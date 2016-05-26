<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
peri_ccod=request.Form("b[0][peri_ccod]")
arch_Q=request.QueryString("arch")
pes_Q=request.QueryString("pes")
arch_F=request.Form("b[0][arch]")
pes_F=request.Form("b[0][pes]")
'response.Write("<br>archQ= "&arch_Q)
'response.Write("<br>pesQ= "&pes_Q)
'response.Write("<br>archF= "&arch_F)
'response.Write("<br>pesF= "&pes_F)
'response.Write("<br>tipo_beca1= "&tipo_beca1)
'response.Write("<br>tipo_beca2= "&tipo_beca2)
'response.Write("<br>tipo_mantencion= "&tipo_mantencion)
'response.Write("<br>tipo_arancel= "&tipo_arancel)

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Tipos de Becas"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
set errores = new CErrores
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "marca_opcion.xml", "botonera"


set f_formulario = new CFormulario
f_formulario.Carga_Parametros "marca_intercambio.xml", "formu"
f_formulario.Inicializar conexion
sql_descuentos= "select ''"
f_formulario.Consultar sql_descuentos
f_formulario.Siguiente
f_formulario.AgregaCampoCons "peri_ccod", peri_ccod



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
function enviar()

{
formulario = document.busqueda;
formulario.submit();
}

function enviar2()

{
formulario = document.opciones;
formulario.submit();
}




</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
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
            <td>
              <table width="74%"  border="0" align="center">
			    <FORM   METHOD=POST name="opciones" >
				<input type="hidden" name="b[0][arch]" value="<%=arch_Q%>">
				<input type="hidden" name="b[0][pes]" value="<%=pes_Q%>">
			
					<tr>
						<td colspan="2"><span class="Estilo2"></span><strong>Periodo Académico</strong><br> 
					    <%f_formulario.DibujaCampo("peri_ccod")%></td>
					</tr>
					<tr>
						<td colspan="2"><span class="Estilo2"></span><strong>Tipo Alumno </strong><br> 
					    <%f_formulario.DibujaCampo("talu_ccod")%></td>
					</tr>
					<tr> 
					
						<td width="22%" align=left><%f_botonera.DibujaBoton("ir") %></td>
						
								
			  		 </tr>
			   </form>
			</table>
		  </td>
        </tr>
        </table>
		</td>
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