**This is a project of INFO550**

The dataset is a Real Breast Cancer Data from Kaggle (URL: https://www.kaggle.com/amandam1/breastcancerdataset) (Find the Description and Download the Data in Kaggle) The path of your csv.file is defined as "Path" variable in R code.

More questions please report ISSUES or email me [qzha284@emory.edu](mailto:qzha284@emory.edu)

## Prerequisite
**Docker is required**
All the packages in R have been packed to my Docker image

**Download the project and checkout the directory**

```
## clone the repository
git clone https://github.com/QingZHANG98/INFO550_project.git

## checkout the repository
## If you download and unzip the project, check the structure and name of your directory. It could be INFO550_project/INFO550_project or INFO550_project-master ...

cd INFO550_project # project_path
```
## Go to the docker
My docker images is qingzh11/info_550

Pull the image into local.
Note: the pandoc version = 1.9 otherwise I cannot run it in Mac based docker.
```
docker pull qingzh11/info550:old_pandoc
```
## Execute the analysis
make report
```
## Open the report
```
open ./report/report_Rmd/report.html
```



