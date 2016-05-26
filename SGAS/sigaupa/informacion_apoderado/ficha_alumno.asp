<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_apoderado.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<% 
'------------------------------------------------------
 q_npag			= Request.QueryString("npag")
 traspaso 	= Request.QueryString("traspaso")
 if traspaso = "" then
 	tipo_traspaso="0"
 else
 	tipo_traspaso="1"
 end if	


'conexión a servidor de producción consultas que requieran actualización al minuto
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
  
 periodo_actual = "210"

 '-- Botones de la pagina -----------
 set f_botonera = new CFormulario
 f_botonera.Carga_Parametros "datos_alumno.xml", "botonera"
 
 '---------------------------------------------------------------------------------------------------
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "datos_alumno.xml", "busqueda"
 f_busqueda.Inicializar conexion

 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
 f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
'---------------------------------------------------------------------------------------------------
 if q_pers_nrut = "" or isnull(q_pers_nrut) then
 	rut_env = "-1"
	es_alumno = -1
 else
 	rut_env = q_pers_nrut
	es_alumno = cint(conexion.consultaUno("select protic.TIENE_MATRICULA_ALUMNO("& rut_env &", "& periodo_actual &")"))
   'response.Write("select protic.ES_ALUMNO("& rut_env &", "& periodo_actual &")")
	'-- Formulario con los datos del alumno (Parte 1) -----------
	set fDatosPer = new CFormulario
	fDatosPer.Carga_Parametros "datos_alumno.xml", "f_datos_antecedentes"
	fDatosPer.Inicializar conexion
	cons_Datos = "exec LIST_FICHA_ANTECEDENTES_PERS " & rut_env
	fDatosPer.Consultar cons_Datos 
	fDatosPer.Siguiente
	
	if q_npag = "" or isnull(q_npag) then
		q_npag = 1
	elseif q_npag = 2 then
		'-- Formulario con los datos del alumno (Parte 2) -----------
		set fDatosPer2 = new CFormulario
		fDatosPer2.Carga_Parametros "datos_alumno.xml", "f_datos_antecedentes2"
		fDatosPer2.Inicializar conexion
		cons_Datos = "exec LIST_FICHA_ANTECEDENTES_PERS2 " & rut_env
		fDatosPer2.Consultar cons_Datos 
		fDatosPer2.Siguiente
	end if
 end if 
 
'-- Fin (Parte 1) -------------------------------------------

'--------------------------------------------------------------------------------------------------
 set fc_datos = new CFormulario
 fc_datos.Carga_Parametros "consulta.xml", "consulta"
 fc_datos.Inicializar conexion
		   
 consulta = "select cast(a.pers_nrut as varchar) + ' - ' + a.pers_xdv as rut," & vbCrLf &_
			"         a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre_completo " & vbCrLf &_
			"from personas_postulante a " & vbCrLf &_
			"where cast(a.pers_nrut as varchar) = '" & q_pers_nrut & "'"
 fc_datos.Consultar consulta
 fc_datos.Siguiente
 
'-------------------------------------------------------------------------
 dir_a = "ficha_alumno.asp?busqueda[0][pers_nrut]="&q_pers_nrut&"&busqueda[0][pers_xdv]="&q_pers_xdv&"&npag=1"
 dir_b = "ficha_alumno.asp?busqueda[0][pers_nrut]="&q_pers_nrut&"&busqueda[0][pers_xdv]="&q_pers_xdv&"&npag=2" 
 if traspaso = "" then
	 if q_npag = 1 then
		'f_botonera.AgregaBotonParam "pagina2", "texto", "Ir a página 2"
		dir_JS = "ficha_alumno.asp?busqueda[0][pers_nrut]="&q_pers_nrut&"&busqueda[0][pers_xdv]="&q_pers_xdv&"&npag=2"
	 else
		dir_JS = "ficha_alumno.asp?busqueda[0][pers_nrut]="&q_pers_nrut&"&busqueda[0][pers_xdv]="&q_pers_xdv&"&npag=1"
		'f_botonera.AgregaBotonParam "pagina2", "texto", "Ir a página 1"
	 end if
 else
	 if q_npag = 1 then
		'f_botonera.AgregaBotonParam "pagina2", "texto", "Ir a página 2"
		dir_JS = "ficha_alumno.asp?busqueda[0][pers_nrut]="&q_pers_nrut&"&busqueda[0][pers_xdv]="&q_pers_xdv&"&npag=2&traspaso=1"
	 else
		dir_JS = "ficha_alumno.asp?busqueda[0][pers_nrut]="&q_pers_nrut&"&busqueda[0][pers_xdv]="&q_pers_xdv&"&npag=1&traspaso=1"
		'f_botonera.AgregaBotonParam "pagina2", "texto", "Ir a página 1"
	 end if
 end if

