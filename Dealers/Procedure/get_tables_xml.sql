-- Custom pair type for table_name and desired id (for all NULL)
CREATE TYPE PAIR_TYPE AS
(
    table_name TEXT,
    id_table   INT
);

-- Takes array of pairs and returns xml with data foreach table in one string
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