<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut =Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")
q_tdet_ccod =Request.QueryString("b[0][tdet_ccod]")
q_sede_ccod= request.QueryString("b[0][sede_ccod]")
q_anos_ccod= request.QueryString("b[0][anos_ccod]")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Marcado Masivo"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
set errores = new CErrores
'---------------------------------------------------------------------------------------------------

set f_subida = new CFormulario
f_subida.Carga_Parametros "marca_intercambio.xml", "formu"
f_subida.Inicializar conexion
f_subida.Consultar "select ''"
f_subida.Siguiente

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

<SCRIPT LANGUAGE="JavaScript">
function Validar_rut()
{
	formulario = document.ingreso;
	rut=formulario.elements["b[0][pers_nrut]"].value
	dv=formulario.elements["b[0][pers_xdv]"].value
	
	rut_alumno = rut + "-" + dv;
	if (formulario.elements["b[0][pers_nrut]"].value  != ''){
	  	  if (!valida_rut(rut_alumno)) {
		  alert("Ingrese un RUT válido");
		formulario.elements["b[0][pers_nrut]"].focus;
	 	formulario.elements["b[0][pers_nrut]"].select();
		return false;
	  }
	 else
	 {
	 	return true;
	 }
	}

	//return true;
	
}

function irPagina2(){
	window.location = 'subir_excel.asp';
}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="400" height="250" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%'pagina.DibujarLenguetas Array("Subir Excel"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><FORM name="ingreso" >
              <br>
              <table width="90%"  border="0" align="center">
			    
                <tr>
					<td width="19%" > 
					<span class="Estilo2"></span><strong>Rut</strong><br>
					<%f_subida.DibujaCampo("pers_nrut")%>-<%f_subida.DibujaCampo("pers_xdv")%><%pagina.DibujarBuscaPersonas "b[0][pers_nrut]", "b[0][pers_xdv]"%>
					</td>
					</tr>
					<tr>
					
					<td colspan="2">
					<span class="Estilo2"></span><strong>Periodo Académico</strong><br>
					<%f_subida.DibujaCampo("peri_ccod")%>
					</td>
					</tr>
					<tr>
					
					<td colspan="2">
					<span class="Estilo2"></span><strong>Tipo de Alumno </strong><br>
					<%f_subida.DibujaCampo("talu_ccod")%>
					</td>
					</tr>
					<tr> 
					
					<td align='left' colspan="2"> 
					<INPUT type="button" value="Continuar" onClick="_Guardar(this, document.forms['ingreso'], 'proc_marca_alumno.asp','', '', '', 'FALSE')">
					
					</td>
						
			   </tr>
			   <tr> 
						<td align=left colspan="2"><INPUT type="button" value="Marca Mediante Excel" onClick="irPagina2()"></td>
			   </tr>
			</table>
            </form>
			</td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	</td>
  </tr>  
</table>
</body>
</html>