INSERT INTO drug (name, stock_price)
VALUES ('Cocaine', 10),
       ('Heroin', 8),
       ('Marijuana', 5),
       ('LSD', 3),
       ('MDMA (Ecstasy)', 2),
       ('Methamphetamine', 7),
       ('Crack Cocaine', 12),
       ('PCP (Angel Dust)', 6),
       ('Ketamine', 4),
       ('Psilocybin Mushrooms', 15);

INSERT INTO dealer (street_name, release_date)
VALUES ('El Chapo', NULL),
       ('Pablo Escobar', NULL),
       ('Griselda Blanco', NULL),
       ('Freeway Ricky Ross', NULL),
       ('Frank Lucas', NULL),
       ('George Jung Beach', NULL),
       ('Carlos Lehder', NULL),
       ('Felix Mitchell', NULL),
       ('Nicky Barnes', CURRENT_DATE + INTERVAL '1 year'),
       ('Miguel Angel', CURRENT_DATE + INTERVAL '1 year');

-- For dealer_id = 1
INSERT INTO teritorium (dealer_id, city, district)
VALUES (1, 'Culiacán', 'Centro'),
       (1, 'Culiacán', 'Tres Ríos'),
       (1, 'Culiacán', 'Las Quintas'),
       (1, 'Culiacán', 'Los Pinos'),
       (1, 'Culiacán', 'Infonavit Barrancos'),
       (1, 'Culiacán', 'Jardines del Humaya');

-- For dealer_id = 2
INSERT INTO teritorium (dealer_id, city, district)
VALUES (2, 'Medellín', 'El Poblado'),
       (2, 'Medellín', 'La Candelaria'),
       (2, 'Medellín', 'Buenos Aires'),
       (2, 'Medellín', 'La América'),
       (2, 'Medellín', 'Manrique'),
       (2, 'Medellín', 'Robledo'),
       (2, 'Medellín', 'Santa Cruz');

-- For dealer_id = 3
INSERT INTO teritorium (dealer_id, city, district)
VALUES (3, 'Guadalajara', 'Zona Centro'),
       (3, 'Guadalajara', 'Chapalita'),
       (3, 'Guadalajara', 'Providencia'),
       (3, 'Guadalajara', 'Americana'),
       (3, 'Guadalajara', 'Ladrón de Guevara'),
       (3, 'Guadalajara', 'Colinas de San Javier');

-- For dealer_id = 4
INSERT INTO teritorium (dealer_id, city, district)
VALUES (4, 'Cabo San Lucas', 'Centro'),
       (4, 'Cabo San Lucas', 'Marina'),
       (4, 'Cabo San Lucas', 'El Tezal'),
       (4, 'Cabo San Lucas', 'El Medano Ejidal'),
       (4, 'Cabo San Lucas', 'El Médano'),
       (4, 'Cabo San Lucas', 'Residencial El Pedregal');

-- For dealer_id = 5
INSERT INTO teritorium (dealer_id, city, district)
VALUES (5, 'Tijuana', 'Zona Centro'),
       (5, 'Tijuana', 'Zona Norte'),
       (5, 'Tijuana', 'Playas de Tijuana'),
       (5, 'Tijuana', 'Zona Rio'),
       (5, 'Tijuana', 'La Mesa'),
       (5, 'Tijuana', 'Otay Constituyentes'),
       (5, 'Tijuana', 'San Antonio del Mar');

-- For dealer_id = 6
INSERT INTO teritorium (dealer_id, city, district)
VALUES (6, 'Juárez', 'Centro'),
       (6, 'Juárez', 'Riberas del Bravo'),
       (6, 'Juárez', 'Lomas del Rey'),
       (6, 'Juárez', 'Anapra'),
       (6, 'Juárez', 'Riberas de Sacramento'),
       (6, 'Juárez', 'San Agustín'),
       (6, 'Juárez', 'Vista Hermosa');

-- For dealer_id = 7
INSERT INTO teritorium (dealer_id, city, district)
VALUES (7, 'Oaxaca de Juárez', 'Centro'),
       (7, 'Oaxaca de Juárez', 'Reforma'),
       (7, 'Oaxaca de Juárez', 'La Noria'),
       (7, 'Oaxaca de Juárez', 'Volcanes'),
       (7, 'Oaxaca de Juárez', 'Santa Rosa'),
       (7, 'Oaxaca de Juárez', 'Guadalupe Victoria'),
       (7, 'Oaxaca de Juárez', 'Trinidad de Viguera');

