# mysql-docker
For building an old version of MySQL on my M1 laptop.

## To run:
This project uses docker to build and launch an old version of MySQL.
Run it locally by cloning and running the project with:

```shell
git clone git@github.com:smmcbride/mysql-docker.git
cd mysql-docker 
make up
```

A build has been pushed to [Docker Hub](https://hub.docker.com/repository/docker/smmcbride/mysql). To use
it in a `docker-compose.yml` file:

```shell
  mysql:
    image: smmcbride/mysql:5.6.49
    volumes:
      - mysql_volume:/var/lib/mysql
    ports:
      - 33060:3306
    environment:
      MYSQL_ROOT_PASSWORD: root_password
      MYSQL_DATABASE: database_name
...
volumes:
  mysql_volume:
```

---

### _Debugging Notes_

```shell
Build the image locally and run bash, useful for debugging:
docker build -t mysql_image .
docker run -it --name mysql --env MYSQL_ROOT_PASSWORD=real_password --env MYSQL_DATABASE=real_database -p 33060:3306 mysql_image /bin/bash
docker rm mysql;
```

Example for pushing to Docker Hub
```shell
docker tag mysql-docker_mysql:latest smmcbride/mysql:5.6.49
docker push smmcbride/mysql:5.6.49
```