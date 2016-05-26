<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno_2008.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<% 
'------------------------------------------------------
pers_ncorr = Session("pers_ncorr")
secc_ccod = Session("secc_ccod")
pers_ncorr_profesor	 =  Session("pers_ncorr_profesor")

set conectar = new CConexion
conectar.Inicializar "upacifico"

set tabla = new CFormulario
tabla.Carga_Parametros "tabla_vacia.xml", "tabla"
tabla.Inicializar conectar

consulta = " select parte_2_1,parte_2_2,parte_2_3,parte_2_4,parte_2_5,parte_2_6,parte_2_7,parte_2_8,parte_2_9,parte_2_observaciones " &_
           " from cuestionario_opinion_alumnos where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_profesor as varchar)='"&pers_ncorr_profesor&"'"

tabla.Consultar consulta
tabla.siguiente
'response.Write(consulta)

parte_2_1a = ""
parte_2_1b = ""
parte_2_1c = ""
parte_2_1d = ""
parte_2_1e = ""
parte_2_1f = ""
parte_2_1g = ""
parte_2_1  = tabla.obtenerValor("parte_2_1")
Select Case parte_2_1
Case "1"
    parte_2_1a = "checked"
Case "2"
    parte_2_1b = "checked"
Case "3"
    parte_2_1c = "checked"
Case "4"
    parte_2_1d = "checked"
Case "5"
    parte_2_1e = "checked"
Case "6"
    parte_2_1f = "checked"
Case "0"
    parte_2_1g = "checked"	
End Select

parte_2_2a = ""
parte_2_2b = ""
parte_2_2c = ""
parte_2_2d = ""
parte_2_2e = ""
parte_2_2f = ""
parte_2_2g = ""
parte_2_2  = tabla.obtenerValor("parte_2_2")
Select Case parte_2_2
Case "1"
    parte_2_2a = "checked"
Case "2"
    parte_2_2b = "checked"
Case "3"
    parte_2_2c = "checked"
Case "4"
    parte_2_2d = "checked"
Case "5"
    parte_2_2e = "checked"
Case "6"
    parte_2_2f = "checked"
Case "0"
    parte_2_2g = "checked"	
End Select

parte_2_3a = ""
parte_2_3b = ""
parte_2_3c = ""
parte_2_3d = ""
parte_2_3e = ""
parte_2_3f = ""
parte_2_3g = ""
parte_2_3  = tabla.obtenerValor("parte_2_3")
Select Case parte_2_3
Case "1"
    parte_2_3a = "checked"
Case "2"
    parte_2_3b = "checked"
Case "3"
    parte_2_3c = "checked"
Case "4"
    parte_2_3d = "checked"
Case "5"
    parte_2_3e = "checked"
Case "6"
    parte_2_3f = "checked"
Case "0"
    parte_2_3g = "checked"	
End Select

parte_2_4a = ""
parte_2_4b = ""
parte_2_4c = ""
parte_2_4d = ""
parte_2_4e = ""
parte_2_4f = ""
parte_2_4g = ""
parte_2_4  = tabla.obtenerValor("parte_2_4")
Select Case parte_2_4
Case "1"
    parte_2_4a = "checked"
Case "2"
    parte_2_4b = "checked"
Case "3"
    parte_2_4c = "checked"
Case "4"
    parte_2_4d = "checked"
Case "5"
    parte_2_4e = "checked"
Case "6"
    parte_2_4f = "checked"
Case "0"
    parte_2_4g = "checked"	
End Select

parte_2_5a = ""
parte_2_5b = ""
parte_2_5c = ""
parte_2_5d = ""
parte_2_5e = ""
parte_2_5f = ""
parte_2_5g = ""
parte_2_5  = tabla.obtenerValor("parte_2_5")
Select Case parte_2_5
Case "1"
    parte_2_5a = "checked"
Case "2"
    parte_2_5b = "checked"
Case "3"
    parte_2_5c = "checked"
Case "4"
    parte_2_5d = "checked"
Case "5"
    parte_2_5e = "checked"
Case "6"
    parte_2_5f = "checked"
Case "0"
    parte_2_5g = "checked"	
