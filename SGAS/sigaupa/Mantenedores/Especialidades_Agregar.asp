<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

carr_ccod = request.querystring("carr_ccod")
espe_ccod = request.querystring("espe_ccod")

if espe_ccod <> "" then
   pagina.Titulo = "Modificar Especialidad"
else
   pagina.Titulo = "Agregar Especialidad"
end if

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'----------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Especialidades.xml", "botonera"
'----------------------------------------------------------------



carrera = conexion.consultauno("SELECT carr_tdesc FROM carreras WHERE carr_ccod = '" & carr_ccod & "'")
'----------------------------------------------------------------
set f_nueva = new CFormulario
f_nueva.Carga_Parametros "Especialidades.xml", "f_nueva"
f_nueva.Inicializar conexion
if espe_ccod = "" then
   consulta = "select '' as eesp_ccod , '' as espe_tdesc, '' as espe_ttitulo, '" & carr_ccod & "' as carr_ccod"
else
   valor = conexion.consultaUno("select espe_bexamen_adm  from especialidades where espe_ccod ='" & espe_ccod & "'")
   if valor <> "" then
      valor = "1"
   end if
   consulta = "select espe_ccod, ttit_ccod, carr_ccod, eesp_ccod, espe_tdesc, convert(varchar,espe_fini_vigencia,103) as espe_fini_vigencia, espe_ttitulo, espe_nduracion, '" & valor & "' as espe_bexamen_adm  from especialidades where espe_ccod ='" & espe_ccod & "'"
end if
f_nueva.Consultar consulta
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
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "especialidades[0][espe_fini_vigencia]","1","edicion","fecha_oculta_espe_fini_vigencia"
	calendario.FinFuncion
	
%>


</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>
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
                <td><%pagina.DibujarLenguetas Array("Agregar Especialidad"), 1 %></td>
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
                        <td><%pagina.DibujarSubtitulo carrera %>
						<font color="#CC3300">*</font>Campos Obligatorios
                          <table width="100%" border="0">
                            <tr> 
                              <td width="21%">&nbsp;</td>
                              <td width="5%"><div align="center"></div></td>
                              <td colspan="3">
                                <%'=carrera%>
                              </td>
                            </tr>
                            <tr> 
                              <td><font color="#CC3300">*</font> Especialidad</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"> 
                                <% f_nueva.DibujaCampo "espe_tdesc"%>
                                <% f_nueva.DibujaCampo "carr_ccod"%>
                              </td>
                            </tr>
                            <tr> 
                              <td><font color="#CC3300">*</font> Titulo</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"> 
                                <% f_nueva.DibujaCampo "ttit_ccod"%>
                              </td>
                            </tr>
                            <tr> 
                              <td>Ex&aacute;men de Admisi&oacute;n</td>
                              <td><div align="center">:</div></td>
                              <td width="19%">
                                <% f_nueva.dibujaCampo "espe_bexamen_adm" %>
								<% f_nueva.DibujaCampo "espe_nduracion"%>
                               </td>
                              <td width="20%">&nbsp;</td>
                              <td width="35%">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td><font color="#CC3300">*</font> Titulo Especialidad</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3">
                                <%f_nueva.DibujaCampo "espe_ttitulo"%>
                              </td>
                            </tr>
							<tr> 
                              <td><font color="#CC3300">*</font> Estado</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3">
                                <% f_nueva.DibujaCampo "eesp_ccod" %>
                              </td>
                            </tr>
                            <tr> 
                              <td>Fecha Inicio Vigencia</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3">
                                <% f_nueva.DibujaCampo "espe_fini_vigencia" %>
                                <%calendario.DibujaImagen "fecha_oculta_espe_fini_vigencia","1","edicion" %>
                                (dd/mm/yyyy) </td>
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
							botonera.agregaBotonParam "guardar_nueva", "url", "Proc_Especialidades_Agregar.asp?espe_ccod=" & espe_ccod & ""
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
