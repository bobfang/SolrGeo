#!/usr/bin/env python
import xlsx2csv
xlsx2csv.Xlsx2csv("ZIP_CBSA.xlsx").convert("./geonames/ZIP_CBSA.csv")
xlsx2csv.Xlsx2csv("ZIP_COUNTY.xlsx").convert("./geonames/ZIP_COUNTY.csv")