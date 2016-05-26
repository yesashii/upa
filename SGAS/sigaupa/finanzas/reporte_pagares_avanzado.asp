<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=reporte_pagares_avanzado.xls"
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
 
'------------------------------------------------------------------------------------

consulta = "SELECT pers_ncorr FROM personas WHERE pers_nrut='" & Usuario & "'"
pers_ncorr = conexion.ConsultaUno(consulta)
'response.Write(pers_ncorr)
'f_busqueda.AgregaCampoParam "sede_ccod","destino", "(select a.sede_ccod, d.sede_tdesc from sis_sedes_usuarios a, sis_usuarios b, personas c, sedes d where a.pers_ncorr = b.pers_ncorr and b.pers_ncorr = c.pers_ncorr and a.sede_ccod = d.sede_ccod and a.pers_ncorr =" & pers_ncorr & ")"
'----------------------------------------------------------------------------

set f_letras = new CFormulario
f_letras.Carga_Parametros "Reporte_Pagares.xml", "f_pagares_excel"
f_letras.Inicializar conexion

					
consulta = 	" Select   b.mcaj_ncorr, a.envi_ncorr, a.ding_mdocto,cast(a.ding_tcuenta_corriente as varchar) as ding_tcuenta_corriente," & vbCrLf &_
				" 	case  when protic.documento_pagado_x_regularizacion(a.ingr_ncorr,a.ding_bpacta_cuota,'P' )=1 " & vbCrLf &_
				" 	and protic.documento_pagado_x_regularizacion(a.ingr_ncorr,a.ding_bpacta_cuota,'A' )=a.ding_mdocto " & vbCrLf &_
				" 	and d.edin_tdesc='PAGADO' then (select ereg_tdesc from estados_regularizados where ereg_ccod=protic.documento_pagado_x_regularizacion(a.ingr_ncorr,a.ding_bpacta_cuota,'T')) " & vbCrLf &_
				" 	else d.edin_tdesc end as edin_tdesc, " & vbCrLf &_
				"   convert(varchar,b.ingr_fpago,103) as ingr_fpago, convert(varchar,a.ding_fdocto,103) as ding_fdocto, "& vbCrLf &_
				"   case when len(isnull(a.ding_ndocto,0))<=4 then protic.obtener_numero_pagare_pagado(a.ingr_ncorr) else cast(a.ding_ndocto as varchar) end as numero_pagare, " & vbCrLf &_
				"   protic.obtener_rut(b.pers_ncorr) as rut_alumno, " & vbCrLf &_
				"lower(f.PERS_TEMAIL) as email_personal,(select top 1 lower(email_nuevo) from cuentas_email_upa tt where tt.pers_ncorr=b.pers_ncorr) as email_upa, "& vbCrLf &_
				"   protic.obtener_rut(a.pers_ncorr_codeudor) as rut_apoderado, " & vbCrLf &_
				"(select lower(pers_temail) from personas tt where tt.PERS_NCORR=a.pers_ncorr_codeudor) as email_apoderado,"& vbCrLf &_
				"   k.ciud_tdesc, k.ciud_tcomuna, g.pers_tnombre nombre_apoderado,g.pers_tape_paterno, g.pers_tape_materno, " & vbCrLf &_
				" 	protic.obtener_direccion_letra(a.pers_ncorr_codeudor,1,'CNPB') as direccion, g.pers_tfono, "& vbCrLf &_
				" 	protic.total_recepcionar_cuota(h.tcom_ccod,h.inst_ccod,h.comp_ndocto,h.dcom_ncompromiso) as saldo_pagare, "& vbCrLf &_
				" 	a.ding_mdocto -protic.total_recepcionar_cuota(h.tcom_ccod,h.inst_ccod,h.comp_ndocto,h.dcom_ncompromiso) as  abonado "& vbCrLf &_
				" From detalle_ingresos a " & vbCrLf &_
				"    join   ingresos b " & vbCrLf &_
				"        on a.ingr_ncorr = b.ingr_ncorr " & vbCrLf &_
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
				"    left outer join direcciones j " & vbCrLf &_
				"        on g.pers_ncorr = j.pers_ncorr  " & vbCrLf &_
				" 	 and j.tdir_ccod=1 " & vbCrLf &_
				"    left outer join ciudades k " & vbCrLf &_
				"        on j.ciud_ccod = k.ciud_ccod  " & vbCrLf &_
				"    join   abonos h " & vbCrLf &_
				"        on b.ingr_ncorr = h.ingr_ncorr " & vbCrLf &_
				"    join   compromisos i " & vbCrLf &_
				"        on h.tcom_ccod = i.tcom_ccod  " & vbCrLf &_
				"        and h.inst_ccod = i.inst_ccod  " & vbCrLf &_
				"        and h.comp_ndocto = i.comp_ndocto " & vbCrLf &_
				" Where i.ecom_ccod <> 3   " & vbCrLf &_
				"    and a.ting_ccod = 52    " & vbCrLf &_
				"    and a.ding_ncorrelativo > 0    " & vbCrLf &_
				"    and b.eing_ccod <> 3  "
				
			
					
					if sede <> "" then
					  consulta = consulta &  "AND i.sede_ccod = '" & sede & "' "& vbCrLf
					end if
				  
					if inicio <> "" or termino <> "" then

					  consulta = consulta &  "AND convert(datetime,a.ding_fdocto,103) BETWEEN  isnull(convert(datetime,'" & inicio & "',103),convert(datetime,a.ding_fdocto,103)) and isnull(convert(datetime,'" & termino & "',103),convert(datetime,a.ding_fdocto,103))"& vbCrLf

					end if 
					
					if rut_alumno <> "" then
					  consulta = consulta &  "AND f.pers_nrut = '" & rut_alumno & "' "& vbCrLf
					end if
					
					if rut_apoderado <> "" then
					  consulta = consulta &  "AND g.pers_nrut = '" & rut_apoderado & "' "& vbCrLf
					end if
					
					if num_doc <> "" then                   
				      consulta = consulta &  "AND case when len(isnull(a.ding_ndocto,0))<=4 then protic.obtener_numero_pagare_pagado(a.ingr_ncorr) else cast(a.ding_ndocto as varchar) end = '" & num_doc & "' "& vbCrLf
					end if
					
					if estado_letra <> "" then
  					   consulta = consulta & " AND d.fedi_ccod = '" & estado_letra & "' "& vbCrLf
					 end if
					 
					 if v_inen_ccod <> "" then
  					   consulta = consulta & " AND case when d.udoc_ccod = 2 then e.inen_ccod end = '" & v_inen_ccod & "' "& vbCrLf
					 end if
					 
					 consulta = consulta & "order by numero_pagare asc, a.ding_fdocto asc, b.ingr_fpago asc"

