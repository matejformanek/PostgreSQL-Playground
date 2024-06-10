CREATE OR REPLACE PROCEDURE copy_invoices(bought_path IN VARCHAR, sold_path IN VARCHAR)
    LANGUAGE plpgsql
AS
$$
BEGIN
    EXECUTE FORMAT(
            'COPY stage_bought (date_bought, drug_name, dealer_name, amount_bought) FROM %L DELIMITER '','' CSV HEADER',
            bought_path);

    EXECUTE FORMAT(
            'COPY stage_sold (date_sold, drug_name, dealer_name, teritorium_city, teritorium_district, amount_sold, price) FROM %L DELIMITER '','' CSV HEADER',
            sold_path);
END;
$$;