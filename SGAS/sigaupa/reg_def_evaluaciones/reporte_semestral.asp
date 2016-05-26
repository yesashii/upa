<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=listado_x_fecha.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 300000
'---------------------------------------------------------------------------------------------------
peri_ccod = request.QueryString("peri_ccod")
sede_ccod = request.QueryString("sede_ccod")
carr_ccod = request.QueryString("carr_ccod")
jorn_ccod = request.QueryString("jorn_ccod")

set pagina = new CPagina
pagina.Titulo = "Reporte de avance evaluaciones semestrales" 

set conexion = new cConexion
conexion.inicializar "upacifico"
fecha_01 = conexion.consultaUno("select protic.trunc(getDate())")
'---------------------------------------------------------------------------------------------------
plec_ccod = conexion.consultaUno("select plec_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
if plec_ccod = "1" then 
	filtro_periodo = " and cast(a.peri_ccod as varchar) = '"&peri_ccod&"'"
else
	anos_ccod = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
    primer_periodo = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod&"' and plec_ccod = 1 ")
    filtro_periodo = " and cast(a.peri_ccod as varchar) = case b.duas_ccod when 3 then '"&primer_periodo&"' else '"&peri_ccod&"' end"
end if

c_cantidad = "select max(cant_evaluaciones)"& vbCrLf &_
			 " from "& vbCrLf &_
			 " ( "& vbCrLf &_
			 " select b.asig_ccod,b.asig_tdesc,a.secc_ccod,a.secc_tdesc, "& vbCrLf &_
		     " (select count(*) from calificaciones_seccion cs where cs.secc_ccod=a.secc_ccod) as cant_evaluaciones "& vbCrLf &_
			 " from secciones a, asignaturas b "& vbCrLf &_
			 " where a.asig_ccod=b.asig_Ccod "& vbCrLf &_
			 " and a.carr_ccod='"&carr_ccod&"' and cast(a.sede_ccod as varchar)='"&sede_ccod&"' and cast(a.jorn_ccod as varchar)='"&jorn_ccod&"' "& vbCrLf &_
			 " "& filtro_periodo & vbCrLf &_
			 " )tablea"
'response.Write("<pre>"&c_cantidad&"</pre>")
cantidad = conexion.consultaUno(c_cantidad)


'response.End()
set f_lista = new CFormulario
f_lista.Carga_Parametros "tabla_vacia.xml", "tabla"
f_lista.Inicializar conexion
			
consulta =  "  select c.sede_tdesc as sede, carr_tdesc as carrera, jorn_tdesc as jornada, "& vbCrLf &_	
			"  b.asig_ccod,b.asig_tdesc,a.secc_ccod,a.secc_tdesc,isnull(cast(secc_porce_asiste as varchar),'--') as porcentaje, "& vbCrLf &_	
			"  (select count(*) from cargas_academicas cs where cs.secc_ccod=a.secc_ccod) as cant_alumnos "& vbCrLf &_	
			"  from secciones a, asignaturas b, sedes c, carreras d, jornadas e "& vbCrLf &_	
			"  where a.asig_ccod=b.asig_Ccod "& vbCrLf &_	
			"  and a.sede_ccod=c.sede_ccod and a.carr_ccod=d.carr_ccod  "& vbCrLf &_	
			"  and a.jorn_ccod = e.jorn_ccod "& vbCrLf &_	
			"  and a.carr_ccod='"&carr_ccod&"' and cast(a.sede_ccod as varchar)='"&sede_ccod&"' and cast(a.jorn_ccod as varchar)='"&jorn_ccod&"' "& vbCrLf &_
			"  "&filtro_periodo		



f_lista.Consultar consulta & " order by sede,carrera,jornada"
'response.write("<pre>"&consulta & " order by "&filtro_orden&" apellidos desc </pre>")	
'response.Write("<pre>"&sql_detalles_mate&"</pre>")
'response.End()

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
	<td colspan="2" align="center"><font size="4"><strong><%=pagina.Titulo%></strong></font></td>
</tr>
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
<tr>
	<td colspan="2" align="left"><strong>Fecha de Proceso : </strong><%=fecha_01%></td>
</tr>
<tr>
	<td colspan="2" align="left"><strong>Hora de Proceso : </strong><%=time()%></td>
</tr>
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
<tr>
	<td colspan="2" align="center"><table width="75%" border="1">
									  <tr> 
										<td bgcolor="#FFFFCC"><div align="center"><strong>N°</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Sede</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Carrera</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Jornada</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Cód. asignatura</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Asignatura</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Sección</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>N° Alumnos</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Porcentaje Exigido</strong></div></td>
										<%
										contador = 1
										while contador <= cint(cantidad)
										%>
										   <td bgcolor="#FFFFCC"><div align="center"><strong>Evaluación <%=contador%></strong></div></td>  
										<%
										   contador = contador + 1
										wend
										%>
									  </tr>
									  <% fila = 1 
										 while f_lista.Siguiente %>
									  <tr> 
										<td><div align="center"><%=fila%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("sede")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("carrera")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("jornada")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("asig_ccod")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("asig_tdesc")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("secc_tdesc")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("cant_alumnos")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("porcentaje")%></div></td>
										<%
											set f_lista2 = new CFormulario
											f_lista2.Carga_Parametros "tabla_vacia.xml", "tabla"
											f_lista2.Inicializar conexion
											secc_ccod = f_lista.ObtenerValor("secc_ccod")			
											consulta =  "  select cast(datepart(day,cali_fevaluacion) as varchar) + '-' + "& vbCrLf &_	
														"       cast(datepart(month,cali_fevaluacion) as varchar) + '-' + "& vbCrLf &_	
														"       cast(datepart(year,cali_fevaluacion) as varchar) + ' (' + "& vbCrLf &_	
														"       cast(cali_nponderacion as varchar) + '% )' as muestra, "& vbCrLf &_	
														"       cali_nevaluacion as orden, "& vbCrLf &_	
														"       (select count(*) from calificaciones_alumnos ca where ca.cali_ncorr=a.cali_ncorr and ca.secc_ccod=a.secc_ccod ) as evaluado "& vbCrLf &_	
														"       from calificaciones_seccion a where cast(secc_Ccod as varchar)='"&secc_ccod&"' "& vbCrLf &_	
														" order by orden asc"
											
											
											
											f_lista2.Consultar consulta 
											contador2 = 0
											while f_lista2.siguiente
											 muestra = f_lista2.ObtenerValor("muestra")		
											 evaluado = f_lista2.ObtenerValor("evaluado")
											 if evaluado = "0" then %>
											 	<td bgcolor="#FFFF99"><div align="left"><%=muestra%></div></td>
											 <%else%>
											 	<td bgcolor="#CCFFCC"><div align="left"><%=muestra%></div></td>
											 <%end if 		
											 contador2 = contador2 + 1
											wend
											
										contador = 1
										while contador <= (cint(cantidad) - contador2 )
										   if contador2 = 0 then %>
										      <td bgcolor="#CC0000"><div align="center">&nbsp;</div></td>  
										   <%else%>
										      <td bgcolor="#FFFFFF"><div align="center">&nbsp;</div></td>  
										<% end if 
										   contador = contador + 1
										wend
										%>
									 </tr>
									  <%fila= fila + 1  
										wend %>
									</table>
	</td>
</tr>
</table>

</body>
</html>