<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/revisa_session_registro_empresa.asp" -->
<% 
'------------------------------------------------------

 set conexion = new CConexion
 conexion.Inicializar "upacifico"
 set errores = new CErrores

 set negocio = new CNegocio
 negocio.Inicializa conexion

  q_rut =Request("daem[0][rut]")
  q_dv=Request("daem[0][dv]")

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
 if q_rut <>"" then
	existe=conexion.consultaUno("select count(*) from empresas where empr_nrut="&q_rut&"")
	
	exiete_empre_daem=conexion.consultaUno("select count(*)from empresas a,datos_empresa b where empr_nrut="&q_rut&" and a.empr_ncorr=b.empr_ncorr")

else
existe=99
exiete_empre_daem=99
end if
 'response.write(exiete_empre_daem)
   set f_datos_empresa = new CFormulario
 f_datos_empresa.Carga_Parametros "empresa.xml", "f_datos_empresas"
 f_datos_empresa.Inicializar conexion
 
				if q_rut ="" then	
				 selec_antecedentes="select ''"
				 else
				 
				 if existe=1 then
				selec_antecedentes="select empr_ncorr,empr_tnombre,empr_trazon_social,empr_nrut ,empr_xdv,isnull(b.ciud_ccod,0)as ciud_ccod,isnull(regi_ccod,0)as regi_ccod,dire_tcalle,dire_tnro,dire_tdepto,isnull(pais_ccod,0)as pais_ccod"& vbCrLf &_
				"from empresas a, direcciones b,ciudades c,personas d"& vbCrLf &_
				"where a.empr_ncorr=b.pers_ncorr"& vbCrLf &_
				"and empr_nrut="&q_rut&""& vbCrLf &_
				"and tdir_ccod=1"& vbCrLf &_
				"and a.empr_ncorr=d.pers_ncorr"& vbCrLf &_
				"and b.ciud_ccod=c.ciud_ccod"
				
				else
				selec_antecedentes="select "&q_rut&" as rut,'"&q_dv&"' as rut"
				end if
				 end if
 f_datos_empresa.Consultar selec_antecedentes
 f_datos_empresa.Siguiente
f_datos_empresa.AgregaCampoCons "rut",q_rut
f_datos_empresa.AgregaCampoCons "dv",q_dv
f_datos_empresa.AgregaCampoCons "rut2",q_rut
f_datos_empresa.AgregaCampoCons "dv2",q_dv
'-----------------------------------------------------------------------------------------------
consulta_ciudades = "select regi_ccod, ciud_ccod, ciud_tdesc, ciud_tcomuna from ciudades order by ciud_tdesc asc"

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

function mensaje(){
	<%if es_alumno = 0 then%>
	alert('La persona ingresada no se ha matriculado en el período académico actual.')
	<%end if%>
}

function irPagina2(){
	window.location = '<%=dir_JS%>';
}

function salir_aplicacion(){
    var tipo_traspaso = '<%=tipo_traspaso%>';
	if (tipo_traspaso=='0')
	 {window.location = '../lanzadera/lanzadera.asp';}
	else
	 {window.close();} 
}
function ayuda (valor)
{ var mensaje="";
    mensaje = "AYUDA\nAqui debes ingresar los datos de tu empresa";
		   
	alert(mensaje);
}

function InicioPagina()
{
var a;
a=<%=exiete_empre_daem%>;
	
if (a==0)
{
	_FiltrarCombobox(document.empresa.elements["daem[0][ciud_ccod]"], 
	                 document.empresa.elements["daem[0][regi_ccod]"].value,
					 d_ciudades,
					 'regi_ccod',
					 'ciud_ccod',
					 'ciud_tdesc',
					 '<%=f_datos_empresa.ObtenerValor("ciud_ccod")%>');
					 bloquea();
					
}					 
else
{

}				 
}
function Validar_rut(rut,dv)
{
	formulario = document.empresa;
	rut_alumno = formulario.elements[rut].value + "-" + formulario.elements[dv].value;
	if (formulario.elements[rut].value  != ''){
	  	  if (!valida_rut(rut_alumno)) {
		  alert("Ingrese un RUT válido");
		document.empresa.elements[rut].focus;
	 	document.empresa.elements[rut].select();
		return false;
	  }
	 else
	 {
	 	return true;
	 }
	}

	//return true;
	
}

