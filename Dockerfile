# Base image 선택 (Python 3.9)
FROM python:3.9-slim

# 필수 패키지들 설치
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
    lsb-release \
    ca-certificates \
    fonts-liberation \
    libappindicator3-1 \
    libnspr4 \
    libnss3 \
    xdg-utils \
    --no-install-recommends

# Google Chrome 저장소 추가
RUN echo "deb [signed-by=/usr/share/keyrings/google-archive-keyring.gpg] https://dl.google.com/linux/chrome/deb/ stable main" | tee -a /etc/apt/sources.list.d/google-chrome.list

# Google Chrome의 공식 GPG 키를 추가
RUN curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | tee /usr/share/keyrings/google-archive-keyring.gpg

# Chrome 설치
RUN apt-get update && apt-get install -y google-chrome-stable

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
