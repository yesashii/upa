<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

pegr_ncorr = request.querystring("pegr_ncorr")
peri_ccod = request.querystring("peri_ccod")

if pegr_ncorr <> "" then
   pagina.Titulo = "Modificar período de egreso"
else
   pagina.Titulo = "Agregar período de egreso"
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
periodo = conexion.consultauno("SELECT peri_tdesc FROM periodos_academicos WHERE peri_ccod = '" & peri_ccod & "'")
'----------------------------------------------------------------
set f_nueva = new CFormulario
f_nueva.Carga_Parametros "periodos_egreso.xml", "f_nuevo"
f_nueva.Inicializar conexion
if pegr_ncorr = "" then
   consulta = "select '1' as epeg_ccod , '' as pegr_finicio, '' as pegr_ftermino, '" & peri_ccod & "' as peri_ccod"
   f_nueva.Consultar consulta
else
   consulta =   " select pegr_ncorr,peri_ccod,epeg_ccod," & vbCrlf & _
				" convert(varchar,pegr_finicio,103) as pegr_finicio,convert(varchar,pegr_ftermino,103) as pegr_ftermino " & vbCrlf & _
				" from pre_periodos_egreso " & vbCrlf & _
				" where cast(pegr_ncorr as varchar)='" & pegr_ncorr & "'"
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
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "periodos_egreso[0][pegr_finicio]","1","edicion","fecha_oculta_pegr_finicio"
	calendario.MuestraFecha "periodos_egreso[0][pegr_ftermino]","2","edicion","fecha_oculta_pegr_ftermino"
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
                <td><%pagina.DibujarLenguetas Array("Agregar Período Egreso"), 1 %></td>
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
  <tr> 
    <td width="16%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">Período</font></b></font></td>
    <td width="3%"><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">: 
        </font></b></font></div></td>
    <td width="81%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2"><%=periodo%></font></b></font></td>
  </tr>
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
                            <tr> 
                              <td>Período</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"> <%=periodo%> </td>
                            </tr>
							<tr> 
                              <td><font color="#CC3300">*</font> Estado período</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"> <% f_nueva.DibujaCampo "epeg_ccod"%> </td>
                            </tr>
                            <tr> 
                              <td>Fecha Inicio</td>
                              <td><div align="center">:</div></td>
                              <td width="24%" nowrap>
                                <% f_nueva.DibujaCampo "pegr_finicio"%>
								<%calendario.DibujaImagen "fecha_oculta_pegr_finicio","1","edicion" %>(dd/mm/yyyy)
                              </td>
                              <td>&nbsp;</td>
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td>Fecha Termino</td>
                              <td><div align="center">:</div></td>
                              <td nowrap><% f_nueva.DibujaCampo "pegr_ftermino"%>
							  	<%calendario.DibujaImagen "fecha_oculta_pegr_ftermino","2","edicion" %>(dd/mm/yyyy)
							  </td>
                              <td width="7%">&nbsp;</td>
                              <td width="43%">&nbsp;</td>
                            </tr>
						  </table>
                         </td>
                      </tr>
                    </table>
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
							  if pegr_ncorr <> "" then
							     botonera.agregaBotonParam "guardar_nueva", "url", "periodos_egreso_agregar_proc.asp?peri_ccod=" & peri_ccod & "&pegr_ncorr=" & pegr_ncorr
							  else
  							     botonera.agregaBotonParam "guardar_nueva", "url", "periodos_egreso_agregar_proc.asp?peri_ccod=" & peri_ccod
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
