#install.packages(c("shiny", "plotly"))
library(shiny)
library(plotly)

#create some interative plot



#the range of some paramters
ui <- fluidPage(
  titlePanel("Interactive Linear Regression Simulation"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("beta_0", "Beta 0 (Intercept)", min = -10, max = 20, value = 10),
      sliderInput("beta_1", "Beta 1 (Slope)", min = -2, max = 5, value = 2),
      sliderInput("sigma", "Sigma", min = 4, max = 16, value = 9),
      sliderInput("n", "Sample size", min = 15, max = 50, value = 30)
    ),
    
    mainPanel(
      plotlyOutput("regPlot"),
      plotlyOutput("qqPlot"),
      plotlyOutput("residFittedPlot"),
      plotlyOutput("scaleLocationPlot"),
      plotlyOutput("leveragePlot")
    )
  )
)


server <- function(input, output) {
  reactive_data <- reactive({
    set.seed(123)
    
    n <- input$n
    beta_0 <- input$beta_0
    beta_1 <- input$beta_1
    sigma <- input$sigma
    
    x <- 25 * runif(n)
    y <- beta_0 + beta_1 * x + sigma * rnorm(n)
    
    data.frame(x = x, y = y)
  })
  
  output$regPlot <- renderPlotly({
    plot_data <- reactive_data()
    fit <- lm(y ~ x, data = plot_data)
    plot_data$predicted <- predict(fit)
    
    p <- plot_ly(plot_data, x = ~x, y = ~y, type = "scatter", mode = "markers", name = "Data") %>%
      add_trace(y = ~predicted, name = "Fitted Line", mode = "lines", line = list(color = "red"))
    
    return(p)
  })
  
  output$qqPlot <- renderPlotly({
    plot_data <- reactive_data()
    fit <- lm(y ~ x, data = plot_data)
    qq_data <- as.data.frame(qqnorm(residuals(fit)))
    
    p <- plot_ly(qq_data, x = ~x, y = ~y, type = "scatter", mode = "markers", name = "Q-Q Plot") %>%
      add_lines(x = ~x, y = ~x, name = "Reference Line", line = list(color = "red"))
    
    return(p)
  })
  
 
  output$residFittedPlot <- renderPlotly({
    plot_data <- reactive_data()
    fit <- lm(y ~ x, data = plot_data)
    
    residuals <- residuals(fit)
    fitted <- fitted(fit)
    
    p <- plot_ly(x = fitted, y = residuals, type = "scatter", mode = "markers") %>%
      add_lines(x = ~fitted, y = 0, name = "Zero Line", line = list(color = "red"))
    
    return(p)
  })
  
  
  
  output$scaleLocationPlot <- renderPlotly({
    plot_data <- reactive_data()
    fit <- lm(y ~ x, data = plot_data)
    
    sqrt_abs_resid <- sqrt(abs(residuals(fit)))
    fitted <- fitted(fit)
    
    p <- plot_ly(x = fitted, y = sqrt_abs_resid, type = "scatter", mode = "markers") %>%
      add_lines(x = ~fitted, y = 0, name = "Zero Line", line = list(color = "red"))
    
    return(p)
  })
  
  output$leveragePlot <- renderPlotly({
    plot_data <- reactive_data()
    fit <- lm(y ~ x, data = plot_data)
    
    residuals <- residuals(fit)
    leverage <- hatvalues(fit)
    cooksd <- cooks.distance(fit)
    
    # Calculate the high influence line
    hi_inf <- 0.5 / ncol(plot_data)
    
    p <- plot_ly() %>%
      add_markers(x = leverage, y = residuals, size = ~cooksd, sizes = c(5, 30), name = "Data Points") %>%
      add_segments(x = ~0, xend = ~max(leverage), y = 0, yend = 0, line = list(color = "red"), name = "Zero Line") %>%
      add_segments(x = ~hi_inf, xend = ~hi_inf, y = min(residuals), yend = max(residuals), line = list(color = "blue", dash = "dash"), name = "High Influence Line") %>%
      layout(title = "Residuals vs. Leverage", xaxis = list(title = "Leverage"), yaxis = list(title = "Residuals"))
    
    return(p)
  })
  
  
}

shinyApp(ui = ui, server = server)
