<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno_2008.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<% 
'------------------------------------------------------
q_leng 			= 	Request.QueryString("leng")
v_peri_cta		=	Request.QueryString("v_peri_cta")

if EsVacio(q_leng) then
	q_leng = "1"
end if

set conexion = new CConexion
conexion.Inicializar "upacifico"
set pagina = new CPagina

 set negocio = new CNegocio
 negocio.Inicializa conexion
 
  q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
  q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
  if esVacio(q_pers_nrut) then
	 q_pers_nrut = negocio.obtenerUsuario
	 q_pers_xdv = conexion.consultaUno("Select pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
  end if
  
  
q_peri_ccod = "228"

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "cuenta_corriente_alumno.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "cuenta_corriente_alumno.xml", "buscador"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.Siguiente

v_pers_ncorr = conexion.ConsultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar) = '" & q_pers_nrut & "'")
pers_ncorr = v_pers_ncorr

v_peri_ccod_pos = q_peri_ccod'negocio.ObtenerPeriodoAcademico("POSTULACION")
v_peri_ccod_18  = q_peri_ccod'negocio.ObtenerPeriodoAcademico("CLASES18")

if cint(v_peri_ccod_pos) < cint(v_peri_ccod_18) then
	v_peri_ccod = v_peri_ccod_18
else
	v_peri_ccod = v_peri_ccod_pos
end if
periodo = v_peri_ccod

' AGREGADO PARA MOSTRAR LAS CARRERAS A LAS QUE HA PERTENECIDO EL ALUMNO
'---------------------------------------------------------------------------------------------------
consulta_carreras = " select d.carr_tdesc as salida ,d.carr_ccod " & vbcrlf & _
				   " from alumnos a, ofertas_academicas b, especialidades c, carreras d " & vbcrlf & _
				   " where cast(a.pers_ncorr as varchar)='" & v_pers_ncorr & "' " & vbcrlf & _
                   " and a.emat_ccod=1 " & vbcrlf & _
				   " and a.ofer_ncorr=b.ofer_ncorr " & vbcrlf & _
				   " and b.espe_ccod=c.espe_ccod " & vbcrlf & _
				   " and c.carr_ccod=d.carr_ccod " & vbcrlf & _
                   " group by d.carr_ccod,d.carr_tdesc "				

'---------------------------------------------------------------------------------------------------
set f_periodos = new CFormulario
f_periodos.Carga_Parametros "cuenta_corriente_alumno.xml", "periodos_cta_cte"
f_periodos.Inicializar conexion
sql_periodos="select distinct peri_ccod from periodos_academicos "
f_periodos.Consultar sql_periodos

if v_pers_ncorr <> "" then
	f_periodos.AgregaCampoParam "peri_ccod", "filtro", " anos_ccod >= protic.ANO_INGRESO_UNIVERSIDAD("&v_pers_ncorr&")"
	f_periodos.AgregaCampoCons "peri_ccod", v_peri_cta
	
	sql_total_periodos=conexion.ConsultaUno("select count(*) from periodos_academicos where anos_ccod>= protic.ANO_INGRESO_UNIVERSIDAD("&v_pers_ncorr&")")
	
else

	f_periodos.AgregaCampoParam "peri_ccod", "filtro", "1=2"
	'f_periodos.AgregaCampoCons "peri_tdesc", "Seleccione "
	
end if
f_periodos.siguienteF
'---------------------------------------------------------------------------------------------------
set f_comentarios = new CFormulario
f_comentarios.Carga_Parametros "cuenta_corriente_alumno.xml", "lista_comentarios"
f_comentarios.Inicializar conexion
sql_comentarios ="Select come_ncorr,COME_FCOMENTARIO, SUBSTRING(COME_TCOMENTARIO,1,100)+'...' as COME_TCOMENTARIO,TICO_CCOD from comentarios where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"'"
f_comentarios.Consultar sql_comentarios
'---------------------------------------------------------------------------------------------------
set cuenta_corriente = new CCuentaCorriente
cuenta_corriente.Inicializar conexion, q_pers_nrut, v_peri_cta
if v_peri_cta <> "" then
	filtro="SI"
else
	filtro="NO"
end if
'---------------------------------------------------------------------------------------------------

