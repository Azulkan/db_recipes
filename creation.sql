SET client_min_messages TO WARNING;

----------------------------
-- Création des tables
----------------------------

-- Entités
 
CREATE TABLE PERSONNE (
	idPers SERIAL PRIMARY KEY,
	nom VARCHAR(50),
	typeLien VARCHAR(20),
	telephone VARCHAR(20),

	CHECK (typeLien IN('Ami', 'Famille', 'Collegue'))
);

--

CREATE TABLE RANGEMENT (
	idRang SERIAL PRIMARY KEY,
	type VARCHAR(20),
	description VARCHAR(200),
	dateRangement DATE,
	nom VARCHAR(50)

	CHECK(type IN('Manuscrit', 'Livre', 'Url', 'Magazine'))
);

--

CREATE TABLE RECETTE (
	idRec SERIAL PRIMARY KEY,
	titre VARCHAR(50),
	type VARCHAR(20),
	description VARCHAR(300),
	tempsPreparation SMALLINT,
	tempsCuisson SMALLINT,
	note SMALLINT

	CHECK(tempsPreparation >= 0)
	CHECK(tempsCuisson >= 0)
	CHECK(note >= 0 AND note <= 10)
	CHECK(type IN('Amuse-gueule', 'Entree', 'Plat', 'Dessert'))
);

--

CREATE TABLE INGREDIENT (
	nom VARCHAR(50) PRIMARY KEY,
	unite VARCHAR(20),
	description VARCHAR(200),
	prix SMALLINT

	CHECK(unite IN('unite', 'litre', '100 grammes', 'kilo'))
	CHECK(prix >= 0) 
);

-- Associations

CREATE TABLE REALISER_POUR (
	evenement VARCHAR(20),
	dateEvenement DATE NOT NULL,
	idPers SERIAL REFERENCES PERSONNE ON DELETE CASCADE,
	idRec SERIAL REFERENCES RECETTE ON DELETE CASCADE

	CHECK(evenement IN(NULL, 'Anniversaire', 'Fête', 'Noël', 'Nouvel-An'))
);

--

CREATE TABLE CONTENIR (
	quantite REAL,
	unite VARCHAR(20),
	nom VARCHAR(50) REFERENCES INGREDIENT ON DELETE CASCADE,
	idRec SERIAL REFERENCES RECETTE ON DELETE CASCADE

	CHECK(unite IN('unite', 'litre', '100 grammes', 'kilo'))
	CHECK(quantite >= 0)
);

--

CREATE TABLE RANGER (
	idRec SERIAL REFERENCES RECETTE ON DELETE CASCADE,
	idRang SERIAL REFERENCES RANGEMENT ON DELETE CASCADE
);

----------------------------
-- Insertion des tuples 
----------------------------

INSERT INTO PERSONNE(idPers, nom, typeLien, telephone) VALUES
	(1, 'Lance Pierre', 'Collegue', '0232956325'),
	(2, 'Laure Aidubois', 'Ami', '0698523210'),
	(3, 'Mamie', 'Famille', '0298541585'),
	(4, 'Ma mie', 'Famille', '0685954514'),
	(5, 'Albert Gamotte', 'Collegue', '0235457410'),
	(6, 'Bebert', 'Ami', '0698523300'),
	(7, 'Bruno Zieuvair', 'Collegue', NULL),
	(8, 'Maggie Mauve', 'Ami', '0296256574');
SELECT setval('PERSONNE_idPers_seq', 8); -- Car on a spécifié nous mêmes les premières valeurs du SERIAL, currval ne s'est pas incrementé.

--

INSERT INTO RANGEMENT(idRang, type, description, dateRangement, nom) VALUES
	(1, 'Magazine', NULL, '12/11/2012', 'MAXI'),
	(2, 'Magazine', NULL, '01/02/2013', 'MAXI'),
	(3, 'Livre', NULL, NULL, 'Cuisine d été'),
	(4, 'Manuscrit', NULL, NULL, 'RecettesPerso');
