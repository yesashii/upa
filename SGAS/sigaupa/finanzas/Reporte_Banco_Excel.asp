<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=Reporte_Carta_Guia.xls"
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
'------------------------------------------------------------------------------------
'response.Write("En Construccion...")
'response.End()
folio_envio = Request.QueryString("folio_envio")

set formulario = new CFormulario
formulario.Carga_Parametros "Envios_Banco.xml", "f_detalle_agrupado"
formulario.Inicializar conexion
formulario.ProcesaForm
'formulario.listarpost

alumnos = ""
for fila = 0 to formulario.CuentaPost - 1
  carta = formulario.ObtenerValorPost (fila, "carta")
   if carta = 1 then
      r_alumno = formulario.ObtenerValorPost (fila, "r_alumno")
      alumnos = alumnos & "'" & r_alumno & "',"	 
   end if
next
alumnos = alumnos & "''"

set f_letras = new CFormulario
f_letras.Carga_Parametros "Reporte_Letras.xml", "f_letras_BHIF"
f_letras.Inicializar conexion

cadena = "select a.envi_ncorr, a.envi_fenvio as envi_fenvio, a.inen_ccod, g.inen_tdesc, a.plaz_ccod, h.plaz_tdesc,  " & vbCrLf &_
		   "                isnull(protic.numero_compromiso (b.ingr_ncorr, b.ting_ccod, b.ding_ndocto), '0') as numero_compromiso,  " & vbCrLf &_
		   "		 	   isnull(protic.total_documentos(b.ingr_ncorr, b.ting_ccod, b.ding_ndocto), '0') as total_documentos,  " & vbCrLf &_
		   "		 	   protic.obtener_rut(i.pers_ncorr) as rut_alumno, protic.obtener_nombre_completo(d.pers_ncorr, 'PMN') as nombre_apoderado, protic.obtener_rut(d.pers_ncorr) as rut_apoderado,  " & vbCrLf &_
		   "		 	   protic.obtener_direccion_letra(d.pers_ncorr, 1,'CNPB') as direccion, cast(DATEPART(dd,j.ding_fdocto) as varchar) + '-' + cast(DATEPART(mm,j.ding_fdocto) as varchar) + '-' + cast(DATEPART(yyyy,j.ding_fdocto) as varchar) as ding_fdocto, j.ding_mdetalle, j.ding_ndocto, j.ingr_ncorr, j.ting_ccod,  " & vbCrLf &_
		   "		 	   k.ccte_tdesc, m.sede_tcalle, m.sede_tnro, cast(day(i.ingr_fpago) as varchar) + '-' + cast(month(i.ingr_fpago) as varchar) + '-' + cast(year(i.ingr_fpago) as varchar) as ingr_fpago, a.ccte_ccod, l.sede_ccod, f.ciud_tdesc, f.ciud_tcomuna, protic.obtener_nombre_carrera(l.ofer_ncorr, 'C') as carr_tdesc,  " & vbCrLf &_
		   "		 	   o.pers_nrut as r_alumno, d.pers_nrut as r_apoderado, d.pers_xdv, protic.cantidad_letras(a.envi_ncorr, o.pers_nrut) as total_letras  " & vbCrLf &_
		   "		 from envios a  " & vbCrLf &_
		   "              join detalle_envios b on a.envi_ncorr = b.envi_ncorr  " & vbCrLf &_
		   "              join detalle_ingresos c on b.ting_ccod = c.ting_ccod and b.ding_ndocto = c.ding_ndocto and b.ingr_ncorr = c.ingr_ncorr  " & vbCrLf &_
		   "              left outer join personas d on c.pers_ncorr_codeudor = d.pers_ncorr  " & vbCrLf &_
		   "              left outer join direcciones_publica e on d.pers_ncorr = e.pers_ncorr  " & vbCrLf &_
		   "              left outer join ciudades f on e.ciud_ccod = f.ciud_ccod " & vbCrLf &_
		   "              right outer join (select 1 xri) xr on e.tdir_ccod = xri  " & vbCrLf &_
		   "              left outer join instituciones_envio g on a.inen_ccod = g.inen_ccod " & vbCrLf &_
		   "              left outer join plazas h on a.plaz_ccod = h.plaz_ccod " & vbCrLf &_
		   "              join ingresos i on b.ingr_ncorr = i.ingr_ncorr " & vbCrLf &_
		   "              join personas o on i.pers_ncorr = o.pers_ncorr " & vbCrLf &_
		   "              join detalle_ingresos j on b.ting_ccod = j.ting_ccod and b.ding_ndocto = j.ding_ndocto and b.ingr_ncorr = j.ingr_ncorr " & vbCrLf &_
		   "              left outer join cuentas_corrientes k on a.ccte_ccod = k.ccte_ccod " & vbCrLf &_
		   "              left outer join ofertas_academicas l " & vbCrLf &_
		   "				on l.ofer_ncorr = protic.ultima_oferta_matriculado(i.pers_ncorr) " & vbCrLf &_
		   "              left outer join sedes m on l.sede_ccod = m.sede_ccod " & vbCrLf &_
		   "              left outer join ciudades n on m.ciud_ccod = n.ciud_ccod               " & vbCrLf &_
		   "		 where   " & vbCrLf &_
		   "		    c.ding_ncorrelativo > 0   " & vbCrLf &_
		   "  and a.envi_ncorr = '" & folio_envio & "' " & vbCrLf &_
		   "		 order by nombre_apoderado asc, rut_alumno, numero_compromiso"
		  
 


