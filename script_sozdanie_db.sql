CREATE TABLE "cabinets" (
  "id_cabineta" serial PRIMARY KEY,
  "number" varchar UNIQUE NOT NULL,
  "korpus" integer NOT NULL,
  "etazh" integer NOT NULL
);

CREATE TABLE "sotrudniki" (
  "id_sotrudnika" serial PRIMARY KEY,
  "full_name" varchar(150) NOT NULL,
  "phone" varchar(20) UNIQUE NOT NULL,
  "id_pola" integer NOT NULL,
  "email" varchar(50) UNIQUE NOT NULL
);

CREATE TABLE "pol" (
  "id_pola" serial PRIMARY KEY,
  "nazvanie" varchar(10)
);

CREATE TABLE "rabochie_mesta" (
  "id_mesta" serial PRIMARY KEY,
  "id_cabineta" integer NOT NULL,
  "id_sotrudnika" integer NOT NULL
);

CREATE TABLE "oborudovanie" (
  "unical_nomer" varchar PRIMARY KEY,
  "id_tipa" integer NOT NULL,
  "god_vipuska" integer NOT NULL,
  "id_mesta" integer
);

CREATE TABLE "tip" (
  "id_tipa" serial PRIMARY KEY,
  "naimenovanie" varchar(50) NOT NULL
);

CREATE TABLE "spisannoe_oborudovanie" (
  "unical_nomer" varchar PRIMARY KEY,
  "tip" varchar(50) NOT NULL,
  "god_vipuska" integer NOT NULL,
  "data_spisania" date NOT NULL,
  "prichina" text NOT NULL
);

CREATE TABLE "peremesheniya" (
  "id_peremesheniya" serial PRIMARY KEY,
  "unical_nomer" varchar NOT NULL,
  "id_mesta_staroe" integer,
  "id_mesta_novoe" integer,
  "data_peremesheniya" date
);

ALTER TABLE "rabochie_mesta" ADD FOREIGN KEY ("id_cabineta") REFERENCES "cabinets" ("id_cabineta");

ALTER TABLE "oborudovanie" ADD FOREIGN KEY ("id_mesta") REFERENCES "rabochie_mesta" ("id_mesta");

ALTER TABLE "rabochie_mesta" ADD FOREIGN KEY ("id_sotrudnika") REFERENCES "sotrudniki" ("id_sotrudnika");

ALTER TABLE "oborudovanie" ADD FOREIGN KEY ("id_tipa") REFERENCES "tip" ("id_tipa");

ALTER TABLE "sotrudniki" ADD FOREIGN KEY ("id_pola") REFERENCES "pol" ("id_pola");
