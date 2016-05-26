<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=detalle_envios_cobranza.xls"
Response.ContentType = "application/vnd.ms-excel"
'------------------------------------------------------------------------------------
set pagina = new CPagina
'-----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------------
folio_envio = Request.QueryString("folio_envio")
empresa_envio = request.QueryString("empresa_envio")
fecha = request.QueryString("fecha")

Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'response.End()
 '------------------------------------------------------------------------------------
set f_detalle_envio = new CFormulario
f_detalle_envio.Carga_Parametros "edicion_envios_cobranza.xml", "excel"
f_detalle_envio.Inicializar conexion


' consulta = "select distinct ee.envi_ncorr, a.ting_ccod ,i.ting_tdesc,  a.ding_ndocto as c_ding_ndocto,"& vbCrLf &_
' "tiene_multa_protesto(a.ting_ccod,a.ding_ndocto,a.ingr_ncorr) multa_protesto, "& vbCrLf &_
'"b.ingr_ncorr,a.ding_ndocto,a.ding_mdocto,trunc(b.ingr_fpago) as fecha_envio, "& vbCrLf &_
'"trunc(a.ding_fdocto) as ding_fdocto,a.ding_tcuenta_corriente,h.edin_tdesc, "& vbCrLf &_
'"obtener_nombre_completo(a.pers_ncorr_codeudor) nombre_apoderado , "& vbCrLf &_
'"obtener_rut(b.pers_ncorr) as rut_alumno, obtener_rut(a.pers_ncorr_codeudor) as rut_apoderado "& vbCrLf &_
'"	 from envios ee, "& vbCrLf &_
'"	 detalle_envios de, "& vbCrLf &_
'"	 detalle_ingresos a,  "& vbCrLf &_
'"	 estados_detalle_ingresos a1,  "& vbCrLf &_
'"	 ingresos b,  "& vbCrLf &_
'"	 estados_detalle_ingresos h,  "& vbCrLf &_
'"	 tipos_ingresos i,   "& vbCrLf &_
'"		  personas j, "& vbCrLf &_
'"		  personas k,  "& vbCrLf &_
'"		  abonos l,  "& vbCrLf &_
'"		  detalle_compromisos m,  "& vbCrLf &_
'"		  postulantes n, "& vbCrLf &_
'"		  ofertas_academicas o "& vbCrLf &_
'"	 where  "& vbCrLf &_
'"	   ee.envi_ncorr = de.envi_ncorr "& vbCrLf &_
'"	   and de.ting_ccod = a.ting_ccod "& vbCrLf &_
'"	   and de.ding_ndocto = a.ding_ndocto  "& vbCrLf &_
'"	 and de.ingr_ncorr = a.ingr_ncorr  "& vbCrLf &_
'"	   and a.ingr_ncorr = b.ingr_ncorr    "& vbCrLf &_
'"      and a.edin_ccod = a1.edin_ccod  "& vbCrLf &_
'"      and a.ding_ncorrelativo = 1   "& vbCrLf &_
'"	   and a.edin_ccod = h.edin_ccod   "& vbCrLf &_
'"	   and a.ting_ccod = i.ting_ccod  "& vbCrLf &_
'"	   and b.pers_ncorr = j.pers_ncorr   "& vbCrLf &_
'"	   and a.pers_ncorr_codeudor  = k.pers_ncorr  (+) "& vbCrLf &_
'"	   and b.ingr_ncorr = l.ingr_ncorr   "& vbCrLf &_
'"	   and l.tcom_ccod = m.tcom_ccod  "& vbCrLf &_
'"	   and l.inst_ccod = m.inst_ccod  "& vbCrLf &_
'"	   and l.comp_ndocto = m.comp_ndocto  "& vbCrLf &_
'"	   and l.dcom_ncompromiso = m.dcom_ncompromiso  "& vbCrLf &_
'"	   and b.pers_ncorr = n.pers_ncorr (+) "& vbCrLf &_

'"	   and n.ofer_ncorr = o.ofer_ncorr  (+)"& vbCrLf &_
'"	   AND ee.envi_ncorr="& folio_envio


