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
'LINEA			:93
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
consulta = "SELECT envios.eenv_ccod, envios.envi_ncorr, envios.envi_fenvio, envios.inen_ccod, "&_
         "instituciones_envio.inen_tdesc  "&_
         "FROM envios, instituciones_envio "&_
         "WHERE envios.inen_ccod = instituciones_envio.inen_ccod "&_
         "AND envios.envi_ncorr = " & folio_envio 
 f_envio.Consultar consulta
 f_envio.siguiente
'----------------------------------------------------------------------------
set f_detalle_envio = new CFormulario
f_detalle_envio.Carga_Parametros "Envios_Notaria.xml", "f_detalle_agrupado"
f_detalle_envio.Inicializar conexion

'consulta = "SELECT   a.envi_ncorr, a.envi_ncorr as c_envi_ncorr, c.pers_ncorr, "& vbCrLf &_
'					" f.pers_nrut as r_alumno, f.pers_xdv,  "& vbCrLf &_
'					" cast(f.pers_nrut as varchar) + '-' + f.pers_xdv as rut_alumno,  "& vbCrLf &_
'					" cast(f.pers_nrut as varchar) + '-' + f.pers_xdv as c_rut_alumno,  "& vbCrLf &_
'					" isnull(cast(g.pers_nrut as varchar),' ') as code_nrut , isnull(cast(g.pers_xdv as varchar),' ') as code_xdv,  "& vbCrLf &_
'					" isnull(cast(g.pers_nrut as varchar),' ') as  r_apoderado,  "& vbCrLf &_
'					" isnull(cast(g.pers_nrut as varchar),' ') + '-' + isnull(cast(g.pers_xdv as varchar),' ') as rut_apoderado,  "& vbCrLf &_
'					" isnull(cast(g.pers_nrut as varchar),' ') + '-' + isnull(cast(g.pers_xdv as varchar),' ') as c_rut_apoderado,  "& vbCrLf &_
'					" isnull(cast(g.pers_tnombre as varchar), ' ') + ' ' + isnull(cast(g.pers_tape_paterno as varchar),' ') as nombre_apoderado,  "& vbCrLf &_
'					"count(a.envi_ncorr) as documentos  "& vbCrLf &_
'			"FROM  detalle_envios a,  detalle_ingresos b,  ingresos c,  "& vbCrLf &_
'				  " personas f,   personas g  "& vbCrLf &_
'			"WHERE b.DING_NCORRELATIVO = 1  "& vbCrLf &_
'			  "and a.ting_ccod = b.ting_ccod "& vbCrLf &_
'			  "and a.ding_ndocto = b.ding_ndocto "& vbCrLf &_
'			  "and a.ingr_ncorr = b.ingr_ncorr "& vbCrLf &_
'			  "and b.ingr_ncorr = c.ingr_ncorr "& vbCrLf &_
'			  "and c.pers_ncorr = f.pers_ncorr "& vbCrLf &_
'			  "and b.PERS_NCORR_CODEUDOR *= g.pers_ncorr "& vbCrLf &_ 
'			  "AND a.envi_ncorr='" & folio_envio & "' " & vbCrLf &_
'			"GROUP BY a.envi_ncorr, c.pers_ncorr, f.pers_xdv, g.pers_xdv,   "& vbCrLf &_
'				  "g.pers_tape_paterno, g.pers_tnombre, f.pers_nrut ,g.pers_nrut "& vbCrLf &_
'			"ORDER BY nombre_apoderado"

