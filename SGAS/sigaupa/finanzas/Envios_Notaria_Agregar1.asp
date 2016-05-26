<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO:GESTIÓN DE DOCUMENTOS
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:12/03/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			:108
'********************************************************************
set pagina = new CPagina
pagina.Titulo = "Detalle de Letras del Envío a notaría"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'--------------------------------------------------------------------------------------------
'para que me puedea entregar ultima postulacion del alumno 
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'---------------------------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Envios_Notaria.xml", "botonera"
'--------------------------------------------------------------------------------------------
folio_envio = Request.QueryString("folio_envio")
set f_envio = new CFormulario

f_envio.Carga_Parametros "Envios_Notaria.xml", "f_envios"
f_envio.Inicializar conexion
consulta = "SELECT envios.eenv_ccod, envios.envi_ncorr, envios.envi_fenvio, envios.inen_ccod, "& vbCrLf &_
         "instituciones_envio.inen_tdesc  "& vbCrLf &_
         "FROM envios, instituciones_envio "& vbCrLf &_
         "WHERE envios.inen_ccod = instituciones_envio.inen_ccod "& vbCrLf &_
         "AND envios.envi_ncorr = " & folio_envio 

 f_envio.Consultar consulta
 f_envio.siguiente
 estado_envio =  f_envio.obtenervalor("eenv_ccod")
'----------------------------------------------------------------------------
set f_detalle_envio = new CFormulario
f_detalle_envio.Carga_Parametros "Envios_Notaria.xml", "f_detalle_envio"
f_detalle_envio.Inicializar conexion

'consulta  =	"SELECT a.envi_ncorr, b.ting_ccod, b.ding_ndocto as c_ding_ndocto, b.ingr_ncorr ,b.ding_ndocto,  to_number(c.ding_mdocto) as ding_mdocto, trunc(d.ingr_fpago) as ingr_fpago,  "& vbCrLf &_
'					   "c.ding_fdocto, c1.edin_ccod, c1.edin_tdesc, e.pers_nrut || '-' || e.pers_xdv as rut_alumno,  "& vbCrLf &_
'					   "f.pers_nrut || '-' || f.pers_xdv as rut_apoderado,  "& vbCrLf &_
'					   "f.pers_tnombre || ' ' || f.pers_tape_paterno as nombre_apoderado "& vbCrLf &_  
'				"FROM envios a, detalle_envios b, detalle_ingresos c, estados_detalle_ingresos c1,  "& vbCrLf &_
'					 "ingresos d, personas e, personas f   "& vbCrLf &_
'				"WHERE c.DING_NCORRELATIVO = 1  "& vbCrLf &_
'				  "and a.envi_ncorr = b.envi_ncorr  "& vbCrLf &_
'				  "and b.ting_ccod = c.ting_ccod  "& vbCrLf &_
'				  "and b.ding_ndocto = c.ding_ndocto  "& vbCrLf &_
'				  "and b.ingr_ncorr = c.ingr_ncorr  "& vbCrLf &_
'				  "and c.ingr_ncorr = d.ingr_ncorr  "& vbCrLf &_
'				  "and b.edin_ccod = c1.edin_ccod  "& vbCrLf &_
'				  "and d.pers_ncorr = e.pers_ncorr "& vbCrLf &_
'				  "and c.PERS_NCORR_CODEUDOR = f.pers_ncorr (+)  "& vbCrLf &_
'				  "and a.envi_ncorr='" & folio_envio & "' " & vbCrLf &_
'				"ORDER BY  nombre_apoderado, b.ding_ndocto" 
				
'consulta = "SELECT a.envi_ncorr, b.ting_ccod, b.ding_ndocto as c_ding_ndocto, b.ingr_ncorr ," & vbCrLf &_
'			"    b.ding_ndocto,  cast(cast(c.ding_mdocto as numeric)as varchar) as ding_mdocto, convert(varchar,d.ingr_fpago,103) as ingr_fpago,  " & vbCrLf &_
'			"    convert(varchar,c.ding_fdocto,103)  as ding_fdocto, c1.edin_ccod, c1.edin_tdesc, cast(e.pers_nrut as varchar) + '-' + e.pers_xdv as rut_alumno,  " & vbCrLf &_
'			"    cast(f.pers_nrut as varchar) + '-' + f.pers_xdv as rut_apoderado,  " & vbCrLf &_
'			"    protic.obtener_nombre(f.pers_ncorr,'n') as nombre_apoderado " & vbCrLf &_
'			"FROM envios a, detalle_envios b, detalle_ingresos c, estados_detalle_ingresos c1,  " & vbCrLf &_
'			"ingresos d, personas e, personas f   " & vbCrLf &_
'			"WHERE c.DING_NCORRELATIVO = 1  " & vbCrLf &_
'			"and a.envi_ncorr = b.envi_ncorr  " & vbCrLf &_
'			"and b.ting_ccod = c.ting_ccod  " & vbCrLf &_
'			"and b.ding_ndocto = c.ding_ndocto  " & vbCrLf &_
'			"and b.ingr_ncorr = c.ingr_ncorr  " & vbCrLf &_
'			"and c.ingr_ncorr = d.ingr_ncorr  " & vbCrLf &_
'			"and b.edin_ccod = c1.edin_ccod  " & vbCrLf &_
'			"and d.pers_ncorr = e.pers_ncorr " & vbCrLf &_
'			"and c.PERS_NCORR_CODEUDOR *= f.pers_ncorr  " & vbCrLf &_
'			"and a.envi_ncorr='" & folio_envio & "' " & vbCrLf &_
'			"ORDER BY  nombre_apoderado, b.ding_ndocto"

