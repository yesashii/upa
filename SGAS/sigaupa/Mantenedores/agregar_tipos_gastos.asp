<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Asociar tipos de gastos a perfil"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'---------------------------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "areas_gastos.xml", "botonera"
'---------------------------------------------------------------------------------------------------

pare_ccod=request.querystring("pare_ccod")

descripcion= conexion.consultaUno("select '('+cast(pare_tdesc as varchar)+')' from ocag_perfiles_areas where pare_ccod="&pare_ccod)

'----------------------------------------------------------------------------------------------------
set f_asociadas = new CFormulario
f_asociadas.Carga_Parametros "areas_gastos.xml", "gastos_asociados"
f_asociadas.Inicializar conexion
  
sql_gastos_asociados= " select a.pare_ccod,a.pare_tdesc, b.tgas_ccod, tgas_tdesc, tgas_cod_cuenta "&_ 
				" from ocag_perfiles_areas a, ocag_tipo_gasto_perfil b, ocag_tipo_gasto c "&_
				" where a.pare_ccod=b.pare_ccod "&_
				" and b.tgas_ccod=c.tgas_ccod "&_
				" and a.pare_ccod="&pare_ccod& " "&_
				" and isnull(c.etga_ccod,1) not in (3)  "&_
				" order by tgas_tdesc asc"
				

f_asociadas.Consultar sql_gastos_asociados  

'response.Write(sql_gastos_asociados)


set formulario = new CFormulario
formulario.Carga_Parametros "areas_gastos.xml", "tipos_gastos"
formulario.Inicializar conexion

      consulta = "select "&pare_ccod&" as pare_ccod, tgas_ccod, tgas_tdesc,tgas_cod_cuenta, tgas_nombre_cuenta "&_
	  			 "	from ocag_tipo_gasto "&_
				 " where isnull(etga_ccod,1) not in (3) "&_
				 " and tgas_ccod not in ( "&_
					"	select a.tgas_ccod from ocag_tipo_gasto_perfil a  "&_
					" 	where a.pare_ccod="&pare_ccod&" "&_
					"  )   "&_
					" order by tgas_tdesc asc"

'response.Write(consulta)

'response.Write(consulta)
formulario.Consultar consulta
'formulario.Siguiente



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
                          Permisos x Gastos</font></div></td>
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
					  <p align="center">
                        <%pagina.DibujarSubtitulo "Tipos de gastos asociadas"%>
						<div align="right">P&aacute;ginas: &nbsp;<% f_asociadas.AccesoPagina%></div>
                        <%f_asociadas.DibujaTabla%>
                      </p>
					  <div align="right"><%botonera.dibujaboton "eliminar_pare"  %></div>
					  <br/>
					                     
						<div align="right">P&aacute;ginas: &nbsp;<% formulario.AccesoPagina%></div>
                      <p align="center">
                        <%pagina.DibujarSubtitulo "Listado de tipos de gastos"%>
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
						  <%botonera.dibujaboton "guardar_pare" %>
</td>
                          <td width="84%"><%botonera.dibujaboton "salir_pare"%>
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
