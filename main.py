from flask import Flask, jsonify
import utils

app = Flask(__name__)
app.config['JSON_AS_ASCII'] = False
app.config["JSON_SORT_KEYS"] = False


@app.route('/<int:record_id>')
def show_record_info(record_id):
    try:
        record_info = utils.search_by_record_id(record_id)
        return jsonify(record_info)
    except:
        return 'Информация не найдена'


if __name__ == '__main__':
    app.run()