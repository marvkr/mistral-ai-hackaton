# main.py
import streamlit as st
from audio_recorder_streamlit import audio_recorder
from faster_whisper import WhisperModel
from groq_chat import groq_infer
import os
from audio import speech_to_text, text_to_speech

# Set page config
st.set_page_config(page_title="Groq Translator", page_icon="🎤")

# Set page title
st.title("Groq Translator")


# Load whisper model
model = WhisperModel(
    "base", device="cpu", compute_type="int8", cpu_threads=int(os.cpu_count() / 2)
)

show_record = st.button(label="Show translate")

# Record audio
audio_bytes = audio_recorder(
    auto_start=False,
)
if audio_bytes:
    # Display audio player
    st.audio(audio_bytes, format="audio/wav")

    # Save audio to file
    with open("audio.wav", mode="wb") as f:
        f.write(audio_bytes)

    # Speech to text
    st.divider()
    with st.spinner("Transcribing..."):
        text = speech_to_text("audio.wav")
    st.subheader("Transcribed Text")
    st.write(text)

    # Groq chat
    st.divider()
    with st.spinner("Translating..."):
        response = groq_infer(text)
    st.subheader("Answer")
    st.write(response)

    # Text to speech
    audio_file = text_to_speech(response)
    st.audio(audio_file, format="audio/mp3")
