<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=Informe_Beneficios.xls"
Response.ContentType = "application/vnd.ms-excel"

set pagina = new CPagina
pagina.Titulo = "Informe de Beneficios"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new CNegocio
negocio.InicializaPortal conexion
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
 f_descuentos.Carga_Parametros "Informe_Beneficios.xml", "descuentos_excel"
 f_descuentos.Inicializar conexion
 
 sql = "select i.tben_tdesc, a.stde_ccod, b.stde_tdesc, c.esde_tdesc, a.post_ncorr, d.pers_ncorr, a.ofer_ncorr, e.sede_ccod, "&_
			   "f.pers_nrut || '-' || f.pers_xdv as rut_alumno, f.pers_nrut, c.ESDE_TDESC,"&_
			   "f.pers_tape_paterno || ' ' || f.pers_tape_materno || ' ' || f.pers_tnombre as nombre_alumno, "&_
			   "h.carr_tdesc, to_number(a.sdes_mmatricula) as sdes_mmatricula, to_number(a.sdes_nporc_matricula) as sdes_nporc_matricula, "&_
			   "to_number(a.sdes_mcolegiatura) as sdes_mcolegiatura, to_number(a.sdes_nporc_colegiatura) as sdes_nporc_colegiatura, "&_
			   "nvl(a.sdes_mmatricula, 0) + nvl(a.sdes_mcolegiatura, 0) as subtotal, c.esde_ccod "&_
		"from sdescuentos a, stipos_descuentos b, sestados_descuentos c,  postulantes d, "&_
			 "ofertas_academicas e,  personas_postulante f,  especialidades g,  carreras h, "&_
			 "tipos_beneficios i, sedes j "&_
		"where a.stde_ccod = b.stde_ccod "&_
		  "and b.tben_ccod = i.tben_ccod "&_
		  "and a.esde_ccod = c.esde_ccod "&_
		  "and a.post_ncorr = d.post_ncorr "&_
		  "and a.ofer_ncorr = d.ofer_ncorr "&_
		  "and d.ofer_ncorr = e.ofer_ncorr "&_
		  "and d.pers_ncorr = f.pers_ncorr "&_
		  "and e.espe_ccod = g.espe_ccod "&_
		  "and g.carr_ccod = h.carr_ccod "&_
		  "and e.sede_ccod = j.sede_ccod "&_ 
		  "and d.peri_ccod ='" & Periodo & "' "&_
		  "and b.tben_ccod = nvl('" & tipo_beneficio & "', b.tben_ccod) "&_
		  "and a.stde_ccod =  nvl('" & beneficio & "', a.stde_ccod) "&_
		  "and f.pers_nrut =  nvl('" & rut_alumno & "', f.pers_nrut) "&_ 
		  "and a.esde_ccod =  nvl('" & estado_beneficio & "', a.esde_ccod) "&_ 
          "and j.sede_ccod =  nvl('" & sede & "', j.sede_ccod) "&_ 
		  "and exists (select 1 " &_
            "from sis_sedes_usuarios a2 " &_
			"where a2.pers_ncorr =" & pers_ncorr & " " &_
			  "and a2.sede_ccod = j.sede_ccod " &_
           ") " &_ 
		  "ORDER BY nombre_alumno "
	
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
  </tr>
<% wend %>
</table>
</body>
</html>