SELECT setval('RANGEMENT_idRang_seq', 4);

--

INSERT INTO RECETTE(idRec, titre, type, description, tempsPreparation, tempsCuisson, note) VALUES
	(1, 'feuilletés jambon-fromage', 'Amuse-gueule', '(1) Etaler la pâte feuilletée (2) Y mettre le jambon et le fromage (3) Faire cuire', 10, 15, 8),
	(2, 'tartiflette', NULL, '(1) Cuire les pommes de terre ; (2) Émincez les oignons et cuisez-les ; (3) ajouter le jambon et les pommes de terre, Laissez mijoter ; (4) mettre dans un plat, couvrir avec les reblochons coupés ; (5) faîte cuire', 20, 30, 7),
	(3, 'Chèvre chaud aux figues', NULL, '(1) Coupez les figues en deux ; (2) Mettre dans un plat ; (3) Mettre le chèvre dessus ; (4) salez et poivrez ; (5) Mettre au four', 15, 15, 8),
	(4, 'Crème aux épices', NULL, '(1) Faire chauffer le lait avec la canelle ; (2) Battre les oeufs et le sucre ; (3) Mettre le lait sur la préparation ; (4) Remettre à cuire en touillant', 20, 15, 5),
	(5, 'jolis petits sablés', NULL, '(1) Mélangez beurre, farine et sucre en sablant ; (2) Ajoutez l oeuf et pétrir ; (3) Etalez la pâte ; (4) Faire de jolies formes ; (4) Posez sur une plaque et faire cuire', 25, 20, 6),
	(6, 'salade de tomates', NULL, '(1) coupez les tomates ; (2) salez et poivrez', 10, 0, 2),
	(7, 'Pana cotta à la pistache', NULL, '(1) Mixez le jambon ; (2) Coupez les figues en 2, creusez les pour récupérer la chair ; (3) Mélangez le jambon et la chair ; (4) Salez et poivrez ; (5) Remplissez les figues avec le mélange et mettre au four', 25, 25, 8),
	(8, 'jambon aux figues', NULL, '(1) Mixez le jambon ; (2) Coupez les figues en 2, creusez les pour récupérer la chair ; (3) Mélangez le jambon et la chair ; (4) Salez et poivrez ; (5) Remplissez les figues avec le mélange et mettre au four', 25, 25, 8),
	(9, 'omelette', NULL, '(1) Cassez les oeufs ; (2) touillez ; (3) mettre dans une poele ; (4) cuire avant que ça brûle', 10, 10, 3),
	(10, 'fromage blanc à la confiture', NULL, '(1) Mélangez le fromage blanc et la confiture ; (2) Mettre au frais', 5, 15, 7);
SELECT setval('RECETTE_idRec_seq', 10);

--

INSERT INTO INGREDIENT(nom, unite, description, prix) VALUES
	('pistache', 'kilo', 'émondées', 30),
	('lait', 'litre', 'écrémé', 1),
	('jambon', 'kilo', 'blanc', 9),
	('pâte', 'kilo', 'feuilletée', 10),
	('fromage', 'kilo', 'rapé', 15),
	('reblochon', 'kilo', 'de Savoie', 20),
	('pommes de terre', 'kilo', NULL, 2),
	('oignon', 'kilo', 'rouge ou blanc', 2),
	('sel', 'kilo', 'fin', 2),
	('poivre', 'kilo', 'noir', 15),
	('chèvre', 'kilo', 'frais', 20),
	('figue', 'kilo', 'fraiche', 10),
	('cannelle', 'kilo', 'bâton', 30),
	('oeuf', 'unite', 'de plein-air', 1),
	('sucre', 'kilo', 'blanc', 5),
	('farine', 'kilo', 'blanche', 2),
	('beurre', 'kilo', 'salé', 4),
	('tomate', 'kilo', 'marmande', 3),
	('gelatine', 'unite', 'feuille = 2g', 2),
	('fromage blanc', 'kilo', 'nature', 7),
	('confiture', 'kilo', 'aux fruits', 15),
	('mascarpone', 'kilo', 'crème', 10);

