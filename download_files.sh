#!/usr/bin/env sh
MIN_CITY_POP=15000
# download USA place names
echo "Downloading USA state and county information..."
curl "http://download.geonames.org/export/dump/US.zip" > usa.zip
unzip usa.zip
mkdir ./geonames
# only keep states and counties
grep -E "	ADM1	" US.txt > ./geonames/usa_states.tsv
grep -E "	ADM2	" US.txt > ./geonames/usa_counties.tsv
rm US.txt readme.txt usa.zip
# download country names
echo "Downloading country information..."
curl "http://download.geonames.org/export/dump/countryInfo.txt" > ./geonames/countries.tsv
# download cities
echo "Downloading USA city information..."
curl "http://download.geonames.org/export/dump/cities$MIN_CITY_POP.zip" > cities.zip
unzip cities.zip
# only keep USA cities
grep -E '	US	' cities$MIN_CITY_POP.txt > ./geonames/usa_cities.tsv
rm cities$MIN_CITY_POP.txt cities.zip

echo "Downloading USA Postal Code information..."
curl "http://download.geonames.org/export/zip/US.zip" > usazipcodes.zip
unzip usazipcodes.zip
mv US.txt ./geonames/usa_zip.tsv
rm readme.txt usazipcodes.zip

echo "Downloading USA County information..."
curl "https://www.census.gov/geo/reference/codes/files/national_county.txt" > ./geonames/usa_fips.csv


echo "Downloading USGS Populated Places information..."
curl "http://geonames.usgs.gov/docs/stategaz/POP_PLACES_20140802.zip" > usgs_pop_places.zip
unzip usgs_pop_places.zip
mv POP_PLACES_*.txt ./geonames/usgs_pop_places.txt
rm usgs_pop_places.zip


echo "Downloading US Census population information"
curl "http://www.census.gov/popest/data/metro/totals/2013/files/CSA-EST2013-alldata.csv" > ./geonames/usa_census_csa.csv
curl "https://www.census.gov/popest/data/metro/totals/2013/files/CBSA-EST2013-alldata.csv" > ./geonames/usa_census_cbsa.csv

echo "Downloading US HUD ZIP TO CBSA & County infromation"
curl "http://www.huduser.org/portal/datasets/usps/ZIP_CBSA_032014.xlsx" > ./ZIP_CBSA.xlsx
curl "http://www.huduser.org/portal/datasets/usps/ZIP_COUNTY_032014.xlsx" > ./ZIP_COUNTY.xlsx
echo "Make sure xlsx2csv is installed (sudo pip install xlsx2csv)"
chmod 755 ./xlsx_csv.py
./xlsx_csv.py
rm ZIP_CBSA.xlsx ZIP_COUNTY.xlsx
