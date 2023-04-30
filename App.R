## APP - Ambiência Racial ###

#install.packages("dashboardthemes")
#install.packages("fresh")


library(fresh)
library(shiny)
library(shinydashboard)
library(dashboardthemes)
library(shinyjs)

mytheme <- create_theme(
  
  adminlte_color(
    light_blue = "#000000",
    
  ),
  adminlte_sidebar(
    width = "200px",
    dark_bg = "#000000", #lateral
    dark_hover_bg = "#CE0707", # detaque da lateral
    dark_color = "#FFFFFF" # fontes da lateral
  ),
  
  adminlte_global(
    content_bg = "#FFFFFF", #fundo do MainPainel
    box_bg = "#FFFFFF", # Detalhes da box
    info_box_bg = "#FFFFFF" # Detalhes das box
    
  )
)


ui <- dashboardPage(
 
  header = dashboardHeader(title = "EmoriÔ",
                           titleWidth = 600),
  sidebar = dashboardSidebar(
   
    sidebarMenu(
      br(),
      br(),
      menuItem("Sobre", tabName = "Sobre"),
      menuItem("Escolas", tabName = "Mun"),
      menuItem("Empresas", tabName = "Emp")
     
    )
  ),
  body = dashboardBody(
    h2("Índice de Ambiência Racial"),
    br(),
    use_theme(mytheme), # <-- use the theme
    
    tabItems(
      tabItem(tabName = "Sobre",
              h3("Definição")
      ),
      
      tabItem(tabName = "Mun",
        
        fluidPage(
          
          fluidRow(
            
            column(width = 9.5, 
                   tabBox(
                     width = 9.5,
                     height = 380,
                     title = "Consulte",
                     tabPanel("Município",
                    solidHeader = FALSE,
                     selectInput("uf", "Estado", choices = c("AL", "AC", "AP", "AM", "BA"), selected ="AL" ),
                     br(),
                     textInput("textM", "Município:"),
                      radioButtons('radiored', 'Rede', list('Pública' = 0, 'Privada' = 1 ), selected = 0, inline = TRUE),
                     radioButtons('radioid', 'Dimensão', list('Demodidática' = 0, 'Formação' = 1 ), selected = 0 ,inline = TRUE),
                     actionButton('Consultar', 'Clique')
                     
                   ),
                   tabPanel("Bairro", 
                            h3('Localização'),
                            solidHeader = FALSE,
                            #textInput("textM", "Município:"),
                            textInput("textB", "Bairro:"),
                            radioButtons('radioid', 'Dimensão', list('Demodidática' = 0, 'Formação' = 1 ), inline = TRUE),
                            actionButton('Consultar', 'Clique'),
                            br(),
                            br(),
                            "*selecione Estado e Município na análise por município"
                            
                   ))
           
          )),
          fluidRow(
            column(width = 9.5,
                   msg <- h4("Não encontrado"),
                   textOutput("msg"),
                   br(),
              valueBoxOutput("media", width = 4)
            ),
            column(width = 9.5,
                   valueBoxOutput("desvio", width = 4)),
            column(width = 9.5,
                   valueBoxOutput("var", width = 4)
              
            )
            
          ),
          
          fluidRow(
            column(
              width = 9.5,
              height = 380,
            tabBox(
              width = 9.5,
              height = 480,
              title = " ",
              id = "tabset2", 
              tabPanel("Histograma", "Gráficos", plotOutput("plot1")),
              tabPanel("Dispersão", plotOutput("plot2"))
            ))
          ),
          br(),
          fluidRow(
            column(
              width = 9.5,
              height = 320,
              tabBox(
                width = 9.5,
                height = 300,
                title = "Calcule",
                id = "tabset3",
                tabPanel("Demodidática",
                         solidHeader = FALSE,
                         numericInput('idnumerica1', 'Alunos Não-Brancos (%):', 0, min = 0, max = 100, step = 5),
                         numericInput('idnumerica2', 'Professores Não-Brancos (%):', 0, min = 0, max = 100, step = 5),
                         radioButtons('idmater1', 'Material didático - diversidade étnica', list('Sim' = 0, 'Não' = 1 ), inline = TRUE),
                         radioButtons('idmater2', 'Material didático - culturas indégenas', list('Sim' = 0, 'Não' = 1 ), inline = TRUE)
                         
                         ),
                tabPanel("Formação",
                         solidHeader = FALSE,
                         numericInput('idnumerica3', 'Professores com formação estudos afro-Brasileiros (%):', 0, min = 0, max = 100, step = 5),
                         numericInput('idnumerica4', 'Professores com formação direitos humanos (%):', 0, min = 0, max = 100, step = 5)
                  
                )
                
              )
              
            )
            
          ),
          
          fluidRow(
            column(
              width = 9.5,
              valueBoxOutput("valor", width = 4)
            ),
            column(width = 9.5,
                   valueBoxOutput("desvio2", width = 4)),
            column(width = 9.5,
                   valueBoxOutput("var2", width = 4)
                   
            )
          )
          
          )
        
        
      ),
      tabItem(tabName = "Emp",
              h2("Em construção"))
    )
  )
)


server <- function(input, output, session) {
  require(ggplot2)
  # Consulta
  
 
  output$msg <- renderText(str(msg))
  
  output$media <- renderValueBox({
    valueBox(round(mean(iris$Sepal.Length),2), "Valor", icon = icon("check"), color = "red")
  })
  
  output$desvio <- renderValueBox({
    valueBox(round(mean(iris$Sepal.Width),2), "Desvio", icon = icon("check"), color = "red")
  })
  
  output$var <- renderValueBox({
    valueBox(round(mean(iris$Petal.Width),2), "Variação", icon = icon("fad fa-percent"), color = "red")
  })
  
  # Cálculo
  output$valor <- renderValueBox({
    valueBox(round(median(iris$Petal.Width),2), "Valor", icon = icon("fad fa-percent"), color = "red")
  })
  
  
  output$desvio2 <- renderValueBox({
    valueBox(round(mean(iris$Sepal.Width),2), "Desvio", icon = icon("check"), color = "red")
  })
  
  output$var2 <- renderValueBox({
    valueBox(round(mean(iris$Petal.Width),2), "Variação", icon = icon("fad fa-percent"), color = "red")
  })
  
  
  output$plot1 <- renderPlot({
    ggplot(iris, aes(x=Sepal.Length))+
      theme_minimal()+  geom_histogram(fill="#9F0C0C") +
      theme(panel.grid.minor = element_blank(),
            panel.grid.major = element_blank())+
      xlab ("Length") + ylab("Frequência")+
      theme(legend.position="bottom")
  })
  
  output$plot2 <- renderPlot({
   
    ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, color=factor(Species)))+
      geom_point(aes(color = factor(Species)), alpha= 0.5)+
      geom_smooth(method='lm', aes(color= factor(Species)))+theme_minimal()+
      xlab ("Length") + ylab("Width)")+
      scale_color_manual(values = c("#000000", "#4682B4", "#9F0C0C"), name = "Tipo",
                         breaks=c("setosa", "versicolor", "virginica"))+
      theme(legend.position="bottom")
    
  })
  
  
}

shinyApp(ui, server)








