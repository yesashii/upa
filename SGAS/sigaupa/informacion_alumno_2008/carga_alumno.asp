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


consulta_periodo=" select max(b.peri_ccod) "&_
                 " from alumnos a, ofertas_academicas b,personas c "&_
				 " where a.pers_ncorr = c.pers_ncorr and cast(c.pers_nrut as varchar)='"&q_pers_nrut&"'" &_
				 " and a.ofer_ncorr = b.ofer_ncorr and exists (select 1 from cargas_academicas carg where carg.matr_ncorr= a.matr_ncorr) "
				 

q_peri_ccod = conexion.consultaUno(consulta_periodo)


if matr_ncorr = "" then
	consulta_matr=" Select top 1 b.matr_ncorr from personas a, alumnos b, ofertas_Academicas c" &_
	              " where a.pers_ncorr=b.pers_ncorr and b.ofer_ncorr=c.ofer_ncorr "&_
				  " and cast(c.peri_ccod as varchar)='"&q_peri_ccod&"' and cast(a.pers_nrut as varchar)='"&q_pers_nrut&"'"
				  	
	matr_ncorr= conexion.consultaUno(consulta_matr)	
end if


carrera = conexion.consultaUno("Select carr_ccod from alumnos a, ofertas_Academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast( matr_ncorr as varchar)='"&matr_ncorr&"'")

'---------------------------------------------------------------------------------------------------

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "carga_alumno.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "carga_alumno.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.siguiente

if q_pers_nrut <> "" then
	pers_ncorr_temporal=conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
end if
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv


'---------------------------------------------------------------------------------------------------
set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "carga_alumno.xml", "encabezado"
f_encabezado.Inicializar conexion

consulta = "select top 1 protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, b.plan_ccod, " & vbCrLf &_
           "       ltrim(rtrim(protic.obtener_nombre_carrera(b.ofer_ncorr, 'C'))) as carrera, protic.ano_ingreso_carrera(b.pers_ncorr, d.carr_ccod) as ano_ingreso_plan, cast(d.espe_nduracion as varchar) + ' Semestres' as duas_tdesc " & vbCrLf &_
		   "from personas a, alumnos b, ofertas_academicas c, especialidades d" & vbCrLf &_
		   "where a.pers_ncorr = b.pers_ncorr   " & vbCrLf &_
		   "  and b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
		   "  and c.espe_ccod = d.espe_ccod " 
		   if carrera <> "" then
		   		consulta=consulta & " and cast(d.carr_ccod as varchar)='"&carrera&"'"
		   else
				consulta=consulta & "  and b.ofer_ncorr = protic.ultima_oferta_matriculado(a.pers_ncorr) " 
		   end if
		   consulta=consulta &"  --and b.emat_ccod <> 9 " & vbCrLf &_
		   "  and cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "' "
		   
consulta_carrera= "(select distinct a.matr_ncorr , ltrim(rtrim(d.carr_tdesc)) as carr_tdesc " & vbCrLf &_
				  " from alumnos a, ofertas_academicas b, especialidades c, carreras d " & vbCrLf &_
				  " where cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' " & vbCrLf &_
				  " and a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
				  " and b.espe_ccod=c.espe_ccod " & vbCrLf &_
				  " and c.carr_ccod=d.carr_ccod  --and a.emat_ccod in (1,4,8)" & vbCrLf &_
				  " and exists (select 1 from cargas_academicas carg where carg.matr_ncorr = a.matr_ncorr)" & vbCrLf &_
				  " and cast(b.peri_ccod as varchar)='"&q_peri_ccod&"')s"
 				 
'response.Write("<pre>"&consulta_carrera&"</pre>")
f_encabezado.AgregaCampoParam "carreras_alumno","permiso","LECTURAESCRITURA"
f_encabezado.AgregaCampoParam "carrera","permiso","OCULTO"				 



'response.Write("<pre>"&consulta&"</pre>")
f_encabezado.Consultar consulta
f_encabezado.Siguiente
f_encabezado.AgregaCampoCons "carreras_alumno", matr_ncorr
f_encabezado.AgregaCampoParam "carreras_alumno","destino",consulta_carrera
v_plan_ccod = f_encabezado.ObtenerValor("plan_ccod")

'---------------------------------------------------------------------------------------------------
set f_ramos = new CFormulario
f_ramos.Carga_Parametros "carga_alumno.xml", "ramos"
f_ramos.Inicializar conexion

