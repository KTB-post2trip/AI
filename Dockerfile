# Base image 선택 (Python 3.9)
FROM python:3.9-slim

# 필요한 의존성 설치 (curl, wget, chrome, chromedriver)
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    unzip \
    gnupg2 \
    libappindicator3-1 \
    libasound2 \
    libx11-xcb1 \
    libxtst6 \
    libnss3 \
    libxss1 \
    libgdk-pixbuf2.0-0 \
    google-chrome-stable

# ChromeDriver 설치
RUN CHROME_DRIVER_VERSION=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE) && \
    wget -q https://chromedriver.storage.googleapis.com/${CHROME_DRIVER_VERSION}/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip -d /usr/local/bin/ && \
    rm chromedriver_linux64.zip

# 작업 디렉토리 설정
WORKDIR /app

# 의존성 파일을 복사
COPY requirements.txt .

# Python 의존성 설치
RUN pip install --no-cache-dir -r requirements.txt

# 코드 파일을 복사
COPY . .

# 환경 변수 로딩
RUN echo "GEMINI_API_KEY=${GEMINI_API_KEY}" >> .env

# FastAPI 서버 실행
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
