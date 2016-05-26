<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_post_ncorr 	= Request.QueryString("post_ncorr")
q_ofer_ncorr 	= Request.QueryString("ofer_ncorr")
q_stde_ccod 	= Request.QueryString("stde_ccod")
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Agregar Beca"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "ingresar_beca_mineduc.xml", "botonera"

usuario 	= negocio.ObtenerUsuario()


if q_stde_ccod<>"" then
	v_accion="M"
	sql_union= "Union " &_
				"select stde_ccod, stde_tdesc" & vbCrLf &_
				"from stipos_descuentos a " & vbCrLf &_
				"where a.stde_ccod in ("&q_stde_ccod&") "
				
	sql_tipo_desc="and b.stde_ccod in ("&q_stde_ccod&") "
else
	v_accion="I"
	sql_tipo_desc="and b.stde_ccod in (1) " ' para evitar que muestre datos al editar un descuentos o agregar un segundo descuento.
end if


'---------------------------------------------------------------------------------------------------
set f_descuento = new CFormulario
f_descuento.Carga_Parametros "ingresar_beca_mineduc.xml", "agregar_beca"
f_descuento.Inicializar conexion

consulta = "select * from alumno_credito a, sdescuentos b,stipos_descuentos c " & vbCrLf &_
			" where a.tdet_ccod=b.stde_ccod " & vbCrLf &_
			" and a.post_ncorr=b.post_ncorr " & vbCrLf &_
			" and b.stde_ccod = c.stde_ccod " & vbCrLf &_ 
			" and a.tdet_ccod in (2513,2353,910,1390,1446,1537,1538,1912) " & vbCrLf &_
			" "&sql_tipo_desc&" " & vbCrLf &_
			" and cast(a.post_ncorr as varchar)='" & q_post_ncorr & "' "

'response.Write("<pre>"&consulta&"</pre>")
f_descuento.Consultar consulta



'-------------------------------------------------------------------------------------------
if q_post_ncorr="204815" then
consulta_tipos_descuentos = "select stde_ccod, stde_tdesc" & vbCrLf &_
                            "from stipos_descuentos a " & vbCrLf &_
							"where a.stde_ccod in (2513,2353,910,1390,1446,1537,1538,1912) "
							
else
'consulta_tipos_descuentos = "select stde_ccod, stde_tdesc" & vbCrLf &_
'                            "from stipos_descuentos a " & vbCrLf &_
'							"where a.stde_ccod in (2353,910,1390,1446,1537,1538,1912) " & vbCrLf &_
'							" and a.stde_ccod not in (select isnull(b2.stde_ccod,0) " & vbCrLf &_
'							"                  from postulantes a2, sdescuentos b2 " & vbCrLf &_
'							"				  where a2.post_ncorr *= b2.post_ncorr " & vbCrLf &_
'							"				    and a2.ofer_ncorr *= b2.ofer_ncorr " & vbCrLf &_
'							"					and a2.post_ncorr = '" & q_post_ncorr & "') " &_
'							" "&sql_union&" "
'----------------------------------------------------------------------------------------------------------------ACTUALIZACIÓN LUIS HERRERA 19_04_2013

 consulta_tipos_descuentos = "select stde_ccod, " & vbCrLf &_
 "       stde_tdesc " & vbCrLf &_
 "from   stipos_descuentos a " & vbCrLf &_
 "where  a.stde_ccod in ( 2513,2353, 910, 1390, 1446, " & vbCrLf &_
 "                        1537, 1538, 1912 ) " & vbCrLf &_
 "       and a.stde_ccod not in (select isnull(b2.stde_ccod, 0) " & vbCrLf &_
 "                               from   postulantes as a2 " & vbCrLf &_
 "                                      left outer join sdescuentos as b2 " & vbCrLf &_
 "                                                   on a2.post_ncorr = " & vbCrLf &_
 "                                                      b2.post_ncorr " & vbCrLf &_
 "                                                      and " & vbCrLf &_
 "                                      a2.ofer_ncorr = b2.ofer_ncorr " & vbCrLf &_
 "                               where  a2.post_ncorr = '" & q_post_ncorr & "') " &_
 " "&sql_union&" "						
'----------------------------------------------------------------------------------------------------------------ACTUALIZACIÓN LUIS HERRERA 19_04_2013							
end if							


'response.Write("<pre>"&consulta_tipos_descuentos&"</pre>")						
f_descuento.AgregaCampoParam "stde_ccod", "destino", "("&consulta_tipos_descuentos&") a"
f_descuento.AgregaCampoCons "stde_ccod", q_stde_ccod
f_descuento.siguienteF




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



</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="" onBlur="revisaVentana();">
<br>
<table width="50%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
  <tr>
    <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
    <td height="8" background="../imagenes/top_r1_c2.gif"></td>
    <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
  </tr>
  <tr>
    <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
    <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><%pagina.DibujarLenguetas Array("Agregar descuento"), 1 %></td>
        </tr>
        <tr>
          <td height="2" background="../imagenes/top_r3_c2.gif"></td>
        </tr>
        <tr>
          <td>
          	<form name="edicion">
			<input type="hidden" name="accion" value="<%=v_accion%>">
			<input type="hidden" name="descuentos[0][post_ncorr]" value="<%=q_post_ncorr%>">
			<input type="hidden" name="descuentos[0][ofer_ncorr]" value="<%=q_ofer_ncorr%>">
			<input type="hidden" name="descuentos[0][stde_ccod_old]" value="<%=q_stde_ccod%>">
			<br/>
                      <table width="80%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          	<td width="16%"><strong>Becas Mineduc</strong></td>
							<td><strong>:</strong></td>
						  	<td width="84%"><%f_descuento.DibujaCampo("stde_ccod")%></td>
                        </tr>
						 <tr>
						  	<td><strong> Monto beneficio</strong></td>
							<td><strong>:</strong></td>
                         	<td><%f_descuento.DibujaCampo("monto_bene")%></td>
                         </tr>
						 <tr>						  
                          	<td><strong>Año Adjudicacion</strong></td>
							<td><strong>:</strong></td>
                          	<td><%f_descuento.DibujaCampo("ano_adjudicacion")%></td>
                        </tr>
						<tr>
                          	<td><strong>Observacion</strong><br></td>
							<td><strong>:</strong></td>                              
                           	<td><%f_descuento.DibujaCampo("observacion")%></td>
                        </tr>
                      </table>
            </form>
		 </td>
        </tr>
    </table></td>
    <td width="7" background="../imagenes/der.gif">&nbsp;</td>
  </tr>
  <tr>
    <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
    <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td width="38%" height="20"><div align="center">
		    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("aceptar")%>
                  </div></td>
                  <td><div align="center"><%f_botonera.DibujaBoton("cancelar")%></div></td>
                </tr>
              </table>
          </div></td>
          <td width="62%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
        </tr>
        <tr>
          <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
        </tr>
    </table></td>
    <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
  </tr>
</table>
</body>
</html>
