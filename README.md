# rocker-c-rex
**Those source code are prepared to build a docker image of shiny web application called C-REx**

Installation as follow:

_Step 1_:
download this repository to your local machine

_Step 2_:
install and start docker 
(if you need more help about docker, please refer to docker website: https://docs.docker.com/install/)

_Step 3_:
unzip rocker-c-rex.zip file and cd to local dir and on command line type to build your local docker image: 
>docker build --tag c_rex .

_Step 4_:
run docker image by command line: 
>docker run c_rex

(Note: The default port set as 3838)
Finally the new shiny application website is available at local: 0.0.0.0:3838/app_c_rex
