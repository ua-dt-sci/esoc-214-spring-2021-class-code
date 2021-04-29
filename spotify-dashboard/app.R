#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)

# read data in
spotify_data <- read_csv("data/spotify_songs.csv") %>%
    mutate(release_year = as.numeric(substr(track_album_release_date, 1, 4)))

# create a vector of genres (check in 2:27pm)
genres <- unique(spotify_data$playlist_genre)

# create a vector of numeric variable to display
variables <- c("danceability", "energy", "loudness",
               "speechiness", "acousticness",
               "instrumentalness", "liveness", "valence",
               "tempo", "duration_ms")

#genres <- spotify_data %>%
#    distinct(playlist_genre) %>%
#    pull(playlist_genre)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Spotify Dashboard"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            h3("Select Genre and Variable to display!"),
            p("This dashboard displays a bar plot and a timeline for differente numeric variables across different music genres."),
            selectInput("selected_genre",
                        "Select a genre to plot:",
                        choices = genres,
                        multiple = TRUE,
                        selected = "pop"),
            selectInput("selected_variable",
                        "Select variable to plot:",
                        choices = variables)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           tabsetPanel(type = "tabs",
                       tabPanel("Bar Plot",
                                plotOutput("bar_plot")),
                       tabPanel("Time Line",
                                plotOutput("timeline")),
                       tabPanel("Instructions",
                                p("To use this dashboard, follow these instructions..."))
               
           )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    output$bar_plot <- renderPlot({
        if (length(input$selected_genre) != 0){
            # plot a bar plot
            spotify_data %>%
                filter(playlist_genre %in% input$selected_genre) %>%
                group_by(playlist_genre, playlist_subgenre) %>%
                summarize(mean_of_variable = mean(!!sym(input$selected_variable),
                                                  na.rm = TRUE)) %>%
                ggplot(aes(x = playlist_subgenre,
                           y = mean_of_variable)) +
                geom_col() +
                facet_wrap(~playlist_genre,
                           scales = "free_x",
                           ncol = 2) +
                theme_linedraw() +
                labs(y = input$selected_variable)
        }
    })
    
    output$timeline <- renderPlot({

        if (length(input$selected_genre != 0)) {
            spotify_data %>%
                filter(playlist_genre %in% input$selected_genre) %>%
                group_by(playlist_genre, playlist_subgenre, release_year) %>%
                summarize(mean_of_variable = mean(!!sym(input$selected_variable), 
                                                  na.rm = TRUE)) %>%
                ggplot(aes(x = release_year,
                           y = mean_of_variable,
                           color = playlist_subgenre)) +
                geom_point() +
                geom_smooth(method = "lm", se = FALSE) +
                facet_wrap(~playlist_genre) +
                theme_linedraw() +
                labs(y = input$selected_variable)
        }
        
        
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
