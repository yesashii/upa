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
'FECHA ACTUALIZACION 	:20/03/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			:100,102
'*******************************************************************
'Response.AddHeader "Content-Disposition", "attachment;filename=detalle_envios_sedes.xls"
'Response.ContentType = "application/vnd.ms-excel"

'------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Documentos enviados entre sedes"
'-----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------------
folio_envio = Request.QueryString("folio_envio")
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
v_usuario=negocio.obtenerUsuario()
'------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "rendicion_cajas.xml", "botonera"

nombre_cajero=conexion.consultaUno("Select protic.obtener_nombre_completo(a.pers_ncorr,'n') from personas a where cast(a.pers_nrut as varchar)='"&v_usuario&"'")

set f_envio = new CFormulario
f_envio.Carga_Parametros "envios_sedes.xml", "f_envios"
f_envio.Inicializar conexion
consulta = "SELECT a.eenv_ccod, a.esed_ncorr, a.esed_fenvio, "& vbCrLf &_
         " b.sede_tdesc as sede_origen, c.sede_tdesc as sede_destino "& vbCrLf &_
         " FROM envios_sedes a, sedes b, sedes c "& vbCrLf &_
         " WHERE a.sede_origen = b.sede_ccod "& vbCrLf &_
		 " 	AND a.sede_destino = c.sede_ccod "& vbCrLf &_
         "	AND a.esed_ncorr = " & folio_envio 
 f_envio.Consultar consulta
 f_envio.siguiente

 '------------------------------------------------------------------------------------
set f_detalle_envio = new CFormulario
f_detalle_envio.Carga_Parametros "envios_sedes.xml", "excel"
f_detalle_envio.Inicializar conexion

		  
'consulta = " SELECT a.esed_ncorr,isnull(h.banc_tdesc,'Sin Banco') as banco, b.ting_ccod,g.ting_tdesc as tipo_docto, b.ding_ndocto as c_ding_ndocto, b.ingr_ncorr ," & vbCrLf &_
'			"    b.ding_ndocto,  cast(cast(c.ding_mdocto as numeric)as varchar) as ding_mdocto, convert(varchar,d.ingr_fpago,103) as ingr_fpago,  " & vbCrLf &_
'			"    convert(varchar,c.ding_fdocto,103)  as ding_fdocto, c1.edin_ccod, c1.edin_tdesc, cast(e.pers_nrut as varchar) + '-' + e.pers_xdv as rut_alumno,  " & vbCrLf &_
'			"    cast(f.pers_nrut as varchar) + '-' + f.pers_xdv as rut_apoderado,  " & vbCrLf &_
'			"    protic.obtener_nombre(f.pers_ncorr,'n') as nombre_apoderado " & vbCrLf &_
'			"FROM envios_sedes a, detalle_envios_sedes b, detalle_ingresos c, estados_detalle_ingresos c1,  " & vbCrLf &_
'			"ingresos d, personas e, personas f, tipos_ingresos g, bancos h   " & vbCrLf &_
'			"WHERE c.DING_NCORRELATIVO = 1  " & vbCrLf &_
'			"and a.esed_ncorr = b.esed_ncorr  " & vbCrLf &_
'			"and b.ting_ccod = c.ting_ccod  " & vbCrLf &_
'			"and b.ding_ndocto = c.ding_ndocto  " & vbCrLf &_
'			"and b.ingr_ncorr = c.ingr_ncorr  " & vbCrLf &_
'			"and c.ingr_ncorr = d.ingr_ncorr  " & vbCrLf &_
'			"and b.edin_ccod = c1.edin_ccod  " & vbCrLf &_
'			"and d.pers_ncorr = e.pers_ncorr " & vbCrLf &_
'			"and b.ting_ccod = g.ting_ccod  " & vbCrLf &_
'			"and c.PERS_NCORR_CODEUDOR *= f.pers_ncorr  " & vbCrLf &_
'			"and c.banc_ccod *= h.banc_ccod  " & vbCrLf &_
'			"and a.esed_ncorr='" & folio_envio & "' " & vbCrLf &_
'			"ORDER BY  nombre_apoderado, b.ding_ndocto"

