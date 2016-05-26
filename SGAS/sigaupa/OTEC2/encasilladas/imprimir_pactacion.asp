<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_comp_ndocto = Request.QueryString("comp_ndocto")
q_leng = Request.QueryString("leng")

'response.Write("lolola comp_ndocto "&q_comp_ndocto&" q_leng "&q_leng)
'response.End()
if EsVacio(q_leng) then
	q_leng = "1"
end if



Function SqlDocumentos(p_ting_ccod)
	SqlDocumentos = "select  f.ting_ccod, f.ding_ndocto, f.ingr_ncorr, f.ting_ccod as c_ting_ccod, f.ding_ndocto as c_ding_ndocto, f.ingr_ncorr as c_ingr_ncorr, f.banc_ccod, f.plaz_ccod, f.ding_fdocto, f.ding_mdocto, f.ding_mdetalle, f.ding_tcuenta_corriente, b.comp_fdocto " & vbCrLf &_
	                "from sim_pactaciones a, compromisos b, detalle_compromisos c, abonos d, ingresos e, detalle_ingresos f--, postulantes g " & vbCrLf &_
					"where a.comp_ndocto = b.comp_ndocto " & vbCrLf &_
					"  and a.inst_ccod = b.inst_ccod " & vbCrLf &_
					"  and a.tcom_ccod = b.tcom_ccod " & vbCrLf &_
					"  and b.tcom_ccod = c.tcom_ccod " & vbCrLf &_
					"  and b.inst_ccod = c.inst_ccod " & vbCrLf &_
					"  and b.comp_ndocto = c.comp_ndocto " & vbCrLf &_
					"  and c.tcom_ccod = d.tcom_ccod " & vbCrLf &_
					"  and c.inst_ccod = d.inst_ccod " & vbCrLf &_
					"  and c.comp_ndocto = d.comp_ndocto " & vbCrLf &_
					"  and c.dcom_ncompromiso = d.dcom_ncompromiso " & vbCrLf &_
					"  and d.ingr_ncorr = e.ingr_ncorr " & vbCrLf &_
					"  and e.ingr_ncorr = f.ingr_ncorr " & vbCrLf &_
					"  --and b.pers_ncorr = g.pers_ncorr " & vbCrLf &_
					"  --and g.peri_ccod = '" & negocio.ObtenerPeriodoAcademico("POSTULACION") & "' " & vbCrLf &_
					"  and f.ting_ccod IN ('" & p_ting_ccod & "')  " & vbCrLf &_
					"  and a.comp_ndocto = '" & q_comp_ndocto & "' "
					
					
'response.Write("<pre>"&SqlDocumentos&"</pre>")
'response.Flush()
End Function



set pagina = new CPagina
pagina.Titulo = "Imprimir documentación de pactación"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "imprimir_pactacion.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_pactacion = new CFormulario
f_pactacion.Carga_Parametros "imprimir_pactacion.xml", "pactacion"
f_pactacion.Inicializar conexion

consulta = "select a.comp_ndocto, a.tcom_ccod, a.tdet_ccod, b.comp_mdocumento, protic.obtener_rut(b.pers_ncorr) as rut, protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre " & vbCrLf &_
           "from sim_pactaciones a, compromisos b " & vbCrLf &_
		   "where a.comp_ndocto = b.comp_ndocto " & vbCrLf &_
		   "  and a.inst_ccod = b.inst_ccod " & vbCrLf &_
		   "  and a.tcom_ccod = b.tcom_ccod " & vbCrLf &_
		   "  and a.comp_ndocto = '" & q_comp_ndocto & "'"
'response.Write("<pre>"&consulta&"<pre>")
'response.End()
f_pactacion.Consultar consulta
'---------------------------------------------------------------------------------------------------
if q_leng = "1" then
	set f_comp_ingreso = new CFormulario
	f_comp_ingreso.Carga_Parametros "imprimir_pactacion.xml", "comp_ingreso"
	f_comp_ingreso.Inicializar conexion
	
	consulta = "select c.ting_ccod, c.ingr_nfolio_referencia, max(c.ingr_fpago) as ingr_fpago, sum(c.ingr_mefectivo) as ingr_mefectivo, sum(c.ingr_mdocto) as ingr_mdocto, sum(c.ingr_mtotal) as ingr_mtotal " & vbCrLf &_
	           "from sim_pactaciones a, abonos b, ingresos c " & vbCrLf &_
			   "where a.comp_ndocto = b.comp_ndocto " & vbCrLf &_
			   "  and a.inst_ccod = b.inst_ccod " & vbCrLf &_
			   "  and a.tcom_ccod = b.tcom_ccod " & vbCrLf &_
			   "  and b.ingr_ncorr = c.ingr_ncorr " & vbCrLf &_
			   "  and b.tcom_ccod in (7) " & vbCrLf &_
			   "  and c.ting_ccod=33 " & vbCrLf &_
			   "  and a.comp_ndocto = '" & q_comp_ndocto & "' " & vbCrLf &_
			   "group by c.ting_ccod, c.ingr_nfolio_referencia"
	'response.Write("<pre>"&consulta&"</pre>")		   
	f_comp_ingreso.Consultar consulta
	
	set f_tabla = f_comp_ingreso
	
	bt_imprimir = "imprimir_docto"
	f_botonera.AgregaBotonUrlParam "imprimir_docto", "contrato", q_comp_ndocto
	f_botonera.AgregaBotonUrlParam "imprimir_docto", "periodo", negocio.ObtenerPeriodoAcademico("POSTULACION")
	f_botonera.AgregaBotonUrlParam "imprimir_docto", "tipo_impresion", "2"
