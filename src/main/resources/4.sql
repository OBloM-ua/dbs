DROP TABLE Lehrveranstaltung;

CREATE TABLE Lehrveranstaltung (
  LVNr    INTEGER,
  Titel   VARCHAR(20),
  Typ     VARCHAR(20),
  Stunden NUMERIC(3, 1),
  ECTS    NUMERIC(3, 1),
  PRIMARY KEY (LVNr)
);

CREATE TABLE StudentIn (
  MatrNr   INTEGER,
  Vorname  VARCHAR(20),
  Nachname VARCHAR(20),
  GebDatum DATE,
  PRIMARY KEY (MatrNr)
);


CREATE TABLE Teilnehmer (
  MatrNr   INTEGER,
  LVNr     INTEGER,
  semester VARCHAR(6),
  note     INTEGER,
  PRIMARY KEY (MatrNr, LVNr, semester),
  FOREIGN KEY (MatrNr) REFERENCES StudentIn(MatrNr),
  FOREIGN KEY (LVNr) REFERENCES Lehrveranstaltung(LVNr)
);


CREATE TABLE Studienrichtung (
  Kennzahl  INTEGER,
  Name      VARCHAR(20),
  Abschnitt VARCHAR(20),
  SumECTS   INTEGER,
  PRIMARY KEY (Kennzahl)
);

CREATE TABLE Studiert (
  Kennzahl INTEGER,
  MatrNr   INTEGER,
  seit     DATE,
  PRIMARY KEY (Kennzahl, MatrNr),
  FOREIGN KEY (MatrNr) REFERENCES StudentIn(MatrNr),
  FOREIGN KEY (Kennzahl) REFERENCES Studienrichtung(Kennzahl)
);

DROP TABLE Studienrichtung;

--Lehrveranstaltung =
--LVNr Titel Typ Stunden ECTS
--050030 Datenbanksysteme VO 1,0 2,0
--050031 Datenbanksysteme UE 2,0 3,0
--050054 Softwarearchitekturen PR 2,0 3,0
--050056 Projektmanagement VU 4,0 6,0

INSERT INTO Lehrveranstaltung (LVNr, Titel, Typ, Stunden, ECTS)
VALUES (050030, 'Datenbanksysteme', 'VO', 1.0, 2.0);

INSERT INTO Lehrveranstaltung (LVNr, Titel, Typ, Stunden, ECTS)
VALUES (050031, 'Datenbanksysteme', 'UE', 2.0, 3.0);

INSERT INTO Lehrveranstaltung (LVNr, Titel, Typ, Stunden, ECTS)
VALUES (050054, 'Softwarearchitekture', 'PR', 2.0, 3.0);

INSERT INTO Lehrveranstaltung (LVNr, Titel, Typ, Stunden, ECTS)
VALUES (050056, 'Projektmanagement', 'VU', 4.0, 6.0);

--StudentIn =
--MatrNr Vorname Nachname GebDatum
--0111111 Martin Huber 1981-01-01
--0222222 Johann Maier 1982-05-05

INSERT INTO StudentIn (MatrNr, Vorname, Nachname, GebDatum)
VALUES (0111111, 'Martin', 'Huber', to_date('1981-01-01', 'yyyy-mm-dd'));

INSERT INTO StudentIn (MatrNr, Vorname, Nachname, GebDatum)
VALUES (0222222, 'Johann', 'Maier', to_date('1982-05-05', 'yyyy-mm-dd'));

--teilgenommen =
--MatrNr LVNr Semester Note
--0111111 050030 SS 2002 2
--0111111 050031 SS 2002 3
--0111111 050056 WS 2003 1
--0222222 050054 SS 2002 4
--0222222 050056 WS 2003 1


INSERT INTO teilnehmer (MatrNr, LVNr, Semester, Note)
VALUES (0111111, 050030, 'SS2002', 2);

INSERT INTO teilnehmer (MatrNr, LVNr, Semester, Note)
VALUES (0111111, 050031, 'SS2002', 3);

INSERT INTO teilnehmer (MatrNr, LVNr, Semester, Note)
VALUES (0111111, 050056, 'WS2003', 1);

INSERT INTO teilnehmer (MatrNr, LVNr, Semester, Note)
VALUES (0222222, 050054, 'SS2002', 4);

INSERT INTO teilnehmer (MatrNr, LVNr, Semester, Note)
VALUES (0222222, 050056, 'WS2003', 1);

--
INSERT INTO Studienrichtung (Kennzahl, name, Abschnitt, SumECTS)
VALUES (521, 'Informatik', 'Bakkalaureat', 180);

