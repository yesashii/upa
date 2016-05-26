<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

mesi_ncorr=request.QueryString("mesi_ncorr")
pers_ncorr=request.QueryString("pers_ncorr_d")
v_cerrar=request.QueryString("cerrar")
if indice="" then

indice=-99
end if

if v_cerrar="" then
v_cerrar="0"
end if
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
f_mensajes.Carga_Parametros "mensajeria_sicologo.xml", "responder_mensaje"
f_mensajes.Inicializar conexion


sql_descuentos="select pers_tnombre+' '+pers_tape_paterno as origen ,'RE: '+mesi_titulo as asunto"& vbcrlf & _
"from mensajeria_sicologos a,"& vbcrlf & _
"personas b"& vbcrlf & _
"where a.pers_ncorr_origen=b.pers_ncorr"& vbcrlf & _
"and a.mesi_ncorr="&mesi_ncorr&""



f_mensajes.Consultar sql_descuentos
f_mensajes.siguiente

'response.Write(sql_descuentos)

 'response.End()
 

'response.Write("<br>"&sql_hora)


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

function cerrar()
{
	cerrar=<%=v_cerrar%>
	//alert(cerrar)
	if (cerrar>0)
	{
		window.close();
	}
		
}

</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); cerrar();" >
<form name="edicion">
<input type="hidden" name="a[0][pers_ncorr_destino]" value="<%=pers_ncorr%>"/>
<table width="750" height="300" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
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
            <td><%pagina.DibujarLenguetas Array("Redactar Mensaje"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center">
              <%pagina.DibujarTituloPagina%><br>
                    <table width="60%" border="0">
                      <tr> 
                        <td colspan="3" align="center"><strong>Para:</strong></td>
						<td width="66%" colspan="3" ><%f_mensajes.DibujaCampo("origen")%></td>
                      </tr>
					   <tr> 
                        <td colspan="3" align="center"><strong>Asunto:</strong></td>
						<td width="66%" colspan="3"><%f_mensajes.DibujaCampo("asunto")%></td>
                      </tr>
					  <tr> 
                        <td colspan="3" align="center" valign="top"><strong>Mensaje:</strong></td>
						<td width="66%" colspan="3" align="center"><textarea name="a[0][mensaje]" rows="7" style="width:300px"></textarea></td>
					  </tr>
                    </table>
                  </div>
              </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="12%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("cerrar")%></div></td>
				   <td><div align="center"><%f_botonera.DibujaBoton("enviar")%></div></td>
                 </tr>
              </table>
            </div></td>
            <td width="88%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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