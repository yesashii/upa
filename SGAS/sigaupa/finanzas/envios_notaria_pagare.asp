<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina

set f_busqueda = new CFormulario
set conexion = new CConexion
set botonera = new CFormulario
set negocio = new CNegocio

conexion.Inicializar "upacifico"
negocio.Inicializa conexion
'-----------------------------------------------------------------------
pagina.Titulo = "Envíos Pagare UPA a Notaria"

'-----------------------------------------------------------------------
botonera.Carga_Parametros "envios_notaria_pagare.xml", "btn_envios_pagare"

 folio = request.querystring("busqueda[0][envi_ncorr]")
 notaria = request.querystring("busqueda[0][inen_ccod]")
 fecha = request.querystring("busqueda[0][envi_fenvio]")

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "envios_notaria_pagare.xml", "busqueda_envios"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente

 f_busqueda.AgregaCampoCons "envi_ncorr", folio
 f_busqueda.AgregaCampoCons "inen_ccod", notaria
 f_busqueda.AgregaCampoCons "envi_fenvio", fecha
' f_busqueda.AgregaCampoCons "pers_nrut", rut_alumno
' f_busqueda.AgregaCampoCons "pers_xdv", rut_alumno_digito
' f_busqueda.AgregaCampoCons "code_nrut", rut_apoderado
' f_busqueda.AgregaCampoCons "code_xdv", rut_apoderado_digito

Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")

'---------------------------------------------------------------------------------------------------
set f_listado = new CFormulario
f_listado.Carga_Parametros "envios_notaria_pagare.xml", "f_listado"
f_listado.Inicializar conexion

	   

sql_listado = "SELECT e.tenv_ccod,"& vbCrLf &_
			  "       ei.tine_ccod,"& vbCrLf &_
			  "       E.envi_ncorr,"& vbCrLf &_
			  "       ev.eenv_tdesc,"& vbCrLf &_
			  "       ei.inen_tdesc,"& vbCrLf &_
			  "       e.envi_fenvio,"& vbCrLf &_
			  "       e.inen_ccod,"& vbCrLf &_
			  "       protic.Cantidad_documentos_envio(E.envi_ncorr) AS cant_doc"& vbCrLf &_
			  "FROM   envios e"& vbCrLf &_
			  "       INNER JOIN instituciones_envio ei"& vbCrLf &_
			  "               ON e.inen_ccod = ei.inen_ccod"& vbCrLf &_
			  "                  AND ei.tine_ccod = 2"& vbCrLf &_
			  "       INNER JOIN estados_envio ev"& vbCrLf &_
			  "               ON ev.eenv_ccod = e.eenv_ccod"& vbCrLf &_
			  "WHERE e.TENV_CCOD=3"
			  
			if notaria <> "" then 
				sql_listado = sql_listado & " AND ei.inen_ccod =" & notaria
			end if
			if folio <> "" then 
				sql_listado = sql_listado & " AND e.envi_ncorr =" & folio
			end if
			if fecha<> "" then 
				sql_listado = sql_listado & " AND e.envi_fenvio ='" & fecha & "'"
			end if
			 sql_listado = sql_listado &" ORDER  BY e.ENVI_FENVIO, ev.eenv_tdesc DESC "


'response.Write("<pre>"&sql_listado&"</pre>")
'response.End()
f_listado.Consultar sql_listado

'---------------------------------------------------------------------------------------------------
'set botonera = new CFormulario
'botonera.Carga_Parametros "Envios_Notaria.xml", "botonera"
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


function abrir()
 { 
  location.reload("Envios_Cobranza_Agregar1.asp") 
 }
</script>

<script language='javaScript1.2'> 
  colores = Array(3);
  colores[0] = ''; 
  colores[1] = '#97AAC6'; 
  colores[2] = '#C0C0C0'; 
</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "busqueda[0][envi_fenvio]","1","buscador","fecha_oculta_enpa_fenvio"
	calendario.FinFuncion
