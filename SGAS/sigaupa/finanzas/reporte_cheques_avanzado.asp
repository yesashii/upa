<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO: FINANZAS
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:25/04/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			: 142
'*******************************************************************
Server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=reporte_cheques_avanzado.xls"
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
 inicio 				= request.querystring("busqueda[0][inicio]")
 termino 				= request.querystring("busqueda[0][termino]")
 rut_alumno 			= request.querystring("busqueda[0][pers_nrut]")
 num_doc 				= request.querystring("busqueda[0][ding_ndocto]")
 estado_doc 			= request.querystring("busqueda[0][edin_ccod]")
 v_inen_ccod 			= Request.QueryString("busqueda[0][inen_ccod]")
 rut_alumno_digito 		= request.querystring("busqueda[0][pers_xdv]")
 rut_apoderado 			= request.querystring("busqueda[0][code_nrut]")
 rut_apoderado_digito 	= request.querystring("busqueda[0][code_xdv]")
 v_tipo_doc 			= request.querystring("busqueda[0][ting_ccod]")
 
'------------------------------------------------------------------------------------

consulta = "SELECT pers_ncorr FROM personas WHERE pers_nrut='" & Usuario & "'"
pers_ncorr = conexion.ConsultaUno(consulta)
'response.Write(pers_ncorr)
'f_busqueda.AgregaCampoParam "sede_ccod","destino", "(select a.sede_ccod, d.sede_tdesc from sis_sedes_usuarios a, sis_usuarios b, personas c, sedes d where a.pers_ncorr = b.pers_ncorr and b.pers_ncorr = c.pers_ncorr and a.sede_ccod = d.sede_ccod and a.pers_ncorr =" & pers_ncorr & ")"
'----------------------------------------------------------------------------

set f_letras = new CFormulario
f_letras.Carga_Parametros "Reporte_Letras.xml", "f_letras_excel"
f_letras.Inicializar conexion


if v_tipo_doc <> "" then
	filtro_docto = " and a.ting_ccod in ("&v_tipo_doc&") "& vbCrLf
else
	filtro_docto = " and a.ting_ccod in (3,38,14) "