consulta = "SELECT   a.envi_ncorr, a.envi_ncorr as c_envi_ncorr, c.pers_ncorr, "& vbCrLf &_
					" f.pers_nrut as r_alumno, f.pers_xdv,  "& vbCrLf &_
					" cast(f.pers_nrut as varchar) + '-' + f.pers_xdv as rut_alumno,  "& vbCrLf &_
					" cast(f.pers_nrut as varchar) + '-' + f.pers_xdv as c_rut_alumno,  "& vbCrLf &_
					" isnull(cast(g.pers_nrut as varchar),' ') as code_nrut , isnull(cast(g.pers_xdv as varchar),' ') as code_xdv,  "& vbCrLf &_
					" isnull(cast(g.pers_nrut as varchar),' ') as  r_apoderado,  "& vbCrLf &_
					" isnull(cast(g.pers_nrut as varchar),' ') + '-' + isnull(cast(g.pers_xdv as varchar),' ') as rut_apoderado,  "& vbCrLf &_
					" isnull(cast(g.pers_nrut as varchar),' ') + '-' + isnull(cast(g.pers_xdv as varchar),' ') as c_rut_apoderado,  "& vbCrLf &_
					" isnull(cast(g.pers_tnombre as varchar), ' ') + ' ' + isnull(cast(g.pers_tape_paterno as varchar),' ') as nombre_apoderado,  "& vbCrLf &_
					"count(a.envi_ncorr) as documentos  "& vbCrLf &_
			"FROM detalle_envios a INNER JOIN detalle_ingresos b "& vbCrLf &_
			"ON a.ting_ccod = b.ting_ccod and a.ding_ndocto = b.ding_ndocto and a.ingr_ncorr = b.ingr_ncorr and b.DING_NCORRELATIVO = 1 "& vbCrLf &_
			"INNER JOIN ingresos c "& vbCrLf &_
			"ON b.ingr_ncorr = c.ingr_ncorr "& vbCrLf &_
			"INNER JOIN personas f "& vbCrLf &_
			"ON c.pers_ncorr = f.pers_ncorr "& vbCrLf &_
			"LEFT OUTER JOIN personas g "& vbCrLf &_
			"ON b.PERS_NCORR_CODEUDOR = g.pers_ncorr "& vbCrLf &_
			"WHERE a.envi_ncorr = '" & folio_envio & "' " & vbCrLf &_
			"GROUP BY a.envi_ncorr, c.pers_ncorr, f.pers_xdv, g.pers_xdv,   "& vbCrLf &_
				  "g.pers_tape_paterno, g.pers_tnombre, f.pers_nrut ,g.pers_nrut "& vbCrLf &_
			"ORDER BY nombre_apoderado"

'response.Write("<pre>"&consulta&"</pre>")
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
function abrir()  
   {
	 resultado = window.open("Envios_Notaria_MLetra.asp","","toolbar=no, resizable=no,left=150,top=200,width=415,height=205");
   }
</script>
<script language='javaScript1.2'> 
  colores = Array(3);
  colores[0] = ''; 
  colores[1] = '#97AAC6'; 
  colores[2] = '#C0C0C0'; 
</script>
</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<BR>
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
                  <%pagina.dibujarLenguetas array (array("Detalle Letras","Envios_Notaria_Agregar1.asp?folio_envio="&folio_envio),array("Letras por Apoderado","Envios_Notaria_Agregar2.asp")),2 %>
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
                    <form name="edicion">
                    <div align="center"><BR>
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
                  </form>                   <BR>
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
                    <BR>
                  </div>
                  <div align="center">
                    <% f_detalle_envio.DibujaTabla %>
                    <br> <BR>
                  </div></td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                <td width="199" bgcolor="#D8D8DE"><table width="78%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="38%">
                        <div align="center">
                          <%  botonera.agregabotonparam "anterior", "url", "Envios_Notaria_Agregar1.asp?folio_envio=" & folio_envio 
					  botonera.DibujaBoton "anterior" %>
                          </div></td>
                      <td width="38%"><div align="center">
                        <% 
							if f_detalle_envio.NroFilas = "0" then
							   botonera.agregabotonparam "imprimir", "deshabilitado" ,"TRUE"
							end if
							botonera.agregabotonparam "imprimir", "url", "../REPORTESNET/documento_banco.aspx?folio_envio=" & folio_envio & "&periodo=" & Periodo & "&informe=3"
							botonera.DibujaBoton ("imprimir")
						%>
                      </div></td>
                    </tr>
                  </table>
                </td>
                <td width="163" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
              </tr>
              <tr>
                <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
              </tr>
            </table>
        </td>
      </tr>
    </table>
	<BR>
	<br>
    </td>
  </tr>  
</table>
</body>
</html>
