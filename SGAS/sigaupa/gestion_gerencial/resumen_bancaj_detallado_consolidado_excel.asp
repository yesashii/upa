<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "funciones_bancaj.asp" -->

<%
Server.ScriptTimeout = 150000 
Response.AddHeader "Content-Disposition", "attachment;filename=resumen_bancaj_detallado_consolidado.xls"
Response.ContentType = "application/vnd.ms-excel"
 
'---------------------------------------------------------------------------------------------------


'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion

v_anos  = request.querystring("busqueda[0][v_anos]")
'v_sede_ccod  = request.querystring("busqueda[0][sede_ccod]")
'v_pers_ncorr = request.querystring("busqueda[0][pers_ncorr]")


fecha_01 = conexion.ConsultaUno("Select protic.trunc(getdate())")

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "numeros_boletas_cajeros.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
 'f_busqueda.AgregaCampoCons "sede_ccod", v_sede_ccod
 'f_busqueda.AgregaCampoCons "pers_ncorr", v_pers_ncorr
 
 

'**********************************************************************************


v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")



		set consolidado = new CFormulario
		consolidado.carga_parametros "resumen_bancaj_detallado.xml", "resumen_detalle_consolidado"
		consolidado.inicializar conexion 
		

		sql_consolidado=ObtenerConsultaConsolidadoPareo(v_anos)

'response.Write("<pre>"&sql_casa_cetral&"</pre>")		

		if not Esvacio(Request.QueryString) then
			consolidado.Consultar sql_consolidado

		else
			vacia = "select '' where 1=2 "
			
			consolidado.Consultar vacia
			consolidado.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"
		end if

%>
<html>
<head>
<title>Control presupuestario Consolidado</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="3"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">  Consolidado Universidad del Pac&iacute;fico </font></div>
	  <div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr> 
    <td height="22" colspan="3"><strong>Control presupuestario año: <%=v_anos%> </strong> </td>
  </tr>
  <tr>
    <td><strong>Fecha actual: <%=fecha_01%></strong></td>
    <td> </td>
 </tr>
 
</table>

