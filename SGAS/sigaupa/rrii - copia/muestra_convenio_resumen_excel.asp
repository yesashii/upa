<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=busca_convenio.xls"
Response.ContentType = "application/vnd.ms-excel"

pais_ccod =Request.QueryString("b[0][pais_ccod]")
ciex_ccod =Request.QueryString("b[0][ciex_ccod]")
univ_ccod =Request.QueryString("b[0][univ_ccod]")
carr_ccod =Request.QueryString("b[0][carr_ccod]")
anos_ccod =Request.QueryString("b[0][anos_ccod]")
fecha_fin_1 =Request.QueryString("b[0][fecha_fin_1]")
fecha_ini_1 =Request.QueryString("b[0][fecha_ini_1]")
fecha_fin_2 =Request.QueryString("b[0][fecha_fin_2]")
fecha_ini_2 =Request.QueryString("b[0][fecha_ini_2]")
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion



if pais_ccod<>"" and ciex_ccod<>"" then
 consulta_uni="select b.univ_ccod,univ_tdesc from universidad_ciudad a, universidades b where a.univ_ccod=b.univ_ccod and ciex_ccod="&ciex_ccod&""
else
 consulta_uni="select ''"
end if


if  pais_ccod <>""  then
filtro2=filtro2&"and e.pais_ccod="&pais_ccod&""
end if

if  ciex_ccod <>"" then
filtro=filtro&"and e.ciex_ccod="&ciex_ccod&""
end if




if univ_ccod<>"" then
filtro3=filtro3&"and b.univ_ccod="&univ_ccod&""
end if
 
 
if carr_ccod<> "" then
filtro4=filtro4&"and d.carr_ccod="&carr_ccod&""
end if


if fecha_fin_1<> ""  and  fecha_ini_1<> "" then
filtro6=filtro6&"and convert(datetime,daco_flimite_pos_sem1_upa,103) between convert(datetime,'"&fecha_ini_1&"',103) and convert(datetime,'"&fecha_fin_1&"',103)"
end if

if fecha_fin_2<> ""  and  fecha_ini_2<> "" then
filtro7=filtro7&"and convert(datetime,daco_flimite_pos_sem2_upa,103) between convert(datetime,'"&fecha_ini_2&"',103) and convert(datetime,'"&fecha_fin_2&"',103)"
end if


 
set f_resumen_convenio = new CFormulario
f_resumen_convenio.Carga_Parametros "tabla_vacia.xml", "tabla" 
f_resumen_convenio.Inicializar conexion

sql_descuentos="select a.daco_ncorr,univ_tdesc,pais_tdesc,ciex_tdesc,"& vbCrLf &_
"protic.obtener_carreras_convenio_rrii(a.daco_ncorr)as carreras_convenio,"& vbCrLf &_
"protic.trunc(daco_flimite_pos_sem1_upa)as daco_flimite_pos_sem1_upa,"& vbCrLf &_
"protic.trunc(daco_flimite_pos_sem2_upa)as daco_flimite_pos_sem2_upa,"& vbCrLf &_
"daco_ncupo"& vbCrLf &_
"from datos_convenio a,"& vbCrLf &_
"universidad_ciudad b,"& vbCrLf &_
"universidades c,"& vbCrLf &_
"carreras_convenio d,"& vbCrLf &_
"ciudades_extranjeras e,"& vbCrLf &_
"paises f"& vbCrLf &_
"where a.unci_ncorr=b.unci_ncorr"& vbCrLf &_
"and b.univ_ccod=c.univ_ccod"& vbCrLf &_
"and b.ciex_ccod=e.ciex_ccod"& vbCrLf &_
"and a.daco_ncorr=d.daco_ncorr"& vbCrLf &_
"and a.anos_ccod="&anos_ccod&""& vbCrLf &_
"and d.ecco_ccod=1"& vbCrLf &_
"and e.pais_ccod=f.pais_ccod"& vbCrLf &_
""&filtro&""& vbCrLf &_
""&filtro2&""& vbCrLf &_
""&filtro3&""& vbCrLf &_
""&filtro4&""& vbCrLf &_
""&filtro6&""& vbCrLf &_
""&filtro7&""& vbCrLf &_
"group by univ_tdesc,a.daco_ncorr,daco_flimite_pos_sem1_upa,daco_flimite_pos_sem2_upa,daco_ncupo,pais_tdesc,ciex_tdesc"				
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&numero_total&"</pre>")
'response.Write("<pre>"&q_sfun_ccod&"</pre>")
'response.End()

f_resumen_convenio.Consultar sql_descuentos


				
				
'-------------------------------------------------------------------------------



'response.End()		

'------------------------------------------------------------------------------
%>
 <html>
<head>
<title><%=pagina.Titulo%></title>  

</head>
<body bgcolor="#ffffff" leftmargin="43" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="100%" border="1">
 
  <tr>
    <td width="11%" bgcolor="#00CC00"><div align="center"><strong>Instituci&oacute;n</strong></div></td>
    <td width="5%" bgcolor="#00CC00"><div align="center"><strong>Pais</strong></div></td>
	<td width="5%" bgcolor="#00CC00"><div align="center"><strong>Ciudad</strong></div></td>
	<td width="5%" bgcolor="#00CC00"><div align="center"><strong>Cupo</strong></div></td>
    <td width="20%" bgcolor="#00CC00"><div align="center"><strong>Carrera UPA en Convenio</strong></div></td>
    <td width="18%" bgcolor="#00CC00"><div align="center"><strong>Fecha Limite Postulaci&oacute;n 1 semestre </strong></div></td>
	<td width="12%" bgcolor="#00CC00"><div align="center"><strong>Fecha Postulaci&oacute;n 2 semestre </strong></div></td>
	
  </tr>
  <%  while f_resumen_convenio.Siguiente %>
  <tr> 
    <td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("univ_tdesc")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("pais_tdesc")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("ciex_tdesc")%></div></td>
    <td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("daco_ncupo")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("carreras_convenio")%></div></td>
    <td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("daco_flimite_pos_sem1_upa")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("daco_flimite_pos_sem2_upa")%></div></td>
   
  </tr>
  <%  wend %>
</table>
</html>