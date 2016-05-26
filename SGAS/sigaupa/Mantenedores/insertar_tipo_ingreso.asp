<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		: Mantenedor de Tipo Ingresos
'FECHA CREACIÓN		: 12/12/2013
'CREADO POR 		: Michael Shaw Rojas
'ENTRADA		:NA
'SALIDA			:NA
'*******************************************************************

ting_ccod=request.querystring("ting_ccod")


set errores= new CErrores

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set pagina = new cPagina
pagina.Titulo = "Agregar Tipo Ingresos"

set botonera = new CFormulario
botonera.carga_parametros "agrega_tipo_ingreso.xml", "botonera"

set ingresos = new CFormulario
ingresos.Carga_Parametros "agrega_tipo_ingreso.xml", "agrega_cursos" 
ingresos.Inicializar conexion


if ting_ccod="" then
sql_diplomado= "select ''"	
else
sql_diplomado= "select ting_ccod,ting_tdesc,ting_bregularizacion,ting_cuenta_softland, ting_tipos_softland,ereg_ccod from tipos_ingresos where ting_ccod="&ting_ccod
end if

ingresos.Consultar sql_diplomado
ingresos.siguiente

regularizacion = ingresos.ObtenerValor("ting_bregularizacion")
estado = ingresos.ObtenerValor("ereg_ccod")

if regularizacion="S" then
re_select_si="selected"
end if
if regularizacion="N" then
re_select_no="selected"
end if

if estado<> "" then
prueba = "sel_" & estado
end if
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
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>
<script language="JavaScript">

function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if
%>
}

function ValidaSoloNumeros() {
	//alert(event.keyCode)
 if ((event.keyCode < 46) || (event.keyCode > 57)) 
  event.returnValue = false;
}

function ValidaSoloLetras() {
	//alert(event.keyCode)
if ((event.keyCode != 32) && (event.keyCode < 65) || (event.keyCode > 90) && (event.keyCode < 97) || (event.keyCode > 122))
  event.returnValue = false;
}

function validaselect(){
	
	if (document.edicion.elements['datos[0][ereg_ccod]'].selectedIndex==0){ 
      	 alert("Debe seleccionar un estado para el Tipo de Ingreso.") 
      	 document.edicion.elements['datos[0][ereg_ccod]'].focus() 
      	 return false; 
   	} 
	return true;
}


</script>
</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();">
<form name="edicion">
<input type="hidden" name="datos[0][ting_ccod]" value="<%=ting_ccod%>" />
<table width="750" height="300" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<br>
	<table width="70%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
				<table align="center">
					<tr>
						<td>
							<%pagina.DibujarTituloPagina%>
						</td>
					</tr>
				</table>
				<table align="left" width="90%" class='v1' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' >
				<tr bgcolor='#C4D7FF' bordercolor='#999999'>
				<th width="32%">Item</th>
				<th width="68%">Ingreso</th>
				</tr>
					<tr>
					    <td height="30"><strong>Agregar Curso</strong></td>                      
				  	  <td><%ingresos.DibujaCampo("ting_tdesc")%></td>					
                     </tr>
						<tr>
                        <input type="hidden" name="datos[0][ting_bregularizacion]" value="S" />
					  </tr>
                      <tr>
						<td height="30"><strong>Cuenta Softland</strong></td>
						<td><%ingresos.DibujaCampo("ting_cuenta_softland")%></td>
					</tr>		
                    <tr>
						<td height="30"><strong>Tipo Softland</strong></td>
						<td><%ingresos.DibujaCampo("ting_tipos_softland")%></td>
					</tr>	
                    <tr>
						  <td height="30"><strong>Estado</strong></td>
						  <td><select name="datos[0][ereg_ccod]">
						    <option value="">Seleccionar</option>
						    <option value="1" <%if prueba = "sel_1" then%>
							selected 
							<%end if%>>Anulación</option>
						    <option value="2" <%if prueba = "sel_2" then %>							
							selected 
							<%end if%>>Condonación</option>
                            <option value="3" <%if prueba = "sel_3" then %>
							selected 
							<%end if%>>Castigos</option>
                            <option value="4" <%if prueba = "sel_4" then %>
							selected 
							<%end if%>>Descuentos</option>
				        </select></td>
					  </tr>			
				</table>
				</td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
    <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="13%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><%botonera.DibujaBoton"guardar_curso" %></td>
				  <td><%botonera.DibujaBoton"cerrar" %></td>
                  </tr>
              </table>
            </div></td>
            <td width="87%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	</td>
  </tr>  
</table> </form>
</body>
</html>