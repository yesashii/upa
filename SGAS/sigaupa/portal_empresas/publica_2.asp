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
ofta_ncorr=request.QueryString("ofta_ncorr")

empr_ncorr=conexion.ConsultaUno("select empr_ncorr from empresas where empr_nrut="&q_rut&"")
pers_nrut=conexion.ConsultaUno("select daem_pers_nrut_contacto from datos_empresa where empr_ncorr="&empr_ncorr&"")

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
'---------------------------------------------------------------------------------------------------
set f_carreras= new CFormulario
 f_carreras.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_carreras.Inicializar conexion
 
				 selec_antecedentes="select carr_ccod,carr_tdesc from carreras where carr_ccod in (800,14,32,970,41,45,47,17,23,21,860,880,870,950,940,43,49,51,99,830,840,850,36,940,980) order by carr_tdesc"
			
 f_carreras.Consultar selec_antecedentes
 
 'response.write(exiete_empre_daem)
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

<script language="JavaScript">

function ayuda (valor)
{ var mensaje="";

	switch (valor)
	{
	case 1 : mensaje = "AYUDA\n Debe ingresar lo requisitos especifico del trabajo"; break;
	case 2 : mensaje = "AYUDA\n Debe indicar el operador y los años de experiencia"; break;
	case 3 : mensaje = "AYUDA\n Debe indicar el grado educacional que necesita el cargo"; break;
	case 4 : mensaje = "AYUDA\n Debe indicar en que estado tienen que estar los estudios del postulante para el cargo"; break;
	case 5 : mensaje = "AYUDA\n Debe indicar todos los requisitos necesarios para el cargo"; break;
	case 6 : mensaje = "AYUDA\n Debe indicar si es necesario conocimientos computacionales para el cargo"; break;
	case 7 : mensaje = "AYUDA\n Debe indicar si es el cargo es para alguna(s) carrera(s) en especial"; break;
	case 8 : mensaje = "AYUDA\n Debe indicar si es el cargo necesita conocimientos en algun idioma, el nivel y que habilidad"; break;
	case 9 : mensaje = "AYUDA\n Debe indicar si es el cargo necesita conocimientos en algún Programa y el nivel"; break;
	}
  
		   
	alert(mensaje);
}


function enviar()
{
	valido=Validar_rut("daem[0][rut]","daem[0][dv]");
	
	if (valido!=false)
	{
		document.empresa.submit();

	}
}
function revisa_carrera_mov(val)
{
	if (val==1)
	{
		document.oferta_trabajo.elements["pone"].disabled=true;
	}
	else
	{
		document.oferta_trabajo.elements["pone"].disabled=false;
	}

}


function MueveSelect(Origen, Destino,agrega)
	{
	  var ok=false;
	  var valora=Origen.options[Origen.selectedIndex].value 
	  i=Destino.length;
	  valor=Origen.selectedIndex ;
	  if (valor>=0)
		{
			if(agrega==1)
			{	
					contenido=document.oferta_trabajo.elements["ofta[0][LISTADOCARRERA]"].value;
					valor_sel=document.oferta_trabajo.elements["ofta[0][carreras]"].value;
					if (valor_sel==0){revisa_carrera_mov(agrega)}
					//alert(valor_sel);
					//alert(contenido);
					if (contenido=="")
						{
							separador=""
						}
					else
						{
							separador="|"
						}	
					contenido2=contenido+separador+valor_sel;
					
					document.oferta_trabajo.elements["ofta[0][LISTADOCARRERA]"].value=contenido2;
			}
			if (agrega==2)
			{	
					contiene_listo_carrera=document.oferta_trabajo.elements["ofta[0][LISTADOCARRERA]"].value;
					if (contiene_listo_carrera==0){revisa_carrera_mov(agrega)}
				    arr_lista_carrera=contiene_listo_carrera.split("|");
				  
					arr_lista_carrera.splice(valor,1) 
				 
				 
					resul=arr_lista_carrera.join("|") ;
					document.oferta_trabajo.elements["ofta[0][LISTADOCARRERA]"].value="";
					document.oferta_trabajo.elements["ofta[0][LISTADOCARRERA]"].value=resul;
			}
		
		
		
		  texto=Origen.options[valor].text;
		  for (var e=0; e< i; e++) 
			{
			  if (texto==Destino.options[e].text)
				{
				  ok=true;
				  break;
				}
			  else
				  ok=false;
			}
		  if (!ok)
			{
			  temp = Origen.selectedIndex;
			  var el = new Option(texto,valora);
			  Destino.options[i] = el;
			  Origen.options[temp]=null;
			}
			
			
		}
	  else
		alert("Seleccione un valor para agregar.");
	}


