# React Nginx seperate
리액트와 nginx를 분리하려는 시도이다.

GPT와 대화하면서 알게된 내용이다.
목표한 방향은 아니지만 뭔가 배울만한 것들이 있는것 같아 남긴다.

### React 프로젝트 만들기/받아오기
만들든 불러오든 React 프로젝트가 있다고 합시다.   
`npm i`까지 진행. package-lock.json 만들기.

### React Dockerfile
```docker
# 1. React 빌드 단계
FROM node:18 AS builder

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build

# 2. 빌드된 파일을 Nginx 컨테이너로 복사하기 위해 export
CMD ["cp", "-r", "/app/dist", "/output"]
```


### nginx 폴더
```nginx
server {
    listen 80;
    server_name localhost;

    root /usr/share/nginx/html;
    index index.html;
    
    location / {
        try_files $uri /index.html;
    }

    error_page 404 /index.html;
}
```

Dockerfile
```docker
FROM nginx:alpine

# Nginx 설정 파일 복사
COPY default.conf /etc/nginx/conf.d/default.conf

# React 빌드된 정적 파일을 Nginx HTML 폴더로 복사
COPY ./build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```
복사한 build 디렉터리를 nginx의 index로 삽입.


지피티의 답변을 수정해서 되는 형태의 명령어로 구성했다.
```
docker build -t react-builder -f react-start/Dockerfile ./react-start/
docker run --name temp-react react-builder

docker cp temp-react:/output ./nginx/build

docker build -t my-nginx-react -f nginx/Dockerfile ./nginx
docker run -d -p 80:80 my-nginx-react
```
실행위치는 nginx와 react-start 상위인 parent라는 것을 알아두자.   
여기서 놀라운 점은 `docker cp` 명령어였다. 난 멈춘 컨테이너는 파일 접근이 안되는줄 알았는데 아니었다.

위 명령어들을 sh 파일 `docker_run.sh`로 생성했다.
```
. docker_run.sh
```
로 실행시키면 동작한다.