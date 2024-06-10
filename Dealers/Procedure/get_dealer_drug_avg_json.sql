-- Returns average of sales, profit, etc... but for each pair of dealer and drug
CREATE OR REPLACE FUNCTION get_dealer_drug_avg_json(datum IN DATE = CURRENT_DATE, id_dealer IN INTEGER = NULL)
    RETURNS JSON
    LANGUAGE plpgsql
AS
$$
DECLARE
    data   JSON[];
BEGIN
    SELECT ARRAY(
                   SELECT JSON_BUILD_OBJECT('street_name', street_name,
                                            'name', name,
                                            'am_bought', COALESCE(SUM(amount_bought), 0),
                                            'am_payed', COALESCE(SUM(stock_price * amount_bought), 0),
                                            'am_sold', COALESCE(MIN(amv.am_sold), 0),
                                            'am_gained', COALESCE(MIN(amv.am_gained), 0),
                                            'debt', COALESCE(SUM(amount_bought) - COALESCE(MIN(amv.am_sold), 0), 0),
                                            'profit',
                                            COALESCE(MIN(amv.am_gained) - SUM(stock_price * amount_bought), 0))
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
                     AND (id_dealer IS NULL OR id_dealer = dealer_id)
                   GROUP BY street_name, name)
    INTO data;

    RETURN (SELECT JSON_AGG(dat)
            FROM UNNEST(data) AS dat);
END;
$$;
