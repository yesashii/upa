<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

inci_ccod = request.querystring("inci_ccod")

ya_grabado = 0
if inci_ccod <> "" then
   pagina.Titulo = "Editar Incidente"
   ya_grabado = 1
else
   pagina.Titulo = "Agregar Nuevo incidente"
end if

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'----------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Mantenedor_incidentes.xml", "botonera_editar"
'----------------------------------------------------------------
set f_nueva = new CFormulario
f_nueva.Carga_Parametros "mantenedor_incidentes.xml", "f_nuevo"
f_nueva.Inicializar conexion


if inci_ccod = "" then
	inci_ccod = conexion.consultaUno("select isnull(max(folio),499) + 1  from incidentes ")
	folio = inci_ccod
	inci_ccod = "INC0"&folio
	consulta= " Select '"&inci_ccod&"' as inci_ccod,"&folio&" as folio"
else
	consulta= " Select INCI_CCOD,protic.trunc(FECHA_INCIDENTE) as FECHA_INCIDENTE,HORA_INCIDENTE,INCIDENTE,SERV_CCOD,ERED_CCOD,CELE_CCOD,SOLUCION_PLANTEADA,STATUS_SOLUCION,"&_
			  "	isnull(PERSONAL_TECNICO,'')as personal_tecnico,protic.trunc(FECHA_SOLUCION) as FECHA_SOLUCION,HORA_SOLUCION,EINC_CCOD,isnull(PRIMERA_VEZ,'N'),isnull(INCIDENTE_MAYOR,'N'),OBSERVACIONES,FOLIO "&_
			  " FROM INCIDENTES where CAST(inci_ccod as varchar)='"&inci_ccod&"'"
end if
'response.Write(consulta)
f_nueva.consultar consulta
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
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "incidentes[0][fecha_incidente]","1","edicion","fecha_oculta_incidente"
	calendario.MuestraFecha "incidentes[0][fecha_solucion]","2","edicion","fecha_oculta_solucion"
	calendario.FinFuncion
	
%>
</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>
<table width="550" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  
  <tr> 
    <td valign="top" bgcolor="#EAEAEA"> <br> <br> <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
        <tr> 
          <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
          <td height="8" background="../imagenes/top_r1_c2.gif"></td>
          <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
        </tr>
        <tr valign="top"> 
          <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
          <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td><%pagina.DibujarLenguetas Array("Mantenedor de Incidentes"), 1 %></td>
              </tr>
              <tr> 
                <td height="2" background="../imagenes/top_r3_c2.gif"></td>
              </tr>
              <tr valign="top"> 
                <td><div align="center"><br>
                    <%pagina.DibujarTituloPagina%>
                    <br>
					</div>
				   
                  <form name="edicion">
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td>
                          <table width="100%" border="0">
							<tr> 
                              <td><strong>Cód.Interno</strong></td>
                              <td><div align="center">:</div></td>
                              <td width="74%" colspan="3"><font color="#990000" size="3"><strong><%=inci_ccod%></strong></font>
							     <%f_nueva.dibujaCampo("inci_ccod")%>
								 <%f_nueva.dibujaCampo("folio")%>
							  </td>
                            </tr>
							 <tr> 
                                <td width="24%">Día de incidente</td>
								<td width="2%"> <div align="center">:</div> </td>
								<td colspan="3"><%f_nueva.dibujaCampo("fecha_incidente")%>
								                <%calendario.DibujaImagen "fecha_oculta_incidente","1","edicion" %>(dd/mm/yyyy)
								</td>
                              </tr>
                            <tr> 
                              <td>Hora</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"><%f_nueva.dibujaCampo("hora_incidente")%> (16:20)</td>
                            </tr>
							<tr> 
                              <td>Incidente</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"><%f_nueva.dibujaCampo("incidente")%></td>
                            </tr>
							<tr> 
                              <td>Equipo</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"><%f_nueva.dibujaCampo("serv_ccod")%></td>
                            </tr>
							<tr> 
                              <td>Red</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"><%f_nueva.dibujaCampo("ered_ccod")%></td>
                            </tr>
							<tr> 
                              <td>Otro</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"><%f_nueva.dibujaCampo("cele_ccod")%></td>
                            </tr>
							<tr> 
                              <td>Solución planteada</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"><%f_nueva.dibujaCampo("solucion_planteada")%></td>
                            </tr>
							<tr> 
                              <td>Status solución</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"><%f_nueva.dibujaCampo("status_solucion")%></td>
                            </tr>
							<tr> 
                              <td>Personal ténico</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"><%f_nueva.dibujaCampo("personal_tecnico")%></td>
                            </tr>
							<tr> 
                                <td width="24%">Día de solución</td>
								<td width="2%"> <div align="center">:</div> </td>
								<td colspan="3"><%f_nueva.dibujaCampo("fecha_solucion")%>
								                <%calendario.DibujaImagen "fecha_oculta_solucion","2","edicion" %>(dd/mm/yyyy)
								</td>
                              </tr>
                            <tr> 
                              <td>Hora</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"><%f_nueva.dibujaCampo("hora_solucion")%> (16:40)</td>
                            </tr>
							<tr> 
                              <td>Estado Incidente</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"><%f_nueva.dibujaCampo("einc_ccod")%></td>
                            </tr>
							<tr> 
                              <td colspan="5" align="left">
							  	<table width="100%" cellpadding="0" cellspacing="0">
									<tr>
										<td width="3%" align="center"><%f_nueva.dibujaCampo("primera_vez")%></td>
										<td width="45%" align="left">¿Primera vez que ocurre?</td>
										<td width="4%" align="left">&nbsp;</td>
										<td width="3%" align="center"><%f_nueva.dibujaCampo("incidente_mayor")%></td>
										<td width="45%" align="left">¿Parte de incidente mayor?</td>
									</tr>
								</table>
							  </td>
                            </tr>
							<tr valign="top"> 
                              <td>Comentarios</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"><%f_nueva.dibujaCampo("observaciones")%></td>
                            </tr>
							<tr><td colspan="5">&nbsp;</td></tr>
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
                        <td width="33%"><div align="center">
                            <% 'if ya_grabado <> 1 then
							     botonera.agregaBotonParam "guardar_nueva", "url", "proc_mantenedores_incidentes_editar.asp"
							     botonera.dibujaBoton "guardar_nueva" 
							   'end if%>
                          </div></td>
                        <td width="33%"><div align="center">
                            <%botonera.dibujaBoton "cancelar" %>
                          </div></td>
						<td width="34%">&nbsp;</td>  
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
