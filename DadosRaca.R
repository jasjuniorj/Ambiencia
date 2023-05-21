#### Composição Racial das Escolas no Brasil ####

## Pacotes - Verifique se todos estaão instalados - Caso não: install.packages("nomedopacote") 

library(readxl)
library(readr)
library(dplyr)
library(tidyverse)
library(ggpubr)
library(viridis)
library(hrbrthemes)
library(forcats)
library(psych)
library(stringi)
library(openxlsx)

# Etapa 1: Consturção das Bases

### Composição racial da escola -  Alunos - 2022 ####


Dadosraca <- read_delim("Dadosraca2.csv", 
                        delim = ";", escape_double = FALSE, trim_ws = TRUE)

qtprof2018 <- read_csv("qtprof2018.csv") # Úlitmo ano com a variável total de profissionais

# Junçõ das base de raça com a do total de profissionais por escola

Dadosraca <- Dadosraca %>% 
  mutate(id_escola = CO_ENTIDADE) %>% 
  left_join(qtprof2018, by = "id_escola" ) %>% 
  rename(qt_fun18 = quantidade_funcionario)


## Código para retirada do codigo 88888 # Não dado para o Inep


Dadosraca <- mutate(Dadosraca, QT_PROF_ADMINISTRATIVOS = as.numeric(ifelse(QT_PROF_ADMINISTRATIVOS<88888, QT_PROF_ADMINISTRATIVOS,
                                                                           ' ') ),
                    QT_PROF_ASSIST_SOCIAL = as.numeric(ifelse(QT_PROF_ASSIST_SOCIAL<88888, QT_PROF_ASSIST_SOCIAL,
                                                              ' ') ),
                    QT_PROF_BIBLIOTECARIO = as.numeric(ifelse(QT_PROF_BIBLIOTECARIO<88888, QT_PROF_BIBLIOTECARIO,
                                                              ' ') ),
                    QT_PROF_COORDENADOR = as.numeric(ifelse( QT_PROF_COORDENADOR<88888,  QT_PROF_COORDENADOR,
                                                             ' ') ),
                    QT_PROF_FONAUDIOLOGO = as.numeric(ifelse( QT_PROF_FONAUDIOLOGO<88888,  QT_PROF_FONAUDIOLOGO,
                                                              ' ') ),
                    QT_PROF_NUTRICIONISTA = as.numeric(ifelse(QT_PROF_NUTRICIONISTA<88888, QT_PROF_NUTRICIONISTA,
                                                              ' ') ),
                    QT_PROF_SAUDE = as.numeric(ifelse(QT_PROF_SAUDE<88888, QT_PROF_SAUDE,
                                                      ' ') ),
                    QT_PROF_GESTAO = as.numeric(ifelse(QT_PROF_GESTAO<88888, QT_PROF_GESTAO,
                                                       ' ') ),
                    QT_PROF_SERVICOS_GERAIS = as.numeric(ifelse(QT_PROF_SERVICOS_GERAIS<88888, QT_PROF_SERVICOS_GERAIS,
                                                                ' ') ),
                    QT_PROF_MONITORES = as.numeric(ifelse(QT_PROF_MONITORES<88888, QT_PROF_MONITORES,
                                                          ' ') ),
                    QT_PROF_PEDAGOGIA = as.numeric(ifelse(QT_PROF_PEDAGOGIA<88888, QT_PROF_PEDAGOGIA,
                                                          ' ') ),
                    QT_PROF_SEGURANCA = as.numeric(ifelse( QT_PROF_SEGURANCA<88888,  QT_PROF_SEGURANCA,
                                                           ' ') ),
                    QT_PROF_PSICOLOGO = as.numeric(ifelse( QT_PROF_PSICOLOGO<88888,  QT_PROF_PSICOLOGO,
                                                           ' ') ),
                    QT_PROF_SECRETARIO = as.numeric(ifelse( QT_PROF_SECRETARIO<88888,  QT_PROF_SECRETARIO,
                                                            ' ') ),
                    QT_PROF_ALIMENTACAO = as.numeric(ifelse( QT_PROF_ALIMENTACAO<88888,  QT_PROF_ALIMENTACAO,
                                                             ' ') )
)

## Calculando o percentual de matriculas por raça na educação básica 


