<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Impresion correspondencia"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "correspondencia.xml", "botonera"

set formulario = new CFormulario
formulario.Carga_Parametros "correspondencia.xml", "f_nuevo"
formulario.Inicializar conexion

consulta="Select protic.trunc(corr_frecepcion) as fecha_recp,* from correspondencia where protic.trunc(corr_frecepcion)=protic.trunc(getdate())"

formulario.Consultar consulta
v_indice=0
'---------------------------------------------------------------------------------------------------
%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_inicial.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">


<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script>
function imprimir()
{
  window.print();  
}
</script>
</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<style>
@media print{ .noprint {visibility:hidden; }}
</style>

<table width="680" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
 	<tr>
	  <td height="38"><div align="center"><br><%pagina.DibujarTituloPagina%><br></div></td>
	</tr>    
  	<tr>
    	<td valign="top" >
<div align="center" class="noprint"><%f_botonera.DibujaBoton("imprime_listado")%></div>
		<table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0" >
		  <tr>
				<br>
				  <td> <b><font color="#666677" size="2">Detalle correspondencia recibida. </font></b>
					<br>
					  <table  width='100%' class=v1 border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD' >
						<tr bgcolor='#C4D7FF' bordercolor='#999999'>
						  <td width="4%" height="26"><div align="center"><strong>N&deg;</strong></div></td>
						  <td width="10%"><div align="center"><strong>Fecha</strong></div></td>
						  <td width="18%"><div align="center"><strong>Desde</strong></div></td>
						  <td width="15%"><div align="center"><strong>Para</strong></div></td>
						  <td width="17%"><div align="center"><strong>Departamento</strong></div></td>
						  <td width="18%"><div align="center"><strong>Contenido</strong></div></td>
						  <td width="19%"><div align="center"><strong>Firma</strong></div></td>
						</tr>
						<%  while formulario.Siguiente 
										v_indice=v_indice+1 %>
						<tr bgcolor="#FFFFFF">
						  <td height="30"><div align="left"><%=v_indice%></div></td>
						  <td><div align="left"><%=formulario.ObtenerValor("fecha_recp")%></div></td>
						  <td><div align="left"><%=formulario.ObtenerValor("corr_desde")%></div></td>
						  <td><div align="left"><%=formulario.ObtenerValor("corr_para")%></div></td>
						  <td><div align="left"><%=formulario.ObtenerValor("corr_departamento")%></div></td>
						  <td><div align="left"><%=formulario.ObtenerValor("corr_contenido")%></div></td>
						  <td><div align="center">__________________</div></td>
						</tr>
						<%  wend %>
					  </table>
					  <br>
				  </td>
				</tr>
			  </table></td>
		</tr>
		  <tr>
			<td height="28" colspan="2">
				<table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="31%" height="20"><div align="center" class="noprint"><%f_botonera.DibujaBoton("imprime_listado")%></div></td>
					</tr>
		</table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
