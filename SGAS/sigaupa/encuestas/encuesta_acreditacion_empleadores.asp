<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Encuesta Empleadores"
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


if carr_ccod<>"" then 
 cantidad_encuestas_alumnos = conexion.consultaUno("select count(*) from (select distinct pers_ncorr from encuestas_alumnos where isnull(antiguos,'N')='N' and carr_ccod ='"&carr_ccod&"' and isnull(pers_ncorr,0)<>0 union all select pers_ncorr from encuestas_alumnos where isnull(antiguos,'N')='N' and carr_ccod ='"&carr_ccod&"' and isnull(pers_ncorr,0)=0) a")
 cantidad_encuestas_docentes = conexion.consultaUno("select count(*) from (select distinct pers_ncorr from encuestas_docentes where isnull(antiguos,'N')='N' and carr_ccod ='"&carr_ccod&"' and isnull(pers_ncorr,0)<>0 union all select pers_ncorr from encuestas_docentes where isnull(antiguos,'N')='N' and carr_ccod ='"&carr_ccod&"' and isnull(pers_ncorr,0)=0) b")
 cantidad_encuestas_egresados = conexion.consultaUno("select count(*) from (select distinct pers_ncorr from encuestas_egresados where isnull(antiguos,'N')='N' and carr_ccod ='"&carr_ccod&"' and isnull(pers_ncorr,0)<>0 union all select pers_ncorr from encuestas_egresados where isnull(antiguos,'N')='N' and carr_ccod ='"&carr_ccod&"' and isnull(pers_ncorr,0)=0) c")
 cantidad_encuestas_empleadores = conexion.consultaUno("select count(*) from encuestas_empleadores where isnull(antiguos,'N')='N' and carr_ccod ='"&carr_ccod&"'")
 
 lenguetas_encuesta = Array(Array("Encuesta Alumnos ("&cantidad_encuestas_alumnos&")", "encuesta_acreditacion_alumno.asp?busqueda[0][carr_ccod]="&carr_ccod), Array("Encuesta Docentes  ("&cantidad_encuestas_docentes&")", "encuesta_acreditacion_docentes.asp?busqueda[0][carr_ccod]="&carr_ccod), Array("Encuesta Egresados ("&cantidad_encuestas_egresados&")", "encuesta_acreditacion_egresados.asp?busqueda[0][carr_ccod]="&carr_ccod), Array("Encuesta Empleadores ("&cantidad_encuestas_empleadores&")", "encuesta_acreditacion_empleadores.asp?busqueda[0][carr_ccod]="&carr_ccod))
 filtro_carrera = " and carr_ccod='"&carr_ccod&"'"
