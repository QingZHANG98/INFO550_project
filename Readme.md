**This is a project of INFO550**

The dataset is a Real Breast Cancer Data from Kaggle (URL: https://www.kaggle.com/amandam1/breastcancerdataset) (Find the Description and Download the Data in Kaggle) The path of your csv.file is defined as "Path" variable in R code.

More questions please report ISSUES or email me [qzha284@emory.edu](mailto:qzha284@emory.edu)

This report is made by R 4.1.1. Make sure R >= 4.0 has been installed. R packages 'renv' is needed. All versions of packages are locked by renv. 



**Download the project and checkout the directory**

```
## clone the repository
git clone https://github.com/QingZHANG98/INFO550_project.git

## checkout the repository
## If you unzip the project, check the structure of your directory. It could be INFO550_project/INFO550_project in come system

cd INFO550_project
```

**Go to the R session:**

```
if(!require(renv)){
  install.packages("renv")
  require(renv)
}
```

```
## activate the environment
renv::activate("./") ## "./" is the path of renv. If you have checkout
```



## Execute the analysis

```
make report
```

## Open the report

```
open ./report/report_Rmd/report.html
```



