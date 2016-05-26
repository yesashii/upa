<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno_2008.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<% 
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO:
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:28/02/2013
'ACTUALIZADO POR		:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			:59 - 98
'********************************************************************
'------------------------------------------------------
plan_ccod		= 	request.querystring("ch[0][plan_ccod]")

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
  
q_peri_ccod = "228"

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "notas_alumno.xml", "botonera"
'---------------------------------------------------------------------------------------------------

if plan_ccod=""  then
'	consulta_actual_plan="  select  distinct cast(f.espe_ccod as varchar)+ '-' + cast(f.plan_ccod as varchar)+ '-' + cast(d.carr_ccod as varchar) as parametro " & vbcrlf &_
'						 "	from personas a, alumnos b,ofertas_academicas c,especialidades d,carreras e,planes_estudio f,cargas_academicas g" & vbcrlf &_
'						 " where cast(pers_nrut as varchar)='"&q_pers_nrut&"'" & vbcrlf &_
'						 " and a.pers_ncorr=b.pers_ncorr" & vbcrlf &_
'						 " and b.ofer_ncorr=c.ofer_ncorr" & vbcrlf &_
'						 " and b.matr_ncorr *= g.matr_ncorr" & vbcrlf &_
'						 " and c.espe_ccod=d.espe_ccod" & vbcrlf &_
'						 " and d.carr_ccod=e.carr_ccod" & vbcrlf &_
'					 	 "and b.plan_ccod=f.plan_ccod "

	consulta_actual_plan="  select  distinct cast(f.espe_ccod as varchar)+ '-' + cast(f.plan_ccod as varchar)+ '-' + cast(d.carr_ccod as varchar) as parametro " & vbcrlf &_
						 "	from personas a INNER JOIN alumnos b " & vbcrlf &_
						 " ON a.pers_ncorr=b.pers_ncorr AND cast(pers_nrut as varchar)='"&q_pers_nrut&"'" & vbcrlf &_
						 " INNER JOIN ofertas_academicas c " & vbcrlf &_
						 " ON b.ofer_ncorr=c.ofer_ncorr " & vbcrlf &_
						 " LEFT OUTER JOIN cargas_academicas g " & vbcrlf &_
						 " ON b.matr_ncorr = g.matr_ncorr " & vbcrlf &_
						 " INNER JOIN especialidades d " & vbcrlf &_
						 " ON c.espe_ccod=d.espe_ccod " & vbcrlf &_
						 " INNER JOIN carreras e " & vbcrlf &_
						 " ON d.carr_ccod=e.carr_ccod " & vbcrlf &_
						 " INNER JOIN planes_estudio f " & vbcrlf &_
						 "ON b.plan_ccod=f.plan_ccod "
					 
	plan_ccod = conexion.consultaUno(consulta_actual_plan) 
end if 

set historico	=	new cHistoricoNotas
set combo_b		= 	new cformulario
'response.End()
combo_b.inicializar			conexion
combo_b.carga_parametros	"notas_alumno.xml","combo"
combo_b.consultar			"select '' as salida, '' as parametro"

'combo_b.agregacampoparam	"plan_ccod","destino","(select  distinct a.pers_nrut,e.carr_ccod, " & vbcrlf &_
'							"                       protic.initCap(e.carr_tdesc + '-' + d.espe_tdesc)  AS salida,    " & vbcrlf &_
'							"						cast(f.espe_ccod as varchar)+ '-' + cast(f.plan_ccod as varchar)+ '-' + cast(e.carr_ccod as varchar) as parametro " & vbcrlf &_
'							"						from personas a, alumnos b,ofertas_academicas c,especialidades d,carreras e,planes_estudio f,cargas_academicas g " & vbcrlf &_
'							"                       where cast(pers_nrut as varchar)='"&q_pers_nrut&"' " & vbcrlf &_
'							"						and a.pers_ncorr=b.pers_ncorr" & vbcrlf &_
'							"						and b.ofer_ncorr=c.ofer_ncorr" & vbcrlf &_
'    						"						and b.matr_ncorr *= g.matr_ncorr" & vbcrlf &_
'							"						and c.espe_ccod=d.espe_ccod" & vbcrlf &_
'							"						and d.carr_ccod=e.carr_ccod" & vbcrlf &_
'							"						and b.plan_ccod=f.plan_ccod) a"

