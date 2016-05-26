<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
codigo= request.QueryString("codigo")

set pagina = new CPagina
pagina.Titulo = "Mantenedor De Módulos"

set botonera =  new CFormulario
botonera.carga_parametros "editar_modulos.xml", "btn_edita_modulos"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
periodo = negocio.obtenerPeriodoAcademico("Postulacion")
'---------------------------------------------------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "editar_modulos.xml", "edicion_modulos"
formulario.inicializar conexion

if codigo <> "" then 
consulta= "SELECT mote_ccod, mote_tdesc " & vbCrlf & _
		  " FROM modulos_otec " & vbCrlf & _
          " WHERE mote_ccod = '" & codigo & "'" 
else
consulta = "select '' as mote_ccod, '' as mote_tdesc"
end if

'response.write("<pre>"&consulta&"</pre>")
formulario.consultar consulta 
if codigo <> "" then
	formulario.agregacampocons "mote_ccod", codigo
	formulario.agregacampocons "codigo", codigo
end if
formulario.siguiente

lenguetas_masignaturas = Array(Array("Datos De La Asignatura", "editar_modulos.asp?mote_ccod="&codigo))
'response.Write("doras "&horas_Asignatura&" duracion "&duracion_asignatura)
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
function guardar(formulario){

if(preValidaFormulario(formulario))
    {	
    	formulario.action ='actualizar_modulos.asp';
		formulario.submit();
	}
	
}
function volver(){
	CerrarActualizar();
}

function validaCambios(){
	alert("..");
	return false;
}

</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="380" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas lenguetas_masignaturas, 1%> </td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
              <form name="edicion" method="post"><table width="100%"  border="0">
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><%pagina.DibujarSubtitulo "Datos Del Módulo"%></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
</table>

                    <table width="98%" align="center">
                      <tr> 
                        <td width="25%"><strong>C&oacute;digo</strong></td>
                        <td width="75%">:<% if codigo <> "" and not esVacio(codigo) then
						                     	formulario.agregaCampoParam "mote_ccod","permiso","OCULTO"
												formulario.dibujaCampo("mote_ccod")
												response.Write(formulario.obtenerValor("mote_ccod"))
											else	
						                        formulario.agregaCampoParam "mote_ccod","permiso","LECTURAESCRITURA"
												formulario.dibujaCampo("mote_ccod")
											end if%>
						</td>
                      </tr>
                      <tr> 
                        <td><strong>Nombre </strong></td>
                        <td>:<%=formulario.dibujaCampo("mote_tdesc")%><input type="hidden" name="modifica" value="<%=codigo%>"></td>
                      </tr>
                      <tr> 
                        <td valign="top" colspan="2">&nbsp;</td></tr>
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
                  <td><div align="center"><%botonera.dibujaboton "guardar"%></div></td>
                  <td><div align="center"><%botonera.dibujaboton "volver"%></div></td>
                  <td><div align="center"></div></td>
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
	</td>
  </tr>  
</table>
</body>
</html>
