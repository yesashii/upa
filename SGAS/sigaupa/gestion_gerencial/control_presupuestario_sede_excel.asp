<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "funciones_control_presupuestario.asp" -->

<%
Server.ScriptTimeout = 150000 
Response.AddHeader "Content-Disposition", "attachment;filename=resumen_bancaj_detallado_sede.xls"
Response.ContentType = "application/vnd.ms-excel"
 
'---------------------------------------------------------------------------------------------------


'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion

v_anos  = request.querystring("busqueda[0][v_anos]")
fecha_01 = conexion.ConsultaUno("Select protic.trunc(getdate())")

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "numeros_boletas_cajeros.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
'**********************************************************************************
		set casa_central = new CFormulario
		casa_central.carga_parametros "resumen_bancaj_detallado.xml", "resumen_caja_detalle"
		casa_central.inicializar conexion 
		
		if not Esvacio(Request.QueryString) then
			sql_casa_central=ObtenerConsultaSedePareo(1,v_anos)
			casa_central.Consultar sql_casa_central
		else
			vacia = "select '' where 1=2 "

			casa_central.Consultar vacia
			casa_central.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"

		end if

%>
<html>
<head>
<title>Control presupuestario agrupado por Sede y Facultad</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="3"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif"> Control presupuestario ingresos por Sede y Facultad </font></div>
	  <div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr> 
    <td height="22" colspan="3"><strong>Control presupuestario por Sedes</strong> </td>
  </tr>
  <tr>
    <td><strong>Fecha actual: <%=fecha_01%></strong></td>
    <td> </td>
 </tr>
 
</table>

<p></p>
<font color="#0000FF" size="+1" ><strong>Las Condes</strong></font>


  <% 
  facu_ccod=0
  fila = 1
  contador_central=0 

