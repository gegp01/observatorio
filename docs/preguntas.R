path = "~/COVID19_C3/OBSERVATORIO DE VACUNAS/dev/version_2/varios_html/"

setwd(path)
P = read.csv("preguntas.csv", colClasses=c(rep("character",9)))
ask_resp = paste('<div><button class="collapsible_p"><h5 style="color:royalblue;">', P$pregunta, "</h5></button>"
                     ,'<div class="content_p indented" align="justify"><br><p style="color:black;">'
#                     , P$mensaje
#                     , '</p><p>'
                      , P$respuesta
                     , "</p></div></div>"
                     ,  sep="")
  
# f.pregunta = function(x){paste(ask_men_resp[x], sep="", collapse="\n")}
# dat1 = lapply(1:10, f.pregunta) 
# p <- paste(dat1, collapse='')
  
# Agrupar preguntas con base en las catgorías

nms = unique(P$Categoría)

f.categorica = function(x) {ask_resp[grep(nms[x], P$Categoría)]}
PC = lapply(1:length(nms), f.categorica)

# Preguntas codificadas (html) y separadas en Categorías

f.codeHTML = function(x){paste(PC[[x]], collapse='<br>')}

p = lapply(1:length(nms), f.codeHTML)

names(p) = nms

# p2 <- paste(ask_resp, collapse='<br>')
# ref = P$referencias
# keywords = P$palabras_clave

require(jsonlite)

# ESQUEMA
dat1= data.frame(preguntas = p[[1]])
P1 = toJSON(dat1, collapse = '', pretty=T)
write_json(P1, "P1.js")
system("sed -i '1s/^/ var preguntas_esquema =  /' P1.js")
system("sed -i '$s/$/ ; /' P1.js")

# EFECTOS ADVERSOS
dat2= data.frame(preguntas = p[[2]])
P2 = toJSON(dat2, collapse = '', pretty=T)
write_json(P2, "P2.js")
system("sed -i '1s/^/ var preguntas_adversos =  /' P2.js")
system("sed -i '$s/$/ ; /' P2.js")

# VACUNA COVID-19
dat3= data.frame(preguntas = p[[3]])
P3 = toJSON(dat3, collapse = '', pretty=T)
write_json(P3, "P3.js")
system("sed -i '1s/^/ var preguntas_vacuna =  /' P3.js")
system("sed -i '$s/$/ ; /' P3.js")

# ESTRATEGIA
dat4= data.frame(preguntas = p[[4]])
P4 = toJSON(dat4, collapse = '', pretty=T)
write_json(P4, "P4.js")
system("sed -i '1s/^/ var preguntas_estrategia =  /' P4.js")
system("sed -i '$s/$/ ; /' P4.js")

# TIPOS DE VACUNAS
dat5= data.frame(preguntas = p[[5]])
P5 = toJSON(dat5, collapse = '', pretty=T)
write_json(P5, "P5.js")
system("sed -i '1s/^/ var preguntas_tipos =  /' P5.js")
system("sed -i '$s/$/ ; /' P5.js")

# EFECTIVIDAD
dat6= data.frame(preguntas = p[[6]])
P6 = toJSON(dat6, collapse = '', pretty=T)
write_json(P6, "P6.js")
system("sed -i '1s/^/ var preguntas_efectividad =  /' P6.js")
system("sed -i '$s/$/ ; /' P6.js")

