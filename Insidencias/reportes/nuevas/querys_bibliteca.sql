select distinct count(*) as repetido,codigo from fox..sd_autores_tesis_actuales
where codigo is not null
group by codigo

-- autores que no figuran en la tabla general de autores
select * from fox..sd_tesis_finales
where codigo_autor not in ( select distinct codigo from fox..sd_autores_tesis_actuales
)

-- autores que figuran sin datos de tesis
select * from fox..sd_autores_tesis_actuales
where codigo not in ( select distinct codigo_autor from fox..sd_tesis_finales
)