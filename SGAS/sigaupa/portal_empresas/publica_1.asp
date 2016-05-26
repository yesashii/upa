<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/revisa_session_empresa.asp" -->
<% 
'------------------------------------------------------

 set conexion = new CConexion
 conexion.Inicializar "upacifico"
 set errores = new CErrores

 set negocio = new CNegocio
 negocio.Inicializa conexion


q_rut=negocio.obtenerUsuario
'  q_rut =Request("daem[0][rut]")
'  q_dv=Request("daem[0][dv]")

 '-- Botones de la pagina -----------
 set f_botonera = new CFormulario
 f_botonera.Carga_Parametros "empresa.xml", "botonera"
 
 '---------------------------------------------------------------------------------------------------
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "empresa.xml", "busqueda"
 f_busqueda.Inicializar conexion

 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
'---------------------------------------------------------------------------------------------------
set f_oferta_trabajo = new CFormulario
 f_oferta_trabajo.Carga_Parametros "empresa.xml", "f_oferta_trabajo"
 f_oferta_trabajo.Inicializar conexion
 
				 selec_antecedentes="select ''"
			
 f_oferta_trabajo.Consultar selec_antecedentes
 f_oferta_trabajo.Siguiente
 'response.write(exiete_empre_daem)
'-----------------------------------------------------------------------------------------------
consulta_ciudades = "select regi_ccod, ciud_ccod, ciud_tdesc, ciud_tcomuna from ciudades order by ciud_tdesc asc"
empr_ncorr=conexion.ConsultaUno("select empr_ncorr from empresas where empr_nrut="&q_rut&"")
pers_nrut=conexion.ConsultaUno("select daem_pers_nrut_contacto from datos_empresa where empr_ncorr="&empr_ncorr&"")
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Bienvenido a Universidad del Pac&iacute;fico Online</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript" src="../biblioteca/dicc_ciudades.js"></script>
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>

<script language="JavaScript">

function ayuda (valor)
{ var mensaje="";
   
		switch (valor)
	{
	case 1 :  mensaje = "AYUDA\n En esta parte debes ingresar la descripcion del trabajo y el lugar donde se desarrollará"; break;
	case 2 : mensaje = "AYUDA\n Debe indicar el Nombre del Cargo"; break;
	case 3 : mensaje = "AYUDA\n Debe indicar el numero de puestos disponibles para el cargo"; break;
	case 4 : mensaje = "AYUDA\n Debe Selecionar el tipo de cargo "; break;
	case 5 : mensaje = "AYUDA\n Debe selecionar el área a la que pertence el cargo"; break;
	case 6 : mensaje = "AYUDA\n Debe detallar la oferta "; break;
	case 7 : mensaje = "AYUDA\n Debe indicar la jornada de la oferta"; break;
	case 8 : mensaje = "AYUDA\n Debe indicar la duracion del contrato de la oferta"; break;
	case 9 : mensaje = "AYUDA\n Debe indicar el monto del salario de la oferta"; break;
	case 10 : mensaje = "AYUDA\n Debe ingresar un comentario del salario"; break;
	case 11 : mensaje = "AYUDA\n Debe indicar la fecha en que la oferta caduca"; break;
	case 12 : mensaje = "AYUDA\n Debe indicar la region de la oferta"; break;
	case 13 : mensaje = "AYUDA\n Debe indicar la ciudad de la oferta"; break;
	case 14 : mensaje = "AYUDA\n Debe indicar el donde se realizara la oferta "; break;
	}
		   
	alert(mensaje);
}

function InicioPagina()
{

	_FiltrarCombobox(document.oferta_trabajo.elements["ofta[0][ciud_ccod]"], 
	                 document.oferta_trabajo.elements["ofta[0][regi_ccod]"].value,
					 d_ciudades,
					 'regi_ccod',
					 'ciud_ccod',
					 'ciud_tdesc',
					 '<%=f_oferta_trabajo.ObtenerValor("ciud_ccod")%>');
					// bloquea();
}

 

   function EsMayor(nDi0, nMe0, nAn0, nDi1, nMe1, nAn1)
   {
	    var bRes = false;
	    bRes = bRes || (nAn1 > nAn0);
	    bRes = bRes || ((nAn1 == nAn0) && (nMe1 > nMe0));
	    bRes = bRes || ((nAn1 == nAn0) && (nMe1 == nMe0) && (nDi1 > nDi0));
	    return bRes;
   }

