# 0) Importe o pacote `tidyverse`
library(tidyverse)
# 1) Importe o arquivo salvo `herois_completo.csv` no módulo anterior.
herois <- read_csv("herois_completo.csv")
# 2) Faça um gráfico de pontos da coluna `weight` em função de `height`.
ggplot(herois, aes(x = height, y = weight)) +
  geom_point()

# 3) Observe os outliers no gráfico. Crie um novo dataframe sem esses pontos.
# Isto é, crie um novo dataframe chamado `herois_limpo`, filtrando os heróis com peso
# e altura entre 1 a 500. Use este dataframe para todos os próximos items.
herois_limpo <- herois %>% 
  filter(between(weight, 1, 500) & between(height, 1, 500))

# 3) Refaça o item 2, atribuindo a cor verde para os pontos.
ggplot(herois_limpo, aes(x = height, y = weight)) +
  geom_point(color = "green")

# 4) Refaça o item 2, mapeando a cor dos pontos à variável `publisher`.  
ggplot(herois_limpo, aes(x = height, y = weight)) +
  geom_point(aes(color = publisher))

# 5) Refaça o item 2, mapeando a cor dos pontos à variável `gender`
ggplot(herois_limpo, aes(x = height, y = weight)) +
  geom_point(aes(color = gender))

# 6) Refaça o item 2, mapeando a cor dos pontos à variável `gender` e o formato (shape)
# dos pontos à variável `flight`  
ggplot(herois_limpo, aes(x = height, y = weight)) +
  geom_point(aes(color = gender, shape = flight))


# 7) Refaça o item 2, mapeando a cor dos pontos à variável `gender`, o formato (shape)
# dos pontos à variável `flight` e separando o gráfico em subgráficos (facets) 
# usando a variável `publisher`.
ggplot(herois_limpo, aes(x = height, y = weight)) +
  geom_point(aes(color = gender, shape = flight)) + 
  facet_wrap(~ publisher)

# 8) Refaça o item 2, mapeando a cor dos pontos à variável `flight` e separando
# o gráfico em subgráficos (facets) usando as variáveis `publisher` e `gender`.
ggplot(herois_limpo, aes(x = height, y = weight)) +
  geom_point(aes(color = flight)) + 
  facet_grid(gender ~ publisher)

