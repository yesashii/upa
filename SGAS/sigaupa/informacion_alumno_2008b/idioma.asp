<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<% 
'------------------------------------------------------
 q_npag	= Request.QueryString("npag")
 traspaso 	= Request.QueryString("traspaso")
 if traspaso = "" then
 	tipo_traspaso="0"
 else
 	tipo_traspaso="1"
 end if	

 
 set conexion = new CConexion
 conexion.Inicializar "upacifico"
 set errores = new CErrores

 set negocio = new CNegocio
 negocio.Inicializa conexion

  q_idal_ncorr = Request.QueryString("idal_ncorr")
 
    'response.write(q_idio_ncorr)
	
  if esVacio(q_pers_nrut) then
	 q_pers_nrut = negocio.obtenerUsuario
	 q_pers_xdv = conexion.consultaUno("Select pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
  end if

 
 periodo_actual = "226"

 '-- Botones de la pagina -----------

 

 
 set f_idioma = new CFormulario
 f_idioma.Carga_Parametros "curriculum_alumno.xml", "idioma"
 f_idioma.Inicializar conexion
				if q_idal_ncorr<> "" then
				 idiomauestra=	"select a.idio_ccod,idal_habla,idal_lee,idal_escribe,a.nidi_ccod,nidi_tdesc,idio_tdesc,idal_otro from idioma_alumno a,niveles_idioma b,idioma c where idal_ncorr="&q_idal_ncorr&""
				 
else
 			idiomauestra="select '' "
end if
	f_idioma.Consultar idiomauestra
 f_idioma.Siguiente

 '------------------------------------------------------------------------------------------ 


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Idoma</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_alumnos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

function mensaje(){
	<%if es_alumno = 0 then%>
	alert('La persona ingresada no se ha matriculado en el período académico actual.')
	<%end if%>
}

function irPagina2(){
	window.location = '<%=dir_JS%>';
}
function salir_aplicacion(){
    
	 window.close();
}
function ayuda (valor)
{ var mensaje="";
    mensaje = "AYUDA\nLa Ficha de antecedentes personales, le entrega información al alumnado de cuales son los datos que tenemos registrados en el sistema;\n" +
	       	  "Datos que deben ser corroborados por cada alumno y en caso de presentar alguna anomalía o que requiera ser cambiado, rogamos comunicarse con departamento de registro curricular\n"+
		      "Los botones de esta función permiten navegar entre las dos páginas, para ver datos personales, domicilios, datos académicos y familiares.\n"+
		      "En una futura versión se pretende desarrollar la opción para que el alumno modifique sus datos directamente desde cualquier PC conectado a Internet.";
		   
		   
	alert(mensaje);
}


function verifica(valor)
{
//alert("valor "+valor);
	if (valor =='8')
	{
		
		document.idioma.elements["idio[0][idal_otro]"].disabled=false;	
		
	}
	else
	{
		
		document.idioma.elements["idio[0][idal_otro]"].disabled=true;
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


<form name="idioma">
<input type="hidden" name="idio[0][pers_nrut]" value="<%=q_pers_nrut%>">
<input type="hidden" name="idio[0][idal_ncorr]" value="<%=q_idal_ncorr%>">
<table align="center" width="700">
	
	
	
	

	
	
	<tr>
		<td width="100%" align="left">
			<table width="551" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6" align="center">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="98%" border="0" bgcolor="#f7faff">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="40%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Idioma</strong></font></td>
										   <td><hr></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="97%" border="0" cellpadding="1" cellspacing="3">
									  <tr> 
										<td width="174" height="20">&nbsp;</td>
										<td width="99"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>&nbsp;</strong></font></td>
										<td width="119"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>&nbsp;</strong></font></td>
									    <td width="103" height="38">
										        <%POS_IMAGEN = 0%>
								        <a href="javascript:ayuda(1)"
												onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda2.png';return true "
												onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda1.png';return true "><img src="imagenes/ayuda1.png" border="0" width="38" height="38" alt="¿Cómo funciona?"></a></td>
									  </tr>
									  <tr> 
										<td height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Idioma :</strong></font></td>
										<td colspan="3"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Nivel :</strong></font></td>
									  </tr>
									  <tr valign="top"> 
											<td height="20"> 
												 <table width="98%" border="0" cellpadding="0" cellspacing="0" >
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" ><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_idioma.dibujaCampo("idio_ccod")%></font></td>
													</tr>
											  </table>											</td>
											<td colspan="3">
												 <table width="45%" border="0" cellpadding="0" cellspacing="0" >
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" ><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_idioma.dibujaCampo("nidi_ccod")%></font></td>
													</tr>
											  </table>											</td>
									  </tr>
									    <tr> 
										<td height="10">&nbsp;</td>
										
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td width="103" height="10">&nbsp;</td>
									  </tr>
                                      <tr> 
										<td height="10"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Especificar Otro </strong></font></td>
										
										<td height="10"><%=f_idioma.dibujaCampo("idal_otro")%></td>
										<td height="10">&nbsp;</td>
										<td width="103" height="10">&nbsp;</td>
									  </tr>
									    <tr> 
										<td height="10">&nbsp;</td>
										
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td width="103" height="10">&nbsp;</td>
									  </tr>
									  <tr> 
										<td height="23" colspan="1"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Habla :</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Lee:</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Escribe :</strong></font></td>
										<td></td>
									  </tr>
									  <tr valign="top"> 
											<td height="20" colspan="1"> 
												 <table width="18%" border="0" cellpadding="0" cellspacing="0">
													<tr> 
													 <td height="20" bordercolor="#CCCCCC" ><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_idioma.dibujaCampo("idal_habla")%></font></td>
													</tr>
											  </table>											</td>
											<td>
												 <table width="18%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													 <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_idioma.dibujaCampo("idal_lee")%></font></td>
													</tr>
											  </table>											</td>
											<td>
												 <table width="28%" border="0" cellpadding="0" cellspacing="0" >
													<tr> 
													   <td height="20" bordercolor="#CCCCCC" ><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_idioma.dibujaCampo("idal_escribe")%></font></td>
													</tr>
											  </table>		
	  									</td>
																				<td>
												 <table width="28%" border="0" cellpadding="0" cellspacing="0" >
													<tr> 
													   <td height="20" bordercolor="#CCCCCC" ></td>
													</tr>
											  </table>		
											  									</td>
									  </tr>
									   <tr valign="top"> 
											<td height="20" colspan="1"> 
												 <table width="18%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr>													</tr>
											  </table>											</td>
											<td>
												 <table width="18%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr>													</tr>
											  </table>											</td>
											<td>
												 <table width="28%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr>													</tr>
											  </table>											</td>
									  </tr>
                                      <tr> 
										 <td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
									  </tr>
									    <tr> 
										
										<td height="10">&nbsp;</td>
										<td height="10" colspan="2"><hr></td>
									  </tr>
						
                                      <tr> 
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10" align="right">
															<%POS_IMAGEN = POS_IMAGEN + 1%>
															<a href="javascript:_Guardar(this, document.forms['idioma'], 'proc_idioma.asp','', '', '', 'FALSE');"
																onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/GUARDAR2.png';return true "
																onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/GUARDAR1.png';return true ">
																<img src="imagenes/GUARDAR1.png" border="0" width="70" height="70" alt="Guardar nuevo Idioma"> 
															</a>
										
										</td>
										<td height="10" align="left"> 
										                    <%POS_IMAGEN = POS_IMAGEN + 1%>
															<a href="javascript:_Navegar(this, 'curriculum.asp?npag=2', 'FALSE');"
																onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
																onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true ">
																<img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> 
															</a>
										</td>
									  </tr>
								  </table>
                  
								</td>
							</tr>
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

	<tr>
		<td width="100%" align="left">
			
		</td>
	</tr>
</table>
</form>
</center>
</body>
</html>

