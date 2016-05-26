<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=encuesta_desarrollo.xls"
Response.ContentType = "application/vnd.ms-excel"
'Server.ScriptTimeOut = 150000
'---------------------------------------------------------------------------------------------------
carr_ccod = request.QueryString("carr_ccod")
facu_ccod = request.QueryString("facu_ccod")

if facu_ccod <> "" then
	carr_ccod=""
end if	

set pagina = new CPagina
pagina.Titulo = "Listado de alumnos encuesta desarrollo" 

set conexion = new cConexion
conexion.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario = negocio.obtenerUsuario

c_autorizado = " select case count(*) when 0 then 'N' else 'S' end from personas a, sis_roles_usuarios b "&_
			   " where cast(a.pers_nrut as varchar)='"&usuario&"' and a.pers_ncorr=b.pers_ncorr "&_
               " and b.srol_ncorr='107'"

autorizado = conexion.consultaUno(c_autorizado)			

if carr_ccod <> "" then
	carr_tdesc = conexion.consultaUno("select carr_tdesc from carreras where carr_ccod='"&carr_ccod&"'")
else
	carr_tdesc = "Todas las Carreras"
end if

if facu_ccod <> "" then
	facu_tdesc = conexion.consultaUno("select facu_tdesc from facultades where facu_ccod='"&facu_ccod&"'")
else
	facu_tdesc = "Sin considerar facultad"
end if

fecha_01 = conexion.consultaUno("select protic.trunc(getDate())")
'---------------------------------------------------------------------------------------------------
set f_lista = new CFormulario
f_lista.Carga_Parametros "tabla_vacia.xml", "tabla"
f_lista.Inicializar conexion
 consulta = " select distinct cast(pers_nrut as varchar)+'-'+pers_xdv as rut, pers_tape_paterno + ' ' + pers_tape_materno + ' ' + pers_tnombre as nombre, "& vbCrLf &_
			" c.carr_tdesc as carrera, motivacion as motivacion, descripcion as descripcion,comparacion as comparacion, "& vbCrLf &_
			" clasificacion as clasificacion,definicion as definicion,argumentacion as argumentacion, "& vbCrLf &_
			" autoevaluacion as autoevaluacion, autovaloracion as autovaloracion, "& vbCrLf &_
			" cast(((descripcion + comparacion + clasificacion + definicion + argumentacion) / 5) as numeric(4,2)) as prom_habilidades, "& vbCrLf &_
			" suma_positivos, suma_negativos, (suma_positivos - (suma_negativos * -1) ) / suma_positivos  as sad_individual "& vbCrLf &_
			" from respuestas_encuesta_desarrollo a, personas b,carreras c "& vbCrLf &_
			" where a.pers_ncorr = b.pers_ncorr       "& vbCrLf &_
			" and a.carr_ccod=c.carr_ccod "
			
			if carr_ccod <> "" then 
				consulta = consulta & " and c.carr_ccod='"&carr_ccod&"'"
			end if
			
			
			if facu_ccod <> "" then 
				consulta = consulta & "  and exists (select 1 from areas_academicas aa where aa.area_ccod=c.area_ccod and cast(aa.facu_ccod as varchar)='"&facu_ccod&"')"
			end if
			
			if autorizado = "N" then 
				consulta = consulta &  "  and c.carr_ccod in ( select distinct carr_ccod  "& vbCrLf &_
									   "                       from personas aa, sis_especialidades_usuario ab, especialidades ac "& vbCrLf &_
									   "  					   where cast(aa.pers_nrut as varchar)='"&usuario&"' "& vbCrLf &_
									   "					   and aa.pers_ncorr=ab.pers_ncorr and ab.espe_ccod=ac.espe_ccod) "
			end if					   
'response.write("<pre>"&consulta&"</pre>")
f_lista.Consultar consulta & " order by carrera, nombre"
	
'response.Write("<pre>"&sql_detalles_mate&"</pre>")
'response.End()

if facu_ccod <> "" then
	msj_total="SAD Facultad"
end if	
if carr_ccod <> "" then
	msj_total="SAD Carrera"
end if	

if facu_ccod = "" and carr_ccod="" then
	msj_total="SAD Universidad"