end if

					
consulta = 	" Select  b.mcaj_ncorr,protic.obtener_envio(a.ingr_ncorr) as envi_ncorr,a.banc_ccod, a.ding_ndocto, convert(varchar,max(b.ingr_fpago),103) as ingr_fpago, " & vbCrLf &_
				" 		case when protic.documento_pagado_x_regularizacion(a.ingr_ncorr,a.ding_bpacta_cuota,'P' )=1 " & vbCrLf &_
				" 		and protic.documento_pagado_x_regularizacion(a.ingr_ncorr,a.ding_bpacta_cuota,'A' )=a.ding_mdocto " & vbCrLf &_
				"		and d.edin_tdesc='PAGADO' then (select ereg_tdesc from estados_regularizados where ereg_ccod=protic.documento_pagado_x_regularizacion(a.ingr_ncorr,a.ding_bpacta_cuota,'T')) else d.edin_tdesc end as edin_tdesc, " & vbCrLf &_
				"       convert(varchar,max(a.ding_fdocto),103) as ding_fdocto, max(b.ingr_mtotal) as ding_mdocto, " & vbCrLf &_
				"       protic.obtener_rut(b.pers_ncorr) as rut_alumno, protic.obtener_rut(a.pers_ncorr_codeudor) as rut_apoderado, " & vbCrLf &_
				"       max(k.ciud_tdesc) as ciud_tdesc, max(k.ciud_tcomuna) as ciud_tcomuna, max(g.pers_tnombre) as nombre_apoderado, " & vbCrLf &_
				" 		max(g.pers_tape_paterno) as pers_tape_paterno , max(g.pers_tape_materno) as pers_tape_materno, "& vbCrLf &_
				" 		protic.obtener_direccion_letra(a.pers_ncorr_codeudor,1,'CNPB') as direccion, max(g.pers_tfono) as pers_tfono, "& vbCrLf &_
				" 		(select sede_tdesc from sedes where sede_ccod=isnull(max(a.sede_actual),case when max(b.ingr_fpago) < '03/12/2006' then 1 else max(m.sede_ccod) end) ) as sede_actual " & vbCrLf &_
				" From detalle_ingresos a (nolock) " & vbCrLf &_
				"    join   ingresos b (nolock) " & vbCrLf &_
				"        on a.ingr_ncorr = b.ingr_ncorr " & vbCrLf &_
				" 	 join movimientos_cajas m (nolock) "& vbCrLf &_
				"    	 on b.mcaj_ncorr = m.mcaj_ncorr "& vbCrLf &_
				"    left outer join   envios c (nolock) " & vbCrLf &_
				"        on a.envi_ncorr = c.envi_ncorr " & vbCrLf &_
				"    join   estados_detalle_ingresos d (nolock) " & vbCrLf &_
				"        on a.edin_ccod = d.edin_ccod " & vbCrLf &_
				"    left outer join   instituciones_envio e " & vbCrLf &_
				"        on c.inen_ccod = e.inen_ccod  " & vbCrLf &_
				"    join   personas f (nolock) " & vbCrLf &_
				"        on b.pers_ncorr = f.pers_ncorr " & vbCrLf &_
				"    left outer join   personas g (nolock) " & vbCrLf &_
				"        on a.pers_ncorr_codeudor = g.pers_ncorr  " & vbCrLf &_
				"    left outer join direcciones j (nolock) " & vbCrLf &_
				"        on g.pers_ncorr = j.pers_ncorr  " & vbCrLf &_
				" 	 	 and j.tdir_ccod=1 "& vbCrLf &_
				"    left outer join ciudades k (nolock) " & vbCrLf &_
				"        on j.ciud_ccod = k.ciud_ccod  " & vbCrLf &_
				"    join   abonos h (nolock) " & vbCrLf &_
				"        on b.ingr_ncorr = h.ingr_ncorr " & vbCrLf &_
				"    join   compromisos i (nolock) " & vbCrLf &_
				"        on h.tcom_ccod = i.tcom_ccod  " & vbCrLf &_
				"        and h.inst_ccod = i.inst_ccod  " & vbCrLf &_
				"        and h.comp_ndocto = i.comp_ndocto " & vbCrLf &_
				"    	 and h.pers_ncorr = i.pers_ncorr "& vbCrLf &_
				" Where i.ecom_ccod <> 3   " & vbCrLf &_
				" "&filtro_docto&" "& vbCrLf &_
				"    and a.ding_ncorrelativo > 0    " & vbCrLf &_
				"    and b.eing_ccod <> 3  " 
				
					
					
					if sede <> "" then
					  consulta = consulta &  "And isnull(a.sede_actual,case when b.ingr_fpago < '03/12/2006' then 1 else m.sede_ccod end) = '" & sede & "' "& vbCrLf
					end if
				  
					if inicio <> "" or termino <> "" then
					  'consulta = consulta &  "AND protic.trunc(a.ding_fdocto) BETWEEN  isnull('" & inicio & "',a.ding_fdocto) and isnull('" & termino & "',a.ding_fdocto) "& vbCrLf
					  consulta = consulta &  "AND convert(datetime,a.ding_fdocto,103) BETWEEN  isnull(convert(datetime,'" & inicio & "',103),convert(datetime,a.ding_fdocto,103)) and isnull(convert(datetime,'" & termino & "',103),convert(datetime,a.ding_fdocto,103))"& vbCrLf
					end if 
					
					if rut_alumno <> "" then
					  consulta = consulta &  "AND f.pers_nrut = '" & rut_alumno & "' "& vbCrLf
					end if
					
					if rut_apoderado <> "" then
					  consulta = consulta &  "AND g.pers_nrut = '" & rut_apoderado & "' "& vbCrLf
					end if
					
					if num_doc <> "" then                   
				      consulta = consulta &  "AND a.ding_ndocto = '" & num_doc & "' "& vbCrLf
					end if
					
					if estado_doc <> "" then
  					   consulta = consulta & " AND d.fedi_ccod = '" & estado_doc & "' "& vbCrLf
					 end if
					 
					 if v_inen_ccod <> "" then
  					   consulta = consulta & " AND case when d.udoc_ccod = 2 then e.inen_ccod end = '" & v_inen_ccod & "' "& vbCrLf
					 end if
					 consulta = consulta & " group by a.ingr_ncorr,b.mcaj_ncorr,a.ding_ndocto,a.banc_ccod,a.envi_ncorr,b.pers_ncorr,a.pers_ncorr_codeudor,a.ding_bpacta_cuota, a.ding_mdocto ,d.edin_tdesc "
