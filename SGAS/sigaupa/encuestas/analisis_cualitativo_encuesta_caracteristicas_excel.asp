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
			" c.carr_tdesc as carrera, "& vbCrLf &_
			" case preg_I_aa when 1 then 'X' else '' end as ia, case preg_I_ab when 1 then 'X' else '' end as ib, "& vbCrLf &_
            " case preg_I_ac when 1 then 'X' else '' end as ic, case preg_I_ad when 1 then 'X' else '' end as id, "& vbCrLf &_
			" case preg_I_ae when 1 then 'X' else '' end as ie, case preg_I_af when 1 then 'X' else '' end as iif, "& vbCrLf &_
			" case preg_I_ba when 1 then 'X' else '' end as iia, case preg_I_bb when 1 then 'X' else '' end as iib, "& vbCrLf &_
		    " case preg_I_bc when 1 then 'X' else '' end as iic, case preg_I_bd when 1 then 'X' else '' end as iid, "& vbCrLf &_
			" case preg_I_be when 1 then 'X' else '' end as iie, case preg_I_bf when 1 then 'X' else '' end as iiif, "& vbCrLf &_
			" case preg_I_bg when 1 then 'X' else '' end as iig "& vbCrLf &_
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
	<td colspan="2" align="center"><font size="4"><strong>Análisis Cualitativo encuesta Desarrollo</strong></font></td>
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
	<td colspan="2">&nbsp;</td>
</tr>
<tr>
	<td colspan="2" align="center"><table width="75%" border="1">
	                                  <tr valign="top">
									  	<td colspan="4">&nbsp;</td>
										<td colspan="6" bgcolor="#FFFFCC"><strong>Indica la (as) expectativa (s) que tienes sobre la carrera que deseas estudiar.</strong><br>
										                        <strong>A)</strong>Poder contar con herramientas profesionales que me permitan contribuir al desarrollo del País.<br>
																<strong>B)</strong>Dominio teórico.<br>
																<strong>C)</strong>Lograr una inserción a la vida laboral profesional.<br>
																<strong>D)</strong>Aprender a solucionar problemas científicos.<br>
																<strong>E)</strong>Dominio práctico<br>
																<strong>F)</strong>Poder ayudar a los demás</td>
										<td colspan="7"><strong>Señala aquel (llos) aspectos que consideras que no están claros con respecto a la carrera seleccionada:</strong><br>
										                        <strong>A)</strong>Afectará la vida personal el ejercicio profesional futuro.<br>
																<strong>B)</strong>Sabré tener conductas profesionales.<br>
																<strong>C)</strong>Valdrá la pena realizar los estudios universitarios.<br>
																<strong>D)</strong>Contaré con la preparación previa como para tener un buen desempeño durante los estudios universitarios.<br>
																<strong>E)</strong>Estaré convencido de qué es lo que realmente quiero estudiar.<br>
																<strong>F)</strong>Podré contribuir al mejoramiento del entorno social.<br>
																<strong>G)</strong>Ninguna de las anteriores.</td>
									  </tr>
									  <tr> 
										<td bgcolor="#FFFFCC"><div align="center"><strong>N°</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>RUT</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>NOMBRE</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>CARRERA</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>A)</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>B)</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>C)</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>D)</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>E)</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>F)</strong></div></td>
										<td><div align="center"><strong>A)</strong></div></td>
										<td><div align="center"><strong>B)</strong></div></td>
										<td><div align="center"><strong>C)</strong></div></td>
										<td><div align="center"><strong>D)</strong></div></td>
										<td><div align="center"><strong>E)</strong></div></td>
										<td><div align="center"><strong>F)</strong></div></td>
										<td><div align="center"><strong>G)</strong></div></td>
									  </tr>
									  <%
									 while f_lista.Siguiente %>
									  <tr> 
										<td><div align="center"><%=fila%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("rut")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("nombre")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("carrera")%></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><%=f_lista.ObtenerValor("ia")%></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><%=f_lista.ObtenerValor("ib")%></div></td>	
										<td bgcolor="#FFFFCC"><div align="center"><%=f_lista.ObtenerValor("ic")%></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><%=f_lista.ObtenerValor("id")%></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><%=f_lista.ObtenerValor("ie")%></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><%=f_lista.ObtenerValor("iif")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("iia")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("iib")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("iic")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("iid")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("iie")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("iiif")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("iig")%></div></td>
									  </tr>
									  <%fila= fila + 1 
									wend %>
					</table>
	</td>
</tr>
</table>

</body>
</html>