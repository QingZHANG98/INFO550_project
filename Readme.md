**This is a project of INFO550**

The dataset is a Real Breast Cancer Data from Kaggle (URL: https://www.kaggle.com/amandam1/breastcancerdataset) (Find the Description and Download the Data in Kaggle)

## Prerequisite
**Docker is required in terminal**
All the packages in R have been packed to my Docker image

## Docker image
My docker images is qingzh11/info_550:old_pandoc
The pandoc version = 1.9 in order to run it in Mac based docker.
```bash
# Pull the image into local.
docker pull qingzh11/info550:old_pandoc
```

## Execute the analysis
**Download the project and checkout the directory**
```bash
## clone the repository
git clone https://github.com/QingZHANG98/INFO550_project.git

## checkout the repository
cd INFO550_project # or your_project_path
```
**Build a new image to make report**
```bash
# If you have a pull of qingzh11/info550:old_pandoc, it will be faster.
docker build -t info550 .
```
**Run the container and make report**
It will update the report in local directory
```bash
docker run -v ${PWD}:/INFO550_project info550
```
**Open the report file**
```bash
open ./report/report_Rmd/report.html
```