FROM rocker/shiny:latest
ADD . /srv/shiny-server/app_c_rex
ADD shiny-server.conf /etc/shiny-server
RUN  echo 'install.packages(c("ggplot2","shiny"), \
repos="http://cran.us.r-project.org", \
dependencies=TRUE)' > /tmp/packages.R \
  && Rscript /tmp/packages.R

EXPOSE 3838
CMD ["/srv/shiny-server/app_c_rex/shiny-server.sh"]
