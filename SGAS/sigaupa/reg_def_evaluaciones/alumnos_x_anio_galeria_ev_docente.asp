<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

carr_ccod = request.querystring("carr_ccod")
pers_ncorr = request.querystring("pers_ncorr")
anos_ccod = request.querystring("anos_ccod")
anos_ccod_encuesta = request.QueryString("anos_ccod_encuesta")

pagina.Titulo = "Evaluación Docente"



'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'----------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Especialidades.xml", "botonera"
'----------------------------------------------------------------

rut = conexion.consultaUno("select cast(pers_nrut as varchar)+'-'+pers_xdv from personas  where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
rut2 = conexion.consultaUno("select pers_nrut from personas  where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
nombre = conexion.consultaUno("select protic.initCap(pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno) from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
email = conexion.consultaUno("select lower(email_nuevo) from cuentas_email_upa  where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
sede = conexion.consultaUno("select top 1 protic.initCap(sede_tdesc) from alumnos a, ofertas_academicas b,sedes c,especialidades d,periodos_academicos e where a.ofer_ncorr=b.ofer_ncorr and b.sede_ccod=c.sede_ccod and b.espe_ccod=d.espe_ccod and b.peri_ccod=e.peri_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and d.carr_ccod='"&carr_ccod&"' and cast(anos_ccod as varchar)='"&anos_ccod&"'  and a.emat_ccod <> 9 and a.alum_nmatricula <> 7777 order by b.peri_ccod desc")
carrera = conexion.consultaUno("select protic.initCap(carr_tdesc) from carreras where  cast(carr_ccod as varchar)='"&carr_ccod&"'")
ingreso = conexion.consultaUno("select protic.ano_ingreso_carrera("&pers_ncorr&",'"&carr_ccod&"')")
jornada = conexion.consultaUno("select top 1 protic.initCap(jorn_tdesc) from alumnos a, ofertas_academicas b,jornadas c,especialidades d,periodos_academicos e where a.ofer_ncorr=b.ofer_ncorr and b.jorn_ccod=c.jorn_ccod and b.espe_ccod=d.espe_ccod and b.peri_ccod=e.peri_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and d.carr_ccod='"&carr_ccod&"' and cast(anos_ccod as varchar)='"&anos_ccod&"'  and a.emat_ccod <> 9 and a.alum_nmatricula <> 7777 order by b.peri_ccod desc")
especialidad = conexion.consultaUno("select top 1 protic.initCap(espe_tdesc) from alumnos a, ofertas_academicas b,sedes c,especialidades d where a.ofer_ncorr=b.ofer_ncorr and b.sede_ccod=c.sede_ccod and b.espe_ccod=d.espe_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and d.carr_ccod='"&carr_ccod&"' and a.emat_ccod <> 9 and a.alum_nmatricula <> 7777 order by b.peri_ccod desc")
plan = conexion.consultaUno("select top 1 protic.initCap(plan_tdesc) from alumnos a, ofertas_academicas b,sedes c,especialidades d,planes_estudio e where a.ofer_ncorr=b.ofer_ncorr and b.sede_ccod=c.sede_ccod and b.espe_ccod=d.espe_ccod and a.plan_ccod=e.plan_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and d.carr_ccod='"&carr_ccod&"' and a.emat_ccod <> 9 and a.alum_nmatricula <> 7777 order by b.peri_ccod desc")
plan_ccod = conexion.consultaUno("select top 1 protic.initCap(a.plan_ccod) from alumnos a, ofertas_academicas b,sedes c,especialidades d,planes_estudio e where a.ofer_ncorr=b.ofer_ncorr and b.sede_ccod=c.sede_ccod and b.espe_ccod=d.espe_ccod and a.plan_ccod=e.plan_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and d.carr_ccod='"&carr_ccod&"' and a.emat_ccod <> 9 and a.alum_nmatricula <> 7777 order by b.peri_ccod desc")
peri_ccod = conexion.consultaUno("select top 1 protic.initCap(b.peri_ccod) from alumnos a, ofertas_academicas b,sedes c,especialidades d,planes_estudio e where a.ofer_ncorr=b.ofer_ncorr and b.sede_ccod=c.sede_ccod and b.espe_ccod=d.espe_ccod and a.plan_ccod=e.plan_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and d.carr_ccod='"&carr_ccod&"' and a.emat_ccod <> 9 and a.alum_nmatricula <> 7777 order by b.peri_ccod desc")
periodo_mostrar = conexion.consultaUno("select cast(anos_ccod as varchar) + '- 0' + cast(plec_ccod as varchar) from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
'response.Write(plan_ccod)

if anos_ccod_encuesta = "" then
	anos_ccod_encuesta = conexion.consultaUno("select datepart(year,getDate()) ")
end if

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "alumnos_x_anio_galeria.xml", "ff_busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"

 c_anos = "(select distinct anos_ccod, anos_ccod as anos_tdesc from alumnos a, ofertas_academicas b, especialidades c, periodos_academicos d "&_
          " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and b.peri_ccod=d.peri_ccod "&_
		  " and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and c.carr_ccod='"&carr_ccod&"' and a.emat_ccod <> 9 and a.alum_nmatricula <> 7777 )tt"
 'response.Write(c_anos)
 f_busqueda.agregaCampoParam "anos_ccod","destino",c_anos
 f_busqueda.agregaCampoCons "anos_ccod",anos_ccod_encuesta
 f_busqueda.siguiente

set f_ramos = new CFormulario
f_ramos.Carga_Parametros "tabla_vacia.xml", "tabla"
f_ramos.Inicializar conexion
'response.Write(carrera)			
consulta2 = "  select distinct e.asig_ccod,f.asig_tdesc,protic.initcap(i.pers_tnombre + ' ' + i.pers_tape_paterno) as docente,e.secc_ccod,i.pers_ncorr, " & vbCrLf &_
			"  case c.plec_ccod when 1 then '1er Sem' when 2 then '2do Sem' when 3 then '3er Tri' end as semestre " & vbCrLf &_
			"  from alumnos a, ofertas_academicas b,periodos_academicos c,cargas_academicas d, " & vbCrLf &_
			"       secciones e,asignaturas f,bloques_horarios g, bloques_profesores h,personas i,especialidades j " & vbCrLf &_
			"  where cast(a.pers_ncorr as varchar)= '"&pers_ncorr&"' " & vbCrLf &_
			"  and a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
			"  and b.peri_ccod = c.peri_ccod and cast(c.anos_ccod as varchar)='"&anos_ccod_encuesta&"' and c.plec_ccod in (1,2,3) " & vbCrLf &_
			"  and a.matr_ncorr=d.matr_ncorr and d.secc_ccod=e.secc_ccod " & vbCrLf &_
			"  and e.asig_ccod=f.asig_ccod and e.secc_ccod=g.secc_ccod  " & vbCrLf &_
			"  and g.bloq_ccod=h.bloq_ccod and h.tpro_ccod=1 " & vbCrLf &_
			"  and h.pers_ncorr=i.pers_ncorr and b.espe_ccod=j.espe_ccod and j.carr_ccod='"&carr_ccod&"'" & vbCrLf &_
			"  and not exists (select 1 from convalidaciones conv where conv.matr_ncorr=a.matr_ncorr and conv.asig_ccod=e.asig_ccod) " & vbCrLf &_
			"  order by semestre"
			
			
f_ramos.Consultar consulta2
lenguetas_detalle = Array(Array("Avance Curricular", "alumnos_x_anio_galeria_detalle.asp?pers_ncorr="&pers_ncorr&"&carr_ccod="&carr_ccod&"&anos_ccod="&anos_ccod), Array("Evaluación Docente", "alumnos_x_anio_galeria_ev_docente.asp?pers_ncorr="&pers_ncorr&"&carr_ccod="&carr_ccod&"&anos_ccod="&anos_ccod))
carr_ccod2 = conexion.consultaUno("select ltrim(rtrim(carr_ccod)) from carreras where carr_ccod='"&carr_ccod&"'")

tiene_foto  = conexion.consultaUno("Select case count(*) when 0 then 'N' else 'S' end from rut_fotos_2010 where cast(rut as varchar)='"&rut2&"'")
tiene_foto2 = conexion.consultaUno("Select case count(*) when 0 then 'N' else 'S' end from fotos_alumnos where cast(pers_nrut as varchar)='"&rut2&"'")

if tiene_foto="S" then 
 	nombre_foto = conexion.consultaUno("Select ltrim(rtrim(imagen)) from rut_fotos_2010 where cast(rut as varchar)='"&rut2&"'")
elseif tiene_foto="N" and tiene_foto2="S" then 
  	nombre_foto = conexion.consultaUno("Select ltrim(rtrim(foto_truta)) from fotos_alumnos where cast(pers_nrut as varchar)='"&rut2&"'")	
else
    nombre_foto = "user.png"
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
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>

<script language="JavaScript">
function recargar(valor)
{
	//alert(valor);
	document.getElementById("texto_alerta").style.visibility="visible";
	url = "alumnos_x_anio_galeria_ev_docente.asp?pers_ncorr=<%=pers_ncorr%>&carr_ccod=<%=carr_ccod2%>&anos_ccod=<%=anos_ccod%>&anos_ccod_encuesta="+valor;
	//alert(url);
	document.location = url;
	//document.edicion.submit();
}
</script>
</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="500" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  
  <tr> 
    <td valign="top" bgcolor="#EAEAEA"> <br> <br> <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
        <tr> 
          <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
          <td height="8" background="../imagenes/top_r1_c2.gif"></td>
          <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
        </tr>
        <tr> 
          <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
          <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td><%pagina.DibujarLenguetas lenguetas_detalle, 2%></td>
              </tr>
              <tr> 
                <td height="2" background="../imagenes/top_r3_c2.gif"></td>
              </tr>
              <tr> 
                <td><div align="center"><br>
                    <%pagina.DibujarTituloPagina%>
                    <br><BR>
                  </div>
				  <form name="edicion">
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr valign="top"> 
                        <td width="90%" align="center">
                          <table width="100%" border="0">
                            <tr> 
                                <td width="10%" align="left"><strong>Rut</strong></td>
								<td width="1%" align="left"><strong>:</strong></td>
								<td width="89%" align="left"><%=rut%></td>
                            </tr>
							<tr> 
                                <td width="10%" align="left"><strong>Nombre</strong></td>
								<td width="1%" align="left"><strong>:</strong></td>
								<td width="89%" align="left"><%=nombre%></td>
                            </tr>
							<tr> 
                                <td width="10%" align="left"><strong>Email</strong></td>
								<td width="1%" align="left"><strong>:</strong></td>
								<td width="89%" align="left"><%=email%></td>
                            </tr>
							<tr> 
                                <td width="10%" align="left"><strong>Sede</strong></td>
								<td width="1%" align="left"><strong>:</strong></td>
								<td width="89%" align="left"><%=sede%></td>
                            </tr>
							<tr> 
                                <td width="10%" align="left"><strong>Carrera</strong></td>
								<td width="1%" align="left"><strong>:</strong></td>
								<td width="89%" align="left"><%=carrera%></td>
                            </tr>
							<tr> 
                                <td width="10%" align="left"><strong>Jornada</strong></td>
								<td width="1%" align="left"><strong>:</strong></td>
								<td width="89%" align="left"><%=jornada%></td>
                            </tr>
							<tr> 
                                <td width="10%" align="left"><strong>Ingreso</strong></td>
								<td width="1%" align="left"><strong>:</strong></td>
								<td width="89%" align="left"><%=ingreso%></td>
                            </tr>
							<tr> 
                                <td width="10%" align="left"><strong>Especialidad</strong></td>
								<td width="1%" align="left"><strong>:</strong></td>
								<td width="89%" align="left"><%=especialidad%></td>
                            </tr>
							<tr> 
                                <td width="10%" align="left"><strong>Plan</strong></td>
								<td width="1%" align="left"><strong>:</strong></td>
								<td width="89%" align="left"><%=plan%></td>
                            </tr>
							<tr>
								<td width="10%" align="left"><strong>Año a consultar</strong></td>
								<td width="1%" align="left"><strong>:</strong></td>
								<td width="89%" align="left"><%f_busqueda.dibujaCampo("anos_ccod")%></td>
							</tr>
							<tr>
								<td colspan="3" align="center">
								  <div  align="center" id="texto_alerta" style="visibility: hidden;"><font color="#0000FF" size="-1">Cargando encuestas...</font></div>
								</td>
							</tr>
							<tr>
								<td colspan="3">
								      <script language='javaScript1.2'> colores = Array(3);   colores[0] = ''; colores[1] = '#FFECC6'; colores[2] = '#FFECC6'; </script>
												<table width='100%' border='0' cellpadding='0' cellspacing='0' bgcolor='#ADADAD' id='tb_ramos'>
													<tr bgcolor='#C4D7FF'>
														<th colspan="5" align="center"><font color="#333333">Estado Evaluación docente año <%=anos_ccod_encuesta%></font></th>
													</tr>
													<tr bgcolor='#C4D7FF'>
														<th><font color='#333333'>Código</font></th>
														<th><font color='#333333'>Asignatura</font></th>
														<th><font color='#333333'>Periodo</font></th>
														<th><font color='#333333'>Docente</font></th>
														<th width="10%" bgcolor="#e41712"><font color='#FFFFFF'><strong>AVANCE</strong></font></th>
													</tr>
													<%f_ramos.primero
													  codigo = "C-ID"
													  validador = 0
													  while f_ramos.siguiente
													  secc_ccod = f_ramos.obtenerValor("secc_ccod")
													  pers_ncorr_profesor = f_ramos.obtenerValor("pers_ncorr")
													  asig_ccod = f_ramos.obtenerValor("asig_ccod")
													  asig_tdesc = f_ramos.obtenerValor("asig_tdesc")
													  periodo = f_ramos.obtenerValor("semestre")
													  docente = f_ramos.obtenerValor("docente")
													  encuestado = f_ramos.obtenerValor("encuestado")
													  antigua = conexion.consultaUno("select count(*) from evaluacion_docente where cast(secc_Ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"'")
													  fase_1 = conexion.consultaUno("select count(*) from cuestionario_opinion_alumnos where cast(secc_Ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(pers_ncorr_profesor as varchar)='"&pers_ncorr_profesor&"' and isnull(parte_2_1,7) <> 7")
													  fase_2 = conexion.consultaUno("select count(*) from cuestionario_opinion_alumnos where cast(secc_Ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(pers_ncorr_profesor as varchar)='"&pers_ncorr_profesor&"' and isnull(parte_3_1,7) <> 7")
													  fase_3 = conexion.consultaUno("select count(*) from cuestionario_opinion_alumnos where cast(secc_Ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(pers_ncorr_profesor as varchar)='"&pers_ncorr_profesor&"' and isnull(parte_4_1,7) <> 7")
													  fase_4 = conexion.consultaUno("select count(*) from cuestionario_opinion_alumnos where cast(secc_Ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(pers_ncorr_profesor as varchar)='"&pers_ncorr_profesor&"' and isnull(parte_5_1,7) <> 7")
													  fase_5 = conexion.consultaUno("select count(*) from cuestionario_opinion_alumnos where cast(secc_Ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(pers_ncorr_profesor as varchar)='"&pers_ncorr_profesor&"' and isnull(parte_6_1,7) <> 7")
													  cuadro1 = "<img width='8' height='14' border='0' src='../imagenes/sinevaluar.jpg'>"
													  cuadro2 = "<img width='8' height='14' border='0' src='../imagenes/sinevaluar.jpg'>"
													  cuadro3 = "<img width='8' height='14' border='0' src='../imagenes/sinevaluar.jpg'>"
													  cuadro4 = "<img width='8' height='14' border='0' src='../imagenes/sinevaluar.jpg'>"
													  cuadro5 = "<img width='8' height='14' border='0' src='../imagenes/sinevaluar.jpg'>"
													  if  antigua <> "0" then
													  	cuadro1 = "<img width='8' height='14' border='0' src='../imagenes/evaluada.jpg'>"
														cuadro2 = "<img width='8' height='14' border='0' src='../imagenes/evaluada.jpg'>"
														cuadro3 = "<img width='8' height='14' border='0' src='../imagenes/evaluada.jpg'>"
														cuadro4 = "<img width='8' height='14' border='0' src='../imagenes/evaluada.jpg'>"
														cuadro5 = "<img width='8' height='14' border='0' src='../imagenes/evaluada.jpg'>"
														codigo = codigo & "|" & secc_ccod
														validador = validador + cdbl(secc_ccod)
													  else
													  	if fase_1 <> "0" then
															cuadro1 = "<img width='8' height='14' border='0' src='../imagenes/evaluada.jpg'>"
														end if
														if fase_2 <> "0" then
															cuadro2 = "<img width='8' height='14' border='0' src='../imagenes/evaluada.jpg'>"
														end if
														if fase_3 <> "0" then
															cuadro3 = "<img width='8' height='14' border='0' src='../imagenes/evaluada.jpg'>"
														end if
														if fase_4 <> "0" then
															cuadro4 = "<img width='8' height='14' border='0' src='../imagenes/evaluada.jpg'>"
														end if
														if fase_5 <> "0" then
															cuadro5 = "<img width='8' height='14' border='0' src='../imagenes/evaluada.jpg'>"
															'acá agregaremos los validadores 
															codigo = codigo & "|" & secc_ccod
															validador = validador + cdbl(secc_ccod)
														end if
													  end if
													  %>
													  <tr bgcolor="#FFFFFF"> 
													        <td class='click'onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><font class="-1"><%=asig_ccod%></font></td>
															<td class='click'onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><%=asig_tdesc%></td>
															<td class='click'align='CENTER' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><%=periodo%></td>
															<td class='click'align='CENTER' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><%=docente%></td>
															<td class='click'align='CENTER' width='10%' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>
																	<table width="98%" height="5" border="1" bordercolor="#e41712">
																	   <tr>
																	   		<td width="20%"><%=cuadro1%></td>
																			<td width="20%"><%=cuadro2%></td>
																			<td width="20%"><%=cuadro3%></td>
																			<td width="20%"><%=cuadro4%></td>
																			<td width="20%"><%=cuadro5%></td>
																	   </tr>
																	</table>
															</td>
													 </tr>
													<% POS_IMAGEN = POS_IMAGEN + 5
													   wend
													   codigo = codigo &"PNC"&pers_ncorr_temporal 
													   validador = validador + cdbl(anos_ccod)
													%>
												</table>
								</td>
							</tr>
                          </table>
                         </td>
						 <td width="10%" align="center"><img width="90" height="98" src="../informacion_alumno_2008b/imagenes/alumnos/<%=nombre_foto%>" border="2"></td>
                      </tr>
                    </table>
                  </form></td>
              </tr>
            </table></td>
          <td width="7" background="../imagenes/der.gif">&nbsp;</td>
        </tr>
        <tr> 
          <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
          <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="19%" height="20"><div align="center"> 
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                         <td width="100%"><div align="center">
                            <%botonera.dibujaBoton "cancelar" %>
                          </div></td>
                      </tr>
                    </table>
                  </div></td>
                <td width="81%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
              </tr>
              <tr> 
                <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
              </tr>
            </table></td>
          <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
        </tr>
      </table>
      <br> </td>
  </tr>
</table>
</body>
</html>