INSERT INTO Studienrichtung (Kennzahl, name, Abschnitt, SumECTS)
VALUES (526, 'Wirtschaftsinformati', 'Bakkalaureat', 180);

INSERT INTO Studienrichtung (Kennzahl, name, Abschnitt, SumECTS)
VALUES (926, 'Wirtschaftsinformati', 'Magisterstudium', 120);

INSERT INTO Studienrichtung (Kennzahl, name, Abschnitt, SumECTS)
VALUES (935, 'Medieninformatik', 'Magisterstudium', 120);

--studiert =
--MatrNr Kennzahl seit
--0111111 521 2001-10-01
--0111111 926 2004-03-01
--0222222 521 2001-10-01
--0222222 526 2002-03-01


INSERT INTO studiert (MatrNr, Kennzahl, seit)
VALUES (0111111, 521, to_date('2001-10-01', 'yyyy-mm-dd'));

INSERT INTO studiert (MatrNr, Kennzahl, seit)
VALUES (0111111, 926, to_date('2004-03-01', 'yyyy-mm-dd'));

INSERT INTO studiert (MatrNr, Kennzahl, seit)
VALUES (0222222, 521, to_date('2001-10-01', 'yyyy-mm-dd'));

INSERT INTO studiert (MatrNr, Kennzahl, seit)
VALUES (0222222, 526, to_date('2002-03-01', 'yyyy-mm-dd'));

--TEST
SELECT table_name
FROM user_tables;
DROP TABLE teilnehmer;

SELECT *
FROM Studienrichtung;
SELECT *
FROM Lehrveranstaltung;
SELECT *
FROM STUDENTIN;
SELECT *
FROM TEILNEHMER;
SELECT *
FROM studiert;

DROP TABLE Studienrichtung;
DROP TABLE studiert;
DELETE FROM Studienrichtung
WHERE Kennzahl = 921;

--4.1
SELECT STUDIENRICHTUNG.NAME , STUDIENRICHTUNG.SUMECTS FROM STUDIENRICHTUNG WHERE SUMECTS = (SELECT MAX(SUMECTS) FROM STUDIENRICHTUNG);

SELECT STUDIENRICHTUNG.name FROM Studienrichtung WHERE SumECTS >= ALL (SELECT SumECTS FROM Studienrichtung);

-- ∏ NAME, SumECTS (σ MAX (SumECTS) (Studienrichtung))
--4.2
--Namen aller Studierenden, die Projektmanagement 050056 aber nicht  050054
--0111111 050030 SS 2002 2
--0111111 050031 SS 2002 3
--0111111 050056 WS 2003 1
--0222222 050054 SS 2002 4
--0222222 050056 WS 2003 1

SELECT DISTINCT
  vorname,
  nachname
FROM STUDENTIN
  INNER JOIN TEILNEHMER
    ON STUDENTIN.MatrNr = TEILNEHMER.MatrNr
WHERE TEILNEHMER.MatrNr NOT IN
      (SELECT TEILNEHMER.MatrNr
       FROM TEILNEHMER
       WHERE LVNr = '050054' AND LVNr != '050056');

-- R1 = σLVNr = 050056(teilgenommen)
-- R2 = σLVNr = 050054(teilgenommen)
-- R3 = R1 – R2
-- R4 = StudentIn ⋈ R3
-- R5 =∏ Nachname, Vorname (R4)


--4.3
SELECT
  Name,
  Kennzahl
FROM Studienrichtung
  NATURAL JOIN (
    SELECT
      Kennzahl,
      count(Kennzahl)
    FROM Studiert
    GROUP BY Kennzahl
    HAVING count(Kennzahl) >= 2);


-- ∏ NAME, Kennzahl (σ count(Kennzahl)>=2 (Studienrichtung⋈Studiert));
--4.4
ALTER TABLE StudentIn
  ADD (
  FreundIn INTEGER,
  FOREIGN KEY (FreundIn) REFERENCES StudentIn (MatrNr)
  );

UPDATE StudentIn
SET FreundIn = NULL
WHERE MatrNr = 0111111;
UPDATE StudentIn
SET FreundIn = 0111111
WHERE MatrNr = 0222222;

INSERT INTO StudentIn (MatrNr, Vorname, Nachname, GebDatum, FreundIn)
VALUES (0333333, 'Johann', 'Baidiuk', to_date('1992-08-12', 'yyyy-mm-dd'), 0222222);

SELECT
  MatrNr,
  Vorname,
  Nachname
FROM studentin
WHERE FREUNDIN = (SELECT MatrNr
                  FROM studentin
                  WHERE FREUNDIN = 0111111);


-- ∏ MatrNr, Vorname, Nachname (FreundIn =(∏ MatrNr(σ FREUNDIN = 0111111(studentin))
