<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
'---------------------------------------------------------------------------------------------------
'set pagina = new CPagina
'pagina.Titulo = "ENCUESTA PARA EMPLEADORES"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

consulta_carreras= " ( select distinct ltrim(rtrim(a.carr_ccod)) as carr_ccod, a.carr_tdesc from  carreras a "&_
                   "    where exists (select 1 from especialidades b, ofertas_academicas c where a.carr_ccod = b.carr_ccod and  b.espe_ccod = c.espe_ccod) "&_
				   "    and tcar_ccod =1 )a"
'----------------------------------------------------------------------- 
' response.Write(consulta_carreras)
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "encuesta_empleadores.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '"&carr_ccod&"' as carr_ccod"
 'if  EsVacio(carr_ccod) then
 ' 		f_busqueda.Agregacampoparam "carr_ccod", "filtro" , "1=2"
 'end if
 f_busqueda.agregaCampoParam "carr_ccod","destino",consulta_carreras
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "carr_ccod", carr_ccod 
 



set f_botonera = new CFormulario
f_botonera.Carga_Parametros "encuesta_empleadores.xml", "botonera"

devuelto = request.QueryString("devuelto")
%>


<html>
<head>
<title>Encuesta para Empleadores</title>
<link href="../estilos/estilos.css" rel=stylesheet type="text/css">
<link href="../estilos/tabla.css" rel=stylesheet type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function Validar()
{
// se retornara true hasta definir bien que campos se desea validar que sean obligatorios
if (confirm("�Esta seguro que desea grabar y enviar la encuesta?.\n Una vez grabada, no podr� realizar cambios en ella."))
    { return true;}
else
	{return false;}	
}

</script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"></head>

