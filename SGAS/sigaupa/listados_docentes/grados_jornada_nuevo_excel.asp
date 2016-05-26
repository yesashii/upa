<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'Server.ScriptTimeOut = 10000
Response.AddHeader "Content-Disposition", "attachment;filename=grados_academicos.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

periodo = negocio.obtenerPeriodoAcademico("Postulacion")
ano_consulta = conexion.consultaUno("Select anos_ccod from periodos_Academicos where cast(peri_ccod as varchar)='"&periodo&"'")

'-----------------------------------------------------------------------
carr_ccod=request.QueryString("carr_ccod")
jorn_ccod=request.QueryString("jorn_ccod")
sede_ccod = request.QueryString("sede_ccod")  'negocio.obtenerSede

'----------------------------------------------------------------------- 
'------------------------------------------función para buscar la cantidad de docentes----------------------------------
Function Cantidad_docentes(sede,grado,tipo_jornada,carrera,jornada)
'response.Write("entre")
'-------------------------debemos buscar solo los dcentes pertenecientes a un solo grado, vale decir un doctor que tambien tiene un magister
'-----------------------------------------solo es considerado como doctor no como magister
'dependiendo del tipo de  jornada debemos buscar a los docentes cuyas horas esten dentro del criterio asignado.
if tipo_jornada = 1 then
    filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) >= 33"  
elseif tipo_jornada = 2 then
	filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) <= 32"  
elseif tipo_jornada = 3  then
    filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) <= 19"  
end if

'if sede = 2 then
'	filtro_sede= " in ('1','2')"
'else
	filtro_sede= " = '"&sede&"'"
'end if

if grado = 5 then

consulta_Cantidad = " select count(distinct c.pers_ncorr)   " & vbCrLf &_
			        "  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d, asignaturas f,periodos_academicos pea   " & vbCrLf &_
			        "  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
			        "  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3)  " & vbCrLf &_
			        "  and d.egra_ccod in (1,3) and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"' " & vbCrLf &_
			        "  and cast(a.jorn_ccod as varchar) ='"&jornada&"'"&vbCrLf &_
					"  and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					"  and  a.carr_ccod='"&carrera&"'"
			
Cantidad_docentes= conexion.consultaUno(consulta_cantidad)	

elseif grado = 4 then

consulta_Cantidad = "  select count(distinct c.pers_ncorr)  " & vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d, asignaturas f,periodos_academicos pea  " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8) and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					"  and d.egra_ccod=1 and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"' " & vbCrLf &_
			        "  and cast(a.jorn_ccod as varchar) ='"&jornada&"'"&vbCrLf &_
					"  and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					"  and  a.carr_ccod='"&carrera&"'"
			
Cantidad_docentes= conexion.consultaUno(consulta_cantidad)

elseif grado = 3 then

consulta_Cantidad = "  select count(distinct c.pers_ncorr)   " & vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,asignaturas f,periodos_academicos pea  " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 3 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=4 and r.egra_ccod=1)  " & vbCrLf &_
					"  and d.egra_ccod=1 and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"' " & vbCrLf &_
			        "  and cast(a.jorn_ccod as varchar) ='"&jornada&"'"&vbCrLf &_
					"  and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					"  and  a.carr_ccod='"&carrera&"'"
			
Cantidad_docentes= conexion.consultaUno(consulta_cantidad)	


elseif grado = 2 then

consulta_Cantidad = " select count(*)  " & vbCrLf &_
					"  from (  " & vbCrLf &_
					"  select distinct c.pers_ncorr  " & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d, asignaturas f,periodos_academicos pea  " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3)  " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)  " & vbCrLf &_
					" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )  " & vbCrLf &_
					" and a.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"' " & vbCrLf &_
			        " and cast(a.jorn_ccod as varchar) ='"&jornada&"'"&vbCrLf &_
					" and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					"  and  a.carr_ccod='"&carrera&"'" & vbCrLf &_
					" union " & vbCrLf &_
					" select distinct c.pers_ncorr   " & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,asignaturas f,periodos_academicos pea  " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
					" and d.grac_ccod = 2  and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
					"  and cast(pea.anos_ccod as varchar)='"&ano_consulta&"' " & vbCrLf &_
			        "  and cast(a.jorn_ccod as varchar) ='"&jornada&"'"&vbCrLf &_
					"  and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					"  and  a.carr_ccod='"&carrera&"')a"
			
