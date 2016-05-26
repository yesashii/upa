SELECT b.sala_ccod, 
       sala_ciso, 
       tsal_tdesc, 
       dias_ccod, 
       hora_ccod, 
       protic.Detalle_sala_con_carrera(b.sala_ccod, a.dias_ccod, a.hora_ccod, CONVERT(DATETIME, '11-08-2015', 103), CONVERT(DATETIME, '23-11-2015', 103), d.peri_ccod) AS detalle, 
       Count(DISTINCT a.bloq_ccod)                                                                                                                                     AS usos
FROM   bloques_horarios a, 
       salas b, 
       tipos_sala c, 
       secciones d, 
       asignaturas e 
WHERE  a.sala_ccod = b.sala_ccod 
       AND b.tsal_ccod = c.tsal_ccod 
       AND Cast(b.sala_ccod AS VARCHAR) = '167' 
       AND hora_ccod IS NOT NULL 
       AND a.secc_ccod = d.secc_ccod 
       AND d.asig_ccod = e.asig_ccod 
       AND d.peri_ccod = CASE e.duas_ccod 
                           WHEN 3 THEN '238' 
                           ELSE '240' 
                         END 
       AND a.bloq_finicio_modulo BETWEEN CONVERT(DATETIME, '11-08-2015', 103) AND CONVERT(DATETIME, '23-11-2015', 103) 
GROUP  BY d.peri_ccod, 
          b.sala_ccod, 
          sala_ciso, 
          tsal_tdesc, 
          dias_ccod, 
          hora_ccod 





<br><font size=-1 color=blue>ACTIVIDADES ACADEMICAS COMPLEMENTARIAS</font><br>OPTDAE42                 
-TALLER DE TEATRO sec 1 - - (D)<br>HECTOR ROLANDO VALENZUELA<br> Hasta <font color="#ff0000">23/11/2015</font><br>0 Alumnos <br>



<br><font size=-1 color=blue>ACTIVIDADES ACADEMICAS COMPLEMENTARIAS</font><br>OPTDAE42                 
-TALLER DE TEATRO sec 1 - - (D)<br>HECTOR ROLANDO VALENZUELA<br> Hasta <font color="#ff0000">23/11/2015</font><br>0 Alumnos <br>

<br><font size=-1 color=blue>ACTIVIDADES ACADEMICAS COMPLEMENTARIAS</font><br>OPTDAE15                 
-TALLER DE CANTO POPULAR sec 1 - - (D)<br>MARIA PAZ MERA<br> Hasta <font color="#ff0000">27/10/2015</font><br>0 Alumnos <br>

-- -------------------------------------------------------------------------------

 protic.Detalle_sala_con_carrera(b.sala_ccod, a.dias_ccod, a.hora_ccod, CONVERT(DATETIME, '11-08-2015', 103), CONVERT(DATETIME, '23-11-2015', 103), 240) 





bloq_ftermino_modulo


select * from bloques_horarios order by ssec_ncorr asc

-- ---------------------------------------------------------------------------------

ALTER FUNCTION protic.detalle_sala_con_carrera(
@sala numeric, 
@dia numeric, 
@hora numeric,
@fini datetime, 
@fter datetime,
@periodo numeric) 

RETURNS varchar(500)


AS
BEGIN 

declare @salida    varchar(500)
declare @flag	   numeric

set	@flag = 1
set	@salida = ''
--------------------------------variable del cursos c_horario-----------------------
declare @vc_detalle varchar(100)
declare @vc_carrera varchar(100)
declare @vc_profesor varchar(100)
declare @vc_fecha_termino varchar(20)
declare @vc_cantidad_alumnos varchar(3)
----------------------------------cursor c_horario-----------------------------------
declare c_horario cursor for

 SELECT TOP 1 Cast(b.asig_ccod AS VARCHAR) + '-' + Cast(d.asig_tdesc AS VARCHAR) + ' sec' + ' ' + Cast(b.secc_tdesc AS VARCHAR)    													AS detalle, 
             Upper(carr_tdesc)                                   																																	 													AS carrera, 
             CASE Isnull(e.pers_ncorr, 0) WHEN 0 THEN 'Sin docente' ELSE Cast(c.pers_tnombre AS VARCHAR) + ' ' + Cast(c.pers_tape_paterno AS VARCHAR) END   AS profesor, 
             protic.Trunc(a.bloq_ftermino_modulo)                 																																													AS fecha_termino, 
             Cast((SELECT Count(*) FROM   cargas_academicas ca   WHERE  ca.secc_ccod = b.secc_ccod) AS VARCHAR) 																						AS cantidad_alumnos 
