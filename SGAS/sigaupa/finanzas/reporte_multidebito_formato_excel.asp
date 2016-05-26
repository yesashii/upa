<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/funciones_formateo.asp" -->

<%
'---------------------------------------------------------------------------------------------------------------------------------
Response.AddHeader "Content-Disposition", "attachment;filename=reporte_multidebito_formato_bci.xls"
Response.ContentType = "application/vnd.ms-excel"
'for each x in request.Form
'	response.Write("<br>"& x &"->"&request.Form(x))
'next
'---------------------------------------------------------------------------------------------------------------------------------

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

'---------------------------------------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------------------------------------
set f_multidebito = new CFormulario
f_multidebito.Carga_Parametros "Reporte_multidebito.xml", "f_multidebito_excel"
f_multidebito.Inicializar conexion

					
consulta = 	" Select  replace(convert(varchar,a.ding_fdocto,103),'/','') as fecha_docto, "& vbCrLf &_
				" protic.obtener_numero_multidebito_softland(a.ingr_ncorr)  as cuota_multidebito, "& vbCrLf &_
				"   cast(a.ding_ndocto as varchar) as numero_pagare, isnull(j.banc_cod_sbif,'001') as cod_banco, "& vbCrLf &_
				"   replace(protic.obtener_rut(b.pers_ncorr),'-','') as rut_alumno, " & vbCrLf &_
				"   replace(protic.obtener_rut(a.pers_ncorr_codeudor),'-','') as rut_apoderado, " & vbCrLf &_
				"   g.pers_tnombre +' '+g.pers_tape_paterno +' '+g.pers_tape_materno as nombre_apoderado, " & vbCrLf &_
				" 	protic.total_recepcionar_cuota(h.tcom_ccod,h.inst_ccod,h.comp_ndocto,h.dcom_ncompromiso) as saldo_pagare "& vbCrLf &_
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
				"    join   abonos h " & vbCrLf &_
				"        on b.ingr_ncorr = h.ingr_ncorr " & vbCrLf &_
				"    join   compromisos i " & vbCrLf &_
				"        on h.tcom_ccod = i.tcom_ccod  " & vbCrLf &_
				"        and h.inst_ccod = i.inst_ccod  " & vbCrLf &_
				"        and h.comp_ndocto = i.comp_ndocto " & vbCrLf &_
				"    join   bancos j " & vbCrLf &_
				"        on isnull(a.banc_ccod,1) = j.banc_ccod " & vbCrLf &_
				" Where i.ecom_ccod <> 3   " & vbCrLf &_
				"    and a.ting_ccod = 59    " & vbCrLf &_
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
				      consulta = consulta &  "AND case when len(isnull(a.ding_ndocto,0))<=4 then protic.obtener_numero_multidebito_pagado(a.ingr_ncorr) else cast(a.ding_ndocto as varchar) end = '" & num_doc & "' "& vbCrLf
					end if
					
					if estado_letra <> "" then
  					   consulta = consulta & " AND d.fedi_ccod = '" & estado_letra & "' "& vbCrLf
					end if
					 
					if v_inen_ccod <> "" then
  					   consulta = consulta & " AND case when d.udoc_ccod = 2 then e.inen_ccod end = '" & v_inen_ccod & "' "& vbCrLf
					end if
					 
'					consulta = consulta & "order by numero_pagare asc, a.ding_fdocto asc, b.ingr_fpago asc"
					 
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_multidebito.Consultar consulta



%>

<html>
<head>
<title>Reporte Multidebito</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >

<table width="114%" border="1">
  <tr> 
    
	<td width="20%"><div align="center"><strong>Rut</strong></div></td>
	<td width="16%"><div align="center"><strong>Nombre Mandatario</strong></div></td>
	<td width="19%"><div align="center"><strong>BCO</strong></div></td>
    <td width="18%"><div align="center"><strong>Identificador</strong></div></td>
    <td width="12%"><div align="center"><strong>Monto Cargo</strong></div></td>
    <td width="15%"><div align="center"><strong>Fecha</strong></div></td>
  </tr>
  <%  while f_multidebito.Siguiente %>
  <tr> 
    <td><div align="center"><%=f_multidebito.ObtenerValor("rut_apoderado")%></div></td>
	<td><div align="center"><%=f_multidebito.ObtenerValor("nombre_apoderado")%></div></td>
    <td><div align="center">&nbsp;<%=f_multidebito.ObtenerValor("cod_banco")%></div></td>
    <td><div align="center"><%=f_multidebito.ObtenerValor("rut_alumno")%></div></td>
    <td><div align="center"><%=f_multidebito.ObtenerValor("saldo_pagare")%></div></td>
    <td><div align="center"><%=f_multidebito.ObtenerValor("fecha_docto")%></div></td>
  </tr>
    <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>