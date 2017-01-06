yum install R
wget https://download3.rstudio.org/centos5.9/x86_64/shiny-server-1.4.2.786-rh5-x86_64.rpm
sudo yum install --nogpgcheck shiny-server-1.4.2.786-rh5-x86_64.rpm


R -e "install.packages('shiny', repos='http://cran.rstudio.com/')"