function agregaIdioma()
	{
	  if ((document.oferta_trabajo.elements["ofta[0][idiomas]"].value>0)&&(document.oferta_trabajo.elements["ofta[0][niveles_idioma]"].value>0))
		{
		  var separador = "|";
		  if (document.oferta_trabajo.elements["ofta[0][LISTADOIDIOMAS]"].value == "" ) separador = "";
			var texto = document.oferta_trabajo.elements["ofta[0][idiomas]"].options[document.oferta_trabajo.elements["ofta[0][idiomas]"].selectedIndex].text +'('+document.oferta_trabajo.elements["ofta[0][niveles_idioma]"].options[document.oferta_trabajo.elements["ofta[0][niveles_idioma]"].selectedIndex].text +' ' + 'Hab:' + document.oferta_trabajo.elements["ofta[0][habla]"].options[document.oferta_trabajo.elements["ofta[0][habla]"].selectedIndex].text + ', Lee:' + document.oferta_trabajo.elements["ofta[0][lee]"].options[document.oferta_trabajo.elements["ofta[0][lee]"].selectedIndex].text  + ', Esc:' + document.oferta_trabajo.elements["ofta[0][escribe]"].options[document.oferta_trabajo.elements["ofta[0][escribe]"].selectedIndex].text + ')' ;
			
			var valora = document.oferta_trabajo.elements["ofta[0][idiomas]"].value;
			
			i=document.oferta_trabajo.idiomasAvisosID.length;
			
			var el = new Option(texto,valora);
			
			document.oferta_trabajo.idiomasAvisosID.options[i] = el;
			
			document.oferta_trabajo.elements["ofta[0][LISTADOIDIOMAS]"].value=document.oferta_trabajo.elements["ofta[0][LISTADOIDIOMAS]"].value + separador + document.oferta_trabajo.elements["ofta[0][idiomas]"].value + ',' + document.oferta_trabajo.elements["ofta[0][niveles_idioma]"].value + ',' + document.oferta_trabajo.elements["ofta[0][habla]"].value  + ',' + document.oferta_trabajo.elements["ofta[0][lee]"].value  + ',' + document.oferta_trabajo.elements["ofta[0][escribe]"].value  + '';
			
			borrar(document.oferta_trabajo.elements["ofta[0][idiomas]"]);
		}
	  else
		  alert("Seleccione El idioma y el Nivel para agregar.");
	}

