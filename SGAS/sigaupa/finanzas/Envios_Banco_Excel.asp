<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=detalle_envios_Banco.xls"
Response.ContentType = "application/vnd.ms-excel"

'------------------------------------------------------------------------------------
set pagina = new CPagina
'-----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------------
folio_envio = Request.QueryString("folio_envio")
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
response.Write("En Construccion...")
response.End()
'------------------------------------------------------------------------------------
set f_envio = new CFormulario
f_envio.Carga_Parametros "Envios_Banco.xml", "f_envios"
f_envio.Inicializar conexion
consulta = "SELECT a.envi_ncorr, a.envi_fenvio, a.inen_ccod, "&_
         "b.inen_tdesc, a.plaz_ccod, c.plaz_tdesc "&_
         "FROM envios a, instituciones_envio b, plazas c "&_
         "WHERE ((a.inen_ccod = b.inen_ccod) "&_
         "AND (a.plaz_ccod = c.plaz_ccod)) "&_
		 "AND a.envi_ncorr=" & folio_envio 
 f_envio.Consultar consulta
 f_envio.siguiente
 '------------------------------------------------------------------------------------
set f_detalle_envio = new CFormulario
f_detalle_envio.Carga_Parametros "Envios_Banco.xml", "excel"
f_detalle_envio.Inicializar conexion

consulta = "SELECT  b.envi_ncorr, "&_ 
		"personas.pers_nrut || '-' || personas.pers_xdv as rut_alumno,  "&_ 
		"g.pers_nrut || '-' || g.pers_xdv as rut_apoderado,  "&_ 
		"g.pers_tnombre || ' ' || g.pers_tape_paterno as nombre_apoderado, "&_ 
		"count(b.envi_ncorr) as documentos  "&_ 
"FROM   envios a, detalle_envios b, "&_ 
       "detalle_ingresos c,  "&_ 
       "ingresos d, postulantes e,  "&_ 
"		codeudor_postulacion f,  "&_ 
"		personas, "&_ 
"		personas g  "&_ 
"WHERE (c.DING_NCORRELATIVO = 1 "&_ 
        "AND a.envi_ncorr = b.envi_ncorr "&_ 
		" AND  c.ting_ccod = b.ting_ccod  "&_ 
		"	AND c.ding_ndocto = b.ding_ndocto  "&_ 
		"	AND d.ingr_ncorr = c.ingr_ncorr  "&_ 
			"AND e.pers_ncorr = d.pers_ncorr  "&_ 
			"AND f.post_ncorr = e.post_ncorr  "&_ 
			"AND personas.pers_ncorr = e.pers_ncorr "&_ 
			"and f.pers_ncorr = g.pers_ncorr "&_ 
			"AND b.envi_ncorr=" & folio_envio &  " AND e.peri_ccod='" & Periodo &  "') "&_ 
		"GROUP BY b.envi_ncorr, d.pers_ncorr, personas.pers_nrut,  "&_ 
			"personas.pers_xdv, g.pers_nrut, g.pers_xdv,  "&_ 
			"g.pers_tape_paterno, g.pers_tnombre, "&_ 
			"e.peri_ccod"

f_detalle_envio.Consultar consulta

%>
<html>
<head>
<title> Detalle Envio a Banco</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td width="10%">&nbsp;</td>
    <td width="34%">&nbsp;</td>
  </tr>
  <tr> 
    <td><strong>N&ordm; Folio</strong></td>
    <td><strong>:</strong><font size="2"> 
      <% =f_envio.DibujaCampo("envi_ncorr") %>
      </font></td>
    <td><div align="left"><font size="2"> </font></div></td>
    <td><strong>Fecha</strong></td>
    <td><strong>:</strong> <% =f_envio.DibujaCampo("envi_fenvio") %> </td>
  </tr>
  <tr> 
    <td width="16%"><strong>Banco</strong></td>
    <td width="26%"><strong>:</strong> <% =f_envio.DibujaCampo("inen_tdesc") %> </td>
    <td width="14%"><div align="left"><font size="2"> </font></div></td>
    <td><strong>Plaza</strong></td>
    <td><strong>:</strong> 
      <% =f_envio.DibujaCampo("plaz_tdesc") %>
    </td>
  </tr>
</table>
<p>&nbsp; 
<table width="75%" border="1">
  <tr> 
    <td><div align="center"><strong>Rut Alumno</strong></div></td>
    <td><div align="center"><strong>Rut Apoderado</strong></div></td>
    <td><div align="center"><strong>Apoderado</strong></div></td>
    <td><div align="center"><strong>N&ordm; Documentos</strong></div></td>
  </tr>
  <%  while f_detalle_envio.Siguiente %>
  <tr> 
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("rut_alumno")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("rut_apoderado")%></div></td>
    <td><div align="left"><%=f_detalle_envio.ObtenerValor("nombre_apoderado")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("documentos")%></div></td>
  </tr>
  <%  wend %>
</table>

</p>
<div align="center"></div>
</body>
</html>