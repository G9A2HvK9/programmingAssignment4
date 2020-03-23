## loads all libraries
source('./00_loadLibraries.R')

## checks if variables are present in workspace. If not, reads data by sourcing 00_loadData file
if( !exists( 'NEI') | !exists( 'SCC' ) ){
        source('./00_loadData.R')
}

## subsets SCC data to only include those where "EI.Sector" includes "Coal"
coal_sources <- subset(
        x = SCC, 
        subset = grepl('Coal', EI.Sector)
        )

## subsets NEI data to only include those, where SCC code corresponds to a code for coal emissions
coal_emissions <- NEI[ NEI$SCC %in% coal_sources$SCC ]

## aggregates coal emissons by year to get total coal emissions per year
coal_emissions_by_year <- tapply(
        X = coal_emissions$Emissions, 
        INDEX = coal_emissions$year,
        FUN = sum)

## draws plot of total coal emissions per year and ammends axis titles, chart title
plot(
        x = names(coal_emissions_by_year),
        y = coal_emissions_by_year, 
        type = 'l',
        xlab = 'Year',
        ylab = 'Emissions in metric tons',
        main = 'PM2.5 Emissions from coal sources in the United States'
        )

## exports plot from screen device to .png
dev.copy(png, ## determines graphics device to be png
         filename = './04_plot04.png', ## determines file name & location
         width = 480, ## sets width
         height = 480, ## sets height
         units = 'px' ## sets units as pixels
)

## closes connection
dev.off()