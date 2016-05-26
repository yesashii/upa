<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

set errores = new CErrores
set pagina = new CPagina
 
encu_ncorr = 15
pers_ncorr = request.querystring("pers_ncorr")
secc_ccod = request.querystring("secc_ccod")
pers_ncorr_profesor = pers_ncorr

'response.Write("secc_ccod= "&secc_ccod&" pers_ncorr= "&pers_ncorr_profesor)
'--------------------------------------------------------------------------
set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set botonera = new CFormulario
botonera.Carga_Parametros "m_ver.xml", "botonera2"

peri_ccod = conectar.consultaUno("select peri_ccod from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")
if peri_ccod <= "202" then
	encu_ncorr=15
else
	encu_ncorr=23
end if 

nombre_encuesta = conectar.consultaUno("Select encu_tnombre from encuestas where cast(encu_ncorr as varchar)='"&encu_ncorr&"'")
instruccion = conectar.consultaUno("Select encu_tinstruccion from encuestas where cast(encu_ncorr as varchar)='"&encu_ncorr&"'")
pagina.Titulo = nombre_encuesta 



set escala= new cformulario
escala.carga_parametros "tabla_vacia.xml","tabla"
escala.inicializar conectar
Query_escala = "select  resp_ncorr,resp_tabrev,protic.initcap(resp_tdesc) as resp_tdesc,resp_nnota from respuestas where cast(encu_ncorr as varchar)='"&encu_ncorr&"' order by resp_norden"
escala.consultar Query_escala
cantid = escala.nroFilas
'response.Write(cantid)
set criterios= new cformulario
criterios.carga_parametros "tabla_vacia.xml","tabla"
criterios.inicializar conectar
Query_criterios = "select  crit_ncorr,crit_tdesc from criterios where cast(encu_ncorr as varchar)='"&encu_ncorr&"' order by crit_norden"
criterios.consultar Query_criterios
cantid_criterios = criterios.nroFilas

'------------------buscamos que datos vamos mostrar en el encabezado de la encuesta
carrera=conectar.consultaUno("select protic.initCap(carr_tdesc) from secciones a, carreras b where a.carr_ccod=b.carr_ccod and cast(a.secc_ccod as varchar)='"&secc_ccod&"'")
asignatura=conectar.consultaUno("select ltrim(rtrim(b.asig_ccod))+' ' + protic.initCap(b.asig_tdesc) from secciones a, asignaturas b where a.asig_ccod=b.asig_ccod and cast(a.secc_ccod as varchar)='"&secc_ccod&"'") 
seccion=conectar.consultaUno("select secc_tdesc from secciones a where cast(a.secc_ccod as varchar)='"&secc_ccod&"'")
carr_ccod=conectar.consultaUno("select carr_ccod from secciones a where cast(a.secc_ccod as varchar)='"&secc_ccod&"'")
profesor = conectar.consultaUno("select protic.initCap(pers_tnombre + ' ' + pers_tape_paterno + ' ' +pers_tape_materno) from personas where cast(pers_ncorr as varchar)='"&pers_ncorr_profesor&"'")

'response.Write("select count(distinct pers_ncorr_encuestado,secc_ccod) from resultados_encuestas where cast(pers_ncorr_destino as varchar)='"&pers_ncorr&"'")

if secc_ccod <> "" then
	cantidad_encuestas = conectar.consultaUno("select count(distinct pers_ncorr_encuestado) from evaluacion_docente where cast(pers_ncorr_destino as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"'")
else
	cantidad_encuestas = conectar.consultaUno("select count(*) from (select distinct pers_ncorr_encuestado,secc_ccod from evaluacion_docente where cast(pers_ncorr_destino as varchar)='"&pers_ncorr&"')a")
end if 
'response.Write(cantidad_encuestas)

pers_nrut = conectar.consultaUno("Select pers_nrut from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
pers_xdv = conectar.consultaUno("Select pers_xdv from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")

if secc_ccod <> "" then 
	filtro_seccion = " and cast(c.secc_ccod as varchar)='"&secc_ccod&"'"
end if 

set notas= new cformulario
notas.carga_parametros "tabla_vacia.xml","tabla"
notas.inicializar conectar
Query_notas = " select d.matr_ncorr,d.secc_ccod,ltrim(rtrim(isnull(d.sitf_ccod,'SP'))) as sitf_ccod  "& vbCrLf &_ 
			  " from bloques_profesores a, bloques_horarios b, secciones c,cargas_Academicas d  "& vbCrLf &_
			  " where a.bloq_ccod=b.bloq_ccod   "& vbCrLf &_
			  " and b.secc_ccod = c.secc_ccod  "& vbCrLf &_
			  " and c.secc_ccod = d.secc_ccod  "&filtro_seccion& vbCrLf &_
			  " and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'  "& vbCrLf &_
			  " and a.tpro_ccod = 1  "& vbCrLf &_
			  " and exists (select 1 from resultados_encuestas aa where aa.secc_ccod=c.secc_ccod and aa.pers_ncorr_destino = a.pers_ncorr)"


notas.consultar Query_notas
'response.Write("<pre>"&Query_notas&"</pre>")

cantidad_secciones = conectar.ConsultaUno("select count(distinct secc_ccod) from ("&Query_notas&")a")
'response.Write(cantidad_secciones)
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

sede = conectar.consultaUno("Select sede_ccod from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")
carr= conectar.consultaUno("Select carr_ccod from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")
jorn = conectar.consultaUno("Select jorn_ccod from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")
pers_nrut = conectar.consultaUno("Select pers_nrut from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
pers_xdv = conectar.consultaUno("Select pers_xdv from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")


'---------------------------------------Detalle tabla de gráfico----------------------------------------------
'-------------------------------------Marcelo Sandoval 01-06-2007---------------------------------------------
cantidad_x_profesor = conectar.consultaUno("select count(*) from evaluacion_docente where cast(secc_ccod as varchar)= '"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)= '"&pers_ncorr_profesor&"'")
'metodologicos_x_p = conectar.consultaUno("select sum(metodologicos) from evaluacion_docente where cast(secc_ccod as varchar)= '"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)= '"&pers_ncorr_profesor&"'")
'interaccion_x_p = conectar.consultaUno("select sum(interaccion) from evaluacion_docente where cast(secc_ccod as varchar)= '"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)= '"&pers_ncorr_profesor&"'")
'administrativos_x_p = conectar.consultaUno("select sum(administrativos) from evaluacion_docente where cast(secc_ccod as varchar)= '"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)= '"&pers_ncorr_profesor&"'")

