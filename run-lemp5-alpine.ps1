docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker build $(Get-Location)/. -t crazyyoshi/lemp5-alpine:latest
docker run -d -p 80:80 crazyyoshi/lemp5-alpine:latest