end if	

'------------------------------------------------------------------------------
%>
<html>
<head>
<title><%=pagina.Titulo%></title>  
<!--<meta http-equiv="Content-Type" content="text/html;">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">-->

</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
<tr>
	<td colspan="2" align="center"><font size="4"><strong>Listado alumnos de encuesta Desarrollo</strong></font></td>
</tr>
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
<tr>
	<td colspan="2" align="left"><strong>Facultad : </strong><%=facu_tdesc%></td>
</tr>
<tr>
	<td colspan="2" align="left"><strong>Carrera : </strong><%=carr_tdesc%></td>
</tr>
<tr>
	<td colspan="2" align="left"><strong>Fecha Actual : </strong><%=fecha_01%></td>
</tr>
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
<tr>
	<td colspan="2" align="center"><table width="75%" border="1">
									  <tr> 
										<td bgcolor="#FFFFCC"><div align="center"><strong>N°</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>RUT</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>NOMBRE</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>CARRERA</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>MOTIVACIÓN</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>DESCRIPCIÓN</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>COMPARACIÓN</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>CLASIFICACIÓN</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>DEFINICIÓN</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>ARGUMENTACIÓN</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>AUTOEVALUACIÓN</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>AUTOVALORACIÓN</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>PROM. HABILIDADES</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>SUMA POSITIVOS</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>SUMA NEGATIVOS</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>SAD INDIVIDUAL</strong></div></td>
									  </tr>
									  <% fila = 1 
									     motivacion_p = 0
										 motivacion_n = 0
										 descripcion_p = 0
										 descripcion_n = 0
										 comparacion_p = 0
										 comparacion_n = 0
										 clasificacion_p = 0
										 clasificacion_n = 0
										 definicion_p = 0
										 definicion_n = 0
										 argumentacion_p = 0
										 argumentacion_n = 0
										 autoevaluacion_p =0
										 autoevaluacion_n = 0
										 autovaloracion_p = 0
										 autovaloracion_n = 0
										 prom_habiliadades_p = 0.0
										 prom_habiliadades_n = 0.0
										 total_sad = 0.0
										 contador = 0
									 while f_lista.Siguiente 
									     contador = contador + 1%>
									  <tr> 
										<td><div align="center"><%=fila%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("rut")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("nombre")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("carrera")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("motivacion")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("descripcion")%></div></td>	
										<td><div align="center"><%=f_lista.ObtenerValor("comparacion")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("clasificacion")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("definicion")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("argumentacion")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("autoevaluacion")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("autovaloracion")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("prom_habilidades")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("suma_positivos")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("suma_negativos")%></div></td>
										<td bgcolor="#CCFFCC"><div align="center"><%=formatnumber(cdbl(f_lista.ObtenerValor("sad_individual")),2,-1,0,0)%></div></td>
									  </tr>
									  <%fila= fila + 1 
									     total_sad = total_sad + cdbl(f_lista.ObtenerValor("sad_individual"))
									     if cint(f_lista.ObtenerValor("motivacion")) > 0 then 
										       motivacion_p = motivacion_p + cint(f_lista.ObtenerValor("motivacion"))
									     else
										 	   motivacion_n = motivacion_n + cint(f_lista.ObtenerValor("motivacion")) 		
									     end if
										 
										 if cint(f_lista.ObtenerValor("descripcion")) > 0 then 
										       descripcion_p = descripcion_p + cint(f_lista.ObtenerValor("descripcion"))
									     else
										 	   descripcion_n = descripcion_n + cint(f_lista.ObtenerValor("descripcion")) 		
									     end if
										 
										 if cint(f_lista.ObtenerValor("comparacion")) > 0 then 
										       comparacion_p = comparacion_p + cint(f_lista.ObtenerValor("comparacion"))
									     else
										 	   comparacion_n = comparacion_n + cint(f_lista.ObtenerValor("comparacion")) 		
									     end if
										 
										 if cint(f_lista.ObtenerValor("clasificacion")) > 0 then 
										       clasificacion_p = clasificacion_p + cint(f_lista.ObtenerValor("clasificacion"))
									     else
										 	   clasificacion_n = clasificacion_n + cint(f_lista.ObtenerValor("clasificacion")) 		
									     end if
										 
										 if cint(f_lista.ObtenerValor("definicion")) > 0 then 
										       definicion_p = definicion_p + cint(f_lista.ObtenerValor("definicion"))
									     else
										 	   definicion_n = definicion_n + cint(f_lista.ObtenerValor("definicion")) 		
									     end if
										 
										 if cint(f_lista.ObtenerValor("argumentacion")) > 0 then 
										       argumentacion_p = argumentacion_p + cint(f_lista.ObtenerValor("argumentacion"))
									     else
										 	   argumentacion_n = argumentacion_n + cint(f_lista.ObtenerValor("argumentacion")) 		
									     end if
										 
										 if cint(f_lista.ObtenerValor("autoevaluacion")) > 0 then 
										       autoevaluacion_p = autoevaluacion_p + cint(f_lista.ObtenerValor("autoevaluacion"))
									     else
										 	   autoevaluacion_n = autoevaluacion_n + cint(f_lista.ObtenerValor("autoevaluacion")) 		
									     end if
										 
										 if cint(f_lista.ObtenerValor("autovaloracion")) > 0 then 
										      autovaloracion_p = autovaloracion_p + cint(f_lista.ObtenerValor("autovaloracion"))
									     else
										 	  autovaloracion_n = autovaloracion_n + cint(f_lista.ObtenerValor("autovaloracion")) 		
									     end if
										 
										 if cdbl(f_lista.ObtenerValor("prom_habilidades")) > cdbl(0.0) then 
										      prom_habilidades_p = cdbl(prom_habilidades_p) + cdbl(f_lista.ObtenerValor("prom_habilidades"))
									     else
										 	  prom_habilidades_n = cdbl(prom_habilidades_n) + cdbl(f_lista.ObtenerValor("prom_habilidades"))
									     end if
									wend 
									    
										if motivacion_p > 0 then
									    	sad_motivacion = (motivacion_p - (motivacion_n * -1 )) / motivacion_p
										else
										    sad_motivacion = 0
										end if
										if descripcion_p > 0 then
											sad_descripcion = (descripcion_p - (descripcion_n * -1)) / descripcion_p
										else
											sad_descripcion = 0
										end if	
										if comparacion_p > 0 then
											sad_comparacion = (comparacion_p - (comparacion_n * -1)) / comparacion_p
										else
											sad_comparacion = 0
										end if
										if clasificacion_p > 0 then
											sad_clasificacion = (clasificacion_p - (clasificacion_n * -1)) / clasificacion_p
										else
											sad_clasificacion = 0
										end if
										if definicion_p > 0 then
											sad_definicion = (definicion_p - (definicion_n * -1)) / definicion_p
										else
											sad_definicion = 0
										end if	
										if argumentacion_p > 0 then  
											sad_argumentacion = (argumentacion_p - (argumentacion_n * -1)) / argumentacion_p
										else
											sad_argumentacion = 0
										end if
										if autoevaluacion_p > 0 then
											sad_autoevaluacion = (autoevaluacion_p - (autoevaluacion_n * -1)) / autoevaluacion_p
										else
										    sad_autoevaluacion = 0
										end if
										if autovaloracion_p > 0 then	
											sad_autovaloracion = (autovaloracion_p - (autovaloracion_n * -1)) / autovaloracion_p
										else
											sad_autovaloracion = 0
										end if
										if prom_habilidades_p > cdbl(0.0)	then	
											sad_prom_habilidades = (sad_descripcion + sad_comparacion + sad_clasificacion + sad_definicion + sad_argumentacion ) / 5
										else
											sad_prom_habilidades = 0				
										end if
										%>
										<tr> 
										<td><div align="center">&nbsp;</div></td>
										<td><div align="left">&nbsp;</div></td>
										<td><div align="left">&nbsp;</div></td>
										<td><div align="left"><strong>POSITIVOS</strong></div></td>
										<td><div align="center"><%=motivacion_p%></div></td>
										<td><div align="center"><%=descripcion_p%></div></td>	
										<td><div align="center"><%=comparacion_p%></div></td>
										<td><div align="center"><%=clasificacion_p%></div></td>
										<td><div align="center"><%=definicion_p%></div></td>
										<td><div align="center"><%=argumentacion_p%></div></td>
										<td><div align="center"><%=autoevaluacion_p%></div></td>
										<td><div align="center"><%=autovaloracion_p%></div></td>
										<td><div align="center"><%=prom_habilidades_p%></div></td>
										<td><div align="center">&nbsp;</div></td>
										<td><div align="center">&nbsp;</div></td>
										<td><div align="center">&nbsp;</div></td>
									  </tr>
									  <tr> 
										<td><div align="center">&nbsp;</div></td>
										<td><div align="left">&nbsp;</div></td>
										<td><div align="left">&nbsp;</div></td>
										<td><div align="left"><strong>NEGATIVOS</strong></div></td>
										<td><div align="center"><%=motivacion_n%></div></td>
										<td><div align="center"><%=descripcion_n%></div></td>	
										<td><div align="center"><%=comparacion_n%></div></td>
										<td><div align="center"><%=clasificacion_n%></div></td>
										<td><div align="center"><%=definicion_n%></div></td>
										<td><div align="center"><%=argumentacion_n%></div></td>
										<td><div align="center"><%=autoevaluacion_n%></div></td>
										<td><div align="center"><%=autovaloracion_n%></div></td>
										<td><div align="center"><%=prom_habilidades_n%></div></td>
										<td><div align="center">&nbsp;</div></td>
										<td><div align="center">&nbsp;</div></td>
										<td><div align="center">&nbsp;</div></td>
									  </tr>
									  <tr> 
										<td><div align="center">&nbsp;</div></td>
										<td><div align="left">&nbsp;</div></td>
										<td><div align="left">&nbsp;</div></td>
										<td><div align="left">&nbsp;</div></td>
										<td bgcolor="#CCFFCC"><div align="center"><%=formatnumber(cdbl(sad_motivacion),2,-1,0,0)%></div></td>
										<td bgcolor="#CCFFCC"><div align="center"><%=formatnumber(cdbl(sad_descripcion),2,-1,0,0)%></div></td>	
										<td bgcolor="#CCFFCC"><div align="center"><%=formatnumber(cdbl(sad_comparacion),2,-1,0,0)%></div></td>
										<td bgcolor="#CCFFCC"><div align="center"><%=formatnumber(cdbl(sad_clasificacion),2,-1,0,0)%></div></td>
										<td bgcolor="#CCFFCC"><div align="center"><%=formatnumber(cdbl(sad_definicion),2,-1,0,0)%></div></td>
										<td bgcolor="#CCFFCC"><div align="center"><%=formatnumber(cdbl(sad_argumentacion),2,-1,0,0)%></div></td>
										<td bgcolor="#CCFFCC"><div align="center"><%=formatnumber(cdbl(sad_autoevaluacion),2,-1,0,0)%></div></td>
										<td bgcolor="#CCFFCC"><div align="center"><%=formatnumber(cdbl(sad_autovaloracion),2,-1,0,0)%></div></td>
										<td bgcolor="#CCFFCC"><div align="center"><%=formatnumber(cdbl(sad_prom_habilidades),2,-1,0,0)%></div></td>
										<td><div align="center">&nbsp;</div></td>
										<td><div align="center">&nbsp;</div></td>
										<td><div align="center">&nbsp;</div></td>
									  </tr>
									  <% 'total_1 = (sad_descripcion + sad_comparacion + sad_clasificacion +	sad_definicion + sad_argumentacion) / 5
									     total_2 = (sad_prom_habilidades + sad_motivacion + sad_autoevaluacion  +	sad_autovaloracion)
										 sad_general = total_2 / 4
										 'sad_general = total_sad / contador %>
									  <tr>
									  	<td colspan="3" align="right"><font color="#0033FF"><strong><%=msj_total%></strong></font>
										</td>
										<td colspan="13" align="left"><font color="#0033FF"><strong>: <%=formatnumber(cdbl(sad_general),2,-1,0,0)%></strong></font></td>
									  </tr>	 
									</table>
	</td>
</tr>
</table>

</body>
</html>