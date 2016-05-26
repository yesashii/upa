<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next
'response.End()
q_plan_ccod  = Request.QueryString("plan_ccod")
q_peri_ccod  = Request.QueryString("peri_ccod")
q_pers_nrut  = Request.QueryString("pers_nrut")
q_pers_xdv   = Request.QueryString("pers_xdv")
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Certificados Emitidos al Alumno"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "detalle_egreso_titulacion.xml", "botonera"

q_pers_ncorr = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")

'---------------------------------------------------------------------------------------------------
consulta_grabado =  " select case count(*) when 0 then 'N' else 'S' end "&_
					" from salidas_carrera a, alumnos_salidas_carrera b  "&_
					" where a.saca_ncorr=b.saca_ncorr "&_
					" and b.pers_ncorr = (select pers_ncorr from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"') "

ya_grabado= conexion.consultaUno(consulta_grabado)

if ya_grabado="S" then
    lengueta_detalle = "Detalle_egreso_titulacion.asp?plan_ccod="&q_plan_ccod&"&peri_ccod="&q_peri_ccod&"&pers_nrut="&q_pers_nrut&"&pers_xdv="&q_pers_xdv
end if

'---------------------------------------------------------------------------------------------------
set f_titulado = new CFormulario
f_titulado.Carga_Parametros "adm_titulados.xml", "datos_titulacion"
f_titulado.Inicializar conexion

SQL = " select top 1 f.sede_ccod, a.pers_ncorr, b.plan_ccod, c.espe_ccod, e.peri_ccod, d.carr_tdesc, c.espe_tdesc, "& vbCrLf & _
      " e.peri_tdesc, f.sede_tdesc, b.plan_tdesc as plan_ncorrelativo, protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre"& vbCrLf & _
      " from personas a, alumnos aa, ofertas_academicas aaa, planes_estudio b, especialidades c, carreras d, periodos_academicos e, sedes f"& vbCrLf & _
      " where cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "' "& vbCrLf & _
      "   and a.pers_ncorr=aa.pers_ncorr and aa.ofer_ncorr=aaa.ofer_ncorr and aa.plan_ccod=b.plan_ccod and aaa.espe_ccod=c.espe_ccod "& vbCrLf & _
	  "   and c.carr_ccod=d.carr_ccod and aaa.peri_ccod=e.peri_ccod and aaa.sede_ccod=f.sede_ccod and aa.emat_ccod <> 9 order by e.peri_ccod desc "
'response.Write(sql)

f_titulado.Consultar SQL
f_titulado.SiguienteF


set f_emitidos = new CFormulario
f_emitidos.Carga_Parametros "adm_titulados.xml", "certificados_emitidos"
f_emitidos.Inicializar conexion

consulta_emitidos = " select cert_fecha, protic.trunc(cert_fecha) as fecha, "& vbCrLf & _
					" cert_tipo as tipo, isnull(grado,carr_tdesc) as carrera_grado,  "& vbCrLf & _
				    " isnull(comentario,'--') as comentario  "& vbCrLf & _
					" from certificados_emitidos a, carreras b  "& vbCrLf & _
					" where cast(PERS_NCORR as varchar)= '"&q_pers_ncorr&"' "& vbCrLf & _
					" and a.carr_ccod=b.carr_ccod "& vbCrLf & _
					" order by cert_fecha asc "
					
f_emitidos.Consultar consulta_emitidos

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

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');" onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">	  <br>
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
            <td><%pagina.DibujarLenguetas Array("Certificados emitidos"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><br><br>
                 <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Datos de Estudio"%>
                      <br>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><div align="center"><%f_titulado.DibujaRegistro%></div></td>
                        </tr>
                      </table>
					</td>
                  </tr>
				  <tr><td><br></td></tr>
				  <tr>
                    <td><%pagina.DibujarSubtitulo "Certificados emitidos al Alumno"%>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><div align="right">Pagina <%f_emitidos.accesoPagina%></div></td>
                        </tr>
						<tr>
                          <td><div align="center"><%f_emitidos.DibujaTabla%></div></td>
                        </tr>
                      </table>
					</td>
                  </tr>
				  <tr><td>&nbsp;</td></tr>
				  
                </table>
                          <br>
           </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="8%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
				  <td><div align="center"><%f_botonera.DibujaBoton "cerrar"%></div></td>
				</tr>
              </table>
            </div></td>
            <td width="92%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
