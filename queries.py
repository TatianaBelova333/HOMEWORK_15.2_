import sqlite3

# Выборка уникальных пород
con = sqlite3.connect('animal.db')
cur = con.cursor()
query_1 = """
      SELECT DISTINCT breed
      FROM animals;
"""
cur.execute(query_1)
breeds = cur.execute(query_1).fetchall()
con.close()

# Поиск строк с несколькими породами, вычленение пород, удаление дублей и добавление в отдельную таблицу (breed)

unsplit_breeds = []
for breed in breeds:
    for el in breed:
        if '/' in el:
            unsplit_breeds.extend(el.split('/'))
        else:
            unsplit_breeds.append(el)

new_breeds = [(x,) for x in set(unsplit_breeds)]


con = sqlite3.connect('animal.db')
cur = con.cursor()
query_2 = """
      INSERT INTO breed(breed_name)
      VALUES(?);
"""
cur.executemany(query_2, new_breeds)
con.commit()
con.close()


con = sqlite3.connect('animal.db')
cur = con.cursor()
query_1 = """
      SELECT color_name
      FROM color;
"""
cur.execute(query_1)
colors = cur.execute(query_1).fetchall()
con.close()
colors = [x[0] for x in colors]
print(colors)


con = sqlite3.connect('animal.db')
cur = con.cursor()
for color in colors:
    query_2 = """UPDATE animal 
                 SET color2_id = (SELECT color.color_id
                                  FROM color
                                       INNER JOIN animal 
                                       ON animal.color2 = color.color_name
                                       WHERE color.color_name = ?)
                 WHERE color2 = ?
                 """
    cur.execute(query_2, (color, color))
    con.commit()


con = sqlite3.connect('animal.db')
cur = con.cursor()
query_1 = """
      SELECT breed_name
      FROM breed;
"""
cur.execute(query_1)
breeds = cur.execute(query_1).fetchall()
con.close()
breeds = [x[0] for x in breeds]
print(breeds)


con = sqlite3.connect('animal.db')
cur = con.cursor()
for breed in breeds:
    query_2 = """UPDATE animal 
                 SET species_breed_id = (SELECT breed.id
                                         FROM breed
                                         INNER JOIN animal 
                                         ON animal.breed = breed.breed_name
                                         WHERE breed.breed_name = ?)
                 WHERE breed = ?
                 """
    cur.execute(query_2, (breed, breed))
    con.commit()

con = sqlite3.connect('animal.db')
cur = con.cursor()
query_1 = """
      SELECT color1_id, color2_id
      FROM animal;
"""
cur.execute(query_1)
colors = cur.execute(query_1).fetchall()
con.close()
colors = set(colors)


con = sqlite3.connect('animal.db')
cur = con.cursor()
query_2 = """
      INSERT INTO coloration(color1_id, color2_id)
      VALUES(?, ?);
"""
for item in colors:
    cur.execute(query_2, item)
con.commit()


con = sqlite3.connect('animal.db')
cur = con.cursor()
query_2 = """
      UPDATE animal
      SET coloration_id = ?
      WHERE color1_id = ? AND color2_id =?;
"""
for item in colors:
    cur.execute(query_2, item)
con.commit()


con = sqlite3.connect('animal.db')
cur = con.cursor()
query_1 = """
      SELECT id, color1_id, color2_id
      FROM coloration;
"""
cur.execute(query_1)
colors = cur.execute(query_1).fetchall()
con.close()
print(colors)


con = sqlite3.connect('animal.db')
cur = con.cursor()
query_2 = """
      UPDATE animal
      SET coloration_id = ?
      WHERE color1_id = ? AND color2_id IS ?;
"""
for item in colors:
    cur.execute(query_2, item)
con.commit()

con = sqlite3.connect('animal.db')
cur = con.cursor()
query_1 = """
      SELECT breed_name, id
      FROM breed;
"""
cur.execute(query_1)
breeds = cur.execute(query_1).fetchall()
con.close()

print(breeds)

con = sqlite3.connect('animal.db')
cur = con.cursor()
for breed in breeds:
    query_2 = """UPDATE species_breed 
                 SET breed_name = ?
                 WHERE breed_id = ?
                 """
    cur.execute(query_2, (breed[0], breed[1]))

    con = sqlite3.connect('animal.db')
    cur = con.cursor()
    query_1 = """
          SELECT id, animal_id
          FROM animal;
    """
    cur.execute(query_1)
    animals = cur.execute(query_1).fetchall()
    con.close()

    print(animals)

    con = sqlite3.connect('animal.db')
    cur = con.cursor()
    for animal in animals:
        query_2 = """UPDATE animal_outcome 
                     SET animal_id = ?
                     WHERE animal_id_name = ?
                     """
        cur.execute(query_2, (animal[0], animal[1]))
    con.commit()


con = sqlite3.connect('animal.db')
cur = con.cursor()
query_1 = """
          SELECT id, type_name
          FROM outcome_type;
    """
cur.execute(query_1)
subtypes = cur.execute(query_1).fetchall()
con.close()

print(subtypes)

con = sqlite3.connect('animal.db')
cur = con.cursor()
for subtype in subtypes:
    query_2 = """UPDATE animal_outcome 
                 SET outcome_type_id = ?
                 WHERE outcome_type = ?;
            """
    cur.execute(query_2, (subtype[0], subtype[1]))
con.commit()


con = sqlite3.connect('animal.db')
cur = con.cursor()
query_1 = """
          SELECT age_upon_outcome
          FROM animal_outcome;
    """
cur.execute(query_1)
subtypes = cur.execute(query_1).fetchall()
con.close()
print(subtypes)
numbers = list(set([int(x[0].split()[0]) for x in subtypes]))
params = []
for num in numbers:
    t = (str(num) + '%', num)
    params.append(t)


con = sqlite3.connect('animal.db')
cur = con.cursor()
for param in params:
    query_2 = """UPDATE animal_outcome 
                 SET age_upon_outcome_int = ?
                 WHERE age_upon_outcome LIKE ?;
            """
    cur.execute(query_2, (param[1], param[0]))
con.commit()