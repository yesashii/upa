<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
uhciu_ccod = request.QueryString("UHCIU_CCOD")
nombre_ciudad=  request.QueryString("NOMBRE_CIUDAD")

'response.write "<pre>"&nom_carrera_ing&"</pre>"

set pagina = new CPagina
pagina.Titulo = "Mantenedor De Comunas Ingresa"

set botonera =  new CFormulario
botonera.carga_parametros "adm_comunas_ufe.xml", "btn_adm_comunas"
'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set errores = new CErrores
'---------------------------------------------------------------------------------------------------

consulta =  "  select UHCIU_CCOD, UHCIU_CCOD as eliminar ,CODIGO_REGION, NOMBRE_REGION,  " & vbCrlf & _
		    " CODIGO_COMUNA, NOMBRE_COMUNA, CODIGO_CIUDAD, NOMBRE_CIUDAD  " & vbCrlf & _
 			" from  ufe_ciudades" & vbCrlf & _
			" where NOMBRE_CIUDAD like '%"&nombre_ciudad&"%' " & vbCrlf & _	
			" order  by CODIGO_REGION" 
'response.write "<pre>"&consulta&"</pre>"
'response.End()			
set formulario 		= 		new cFormulario
formulario.carga_parametros	"adm_comunas_ufe.xml",	"tabla"
formulario.inicializar		conectar
formulario.consultar 		consulta
registros = formulario.nrofilas
'RESPONSE.end()
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

function enviar(formulario){
formulario.submit();
}
function agrega_carrera_antiguo(formulario){

	direccion="agregar_comunas_ufe.asp?car_ing_ncorr ="
	resultado=window.open(direccion, "ventana1","width=700,height=400,scrollbars=yes, left=0, top=0");
}
function agrega_carrera(formulario) {
	direccion = "agregar_comunas_ufe.asp";
	resultado=window.open(direccion, "ventana1","width=700,height=400,scrollbars=no, left=380, top=350");
	
 // window.close();
}


</script>

</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador" method="get">
              <table width="100%" border="0">
                <tr>
                  <td width="29%">
                      <div align="center">
                        &nbsp;&nbsp;&nbsp;&nbsp;</div></td>
                  <td width="39%">
                        <div align="center">
                          <input type="text" name="nombre_ciudad" size="30" maxlength="50" onKeyDown="return bloquearTeclas(event.keyCode,this)" onKeyUp="this.value=this.value.toUpperCase()" ID="TO-S" >
                          <br>
  Nombre Ciudad                        </div></td>
                  <td width="28%"><%botonera.dibujaboton "buscar"%></td>
                  <td width="4%" nowrap>&nbsp;</td>
                </tr>
              </table>
             
              </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	<br>
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
            <td><%pagina.DibujarLenguetas Array("Resultados de la b�squeda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                    <table width="650" border="0">
                      <tr> 
                        <td width="116">&nbsp;</td>
                        <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                            <%formulario.AccesoPagina%>
                          </div></td>
                        <td width="24"> <div align="right"> </div></td>
                      </tr>
                    </table>
                  </div>
              <form name="edicion">
			  <input name="registros" type="hidden" value="<%=registros%>">
                <div align="center"><%formulario.dibujatabla()%><br>
                </div>
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
                  <td><div align="center">
                    <%botonera.dibujaboton "AGREGAR"%>
                  </div></td>
                  <td><div align="center">
                    <%botonera.dibujaboton "eliminar"%>
                  </div></td>
				   
				  <td width="14%"> <div align="center">  <%
				                           botonera.agregabotonparam "excel_general", "url", "comunas_ingresa_excel.asp"
										   botonera.dibujaboton "excel_general"
										%>
					 </div>
                  </td>
                  <td><div align="center">
                    <%botonera.dibujaboton "SALIR"%>
                  </div></td>
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