end if

if q_leng = "2" then
	set f_documentos = new CFormulario	
	f_documentos.Carga_Parametros "imprimir_pactacion.xml", "cheques"
	f_documentos.Inicializar conexion
	
	f_documentos.Consultar SqlDocumentos("3")
	
	set f_tabla = f_documentos	
	
	bt_imprimir = "imprimir_cheques"
end if

if q_leng = "3" then
	set f_documentos = new CFormulario	
	f_documentos.Carga_Parametros "imprimir_pactacion.xml", "letras"
	f_documentos.Inicializar conexion
	
	f_documentos.Consultar SqlDocumentos("4")
	
	set f_tabla = f_documentos	
	
	bt_imprimir = "imprimir_letras"
end if

if q_leng = "4" then
	set f_documentos = new CFormulario	
	f_documentos.Carga_Parametros "imprimir_pactacion.xml", "tarjetas"
	f_documentos.Inicializar conexion
	
	f_documentos.Consultar SqlDocumentos("13','51")
	
	set f_tabla = f_documentos	
	'f_tabla.agregaCampoCons
	'bt_imprimir = "imprimir_letras"
end if


'---------------------------------------------------------------------------------------------------
url_leng_1 = "imprimir_pactacion.asp?comp_ndocto=" & q_comp_ndocto & "&leng=1"
url_leng_2 = "imprimir_pactacion.asp?comp_ndocto=" & q_comp_ndocto & "&leng=2"
url_leng_3 = "imprimir_pactacion.asp?comp_ndocto=" & q_comp_ndocto & "&leng=3"
url_leng_4 = "imprimir_pactacion.asp?comp_ndocto=" & q_comp_ndocto & "&leng=4"
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
var t_documentos;
var t_alt_documentos;

function imprimir_d_click(objeto)
{	
	for (var i = 0; i < t_alt_documentos.filas.length; i++) {
		if (t_alt_documentos.filas[i].campos["imprimir_d"].objeto != objeto) {			
			t_alt_documentos.filas[i].campos["imprimir_d"].objeto.checked = false;
		}
		cambiaOculto(t_alt_documentos.filas[i].campos["imprimir_d"].objeto, '1', '0');
	}
}


function ValidaImprimirCheque()
{
	if (t_documentos.CuentaSeleccionados("imprimir_d") == 0) {
		alert('Debe seleccionar cheques para imprimir.');
		return false;		
	}	

	return true;
}


function ValidaImprimirLetras()
{
	if (t_documentos.CuentaSeleccionados("ding_ndocto") == 0) {
		alert('Debe seleccionar letras para imprimir.');
		return false;		
	}
	
	open ("", "wLetras", "top=, left=, width=, height=");	
	return true;
}



function InicioPagina()
{
	t_documentos = new CTabla("envios");
	t_alt_documentos = new CTabla("_envios");
}
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
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
            <td><%pagina.DibujarLenguetas Array("Documentos para imprimir"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"></div>
              <form name="edicion">
                <br>
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><div align="center"><%f_pactacion.DibujaRegistro%></div></td>
                  </tr>
                </table>
                <br>
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>                      <br>
                      <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#EDEDEF">
                        <tr>
                          <td width="9" height="8"><img src="../imagenes/marco_claro/1.gif" width="9" height="8"></td>
                          <td height="8" background="../imagenes/marco_claro/2.gif"></td>
                          <td width="7" height="8"><img src="../imagenes/marco_claro/3.gif" width="7" height="8"></td>
                        </tr>
                        <tr>
                          <td width="9" background="../imagenes/marco_claro/9.gif"></td>
                          <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td><%pagina.DibujarLenguetasFClaro Array(Array("Comprobante de ingreso", url_leng_1), Array("Cheques", url_leng_2), Array("Letras", url_leng_3),Array("Tarjetas", url_leng_4)), CInt(q_leng) %></td>
                              </tr>
                              <tr>
                                <td height="2" background="../imagenes/top_r3_c2.gif"></td>
                              </tr>
                              <tr>
                                <td> <br>                                  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                                  <tr>
                                    <td><div align="center"><%f_tabla.DibujaTabla%></div></td>
                                  </tr>
                                </table>                                  
                                    </td>
                              </tr>
                          </table></td>
                          <td width="7" background="../imagenes/marco_claro/10.gif"></td>
                        </tr>
                        <tr>
                          <td width="9" height="13"><img src="../imagenes/marco_claro/base1.gif" width="9" height="13"></td>
                          <td height="13" background="../imagenes/marco_claro/15.gif"></td>
                          <td width="7" height="13"><img src="../imagenes/marco_claro/base3.gif" width="7" height="13"></td>
                        </tr>
                      </table></td>
                  </tr>
                </table>
                          <br>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="23%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                    <% 
					if q_leng <> "2" and q_leng <> "4" then
						f_botonera.DibujaBoton(bt_imprimir)
					end if 
					%>
                  </div></td>
                  <td><div align="center"><%f_botonera.DibujaBoton("salir2")%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="77%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
