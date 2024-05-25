# mistral-ai-hackaton

Install the api backend python dependencies:

```bash
python -m venv venv
source ven/bin/activate
cd api
pip install -r requirements.txt
```

## Test the audio to audio api endpoint

Run the api:
`python app.py`

Then request it with an audio file

```bash
curl -X POST -F 'file=@audio/I_lost_my_keys.mp3' http://127.0.0.1:5000/upload
```
