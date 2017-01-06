yum install mysql-devel
R -e "install.packages('shiny', repos='http://cran.rstudio.com/')"
R -e "install.packages('DBI', repos='http://cran.rstudio.com/')"
R -e "install.packages('ggplot2', repos='http://cran.rstudio.com/')"
R -e "install.packages('RMySQL', repos='http://cran.rstudio.com/')"

cp -R ../drug-count/ /srv/shiny-server/sample-apps/