End Select


parte_2_6a = ""
parte_2_6b = ""
parte_2_6c = ""
parte_2_6d = ""
parte_2_6e = ""
parte_2_6f = ""
parte_2_6g = ""
parte_2_6  = tabla.obtenerValor("parte_2_6")
Select Case parte_2_6
Case "1"
    parte_2_6a = "checked"
Case "2"
    parte_2_6b = "checked"
Case "3"
    parte_2_6c = "checked"
Case "4"
    parte_2_6d = "checked"
Case "5"
    parte_2_6e = "checked"
Case "6"
    parte_2_6f = "checked"
Case "0"
    parte_2_6g = "checked"	
End Select


parte_2_7a = ""
parte_2_7b = ""
parte_2_7c = ""
parte_2_7d = ""
parte_2_7e = ""
parte_2_7f = ""
parte_2_7g = ""
parte_2_7  = tabla.obtenerValor("parte_2_7")
Select Case parte_2_7
Case "1"
    parte_2_7a = "checked"
Case "2"
    parte_2_7b = "checked"
Case "3"
    parte_2_7c = "checked"
Case "4"
    parte_2_7d = "checked"
Case "5"
    parte_2_7e = "checked"
Case "6"
    parte_2_7f = "checked"
Case "0"
    parte_2_7g = "checked"	
End Select

parte_2_8a = ""
parte_2_8b = ""
parte_2_8c = ""
parte_2_8d = ""
parte_2_8e = ""
parte_2_8f = ""
parte_2_8g = ""
parte_2_8  = tabla.obtenerValor("parte_2_8")
Select Case parte_2_8
Case "1"
    parte_2_8a = "checked"
Case "2"
    parte_2_8b = "checked"
Case "3"
    parte_2_8c = "checked"
Case "4"
    parte_2_8d = "checked"
Case "5"
    parte_2_8e = "checked"
Case "6"
    parte_2_8f = "checked"
Case "0"
    parte_2_8g = "checked"	
End Select

parte_2_9a = ""
parte_2_9b = ""
parte_2_9c = ""
parte_2_9d = ""
parte_2_9e = ""
parte_2_9f = ""
parte_2_9g = ""
parte_2_9  = tabla.obtenerValor("parte_2_9")
Select Case parte_2_9
Case "1"
    parte_2_9a = "checked"
Case "2"
    parte_2_9b = "checked"
Case "3"
    parte_2_9c = "checked"
Case "4"
    parte_2_9d = "checked"
Case "5"
    parte_2_9e = "checked"
Case "6"
    parte_2_9f = "checked"
Case "0"
    parte_2_9g = "checked"	
End Select

parte_2_observaciones  = tabla.obtenerValor("parte_2_observaciones")

'set negocio = new CNegocio
'negocio.Inicializa conectar
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title><%=nombre_encuesta%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_alumnos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function volver()
{
   location.href ="seleccionar_docente.asp";
}
function direccionar(valor)
{var cadena;
 var secc_ccod='<%=secc_ccod%>';
 var pers_ncorr_profesor='<%=pers_ncorr_profesor%>';
 location.href="contestar_encuesta2.asp?encu_ncorr="+valor+"&secc_ccod="+secc_ccod+"&pers_ncorr_docente="+pers_ncorr_profesor;
}

