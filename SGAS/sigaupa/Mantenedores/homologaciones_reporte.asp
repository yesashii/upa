<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=homologacion_reporte.xls"
Response.ContentType = "application/vnd.ms-excel"
'---------------------------------------------------------------------------------------------------
homo_nresolucion2 = request.querystring("homo_nresolucion")
set conexion = new CConexion
set negocio = new CNegocio
conexion.inicializar "upacifico"
negocio.inicializa conexion

set f_asig_resolucion = new CFormulario
f_asig_resolucion.Carga_Parametros "consulta.xml", "consulta"
f_asig_resolucion.Inicializar conexion
SQL_asig_resolucion = " select a.homo_ccod,c.asig_ccod as asig_ccod_origen,b.asig_ccod as asig_ccod_destino,c.asig_ccod, " & vbcrlf & _
					  " (Select asig_tdesc from asignaturas where asig_ccod=c.asig_ccod) as asig_origen, " & vbcrlf & _
		    		  " (Select asig_tdesc from asignaturas where asig_ccod=b.asig_ccod) as asig_destino " & vbcrlf & _
					  "    from homologacion a, homologacion_destino b, homologacion_fuente c " & vbcrlf & _
					  "    where cast(a.homo_nresolucion as varchar)='" & homo_nresolucion2 & "' and a.homo_ccod=b.homo_ccod " & vbcrlf & _
					  "    and a.homo_ccod=c.homo_ccod and b.homo_ccod=c.homo_ccod"
'response.Write("<pre>" & SQL_asig_resolucion & "<pre>")
f_asig_resolucion.Consultar SQL_asig_resolucion

set f_homo = new CFormulario
f_homo.Carga_Parametros "m_homologaciones_malla.xml", "f_nuevo"
f_homo.Inicializar conexion
SQL = " Select homo_fresolucion,esho_ccod,thom_ccod,homo_nresolucion,(Select esho_tdesc from estados_homologacion where esho_ccod=a.esho_ccod) as esho_tdesc," & vbcrlf & _
	" (Select thom_tdesc from tipos_homologaciones where thom_ccod=a.thom_ccod) as thom_tdesc " & vbcrlf & _
    " from homologacion a " & vbcrlf & _
    " where cast(a.homo_nresolucion as varchar)='" & homo_nresolucion2 & "' " & vbcrlf & _
	" group by homo_nresolucion,homo_fresolucion,esho_ccod,thom_ccod "
f_homo.Consultar SQL

f_homo.Siguiente

sql_verif_plan_fuente = "select max(plan_ccod_fuente) as plan_ccod_fuente from homologacion " & vbcrlf & _
					   " where cast(homo_nresolucion as varchar)='" & homo_nresolucion2 & "'"
					   
sql_verif_plan_destino = "select max(plan_ccod_destino) as plan_ccod_destino from homologacion " & vbcrlf & _
					   " where cast(homo_nresolucion as varchar)='" & homo_nresolucion2& "'"
					   
verif_plan_fuente = conexion.consultaUno(sql_verif_plan_fuente)
verif_plan_destino = conexion.consultaUno(sql_verif_plan_destino)

plan_ccod_aux_fuente=conexion.ConsultaUno("select plan_ccod from planes_estudio where plan_ccod=" & verif_plan_fuente)   
plan_ccod_aux_destino=conexion.ConsultaUno("select plan_ccod from planes_estudio where plan_ccod=" & verif_plan_destino)   
plan_tdesc_fuente = conexion.ConsultaUno("select plan_tdesc from planes_estudio where plan_ccod=" & plan_ccod_aux_fuente)   
plan_tdesc_destino = conexion.ConsultaUno("select plan_tdesc from planes_estudio where plan_ccod=" & plan_ccod_aux_destino)   

