#
# Curso de Desenvolvimento e Interface com Shiny
#
#    http://shiny.rstudio.com/
#

install.packages("installr")

library(installr)

library(shiny)
library(dplyr)

#  Resumo das Aulas Principais 
# 

# Aula sobre como esturturar a tela de aplicativo com shiny, a estrutra básica é um campo de input 
# princpalmente input de dados, botons, campos de entrada de textos, slicies e o campo de output 
# da tela chamada de MainPanel, mostram as saidas dos dashboard, saída dos dados. 

# Script

ui <-  fluidPage(
  titlePanel("Estrutura Principal"),
  
  sidebarLayout(position = "right", # é possivel colcoar os input na direita basta:
    sidebarPanel( 
      h2("Nessa área ficarão os dados de input") # h2 é uma das tags de htlm (ver na aula referente)
      
    ),
    mainPanel(
      h2("Aqui serão colocados os elementos de saída") # podem ser textos, imagens, gráficos e tabela
    )
  )
  
) # Aquivo de FrontEnd

server <- function(input, output) {
  
} # Aquivo responsável por conetar input e output programados. Aquivo de backEnd

shinyApp(ui, server)

# Aula de funções Render e Output - as de output são responsáveis por mostrar ao shiny onde mostrar nossos
# dados de saída, ja as render são funções responsáveis por atualizar os dados de saída toda vez 
# que os input fores acionados. Cada tipo de output tem um função específica, a render acompanha isso 

# veja a tabela:

# Funções de saída de dados 

# OutputFuntions        Creates
# dataTableOutput       DataTable
# htmlOutput            raw HTML
# imageOutput           imagem
# plotOutput            plot(gráficos)
# textOutput            text
# tableOutput           Table
# uiOtput               raw HTML

# Funções Render

# renderDataTable       DataTable
# renderImage           imagem
# renderPlot            plot (gráficos)
# renderPrint           any printed output
# renderTable           data frame, matrix e outros com estutura semelhante
# renderText            character sting
# renderUI              Objetos do shiny

ui <- fluidPage(
  titlePanel("Entrada e saida de dados"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("identrada", "informe o texto") # parâmetros id e label (definição do input)
    ),
    mainPanel(
      textOutput("idsaida") # parâmetro id
    )
  )
)

server <- function(input, output){
  output$idsaida <- renderText({input$identrada})
}

shinyApp(ui, server)


# Aula 7 - Entrada de Números 
# função numericInput, parâmetros: id, label, min, max e pulos (steps).

ui <- fluidPage(
  titlePanel("Entrada de Números"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput('idnumerica', 'informe o número', 0, min = 0, max = 100, step = 5) # parametros
    ),
    mainPanel(
      verbatimTextOutput('idsaida', placeholder = TRUE) # placeholder trava no valor máximo determinado
    )
    
  )
)

server <- function(input, output){
  output$idsaida <- renderText({input$idnumerica})
}

shinyApp(ui, server)


# Aula 9 - Radio Button 

# Muito utilizado para o usuário informar uma opção, por exemplo, formar o sexo, a raça, cor, tipo de 
# gráfico etc. 
# Parâmentros - id, label, choice (opções) e inline (True coloca as opções em linha), vc pode colocar
# uma lista o que pode facilitar depois comparções.


ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      #radioButtons('radioid', 'informe opção', choices = c('Branco', 'Negro', 'Pardo', 'Amarelo'), inline = FALSE)
      radioButtons('radioid', 'informe opcao', list('Branco' = 0, 'Negro' = 1, 'Pardo' = 3, 'Amarelo' = 4 ), inline = FALSE)
      ),
    mainPanel(
      verbatimTextOutput('opcoes')
    )
  )
)


server <- function(input, output) {
  output$opcoes <- renderText({input$radioid})
}

shinyApp(ui, server)


# Aula 11 - Action Button 

# Botão que quando acionado executa algum código dentro do servidor, ex. somar dois números. 
# parâmetros: id, label e icon (para incone, colocar definição em ingles)
# no server a função é renderizada pela oberverEvent (gatilho para realizar a operação cada vez 
# que for acionada) ele recebe uma valor reativo a um dada ação.

ui <-  fluidPage(
  sidebarLayout(
    sidebarPanel(
      actionButton('idbotao', 'clique no botao', icon('refresh') )
    ),
    mainPanel(
      textOutput('idsaida')
    )
  )
)

server <- function(input, output){
  observeEvent(input$idbotao, {
    #todo codigo que estiver dentro da função observerEvent será executado quando o botão for acionado
    #no caso exibir um texto.
    output$idsaida <- renderText("Mensagem que será exibida quando o botão for pressinado")
  })
}

shinyApp(ui, server)


# Aula Slider 

# Serve para pegar um número com o usuário dentro de uma escala determinada


ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput('idslider', 'Valor Informado', min = 0, max = 1000, step = 50, value = 500)
    ),
    mainPanel(
      textOutput('idsaida') # Irá retornar um texto
    )
    
  )
)

server <- function(input, output){
  output$idsaida <- renderText(input$idslider) # função para o que ira retornar - texto
}

shinyApp(ui, server)


# Aula 13 - CheckBoxGroupIput

# Sever para quando queremos apanha um grupo de itens (opções) selecionadas pelo o usuário, ele coloca
# um actionButton - para acomular as opções seleiconadas

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput('idchexbox', 'Seleicone Opcoes', list('radio'= 1, 'TV' = 2, 'Notebook' = 3, 'Ar Condicionado' = 4))
    ),
    mainPanel(
      actionButton('salvarProdutos', 'Clique')
    )
  )
)


ui <- fluidPage(
  splitLayout( #dividir o MainPainel # acrescentado
    Widths =  c("70%", "30%"),
    heights =  c("70%", "30%"),
    dir = "v",
    sidebarPanel( # esconder o sidebarpainel
      actionButton("toggle_sidebar", "Expandir/Recolher"),
      conditionalPanel(
        condition = "input.toggle_sidebar % 2 == 1",
      checkboxGroupInput('idchexbox', 'Seleicone Opcoes', list('radio'= 1, 'TV' = 2, 'Notebook' = 3, 'Ar Condicionado' = 4))
    )),
    mainPanel( # adicionando um selectInput no MainPainel # acrescentado 2023
      id = "seção1",
      selectInput("meu_select", "Selecione uma opção:", choices = c("Opção 1", "Opção 2", "Opção 3")),
      actionButton('salvarProdutos', 'Clique')
    ),
    mainPanel( # adicionando um selectInput no MainPainel # acrescentado 2023
      id = "seção2",
      selectInput("meu_select", "Selecione uma opção:", choices = c("Opção 1", "Opção 2", "Opção 3")),
      actionButton('salvarProdutos', 'Clique')
    ),
  )
)

server <- function(input, output){
  observeEvent(input$salvarProdutos, {
    opcoesselecionadas <- as.data.frame(input$idchexbox) # todas as opções serão acumuladas nessa data
    print(opcoesselecionadas) # Imprime na tela as opções selecionadas.
  })
}

shinyApp(ui, server)

# Aula 14 - Como Plotar Gráficos 
# Repare que o output de saida passa a ser o de entrada a partir do server, ele é quem link a parte
# da entrada sidebarpanel com o da saida da tela mainPanel vc programa o que ira e o que irá sair 
# liga ambos no servidor (backEnd), prestar atenção para saber exatamente o que está esperando como 
# resposta para cada ação programada.

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput('idhist', 'selecionar amostra', min = 100, max = 1000, value = 200)
    ),
    mainPanel(
      plotOutput('idgrafico')
    )
  )
)

server <- function(input, output){
  output$idgrafico <- renderPlot({hist(sample(input$idhist))})
}

shinyApp(ui, server)


# Pulei todos as aulas sobre as tags - importnates para formatar textos no shiny

# Aula progress bar - importante para mensurar o nível de processamento e informar para o usuário, 
# no exemplo um estará vinculado a um slider e outro a um for de 1 a 100. Para fazer isso precisa 
# de um biblioteca chaada shinywidgets

library(shinyWidgets)

ui <- fluidPage( # Reparar que nesse exemplo não dividimos a tela com sidebarLayout (não tem barra de 
  column( # de painel e parte principal do painel)
    width = 7,
    tags$b('Progresso vinculado ao slider'), br(), #tags ver nas aulas anteriores
    progressBar('pb1', value = 50),
    sliderInput('up1', 'Update', min = 0, max = 100, value = 50),
    br(),
    br(),
    progressBar('pb2', value = 0, total = 100, title = '', display_pct = TRUE),
    actionButton('go', 'Processar dados')
  )
)

