<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Administrador de Centros de Costo"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "adm_centros_costo.xml", "botonera"


v_nombre_cc = request.QueryString("nombre_cc")
v_codigo_cc = request.QueryString("codigo_cc")
v_codigo_compuesto = request.QueryString("cod_compuesto")

set errores = new CErrores
'---------------------------------------------------------------------------------------------------
set f_centros_costo = new CFormulario
f_centros_costo.Carga_Parametros "adm_centros_costo.xml", "centros_costo"
f_centros_costo.Inicializar conexion

consulta = "select a.ccos_ccod, a.ccos_ccod as c_ccos_ccod, a.ccos_tdesc, a.ccos_tcodigo,a.ccos_tcompuesto " & vbCrLf &_
           "from centros_costo a " & vbCrLf &_
		   "Where a.ccos_tcodigo like '%"&v_codigo_cc&"%'"& vbCrLf &_
		    "and a.ccos_tcompuesto like '%"&v_codigo_compuesto&"%' "& vbCrLf &_
		   "and a.ccos_tdesc like '%"&v_nombre_cc&"%' "& vbCrLf &_
		   "order by a.ccos_tdesc asc"
		   
f_centros_costo.Consultar consulta

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

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
                  <td width="20%">
                      <div align="center"> &nbsp;&nbsp;&nbsp;&nbsp;
                            <input type="text" name="codigo_cc" value="<%=v_codigo_cc%>" size="15" maxlength="6" onKeyDown="return bloquearTeclas(event.keyCode,this)" onKeyUp="this.value=this.value.toUpperCase()" ID="TO-S" >
							Codigo C.C. </div></td>
                  <td width="27%">
                        <div align="center">
                          <input type="text" name="cod_compuesto" value="<%=v_codigo_compuesto%>" size="15" maxlength="8" onKeyDown="return bloquearTeclas(event.keyCode,this)" onKeyUp="this.value=this.value.toUpperCase()" ID="TO-S" >
                          <br>
                            Cod. compuesto </div></td>
							<td width="31%"><div align="center">
                          <input type="text" name="nombre_cc" value="<%=v_nombre_cc%>" size="30" maxlength="50" onKeyDown="return bloquearTeclas(event.keyCode,this)" onKeyUp="this.value=this.value.toUpperCase()" ID="TO-S" >
                          <br>
                            Descripcion C.C. </div></td>
                  <td width="21%" align="center"><%f_botonera.dibujaboton "buscar"%></td>
                  <td width="1%" nowrap>&nbsp;</td>
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
            <td><%pagina.DibujarLenguetas Array("Administrador de Centros de Costo"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Centros de Costo"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="right">P&aacute;ginas : 
                              <%f_centros_costo.AccesoPagina%>
                              <br>
                          </div></td>
                        </tr>
                        <tr>
                          <td><div align="center"><%f_centros_costo.DibujaTabla%></div></td>
                        </tr>
                        <tr>
                          <td><div align="center"><br>
                            <%f_centros_costo.Pagina%></div></td>
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
                  <td><div align="center"><%f_botonera.DibujaBoton "agregar"%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton "eliminar"%>
                  </div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton "salir"%>
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
