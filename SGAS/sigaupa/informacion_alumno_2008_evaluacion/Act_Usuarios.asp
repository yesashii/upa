<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno_2008.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
rut = request.querystring("busqueda[0][pers_nrut]")
digito = request.querystring("busqueda[0][pers_xdv]")
'-------------------------------------------------------------------

v_pers_nrut=request.QueryString("pers_nrut")

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "Act_Usuarios.xml", "busqueda_usuarios"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' "
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut
 f_busqueda.AgregaCampoCons "pers_xdv", digito
'--------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Act_Usuarios.xml", "botonera"
'--------------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "Act_Usuarios.xml", "f1"
formulario.Inicializar conexion

consulta = "SELECT a.pers_ncorr, a.pers_nrut, a.pers_xdv, protic.fnSplit(a.pers_tfono,'-',1) AS cod_area , isnull(protic.fnSplit(a.pers_tfono,'-',2),a.pers_tfono) AS pers_tfono,protic.fnSplit(a.pers_tcelular,'-',1) AS pre_celu , isnull(protic.fnSplit(a.pers_tcelular,'-',2),a.pers_tcelular)AS pers_tcelular," & vbcrlf & _
			" a.pers_tnombre, a.pers_tnombre as pers_tnombre2,a.pers_tape_paterno, a.pers_tape_paterno as pers_tape_paterno2, a.pers_tape_materno, a.pers_tape_materno as pers_tape_materno2, a.pers_temail,b.dire_tcalle, b.dire_tnro, b.dire_tblock, b.dire_tpoblacion, b.ciud_ccod, " & vbcrlf & _
			"(SELECT top 1 sede_tdesc from alumnos aa, ofertas_academicas bb,sedes cc, especialidades dd, carreras ee " & vbcrlf & _
			"WHERE aa.ofer_ncorr=bb.ofer_ncorr and bb.sede_ccod=cc.sede_ccod and bb.espe_ccod=dd.espe_ccod " & vbcrlf & _
			"and dd.carr_ccod=ee.carr_ccod and aa.emat_ccod <> 9 and aa.pers_ncorr=a.pers_ncorr ORDER BY bb.peri_ccod desc) as sede, " & vbcrlf & _
			"(SELECT top 1 carr_tdesc from alumnos aa, ofertas_academicas bb,sedes cc, especialidades dd, carreras ee " & vbcrlf & _
			"WHERE aa.ofer_ncorr=bb.ofer_ncorr and bb.sede_ccod=cc.sede_ccod and bb.espe_ccod=dd.espe_ccod " & vbcrlf & _
			"and dd.carr_ccod=ee.carr_ccod and aa.emat_ccod <> 9 and aa.pers_ncorr=a.pers_ncorr ORDER BY bb.peri_ccod desc) as carrera " & vbcrlf & _			
			"FROM personas a, direcciones b " & vbcrlf & _
			"WHERE a.pers_ncorr = b.pers_ncorr " & vbcrlf & _ 
			"and b.tdir_ccod = 1 " & vbcrlf & _ 
			"and cast(a.pers_nrut as varchar) = '"&v_pers_nrut&"' "  
						   	
formulario.Consultar consulta
formulario.siguiente
 
%>


<html>
<head>
<title>Actualizar Datos Personal</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_alumnos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript" src="../biblioteca/obtiene_codigo_area.js"></script>
<script language="JavaScript" src="../biblioteca/jquery-1.4.4.min.js"></script>

<script language="JavaScript">

function solonumeros(){
var key=window.event.keyCode;
	if (key < 48 || key > 57){
	window.event.keyCode=0;
	}
}
$(document).ready(function() {
var fono=document.f1.elements["personas[0][pers_tfono]"].value;
    celu=document.f1.elements["personas[0][pers_tcelular]"].value;
if (fono=='V')
{
	document.f1.elements["personas[0][pers_tfono]"].value='';
}
if (celu=='V')
{
	document.f1.elements["personas[0][pers_tcelular]"].value='';
	document.f1.elements["personas[0][pre_tcelu]"].value='';
}

EnmarcararTelefono();

	});