function borrarIdioma(Obj)
	{
	  temp = Obj.selectedIndex;
	  if (temp>=0)
 
		{
		  i=document.oferta_trabajo.elements["ofta[0][idiomas]"].length;
		  var inicio = Obj.options[Obj.selectedIndex].text.indexOf("(",0)-1;
		  var texto = Obj.options[Obj.selectedIndex].text.substring(0,inicio);
		  var valora = Obj.value;
		  var el = new Option(texto,valora);
		  document.oferta_trabajo.elements["ofta[0][idiomas]"].options[i] = el;				
		  Obj.options[temp]=null;
		  
		  
		  contiene_listo_idioma=document.oferta_trabajo.elements["ofta[0][LISTADOIDIOMAS]"].value;
		  arr_lista_idioma=contiene_listo_idioma.split("|");
		  
		 	arr_lista_idioma.splice(temp,1) 
		 
		 
		 		resul=arr_lista_idioma.join("|") ;
			document.oferta_trabajo.elements["ofta[0][LISTADOIDIOMAS]"].value="";
			document.oferta_trabajo.elements["ofta[0][LISTADOIDIOMAS]"].value=resul;

		}
	  else if (Obj.length==0)
		  alert("La lista está vacía");
	  else if (temp<0)
		  alert("Seleccione el valor que desea eliminar.");
	}
	
	function agregaPrograma()
	{
	  if ((document.oferta_trabajo.elements["ofta[0][programas]"].value>0)&&(document.oferta_trabajo.elements["ofta[0][niveles_programas]"].value>0))
		{
		  var separador = "|";
		  if (document.oferta_trabajo.elements["ofta[0][LISTADOPROGRAMAS]"].value == "" ) separador = "";
			var texto = document.oferta_trabajo.elements["ofta[0][programas]"].options[document.oferta_trabajo.elements["ofta[0][programas]"].selectedIndex].text +'('+document.oferta_trabajo.elements["ofta[0][niveles_programas]"].options[document.oferta_trabajo.elements["ofta[0][niveles_programas]"].selectedIndex].text + ')' ;
			
			var valora = document.oferta_trabajo.elements["ofta[0][programas]"].value;
			
			i=document.oferta_trabajo.programasAvisosID.length;
			
			var el = new Option(texto,valora);
			
			document.oferta_trabajo.programasAvisosID.options[i] = el;
			
			document.oferta_trabajo.elements["ofta[0][LISTADOPROGRAMAS]"].value=document.oferta_trabajo.elements["ofta[0][LISTADOPROGRAMAS]"].value + separador + document.oferta_trabajo.elements["ofta[0][programas]"].value + ',' + document.oferta_trabajo.elements["ofta[0][niveles_programas]"].value +'';
			
			borrar(document.oferta_trabajo.elements["ofta[0][programas]"]);
		}
	  else
		  alert("Seleccione El Programa y el Nivel para agregar.");
	}
function borrar(Obj)
	{
	  temp = Obj.selectedIndex;
	  if (temp>=0)
		Obj.options[temp]=null;
	  else if (Obj.length==0)
		alert("La lista está vacía");
	  else if (temp<0)
		alert("Seleccione el valor que desea eliminar.");
	}
	
	function borrarPrograma(Obj)
	{
	  temp = Obj.selectedIndex;
	  if (temp>=0)
 
		{
		  i=document.oferta_trabajo.elements["ofta[0][programas]"].length;
		  var inicio = Obj.options[Obj.selectedIndex].text.indexOf("(",0)-1;
		  var texto = Obj.options[Obj.selectedIndex].text.substring(0,inicio);
		  var valora = Obj.value;
		  var el = new Option(texto,valora);
		  document.oferta_trabajo.elements["ofta[0][programas]"].options[i] = el;				
		  Obj.options[temp]=null;
		  
		  
		  contiene_listo_programa=document.oferta_trabajo.elements["ofta[0][LISTADOPROGRAMAS]"].value;
		  arr_lista_programa=contiene_listo_programa.split("|");
		  
		 	arr_lista_programa.splice(temp,1) 
		 
		 
		 		resul=arr_lista_programa.join("|") ;
			document.oferta_trabajo.elements["ofta[0][LISTADOPROGRAMAS]"].value="";
			document.oferta_trabajo.elements["ofta[0][LISTADOPROGRAMAS]"].value=resul;

		}
	  else if (Obj.length==0)
		  alert("La lista está vacía");
	  else if (temp<0)
		  alert("Seleccione el valor que desea eliminar.");
	}
	
function verifica_carreras()
{
	carreras=document.oferta_trabajo.elements["ofta[0][LISTADOCARRERA]"].value;
	
	//alert(carreras)
	if (carreras=="")
		{
			return false;
		}
	else
		{
			return true;
		}
	
}
function verifica_programas()
{
	carreras=document.oferta_trabajo.elements["ofta[0][LISTADOPROGRAMAS]"].value;
	marcada=document.oferta_trabajo.elements["ofta[0][conocimiento_comp]"].value;
	
	//alert(marcada)
	if (marcada==1)
	{
		if (carreras=="")
			{
				return false;
			}
		else
			{
				return true;
			}
	}
	{
		return true;
	}
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
			{			veri=verifica_carreras()
						veri2=verifica_programas()
				if ((veri!=false)&&(veri2!=false))
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
				 	
					if (veri==false)
					{
					warnEmpty (document.oferta_trabajo.elements["ofta[0][carreras]"])
					}
					if (veri2==false)
					{
					warnEmpty (document.oferta_trabajo.elements["ofta[0][programas]"])
					}
					//document.oferta_trabajo.elements["ofta[0][carreras]"].focus;
	 				//document.oferta_trabajo.elements["ofta[0][carreras]"].type=="select-one";
					//alert("Debe Selecionar una Opción en Carreras");
				
				 }			
			}  
				
	}
}
	
