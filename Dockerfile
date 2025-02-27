# 셀레니움 공식 이미지를 사용
FROM selenium/standalone-chrome:latest

# Python 3.9 베이스 이미지로 변경
FROM python:3.9-slim

# 필요한 의존성 설치
RUN apt-get update && apt-get install -y \
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
RUN pip install --no-cache-dir -r requirements.txt

# 코드 파일을 복사
COPY . .

# 환경 변수 로딩
RUN echo "GEMINI_API_KEY=${GEMINI_API_KEY}" >> .env

# FastAPI 서버 실행
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