'					 consulta = consulta & "order by a.ding_ndocto asc, a.ding_fdocto asc, b.ingr_fpago asc"
					 consulta = consulta & "order by a.ding_ndocto asc, ding_fdocto asc, ingr_fpago asc"
'response.Write("<PRE>" & consulta & "</PRE>")
'response.End()				 
f_letras.Consultar consulta


%>
<html>
<head>
<title> Reporte Cheques Avanzado </title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="75%" border="1">
  <tr>
  	<td width="11%"><div align="center"><strong>Caja Origen</strong></div></td>
	<td width="11%"><div align="center"><strong>Deposito</strong></div></td> 
    <td width="11%"><div align="center"><strong>N&ordm; Cheque</strong></div></td>
	<td width="11%"><div align="center"><strong>Banco</strong></div></td>
    <td width="11%"><div align="center"><strong>Estado</strong></div></td>
    <td width="11%"><div align="center"><strong>F. Emisi&oacute;n</strong></div></td>
    <td width="14%"><div align="center"><strong>F. Vencimiento</strong></div></td>
    <td width="8%"><div align="center"><strong>Monto ($)</strong></div></td>
    <td width="11%"><div align="center"><strong>Rut Alumno</strong></div></td>
    <td width="11%"><div align="center"><strong>Rut Apoderado</strong></div></td>
	<td width="11%"><div align="center"><strong>Apellido Paterno</strong></div></td>
	<td width="11%"><div align="center"><strong>Apellido Materno</strong></div></td>
	<td width="11%"><div align="center"><strong>Nombre Apoderado</strong></div></td>
    <td width="11%"><div align="center"><strong>Direccion Apoderado</strong></div></td>
	<td width="11%"><div align="center"><strong>Ciudad</strong></div></td>
	<td width="11%"><div align="center"><strong>Comuna</strong></div></td>
	<td width="11%"><div align="center"><strong>Telefono</strong></div></td>
	<td width="11%"><div align="center"><strong>Sede Actual</strong></div></td>

  </tr>
  <%  while f_letras.Siguiente %>
  <tr>
  	<td><div align="right"><%=f_letras.ObtenerValor("mcaj_ncorr")%></div></td>
	<td><div align="right"><%=f_letras.ObtenerValor("envi_ncorr")%></div></td> 
    <td><%=f_letras.ObtenerValor("ding_ndocto")%></td>
	 <td><%=f_letras.ObtenerValor("banc_ccod")%></td>
    <td><%=f_letras.ObtenerValor("edin_tdesc")%></td>
    <td><div align="left"><%=f_letras.ObtenerValor("ingr_fpago")%></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("ding_fdocto")%></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("ding_mdocto")%></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("rut_alumno")%></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("rut_apoderado")%></div></td>
	<td><div align="left"><%=f_letras.ObtenerValor("pers_tape_paterno")%></div></td>
	<td><div align="left"><%=f_letras.ObtenerValor("pers_tape_materno")%></div></td>
	<td><div align="left"><%=f_letras.ObtenerValor("nombre_apoderado")%></div></td>
    <td><%=f_letras.ObtenerValor("direccion")%></td>
	<td><%=f_letras.ObtenerValor("ciud_tcomuna")%></td>
	<td><%=f_letras.ObtenerValor("ciud_tdesc")%></td>
	<td><%=f_letras.ObtenerValor("pers_tfono")%></td>
	<td><%=f_letras.ObtenerValor("sede_actual")%></td>
  </tr>

  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>