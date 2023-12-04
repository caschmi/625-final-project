install.packages("shiny")
install.packages("MASS")
library(shiny)
library(MASS)
Final <- read.csv("finalModelData.csv")




ui <- fluidPage(
  titlePanel("TITTYVERSE"),
  sidebarLayout(
    sidebarPanel(
      selectInput('Outcome', 'Select the outcome variable', choices = names(Final)),
      selectizeInput('Predictors', 'Select the predictor variable/s', choices = names(Final), multiple=TRUE),
      actionButton("run_regression", "Run Regression")
    ),
    mainPanel(
      tabsetPanel(
        type = "tabs",
        tabPanel("Model", verbatimTextOutput("model_summary")),
        tabPanel("Residual Plots", plotOutput("plot"))
      )
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

    output$scatterplot <- renderPlot({
      ggplot(Final, aes_string(x = Predictors, y = Outcome)) +
        geom_point() +
        geom_smooth(method = "lm", se = FALSE, color = "blue") +
        labs(title = "HOT SNAKS")
    })

    output$model_summary <- renderPrint({
      summary(model)
    })
    output$plot <- renderPlot({
      plot(fitted(model), resid(model))
    })
  })
}

shinyApp(ui, server)















