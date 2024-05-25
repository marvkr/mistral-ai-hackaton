from faster_whisper import WhisperModel
import os
from gtts import gTTS

# Load whisper model
model = WhisperModel(
    "base", device="cpu", compute_type="int8", cpu_threads=int(os.cpu_count() / 2)
)


# Speech to text
def speech_to_text(audio_file: str):
    segments, info = model.transcribe(audio_file, beam_size=5)
    speech_text = " ".join([segment.text for segment in segments])
    return speech_text


# Text to speech
def text_to_speech(translated_text, language, filename):
    my_obj = gTTS(text=translated_text, lang=language)
    my_obj.save(filename)
    return filename