--

INSERT INTO REALISER_POUR(evenement, dateEvenement, idPers, idRec) VALUES
	(NULL, '10/04/2014', 1, 2),
	(NULL, '10/04/2014', 1, 5),
	(NULL, '20/11/2014', 1, 8),
	(NULL, '20/11/2014', 1, 7),
	('Nouvel-An', '31/12/2014', 1, 1),
	('Nouvel-An', '31/12/2014', 1, 8),
	('Nouvel-An', '31/12/2014', 1, 7),

	(NULL, '02/02/2014', 3, 8),
	(NULL, '02/02/2014', 3, 10),
	(NULL, '12/03/2014', 3, 8),
	(NULL, '05/04/2014', 3, 9),
	(NULL, '10/05/2014', 3, 9),
	(NULL, '10/05/2014', 3, 10),
	(NULL, '23/06/2014', 3, 9),
	(NULL, '23/06/2014', 3, 4),	
	(NULL, '01/09/2014', 3, 9),
	(NULL, '01/09/2014', 3, 10),	
	(NULL, '10/10/2014', 3, 8),
	(NULL, '10/10/2014', 3, 10),
	(NULL, '11/11/2014', 3, 8),
	('Noel', '24/12/2014', 3, 1),
	('Noel', '24/12/2014', 3, 3),
	('Noel', '24/12/2014', 3, 4),

	(NULL, '02/11/2014', 4, 3),
	(NULL, '02/11/2014', 4, 7),
	(NULL, '10/11/2014', 4, 9),
	(NULL, '10/11/2014', 4, 10),
	(NULL, '15/11/2014', 4, 8),
	(NULL, '15/11/2014', 4, 4),
	(NULL, '02/12/2014', 4, 6),
	(NULL, '02/12/2014', 4, 5),
	(NULL, '10/12/2014', 4, 1),
	(NULL, '10/12/2014', 4, 6),
	(NULL, '12/12/2014', 4, 3),
	(NULL, '12/12/2014', 4, 4),
	('Noel', '24/12/2014', 4, 1),
	('Noel', '24/12/2014', 4, 3),
	('Noel', '24/12/2014', 4, 4),
	(NULL, '01/01/2015', 4, 9),
	(NULL, '05/01/2015', 4, 8),
	(NULL, '05/01/2015', 4, 10),
	(NULL, '10/01/2015', 4, 6),
	(NULL, '10/01/2015', 4, 5),

	('Nouvel-An', '31/12/2014', 6, 1),
	('Nouvel-An', '31/12/2014', 6, 8),
	('Nouvel-An', '31/12/2014', 6, 7),
	(NULL, '10/02/2013', 8, 2),
	(NULL, '10/02/2013', 8, 4),
	(NULL, '20/07/2014', 8, 8),
	(NULL, '20/07/2014', 8, 5),
	('Nouvel-An', '31/12/2014', 8, 1),
	('Nouvel-An', '31/12/2014', 8, 8),
	('Nouvel-An', '31/12/2014', 8, 7);

--

