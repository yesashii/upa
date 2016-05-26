<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Encuesta Docentes"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "encuestas_acreditacion.xml", "botonera"

'-----------------------------------------------------------------------
carr_ccod = request.querystring("busqueda[0][carr_ccod]")
'response.Write(carr_ccod)
carrera = conexion.consultauno("SELECT carr_tdesc FROM carreras WHERE carr_ccod = '" & carr_ccod & "'")
'----------------------------------------------------------------------- 
 usuario_sesion = negocio.obtenerUsuario
 pers_ncorr_temporal = conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario_sesion&"'")


 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "encuestas_acreditacion.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 
 consulta_carreras = " select a.carr_ccod,a.carr_tdesc   "& vbCrLf &_
					 " from carreras a,  "& vbCrLf &_
					 " (select distinct carr_ccod from encuestas_alumnos where isnull(antiguos,'N')='N'  "& vbCrLf &_
					 " union   "& vbCrLf &_
					 " select distinct carr_ccod from encuestas_docentes where isnull(antiguos,'N')='N'  "& vbCrLf &_
					 " union   "& vbCrLf &_
					 " select distinct carr_ccod from encuestas_egresados where isnull(antiguos,'N')='N'  "& vbCrLf &_
					 " union  "& vbCrLf &_
					 " select distinct carr_ccod from encuestas_empleadores where isnull(antiguos,'N')='N'  "& vbCrLf &_
					 " )b  "& vbCrLf &_
					 " where a.carr_ccod = b.carr_ccod "& vbCrLf &_
					 " and a.carr_ccod in (select carr_ccod from especialidades aa, sis_especialidades_usuario bb"& vbCrLf &_
                     " where aa.espe_ccod=bb.espe_ccod and cast(bb.pers_ncorr as varchar)='"&pers_ncorr_temporal&"')"
 
 
 f_busqueda.AgregaCampoParam "carr_ccod","destino", "(" & consulta_carreras & ")a" 
 f_busqueda.Siguiente
 f_busqueda.AgregaCampoCons "carr_ccod", carr_ccod  

'response.Write(carr_ccod)

if carr_ccod<>"" then 
 cantidad_encuestas_alumnos = conexion.consultaUno("select count(*) from (select distinct pers_ncorr from encuestas_alumnos where isnull(antiguos,'N')='N' and carr_ccod ='"&carr_ccod&"' and isnull(pers_ncorr,0)<>0 union all select pers_ncorr from encuestas_alumnos where isnull(antiguos,'N')='N' and carr_ccod ='"&carr_ccod&"' and isnull(pers_ncorr,0)=0) a")
 cantidad_encuestas_docentes = conexion.consultaUno("select count(*) from (select distinct pers_ncorr from encuestas_docentes where isnull(antiguos,'N')='N' and carr_ccod ='"&carr_ccod&"' and isnull(pers_ncorr,0)<>0 union all select pers_ncorr from encuestas_docentes where isnull(antiguos,'N')='N' and carr_ccod ='"&carr_ccod&"' and isnull(pers_ncorr,0)=0) b")
 cantidad_encuestas_egresados = conexion.consultaUno("select count(*) from (select distinct pers_ncorr from encuestas_egresados where isnull(antiguos,'N')='N' and carr_ccod ='"&carr_ccod&"' and isnull(pers_ncorr,0)<>0 union all select pers_ncorr from encuestas_egresados where isnull(antiguos,'N')='N' and carr_ccod ='"&carr_ccod&"' and isnull(pers_ncorr,0)=0) c")
 cantidad_encuestas_empleadores = conexion.consultaUno("select count(*) from encuestas_empleadores where isnull(antiguos,'N')='N' and carr_ccod ='"&carr_ccod&"'")
 
 lenguetas_encuesta = Array(Array("Encuesta Alumnos ("&cantidad_encuestas_alumnos&")", "encuesta_acreditacion_alumno.asp?busqueda[0][carr_ccod]="&carr_ccod), Array("Encuesta Docentes  ("&cantidad_encuestas_docentes&")", "encuesta_acreditacion_docentes.asp?busqueda[0][carr_ccod]="&carr_ccod), Array("Encuesta Egresados ("&cantidad_encuestas_egresados&")", "encuesta_acreditacion_egresados.asp?busqueda[0][carr_ccod]="&carr_ccod), Array("Encuesta Empleadores ("&cantidad_encuestas_empleadores&")", "encuesta_acreditacion_empleadores.asp?busqueda[0][carr_ccod]="&carr_ccod))
 filtro_carrera = " and carr_ccod='"&carr_ccod&"'"
