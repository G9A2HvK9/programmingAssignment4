## loads all libraries
source('./00_loadLibraries.R')

## checks if variables are present in workspace. If not, reads data by sourcing 00_loadData file
if( !exists( 'NEI') | !exists( 'SCC' ) ){
        source('./00_loadData.R')
}

## subsets NEI data set to only include Baltimor City fips code
bMore_city <- subset(
        x = NEI, ## sets data set to NEI data.table
        subset = fips == '24510' ## sets subset to fips == '24510'
)

## aggregates bMore_city emissions data into totals by year and type
factor_sums <- aggregate(
        x = bMore_city$Emissions,
        by = list(bMore_city$year, bMore_city$type),
        FUN = sum
)

## updates variable names for easier processing and more readable code
names(factor_sums) <- c('year', 'type', 'emissions')

## uses ggplot to set up plotting device. Plots emissions per year by grouping (type)
bMore_city_plot <- ggplot(
        data = factor_sums,
        aes(
                x = year,
                y = emissions,
                group = type
        )
) 

## edits plot to add aesthetics like lines, titles and axis lables
bMore_city_plot <- bMore_city_plot + 
                geom_path() + facet_grid(.~type) + 
                theme(axis.text.x = element_text(angle = 45)) + 
                labs(x = 'Year', y = 'Emissions in metric tons') + 
                ggtitle('PM2.5 Emissions in Baltimore City by Source') +
                theme(plot.title = element_text(hjust = 0.5))

## opens png file
png(
        filename = '03_plot03.png',
        widt = 960,
        height = 480,
        unit = 'px'
)

## writes bMore_city_plot to png file
bMore_city_plot

## closes connection
dev.off()
