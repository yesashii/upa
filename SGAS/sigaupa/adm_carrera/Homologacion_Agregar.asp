<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

nombre_asig = request.querystring("busqueda[0][nombre_asig]")
codigo_asig = request.QueryString("busqueda[0][codigo_asig]")
homo_ccod = request.QueryString("homo_ccod")
destino = request.QueryString("destino")

set pagina = new CPagina
if homo_ccod = "NUEVA" then
  pagina.Titulo = "Agregar Homologacion"
  leng1="Detalle Homologacion"
else
  pagina.Titulo = "Agregar Asignaturas a la Homologacion"
  leng1=array("Detalle Homologacion","Homologacion_Editar.asp?homo_ccod=" & homo_ccod)
end if

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------

set botonera =  new CFormulario
botonera.carga_parametros "editar_malla.xml", "btn_edita_malla"


set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "editar_malla.xml", "f_busqueda_asignaturas"
f_busqueda.Inicializar conexion
f_busqueda.consultar "select 1 as nose from dual where 1=2"
f_busqueda.agregacampocons "nombre_asig" , nombre_asig
f_busqueda.agregacampocons "codigo_asig" , codigo_asig
f_busqueda.siguiente

'------------------------------------------------------------------
set f_asignaturas = new CFormulario
f_asignaturas.Carga_Parametros "editar_malla.xml", "f_asignaturas_encontradas"
f_asignaturas.Inicializar conexion

 consulta = "SELECT distinct a.ASIG_CCOD, a.ASIG_CCOD as c_asig_ccod, a.ASIG_TDESC, '" & homo_ccod & "' as homo_ccod, '"&destino&"' as destino "&_ 
			"FROM asignaturas a "			
			
			 if codigo_asig <> "" then
			   consulta =  consulta & "WHERE a.asig_ccod = '" & codigo_asig & "' "
			   if nombre_asig <> "" then
			   	  consulta =  consulta & "and a.asig_tdesc like '" & nombre_asig & "%' "				
			   end if
			 else
			    if nombre_asig <> "" then
			        consulta =  consulta & "WHERE a.asig_tdesc like '" & nombre_asig & "%' "
				else
				    consulta = consulta & "WHERE 1=2 "
					f_asignaturas.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
				end if
			  end if


			consulta =  consulta & "order by a.asig_tdesc "
f_asignaturas.consultar consulta

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
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
    <td valign="top" bgcolor="#EAEAEA"> <br> <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
        <tr> 
          <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
          <td height="8" background="../imagenes/top_r1_c2.gif"></td>
          <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
        </tr>
        <tr> 
          <td width="9" background="../imagenes/izq.gif"></td>
          <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td>
                  <%pagina.dibujarLenguetas array (leng1,array("Búsqueda de Asignaturas","Homologacion_Agregar.asp?homo_ccod="& homo_ccod)),2 %>
                </td>
              </tr>
              <tr> 
                <td height="2" background="../imagenes/top_r3_c2.gif"></td>
              </tr>
              <tr> 
                <td><form name="buscador">
                    <br>
                    <table width="98%"  border="0" align="center">
                      <tr> 
                        <td width="82%"><div align="center"> 
                            <table width="100%" border="0">
                              <tr> 
                                <td width="40%"><div align="center"> 
                                    <%f_busqueda.DibujaCampo "codigo_asig"%>
                                  </div></td>
                                <td width="9%"><input type="hidden" name="homo_ccod" value="<%=homo_ccod%>">
                                  <input type="hidden" name="destino" value="<%=destino%>"></td>
                                <td width="42%"> <div align="center"> 
                                    <%f_busqueda.DibujaCampo "nombre_asig"%>
                                  </div></td>
                              </tr>
                              <tr> 
                                <td><div align="center">C&oacute;digo Asignatura</div></td>
                                <td>&nbsp;</td>
                                <td><div align="center">Nombre Asignatura</div></td>
                              </tr>
                            </table>
                          </div></td>
                        <td width="18%"><div align="center">
                            <%botonera.dibujaBoton "buscar_homologacion"%>
                          </div></td>
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
      <br> <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
                <td><div align="center"><br>
                    <%pagina.DibujarTituloPagina%>
                    <br>
                  </div>
                  <form name="edicion">
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td><div align="center"> 
                            <%pagina.DibujarSubtitulo "Asignaturas Encontradas"%>
                            <table width="100%" border="0">
                              <tr> 
                                <td width="116">&nbsp;</td>
                                <td width="511"><div align="right">P&aacute;ginas: 
                                    &nbsp; 
                                    <% f_asignaturas.AccesoPagina %>
                                  </div></td>
                                <td width="24"> <div align="right"> </div></td>
                              </tr>
                            </table>
                            <br>
                            <BR>
                            <%f_asignaturas.DibujaTabla %>
                          </div></td>
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
                <td width="30%" height="20"><div align="center"> 
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td><div align="center"> 
                            <%
							if f_asignaturas.nroFilas > 0 then
							   botonera.agregaBotonParam "guardar_homologacion", "deshabilitado", "FALSE"
							else
							   botonera.agregaBotonParam "guardar_homologacion", "deshabilitado", "TRUE"
							end if
							botonera.dibujaBoton "guardar_homologacion"%>
                          </div></td>                       
                        <td><div align="center">
						<% botonera.agregaBotonParam "salir", "funcion", "CerrarActualizar();"
						   botonera.dibujaBoton "salir" %>
						</div></td>
                      </tr>
                    </table>
                  </div></td>
                <td width="70%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
              </tr>
              <tr> 
                <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
              </tr>
            </table></td>
          <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
        </tr>
      </table>
      <br> <br> </td>
  </tr>
</table>
</body>
</html>
