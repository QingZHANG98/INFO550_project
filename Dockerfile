FROM qingzh11/info550:old_pandoc

# copy contents of local folder to project folder in container
COPY ./ /INFO550_project/

# make R scripts executable
RUN chmod +x /INFO550_project/report/R/*.R
RUN chmod +x /INFO550_project/report/report_Rmd/*.Rmd

RUN Rscript -e "renv::restore()" -y

WORKDIR /INFO550_project

# make container entry point
CMD make report