function validar_ingreso()
{
  var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor = 7;
  //alert("divisor= "+divisor);
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
    elemento=document.edicion.elements[i];
  	if (elemento.type=="radio")
  		{
		  cant_radios++;
		  if(elemento.checked)
		     {contestada++;}
  		}
  }
  if (contestada==(cant_radios/divisor))
   {
   		document.edicion.submit();
	}
  else
   { 
   		alert("Debe responder todas las preguntas antes de grabar,\n aún faltan preguntas por contestar.");
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
</style>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#CC6600" background="imagenes/fondo.jpg">
<center>
<table align="center" width="700">
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<tr>
		<td width="100%" align="center"><font size="5" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>Cuestionario de Opinión de alumnos</strong></font></td>
	</tr>
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<!--Antecedentes educacionales-->
	<tr>
		<td width="100%" align="left">
			<table width="700" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="98%" border="0" bgcolor="#f7faff">
						<form name="edicion" action="contestar_evaluacion_docente_2_2008_proc.asp" method="post">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="95%"><hr style="color:#4b73a6;"></td>
										   <td width="5%" align="center"><div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#990000"><strong>Paso 2/6</strong></font></div></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="98%" cellpadding="0" cellspacing="0">
									<tr>
										<td width="100%" align="left">
											<div align="justify">
												<font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
													<strong>PARTE II</strong>
												</font>
											</div>
										</td>
									</tr>
									<tr>
										<td width="100%" align="left">&nbsp;</td>
									</tr>
									<tr>
									<td width="100%" align="left">
										<div align="justify">
											<font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												En esta parte del cuestionario encontrarás un conjunto de preguntas referidas a la docencia desarrollada por tu profesor/a en esta asignatura.
											</font>
										</div>
									</td>
									</tr>
									<tr>
										<td width="100%" align="left">&nbsp;</td>
									</tr>
									<tr>
									<td width="100%" align="left">
										<div align="justify">
											<font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												Las preguntas sobre las cuales deberás pronunciarte están agrupadas en conjuntos que hemos denominado dimensiones. Estas son las siguientes: 
												enseñanza para el aprendizaje, evaluación para el aprendizaje, ambiente para el aprendizaje y responsabilidad formal. También estimamos 
												pertinente incluir una dimensión relacionada con el compromiso que tú has tenido con esta asignatura.
												Se te presenta una breve explicación de cada dimensión, el conjunto de preguntas correspondiente a cada 
												una de ellas y un espacio para comentarios si es que estimas conveniente realizarlos.
											</font>
										</div>
									</td>
									</tr>
									<tr>
										<td width="100%" align="left">&nbsp;</td>
									</tr>
									<tr>
										<td width="100%" align="left">
											<div align="justify">
												<font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
													Para responder encontrarás una escala graduada de acuerdo a cada pregunta y deberás seleccionar 
													la opción que consideres mejor refleja tu opinión. La escala de opciones está graduada en forma 
													creciente desde el número 1 al 6. <strong>Si piensas que no puedes opinar, selecciona la última columna, se señala “No se aplica”</strong>.
												</font>
											</div>
										</td>
									</tr>
									<tr>
										<td width="100%" align="left">&nbsp;</td>
									</tr>
									<tr>
										<td width="100%" align="left">
											<div align="justify">
												<font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
													<strong>1º Dimensión Enseñanza para el aprendizaje:</strong> Esta dimensión se refiere a la forma en 
													que el docente desarrolla sus clases. Incluye la comunicación de información sobre el desarrollo del 
													curso, la estructuración de las clases, la claridad en el tratamiento de los temas, entre otros.</strong>
												</font>
											</div>
										</td>
									</tr>
									<tr>
										<td width="100%" align="left">&nbsp;</td>
									</tr>
									<tr>
										<td width="100%" align="center">
											<table width="100%" align="center" cellpadding="0" cellspacing="0" border="1" bordercolor="#4b73a6">
											<tr>
												<td width="50%">&nbsp;</td>
												<td width="10%">&nbsp;</td>
												<td width="4%" align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">1</font></td>
												<td width="4%" align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">2</font></td>
												<td width="4%" align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">3</font></td>
												<td width="4%" align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">4</font></td>
												<td width="4%" align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">5</font></td>
												<td width="4%" align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">6</font></td>
												<td width="10%">&nbsp;</td>
												<td width="6%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">No se aplica</font></td>
											</tr>
											<tr>
												<td width="50%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="justify">
																		1. ¿El/la docente explicó clara y oportunamente los objetivos, metodología y bibliografía a utilizar, al inicio del curso? 
																	</div>
																</font>
												</td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">En forma poco clara y oportuna</font></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_1" value="1" <%=parte_2_1a%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_1" value="2" <%=parte_2_1b%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_1" value="3" <%=parte_2_1c%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_1" value="4" <%=parte_2_1d%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_1" value="5" <%=parte_2_1e%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_1" value="6" <%=parte_2_1f%>></td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">En forma  clara y oportuna</font></td>
												<td width="6%" align="center"><input type="radio" name="parte_2_1" value="0" <%=parte_2_1g%>></td>
											</tr>
											<tr>
												<td width="50%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="justify">
																		2. ¿Qué tan significativas para mi aprendizaje fueron las actividades desarrolladas por el/la docente en clases? 
																	</div>
																</font>
												</td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Muy poco significativas</font></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_2" value="1" <%=parte_2_2a%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_2" value="2" <%=parte_2_2b%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_2" value="3" <%=parte_2_2c%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_2" value="4" <%=parte_2_2d%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_2" value="5" <%=parte_2_2e%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_2" value="6" <%=parte_2_2f%>></td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Muy significativas</font></td>
												<td width="6%" align="center"><input type="radio" name="parte_2_2" value="0" <%=parte_2_2g%>></td>
											</tr>
											<tr>
												<td width="50%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="justify">
																		3. Las clases desarrolladas por el/la docente ¿me dieron la posibilidad de pensar, observar, investigar, practicar y sacar mis propias conclusiones? 
																	</div>
																</font>
												</td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Casi nunca</font></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_3" value="1" <%=parte_2_3a%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_3" value="2" <%=parte_2_3b%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_3" value="3" <%=parte_2_3c%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_3" value="4" <%=parte_2_3d%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_3" value="5" <%=parte_2_3e%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_3" value="6" <%=parte_2_3f%>></td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Muy Frecuentemente</font></td>
												<td width="6%" align="center"><input type="radio" name="parte_2_3" value="0" <%=parte_2_3g%>></td>
											</tr>
											<tr>
												<td width="50%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="justify">
																		4. ¿De qué manera el/la docente respondió las consultas que realizamos en clases?
																	</div>
																</font>
												</td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">En forma poco clara o poco satisfactoria</font></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_4" value="1" <%=parte_2_4a%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_4" value="2" <%=parte_2_4b%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_4" value="3" <%=parte_2_4c%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_4" value="4" <%=parte_2_4d%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_4" value="5" <%=parte_2_4e%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_4" value="6" <%=parte_2_4f%>></td>
												<td width="10%"align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">En forma clara y satisfactoria</font></td>
												<td width="6%" align="center"><input type="radio" name="parte_2_4" value="0" <%=parte_2_4g%>></td>
											</tr>
											<tr>
												<td width="50%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="justify">
																		5. ¿Con qué frecuencia el/la docente relacionó los contenidos tratados con nuestro futuro desempeño profesional?
																	</div>
																</font>
												</td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Casi nunca</font></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_5" value="1" <%=parte_2_5a%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_5" value="2" <%=parte_2_5b%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_5" value="3" <%=parte_2_5c%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_5" value="4" <%=parte_2_5d%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_5" value="5" <%=parte_2_5e%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_5" value="6" <%=parte_2_5f%>></td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Muy frecuentemente</font></td>
												<td width="6%" align="center"><input type="radio" name="parte_2_5" value="0" <%=parte_2_5g%>></td>
											</tr>
											<tr>
												<td width="50%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="justify">
																		6. La forma de organizar los contenidos del curso por el/la docente ¿fue favorable a mi aprendizaje? 
																	</div>
																</font>
												</td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Muy poco favorable</font></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_6" value="1" <%=parte_2_6a%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_6" value="2" <%=parte_2_6b%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_6" value="3" <%=parte_2_6c%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_6" value="4" <%=parte_2_6d%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_6" value="5" <%=parte_2_6e%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_6" value="6" <%=parte_2_6f%>></td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Muy favorable</font></td>
												<td width="6%" align="center"><input type="radio" name="parte_2_6" value="0" <%=parte_2_6g%>></td>
											</tr>
											<tr>
												<td width="50%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="justify">
																		7. Las actividades desarrolladas por el/la docente ¿fueron coherentes con los objetivos de aprendizaje de la asignatura?
																	</div>
																</font>
												</td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Poco coherentes</font></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_7" value="1" <%=parte_2_7a%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_7" value="2" <%=parte_2_7b%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_7" value="3" <%=parte_2_7c%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_7" value="4" <%=parte_2_7d%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_7" value="5" <%=parte_2_7e%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_7" value="6" <%=parte_2_7f%>></td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Muy coherentes</font></td>
												<td width="6%" align="center"><input type="radio" name="parte_2_7" value="0" <%=parte_2_7g%>></td>
											</tr>
											<tr>
												<td width="50%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="justify">
																		8. Las actividades desarrolladas ¿facilitan la innovación y creatividad en el hacer disciplinario?
																	</div>
																</font>
												</td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Casi nunca</font></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_8" value="1" <%=parte_2_8a%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_8" value="2" <%=parte_2_8b%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_8" value="3" <%=parte_2_8c%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_8" value="4" <%=parte_2_8d%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_8" value="5" <%=parte_2_8e%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_8" value="6" <%=parte_2_8f%>></td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Muy frecuentemente</font></td>
												<td width="6%" align="center"><input type="radio" name="parte_2_8" value="0" <%=parte_2_8g%>></td>
											</tr>
											<tr>
												<td width="50%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="justify">
																		9. Me parece que las expectativas del/la docente sobre nuestros aprendizajes son.
																	</div>
																</font>
												</td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Muy bajas</font></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_9" value="1" <%=parte_2_9a%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_9" value="2" <%=parte_2_9b%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_9" value="3" <%=parte_2_9c%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_9" value="4" <%=parte_2_9d%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_9" value="5" <%=parte_2_9e%>></td>
												<td width="4%" align="center"><input type="radio" name="parte_2_9" value="6" <%=parte_2_9f%>></td>
												<td width="10%" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Muy altas</font></td>
												<td width="6%" align="center"><input type="radio" name="parte_2_9" value="0" <%=parte_2_9g%>></td>
											</tr>
											
											</table>
											
										</td>
									</tr>
									<tr>
										<td width="100%" align="left">&nbsp;</td>
									</tr>
									<tr>
										<td width="100%" align="left">
											<div align="justify">
												<font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
													Comentarios, sugerencias u observaciones al docente en esta dimensión:
												</font>
											</div>
										</td>
									</tr>
									<tr>
										<td width="100%" align="left">&nbsp;</td>
									</tr>
									<tr>
										<td width="100%" align="center"><textarea name="parte_2_observaciones" cols="100" rows="6" id="TO-S"><%=parte_2_observaciones%></textarea></td>
									</tr>
									<tr>
										<td width="100%" align="left">&nbsp;</td>
									</tr>
									<tr>
										<td width="100%" align="left">&nbsp;</td>
									</tr>
									<tr>
										<td width="100%" align="center">
											<table width="40%" cellpadding="0" cellspacing="0">
												<tr>
												<td width="34%" align="center">
														<%POS_IMAGEN = 0%>
														<a href="javascript:_Navegar(this, 'contestar_evaluacion_docente_2008.asp', 'FALSE');"
															onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ANTERIOR2.png';return true "
															onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ANTERIOR1.png';return true ">
															<img src="imagenes/ANTERIOR1.png" border="0" width="70" height="70" alt="VOLVER A PAGINA ANTERIOR"> 
														</a>
													</td>
												    <td width="32%" align="center">
														<%POS_IMAGEN = POS_IMAGEN + 1%>
														<a href="javascript:_Navegar(this, 'seleccionar_docente_2008.asp', 'FALSE');"
															onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
															onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true ">
															<img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> 
														</a>
													</td>
													<td width="34%" align="center">
														<%POS_IMAGEN = POS_IMAGEN + 1%>
														<a href="javascript:validar_ingreso();"
															onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SIGUIENTE2.png';return true "
															onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SIGUIENTE1.png';return true ">
															<img src="imagenes/SIGUIENTE1.png" border="0" width="70" height="70" alt="IR A PAGINA SIGUIENTE"> 
														</a>
													</td>
												</tr>
											</table>
										</td>
									</tr>
									</table>
								</td>
							</tr>
						 </form>
						</table>
					</td>
				</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
			</table>
		</td>
	</tr>
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
</table>
</center>
</body>
</html>

