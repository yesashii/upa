<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

secc_ccod = request.querystring("secc_ccod")
matr_ncorr = request.querystring("matr_ncorr")

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

rut = conexion.consultaUno("select cast(pers_nrut as varchar)+'-'+pers_xdv from alumnos a, personas b where a.pers_ncorr=b.pers_ncorr and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")
nombre = conexion.consultaUno("select protic.initCap(pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno) from alumnos a, personas b where a.pers_ncorr=b.pers_ncorr and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")
email = conexion.consultaUno("select lower(email_nuevo) from alumnos a, personas b,cuentas_email_upa c where a.pers_ncorr=b.pers_ncorr and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and b.pers_ncorr=c.pers_ncorr ")
sede = conexion.consultaUno("select protic.initCap(sede_tdesc) from alumnos a, ofertas_academicas b,sedes c where a.ofer_ncorr=b.ofer_ncorr and b.sede_ccod=c.sede_ccod and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")
carrera = conexion.consultaUno("select protic.initCap(carr_tdesc) from alumnos a, ofertas_academicas b,especialidades c,carreras d  where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")
ingreso = conexion.consultaUno("select protic.ano_ingreso_carrera(a.pers_ncorr,c.carr_ccod) from alumnos a, ofertas_academicas b,especialidades c,carreras d  where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")
jornada = conexion.consultaUno("select protic.initCap(jorn_tdesc) from alumnos a, ofertas_academicas b,jornadas c where a.ofer_ncorr=b.ofer_ncorr and b.jorn_ccod=c.jorn_ccod and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")
final = conexion.consultaUno("select cast(carg_nnota_final as varchar) + ' ('+ltrim(rtrim(sitf_ccod))+')' from cargas_academicas where cast(matr_ncorr as varchar)='"&matr_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"'")


set datos_evaluacion = new CFormulario
datos_evaluacion.Carga_Parametros "fotos_alumnos_seccion.xml", "parciales"
datos_evaluacion.Inicializar conexion
consulta_evaluacion =  " select cali_nevaluacion as orden,teva_tdesc as tipo, cali_nponderacion as ponderacion,cala_nnota as nota "& vbCrLf &_
					   " from calificaciones_alumnos a,calificaciones_seccion b,tipos_evaluacion c "& vbCrLf &_
					   " where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and cast(a.secc_ccod as varchar)='"&secc_ccod&"' "& vbCrLf &_
					   " and a.secc_ccod=b.secc_ccod and a.cali_ncorr=b.cali_ncorr "& vbCrLf &_
					   " and b.teva_ccod=c.teva_ccod "& vbCrLf &_
					   " order by cali_nevaluacion "

datos_evaluacion.Consultar consulta_evaluacion

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
<table width="450" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  
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
                <td><%pagina.DibujarLenguetas Array("Detalle Alumno"), 1 %></td>
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
                      <tr> 
                        <td>
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
								<td colspan="3">&nbsp;</td>
							</tr>
							<tr>
								<td colspan="3" align="center">
										<div align="center">
										  <% datos_evaluacion.DibujaTabla %>
										</div>
								</td>
							</tr>
							<%if final <> "" then%>
							<tr>
								<td colspan="3" align="center"><%=final%></td>
							</tr>
							<%end if%>
                          </table>
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
