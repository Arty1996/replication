-- Table: "Replication"."20190603"

-- DROP TABLE "Replication"."20190603";

CREATE TABLE "Replication"."20190603"
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

ALTER TABLE "Replication"."20190603"
    OWNER to postgres;

-- Далее импортируем данные из файла

--\copy "Replication"."20190603" FROM 'C:\Users\taras_000\Desktop\Вышка\Репликация\se\OrderLog20190603.txt' DELIMITER ',' CSV HEADER;
-- Почему-то эта команда не работает, поэтому пришлось импортировать вручную

-- Удаляем лишние данные и добавляем дату

DELETE FROM "Replication"."20190603"
WHERE "SECCODE" NOT IN ('AFKS', 'AFLT', 'ALRS', 'CBOM', 'CHMF', 'DSKY', 'FEES', 'FIVE', 'GAZP', 'GMKN', 'HYDR', 'IRAO', 'LKOH', 'LNTA', 'MAGN', ' MGNT', 'MOEX', 'MTSS', 'MVID', 'NLMK', 'NVTK', 'PHOR', 'PIKK', 'PLZL', 'POLY', 'RNFT', 'ROSN', 'RTKM', 'RUAL', 'SBER', 'SBERP', 'SFIN', 'SNGS', 'SNGSP', 'TATN', 'TATNP', 'TRMK', 'TRNFP', 'UPRO', 'VTBR', 'YNDX');

ALTER TABLE "Replication"."20190603" ADD "DATE" date;

UPDATE "Replication"."20190603"
SET "DATE"='2019-06-03';

ALTER TABLE "Replication"."20190603" DROP "ORDERNO", DROP "TRADENO", DROP "TRADEPRICE";

-- Такой же шаблон используем для остальных дней

-- Теперь создаём общую таблицу для всех дней

-- Table: "Replication"."June2019"

-- DROP TABLE "Replication"."June2019";

CREATE TABLE "Replication"."June2019"
(
    "NO" bigint NOT NULL,
    "SECCODE" text COLLATE pg_catalog."default" NOT NULL,
    "BUYSELL" text COLLATE pg_catalog."default" NOT NULL,
    "TIME" bigint NOT NULL,
    "ACTION" smallint NOT NULL,
    "PRICE" real NOT NULL,
    "VOLUME" bigint NOT NULL,
    "DATE" date NOT NULL,
    CONSTRAINT "June2019_pkey" PRIMARY KEY ("NO", "DATE")
)

TABLESPACE pg_default;

ALTER TABLE "Replication"."June2019"
    OWNER to postgres;

-- Копируем в неё данные из всех остальный таблиц

INSERT INTO "Replication"."June2019" SELECT * FROM "Replication"."20190603"

-- Повсторяем это действие для каждой из 19 таблиц
-- В итоге получаем одну таблицу со всеми необходимыми данными