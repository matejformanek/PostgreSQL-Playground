-- Combines to options to give us all data
CREATE OR REPLACE FUNCTION get_dealer_stats_json(datum IN DATE = CURRENT_DATE, id_dealer IN INTEGER = NULL)
    RETURNS JSON
    LANGUAGE plpgsql
AS
$$
DECLARE
    dealer_data      JSON := get_dealer_avg_json(datum, id_dealer);
    dealer_drug_data JSON := get_dealer_drug_avg_json(datum, id_dealer);
BEGIN
    RETURN JSON_BUILD_OBJECT(
            'dealers', (SELECT JSON_AGG(
                                       JSON_BUILD_OBJECT(
                                               'street_name', d1 ->> 'street_name',
                                               'amount_bought', d1 ->> 'am_bought',
                                               'amount_payed', d1 ->> 'am_payed',
                                               'amount_sold', d1 ->> 'am_sold',
                                               'amount_gained', d1 ->> 'am_gained',
                                               'debt', d1 ->> 'debt',
                                               'profit', d1 ->> 'profit',
                                               'data', (SELECT JSON_AGG(
                                                                       JSON_BUILD_OBJECT(
                                                                               'drug_name', d2 ->> 'name',
                                                                               'amount_bought', d2 ->> 'am_bought',
                                                                               'amount_payed', d2 ->> 'am_payed',
                                                                               'amount_sold', d2 ->> 'am_sold',
                                                                               'amount_gained', d2 ->> 'am_gained',
                                                                               'debt', d2 ->> 'debt',
                                                                               'profit', d2 ->> 'profit'
                                                                       )
                                                               )
                                                        FROM JSON_ARRAY_ELEMENTS(dealer_drug_data) d2
                                                        WHERE d1 ->> 'street_name' = d2 ->> 'street_name')
                                       ))
                        FROM JSON_ARRAY_ELEMENTS(dealer_data) d1));
END;
$$;