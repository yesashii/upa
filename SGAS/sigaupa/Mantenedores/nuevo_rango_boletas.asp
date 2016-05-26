<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Ingreso nuevo rango"
'-----------------------------------------------------------------------

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_sede_ccod = request.querystring("sede_ccod")
v_tbol_ccod = request.querystring("tbol_ccod")
v_inst_ccod = request.querystring("inst_ccod")
set errores = new CErrores
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "numeros_boletas_venta.xml", "botonera"
'-----------------------------------------------------------------------

set f_contrato = new CFormulario
f_contrato.Carga_Parametros "numeros_boletas_venta.xml", "nuevo_rango"
f_contrato.Inicializar conexion
f_contrato.Consultar "select ''"
f_contrato.Siguiente

 f_contrato.AgregaCampoCons "sede_ccod", v_sede_ccod
 f_contrato.AgregaCampoCons "tbol_ccod", v_tbol_ccod
 f_contrato.AgregaCampoCons "inst_ccod", v_inst_ccod   
'--------------------------------------------------------------------

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

function Guardar_Nuevo_Rango(form){
//alert();
//return false;
mensaje="Guardar";
	if (preValidaFormulario(form)){
		
			return true;
		
	}	
	return false;
} 

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="500" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<br>		
	<table width="450" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="100%" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td width="9"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="100%" height="8" border="0" alt=""></td>
              <td width="7"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>			  
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td bgcolor="#D8D8DE">
				<%pagina.DibujarLenguetas Array("Ingresar nuevo rango boletas"), 1 %>				
				</td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="100%" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>			 
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">&nbsp;<div align="center"><%pagina.DibujarTituloPagina%></div>
				  <%pagina.DibujarSubtitulo "Datos rango boletas"%><br>
				  <form name="edicion">
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
                          <tr>
							<td width="27%" >Tipo Boleta</td>
							<td width="73%" ><% f_contrato.DibujaCampo ("tbol_ccod") %></td>
					  </tr>
							<tr>
							<td >Sede</td>
							<td ><% f_contrato.DibujaCampo ("sede_ccod") %></td>
                          </tr>
						  
						  <tr>
							  <td>Empresa</td>
							  <td><% f_contrato.DibujaCampo ("inst_ccod") %></td>
					  </tr>
						  
					<tr>
							  <td>Boleta Inicio</td>
							  <td><% f_contrato.DibujaCampo ("rbol_ninicio") %></td>
					  </tr>
							<tr>
							  <td>Boleta Fin</td>
							  <td><% f_contrato.DibujaCampo ("rbol_nfin") %></td>
					  </tr>
                    </table>
		
                  </form>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="198" bgcolor="#D8D8DE">
				  <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="20%"> <div align="left"><%botonera.DibujaBoton ("guardar_nuevo")%></div></td>
                      <td width="49%"> <div align="left"><%botonera.DibujaBoton ("cancelar")%></div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>			
		  </td>
        </tr>
      </table>	
</td>
  </tr>  
</table>
</body>
</html>