while casa_central.Siguiente 

	 if Cint(facu_ccod)=Cint(casa_central.ObtenerValor("presc_facultad")) or Cint(facu_ccod)=0 then
		 contador_central=contador_central+1
	 else
	 	contador_central=0
			if contador_central=0 then
				  %>
					  <TR>
					  <TH >Sub Total :</TH>
					  <TH><b><%=FormatCurrency(arancel_central,0)%></b></TH>
					  <TH><b><%=FormatCurrency(titulacion_central,0)%></b></TH>
					  <TH><b><%=FormatCurrency(total_central,0)%></b></TH>
					  <td></td>
					  <TH><b><%=FormatCurrency(presc_arancel_central,0)%></b></TH>
					  <TH><b><%=FormatCurrency(presc_titulacion_central,0)%></b></TH>
					  <TH><b><%=FormatCurrency(presc_total_central,0)%></b></TH>
					  	<%
						'** subtotales por facultad en pesos $
						v_dif_facu_arancel_central		=	arancel_central		-	presc_arancel_central
						v_dif_facu_titulacion_central	=	titulacion_central	-	presc_titulacion_central
						v_dif_facu_total_central		=	total_central		-	presc_total_central
						
						'** subtotales por facultad en porcentajes %
						v_porc_facu_arancel_central		=	FormatPercent(arancel_central		/	ReemplazaCero(presc_arancel_central),2)
						v_porc_facu_titulacion_central	=	FormatPercent(titulacion_central	/	ReemplazaCero(presc_titulacion_central),2)
						v_porc_facu_total_central		=	FormatPercent(total_central			/	ReemplazaCero(presc_total_central),2)

						%>

					  <td></td>
					  <TH><b><%=FormatCurrency(v_dif_facu_arancel_central,0)%></b></TH>
					  <TH><b><%=FormatCurrency(v_dif_facu_titulacion_central,0)%></b></TH>
					  <TH><b><%=FormatCurrency(v_dif_facu_total_central,0)%></b></TH>
					  <td></td>
					  <TH><b><%=v_porc_facu_arancel_central%></b></TH>
					  <TH><b><%=v_porc_facu_titulacion_central%></b></TH>
					  <TH><b><%=v_porc_facu_total_central%></b></TH>

				 </TR>
			</table>
			<p></p>
			<p></p>
			<%
				  '***	INICIALIZA MONTOS	**********************
				  arancel_central		=	0
				  titulacion_central	=	0
				  total_central			=	0
				  presc_arancel_central		=	0
				  presc_titulacion_central	=	0
				  presc_total_central		=	0			
			end if
		facu_ccod=casa_central.ObtenerValor("presc_facultad")
		contador_central=contador_central+1
	 end if
	   facu_ccod=casa_central.ObtenerValor("presc_facultad")	 

	 if  contador_central=1 then ' dibuja el encabezado por cada facultad
	 %>
	<table width="100%" border="1">
	   <tr> 
		<td width="21%"   ><font color="#0033FF" size="+1"><strong><%=casa_central.ObtenerValor("facultad")%></strong></font></td>
		<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Reales</strong></div></td>
		<td width="1%"></td>
		<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Presupuestado</strong></div></td>
		<td width="1%"></td>
		<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Desviacion Pesos</strong></div></td>
		<td width="1%"></td>
		<td bgcolor="#66CC99" colspan="3"><div align="center"><strong> % Desviacion </strong></div></td>

	  </tr>

	  <tr> 
		<td width="21%" bgcolor="#FFFFCC"><div align="center"><strong>Carrera</strong></div></td>
		<td width="6%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
		<td width="12%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
		<td width="12%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
		<td></td>
		<td width="22%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
		<td width="12%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
		<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
		<td></td>
		<td width="22%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
		<td width="12%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
		<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
		<td></td>
		<td width="22%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
		<td width="12%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
		<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
	  </tr>
	<%end if%> 
  <tr> 
	<td><div align="left"><%=casa_central.ObtenerValor("carrera")%></div></td>
    <td><div align="center"><%=FormatCurrency(casa_central.ObtenerValor("arancel"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(casa_central.ObtenerValor("titulacion"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(casa_central.ObtenerValor("total"),0)%></div></td>
	<td></td>
	<td><div align="center"><%=FormatCurrency(casa_central.ObtenerValor("presc_aranceles"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(casa_central.ObtenerValor("presc_titulaciones"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(casa_central.ObtenerValor("presc_total"),0)%></div></td>
		<%
		v_dif_arancel_central	=	Ccur(casa_central.ObtenerValor("arancel"))		-	Ccur(casa_central.ObtenerValor("presc_aranceles"))
		v_dif_titulacion_central=	Ccur(casa_central.ObtenerValor("titulacion"))	-	Ccur(casa_central.ObtenerValor("presc_titulaciones"))
		v_dif_total_central		=	Ccur(casa_central.ObtenerValor("total"))		-	Ccur(casa_central.ObtenerValor("presc_total"))
		
		v_porc_arancel_central		=	FormatPercent(Ccur(casa_central.ObtenerValor("arancel"))	/	ReemplazaCero(Ccur(casa_central.ObtenerValor("presc_aranceles"))),2)
		v_porc_titulacion_central	=	FormatPercent(Ccur(casa_central.ObtenerValor("titulacion"))	/	ReemplazaCero(Ccur(casa_central.ObtenerValor("presc_titulaciones"))),2)
		v_porc_total_central		=	FormatPercent(Ccur(casa_central.ObtenerValor("total"))		/	ReemplazaCero(Ccur(casa_central.ObtenerValor("presc_total"))),2)

		%>
	<td></td>
	<td><div align="center"><%=FormatCurrency(v_dif_arancel_central,0)%></div></td>
	<td><div align="center"><%=FormatCurrency(v_dif_titulacion_central,0)%></div></td>
	<td><div align="center"><%=FormatCurrency(v_dif_total_central,0)%></div></td>
	<td></td>
	<td><div align="center"><%=v_porc_arancel_central%></div></td>
	<td><div align="center"><%=v_porc_titulacion_central%></div></td>
	<td><div align="center"><%=v_porc_total_central%></div></td>

  </tr>
 <% 
	 '***	TOTALIZA MONTOS	**********************
	  arancel_central		=	Ccur(casa_central.ObtenerValor("arancel"))		+	Ccur(arancel_central)
	  titulacion_central	=	Ccur(casa_central.ObtenerValor("titulacion"))	+	Ccur(titulacion_central)
	  total_central			=	Ccur(casa_central.ObtenerValor("total"))		+	Ccur(total_central)
	  presc_arancel_central		=	Ccur(casa_central.ObtenerValor("presc_aranceles"))		+	Ccur(presc_arancel_central)
	  presc_titulacion_central	=	Ccur(casa_central.ObtenerValor("presc_titulaciones"))	+	Ccur(presc_titulacion_central)
	  presc_total_central		=	Ccur(casa_central.ObtenerValor("presc_total"))			+	Ccur(presc_total_central)  

'*** Total por Sede
	  arancel_sede_central		=	arancel_sede_central	+	Ccur(casa_central.ObtenerValor("arancel"))
	  titulacion_sede_central	=	titulacion_sede_central	+	Ccur(casa_central.ObtenerValor("titulacion"))
	  total_sede_central		=	total_sede_central		+	Ccur(casa_central.ObtenerValor("total"))
	  presc_arancel_sede_central	=	presc_arancel_sede_central		+	Ccur(casa_central.ObtenerValor("presc_aranceles"))
	  presc_titulacion_sede_central	=	presc_titulacion_sede_central	+	Ccur(casa_central.ObtenerValor("presc_titulaciones"))
	  presc_total_sede_central		=	presc_total_sede_central		+	Ccur(casa_central.ObtenerValor("presc_total"))	 


  wend %>
					  <TR>
					  <TH >Sub Total :</TH>
					  <TH><b><%=FormatCurrency(arancel_central,0)%></b></TH>
					  <TH><b><%=FormatCurrency(titulacion_central,0)%></b></TH>
					  <TH><b><%=FormatCurrency(total_central,0)%></b></TH>
					  <td></td>      
					  <TH><b><%=FormatCurrency(presc_arancel_central,0)%></b></TH>
					  <TH><b><%=FormatCurrency(presc_titulacion_central,0)%></b></TH>
					  <TH><b><%=FormatCurrency(presc_total_central,0)%></b></TH>
					  <%
					'** DESVIACION SUBTOTALES POR FACULTAD EN PESOS
						v_dif_facu_arancel_central		=	arancel_central		-	presc_arancel_central
						v_dif_facu_titulacion_central	=	titulacion_central	-	presc_titulacion_central
						v_dif_facu_total_central		=	total_central		-	presc_total_central
					
					'** DESVIACION SUBTOTALES POR FACULTAD EN PORCENTAJE %
						v_porc_facu_arancel_central		=	FormatPercent(arancel_central		/	ReemplazaCero(presc_arancel_central),2)
						v_porc_facu_titulacion_central	=	FormatPercent(titulacion_central	/	ReemplazaCero(presc_titulacion_central),2)
						v_porc_facu_total_central		=	FormatPercent(total_central			/	ReemplazaCero(presc_total_central),2)

					  %>
					  <td></td>      
					  <TH><b><%=FormatCurrency(v_dif_facu_arancel_central,0)%></b></TH>
					  <TH><b><%=FormatCurrency(v_dif_facu_titulacion_central,0)%></b></TH>
					  <TH><b><%=FormatCurrency(v_dif_facu_total_central,0)%></b></TH>
					  <td></td>      
					  <TH><b><%=v_porc_facu_arancel_central%></b></TH>
					  <TH><b><%=v_porc_facu_titulacion_central%></b></TH>
					  <TH><b><%=v_porc_facu_total_central%></b></TH>


				 </TR>
  
</table>
<!-- Totalizacion para cada sede -->
<p></p>
<table width="100%" border="1">
		<tr> 
			<td width="30%" bgcolor=""  ><font color="#0033FF" size="+1"><strong></strong></font></td>
			<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Reales</strong></div></td>
			<td width="1%"></td>
			<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Presupuestado</strong></div></td>
			<td width="1%"></td>
			<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Desviacion en Pesos</strong></div></td>
			<td width="1%"></td>
			<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>% Desviacion</strong></div></td>

		</tr>
		<tr>
			<td width="30%" ><strong>Total general Las Condes </strong></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
			<td></td>
			<td width="19%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
			<td></td>
			<td width="19%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
			<td></td>
			<td width="19%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
		</tr>
    <TR>
	  <TH bgcolor="#CCFFFF"></TH>
	  <TH><%=FormatCurrency(arancel_sede_central,0)%></TH>
	  <TH><%=FormatCurrency(titulacion_sede_central,0)%></TH>
	  <TH><%=FormatCurrency(total_sede_central,0)%></TH>
	  <td></td>
	  <TH><%=FormatCurrency(presc_arancel_sede_central,0)%></TH>
	  <TH><%=FormatCurrency(presc_titulacion_sede_central,0)%></TH>
	  <TH><%=FormatCurrency(presc_total_sede_central,0)%></TH>
	  <%
	  '*** desviacion por sede
 	v_dif_arancel_sede_central		=	arancel_sede_central	-	presc_arancel_sede_central
	v_dif_titulacion_sede_central	=	titulacion_sede_central	-	presc_titulacion_sede_central
	v_dif_total_sede_central		=	total_sede_central		-	presc_total_sede_central

 	v_porc_arancel_sede_central		=	FormatPercent(arancel_sede_central		/	ReemplazaCero(presc_arancel_sede_central),2)
	v_porc_titulacion_sede_central	=	FormatPercent(titulacion_sede_central	/	ReemplazaCero(presc_titulacion_sede_central),2)
	v_porc_total_sede_central		=	FormatPercent(total_sede_central		/	ReemplazaCero(presc_total_sede_central),2)

	  %>
	  <td></td>
	  <TH><%=FormatCurrency(v_dif_arancel_sede_central,0)%></TH>
	  <TH><%=FormatCurrency(v_dif_titulacion_sede_central,0)%></TH>
	  <TH><%=FormatCurrency(v_dif_total_sede_central,0)%></TH>
	  <td></td>
	  <TH><%=v_porc_arancel_sede_central%></TH>
	  <TH><%=v_porc_titulacion_sede_central%></TH>
	  <TH><%=v_porc_total_sede_central%></TH>
  </TR>

</table>
<% 
set providencia = new CFormulario
providencia.carga_parametros "resumen_bancaj_detallado.xml", "resumen_caja_detalle"
providencia.inicializar conexion 

if not Esvacio(Request.QueryString) then
	sql_providencia=ObtenerConsultaSedePareo(2,v_anos)
	providencia.Consultar sql_providencia
else
	vacia = "select '' where 1=2 "
	providencia.Consultar vacia
	providencia.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"
end if

%>
<p>&nbsp;</p>
<p></p>
<p></p> 
<font color="#0000FF" size="+1" ><strong>Sede Lyon</strong></font>

<%  
  facu_ccod=0
  fila = 1
  contador_providencia=0 
while providencia.Siguiente 

	 if Cint(facu_ccod)=Cint(providencia.ObtenerValor("presc_facultad")) or Cint(facu_ccod)=0 then
		 contador_providencia=contador_providencia+1
	 else
	 	contador_providencia=0
			if contador_providencia=0 then
				  %>
					  <TR>
					  <TH >Sub Total :</TH>
					  <TH><b><%=FormatCurrency(arancel_providencia,0)%></b></TH>
					  <TH><b><%=FormatCurrency(titulacion_providencia,0)%></b></TH>
					  <TH><b><%=FormatCurrency(total_providencia,0)%></b></TH>
					  <td></td>
					  <TH><b><%=FormatCurrency(presc_arancel_providencia,0)%></b></TH>
					  <TH><b><%=FormatCurrency(presc_titulacion_providencia,0)%></b></TH>
					  <TH><b><%=FormatCurrency(presc_total_providencia,0)%></b></TH>
					  <%
						'** DESVIACION POR FACULTAD EN PESOS $
						v_dif_facu_arancel_providencia		=	arancel_providencia		-	presc_arancel_providencia
						v_dif_facu_titulacion_providencia	=	titulacion_providencia	-	presc_titulacion_providencia
						v_dif_facu_total_providencia		=	total_providencia		-	presc_total_providencia
						
						'** DESVIACION POR FACULTAD EN PORCENTAJES %
						v_porc_facu_arancel_providencia		=	FormatPercent(arancel_providencia		/	ReemplazaCero(presc_arancel_providencia),2)
						v_porc_facu_titulacion_providencia	=	FormatPercent(titulacion_providencia	/	ReemplazaCero(presc_titulacion_providencia),2)
						v_porc_facu_total_providencia		=	FormatPercent(total_providencia			/	ReemplazaCero(presc_total_providencia),2)

					  %>

					  <td></td>
					  <TH><b><%=FormatCurrency(v_dif_facu_arancel_providencia,0)%></b></TH>
					  <TH><b><%=FormatCurrency(v_dif_facu_titulacion_providencia,0)%></b></TH>
					  <TH><b><%=FormatCurrency(v_dif_facu_total_providencia,0)%></b></TH>
					  <td></td>
					  <TH><b><%=v_porc_facu_arancel_providencia%></b></TH>
					  <TH><b><%=v_porc_facu_titulacion_providencia%></b></TH>
					  <TH><b><%=v_porc_facu_total_providencia%></b></TH>

				</table>
				<p></p>
				<p></p>
			<%
				  '***	INICIALIZA MONTOS	**********************
				  arancel_providencia		=	0
				  titulacion_providencia	=	0
				  total_providencia			=	0
				  presc_arancel_providencia		=	0
				  presc_titulacion_providencia	=	0
				  presc_total_providencia		=	0			
			end if
		facu_ccod=providencia.ObtenerValor("presc_facultad")
		contador_providencia=contador_providencia+1
	 end if
	   facu_ccod=providencia.ObtenerValor("presc_facultad")	 

	 if  contador_providencia=1 then ' dibuja el encabezado por cada facultad

		%>
		<table width="100%" border="1">  
		  <tr> 
			<td bgcolor="" ><font color="#0033FF" size="+1"><strong><%=providencia.ObtenerValor("facultad")%></strong></font></td>
			<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Reales</strong></div></td>
			<td></td>
			<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Presupuestado</strong></div></td>
			<td></td>
			<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Desviacion Pesos</strong></div></td>
			<td></td>
			<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>% Desviacion</strong></div></td>

		  </tr>
		  <tr> 
			<td width="24%" bgcolor="#FFFFCC"><div align="center"><strong>Carrera</strong></div></td>
			<td width="6%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
			<td></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
			<td></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Aranceles</strong></div></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Titulaciones</strong></div></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Totales</strong></div></td>
			<td></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Aranceles</strong></div></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Titulaciones</strong></div></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Totales</strong></div></td>
		  </tr>
		<%end if%> 
  <tr> 
	<td><div align="left"><%=providencia.ObtenerValor("carrera")%></div></td>
	<td><div align="center"><%=FormatCurrency(providencia.ObtenerValor("arancel"),0)%></div></td>
    <td><div align="center"><%=FormatCurrency(providencia.ObtenerValor("titulacion"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(providencia.ObtenerValor("total"),0)%></div></td>
	<td></td>
	<td><div align="center"><%=FormatCurrency(providencia.ObtenerValor("presc_aranceles"),0)%></div></td>
    <td><div align="center"><%=FormatCurrency(providencia.ObtenerValor("presc_titulaciones"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(providencia.ObtenerValor("presc_total"),0)%></div></td>
	
	<%

	v_dif_arancel_providencia	=	Ccur(providencia.ObtenerValor("arancel"))	-	Ccur(providencia.ObtenerValor("presc_aranceles"))
	v_dif_titulacion_providencia=	Ccur(providencia.ObtenerValor("titulacion"))-	Ccur(providencia.ObtenerValor("presc_titulaciones"))
	v_dif_total_providencia		=	Ccur(providencia.ObtenerValor("total"))		-	Ccur(providencia.ObtenerValor("presc_total"))
	
	v_porc_arancel_providencia		=	FormatPercent(Ccur(providencia.ObtenerValor("arancel"))		/	ReemplazaCero(Ccur(providencia.ObtenerValor("presc_aranceles"))),2)
	v_porc_titulacion_providencia	=	FormatPercent(Ccur(providencia.ObtenerValor("titulacion"))	/	ReemplazaCero(Ccur(providencia.ObtenerValor("presc_titulaciones"))),2)
	v_porc_total_providencia		=	FormatPercent(Ccur(providencia.ObtenerValor("total"))		/	ReemplazaCero(Ccur(providencia.ObtenerValor("presc_total"))),2)

	%>
	<td></td>
	<td><div align="center"><%=FormatCurrency(v_dif_arancel_providencia,0)%></div></td>
    <td><div align="center"><%=FormatCurrency(v_dif_titulacion_providencia,0)%></div></td>
	<td><div align="center"><%=FormatCurrency(v_dif_total_providencia,0)%></div></td>
	<td></td>
	<td><div align="center"><%=v_porc_arancel_providencia%></div></td>
    <td><div align="center"><%=v_porc_titulacion_providencia%></div></td>
	<td><div align="center"><%=v_porc_total_providencia%></div></td>
  </tr>
  <% 
   '***	SUBTOTALES MONTOS POR FACULTAD	**********************
  arancel_providencia		=	Ccur(providencia.ObtenerValor("arancel"))		+	Ccur(arancel_providencia)
  titulacion_providencia	=	Ccur(providencia.ObtenerValor("titulacion"))	+	Ccur(titulacion_providencia)
  total_providencia			=	Ccur(providencia.ObtenerValor("total"))			+	Ccur(total_providencia)
  presc_arancel_providencia		=	Ccur(providencia.ObtenerValor("presc_aranceles"))		+	Ccur(presc_arancel_providencia)
  presc_titulacion_providencia	=	Ccur(providencia.ObtenerValor("presc_titulaciones"))	+	Ccur(presc_titulacion_providencia)
  presc_total_providencia		=	Ccur(providencia.ObtenerValor("presc_total"))			+	Ccur(presc_total_providencia)
'____________________________________________________________________________________________________________________________
 
 '*** TOTAL MONTOS POR SEDE
	  arancel_sede_providencia		=	arancel_sede_providencia	+	Ccur(providencia.ObtenerValor("arancel"))
	  titulacion_sede_providencia	=	titulacion_sede_providencia	+	Ccur(providencia.ObtenerValor("titulacion"))
	  total_sede_providencia		=	total_sede_providencia		+	Ccur(providencia.ObtenerValor("total"))	
	  presc_arancel_sede_providencia	=	presc_arancel_sede_providencia		+	Ccur(providencia.ObtenerValor("presc_aranceles"))	
	  presc_titulacion_sede_providencia	=	presc_titulacion_sede_providencia	+	Ccur(providencia.ObtenerValor("presc_titulaciones"))
	  presc_total_sede_providencia		=	presc_total_sede_providencia		+	Ccur(providencia.ObtenerValor("presc_total"))	


  wend %>
  
    <TR>
	  <TH>Sub Total :</TH>
	  <TH><b><%=FormatCurrency(arancel_providencia,0)%></b></TH>
	  <TH><b><%=FormatCurrency(titulacion_providencia,0)%></b></TH>
	  <TH><b><%=FormatCurrency(total_providencia,0)%></b></TH>
	  <td></td>
	  <TH><b><%=FormatCurrency(presc_arancel_providencia,0)%></b></TH>
	  <TH><b><%=FormatCurrency(presc_titulacion_providencia,0)%></b></TH>
	  <TH><b><%=FormatCurrency(presc_total_providencia,0)%></b></TH>
	  <%
	  '** DESVIACION POR SUBTOTALES POR FACULTAD $
	  	v_dif_facu_arancel_providencia		=	arancel_providencia		-	presc_arancel_providencia
		v_dif_facu_titulacion_providencia	=	titulacion_providencia	-	presc_titulacion_providencia
		v_dif_facu_total_providencia		=	total_providencia		-	presc_total_providencia
	  
	  '** DESVIACION POR SUBTOTALES POR FACULTAD %
	  	v_porc_facu_arancel_providencia		=	FormatPercent(arancel_providencia		/	ReemplazaCero(presc_arancel_providencia),2)
		v_porc_facu_titulacion_providencia	=	FormatPercent(titulacion_providencia	/	ReemplazaCero(presc_titulacion_providencia),2)
		v_porc_facu_total_providencia		=	FormatPercent(total_providencia			/	ReemplazaCero(presc_total_providencia),2)
	
	  %>
	  <td></td>
	  <TH><b><%=FormatCurrency(v_dif_facu_arancel_providencia,0)%></b></TH>
	  <TH><b><%=FormatCurrency(v_dif_facu_titulacion_providencia,0)%></b></TH>
	  <TH><b><%=FormatCurrency(v_dif_facu_total_providencia,0)%></b></TH>
	  <td></td>
	  <TH><b><%=v_porc_facu_arancel_providencia%></b></TH>
	  <TH><b><%=v_porc_facu_titulacion_providencia%></b></TH>
	  <TH><b><%=v_porc_facu_total_providencia%></b></TH>
  </TR>

</table>

<!-- Totalizacion para cada sede -->
<p></p>
<table width="100%" border="1">
		<tr> 
			<td width="30%" bgcolor=""  ><font color="#0033FF" size="+1"><strong></strong></font></td>
			<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Reales</strong></div></td>
			<td width="0%"></td>
			<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Presupuestado</strong></div></td>
			<td width="0%"></td>
			<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Desviacion Pesos</strong></div></td>
			<td width="0%"></td>
			<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>% Desviacion</strong></div></td>
		</tr>
		<tr>
			<td width="30%" ><strong>Total general Lyon </strong></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
			<td></td>
			<td width="20%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
			<td></td>
			<td width="20%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
			<td></td>
			<td width="20%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
		</tr>
    <TR>
	  <TH bgcolor="#CCFFFF"></TH>
	  <TH><%=FormatCurrency(arancel_sede_providencia,0)%></TH>
	  <TH><%=FormatCurrency(titulacion_sede_providencia,0)%></TH>
	  <TH><%=FormatCurrency(total_sede_providencia,0)%></TH>
	  <td></td>
	  <TH><%=FormatCurrency(presc_arancel_sede_providencia,0)%></TH>
	  <TH><%=FormatCurrency(presc_titulacion_sede_providencia,0)%></TH>
	  <TH><%=FormatCurrency(presc_total_sede_providencia,0)%></TH>
	  <%
		'** DESVIACION POR SEDE EN PESOS
		v_dif_arancel_sede_providencia		=	arancel_sede_providencia	-	presc_arancel_sede_providencia
		v_dif_titulacion_sede_providencia	=	titulacion_sede_providencia	-	presc_titulacion_sede_providencia
		v_dif_total_sede_providencia		=	total_sede_providencia		-	presc_total_sede_providencia
		
		'** DESVIACION POR SEDE EN PORCENTAJE %
		v_porc_arancel_sede_providencia		=	FormatPercent(arancel_sede_providencia		/	ReemplazaCero(presc_arancel_sede_providencia),2)
		v_porc_titulacion_sede_providencia	=	FormatPercent(titulacion_sede_providencia	/	ReemplazaCero(presc_titulacion_sede_providencia),2)
		v_porc_total_sede_providencia		=	FormatPercent(total_sede_providencia		/	ReemplazaCero(presc_total_sede_providencia),2)
	  %>
	  <td></td>
	  <TH><%=FormatCurrency(v_dif_arancel_sede_providencia,0)%></TH>
	  <TH><%=FormatCurrency(v_dif_titulacion_sede_providencia,0)%></TH>
	  <TH><%=FormatCurrency(v_dif_total_sede_providencia,0)%></TH>
	  <td></td>
	  <TH><%=v_porc_arancel_sede_providencia%></TH>
	  <TH><%=v_porc_titulacion_sede_providencia%></TH>
	  <TH><%=v_porc_total_sede_providencia%></TH>

  </TR>

</table>

<% 
set melipilla = new CFormulario
melipilla.carga_parametros "resumen_bancaj_detallado.xml", "resumen_caja_detalle"
melipilla.inicializar conexion 

if not Esvacio(Request.QueryString) then
	sql_melipilla=ObtenerConsultaSedePareo(4,v_anos)
	melipilla.Consultar sql_melipilla
else
	vacia = "select '' where 1=2 "
	melipilla.Consultar vacia
	melipilla.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"
end if

%>

<p></p>
<p></p> 
<font color="#0000FF" size="+1"><strong>Sede Melipilla</strong></font>


  <%  
      facu_ccod=0
	  fila = 1
	  contador_melipilla=0 
	while melipilla.Siguiente 

	 if Cint(facu_ccod)=Cint(melipilla.ObtenerValor("presc_facultad")) or Cint(facu_ccod)=0 then
		 contador_melipilla=contador_melipilla+1
	 else
	 	contador_melipilla=0
			if contador_melipilla=0 then
				  %>
					  <TR>
					  <TH >Sub Total :</TH>
					  <TH><b><%=FormatCurrency(arancel_melipilla,0)%></b></TH>
					  <TH><b><%=FormatCurrency(titulacion_melipilla,0)%></b></TH>
					  <TH><b><%=FormatCurrency(total_melipilla,0)%></b></TH>
					  <td></td>
					  <TH><b><%=FormatCurrency(presc_arancel_melipilla,0)%></b></TH>
					  <TH><b><%=FormatCurrency(presc_titulacion_melipilla,0)%></b></TH>
					  <TH><b><%=FormatCurrency(presc_total_melipilla,0)%></b></TH>
					  	<%
						'** DESVIACION POR FACULTAD EN PESOS $
						v_dif_facu_arancel_melipilla	=	arancel_melipilla		-	presc_arancel_melipilla
						v_dif_facu_titulacion_melipilla	=	titulacion_melipilla	-	presc_titulacion_melipilla
						v_dif_facu_total_melipilla		=	total_melipilla			-	presc_total_melipilla
						
						'** DESVIACION POR FACULTAD EN PORCENTAJES %
						v_porc_facu_arancel_melipilla	=	FormatPercent(arancel_melipilla		/	ReemplazaCero(presc_arancel_melipilla),2)
						v_porc_facu_titulacion_melipilla=	FormatPercent(titulacion_melipilla	/	ReemplazaCero(presc_titulacion_melipilla),2)
						v_porc_facu_total_melipilla		=	FormatPercent(total_melipilla		/	ReemplazaCero(presc_total_melipilla),2)

						%>
					  <td></td>
					  <TH><b><%=FormatCurrency(v_dif_facu_arancel_melipilla,0)%></b></TH>
					  <TH><b><%=FormatCurrency(v_dif_facu_titulacion_melipilla,0)%></b></TH>
					  <TH><b><%=FormatCurrency(v_dif_facu_total_melipilla,0)%></b></TH>
					  <td></td>
					  <TH><b><%=v_porc_facu_arancel_melipilla%></b></TH>
					  <TH><b><%=v_porc_facu_titulacion_melipilla%></b></TH>
					  <TH><b><%=v_porc_facu_total_melipilla%></b></TH>

				 </TR>
				 </table>
				<p></p>
				<p></p>
			<%
				  '***	INICIALIZA MONTOS	**********************
				  arancel_melipilla		=	0
				  titulacion_melipilla	=	0
				  total_melipilla			=	0
				  presc_arancel_melipilla	=	0
				  presc_titulacion_melipilla	=	0
				  presc_total_melipilla		=	0			
			end if
		facu_ccod=melipilla.ObtenerValor("presc_facultad")
		contador_melipilla=contador_melipilla+1
	 end if
	   facu_ccod=melipilla.ObtenerValor("presc_facultad")	 

	 if  contador_melipilla=1 then ' dibuja el encabezado por cada facultad
	 %>		
	 <table width="100%" border="1">
	   	<tr> 
			<td bgcolor=""><font color="#0033FF" size="+1"><strong><%=melipilla.ObtenerValor("facultad")%></strong></font></td>
			<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Reales</strong></div></td>
			<td></td>
			<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Presupuestado</strong></div></td>
			<td></td>
			<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Desviacion Pesos</strong></div></td>
			<td></td>
			<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>% Desviacion</strong></div></td>
		</tr>
		<tr> 
			<td width="24%" bgcolor="#FFFFCC"><div align="center"><strong>Carrera</strong></div></td>
			<td width="6%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
			<td></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
			<td></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
			<td></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
		</tr>
	<%end if%> 
  <tr> 
	<td><div align="left"><%=melipilla.ObtenerValor("carrera")%></div></td>
	<td><div align="center"><%=FormatCurrency(melipilla.ObtenerValor("arancel"),0)%></div></td>
    <td><div align="center"><%=FormatCurrency(melipilla.ObtenerValor("titulacion"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(melipilla.ObtenerValor("total"),0)%></div></td>
	<td></td>
	<td><div align="center"><%=FormatCurrency(melipilla.ObtenerValor("presc_aranceles"),0)%></div></td>
    <td><div align="center"><%=FormatCurrency(melipilla.ObtenerValor("presc_titulaciones"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(melipilla.ObtenerValor("presc_total"),0)%></div></td>
	<%
	'** DESVIACION POR CARRERAS
	v_dif_arancel_melipilla		=	Ccur(melipilla.ObtenerValor("arancel"))		-	Ccur(melipilla.ObtenerValor("presc_aranceles"))
	v_dif_titulacion_melipilla	=	Ccur(melipilla.ObtenerValor("titulacion"))	-	Ccur(melipilla.ObtenerValor("presc_titulaciones"))
	v_dif_total_melipilla		=	Ccur(melipilla.ObtenerValor("total"))		-	Ccur(melipilla.ObtenerValor("presc_total"))

	v_porc_arancel_melipilla		=	FormatPercent(Ccur(melipilla.ObtenerValor("arancel"))	/	ReemplazaCero(Ccur(melipilla.ObtenerValor("presc_aranceles"))),2)
	v_porc_titulacion_melipilla		=	FormatPercent(Ccur(melipilla.ObtenerValor("titulacion"))/	ReemplazaCero(Ccur(melipilla.ObtenerValor("presc_titulaciones"))),2)
	v_porc_total_melipilla			=	FormatPercent(Ccur(melipilla.ObtenerValor("total"))		/	ReemplazaCero(Ccur(melipilla.ObtenerValor("presc_total"))),2)

	
	%>
	<td></td>
	<td><div align="center"><%=FormatCurrency(v_dif_arancel_melipilla,0)%></div></td>
    <td><div align="center"><%=FormatCurrency(v_dif_titulacion_melipilla,0)%></div></td>
	<td><div align="center"><%=FormatCurrency(v_dif_total_melipilla,0)%></div></td>
	<td></td>
	<td><div align="center"><%=v_porc_arancel_melipilla%></div></td>
    <td><div align="center"><%=v_porc_titulacion_melipilla%></div></td>
	<td><div align="center"><%=v_porc_total_melipilla%></div></td>
  </tr>
  <% 
  '***	TOTALIZA MONTOS	**********************
  arancel_melipilla		=	Ccur(melipilla.ObtenerValor("arancel"))		+	Ccur(arancel_melipilla)
  titulacion_melipilla	=	Ccur(melipilla.ObtenerValor("titulacion"))	+	Ccur(titulacion_melipilla)
  total_melipilla		=	Ccur(melipilla.ObtenerValor("total"))		+	Ccur(total_melipilla)
  presc_arancel_melipilla		=	Ccur(melipilla.ObtenerValor("presc_aranceles"))	+	Ccur(presc_arancel_melipilla)
  presc_titulacion_melipilla	=	Ccur(melipilla.ObtenerValor("presc_titulaciones"))+	Ccur(presc_titulacion_melipilla)
  presc_total_melipilla			=	Ccur(melipilla.ObtenerValor("presc_total"))		+	Ccur(presc_total_melipilla)


 '*** Total por Sede
	  arancel_sede_melipilla		=	arancel_sede_melipilla	+	Ccur(melipilla.ObtenerValor("arancel"))
	  titulacion_sede_melipilla		=	titulacion_sede_melipilla	+	Ccur(melipilla.ObtenerValor("titulacion"))
	  total_sede_melipilla			=	total_sede_melipilla		+	Ccur(melipilla.ObtenerValor("total"))	
	  presc_arancel_sede_melipilla		=	presc_arancel_sede_melipilla	+	Ccur(melipilla.ObtenerValor("presc_aranceles"))
	  presc_titulacion_sede_melipilla	=	presc_titulacion_sede_melipilla	+	Ccur(melipilla.ObtenerValor("presc_titulaciones"))
	  presc_total_sede_melipilla		=	presc_total_sede_melipilla		+	Ccur(melipilla.ObtenerValor("presc_total"))



  wend %>
    <TR>
	  <TH>Sub Total :</TH>
	  <TH><b><%=FormatCurrency(arancel_melipilla,0)%></b></TH>
	  <TH><b><%=FormatCurrency(titulacion_melipilla,0)%></b></TH>
	  <TH><b><%=FormatCurrency(total_melipilla,0)%></b></TH>
	  <td></td>
	  <TH><b><%=FormatCurrency(presc_arancel_melipilla,0)%></b></TH>
	  <TH><b><%=FormatCurrency(presc_titulacion_melipilla,0)%></b></TH>
	  <TH><b><%=FormatCurrency(presc_total_melipilla,0)%></b></TH>
	  <%
	  '** DESVIACION SUBTOTALES POR FACULTAD EN PESOS $
	  	v_dif_facu_arancel_melipilla		=	arancel_melipilla		-	presc_arancel_melipilla
		v_dif_facu_titulacion_melipilla		=	titulacion_melipilla	-	presc_titulacion_melipilla
		v_dif_facu_total_melipilla			=	total_melipilla			-	presc_total_melipilla
	 
	 '** DESVIACION SUBTOTALES POR FACULTAD EN PORCENTAJES %
  	  	v_porc_facu_arancel_melipilla		=	FormatPercent(arancel_melipilla		/	ReemplazaCero(presc_arancel_melipilla),2)
		v_porc_facu_titulacion_melipilla	=	FormatPercent(titulacion_melipilla	/	ReemplazaCero(presc_titulacion_melipilla),2)
		v_porc_facu_total_melipilla			=	FormatPercent(total_melipilla		/	ReemplazaCero(presc_total_melipilla),2)

	  %>
	  <td></td>
	  <TH><b><%=FormatCurrency(v_dif_facu_arancel_melipilla,0)%></b></TH>
	  <TH><b><%=FormatCurrency(v_dif_facu_titulacion_melipilla,0)%></b></TH>
	  <TH><b><%=FormatCurrency(v_dif_facu_total_melipilla,0)%></b></TH>
	  <td></td>
	  <TH><b><%=v_porc_facu_arancel_melipilla%></b></TH>
	  <TH><b><%=v_porc_facu_titulacion_melipilla%></b></TH>
	  <TH><b><%=v_porc_facu_total_melipilla%></b></TH>
  </TR>

</table>
<!-- Totalizacion para cada sede -->
<p></p>
<table width="100%" border="1">
		<tr> 
			<td width="23%" bgcolor=""  ><font color="#0033FF" size="+1"><strong></strong></font></td>
			<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Reales</strong></div></td>
			<td width="1%"></td>
			<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Presupuestado</strong></div></td>
			<td width="1%"></td>
			<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Desviacion Pesos</strong></div></td>
			<td width="1%"></td>
			<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>% Desviacion </strong></div></td>
		</tr>
		<tr>
			<td width="23%" ><strong>Total general Melipilla</strong></td>
			<td width="16%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
			<td width="9%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
			<td></td>
			<td width="21%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
			<td></td>
			<td width="21%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
			<td></td>
			<td width="21%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
		</tr>
    <TR>
	  <TH bgcolor="#CCFFFF"></TH>
	  <TH><%=FormatCurrency(arancel_sede_melipilla,0)%></TH>
	  <TH><%=FormatCurrency(titulacion_sede_melipilla,0)%></TH>
	  <TH><%=FormatCurrency(total_sede_melipilla,0)%></TH>
	  <td></td>
	  <TH><%=FormatCurrency(presc_arancel_sede_melipilla,0)%></TH>
	  <TH><%=FormatCurrency(presc_titulacion_sede_melipilla,0)%></TH>
	  <TH><%=FormatCurrency(presc_total_sede_melipilla,0)%></TH>
	  <%
	  '** DESVIACION POR SEDE EN PESOS $
	   	v_dif_arancel_sede_melipilla	=	arancel_sede_melipilla		-	presc_arancel_sede_melipilla
		v_dif_titulacion_sede_melipilla	=	titulacion_sede_melipilla	-	presc_titulacion_sede_melipilla
		v_dif_total_sede_melipilla		=	total_sede_melipilla		-	presc_total_sede_melipilla


	  '** DESVIACION POR SEDE EN PORCNETAJES %
	   	v_porc_arancel_sede_melipilla	=	FormatPercent(arancel_sede_melipilla	/	ReemplazaCero(presc_arancel_sede_melipilla),2)
		v_porc_titulacion_sede_melipilla=	FormatPercent(titulacion_sede_melipilla	/	ReemplazaCero(presc_titulacion_sede_melipilla),2)
		v_porc_total_sede_melipilla		=	FormatPercent(total_sede_melipilla		/	ReemplazaCero(presc_total_sede_melipilla),2)
	  %>
	  <td></td>
	  <TH><%=FormatCurrency(v_dif_arancel_sede_melipilla,0)%></TH>
	  <TH><%=FormatCurrency(v_dif_titulacion_sede_melipilla,0)%></TH>
	  <TH><%=FormatCurrency(v_dif_total_sede_melipilla,0)%></TH>
	  <td></td>
	  <TH><%=v_porc_arancel_sede_melipilla%></TH>
	  <TH><%=v_porc_titulacion_sede_melipilla%></TH>
	  <TH><%=v_porc_total_sede_melipilla%></TH>


  </TR>

</table>


<% 

set bustamante = new CFormulario
bustamante.carga_parametros "resumen_bancaj_detallado.xml", "resumen_caja_detalle"
bustamante.inicializar conexion 

if not Esvacio(Request.QueryString) then
	sql_bustamante=ObtenerConsultaSedePareo(8,v_anos)
	bustamante.Consultar sql_bustamante
else
	vacia = "select '' where 1=2 "
	bustamante.Consultar vacia
	bustamante.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"
end if

%>

<p></p>
<p></p> 
<font color="#0000FF" size="+1"><strong>Sede Bustamante</strong></font>


  <%  
      facu_ccod=0
	  fila = 1
	  contador_bustamante=0 
	while bustamante.Siguiente 

	 if Cint(facu_ccod)=Cint(bustamante.ObtenerValor("presc_facultad")) or Cint(facu_ccod)=0 then
		 contador_bustamante=contador_bustamante+1
	 else
	 	contador_bustamante=0
			if contador_bustamante=0 then
				  %>
					  <TR>
					  <TH >Sub Total :</TH>
					  <TH><b><%=FormatCurrency(arancel_bustamante,0)%></b></TH>
					  <TH><b><%=FormatCurrency(titulacion_bustamante,0)%></b></TH>
					  <TH><b><%=FormatCurrency(total_bustamante,0)%></b></TH>
					  <td></td>
					  <TH><b><%=FormatCurrency(presc_arancel_bustamante,0)%></b></TH>
					  <TH><b><%=FormatCurrency(presc_titulacion_bustamante,0)%></b></TH>
					  <TH><b><%=FormatCurrency(presc_total_bustamante,0)%></b></TH>
					  	<%
						'** DESVIACION POR FACULTAD EN PESOS $
						v_dif_facu_arancel_bustamante	=	arancel_bustamante		-	presc_arancel_bustamante
						v_dif_facu_titulacion_bustamante	=	titulacion_bustamante	-	presc_titulacion_bustamante
						v_dif_facu_total_bustamante		=	total_bustamante			-	presc_total_bustamante
						
						'** DESVIACION POR FACULTAD EN PORCENTAJES %
						v_porc_facu_arancel_bustamante	=	FormatPercent(arancel_bustamante		/	ReemplazaCero(presc_arancel_bustamante),2)
						v_porc_facu_titulacion_bustamante=	FormatPercent(titulacion_bustamante	/	ReemplazaCero(presc_titulacion_bustamante),2)
						v_porc_facu_total_bustamante		=	FormatPercent(total_bustamante		/	ReemplazaCero(presc_total_bustamante),2)

						%>
					  <td></td>
					  <TH><b><%=FormatCurrency(v_dif_facu_arancel_bustamante,0)%></b></TH>
					  <TH><b><%=FormatCurrency(v_dif_facu_titulacion_bustamante,0)%></b></TH>
					  <TH><b><%=FormatCurrency(v_dif_facu_total_bustamante,0)%></b></TH>
					  <td></td>
					  <TH><b><%=v_porc_facu_arancel_bustamante%></b></TH>
					  <TH><b><%=v_porc_facu_titulacion_bustamante%></b></TH>
					  <TH><b><%=v_porc_facu_total_bustamante%></b></TH>

				 </TR>
				 </table>
				<p></p>
				<p></p>
			<%
				  '***	INICIALIZA MONTOS	**********************
				  arancel_bustamante		=	0
				  titulacion_bustamante	=	0
				  total_bustamante			=	0
				  presc_arancel_bustamante	=	0
				  presc_titulacion_bustamante	=	0
				  presc_total_bustamante		=	0			
			end if
		facu_ccod=bustamante.ObtenerValor("presc_facultad")
		contador_bustamante=contador_bustamante+1
	 end if
	   facu_ccod=bustamante.ObtenerValor("presc_facultad")	 

	 if  contador_bustamante=1 then ' dibuja el encabezado por cada facultad
	 %>		
	 <table width="100%" border="1">
	   	<tr> 
			<td bgcolor=""><font color="#0033FF" size="+1"><strong><%=bustamante.ObtenerValor("facultad")%></strong></font></td>
			<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Reales</strong></div></td>
			<td></td>
			<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Presupuestado</strong></div></td>
			<td></td>
			<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Desviacion Pesos</strong></div></td>
			<td></td>
			<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>% Desviacion</strong></div></td>
		</tr>
		<tr> 
			<td width="24%" bgcolor="#FFFFCC"><div align="center"><strong>Carrera</strong></div></td>
			<td width="6%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
			<td></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
			<td></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
			<td></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
			<td width="14%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
		</tr>
	<%end if%> 
  <tr> 
	<td><div align="left"><%=bustamante.ObtenerValor("carrera")%></div></td>
	<td><div align="center"><%=FormatCurrency(bustamante.ObtenerValor("arancel"),0)%></div></td>
    <td><div align="center"><%=FormatCurrency(bustamante.ObtenerValor("titulacion"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(bustamante.ObtenerValor("total"),0)%></div></td>
	<td></td>
	<td><div align="center"><%=FormatCurrency(bustamante.ObtenerValor("presc_aranceles"),0)%></div></td>
    <td><div align="center"><%=FormatCurrency(bustamante.ObtenerValor("presc_titulaciones"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(bustamante.ObtenerValor("presc_total"),0)%></div></td>
	<%
	'** DESVIACION POR CARRERAS
	v_dif_arancel_bustamante	=	Ccur(bustamante.ObtenerValor("arancel"))	-	Ccur(bustamante.ObtenerValor("presc_aranceles"))
	v_dif_titulacion_bustamante	=	Ccur(bustamante.ObtenerValor("titulacion"))	-	Ccur(bustamante.ObtenerValor("presc_titulaciones"))
	v_dif_total_bustamante		=	Ccur(bustamante.ObtenerValor("total"))		-	Ccur(bustamante.ObtenerValor("presc_total"))

	v_porc_arancel_bustamante		=	FormatPercent(Ccur(bustamante.ObtenerValor("arancel"))		/	ReemplazaCero(Ccur(bustamante.ObtenerValor("presc_aranceles"))),2)
	v_porc_titulacion_bustamante	=	FormatPercent(Ccur(bustamante.ObtenerValor("titulacion"))	/	ReemplazaCero(Ccur(bustamante.ObtenerValor("presc_titulaciones"))),2)
	v_porc_total_bustamante			=	FormatPercent(Ccur(bustamante.ObtenerValor("total"))		/	ReemplazaCero(Ccur(bustamante.ObtenerValor("presc_total"))),2)

	
	%>
	<td></td>
	<td><div align="center"><%=FormatCurrency(v_dif_arancel_bustamante,0)%></div></td>
    <td><div align="center"><%=FormatCurrency(v_dif_titulacion_bustamante,0)%></div></td>
	<td><div align="center"><%=FormatCurrency(v_dif_total_bustamante,0)%></div></td>
	<td></td>
	<td><div align="center"><%=v_porc_arancel_bustamante%></div></td>
    <td><div align="center"><%=v_porc_titulacion_bustamante%></div></td>
	<td><div align="center"><%=v_porc_total_bustamante%></div></td>
  </tr>
  <% 
  '***	TOTALIZA MONTOS	**********************
  arancel_bustamante	=	Ccur(bustamante.ObtenerValor("arancel"))	+	Ccur(arancel_bustamante)
  titulacion_bustamante	=	Ccur(bustamante.ObtenerValor("titulacion"))	+	Ccur(titulacion_bustamante)
  total_bustamante		=	Ccur(bustamante.ObtenerValor("total"))		+	Ccur(total_bustamante)
  presc_arancel_bustamante		=	Ccur(bustamante.ObtenerValor("presc_aranceles"))	+	Ccur(presc_arancel_bustamante)
  presc_titulacion_bustamante	=	Ccur(bustamante.ObtenerValor("presc_titulaciones"))	+	Ccur(presc_titulacion_bustamante)
  presc_total_bustamante		=	Ccur(bustamante.ObtenerValor("presc_total"))		+	Ccur(presc_total_bustamante)


 '*** Total por Sede
	  arancel_sede_bustamante		=	arancel_sede_bustamante		+	Ccur(bustamante.ObtenerValor("arancel"))
	  titulacion_sede_bustamante	=	titulacion_sede_bustamante	+	Ccur(bustamante.ObtenerValor("titulacion"))
	  total_sede_bustamante			=	total_sede_bustamante		+	Ccur(bustamante.ObtenerValor("total"))	
	  presc_arancel_sede_bustamante		=	presc_arancel_sede_bustamante		+	Ccur(bustamante.ObtenerValor("presc_aranceles"))
	  presc_titulacion_sede_bustamante	=	presc_titulacion_sede_bustamante	+	Ccur(bustamante.ObtenerValor("presc_titulaciones"))
	  presc_total_sede_bustamante		=	presc_total_sede_bustamante			+	Ccur(bustamante.ObtenerValor("presc_total"))



  wend %>
    <TR>
	  <TH>Sub Total :</TH>
	  <TH><b><%=FormatCurrency(arancel_bustamante,0)%></b></TH>
	  <TH><b><%=FormatCurrency(titulacion_bustamante,0)%></b></TH>
	  <TH><b><%=FormatCurrency(total_bustamante,0)%></b></TH>
	  <td></td>
	  <TH><b><%=FormatCurrency(presc_arancel_bustamante,0)%></b></TH>
	  <TH><b><%=FormatCurrency(presc_titulacion_bustamante,0)%></b></TH>
	  <TH><b><%=FormatCurrency(presc_total_bustamante,0)%></b></TH>
	  <%
	  '** DESVIACION SUBTOTALES POR FACULTAD EN PESOS $
	  	v_dif_facu_arancel_bustamante		=	arancel_bustamante		-	presc_arancel_bustamante
		v_dif_facu_titulacion_bustamante	=	titulacion_bustamante	-	presc_titulacion_bustamante
		v_dif_facu_total_bustamante			=	total_bustamante		-	presc_total_bustamante
	 
	 '** DESVIACION SUBTOTALES POR FACULTAD EN PORCENTAJES %
  	  	v_porc_facu_arancel_bustamante		=	FormatPercent(arancel_bustamante	/	ReemplazaCero(presc_arancel_bustamante),2)
		v_porc_facu_titulacion_bustamante	=	FormatPercent(titulacion_bustamante	/	ReemplazaCero(presc_titulacion_bustamante),2)
		v_porc_facu_total_bustamante		=	FormatPercent(total_bustamante		/	ReemplazaCero(presc_total_bustamante),2)

	  %>
	  <td></td>
	  <TH><b><%=FormatCurrency(v_dif_facu_arancel_bustamante,0)%></b></TH>
	  <TH><b><%=FormatCurrency(v_dif_facu_titulacion_bustamante,0)%></b></TH>
	  <TH><b><%=FormatCurrency(v_dif_facu_total_bustamante,0)%></b></TH>
	  <td></td>
	  <TH><b><%=v_porc_facu_arancel_bustamante%></b></TH>
	  <TH><b><%=v_porc_facu_titulacion_bustamante%></b></TH>
	  <TH><b><%=v_porc_facu_total_bustamante%></b></TH>
  </TR>

</table>
<!-- Totalizacion para cada sede -->
<p></p>
<table width="100%" border="1">
		<tr> 
			<td width="23%" bgcolor=""  ><font color="#0033FF" size="+1"><strong></strong></font></td>
			<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Reales</strong></div></td>
			<td width="1%"></td>
			<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Ingresos Presupuestado</strong></div></td>
			<td width="1%"></td>
			<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>Desviacion Pesos</strong></div></td>
			<td width="1%"></td>
			<td bgcolor="#66CC99" colspan="3"><div align="center"><strong>% Desviacion </strong></div></td>
		</tr>
		<tr>
			<td width="23%" ><strong>Total general Bustamante</strong></td>
			<td width="16%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
			<td width="9%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
			<td></td>
			<td width="21%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
			<td></td>
			<td width="21%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
			<td></td>
			<td width="21%" bgcolor="#FFFFCC"><div align="center"><strong>Arancel</strong></div></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Titulacion</strong></div></td>
			<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Total</strong></div></td>
		</tr>
    <TR>
	  <TH bgcolor="#CCFFFF"></TH>
	  <TH><%=FormatCurrency(arancel_sede_bustamante,0)%></TH>
	  <TH><%=FormatCurrency(titulacion_sede_bustamante,0)%></TH>
	  <TH><%=FormatCurrency(total_sede_bustamante,0)%></TH>
	  <td></td>
	  <TH><%=FormatCurrency(presc_arancel_sede_bustamante,0)%></TH>
	  <TH><%=FormatCurrency(presc_titulacion_sede_bustamante,0)%></TH>
	  <TH><%=FormatCurrency(presc_total_sede_bustamante,0)%></TH>
	  <%
	  '** DESVIACION POR SEDE EN PESOS $
	   	v_dif_arancel_sede_bustamante	=	arancel_sede_bustamante		-	presc_arancel_sede_bustamante
		v_dif_titulacion_sede_bustamante	=	titulacion_sede_bustamante	-	presc_titulacion_sede_bustamante
		v_dif_total_sede_bustamante		=	total_sede_bustamante		-	presc_total_sede_bustamante


	  '** DESVIACION POR SEDE EN PORCNETAJES %
	   	v_porc_arancel_sede_bustamante	=	FormatPercent(arancel_sede_bustamante	/	ReemplazaCero(presc_arancel_sede_bustamante),2)
		v_porc_titulacion_sede_bustamante=	FormatPercent(titulacion_sede_bustamante	/	ReemplazaCero(presc_titulacion_sede_bustamante),2)
		v_porc_total_sede_bustamante		=	FormatPercent(total_sede_bustamante		/	ReemplazaCero(presc_total_sede_bustamante),2)
	  %>
	  <td></td>
	  <TH><%=FormatCurrency(v_dif_arancel_sede_bustamante,0)%></TH>
	  <TH><%=FormatCurrency(v_dif_titulacion_sede_bustamante,0)%></TH>
	  <TH><%=FormatCurrency(v_dif_total_sede_bustamante,0)%></TH>
	  <td></td>
	  <TH><%=v_porc_arancel_sede_bustamante%></TH>
	  <TH><%=v_porc_titulacion_sede_bustamante%></TH>
	  <TH><%=v_porc_total_sede_bustamante%></TH>


  </TR>

</table>
<%
' calculo de totales globales por carreras y facultades
v_total_arancel		=	arancel_central		+	arancel_providencia		+	arancel_melipilla 		+	arancel_bustamante
v_total_titulacion	=	titulacion_central	+	titulacion_providencia	+	titulacion_melipilla 	+	titulacion_bustamante
v_total_total		=	total_central		+	total_providencia		+	total_melipilla 		+	total_bustamante
v_presc_total_arancel		=	presc_arancel_central		+	presc_arancel_providencia		+	presc_arancel_melipilla 	+	presc_arancel_bustamante
v_presc_total_titulacion	=	presc_titulacion_central	+	presc_titulacion_providencia	+	presc_titulacion_melipilla 	+	presc_titulacion_bustamante
v_presc_total_total			=	presc_total_central			+	presc_total_providencia			+	presc_total_melipilla 		+	presc_total_bustamante

'response.Write("<br>"&v_presc_total_arancel)
'response.Write("<br>"&v_presc_total_titulacion)
'response.Write("<br>"&v_presc_total_total)
%>
<p>&nbsp;</p>

<p></p>
<p></p>
</body>
</html>