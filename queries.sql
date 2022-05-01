CREATE TABLE animal_species (
       species_id INTEGER PRIMARY KEY AUTOINCREMENT,
       species VARCHAR(50) NOT NULL
       );


CREATE TABLE breed (
       breed_id INTEGER PRIMARY KEY AUTOINCREMENT,
       breed_name VARCHAR(50) NOT NULL
       );

CREATE TABLE color (
       color_id INTEGER PRIMARY KEY AUTOINCREMENT,
       color_name VARCHAR(50) NOT NULL
       );


CREATE TABLE outcome_subtype (
       subtype_id INTEGER PRIMARY KEY AUTOINCREMENT,
       subtype_name VARCHAR(50) NOT NULL
       );


CREATE TABLE outcome_type (
       type_id INTEGER PRIMARY KEY AUTOINCREMENT,
       type_name VARCHAR(50) NOT NULL
       );


INSERT INTO species (species_name)
SELECT DISTINCT animal_type
FROM animals;


INSERT INTO breed (breed_name)
SELECT breed FROM animals
WHERE breed IS NOT NULL OR breed != ''
GROUP BY breed;


INSERT INTO breed (breed_name)
SELECT breed FROM animals
WHERE (breed IS NOT NULL OR breed != '')
GROUP BY animals.breed
HAVING animals.breed NOT IN (
                 SELECT breed_name
                 FROM breed);


UPDATE animals
SET color1 = TRIM(color1),
    color2 = TRIM(color2);


INSERT INTO color (color_name)
SELECT DISTINCT color1 FROM animals
WHERE (color1 IS NOT NULL
           OR color1 != '')
           AND animals.color1 NOT IN (
                 SELECT color_name
                 FROM color);

INSERT INTO color (color_name)
SELECT DISTINCT color2 FROM animals
WHERE (color2 IS NOT NULL
           OR color2 != '')
           AND animals.color2 NOT IN (
                 SELECT color_name
                 FROM color);

UPDATE breed
SET breed_name = TRIM(breed_name);


UPDATE animals
SET outcome_subtype = TRIM(outcome_subtype);

UPDATE animals
SET outcome_type = TRIM(outcome_type);

INSERT INTO outcome_subtype(subtype_name)
SELECT DISTINCT outcome_subtype FROM animals
WHERE outcome_subtype IS NOT NULL OR outcome_subtype != '';


INSERT INTO outcome_type(type_name)
SELECT DISTINCT outcome_type FROM animals
WHERE outcome_type IS NOT NULL OR outcome_type != '';


CREATE TABLE animal (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    animal_id VARCHAR(50) NOT NULL,
    species_breed_id INTEGER,
    name VARCHAR(50),
    date_of_birth DATE NOT NULL,
    coloration_id INTEGER,
    FOREIGN KEY (species_breed_id ) REFERENCES species_breed (id) ON DELETE SET NULL,
    FOREIGN KEY (coloration_id) REFERENCES coloration(id) ON DELETE SET NULL
);


UPDATE animals
SET name = REPLACE(name, '*', '')
WHERE name LIKE '*%';

INSERT INTO animal (animal_id, name, date_of_birth)
SELECT DISTINCT animal_id, name, date_of_birth
FROM animals;


INSERT INTO animal (species_id)
SELECT animal_species.species_id
FROM animal INNER JOIN animals ON animal.animal_id = animals.animal_id
            INNER JOIN species ON animals.animal_type = animal_species.species;

UPDATE animals
SET animal_type = 'Dog'
WHERE animal_id = 'A684346';

INSERT INTO animal (species_id)
SELECT animal_species.species_id
FROM animal INNER JOIN animals ON animal.animal_id = animals.animal_id
            INNER JOIN species ON animals.animal_type = animal_species.species
WHERE animals.animal_type = animal_species.species;


SELECT animal.animal_id, animals.animal_id, animals.animal_type, animal_species.species_id, animal_species.species
FROM animal INNER JOIN animals ON animal.animal_id = animals.animal_id
            INNER JOIN species ON animals.animal_type = animal_species.species;


CREATE TABLE coloration (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    color1_id INTEGER,
    color2_id INTEGER,
    FOREIGN KEY (color1_id) REFERENCES color(color_id) ON DELETE SET NULL,
    FOREIGN KEY (color2_id) REFERENCES color(color_id) ON DELETE SET NULL
);

CREATE TABLE species_breed (
    id INTEGER PRIMARY KEY AUTOINCREMENT ,
    species_id INTEGER,
    breed_id INTEGER,
    FOREIGN KEY (species_id) REFERENCES species(id) ON DELETE SET NULL ON UPDATE CASCADE ,
    FOREIGN KEY (breed_id) REFERENCES breed(id) ON DELETE SET NULL ON UPDATE CASCADE
    );

INSERT INTO animal (animal_id, name, date_of_birth)
SELECT DISTINCT animal_id, name, date_of_birth FROM animals;




UPDATE animal
SET species_breed_id = (SELECT breed.id
                        FROM breed INNER JOIN animals ON breed.breed_name = animals.breed)
