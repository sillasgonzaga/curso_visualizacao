library(rmarkdown)
library(gapminder)
data(gapminder)


vetor_continentes <- sort(as.character(unique(gapminder$continent)))
vetor_continentes <- vetor_continentes[-5]

for (continente_loop in vetor_continentes){
  
  rmarkdown::render("solucoes/exercicios_modulo05_relatorio_onu.Rmd",
                    output_format = "html_document",
                    output_file = paste0(continente_loop, ".html"),
                    params = list(
                      continente_relatorio = continente_loop
                    ))
  
}