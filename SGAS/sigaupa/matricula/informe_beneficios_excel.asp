<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=Informe_Beneficios.xls"
Response.ContentType = "application/vnd.ms-excel"

set pagina = new CPagina
pagina.Titulo = "Informe de Beneficios"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
Usuario = negocio.ObtenerUsuario()
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Informe_Beneficios.xml", "botonera"
'-----------------------------------------------------------------------
 rut_alumno = request("rut")
 tipo_beneficio = request.QueryString("t_bene")
 beneficio = request.querystring("bene")
 estado_beneficio = request.querystring("e_bene")
 sede = request.querystring("sede")

'--------------------------------------------------------------------
 consulta = "SELECT pers_ncorr FROM personas WHERE pers_nrut='" & Usuario & "'"
 pers_ncorr = conexion.ConsultaUno(consulta)
'-----------------------------------------------------------------------

 set f_descuentos = new CFormulario
 f_descuentos.Carga_Parametros "tabla_vacia.xml", "tabla"
 f_descuentos.Inicializar conexion
 


sql = "select i.tben_tdesc, a.stde_ccod, b.stde_tdesc, c.esde_tdesc, a.post_ncorr, d.pers_ncorr, a.ofer_ncorr, e.sede_ccod," & vbCrLf &_
		"    cast(f.pers_nrut as varchar) + '-' + f.pers_xdv as rut_alumno, f.pers_nrut," & vbCrLf &_
		"    f.pers_tape_paterno + ' ' + f.pers_tape_materno + ' ' + f.pers_tnombre as nombre_alumno," & vbCrLf &_
		"    h.carr_tdesc,cast(a.sdes_mmatricula as int) as sdes_mmatricula," & vbCrLf &_
		"    a.sdes_nporc_matricula as sdes_nporc_matricula," & vbCrLf &_
		"    cast(a.sdes_mcolegiatura as int) as sdes_mcolegiatura,a.sdes_nporc_colegiatura as sdes_nporc_colegiatura," & vbCrLf &_
		"    cast(isnull(a.sdes_mmatricula, 0) + isnull(a.sdes_mcolegiatura, 0) as int) as subtotal, c.esde_ccod, protic.trunc(a.AUDI_FMODIFICACION) as fecha " & vbCrLf &_
		"    from sdescuentos a,stipos_descuentos b,sestados_descuentos c," & vbCrLf &_
		"          postulantes d,ofertas_academicas e,personas_postulante f," & vbCrLf &_
		"          especialidades g,carreras h,tipos_beneficios i,sedes j" & vbCrLf &_
		"    where a.stde_ccod = b.stde_ccod" & vbCrLf &_
		"        and a.esde_ccod = c.esde_ccod " & vbCrLf &_
		"        and a.post_ncorr = d.post_ncorr " & vbCrLf &_
		"        and a.ofer_ncorr = d.ofer_ncorr" & vbCrLf &_
		"        and d.ofer_ncorr = e.ofer_ncorr " & vbCrLf &_
		"        and d.pers_ncorr = f.pers_ncorr" & vbCrLf &_
		"        and e.espe_ccod = g.espe_ccod " & vbCrLf &_
		"        and g.carr_ccod = h.carr_ccod" & vbCrLf &_
		"        and e.sede_ccod = j.sede_ccod  " & vbCrLf &_
		"        and b.tben_ccod = i.tben_ccod " & vbCrLf &_
		"        and d.peri_ccod ='" & Periodo & "' "
		if tipo_beneficio <>"" then
		 	sql= sql & " and cast(b.tben_ccod as varchar) ='" & tipo_beneficio & "'" 
		end if
		if beneficio<>"" then
		 	sql= sql & " and cast(a.stde_ccod as varchar) ='" & beneficio & "'"
		end if
		if rut_alumno <> "" then
		 	sql= sql & " and cast(f.pers_nrut as varchar) ='" & rut_alumno & "'"
		end if
		if estado_beneficio<>"" then
		 	sql= sql & " and cast(a.esde_ccod as varchar) ='" & estado_beneficio & "'"
		end if
		if sede<>"" then
		 	sql= sql & " and cast(j.sede_ccod as varchar) ='" & sede & "'"
		end if 
		sql= sql & " and exists (select 1 " & vbCrLf &_
		"from sis_sedes_usuarios a2 " & vbCrLf &_
		"where cast(a2.pers_ncorr as varchar) ='" & pers_ncorr & "' " & vbCrLf &_
		"and a2.sede_ccod = j.sede_ccod " & vbCrLf &_
		") " & vbCrLf &_
		"ORDER BY nombre_alumno"


'response.write("<pre>"&sql&"</pre>")
	
f_descuentos.consultar sql	 

%>



<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>
<table width="100%" border="1">
<tr> 
    <td><div align="center"><strong>RUT Alumno</strong></div></td>
    <td><div align="center"><strong>Nombre Alumno</strong></div></td>
    <td><div align="center"><strong>Descuento</strong></div></td>
    <td><div align="center"><strong>% Desc. Matricula</strong></div></td>
    <td><div align="center"><strong>% Desc. Arancel</strong></div></td>
    <td><div align="center"><strong>Desc. Matricula</strong></div></td>
    <td><div align="center"><strong>Desc. Arancel</strong></div></td>
    <td><div align="center"><strong>Subtotal</strong></div></td>
    <td><div align="center"><strong>Estado</strong></div></td>
    <td><div align="center"><strong>Fecha Beneficio</strong></div></td>
  </tr>

<% while f_descuentos.siguiente%>
   <tr> 
    <td><div align="center"><%=f_Descuentos.ObtenerValor ("rut_alumno")%></div></td>
    <td><div align="left"><%=f_Descuentos.ObtenerValor ("nombre_alumno")%></div></td>
    <td><div align="left"><%=f_Descuentos.ObtenerValor ("stde_tdesc")%></div></td>
    <td><div align="center"><%=f_Descuentos.ObtenerValor ("sdes_nporc_matricula")%></div></td>
    <td><div align="center"><%=f_Descuentos.ObtenerValor ("sdes_nporc_colegiatura")%></div></td>
    <td><div align="right"><%=f_Descuentos.ObtenerValor ("sdes_mmatricula")%></div></td>
    <td><div align="right"><%=f_Descuentos.ObtenerValor ("sdes_mcolegiatura")%></div></td>
    <td><div align="right"><%=f_Descuentos.ObtenerValor ("subtotal")%></div></td>
    <td><div align="left"><%=f_Descuentos.ObtenerValor ("ESDE_TDESC")%></div></td>
      <td><div align="left"><%=f_Descuentos.ObtenerValor ("fecha")%></div></td>
  </tr>
<% wend %>
</table>
</body>
</html>