Cantidad_docentes= conexion.consultaUno(consulta_cantidad)		

elseif grado = 1 then

consulta_Cantidad = " select count(*)  " & vbCrLf &_
					" from (  " & vbCrLf &_
					" select distinct c.pers_ncorr   " & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,asignaturas f,periodos_academicos pea  " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	  " & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
					" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 1 )  " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
					" and a.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"' " & vbCrLf &_
			        "  and cast(a.jorn_ccod as varchar) ='"&jornada&"'"&vbCrLf &_
					"  and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					"  and  a.carr_ccod='"&carrera&"'" & vbCrLf &_
					" union" & vbCrLf &_
					" select distinct c.pers_ncorr   " & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,asignaturas f,periodos_academicos pea  " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
					" and d.grac_ccod = 1 and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
					" cast(pea.anos_ccod as varchar)='"&ano_consulta&"' " & vbCrLf &_
			        "  and cast(a.jorn_ccod as varchar) ='"&jornada&"'"&vbCrLf &_
					"  and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					"  and  a.carr_ccod='"&carrera&"')a" & vbCrLf &_
			
Cantidad_docentes= conexion.consultaUno(consulta_cantidad)	

else
consulta_Cantidad_sin_grado =   " select count(*) " & vbCrLf &_
								" from ( " & vbCrLf &_
								" select distinct c.pers_ncorr  " & vbCrLf &_
								" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,asignaturas f,periodos_academicos pea " & vbCrLf &_
								" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod " & vbCrLf &_
								" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
								" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
								" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
								" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) )  " & vbCrLf &_
								" and a.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"' " & vbCrLf &_
								"  and cast(a.jorn_ccod as varchar) ='"&jornada&"'"&vbCrLf &_
								"  and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
								" "&filtro_horas& vbCrLf &_
								"  and  a.carr_ccod='"&carrera&"'" & vbCrLf &_
								" union" & vbCrLf &_
								" select distinct c.pers_ncorr   " & vbCrLf &_
								" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,asignaturas f,periodos_academicos pea " & vbCrLf &_
								" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.peri_ccod=pea.peri_ccod  " & vbCrLf &_
								" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
								" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
								" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2))  " & vbCrLf &_
								" and cast(pea.anos_ccod as varchar)='"&ano_consulta&"' " & vbCrLf &_
								" and cast(a.jorn_ccod as varchar) ='"&jornada&"'"&vbCrLf &_
								" and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
								" "&filtro_horas& vbCrLf &_
								" and  a.carr_ccod='"&carrera&"')a" 
					
     Cantidad_docentes = conexion.consultaUno(consulta_Cantidad_sin_grado)
end if

End Function

'------------------------------------------------------------------------------------------------------------------------------------
'-----------------------------------Funcion para buscar el total de horas de los docentes--------------------------------------------
'------------------------------------------función para buscar la cantidad de docentes----------------------------------
Function Cantidad_horas_docentes(sede,grado,tipo_jornada,carrera,jornada)
'-------------------------debemos buscar solo los dcentes pertenecientes a un solo grado, vale decir un doctor que tambien tiene un magister
'-----------------------------------------solo es considerado como doctor no como magister
'dependiendo del tipo de  jornada debemos buscar a los docentes cuyas horas esten dentro del criterio asignado.
if tipo_jornada = 1 then
    filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) >= 33"  
elseif tipo_jornada = 2 then
	filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) <= 32"  
elseif tipo_jornada = 3  then
    filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) <= 19"  
end if

