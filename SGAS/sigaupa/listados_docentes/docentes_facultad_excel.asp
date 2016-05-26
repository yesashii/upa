<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO: LISTADOS DOCENTES
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:25/04/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:Corregir código
'LINEA			:261 - 262
'*******************************************************************
'Response.AddHeader "Content-Disposition", "attachment;filename=docentes_facultad.xls"
'Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 250000
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'----------------------------------------------------------------------------------------------
'-----------a modo de unificar el listado debemos sacar el periodo y el año que se esta consultando---------
periodo = negocio.obtenerPeriodoAcademico("PLANIFICACION")
ano_consulta = conexion.consultaUno("Select anos_ccod from periodos_Academicos where cast(peri_ccod as varchar)='"&periodo&"'")

'response.Write(ano_consulta)
'-----------------------------------------------------------------------
facu_ccod=request.QueryString("facu_ccod")
carr_ccod=request.QueryString("carr_ccod")
'------------------------------------------------------------------------------------
facultad = conexion.consultauno("SELECT protic.initcap(facu_tdesc) FROM facultades WHERE cast(facu_ccod as varchar)= '" & facu_ccod & "'")
carrera = conexion.consultauno("SELECT carr_tdesc FROM carreras WHERE cast(carr_ccod as varchar)= '" & carr_ccod & "'")

if facu_ccod <> "" then
	filtro1 = " and cast(aa.facu_ccod as varchar)='"&facu_ccod&"'"
	nombre_facultad = facultad
else
	filtro1 = ""
	nombre_facultad = "Todas las Facultades"
end if
if carr_ccod <> "" then
	filtro2 = " and cast(dd.carr_ccod as varchar)='"&carr_ccod&"'"
	nombre_carrera = carrera
else
	filtro2 = ""
	nombre_carrera= "Todas las Carreras"
