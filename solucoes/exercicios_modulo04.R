# Carregue os pacotes usados neste material
library(tidyverse)
library(plotly)
library(sf)
library(brmap)

# 
# ) Carregue o dataset `series_ipca_selic.rds`.
df_series <- read_rds("series_ipca_selic.rds")

# ) Faça um gráfico simples de linha dos indicadores, mapeando a coluna de 
# indicador na *aesthetic* cor. Salve o gráfico no objeto `p2`.
p2 <- df_series %>% 
  filter(date >= as.Date("2000-01-01")) %>% 
  ggplot(aes(x = date, y = valor, color = indicador)) +
  geom_line()
p2
# 
# ) Transforme o gráfico para interativo usando a função `ggplotly`. 
# Brinque com o gráfico: dê zoom em períodos específicos, passe o mouse nas linhas,
# etc. Confira como ficou a tooltip.
ggplotly(p2)

# 
# ) Volte ao gráfico original e defina uma *aesthetic* `text` de forma que 
# mostre a data em um formato *mm/aaaa*, o nome do indicador e seu valor.
p2 <- df_series %>% 
  filter(date >= as.Date("2000-01-01")) %>% 
  ggplot(aes(x = date,
             y = valor,
             color = indicador,
             group = 1,
             text = paste("Data: ", format(date, "%m/%y"), "\n",
                          "Indicador: ", indicador, "\n",
                           "Valor: ", valor))) +
  geom_line()

p2
# ) Salve o gráfico finalizado em um arquivo local com a extensão html.
ggplotly(p2, tooltip = "text")


# ) Execute o código abaixo para baixar o conjunto de dados da quantidade de 
# servidores civis e total remunerado para os mesmos por estado (dados de Junho/2018):  
  
# https://github.com/sillasgonzaga/postsibpad/blob/master/data/servidores_agregados_por_uf.csv
df_servidores <- read.csv2("https://raw.githubusercontent.com/sillasgonzaga/postsibpad/master/data/servidores_agregados_por_uf.csv")

#) Crie um novo dataframe chamado `df_servidores_estado`, que corresponde à
# junção do dataframe `brmap_estado`, do pacote `brmap`, com `df_servidores`.
df_servidores_estado <- left_join(brmap_estado,
                                  df_servidores,
                                  by = c("estado_sigla" = "uf_exercicio"))

# ) Crie dois mapas: um com os estados coloridos pela quantidade de servidores 
# e outro pelo log da remuneração bruta.

ggplot(df_servidores_estado) +
  geom_sf(aes(geometry = geometry,
              fill = log(qtd_servidores)))


ggplot(df_servidores_estado) +
  geom_sf(aes(geometry = geometry,
              fill = log(soma_salarios)))