INSERT INTO CONTENIR(quantite, unite, nom, idRec) VALUES
	(0.2, 'kilo', 'jambon', 1),
	(0.1, 'kilo', 'fromage', 1),
	(1, 'unite', 'pâte', 1),

	(1, 'kilo', 'reblochon', 2),
	(1, 'kilo', 'pommes de terre', 2),
	(0.3, 'kilo', 'jambon', 2),
	(2, 'kilo', 'oignon', 2),
	(1, 'kilo', 'sel', 2),
	(1, 'kilo', 'poivre', 2),

	(0.2, 'kilo', 'chèvre', 3),
	(4, 'kilo', 'figue', 3),
	(1, 'kilo', 'sel', 3),
	(1, 'kilo', 'poivre', 3),

	(0.5, 'litre', 'lait', 4),
	(1, 'kilo', 'cannelle', 4),
	(2, 'unite', 'oeuf', 4),
	(0.05, 'kilo', 'sucre', 4),

	(0.2, 'kilo', 'farine', 5),
	(0.1, 'kilo', 'sucre', 5),
	(1, 'unite', 'oeuf', 5),
	(0.05, 'kilo', 'beurre', 5),

	(5, 'kilo', 'tomate', 6),
	(1, 'kilo', 'sel', 6),
	(1, 'kilo', 'poivre', 6),

	(1, 'litre', 'lait', 7),
	(0.1, 'kilo', 'pistache', 7),
	(2, 'unite', 'gelatine', 7),
	(0.06, 'kilo', 'sucre', 7),
	(0.1, 'kilo', 'mascarpone', 7),

	(1, 'kilo', 'jambon', 8),
	(10, 'kilo', 'figue', 8),
	(1, 'kilo', 'sel', 8),
	(1, 'kilo', 'poivre', 8),

	(3, 'unite', 'oeuf', 9),

	(0.5, 'kilo', 'fromage blanc', 10),
	(0.1, 'kilo', 'confiture', 10);

--

INSERT INTO RANGER(idRec, idRang) VALUES
	(1, 1),
	(2, 1),
	(3, 1),
	(4, 1),
-- grtt1 : Consultation


	(5, 2),
	(6, 2),

	(7, 3),
	(8, 3),

	(9, 4),
	(10, 4);

----------------------------
-- Définition des fonctions 
----------------------------

CREATE OR REPLACE FUNCTION appreciationRecette(id INTEGER)
RETURNS VARCHAR(10) AS $$

DECLARE 
	appreciation VARCHAR(10);
	laNote SMALLINT;

BEGIN
	SELECT note INTO laNote
	FROM RECETTE
	WHERE idRec = id;

	IF laNote < 5 THEN
		appreciation := 'Bof';
	END IF;

	IF laNote >= 5 AND laNote <= 7 THEN
		appreciation := 'Bon';
	END IF;

	IF laNote > 7 THEN
		appreciation := 'Excellent';
	END IF;

	RETURN appreciation;
END $$ LANGUAGE 'plpgsql';

--

CREATE OR REPLACE FUNCTION nbInvit(id INTEGER)
RETURNS SMALLINT AS $$

DECLARE 
	resultat SMALLINT;

BEGIN
	SELECT count(DISTINCT dateEvenement) INTO resultat
	FROM REALISER_POUR
	WHERE idPers = id;

	RETURN resultat;
END $$ LANGUAGE 'plpgsql';

--

CREATE OR REPLACE FUNCTION derniereInvit(id INTEGER)
RETURNS DATE AS $$

DECLARE 
	resultat DATE;

BEGIN
	SELECT MAX(rp.dateEvenement) INTO resultat
	FROM REALISER_POUR rp, PERSONNE p
	WHERE rp.idPers = p.idPers AND p.idPers = id;

	RETURN resultat;
END $$ LANGUAGE 'plpgsql';

--

CREATE OR REPLACE FUNCTION aInviter(id INTEGER)
RETURNS SMALLINT AS $$

DECLARE 
	resultat SMALLINT;
	laDate DATE;

BEGIN
	SELECT MAX(rp.dateEvenement) INTO laDate
	FROM REALISER_POUR rp, PERSONNE p
	WHERE rp.idPers = p.idPers AND p.idPers = id;

	IF laDate IS NULL THEN
		resultat := 1;
	ELSE
		resultat := 0;
	END IF;

	RETURN resultat;
END $$ LANGUAGE 'plpgsql';