'response.Write("select protic.obtener_sql_notas('" & q_pers_nrut & "')")
'response.Write("q_solo_aprobadas "&q_solo_aprobadas)
consulta2 = "select distinct g.asig_ccod, g.asig_tdesc, g.asig_nhoras, f.secc_tdesc as seccion,protic.horario_con_sala(f.secc_ccod) as horario " & vbCrLf &_
			" from bloques_horarios a, salas b, tipos_sala c, cargas_academicas d, personas e, secciones f, asignaturas g " & vbCrLf &_
			" where a.sala_ccod =b.sala_ccod " & vbCrLf &_
			"	and a.pers_ncorr =e.pers_ncorr " & vbCrLf &_
			"	and a.secc_ccod=f.secc_ccod" & vbCrLf &_
			"	and f.asig_ccod=g.asig_ccod" & vbCrLf &_
			"	and b.tsal_ccod=c.tsal_ccod " & vbCrLf &_
			"	and a.secc_ccod=d.secc_ccod" & vbCrLf &_
			"	and not exists (select 1 from convalidaciones conv where d.matr_ncorr=conv.matr_ncorr and f.asig_ccod=conv.asig_ccod) " & vbCrLf &_
			"	and cast(d.matr_ncorr as varchar)= '"&matr_ncorr&"'"
			
consulta2 = " select distinct g.asig_ccod, g.asig_tdesc, g.asig_nhoras, f.secc_tdesc as seccion,protic.horario_con_sala(f.secc_ccod) as horario " & vbCrLf &_
			" from bloques_horarios a,cargas_academicas d,secciones f, asignaturas g " & vbCrLf &_
			" where  a.secc_ccod=f.secc_ccod " & vbCrLf &_
			"	and f.asig_ccod=g.asig_ccod " & vbCrLf &_
			"	and a.secc_ccod=d.secc_ccod " & vbCrLf &_
			"	and not exists (select 1 from convalidaciones conv where d.matr_ncorr=conv.matr_ncorr and f.asig_ccod=conv.asig_ccod) " & vbCrLf &_
			"	and cast(d.matr_ncorr as varchar)= '"&matr_ncorr&"'"
			
'response.Write("<pre>"&consulta2&"</pre>")
f_ramos.Consultar consulta2
'f_ramos.siguiente   
nombre_carrera=f_encabezado.obtenerValor("carrera")


 
 

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
function dibujar(formulario)
{
	formulario.submit();
}
function horario(){
	self.open('horario_alumno.asp?matr_ncorr=<%=matr_ncorr%>','horario','width=700px, height=550px, scrollbars=yes, resizable=yes')
}

function ayuda (valor)
{ var mensaje="";
    mensaje = "AYUDA\nLa función horario o carga académica del alumno da cuenta de las asignaturas inscritas para el alumno en la última matrícula que este registre en la Universidad.\n" +
	       	  "Junto con ver las asignaturas podrá acceder a imprimir su horario de clases (si la matrícula es igual o mayor al 1er semestre 2008).";
		   
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
		<td width="100%" align="center"><font size="5" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>CARGA ACADEMICA DEL ALUMNO</strong></font></td>
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
										   <td width="28%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Carrera a Consultar</strong></font></td>
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
								<form name="buscador">
									<table width="100%" border="0" cellpadding="1" cellspacing="3">
									  <tr> 
										<td width="16%" height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Carrera :</strong></font></td>
										<td colspan="3" align="left"><%f_encabezado.DibujaCampo("carrera")%>
											                         <%f_encabezado.DibujaCampo("carreras_alumno")%>
							            </td>
									  </tr>
									  <tr valign="top"> 
										<td height="10">&nbsp;</td>
										<td width="61%" height="10">&nbsp;</td>
										<td width="12%" height="10">&nbsp;</td>
										<td width="11%" height="10" align="center">
																			<%POS_IMAGEN = POS_IMAGEN + 1%>
																			<a href="javascript:_Navegar(this, 'mensajes.asp', 'FALSE');"
																				onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
																				onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true ">
																				<img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> 
																			</a>
										</td>
									  </tr>
								  </table>
                                  </form>
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
										   <td width="28%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Asignaturas a cursar</strong></font></td>
										   <td><hr></td>
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
									  <tr><td height="20" colspan="4">&nbsp;</td></tr>
									  <tr><td align="center" colspan="4"><%f_ramos.DibujaTabla%></td></tr>
									  <tr><td height="20" colspan="4">&nbsp;</td></tr>
									  <tr valign="middle"> 
										<td height="10">&nbsp;</td>
										<td height="10" align="right">
											                 <%POS_IMAGEN = POS_IMAGEN + 1%>
															 <a href="javascript:horario();"
																onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/HORARIO2.png';return true "
																onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/HORARIO1.png';return true ">
																<img src="imagenes/HORARIO1.png" border="0" width="70" height="70" alt="VER HORARIO DE CLASES"> 
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

