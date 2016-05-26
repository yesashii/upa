<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "detalle de documentos del deposito"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
'-------------------------------------------------------------------------------------------
set negocio = new CNegocio
negocio.Inicializa conexion
'--------------------------------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'---------------------------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Depositos.xml", "botonera"
'--------------------------------------------------------------------------------------------
folio_envio = Request.QueryString("folio_envio")

set f_envio = new CFormulario
f_envio.Carga_Parametros "Depositos.xml", "f_datos"
f_envio.Inicializar conexion

consulta = "SELECT  a.envi_ncorr, a.eenv_ccod, b.eenv_tdesc, a.envi_fenvio, a.tdep_ccod, d.tdep_tdesc , a.inen_ccod, c.inen_tdesc, e.ccte_tdesc   "& vbCrLf &_
           "FROM envios a, "& vbCrLf &_
			   "estados_envio b, "& vbCrLf &_
			   "instituciones_envio c, "& vbCrLf &_
			   "tipos_depositos d, "& vbCrLf &_
			   "cuentas_corrientes e "& vbCrLf &_
			"WHERE a.eenv_ccod = b.eenv_ccod "& vbCrLf &_
			  "and a.inen_ccod = c.inen_ccod "& vbCrLf &_
			  "and a.tdep_ccod = d.tdep_ccod "& vbCrLf &_
			  "and a.ccte_ccod = e.ccte_ccod "& vbCrLf &_
			  "and a.envi_ncorr =" & folio_envio 

 f_envio.Consultar consulta
 f_envio.siguiente

 estado_envio =  f_envio.obtenervalor("eenv_ccod")

'----------------------------------------------------------------------------
set f_detalle_envio = new CFormulario
f_detalle_envio.Carga_Parametros "Depositos.xml", "f_detalle_deposito"
f_detalle_envio.Inicializar conexion

				  
consulta = "select a.envi_ncorr, a.envi_ncorr as c_envi_ncorr, b.ting_ccod, b.ding_ndocto as c_ding_ndocto, b.ingr_ncorr, "& vbCrLf &_
			"b.ding_ndocto, cast(c.ding_mdocto as numeric) as ding_mdocto, convert(varchar,d.ingr_fpago,103) as ingr_fpago, c.ding_tcuenta_corriente, "& vbCrLf &_
			"c.ding_fdocto, c1.edin_ccod, g.banc_tdesc, "& vbCrLf &_
			"cast(f.pers_nrut as varchar) + '-' + f.pers_xdv as rut_apoderado, "& vbCrLf &_
			"cast(f.pers_tnombre as varchar) + ' ' + f.pers_tape_paterno as nombre_apoderado "& vbCrLf &_
			"    from envios a,detalle_envios b,detalle_ingresos c,ingresos d,estados_detalle_ingresos c1,"& vbCrLf &_
			"        personas e,personas f,bancos g"& vbCrLf &_
			"    where a.envi_ncorr = b.envi_ncorr"& vbCrLf &_
			"    and b.ting_ccod = c.ting_ccod  "& vbCrLf &_
			"    and b.ding_ndocto = c.ding_ndocto  "& vbCrLf &_
			"    and b.ingr_ncorr = c.ingr_ncorr"& vbCrLf &_
			"    and c.ingr_ncorr = d.ingr_ncorr  "& vbCrLf &_
			"    and b.edin_ccod = c1.edin_ccod"& vbCrLf &_
			"    and d.pers_ncorr = e.pers_ncorr"& vbCrLf &_
			"    and c.PERS_NCORR_CODEUDOR *= f.pers_ncorr"& vbCrLf &_
			"    and c.banc_ccod *= g.banc_ccod"& vbCrLf &_
			"    and c.DING_NCORRELATIVO = 1"& vbCrLf &_
			"    and a.envi_ncorr=" & folio_envio&""
				  
