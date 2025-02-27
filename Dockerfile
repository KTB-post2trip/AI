# 셀레니움 공식 이미지를 사용 (chromium과 chromedriver가 이미 설치됨)
FROM selenium/standalone-chrome:latest

# 필요한 시스템 의존성 설치 (Python 3.9 포함)
USER root
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-dev \
    wget \
    ca-certificates \
    unzip \
    libnss3 \
    libgdk-pixbuf2.0-0 \
    libasound2 \
    && rm -rf /var/lib/apt/lists/*

# 작업 디렉토리 설정
WORKDIR /app

# 의존성 파일을 복사
COPY requirements.txt .

# 의존성 설치
RUN pip3 install --no-cache-dir -r requirements.txt

# 코드 파일을 복사
COPY . .

# 환경 변수 로딩 (필요시)
RUN echo "GEMINI_API_KEY=${GEMINI_API_KEY}" >> .env

# FastAPI 서버 실행
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
