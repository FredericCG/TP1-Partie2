-- TP1 fichier réponse -- Modifiez le nom du fichier en suivant les instructions
-- Votre nom:                        Votre DA: 
--ASSUREZ VOUS DE LA BONNE LISIBILITÉ DE VOS REQUÊTES  /5--

-- 1.   Rédigez la requête qui affiche la description pour les trois tables. Le nom des champs et leur type. /2
DESC OUTILS_EMPRUNT;

DESC OUTILS_OUTIL;

DESC OUTILS_USAGER;

-- 2.   Rédigez la requête qui affiche la liste de tous les usagers, sous le format prénom « espace » nom de famille (indice : concaténation). /2
SELECT
    CONCAT(CONCAT(PRENOM,
    ' '),
    NOM_FAMILLE) AS "Usager"
FROM
    OUTILS_USAGER;

-- 3.   Rédigez la requête qui affiche le nom des villes où habitent les usagers, en ordre alphabétique, le nom des villes va apparaître seulement une seule fois. /2
SELECT
    DISTINCT VILLE AS "Ville de l'usager"
FROM
    OUTILS_USAGER
ORDER BY
    VILLE ASC;
-- 4.   Rédigez la requête qui affiche toutes les informations sur tous les outils en ordre alphabétique sur le nom de l’outil puis sur le code. /2
SELECT
    NOM,
    CODE_OUTIL AS "Code de l'outil"
FROM
    OUTILS_OUTIL
ORDER BY
    NOM ASC;
-- 5.   Rédigez la requête qui affiche le numéro des emprunts qui n’ont pas été retournés. /2
SELECT
    NUM_EMPRUNT AS "Numéro de l'emprunt"
FROM
    OUTILS_EMPRUNT
WHERE
    DATE_RETOUR IS NULL;

-- 6.   Rédigez la requête qui affiche le numéro des emprunts faits avant 2014./3
SELECT
    NUM_EMPRUNT AS "Numéro de l'emprunt"
FROM
    OUTILS_EMPRUNT
WHERE
    DATE_EMPRUNT < TO_DATE('01-01-2014',
    'DD-MM-YYYY');
-- 7.   Rédigez la requête qui affiche le nom et le code des outils dont la couleur début par la lettre « j » (indice : utiliser UPPER() et LIKE) /3
SELECT
    NOM        AS "Outil",
    CODE_OUTIL AS "Code de l'outil"
FROM
    OUTILS_OUTIL
WHERE
    UPPER(CARACTERISTIQUES) LIKE '%J%';
-- 8.   Rédigez la requête qui affiche le nom et le code des outils fabriqués par Stanley. /2
SELECT
    NOM        AS "Outil",
    CODE_OUTIL AS "Code de l'outil"
FROM
    OUTILS_OUTIL
WHERE
    UPPER(FABRICANT) = 'STANLEY';
-- 9.   Rédigez la requête qui affiche le nom et le fabricant des outils fabriqués de 2006 à 2008 (ANNEE). /2
SELECT
    NOM       AS "Outil",
    FABRICANT AS "Fabricant de l'outil"
FROM
    OUTILS_OUTIL
WHERE
    ANNEE <= 2008
    AND ANNEE >= 2006;

-- 10.  Rédigez la requête qui affiche le code et le nom des outils qui ne sont pas de « 20 volts ». /3
SELECT
    NOM        AS "Outil",
    CODE_OUTIL AS "Code de l'outil"
FROM
    OUTILS_OUTIL
WHERE
    UPPER(CARACTERISTIQUES) NOT LIKE '%20 VOLT%';
-- 11.  Rédigez la requête qui affiche le nombre d’outils qui n’ont pas été fabriqués par Makita. /2
SELECT
    COUNT(NOM) AS "Nombre d'outils"
FROM
    OUTILS_OUTIL
WHERE
    UPPER(FABRICANT) != 'MAKITA';