'if sede = 2 then
'	filtro_sede= " in ('1','2')"
'else
	filtro_sede= " = '"&sede&"'"
'end if

if grado = 5 then

consulta_Cantidad = " select cast(isnull(sum(prof_nhoras),0) as numeric) from (select distinct c.pers_ncorr,a.sede_ccod,a.carr_ccod,a.jorn_ccod   " & vbCrLf &_
			        "  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d, asignaturas f,periodos_academicos pea   " & vbCrLf &_
			        "  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
			        "  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3)  " & vbCrLf &_
			        "  and d.egra_ccod in (1,3) and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"' " & vbCrLf &_
			        "  and cast(a.jorn_ccod as varchar) ='"&jornada&"'"&vbCrLf &_
					"  and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					"  and  a.carr_ccod='"&carrera&"'"&vbCrLf &_
					" )a, horas_docentes_carrera_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					" and hdc.sede_ccod= a.sede_ccod"& vbCrLf &_
					" and hdc.carr_ccod= a.carr_ccod"& vbCrLf &_
					" and hdc.jorn_ccod= a.jorn_ccod" 
					
Cantidad_horas_docentes= conexion.consultaUno(consulta_cantidad)					

elseif grado = 4 then

consulta_Cantidad = " select cast(isnull(sum(prof_nhoras),0) as numeric) from (select distinct c.pers_ncorr,a.sede_ccod,a.carr_ccod,a.jorn_ccod  " & vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d, asignaturas f,periodos_academicos pea  " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8) and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					"  and d.egra_ccod=1 and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"' " & vbCrLf &_
			        "  and cast(a.jorn_ccod as varchar) ='"&jornada&"'"&vbCrLf &_
					"  and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					"  and  a.carr_ccod='"&carrera&"'"&vbCrLf &_
					" )a, horas_docentes_carrera_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					" and hdc.sede_ccod= a.sede_ccod"& vbCrLf &_
					" and hdc.carr_ccod= a.carr_ccod"& vbCrLf &_
					" and hdc.jorn_ccod= a.jorn_ccod" 
					
Cantidad_horas_docentes= conexion.consultaUno(consulta_cantidad)				

elseif grado = 3 then

consulta_Cantidad = " select cast(isnull(sum(prof_nhoras),0) as numeric) from (select distinct c.pers_ncorr,a.sede_ccod,a.carr_ccod,a.jorn_ccod   " & vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,asignaturas f,periodos_academicos pea  " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 3 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=4 and r.egra_ccod=1)  " & vbCrLf &_
					"  and d.egra_ccod=1 and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"' " & vbCrLf &_
			        "  and cast(a.jorn_ccod as varchar) ='"&jornada&"'"&vbCrLf &_
					"  and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					"  and  a.carr_ccod='"&carrera&"'"&vbCrLf &_
					" )a, horas_docentes_carrera_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					" and hdc.sede_ccod= a.sede_ccod"& vbCrLf &_
					" and hdc.carr_ccod= a.carr_ccod"& vbCrLf &_
					" and hdc.jorn_ccod= a.jorn_ccod" 
'response.Write("<pre>"&consulta_Cantidad&"</pre>")					
Cantidad_horas_docentes= conexion.consultaUno(consulta_cantidad)		

elseif grado = 2 then

consulta_Cantidad = " select cast(isnull(sum(prof_nhoras),0) as numeric) from (select distinct c.pers_ncorr,a.sede_ccod,a.carr_ccod,a.jorn_ccod  " & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d, asignaturas f,periodos_academicos pea  " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3)  " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)  " & vbCrLf &_
					" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )  " & vbCrLf &_
					" and a.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"' " & vbCrLf &_
			        " and cast(a.jorn_ccod as varchar) ='"&jornada&"'"&vbCrLf &_
					" and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					"  and  a.carr_ccod='"&carrera&"'" & vbCrLf &_
					" union " & vbCrLf &_
					" select distinct c.pers_ncorr,a.sede_ccod,a.carr_ccod,a.jorn_ccod " & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,asignaturas f,periodos_academicos pea  " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
					" and d.grac_ccod = 2  and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
					"  and cast(pea.anos_ccod as varchar)='"&ano_consulta&"' " & vbCrLf &_
			        "  and cast(a.jorn_ccod as varchar) ='"&jornada&"'"&vbCrLf &_
					"  and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					"  and  a.carr_ccod='"&carrera&"'"&vbCrLf &_
					" )a, horas_docentes_carrera_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					" and hdc.sede_ccod= a.sede_ccod"& vbCrLf &_
					" and hdc.carr_ccod= a.carr_ccod"& vbCrLf &_
					" and hdc.jorn_ccod= a.jorn_ccod" 
					
