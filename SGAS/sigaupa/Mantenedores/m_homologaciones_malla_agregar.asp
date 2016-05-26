<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina

homo_ccod = request.querystring("homo_ccod")
'area_ccod = request.querystring("area_ccod")

if homo_ccod <> "" then
   pagina.Titulo = "Modificar Homologación"
else
   pagina.Titulo = "Agregar Homologación"
end if

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'----------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "m_homologaciones_malla.xml", "botonera"
'----------------------------------------------------------------
'area = conexion.consultauno("SELECT area_tdesc FROM areas_academicas WHERE area_ccod = '" & area_ccod & "'")
'facultad = conexion.consultauno("SELECT facu_ccod FROM areas_academicas WHERE area_ccod = '" & area_ccod & "'")
'facultad = conexion.consultauno("SELECT facu_tdesc FROM facultades WHERE facu_ccod = '" & facultad & "'")
'----------------------------------------------------------------
set f_nueva = new CFormulario
f_nueva.Carga_Parametros "m_homologaciones_malla.xml", "f_nuevo"
f_nueva.Inicializar conexion
if homo_ccod = "" then
   consulta = "select '' as thom_ccod,'' as esho_ccod "
   f_nueva.Consultar consulta
   'fecha_sistema = conexion.consultauno("select convert(varchar,getdate(),103)")
   'response.write(fecha_sistema)
   'f_nueva.AgregaCampoCons "plan_fcreacion", fecha_sistema
else
   consulta = " Select homo_nresolucion,protic.trunc(homo_fresolucion) as homo_fresolucion,esho_ccod,homo_ccod,thom_ccod " & vbCrLf &_
		      " from homologacion "	& vbCrLf &_					
			  " where homo_ccod ='" & homo_ccod & "'"
   f_nueva.Consultar consulta
end if
f_nueva.Siguiente
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
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>

<script language="JavaScript">
</script>
</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  
  <tr> 
    <td valign="top" bgcolor="#EAEAEA"> <br> <br> <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
        <tr> 
          <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
          <td height="8" background="../imagenes/top_r1_c2.gif"></td>
          <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
        </tr>
        <tr> 
          <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
          <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td><%pagina.DibujarLenguetas Array(pagina.Titulo), 1 %></td>
              </tr>
              <tr> 
                <td height="2" background="../imagenes/top_r3_c2.gif"></td>
              </tr>
              <tr> 
                <td><div align="center"><br>
                    <%pagina.DibujarTituloPagina%>
                    <br><BR>
                  </div>
				   
                  <form name="edicion">
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td><table width="100%" border="0">
                      <tr>
                        <td><table width="99%" border="0" align="left" cellpadding="0" cellspacing="0">
  <!--<tr> 
    <td width="16%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">Facultad</font></b></font></td>
    <td width="3%"><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">: 
        </font></b></font></div></td>
    <td width="81%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2"><%'=facultad%></font></b></font></td>
  </tr>
  <tr> 
    <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">&Aacute;rea</font></b></font></td>
    <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">: 
        </font></b></font></div></td>
    <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2"><%'=area%></font></b></font></td>
  </tr>-->
  <tr> 
    <td height="0" colspan="3"><font color="#666677"><img src="../imagenes/linea.gif" width="100%" height="9"></font></td>
  </tr>
</table></td>
                      </tr>
                    </table>
                          <table width="100%" border="0">
                            <tr> 
                              <td width="23%"><font color="#CC3300">*</font>Campos Obligatorios</td>
                              <td width="3%"><div align="center"></div></td>
                              <td colspan="3">&nbsp; </td>
                            </tr>
							<% if homo_ccod <> "" then%>
							<tr> 
                              <td>C&oacute;digo Homologaci&oacute;n</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"> <%= homo_ccod%><% f_nueva.DibujaCampo "homo_ccod"%> </td>
                            </tr>
							<%end if%>
							<tr> 
                              <td><font color="#CC3300">*</font> N&ordm; Resoluci&oacute;n</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"> <% f_nueva.DibujaCampo "homo_nresolucion"%> </td>
                            </tr>
							<tr> 
                              <td><font color="#CC3300">*</font> Fecha Resoluci&oacute;n</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"> <% f_nueva.DibujaCampo "homo_fresolucion"%> </td>
                            </tr>
                            <tr> 
                              <td><font color="#CC3300">*</font> Tipo Homologaci&oacute;n</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"> <% f_nueva.DibujaCampo "thom_ccod"%> </td>
                            </tr>
							<tr> 
                              <td><font color="#CC3300">*</font> Estado Homologaci&oacute;n</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"> <% f_nueva.DibujaCampo "esho_ccod"%> </td>
                            </tr>
                          </table>
                          <br></td>
                      </tr>
                    </table>
                    <br>
                  </form></td>
              </tr>
            </table></td>
          <td width="7" background="../imagenes/der.gif">&nbsp;</td>
        </tr>
        <tr> 
          <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
          <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="19%" height="20"><div align="center"> 
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td width="47%"><div align="center">
                            <%
							  if homo_ccod <> "" then
							     botonera.agregaBotonParam "guardar_nueva", "url", "Proc_homologaciones_malla_Agregar.asp?homo_ccod=" & homo_ccod
							  else
  							     botonera.agregaBotonParam "guardar_nueva", "url", "Proc_homologaciones_malla_Agregar.asp"
							  end if
							  botonera.dibujaBoton "guardar_nueva" %>
                          </div></td>
                        <td width="53%"><div align="center">
                            <%botonera.dibujaBoton "cancelar" %>
                          </div></td>
                      </tr>
                    </table>
                  </div></td>
                <td width="81%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
              </tr>
              <tr> 
                <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
              </tr>
            </table></td>
          <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
        </tr>
      </table>
      <br> </td>
  </tr>
</table>
</body>
</html>