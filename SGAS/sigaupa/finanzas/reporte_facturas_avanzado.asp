<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=reporte_facturas_avanzado.xls"
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

 sede 		= request.querystring("busqueda[0][sede_ccod]")
 inicio 	= request.querystring("busqueda[0][inicio]")
 termino 	= request.querystring("busqueda[0][termino]")
 rut_alumno = request.querystring("busqueda[0][pers_nrut]")
 num_doc 		= request.querystring("busqueda[0][ding_ndocto]")
 estado_letra 	= request.querystring("busqueda[0][edin_ccod]")
 v_inen_ccod 	= Request.QueryString("busqueda[0][inen_ccod]")
 rut_alumno_digito 		= request.querystring("busqueda[0][pers_xdv]")
 rut_apoderado 			= request.querystring("busqueda[0][code_nrut]")
 rut_apoderado_digito 	= request.querystring("busqueda[0][code_xdv]")
 v_ting_ccod 			= Request.QueryString("busqueda[0][ting_ccod]")
'------------------------------------------------------------------------------------

consulta = "SELECT pers_ncorr FROM personas WHERE pers_nrut='" & Usuario & "'"
pers_ncorr = conexion.ConsultaUno(consulta)
'response.Write(pers_ncorr)
'f_busqueda.AgregaCampoParam "sede_ccod","destino", "(select a.sede_ccod, d.sede_tdesc from sis_sedes_usuarios a, sis_usuarios b, personas c, sedes d where a.pers_ncorr = b.pers_ncorr and b.pers_ncorr = c.pers_ncorr and a.sede_ccod = d.sede_ccod and a.pers_ncorr =" & pers_ncorr & ")"
'----------------------------------------------------------------------------

set f_letras = new CFormulario
f_letras.Carga_Parametros "reporte_facturas.xml", "f_facturas_excel"
f_letras.Inicializar conexion

					
consulta = 	" Select   substring(m.ting_tdesc,12,7) as ting_tdesc,b.mcaj_ncorr, a.envi_ncorr, d.edin_tdesc, isnull(a.ding_mdocto,a.ding_mdetalle) as ding_mdocto," & vbCrLf &_
				"        convert(varchar,b.ingr_fpago,103) as ingr_fpago, convert(varchar,a.ding_fdocto,103) as ding_fdocto, "& vbCrLf &_
				"        a.ding_ndocto as numero_factura, protic.obtener_rut(b.pers_ncorr) as rut_alumno, " & vbCrLf &_
				"        k.ciud_tdesc, k.ciud_tcomuna, f.empr_tnombre nombre_empresa,f.empr_trazon_social as razon, " & vbCrLf &_
				" 		 empr_tdireccion as direccion, f.empr_tfono as fono "& vbCrLf &_
				" From detalle_ingresos a " & vbCrLf &_
				"    join   ingresos b " & vbCrLf &_
				"        on a.ingr_ncorr = b.ingr_ncorr " & vbCrLf &_
				"    left outer join   envios c " & vbCrLf &_
				"        on a.envi_ncorr = c.envi_ncorr " & vbCrLf &_
				"    join   estados_detalle_ingresos d " & vbCrLf &_
				"        on a.edin_ccod = d.edin_ccod " & vbCrLf &_
				"    left outer join   instituciones_envio e " & vbCrLf &_
				"        on c.inen_ccod = e.inen_ccod  " & vbCrLf &_
				"    join   empresas f " & vbCrLf &_
				"        on b.pers_ncorr = f.empr_ncorr " & vbCrLf &_
				"    left outer join ciudades k " & vbCrLf &_
				"        on f.ciud_ccod = k.ciud_ccod  " & vbCrLf &_
				"    join   abonos h " & vbCrLf &_
				"        on b.ingr_ncorr = h.ingr_ncorr " & vbCrLf &_
				"    join   compromisos i " & vbCrLf &_
				"        on h.tcom_ccod = i.tcom_ccod  " & vbCrLf &_
				"        and h.inst_ccod = i.inst_ccod  " & vbCrLf &_
				"        and h.comp_ndocto = i.comp_ndocto " & vbCrLf &_
				" 	join tipos_ingresos m " & vbCrLf &_
				" 		on a.ting_ccod=m.ting_ccod " & vbCrLf &_
				" Where i.ecom_ccod <> 3   " & vbCrLf &_
				"    and b.eing_ccod <> 3   " & vbCrLf &_
				"    and a.ding_ncorrelativo > 0 " 
				
					
					
					if sede <> "" then
					  consulta = consulta &  "AND i.sede_ccod = '" & sede & "' "& vbCrLf
					end if

					if v_ting_ccod <> "" then
					  	consulta = consulta &  "AND a.ting_ccod = '" & v_ting_ccod & "' "& vbCrLf
					else
						consulta = consulta &  " AND a.ting_ccod in (49,59) "& vbCrLf
					end if		
				  
					if inicio <> "" or termino <> "" then
					  	consulta = consulta &  "AND convert(datetime,a.ding_fdocto,103) BETWEEN  isnull(convert(datetime,'" & inicio & "',103),convert(datetime,a.ding_fdocto,103)) and isnull(convert(datetime,'" & termino & "',103),convert(datetime,a.ding_fdocto,103))"& vbCrLf
					end if 
					
					if rut_alumno <> "" then
					  consulta = consulta &  "AND f.empr_nrut = '" & rut_alumno & "' "& vbCrLf
					end if
					
					if num_doc <> "" then                   
				      consulta = consulta &  " AND cast(a.ding_ndocto as varchar) = '" & num_doc & "' "& vbCrLf
					end if
					
					if estado_letra <> "" then
  					   consulta = consulta & " AND d.fedi_ccod = '" & estado_letra & "' "& vbCrLf
					 end if
					 
					if v_inen_ccod <> "" then
  					   consulta = consulta & " AND case when d.udoc_ccod = 2 then e.inen_ccod end = '" & v_inen_ccod & "' "& vbCrLf
					end if
					 
					 consulta = consulta & "order by ting_tdesc, numero_factura asc, a.ding_fdocto asc, b.ingr_fpago asc"
					 
