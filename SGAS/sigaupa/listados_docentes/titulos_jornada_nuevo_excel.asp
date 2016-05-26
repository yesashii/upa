<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'Server.ScriptTimeOut = 10000
Response.AddHeader "Content-Disposition", "attachment;filename=titulos_profesionales.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

periodo = negocio.obtenerPeriodoAcademico("Postulacion")

'-----------------------------------------------------------------------
carr_ccod=request.QueryString("carr_ccod")
jorn_ccod=request.QueryString("jorn_ccod")
sede_ccod = request.QueryString("sede_ccod")  'negocio.obtenerSede

'------------------------------------------función para buscar la cantidad de docentes----------------------------------
Function Cantidad_docentes(sede,grado,tipo_jornada,carrera,jornada)
'response.Write("entre")
'-------------------------debemos buscar solo los dcentes pertenecientes a un solo grado, vale decir un doctor que tambien tiene un magister
'-----------------------------------------solo es considerado como doctor no como magister
if grado=2 then 
	filtro_estricto = "  " & vbCrLf 	
elseif grado=1 then 
	filtro_estricto = "  and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (2)) " & vbCrLf 	
elseif grado =0 then
	filtro_estricto1 = "  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,5)) " & vbCrLf
	filtro_estricto2 = "  and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2)) " & vbCrLf 	
end if
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

if grado > 0 and grado <= 2 then

consulta_Cantidad = " select count(distinct c.pers_ncorr) as cantidad_doctores "& vbCrLf &_
					" from secciones a join bloques_horarios b "& vbCrLf &_
					"    on  a.secc_ccod = b.secc_ccod "& vbCrLf &_
					" join bloques_profesores c "& vbCrLf &_
				    "    on  b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
					" join curriculum_docente d "& vbCrLf &_
				    "    on  c.pers_ncorr = d.pers_ncorr "& vbCrLf &_
					" where cast(d.grac_ccod as varchar)='"&grado&"' and c.tpro_ccod=1"& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					" "&filtro_estricto& vbCrLf &_
					" and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" and cast(a.carr_ccod as varchar) ='"&carrera&"'"&vbCrLf &_
					" and cast(a.jorn_ccod as varchar) ='"&jornada&"'"&vbCrLf &_
					" and not exists (select 1 from grados_profesor gr where gr.pers_ncorr = c.pers_ncorr and gr.grac_ccod in (3,4,5)) "& vbCrLf
				    
Cantidad_docentes= conexion.consultaUno(consulta_cantidad)

else
						
consulta_Cantidad_sin_titulo = " select count(distinct c.pers_ncorr) as cantidad_doctores "& vbCrLf &_
					" from secciones a join bloques_horarios b "& vbCrLf &_
					"    on  a.secc_ccod = b.secc_ccod "& vbCrLf &_
					" join bloques_profesores c "& vbCrLf &_
				    "    on  b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
					" join curriculum_docente d "& vbCrLf &_
				    "    on  c.pers_ncorr = d.pers_ncorr "& vbCrLf &_
					" where not exists (select 1 from grados_profesor gr where gr.pers_ncorr = c.pers_ncorr) and c.tpro_ccod=1"& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					" "&filtro_estricto2& vbCrLf &_
					" and cast(a.sede_ccod as varchar)"&filtro_sede& vbCrLf &_
					" and cast(a.carr_ccod as varchar)='"&carrera&"'"&vbCrLf &_
					" and cast(a.jorn_ccod as varchar)= '"&jornada&"'"&vbCrLf


     Cantidad_docentes = cint(conexion.consultaUno(consulta_Cantidad_sin_titulo))
end if

End Function

'------------------------------------------------------------------------------------------------------------------------------------
'-----------------------------------Funcion para buscar el total de horas de los docentes--------------------------------------------
'------------------------------------------función para buscar la cantidad de docentes----------------------------------
Function Cantidad_horas_docentes(sede,grado,tipo_jornada,carrera,jornada)
'-------------------------debemos buscar solo los dcentes pertenecientes a un solo grado, vale decir un doctor que tambien tiene un magister
'-----------------------------------------solo es considerado como doctor no como magister
if grado=2 then 
	filtro_estricto = "  " & vbCrLf 	
elseif grado=1 then 
	filtro_estricto = "  and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (2)) " & vbCrLf 	
elseif grado =0 then
	filtro_estricto1 = "  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,5)) " & vbCrLf
	filtro_estricto2 = "  and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2)) " & vbCrLf 	
end if
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

if grado > 0 and grado <= 2 then

