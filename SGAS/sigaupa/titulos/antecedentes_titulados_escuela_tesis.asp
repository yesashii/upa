<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
plan_ccod  = Request.QueryString("plan_ccod")
pers_ncorr  = Request.QueryString("pers_ncorr")
q_ctes_ncorr  = Request.QueryString("ctes_ncorr")
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Antecedentes de Tesis"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

if session("msjOk") <> ""  then
	mensaje_html = "<center> "&_
				   "     <table border='1'  bordercolor='#339900' cellspacing='2' cellpadding='5' align='center'> "&_
				   "       <tr>"&_
				   "	         <td align='center' bgcolor='#CCFFCC'>"&session("msjOk")&"</td> "&_
				   "       </tr>"&_
				   "     </table> "&_
				   " </center>"
	session("msjOk")=""
end if
if session("msjError") <> ""  then
	mensaje_html = "<center>"&_
				   "    <table border='1'  bordercolor='#CC6600' cellspacing='2' cellpadding='5' align='center'> "&_
				   "      <tr> "&_
				   "         <td align='center' bgcolor='#FFCC66'>"&session("msjError")&"</td> "&_
				   "      </tr> "&_
				   "    </table> "&_
				   "</center>"
	session("msjError")=""
end if

'---------------------------------------------------------------------------------------------------
q_plan_ccod  = plan_ccod
q_peri_ccod  = ultimo_periodo

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "antecedentes_titulados_escuela.xml", "botonera_de"

'---------------------------------------------------------------------------------------------------
set f_titulado = new CFormulario
f_titulado.Carga_Parametros "antecedentes_titulados_escuela.xml", "encabezado_de"
f_titulado.Inicializar conexion

SQL = " select top 1 b.sede_ccod, a.pers_ncorr, a.plan_ccod, c.espe_ccod, b.peri_ccod, e.carr_ccod,e.carr_tdesc, c.espe_tdesc, "&_
      " h.peri_tdesc, d.sede_tdesc, g.plan_tdesc as plan_ncorrelativo, protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre "&_
      " from alumnos a, ofertas_academicas b, especialidades c, sedes d, carreras e, jornadas f, planes_estudio g, periodos_academicos h"&_
	  " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and b.sede_ccod=d.sede_ccod and c.carr_ccod=e.carr_ccod "&_
	  " and b.jorn_ccod=f.jorn_ccod and a.plan_ccod=g.plan_ccod and b.peri_ccod=h.peri_ccod "&_
	  " and cast(a.pers_ncorr as varchar)= '" & pers_ncorr & "'"&_
	  " and cast(a.plan_ccod as varchar)= '" & plan_ccod & "' and emat_ccod <> 9 order by b.peri_ccod desc "
	  

f_titulado.Consultar SQL
f_titulado.SiguienteF
v_sede_ccod = f_titulado.obtenerValor ("sede_ccod")
carr_ccod   = f_titulado.obtenerValor ("carr_ccod")

q_pers_ncorr = pers_ncorr

if q_ctes_ncorr <> "" then
	 consulta_comision = " select '"&q_peri_ccod&"' as peri_ccod,ctes_ncorr, pers_nrut,pers_xdv, a.pers_ncorr, a.plan_ccod, docente, "&_
				" replace(calificacion_asignada,',','.') as calificacion_asignada " &_
				" from comision_tesis a, personas b "&_
				" where a.pers_ncorr=b.pers_ncorr "&_
				" and cast(a.ctes_ncorr as varchar)='"&q_ctes_ncorr&"'"
else
     consulta_comision = " select '"&plan_consulta&"' as plan_ccod, '"&q_pers_ncorr&"' as pers_ncorr"
end if

'response.Write("promedio tesis "&promedio_tesis)
'----------------------datos adicionales tesis
tiene_grabado = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end  from detalles_titulacion_carrera where cast(plan_ccod as varchar)='"&plan_ccod&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"' and carr_ccod='"&carr_ccod&"'")

if tiene_grabado = "S" then
	 consulta_tesis = " select pers_ncorr,plan_ccod,tema_tesis,"&_
				" protic.trunc(inicio_tesis) as inicio_tesis,protic.trunc(fecha_ceremonia) as fecha_ceremonia,id_ceremonia,protic.trunc(termino_tesis) as termino_tesis, "&_
			    " replace(calificacion_tesis,',','.') as calificacion_tesis,protic.trunc(fecha_titulacion) as fecha_titulacion "&_
				" from detalles_titulacion_carrera a "&_
				" where cast(plan_ccod as varchar)='"&plan_ccod&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"' and carr_ccod='"&carr_ccod&"'"