if cantidad_x_profesor <> "0" then
        'metodologicos_x_profesor = clng(clng(metodologicos_x_p) / clng(cantidad_x_profesor))
		'interaccion_x_profesor = clng(clng(interaccion_x_p) / clng(cantidad_x_profesor))
		'administrativos_x_profesor = clng(clng(administrativos_x_p) / clng(cantidad_x_profesor))
		'puntaje_total = conectar.consultaUno("select cast(avg(puntaje_total) as decimal(6,2)) from evaluacion_docente bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_destino as varchar)= '"&pers_ncorr_profesor&"'")
		metodologicos_x_profesor = conectar.consultaUno("select cast(avg(metodologicos) as decimal(6,2)) from evaluacion_docente bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_destino as varchar)= '"&pers_ncorr_profesor&"'")
		interaccion_x_profesor = conectar.consultaUno("select cast(avg(interaccion) as decimal(6,2)) from evaluacion_docente bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_destino as varchar)= '"&pers_ncorr_profesor&"'")
		administrativos_x_profesor = conectar.consultaUno("select cast(avg(administrativos) as decimal(6,2)) from evaluacion_docente bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_destino as varchar)= '"&pers_ncorr_profesor&"'")
else
        metodologicos_x_profesor = 0
		interaccion_x_profesor = 0
		administrativos_x_profesor = 0
end if
total_x_profesor = clng(metodologicos_x_profesor) + clng(interaccion_x_profesor)+clng(administrativos_x_profesor)
'response.write(total_x_profesor)

carr_ccod = conectar.consultaUno("select carr_ccod from secciones where cast(secc_ccod as varchar)= '"&secc_ccod&"'")
peri_ccod = conectar.consultaUno("select peri_ccod from secciones where cast(secc_ccod as varchar)= '"&secc_ccod&"'")

cantidad_x_carrera = conectar.consultaUno("select count(*) from secciones a, evaluacion_docente b where cast(a.carr_ccod as varchar)= '"&carr_ccod&"' and  cast(a.peri_ccod as varchar)= '"&peri_ccod&"' and a.secc_ccod=b.secc_ccod")

if cantidad_x_carrera <> "0" then
        'metodologicos_x_carrera = clng(clng(metodologicos_x_c) / clng(cantidad_x_carrera))
		'interaccion_x_carrera = clng(clng(interaccion_x_c) / clng(cantidad_x_carrera))
		'administrativos_x_carrera = clng(clng(administrativos_x_c) / clng(cantidad_x_carrera))
		metodologicos_x_carrera = conectar.consultaUno("select cast(avg(metodologicos) as decimal(6,2)) from secciones a, evaluacion_docente b where cast(a.carr_ccod as varchar)= '"&carr_ccod&"' and  cast(a.peri_ccod as varchar)= '"&peri_ccod&"' and a.secc_ccod=b.secc_ccod")
		interaccion_x_carrera = conectar.consultaUno("select cast(avg(interaccion) as decimal(6,2)) from secciones a, evaluacion_docente b where cast(a.carr_ccod as varchar)= '"&carr_ccod&"' and  cast(a.peri_ccod as varchar)= '"&peri_ccod&"' and a.secc_ccod=b.secc_ccod")
		administrativos_x_carrera = conectar.consultaUno("select cast(avg(administrativos) as decimal(6,2)) from secciones a, evaluacion_docente b where cast(a.carr_ccod as varchar)= '"&carr_ccod&"' and  cast(a.peri_ccod as varchar)= '"&peri_ccod&"' and a.secc_ccod=b.secc_ccod")

else
        metodologicos_x_carrera = 0
		interaccion_x_carrera = 0
		administrativos_x_carrera = 0
end if
total_x_carrera = clng(metodologicos_x_carrera) + clng(interaccion_x_carrera)+clng(administrativos_x_carrera)

'response.Write("<hr>"&carr_ccod)

facu_ccod = conectar.consultaUno("select b.facu_ccod from carreras a, areas_academicas b where a.area_ccod=b.area_ccod and a.carr_ccod='"&carr_ccod&"'")
cantidad_x_facultad = conectar.consultaUno("select count(*) from secciones a,evaluacion_docente b where carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(a.peri_ccod as varchar)='"&peri_ccod&"' and a.secc_ccod=b.secc_ccod")

if cantidad_x_facultad <> "0" then
        'metodologicos_x_facultad = clng(clng(metodologicos_x_f) / clng(cantidad_x_facultad))
		'interaccion_x_facultad = clng(clng(interaccion_x_f) / clng(cantidad_x_facultad))
		'administrativos_x_facultad = clng(clng(administrativos_x_f) / clng(cantidad_x_facultad))
		metodologicos_x_facultad = conectar.consultaUno("select cast(avg(metodologicos) as decimal(6,2)) from secciones a,evaluacion_docente b where carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(a.peri_ccod as varchar)='"&peri_ccod&"' and a.secc_ccod=b.secc_ccod")
		interaccion_x_facultad = conectar.consultaUno("select cast(avg(interaccion) as decimal(6,2)) from secciones a,evaluacion_docente b where carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(a.peri_ccod as varchar)='"&peri_ccod&"' and a.secc_ccod=b.secc_ccod")
		administrativos_x_facultad = conectar.consultaUno("select cast(avg(administrativos) as decimal(6,2)) from secciones a,evaluacion_docente b where carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(a.peri_ccod as varchar)='"&peri_ccod&"' and a.secc_ccod=b.secc_ccod")
else
        metodologicos_x_facultad = 0
		interaccion_x_facultad = 0
		administrativos_x_facultad = 0
end if
total_x_facultad = clng(metodologicos_x_facultad) + clng(interaccion_x_facultad)+clng(administrativos_x_facultad)
cantidad_x_universidad = conectar.consultaUno("select count(*) from evaluacion_docente where cast(peri_ccod as varchar)='"&peri_ccod&"'")

if cantidad_x_universidad <> "0" then
        'metodologicos_x_universidad = clng(clng(metodologicos_x_u) / clng(cantidad_x_universidad))
		'interaccion_x_universidad = clng(clng(interaccion_x_u) / clng(cantidad_x_universidad))
		'administrativos_x_universidad = clng(clng(administrativos_x_u) / clng(cantidad_x_universidad))
		metodologicos_x_universidad = conectar.consultaUno("select cast(avg(metodologicos) as decimal(6,2)) from evaluacion_docente where cast(peri_ccod as varchar)='"&peri_ccod&"'")
		interaccion_x_universidad = conectar.consultaUno("select cast(avg(interaccion) as decimal(6,2)) from evaluacion_docente where cast(peri_ccod as varchar)='"&peri_ccod&"'")
		administrativos_x_universidad = conectar.consultaUno("select cast(avg(administrativos) as decimal(6,2)) from evaluacion_docente where cast(peri_ccod as varchar)='"&peri_ccod&"'")

else
        metodologicos_x_universidad = 0
		interaccion_x_universidad = 0
		administrativos_x_universidad = 0
