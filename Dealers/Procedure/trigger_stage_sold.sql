-- Takes imported rows maps id for the names and saves into real table
CREATE OR REPLACE FUNCTION trigger_stage_sold() RETURNS TRIGGER
    LANGUAGE plpgsql
AS
$$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN (SELECT street_name, dealer_id FROM dealer) -- map dealer ID
        LOOP
            UPDATE stage_sold
            SET dealer_id = rec.dealer_id
            WHERE dealer_name = rec.street_name;
        END LOOP;

    FOR rec IN (SELECT drug.name, drug.drug_id FROM drug) -- map drug ID
        LOOP
            UPDATE stage_sold
            SET drug_id = rec.drug_id
            WHERE drug_name = rec.name;
        END LOOP;

    FOR rec IN (SELECT city, district, teritorium_id FROM teritorium) -- map teritorium ID
        LOOP
            UPDATE stage_sold
            SET teritorium_id = rec.teritorium_id
            WHERE teritorium_district = rec.district
              AND teritorium_city = rec.city;
        END LOOP;

    INSERT INTO sold (date_sold, drug_id, dealer_id, teritorium_id, amount_sold, price)
    SELECT date_sold, drug_id, dealer_id, teritorium_id, amount_sold, price
    FROM stage_sold;

    DELETE FROM stage_sold;

    CALL update_dealers_mv_stats(current_date); -- Update MV

    RETURN NULL;
END;
$$;

CREATE OR REPLACE TRIGGER import_sold
    AFTER INSERT
    ON stage_sold
    FOR EACH STATEMENT
EXECUTE FUNCTION trigger_stage_sold();