<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=Reporte_Cheques.xls"
Response.ContentType = "application/vnd.ms-excel"
'------------------------------------------------------------------------------------
set pagina = new CPagina
'-----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
Usuario = negocio.ObtenerUsuario()
'------------------------------------------------------------------------------------
 sede 					= request.querystring("busqueda[0][sede_ccod]")
 rut_alumno 			= request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito 		= request.querystring("busqueda[0][pers_xdv]")
 rut_apoderado 			= request.querystring("busqueda[0][code_nrut]")
 rut_apoderado_digito 	= request.querystring("busqueda[0][code_xdv]")
 num_doc 				= request.querystring("busqueda[0][ding_ndocto]")
 estado_cheque 			= request.querystring("busqueda[0][edin_ccod]")
 num_cuenta 			= request.querystring("busqueda[0][ding_tcuenta_corriente]")
 inicio 				= request.querystring("busqueda[0][inicio]")
 termino 				= request.querystring("busqueda[0][termino]")
 v_tipo_doc 			= request.querystring("busqueda[0][ting_ccod]") 

'----------------------------------------------------------------------------
consulta = "SELECT pers_ncorr FROM personas WHERE pers_nrut='" & Usuario & "'"
pers_ncorr = conexion.ConsultaUno(consulta)

 
set f_cheques = new CFormulario
f_cheques.Carga_Parametros "Reporte_Cheques.xml", "f_cheques_excel"
f_cheques.Inicializar conexion


if v_tipo_doc <> "" then
	filtro_docto = " and a.ting_ccod in ("&v_tipo_doc&") "& vbCrLf
else
	filtro_docto = " and a.ting_ccod in (3,38,14) "
end if
		
consulta = "select a.ding_ndocto,a.banc_ccod,b.mcaj_ncorr,protic.obtener_envio(a.ingr_ncorr) as envi_ncorr, max(e.banc_tdesc) as banc_tdesc, "& vbCrLf &_
		"          convert(varchar,max(b.ingr_fpago),103) as ingr_fpago,convert(varchar,max(a.ding_fdocto),103) as ding_fdocto, "& vbCrLf &_
		" 		   case when protic.documento_pagado_x_regularizacion(a.ingr_ncorr,a.ding_bpacta_cuota,'P' )=1 " & vbCrLf &_
		" 		   and protic.documento_pagado_x_regularizacion(a.ingr_ncorr,a.ding_bpacta_cuota,'A' )=a.ding_mdocto " & vbCrLf &_
		"		   and g.edin_tdesc='PAGADO' then (select ereg_tdesc from estados_regularizados where ereg_ccod=protic.documento_pagado_x_regularizacion(a.ingr_ncorr,a.ding_bpacta_cuota,'T')) else g.edin_tdesc end as edin_tdesc, " & vbCrLf &_
		"          max(b.ingr_mtotal) as ding_mdocto, protic.obtener_rut(b.pers_ncorr) as rut_alumno,"& vbCrLf &_
		"          protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre_alumno,"& vbCrLf &_
		"          protic.obtener_nombre_completo(a.pers_ncorr_codeudor,'n') as nombre_apoderado,"& vbCrLf &_
		"          protic.obtener_rut(a.pers_ncorr_codeudor) as rut_apoderado , max(a.ding_tcuenta_corriente) as ding_tcuenta_corriente, "& vbCrLf &_
		"		   protic.documento_pagado_x_otro(a.ingr_ncorr,a.ding_bpacta_cuota,'A') as abonado, "& vbCrLf &_
		"		   max(b.ingr_mtotal)-protic.documento_pagado_x_otro(a.ingr_ncorr,a.ding_bpacta_cuota,'A') as saldo, "& vbCrLf &_
		" 		  (select sede_tdesc from sedes where sede_ccod=isnull(max(a.sede_actual),case when max(b.ingr_fpago) < '03/12/2006' then 1 else max(m.sede_ccod) end) ) as sede_actual " & vbCrLf &_
		"   from detalle_ingresos a (nolock) "& vbCrLf &_
        " join ingresos b (nolock)"& vbCrLf &_
        "    on a.ingr_ncorr = b.ingr_ncorr "& vbCrLf &_
		" join movimientos_cajas m (nolock) "& vbCrLf &_
		"    on b.mcaj_ncorr = m.mcaj_ncorr "& vbCrLf &_
        " join abonos c (nolock) "& vbCrLf &_
        "    on b.ingr_ncorr = c.ingr_ncorr "& vbCrLf &_
        " join compromisos d (nolock) "& vbCrLf &_
        "    on c.tcom_ccod = d.tcom_ccod  "& vbCrLf &_
		"    and c.inst_ccod = d.inst_ccod  "& vbCrLf &_
		"    and c.comp_ndocto = d.comp_ndocto "& vbCrLf &_
        "    and c.pers_ncorr = d.pers_ncorr "& vbCrLf &_
        " left outer join bancos e "& vbCrLf &_
        "    on a.banc_ccod = e.banc_ccod "& vbCrLf &_
        " left outer join envios f  "& vbCrLf &_
        "    on a.envi_ncorr = f.envi_ncorr "& vbCrLf &_
        " join estados_detalle_ingresos g"& vbCrLf &_
        "    on a.edin_ccod = g.edin_ccod"& vbCrLf &_
        " join personas h (nolock)  "& vbCrLf &_
        "    on b.pers_ncorr = h.pers_ncorr"& vbCrLf &_
        " left outer join personas i (nolock) "& vbCrLf &_
        "    on a.pers_ncorr_codeudor = i.pers_ncorr"& vbCrLf &_
		" where d.ecom_ccod <> 3 "& vbCrLf &_
		" "&filtro_docto&" "& vbCrLf &_
		"  and a.ding_ncorrelativo >= 1 "& vbCrLf &_
		"  and b.eing_ccod <> 3  "

					
					if sede <> "" then
					  consulta = consulta &  "And isnull(a.sede_actual,case when b.ingr_fpago < '03/12/2006' then 1 else m.sede_ccod end) = '" & sede & "' "& vbCrLf
					end if
				  
					if inicio <> "" or termino <> "" then
					  consulta = consulta &  "AND convert(datetime,a.ding_fdocto,103) BETWEEN  isnull(convert(datetime,'" & inicio & "',103),convert(datetime,a.ding_fdocto,103)) and isnull(convert(datetime,'" & termino & "',103),convert(datetime,a.ding_fdocto,103))"& vbCrLf
					end if 
					
					if rut_alumno <> "" then
					  consulta = consulta &  "AND h.pers_nrut = '" & rut_alumno & "' "& vbCrLf
					end if
					
					if rut_apoderado <> "" then
					  consulta = consulta &  "AND i.pers_nrut = '" & rut_apoderado & "' "& vbCrLf
					end if
					
					if num_doc <> "" then                   
				      consulta = consulta &  "AND a.ding_ndocto = '" & num_doc & "' "& vbCrLf
					end if
					
					if estado_cheque <> "" then
  					   consulta = consulta & " AND g.fedi_ccod = '" & estado_cheque & "' "& vbCrLf
					 end if
					
					if num_cuenta <> "" then
					   consulta = consulta & " AND a.ding_tcuenta_corriente = '" & num_cuenta & "' "
					end if
					consulta = consulta & " group by a.ingr_ncorr,b.mcaj_ncorr,a.ding_ndocto,a.banc_ccod,f.envi_ncorr,b.pers_ncorr,a.pers_ncorr_codeudor ,a.ding_bpacta_cuota, a.ding_mdocto ,g.edin_tdesc "
					consulta = consulta & " order by a.ding_fdocto asc, a.ding_ndocto asc "

