from flask import Flask, request, send_file
from werkzeug.utils import secure_filename
import os

app = Flask(__name__)

# Configure upload folder
UPLOAD_FOLDER = 'uploads'
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return 'No file part', 400
    file = request.files['file']
    if file.filename == '':
        return 'No selected file', 400
    if file:
        filename = secure_filename(file.filename)
        file_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        file.save(file_path)
        return stream_file(file_path)

def stream_file(file_path):
    def generate():
        with open(file_path, 'rb') as f:
            data = f.read(1024)
            while data:
                yield data
                data = f.read(1024)
    return app.response_class(generate(), mimetype='audio/mpeg')

if __name__ == '__main__':
    app.run(debug=True)
