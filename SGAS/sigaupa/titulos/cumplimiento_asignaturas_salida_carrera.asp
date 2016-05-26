<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_saca_ncorr = Request.QueryString("saca_ncorr")
q_pers_ncorr = Request.QueryString("pers_ncorr")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Cumplimiento con asignaturas de la Salida"


'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "adm_salidas_alumnos.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_salida = new CFormulario
f_salida.Carga_Parametros "adm_salidas_alumnos.xml", "salida_muestra"
f_salida.Inicializar conexion

SQL = " select b.pers_ncorr,a.saca_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut,  "& vbCrLf &_
      " b.pers_tnombre + ' ' + b.pers_tape_paterno + ' ' + b.pers_tape_materno as alumno, "& vbCrLf &_
	  " a.saca_tdesc as salida, c.tsca_ccod,case c.tsca_ccod when 1 then '<font color=#073299><strong>' "& vbCrLf &_ 
      "            when 2 then '<font color=#004000><strong>' "& vbCrLf &_ 
  	  " 		   when 3 then '<font color=#b76d05><strong>' "& vbCrLf &_ 
	  "			   when 4 then '<font color=#714e9c><strong>' "& vbCrLf &_ 
	  " 		   when 5 then '<font color=#ab2b05><strong>' "& vbCrLf &_ 
	  "  		   when 6 then '<font color=#0078c0><strong>' end + c.tsca_tdesc + '</strong></font>' as tipo_salida, d.carr_ccod, d.carr_tdesc, "& vbCrLf &_
      "    (select top 1 sede_ccod from alumnos t1, ofertas_academicas t2, especialidades t3 "& vbCrLf &_
      "            where t1.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod "& vbCrLf &_
      "            and t1.pers_ncorr=b.pers_ncorr and t3.carr_ccod=a.carr_ccod order by t2.peri_ccod desc) as sede_ccod, "& vbCrLf &_
      "    (select top 1 sede_tdesc from alumnos t1, ofertas_academicas t2, especialidades t3,sedes t4 "& vbCrLf &_
      "            where t1.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod and t2.sede_ccod=t4.sede_ccod "& vbCrLf &_
      "            and t1.pers_ncorr=b.pers_ncorr and t3.carr_ccod=a.carr_ccod order by t2.peri_ccod desc) as sede_tdesc,   "& vbCrLf &_
      "    (select top 1 jorn_tdesc from alumnos t1, ofertas_academicas t2, especialidades t3,jornadas t4 "& vbCrLf &_
      "            where t1.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod and t2.jorn_ccod=t4.jorn_ccod "& vbCrLf &_
      "            and t1.pers_ncorr=b.pers_ncorr and t3.carr_ccod=a.carr_ccod order by t2.peri_ccod desc) as jorn_tdesc,"& vbCrLf &_              
	  "    (select top 1 peri_ccod from alumnos t1, ofertas_academicas t2, especialidades t3 "& vbCrLf &_
      "            where t1.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod "& vbCrLf &_
      "            and t1.pers_ncorr=b.pers_ncorr and t3.carr_ccod=a.carr_ccod and t1.emat_ccod in (4,8) "& vbCrLf &_
	  "            order by t2.peri_ccod desc) as peri_ccod, "& vbCrLf &_
	  "    (select top 1 peri_tdesc from alumnos t1, ofertas_academicas t2, especialidades t3,periodos_academicos t4 "& vbCrLf &_
      "            where t1.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod and t2.peri_ccod=t4.peri_ccod "& vbCrLf &_
      "            and t1.pers_ncorr=b.pers_ncorr and t3.carr_ccod=a.carr_ccod and t1.emat_ccod in (4,8) "& vbCrLf &_
	  "            order by t2.peri_ccod desc) as peri_tdesc, "& vbCrLf &_
      "    (select case count(*) when 0 then 'N' else 'S' end  from alumnos t1, ofertas_academicas t2, especialidades t3 "& vbCrLf &_
      "            where t1.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod "& vbCrLf &_
      "            and t1.pers_ncorr=b.pers_ncorr and t3.carr_ccod=a.carr_ccod and t1.emat_ccod in (4)) as egresado,     "& vbCrLf &_
      "    (select case count(*) when 0 then 'N' else 'S' end  from alumnos t1, ofertas_academicas t2, especialidades t3 "& vbCrLf &_
      "            where t1.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod "& vbCrLf &_
      "            and t1.pers_ncorr=b.pers_ncorr and t3.carr_ccod=a.carr_ccod and t1.emat_ccod in (8)) as titulado, "& vbCrLf &_
	  "    (select t1.plan_ccod  from alumnos t1, ofertas_academicas t2, especialidades t3 "& vbCrLf &_
      "            where t1.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod "& vbCrLf &_
      "            and t1.pers_ncorr=b.pers_ncorr and t3.carr_ccod=a.carr_ccod and t1.emat_ccod in (8)) as plan_ccod "& vbCrLf &_
	  " from salidas_carrera a, personas b,tipos_salidas_carrera c, carreras d "& vbCrLf &_
	  " where cast(b.pers_ncorr as varchar)='"&q_pers_ncorr&"' and cast(a.saca_ncorr as varchar)='"&q_saca_ncorr&"' "& vbCrLf &_
	  " and a.tsca_ccod=c.tsca_ccod and a.carr_ccod=d.carr_ccod "

