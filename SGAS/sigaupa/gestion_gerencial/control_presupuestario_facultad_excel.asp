<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "funciones_control_presupuestario.asp" -->

<%
Server.ScriptTimeout = 150000 
Response.AddHeader "Content-Disposition", "attachment;filename=resumen_bancaj_detallado_facultad.xls"
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

		set facu_marketing = new CFormulario
		facu_marketing.carga_parametros "resumen_bancaj_detallado.xml", "resumen_detalle_facultad"
		facu_marketing.inicializar conexion 
		
		set facu_diseno = new CFormulario
		facu_diseno.carga_parametros "resumen_bancaj_detallado.xml", "resumen_detalle_facultad"
		facu_diseno.inicializar conexion 
		
		set facu_comunicaciones = new CFormulario
		facu_comunicaciones.carga_parametros "resumen_bancaj_detallado.xml", "resumen_detalle_facultad"
		facu_comunicaciones.inicializar conexion 
		
		set facu_ciencias = new CFormulario
		facu_ciencias.carga_parametros "resumen_bancaj_detallado.xml", "resumen_detalle_facultad"
		facu_ciencias.inicializar conexion 
		
		set facu_tecnologias = new CFormulario
		facu_tecnologias.carga_parametros "resumen_bancaj_detallado.xml", "resumen_detalle_facultad"
		facu_tecnologias.inicializar conexion 
		
		set facu_institucionales = new CFormulario
		facu_institucionales.carga_parametros "resumen_bancaj_detallado.xml", "resumen_detalle_facultad"
		facu_institucionales.inicializar conexion 
		
		
		sql_facu_marketing		=	ObtenerConsultaFacultadPareo(1,v_anos)
		sql_facu_diseno			=	ObtenerConsultaFacultadPareo(2,v_anos)
		sql_facu_comunicaciones	=	ObtenerConsultaFacultadPareo(3,v_anos)
		sql_facu_ciencias		=	ObtenerConsultaFacultadPareo(4,v_anos)
		sql_facu_tecnologias	=	ObtenerConsultaFacultadPareo(5,v_anos)
		sql_facu_institucionales=	ObtenerConsultaFacultadPareo(8,v_anos)

		if not Esvacio(Request.QueryString) then
			facu_marketing.Consultar sql_facu_marketing
			facu_diseno.Consultar sql_facu_diseno
			facu_comunicaciones.Consultar sql_facu_comunicaciones
			facu_ciencias.Consultar sql_facu_ciencias
			facu_tecnologias.Consultar sql_facu_tecnologias
			facu_institucionales.Consultar sql_facu_institucionales
		else
		
			vacia = "select '' where 1=2 "
			 
			facu_marketing.Consultar vacia
			facu_marketing.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"
			
			facu_diseno.Consultar vacia
			facu_diseno.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"
			
			facu_diseno.Consultar vacia
			facu_diseno.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"

			facu_ciencias.Consultar vacia
			facu_ciencias.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"
			
			facu_tecnologias.Consultar vacia
			facu_tecnologias.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"
			
			facu_institucionales.Consultar vacia
			facu_institucionales.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"
		
			'totales.Consultar vacia
			'totales.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"
		
		end if

%>
<html>
<head>
<title>Control presupuestario agrupado por Facultad</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="3"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif"> Control presupuestario ingresos por Facultad </font></div>
	  <div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr> 
    <td height="22" colspan="3"><strong>Control presupuestario   año: <%=v_anos%> </strong> </td>
  </tr>
  <tr>
    <td><strong>Fecha actual: <%=fecha_01%></strong></td>
    <td> </td>
 </tr>
 
</table>