consulta_Cantidad = " select cast(isnull(sum(prof_nhoras),0) as numeric) from (select distinct c.pers_ncorr,a.sede_ccod,a.carr_ccod,a.jorn_ccod "& vbCrLf &_
					" from secciones a join bloques_horarios b "& vbCrLf &_
					"    on  a.secc_ccod = b.secc_ccod "& vbCrLf &_
					" join bloques_profesores c "& vbCrLf &_
				    "    on  b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
					" join curriculum_docente d "& vbCrLf &_
				    "    on  c.pers_ncorr = d.pers_ncorr "& vbCrLf &_
					" join personas e "& vbCrLf &_
				    "    on c.pers_ncorr = e.pers_ncorr    "& vbCrLf &_
					" where cast(d.grac_ccod as varchar)='"&grado&"' "& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					" "&filtro_estricto& vbCrLf &_
					" and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" and cast(a.carr_ccod as varchar) ='"&carrera&"' and c.tpro_ccod=1"&vbCrLf &_
					" and cast(a.jorn_ccod as varchar) ='"&jornada&"'"&vbCrLf &_
					" and not exists (select 1 from grados_profesor gr where gr.pers_ncorr = c.pers_ncorr and gr.grac_ccod in (3,4,5)) "& vbCrLf &_
				    " )a,horas_docentes_carrera_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					" and hdc.sede_ccod= a.sede_ccod" & vbCrLf &_
					" and hdc.carr_ccod= a.carr_ccod" & vbCrLf &_
					" and hdc.jorn_ccod= a.jorn_ccod" 
Cantidad_horas_docentes= conexion.consultaUno(consulta_cantidad)

else
						
consulta_Cantidad_sin_titulo = " select cast(isnull(sum(prof_nhoras),0) as numeric) from (select distinct c.pers_ncorr,a.sede_ccod,a.carr_ccod,a.jorn_ccod "& vbCrLf &_
					" from secciones a join bloques_horarios b "& vbCrLf &_
					"    on  a.secc_ccod = b.secc_ccod "& vbCrLf &_
					" join bloques_profesores c "& vbCrLf &_
				    "    on  b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
					" join curriculum_docente d "& vbCrLf &_
				    "    on  c.pers_ncorr = d.pers_ncorr "& vbCrLf &_
					" join personas e "& vbCrLf &_
				    "    on c.pers_ncorr = e.pers_ncorr    "& vbCrLf &_
					" where not exists (select 1 from grados_profesor gr where gr.pers_ncorr = c.pers_ncorr) "& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					" "&filtro_estricto2& vbCrLf &_
					" and cast(a.sede_ccod as varchar)"&filtro_sede& vbCrLf &_
					" and cast(a.carr_ccod as varchar)='"&carrera&"'" &vbCrLf &_
					" and cast(a.jorn_ccod as varchar)='"&jornada&"' and c.tpro_ccod=1" &vbCrLf &_
					" )a,horas_docentes_carrera_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					" and hdc.sede_ccod= a.sede_ccod" & vbCrLf &_
					" and hdc.carr_ccod= a.carr_ccod" & vbCrLf &_
					" and hdc.jorn_ccod= a.jorn_ccod" 		

     Cantidad_horas_docentes = cint(conexion.consultaUno(consulta_Cantidad_sin_titulo))
end if
End Function
'------------------------------------------------------------------------------------------------------------------------------------
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
'-----------Profesionales--------------------------------------------------------------------
if not esVacio(sede_ccod) and not esVacio(carr_ccod) and not esvacio(jorn_ccod) then
	cant_profesional_c = Cantidad_docentes(sede_ccod,2,1,carr_ccod,jorn_ccod)
	horas_profesional_c = Cantidad_horas_docentes(sede_ccod,2,1,carr_ccod,jorn_ccod)
	cant_profesional_m = Cantidad_docentes(sede_ccod,2,2,carr_ccod,jorn_ccod)
	horas_profesional_m = Cantidad_horas_docentes(sede_ccod,2,2,carr_ccod,jorn_ccod)
	cant_profesional_h = Cantidad_docentes(sede_ccod,2,3,carr_ccod,jorn_ccod)
	horas_profesional_h = Cantidad_horas_docentes(sede_ccod,2,3,carr_ccod,jorn_ccod)
	total_cant_profesional = cint(cant_profesional_c) + cint(cant_profesional_m) + cint(cant_profesional_h)
	total_horas_profesional = cint(horas_profesional_c) + cint(horas_profesional_m) + cint(horas_profesional_h)
	'-----------Tecnico--------------------------------------------------------------------
	cant_tecnico_c = Cantidad_docentes(sede_ccod,1,1,carr_ccod,jorn_ccod)
	horas_tecnico_c = Cantidad_horas_docentes(sede_ccod,1,1,carr_ccod,jorn_ccod)
	cant_tecnico_m = Cantidad_docentes(sede_ccod,1,2,carr_ccod,jorn_ccod)
	horas_tecnico_m = Cantidad_horas_docentes(sede_ccod,1,2,carr_ccod,jorn_ccod)
	cant_tecnico_h = Cantidad_docentes(sede_ccod,1,3,carr_ccod,jorn_ccod)
	horas_tecnico_h = Cantidad_horas_docentes(sede_ccod,1,3,carr_ccod,jorn_ccod)
	total_cant_tecnico = cint(cant_tecnico_c) + cint(cant_tecnico_m) + cint(cant_tecnico_h)
	total_horas_tecnico = cint(horas_tecnico_c) + cint(horas_tecnico_m) + cint(horas_tecnico_h)
	'-----------Sin titulos--------------------------------------------------------------------
	cant_sin_c = Cantidad_docentes(sede_ccod,0,1,carr_ccod,jorn_ccod)
	horas_sin_c = Cantidad_horas_docentes(sede_ccod,0,1,carr_ccod,jorn_ccod)
	cant_sin_m = Cantidad_docentes(sede_ccod,0,2,carr_ccod,jorn_ccod)
	horas_sin_m = Cantidad_horas_docentes(sede_ccod,0,2,carr_ccod,jorn_ccod)
	cant_sin_h = Cantidad_docentes(sede_ccod,0,3,carr_ccod,jorn_ccod)
	horas_sin_h = Cantidad_horas_docentes(sede_ccod,0,3,carr_ccod,jorn_ccod)
	total_cant_sin = cint(cant_sin_c) + cint(cant_sin_m) + cint(cant_sin_h)
	total_horas_sin = cint(horas_sin_c) + cint(horas_sin_m) + cint(horas_sin_h)
	'---------------------totales----------------------------------------------------------------
	total_cantidad_c = cint(cant_profesional_c) + cint(cant_tecnico_c)  + cint(cant_sin_c)
	total_horas_c = cint(horas_profesional_c) + cint(horas_tecnico_c) + cint(horas_sin_c)
   	total_cantidad_m = cint(cant_profesional_m) + cint(cant_tecnico_m) + cint(cant_sin_m)
	total_horas_m = cint(horas_profesional_m) + cint(horas_tecnico_m)  + cint(horas_sin_m)
	total_cantidad_h = cint(cant_profesional_h) + cint(cant_tecnico_h) + cint(cant_sin_h)
	total_horas_h = cint(horas_profesional_h) + cint(horas_tecnico_h)  + cint(horas_sin_h)
 
   	total_cantidad = cint(total_cantidad_c) + cint(total_cantidad_m) + cint(total_cantidad_h)
	total_horas = cint(total_horas_c) + cint(total_horas_m) + cint(total_horas_h)

	'-------------------------------------fin de la cosecha de valores--------------------------------------------------------	
