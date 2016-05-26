<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'---------------------------------------------------------------------------------------------------

q_mcaj_ncorr = Request.QueryString("busqueda[0][mcaj_ncorr]")
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina
pagina.Titulo = "Corrección de Tarjetas"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "corregir_tarjetas.xml", "botonera"


'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "corregir_tarjetas.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "mcaj_ncorr", q_mcaj_ncorr


	
'-----------------DETALLES CHEQUES------------------------------------
		set f_detalle_cheque_2 = new CFormulario
		f_detalle_cheque_2.Carga_Parametros "corregir_tarjetas.xml", "f_detalle_tarjeta"
		f_detalle_cheque_2.Inicializar conexion
	
		consulta_c = "select a.ingr_ncorr,protic.obtener_rut(a.pers_ncorr) as rut," & vbCrLf &_
					" protic.obtener_rut((SELECT pers_ncorr FROM codeudor_postulacion WHERE post_ncorr in (SELECT MAX(post_ncorr) AS post_ncorr FROM postulantes WHERE pers_ncorr = a.pers_ncorr))) as rut_apoderado,"& vbCrLf &_
					"    protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre,b.ding_ndocto as num_docto, " & vbCrLf &_
					"    b.ting_ccod, b.ting_ccod as tipo_doc, b.ding_ndocto, isnull(cast(b.banc_ccod as varchar),'N/B') as banc_ccod, b.plaz_ccod," & vbCrLf &_
					"    b.ding_fdocto, cast(b.ding_mdetalle as numeric) as ding_mdetalle," & vbCrLf &_
					"    cast(b.ding_mdocto as numeric) as ding_mdocto " & vbCrLf &_
					"    from ingresos a,detalle_ingresos b " & vbCrLf &_
					"    where a.ingr_ncorr = b.ingr_ncorr " & vbCrLf &_
					"        and a.eing_ccod <> 3 " & vbCrLf &_
					"        and cast(a.mcaj_ncorr as varchar)= '" & q_mcaj_ncorr & "' " & vbCrLf &_
					"        and b.ting_ccod in (13,51) " & vbCrLf &_
					" ORDER BY b.banc_ccod ASC, b.ding_ndocto asc, rut ASC"

		'response.Write("<pre>"&consulta_c&"</pre>")
		'response.End()		
		f_detalle_cheque_2.Consultar consulta_c

		
set f_movimiento_caja = new CFormulario
f_movimiento_caja.Carga_Parametros "detalle_caja.xml", "movimiento_caja"
f_movimiento_caja.Inicializar conexion
'---------------------------------------------------------------------------------------------------

	   
consulta = "select protic.obtener_rut(b.pers_ncorr) as rut," & vbCrLf &_
			"    protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre_completo," & vbCrLf &_
			"    a.mcaj_ncorr, a.mcaj_ncorr as c_mcaj_ncorr, a.mcaj_finicio," & vbCrLf &_
			"    getdate() as fecha_emision, a.mcaj_mrendicion " & vbCrLf &_
			"from movimientos_cajas a, cajeros b " & vbCrLf &_
			"where a.sede_ccod = b.sede_ccod " & vbCrLf &_
			"  and a.caje_ccod = b.caje_ccod " & vbCrLf &_
			"  and cast(a.mcaj_ncorr as varchar) = '" & q_mcaj_ncorr & "'"
			
f_movimiento_caja.Consultar consulta


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
var t_busqueda;

function ValidaBusqueda()
{
	rut = t_busqueda.ObtenerValor(0, "pers_nrut") + '-' + t_busqueda.ObtenerValor(0, "pers_xdv")
	
	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido');		
		t_busqueda.filas[0].campos["pers_xdv"].objeto.select();
		return false;
	}
	
	return true;	
}


function InicioPagina()
{
	t_busqueda = new CTabla("busqueda");
}
</script>

</head>
<body onBlur="revisaVentana()" bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" >
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
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
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Búsqueda de postulantes"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                            <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
							  <td width="32%"><div align="right">N&ordm; Caja</div></td>
                                <td width="7%"><div align="center">:</div></td>	
							  <td><%f_busqueda.DibujaCampo("mcaj_ncorr")%></td>
							  </tr>
                            </table>
                  </div></td>
                  <td width="19%"><div align="center">
                            <%f_botonera.DibujaBoton("buscar")%>
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
            <td><div align="center"><br>
                    <table width="100%" border="0">
                      <tr> 
                        <td><%f_movimiento_caja.DibujaRegistro%></td>
                      </tr>
                
                    </table>                   
                    
               <p><%pagina.DibujarSubtitulo("Cambio de tarjetas")%></p>
                  </div>
              <form name="edicion">
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr>
                        <td align="center"> <br>
                          <table width="665" border="0">
                            <tr> 
                              <td width="116">&nbsp;</td>
                              <td width="511"><div align="right">P&aacute;ginas: 
                                  &nbsp; 
                                  <%f_detalle_cheque_2.AccesoPagina%>
                                </div></td>
                              <td width="24"> <div align="right"> </div></td>
                            </tr>
                          </table> 
                          <br>
                        </td>
                      </tr>
                      <tr> 
                        <td> <div align="center">
                            <%f_detalle_cheque_2.DibujaTabla%>
                          </div></td>
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
            <td width="15%" height="20"><div align="center">
                    <table width="50%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td><div align="center"> 
						 
                            <% f_botonera.dibujaboton "salir" %>
											 
                          </div></td>
                      </tr>
                    </table>
            </div></td>
            <td width="85%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
