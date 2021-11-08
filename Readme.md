This is a project of INFO550

The dataset is a Real Breast Cancer Data from Kaggle (URL: https://www.kaggle.com/amandam1/breastcancerdataset) (Find the Description and Download the Data in Kaggle) The path of your csv.file is defined as "Path" variable in R code.

More questions please report ISSUES or email me [qzha284@emory.edu](mailto:qzha284@emory.edu)

This report is made by R. Make sure the R has been installed. R packages 'renv' is needed. All versions of packages are locked by renv.

```
if(!require(renv)){
  install.packages("DataExplorer")
  require(renv)
}
```

## Activate the environment

```
Rscript -e "renv::activate('./')"
```



**Down load the files**

```
git clone https://github.com/QingZHANG98/INFO550_project.git
## move to the repository
cd INFO550_project
```

## Execute the analysis

```
make report
```

## Path of this file

```
open ./report/report_Rmd/report.html
```