'---------------------------------------------------------------------------------------------------
url_leng_1 = "cuenta_corriente_alumno.asp?buscador[0][pers_nrut]=" & q_pers_nrut & "&buscador[0][pers_xdv]=" & q_pers_xdv & "&leng=1&v_peri_cta="&v_peri_cta
url_leng_2 = "cuenta_corriente_alumno.asp?buscador[0][pers_nrut]=" & q_pers_nrut & "&buscador[0][pers_xdv]=" & q_pers_xdv & "&leng=2&v_peri_cta="&v_peri_cta
url_leng_3 = "cuenta_corriente_alumno.asp?buscador[0][pers_nrut]=" & q_pers_nrut & "&buscador[0][pers_xdv]=" & q_pers_xdv & "&leng=3&v_peri_cta="&v_peri_cta
'---------------------------------------------------------------------------------------------------

if v_peri_cta="" then
	v_peri_cta=v_peri_ccod
end if
'---------------------------------------------------------------------------------------------------
set persona = new CPersona
persona.Inicializar conexion, q_pers_nrut

set alumno = new CAlumno
es_alumno = false

if EsVacio(persona.ObtenerMatriculaPeriodo(v_peri_cta)) then
	sql_ultima_matricula="select max(peri_ccod) from postulantes a, alumnos b where a.post_ncorr=b.post_ncorr and cast(b.pers_ncorr as varchar)='"&v_pers_ncorr&"'"
	v_peri_ant=conexion.ConsultaUno(sql_ultima_matricula)
	if EsVacio(v_peri_ant) then ' no existe matricula para ningun periodo
		set f_datos = persona
		persona="SI"
	else ' busca matricula correspondiante a ultimo periodo cursado
		if EsVacio(persona.ObtenerMatriculaPeriodo(v_peri_ant)) then
			set f_datos = persona
			persona="SI"
		else
			es_alumno = true
			alumno.InicializarCarreras conexion, persona.ObtenerMatriculaPeriodo(v_peri_ant), v_peri_ant,v_peri_cta
			set f_datos = alumno
			persona="NO&periodo="&v_peri_ant&"&filtro="&filtro&"&peri_sel="&v_peri_cta
			'persona="NO&matr_ncorr="&persona.ObtenerMatriculaPeriodo(v_peri_ant)
		end if
	end if
else
	es_alumno = true
	alumno.InicializarCarreras conexion, persona.ObtenerMatriculaPeriodo(v_peri_cta), v_peri_cta,v_peri_cta
	set f_datos = alumno
	persona="NO&periodo="&v_peri_cta&"&filtro="&filtro&"&peri_sel="&v_peri_cta
	'persona="NO&matr_ncorr="&persona.ObtenerMatriculaPeriodo(v_peri_cta)
end if
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

var t_busqueda;

function InicioPagina()
{
	t_busqueda = new CTabla("buscador");
}


function Ficha_Alumno(){
	window.open("../MATRICULA/FICHA_ANTEC_PERSONALES.ASP?busqueda[0][pers_nrut]=<%=q_pers_nrut%>&busqueda[0][pers_xdv]=<%=q_pers_xdv%>&traspaso=1","nombre_pagina","scrollbars,  toolbar=false, resizable ");
}

function periodo_academico(periodo){
var v_peri;
v_peri=periodo;
	location.href="cuenta_corriente_alumno.asp?buscador[0][pers_nrut]=<%=q_pers_nrut%>&buscador[0][pers_xdv]=<%=q_pers_xdv%>&leng=<%=q_leng%>&v_peri_cta="+v_peri+"";
}

function nuevo_comentario(){
	window.open("crea_comentarios.asp?pers_ncorr=<%=v_pers_ncorr%>","nuevo_comentario"," width=750, height=400,scrollbars,  toolbar=false, resizable");
}

