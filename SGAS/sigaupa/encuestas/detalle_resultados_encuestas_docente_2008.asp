<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

set errores = new CErrores
set pagina = new CPagina
 

pers_ncorr = request.querystring("pers_ncorr")
secc_ccod = request.querystring("secc_ccod")
origen = request.querystring("origen")
pers_ncorr_profesor = pers_ncorr

set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set botonera = new CFormulario
botonera.Carga_Parametros "m_ver.xml", "botonera2"

peri_ccod = conectar.consultaUno("select peri_ccod from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")
pagina.Titulo = "Cuestionario de Opinión de alumnos"
'response.End()


set datos_generales= new cformulario
datos_generales.carga_parametros "tabla_vacia.xml","tabla"
datos_generales.inicializar conectar
Query_datos_generales = " Select protic.initcap(carr_tdesc) as carrera, ltrim(rtrim(b.asig_ccod))+' ' + protic.initCap(b.asig_tdesc) as asignatura,  "& vbCrLf &_ 
                        " secc_tdesc as seccion,a.peri_ccod,a.carr_ccod, f.pers_tnombre + ' ' + f.pers_tape_paterno + ' ' + f.pers_tape_materno as profesor,  "& vbCrLf &_ 
						" f.pers_nrut,a.sede_ccod,jorn_ccod, f.pers_xdv,(select count(*) from cuestionario_opinion_alumnos bb where bb.secc_ccod=a.secc_Ccod and bb.pers_ncorr_profesor=f.pers_ncorr and isnull(estado_cuestionario,0) = 2) as cantidad_encuestas  "& vbCrLf &_ 
						" from secciones a, asignaturas b, carreras c, bloques_horarios d, bloques_profesores e, personas f  "& vbCrLf &_ 
						" where a.asig_ccod=b.asig_ccod and a.carr_ccod=c.carr_ccod  "& vbCrLf &_ 
						" and a.secc_ccod=d.secc_ccod and d.bloq_ccod=e.bloq_ccod and e.pers_ncorr=f.pers_ncorr and cast(f.pers_ncorr as varchar)='"&pers_ncorr_profesor&"' "& vbCrLf &_ 
						" and cast(a.secc_ccod as varchar)='"&secc_ccod&"'"
'response.Write("<pre>"&Query_datos_generales&"</pre>")
'
datos_generales.consultar Query_datos_generales
datos_generales.siguiente
'------------------buscamos que datos vamos mostrar en el encabezado de la encuesta
carrera    = datos_generales.obtenerValor("carrera")
asignatura = datos_generales.obtenerValor("asignatura")
seccion    = datos_generales.obtenerValor("seccion")
carr_ccod  = datos_generales.obtenerValor("carr_ccod")
peri_ccod  = datos_generales.obtenerValor("peri_ccod")
profesor   = datos_generales.obtenerValor("profesor")
cantidad_encuestas = datos_generales.obtenerValor("cantidad_encuestas")
pers_nrut = datos_generales.obtenerValor("pers_nrut")
pers_xdv  = datos_generales.obtenerValor("pers_xdv")
sede  = datos_generales.obtenerValor("sede_ccod")
jorn  = datos_generales.obtenerValor("jorn_ccod")


set notas= new cformulario
notas.carga_parametros "tabla_vacia.xml","tabla"
notas.inicializar conectar
Query_notas = " select d.matr_ncorr,d.secc_ccod,ltrim(rtrim(isnull(d.sitf_ccod,'SP'))) as sitf_ccod  "& vbCrLf &_ 
			  " from bloques_profesores a, bloques_horarios b, secciones c,cargas_Academicas d  "& vbCrLf &_
			  " where a.bloq_ccod=b.bloq_ccod   "& vbCrLf &_
			  " and b.secc_ccod = c.secc_ccod  "& vbCrLf &_
			  " and c.secc_ccod = d.secc_ccod  and cast(c.secc_Ccod as varchar)='"&secc_ccod&"'"& vbCrLf &_
			  " and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'  "& vbCrLf &_
			  " and a.tpro_ccod = 1  "& vbCrLf &_
			  " and exists (select 1 from cuestionario_opinion_alumnos aa where aa.secc_ccod=c.secc_ccod and aa.pers_ncorr_profesor = a.pers_ncorr and isnull(aa.estado_cuestionario,0) = 2 )"


notas.consultar Query_notas
'response.Write("<pre>"&Query_notas&"</pre>")

contador_total = 0
contador_reprobados = 0
contador_aprobados = 0
contador_pendientes = 0
while notas.siguiente 
	contador_total = contador_total + 1
	if notas.obtenerValor("sitf_ccod")="R" then
		contador_reprobados= contador_reprobados + 1
	elseif notas.obtenerValor("sitf_ccod")="A" then
		contador_aprobados= contador_aprobados + 1
	end if
	if notas.obtenerValor("sitf_ccod")="SP" then
		contador_pendientes= contador_pendientes + 1
	end if		
wend
notas.primero

carr= carr_ccod


'---------------------------------------Detalle tabla de gráfico----------------------------------------------
'-------------------------------------Marcelo Sandoval 01-06-2007---------------------------------------------
cantidad_x_profesor = cantidad_encuestas
if cantidad_x_profesor <> "0" then
 		nivel_1_x_profesor = conectar.consultaUno("select cast(avg(promedio_dimension_1) as decimal(7,6)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 ")
		nivel_2_x_profesor = conectar.consultaUno("select cast(avg(promedio_dimension_2) as decimal(7,6)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 ")
		nivel_3_x_profesor = conectar.consultaUno("select cast(avg(promedio_dimension_3) as decimal(7,6)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 ")
		nivel_4_x_profesor = conectar.consultaUno("select cast(avg(promedio_dimension_4) as decimal(7,6)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 ")
else
        nivel_1_x_profesor = 0
		nivel_2_x_profesor = 0
		nivel_3_x_profesor = 0
		nivel_4_x_profesor = 0
		
end if
total_x_profesor = conectar.consultaUno("select cast(avg(puntaje_total) as decimal(9,8)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 ")

