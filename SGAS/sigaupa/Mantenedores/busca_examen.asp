<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO:
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:15/01/2013
'ACTUALIZADO POR		:JAIME PAINEMAL A.
'MOTIVO			:Optimizar código, eliminar sentencia *=
'LINEA			:64
'********************************************************************
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Especialidades"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "busca_examen.xml", "botonera"

'-----------------------------------------------------------------------
carr_ccod = request.querystring("busqueda[0][carr_ccod]")
'response.Write(carr_ccod)
carrera = conexion.consultauno("SELECT carr_tdesc FROM carreras WHERE carr_ccod = '" & carr_ccod & "'")
'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "busca_examen.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 'if  EsVacio(carr_ccod) then
 ' 		f_busqueda.Agregacampoparam "carr_ccod", "filtro" , "1=2"
 'end if
 f_busqueda.AgregaCampoCons "carr_ccod", carr_ccod 
 f_busqueda.Siguiente
  
 'ultimo = carr_ccod

'---------------------------------------------------------------------------------------------------
set f_especialidades = new CFormulario
f_especialidades.Carga_Parametros "busca_examen.xml", "f_especialidades"
f_especialidades.Inicializar conexion
' consulta = "select a.carr_ccod, a.espe_ccod, b.TTIT_CCOD, b.ttit_tdesc, c.eesp_tdesc, a.espe_tdesc, a.espe_ttitulo, a.espe_nduracion "& vbCrLf &_
'			"from especialidades a, tipos_titulos b, estados_de_especialidad c "& vbCrLf &_
'			"where a.ttit_ccod *= b.ttit_ccod "& vbCrLf &_
'			"  and a.eesp_ccod = c.eesp_ccod "& vbCrLf &_
'			"  and carr_ccod = '" & carr_ccod & "' "& vbCrLf &_
'			"ORDER BY a.espe_fini_vigencia "

 consulta = "select a.carr_ccod, a.espe_ccod, b.TTIT_CCOD, b.ttit_tdesc, c.eesp_tdesc, a.espe_tdesc, a.espe_ttitulo, a.espe_nduracion "& vbCrLf &_
			"from especialidades a LEFT OUTER JOIN tipos_titulos b "& vbCrLf &_
			"  ON a.ttit_ccod = b.ttit_ccod "& vbCrLf &_
			"  INNER JOIN estados_de_especialidad c "& vbCrLf &_
			"  ON a.eesp_ccod = c.eesp_ccod "& vbCrLf &_
			"  WHERE carr_ccod = '" & carr_ccod & "' "& vbCrLf &_
			"ORDER BY a.espe_fini_vigencia "
'response.write("<pre>"&consulta&"</pre>")
f_especialidades.Consultar consulta

'---------------------------------------------------------------------------------------------------

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
  buscador.action="Especialidades.asp?busqueda[0][carr_ccod]=" + document.buscador.elements["busqueda[0][carr_ccod]"].value;
  buscador.method="POST";
  buscador.submit();
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
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                            <table width="100%" border="0">
                              <tr> 
                                <td width="32%"><div align="left">Carrera</div></td>
                                <td width="3%"><div align="center">:</div></td>
                                <td width="65%"><% f_busqueda.dibujaCampo ("carr_ccod") %></td>
                              </tr>
							  <tr> 
                                <td width="32%"><div align="left">Estado Examen Postulante</div></td>
                                <td width="3%"><div align="center">:</div></td>
                                <td width="65%"><% f_busqueda.dibujaCampo ("eepo_ccod") %></td>
                              </tr>
                            </table>
                          </div></td>
                  <td width="19%"><div align="center"><%botonera.DibujaBoton "buscar"%></div></td>
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
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center">
                     
                    <br>
                    <br><%pagina.DibujarSubtitulo carrera%>
                  
                  </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><div align="center"> 
                            <%pagina.DibujarTituloPagina%>
                            <br>
                            <table width="650" border="0">
                              <tr> 
                                <td width="116">&nbsp;</td>
                                <td width="511"><div align="right">P&aacute;ginas: 
                                    &nbsp; 
                                    <%f_especialidades.AccesoPagina%>
                                  </div></td>
                                <td width="24"> <div align="right"> </div></td>
                              </tr>
                            </table>                          
                            <%f_especialidades.DibujaTabla()%>
                          </div></td>
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
                  <td><div align="center"> 
                            <% if carr_ccod <> "" then
							      botonera.AgregaBotonParam "nueva" , "deshabilitado", "FALSE"
							   else
							     botonera.AgregaBotonParam "nueva" , "deshabilitado", "TRUE"
							   end if
							   botonera.AgregaBotonParam "nueva", "url", "Especialidades_Agregar.asp?carr_ccod=" & carr_ccod
							   botonera.DibujaBoton "nueva"
							%>
                          </div></td>
                  <td><div align="center">
                            <% if carr_ccod <> "" then
							      botonera.AgregaBotonParam "eliminar" , "deshabilitado", "FALSE"
							   else
							     botonera.AgregaBotonParam "eliminar" , "deshabilitado", "TRUE"
							   end if
							   botonera.DibujaBoton "eliminar"%>				  
                          </div></td>
                  <td><div align="center"><%botonera.DibujaBoton "lanzadera"%></div></td>
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
