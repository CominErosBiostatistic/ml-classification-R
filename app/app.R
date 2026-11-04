#------------------------------------------------------------------------------
# App per la classificazione automatica del paziente (rete neurale)
#
# Legge il modello salvato da analysis.Rmd (app/model_nn.rds): eseguire prima
# l'analisi, poi avviare l'app con shiny::runApp("app")
#------------------------------------------------------------------------------

library(shiny)
library(caret)
library(nnet)


# modello
rete2 <- readRDS("model_nn.rds")


# interfaccia utente
ui <- fluidPage(
  titlePanel("Classificazione automatica del paziente (rete neurale)"),

  sidebarLayout(
    sidebarPanel(
      selectInput("sex", "Sesso",
                  choices = list("Donna", "Uomo")),
      selectInput("cp", "Dolore toracico",
                  choices = list("Asintomatico", "Dolore atipico", "Dolore tipico", "Dolore non anginoso")),
      selectInput("exang", "Dolore toracico durante esercizio fisico",
                  choices = list("No pain", "Chest pain")),
      selectInput("slope", "Pendenza curva del segmento ST",
                  choices = list("Downsloping", "Flat", "Upsloping")),
      selectInput("oldpeak_c", "Variazione del segmento ST durante l'esercizio fisico",
                  choices = list("Bassa", "Elevata")),
      radioButtons("age_c", "Età",
                   choices = list("< 45" = 1, "45-54" = 2, "55-64" = 3, "65+" = 4)),
      selectInput("chol_c", "Livello di colesterolo totale in mg/dl",
                  choices = list("Normale", "Borderline", "Elevato")),
      selectInput("vasi_ostruiti", "Numero di vasi ostruiti",
                  choices = list("Nessuno", "Uno", "Due", "Tre")),
      actionButton("predict", "Predici")
    ),

    mainPanel(
      textOutput("result")
    )
  )
)


# logica server
server <- function(input, output) {

  observeEvent(input$predict, {

    # un paziente, con le stesse variabili usate per addestrare il modello
    new_data <- data.frame(
      sex           = input$sex,
      cp            = input$cp,
      exang         = input$exang,
      slope         = input$slope,
      age_c         = input$age_c,
      chol_c        = input$chol_c,
      oldpeak_c     = input$oldpeak_c,
      vasi_ostruiti = input$vasi_ostruiti
    )

    prediction <- predict(rete2, newdata = new_data, type = "raw")
    recode     <- c("Non a rischio" = "X0", "A rischio" = "X1")
    prediction <- factor(prediction, levels = recode, labels = names(recode))

    output$result <- renderText({
      paste("La valutazione per il paziente è:", prediction)
    })
  })
}


shinyApp(ui = ui, server = server)
