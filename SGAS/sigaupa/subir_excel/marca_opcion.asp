<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
peri_ccod=request.Form("b[0][peri_ccod]")
arch_Q=request.QueryString("arch")
pes_Q=request.QueryString("pes")
arch_F=request.Form("b[0][arch]")
pes_F=request.Form("b[0][pes]")
tipo_beca1 = Request("b[0][tipos_becas]")	
tipo_beca2 = Request.form("b[0][tipos_becas]")
tipo_mantencion = Request.form("b[0][mantencion]")
tipo_arancel = Request.form("b[0][arancel]")
if tipo_beca1 ="" then
tipo_beca=tipo_beca2
else
tipo_beca=tipo_beca1
end if

if tipo_beca ="" then
tipo_beca="0"
end if
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



if tipo_beca="2" then
set f_arancel_externas = new CFormulario
f_arancel_externas.Carga_Parametros "marca_opcion.xml", "formu"
f_arancel_externas.Inicializar conexion
sql_descuentos= "select ''"
f_arancel_externas.Consultar sql_descuentos
f_arancel_externas.Siguiente
f_arancel_externas.AgregaCampoCons "arancel", tipo_arancel
end if
if tipo_beca="1" then
set f_mantencio_externas = new CFormulario
f_mantencio_externas.Carga_Parametros "marca_opcion.xml", "formu"
f_mantencio_externas.Inicializar conexion
sql_descuentos= "select ''"
f_mantencio_externas.Consultar sql_descuentos
f_mantencio_externas.Siguiente
f_mantencio_externas.AgregaCampoCons "mantencion", tipo_mantencion
end if

set f_formulario = new CFormulario
f_formulario.Carga_Parametros "marca_opcion.xml", "formu"
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

function marca()
{
var valor;
valor=<%=tipo_beca%>;
formulario = document.busqueda;
formulario.elements["b[0][tipos_becas]"].value=valor;
}



</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="marca();""MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
			    <FORM  ACTION="marca_opcion.asp" METHOD=POST name="busqueda" >
				<input type="hidden" name="b[0][arch]" value="<%=arch_Q%>">
				<input type="hidden" name="b[0][pes]" value="<%=pes_Q%>">

               <tr>						
                      <td width="20%"><span class="Estilo2"></span><strong>Tipo de Beneficios</strong><br>
					  					<select name="b[0][tipos_becas]" onChange="enviar();" id="TO-N">
										<option value="0">Elija un Tipo de Beca</option>
										<option option value="1">Becas de Mantención</option>
										<option option value="2">Becas de Arancel Externas</option>
										</select>
						</td>
               </tr>
			   </form>
			</table>
		  </td>
        </tr>
		  
		  
          <tr>
            <td>
              <table width="74%"  border="0" align="center">
			    <FORM   METHOD=POST name="opciones" >
				<input type="hidden" name="b[0][arch]" value="<%=arch_F%>">
				<input type="hidden" name="b[0][pes]" value="<%=pes_F%>">
				<input type="hidden" name="b[0][tipos_becas]" value="<%=tipo_beca1%>">
				<%if tipo_beca="2" then%>
               <tr>						
                      <td width="20%"><span class="Estilo2"></span><strong>Becas</strong><br> <%f_arancel_externas.DibujaCampo("arancel")%></td>
               </tr>
			   <%end if%>
			   <%if tipo_beca="1" then%>
			      <tr>						
                      <td width="20%"><span class="Estilo2"></span><strong>Becas</strong><br> <%f_mantencio_externas.DibujaCampo("mantencion")%></td>
               </tr>
				<%end if%>
					<tr>
						<td width="20%"><span class="Estilo2"></span><strong>Periodo Académico</strong><br> <%f_formulario.DibujaCampo("peri_ccod")%></td>
					</tr>
					
					<tr> 
					<%if tipo_mantencion <> "" or tipo_arancel <> "" then%>
						<td align=left><%f_botonera.agregaBotonParam "ir","deshabilitado","FALSE"
					 					f_botonera.DibujaBoton("ir") %></td>
					<%else%>
						<td align=left><%f_botonera.agregaBotonParam "ir","deshabilitado","TRUE"
					 					f_botonera.DibujaBoton("ir") %></td>
					<%end if%>					
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