escolas <- Dadosraca %>% 
  group_by(CO_ENTIDADE) %>%
  summarise(NBranco = sum(QT_MAT_BAS_PRETA, QT_MAT_BAS_PARDA),
            Branco = QT_MAT_BAS_BRANCA,
            Pretos = QT_MAT_BAS_PRETA,
            Brancoper = sum(round((QT_MAT_BAS_BRANCA/QT_MAT_BAS)*100,2)),
            NBrancoper = sum(round((NBranco/QT_MAT_BAS)*100,2)),
            Pretoper = sum(round((QT_MAT_BAS_PRETA/QT_MAT_BAS)*100,2))) %>% 
  rename(id_escola = CO_ENTIDADE)


## Calculando o total de professores com base na quantidade de funionários em 18
## seleção de todas as variáveis que entram no calculo de ambiência que estão nessa base.

escolas <- Dadosraca %>% 
  mutate(NPROF =  qt_fun18 - (QT_PROF_ADMINISTRATIVOS + QT_PROF_ALIMENTACAO+
                                QT_PROF_ASSIST_SOCIAL+ QT_PROF_BIBLIOTECARIO+
                                QT_PROF_COORDENADOR+ QT_PROF_FONAUDIOLOGO+ QT_PROF_NUTRICIONISTA+ QT_PROF_SAUDE+
                                QT_PROF_GESTAO+ QT_PROF_SERVICOS_GERAIS+ QT_PROF_MONITORES+QT_PROF_PEDAGOGIA+
                                QT_PROF_SEGURANCA+QT_PROF_PSICOLOGO+ QT_PROF_SECRETARIO)) %>% 
  select(NO_MESORREGIAO,NO_REGIAO,SG_UF, CO_UF,CO_MUNICIPIO, NO_MUNICIPIO, 
         CO_DISTRITO,NO_ENTIDADE, TP_LOCALIZACAO_DIFERENCIADA,id_escola, qt_fun18,
         CO_CEP, IN_MATERIAL_PED_INDIGENA, IN_MATERIAL_PED_ETNICO, IN_MATERIAL_ESP_QUILOMBOLA,
         IN_MATERIAL_ESP_INDIGENA, IN_MEDIACAO_SEMIPRESENCIAL, IN_BAS, IN_INF, QT_MAT_BAS_FEM,
         QT_MAT_BAS_MASC, QT_MAT_BAS_ND, QT_MAT_BAS_PRETA, QT_MAT_BAS_PARDA, 
         QT_MAT_BAS_BRANCA, QT_MAT_BAS, NPROF) %>%
  inner_join(escolas, by = "id_escola")

### Composição racial das escolas - Professores - 2020 ####

docentesAC <- read_csv("docentesAC.csv")
docentesAL <- read_csv("docentesAL.csv")
docentesAM <- read_csv("docentesAM.csv")
docentesAP <- read_csv("docentesAP.csv")
docentesBA <- read_csv("docentesBA.csv")
docentesCE <- read_csv("docentesCE.csv")
docentesDF <- read_csv("docentesDF.csv")
docentesES <- read_csv("docentesES.csv")
docentesGO <- read_csv("docentesGO.csv")
docentesMA <- read_csv("docentesMA.csv")
docentesMG <- read_csv("docentesMG.csv")
docentesMS <- read_csv("docentesMS.csv")
docentesMT <- read_csv("docentesMT.csv")
docentesPA <- read_csv("docentesPA.csv")
docentesPB <- read_csv("docentesPB.csv")
docentesPE <- read_csv("docentesPE.csv")
docentesPI <- read_csv("docentesPI.csv")
docentesPR <- read_csv("docentesPR.csv")
docentesRJ <- read_csv("docentesRJ.csv")
docentesRN <- read_csv("docentesRN.csv")
docentesRO <- read_csv("docentesRO.csv")
docentesRR <- read_csv("docentesRR.csv")
docentesRS <- read_csv("docentesRS.csv")
docentesSC <- read_csv("docentesSC.csv")
docentesSE <- read_csv("docentesSE.csv")
docentesSP <- read_csv("docentesSP.csv")
docentesTO <- read_csv("docentesTO.csv")


## Estratégia para facilitar o processamento - divsão a base de mais 10 milhões de casos