else
     consulta_tesis = " select '"&plan_ccod&"' as plan_ccod, '"&pers_ncorr&"' as pers_ncorr"
end if
'response.Write(consulta)
set f_tesis = new CFormulario
f_tesis.Carga_Parametros "antecedentes_titulados_escuela.xml", "datos_tesis"
f_tesis.Inicializar conexion

consulta_fecha =  " select protic.trunc(b.asca_fsalida) from salidas_carrera a, alumnos_salidas_carrera b " &_
			      " where cast(a.plan_ccod as varchar)='"&plan_ccod&"'  and a.carr_ccod='"&carr_ccod&"' and a.saca_ncorr=b.saca_ncorr "&_
		          " and cast(b.pers_ncorr as varchar)='"&pers_ncorr&"' and a.tsca_ccod in (1,4)"

fecha_examen = conexion.consultaUno(consulta_fecha)

f_tesis.Consultar consulta_tesis

f_tesis.agregaCampoCons "fecha_titulacion",fecha_examen
f_tesis.Siguiente
'response.Write(promedio_tesis)
'---------------------------------------------------------------------------------------------------
f_botonera.AgregaBotonUrlParam "siguiente", "plan_ccod", plan_ccod
f_botonera.AgregaBotonUrlParam "siguiente", "peri_ccod", q_peri_ccod

f_botonera.AgregaBotonUrlParam "guardar_nuevo", "plan_ccod", plan_ccod
f_botonera.AgregaBotonUrlParam "guardar_nuevo", "peri_ccod", q_peri_ccod

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
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA"><br>
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
            <td><%pagina.DibujarLenguetas Array("Antecedentes de Tesis"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
              <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>
                      <br>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><div align="center"><%f_titulado.DibujaRegistro%></div></td>
                        </tr>
                      </table>
					</td>
                  </tr>
				  <tr>
                    <td align="center">
					<%pagina.DibujarSubtitulo "Datos de Tesis."%>
                      <br>
					  <form name="tesis">
					  <input type="hidden" name="saca_ncorr" value="<%=saca_ncorr%>">
					  <table border="0" width="98%">
								<tr>
								    <td width="14%" align="left"><strong>Tema Tesis</strong></td>
									<td width="1%" align="left"><strong>:</strong></td>
									<td colspan="5" align="left"><%f_tesis.dibujaCampo("tema_tesis")%></td>
								</tr>
								<tr>
								    <td width="14%" align="left"><strong>Inicio</strong></td>
									<td width="1%" align="left"><strong>:</strong></td>
									<td width="35%" align="left"><%f_tesis.dibujaCampo("inicio_tesis")%><input type="hidden" name="tesis[0][pers_ncorr]" value="<%=q_pers_ncorr%>">&nbsp;01/01/2012</td>
									<td width="14%" align="left"><strong>&nbsp;</strong></td>
									<td width="1%" align="left"><strong>&nbsp;</strong></td>
									<td colspan="2" align="left">&nbsp;</td>
								</tr>
								<tr>
								    <td width="14%" align="left"><strong>Término</strong></td>
									<td width="1%" align="left"><strong>:</strong></td>
									<td width="35%" align="left"><%f_tesis.dibujaCampo("termino_tesis")%><input type="hidden" name="tesis[0][plan_ccod]" value="<%=plan_ccod%>">&nbsp;08/08/2012</td>
									<td width="14%" align="left">&nbsp;</td>
									<td width="1%" align="left">&nbsp;</td>
									<td colspan="2" align="left">&nbsp;</td>
								</tr>
								<tr>
								    <td colspan="7" align="right">&nbsp;</td>
    							</tr>
					  </table>
    				  </form>
					</td>
                  </tr>
                </table>
           </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="16%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
				  <td><div align="center"><%f_botonera.DibujaBoton "cerrar"%></div></td>
                  <td><div align="center"><%f_botonera.DibujaBoton "guardar_tesis"%></div></td>
                </tr>
              </table>
            </div></td>
            <td width="84%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
