-- 1 процедура закрепления устройства за рабочим местом с проверкой типа
CREATE OR REPLACE PROCEDURE zakreplenie_ustroistva(
    p_unical_nomer VARCHAR,
    p_id_mesta INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_tipa INT;
    v_nazvanie_tipa VARCHAR(100);
    v_zanyato_unical_nomer VARCHAR(50);
BEGIN
    -- проверка существования рабочего места
    IF NOT EXISTS (SELECT 1 FROM "rabochie_mesta" WHERE id_mesta = p_id_mesta) THEN
        RAISE EXCEPTION 'Ошибка: Рабочее место с ID % не найдено.', p_id_mesta;
    END IF;

    -- получение id типа и названия устройства (join для получения типа)
    SELECT o.id_tipa, t.naimenovanie INTO v_id_tipa, v_nazvanie_tipa
    FROM "oborudovanie" o
    JOIN "tip" t ON o.id_tipa = t.id_tipa
    WHERE o.unical_nomer = p_unical_nomer;

    -- проверка существования устройства
    IF v_id_tipa IS NULL THEN
        RAISE EXCEPTION 'Устройство с номером % не найдено.', p_unical_nomer;
    END IF;
    
    -- проверка существования на этом рабочем месте устройство с таким же id типа
    SELECT unical_nomer INTO v_zanyato_unical_nomer
    FROM "oborudovanie"
    WHERE id_mesta = p_id_mesta 
      AND id_tipa = v_id_tipa
      AND unical_nomer <> p_unical_nomer
    LIMIT 1;

    IF v_zanyato_unical_nomer IS NOT NULL THEN
        RAISE EXCEPTION 'Рабочее место % уже занято устройством того же типа ("%"). Занято устройством %', 
            p_id_mesta, v_nazvanie_tipa, v_zanyato_unical_nomer;
    END IF;
    
    -- закрепление устройства
    UPDATE "oborudovanie"
    SET id_mesta = p_id_mesta
    WHERE unical_nomer = p_unical_nomer;
    
    -- уведомление
    RAISE NOTICE 'Устройство % (%) закреплено за рабочим местом %.', 
        p_unical_nomer, v_nazvanie_tipa, p_id_mesta;

END;
$$;

-- проверка первая
CALL zakreplenie_ustroistva('PC-RS-006', 10);
--проверка вторая
CALL zakreplenie_ustroistva('PC-RS-006', 26);

-- 2 процедура списания оборудования: перемещение в таблицу "списанное_оборудование"
CREATE OR REPLACE PROCEDURE spisanie_oborudovaniya(
    p_unical_nomer VARCHAR,
    p_prichina_spisaniya TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_tipa INT;
    v_god_vipuska INT;
    v_nazvanie_tipa VARCHAR(100);
    v_id_mesta INT;
BEGIN

    -- получение данных для проверки и списания
    SELECT 
        o.id_tipa, 
        o.god_vipuska, 
        t.naimenovanie,
        o.id_mesta
    INTO 
        v_id_tipa, 
        v_god_vipuska, 
        v_nazvanie_tipa,
        v_id_mesta
    FROM 
        "oborudovanie" o
    JOIN 
        "tip" t ON o.id_tipa = t.id_tipa
    WHERE 
        o.unical_nomer = p_unical_nomer;

    -- проверка существования устройства
    IF v_id_tipa IS NULL THEN
        RAISE EXCEPTION 'Устройство с номером % не найдено.', p_unical_nomer;
    END IF;

    -- перемещение данных в таблицу списанное_оборудование
    INSERT INTO "spisannoe_oborudovanie" (
        unical_nomer, 
        tip,
        god_vipuska, 
        data_spisania,
        prichina
    )
    VALUES (
        p_unical_nomer, 
        v_nazvanie_tipa,
        v_god_vipuska,
        NOW()::date,
        p_prichina_spisaniya
    );

    -- удаление устройства из таблицы оборудования
    DELETE FROM "oborudovanie"
    WHERE unical_nomer = p_unical_nomer;

    RAISE NOTICE 'Устройство % (Тип: %) списано. Причина: %',
        p_unical_nomer, v_nazvanie_tipa, p_prichina_spisaniya;

END;
$$;

-- проверка
CALL spisanie_oborudovaniya(
    p_unical_nomer := 'PC-RS-001',
    p_prichina_spisaniya := 'Не подлежит ремонту.'
);

-- 3 процедура формирования инвентарной ведомости по кабинету
CREATE OR REPLACE PROCEDURE invent_vedomost(
  p_id_kabineta INT)
LANGUAGE plpgsql
AS $$
BEGIN
  -- удаление
  DROP TABLE IF EXISTS "temp_invent";
  
    -- cоздание временной таблицы (TEMPORARY удаление после завершения)
    CREATE TEMPORARY TABLE "temp_invent" (
        id_mesta INT,
        unical_nomer VARCHAR(50),
        tip VARCHAR(100),
        god_vipuska INT
    );
    
    -- заполнение временной таблицы
    INSERT INTO "temp_invent" (
        id_mesta, unical_nomer, tip, god_vipuska
    )
    SELECT 
        rm.id_mesta,
        o.unical_nomer, 
        t.naimenovanie,
        o.god_vipuska
    FROM 
        "rabochie_mesta" rm
    JOIN 
        "oborudovanie" o ON rm.id_mesta = o.id_mesta
    JOIN 
        "tip" t ON o.id_tipa = t.id_tipa
    WHERE 
        rm.id_cabineta = p_id_kabineta;
END;
$$;

-- проверка 
CALL invent_vedomost(p_id_kabineta := 8);
SELECT * FROM "temp_invent";