<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

'---------------------------------------------------------------------------------------------------
'set pagina = new CPagina
'pagina.Titulo = "Encuesta Así soy yo"
'---------------------------------------------------------------------------------------------------
'secc_ccod=request.Form("secc")
'anos_ccod=request.Form("anos_ccod")


set pagina = new cPagina
set errores= new CErrores
set conexion = new CConexion
conexion.Inicializar "upacifico"
'
set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "mantenedores_escuela.xml", "botonera"

set f_buscador = new CFormulario
f_buscador.Carga_Parametros "mantenedores_escuela.xml", "buscador"
f_buscador.Inicializar conexion
consultal="select''"
f_buscador.Consultar consultal
f_buscador.Siguiente

set f_mantenedor = new CFormulario
'response.End()
f_mantenedor.Carga_Parametros "mantenedores_escuela.xml", "f_mantenedor_base_1_1_a"

f_mantenedor.Inicializar conexion

'pers_ncorr=conexion.ConsultaUno("select protic.obtener_pers_ncorr("&q_pers_nrut&")")
consulta = "select ''"



'response.End()
f_mantenedor.Consultar consulta
'f_mantenedor.Siguiente


'Ano =conexion.ConsultaUno("select anos_ccod from ")

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<title>-Universidad del Pac&iacute;fico</title>

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

function bloque_ano(valor)
{
var mantenedor=document.edicion.elements["bu[0][tipo_indi]"].value;


if (valor ==1)
	{
		
		document.edicion.elements["bu[0][anos_ccod]"].disabled=true;	
		
	}
	
else if ((valor ==3)&&(mantenedor >15)&&(mantenedor != 16))
	{
	
	document.edicion.elements["bu[0][anos_ccod]"].disabled=true;
    }
else if ((valor ==3)&&(mantenedor == 16))
	{
	document.edicion.elements["bu[0][anos_ccod]"].disabled=false;
    }	
else
	{
			
		document.edicion.elements["bu[0][anos_ccod]"].disabled=false;
	}
}
</script>
</head>

<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" >
<form name="edicion">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA"><br>
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
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
			<table width="500" border="0" align="left">
