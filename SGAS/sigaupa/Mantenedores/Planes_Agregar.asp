<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

plan_ccod = request.querystring("plan_ccod")
espe_ccod = request.querystring("espe_ccod")

if plan_ccod <> "" then
   pagina.Titulo = "Modificar Plan de Estudio"
else
   pagina.Titulo = "Agregar Plan de Estudio"
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
especialidad = conexion.consultauno("SELECT espe_tdesc FROM especialidades WHERE espe_ccod = '" & espe_ccod & "'")
carrera = conexion.consultauno("SELECT carr_ccod FROM especialidades WHERE espe_ccod = '" & espe_ccod & "'")
carrera = conexion.consultauno("SELECT carr_tdesc FROM carreras WHERE carr_ccod = '" & carrera & "'")
'----------------------------------------------------------------
set f_nueva = new CFormulario
f_nueva.Carga_Parametros "Planes.xml", "f_nuevo"
f_nueva.Inicializar conexion
if plan_ccod = "" then
   consulta = "select '1' as eesp_ccod , '' as plan_fcreacion, '' as espe_tdesc, '' as espe_ttitulo, '" & carr_ccod & "' as carr_ccod, '' as plan_nresolucion"
   f_nueva.Consultar consulta
   fecha_sistema = conexion.consultauno("select convert(varchar,getdate(),103)")
   'response.write(fecha_sistema)
   f_nueva.AgregaCampoCons "plan_fcreacion", fecha_sistema
else
   consulta ="select plan_ccod,espe_ccod,epes_ccod,plan_tdesc,plan_ncorrelativo," & vbCrlf & _
				"convert(varchar,plan_fcreacion,103) as plan_fcreacion,isnull(incluir_mencion,'0') as incluir_mencion, nombre_mencion," & vbCrlf & _
				"convert(varchar,plan_ftermino,103) as plan_ftermino,plan_nresolucion, isnull(plan_tcreditos,'0') as plan_tcreditos, linea_1_certificado, linea_2_certificado, plan_duracion_semestres " & vbCrlf & _
				"from planes_estudio " & vbCrlf & _
				"where cast(plan_ccod as varchar)='" & plan_ccod & "'"
   f_nueva.Consultar consulta
end if
f_nueva.Siguiente

incluir_mencion = f_nueva.obtenerValor("incluir_mencion")
if incluir_mencion = "0" then
	f_nueva.agregaCampoParam "nombre_mencion","deshabilitado","true"
	f_nueva.agregaCampoParam "nombre_mencion","id","TO-S"
end if
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
function habilita (valor,formulario)
{
var nombre_mencion = MM_findObj('planes[0][nombre_mencion]', document);
	
 	if (valor){
		
        nombre_mencion.disabled = false; 
		nombre_mencion.id = "TO-N"; 
	 }
	 else
	 {
	 	nombre_mencion.disabled = true; 
		nombre_mencion.id = "TO-S";
	 }
}
</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "planes[0][plan_fcreacion]","1","edicion","fecha_oculta_plan_fcreacion"
	calendario.MuestraFecha "planes[0][plan_ftermino]","2","edicion","fecha_oculta_plan_ftermino"
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
                        <td><table width="100%" border="0">
                      <tr>
                        <td><table width="99%" border="0" align="left" cellpadding="0" cellspacing="0">
  <tr> 
    <td width="16%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">Carrera</font></b></font></td>
    <td width="3%"><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">: 
        </font></b></font></div></td>
    <td width="81%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2"><%=carrera%></font></b></font></td>
  </tr>
  <tr> 
    <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">Especialidad</font></b></font></td>
    <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">: 
        </font></b></font></div></td>
    <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2"><%=especialidad%></font></b></font></td>
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
                              <td><font color="#CC3300">*</font> Plan</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"> <% f_nueva.DibujaCampo "plan_tdesc"%> </td>
                            </tr>
							<tr> 
                              <td><font color="#CC3300">*</font> Estado plan estudio</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"> <% f_nueva.DibujaCampo "epes_ccod"%> </td>
                            </tr>
                            <tr> 
                              <td>Fecha Creaci&oacute;n</td>
                              <td><div align="center">:</div></td>
                              <td width="24%" nowrap>
                                <% f_nueva.DibujaCampo "plan_fcreacion"%>
								<%calendario.DibujaImagen "fecha_oculta_plan_fcreacion","1","edicion" %>(dd/mm/yyyy)
                              </td>
                              <td>&nbsp;</td>
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td>Fecha Termino</td>
                              <td><div align="center">:</div></td>
                              <td nowrap><% f_nueva.DibujaCampo "plan_ftermino"%>
							  	<%calendario.DibujaImagen "fecha_oculta_plan_ftermino","2","edicion" %>(dd/mm/yyyy)
							  </td>
                              <td width="7%">&nbsp;</td>
                              <td width="43%">&nbsp;</td>
                            </tr>
							<tr> 
                              <td><font color="#CC3300">*</font> Nro Resoluci&oacute;n</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"> <% f_nueva.DibujaCampo "plan_nresolucion"%> </td>
                            </tr>
							<tr> 
                              <td>Afecta Cr&eacute;ditos</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"> <% f_nueva.DibujaCampo "plan_tcreditos"%> 
											   <% f_nueva.DibujaCampo "incluir_mencion"%>
											   <% f_nueva.DibujaCampo "nombre_mencion"%> 
											   <% f_nueva.DibujaCampo "linea_1_certificado"%>
											   <% f_nueva.DibujaCampo "linea_2_certificado"%>
							  </td>
                            </tr>
							<tr> 
                              <td>Duración en Semestres</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"> <% f_nueva.DibujaCampo "plan_duracion_semestres"%> </td>
                            </tr>
                            <tr> 
                                <td colspan="5" align="center">&nbsp;</td>
                            </tr>
                            <!--<tr> 
                                <td colspan="5" align="center">
                                	<table width="90%" bgcolor="#FFFFCC" cellpadding="0" cellspacing="0" align="center">
                                    	<tr>
                                        	<td colspan="3" align="left"><font size="2" color="#0033CC"><strong>Información requerida para certificado de título</strong></font></td>
                                        </tr> 
                                        <tr>
                                        	<td width="10%" align="right"><strong>Línea 1</strong></td>
                                            <td width="1%"><strong>:</strong></td>
                                            <td  align="left"><font size="1"> Ej: ASISTENTE SOCIAL</font></td>
                                        </tr>
                                        <tr>
                                        	<td width="10%" align="right"><strong>*Línea 2</strong></td>
                                            <td width="1%"><strong>:</strong></td>
                                            <td  align="left"><font size="1"> Ej: MENCION FAMILIA</font></td>
                                        </tr> 
                                        <tr>
                                        	<td colspan="3" align="right"><font size="1">* Si el título es muy largo, dividir en las dos líneas</font></td>
                                        </tr>     
                                    </table>
                                </td>
                            </tr>-->
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
							  if plan_ccod <> "" then
							     botonera.agregaBotonParam "guardar_nueva", "url", "Proc_Planes_Agregar.asp?espe_ccod=" & espe_ccod & "&plan_ccod=" & plan_ccod
							  else
  							     botonera.agregaBotonParam "guardar_nueva", "url", "Proc_Planes_Agregar.asp?espe_ccod=" & espe_ccod
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