-- For dealer_id = 8
INSERT INTO teritorium (dealer_id, city, district)
VALUES (8, 'Cancún', 'Zona Hotelera'),
       (8, 'Cancún', 'Centro'),
       (8, 'Cancún', 'Supermanzana 23'),
       (8, 'Cancún', 'Playa Tortugas'),
       (8, 'Cancún', 'Residencial Cumbres'),
       (8, 'Cancún', 'Región 513'),
       (8, 'Cancún', 'Riviera Cancún');

-- For dealer_id = 9
INSERT INTO teritorium (dealer_id, city, district)
VALUES (9, 'Acapulco', 'Zona Dorada'),
       (9, 'Acapulco', 'Centro'),
       (9, 'Acapulco', 'La Costera'),
       (9, 'Acapulco', 'Diamante'),
       (9, 'Acapulco', 'Las Playas'),
       (9, 'Acapulco', 'Alfredo V. Bonfil'),
       (9, 'Acapulco', 'Rincón de las Brisas');

-- For dealer_id = 10
INSERT INTO teritorium (dealer_id, city, district)
VALUES (10, 'Tepito', 'Zona Centro'),
       (10, 'Tepito', 'Morelos'),
       (10, 'Tepito', 'Lagunilla'),
       (10, 'Tepito', 'Jardín Balbuena'),
       (10, 'Tepito', 'Buenavista'),
       (10, 'Tepito', 'Guerrero'),
       (10, 'Tepito', 'Santa María la Ribera');

-- Inserts boughts for all dealers in 2023-01-01 to 2024-02-01 span.
DO
$$
    DECLARE
        date_insert DATE := '2023-01-01';
        id_drug     RECORD;
    BEGIN
        FOR i IN 1..14 -- cycle months
            LOOP
                FOR id_dealer IN 1..9 -- cycle dealers
                    LOOP
                        IF (i > 10 AND id_dealer = 9) OR FLOOR(RANDOM() * 10) + 1 = 5 THEN -- simulate not buying
                            CONTINUE;
                        END IF;
                        FOR id_drug IN (SELECT drug.drug_id FROM drug ORDER BY RANDOM() LIMIT FLOOR(RANDOM() * 7) + 1)
                            LOOP
                                INSERT INTO bought (date_bought, dealer_id, drug_id, amount_bought)
                                VALUES (date_insert, id_dealer, id_drug.drug_id, FLOOR(RANDOM() * 341) + 10);
                            END LOOP;
                    END LOOP;

                date_insert := date_insert + INTERVAL '1 month';
            END LOOP;
    END;
$$;

-- Inserts solds for all dealers in 2023-02-01 to 2024-03-01 span.
DO
$$
    DECLARE
        date_insert   DATE := '2023-02-01';
        bought_stats CURSOR (datum DATE) FOR (SELECT bought.dealer_id,
                                                     bought.drug_id,
                                                     SUM(amount_bought) - COALESCE(MIN(amv.am_sold), 0) AS debt
                                              FROM bought
                                                       JOIN public.dealer USING (dealer_id)
                                                       JOIN drug USING (drug_id)
                                                       LEFT JOIN (SELECT dealer_id,
                                                                         drug_id,
                                                                         SUM(amount_sold) AS am_sold
                                                                  FROM public.dealer
                                                                           JOIN public.sold USING (dealer_id)
                                                                  WHERE date_sold < datum
                                                                  GROUP BY dealer_id, drug_id) AS amv
                                                                 USING (dealer_id, drug_id)
                                              WHERE date_bought < datum
                                              GROUP BY bought.dealer_id, bought.drug_id);
        rec           RECORD;
        id_teritorium INTEGER;
    BEGIN
        FOR i IN 1..14 -- cycle months
            LOOP
                FOR rec IN bought_stats(date_insert)
                    LOOP
                        IF rec.debt <= 0 THEN -- nothing to be sold
                            CONTINUE;
                        END IF;

                        SELECT teritorium_id
                        INTO id_teritorium -- choose random territorium
                        FROM teritorium
                        WHERE dealer_id = rec.dealer_id
                        ORDER BY RANDOM()
                        LIMIT 1;

                        IF FLOOR(RANDOM() * 4) + 1 = 2 THEN -- 25% chance (not even) he will sell in concurent teritory
                            id_teritorium := FLOOR(RANDOM() * 67) + 1;
                        END IF;

                        -- 75% chance they wont have debts
                        IF FLOOR(RANDOM() * 4) + 1 <> 1 OR rec.debt < 10 THEN
                            INSERT INTO sold (date_sold, drug_id, dealer_id, teritorium_id, amount_sold, price)
                            VALUES (date_insert, rec.drug_id, rec.dealer_id, id_teritorium, rec.debt,
                                    (SELECT ROUND(drug.stock_price * rec.debt * (0.6 + RANDOM() * (1.5 - 0.6)))
                                     FROM drug
                                     WHERE drug.drug_id = rec.drug_id));
                        ELSE
                            INSERT INTO sold (date_sold, drug_id, dealer_id, teritorium_id, amount_sold, price)
                            VALUES (date_insert, rec.drug_id, rec.dealer_id, id_teritorium, FLOOR(rec.debt / 2),
                                    (SELECT ROUND(drug.stock_price * FLOOR(rec.debt / 2) * (0.6 + RANDOM() * (1.5 - 0.6)))
                                     FROM drug
                                     WHERE drug.drug_id = rec.drug_id));
                        END IF;
                    END LOOP;
                date_insert := date_insert + INTERVAL '1 month';
            END LOOP;
    END;
