<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "mantener permisos"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'---------------------------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Mant_Permisos.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f2 = new CFormulario
f2.Carga_Parametros "Mant_Permisos.xml", "fselect"
'srol_ccod = request.Form("roles[0][srol_ccod]")  'nombre de la variable

srol_ccod = request.QueryString("roles[0][srol_ccod]")

f2.Inicializar conexion
f2.Consultar "select '' "
f2.AgregaCampoCons "srol_ccod", srol_ccod   'le agrego un campo a la consulta
f2.Siguiente
ultimo = srol_ccod

 set formulario = new CFormulario
 formulario.Carga_Parametros "Mant_Permisos.xml", "fpermisos"
 formulario.Inicializar conexion

consulta = " select a.smet_ccod,a.srol_ncorr, "& vbcrlf  & _
" b.srol_tdesc,a.smod_ccod,c.smod_tdesc, "& vbcrlf  & _
" d.sfun_ccod,d.sfun_tdesc,convert(datetime,a.sper_fmodificacion,103) as sper_fmodificacion"& vbcrlf  & _
" from sis_permisos a, sis_roles b, "& vbcrlf  & _
" sis_modulos c,sis_funciones_modulos d "& vbcrlf  & _
" where a.srol_ncorr = b.srol_ncorr "& vbcrlf  & _
" and a.sfun_ccod =d.sfun_ccod "& vbcrlf  & _
" and d.smod_ccod = c.smod_ccod "& vbcrlf  & _
" AND (a.srol_ncorr =cast(cast('" & ultimo & "' as real) as numeric)) "& vbcrlf  & _
"ORDER BY c.smod_tdesc , d.sfun_tdesc"

'response.Write("<pre>"&consulta&"</pre>")

			formulario.Consultar consulta


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

function cargar()
{
  edicion.action="Mant_Permisos.asp?roles[0][srol_ccod]=" + document.edicion.elements["roles[0][srol_ccod]"].value;
  edicion.method="POST";
  edicion.submit();
}

</script>

</head>
<style>
<!--

select {  
	font-family: Verdana, Arial, Helvetica, sans-serif; 
	font-size: 9px; 
	background-color: #FFFFFF
}

-->
</style>

<body  onBlur="revisaVentana()" bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
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
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Mantenedor
                          de Permisos</font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
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
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  
                <td bgcolor="#D8D8DE"> <div align="center">&nbsp; <BR>
                    <%pagina.DibujarTituloPagina%>
                    <table width="100%" border="0">
                      <tr> 
                        <td width="116">&nbsp;</td>
                        <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                            <%formulario.AccesoPagina%>
                          </div></td>
                        <td width="24"> <div align="right"> </div></td>
                      </tr>
                    </table>
                  </div>
                  <form name="edicion">
					<table width="100%" border="0">
                      <tr> 
                        <td width="24%"><div align="right">Listado de Roles</div></td>
                        <td width="4%"><div align="center">:</div></td>
                        <td width="72%"><% f2.dibujaCampo ("srol_ccod")  'dibujo el objeto Select %> </td>
                      </tr>
                    </table>
                    <div align="center"><br>
                      <% formulario.DibujaTabla %>
                    </div>
                  </form>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="77" bgcolor="#D8D8DE"> 
                    <div align="left">                      
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td width="8%" height="0"><%'pagina.DibujarBoton "Eliminar", "ELIMINAR-edicion", "Mant_Funciones_Eliminar.asp"
						  botonera.dibujaboton "eliminar"%> </td>
                        <td width="12%">
                          <% if ultimo <> "" then
						        botonera.agregabotonparam "agregar", "url", "Mant_Permisos_Agregar.asp?codigo_rol=" & ultimo 
						        botonera.dibujaboton "agregar" 
							 end if	%>
                        </td>
                        <td width="80%">
                          <% botonera.dibujaboton "lanzadera" 	%>
                        </td>
                      </tr>
                    </table>
                  </div></td>
                  <td width="285" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<p><br>
			<p><br>
			<p><br>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
