<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 150000 
Response.AddHeader "Content-Disposition", "attachment;filename=resumen_excel_flujos.xls"
Response.ContentType = "application/vnd.ms-excel"
 
'---------------------------------------------------------------------------------------------------


'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion

v_fecha_corte  = request.querystring("busqueda[0][ding_fdocto]")

'**********************************************************************************
set f_flujo = new CFormulario
f_flujo.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_flujo.inicializar conexion 
		

sql_flujo=	" select  protic.obtener_rut(a.pers_ncorr) as rut,c.ting_tdesc as tipo_docto, " & vbCrLf &_
			"	b.ding_ndocto as numero_docto,b.ding_ncorrelativo as correlativo,cast(b.ding_mdetalle as numeric) as detalle, " & vbCrLf &_
			"	cast(b.ding_mdocto as numeric) as total_docto,protic.trunc(b.ding_fdocto) as fecha_docto,d.edin_tdesc as estado_docto," & vbCrLf &_
			"	case when a.ting_ccod=15 then " & vbCrLf &_
			"		(select top 1 peri_tdesc from periodos_academicos where anos_ccod>=year(getdate()) and plec_ccod=1 order by peri_ccod asc) " & vbCrLf &_
			"		else (select top 1 peri_tdesc  from abonos ab, periodos_academicos pa where ab.peri_ccod=pa.peri_ccod and ab.ingr_ncorr=a.ingr_ncorr) end as periodo, " & vbCrLf &_
			"		(select sede_tdesc from sedes where sede_ccod in ((isnull((select top 1 sede_ccod from alumnos al, ofertas_academicas oa where al.ofer_ncorr=oa.ofer_ncorr and al.pers_ncorr=a.pers_ncorr  " & vbCrLf &_
			"		and oa.peri_ccod in (select top 1 pa.peri_ccod  from abonos ab, periodos_academicos pa where ab.peri_ccod=pa.peri_ccod and ab.ingr_ncorr=a.ingr_ncorr)),1)))) as sede " & vbCrLf &_
			"	from ingresos a (nolock), detalle_ingresos b (nolock),  " & vbCrLf &_
			"	tipos_ingresos c, estados_detalle_ingresos d " & vbCrLf &_
			"	where a.ingr_ncorr=b.ingr_ncorr " & vbCrLf &_
			"		and a.eing_ccod=4  " & vbCrLf &_ 
			"		and b.ting_ccod in (3,4,13,38,51,52,59,66) " & vbCrLf &_ 
			"		and convert(datetime,ding_fdocto,103)>=convert(datetime,'"&v_fecha_corte&"',103) " & vbCrLf &_
			"		and b.edin_ccod not in (6,11) " & vbCrLf &_
			"		and b.ingr_ncorr not in (select ingr_ncorr from documento_pagado) " & vbCrLf &_ 
			"		and b.ting_ccod=c.ting_ccod " & vbCrLf &_
			"		and b.edin_ccod=d.edin_ccod " & vbCrLf &_
			"		order by ding_fdocto, b.ting_ccod	"


		if not Esvacio(Request.QueryString) then
		'response.Write("<pre>"&sql_flujo&"</pre>")
		'response.End()
			f_flujo.Consultar sql_flujo

		else
			vacia = "select '' where 1=2 "
			
			f_flujo.Consultar vacia
			f_flujo.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"
		end if


%>
<html>
<head>
<title>Flujo de vencimientos</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif"> Flujo de vencimientos </font></div>
	  <div align="right"></div></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
  </tr>
</table>

<font color="#0000FF" size="+1" ><strong>Resumen</strong></font>
<table width="100%" border="1">
	   <tr> 
		<td bgcolor="#66CC99" colspan="10"><div align="center"><strong>Detalle Documentos</strong></div></td>
	  </tr>

  <tr> 
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>rut</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>tipo_docto</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>numero_docto</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>correlativo</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>detalle</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>total_docto</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>fecha_docto</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>estado_docto</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>periodo</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>sede</strong></div></td>
  </tr>
  <% fila = 1 
     while f_flujo.Siguiente %>
  <tr> 
	<td><div align="center"><%=f_flujo.ObtenerValor("rut")%></div></td>
    <td><div align="center"><%=f_flujo.ObtenerValor("tipo_docto")%></div></td>
	<td><div align="center"><%=f_flujo.ObtenerValor("numero_docto")%></div></td>
	<td><div align="center"><%=f_flujo.ObtenerValor("correlativo")%></div></td>
	<td><div align="center"><%=f_flujo.ObtenerValor("detalle")%></div></td>
	<td><div align="center"><%=f_flujo.ObtenerValor("total_docto")%></div></td>
	<td><div align="center"><%=f_flujo.ObtenerValor("fecha_docto")%></div></td>
	<td><div align="center"><%=f_flujo.ObtenerValor("estado_docto")%></div></td>
	<td><div align="center"><%=f_flujo.ObtenerValor("periodo")%></div></td>
	<td><div align="center"><%=f_flujo.ObtenerValor("sede")%></div></td>
  </tr>
<%
'response.Flush()
  wend %>
</table>
<p></p>
<p></p>
</body>
</html>