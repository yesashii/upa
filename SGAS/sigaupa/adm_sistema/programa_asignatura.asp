<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
codigo= request.QueryString("asig_ccod")
upro_ccod = request.QueryString("upro_ccod")
vacio= true
set pagina = new CPagina
pagina.Titulo = "Mantenedor De Asignaturas"

set botonera =  new CFormulario
botonera.carga_parametros "programa_asignatura.xml", "btn_programa_asignaturas"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores = new CErrores
'---------------------------------------------------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "programa_asignatura.xml", "f_programa_asignatura"
formulario.inicializar conexion

set f_tabla = new cformulario
f_tabla.carga_parametros "programa_asignatura.xml", "f_programa_asignatura_tabla"
f_tabla.inicializar conexion

if pras_ccod="" or isnull(pras_ccod) or isempty(pras_ccod) then
	pras_ccod =conexion.consultauno("select pras_ccod from asignaturas where asig_ccod = '"&codigo&"'")
else
vacio = false
end if 

consulta=   " select upro_tdesc,upro_nnumero," & _ 
"'"&codigo&"' as asig_ccod,upro_ccod,'"&PRAS_CCOD&"' AS PRAS_CCOD,UPRO_NHORAS" & _
" from " & _
" programa_asignaturas a,unidades_programa b " & _
" where a.pras_ccod = b.pras_ccod " & _
" and cast(a.pras_ccod as varchar)='"&pras_ccod&"' " 



consulta2=   " select * from " & _
" programa_asignaturas a,unidades_programa b " & _
" where a.pras_ccod = b.pras_ccod " & _
" and cast(b.upro_ccod as varchar)='"&upro_ccod&"' "

formulario.consultar consulta2
f_tabla.consultar consulta

if codigo <> "" then
	formulario.agregacampocons "asig_ccod", codigo
	formulario.agregacampocons "codigo", codigo
end if
formulario.siguiente


lenguetas_masignaturas = Array(Array("Datos De La Asignatura", "editar_asignatura.asp?asig_ccod="&codigo), Array("Programa De La Asignatura", "programa_asignatura.asp?asig_ccod="&codigo))

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
if(preValidaFormulario(formulario)){	
    formulario.action ='actualizar_unidades.asp';
	formulario.submit();
	}
}
function enviar(){
	window.navigate("programa_asignatura.asp?asig_ccod="+"<%=codigo%>")
}
function eliminar(formulario){
    formulario.action ='eliminar_unidades.asp';
	formulario.submit();

}

</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
            <td><%pagina.DibujarLenguetas lenguetas_masignaturas, 2%> </td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
              <table width="100%"  border="0">
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><%pagina.DibujarSubtitulo "Datos De La Unidad"%></td>
  </tr>
  <tr>
    <td><div align="right"><font color="#CC3300">*</font> Campos Obligatorios</div></td>
  </tr>
</table>
<form name="edicion" method="post">
  <input type="hidden" name="asig_ccod" value="<%=codigo%>">
  <input type="hidden" name="upro_ccod" value="<%=upro_ccod%>">
                <table width="90%"  border="0" align="center">
                  <tr>
                    <td width="28%"><div align="right"><strong><font color="#CC3300">*</font>Nombre De La Unidad : </strong></div></td>
                    <td width="72%"><%=formulario.dibujaCampo("upro_tdesc")%></td>
                  </tr>
                  <tr>
                    <td><div align="right"><strong><font color="#CC3300">*</font>N&uacute;mero De La Unidad :</strong></div></td>
                    <td><%=formulario.dibujaCampo("upro_nnumero")%></td>
                  </tr>
                  <tr>
                    <td><div align="right"><strong>N&deg; De Horas De LaUnidad : </strong></div></td>
                    <td><%=formulario.dibujaCampo("UPRO_NHORAS")%></td>
                  </tr>
                  <tr>
                    <td><div align="right"><strong>Objetivo De La Unidad : </strong></div></td>
                    <td><%=formulario.dibujaCampo("upro_tobjetivo")%></td>
                  </tr>
                  <tr>
                    <td><div align="right"><strong>Contenidos : </strong></div></td>
                    <td><%=formulario.dibujaCampo("upro_tcontenido")%></td>
                  </tr>
                  <tr>
                    <td><div align="right"><strong>M&eacute;todos De Ense&ntilde;anza : </strong></div></td>
                    <td><%=formulario.dibujaCampo("upro_tmetodo")%></td>
                  </tr>
                  <tr>
                    <td><div align="right"><strong>Bibliograf&iacute;a : </strong></div></td>
                    <td><%=formulario.dibujaCampo("upro_tbiblio")%></td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                  </tr>
                </table></form>
                <table width="100%"  border="0">
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td></td>
  </tr>
  <tr>
    <td><%pagina.DibujarSubtitulo "Listado De Unidades"%></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><div align="center"><form name="lista_unidad" method="post">
      <input type="hidden" name="PRAS_CCOD" value="<%=PRAS_CCOD%>">
      <%f_tabla.dibujatabla()%></form></div></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
</table>


             </td></tr>
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
                  <td><div align="center">                    
                    <%botonera.dibujaboton "eliminar"%>
                  </div></td>
                  <td><div align="center">
                    <%botonera.dibujaboton "limpiar"%>
                  </div></td>
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
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
