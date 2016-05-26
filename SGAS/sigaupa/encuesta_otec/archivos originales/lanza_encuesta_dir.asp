<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/revisa_session_encuesta_docente_rr_hh.asp"-->

<%

'---------------------------------------------------------------------------------------------------
'set pagina = new CPagina
'pagina.Titulo = "Encuesta Así soy yo"
'---------------------------------------------------------------------------------------------------

'secc_ccod=request.Form("secc")
set conexion = new CConexion
conexion.Inicializar "upacifico"
'
set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "encuesta_docente_rr_hh.xml", "botonera"

set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "encuesta_docente_rr_hh.xml", "encabezado"
f_encabezado.Inicializar conexion

'pers_ncorr=conexion.ConsultaUno("select protic.obtener_pers_ncorr("&q_pers_nrut&")")
consulta = "select ''" 
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_encabezado.Consultar consulta
f_encabezado.Siguiente



%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>- Encuesta Universidad del Pac&iacute;fico</title>

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

function ir()
{

window.location=("portada_encuesta.asp")
}



</script>
</head>

<body onload="ir();">

<p align="center"><span class="Estilo34">  </span></p>
<table width="100%" border="0">
<tr valign="top">
<td width="100%" align="center"></td>
</tr>
</table>
</body>

</html>