WHERE EXISTS (SELECT breed.id
                        FROM breed INNER JOIN animals ON breed.breed_name = animals.breed);


CREATE TABLE animal (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    animal_id VARCHAR(50) NOT NULL,
    species_breed_id INTEGER,
    name VARCHAR(50),
    date_of_birth DATE NOT NULL,
    color1 VARCHAR(50),
    color2 VARCHAR(50),
    color1_id INTEGER,
    color2_id INTEGER,
    FOREIGN KEY (species_breed_id ) REFERENCES species_breed (id) ON DELETE SET NULL,
    FOREIGN KEY (color1_id) REFERENCES color(color_id) ON DELETE SET NULL,
    FOREIGN KEY (color2_id) REFERENCES color(color_id) ON DELETE SET NULL
);

INSERT INTO animal (animal_id, name, date_of_birth, color1, color2)
SELECT DISTINCT animal_id, name, date_of_birth, color1, color2
FROM animals;

INSERT INTO animal (color1_id)
SELECT color.color_id
FROM animal
INNER JOIN color ON animal.color1 = color.color_name
WHERE animal.color1_id IS NULL;

SELECT animal_id, species.species_name, breed.breed_name
FROM animal INNER JOIN species_breed ON animal.species_breed_id = species_breed.id
            INNER JOIN species ON species_breed.species_id = species.id
            INNER JOIN breed ON species_breed.breed_id = breed.id;


SELECT a.animal_id, c.color1_id, c.color2_id
FROM animal a INNER JOIN coloration c ON a.coloration_id = c.id;


-- to get colors from coloration table/ color
SELECT c1.color_name, c2.color_name
FROM coloration c
    INNER JOIN color c1 ON c.color1_id = c1.color_id
    LEFT JOIN color c2 ON c.color2_id = c2.color_id;

-- to get colors from coloration table/ color/animal
SELECT a.animal_id, c1.color_name, c2.color_name
FROM animal a
    INNER JOIN coloration c ON a.coloration_id = c.id
    INNER JOIN color c1 ON c.color1_id = c1.color_id
    LEFT JOIN color c2 ON c.color2_id = c2.color_id;


CREATE TABLE animal_outcome (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    animal_id INTEGER,
    animal_id_name VARCHAR,
    age_upon_outcome VARCHAR(50),
    outcome_subtype VARCHAR,
    outcome_subtype_id INTEGER,
    outcome_type VARCHAR,
    outcome_type_id INTEGER,
    outcome_month INTEGER,
    outcome_year INTEGER,
    FOREIGN KEY (animal_id) REFERENCES animal(id) ON DELETE SET NULL,
    FOREIGN KEY (outcome_subtype_id) REFERENCES outcome_subtype(id) ON DELETE SET NULL,
    FOREIGN KEY (outcome_type_id) REFERENCES outcome_type(id) ON DELETE SET NULL
);

INSERT INTO animal_outcome (
                            animal_id_name,
                            age_upon_outcome,
                            outcome_subtype,
                            outcome_type,
                            outcome_month,
                            outcome_year)
SELECT animal_id, age_upon_outcome, outcome_subtype, outcome_type, outcome_month, outcome_year
FROM animals;


CREATE TABLE age_unit (
     id INTEGER PRIMARY KEY AUTOINCREMENT,
     age_unit VARCHAR (20)
 );

INSERT INTO age_unit (age_unit)
VALUES ('day'),
       ('week'),
       ('month'),
       ('year');

UPDATE animal_outcome
SET age_unit_id = 1
WHERE age_upon_outcome LIKE '%day%';

UPDATE animal_outcome
SET age_unit_id = 2
WHERE age_upon_outcome LIKE '%month%';

UPDATE animal_outcome
SET age_unit_id = 4
WHERE age_upon_outcome LIKE '%year%';

SELECT ao.age_upon_outcome, au.age_unit
FROM animal_outcome ao INNER JOIN age_unit au on ao.age_unit_id = au.id;


SELECT a.animal_id,
       a.name,
       a.date_of_birth,
       s.species_name,
       sb.breed_name,
       ao.age_upon_outcome_int,
       au.age_unit,
       ao.outcome_month,
       ao.outcome_year,
       os.subtype_name,
       ot.type_name,
       c1.color_name as color1,
       c2.color_name as color2


FROM animal_outcome ao INNER JOIN animal a ON ao.animal_id = a.id
                       INNER JOIN coloration c ON a.coloration_id = c.id
                       INNER JOIN color c1 ON c.color1_id = c1.color_id
                       LEFT JOIN color c2 ON c.color2_id = c2.color_id
                       INNER JOIN species_breed sb ON a.species_breed_id = sb.id
                       INNER JOIN species s ON s.id = sb.species_id
                       LEFT JOIN outcome_subtype os on ao.outcome_subtype_id = os.id
                       INNER JOIN outcome_type ot on ao.outcome_type_id = ot.id
                       INNER JOIN age_unit au on ao.age_unit_id = au.id;

