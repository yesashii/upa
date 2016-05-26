select case when preg_1_1='1' then 'Por amigos y compañeros de colegio' else '' end as alternativa_1,
case when preg_1_2='1' then 'Conocidos estudiando en  UPA' else '' end as alternativa_2,
case when preg_1_3='1' then 'Eventos o charlas en colegios' else '' end as alternativa_3,
case when preg_1_4='1' then 'Por profesores de la universidad' else '' end as alternativa_4,
case when preg_1_5='1' then 'Por familiares y/o parientes' else '' end as alternativa_5,
case when preg_1_6='1' then 'Preuniversitario' else '' end as alternativa_6,
carrera,emat_tdesc,matr_ncorr,tipo_alumno,max(tipo_evento) as tipo_evento,anio_evento,--max(even_tnombre) as nombre_evento,
protic.obtener_rut(aa.pers_ncorr) as rut_alumno,nombres,paterno,materno,anio_rendido_prueba,
protic.obtener_direccion(aa.pers_ncorr,1,'CNPB') AS direccion_alumno,
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
 ) as aa , encuestas_postulantes bb
 where tipo_alumno not in  ('Antiguo')
 and aa.pers_ncorr*=bb.pers_ncorr
group by nombres,paterno,materno,emat_tdesc,matr_ncorr,aa.pers_ncorr,preg_1_1,preg_1_2,preg_1_4,preg_1_3,preg_1_5,preg_1_6,
carrera,ciud_tcomuna,ciud_tdesc,tipo_alumno,anio_rendido_prueba,anio_evento--,tipo_evento
order by carrera,nombres

