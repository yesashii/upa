<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Información del docente"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
rut = request.querystring("busqueda[0][pers_nrut]")
digito = request.querystring("busqueda[0][pers_xdv]")
'--------------------------------------------------------------------------



 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "Claves_docentes.xml", "busqueda_usuarios"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' "
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut
 f_busqueda.AgregaCampoCons "pers_xdv", digito
'--------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Claves_docentes.xml", "botonera"
botonera.agregabotonparam "agregar", "url", "Mant_Usuarios_Buscar.asp"
'--------------------------------------------------------------------------
if rut <> "" then 
	set formulario = new CFormulario
	formulario.Carga_Parametros "Claves_docentes.xml", "f1"
	formulario.Inicializar conexion
	
	consulta = "SELECT a.pers_ncorr, b.pers_nrut, lower(a.susu_tlogin) as susu_tlogin, upper(a.susu_tclave) as susu_tclave, " & vbcrlf & _
			   "   convert(datetime,a.susu_fmodificacion,103) as susu_fmodificacion, "& vbcrlf & _
			   "   a.pers_ncorr as c_pers_ncorr, " & vbcrlf & _
			   "   cast(b.pers_nrut as varchar) + '-' + b.pers_xdv as rut, " & vbcrlf & _
			   "   b.pers_tnombre + ' ' + b.pers_tape_paterno +' '+ b.pers_tape_materno as nombre_usuario, "& vbcrlf & _
			   "   (select top 1 lower(email_nuevo) from cuentas_email_upa tt where tt.pers_ncorr=b.pers_ncorr order by fecha_creacion desc) +' (Clave temporal: ' + "& vbCrLf &_
			   "    isnull((select top 1 t2.clave from cuentas_email_upa tt, email_outlook t2  "& vbCrLf &_
			   "            where tt.pers_ncorr=b.pers_ncorr and tt.email_nuevo collate Modern_Spanish_CI_AS = t2.cuenta),'') + ')' as email"& vbcrlf & _
			   " FROM sis_usuarios a, personas b "& vbcrlf & _
			   " WHERE a.pers_ncorr = b.pers_ncorr and cast(b.pers_nrut as varchar)='"&rut&"'"& vbcrlf & _
			   " and not exists (select 1 from sis_roles_usuarios ss where ss.pers_ncorr=b.pers_ncorr and ss.srol_ncorr not in (3,4,5,106) )"& vbcrlf & _
			   " ORDER BY a.susu_tlogin " 
	'response.Write("<pre>"&consulta&"</pre>")
	'response.End()
	formulario.Consultar consulta
	
	set formulario2 = new CFormulario
	formulario2.Carga_Parametros "Claves_docentes.xml", "asignaturas"
	formulario2.Inicializar conexion
	
	pers_ncorr = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&rut&"'")
	'response.End()
	consulta_asignaturas = " select *, "& vbcrlf & _
						   " case when porcentaje_ingreso > 0 and porcentaje_ingreso < 100 then '<a href=""notas_parciales_excel.asp?secc_ccod='+cast(secc_ccod as varchar)+'"" target= ""_top""><img src=""../imagenes/amarillo.bmp"" width=""32"" height=""32"" border=""0""></a>' "& vbcrlf & _
						   " when porcentaje_ingreso = 0 then '<a href=""notas_parciales_excel.asp?secc_ccod='+cast(secc_ccod as varchar)+'"" target= ""_top""><img src=""../imagenes/rojo.bmp"" width=""32"" height=""32"" border=""0""></a>' "& vbcrlf & _
					       " else '<a href=""notas_parciales_excel.asp?secc_ccod='+cast(secc_ccod as varchar)+'"" target= ""_top""><img src=""../imagenes/verde.bmp"" width=""32"" height=""32"" border=""0""></a>' "& vbcrlf & _
						   " end as libro "& vbcrlf & _
						   " from "& vbcrlf & _
						   " ( "& vbcrlf & _
	                       " select sede, carrera, asignatura,secc_ccod, seccion, periodo, total_programado,total_evaluado, "& vbcrlf & _
						   " cast((total_evaluado * 100.00) / case total_programado when 0 then 1 else total_programado end as decimal(6,2)) as porcentaje_ingreso, "& vbcrlf & _
						   " isnull(cast(cast(puntaje_evaluacion_docente as decimal (6,2)) as varchar) + ' evaluado por '+ cast(total_encuestados as varchar) + ' alumno(s)','--') as puntaje_ED "& vbcrlf & _
						   " from  "& vbcrlf & _
						   "	( "& vbcrlf & _
						   "	select distinct e.sede_tdesc as sede, f.carr_tdesc + ' ('+jorn_tdesc_corta+')' as carrera, "& vbcrlf & _
						   "	ltrim(rtrim(d.asig_ccod)) + ' -- ' + d.asig_tdesc as asignatura,a.secc_ccod,secc_tdesc as seccion, "& vbcrlf & _
						   "	cast(anos_ccod as varchar)+'-0' +cast(plec_ccod as varchar) as periodo, "& vbcrlf & _
						   "	(select count(*) from calificaciones_seccion ss where ss.secc_ccod=a.secc_ccod) as total_programado, "& vbcrlf & _
						   "	(select count(distinct cc.cali_ncorr)  "& vbcrlf & _
						   "	 from calificaciones_seccion ss, calificaciones_alumnos cc  "& vbcrlf & _
						   "	 where ss.secc_ccod=a.secc_ccod and ss.cali_ncorr=cc.cali_ncorr  "& vbcrlf & _
						   "	 and ss.secc_ccod=cc.secc_ccod) as total_evaluado, "& vbcrlf & _
						   "	(select avg(puntaje_total) from evaluacion_docente ss where ss.secc_ccod=a.secc_ccod and ss.pers_ncorr_destino = c.pers_ncorr) as puntaje_evaluacion_docente,   "& vbcrlf & _
						   "	(select count (distinct pers_ncorr_encuestado) from evaluacion_docente ss where ss.secc_ccod=a.secc_ccod and ss.pers_ncorr_destino = c.pers_ncorr) as total_encuestados   "& vbcrlf & _
						   "	from secciones a, bloques_horarios b, bloques_profesores c, asignaturas d, sedes e, carreras f, jornadas g,periodos_academicos h "& vbcrlf & _
						   "	where a.secc_ccod=b.secc_ccod and b.bloq_ccod=c.bloq_ccod "& vbcrlf & _
						   "	and a.asig_ccod=d.asig_ccod and a.sede_ccod=e.sede_ccod  "& vbcrlf & _
						   "	and a.carr_ccod=f.carr_ccod and a.jorn_ccod=g.jorn_ccod "& vbcrlf & _
						   "	and a.peri_ccod=h.peri_ccod "& vbcrlf & _
						   "	and cast(c.pers_ncorr as varchar)='"&pers_ncorr&"' and tpro_ccod=1 "& vbcrlf & _
						   "	and h.anos_ccod= datepart(year,getDate()) "& vbcrlf & _
						   "	)tabla_general ) tabla_3 order by periodo, sede,carrera, asignatura, seccion"
	'response.Write("<pre>"&consulta_asignaturas&"</pre>")
	'response.End()
	formulario2.Consultar consulta_asignaturas
	
	'Buscamos los periodos academicos en que el docente ha realizado clases par ala universidad en el año
	 set f_periodo = new CFormulario
	 f_periodo.Carga_Parametros "Claves_docentes.xml", "f_periodos"
	 
	 f_periodo.Inicializar conexion
	 f_periodo.Consultar "select ''"
	 'if  EsVacio(carr_ccod) then
	 ' 		f_busqueda.Agregacampoparam "carr_ccod", "filtro" , "1=2"
	 'end if
	 c_destino = " select distinct b.peri_ccod,b.peri_tdesc "&_
	             " from secciones a, periodos_academicos b, bloques_horarios c, bloques_profesores d"&_
	             " where a.peri_ccod = b.peri_ccod and b.anos_ccod = datePart(year,getDate())"&_
				 " and a.secc_ccod=c.secc_ccod and c.bloq_ccod = d.bloq_ccod and cast(d.pers_ncorr as varchar)='"&pers_ncorr&"' and tpro_ccod=1 "
				 
	 f_periodo.AgregaCampoParam "peri_ccod", "destino", "("&c_destino&")aaa" 
	 f_periodo.AgregaCampoCons "peri_ccod", peri_ccod 
	 f_periodo.Siguiente
	
	
