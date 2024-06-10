-- Would be called by trigger at the end of the month when new invoices come
-- -> updates MV with stats about how the dealers are doing from the beginning of them coming to job
-- Now simulated when new copy comes the trigger updates it
CREATE OR REPLACE PROCEDURE update_dealers_mv_stats(new_date IN DATE)
    LANGUAGE plpgsql
AS
$$
BEGIN
    DROP MATERIALIZED VIEW IF EXISTS stats_dealers CASCADE;

--     MV cannot be created with params but it can be bypassed with dynamic SQL
    EXECUTE FORMAT('
    CREATE MATERIALIZED VIEW stats_dealers AS
    SELECT bought.dealer_id,
           bought.drug_id,
           SUM(amount_bought)                                    AS am_bought,
           SUM(stock_price * amount_bought)                      AS am_payed,
           MIN(amv.am_sold)                                      AS am_sold,
           MIN(amv.am_gained)                                    AS am_gained,
           SUM(amount_bought) - COALESCE(MIN(amv.am_sold), 0)    AS debt,
           MIN(amv.am_gained) - SUM(stock_price * amount_bought) AS profit
    FROM bought
             JOIN public.dealer USING (dealer_id)
             JOIN drug USING (drug_id)
             LEFT JOIN (SELECT dealer_id,
                               drug_id,
                               SUM(amount_sold) AS am_sold,
                               SUM(price)       AS am_gained
                        FROM public.dealer
                                 JOIN public.sold USING (dealer_id)
                        WHERE date_sold <= %L
                        GROUP BY dealer_id, drug_id) AS amv
                       USING (dealer_id, drug_id)
    WHERE date_bought <= %L
    GROUP BY bought.dealer_id, bought.drug_id
    ORDER BY dealer_id, drug_id', new_date, new_date - INTERVAL '1 month');

    REFRESH MATERIALIZED VIEW stats_dealers;
END;
$$;