FROM   bloques_horarios a 
       JOIN secciones b 
         ON a.secc_ccod = b.secc_ccod 
       JOIN carreras tt 
         ON b.carr_ccod = tt.carr_ccod 
       JOIN asignaturas d 
         ON b.asig_ccod = d.asig_ccod 
       LEFT OUTER JOIN bloques_profesores e 
                    ON a.bloq_ccod = e.bloq_ccod 
       LEFT OUTER JOIN personas c 
                    ON c.pers_ncorr = e.pers_ncorr 
WHERE  a.sala_ccod = @sala 
       AND a.dias_ccod = @dia 
       AND a.hora_ccod = @hora 
       AND b.peri_ccod = @periodo 
       AND ( a.bloq_finicio_modulo BETWEEN @fini AND @fter 
              OR a.bloq_ftermino_modulo BETWEEN @fini AND @fter 
              OR a.bloq_finicio_modulo < @fini 
                 AND a.bloq_ftermino_modulo > @fter ) 
    union
            select top 1  
            cast(f.mote_ccod as varchar)+ '-' +cast(f.mote_tdesc as varchar)+' sec'+' '+ 
            cast(d.seot_tdesc as varchar) as detalle,lower(h.dcur_tdesc) as carrera,
            isnull((select top 1 pers_tnombre + ' ' + pers_tape_paterno 
            from bloques_relatores_otec tt, personas t2
            where tt.bhot_ccod=a.bhot_ccod and tt.pers_ncorr=t2.pers_ncorr ),'Sin relator') as profesor,
            protic.trunc(a.bhot_ftermino) as fecha_termino,cast(0 as varchar) as cantidad_alumnos 
                    from bloques_horarios_otec a,salas b, tipos_sala c,
                    secciones_otec d, mallas_otec e, modulos_otec f,
                    datos_generales_secciones_otec g, diplomados_cursos h
                    where a.sala_ccod = b.sala_ccod
                    and b.tsal_ccod =c.tsal_ccod
                    and a.seot_ncorr=d.seot_ncorr
                    and d.maot_ncorr=e.maot_ncorr
                    and e.mote_ccod=f.mote_ccod
                    and d.dgso_ncorr=g.dgso_ncorr 
                    and g.dcur_ncorr=h.dcur_ncorr
                    and b.sala_ccod = @sala
                    and a.hora_ccod = @dia
                    and a.dias_ccod = @hora
                    and (a.bhot_finicio between @fini and @fter
                    or a.bhot_ftermino between @fini and @fter)
                    and exists (select 1 from bloques_horarios_otec a2,salas b2, tipos_sala c2
                                where a2.sala_ccod = b2.sala_ccod
                                and b2.tsal_ccod =c2.tsal_ccod
                                and b2.sala_ccod = @sala
                                and a2.dias_ccod = a.dias_ccod
                                and a2.hora_ccod = a.hora_ccod
                                and a2.bhot_ccod = a.bhot_ccod
                                and a2.dias_ccod = @dia
                                and a2.hora_ccod = @hora	
                                and (a2.bhot_finicio between  @fini and @fter
                                or a2.bhot_ftermino between @fini and @fter ) )   
        union
          select top 1  
          cast(f.mote_ccod as varchar)+ '-' +cast(f.mote_tdesc as varchar)+' sec'+' '+ 
          cast(d.seot_tdesc as varchar) as detalle,lower(h.dcur_tdesc) as carrera,
          isnull((select top 1 pers_tnombre + ' ' + pers_tape_paterno from bloques_relatores_otec tt, personas t2
          where tt.bhot_ccod=a.bhot_ccod and tt.pers_ncorr=t2.pers_ncorr ),'Sin relator') as profesor,
          protic.trunc(a.bhot_ftermino) as fecha_termino,cast(0 as varchar) as cantidad_alumnos 
                from bloques_horarios_otec a,salas b, tipos_sala c,
                secciones_otec d, mallas_otec e, modulos_otec f,
                datos_generales_secciones_otec g, diplomados_cursos h
                where a.sala_ccod = b.sala_ccod
                and b.tsal_ccod =c.tsal_ccod
                and a.seot_ncorr=d.seot_ncorr
                and d.maot_ncorr=e.maot_ncorr
                and e.mote_ccod=f.mote_ccod
                and d.dgso_ncorr=g.dgso_ncorr 
                and g.dcur_ncorr=h.dcur_ncorr
                and b.sala_ccod = @sala
                and a.hora_ccod = @dia
                and a.dias_ccod = @hora
                and (a.bhot_finicio between @fini and @fter
                                    or a.bhot_ftermino between @fini and @fter)
                and exists (select 1 from bloques_horarios_otec a2,horarios_sedes_otec b2
                            where a2.sala_ccod = @sala
                            and a2.sede_ccod = b2.sede_ccod
                            and a2.hora_ccod = b2.hora_ccod
                            and a2.dias_ccod = a.dias_ccod
                            and a2.dias_ccod = @dia
                            and (b2.tope_pregrado_inicio = @hora or b2.tope_pregrado_fin = @hora)	
                            and (a2.bhot_finicio between  @fini and @fter
                            or a2.bhot_ftermino between @fini and @fter ) )
        union
          select top 1 upper(motivo) as detalle,"Reserva Sala" as carrera,
          upper(responsable) as profesor,
          protic.trunc(fecha_reserva) as fecha_termino,num_nalumnos as cantidad_alumnos 
                from RESERVA_HORAS_LABORATORIOS
                where sala_ccod = @sala
                and hora_ccod = @hora
                and dias_ccod = @dia
                and fecha_reserva between  @fini and @fter
                