<tr valign="top" align="left">
<td width="100%" align="left">

  <table align="left">
  <tr>
  	<td>
		Información 
	</td>
   </tr>
	<tr>
	   <td>
	   	  	<select  name="bu[0][tipo_indi]" id='NU-N'>
			<option value="">Selecione la informacion a completar</option>
			<option value="1">Porcentaje de alumnos de 1er año en programa de apoyo y seguimiento por escuela</option>
			<option value="2">Los programas con perfil de egreso actualizado </option>
			<option value="3">Las carreras con autoevaluación vigente</option>
			<option value="4">Las carreras que terminaron su proceso de autoevaluación planificado para el año </option>
			<option value="5">Las carreras de pregrado acreditadas</option>
			<option value="72">N° de nuevos programas académicos de pregrado implementados</option>
			<option value="73">N° de nuevos programas académicos de Postgrado implementados</option>
			<option value="7">Movilidad internacional de matriculados en cada carrera para el año </option>
			<option value="8">Porcentaje de retención entregado para el año  </option>
			<option value="9">El N° de alumnos nuevos anuales entregados por carrera </option>
			<option value="10">El N° de titulación oportuna entregado por carrera para el año</option>
			<option value="11">Fechas de cohorte para considerar toma de carga oportuna semestral</option>
			<option value="12">Fechas de cohorte para considerar ingreso de notas oportuno por semestres</option>
			<option value="13">Relación de cumplimiento requerimientos proyectos de carrera anuales</option>
			<option value="14">Cantidad de metros cuadrados construidos ,de salas, talleres o laboratorios por sedes  </option>
			<option value="15">Cantidad de bibliografía obligatoria y complementaria disponible por sede </option>
			<option value="16">Porcentaje de alumnos participantes en Programa de Formación General Optativa por carrera</option>
			<option value="17">Proyecto Centro de Apoyo Docente aprobado por Vice-rectoría Académica</option>
			<option value="18">Porcentaje de implementación del Centro de Apoyo Docente</option>
			<option value="19">N° de proyectos de investigación terminados y publicados</option>
			<option value="20">N° Artículos y Comunicados de Prensa</option>
			<option value="21">N° de nuevos Convenios de Cooperación Acad. y de Intercambio Estud. con universidades de la OECD</option>
			<option value="22">N° de nuevos Convenios de Cooperación Acad. y de Intercambio Estud. con universidades de países latinoamericanos </option>
			<option value="23">Nº de nuevos convenios de doble certificación </option>
			<option value="24">Nº de actividades culturales con instituciones extranjeras en Chile </option>
			<option value="25">Presupuesto financiado (MM$)  </option>
			<option value="26">Razón de endeudamiento (Deuda/Patrimonio)  </option>
			<option value="27">EBITDA Resultado Operacional antes de impuesto </option>
			<option value="28">Excedentes Finales </option>
			<option value="29">[( Ingresos No operacionales) / (Ingresos Totales)] </option>
			<option value="30">Grado de satisfacción sobre servicios</option>
			<option value="31">N° de días utilizados en procesos administrativos de: retiros, eliminaciones y suspensión de estudios</option>
			<option value="32">N° de días utilizados en proceso administrativo emisión certificación CORFO</option>
			<option value="33">Grado de satisfacción SGA</option>
			<option value="34">Disponibilidad de la información 24x7x365</option>
			<option value="35">Velocidad de acceso tiempo en segundos de respuesta interna a nivel transaccional, en segundos</option>
			<option value="36">Integridad de la información</option>
			<option value="37">N° de funcionalidades desarrolladas de acuerdo a las necesidades expresadas por las unidades y usuarios</option>
			<option value="38">Optimización de procesos administrativos</option>
			<option value="39">Generación y actualización de Flujo de caja a 5 año</option>
			<option value="40">N° de proyectos de transferencia presentados</option>
			<option value="41">N° de mecanismos debidamente formalizados entre las áreas (VRPD-VRA),(VRDP–VAF) para generar proyectos de desarrollo</option>
			<option value="42">N° de proyectos gestionados en su implementación en colaboración con las áreas</option>
			<option value="43">[(Ingresos de transferencia técnica y de conocimientos) / (Ingresos No Operacionales)] x 100</option>
			<option value="44">Nº de programas de Español + Cultura Latinoamericana implementado en periodo de vacaciones</option>
			<option value="45">N° de programas de extensión académica implementados</option>
			<option value="46">[(Ingresos provenientes de extensión académica) / (Ingresos No Operacionales)] x 100</option>
			<option value="47">[(Ingresos de Extensión) / (Ingresos Operacionales)] x 100</option>
			<option value="48">[(Excedentes) / (Ingresos de los programas de extensión)] x 100</option>
			<option value="49">Porcentaje de satisfacción de servicios</option>
			<option value="50">[(N° de pers. reclutadas y seleccionadas en 30 días)/(N° total de pers. reclutadas y seleccionadas en el año)] x 100</option>
			<option value="51">N° de pers. que cursen el  Programa de Inducción</option>
			<option value="52">Porcentaje de Docentes con evaluación 360°</option>
			<option value="53">Porcentaje de Docentes  con planes de desarrollo implementados</option>
			<option value="54">Porcentaje de Docentes con bajo Desempeño  con gestión de consecuencias</option>
			<option value="55">Porcentaje de Directivos gestionados  con proceso de mejoramiento del  desempeño</option>
			<option value="56">Porcentaje de Directivos con planes de desarrollo implementados</option>
			<option value="57">Porcentaje de Directivos con bajo desempeño  con gestión de consecuencias </option>
			<option value="58">Porcentaje de Administrativos gestionados  con proceso de mejoramiento del desempeño</option>
			<option value="59">Porcentaje de Administrativos con planes de desarrollo implementados</option>
			<option value="60">Porcentaje de Administrativos con bajo desempeño con gestión de consecuencias</option>
			<option value="61">Porcentaje de empleados docentes con desempeño excepcional reconocidos </option>
			<option value="62">Porcentaje de empleados administrativos con desempeño excepcional reconocidos  </option>
			<option value="63"> de empleados directivos con desempeño excepcional reconocidos  </option>
			<option value="64">N° de programas corporativos de capacitación anual    </option>
			<option value="65">N° de empleados capacitados</option>
			<option value="66">N° de horas dedicadas a la capacitación</option>
			<option value="67">Porcentaje renta imponible del personal destinado para su desarrollo, perfeccionamiento y capacitación</option>
			<option value="68">Inversión total  en desarrollo, perfeccionamiento y capacitación por empleado</option>
			<option value="69">Realizar una medición anual de clima laboral</option>
			<option value="70">Porcentaje de ejecución del plan de mejoramiento</option>
			<option value="71">Porcentaje de mejoramiento  clima</option>
			</select>
	    </td>	
	  </tr>
  
	  <tr>
		<td>
			Dato a ingresar
		</td>
	  </tr>
  	<tr>
	   <td>
	   	  	<select name="bu[0][tipo_mantenedora]" id='NU-N' onChange="bloque_ano(this.value)">
			<option value="">Seleccione el dato</option>
			<option value="1">Datos Base</option>
			<option value="2">Dato Real</option>
			<option value="3">Estimativo</option>
			</select>
	   </td>	
	</tr>
	 <tr>
  	   <td>
		   Año
	   </td>
    </tr>
	<tr>
  	  <td>
		<select name="bu[0][anos_ccod]" id='NU-N' >
			<option value="">Seleccione un Año</option>
			<option value="2009">2009</option>
			<option value="2010">2010</option>
			<option value="2011">2011</option>
			<option value="2012">2012</option>
			<option value="2013">2013</option>
			</select>
	 </td>
  </tr>
  <tr><td>&nbsp;</td></tr>
  <tr><td bgcolor="#990000" align="center"><a href="inicio.html" target="_blank"><font color="#FFFFFF" size="3"><strong>Ir a Indicadores</strong></font></a></td></tr>
  <tr><td>&nbsp;</td></tr>	
  </table>

</td>
</tr>
 <tr>
	<td align="right">
	
	</td>
  </tr>
</table>
           </td></tr>
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
				    <td title="o"><div align="center"><%f_botonera.DibujaBoton"ingresar"%></div></td>
				    <td><div align="center"><%f_botonera.DibujaBoton("salir2")%></div></td>
                </tr>
              </table>
            </td>
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
</form>
</body>

</html>