f_salida.Consultar SQL
f_salida.Siguiente
plan_ccod = f_salida.obtenerValor("plan_ccod")
egresado  = f_salida.obtenerValor("egresado")
titulado  = f_salida.obtenerValor("titulado")
carr_ccod = f_salida.obtenerValor("carr_ccod")
tsca_ccod = f_salida.obtenerValor("tsca_ccod")
f_salida.primero

set f_asignaturas = new CFormulario
f_asignaturas.Carga_Parametros "adm_salidas_alumnos.xml", "asignaturas"
f_asignaturas.Inicializar conexion

c_asignaturas_faltantes = " select d.espe_tdesc as especialidad,c.plan_tdesc as plan_estudio, e.asig_ccod as cod_asignatura, e.asig_tdesc as asignatura, "& vbCrLf &_
						  " case protic.es_ramo_aprobado('"&q_pers_ncorr&"',b.asig_ccod,'"&carr_ccod&"',"&plan_ccod&") when 0 then 'N0' else 'SI' end as aprobado "& vbCrLf &_
						  " from asignaturas_salidas_carrera a, malla_curricular b, planes_estudio c, especialidades d, asignaturas e  "& vbCrLf &_
						  " where a.mall_ccod=b.mall_ccod and b.plan_ccod=c.plan_ccod and c.espe_ccod=d.espe_ccod "& vbCrLf &_
						  " and b.asig_ccod=e.asig_ccod "& vbCrLf &_
						  " and cast(a.saca_ncorr as varchar)='"&q_saca_ncorr&"'  "& vbCrLf &_
						  " order by aprobado,especialidad, plan_estudio, asignatura"

f_asignaturas.Consultar c_asignaturas_faltantes						  

'-------------------------------------------------------------------
str_accion = "Cumplimiento asignaturas Requisitos"
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
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
            <td><%pagina.DibujarLenguetas Array(str_accion), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><br>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo str_accion%>
                      <br>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><div align="center"><%f_salida.DibujaRegistro%></div></td>
                        </tr>
                        <tr>
                          <td>&nbsp;</td>
                        </tr>
						<tr>
                          <td align="right">P&aacute;ginas : <%f_asignaturas.AccesoPagina%></td>
                        </tr>
						<tr>
                          <td align="center"><%f_asignaturas.dibujatabla()%></td>
                        </tr>
                      </table></td>
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
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.AgregaBotonParam "excel", "url","cumplimiento_asignaturas_salida_carrera_excel.asp?saca_ncorr=" & q_saca_ncorr & "&pers_ncorr=" & q_pers_ncorr
				                            f_botonera.DibujaBoton "excel" %></div></td>
                  <td><div align="center"><%f_botonera.DibujaBoton "cerrar" %></div></td>
                </tr>
              </table>
            </div></td>
            <td width="62%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
