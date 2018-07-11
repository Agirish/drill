# How to build an Apache Drill Docker image

## Prerequisites

To build an Apache Drill docker image, you need to have the following software installed on your system to successfully complete a build. 
  * Java 8
  * Maven 3.3.1 or greater
  * Docker 18 or greater

## Confirm settings
    # java -version
    java version "1.8.0_161"
    Java(TM) SE Runtime Environment (build 1.8.0_161-b12)
    Java HotSpot(TM) 64-Bit Server VM (build 25.161-b12, mixed mode)

    # mvn --version
    Apache Maven 3.3.1 (cab6659f9874fa96462afef40fcf6bc033d58c1c; 2015-03-13T13:10:27-07:00)
    
    # $ docker version
    Client:
     Version:      18.03.1-ce
     API version:  1.37
     Go version:   go1.9.5
     Git commit:   9ee9f40
     Built:        Thu Apr 26 07:13:02 2018
     OS/Arch:      darwin/amd64
     Experimental: false
     Orchestrator: swarm

    Server:
     Engine:
      Version:      18.03.1-ce
      API version:  1.37 (minimum version 1.12)
      Go version:   go1.9.5
      Git commit:   9ee9f40
      Built:        Thu Apr 26 07:22:38 2018
      OS/Arch:      linux/amd64
      Experimental: true

## Checkout

    git clone https://github.com/apache/drill.git
    
## Build Drill

    cd drill
    mvn clean install
    
## Build Docker Image

    cd distribution
    mvn dockerfile:build -Pdocker
    
## Push Docker Image
   
   By default, the image built above is configured to be pushed to [Drill Docker Hub](https://hub.docker.com/r/drill/apache-drill/) to create official Drill Docker images. You can configure the repository in pom.xml to point to any private or public container registry.
   
    cd distribution
    mvn dockerfile:push -Pdocker
    
  To push the image to a different repository,
  
    cd distribution
    mvn dockerfile:push -Pdocker -Pdocker.repository=<my_repo>

## Run Docker Container
   
   Running the Docker container should start Drill in embedded mode and connect to Sqlline
    
    docker run -i -t drill/apache-drill:1.14.0 /bin/bash
    Jun 29, 2018 3:28:21 AM org.glassfish.jersey.server.ApplicationHandler initialize
    INFO: Initiating Jersey application, version Jersey: 2.8 2014-04-29 01:25:26...
    apache drill 1.14.0-SNAPSHOT 
    "json ain't no thang"
    0: jdbc:drill:zk=local> select version from sys.version;
    +------------------+
    |     version      |
    +------------------+
    | 1.14.0  |
    +------------------+
    1 row selected (0.28 seconds)
      

## Start a new SQLLine session 
    
   You can start new stand-alone sessions of Sqlline
    
    docker exec -it <CONTAINER_ID> bash
    
    $ /opt/drill/bin/drill-localhost 
     apache drill 1.14.0 
     "drill baby drill"
     0: jdbc:drill:drillbit=localhost>

## Run a query

    SELECT 
      employee_id, 
      first_name
    FROM cp.`employee.json`; 
    
## More information 

For more information including how to run Apache Drill in a Docker container, visit the [Apache Drill Documentation](http://drill.apache.org/docs/)
