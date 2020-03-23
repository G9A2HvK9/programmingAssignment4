## checks if variables are present in workspace. If not, reads data by sourcing 00_loadData file
if( !exists( 'NEI') | !exists( 'SCC' ) ){
        source('./00_loadData.R')
}

## determines total emissions by year
by_year <- tapply(
        X = NEI$Emissions, ## sets data source as emissions variable of NEI
        INDEX = NEI$year, ## sets factor as year variable of NEI
        FUN = sum ## sets function as sum
)

## draws plot on screen device, using by_year data
by_year_plot <- plot(
        x = names(by_year), ## determines x-data source as names of by_year
        y = by_year[1:4], ## determines y-data source as values of by_year
        type = 'l', ## determines type to by 'line'
        xlab = 'Year', ## sets x-axis lable
        ylab = 'Total Emissions in metric tons', ## sets y-axis lable
        main = 'PM2.5 Emissions in the United States' ## sets main chart title
)

## exports plot from screen device to .png
dev.copy(png, ## determines graphics device to be png
         filename = './01_plot01.png', ## determines file name & location
         width = 480, ## sets width
         height = 480, ## sets height
         units = 'px' ## sets units as pixels
)

## closes connection
dev.off()