---------------------------------------------fin cursor c_horarios---------------------------------        
		open c_horario
        fetch next from c_horario
        into   @vc_detalle,@vc_carrera,@vc_profesor,@vc_fecha_termino,@vc_cantidad_alumnos
        
        while @@FETCH_STATUS = 0
        begin 		    
        	if @flag = 1 
		        set @flag = 2
	        else
		        select @salida = @salida +'<br>'
	   
    	    select  @salida = cast(rtrim(ltrim(@salida))as varchar) +'<br><font size=-1 color=blue>'+@vc_carrera+'</font><br>'+@vc_detalle + '<br>' + @vc_profesor +'<br>'+' Hasta <font color="#ff0000">'+@vc_fecha_termino+'</font><br>'+@vc_cantidad_alumnos+ ' Alumnos <br>'

            fetch next from c_horario
            into   @vc_detalle,@vc_carrera,@vc_profesor,@vc_fecha_termino,@vc_cantidad_alumnos

            END --fin while
close c_horario
DEALLOCATE c_horario

return @salida

END

-- --------------------------------------------------------------------------------------------

SELECT
				b.sala_ccod, 
				a.dias_ccod,
				a.hora_ccod,
				d.peri_ccod,
       protic.Detalle_sala_con_carrera(b.sala_ccod, a.dias_ccod, a.hora_ccod, CONVERT(DATETIME, '01-08-2015', 103), CONVERT(DATETIME, '23-11-2015', 103), d.peri_ccod) AS detalle
FROM   bloques_horarios a, 
       salas b, 
       tipos_sala c, 
       secciones d, 
       asignaturas e 
WHERE  a.sala_ccod = b.sala_ccod 
       AND b.tsal_ccod = c.tsal_ccod 
       AND Cast(b.sala_ccod AS VARCHAR) = '274' 
       AND hora_ccod IS NOT NULL 
       AND a.secc_ccod = d.secc_ccod 
       AND d.asig_ccod = e.asig_ccod 
       AND d.peri_ccod = CASE e.duas_ccod 
                           WHEN 3 THEN '238' 
                           ELSE '240' 
                         END 
       AND a.bloq_finicio_modulo BETWEEN CONVERT(DATETIME, '27-07-2015', 103) AND CONVERT(DATETIME, '05-12-2015', 103) 
GROUP  BY d.peri_ccod, 
          b.sala_ccod, 
          sala_ciso, 
          tsal_tdesc, 
          dias_ccod, 
          hora_ccod 
-- -------------------------------------------------------------------------