combo_b.agregacampoparam	"plan_ccod","destino","(select  distinct a.pers_nrut,e.carr_ccod, " & vbcrlf &_
							"                       protic.initCap(e.carr_tdesc + '-' + d.espe_tdesc)  AS salida,    " & vbcrlf &_
							"						cast(f.espe_ccod as varchar)+ '-' + cast(f.plan_ccod as varchar)+ '-' + cast(e.carr_ccod as varchar) as parametro " & vbcrlf &_
							"						from personas a INNER JOIN alumnos b " & vbcrlf &_
							"						ON a.pers_ncorr=b.pers_ncorr AND cast(pers_nrut as varchar)='"&q_pers_nrut&"' " & vbcrlf &_
							"						INNER JOIN ofertas_academicas c " & vbcrlf &_
							"						ON b.ofer_ncorr=c.ofer_ncorr " & vbcrlf &_
							"						LEFT OUTER JOIN cargas_academicas g " & vbcrlf &_
							"						ON b.matr_ncorr = g.matr_ncorr " & vbcrlf &_
							"						INNER JOIN especialidades d " & vbcrlf &_
							"						ON c.espe_ccod = d.espe_ccod " & vbcrlf &_
							"						INNER JOIN carreras e " & vbcrlf &_
							"						ON d.carr_ccod = e.carr_ccod " & vbcrlf &_
							"						INNER JOIN planes_estudio f " & vbcrlf &_
							"						ON b.plan_ccod = f.plan_ccod ) a"
combo_b.siguiente
combo_b.agregacampocons		"plan_ccod", plan_ccod

if plan_ccod <> "" then 
	variables		=	split(plan_ccod,"-")
	plan			=	variables(1)
	especialidad	=	variables(0)
'	carrera			=	mid(especialidad,1,2)
	carrera			=   variables(2)
	historico.inicializar	conexion, q_pers_nrut, plan, especialidad, carrera
	'response.write(  rut  &"'='" &  plan  &"'='" & especialidad &"'='" & carrera )
end if

'---------------------------------------------------------------------------------------------------
set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "notas_alumno.xml", "encabezado"
f_encabezado.Inicializar conexion

consulta = "select top 1 protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, b.plan_ccod, " & vbCrLf &_
           "       ltrim(rtrim(protic.obtener_nombre_carrera(b.ofer_ncorr, 'C'))) as carrera, protic.ano_ingreso_carrera_egresa2(b.pers_ncorr, d.carr_ccod) as ano_ingreso_plan, cast(d.espe_nduracion as varchar) + ' Semestres' as duas_tdesc " & vbCrLf &_
		   "from personas a, alumnos b, ofertas_academicas c, especialidades d" & vbCrLf &_
		   "where a.pers_ncorr = b.pers_ncorr   " & vbCrLf &_
		   "  and b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
		   "  and c.espe_ccod = d.espe_ccod "  & vbCrLf &_
		   "  and b.ofer_ncorr = protic.ultima_oferta_matriculado(a.pers_ncorr) "  & vbCrLf &_
		   "  and b.emat_ccod <> 9 " & vbCrLf &_
		   "  and cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "' "
		   
'response.Write("<pre>"&consulta&"</pre>")
f_encabezado.Consultar consulta
f_encabezado.Siguiente

v_plan_ccod = f_encabezado.ObtenerValor("plan_ccod")
nombre_carrera=f_encabezado.obtenerValor("carrera")

f_botonera.agregaBotonParam "concentracion_notas","url","notas_parciales_alumno.asp"
f_botonera.agregaBotonParam "concentracion_notas","texto","Volver a notas Parciales"

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Notas parciales del alumno</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_alumnos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
colores = Array(3);
colores[0] = '';
colores[1] = '#FFECC6';
colores[2] = '#FFECC6';
	
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
function dibujar(formulario)
{
	formulario.submit();
}
function horario(){
	self.open('horario_alumno.asp?matr_ncorr=<%=matr_ncorr%>','horario','width=700px, height=550px, scrollbars=yes, resizable=yes')
}

