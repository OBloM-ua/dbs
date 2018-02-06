-- DROP TABLE Klient;
CREATE TABLE Klient (
  EMAIL    VARCHAR(30),
  Password VARCHAR(100),
  Name     VARCHAR(30),
  Adresse  VARCHAR(50),
  PRIMARY KEY (EMAIL)
);
CREATE TABLE Bezahlung (
  BezId       INTEGER,
  KreditKarte INTEGER,
  DebitKarte  INTEGER,
  PRIMARY KEY (BezId)
);
--drop table Auftrag;
CREATE TABLE Auftrag (
  Auftragid      NUMBER PRIMARY KEY,
  PreisSumme     NUMERIC(10, 2),
  ProduktenListe VARCHAR(150)
);
CREATE TABLE BKA (
  EMAIL     VARCHAR(30),
  BezId     INTEGER,
  Auftragid INTEGER,
--   PRIMARY KEY (EMAIL, BezId, Auftragid),
  FOREIGN KEY (Email) REFERENCES Klient,
  FOREIGN KEY (BezId) REFERENCES BEZAHLUNG,
  FOREIGN KEY (Auftragid) REFERENCES Auftrag
);
--1
-- DROP TABLE Produkt;
CREATE TABLE Produkt (
  Produktid  INTEGER,
  Preis      NUMERIC(10, 2),
  Name       VARCHAR(150),
  Hersteller VARCHAR(150),
  AuftragId  INTEGER,
  PRIMARY KEY (Produktid),
  FOREIGN KEY (Auftragid) REFERENCES Auftrag
);
CREATE TABLE Beschreibung (
  Bild      VARCHAR(150),
  Text      VARCHAR(2000),
  ProduktId INTEGER,
  FOREIGN KEY (ProduktId) REFERENCES Produkt
);
--DROP TABLE Lieferung;
CREATE TABLE Lieferung (
  Lieferung_Id_one INTEGER NOT NULL,
  Lieferung_Id_two INTEGER,
  PRIMARY KEY (Lieferung_Id_one),
  FOREIGN KEY (Lieferung_Id_two) REFERENCES Lieferung
);
--drop table ProduktLieferung;
CREATE TABLE ProduktLieferung (
  Produktid        INTEGER,
  Lieferung_Id_one INTEGER,
  FOREIGN KEY (Produktid) REFERENCES Produkt,
  FOREIGN KEY (Lieferung_Id_one) REFERENCES Lieferung
);
CREATE TABLE Alkohol (
  Typ       VARCHAR(30),
  Staerke   INTEGER,
  ProduktId INTEGER,
  FOREIGN KEY (ProduktId) REFERENCES Produkt
);
--drop table TABAK;
CREATE TABLE Tabak (
  Tabakharz VARCHAR(30),
  Nikotine  INTEGER,
  ProduktId INTEGER,
  FOREIGN KEY (ProduktId) REFERENCES Produkt
);
--drop SEQUENCE auftrag_seq;
CREATE SEQUENCE auftrag_seq
  START WITH 1;

--drop trigger auftrag_id_trg;
CREATE OR REPLACE TRIGGER auftrag_id_trg
  BEFORE INSERT ON Auftrag
  FOR EACH ROW
  BEGIN
    IF :new.Auftragid IS NULL
    THEN
      SELECT auftrag_seq.nextval
      INTO :new.Auftragid
      FROM dual;
    END IF;
  END;
/

