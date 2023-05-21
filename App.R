## APP - Ambiência Racia ###

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


baseB <- read_excel("baseambB.xlsx")

bair <- baseB$Bairro

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
              h3("Consulte"),
        
        fluidPage(
          useShinyjs(),
          fluidRow(
            
            column(width = 9.5, 
                   tabBox(
                     width = 9.5,
                     height = 380,
                     title = "Seu entorno",
                     tabPanel("Município",
                    solidHeader = FALSE,
                     selectInput("uf", "Estado", choices = c("AC", "AL", "AP", "AM", "BA","CE", "DF", "ES", "GO", "AM",
                                                             "MT", "MS", "MG", "PA", "PB",
                                                             "PE", "PI", "RJ", "RN", "RS",
                                                             "RO", "RR", "SC", "SP", "SE", "TO", " "), selected =" " ),
                     br(),
                     textInput("textM", "Município"),
                      radioButtons('radiorede', 'Rede', list('Pública' = 'pública', 'Privada' = 'privada' ), selected = 'pública', inline = TRUE),
                     radioButtons('radiodim', 'Dimensão', list('Demoempenho' = 0, 'Formação' = 1 ), selected = 0 ,inline = TRUE),
                     actionButton('Con', 'Clique')
                   ),
                   tabPanel("Bairro", 
                            solidHeader = FALSE,
                            #textInput("textM", "Município:"),
                            selectInput("Bair", "Bairro", choices = bair, selected = " " ),
                            radioButtons('radiodimB', 'Dimensão', list('Demoempenho' = 0, 'Formação' = 1 ), inline = TRUE),
                            actionButton('ConB', 'Clique'),
                            br(),
                            br(),
                            h5("*Primeiro preencha aba Município."),
                             h5("**Disponível preferencialmente para municípios com população > 2000 mil/hab.")
                            
                   ))
           
          )),
          fluidRow(
            box(
              title = "Medidas",
              collapsible = TRUE,
              collapsed = FALSE,
              width = 12,
            column(width = 9.5,
                   br(),
              valueBoxOutput("media", width = 4)
            ),
            column(width = 9.5,
                   valueBoxOutput("desvio", width = 4)),
            column(width = 9.5,
                   valueBoxOutput("var", width = 4)
              
            ))
            
          ),
          
          fluidRow(
            box(
              title = "Gráficos",
              collapsible = TRUE,
              collapsed = TRUE,
              width = 12,
              
                column(width = 12,
                       "Histograma", "Municípios do Estado", plotOutput("plot1")),
              br(),
               
                  column(width = 12,
                         "Dispersão", "Municípios do Estado", plotOutput("plot2"))
            
          )),
          br(),
          br(),
          h3("Calcule"),
          fluidRow(
            column(
              width = 9.5,
              height = 430,
              tabBox(
                width = 9.5,
                height = 410,
                title = "Seu ambiente",
                id = "tabset3",
                tabPanel("Local",
                         selectInput("ufA", "Estado", choices = c("AC", "AL", "AP", "AM", "BA","CE", "DF", "ES", "GO", "AM",
                                                                 "MT", "MS", "MG", "PA", "PB",
                                                                 "PE", "PI", "RJ", "RN", "RS",
                                                                 "RO", "RR", "SC", "SP", "SE", "TO", " "), selected =" " ),
                         br(),
                         textInput("textMA", "Município"),
                         textInput("BairA", "Bairro"),
                         actionButton("proximoA", "Siga"),
                         uiOutput("geral"),
                         h5("** Para bairros não encontrados o valor de referência será o municípial")
                         
                         
                ),
                tabPanel("Demoempenho",
                         solidHeader = FALSE,
                         h5("Dados do estabelecimento"),
                         numericInput('idnumerica1', 'Alunos Não-Brancos (%)', 0, min = 0, max = 100, step = 5),
                         numericInput('idnumerica2', 'Professores Não-Brancos (%)', 0, min = 0, max = 100, step = 5),
                         numericInput('Desemp', 'Diferença de desempenho - Município', value = NULL),
                         actionButton('ConC', 'Clique'),
                         uiOutput("Demo")
                         
                         
                         ),
                tabPanel("Formação ",
                         solidHeader = FALSE,
                         h5("Dados do estabelecimento"),
                         numericInput('idnumerica3', 'Professores com formação estudos afro-Brasileiros (%)', 0, min = 0, max = 100, step = 5),
                         numericInput('idnumerica4', 'Professores com formação direitos humanos (%)', 0, min = 0, max = 100, step = 5),
                         radioButtons('idmater1', 'Material didático sobre diversidade étnica', list('Sim' = 1, 'Não' = 0 ), inline = TRUE),
                         radioButtons('idmater2', 'Material didático sobre culturas indégenas', list('Sim' = 1, 'Não' = 0 ), inline = TRUE),
                         actionButton('ConD', 'Clique')
                  
                )
                
              )
              
            )
            
          ),
          
          fluidRow(
            box(
              title = "Resultado",
              collapsible = TRUE,
              collapsed = FALSE,
              width = 12,
              
            column(
              width = 9.5,
              valueBoxOutput("valor", width = 4)
            ),
            column(width = 9.5,
                   valueBoxOutput("desvio2", width = 4)),
            column(width = 9.5,
                   valueBoxOutput("var2", width = 4)
                   
           ),
           column(12, align = "right", downloadButton("down", "Download"))
          ))
          
          ),
        fluidRow(
          box(
            collapsible = TRUE,
            collapsed = FALSE,
            title = "Dúvidas e Sugestões",
            width = 12,
            #height = 410,
            column(
              width = 9.5,
            textInput("textNome", "Nome"),
            textInput("textEmail", "E-mail"),
            textInput("textTel", "Telefone")),
            tags$textarea(
              id = "textMsg",
              placeholder = "Digite seu texto...",
              rows = 5,
              style = "width: 100%; resize: vertical;"
            ),
            column(12, align = "right", actionButton('ConE', 'Enviar') )
           
            ),
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
  baseB <- read_excel("baseambB.xlsx")
  IDeA <- read_excel("IDeA.xlsx")
  #popraca <- read_excel("popraca.xlsx")
  
  # Consulta
  observeEvent(input$Con,{
    
    subbase <- subset(base, rede2 == input$radiorede & SG_UF == input$uf) 
    
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
      subbase <- subset(subbase, MunicNome == mun)
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
        xlab ("Demoempenho") + ylab("Frequência")+
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
      xlab ("Demoempenho") + ylab("Formação")+
      geom_vline(xintercept =val$Demomean, linetype = "dashed", color = "#3F5B72")+
      geom_hline(yintercept =val$Formmean, linetype = "dashed", color = "#3F5B72")+
      annotate("text", x = val$Demomean+3,  y = val$Formmean+2, label = " ", color = "#3F5B72")+
      theme(legend.position="bottom")
  })
  
  # Bairros - parte de filtro por municipio - input$textM
  
  subbaseB <- subset(baseB, SG_UF == input$uf) 
  
  munic <- unique(subbaseB$Bairro[subbaseB$MunicNome == mun])
  updateSelectInput(session, "Bair", choices = munic)
 
  
  })
  
  # Bairros
  observeEvent(input$ConB,{
    
    subbaseB <- subset(baseB, SG_UF == input$uf & Bairro == input$Bair)
    
    if(input$radiodimB == 0) {
      output$media <- renderValueBox({
        valueBox(round((subbaseB$Demomean),2), "Valor", icon = icon("check"), color = "red") 
      })
      
      output$desvio <- renderValueBox({
        valueBox(round((subbaseB$Demosd),2), "Desvio", icon = icon("check"), color = "red")
      })
      
      output$var <- renderValueBox({
        valueBox(round(subbaseB$Democv,2), "Variação", icon = icon("fad fa-percent"), color = "red")
      })
      
    }else{
      
      output$media <- renderValueBox({
        valueBox(round((subbaseB$Formmean),2), "Valor", icon = icon("check"), color = "red") 
      })
      
      output$desvio <- renderValueBox({
        valueBox(round((subbaseB$Formsd),2), "Desvio", icon = icon("check"), color = "red")
      })
      
      output$var <- renderValueBox({
        valueBox(round(subbaseB$Formcv,2), "Variação", icon = icon("fad fa-percent"), color = "red")
      })
      
      
    }
    
    
  })
  
  # Cálculo
  
  
  
  updateValue <- function(){
    munB <<- tolower(stri_trans_general(input$textMA, "Latin-ASCII"))
    subpop <<- subset(popraca, SG_UF == input$ufA & MunicNome == munB)
    
    
    matDV <- as.numeric(input$idmater1)
    matCI <- as.numeric(input$idmater2)
    
    
    valmoddemo <<- round(51.62 + 0.269*(input$idnumerica1-subpop$NBrancopopper) + 0.303*(input$idnumerica2-subpop$NBrancopopper)-
      12.20*subpop$DesMat,2)
    
   
    ## devolver o valor da diferença de desempenho
    DesMat <<- round(subpop$DesMat,2)
    
    ## Medo de bug - resolvi repetir o código, ver depois como simplificar
    
    bair <<- tolower(stri_trans_general(input$BairA, "Latin-ASCII"))
    
    subbaseBB <<- subset(baseB, SG_UF == input$ufA & MunicNome == munB) 
    indbar <<- grep(bair, subbaseBB$BairroNome)
    #print(indbar)
    
    subbaseC <<- subset(base, rede2 == 'privada' & SG_UF == input$ufA & MunicNome == munB) 
    
    #print(mun)
    indmunB <<- grep(munB, subbaseC$MunicNome)
    
    if(length(indbar)==0){
      
      if(length(indmunB) == 0){
        valordesv <<-0.00
        nomed <<- "Não Encontrado"
        valorvar <<- 0.00
        nomev <<- "Não Encontrado"
   
      }else{
        valordesv <<- round(subbaseC$Demomean,2)
        nomed <<- "Valor - Município"
        valorvar <<- round(subbaseC$Democv,2)
        nomev <<- "Variação - Município"
    
      }}
    else{
      subbaseBB <- subset(subbaseBB, BairroNome == bair)
      valordesv <<- round(subbaseBB$Demomean,2)
      nomed <<- "Valor - Bairro"
      valorvar <<- round( subbaseBB$Democv,2)
      nomev <<- "Variação - Bairro"
    } 
    
    # Formação
    
    valmodForm <<- round(0.626 + 0.623*input$idnumerica3 + 0.359*input$idnumerica4+0.399*(matDV+matCI),2)
    
    
    if(length(indbar)==0){
      
      if(length(indmunB) == 0){
        valordesvF <<-0.00
        nomeFd <<- "Não Encontrado"
        valorvarF <<- 0.00
        nomeFv <<- "Não Encontrado"
        
      }else{
        valordesvF <<- round(subbaseC$Formmean,2)
        nomeFd <<- "Valor - Município"
        valorvarF <<- round(subbaseC$Formcv,2)
        nomeFv <<- "Variação - Município"
        
      }}
    else{
      subbaseBB <- subset(subbaseBB, BairroNome == bair)
      valordesvF <<- round(subbaseBB$Formmean,2)
      nomeFd <<- "Valor - Bairro"
      valorvarF <<- round( subbaseBB$Formcv,2)
      nomeFv <<- "Variação - Bairro"
    } 
  }
  
  
  observeEvent(input$proximoA, {
    updateValue()
    
    updateTabsetPanel(session, "tabset3", selected = "Demoempenho")
    
    
    updateNumericInput(session, "Desemp", value = DesMat)
    shinyjs::disable("Desemp")
    
  })
  
  
  output$geral <- renderUI({
    tags$h3(" ")
  })
  
  observeEvent(input$ConC,{
  
   updateValue()
    
    if (input$idnumerica1 == 0|| input$idnumerica2 ==0){
      valmoddemo = 0
    }
   
    output$valor <- renderValueBox({
      valueBox(valmoddemo, "Valor - Estabelecimento", icon = icon("check"), color = "red")
    })
    
    
    output$desvio2 <- renderValueBox({
          valueBox(valordesv, nomed, icon = icon("check"), color = "red")
        })
        
    output$var2 <- renderValueBox({
          valueBox(valorvar, nomev, icon = icon("fad fa-percent"), color = "red")
        })
    
        
  })
  
  observeEvent(input$ConD,{
    
    updateValue()
    
    if (input$idnumerica3 == 0|| input$idnumerica2 ==0){
      valmodForm = 0
    }
    
    output$valor <- renderValueBox({
      valueBox(valmodForm, "Valor - Estabelecimento", icon = icon("check"), color = "red")
    })
    
    
    output$desvio2 <- renderValueBox({
      valueBox(valordesvF, nomeFd, icon = icon("check"), color = "red")
    })
    
    output$var2 <- renderValueBox({
      valueBox(valorvarF, nomeFv, icon = icon("fad fa-percent"), color = "red")
    })
    
    
    
  })
  
  CSV <- function(){
    updateValue()
    valorestD = 'Valor Estab'
    valorestF = 'Valor Estab'
    # Não consluta Demo
    if (input$idnumerica1 == 0 || input$idnumerica2 == 0){
      valmoddemo = 0.00
      valordesv = 0.00
      valorvar = 0.00
      nomed = iconv('Não Consultado', to = "ISO-8859-1" )
      nomev = iconv('Não Consultado', to = "ISO-8859-1" )
      valorestD = iconv('Não Consultado', to = "ISO-8859-1" )
    }
    # Não consulta Form
    if(input$idnumerica3 == 0 || input$idnumerica4 == 0){
      valmodForm = 0.00
      valordesvF = 0.00
      valorvarF = 0.00
      nomeFd = iconv('Não Consultado', to = "ISO-8859-1" )
      nomeFv = iconv('Não Consultado', to = "ISO-8859-1" )
      valorestF = iconv('Não Consultado', to = "ISO-8859-1" )
    }
    
    nomed = iconv(nomed, to ="ISO-8859-1")
    nomev = iconv(nomev, to ="ISO-8859-1")
    nomeFd = iconv(nomeFd, to ="ISO-8859-1")
    nomeFv = iconv(nomeFv, to ="ISO-8859-1")
    
  
    data <- data.frame(
      Valor = c(valmoddemo, valordesv, valorvar, 
                valmodForm, valordesvF,valorvarF),
      Tipo = c('Media', 'Desvio', 'C.Variacao',
               'Media', 'Desvio', 'C.Variacao'),
      Dimensao = c('Demodidatica', 'Demodidatica', 'Demodidatica',
                   'Formempenho', 'Formempenho','Formempenho'),
      Localidade = c( valorestD,nomed, nomev,
                      valorestF, nomeFd,nomeFv)
    )
   
    
    return(data)
    
  }
 
 
  output$down <- downloadHandler(
  
    filename = "valores.csv",
    content = function(file) {
      data <- CSV()
      write.csv2(data, file, row.names = FALSE)
    }
  )
  
  observeEvent(input$ConE, {
    textMsg <- isolate(input$textMsg)
    textEmail <- isolate(input$textEmail)
    textNome <- isolate(input$textNome)
    textTel <- isolate(input$textTel)
    
    if (!is.null(textMsg)) {
      # Caminho do arquivo
      file_path <- "inputs.txt"
      
      # Abre o arquivo em modo de escrita
      file_conn <- file(file_path, "a")
      
      # Escreve os textos no arquivo
      cat(' ', "\n", file = file_conn)
      cat(textNome, "\n", file = file_conn)
      cat(textEmail, "\n\n", file = file_conn)
      cat(textTel, "\n\n", file = file_conn)
      cat(textMsg, "\n", file = file_conn)
      
      # Fecha o arquivo
      close(file_conn)
      
      # Limpa os campos de texto
      updateTextAreaInput(session, "textMsg", value = "")
      updateTextAreaInput(session, "textEmail", value = "")
      updateTextAreaInput(session, "textNome", value = "")
      updateTextAreaInput(session, "textTel", value = "")
    }
  })
  
  
}



shinyApp(ui, server)





