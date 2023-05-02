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
    light_blue = "#3F5B72",
    
  ),
  adminlte_sidebar(
    width = "200px",
    dark_bg = "#3F5B72", #lateral
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
                     selectInput("uf", "Estado", choices = c("AC", "AL", "AP", "AM", "BA","CE", "DF", "ES", "GO", "AM",
                                                             "MT", "MS", "MG", "PA", "PB",
                                                             "PE", "PI", "RJ", "RN", "RS",
                                                             "RO", "RR", "SC", "SP", "SE", "TO", " "), selected =" " ),
                     br(),
                     textInput("textM", "Município:"),
                      radioButtons('radiorede', 'Rede', list('Pública' = 'pública', 'Privada' = 'privada' ), selected = 'pública', inline = TRUE),
                     radioButtons('radiodim', 'Dimensão', list('Demodidática' = 0, 'Formação' = 1 ), selected = 0 ,inline = TRUE),
                     actionButton('Con', 'Clique')
                     
                   ),
                   tabPanel("Bairro", 
                            h3('Localização'),
                            solidHeader = FALSE,
                            #textInput("textM", "Município:"),
                            textInput("textB", "Bairro:"),
                            radioButtons('radiodim', 'Dimensão', list('Demodidática' = 0, 'Formação' = 1 ), inline = TRUE),
                            actionButton('Con', 'Clique'),
                            br(),
                            br(),
                            "*selecione Estado e Município na análise por município"
                            
                   ))
           
          )),
          fluidRow(
            column(width = 9.5,
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
              tabPanel("Histograma", "Municípios do Estado", plotOutput("plot1")),
              tabPanel("Dispersão", "Municípios do Estado", plotOutput("plot2"))
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
  require(readxl)
  require(stringi)
  base <- read_excel("baseambM.xlsx")
  # Consulta
  observeEvent(input$Con,{
    subbase <- subset(base, rede2 == input$radiorede) 
    
    mun <- tolower(stri_trans_general(input$textM, "Latin-ASCII"))
    #print(mun)
    indmun <- grep(mun, subbase$MunicNome)
    #print(indmun)
   
    
    if(length(indmun)==0){
      
      output$media <- renderValueBox({
        valueBox(0.00, "Não encontrado", icon = icon("check"), color = "red") #verificar se precisa ser a média
      })
      
      output$desvio <- renderValueBox({
        valueBox(0.00, "Não encontrado", icon = icon("check"), color = "red")
      })
      
      output$var <- renderValueBox({
        valueBox(0.00, "Não encontrado", icon = icon("fad fa-percent"), color = "red")
      })
      
      
    } else{
      subbase <- subset(subbase, SG_UF == input$uf & MunicNome == mun)
      if(input$radiodim == 0) {
        output$media <- renderValueBox({
          valueBox(round((subbase$Demomean),2), "Valor", icon = icon("check"), color = "red") #verificar se precisa ser a média
        })
        
        output$desvio <- renderValueBox({
          valueBox(round((subbase$Demosd),2), "Desvio", icon = icon("check"), color = "red")
        })
        
        output$var <- renderValueBox({
          valueBox(round(subbase$Democv,2), "Variação", icon = icon("fad fa-percent"), color = "red")
        })
        
      }else{
        
        output$media <- renderValueBox({
          valueBox(round((subbase$Formmean),2), "Valor", icon = icon("check"), color = "red") #verificar se precisa ser a média
        })
        
        output$desvio <- renderValueBox({
          valueBox(round((subbase$Formsd),2), "Desvio", icon = icon("check"), color = "red")
        })
        
        output$var <- renderValueBox({
          valueBox(round(subbase$Formcv,2), "Variação", icon = icon("fad fa-percent"), color = "red")
        })
        
        
      }
      
    }
    
  
 # Gráfico
    subgraf <- subset(base, rede2 == input$radiorede & SG_UF ==input$uf)
    
  output$plot1 <- renderPlot({
    
    
    if(input$radiodim == 0){
      val <- subset(subgraf, MunicNome == mun) 
      
      
      ggplot(subgraf, aes(x=Demomean))+
        theme_minimal()+  geom_histogram(fill="#9F0C0C") +
        theme(panel.grid.minor = element_blank(),
              panel.grid.major = element_blank())+
        xlab ("Demodidática") + ylab("Frequência")+
        theme(legend.position="bottom")+ geom_vline(xintercept = val$Demomean,  linetype = "dashed", color = "#3F5B72")+
        annotate("text", x = val$Demomean+3,  y = 20, label = val$Município, color = "#3F5B72")
      
       
      
    }else{
      val <- subset(subgraf, MunicNome == mun)
      
      
      ggplot(subgraf, aes(x=Formmean))+
        theme_minimal()+  geom_histogram(fill="#9F0C0C") +
        theme(panel.grid.minor = element_blank(),
              panel.grid.major = element_blank())+
        xlab ("Formação") + ylab("Frequência")+
        theme(legend.position="bottom")+geom_vline(xintercept = val$Formmean,  
                                                   linetype = "dashed", color = "#3F5B72")+
      annotate("text", x = val$Formmean+3,  y = 20, label = val$Município, color = "#3F5B72")
     
        
    } })
    
  output$plot2 <- renderPlot({
    
    val <- subset(subgraf, MunicNome == mun) 
    
    
    ggplot(subgraf, aes(x=Demomean, y= Formmean))+
      geom_point(alpha= 0.5, color ="#9F0C0C")+
      geom_point(aes(x = val$Demomean, y = val$Formmean), size = 5, color = "#3F5B72")+
      geom_smooth(method='lm')+theme_minimal()+
      xlab ("Demodidática") + ylab("Formação")+
      geom_vline(xintercept =val$Demomean, linetype = "dashed", color = "#3F5B72")+
      geom_hline(yintercept =val$Formmean, linetype = "dashed", color = "#3F5B72")+
      annotate("text", x = val$Demomean+3,  y = val$Formmean+2, label = " ", color = "#3F5B72")+
      theme(legend.position="bottom")
  })
  
 
  
  })
  
  # Bairros
  
  
  
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
  
  
 
  
  
}

shinyApp(ui, server)