server <- function(input, output, session){
  observeEvent(input$up1, {
    updateProgressBar(
      session = session, 
      id = 'pb1', 
      value = input$up1
      )
    })
  observeEvent(input$go, {
    for (i in 1:100) {
    updateProgressBar(session = session, 
                      id = 'pb2', 
                      value = i, 
                      total = 100, 
                      title = paste('Progresso'))
  Sys.sleep(0.1)}})
}

shinyApp(ui, server)


# Aula 19 - FluidRow e Colum 

# Na bliblioteca shiny a tela pode ser dividida em até 12 espaços, pode ser uma 3 colunas e 
# 4 linhas ou 4 linhas e 3 colunas, cada uma delas pode ser subvidida, caso se queira, em 
# no lado da barra e lado principal.  Então colum e fluidRow são muito importante para encontramos 
# uma estutura adequada para a página.

ui <- fluidPage(
  
  fluidRow(
    column(style = 'border: 1px solid black', width = 4, 'Conteudo'),
    column(style = 'border: 1px solid black', width = 4, 'Conteudo'),
    column(style = 'border: 1px solid black', width = 4, 'Conteudo')
  ),
  fluidRow(
    column(style = 'border: 1px solid black', width = 4, 'Conteudo'),
    column(style = 'border: 1px solid black', width = 4, 'Conteudo'),
    column(style = 'border: 1px solid black', width = 4, 'Conteudo')
    )
  )

server <- function(input, output){
  
}

shinyApp(ui, server)

## Outras divisões possíveis, vc pode colocar elementos de input ou de output que vc quiser em cada 
## parte.


ui <- fluidPage(
  titlePanel('Estuturua do App'),
  h4('ualalkdfkadfjakdfjkadjfkadfkla'),
  h5('jfkjaksdfjkasdjfkljasdkfjaksdjfkasdjkf'),
  fluidRow(
  column(3,
         checkboxGroupInput('idchexbox', 'Seleicone Opcoes', list('radio'= 1, 'TV' = 2, 'Notebook' = 3, 'Ar Condicionado' = 4)),
         sliderInput('sample', 'tamanho amostra', min = 0, max = 100, value = 50),
         sliderInput('sample', 'tamanho amostra', min = 0, max = 100, value = 50)
         
         ),
  column(3,
         sliderInput('sample', 'tamanho amostra', min = 0, max = 100, value = 50),
         sliderInput('sample', 'tamanho amostra', min = 0, max = 100, value = 50),
         sliderInput('sample', 'tamanho amostra', min = 0, max = 100, value = 50)
    
  ),
  column(3,
         sliderInput('sample', 'tamanho amostra', min = 0, max = 100, value = 50),
         sliderInput('sample', 'tamanho amostra', min = 0, max = 100, value = 50),
         sliderInput('sample', 'tamanho amostra', min = 0, max = 100, value = 50)
      )
    ),
  fluidRow(
    column(2,
          checkboxGroupInput('idchexbox', 'Seleicone Opcoes', list('radio'= 1, 'TV' = 2, 'Notebook' = 3, 'Ar Condicionado' = 4)),
           radioButtons('radioid', 'informe opcao', list('Branco' = 0, 'Negro' = 1, 'Pardo' = 3, 'Amarelo' = 4 ), inline = FALSE)
           
    ),
    column(3,
           sliderInput('sample', 'tamanho amostra', min = 0, max = 100, value = 50),
           sliderInput('sample', 'tamanho amostra', min = 0, max = 100, value = 50),
           radioButtons('radioid', 'informe opcao', list('Branco' = 0, 'Negro' = 1, 'Pardo' = 3, 'Amarelo' = 4 ), inline = FALSE)
           
    )
    
  )
)


server <- function(input, output){
  
}

shinyApp(ui, server)

# Aula 20 - NavBar Panel

# Útil para montar uma esturura de abas para página, dentro dela vc configura uma conjunto de tab
# que são os menus de cada tela.

ui <- navbarPage(title = 'Exemplo NavBar',
                 
                 tabPanel('Sobre a pagina',  
                          h4('Exemplo de utilização de NavBar')
                          ),
                 
                  tabPanel('Dados', tableOutput('data')), # o 1º parâmetro é nome da aba e resto é o que vai
                 # aparecer em cada um deles.
                  tabPanel('Grafico', 
                           sidebarLayout(
                             sidebarPanel(
                               sliderInput('b', 'selecione o numero de dados',
                                           min = 5, max = 20, value = 10)
                             ),
                             mainPanel(
                               plotOutput('plot')
                             )
                           )
                           ),
                  navbarMenu('Mais Opções',
                             tabPanel('Menu a', verbatimTextOutput('summary')),
                             tabPanel('Menu b', 
                                      h1('Dados sobre a pagina')))
                          )
                   

server <- function(input, output, session){
  output$data <- renderTable({mtcars})
  output$plot <- renderPlot({hist(mtcars$mpg, col = 'blue', breaks = input$b)})
  output$summary <- renderPrint({summary(mtcars$mpg)})
}

shinyApp(ui, server)


# Uma estutura ainda mais complexa é uma pagina com painel com várias abas. esse o chamado TabSet Panel 
# segue o codigo 

data("iris")
ui <- fluidPage(
  titlePanel(title = h4('Iris Dataset', align = 'center')),
  sidebarLayout(
    sidebarPanel(
      selectInput('var', '1. Selecione a variável do irisdataset', choices = c('Sepal.Length' =1, 
                                                                               'Sepal.width'=2,
                                                                               'Petal.Length'=3,
                                                                               'Petal.width'= 4), selected = 1),
      br(),
      sliderInput('bins', '2. selecione a quantidade de dados', min = 5, max = 25, value = 15),
      br(),
      radioButtons('color', '3. selecione a cor do histograma', choices = c('Green', 'Red', 'Yellow'), selected = 'Green'),
    
      ),
    
    mainPanel(
      tabsetPanel(
        type = 'tab',
        tabPanel('Summary', verbatimTextOutput('summary')),
        tabPanel('Structure'),
        tabPanel('Dados', tableOutput('dados')),
        tabPanel('Grafico', plotOutput('myhist'),
                 box(
                   title = 'Box 1', width = 4, solidHeader = TRUE, status = 'success','conteúdo' 
                 ))
        
      )
    )
  )
)


server <- function(input, output){
  output$dados <- renderTable({
    colm <- as.numeric(input$var)
    iris[colm]
  })
  output$myhist <- renderPlot({
    colm <- as.numeric(input$var)
    hist(iris[,colm], breaks = seq(0, max(iris[,colm]), l=input$bins+1),col=input$color,
                                   main='IRIS', xlab = names(iris[colm]), 
                                   xlim = c(0, max(iris[,colm])))
      })
  output$summary <- renderPrint({
    colm <- as.numeric(input$var)
    summary(iris[,colm])
    })
}

shinyApp(ui, server)



## estilização - 

## A ideia nesse é estilizar as h# que servem para definir textos, cada h#
# terá uma configuração prévia, de modo a estilizar o projeto. O Body é o 
# corpo da pagina vc pode configuar uma cor para ela e outros elementos.
# O nome disso é entregar o CSS com o projeto do R. Ele aconselha fazer um 
# curso específico de CSS para aprender a configurar paginas web.