espe_ccod_aux_fuente=conexion.ConsultaUno("select b.espe_ccod from planes_estudio a, especialidades b where a.plan_ccod=" & verif_plan_fuente & " and a.espe_ccod=b.espe_ccod")   
espe_ccod_aux_destino=conexion.ConsultaUno("select b.espe_ccod from planes_estudio a, especialidades b where a.plan_ccod=" & verif_plan_destino & " and a.espe_ccod=b.espe_ccod")   
espe_tdesc_fuente=conexion.ConsultaUno("select b.espe_tdesc from planes_estudio a, especialidades b where a.plan_ccod=" & verif_plan_fuente & " and a.espe_ccod=b.espe_ccod")   
espe_tdesc_destino=conexion.ConsultaUno("select b.espe_tdesc from planes_estudio a, especialidades b where a.plan_ccod=" & verif_plan_destino & " and a.espe_ccod=b.espe_ccod")   


carr_ccod_aux_fuente=conexion.ConsultaUno("select carr_ccod from especialidades where espe_ccod=" & espe_ccod_aux_fuente)   
carr_ccod_aux_destino=conexion.ConsultaUno("select carr_ccod from especialidades where espe_ccod=" & espe_ccod_aux_destino)   
carr_tdesc_fuente=conexion.ConsultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar)='" & carr_ccod_aux_fuente & "'")   
carr_tdesc_destino=conexion.ConsultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar)='" & carr_ccod_aux_destino & "'")   

	
'------------------------------------------------------------------------------
%>
<html>
<head>
<!--<meta http-equiv="Content-Type" content="text/html;">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">-->

</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="650" border="0">
  <tr> 
	<td width="21%"><div align="left">N&ordm; Resoluci&oacute;n</div></td>
	<td width="4%"><div align="center">:</div></td>
	<td width="75%" colspan="4" align="left"><strong><%=f_homo.ObtenerValor("homo_nresolucion") %></td>
  </tr>
  <tr>
	<td><div align="left">Fecha Resoluci&oacute;n</div></td>
	<td><div align="center">:</div></td>
	<td colspan="4" align="left"><strong><%=f_homo.ObtenerValor("homo_fresolucion")%></strong></td>
  </tr>
  <tr>
	<td><div align="left">Tipo Homologaci&oacute;n</div></td>
	<td><div align="center">:</div></td>
	<td colspan="4" align="left"><strong><%=f_homo.ObtenerValor("thom_tdesc")%></strong></td>
  </tr>
  <tr>
	<td><div align="left">Estado Homologaci&oacute;n</div></td>
	<td><div align="center">:</div></td>
	<td align="left" colspan="2"><strong><%=f_homo.ObtenerValor("esho_tdesc")%></strong></td>
	<td align="right" colspan="2"></td>
  </tr>	
  <tr> 
	<td width="55">Origen</td>
	<td width="5" align="center">:</td>
	<td width="196" colspan="4"><%=carr_tdesc_fuente %> / <%=espe_tdesc_fuente %> / <%=plan_tdesc_fuente %></td>
  </tr>
  <tr> 
	<td width="55">Destino</td>
	<td width="5" align="center">:</td>
	<td width="196" colspan="4"><%=carr_tdesc_destino %> / <%=espe_tdesc_destino %> / <%=plan_tdesc_destino %></td>
  </tr>
  <tr>
  	<td colspan="6">&nbsp;</td>
  </tr>
</table>
<table width="75%" border="1">

  <tr> 
    <td><div align="center"><strong>Código Asignatura Origen</strong></div></td>
    <td colspan="2"><div align="center"><strong>Asignatura Origen</strong></div></td>
    <td colspan="2"><div align="center"><strong>Código Asignatura Destino</strong></div></td>
    <td><div align="center"><strong>Asignatura Destino</strong></div></td>
  </tr>
  <%  while f_asig_resolucion.Siguiente %>
  <tr> 
    <td><div align="center"><%=f_asig_resolucion.ObtenerValor("asig_ccod_origen")%></div></td>
    <td colspan="2"><div align="center"><%=f_asig_resolucion.ObtenerValor("asig_origen")%></div></td>
    <td colspan="2"><div align="left"><%=f_asig_resolucion.ObtenerValor("asig_ccod_destino")%></div></td>
    <td><div align="center"><%=f_asig_resolucion.ObtenerValor("asig_destino")%></div></td>
  </tr>
  <%  wend %>
</table>
</body>
</html>