Cantidad_horas_docentes= conexion.consultaUno(consulta_cantidad)					

elseif grado = 1 then

consulta_Cantidad = " select cast(isnull(sum(prof_nhoras),0) as numeric) from (select distinct c.pers_ncorr,a.sede_ccod,a.carr_ccod,a.jorn_ccod   " & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,asignaturas f,periodos_academicos pea  " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	  " & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
					" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 1 )  " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
					" and a.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"' " & vbCrLf &_
			        "  and cast(a.jorn_ccod as varchar) ='"&jornada&"'"&vbCrLf &_
					"  and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					"  and  a.carr_ccod='"&carrera&"'" & vbCrLf &_
					" union" & vbCrLf &_
					" select distinct c.pers_ncorr,a.sede_ccod,a.carr_ccod,a.jorn_ccod   " & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,asignaturas f,periodos_academicos pea  " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
					" and d.grac_ccod = 1 and tpro_ccod=1 and a.peri_ccod=pea.peri_ccod " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
					" cast(pea.anos_ccod as varchar)='"&ano_consulta&"' " & vbCrLf &_
			        "  and cast(a.jorn_ccod as varchar) ='"&jornada&"'"&vbCrLf &_
					"  and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					"  and  a.carr_ccod='"&carrera&"'"&vbCrLf &_
					" )a, horas_docentes_carrera_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					" and hdc.sede_ccod= a.sede_ccod"& vbCrLf &_
					" and hdc.carr_ccod= a.carr_ccod"& vbCrLf &_
					" and hdc.jorn_ccod= a.jorn_ccod" 
					
Cantidad_horas_docentes= conexion.consultaUno(consulta_cantidad)					


else
consulta_Cantidad_sin_grado = " select cast(isnull(sum(prof_nhoras),0) as numeric) from (select distinct c.pers_ncorr,a.sede_ccod,a.carr_ccod,a.jorn_ccod  " & vbCrLf &_
								" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,asignaturas f,periodos_academicos pea " & vbCrLf &_
								" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod " & vbCrLf &_
								" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
								" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
								" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
								" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) )  " & vbCrLf &_
								" and a.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&ano_consulta&"' " & vbCrLf &_
								"  and cast(a.jorn_ccod as varchar) ='"&jornada&"'"&vbCrLf &_
								"  and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
								" "&filtro_horas& vbCrLf &_
								"  and  a.carr_ccod='"&carrera&"'" & vbCrLf &_
								" union" & vbCrLf &_
								" select distinct c.pers_ncorr,a.sede_ccod,a.carr_ccod,a.jorn_ccod   " & vbCrLf &_
								" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,asignaturas f,periodos_academicos pea " & vbCrLf &_
								" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.peri_ccod=pea.peri_ccod  " & vbCrLf &_
								" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
								" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
								" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2))  " & vbCrLf &_
								" and cast(pea.anos_ccod as varchar)='"&ano_consulta&"' " & vbCrLf &_
								" and cast(a.jorn_ccod as varchar) ='"&jornada&"'"&vbCrLf &_
								" and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
								" "&filtro_horas& vbCrLf &_
								" and  a.carr_ccod='"&carrera&"' )a,horas_docentes_carrera_final hdc "& vbCrLf &_
								" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
								" and hdc.sede_ccod= a.sede_ccod"& vbCrLf &_
								" and hdc.carr_ccod= a.carr_ccod"& vbCrLf &_
								" and hdc.jorn_ccod= a.jorn_ccod" 
						
     Cantidad_horas_docentes = conexion.consultaUno(consulta_Cantidad_sin_grado)