function ayuda (valor)
{ var mensaje="";
    mensaje = "AYUDA\nLa Cuenta corriente del alumno, despliega información sobre sus estados financieros, estado de pagos realizados y documentos que están por vencer. Navegando en ella se puede acceder a:\n\n" +
	       	  "Detalle de compromisos: Bajo esta opción se pueden ver todos los pagos relacionados con el alumno, estado de pagos, documentos relacionados.\n"+
		      "Becas y descuentos: Esta opción da cuenta de los descuentos o becas que beneficiaron al alumno, porcentaje de cobertura y montos totales.\n"+
		      "Comentarios: Da cuenta de observaciones y comentarios a los que se visto afecto el alumno tanto académica como financieramente.";
		   
		   
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
		<td width="100%" align="center"><font size="5" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>REVISIÓN DE CUENTA CORRIENTE</strong></font></td>
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
										   <td width="31%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Identificación alumno</strong></font></td>
										   <td width="59%"><hr></td>
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
								
									<table width="100%" border="0" cellpadding="1" cellspacing="3">
									  <form name="buscador">
									  <tr> 
										<td height="20"><%f_busqueda.DibujaCampo("pers_nrut")%>
														<%f_busqueda.DibujaCampo("pers_xdv")%>
										</td>
									  </tr>
									  </form>
									  <tr>
										  <td>
										  		 <% if v_pers_ncorr <> "" then %>
												  <table width="98%"  border="0" cellspacing="0" cellpadding="0">
													<tr>
													  <td align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%f_datos.DibujaDatos%></font></td>
													</tr>
													<tr>
														<td><font size="2" face="Courier New, Courier, mono" color="#496da6">
														                  <%if 	es_alumno = true then
																				f_datos.DibujaDatos2
																			end if
																			%></font>
														</td>
													</tr>
													<tr>
														<td>
														<% if sql_total_periodos > 0 then %>
														<form name="periodo">
															<table width="100%">
																<tr>
																	<td><br><hr></td>
																</tr>
																<tr>
																	<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>
																	Periodo academico :</strong><%=f_periodos.DibujaCampo("peri_ccod")%>
																	</font>
																	</td>
																</tr>
																<tr>
																	<td><hr></td>
																</tr>
															
															</table>
															</form>
															<% end if %>
														</td>
													</tr>
													<tr>
														<td align="right"><%POS_IMAGEN = POS_IMAGEN + 1%>
																			<a href="javascript:_Navegar(this, 'mensajes.asp', 'FALSE');"
																				onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
																				onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true ">
																				<img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> 
																			</a>
												        </td>
													</tr>
												  </table>
												  <%end if%>	
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
						<form name="edicion" action="carga_alumno.asp">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="28%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Estados Financieros</strong></font></td>
										   <td><hr></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
									    <tr>
										  <td colspan="4"><%pagina.DibujarLenguetasFClaro Array(Array("Detalle de compromisos", url_leng_1), Array("Becas y descuentos", url_leng_2), Array("Comentarios", url_leng_3)), CInt(q_leng) %></td>
										</tr>
										<tr><td colspan="4">&nbsp;</td></tr>
										<tr>
										    <td colspan="4">
										    </td>
									    </tr>
										<tr>
                          					<td colspan="4"> 
                            						<div align="left"><br>
														<%
														select case q_leng
															case "1"%>
																<table width="98%" cellpadding="0" cellspacing="0" align="center">
																<tr><td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>
																	Resumen</strong></font></td></tr>
																<tr><td><%cuenta_corriente.DibujaResumenCompromisos%></td></tr>
																</table>
																<%
														end select
														%>
                             							<br>
														<%
														select case q_leng
															case "1"%>
															    <table width="98%" cellpadding="0" cellspacing="0" align="center">
																<tr><td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>
																	Detalle de compromisos</strong></font></td></tr>
																</table>
															<%case "2"%>
															    <table width="98%" cellpadding="0" cellspacing="0" align="center">
																<tr><td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>
																	Becas y descuentos</strong></font></td></tr>
																</table>
														<%end select
														%>
                                                       </div>                            
                                                       <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
														<tr>
														  <td><div align="center">
																<%
																select case q_leng
																	case "1"
																		cuenta_corriente.DibujaDetalleCompromisos												
																	case "2"
																		cuenta_corriente.DibujaBecasDescuentos
																	case "3"%>
																		<div align="right"><%f_comentarios.AccesoPagina%></div>
																		<%
																		f_comentarios.DibujaTabla
																end select
																%>
														  </div></td>
														</tr>
														<tr>
														     <td align="right"><%POS_IMAGEN = POS_IMAGEN + 7%>
																			<a href="javascript:_Navegar(this, 'mensajes.asp', 'FALSE');"
																				onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
																				onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true ">
																				<img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> 
																			</a>
												             </td>
													    </tr>
                                                        </table>                            
														<br>	
							                  </td>
							               </tr>
										</table>
                  
								</td>
							</tr>
						  <input type="hidden" name="b[0][pers_nrut]" value="<%=q_pers_nrut%>"> 
						  <input name="b[0][pers_xdv]" type="hidden" value="<%=q_pers_xdv%>">
						  <input name="b[0][peri_ccod]" type="hidden" value="<%=q_peri_ccod%>">
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