ui <- fluidPage(
  
  tags$head(
    tags$style(HTML("
      @import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
      
      h1 {
        font-family: 'Lobster', cursive;
        font-weight: 500;
        line-height: 1.1;
        color: #48ca3b;
      }
      
      h3 {
        font-family: 'Lobster', cursive;
        font-weight: 300;
        line-height: 1.1;
        color: blue;
      }
      
      p {
        color:yellow; 
        font-size: 30px;
      }
      
      body {
        background-color: gray; 
      }

    "))
  ),
  
  headerPanel(tags$h1("New Application")),
  
  sidebarPanel(
  ),
  
  mainPanel(
    tags$h1("teste h1"),
    tags$h3("teste h3"),
    tags$p("teste P")
  )
)
server <- function(input, output){
  
}

shinyApp(ui, server)



## Vc pode guardar a configuração em um aquivo separado e usar sempre que quiser
## o exemplo abaixo mostra como.

ui <- fluidPage(
  
  includeCSS("style.css"), #arquivo bloco de notas com a configuração da pagina
  
  headerPanel("New Application"),
  
  sidebarPanel(
    sliderInput("obs", "Number of observations:", 
                min = 1, max = 1000, value = 500)
  ),
  
  mainPanel(plotOutput("distPlot"))
)

server <- function(input, output){
  
}

shinyApp(ui, server)

### Estilização com ShinyThemes

# como o seletor de thema vc escolher e setar o tema que quiser.
## no site do bootstrap vc tem uma lista de elemento estilizados 
#LINK BOOTSTRAP https://getbootstrap.com 
# pode sair formando a pagina e tal.

library(devtools)
install.packages("htmltools")

install.packages("shinythemes")
remotes::install_github("rstudio/htmltools")
remotes::install_github("rstudio/bslib") #acrecentado ao script em 2023


library(shinythemes)
library(shiny)
library(bslib) # implementação 2023
library(htmltools)

ui = fluidPage(
 shinythemes::themeSelector(), # seletor que permite a escolha do theme.
  sidebarPanel(
    textInput("txt", "Text input:", "text here"),
    sliderInput("slider", "Slider input:", 1, 100, 30),
    actionButton("action", "Button"),
    actionButton("action2", "Button2", class = "btn-primary")
  ),
  mainPanel(
    tabsetPanel(
      tabPanel("Tab 1"),
      tabPanel("Tab 2")
    )
  )
)



ui = fluidPage( 
  theme =  bs_theme(bg = "#f4f4ee", fg = "#a4544c", primary = "#547c94"), # implementação 2023 
  sidebarPanel(
    textInput("txt", "Text input:", "text here"),
    sliderInput("slider", "Slider input:", 1, 100, 30),
    actionButton("action", "Button"),
    actionButton("action2", "Button2", class = "btn-primary")
  ),
  mainPanel(
    tabsetPanel(
      tabPanel("Tab 1"),
      tabPanel("Tab 2")
    )
  )
)



server = function(input, output) {}

shinyApp(ui, server)



# As próximas aulas são sobre o pacote JS (Java Script do Shiny),
## vor ver mais não vou anotar nada.


# Aula 26 Como ler uma aquivo no shiny

# Como fazer se vc precisa ler um aquivo csv, por exemplo, fazer alguns calculos no servido e 
# mostrar o resultados para o usuário.
# a função é o FileInput, parâmetros: id, label, tipos de arquivos aceito pelo input (um vetor 
# com todos os tipos). Importante - necessariamente vc terá um radioButton para que o usuário marque so 
# e tão somente uma opção). Como vc pode abrir antes o arquivo nao vejo porque perder tanto tempo com 
# ver e digitar depois o codigo completo, logo mas sem nenhuma dificuldade.

ui <- fluidPage(
  titlePanel("Upload de arquivos"),
  sidebarLayout(
    sidebarPanel( # abaixo conjunto de tipo de arquivos aceitos pelo fileInput
      fileInput('idArquivo', 'Selecione o seu arquivo', accept = c('text/csv','text/comma-separated-values','text/tab-separated-values','.csv','.tsv')),
      tags$hr(),
      checkboxInput('header', 'Header', TRUE),
      radioButtons('sep', 'Separador de colunas',c("Virgula" =',',"Ponto e virgula" =';',"Tab" ='\t'),',')
    ),
    mainPanel(
      actionButton("idBotao","Ler o arquivo")
    )
  )
)

# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 9MB.
options(shiny.maxRequestSize = 9*1024^2) # configura o tamanho do arq. conforme necessidade.
server <- function(input, output) {     # Por definição aceita apenas arq. de no máximo 5 Mb.
  observeEvent(input$idBotao, {
    print(input$header)
    arquivo <- read.csv(input$idArquivo$datapath, header = input$header,sep = input$sep)
    #MyData <- read.csv(file="c:/TheDataIWantToReadIn.csv", header=TRUE, sep=",")
    print(arquivo)
  })
  
}

shinyApp(ui,server)


# Aula 27 - como mostrar aos dados lidos no shiny em tabelas e não mais no console. Também não é exatamente
# muito útil para nós no momento, também é sobre o FileInput.


# Aula 28 - Como vc fazer Download de aquivos. Também não vejo tanta utilidade, já que podemos fazer 
# esses Download por outros caminhos. O bom é que ensine como fazer write de aquivos gerados no shiny.

## Aula 29

library(shiny)
library(stringr)
library(readxl)
ui <- fluidPage(
  titlePanel("Upload de arquivos"),
  sidebarLayout(
    sidebarPanel(
      fileInput('idArquivo', 'Selecione o seu arquivo', accept = c('text/csv','text/comma-separated-values','text/tab-separated-values','.csv','.tsv','.xlsx')),
      tags$hr(),
      checkboxInput('header', 'Header', TRUE),
      radioButtons('sep', 'Separador de colunas',c("Virgula" =',',"Ponto e virgula" =';',"Tab" ='\t'),',')
    ),
    mainPanel(
      actionButton("idBotao","Ler o arquivo"),
      tableOutput("outTableId")
    )
  )
)

# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 9MB.
options(shiny.maxRequestSize = 9*1024^2)
server <- function(input, output) {
  observeEvent(input$idBotao, {
    tipoArquivo <- str_extract(input$idArquivo$datapath, ".csv")
    if(is.na(tipoArquivo)){
      arquivo <- read_excel(input$idArquivo$datapath, col_names = input$header)
    }else{
      arquivo <- read.csv(input$idArquivo$datapath, header = input$header,sep = input$sep)
    }
    
    #MyData <- read.csv(file="c:/TheDataIWantToReadIn.csv", header=TRUE, sep=",")
    output$outTableId <- renderTable({arquivo})
  })
  
}
shinyApp(ui,server)


### Aula 30 - Como ler os arq e mostar nos paineis 

library(shiny)
library(stringr)
library(readxl)
ui <- fluidPage(
  titlePanel("Upload de arquivos"),
  sidebarLayout(
    sidebarPanel(
      fileInput('idArquivo', 'Selecione o seu arquivo', accept = c('text/csv','text/comma-separated-values','text/tab-separated-values','.csv','.tsv','.xlsx')),
      tags$hr(),
      checkboxInput('header', 'Header', TRUE),
      radioButtons('sep', 'Separador de colunas',c("Virgula" =',',"Ponto e virgula" =';',"Tab" ='\t'),',')
    ),
    mainPanel(
      actionButton("idBotao","Ler o arquivo"),
      tableOutput("outTableId")
    )
  )
)

# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 9MB.
options(shiny.maxRequestSize = 9*1024^2)
server <- function(input, output) {
  observeEvent(input$idBotao, {
    tipoArquivo <- str_extract(input$idArquivo$datapath, ".csv")
    if(is.na(tipoArquivo)){
      arquivo <- read_excel(input$idArquivo$datapath, col_names = input$header)
    }else{
      arquivo <- read.csv(input$idArquivo$datapath, header = input$header,sep = input$sep)
    }
    
    #MyData <- read.csv(file="c:/TheDataIWantToReadIn.csv", header=TRUE, sep=",")
    output$outTableId <- renderTable({arquivo})
  })
  
}
shinyApp(ui,server)

### Como Baixar Arquivos - aula 31

# Única diferença download Botton - Pode ser importante para disponibiizar resultados para os usuários

ui <- fluidPage(
  
  titlePanel("Botão de download"),
  sidebarLayout(
    sidebarPanel(
      downloadButton("downloadData", "Download")
    ),
    mainPanel(
      
    )
  )
)

server <- function(input, output) {
  datasetInput <- cars
  
  output$downloadData <- downloadHandler(
    filename = function() {
      "arquivo.csv"
    },
    content = function(file) {
      write.csv(datasetInput, file, row.names = TRUE)
    }
  )
}
shinyApp(ui, server)


  

# Aula 32 - visualização de dados com a bliblioteca DT - bom para formatação de tabelas.

# Repare: diamonds é a única que tem um checkbox que vc pode escolher quais variáveis poder ser mostradas,
# de acordo com input do usuário. A iris é a unica que vc pode escolher quantos casos vc quer mostrar,
# para um exercicio valendo é só saber o que vc quer mostrar.


install.packages('DT')
library(ggplot2)
library(DT)


ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        'input.dataset === "diamonds"',
      checkboxGroupInput("show_vars", "colunas a serem mostras:",
                         names(diamonds), selected = names(diamonds))
      ),
      conditionalPanel(
        'input.dataset === "mtcars"'
      ),
      conditionalPanel(
        'input.dataset === "iris"'
      )
    ),
    mainPanel(
      tabsetPanel(
          id = 'dataset',
          tabPanel("diamonds", DT::dataTableOutput("mytable1")),
          tabPanel("mtcars", DT::dataTableOutput("mytable2")),
          tabPanel("iris", DT::dataTableOutput("mytable3"))
        )
      )
    )
  )


