select cod_pre from protic.presupuesto_upa where cod_area in (
    select area_ccod from protic.area_presupuesto_usuario where rut_usuario=13582834
)
 


select  month(b.movfv) as mes_venc,isnull(sum(movhaber),0) as monto, sum(valor) as presupuestado, sum(valor)-isnull(sum(movhaber),0) as desviacion  
from  softland.cwmovim b, presupuesto_upa.protic.vis_presupuesto_anual c
where month(b.movfv)=c.mes 
    and cast(b.cajcod as varchar) like cast(c.cod_pre as varchar)
    and year(b.movfv)=2009   
    and b.movhaber <> 0   
    and b.pctcod like '2-10-070-10-000003'  
    and b.cpbnum>0
    and b.cajcod in (
        select cod_pre from presupuesto_upa.protic.vis_presupuesto_anual where cod_area in (
            select area_ccod from presupuesto_upa.protic.area_presupuesto_usuario where rut_usuario=13582834
        )
    )
group by month(b.movfv)


select  * from  protic.presupuesto_upa where cod_area=37

select  *
from  softland.cwmovim b
where year(b.movfv)=2009   
    and b.movhaber <> 0   
    and b.pctcod like '2-10-070-10-000003'  
    and b.cpbnum>0
    and b.cajcod in (
        select cod_pre from presupuesto_upa.protic.vis_presupuesto_anual where cod_area in (
            select area_ccod from presupuesto_upa.protic.area_presupuesto_usuario where rut_usuario=13582834
        )
      )


--################################################
-- ##   Presupuesto por area presupuestaria     ##
--################################################
select  upper(nombremes) as mes,indice as mes_venc,isnull(presu_real,0) as presu_real,  
        isnull(presupuestado,0) as presupuestado,  isnull(desviacion,0) as desviacion
			 from softland.sw_mesce as b 
             left outer join (
    select isnull(pa.mes,pr.mes) as mes, presu_real,presupuestado, presupuestado-presu_real as desviacion from 
    (select isnull(sum(cast(movhaber as numeric)),0) as presu_real, month(movfv) as mes 
    from  softland.cwmovim   
    where cajcod in (
            select cod_pre from presupuesto_upa.protic.vis_presupuesto_anual where cod_area in (
                select area_ccod from presupuesto_upa.protic.area_presupuesto_usuario where rut_usuario=13582834
                ) 
            )
            and year(movfv)=2009   
            and movhaber <> 0   
            and pctcod like '2-10-070-10-000003'  
            and cpbnum>0  group by month(movfv)
        ) as pr full outer join
    (select sum(valor) as presupuestado,mes 
        from presupuesto_upa.protic.vis_presupuesto_anual 
        where cod_area in (
                    select area_ccod from presupuesto_upa.protic.area_presupuesto_usuario where rut_usuario=13582834
                ) 
        group by mes
        ) as pa
    on pr.mes=pa.mes
    )as a
on indice=mes



--################################################
-- ##   Presupuesto por codigo presupuestario   ##
--################################################
select  upper(nombremes) as mes,indice as mes_venc,isnull(presu_real,0) as presu_real,  
        isnull(presupuestado,0) as presupuestado,  isnull(desviacion,0) as desviacion
			 from softland.sw_mesce as b 
             left outer join (
    select pr.mes as mes, presu_real,presupuestado, presupuestado-presu_real as desviacion from 
    (select isnull(sum(cast(movhaber as numeric)),0) as presu_real, month(movfv) as mes 
    from  softland.cwmovim   
    where cajcod='3-F9-01200' 
        and year(movfv)=2009   
        and movhaber <> 0   
        and pctcod like '2-10-070-10-000003'  
        and cpbnum>0  group by month(movfv)) as pr,
    (select sum(valor) as presupuestado,mes 
    from presupuesto_upa.protic.vis_presupuesto_anual 
    where cod_pre='3-F9-01200' group by mes) as pa
    where pr.mes=pa.mes
    )as a
on indice=mes