end if
%>
<html>
<head>
<title>clasificacion por título profesional</title>
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
    <td width="15%" colspan="2"><div align="center"><strong>PROFESIONALES</strong></div></td>
    <td width="15%" colspan="2"><div align="center"><strong>TECNICOS</strong></div></td>
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
  </tr>
  <tr>
	<td><div align="center">COMPLETA</div></td>
    <td><div align="center"><%=Cant_profesional_c%></div></td>
    <td><div align="center"><%=horas_profesional_c%></div></td>
	<td><div align="center"><%=Cant_tecnico_c%></div></td>
    <td><div align="center"><%=horas_tecnico_c%></div></td>
	<td><div align="center"><%=Cant_sin_c%></div></td>
    <td><div align="center"><%=horas_sin_c%></div></td>
	<td><div align="center"><%=total_cantidad_c%></div></td>
    <td><div align="center"><%=total_horas_c%></div></td>
  </tr>
  <tr>
	<td><div align="center">MEDIA</div></td>
    <td><div align="center"><%=Cant_profesional_m%></div></td>
    <td><div align="center"><%=horas_profesional_m%></div></td>
	<td><div align="center"><%=Cant_tecnico_m%></div></td>
    <td><div align="center"><%=horas_tecnico_m%></div></td>
	<td><div align="center"><%=Cant_sin_m%></div></td>
    <td><div align="center"><%=horas_sin_m%></div></td>
	<td><div align="center"><%=total_cantidad_m%></div></td>
    <td><div align="center"><%=total_horas_m%></div></td>
  </tr>
  <tr>
	<td><div align="center">HORA</div></td>
    <td><div align="center"><%=Cant_profesional_h%></div></td>
    <td><div align="center"><%=horas_profesional_h%></div></td>
	<td><div align="center"><%=Cant_tecnico_h%></div></td>
    <td><div align="center"><%=horas_tecnico_h%></div></td>
	<td><div align="center"><%=Cant_sin_h%></div></td>
    <td><div align="center"><%=horas_sin_h%></div></td>
	<td><div align="center"><%=total_cantidad_h%></div></td>
    <td><div align="center"><%=total_horas_h%></div></td>
  </tr>
  <tr> 
	<td><div align="right" class="Estilo2"><strong>TOTAL</strong></div></td>
	<td><div align="center" class="Estilo4"><strong><%=total_cant_profesional%></strong></div></td>
	<td><div align="center" class="Estilo4"><strong><%=total_horas_profesional%></strong></div></td>
	<td><div align="center" class="Estilo4"><strong><%=total_cant_tecnico%></strong></div></td>
	<td><div align="center" class="Estilo4"><strong><%=total_horas_tecnico%></strong></div></td>
	<td><div align="center" class="Estilo4"><strong><%=total_cant_sin%></strong></div></td>
	<td><div align="center" class="Estilo4"><strong><%=total_horas_sin%></strong></div></td>
	<td><div align="center" class="Estilo4"><strong><%=total_cantidad%></strong></div></td>
	<td><div align="center" class="Estilo4"><strong><%=total_horas%></strong></div></td>
  </tr>
</table>
<div align="right">* Horas semanales, medidas de forma cronológica &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>