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