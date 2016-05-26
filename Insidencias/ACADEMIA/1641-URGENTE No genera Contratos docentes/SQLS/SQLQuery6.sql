select distinct e.tcdo_ccod                                               as 
                tipo_contrato, 
                e.tcdo_ccod, 
                e.cdoc_ncorr, 
                b.sede_ccod, 
                b.carr_ccod, 
                b.jorn_ccod, 
                a.pers_ncorr, 
                protic.obtener_rut(a.pers_ncorr)                          as rut 
                , 
                max(d.tcat_valor) 
                as categoria, 
                (select tcat_valor 
                 from   tipos_categoria 
                 where  tcat_ccod = 
                        protic.obtiene_categoria_carrera(a.pers_ncorr, 
                        '1', 
                                            '47 ', '1', 
                                '242', 0))        as valor_categoria 
                , 
                protic.obtener_nombre_completo(a.pers_ncorr, 
                'a')         as nom, 
                protic.anexos_pendientes(a.pers_ncorr, '47 ') as 
                pendientes, 
                protic.anexos_pendientes(a.pers_ncorr, '47 ') as 
                calcular, 
                --protic.anexos_nuevos(a.pers_ncorr,2012) as anexos_nuevos ,    
                protic.anexos_nuevos_escuela(a.pers_ncorr, '47 ', 
                '1', '1', 2016)   as 
                anexos_nuevos_escuela, 
                protic.anexos_nuevos(a.pers_ncorr, 2016)          as 
                anexos_creados, 
                protic.maxima_duracion_asignatura(a.pers_ncorr)           as 
                duracion_asignatura 
from   personas a 
       join carreras_docente as b 
         on a.pers_ncorr = b.pers_ncorr 
            and cast(b.carr_ccod as varchar) = '47 ' 
            and cast(b.jorn_ccod as varchar) = '1' 
            and cast(b.sede_ccod as varchar) = '1' 
       left outer join bloques_profesores as c 
                    on b.pers_ncorr = c.pers_ncorr 
       left outer join tipos_categoria as d 
                    on b.tcat_ccod = d.tcat_ccod 
       left outer join contratos_docentes_upa as e 
                    on a.pers_ncorr = e.pers_ncorr 
                       and e.ano_contrato = 2016 
                       and e.ecdo_ccod = 1 
       join periodos_academicos f 
         on b.peri_ccod = f.peri_ccod 
            and f.anos_ccod = 2016 
group  by a.pers_ncorr, 
          b.sede_ccod, 
          b.carr_ccod, 
          b.jorn_ccod, 
          e.cdoc_ncorr, 
          e.tcdo_ccod 
order  by nom 