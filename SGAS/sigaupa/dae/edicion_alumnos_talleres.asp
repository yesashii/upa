<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
	'response.Write(k&" = "&request.Form(k)&"<br>")
	'next
'response.End()
q_tdsi_ncorr= request.QueryString("tdsi_ncorr")
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Historial de Documentos"
set errores= new CErrores
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "edicion_talleres.xml", "botonera"
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "edicion_talleres.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "edicion_talleres.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

'---------------------------------------------------------------------------------------------------
set f_dictados = new CFormulario
f_dictados.Carga_Parametros "edicion_talleres.xml", "dictados"
f_dictados.Inicializar conexion

sql_dictados= "select tdsi_ncorr,tasi_ncorr,sede_ccod,peri_ccod,fecha from  talleres_dictados_sicologia b where tdsi_ncorr="&q_tdsi_ncorr&""
				

f_dictados.Consultar sql_dictados				





set f_listado = new CFormulario
f_listado.Carga_Parametros "edicion_talleres.xml", "listado"
f_listado.Inicializar conexion

sql_listado= "select atsi_ncorr,tdsi_ncorr,pers_ncorr,(select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno from personas where pers_ncorr=a.pers_ncorr)as nombre from alumnos_talleres_psicologia a where tdsi_ncorr="&q_tdsi_ncorr&" "


f_listado.Consultar sql_listado
				
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&numero_total&"</pre>")
'response.Write("<pre>"&q_acre_ncorr&"</pre>")
'response.End()



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
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" >
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
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
					
					
					 
                    <table width="100%" border="0">
                     
                    </table>
			  </tr>
			  
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
             
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Taller"%>
					 <form name="edicion" >
                      <table width="98%"  border="0" align="center">
					   <tr>
                             <td align="right">P&aacute;gina:
                                 <%f_dictados.accesopagina%>
                             </td>
                            </tr>
                            <tr>						
                                <td align="center">
						       <%f_dictados.DibujaTabla()%>
							   </td>
						  
                        </tr>
                      </table></form>
					   <form name="edicion2" >
					       <table width="98%"  border="0" align="center">
					   <tr>
                             <td align="right">P&aacute;gina:
                                 <%f_listado.accesopagina%>
                             </td>
                            </tr>
                            <tr>						
                                <td align="center">
						       <%f_listado.DibujaTabla()%>
							   </td>
						  
                        </tr>
						
                      </table></form>
					
                      <br>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><p><br> </p>
                            </td>
                        </tr>
                      </table></td>
                  </tr>
                </table>
                          <br>
            </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="31%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                    
					<%f_botonera.DibujaBoton"guardar" %></div></td>
			
				  
							 
                  <td><div align="center"><%f_botonera.DibujaBoton("salir2")%></div></td>
				   <td><div align="center">
                    
					<%f_botonera.AgregaBotonParam "volver", "url", "EDICION_BUSCA_ALUMNOS_TALLERES.asp"
				   f_botonera.DibujaBoton"volver"  %></div></td>
				  <td><div align="center">
                    
					<%f_botonera.AgregaBotonParam "excel", "url", "agrega_alumnos_taller.asp?tdsi_ncorr="&q_tdsi_ncorr&"&pagi=2"
				   f_botonera.DibujaBoton"excel"  %></div></td>
				   
				    <td><div align="center"><%f_botonera.DibujaBoton("eliminar")%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="69%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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