end if
End Function
'------------------------------------------------------------------------------------------------------------------------------------
if carr_ccod<>"" and carr_ccod<>"-1" then
  nombre_carrera=conexion.consultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar)='"&carr_ccod&"'")
end if
if jorn_ccod<>"" and jorn_ccod<>"-1" then
  jorn_tdesc=conexion.consultaUno("select jorn_tdesc from jornadas where cast(jorn_ccod as varchar)='"&jorn_ccod&"'")
end if
fecha_01=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
nombre_sede=conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede_ccod&"'")
'------------------------------------------------------------------------------------

'----------------------------------------buscamos los valores-------------------------------------------------------------
'-----------Doctores--------------------------------------------------------------------
if not esVacio(sede_ccod) and not esVacio(carr_ccod) and not esvacio(jorn_ccod) then
	cant_doctor_c = Cantidad_docentes(sede_ccod,5,1,carr_ccod,jorn_ccod)
	horas_doctor_c = Cantidad_horas_docentes(sede_ccod,5,1,carr_ccod,jorn_ccod)
	cant_doctor_m = Cantidad_docentes(sede_ccod,5,2,carr_ccod,jorn_ccod)
	horas_doctor_m = Cantidad_horas_docentes(sede_ccod,5,2,carr_ccod,jorn_ccod)
	cant_doctor_h = Cantidad_docentes(sede_ccod,5,3,carr_ccod,jorn_ccod)
	horas_doctor_h = Cantidad_horas_docentes(sede_ccod,5,3,carr_ccod,jorn_ccod)
	total_cant_doctor = cint(cant_doctor_c) + cint(cant_doctor_m) + cint(cant_doctor_h)
	total_horas_doctor = cint(horas_doctor_c) + cint(horas_doctor_m) + cint(horas_doctor_h)
	'-----------Magister--------------------------------------------------------------------
	cant_magister_c = Cantidad_docentes(sede_ccod,4,1,carr_ccod,jorn_ccod)
	horas_magister_c = Cantidad_horas_docentes(sede_ccod,4,1,carr_ccod,jorn_ccod)
	cant_magister_m = Cantidad_docentes(sede_ccod,4,2,carr_ccod,jorn_ccod)
	horas_magister_m = Cantidad_horas_docentes(sede_ccod,4,2,carr_ccod,jorn_ccod)
	cant_magister_h = Cantidad_docentes(sede_ccod,4,3,carr_ccod,jorn_ccod)
	horas_magister_h = Cantidad_horas_docentes(sede_ccod,4,3,carr_ccod,jorn_ccod)
	total_cant_magister = cint(cant_magister_c) + cint(cant_magister_m) + cint(cant_magister_h)
	total_horas_magister = cint(horas_magister_c) + cint(horas_magister_m) + cint(horas_magister_h)
	'-----------Licenciados--------------------------------------------------------------------
	cant_licenciado_c = Cantidad_docentes(sede_ccod,3,1,carr_ccod,jorn_ccod)
	horas_licenciado_c = Cantidad_horas_docentes(sede_ccod,3,1,carr_ccod,jorn_ccod)
	cant_licenciado_m = Cantidad_docentes(sede_ccod,3,2,carr_ccod,jorn_ccod)
	horas_licenciado_m = Cantidad_horas_docentes(sede_ccod,3,2,carr_ccod,jorn_ccod)
	cant_licenciado_h = Cantidad_docentes(sede_ccod,3,3,carr_ccod,jorn_ccod)
	horas_licenciado_h = Cantidad_horas_docentes(sede_ccod,3,3,carr_ccod,jorn_ccod)
	total_cant_licenciado = cint(cant_licenciado_c) + cint(cant_licenciado_m) + cint(cant_licenciado_h)
	total_horas_licenciado = cint(horas_licenciado_c) + cint(horas_licenciado_m) + cint(horas_licenciado_h)
	'-----------Sin Grados--------------------------------------------------------------------
	cant_sin_c = Cantidad_docentes(sede_ccod,0,1,carr_ccod,jorn_ccod)
	horas_sin_c = Cantidad_horas_docentes(sede_ccod,0,1,carr_ccod,jorn_ccod)
	cant_sin_m = Cantidad_docentes(sede_ccod,0,2,carr_ccod,jorn_ccod)
	horas_sin_m = Cantidad_horas_docentes(sede_ccod,0,2,carr_ccod,jorn_ccod)
	cant_sin_h = Cantidad_docentes(sede_ccod,0,3,carr_ccod,jorn_ccod)
	horas_sin_h = Cantidad_horas_docentes(sede_ccod,0,3,carr_ccod,jorn_ccod)
	total_cant_sin = cint(cant_sin_c) + cint(cant_sin_m) + cint(cant_sin_h)
	total_horas_sin = cint(horas_sin_c) + cint(horas_sin_m) + cint(horas_sin_h)
	'---------------------totales----------------------------------------------------------------
	total_cantidad_c = cint(cant_doctor_c) + cint(cant_magister_c) + cint(cant_licenciado_c) + cint(cant_sin_c)
	total_horas_c = cint(horas_doctor_c) + cint(horas_magister_c) + cint(horas_licenciado_c) + cint(horas_sin_c)
   	total_cantidad_m = cint(cant_doctor_m) + cint(cant_magister_m) + cint(cant_licenciado_m) + cint(cant_sin_m)
	total_horas_m = cint(horas_doctor_m) + cint(horas_magister_m) + cint(horas_licenciado_m) + cint(horas_sin_m)
	total_cantidad_h = cint(cant_doctor_h) + cint(cant_magister_h) + cint(cant_licenciado_h) + cint(cant_sin_h)
	total_horas_h = cint(horas_doctor_h) + cint(horas_magister_h) + cint(horas_licenciado_h) + cint(horas_sin_h)
 
   	total_cantidad = cint(total_cantidad_c) + cint(total_cantidad_m) + cint(total_cantidad_h)
	total_horas = cint(total_horas_c) + cint(total_horas_m) + cint(total_horas_h)


	
	'-------------------------------------fin de la cosecha de valores--------------------------------------------------------	
