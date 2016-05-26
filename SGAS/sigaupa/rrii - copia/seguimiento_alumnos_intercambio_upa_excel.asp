<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=listado_postulantes.xls"
Response.ContentType = "application/vnd.ms-excel"

pais_ccod =Request.QueryString("b[0][pais_ccod]")
ciex_ccod =Request.QueryString("b[0][ciex_ccod]")
univ_ccod =Request.QueryString("b[0][univ_ccod]")
peri_ccod =Request.QueryString("b[0][peri_ccod]")
pers_nrut =Request.QueryString("b[0][pers_nrut]")
pers_xdv =Request.QueryString("b[0][pers_xdv]")
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion





if  pais_ccod <>""  then
filtro2=filtro2&"and f.pais_ccod="&pais_ccod&""
end if

if  ciex_ccod <>"" then
filtro=filtro&"and d.ciex_ccod="&ciex_ccod&""
end if




if univ_ccod<>"" then
filtro3=filtro3&"and d.univ_ccod="&univ_ccod&""
end if
 
 
if pers_nrut<>"" then
filtro4=filtro4&"and pers_nrut="&pers_nrut&""
end if






set f_resumen_convenio = new CFormulario
f_resumen_convenio.Carga_Parametros "tabla_vacia.xml", "tabla" 
f_resumen_convenio.Inicializar conexion




sql_descuentos="select aiup_ncorr,pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre,"& vbCrLf &_
 "pais_tdesc,"& vbCrLf &_
 "ciex_tdesc,"& vbCrLf &_
 "univ_tdesc,"& vbCrLf &_
 "espi_tdesc,"& vbCrLf &_
 "'"&pais_ccod&"' as pais_ccod,'"&ciex_ccod&"'as ciex_ccod ,'"&univ_ccod&"' as univ_ccod,'"&peri_ccod&"' as peri_ccod,'"&pers_nrut&"' as pers_nrut,'"&pers_xdv&"' as pers_xdv"& vbCrLf &_
"from personas a,postulantes b,postulacion_alumnos_intercambio_upa c,universidad_ciudad d,universidades e,ciudades_extranjeras g, paises f,ESTADO_POSTULACION_INTERCAMBIO h"& vbCrLf &_
"where a.PERS_NCORR=b.PERS_NCORR"& vbCrLf &_
"and b.POST_NCORR=c.post_ncorr"& vbCrLf &_
"and c.unci_ncorr=d.unci_ncorr"& vbCrLf &_
"and d.univ_ccod=e.univ_ccod"& vbCrLf &_
"and d.ciex_ccod=g.ciex_ccod"& vbCrLf &_
"and g.pais_ccod=f.PAIS_CCOD"& vbCrLf &_
"and c.espi_ccod=h.espi_ccod"& vbCrLf &_
"and c.peri_ccod="&peri_ccod&""& vbCrLf &_
""&filtro&""& vbCrLf &_
""&filtro2&""& vbCrLf &_
""&filtro3&""& vbCrLf &_
""&filtro4&""& vbCrLf &_
"order by  nombre"
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
    <td width="26%" bgcolor="#99CC33"><div align="center"><strong>Nombre</strong></div></td>
    <td width="23%" bgcolor="#99CC33"><div align="center"><strong>Universidad</strong></div></td>
	<td width="17%" bgcolor="#99CC33"><div align="center"><strong>Ciudad</strong></div></td>
	<td width="19%" bgcolor="#99CC33"><div align="center"><strong>Pais</strong></div></td>
    <td width="15%" bgcolor="#99CC33"><div align="center"><strong>Estado</strong></div></td>
	
  </tr>
  <%  while f_resumen_convenio.Siguiente %>
  <tr> 
    <td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("nombre")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("univ_tdesc")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("ciex_tdesc")%></div></td>
    <td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("pais_tdesc")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("espi_tdesc")%></div></td>
   
  </tr>
  <%  wend %>
</table>
</html>