<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
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
            <td><div align="center"><br><font size="+1" face="Times New Roman, Times, serif"><strong>ENCUESTA PARA EMPLEADORES</strong></font><br>
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
                          <td><div align="justify">Esta encuesta est� dise�ada para optimizar los mecanismos de autoevaluaci�n de las instituciones acad�micas chilenas. Su aporte, al responder este cuestionario, ser� muy valioso para la Universidad del Pac�fico y para el sistema educacional del pa�s.</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="justify">La encuesta s�lo ser� utilizada con fines de diagn�stico de la instituci�n, como parte de un proceso de autoevaluaci�n en el que se encuentra.</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
                        <tr>
                          <td><div align="justify">Como empleador, se le solicita que eval�e al o los profesionales egresados de la Universidad del Pac�fico, que actualmente se encuentran trabajando en su organizaci�n, se�alando la carrera a la que representan.</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="justify">Si son varios los profesionales que est� evaluando a la vez, se le solicita que conteste intentando extraer observaciones generales sobre esos distintos profesionales.</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>SECCI�N I:<br>DATOS GENERALES DE LA ORGANIZACI�N.</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">1. Indique la carrera de la que egres� el o los profesionales en los que basar� su evaluaci�n:</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">  <%f_busqueda.dibujaCampo ("carr_ccod")%>
                          </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">2. Nombre de la organizaci�n (empresa, instituci�n, etc).</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><input type="text" maxlength="100" size="100" name="e[0][nombre_Empresa]" value="" id="TO-N"></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">3. Tama�o de la organizaci�n.</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="45%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="90%"><div align="left">a.	Grande (100 funcionarios o m�s)</div></td>
													   <td width="10%"><div align="left"><input type="radio" name="e[0][tamano_empresa]" value="1"></div></td>
													</tr>
													<tr>
													   <td width="90%"><div align="left">b.	Mediana (entre 31 y 99 funcionarios)</div></td>
													   <td width="10%"><div align="left"><input type="radio" name="e[0][tamano_empresa]" value="2" ></div></td>
													</tr>
													<tr>
													   <td width="90%"><div align="left">c.	Peque�a (30 funcionarios o menos)</div></td>
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
                          <td><div align="left">4. Indique la principal caracter�stica del giro de la empresa (sector productivo al que pertenece u otra caracter�stica b�sica que defina el tipo de actividad de la organizaci�n).</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><input type="text" maxlength="100" size="100" name="e[0][actividad_Empresa]" value="" id="TO-N"></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">5. Indique su cargo en la empresa.</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><input type="text" maxlength="100" size="100" name="e[0][cargo_encuestado]" value="" id="TO-N"></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">6. Ud. es egresado de la Universidad del Pac�fico (o Instituto Profesional del Pac�fico).</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="25%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="40%"><div align="right">a. Si</div></td>
													   <td width="10%"><div align="left"><input type="radio" name="e[0][egresado_upa]" value="1"></div></td>
													   <td width="40%"><div align="right">b. No</div></td>
													   <td width="10%"><div align="left"><input type="radio" name="e[0][egresado_upa]" value="2"></div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>SECCI�N II:<br>ENCUESTA</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">USTED ENCONTRAR� EN ESTA ENCUESTA UN CONJUNTO DE AFIRMACIONES RESPECTO A LAS CUALES PODR� EXPRESAR SU GRADO DE ACUERDO O DESACUERDO. Si considera que manifestarse sobre alg�n punto en particular no corresponde pues carece de la informaci�n adecuada para emitir un juicio, bastar� con que omita su respuesta.</div></td>
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
                          <td><div align="left">1. "La formaci�n y los conocimientos entregados por la carrera de la Universidad del Pac�fico a sus egresados, permiten satisfacer los requerimientos de nuestra organizaci�n".</div></td>
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
                          <td><div align="left">2. "El perfil del egresado de la Universidad del Pac�fico, esto es, el conjunto de las caracter�sticas que re�ne un egresado de la carrera e instituci�n mencionadas, es difundido y conocido ".</div></td>
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
                          <td><div align="left">3. "El perfil del egresado de la carrera de la Universidad del Pac�fico, me parece bueno y adecuado a los requerimientos del medio laboral".</div></td>
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
                          <td><div align="left">4. "Las autoridades de la carrera de la Universidad del Pac�fico consultan regularmente mis opiniones como empleador".</div></td>
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
                          <td><div align="left">5. "Cuando requiero profesionales, mi organizaci�n recurre a la Universidad del Pac�fico para buscar empleados capaces".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_5]" value="4"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_5]" value="3"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_5]" value="2"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_5]" value="1"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_5]" value="0"></div></td>
													<tr>
													<tr>
													   <td width="20%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="20%"><div align="center">b. De acuerdo</div></td>
													   <td width="20%"><div align="center">c. En desacuerdo</div></td>
													   <td width="20%"><div align="center">d. Muy en desacuerdo</div></td>
													   <td width="20%"><div align="center">e. No cuento con informaci�n</div></td>
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
                          <td><div align="left">6. "La publicidad de Universidad del Pac�fico sobre sus egresados es ver�dica".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_6]" value="4"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_6]" value="3"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_6]" value="2"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_6]" value="1"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_6]" value="0"></div></td>
													<tr>
													<tr>
													   <td width="20%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="20%"><div align="center">b. De acuerdo</div></td>
													   <td width="20%"><div align="center">c. En desacuerdo</div></td>
													   <td width="20%"><div align="center">d. Muy en desacuerdo</div></td>
													   <td width="20%"><div align="center">e. No cuento con informaci�n.</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">7. "La Universidad del Pac�fico, da confianza a mi organizaci�n como formadora de profesionales".</div></td>
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
                          <td><div align="left"><font size="2"><strong>Dimensi�n 3: FUNCIONES INSTITUCIONALES: PROGRAMAS EDUCACIONALES.</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">8. "Los contenidos que los egresados de la Universidad del Pac�fico manejan, son �tiles y/o relevantes para el desempe�o profesional en mi organizaci�n".</div></td>
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
                          <td><div align="left">9. "Los egresados de la Universidad del Pac�fico pueden conciliar adecuadamente el conocimiento te�rico y el pr�ctico".</div></td>
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
                          <td><div align="left">10. "Los egresados de la Universidad del Pac�fico muestran facilidad de expresi�n oral y escrita".</div></td>
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
                          <td><div align="left">11. "Los egresados de la Universidad del Pac�fico est�n en condiciones de emitir su propia opini�n fundamentada en base al conocimiento recibido".</div></td>
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
                          <td><div align="left">12. "Los egresados de la Universidad del Pac�fico pueden diagnosticar problemas y resolverlos".</div></td>
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
                          <td><div align="left">13. "Los egresados de la Universidad del Pac�fico son capaces de trabajar en equipo".</div></td>
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
                          <td><div align="left">14. "Los egresados de la Universidad del Pac�fico muestran una alta motivaci�n para investigar y profundizar sus conocimientos ".</div></td>
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
                          <td><div align="left">15. "Respetan la opini�n de los otros, incluso estando en desacuerdo".</div></td>
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
                          <td><div align="left">16. "Son capaces de comprender el mundo actual". </div></td>
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
                          <td><div align="left">17. "A los egresados de la Universidad del Pac�fico, les interesan los problemas de su comunidad, ciudad y/o pa�s y se sienten inclinados a resolverlos y discutirlos".</div></td>
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
                          <td><div align="left">18. "Tienen una formaci�n completa que les permite comprender desde eventos hist�ricos hasta expresiones art�sticas".</div></td>
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
                          <td><div align="left">19. "Los directivos de la carrera de la Universidad del Pac�fico, mantienen un fuerte v�nculo con el medio laboral".</div></td>
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
                          <td><div align="left"><font size="2"><strong>Dimensi�n 4: EVALUACI�N DE COMPETENCIAS GENERALES.</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="justify">En el siguiente cuadro usted encontrar� una serie de criterios para evaluar al(a los) empleado(s) profesionales egresados de la Universidad del Pac�fico. CALIFIQUE EN UNA ESCALA DE 1 A 7 AL(LOS) PROFESIONAL(ES), CONSIDERANDO QUE 7 ES TOTALMENTE CAPACITADO Y 1 ES TOTALMENTE INCAPACITADO.</div></td>
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
								 	 <td width="65%"><div align="justify">20- <strong>Comunicaci�n</strong>: Capacidad para comunicarse de manera efectiva a trav�s del lenguaje oral y escrito, t�cnico y computacional necesario para el ejercicio de la profesi�n.</div></td>
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
								 	 <td width="65%"><div align="justify">21- <strong>Pensamiento cr�tico</strong>: Capacidad para utilizar el conocimiento, la experiencia y el razonamiento para emitir juicios fundados.</div></td>
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
								 	 <td width="65%"><div align="justify">22- <strong>Soluci�n de problemas</strong>: Capacidad para identificar problemas, planificar estrategias y enfrentarlos.</div></td>
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
								 	 <td width="65%"><div align="justify">23- <strong>Interacci�n social</strong>: Capacidad para formar parte de equipos de trabajo, y participar en proyectos grupales.</div></td>
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
								 	 <td width="65%"><div align="justify">24- <strong>Autoaprendizaje e iniciativa personal</strong>: Inquietud y b�squeda permanente de nuevos conocimientos y capacidad de aplicarlos y perfeccionar sus conocimientos anteriores.</div></td>
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
								 	 <td width="65%"><div align="justify">25- <strong>Formaci�n y consistencia �tica</strong>: Capacidad para asumir principios �ticos y respetar los principios del otro, como norma de convivencia social.</div></td>
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
								 	 <td width="65%"><div align="justify">27- <strong>Formaci�n Ciudadana</strong>: Capacidad para integrarse a la comunidad y participar responsablemente en la vida ciudadana.</div></td>
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
								 	 <td width="65%"><div align="justify">28- <strong>Sensibilidad est�tica</strong>: Capacidad de apreciar y valorar diversas formas art�sticas y los contextos de donde provienen.</div></td>
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
                          <td><div align="left"><font size="2"><strong>Dimensi�n 5: DESARROLLO INSTITUCIONAL.</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">29. "Estoy informado de que en la Universidad del Pac�fico, se imparten interesantes y �tiles cursos para el perfeccionamiento, actualizaci�n y/o capacitaci�n profesional".</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_29]" value="4"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_29]" value="3"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_29]" value="2"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_29]" value="1"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_29]" value="0"></div></td>
													<tr>
													<tr>
													   <td width="20%"><div align="center">a. Muy de acuerdo.</div></td>
													   <td width="20%"><div align="center">b. De acuerdo</div></td>
													   <td width="20%"><div align="center">c. En desacuerdo</div></td>
													   <td width="20%"><div align="center">d. Muy en desacuerdo</div></td>
													   <td width="20%"><div align="center">e. No cuento con informaci�n</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left"><font size="2"><strong>Dimensi�n 6: SATISFACCI�N CON LOS PROFESIONALES.</strong></font></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">30. "Tengo la convicci�n de que los egresados de la Universidad del Pac�fico tienen una excelente reputaci�n y valoraci�n".</div></td>
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
                          <td><div align="left">31. "A mi juicio la carrera de la Universidad del Pac�fico es reconocida porque forma profesionales de calidad".</div></td>
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
                          <td><div align="left">32. "El desempe�o profesional de los egresados de la Universidad del Pac�fico es muy bueno".</div></td>
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
                          <td><div align="left">33. "Los egresados de la Universidad del Pac�fico se comparan favorablemente, en t�rminos profesionales, con los de otras instituciones".</div></td>
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
                          <td><div align="left">34. Se�ale cu�l es el nivel de renta aproximada a la que optan en su organizaci�n, profesionales egresados de la Universidad del Pac�fico, de acuerdo a los a�os de experiencia.</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left"> 34.1 Menos de un a�o de experiencia:</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_341]" value="5"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_341]" value="4"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_341]" value="3"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_341]" value="2"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_341]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="20%"><div align="center">a. Menos de $ 200.000 </div></td>
													   <td width="20%"><div align="center">b. Entre $ 200.001 y $ 500.000 </div></td>
													   <td width="20%"><div align="center">c. Entre $ 500.001 y $ 1.000.000</div></td>
													   <td width="20%"><div align="center">d. Entre $ 1.000.001 y $ 1.500.000</div></td>
													   <td width="20%"><div align="center">e. M�s de $ 1.500.001</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">34.2 Entre uno y tres  a�os de experiencia:</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_342]" value="5"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_342]" value="4"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_342]" value="3"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_342]" value="2"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_342]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="20%"><div align="center">a. Menos de $ 200.000 </div></td>
													   <td width="20%"><div align="center">b. Entre $ 200.001 y $ 500.000 </div></td>
													   <td width="20%"><div align="center">c. Entre $ 500.001 y $ 1.000.000</div></td>
													   <td width="20%"><div align="center">d. Entre $ 1.000.001 y $ 1.500.000</div></td>
													   <td width="20%"><div align="center">e. M�s de $ 1.500.001</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">34.3 Entre tres y cinco a�os de experiencia:</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_343]" value="5"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_343]" value="4"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_343]" value="3"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_343]" value="2"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_343]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="20%"><div align="center">a. Menos de $ 200.000 </div></td>
													   <td width="20%"><div align="center">b. Entre $ 200.001 y $ 500.000 </div></td>
													   <td width="20%"><div align="center">c. Entre $ 500.001 y $ 1.000.000</div></td>
													   <td width="20%"><div align="center">d. Entre $ 1.000.001 y $ 1.500.000</div></td>
													   <td width="20%"><div align="center">e. M�s de $ 1.500.001</div></td>
													<tr>
     											  </table>
			                  </div>
						  </td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">34.4 M�s de cinco a�os de experiencia:</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><table width="80%" border="1" bordercolor="#333333">
						                          	<tr>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_344]" value="5"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_344]" value="4"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_344]" value="3"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_344]" value="2"></div></td>
													   <td width="20%"><div align="center"><input type="radio" name="e[0][preg_344]" value="1"></div></td>
													<tr>
													<tr>
													   <td width="20%"><div align="center">a. Menos de $ 200.000 </div></td>
													   <td width="20%"><div align="center">b. Entre $ 200.001 y $ 500.000 </div></td>
													   <td width="20%"><div align="center">c. Entre $ 500.001 y $ 1.000.000</div></td>
													   <td width="20%"><div align="center">d. Entre $ 1.000.001 y $ 1.500.000</div></td>
													   <td width="20%"><div align="center">e. M�s de $ 1.500.001</div></td>
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
                          <td><div align="left">35. Se�ale a continuaci�n las deficiencias y limitaciones profesionales que usted observa en los egresados de la Universidad del Pac�fico y que le parece importante que la carrera enfrente.</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><textarea name="e[0][deficiencias_egresados]" cols="100" rows="4" id="TO-N"></textarea></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">36. Se�ale las caracter�sticas que UD. reconoce en el egresado de la Universidad del Pac�fico.</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><textarea name="e[0][caracteristicas_egresados]" cols="100" rows="4" id="TO-N"></textarea></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="left">37. Se�ale a continuaci�n las caracter�sticas y capacidades que deber�a tener un profesional de la carrera, para que le resultara �til a su organizaci�n.</div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><textarea name="e[0][capacidades_egresados]" cols="100" rows="4" id="TO-N"></textarea></div></td>
                        </tr>
						<tr>
                          <td><div align="center">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td><div align="center"><font size="3"><strong>MUCHAS GRACIAS</strong></font></div></td>
                        </tr>
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
                  <td><div align="center"><%f_botonera.DibujaBoton("guardar_encuesta")%></div></td>
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
