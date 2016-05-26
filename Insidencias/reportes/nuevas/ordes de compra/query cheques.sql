select CpbNum,CpbAno,numero, fecha, proveedor, sum(monto) as monto_cheque from (
select a.CpbNum,a.CpbAno,convert(char(10),a.movfv,103) as fecha,b.nomaux as proveedor,   
  cast(a.movdebe as integer) as monto,cast(a.NumDoc as integer) as numero    
  from softland.cwmovim a join softland.cwtauxi b    
    on  a.codaux=b.codaux
  where a.codaux='13582834'
  and a.ttdcod like 'CP'   
  and a.cpbano=2011 
) as tabla
group by  CpbNum,CpbAno, numero, fecha, proveedor


/*********    CHEQUES SIN TIPO DE ESTADO      **********/
select c.*,a.CpbAno,a.CpbNum,a.MovNum,convert(char(10),a.movfv,103) as fecha,a.CodBanco,   
  cast(a.movhaber as integer) as monto,cast(a.NumDoc as integer) as numero,b.nomaux as proveedor,    
  cast(a.movhaber as integer) as cod_monto,cast(a.NumDoc as integer) as cod_numero,a.codaux as cod_proveedor   
  from softland.cwmovim a join softland.cwtauxi b    
    on  a.codaux=b.codaux
  join softland.cwcpbte c
    on a.cpbnum=c.cpbnum
    and c.cpbtip='E'       
  where a.cpbnum not in (00000000)
  and a.cajcod not like '0000000000'   
  and a.codaux='13582834'   
  and a.cpbano=2011  


/******************     CHEQUES CON ESTADO DE LOG **********************/
select cpbtip,estado_cheque,pctcod,a.CpbAno,a.CpbNum,a.MovNum,convert(char(10),a.movfv,103) as fecha,a.CodBanco,   
  cast(a.movhaber as integer) as monto,cast(a.NumDoc as integer) as numero,b.nomaux as proveedor,    
  cast(a.movhaber as integer) as cod_monto,cast(a.NumDoc as integer) as cod_numero,a.codaux as cod_proveedor   
  from softland.cwmovim a join softland.cwtauxi b    
    on  a.codaux=b.codaux
  join softland.cwcpbte c
    on a.cpbnum=c.cpbnum
    and c.cpbtip='E'       
  left outer join softland.pw_log_cheques d
    on a.cpbnum=d.cpbnum
    and a.cpbano=d.cpbano
    and d.movnum=0  
  where a.cpbnum not in (00000000)   
  and a.codaux='13582834'   
  and a.cpbano=2011  
  
  