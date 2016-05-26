<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 3000 

Response.AddHeader "Content-Disposition", "attachment;filename=arqueo_cheques.xls"
Response.ContentType = "application/vnd.ms-excel"
'------------------------------------------------------------------------------------
set pagina = new CPagina
'------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
Usuario = negocio.ObtenerUsuario()
'------------------------------------------------------------------------------------
 sede = request.querystring("busqueda[0][sede_ccod]")
 sede_caja = request.querystring("busqueda[0][sede_caja]")
 inicio = request.querystring("busqueda[0][inicio]")
 termino = request.querystring("busqueda[0][termino]")
 rut_alumno = request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito = request.querystring("busqueda[0][pers_xdv]")
 rut_apoderado = request.querystring("busqueda[0][code_nrut]")
 rut_apoderado_digito = request.querystring("busqueda[0][code_xdv]")
 num_doc = request.querystring("busqueda[0][ding_ndocto]")
 estado_letra = request.querystring("busqueda[0][edin_ccod]")
 v_inen_ccod = Request.QueryString("busqueda[0][inen_ccod]")

'----------------------------------------------------------------------------


set f_letras = new CFormulario
f_letras.Carga_Parametros "Reporte_Letras.xml", "f_letras_excel"
f_letras.Inicializar conexion

			
					
consulta = 	" Select  a.envi_ncorr, a.ding_ndocto, a.banc_ccod,d.edin_tdesc, convert(varchar,b.ingr_fpago,103) as ingr_fpago, " & vbCrLf &_
				"        convert(varchar,a.ding_fdocto,103) as ding_fdocto, h.abon_mabono as ding_mdocto, (select ting_tdesc from tipos_ingresos where ting_ccod=a.ting_ccod) as tipo_docto," & vbCrLf &_
				"        protic.obtener_rut(b.pers_ncorr) as rut_alumno, " & vbCrLf &_
				"        protic.obtener_rut(a.pers_ncorr_codeudor) as rut_apoderado, " & vbCrLf &_
				"        case d.udoc_ccod when 2 then e.inen_tdesc else " & vbCrLf &_
				" case when(a.edin_ccod =12 or a.edin_ccod=6) then e.inen_tdesc end end as institucion, " & vbCrLf &_
				" b.ingr_nfolio_referencia as comprobante, b.mcaj_ncorr as caja, "& vbCrLf &_
  				" (select sede_tdesc from sedes where sede_ccod=isnull(a.sede_actual,case when b.ingr_fpago < '03/12/2006' then 1 else m.sede_ccod end) ) as sede_actual "& vbCrLf &_
				" From detalle_ingresos a " & vbCrLf &_
				"    join   ingresos b " & vbCrLf &_
				"        on a.ingr_ncorr = b.ingr_ncorr " & vbCrLf &_
				" 	 left outer join movimientos_cajas m "& vbCrLf &_
				"    	 on b.mcaj_ncorr = m.mcaj_ncorr "& vbCrLf &_
				"    left outer join   envios c " & vbCrLf &_
				"        on a.envi_ncorr = c.envi_ncorr " & vbCrLf &_
				"    join   estados_detalle_ingresos d " & vbCrLf &_
				"        on a.edin_ccod = d.edin_ccod " & vbCrLf &_
				"    left outer join   instituciones_envio e " & vbCrLf &_
				"        on c.inen_ccod = e.inen_ccod  " & vbCrLf &_
				"    join   personas f " & vbCrLf &_
				"        on b.pers_ncorr = f.pers_ncorr " & vbCrLf &_
				"    left outer join   personas g " & vbCrLf &_
				"        on a.pers_ncorr_codeudor = g.pers_ncorr  " & vbCrLf &_
				"    join   abonos h " & vbCrLf &_
				"        on b.ingr_ncorr = h.ingr_ncorr " & vbCrLf &_
				"    join   compromisos i " & vbCrLf &_
				"        on h.tcom_ccod = i.tcom_ccod  " & vbCrLf &_
				"        and h.inst_ccod = i.inst_ccod  " & vbCrLf &_
				"        and h.comp_ndocto = i.comp_ndocto " & vbCrLf &_
				" where i.ecom_ccod <> 3   " & vbCrLf &_
				"    and a.ting_ccod in (3,38)    " & vbCrLf &_
				"    and a.ding_ncorrelativo > 0    " & vbCrLf &_
				" 	 and a.audi_tusuario not like '%CH-2E%' " & vbCrLf &_
				"    and a.ingr_ncorr not in ( " & vbCrLf &_
				"				 select  da.ingr_ncorr " & vbCrLf &_
				"					from detalle_ingresos da, detalle_ingresos db , ingresos dc " & vbCrLf &_
				"					where da.ding_ndocto=db.ding_ndocto " & vbCrLf &_
				"					and da.banc_ccod =db.banc_ccod " & vbCrLf &_
				"					and da.ding_fdocto =db.ding_fdocto " & vbCrLf &_
				"					and da.ting_ccod =3 " & vbCrLf &_
				"					and db.ting_ccod =38 " & vbCrLf &_
				"					and da.ingr_ncorr=dc.ingr_ncorr " & vbCrLf &_
				"					and dc.eing_ccod not in (3,6) " & vbCrLf &_
				"			) " & vbCrLf &_
				"    and b.eing_ccod not in (1,3)  "	
					
					
					if sede_caja <> "" then
					  consulta = consulta &  "AND isnull(a.sede_actual,case when b.ingr_fpago < '03/12/2006' then 1 else m.sede_ccod end) = '" & sede_caja & "' "& vbCrLf
					end if

					if sede <> "" then
					  consulta = consulta &  "AND i.sede_ccod = '" & sede & "' "& vbCrLf
					end if
				  
					if inicio <> "" or termino <> "" then
					  consulta = consulta &  "AND convert(datetime,a.ding_fdocto,103) BETWEEN  isnull(convert(datetime,'" & inicio & "',103),convert(datetime,a.ding_fdocto,103)) and isnull(convert(datetime,'" & termino & "',103),convert(datetime,a.ding_fdocto,103))"& vbCrLf
					end if 
			
					if estado_letra <> "" then
  					   consulta = consulta & " AND d.fedi_ccod = '" & estado_letra & "' "& vbCrLf
					 end if
					 
					 if v_inen_ccod <> "" then
  					   consulta = consulta & " AND case when d.udoc_ccod = 2 then e.inen_ccod end = '" & v_inen_ccod & "' "& vbCrLf
					 end if
					 
					 consulta = consulta & "order by a.banc_ccod,a.ding_ndocto asc,a.edin_ccod, a.ding_fdocto asc, b.ingr_fpago asc"
					 
