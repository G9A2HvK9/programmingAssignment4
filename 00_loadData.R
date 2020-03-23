source('./00_loadLibraries.R') ## loads all libraries necessary to execute file

## checks for 99_data directory. If none exists, creates the directory
if( !file.exists('./99_data') ){
        dir.create('./99_data')
}

## checks data directory for zip file. If it does not exist, downloads zip file
if( !file.exists('./99_data/exdata2Fdata2FNEI_data.zip') ){
        download.file(
                url = 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip',
                destfile = './99_data/exdata2Fdata2FNEI_data.zip',
        )
}

## checks if both data sources are present. If either is missing, unzips .zip file and overwrites data
if( !file.exists('./99_data/Source_Classification_Code.rds') | !file.exists('./99_data/summarySCC_PM25.rds') ){
        unzip(
                zipfile = './99_data/exdata2Fdata2FNEI_data.zip',
                overwrite = TRUE,
                exdir = './99_data',
        )
}

## Checks to see if .zip file exists and deletes .zip file
if( file.exists('./99_data/exdata2Fdata2FNEI_data.zip') ){
        file.remove('./99_data/exdata2Fdata2FNEI_data.zip')
}

## reads data sources into workspace and formats as data.table
NEI <- as.data.table( readRDS('./99_data/summarySCC_PM25.rds'), verbose = TRUE )
SCC <- as.data.table( readRDS('./99_data/Source_Classification_Code.rds'), verbose = TRUE )
