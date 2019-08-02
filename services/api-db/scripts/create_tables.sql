DROP TABLE IF EXISTS "user_service";
DROP TABLE IF EXISTS "bid";
DROP TABLE IF EXISTS "slot";
DROP TABLE IF EXISTS "service";
DROP TABLE IF EXISTS "user";
DROP FUNCTION IF EXISTS "is_user_contractor";

CREATE TABLE "user" (
  "id" serial PRIMARY KEY,
  "username" VARCHAR(128) UNIQUE NOT NULL,
  "email" VARCHAR(128) UNIQUE NOT NULL,
  "created_on" TIMESTAMP NOT NULL,
  "contractor" CHAR DEFAULT 't'
);

CREATE TABLE "service" (
  id serial PRIMARY KEY,
  title VARCHAR(128) UNIQUE NOT NULL
);

CREATE TABLE "user_service" (
  contractor_id int REFERENCES "user" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  service_id int REFERENCES "service" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT user_service_pkey PRIMARY KEY (contractor_id, service_id)
);

CREATE TABLE "slot" (
  "id" SERIAL PRIMARY KEY,
  "start" TIMESTAMP NOT NULL,
  "duration" INTEGER NOT NULL,
  "contractor_id" INTEGER REFERENCES "user" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE "bid" (
  "amount" INTEGER NOT NULL,
  "client_id" INTEGER REFERENCES "user" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  "slot_id" INTEGER REFERENCES "slot" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  "service_id" INTEGER REFERENCES "service" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT bid_pkey PRIMARY KEY ("client_id", "slot_id", "service_id")
);

CREATE FUNCTION is_user_contractor() RETURNS trigger AS $is_user_contractor$
DECLARE
  is_contractor CHAR;
BEGIN
  SELECT "contractor" into is_contractor FROM "user" WHERE "user"."id" = NEW.contractor_id;
  IF  is_contractor != 't' THEN RAISE EXCEPTION '"contractor" column of user must be "t"'; END IF;
  RETURN NEW;
END; $is_user_contractor$
LANGUAGE PLPGSQL;

CREATE TRIGGER "is_user_contractor_user_service" BEFORE INSERT OR UPDATE ON "user_service"
  FOR EACH ROW EXECUTE PROCEDURE is_user_contractor();

CREATE TRIGGER "is_user_contractor_slot" BEFORE INSERT OR UPDATE ON "slot"
  FOR EACH ROW EXECUTE PROCEDURE is_user_contractor();