----------------------------
-- Triggers 
----------------------------

CREATE FUNCTION verifierRangement() RETURNS trigger AS $$
    BEGIN
        IF NEW.type = 'Magazine' OR NEW.type = 'Url' THEN
        	IF NEW.dateRangement IS NULL THEN
        		RAISE EXCEPTION 'La date est obligatoirement renseignée pour un magazine ou une URL';
        	END IF;	
        END IF;

        RETURN NEW;
    END $$ LANGUAGE plpgsql;

CREATE TRIGGER triggerRangement BEFORE INSERT OR UPDATE ON RANGEMENT
    FOR EACH ROW EXECUTE PROCEDURE verifierRangement();

--

CREATE FUNCTION verifierPersonne() RETURNS trigger AS $$
    BEGIN
        IF NEW.typeLien <> 'Famille' AND NEW.typeLien <> 'Ami' AND NEW.typeLien <> 'Collegue' THEN
        	RAISE EXCEPTION 'Type du lien invalide : doit être Famille, Ami ou Collegue';
        END IF;

        RETURN NEW;
    END $$ LANGUAGE plpgsql;

CREATE TRIGGER triggerPersonne BEFORE INSERT OR UPDATE ON PERSONNE
    FOR EACH ROW EXECUTE PROCEDURE verifierPersonne();

--

CREATE FUNCTION evenementImportant() RETURNS trigger AS $$
    DECLARE
    	anneeCourante TEXT;
    	dateCourante TEXT;

    BEGIN
    	anneeCourante = EXTRACT(YEAR FROM CURRENT_DATE);

    	IF NEW.dateEvenement IS NULL THEN
	        IF NEW.evenement = 'Noel' THEN
	            dateCourante := anneeCourante || '-12-24';
	            NEW.dateEvenement := to_date(dateCourante, 'YYYY-MM-DD');
	        END IF;

	        IF NEW.evenement = 'Nouvel-An' THEN
	            dateCourante := anneeCourante || '-12-31';
	            NEW.dateEvenement := to_date(dateCourante, 'YYYY-MM-DD');
	        END IF;
        END IF;

        RETURN NEW;
    END $$ LANGUAGE plpgsql;

CREATE TRIGGER triggerDateEvenement BEFORE INSERT OR UPDATE ON REALISER_POUR
    FOR EACH ROW EXECUTE PROCEDURE evenementImportant();

----------------------------
-- Création des vues
----------------------------

CREATE VIEW LISTE_EVALUATION_RECETTE (titre, type, tempsPreparation, tempsCuisson, appreciation) AS 
	SELECT titre, type, tempsPreparation, tempsCuisson, appreciationRecette(idRec)
 	FROM RECETTE;

--

CREATE VIEW LISTE_A_INVITER (nomPersonne, dateDerniereInvit, aInviter, nbInvit) AS
	SELECT p.nom, derniereInvit(p.idPers), aInviter(p.idPers) , nbInvit(p.idPers)
	FROM PERSONNE p
	GROUP BY p.idPers; 

----------------------------
-- Index 
----------------------------

CREATE INDEX typeLien_index ON PERSONNE(typeLien);

--

CREATE INDEX titre_index ON RECETTE(titre); 

----------------------------
-- Attribution des droits 
----------------------------

-- grtt42 : Consultation + Mise à jour

GRANT UPDATE ON PERSONNE, RECETTE, INGREDIENT, RANGEMENT, CONTENIR, REALISER_POUR, RANGER TO grtt42;
GRANT SELECT ON PERSONNE, RECETTE, INGREDIENT, RANGEMENT, CONTENIR, REALISER_POUR, RANGER TO grtt42;

-- grtt1 : Consultation

GRANT SELECT ON PERSONNE, RECETTE, INGREDIENT, RANGEMENT, CONTENIR, REALISER_POUR, RANGER TO grtt1;