f_letras.Consultar consulta

'response.Write("<PRE>" & consulta & "</PRE>")
'response.End()
%>
<html>
<head>
<title> Reporte Pagare Transbank </title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="75%" border="1">
  <tr> 
    <td width="11%"><div align="center"><strong>Caja Origen</strong></div></td>
	<td width="11%"><div align="center"><strong>Deposito</strong></div></td>  
	<td width="11%"><div align="center"><strong>N&ordm; Pagare</strong></div></td>
	<td width="11%"><div align="center"><strong>N&ordm; Tarjeta</strong></div></td>
    <td width="11%"><div align="center"><strong>Estado</strong></div></td>
    <td width="11%"><div align="center"><strong>F. Emisi&oacute;n</strong></div></td>
    <td width="14%"><div align="center"><strong>F. Vencimiento</strong></div></td>
    <td width="8%"><div align="center"><strong>Monto ($)</strong></div></td>
	<td width="8%"><div align="center"><strong>Abonado ($)</strong></div></td>
	<td width="8%"><div align="center"><strong>Saldo ($)</strong></div></td>
    <td width="11%"><div align="center"><strong>Rut Alumno</strong></div></td>
    <td width="11%"><div align="center"><strong>Email Personal</strong></div></td>
    <td width="11%"><div align="center"><strong>Email Upa</strong></div></td>
    <td width="11%"><div align="center"><strong>Rut Apoderado</strong></div></td>
	<td width="11%"><div align="center"><strong>Apellido Paterno</strong></div></td>
	<td width="11%"><div align="center"><strong>Apellido Materno</strong></div></td>
	<td width="11%"><div align="center"><strong>Nombre Apoderado</strong></div></td>
    <td width="11%"><div align="center"><strong>Email Apoderado</strong></div></td>
    <td width="11%"><div align="center"><strong>Direccion Apoderado</strong></div></td>
	<td width="11%"><div align="center"><strong>Ciudad</strong></div></td>
	<td width="11%"><div align="center"><strong>Comuna</strong></div></td>
	<td width="11%"><div align="center"><strong>Telefono</strong></div></td>

  </tr>
  <%  while f_letras.Siguiente %>
  <tr> 
    <td><div align="center"><%=f_letras.ObtenerValor("mcaj_ncorr")%></div></td>
	<td><div align="center"><%=f_letras.ObtenerValor("envi_ncorr")%></div></td>
	<td><%=f_letras.ObtenerValor("numero_pagare")%></td>
	<td>&nbsp;<%=f_letras.ObtenerValor("ding_tcuenta_corriente")%></td>
    <td><%=f_letras.ObtenerValor("edin_tdesc")%></td>
    <td><div align="left"><%=f_letras.ObtenerValor("ingr_fpago")%></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("ding_fdocto")%></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("ding_mdocto")%></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("abonado")%></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("saldo_pagare")%></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("rut_alumno")%></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("email_personal")%></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("email_upa")%></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("rut_apoderado")%></div></td>
	<td><div align="left"><%=f_letras.ObtenerValor("pers_tape_paterno")%></div></td>
	<td><div align="left"><%=f_letras.ObtenerValor("pers_tape_materno")%></div></td>
	<td><div align="left"><%=f_letras.ObtenerValor("nombre_apoderado")%></div></td>
    <td><div align="center"><%=f_letras.ObtenerValor("email_apoderado")%></div></td>
    <td><%=f_letras.ObtenerValor("direccion")%></td>
	<td><%=f_letras.ObtenerValor("ciud_tcomuna")%></td>
	<td><%=f_letras.ObtenerValor("ciud_tdesc")%></td>
	<td><div align="right"><%=f_letras.ObtenerValor("pers_tfono")%></div></td>
  </tr>

  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>