<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
set botonera = new CFormulario
botonera.Carga_Parametros "edicion_envios_pagare.xml", "btn_edicion_envios_pagare"


'---------------------------------------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")

'---------------------------------------------------------------------------------------------------
'-----------------------------------------------------------------------
pagina.Titulo = "Detalles de Envíos Pagares UPA a Notaría"

'-----------------------------------------------------------------------
folio_envio = request.QueryString("folio_envio")
empresa_envio = request.QueryString("empresa_envio")
tipo_empresa = request.QueryString("tipo_empresa")
set f_envio = new CFormulario

f_envio.Carga_Parametros "Envios_Notaria.xml", "f_envios"
f_envio.Inicializar conexion
consulta = "SELECT a.envi_ncorr, a.envi_fenvio, a.inen_ccod, instituciones_envio.inen_tdesc FROM ENVIOS a, instituciones_envio WHERE a.inen_ccod = instituciones_envio.inen_ccod AND a.envi_ncorr = " & folio_envio 
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
 f_envio.Consultar consulta
 f_envio.siguiente
 estado_envio =  f_envio.obtenervalor("envi_ncorr")

'---------------------------- OBTEBER EL ESTADO DEL FOLIO ----------------
cc_enviado="SELECT a.envi_ncorr, a.envi_fenvio, a.inen_ccod, instituciones_envio.inen_tdesc FROM ENVIOS a, instituciones_envio WHERE a.inen_ccod = instituciones_envio.inen_ccod AND a.envi_ncorr = " & folio_envio 
'response.Write("<pre>"&cc_cantidad&"  ACA</pre>")
'response.End()
estado_envio = conexion.consultaUno(cc_enviado)


'---------------------------PARA SABER SI HAY O NO DOC ASOCIADOS AL FOLIO -------
cc_cantidad="SELECT count (*) as cantidad FROM detalle_envios  WHERE detalle_envios.envi_ncorr=" & folio_envio
cantidad_doc = conexion.consultaUno(cc_cantidad)

'------------------------------------------------------------------------------
set f_listado = new CFormulario
f_listado.Carga_Parametros "edicion_envios_pagare.xml", "f_listado"
f_listado.Inicializar conexion




consulta = "SELECT e.ENVI_NCORR,"& vbCrLf &_
			"	di.DING_NDOCTO,"& vbCrLf &_
			"	di.DING_NDOCTO AS DING_NDOCTO2,"& vbCrLf &_
			"	edi.EDIN_TDESC,"& vbCrLf &_
			"	protic.obtener_rut(p.PERS_NCORR) as rut_alumno,"& vbCrLf &_
			"	protic.obtener_rut(di.pers_ncorr_codeudor) as rut_apoderado,"& vbCrLf &_
			"	protic.obtener_nombre_completo(di.pers_ncorr_codeudor,'n') AS nombre_apoderado,"& vbCrLf &_
			"	e.ENVI_FENVIO,"& vbCrLf &_
			"	di.DING_MDOCTO,"& vbCrLf &_
			" 	di.DING_FDOCTO"& vbCrLf &_
			"	FROM DETALLE_INGRESOS di"& vbCrLf &_
			"	INNER JOIN INGRESOS i"& vbCrLf &_
			"		ON i.INGR_NCORR = di.INGR_NCORR"& vbCrLf &_
			"	INNER JOIN DETALLE_ENVIOS de"& vbCrLf &_
			"		ON de.DING_NDOCTO = di.DING_NDOCTO AND de.INGR_NCORR=di.INGR_NCORR"& vbCrLf &_
			"	INNER JOIN ENVIOS e"& vbCrLf &_
			"		ON de.ENVI_NCORR=e.ENVI_NCORR"& vbCrLf &_
			"	INNER JOIN ESTADOS_ENVIO ee"& vbCrLf &_
			"		ON ee.EENV_CCOD = e.EENV_CCOD"& vbCrLf &_
			"	INNER JOIN PERSONAS p"& vbCrLf &_
			"		ON p.PERS_NCORR = i.PERS_NCORR"& vbCrLf &_
			"	INNER JOIN ESTADOS_DETALLE_INGRESOS edi"& vbCrLf &_
			"		ON edi.EDIN_CCOD=de.EDIN_CCOD"& vbCrLf &_
			"	WHERE e.ENVI_NCORR=" & folio_envio
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_listado.Consultar consulta



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

function eliminar(){
}

function agregar(){
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td align="center" valign="top" bgcolor="#EAEAEA"> <br>
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
                <td><%pagina.dibujarLenguetas array (array("Detalle de Documentos","Envios_Cobranza_Agregar1.asp")),1 %>
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
                  <td bgcolor="#D8D8DE">
				     <div align="center">&nbsp; <br>
                    <%pagina.DibujarTituloPagina%>
                    <br>
                    <br>
                  </div>
                    
                  <table width="100%" border="0">
                    <tr> 
                      <td width="8%">N&ordm; Folio</td>
                      <td width="2%">:</td>
                      <td width="14%"><font size="2"> 
                        <% f_envio.DibujaCampo("envi_ncorr") %>
                        </font></td>
                      <td width="8%">Notar&iacute;a</td>
                      <td width="2%">:</td>
                      <td width="37%"><font size="2"> 
                        <% f_envio.DibujaCampo("inen_tdesc") %>
                        </font></td>
                      <td width="7%">Fecha</td>
                      <td width="2%">:</td>
                      <td width="20%"><font size="2"> 
                        <% f_envio.DibujaCampo("envi_fenvio") %>
                        </font></td>
                    </tr>
                  </table>
                    
                  <br>
                  <table width="665" border="0">
                    <tr> 
                      <td width="116">&nbsp;</td>
                      <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                          <%f_listado.AccesoPagina%>
                        </div></td>
                      <td width="24"> <div align="right"> </div></td>
                    </tr>
                  </table> 
                  <form name="edicion">
                    <div align="center">
                      <%f_listado.dibujatabla%>
                    </div>
                  </form>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="431" bgcolor="#D8D8DE"><table width="97%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="13%" align="center"> <% botonera.DibujaBoton "anterior"%> </td>
                      <td width="27%" align="center"> 
					  <% if estado_envio <> "2" then 
					    botonera.agregabotonparam "agregar_pagare", "url" ,"Envios_Pagare_Buscar.asp?folio_envio="& folio_envio &"&tipo_empresa="& tipo_empresa
					    botonera.DibujaBoton "agregar_pagare"
						end if	  %> </td>
                      <td width="22%" align="center"> <%if (estado_envio <> "2" and cantidad_doc>0) then
					                       botonera.agregabotonparam "eliminar", "url", "Proc_Notaria_Eliminar_Pagare.asp"
						                   botonera.dibujaboton "eliminar"
										end if %> </td>
                      <td width="19%" align="center">
                        <% if cantidad_doc>0 then 
          botonera.AgregaBotonParam "excel","url","envios_notaria_pagare_excel.asp?folio_envio=" & folio_envio &"&empresa_envio=" & empresa_envio &"&fecha=" & DATE()
          botonera.DibujaBoton "excel"
		  end if  %>
                      </td>
                    </tr>
                  </table>
                </td>
                  <td width="12" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="234" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
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