f_letras.Consultar consulta

'response.Write("<PRE> " & consulta & "</PRE>")
'response.End()
%>
<html>
<head>
<title> Reporte Letras </title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="75%" border="1">
  <tr> 
    <td width="11%"><div align="center"><strong>Caja Origen</strong></div></td>
	<td width="11%"><div align="center"><strong>Tipo Factura</strong></div></td>	
	<td width="11%"><div align="center"><strong>N&ordm; Factura</strong></div></td>
    <td width="11%"><div align="center"><strong>Estado</strong></div></td>
    <td width="11%"><div align="center"><strong>F. Emisi&oacute;n</strong></div></td>
    <td width="14%"><div align="center"><strong>F. Vencimiento</strong></div></td>
    <td width="8%"><div align="center"><strong>Monto ($)</strong></div></td>
    <td width="11%"><div align="center"><strong>Rut Empresa </strong></div></td>
	<td width="11%"><div align="center"><strong>Razon Social</strong></div></td>
	<td width="11%"><div align="center"><strong>Nombre Empresa </strong></div></td>
    <td width="11%"><div align="center"><strong>Direccion Empresa </strong></div></td>
	<td width="11%"><div align="center"><strong>Ciudad</strong></div></td>
	<td width="11%"><div align="center"><strong>Comuna</strong></div></td>
	<td width="11%"><div align="center"><strong>Telefono</strong></div></td>

  </tr>
  <%  while f_letras.Siguiente %>
  <tr> 
    <td><div align="center"><%=f_letras.ObtenerValor("mcaj_ncorr")%></div></td>
	<td><div align="left"><%=f_letras.ObtenerValor("ting_tdesc")%></div></td>
	<td><%=f_letras.ObtenerValor("numero_factura")%></td>
    <td><%=f_letras.ObtenerValor("edin_tdesc")%></td>
    <td><div align="left"><%=f_letras.ObtenerValor("ingr_fpago")%></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("ding_fdocto")%></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("ding_mdocto")%></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("rut_alumno")%></div></td>
	<td><div align="left"><%=f_letras.ObtenerValor("razon")%></div></td>
	<td><div align="left"><%=f_letras.ObtenerValor("nombre_empresa")%></div></td>
    <td><%=f_letras.ObtenerValor("direccion")%></td>
	<td><%=f_letras.ObtenerValor("ciud_tcomuna")%></td>
	<td><%=f_letras.ObtenerValor("ciud_tdesc")%></td>
	<td><%=f_letras.ObtenerValor("fono")%></td>
  </tr>

  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>