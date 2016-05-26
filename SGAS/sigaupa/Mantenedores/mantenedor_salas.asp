<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Mantenedor De Salas"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores = new CErrores
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "adm_salas.xml", "botonera"
'---------------------------------------------------------------------------------------------------

set f_salas	 		=	new cformulario
f_salas.carga_parametros 	"adm_salas.xml", "adm_salas"
f_salas.inicializar			conexion

sede_ccod = negocio.obtenersede

'Sql_sala = " select sala_ccod, "&vbCrlf & _
'		   " decode(sala_tdesc,'','Sin descripción',sala_tdesc)as sala_tdesc, "&vbCrlf &_
'		   " sala_ciso,decode(sala_ncupo,'','--',sala_ncupo) as sala_ncupo, "&vbCrlf & _
'		   " to_char(sala_fini_vigencia,'dd/mm/yyyy') as sala_fini_vigencia, "&vbCrlf & _
'		   " decode(to_char(sala_ffin_vigencia,'dd/mm/yyyy'),'','Sin fecha termino vigencia',to_char(sala_ffin_vigencia,'dd/mm/yyyy')) "&vbCrlf & _
'		   " as sala_ffin_vigencia "&vbCrlf & _
'		   " from salas  "&vbCrlf & _
'		   " where sede_ccod='"&sede_ccod&"' " 

Sql_sala= "select sala_ccod, "&vbCrlf & _ 
          " case sala_tdesc when '' then 'Sin descripción' else sala_tdesc end as sala_tdesc,"&vbCrlf & _
          " sala_ciso,"&vbCrlf & _
     	  " case cast(sala_ncupo as varchar) when '' then '--' else sala_ncupo end  as sala_ncupo,"&vbCrlf & _
          " convert(varchar,sala_fini_vigencia,103) as sala_fini_vigencia,"&vbCrlf & _ 
          " case convert(varchar,sala_ffin_vigencia,103) when '' then 'Sin fecha termino vigencia'"&vbCrlf & _
          " else convert(varchar,sala_ffin_vigencia,103) end  "&vbCrlf & _
          " as sala_ffin_vigencia"&vbCrlf & _ 
          " from salas"&vbCrlf & _
          " where cast(sede_ccod as varchar)='"&sede_ccod&"' " 		   

'response.Write("<pre>"&Sql_sala&"</pre>")
'response.End()
f_salas.consultar	Sql_sala 


SubTitulo = "Lista De Salas De La Sede : "&conexion.consultauno("select sede_tdesc from sedes where cast(sede_ccod as varchar) = '"&sede_ccod&"'")

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
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Lista De Salas"), 1 %></td>
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
                    <td><%pagina.DibujarSubtitulo SubTitulo %>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"></div></td>
                        </tr>
                        <tr>
                          <td><div align="right">P&aacute;ginas :<%f_salas.accesopagina%> </div></td>
                        </tr>
                        <tr>
                          <td><div align="center">
                          </div>
                            <div align="center"></div></td>
                        </tr>
                        <tr>
                          <td><div align="center">
                                <%f_salas.dibujatabla()%>
                          </div></td>
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
                  <td><div align="center"><%f_botonera.DibujaBoton("agregar")%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("eliminar")%>
                  </div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("salir")%>
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
