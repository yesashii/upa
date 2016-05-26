select carrera,emat_tdesc,matr_ncorr,tipo_alumno,max(tipo_evento) as tipo_evento,anio_evento,--max(even_tnombre) as nombre_evento,
protic.obtener_rut(pers_ncorr) as rut_alumno,nombres,paterno,materno,anio_rendido_prueba,
protic.obtener_direccion(pers_ncorr,1,'CNPB') AS direccion_alumno,
max(colegio) as colegio,ciud_tcomuna as ciudad,ciud_tdesc as comuna
--,max(carrera_1) as opcion1,max(carrera_2) as opcion2,max(carrera_3) as opcion3 
from (
        select  distinct year(c.even_fevento) as anio_evento,d.pers_tnombre as nombres,d.pers_tape_paterno as paterno, d.pers_tape_materno as materno,
        i.emat_tdesc,f.matr_ncorr,f.pers_ncorr,h.sede_ccod,protic.obtener_nombre_carrera(f.ofer_ncorr,'CJ') as carrera,
        carrera_1,carrera_2,carrera_3,c.even_tnombre,isnull(post_nano_paa,000) as anio_rendido_prueba,
        case e.post_bnuevo when 'S' then 'Nuevo' else 'Antiguo' end as tipo_alumno ,
        j.teve_tdesc as tipo_evento,ciud_tcomuna,ciud_tdesc, isnull(k.cole_tdesc,'sin informacion') as colegio
            from personas_eventos_upa a,eventos_alumnos b,
            eventos_upa c, personas_postulante d,postulantes e, alumnos f, ciudades g,
             ofertas_academicas h, estados_matriculas i, tipo_evento j,colegios k
            where a.pers_ncorr_alumno=b.pers_ncorr_alumno
            and b.even_ncorr=c.even_ncorr 
            and c.teve_ccod not in (5,8)
            --and year(c.even_fevento)=2009
            and a.pers_nrut=d.pers_nrut
            and d.pers_ncorr=e.pers_ncorr
            and e.post_ncorr=f.post_ncorr
            and a.ciud_ccod=g.ciud_ccod
            and f.ofer_ncorr=h.ofer_ncorr
            and c.teve_ccod=j.teve_ccod 
            and e.peri_ccod=218
            and f.emat_ccod not in (9)
            and f.emat_ccod=i.emat_ccod
            and a.cole_ccod*=k.cole_ccod
 ) as tabla 
 where tipo_alumno not in  ('Antiguo')
group by nombres,paterno,materno,emat_tdesc,matr_ncorr,pers_ncorr,
carrera,ciud_tcomuna,ciud_tdesc,tipo_alumno,anio_rendido_prueba,anio_evento--,tipo_evento
order by carrera,nombres