consulta = 	" Select a.envi_ncorr, c.ting_ccod, d.ting_tdesc, c.ding_ndocto as c_ding_ndocto, c.ingr_ncorr, c.ding_ndocto, c.ding_mdocto,  "& vbCrLf &_
           	" 		protic.total_recepcionar_cuota(j.tcom_ccod,j.inst_ccod,j.comp_ndocto,j.dcom_ncompromiso)   as saldo,"& vbCrLf &_
			"       convert(datetime,e.ingr_fpago, 103) as fecha_envio, protic.tiene_multa_protesto(c.ting_ccod, c.ding_ndocto, c.ingr_ncorr) as multa_protesto, "& vbCrLf &_
		   	"	   	convert(datetime,c.ding_fdocto, 103) as ding_fdocto, c.ding_tcuenta_corriente, f.edin_tdesc, "& vbCrLf &_
		   	"	   	g.pers_tnombre as nombre_apoderado, g.pers_tape_paterno as apellido_paterno, g.pers_tape_materno as apellido_materno, "& vbCrLf &_
		   	"	   	protic.obtener_rut(e.pers_ncorr) as rut_alumno, "& vbCrLf &_
		   	"	   	protic.obtener_rut(isnull(c.pers_ncorr_codeudor, protic.ultimo_aval(e.pers_ncorr))) as rut_apoderado, "& vbCrLf &_
		   	"       isnull(protic.obtener_direccion_letra(g.pers_ncorr,1,'CNPB'),protic.obtener_direccion(e.pers_ncorr,1,'CNPB'))  as direccion, "& vbCrLf &_
		   	" 		i.ciud_tdesc as comuna, i.ciud_tcomuna as  ciudad, g.pers_tfono as telefono "& vbCrLf &_
		   	" From envios a, detalle_envios b, detalle_ingresos c, tipos_ingresos d, ingresos e, estados_detalle_ingresos f, "& vbCrLf &_
			"      personas g,  direcciones_publica h, ciudades i, abonos j "& vbCrLf &_		   
			" Where a.envi_ncorr = b.envi_ncorr "& vbCrLf &_
		   	"  and b.ting_ccod = c.ting_ccod "& vbCrLf &_
		   	"  and b.ingr_ncorr = c.ingr_ncorr "& vbCrLf &_
		   	"  and b.ding_ndocto = c.ding_ndocto "& vbCrLf &_
		   	"  and c.ting_ccod = d.ting_ccod "& vbCrLf &_
		   	"  and c.ingr_ncorr = e.ingr_ncorr "& vbCrLf &_
			"  and e.ingr_ncorr=j.ingr_ncorr "& vbCrLf &_
		   	"  and c.edin_ccod = f.edin_ccod "& vbCrLf &_
			" 	and isnull(c.pers_ncorr_codeudor, protic.ultimo_aval(e.pers_ncorr))=g.pers_ncorr "& vbCrLf &_
			"  and h.pers_ncorr = g.pers_ncorr "& vbCrLf &_
			"  and h.ciud_ccod *= i.ciud_ccod "& vbCrLf &_
			"  and h.tdir_ccod = 1 "& vbCrLf &_
		   	"  and cast(a.envi_ncorr as varchar)= '" & folio_envio & "'"
'response.Write("<pre>"&consulta&"</pre>")
f_detalle_envio.Consultar consulta

%>
<html>
<head>
<title>Detalle Envio a Cobranza</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
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
    <td><strong>:</strong> <%=folio_envio%></td>
    <td><div align="left"><font size="2"> </font></div></td>
    <td><strong>Fecha</strong></td>
    <td><strong>:</strong> <%=fecha%> </td>
  </tr>
  <tr> 
    <td><strong>Empresa</strong></td>
    <td><strong>:</strong> <%=empresa_envio%> </td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%">&nbsp;</td>
    <td width="26%">&nbsp;</td>
    <td width="14%"><div align="left"><font size="2"> </font></div></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>

<table width="114%" border="1">
  <tr> 
    <td width="9%"><div align="center"><strong>N&ordm; Documento</strong></div></td>
    <td width="20%" align="center"><strong>Tipo</strong> </td>
    <td width="20%" align="center"><strong>N&ordm; Cuenta Corriente</strong></td>
    <td width="20%"><div align="center"><strong>Estado</strong></div></td>
    <td width="11%"><div align="center"><strong>Rut Alumno</strong></div></td>
    <td width="16%"><div align="center"><strong>Rut Apoderado</strong></div></td>
    <td width="11%"><div align="center"><strong>Apoderado</strong></div></td>
<td width="11%"><div align="center"><strong>Apellido Paterno</strong></div></td>
<td width="11%"><div align="center"><strong>Apellido Materno</strong></div></td>
    <td width="14%"><div align="center"><strong>Fecha Emisi&oacute;n</strong></div></td>
    <td width="14%"><div align="center"><strong>Fecha Vencimiento</strong></div></td>
    <td width="19%"><div align="center"><strong>Monto Letra</strong></div></td>
    <td width="19%"><div align="center"><strong>Saldo</strong></div></td>
    <td width="19%"><strong>Multa Protesto</strong></td>
	<td width="19%"><div align="center"><strong>Direccion Apoderado</strong></div></td>
<td width="19%"><div align="center"><strong>Comuna</strong></div></td>
<td width="19%"><div align="center"><strong>Ciudad</strong></div></td>
	<td width="19%"><div align="center"><strong>Telefono</strong></div></td>
  </tr>
  <%  while f_detalle_envio.Siguiente %>
  <tr> 
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("ding_ndocto")%></div></td>
    <td align="center"><%=f_detalle_envio.ObtenerValor("ting_tdesc")%></td>
    <td align="center"><%=f_detalle_envio.ObtenerValor("ding_tcuenta_corriente")%></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("edin_tdesc")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("rut_alumno")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("rut_apoderado")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("nombre_apoderado")%></div></td>
<td><div align="center"><%=f_detalle_envio.ObtenerValor("apellido_paterno")%></div></td>
<td><div align="center"><%=f_detalle_envio.ObtenerValor("apellido_materno")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("fecha_envio")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("ding_fdocto")%></div></td>
    <td><div align="right"><%=f_detalle_envio.ObtenerValor("ding_mdocto")%></div></td>
    <td><div align="right"><%=f_detalle_envio.ObtenerValor("saldo")%></div></td>
    <td><div align="right"><%=f_detalle_envio.ObtenerValor("multa_protesto")%></div></td> 
	<td><div align="right"><%=f_detalle_envio.ObtenerValor("direccion")%></div></td>
<td><div align="right"><%=f_detalle_envio.ObtenerValor("comuna")%></div></td>
<td><div align="right"><%=f_detalle_envio.ObtenerValor("ciudad")%></div></td>
	<td><div align="right"><%=f_detalle_envio.ObtenerValor("telefono")%></div></td>
  </tr>
  <%  wend %>
</table>
<div align="center"></div>
</body>
</html>