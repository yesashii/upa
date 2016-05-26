<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%

v_rut_origen 	= request.QueryString("rut")
v_area_origen 	= request.QueryString("cod_area")
v_opcion    	= request.QueryString("opcion")



if v_opcion="" then
	v_opcion=1
end if

set pagina = new CPagina
pagina.Titulo = "Asignar area presupuestal"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set conexion2 = new CConexion2
conexion2.Inicializar "upacifico"

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "asigna_area_presupuesto.xml", "botonera"


if v_rut_origen <>"" then
	sql_de_rut	=	"select pers_xdv from personas where pers_nrut="&v_rut_origen
	pers_xdv	= 	conexion.consultaUno(sql_de_rut)
end if
'---------------------------------------------------------------------------------------------------

'--------------------------------------------fin seleccion combos carreras--------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "asigna_area_presupuesto.xml", "busqueda"
f_busqueda.Inicializar conexion2
f_busqueda.Consultar "Select ''"
f_busqueda.siguienteF

f_busqueda.AgregaCampoCons "area_ccod", v_area_origen 
f_busqueda.AgregaCampoCons "pers_nrut", v_rut_origen 
f_busqueda.AgregaCampoCons "pers_xdv", pers_xdv
'---------------------------------------------------------------------------------------------------------
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

function enviar(formulario)
{
	document.buscador.method="get";
	document.buscador.action="asigna_centros_costos.asp";
	document.buscador.submit();
}


function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if%>
}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="540" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
  
    <td valign="top" bgcolor="#EAEAEA">
	<form name="buscador">
	<input type="hidden" name="opcion" value="<%=v_opcion%>">
	<input type="hidden" name="rut_origen" value="<%=v_rut_origen%>">
	<input type="hidden" name="area_origen" value="<%=v_area_origen%>">
	<br>
	<table width="97%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
              
			  <table width="99%"  border="0" cellspacing="0" cellpadding="0" >
                  <tr>
				  		<td><%pagina.DibujarSubtitulo "Titulo"%></td>
				  </tr>
				  <tr>
				  		<td align="center">
							<table width="98%" height="98%" >
								  <tr>
									<td><div align="left"><strong>Areas disponibles </strong></div></td>
									<td width="20"><div align="center">:</div></td>
									<td><%f_busqueda.DibujaCampo("area_ccod")%></td>
								  </tr>
								  <tr>
									<td width="107"><div align="left"><strong>Rut Usuario </strong></div></td>
									    <td width="20"><div align="center">:</div></td>
									<td width="548"><%f_busqueda.DibujaCampo("pers_nrut")%>-<%f_busqueda.DibujaCampo("pers_xdv")%></td>
								  </tr>
							</table>  
						<br/>
						</td>
				  </tr>
				  <tr>
				  <td></td>
				  </tr>
				 </table> 
            </td></tr>
        </table>
		</td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="9%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
					<td><div align="left"><%f_botonera.DibujaBoton("guardar")%></div></td>
                  	<td><div align="left"><%f_botonera.DibujaBoton("cerrar")%></div></td>
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
	<br></form>
	</td>
	
  </tr>  
</table>
</body>
</html>
