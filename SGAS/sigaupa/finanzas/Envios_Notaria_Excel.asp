<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO:GESTIÓN DE DOCUMENTOS
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:12/03/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			:94
'********************************************************************
Response.AddHeader "Content-Disposition", "attachment;filename=detalle_envios_Notaria.xls"
Response.ContentType = "application/vnd.ms-excel"

'------------------------------------------------------------------------------------
set pagina = new CPagina
'-----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------------
folio_envio = Request.QueryString("folio_envio")
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'------------------------------------------------------------------------------------
set f_envio = new CFormulario
f_envio.Carga_Parametros "Envios_Notaria.xml", "f_envios"
f_envio.Inicializar conexion
consulta = "SELECT envios.envi_ncorr, envios.envi_fenvio, envios.inen_ccod, "&_
         "instituciones_envio.inen_tdesc "&_
         "FROM envios, instituciones_envio "&_
         "WHERE envios.inen_ccod = instituciones_envio.inen_ccod "&_
		 "AND envios.envi_ncorr=" & folio_envio 
 f_envio.Consultar consulta
 f_envio.siguiente

 '------------------------------------------------------------------------------------
set f_detalle_envio = new CFormulario
f_detalle_envio.Carga_Parametros "Envios_Notaria.xml", "excel"
f_detalle_envio.Inicializar conexion

		  
'			  consulta  =	"SELECT a.envi_ncorr, b.ting_ccod, b.ding_ndocto as c_ding_ndocto, b.ingr_ncorr ,b.ding_ndocto,  cast(c.ding_mdocto as integer) as ding_mdocto, "& vbCrLf &_
'						" protic.total_recepcionar_cuota(j.tcom_ccod,j.inst_ccod,j.comp_ndocto,j.dcom_ncompromiso)   as saldo,"& vbCrLf &_
'						" day(d.ingr_fpago) + month(d.ingr_fpago) + year(d.ingr_fpago) as ingr_fpago,  "& vbCrLf &_
'					   	" c.ding_fdocto, c1.edin_ccod, c1.edin_tdesc, cast(e.pers_nrut as varchar) + '-' + e.pers_xdv as rut_alumno,  "& vbCrLf &_
'					   	" cast(f.pers_nrut as varchar) + '-' + f.pers_xdv as rut_apoderado,  "& vbCrLf &_
'					   	" protic.obtener_direccion_letra(f.pers_ncorr,1,'CNPB') as direccion_apo,protic.obtener_direccion_letra(f.pers_ncorr,1,'C-C') as comuna_ciudad, "& vbCrLf &_
'					   	"f.pers_tape_paterno  as paterno_apo, f.pers_tape_materno as materno_apo,cast(f.pers_tnombre as varchar)  as nombre_apo"& vbCrLf &_  
'				"FROM envios a, detalle_envios b, detalle_ingresos c, estados_detalle_ingresos c1,  "& vbCrLf &_
'					 "ingresos d, personas e, personas f, abonos j   "& vbCrLf &_
'				"WHERE c.DING_NCORRELATIVO = 1  "& vbCrLf &_
'				  "and a.envi_ncorr = b.envi_ncorr  "& vbCrLf &_
'				  "and b.ting_ccod = c.ting_ccod  "& vbCrLf &_
'				  "and b.ding_ndocto = c.ding_ndocto  "& vbCrLf &_
'				  "and b.ingr_ncorr = c.ingr_ncorr  "& vbCrLf &_
'				  "and c.ingr_ncorr = d.ingr_ncorr  "& vbCrLf &_
'				  "and b.edin_ccod = c1.edin_ccod  "& vbCrLf &_
'				  "and d.pers_ncorr = e.pers_ncorr "& vbCrLf &_
'				  "and b.ingr_ncorr=j.ingr_ncorr "& vbCrLf &_
'				  "and c.PERS_NCORR_CODEUDOR *= f.pers_ncorr   "& vbCrLf &_
'				  "and a.envi_ncorr=" & folio_envio & vbCrLf &_
'				  " order by paterno_apo"

			  consulta  =	"SELECT a.envi_ncorr, b.ting_ccod, b.ding_ndocto as c_ding_ndocto, b.ingr_ncorr ,b.ding_ndocto,  cast(c.ding_mdocto as integer) as ding_mdocto, "& vbCrLf &_
						" protic.total_recepcionar_cuota(j.tcom_ccod,j.inst_ccod,j.comp_ndocto,j.dcom_ncompromiso)   as saldo,"& vbCrLf &_
						" day(d.ingr_fpago) + month(d.ingr_fpago) + year(d.ingr_fpago) as ingr_fpago,  "& vbCrLf &_
					   	" c.ding_fdocto, c1.edin_ccod, c1.edin_tdesc, cast(e.pers_nrut as varchar) + '-' + e.pers_xdv as rut_alumno,  "& vbCrLf &_
					   	" cast(f.pers_nrut as varchar) + '-' + f.pers_xdv as rut_apoderado,  "& vbCrLf &_
					   	" protic.obtener_direccion_letra(f.pers_ncorr,1,'CNPB') as direccion_apo,protic.obtener_direccion_letra(f.pers_ncorr,1,'C-C') as comuna_ciudad, "& vbCrLf &_
					   	"f.pers_tape_paterno  as paterno_apo, f.pers_tape_materno as materno_apo,cast(f.pers_tnombre as varchar)  as nombre_apo"& vbCrLf &_  
				"FROM envios a INNER JOIN detalle_envios b "& vbCrLf &_
				"ON a.envi_ncorr = b.envi_ncorr "& vbCrLf &_
				"INNER JOIN detalle_ingresos c "& vbCrLf &_
				"ON b.ting_ccod = c.ting_ccod and b.ding_ndocto = c.ding_ndocto and b.ingr_ncorr = c.ingr_ncorr and c.DING_NCORRELATIVO = 1 "& vbCrLf &_
				"INNER JOIN ingresos d "& vbCrLf &_
				"ON c.ingr_ncorr = d.ingr_ncorr "& vbCrLf &_
				"INNER JOIN estados_detalle_ingresos c1 "& vbCrLf &_
				"ON b.edin_ccod = c1.edin_ccod "& vbCrLf &_
				"INNER JOIN personas e "& vbCrLf &_
				"ON d.pers_ncorr = e.pers_ncorr "& vbCrLf &_
				"INNER JOIN abonos j "& vbCrLf &_
				"ON b.ingr_ncorr=j.ingr_ncorr "& vbCrLf &_
				"LEFT OUTER JOIN personas f "& vbCrLf &_
				"ON c.PERS_NCORR_CODEUDOR = f.pers_ncorr "& vbCrLf &_
				"WHERE a.envi_ncorr = " & folio_envio & vbCrLf &_
				  " order by paterno_apo"
			  
