-- Takes imported rows maps id for the names and saves into real table
CREATE OR REPLACE FUNCTION trigger_stage_bought() RETURNS TRIGGER
    LANGUAGE plpgsql
AS
$$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN (SELECT street_name, dealer_id FROM dealer) -- map dealer ID
        LOOP
            UPDATE stage_bought
            SET dealer_id = rec.dealer_id
            WHERE dealer_name = rec.street_name;
        END LOOP;

    FOR rec IN (SELECT drug.name, drug.drug_id FROM drug) -- map drug ID
        LOOP
            UPDATE stage_bought
            SET drug_id = rec.drug_id
            WHERE drug_name = rec.name;
        END LOOP;

    INSERT INTO bought (date_bought, dealer_id, drug_id, amount_bought)
    SELECT date_bought, dealer_id, drug_id, amount_bought
    FROM stage_bought;

    DELETE FROM stage_bought;

    RETURN NULL;
END;
$$;

CREATE OR REPLACE TRIGGER import_bought
    AFTER INSERT
    ON stage_bought
    FOR EACH STATEMENT
EXECUTE FUNCTION trigger_stage_bought();