f_letras.Consultar cadena




%>


<html>
<head>
<title> Detalle Envio a Banco</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="1">
  <tr> 
    <td ><div align="center"><strong>Moneda</strong></div></td>
	<td ><div align="center"><strong>N&ordm; Cedente</strong></div></td>
    <td ><div align="center"><strong>Rut Aceptante</strong></div></td>
	<td ><div align="center"><strong>DV</strong></div></td>
    <td><div align="center"><strong>Nombre Aceptante</strong></div></td>
    <td ><div align="center"><strong>Dirección Aceptante</strong></div></td>
	<td ><div align="center"><strong>Comuna</strong></div></td>
    <td ><div align="center"><strong>Ciudad del Aceptante</strong></div></td>
	<td ><div align="center"><strong>Plaza de Cobro</strong></div></td>
    <td ><div align="center"><strong>Fecha Vencimiento</strong></div></td>
    <td ><div align="center"><strong>Valor Documento </strong></div></td>
	<td ><div align="center"><strong>Valor Cuota</strong></div></td>
	<td ><div align="center"><strong>Cantidad</strong></div></td>
	<td ><div align="center"><strong>Cuota</strong></div></td>
	<td ><div align="center"><strong>Fecha Emisión</strong></div></td>
	<td ><div align="center"><strong>Impuesto Timbre</strong></div></td>
  </tr>
  <%  while f_letras.Siguiente %>
  <tr> 
    <td><div align="center">CLP</div></td>
	<td><div align="right"><%=f_letras.ObtenerValor("ding_ndocto") %></div></td>
    <td><div align="right">
		 <% =f_letras.ObtenerValor("r_apoderado")%>
      </div></td>
	<td><div align="left"><%=f_letras.ObtenerValor("pers_xdv") %></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("nombre_apoderado") %></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("direccion")%></div></td>
	<td><div align="left"><%=f_letras.ObtenerValor("ciud_tdesc")%></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("ciud_tcomuna")%></div></td>
	<td><div align="left"></div></td>
    <td><div align="center">
		&nbsp;<%=f_letras.ObtenerValor("ding_fdocto")%>
	</div></td>
    <td><div align="right">
	<%=f_letras.ObtenerValor("ding_mdetalle") %>
	</div></td>
    <td><div align="right">
	<%=f_letras.ObtenerValor("ding_mdetalle") %>
	</div></td>
	<td><div align="right">
	<%=f_letras.ObtenerValor("total_documentos")%>
	</div></td>
	<td><div align="right">
	<%=f_letras.ObtenerValor("numero_compromiso") %>
	</div></td>
	<td><div align="center">&nbsp;<%=f_letras.ObtenerValor("ingr_fpago") %>
	</div></td>
	<td><div align="center"><%   %></div></td>
  </tr>
  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>