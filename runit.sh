# runit.sh
# 
sudo docker build -f docker/Dockerfile.blackwell -t chatterbox-tts:blackwell .

# Frontend
cp .env.example.docker .env
docker compose -f docker/docker-compose.blackwell.yml --profile frontend up -d

# API only
docker run -d \
  --name chatterbox-blackwell \
  --gpus all \
  -p 4123:4123 \
  -v $(pwd)/cache:/cache \
  -v $(pwd)/voices:/voices \
  chatterbox-tts:blackwell

docker start chatterbox-blackwell
  
# Basic use
curl -X POST http://localhost:4123/v1/audio/speech \
  -H "Content-Type: application/json" \
  -d '{"input": "Hello from Chatterbox TTS!"}' \
  --output test.wav

# Upload a voice
curl -X POST http://localhost:4123/voices \
  -F "voice_file=@/home/troy/cornball_media/LilCasey/Casey_voice_samples/FatherChristmas.mp3" \
  -F "voice_name=FatherChristmas"

# Use the voice by name in speech generation
curl -X POST http://localhost:4123/v1/audio/speech \
  -H "Content-Type: application/json" \
  -d '{"input": "Hello with my custom voice!", "exaggeration": 1.2, "cfg_weight": 0.3, "temperature": 0.9, "voice": "FatherChristmas"}' \
  --output custom_voice_output.wav

curl -sS -X POST 'http://localhost:4123/v1/audio/speech' \
  -H 'Content-Type: application/json' \
  -d '{"input":"Hello with my custom voice you pain in the ass!","voice":"FatherChristmas","temperature":0.9,"exaggeration":1.2,"cfg_weight":0.3}' \
  --output 'speech.wav'
###########################################
curl -sS -D /tmp/h -o /tmp/body.json \
  -H "Accept: application/json" \
  -X POST http://localhost:4123/upload_reference \
  -F "files=@/home/troy/cornball_media/LilCasey/Casey_voice_samples/FatherChristmas2.mp3"

curl -sS -D /tmp/h -o /tmp/body.json \
  -H "Accept: application/json" \
  -X POST http://localhost:8004/upload_reference \
  -F "files=@/home/troy/cornball_media/LilCasey/Casey_voice_samples/mothman02.mp3"