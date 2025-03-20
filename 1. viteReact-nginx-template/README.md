# React + Vite + Nginx

## 개요
Vite로 만든 React 프로젝트를 Nginx로 배포하는 형태의 가장 기본적인 Docker이다.  
React와 Nginx가 함께 설정되고 빌드되는 Docker Container.

대충 순서는 이렇다.
1. vite를 통한 react 프로젝트 만들기(기존에 존재한다면 받아오기)
2. npm 설치(이것도 사실 선택적, Dockerfile 수정이 필요하긴 함)


## 설명

### React 프로젝트 받아오기
```
npm create vite@latest
```

### npm 설치(사실 package-lock.json 생성)
```
npm i
```
Dockerfile에 package-lock.json을 copy하는 부분이 있기 때문에 해주는 것.   
기존 프로젝트를 받아서 package-lock.json이 존재한다면 `npm i`가 필요없긴 함.


### Dockerfile 생성
두번 base image를 불러오고 nginx를 사용하는 파일 내용.   
react를 빌드하고 해당 build 된 결과를 nginx의 index로 잡아주는 과정이라고 볼 수 있다.

여기서 주의할 건 nginx에 damone off를 붙여줘야 nginx 정지 없이 동작 가능하다고 한다.   
참조 : https://stackoverflow.com/questions/18861300/how-to-run-nginx-within-a-docker-container-without-halting


### docker 빌드
맘대로 빌드하면 됨.
```
docker build -t reate-nginx-template .
```

### docker 실행
도착포트 80으로 설정하는거 말곤 여기서 맞출 것은 없음.
```
docker run -d -p 3000:80 reate-nginx-template
```
nginx의 기본 포트가 80이니 이런식으로 dest-port를 80으로 잡아줌.
이걸 어케아냐?   
`/etc/nginx/conf.d/default.conf`에 기본 config 파일이 있는데 거기 적혀 있음.   
밑에 이 부분 바꾸는 방법 참조.


## 선택사항, 추가 설정
nginx.conf 생성(파일 참고)
```docker
...
COPY --from=build /app/dist /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 3000
...
```
이런 식으로 nginx.conf, 그러니까 nginx의 설정을 직접 넣어줄 수도 있다.

nginx.conf의 예시
```
server {
    listen 3000;
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
    location / {
        # root를 /usr/share/nginx/html 을 바라보게 했으므로(Dockerfile 참고)
        # 해당 경로 아래에 배포해주면 됩니다.
        root   /usr/share/nginx/html;
        index  index.html index.htm;
        try_files $uri $uri/ /index.html;
    }
}
```
이런식으로 하면 listen port도 바꿀 수 있고(예시는 3000), 더 세세하게 nginx를 바꿀 수 있다.   
사실 이 내용은 기본 default.conf랑 큰 차이가 없음.
