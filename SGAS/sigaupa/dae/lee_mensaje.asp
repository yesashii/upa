<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

mesi_ncorr=request.QueryString("mesi_ncorr")



'response.Write(peri_ccod&"<br>"&sede_ccod&"<br>"&fecha)
'---------------------------------------------------------------------------------------------------

set errores= new CErrores

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "mensajeria_sicologo.xml", "botonera"
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "mensajeria_sicologo.xml", "botonera"

'---------------------------------------------------------------------------------------------------
'---------------------------------------------------------------------------------------------------

 usu=negocio.obtenerUsuario
 'f_cheques.agregaCampoCons "peri_ccod",peri_ccod
 'f_cheques.agregaCampoCons "sede_ccod",sede_ccod
 'f_cheques.agregaCampoCons "fecha_consulta",fecha_consulta
 
 
 set f_mensajes = new CFormulario
f_mensajes.Carga_Parametros "mensajeria_sicologo.xml", "lee_mensaje"
f_mensajes.Inicializar conexion


sql_mensaje= " select mesi_mensaje,mesi_titulo,pers_tnombre+' '+pers_tape_paterno as origen,pers_ncorr_destino,pers_ncorr_origen"& vbcrlf & _
				" from mensajeria_sicologos a,"& vbcrlf & _
				" personas b"& vbcrlf & _
				" where a.pers_ncorr_origen=b.PERS_NCORR"& vbcrlf & _
				" and mesi_ncorr="&mesi_ncorr&""

f_mensajes.Consultar sql_mensaje
f_mensajes.siguiente
v_alumno=f_mensajes.obtenerValor("pers_ncorr_origen")
v_sicologa=f_mensajes.obtenerValor("pers_ncorr_destino")

'response.Write(sql_descuentos)

 'response.End()
 marca_leido="update mensajeria_sicologos set esme_ccod=2 where mesi_ncorr="&mesi_ncorr&""
conexion.EjecutaS marca_leido
'response.Write("<br>"&sql_hora)

set f_historial = new CFormulario
f_historial.Carga_Parametros "mensajeria_sicologo.xml", "historial"
f_historial.Inicializar conexion

sql_historial=	" select accion,mesi_mensaje as mensaje,mesi_titulo,origen,protic.trunc(fecha) as fecha_msj, fecha "& vbcrlf & _
				" from ( "& vbcrlf & _ 
				" Select 'Entrada' as accion, mesi_mensaje,mesi_titulo,pers_tnombre+' '+pers_tape_paterno as origen,pers_ncorr_destino, "& vbcrlf & _
				" pers_ncorr_origen, a.audi_fmodificacion as fecha "& vbcrlf & _
				" from mensajeria_sicologos a,personas b "& vbcrlf & _
				" where a.pers_ncorr_origen=b.PERS_NCORR "& vbcrlf & _
				" and a.pers_ncorr_destino="&v_sicologa&" "& vbcrlf & _
				" and b.PERS_NCORR="&v_alumno&" "& vbcrlf & _
				" UNION "& vbcrlf & _
				" Select 'Salida' as accion, mesi_mensaje,mesi_titulo,pers_tnombre+' '+pers_tape_paterno as origen,pers_ncorr_destino, "& vbcrlf & _
				" pers_ncorr_origen, a.audi_fmodificacion as fecha "& vbcrlf & _
				" from mensajeria_sicologos a,personas b "& vbcrlf & _
				" where a.pers_ncorr_origen=b.PERS_NCORR "& vbcrlf & _
				" and a.pers_ncorr_destino="&v_alumno&" "& vbcrlf & _
				" and b.PERS_NCORR="&v_sicologa&" "& vbcrlf & _
				" ) as historial "& vbcrlf & _
				"order by fecha desc "

'response.Write("<pre>"&sql_historial&"</pre>")

f_historial.Consultar sql_historial
'f_historial.siguiente
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
<DIV ID="overDiv" STYLE="position:absolute; visibility:hide;z-index:1;"></DIV>
<script language="JavaScript" src="../biblioteca/overlib.js"></script>
<script language="JavaScript">

</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');" onBlur="revisaVentana();">
<form name="edicion">
<table width="600" height="300" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="80%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Mensaje recibidos"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center">
              <%pagina.DibujarTituloPagina%><br>
                    <table width="70%" border="0">
					  <tr> 
                        <td colspan="3" align="center"><strong>De:</strong></td>
						<td width="80%"><%=f_mensajes.Obtenervalor("origen")%></td>
                      </tr>
					  <tr> 
                        <td colspan="3" align="center"><strong>Asunto:</strong></td>
						<td><%=f_mensajes.Obtenervalor("mesi_titulo")%></td>
                      </tr>
					  <tr> 
                        <td colspan="3" align="center" valign="top"><strong>Mensaje:</strong></td>
						<td><%=f_mensajes.Obtenervalor("mesi_mensaje")%></td>
                      </tr>
                    </table>
                  </div>
                  <br/>
                  <%pagina.DibujarSubtitulo "Historial de mensajes"%>
				<center><%f_historial.DibujaTabla()%></center>
              </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="26%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("cerrar")%></div></td>
				   <td><div align="center"><%f_botonera.AgregaBotonParam "responder", "url", "redactar_mensaje.asp?mesi_ncorr="&mesi_ncorr&"&pers_ncorr_d="&f_mensajes.Obtenervalor("pers_ncorr_origen")&""
				   						     f_botonera.DibujaBoton("responder")%></div></td>
                 </tr>
              </table>
            </div></td>
            <td width="74%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table>
		
		</td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	
	<br>
	<br>
	</td>
  </tr>  
</table> </form>
</body>
</html>