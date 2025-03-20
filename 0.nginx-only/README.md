# Nginx 하나만 빌드하고 실행

간단히 nginx만 빌드하고 실행해보자.

```
docker build -t nginx-only .

docker run -d -p 3000:80 nginx-only
```
이 명령어 치면 된다.