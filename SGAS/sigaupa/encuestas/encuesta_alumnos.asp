<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

'---------------------------------------------------------------------------------------------------
'set pagina = new CPagina
'pagina.Titulo = "ENCUESTA PARA EMPLEADORES"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

 set negocio = new CNegocio
 negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
rut = request.querystring("busqueda[0][pers_nrut]")
digito = request.querystring("busqueda[0][pers_xdv]")
'--------------------------------------------------------------------------



if pers_ncorr = "" then
	pers_nrut = negocio.obtenerUsuario  '"14118106" 'rut 
	rute = pers_nrut
	pers_ncorr= conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'")
	nombre= conexion.consultaUno("Select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
	rut = conexion.consultaUno("Select cast(pers_nrut as varchar)+ '-' + pers_xdv from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
end if

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "encuesta_alumnos.xml", "botonera"

carr_ccod = conexion.consultaUno("select top 1 carr_ccod from alumnos a, ofertas_academicas b, especialidades c where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.emat_ccod in (1,2,4,8) order by peri_ccod desc")
carrera = conexion.consultaUno("select protic.initcap(carr_tdesc) from carreras where cast(carr_ccod as varchar)='"&carr_ccod&"'")

'response.Write(carr_ccod)

devuelto = request.QueryString("devuelto")

contestada = conexion.consultaUno("select count(*) from encuestas_alumnos where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and carr_ccod='"&carr_ccod&"' and isnull(antiguos,'N')= 'N'")

cantidad_matriculas = conexion.consultaUno("select count(*) from alumnos a, ofertas_academicas b, especialidades c where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod ")

'response.Write("contestada "&contestada&" cantidad_matriculas "&cantidad_matriculas&" rute "&rute)
%>


<html>
<head>
<title>ENCUESTA PARA ESTUDIANTES</title>
<link href="../estilos/estilos.css" rel=stylesheet type="text/css">
<link href="../estilos/tabla.css" rel=stylesheet type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function Validar2()
{
// se retornara true hasta definir bien que campos se desea validar que sean obligatorios
if (confirm("�Esta seguro que desea grabar y enviar la encuesta?.\n Una vez grabada, no podr� realizar cambios en ella."))
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
		alert('Ingrese un RUT v�lido.');
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
            <td><%
				 if cantidad_matriculas = "0" then 
				%>
				<div align="center"><br><font size="+1" face="Times New Roman, Times, serif">Lo sentimos pero no hemos encontrado ninguna matricula de usted para la carrera de Publicidad. S�lo alumnos de dicha carrera pueden contestar la encuesta.</font><br>
                </div><br>
				<%else%>
			    <div align="center"><br><font size="+1" face="Times New Roman, Times, serif"><strong>ENCUESTA PARA ESTUDIANTES</strong></font><br>
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
                          <td><div align="center">Fecha de Aplicaci�n: <%=Date%></div></td>
                        </tr>
                        <tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
                        <tr>
                          <td><div align="justify">Esta encuesta est� dise�ada para optimizar los mecanismos de autoevaluaci�n de la Universidad del Pac�fico. Su aporte, al responder este cuestionario, ser� muy valioso para la instituci�n, en la cual usted estudia. La encuesta s�lo ser� utilizada con fines de diagn�stico de la Universidad, como parte del proceso de autoevaluaci�n en la que se encuentra.</div></td>
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
													  <tr>
													       <td width="9%" align="left"><strong>Carrera</strong></td>
														   <td width="1%" align="center"><strong>:</strong></td>
														   <td  colspan="4" align="left"><%=carrera%></td>
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
                          <td><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Lo Sentimos pero no puede volver a contestar la encuesta de Acreditaci�n  de la Universidad para la carrera de <%=carrera%>, muchas gracias por su colaboraci�n en dicho proceso.</strong></font></div></td>
                        </tr>
						<%else%>
						<tr>
                          <td><div align="left">A. Edad.</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">  <input type="text" maxlength="2" size="5" name="e[0][edad_alumno]" value="" id="NU-N"> A�os</div>
						                          <input type="hidden" maxlength="10" size="10" name="e[0][pers_ncorr]" value="<%=pers_ncorr%>" id="NU-N">
												  <input type="hidden" maxlength="3" size="3" name="e[0][carr_ccod]" value="<%=carr_ccod%>" id="NU-N"></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">B. Sexo.</div></td>
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
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>SECCI�N I:<br>ENCUESTA Y DIMENSIONES DE AN�LISIS</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">USTED ENCONTRAR� A CONTINUACI�N UN CONJUNTO DE AFIRMACIONES RESPECTO DE LAS CUALES PODR� EXPRESAR SU GRADO DE ACUERDO O DESACUERDO. Si considera que manifestarse sobre alg�n punto en particular no corresponde pues carece de la informaci�n adecuada para emitir un juicio, bastar� con omitir la respuesta.</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left"><font size="2"><strong>Dimensi�n 1: MISI�N, METAS Y OBJETIVOS.</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">1. "Conozco la misi�n de la Universidad del Pac�fico�.</div></td>
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
                          <td><div align="left">2. "La carrera que estudio tiene un proyecto acad�mico s�lido y coherente con la misi�n institucional".</div></td>
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
                          <td><div align="left">3. "Como estudiante tengo conocimiento del perfil del egresado, esto es, del conjunto de conocimientos y habilidades profesionales que debe tener un egresado de la carrera que estoy estudiando".</div></td>
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
                          <td><div align="left">4. "El conjunto de asignaturas de la carrera responde a las necesidades del perfil de egreso".</div></td>
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
                          <td><div align="left">5. "Existen mecanismos peri�dicos de evaluaci�n docente, es decir, encuestas o instrumentos mediante los cuales los alumnos juzgan la calidad de los profesores y la docencia impartida".</div></td>
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
                          <td><div align="left">6. "Se aprecia que los mecanismos de evaluaci�n docente son considerados por los directivos de la carrera para realizar ajustes cuando es necesario (cambiar profesores, perfeccionar asignaturas, etc.)".</div></td>
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
                          <td><div align="left"><font size="2"><strong>Dimensi�n 2: NORMATIVA, GOBIERNO Y ADMINISTRACI�N.</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">7. "La formaci�n recibida permite suponer que se cumplir�n los objetivos de la carrera".</div></td>
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
                          <td><div align="left">8. "La cantidad de acad�micos es adecuada para la cantidad de alumnos".</div></td>
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
                          <td><div align="left">9. "La publicidad que recib� cuando postul� a la carrera era ver�dica".</div></td>
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
                          <td><div align="left">10. "Mis datos y antecedentes sobre cuestiones acad�micas (ramos cursados, notas) son de f�cil acceso".</div></td>
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
                          <td><div align="left">11. "Las decisiones de los directivos de la carrera son tomadas de manera transparente y utilizando criterios adecuados".</div></td>
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
                          <td><div align="left">12. "La normativa y reglamentaciones de la carrera son claras y conocidas".</div></td>
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
                          <td><div align="left"><font size="2"><strong>Dimensi�n 3: ESTUDIANTES.</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">13. "Los estudiantes somos escuchados en nuestras demandas y necesidades". </div></td>
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
                          <td><div align="left">14. "En la Universidad del Pac�fico existen centros de estudiantes u otras agrupaciones estamentales que permiten canalizar demandas y necesidades a las autoridades".</div></td>
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
                          <td><div align="left">15. "Los alumnos hemos recibido informaci�n sobre becas, cr�ditos, pr�cticas y todo tipo de posibilidades relevantes para el desarrollo acad�mico y profesional en nuestra �rea".</div></td>
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
                          <td><div align="left"><font size="2"><strong>Dimensi�n 4: RECURSOS HUMANOS: PERSONAL ACAD�MICO Y ADMINISTRATIVO.</strong></font></div></td>
                        </tr>
						
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">16. "Las autoridades de la carrera son perfectamente conocidas por los alumnos".</div></td>
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
                          <td><div align="left">17. "Las autoridades de la carrera son accesibles para los estudiantes".</div></td>
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
                          <td><div align="left">18. "Cuando tengo un problema s� a qui�n tengo que recurrir entre las autoridades acad�micas".</div></td>
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
                          <td><div align="left">19. "Los profesores son ubicables fuera del horario de clases". </div></td>
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
                          <td><div align="left">20. "Los profesores se encuentran dispuestos a escuchar y aclarar nuestras consultas fuera del horario de clases."</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_20]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_20]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_20]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_20]" value="1"></div></td>
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
                          <td><div align="left">21. "Existe una atm�sfera de confianza entre los alumnos, la escuela y los docentes, que permite un ambiente de desarrollo intelectual en el �mbito de la carrera". </div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_21]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_21]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_21]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_21]" value="1"></div></td>
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
                          <td><div align="left">22. "Creo que la calidad de los docentes es buena".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_22]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_22]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_22]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_22]" value="1"></div></td>
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
                          <td><div align="left">23. "Los procedimientos regulares para comunicarse con docentes y autoridades son conocidos por los estudiantes".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_23]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_23]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_23]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_23]" value="1"></div></td>
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
                          <td><div align="left">24. "Los tr�mites, como solicitud de certificados, inscripci�n de ramos y otras prestaciones, se pueden realizar en forma r�pida."</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_24]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_24]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_24]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_24]" value="1"></div></td>
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
                          <td><div align="left"><font size="2"><strong>Dimensi�n 5: FUNCIONES INSTITUCIONALES: PROGRAMAS EDUCACIONALES.</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">25. "Si uno reprueba un ramo hay que esperar un a�o entero para poder cursarlo de nuevo pues los cursos no se imparten todos los semestres" (pregunta v�lida s�lo para casos con ramos semestrales; si no corresponde, omita la respuesta).</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="50%"><div align="center"><input type="radio" name="e[0][preg_25]" value="1"></div></td>
													   <td width="50%"><div align="center"><input type="radio" name="e[0][preg_25]" value="0"></div></td>
													<tr>
													<tr>
													   <td width="50%"><div align="center">a. S�.</div></td>
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
                          <td><div align="left">26. "Los ramos est�n bien coordinados, de modo que la malla curricular tiene continuidad y sentido".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_26]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_26]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_26]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_26]" value="1"></div></td>
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
                          <td><div align="left">27. "Los ramos de esta carrera fomentan la creatividad de los alumnos".</div></td>
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
                          <td><div align="left">28. "Creo que el plan de estudios responde a las necesidades de quien luego se enfrentar� al mundo laboral".</div></td>
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
                          <td><div align="left">29. "Las materias de los diferentes ramos de la carrera, no se repiten de manera innecesaria".</div></td>
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
                          <td><div align="left">30. "Todas las materias son �tiles y relevantes en la formaci�n profesional de la carrera". </div></td>
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
                          <td><div align="left">31. "El conjunto de asignaturas de la carrera integra adecuadamente actividades te�ricas y pr�cticas".</div></td>
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
                          <td><div align="left">32. "El plan de estudios es de p�blico conocimiento".</div></td>
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
                          <td><div align="left">33. Responda s�lo si es alumno de �ltimo a�o de su carrera:"El proceso de titulaci�n es conocido de antemano".</div></td>
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
                          <td><div align="left">34. "Las asignaturas permiten participar en los grandes temas, relacionados con el �mbito de la carrera, que se est�n desarrollando en la actualidad".</div></td>
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
                          <td><div align="left">35. "La carrera fomenta la participaci�n de alumnos en concursos, ferias y seminarios de la disciplina".</div></td>
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
                          <td><div align="left">36. "El plan de estudios, a trav�s de sus diferentes asignaturas, contempla actividades de vinculaci�n de los estudiantes con el medio profesional".</div></td>
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
                          <td><div align="left"><font size="2"><strong>Dimensi�n 6: EVALUACI�N DE COMPETENCIAS GENERALES</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="justify">En el siguiente cuadro usted encontrar� una serie de criterios para evaluar aspectos generales de la formaci�n impartida por la carrera que usted estudia.
													CALIFIQUE EN UNA ESCALA DE 1 A 7 LA CALIDAD DE LA FORMACI�N RECIBIDA HASTA AHORA EN LAS DISTINTAS �REAS, CONSIDERANDO QUE 7 ES MUY BUENA Y 1 ES MUY MALA O INEXISTENTE.
													</div></td>
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
								 	 <td width="65%"><div align="justify">37- <strong>Comunicaci�n</strong>: Capacidad para comunicarse de manera efectiva a trav�s del lenguaje oral y escrito, y del lenguaje t�cnico y computacional necesario para el ejercicio de la profesi�n.</div></td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">1</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_37]" value="1"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">2</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_37]" value="2"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">3</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_37]" value="3"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">4</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_37]" value="4"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">5</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_37]" value="5"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">6</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_37]" value="6"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">7</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_37]" value="7"></td></tr>
																		 </table></div>
									 </td>
								 </tr>
								 <tr>
								 	 <td width="65%"><div align="justify">38- <strong>Pensamiento cr�tico</strong>: Capacidad para utilizar el conocimiento, la experiencia y el razonamiento para emitir juicios fundados.</div></td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">1</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_38]" value="1"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">2</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_38]" value="2"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">3</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_38]" value="3"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">4</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_38]" value="4"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">5</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_38]" value="5"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">6</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_38]" value="6"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">7</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_38]" value="7"></td></tr>
																		 </table></div>
									 </td>
								 </tr>
								  <tr>
								 	 <td width="65%"><div align="justify">39- <strong>Soluci�n de problemas</strong>: Capacidad para identificar problemas, planificar estrategias y enfrentarlos.</div></td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">1</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_39]" value="1"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">2</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_39]" value="2"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">3</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_39]" value="3"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">4</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_39]" value="4"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">5</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_39]" value="5"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">6</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_39]" value="6"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">7</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_39]" value="7"></td></tr>
																		 </table></div>
									 </td>
								 </tr>
								 <tr>
								 	 <td width="65%"><div align="justify">40- <strong>Interacci�n social</strong>: Capacidad para formar parte de equipos de trabajo, y participar en proyectos grupales.</div></td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">1</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_40]" value="1"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">2</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_40]" value="2"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">3</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_40]" value="3"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">4</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_40]" value="4"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">5</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_40]" value="5"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">6</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_40]" value="6"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">7</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_40]" value="7"></td></tr>
																		 </table></div>
									 </td>
								 </tr>
								 <tr>
								 	 <td width="65%"><div align="justify">41- <strong>Autoaprendizaje e iniciativa personal</strong>: Inquietud y b�squeda permanente de nuevos conocimientos y capacidad de aplicarlos y perfeccionar sus conocimientos anteriores.</div></td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">1</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_41]" value="1"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">2</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_41]" value="2"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">3</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_41]" value="3"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">4</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_41]" value="4"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">5</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_41]" value="5"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">6</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_41]" value="6"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">7</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_41]" value="7"></td></tr>
																		 </table></div>
									 </td>
								 </tr>
								 <tr>
								 	 <td width="65%"><div align="justify">42- <strong>Formaci�n y consistencia �tica</strong>: Capacidad para asumir principios �ticos y respetar los principios del otro, como norma de convivencia social.</div></td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">1</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_42]" value="1"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">2</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_42]" value="2"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">3</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_42]" value="3"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">4</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_42]" value="4"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">5</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_42]" value="5"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">6</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_42]" value="6"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">7</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_42]" value="7"></td></tr>
																		 </table></div>
									 </td>
								 </tr>
								 <tr>
								 	 <td width="65%"><div align="justify">43- <strong>Pensamiento Globalizado</strong>: Capacidad para comprender los aspectos interdependientes del mundo globalizado.</div></td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">1</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_43]" value="1"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">2</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_43]" value="2"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">3</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_43]" value="3"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">4</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_43]" value="4"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">5</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_43]" value="5"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">6</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_43]" value="6"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">7</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_43]" value="7"></td></tr>
																		 </table></div>
									 </td>
								 </tr>
								 <tr>
								 	 <td width="65%"><div align="justify">44- <strong>Formaci�n Ciudadana</strong>: Capacidad para integrarse a la comunidad y participar responsablemente en la vida ciudadana.</div></td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">1</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_44]" value="1"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">2</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_44]" value="2"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">3</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_44]" value="3"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">4</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_44]" value="4"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">5</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_44]" value="5"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">6</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_44]" value="6"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">7</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_44]" value="7"></td></tr>
																		 </table></div>
									 </td>
								 </tr>
								 <tr>
								 	 <td width="65%"><div align="justify">45- <strong>Sensibilidad est�tica</strong>: Capacidad de apreciar y valorar diversas formas art�sticas y los contextos de donde provienen.</div></td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">1</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_45]" value="1"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">2</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_45]" value="2"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">3</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_45]" value="3"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">4</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_45]" value="4"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">5</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_45]" value="5"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">6</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_45]" value="6"></td></tr>
																		 </table></div>
									 </td>
									 <td width="5%"><div align="center"><table width="100%">
									                                       <tr><td align="center">7</td></tr>
																		   <tr><td align="center"><input type="radio" name="e[0][preg_45]" value="7"></td></tr>
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
                          <td><div align="left"><font size="2"><strong>Dimensi�n 7: RECURSOS HUMANOS: PERSONAL ACAD�MICO Y ADMINISTRATIVO.</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">46. "Los docentes que participan en la carrera son id�neos". </div></td>
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
                          <td><div align="left">47. "La cantidad de docentes de la carrera es suficiente y adecuada".</div></td>
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
                          <td><div align="left">48. "Los docentes son, en general, buenos pedagogos".</div></td>
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
                          <td><div align="left">49. "Los docentes de esta unidad acad�mica est�n actualizados en sus conocimientos".</div></td>
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
                          <td><div align="left">50. "Los docentes de esta carrera son acad�micos de prestigio y trayectoria reconocida".</div></td>
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
                          <td><div align="left">51. "Los administrativos que prestan apoyo a la escuela (secretarias, departamento de computaci�n, biblioteca, etc.), est�n capacitados para mantener un correcto funcionamiento de �sta".</div></td>
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
                          <td><div align="left">52. "La cantidad de personal administrativo es adecuada". </div></td>
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
                          <td><div align="left"><font size="2"><strong>Dimensi�n 8: DESARROLLO INSTITUCIONAL.</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">53. "Los criterios de admisi�n de alumnos a la carrera son claros".</div></td>
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
                          <td><div align="left">54. "Las metodolog�as de ense�anza permiten un muy buen aprendizaje".</div></td>
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
                          <td><div align="left">55. "Los contenidos que se me han entregado son adecuados para mi formaci�n".</div></td>
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
                          <td><div align="left">56. Responda s�lo si es alumno de �ltimo a�o de la carrera:
