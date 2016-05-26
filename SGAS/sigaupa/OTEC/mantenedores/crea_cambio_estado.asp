<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Cambio Estado Seccion Otec"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

v_modulo = Request.QueryString("modulo")
v_sede = Request.QueryString("sede")
dgso_ncorr = Request.QueryString("dgso_ncorr")

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "estado_secciones_otec.xml", "botonera"

'---------------------------------------------------------------------------------------------------

set formulario = new CFormulario
formulario.Carga_Parametros "estado_secciones_otec.xml", "cambio_estado"
formulario.Inicializar conexion
consulta = " select '' "
formulario.Consultar consulta
formulario.Siguiente

rut_usuario=negocio.ObtenerUsuario

if v_modulo <> "" and v_sede <> "" then
	editar=true
else
editar=false
%>
	<script language="JavaScript">
		alert("No ha realizado una busqueda");
		window.close();
	</script>
	<%	
end if
'----------------------------------------------------

%>


<html>
<head>
<title>Crear Comentarios</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function cerrarVentana(){
	window.close();
}
function comprobar(){
	textoArea=document.edicion.elements["cambio[0][sohe_observacion]"].value;
	
	 inicioBlanco = /^ /
	finBlanco = / $/	
	variosBlancos = /[ ]+/g 
	
	textoArea = textoArea.replace(inicioBlanco,"");
	textoArea = textoArea.replace(finBlanco,"");
	textoArea = textoArea.replace(variosBlancos," ");
	
	textoAreaDividido = textoArea.split(" ");
	numeroPalabras = textoAreaDividido.length;
	
	if (numeroPalabras >=6){
		return true;
	}else{
		alert("Debe ingresar un minimo de 6 palabras")
	return false;
	}
}

</script>

</head>
<body  onBlur="revisaVentana()" bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../adm_sistema/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../adm_sistema/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../adm_sistema/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../adm_sistema/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="700" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
   <tr>
    <td height="268" valign="top" bgcolor="#EAEAEA">
	<BR>
	<BR>			
	
	<table  border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
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
						  
                      <td width="205" valign="middle" background="../imagenes/fondo1.gif"><font color="white">Cambio Estado</font> </td>
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
                    <%pagina.DibujarTituloPagina%>
                  </div>
                  <form name="edicion">
					<input  type="hidden" name="cambio[0][dcur_ncorr]" value="<%=v_modulo%>">
                    <input  type="hidden" name="cambio[0][sede_ccod]" value="<%=v_sede%>">
                    <input  type="hidden" name="cambio[0][dgso_ncorr]" value="<%=dgso_ncorr%>">
									     
					<table width="100%" border="0">
                      <tr> 
                        <td><strong>Observacion</strong></td>
                        <td><strong>:</strong></td>
                        <td><textarea name="cambio[0][sohe_observacion]" rows="5" style="width:250" id="TO-N"></textarea>
						 </td>
                      </tr>
                      <tr> 
                        <td width="17%"><strong>Estado</strong></td>
                        <td width="3%"><strong>:</strong></td>
                        <td width="80%"><%formulario.DibujaCampo("esot_ccod")  %></td>
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
						   <% 
						   if editar=true then
								botonera.dibujaboton "guardar_nuevo"
						   end if
						   %>
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
