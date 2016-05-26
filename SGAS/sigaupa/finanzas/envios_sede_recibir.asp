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
'FECHA ACTUALIZACION 	:20/03/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			:92
'*******************************************************************
set pagina = new CPagina
pagina.Titulo = "Recepcionar documentos enviados entre Sedes"
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
botonera.Carga_Parametros "envios_sedes.xml", "botonera"
'--------------------------------------------------------------------------------------------
folio_envio = Request.QueryString("folio_envio")
set f_envio = new CFormulario

f_envio.Carga_Parametros "envios_sedes.xml", "f_envios"
f_envio.Inicializar conexion
consulta = "SELECT a.eenv_ccod, a.esed_ncorr, a.esed_fenvio, "& vbCrLf &_
         " b.sede_tdesc as sede_origen, c.sede_tdesc as sede_destino "& vbCrLf &_
         " FROM envios_sedes a, sedes b, sedes c "& vbCrLf &_
         " WHERE a.sede_origen = b.sede_ccod "& vbCrLf &_
		 " 	AND a.sede_destino = c.sede_ccod "& vbCrLf &_
         "	AND a.esed_ncorr = " & folio_envio 

 f_envio.Consultar consulta
 f_envio.siguiente
 estado_envio =  f_envio.obtenervalor("eenv_ccod")
'----------------------------------------------------------------------------
set f_detalle_envio = new CFormulario
f_detalle_envio.Carga_Parametros "envios_sedes.xml", "f_detalle_envio"
f_detalle_envio.Inicializar conexion

				
'consulta = " SELECT a.esed_ncorr, b.ting_ccod,b.ting_ccod as tipo_doc, b.ding_ndocto as c_ding_ndocto, b.ingr_ncorr ," & vbCrLf &_
'			"    b.ding_ndocto,  cast(cast(c.ding_mdocto as numeric)as varchar) as ding_mdocto, convert(varchar,d.ingr_fpago,103) as ingr_fpago,  " & vbCrLf &_
'			"    convert(varchar,c.ding_fdocto,103)  as ding_fdocto, c1.edin_ccod, c1.edin_tdesc, cast(e.pers_nrut as varchar) + '-' + e.pers_xdv as rut_alumno,  " & vbCrLf &_
'			"    cast(f.pers_nrut as varchar) + '-' + f.pers_xdv as rut_apoderado,  " & vbCrLf &_
'			"    protic.obtener_nombre(f.pers_ncorr,'n') as nombre_apoderado " & vbCrLf &_
'			"FROM envios_sedes a, detalle_envios_sedes b, detalle_ingresos c, estados_detalle_ingresos c1,  " & vbCrLf &_
'			"ingresos d, personas e, personas f   " & vbCrLf &_
'			"WHERE c.DING_NCORRELATIVO = 1  " & vbCrLf &_
'			"and a.esed_ncorr = b.esed_ncorr  " & vbCrLf &_
'			"and b.ting_ccod = c.ting_ccod  " & vbCrLf &_
'			"and b.ding_ndocto = c.ding_ndocto  " & vbCrLf &_
'			"and b.ingr_ncorr = c.ingr_ncorr  " & vbCrLf &_
'			"and c.ingr_ncorr = d.ingr_ncorr  " & vbCrLf &_
'			"and b.edin_ccod = c1.edin_ccod  " & vbCrLf &_
'			"and d.pers_ncorr = e.pers_ncorr " & vbCrLf &_
'			"and c.PERS_NCORR_CODEUDOR *= f.pers_ncorr  " & vbCrLf &_
'			"and a.esed_ncorr='" & folio_envio & "' " & vbCrLf &_
'			"ORDER BY  nombre_apoderado, b.ding_ndocto"

consulta = " SELECT a.esed_ncorr, b.ting_ccod,b.ting_ccod as tipo_doc, b.ding_ndocto as c_ding_ndocto, b.ingr_ncorr ," & vbCrLf &_
			"    b.ding_ndocto,  cast(cast(c.ding_mdocto as numeric)as varchar) as ding_mdocto, convert(varchar,d.ingr_fpago,103) as ingr_fpago,  " & vbCrLf &_
			"    convert(varchar,c.ding_fdocto,103)  as ding_fdocto, c1.edin_ccod, c1.edin_tdesc, cast(e.pers_nrut as varchar) + '-' + e.pers_xdv as rut_alumno,  " & vbCrLf &_
			"    cast(f.pers_nrut as varchar) + '-' + f.pers_xdv as rut_apoderado,  " & vbCrLf &_
			"    protic.obtener_nombre(f.pers_ncorr,'n') as nombre_apoderado " & vbCrLf &_
			"FROM envios_sedes a " & vbCrLf &_
			"INNER JOIN detalle_envios_sedes b " & vbCrLf &_
			"ON a.esed_ncorr = b.esed_ncorr and a.esed_ncorr='" & folio_envio & "' " & vbCrLf &_
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
                  <%pagina.dibujarLenguetas array (array("Detalle Documentos","Envios_Notaria_Agregar1.asp")),1 %>
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
                      <td width="15%">N&ordm; Folio</td>
                      <td width="3%">:</td>
                      <td width="30%"><font size="2"> 
                        <% f_envio.DibujaCampo("esed_ncorr") %>
                        </font></td>
					  <td width="21%">Fecha</td>
                      <td width="2%">:</td>
                      <td width="29%"><font size="2"> 
                        <% f_envio.DibujaCampo("esed_fenvio") %>
                        </font></td>
					</tr>
					<tr>
                      <td width="15%">Sede Origen</td>
                      <td width="3%">:</td>
                      <td width="30%"><font size="2"> 
                        <% f_envio.DibujaCampo("sede_origen") %>
                        </font></td>
 					  <td width="21%">Sede Destino</td>
                      <td width="2%">:</td>
                      <td width="29%"><font size="2"> 
                        <% f_envio.DibujaCampo("sede_destino") %>
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
                          <%  botonera.agregabotonparam "anterior", "url", "recepcionar_envios_sedes.asp?esed_ncorr="& folio_envio
						      botonera.DibujaBoton "anterior"  %>
                        </div></td>
                      <td width="14%">
					  </td>
                      <td width="14%"><% if estado_envio = "1" or estado_envio = "6" then
					                        botonera.agregabotonparam "devolver", "deshabilitado" ,"TRUE"
										 end if 
					                       botonera.agregabotonparam "devolver", "url", "envios_sede_eliminar_doc.asp"
						                   botonera.dibujaboton "devolver"
										 %> </td>
                      <td width="15%">  </td>
                      <td width="43%"></td>
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