'response.Write("<pre>"&consulta&"</pre>")
			  
f_cheques.Consultar consulta

%>
<html>
<head>
<title> Reporte Cheques</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table border="1">
  <tr> 
	<td width="11%"><div align="center"><strong>Caja Origen</strong></div></td>
	<td width="11%"><div align="center"><strong>Deposito</strong></div></td>
    <td width="11%"><div align="center"><strong>N&ordm; Cheque</strong></div></td>
    <td width="11%"><div align="center"><strong>Banco</strong></div></td>
	<td width="11%"><div align="center"><strong>Cuenta Corriente</strong></div></td>
    <td width="11%"><div align="center"><strong>F. Vencimiento</strong></div></td>
    <td width="14%"><div align="center"><strong>Estado</strong></div></td>
    <td width="8%"><div align="center"><strong>Rut Alumno </strong></div></td>
    <td width="8%"><div align="center"><strong>Nombre Alumno </strong></div></td>
    <td width="8%"><div align="center"><strong>Rut Titular</strong></div></td>
    <td width="11%"><div align="center"><strong>Nombre Titular</strong></div></td>
    <td width="11%"><div align="center"><strong>Monto ($)</strong></div></td>
	<td width="11%"><div align="center"><strong>Abonado ($)</strong></div></td>
	<td width="11%"><div align="center"><strong>Saldo ($)</strong></div></td>
	<td width="11%"><div align="center"><strong>Sede Actual</strong></div></td>
  </tr>
  <%  while f_cheques.Siguiente %>
  <tr> 
  	<td><div align="right"><%=f_cheques.ObtenerValor("mcaj_ncorr")%></div></td>
	<td><div align="right"><%=f_cheques.ObtenerValor("envi_ncorr")%></div></td>
    <td><%=f_cheques.ObtenerValor("ding_ndocto")%></td>
    <td><%=f_cheques.ObtenerValor("banc_tdesc")%></td>
	<td><div align="left"><%=f_cheques.ObtenerValor("ding_tcuenta_corriente")%></div></td>
	<td><div align="left"><%=f_cheques.ObtenerValor("ding_fdocto")%></div></td>
    <td><div align="left"><%=f_cheques.ObtenerValor("edin_tdesc")%></div></td>
    <td><%=f_cheques.ObtenerValor("rut_alumno")%></td>
    <td><%=f_cheques.ObtenerValor("nombre_alumno")%></td>
    <td><div align="left"><%=f_cheques.ObtenerValor("rut_apoderado")%></div></td>
    <td><div align="left"><%=f_cheques.ObtenerValor("nombre_apoderado")%></div></td>
    <td><div align="right"><%=f_cheques.ObtenerValor("ding_mdocto")%></div></td>
	<td><div align="right"><%=f_cheques.ObtenerValor("abonado")%></div></td>
	<td><div align="right"><%=f_cheques.ObtenerValor("saldo")%></div></td>
	<td><div align="right"><%=f_cheques.ObtenerValor("sede_actual")%></div></td>
  </tr>
  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>