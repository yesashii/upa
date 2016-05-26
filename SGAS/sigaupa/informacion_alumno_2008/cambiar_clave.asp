<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno_2008.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<% 
'------------------------------------------------------
matr_ncorr = Request.QueryString("enca[0][carreras_alumno]")

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
 
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
if esVacio(q_pers_nrut) then
	 q_pers_nrut = negocio.obtenerUsuario
	 q_pers_xdv = conexion.consultaUno("Select pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
end if

q_peri_ccod = "210"


set f_botonera = new CFormulario
f_botonera.Carga_Parametros "cambiar_clave.xml", "botonera"

Usuario = q_pers_nrut

'---------------------------------------------------------------------------------------------------
set f_datos = new CFormulario
f_datos.Carga_Parametros "cambiar_clave.xml", "f_datos"
f_datos.Inicializar conexion

  sql = "SELECT a.pers_ncorr, a.susu_tlogin, upper(a.susu_tclave) as susu_tclave, '' as anterior,  '' as nueva,  '' as confirmacion, "&_ 
              "protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre "&_
        "FROM sis_usuarios a, personas b "&_
        "WHERE a.pers_ncorr = b.pers_ncorr "&_
          "AND b.pers_nrut ='" & Usuario & "'"

f_datos.Consultar sql
f_datos.Siguiente

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Administración de clave de acceso</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function Validar()
 {
    formulario = document.edicion;
	original = formulario.elements["datos[0][susu_tclave]"].value;	
	anterior = formulario.elements["datos[0][anterior]"].value;	
	nueva = formulario.elements["datos[0][nueva]"].value;	
	confirmacion = formulario.elements["datos[0][confirmacion]"].value;	

    if (anterior.toUpperCase() != original.toUpperCase())
	 {
	    alert('Su clave anterior no es correcta');
		formulario.elements["datos[0][anterior]"].focus();
		formulario.elements["datos[0][anterior]"].select();
		return false;
	 }
	else
	  if (nueva.toUpperCase() != confirmacion.toUpperCase())
       {
		  alert('La clave de confirmación no coincide con la clave nueva.');
		  formulario.elements["datos[0][confirmacion]"].focus();
		  formulario.elements["datos[0][confirmacion]"].select();
		  return false;
	   }	  		
	
	return true;   
 }
function ayuda (valor)
{ var mensaje="";
    mensaje = "AYUDA\nEsta función permite que el alumno administre su clave de acceso al sistema de gestión, para ello debe: \n\n" +
	       	  "- Ingresar clave antigua de acceso (solo con el fin de validación).\n"+
			  "- Ingresar nueva clave y replicarla para confirmar.\n"+
			  "- Presionar el botón guardar para actualizar sus datos y cambiar clave.\n"+
			  "\n\nLos cambios en claves de acceso son de estricta responsabilidad de los alumnos.";
		   
	alert(mensaje);
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
		<td width="100%" align="center"><font size="5" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>Administración de claves de acceso</strong></font></td>
	</tr>
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<!--Antecedentes educacionales-->
	<tr>
		<td width="100%" align="center">
			<table width="550" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="98%" border="0" bgcolor="#f7faff">
						<form name="edicion" action="notas_alumno.asp">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="60%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Administraci&oacute;n de claves de acceso</strong></font></td>
										   <td width="27%"><hr></td>
										   <TD width="13%">
										   		<%POS_IMAGEN = 0%>
										   		<a href="javascript:ayuda(1)"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda2.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda1.png';return true ">
												<img src="imagenes/ayuda1.png" border="0" width="38" height="38" alt="¿Cómo funciona?"> 
												</a>
											</TD>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
									  <tr> 
										<td width="5%" height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Rut</strong></font></td>
										<td width="25%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%f_datos.dibujaCampo("rut") %></font></td>
										<td width="11%" height="20" align="right"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Nombre</strong></font></td>
										<td width="59%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%f_datos.dibujaCampo("nombre") %></font></td>
									  </tr>
									  <tr><td height="20" colspan="4">&nbsp;</td></tr>
									  <tr>
									       <td height="20" colspan="4" align="center">
									  			<table width="95%" border="1" bordercolor="#496da6">
													<tr><td align="center">
																		 <table width="100%" border="0">
																		 <tr>
																		    <td align="center" width="80"><img width="80" height="80" src="imagenes/llaves.gif" border="0"></td>
																		    <td align="left">
																				<table width="100%" cellpadding="0" cellspacing="0">
																					<tr>
																						<td width="35%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Login</strong></font></td>
																						<td width="65%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><% f_datos.dibujaCampo "susu_tlogin" %></font><% f_datos.dibujaCampo "pers_ncorr" %></td>
																					</tr>
																					<tr>
																						<td width="35%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Clave Anterior</strong></font></td>
																						<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><% f_datos.dibujaCampo "anterior" %> <% f_datos.dibujaCampo "susu_tclave" %> </font></td>
																					</tr>
																					<tr>
																						<td width="35%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Nueva Clave</strong></font></td>
																						<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><% f_datos.dibujaCampo "nueva" %>&nbsp;(max. 8 caracteres)</font></td>
																					</tr>
																					<tr>
																						<td width="35%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Confirme Clave</strong></font></td>
																						<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><% f_datos.dibujaCampo "confirmacion" %></font></td>
																					</tr>
																				</table>
																			</td>
																		 </tr>
																		 </table>
													
													</td>
												</tr>
											 </table>
									       </td>
									  </tr>
									  <tr><td height="20" colspan="4">&nbsp;</td></tr>
									  <tr> 
										<td height="10">&nbsp;</td>
										<td height="10" align="right">
															<%POS_IMAGEN = POS_IMAGEN + 2%>
															<a href="javascript:_Guardar(this, document.forms['edicion'], 'proc_cambiar_clave.asp','', 'Validar();', '', 'FALSE');"
																onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/GUARDAR2.png';return true "
																onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/GUARDAR1.png';return true ">
																<img src="imagenes/GUARDAR1.png" border="0" width="70" height="70" alt="Guardar nueva Clave"> 
															</a>
										
										</td>
										<td height="10" align="left"> 
										                    <%POS_IMAGEN = POS_IMAGEN + 1%>
															<a href="javascript:_Navegar(this, 'mensajes.asp', 'FALSE');"
																onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
																onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true ">
																<img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> 
															</a>
										</td>
										<td height="10">&nbsp;</td>
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