function enviar()
{
	valido=Validar_rut("daem[0][rut]","daem[0][dv]");
	
	if (valido!=false)
	{
		document.empresa.submit();

	}
}


function bloquea()
{var a;
a=<%=existe%>;
if (a=='1')
	{
		
		document.empresa.elements["daem[0][empr_tnombre]"].disabled=true;
		document.empresa.elements["daem[0][empr_trazon_social]"].disabled=true;	
		document.empresa.elements["daem[0][dire_tcalle]"].disabled=true;
		document.empresa.elements["daem[0][dire_tdepto]"].disabled=true;
		document.empresa.elements["daem[0][dire_tnro]"].disabled=true;
		document.empresa.elements["daem[0][regi_ccod]"].disabled=true;
		document.empresa.elements["daem[0][ciud_ccod]"].disabled=true;
		document.empresa.elements["daem[0][pais_ccod]"].disabled=true;
		
	}
	else
	{
			
		document.empresa.elements["daem[0][empr_tnombre]"].disabled=false;
		document.empresa.elements["daem[0][empr_trazon_social]"].disabled=false;
		document.empresa.elements["daem[0][dire_tcalle]"].disabled=false;
		document.empresa.elements["daem[0][dire_tnro]"].disabled=false;
		document.empresa.elements["daem[0][dire_tdepto]"].disabled=false;
		document.empresa.elements["daem[0][regi_ccod]"].disabled=false;
		document.empresa.elements["daem[0][ciud_ccod]"].disabled=false;
		document.empresa.elements["daem[0][pais_ccod]"].disabled=false;
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
.Estilo1 {
	color: #FF0000;
	font-weight: bold;
}
</style>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#CC6600" background="imagenes/fondo.jpg" onLoad= "InicioPagina();">
 <form name="empresa">
 <input type="hidden" name="daem[0][rut2]" value="<%=q_rut%>">
<input type="hidden" name="daem[0][dv2]" value="<%=q_dv%>">
<center>

  <table width="793" height="705" align="center">
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<tr>
		<td width="100%" align="center"><font size="5" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>FICHA DE EMPRESAS </strong></font></td>
	</tr>
	<tr valign="top">
		<td width="100%" height="623" align="left">
			<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="97%" border="0" bgcolor="#f7faff">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										<%if exiete_empre_daem<>99 then%>
										   <td width="139"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Datos Empresa </strong></font></td>
										   <%else%>
										    <td width="139"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Ingrese Rut </strong></font></td>
											<%end if%>
									      <td width="535"><hr></td>
										   <td width="39" height="38">
										        <%POS_IMAGEN = 0%>
										   		<a href="javascript:ayuda(1)"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda2.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda1.png';return true ">
												
										  <img src="imagenes/ayuda1.png" border="0" width="38" height="38" alt="¿Cómo funciona?">												</a>										   </td>
										</tr>
									</table>								
							  </td>
							</tr>
							<%if exiete_empre_daem >0 then%>
							<tr>
							  <td width="100%" align="center"><table width="99%" height="133" border="0" cellpadding="1" cellspacing="3">
                                <tr>
                                  <td colspan="3"><table width="187%" border="0" cellpadding="0" cellspacing="0" bgcolor="#f7faff">
                                      <tr>
                                        <td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Rut Empresa  :</strong></font></td>
                                      </tr>
                                  </table></td>
                                </tr>
                                <tr valign="top">
								<td colspan="3"><table width="187%" border="0" cellpadding="0" cellspacing="0" bgcolor="#f7faff">
                                      <tr>
                                        <td><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_empresa.dibujaCampo("rut")%>-<%=f_datos_empresa.dibujaCampo("dv")%></font></td>
                                      </tr>
                                  </table></td>
                                  
                                  
                                </tr>
								<%if exiete_empre_daem=99 then%>
                                <tr>
                                  <td width="20%" height="10" align="right">
								  <%POS_IMAGEN = POS_IMAGEN + 1%>
								  <a href="javascript:enviar();"
											onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/CONTINUAR_22.png';return true "
												onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/CONTINUAR_21.png';return true "> <img src="imagenes/CONTINUAR_21.png" border="0"  alt="VOLVER AL HOME"></a></td>
                                  <td width="74%" height="10">
								   <%POS_IMAGEN = POS_IMAGEN + 1%>
								  <a href="javascript:_Navegar(this, 'portada_registro_empresa.asp', 'FALSE');"
												onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
												onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true "> <img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> </a></td>
                                  <td width="6%" height="10">&nbsp;</td>
                                </tr>
								<%end if%>
								</table>
							  </td>
										</tr>
							
							
							<tr>
							  <td width="100%" align="center"><table width="99%" border="0" cellpadding="1" cellspacing="3">
                                <tr>
								<td colspan="3">&nbsp;</td>
                                  
                                </tr>
                                <tr valign="top">
								<%if exiete_empre_daem<>99 then%>
								<td colspan="3" align="center"><span class="Estilo1"><font size="6" face="Georgia, Times New Roman, Times, serif">La Empresa ya esta registrada</font></span></td>
								<%else%>
								<td colspan="3" align="center"></td>
								<%end if%>
								
                                  
                                </tr>
                                <tr>
                                  <td colspan="3">&nbsp;</td>
                                </tr>
								
								</table>
							  </td>
										</tr>
										<%if exiete_empre_daem<>99 then%>
									<tr>
									<td>
										<table width="718">
								
                                <tr>
                                  <td width="434" height="10">&nbsp;</td>
                                  <td width="111" height="10" align="right">&nbsp;</td>
                                  <td width="157" height="10" align="left"><%POS_IMAGEN = POS_IMAGEN + 1%>
                                  <a href="javascript:_Navegar(this, 'portada_registro_empresa.asp', 'FALSE');"
												onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
												onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true "> <img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> </a> </td>
                                </tr>
                              </table></td>
							</tr>	
							<%end if%>
							<%else%>
							<tr>
									<td>
										<table width="100%">
							<tr>
							  <td width="100%" align="center"><table width="99%" border="0" cellpadding="1" cellspacing="3">
                                <tr>
								<td width="26%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Rut Empresa  :</strong></font></td>
                                  <td width="43%"  height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Nombre  Comercial :</strong></font></td>
                                  <td width="31%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Raz&oacute;n  Social :</strong></font></td>
                                </tr>
                                <tr valign="top">
								<td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#f7faff">
                                      <tr>
                                        <td><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_empresa.dibujaCampo("rut2")%>-<%=f_datos_empresa.dibujaCampo("dv2")%></font></td>
                                      </tr>
                                  </table></td>
                                  <td height="20"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                                      <tr>
                                        <td height="20" bordercolor="#CCCCCC" bgcolor="#f7faff"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_empresa.dibujaCampo("empr_tnombre")%></font></td>
                                      </tr>
                                  </table></td>
                                  <td><table width="99%" border="0" cellpadding="0" cellspacing="0" bgcolor="#F0F0F0">
                                      <tr>
                                        <td height="20" bordercolor="#CCCCCC" bgcolor="#f7faff"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_empresa.dibujaCampo("empr_trazon_social")%></font></td>
                                      </tr>
                                  </table></td>
                                </tr>
                                <tr>
                                  <td height="10">&nbsp;</td>
                                  <td height="10">&nbsp;</td>
                                  <td height="10">&nbsp;</td>
                                </tr>
								
								</table>							  </td>
										</tr>
								
								<tr>
									<td>
										<table width="100%">
										
								
                                <tr>
								
							
                                  <td width="224" height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Direcci&oacute;n :</strong></strong></font></td>
								  <td width="102"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Número:</strong></strong></font></td>
								  <td width="102"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Depto:</strong></strong></font></td>
								  <td width="206"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Regi&oacute;n :</strong></strong></font></td>
                                  <td width="166"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Ciudad :</strong></strong></font></td>
                                </tr>
                                <tr valign="top">
                                  <td height="20"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                                      <tr>
                                        <td height="20" bordercolor="#CCCCCC" bgcolor="#f7faff"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_empresa.dibujaCampo("dire_tcalle")%></font></td>
                                      </tr>
                                  </table></td>
                                  <td><table width="73%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                                      <tr>
									  <td height="20" bordercolor="#CCCCCC" bgcolor="#f7faff"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_empresa.dibujaCampo("dire_tnro")%></font></td>
                                      </tr>
                                  </table></td>
								   <td><table width="99%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                                      <tr>
									  
                                        <td height="20" bordercolor="#CCCCCC" bgcolor="#f7faff"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_empresa.dibujaCampo("dire_tdepto")%></font></td>
                                      </tr>
                                  </table></td>
								  <td><table width="99%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                                      <tr>
									  
                                        <td height="20" bordercolor="#CCCCCC" bgcolor="#f7faff"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_empresa.dibujaCampo("regi_ccod")%></font></td>
                                      </tr>
                                  </table></td>
                                  <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                                      <tr>
                                        <td height="20" bordercolor="#CCCCCC" bgcolor="#f7faff"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_empresa.dibujaCampo("ciud_ccod")%></font></td>
                                      </tr>
                                  </table></td>
                                </tr>
								
								
								
                                <tr>
                                  <td height="10">&nbsp;</td>
                                  <td height="10">&nbsp;</td>
                                  <td height="10">&nbsp;</td>
                                </tr>
								</table>									</td>
								</tr>
								
								
								<tr>
									<td>
										<table width="100%">
                                <tr>
                                  <td width="179" height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Pais : </strong></strong></font></td>
                                  <td width="269"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Sector :</strong></font></td>
                                  <td width="254"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>N&deg; Trabjadores:</strong></strong></font></td>
                                </tr>
                                <tr valign="top">
                                  <td><table width="92%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                                      <tr>
                                        <td height="20" bordercolor="#CCCCCC" bgcolor="#f7faff"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_empresa.dibujaCampo("pais_ccod")%></font></td>
                                      </tr>
                                  </table></td>
                                  <td><table width="96%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                                      <tr>
                                        <td height="20" bordercolor="#CCCCCC" bgcolor="#f7faff"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_empresa.dibujaCampo("sector")%></font></td>
                                      </tr>
                                  </table></td>
                                  <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                                      <tr>
                                        <td height="20" bordercolor="#CCCCCC" bgcolor="#f7faff"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_empresa.dibujaCampo("n_trabajadores")%></font></td>
                                      </tr>
                                  </table></td>
                                </tr>
                                <tr>
                                  <td height="10">&nbsp;</td>
                                  <td>&nbsp;</td>
                                  <td>&nbsp;</td>
                                </tr>
									  </table>									</td>
										</tr>
										
										
								<tr>
									<td>
										<table>
											<tr>
												<td width="139"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Datos Convenio </strong></font></td>
												<td width="535"><hr></td>
											<tr/>
										</table>									</td>
								</tr>
								<tr>
									<td>
										<font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Datos Contacto </strong></font>									</td>
								</tr>
								<tr>
									<td>
										<table width="100%">
											<tr>
											   <td width="173" colspan="1"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Rut </strong></font></td>
											  <td width="190" height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Nombre:</strong></strong></font></td>
											  <td width="190" height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Apellido Paterno: </strong></strong></font></td>
											  <td width="190" height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Apellido Materno:</strong></strong></font></td>
											</tr>
											
											<tr valign="top">
											  <td colspan="1">
													<table width="92%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													  <tr>
														<td height="20" bordercolor="#CCCCCC" bgcolor="#f7faff"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_empresa.dibujaCampo("rut_contacto")%>-<%=f_datos_empresa.dibujaCampo("dv_contacto")%></font></td>
													  </tr>
													</table>											  </td>
											  <td height="20">
													<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													  <tr>
														<td height="20" bordercolor="#CCCCCC" bgcolor="#f7faff"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_empresa.dibujaCampo("daem_pers_tnombre")%></font></td>
													  </tr>
													</table>											  </td>
											
											  <td>
												  <table width="99%" border="0" cellpadding="0" cellspacing="0" bgcolor="#f7faff">
													  <tr>
														<td height="20" bordercolor="#CCCCCC" bgcolor="#f7faff"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_empresa.dibujaCampo("daem_pers_tape_paterno")%></font></td>
													  </tr>
												  </table>											  </td>
											   <td>
												  <table width="99%" border="0" cellpadding="0" cellspacing="0" bgcolor="#f7faff">
													  <tr>
														<td height="20" bordercolor="#CCCCCC" bgcolor="#f7faff"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_empresa.dibujaCampo("daem_pers_tape_materno")%></font></td>
													  </tr>
												  </table>											  </td>
											</tr>
									  </table>							      </td>
							  </tr>
							  <tr>
									<td>
										<table width="751">
											<tr>
											 
											  <td width="331" colspan="1"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Cargo  :</strong></font></td>
											  <td width="376"><strong><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Fono:</strong></font></strong></td>
											  <td width="376"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Fax:</strong></strong></font></td>
											</tr>
											
											<tr valign="top">
											  
											  <td colspan="1">
													<table width="92%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													  <tr>
														<td height="20" bordercolor="#CCCCCC" bgcolor="#f7faff"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_empresa.dibujaCampo("cargo")%></font></td>
													  </tr>
													</table>											  </td>
											  <td>
												  <table width="99%" border="0" cellpadding="0" cellspacing="0" bgcolor="#f7faff">
													  <tr>
														<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_empresa.dibujaCampo("fono")%></font></td>
													  </tr>
												  </table>											  </td>
											    <td>
												  <table width="99%" border="0" cellpadding="0" cellspacing="0" bgcolor="#f7faff">
													  <tr>
														<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_empresa.dibujaCampo("fax")%></font></td>
													  </tr>
												  </table>											  </td>
											</tr>
									  </table>							      </td>
							  </tr>		
										
								<tr>
								  <td><table width="751">
                                    <tr>
                                      <td width="172"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Email : </strong></strong></font></td>
                                      <td width="428"></td>
                                      <td width="428"></td>
                                    </tr>
                                    <tr valign="top">
                                      <td>
									    <table width="99%" border="0" cellpadding="0" cellspacing="0" bgcolor="#f7faff">
											  <tr>
												<td><font size="2" face="Courier New, Courier, mono" color="#f7faff"><%=f_datos_empresa.dibujaCampo("pers_temail")%></font></td>
											  </tr>
									    </table>
									  </td>
                                      <td>&nbsp;
									  	
									  </td>
									  <td>&nbsp;
									  	
									  </td>
                                    </tr>
                                    <tr>
                                      <td height="20"></td>
                                      <td>&nbsp;</td>
                                      <td>&nbsp;</td>
                                    </tr>
                                    <tr valign="top">
                                      <td colspan="2"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                                          <tr>
                                            <td height="20" bordercolor="#CCCCCC" bgcolor="#f7faff"></td>
                                          </tr>
                                      </table></td>
                                      <td colspan="1"><table width="99%" border="0" cellpadding="0" cellspacing="0" bgcolor="#f7faff">
                                          <tr>
                                            <td>&nbsp;</td>
                                          </tr>
                                      </table></td>
                                    </tr>
                                  </table></td>
										</tr>
								<tr>
									<td>
										<table width="718">
								
                                <tr>
                                  <td width="434" height="10">&nbsp;</td>
                                  <td width="111" height="10" align="right"><%POS_IMAGEN = POS_IMAGEN + 1%>
                                  <a href="javascript:_Guardar(this, document.forms['empresa'], 'proc_registro_empresa.asp','', '', '', 'FALSE');"
												onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/GUARDAR2.png';return true "
												onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/GUARDAR1.png';return true "> <img src="imagenes/GUARDAR1.png" border="0" width="70" height="70" alt="Guardar Información"> </a> </td>
                                  <td width="157" height="10" align="left"><%POS_IMAGEN = POS_IMAGEN + 1%>
                                  <a href="javascript:_Navegar(this, 'portada_registro_empresa.asp', 'FALSE');"
												onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
												onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true "> <img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> </a> </td>
                                </tr>
                              </table></td>
							</tr>
						</table>					</td>
				</tr>
				<%end if%>
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
