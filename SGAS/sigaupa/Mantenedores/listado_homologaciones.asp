<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=homologaciones.xls"
Response.ContentType = "application/vnd.ms-excel"


homo_nresolucion = request.querystring("homo_nresolucion")
carr_ccod = request.querystring("carr_ccod")

'response.Write("listado_homologaciones.asp?homo_nresolucion="&homo_nresolucion&"&carr_ccod="&carr_ccod)
'response.End()

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

fecha_01 =conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------

set f_homo = new CFormulario
f_homo.Carga_Parametros "tabla_vacia.xml", "tabla"
f_homo.Inicializar conexion

consulta = " Select min(a.homo_ccod) as homo_ccod,homo_fresolucion,esho_tdesc,thom_tdesc," & vbCrLf &_
		   "  homo_nresolucion,homo_nresolucion as homo_nresolucion_aux,  " & vbCrLf &_
		   "(Select plan_tdesc from planes_estudio where plan_ccod=a.plan_ccod_fuente) as plan_tdesc_fuente, " & vbCrLf &_
           " (Select plan_tdesc from planes_estudio where plan_ccod=a.plan_ccod_destino) as plan_tdesc_destino, " & vbCrLf &_
           " (select carr_tdesc from carreras aa,especialidades b,planes_estudio c " & vbCrLf &_
           " where c.plan_ccod=a.plan_ccod_fuente " & vbCrLf &_
           " and c.espe_ccod=b.espe_ccod " & vbCrLf &_
           " and b.carr_ccod=aa.carr_ccod) as carr_tdesc_fuente, " & vbCrLf &_
           " (select carr_tdesc from carreras aa,especialidades b,planes_estudio c " & vbCrLf &_
           " where c.plan_ccod=a.plan_ccod_destino " & vbCrLf &_
           " and c.espe_ccod=b.espe_ccod " & vbCrLf &_
           " and b.carr_ccod=aa.carr_ccod) as carr_tdesc_destino " & vbCrLf &_
    	   " from homologacion a, tipos_homologaciones b, estados_homologacion c " & vbCrLf &_
		   " where a.thom_ccod=b.thom_ccod and a.esho_ccod=c.esho_ccod " & vbCrLf

if	homo_nresolucion <> ""  then		   
	consulta = consulta & " and cast(a.homo_nresolucion as varchar)='" & homo_nresolucion & "'"
end if		   

if carr_ccod <> "" then
    consulta = consulta & " and  ((select count(*) from planes_estudio pe, especialidades es where pe.plan_ccod=a.plan_ccod_fuente and pe.espe_ccod=es.espe_ccod and es.carr_ccod='"&carr_ccod&"') " & vbCrLf &_
						  "       + " & vbCrLf &_
					      "      (select count(*) from planes_estudio pe, especialidades es where pe.plan_ccod=a.plan_ccod_destino and pe.espe_ccod=es.espe_ccod and es.carr_ccod='"&carr_ccod&"'))<> 0 "
end if
		       
    consulta = consulta & " group by homo_nresolucion,homo_fresolucion,esho_tdesc,thom_tdesc,a.plan_ccod_fuente,a.plan_ccod_destino"

f_homo.Consultar consulta
%>
<html>
<head>
<title> Listado Homologaciones</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado Homologaciones </font></div>
	<div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  
  <tr>
    <td width="6%"><strong>Fecha</strong></td>
    <td width="94%" colspan="3"> <strong>:</strong><%=fecha_01%></td>
 </tr>
 
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="2%" bgcolor="#FFFFCC"><div align="center"><strong>Nº</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Nº Resolución</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Fecha Resolución</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Plan Origen</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Carrera Origen</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Plan Destino</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Carrera Destino</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Tipo Homologación</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Estado</strong></div></td>
  </tr>
  <%  fila = 1 
     while f_homo.Siguiente %>
  <tr>
    <td><div align="center"><%=fila%></div></td> 
    <td><div align="center"><%=f_homo.ObtenerValor("homo_nresolucion_aux")%></div></td>
    <td><div align="center"><%=f_homo.ObtenerValor("homo_fresolucion")%></div></td>
    <td><div align="center"><%=f_homo.ObtenerValor("plan_tdesc_fuente")%></div></td>
    <td><div align="left"><%=f_homo.ObtenerValor("carr_tdesc_fuente")%></div></td>
    <td><div align="center"><%=f_homo.ObtenerValor("plan_tdesc_destino")%></div></td>
	<td><div align="left"><%=f_homo.ObtenerValor("carr_tdesc_destino")%></div></td>
	<td><div align="center"><%=f_homo.ObtenerValor("thom_tdesc")%></div></td>
	<td><div align="center"><%=f_homo.ObtenerValor("esho_tdesc")%></div></td>
  </tr>
  <%fila = fila + 1  
    wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>