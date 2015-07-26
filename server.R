library(shiny)
library(ISLR);
library(ggplot2);
library(caret);
options(RCHART_WIDTH = 550)

data(Wage)

Wage <- subset(Wage,select=-c(logwage,sex,region))
modFit<- train(wage ~ ., method = "lm",data=Wage)
outSummary <- summary(modFit)

#
# shinyServer
#
shinyServer(function(input, output) {
  output$distPlot <- renderPlot({
    x <- Wage$wage
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    hist(x, breaks=bins, freq=TRUE, col='darkgreen', border='white')
  })
  
  dataInput <- reactive({
    df <- data.frame(year=as.numeric(input$year),age=input$age,maritl=input$maritl,race=input$race,
                     education=input$education,jobclass=input$jobclass,health=input$health,health_ins=input$health_ins)
    wagePred <- predict(modFit, df)
    wagePredStr <- round(wagePred, digits=1)
    
    dfTrain <- subset(Wage, year==as.numeric(input$year) & age==input$age & maritl==input$maritl
                     & race==input$race & education==input$education & jobclass==input$jobclass
                     & health==input$health & health_ins==input$health_ins)
    wageTrain = dfTrain$wage
    wageTrainStr = round(wageTrain, digits=1)

    residualWage <- wagePred - wageTrain
    residualWageStr = round(residualWage, digits=1)
    if (length(wageTrain) != 0){
      retDf <- data.frame("Predicted Wage"=wagePredStr, "Training Wage"=wageTrainStr, "Residual"=residualWageStr)
    }else{
      retDf <- data.frame("Predicted Wage"=wagePredStr)  
    }
    return(retDf)
  })
  
  dataInput4Display <- reactive({
    df4d <- data.frame("Education"=input$education,
                       "Race"=input$race,
                       "Age"=input$age,
                       "Marital"=input$maritl,
                       "Job Class"=input$jobclass,
                       "Health"=input$health,
                       "Health Insurance"=input$health_ins,
                       "Year"=input$year)
    return(df4d)
  })
  
  
  ageInput <- reactive({
    dfAge <- subset(Wage, age==input$age)
    bpTitle <- paste("Wage vs Education [Age:",input$age)
    bpTitle <- paste(bpTitle,"]")
    boxp <- ggplot(dfAge, aes(x=education, y=wage, fill=education)) + geom_boxplot() + scale_x_discrete(labels= c("1","2","3","4","5")) + ggtitle(bpTitle)
    return(boxp)
  })
  
  output$data4display <- renderTable(dataInput4Display())
  output$resultpred <- renderTable(dataInput())
  output$ageboxplot <- renderPlot(ageInput())
  output$summary <- renderPrint(outSummary)
  output$dtable <- renderDataTable(Wage, options = list(pageLength = 10))
})

