# 1. Build and run React builder docker
docker build -t 3-react-builder ./react-start
docker run --name temp-react 3-react-builder

# 2. Copy output to bind directory for nginx
docker cp temp-react:/output ./build
docker rm temp-react

# 3. Build nginx docker and Run(bind setting)
docker build -t my-nginx ./nginx
docker run -d --mount type=bind,source="$(pwd)/build",target="/usr/share/nginx/html" -p 80:80 my-nginx

# these are also available

# get rid of double quote
# docker run -d --mount type=bind,source=$(pwd)/build,target=/usr/share/nginx/html -p 80:80 my-nginx

# this can be error. maybe by git bash
# docker run -d -v ./build:/usr/share/nginx/html -p 80:80 my-nginx