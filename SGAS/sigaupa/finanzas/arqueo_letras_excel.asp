<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 3000 
Response.AddHeader "Content-Disposition", "attachment;filename=Reporte_Letras.xls"
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
 sede 					= request.querystring("busqueda[0][sede_ccod]")
 sede_caja 				= request.querystring("busqueda[0][sede_caja]")
 inicio 				= request.querystring("busqueda[0][inicio]")
 termino 				= request.querystring("busqueda[0][termino]")
 rut_alumno 			= request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito 		= request.querystring("busqueda[0][pers_xdv]")
 rut_apoderado 			= request.querystring("busqueda[0][code_nrut]")
 rut_apoderado_digito 	= request.querystring("busqueda[0][code_xdv]")
 num_doc 				= request.querystring("busqueda[0][ding_ndocto]")
 estado_letra 			= request.querystring("busqueda[0][edin_ccod]")
 tipo_ingreso 			= request.querystring("busqueda[0][ting_ccod]")
 v_inen_ccod 			= Request.QueryString("busqueda[0][inen_ccod]")

'----------------------------------------------------------------------------

set f_letras = new CFormulario
f_letras.Carga_Parametros "Reporte_Letras.xml", "f_letras_excel"
f_letras.Inicializar conexion

					
consulta = 	" Select  a.envi_ncorr, a.ding_ndocto, d.edin_tdesc, convert(varchar,b.ingr_fpago,103) as ingr_fpago, " & vbCrLf &_
				"        convert(varchar,a.ding_fdocto,103) as ding_fdocto, a.ding_mdocto, " & vbCrLf &_
				"        protic.obtener_rut(b.pers_ncorr) as rut_alumno, " & vbCrLf &_
				"        protic.obtener_rut(a.pers_ncorr_codeudor) as rut_apoderado, " & vbCrLf &_
				"        case d.udoc_ccod when 2 then e.inen_tdesc end as institucion, " & vbCrLf &_
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
				" Where i.ecom_ccod <> 3   " & vbCrLf &_
				"    and b.eing_ccod not in (1,3)   " & vbCrLf &_
				"    and a.ding_ncorrelativo > 0    " & vbCrLf &_
				"    and a.ting_ccod = '"&tipo_ingreso&"'   " 	
					
					
					if sede_caja <> "" then
					  consulta = consulta &  "AND isnull(a.sede_actual,case when b.ingr_fpago < '03/12/2006' then 1 else m.sede_ccod end) = '" & sede_caja & "' "& vbCrLf
					end if

					if sede <> "" then
					  consulta = consulta &  "AND i.sede_ccod = '" & sede & "' "& vbCrLf
					end if
				  
					if inicio <> "" or termino <> "" then
					  'consulta = consulta &  "AND protic.trunc(a.ding_fdocto) BETWEEN  isnull('" & inicio & "',a.ding_fdocto) and isnull('" & termino & "',a.ding_fdocto) "& vbCrLf
					  consulta = consulta &  "AND convert(datetime,a.ding_fdocto,103) BETWEEN  isnull(convert(datetime,'" & inicio & "',103),convert(datetime,a.ding_fdocto,103)) and isnull(convert(datetime,'" & termino & "',103),convert(datetime,a.ding_fdocto,103))"& vbCrLf
					end if 
			
					if estado_letra <> "" and estado_letra <> "54" and estado_letra <> "50" and estado_letra <> "49"  and estado_letra <> "7"  then
  					   consulta = consulta & " AND d.fedi_ccod = '" & estado_letra & "' "& vbCrLf
					 end if
					 
					 if estado_letra = "54" then
  					   consulta = consulta & " AND d.fedi_ccod = '23' "& vbCrLf
					 end if
					 
					  if estado_letra = "50" then
  					   consulta = consulta & " AND a.edin_ccod = '50' "& vbCrLf
					 end if
					 
					  if estado_letra = "49" then
  					   consulta = consulta & " AND a.edin_ccod = '49' "& vbCrLf
					 end if
					 
					 if estado_letra = "7" then
  					   consulta = consulta & " AND a.edin_ccod = '7' "& vbCrLf
					 end if
					 
					 if v_inen_ccod <> "" then
  					   consulta = consulta & " AND case when d.udoc_ccod = 2 then e.inen_ccod end = '" & v_inen_ccod & "' "& vbCrLf
					 end if
					 
					 consulta = consulta & "order by a.ding_ndocto asc,a.edin_ccod,a.ding_fdocto asc, b.ingr_fpago asc"
'response.Write("<PRE>" & consulta & "</PRE>")
'response.End()					 
f_letras.Consultar consulta


%>
<html>
<head>
<title> Detalle Envio a Banco</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="75%" border="1">
  <tr> 
    <td width="11%"><div align="center"><strong>N&ordm; Letra</strong></div></td>
    <td width="11%"><div align="center"><strong>Estado</strong></div></td>
    <td width="11%"><div align="center"><strong>F. Emisi&oacute;n</strong></div></td>
    <td width="14%"><div align="center"><strong>F. Vencimiento</strong></div></td>
    <td width="8%"><div align="center"><strong>Monto ($)</strong></div></td>
    <td width="11%"><div align="center"><strong>Rut Alumno</strong></div></td>
    <td width="11%"><div align="center"><strong>Rut Apoderado</strong></div></td>
    <td width="11%"><div align="center"><strong>Instituci&oacute;n</strong></div></td>
	<td width="11%"><div align="center"><strong>N� Comprobante</strong></div></td>
	<td width="11%"><div align="center"><strong>N� Caja</strong></div></td>
	<td width="11%"><div align="center"><strong>Sede Actual</strong></div></td>
  </tr>
  <%  while f_letras.Siguiente %>
  <tr> 
    <td><div align="left"><%=f_letras.ObtenerValor("ding_ndocto")%></div></td>
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
  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>