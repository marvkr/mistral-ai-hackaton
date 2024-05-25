# mistral-ai-hackaton

Run realtime conversation backend test:

`cd api && pip install -r requirements.txt`

`streamlit run streamlit.py`

## Test the audio to audio api endpoint

`python app.py`

```bash
curl -X POST -F 'file=@audio/I_lost_my_keys.mp3' http://127.0.0.1:5000/upload
```
