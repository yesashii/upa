<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "agregar permisos"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'---------------------------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Mant_Permisos.xml", "botonera"
'---------------------------------------------------------------------------------------------------
codigo_rol = request("codigo_rol")

set f2 = new CFormulario
f2.Carga_Parametros "Mant_Permisos.xml", "f2"
smod_ccod = request.Form("modulos[0][smod_ccod]")  'nombre de la variable
f2.Inicializar conexion
f2.Consultar "select ''  "
f2.AgregaCampoCons "smod_ccod", smod_ccod   'le agrego un campo a la consulta
f2.Siguiente
ultimo = smod_ccod
'----------------------------------------------------------------------------------------------------
set fx = new CFormulario
fx.Carga_Parametros "parametros.xml", "tabla"
fx.Inicializar conexion
'--------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "Mant_Permisos.xml", "f1"
formulario.Inicializar conexion
  if smod_ccod <> "" then  
	 'muestra todas las Funciones de un modulo X
	 'consulta = "SELECT  " &  codigo_rol & " as srol_ncorr, a.smod_ccod, b.smod_tdesc ,a.smod_ccod as c_smod_ccod, a.sfun_ccod, a.sfun_ccod as c_sfun_ccod , a.sfun_tdesc, 1 as smet_ccod FROM sis_funciones_modulos a , sis_modulos b WHERE a.smod_ccod = b.smod_ccod AND a.smod_ccod='" & smod_ccod & "' ORDER BY a.smod_ccod"
      'muestra solo las funciones de un modulo x que no tiene permiso
      consulta = "SELECT  " &  codigo_rol & " as srol_ncorr, a.smod_ccod, b.smod_tdesc, " &_
         "a.smod_ccod as c_smod_ccod, a.sfun_ccod, a.sfun_ccod as c_sfun_ccod , a.sfun_tdesc, " &_ 
         "1 as smet_ccod FROM sis_funciones_modulos a , sis_modulos b " &_  
         "WHERE a.smod_ccod = b.smod_ccod AND a.smod_ccod='" & smod_ccod & "' " &_ 
         "AND a.sfun_ccod not in (SELECT sfun_ccod FROM sis_permisos " &_
         "WHERE srol_ncorr = " &  codigo_rol & " AND  smod_ccod = '" & smod_ccod & "' ) ORDER BY a.sfun_tdesc "
  else
    'Funciones de todos los modulos
	'consulta = "SELECT  " &  codigo_rol & " as srol_ncorr, a.smod_ccod, b.smod_tdesc, a.smod_ccod as c_smod_ccod, a.sfun_ccod, a.sfun_ccod as c_sfun_ccod , a.sfun_tdesc, 1 as smet_ccod FROM sis_funciones_modulos a , sis_modulos b WHERE a.smod_ccod = b.smod_ccod ORDER BY a.smod_ccod"
    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    'la idea es que muestre solo las funciones q no tiene permiso
     C2 = "SELECT  " &  codigo_rol & " as srol_ncorr, a.smod_ccod, b.smod_tdesc, a.smod_ccod "&_
  	        "as c_smod_ccod, a.sfun_ccod, a.sfun_ccod as c_sfun_ccod , a.sfun_tdesc, 1 as smet_ccod "&_ 
	        "FROM sis_funciones_modulos a , sis_modulos b "&_
            "WHERE a.smod_ccod = b.smod_ccod "
	 cons = "SELECT smod_ccod, sfun_ccod FROM sis_permisos WHERE srol_ncorr  = " &  codigo_rol & " ORDER BY smod_ccod, sfun_ccod "
     fx.Consultar cons
     while fx.Siguiente
	   modulo = fx.ObtenerValor("smod_ccod")
	   funcion= fx.ObtenerValor("sfun_ccod")
       C2 = C2 + " AND NOT (a.smod_ccod = " & modulo & "  AND a.sfun_ccod = " & funcion & ") "
	wend
    C2 = C2 + "ORDER BY b.smod_tdesc, a.sfun_tdesc"
	consulta = C2
    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  end if
  formulario.Consultar consulta
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
function cargar()
{ 
  edicion.action=""
  edicion.method="POST";
  edicion.submit();
}
</script>
<style>
<!--

select {  
	font-family: Verdana, Arial, Helvetica, sans-serif; 
	font-size: 9px; 
	background-color: #FFFFFF
}

-->
</style>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    
  </tr>
  <%'pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<br>		
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Agregar
                          Permisos</font></div></td>
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
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  
                <td bgcolor="#D8D8DE"> <div align="center"><BR>
                    <%pagina.DibujarTituloPagina%>
                    <BR>
                  </div>
                  <form name="edicion">
                    <div align="center"> 
                      <table width="100%" border="0">
                        <tr>
                          <td width="27%"><div align="right"><strong>Listado de 
                              M&oacute;dulos</strong></div></td>
                          <td width="4%"><div align="center"><strong>:</strong></div></td>
                          <td width="69%">
                            <% f2.dibujaCampo ("smod_ccod")  'dibujo el objeto Select %>
                          </td>
                        </tr>
                      </table>
                   
                      <table width="100%" border="0">
                        <tr> 
                          <td width="283">&nbsp; </td>
                          <td width="347"><div align="right">P&aacute;ginas: &nbsp; 
                              <% formulario.AccesoPagina%>
                            </div></td>
                          <td width="26"> <div align="right"> </div></td>
                        </tr>
                      </table>
                      <p align="center">
                        <%pagina.DibujarSubtitulo "Listado de Funciones del Módulo"%>
                        <BR>
                        <%formulario.DibujaTabla%>
                      </p>
					</div>
				    </form>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="72" bgcolor="#D8D8DE"> 
                    <div align="left">                      <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="16%">
						  <%  'botonera.agregabotonparam "agregar", "url", "Proc_Mant_Permisos_Agregar.asp"
						     botonera.dibujaboton "guardar"  %>
</td>
                          <td width="84%"><% 'botonera.dibujaboton "cancelar"
						    botonera.dibujaboton "salir"%>
</td>
                        </tr>
                      </table>
                  </div></td>
                  <td width="290" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<p><br>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