sql_persona="select pers_ncorr from personas where cast(pers_nrut as varchar)='"&rut_env& "' "
v_pers_ncorr=conexion.consultaUno(sql_persona)

if v_pers_ncorr<>"" then
	v_ofer_ncorr 	= conexion.consultaUno("select protic.ultima_oferta_matriculado("& v_pers_ncorr &") ")
	v_sede_ccod 	= conexion.consultaUno("select sede_ccod from ofertas_academicas where ofer_ncorr in ("& v_ofer_ncorr &") ")
end if
'response.Write(v_ofer_ncorr&" - "&v_sede_ccod)

if v_sede_ccod <>"" then
	sql_agentes_cobranza="select * from encargados_cobranzas_sede a, sedes b where a.sede_ccod=b.sede_ccod and cast(a.sede_ccod as varchar)='"&v_sede_ccod&"' "
	
	set f_agentes = new CFormulario
	f_agentes.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
	f_agentes.Inicializar conexion
	f_agentes.Consultar sql_agentes_cobranza
	f_agentes.siguiente
end if
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Bienvenido a Universidad del Pac&iacute;fico Online</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_alumno.css" rel="stylesheet" type="text/css">
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
    mensaje = "AYUDA\nLa Ficha de antecedentes personales, le entrega información al alumnado de cuales son los datos que tenemos registrados en el sistema;\n" +
	       	  "Datos que deben ser corroborados por cada alumno y en caso de presentar alguna anomalía o que requiera ser cambiado, rogamos comunicarse con departamento de registro curricular\n"+
		      "Los botones de esta función permiten navegar entre las dos páginas, para ver datos personales, domicilios, datos académicos y familiares.\n"+
		      "En una futura versión se pretende desarrollar la opción para que el alumno modifique sus datos directamente desde cualquier PC conectado a Internet.";
		   
		   
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
<%if q_npag=1 then%>
<table align="center" width="700">
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<tr>
		<td width="100%" align="center"><font size="5" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>FICHA DE ANTECEDENTES PERSONALES</strong></font></td>
	</tr>
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
										   <td width="252"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Identificación del Alumno</strong></font></td>
										   <td width="344"><hr></td>
										   <td width="68" height="38">
										        <%POS_IMAGEN = 0%>
										   		<a href="javascript:ayuda(1)"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda2.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda1.png';return true ">
												
												<img src="imagenes/ayuda1.png" border="0" width="38" height="38" alt="¿Cómo funciona?"> 
												</a>
										   
										   </td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="100%" border="0" cellpadding="1" cellspacing="3">
									  <tr> 
										<td height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Nombres :</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>RUT :</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Pasaporte :</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Fecha Nacimiento :</strong></font></td>
									  </tr>
									  <tr valign="top"> 
											<td height="20"> 
												 <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("nombre")%></font></td>
													</tr>
												  </table>
											</td>
											<td>
												 <table width="80%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("rut")%></font></td>
													</tr>
												 </table>
											</td>
											<td>
												 <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													   <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("pasaporte")%></font></td>
													</tr>
												 </table>
											</td>
											<td>
												 <table width="50%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("fecha_nac")%></font></td>
													</tr>
												 </table>
											</td>
									  </tr>
                                      <tr> 
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
									  </tr>
									  <tr> 
										<td height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Direcci&oacute;n :</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Comuna : </strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Ciudad :</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Regi&oacute;n :</strong></font></td>
									  </tr>
									  <tr valign="top"> 
										<td height="20"> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"> <font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("Direccion")%></font></td>
											</tr>
										  </table>
										 </td>
										 <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"> <font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("comuna")%></font></td>
											</tr>
										  </table>
										  </td>
										  <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"> <font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("ciudad")%></font></td>
											</tr>
										  </table>
										  </td>
										  <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"> <font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("region")%></font></td>
											</tr>
										  </table>
										  </td>
									  </tr>
									  <tr> 
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
									  </tr>
									  <tr> 
										<td height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Fonos : </strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Nacionalidad :</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Carrera :</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>A&ntilde;o Ingreso :</strong></font></td>
									  </tr>
									  <tr valign="top"> 
										<td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"> <font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("fono")%></font></td>
											</tr>
										  </table>
										</td>
										<td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"> <font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("nacionalidad")%></font></td>
											</tr>
										  </table>
										</td>
										<td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"> <font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("Carrera")%></font></td>
											</tr>
										  </table>
										</td>
										<td> <table width="40%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"> <font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("ano_ingr")%></font></td>
											</tr>
										  </table>
										</td>
									  </tr>
									  <tr> 
										<td height="10">&nbsp;</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
									  </tr>
									  <tr> 
										<td height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Estado Civil :</strong></font></td>
										<td colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Qui&eacute;n financia sus estudios :</strong></font></td>
										<td>&nbsp;</td>
									  </tr>
									  <tr valign="top"> 
										<td height="20"> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"> <font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("Estado_civil")%></font></td>
											</tr>
										  </table></td>
										<td colspan="2"><table width="55%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"> <font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("FinanciaEst")%></font></td>
											</tr>
										  </table></td>
										<td>&nbsp; </td>
									  </tr>   
                                       <tr> 
										<td height="10" colspan="2"><p><strong>(</strong><font color="#FF0000">*</font><strong>)</strong> <font color="#FF0000"> Si esta información no corresponde o no se muestra actualizada, por favor contactese con Registro Curricular:</font>
									     <br/><font color="#0000FF">Email: crojas@upacifico.cl</font></p></td>
										
										<td height="10" align="right">
											    <%POS_IMAGEN = POS_IMAGEN + 1%>
										   		<a href="javascript:_Navegar(this, 'javascript:irPagina2();', 'FALSE');"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_22.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_21.png';return true ">
												<img src="imagenes/IR_A_PAGINA_21.png" border="0" width="70" height="70" alt="VER INFORMACIÓN DE LA PÁGINA 2"> 
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
										   <td width="38%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Antecedentes Educacionales</strong></font></td>
										   <td><hr></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="100%" border="0" cellpadding="1" cellspacing="3">
									  <tr> 
										<td height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Colegio de Egreso :</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>A&ntilde;o de Egreso</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Proc. de Educaci&oacute;n</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Tipo de Establecimiento</strong></font></td>
									  </tr>
									  <tr valign="top"> 
											<td height="20"> 
												 <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("colegio_egreso")%></font></td>
													</tr>
												  </table>
											</td>
											<td>
												 <table width="80%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("ano_egreso")%></font></td>
													</tr>
												 </table>
											</td>
											<td>
												 <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													   <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("proced_educ")%></font></td>
													</tr>
												 </table>
											</td>
											<td>
												 <table width="50%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0">&nbsp;</td>
													</tr>
												 </table>
											</td>
									  </tr>
                                      <tr> 
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
									  </tr>
									  <tr> 
										<td height="20" colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Universidad (Si estuvo en otra anteriormente)</strong></font></td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
									  </tr>
									  <tr valign="top"> 
										<td height="20" colspan="2"> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"> <font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("inst_educ_sup")%></font></td>
											</tr>
										  </table>
										 </td>
										 <td>&nbsp;</td>
										 <td>&nbsp;</td>
									  </tr>
									  <tr> 
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10" align="right">
											    <%POS_IMAGEN = POS_IMAGEN + 1%>
										   		<a href="javascript:_Navegar(this, 'javascript:irPagina2();', 'FALSE');"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_22.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_21.png';return true ">
												<img src="imagenes/IR_A_PAGINA_21.png" border="0" width="70" height="70" alt="VER INFORMACIÓN DE LA PÁGINA 2"> 
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
	<!--Identificación del sostenedor académico-->
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
										   <td width="45%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Identificaci&oacute;n del sostenedor econ&oacute;mico </strong></font></td>
										   <td><hr></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="100%" border="0" cellpadding="1" cellspacing="3">
									  <tr> 
										<td width="21%" height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Nombre :</strong></font></td>
										<td width="23%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>RUT :</strong></font></td>
										<td colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Fecha Nacimiento :</strong></font></td>
										<td width="23%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Edad :</strong></font></td>
									  </tr>
									  <tr valign="top"> 
											<td height="20"> 
												 <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("nombre_sost_ec")%></font></td>
													</tr>
												  </table>											</td>
											<td>
												 <table width="80%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("RUT_sost_ec")%></font></td>
													</tr>
												 </table>											</td>
											<td colspan="2">
												 <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													   <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("fnac_sost_ec")%></font></td>
													</tr>
												 </table>											</td>
											<td>
												 <table width="50%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("edad_sost")%></font></td>
													</tr>
												 </table>											</td>
									  </tr>
                                      <tr> 
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10" colspan="2">&nbsp;</td>
										<td height="10">&nbsp;</td>
									  </tr>
									  <tr> 
										<td height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Direcci&oacute;n :</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Comuna:</strong></font></td>
										<td colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Ciudad :</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Regi&oacute;n :</strong></font></td>
									  </tr>
									  <tr valign="top"> 
											<td height="20"> 
												 <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("dire_tdesc_sost_ec")%></font></td>
													</tr>
												  </table>											</td>
											<td>
												 <table width="80%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("comu_sost_ec")%></font></td>
													</tr>
												 </table>											</td>
											<td colspan="2">
												 <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													   <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("ciud_sost_ec")%></font></td>
													</tr>
												 </table>											</td>
											<td>
												 <table width="50%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("regi_sost_ec")%></font></td>
													</tr>
												 </table>											</td>
									  </tr>
									  <tr> 
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10" colspan="2">&nbsp;</td>
										<td height="10">&nbsp;</td>
									  </tr>
									  <tr> 
										<td height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Fono :</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Parentesco :</strong></font></td>
										<td colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>&nbsp;</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>&nbsp;</strong></font></td>
									  </tr>
									  <tr valign="top"> 
											<td height="20"> 
												 <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("fono_sost_ec")%></font></td>
													</tr>
												  </table>											</td>
											<td>
												 <table width="80%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("pare_sost_ec")%></font></td>
													</tr>
												 </table>											</td>
											<td colspan="2">
												 <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													   <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0">&nbsp;</td>
													</tr>
												 </table>											</td>
											<td>
												 <table width="50%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0">&nbsp;</td>
													</tr>
												 </table>											</td>
									  </tr>
									  <tr> 
										<td height="10" colspan="3"><strong>(</strong><font color="#FF0000">*</font><strong>)</strong> <font color="#FF0000"> Si esta información no corresponde o no se muestra actualizada, por favor contactese con encargado de recaudaci&oacute;n y finazas correspondiente a su sede (<%=f_agentes.Obtenervalor("sede_tdesc")%>):</font>
										<br>
										<font color="#0000FF">ENCARGADO:</font> <%=f_agentes.Obtenervalor("ecse_tnombre")%> <font color="#0000FF">EMAIL:</font> <%=f_agentes.Obtenervalor("ecse_temail")%>  </td>
										<td width="15%" align="right"><%POS_IMAGEN = POS_IMAGEN + 1%>
                                          <a href="javascript:_Navegar(this, 'javascript:irPagina2();', 'FALSE');"
												onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_22.png';return true "
												onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_21.png';return true "> <img src="imagenes/IR_A_PAGINA_21.png" border="0" width="70" height="70" alt="VER INFORMACIÓN DE LA PÁGINA 2"></a></td>
										<td height="10" align="left">
											    <%POS_IMAGEN = POS_IMAGEN + 1%>
										   		<a href="javascript:_Navegar(this, 'mensajes.asp', 'FALSE');"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true ">
												<img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME">												</a>										</td>
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
</table>
<%else%>
<table align="center" width="700">
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<tr>
		<td width="100%" align="center"><font size="5" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>FICHA DE ANTECEDENTES PERSONALES</strong></font></td>
	</tr>
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
										    <td width="37%" height="23"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Identificación del Alumno</strong></font></td>
										   <td width="52%"><hr></td>
										   <TD width="11%">
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
									<table width="100%" border="0" cellpadding="1" cellspacing="3">
									  <tr> 
										<td height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Nombres :</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>RUT :</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Fonos :</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>&nbsp;</strong></font></td>
									  </tr>
									  <tr valign="top"> 
											<td height="20"> 
												 <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("nombre")%></font></td>
													</tr>
												  </table>
											</td>
											<td>
												 <table width="80%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("rut")%></font></td>
													</tr>
												 </table>
											</td>
											<td>
												 <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													   <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("fono")%></font></td>
													</tr>
												 </table>
											</td>
											<td>
												 <table width="50%" border="0" cellpadding="0" cellspacing="0">
													<tr> 
													  <td height="20">&nbsp;</td>
													</tr>
												 </table>
											</td>
									  </tr>
                                      <tr> 
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
									  </tr>
									  <tr> 
										<td height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Carrera (s) :</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>A&ntilde;o ingreso: </strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>&nbsp;</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>&nbsp;</strong></font></td>
									  </tr>
									  <tr valign="top"> 
										<td height="20"> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"> <font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("Carrera")%></font></td>
											</tr>
										  </table>
										 </td>
										 <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"> <font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer.dibujaCampo("ano_ingr")%></font></td>
											</tr>
										  </table>
										  </td>
										  <td> <table width="100%" border="0" cellpadding="0" cellspacing="0">
											<tr> 
											  <td height="20" >&nbsp;</td>
											</tr>
										  </table>
										  </td>
										  <td> <table width="100%" border="0" cellpadding="0" cellspacing="0">
											<tr> 
											  <td height="20" >&nbsp;</td>
											</tr>
										  </table>
										  </td>
									  </tr>
									     
                                       <tr> 
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10" align="right">
											    <%POS_IMAGEN = POS_IMAGEN + 1%>
										   		<a href="javascript:_Navegar(this, 'javascript:irPagina2();', 'FALSE');"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_12.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_11.png';return true ">
												<img src="imagenes/IR_A_PAGINA_11.png" border="0" width="70" height="70" alt="VER INFORMACIÓN DE LA PÁGINA 1"> 
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
										   <td width="40%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Antecedentes de los Padres</strong></font></td>
										   <td><hr></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="100%" border="0" cellpadding="1" cellspacing="3">
									  <tr> 
										<td height="20"><font size="3" face="Courier New, Courier, mono" color="#496da6"><strong>Padre :</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>&nbsp;</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>&nbsp;</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>&nbsp;</strong></font></td>
									  </tr>
									  <tr> 
										<td height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>RUT :</strong></font></td>
										<td colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Nombres :</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Fono :</strong></font></td>
									  </tr>
									  <tr valign="top"> 
											<td height="20"> 
												 <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer2.dibujaCampo("RUT_p")%></font></td>
													</tr>
												  </table>
											</td>
											<td colspan="2">
												 <table width="80%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer2.dibujaCampo("Nombre_p")%></font></td>
													</tr>
												 </table>
											</td>
											<td>
												 <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													   <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer2.dibujaCampo("fono_p")%></font></td>
													</tr>
												 </table>
											</td>
									  </tr>
                                      <tr> 
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
									  </tr>
									  <tr> 
										<td height="20" colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Direcci&oacute;n :</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Comuna :</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Ciudad :</strong></font></td>
									  </tr>
									  <tr valign="top"> 
											<td height="20" colspan="2"> 
												 <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer2.dibujaCampo("Direccion_p")%></font></td>
													</tr>
												  </table>
											</td>
											<td>
												 <table width="80%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer2.dibujaCampo("comuna_p")%></font></td>
													</tr>
												 </table>
											</td>
											<td>
												 <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													   <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer2.dibujaCampo("ciudad_p")%></font></td>
													</tr>
												 </table>
											</td>
									  </tr>
                                      <tr> 
										<td height="10">&nbsp;</td>
										<td height="10" colspan="2"><hr></td>
										<td height="10">&nbsp;</td>
									  </tr>
									  <tr> 
										<td height="20"><font size="3" face="Courier New, Courier, mono" color="#496da6"><strong>Madre :</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>&nbsp;</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>&nbsp;</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>&nbsp;</strong></font></td>
									  </tr>
									  <tr> 
										<td height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>RUT :</strong></font></td>
										<td colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Nombres :</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Fono :</strong></font></td>
									  </tr>
									  <tr valign="top"> 
											<td height="20"> 
												 <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer2.dibujaCampo("RUT_m")%></font></td>
													</tr>
												  </table>
											</td>
											<td colspan="2">
												 <table width="80%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer2.dibujaCampo("Nombre_m")%></font></td>
													</tr>
												 </table>
											</td>
											<td>
												 <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													   <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer2.dibujaCampo("fono_m")%></font></td>
													</tr>
												 </table>
											</td>
									  </tr>
                                      <tr> 
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
									  </tr>
									  <tr> 
										<td height="20" colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Direcci&oacute;n :</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Comuna :</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Ciudad :</strong></font></td>
									  </tr>
									  <tr valign="top"> 
											<td height="20" colspan="2"> 
												 <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer2.dibujaCampo("Direccion_m")%></font></td>
													</tr>
												  </table>
											</td>
											<td>
												 <table width="80%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer2.dibujaCampo("comuna_m")%></font></td>
													</tr>
												 </table>
											</td>
											<td>
												 <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													   <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer2.dibujaCampo("ciudad_m")%></font></td>
													</tr>
												 </table>
											</td>
									  </tr>
                                      <tr> 
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10" align="right">
											    <%POS_IMAGEN = POS_IMAGEN + 1%>
										   		<a href="javascript:_Navegar(this, 'javascript:irPagina2();', 'FALSE');"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_12.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_11.png';return true ">
												<img src="imagenes/IR_A_PAGINA_11.png" border="0" width="70" height="70" alt="VER INFORMACIÓN DE LA PÁGINA 1"> 
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
	<!--Datos entregados para admisión-->
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
										   <td width="45%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Datos entregados para admisión</strong></font></td>
										   <td><hr></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="100%" border="0" cellpadding="1" cellspacing="3">
									  <tr> 
										<td height="20" colspan="2"><em><font size="2" face="Georgia, Times New Roman, Times, serif" color="#000066">ACAD&Eacute;MICOS</font></em></td>
										<td colspan="2"><em><font size="2" face="Georgia, Times New Roman, Times, serif" color="#000066">FORMA DE ADMISI&Oacute;N</font></em></td>
									  </tr>
									  <tr> 
										<td height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Prom. Notas Ens. Media </strong></font></td>
										<td>
											<table width="50%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
												<tr> 
												  <td height="20" align="right" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer2.dibujaCampo("promNotas_em")%></font></td>
												</tr>
										    </table>
										</td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Admisi&oacute;n Regular</strong></font></td>
										<td>
											<table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
												<tr> 
												  <td height="20" align="center" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer2.dibujaCampo("adm_regular")%></font></td>
												</tr>
											 </table>
										</td>
									  </tr>
									  <tr> 
										<td height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>A&ntilde;o que rinde la PAA</strong></font></td>
										<td>
											<table width="50%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
												<tr> 
												  <td height="20" align="right" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer2.dibujaCampo("ano_PAA")%></font></td>
												</tr>
										    </table>
										</td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Admisi&oacute;n por Convalidaci&oacute;n</strong></font></td>
										<td>
											<table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
												<tr> 
												  <td height="20" align="center" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer2.dibujaCampo("adm_por_conv")%></font></td>
												</tr>
											 </table>
										</td>
									  </tr>
									  <tr> 
										<td height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Ptje. promedio PAA </strong></font></td>
										<td>
											<table width="50%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
												<tr> 
												  <td height="20" align="right" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6">
												                                                                        <%puntaje_PSU= fDatosPer2.obtenerValor("pje_prom_PAA") 
																														  if puntaje_PSU="" or puntaje_PSU < "475" then
																														    response.Write("Ingreso Especial")
																														  else   
																														    response.Write(fDatosPer2.dibujaCampo("pje_prom_PAA"))
																														  end if
																														%></font>
									            </td>
												</tr>
										    </table>
										</td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>&nbsp;</strong></font></td>
										<td>
											<table width="30%" border="0" cellpadding="0" cellspacing="0">
												<tr> 
												  <td height="20" align="center">&nbsp;</td>
												</tr>
											 </table>
										</td>
									  </tr>
									  <tr> 
										<td height="10" valign="top"><font size="2" face="Courier New, Courier, mono" color="#496da6">(Verbal - Matem&aacute;ticas)</font></td>
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
									  </tr>
									  <tr> 
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
									  </tr>
									  <tr> 
										<td height="10"><em><font size="2" face="Georgia, Times New Roman, Times, serif" color="#000066">ANTECEDENTES ENTREGADOS</font></em></td>
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
									  </tr>
									  <tr> 
										<td height="20" colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>C&eacute;dula de Identidad o Pasaporte</strong></font></td>
										<td>
											<table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
												<tr> 
												  <td height="20" align="center" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer2.dibujaCampo("CI_pas")%></font></td>
												</tr>
											</table>
										</td>
										<td>&nbsp;</td>
									  </tr>
									  <tr> 
										<td height="20" colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Licencia de Ense&ntilde;anza Media</strong></font></td>
										<td>
											<table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
												<tr> 
												  <td height="20" align="center" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer2.dibujaCampo("lic_EM")%></font></td>
												</tr>
											</table>
										</td>
										<td>&nbsp;</td>
									  </tr>
									  <tr> 
										<td height="20" colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Concentraci&oacute;n de Notas E.M.</strong></font></td>
										<td>
											<table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
												<tr> 
												  <td height="20" align="center" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer2.dibujaCampo("concen_notas")%></font></td>
												</tr>
											</table>
										</td>
										<td>&nbsp;</td>
									  </tr>
									  <tr> 
										<td height="20" colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Puntaje PAA / PSU</strong></font></td>
										<td>
											<table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
												<tr> 
												  <td height="20" align="center" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer2.dibujaCampo("ptje_paa_psu")%></font></td>
												</tr>
											</table>
										</td>
										<td>&nbsp;</td>
									  </tr>
									  <tr> 
										<td height="20" colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>2 Fotos tama&ntilde;o Carnet</strong></font></td>
										<td>
											<table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
												<tr> 
												  <td height="20" align="center" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer2.dibujaCampo("fotos_carnet")%></font></td>
												</tr>
											</table>
										</td>
										<td>&nbsp;</td>
									  </tr>
									  <tr> 
										<td height="20" colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Certificado de Residencia</strong></font></td>
										<td>
											<table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
												<tr> 
												  <td height="20" align="center" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer2.dibujaCampo("certif_residencia")%></font></td>
												</tr>
											</table>
										</td>
										<td>&nbsp;</td>
									  </tr>
									  <tr> 
										<td height="20" colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Seguro de Salud (Extranjeros)</strong></font></td>
										<td>
											<table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
												<tr> 
												  <td height="20" align="center" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=fDatosPer2.dibujaCampo("seguro_salud")%></font></td>
												</tr>
											</table>
										</td>
										<td>&nbsp;</td>
									  </tr>
									  <tr> 
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10" align="right">
											    <%POS_IMAGEN = POS_IMAGEN + 1%>
										   		<a href="javascript:_Navegar(this, 'javascript:irPagina2();', 'FALSE');"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_12.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_11.png';return true ">
												<img src="imagenes/IR_A_PAGINA_11.png" border="0" width="70" height="70" alt="VER INFORMACIÓN DE LA PÁGINA 1"> 
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
</table>
<%end if%>
</center>
</body>
</html>

