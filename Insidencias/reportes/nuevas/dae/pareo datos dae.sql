select b.pers_ncorr,e.sede_tdesc as sede, f.jorn_tdesc as jornada,a.* 
from sd_renovantes_dae a, personas b, alumnos c, ofertas_academicas d,
sedes e, jornadas f
where a.rut=b.pers_nrut
and b.pers_ncorr=c.pers_ncorr
and c.matr_ncorr=(select max(matr_ncorr) from alumnos where pers_ncorr=b.pers_ncorr and emat_ccod not in (9))
and c.ofer_ncorr=d.ofer_ncorr
and d.sede_ccod=e.sede_ccod
and d.jorn_ccod=f.jorn_ccod
order by num desc



-- otros
select max(comp_mdocumento) from contratos a, compromisos b, alumnos c
        where a.cont_ncorr=b.comp_ndocto
        and a.matr_ncorr=c.matr_ncorr
        and a.peri_ccod=206
        and c.pers_ncorr=22435
        and b.tcom_ccod=2
        and emat_ccod not in (9,8)
                

-- agregar monto pagado
select ad.*,pe.pers_ncorr,(select max(comp_mdocumento) from contratos a, compromisos b, alumnos c
                where a.cont_ncorr=b.comp_ndocto
                and a.matr_ncorr=c.matr_ncorr
                and a.peri_ccod=206
                and c.pers_ncorr=pe.pers_ncorr
                and b.tcom_ccod=2
                and emat_ccod not in (8,9)) as arancel_real_sis
from sd_alumnos_arancel_dae ad, personas pe
where ad.rut=pe.pers_nrut


-- Arancel carrera y pagado
select pe.pers_ncorr,(select max(comp_mdocumento) from contratos a, compromisos b, alumnos c
                where a.cont_ncorr=b.comp_ndocto
                and a.matr_ncorr=c.matr_ncorr
                and a.peri_ccod=206
                and c.pers_ncorr=pe.pers_ncorr
                and b.tcom_ccod=2
                and emat_ccod not in (8,9)) as arancel_real_sis,
               (select top 1 e.aran_mcolegiatura from contratos a, compromisos b, alumnos c, ofertas_academicas d, aranceles e
                where a.cont_ncorr=b.comp_ndocto
                and a.matr_ncorr=c.matr_ncorr
                and a.peri_ccod=206
                and c.pers_ncorr=pe.pers_ncorr
                and b.tcom_ccod=2
                and c.ofer_ncorr=d.ofer_ncorr
                and d.aran_ncorr=e.aran_ncorr
                and c.emat_ccod not in (8,9)
                order by c.matr_ncorr desc) as arancel_carrera,
ad.* 
from sd_total_creditos_2007 ad, personas pe
where ad.rut=pe.pers_nrut

-- preasignacion para dae
select distinct a.*, isnull(b.pers_nnota_ens_media,0) as promedio_media,
protic.obtener_nombre_carrera(c.ofer_ncorr,'CJ') as carrera
from sd_lista_preasignacion a, personas b, alumnos c, postulantes d
where a.rut=b.pers_nrut
and b.pers_ncorr=c.pers_ncorr
and c.post_ncorr=d.post_ncorr
and d.peri_ccod=206


-- pareo alumnos existentes

select a.* from sd_renovantes_2007 a, personas b, alumnos c, postulantes d
where a.rut=b.pers_nrut
and b.pers_ncorr=c.pers_ncorr
and c.post_ncorr=d.post_ncorr
and d.peri_ccod=206
and emat_ccod=1