function ayuda (valor)
{ var mensaje="";
    mensaje = "AYUDA\nLa función de calificaciones históricas: permite al alumnos hacer revisiones históricas de cumplimiento de plan de estudios, revisar ramos probados y reprobados, además entrega información de: \n\n" +
	       	  "- Cantidad de oportunidades que ha dado una asignatura hasta aprobarla.\n"+
			  "- Asignaturas reprobadas por año.\n"+
			  "- Convalidaciones y homologaciones realizadas.";
		   
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
		<td width="100%" align="center"><font size="5" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>Calificaciones Históricas del alumno</strong></font></td>
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
						<form name="buscador" action="notas_alumno.asp">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="28%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Asignaturas a cursar</strong></font></td>
										   <td><hr></td>
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
									  <tr> 
										<td height="20" width="10%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Rut</strong></font></td>
										<td width="40%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%f_encabezado.DibujaCampo("rut")%></font></td>
										<td width="10%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Nombre</strong></font></td>
										<td width="40%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%f_encabezado.DibujaCampo("nombre")%></font></td>
									  </tr>
									  <tr> 
										<td height="20" width="10%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Carrera</strong></font></td>
										<td width="40%" colspan="3"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%=nombre_carrera%></font></td>
									  </tr>
									  <tr> 
										<td height="20" width="10%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Duraci&oacute;n</strong></font></td>
										<td width="40%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%f_encabezado.DibujaCampo("duas_tdesc")%></font></td>
										<td width="10%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Año Ingreso</strong></font></td>
										<td width="40%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%f_encabezado.DibujaCampo("ano_ingreso_plan")%></font></td>
									  </tr> 
									  <tr> 
										<td height="20" width="10%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Programa</strong></font></td>
										<td width="40%" colspan="3"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%combo_b.dibujacampo("plan_ccod")%></font></td>
									  </tr>                       
									  <tr><td height="20" colspan="4">&nbsp;</td></tr>
									  <tr> 
										<td height="10">&nbsp;</td>
										<td height="10" align="right">
											                 <%POS_IMAGEN = POS_IMAGEN + 1%>
															 <a href="javascript:_Navegar(this, 'notas_parciales_alumno.asp', 'FALSE');"
																onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/NOTAS4.png';return true "
																onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/NOTAS3.png';return true ">
																<img src="imagenes/NOTAS3.png" border="0" width="70" height="70" alt="VER CALIFICACIONES PARCIALES"> 
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
										   <td width="28%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Asignaturas históricas</strong></font></td>
										   <td><hr></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
									  <tr>
									     <td height="20" colspan="4" align="center">
									  			<%if plan_ccod <> "" then
													historico.dibuja
													else %>
													  <table class="v1" border="1" borderColor="#999999" bgColor="#adadad" cellspacing="0" cellspading="0" width="98%">
													  <tr align="center" bgColor="#c4d7ff">
														<TH><FONT color=#333333>Nivel</FONT></TH>
														<TH><FONT color=#333333>C&oacute;digo Asignatura</FONT></TH>
														<TH><FONT color=#333333>Asignatura</FONT></TH>
														<TH><FONT color=#333333>1 oportunidad</FONT></TH>
														<TH><FONT color=#333333>2 oportunidad</FONT></TH>
														<TH><FONT color=#333333>3 oportunidad</FONT></TH>
													  </tr>
													  <tr bgcolor="#FFFFFF">
														<td colspan="6" align="center" class=noclick onmouseover=resaltar(this) onmouseout=desResaltar(this)>No hay datos asociados a los parametros de b&uacute;squeda.</td>
													  </tr>
													</table>
													<%
												end if%>
									  	  </td>
									  </tr>
									  <tr> 
										<td height="10">&nbsp;</td>
										<td height="10" align="right">
											                 <%POS_IMAGEN = POS_IMAGEN + 1%>
															 <a href="javascript:_Navegar(this, 'notas_parciales_alumno.asp', 'FALSE');"
																onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/NOTAS4.png';return true "
																onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/NOTAS3.png';return true ">
																<img src="imagenes/NOTAS3.png" border="0" width="70" height="70" alt="VER CALIFICACIONES PARCIALES"> 
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

