<!-- #include file = "../biblioteca/_conexion.asp" -->

<%

'---------------------------------------------------------------------------------------------------
'set pagina = new CPagina
'pagina.Titulo = "ENCUESTA PARA EMPLEADORES"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"


'---------------------------------------------------------------------------------------------------
rut = request.querystring("busqueda[0][pers_nrut]")
digito = request.querystring("busqueda[0][pers_xdv]")
'--------------------------------------------------------------------------

 rute = rut
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "encuestas_acreditacion_publicidad.xml", "busqueda_usuarios"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' "
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut
 f_busqueda.AgregaCampoCons "pers_xdv", digito
'--------------------------------------------------------------------------
'response.Write(rut)
if rut <> "" then
    pers_ncorr= conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&rut&"'")
end if

'response.Write(cantidad_carreras)

	pers_nrut = rut
	pers_ncorr= conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'")
	nombre= conexion.consultaUno("Select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
	rut = conexion.consultaUno("Select cast(pers_nrut as varchar)+ '-' + pers_xdv from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
	edad = conexion.consultaUno("Select datediff(year,pers_fnacimiento,getDate()) from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
	sexo = conexion.consultaUno("Select sexo_tdesc from personas a, sexos b where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and a.sexo_ccod=b.sexo_ccod")
	ano_ingreso = conexion.consultaUno("select min(anos_ccod) from alumnos a, ofertas_academicas b, especialidades c, periodos_academicos d where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod  and b.peri_ccod = d.peri_ccod")
	ano_fin = conexion.consultaUno("select max(anos_ccod) from alumnos a, ofertas_academicas b, especialidades c, periodos_academicos d where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod  and b.peri_ccod = d.peri_ccod")


set f_botonera = new CFormulario
f_botonera.Carga_Parametros "encuestas_acreditacion_publicidad.xml", "botonera_egresados"

devuelto = request.QueryString("devuelto")

contestada = conexion.consultaUno("select count(*) from encuesta_publicidad_egresados where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and isnull(antiguos,'N')='N'")

'response.Write("select count(*) from alumnos a, ofertas_academicas b, especialidades c where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod  and emat_ccod in (1,2,4,8)")
cantidad_matriculas = conexion.consultaUno("select count(*) from alumnos a, ofertas_academicas b, especialidades c where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod  and emat_ccod in (1,2,4,8) and c.carr_ccod='45'")

%>


<html>
<head>
<title>ENCUESTA PARA EGRESADOS</title>
<link href="../estilos/estilos.css" rel=stylesheet type="text/css">
<link href="../estilos/tabla.css" rel=stylesheet type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function Validar2()
{
// se retornara true hasta definir bien que campos se desea validar que sean obligatorios
if (confirm("¿Esta seguro que desea grabar y enviar la encuesta?.\n Una vez grabada, no podrá realizar cambios en ella."))
    { return true;}
else
	{return false;}	
}
function Validar()
{
	formulario = document.buscador;
	
	rut_alumno = formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value;	
	if (formulario.elements["busqueda[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].focus();
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	  }
	
	
	return true;
}

</script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"></head>

<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%'pagina.DibujarEncabezado()%> 
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
                              <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador 
                                </font></div></td>
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
                      <td bgcolor="#D8D8DE"><div align="center"> 
                          <form name="buscador">
                            <table width="98%"  border="0">
                              <tr> 
                                <td width="81%"><table width="524" border="0">
                                    <tr> 
                                      <td width="98">Rut Alumno</td>
                                      <td width="23">:</td>
                                      <td width="389"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                        <%f_busqueda.DibujaCampo("pers_nrut") %>
                                        - 
                                        <%f_busqueda.DibujaCampo("pers_xdv")%>
                                        </font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
                                    </tr>
                                  </table></td>
                                <td width="19%"><div align="center"> 
                                    <%f_botonera.DibujaBoton "buscar" %>
                                  </div></td>
                              </tr>
                            </table>
                          </form>
                        </div></td>
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
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
             <tr>
            <td><%if rute = "" then %>
			    <div align="center"><br><font size="2" face="Times New Roman, Times, serif">Haga el favor de ingresar su <strong>RUT</strong> y presione 'Buscar', para localizar la información que tengamos sobre usted, datos necesarios para poder contestar la encuesta de acreditación.</font><br>
                </div><br>
				<%else
				 if cantidad_matriculas = "0" then 
				%>
				<div align="center"><br><font size="+1" face="Times New Roman, Times, serif">Lo sentimos pero no hemos encontrado ninguna matricula de usted para nuestra casa de estudios. Sólo alumnos de la carrera de Publicidad de la Universidad pueden contestar la encuesta.</font><br>
                </div><br>
				<%else%>
			    <div align="center"><br><font size="+1" face="Times New Roman, Times, serif"><strong>ENCUESTA PARA EGRESADOS</strong></font><br>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>
					   <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <%if devuelto="1" then%>
						<tr>
                          <td bgcolor="#0066CC"><div align="center"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><strong>La Encuesta, por usted ingresada, ha sido grabada exitosamente</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<%end if%>
						<tr>
                          <td><div align="center">Fecha de Aplicación de la Encuesta <%=Date%></div></td>
                        </tr>
                        <tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
                        <tr>
                          <td><div align="justify">Esta encuesta está diseñada para optimizar los mecanismos de autoevaluación de las instituciones de educación superior chilenas. Su aporte, al responder este cuestionario, será muy valioso para la Escuela de Publicidad de la Universidad del Pacífico. La encuesta sólo será utilizada con fines de diagnóstico de la carrera de Publicidad, como parte del proceso de autoevaluación en la que se encuentra.</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="justify">Como egresado, se le solicita que evalúe distintos aspectos de la carrera en la que usted estudió y de la formación recibida. </div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="100%" border="0">
													  <tr>
													       <td width="9%" align="left"><strong>Alumno</strong></td>
														   <td width="1%" align="center"><strong>:</strong></td>
														   <td width="40%" align="left"><%=nombre%></td>
														   <td width="9%" align="right"><strong>Rut</strong></td>
														   <td width="1%" align="center"><strong>:</strong></td>
														   <td width="40%" align="left"><%=rut%></td>
													  </tr>
       											  </table>
				              </div>
						  </td>
                        </tr>
						
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<%if contestada <> "0" then%>
						<tr>
                          <td><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Lo Sentimos pero no puede volver a contestar la encuesta de Acreditación de la Universidad, muchas gracias por su colaboración en dicho proceso.</strong></font></div></td>
                        </tr>
						<%else%>
						<tr>
                          <td><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>SECCIÓN I:<br>DATOS GENERALES</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">1. Edad.</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">  <input type="text" maxlength="2" size="5" name="e[0][edad_alumno]" value="" id="NU-N"> Años</div>
						                          <input type="hidden" maxlength="10" size="10" name="e[0][pers_ncorr]" value="<%=pers_ncorr%>" id="NU-N">
						   </td>  
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">2. Sexo.</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="50%"><div align="center"><input type="radio" name="e[0][sexo]" value="1"></div></td>
													   <td width="50%"><div align="center"><input type="radio" name="e[0][sexo]" value="2"></div></td>
  													<tr>
													<tr>
													   <td width="50%"><div align="center">a. Femenino</div></td>
													   <td width="50%"><div align="center">b. Masculino</div></td>
    												<tr>
    											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;<input type="hidden" name="e[0][carr_ccod]" value="45"></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">3. Condición de egreso (marque la o las etapas de egreso cumplidas).</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="50%"><div align="center"><input type="radio" name="e[0][condicion_egreso]" value="1"></div></td>
													   <td width="50%"><div align="center"><input type="radio" name="e[0][condicion_titulado]" value="1"></div></td>
  													<tr>
													<tr>
													   <td width="50%"><div align="center">a. Egresado(a)</div></td>
													   <td width="50%"><div align="center">b. Titulado(a)</div></td>
    												<tr>
    											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">4. Período en el que estudió la carrera:</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="50%"><div align="center"><input type="text" name="e[0][ano_inicio]" value="" maxlength="4" size="10" id="NU-N"></div></td>
													   <td width="50%"><div align="center"><input type="text" name="e[0][ano_final]" value="" maxlength="4" size="10" id="NU-N"></div></td>
  													<tr>
													<tr>
													   <td width="50%"><div align="center">a. Año inicio</div></td>
													   <td width="50%"><div align="center">b. Año final</div></td>
    												<tr>
    											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">5. Actualmente, ¿está usted trabajando? (considere por trabajo cualquier actividad remunerada de por lo menos media jornada de dedicación).</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="50%"><div align="center"><input type="radio" name="e[0][trabajando]" value="1"></div></td>
													   <td width="50%"><div align="center"><input type="radio" name="e[0][trabajando]" value="2"></div></td>
  													<tr>
													<tr>
													   <td width="50%"><div align="center">a. S&iacute;</div></td>
													   <td width="50%"><div align="center">b. No</div></td>
    												<tr>
    											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">6. Desde que comenzó a buscar trabajo, luego de egresar, ¿cuánto tiempo se demoró en encontrar su primer trabajo?.</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][tiempo_demora]" value="5"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][tiempo_demora]" value="4"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][tiempo_demora]" value="3"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][tiempo_demora]" value="2"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][tiempo_demora]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="20%"><div align="center">a. Menos de 2 meses.</div></td>
													   <td width="20%"><div align="center">b. Entre 2 meses y 6 meses.</div></td>
													   <td width="20%"><div align="center">c. Entre 6 meses y 1 año.</div></td>
													   <td width="20%"><div align="center">d. Más de 1 año.</div></td>
													   <td width="20%"><div align="center">e. No he encontrado trabajo.</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">7. Si está trabajando actualmente, señale la renta promedio (líquida) mensual que está obteniendo, de acuerdo a los rangos indicados:</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][renta_promedio]" value="5"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][renta_promedio]" value="4"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][renta_promedio]" value="3"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][renta_promedio]" value="2"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][renta_promedio]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="20%"><div align="center">a. Menos de $200.000.</div></td>
													   <td width="20%"><div align="center">b. Entre $200.001 y $500.000.</div></td>
													   <td width="20%"><div align="center">c. Entre $500.001 y 1.000.000.</div></td>
													   <td width="20%"><div align="center">d. Entre $1.000.001 y $1.500.000.</div></td>
													   <td width="20%"><div align="center">e. Más de $1.500.001.</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">8. Si está trabajando actualmente, escriba el nombre de la organización (empresa, institución, etc). </div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><input type="text" maxlength="100" size="100" name="e[0][nombre_empresa]" value="" id="TO-S"></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">9. Tamaño de la organización en que trabaja:</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="45%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="90%"><div align="left">a.	Grande (100 funcionarios o más)</div></td>
													   <td width="10%"><div align="left"><input type="radio" name="e[0][tamano_empresa]" value="1"></div></td>
													</tr>
													<tr>
													   <td width="90%"><div align="left">b.	Mediana (entre 31 y 99 funcionarios)</div></td>
													   <td width="10%"><div align="left"><input type="radio" name="e[0][tamano_empresa]" value="2" ></div></td>
													</tr>
													<tr>
													   <td width="90%"><div align="left">c.	Pequeña (30 funcionarios o menos)</div></td>
													   <td width="10%"><div align="left"><input type="radio" name="e[0][tamano_empresa]" value="3"></div></td>
													</tr>
												  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">10. Indique la principal característica del giro de la empresa (sector productivo al que pertenece u otra característica básica que defina el tipo de actividad de la organización).</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><input type="text" maxlength="100" size="100" name="e[0][caracteristica_empresa]" value="" id="TO-S"></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">11. el rol por usted cumplido en la organización donde trabaja es de:</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="33%"><div align="center"><input type="radio" name="e[0][rol_alumno]" value="3"></div></td>
													   <td width="33%"><div align="center"><input type="radio" name="e[0][rol_alumno]" value="2"></div></td>
													   <td width="34%"><div align="center"><input type="radio" name="e[0][rol_alumno]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="33%"><div align="center">a. Jefatura.</div></td>
													   <td width="33%"><div align="center">b. Empleado(a).</div></td>
													   <td width="34%"><div align="center">c. Independiente.</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">12. Indique su cargo en la empresa.</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><input type="text" maxlength="100" size="100" name="e[0][cargo_empresa]" value="" id="TO-S"></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>SECCIÓN II:<br>ENCUESTA</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">USTED ENCONTRARÁ EN ESTA ENCUESTA UN CONJUNTO DE AFIRMACIONES RESPECTO A LAS CUALES PODRÁ EXPRESAR SU GRADO DE ACUERDO O DESACUERDO. Si considera que manifestarse sobre algún punto en particular no corresponde pues carece de la información adecuada para emitir un juicio, bastará con <strong>omitir la respuesta</strong>.</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left"><font size="2"><strong>Dimensión 1: PROPÓSITOS.</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">1. "Cuando estudié en la carrera había claridad respecto a los objetivos de la formación impartida".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_1]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_1]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_1]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_1]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">2. "Resulta evidente que la institución había definido claramente cuál era el cuerpo de conocimientos mínimos para poder egresar de la carrera".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_2]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_2]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_2]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_2]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">3. "Los egresados de la carrera de Publicidad de la Universidad del Pacífico donde estudié tenemos un perfil identificable".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_3]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_3]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_3]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_3]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left"><font size="2"><strong>Dimensión 2: INTEGRIDAD.</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">4. "La formación que recibí cumplió con los objetivos de la carrera".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_4]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_4]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_4]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_4]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">5. "El número de alumnos de la carrera de Publicidad era adecuado para los recursos disponibles y el número de académicos".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_5]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_5]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_5]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_5]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">6. "Tanto la publicidad como otras informaciones que recibí al momento de postular resultaron ser verídicas".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_6]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_6]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_6]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_6]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">7. "Los antecedentes referidos a asuntos académicos (notas, asignaturas cursadas y vencidas, etc.) siempre fueron accesibles y estuvieron disponible para mis consultas".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_7]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_7]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_7]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_7]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">8. "Las decisiones tomadas por las instancias directivas de la carrera se basaban en criterios académicos".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_8]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_8]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_8]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_8]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left"><font size="2"><strong>Dimensión 3: ESTRUCTURA ORGANIZACIONAL.</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">9. "Las autoridades de la carrera eran elegidas o nombradas de manera transparente".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_9]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_9]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_9]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_9]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">10. "Los roles que cumplían las autoridades administrativas eran adecuados para cumplir eficientemente con los objetivos de la carrera".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_10]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_10]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_10]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_10]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">11. "Siempre tuve conocimiento claro respecto de la autoridad a la cual debía recurrir cuando tenía algún problema administrativo y/o académico".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_11]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_11]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_11]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_11]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">12. "Las autoridades superiores de la carrera eran personalidades destacadas en la disciplina".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_12]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_12]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_12]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_12]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">13. "Las autoridades desempeñaban eficientemente sus funciones".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_13]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_13]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_13]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_13]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">14. "Existía una atmósfera de confianza entre alumnos, la escuela y los docentes, que permitía un ambiente de desarrollo intelectual en el ámbito publicitario".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_14]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_14]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_14]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_14]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left"><font size="2"><strong>Dimensión 4: ESTRUCTURA CURRICULAR.</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">15. "Si uno reprobaba un ramo, podía cursarlo al semestre siguiente, sin tener que esperar que pasará un año entero". (Pregunta válida sólo para casos de ramos semestrales; si no corresponde, omita la repuesta).</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_15]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_15]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_15]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_15]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">16. "Los contenidos de las asignaturas no se repetían en dos o más ramos de manera innecesaria".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_16]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_16]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_16]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_16]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">17. "La gran mayoría de los contenidos de las materias fueron útiles y/o relevantes para mi formación o para mi desempeño como profesional".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_17]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_17]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_17]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_17]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">18. "Las actividades de las asignaturas me permitieron conciliar el conocimiento teórico y práctico".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_18]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_18]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_18]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_18]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">19. "La carrera entrega una formación que permite afrontar el proceso de obtención del grado académico y del título profesional sin inconvenientes".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_19]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_19]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_19]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_19]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left"><font size="2"><strong>Dimensión 5: EVALUACIÓN DE COMPETENCIAS GENERALES.</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="justify">En el siguiente cuadro usted encontrará una serie de criterios para evaluar la formación entregada por la carrera cuando usted estudió. CALIFIQUE EN UNA ESCALA DE 1 A 7, CONSIDERANDO QUE 7 ES MUY BUENA Y 1 MUY DEFICIENTE.</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                           <td><div align="center">
						       <table width="98%" border="1" bordercolor="#333333">
							   	 <tr>
								 	 <td width="65%"><div align="center"><strong>ASPECTOS A EVALUAR</strong></div></td>
									 <td width="35%" colspan="7"><div align="center"><strong>NOTA</strong></div></td>
								 </tr>
								 <tr>
								 	 <td width="65%"><div align="justify">20- <strong>Comunicación</strong>: Capacidad para comunicarse de manera efectiva a través del lenguaje oral y escrito, y del lenguaje técnico y computacional necesario para el ejercicio de la profesión.</div></td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">1</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_20]" value="1"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">2</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_20]" value="2"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">3</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_20]" value="3"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">4</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_20]" value="4"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">5</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_20]" value="5"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">6</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_20]" value="6"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">7</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_20]" value="7"></td></tr>
																		 </table></div>
									 </td>
								 </tr>
								 <tr>
								 	 <td width="65%"><div align="justify">21- <strong>Pensamiento crítico</strong>: Capacidad para utilizar el conocimiento, la experiencia y el razonamiento para emitir juicios fundados.</div></td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">1</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_21]" value="1"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">2</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_21]" value="2"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">3</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_21]" value="3"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">4</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_21]" value="4"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">5</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_21]" value="5"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">6</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_21]" value="6"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">7</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_21]" value="7"></td></tr>
																		 </table></div>
									 </td>
								 </tr>
								  <tr>
								 	 <td width="65%"><div align="justify">22- <strong>Solución de problemas</strong>: Capacidad para identificar problemas, planificar estrategias y enfrentarlos.</div></td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">1</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_22]" value="1"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">2</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_22]" value="2"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">3</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_22]" value="3"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">4</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_22]" value="4"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">5</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_22]" value="5"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">6</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_22]" value="6"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">7</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_22]" value="7"></td></tr>
																		 </table></div>
									 </td>
								 </tr>
								 <tr>
								 	 <td width="65%"><div align="justify">23- <strong>Interacción social</strong>: Capacidad para formar parte de equipos de trabajo, y participar en proyectos grupales.</div></td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">1</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_23]" value="1"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">2</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_23]" value="2"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">3</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_23]" value="3"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">4</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_23]" value="4"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">5</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_23]" value="5"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">6</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_23]" value="6"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">7</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_23]" value="7"></td></tr>
																		 </table></div>
									 </td>
								 </tr>
								 <tr>
								 	 <td width="65%"><div align="justify">24- <strong>Autoaprendizaje e iniciativa personal</strong>: Inquietud y búsqueda permanente de nuevos conocimientos y capacidad de aplicarlos y perfeccionar sus conocimientos anteriores.</div></td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">1</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_24]" value="1"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">2</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_24]" value="2"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">3</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_24]" value="3"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">4</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_24]" value="4"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">5</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_24]" value="5"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">6</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_24]" value="6"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">7</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_24]" value="7"></td></tr>
																		 </table></div>
									 </td>
								 </tr>
								 <tr>
								 	 <td width="65%"><div align="justify">25- <strong>Formación y consistencia ética</strong>: Capacidad para asumir principios éticos y respetar los principios del otro, como norma de convivencia social.</div></td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">1</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_25]" value="1"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">2</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_25]" value="2"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">3</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_25]" value="3"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">4</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_25]" value="4"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">5</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_25]" value="5"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">6</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_25]" value="6"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">7</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_25]" value="7"></td></tr>
																		 </table></div>
									 </td>
								 </tr>
								 <tr>
								 	 <td width="65%"><div align="justify">26- <strong>Pensamiento Globalizado</strong>: Capacidad para comprender los aspectos interdependientes del mundo globalizado.</div></td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">1</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_26]" value="1"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">2</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_26]" value="2"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">3</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_26]" value="3"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">4</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_26]" value="4"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">5</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_26]" value="5"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">6</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_26]" value="6"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">7</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_26]" value="7"></td></tr>
																		 </table></div>
									 </td>
								 </tr>
								 <tr>
								 	 <td width="65%"><div align="justify">27- <strong>Formación Ciudadana</strong>: Capacidad para integrarse a la comunidad y participar responsablemente en la vida ciudadana.</div></td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">1</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_27]" value="1"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">2</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_27]" value="2"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">3</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_27]" value="3"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">4</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_27]" value="4"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">5</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_27]" value="5"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">6</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_27]" value="6"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">7</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_27]" value="7"></td></tr>
																		 </table></div>
									 </td>
								 </tr>
								 <tr>
								 	 <td width="65%"><div align="justify">28- <strong>Sensibilidad estética</strong>: Capacidad de apreciar y valorar diversas formas artísticas y los contextos de donde provienen.</div></td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">1</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_28]" value="1"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">2</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_28]" value="2"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">3</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_28]" value="3"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">4</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_28]" value="4"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">5</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_28]" value="5"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">6</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_28]" value="6"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">7</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_28]" value="7"></td></tr>
																		 </table></div>
									 </td>
								 </tr>
							   </table>
						       </div>
					       </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left"><font size="2"><strong>Dimensión 6: RECURSOS HUMANOS.</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">29. "Los docentes con los que contó mi carrera eran adecuados para entregar una buena formación".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_29]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_29]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_29]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_29]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">30. "La cantidad de docentes asignados a mi carrera era la adecuada para la cantidad de alumnos que éramos en mi curso".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_30]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_30]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_30]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_30]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">31. "Los profesores estaban al día en el conocimiento teórico y práctico de la disciplina, y eso era evidente en sus clases".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_31]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_31]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_31]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_31]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">32. "El personal administrativo de la carrera y la institución (secretarias, departamento de computación, biblioteca, etc.), entregaban los servicios adecuados para un funcionamiento eficiente".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_32]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_32]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_32]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_32]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">33. "La cantidad de personal administrativo era la adecuada".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_33]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_33]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_33]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_33]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left"><font size="2"><strong>Dimensión 7: EFECTIVIDAD PROCESO DE ENSEÑANZA.</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">34. "Los criterios de admisión de alumnos para la carrera de Publicidad, eran claros".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_34]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_34]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_34]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_34]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">35. "Las autoridades de la carrera se preocuparon de diagnosticar la formación de sus alumnos para adecuar los contenidos y las estrategias de enseñanza".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_35]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_35]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_35]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_35]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">36. "La malla curricular era coherente y estaba adecuadamente planteada".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_36]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_36]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_36]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_36]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">37. "El plan de estudios y los programas de las asignaturas me fueron impartidos completamente".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_37]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_37]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_37]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_37]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">38. "La forma de evaluación de los alumnos en pruebas, trabajos y otras actividades estaba basada en criterios claros y conocidos".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_38]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_38]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_38]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_38]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">39. "Siempre tuve claros los criterios y requisitos para egresar y titularme".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_39]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_39]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_39]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_39]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">40. "Los criterios de titulación eran adecuados".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_40]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_40]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_40]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_40]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left"><font size="2"><strong>Dimensión 8: RESULTADOS DEL PROCESO DE FORMACIÓN.</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">41. "La carrera de Publicidad de la Universidad del Pacífico actualmente ofrece programas y mecanismos para el perfeccionamiento y/o actualización de los egresados".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_41]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_41]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_41]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_41]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">42. "Existe un proceso eficiente de seguimiento de los egresados".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_42]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_42]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_42]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_42]" value="1"></div></td>
		   											</tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">43. "La carrera de Publicidad y la Universidad del Pacífico donde estudié, disponen de una buena política de colocación laboral".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_43]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_43]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_43]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_43]" value="1"></div></td>
		   											</tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left"><font size="2"><strong>Dimensión 9: INFRAESTRUCTURA.</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">44. "Las salas de clases tenían instalaciones adecuadas a los requerimientos académicos y a la cantidad de alumnos".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_44]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_44]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_44]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_44]" value="1"></div></td>
		   											</tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">45. "Siempre encontraba los libros u otros materiales que necesitaba en la biblioteca".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_45]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_45]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_45]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_45]" value="1"></div></td>
		   											</tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">46. "El servicio de bibliotecas y salas de lectura era adecuado en términos de calidad de atención y extensión de horarios de uso".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_46]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_46]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_46]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_46]" value="1"></div></td>
		   											</tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">47. "Los medios audiovisuales de apoyo a la carrera eran suficientes".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_47]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_47]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_47]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_47]" value="1"></div></td>
		   											</tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">48. "Los laboratorios y/o talleres estaban correctamente implementados".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_48]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_48]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_48]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_48]" value="1"></div></td>
		   											</tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">49. "Los equipos computacionales eran suficientes para nuestras necesidades".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_49]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_49]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_49]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_49]" value="1"></div></td>
		   											</tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">50. "La institución se preocupaba permanentemente de mejorar la calidad de la infraestructura".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_50]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_50]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_50]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_50]" value="1"></div></td>
		   											</tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">51. La calidad de baños, áreas de esparcimiento y seguridad de las instalaciones, era la adecuada".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_51]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_51]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_51]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_51]" value="1"></div></td>
		   											</tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">52. "La carrera donde estudié siempre facilitó los medios necesarios para realizar actividades de apoyo a mi formación (festivales, concursos, ferias y seminarios de la disciplina)".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_52]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_52]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_52]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_52]" value="1"></div></td>
		   											</tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left"><font size="2"><strong>Dimensión 10: VINCULACIÓN CON EL MEDIO.</strong></font></div></td>
                        </tr>
						
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">53. "La formación que recibí fue suficiente para desempeñar satisfactoriamente mi práctica profesional y para enfrentarme al mundo laboral".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_53]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_53]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_53]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_53]" value="1"></div></td>
													</tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">54. "La carrera donde estudié fomenta y facilita la participación de egresados en seminarios y/o charlas sobre la disciplina".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_54]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_54]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_54]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_54]" value="1"></div></td>
													</tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">55. "El plan de estudios contemplaba actividades de vinculación de los estudiantes con el medio profesional".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_55]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_55]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_55]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_55]" value="1"></div></td>
													</tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">56. "En el mercado existe interés por contratar a los egresados de la carrera de Publicidad de la Universidad del Pacífico".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_56]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_56]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_56]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_56]" value="1"></div></td>
													</tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left"><font size="2"><strong>Dimensión 11: SATISFACCIÓN GENERAL.</strong></font></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">57. "Si tuviera la oportunidad de elegir otra vez dónde estudiar la carrera de Publicidad, nuevamente optaría por la Universidad del Pacífico".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_57]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_57]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_57]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_57]" value="1"></div></td>
		   											</tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">58. "En términos generales, se puede señalar que la formación que recibí en mi carrera fue de alta calidad".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_58]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_58]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_58]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_58]" value="1"></div></td>
		   											</tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">59. "Al egresar de la carrera de Publicidad, fui contratado(a) de acuerdo a mis expectativas profesionales y de renta".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_59]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_59]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_59]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_59]" value="1"></div></td>
		   											</tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">60. "A los egresados de mi carrera nos resulta favorable la comparación, en términos profesionales, con los de otras instituciones académicas".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_60]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_60]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_60]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_60]" value="1"></div></td>
		   											</tr>
													<tr>
													   <td width="25%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="25%"><div align="center">b. De acuerdo</div></td>
													   <td width="25%"><div align="center">c. En desacuerdo</div></td>
													   <td width="25%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>SECCIÓN III.<br>SUGERENCIAS Y COMENTARIOS</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">1. ¿Qué contenidos no me fueron entregados y hoy me doy cuenta de que me sería muy favorable conocer?</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><textarea name="e[0][contenidos_faltantes]" cols="100" rows="10" id="TO-N"></textarea></div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">2. ¿Qué sugerencias le haría usted a las autoridades de la carrera de Publicidad para mejorar la calidad de la formación?</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><textarea name="e[0][sugerencias_autoridades]" cols="100" rows="10" id="TO-N"></textarea></div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><font size="3"><strong>MUCHAS GRACIAS</strong></font></div></td>
                        </tr><%end if%>
                     </table></td>
                  </tr>
                </table>
                          <br>
						  
            </form><%end if' fin del if de si es alumno de publicidad
			end if ' fin del if por si ingreso el rut%></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="31%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><% if rute <> "" and contestada = "0" and cantidad_matriculas<> "0"   then
				                             	f_botonera.DibujaBoton("guardar_encuesta")
											 end if%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("cancelar")%>
                  </div></td>
                  </tr>
              </table>
            </div></td>
            <td width="69%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
