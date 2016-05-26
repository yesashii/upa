<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'Response.AddHeader "Content-Disposition", "attachment;filename=Reporte_Cedentes_BHIF.xls"
'Response.ContentType = "application/vnd.ms-excel"
'------------------------------------------------------------------------------------
set pagina = new CPagina
'-----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'------------------------------------------------------------------------------------
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
cadena = "SELECT A.ENVI_NCORR, A.ENVI_FENVIO, A.INEN_CCOD, B.INEN_TDESC, A.PLAZ_CCOD, C.PLAZ_TDESC,  "&_
				"obtener_rut(G.PERS_NCORR) AS RUT_ALUMNO,  "&_
				"obtener_nombre_completo(J.PERS_NCORR, 'PMN') AS NOMBRE_APODERADO,  "&_
				"obtener_rut(J.PERS_NCORR) AS RUT_APODERADO, K.DIRE_TCALLE || ' ' || K.DIRE_TNRO AS DIRECCION,  "&_
				"E.DING_FDOCTO, E.DING_MDETALLE, E.DING_NDOCTO, E.INGR_NCORR, E.TING_CCOD,   "&_
				"M.CCTE_TDESC, N.SEDE_TCALLE, N.SEDE_TNRO, B.INEN_CCOD AS EXPR1, f.ingr_fpago,  "&_
				"C.PLAZ_CCOD AS EXPR2, M.CCTE_CCOD,N.SEDE_CCOD, q.ciud_tdesc, q.ciud_tcomuna, r.CARR_TDESC,  "&_
				"g.pers_nrut as r_alumno, j.pers_nrut as r_apoderado, j.PERS_XDV, "&_  
				"cantidad_letras(A.ENVI_NCORR, g.pers_nrut) as total_letras "&_ 
		"FROM ENVIOS A, INSTITUCIONES_ENVIO B, PLAZAS C, DETALLE_ENVIOS D,   "&_
				"DETALLE_INGRESOS E, INGRESOS F, PERSONAS G, POSTULANTES H, CODEUDOR_POSTULACION I,  "&_ 
				"PERSONAS J, DIRECCIONES K, TIPOS_DIRECCIONES L, CUENTAS_CORRIENTES M, SEDES N,  "&_
				"Ofertas_academicas o, especialidades p, ciudades q, carreras r    "&_
		"WHERE A.INEN_CCOD = B.INEN_CCOD   "&_
				"AND A.PLAZ_CCOD = C.PLAZ_CCOD   "&_
				"AND A.ENVI_NCORR = D.ENVI_NCORR   "&_
				"AND D.TING_CCOD = E.TING_CCOD   "&_
				"AND D.DING_NDOCTO = E.DING_NDOCTO   "&_
				"AND D.INGR_NCORR = E.INGR_NCORR   "&_
				"AND E.INGR_NCORR = F.INGR_NCORR   "&_
				"AND F.PERS_NCORR = G.PERS_NCORR   "&_
				"AND G.PERS_NCORR = H.PERS_NCORR   "&_
				"AND H.ofer_ncorr = o.OFER_NCORR  "&_
				"AND o.espe_ccod = p.ESPE_CCOD "&_ 
				"AND H.POST_NCORR = I.POST_NCORR   "&_
				"AND I.PERS_NCORR = J.PERS_NCORR   "&_
				"AND J.PERS_NCORR = K.PERS_NCORR   "&_
				"AND K.TDIR_CCOD = L.TDIR_CCOD   "&_
				"AND A.CCTE_CCOD = M.CCTE_CCOD   "&_
				"AND M.SEDE_CCOD = N.SEDE_CCOD   "&_
				"AND k.CIUD_CCOD = q.CIUD_CCOD  "&_
				"AND p.CARR_CCOD = r.CARR_CCOD  "&_
				"AND (H.PERI_CCOD ="&Periodo&")   "&_
				"AND (L.TDIR_CCOD = 1)  "&_ 
				"AND (A.ENVI_NCORR ="&folio_envio&") " &_ 
				"AND g.PERS_NRUT IN ("&alumnos&") "&_ 
		"ORDER BY RUT_ALUMNO, E.DING_FDOCTO"
		
				
				'AND (G.PERS_NRUT IN('')) 

f_letras.Consultar cadena
%>
<%
 function completar(campo, cantidad)
   
    largo = len(trim(campo))
	if (largo < cantidad) then
       for i = largo to cantidad - 1
	      campo =  "0" & campo
	   next
	end if	
	completar = "=""" & campo  & """"		
 end function
 
  function completar2(campo, cantidad)
   
    largo = len(trim(campo))
	if (largo < cantidad) then
       for i = largo to cantidad - 1
	      campo =  "0" & campo
	   next
	end if	
	completar2 = campo 
 end function

function convertir_fecha(fecha)
   dia = completar2(day(fecha),2)
   mes =  completar2(month(fecha),2)
   anio = completar2(year(fecha),2)
   convertir_fecha = dia & "-" & mes & "-" & anio 
end function

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
    <!-- <td width="11%"><div align="center"><strong>Rut Alumno</strong></div></td>-->
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
    <!--<td><div align="center"><% completar f_letras.ObtenerValor("r_alumno"), 9 %></div></td>-->
    <td><div align="right">
        <% =completar(f_letras.ObtenerValor("r_apoderado"), 9) %>
      </div></td>
	<td><div align="left"><%=f_letras.ObtenerValor("pers_xdv") %></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("nombre_apoderado") %></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("direccion")%></div></td>
	<td><div align="left"></div></td>
    <td><div align="left"><%=f_letras.ObtenerValor("ciud_tdesc")%></div></td>
	<td><div align="left"></div></td>
    <td><div align="center"><%=convertir_fecha (f_letras.ObtenerValor("ding_fdocto"))%></div></td>
    <td><div align="right"><%=completar (f_letras.ObtenerValor("ding_mdetalle"), 15) %></div></td>
    <td><div align="right"><%=completar (f_letras.ObtenerValor("ding_mdetalle"), 15) %></div></td>
	<td><div align="right"><%=completar (f_letras.ObtenerValor("total_letras"), 3) %></div></td>
	<td><div align="right"><%=completar ("x", 3) %></div></td>
	<td><div align="center"><%=convertir_fecha (f_letras.ObtenerValor("ingr_fpago")) %></div></td>
	<td><div align="center"><%   %></div></td>
  </tr>
  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>