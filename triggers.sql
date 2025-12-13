--1 триггер на добавление устройства: проверять уникальность номера
CREATE OR REPLACE FUNCTION check_unique_unical_nomer()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM "oborudovanie"
        WHERE unical_nomer = NEW.unical_nomer
    ) THEN
        RAISE EXCEPTION 'Ошибка: Номер %s уже существует в базе данных.', NEW.unical_nomer;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER enforce_unique_unical_nomer
BEFORE INSERT ON "oborudovanie"
FOR EACH ROW
EXECUTE FUNCTION check_unique_unical_nomer();

--2 Триггер на удаление рабочего места: автоматически освобождать устройства
CREATE OR REPLACE FUNCTION udalenie_mesta()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE "oborudovanie"
    SET id_mesta = NULL
    WHERE id_mesta = OLD.id_mesta;
    
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER free_equipment_trigger
AFTER DELETE ON "rabochie_mesta" 
FOR EACH ROW 
EXECUTE FUNCTION udalenie_mesta();

--3 Триггер на обновление закрепления устройства
CREATE OR REPLACE FUNCTION obnovlenie_peremesheniya()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.id_mesta IS DISTINCT FROM NEW.id_mesta THEN
        INSERT INTO "peremesheniya" (
            unical_nomer,
            id_mesta_staroe,
            id_mesta_novoe
        ) VALUES (
            NEW.unical_nomer,
            OLD.id_mesta,
            NEW.id_mesta
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER obnovlenie_peremesheniya_trigger
BEFORE UPDATE ON "oborudovanie"
FOR EACH ROW
EXECUTE FUNCTION obnovlenie_peremesheniya();