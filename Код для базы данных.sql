-- В PostreSQL создаём таблицу с данными для 03.06.2019

-- Table: "replication"."20190603"

-- DROP TABLE "replication"."20190603";

CREATE TABLE "replication"."20190603"
(
    "NO" bigint NOT NULL,
    "SECCODE" text COLLATE pg_catalog."default" NOT NULL,
    "BUYSELL" text COLLATE pg_catalog."default" NOT NULL,
    "TIME" bigint NOT NULL,
    "ORDERNO" bigint NOT NULL,
    "ACTION" smallint NOT NULL,
    "PRICE" real NOT NULL,
    "VOLUME" bigint NOT NULL,
    "TRADENO" bigint,
    "TRADEPRICE" real,
    CONSTRAINT "20190603_pkey" PRIMARY KEY ("NO")
)

TABLESPACE pg_default;

ALTER TABLE "replication"."20190603"
    OWNER to postgres;

-- Далее импортируем данные из файла OrderLog20190603.txt с параметрами DELIMITER ',' CSV HEADER

-- Удаляем лишние данные и добавляем дату
-- В связи с тем, что объём данных слишком большой, оставим только 11 тикеров, чьи средние объёмы по торгам превысили 1 млрд руб.

ALTER TABLE "replication"."20190603" DROP "TRADENO", DROP "TRADEPRICE";

DELETE FROM "replication"."20190603"
WHERE "SECCODE" NOT IN ('ALRS', 'GAZP', 'GMKN', 'IRAO', 'LKOH', ' MGNT', 'ROSN', 'SBER', 'SBERP', 'TATN', 'VTBR');

ALTER TABLE "replication"."20190603" ADD "DATE" date;

UPDATE "replication"."20190603"
SET "DATE"='2019-06-03';

-- Такой же скрипт используем для остальных дней

-- Теперь создаём общую таблицу для всех дней

-- Table: "replication"."june2019"

-- DROP TABLE "replication"."june2019";

CREATE TABLE "replication"."june2019"
(
    "NO" bigint NOT NULL,
    "SECCODE" text COLLATE pg_catalog."default" NOT NULL,
    "BUYSELL" text COLLATE pg_catalog."default" NOT NULL,
    "TIME" bigint NOT NULL,
    "ORDERNO" bigint NOT NULL,
    "ACTION" smallint NOT NULL,
    "PRICE" real NOT NULL,
    "VOLUME" bigint NOT NULL,
    "DATE" date NOT NULL,
    CONSTRAINT "june2019_pkey" PRIMARY KEY ("NO", "DATE")
)

TABLESPACE pg_default;

ALTER TABLE "replication"."june2019"
    OWNER to postgres;

-- Копируем в неё данные из всех остальный таблиц

INSERT INTO "replication"."june2019" SELECT * FROM "replication"."20190603"

-- Повторяем это действие для каждой из 19 таблиц
-- В итоге получаем одну таблицу со всеми необходимыми данными