-- 12.  Rédigez la requête qui affiche les emprunts des clients de Vancouver et Regina. Il faut afficher le nom complet de l’usager, le numéro d’emprunt, la durée de l’emprunt et le prix de l’outil (indice : n’oubliez pas de traiter le NULL possible (dans les dates et le prix) et utilisez le IN). /5
SELECT
    (CONCAT(CONCAT(U.PRENOM,
    ' '),
    U.NOM_FAMILLE))                 AS "Usager",
    E.NUM_EMPRUNT                   AS "Numéro de l'emprunt",
    NVL(ROUND(E.DATE_RETOUR- E.DATE_EMPRUNT),
    ROUND(SYSDATE- E.DATE_EMPRUNT)) AS "Durée de l'emprunt",
    NVL(O.PRIX,
    0)                              AS "Prix de l'outil"
FROM
    OUTILS_EMPRUNT E
    INNER JOIN OUTILS_USAGER U
    ON U.NUM_USAGER = E.NUM_USAGER
    INNER JOIN OUTILS_OUTIL O
    ON E.CODE_OUTIL = O.CODE_OUTIL
WHERE
    U.VILLE IN ('Regina',
    'Vancouver');
-- 13.  Rédigez la requête qui affiche le nom et le code des outils empruntés qui n’ont pas encore été retournés. /4
SELECT
    O.NOM        AS "Outils",
    O.CODE_OUTIL AS "Code de l'outil"
FROM
    OUTILS_OUTIL   O
    INNER JOIN OUTILS_EMPRUNT E
    ON E.CODE_OUTIL = O.CODE_OUTIL
WHERE
    E.DATE_RETOUR IS NULL;
-- 14.  Rédigez la requête qui affiche le nom et le courriel des usagers qui n’ont jamais fait d’emprunts. (indice : IN avec sous-requête) /3
SELECT
    (CONCAT(CONCAT(PRENOM,
    ' '),
    NOM_FAMILLE)) AS "Usager",
    COURRIEL      AS "Courriel de l'usager"
FROM
    OUTILS_USAGER
WHERE
    NUM_USAGER NOT IN (
        SELECT
            NUM_USAGER
        FROM
            OUTILS_EMPRUNT
    );
-- 15.  Rédigez la requête qui affiche le code et la valeur des outils qui n’ont pas été empruntés. (indice : utiliser une jointure externe – LEFT OUTER, aucun NULL dans les nombres) /4
SELECT
    O.CODE_OUTIL AS "Code de l'outil",
    NVL(O.PRIX,
    0)           AS "Prix de l'outils"
FROM
    OUTILS_OUTIL   O
    LEFT OUTER JOIN OUTILS_EMPRUNT E
    ON O.CODE_OUTIL = E.CODE_OUTIL
WHERE
    E.CODE_OUTIL IS NULL;
-- 16.  Rédigez la requête qui affiche la liste des outils (nom et prix) qui sont de marque Makita et dont le prix est supérieur à la moyenne des prix de tous les outils. Remplacer les valeurs absentes par la moyenne de tous les autres outils. /4
SELECT
    NOM       AS "Outil",
    ROUND(COALESCE(PRIX,
    MOYENNE)) AS "Prix ou moyenne du prix des outils"
FROM
    OUTILS_OUTIL O1
    INNER JOIN (
        SELECT
            AVG(PRIX) AS MOYENNE
        FROM
            OUTILS_OUTIL O
    )
    ON 1 = 1
WHERE
    FABRICANT = 'Makita'
    AND (PRIX > MOYENNE
    OR PRIX IS NULL);
-- 17.  Rédigez la requête qui affiche le nom, le prénom et l’adresse des usagers et le nom et le code des outils qu’ils ont empruntés après 2014. Triés par nom de famille. /4
SELECT
    U.NOM_FAMILLE AS "Nom de famille",
    U.PRENOM      AS "Prénom",
    U.ADRESSE     AS "Adresse de l'usager",
    O.NOM         AS "Outil emprunté",
    O.CODE_OUTIL  AS "Code de l'outil"
FROM
    OUTILS_USAGER  U
    INNER JOIN OUTILS_EMPRUNT E
    ON U.NUM_USAGER = E.NUM_USAGER
    INNER JOIN OUTILS_OUTIL O
    ON E.CODE_OUTIL = O.CODE_OUTIL
WHERE
    E.DATE_EMPRUNT > TO_DATE('31-12-2014',
    'DD-MM-YYYY')
ORDER BY
    U.NOM_FAMILLE ASC;
