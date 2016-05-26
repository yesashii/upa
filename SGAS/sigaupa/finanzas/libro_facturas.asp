<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Libro Facturas"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
Usuario = negocio.ObtenerUsuario()
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "libro_facturas.xml", "botonera"
'-----------------------------------------------------------------------
 sede = request.querystring("busqueda[0][sede_ccod]")
 inicio = request.querystring("busqueda[0][inicio]")
 termino = request.querystring("busqueda[0][termino]")
 num_doc = request.querystring("busqueda[0][fact_nfactura]")
 estado_factura = request.querystring("busqueda[0][efac_ccod]")
 tipo_factura = Request.QueryString("busqueda[0][tfac_ccod]")
 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "libro_facturas.xml", "busqueda_facturas"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "sede_ccod", sede
 f_busqueda.AgregaCampoCons "inicio", inicio
 f_busqueda.AgregaCampoCons "termino", termino
 f_busqueda.AgregaCampoCons "fact_nfactura", num_doc
 f_busqueda.AgregaCampoCons "efac_ccod", estado_factura
 f_busqueda.AgregaCampoCons "tfac_ccod", tipo_factura
'----------------------------------------------------------------------------
 
 set f_boletas = new CFormulario
 f_boletas.Carga_Parametros "libro_facturas.xml", "f_facturas"
 f_boletas.Inicializar conexion
 

consulta = "select a.pers_ncorr_alumno,protic.obtener_rut(a.pers_ncorr_alumno) as rut_beneficiario ," & vbCrLf &_
			" protic.obtener_nombre_completo(a.pers_ncorr_alumno,'n') as nombre_beneficiario," & vbCrLf &_
			" b.tfac_tdesc as tipo_factura,fact_nfactura as num_factura,case when a.efac_ccod =3 then 0 else fact_mtotal end as total_factura," & vbCrLf &_
			" protic.trunc(a.fact_ffactura) as fecha_factura, ingr_nfolio_referencia as comprobante," & vbCrLf &_
			" mcaj_ncorr as caja, c.efac_tdesc as estado" & vbCrLf &_
			" From facturas a, tipos_facturas b, estados_facturas c" & vbCrLf &_
			" where a.tfac_ccod=b.tfac_ccod" & vbCrLf &_
			" and a.efac_ccod=c.efac_ccod " 


					if sede <> "" then
					  consulta = consulta & vbCrLf&  " and a.sede_ccod = '" & sede & "' "
					end if

					if inicio <> "" and termino <> "" then
					  consulta = consulta & vbCrLf&   " and convert(datetime,fact_ffactura,103) between '" & inicio & "' and '" & termino & "'"
					end if 
					if inicio <> "" and termino = "" then
					  consulta = consulta & vbCrLf&   " and convert(datetime,fact_ffactura,103) >= '" & inicio & "'"
					end if 
					if inicio = "" and termino <> "" then
					  consulta = consulta & vbCrLf&   " and convert(datetime,fact_ffactura,103) <= '" & termino & "'"
					end if 
					
					if num_doc <> "" then                   
				      consulta = consulta & vbCrLf&   " and a.fact_nfactura= '" & num_doc & "' "
					end if
					if tipo_doc <> "" then                   
				      consulta = consulta & vbCrLf&   " and a.tfac_ccod= '" & tipo_factura & "' "
					end if
					if estado_letra <> "" then
  					   consulta = consulta & vbCrLf&  " and a.efac_ccod ='" & estado_factura & "' "
					 end if
					 
					 
					 consulta = consulta & vbCrLf&  " order by num_factura" 
										
'response.Write("<pre>"&consulta&"</pre>")
'response.Flush()
    
  if Request.QueryString <> "" then
	  f_boletas.consultar consulta
  else
	f_boletas.consultar "select '' where 1=2"
	f_boletas.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
  end if
'response.Write("<pre>"&consulta&"</pre>")
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
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>

<script language="JavaScript">
function Validar()
{
	return true;
}
</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "busqueda[0][inicio]","1","buscador","fecha_oculta_inicio"
	calendario.MuestraFecha "busqueda[0][termino]","2","buscador","fecha_oculta_termino"
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
                    <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="192" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador
                      de Documentos</font></div></td>
                    <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="459" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
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
			
				<form name="buscador" method="post">                
                      <table width="660" border="0" align="left">
                        <tr> 
                          <td width="94"><div align="left">Sede</div></td>
                          <td width="7">:</td>
                          <td width="125"> <% f_busqueda.DibujaCampo ("sede_ccod") %> </td>
                          <td width="5"><div align="center"></div></td>
                          <td width="96">Tipo Factura </td>
                          <td width="8">&nbsp;</td>
                          <td width="212"><% f_busqueda.DibujaCampo ("tfac_ccod") %></td>
                          <td width="79" rowspan="8"><div align="center"></div>
                            <div align="center"> 
                              <%botonera.DibujaBoton "buscar" %>
                            </div></td>
                        </tr>
                        <tr> 
                          <td colspan="3">Periodo de emisión del documento </td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                        </tr>
                        <tr> 
                          <td>Inicio</td>
                          <td>:</td>
                          <td><div align="left"></div>
                            <% f_busqueda.DibujaCampo ("inicio")%> <%calendario.DibujaImagen "fecha_oculta_inicio","1","buscador" %>
                            (dd/mm/aaaa) </td>
                          <td>&nbsp;</td>
                          <td>T&eacute;rmino</td>
                          <td>:</td>
                          <td><div align="left"> 
                              <% f_busqueda.DibujaCampo ("termino") %>
                              <%calendario.DibujaImagen "fecha_oculta_termino","2","buscador" %>
                              (dd/mm/aaaa) </div></td>
                        </tr>
                        <tr> 
                          <td>Estado Factura </td>
                          <td>:</td>
                          <td> <% f_busqueda.DibujaCampo ("efac_ccod") %> </td>
                          <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                              </font></div></td>
                          <td>N&deg; Factura </td>
                          <td>:</td>
                          <td><% f_busqueda.DibujaCampo ("fact_nfactura") %></td>
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
                    <td width="172" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Documentos
                          Encontrados</font></div>
                    </td>
                    <td width="485" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
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
                <td bgcolor="#D8D8DE"> <div align="center"><BR>
                    <%pagina.DibujarTituloPagina%>
                  </div>
                  <table width="665" border="0">
                    <tr> 
                      <td width="116">&nbsp;</td>
                      <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                          <%f_boletas.AccesoPagina%>
                        </div></td>
                      <td width="24"> <div align="right"> </div></td>
                    </tr>
                  </table> 
                  <form name="edicion">
                    <div align="center">
                      <% f_boletas.DibujaTabla() %>
                    </div>
                  </form>
                    <br>
                </td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                <td width="250" bgcolor="#D8D8DE"><table width="90%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="51%"><% botonera.DibujaBoton ("lanzadera") %> </td>
                      <td width="49%"><% 
                					  if Request.QueryString = "" then 
					                     botonera.agregabotonparam "excel_facturas", "deshabilitado" ,"TRUE"
  									  end if
									     botonera.DibujaBoton ("excel_facturas")  
										 									
									%> </td>

                    </tr>
                  </table>
                </td>
                <td width="262" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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