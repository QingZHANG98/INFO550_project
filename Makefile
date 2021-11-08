# data 
data: ./raw_data/BRCA.csv ./report/R/make_studyset.R
	Rscript ./report/R/make_studyset.R
	
# making study dataset
report: data figs ./report/report_Rmd/report.Rmd
	Rscript -e "rmarkdown::render('./report/report_Rmd/report.Rmd')"

# making figs
figs: data ./report/R/make_figs.R
	Rscript ./report/R/make_figs.R