$Env:DOCKER_BUILDKIT=1
docker build -t my-static-site .
docker run -p 8080:80 my-static-site