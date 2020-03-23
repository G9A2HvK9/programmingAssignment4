## checks if variables are present in workspace. If not, reads data by sourcing 00_loadData file
if( !exists( 'NEI') | !exists( 'SCC' ) ){
        source('./00_loadData.R')
}

## subsets NEI data by fips code for Baltimore City and stores result in new variable
bMore_city <- subset(
        x = NEI,
        subset = fips == '24510' 
)

## aggregates to calculate total emissions by year, using tapply and stores in new variable
bMore_city_by_year <- tapply(
        X = bMore_city$Emissions,
        INDEX = bMore_city$year,
        FUN = sum
)

## draws plot on screen device, using by_year data
bMore_city_by_year_plot <- plot(
                x = names(bMore_city_by_year), ## determines x-data source as names of by_year
                y = bMore_city_by_year[1:4], ## determines y-data source as values of by_year
                type = 'l', ## determines type to by 'line'
                xlab = 'Year', ## sets x-axis lable
                ylab = 'Total Emissions in metric tons', ## sets y-axis lable
                main = 'PM2.5 Emissions in Baltimore City' ## sets main chart title
)

## exports plot from screen device to .png
dev.copy(png, ## determines graphics device to be png
         filename = './02_plot02.png', ## determines file name & location
         width = 480, ## sets width
         height = 480, ## sets height
         units = 'px' ## sets units as pixels
)

## closes connection
dev.off()