else
 lenguetas_encuesta = Array(Array("Encuesta Docentes", "encuesta_acreditacion_docentes.asp"))
 filtro_carrera = " and 1 = 2 "
end if

%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function cargar()
{
  buscador.action="encuesta_acreditacion_docentes.asp?busqueda[0][carr_ccod]=" + document.buscador.elements["busqueda[0][carr_ccod]"].value;
  buscador.method="POST";
  buscador.submit();
}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
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
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                            <table width="100%" border="0">
                              <tr> 
                                <td width="12%"><div align="left">Carrera</div></td>
                                <td width="5%"><div align="center">:</div></td>
                                <td width="83%"><% f_busqueda.dibujaCampo ("carr_ccod") %></td>
                              </tr>
                            </table>
                          </div></td>
                  <td width="19%"><div align="center"><%botonera.DibujaBoton "buscar"%></div></td>
                </tr>
              </table>
            </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
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
            <td><% pagina.DibujarLenguetas lenguetas_encuesta, 2 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center">
                     
                    <br>
                    <br><%pagina.DibujarSubtitulo carrera%>
                  
                  </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><div align="center"> 
                            <%pagina.DibujarTituloPagina%>
                            <br><br>
                            <table width="98%" border="0" align="center">
                              <tr> 
                                <td>
								<table width="100%" class="v1" border="1" cellpadding="0" cellspacing="0" borderColor="#999999" bgColor="#adadad">
									 <tr borderColor="#999999" bgColor="#c4d7ff">
										<th width="55%"  valign="top"><FONT color="#333333"><div align="left"><strong>PREGUNTA</strong></div></font></th>
										<th width="10%"  valign="top"><FONT color="#333333"><div align="center"><strong>Muy de Acuerdo</strong></div></font></th>
										<th width="10%"  valign="top"><FONT color="#333333"><div align="center"><strong>De acuerdo</strong></div></font></th>
										<th width="10%"  valign="top"><FONT color="#333333"><div align="center"><strong>En Desacuerdo</strong></div></font></th>
										<th width="10%"  valign="top"><FONT color="#333333"><div align="center"><strong>Muy en Desacuerdo</strong></div></font></th>
										<th width="5%"  valign="top"><FONT color="#333333"><div align="center"><strong>TOTAL</strong></div></font></th>
									  </tr>
									  <tr borderColor="#999999" bgColor="#c4d7ff">
										<th colspan="6"><FONT color="#333333"><div align="left"><strong><font size="2"><strong>Dimensión 1: MISIÓN, METAS Y OBJETIVOS.</strong></font></strong></div></font></th>
        							  </tr> 
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg1_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_1=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg1_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_1=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg1_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_1=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg1_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_1=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_1 = cint(preg1_4) + cint(preg1_3) + cint(preg1_2) + cint(preg1_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>1.</strong> El perfil del egresado, esto es, el conjunto de conocimientos y habilidades profesionales que debe reunir el egresado de la carrera en la que hago clases, es en general conocido por los docentes de la escuela.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg1_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg1_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg1_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg1_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_1%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg2_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_2=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg2_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_2=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg2_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_2=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg2_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_2=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_2 = cint(preg2_4) + cint(preg2_3) + cint(preg2_2) + cint(preg2_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>2.</strong> El perfil del egresado de la carrera está claramente definido.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg2_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg2_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg2_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg2_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_2%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg3_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_3=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg3_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_3=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg3_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_3=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg3_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_3=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_3 = cint(preg3_4) + cint(preg3_3) + cint(preg3_2) + cint(preg3_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>3.</strong> El plan de estudios de la carrera, responde a las necesidades del perfil de egreso.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg3_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg3_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg3_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg3_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_3%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg4_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_4=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg4_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_4=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg4_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_4=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg4_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_4=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_4 = cint(preg4_4) + cint(preg4_3) + cint(preg4_2) + cint(preg4_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>4.</strong> Estoy informado y conozco la misión institucional de la Universidad del Pacífico.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg4_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg4_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg4_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg4_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_4%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg5_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_5=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg5_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_5=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg5_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_5=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg5_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_5=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_5 = cint(preg5_4) + cint(preg5_3) + cint(preg5_2) + cint(preg5_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>5.</strong> Los propósitos y objetivos de la carrera, son coherentes con la misión de la Universidad del Pacífico.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg5_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg5_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg5_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg5_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_5%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg6_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_6=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg6_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_6=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg6_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_6=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg6_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_6=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_6 = cint(preg6_4) + cint(preg6_3) + cint(preg6_2) + cint(preg6_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>6.</strong> La escuela donde hago clases, ha definido con claridad un cuerpo de conocimientos mínimos con el cual se considera a un alumno apto para egresar de la carrera.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg6_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg6_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg6_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg6_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_6%></strong></div></td>
									  </tr>
									  
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg7_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_7=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg7_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_7=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg7_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_7=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg7_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_7=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_7 = cint(preg7_4) + cint(preg7_3) + cint(preg7_2) + cint(preg7_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>7.</strong> Las evaluaciones de los estudiantes a los profesores son útiles y contemplan los aspectos centrales de la actividad docente.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg7_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg7_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg7_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg7_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_7%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg8_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_8=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg8_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_8=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg8_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_8=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg8_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_8=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_8 = cint(preg8_4) + cint(preg8_3) + cint(preg8_2) + cint(preg8_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>8.</strong> La toma de decisiones en la escuela, responde a evaluaciones objetivas y a políticas transparentes.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg8_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg8_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg8_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg8_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_8%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg9_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_9=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg9_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_9=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg9_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_9=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg9_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_9=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_9 = cint(preg9_4) + cint(preg9_3) + cint(preg9_2) + cint(preg9_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>9.</strong> Hay mecanismos claros y permanentes de evaluación de la gestión de las autoridades.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg9_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg9_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg9_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg9_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_9%></strong></div></td>
									  </tr>
									  <tr borderColor="#999999" bgColor="#c4d7ff">
										<th colspan="6"><FONT color="#333333"><div align="left"><strong><font size="2"><strong><font size="2"><strong>Dimensión 2: NORMATIVA, GOBIERNO Y ADMINISTRACIÓN.</strong></font></strong></font></strong></div></font></th>
        							  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg10_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_10=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg10_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_10=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg10_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_10=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg10_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_10=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_10 = cint(preg10_4) + cint(preg10_3) + cint(preg10_2) + cint(preg10_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>10.</strong> Los trámites burocráticos que me toca realizar como docente son escasos y poco engorrosos.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg10_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg10_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg10_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg10_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_10%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg11_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_11=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg11_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_11=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg11_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_11=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg11_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_11=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_11 = cint(preg11_4) + cint(preg11_3) + cint(preg11_2) + cint(preg11_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>11.</strong> Las decisiones de los directivos de la carrera, son tomadas de manera transparente y utilizando criterios adecuados.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg11_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg11_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg11_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg11_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_11%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg12_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_12=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg12_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_12=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg12_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_12=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg12_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_12=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_12 = cint(preg12_4) + cint(preg12_3) + cint(preg12_2) + cint(preg12_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>12.</strong> La normativa y reglamentaciones de la carrera, son claras y conocidas.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg12_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg12_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg12_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg12_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_12%></strong></div></td>
									  </tr>
									  
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg13_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_13=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg13_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_13=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg13_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_13=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg13_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_13=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_13 = cint(preg13_4) + cint(preg13_3) + cint(preg13_2) + cint(preg13_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>13.</strong> Los docentes tenemos participación en la discusión sobre el perfil de egreso de la carrera.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg13_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg13_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg13_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg13_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_13%></strong></div></td>
									  </tr>
									  <tr borderColor="#999999" bgColor="#c4d7ff">
										<th colspan="6"><FONT color="#333333"><div align="left"><strong><font size="2"><strong><font size="2"><strong>Dimensión 3: RECURSOS HUMANOS: PERSONAL ACADÉMICO Y ADMINISTRATIVO.</strong></font></strong></font></strong></div></font></th>
        							  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg14_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_14=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg14_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_14=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg14_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_14=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg14_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_14=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_14 = cint(preg14_4) + cint(preg14_3) + cint(preg14_2) + cint(preg14_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>14.</strong> Las autoridades de la carrera (Director, Secretario Académico y Coordinador) son idóneas para el desempeño de sus cargos.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg14_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg14_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg14_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg14_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_14%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg15_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_15=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg15_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_15=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg15_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_15=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg15_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_15=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_15 = cint(preg15_4) + cint(preg15_3) + cint(preg15_2) + cint(preg15_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>15.</strong> Creo que la calidad del cuerpo docente es buena.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg15_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg15_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg15_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg15_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_15%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg16_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_16=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg16_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_16=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg16_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_16=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg16_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_16=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_16 = cint(preg16_4) + cint(preg16_3) + cint(preg16_2) + cint(preg16_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>16.</strong> Existen y operan instancias de participación de los docentes para tomar decisiones en temas relevantes de la carrera.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg16_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg16_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg16_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg16_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_16%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg17_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_17=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg17_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_17=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg17_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_17=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg17_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_17=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_17 = cint(preg17_4) + cint(preg17_3) + cint(preg17_2) + cint(preg17_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>17.</strong> Existe una atmósfera de confianza entre los alumnos, la escuela y los docentes, que permite un ambiente de desarrollo intelectual en el ámbito de la carrera.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg17_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg17_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg17_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg17_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_17%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg18_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_18=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg18_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_18=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg18_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_18=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg18_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_18=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_18 = cint(preg18_4) + cint(preg18_3) + cint(preg18_2) + cint(preg18_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>18.</strong> La Universidad del Pacífico y/o la carrera, nos facilita y promueve la posibilidad de seguir estudios de perfeccionamiento (postítulos, postgrados, capacitaciones, etc.).</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg18_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg18_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg18_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg18_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_18%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg19_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_19=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg19_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_19=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg19_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_19=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg19_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_19=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_19 = cint(preg19_4) + cint(preg19_3) + cint(preg19_2) + cint(preg19_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>19.</strong> Creo que, en general, mis colegas asociados a la carrera, son idóneos académicamente.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg19_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg19_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg19_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg19_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_19%></strong></div></td>
									  </tr>
									   <tr bgcolor="#FFFFFF">
									  <%
									  preg20_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_20=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg20_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_20=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg20_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_20=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg20_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_20=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_20 = cint(preg20_4) + cint(preg20_3) + cint(preg20_2) + cint(preg20_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>20.</strong> La cantidad de docentes asignados a la carrera, considerando los que trabajan a tiempo completo, medio tiempo y por horas; es la adecuada.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg20_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg20_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg20_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg20_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_20%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg21_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_21=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg21_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_21=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg21_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_21=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg21_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_21=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_21 = cint(preg21_4) + cint(preg21_3) + cint(preg21_2) + cint(preg21_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>21.</strong> La cantidad de funcionarios administrativos (secretaria, biblioteca, computación, etc.), que prestan servicios  a la carrera, es adecuada.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg21_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg21_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg21_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg21_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_21%></strong></div></td>
									  </tr>
									  <tr borderColor="#999999" bgColor="#c4d7ff">
										<th colspan="6"><FONT color="#333333"><div align="left"><strong>Dimensión 5: FUNCIONES INSTITUCIONALES: PROGRAMAS EDUCACIONALES.</strong></div></font></th>
        							  </tr>
									  
									  
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg31_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_31=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg31_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_31=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg31_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_31=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg31_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_31=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_31 = cint(preg31_4) + cint(preg31_3) + cint(preg31_2) + cint(preg31_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>31.</strong> El plan de estudios de la carrera, es coherente con los objetivos de la Universidad del Pacífico (su misión).</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg31_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg31_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg31_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg31_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_31%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg32_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_32=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg32_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_32=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg32_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_32=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg32_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_32=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_32 = cint(preg32_4) + cint(preg32_3) + cint(preg32_2) + cint(preg32_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>32.</strong> Los ramos de la carrera fomentan la creatividad de los alumnos.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg32_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg32_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg32_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg32_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_32%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg33_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_33=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg33_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_33=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg33_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_33=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg33_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_33=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_33 = cint(preg33_4) + cint(preg33_3) + cint(preg33_2) + cint(preg33_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>33.</strong> El plan de estudios responde a las necesidades de quien luego se enfrentará al mundo laboral.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg33_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg33_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg33_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg33_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_33%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg34_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_34=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg34_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_34=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg34_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_34=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg34_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_34=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_34 = cint(preg34_4) + cint(preg34_3) + cint(preg34_2) + cint(preg34_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>34.</strong> En general, las asignaturas y materias del plan de estudio son relevantes y pertinentes a la formación de los estudiantes.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg34_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg34_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg34_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg34_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_34%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg35_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_35=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg35_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_35=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg35_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_35=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg35_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_35=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_35 = cint(preg35_4) + cint(preg35_3) + cint(preg35_2) + cint(preg35_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>35.</strong> El plan de estudios integra adecuadamente actividades teóricas y prácticas.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg35_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg35_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg35_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg35_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_35%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg36_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_36=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg36_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_36=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg36_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_36=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg36_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_36=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_36 = cint(preg36_4) + cint(preg36_3) + cint(preg36_2) + cint(preg36_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>36.</strong> El plan de estudios contempla una formación integral en los estudiantes.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg36_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg36_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg36_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg36_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_36%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg37_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_37=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg37_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_37=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg37_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_37=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg37_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_37=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_37 = cint(preg37_4) + cint(preg37_3) + cint(preg37_2) + cint(preg37_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>37.</strong> El plan de estudios contempla salidas a terreno como aspecto relevante para la formación profesional del estudiante.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg37_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg37_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg37_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg37_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_37%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg38_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_38=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg38_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_38=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg38_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_38=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg38_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_38=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_38 = cint(preg38_4) + cint(preg38_3) + cint(preg38_2) + cint(preg38_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>38.</strong> La comunidad de académicos y estudiantes está inserta en los grandes debates de la disciplina.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg38_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg38_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg38_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg38_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_38%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg39_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_39=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg39_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_39=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg39_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_39=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg39_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_39=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_39 = cint(preg39_4) + cint(preg39_3) + cint(preg39_2) + cint(preg39_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>39.</strong> La carrera fomenta la participación de alumnos y profesores en seminarios de la disciplina.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg39_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg39_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg39_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg39_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_39%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg40_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_40=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg40_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_40=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg40_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_40=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg40_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_40=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_40 = cint(preg40_4) + cint(preg40_3) + cint(preg40_2) + cint(preg40_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>40.</strong> La Universidad del Pacífico y/o la carrera, fomenta actividades de extensión donde participen los docentes.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg40_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg40_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg40_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg40_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_40%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg41_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_41=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg41_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_41=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg41_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_41=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg41_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_41=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_41 = cint(preg41_4) + cint(preg41_3) + cint(preg41_2) + cint(preg41_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>41.</strong> Considero que actividades organizadas por la Universidad del Pacífico y/o la carrera, tales como concursos, charlas y seminarios, entre otros, contribuyen a mi actualización de conocimientos profesionales.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg41_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg41_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg41_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg41_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_41%></strong></div></td>
									  </tr>
									  <tr borderColor="#999999" bgColor="#c4d7ff">
										<th colspan="6"><FONT color="#333333"><div align="left"><strong><font size="2"><strong>Dimensión 6: DESARROLLO INSTITUCIONAL.</strong></font></strong></div></font></th>
        							  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg42_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_42=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg42_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_42=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg42_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_42=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg42_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_42=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_42 = cint(preg42_4) + cint(preg42_3) + cint(preg42_2) + cint(preg42_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>42.</strong> Los criterios de admisión de alumnos son claros.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg42_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg42_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg42_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg42_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_42%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg43_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_43=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg43_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_43=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg43_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_43=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg43_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_43=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_43 = cint(preg43_4) + cint(preg43_3) + cint(preg43_2) + cint(preg43_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>43.</strong> Las autoridades de la carrera, se preocupan de diagnosticar la formación de sus alumnos para adecuar los contenidos y las estrategias de enseñanza.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg43_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg43_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg43_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg43_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_43%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg44_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_44=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg44_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_44=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg44_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_44=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg44_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_44=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_44 = cint(preg44_4) + cint(preg44_3) + cint(preg44_2) + cint(preg44_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>44.</strong> La enseñanza impartida en la carrera, es de buen nivel académico.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg44_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg44_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg44_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg44_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_44%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg45_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_45=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg45_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_45=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg45_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_45=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg45_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_45=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_45 = cint(preg45_4) + cint(preg45_3) + cint(preg45_2) + cint(preg45_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>45.</strong> El desempeño de los estudiantes, en cuanto a sus niveles de aprendizaje en la carrera, es satisfactorio.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg45_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg45_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg45_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg45_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_45%></strong></div></td>
									  </tr>
									  
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg46_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_46=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg46_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_46=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg46_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_46=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg46_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_46=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_46 = cint(preg46_4) + cint(preg46_3) + cint(preg46_2) + cint(preg46_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>46.</strong> Los contenidos que se entregan a los alumnos son adecuados para su formación.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg46_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg46_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg46_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg46_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_46%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg47_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_47=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg47_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_47=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg47_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_47=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg47_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_47=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_47 = cint(preg47_4) + cint(preg47_3) + cint(preg47_2) + cint(preg47_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>47.</strong> Conozco los criterios de titulación de la carrera.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg47_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg47_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg47_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg47_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_47%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg48_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_48=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg48_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_48=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg48_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_48=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg48_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_48=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_48 = cint(preg48_4) + cint(preg48_3) + cint(preg48_2) + cint(preg48_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>48.</strong> La forma en que evalúo a los alumnos está basada en criterios muy claros.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg48_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg48_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg48_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg48_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_48%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg49_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_49=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg49_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_49=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg49_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_49=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg49_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_49=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_49 = cint(preg49_4) + cint(preg49_3) + cint(preg49_2) + cint(preg49_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>49.</strong> La secuencia de la malla curricular actual está adecuadamente planteada.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg49_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg49_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg49_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg49_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_49%></strong></div></td>
									  </tr>
									  <tr borderColor="#999999" bgColor="#c4d7ff">
										<th colspan="6"><FONT color="#333333"><div align="left"><strong><font size="2"><strong>Dimensión 7: INFRAESTRUCTURA, APOYO TÉCNICO Y RECURSOS ACADÉMICOS.</strong></font></strong></div></font></th>
        							  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg50_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_50=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg50_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_50=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg50_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_50=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg50_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_50=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_50 = cint(preg50_4) + cint(preg50_3) + cint(preg50_2) + cint(preg50_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>50.</strong> Las salas de clases tienen instalaciones adecuadas a los requerimientos académicos y a la cantidad de alumnos.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg50_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg50_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg50_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg50_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_50%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg51_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_51=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg51_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_51=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg51_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_51=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg51_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_51=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_51 = cint(preg51_4) + cint(preg51_3) + cint(preg51_2) + cint(preg51_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>51.</strong> La renovación y reparación del equipamiento de las salas, es oportuna.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg51_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg51_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg51_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg51_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_51%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg52_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_52=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg52_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_52=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg52_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_52=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg52_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_52=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_52 = cint(preg52_4) + cint(preg52_3) + cint(preg52_2) + cint(preg52_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>52.</strong> Los libros y material bibliográfico que requiero para dictar mi asignatura, están disponibles en la(s) biblioteca(s) de la Universidad del Pacífico.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg52_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg52_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg52_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg52_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_52%></strong></div></td>
									  </tr>
									  
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg53_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_53=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg53_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_53=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg53_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_53=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg53_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_53=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_53 = cint(preg53_4) + cint(preg53_3) + cint(preg53_2) + cint(preg53_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>53.</strong> Cuando solicito que se adquieran los libros necesarios para impartir mis ramos, la biblioteca se hace cargo de obtenerlos de manera muy eficiente.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg53_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg53_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg53_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg53_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_53%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg54_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_54=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg54_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_54=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg54_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_54=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg54_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_54=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_54 = cint(preg54_4) + cint(preg54_3) + cint(preg54_2) + cint(preg54_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>54.</strong> La biblioteca adquiere permanentemente material nuevo.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg54_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg54_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg54_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg54_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_54%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg55_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_55=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg55_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_55=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg55_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_55=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg55_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_55=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_55 = cint(preg55_4) + cint(preg55_3) + cint(preg55_2) + cint(preg55_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>55.</strong> Se cuenta con suficientes medios audiovisuales y diversos materiales de apoyo a la docencia.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg55_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg55_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg55_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg55_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_55%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg56_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_56=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg56_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_56=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg56_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_56=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg56_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_56=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_56 = cint(preg56_4) + cint(preg56_3) + cint(preg56_2) + cint(preg56_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>56.</strong> Los laboratorios de computación están correctamente implementados".</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg56_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg56_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg56_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg56_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_56%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg57_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_57=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg57_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_57=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg57_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_57=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg57_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_57=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_57 = cint(preg57_4) + cint(preg57_3) + cint(preg57_2) + cint(preg57_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>57.</strong> El set de TV está correctamente implementado.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg57_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg57_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg57_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg57_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_57%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg58_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_58=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg58_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_58=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg58_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_58=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg58_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_58=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_58 = cint(preg58_4) + cint(preg58_3) + cint(preg58_2) + cint(preg58_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>58.</strong> La sala de edición de material audiovisual está correctamente implementada.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg58_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg58_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg58_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg58_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_58%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg59_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_59=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg59_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_59=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg59_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_59=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg59_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_59=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_59 = cint(preg59_4) + cint(preg59_3) + cint(preg59_2) + cint(preg59_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>59.</strong> El laboratorio fotográfico está correctamente implementado.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg59_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg59_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg59_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg59_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_59%></strong></div></td>
									  </tr>
									  <tr borderColor="#999999" bgColor="#c4d7ff">
										<th colspan="6"><FONT color="#333333"><div align="left"><strong><font size="2"><strong>Dimensión 8: SATISFACCIÓN GENERAL.</strong></font></strong></div></font></th>
        							  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg60_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_60=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg60_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_60=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg60_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_60=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg60_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_60=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_60 = cint(preg60_4) + cint(preg60_3) + cint(preg60_2) + cint(preg60_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>60.</strong> Es un orgullo ser docente de la carrera y de la Universidad del Pacífico.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg60_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg60_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg60_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg60_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_60%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg61_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_61=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg61_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_61=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg61_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_61=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg61_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_61=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_61 = cint(preg61_4) + cint(preg61_3) + cint(preg61_2) + cint(preg61_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>61.</strong> La docencia impartida en la carrera es de calidad.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg61_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg61_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg61_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg61_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_61%></strong></div></td>
									  </tr> 
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg62_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_62=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg62_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_62=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg62_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_62=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg62_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_62=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_62 = cint(preg62_4) + cint(preg62_3) + cint(preg62_2) + cint(preg62_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>62.</strong> Los egresados de la carrera, cuentan con las competencias necesarias para desempeñarse adecuadamente en el medio profesional.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg62_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg62_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg62_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg62_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_62%></strong></div></td>
									  </tr> 
									</table>                    								
								</td>
                              </tr>
							  <tr>
							  	<td>&nbsp;</td>
							  </tr>
							  <tr><td >&nbsp;</td></tr>
							  <tr> 
                                <td>
								<table width="100%" class="v1" border="1" cellpadding="0" cellspacing="0" borderColor="#999999" bgColor="#adadad">
									 <tr borderColor="#999999" bgColor="#c4d7ff">
										<th width="60%" valign="top"><FONT color="#333333"><div align="left"><strong>PREGUNTA</strong></div></font></th>
										<th width="5%"  valign="top"><FONT color="#333333"><div align="center"><strong>1</strong></div></font></th>
										<th width="5%"  valign="top"><FONT color="#333333"><div align="center"><strong>2</strong></div></font></th>
										<th width="5%"  valign="top"><FONT color="#333333"><div align="center"><strong>3</strong></div></font></th>
										<th width="5%"  valign="top"><FONT color="#333333"><div align="center"><strong>4</strong></div></font></th>
										<th width="5%"  valign="top"><FONT color="#333333"><div align="center"><strong>5</strong></div></font></th>
										<th width="5%"  valign="top"><FONT color="#333333"><div align="center"><strong>6</strong></div></font></th>
										<th width="5%"  valign="top"><FONT color="#333333"><div align="center"><strong>7</strong></div></font></th>
										<th width="5%"  valign="top"><FONT color="#333333"><div align="center"><strong>Total</strong></div></font></th>
									  </tr>
									  <tr borderColor="#999999" bgColor="#c4d7ff">
										<th colspan="9"><FONT color="#333333"><div align="left"><strong><font size="2"><strong>Dimensión 4: EVALUACIÓN DE COMPETENCIAS GENERALES</strong></font></strong></div></font></th>
        							  </tr> 
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg22_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_22=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg22_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_22=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg22_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_22=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg22_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_22=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg22_5= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_22=5 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg22_6= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_22=6 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg22_7= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_22=7 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_22 = cint(preg22_1) + cint(preg22_2) + cint(preg22_3) + cint(preg22_4) + cint(preg22_5) + cint(preg22_6) + cint(preg22_7)
									  %>
										<td width="60%"><div align="left" class="Estilo2"><strong>22- Comunicación: </strong>Capacidad para comunicarse de manera efectiva a través del lenguaje oral y escrito, y del lenguaje técnico y computacional necesario para el ejercicio de la profesión.</div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg22_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg22_2%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg22_3%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg22_4%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg22_5%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg22_6%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg22_7%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_22%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg23_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_23=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg23_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_23=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg23_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_23=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg23_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_23=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg23_5= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_23=5 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg23_6= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_23=6 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg23_7= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_23=7 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_23 = cint(preg23_1) + cint(preg23_2) + cint(preg23_3) + cint(preg23_4) + cint(preg23_5) + cint(preg23_6) + cint(preg23_7)
									  %>
										<td width="60%"><div align="left" class="Estilo2"><strong>23- Pensamiento crítico: </strong>Capacidad para utilizar el conocimiento, la experiencia y el razonamiento para emitir juicios fundados.</div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg23_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg23_2%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg23_3%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg23_4%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg23_5%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg23_6%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg23_7%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_23%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg24_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_24=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg24_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_24=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg24_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_24=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg24_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_24=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg24_5= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_24=5 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg24_6= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_24=6 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg24_7= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_24=7 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_24 = cint(preg24_1) + cint(preg24_2) + cint(preg24_3) + cint(preg24_4) + cint(preg24_5) + cint(preg24_6) + cint(preg24_7)
									  %>
										<td width="60%"><div align="left" class="Estilo2"><strong>24- Solución de problemas: </strong>Capacidad para identificar problemas, planificar estrategias y enfrentarlos.</div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg24_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg24_2%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg24_3%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg24_4%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg24_5%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg24_6%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg24_7%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_24%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg25_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_25=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg25_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_25=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg25_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_25=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg25_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_25=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg25_5= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_25=5 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg25_6= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_25=6 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg25_7= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_25=7 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_25 = cint(preg25_1) + cint(preg25_2) + cint(preg25_3) + cint(preg25_4) + cint(preg25_5) + cint(preg25_6) + cint(preg25_7)
									  %>
										<td width="60%"><div align="left" class="Estilo2"><strong>25- Interacción social: </strong>Capacidad para formar parte de equipos de trabajo, y participar en proyectos grupales.</div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg25_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg25_2%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg25_3%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg25_4%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg25_5%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg25_6%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg25_7%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_25%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg26_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_26=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg26_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_26=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg26_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_26=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg26_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_26=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg26_5= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_26=5 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg26_6= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_26=6 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg26_7= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_26=7 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_26 = cint(preg26_1) + cint(preg26_2) + cint(preg26_3) + cint(preg26_4) + cint(preg26_5) + cint(preg26_6) + cint(preg26_7)
									  %>
										<td width="60%"><div align="left" class="Estilo2"><strong>26- Autoaprendizaje e iniciativa personal: </strong>Inquietud y búsqueda permanente de nuevos conocimientos y capacidad de aplicarlos y perfeccionar sus conocimientos anteriores.</div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg26_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg26_2%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg26_3%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg26_4%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg26_5%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg26_6%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg26_7%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_26%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg27_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_27=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg27_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_27=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg27_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_27=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg27_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_27=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg27_5= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_27=5 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg27_6= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_27=6 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg27_7= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_27=7 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_27 = cint(preg27_1) + cint(preg27_2) + cint(preg27_3) + cint(preg27_4) + cint(preg27_5) + cint(preg27_6) + cint(preg27_7)
									  %>
										<td width="60%"><div align="left" class="Estilo2"><strong>27- Formación y consistencia ética: </strong>Capacidad para asumir principios éticos y respetar los principios del otro, como norma de convivencia social.</div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg27_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg27_2%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg27_3%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg27_4%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg27_5%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg27_6%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg27_7%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_27%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg28_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_28=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg28_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_28=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg28_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_28=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg28_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_28=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg28_5= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_28=5 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg28_6= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_28=6 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg28_7= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_28=7 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_28 = cint(preg28_1) + cint(preg28_2) + cint(preg28_3) + cint(preg28_4) + cint(preg28_5) + cint(preg28_6) + cint(preg28_7)
									  %>
										<td width="60%"><div align="left" class="Estilo2"><strong>28- Pensamiento Globalizado: </strong>Capacidad para comprender los aspectos interdependientes del mundo globalizado.</div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg28_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg28_2%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg28_3%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg28_4%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg28_5%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg28_6%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg28_7%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_28%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg29_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_29=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg29_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_29=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg29_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_29=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg29_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_29=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg29_5= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_29=5 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg29_6= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_29=6 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg29_7= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_29=7 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_29 = cint(preg29_1) + cint(preg29_2) + cint(preg29_3) + cint(preg29_4) + cint(preg29_5) + cint(preg29_6) + cint(preg29_7)
									  %>
										<td width="60%"><div align="left" class="Estilo2"><strong>29- Formación Ciudadana: </strong>Capacidad para integrarse a la comunidad y participar responsablemente en la vida ciudadana.</div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg29_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg29_2%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg29_3%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg29_4%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg29_5%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg29_6%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg29_7%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_29%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg30_1= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_30=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg30_2= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_30=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg30_3= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_30=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg30_4= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_30=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg30_5= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_30=5 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg30_6= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_30=6 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg30_7= conexion.consultaUno("select count(distinct pers_ncorr) from encuestas_docentes where preg_30=7 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_30 = cint(preg30_1) + cint(preg30_2) + cint(preg30_3) + cint(preg30_4) + cint(preg30_5) + cint(preg30_6) + cint(preg30_7)
									  %>
										<td width="60%"><div align="left" class="Estilo2"><strong>30- Sensibilidad estética: </strong>Capacidad de apreciar y valorar diversas formas artísticas y los contextos de donde provienen.</div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg30_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg30_2%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg30_3%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg30_4%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg30_5%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg30_6%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg30_7%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_30%></strong></div></td>
									  </tr>
  								  </table>
							    </td>
							  </tr>		  
                            </table>                          
                        </div></td>
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
            <td width="21%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <%if carr_ccod <> "" then 
				   botonera.agregaBotonParam "excel","url","encuesta_acreditacion_docentes_excel.asp?carr_ccod="&carr_ccod%>
                  <td><div align="center"><%botonera.DibujaBoton "excel"%></div></td>
				<%end if%> 
                  <td><div align="center">&nbsp;</div></td>
                  <td><div align="center"><%botonera.DibujaBoton "lanzadera"%></div></td>
                </tr>
              </table>
            </div></td>
            <td width="79%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