end if  
%>


<html>
<head>
<title><%=Pagina.titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

function Validar()
{
	formulario = document.buscador;
	
	rut_alumno = formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value;	
	if (formulario.elements["busqueda[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].focus();
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	  }
	
	
	return true;
}
function horario()
{ var pers_ncorr = '<%=pers_ncorr%>';
   if (document.edicion.elements["p[0][peri_ccod]"].value == "")
   {
   	alert("Debe seleccionar un periodo académico para ver el horario correspondiente");
	document.edicion.elements["p[0][peri_ccod]"].focus();
   }
   else
   {
		window.open("horario_docente.asp?pers="+pers_ncorr+"&peri="+document.edicion.elements["p[0][peri_ccod]"].value,'pop'+pers_ncorr,'width=800,height=600,scrollbars=yes,resizable=yes');

   }
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
                    <tr> 
                      <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                      <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                      <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                      <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
                      <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                      <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td width="15" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                            <td width="210" valign="bottom" background="../imagenes/fondo1.gif"> 
                              <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador 
                                </font></div></td>
                            <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                            <td width="423" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                          </tr>
                        </table></td>
                      <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                      <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                      <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
                    </tr>
                  </table>
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                      <td bgcolor="#D8D8DE"><div align="center"> 
                          <form name="buscador">
                            <table width="98%"  border="0">
                              <tr> 
                                <td width="81%"><table width="524" border="0">
                                    <tr> 
                                      <td width="98">Rut Usuario</td>
                                      <td width="23">:</td>
                                      <td width="389"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                        <%f_busqueda.DibujaCampo("pers_nrut") %>
                                        - 
                                        <%f_busqueda.DibujaCampo("pers_xdv")%>
                                        </font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
                                    </tr>
                                  </table></td>
                                <td width="19%"><div align="center"> 
                                    <%botonera.DibujaBoton "buscar" %>
                                  </div></td>
                              </tr>
                            </table>
                          </form>
                        </div></td>
                      <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                      <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                      <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
      </tr>
    </table>	
	<%if rut <> "" then %>	<br>		
	
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
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
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Datos 
                          Encontrados</font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0" aling="center">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE">
				 <div align="center">&nbsp; 
                    <BR>
					<%pagina.DibujarTituloPagina%>
                  </div>
					  <table width="100%" border="0">
					  <form name="edicion">
						<tr>
							<td width="100%" align="left"><br><strong>Accesos al sistema de gestión:</strong></td>
						</tr>
						<tr>
							<td width="100%" align="right"><div align="right">P&aacute;ginas: &nbsp;<%formulario.AccesoPagina%></div></td>
						</tr>
						<tr>
							<td width="100%" align="center"><div align="center"><%formulario.DibujaTabla %></div></td>
						</tr>
						<tr>
							<td width="100%" align="center"><div align="center">&nbsp;</div></td>
						</tr>
						<tr>
							<td width="100%" align="center"><div align="center">&nbsp;</div></td>
						</tr>
						<tr>
							<td width="100%" align="left"><br><strong>Carga académica anual del Docente:</strong></td>
						</tr>
						<tr>
							<td width="100%" align="right"><div align="right">P&aacute;ginas: &nbsp;<%formulario2.AccesoPagina%></div></td>
						</tr>
						<tr>
							<td width="100%" align="center"><div align="center"><%formulario2.DibujaTabla %></div></td>
						</tr>
						<tr>
							<td width="100%">&nbsp;</td>
						</tr>
						<tr>
							<td width="100%">&nbsp;</td>
						</tr>
						<tr>
							<td width="100%" align="center">
								<table width="85%" border="1" bordercolor="#990000">
									<tr>
										<td width="32" height="32" bgcolor="#FFFFFF"><img width="32" height="32" src="../imagenes/verde.bmp"></td>
										<td>El Docente ha evaluado el 100% de los evaluaciones programadas de la asignatura</td>
									</tr>
									<tr>
										<td width="32" height="32" bgcolor="#FFFFFF"><img width="32" height="32" src="../imagenes/amarillo.bmp"></td>
										<td>El Docente ha definido las evaluaciones de la asignatura pero ha ingresado sólo algunas notas.</td>
									</tr>
									<tr>
										<td width="32" height="32" bgcolor="#FFFFFF"><img width="32" height="32" src="../imagenes/rojo.bmp"></td>
										<td>El Docente aún NO ingresa notas para esta asignatura, <strong>es necesario controlar estos casos debido a que se pueden convertir en retrasos una vez terminado el periodo académico</strong>.</td>
									</tr>
									<%if formulario2.nroFilas <> 0 then %>
									<tr>
										<td colspan="2">
											<table width="100%" border="0">
											<tr>
												<td width="25%"><strong>Seleccione periodo:</strong></td>
												<td width="50%"><%f_periodo.dibujaCampo("peri_ccod")%></td>
												<td align="center"><%botonera.dibujaboton "horario"%></td>
											</tr>
											</table>
											
										</td>
									</tr>
									<%end if%>
								</table>
							</td>
						</tr>
						<tr>
							<td width="100%">&nbsp;</td>
						</tr>
					  </form>
					  </table> 
                  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="101" nowrap bgcolor="#D8D8DE"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="94%">
                        <%  botonera.dibujaboton "salir"%>
                      </td>
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
<%end if%>	  
	<br><br>
   </td>
  </tr>  
</table>
</body>
</html>