server <- function(input, output){
  
  diamonds2 = diamonds[sample(nrow(diamonds), 1000), ]
  output$mytable1 <- DT::renderDataTable({
    DT::datatable(diamonds2[, input$show_vars, drop = FALSE ])
  })
  output$mytable2 <- DT::renderDataTable({
    DT::datatable(mtcars, options = list(orderClasses = TRUE))
  })
  output$mytable3 <- DT::renderDataTable({
    DT::datatable(iris, options = list(lengthMenu = c(5, 30, 50), pareLength = 15))
  })
}

shinyApp(ui, server)


# Aula 31 - Biblioteca shiny Dashboard - é uma espécie de tema que podemos utilizar para estilizar 
# de forma mais adequada o nosso App, mas tudo que vimos nas aulas anteriores continua valendo.
# a diferença maior é que vc não trabalha com fluidPage e sim com dashboardPage()

install.packages("shinydashboard")
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = 'sib shinyDashBoard'), # coloca o nosso título
  dashboardSidebar(
    sidebarMenuOutput("menu")# vc pode construir configuração do output do nosso menu
  ),
  dashboardBody() # A estutrua anterior pode ser colocada aqui, como vimos antes.
)

server <- function(input, output){
  output$menu <- renderMenu({
    sidebarMenu(
      menuItem("Menu itens", icon = icon("calendar") )
    )
  })
}

shinyApp(ui, server)

# Aula 32 Criando uma dashboard 

# Aqui o destaque vai para as esturutra box, um item que ajuda a estruturar nossa dashboard
# dentro delas é possivel colocar gráficos tabelas e texto e deixar portanto apresentação mais elegante
# uma opção é salvar toda estrutura do dashboardBory em uma variável e utlizar td dentro da dashboardPage()
# imporatante saber que naão podemos ultrapassar o valor de 12 - width = 4 * 3 = 12.

body <- dashboardBody(
  
  fluidRow(
    box(title = 'Box', 'Conteudo'),
    box(status = 'warning', 'conteudo')
  ),
  
  fluidRow(
    box(
      title = 'Box 1', width = 4, solidHeader = TRUE, status = 'success','conteúdo' 
    ), #primary, success, info, warning, danger.
    box(
      title = 'Box 2', width = 4, solidHeader = TRUE, 'conteúdo' 
    ),
    box(
      title = 'Box 3', width = 4, solidHeader = TRUE, status = 'warning','conteúdo'
     )
    ),
    fluidRow(
      box(
        width = 4, background = 'black', # podemos colocar qualquer cor
        "Box sem título"
      ),
      box(
        title = 'Box 5', width = 4, background = 'black'
      ),
      box(
        title = 'conteudo', width = 4
      )
    )
  )

ui <- dashboardPage(
  dashboardHeader(title = 'Aula Box'),
  #dashboardSidebar(), # Para desabilitar a barra de menu, no caso não está servindo.
  dashboardSidebar(disable = TRUE),
  body
)

server <- function(input, output){
  
}

shinyApp(ui, server)

# Aula 33 - Trabalhando com Box com outputs diferentes de textos, são plots, sliders e outros


library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Aula Box"),
  dashboardSidebar( # configuração do menu
    sidebarMenu(
      menuItemOutput("menuitem"),
      menuItemOutput("menuitem2"),
      textInput("idvalor", "informe o valor" )
      )
    ) ,
  
  dashboardBody( # configuração do corpo da página
   
    box(
      title = "Histograma", status = "primary", solidHeader = TRUE,
      collapsible = TRUE, # reduz o conteúdo da box, botão para esconder esse conteúdo.
      plotOutput("plot", height = 250)
    ),
    box(
      title = "Inputs", status = 'warning', solidHeader = TRUE,
      sliderInput("sliderid", "selecione o valor:", 1, 100,50),
      textInput('idTaxa', 'Informe a taxa:')
    )
  ))


server <- function(input, output) {
  output$menuitem <- renderMenu({
    menuItem("Menu item", icon = icon("calendar"))
  })
  output$menuitem2 <- renderMenu({
    menuItem("Menu item", icon = icon("refresh"))
  })
  numeros <- c(1,2,5,7,8,8,8,1,2,4) # vetor de números, podia ser uma variável qualquer.
  output$plot <- renderPlot(hist(numeros, main= 'Histograma'))
}

shinyApp(ui, server)


# Aula 34 - value box 

# uma caixa utilzada para mostra valores, uma percentagem, um total de algo etc.


ui <- dashboardPage(
  dashboardHeader(title = "Caixa de Valores"),
  dashboardSidebar(),
  dashboardBody(
    fluidRow(
      valueBox(10 * 2, "Novas Compras", icon = icon("credit-card")),
      valueBoxOutput("progressBox"), # valores que serão definidos no server
      valueBoxOutput('AprovalBox')
    ),
    fluidRow(
      box(width = 4, actionButton('count', "Incrementar"))
    )
  )
)


server <- function(input, output){
  
  output$progressBox <- renderValueBox({
    valueBox(paste(25 + input$count, "%"), "Progresso", icon = icon("list"), color = "purple")
  })
  output$approvalBox <- renderValueBox({
    valueBox("80%", "approvacao", icon = icon("thumbs-up", lib = "glyphicon"), color = "yellow")
  })
}

shinyApp(ui, server)

# site com lista de icon - https://fontawesome.com/icons?from-io


# Aula 35 - como hospedar os nossos projetos 

# exitem contas gratuitas e contas pagas 
 # vou assitir e depois fazer a minha conta.

# Aula 36 - Ele ensina a colocar o codigo em rede, no servidor do shiny (palno básico 26 hs de uso)
# aquivar a aplicação significa que ninguem vai poder mais acessar.
# o plano reset todo fim de mes - 26hs o mês, no plano start vc terá mais de 100hs mês.



# Alua 38 - Resolvendo problemas de acentos - Ex. O que ele indica é copiar a palavra e converter 
# Para UTF-8 em algum site de converesão. Na execução local pode não dar muito problema, mas quando 
# Subimos para o servidor isso costuma dá problema.

ui <- fluidPage( # Reparar que nesse exemplo não dividimos a tela com sidebarLayout (não tem barra de 
  column( # de painel e parte principal do painel)
    width = 7,
    tags$b('Progresso vínculo ao slider'), br(), #tags ver nas aulas anteriores
    progressBar('pb1', value = 50),
    sliderInput('up1', 'Update', min = 0, max = 100, value = 50),
    br(),
    br(),
    progressBar('pb2', value = 0, total = 100, title = '', display_pct = TRUE),
    actionButton('go', 'Processar à dados')
  )
)

server <- function(input, output, session){
  observeEvent(input$up1, {
    updateProgressBar(
      session = session, 
      id = 'pb1', 
      value = input$up1
    )
  })
  observeEvent(input$go, {
    for (i in 1:100) {
      updateProgressBar(session = session, 
                        id = 'pb2', 
                        value = i, 
                        total = 100, 
                        title = paste('Progresso'))
      Sys.sleep(0.1)}})
}

shinyApp(ui, server)

??progressBar

# Aula 39 - Projeto final - Painel com tres linhas onde vão ser mostrados gráficos e algumas informa
# ções. Não consegui acertar o codigo inteiro tem que ver com mais calma. 

library(shiny)
library(shinydashboard)
library(plyr)