<p></p>
<font color="#0000FF" size="+1" ><strong>Consolidado</strong></font>
<table width="100%" border="1">
	   <tr> 
		<td width="21%"></td>
		<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Reales</strong></div></td>
		<td width="1%"></td>
		<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Presupuestado</strong></div></td>
		<td width="1%"></td>
		<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Desviacion Pesos</strong></div></td>
		<td width="1%"></td>
		<td bgcolor="#66CC99" colspan="3"><div align="center"><strong> % Desviacion </strong></div></td>

	  </tr>

  <tr> 
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Sedes</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
	<td></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
	<td></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
	<td></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>

  </tr>
  <% fila = 1 
     while consolidado.Siguiente %>
  <tr> 
	<td><div align="center"><%=consolidado.ObtenerValor("sede_tdesc")%></div></td>
    <td><div align="center"><%=FormatCurrency(consolidado.ObtenerValor("arancel"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(consolidado.ObtenerValor("titulacion"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(consolidado.ObtenerValor("total"),0)%></div></td>
	<td></td>
	<td><div align="center"><%=FormatCurrency(consolidado.ObtenerValor("presc_aranceles"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(consolidado.ObtenerValor("presc_titulaciones"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(consolidado.ObtenerValor("presc_totales"),0)%></div></td>

	  <% 
	  '***	TOTALIZA MONTOS	**********************
	  arancel_consolidado		=	Ccur(consolidado.ObtenerValor("arancel"))	+	Ccur(arancel_consolidado)
	  titulacion_consolidado	=	Ccur(consolidado.ObtenerValor("titulacion"))+	Ccur(titulacion_consolidado)
	  total_consolidado			=	Ccur(consolidado.ObtenerValor("total"))		+	Ccur(total_consolidado)
	  
	  '** totaliza presupuestos
	  presc_arancel_consolidado		=	Ccur(consolidado.ObtenerValor("presc_aranceles"))	+	Ccur(presc_arancel_consolidado)
	  presc_titulacion_consolidado	=	Ccur(consolidado.ObtenerValor("presc_titulaciones"))+	Ccur(presc_titulacion_consolidado)
	  presc_total_consolidado		=	Ccur(consolidado.ObtenerValor("presc_totales"))		+	Ccur(presc_total_consolidado)
	  
	  '** Desviacion en pesos por sede
	  	v_dif_arancel_sede		=	Ccur(consolidado.ObtenerValor("arancel"))		-	Ccur(consolidado.ObtenerValor("presc_aranceles"))
		v_dif_titulacion_sede	=	Ccur(consolidado.ObtenerValor("titulacion"))	-	Ccur(consolidado.ObtenerValor("presc_titulaciones"))
		v_dif_total_sede		=	Ccur(consolidado.ObtenerValor("total"))			-	Ccur(consolidado.ObtenerValor("presc_totales"))

    	'** Desviacion en porcentajes por sede
	  	v_porc_arancel_sede		=	FormatPercent(Ccur(consolidado.ObtenerValor("arancel"))		/	ReemplazaCero(Ccur(consolidado.ObtenerValor("presc_aranceles"))),2)
		v_porc_titulacion_sede	=	FormatPercent(Ccur(consolidado.ObtenerValor("titulacion"))	/	ReemplazaCero(Ccur(consolidado.ObtenerValor("presc_titulaciones"))),2)
		v_porc_total_sede		=	FormatPercent(Ccur(consolidado.ObtenerValor("total"))		/	ReemplazaCero(Ccur(consolidado.ObtenerValor("presc_totales"))),2)
	%>
	<td></td>
	<td><div align="center"><%=FormatCurrency(v_dif_arancel_sede,0)%></div></td>
	<td><div align="center"><%=FormatCurrency(v_dif_titulacion_sede,0)%></div></td>
	<td><div align="center"><%=FormatCurrency(v_dif_total_sede,0)%></div></td>
	<td></td>
	<td><div align="center"><%=v_porc_arancel_sede%></div></td>
	<td><div align="center"><%=v_porc_titulacion_sede%></div></td>
	<td><div align="center"><%=v_porc_total_sede%></div></td>

  </tr>
<%
  wend %>
    <TR>
	  <TH >Totales x Documentos:</TH>
	  <TH><%=FormatCurrency(arancel_consolidado,0)%></TD>
	  <TH><%=FormatCurrency(titulacion_consolidado,0)%></TH>
	  <TH><%=FormatCurrency(total_consolidado,0)%></TH>
	  <td></td>
	  <TH><%=FormatCurrency(presc_arancel_consolidado,0)%></TD>
	  <TH><%=FormatCurrency(presc_titulacion_consolidado,0)%></TH>
	  <TH><%=FormatCurrency(presc_total_consolidado,0)%></TH>
	  <%
	  '** Desviacion en pesos consolidado
	  	v_dif_arancel_total_sedes		=	arancel_consolidado		-	presc_arancel_consolidado
		v_dif_titulacion_total_sedes	=	titulacion_consolidado	-	presc_titulacion_consolidado
		v_dif_total_total_sedes			=	total_consolidado		-	presc_total_consolidado
	 	
		'** Desviacion en porcentaje consolidado
		v_porc_arancel_total_sedes		=	FormatPercent(arancel_consolidado	/	ReemplazaCero(presc_arancel_consolidado),2)
		v_porc_titulacion_total_sedes	=	FormatPercent(titulacion_consolidado/	ReemplazaCero(presc_titulacion_consolidado),2)
		v_porc_total_total_sedes		=	FormatPercent(total_consolidado		/	ReemplazaCero(presc_total_consolidado),2)

	  %>
	  <td></td>
	  <TH><%=FormatCurrency(v_dif_arancel_total_sedes,0)%></TD>
	  <TH><%=FormatCurrency(v_dif_titulacion_total_sedes,0)%></TH>
	  <TH><%=FormatCurrency(v_dif_total_total_sedes,0)%></TH>
	  <td></td>
	  <TH><%=v_porc_arancel_total_sedes%></TD>
	  <TH><%=v_porc_titulacion_total_sedes%></TH>
	  <TH><%=v_porc_total_total_sedes%></TH>

 </TR>
</table>
<p></p>
<p></p>
</body>
</html>