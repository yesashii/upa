use udelpac 


select Upper(nombremes)                          as mes, 
       indice                                    as mes_venc, 
       Cast(isnull(presu_real, 0) as numeric)    as presu_real, 
       Cast(isnull(presupuestado, 0) as numeric) as presupuestado, 
       Cast(isnull(desviacion, 0) as numeric)    as desviacion 
from   softland.sw_mesce as b 
       left outer join (select pa.mes                                as mes, 
                               isnull(presu_real, 0)                 as 
                               presu_real, 
                               presupuestado, 
                               presupuestado - isnull(presu_real, 0) as 
                               desviacion 
                        from   (select Sum(valor) as presupuestado, 
                                       mes 
                                from 
              presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2015 
                                where  cod_pre in (select distinct cod_pre 
                                                   from 
              presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2015 
                          where  cod_area = 76) 
                                group  by mes) as pa 
                               left outer join (select isnull(Sum(Cast( 
                                                       movhaber as numeric)), 0) 
                                                       as 
                                                       presu_real 
                                                       , 
Cast(Substring(b.efcodi, 1, 2) 
     as numeric) as mes 
from   softland.cwmovim a, 
softland.cwmovef b 
where  a.cpbnum = b.cpbnum 
and a.movnum = b.movnum 
and a.movhaber = b.efmontohaber 
and 
Substring(b.efcodi, 3, 4) = 2015 
and a.cajcod in (select distinct 
                cod_pre 
                 from 
presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2015 
where  cod_area = 76) 
and a.movhaber <> 0 
and a.pctcod like '2-10-070-10-000004' 
and a.cpbnum > 0 
group  by Cast(Substring(b.efcodi, 1, 2) as numeric)) 
as pr 
on pa.mes = pr.mes)as a 
on indice = mes 
order  by mes_venc asc 





select * from  softland.WISsistemas
select * from  softland.sw_trcpago
select * from  softland.Sw_PersonDJ
select * from  softland.sw_boletahonorario
select * from  softland.sw_informe

select * from softland.sw_infocer
select * from softland.sw_estadoper
select * from softland.sw_variablepersona where ficha = 15370707 and codVariable = 'p309'

select * from softland.sw_variablepersona where ficha = 8043252 and codVariable = 'h001' -- bruto

select * from softland.sw_variablepersona where ficha = 13919051 and codVariable in ('h001','h065') order by mes desc

select SUM(CAST(valor AS NUMERIC)) from softland.sw_variablepersona where ficha = 16371641 and mes = 20 and codVariable in ('h001','h065')
select * from softland.sw_variablepersona where ficha = 16371641 and mes = 1 and codVariable in ('D001','D002','D004','D005', 'P063', 'D018')



select SUM(CAST(valor AS NUMERIC)) from softland.sw_variablepersona where ficha = 8043252 and mes = 17 and codVariable in ('h001','h065') 
select SUM(CAST(valor AS NUMERIC)) from softland.sw_variablepersona where ficha = 14605648 and mes = 24 and codVariable in ('D001','D002','D004','D005')

-- --------------------


SELECT * FROM INFORMATION

select * from  softland.RGParam

select * from  softland.sw_vacadic




select SUM(CAST(valor AS NUMERIC)) from softland.sw_variablepersona where ficha = 13919051 and codVariable in ('h001','h065') 



SELECT *, CAST(valor AS NUMERIC)*0.07 FROM softland.sw_variablepersona where ficha = 16371641 AND codVariable='H110'

SELECT * FROM softland.sw_variable WHERE descripcion like '%adici%'
SELECT * FROM softland.sw_varformula  WHERE codVariable like '%P063%'
SELECT * from Information_Schema.Tables

SELECT * from Information_Schema.COLUMNS where column_name like '%codvariable%'

SELECT * from Information_Schema.Tables where table_name like 'RG%'


select * from softland.sw_variablepersona where ficha = 13682204 and codVariable = 'h001' 