consulta = " SELECT a.esed_ncorr,isnull(h.banc_tdesc,'Sin Banco') as banco, b.ting_ccod,g.ting_tdesc as tipo_docto, b.ding_ndocto as c_ding_ndocto, b.ingr_ncorr ," & vbCrLf &_
			"    b.ding_ndocto,  cast(cast(c.ding_mdocto as numeric)as varchar) as ding_mdocto, convert(varchar,d.ingr_fpago,103) as ingr_fpago,  " & vbCrLf &_
			"    convert(varchar,c.ding_fdocto,103)  as ding_fdocto, c1.edin_ccod, c1.edin_tdesc, cast(e.pers_nrut as varchar) + '-' + e.pers_xdv as rut_alumno,  " & vbCrLf &_
			"    cast(f.pers_nrut as varchar) + '-' + f.pers_xdv as rut_apoderado,  " & vbCrLf &_
			"    protic.obtener_nombre(f.pers_ncorr,'n') as nombre_apoderado " & vbCrLf &_
			"FROM envios_sedes a " & vbCrLf &_
			"INNER JOIN detalle_envios_sedes b " & vbCrLf &_
			"ON a.esed_ncorr = b.esed_ncorr and a.esed_ncorr='" & folio_envio & "' " & vbCrLf &_
			"INNER JOIN detalle_ingresos c " & vbCrLf &_
			"ON b.ting_ccod = c.ting_ccod and b.ding_ndocto = c.ding_ndocto and b.ingr_ncorr = c.ingr_ncorr AND c.DING_NCORRELATIVO = 1 " & vbCrLf &_
			"INNER JOIN ingresos d " & vbCrLf &_
			"ON c.ingr_ncorr = d.ingr_ncorr " & vbCrLf &_
			"INNER JOIN estados_detalle_ingresos c1 " & vbCrLf &_
			"ON b.edin_ccod = c1.edin_ccod " & vbCrLf &_
			"INNER JOIN personas e " & vbCrLf &_
			"ON d.pers_ncorr = e.pers_ncorr " & vbCrLf &_
			"INNER JOIN tipos_ingresos g " & vbCrLf &_
			"ON b.ting_ccod = g.ting_ccod " & vbCrLf &_
			"LEFT OUTER JOIN personas f " & vbCrLf &_
			"ON c.PERS_NCORR_CODEUDOR = f.pers_ncorr " & vbCrLf &_
			"LEFT OUTER JOIN bancos h " & vbCrLf &_
			"ON c.banc_ccod = h.banc_ccod " & vbCrLf &_
			"ORDER BY  nombre_apoderado, b.ding_ndocto"
			  
'response.Write("<pre>"&consulta&"</pre>")
f_detalle_envio.Consultar consulta

%>
<html>
<head>
<title> Detalle envio entre sedes</title>
<meta http-equiv="Content-Type" content="text/html;">
<link href="../estilos/estilos_inicial.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script>
function imprimir()
{
  window.print();  
}
</script>
</head>
<body >

<style>
@media print{ .noprint {visibility:hidden; }}
</style>
<table width="600" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" >

	<br>
<table width="100%" border="0">
<tr> 
    <td colspan="5"><div align="center"><br> <%pagina.DibujarTituloPagina%><br></div></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td width="10%">&nbsp;</td>
    <td width="34%">&nbsp;</td>
  </tr>
  <tr> 
    <td><strong>N&ordm; Envio </strong></td>
    <td><strong>:</strong> <% =f_envio.DibujaCampo("esed_ncorr") %> </td>
    <td><div align="left"><font size="2"> </font></div></td>
    <td><strong>Fecha</strong></td>
    <td><strong>:</strong> <% =f_envio.DibujaCampo("esed_fenvio") %> </td>
  </tr>
  <tr> 
    <td><strong>Origen</strong></td>
    <td><strong>:</strong> <% =f_envio.DibujaCampo("sede_origen") %> </td>
    <td>&nbsp;</td>
    <td><strong>Destino</strong></td>
    <td><strong>:</strong>
        <% =f_envio.DibujaCampo("sede_destino") %></td>
  </tr>
</table>
<br>
<br>
<table class=v1 width='100%' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD'>
  <tr bgcolor='#C4D7FF' bordercolor='#999999'>
	<td width="7%"><div align="center"><strong>Tipo Docto</strong></div></td> 
    <td width="11%"><div align="center"><strong>N&ordm; Docto</strong></div></td>
    <td width="14%"><div align="center"><strong>Banco</strong></div></td>
    <td width="14%"><div align="center"><strong>Estado</strong></div></td>
    <td width="13%"><div align="center"><strong>Rut Alumno</strong></div></td>
    <td width="14%"><div align="center"><strong>Rut Apoderado</strong></div></td>
    <td width="13%"><div align="center"><strong>Fecha Vencimiento</strong> </div></td>
    <td width="14%"><div align="center"><strong>Monto Docto</strong></div></td>
  </tr>
  <%  while f_detalle_envio.Siguiente %>
  <tr bgcolor="#FFFFFF" >
    <td><div align="left"><%=f_detalle_envio.ObtenerValor("tipo_docto")%></div></td> 
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("ding_ndocto")%></div></td>
	<td><div align="left"><%=f_detalle_envio.ObtenerValor("banco")%></div></td>
    <td><div align="left"><%=f_detalle_envio.ObtenerValor("edin_tdesc")%></div></td>
    <td><div align="left"><%=f_detalle_envio.ObtenerValor("rut_alumno")%></div></td>
    <td><div align="left"><%=f_detalle_envio.ObtenerValor("rut_apoderado")%></div></td>
    <td><div align="left"><%=f_detalle_envio.ObtenerValor("ding_fdocto")%></div></td>
    <td><div align="right"><%=formatcurrency(f_detalle_envio.ObtenerValor("ding_mdocto"),0)%></div></td>
  </tr>
    <%  wend %>
</table>
	<br>
	</td>
  </tr>  
<tr>
	<td ><center>___________________________________<br><%=nombre_cajero%></center></td>
</tr>
<tr>
	<td><div align="center" class="noprint"> <%f_botonera.DibujaBoton("imprimir")%> </div></td>
</tr>
</table>
</body>
</html>