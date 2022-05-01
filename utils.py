import sqlite3


def connect_to_sqlite_database(database_path, sqlite_query, params):
    with sqlite3.connect(database_path) as connection:
        cursor = connection.cursor()
        data_raw = cursor.execute(sqlite_query, params).fetchall()
    return data_raw


def search_by_record_id(record_id):
    query = """
             SELECT ao.id,
                    a.animal_id,
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
                       INNER JOIN age_unit au on ao.age_unit_id = au.id
             WHERE ao.id = ?;
                       """
    data_raw = connect_to_sqlite_database('animal.db', query, (record_id,))
    record_info = data_raw[0]
    record_info_dict = {
        'record_id': record_info[0],
        'animal_id': record_info[1],
        'animal_name': record_info[2],
        'date_of_birth': record_info[3],
        'animal_type': record_info[4],
        'animal_breed': record_info[5],
        'outcome_age': ' '.join([str(record_info[6]), record_info[7]]),
        'outcome_month': record_info[8],
        'outcome_year': record_info[9],
        'outcome_subtype': record_info[10],
        'outcome_type': record_info[11],
        'coloration': record_info[12:]
    }
    return record_info_dict


if __name__ == '__main__':
    pass