docentesa <- bind_rows(docentesAC, docentesAL, docentesAM, docentesAP, docentesCE, docentesDF,
                       docentesES, docentesGO, docentesMA, docentesMG) 
docentesb<- bind_rows( docentesMS, docentesMT,docentesBA, # !Bahia inclusa nesse código
                       docentesPA, docentesPB, docentesPE, docentesPI, docentesPR, docentesRJ)
docentesc <- bind_rows(docentesRN, docentesRO, docentesRR, docentesRS, docentesSC, docentesSE,
                       docentesSP, docentesTO)


## Recodificação da raça e preparação para computar o total de professores de cada raça

docentec <- docentesc %>%  # alterar docentex a / b / c
  mutate(totaldoc = 1,
         raca = case_when(
           (raca_cor == 0) ~"Não Declarada",
           (raca_cor == 1) ~"Branca",
           (raca_cor == 2) ~"Preta",
           (raca_cor == 3) ~"Parda",
           (raca_cor == 4) ~"Amarela",
           (raca_cor == 5) ~"Indígena",
         )) %>% spread(key = raca, value = raca) %>%  
  mutate(`Não Declarada` = case_when(
    (`Não Declarada`=="Não Declarada") ~ 1),
    Branca = case_when(
      (Branca == "Branca") ~ 1),  
    Preta = case_when(
      (Preta == "Preta") ~ 1),
    Parda = case_when(
      (Parda == "Parda") ~ 1),
    Amarela = case_when(
      (Amarela == "Amarela") ~ 1),
    Indígena = case_when(
      (Indígena == "Indígena") ~ 1))

## Agregando por rede e por escola e calculando o percentual de professores (Doc) por raça e
## percentual de professores com formações específicas (Afro-brasileiros e Direitos Humanos)

docentescoc <- docentec %>% #alterar o docentex - a / b / c
  group_by(rede,id_escola) %>%
  summarise(NDelcarada = sum(`Não Declarada`, na.rm = TRUE),
            total = sum(totaldoc),
            Brancos = sum(Branca, na.rm = TRUE),
            Pretos = sum(Preta, na.rm = TRUE),
            Pardos = sum(Parda, na.rm = TRUE),
            Amarelos = sum(Amarela, na.rm = TRUE),
            Indígena = sum(Indígena, na.rm = TRUE),
            NBrancos = sum(Preta,
                           Parda,Amarela,Indígena, na.rm = TRUE),
            totalraca = sum(`Não Declarada`, Branca, Preta,
                            Parda,Amarela,Indígena, na.rm = TRUE),
            totaldecl = sum(Branca, Preta,
                            Parda,Amarela,Indígena, na.rm = TRUE),
            formAfro = sum(formacao_especif_afro, na.rm = TRUE),
            #formAfroNA = sum(is.na(formacao_especif_afro)), todos tinham preenchido
            formDH = sum(formacao_especif_dir_humanos, na.rm = TRUE)) %>% 
  #formDHNA = sum(is.na(formacao_especif    _dir_humanos))) %>%, todos tinham preenchido
  mutate(NBperDoc = round((NBrancos/total)*100,2),
         PretoperDoc = round((Pretos/total)*100,2),
         BrancoPerDoc = round((Brancos/total)*100,2),
         NDelcaradaperc =round((NDelcarada/total)*100,2 ),
         formAfroperc = round((formAfro/total)*100,2 ),
         formDHperc = round((formDH/total)*100,2 )) %>% 
  rename(CodEsc = id_escola)


escolasdocent <- bind_rows(docentescoa, docentescob, docentescoc) # reunião das três bases a , b e c

## Juntando as bases escolas (dados alunos) e escolasdocent (dados professores)

escolas <- rename(escolas, CodEsc = id_escola)

base <- left_join(escolas, escolasdocent, by = "CodEsc")

## População por Raça - Cálculo da diferença na composição racial 

popraca <- read_excel("popraca.xlsx")

base <- popraca %>% 
  rename(CO_MUNICIPIO = `Código IBGE`) %>% 
  inner_join(base, by = c("CO_MUNICIPIO", "SG_UF"))

## Calculando a diferenças de composição racial - escola população

base <- base %>% 
  mutate(DifCompAluno = NBrancoper - NBrancopopper,
         DifCompDoc =  NBperDoc - NBrancopopper)

