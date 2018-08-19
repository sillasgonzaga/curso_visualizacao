# 
# 1) Importe o arquivo salvo `herois_completo.csv` no primeiro módulo. Salve no objeto `herois`.
# . Filtre os herois que possuem peso e altura maior que 0.
herois <- read_csv("herois_completo.csv") %>% 
  filter(height > 0, weight > 0)

# 2) Crie um histograma da variável altura.
ggplot(herois, aes(x = height)) +
  geom_histogram()

# 
# 3) Analise a distribuição da variável peso em função da editora dos heróis. 
ggplot(herois, aes(x = publisher, y = weight)) + 
  geom_boxplot()


# 
# 4) Crie um gŕafico de barras mostrando a quantidade de heróis por editora.
# Ordene as barras em ordem descrescente.
# Acrescente uma camada de texto nas barras mostrando a quantidade exata.
herois %>% 
  count(publisher) %>% 
  ggplot(aes(x = reorder(publisher, -n), y = n))+ 
  geom_col() + 
  geom_label(aes(label = n))

# 5) Crie um gráfico de barras mostrando a quantidade de herois bons ou maus 
# (variável `alignment`) por editora.
# Use tanto `geom_bar()` como `geom_col()` para isso, usando o argumento
# `position = position_dodge()` para separar as barras nas editoras.

# alternativa geom_bar
ggplot(herois, aes(x = publisher, fill = alignment)) +
  geom_bar(position = position_dodge())

# alternativa geom_col
herois %>% 
  count(publisher, alignment) %>% 
  ggplot(aes(x = publisher, y = n, fill = alignment)) +
  geom_col(position = position_dodge())

# 6) Repita o item anterior, trocando apenas o parâmeto 
# `position = position_dodge()` para `position = position_fill()` para observar
# a proporção de personagens bons, maus ou neutros em cada editora.
herois %>% 
  count(publisher, alignment) %>% 
  ggplot(aes(x = publisher, y = n, fill = alignment)) +
  geom_col(position = position_fill())

# 7) Use o dplyr e o tidyr para criar um dataset chamado `hero_agg`,
# que contem a quantidade de poderes agregado por editora e heroi.
# Dica: transforme as colunas de super-poderes em numéricas,
# converta o dataframe para formato tidy, agrupe os dados por editora e heroi
# e calcule a soma da coluna transformada de poderes.
hero_agg <- herois %>% 
  mutate_at(vars(agility:omniscient), as.numeric) %>% 
  gather(super_poder, possui, agility:omniscient) %>% 
  group_by(publisher, name) %>% 
  summarise(qtd_poderes = sum(possui))

hero_agg  

# 8) Faça um gráfico de barras mostrando os 10 herois de cada editora que possuem
# mais poderes. Dica: use facets para separa os herois de cada editora.
hero_agg %>% 
  group_by(publisher) %>% 
  top_n(10, qtd_poderes) %>% 
  ggplot(aes(x = name, y = qtd_poderes)) +
  geom_col() +
  coord_flip() +
  facet_wrap(~ publisher, drop = TRUE, scales = "free_y")

# 
# 9) Faça um gráfico de densidade da distribuição da quantidade de poderes 
# dos herois por editora.
ggplot(hero_agg, aes(x = qtd_poderes, fill = publisher)) +
  geom_density(alpha = 0.3)

# 
# 10) Para praticar com gráficos de séries temporais, usaremos outro dataset.
# Importe o dataset `economics` usando a função `data()`. 
# Observe os dados com a função `head()`.
# Qual a periodicidade temporal dos dados (ex.: diário, semanal, mensal, anual) ?
data(economics)
head(economics)

 
# 11) Faça um gráfico da variável `unemploy` ao longo do tempo.
# Salve esse gráfico no objeto p, que será usado nos próximos itens.
p <- ggplot(economics, aes(x = date, y = unemploy)) +
  geom_line()

p

# 12) Acrescente uma camada de área sombreada destacando o período entre
# 2001 a 2005.

p +
  geom_rect(
    xmin = as.Date("2001-01-01"),
    xmax = as.Date("2005-12-31"),
    ymin = -Inf,
    ymax = Inf,
    alpha = 0.01
  )
 
# 13) Acrescente algum comentário seu no gráfico usando a função `geom_text()`.
p + 
  geom_text(
    x = as.Date("1975-01-01"),
    y = 13000,
    label = "O indicador aparenta ser cíclico"
  )

# 
# 14) Transforme o dataframe `economics` para o formato tidy. 
# Faça um gráfico de linha de todos os indicadores econômicos ao longo do tempo,
# mapeando a *aesthetic* color à variável do nome do indicador. 
# Note os problemas de escala do gráfico.
economics_tidy <- economics %>% 
  gather(indicador, valor, -date)

economics_tidy %>% 
  ggplot(aes(x = date, y = valor, color = indicador)) +
  geom_line()

# 
# 15) Repita o item anterior, acrescentando uma camada de facets que separe
# os gráficos por indicador. Defina o parâmetro `scales` para ter escala livre
# no eixo y.

economics_tidy %>% 
  ggplot(aes(x = date, y = valor, color = indicador)) +
  geom_line() +
  facet_wrap(~ indicador, scales = "free_y")