select 
		b.sala_ccod,sala_ciso,tsal_tdesc,dias_ccod,hora_ccod,    	protic.detalle_sala_con_carrera(       	b.sala_ccod,a.dias_ccod,a.hora_ccod,       	convert(datetime,'27-07-2015',103),convert(datetime,'05-12-2015',103),d.peri_ccod) as detalle, count(distinct a.bloq_ccod) as usos 
	  	from 
			bloques_horarios a, salas b, tipos_sala c,secciones d, asignaturas e 
	  	where 
			a.sala_ccod =b.sala_ccod 
			and b.tsal_ccod=c.tsal_ccod 
			and cast(b.sala_ccod as varchar)='274'
			and hora_ccod is not null  
			and a.secc_ccod=d.secc_ccod and d.asig_ccod=e.asig_ccod and d.peri_ccod = case e.duas_ccod when 3 then '238' else '240' end 
			and a.bloq_finicio_modulo  
		between  
			convert(datetime,'27-07-2015',103)
		  and  
		    convert(datetime,'05-12-2015',103)
	  	group by  d.peri_ccod,b.sala_ccod,sala_ciso,tsal_tdesc,dias_ccod,hora_ccod 
   UNION 
   select b.sala_ccod,sala_ciso,tsal_tdesc,dias_ccod,hora_ccod, 
			 protic.detalle_sala_con_carrera(b.sala_ccod,a.dias_ccod,a.hora_ccod,convert(datetime,'27-07-2015',103),
			 convert(datetime,'05-12-2015',103),0) as detalle, count(distinct a.bhot_ccod) as usos  
	  from bloques_horarios_otec a,salas b, tipos_sala c, 
		   secciones_otec d, mallas_otec e, modulos_otec f, 
		   datos_generales_secciones_otec g, diplomados_cursos h 
	  where a.sala_ccod = b.sala_ccod 
	  and b.tsal_ccod =c.tsal_ccod 
	  and a.seot_ncorr=d.seot_ncorr 
	  and d.maot_ncorr=e.maot_ncorr 
	  and e.mote_ccod=f.mote_ccod 
	  and d.dgso_ncorr=g.dgso_ncorr  
	  and g.dcur_ncorr=h.dcur_ncorr 
	  and cast(b.sala_ccod as varchar) = '274' 
	  and (a.bhot_finicio between convert(datetime,'27-07-2015',103) and convert(datetime,'05-12-2015',103)
		   or  
		   a.bhot_ftermino between convert(datetime,'27-07-2015',103) and convert(datetime,'05-12-2015',103)) 
	  and exists (select 1 from bloques_horarios_otec a2,salas b2, tipos_sala c2 
				  where a2.sala_ccod = b2.sala_ccod 
				  and b2.tsal_ccod =c2.tsal_ccod 
				  and cast(b2.sala_ccod as varchar) = '274' 
				  and a2.dias_ccod = a.dias_ccod 
				  and a2.hora_ccod = a.hora_ccod 
				  and a2.bhot_ccod = a.bhot_ccod 
				  and (a2.bhot_finicio between  convert(datetime,'27-07-2015',103) and convert(datetime,'05-12-2015',103)
					   or  
					   a2.bhot_ftermino between convert(datetime,'27-07-2015',103) and convert(datetime,'05-12-2015',103) )  
				  )  
	 group by b.sala_ccod,sala_ciso,tsal_tdesc,dias_ccod,hora_ccod 
	 UNION 
	 select b.sala_ccod,sala_ciso,tsal_tdesc,dias_ccod,hora_ccod,    	 
			protic.detalle_sala_con_carrera(b.sala_ccod,a.dias_ccod,a.hora_ccod,convert(datetime,'27-07-2015',103), 
			convert(datetime,'05-12-2015',103),0) as detalle, count(distinct a.bhot_ccod) as usos  
	 from bloques_horarios_otec a,salas b, tipos_sala c, 
		  secciones_otec d, mallas_otec e, modulos_otec f, 
		  datos_generales_secciones_otec g, diplomados_cursos h 
	 where a.sala_ccod = b.sala_ccod 
	 and b.tsal_ccod =c.tsal_ccod 
	 and a.seot_ncorr=d.seot_ncorr 
	 and d.maot_ncorr=e.maot_ncorr 
	 and e.mote_ccod=f.mote_ccod 
	 and d.dgso_ncorr=g.dgso_ncorr  
	 and g.dcur_ncorr=h.dcur_ncorr 
	 and cast(b.sala_ccod as varchar) = '274' 
	 and (a.bhot_finicio between convert(datetime,'27-07-2015',103) and convert(datetime,'05-12-2015',103) 
		  or  
		  a.bhot_ftermino between convert(datetime,'27-07-2015',103) and convert(datetime,'05-12-2015',103)) 
	 and exists ( 
				 select 1 from bloques_horarios_otec a2,horarios_sedes_otec b2 
				 where cast(a2.sala_ccod as varchar) = '274' 
				 and a2.sede_ccod = b2.sede_ccod 
				 and a2.hora_ccod = b2.hora_ccod 
				 and a2.dias_ccod = a.dias_ccod 
				 and (a2.bhot_finicio between  convert(datetime,'27-07-2015',103) and convert(datetime,'05-12-2015',103) 
					  or  
					  a2.bhot_ftermino between convert(datetime,'27-07-2015',103) and convert(datetime,'05-12-2015',103) )  
				) 
	 group by b.sala_ccod,sala_ciso,tsal_tdesc,dias_ccod,hora_ccod 
	 UNION 
	 select rhla_ncorr, b.sala_ccod,b.sala_ciso,tsal_tdesc,dias_ccod,hora_ccod,    	 
			protic.detalle_sala_con_carrera(b.sala_ccod,a.dias_ccod,a.hora_ccod,convert(datetime,'27-07-2015',103), 
			convert(datetime,'05-12-2015',103),0) as detalle, count(distinct a.rhla_ncorr) as usos 
	 from reserva_horas_laboratorios a, salas b, tipos_sala c 
	 where a.sala_ccod = b.sala_ccod 
	 and b.tsal_ccod =c.tsal_ccod 
	 and cast(a.sala_ccod as varchar) = '274' 
	 and fecha_reserva between  convert(datetime,'27-07-2015',103) and convert(datetime,'05-12-2015',103)
	 group by rhla_ncorr, b.sala_ccod,sala_ciso,tsal_tdesc,dias_ccod,hora_ccod  


