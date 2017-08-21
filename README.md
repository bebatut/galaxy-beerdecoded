Galaxy for BeerDeCoded
===============

[![Docker Repository on Quay](https://quay.io/repository/bebatut/galaxy-beerdecoded/status "Docker Repository on Quay")](https://quay.io/repository/bebatut/galaxy-beerdecoded)

[BeerDeCoded](http://www.genome.beer/) is a participatory project investigate the microbial composition of a collection of commercial beers. The goal of the BeerDeCoded project is not only to extend the scientific knowledge about beer, but also to improve the public understanding of issues related to personal geno- mics, food technology, and their role in society.

For the data analysis, the BeerDeCoded project is using [Galaxy](https://galaxyproject.org/), inside a [Galaxy Docker flavor](http://bgruening.github.io/docker-galaxy-stable/) based on [ASaiM](http://asaim.readthedocs.io/en/latest/).

# Usage

## Requirements

To use Galaxy for BeerDeCoded, [Docker](https://www.docker.com/products/overview#h_installation) is required (except if you want to [setup and run the framework without using Docker](#installation-and-use-without-using-docker)). 

For Linux users and people familiar with the command line, please follow the [very good instructions](https://docs.docker.com/installation/) from the Docker project. Non-Linux users are encouraged to use [Kitematic](https://kitematic.com), a graphical User-Interface for managing Docker containers.

## Launch

1. Starting the Docker container with Galaxy for BeerDeCoded: analogous to starting the generic Galaxy Docker image: 

    ```
    $ docker run -d -p 8080:80 quay.io/bebatut/galaxy-beerdecoded
    ```

    Nevertheless, here is a quick rundown: 

    - `docker run` starts the Image/Container

        In case the Container is not already stored locally, Docker downloads it automatically
       
    - The argument `-p 8080:80` makes the port 80 (inside of the container) available on port 8080 on your host

        Inside the container a Apache web server is running on port 80 and that port can be bound to a local port on your host computer. 
        With this parameter you can access your Galaxy instance via `http://localhost:8080` immediately after executing the command above
        
    - `quay.io/bebatut/galaxy-beerdecoded` is the Image/Container name, that directs Docker to the correct path in the [Docker index](https://index.docker.io/u/bgruening/galaxy-rna-workbench/)
    - `-d` will start the Docker container in Daemon mode. 

    > A detailed discussion of Docker's parameters is given in the [Docker manual](http://docs.docker.io/). It is really worth reading.

    The Docker container is run: Galaxy will be launched!

    > Setting up Galaxy and its components can take several minutes. You can inspect the state of the starting using:
    > ```
    > $ docker ps # to obtain the id of the container
    > $ docker logs <container_id>
    > ```

    The previous commands will configure, launch and populate Galaxy with the needed tools, workflows and databases. The instance will be accessible at [http://localhost:8080](http://localhost:8080).

2. Installation of the databases once Galaxy is running

    ```
    $ docker exec <container_id> run_data_managers
    ```


#### Workflows

To access to the workflows, you need to connect with the admin user (username: `admin@galaxy.org`, password: `admin`). And you will have access to the workflows in the 'Workflow' section (Top panel)

#### Databases

Databases are automatically added to the Galaxy instance for MetaPhlAn2, HUMAnN2 and QIIME.

Sometimes the databases are not correctly seen by the tools. If it is the case, you need to force the connection between the tool and the database:

- Connect with the admin user: 
    - username `admin@galaxy.org` 
    - password `admin`
- Go to the 'Admin' section (Top panel)
- Go to 'Local data' section (Left panel)
- Click on `humann2_nucleotide_database`, `humann2_protein_database` or `metaphlan2_database` (depending on the database)
- Click on the 'Reload button' on the top
    
    The table must be filled

If you want other databases for HUMAnN2 or QIIME, you can install them "manually":

- Connect with the admin user: 
    - username `admin@galaxy.org` 
    - password `admin`
- Go to the 'Admin' section (Top panel)
- Go to 'Local data' section (Left panel)
- Click on 'HUMAnN2 download' (or 'Download QIIME') and choose the database you want to import

### Interactive session

For an interactive session, you can execute:

```
$ docker run -i -t -p 8080:80 quay.io/bebatut/galaxy-beerdecoded /bin/bash
```

and manually invokes the `startup` script to start PostgreSQL, Apache and Galaxy and download the need databases.

> For a more specific configuration, you can have a look at the [documentation of the Galaxy Docker Image](http://bgruening.github.io/docker-galaxy-stable/).

### Data

Docker images are "read-only". All changes during one session are lost after restart. This mode is useful to present ASaiM to your colleagues or to run workshops with it. 

To install Tool Shed repositories or to save your data, you need to export the computed data to the host computer. Fortunately, this is as easy as:

```
$ docker run -d -p 8080:80 -v /home/user/galaxy_storage/:/export/ quay.io/bebatut/galaxy-beerdecoded
```

Given the additional `-v /home/user/galaxy_storage/:/export/` parameter, Docker will mount the folder `/home/user/galaxy_storage` into the Container under `/export/`. A `startup.sh` script, that is usually starting Apache, PostgreSQL and Galaxy, will recognize the export directory with one of the following outcomes:

- In case of an empty `/export/` directory, it will move the [PostgreSQL](http://www.postgresql.org/) database, the Galaxy database directory, Shed Tools and Tool Dependencies and various configure scripts to /export/ and symlink back to the original location.
- In case of a non-empty `/export/`, for example if you continue a previous session within the same folder, nothing will be moved, but the symlinks will be created.

This enables you to have different export folders for different sessions - meaning real separation of your different projects.

### Users & Passwords

The Galaxy Admin User has the username `admin@galaxy.org` and the password `admin`.

The PostgreSQL username is `galaxy`, the password `galaxy` and the database name `galaxy`.
If you want to create new users, please make sure to use the `/export/` volume. Otherwise your user will be removed after your Docker session is finished.

### Stoping Galaxy

Once you are done with Galaxy, you can kill the container:

```
$ docker ps # to obtain the id of the container
$ docker kill <container_id>
```

> The image corresponding to the container will stay in memory. If you want to clean fully your Docker engine, you can follow the [Docker Cleanup Commands](https://www.calazan.com/docker-cleanup-commands/).

# Documentation

Available tools and workflows in ASaiM framework (on which the current instance is based) are described in the documentation available at [http://asaim.readthedocs.org/](http://asaim.readthedocs.org/en/latest/framework/index.html).

# Bug Reports

Any bug can be filed in an issue [here](https://github.com/bebatut/galaxy-beerdecoded/issues).

# License

Galaxy for BeerDeCoded is released under Apache 2 License. See the [LICENSE](LICENSE) file for details.