<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
	'response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

pers_ncorr=request.QueryString("pers_ncorr")

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

Set errores= New CErrores

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------

rut_temporal = request.Form("padre[0][pers_nrut]")
xdv_temporal = request.Form("padre[0][pers_xdv]")



'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Editar Sicólogo"


set f_botonera = new CFormulario
f_botonera.Carga_Parametros "mantenedor_sicologos.xml", "botonera"



'---------------------------------------------------------------------------------------------------
set f_sicologo = new CFormulario
f_sicologo.Carga_Parametros "mantenedor_sicologos.xml", "editar"
f_sicologo.Inicializar conexion

consulta = "select sico_ncorr,a.pers_ncorr,pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre,"& vbCrLf &_
"cast(pers_nrut as varchar)+'-'+pers_xdv as rut,lower(email_upa)as email,"& vbCrLf &_
"(select count(*) from  sicologos_sede c where c.sico_ncorr=b.sico_ncorr and c.sede_ccod=1)as lascondes,"& vbCrLf &_
"(select count(*) from  sicologos_sede c where c.sico_ncorr=b.sico_ncorr and c.sede_ccod=8)as baquedano,"& vbCrLf &_
"(select count(*) from  sicologos_sede c where c.sico_ncorr=b.sico_ncorr and c.sede_ccod=2)as lyon,"& vbCrLf &_
"(select count(*) from  sicologos_sede c where c.sico_ncorr=b.sico_ncorr and c.sede_ccod=4)as melipilla"& vbCrLf &_
"from personas a,"& vbCrLf &_
"sicologos b"& vbCrLf &_
"where a.PERS_NCORR=b.pers_ncorr"& vbCrLf &_
"and a.PERS_NCORR="&pers_ncorr&""


'response.Write("<pre>" & consulta & "</pre>")
 'response.end() 
f_sicologo.Consultar consulta
f_sicologo.Siguientef


 
 
'-------------------------------------------------------------------------------------


'v_epos_ccod = conexion.ConsultaUno("select epos_ccod from postulantes where post_ncorr = '" & v_post_ncorr & "'")
'response.Write(v_post_ncorr)

	
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
<script language="JavaScript" src="../biblioteca/dicc_ciudades.js"></script>

<script language="JavaScript">
</script>
<style type="text/css">
<!--
.style1 {color: #FF0000}
.Estilo2 {color: #FF0000; font-weight: bold; }
-->
</style>
</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');">

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
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTitulo "Datos Sicólogo" %>
              <br>
              <br>
              <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td><div align="justify"><%=msjRecordatorio%></div></td>
                </tr>
              </table>
			</div>
              <form name="edicion" >
			  <input type="hidden" name="b[0][sico_ncorr]" value="<%=f_sicologo.ObtenerValor("sico_ncorr")%>">
			   <input type="hidden" name="b[0][pers_ncorr]" value="<%=f_sicologo.ObtenerValor("pers_ncorr")%>">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Familiar"%>
                        <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" >
                          <tr>
                            <td width="20%"><strong> R.U.T.</strong><br>
                                <%f_sicologo.DibujaCampo("rut")%></td>
                            <td width="30%"><strong>Nombre </strong><br>
                                <%f_sicologo.DibujaCampo("nombre")%>                            </td>
                            <td width="30%"><strong>Correo</strong><br>
                                <%f_sicologo.DibujaCampo("email")%></td>
                          </tr>
                          <tr>
                            <td><table width="100%">
                                <tr>
                                  <td width="43%"><strong>Las Condes </strong></td>
                                  <td width="57%"><%f_sicologo.DibujaCampo("lascondes")%></td>
                                </tr>
                                <tr>
                                  <td><strong>Baquedano </strong></td>
                                  <td><%f_sicologo.DibujaCampo("baquedano")%></td>
                                </tr>
                                <tr>
                                  <td><strong>Lyon </strong></td>
                                  <td><%f_sicologo.DibujaCampo("lyon")%></td>
                                </tr>
                                <tr>
                                  <td><strong>Melipilla </strong></td>
                                  <td><%f_sicologo.DibujaCampo("melipilla")%></td>
                                </tr>
                            </table></td>
                          </tr>
                        </table>
                      <br>                    </td>
                  </tr>
                </table>
              </form></td></tr>
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
                  <td align="center">
                    <%f_botonera.DibujaBoton("vovler")%>
                  </td>
                  <td align="center">
                    <%f_botonera.DibujaBoton("guardar2")%>
                  </td>
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
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