function verifica_fecha_caducidad()
{
	fecha_actual=new Date()
	
	dia_actual=fecha_actual.getDate()
	mes_actual=fecha_actual.getMonth()
	ano_actual=fecha_actual.getFullYear() 
	
	switch (mes_actual)
	{
  		case 0: mesactual = "01"; break;
		case 1: mesactual = "02"; break;
		case 2: mesactual = "03"; break;
		case 3: mesactual = "04"; break;
		case 4: mesactual = "05"; break;
		case 5: mesactual = "06"; break;
		case 6: mesactual = "07"; break;
		case 7: mesactual = "08"; break;
		case 8: mesactual = "09"; break;
		case 9: mesactual = "10"; break;
		case 10: mesactual ="11"; break;
		case 11: mesactual ="12"; break;	
  	}
	//alert("fecha actual "+dia_actual+'/'+mesactual+'/'+ano_actual)
	
	
	fecha_ingresada=document.oferta_trabajo.elements["ofta[0][fcaducidad_oferta]"].value
	//alert("fecha ingresada "+fecha_ingresada)
	mfecha=fecha_ingresada.split("/")
	
	dia_ingresado=mfecha[0]
	mes_ingresado=mfecha[1]
	ano_ingresado=mfecha[2]
	
	
	
	mayor=EsMayor(dia_actual,mesactual,ano_actual,dia_ingresado,mes_ingresado,ano_ingresado)
	//alert(mayor)
	return mayor
}

function _Guardar2(p_boton, formulario, p_url, p_target, p_funcion_validacion, p_mensaje_confirmacion, p_soloUnClick)
{
	var continuar = true;
	var v_soloUnClick = (p_soloUnClick.toUpperCase() == 'TRUE') ? true : false;
	
	
	if (p_mensaje_confirmacion != "") {
		continuar = confirm(p_mensaje_confirmacion);
	}	
	
	if (continuar) 
	{
		
			if (preValidaFormulario(formulario)) 
			{			veri=verifica_fecha_caducidad()
				if (veri!=false)
				{
					if (p_funcion_validacion != "")			
						eval("_form_valido = " + p_funcion_validacion);
					else
						_form_valido = true;			
					
					if (_form_valido) 
					{
						formulario.action = p_url;
						formulario.method = "post";
						formulario.target = p_target;
						formulario.submit();
						
						_HabilitarBoton(p_boton, !v_soloUnClick);
					}
				 }
				 else
				 {
					alert("Le fecha de caducidad debe ser mayor a la fecha actual")
				
				 }			
			}  
				
	}
}

</script>
<%
set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "ofta[0][fcaducidad_oferta]","1","oferta_trabajo","fecha_oculta_fnacimiento"
	calendario.FinFuncion


%>
<style type="text/css">
#menu div.barraMenu,
#menu div.barraMenu a.botonMenu {
font-family: sans-serif, Verdana, Arial;
font-size: 8pt;
color: white;
}

#menu div.barraMenu {
text-align: left;
}

#menu div.barraMenu a.botonMenu {
background-color: #4b73a6;
border-bottom-style:double;
border-color:#FFFFFF;
color: white;
cursor: pointer;
padding: 4px 6px 2px 5px;
text-decoration: none;
}

#menu div.barraMenu a.botonMenu:hover {
background-color: #FFFFFF;
color:#4b73a6;
}

#menu div.barraMenu a.botonMenu:active {
background-color: #637D4D;
color: black;
}
body {
	background-color: #FFFFFF;
}
</style>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" background="imagenes/fondo.jpg" onLoad= "InicioPagina();">
<%calendario.ImprimeVariables%>
 <form name="oferta_trabajo">
 <input type="hidden" name="ofta[0][empre_ncorr]" value="<%=empr_ncorr%>">