function EnmarcararTelefono()
{
		var ciudad=document.f1.elements["personas[0][ciud_ccod]"].value;
		var val=document.f1.elements["personas[0][pers_tfono]"].value;
		cod_area=ObtenerCodigoCiudad(ciudad)
		document.f1.elements["personas[0][cod_area]"].value=cod_area;
		verificar_numero()
}
function verificar_numero()
{
	
	var ciudad=document.f1.elements["personas[0][ciud_ccod]"].value;
	var val=document.f1.elements["personas[0][pers_tfono]"].value;
	if (ciudad!="")
	{
		total=val.length
		cod_area=ObtenerCodigoCiudad(ciudad)
		lagor_fono=LargoFono(cod_area)
		
		if((total!=lagor_fono)&&(total>0))
		{
			alert("el telefono debe tener "+lagor_fono+" digitos")
			document.f1.elements["personas[0][pers_tfono]"].focus();
			document.f1.elements["personas[0][pers_tfono]"].select()
		}
	}
	
}
function trim(cadena)
{
	for(i=0; i<cadena.length; )
	{
		if(cadena.charAt(i)==" ")
			cadena=cadena.substring(i+1, cadena.length);
		else
			break;
	}

	for(i=cadena.length-1; i>=0; i=cadena.length-1)
	{
		if(cadena.charAt(i)==" ")
			cadena=cadena.substring(0,i);
		else
			break;
	}
	
	return cadena;
}

function verifica_numero_celular_prefijo()
{
	var val=document.f1.elements["personas[0][pers_tcelular]"].value;
	var prefijo=document.f1.elements["personas[0][pre_celu]"].value;
	
	largo_numero_ingresado=val.length
	largo_prefijo=prefijo.length
	
	if 	(((trim(prefijo)=="")&&(largo_numero_ingresado>0))||(largo_prefijo>1))
	{
		alert("Debe ingresar un numero entre 6 y 9")
		document.f1.elements["personas[0][pre_celu]"].focus();
		document.f1.elements["personas[0][pre_celu]"].select()
		return false
		
	}
	else 
	{
		if ((largo_numero_ingresado!=7)&&(largo_numero_ingresado>0))
			{
				alert("El Numero Celular debe tener 7 numeros")
				document.f1.elements["personas[0][pers_tcelular]"].focus();
				document.f1.elements["personas[0][pers_tcelular]"].select()
				return false
			}
	}
	return true;
}

function verifica_numero_celular()
{
var val=document.f1.elements["personas[0][pers_tcelular]"].value;

largo_numero_ingresado=val.length

	if ((largo_numero_ingresado!=7)&&(largo_numero_ingresado>0))
		{
			alert("El Numero Celular debe tener 7 numeros")
			document.f1.elements["personas[0][pers_tcelular]"].focus();
			document.f1.elements["personas[0][pers_tcelular]"].select()
			return false
		}
return true;
}

function validar_fono_celu()
{
	valor=verifica_numero_celular_prefijo();
	valor2=verifica_numero_celular();
	if ((valor==true)&&(valor2==true))
	{
		salida= true;
	}
	else
	{
		salida= false;
	}
	return salida;

}

function SoloNumerosNueveOchoSieteSeis(){
var key=window.event.keyCode;
	if (key < 54 || key > 57){
	window.event.keyCode=0;
	}
}

function validar_ingreso()
{
  var formulario = document.f1;
  if((formulario.elements["personas[0][pers_tfono]"].value !="")||(formulario.elements["personas[0][pers_tcelular]"].value !=""))
   {
    	_Guardar(this, document.forms['f1'], 'Act_Usuarios_Actualizar_proc.asp','', '', '', 'FALSE');
   }
   else
   {
       alert("Debes ingresar un número de teléfono fijo o celular, antes de grabar");
   }


}


</script>

