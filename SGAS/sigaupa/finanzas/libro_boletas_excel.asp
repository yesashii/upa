<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=Reporte_boletas.xls"
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
 inicio = request.querystring("busqueda[0][inicio]")
 termino = request.querystring("busqueda[0][termino]")
 'rut_alumno = request.querystring("busqueda[0][pers_nrut]")
 'rut_alumno_digito = request.querystring("busqueda[0][pers_xdv]")
 'rut_apoderado = request.querystring("busqueda[0][code_nrut]")
 'rut_apoderado_digito = request.querystring("busqueda[0][code_xdv]")
 num_doc = request.querystring("busqueda[0][bole_nboleta]")
 estado_letra = request.querystring("busqueda[0][ebol_ccod]")
 v_tbol_ccod = Request.QueryString("busqueda[0][tbol_ccod]")

'----------------------------------------------------------------------------
consulta = "SELECT pers_ncorr FROM personas WHERE pers_nrut='" & Usuario & "'"
pers_ncorr = conexion.ConsultaUno(consulta)
'response.Write(pers_ncorr)
'f_busqueda.AgregaCampoParam "sede_ccod","destino", "(select a.sede_ccod, d.sede_tdesc from sis_sedes_usuarios a, sis_usuarios b, personas c, sedes d where a.pers_ncorr = b.pers_ncorr and b.pers_ncorr = c.pers_ncorr and a.sede_ccod = d.sede_ccod and a.pers_ncorr =" & pers_ncorr & ")"
'----------------------------------------------------------------------------

set f_boletas = new CFormulario
f_boletas.Carga_Parametros "tabla_vacia.xml", "tabla"
f_boletas.Inicializar conexion

			
					
consulta = "select a.pers_ncorr_aval,protic.obtener_rut(a.pers_ncorr_aval) as rut_beneficiario ," & vbCrLf &_
				" protic.obtener_nombre_completo(a.pers_ncorr_aval,'n') as nombre_beneficiario," & vbCrLf &_
				" b.tbol_tdesc as tipo_boleta,bole_nboleta as num_boleta,case when a.ebol_ccod =3 then 0 else bole_mtotal end as total_boleta," & vbCrLf &_
				" protic.trunc(a.bole_fboleta) as fecha_boleta, ingr_nfolio_referencia as comprobante," & vbCrLf &_
				" mcaj_ncorr as caja, c.ebol_tdesc as estado, d.sede_tdesc as sede,protic.obtener_rut(a.pers_ncorr) as rut_alumno, e.inst_trazon_social " & vbCrLf &_
				" From boletas a, tipos_boletas b, estados_boletas c, sedes d, instituciones e " & vbCrLf &_
				" where a.tbol_ccod=b.tbol_ccod" & vbCrLf &_
				" and a.sede_ccod=d.sede_ccod " & vbCrLf &_
				" and a.ebol_ccod=c.ebol_ccod "  & vbCrLf &_
				" and isnull(a.inst_ccod,1)=e.inst_ccod "


					if sede <> "" then
					  consulta = consulta & vbCrLf&  " and a.sede_ccod = '" & sede & "' "
					end if

					if inicio <> "" and termino <> "" then
					  consulta = consulta & vbCrLf&   " and convert(datetime,bole_fboleta,103) between '" & inicio & "' and '" & termino & "'"
					end if 
					if inicio <> "" and termino = "" then
					  consulta = consulta & vbCrLf&   " and convert(datetime,bole_fboleta,103) >= '" & inicio & "'"
					end if 
					if inicio = "" and termino <> "" then
					  consulta = consulta & vbCrLf&   " and convert(datetime,bole_fboleta,103) <= '" & termino & "'"
					end if 
					
					if num_doc <> "" then                   
				      consulta = consulta & vbCrLf&   " and a.bole_nboleta= '" & num_doc & "' "
					end if
					if tipo_doc <> "" then                   
				      consulta = consulta & vbCrLf&   " and a.tbol_ccod= '" & tipo_doc & "' "
					end if
					if estado_letra <> "" then
  					   consulta = consulta & vbCrLf&  " and a.ebol_ccod ='" & estado_letra & "' "
					 end if
					 
					 
					 consulta = consulta & vbCrLf&  " order by num_boleta" 
					 
f_boletas.Consultar consulta

'response.Write("<PRE>" & consulta & "</PRE>")
'response.End()
%>
<html>
<head>
<title> Detalle Boletas</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="75%" border="1">
  <tr> 
	<td width="11%"><div align="center"><strong>Tipo Boleta</strong></div></td>
    <td width="11%"><div align="center"><strong>N&ordm; Boleta</strong></div></td>
	<td width="8%"><div align="center"><strong>Monto ($)</strong></div></td>
    <td width="11%"><div align="center"><strong>Estado</strong></div></td>
	<td width="11%"><div align="center"><strong>F. Emisi&oacute;n</strong></div></td>
	<td width="11%"><div align="center"><strong>Rut Beneficiario</strong></div></td>
    <td width="11%"><div align="center"><strong>Nombre Beneficiario</strong></div></td>
	<td width="11%"><div align="center"><strong>Nº Comprobante</strong></div></td>
	<td width="11%"><div align="center"><strong>Nº Caja</strong></div></td>
	<td width="11%"><div align="center"><strong>Sede</strong></div></td>
	<td width="11%"><div align="center"><strong>Rut Alumno</strong></div></td>
	<td width="11%"><div align="center"><strong>Empresa</strong></div></td>

  </tr>
  <%  while f_boletas.Siguiente %>
  <tr> 
  <td><div align="left"><%=f_boletas.ObtenerValor("tipo_boleta")%></div></td>
    <td><div align="left"><%=f_boletas.ObtenerValor("num_boleta")%></div></td>
    <td><div align="left"><%=f_boletas.ObtenerValor("total_boleta")%></div></td>
	<td><div align="left"><%=f_boletas.ObtenerValor("estado")%></div></td>
    <td><div align="left"><%=f_boletas.ObtenerValor("fecha_boleta")%></div></td>
    <td><div align="left"><%=f_boletas.ObtenerValor("rut_beneficiario")%></div></td>
    <td><div align="left"><%=f_boletas.ObtenerValor("nombre_beneficiario")%></div></td>
	<td><div align="left"><%=f_boletas.ObtenerValor("comprobante")%></div></td>
	<td><div align="left"><%=f_boletas.ObtenerValor("caja")%></div></td>
	<td><div align="left"><%=f_boletas.ObtenerValor("sede")%></div></td>
	<td><div align="left"><%=f_boletas.ObtenerValor("rut_alumno")%></div></td>
	<td><div align="left"><%=f_boletas.ObtenerValor("inst_trazon_social")%></div></td>
  </tr>
  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>