end if
%>
<html>
<head>
<title>clasificacion por grado academico</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Clasificaci&oacute;n por grado acad&eacute;mico</font></div>
	  <div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Sede</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=nombre_sede %></td>
  </tr>
  <tr> 
    <td width="16%"><strong>Carrera</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=nombre_carrera %></td>
  </tr>
   <tr> 
    <td width="16%"><strong>Jornada</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=jorn_tdesc %></td>
  </tr>
  <tr> 
    <td><strong>Fecha</strong></td>
    <td colspan="3"><strong>:</strong> <%=fecha_01%></td>
  </tr>
  
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="10%"><div align="left"><strong>DOCENTES</strong></div></td>
    <td width="15%" colspan="2"><div align="center"><strong>DOCTOR</strong></div></td>
    <td width="15%" colspan="2"><div align="center"><strong>MAGISTER</strong></div></td>
	<td width="15%" colspan="2"><div align="center"><strong>LICENCIADOS</strong></div></td>
	<td width="10%" colspan="2"><div align="center"><strong>SIN GRADO</strong></div></td>
    <td width="10%" colspan="2"><div align="center"><strong>TOTAL</strong></div></td>
  </tr>
  <tr> 
    <td><div align="left"><strong>JORNADA</strong></div></td>
    <td><div align="center"><strong>N°</strong></div></td>
    <td><div align="center"><strong>HORAS</strong></div></td>
	<td><div align="center"><strong>N°</strong></div></td>
    <td><div align="center"><strong>HORAS</strong></div></td>
	<td><div align="center"><strong>N°</strong></div></td>
    <td><div align="center"><strong>HORAS</strong></div></td>
	<td><div align="center"><strong>N°</strong></div></td>
    <td><div align="center"><strong>HORAS</strong></div></td>
	<td><div align="center"><strong>N°</strong></div></td>
    <td><div align="center"><strong>HORAS</strong></div></td>
  </tr>
  <tr>
	<td><div align="center">COMPLETA</div></td>
    <td><div align="center"><%=Cant_doctor_c%></div></td>
    <td><div align="center"><%=horas_doctor_c%></div></td>
	<td><div align="center"><%=Cant_magister_c%></div></td>
    <td><div align="center"><%=horas_magister_c%></div></td>
	<td><div align="center"><%=Cant_licenciado_c%></div></td>
    <td><div align="center"><%=horas_licenciado_c%></div></td>
	<td><div align="center"><%=Cant_sin_c%></div></td>
    <td><div align="center"><%=horas_sin_c%></div></td>
	<td><div align="center"><%=total_cantidad_c%></div></td>
    <td><div align="center"><%=total_horas_c%></div></td>
  </tr>
  <tr>
	<td><div align="center">MEDIA</div></td>
    <td><div align="center"><%=Cant_doctor_m%></div></td>
    <td><div align="center"><%=horas_doctor_m%></div></td>
	<td><div align="center"><%=Cant_magister_m%></div></td>
    <td><div align="center"><%=horas_magister_m%></div></td>
	<td><div align="center"><%=Cant_licenciado_m%></div></td>
    <td><div align="center"><%=horas_licenciado_m%></div></td>
	<td><div align="center"><%=Cant_sin_m%></div></td>
    <td><div align="center"><%=horas_sin_m%></div></td>
	<td><div align="center"><%=total_cantidad_m%></div></td>
    <td><div align="center"><%=total_horas_m%></div></td>
  </tr>
  <tr>
	<td><div align="center">HORA</div></td>
    <td><div align="center"><%=Cant_doctor_h%></div></td>
    <td><div align="center"><%=horas_doctor_h%></div></td>
	<td><div align="center"><%=Cant_magister_h%></div></td>
    <td><div align="center"><%=horas_magister_h%></div></td>
	<td><div align="center"><%=Cant_licenciado_h%></div></td>
    <td><div align="center"><%=horas_licenciado_h%></div></td>
	<td><div align="center"><%=Cant_sin_h%></div></td>
    <td><div align="center"><%=horas_sin_h%></div></td>
	<td><div align="center"><%=total_cantidad_h%></div></td>
    <td><div align="center"><%=total_horas_h%></div></td>
  </tr>
  <tr> 
	<td><div align="right" class="Estilo2"><strong>TOTAL</strong></div></td>
	<td><div align="center" class="Estilo4"><strong><%=total_cant_doctor%></strong></div></td>
	<td><div align="center" class="Estilo4"><strong><%=total_horas_doctor%></strong></div></td>
	<td><div align="center" class="Estilo4"><strong><%=total_cant_magister%></strong></div></td>
	<td><div align="center" class="Estilo4"><strong><%=total_horas_magister%></strong></div></td>
	<td><div align="center" class="Estilo4"><strong><%=total_cant_licenciado%></strong></div></td>
	<td><div align="center" class="Estilo4"><strong><%=total_horas_licenciado%></strong></div></td>
	<td><div align="center" class="Estilo4"><strong><%=total_cant_sin%></strong></div></td>
	<td><div align="center" class="Estilo4"><strong><%=total_horas_sin%></strong></div></td>
	<td><div align="center" class="Estilo4"><strong><%=total_cantidad%></strong></div></td>
	<td><div align="center" class="Estilo4"><strong><%=total_horas%></strong></div></td>
  </tr>
</table>
<p><div align="right">* Horas Semanales, medidas de forma cronológica &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>