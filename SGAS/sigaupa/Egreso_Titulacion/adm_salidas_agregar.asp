<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_sapl_ncorr = Request.QueryString("sapl_ncorr")
q_plan_ccod = Request.QueryString("plan_ccod")
q_peri_ccod = Request.QueryString("peri_ccod")
q_sede_ccod = Request.QueryString("sede_ccod")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Título de la página"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


'---------------------------------------------------------------------------------------------------
set f_botonera_g = new CFormulario
f_botonera_g.Carga_Parametros "botonera_generica.xml", "botonera"

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "adm_salidas.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "adm_salidas.xml", "encabezado"
f_encabezado.Inicializar conexion

SQL = " select c.carr_tdesc, b.espe_tdesc, a.plan_tdesc"
SQL = SQL &  " from planes_estudio a, especialidades b, carreras c"
SQL = SQL &  " where a.espe_ccod = b.espe_ccod"
SQL = SQL &  "   and b.carr_ccod = c.carr_ccod"
SQL = SQL &  "   and cast(a.plan_ccod as varchar)= '" & q_plan_ccod & "'"

f_encabezado.Consultar SQL

if f_encabezado.NroFilas > 0 then
	f_encabezado.AgregaCampoCons "peri_ccod", q_peri_ccod
end if

'---------------------------------------------------------------------------------------------------
set f_salida = new CFormulario
f_salida.Carga_Parametros "adm_salidas.xml", "salida"
f_salida.Inicializar conexion

SQL = " select a.sapl_ncorr, a.sapl_tdesc, a.plan_ccod, a.peri_ccod, a.sede_ccod, a.tspl_ccod, a.sapl_npond_asignaturas "
SQL = SQL &  " from salidas_plan a"
SQL = SQL &  " where cast(a.sapl_ncorr as varchar)= '" & q_sapl_ncorr & "'"

f_salida.Consultar SQL
'f_salida.SiguienteF

f_salida.AgregaCampoCons "peri_ccod", q_peri_ccod
f_salida.AgregaCampoCons "plan_ccod", q_plan_ccod
f_salida.AgregaCampoCons "sede_ccod", q_sede_ccod


'-------------------------------------------------------------------
if EsVacio(q_sapl_ncorr) then
	str_accion = "Agregar"
	
	SQL = " select distinct a.tspl_ccod"
	SQL = SQL &  " from salidas_plan a"
	SQL = SQL &  " where a.tspl_ccod in (2, 3, 4)"
	SQL = SQL &  "   and cast(a.plan_ccod as varchar)= '" & q_plan_ccod & "'"
	SQL = SQL &  "   and cast(a.peri_ccod as varchar)= '" & q_peri_ccod & "'"
	SQL = SQL &  "   and cast(a.sede_ccod as varchar)= '" & q_sede_ccod & "'"
	
	f_salida.AgregaCampoParam "tspl_ccod", "filtro", "tspl_ccod not in (" & SQL & ")"
	
else
	str_accion = "Editar"
	f_salida.AgregaCampoParam "tspl_ccod", "permiso", "LECTURA"
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
              <table width="98%"  border="0" align="center">
              <tr>
                <td><div align="center">
                  <%f_encabezado.DibujaRegistro%>
                </div></td>
              </tr>
            </table>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Salida"%>
                      <br>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><div align="center"><%f_salida.DibujaRegistro%></div></td>
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
                  <td><div align="center"><%f_botonera.DibujaBoton "siguiente" %></div></td>
                  <td><div align="center"><%f_botonera_g.DibujaBoton "cancelar" %></div></td>
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
