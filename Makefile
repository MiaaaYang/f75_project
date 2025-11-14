


output/f75_clean.rds: code/00_clean_data.R f75_dataset/f75_interim.csv
	Rscript code/00_clean_data.R
	
.PHONY: clean
clean:
	rm -f output/*.rds && rm -f output/*.png && rm -f *.html && rm -f *.pdf 