%>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
            <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
            <tr>
              <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="15" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="282" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador 
                          Env&iacute;os de Pagare UPA a Notaria</font></div></td>
                    <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="363" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                  </tr>
              </table></td>
              <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>              
            </tr>
            <tr>
              <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
          </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"><div align="center">
				<form name="buscador" >
                      <table width="98%"  border="0">
                        <tr> 
                          <td width="81%"><table width="524" border="0">
                              <tr> 
                                <td width="86" height="20">N&ordm; Folio</td>
                                <td width="17">:</td>
                                <td width="151">
                                  <% f_busqueda.DibujaCampo("envi_ncorr") %>
                                </td>
                                <td width="93">Fecha</td>
                                <td width="12">:</td>
                                <td width="139">
                                  <% f_busqueda.dibujaCampo ("envi_fenvio")%>
								  <%calendario.DibujaImagen "fecha_oculta_enpa_fenvio","1","buscador" %>(dd/mm/aaaa)
                                </td>
                              </tr>
                              <tr> 
                                <td>Notar&iacute;a</td>
                                <td>:</td>
                                <td>
                                  <% f_busqueda.dibujaCampo ("inen_ccod") %>
                                </td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                              </tr>
                            </table></td>
                          <td width="19%"><div align="center">
                              <%botonera.DibujaBoton "buscar" %>
							  <%botonera.DibujaBoton "resetear" %>
                            </div></td>
                        </tr>
                      </table>
                    </form>
                </div></td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>			
          </td>
      </tr>
    </table>	
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
            <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
            <tr>
              <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="281" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Listado 
                          de Env&iacute;os de Pagare UPA a Notaria</font></div>
                    </td>
                    <td width="376" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                  </tr>
                </table>
              </td>
              <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
            </tr>
          </table>
		  
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"> <div align="center">&nbsp; <br>
                    <%pagina.DibujarTituloPagina%>
                    <br>
                  </div>
                  <table width="665" border="0">
                    <tr> 
                      <td width="116">&nbsp;</td>
                      <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                          <%f_listado.AccesoPagina%>
                        </div></td>
                      <td width="24"> <div align="right"> </div></td>
                    </tr>
                  </table> 
                  <form name="edicion">
				  <table width="100%" cellspacing="0" cellpadding="0">
                    <tr>
                      <td><div align="center"> 
                            <% f_listado.DibujaTabla %>
                          </div></td>
                    </tr>
                  </table> 
                  </form>
                    <br>
                </td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                <td width="335" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td><div align="center"> 
                          <%botonera.DibujaBoton "agregar" %>
                        </div></td>
                      <td><div align="center"> 
					  <% if ( f_listado.nrofilas >0) then 
						      botonera.AgregaBotonParam "enviar_folio","deshabilitado","FALSE"
							  
						  else 
						      botonera.AgregaBotonParam "enviar_folio","deshabilitado","TRUE"
						  end if 
						  %>
                          <%
						   botonera.agregabotonparam "enviar_folio", "url", "proc_Envios_Notaria.asp"
						   botonera.dibujaboton "enviar_folio" %>
                        </div></td>
                      <td align="center" valign="middle"> 
					  <% if ( f_listado.nrofilas >0) then 
						      botonera.AgregaBotonParam "eliminar","deshabilitado","FALSE"
							  
						  else 
						      botonera.AgregaBotonParam "eliminar","deshabilitado","TRUE"
						  end if 
						  %>
					    <% botonera.agregabotonparam "eliminar", "url", "Proc_Emp_Notaria_Eliminar_Pagare.asp"
						     botonera.dibujaboton "eliminar"%>
                        
                      </td>
                      <td><div align="center"> 
                          <%botonera.DibujaBoton "salir" %>
                        </div></td>
                    </tr>
                  </table>
                  
                </td>
                <td width="27" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
              </tr>
              <tr>
                <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
              </tr>
            </table>
        </td>
      </tr>
    </table>
	<p>&nbsp;</p></td>
  </tr>  
</table>
</body>
</html>