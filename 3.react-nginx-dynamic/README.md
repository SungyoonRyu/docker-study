# 리액트와 Nginx '완전히' 분리하기
2번 프로젝트의 단점을 보완하기 위해 만든 프로젝트이다.   
React 프로젝트를 빌드하면 자동으로 Nginx의 파일을 바꾸도록 해서 React 빌드시 Nginx나 다른 프로젝트 빌드가 없도록 하는 것이 목적이다.

큰 흐름은 `2.react-nginx-seperate`와 크게 다른 점이 없다.

React 빌드 부분은 거의 같다. React 프로젝트를 빌드하는 도커 파일이다.  
여기서 봐야할 점은 docker 파일의 실행 시점에 뭐가 실행되냐.
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
CMD 이전에 npm run build는 docker build 타이밍에 확정된다. 그리고 docker run에서는 CMD의 구문만 실행된다. 그 의미는 React 프로젝트의 내용이 바뀌어도 docker의 실행에는 영향을 주지 않는다. 그렇기에 React 프로젝트가 변경되면 react-build 도커의 컨테이너 또한 다시 build 되어야 한다는 것이다.

Nginx Dockerfile 설정은 더 줄었다. 파일을 복사하여 리소스를 넣는 방식이 아닌, bind 되어있는 디렉토리를 사용하는 방식이기에 그 부분이 줄었다. 이번에는 `default.conf`도 안써서 그냥 nginx 컨테이너를 그냥 올린 것과 차이가 없다.


수정하면 다시 빌드해야한다는 것

# 추가 보완해야 할 점
/build/assets에 컴파일된 js 파일이 늘어난다. 빌드과정에서 js 파일의 index를 해쉬(?인지는 모르지만) 비스무리한 문자열로 파일명을 잡는데, `docker cp`를 쓰면서 덮어쓰기가 아니라 늘어난다. 기존 것을 일일이 지울 수도 있겠지만, 음... 

React의 빌드도 안하게 하는 방법이 있을 것 같다. React 프로젝트도 volume이나 bind로 빌드 도커에 mount하고 CMD를 npm build로 하는 방법이 있을텐데, 이렇게 되면 근본적이 질문을 하게 된다.   
그럼 Dockerising하는 이유가 뭐지...?   
물론 CI/CD나 Container에 대한 목적과 의도를 더 알게된 후 답변할 수 있을 것 같다. 여기 부분은 Docker와 CI/CD에 대해 더 학습한 후 진행하도록 하자.