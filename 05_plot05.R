## loads all libraries
source('./00_loadLibraries.R')

## checks if variables are present in workspace. If not, reads data by sourcing 00_loadData file
if( !exists( 'NEI') | !exists( 'SCC' ) ){
        source('./00_loadData.R')
}

## subsets SCC data to only include rows where EI.Sector includes a mention of "vehicle"
vehicle_sources <- subset(
        x = SCC, 
        subset = grepl('Vehicle*', EI.Sector)
)

## subsets NEI data to only include fips code 24510 (Baltimore)
bMore_city <- subset(
        x = NEI,
        subset = NEI$fips == '24510'
)

## subsets baltimore city data to only include instances, where the SCC code indicates vehicle emissions
vehicle_emissions <- bMore_city[ bMore_city$SCC %in% vehicle_sources$SCC ]

## aggregates over the bMore vehicle emissions to get the sums of all emissions per year
vehicle_emissions_by_year <- tapply(
        X = vehicle_emissions$Emissions,
        INDEX = vehicle_emissions$year,
        FUN = sum)

## draws plot of vehicle emissions per year and adds axis titles, chart title
plot(
        x = names(vehicle_emissions_by_year),
        y = vehicle_emissions_by_year, 
        type = 'l',
        xlab = 'Year',
        ylab = 'Emissions in metric tons',
        main = 'PM2.5 Emissions from vehicles in Baltimore City'
)

## exports plot from screen device to .png
dev.copy(png, ## determines graphics device to be png
         filename = './05_plot05.png', ## determines file name & location
         width = 480, ## sets width
         height = 480, ## sets height
         units = 'px' ## sets units as pixels
)

## closes connection
dev.off()