-- 18.  Rédigez la requête qui affiche le nom et le prix des outils qui ont été empruntés plus qu’une fois. /4
SELECT
    O.NOM AS "Outil emprunté",
    NVL(O.PRIX,
    0)    AS "Prix de l'outil"
FROM
    OUTILS_OUTIL   O
    INNER JOIN OUTILS_EMPRUNT E
    ON E.CODE_OUTIL = O.CODE_OUTIL
GROUP BY
    O.NOM,
    O.PRIX
HAVING
    COUNT(E.CODE_OUTIL) > 1;
-- 19.  Rédigez la requête qui affiche le nom, l’adresse et la ville de tous les usagers qui ont fait des emprunts en utilisant : /6

--  Une jointure
SELECT
    DISTINCT U.NOM_FAMILLE AS "Nom de famille de l'usager",
    U.ADRESSE     AS "Adresse de l'usager",
    U.VILLE       AS "Ville"
FROM
    OUTILS_USAGER  U
    INNER JOIN OUTILS_EMPRUNT E
    ON U.NUM_USAGER = E.NUM_USAGER
WHERE
    U.NUM_USAGER IS NOT NULL;
--  IN
SELECT
    DISTINCT NOM_FAMILLE AS "Nom de famille de l'usager",
    ADRESSE     AS "Adresse de l'usager",
    VILLE       AS "Ville"
FROM
    OUTILS_USAGER
WHERE
    NUM_USAGER IN (
        SELECT
            NUM_USAGER
        FROM
            OUTILS_EMPRUNT
    );
--  EXISTS
SELECT
    DISTINCT U.NOM_FAMILLE AS "Nom de famille de l'usager",
    U.ADRESSE     AS "Adresse de l'usager",
    U.VILLE       AS "Ville"
FROM
    OUTILS_USAGER  U
WHERE
    EXISTS (
        SELECT
            E.NUM_USAGER
        FROM
            OUTILS_EMPRUNT E
        WHERE
            E.NUM_USAGER = U.NUM_USAGER
    );
-- 20.  Rédigez la requête qui affiche la moyenne du prix des outils par marque. /3
SELECT
    ROUND(AVG(NVL(PRIX,
    0)))      AS "Moyenne des prix",
    FABRICANT AS "Marque"
FROM
    OUTILS_OUTIL
GROUP BY
    FABRICANT;
-- 21.  Rédigez la requête qui affiche la somme des prix des outils empruntés par ville, en ordre décroissant de valeur. /4
SELECT
    SUM(O.PRIX),
    U.VILLE
FROM
    OUTILS_OUTIL   O
    INNER JOIN OUTILS_EMPRUNT E
    ON E.CODE_OUTIL = O.CODE_OUTIL
    INNER JOIN OUTILS_USAGER U
    ON U.NUM_USAGER = E.NUM_USAGER
WHERE
    U.NUM_USAGER IS NOT NULL
GROUP BY
    U.VILLE;
-- 22.  Rédigez la requête pour insérer un nouvel outil en donnant une valeur pour chacun des attributs. /2
INSERT INTO OUTILS_OUTIL (
    CODE_OUTIL,
    NOM,
    FABRICANT,
    CARACTERISTIQUES,
    ANNEE,
    PRIX
) VALUES (
    'PE225',
    'Pelle',
    'Dewalt',
    'Petite, acier inoxidable, jaune',
    '2018',
    '250'
);
-- 23.  Rédigez la requête pour insérer un nouvel outil en indiquant seulement son nom, son code et son année. /2
INSERT INTO OUTILS_OUTIL (
    NOM,
    CODE_OUTIL,
    ANNEE
) VALUES (
    'Marteau',
    'MA543',
    '2018'
);
-- 24.  Rédigez la requête pour effacer les deux outils que vous venez d’insérer dans la table. /2
DELETE FROM OUTILS_OUTIL
WHERE
    CODE_OUTIL = 'MA543'
    OR CODE_OUTIL = 'PE225';
-- 25.  Rédigez la requête pour modifier le nom de famille des usagers afin qu’ils soient tous en majuscules. /2
UPDATE OUTILS_USAGER
SET
    NOM_FAMILLE = UPPER(
        NOM_FAMILLE
    );
