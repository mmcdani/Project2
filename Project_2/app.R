library(shiny)
library(tidyverse)
source("helpers.R")  # now pulls in num_vars and cat_vars

ui <- fluidPage(
  titlePanel("Mobile Device Usage"),
  
  sidebarLayout(
    sidebarPanel(
      h2("Select a Subset of Data:"),
      
      selectizeInput(
        "cat_vars",
        "Select a Categorical Variable:",
        choices = names(cat_vars),
        selected = "Gender"
      ),
      
      selectizeInput(
        "num_vars",
        "Select a Numeric Variable:",
        choices = names(num_vars),
        selected = "Number of Apps Installed"
      )
    ),

    
    mainPanel(
      tabsetPanel(
        tabPanel('About',
                 h3('about section'),
                 p('about info'),
                 h4('Data Source'),
                 p(a('Click this link to view the data source',
                     href = 'https://www.kaggle.com/datasets/valakhorasani/mobile-device-usage-and-user-behavior-dataset'),
                   p('provide purpose of the sidebar tab'),
                   img("Project_2/proj.jfif")))
      ),
      plotOutput("barPlot")
    )
  )
)

server <- function(input, output) {
  output$barPlot <- renderPlot({
    cat_col <- cat_vars[[input$cat_vars]]
    num_col <- num_vars[[input$num_vars]]
    
    ggplot(mobile_device_data, aes_string(x = cat_col, y = num_col)) +
      geom_boxplot(fill = "steelblue", alpha = 0.6) +
      labs(
        x = input$cat_vars,
        y = input$num_vars,
        title = paste("Distribution of", input$num_vars, "by", input$cat_vars)
      ) +
      theme_minimal(base_size = 14)
  })
}

shinyApp(ui = ui, server = server)