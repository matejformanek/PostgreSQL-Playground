-- Remove conflicting tables
DROP TABLE IF EXISTS bought CASCADE;
DROP TABLE IF EXISTS stage_bought CASCADE;
DROP TABLE IF EXISTS dealer CASCADE;
DROP TABLE IF EXISTS drug CASCADE;
DROP TABLE IF EXISTS sold CASCADE;
DROP TABLE IF EXISTS stage_sold CASCADE;
DROP TABLE IF EXISTS teritorium CASCADE;

DROP MATERIALIZED VIEW IF EXISTS stats_dealers CASCADE;
DROP TYPE IF EXISTS PAIR_TYPE;
DROP FUNCTION IF EXISTS trigger_stage_bought() CASCADE;
DROP FUNCTION IF EXISTS trigger_stage_sold() CASCADE;
DROP FUNCTION IF EXISTS get_dealer_stats_json(datum DATE, id_dealer INTEGER) CASCADE;
DROP FUNCTION IF EXISTS get_dealer_drug_avg_json(datum DATE, id_dealer INTEGER) CASCADE;
DROP FUNCTION IF EXISTS get_dealer_avg_json(datum DATE, id_dealer INTEGER) CASCADE;
DROP FUNCTION IF EXISTS get_teritory_stats_md(datum DATE, id_dealer INTEGER) CASCADE;
DROP FUNCTION IF EXISTS get_tables_xml(pairs PAIR_TYPE[]);
-- End of removing

CREATE TYPE PAIR_TYPE AS
(
    table_name TEXT,
    id_table   INT
);

CREATE TABLE stage_bought
(
    date_bought   DATE         NOT NULL,
    drug_name     VARCHAR(256) NOT NULL,
    dealer_name   VARCHAR(256) NOT NULL,
    amount_bought BIGINT       NOT NULL,
    dealer_id     INTEGER,
    drug_id       INTEGER
);

CREATE TABLE bought
(
    date_bought   DATE    NOT NULL,
    dealer_id     INTEGER NOT NULL,
    drug_id       INTEGER NOT NULL,
    amount_bought BIGINT  NOT NULL
);
ALTER TABLE bought
    ADD CONSTRAINT pk_bought PRIMARY KEY (date_bought, dealer_id, drug_id);

CREATE TABLE dealer
(
    dealer_id    SERIAL       NOT NULL,
    street_name  VARCHAR(256) NOT NULL,
    release_date DATE
);
ALTER TABLE dealer
    ADD CONSTRAINT pk_dealer PRIMARY KEY (dealer_id);

CREATE TABLE drug
(
    drug_id     SERIAL       NOT NULL,
    name        VARCHAR(256) NOT NULL,
    stock_price INTEGER      NOT NULL
);
ALTER TABLE drug
    ADD CONSTRAINT pk_drug PRIMARY KEY (drug_id);

CREATE TABLE stage_sold
(
    date_sold           DATE         NOT NULL,
    drug_name           VARCHAR(256) NOT NULL,
    dealer_name         VARCHAR(256) NOT NULL,
    teritorium_city     VARCHAR(256) NOT NULL,
    teritorium_district VARCHAR(256) NOT NULL,
    amount_sold         BIGINT       NOT NULL,
    price               BIGINT       NOT NULL,
    teritorium_id       INTEGER,
    drug_id             INTEGER,
    dealer_id           INTEGER
);

CREATE TABLE sold
(
    date_sold     DATE    NOT NULL,
    drug_id       INTEGER NOT NULL,
    dealer_id     INTEGER NOT NULL,
    teritorium_id INTEGER NOT NULL,
    amount_sold   BIGINT  NOT NULL,
    price         BIGINT  NOT NULL
);
ALTER TABLE sold
    ADD CONSTRAINT pk_sold PRIMARY KEY (date_sold, drug_id, dealer_id);

CREATE TABLE teritorium
(
    teritorium_id SERIAL       NOT NULL,
    dealer_id     INTEGER,
    city          VARCHAR(256) NOT NULL,
    district      VARCHAR(256) NOT NULL
);
ALTER TABLE teritorium
    ADD CONSTRAINT pk_teritorium PRIMARY KEY (teritorium_id);

ALTER TABLE bought
    ADD CONSTRAINT fk_bought_dealer FOREIGN KEY (dealer_id) REFERENCES dealer (dealer_id) ON DELETE CASCADE;
ALTER TABLE bought
    ADD CONSTRAINT fk_bought_drug FOREIGN KEY (drug_id) REFERENCES drug (drug_id) ON DELETE CASCADE;

ALTER TABLE sold
    ADD CONSTRAINT fk_sold_drug FOREIGN KEY (drug_id) REFERENCES drug (drug_id) ON DELETE CASCADE;
ALTER TABLE sold
    ADD CONSTRAINT fk_sold_dealer FOREIGN KEY (dealer_id) REFERENCES dealer (dealer_id) ON DELETE CASCADE;
ALTER TABLE sold
    ADD CONSTRAINT fk_sold_teritorium FOREIGN KEY (teritorium_id) REFERENCES teritorium (teritorium_id) ON DELETE CASCADE;

ALTER TABLE teritorium
    ADD CONSTRAINT fk_teritorium_dealer FOREIGN KEY (dealer_id) REFERENCES dealer (dealer_id) ON DELETE CASCADE;