# Base image 선택 (Python 3.9)
FROM python:3.9-slim

# 필요한 시스템 의존성 설치
RUN apt-get update && apt-get install -y \
    wget \
    ca-certificates \
    unzip \
    libnss3 \
    libgdk-pixbuf2.0-0 \
    libasound2 \
    curl \
    && rm -rf /var/lib/apt/lists/*

# chromium 설치 (deb 파일을 다운로드하여 설치)
RUN curl -sSL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o google-chrome.deb && \
    dpkg -i google-chrome.deb && \
    apt-get -y --fix-broken install && \
    rm google-chrome.deb

# chromedriver 수동 다운로드 및 설치
RUN wget https://chromedriver.storage.googleapis.com/112.0.5615.49/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip && \
    mv chromedriver /usr/local/bin/ && \
    rm chromedriver_linux64.zip

# 작업 디렉토리 설정
WORKDIR /app

# 의존성 파일을 복사
COPY requirements.txt .

# 의존성 설치
RUN pip install --no-cache-dir -r requirements.txt

# 코드 파일을 복사
COPY . .

# 환경 변수 로딩
RUN echo "GEMINI_API_KEY=${GEMINI_API_KEY}" >> .env

# Chrome 브라우저와 chromedriver의 경로를 환경 변수로 설정
ENV CHROME_BIN=/usr/bin/google-chrome
ENV DISPLAY=:99

# FastAPI 서버 실행
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
