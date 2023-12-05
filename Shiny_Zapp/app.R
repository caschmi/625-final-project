install.packages("shiny")
install.packages("MASS")
install.packages("RColorBrewer")
library(RColorBrewer)
library(shiny)
library(MASS)
library(ggplot2)
Final <- read.csv("finalModelData.csv")
Final$Covid <- ifelse(Final$COVID == 1, "Covid", "Pre-covid")

Final$Race <- relevel(as.factor(Final$Race), ref = "White")
Final$Gender <- relevel(as.factor(Final$Gender), ref = "M")
Final$Cause_of_Death <- relevel(as.factor(Final$Cause_of_Death), ref = "All other non-drug and non-alcohol causes")
Final$Age <- relevel(as.factor(Final$Age), ref = "Under 5 years")
Final$COVID <- as.factor(Final$COVID)




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
        ),
        tabPanel(
          title = "ANOVA", verbatimTextOutput("anova")
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
      selectizeInput('y_axis', 'Select the y variable', choices = c("Population", "Deaths")),
      selectInput('stratification', 'Select the variable to stratify on', choices = c("Race", "Gender", "Cause_of_Death", "Age", "Covid")),
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
    #specify which groups in the categorical variables should be reference
    model <- glm.nb(as.formula(paste(outcome, "~", paste(predictors, collapse = "+"), "+", "offset(log(Final$Population))")),
                    link = log,
                    data = Final)

    output$model_summary <- renderPrint({
      summary(model)
    })
    output$plot <- renderPlot({
      plot(fitted(model), resid(model))
    })
    output$anova <- renderPrint({
      anova(model)
    })
  })
  observeEvent(input$create_plot, {
      strat <- input$stratification
      Stratification <- Final[[strat]]
      y_var <- input$y_axis
      y_vars <- Final[[y_var]]

      #create plot
      output$exp_plot <- renderPlot({
        ggplot(Final, aes(y = y_vars,
                          x = Year, group = Stratification)) +
          stat_summary(aes(color = Stratification, linetype = Stratification),
                       geom = "line", fun.y = mean, linewidth = 1) +
          stat_summary(aes(shape = Stratification), geom = "point",
                       fun.y = mean, size = 2) + xlab("Years") +
          ylab(paste(y_var)) +
          scale_color_brewer(palette = "Dark2")
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





