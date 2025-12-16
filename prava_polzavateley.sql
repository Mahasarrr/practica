-- 1 роль it_specialist - права на INSERT, UPDATE, DELETE таблиц оборудования и рабочих мест.
CREATE ROLE it_specialist; 
GRANT INSERT, UPDATE, DELETE ON "oborudovanie" TO it_specialist;
GRANT INSERT, UPDATE, DELETE ON "rabochie_mesta" TO it_specialist;

-- 2 роль employee - только SELECT своих рабочих мест и устройств.
CREATE ROLE employee; 
GRANT SELECT ON "oborudovanie", "rabochie_mesta" TO employee;

-- ограничение для таблицы рабочих мест
ALTER TABLE "rabochie_mesta" ENABLE ROW LEVEL SECURITY;

CREATE POLICY employee_own_mesta ON "rabochie_mesta"
    FOR SELECT
    TO employee
    USING (
        -- id сотрудника должен совпадать с именем пользователя, приведенным к числу.
        id_sotrudnika = CAST(current_user AS VARCHAR)::INT
    );
    
-- ограничение для таблицы оборудования
ALTER TABLE "oborudovanie" ENABLE ROW LEVEL SECURITY;

CREATE POLICY employee_own_oborudovanie ON "oborudovanie"
    FOR SELECT
    TO employee
    USING (
        -- оборудование видно, если его рабочее место закреплено за текущим сотрудником
        id_mesta IN (
            SELECT id_mesta 
            FROM "rabochie_mesta" 
            WHERE id_sotrudnika = CAST(current_user AS VARCHAR)::INT
        )
    );

-- 3 роль auditor_equipment - SELECT всех таблиц, но без изменения.
CREATE ROLE auditor_equipment; 
GRANT SELECT ON "oborudovanie", "rabochie_mesta", "peremesheniya", "cabinets", "pol", "sotrudniki", "spisannoe_oborudovanie", "tip" TO auditor_equipment;