bordy <- dashboardBody(
  fluidRow(
    box(
      title = "Carro com o melhor consumo", width = 6, solidHeader = TRUE, status = "success", "Toyota Corolla"
    ), # Obervar que as informações em status estão fixas e não dinâmicas (mas é possível inverter).
    box(
      title = "Carro com o pior consumo", width = 6, solidHeader = TRUE, status = "danger", "Cadillac Fleetwood"
    )
  ),
  fluidRow(
    valueBoxOutput("menorconsumo"),
    valueBoxOutput("Consumomedio"),
    valueBoxOutput("maiorconsumo")
  ),
  
  fluidRow(
    box(
      title = "Cambios utilizados", status = "primary", solidHeader = TRUE,  collapsible = TRUE, 
      plotOutput("plot")
      ),
    box(
      title = "Histograma", status = "primary", solidHeader = TRUE, collapsible = TRUE,
      plotOutput("plot2")
    )
  ),
  
  fluidRow(
    valueBoxOutput("mediaMPG_aut", width = 2), # média de consumo
    valueBoxOutput("mediaMPG_man", width = 2), # média pontecia (cavalos)
    valueBoxOutput("mediaHP_aut", width = 2), # média de peso
    valueBoxOutput("mediaHP_man", width = 2),
    valueBoxOutput("mediaWT_aut", width = 2),
    valueBoxOutput("mediaWT_man", width = 2)
  )
)

ui <- dashboardPage(
  dashboardHeader(title = "MTCARS"),
  dashboardSidebar(disable = TRUE),
  bordy
)

server <- function(input, output) {
  mtcars2 <- mtcars
  mtcars2 <- as.data.frame(mtcars2) #.am serve rara agrupar os dados conforme pede as informações
  dados <- ddply(mtcars2, .(am), summarize, mediaMPG = mean(mpg), mediaDISP = mean(disp), 
                 mediaHp = mean(hp), mediaDRAT = mean(drat), mediaWT = mean(wt), mediaQSEC = mean(qsec), 
                 quantMODELO = length(am))
  maiorconsumo <- max(mtcars2$mpg)
  menorconsumo <- min(mtcars2$mpg)
  consumoMédio <- mean(mtcars2$mpg)
  dadosGrafico <- as.data.frame(dados$quantMODELO)
  
  output$menorconsumo <- renderValueBox({
    valueBox(menorconsumo, "Menor Consumo", icon = icon("thumbs-up", lib = "glyphicon"), color = "green")
  })
  output$conusmomedio <- renderValueBox({
    valueBox(round(consumomedio,2), "Consumo Medio", icon = icon("balance-scale"), color = "yellow")
  })
  output$maiorconsumo <- renderValueBox({
    valueBox(maiorconsumo, "Maior Consumo", icon = icon("angry"), color = "red")
  })
  output$plot <- renderPlot(pie(as.numeric(dados$quantMODELO), main = "Tipo de Cambio", labels = c("Automático", "Manual")))
  output$plot2 <- renderPlot(hist(mtcars2$cyl, xlab = "Quantidade de Cilindros", ylab = "Ocorrencias", main = "Quantidade de carros por cilindros"))
  
  output$mediaMPG_aut <- renderValueBox({
    valueBox(round(dados[1,2],2), "Consumo médio automatico", color = "navy")
  })
  output$mediaMPG_man <- renderValueBox({
    valueBox(round(dados[2,2],2, "Consumo medio manual"))
  })
  
  output$mediaHP_aut <- renderValueBox({
    valueBox(round(dados[1,4],2, "Potencia media automatica"))
  })
  output$mediaHP_man <- renderValueBox({
    valueBox(round(dados[2,4],2, "Potencia media manual"))
  })
  
  output$mediaWT_aut <- renderValueBox({
    valueBox(round(dados[1,6],2, "Peso media automatica"))
  })
  output$mediaWT_man <- renderValueBox({
    valueBox(round(dados[2,6],2, "Peso media manual"))
  })
}


shinyApp(ui, server)



##### Aula 43 - Puleia de hospedagem por hora dessa vez, estão tds mais acima 
### Analisando a dataset MTCARS

library(shinydashboard)
library(shiny)
library("plyr")

data("mtcars")

body <- dashboardBody(
  
  fluidRow(
    box(
      title = "Carro com o melhor consumo", width = 6, solidHeader = TRUE, status = "success", "Toyota Corolla"
    ), #primary, success, info, warning, danger.
    box(
      title = "Carro com o pior consumo", width = 6, solidHeader = TRUE, status = "danger", "Cadillac Fleetwood"
    )
  ),
  
  fluidRow(
    valueBoxOutput("menorConsumo"),
    valueBoxOutput("consumoMedio"),
    valueBoxOutput("maiorConsumo")
  ),
  
  fluidRow(
    box(
      title = "Cambios utilizados", status = "primary", solidHeader = TRUE, collapsible = TRUE,
      plotOutput("plot")
    ),
    box(
      title = "Histograma", status = "primary", solidHeader = TRUE, collapsible = TRUE,
      plotOutput("plot2")
    )
  ),
  
  fluidRow(
    valueBoxOutput("mediaMPG_aut", width = 2),
    valueBoxOutput("mediaHP_aut", width = 2),
    valueBoxOutput("mediaWT_aut", width = 2),
    valueBoxOutput("mediaMPG_man", width = 2),
    valueBoxOutput("mediaHP_man", width = 2),
    valueBoxOutput("mediaWT_man", width = 2)
  )
  
)


ui <- dashboardPage(
  dashboardHeader(title = "MTCARS"),
  dashboardSidebar ( disable = TRUE ),
  body
)


server <- function(input, output){
  mtcars2 <- mtcars
  mtcars2 <- as.data.frame(mtcars2)
  dados <- ddply(mtcars2, .(am),summarize,mediaMPG = mean(mpg), mediaDISP = mean(disp), mediaHp = mean(hp), mediaDRAT = mean(drat), mediaWT = mean(wt), mediaQSEC = mean(qsec), quantMODELO = length(am))
  maiorConsumo <- max(mtcars2$mpg)
  menorConsumo <- min(mtcars2$mpg)
  consumoMedio <- mean(mtcars2$mpg)
  dadosGrafico <- as.data.frame(dados$quantMODELO)
  
  output$menorConsumo <- renderValueBox({
    valueBox(paste0(menorConsumo, " MPG"), "Menor consumo", icon = icon("thumbs-up", lib = "glyphicon"),color = "green")
  })
  
  output$consumoMedio <- renderValueBox({
    valueBox(paste0(round(consumoMedio,2), "MPG"), "Consumo medio", icon = icon("balance-scale"),color = "yellow")
  })
  
  output$maiorConsumo <- renderValueBox({
    valueBox(paste0(maiorConsumo, "MPG"), "Maior consumo", icon = icon("angry"),color = "red")
  })
  
  output$plot <- renderPlot(pie(as.numeric(dados$quantMODELO), main = "Tipo de câmbio",  labels = c("Automático", "Manual")))
  
  output$plot2 <- renderPlot(hist(mtcars2$cyl, xlab = "Quantidade de cilindros", ylab = "Ocorrências", main = "Quantidade de carros por cilindros"))
  
  output$mediaMPG_aut <- renderValueBox({
    valueBox(paste0(round(dados[1,2],2), "MPG"), "Consumo médio automático", color = "navy")
  })
  
  output$mediaMPG_man <- renderValueBox({
    valueBox(paste0(round(dados[2,2],2), "MPG"), "Consumo médio manual")
  })
  
  output$mediaHP_aut <- renderValueBox({
    valueBox(paste0(round(dados[1,4],2), "HP"), "Potência média automático", color = "navy")
  })
  
  output$mediaHP_man <- renderValueBox({
    valueBox(paste0(round(dados[2,4],2), "HP"), "Potência média manual")
  })
  
  output$mediaWT_aut <- renderValueBox({
    valueBox(paste0(round(dados[1,6],2), "WT"), "Peso médio automático", color = "navy")
  })
  
  output$mediaWT_man <- renderValueBox({
    valueBox(paste0(round(dados[2,6],2), "WT"), "Peso médio manual")
  })
}
shinyApp(ui, server)


#### Exemplo do Enen

## Dashboard bem completa, bom olhar etapa por etapa, vê e rever a 
## a aula quanto for tentar construir o projeto

library(shiny)
library(shinydashboard)
library(ECharts2Shiny)
library(dplyr)
library(ggplot2)
library(stringr)
library(esquisse)
library(DT)
library(r2d3)

dados <- read.csv(file = "amostra.csv")

#quant de alunos por estado
alunosEstado <- dados %>% group_by(SG_UF_RESIDENCIA) %>% summarise(quantAlunos = n()) %>% arrange(desc(quantAlunos))

