library(shiny)
library(shinyalert)
library(tidyverse)
library(ggplot2)
library(DT)
source("helpers.R")  # now pulls in num_vars and cat_vars

#load data 
mobile_device_data <- read_csv("data/user_behavior_dataset.csv")

ui <- fluidPage(
  titlePanel("Mobile Device Usage"),
  
  tabsetPanel(
    
    # About tab
    tabPanel(
      "About",
      h3("About Section"),
      p("The purpose of this website is to compare different categories for mobile data usage. The user will be able to select the variables and look at numerical summaries."),
      h4("Data Source"),
      p(a(
        "Click this link to view the data source",
        href = "https://www.kaggle.com/datasets/valakhorasani/mobile-device-usage-and-user-behavior-dataset"
      )),
      img(src = "Project_2/proj.jfif", height = "200px")
    ),
    
    #Data download tab
    tabPanel(
      "Data Download",
      DTOutput("data_table"),
      downloadButton("download_data", "Download CSV")
    ),
    
    #Data exploration tab
    tabPanel(
      "Data Exploration",
      sidebarLayout(
        sidebarPanel(
          selectizeInput("cat_vars", "Select a Categorical Variable:", choices = names(cat_vars), selected = "Gender"),
          selectizeInput("num_vars", "Select a Numeric Variable:", choices = names(num_vars), selected = "Number of Apps Installed"),
          radioButtons(
            "summary_type",
            "Choose Variable to summarize:",
            choices = c("Numeric summaries", "Categorical summaries"),
            inline = TRUE
          )
        ),
      mainPanel(
        uiOutput("explore_ui"),
        plotOutput("barPlot")
      )
      )
    )
  )
)

server <- function(input, output) {
  # example server code
}

shinyApp(ui, server)

server <- function(input, output) {
  
  # Generate UI for numeric/categorical variable selection
  output$explore_ui <- renderUI({
    if(input$summary_type == "Numeric summaries") {
      selectInput("numeric_var", "Select numeric variable for summary:",
                  choices = names(num_vars),
                  selected = input$num_vars)
    } else {
      selectInput("categorical_var", "Select categorical variable for summary:",
                  choices = names(cat_vars),
                  selected = input$cat_vars)
    }
  })
  
  # Render bar/boxplot
  output$barPlot <- renderPlot({
    req(input$cat_vars, input$num_vars)
    
    ggplot(mobile_device_data, aes_string(x = input$cat_vars, y = input$num_vars)) +
      geom_boxplot(fill = "steelblue", alpha = 0.6) +
      labs(
        x = input$cat_vars,
        y = input$num_vars,
        title = paste("Distribution of", input$num_vars, "by", input$cat_vars)
      ) +
      theme_minimal(base_size = 14)
  })
  
  # Render data table
  output$data_table <- renderDT({
    datatable(mobile_device_data, options = list(pageLength = 10))
  })
  
  # Download handler
  output$download_data <- downloadHandler(
    filename = function() { "mobile_data_subset.csv" },
    content = function(file) {
      write.csv(mobile_device_data, file, row.names = FALSE)
    }
  )
}

shinyApp(ui = ui, server = server)

