# main.py
import streamlit as st
from audio_recorder_streamlit import audio_recorder
from faster_whisper import WhisperModel  
from groq_chat import groq_infer  
import os 
from gtts import gTTS  

# Set page config
st.set_page_config(page_title='Groq Translator', page_icon='🎤')

# Set page title
st.title('Groq Translator')


# Load whisper model
model = WhisperModel("base", device="cpu", compute_type="int8", cpu_threads=int(os.cpu_count() / 2)) 

# Speech to text
def speech_to_text(audio_chunk): 
    segments, info = model.transcribe(audio_chunk, beam_size=5) 
    speech_text = " ".join([segment.text for segment in segments]) 
    return speech_text 

# Text to speech
def text_to_speech(translated_text, language): 
    file_name = "speech.mp3"
    my_obj = gTTS(text=translated_text, lang=language) 
    my_obj.save(file_name) 
    return file_name 


# Language selection
# option = st.selectbox(
#    "Language to translate to:",
#    languages,
#    index=None,
#    placeholder="Select language...",
# )

# Record audio
audio_bytes = audio_recorder(auto_start=False)
if audio_bytes:
    # Display audio player
    st.audio(audio_bytes, format="audio/wav")

    # Save audio to file
    with open('audio.wav', mode='wb') as f:
        f.write(audio_bytes)

    # Speech to text
    st.divider() 
    with st.spinner('Transcribing...'): 
        text = speech_to_text('audio.wav') 
    st.subheader('Transcribed Text') 
    st.write(text) 

    # Groq translation
    st.divider() 
    with st.spinner('Translating...'): 
        translation = groq_infer(text, 'en') 
    st.subheader('Translated Text to ' + option) 
    st.write(translation.text) 

    # Text to speech
    audio_file = text_to_speech(translation.text, languages[option]) 
    st.audio(audio_file, format="audio/mp3")