#quant de alunos por cidade
alunosCidade <- dados %>% group_by(NO_MUNICIPIO_ESC) %>% summarise(quantAlunos = n()) %>% arrange(desc(quantAlunos)) %>% collect()

#quant de alunos que v?o fazer provas em braille
provaBraille <- dados %>% filter(IN_BRAILLE == 1) %>% summarise(quantidade = n()) %>% collect()

#alunos treineiros
treineiros <- dados %>% filter(IN_TREINEIRO == 1) %>% summarise(quantidade = n()) %>% collect()

#cadeira canhoto
canhoto <- dados %>% filter(IN_CADEIRA_CANHOTO == 1) %>% summarise(quantidade = n()) %>% collect()

#presentes
quantPresentes1dia <- as.integer(dados %>% filter(TP_PRESENCA_CH == 1) %>% summarise(quantidade = n()) %>% collect())
quantPresentes2dia <- as.integer(dados %>% filter(TP_PRESENCA_MT == 1) %>% summarise(quantidade = n()) %>% collect())

#idade media dos participantes
idadeMedia <- dados %>% filter(NU_IDADE > 0) %>% summarise(mediaIdade = mean(NU_IDADE)) %>% collect()
idadeMedia <- round(idadeMedia, 2)

#sexo dos participantes
sexo <- dados %>% filter(TP_SEXO %in% c("M", "F")) %>% group_by(TP_SEXO) %>% count() %>% ungroup() %>% mutate(porcentagem = round(n/sum(n),4)*100,  lab.pos = cumsum(porcentagem)-.5*porcentagem)

#quantidade de alunos por lingua estrangeira
#0	Ingl?s
#1	Espanhol
linguaEstrangeira <- dados %>% group_by(TP_LINGUA) %>% count() %>% ungroup() %>% mutate(porcentagem = round(n/sum(n),4)*100,  lab.pos = cumsum(porcentagem)-.5*porcentagem)
linguaEstrangeira <- as.data.frame(linguaEstrangeira)
linguaEstrangeira$TP_LINGUA <- str_replace(linguaEstrangeira$TP_LINGUA, "1", "Ingl?s")
linguaEstrangeira$TP_LINGUA <- str_replace(linguaEstrangeira$TP_LINGUA, "0", "Espanhol")

#nacionalidade
#1	Brasileiro(a)
#2	Brasileiro(a) Naturalizado(a)
#3	Estrangeiro(a)
#4	Brasileiro(a) Nato(a), nascido(a) no exterior
quantNacionalidade <- dados %>% filter(TP_NACIONALIDADE != 0) %>% group_by(TP_NACIONALIDADE) %>% summarise(quantidade = n()) %>% arrange(desc(quantidade))
quantNacionalidade$TP_NACIONALIDADE <- str_replace(quantNacionalidade$TP_NACIONALIDADE, "1", "Brasileiro(a)")
quantNacionalidade$TP_NACIONALIDADE <- str_replace(quantNacionalidade$TP_NACIONALIDADE, "2", "Brasileiro(a) Naturalizado(a)")
quantNacionalidade$TP_NACIONALIDADE <- str_replace(quantNacionalidade$TP_NACIONALIDADE, "3", "Estrangeiro(a)")
quantNacionalidade$TP_NACIONALIDADE <- str_replace(quantNacionalidade$TP_NACIONALIDADE, "4", "Brasileiro(a) Nato(a), nascido(a) no exterior")

nacionalidade <- c(rep(as.character(quantNacionalidade[1,1]), as.integer(quantNacionalidade[1,2])),
                   rep(as.character(quantNacionalidade[2,1]), as.integer(quantNacionalidade[2,2])),
                   rep(as.character(quantNacionalidade[3,1]), as.integer(quantNacionalidade[3,2]))
)

#localizacao escola
#1	Urbana
#2	Rural
quantLocalicazao <- dados %>% group_by(TP_LOCALIZACAO_ESC) %>% summarise(quant = n())
quantLocalicazao <- as.data.frame(quantLocalicazao)
quantLocalicazao$TP_LOCALIZACAO_ESC <- str_replace(quantLocalicazao$TP_LOCALIZACAO_ESC, "1", "Urbana")
quantLocalicazao$TP_LOCALIZACAO_ESC <- str_replace(quantLocalicazao$TP_LOCALIZACAO_ESC, "2", "Rural")
quantLocalicazao$TP_LOCALIZACAO_ESC <- str_replace(quantLocalicazao$TP_LOCALIZACAO_ESC, "NA", "N?o informado")
quantLocalicazao <- quantLocalicazao[-3,]

localizacao <- c(rep(as.character(quantLocalicazao[1,1]), as.integer(quantLocalicazao[1,2])), rep(as.character(quantLocalicazao[2,1]), as.integer(quantLocalicazao[2,2])))

#situacao de conclusao do EM
#1	J? conclu? o Ensino M?dio
#2	Estou cursando e concluirei o Ensino M?dio em 2015
#3	Estou cursando e concluirei o Ensino M?dio ap?s 2015
#4	N?o conclu? e n?o estou cursando o Ensino M?dio
conclusaoEM <- dados %>% group_by(TP_ST_CONCLUSAO) %>% summarise(quant = n()) %>% arrange(TP_ST_CONCLUSAO) %>% collect()
conclusaoEM <- cbind(c("J? conclu? o Ensino M?dio", "Estou cursando e concluirei o Ensino M?dio em 2015", "Estou cursando e concluirei o Ensino M?dio ap?s 2015", "N?o conclu? e n?o estou cursando o Ensino M?dio"), conclusaoEM)

#media dos alunos por tipo de escola
#1	N?o Respondeu
#2	P?blica
#3	Privada
#4	Exterior
#dados %>% group_by(TP_ESCOLA) %>% summarise(mediaNotasMT = mean(NU_NOTA_MT), mediaNotasCN = mean(NU_NOTA_CN), mediaNotasCH = mean(NU_NOTA_CH), mediaNotasLC = mean(NU_NOTA_LC)) %>% 
# mutate(mediaAreas = (mediaNotasMT + mediaNotasCN + mediaNotasCH + mediaNotasLC) / 4) %>% arrange(desc(mediaAreas))

#redacao
competenciasRedacao <- dados %>% filter(NU_NOTA_COMP1 > 0 & NU_NOTA_COMP2 > 0 & NU_NOTA_COMP3 > 0 & NU_NOTA_COMP4 > 0 & NU_NOTA_COMP5 > 0) %>% group_by(TP_ESCOLA) %>% summarise(comp1 = mean(NU_NOTA_COMP1), comp2 = mean(NU_NOTA_COMP2), comp3 = mean(NU_NOTA_COMP3), comp4 = mean(NU_NOTA_COMP4), comp5 = mean(NU_NOTA_COMP5)) %>%  arrange(TP_ESCOLA) %>% collect()
competenciasRedacao <- as.data.frame(competenciasRedacao)
competenciasRedacao$TP_ESCOLA <- NULL
competenciasRedacao <- t(competenciasRedacao)
competenciasRedacao <- as.data.frame(competenciasRedacao)
competenciasRedacao <- rbind(0, competenciasRedacao)
names(competenciasRedacao) <- c("N?o respondeu", "P?blica", "Privada", "Exterior")
row.names(competenciasRedacao) <- c("0","COMP 1", "COMP 2", "COMP 3", "COMP 4", "COMP 5")

#renda
#A	Nenhuma renda.
#B	At? R$ 954,00.
#C	De R$ 954,01 at? R$ 1.431,00.
#D	De R$ 1.431,01 at? R$ 1.908,00.
#E	De R$ 1.908,01 at? R$ 2.385,00.
#F	De R$ 2.385,01 at? R$ 2.862,00.
#G	De R$ 2.862,01 at? R$ 3.816,00.
#H	De R$ 3.816,01 at? R$ 4.770,00.
#I	De R$ 4.770,01 at? R$ 5.724,00.
#J	De R$ 5.724,01 at? R$ 6.678,00.
#K	De R$ 6.678,01 at? R$ 7.632,00.
#L	De R$ 7.632,01 at? R$ 8.586,00.
#M	De R$ 8.586,01 at? R$ 9.540,00.
#N	De R$ 9.540,01 at? R$ 11.448,00.
#O	De R$ 11.448,01 at? R$ 14.310,00.
#P	De R$ 14.310,01 at? R$ 19.080,00.
#Q	Mais de R$ 19.080,00.

