<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Ingresa Valor Unidad de Fomento"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_fecha = Request.QueryString("fecha")

Longitud=Len(Request.QueryString("fecha"))
var1=Mid(Request.QueryString("fecha"),Longitud-3,4)


set f_botonera = new CFormulario
f_botonera.Carga_Parametros "mantener_ufomento.xml", "botonera"

v_valor_uf=conexion.ConsultaUno("select ufom_mvalor from uf where ufom_fuf='"&v_fecha&"'")

'response.Write(v_valor_uf)
'ufom_ncorr = conexion.ObtenerSecuencia("ufom_ncorr_seq")


set f_ufomvalor = new CFormulario
f_ufomvalor.Carga_Parametros "mantener_ufomento.xml", "ufomento"
f_ufomvalor.Inicializar conexion
f_ufomvalor. consultar "select ''"
f_ufomvalor.AgregaCampoCons "ufom_fuf" ,v_fecha

if v_valor_uf<>"" then
	v_valor_uf=replace(v_valor_uf,",",".")
	ufom_ncorr=conexion.ConsultaUno("select ufom_ncorr from uf where ufom_fuf='"&v_fecha&"'")
	f_ufomvalor.AgregaCampoCons "ufom_mvalor" ,v_valor_uf
	f_ufomvalor.AgregaCampoCons "ufom_ncorr" ,ufom_ncorr
response.Write("<hr>"&ufom_ncorr)
end if



'f_ufomvalor.siguiente
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
	<table width="50%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Agregar"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><br>
              <form name="ufomento">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Ingresar Valor de la UF para :" & v_fecha & ""%>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td></td>
                          <td>&nbsp;</td>
                          <td><%f_ufomvalor.DibujaRegistro%></td>
                          <td><h6><b>Ej (17090.20)</b></h6></td>
                          <td></td>
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
                  <td><div align="center"><%f_botonera.AgregaBotonParam "AGREGAR","url","../Mantenedores/proc_mantener_ufomento.asp?var="& var1 &"" 
				                            f_botonera.DibujaBoton "AGREGAR"%></div></td>
                  <td><div align="center"><%f_botonera.AgregaBotonParam "volver","url","../Mantenedores/mantener_uf.asp?b%5B0%5D%5Banos_ccod%5D="& var1 &"" 
				                            f_botonera.DibujaBoton "volver"%></div></td>
                  <td><div align="center"></div></td>
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