cantidad_x_carrera = conectar.consultaUno("select count(*) from secciones a, cuestionario_opinion_alumnos b where cast(a.carr_ccod as varchar)= '"&carr_ccod&"' and  cast(a.peri_ccod as varchar)= '"&peri_ccod&"' and a.secc_ccod=b.secc_ccod and isnull(estado_cuestionario,0) = 2 ")

if cantidad_x_carrera <> "0" then
        nivel_1_x_carrera = conectar.consultaUno("select cast(avg(promedio_dimension_1) as decimal(7,6)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 ")
		nivel_2_x_carrera = conectar.consultaUno("select cast(avg(promedio_dimension_2) as decimal(7,6)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 ")
		nivel_3_x_carrera = conectar.consultaUno("select cast(avg(promedio_dimension_3) as decimal(7,6)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 ")
		nivel_4_x_carrera = conectar.consultaUno("select cast(avg(promedio_dimension_4) as decimal(7,6)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 ")

else
        nivel_1_x_carrera = 0
		nivel_2_x_carrera = 0
		nivel_3_x_carrera = 0
		nivel_4_x_carrera = 0
end if
total_x_carrera = conectar.consultaUno("select cast(avg(puntaje_total) as decimal(9,8)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 ")

'response.Write("<hr>"&carr_ccod)

facu_ccod = conectar.consultaUno("select b.facu_ccod from carreras a, areas_academicas b where a.area_ccod=b.area_ccod and a.carr_ccod='"&carr_ccod&"'")
cantidad_x_facultad = conectar.consultaUno("select count(*) from secciones a,cuestionario_opinion_alumnos b where carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(a.peri_ccod as varchar)='"&peri_ccod&"' and a.secc_ccod=b.secc_ccod and isnull(estado_cuestionario,0) = 2 ")

if cantidad_x_facultad <> "0" then
		nivel_1_x_facultad = conectar.consultaUno("select cast(avg(promedio_dimension_1) as decimal(7,6)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 ")
		nivel_2_x_facultad = conectar.consultaUno("select cast(avg(promedio_dimension_2) as decimal(7,6)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 ")
		nivel_3_x_facultad = conectar.consultaUno("select cast(avg(promedio_dimension_3) as decimal(7,6)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 ")
		nivel_4_x_facultad = conectar.consultaUno("select cast(avg(promedio_dimension_4) as decimal(7,6)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 ")
else
        nivel_1_x_facultad = 0
		nivel_2_x_facultad = 0
		nivel_3_x_facultad = 0
		nivel_4_x_facultad = 0