consulta = "SELECT a.envi_ncorr, b.ting_ccod, b.ding_ndocto as c_ding_ndocto, b.ingr_ncorr ," & vbCrLf &_
			"    b.ding_ndocto,  cast(cast(c.ding_mdocto as numeric)as varchar) as ding_mdocto, convert(varchar,d.ingr_fpago,103) as ingr_fpago,  " & vbCrLf &_
			"    convert(varchar,c.ding_fdocto,103)  as ding_fdocto, c1.edin_ccod, c1.edin_tdesc, cast(e.pers_nrut as varchar) + '-' + e.pers_xdv as rut_alumno,  " & vbCrLf &_
			"    cast(f.pers_nrut as varchar) + '-' + f.pers_xdv as rut_apoderado,  " & vbCrLf &_
			"    protic.obtener_nombre(f.pers_ncorr,'n') as nombre_apoderado " & vbCrLf &_
			"FROM envios a " & vbCrLf &_
			"INNER JOIN detalle_envios b " & vbCrLf &_
			"ON a.envi_ncorr = b.envi_ncorr " & vbCrLf &_
			"INNER JOIN detalle_ingresos c " & vbCrLf &_
			"ON b.ting_ccod = c.ting_ccod and b.ding_ndocto = c.ding_ndocto and b.ingr_ncorr = c.ingr_ncorr AND c.DING_NCORRELATIVO = 1 " & vbCrLf &_
			"INNER JOIN ingresos d " & vbCrLf &_
			"ON c.ingr_ncorr = d.ingr_ncorr " & vbCrLf &_
			"INNER JOIN estados_detalle_ingresos c1 " & vbCrLf &_
			"ON b.edin_ccod = c1.edin_ccod " & vbCrLf &_
			"INNER JOIN personas e " & vbCrLf &_
			"ON d.pers_ncorr = e.pers_ncorr " & vbCrLf &_
			"LEFT OUTER JOIN personas f " & vbCrLf &_
			"ON c.PERS_NCORR_CODEUDOR = f.pers_ncorr " & vbCrLf &_
			"WHERE a.envi_ncorr = '" & folio_envio & "' " & vbCrLf &_
			"ORDER BY  nombre_apoderado, b.ding_ndocto"

'response.Write("<pre>"&consulta&"</pre>")		 
'response.End()
'response.Write("<PRE>" & consulta & "</PRE>")
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
<script language='javaScript1.2'> 
  colores = Array(3);
  colores[0] = ''; 
  colores[1] = '#97AAC6'; 
  colores[2] = '#C0C0C0'; 
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
                <td>
                  <%pagina.dibujarLenguetas array (array("Detalle Letras","Envios_Notaria_Agregar1.asp"),array("Letras por Apoderado","Envios_Notaria_Agregar2.asp?folio_envio="& folio_envio)),1 %>
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
                    <BR><BR>
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
                  <BR><BR>
				  <div align="center"> 
                    <table width="665" border="0">
                      <tr> 
                        <td width="116">&nbsp;</td>
                        <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                            <%f_detalle_envio.AccesoPagina%>
                          </div></td>
                        <td width="24"> <div align="right"> </div></td>
                      </tr>
                    </table>
                  </div>
                  <form name="edicion">
				    <% f_detalle_envio.DibujaTabla() %>
				  </form>
				    
                  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="126" bgcolor="#D8D8DE"><table width="97%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="14%"> <div align="left"> 
                          <%  botonera.agregabotonparam "anterior", "url", "Envios_Notaria.asp?envi_ncorr="& folio_envio
						      botonera.DibujaBoton "anterior"  %>
                        </div></td>
                      <td width="14%"> <%    if estado_envio = "2" then
						         botonera.agregabotonparam "agregar_letras", "deshabilitado" ,"TRUE"
							  end if
					              botonera.agregabotonparam "agregar_letras", "url" ,"Envios_Notaria_Buscar.asp?folio_envio="& folio_envio 
					              botonera.DibujaBoton "agregar_letras"
					   %> </td>
                      <td width="14%"><% if estado_envio = "2" then
					                        botonera.agregabotonparam "eliminar", "deshabilitado" ,"TRUE"
										 end if 
					                       botonera.agregabotonparam "eliminar", "url", "Envios_Notaria_Eliminar_Letra.asp"
						                   botonera.dibujaboton "eliminar"
										 %> </td>
                      <td width="15%">
                        <% botonera.AgregaBotonParam "excel","url","Envios_Notaria_Excel.asp?folio_envio=" & folio_envio
					                    botonera.DibujaBoton ("excel") %>
                      </td>
                      <td width="43%"><div align="left"></div>
                        <div align="left">
                          <% botonera.AgregaBotonParam "imprimir","url","../REPORTESNET/detalle_envio_notaria.aspx?folio_envio=" & folio_envio & "&periodo=" & Periodo
					          botonera.DibujaBoton ("imprimir") %>
                        </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="369" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="182" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
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