resultado <- dados %>% filter(Q006 != "NA") %>% group_by(Q006) %>% summarise(quantidade = n()) %>% arrange(desc(quantidade)) %>% collect()

#presen?a
#0 - Faltou ? prova
#1 - Presente na prova
#2 - Eliminado na prova
#dados %>% filter(TP_PRESENCA_CH != "NA" && TP_PRESENCA_CN != "NA" && TP_PRESENCA_LC != "NA" && TP_PRESENCA_MT != "NA") %>% 
#group_by(TP_PRESENCA_CH, TP_PRESENCA_CN, TP_PRESENCA_LC, TP_PRESENCA_MT) %>% summarise(quantidade = n()) %>% arrange(desc(quantidade))

#media de notas entre MG e SP
#teste <- dados %>% filter(SG_UF_RESIDENCIA %in% c("MG", "SP") & NU_NOTA_MT > 0 & NU_NOTA_CH > 0) %>% group_by(SG_UF_RESIDENCIA) %>% 
#summarise(mediaNotasMT = mean(NU_NOTA_MT), mediaNotasCN = mean(NU_NOTA_CN), mediaNotasCH = mean(NU_NOTA_CH), mediaNotasLC = mean(NU_NOTA_LC))

#ranking de escolas
consulta <- dados %>% group_by(CO_ESCOLA,NO_MUNICIPIO_ESC,SG_UF_ESC,TP_ESCOLA) %>% 
  summarise(quantParticipantes = n(), mediaNotasMT = round(mean(NU_NOTA_MT),3), mediaNotasCN = round(mean(NU_NOTA_CN),3), mediaNotasCH = round(mean(NU_NOTA_CH),3), mediaNotasLC = round(mean(NU_NOTA_LC),3), mediaNotasRedacao = round(mean(NU_NOTA_REDACAO),3)) %>%  
  mutate(mediaGeral = round(((mediaNotasMT+mediaNotasCN+mediaNotasCH+mediaNotasLC+mediaNotasRedacao)/5),3)) %>% arrange(desc(mediaGeral))

consulta$TP_ESCOLA <- str_replace(consulta$TP_ESCOLA, "1", "N?o respondeu")
consulta$TP_ESCOLA <- str_replace(consulta$TP_ESCOLA, "2", "P?blica")
consulta$TP_ESCOLA <- str_replace(consulta$TP_ESCOLA, "3", "Privada")
consulta$TP_ESCOLA <- str_replace(consulta$TP_ESCOLA, "4", "Exterior")

colnames(consulta) <- c("C?digo Escola", "Munic?pio", "Estado", "Tipo Escola", "Participantes", "M?dia MT", "M?dia CN", "M?dia CH", "M?dia LC", "M?dia Reda??o", "M?dia Geral")

notaMediaCH <- round(dados %>% filter(NU_NOTA_CH > 0) %>% summarise(mediaCH = mean(NU_NOTA_CH)),2)
notaMediaLC <- round(dados %>% filter(NU_NOTA_LC > 0) %>% summarise(mediaLC = mean(NU_NOTA_LC)),2)
notaMediaCN <- round(dados %>% filter(NU_NOTA_CN > 0) %>% summarise(mediaCN = mean(NU_NOTA_CN)),2)
notaMediaMT <- round(dados %>% filter(NU_NOTA_MT > 0) %>% summarise(mediaMT = mean(NU_NOTA_MT)),2)

notasMediasTipoEscola <- dados %>% filter(NU_NOTA_MT > 0 & NU_NOTA_CH > 0 & NU_NOTA_CN > 0 & NU_NOTA_LC > 0) %>% group_by(TP_ESCOLA) %>%summarise(mediaNotasMT = round(mean(NU_NOTA_MT),3), mediaNotasCN = round(mean(NU_NOTA_CN),3), mediaNotasCH = round(mean(NU_NOTA_CH),3), mediaNotasLC = round(mean(NU_NOTA_LC),3), mediaNotasRedacao = round(mean(NU_NOTA_REDACAO),3))
notasMediasTipoEscola <- as.data.frame(notasMediasTipoEscola)
notasMediasTipoEscola$TP_ESCOLA <- str_replace(notasMediasTipoEscola$TP_ESCOLA, "1", "N?o respondeu")
notasMediasTipoEscola$TP_ESCOLA <- str_replace(notasMediasTipoEscola$TP_ESCOLA, "2", "P?blica")
notasMediasTipoEscola$TP_ESCOLA <- str_replace(notasMediasTipoEscola$TP_ESCOLA, "3", "Privada")
notasMediasTipoEscola$TP_ESCOLA <- str_replace(notasMediasTipoEscola$TP_ESCOLA, "4", "Exterior")

ui <- dashboardPage(
  
  dashboardHeader(
    
    title = "ENEM Dashboard",
    titleWidth = 200
  ),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    tags$style(type="text/css", ".alinhamento {color: black;height:40px;display:flex;align-items: center;justify-content: center;}"),
    tags$style(type="text/css", ".cor {background-color: white;"),
    loadEChartsLibrary(),
    loadEChartsTheme('shine'),
    loadEChartsTheme('vintage'),
    loadEChartsTheme('dark-digerati'),
    loadEChartsTheme('roma'),
    loadEChartsTheme('infographic'),
    loadEChartsTheme('macarons'),
    loadEChartsTheme('caravan'),
    loadEChartsTheme('jazz'),
    loadEChartsTheme('london'),
    tabsetPanel(
      id = "tabs",
      tabPanel(
        title = "Participantes",
        value = "page1",
        fluidRow(
          valueBoxOutput("idadeMedia", width = 3),
          valueBoxOutput("braille", width = 3),
          valueBoxOutput("treineiro", width = 3),
          valueBoxOutput("canhoto", width = 3)
        ),
        fluidRow(
          column(6,
                 plotOutput("test_6")
          ),
          column(6,
                 plotOutput("test_15")    
          )
        ),
        fluidRow(
          column(6,
                 plotOutput("test_11")
          ),
          column(6,
                 plotOutput("test_16")
          )
        ),
        fluidRow(
          column(6,
                 tags$div(id="test_50", style="width:100%;height:300px;"), 
                 deliverChart(div_id = "test_50")
          ),
          column(6,
                 tags$div(id="test_51", style="width:100%;height:300px;"), 
                 deliverChart(div_id = "test_51")
          )
        )
      ),
      tabPanel(
        title = "Resultados",
        fluidRow(
          valueBoxOutput("presentesLC", width = 3),
          valueBoxOutput("presentesCH", width = 3),
          valueBoxOutput("presentesCN", width = 3),
          valueBoxOutput("presentesMT", width = 3)
        ),
        fluidRow(
          tags$h3(class = "alinhamento", "Compet?ncias dos alunos na reda??o do ENEM por tipo de escola")
        ),
        fluidRow(
          column(12,
                 tags$div(id="test_2", style="width:100%;height:300px;"),
                 deliverChart(div_id = "test_2")
          )
        ),
        fluidRow(class = "cor",
                 tags$h3(class = "alinhamento", "M?dia de notas dos alunos no ENEM por tipo de escola")
        ),
        fluidRow(class = "cor",
                 column(6,
                        plotOutput("test_62") 
                 ),
                 column(6,
                        plotOutput("test_63") 
                 )
        ),
        fluidRow(class = "cor",
                 column(6,
                        plotOutput("test_60") 
                 ),
                 column(6,
                        plotOutput("test_61") 
                 )
        ),
        fluidRow(class = "cor",
                 column(3,
                        fluidRow(
                          tags$h3(class = "alinhamento", "Presentes 1? Dia")
                        ),
                        tags$div(id="test_70", style="width:100%;height:300px;"),
                        deliverChart(div_id = "test_70")
                 ),
                 column(3,
                        fluidRow(
                          tags$h3(class = "alinhamento", "Presentes 2? Dia")
                        ),
                        tags$div(id="test_71", style="width:100%;height:300px;"),
                        deliverChart(div_id = "test_71")
                 ),
                 column(6,
                        fluidRow(
                          tags$h3(class = "alinhamento", "Histograma das notas de reda??o")
                        ),
                        plotOutput("test_75") 
                 )
        ),
        fluidRow(class = "cor",
                 column(9,
                        plotOutput("test_80")
                 ),
                 column(3,
                        tags$h4(class="alinhamento", "Legenda"),
                        tags$li("A - Nenhuma renda."),
                        tags$li("B - At? R$ 954,00."),
                        tags$li("C - De R$ 954,01 at? R$ 1.431,00."),
                        tags$li("D - De R$ 1.431,01 at? R$ 1.908,00."),
                        tags$li("E - De R$ 1.908,01 at? R$ 2.385,00."),
                        tags$li("F - De R$ 2.385,01 at? R$ 2.862,00."),
                        tags$li("G - De R$ 2.862,01 at? R$ 3.816,00."),
                        tags$li("H - De R$ 3.816,01 at? R$ 4.770,00."),
                        tags$li("I - De R$ 4.770,01 at? R$ 5.724,00."),
                        tags$li("J - De R$ 5.724,01 at? R$ 6.678,00."),
                        tags$li("K - De R$ 6.678,01 at? R$ 7.632,00."),
                        tags$li("L - De R$ 7.632,01 at? R$ 8.586,00."),
                        tags$li("M - De R$ 8.586,01 at? R$ 9.540,00."),
                        tags$li("N - De R$ 9.540,01 at? R$ 11.448,00."),
                        tags$li("O - De R$ 11.448,01 at? R$ 14.310,00."),
                        tags$li("P - De R$ 14.310,01 at? R$ 19.080,00."),
                        tags$li("Q - Mais de R$ 19.080,00.")
                 )
        )
      ),
      tabPanel(
        title = "Ranking de escolas",
        fluidRow(
          DT::dataTableOutput("tabela")
        )
      )
    )
  )
)

