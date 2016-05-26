<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno_2008.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<% 
'------------------------------------------------------
pers_ncorr = request.querystring("pers_ncorr")
secc_ccod = request.querystring("secc_ccod")
pers_ncorr_profesor = request.querystring("pers_ncorr_docente")

set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

if len(secc_ccod)=0 then
	secc_ccod = Session("secc_ccod")
	pers_ncorr_profesor	 =  Session("pers_ncorr_profesor")
end if
 
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
if q_pers_nrut = "" then
	 q_pers_nrut = negocio.obtenerUsuario
	 q_pers_xdv = conectar.consultaUno("Select pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
end if

if pers_ncorr = "" then
	pers_ncorr= conectar.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
end if

if pers_ncorr <> "" and secc_ccod <> "" and pers_ncorr_profesor <> "" then
	Session("pers_ncorr") = pers_ncorr
	Session("secc_ccod") = secc_ccod
	Session("pers_ncorr_profesor") = pers_ncorr_profesor
end if

peri_ccod_encuesta =  conectar.consultaUno("select peri_ccod from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")
duas_ccod_encuesta =  conectar.consultaUno("select duas_ccod from secciones a, asignaturas b where a.asig_ccod=b.asig_ccod and cast(secc_ccod as varchar)='"&secc_ccod&"'")


'------------------buscamos que datos vamos mostrar en el encabezado de la encuesta
c_carr_ccod= "select carr_ccod from alumnos a, ofertas_academicas b, especialidades c where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(b.peri_ccod as varchar)='"&peri_ccod_encuesta&"' and a.emat_ccod=1 "
carr_ccod=conectar.consultaUno(c_carr_ccod)
carrera=conectar.consultaUno("select protic.initCap(carr_tdesc) from carreras where carr_ccod ='"&carr_ccod&"'")
asignatura=conectar.consultaUno("select protic.initCap(b.asig_tdesc) from secciones a, asignaturas b where a.asig_ccod=b.asig_ccod and cast(a.secc_ccod as varchar)='"&secc_ccod&"'") 
cod_asignatura=conectar.consultaUno("select asig_ccod from secciones a where cast(a.secc_ccod as varchar)='"&secc_ccod&"'") 
seccion=conectar.consultaUno("select secc_tdesc from secciones a where cast(a.secc_ccod as varchar)='"&secc_ccod&"'")
periodo=conectar.consultaUno("select peri_ccod from secciones a where cast(a.secc_ccod as varchar)='"&secc_ccod&"'")
plec_ccod_enc = conectar.consultaUno("select plec_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
ano_ingreso = conectar.consultaUno("select protic.ano_ingreso_carrera("&pers_ncorr&",'"&carr_ccod&"')")
'response.Write("select protic.ano_ingreso_carrera("&pers_ncorr&",'"&carr_ccod&"')")
profesor = conectar.consultaUno("select protic.initCap(pers_tnombre + ' ' + pers_tape_paterno + ' ' +pers_tape_materno) from personas where cast(pers_ncorr as varchar)='"&pers_ncorr_profesor&"'")
estado = ""
consulta = " select count(*) " &_
           " from evaluacion_docente where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"'"
estado = conectar.consultaUno(consulta)
if estado <> "0" then 
	estado = "2"
else
	consulta = " select isnull(estado_cuestionario,1) " &_
          	   " from cuestionario_opinion_alumnos where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_profesor as varchar)='"&pers_ncorr_profesor&"'"
	estado = conectar.consultaUno(consulta)
end if	
if len(estado) = 0 then
	estado = "1"
end if 
'response.Write(estado)
estado = "1"
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
  var plec = '<%=plec_ccod_enc%>';
  /*if (plec == '2')
    { 
	  alert("El proceso de evaluación docente 2do Semestre se abrirá a mediados del semestre.");
	}
  else
    {*/ 
  document.edicion.submit();
	//}
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
						<form name="edicion" action="contestar_evaluacion_docente_2008_proc.asp" method="post">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="95%"><hr style="color:#4b73a6;"></td>
										   <td width="5%" align="center"><div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#990000"><strong>Paso 1/6</strong></font></div></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="98%" cellpadding="0" cellspacing="0">
									<tr>
										<td width="100%" align="left">
											<font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">Estimado/a estudiante:</font>
										</td>
									</tr>
									<tr>
										<td width="100%" align="left">&nbsp;</td>
									</tr>
									<%if estado = "2" then%>
										<tr>
											<td width="100%" align="center">
											<table width="70%" cellpadding="0" cellspacing="0">
											<tr>
												<td width="100%" bgcolor="#CC0000" align="center">
													<font size="2" color="#FFFFFF" face="Verdana, Arial, Helvetica, sans-serif">
														La evaluación docente del profesor, para esta asignatura ya se encuentra completada.<br><b>...Muchas Gracias...</b>
													</font>
												</td>
											</tr>
											</table>
											</td>
										</tr>
										<tr>
											<td width="100%" align="left">&nbsp;</td>
										</tr>
									<%End if%>
									<tr>
										<td width="100%" align="left">
											<div align="justify">
												<font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
													El siguiente cuestionario tiene como propósito recoger información acerca de tus percepciones sobre 
													la docencia desarrollada por tu profesor/a en esta asignatura. La información que entregues le servirá 
													como retroalimentación para mejorar su docencia, por lo cual es muy importante que contestes en la forma 
													más objetiva posible.
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
												Queremos asegurarte que tu participación es anónima y no hay respuestas correctas o incorrectas.
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
												Agradecemos tu tiempo y colaboración.
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
													Vicerrectoría Académica
												</font>
											</div>
										</td>
									</tr>
									<tr>
										<td width="100%" align="left">&nbsp;</td>
									</tr>
									<tr>
										<td width="100%" align="left">&nbsp;</td>
									</tr>
									<tr>
										<td width="100%" align="left">
											<div align="justify">
												<font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
													<strong>PARTE I<br>
													Antecedentes del Estudiante
													</strong>
												</font>
											</div>
										</td>
									</tr>
									<tr>
										<td width="100%" align="left">&nbsp;</td>
									</tr>
									<tr>
										<td width="100%" align="left">
											<font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
													<strong>1. Carrera que cursa:</strong> <%=carrera%>
												</font>
										</td>
									</tr>
									<tr>
										<td width="100%" align="left">
											<font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
													<strong>2. Año que ingreso a la carrera:</strong> <%=ano_ingreso%>
												</font>
										</td>
									</tr>
									<tr>
										<td width="100%" align="left">
											<font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
													<strong>Antecedentes de la asignatura</strong>
												</font>
										</td>
									</tr>
									<tr>
										<td width="100%" align="left">
											<font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
													<strong>3. Nombre de la asignatura:</strong> <%=asignatura%>
												</font>
										</td>
									</tr>
									<tr>
										<td width="100%" align="left">
											<font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
													<strong>4. Código:</strong> <%=cod_asignatura%>
												</font>
										</td>
									</tr>
									<tr>
										<td width="100%" align="left">
											<font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
													<strong>5. Nombre profesor:</strong> <%=profesor%>
												</font>
										</td>
									</tr>
									<tr>
										<td width="100%" align="left">&nbsp;</td>
									</tr>
									
									<tr>
										<td width="100%" align="left">&nbsp;</td>
									</tr>
									<tr>
										<td width="100%" align="center">
											<table width="30%" cellpadding="0" cellspacing="0">
												<tr>
												    <td width="50%" align="center">
														<%POS_IMAGEN = 0%>
														<a href="javascript:_Navegar(this, 'seleccionar_docente_2008.asp', 'FALSE');"
															onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
															onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true ">
															<img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> 
														</a>
													</td>
													<td width="50%" align="center">
													<%
													   if estado = "2" then%>
													     &nbsp;
													   <%else%>
														<%POS_IMAGEN = POS_IMAGEN + 1%>
														<a href="javascript:validar_ingreso();"
															onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SIGUIENTE2.png';return true "
															onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SIGUIENTE1.png';return true ">
															<img src="imagenes/SIGUIENTE1.png" border="0" width="70" height="70" alt="IR A PAGINA 2"> 
														</a>
													<%end if%>
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