"Los criterios de titulaci�n son conocidos". 
</div></td>
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
                          <td><div align="left">57. "La forma de evaluar a los alumnos est� basada en criterios claros".</div></td>
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
                          <td><div align="left">58. "La distribuci�n de la carga horaria de los ramos de cada semestre, es adecuada".</div></td>
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
                          <td><div align="left">59. "La secuencia de ramos en la malla curricular es apropiada y coherente". </div></td>
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
                          <td><div align="left"><font size="2"><strong>Dimensi�n 9: INFRAESTRUCTURA, APOYO T�CNICO Y RECURSOS ACAD�MICOS.</strong></font></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">60. "Las salas de clases tienen instalaciones adecuadas a los requerimientos acad�micos y a la cantidad de alumnos". </div></td>
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
                          <td><div align="left">61. "La renovaci�n y reparaci�n del equipamiento de las salas es oportuna".</div></td>
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
                          <td><div align="left">62. "Siempre encuentro los libros que necesito en la biblioteca". </div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_62]" value="4"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_62]" value="3"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_62]" value="2"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_62]" value="1"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_62]" value="0"></div></td>
		   											</tr>
													<tr>
													   <td width="20%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="20%"><div align="center">b. De acuerdo</div></td>
													   <td width="20%"><div align="center">c. En desacuerdo</div></td>
													   <td width="20%"><div align="center">d. Muy en desacuerdo</div></td>
													   <td width="20%"><div align="center">e. No utilizo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">63. "La biblioteca adquiere permanentemente material nuevo".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_63]" value="4"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_63]" value="3"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_63]" value="2"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_63]" value="1"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_63]" value="0"></div></td>
		   											</tr>
													<tr>
													   <td width="20%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="20%"><div align="center">b. De acuerdo</div></td>
													   <td width="20%"><div align="center">c. En desacuerdo</div></td>
													   <td width="20%"><div align="center">d. Muy en desacuerdo</div></td>
													   <td width="20%"><div align="center">e. No utilizo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
				        <tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">64. "La biblioteca adquiere permanentemente importantes publicaciones peri�dicas (revistas, informes, etc) sobre la disciplina".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_64]" value="4"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_64]" value="3"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_64]" value="2"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_64]" value="1"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_64]" value="0"></div></td>
		   											</tr>
													<tr>
													   <td width="20%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="20%"><div align="center">b. De acuerdo</div></td>
													   <td width="20%"><div align="center">c. En desacuerdo</div></td>
													   <td width="20%"><div align="center">d. Muy en desacuerdo</div></td>
													   <td width="20%"><div align="center">e. No utilizo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">65. "Los medios audiovisuales de apoyo a la carrera son suficientes". </div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_65]" value="4"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_65]" value="3"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_65]" value="2"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_65]" value="1"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_65]" value="0"></div></td>
		   											</tr>
													<tr>
													   <td width="20%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="20%"><div align="center">b. De acuerdo</div></td>
													   <td width="20%"><div align="center">c. En desacuerdo</div></td>
													   <td width="20%"><div align="center">d. Muy en desacuerdo</div></td>
													   <td width="20%"><div align="center">e. No utilizo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">66. "Los laboratorios de computaci�n est�n correctamente implementados".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_66]" value="4"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_66]" value="3"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_66]" value="2"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_66]" value="1"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_66]" value="0"></div></td>
		   											</tr>
													<tr>
													   <td width="20%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="20%"><div align="center">b. De acuerdo</div></td>
													   <td width="20%"><div align="center">c. En desacuerdo</div></td>
													   <td width="20%"><div align="center">d. Muy en desacuerdo</div></td>
													   <td width="20%"><div align="center">e. No utilizo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">67. "El set de TV est� correctamente implementado".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_67]" value="4"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_67]" value="3"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_67]" value="2"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_67]" value="1"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_67]" value="0"></div></td>
		   											</tr>
													<tr>
													   <td width="20%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="20%"><div align="center">b. De acuerdo</div></td>
													   <td width="20%"><div align="center">c. En desacuerdo</div></td>
													   <td width="20%"><div align="center">d. Muy en desacuerdo</div></td>
													   <td width="20%"><div align="center">e. No utilizo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">68. "La sala de edici�n de material audiovisual est� correctamente implementada".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_68]" value="4"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_68]" value="3"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_68]" value="2"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_68]" value="1"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_68]" value="0"></div></td>
		   											</tr>
													<tr>
													   <td width="20%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="20%"><div align="center">b. De acuerdo</div></td>
													   <td width="20%"><div align="center">c. En desacuerdo</div></td>
													   <td width="20%"><div align="center">d. Muy en desacuerdo</div></td>
													   <td width="20%"><div align="center">e. No utilizo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">69. "El laboratorio fotogr�fico est� correctamente implementado".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_69]" value="4"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_69]" value="3"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_69]" value="2"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_69]" value="1"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_69]" value="0"></div></td>
		   											</tr>
													<tr>
													   <td width="20%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="20%"><div align="center">b. De acuerdo</div></td>
													   <td width="20%"><div align="center">c. En desacuerdo</div></td>
													   <td width="20%"><div align="center">d. Muy en desacuerdo</div></td>
													   <td width="20%"><div align="center">e. No utilizo</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">70. "Creo que la infraestructura de servicios anexos a la educaci�n (ba�os, casinos, casilleros y otros) es satisfactoria".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_70]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_70]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_70]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_70]" value="1"></div></td>
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
                          <td><div align="left">71. "La instituci�n tiene a disposici�n del alumno zonas adecuadas de recreaci�n y esparcimiento".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_71]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_71]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_71]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_71]" value="1"></div></td>
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
                          <td><div align="left">72. "Los equipos computacionales disponibles para actividades fuera de clases, son suficientes para nuestras necesidades".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_72]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_72]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_72]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_72]" value="1"></div></td>
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
                          <td><div align="left"><font size="2"><strong>Dimensi�n 10: SATISFACCI�N GENERAL.</strong></font></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">73. "Si tuviera la oportunidad de elegir otra vez d�nde estudiar esta carrera, nuevamente optar�a por la Universidad del Pac�fico".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_73]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_73]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_73]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_73]" value="1"></div></td>
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
                          <td><div align="left">74. "Estoy satisfecho con la formaci�n que he recibido en la Universidad del Pac�fico".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_74]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_74]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_74]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_74]" value="1"></div></td>
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
                          <td><div align="left">75. "La docencia impartida en esta carrera es de calidad".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_75]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_75]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_75]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_75]" value="1"></div></td>
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
                          <td><div align="left">76. "El valor de los aranceles y matr�cula de la carrera es acorde a la calidad de la educaci�n entregada".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_76]" value="4"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_76]" value="3"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_76]" value="2"></div></td>
													   <td width="25%"><div align="center"><input type="radio" name="e[0][preg_76]" value="1"></div></td>
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
                          <td><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>SECCI�N III.<br>SUGERENCIAS Y COMENTARIOS</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">77. Se�ale a continuaci�n sugerencias o comentarios referidos a las fortalezas y/o debilidades de la carrera o instituci�n, que le gustar�a destacar:</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><textarea name="e[0][sugerencias_carrera]" cols="100" rows="10" id="TO-N"></textarea></div>
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
			%></td></tr>
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
                  <td><div align="center"><% if rute <> "" and contestada = "0" and cantidad_matriculas<> "0"  then
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
