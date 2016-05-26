<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<% 
'------------------------------------------------------

 tiea_ccod= Request.QueryString("tiea_ccod")
 dlpr_ncorr=Request.QueryString("dlpr_ncorr")
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

  q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
  q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
  if esVacio(q_pers_nrut) then
	 q_pers_nrut = negocio.obtenerUsuario
	 q_pers_xdv = conexion.consultaUno("Select pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
  end if
  'response.write(q_npag)
 
 periodo_actual = "226"

 '-- Botones de la pagina -----------
 set f_botonera = new CFormulario
 f_botonera.Carga_Parametros "curriculum_alumno.xml", "botonera"
 

'---------------------------------------------------------------------------------------------------

 
 set f_practica_pasantia = new CFormulario
 f_practica_pasantia.Carga_Parametros "curriculum_alumno.xml", "laboral_practica_pasantia"
 f_practica_pasantia.Inicializar conexion
			
			
			if dlpr_ncorr =""  then
			sltTrabajo="select ''"
			
			else	 
	sltTrabajo="select   pais_ccod,ciud_ccod,dlpr_nombre_empresa,dlpr_rubro_empresa,dlpr_cargo_empresa,dlpr_web_empresa,exal_ncorr,exal_fini,case when exal_ffin='01-01-1900 0:00:00.000' then null when exal_ffin <> '01/01/1900' then exal_ffin end as exal_ffin,tiea_ccod,exal_tactividad from direccion_laboral_profesionales a,experiencia_alumno b "& vbCrLf &_
"where a.dlpr_ncorr=b.dlpr_ncorr"& vbCrLf &_
"and a.dlpr_ncorr="&dlpr_ncorr&" "
 	
end if
f_practica_pasantia.Consultar sltTrabajo
f_practica_pasantia.Siguiente
 
 
 
 

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Bienvenido a Universidad del Pac&iacute;fico Online</title>
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
    var tipo_traspaso = '<%=tipo_traspaso%>';
	if (tipo_traspaso=='0')
	 {window.location = '../lanzadera/lanzadera.asp';}
	else
	 {window.close();} 
}
function ayuda (valor)
{ var mensaje="";

 var qtiea_ccod='<%=tiea_ccod%>';
 
 
 if (qtiea_ccod =1)
 {
    mensaje = "AYUDA\nDebes ingresar tu informacion laboral" 

	alert(mensaje);
	}
	if (qtiea_ccod !=1)	   
	{	
	 mensaje = "AYUDA\nDebes ingresar informacion sobre tu pasantias o practica laboral" 
	       	    
	alert(mensaje);
	}
	
}
function validarclick()
{ 

 var qtiea_ccod='<%=tiea_ccod%>';
if (qtiea_ccod !=1)
{
 var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor=2;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.laboral_practica_pasantia.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.laboral_practica_pasantia.elements[i];
  	if ((elemento.type=="radio"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 return true;
  }
  else
  {
   alert("Debes marcar que tipo de experiencia es Paractica Laboral o Pasantia Temprana.");
   return false;
  }
 
  }
   return true;
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
		
		<form name="laboral_practica_pasantia">
		<input type="hidden" name="prapa[0][pers_nrut]" value="<%=q_pers_nrut%>">
		<input type="hidden" name="prapa[0][dlpr_ncorr]" value="<%=dlpr_ncorr%>">
		<input type="hidden" name="prapa[0][tiea_ccod]" value="<%=tiea_ccod%>">
	<tr>
		<td width="100%" height="400" align="left">
		
			<table width="700" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="98%" border="0" bgcolor="#f7faff">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<%if tiea_ccod=1 then%>
										<tr>
										   <td width="50%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Laboral </strong></font></td>
										   <td width="39%"><hr></td>
										   <%end if%>
										   <%if tiea_ccod=2 then%>
								   	  <tr>
										   <td width="50%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Pr&aacute;ctica Profesional </strong></font></td>
										   <td><hr></td>
										   <%end if%>
										    <%if tiea_ccod=3 then%>
								   	  <tr>
										   <td width="50%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Pasant&iacute;a Temprana Profesionalizante</strong></font></td>
										   <td><hr></td>
										   <%end if%>
										       <TD width="11%">
										   		<%POS_IMAGEN = 0%>
										   		<a href="javascript:ayuda(1)"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda2.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda1.png';return true ">
												<img src="imagenes/ayuda1.png" border="0" width="38" height="38" alt="¿Cómo funciona?">												</a>										  </TD>
									  </tr>
									</table>								</td>
							</tr>
							<tr>
							  <td width="100%" align="center"><table width="100%" border="0" cellpadding="1" cellspacing="3">
                               
                               
							    
								
								  <tr>
                                  <td colspan="2" height="20">&nbsp;</td>
                                  <td width="29%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>&nbsp;</strong></font></td>
                                  <td width="30%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>&nbsp;</strong></font></td>
                                </tr>
								
                                <tr>
                                  <td colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Nombre Empresa/Institucion </strong></font></td>
                                  <td colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Sector : </strong></font></td>
                                </tr>
                                <tr valign="top">
                                  <td height="20" colspan="2"><table width="100%" border="0" cellpadding="0" cellspacing="0" >
                                      <tr>
                                        <td height="20" bordercolor="#CCCCCC" ><%=f_practica_pasantia.dibujaCampo("dlpr_nombre_empresa")%></td>
                                      </tr>
                                  </table></td>
                                 
                                  <td height="20" colspan="2"><table width="100%" border="0" cellpadding="0" cellspacing="0" >
                                      <tr> <td height="20" bordercolor="#CCCCCC" ><%=f_practica_pasantia.dibujaCampo("dlpr_rubro_empresa")%></td></tr>
                                    </table>                                </tr>
                                <tr>
                                  <td colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Cargo : </strong></font></td>
                                  <td colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong> Pagina Web : </strong></font></td>
                                </tr>
                                <tr valign="top">
                                  <td height="20" colspan="2"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                                      <tr>
                                        <td height="20" bordercolor="#CCCCCC" ><%=f_practica_pasantia.dibujaCampo("dlpr_cargo_empresa")%></td>
                                      </tr>
                                  </table></td>
                                  <td colspan="2"><table width="80%" border="0" cellpadding="0" cellspacing="0" >
                                      <tr>
                                        <td height="20" bordercolor="#CCCCCC"><%=f_practica_pasantia.dibujaCampo("dlpr_web_empresa")%></td>
                                      </tr>
                                  </table></td>
                                  <td width="4%"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                                      <tr> </tr>
                                  </table>                                </tr>
                                <tr>
                                  <td height="10" colspan="6">&nbsp;</td>
                                </tr>
                                <tr>
                                  <td width="20%" height="20" colspan="1"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Fecha Ingreso  : </strong></font></td>
                                  <td width="17%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Fecha Salida </strong></font></td>
                                  <td></td>
                                </tr>
                                <tr valign="top">
                                  <td height="20" colspan="1"><table width="99%" border="0" cellpadding="0" cellspacing="0" >
                                      <tr>
                                        <td height="20" bordercolor="#CCCCCC" ><%=f_practica_pasantia.dibujaCampo("exal_fini")%><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong> dd/mm/aaaa </strong></font></td>
                                      </tr>
                                  </table></td>
                                  <td><table width="100%" border="0" cellpadding="0" cellspacing="0" >
                                      <tr>
                                        <td height="20" bordercolor="#CCCCCC" ><%=f_practica_pasantia.dibujaCampo("exal_ffin")%><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong> dd/mm/aaaa </strong></font></td>
                                      </tr>
                                  </table></td>
                                  <td colspan="2"><table width="80%" border="0" cellpadding="0" cellspacing="0" >
                                      <tr>
                                        <td height="20" bordercolor="#CCCCCC" >&nbsp;</td>
                                      </tr>
                                  </table></td>
                                </tr>
  <td height="20" colspan="1"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Pais :</strong></font></td>
      <td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Ciudad :</strong></font></td>
      <td></td>
  </tr>
  <tr valign="top">
    <td height="20" colspan="1"><table width="100%" border="0" cellpadding="0" cellspacing="0" >
      <tr>
        <td height="20" bordercolor="#CCCCCC" ><%=f_practica_pasantia.dibujaCampo("pais_ccod")%></td>
      </tr>
    </table></td>
    <td><table width="100%" border="0" cellpadding="0" cellspacing="0" >
      <tr>
        <td height="20" bordercolor="#CCCCCC" ><%=f_practica_pasantia.dibujaCampo("ciud_ccod")%></td>
      </tr>
    </table></td>
    <td colspan="2"><table width="51%" border="0" cellpadding="0" cellspacing="0" >
      <tr>
        <td height="20"  bordercolor="#CCCCCC" >&nbsp;</td>
      </tr>
    </table></td>
  </tr>
  <%if tiea_ccod <>1 then %>
     <td height="20" colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Actividades Desarrolladas</strong></font></td>
       <td></td>
      <td></td>
  </tr>
  <tr valign="top">
    <td height="20" colspan="4"><table width="100%" border="0" cellpadding="0" cellspacing="0" >
      <tr>
        <td height="20" bordercolor="#CCCCCC" ><%=f_practica_pasantia.dibujaCampo("exal_tactividad")%></td>
      </tr>
    </table></td>
      <%end if%>
    
  </tr>
  <tr>
    <td height="10">&nbsp;</td>
    <td height="10" colspan="2"><hr></td>
    <td height="10">&nbsp;</td>
  </tr>
 
 
  <tr valign="top">
  <tr valign="top">
  <tr>
  <tr>
    <td height="10">&nbsp;</td>
   <td></td>
								        <td height="10" align="right">
										<%POS_IMAGEN = POS_IMAGEN + 1%>
				<a href="javascript:_Guardar(this, document.forms['laboral_practica_pasantia'], 'proc_laboral_practica_pasantia.asp','', 'validarclick();','','FALSE');"
																onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/AGREGAR2.png';return true "
																onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/AGREGAR1.png';return true "><img src="imagenes/AGREGAR1.png" border="0" width="70" height="70" alt="Guardar"></a></td>
										
    <td height="10" align="left"><%POS_IMAGEN = POS_IMAGEN + 1%>
      <a href="javascript:_Navegar(this, 'curriculum.asp?npag=2', 'FALSE');"
												onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
												onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true "> <img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> </a> </td>
                              </table></td>
							</tr>
						</table>					</td>
				</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
			</table>		</td>
	</tr>
	</form>
	
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<!--Datos entregados para admisión-->
	<tr>
		<td width="100%" align="left">		</td>
	</tr>
</table>

</center>
</body>
</html>

