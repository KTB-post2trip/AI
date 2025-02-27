# Base image 선택 (Python 3.9)
FROM python:3.9-slim

# 필요한 시스템 의존성 설치
RUN apt-get update && apt-get install -y \
    wget \
    ca-certificates \
    unzip \
    chromium \
    libnss3 \
    libgdk-pixbuf2.0-0 \
    libasound2 \
    curl \
    && rm -rf /var/lib/apt/lists/*

# ChromeDriver 설치
RUN CHROMEDRIVER_VERSION=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE) && \
    wget https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip -O /tmp/chromedriver.zip && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
    rm /tmp/chromedriver.zip

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
ENV CHROME_BIN=/usr/bin/chromium
ENV DISPLAY=:99
ENV CHROMEDRIVER_PATH=/usr/local/bin/chromedriver

# FastAPI 서버 실행
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