$$;

-- Would be called by trigger at the end of the month when new invoices come
-- -> updates MV with stats about how the dealers are doing from the beginning of them coming to job
-- Now simulated when new copy comes the trigger updates it
CREATE OR REPLACE PROCEDURE update_dealers_mv_stats(new_date IN DATE)
    LANGUAGE plpgsql
AS
$$
BEGIN
    DROP MATERIALIZED VIEW IF EXISTS stats_dealers CASCADE;

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

CALL update_dealers_mv_stats(CURRENT_DATE);

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

    CALL update_dealers_mv_stats(CURRENT_DATE);

    RETURN NULL;
END;
$$;

CREATE OR REPLACE TRIGGER import_sold
    AFTER INSERT
    ON stage_sold
    FOR EACH STATEMENT
EXECUTE FUNCTION trigger_stage_sold();

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

-- Returns average of sales, profit, etc... but for each pair of dealer and drug
-- JSON[] each row is 1 dealer but multiple objects inside
CREATE OR REPLACE FUNCTION get_dealer_drug_avg_json(datum IN DATE = CURRENT_DATE, id_dealer IN INTEGER = NULL)
    RETURNS JSON
    LANGUAGE plpgsql
AS
$$
DECLARE
    data JSON[];
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

-- Creates MD file that can be put straight to web with stats about teritories
CREATE OR REPLACE FUNCTION get_teritory_stats_md(datum IN DATE = CURRENT_DATE, id_dealer IN INTEGER = NULL)
    RETURNS TEXT
    LANGUAGE plpgsql
AS
$$
DECLARE
    result TEXT    := '# Statistiky teritorii

Prehled jednotlivych teritorii se statistikami ohledne jejich celkoveho prodeje. Komu patri a na jake districty se deli.
Kolik zde bylo prodano drog. Kolik zde bylo prodano konkurencnimi dealery.

';
    ter    RECORD;
    tab    RECORD;
    deal   RECORD;
    cnt    INTEGER := 1;
    cnt2   INTEGER;
BEGIN
    FOR ter IN (SELECT DISTINCT city, dealer.dealer_id, street_name
                FROM teritorium
                         JOIN public.dealer ON dealer.dealer_id = teritorium.dealer_id
                WHERE id_dealer IS NULL
                   OR id_dealer = dealer.dealer_id
                ORDER BY dealer_id)
        LOOP
            result := result || '## ' || cnt || ') ' || ter.city || '

### ' || cnt || '.1) Celkove vysledky

**Spravuje: ' || ter.street_name || '**

