select carrera,tipo_alumno,max(tipo_evento) as tipo_evento,estado_postulacion,--max(even_tnombre) as nombre_evento,
protic.obtener_rut(pers_ncorr) as rut_alumno,nombres,paterno,materno,anio_rendido,
protic.obtener_direccion(pers_ncorr,1,'CNPB') AS direccion_alumno,
max(colegio) as colegio,ciud_tcomuna as ciudad,ciud_tdesc as comuna
--,max(carrera_1) as opcion1,max(carrera_2) as opcion2,max(carrera_3) as opcion3 
from (
        select  distinct 
        d.pers_tnombre as nombres,d.pers_tape_paterno as paterno, d.pers_tape_materno as materno,
        h.sede_ccod,protic.obtener_nombre_carrera(f.ofer_ncorr,'CJ') as carrera,e.pers_ncorr,
        carrera_1,carrera_2,carrera_3,c.even_tnombre,isnull(post_nano_paa,000) as anio_rendido,
        case e.post_bnuevo when 'S' then 'Nuevo' else 'Antiguo' end as tipo_alumno , epos_tdesc as estado_postulacion,
        j.teve_tdesc as tipo_evento,ciud_tcomuna,ciud_tdesc, isnull(k.cole_tdesc,'sin informacion') as colegio
            from personas_eventos_upa a,eventos_alumnos b,
            eventos_upa c, personas_postulante d,postulantes e, detalle_postulantes f, ciudades g,
             ofertas_academicas h, tipo_evento j,colegios k, estados_postulantes i
            where a.pers_ncorr_alumno=b.pers_ncorr_alumno
            and b.even_ncorr=c.even_ncorr 
            and c.teve_ccod not in (5,8)
            and year(c.even_fevento)=2009
            and a.pers_nrut=d.pers_nrut
            and d.pers_ncorr=e.pers_ncorr
            and e.post_ncorr=f.post_ncorr
            and f.ofer_ncorr=h.ofer_ncorr
            and a.ciud_ccod=g.ciud_ccod
            and c.teve_ccod=j.teve_ccod
            and e.epos_ccod=i.epos_ccod  
            and e.peri_ccod=218
            and a.cole_ccod*=k.cole_ccod
            and not exists (select 1 from alumnos where pers_ncorr= e.pers_ncorr)
 ) as tabla 
 where tipo_alumno not in  ('Antiguo')
group by nombres,paterno,materno,carrera,ciud_tcomuna,ciud_tdesc,tipo_alumno,anio_rendido,pers_ncorr,estado_postulacion--,tipo_evento
order by carrera,nombres