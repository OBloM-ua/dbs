DROP TABLE Lehrveranstaltung;
DROP TABLE teilgenommen;
DROP TABLE studiert;
DROP TABLE StudentIn;
DROP TABLE Studienrichtung;

--3.1 Zeichnen Sie die angegebenen Relationen als ER Diagramm.
SELECT *
FROM LEHRVERANSTALTUNG;
SELECT *
FROM teilgenommen;
SELECT *
FROM studiert;
SELECT *
FROM StudentIn;
SELECT *
FROM Studienrichtung;

CREATE TABLE Lehrveranstaltung (
  LVNr    CHAR(6),
  Titel   VARCHAR(25),
  Typ     VARCHAR(4),
  Stunden NUMBER,
  ECTS    NUMBER,
  PRIMARY KEY (LVNr)
);

CREATE TABLE teilgenommen (
  MatrNr   CHAR(8),
  LVNr     CHAR(6),
  Semester CHAR(7),
  Note     NUMBER,
  PRIMARY KEY (MatrNr, LVNr, Semester),
  FOREIGN KEY (MatrNr) REFERENCES StudentIn (MatrNr),
  FOREIGN KEY (LVNr) REFERENCES Lehrveranstaltung (LVNr)
);

CREATE TABLE StudentIn (
  MatrNr   CHAR(8),
  Vorname  VARCHAR(25),
  Nachname VARCHAR(25),
  GebDatum DATE,
  PRIMARY KEY (MatrNr)
);

CREATE TABLE studiert (
  MatrNr   CHAR(8),
  Kennzahl VARCHAR(5),
  seit     DATE,
  PRIMARY KEY (MatrNr, Kennzahl),
  FOREIGN KEY (MatrNr) REFERENCES StudentIn (MatrNr),
  FOREIGN KEY (Kennzahl) REFERENCES Studienrichtung (Kennzahl)
);

CREATE TABLE Studienrichtung (
  Kennzahl  VARCHAR(5),
  Name      VARCHAR(25),
  Abschnitt VARCHAR(25),
  SumECTS   VARCHAR(5),
  PRIMARY KEY (Kennzahl)
);

INSERT INTO Lehrveranstaltung (LVNr, Titel, Typ, Stunden, ECTS) VALUES (050030, 'Datenbanksysteme', 'VO', 1.0, 2.0);
INSERT INTO Lehrveranstaltung (LVNr, Titel, Typ, Stunden, ECTS) VALUES (050031, 'Datenbanksysteme', 'UE', 2.0, 3.0);
INSERT INTO Lehrveranstaltung (LVNr, Titel, Typ, Stunden, ECTS)
VALUES (050054, 'Softwarearchitekturen', 'PR', 2.0, 3.0);
INSERT INTO Lehrveranstaltung (LVNr, Titel, Typ, Stunden, ECTS) VALUES (050056, 'Projektmanagement', 'VU', 4.0, 6.0);

INSERT INTO teilgenommen (MatrNr, LVNr, Semester, Note) VALUES (0111111, 050030, 'SS 2002', 2);
INSERT INTO teilgenommen (MatrNr, LVNr, Semester, Note) VALUES (0111111, 050031, 'SS 2002', 3);
INSERT INTO teilgenommen (MatrNr, LVNr, Semester, Note) VALUES (0111111, 050056, 'WS 2003', 1);
INSERT INTO teilgenommen (MatrNr, LVNr, Semester, Note) VALUES (0222222, 050054, 'SS 2002', 4);
INSERT INTO teilgenommen (MatrNr, LVNr, Semester, Note) VALUES (0222222, 050056, 'WS 2003', 1);

INSERT INTO StudentIn (MatrNr, Vorname, Nachname, GebDatum)
VALUES (0111111, 'Martin', 'Huber', TO_DATE('1981/01/01', 'yyyy/mm/dd'));
INSERT INTO StudentIn (MatrNr, Vorname, Nachname, GebDatum)
VALUES (0222222, 'Johann', 'Maier', TO_DATE('1982/05/05', 'yyyy/mm/dd'));

INSERT INTO studiert (MatrNr, Kennzahl, seit) VALUES (0111111, 521, TO_DATE('2001/10/01', 'yyyy/mm/dd'));
INSERT INTO studiert (MatrNr, Kennzahl, seit) VALUES (0111111, 926, TO_DATE('2001/10/01', 'yyyy/mm/dd'));
INSERT INTO studiert (MatrNr, Kennzahl, seit) VALUES (0222222, 521, TO_DATE('2001/10/01', 'yyyy/mm/dd'));
INSERT INTO studiert (MatrNr, Kennzahl, seit) VALUES (0222222, 526, TO_DATE('2001/10/01', 'yyyy/mm/dd'));


INSERT INTO Studienrichtung (Kennzahl, Name, Abschnitt, SumECTS) VALUES (521, 'Informatik', 'Bakkalaureat', 180);
INSERT INTO Studienrichtung (Kennzahl, Name, Abschnitt, SumECTS)
VALUES (526, 'Wirtschaftsinformatik', 'Bakkalaureat', 180);
INSERT INTO Studienrichtung (Kennzahl, Name, Abschnitt, SumECTS)
VALUES (926, 'Wirtschaftsinformatik', 'Magisterstudium', 120);
INSERT INTO Studienrichtung (Kennzahl, Name, Abschnitt, SumECTS)
VALUES (935, 'Medieninformatik', 'Magisterstudium', 120);

--3.2
CREATE VIEW r1 AS (SELECT *
                   FROM STUDENTIN
                   WHERE vorname = 'Martin' AND NACHNAME = 'Huber');
CREATE VIEW r2 AS (SELECT
                     MatrNr,
                     titel,
                     Semester
                   FROM LEHRVERANSTALTUNG
                     NATURAL JOIN TEILGENOMMEN
                     NATURAL JOIN r1);

--3.3
--"Gesucht sind die Namen und Noten aller Studierenden, die im SS 2002
-- an einer Lehrveranstaltung teilgenommen und diese mit der Note 2, 3, oder 4 abgeschlossen haben."

SELECT DISTINCT
  Vorname,
  Nachname,
  note
FROM teilgenommen
  NATURAL JOIN STUDENTIN
WHERE
  TEILGENOMMEN.SEMESTER = 'SS 2002' AND TEILGENOMMEN.NOTE > 1 AND TEILGENOMMEN.NOTE < 5;

-- Exercise 3.4
-- Formulieren Sie die folgende Fragestellung in Relationenalgebra und SQL. Geben Sie weiters auch die Ergebnisrelation
-- in Tabellenform an:
-- "Gesucht sind alle Tupel bei denen die Note des Studierenden mit der ECTS Anzahl der Lehrveranstaltung übereinstimmt."
SELECT *
FROM Lehrveranstaltung, teilgenommen
WHERE
  teilgenommen.NOTE = LEHRVERANSTALTUNG.ECTS;

--3.5
--Gesucht sind Kennzahl und Name aller Studienrichtungen die keinen teilnehmenden Studierenden aufweisen."
SELECT
  Kennzahl,
  Name
FROM Studienrichtung
WHERE KENNZAHL NOT IN (SELECT KENNZAHL
                       FROM studiert);

--3.6
-- "Gesucht sind die Namen aller Studierenden und die Anzahl der Lehrveranstaltungen, die diese im SS 2002 besucht haben."