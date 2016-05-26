<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->



<%
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Fin"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


set f_botonera = new CFormulario
f_botonera.Carga_Parametros "encuesta_rr_pp.xml", "botonera"
q_pers_nrut=negocio.obtenerUsuario
alumno = conexion.consultaUno("Select nombres+' '+apellidos from titulados_egresados_rrpp where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
'response.End()
Session.Abandon()
response.Redirect("portada_encuesta.asp")
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Bienvenido a la Universidad del Pac&iacute;fico</title>


<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

function cerrarVentana(){
//la referencia de la ventana es el objeto window del popup. Lo utilizo para acceder al método close
window.close()
} 

</script>
</head>

<body>
</body>

</html>
