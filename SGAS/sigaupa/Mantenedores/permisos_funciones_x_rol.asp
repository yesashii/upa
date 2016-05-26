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
botonera.Carga_Parametros "Mant_Permisos_OC.xml", "botonera"
'---------------------------------------------------------------------------------------------------

rusu_ccod=request.querystring("rusu_ccod")

descripcion= conexion.consultaUno("select '('+cast(rusu_tdesc as varchar)+')' from ocag_roles_usuarios where rusu_ccod="&rusu_ccod)

set f2 = new CFormulario
f2.Carga_Parametros "Mant_Permisos_OC.xml", "f2"
smod_ccod = 180  'nombre de la variable
f2.Inicializar conexion
f2.Consultar "select ''  "
f2.AgregaCampoCons "smod_ccod", smod_ccod   'Se agrega modulo de Ordenes de compra fijo
f2.Siguiente

'----------------------------------------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "Mant_Permisos_OC.xml", "f1"
formulario.Inicializar conexion
  if smod_ccod <> "" then  
	 'muestra todas las Funciones de un modulo X
      'muestra solo las funciones de un modulo x que no tiene permiso
      consulta = "SELECT  " &  rusu_ccod & " as rusu_ccod, b.smod_tdesc, " &_
         "a.smod_ccod as c_smod_ccod, a.sfun_ccod, a.sfun_ccod as c_sfun_ccod , a.sfun_tdesc, " &_ 
         "1 as smet_ccod FROM sis_funciones_modulos a , sis_modulos b " &_  
         "WHERE a.smod_ccod = b.smod_ccod AND a.smod_ccod='" & smod_ccod & "' " &_ 
         "AND a.sfun_ccod not in (SELECT sfun_ccod FROM ocag_permisos_funciones_rol " &_
         "WHERE rusu_ccod = " &  rusu_ccod & " ) ORDER BY a.sfun_tdesc "
  end if
  formulario.Consultar consulta


set f_asociadas = new CFormulario
f_asociadas.Carga_Parametros "Mant_Permisos_OC.xml", "asociadas"
f_asociadas.Inicializar conexion
  
sql_funciones= " select " &  rusu_ccod & " as rusu_ccod, a.sfun_ccod, a.sfun_ccod as codigo, sfun_tdesc as funcion "&_
				" from sis_funciones_modulos a,ocag_permisos_funciones_rol b "&_
				" where b.rusu_ccod=" &  rusu_ccod & " "&_
				" and a.sfun_ccod=b.sfun_ccod "

f_asociadas.Consultar sql_funciones  
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
    <td valign="top" bgcolor="#EAEAEA">
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
					<font color="#0033FF" size="+1"><%=descripcion%></font>
                  </div>
                  <form name="edicion">
                    <div align="center"> 
                      <table width="100%" border="0">
                        <tr>
                          <td width="27%"><div align="right"><strong>Modulo</strong></div></td>
                          <td width="4%"><div align="center"><strong>:</strong></div></td>
                          <td width="69%"><% f2.dibujaCampo ("smod_ccod")  'dibujo el objeto Select %></td>
                        </tr>
                      </table>

					  <p align="center">
                        <%pagina.DibujarSubtitulo "Funciones Asociadas"%>
                        <%f_asociadas.DibujaTabla%>
                      </p>
					  <div align="right"><%botonera.dibujaboton "eliminar"  %></div>
					  <br/>
					                     
						<div align="right">P&aacute;ginas: &nbsp;<% formulario.AccesoPagina%></div>
                      <p align="center">
                        <%pagina.DibujarSubtitulo "Listado de Funciones del Módulo"%>
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
