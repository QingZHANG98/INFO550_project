**This is a project of INFO550**

The dataset is a Real Breast Cancer Data from Kaggle (URL: https://www.kaggle.com/amandam1/breastcancerdataset) (Find the Description and Download the Data in Kaggle) The path of your csv.file is defined as "Path" variable in R code.

More questions please report ISSUES or email me [qzha284@emory.edu](mailto:qzha284@emory.edu)

## Prerequisite
This report is made by R 4.1.1.  
R packages 'renv' is needed. All versions of packages are locked by renv.  
GNU Make is needed. In MacOS, install the Xcode. In linux:
```
sudo apt-get install make
```
If you don't want to use terminal, run the code in report/R to generate figures and cleaned data. Render the report by report_Rmd/report.Rmd file.  

**Download the project and checkout the directory**

```
## clone the repository
git clone https://github.com/QingZHANG98/INFO550_project.git

## checkout the repository
## If you download and unzip the project, check the structure and name of your directory. It could be INFO550_project/INFO550_project or INFO550_project-master ...

cd INFO550_project # project_path
```

**Go to the R session:**  
make sure the renv package has been installed.  

```
if(!require(renv)){
  install.packages("renv")
  require(renv)
}
```

synchronize the library

```
renv::restore()
```
If there is an error in synchronizing packages, you should manually install the packages. Check what packages are needed:  
```
renv::status()
```
If the renv is not activated: 
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