end if
total_x_facultad = conectar.consultaUno("select cast(avg(puntaje_total) as decimal(9,8)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 ")
cantidad_x_universidad = conectar.consultaUno("select count(*) from cuestionario_opinion_alumnos a,secciones b where a.secc_ccod=b.secc_ccod and cast(b.peri_ccod as varchar)='"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2")

if cantidad_x_universidad <> "0" then
		nivel_1_x_universidad = conectar.consultaUno("select cast(avg(promedio_dimension_1) as decimal(7,6)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 ")
		nivel_2_x_universidad = conectar.consultaUno("select cast(avg(promedio_dimension_2) as decimal(7,6)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 ")
		nivel_3_x_universidad = conectar.consultaUno("select cast(avg(promedio_dimension_3) as decimal(7,6)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 ")
		nivel_4_x_universidad = conectar.consultaUno("select cast(avg(promedio_dimension_4) as decimal(7,6)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 ")

else
        nivel_1_x_universidad = 0
		nivel_2_x_universidad = 0
		nivel_3_x_universidad = 0
		nivel_4_x_universidad = 0
end if
total_x_universidad = conectar.consultaUno("select cast(avg(puntaje_total) as decimal(9,8)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 ")


docente = profesor
facultad = conectar.consultaUno("Select facu_tdesc from facultades where facu_ccod ='"&facu_ccod&"'")


usuario = negocio.obtenerUsuario
pers_ncorr_temporal = conectar.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")
'response.Write("profesor "&pers_ncorr_profesor&" temporal "&pers_ncorr_temporal)
if clng(pers_ncorr_profesor) = clng(pers_ncorr_temporal) then
	ocultar="S"
else
	ocultar="N"	
end if
'response.End()
'response.Write(ocultar)
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
function Volver()
{
   var origen = '<%=origen%>';
   if (origen != '2')
   		{location.href ="RESULTADOS_ENCUESTAS_DOCENTE_2008.ASP?busqueda[0][pers_nrut]="+<%=pers_nrut%>+"&busqueda[0][pers_xdv]="+'<%=pers_xdv%>';}
   else
   	    {location.href ="ANALISIS_RESULTADOS_ENCUESTAS_2008.ASP?busqueda[0][SEDE_CCOD]="+<%=sede%>+"&busqueda[0][JORN_CCOD]="+<%=jorn%>+"&busqueda[0][CARR_CCOD]="+'<%=carr_ccod%>';}		
}

</script>


</head>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
 <tr>
    <td height="72" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<form name="edicion">
		<% 
		  	contestada = conectar.consultaUno("Select Count(*) from cuestionario_opinion_alumnos where cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_profesor as varchar)='"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 ")
		%>
	  <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
             <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0" aling="center">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">			        <div align="center">
                      <%pagina.DibujarTituloPagina%>
                      <BR>
                      <table width="100%"  border="0" align="center">
                        <tr> 
                          <td colspan="3">&nbsp;</td>
						</tr>
						<tr>
							<td colspan="3">
							<table width="100%" border="0">
								 <%if secc_ccod <> "" then%>
								  <tr> 
									<td width="18%" align="left"><strong>Escuela</strong> </td>
									<td width="1%"><strong>:</strong></td>
									<td width="38%" align="left"><font color="#CC0000"><%=carrera%></font></td>
									<td width="14%" align="right"><strong>Secci&oacute;n</strong></td>
									<td width="2%"><strong>:</strong></td>
									<td colspan="3" align="left"><font color="#CC0000"><%=seccion%></font></td>
								  </tr>
  								  <tr> 
									<td width="18%" align="left"><strong>Asignatura</strong></td>
									<td width="1%"><strong>:</strong></td>
									<td width="38%" align="left"><font color="#CC0000"><%=asignatura%></font></td>
									<td width="14%" align="right"><strong>Cant. Alumnos</strong></td>
									<td width="2%"><strong>:</strong></td>
									<td colspan="3" align="left"><font color="#CC0000"><%=cantidad_encuestas%></font></td>
								  </tr>
								  <%end if%>
								   <tr> 
									<td width="18%" align="left"><strong>Profesor</strong> </td>
									<td width="1%"><strong>:</strong></td>
									<td colspan="6" align="left"><strong><font color="#CC0000"><%=profesor%></font></strong></td>
								  </tr>
						    </table>
							</td>
						</tr>
						<tr>  
						  <td colspan="3" height="20"></td>
						</tr> 
                        <!--
						<tr>
							   <td colspan="3" align="center">
									<table width="90%" border="1" bordercolor="#990000" bgcolor="#FFFFFF">
										<tr>
										    
											<td colspan="2" align="left"><strong>&nbsp;</strong></td>
										    <td align="left"><strong>DIMENSIÓN 1</strong></td>
											<td align="left"><strong>DIMENSIÓN 2</strong></td>
											<td align="left"><strong>DIMENSIÓN 3</strong></td>
											<td align="left"><strong>DIMENSIÓN 4</strong></td>
											<td align="left"><strong>PUNTAJE TOTAL</strong></td>
										</tr>
										<tr>
										    <td width="5%" bgcolor="#fcfa95">&nbsp;</td>
											<td width="35%" align="left"><strong><%="PROMEDIO PROFESOR "&docente%></strong></td>
										    <td align="center"><%=nivel_1_x_profesor%></td>
											<td align="center"><%=nivel_2_x_profesor%></td>
											<td align="center"><%=nivel_3_x_profesor%></td>
											<td align="center"><%=nivel_4_x_profesor%></td>
											<td align="center"><%=total_x_profesor%></td>
										</tr>
										<tr>
										    <td width="5%" bgcolor="#e9e8d2">&nbsp;</td>
											<td width="35%" align="left"><strong><%="PROMEDIO CARRERA "&carrera%></strong></td>
										    <td align="center"><%=nivel_1_x_carrera%></td>
											<td align="center"><%=nivel_2_x_carrera%></td>
											<td align="center"><%=nivel_3_x_carrera%></td>
											<td align="center"><%=nivel_4_x_carrera%></td>
											<td align="center"><%=total_x_carrera%></td>
										</tr>
										<tr>
										    <td width="5%" bgcolor="#e5e6ff">&nbsp;</td>
											<td width="35%" align="left"><strong><%="PROMEDIO "&facultad%></strong></td>
										    <td align="center"><%=nivel_1_x_facultad%></td>
											<td align="center"><%=nivel_2_x_facultad%></td>
											<td align="center"><%=nivel_3_x_facultad%></td>
											<td align="center"><%=nivel_4_x_facultad%></td>
											<td align="center"><%=total_x_facultad%></td>
										</tr>
										<tr>
										    <td width="5%" bgcolor="#6f79ff">&nbsp;</td>
											<td width="35%" align="left"><strong><%="PROMEDIO UNIVERSIDAD DEL PACIFICO"%></strong></td>
										    <td align="center"><%=nivel_1_x_universidad%></td>
											<td align="center"><%=nivel_2_x_universidad%></td>
											<td align="center"><%=nivel_3_x_universidad%></td>
											<td align="center"><%=nivel_4_x_universidad%></td>
											<td align="center"><%=total_x_universidad%></td>
										</tr>
									</table>
							   </td>
							</tr>
							<tr>
								<td colspan="3" align="center"><img border="0" src="grafico_barras_2008.asp?pers_ncorr=<%=pers_ncorr%>&secc_ccod=<%=secc_ccod%>" ></td>
							</tr>-->
							<tr>
							    <td colspan="3">&nbsp;</td>
							</tr>
							<tr>
							    <td colspan="3" align="center">
									<table width="90%" border="1" bordercolor="#990000" bgcolor="#FFFFFF">
										<tr>
											<td colspan="6" bgcolor="#990000" align="center"><font color="#FFFFFF"><strong>DIMENSIÓN I: Enseñanza para el aprendizaje</strong></font></td>
										</tr>
										<tr>
											<td width="3%" align="left"><strong>N°</strong></td>
											<td width="57%" align="left"><strong>PREGUNTA</strong></td>
											<td width="10%" align="left" bgcolor="#fcfa95"><strong>Profesor</strong></td>
											<td width="10%" align="left" bgcolor="#e9e8d2"><strong>Carrera</strong></td>
											<td width="10%" align="left" bgcolor="#e5e6ff"><strong>Facultad</strong></td>
											<td width="10%" align="left" bgcolor="#6f79ff"><strong>Universidad</strong></td>
										</tr>
										<tr>
											<td width="3%" align="left">1</td>
											<td width="57%" align="left">¿El/la docente explicó clara y oportunamente los objetivos, metodología y bibliografía a utilizar, al inicio del curso?</td>
											<td width="10%" align="center"  bgcolor="#fcfa95">
												<% preg1_profesor = conectar.consultaUno("select cast(avg(parte_2_1) as decimal(4,3)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_1,0) <> 0 ")
												   response.Write(preg1_profesor)%>
											</td>
											<td width="10%" align="center" bgcolor="#e9e8d2">
												<% preg1_carrera = conectar.consultaUno("select cast(avg(parte_2_1) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_1,0) <> 0")
												   response.Write(preg1_carrera)%></td>
											<td width="10%" align="center" bgcolor="#e5e6ff">
											    <% preg1_facultad = conectar.consultaUno("select cast(avg(parte_2_1) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_1,0) <> 0")
												   response.Write(preg1_facultad)%></td>
											<td width="10%" align="center" bgcolor="#6f79ff">
											    <% preg1_universidad = conectar.consultaUno("select cast(avg(parte_2_1) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_1,0) <> 0")
												   response.Write(preg1_universidad) %></td>
										</tr>
										<tr>
											<td width="3%" align="left">2</td>
											<td width="57%" align="left">¿Qué tan significativas para mi aprendizaje fueron las actividades desarrolladas por el/la docente en clases?</td>
											<td width="10%" align="center"  bgcolor="#fcfa95">
											    <% preg2_profesor = conectar.consultaUno("select cast(avg(parte_2_2) as decimal(4,3)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_2,0) <> 0")
												   response.Write(preg2_profesor)%></td>
											<td width="10%" align="center" bgcolor="#e9e8d2">
												<% preg2_carrera = conectar.consultaUno("select cast(avg(parte_2_2) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_2,0) <> 0")
												   response.Write(preg2_carrera)%></td>
											<td width="10%" align="center" bgcolor="#e5e6ff">
											    <% preg2_facultad = conectar.consultaUno("select cast(avg(parte_2_2) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_2,0) <> 0")
												   response.Write(preg2_facultad)%></td>
											<td width="10%" align="center" bgcolor="#6f79ff">
											    <% preg2_universidad = conectar.consultaUno("select cast(avg(parte_2_2) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_2,0) <> 0")
												   response.Write(preg2_universidad) %></td>
										</tr>
										<tr>
											<td width="3%" align="left">3</td>
											<td width="57%" align="left">Las clases desarrolladas por el/la docente ¿me dieron la posibilidad de pensar, observar, investigar, practicar y sacar mis propias conclusiones?</td>
											<td width="10%" align="center"  bgcolor="#fcfa95">
											<% preg3_profesor = conectar.consultaUno("select cast(avg(parte_2_3) as decimal(4,3)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_3,0) <> 0")
												   response.Write(preg3_profesor)%>
											</td>
											<td width="10%" align="center" bgcolor="#e9e8d2">
												<% preg3_carrera = conectar.consultaUno("select cast(avg(parte_2_3) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_3,0) <> 0")
												   response.Write(preg3_carrera)%></td>
											<td width="10%" align="center" bgcolor="#e5e6ff">
											    <% preg3_facultad = conectar.consultaUno("select cast(avg(parte_2_3) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_3,0) <> 0")
												   response.Write(preg3_facultad)%></td>
											<td width="10%" align="center" bgcolor="#6f79ff">
											    <% preg3_universidad = conectar.consultaUno("select cast(avg(parte_2_3) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_3,0) <> 0")
												   response.Write(preg3_universidad) %></td>
										</tr>
										<tr>
											<td width="3%" align="left">4</td>
											<td width="57%" align="left">¿De qué manera el/la docente respondió las consultas que realizamos en clases?</td>
											<td width="10%" align="center"  bgcolor="#fcfa95">
											<% preg4_profesor = conectar.consultaUno("select cast(avg(parte_2_4) as decimal(4,3)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_4,0) <> 0")
												   response.Write(preg4_profesor)%></td>
											<td width="10%" align="center" bgcolor="#e9e8d2">
												<% preg4_carrera = conectar.consultaUno("select cast(avg(parte_2_4) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_4,0) <> 0")
												   response.Write(preg4_carrera)%></td>
											<td width="10%" align="center" bgcolor="#e5e6ff">
											    <% preg4_facultad = conectar.consultaUno("select cast(avg(parte_2_4) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_4,0) <> 0")
												   response.Write(preg4_facultad)%></td>
											<td width="10%" align="center" bgcolor="#6f79ff">
											    <% preg4_universidad = conectar.consultaUno("select cast(avg(parte_2_4) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_4,0) <> 0")
												   response.Write(preg4_universidad) %></td>
										</tr>
										<tr>
											<td width="3%" align="left">5</td>
											<td width="57%" align="left">¿Con qué frecuencia el/la docente relacionó los contenidos tratados con nuestro futuro desempeño profesional?</td>
											<td width="10%" align="center"  bgcolor="#fcfa95">
											<% preg5_profesor = conectar.consultaUno("select cast(avg(parte_2_5) as decimal(4,3)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_5,0) <> 0")
												   response.Write(preg5_profesor)%>
											</td>
											<td width="10%" align="center" bgcolor="#e9e8d2">
												<% preg5_carrera = conectar.consultaUno("select cast(avg(parte_2_5) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_5,0) <> 0")
												   response.Write(preg5_carrera)%></td>
											<td width="10%" align="center" bgcolor="#e5e6ff">
											    <% preg5_facultad = conectar.consultaUno("select cast(avg(parte_2_5) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_5,0) <> 0")
												   response.Write(preg5_facultad)%></td>
											<td width="10%" align="center" bgcolor="#6f79ff">
											    <% preg5_universidad = conectar.consultaUno("select cast(avg(parte_2_5) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_5,0) <> 0")
												   response.Write(preg5_universidad) %></td>
										</tr>
										<tr>
											<td width="3%" align="left">6</td>
											<td width="57%" align="left">La forma de organizar los contenidos del curso por el/la docente ¿fue favorable a mi aprendizaje?</td>
											<td width="10%" align="center"  bgcolor="#fcfa95">
											<% preg6_profesor = conectar.consultaUno("select cast(avg(parte_2_6) as decimal(4,3)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_6,0) <> 0")
												   response.Write(preg6_profesor)%>
											</td>
											<td width="10%" align="center" bgcolor="#e9e8d2">
												<% preg6_carrera = conectar.consultaUno("select cast(avg(parte_2_6) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_6,0) <> 0")
												   response.Write(preg6_carrera)%></td>
											<td width="10%" align="center" bgcolor="#e5e6ff">
											    <% preg6_facultad = conectar.consultaUno("select cast(avg(parte_2_6) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_6,0) <> 0")
												   response.Write(preg6_facultad)%></td>
											<td width="10%" align="center" bgcolor="#6f79ff">
											    <% preg6_universidad = conectar.consultaUno("select cast(avg(parte_2_6) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_6,0) <> 0")
												   response.Write(preg6_universidad) %></td>
										</tr>
										<tr>
											<td width="3%" align="left">7</td>
											<td width="57%" align="left">Las actividades desarrolladas por el/la docente ¿fueron coherentes con los objetivos de aprendizaje de la asignatura?</td>
											<td width="10%" align="center"  bgcolor="#fcfa95">
											<% preg7_profesor = conectar.consultaUno("select cast(avg(parte_2_7) as decimal(4,3)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_7,0) <> 0")
												   response.Write(preg7_profesor)%>
											</td>
											<td width="10%" align="center" bgcolor="#e9e8d2">
												<% preg7_carrera = conectar.consultaUno("select cast(avg(parte_2_7) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_7,0) <> 0")
												   response.Write(preg7_carrera)%></td>
											<td width="10%" align="center" bgcolor="#e5e6ff">
											    <% preg7_facultad = conectar.consultaUno("select cast(avg(parte_2_7) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_7,0) <> 0")
												   response.Write(preg7_facultad)%></td>
											<td width="10%" align="center" bgcolor="#6f79ff">
											    <% preg7_universidad = conectar.consultaUno("select cast(avg(parte_2_7) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_7,0) <> 0")
												   response.Write(preg7_universidad) %></td>
										</tr>
										<tr>
											<td width="3%" align="left">8</td>
											<td width="57%" align="left">Las actividades desarrolladas ¿facilitan la innovación y creatividad en el hacer disciplinario?</td>
											<td width="10%" align="center"  bgcolor="#fcfa95">
											<% preg8_profesor = conectar.consultaUno("select cast(avg(parte_2_8) as decimal(4,3)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_8,0) <> 0")
												   response.Write(preg8_profesor)%>
											</td>
											<td width="10%" align="center" bgcolor="#e9e8d2">
												<% preg8_carrera = conectar.consultaUno("select cast(avg(parte_2_8) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_8,0) <> 0")
												   response.Write(preg8_carrera)%></td>
											<td width="10%" align="center" bgcolor="#e5e6ff">
											    <% preg8_facultad = conectar.consultaUno("select cast(avg(parte_2_8) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_8,0) <> 0")
												   response.Write(preg8_facultad)%></td>
											<td width="10%" align="center" bgcolor="#6f79ff">
											    <% preg8_universidad = conectar.consultaUno("select cast(avg(parte_2_8) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_8,0) <> 0")
												   response.Write(preg8_universidad) %></td>
										</tr>
										<tr>
											<td width="3%" align="left">9</td>
											<td width="57%" align="left">Me parece que las expectativas del/la docente sobre nuestros aprendizajes son.</td>
											<td width="10%" align="center"  bgcolor="#fcfa95">
											<% preg9_profesor = conectar.consultaUno("select cast(avg(parte_2_9) as decimal(4,3)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_9,0) <> 0")
												   response.Write(preg9_profesor)%>
											</td>
											<td width="10%" align="center" bgcolor="#e9e8d2">
												<% preg9_carrera = conectar.consultaUno("select cast(avg(parte_2_9) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_9,0) <> 0")
												   response.Write(preg9_carrera)%></td>
											<td width="10%" align="center" bgcolor="#e5e6ff">
											    <% preg9_facultad = conectar.consultaUno("select cast(avg(parte_2_9) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_9,0) <> 0")
												   response.Write(preg9_facultad)%></td>
											<td width="10%" align="center" bgcolor="#6f79ff">
											    <% preg9_universidad = conectar.consultaUno("select cast(avg(parte_2_9) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_9,0) <> 0")
												   response.Write(preg9_universidad) %></td>
										</tr>
										
										
										<tr>
											<td colspan="6" bgcolor="#990000" align="center"><font color="#FFFFFF"><strong>DIMENSIÓN 2: Evaluación para el aprendizaje</strong></font></td>
										</tr>
										<tr>
											<td width="3%" align="left"><strong>N°</strong></td>
											<td width="57%" align="left"><strong>PREGUNTA</strong></td>
											<td width="10%" align="left" bgcolor="#fcfa95"><strong>Profesor</strong></td>
											<td width="10%" align="left" bgcolor="#e9e8d2"><strong>Carrera</strong></td>
											<td width="10%" align="left" bgcolor="#e5e6ff"><strong>Facultad</strong></td>
											<td width="10%" align="left" bgcolor="#6f79ff"><strong>Universidad</strong></td>
										</tr>
										<tr>
											<td width="3%" align="left">1</td>
											<td width="57%" align="left">El/la docente ¿comunicó claramente los criterios de evaluación y calificación con los que seremos evaluados?</td>
											<td width="10%" align="center"  bgcolor="#fcfa95">
												<% preg1_profesor = conectar.consultaUno("select cast(avg(parte_3_1) as decimal(4,3)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_3_1,0) <> 0")
												   response.Write(preg1_profesor)%>
											</td>
											<td width="10%" align="center" bgcolor="#e9e8d2">
												<% preg1_carrera = conectar.consultaUno("select cast(avg(parte_3_1) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_3_1,0) <> 0")
												   response.Write(preg1_carrera)%></td>
											<td width="10%" align="center" bgcolor="#e5e6ff">
											    <% preg1_facultad = conectar.consultaUno("select cast(avg(parte_3_1) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_3_1,0) <> 0")
												   response.Write(preg1_facultad)%></td>
											<td width="10%" align="center" bgcolor="#6f79ff">
											    <% preg1_universidad = conectar.consultaUno("select cast(avg(parte_3_1) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_3_1,0) <> 0")
												   response.Write(preg1_universidad) %></td>
										</tr>
										<tr>
											<td width="3%" align="left">2</td>
											<td width="57%" align="left">Los procedimientos de evaluación utilizados por el/la docente ¿fueron coherentes con los contenidos tratados 
																		   y las actividades  desarrolladas durante el curso? </td>
											<td width="10%" align="center"  bgcolor="#fcfa95">
											    <% preg2_profesor = conectar.consultaUno("select cast(avg(parte_3_2) as decimal(4,3)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_3_2,0) <> 0")
												   response.Write(preg2_profesor)%></td>
											<td width="10%" align="center" bgcolor="#e9e8d2">
												<% preg2_carrera = conectar.consultaUno("select cast(avg(parte_3_2) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_3_2,0) <> 0")
												   response.Write(preg2_carrera)%></td>
											<td width="10%" align="center" bgcolor="#e5e6ff">
											    <% preg2_facultad = conectar.consultaUno("select cast(avg(parte_3_2) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_3_2,0) <> 0")
												   response.Write(preg2_facultad)%></td>
											<td width="10%" align="center" bgcolor="#6f79ff">
											    <% preg2_universidad = conectar.consultaUno("select cast(avg(parte_3_2) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_3_2,0) <> 0")
												   response.Write(preg2_universidad) %></td>
										</tr>
										<tr>
											<td width="3%" align="left">3</td>
											<td width="57%" align="left">Las instrucciones e indicaciones de los instrumentos de evaluación  aplicados por el/la docente ¿han sido claras y precisas para su desarrollo?</td>
											<td width="10%" align="center"  bgcolor="#fcfa95">
											<% preg3_profesor = conectar.consultaUno("select cast(avg(parte_3_3) as decimal(4,3)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_3_3,0) <> 0")
												   response.Write(preg3_profesor)%>
											</td>
											<td width="10%" align="center" bgcolor="#e9e8d2">
												<% preg3_carrera = conectar.consultaUno("select cast(avg(parte_3_3) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_3_3,0) <> 0")
												   response.Write(preg3_carrera)%></td>
											<td width="10%" align="center" bgcolor="#e5e6ff">
											    <% preg3_facultad = conectar.consultaUno("select cast(avg(parte_3_3) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_3_3,0) <> 0")
												   response.Write(preg3_facultad)%></td>
											<td width="10%" align="center" bgcolor="#6f79ff">
											    <% preg3_universidad = conectar.consultaUno("select cast(avg(parte_3_3) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_3_3,0) <> 0")
												   response.Write(preg3_universidad) %></td>
										</tr>
										<tr>
											<td width="3%" align="left">4</td>
											<td width="57%" align="left">El análisis y comentarios de los resultados de las evaluaciones ¿fueron entregados en un tiempo oportuno, me ayudaron a ver mis 
																		   errores y así mejorar mis aprendizajes?</td>
											<td width="10%" align="center"  bgcolor="#fcfa95">
											<% preg4_profesor = conectar.consultaUno("select cast(avg(parte_3_4) as decimal(4,3)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_3_4,0) <> 0")
												   response.Write(preg4_profesor)%></td>
											<td width="10%" align="center" bgcolor="#e9e8d2">
												<% preg4_carrera = conectar.consultaUno("select cast(avg(parte_3_4) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_3_4,0) <> 0")
												   response.Write(preg4_carrera)%></td>
											<td width="10%" align="center" bgcolor="#e5e6ff">
											    <% preg4_facultad = conectar.consultaUno("select cast(avg(parte_3_4) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_3_4,0) <> 0")
												   response.Write(preg4_facultad)%></td>
											<td width="10%" align="center" bgcolor="#6f79ff">
											    <% preg4_universidad = conectar.consultaUno("select cast(avg(parte_3_4) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_3_4,0) <> 0")
												   response.Write(preg4_universidad) %></td>
										</tr>
										
										
										<tr>
											<td colspan="6" bgcolor="#990000" align="center"><font color="#FFFFFF"><strong>DIMENSIÓN 3: Ambiente para el Aprendizaje</strong></font></td>
										</tr>
										<tr>
											<td width="3%" align="left"><strong>N°</strong></td>
											<td width="57%" align="left"><strong>PREGUNTA</strong></td>
											<td width="10%" align="left" bgcolor="#fcfa95"><strong>Profesor</strong></td>
											<td width="10%" align="left" bgcolor="#e9e8d2"><strong>Carrera</strong></td>
											<td width="10%" align="left" bgcolor="#e5e6ff"><strong>Facultad</strong></td>
											<td width="10%" align="left" bgcolor="#6f79ff"><strong>Universidad</strong></td>
										</tr>
										<tr>
											<td width="3%" align="left">1</td>
											<td width="57%" align="left">El/la docente ¿crea un ambiente de confianza que incentiva la participación en el aula?</td>
											<td width="10%" align="center"  bgcolor="#fcfa95">
												<% preg1_profesor = conectar.consultaUno("select cast(avg(parte_4_1) as decimal(4,3)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_4_1,0) <> 0")
												   response.Write(preg1_profesor)%>
											</td>
											<td width="10%" align="center" bgcolor="#e9e8d2">
												<% preg1_carrera = conectar.consultaUno("select cast(avg(parte_4_1) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_4_1,0) <> 0")
												   response.Write(preg1_carrera)%></td>
											<td width="10%" align="center" bgcolor="#e5e6ff">
											    <% preg1_facultad = conectar.consultaUno("select cast(avg(parte_4_1) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_4_1,0) <> 0")
												   response.Write(preg1_facultad)%></td>
											<td width="10%" align="center" bgcolor="#6f79ff">
											    <% preg1_universidad = conectar.consultaUno("select cast(avg(parte_4_1) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_4_1,0) <> 0")
												   response.Write(preg1_universidad) %></td>
										</tr>
										<tr>
											<td width="3%" align="left">2</td>
											<td width="57%" align="left">El/la docente ¿establece una interacción (diálogo) con los estudiantes que facilita mi aprendizaje?</td>
											<td width="10%" align="center"  bgcolor="#fcfa95">
											    <% preg2_profesor = conectar.consultaUno("select cast(avg(parte_4_2) as decimal(4,3)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_4_2,0) <> 0")
												   response.Write(preg2_profesor)%></td>
											<td width="10%" align="center" bgcolor="#e9e8d2">
												<% preg2_carrera = conectar.consultaUno("select cast(avg(parte_4_2) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_4_2,0) <> 0")
												   response.Write(preg2_carrera)%></td>
											<td width="10%" align="center" bgcolor="#e5e6ff">
											    <% preg2_facultad = conectar.consultaUno("select cast(avg(parte_4_2) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_4_2,0) <> 0")
												   response.Write(preg2_facultad)%></td>
											<td width="10%" align="center" bgcolor="#6f79ff">
											    <% preg2_universidad = conectar.consultaUno("select cast(avg(parte_4_2) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_4_2,0) <> 0")
												   response.Write(preg2_universidad) %></td>
										</tr>
										<tr>
											<td width="3%" align="left">3</td>
											<td width="57%" align="left">El/la docente ¿considera y atiende los puntos de vista de los estudiantes, aunque sean distintos a los suyos?</td>
											<td width="10%" align="center"  bgcolor="#fcfa95">
											<% preg3_profesor = conectar.consultaUno("select cast(avg(parte_4_3) as decimal(4,3)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_4_3,0) <> 0")
												   response.Write(preg3_profesor)%>
											</td>
											<td width="10%" align="center" bgcolor="#e9e8d2">
												<% preg3_carrera = conectar.consultaUno("select cast(avg(parte_4_3) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_4_3,0) <> 0")
												   response.Write(preg3_carrera)%></td>
											<td width="10%" align="center" bgcolor="#e5e6ff">
											    <% preg3_facultad = conectar.consultaUno("select cast(avg(parte_4_3) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_4_3,0) <> 0")
												   response.Write(preg3_facultad)%></td>
											<td width="10%" align="center" bgcolor="#6f79ff">
											    <% preg3_universidad = conectar.consultaUno("select cast(avg(parte_4_3) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_4_3,0) <> 0")
												   response.Write(preg3_universidad) %></td>
										</tr>
										<tr>
											<td width="3%" align="left">4</td>
											<td width="57%" align="left">El/la docente ¿estimuló mi interés por aprender más de mi disciplina?</td>
											<td width="10%" align="center"  bgcolor="#fcfa95">
											<% preg4_profesor = conectar.consultaUno("select cast(avg(parte_4_4) as decimal(4,3)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_4_4,0) <> 0")
												   response.Write(preg4_profesor)%></td>
											<td width="10%" align="center" bgcolor="#e9e8d2">
												<% preg4_carrera = conectar.consultaUno("select cast(avg(parte_4_4) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_4_4,0) <> 0")
												   response.Write(preg4_carrera)%></td>
											<td width="10%" align="center" bgcolor="#e5e6ff">
											    <% preg4_facultad = conectar.consultaUno("select cast(avg(parte_4_4) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_4_4,0) <> 0")
												   response.Write(preg4_facultad)%></td>
											<td width="10%" align="center" bgcolor="#6f79ff">
											    <% preg4_universidad = conectar.consultaUno("select cast(avg(parte_4_4) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_4_4,0) <> 0")
												   response.Write(preg4_universidad) %></td>
										</tr>
										
										
										
										<tr>
											<td colspan="6" bgcolor="#990000" align="center"><font color="#FFFFFF"><strong>DIMENSIÓN 4: Responsabilidad Formal</strong></font></td>
										</tr>
										<tr>
											<td width="3%" align="left"><strong>N°</strong></td>
											<td width="57%" align="left"><strong>PREGUNTA</strong></td>
											<td width="10%" align="left" bgcolor="#fcfa95"><strong>Profesor</strong></td>
											<td width="10%" align="left" bgcolor="#e9e8d2"><strong>Carrera</strong></td>
											<td width="10%" align="left" bgcolor="#e5e6ff"><strong>Facultad</strong></td>
											<td width="10%" align="left" bgcolor="#6f79ff"><strong>Universidad</strong></td>
										</tr>
										<tr>
											<td width="3%" align="left">1</td>
											<td width="57%" align="left">El/la docente ¿asistió a realizar sus clases?</td>
											<td width="10%" align="center"  bgcolor="#fcfa95">
												<% preg1_profesor = conectar.consultaUno("select cast(avg(parte_5_1) as decimal(4,3)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_5_1,0) <> 0")
												   response.Write(preg1_profesor)%>
											</td>
											<td width="10%" align="center" bgcolor="#e9e8d2">
												<% preg1_carrera = conectar.consultaUno("select cast(avg(parte_5_1) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_5_1,0) <> 0")
												   response.Write(preg1_carrera)%></td>
											<td width="10%" align="center" bgcolor="#e5e6ff">
											    <% preg1_facultad = conectar.consultaUno("select cast(avg(parte_5_1) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_5_1,0) <> 0")
												   response.Write(preg1_facultad)%></td>
											<td width="10%" align="center" bgcolor="#6f79ff">
											    <% preg1_universidad = conectar.consultaUno("select cast(avg(parte_5_1) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_5_1,0) <> 0")
												   response.Write(preg1_universidad) %></td>
										</tr>
										<tr>
											<td width="3%" align="left">2</td>
											<td width="57%" align="left">Si el/la docente no realizó alguna clase ¿se preocupó de que los estudiantes fuéramos comunicados con anterioridad?</td>
											<td width="10%" align="center"  bgcolor="#fcfa95">
											    <% preg2_profesor = conectar.consultaUno("select cast(avg(parte_5_2) as decimal(4,3)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_5_2,0) <> 0")
												   response.Write(preg2_profesor)%></td>
											<td width="10%" align="center" bgcolor="#e9e8d2">
												<% preg2_carrera = conectar.consultaUno("select cast(avg(parte_5_2) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_5_2,0) <> 0")
												   response.Write(preg2_carrera)%></td>
											<td width="10%" align="center" bgcolor="#e5e6ff">
											    <% preg2_facultad = conectar.consultaUno("select cast(avg(parte_5_2) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_5_2,0) <> 0")
												   response.Write(preg2_facultad)%></td>
											<td width="10%" align="center" bgcolor="#6f79ff">
											    <% preg2_universidad = conectar.consultaUno("select cast(avg(parte_5_2) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_5_2,0) <> 0")
												   response.Write(preg2_universidad) %></td>
										</tr>
										<tr>
											<td width="3%" align="left">3</td>
											<td width="57%" align="left">El/la docente ¿fue puntual al comenzar y al finalizar las sesiones de clases?</td>
											<td width="10%" align="center"  bgcolor="#fcfa95">
											<% preg3_profesor = conectar.consultaUno("select cast(avg(parte_5_3) as decimal(4,3)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_5_3,0) <> 0")
												   response.Write(preg3_profesor)%>
											</td>
											<td width="10%" align="center" bgcolor="#e9e8d2">
												<% preg3_carrera = conectar.consultaUno("select cast(avg(parte_5_3) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_5_3,0) <> 0")
												   response.Write(preg3_carrera)%></td>
											<td width="10%" align="center" bgcolor="#e5e6ff">
											    <% preg3_facultad = conectar.consultaUno("select cast(avg(parte_5_3) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_5_3,0) <> 0")
												   response.Write(preg3_facultad)%></td>
											<td width="10%" align="center" bgcolor="#6f79ff">
											    <% preg3_universidad = conectar.consultaUno("select cast(avg(parte_5_3) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_5_3,0) <> 0")
												   response.Write(preg3_universidad) %></td>
										</tr>
										<tr>
											<td width="3%" align="left">4</td>
											<td width="57%" align="left">El/la docente ¿nos comunicó oportunamente fechas importantes como horarios de inicio y término de clases, y salas o 
																		espacios físicos a utilizar?</td>
											<td width="10%" align="center"  bgcolor="#fcfa95">
											<% preg4_profesor = conectar.consultaUno("select cast(avg(parte_5_4) as decimal(4,3)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_5_4,0) <> 0")
												   response.Write(preg4_profesor)%></td>
											<td width="10%" align="center" bgcolor="#e9e8d2">
												<% preg4_carrera = conectar.consultaUno("select cast(avg(parte_5_4) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_5_4,0) <> 0")
												   response.Write(preg4_carrera)%></td>
											<td width="10%" align="center" bgcolor="#e5e6ff">
											    <% preg4_facultad = conectar.consultaUno("select cast(avg(parte_5_4) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_5_4,0) <> 0")
												   response.Write(preg4_facultad)%></td>
											<td width="10%" align="center" bgcolor="#6f79ff">
											    <% preg4_universidad = conectar.consultaUno("select cast(avg(parte_5_4) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_5_4,0) <> 0")
												   response.Write(preg4_universidad) %></td>
										</tr>
										<tr>
											<td width="3%" align="left">5</td>
											<td width="57%" align="left">El/la docente ¿cumple con los plazos acordados para la entrega de trabajos y pruebas?</td>
											<td width="10%" align="center"  bgcolor="#fcfa95">
											<% preg4_profesor = conectar.consultaUno("select cast(avg(parte_5_5) as decimal(4,3)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_5_5,0) <> 0")
												   response.Write(preg4_profesor)%></td>
											<td width="10%" align="center" bgcolor="#e9e8d2">
												<% preg4_carrera = conectar.consultaUno("select cast(avg(parte_5_5) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_5_5,0) <> 0")
												   response.Write(preg4_carrera)%></td>
											<td width="10%" align="center" bgcolor="#e5e6ff">
											    <% preg4_facultad = conectar.consultaUno("select cast(avg(parte_5_5) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_5_5,0) <> 0")
												   response.Write(preg4_facultad)%></td>
											<td width="10%" align="center" bgcolor="#6f79ff">
											    <% preg4_universidad = conectar.consultaUno("select cast(avg(parte_5_5) as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_5_5,0) <> 0")
												   response.Write(preg4_universidad) %></td>
										</tr>
										
									</table>
								</td>
							</tr>
							<tr>
								<td colspan="3">&nbsp;</td>
							</tr>
                            <!--
							<tr>
								<td colspan="3" align="center">
									<table width="70%" border="1" bordercolor="#990000" bgcolor="#990000">
										<tr align="center">
											<td colspan="2" align="center"><font color="#FFFFFF"><strong>Rango Puntaje</strong></font></td>
											<td width="40%" align="center"><font color="#FFFFFF">&nbsp;</font></td>
										</tr>
										<tr>
											<td width="30" align="center"><font color="#FFFFFF">Menor</font></td>
											<td width="30" align="center"><font color="#FFFFFF">Mayor</font></td>
											<td width="40%" align="center"><font color="#FFFFFF">Nivel</font></td>
										</tr>
										<tr>
											<td width="30" align="center" bgcolor="#FFFFFF">0.00</td>
											<td width="30" align="center"  bgcolor="#FFFFFF">3.54</td>
											<td width="40%" align="center"  bgcolor="#FFFFFF">Insuficiente</td>
										</tr>
										<tr>
											<td width="30" align="center" bgcolor="#FFFFFF">3.55</td>
											<td width="30" align="center"  bgcolor="#FFFFFF">5.34</td>
											<td width="40%" align="center"  bgcolor="#FFFFFF">Satisfactorio</td>
										</tr>
										<tr>
											<td width="30" align="center" bgcolor="#FFFFFF">5.35</td>
											<td width="30" align="center"  bgcolor="#FFFFFF">6.00</td>
											<td width="40%" align="center"  bgcolor="#FFFFFF">Bueno</td>
										</tr>
										<% 
										   'nivel_profesor = ""
										   'total_x_profesor = cdbl(total_x_profesor)
										   'if total_x_profesor <= cdbl(3.54) then 
										   '    nivel_profesor = "INSUFICIENTE"
										   'elseif total_x_profesor >= cdbl(5.35)  then
										   '    nivel_profesor = "BUENO"
										   'else
										   '    nivel_profesor = "SATISFACTORIO"
										   'end if
										   'response.Write(nivel_profesor)%>
										<tr>
											<td colspan="3" align="center" bgcolor="#fcfa95">
											   <font size="2" color="#003399">Su puntaje <%=total_x_profesor%> lo posiciona en la categoría <strong><%=nivel_profesor%></strong></font>
											</td>
										</tr>
									</table>
								</td>
							</tr>-->
	                      </table>
					  <hr>
                  </div>
				</td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="101" nowrap bgcolor="#D8D8DE"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="50%"><% botonera.dibujaBoton "Volver" %></td>
					  <td width="50%"><%  if cantidad_encuestas > "0" and secc_ccod <> "" then
											   botonera.agregaBotonParam "excel","url","observaciones_2008_excel.asp?pers_ncorr="&pers_ncorr&"&secc_ccod="&secc_ccod
											   botonera.dibujaBoton "excel" 
										  end if %></td>
                    </tr>
                  </table></td>
                  <td width="309" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="267" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<BR>
		  </td>
        </tr>
      </table>
	  </form>
   </td>
  </tr>  
</table>
</body>
</html>