</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#CC6600" background="imagenes/fondo.jpg">
<center>
<table align="center" width="700">
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<tr>
		<td width="100%" align="center"><font size="5" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>Actualización de Datos Personales</strong></font></td>
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
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="22%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Datos Personales </strong></font></td>
										   <td width="68%"><hr></td>
										    <TD width="10%">
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
									 <form action="actualizar.asp" method="post" name="f1">
									   <tr>
										  <td width="3%">&nbsp;</td>
										  <td height="40" width="94%"><div align="center"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#CC0000">ESTIMADO (A) ALUMNO (A): CON EL FIN DE MEJORAR LA COMUNICACIÓN Y ENTREGARTE  OPORTUNAMENTE INFORMACIÓN RELACIONADA CON LOS BENEFICIOS DE LA UNIVERSIDAD, AGRADECEREMOS REVISAR Y ACTUALIZAR TUS DATOS PERSONALES.<br><br>UNA VEZ ACTUALIZADOS TUS DATOS, PODRÁS INGRESAR A TU TOMA DE RAMOS ONLINE.</font></b></div></td>
										  <td width="3%">&nbsp;</td>
										</tr>
										<tr>
										  <td>&nbsp;</td>
                          				  <td>
										      <table width="100%" cellpadding="0" cellspacing="0" border="0">
											  <tr>
												<td>&nbsp;</td>
												<td height="30" colspan="3"><div align="justify"><font size="2"><strong>&nbsp;</strong></font></div></td>
											  </tr>
											  <tr valign="middle">
												<td width="4%" height="22">&nbsp;</td>
												<td width="20%" height="22" align="left"><font color="#FF0000">*</font> <font>RUT del postulante</font></td>
												<td height="22">:</td>
												<td height="22">
												  <table width="100%" border="0" cellspacing="0" cellpadding="0">
													<tr>
													  <td>
													  <% formulario.DibujaCampo("pers_ncorr") %>
													  <%' formulario.DibujaCampo("audi_tusuario") %>
													  <% 'formulario.DibujaCampo("audi_fmodificacion") %>													  
													  <% formulario.DibujaCampo("pers_nrut") %>													  
													  -<% formulario.DibujaCampo("pers_xdv") %>
 													  </td>
													</tr>
												</table></td>
											  </tr>
											  <tr>
												<td height="10">&nbsp;</td>
												<td width="20%" height="15" valign="top">&nbsp;</td>
												<td height="10">&nbsp;</td>
												<td height="10">&nbsp;</td>												  
											  </tr>
											  <tr>
												<td height="22">&nbsp;</td>
												<td width="20%" height="22" align="left"><font color="#FF0000">*</font><font>Nombre Completo</font> </td>
												<td height="22">:</td>
												<td height="22">
												  <table width="100%" border="0" cellspacing="0" cellpadding="0">
													<tr>
													  <% formulario.DibujaCampo("pers_tape_paterno") %>
													  <% formulario.DibujaCampo("pers_tape_materno") %>
													  <% formulario.DibujaCampo("pers_tnombre") %>
													  <% formulario.DibujaCampo("pers_tnombre2") %>&nbsp;&nbsp;
													  <% formulario.DibujaCampo("pers_tape_paterno2") %>&nbsp;&nbsp;
													  <% formulario.DibujaCampo("pers_tape_materno2") %>
													</tr>
												</table></td>
											  </tr>
											  <tr>
												<td height="10">&nbsp;</td>
												<td width="20%" height="10">&nbsp;</td>
												<td height="10">&nbsp;</td>
												<td height="10">&nbsp;</td>
											  </tr>
											  <tr>
												<td height="22">&nbsp;</td>
												<td width="20%" height="22" align="left"><font color="#FF0000">*</font><font>Carrera</font></td>
												<td height="22">:</td>
												<td height="22" align="left"> <% formulario.DibujaCampo("carrera") %> </td>
											  </tr>
											  <tr>
												<td height="10">&nbsp;</td>
												<td width="20%" height="10">&nbsp;</td>
												<td height="10">&nbsp;</td>
												<td height="10">&nbsp;</td>
											  </tr>
											  <tr>
												<td height="22">&nbsp;</td>
												<td width="20%" height="22" align="left"><font color="#FF0000">*</font><font>Sede/Campus</font></td>
												<td height="22">:</td>
												<td height="22" align="left"> <% formulario.DibujaCampo("sede") %> </td>
											  </tr>
											  <tr>
												<td height="10">&nbsp;</td>
												<td width="20%" height="10">&nbsp;</td>
												<td height="10">&nbsp;</td>
												<td height="10">&nbsp;</td>
											  </tr>
											  <tr>
												<td height="22">&nbsp;</td>
												<td width="20%" height="22" align="left"><font color="#FF0000">*</font><font>Dirección</font></td>
												<td height="22">:</td>
												<td height="22" align="left"> <% formulario.DibujaCampo("dire_tcalle") %></td>
											  </tr>
											  <tr>
												<td height="10">&nbsp;</td>
												<td width="20%" height="10">&nbsp;</td>
												<td height="10">&nbsp;</td>
												<td height="10">&nbsp;</td>
											  </tr>
											  <tr>
												<td height="10">&nbsp;</td>
												<td width="20%" height="25" valign="top">
												  <div align="center">&nbsp;&nbsp;</div></td>
												<td height="10">&nbsp;</td>
												<td height="10" valign="top" align="left">
												  <table width="80%" border="0" cellspacing="0" cellpadding="0">
													<tr>
													  <td width="33%" align="center"><font color="#FF0000">*</font><font>Número</font></td>
													  <td width="33%" align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Departamento</font></td>
													  <td width="34%" align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Condominio</font></td>
													</tr>
													<tr>
													  <td width="33%" align="center"> <% formulario.DibujaCampo("dire_tnro") %></td>
													  <td width="33%" align="center"> <% formulario.DibujaCampo("dire_tblock") %></td>
													  <td width="34%" align="center"> <% formulario.DibujaCampo("dire_tpoblacion") %></td>
													</tr>
												</table></td>
											  </tr>
											  <tr>
												<td height="10">&nbsp;</td>
												<td width="20%" height="10">&nbsp;</td>
												<td height="10">&nbsp;</td>
												<td height="10">&nbsp;</td>
											  </tr>
											  <tr>
												<td height="22">&nbsp;</td>
												<td width="20%" height="22" align="left"><font color="#FF0000">*</font><font>Comuna</font></td>
												<td height="22">:</td>
												<td height="22" align="left">
												<% formulario.DibujaCampo("ciud_ccod") %>																			
												</td>
											  </tr>
											  <tr>
												<td height="10">&nbsp;</td>
												<td width="20%" height="10">&nbsp;</td>
												<td height="10">&nbsp;</td>
												<td height="10">&nbsp;</td>
											  </tr>
											  <tr>
												<td height="22">&nbsp;</td>
												<td width="20%" height="22" align="left"><font color="#FF0000">*</font><font>Correo Electr&oacute;nico</font></td>
												<td height="22">:</td>
												<td height="22" align="left"> <% formulario.DibujaCampo("pers_temail") %>&nbsp;&nbsp;Ej: juanperez@mail.cl</td>
											  </tr>
											  <tr>
												<td height="10">&nbsp;</td>
												<td width="20%" height="10">&nbsp;</td>
												<td height="10">&nbsp;</td>
												<td height="10">&nbsp;</td>
											  </tr>
											  <tr>
												<td height="22">&nbsp;</td>
												<td width="20%" height="22" align="left"><font color="#FF0000">*</font><font>Tel&eacute;fono de Contacto</font></td>
												<td height="22">:</td>
												<td height="22" align="left"> <% formulario.DibujaCampo("cod_area") %>-<% formulario.DibujaCampo("pers_tfono") %>&nbsp;(Formato: Cod. &Aacute;rea - N&uacute;mero)</td>
											  </tr>
											  <tr>
												<td height="10">&nbsp;</td>
												<td width="20%" height="10">&nbsp;</td>
												<td height="10">&nbsp;</td>
												<td height="10">&nbsp;</td>
											  </tr>
											  <tr>
												<td height="22">&nbsp;</td>
												<td width="20%" height="22" align="left"><font color="#FF0000">*</font><font>Celular</font></td>
												<td height="22">:</td>
												<td height="22" align="left"> <% formulario.DibujaCampo("pre_celu") %> - <% formulario.DibujaCampo("pers_tcelular") %> &nbsp;(Ej: 7-1234567)</td>
											  </tr>											  
											  <tr>
												<td height="10">&nbsp;</td>
												<td width="20%" height="10">&nbsp;</td>
												<td height="10">&nbsp;</td>
												<td height="10">&nbsp;</td>
											  </tr>	 
											  <tr>
											    <td colspan="4" align="center"><%' botonera.DibujaBoton("guardar") %>
												  <table width="40%" cellpadding="0" cellspacing="0">
												<tr>
												    <td width="50%" align="center">
														<%POS_IMAGEN = POS_IMAGEN + 1%>
														<a href="javascript:_Navegar(this, '../portada_alumno_2008b/portada_alumno.asp', 'FALSE');"
															onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
															onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true ">
															<img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> 
														</a>
													</td>
													<td width="50%" align="center">
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
										  </table></td>
										  <td>&nbsp;</td>
										</tr>
									 </form> 
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
</table>
</center>

