sudo /usr/local/mysql/support-files/mysql.server start
sudo /usr/local/mysql/support-files/mysql.server stop

Creating root account
mysqladmin -u root password 'root password goes here'

And then to invoke the MySQL client:
mysql -h localhost -u root -p

create a user
create user 'solrgeo'@'localhost' identified by 'gpsmaps';

create database solrgeo_db;

show databases;

grant all on solrgeo_db.* to 'solrgeo'@'localhost';

LOAD DATA LOCAL INFILE '/path/to/your/csv/file/model.csv' INTO TABLE test.dummy FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';


curl "http://www.census.gov/popest/data/metro/totals/2013/files/CSA-EST2013-alldata.csv" > ./geonames/usa_census_csa.csv


#Census population estimates
#Pull out all CSAs
mkdir ./geonames/db
awk -F $',' '$2=="" {print $1 "|" $5 $6 "|" $7 "|" $8}' ./geonames/usa_census_csa.csv > ./geonames/db/csa.csv

LOAD DATA LOCAL INFILE './geonames/db/csa.csv' INTO TABLE solrgeo_db.csa FIELDS TERMINATED BY '|';



#Pull out all MSAs
awk -F $',' '($2 != "") && ($4 == "") {print $1 "|" $2 "|" $3 "|" $5 $6 "|" $7 "|" $8}' ./geonames/usa_census_csa.csv > ./geonames/db/msa.csv

LOAD DATA LOCAL INFILE './geonames/db/msa.csv' INTO TABLE solrgeo_db.msa FIELDS TERMINATED BY '|';

#Pull out all Counties , seems like this awk gives headers
awk -F $',' '($2 != "") && ($4 != "") {print $1 "|" $2 "|" $4 "|" $5 $6 "|" $8}' ./geonames/usa_census_csa.csv > ./geonames/db/counties.csv
LOAD DATA LOCAL INFILE './geonames/db/counties.csv' INTO TABLE solrgeo_db.counties FIELDS TERMINATED BY '|' IGNORE 1 LINES;


#pull out all CBSAs
awk -F $',' '($2 == "") && ($3 == "") {print $1 "|" $4 $5 "|" $6 "|" $7 }' ./geonames/usa_census_cbsa.csv > ./geonames/db/cbsa.csv
LOAD DATA LOCAL INFILE './geonames/db/cbsa.csv' INTO TABLE solrgeo_db.cbsa FIELDS TERMINATED BY '|' IGNORE 3 LINES;

#Place to County Names
awk -F $'|' '{print $1 "|" $2 "|" $4 "|" $5 $7 "|" $6 "|" $10 "|" $11}' ./geonames/usgs_pop_places.txt > ./geonames/db/places.csv
LOAD DATA LOCAL INFILE './geonames/db/places.csv' INTO TABLE solrgeo_db.places FIELDS TERMINATED BY '|' IGNORE 1 LINES;

#ZIP to CBSA
awk -F $',' '{print $1 "|" $2}' ./geonames/ZIP_CBSA.csv > ./geonames/db/zip_cbsa.csv
LOAD DATA LOCAL INFILE './geonames/db/zip_cbsa.csv' INTO TABLE solrgeo_db.zip_cbsa FIELDS TERMINATED BY '|' IGNORE 1 LINES;

#ZIP to County
awk -F $',' '{print $1 "|" $2}' ./geonames/ZIP_COUNTY.csv > ./geonames/db/ZIP_COUNTY.csv
LOAD DATA LOCAL INFILE './geonames/db/ZIP_COUNTY.csv' INTO TABLE solrgeo_db.zip_county FIELDS TERMINATED BY '|' IGNORE 1 LINES;


##MySQL
select * from zip_county zcou
left outer join zip_cbsa zc on zcou.zip = zc.zip
left outer join msa m on zc.cbsa = m.CBSA
left outer join csa csa on csa.csa = m.csa
left outer join cbsa cbsa on cbsa.cbsa = zc.cbsa
where zc.cbsa != 99999;