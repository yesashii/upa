select sum (enero) as enero, sum (febrero) as febrero,sum (marzo) as marzo,
sum (abril) as abril, sum (mayo) as mayo,sum (junio) as junio,
sum (julio) as julio, sum (agosto) as agosto,sum (septiembre) as septiembre,
sum (octubre) as octubre, sum (noviembre) as noviembre,sum (diciembre) as diciembre
from  (
    select case month(d.ding_fdocto) when 1 then sum(d.ding_mdetalle) end as enero,
    case month(d.ding_fdocto) when 2 then sum(d.ding_mdetalle) end as febrero,
    case month(d.ding_fdocto) when 3 then sum(d.ding_mdetalle) end as marzo,
    case month(d.ding_fdocto) when 4 then sum(d.ding_mdetalle) end as abril,
    case month(d.ding_fdocto) when 5 then sum(d.ding_mdetalle) end as mayo,
    case month(d.ding_fdocto) when 6 then sum(d.ding_mdetalle) end as junio,
    case month(d.ding_fdocto) when 7 then sum(d.ding_mdetalle) end as julio,
    case month(d.ding_fdocto) when 8 then sum(d.ding_mdetalle) end as agosto,
    case month(d.ding_fdocto) when 9 then sum(d.ding_mdetalle) end as septiembre,
    case month(d.ding_fdocto) when 10 then sum(d.ding_mdetalle) end as octubre,
    case month(d.ding_fdocto) when 11 then sum(d.ding_mdetalle) end as noviembre,
    case month(d.ding_fdocto) when 12 then sum(d.ding_mdetalle) end as diciembre
    from sd_documentos_magister a, personas b, ingresos c, detalle_ingresos d
    where a.rut=b.pers_nrut
    and b.pers_ncorr=c.pers_ncorr
    and c.ting_ccod=7
    and c.eing_ccod in (1,4)
    and c.ingr_ncorr*=d.ingr_ncorr
    and year(d.ding_fdocto)='2007'
    group by d.ingr_ncorr,d.ding_fdocto
) as tabla
