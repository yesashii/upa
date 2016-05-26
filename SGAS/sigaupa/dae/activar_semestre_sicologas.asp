<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut =Request.QueryString("a[0][pers_nrut]")
q_pers_xdv = Request.QueryString("a[0][pers_xdv]")
q_tasi_ncorr= request.QueryString("a[0][tasi_ncorr]")
q_sede_ccod= request.QueryString("a[0][sede_ccod]")
q_peri_ccod= request.QueryString("a[0][peri_ccod]")
q_carr_ccod= request.QueryString("a[0][carr_ccod]")
q_fecha= request.QueryString("a[0][fecha]")
'---------------------------------------------------------------------------------------------------

set errores= new CErrores

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "agrega_taller.xml", "botonera"
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "agrega_taller.xml", "botonera"

'---------------------------------------------------------------------------------------------------

'---------------------------------------------------------------------------------------------------
peri_ccod=conexion.ConsultaUno("select peri_ccod from semestre_activo")

set f_cheques = new CFormulario
f_cheques.Carga_Parametros "tabla_vacia.xml", "tabla" 
f_cheques.Inicializar conexion


sql_descuentos= "select peri_ccod, peri_tdesc  from periodos_academicos where peri_ccod > 218"




					
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&numero_total&"</pre>")
'response.Write("<pre>"&q_sfun_ccod&"</pre>")
'response.End()

f_cheques.Consultar sql_descuentos

 usu=negocio.obtenerUsuario
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

function activar_valor()
{
document.edicion.elements["a[0][peri_ccod]"].value=<%=peri_ccod%>

}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); activar_valor();" onBlur="revisaVentana();">
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
                    <td width="100%">
					
                      <table width="98%"  border="0" align="center">
					   
                            
						 <tr>						
                               
						   <td width="20%"><span class="Estilo2"></span><strong>Selecione el Periodo Academico y Presione Activar</strong><br></td>
                        </tr>
						
						  <tr>						
                               
						   <td width="20%"><span class="Estilo2"></span><strong>Periodo Academico</strong><br> 
						   <select name="a[0][peri_ccod]">
						   <%while f_cheques.Siguiente %>
						   <option value="<%=f_cheques.ObtenerValor("peri_ccod")%>"><%=f_cheques.ObtenerValor("peri_tdesc")%></option>
						   <%wend%>
						   </select>
						   </td>
                        </tr>
                      </table>
					
                      <br>
                    
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
				
                  <td>
				  <div align="center">
					  <table id="bt_salir5334" width="92" border="0" cellspacing="0" cellpadding="0" class="click" onMouseOver="_OverBoton(this);" onMouseOut="_OutBoton(this);" onClick="_Navegar(this, '../lanzadera/lanzadera.asp', 'FALSE')">
						  <tr> 
							<td width="7" height="16" rowspan="3"><img src="../imagenes/botones/boton1.gif" width="5" height="16" id="bt_salir5334c11"></td> 
							<td width="88" height="2"><img src="../imagenes/botones/boton2.gif" width="88" height="2" id="bt_salir5334c12"></td> 
							<td width="10" height="16" rowspan="3"><img src="../imagenes/botones/boton4.gif" width="5" height="16" id="bt_salir5334c13"></td>
						  </tr>
						  <tr> 
							<td height="12" bgcolor="#EEEEF0" id="bt_salir5334c21" nowrap> 
							  <div align="center"><font id="bt_salir5334f21" color="#333333" size="1" face="Verdana, Arial, Helvetica, sans-serif">Salir</font></div></td>
						  </tr>
						  <tr> 
							<td width="88" height="2"><img src="../imagenes/botones/boton3.gif" width="88" height="2" id="bt_salir5334c31"></td>
						  </tr>
					</table>
				</div>
				</td>

				  
							 
                  <td>
					<div align="center">
						  <table id="bt_salir5335" width="92" border="0" cellspacing="0" cellpadding="0" class="click" onMouseOver="_OverBoton(this);" onMouseOut="_OutBoton(this);" onClick="_Guardar(this, document.forms['edicion'], 'activar_semestre_sicologas_proc.asp','', '', '', 'FALSE')">
							  <tr> 
								<td width="7" height="16" rowspan="3"><img src="../imagenes/botones/boton1.gif" width="5" height="16" id="bt_salir5335c11"></td> 
								<td width="88" height="2"><img src="../imagenes/botones/boton2.gif" width="88" height="2" id="bt_salir5335c12"></td> 
								<td width="10" height="16" rowspan="3"><img src="../imagenes/botones/boton4.gif" width="5" height="16" id="bt_salir5335c13"></td>
							  </tr>
							  <tr> 
								<td height="12" bgcolor="#EEEEF0" id="bt_salir5335c21" nowrap> 
								  <div align="center"><font id="bt_salir5335f21" color="#333333" size="1" face="Verdana, Arial, Helvetica, sans-serif">Activar</font></div></td>
							  </tr>
							  <tr> 
								<td width="88" height="2"><img src="../imagenes/botones/boton3.gif" width="88" height="2" id="bt_salir5335c31"></td>
							  </tr>
						</table>
					</div>
				  </td>
				  
				  
				 
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