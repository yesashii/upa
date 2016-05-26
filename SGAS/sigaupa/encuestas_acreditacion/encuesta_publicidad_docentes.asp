<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

'---------------------------------------------------------------------------------------------------
'set pagina = new CPagina
'pagina.Titulo = "ENCUESTA PARA EMPLEADORES"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"


set negocio = new CNegocio
negocio.Inicializa conexion

sede=negocio.obtenerSede()
carr_ccod = request.querystring("e[0][carr_ccod]")
if pers_ncorr = "" then
	pers_nrut= negocio.obtenerUsuario()
	pers_ncorr= conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'")
	nombre= conexion.consultaUno("Select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
	rut = conexion.consultaUno("Select cast(pers_nrut as varchar)+ '-' + pers_xdv from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
	edad = conexion.consultaUno("Select datediff(year,pers_fnacimiento,getDate()) from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
	sexo = conexion.consultaUno("Select sexo_tdesc from personas a, sexos b where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and a.sexo_ccod=b.sexo_ccod")
	grados= conexion.consultaUno("select protic.obtener_grados_docente("&pers_ncorr&")")
	titulos= conexion.consultaUno("select protic.obtener_titulos_docente("&pers_ncorr&")")
	asignaturas= conexion.consultaUno("select protic.obtener_asignaturas_docente_carrera_anuales ("&sede&",'"&carr_ccod&"',"&pers_ncorr&",2006)")
	'encu_ncorr=""
end if

'response.Write("select protic.obtener_asignaturas_docente_carrera_anuales ("&sede&",'"&carr_ccod&"',"&pers_ncorr&",2006)")

'response.Write(carr_ccod)
carrera = conexion.consultauno("SELECT protic.initCap(carr_tdesc) FROM carreras WHERE carr_ccod = '" & carr_ccod & "'")

consulta_carreras= " ( select distinct ltrim(rtrim(d.carr_ccod)) as carr_ccod, d.carr_tdesc from bloques_profesores a, bloques_horarios b, secciones c, carreras d "&_
                   " where a.bloq_ccod = b.bloq_ccod and b.secc_ccod = c.secc_ccod and c.carr_ccod = d.carr_ccod"&_
				   " and c.peri_ccod=202 and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and cast(c.sede_ccod as varchar)='"&sede&"')a"
'MRIFFO: solucion parche (considera la sede en la cual tiene permiso el usuario (sis_sedes_usuarios) independiente donde haga clase)
consulta_carreras= " ( select distinct ltrim(rtrim(d.carr_ccod)) as carr_ccod, d.carr_tdesc from bloques_profesores a, bloques_horarios b, secciones c, carreras d "&_
                   " where a.bloq_ccod = b.bloq_ccod and b.secc_ccod = c.secc_ccod and c.carr_ccod = d.carr_ccod"&_
				   " and c.peri_ccod=202 and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and cast(c.sede_ccod as varchar) in ('1','2','4'))a"
'----------------------------------------------------------------------- 

 


set f_botonera = new CFormulario
f_botonera.Carga_Parametros "encuestas_acreditacion_publicidad.xml", "botonera_docentes"

devuelto = request.QueryString("devuelto")

contestada = conexion.consultaUno("select count(*) from encuestas_docentes where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and carr_ccod ='"&carr_ccod&"' and isnull(antiguos,'N')='N'")

'response.Write(contestada)

%>


<html>
<head>
<title>ENCUESTA PARA ACADÉMICOS</title>
<link href="../estilos/estilos.css" rel=stylesheet type="text/css">
<link href="../estilos/tabla.css" rel=stylesheet type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function Validar()
{
// se retornara true hasta definir bien que campos se desea validar que sean obligatorios
if (confirm("¿Esta seguro que desea grabar y enviar la encuesta?.\n Una vez grabada, no podrá realizar cambios en ella."))
    { return true;}
else
	{return false;}	
}

function cargar(valor){
  edicion.action="encuesta_docentes.asp?e[0][carr_ccod]=" + document.edicion.elements["e[0][carr_ccod]"].value;
  edicion.method="GET";
  edicion.submit();
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"></head>

<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%> 
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
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
            <td><div align="center"><br><font size="+1" face="Times New Roman, Times, serif"><strong>ENCUESTA PARA ACADÉMICOS</strong></font><br>
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
                          <td><div align="center">Fecha de Aplicación: <%=Date%></div></td>
                        </tr>
                        <tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
                        <tr>
                          <td><div align="justify">Esta encuesta está diseñada para optimizar los mecanismos de autoevaluación de las instituciones de educación chilenas. Su aporte, al responder este cuestionario, será muy valioso para la Escuela de Publicidad de la Universidad del Pacífico  y para el sistema educacional del país. La encuesta sólo será utilizada con fines de diagnóstico de la carrera, como parte del proceso de autoevaluación en la que se encuentra.</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="justify">Como académico, se le solicita que evalúe distintos aspectos asociados al desempeño de la carrera de Publicidad y, en algunos casos, de la Universidad del Pacífico, donde usted trabaja.</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="100%" border="0">
													  <tr>
													       <td width="9%" align="left"><strong>Docente</strong></td>
														   <td width="1%" align="center"><strong>:</strong></td>
														   <td width="40%" align="left"><%=nombre%></td>
														   <td width="9%" align="right"><strong>Rut</strong></td>
														   <td width="1%" align="center"><strong>:</strong></td>
														   <td width="40%" align="left"><%=rut%></td>
													  </tr>
													  <tr>
													       <td width="9%" align="left"><strong>Sexo</strong></td>
														   <td width="1%" align="center"><strong>:</strong></td>
														   <td width="40%" align="left"><%=sexo%></td>
														   <td width="9%" align="right"><strong>Edad</strong></td>
														   <td width="1%" align="center"><strong>:</strong></td>
														   <td width="40%" align="left"><%=edad%></td>
													  </tr>
													   <tr>
													       <td width="9%" align="left"><strong>Grados</strong></td>
														   <td width="1%" align="center"><strong>:</strong></td>
														   <td  colspan="4" align="left"><%=grados%></td>
													  </tr>
													  <tr>
													       <td width="9%" align="left"><strong>T&iacute;tulos</strong></td>
														   <td width="1%" align="center"><strong>:</strong></td>
														   <td  colspan="4" align="left"><%=titulos%></td>
													  </tr>
													  <tr>
													       <td width="9%" align="left"><strong>Asignaturas</strong></td>
														   <td width="1%" align="center"><strong>:</strong></td>
														   <td  colspan="4" align="left"><%=asignaturas%></td>
													  </tr>
											  </table>
				              </div>
						  </td>
                        </tr>
						
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<%'if asignaturas <> "--" then ' sólo se debe considerar a docentes con clases en publicidad%>
						<%if contestada = "0" then%>
						<tr>
                          <td><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>SECCIÓN I:<br>DATOS GENERALES</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">Indique la cantidad de años que ha ejercido docencia en la Escuela de Publicidad de la Universidad del Pacífico:</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">  <%if contestada <> "0" then 
						                            	anos = conexion.consultaUno("select anos_universidad from encuestas_docentes where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and carr_ccod='"&carr_ccod&"'")%>
												        <input type="text" maxlength="2" size="5" name="e[0][anos_universidad]" value="<%=anos%>" disabled> Años</div>		
						                          <%else%>
						                          		<input type="text" maxlength="2" size="5" name="e[0][anos_universidad]" value="" id="NU-N"> Años</div>
						                          <%end if%>
												  </td>
                        </tr>
						<tr>
                          <td><div align="center">
   					                           <input type="hidden" maxlength="10" size="10" name="e[0][carr_ccod]" value="45" id="NU-N">
						                       <input type="hidden" maxlength="10" size="10" name="e[0][pers_ncorr]" value="<%=pers_ncorr%>" id="NU-N">
						      </div></td>
                        </tr>
						<tr>
                          <td><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>SECCIÓN II:<br>ENCUESTA</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">USTED ENCONTRARÁ EN ESTA ENCUESTA UN CONJUNTO DE AFIRMACIONES RESPECTO A LAS CUALES PODRÁ EXPRESAR SU GRADO DE ACUERDO O DESACUERDO. Si considera que manifestarse sobre algún punto en particular no corresponde, pues carece de la información adecuada para emitir un juicio, bastará con <strong>omitir la respuesta</strong>.</div></td>
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
                          <td><div align="left">1. "El perfil del egresado, esto es, el conjunto de conocimientos y habilidades profesionales que debe reunir el egresado de Publicidad de la Universidad del Pacífico, es en general conocido por los docentes".</div></td>
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
                          <td><div align="left">2. "El perfil del egresado de la carrera de Publicidad de la Universidad del Pacífico está claramente definido".</div></td>
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
                          <td><div align="left">3. "El plan de estudios de la carrera de Publicidad de la Universidad del pacífico responde a las necesidades del perfil de egreso".</div></td>
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
                          <td><div align="left">4. "Estoy informado y conozco la misión institucional de la Universidad del Pacífico".</div></td>
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
                          <td><div align="left">5. "Los propósitos y objetivos de la carrera de Publicidad, son coherentes con la misión de la Universidad del Pacífico".</div></td>
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
                          <td><div align="left">6. "La carrera de Publicidad ha definido con claridad un cuerpo de conocimientos mínimos con el cual se considera a un alumno apto para egresar de la carrera".</div></td>
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
                          <td><div align="left">7. "Las evaluaciones de los estudiantes a los profesores son útiles y contemplan los aspectos centrales de la actividad docente".</div></td>
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
                          <td><div align="left">8. "La toma de decisiones en la Escuela de Publicidad responde a evaluaciones objetivas y a políticas transparentes".</div></td>
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
                          <td><div align="left">9. "Hay mecanismos claros y permanentes de evaluación de la gestión de las autoridades".</div></td>
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
                          <td><div align="left"><font size="2"><strong>Dimensión 2: INTEGRIDAD.</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">10. "Los trámites burocráticos que me toca realizar como docente son escasos y poco engorrosos".</div></td>
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
													   <td width="20%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="20%"><div align="center">b. De acuerdo</div></td>
													   <td width="20%"><div align="center">c. En desacuerdo</div></td>
													   <td width="20%"><div align="center">d. Muy en desacuerdo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">11. "Las decisiones de los directivos de la carrera de Publicidad son tomadas de manera transparente y utilizando criterios adecuados".</div></td>
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
                          <td><div align="left">12. "La normativa y reglamentaciones de la carrera de Publicidad son claras y conocidas".</div></td>
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
                          <td><div align="left">13. "Los docentes tenemos participación en la discusión sobre el perfil de egreso de la carrera".</div></td>
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
                          <td><div align="left"><font size="2"><strong>Dimensión 3: ESTRUCTURA ORGANIZACIONAL.</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">14. "Las autoridades de la carrera (Director, Secretario y Coordinador) son idóneas para el desempeño de sus cargos".</div></td>
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
                          <td><div align="left">15. "Creo que la calidad del cuerpo docente es buena".</div></td>
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
                          <td><div align="left">16. "Existen y operan instancias de participación de los docentes para tomar decisiones en temas relevantes de la carrera de Publicidad".</div></td>
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
                          <td><div align="left">17. Existe una atmósfera de confianza entre los alumnos, la Escuela y los docentes, que permite un ambiente de desarrollo intelectual en el ámbito publicitario.</div></td>
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
                          <td><div align="left"><font size="2"><strong>Dimensión 4: EVALUACIÓN DE COMPETENCIAS GENERALES.</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="justify">En el siguiente cuadro usted encontrará una serie de criterios para evaluar aspectos específicos de la formación impartida en la carrera. CALIFIQUE EN UNA ESCALA DE 1 A 7 LA CALIDAD DE LA FORMACIÓN IMPARTIDA A LOS ESTUDIANTES HASTA AHORA EN LAS DISTINTAS ÁREAS, CONSIDERANDO QUE 7 ES MUY BUENA Y 1 ES MUY MALA O INEXISTENTE.</div></td>
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
								 	 <td width="65%"><div align="justify">18- Comunicación: Capacidad para comunicarse de manera efectiva a través del lenguaje oral y escrito, y del lenguaje técnico y computacional necesario para el ejercicio de la profesión.</div></td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">1</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_18]" value="1"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">2</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_18]" value="2"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">3</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_18]" value="3"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">4</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_18]" value="4"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">5</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_18]" value="5"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">6</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_18]" value="6"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">7</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_18]" value="7"></td></tr>
																		 </table></div>
									 </td>
								 </tr>
								 <tr>
								 	 <td width="65%"><div align="justify">19- Pensamiento crítico: Capacidad para utilizar el conocimiento, la experiencia y el razonamiento para emitir juicios fundados.</div></td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">1</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_19]" value="1"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">2</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_19]" value="2"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">3</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_19]" value="3"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">4</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_19]" value="4"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">5</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_19]" value="5"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">6</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_19]" value="6"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">7</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_19]" value="7"></td></tr>
																		 </table></div>
									 </td>
								 </tr>
								 <tr>
								 	 <td width="65%"><div align="justify">20- Solución de problemas: Capacidad para identificar problemas, planificar estrategias y enfrentarlos. </div></td>
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
								 	 <td width="65%"><div align="justify">21- Interacción social: Capacidad para formar parte de equipos de trabajo, y participar en proyectos grupales.</div></td>
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
								 	 <td width="65%"><div align="justify">22- Autoaprendizaje e iniciativa personal: Inquietud y búsqueda permanente de nuevos conocimientos y capacidad de aplicarlos y perfeccionar sus conocimientos anteriores.</div></td>
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
								 	 <td width="65%"><div align="justify">23- Formación y consistencia ética: Capacidad para asumir principios éticos y respetar los principios del otro, como norma de convivencia social.</div></td>
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
								 	 <td width="65%"><div align="justify">24- Pensamiento Globalizado: Capacidad para comprender los aspectos interdependientes del mundo globalizado.</div></td>
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
								 	 <td width="65%"><div align="justify">25- Formación Ciudadana: Capacidad para integrarse a la comunidad y participar responsablemente en la vida ciudadana.</div></td>
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
								 	 <td width="65%"><div align="justify">26- Sensibilidad estética: Capacidad de apreciar y valorar diversas formas artísticas y los contextos de donde provienen.</div></td>
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
							   </table>
						       </div>
					       </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left"><font size="2"><strong>Dimensión 5: ESTRUCTURA CURRICULAR.</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="left">27. "El plan de estudios es coherente con los objetivos de la Universidad del Pacífico (su misión) y de la carrera de Publicidad".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_27]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_27]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_27]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_27]" value="1"></div></td>
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
                          <td><div align="left">28. "Los ramos de la carrera de Publicidad fomentan la creatividad de los alumnos".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_28]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_28]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_28]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_28]" value="1"></div></td>
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
                          <td><div align="left">29. "El plan de estudios responde a las necesidades de quien luego se enfrentará al mundo laboral".</div></td>
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
                          <td><div align="left">30. "En general, las asignaturas y materias del plan de estudio son relevantes y pertinentes a la formación de los estudiantes".</div></td>
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
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">31. "El plan de estudios integra adecuadamente actividades teóricas y prácticas".</div></td>
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
                          <td><div align="left">32. "El plan de estudios contempla una formación integral en los estudiantes".</div></td>
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
                          <td><div align="left">33. "El plan de estudios contempla salidas a terreno como aspecto relevante para la formación profesional del estudiante".</div></td>
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
                          <td><div align="left"><font size="2"><strong>Dimensión 6: RECURSOS HUMANOS.</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">34. "La Universidad del Pacífico y/o la carrera de Publicidad, nos facilita y promueve la posibilidad de seguir estudios de perfeccionamiento (postítulos, posgrados, capacitaciones, etc.).</div></td>
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
                          <td><div align="left">35. "Creo que, en general, mis colegas asociados a la carrera de Publicidad son idóneos académicamente".</div></td>
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
                          <td><div align="left">36. "La cantidad de docentes asignados a la carrera de Publicidad, considerando los que trabajan a tiempo completo, medio tiempo y por horas; es la adecuada".</div></td>
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
                          <td><div align="left">37. "La cantidad de funcionarios administrativos (secretaria, biblioteca, computación, etc.), que prestan servicios  a la carrera de Publicidad es adecuada".</div></td>
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
                          <td><div align="left"><font size="2"><strong>Dimensión 7: EFECTIVIDAD DE ENSEÑANZA.</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">38. "Los criterios de admisión de alumnos son claros".</div></td>
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
                          <td><div align="left">39. "Las autoridades de la carrera de Publicidad se preocupan de diagnosticar la formación de sus alumnos para adecuar los contenidos y las estrategias de enseñanza".</div></td>
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
                          <td><div align="left">40. "La enseñanza impartida en la carrera de Publicidad es de buen nivel académico".</div></td>
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
                          <td><div align="left">41. "El desempeño de los estudiantes, en cuanto a sus niveles de aprendizaje en la carrera de Publicidad, es satisfactorio".</div></td>
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
                          <td><div align="left">42. "Los contenidos que se entregan a los alumnos son adecuados para su formación".</div></td>
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
                          <td><div align="left">43. "Los criterios de titulación de la carrera de Publicidad son conocidos por usted".</div></td>
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
                          <td><div align="left">44. "La forma en que Ud. evalúa a los alumnos está basada en criterios muy claros".</div></td>
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
                          <td><div align="left">45. "La secuencia de la malla curricular (2004) está adecuadamente planteada".</div></td>
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
                          <td><div align="left">46. "La secuencia de la malla curricular (2006) está adecuadamente planteada".</div></td>
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
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left"><font size="2"><strong>Dimensión 8: INFRAESTRUCTURA Y OTROS RECURSOS.</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="left">47. "Las salas de clases tienen instalaciones adecuadas a los requerimientos académicos y a la cantidad de alumnos".</div></td>
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
                          <td><div align="left">48. "La renovación y reparación del equipamiento de las salas es oportuna".</div></td>
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
                          <td><div align="left">49. "Los libros y material bibliográfico que requiero para dictar mi asignatura están disponibles en la(s) biblioteca(s) de la Universidad del Pacífico".</div></td>
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
                          <td><div align="left">50. "Cuando solicito que se adquieran los libros necesarios para impartir mis ramos, la biblioteca se hace cargo de obtenerlos de manera muy eficiente".</div></td>
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
                          <td><div align="left">51. "La biblioteca adquiere permanentemente material nuevo".</div></td>
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
                          <td><div align="left">52. "Se cuenta con suficientes medios audiovisuales y diversos materiales de apoyo a la docencia".</div></td>
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
                          <td><div align="left">53. "Los laboratorios de computación están correctamente implementados".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_53]" value="4"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_53]" value="3"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_53]" value="2"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_53]" value="1"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_53]" value="0"></div></td>
													</tr>
													<tr>
													   <td width="20%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="20%"><div align="center">b. De acuerdo</div></td>
													   <td width="20%"><div align="center">c. En desacuerdo</div></td>
													   <td width="20%"><div align="center">d. Muy en desacuerdo</div></td>
													   <td width="20%"><div align="center">e. No Utilizo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">54. "El set de TV está correctamente implementado".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_54]" value="4"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_54]" value="3"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_54]" value="2"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_54]" value="1"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_54]" value="0"></div></td>
													</tr>
													<tr>
													   <td width="20%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="20%"><div align="center">b. De acuerdo</div></td>
													   <td width="20%"><div align="center">c. En desacuerdo</div></td>
													   <td width="20%"><div align="center">d. Muy en desacuerdo</div></td>
													   <td width="20%"><div align="center">e. No Utilizo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">55. "La sala de edición de material audiovisual está correctamente implementada".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_55]" value="4"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_55]" value="3"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_55]" value="2"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_55]" value="1"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_55]" value="0"></div></td>
													</tr>
													<tr>
													   <td width="20%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="20%"><div align="center">b. De acuerdo</div></td>
													   <td width="20%"><div align="center">c. En desacuerdo</div></td>
													   <td width="20%"><div align="center">d. Muy en desacuerdo</div></td>
													   <td width="20%"><div align="center">e. No Utilizo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">56. "El laboratorio fotográfico está correctamente implementado".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_56]" value="4"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_56]" value="3"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_56]" value="2"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_56]" value="1"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_56]" value="0"></div></td>
		   											</tr>
													<tr>
													   <td width="20%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="20%"><div align="center">b. De acuerdo</div></td>
													   <td width="20%"><div align="center">c. En desacuerdo</div></td>
													   <td width="20%"><div align="center">d. Muy en desacuerdo</div></td>
													   <td width="20%"><div align="center">e. No Utilizo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left"><font size="2"><strong>Dimensión 9: VINCULACIÓN CON EL MEDIO.</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">57. "La comunidad de académicos y estudiantes está inserta en los grandes debates de la disciplina".</div></td>
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
                          <td><div align="left">58. "La carrera de Publicidad fomenta la participación de alumnos y profesores en seminarios de la disciplina".</div></td>
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
                          <td><div align="left">59. "La Universidad del Pacífico y/o la carrera de Publicidad fomenta actividades de extensión donde participen los docentes".</div></td>
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
                          <td><div align="left">60. "Considera que actividades como la Feria de la Publicidad, concursos creativos, charlas y seminarios, contribuyen a su actualización de conocimientos profesionales".</div></td>
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
                          <td><div align="left"><font size="2"><strong>Dimensión 10: SATISFACCIÓN GENERAL.</strong></font></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">61. "Es un orgullo ser docente de la carrera de Publicidad y de la Universidad del Pacífico".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_61]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_61]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_61]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_61]" value="1"></div></td>
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
                          <td><div align="left">62. "La docencia impartida en la carrera de Publicidad es de calidad".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_62]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_62]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_62]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_62]" value="1"></div></td>
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
                          <td><div align="left">63. "Los egresados de la carrera de Publicidad cuentan con las competencias necesarias para desempeñarse adecuadamente en el medio profesional".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_63]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_63]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_63]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_63]" value="1"></div></td>
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
                          <td><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>SECCIÓN III.<br>SUGERENCIAS Y COMENTARIOS.</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">64. Señale a continuación sugerencias o comentarios referidos a las fortalezas y/o debilidades de esta carrera que le gustaría destacar:</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><%if contestada <> "0" then 
						                            	fortalesas = conexion.consultaUno("select fortalesas_carrera from encuestas_docentes where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and carr_ccod='45'")%>
												        <textarea name="e[0][fortalesas_carrera]" cols="100" rows="10" disabled><%=fortalesas%></textarea>		
						                          <%else%>
						                          		<textarea name="e[0][fortalesas_carrera]" cols="100" rows="10" id="TO-N"></textarea>
						                          <%end if%>
							  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><font size="3"><strong>MUCHAS GRACIAS</strong></font></div></td>
                        </tr>
						<%else%>
						<tr>
                          <td><div align="center"><font size="+1"><strong>Lo sentimos, No puede volver a contestar la encuesta para la carrera de <%=carrera%>.</strong></font></div></td>
                        </tr>
						<%end if%>
						<%'else%>
						
						<%'end if%>
                      </table></td>
                  </tr>
                </table>
                          <br>
            </form></td></tr>
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
                  <td><div align="center"><% if asignaturas <> "--" and contestada = "0" then
				                             	f_botonera.DibujaBoton("guardar_encuesta")
											 end if%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("SALIR")%>
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