'response.Write("<pre>"&consulta&"</pre>")
f_detalle_envio.Consultar consulta

%>
<html>
<head>
<title> Detalle Envio a Notaria</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td width="10%">&nbsp;</td>
    <td width="34%">&nbsp;</td>
  </tr>
  <tr> 
    <td><strong>N&ordm; Folio</strong></td>
    <td><strong>:</strong> <% =f_envio.DibujaCampo("envi_ncorr") %> </td>
    <td><div align="left"><font size="2"> </font></div></td>
    <td><strong>Fecha</strong></td>
    <td><strong>:</strong> <% =f_envio.DibujaCampo("envi_fenvio") %> </td>
  </tr>
  <tr> 
    <td><strong>Notaria</strong></td>
    <td><strong>:</strong> <% =f_envio.DibujaCampo("inen_tdesc") %> </td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%">&nbsp;</td>
    <td width="26%">&nbsp;</td>
    <td width="14%"><div align="left"><font size="2"> </font></div></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>

<table width="114%" border="1">
  <tr> 
    <td width="9%"><div align="center"><strong>N&ordm; Letra</strong></div></td>
    <td width="20%"><div align="center"><strong>Estado</strong></div></td>
    <td width="11%"><div align="center"><strong>Rut Alumno</strong></div></td>
    <td width="16%"><div align="center"><strong>Rut Apoderado</strong></div></td>
	<td width="16%"><div align="center"><strong>Direccion Apoderado</strong></div></td>
	<td width="16%"><div align="center"><strong>Comuna-Ciudad</strong></div></td>
    <td width="11%"><div align="center"><strong>Apellido Paterno</strong></div></td>
	<td width="11%"><div align="center"><strong>Apellido Materno</strong></div></td>
	<td width="11%"><div align="center"><strong>Nombres Apoderado</strong></div></td>
    <td width="14%"><div align="center"><strong>Fecha Emisi&oacute;n</strong></div></td>
    <td width="14%"><div align="center"><strong>Fecha Vencimiento</strong> </div></td>
    <td width="19%"><div align="center"><strong>Monto Letra</strong></div></td>
	<td width="19%"><div align="center"><strong>Saldo $</strong></div></td>
  </tr>
  <%  while f_detalle_envio.Siguiente %>
  <tr> 
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("ding_ndocto")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("edin_tdesc")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("rut_alumno")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("rut_apoderado")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("direccion_apo")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("comuna_ciudad")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("paterno_apo")%></div></td>
	<td><div align="center"><%=f_detalle_envio.ObtenerValor("materno_apo")%></div></td>
	<td><div align="center"><%=f_detalle_envio.ObtenerValor("nombre_apo")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("ingr_fpago")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("ding_fdocto")%></div></td>
    <td><div align="right"><%=f_detalle_envio.ObtenerValor("ding_mdocto")%></div></td>
	<td><div align="right"><%=f_detalle_envio.ObtenerValor("saldo")%></div></td>
  </tr>
    <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>