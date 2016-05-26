select a.rut,a.dv, 
c.dire_tcalle as direccion, c.dire_tnro as nro,
c.dire_tblock as depto, c.dire_tpoblacion as poblacion,
(select cast(max(comp_mdocumento) as numeric) from contratos a, compromisos b, alumnos c
                where a.cont_ncorr=b.comp_ndocto
                and a.matr_ncorr=c.matr_ncorr
                and a.peri_ccod in (202,204,206)
                and c.pers_ncorr=pe.pers_ncorr
                and b.tcom_ccod=2
                and emat_ccod not in (8,9)
                --and c.ofer_ncorr=protic.ultima_oferta_matriculado(pe.pers_ncorr)
                ) as arancel_real_sis
From sd_agregar_direcciones_2 a, personas pe, direcciones c
where a.rut=pe.pers_nrut
    and pe.pers_ncorr *= c.pers_ncorr
    and c.tdir_ccod=1



select * from compromisos where comp_ndocto=41296 

select * from sd_comentarios_abril_2007

select cast(rut as numeric) as rut,cast(comentario as varchar(8000)) as glosa,
convert(datetime,'04/04/2007',103) as fecha,pers_ncorr
from sd_comentarios_abril_2007 a, personas b
where a.rut=b.pers_nrut