function Activar_programas(valor)
{
	if (valor==1)
	{
		document.oferta_trabajo.elements["ofta[0][programas]"].disabled=false
		document.oferta_trabajo.elements["ofta[0][niveles_programas]"].disabled=false
	
	}
	else
	{
		document.oferta_trabajo.elements["ofta[0][programas]"].disabled=true
		document.oferta_trabajo.elements["ofta[0][niveles_programas]"].disabled=true
	
	}

}
</script>
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

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" background="imagenes/fondo.jpg" onLoad="Activar_programas(2);">
 <form name="oferta_trabajo">
 <input type="hidden" name="ofta[0][ofta_ncorr]" value="<%=ofta_ncorr%>">
  <input type="hidden" name="ofta[0][pers_nrut]" value="<%=pers_nrut%>">
<center>

  <table width="793"  align="center">
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
										  <td width="91">
										   		<font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Requisitos </strong></font>										  </td>
									      <td width="607">&nbsp;</td>
									      <td width="41" height="38">
										        <%POS_IMAGEN = 0%>
										   		<a href="javascript:ayuda(1)"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda2.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda1.png';return true ">
										  		<img src="imagenes/ayuda1.png" border="0" width="38" height="38" alt="¿Cómo funciona?"></a>										   										  </td>
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
															<a href="javascript:ayuda(2)">
										  					<img src="imagenes/ayuda1.png" border="0" width="28" height="28" alt="¿Cómo funciona?"></a>														</td>
														<td>
															<font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Experiencia Laboral  :</strong></font>														</td>
													</tr>
												</table>											</td>
											<td width="48%" align="left">
												<font size="2" face="Courier New, Courier, mono" color="#496da6">
																						  <select name='ofta[0][operador_experiencia]'>
																						  <option value="1">igual a</option>
																						  <option value="2">mayor que</option>
																						  <option value="3">menor que</option>
																						  </select><%=f_oferta_trabajo.dibujaCampo("anos_experiencia")%>&nbsp;años&nbsp;(0=sin experiencia)</font>											</td>
										</tr>
										<tr>
											<td width="52%" align="right">
												<table>
													<tr>
														<td>
															<a href="javascript:ayuda(3)">
										  					<img src="imagenes/ayuda1.png" border="0" width="28" height="28" alt="¿Cómo funciona?"></a>														</td>
														<td>
															<font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Grado educacional/estudios mínimos  :</strong></font>											</td>
													</tr>
												</table>										  </td>
											<td width="48%" align="left">
												<font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_oferta_trabajo.dibujaCampo("estudio_minimo")%></font>											</td>
										</tr>
										<tr>
											<td width="52%" align="right">
												<table>
													<tr>
														<td>
															<a href="javascript:ayuda(4)">
										  					<img src="imagenes/ayuda1.png" border="0" width="28" height="28" alt="¿Cómo funciona?"></a>														</td>
														<td>
															<font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Situación de Estudio  :</strong></font>														</td>
													</tr>
												</table>											</td>
											<td width="48%" align="left">
												<font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_oferta_trabajo.dibujaCampo("situacion_estudio")%></font>											</td>
										</tr>
										<tr>
											<td width="52%" align="right" valign="top">
												<table>
													<tr>
														<td>
															<a href="javascript:ayuda(5)">
										  					<img src="imagenes/ayuda1.png" border="0" width="28" height="28" alt="¿Cómo funciona?"></a>														</td>
														<td>
														<font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Requisitos Mínimos  :</strong></font>														</td>
													</tr>
												</table>											</td>
											<td width="48%" align="left">
												<font size="2" face="Courier New, Courier, mono" color="#496da6"><textarea  name='ofta[0][requisitos_minimos]' rows="5" cols="70" onBlur="this.value=this.value.toUpperCase();"></textarea></font>											</td>
										</tr>
										<tr>
											<td width="52%" align="right">
												<table>
													<tr>
														<td>
															<a href="javascript:ayuda(6)">
										  					<img src="imagenes/ayuda1.png" border="0" width="28" height="28" alt="¿Cómo funciona?"></a>														</td>
														<td>
															<font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Conocimientos en computación :</strong></font>														</td>
													</tr>
												</table>											</td>
											<td width="48%" align="left">
													    <select name="ofta[0][conocimiento_comp]" id='TO-N' onChange="Activar_programas(this.value);">
														<option value="1">Seleccionar</option>
														<option value="1">Si</option>
														<option value="2">No</option>
														</select>											</td>
										</tr>
										
										
										<tr>
											<td colspan="2">
												<table width="100%">
													<tr>
														<td>
															<table align="center">
																<tr align="center">
																	<td align="center">
																		<a href="javascript:ayuda(9)">
										  								<img src="imagenes/ayuda1.png" border="0" width="28" height="28" alt="¿Cómo funciona?"></a>																	</td>
																	<td>
																	<font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Programas</strong></font>																	</td>
																</tr>
															</table>														</td>
														<td></td>
														<td align="center">
															<font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Programas Selecionados</strong></font>														</td>
													</tr>
													<tr>
											<td width="46%" align="center">
												<table width="292">
													<tr>
														<td width="60%" align="right">
																	<font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Programas</strong></font>														
														</td>
														<td width="40%" align="left">
															<font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_oferta_trabajo.dibujaCampo("programas")%></font>											    </td>
													</tr>
													<tr>
														<td width="60%" align="right"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Nivel de Conocimiento</strong></font></td>
														<td width="40%" align="left">
															<font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_oferta_trabajo.dibujaCampo("niveles_programas")%></font>								</td>
													</tr>
													
											    </table>											
											  </td>
											<td width="7%" align="center">
															<table>
																<tr>
																	<td>
																		<input type="button" onClick="agregaPrograma()" name="agregar" value=" &gt;&gt; ">																	</td>
																</tr>
																<tr>
																	<td>
																		<input type="button" onClick="borrarPrograma(document.oferta_trabajo.programasAvisosID)" name="agregar" value=" &lt;&lt; ">																	</td>
																</tr>  
															</table>													  </td>
											<td width="47%" align="center" valign="top">
												<font size="2" face="Courier New, Courier, mono" color="#496da6">
												<select name="programasAvisosID" size="5" style="width:275px;" >
												</select>
											  <input type="hidden" name="ofta[0][LISTADOPROGRAMAS]" value=""></font>											</td>
										</tr>
												</table>											</td>
										</tr>
										<tr>
											<td width="52%" align="center">
												<table>
													<tr>
														<td>
															<a href="javascript:ayuda(7)">
										  					<img src="imagenes/ayuda1.png" border="0" width="28" height="28" alt="¿Cómo funciona?"></a>														</td>
														<td>
															<font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Carreras</strong></font>														</td>
													</tr>
												</table>											</td>
											<td width="48%" align="center">
												<font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Carreras Selecionadas</strong></font>											</td>
										</tr>
										<tr>
											<td colspan="2" align="center">
												<table width="100%">
													<tr>
													  <td width="45%" align="right"><font size="2" face="Courier New, Courier, mono" color="#496da6">
																<select name="ofta[0][carreras]" size="5" style="width:100%;"> 
																<option value=0>CUALQUIER CARRERA</option>
																<% while f_carreras.Siguiente%>
																<option value="<%=f_carreras.ObtenerValor("carr_ccod")%>"><%=f_carreras.ObtenerValor("carr_tdesc")%></option> 																
																<%wend%> 
																</select></font>													  </td>
														<td width="10%" align="center">
															<table>
																<tr>
																	<td>
																		<input type="button" name="pone" value=" >> "  onClick="if (document.oferta_trabajo.elements['ofta[0][carreras]'].selectedIndex>=0) { MueveSelect(document.oferta_trabajo.elements['ofta[0][carreras]'],document.oferta_trabajo.elements['ofta[0][carreras_sel]'],1); } else { alert('debes seleccionar alguna carrera')}">																	</td>
																</tr>
																<tr>
																	<td>
																		<input type="button" value=" << " onClick="if (document.oferta_trabajo.elements['ofta[0][carreras_sel]'].selectedIndex>=0) { MueveSelect(document.oferta_trabajo.elements['ofta[0][carreras_sel]'],document.oferta_trabajo.elements['ofta[0][carreras]'],2); } else { alert('debes seleccionar alguna carrera')}">																	</td>
																</tr>  
															</table>														</td>
														<td width="45%" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6">
														<select  size="5" name="ofta[0][carreras_sel]"  style="width:100%;" multiple>
														</select>
														<input type="hidden" name="ofta[0][LISTADOCARRERA]"  value="">
														</font>													  </td>
													</tr>
												</table>											</td>
										</tr>
										

										<tr>
											<td colspan="2">
												<table width="100%">
													<tr>
														<td>
															<table align="center">
																<tr align="center">
																	<td align="center">
																		<a href="javascript:ayuda(8)">
										  								<img src="imagenes/ayuda1.png" border="0" width="28" height="28" alt="¿Cómo funciona?"></a>																	</td>
																	<td>
																	<font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Idiomas</strong></font>																	</td>
																</tr>
															</table>														</td>
														<td></td>
														<td align="center">
															<font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Idiomas Selecionados</strong></font>														</td>
													</tr>
													<tr>
											<td width="46%" align="center">
												<table width="292" height="126">
													<tr>
														<td width="60%" align="right">
																	<font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Idiomas</strong></font>														</td>
														<td width="40%" align="left">
															<font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_oferta_trabajo.dibujaCampo("idiomas")%></font>													  </td>
													</tr>
													<tr>
														<td width="60%" align="right"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Nivel de Conocimiento</strong></font></td>
														<td width="40%" align="left">
															<font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_oferta_trabajo.dibujaCampo("niveles_idioma")%></font>													  </td>
													</tr>
													<tr>
														<td width="60%" align="right">
															<font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Habla</strong></font>														</td>
														<td width="40%" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6">
														<select name="ofta[0][habla]">
														<option value="1">Si</option>
														<option value="2">No</option>
														</select>
												</font>													  </td>
													</tr>
													<tr>
														<td width="60%" align="right">
															<font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Lee</strong></font>														</td>
														<td width="40%" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6">
														<select name="ofta[0][lee]">
														<option value="1">Si</option>
														<option value="2">No</option>
														</select>
														</font>													  </td>
													</tr>
													<tr>
														<td width="60%" align="right">
															<font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Escribe</strong></font>														</td>
														<td width="40%" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6">
														<select name="ofta[0][escribe]">
														<option value="1">Si</option>
														<option value="2">No</option>
														</select>
														</font>													  </td>
													</tr>
											  </table>											</td>
											<td width="7%" align="center">
															<table>
																<tr>
																	<td>
																		<input type="button" onClick="agregaIdioma()" name="agregar" value=" &gt;&gt; ">																	</td>
																</tr>
																<tr>
																	<td>
																		<input type="button" onClick="borrarIdioma(document.oferta_trabajo.idiomasAvisosID)" name="agregar" value=" &lt;&lt; ">																	</td>
																</tr>  
															</table>													  </td>
											<td width="47%" align="center" valign="top">
												<font size="2" face="Courier New, Courier, mono" color="#496da6">
												<select name="idiomasAvisosID" size="5" style="width:275px;" >
												</select>
											  <input type="hidden" name="ofta[0][LISTADOIDIOMAS]" value=""></font>											</td>
										</tr>
												</table>											</td>
										</tr>
									</table>							 
							  </td>
							</tr>
							<tr>
								<td>
									
									<table width="718">
										<tr>
										  <td width="434" height="10">&nbsp;</td>
										  <td width="129" height="10" align="center"><%POS_IMAGEN = POS_IMAGEN + 9%>
										  <a href="javascript:_Navegar(this, 'inicio_empresa.asp', 'FALSE');"
														onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
														onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true "> <img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> </a>										  </td>
										  <td width="139" height="10" align="left"><%POS_IMAGEN = POS_IMAGEN + 1%>
										  <a href="javascript:_Guardar2(this, document.forms['oferta_trabajo'], 'publica_2_proc.asp','', '', '', 'FALSE');"
														onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/FINALIZAR_22.png';return true "
														onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/FINALIZAR_21.png';return true "> <img src="imagenes/FINALIZAR_21.png" border="0" width="70" height="70" alt=""> </a>
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




  <hr>
</center>
 </form>
</body>
</html>