select * from reserva_horas_laboratorios where rhla_ncorr = 2666

BEGIN TRANSACTION
update reserva_horas_laboratorios set fecha_reserva = '2015-12-09' where rhla_ncorr = 2600

update reserva_horas_laboratorios set fecha_reserva = '2015-12-10' where rhla_ncorr = 2601

update reserva_horas_laboratorios set fecha_reserva = '2015-12-19' where rhla_ncorr = 2631


update reserva_horas_laboratorios set fecha_reserva = '2015-12-17' where rhla_ncorr = 2642


update reserva_horas_laboratorios set fecha_reserva = '2015-12-19' where rhla_ncorr = 2652


update reserva_horas_laboratorios set fecha_reserva = '2015-12-18' where rhla_ncorr = 2653


update reserva_horas_laboratorios set fecha_reserva = '2015-12-19' where rhla_ncorr = 2664


update reserva_horas_laboratorios set fecha_reserva = '2015-12-25' where rhla_ncorr = 2665


update reserva_horas_laboratorios set fecha_reserva = '2015-12-26' where rhla_ncorr = 2666

COMMIT


BEGIN TRANSACTION
update reserva_horas_laboratorios 
set fecha_reserva = REPLACE(fecha_reserva, '11', '12')
where rhla_ncorr in (
select rhla_ncorr
	 from reserva_horas_laboratorios a, salas b, tipos_sala c 
	 where a.sala_ccod = b.sala_ccod 
	 and b.tsal_ccod =c.tsal_ccod 
	 and cast(a.sala_ccod as varchar) = '274' 
	 and fecha_reserva between  convert(datetime,'27-07-2015',103) and convert(datetime,'05-12-2015',103)
	 group by rhla_ncorr
)

COMMIT

-- ----------------------------------------------------------------



 SELECT TOP 1 Cast(b.asig_ccod AS VARCHAR) + '-' + Cast(d.asig_tdesc AS VARCHAR) + ' sec' + ' ' + Cast(b.secc_tdesc AS VARCHAR)    													AS detalle, 
							Upper(carr_tdesc)                                   																																	 													AS carrera, 
							CASE Isnull(e.pers_ncorr, 0) WHEN 0 THEN 'Sin docente' ELSE Cast(c.pers_tnombre AS VARCHAR) + ' ' + Cast(c.pers_tape_paterno AS VARCHAR) END   AS profesor, 
							protic.Trunc(a.bloq_ftermino_modulo)                 																																													AS fecha_termino, 
							Cast((SELECT Count(*) FROM   cargas_academicas ca   WHERE  ca.secc_ccod = b.secc_ccod) AS VARCHAR) 																						AS cantidad_alumnos 
FROM   bloques_horarios a 
       JOIN secciones b 
         ON a.secc_ccod = b.secc_ccod 
       JOIN carreras tt 
         ON b.carr_ccod = tt.carr_ccod 
       JOIN asignaturas d 
         ON b.asig_ccod = d.asig_ccod 
       LEFT OUTER JOIN bloques_profesores e 
                    ON a.bloq_ccod = e.bloq_ccod 
       LEFT OUTER JOIN personas c 
                    ON c.pers_ncorr = e.pers_ncorr 
