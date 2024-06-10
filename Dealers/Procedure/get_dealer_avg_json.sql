-- Returns average of sales, profit, etc...
-- JSON[] each row is 1 dealer and his stats
CREATE OR REPLACE FUNCTION get_dealer_avg_json(datum IN DATE = CURRENT_DATE, id_dealer IN INTEGER = NULL)
    RETURNS JSON
    LANGUAGE plpgsql
AS
$$
DECLARE
    person_data JSON[];
BEGIN
    SELECT ARRAY(
                   SELECT JSON_BUILD_OBJECT('street_name', street_name,
                                            'am_bought', COALESCE(SUM(am_bought), 0),
                                            'am_payed', COALESCE(SUM(am_payed), 0),
                                            'am_sold', COALESCE(SUM(am_sold), 0),
                                            'am_gained', COALESCE(SUM(am_gained), 0),
                                            'debt', COALESCE(SUM(debt), 0),
                                            'profit', COALESCE(SUM(profit), 0))
                   FROM (SELECT bought.dealer_id,
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
                                             WHERE date_sold <= datum
                                             GROUP BY dealer_id, drug_id) AS amv
                                            USING (dealer_id, drug_id)
                         WHERE date_bought <= datum - INTERVAL '1 month'
                         GROUP BY bought.dealer_id, bought.drug_id
                         ORDER BY dealer_id, drug_id) AS dl
                            RIGHT JOIN dealer USING (dealer_id)
                   WHERE id_dealer IS NULL
                      OR id_dealer = dealer_id
                   GROUP BY street_name
                   ORDER BY street_name)
    INTO person_data;

    RETURN (SELECT JSON_AGG(dat)
            FROM UNNEST(person_data) AS dat);
END;
$$;
