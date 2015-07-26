library(shiny)
library(quantmod)
library(ISLR);
library(ggplot2);

#require(rCharts)
options(RCHART_LIB = 'polycharts')

data(Wage)
#
# shinyUI
#
shinyUI(fluidPage(
  
  # Application title
  title = "Wage Predictor",
  
  fluidRow(
    column(4,
           img(src='wages.png', align = "left")
    ),
    
    column(8,
           h1("Wage Predictor", align = "center"),
           br(),
           
           p("p creates a paragraph of text."),
           p("A new p() command starts a new paragraph. Supply a style attribute to change the
  format of the entire paragraph.", style = "font-family: 'times'; font-si16pt"),
           strong("strong() makes bold text."),
           em("em() creates italicized (i.e, emphasized) text.")
           
          ) #close cloumn
  ),
  code("code displays your text similar to computer code"),
  div("div creates segments of text with a similar style. This division of text is al
 l blue because I passed the argument 'style = color:blue' to div", style = "color:blue"),
  br(),
  p("span does the same thing as div, but it works with",
    span("groups of words", style = "color:blue"),
    "that appear inside a paragraph."),
  p("Da qui in poi posso scrivere tutto il testo che voglio."),
  
  
  p("The application implements a wage predictor based on 
  income survey data for 3000 males in Mid-Atlantic region of USA.
  Selecting 8 variables (see below) the system will provide a prediction of wage the worker could obtain.
  If the combination of variables chosen by user is the same as those in training data, the exact value ow wage will be displayd and the residual 
  (the difference between the observed value and the estimated value) as well,
  
  The app is structured in 7 different areas:
    The description are (this one)
  The input area, where the user can select
  
  HOW TO USE"),
  a("Technical Notes", href="/technotes.html"),
  

  hr(),

  fluidRow(
    # COL 1
    column(4,
           radioButtons("education", h5("Education:"),
                        choices = list("1. < HS Grad"="1. < HS Grad", "2. HS Grad"="2. HS Grad",
                                       "3. Some College"="3. Some College", "4. College Grad"="4. College Grad",
                                       "5. Advanced Degree"="5. Advanced Degree"), selected="2. HS Grad"),
           
           radioButtons("race", h5("Race:"),
                        choices = list("1. White"="1. White", "2. Black"="2. Black","3. Asian"="3. Asian",
                                       "4. Other"="4. Other"),selected="1. White"),
           
      sliderInput("age",
                  "Age:",
                  min = 18,
                  max = 80,
                  value = 42)      
    ),
    
    # COL 2
    column(4,
           radioButtons("maritl", h5("Marital Status"),
                        choices = list("Never Married"="1. Never Married", "2. Married"="2. Married","3. Widowed"="3. Widowed",
                                       "4. Divorced"="4. Divorced", "5. Separated"="5. Separated"),selected="2. Married"),
           
           
           radioButtons("jobclass", h5("Job Class"),
                        choices = list("1. Industrial"="1. Industrial", "2. Information"="2. Information"),selected="1. Industrial")
           
           
    ),
      
    # COL 3
    column(4, 
             radioButtons("health", h5("Health:"),
                choices = list("1. Good"="1. <=Good", "2. Very Good"="2. >=Very Good"),selected="2. >=Very Good"),
             radioButtons("health_ins", h5("Health Insurance:"),
                choices = list("1. Yes"="1. Yes", "2. No"="2. No"),selected="1. Yes"),
      
    
      selectInput("year", h5("Year:"), 
                  choices = list("2003"=2003, "2004"=2004,"2005"=2005,"2006"=2006,"2007"=2007,
                                 "2008"=2008,"2009"=2009,"2010"=2010,"2011"=2011,"2012"=2012,
                                 "2013"=2013,"2014"=2014,"2015"=2015,"2015"=2016), selected = 2003)
      
      )
  
  
),

mainPanel(
  tabsetPanel(
    tabPanel("Predictor",
             h3("Input Data:"),
             tableOutput("data4display"),
             h3("Predictor results [annual salary in USD]:"),
             tableOutput("resultpred")
             #plotOutput("ageboxplot")
            ),
    tabPanel("Wage/Education/Age", plotOutput("ageboxplot")),
    tabPanel("Model Summary", verbatimTextOutput("summary")),
    tabPanel("Table", dataTableOutput("dtable"))
  ) )
))