## Desigualdade de desempenho entre alunos - IDEA 

IDeA <- read_excel("IDeA.xlsx")


IDeA <- IDeA %>% 
  rename(CO_MUNICIPIO = Código, SG_UF = UF, 
         NivPort = `Nível de Aprendizagem (Português | 5º ano | 2017)`,
         NivMat = `Nível de Aprendizagem (Matemática | 5º ano | 2017)`,
         DesPort = `Nível de Desigualdade por Raça (Português | 5º ano | 2017)`,
         DesMat = `Nível de Desigualdade por Raça (Matemática | 5º ano | 2017)`) %>% 
  select(CO_MUNICIPIO, DesMat, DesPort)


base <- inner_join(base, IDeA, by = "CO_MUNICIPIO")

### Análise Fatorial - Inidicador de Ambiência Racial (IAR) ####

## Primeiro passo análise por quantis das variáveis total de professores e Alunos 

quantile(base$total,probs = seq(0,1, by=0.1), na.rm = TRUE) # professores
quantile(base$QT_MAT_BAS, probs = seq(0,1, by=0.1), na.rm = TRUE)#alunos


baseaf <- base %>%
  mutate(material = IN_MATERIAL_PED_ETNICO+IN_MATERIAL_PED_INDIGENA,
         rede2 = case_when(
           (rede == "federal")|(rede == "estadual")|(rede == "municipal") ~ "pública",
           (rede == "privada") ~ "privada" )) %>% 
  filter(total >= 6, QT_MAT_BAS >= 52,) %>%  #rede2 == "privada") %>% 
  select(CodEsc,CO_MUNICIPIO, rede2,formDHperc, formAfroperc, DifCompAluno, DifCompDoc, material, DesMat, DesPort ) #fizemos a inclusão das duas últimas


baseaf <- na.omit(baseaf)

## Procedimentos da AF 

# 1) Teste de adequação da amostra

bartlett.test(baseaf[,c(4:9)])
KMO(baseaf[,c(4:9)])

### Ajuste - Extração de componentes 

afcp <- princomp(baseaf[,c(4:9)], scores = T);afcp
summary(afcp)

### Cargas fatorais

cp<- principal(baseaf[,c(4:9)], nfactors = 2, rotate = "varimax", scores = T); cp


## verifcação dos scores e junção da bases

head(cp$scores)
summary(cp$scores)

fatores <- as.data.frame(cp$scores)

baseaf<- cbind(baseaf, fatores)

baseafx <- inner_join(baseaf, base[,c(16,17,18,19,20)], by="CodEsc")

baseamb <- rename(baseaf, Demo = RC1, Form = RC2) %>% 
  mutate(Formação = (Form - min(Form))/(max(Form)-min(Form)),
         Demodidática = (Demo - min(Demo))/(max(Demo)-min(Demo)) ) %>% 
  left_join(base[,c(1,5,25,27)], by = "CodEsc") %>% 
  mutate(CO_CEP = as.numeric(CO_CEP)) 

## Junção dos Bairros
## Após procedimento de extração via url - requests python - Ver no script antigo 

Cep <- read_excel("Cep.xlsx")

baseamb <- Cep %>% 
  filter(bairro == "neighborhood") %>% 
  rename(CO_CEP = Cep) %>% 
  right_join(baseamb, by="CO_CEP") %>% 
  select(-bairro) %>% rename(Bairro = Nome)


## Bases Finais - Municípios 

## Retirar acentos da variável - Municipio

baseamb <- baseamb %>% 
  mutate(MunicNome = tolower(stri_trans_general(Município, "Latin-ASCII")))

## Base por Município

baseambM <- baseamb %>% 
  group_by(SG_UF, CO_MUNICIPIO, Município, MunicNome, rede2) %>% 
  summarise(Demomean = round(mean(Demodidática*100),2), Demosd = round(sd(Demodidática*100),2), 
            Formmean = round(mean(Formação*100),2),
            Formsd = round(sd(Formação*100),2)) %>% 
  mutate(Democv = round((Demosd/Demomean)*100,2), Formcv = round((Formsd/Formmean)*100,2)) 

write.xlsx(baseambM, "baseambM.xlsx")


