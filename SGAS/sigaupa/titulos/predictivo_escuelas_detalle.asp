<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

carr_ccod = request.querystring("carr_ccod")
pers_ncorr = request.querystring("pers_ncorr")
plan_ccod = request.querystring("plan_ccod")

pagina.Titulo = "Datos Alumno(a)"


'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'----------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Especialidades.xml", "botonera"
'----------------------------------------------------------------
peri_ccod = negocio.obtenerPeriodoAcademico("CLASES18")
rut = conexion.consultaUno("select cast(pers_nrut as varchar)+'-'+pers_xdv from personas  where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
rut2 = conexion.consultaUno("select pers_nrut from personas  where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
nombre = conexion.consultaUno("select protic.initCap(pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno) from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
email = conexion.consultaUno("select lower(email_nuevo) from cuentas_email_upa  where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
sede = conexion.consultaUno("select top 1 protic.initCap(sede_tdesc) from alumnos a, ofertas_academicas b,sedes c,especialidades d,periodos_academicos e where a.ofer_ncorr=b.ofer_ncorr and b.sede_ccod=c.sede_ccod and b.espe_ccod=d.espe_ccod and b.peri_ccod=e.peri_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and d.carr_ccod='"&carr_ccod&"' and cast(a.plan_ccod as varchar)='"&plan_ccod&"'  and a.emat_ccod <> 9 and a.alum_nmatricula <> 7777 order by b.peri_ccod desc")
carrera = conexion.consultaUno("select protic.initCap(carr_tdesc) from carreras where  cast(carr_ccod as varchar)='"&carr_ccod&"'")
ingreso = conexion.consultaUno("select protic.ano_ingreso_carrera("&pers_ncorr&",'"&carr_ccod&"')")
jornada = conexion.consultaUno("select top 1 protic.initCap(jorn_tdesc) from alumnos a, ofertas_academicas b,jornadas c,especialidades d,periodos_academicos e where a.ofer_ncorr=b.ofer_ncorr and b.jorn_ccod=c.jorn_ccod and b.espe_ccod=d.espe_ccod and b.peri_ccod=e.peri_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and d.carr_ccod='"&carr_ccod&"' and cast(a.plan_ccod as varchar)='"&plan_ccod&"' and a.emat_ccod <> 9 and a.alum_nmatricula <> 7777 order by b.peri_ccod desc")
especialidad = conexion.consultaUno("select espe_tdesc from planes_estudio a, especialidades b where a.espe_ccod=b.espe_ccod and cast(plan_ccod as varchar)='"&plan_ccod&"'")
plan = conexion.consultaUno("select plan_tdesc from planes_estudio  where cast(plan_ccod as varchar)='"&plan_ccod&"'")
periodo_mostrar = conexion.consultaUno("select cast(anos_ccod as varchar) + '- 0' + cast(plec_ccod as varchar) from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")

set datos_plan = new CFormulario
datos_plan.Carga_Parametros "fotos_alumnos_seccion.xml", "parciales"
datos_plan.Inicializar conexion
consulta_plan =  " select nive_ccod, ltrim(rtrim(b.asig_ccod))+' -- '+ b.asig_tdesc as asignatura, "& vbCrLf &_
				 " isnull(protic.estado_ramo_alumno("&pers_ncorr&",b.asig_ccod,'"&carr_ccod&"',a.plan_ccod,'"&peri_ccod&"'),'') as aprobado "& vbCrLf &_
				 " from malla_curricular a, asignaturas b "& vbCrLf &_
				 " where a.asig_ccod=b.asig_ccod "& vbCrLf &_
				 " and cast(a.plan_ccod as varchar)='"&plan_ccod&"' and isnull(mall_npermiso,0) <> 1 "& vbCrLf &_
				 " order by nive_ccod "
'response.Write("<pre>"&consulta_plan&"</pre>")
datos_plan.Consultar consulta_plan
datos_plan.siguiente
nivel = datos_plan.obtenerValor("nive_ccod")
datos_plan.primero


lenguetas_detalle = Array(Array("Avance Curricular", "alumnos_x_anio_galeria_detalle.asp?pers_ncorr="&pers_ncorr&"&carr_ccod="&carr_ccod&"&anos_ccod="&anos_ccod))

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
                <td><%pagina.DibujarLenguetas lenguetas_detalle, 1%></td>
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
                        <td width="90%" align="left">
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
								<td colspan="3">&nbsp;</td>
							</tr>
							<tr>
								<td colspan="3">
									<table width="98%" cellpadding="0" cellspacing="0" border="1" bordercolor="#666666">
									   <tr>
									   		<td colspan="3" align="center" bgcolor="#FF9900"><strong>NIVEL <%=nivel%></strong></td>
									   </tr>
									   <tr>
									   		<td width="6%" align="center" bgcolor="#FF9900"><strong>Nivel</strong></td>
											<td width="80%" align="center" bgcolor="#FF9900"><strong>Asignatura</strong></td>
											<td width="14%" align="center" bgcolor="#FF9900"><strong>Estado</strong></td>
									   </tr>
									   <%while datos_plan.siguiente
									   		nivel_actual = datos_plan.obtenerValor("nive_ccod")
											asignatura = datos_plan.obtenerValor("asignatura")
											aprobado = datos_plan.obtenerValor("aprobado")
											color = "#FFFFFF"
											if aprobado = "" then
												color= "#FFFFFF"
											elseif aprobado = "CA" then
											    aprobado=periodo_mostrar
												color= "#66CC66"
											else
												color= "#3399FF"
											end if
										 if cint(nivel) = cint(nivel_actual) then 	
									   %>
									   <tr>
									   		<td width="6%" align="center" bgcolor="<%=color%>"><%=nivel_actual%></td>
											<td width="80%" align="left" bgcolor="<%=color%>"><%=asignatura%></td>
											<td width="14%" align="center" bgcolor="<%=color%>"><%=aprobado%></td>
									   </tr>
									   <%else
									       nivel = nivel_actual
										   datos_plan.anterior%>
									       </table>
								          </td>
							            </tr>
										<tr>
											<td colspan="3">&nbsp;</td>
										</tr>
										<tr>
											<td colspan="3">
												<table width="98%" cellpadding="0" cellspacing="0" border="1" bordercolor="#666666">
												   <tr>
														<td colspan="3" align="center" bgcolor="#FF9900"><strong>NIVEL <%=nivel%></strong></td>
												   </tr>
												   <tr>
														<td width="6%" align="center" bgcolor="#FF9900"><strong>Nivel</strong></td>
														<td width="80%" align="center" bgcolor="#FF9900"><strong>Asignatura</strong></td>
														<td width="14%" align="center" bgcolor="#FF9900"><strong>Estado</strong></td>
												   </tr>
									   <%end if%>
									   <%wend%>
									</table>
								</td>
							</tr>
							<tr>
								<td colspan="3">&nbsp;</td>
							</tr>
                          </table>
                         </td>
						 <td width="10%" align="center">
						     <img width="90" height="98" src="../informacion_alumno_2008b/imagenes/alumnos/<%=nombre_foto%>" border="2">
						 </td>
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
