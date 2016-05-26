select count(*) as cantidad,protic.trunc(max(fecha)) as fecha_ingreso,tipo_usuario 
    from (
    select convert(datetime,protic.trunc(lusu_flogeo),103) as fecha,isnull(lusu_tusuario,'F') as tipo_usuario 
    from login_usuarios where lusu_flogeo>='01/09/2008'
    )as tabla
group by   fecha, tipo_usuario 
order by fecha, tipo_usuario