<input type="hidden" name="ofta[0][pers_nrut]" value="<%=pers_nrut%>">
<center>

  <table width="800"  align="center">
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<tr>
		<td width="100%" align="center"><font size="5" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>CREACI&Oacute;N DE  OFERTA DE EMPLEO </strong></font></td>
	</tr>
	<tr valign="top">
		<td width="100%"  align="left">
			<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="97%" border="0" bgcolor="#f7faff">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="249"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Descripción Oferta Trabajo </strong></font></td>
									       <td width="449"><hr></td>
									       <td width="41" height="38">
										        <%POS_IMAGEN = 0%>
										   		<a href="javascript:ayuda(1)"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda2.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda1.png';return true ">
												
										  <img src="imagenes/ayuda1.png" border="0" width="38" height="38" alt="¿Cómo funciona?">												</a>										   </td>
										</tr>
									</table>								
							  </td>
							</tr>
							
							<tr>
							  <td width="100%">
							  		<table width="100%">
										<tr>
											<td width="56%" align="right">
												<table>
													<tr>
														<td>
															<a href="javascript:ayuda(2)">
										  					<img src="imagenes/ayuda1.png" border="0" width="28" height="28" alt="¿Cómo funciona?"></a>
														</td>
														<td>
															<font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Cargo/Puesto  :</strong></font>											
														</td>
													</tr>
												</table>
										  </td>
											<td width="44%" align="left">
												<font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_oferta_trabajo.dibujaCampo("cargo")%></font>											</td>
										</tr>
										<tr>
											<td width="56%" align="right">
												<table>
													<tr>
														<td>
															<a href="javascript:ayuda(3)">
										  					<img src="imagenes/ayuda1.png" border="0" width="28" height="28" alt="¿Cómo funciona?"></a>
														</td>
														<td>
															<font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>N° de Vacantes  :</strong></font>											
														</td>
													</tr>
												</table>
										  </td>
											<td width="44%" align="left">
												<font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_oferta_trabajo.dibujaCampo("vacantes")%></font>											</td>
										</tr>
										<tr>
											<td width="56%" align="right">
												<table>
													<tr>
														<td>
															<a href="javascript:ayuda(4)">
										  					<img src="imagenes/ayuda1.png" border="0" width="28" height="28" alt="¿Cómo funciona?"></a>
														</td>
														<td>
															<font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Tipo de cargo  :</strong></font>											
														</td>
													</tr>
												</table>
										  </td>
											<td width="44%" align="left">
												<font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_oferta_trabajo.dibujaCampo("tipo_cargo")%></font>											</td>
										</tr>
										<tr>
											<td width="56%" align="right">
												<table>
													<tr>
														<td>
															<a href="javascript:ayuda(5)">
										  					<img src="imagenes/ayuda1.png" border="0" width="28" height="28" alt="¿Cómo funciona?"></a>
														</td>
														<td>
															<font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Área  :</strong></font>
														</td>
													</tr>
												</table>
										  </td>
											<td width="44%" align="left">
												<font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_oferta_trabajo.dibujaCampo("area")%></font>											</td>
										</tr>
										<tr>
											<td width="56%" align="right" valign="top">
												<table>
													<tr>
														<td>
															<a href="javascript:ayuda(6)">
										  					<img src="imagenes/ayuda1.png" border="0" width="28" height="28" alt="¿Cómo funciona?"></a>
														</td>
														<td>
															<font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Descripción de la Oferta  :</strong></font>
														</td>
													</tr>
												</table>											
										  </td>
											<td width="44%" align="left">
												<font size="2" face="Courier New, Courier, mono" color="#496da6">
										  <textarea   name='ofta[0][desc_oferta]' rows="5" cols="55" onBlur="this.value=this.value.toUpperCase();"></textarea></font>											</td>
										</tr>
										<tr>
											<td width="56%" align="right">
												<table>
													<tr>
														<td>
															<a href="javascript:ayuda(7)">
										  					<img src="imagenes/ayuda1.png" border="0" width="28" height="28" alt="¿Cómo funciona?"></a>
														</td>
														<td>
															<font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Disponibilidad para Trabajar/ jornada laboral   :</strong></font>
														</td>
													</tr>
												</table>						
										  </td>
											<td width="44%" align="left">
												<font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_oferta_trabajo.dibujaCampo("jornada")%></font>											</td>
										</tr>
										<tr>
											<td width="56%" align="right">
												<table>
													<tr>
														<td>
															<a href="javascript:ayuda(8)">
										  					<img src="imagenes/ayuda1.png" border="0" width="28" height="28" alt="¿Cómo funciona?"></a>
														</td>
														<td>
															<font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Duraci&oacute;n del Contrato   :</strong></font>																						
														</td>
													</tr>
												</table>
										  </td>
											<td width="44%" align="left">
												<font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_oferta_trabajo.dibujaCampo("duracion_contrato")%></font>										</td>
										</tr>
										<tr>
											<td width="56%" align="right">
												<table>
													<tr>
														<td>
															<a href="javascript:ayuda(9)">
										  					<img src="imagenes/ayuda1.png" border="0" width="28" height="28" alt="¿Cómo funciona?"></a>
														</td>
														<td>
															<font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Salario l&iacute;quido    :</strong></font>
														</td>
													</tr>
												</table>											
										  </td>
											<td width="44%" align="left">
												<font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_oferta_trabajo.dibujaCampo("salario")%></font>											</td>
										</tr>
										<tr>
											<td width="56%" align="right">
												<table>
													<tr>
														<td>
															<a href="javascript:ayuda(10)">
										  					<img src="imagenes/ayuda1.png" border="0" width="28" height="28" alt="¿Cómo funciona?"></a>
														</td>
														<td>
															<font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Comentarios del Salario(comisiones/incentivos):</strong></font>
														</td>
													</tr>
												</table>											
										  </td>
											<td width="44%" align="left">
												<font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_oferta_trabajo.dibujaCampo("cometario_salario")%></font>											</td>
										</tr>
										<tr>
											<td width="56%" align="right">
												<table>
													<tr>
														<td>
															<a href="javascript:ayuda(11)">
										  					<img src="imagenes/ayuda1.png" border="0" width="28" height="28" alt="¿Cómo funciona?"></a>
														</td>
														<td>
															<font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Fecha Caducidad de la Oferta de empleo   :</strong></font>									
														</td>
													</tr>
												</table>
										  </td>
											<td width="44%" align="left">
												<font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_oferta_trabajo.dibujaCampo("fcaducidad_oferta")%><a style='cursor:hand;' onClick='PopCalendar.show(document.oferta_trabajo.fecha_oculta, "dd/mm/yyyy", null, null, "obtener_fecha(1)", "11"); cambia(1);'> </a>
												<%calendario.DibujaImagen "fecha_oculta_fnacimiento","1","oferta_trabajo" %>
										  </font> </td>
										</tr>
										
									</table>
							  </td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="88">
										   	
										   <font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Ubicación</strong></font>
										   </td>
									      <td width="610"><hr></td>
									      <td width="41" height="38">&nbsp;</td>
										</tr>
									</table>								
							  </td>
							</tr>
							<tr>
							  <td width="100%">
							  		<table width="100%">
										<tr>
											<td width="52%" align="right">
												<table>
													<tr>
														<td>
															<a href="javascript:ayuda(12)">
										  					<img src="imagenes/ayuda1.png" border="0" width="28" height="28" alt="¿Cómo funciona?"></a>
														</td>
														<td>
														<font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Región  :</strong></font>
														</td>
													</tr>
												</table>
											</td>
											<td width="48%" align="left">
												<font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_oferta_trabajo.dibujaCampo("regi_ccod")%></font>
											</td>
										</tr>
										<tr>
											<td width="52%" align="right">
												<table>
													<tr>
														<td>
															<a href="javascript:ayuda(13)">
										  					<img src="imagenes/ayuda1.png" border="0" width="28" height="28" alt="¿Cómo funciona?"></a>
														</td>
														<td>
															<font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Ciudad  :</strong></font>
														</td>
													</tr>
												</table>
											</td>
											<td width="48%" align="left">
												<font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_oferta_trabajo.dibujaCampo("ciud_ccod")%></font>
											</td>
										</tr>
										<tr>
											<td width="52%" align="right">
												<table>
													<tr>
														<td>
															<a href="javascript:ayuda(14)">
										  					<img src="imagenes/ayuda1.png" border="0" width="28" height="28" alt="¿Cómo funciona?"></a>
														</td>
														<td>
															<font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Lugar de trabajo  :</strong></font>
														</td>
													</tr>
												</table>
											</td>
											<td width="48%" align="left">
												<font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_oferta_trabajo.dibujaCampo("lugar_trabajo")%></font>
											</td>
										</tr>
									</table>
							  </td>
							</tr>
							<tr>
								<td>
									
									<table width="718">
										<tr>
										  <td width="434" height="10">&nbsp;</td>
										  <td width="111" height="10" align="center">
										  <a href="javascript:_Navegar(this, 'inicio_empresa.asp', 'FALSE');"> 
										  <img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> </a>
										  </td>
										  <td width="157" height="10" align="left">
										  <a href="javascript:_Guardar2(this, document.forms['oferta_trabajo'], 'publica_1_proc.asp','', '', '', 'FALSE');"> 
										  <img src="imagenes/CONTINUAR_21.png" border="0" width="70" height="70" alt="Guardar"> </a> 
										   
										  </td>
										</tr>
								  </table>
										  						
								</td>
							</tr>
				 </table>
	  </td>
	</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
			</table>		</td>
	</tr>
		 
	<!--Antecedentes educacionales-->
	<!--Identificación del sostenedor académico-->
</table>




</center>
 <form>
</body>
</html>
