<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores

set pagina = new CPagina
pagina.Titulo = "Administración de clave de acceso"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "cambiar_clave.xml", "botonera"

Usuario = negocio.ObtenerUsuario()

'---------------------------------------------------------------------------------------------------
set f_datos = new CFormulario
f_datos.Carga_Parametros "cambiar_clave.xml", "f_datos"
f_datos.Inicializar conexion

  sql = "SELECT a.pers_ncorr, a.susu_tlogin, upper(a.susu_tclave) as susu_tclave, '' as anterior,  '' as nueva,  '' as confirmacion, "&_ 
              "protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre "&_
        "FROM sis_usuarios a, personas b "&_
        "WHERE a.pers_ncorr = b.pers_ncorr "&_
          "AND b.pers_nrut ='" & Usuario & "'"

f_datos.Consultar sql
f_datos.Siguiente
'response.End()

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
 function Validar()
 {
    formulario = document.edicion;
	original = formulario.elements["datos[0][susu_tclave]"].value;	
	anterior = formulario.elements["datos[0][anterior]"].value;	
	nueva = formulario.elements["datos[0][nueva]"].value;	
	confirmacion = formulario.elements["datos[0][confirmacion]"].value;	

    if (anterior.toUpperCase() != original.toUpperCase())
	 {
	    alert('Su clave anterior no es correcta');
		formulario.elements["datos[0][anterior]"].focus();
		formulario.elements["datos[0][anterior]"].select();
		return false;
	 }
	else
	  if (nueva.toUpperCase() != confirmacion.toUpperCase())
       {
		  alert('La clave de confirmación no coincide con la clave nueva.');
		  formulario.elements["datos[0][confirmacion]"].focus();
		  formulario.elements["datos[0][confirmacion]"].select();
		  return false;
	   }	  		
	
	return true;   
 }
</script>

<style type="text/css">
<!--
.Estilo1 {color: #FF0000}
-->
</style>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="500" height="380" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="80" valign="top"><img src="../imagenes/banner.jpg" width="750" height="100" border="0"></td>
  </tr>
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
      <br>
	<table width="60%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Cambio de Clave"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
              <form name="edicion">
		<table width="100%" align="center" >
			<tr>
			  <td width="7%"><strong>RUT</strong></td>
			  <td width="4%"><strong>:</strong></td>
			  <td width="23%"> <% f_datos.dibujaCampo "rut" %></td>
				<td width="13%"><strong>Nombre</strong></td>
				<td width="3%"><strong>:</strong></td>
				<td width="50%"><% f_datos.dibujaCampo "nombre" %>
                </td>
			</tr>
		</table>
                <br>
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr align="center">
                    <td>
						<table style="border:1px solid gray; background-color:#C5C5C5" align="center" border="0" cellspacing="1" cellpadding="1">
						  <tr > 
							<td width="83" ><strong>Login</strong></td>
							<td width="10"><strong>:</strong></td>
							<td width="125"><b><font color="#0033FF"><% f_datos.dibujaCampo "susu_tlogin" %></font></b><% f_datos.dibujaCampo "pers_ncorr" %> </td>
						  </tr>
						  <tr> 
							<td><strong>Clave Anterior</strong></td>
							<td><strong>:</strong></td>
							<td> <% f_datos.dibujaCampo "anterior" %> 
							<% f_datos.dibujaCampo "susu_tclave" %> </td>
						  </tr>
						  <tr > 
							<td ><strong>Nueva Clave</strong></td>
							<td><strong>:</strong></td>
							<td> <% f_datos.dibujaCampo "nueva" %> 
							  <font color="#0033FF">(max. 8 caracteres) </font></td>
						  </tr>
						  <tr > 
							<td ><strong>Confirme Clave</strong></td>
							<td><strong>:</strong></td>
							<td> <% f_datos.dibujaCampo "confirmacion" %> </td>
						  </tr>
					 </table> 
					</td>
                  </tr>
                </table>
                          <br>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="21%" height="20"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td> <div align="left"> 
                            <%
							if Usuario <> "" then
							  f_botonera.AgregaBotonParam  "guardar", "deshabilitado" , "FALSE"
							else
							  f_botonera.AgregaBotonParam  "guardar", "deshabilitado" , "TRUE"
							end if
							f_botonera.DibujaBoton "guardar"
							 %>
                          </div></td>
                        <td> <div align="left">
                            <%
								f_botonera.AgregaBotonParam "salir", "url", "menu_alumno.asp"
								f_botonera.DibujaBoton "salir" 
							%>
                          </div></td>
                      </tr>
                    </table>
            </div></td>
            <td width="79%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
