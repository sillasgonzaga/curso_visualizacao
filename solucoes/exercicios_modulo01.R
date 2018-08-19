# 0) Carregue os pacotes `tidyverse` e `janitor`.
library(tidyverse)
library(janitor)

# 1) Baixe o dataset de Super Heróis do Kaggle. Descompacte o arquivo e importe
# os dois arquivos para o R: salve o arquivo `super_hero_powers.csv` no objeto 
# `hero_powers` e o arquivo `heroes_information.csv` no objeto `hero_info`. 
#Use também na função `read_csv` o argumento `na = c("", "-", "NA"))` para que linhas 
# com traço ou vazias sejam convertidas para **NA**. Observe as colunas presentes 
# nos datasets usando a função `glimpse`.

hero_powers <- read_csv("super_hero_powers.csv", na = c("", "-"))
hero_info <- read_csv("heroes_information.csv", na = c("", "-"))

glimpse(hero_powers)
glimpse(hero_info)

# 2) Use a função `janitor::clean_names()` para limpar os nomes das colunas.  
hero_info <- clean_names(hero_info)
hero_powers <- clean_names(hero_powers)

# 3) No caso de `hero_info`, remova a primeira coluna.  
hero_info[, 1] <- NULL

# 4) Em `hero_powers`, converta todas as colunas com exceção da primeira para o tipo
# `logical`.
hero_powers <- hero_powers %>% 
  mutate_at((vars(-1)), as.logical)

# ) Em `hero_info`, na coluna `publisher`, observe quantas editoras diferentes
# existem no dataset. Substitua *Marvel Comics* por *Marvel*, *DC Comics* por *DC* e
# todas as outras editoras pelo termo "Outros".
unique(hero_info$publisher)
length(unique(hero_info$publisher))

hero_info <- hero_info %>% 
  mutate(publisher = case_when(
    publisher == "Marvel Comics" ~ "Marvel",
    publisher == "DC Comics" ~ "DC",
    TRUE ~ "Outros"
  ))

# 7) Em `hero_info`, quais raças (coluna `race`) são exclusivas de cada editora? 
raca_por_editora <- hero_info %>% 
  count(publisher, race) %>% 
  spread(publisher, n)

# exclusivas da Marvel
raca_por_editora %>% 
  filter(!is.na(Marvel) & is.na(DC) & is.na(Outros))

# solução não tidy, usando sintaxe do base R
racas_marvel <- unique(hero_info$race[hero_info$publisher == "Marvel"])
racas_dc <- unique(hero_info$race[hero_info$publisher == "DC"])
racas_outros <- unique(hero_info$race[hero_info$publisher == "Outros"])

# raças exclusivas da marvel
setdiff(racas_marvel, c(racas_dc, racas_outros))

# 8) Em `hero_info`, quais cores de olhos (coluna `eye_color`) são mais comuns para 
# cada sexo (coluna `gender`)?  Filtre o top 3 para cada sexo.
hero_info %>% 
  group_by(gender, eye_color) %>% 
  summarise(n = n()) %>% 
  top_n(3, n)

# 9) Em `hero_powers`, calcule o percentual de heróis que possui cada habilidade
# descrita nas colunas (Dica: é possível calcular a soma ou percentual de um vetor
# lógico, pois `TRUE` equivale a 1 e `FALSE` a 0)
hero_powers
# para apenas uma coluna (a segunda, agility)
hero_powers %>% 
  summarise(pct_herois = mean(agility))

# para todas as colunas que sao do tipo logical
hero_powers %>% 
  summarise_if(is.logical, mean) 

# 9) Repita o item anterior, usando uma abordagem mais *tidy*: converta o formato
# do dataframe `hero_powers` para o formato long. Ele passará a possuir apenas
# 3 colunas: `hero_names`, `poder` e `possui_poder` usando a função `tidyr::gather()`.
# Então, calcule a média da coluna `possui_poder` agrupado pela coluna `poder`.
hero_powers %>% 
  gather(poder, possui_poder, -hero_names) %>% 
  group_by(poder) %>% 
  summarise(pct = mean(possui_poder))


# 10) Junte os dois dataframes em um só, chamado `hero`. 
# A função a ser usada é `inner_join()`. Pense bem em qual será a ordem dos dataframes
# nos argumentos da função e qual será a chave usada no argumento `by` para unir 
# as duas tabelas.
hero <- inner_join(hero_info, hero_powers,
                   by = c("name" = "hero_names"))


# 11) No dataframe `hero`, calcule o percentual de herois de cada editora que são 
# telepatas.
hero %>% 
  group_by(publisher) %>% 
  summarise(pct_telepatas = mean(telepathy))

# 12) No dataframe `hero`, selecione as colunas `name`, `publisher`, `flight`
# e `weight`, filtre os heróis que podem voar e retorne os 10 de maior peso.
hero %>% 
  select(name, publisher, flight, weight) %>% 
  filter(flight) %>% 
  arrange(desc(weight)) %>% 
  head(10)

# 13) Salve o dataframe chamado `hero` no arquivo `herois_completo.csv` usando a
# função `readr::write_csv()`.

write_csv(hero, "herois_completo.csv", na = "NA")
