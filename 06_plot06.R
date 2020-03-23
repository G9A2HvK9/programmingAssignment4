## loads all libraries
source('./00_loadLibraries.R')

## checks if variables are present in workspace. If not, reads data by sourcing 00_loadData file
if( !exists( 'NEI') | !exists( 'SCC' ) ){
        source('./00_loadData.R')
}

## subsets SCC data to only include values where EI.Sector has a mention of "vehicle"
vehicle_sources <- subset(
        x = SCC, 
        subset = grepl('Vehicle*', EI.Sector)
)

## subsets NEI data by fips code 24510 (Baltimore)
bMore_city <- subset(
        x = NEI,
        subset = NEI$fips == '24510'
)

## subsets NEI data by fips code 06037 (LA)
la_city <- subset(
        x = NEI,
        subset = NEI$fips == '06037'
)

## subsets baltimore and la emissions to only include those where SCC code corresponds to vehicle emissions
vehicle_emissions_bMore <- bMore_city[ bMore_city$SCC %in% vehicle_sources$SCC ]
vehicle_emissions_la <- la_city[ la_city$SCC %in% vehicle_sources$SCC ]

## aggregates over vehicle emissions in baltimore to get total emissions per year, using tapply
vehicle_emissions_by_year_bMore <- tapply(
        X = vehicle_emissions_bMore$Emissions,
        INDEX = vehicle_emissions_bMore$year,
        FUN = sum)

## aggregates over vehicle emissions in L.A. to get total emissions per year, using tapply
vehicle_emissions_by_year_la <- tapply(
        X = vehicle_emissions_la$Emissions,
        INDEX = vehicle_emissions_la$year,
        FUN = sum)

## sets up the plotting canvas to include 1 row, 2 columns and sets margins
par(mfrow = c(1, 2), oma = c(0,0,2,0))

## plots vehicle emissions per year in Baltimore and normalizes to % of 1999 levels
plot(
        x = names(vehicle_emissions_by_year_bMore),
        y = (vehicle_emissions_by_year_bMore/vehicle_emissions_by_year_bMore[1])*100, 
        type = 'l',
        xlab = 'Year',
        ylab = 'Emissions as % of 1999 level',
        main = 'Baltimore City',
        ylim = c(0, 120)
)

## plots vehicle emissions per year in L.A. and normalizes to % of 1999 levels
plot(
        x = names(vehicle_emissions_by_year_la),
        y = (vehicle_emissions_by_year_la/vehicle_emissions_by_year_la[1])*100,
        type = 'l',
        xlab = 'Year',
        ylab = '',
        main = 'Los Angeles',
        ylim = c(0, 120)
)

## Sets main chart title, superceding to two plot titles
mtext('Comparison between Motor Vehicle Emissions in Baltimore City and L.A.', outer = TRUE, cex = 1.5)

## exports plot from screen device to .png
dev.copy(png, ## determines graphics device to be png
         filename = './06_plot06.png', ## determines file name & location
         width = 960, ## sets width
         height = 480, ## sets height
         units = 'px' ## sets units as pixels
)

## closes connection
dev.off()