<!--
<TABLE id=Table1 cellSpacing=0 cellPadding=0 width="750" border=0>
	  <TBODY>
	     <TR valign="top">
		   <td align="center" bgColor="#0000" width="800">
				<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
					<tr>
					  <td> 
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
							  <td width="9" align="left" background="img/izq.jpg">&nbsp;</td>
							  <td bgcolor="#FFFFFF">
								&nbsp;
								<div align="right"><font color="#FF0000"><b>*</b></font><b> Campos Obligatorios</b><br>
								</div>
				    			<form action="actualizar.asp" method="post" name="f1">
								  <blockquote>
								     <table width="90%" border="0" cellspacing="0" cellpadding="0">
										
										
										<tr valign="bottom">
										   <td colspan="3" align="right">&nbsp;</td>
									    </tr>
									  </table>
								  </blockquote>
								</form>
							  <br>				  </td>
							</tr>
						</table>
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
							  <td width="182" bgcolor="#FFFFFF"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
								<tr>
								  <td><div align="center"><% botonera.DibujaBoton("guardar") %></div></td>
								  <td><div align="center"><% botonera.DibujaBoton("continuar") %></div></td>
								</tr>
							  </table>                    
							  </td>
							  <td width="174" rowspan="2" background="img/abajo_r1_c4.jpg" align="left"><img src="img/abajo_r1_c3.jpg" width="12" height="28"></td>
							  <td width="310" rowspan="2" align="right" background="img/abajo_r1_c4.jpg"><img src="img/abajo_r1_c5.gif" width="7" height="28"></td>
							</tr>
							<tr>
							</tr>
						</table>
						<p><br>
					  </td>
					</tr>
				  </table>	      
		  </td>
		 </TR>		
 	   </TBODY>
	</TABLE>-->
</body>
</html>