end if
fecha_01=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
set f_docentes = new CFormulario
 f_docentes.Carga_Parametros "docentes_facultad_carrera.xml", "f_docentes"
 f_docentes.Inicializar conexion

 consulta = "   select distinct  a.*, Doctor + Magister + Licenciado + Profesional + Tecnico + sin_grado_titulo as Totales,  " & vbCrLf &_
            "   horas_doctores + horas_Magister + horas_Licenciados + horas_Profesionales + horas_Tecnicos + horas_sin_grados_titulos as Total_horas  " & vbCrLf &_  
			" from (select aa.facu_tdesc as facultad,cc.carr_tdesc as carrera,   " & vbCrLf &_
			" (select count(distinct c.pers_ncorr)   " & vbCrLf &_
			"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,periodos_academicos pea   " & vbCrLf &_
			"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
			"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5  " & vbCrLf &_
			"  and d.egra_ccod in (1,3) and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod " & vbCrLf &_
			"  and  a.carr_ccod=dd.carr_ccod) as Doctor,   " & vbCrLf &_
			" -------------------------------------------------------------------------------------------------- " & vbCrLf &_
			"  (select isnull(sum(b1.horas),0)" & vbCrLf &_
			"   from (select distinct c.pers_ncorr   " & vbCrLf &_
			"		  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,periodos_academicos pea  " & vbCrLf &_
			"		  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
			"		  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5  " & vbCrLf &_
			"		  and d.egra_ccod in (1,3) and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod " & vbCrLf &_
			"		  and  a.carr_ccod=dd.carr_ccod) a1, horas_docentes_seccion_final b1,periodos_Academicos pea " & vbCrLf &_
			"	where a1.pers_ncorr=b1.pers_ncorr and b1.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod" & vbCrLf &_
			"	and b1.carr_ccod=dd.carr_ccod )as Horas_Doctores, " & vbCrLf &_
			" --------------------------------------------------------------------------------------------------" & vbCrLf &_
			
			" (select count(distinct c.pers_ncorr)  " & vbCrLf &_
			"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,periodos_academicos pea " & vbCrLf &_
			"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
			"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8)  " & vbCrLf &_
			"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
			"  and d.egra_ccod=1 and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod " & vbCrLf &_
			"  and  a.carr_ccod=dd.carr_ccod) as Magister,  " & vbCrLf &_
			" --------------------------------------------------------------------------------------------------" & vbCrLf &_
			"  (select isnull(sum(b1.horas),0)" & vbCrLf &_
			"   from (select distinct c.pers_ncorr " & vbCrLf &_
			"		  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,periodos_academicos pea  " & vbCrLf &_
			"		  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod " & vbCrLf &_
			"		  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8)  " & vbCrLf &_
			"		  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
			"		  and d.egra_ccod=1 and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod " & vbCrLf &_
			"		  and  a.carr_ccod=dd.carr_ccod) a1, horas_docentes_seccion_final b1,periodos_academicos pea " & vbCrLf &_
			"	where a1.pers_ncorr=b1.pers_ncorr and b1.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod" & vbCrLf &_
			"	and b1.carr_ccod=dd.carr_ccod )as Horas_Magister," & vbCrLf &_
			"  --------------------------------------------------------------------------------------------------" & vbCrLf &_
			
			" (select count(distinct c.pers_ncorr)   " & vbCrLf &_
			"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,periodos_academicos pea " & vbCrLf &_
			"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
			"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 3 " & vbCrLf &_
			"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
			"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=4 and r.egra_ccod=1)  " & vbCrLf &_
			"  and d.egra_ccod=1 and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod " & vbCrLf &_
			"  and  a.carr_ccod=dd.carr_ccod) as Licenciado,   " & vbCrLf &_
			" -------------------------------------------------------------------------------------------------- " & vbCrLf &_
			"  (select isnull(sum(b1.horas),0)" & vbCrLf &_
			"   from (select distinct c.pers_ncorr   " & vbCrLf &_
			"		  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,periodos_academicos pea " & vbCrLf &_
			"		  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
			"		  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 3 " & vbCrLf &_
			"		  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
			"		  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=4 and r.egra_ccod=1)  " & vbCrLf &_
			"		  and d.egra_ccod=1 and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod  " & vbCrLf &_
			"		  and  a.carr_ccod=dd.carr_ccod) a1, horas_docentes_seccion_final b1,periodos_academicos pea " & vbCrLf &_
			"	where a1.pers_ncorr=b1.pers_ncorr and b1.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod" & vbCrLf &_
			"	and b1.carr_ccod=dd.carr_ccod )as Horas_Licenciados," & vbCrLf &_
			"  --------------------------------------------------------------------------------------------------" & vbCrLf &_
			
			" (select count(*)  " & vbCrLf &_
			"  from (  " & vbCrLf &_
			"  select distinct c.pers_ncorr  " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,periodos_academicos pea " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod" & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)  " & vbCrLf &_
			" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )  " & vbCrLf &_
			" and  a.carr_ccod=dd.carr_ccod  " & vbCrLf &_
			" union all  " & vbCrLf &_
			" select distinct c.pers_ncorr   " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,periodos_academicos pea " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr " & vbCrLf &_
			" and d.grac_ccod = 2  and tpro_ccod=1  and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod" & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
			" and a.carr_ccod=dd.carr_ccod)a ) as Profesional,  " & vbCrLf &_
			" ------------------------------------------------------------------------------- " & vbCrLf &_
			"  (select isnull(sum(b1.horas),0)" & vbCrLf &_
			"   from (  " & vbCrLf &_
			"		  select distinct c.pers_ncorr  " & vbCrLf &_
			"		 from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,periodos_academicos pea " & vbCrLf &_
			"		 where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
			"		 and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 " & vbCrLf &_
			"		 and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
			"		 and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)  " & vbCrLf &_
			"		 and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )  " & vbCrLf &_
			"		 and  a.carr_ccod=dd.carr_ccod and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod  " & vbCrLf &_
			"		 union all  " & vbCrLf &_
			"		 select distinct c.pers_ncorr   " & vbCrLf &_
			"		 from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,periodos_academicos pea " & vbCrLf &_
			"		 where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
			"		 and c.pers_ncorr = d.pers_ncorr  " & vbCrLf &_
			"		 and d.grac_ccod = 2  and tpro_ccod=1  and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod" & vbCrLf &_
			"		 and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
			"		 and a.carr_ccod=dd.carr_ccod) a1, horas_docentes_seccion_final b1,periodos_academicos pea " & vbCrLf &_
			"	where a1.pers_ncorr=b1.pers_ncorr and b1.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod" & vbCrLf &_
			"	and b1.carr_ccod=dd.carr_ccod )as Horas_Profesionales,  " & vbCrLf &_
			" -----------------------------------------------------------------------------------------------------" & vbCrLf &_
			
			" (select count(*)  " & vbCrLf &_
			" from (  " & vbCrLf &_
			" select distinct c.pers_ncorr   " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,periodos_academicos pea " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	  " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod" & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
			" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 1 )  " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
			" and a.carr_ccod=dd.carr_ccod  " & vbCrLf &_
			" union all  " & vbCrLf &_
			" select distinct c.pers_ncorr   " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,periodos_academicos pea " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr " & vbCrLf &_
			" and d.grac_ccod = 1 and tpro_ccod=1  and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
			" and  a.carr_ccod=dd.carr_ccod)a " & vbCrLf &_
			" ) as tecnico,  " & vbCrLf &_
			" ------------------------------------------------------------------------------------------" & vbCrLf &_
			" (select isnull(sum(b1.horas),0)  " & vbCrLf &_
			" from (  " & vbCrLf &_
			" select distinct c.pers_ncorr   " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,periodos_academicos pea  " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	  " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1  " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
			" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 1 )  " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
			" and a.carr_ccod=dd.carr_ccod  and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod " & vbCrLf &_
			" union all  " & vbCrLf &_
			" select distinct c.pers_ncorr   " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,periodos_academicos pea " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr  " & vbCrLf &_
			" and d.grac_ccod = 1 and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
			" and  a.carr_ccod=dd.carr_ccod)a1, horas_docentes_seccion_final b1,periodos_academicos pea " & vbCrLf &_
			"	where a1.pers_ncorr=b1.pers_ncorr and b1.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod" & vbCrLf &_
			"	and b1.carr_ccod=dd.carr_ccod )as Horas_Tecnicos," & vbCrLf &_
			" ------------------------------------------------------------------------------------------" & vbCrLf &_
			
			" ( select count(*) " & vbCrLf &_
			" from ( " & vbCrLf &_
			" select distinct c.pers_ncorr  " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,periodos_academicos pea " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1  " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) )  " & vbCrLf &_
			" and a.carr_ccod=dd.carr_ccod	and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod " & vbCrLf &_
			" union all  " & vbCrLf &_
			" select distinct c.pers_ncorr   " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,periodos_academicos pea" & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2))  " & vbCrLf &_
			" and a.carr_ccod=dd.carr_ccod)a) as sin_grado_titulo, " & vbCrLf &_
			" ----------------------------------------------------------------------------------------------" & vbCrLf &_
			"( select isnull(sum(b1.horas),0) " & vbCrLf &_
			" from ( " & vbCrLf &_
			" select distinct c.pers_ncorr  " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,periodos_academicos pea " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1 " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) )  " & vbCrLf &_
			" and a.carr_ccod=dd.carr_ccod	and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod " & vbCrLf &_
			" union all  " & vbCrLf &_
			" select distinct c.pers_ncorr   " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,periodos_academicos pea" & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod " & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2))  " & vbCrLf &_
			" and a.carr_ccod=dd.carr_ccod)a1, horas_docentes_seccion_final b1,periodos_Academicos pea " & vbCrLf &_
			"	where a1.pers_ncorr=b1.pers_ncorr and b1.peri_ccod=pea.peri_ccod and pea.anos_ccod=pa.anos_ccod" & vbCrLf &_
			"	and b1.carr_ccod=dd.carr_ccod )as Horas_sin_grados_titulos" & vbCrLf &_
			" ----------------------------------------------------------------------------------------------" & vbCrLf &_
			
			" from facultades aa, areas_academicas bb, carreras cc, secciones dd, asignaturas ff, periodos_academicos pa " & vbCrLf &_
			" where aa.facu_ccod=bb.facu_ccod and bb.area_ccod =  cc.area_ccod " & vbCrLf &_
			" and cc.carr_ccod= dd.carr_ccod and dd.asig_ccod=ff.asig_ccod and ff.duas_ccod in (1,2,3)" & vbCrLf &_
			" and dd.peri_ccod = pa.peri_ccod" & vbCrLf &_
			" and cast(pa.anos_ccod as varchar)='"&ano_consulta&"' and cc.tcar_ccod = 1" & vbCrLf &_
			" "&filtro1&" "&filtro2&" ) a  " & vbCrLf &_
			" where (Doctor + Magister + Licenciado + Profesional + Tecnico + sin_grado_titulo) <> 0  " & vbCrLf &_
			" order by facultad,carrera " 
