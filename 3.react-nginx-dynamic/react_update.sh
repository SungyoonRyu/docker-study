# 1. Build and run React builder docker
docker build -t 3-react-builder ./react-start
docker run --name temp-react 3-react-builder

# 2. Copy output to bind directory for nginx
rm -rf ./build
docker cp temp-react:/output ./build
# docker cp temp-react:/output/. ./build/.    # copy content of outupt dircetory
docker rm temp-react
