<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Regulación de Formación general optativa"


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
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
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
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
                    <tr> 
                      <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                      <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                      <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                      <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
                      <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                      <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td width="15" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                            <td width="210" valign="bottom" background="../imagenes/fondo1.gif"> 
                              <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Actualización Datos Personales</font></div></td>
                            <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                            <td width="423" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                          </tr>
                        </table></td>
                      <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                      <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                      <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
                    </tr>
                  </table>
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                      <td bgcolor="#D8D8DE" align="center">
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
											    
                                    <td colspan="4" align="right">
                                      <% botonera.DibujaBoton("guardar") %>
                                    </td>
											  </tr>
										  </table></td>
										  <td>&nbsp;</td>
										</tr>
									 </form> 
								    </table>
					  </td>
                      <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                      <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                      <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
      </tr>
    </table>	
	<br>		
</td>
</tr>
</table>
</body>
</html>
