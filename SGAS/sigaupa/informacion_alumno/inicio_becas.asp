<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")



'---------------------------------------------------------------------------------------------------

set pagina = new CPagina
pagina.Titulo = "Solicitud de postulación a becas de arancel <br> fondo de ayuda Universidad del Pacífico"

set errores = new CErrores

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


if esVacio(q_pers_nrut) then
	q_pers_nrut = negocio.obtenerUsuario
	q_pers_xdv = conexion.consultaUno("Select pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
end if


set f_botonera = new CFormulario
f_botonera.Carga_Parametros "inicio_becas.xml", "botonera"

set f_alumno = new CFormulario
f_alumno.Carga_Parametros "inicio_becas.xml", "alumno"
f_alumno.Inicializar conexion

'---------- asignamos por defecto el primer semestre año 2006 para el proseso de postulacion a becas
session("_actividad")= 5
'-------------periodo 2º sem por defecto agregado a petición de Mónica Fernandez.
session("_periodo_POSTULACION") 	= 206
session("_periodo")= 206

v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")

v_anio_anterior = "2006"

pers_ncorr_temporal = conexion.consultaUno("select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
anos_ccod = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&v_peri_ccod&"'")
peri_tdesc= conexion.consultaUno("Select peri_tdesc from periodos_Academicos where cast(peri_ccod as varchar)='"&v_peri_ccod&"'")

postulacion_con_familiar = conexion.consultaUno("select post_ncorr from postulacion_becas where cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and cast(peri_ccod as varchar)='"&v_peri_ccod&"'")
if postulacion_con_familiar = "" or esVacio(postulacion_con_familiar) or isnull(postulacion_con_familiar) then 
	'response.Write("select a.post_ncorr from postulantes a, grupo_familiar b where a.post_ncorr = b.post_ncorr and cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and cast(a.peri_ccod as varchar)='"&v_peri_ccod&"' order by peri_ccod desc")
	postulacion_con_familiar = conexion.consultaUno("select a.post_ncorr from postulantes a, grupo_familiar b,periodos_academicos c where a.post_ncorr = b.post_ncorr and cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and a.peri_ccod = c.peri_ccod and cast(c.anos_ccod as varchar)='"&v_anio_anterior&"' order by c.peri_ccod desc")
end if


if postulacion_con_familiar = "" or esVacio(postulacion_con_familiar) or isnull(postulacion_con_familiar) then 
	'response.Write("select a.post_ncorr from postulantes a, grupo_familiar b where a.post_ncorr = b.post_ncorr and cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and cast(a.peri_ccod as varchar)='"&v_peri_ccod&"' order by peri_ccod desc")
	postulacion_con_familiar = conexion.consultaUno("select a.post_ncorr from postulantes a, detalle_postulantes b,periodos_academicos c where a.post_ncorr = b.post_ncorr and cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and a.peri_ccod= c.peri_ccod and cast(c.anos_ccod as varchar)='"&v_anio_anterior&"' and a.epos_ccod = 2 and b.eepo_ccod not in (1,3) order by c.peri_ccod desc")
end if

'consulta = " select top 1 a.pers_ncorr,cast(a.pers_nrut as varchar) + '-' + a.pers_xdv as rut, " & vbCrLf &_
'		   " a.pers_tape_paterno + ' ' + a.pers_tape_materno + ' ' + pers_tnombre as nombre_completo " & vbCrLf &_
'		   " from personas a, alumnos b, ofertas_academicas c, especialidades d " & vbCrLf &_
	'	   " where a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
	'	   " and b.emat_ccod=1 " & vbCrLf &_
'		   " and b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
'		   " and c.espe_ccod = d.espe_ccod " & vbCrLf &_
'		   " and exists (select 1 from postulantes a, detalle_postulantes b where cast(a.peri_ccod as varchar)='"&v_peri_ccod&"' and a.post_ncorr=b.post_ncorr) " & vbCrLf &_
''		   " and protic.ano_ingreso_carrera(a.pers_ncorr,d.carr_ccod) < '"&anos_ccod&"' " & vbCrLf &_
'		   "and cast(a.pers_nrut as varchar)='"&q_pers_nrut&"'" & vbCrLf &_
	'	   "--and cast(b.post_ncorr as varchar) ='"&postulacion_con_familiar&"'" 

consulta = "select top 1 a.pers_ncorr,cast(a.pers_nrut as varchar) + '-' + a.pers_xdv as rut, " & vbCrLf &_
		   " a.pers_tape_paterno + ' ' + a.pers_tape_materno + ' ' + pers_tnombre as nombre_completo, " & vbCrLf &_
		   " d.aran_nano_ingreso as ano_ingreso,case c.post_bnuevo when 'S' then 'NUEVO' else 'ANTIGUO' end as tipo " & vbCrLf &_
		   " from personas_postulante a, postulantes b, ofertas_academicas c, aranceles d,detalle_postulantes e,periodos_academicos f " & vbCrLf &_
		   " where a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
		   " and b.post_ncorr = e.post_ncorr " & vbCrLf &_
  		   " and e.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
		   " and c.aran_ncorr = d.aran_ncorr and b.epos_ccod= 2 and e.eepo_ccod not in (1,3)" & vbCrLf &_
		   " and b.peri_ccod= f.peri_ccod and cast(f.anos_ccod as varchar)='"&v_anio_anterior&"' " & vbCrLf &_
		   " --and protic.ano_ingreso_carrera(a.pers_ncorr,d.carr_ccod) < '"&anos_ccod&"' " & vbCrLf &_
		   " and cast(a.pers_nrut as varchar)='"&q_pers_nrut&"' "
'response.Write("<pre>"&consulta&"</pre>")
f_alumno.Consultar consulta

session("pers_ncorr_alumno") = pers_ncorr_temporal
session("post_ncorr_alumno") = postulacion_con_familiar
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
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
 <tr>
    <td height="80" valign="top"><img src="../imagenes/banner.jpg" width="750" height="100" border="0"></td>
  </tr>
  <%'pagina.DibujarEncabezado()%>    
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
            <td><%pagina.DibujarLenguetas Array("Postulación Becas"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
				  	<td>&nbsp;
					</td>
				  </tr>
				  <tr>
				  	<td><strong>Postulación para el periodo </strong> <%=peri_tdesc%>
					</td>
				  </tr>
				  <tr>
				  	<td>&nbsp;
					</td>
				  </tr>
				  <tr>
                    <td><%pagina.DibujarSubtitulo "Solicitante"%>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"><%f_alumno.DibujaTabla%></div></td>
                        </tr>
                      </table></td>
                  </tr>
				  <tr>
				  	<td>&nbsp;
					</td>
				  </tr>
				  <tr>
				  	<td>&nbsp;
					</td>
				  </tr>
				  <tr>
				  		<td><%if (postulacion_con_familiar ="" or isnull(postulacion_con_familiar)) and q_pers_nrut <> "" then %>
							<div align="center" ><font size="3" color="#0000FF">Imposible realizar el proceso para este alumno ya que no presenta Matriculas para el año 2006.</font></div> 
							<%end if%>
						</td>
				  </tr>
				  <tr>
				  	<td>&nbsp;
					</td>
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
            <td width="29%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><% if postulacion_con_familiar ="" or isnull(postulacion_con_familiar) then 
				                             	f_botonera.AgregaBotonParam "siguiente","deshabilitado","TRUE"
											 end if 
											   f_botonera.DibujaBoton("siguiente")%></div></td>
                  <td><div align="center"><%f_botonera.agregaBotonParam "salir","url","menu_alumno.asp"
				                            f_botonera.DibujaBoton("salir")%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="71%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