server <- function(input, output, session) {
  
  output$idadeMedia <- renderValueBox({
    valueBox(idadeMedia, "Idade média", icon = icon("users"), color="green")  
  })
  
  output$braille <- renderValueBox({
    valueBox(provaBraille, "Braille", icon = icon("pencil"), color="blue")  
  })
  
  output$treineiro <- renderValueBox({
    valueBox(treineiros, "Alunos treineiros", icon = icon("address-card"), color="yellow")  
  })
  
  output$canhoto <- renderValueBox({
    valueBox(canhoto, "Mesas canhotos", icon = icon("address-book"), color="red")  
  })
  
  output$presentesLC <- renderValueBox({
    valueBox(notaMediaLC, "Nota m?dia LC", icon = icon("pencil"), color="green")  
  })
  
  output$presentesCH <- renderValueBox({
    valueBox(notaMediaCH, "Nota m?dia CH", icon = icon("address-book"), color="blue")  
  })
  
  output$presentesCN <- renderValueBox({
    valueBox(notaMediaCN, "Nota m?dia CN", icon = icon("atom"), color="yellow")  
  })
  
  output$presentesMT <- renderValueBox({
    valueBox(notaMediaMT, "Nota m?dia MT", icon = icon("balance-scale"), color="red")  
  })
  
  output$test_15 <- renderPlot({
    ggplot(data = sexo, 
           aes(x = "", y = porcentagem, fill = TP_SEXO))+
      geom_bar(stat = "identity")+
      coord_polar("y", start = 200) +
      geom_text(aes(y = lab.pos, label = paste(porcentagem,"%", sep = "")), col = "white") +
      theme_minimal() + ggtitle( "Sexo dos participantes" ) +
      scale_fill_brewer(palette = "Paired")
  })
  
  output$test_6 <- renderPlot({ggplot(alunosEstado) +
      aes(x = SG_UF_RESIDENCIA, fill = SG_UF_RESIDENCIA, weight = quantAlunos) +
      geom_bar() +
      scale_fill_hue() +
      labs(x = "Estados", y = "Quantidade", title = "Quantidade de alunos por estado", fill = "Estados") +
      theme_minimal()})
  
  output$test_11 <- renderPlot({ ggplot(conclusaoEM) +
      aes(x = `c("J? conclu? o Ensino M?dio", "Estou cursando e concluirei o Ensino M?dio em 2015", `, fill = TP_ST_CONCLUSAO, weight = quant) +
      geom_bar() +
      scale_fill_gradient() +
      labs(x = "Situa??o", y = "Quantidade", title = "Conclus?o do EM", fill = "Legenda") +
      coord_flip() +
      theme_minimal() })
  
  output$test_16 <- renderPlot({
    ggplot(data = linguaEstrangeira, 
           aes(x = "", y = porcentagem, fill = TP_LINGUA))+
      geom_bar(stat = "identity")+
      coord_polar("y", start = 200) +
      geom_text(aes(y = lab.pos, label = paste(porcentagem,"%", sep = "")), col = "white") +
      theme_void() + ggtitle( "L?ngua Estrangeira" ) +
      scale_fill_brewer(palette = "Set1")
  })
  
  output$test_62 <- renderPlot({
    ggplot(notasMediasTipoEscola) +
      aes(x = TP_ESCOLA, fill = TP_ESCOLA, weight = mediaNotasLC) +
      geom_bar() +
      scale_fill_viridis_d(option = "cividis") +
      labs(x = "Tipo Escola", y = "M?dia Notas", title = "Linguagens, C?digos e suas Tecnologias", fill = "Legenda") +
      theme_minimal()
  })
  
  output$test_63 <- renderPlot({
    ggplot(notasMediasTipoEscola) +
      aes(x = TP_ESCOLA, fill = TP_ESCOLA, weight = mediaNotasCH) +
      geom_bar() +
      scale_fill_viridis_d(option = "cividis") +
      labs(x = "Tipo Escola", y = "M?dia Notas", title = "Ci?ncias Humanas e suas Tecnologias", fill = "Legenda") +
      theme_minimal() +
      ylim(0L, 650L)
  })
  
  output$test_60 <- renderPlot({
    ggplot(notasMediasTipoEscola) +
      aes(x = TP_ESCOLA, fill = TP_ESCOLA, weight = mediaNotasMT) +
      geom_bar() +
      scale_fill_viridis_d(option = "cividis") +
      labs(x = "Tipo Escola", y = "M?dia Notas", title = "Matem?tica e suas Tecnologias", fill = "Legenda") +
      theme_minimal()
  })
  
  output$test_61 <- renderPlot({
    ggplot(notasMediasTipoEscola) +
      aes(x = TP_ESCOLA, fill = TP_ESCOLA, weight = mediaNotasCN) +
      geom_bar() +
      scale_fill_viridis_d(option = "cividis") +
      labs(x = "Tipo Escola", y = "M?dia Notas", title = "Ci?ncias da Natureza e suas Tecnologias", fill = "Legenda") +
      theme_minimal()
  })
  
  output$test_75 <- renderPlot({
    ggplot(dados) +
      aes(x = NU_NOTA_REDACAO, colour = NU_NOTA_REDACAO) +
      geom_histogram(bins = 30L, fill = "#0c4c8a") +
      scale_color_gradient() +
      labs(x = "Nota reda??o", y = "Quantidade") +
      theme_minimal()
  })
  
  output$test_80 <- renderPlot({
    ggplot(resultado) +
      aes(x = Q006, fill = Q006, weight = quantidade) +
      geom_bar() +
      scale_fill_hue() +
      labs(x = "Grupo", y = "Quantidade", title = "Renda dos participantes do ENEM", fill = "Legenda") +
      theme_minimal()
  })
  
  renderPieChart(div_id = "test_50", data = nacionalidade, theme = "shine", radius = "75%", show.label = FALSE)
  
  renderPieChart(div_id = "test_51", data = localizacao, theme = "shine", radius = "75%")
  
  
  renderLineChart(div_id = "test_2", theme = "shine", data = competenciasRedacao)
  
  porcentagemDia1 <- round(quantPresentes1dia/(nrow(dados)) * 100,1)
  porcentagemDia2 <- round(quantPresentes2dia/(nrow(dados)) * 100,1)
  
  renderGauge(div_id = "test_70", gauge_name = "", rate = porcentagemDia1, theme = "default", animation = TRUE)
  
  renderGauge(div_id = "test_71", gauge_name = "", rate = porcentagemDia2, theme = "default", animation = TRUE, show.tools = TRUE)
  
  output$tabela <- DT::renderDataTable({
    DT::datatable(consulta, options = list(lengthMenu = c(5, 30, 50), pageLength = 15))
  })
}

shinyApp(ui, server)



esquisser()

