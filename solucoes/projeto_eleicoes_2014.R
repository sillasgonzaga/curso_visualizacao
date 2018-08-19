
# https://cuidando.vc/

orcamento_sp <- read_csv("http://devcolab.each.usp.br/dadosorcamentarios/2017.csv")

glimpse(orcamento_sp)

orcamento_sp <- orcamento_sp %>% 
  filter(!(is.na(latitude) & is.na(longitude)))

ggplot(orcamento_sp, aes(x = longitude, y = latitude)) +
  geom_point(aes(color = pa))

quantile(orcamento_sp$vl_empenhadoliquido)

orcamento_sp %>% 
  select_if(is.character) %>% 
  map_dbl(~ length(unique(.))) %>% 
  sort()


# table(orcamento_sp$ds_categoria)
# table(orcamento_sp$pa)