else
 lenguetas_encuesta = Array(Array("Encuesta Empleadores", "encuesta_acreditacion_empleadores.asp"))
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
  buscador.action="encuesta_acreditacion_egresados.asp?busqueda[0][carr_ccod]=" + document.buscador.elements["busqueda[0][carr_ccod]"].value;
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
            <td><% pagina.DibujarLenguetas lenguetas_encuesta, 4 %></td>
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
									  preg1_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_1=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg1_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_1=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg1_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_1=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg1_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_1=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_1 = cint(preg1_4) + cint(preg1_3) + cint(preg1_2) + cint(preg1_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>1.</strong> La formación y los conocimientos entregados por la carrera de la Universidad del Pacífico a sus egresados, permiten satisfacer los requerimientos de nuestra organización.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg1_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg1_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg1_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg1_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_1%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg2_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_2=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg2_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_2=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg2_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_2=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg2_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_2=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_2 = cint(preg2_4) + cint(preg2_3) + cint(preg2_2) + cint(preg2_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>2.</strong> El perfil del egresado de la Universidad del Pacífico, esto es, el conjunto de las características que reúne un egresado de la carrera e institución mencionadas, es difundido y conocido.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg2_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg2_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg2_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg2_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_2%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg3_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_3=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg3_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_3=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg3_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_3=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg3_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_3=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_3 = cint(preg3_4) + cint(preg3_3) + cint(preg3_2) + cint(preg3_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>3.</strong> El perfil del egresado de la carrera de la Universidad del Pacífico, me parece bueno y adecuado a los requerimientos del medio laboral.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg3_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg3_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg3_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg3_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_3%></strong></div></td>
									  </tr>
									  
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg4_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_4=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg4_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_4=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg4_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_4=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg4_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_4=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_4 = cint(preg4_4) + cint(preg4_3) + cint(preg4_2) + cint(preg4_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>4.</strong> Las autoridades de la carrera de la Universidad del Pacífico consultan regularmente mis opiniones como empleador.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg4_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg4_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg4_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg4_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_4%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg5_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_5=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg5_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_5=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg5_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_5=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg5_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_5=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_5 = cint(preg5_4) + cint(preg5_3) + cint(preg5_2) + cint(preg5_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>5.</strong> Cuando requiero profesionales, mi organización recurre a la Universidad del Pacífico para buscar empleados capaces.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg5_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg5_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg5_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg5_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_5%></strong></div></td>
									  </tr>
									  <tr borderColor="#999999" bgColor="#c4d7ff">
										<th colspan="6"><FONT color="#333333"><div align="left"><strong><font size="2"><strong><font size="2"><strong>Dimensión 2: NORMATIVA, GOBIERNO Y ADMINISTRACIÓN.</strong></font></strong></font></strong></div></font></th>
        							  </tr>
									  
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg6_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_6=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg6_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_6=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg6_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_6=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg6_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_6=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_6 = cint(preg6_4) + cint(preg6_3) + cint(preg6_2) + cint(preg6_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>6.</strong> La publicidad de Universidad del Pacífico sobre sus egresados es verídica.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg6_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg6_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg6_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg6_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_6%></strong></div></td>
									  </tr>
									  
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg7_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_7=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg7_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_7=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg7_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_7=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg7_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_7=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_7 = cint(preg7_4) + cint(preg7_3) + cint(preg7_2) + cint(preg7_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>7.</strong> La Universidad del Pacífico, da confianza a mi organización como formadora de profesionales.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg7_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg7_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg7_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg7_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_7%></strong></div></td>
									  </tr>
									   <tr borderColor="#999999" bgColor="#c4d7ff">
										<th colspan="6"><FONT color="#333333"><div align="left"><strong><font size="2"><strong><font size="2"><strong>Dimensión 3:FUNCIONES INSTITUCIONALES: PROGRAMAS EDUCACIONALES.</strong></font></strong></font></strong></div></font></th>
        							  </tr>
									  
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg8_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_8=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg8_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_8=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg8_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_8=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg8_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_8=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_8 = cint(preg8_4) + cint(preg8_3) + cint(preg8_2) + cint(preg8_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>8.</strong> Los contenidos que los egresados de la Universidad del Pacífico manejan, son útiles y/o relevantes para el desempeño profesional en mi organización.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg8_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg8_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg8_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg8_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_8%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg9_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_9=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg9_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_9=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg9_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_9=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg9_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_9=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_9 = cint(preg9_4) + cint(preg9_3) + cint(preg9_2) + cint(preg9_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>9.</strong> Los egresados de la Universidad del Pacífico pueden conciliar adecuadamente el conocimiento teórico y el práctico.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg9_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg9_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg9_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg9_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_9%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg10_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_10=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg10_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_10=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg10_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_10=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg10_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_10=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_10 = cint(preg10_4) + cint(preg10_3) + cint(preg10_2) + cint(preg10_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>10.</strong> Los egresados de la Universidad del Pacífico muestran facilidad de expresión oral y escrita.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg10_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg10_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg10_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg10_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_10%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg11_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_11=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg11_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_11=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg11_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_11=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg11_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_11=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_11 = cint(preg11_4) + cint(preg11_3) + cint(preg11_2) + cint(preg11_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>11.</strong> Los egresados de la Universidad del Pacífico están en condiciones de emitir su propia opinión fundamentada en base al conocimiento recibido.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg11_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg11_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg11_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg11_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_11%></strong></div></td>
									  </tr>
									 
									   
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg12_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_12=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg12_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_12=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg12_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_12=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg12_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_12=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_12 = cint(preg12_4) + cint(preg12_3) + cint(preg12_2) + cint(preg12_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>12.</strong> Los egresados de la Universidad del Pacífico pueden diagnosticar problemas y resolverlos.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg12_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg12_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg12_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg12_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_12%></strong></div></td>
									  </tr>
									  
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg13_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_13=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg13_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_13=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg13_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_13=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg13_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_13=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_13 = cint(preg13_4) + cint(preg13_3) + cint(preg13_2) + cint(preg13_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>13.</strong> Los egresados de la Universidad del Pacífico son capaces de trabajar en equipo.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg13_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg13_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg13_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg13_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_13%></strong></div></td>
									  </tr>
									  
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg14_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_14=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg14_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_14=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg14_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_14=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg14_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_14=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_14 = cint(preg14_4) + cint(preg14_3) + cint(preg14_2) + cint(preg14_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>14.</strong> Los egresados de la Universidad del Pacífico muestran una alta motivación para investigar y profundizar sus conocimientos.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg14_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg14_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg14_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg14_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_14%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg15_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_15=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg15_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_15=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg15_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_15=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg15_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_15=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_15 = cint(preg15_4) + cint(preg15_3) + cint(preg15_2) + cint(preg15_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>15.</strong> Respetan la opinión de los otros, incluso estando en desacuerdo.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg15_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg15_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg15_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg15_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_15%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg16_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_16=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg16_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_16=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg16_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_16=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg16_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_16=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_16 = cint(preg16_4) + cint(preg16_3) + cint(preg16_2) + cint(preg16_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>16.</strong> Son capaces de comprender el mundo actual.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg16_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg16_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg16_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg16_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_16%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg17_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_17=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg17_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_17=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg17_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_17=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg17_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_17=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_17 = cint(preg17_4) + cint(preg17_3) + cint(preg17_2) + cint(preg17_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>17.</strong> A los egresados de la Universidad del Pacífico, les interesan los problemas de su comunidad, ciudad y/o país y se sienten inclinados a resolverlos y discutirlos.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg17_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg17_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg17_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg17_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_17%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg18_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_18=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg18_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_18=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg18_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_18=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg18_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_18=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_18 = cint(preg18_4) + cint(preg18_3) + cint(preg18_2) + cint(preg18_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>18.</strong> Tienen una formación completa que les permite comprender desde eventos históricos hasta expresiones artísticas.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg18_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg18_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg18_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg18_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_18%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg19_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_19=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg19_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_19=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg19_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_19=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg19_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_19=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_19 = cint(preg19_4) + cint(preg19_3) + cint(preg19_2) + cint(preg19_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>19.</strong> Los directivos de la carrera de la Universidad del Pacífico, mantienen un fuerte vínculo con el medio laboral.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg19_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg19_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg19_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg19_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_19%></strong></div></td>
									  </tr>
									  <tr borderColor="#999999" bgColor="#c4d7ff">
										<th colspan="6"><FONT color="#333333"><div align="left"><strong>Dimensión 5: DESARROLLO INSTITUCIONAL.</strong></div></font></th>
        							  </tr>
									 <tr bgcolor="#FFFFFF">
									  <%
									  preg29_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_29=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg29_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_29=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg29_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_29=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg29_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_29=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_29 = cint(preg29_4) + cint(preg29_3) + cint(preg29_2) + cint(preg29_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>29.</strong> Estoy informado de que en la Universidad del Pacífico, se imparten interesantes y útiles cursos para el perfeccionamiento, actualización y/o capacitación profesional.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg29_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg29_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg29_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg29_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_29%></strong></div></td>
									  </tr>
									  <tr borderColor="#999999" bgColor="#c4d7ff">
										<th colspan="6"><FONT color="#333333"><div align="left"><strong>Dimensión 6: SATISFACCIÓN CON LOS PROFESIONALES.</strong></div></font></th>
        							  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg30_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_30=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg30_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_30=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg30_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_30=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg30_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_30=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_30 = cint(preg30_4) + cint(preg30_3) + cint(preg30_2) + cint(preg30_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>30.</strong> Tengo la convicción de que los egresados de la Universidad del Pacífico tienen una excelente reputación y valoración.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg30_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg30_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg30_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg30_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_30%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg31_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_31=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg31_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_31=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg31_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_31=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg31_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_31=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_31 = cint(preg31_4) + cint(preg31_3) + cint(preg31_2) + cint(preg31_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>31.</strong> A mi juicio la carrera de la Universidad del Pacífico es reconocida porque forma profesionales de calidad.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg31_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg31_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg31_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg31_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_31%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg32_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_32=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg32_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_32=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg32_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_32=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg32_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_32=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_32 = cint(preg32_4) + cint(preg32_3) + cint(preg32_2) + cint(preg32_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>32.</strong> El desempeño profesional de los egresados de la Universidad del Pacífico es muy bueno.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg32_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg32_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg32_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg32_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_32%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg33_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_33=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg33_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_33=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg33_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_33=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg33_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_33=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_33 = cint(preg33_4) + cint(preg33_3) + cint(preg33_2) + cint(preg33_1)
									  %>
										<td width="55%"><div align="left" class="Estilo2"><strong>33.</strong> Los egresados de la Universidad del Pacífico se comparan favorablemente, en términos profesionales, con los de otras instituciones.</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg33_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg33_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg33_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg33_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_33%></strong></div></td>
									  </tr>
									</table>                    								
								</td>
                              </tr>
							  <tr><td>&nbsp;</td></tr>
							  <tr><td >&nbsp;</td></tr>
							  <tr>
							     <td><table width="100%" class="v1" border="1" cellpadding="0" cellspacing="0" borderColor="#999999" bgColor="#adadad">
									 <tr borderColor="#999999" bgColor="#c4d7ff">
										<th width="45%"  valign="top"><FONT color="#333333"><div align="left"><strong>PREGUNTA</strong></div></font></th>
										<th width="10%"  valign="top"><FONT color="#333333"><div align="center"><strong>Menos de $200.000</strong></div></font></th>
										<th width="10%"  valign="top"><FONT color="#333333"><div align="center"><strong>Entre $200.001 y $500.000</strong></div></font></th>
										<th width="10%"  valign="top"><FONT color="#333333"><div align="center"><strong>Entre $500.001 y $1.000.000</strong></div></font></th>
										<th width="10%"  valign="top"><FONT color="#333333"><div align="center"><strong>Entre $1.000.001 y $1.500.000</strong></div></font></th>
										<th width="10%"  valign="top"><FONT color="#333333"><div align="center"><strong>Más de $1.500.001</strong></div></font></th>
										<th width="5%"  valign="top"><FONT color="#333333"><div align="center"><strong>TOTAL</strong></div></font></th>
									  </tr>
									  <tr borderColor="#999999" bgColor="#FFFFFF">
										<th colspan="7"><FONT color="#333333"><div align="left"><strong>34. Señale cuál es el nivel de renta aproximada a la que optan en su organización, profesionales egresados de la Universidad del Pacífico, de acuerdo a los años de experiencia.</strong></div></font></th>
        							  </tr> 
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg341_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_341=5 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg341_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_341=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg341_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_341=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg341_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_341=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg341_5= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_341=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total34_1 = cint(preg341_1) + cint(preg341_2) + cint(preg341_3) + cint(preg341_4) + cint(preg341_5)
									  %>
										<td width="45%"><div align="left" class="Estilo2"><strong>34.1</strong>  Menos de un año de experiencia:</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg341_1%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg341_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg341_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg341_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg341_5%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total34_1%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg342_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_342=5 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg342_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_342=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg342_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_342=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg342_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_342=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg342_5= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_342=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total34_2 = cint(preg342_1) + cint(preg342_2) + cint(preg342_3) + cint(preg342_4) + cint(preg342_5)
									  %>
										<td width="45%"><div align="left" class="Estilo2"><strong>34.2</strong>  Entre uno y tres  años de experiencia:</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg342_1%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg342_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg342_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg342_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg342_5%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total34_2%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg343_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_343=5 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg343_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_343=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg343_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_343=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg343_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_343=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg343_5= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_343=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total34_3 = cint(preg343_1) + cint(preg343_2) + cint(preg343_3) + cint(preg343_4) + cint(preg343_5)
									  %>
										<td width="45%"><div align="left" class="Estilo2"><strong>34.3</strong>  Entre tres y cinco años de experiencia:</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg343_1%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg343_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg343_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg343_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg343_5%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total34_3%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg344_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_344=5 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg344_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_344=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg344_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_344=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg344_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_344=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg344_5= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_344=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total34_4 = cint(preg344_1) + cint(preg344_2) + cint(preg344_3) + cint(preg344_4) + cint(preg344_5)
									  %>
										<td width="45%"><div align="left" class="Estilo2"><strong>34.4</strong>  Más de cinco años de experiencia:</div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg344_1%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg344_2%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg344_3%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg344_4%></div></td>
										<td width="10%"><div align="center" class="Estilo2 Estilo3"><%=preg344_5%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total34_4%></strong></div></td>
									  </tr>
									  </table>
							     </td>
							  </tr>
							  
							  <tr><td>&nbsp;</td></tr>
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
										<th colspan="9"><FONT color="#333333"><div align="left"><strong>Dimensión 4: EVALUACIÓN DE COMPETENCIAS GENERALES.</strong></div></font></th>
        							  </tr> 
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg20_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_20=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg20_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_20=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg20_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_20=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg20_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_20=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg20_5= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_20=5 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg20_6= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_20=6 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg20_7= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_20=7 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_20 = cint(preg20_1) + cint(preg20_2) + cint(preg20_3) + cint(preg20_4) + cint(preg20_5) + cint(preg20_6) + cint(preg20_7)
									  %>
										<td width="60%"><div align="left" class="Estilo2"><strong>20- Comunicación</strong>: Capacidad para comunicarse de manera efectiva a través del lenguaje oral y escrito, técnico y computacional necesario para el ejercicio de la profesión.</div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg20_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg20_2%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg20_3%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg20_4%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg20_5%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg20_6%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg20_7%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_20%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg21_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_21=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg21_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_21=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg21_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_21=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg21_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_21=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg21_5= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_21=5 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg21_6= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_21=6 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg21_7= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_21=7 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_21 = cint(preg21_1) + cint(preg21_2) + cint(preg21_3) + cint(preg21_4) + cint(preg21_5) + cint(preg21_6) + cint(preg21_7)
									  %>
										<td width="60%"><div align="left" class="Estilo2"><strong>21- Pensamiento crítico</strong>: Capacidad para utilizar el conocimiento, la experiencia y el razonamiento para emitir juicios fundados.</div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg21_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg21_2%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg21_3%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg21_4%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg21_5%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg21_6%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg21_7%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_21%></strong></div></td>
									  </tr>
									  <tr bgcolor="#FFFFFF">
									  <%
									  preg22_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_22=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg22_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_22=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg22_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_22=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg22_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_22=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg22_5= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_22=5 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg22_6= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_22=6 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg22_7= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_22=7 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_22 = cint(preg22_1) + cint(preg22_2) + cint(preg22_3) + cint(preg22_4) + cint(preg22_5) + cint(preg22_6) + cint(preg22_7)
									  %>
										<td width="60%"><div align="left" class="Estilo2"><strong>22- Solución de problemas</strong>: Capacidad para identificar problemas, planificar estrategias y enfrentarlos.</div></td>
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
									  preg23_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_23=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg23_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_23=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg23_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_23=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg23_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_23=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg23_5= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_23=5 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg23_6= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_23=6 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg23_7= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_23=7 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_23 = cint(preg23_1) + cint(preg23_2) + cint(preg23_3) + cint(preg23_4) + cint(preg23_5) + cint(preg23_6) + cint(preg23_7)
									  %>
										<td width="60%"><div align="left" class="Estilo2"><strong>23- Interacción social</strong>: Capacidad para formar parte de equipos de trabajo, y participar en proyectos grupales.</div></td>
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
									  preg24_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_24=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg24_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_24=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg24_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_24=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg24_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_24=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg24_5= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_24=5 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg24_6= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_24=6 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg24_7= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_24=7 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_24 = cint(preg24_1) + cint(preg24_2) + cint(preg24_3) + cint(preg24_4) + cint(preg24_5) + cint(preg24_6) + cint(preg24_7)
									  %>
										<td width="60%"><div align="left" class="Estilo2"><strong>24- Autoaprendizaje e iniciativa personal</strong>: Inquietud y búsqueda permanente de nuevos conocimientos y capacidad de aplicarlos y perfeccionar sus conocimientos anteriores.</div></td>
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
									  preg25_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_25=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg25_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_25=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg25_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_25=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg25_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_25=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg25_5= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_25=5 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg25_6= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_25=6 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg25_7= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_25=7 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_25 = cint(preg25_1) + cint(preg25_2) + cint(preg25_3) + cint(preg25_4) + cint(preg25_5) + cint(preg25_6) + cint(preg25_7)
									  %>
										<td width="60%"><div align="left" class="Estilo2"><strong>25- Formación y consistencia ética</strong>: Capacidad para asumir principios éticos y respetar los principios del otro, como norma de convivencia social.</div></td>
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
									  preg26_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_26=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg26_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_26=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg26_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_26=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg26_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_26=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg26_5= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_26=5 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg26_6= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_26=6 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg26_7= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_26=7 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_26 = cint(preg26_1) + cint(preg26_2) + cint(preg26_3) + cint(preg26_4) + cint(preg26_5) + cint(preg26_6) + cint(preg26_7)
									  %>
										<td width="60%"><div align="left" class="Estilo2"><strong>26- Pensamiento Globalizado</strong>: Capacidad para comprender los aspectos interdependientes del mundo globalizado.</div></td>
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
									  preg27_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_27=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg27_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_27=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg27_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_27=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg27_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_27=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg27_5= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_27=5 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg27_6= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_27=6 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg27_7= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_27=7 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_27 = cint(preg27_1) + cint(preg27_2) + cint(preg27_3) + cint(preg27_4) + cint(preg27_5) + cint(preg27_6) + cint(preg27_7)
									  %>
										<td width="60%"><div align="left" class="Estilo2"><strong>27- Formación Ciudadana</strong>: Capacidad para integrarse a la comunidad y participar responsablemente en la vida ciudadana.</div></td>
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
									  preg28_1= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_28=1 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg28_2= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_28=2 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg28_3= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_28=3 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg28_4= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_28=4 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg28_5= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_28=5 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg28_6= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_28=6 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  preg28_7= conexion.consultaUno("select count(*) from encuestas_empleadores where preg_28=7 and isnull(antiguos,'N')='N' " &filtro_carrera)
									  total_28 = cint(preg28_1) + cint(preg28_2) + cint(preg28_3) + cint(preg28_4) + cint(preg28_5) + cint(preg28_6) + cint(preg28_7)
									  %>
										<td width="60%"><div align="left" class="Estilo2"><strong>28- Sensibilidad estética</strong>: Capacidad de apreciar y valorar diversas formas artísticas y los contextos de donde provienen.</div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg28_1%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg28_2%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg28_3%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg28_4%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg28_5%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg28_6%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><%=preg28_7%></div></td>
										<td width="5%"><div align="center" class="Estilo2 Estilo3"><strong><%=total_28%></strong></div></td>
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
				   botonera.agregaBotonParam "excel","url","encuesta_acreditacion_empleadores_excel.asp?carr_ccod="&carr_ccod%>
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
