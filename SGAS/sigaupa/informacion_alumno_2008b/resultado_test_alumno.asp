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
 
  q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
  q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
  if esVacio(q_pers_nrut) then
	 q_pers_nrut = negocio.obtenerUsuario
	 q_pers_xdv = conexion.consultaUno("Select pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
  end if
  pers_ncorr=conexion.consultaUno("Select protic.obtener_pers_ncorr("&q_pers_nrut&")")
  q_idal_ncorr = Request.QueryString("idal_ncorr")
 
    'response.write(q_idio_ncorr)
	
  if esVacio(q_pers_nrut) then
	 q_pers_nrut = negocio.obtenerUsuario
	 q_pers_xdv = conexion.consultaUno("Select pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
  end if

 
 periodo_actual = "226"

 '-- Botones de la pagina -----------

 

 
 set f_resultado = new CFormulario
 f_resultado.Carga_Parametros "resultado_alumno_test.xml", "resultado"
 f_resultado.Inicializar conexion

 			sql_= "select nombre,ec,o_r,ca,ea,ca_ec,ea_or,"& vbCrLf &_
"case when ea_or > 0 and ca_ec >0  then 'DIVERGENTE' when ea_or < 0 and ca_ec >0  then 'ACOMODADOR' when ea_or > 0 and ca_ec < 0  then 'ASIMILADOR' when ea_or < 0 and ca_ec <0  then 'CONVERGENTE' when ea_or = 0 and ca_ec >0  then 'ACOMODADOR/DIVERGENTE' when ea_or > 0 and ca_ec =0  then 'DIVERGENTE/ASIMILADOR' when ea_or = 0 and ca_ec < 0  then 'ASIMILADOR/CONVERGENTE' when ea_or < 0 and ca_ec = 0  then 'ACOMODADOR/CONVERGENTE' when ea_or = 0 and ca_ec = 0  then 'ACOMODADOR/CONVERGENTE/ASIMILADOR/DIVERGENTE'  end as tipo"& vbCrLf &_

"from (select distinct cast(p.pers_nrut as varchar) + '-' + p.pers_xdv as rut, p.pers_tape_paterno + ' ' + p.pers_tape_materno + ' ' + p.pers_tnombre as 						               	nombre,carr_tdesc as carrera, post_npaa_verbal as Paa_verbal,post_npaa_matematicas as paa_mate,protic.trunc(et.fecha)as fecha,"& vbCrLf &_
"preg_2_a + preg_3_a + preg_4_a + preg_5_a + preg_7_a + preg_8_a as ec,"& vbCrLf &_
"preg_1_b + preg_3_b +preg_6_b + preg_7_b + preg_8_b + preg_9_b  as o_r,"& vbCrLf &_
"preg_2_c + preg_3_c +preg_4_c + preg_5_c + preg_8_c + preg_9_c as ca,"& vbCrLf &_
"preg_1_d + preg_3_d +preg_6_d + preg_7_d + preg_8_d + preg_9_d as ea,"& vbCrLf &_
"((((preg_1_d + preg_3_d +preg_6_d + preg_7_d + preg_8_d + preg_9_d)-(preg_1_b + preg_3_b +preg_6_b + preg_7_b + preg_8_b + preg_9_b))*-1)+3)as ea_or,"& vbCrLf &_
"((((preg_2_c + preg_3_c +preg_4_c + preg_5_c + preg_8_c + preg_9_c)-(preg_2_a + preg_3_a + preg_4_a + preg_5_a + preg_7_a + preg_8_a))*-1)+2)as ca_ec"& vbCrLf &_

 
"from encuesta_test et,personas p,alumnos a,postulantes po,ofertas_academicas oa, especialidades esp,carreras car"& vbCrLf &_
"where et.pers_ncorr=p.pers_ncorr"& vbCrLf &_
"and et.pers_ncorr=a.pers_ncorr"& vbCrLf &_
"and a.ofer_ncorr=oa.ofer_ncorr"& vbCrLf &_
"and oa.peri_ccod=210"& vbCrLf &_
"and oa.espe_ccod=esp.espe_ccod"& vbCrLf &_
"and esp.carr_ccod=car.carr_ccod"& vbCrLf &_
"and a.post_ncorr=po.post_ncorr"& vbCrLf &_
"and et.pers_ncorr=protic.obtener_pers_ncorr1('"&q_pers_nrut&"')"
"order by nombre"

	f_resultado.Consultar sql_
 f_resultado.Siguiente

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
    mensaje = "AYUDA\nAquí encontraras los resultados del Test de Kolb;\n" +
	       	  ;
		   
		   
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
			<table width="672" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6" align="center">
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
										<td width="159" height="20">&nbsp;</td>
										<td width="176"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>&nbsp;</strong></font></td>
										<td width="146"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>&nbsp;</strong></font></td>
									    <td width="129" height="38">
										        <%POS_IMAGEN = 0%>
								        <a href="javascript:ayuda(1)"
												onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda2.png';return true "
												onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda1.png';return true "><img src="imagenes/ayuda1.png" border="0" width="38" height="38" alt="¿Cómo funciona?"></a></td>
									  </tr>
									  <tr> 
										<td height="20">&nbsp;</td>
										<td colspan="3"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Nivel :</strong></font></td>
									  </tr>
									  <tr valign="top"> 
											<td height="20"> 
												 <table width="98%" border="0" cellpadding="0" cellspacing="0" >
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" ></td>
													</tr>
											  </table>											</td>
											<td colspan="3">
												 <table width="45%" border="0" cellpadding="0" cellspacing="0" >
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" ><font size="2" face="Courier New, Courier, mono" color="#496da6"><%'=f_idioma.dibujaCampo("nidi_ccod")%></font></td>
													</tr>
											  </table>											</td>
									  </tr>
									    <tr> 
										<td height="10">&nbsp;</td>
										
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td width="129" height="10">&nbsp;</td>
									  </tr>
                                      <tr> 
										<td height="10"></td>
										
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td width="129" height="10">&nbsp;</td>
									  </tr>
									    <tr> 
										<td height="10">&nbsp;</td>
										
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td width="129" height="10">&nbsp;</td>
									  </tr>
									  <tr> 
										<td height="23" colspan="1">&nbsp;</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
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
																onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/AGREGAR2.png';return true "
																onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/AGREGAR1.png';return true ">
																<img src="imagenes/AGREGAR1.png" border="0" width="70" height="70" alt="Guardar nueva Clave"> 
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

