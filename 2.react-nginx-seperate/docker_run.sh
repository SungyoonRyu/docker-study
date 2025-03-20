docker build -t react-builder -f react-start/Dockerfile ./react-start/
docker run --name temp-react react-builder

docker cp temp-react:/output ./nginx/build

docker build -t my-nginx-react -f nginx/Dockerfile ./nginx
docker run -d -p 80:80 my-nginx-react