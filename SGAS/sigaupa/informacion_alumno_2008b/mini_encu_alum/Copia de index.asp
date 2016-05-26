<%if session("rut_usuario")="" then
session("rut_usuario")="15964262"
end if%>
<!-- #include file = "../../biblioteca/_conexion.asp" -->
<!-- #include file = "../../biblioteca/revisa_session_alumno_2008.asp" -->
<!-- #include file = "../../biblioteca/_negocio.asp" -->
<% 


'------------------------------------------------------
set errores= new CErrores
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
 

'---------------------------------------------------------------------------------------------------

 

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Bienvenido a Universidad del Pac&iacute;fico Online</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../../biblioteca/validadores.js"></script>

<script language="JavaScript">
function ir()
{
location.href="encu.asp"

}
</script>
</script>
<style type="text/css">
p{

font-family:Geneva, Arial, Helvetica, sans-serif;
font-size:12px;
}

h3{
font-family:Geneva, Arial, Helvetica, sans-serif;
}
</style>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#CC6600" background="../imagenes/fondo.jpg">
<center>
<table align="center" width="700">
	<tr>
		<td width="100%" align="left">
			<table width="700" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="98%" border="0" bgcolor="#f7faff">
							<tr valign="middle">
								<td>
									<h3>ESTIMADO ALUMNO (A)</h3>
						
									<p>TE LLAMAMOS  A VOTAR PARA QUE ELIJAS A QUIEN, EN NOMBRE DE LOS ESTUDIANTES DE LA UNIVERSIDAD DEL PACÍFICO , PARTICIPE EN LA ELECCION  DE UN REPRESENTANTE ANTE LA COMISIÓN NACIONAL DE ACREDITACIÓN, CNA.</p>
									<p>COMO ES CONOCIDO, ESTE IMPORTANTE ORGANISMO DE EDUCACIÓN SUPERIOR CONTARÁ A PARTIR DE ESTE AÑO, CON DOS  DELEGADOS DE LOS ESTUDIANTES, UNO ELEGIDO ENTRE LOS REPRESENTANTES DE LOS ESTUDIANTES DE LAS INSTITUCIONES DE LA REGIÓN METROPOLITANA Y OTRO POR AQUELLAS DE PROVINCIA.</p>
									<p>PARA ESTOS EFECTOS SE HAN PRESENTADO 4 ESTUDIANTES QUE CUMPLEN LOS REQUISITOS LEGALES, DE ENCONTRARSE ENTRE EL 5% DE MEJORES ALUMNOS DE LA UNIVERSIDAD Y ESTÁN CURSANDO 4º  AÑO DE SU CARRERA EN 2011.  ELLOS HAN  MANIFESTADO SU INTERÉS EN REPRESENTAR A LA INSTITUCIÓN.</p>
									<p>PARA LOGRAR ESTE NOMBRAMIENTO,  SE REQUIERE UNA ALTA VOTACIÓN, POR LO QUE TE INVITAMOS  A SELECCIONAR AL QUE MÁS TE AGRADE Y HACER ASI POSIBLE LA PARTICIPACIÓN ESTUDIANTIL DE LA UNIVERSIDAD DEL PACÍFICO.</p>
									<p>PUEDES CONOCER A LOS  CANDIDATOS Y VOTAR POR ALGUNO DE ELLOS A TRAV&Eacute;S DE ESTA P&Aacute;GINA, HACIENDO CLICK  EN <strong>VOTAR</strong></p>
								</td>
							<tr>
							<tr>
								<td align="center">
									<img src="../imagenes/front.png" width="100" height="100" style="cursor:pointer" onClick="ir()"/>
								</td>
							</tr>
							<tr>
								<td align="center">
									<strong><font size="+1">Ir a encuesta</font></strong>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
			</table>
		</td>
	</tr>
</table>
</center>
</body>
</html>