| District                | Prodano spravcem | Prodano konkurenci | Prodano celkem |
|-------------------------|------------------|--------------------|----------------|
';

            -- Fills the whole table with 1 select
            FOR tab IN (SELECT t2.city,
                               t2.district,
                               SUM(COALESCE(am_sold, 0))                            AS am_sold,
                               SUM(COALESCE(am_sold_con, 0))                        AS am_sold_con,
                               SUM(COALESCE(am_sold, 0) + COALESCE(am_sold_con, 0)) AS am_sum
                        FROM (SELECT city,
                                     district,
                                     SUM(CASE WHEN d.dealer_id = sold.dealer_id THEN amount_sold ELSE 0 END)  AS am_sold,
                                     SUM(CASE WHEN d.dealer_id <> sold.dealer_id THEN amount_sold ELSE 0 END) AS am_sold_con
                              FROM teritorium
                                       JOIN public.sold ON teritorium.teritorium_id = sold.teritorium_id
                                       JOIN public.dealer ON dealer.dealer_id = sold.dealer_id
                                       JOIN public.dealer d ON d.dealer_id = teritorium.dealer_id
                              WHERE d.dealer_id = ter.dealer_id
                                AND date_sold < datum
                              GROUP BY city, district) AS ag
                                 RIGHT JOIN teritorium t2 ON t2.district = ag.district
                        WHERE t2.dealer_id = ter.dealer_id
                        GROUP BY ROLLUP (t2.city, t2.district) -- to get sum of all
                        HAVING t2.city IS NOT NULL
                        ORDER BY district)
                LOOP
                    IF tab.district IS NULL THEN
                        result := result || '| **Celkem** | **' || tab.am_sold || '** | **' || tab.am_sold_con ||
                                  '** | **' ||
                                  tab.am_sum || '** |

';
                        CONTINUE;
                    END IF;

                    result := result || '| ' || tab.district || ' | ' || tab.am_sold || ' | ' || tab.am_sold_con ||
                              ' | ' || tab.am_sum || ' |
';
                END LOOP;

--          fills individual results for each dealer in this teritory
            result := result || '### ' || cnt || '.2) Jednotlive vysledkly

';
            cnt2 := 1;
            FOR deal IN (SELECT dealer.street_name, SUM(amount_sold) AS am_sold
                         FROM teritorium
                                  JOIN public.sold ON teritorium.teritorium_id = sold.teritorium_id
                                  JOIN public.dealer ON dealer.dealer_id = sold.dealer_id
                                  JOIN public.dealer d ON d.dealer_id = teritorium.dealer_id
                         WHERE d.dealer_id = ter.dealer_id
                           AND date_sold < datum
                         GROUP BY dealer.street_name, d.street_name, city
                         ORDER BY am_sold DESC)
                LOOP
                    result := result || cnt2 || ') ' || deal.street_name || ' - ' || deal.am_sold || '
';

                    cnt2 := cnt2 + 1;
                END LOOP;
            result := result || '
';

            cnt := cnt + 1;
        END LOOP;


    RETURN result;
END;
$$;

CREATE OR REPLACE FUNCTION get_tables_xml(pairs IN PAIR_TYPE[])
    RETURNS XML
    LANGUAGE plpgsql
AS
$$
DECLARE
    res   XML := '';
    hold  XML;
    id    VARCHAR;
    query TEXT;
    pair  PAIR_TYPE;
BEGIN

    FOREACH pair IN ARRAY pairs
        LOOP
            id := COALESCE(CAST(pair.id_table AS VARCHAR), 'NULL');
            query := 'SELECT * FROM ' || pair.table_name || ' WHERE ' || pair.table_name || '_id = ' || id || ' OR ' ||
                     id || ' ISNULL';
            SELECT XMLCONCAT(XMLCOMMENT('Data for table: ' || pair.table_name || '. And ID = ' ||
                                        CASE WHEN id = 'NULL' THEN 'ALL' ELSE id END),
                             XMLELEMENT(NAME info, XMLATTRIBUTES(pair.table_name || '_table_info' AS
                                        data), -- Data about table
                                        XMLELEMENT(NAME tableName, pair.table_name),
                                        XMLELEMENT(NAME tableCols,
                                                   (SELECT XMLAGG(XMLCONCAT(XMLELEMENT(NAME column, column_name || ' - ' || data_type)))
                                                    FROM information_schema.columns
                                                    WHERE information_schema.columns.table_name = pair.table_name)), -- Table columns and types
                                        (SELECT *
                                         FROM UNNEST(XPATH('/table/row/num_of_rows', -- Number of rows
                                                           QUERY_TO_XML(
                                                                   'SELECT COUNT(*) as num_of_rows FROM ' ||
                                                                   pair.table_name,
                                                                   TRUE, FALSE, ''))))),
                             QUERY_TO_XML(query, TRUE, FALSE, '')) -- Selects all data
            INTO hold;

            EXECUTE FORMAT('SELECT XMLELEMENT(NAME %I, $1)', pair.table_name, hold) USING hold INTO hold; -- adds table tag

            SELECT XMLCONCAT(res, hold) INTO res; -- concats 2 table xmls
        END LOOP;

    SELECT XMLELEMENT(NAME tables, res) INTO res; -- root tag

    RETURN res;
END;
$$;