<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
side_ncorr =Request.QueryString("side_ncorr")
peri_ccod = Request.QueryString("peri_ccod")
'---------------------------------------------------------------------------------------------------

set errores= new CErrores

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "crea_modulos_sicologos.xml", "botonera"
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "crea_modulos_sicologos.xml", "botonera"

'---------------------------------------------------------------------------------------------------


 set f_sedes_sicologos = new CFormulario
f_sedes_sicologos.Carga_Parametros "crea_modulos_sicologos.xml", "muestra_bloques"
f_sedes_sicologos.Inicializar conexion
coma=""""

sql_descuentos= "select blsi_ncorr, hora_ini+'-'+hora_fin as hora, (select case count(*) when 0 then '<img src="&coma&"img/cancel.png"&coma&" width="&coma&"15"&coma&" height="&coma&"15"&coma&">'else '<img src="&coma&"img/ok.png"&coma&" width="&coma&"15"&coma&" height="&coma&"15"&coma&">' end  from bloque_dia_sicologo aa where aa.blsi_ncorr=a.blsi_ncorr and dias_ccod=1 ) as lunes,"& vbcrlf & _
"  (select case count(*) when 0 then '<img src="&coma&"img/cancel.png"&coma&" width="&coma&"15"&coma&" height="&coma&"15"&coma&">'else '<img src="&coma&"img/ok.png"&coma&" width="&coma&"15"&coma&" height="&coma&"15"&coma&">' end  from bloque_dia_sicologo aa where aa.blsi_ncorr=a.blsi_ncorr and dias_ccod=2 ) as martes,"& vbcrlf & _
"  (select case count(*) when 0 then '<img src="&coma&"img/cancel.png"&coma&" width="&coma&"15"&coma&" height="&coma&"15"&coma&">'else '<img src="&coma&"img/ok.png"&coma&" width="&coma&"15"&coma&" height="&coma&"15"&coma&">' end  from bloque_dia_sicologo aa where aa.blsi_ncorr=a.blsi_ncorr and dias_ccod=3 ) as miercoles,"& vbcrlf & _
"  (select case count(*) when 0 then '<img src="&coma&"img/cancel.png"&coma&" width="&coma&"15"&coma&" height="&coma&"15"&coma&">'else '<img src="&coma&"img/ok.png"&coma&" width="&coma&"15"&coma&" height="&coma&"15"&coma&">' end  from bloque_dia_sicologo aa where aa.blsi_ncorr=a.blsi_ncorr and dias_ccod=4 ) as jueves,"& vbcrlf & _
"  (select case count(*) when 0 then '<img src="&coma&"img/cancel.png"&coma&" width="&coma&"15"&coma&" height="&coma&"15"&coma&">'else '<img src="&coma&"img/ok.png"&coma&" width="&coma&"15"&coma&" height="&coma&"15"&coma&">' end  from bloque_dia_sicologo aa where aa.blsi_ncorr=a.blsi_ncorr and dias_ccod=5 ) as viernes"& vbcrlf & _
"  from bloques_sicologos a where side_ncorr="&side_ncorr&" and peri_ccod="&peri_ccod&""

f_sedes_sicologos.Consultar sql_descuentos
'response.Write(sql_descuentos)
sede=conexion.ConsultaUno("select sede_tdesc from sedes a, sicologos_sede b where a.sede_ccod=b.sede_ccod and b.side_ncorr="&side_ncorr&"")
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
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<form name="edicion">
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
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
		  <tr>
		  <td><div align="center">
                    <br>
                    <table width="100%" border="0">
                     
                    </table>
					</tr>
          <tr>
            <td>
				
              
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td width="50%">
						  <table width="75%"  border="0" align="center">
								 <tr>						
								   <td width="20%" align="center"><strong><font size="4">Horario para sede <%=sede%> </font></strong></td>
						    </tr>
							</table>
							<table width="75%"  border="0" align="center">
								  <tr>
								  	<td align="left" width="100%">
										<table border="1" >
											<tr>
												<td>
													<img src="img/ok.png" width="15" height="15">
												</td>
												<td>
													Hora Disponible
												</td>
											</tr>
											<tr>
												<td>
													<img src="img/cancel.png" width="15" height="15">
												</td>
												<td>
													Hora no Disponible
												</td>
											</tr>
										</table>
									</td>
								  </tr>
								  <tr >
								  	<td align="left" width="100%" bgcolor="#FF0000">
									<font color="#ffffff">En este punto aún no esta disponible el horario para los alumnos, si necesita agregar o eliminar dias disponibles al horario haga clic en anterior, si esta todo bien haga clic en finalizar para que el horario quede disponible para los alumnos.</font>									</td>
								  </tr>
								  <tr>
									  <td align="center" width="100%"><%f_sedes_sicologos.Dibujatabla()%></td>
								   </tr>
							</table>
				   </td>
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
				
				  <td><div align="center"><%f_botonera.AgregaBotonParam "anterior2", "url", "bloques_sicologos_anula.asp?side_ncorr="&side_ncorr&"&peri_ccod="&peri_ccod&"&devuelta=1"
				  f_botonera.DibujaBoton"anterior2"%></div></td>
				  
                  <td><div align="center"><%f_botonera.DibujaBoton"siguiente3"%></div></td>
				  
							 
                  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
				  
				  
				 
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
</table> </form>
</body>
</html>