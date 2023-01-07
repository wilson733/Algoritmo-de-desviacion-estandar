library(ggplot2)
library(sf)
library(tidyverse)
library(dplyr)

archivo <-  choose.files(caption = "Seleccione archivo a estandatizar (shp, gpkg)",
                         multi = FALSE)
file_name <- paste0(tools::file_path_sans_ext(archivo),
                    '_AMBIENTADO_POR_RTO.',
                    tools::file_ext(archivo))

datos <- st_read(archivo)

soloDatos <- st_drop_geometry(datos)

datos_normalizados <- data.frame(sapply(soloDatos, scale))

media_por_fila<- rowMeans(datos_normalizados)

sd<- apply(datos_normalizados, 1, sd)

df1<- cbind(datos_normalizados, media_por_fila, sd)

df2<-mutate(df1, ZM2 = ifelse(sd < 0.8 & media_por_fila >= 0.2, 3,
                              ifelse(sd < 0.8 & media_por_fila < 0.2, 2,1 )))


st_geometry(df2) <- st_geometry(datos)

st_write(df2,
         file_name)
