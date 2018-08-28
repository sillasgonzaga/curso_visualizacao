target <- "/home/sillas/R/Projetos/paixaopordados-blogdown/public/material/curso_visualizacao/"
origin <- "_book/*"

# deletar conteudo antigo na pasta do blog
system(str_glue("rm -r {target}/*"))
# copiar conteudo
system(str_glue("cp {origin} {target}"))


