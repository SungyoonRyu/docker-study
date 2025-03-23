# 1. React 빌드 단계
FROM node:18 AS builder

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build

# 2. 빌드된 파일을 Nginx 컨테이너로 복사하기 위해 export
CMD ["cp", "-r", "/app/dist", "/output"]