<p></p>
<font color="#0000FF" size="+1" ><strong>Facultad de Administracion y Marketing</strong></font>
<table width="100%" border="1">
  	   <tr> 
		<td width="21%"   ><font color="#0033FF" size="+1">&nbsp;</font></td>
		<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Reales</strong></div></td>
		<td width="1%"></td>
		<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Presupuestado</strong></div></td>
		<td width="1%"></td>
		<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Desviacion Pesos</strong></div></td>
		<td width="1%"></td>
		<td bgcolor="#66CC99" colspan="3"><div align="center"><strong> % Desviacion </strong></div></td>
	  </tr>
  <tr> 
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Sede</strong></div></td>
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
     while facu_marketing.Siguiente %>
  <tr> 
	<td><div align="center"><%=facu_marketing.ObtenerValor("sede_tdesc")%></div></td>
    <td><div align="center"><%=FormatCurrency(facu_marketing.ObtenerValor("arancel"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(facu_marketing.ObtenerValor("titulacion"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(facu_marketing.ObtenerValor("total"),0)%></div></td>
	<td></td>
    <td><div align="center"><%=FormatCurrency(facu_marketing.ObtenerValor("presc_aranceles"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(facu_marketing.ObtenerValor("presc_titulaciones"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(facu_marketing.ObtenerValor("presc_total"),0)%></div></td>
	<%
	' Desviacion en pesos 
	v_dif_arancel_facu_marketing	=	Ccur(facu_marketing.ObtenerValor("arancel"))	-	Ccur(facu_marketing.ObtenerValor("presc_aranceles"))
	v_dif_titulacion_facu_marketing	=	Ccur(facu_marketing.ObtenerValor("titulacion"))	-	Ccur(facu_marketing.ObtenerValor("presc_titulaciones"))
	v_dif_total_facu_marketing		=	Ccur(facu_marketing.ObtenerValor("total"))		-	Ccur(facu_marketing.ObtenerValor("presc_total"))

	' Desviacion en porcentajes
	v_porc_arancel_facu_marketing	=	FormatPercent(Ccur(facu_marketing.ObtenerValor("arancel"))		/	ReemplazaCero(Ccur(facu_marketing.ObtenerValor("presc_aranceles"))),2)
	v_porc_titulacion_facu_marketing=	FormatPercent(Ccur(facu_marketing.ObtenerValor("titulacion"))	/	ReemplazaCero(Ccur(facu_marketing.ObtenerValor("presc_titulaciones"))),2)
	v_porc_total_facu_marketing		=	FormatPercent(Ccur(facu_marketing.ObtenerValor("total"))		/	ReemplazaCero(Ccur(facu_marketing.ObtenerValor("presc_total"))),2)
	%>
	<td></td>
    <td><div align="center"><%=FormatCurrency(v_dif_arancel_facu_marketing,0)%></div></td>
	<td><div align="center"><%=FormatCurrency(v_dif_titulacion_facu_marketing,0)%></div></td>
	<td><div align="center"><%=FormatCurrency(v_dif_total_facu_marketing,0)%></div></td>
	<td></td>
    <td><div align="center"><%=v_porc_arancel_facu_marketing%></div></td>
	<td><div align="center"><%=v_porc_titulacion_facu_marketing%></div></td>
	<td><div align="center"><%=v_porc_total_facu_marketing%></div></td>

  </tr>
  <% 
  '***	TOTALIZA MONTOS REALES	**********************
  arancel_facu_marketing		=	Ccur(facu_marketing.ObtenerValor("arancel"))	+	Ccur(arancel_facu_marketing)
  titulacion_facu_marketing		=	Ccur(facu_marketing.ObtenerValor("titulacion"))	+	Ccur(titulacion_facu_marketing)
  total_facu_marketing			=	Ccur(facu_marketing.ObtenerValor("total"))		+	Ccur(total_facu_marketing)
 
  '***	TOTALIZA MONTOS PRESUPUESTADOS	**********************
  presc_arancel_facu_marketing		=	Ccur(facu_marketing.ObtenerValor("presc_aranceles"))	+	Ccur(presc_arancel_facu_marketing)
  presc_titulacion_facu_marketing	=	Ccur(facu_marketing.ObtenerValor("presc_titulaciones"))	+	Ccur(presc_titulacion_facu_marketing)
  presc_total_facu_marketing		=	Ccur(facu_marketing.ObtenerValor("presc_total"))		+	Ccur(presc_total_facu_marketing)

  wend %>
    <TR>
	  <TH  >Totales x Documentos:</TH>
	  <TH><%=FormatCurrency(arancel_facu_marketing,0)%></TH>
	  <TH><%=FormatCurrency(titulacion_facu_marketing,0)%></TH>
	  <TH><%=FormatCurrency(total_facu_marketing,0)%></TH>
	  <td></td>
	  <TH><%=FormatCurrency(presc_arancel_facu_marketing,0)%></TH>
	  <TH><%=FormatCurrency(presc_titulacion_facu_marketing,0)%></TH>
	  <TH><%=FormatCurrency(presc_total_facu_marketing,0)%></TH>
	  <%
	  '** desviacion total facultad en pesos
	   v_dif_arancel_marketing		=	arancel_facu_marketing		-	presc_arancel_facu_marketing
	   v_dif_titulacion_marketing	=	titulacion_facu_marketing	-	presc_titulacion_facu_marketing
	   v_dif_total_marketing		=	total_facu_marketing		-	presc_total_facu_marketing
	   
	   '** desviacion total facultad en porcentaje
	   v_porc_arancel_marketing		=	FormatPercent(arancel_facu_marketing	/	ReemplazaCero(presc_arancel_facu_marketing),2)
	   v_porc_titulacion_marketing	=	FormatPercent(titulacion_facu_marketing	/	ReemplazaCero(presc_titulacion_facu_marketing),2)
	   v_porc_total_marketing		=	FormatPercent(total_facu_marketing		/	ReemplazaCero(presc_total_facu_marketing),2)

	  %>
	  <td></td>
	  <TH><%=FormatCurrency(v_dif_arancel_marketing,0)%></TH>
	  <TH><%=FormatCurrency(v_dif_titulacion_marketing,0)%></TH>
	  <TH><%=FormatCurrency(v_dif_total_marketing,0)%></TH>
	  <td></td>
	  <TH><%=v_porc_arancel_marketing%></TH>
	  <TH><%=v_porc_titulacion_marketing%></TH>
	  <TH><%=v_porc_total_marketing%></TH>

 </TR>
</table>
<p>&nbsp;</p>
<p></p>
<p></p> 
<font color="#0000FF" size="+1" ><strong>Facultad de Diseño</strong></font>
<table width="100%" border="1">
    	<tr> 
		<td width="21%"   ><font color="#0033FF" size="+1">&nbsp;</font></td>
		<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Reales</strong></div></td>
		<td width="1%"></td>
		<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Presupuestado</strong></div></td>
		<td width="1%"></td>
		<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Desviacion Pesos</strong></div></td>
		<td width="1%"></td>
		<td bgcolor="#66CC99" colspan="3"><div align="center"><strong> % Desviacion </strong></div></td>
	  </tr>
  <tr> 
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Sede</strong></div></td>
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
  <%  while facu_diseno.Siguiente %>
  <tr> 
	<td><div align="center"><%=facu_diseno.ObtenerValor("sede_tdesc")%></div></td>
	<td><div align="center"><%=FormatCurrency(facu_diseno.ObtenerValor("arancel"),0)%></div></td>
    <td><div align="center"><%=FormatCurrency(facu_diseno.ObtenerValor("titulacion"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(facu_diseno.ObtenerValor("total"),0)%></div></td>
  	<td></td>
    <td><div align="center"><%=FormatCurrency(facu_diseno.ObtenerValor("presc_aranceles"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(facu_diseno.ObtenerValor("presc_titulaciones"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(facu_diseno.ObtenerValor("presc_total"),0)%></div></td>
	<%
	' Desviacion en pesos 
	v_dif_arancel_facu_diseno	=	Ccur(facu_diseno.ObtenerValor("arancel"))	-	Ccur(facu_diseno.ObtenerValor("presc_aranceles"))
	v_dif_titulacion_facu_diseno	=	Ccur(facu_diseno.ObtenerValor("titulacion"))-	Ccur(facu_diseno.ObtenerValor("presc_titulaciones"))
	v_dif_total_facu_diseno		=	Ccur(facu_diseno.ObtenerValor("total"))		-	Ccur(facu_diseno.ObtenerValor("presc_total"))

	' Desviacion en porcentajes
	v_porc_arancel_facu_diseno	=	FormatPercent(Ccur(facu_diseno.ObtenerValor("arancel"))		/	ReemplazaCero(Ccur(facu_diseno.ObtenerValor("presc_aranceles"))),2)
	v_porc_titulacion_facu_diseno=	FormatPercent(Ccur(facu_diseno.ObtenerValor("titulacion"))	/	ReemplazaCero(Ccur(facu_diseno.ObtenerValor("presc_titulaciones"))),2)
	v_porc_total_facu_diseno	 =	FormatPercent(Ccur(facu_diseno.ObtenerValor("total"))		/	ReemplazaCero(Ccur(facu_diseno.ObtenerValor("presc_total"))),2)
	%>
	<td></td>
    <td><div align="center"><%=FormatCurrency(v_dif_arancel_facu_diseno,0)%></div></td>
	<td><div align="center"><%=FormatCurrency(v_dif_titulacion_facu_diseno,0)%></div></td>
	<td><div align="center"><%=FormatCurrency(v_dif_total_facu_diseno,0)%></div></td>
	<td></td>
    <td><div align="center"><%=v_porc_arancel_facu_diseno%></div></td>
	<td><div align="center"><%=v_porc_titulacion_facu_diseno%></div></td>
	<td><div align="center"><%=v_porc_total_facu_diseno%></div></td>

  </tr>

  <% 
   '***	TOTALIZA MONTOS Reales	**********************
  arancel_facu_diseno		=	Ccur(facu_diseno.ObtenerValor("arancel"))		+	Ccur(arancel_facu_diseno)
  titulacion_facu_diseno	=	Ccur(facu_diseno.ObtenerValor("titulacion"))	+	Ccur(titulacion_facu_diseno)
  total_facu_diseno			=	Ccur(facu_diseno.ObtenerValor("total"))			+	Ccur(total_facu_diseno)

 
  '***	TOTALIZA MONTOS PRESUPUESTADOS	**********************
  presc_arancel_facu_diseno		=	Ccur(facu_diseno.ObtenerValor("presc_aranceles"))		+	Ccur(presc_arancel_facu_diseno)
  presc_titulacion_facu_diseno	=	Ccur(facu_diseno.ObtenerValor("presc_titulaciones"))	+	Ccur(presc_titulacion_facu_diseno)
  presc_total_facu_diseno		=	Ccur(facu_diseno.ObtenerValor("presc_total"))		+	Ccur(presc_total_facu_diseno)

  wend %>
  
    <TR>
	  <TH>Totales x Documentos:</TH>
	  <TH><%=FormatCurrency(arancel_facu_diseno,0)%></TH>
	  <TH><%=FormatCurrency(titulacion_facu_diseno,0)%></TH>
	  <TH><%=FormatCurrency(total_facu_diseno,0)%></TH>
	  <td></td>
	  <TH><%=FormatCurrency(presc_arancel_facu_diseno,0)%></TH>
	  <TH><%=FormatCurrency(presc_titulacion_facu_diseno,0)%></TH>
	  <TH><%=FormatCurrency(presc_total_facu_diseno,0)%></TH>
	  <%
	  '** desviacion total facultad en pesos
	   v_dif_arancel_diseno		=	arancel_facu_diseno		-	presc_arancel_facu_diseno
	   v_dif_titulacion_diseno	=	titulacion_facu_diseno	-	presc_titulacion_facu_diseno
	   v_dif_total_diseno		=	total_facu_diseno		-	presc_total_facu_diseno
	   
	   '** desviacion total facultad en porcentaje
	   v_porc_arancel_diseno	=	FormatPercent(arancel_facu_diseno	/	ReemplazaCero(presc_arancel_facu_diseno),2)
	   v_porc_titulacion_diseno	=	FormatPercent(titulacion_facu_diseno/	ReemplazaCero(presc_titulacion_facu_diseno),2)
	   v_porc_total_diseno		=	FormatPercent(total_facu_diseno		/	ReemplazaCero(presc_total_facu_diseno),2)

	  %>
	  <td></td>
	  <TH><%=FormatCurrency(v_dif_arancel_diseno,0)%></TH>
	  <TH><%=FormatCurrency(v_dif_titulacion_diseno,0)%></TH>
	  <TH><%=FormatCurrency(v_dif_total_diseno,0)%></TH>
	  <td></td>
	  <TH><%=v_porc_arancel_diseno%></TH>
	  <TH><%=v_porc_titulacion_diseno%></TH>
	  <TH><%=v_porc_total_diseno%></TH>

  </TR>

</table>
<p>&nbsp;</p>
<p></p>
<p></p> 
<font color="#0000FF" size="+1"><strong>Facultad de Comunicaciones</strong></font>
<table width="100%" border="1">
  <tr>
    <td   ><font color="#0033FF" size="+1">&nbsp;</font></td>
    <td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Reales</strong></div></td>
    <td></td>
    <td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Presupuestado</strong></div></td>
    <td></td>
    <td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Desviacion Pesos</strong></div></td>
    <td></td>
    <td bgcolor="#66CC99" colspan="3"><div align="center"><strong> % Desviacion </strong></div></td>
  </tr>
  <tr> 
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Sede</strong></div></td>
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
  <%  
     while facu_comunicaciones.Siguiente %>
  <tr> 
	<td><div align="center"><%=facu_comunicaciones.ObtenerValor("sede_tdesc")%></div></td>
	<td><div align="center"><%=FormatCurrency(facu_comunicaciones.ObtenerValor("arancel"),0)%></div></td>
    <td><div align="center"><%=FormatCurrency(facu_comunicaciones.ObtenerValor("titulacion"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(facu_comunicaciones.ObtenerValor("total"),0)%></div></td>
  	<td></td>
    <td><div align="center"><%=FormatCurrency(facu_comunicaciones.ObtenerValor("presc_aranceles"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(facu_comunicaciones.ObtenerValor("presc_titulaciones"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(facu_comunicaciones.ObtenerValor("presc_total"),0)%></div></td>
	<%
	' Desviacion en pesos 
	v_dif_arancel_facu_comunicaciones	=	Ccur(facu_comunicaciones.ObtenerValor("arancel"))	-	Ccur(facu_comunicaciones.ObtenerValor("presc_aranceles"))
	v_dif_titulacion_facu_comunicaciones	=	Ccur(facu_comunicaciones.ObtenerValor("titulacion"))-	Ccur(facu_comunicaciones.ObtenerValor("presc_titulaciones"))
	v_dif_total_facu_comunicaciones		=	Ccur(facu_comunicaciones.ObtenerValor("total"))		-	Ccur(facu_comunicaciones.ObtenerValor("presc_total"))

	' Desviacion en porcentajes
	v_porc_arancel_facu_comunicaciones	=	FormatPercent(Ccur(facu_comunicaciones.ObtenerValor("arancel"))		/	ReemplazaCero(Ccur(facu_comunicaciones.ObtenerValor("presc_aranceles"))),2)
	v_porc_titulacion_facu_comunicaciones=	FormatPercent(Ccur(facu_comunicaciones.ObtenerValor("titulacion"))	/	ReemplazaCero(Ccur(facu_comunicaciones.ObtenerValor("presc_titulaciones"))),2)
	v_porc_total_facu_comunicaciones	 =	FormatPercent(Ccur(facu_comunicaciones.ObtenerValor("total"))		/	ReemplazaCero(Ccur(facu_comunicaciones.ObtenerValor("presc_total"))),2)
	%>
	<td></td>
    <td><div align="center"><%=FormatCurrency(v_dif_arancel_facu_comunicaciones,0)%></div></td>
	<td><div align="center"><%=FormatCurrency(v_dif_titulacion_facu_comunicaciones,0)%></div></td>
	<td><div align="center"><%=FormatCurrency(v_dif_total_facu_comunicaciones,0)%></div></td>
	<td></td>
    <td><div align="center"><%=v_porc_arancel_facu_comunicaciones%></div></td>
	<td><div align="center"><%=v_porc_titulacion_facu_comunicaciones%></div></td>
	<td><div align="center"><%=v_porc_total_facu_comunicaciones%></div></td>


  </tr>
  <% 
  '***	TOTALIZA MONTOS	**********************
  arancel_facu_comunicaciones		=	Ccur(facu_comunicaciones.ObtenerValor("arancel"))		+	Ccur(arancel_facu_comunicaciones)
  titulacion_facu_comunicaciones	=	Ccur(facu_comunicaciones.ObtenerValor("titulacion"))	+	Ccur(titulacion_facu_comunicaciones)
  total_facu_comunicaciones			=	Ccur(facu_comunicaciones.ObtenerValor("total"))			+	Ccur(total_facu_comunicaciones)

  '***	TOTALIZA MONTOS PRESUPUESTADOS	**********************
  presc_arancel_facu_comunicaciones		=	Ccur(facu_comunicaciones.ObtenerValor("presc_aranceles"))		+	Ccur(presc_arancel_facu_comunicaciones)
  presc_titulacion_facu_comunicaciones	=	Ccur(facu_comunicaciones.ObtenerValor("presc_titulaciones"))	+	Ccur(presc_titulacion_facu_comunicaciones)
  presc_total_facu_comunicaciones		=	Ccur(facu_comunicaciones.ObtenerValor("presc_total"))		+	Ccur(presc_total_facu_comunicaciones)

  wend %>
    <TR>
	  <TH>Totales x Documentos:</TH>
	  <TH><%=FormatCurrency(arancel_facu_comunicaciones,0)%></TH>
	  <TH><%=FormatCurrency(titulacion_facu_comunicaciones,0)%></TH>
	  <TH><%=FormatCurrency(total_facu_comunicaciones,0)%></TH>
	  <td></td>
	  <TH><%=FormatCurrency(presc_arancel_facu_comunicaciones,0)%></TH>
	  <TH><%=FormatCurrency(presc_titulacion_facu_comunicaciones,0)%></TH>
	  <TH><%=FormatCurrency(presc_total_facu_comunicaciones,0)%></TH>
	  <%
	  '** desviacion total facultad en pesos
	   v_dif_arancel_comunicaciones		=	arancel_facu_comunicaciones		-	presc_arancel_facu_comunicaciones
	   v_dif_titulacion_comunicaciones	=	titulacion_facu_comunicaciones	-	presc_titulacion_facu_comunicaciones
	   v_dif_total_comunicaciones		=	total_facu_comunicaciones		-	presc_total_facu_comunicaciones
	   
	   '** desviacion total facultad en porcentaje
	   v_porc_arancel_comunicaciones	=	FormatPercent(arancel_facu_comunicaciones	/	ReemplazaCero(presc_arancel_facu_comunicaciones),2)
	   v_porc_titulacion_comunicaciones	=	FormatPercent(titulacion_facu_comunicaciones/	ReemplazaCero(presc_titulacion_facu_comunicaciones),2)
	   v_porc_total_comunicaciones		=	FormatPercent(total_facu_comunicaciones		/	ReemplazaCero(presc_total_facu_comunicaciones),2)

	  %>
	  <td></td>
	  <TH><%=FormatCurrency(v_dif_arancel_comunicaciones,0)%></TH>
	  <TH><%=FormatCurrency(v_dif_titulacion_comunicaciones,0)%></TH>
	  <TH><%=FormatCurrency(v_dif_total_comunicaciones,0)%></TH>
	  <td></td>
	  <TH><%=v_porc_arancel_comunicaciones%></TH>
	  <TH><%=v_porc_titulacion_comunicaciones%></TH>
	  <TH><%=v_porc_total_comunicaciones%></TH>

  </TR>

</table>
<p>&nbsp;</p>

<font color="#0000FF" size="+1" ><strong>Facultad de Ciencias Humanas y Educacion</strong></font>
<table width="100%" border="1">
  <tr>
    <td   ><font color="#0033FF" size="+1">&nbsp;</font></td>
    <td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Reales</strong></div></td>
    <td></td>
    <td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Presupuestado</strong></div></td>
    <td></td>
    <td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Desviacion Pesos</strong></div></td>
    <td></td>
    <td bgcolor="#66CC99" colspan="3"><div align="center"><strong> % Desviacion </strong></div></td>
  </tr>
  <tr>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Sede</strong></div></td>
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
     while facu_ciencias.Siguiente %>
  <tr>
    <td><div align="center"><%=facu_ciencias.ObtenerValor("sede_tdesc")%></div></td>
    <td><div align="center"><%=FormatCurrency(facu_ciencias.ObtenerValor("arancel"),0)%></div></td>
    <td><div align="center"><%=FormatCurrency(facu_ciencias.ObtenerValor("titulacion"),0)%></div></td>
    <td><div align="center"><%=FormatCurrency(facu_ciencias.ObtenerValor("total"),0)%></div></td>
  	<td></td>
    <td><div align="center"><%=FormatCurrency(facu_ciencias.ObtenerValor("presc_aranceles"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(facu_ciencias.ObtenerValor("presc_titulaciones"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(facu_ciencias.ObtenerValor("presc_total"),0)%></div></td>
	<%
	' Desviacion en pesos 
	v_dif_arancel_facu_ciencias		=	Ccur(facu_ciencias.ObtenerValor("arancel"))		-	Ccur(facu_ciencias.ObtenerValor("presc_aranceles"))
	v_dif_titulacion_facu_ciencias	=	Ccur(facu_ciencias.ObtenerValor("titulacion"))	-	Ccur(facu_ciencias.ObtenerValor("presc_titulaciones"))
	v_dif_total_facu_ciencias		=	Ccur(facu_ciencias.ObtenerValor("total"))		-	Ccur(facu_ciencias.ObtenerValor("presc_total"))

	' Desviacion en porcentajes
	v_porc_arancel_facu_ciencias	=	FormatPercent(Ccur(facu_ciencias.ObtenerValor("arancel"))	/	ReemplazaCero(Ccur(facu_ciencias.ObtenerValor("presc_aranceles"))),2)
	v_porc_titulacion_facu_ciencias	=	FormatPercent(Ccur(facu_ciencias.ObtenerValor("titulacion"))/	ReemplazaCero(Ccur(facu_ciencias.ObtenerValor("presc_titulaciones"))),2)
	v_porc_total_facu_ciencias	 	=	FormatPercent(Ccur(facu_ciencias.ObtenerValor("total"))		/	ReemplazaCero(Ccur(facu_ciencias.ObtenerValor("presc_total"))),2)
	%>
	<td></td>
    <td><div align="center"><%=FormatCurrency(v_dif_arancel_facu_ciencias,0)%></div></td>
	<td><div align="center"><%=FormatCurrency(v_dif_titulacion_facu_ciencias,0)%></div></td>
	<td><div align="center"><%=FormatCurrency(v_dif_total_facu_ciencias,0)%></div></td>
	<td></td>
    <td><div align="center"><%=v_porc_arancel_facu_ciencias%></div></td>
	<td><div align="center"><%=v_porc_titulacion_facu_ciencias%></div></td>
	<td><div align="center"><%=v_porc_total_facu_ciencias%></div></td>

  </tr>

  <% 
  '***	TOTALIZA MONTOS	**********************
  arancel_facu_ciencias		=	Ccur(facu_ciencias.ObtenerValor("arancel"))		+	Ccur(arancel_facu_ciencias)
  titulacion_facu_ciencias	=	Ccur(facu_ciencias.ObtenerValor("titulacion"))	+	Ccur(titulacion_facu_ciencias)
  total_facu_ciencias		=	Ccur(facu_ciencias.ObtenerValor("total"))		+	Ccur(total_facu_ciencias)
  
  '***	TOTALIZA MONTOS PRESUPUESTADOS	**********************
  presc_arancel_facu_ciencias		=	Ccur(facu_ciencias.ObtenerValor("presc_aranceles"))	+	Ccur(presc_arancel_facu_ciencias)
  presc_titulacion_facu_ciencias	=	Ccur(facu_ciencias.ObtenerValor("presc_titulaciones"))+	Ccur(presc_titulacion_facu_ciencias)
  presc_total_facu_ciencias			=	Ccur(facu_ciencias.ObtenerValor("presc_total"))		+	Ccur(presc_total_facu_ciencias)

  
  wend %>
  <TR>
    <TH>Totales x Documentos:</TH>
    <TH><%=FormatCurrency(arancel_facu_ciencias,0)%></TH>
    <TH><%=FormatCurrency(titulacion_facu_ciencias,0)%></TH>
    <TH><%=FormatCurrency(total_facu_ciencias,0)%></TH>
	  <td></td>
	<TH><%=FormatCurrency(presc_arancel_facu_ciencias,0)%></TH>
	<TH><%=FormatCurrency(presc_titulacion_facu_ciencias,0)%></TH>
	<TH><%=FormatCurrency(presc_total_facu_ciencias,0)%></TH>
	  <%
	  '** desviacion total facultad en pesos
	   v_dif_arancel_ciencias		=	arancel_facu_ciencias	-	presc_arancel_facu_ciencias
	   v_dif_titulacion_ciencias	=	titulacion_facu_ciencias-	presc_titulacion_facu_ciencias
	   v_dif_total_ciencias		=	total_facu_ciencias		-	presc_total_facu_ciencias
	   
	   '** desviacion total facultad en porcentaje
	   v_porc_arancel_ciencias	=	FormatPercent(arancel_facu_ciencias	/	ReemplazaCero(presc_arancel_facu_ciencias),2)
	   v_porc_titulacion_ciencias	=	FormatPercent(titulacion_facu_ciencias/	ReemplazaCero(presc_titulacion_facu_ciencias),2)
	   v_porc_total_ciencias		=	FormatPercent(total_facu_ciencias		/	ReemplazaCero(presc_total_facu_ciencias),2)

	  %>
	  <td></td>
	  <TH><%=FormatCurrency(v_dif_arancel_ciencias,0)%></TH>
	  <TH><%=FormatCurrency(v_dif_titulacion_ciencias,0)%></TH>
	  <TH><%=FormatCurrency(v_dif_total_ciencias,0)%></TH>
	  <td></td>
	  <TH><%=v_porc_arancel_ciencias%></TH>
	  <TH><%=v_porc_titulacion_ciencias%></TH>
	  <TH><%=v_porc_total_ciencias%></TH>

  </TR>

</table>
<p>&nbsp;</p>
<p></p>
<p></p>
<font color="#0000FF" size="+1" ><strong>Facultad de Tecnologias de la Informacion y Comunicacion</strong></font>
<table width="100%" border="1">
  <tr>
    <td   ><font color="#0033FF" size="+1">&nbsp;</font></td>
    <td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Reales</strong></div></td>
    <td></td>
    <td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Presupuestado</strong></div></td>
    <td></td>
    <td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Desviacion Pesos</strong></div></td>
    <td></td>
    <td bgcolor="#66CC99" colspan="3"><div align="center"><strong> % Desviacion </strong></div></td>
  </tr>
  <tr>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Sede</strong></div></td>
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
  <%  while facu_tecnologias.Siguiente %>
  <tr>
    <td><div align="center"><%=facu_tecnologias.ObtenerValor("sede_tdesc")%></div></td>
    <td><div align="center"><%=FormatCurrency(facu_tecnologias.ObtenerValor("arancel"),0)%></div></td>
    <td><div align="center"><%=FormatCurrency(facu_tecnologias.ObtenerValor("titulacion"),0)%></div></td>
    <td><div align="center"><%=FormatCurrency(facu_tecnologias.ObtenerValor("total"),0)%></div></td>
  	<td></td>
    <td><div align="center"><%=FormatCurrency(facu_tecnologias.ObtenerValor("presc_aranceles"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(facu_tecnologias.ObtenerValor("presc_titulaciones"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(facu_tecnologias.ObtenerValor("presc_total"),0)%></div></td>
	<%
	' Desviacion en pesos 
	v_dif_arancel_facu_tecnologias		=	Ccur(facu_tecnologias.ObtenerValor("arancel"))		-	Ccur(facu_tecnologias.ObtenerValor("presc_aranceles"))
	v_dif_titulacion_facu_tecnologias	=	Ccur(facu_tecnologias.ObtenerValor("titulacion"))	-	Ccur(facu_tecnologias.ObtenerValor("presc_titulaciones"))
	v_dif_total_facu_tecnologias		=	Ccur(facu_tecnologias.ObtenerValor("total"))		-	Ccur(facu_tecnologias.ObtenerValor("presc_total"))

	' Desviacion en porcentajes
	v_porc_arancel_facu_tecnologias	=	FormatPercent(Ccur(facu_tecnologias.ObtenerValor("arancel"))	/	ReemplazaCero(Ccur(facu_tecnologias.ObtenerValor("presc_aranceles"))),2)
	v_porc_titulacion_facu_tecnologias	=	FormatPercent(Ccur(facu_tecnologias.ObtenerValor("titulacion"))/	ReemplazaCero(Ccur(facu_tecnologias.ObtenerValor("presc_titulaciones"))),2)
	v_porc_total_facu_tecnologias	 	=	FormatPercent(Ccur(facu_tecnologias.ObtenerValor("total"))		/	ReemplazaCero(Ccur(facu_tecnologias.ObtenerValor("presc_total"))),2)
	%>
	<td></td>
    <td><div align="center"><%=FormatCurrency(v_dif_arancel_facu_tecnologias,0)%></div></td>
	<td><div align="center"><%=FormatCurrency(v_dif_titulacion_facu_tecnologias,0)%></div></td>
	<td><div align="center"><%=FormatCurrency(v_dif_total_facu_tecnologias,0)%></div></td>
	<td></td>
    <td><div align="center"><%=v_porc_arancel_facu_tecnologias%></div></td>
	<td><div align="center"><%=v_porc_titulacion_facu_tecnologias%></div></td>
	<td><div align="center"><%=v_porc_total_facu_tecnologias%></div></td>

  </tr>

  <% 
   '***	TOTALIZA MONTOS	**********************
  arancel_facu_tecnologias		=	Ccur(facu_tecnologias.ObtenerValor("arancel"))		+	Ccur(arancel_facu_tecnologias)
  titulacion_facu_tecnologias	=	Ccur(facu_tecnologias.ObtenerValor("titulacion"))	+	Ccur(titulacion_facu_tecnologias)
  total_facu_tecnologias		=	Ccur(facu_tecnologias.ObtenerValor("total"))		+	Ccur(total_facu_tecnologias)

  '***	TOTALIZA MONTOS PRESUPUESTADOS	**********************
  presc_arancel_facu_tecnologias		=	Ccur(facu_tecnologias.ObtenerValor("presc_aranceles"))	+	Ccur(presc_arancel_facu_tecnologias)
  presc_titulacion_facu_tecnologias	=	Ccur(facu_tecnologias.ObtenerValor("presc_titulaciones"))+	Ccur(presc_titulacion_facu_tecnologias)
  presc_total_facu_tecnologias			=	Ccur(facu_tecnologias.ObtenerValor("presc_total"))		+	Ccur(presc_total_facu_tecnologias)

  wend %>
  <TR>
    <TH>Totales x Documentos:</TH>
    <TH><%=FormatCurrency(arancel_facu_tecnologias,0)%></TH>
    <TH><%=FormatCurrency(titulacion_facu_tecnologias,0)%></TH>
    <TH><%=FormatCurrency(total_facu_tecnologias,0)%></TH>
	<td></td>
	<TH><%=FormatCurrency(presc_arancel_facu_tecnologias,0)%></TH>
	<TH><%=FormatCurrency(presc_titulacion_facu_tecnologias,0)%></TH>
	<TH><%=FormatCurrency(presc_total_facu_tecnologias,0)%></TH>
	  <%
	  '** desviacion total facultad en pesos
	   v_dif_arancel_tecnologias	=	arancel_facu_tecnologias	-	presc_arancel_facu_tecnologias
	   v_dif_titulacion_tecnologias	=	titulacion_facu_tecnologias	-	presc_titulacion_facu_tecnologias
	   v_dif_total_tecnologias		=	total_facu_tecnologias		-	presc_total_facu_tecnologias
	   
	   '** desviacion total facultad en porcentaje
	   v_porc_arancel_tecnologias	=	FormatPercent(arancel_facu_tecnologias	/	ReemplazaCero(presc_arancel_facu_tecnologias),2)
	   v_porc_titulacion_tecnologias=	FormatPercent(titulacion_facu_tecnologias/	ReemplazaCero(presc_titulacion_facu_tecnologias),2)
	   v_porc_total_tecnologias		=	FormatPercent(total_facu_tecnologias	/	ReemplazaCero(presc_total_facu_tecnologias),2)

	  %>
	  <td></td>
	  <TH><%=FormatCurrency(v_dif_arancel_tecnologias,0)%></TH>
	  <TH><%=FormatCurrency(v_dif_titulacion_tecnologias,0)%></TH>
	  <TH><%=FormatCurrency(v_dif_total_tecnologias,0)%></TH>
	  <td></td>
	  <TH><%=v_porc_arancel_tecnologias%></TH>
	  <TH><%=v_porc_titulacion_tecnologias%></TH>
	  <TH><%=v_porc_total_tecnologias%></TH>

  </TR>
</table>
<p>&nbsp;</p>
<p></p>
<p></p>
<font color="#0000FF" size="+1"><strong>Area Ciencias Agropecuarias y de Salud</strong></font>
<table width="100%" border="1">
  <tr>
    <td><font color="#0033FF" size="+1">&nbsp;</font></td>
    <td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Reales</strong></div></td>
    <td></td>
    <td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Presupuestado</strong></div></td>
    <td></td>
    <td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Desviacion Pesos</strong></div></td>
    <td></td>
    <td bgcolor="#66CC99" colspan="3"><div align="center"><strong> % Desviacion </strong></div></td>
  </tr>
  <tr>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Sede</strong></div></td>
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
  <%  
     while facu_institucionales.Siguiente %>
  <tr>

    <td><div align="center"><%=facu_institucionales.ObtenerValor("sede_tdesc")%></div></td>
    <td><div align="center"><%=FormatCurrency(facu_institucionales.ObtenerValor("arancel"),0)%></div></td>
    <td><div align="center"><%=FormatCurrency(facu_institucionales.ObtenerValor("titulacion"),0)%></div></td>
    <td><div align="center"><%=FormatCurrency(facu_institucionales.ObtenerValor("total"),0)%></div></td>
  	<td></td>
    <td><div align="center"><%=FormatCurrency(facu_institucionales.ObtenerValor("presc_aranceles"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(facu_institucionales.ObtenerValor("presc_titulaciones"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(facu_institucionales.ObtenerValor("presc_total"),0)%></div></td>
	<%
	' Desviacion en pesos 
	v_dif_arancel_facu_institucionales		=	Ccur(facu_institucionales.ObtenerValor("arancel"))		-	Ccur(facu_institucionales.ObtenerValor("presc_aranceles"))
	v_dif_titulacion_facu_institucionales	=	Ccur(facu_institucionales.ObtenerValor("titulacion"))	-	Ccur(facu_institucionales.ObtenerValor("presc_titulaciones"))
	v_dif_total_facu_institucionales		=	Ccur(facu_institucionales.ObtenerValor("total"))		-	Ccur(facu_institucionales.ObtenerValor("presc_total"))

	' Desviacion en porcentajes
	v_porc_arancel_facu_institucionales	=	FormatPercent(Ccur(facu_institucionales.ObtenerValor("arancel"))	/	ReemplazaCero(Ccur(facu_institucionales.ObtenerValor("presc_aranceles"))),2)
	v_porc_titulacion_facu_institucionales	=	FormatPercent(Ccur(facu_institucionales.ObtenerValor("titulacion"))/	ReemplazaCero(Ccur(facu_institucionales.ObtenerValor("presc_titulaciones"))),2)
	v_porc_total_facu_institucionales	 	=	FormatPercent(Ccur(facu_institucionales.ObtenerValor("total"))		/	ReemplazaCero(Ccur(facu_institucionales.ObtenerValor("presc_total"))),2)
	%>
	<td></td>
    <td><div align="center"><%=FormatCurrency(v_dif_arancel_facu_institucionales,0)%></div></td>
	<td><div align="center"><%=FormatCurrency(v_dif_titulacion_facu_institucionales,0)%></div></td>
	<td><div align="center"><%=FormatCurrency(v_dif_total_facu_institucionales,0)%></div></td>
	<td></td>
    <td><div align="center"><%=v_porc_arancel_facu_institucionales%></div></td>
	<td><div align="center"><%=v_porc_titulacion_facu_institucionales%></div></td>
	<td><div align="center"><%=v_porc_total_facu_institucionales%></div></td>

  </tr>

  <% 
  '***	TOTALIZA MONTOS	**********************
  arancel_facu_institucionales		=	Ccur(facu_institucionales.ObtenerValor("arancel"))		+	Ccur(arancel_facu_institucionales)
  titulacion_facu_institucionales	=	Ccur(facu_institucionales.ObtenerValor("titulacion"))	+	Ccur(titulacion_facu_institucionales)
  total_facu_institucionales		=	Ccur(facu_institucionales.ObtenerValor("total"))			+	Ccur(total_facu_institucionales)

  '***	TOTALIZA MONTOS PRESUPUESTADOS	**********************
  presc_arancel_facu_institucionales		=	Ccur(facu_institucionales.ObtenerValor("presc_aranceles"))	+	Ccur(presc_arancel_facu_institucionales)
  presc_titulacion_facu_institucionales	=	Ccur(facu_institucionales.ObtenerValor("presc_titulaciones"))+	Ccur(presc_titulacion_facu_institucionales)
  presc_total_facu_institucionales			=	Ccur(facu_institucionales.ObtenerValor("presc_total"))		+	Ccur(presc_total_facu_institucionales)


  wend %>
  <TR>
    <TH>Totales x Documentos:</TH>
    <TH><%=FormatCurrency(arancel_facu_institucionales,0)%></TH>
    <TH><%=FormatCurrency(titulacion_facu_institucionales,0)%></TH>
    <TH><%=FormatCurrency(total_facu_institucionales,0)%></TH>
	<td></td>
	<TH><%=FormatCurrency(presc_arancel_facu_institucionales,0)%></TH>
	<TH><%=FormatCurrency(presc_titulacion_facu_institucionales,0)%></TH>
	<TH><%=FormatCurrency(presc_total_facu_institucionales,0)%></TH>
	  <%
	  '** desviacion total facultad en pesos
	   v_dif_arancel_institucionales	=	arancel_facu_institucionales	-	presc_arancel_facu_institucionales
	   v_dif_titulacion_institucionales	=	titulacion_facu_institucionales	-	presc_titulacion_facu_institucionales
	   v_dif_total_institucionales		=	total_facu_institucionales		-	presc_total_facu_institucionales
	   
	   '** desviacion total facultad en porcentaje
	   v_porc_arancel_institucionales	=	FormatPercent(arancel_facu_institucionales	/	ReemplazaCero(presc_arancel_facu_institucionales),2)
	   v_porc_titulacion_institucionales=	FormatPercent(titulacion_facu_institucionales/	ReemplazaCero(presc_titulacion_facu_institucionales),2)
	   v_porc_total_institucionales		=	FormatPercent(total_facu_institucionales	/	ReemplazaCero(presc_total_facu_institucionales),2)

	  %>
	  <td></td>
	  <TH><%=FormatCurrency(v_dif_arancel_institucionales,0)%></TH>
	  <TH><%=FormatCurrency(v_dif_titulacion_institucionales,0)%></TH>
	  <TH><%=FormatCurrency(v_dif_total_institucionales,0)%></TH>
	  <td></td>
	  <TH><%=v_porc_arancel_institucionales%></TH>
	  <TH><%=v_porc_titulacion_institucionales%></TH>
	  <TH><%=v_porc_total_institucionales%></TH>

</table>
<p>
  <%
' calculo de totales globales por facultades (valor real)
v_total_arancel		=	arancel_facu_marketing		+	arancel_facu_diseno		+	arancel_facu_comunicaciones 	+	arancel_facu_ciencias		+	arancel_facu_tecnologias		+	arancel_facu_institucionales
v_total_titulacion	=	titulacion_facu_marketing	+	titulacion_facu_diseno	+	titulacion_facu_comunicaciones 	+	titulacion_facu_ciencias	+	titulacion_facu_tecnologias		+	titulacion_facu_institucionales
v_total_total		=	total_facu_marketing		+	total_facu_diseno		+	total_facu_comunicaciones 		+	total_facu_ciencias			+	total_facu_tecnologias			+	total_facu_institucionales

' calculo de totales globales por facultades (valor presupuestado)
v_presc_total_arancel		=	presc_arancel_facu_marketing	+	presc_arancel_facu_diseno		+	presc_arancel_facu_comunicaciones 		+	presc_arancel_facu_ciencias		+	presc_arancel_facu_tecnologias		+	presc_arancel_facu_institucionales
v_presc_total_titulacion	=	presc_titulacion_facu_marketing	+	presc_titulacion_facu_diseno	+	presc_titulacion_facu_comunicaciones 	+	presc_titulacion_facu_ciencias	+	presc_titulacion_facu_tecnologias	+	presc_titulacion_facu_institucionales
v_presc_total_total		=	presc_total_facu_marketing		+	presc_total_facu_diseno			+	presc_total_facu_comunicaciones 		+	presc_total_facu_ciencias		+	presc_total_facu_tecnologias		+	presc_total_facu_institucionales


%>
    <font color="#000000" size="+1" ><strong>Total general Universidad del Pacifico Año:
    <%response.Write(v_anos)%>
    </strong></font></p>
	
<p></p>

<table width="100%" border="1">
  <tr>
    <td><font color="#0033FF" size="+1">Total general Universidad del Pacifico</font></td>
    <td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Reales</strong></div></td>
    <td></td>
    <td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Presupuestado</strong></div></td>
    <td></td>
    <td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Desviacion Pesos</strong></div></td>
    <td></td>
    <td bgcolor="#66CC99" colspan="3"><div align="center"><strong> % Desviacion </strong></div></td>
  </tr>
<tr>
    <td width="30%" ></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
    <td width="11%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
	<td width="0%"></td>
	<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
    <td width="15%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
	<td width="0%"></td>
	<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
    <td width="15%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
	<td width="0%"></td>
	<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
    <td width="15%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>	
</tr>
    <TR>
	  <TH>Total acumulado </TH>
	  <TH><%=FormatCurrency(v_total_arancel,0)%></TH>
	  <TH><%=FormatCurrency(v_total_titulacion,0)%></TH>
	  <TH><%=FormatCurrency(v_total_total,0)%></TH>
	  <td></td>
	  <TH><%=FormatCurrency(v_presc_total_arancel,0)%></TH>
	  <TH><%=FormatCurrency(v_presc_total_titulacion,0)%></TH>
	  <TH><%=FormatCurrency(v_presc_total_total,0)%></TH>
	  <%
	  	  '** desviacion total facultad en pesos
	   v_dif_total_arancel		=	v_total_arancel		-	v_presc_total_arancel
	   v_dif_total_titulacion	=	v_total_titulacion	-	v_presc_total_titulacion
	   v_dif_total_total		=	v_total_total		-	v_presc_total_total
	   
	   '** desviacion total facultad en porcentaje
	   v_porc_total_arancel		=	FormatPercent(v_total_arancel	/	ReemplazaCero(v_presc_total_arancel),2)
	   v_porc_total_titulacion	=	FormatPercent(v_total_titulacion/	ReemplazaCero(v_presc_total_titulacion),2)
	   v_porc_total_total		=	FormatPercent(v_total_total		/	ReemplazaCero(v_presc_total_total),2)
	  %>
	  <td></td>
	  <TH><%=FormatCurrency(v_dif_total_arancel,0)%></TH>
	  <TH><%=FormatCurrency(v_dif_total_titulacion,0)%></TH>
	  <TH><%=FormatCurrency(v_dif_total_total,0)%></TH>
	  <td></td>
	  <TH><%=v_porc_total_arancel%></TH>
	  <TH><%=v_porc_total_titulacion%></TH>
	  <TH><%=v_porc_total_total%></TH>

  </TR>

</table>
<p></p>
<p></p>
</body>
</html>