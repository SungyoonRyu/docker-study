FROM nginx:alpine

# Nginx 설정 파일 복사
COPY default.conf /etc/nginx/conf.d/default.conf

# React 빌드된 정적 파일을 Nginx HTML 폴더로 복사
COPY ./build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]