'response.Write("<pre>"&consulta&"</pre>")
'response.End()				  				  
f_detalle_envio.Consultar consulta

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
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><%
				      if estado_envio = "1" then 
					     pagina.dibujarLenguetas array (array("Detalle Depósito","Depositos_Detalle.asp"),array("Búsqueda de Documentos","Depositos_Detalle_Agregar.asp?folio_envio="& folio_envio)),1
                      else
                         pagina.dibujarLenguetas array (array("Detalle Depósito","Depositos_Detalle.asp"),"Búsqueda de Documentos"),1					  
					  end if
					%>
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
                    <BR>
                  </div>
                  <form name="edicion" method="post" action="">
                    <table width="100%" border="0">
                      <tr> 
                        <td><strong>N&ordm; Dep&oacute;sito</strong></td>
                        <td><strong>:</strong></td>
                        <td width="26%"><font size="2"> 
                          <% f_envio.DibujaCampo("envi_ncorr") %>
                          </font></td>
                        <td width="13%"><strong>Fecha</strong></td>
                        <td width="3%"><strong>:</strong></td>
                        <td width="36%"><font size="2"> 
                          <% f_envio.DibujaCampo("envi_fenvio") %>
                          </font></td>
                      </tr>
                      <tr> 
                        <td><strong>Cuenta Corriente</strong></td>
                        <td><strong>:</strong></td>
                        <td><font size="2"> 
                          <%f_envio.DibujaCampo("ccte_tdesc") %>
                          </font></td>
                        <td><strong>Banco</strong></td>
                        <td><strong>:</strong></td>
                        <td><font size="2"> 
                          <% f_envio.DibujaCampo("inen_tdesc") %>
                          </font></td>
                      </tr>
                      <tr> 
                        <td><strong>Estado</strong></td>
                        <td><strong>:</strong></td>
                        <td><font size="2"> 
                          <% f_envio.DibujaCampo("eenv_tdesc") %>
                          </font></td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="19%"><strong>Tipo Dep&oacute;sito</strong></td>
                        <td width="3%"><strong>:</strong></td>
                        <td colspan="4"><font size="2"> 
                          <% f_envio.DibujaCampo("tdep_tdesc") %>
                          </font></td>
                      </tr>
                    </table>
					<div align="center">
                    </div>
                    <table width="665" border="0">
                      <tr>
                        <td width="116">&nbsp;</td>
                        <td width="511"><div align="right">P&aacute;ginas: &nbsp;
                                <% f_detalle_envio.AccesoPagina%>
                          </div>
                        </td>
                        <td width="24">
                          <div align="right"> </div>
                        </td>
                      </tr>
                    </table>
                    <div align="center"><BR>
                      <% f_detalle_envio.DibujaTabla%>
                    </div>
                    </form>
                    
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="115" bgcolor="#D8D8DE"><table width="83%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="10%"> <div align="left"> 
                          <%  botonera.agregabotonparam "anterior", "url", "Depositos.asp?envi_ncorr="& folio_envio
						      botonera.DibujaBoton "anterior"  %>
                        </div></td>
                      <td width="10%"><%    if estado_envio = "2" then
 					                           botonera.agregabotonparam "siguiente", "deshabilitado" ,"TRUE"
										   end if   
					                           botonera.agregabotonparam "siguiente", "url" ,"Depositos_Detalle_Agregar.asp?folio_envio="& folio_envio 
					                           botonera.DibujaBoton "siguiente"
										   	 %> 
                      </td>
                      <td width="13%"><%if estado_envio = "2" then
					                       botonera.agregabotonparam "eliminar", "deshabilitado" ,"TRUE"
										end if
					                       botonera.agregabotonparam "eliminar", "url", "Depositos_Detalle_Eliminar.asp"
						                   botonera.dibujaboton "eliminar"
										%> 
                      </td>
                      <td width="14%">
                                      <%
					                       botonera.agregabotonparam "excel", "url", "Depositos_Excel.asp?folio_envio=" & folio_envio
						                   botonera.dibujaboton "excel"
										%>
                      </td>
                      <td width="53%"> 
                                 <%
				                       botonera.agregabotonparam "imprimir", "url", "../REPORTESNET/Deposito.aspx?folio_envio=" & folio_envio
					                   botonera.dibujaboton "imprimir"
								%>
                      </td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="247" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<BR>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