f_letras.Consultar consulta

'response.Write("<PRE>" & consulta & "</PRE>")
'response.End()
%>
<html>
<head>
<title>Arqueo Cheques Excel</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="75%" border="1">
  <tr >
    <td width="6%" bgcolor="#FFFFCC"><div align="center"><strong>Tipo Docto</strong></div></td> 
    <td width="6%" bgcolor="#FFFFCC"><div align="center"><strong>N&ordm; Cheque</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Banco</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Estado</strong></div></td>
    <td width="6%" bgcolor="#FFFFCC"><div align="center"><strong>F. Emisi&oacute;n</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>F. Vencimiento</strong></div></td>
    <td width="6%" bgcolor="#FFFFCC"><div align="center"><strong>Monto detalle($)</strong></div></td>
    <td width="6%" bgcolor="#FFFFCC"><div align="center"><strong>Rut Alumno</strong></div></td>
    <td width="9%" bgcolor="#FFFFCC"><div align="center"><strong>Rut Apoderado</strong></div></td>
    <td width="8%" bgcolor="#FFFFCC"><div align="center"><strong>Instituci&oacute;n</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Nº Comprobante</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Nº Caja</strong></div></td>
	<td width="13%" bgcolor="#FFFFCC"><div align="center"><strong>Sede Actual</strong></div></td>

  </tr>
  <%  while f_letras.Siguiente %>
  <tr>
	<td><div align="left"><%=f_letras.ObtenerValor("tipo_docto")%></div></td> 
    <td><div align="left"><%=f_letras.ObtenerValor("ding_ndocto")%></div></td>
	<td><div align="left"><%=f_letras.ObtenerValor("banc_ccod")%></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("edin_tdesc")%></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("ingr_fpago")%></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("ding_fdocto")%></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("ding_mdocto")%></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("rut_alumno")%></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("rut_apoderado")%></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("institucion")%></div></td>
	<td><div align="left"><%=f_letras.ObtenerValor("comprobante")%></div></td>
	<td><div align="left"><%=f_letras.ObtenerValor("caja")%></div></td>
	<td><div align="left"><%=f_letras.ObtenerValor("sede_actual")%></div></td>
  </tr>
  <%  
response.Flush()

wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>