'response.Write("<pre>"&consulta&"</pre>")
'response.end()
f_docentes.Consultar consulta
%>
<html>
<head>
<title> Listado docentes</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Disposici&oacute;n de Docentes por Facultad</font></div>
	  <div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Facultad</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=nombre_facultad %></td>
  </tr>
  <tr> 
    <td width="16%"><strong>Carrera</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=nombre_carrera %></td>
  </tr>
  <tr> 
    <td width="16%"><strong>Año</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=ano_consulta %></td>
  </tr>
  <tr> 
    <td><strong>Fecha</strong></td>
    <td colspan="3"><strong>:</strong> <%=fecha_01%></td>
  </tr>
  
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="15%"><div align="left"><strong>Facultad</strong></div></td>
	<td width="15%"><div align="left"><strong>Carrera</strong></div></td>
    <td width="5%"><div align="center"><strong>Doctor</strong></div></td>
	<td width="5%"><div align="center"><strong>Horas Doctores</strong></div></td>
    <td width="5%"><div align="center"><strong>Magister</strong></div></td>
	<td width="5%"><div align="center"><strong>Horas Magister</strong></div></td>
	<td width="5%"><div align="center"><strong>Licenciado</strong></div></td>
	<td width="5%"><div align="center"><strong>Horas Licenciados</strong></div></td>
	<td width="5%"><div align="center"><strong>Profesional</strong></div></td>
	<td width="5%"><div align="center"><strong>Horas Profesionales</strong></div></td>
	<td width="5%"><div align="center"><strong>T&eacute;cnico</strong></div></td>
	<td width="5%"><div align="center"><strong>Horas T&eacute;cnicos</strong></div></td>
	<td width="5%"><div align="center"><strong>Sin T&iacute;tulos</strong></div></td>
	<td width="5%"><div align="center"><strong>Horas sin titulos</strong></div></td>
    <td width="5%"><div align="center"><strong>Nº Total</strong></div></td>
	<td width="5%"><div align="center"><strong>Total Horas</strong></div></td>
  </tr>
  <%  
    total_doctor=0
	total_magister=0
	total_licenciado=0
	total_profesional=0
	total_tecnico=0
	total_singrado=0
	total_general=0
	'---------------------------------------------------
	total_horas_doctores=0
	total_horas_magister=0
	total_horas_licenciados=0
	total_horas_profesionales=0
	total_horas_tecnicos=0
	total_horas_sin_grados_titulos=0
	total_horas_general=0
    while f_docentes.Siguiente %>
  <tr> 
    <td><div align="left"><%=f_docentes.ObtenerValor("facultad")%></div></td>
	<td><div align="left"><%=f_docentes.ObtenerValor("carrera")%></div></td>
    <td><div align="center"><%=f_docentes.ObtenerValor("doctor")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("horas_doctores")%></div></td>
    <td><div align="center"><%=f_docentes.ObtenerValor("magister")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("horas_magister")%></div></td>
    <td><div align="center"><%=f_docentes.ObtenerValor("licenciado")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("horas_licenciados")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("profesional")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("horas_profesionales")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("tecnico")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("horas_tecnicos")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("sin_grado_titulo")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("horas_sin_grados_titulos")%></div></td>
    <td><div align="center"><strong><%=f_docentes.ObtenerValor("totales")%></strong></div></td>
	<td><div align="center"><strong><%=f_docentes.ObtenerValor("total_horas")%></strong></div></td>
  </tr>
  <% total_doctor= total_doctor +  f_docentes.ObtenerValor("doctor")
     total_magister= total_magister +  f_docentes.ObtenerValor("magister")
	 total_licenciado= total_licenciado +  f_docentes.ObtenerValor("licenciado")
	 total_profesional= total_profesional +  f_docentes.ObtenerValor("profesional")
	 total_tecnico= total_tecnico +  f_docentes.ObtenerValor("tecnico")
	 total_singrado= total_singrado +  f_docentes.ObtenerValor("sin_grado_titulo")
	 total_general= total_general +  f_docentes.ObtenerValor("totales")
	 '--------------------------------------------------------------------------------------------
	 total_horas_doctores= clng(total_horas_doctores) +  clng(f_docentes.ObtenerValor("horas_doctores"))
     total_horas_magister= clng(total_horas_magister) +  clng(f_docentes.ObtenerValor("horas_magister"))
	 total_horas_licenciados= clng(total_horas_licenciados) +  clng(f_docentes.ObtenerValor("horas_licenciados"))
	 total_horas_profesionales= clng(total_horas_profesionales) +  clng(f_docentes.ObtenerValor("horas_profesionales"))
	 total_horas_tecnicos= clng(total_horas_tecnicos) +  clng(f_docentes.ObtenerValor("horas_tecnicos"))
	 total_horas_sin_grados_titulos= clng(total_horas_sin_grados_titulos) +  clng(f_docentes.ObtenerValor("horas_sin_grados_titulos"))
	 total_horas_general= clng(total_horas_general) +  clng(f_docentes.ObtenerValor("total_horas"))
	wend %>
  <tr> 
    <td colspan="2"><div align="right"><strong>Total docentes</strong></div></td>
    <td><div align="center"><strong><%=total_doctor%></strong></div></td>
	<td><div align="center"><strong></strong></div></td>
    <td><div align="center"><strong><%=total_magister%></strong></div></td>
	<td><div align="center"><strong></strong></div></td>
    <td><div align="center"><strong><%=total_licenciado%></strong></div></td>
	<td><div align="center"><strong></strong></div></td>
	<td><div align="center"><strong><%=total_profesional%></strong></div></td>
	<td><div align="center"><strong></strong></div></td>
	<td><div align="center"><strong><%=total_tecnico%></strong></div></td>
	<td><div align="center"><strong></strong></div></td>
	<td><div align="center"><strong><%=total_singrado%></strong></div></td>
	<td><div align="center"><strong></strong></div></td>
    <td><div align="center"><strong><%=total_general%></strong></div></td>
	<td><div align="center"><strong></strong></div></td>
  </tr>
  <tr> 
    <td colspan="2"><div align="right"><strong>Total Horas</strong></div></td>
    <td><div align="center"><strong></strong></div></td>
	<td><div align="center"><strong><%=total_horas_doctores%></strong></div></td>
    <td><div align="center"><strong></strong></div></td>
	<td><div align="center"><strong><%=total_horas_magister%></strong></div></td>
    <td><div align="center"><strong></strong></div></td>
	<td><div align="center"><strong><%=total_horas_licenciados%></strong></div></td>
	<td><div align="center"><strong></strong></div></td>
	<td><div align="center"><strong><%=total_horas_profesionales%></strong></div></td>
	<td><div align="center"><strong></strong></div></td>
	<td><div align="center"><strong><%=total_horas_tecnicos%></strong></div></td>
	<td><div align="center"><strong></strong></div></td>
	<td><div align="center"><strong><%=total_horas_sin_grados_titulos%></strong></div></td>
    <td><div align="center"><strong></strong></div></td>
	<td><div align="center"><strong><%=total_horas_general%></strong></div></td>
  </tr>
  <tr> 
    <td colspan="2"><div align="right"><strong>Total Sesiones</strong></div></td>
    <td><div align="center"><strong></strong></div></td>
	<td><div align="center"><strong><%=total_horas_doctores / 2%></strong></div></td>
    <td><div align="center"><strong></strong></div></td>
	<td><div align="center"><strong><%=total_horas_magister / 2%></strong></div></td>
    <td><div align="center"><strong></strong></div></td>
	<td><div align="center"><strong><%=total_horas_licenciados / 2%></strong></div></td>
	<td><div align="center"><strong></strong></div></td>
	<td><div align="center"><strong><%=total_horas_profesionales / 2%></strong></div></td>
	<td><div align="center"><strong></strong></div></td>
	<td><div align="center"><strong><%=total_horas_tecnicos / 2%></strong></div></td>
	<td><div align="center"><strong></strong></div></td>
	<td><div align="center"><strong><%=total_horas_sin_grados_titulos / 2%></strong></div></td>
    <td><div align="center"><strong></strong></div></td>
	<td><div align="center"><strong><%=total_horas_general / 2%></strong></div></td>
  </tr>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>