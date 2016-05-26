<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conectar = new CConexion
conectar.Inicializar "upacifico"


usuario = session("rut_tyg") 'negocio.obtenerUsuario
if usuario = "" then
	session("mensajeerror")= "Debe ingresar con un usuario y clave para ver esta opción, acceso sólo egresados y titulados de la Universidad."
	response.Redirect("index.asp?eea=0") 
end if

nombre = conectar.consultaUno("select protic.initcap(pers_tnombre) from personas where cast(pers_nrut as varchar)='"&usuario&"'")
pers_ncorr = conectar.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")
id_ceremonia = conectar.consultaUno("select id_ceremonia from detalles_titulacion_carrera where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
carr_ccod = conectar.consultaUno("select carr_ccod from alumnos_salidas_carrera a, salidas_carrera b where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.saca_ncorr=b.saca_ncorr and b.tsca_ccod in (1,2,3) ")
fecha_ceremonia = conectar.consultaUno("select protic.trunc(fecha_ceremonia) from ceremonias_titulacion where cast(id_ceremonia as varchar)='"&id_ceremonia&"'")
sede_ceremonia = conectar.consultaUno("select protic.initCap(sede_tdesc) from ceremonias_titulacion a, sedes b where a.sede_ccod=b.sede_ccod and cast(id_ceremonia as varchar)='"&id_ceremonia&"'")
hora_ceremonia = conectar.consultaUno("select hora_inicio from ceremonias_titulacion where cast(id_ceremonia as varchar)='"&id_ceremonia&"'")
lugar_ceremonia = conectar.consultaUno("select lugar from ceremonias_titulacion where cast(id_ceremonia as varchar)='"&id_ceremonia&"'")

consulta =  " select distinct b.sede_ccod,protic.initCap(d.sede_tdesc) as sede_tdesc,a.carr_ccod,protic.initCap(e.carr_tdesc) as carr_tdesc "& vbCrLf &_
			" from detalles_titulacion_carrera a, alumnos_salidas_carrera b, "& vbCrLf &_
			" salidas_carrera c, sedes d, carreras e "& vbCrLf &_
			" where cast(a.id_ceremonia as varchar)='"&id_ceremonia&"' "& vbCrLf &_
			" and a.pers_ncorr=b.pers_ncorr and b.saca_ncorr=c.saca_ncorr "& vbCrLf &_
			" and a.carr_ccod=c.carr_ccod and c.tsca_ccod in (1,2,3,4)  "& vbCrLf &_
			" and b.sede_ccod=d.sede_ccod and a.carr_ccod=e.carr_ccod and e.carr_ccod='"&carr_ccod&"'"& vbCrLf &_
			" order by sede_tdesc, carr_tdesc " 

set f_carrera = new cFormulario
f_carrera.carga_parametros	"tabla_vacia.xml" , "tabla"
f_carrera.inicializar		conectar
f_carrera.consultar 		consulta
registros = f_carrera.nrofilas

tcar_ccod = conectar.consultaUno("select tcar_ccod from carreras where carr_ccod='"&carr_ccod&"'")
datos_basicos = conectar.consultaUno("select count(*) from requerimientos_titulacion where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and (isnull(ACADEMICA,'N')='N' or isnull(FINANCIERA,'N')='N' or isnull(BIBLIOTECA,'N')='N' or isnull(AUDIOVISUAL,'N')='N') ")
if tcar_ccod = "1" then
	otros_datos = conectar.consultaUno("select count(*) from requerimientos_titulacion where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and (isnull(LICENCIA_EM,'N')='N' or isnull(CONCENTRACION_EM,'N')='N' or isnull(PAA_PSU,'N')='N' or isnull(CEDULA_DI,'N')='N') ")
else
	otros_datos = conectar.consultaUno("select count(*) from requerimientos_titulacion where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and (isnull(CERTIFICADO_TG,'N')='N' or isnull(CONCENTRACION_NU,'N')='N' or isnull(CURRICULUM_VITAE,'N')='N' or isnull(MALLA_CURRICULAR,'N')='N' or isnull(CEDULA_DI,'N')='N' ) ")
end if
'response.Write("datos básicos "&datos_basicos)
'response.Write("<br>otros datos "&otros_datos)

set f_requisitos = new cFormulario
f_requisitos.carga_parametros	"tabla_vacia.xml" , "tabla"
f_requisitos.inicializar		conectar

consulta_requisitos = "select case isnull(ACADEMICA,'N') when 'S' then 'OK' else 'N0' end as ACADEMICA, "& vbCrLf &_
                      "       case isnull(FINANCIERA,'N') when 'S' then 'OK' else 'N0' end as FINANCIERA, "& vbCrLf &_
					  "		  case isnull(BIBLIOTECA,'N') when 'S' then 'OK' else 'NO' end as BIBLIOTECA, "& vbCrLf &_
					  "		  case isnull(AUDIOVISUAL,'N') when 'S' then 'OK' else 'NO' end as AUDIOVISUAL, "& vbCrLf &_
					  "		  case isnull(LICENCIA_EM,'N') when 'S' then 'SI' else 'NO' end as LICENCIA_EM, "& vbCrLf &_
					  "		  case isnull(CONCENTRACION_EM,'N') when 'S' then 'SI' else 'NO' end as CONCENTRACION_EM, "& vbCrLf &_
					  "		  case isnull(PAA_PSU,'N') when 'S' then 'SI' else 'NO' end as PAA_PSU, "& vbCrLf &_
					  "		  case isnull(CEDULA_DI,'N') when 'S' then 'SI' else 'NO' end as CEDULA_DI, "& vbCrLf &_
					  "		  case isnull(CERTIFICADO_TG,'N') when 'S' then 'SI' else 'NO' end as CERTIFICADO_TG, "& vbCrLf &_
					  "		  case isnull(CONCENTRACION_NU,'N') when 'S' then 'SI' else 'NO' end as CONCENTRACION_NU, "& vbCrLf &_
					  "		  case isnull(CURRICULUM_VITAE,'N') when 'S' then 'SI' else 'NO' end as CURRICULUM_VITAE, "& vbCrLf &_
					  "		  case isnull(MALLA_CURRICULAR,'N') when 'S' then 'SI' else 'NO' end as MALLA_CURRICULAR "& vbCrLf &_
					  "  from  requerimientos_titulacion "& vbCrLf &_
					  "  where cast(pers_ncorr as varchar)='"&pers_ncorr&"' "

f_requisitos.consultar consulta_requisitos
filas_requisitos = f_requisitos.nroFilas
f_requisitos.siguiente

if filas_requisitos > 0 then 
	ACADEMICA = f_requisitos.obtenerValor("ACADEMICA")
	FINANCIERA = f_requisitos.obtenerValor("FINANCIERA")
	BIBLIOTECA = f_requisitos.obtenerValor("BIBLIOTECA")
	AUDIOVISUAL = f_requisitos.obtenerValor("AUDIOVISUAL")
	LICENCIA_EM = f_requisitos.obtenerValor("LICENCIA_EM")
	CONCENTRACION_EM = f_requisitos.obtenerValor("CONCENTRACION_EM")
	PAA_PSU = f_requisitos.obtenerValor("PAA_PSU")
	CEDULA_DI = f_requisitos.obtenerValor("CEDULA_DI")
	CERTIFICADO_TG = f_requisitos.obtenerValor("CERTIFICADO_TG")
	CONCENTRACION_NU = f_requisitos.obtenerValor("CONCENTRACION_NU")
	CURRICULUM_VITAE = f_requisitos.obtenerValor("CURRICULUM_VITAE")
	MALLA_CURRICULAR = f_requisitos.obtenerValor("MALLA_CURRICULAR")
else
	ACADEMICA = "NO"
	FINANCIERA = "NO"
	BIBLIOTECA = "NO"
	AUDIOVISUAL = "NO"
	LICENCIA_EM = "NO"
	CONCENTRACION_EM = "NO"
	PAA_PSU = "NO"
	CEDULA_DI = "NO"
	CERTIFICADO_TG = "NO"
	CONCENTRACION_NU = "NO"
	CURRICULUM_VITAE = "NO"
	MALLA_CURRICULAR = "NO"
	datos_basicos = "1"
	otros_datos = "1"
end if

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
  <meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
  <meta name="description" content="Your description goes here" />
  <meta name="keywords" content="your,keywords,goes,here" />
  <link rel="stylesheet" type="text/css" href="andreas01.css" media="screen,projection" />
  <title>Web de T&iacute;tulos y Grados</title>
<script src="Scripts/AC_RunActiveContent.js" type="text/javascript"></script>
<style>
a {
	color: #000000;
	text-decoration: none;
	font-weight:bold;	
}

a:hover {
	color: #63ABCC;
}
</style>
</head>

<body>
<div id="wrap">
    <div id="header">
      <script type="text/javascript">
AC_FL_RunContent( 'codebase','http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,28,0','width','760','height','100','src','swf/top_2','quality','high','pluginspage','http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash','movie','swf/top_2' ); //end AC code
      </script>
      <noscript>
      <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,28,0" width="760" height="100">
        <param name="movie" value="swf/top_2.swf" />
        <param name="quality" value="high" />
        <embed src="swf/top_2.swf" quality="high" pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="760" height="100"></embed>
      </object>
      </noscript>
    </div>
<hr color="#cccccc">

<div id="avmenu">
  <script type="text/javascript">
AC_FL_RunContent( 'codebase','http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,28,0','width','154','height','400','src','menu_2','quality','high','pluginspage','http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash','movie','menu_2' ); //end AC code
        </script>
  <noscript>
  <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,28,0" width="154" height="400">
    <param name="movie" value="menu_2.swf" />
    <param name="quality" value="high" />
    <embed src="menu_2.swf" quality="high" pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="154" height="400"></embed>
  </object>
  </noscript>
  </li>
    </ul>
  </div>
<div id="content2">
  <table width="100%" bgcolor="#FFFFFF" border="0">
    <tr>
      <td width="100%" align="left">
	  		<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr valign="bottom">
					<td bgcolor="#FFFFFF" width="8" height="18"><img width="8" height="18" src="img/esq_sup_izq.png"></td>
					<td bgcolor="#FFFFFF" height="18" background="img/superior.png">&nbsp;</td>
					<td bgcolor="#FFFFFF" width="12" height="18"><img width="12" height="18" src="img/esq_sup_der.png"></td>
				</tr>
				<tr>
					<td bgcolor="#FFFFFF" width="8" background="img/izquierda.png">&nbsp;</td>
					<td bgcolor="#FFFFFF">
										 <table width="100%" cellpadding="0" cellspacing="0">
														<tr>
															<td width="100%" colspan="3" align="left">
																<font size="3"><strong>Nómina convocados a ceremonia de Titulación</strong></font>
															</td>
														</tr>
														<tr>
															<td width="100%" colspan="3" align="left">&nbsp;</td>
														</tr>
														<tr>
															<td width="14%" align="left">
																<font size="2"><strong>Fecha</strong></font>
															</td>
															<td width="14%" align="center">
																<font size="2"><strong>:</strong></font>
															</td>
															<td width="85%" align="left">
																<font size="2"><%=fecha_ceremonia%></font>
															</td>
														</tr>
														<tr>
															<td width="14%" align="left">
																<font size="2"><strong>Sede</strong></font>
															</td>
															<td width="14%" align="center">
																<font size="2"><strong>:</strong></font>
															</td>
															<td width="85%" align="left">
																<font size="2"><%=sede_ceremonia%></font>
															</td>
														</tr>
														<tr>
															<td width="14%" align="left">
																<font size="2"><strong>Lugar</strong></font>
															</td>
															<td width="14%" align="center">
																<font size="2"><strong>:</strong></font>
															</td>
															<td width="85%" align="left">
																<font size="2"><%=lugar_ceremonia%></font>
															</td>
														</tr>
														<tr>
															<td width="14%" align="left">
																<font size="2"><strong>Horario</strong></font>
															</td>
															<td width="14%" align="center">
																<font size="2"><strong>:</strong></font>
															</td>
															<td width="85%" align="left">
																<font size="2"><%=hora_ceremonia%></font>
															</td>
														</tr>
														<tr><td colspan="3">&nbsp;</td></tr>
								    </table>
					 </td>
				 	 <td bgcolor="#FFFFFF" width="12" background="img/derecha.png">&nbsp;</td>
				</tr>
				<tr valign="top">
				   <td bgcolor="#FFFFFF" width="8" height="18"><img width="8" height="18" src="img/esq_inf_izq.png"></td>
				   <td bgcolor="#FFFFFF" height="18" background="img/inferior.png">&nbsp;</td>
				   <td bgcolor="#FFFFFF" width="12" height="18"><img width="12" height="18" src="img/esq_inf_der.png"></td>
				</tr>
		 </table>
	  </td>
    </tr>
	<tr>
		<td width="100%" align="left">
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr valign="bottom">
					<td bgcolor="#FFFFFF" width="8" height="18"><img width="8" height="18" src="img/esq_sup_izq.png"></td>
					<td bgcolor="#FFFFFF" height="18" background="img/superior.png">&nbsp;</td>
					<td bgcolor="#FFFFFF" width="12" height="18"><img width="12" height="18" src="img/esq_sup_der.png"></td>
				</tr>
				<tr>
					<td bgcolor="#FFFFFF" width="8" background="img/izquierda.png">&nbsp;</td>
					<td bgcolor="#FFFFFF">
										<%if datos_basicos = "0" and otros_datos = "0" then %>
										<table width="100%" cellpadding="0" cellspacing="0">
													    <% while f_carrera.siguiente 
														    sede_ccod = f_carrera.obtenerValor("sede_ccod")
															sede_tdesc = f_carrera.obtenerValor("sede_tdesc")
															carr_ccod = f_carrera.obtenerValor("carr_ccod")
															carr_tdesc = f_carrera.obtenerValor("carr_tdesc")
															
															consulta =  " select distinct f.pers_ncorr,cast(f.pers_nrut as varchar)+'-'+f.pers_xdv as rut,  "& vbCrLf &_
																		" protic.initCap(f.pers_tape_paterno + ' ' + f.pers_tape_materno + ', '+ f.pers_tnombre) as nombre  "& vbCrLf &_
																		" from detalles_titulacion_carrera a, alumnos_salidas_carrera b,   "& vbCrLf &_
																		"    salidas_carrera c, sedes d, carreras e, personas f  "& vbCrLf &_
																		" where cast(a.id_ceremonia as varchar)='"&id_ceremonia&"'  "& vbCrLf &_
																		" and a.pers_ncorr=b.pers_ncorr and b.saca_ncorr=c.saca_ncorr  "& vbCrLf &_
																		" and a.carr_ccod=c.carr_ccod and c.tsca_ccod in (1,2,3,4) "& vbCrLf &_
																		" and b.sede_ccod=d.sede_ccod and a.carr_ccod=e.carr_ccod  "& vbCrLf &_
																		" and cast(d.sede_ccod as varchar)='"&sede_ccod&"' and e.carr_ccod='"&carr_ccod&"' "& vbCrLf &_
																		" and a.pers_ncorr=f.pers_ncorr  "& vbCrLf &_
																		" order by nombre asc "

															
															set f_alumnos = new cFormulario
															f_alumnos.carga_parametros	"tabla_vacia.xml" , "tabla"
															f_alumnos.inicializar		conectar
															f_alumnos.consultar 		consulta
															total_alumnos = f_alumnos.nrofilas
															%>
															<tr>
																<td width="100%" colspan="3" align="left">
																	<font size="2"><strong><%=carr_tdesc%></strong></font>
																</td>
															</tr>
															<tr>
																<td width="100%" colspan="3" align="left">
																	<font size="+1"><strong><%=sede_tdesc%></strong></font>
																</td>
															</tr>
															<%if total_alumnos > 0 then%>
															<tr>
																<td width="100%" colspan="3" align="left">
																	<table width="100%" cellpadding="0" cellspacing="0" border="0" bordercolor="#000000">
																		<tr>
																			<td width="30%" align="center" bgcolor="#99CCFF"><strong>Rut</strong></td>
																			<td width="30%" align="center" bgcolor="#99CCFF"><strong>Alumno</strong></td>
																		</tr>
																		<%while f_alumnos.siguiente
																		    pers_ncorr2 = f_alumnos.obtenerValor("pers_ncorr") 
																			  color = "#FFFFFF"
																			 if cstr(pers_ncorr) = cstr(pers_ncorr2) then
																			  color = "#FFCC99" 	
																			 end if
																			%>
																		<tr>
																			<td width="30%" align="left" bgcolor="<%=color%>"><%=f_alumnos.obtenerValor("rut")%></td>
																			<td width="30%" align="left" bgcolor="<%=color%>"><%=f_alumnos.obtenerValor("nombre")%></td>
																		</tr>
																		<%wend%>
																	</table>
																</td>
															</tr>
															<tr>
																<td width="100%" colspan="3" align="left">&nbsp;</td>
															</tr>
															<%end if%>
														<%wend%>
														<tr><td colspan="3">&nbsp;</td></tr>
								</table>
								<%else%>
								<table width="100%" cellpadding="0" cellspacing="0">
									<tr>
										<td width="100%" colspan="2" align="left">
												<font size="2"><strong>Documentos requeridos por departamento de Títulos y grados</strong></font>
										</td>
									</tr>
									<tr>
										<td width="100%" colspan="2" align="left">&nbsp;
												
										</td>
									</tr>
									<tr valign="top">
										<td width="50%" align="center">
											<table width="95%" border="1" bordercolor="#b90000" cellpadding="0" cellspacing="0">
												<tr>
													<td width="80%" bgcolor="#e0e0e0" align="center"><font color="#333333"><strong>SITUACIÓN</strong></font></td>
													<td width="20%" bgcolor="#e0e0e0" align="center"><font color="#333333"><strong>ESTADO</strong></font></td>
												</tr>
												<tr>
													<td width="80%" align="left"><font color="#333333">Académica</font></td>
													<td width="20%" align="center"><font color="#333333"><%=ACADEMICA%></font></td>
												</tr>
												<tr>
													<td width="80%" align="left"><font color="#333333">Financiera</font></td>
													<td width="20%" align="center"><font color="#333333"><%=FINANCIERA%></font></td>
												</tr>
												<tr>
													<td width="80%" align="left"><font color="#333333">Biblioteca</font></td>
													<td width="20%" align="center"><font color="#333333"><%=BIBLIOTECA%></font></td>
												</tr>
												<tr>
													<td width="80%" align="left"><font color="#333333">Audiovisual</font></td>
													<td width="20%" align="center"><font color="#333333"><%=AUDIOVISUAL%></font></td>
												</tr>
											</table>
										</td>
										<td width="50%" align="center">
											<table width="95%" border="1" bordercolor="#b90000" cellpadding="0" cellspacing="0">
												<tr>
													<td width="80%" bgcolor="#e0e0e0" align="center"><font color="#333333"><strong>DOCUMENTO</strong></font></td>
													<td width="20%" bgcolor="#e0e0e0" align="center"><font color="#333333"><strong>ENTREGADO</strong></font></td>
												</tr>
												<%if tcar_ccod="1" then %>
												<tr>
													<td width="80%" align="left"><font color="#333333">Licencia de Enseñanza Media</font></td>
													<td width="20%" align="center"><font color="#333333"><%=LICENCIA_EM%></font></td>
												</tr>
												<tr>
													<td width="80%" align="left"><font color="#333333">Concentración de notas E.Media</font></td>
													<td width="20%" align="center"><font color="#333333"><%=CONCENTRACION_EM%></font></td>
												</tr>
												<tr>
													<td width="80%" align="left"><font color="#333333">PAA PSU</font></td>
													<td width="20%" align="center"><font color="#333333"><%=PAA_PSU%></font></td>
												</tr>
												<%else%>
												<tr>
													<td width="80%" align="left"><font color="#333333">Certificado Título o G.Académico</font></td>
													<td width="20%" align="center"><font color="#333333"><%=CERTIFICADO_TG%></font></td>
												</tr>
												<tr>
													<td width="80%" align="left"><font color="#333333">Concentración de notas Universidad</font></td>
													<td width="20%" align="center"><font color="#333333"><%=CONCENTRACION_NU%></font></td>
												</tr>
												<tr>
													<td width="80%" align="left"><font color="#333333">Curriculum Vitae</font></td>
													<td width="20%" align="center"><font color="#333333"><%=CURRICULUM_VITAE%></font></td>
												</tr>
												<tr>
													<td width="80%" align="left"><font color="#333333">Malla Curricular</font></td>
													<td width="20%" align="center"><font color="#333333"><%=MALLA_CURRICULAR%></font></td>
												</tr>
												<%end if%>
												<tr>
													<td width="80%" align="left"><font color="#333333">Cédula de Identidad</font></td>
													<td width="20%" align="center"><font color="#333333"><%=CEDULA_DI%></font></td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td width="100%" colspan="2" align="left">&nbsp;
												
										</td>
									</tr>
								</table>
								<%end if%>
					</td>
					<td bgcolor="#FFFFFF" width="12" background="img/derecha.png">&nbsp;</td>
				</tr>
				<tr valign="top">
					<td bgcolor="#FFFFFF" width="8" height="18"><img width="8" height="18" src="img/esq_inf_izq.png"></td>
					<td bgcolor="#FFFFFF" height="18" background="img/inferior.png">&nbsp;</td>
					<td bgcolor="#FFFFFF" width="12" height="18"><img width="12" height="18" src="img/esq_inf_der.png"></td>
				</tr>
		    </table>
		</td>
	 </tr>							
  </table>
  </div>

<div id="footer">
      <p>Universidad del Pacífico - Derechos Reservados / Sitio desarrollado para Explorer 8, o superior; Firefox o Safari</p>
    </div>
  </div>
  <script type="text/javascript">
<!--

//-->
  </script>
</body>
</html>