end if
total_x_universidad = clng(metodologicos_x_universidad) + clng(interaccion_x_universidad)+clng(administrativos_x_universidad)


docente = conectar.consultaUno("Select pers_tnombre + ' ' + pers_tape_paterno from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
carrera = conectar.consultaUno("Select carr_tdesc from carreras where carr_ccod ='"&carr_ccod&"'")
facultad = conectar.consultaUno("Select facu_tdesc from facultades where facu_ccod ='"&facu_ccod&"'")


usuario = negocio.obtenerUsuario
pers_ncorr_temporal = conectar.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")
'response.Write("profesor "&pers_ncorr_profesor&" temporal "&pers_ncorr_temporal)
if clng(pers_ncorr_profesor) = clng(pers_ncorr_temporal) then
	ocultar="S"
else
	ocultar="N"	
end if
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
   //alert("Entre a la función :)");
   location.href ="resultados_encuestas.asp?busqueda[0][pers_nrut]="+<%=pers_nrut%>+"&busqueda[0][pers_xdv]="+'<%=pers_xdv%>';
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
	<%if encu_ncorr <> "" then%>
	<form name="edicion">
		<% 'response.Write("Select Count(*) from resultados_encuestas where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"'")
		  if secc_ccod <> "" then
		  	contestada = conectar.consultaUno("Select Count(distinct pers_ncorr_encuestado) from evaluacion_docente where cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"'")
		  else
		  	contestada = conectar.consultaUno("select count(*) from (Select distinct pers_ncorr_encuestado,secc_ccod from evaluacion_docente where cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"')aa")
		  end if 
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
						<tr>
							   <td colspan="3" align="center">
									<table width="90%" border="1" bordercolor="#990000" bgcolor="#FFFFFF">
										<tr>
										    
											<td colspan="2" align="left"><strong>&nbsp;</strong></td>
										    <td width="15%" align="left"><strong>ADMINISTRATIVO</strong></td>
											<td width="15%" align="left"><strong>INTERACCION</strong></td>
											<td width="15%" align="left"><strong>METODOLOGIA</strong></td>
											<td width="15%" align="left"><strong>PUNTAJE TOTAL</strong></td>
										</tr>
										<tr>
										    <td width="5%" bgcolor="#fcfa95">&nbsp;</td>
											<td width="35%" align="left"><strong><%="PROMEDIO PROFESOR "&docente%></strong></td>
										    <td width="15%" align="center"><%=administrativos_x_profesor%></td>
											<td width="15%" align="center"><%=interaccion_x_profesor%></td>
											<td width="15%" align="center"><%=metodologicos_x_profesor%></td>
											<td width="15%" align="center"><%=total_x_profesor%></td>
										</tr>
										<tr>
										    <td width="5%" bgcolor="#900000">&nbsp;</td>
											<td width="35%" align="left"><strong><%="PROMEDIO CARRERA "&carrera%></strong></td>
										    <td width="15%" align="center"><%=administrativos_x_carrera%></td>
											<td width="15%" align="center"><%=interaccion_x_carrera%></td>
											<td width="15%" align="center"><%=metodologicos_x_carrera%></td>
											<td width="15%" align="center"><%=total_x_carrera%></td>
										</tr>
										<tr>
										    <td width="5%" bgcolor="#e5e6ff">&nbsp;</td>
											<td width="35%" align="left"><strong><%="PROMEDIO "&facultad%></strong></td>
										    <td width="15%" align="center"><%=administrativos_x_facultad%></td>
											<td width="15%" align="center"><%=interaccion_x_facultad%></td>
											<td width="15%" align="center"><%=metodologicos_x_facultad%></td>
											<td width="15%" align="center"><%=total_x_facultad%></td>
										</tr>
										<tr>
										    <td width="5%" bgcolor="#6f79ff">&nbsp;</td>
											<td width="35%" align="left"><strong><%="PROMEDIO UNIVERSIDAD DEL PACIFICO"%></strong></td>
										    <td width="15%" align="center"><%=administrativos_x_universidad%></td>
											<td width="15%" align="center"><%=interaccion_x_universidad%></td>
											<td width="15%" align="center"><%=metodologicos_x_universidad%></td>
											<td width="15%" align="center"><%=total_x_universidad%></td>
										</tr>
									</table>
							   </td>
							</tr>
							<tr>
								<td colspan="3" align="center"><img border="0" src="grafico_barras.asp?pers_ncorr=<%=pers_ncorr%>&secc_ccod=<%=secc_ccod%>" ></td>
							</tr>
							
						
                      </table>
					  <hr>
					  
					  <table width="100%"  border="1" align="center" bordercolor="#990000" bgcolor="#FFFFFF">
                       <%if cantid_criterios >"0" then
					        contador=1
							acumulado_total = 0
							criterios.Primero
						  	while criterios.siguiente
									ncorr = criterios.obtenervalor("crit_ncorr")
									'response.Write("ncorr= "&ncorr&" ")
									titulo= criterios.obtenervalor("crit_tdesc")		
							wend				
						%>  
						<tr> 
                          	<td width="5%"><font color="#CC0000"><strong>N°</strong></font></td>
							<td width="75%"><font color="#CC0000"><strong>OPINIÓN</strong></font></td>
						  	<td width="5%"><font color="#CC0000"><strong>Prof.</strong></font></td>	
							<td width="5%"><font color="#CC0000"><strong>Esc.</strong></font></td>	
							<td width="5%"><font color="#CC0000"><strong>Fac.</strong></font></td>	
							<td width="5%"><font color="#CC0000"><strong>Univ.</strong></font></td>	
						 </tr>
							<%
							set preguntas2= new cformulario
							preguntas2.carga_parametros "tabla_vacia.xml","tabla"
							preguntas2.inicializar conectar
							Query_preguntas = "select  preg_ncorr,preg_ccod,protic.initCap(preg_tdesc) as preg_tdesc,preg_norden from preguntas where cast(crit_ncorr as varchar)='"&ncorr&"' order by preg_norden"
							preguntas2.consultar Query_preguntas
							cantid_preguntas = preguntas2.nroFilas
							'response.Write("ncorr= "&ncorr&" cantidad_preguntas "&cantid_preguntas)
								if cantid_preguntas >"0" then
						  			while preguntas2.siguiente
									    'response.Write("sql= "&Query_preguntas)
										orden = preguntas2.obtenervalor("preg_norden")
										pregunta= preguntas2.obtenervalor("preg_tdesc")						
										ccod=preguntas2.obtenervalor("preg_ccod")						
										preg_ncorr=preguntas2.obtenervalor("preg_ncorr")		
										c_promedio_profesor = " select cast(avg(cast(resp_nnota as numeric)) as numeric) "&_
															  "	from evaluacion_docente a, respuestas b "&_
															  "	where cast(secc_ccod as varchar)= '"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)= '"&pers_ncorr_profesor&"' "&_
															  "	and b.resp_ncorr = preg_"&contador	
									    promedio_profesor =conectar.consultaUno(c_promedio_profesor)			
										
										c_promedio_carrera = " select cast(avg(cast(resp_nnota as numeric)) as numeric) "&_
															  "	from secciones c,evaluacion_docente a, respuestas b"&_
															  "	where cast(c.peri_ccod as varchar)= '"&peri_ccod&"' and c.carr_ccod='"&carr_ccod &"' and c.secc_ccod=a.secc_ccod and cast(pers_ncorr_destino as varchar)= '"&pers_ncorr_profesor&"' "&_
															  "	and b.resp_ncorr = preg_"&contador	
									    promedio_carrera =conectar.consultaUno(c_promedio_carrera)		
										
										c_promedio_facultad = " select cast(avg(cast(resp_nnota as numeric)) as numeric) "&_
															  "	from secciones c,evaluacion_docente a, respuestas b "&_
															  "	where cast(c.peri_ccod as varchar)= '"&peri_ccod&"' and c.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') "&_
															  " and c.secc_ccod=a.secc_ccod and cast(pers_ncorr_destino as varchar)= '"&pers_ncorr_profesor&"' "&_
															  "	and b.resp_ncorr = preg_"&contador	
									    promedio_facultad =conectar.consultaUno(c_promedio_facultad)
										
										c_promedio_universidad = " select cast(avg(cast(resp_nnota as numeric)) as numeric) "&_
															  "	from secciones c,evaluacion_docente a, respuestas b "&_
															  "	where cast(c.peri_ccod as varchar)= '"&peri_ccod&"' and c.secc_ccod=a.secc_ccod and cast(pers_ncorr_destino as varchar)= '"&pers_ncorr_profesor&"' "&_
															  "	and b.resp_ncorr = preg_"&contador	
									    promedio_universidad =conectar.consultaUno(c_promedio_universidad)		
										
										%>  
										<tr> 
											<td width="5%" align="right"><strong><%=contador%> :</strong></td>
											<td width="75%"><%=pregunta%></td>
											<td width="5%" align="center"><%=promedio_profesor%></td>
											<td width="5%" align="center"><%=promedio_carrera%></td>
											<td width="5%" align="center"><%=promedio_facultad%></td>
											<td width="5%" align="center"><%=promedio_universidad%></td>
						               </tr>
    							<% contador=contador + 1
								  wend 
							end if
					 end if
							%>
							<tr>
							    <td colspan="13">&nbsp;</td>
							</tr>
							
							</table>

                      <table width="100%"  border="0" align="center">
						  <%if ocultar = "N" then %>
							  <tr><td colspan="3"><hr></td></tr>
								<%if cantid > "0" then
								 escala.primero
								  while escala.siguiente
										abrev = escala.obtenervalor("resp_tabrev")
										texto= escala.obtenervalor("resp_tdesc")
										puntos= escala.obtenervalor("resp_nnota")						
								%> 
								<tr>  
								   <td width="3%"><div align="left"><strong><%=abrev%></strong></div></td>
								   <td width="3%"><strong><center>:</center></strong></td>
								   <td width="94%"><div align="left"><strong><%=texto%></strong></div></td>
								</tr>
								<%
								wend
								end if
							End if
						%>
						
                       <%if ocultar = "N" then 
					      if cantid_criterios >"0" then
					        contador=1
							acumulado_total = 0
							criterios.Primero
						  	while criterios.siguiente
									ncorr = criterios.obtenervalor("crit_ncorr")
									'response.Write("ncorr= "&ncorr&" ")
									titulo= criterios.obtenervalor("crit_tdesc")						
							%>  
							<tr> 
                          		<td colspan="3"><font color="#CC0000"><strong><%=titulo%></strong></font></td>
						  		
						  		<%if cantid >"0" then
						  			escala.Primero
						  			while escala.siguiente
										abrev = escala.obtenervalor("resp_tabrev")%>
										<td width="20"><strong><center><font color="#CC0000">
						  				<%response.Write(abrev)		
										%></font></center></strong>
										</td>
										<td width="20"><strong><center><font color="#CC0000">
						  				<%response.Write("P")		
										%></font></center></strong>
										</td>
									<%wend%>
							    <%end if%>
							<td width="2">&nbsp;</td>	
							</tr>
							<%
							set preguntas= new cformulario
							preguntas.carga_parametros "tabla_vacia.xml","tabla"
							preguntas.inicializar conectar
							Query_preguntas = "select  preg_ncorr,preg_ccod,protic.initCap(preg_tdesc) as preg_tdesc,preg_norden from preguntas where cast(crit_ncorr as varchar)='"&ncorr&"' order by preg_norden"
							preguntas.consultar Query_preguntas
							cantid_preguntas = preguntas.nroFilas
							'response.Write("ncorr= "&ncorr&" cantidad_preguntas "&cantid_preguntas)
								if cantid_preguntas >"0" then
						  			while preguntas.siguiente
									    'response.Write("sql= "&Query_preguntas)
										orden = preguntas.obtenervalor("preg_norden")
										pregunta= preguntas.obtenervalor("preg_tdesc")						
										ccod=preguntas.obtenervalor("preg_ccod")						
										preg_ncorr=preguntas.obtenervalor("preg_ncorr")						
										%>  
										<tr> 
                          				<td width="18" align="right"><strong><%=contador%></strong></td>
										<td width="17"><%=".-"%></td>
										<td width="591"><%=pregunta%></td>
						  
						  				<%if cantid >"0" then
						  					escala.Primero
											acumulado = 0
											
						  					while escala.siguiente%>
											 <td width="20"><center>
											   <%if contestada <> 0 then
														if secc_ccod <> "" then 
															respuesta = conectar.consultaUno("Select count(distinct pers_ncorr_encuestado) from evaluacion_docente where cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"' and cast(preg_"&contador&" as varchar)='"&escala.obtenervalor("resp_ncorr")&"'")  
														else
															respuesta = conectar.consultaUno("select count(*) from (Select distinct pers_ncorr_encuestado, secc_ccod from evaluacion_docente where cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"' and cast(preg_"&contador&" as varchar)='"&escala.obtenervalor("resp_ncorr")&"')aa")  
														end if%>
														
														<%if respuesta > "0" then 
														  	response.Write("<strong>"&respuesta&"</strong>")
															puntaje = escala.obtenervalor("resp_nnota")
															acumulado = (cint(puntaje) * cint(respuesta))
														  else
														  	response.Write(respuesta)
														  end if%>
														
												  <%end if
												   %>
											   </center></td>
											   <td width="20"><strong><center><font color="#CC0000">
													<% 'acumulado = formatNumber(cdbl((cint(respuesta) * 100) / cint(cantidad_encuestas)),1)
													   if acumulado > 0 then 
													   		response.Write(acumulado)
													   else
													   		response.Write(0)
													   end if		
													   acumulado = 0
													%></font></center></strong>
												</td>
											<%wend%>
									    <%end if%>
										<td width="2">&nbsp;</td>	
										</tr>
									<%contador=contador+1 
									  acumulado_total = acumulado_total + acumulado
									wend
								end if
								Query_preguntas=""%>
								

							<%wend 
							end if
							
							end if 'fin del if para ocultar..........
							%>
							<tr>
							    <td colspan="13">&nbsp;</td>
							</tr>
							<tr>
							    <td colspan="13"><hr></td>
							</tr>
							<tr>
							    <td colspan="13">&nbsp;</td>
							</tr>
							<tr>
							    <td colspan="13" align="left"><%pagina.dibujarSubTitulo "Dimensión Aspectos metodológicos"%></td>
							</tr>
				            <tr> 
                          		<td colspan="3"><font color="#CC0000"><strong><%=titulo%></strong></font></td>
						  		
						  		<%
								   total1=0
								   total2=0
								   total3=0
								   total4=0
								   total5=0
								   total_dimension_1=0
								   if cantid >"0" then
						  			escala.Primero
						  			while escala.siguiente
										abrev = escala.obtenervalor("resp_tabrev")%>
										<td width="20"><strong><center><font color="#CC0000">
						  				<%response.Write(abrev)		
										%></font></center></strong>
										</td>
										<td width="20"><strong><center><font color="#CC0000">
						  				<%response.Write("P")		
										%></font></center></strong>
										</td>
									<%wend%>
							<%end if%>
							<td width="2">&nbsp;</td>	
							</tr>
							<%if cantid_criterios >"0" then
					        contador=1
							acumulado_total = 0
							criterios.primero
						  	while criterios.siguiente
									ncorr = criterios.obtenervalor("crit_ncorr")
									'response.Write("ncorr= "&ncorr&" ")
									titulo= criterios.obtenervalor("crit_tdesc")	
									
							set preguntas= new cformulario
							preguntas.carga_parametros "tabla_vacia.xml","tabla"
							preguntas.inicializar conectar
							Query_preguntas = "select  preg_ncorr,ltrim(rtrim(preg_ccod)) as preg_ccod,protic.initCap(preg_tdesc) as preg_tdesc,preg_norden from preguntas where cast(crit_ncorr as varchar)='"&ncorr&"' order by preg_norden"
							preguntas.consultar Query_preguntas
							cantid_preguntas = preguntas.nroFilas
							'response.Write("ncorr= "&ncorr&" cantidad_preguntas "&cantid_preguntas)
								if cantid_preguntas >"0" then
						  			while preguntas.siguiente
									    'response.Write("sql= "&Query_preguntas)
										orden = preguntas.obtenervalor("preg_norden")
										pregunta= preguntas.obtenervalor("preg_tdesc")						
										ccod=preguntas.obtenervalor("preg_ccod")						
										preg_ncorr=preguntas.obtenervalor("preg_ncorr")						
										if (orden ="1" or orden ="2" or orden ="3" or orden ="4"  or orden ="5" or orden ="8" or orden ="9" or orden ="12" or orden ="13" or orden ="14" or orden ="15" or orden ="16" or orden ="17" or orden ="20" or orden ="21" or orden ="24" or orden ="27" or orden ="28" or orden ="29" or orden ="30") then%>  
										<tr> 
                          				<td width="18" align="right"><strong><%=orden%></strong></td>
										<td width="17"><%=".-"%></td>
										<td width="591"><%=pregunta%></td>
						  
						  				<%if cantid >"0" then
						  					escala.Primero
											acumulado = 0
											
						  					while escala.siguiente%>
											 <td width="20"><center>
											   <%if contestada <> 0 then
												    if secc_ccod <> "" then 
												        respuesta = conectar.consultaUno("Select count(distinct pers_ncorr_encuestado) from evaluacion_docente where cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"' and cast(preg_"&orden&" as varchar)='"&escala.obtenervalor("resp_ncorr")&"'")  
													else
														respuesta = conectar.consultaUno("select count(*) from (Select distinct pers_ncorr_encuestado, secc_ccod from evaluacion_docente where cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"' and cast(preg_"&orden&" as varchar)='"&escala.obtenervalor("resp_ncorr")&"')aa")  
													end if%>
													
													<%if respuesta > "0" then 
														  	response.Write("<strong>"&respuesta&"</strong>")
															puntaje = escala.obtenervalor("resp_nnota")
															acumulado = (cint(puntaje) * cint(respuesta))
														  else
														  	response.Write(respuesta)
														  end if%>
														
												  <%end if
												  %>
											   </center></td>
											   <td width="20"><strong><center><font color="#CC0000">
													<% 'acumulado = formatNumber(cdbl((cint(respuesta) * 100) / cint(cantidad_encuestas)),1)
													   if acumulado > 0 then 
													   		response.Write(acumulado)
													   else
													   		response.Write(0)
													   end if	
													   total_dimension_1= total_dimension_1 + acumulado	
													   acumulado = 0
													%></font></center></strong>
												</td>
											<%wend%>
									    <%end if%>
										<td width="2">&nbsp;</td>	
										</tr>
									<%contador=contador+1 
									  acumulado_total = acumulado_total + acumulado
									  end if
									wend
								
								Query_preguntas=""
								end if
								%>

							<%wend 
							end if
							%>
							<tr> 
							   <td colspan="3" align="right"><strong>Total dimensión 1 :</strong></td>
							   <td align="left" colspan="10"><strong><%  if cdbl(cantidad_encuestas) <= 0 then 
							                                                total_dimension_1 = 0
                                                                         else
																		    total_dimension_1 =  formatnumber(cdbl(total_dimension_1 / cantidad_encuestas),2,-1,0,0)
																		 end if	 
																		 'total_dimencion_1 = formatnumber(cdbl(total_dimension_1),2)
							                                             if encu_ncorr <> 23 then
											                                  response.Write(total_dimension_1)
																		 else
																			  response.Write(metodologicos_x_profesor)
																		 end if  
																	%></strong></td>
							</tr>
							<tr>
							    <td colspan="13">&nbsp;</td>
							</tr>
							<tr>
							    <td colspan="13" align="left"><%pagina.dibujarSubTitulo "Dimensión Interacción con los alumnos"%></td>
							</tr>
				            <tr> 
                          		<td colspan="3"><font color="#CC0000"><strong><%=titulo%></strong></font></td>
						  		
						  		<%
								   total1=0
								   total2=0
								   total3=0
								   total4=0
								   total5=0
								   total_dimension_2 = 0
								   if cantid >"0" then
						  			escala.Primero
						  			while escala.siguiente
										abrev = escala.obtenervalor("resp_tabrev")%>
										<td width="20"><strong><center><font color="#CC0000">
						  				<%response.Write(abrev)		
										%></font></center></strong>
										</td>
										<td width="20"><strong><center><font color="#CC0000">
						  				<%response.Write("P")		
										%></font></center></strong>
										</td>
									<%wend%>
							<%end if%>
							<td width="2">&nbsp;</td>	
							</tr>
							<%if cantid_criterios >"0" then
					        contador=1
							acumulado_total = 0
							criterios.primero
						  	while criterios.siguiente
									ncorr = criterios.obtenervalor("crit_ncorr")
									'response.Write("ncorr= "&ncorr&" ")
									titulo= criterios.obtenervalor("crit_tdesc")	
									
							set preguntas= new cformulario
							preguntas.carga_parametros "tabla_vacia.xml","tabla"
							preguntas.inicializar conectar
							Query_preguntas = "select  preg_ncorr,ltrim(rtrim(preg_ccod)) as preg_ccod,protic.initCap(preg_tdesc) as preg_tdesc,preg_norden from preguntas where cast(crit_ncorr as varchar)='"&ncorr&"' order by preg_norden"
							preguntas.consultar Query_preguntas
							cantid_preguntas = preguntas.nroFilas
							'response.Write("ncorr= "&ncorr&" cantidad_preguntas "&cantid_preguntas)
								if cantid_preguntas >"0" then
						  			while preguntas.siguiente
									    'response.Write("sql= "&Query_preguntas)
										orden = preguntas.obtenervalor("preg_norden")
										pregunta= preguntas.obtenervalor("preg_tdesc")						
										ccod=preguntas.obtenervalor("preg_ccod")						
										preg_ncorr=preguntas.obtenervalor("preg_ncorr")						
										if (orden = "6" or orden = "7" or orden = "10" or orden = "11" or orden = "18" or orden = "19" or orden = "22" or orden = "23") then%>  
										<tr> 
                          				<td width="18" align="right"><strong><%=orden%></strong></td>
										<td width="17"><%=".-"%></td>
										<td width="591"><%=pregunta%></td>
						  
						  				<%if cantid >"0" then
						  					escala.Primero
											acumulado = 0
											
						  					while escala.siguiente%>
											 <td width="20"><center>
											   <%if contestada <> 0 then
												    if secc_ccod <> "" then 
												        respuesta = conectar.consultaUno("Select count(distinct pers_ncorr_encuestado) from evaluacion_docente where cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"' and cast(preg_"&orden&" as varchar)='"&escala.obtenervalor("resp_ncorr")&"'")  
													else
														respuesta = conectar.consultaUno("select count(*) from (Select distinct pers_ncorr_encuestado, secc_ccod from evaluacion_docente where cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"' and cast(preg_"&orden&" as varchar)='"&escala.obtenervalor("resp_ncorr")&"')aa")  
													end if%>
													
													<%if respuesta > "0" then 
														  	response.Write("<strong>"&respuesta&"</strong>")
															puntaje = escala.obtenervalor("resp_nnota")
															acumulado = (cint(puntaje) * cint(respuesta))
														  else
														  	response.Write(respuesta)
														  end if%>
														
												  <%end if
												   
												  %>
											   </center></td>
											   <td width="20"><strong><center><font color="#CC0000">
													<% 'acumulado = formatNumber(cdbl((cint(respuesta) * 100) / cint(cantidad_encuestas)),1)
													   if acumulado > 0 then 
													   		response.Write(acumulado)
													   else
													   		response.Write(0)
													   end if		
													   total_dimension_2 = total_dimension_2 + acumulado
													    acumulado = 0
													%></font></center></strong>
												</td>
											<%wend%>
									    <%end if%>
										<td width="2">&nbsp;</td>	
										</tr>
									<%contador=contador+1 
									  acumulado_total = acumulado_total + acumulado
									  end if
									wend
								
								Query_preguntas=""
								end if
								%>

							<%wend 
							end if
							%>
							<tr> 
							   <td colspan="3" align="right"><strong>Total dimensión 2 :</strong></td>
							   <td align="left" colspan="10"><strong><%if cdbl(cantidad_encuestas) <= 0 then 
							                                                total_dimension_2 = 0
                                                                         else
																		    total_dimension_2 =  formatnumber(cdbl(total_dimension_2 / cantidad_encuestas),2,-1,0,0)
																		 end if	 
							                                             'response.Write(total_dimension_2)
																		 if encu_ncorr <> 23 then
											                                  response.Write(total_dimension_2)
																		 else
																			  response.Write(interaccion_x_profesor)
																		 end if  %></strong></td>
							</tr>
							<tr>
							    <td colspan="13">&nbsp;</td>
							</tr>
							<tr>
							    <td colspan="13" align="left"><%pagina.dibujarSubTitulo "Dimensión Aspectos Administrativos"%></td>
							</tr>
				            <tr> 
                          		<td colspan="3"><font color="#CC0000"><strong><%=titulo%></strong></font></td>
						  		
						  		<%
								   total1=0
								   total2=0
								   total3=0
								   total4=0
								   total5=0
								   total_dimension_3 = 0
								   if cantid >"0" then
						  			escala.Primero
						  			while escala.siguiente
										abrev = escala.obtenervalor("resp_tabrev")%>
										<td width="20"><strong><center><font color="#CC0000">
						  				<%response.Write(abrev)		
										%></font></center></strong>
										</td>
										<td width="20"><strong><center><font color="#CC0000">
						  				<%response.Write("P")		
										%></font></center></strong>
										</td>
									<%wend%>
							<%end if%>
							<td width="2">&nbsp;</td>	
							</tr>
							<%if cantid_criterios >"0" then
					        contador=1
							acumulado_total = 0
							criterios.primero
						  	while criterios.siguiente
									ncorr = criterios.obtenervalor("crit_ncorr")
									'response.Write("ncorr= "&ncorr&" ")
									titulo= criterios.obtenervalor("crit_tdesc")	
									
							set preguntas= new cformulario
							preguntas.carga_parametros "tabla_vacia.xml","tabla"
							preguntas.inicializar conectar
							Query_preguntas = "select  preg_ncorr,ltrim(rtrim(preg_ccod)) as preg_ccod,protic.initCap(preg_tdesc) as preg_tdesc,preg_norden from preguntas where cast(crit_ncorr as varchar)='"&ncorr&"' order by preg_norden"
							preguntas.consultar Query_preguntas
							cantid_preguntas = preguntas.nroFilas
							'response.Write("ncorr= "&ncorr&" cantidad_preguntas "&cantid_preguntas)
								if cantid_preguntas >"0" then
						  			while preguntas.siguiente
									    'response.Write("sql= "&Query_preguntas)
										orden = preguntas.obtenervalor("preg_norden")
										pregunta= preguntas.obtenervalor("preg_tdesc")						
										ccod=preguntas.obtenervalor("preg_ccod")						
										preg_ncorr=preguntas.obtenervalor("preg_ncorr")						
										if (orden = "25" or orden = "26") then%>  
										<tr> 
                          				<td width="18" align="right"><strong><%=orden%></strong></td>
										<td width="17"><%=".-"%></td>
										<td width="591"><%=pregunta%></td>
						  
						  				<%if cantid >"0" then
						  					escala.Primero
											acumulado = 0
											
						  					while escala.siguiente%>
											 <td width="20"><center>
											   <%if contestada <> 0 then
												    if secc_ccod <> "" then 
												        respuesta = conectar.consultaUno("Select count(distinct pers_ncorr_encuestado) from evaluacion_docente where cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"' and cast(preg_"&orden&" as varchar)='"&escala.obtenervalor("resp_ncorr")&"'")  
													else
														respuesta = conectar.consultaUno("select count(*) from (Select distinct pers_ncorr_encuestado, secc_ccod from evaluacion_docente where cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"' and cast(preg_"&orden&" as varchar)='"&escala.obtenervalor("resp_ncorr")&"')aa")  
													end if%>
													
													<%if respuesta > "0" then 
														  	response.Write("<strong>"&respuesta&"</strong>")
															puntaje = escala.obtenervalor("resp_nnota")
															acumulado = (cint(puntaje) * cint(respuesta))
														  else
														  	response.Write(respuesta)
														  end if%>
														
												  <%end if
												   											   
												  %>
											   </center></td>
											   <td width="20"><strong><center><font color="#CC0000">
													<% 'acumulado = formatNumber(cdbl((cint(respuesta) * 100) / cint(cantidad_encuestas)),1)
													   if acumulado > 0 then 
													   		response.Write(acumulado)
													   else
													   		response.Write(0)
													   end if	
													   total_dimension_3 = total_dimension_3 + acumulado	
													    acumulado = 0
													%></font></center></strong>
												</td>
											<%wend%>
									    <%end if%>
										<td width="2">&nbsp;</td>	
										</tr>
									<%contador=contador+1 
									  acumulado_total = acumulado_total + acumulado
									  end if
									wend
								
								Query_preguntas=""
								end if
								%>

							<%wend 
							end if
							%>
							<tr> 
							   <td colspan="3" align="right"><strong>Total Dimensión 3 :</strong></td>
							   <td align="left" colspan="10"><strong><%if cdbl(cantidad_encuestas) <= 0 then 
							                                                total_dimension_3 = 0
                                                                         else
																		    total_dimension_3 =  formatnumber(cdbl(total_dimension_3 / cantidad_encuestas),2,-1,0,0)
																		 end if	 
							                                             if encu_ncorr <> 23 then
											                                  response.Write(total_dimension_3)
																		 else
																			  response.Write(administrativos_x_profesor)
																		 end if  %></strong></td>
							</tr>
							<tr>
							    <td colspan="13"><hr></td>
							</tr>
							<tr>
							   <td colspan="13" align="center"><strong>PONDERACIÓN</strong>
							   </td>
							</tr>   
							<tr>
							   <td colspan="13" align="center">
							   		<table width="70%" border="1" bordercolor="#990000" bgcolor="#FFFFFF">
										<tr>
										    <td width="25%" align="left"><strong>DIMENSIÓN</strong></td>
											<td width="25%" align="left"><strong>ITEMES</strong></td>
											<td width="10%" align="left"><strong>&nbsp;</strong></td>
											<td width="20%" align="left"><strong>Puntaje</strong></td>
											<td width="20%" align="left"><strong>Puntaje Máximo</strong></td>
										</tr>
										<tr>
										    <td width="25%" align="left">Aspectos Metodológicos</td>
											<td width="25%" align="left"><%
											 if encu_ncorr=23 then
											     response.Write("1,2,3,4,5,8,9,12,13,14,15,16,<br>17,20,21,24,28,29,30")
											  else
											  	 response.Write("1,2,3,4,5,8,9,12,13,14,15,16,<br>17,20,21,24,28,29")
											  end if
											 %> </td>
											<!--<td width="10%" align="left"><strong>40</strong></td>-->
											<td width="10%" align="left"><strong>&nbsp;</strong></td>
											<td width="20%" align="left"><%if encu_ncorr <> 23 then
											                                  response.Write(total_dimension_1)
																		   else
																			  response.Write(metodologicos_x_profesor)
																		   end if
																		 %></td>
											<%'total_d_1 = formatnumber(cdbl(total_dimension_1 * 0.40),2,-1,0,0) 
											   total_d_1 = formatnumber(cdbl(total_dimension_1 * 1.0),2,-1,0,0)%>
											<td width="20%" align="center"> 
											 <%if encu_ncorr=23 then
											     response.Write("80")
											  else
											  	 response.Write("76")
											  end if%></td>
										</tr>
										<tr>
										    <td width="25%" align="left">Interacción con los alumnos</td>
											<td width="25%" align="left">6,7,10,11,18,19,22,23</td>
											<!--<td width="10%" align="left"><strong>40</strong></td>-->
											<td width="10%" align="left"><strong>&nbsp;</strong></td>
											<td width="20%" align="left"><%if encu_ncorr <> 23 then
											                                  response.Write(total_dimension_2)
																		 else
																			  response.Write(interaccion_x_profesor)
																		 end if%></td>
											<%'total_d_2 = formatnumber(cdbl(total_dimension_2 * 0.40),2,-1,0,0) 
											   total_d_2 = formatnumber(cdbl(total_dimension_2 * 1.0),2,-1,0,0)%>
											<td width="20%" align="center">32</td>
										</tr>
										<tr>
										    <td width="25%" align="left">Aspectos Administrativos</td>
											<td width="25%" align="left">25,26</td>
											<!--<td width="10%" align="left"><strong>20</strong></td>-->
											<td width="10%" align="left"><strong>&nbsp;</strong></td>
											<td width="20%" align="left"><%if encu_ncorr <> 23 then
											                                  response.Write(total_dimension_3)
																		 else
																			  response.Write(administrativos_x_profesor)
																		 end if%></td>
											<%'total_d_3 = formatnumber(cdbl(total_dimension_3 * 0.20 ),2,-1,0,0) 
											  total_d_3 = formatnumber(cdbl(total_dimension_3 * 1.0 ),2,-1,0,0)%>
											<td width="20%" align="center">8</td>
										</tr>
										<tr>
										    <td width="50%" align="right" colspan="3"><strong>Total :</strong></td>
											<%total_docente = cdbl(total_d_1) + cdbl(total_d_2) + cdbl(total_d_3) + cdbl(total_d_4) + cdbl(total_d_5)
											  if cdbl(cantidad_encuestas) <= 0 then 
											    total_docente_promedio = 0
											  else
											    if encu_ncorr = 23 then
											          total_docente_promedio  = cdbl(total_x_profesor)   
												else
													  total_docente_promedio =  cdbl(total_docente)' / cdbl(cantidad_encuestas)  response.Write(metodologicos_x_profesor)
											    end if	
											  	 
											  end if%>
											<td width="50%" align="left" colspan="3"><font color="#CC0000"><strong><%=total_docente_promedio%></strong></font></td>
     									</tr>
										<tr>
										    <td width="50%" align="right" colspan="3"><strong>Calificación :</strong></td>
											<% tipo=""
											   'response.Write("select replace("&total_docente_promedio&",',','.')")
											   'total_docente_promedio= conectar.consultaUno("select replace('"&total_docente_promedio&"',',','.')")
											   total_docente_promedio=cdbl(total_docente_promedio)
											   'response.Write(total_docente_promedio)
											   'if total_docente_promedio >= cdbl(0.0) and total_docente_promedio < cdbl(31.3) then
											   	'	tipo = "DEFICIENTE"
											   'elseif total_docente_promedio >= cdbl(31.3) and total_docente_promedio <= cdbl(38.1) then
											   '		tipo = "SATISFACTORIO"
											   'else
											   '		tipo = "BUENO"
											   'end if
											   if encu_ncorr <> 23 then 
												   if total_docente_promedio >= cdbl(29.0) and total_docente_promedio <= cdbl(55.0) then
														tipo = "INSUFICIENTE"
												   elseif total_docente_promedio >= cdbl(56.0) and total_docente_promedio <= cdbl(86.0) then
														tipo = "SATISFACTORIO"
												   else
														tipo = "BUENO"
												   end if									
												else
												   if total_docente_promedio >= cdbl(30.0) and total_docente_promedio <= cdbl(57.0) then
														tipo = "INSUFICIENTE"
												   elseif total_docente_promedio >= cdbl(58.0) and total_docente_promedio <= cdbl(89.0) then
														tipo = "SATISFACTORIO"
												   else
														tipo = "BUENO"
												   end if									
												 end if  
											   	 %>
											<td width="50%" align="left" colspan="3"><font color="#CC0000"><strong><%=tipo%></strong></font></td>
     									</tr>
									</table>
							   </td>
							</tr>
							<tr>
							    <td colspan="13"><hr></td>
							</tr>
							<tr>
							   <td colspan="13" align="center"><strong>PUNTAJE OBTENIDO</strong>
							   </td>
							</tr>   
							<tr>
							   <td colspan="13" align="center">
							   		<table width="70%" border="1" bordercolor="#990000" bgcolor="#FFFFFF">
										<tr>
										    <td width="35%" align="left"><strong>CALIFICACION</strong></td>
											<td width="35%" align="left"><strong>RANGO DE PUNTOS</strong></td>
											<td width="30%" align="left"><strong>PUNTAJE OBTENIDO</strong></td>
										</tr>
										<%if encu_ncorr <> 23 then 
												   if total_docente_promedio >= cdbl(29.0) and total_docente_promedio <= cdbl(55.0) then
														tipo = "INSUFICIENTE"
												   elseif total_docente_promedio >= cdbl(56.0) and total_docente_promedio <= cdbl(86.0) then
														tipo = "SATISFACTORIO"
												   else
														tipo = "BUENO"
												   end if									
												else
												   if total_docente_promedio >= cdbl(30.0) and total_docente_promedio <= cdbl(57.0) then
														tipo = "INSUFICIENTE"
												   elseif total_docente_promedio >= cdbl(58.0) and total_docente_promedio <= cdbl(89.0) then
														tipo = "SATISFACTORIO"
												   else
														tipo = "BUENO"
												   end if									
										 end if  %>
										
										<%if tipo = "INSUFICIENTE" then%>
											<tr>
												<td width="35%" align="left" bgcolor="#990000"><font color="#FFFFFF"><strong>INSUFICIENTE</strong></font></td>
												<td width="35%" align="center" bgcolor="#990000"><font color="#FFFFFF"><strong>... 55</strong></font></td>
												<td width="30%" align="center" bgcolor="#990000"><font color="#FFFFFF"><strong><%=total_docente_promedio%></strong></font></td>
										   </tr>
										  <%else%>
										   <tr>
												<td width="35%" align="left"><strong>INSUFICIENTE</strong></td>
												<td width="35%" align="center"><strong>... 55</strong></td>
												<td width="30%" align="center">&nbsp;</td>
										   </tr>
										<%end if%>
										<%if tipo = "SATISFACTORIO" then%>
											<tr>
												<td width="35%" align="left" bgcolor="#990000"><font color="#FFFFFF"><strong>SATISFACTORIO</strong></font></td>
												<td width="35%" align="center" bgcolor="#990000"><font color="#FFFFFF"><strong>56 ... 86</strong></font></td>
												<td width="30%" align="center" bgcolor="#990000"><font color="#FFFFFF"><strong><%=total_docente_promedio%></strong></font></td>
										   </tr>
										  <%else%>
										   <tr>
												<td width="35%" align="left"><strong>SATISFACTORIO</strong></td>
												<td width="35%" align="center"><strong>56 ... 86</strong></td>
												<td width="30%" align="cenetr">&nbsp;</td>
										   </tr>
										<%end if%>
										<%if tipo = "BUENO" then%>
											<tr>
												<td width="35%" align="left" bgcolor="#990000"><font color="#FFFFFF"><strong>BUENO</strong></font></td>
												<td width="35%" align="center" bgcolor="#990000"><font color="#FFFFFF"><strong>87 ...</strong></font></td>
												<td width="30%" align="center" bgcolor="#990000"><font color="#FFFFFF"><strong><%=total_docente_promedio%></strong></font></td>
										   </tr>
										  <%else%>
										   <tr>
												<td width="35%" align="left"><strong>BUENO</strong></td>
												<td width="35%" align="center"><strong>87 ... </strong></td>
												<td width="30%" align="center">&nbsp;</td>
										   </tr>
										<%end if%>
									</table>
							   </td>
							</tr>
							<tr>
							   <td colspan="13" align="center">&nbsp;</td>
							</tr>
							
					  </table> 

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
					                       botonera.agregaBotonParam "excel","url","observaciones_excel.asp?pers_ncorr="&pers_ncorr&"&secc_ccod="&secc_ccod
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
	  <%end if%>	
   </td>
  </tr>  
</table>
</body>
</html>
