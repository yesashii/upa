<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Cambio Promedio "

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

pers_ncorr = Request.QueryString("pers_ncorr")
promedio_final = Request.QueryString("promedio_final")

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "cambio_promedio_final.xml", "botonera"

'---------------------------------------------------------------------------------------------------

set formulario = new CFormulario
formulario.Carga_Parametros "cambio_promedio_final.xml", "cambio_notas_alumno"
formulario.Inicializar conexion
consulta ="select pers_ncorr, promedio_final from detalles_titulacion_carrera where pers_ncorr="&pers_ncorr&" and promedio_final="&promedio_final
formulario.Consultar consulta
formulario.Siguiente
'response.Write(consulta)
rut_usuario=negocio.ObtenerUsuario

nota = formulario.obtenervalor("promedio_final")

nota = replace(nota,",",".")
%>


<html>
<head>
<title>Cambio Promedio </title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if
%>
}

function cerrarVentana(){
	window.close();
}
function rangonumeros(){
	var nota = "<%=nota%>";
	real = document.edicion.elements['datos[0][promedio_cambio]'].value
	max	= nota*1.007;
	min = nota*0.994;
	max = max.toFixed(2)
	min = min.toFixed(2)
	
	if(real <= min || real >= max){
		alert (" Esta Fuera del Rango de valores.\n El valor tiene que ser +o- 0.02 al Promedio Final. ") 
		return false;
	}else{
		return true;
	}

}

function ValidaSoloNumeros() {
	//alert(event.keyCode)
 if ((event.keyCode < 46) || (event.keyCode > 57)) 
  event.returnValue = false;
}

</script>

</head>
<body  onBlur="revisaVentana()" bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../adm_sistema/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../adm_sistema/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../adm_sistema/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../adm_sistema/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="700" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
   <tr>
    <td height="268" valign="top" bgcolor="#EAEAEA">
	<BR>
	<BR>			
	
	<table  border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="80%">
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif"  height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
						  <td width="9" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
						  
                      <td width="205" valign="middle" background="../imagenes/fondo1.gif"><font color="white">Cambio Promedio</font> </td>
						  <td width="" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
						</tr>
					</table>
				</td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif"  height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  
                <td bgcolor="#D8D8DE"> <div align="center">&nbsp; <BR>
                </div>
                  <form name="edicion">
					<input  type="hidden" name="datos[0][pers_ncorr]" value="<%=pers_ncorr%>">	 
                    <input  type="hidden" name="datos[0][promedio_final]" value="<%=promedio_final%>">         
					<table width="55%" border="0" >
                    <tr>
                      <td><strong>Promedio Final Actual : <%=nota%></strong></td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                    </tr>
                      <tr>
						<td>Promedio a ingresar : <%formulario.DibujaCampo("promedio_cambio")%> 
						    <strong>ejemplo 5.59</strong></td>
						</tr>
                    </table>
					</form>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="123" bgcolor="#D8D8DE"> <div align="left"></div> 
		            <div align="left">                       <table width="100%" border="0" cellpadding="0" cellspacing="0">
                         <tr>
                           <td width="16%">
						   <%botonera.dibujaboton "guardar"%>
                           </td>
                           <td width="84%"><% botonera.dibujaboton "cancelar"%>
                           </td>
                         </tr>
                       </table>
</div></td>
                  <td  rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="45%" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
