**This is a project of INFO550**

The dataset is a Real Breast Cancer Data from Kaggle (URL: https://www.kaggle.com/amandam1/breastcancerdataset) (Find the Description and Download the Data in Kaggle)

## Prerequisite  
**Docker is required in terminal**  
All the packages in R have been packed to my Docker image  

## About renv  
I use two methods to use renv auto-loader in building image
```bash
RUN Rscript -e 'renv::restore()' -y
RUN R --vanilla -s -e 'renv::restore()'
```
The first one is faster, but sometimes it will fail to activate the environment in container.  

## Docker image
My docker image is qingzh11/info_550:old_pandoc  
https://hub.docker.com/repository/docker/qingzh11/info550  
The pandoc version = 1.9 in order to run it in Mac based docker.  
```bash
# Pull the image into local.
docker pull qingzh11/info550:old_pandoc
```

## Execute the analysis
**1. Download the project and checkout the directory**  
```bash
## clone the repository
git clone https://github.com/QingZHANG98/INFO550_project.git

## checkout the repository
cd INFO550_project # or your_project_path
```
**2. Build a new image to make report**  
```bash
# If you have a pull of qingzh11/info550:old_pandoc, it will be faster.
docker build -t info550 .
```
**3. Run the container and make report**  
It will update the report in local directory  
```bash
docker run -v ${PWD}:/INFO550_project info550
```
**OR**  
- Open container without entrypoint.  
```bash
docker run -it -v ${PWD}:/INFO550_project --entrypoint /bin/bash info550
make report
```
- Stop container and exit.  
```bash
exit
```

**4. Open the report file**  
```bash
open ./report/report_Rmd/report.html
```