WHERE  a.sala_ccod = '274'
       AND a.dias_ccod = '4' 
       AND a.hora_ccod = '9' 
       AND b.peri_ccod = '240' 


select * from bloques_horarios a WHERE  a.sala_ccod = '167' AND a.dias_ccod = '2' AND a.hora_ccod = '5' 

select * from bloques_horarios a WHERE  a.sala_ccod = '274' AND a.dias_ccod = '4' AND a.hora_ccod = '9' 

update bloques_horarios set bloq_ftermino_modulo = '2015-11-27' where bloq_ccod = 87551

select * from BLOQUES_HORARIOS where bloq_ccod = 87551




select * from SALAS


-- -----------------------------------------------------------------------
select 
		b.sala_ccod,sala_ciso,tsal_tdesc,dias_ccod,hora_ccod,    	protic.detalle_sala_con_carrera(       	b.sala_ccod,a.dias_ccod,a.hora_ccod,       	convert(datetime,'27-07-2015',103),convert(datetime,'05-12-2015',103),d.peri_ccod) as detalle, count(distinct a.bloq_ccod) as usos 
	  	from 
			bloques_horarios a, salas b, tipos_sala c,secciones d, asignaturas e 
	  	where 
			a.sala_ccod =b.sala_ccod 
			and b.tsal_ccod=c.tsal_ccod 
			and cast(b.sala_ccod as varchar)='275'
			and hora_ccod is not null  
			and a.secc_ccod=d.secc_ccod and d.asig_ccod=e.asig_ccod and d.peri_ccod = case e.duas_ccod when 3 then '238' else '240' end 
			and a.bloq_finicio_modulo  
		between  
			convert(datetime,'27-07-2015',103)
		  and  
		    convert(datetime,'05-12-2015',103)
	  	group by  d.peri_ccod,b.sala_ccod,sala_ciso,tsal_tdesc,dias_ccod,hora_ccod 
    
   
select 
		a.bloq_ccod,b.sala_ccod,sala_ciso,tsal_tdesc,dias_ccod,hora_ccod,    	
			protic.detalle_sala_con_carrera(       	b.sala_ccod,a.dias_ccod,a.hora_ccod,       	convert(datetime,'27-07-2015',103),convert(datetime,'05-12-2015',103),d.peri_ccod) as detalle, count(distinct a.bloq_ccod) as usos 
	  	from 
			bloques_horarios a, salas b, tipos_sala c,secciones d, asignaturas e 
	  	where 
			a.sala_ccod =b.sala_ccod 
			and b.tsal_ccod=c.tsal_ccod 
			and cast(b.sala_ccod as varchar)='275'
			and hora_ccod is not null  
			and a.secc_ccod=d.secc_ccod and d.asig_ccod=e.asig_ccod and d.peri_ccod = case e.duas_ccod when 3 then '238' else '240' end 
			and a.bloq_finicio_modulo  
		between  
			convert(datetime,'27-07-2015',103)
		  and  
		    convert(datetime,'05-12-2015',103)
	  	group by  a.bloq_ccod,d.peri_ccod,b.sala_ccod,sala_ciso,tsal_tdesc,dias_ccod,hora_ccod 






select * from bloques_horarios where bloq_ccod = 84950
select * from bloques_horarios where bloq_ccod = 84951
select * from bloques_horarios where bloq_ccod = 84952
select * from bloques_horarios where bloq_ccod = 84953
select * from bloques_horarios where bloq_ccod = 84954
select * from bloques_horarios where bloq_ccod = 84955

select bloq_ccod, bloq_ftermino_modulo from bloques_horarios
where bloq_ccod in (
84950,
84951,
84952,
84953,
84954,
84955
)



begin TRANSACTION

update bloques_horarios set bloq_ftermino_modulo = '2015-11-13' where bloq_ccod = 84950
update bloques_horarios set bloq_ftermino_modulo = '2015-11-13' where bloq_ccod = 84951
update bloques_horarios set bloq_ftermino_modulo = '2015-11-13' where bloq_ccod = 84952
update bloques_horarios set bloq_ftermino_modulo = '2015-11-29' where bloq_ccod = 84953
update bloques_horarios set bloq_ftermino_modulo = '2015-11-29' where bloq_ccod = 84954
update bloques_horarios set bloq_ftermino_modulo = '2015-11-29' where bloq_ccod = 84955


COMMIT

-- ---------------------------------------------------------------







    
	 
	
	 






































