install.packages("shiny")
install.packages("MASS")
library(shiny)
library(MASS)
Final <- read.csv("finalModelData.csv")






main_page <- tabPanel(
  title = "Analysis",
  titlePanel("Analysis"),
  sidebarLayout(
    sidebarPanel(
      title = "Inputs",
      selectInput('Outcome', 'Select the outcome variable', choices = names(Final)),
      selectizeInput('Predictors', 'Select the predictor variable/s', choices = names(Final), multiple=TRUE),
      actionButton("run_regression", "Run Regression")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel(
          title = "Model", verbatimTextOutput("model_summary")
        ),
        tabPanel(
          title = "Residual Plots", plotOutput("plot")
        )
      )
    )
  )
)



plots_page <- tabPanel(
  title = "Exploratory Plots",
  titlePanel("Exploratory Plots"),
  sidebarLayout(
    sidebarPanel(
      title = "Inputs",
      selectInput('x_axis', 'Select the x variable', choices = names(Final)),
      selectizeInput('y_axis', 'Select the y variable', choices = names(Final)),
      actionButton("create_plot", "Create Plot")
    ),
    mainPanel(
      title = "Plot", plotOutput("exp_plot")
    )
  )
)


server <- function(input, output) {
  observeEvent(input$run_regression, {
    predictors <- input$Predictors
    outcome <- input$Outcome

    #run the regression model
    model <- glm.nb(as.formula(paste(outcome, "~", paste(predictors, collapse = "+"), "+", "offset(log(Final$Population))")),
                    link = log,
                    data = Final)

    output$model_summary <- renderPrint({
      summary(model)
    })
    output$plot <- renderPlot({
      plot(fitted(model), resid(model))
    })
  })
  observeEvent(input$create_plot, {
      x_var <- input$x_axis
      y_var <- input$y_axis

      #create plot
      output$exp_plot <- renderPlot({
        plot(Final[[x_var]],Final[[y_var]],
             xlim = range(Final[[x_var]], na.rm = TRUE),
             ylim = range(Final[[y_var]], na.rm = TRUE))
      }
      )
  })
}

ui <- navbarPage(
  title = "Data Analyser",
  main_page,
  plots_page
)


shinyApp(ui, server)

