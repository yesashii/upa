<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		: Mantenedor de Cursos Diplomado
'FECHA CREACIÓN		: 12/11/2013
'CREADO POR 		: Michael Shaw Rojas
'ENTRADA		:NA
'SALIDA			:NA
'MODULO OTEC
'*******************************************************************

mdcu_ncorr=request.querystring("mdcu_ncorr")

set errores= new CErrores

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set pagina = new cPagina
pagina.Titulo = "Agregar Curso Diplomado"

set botonera = new CFormulario
botonera.carga_parametros "mantenedor_diplomado_cursos.xml", "botonera"
 
 set curso_diplomado = new CFormulario
curso_diplomado.Carga_Parametros "mantenedor_diplomado_cursos.xml", "agrega_cursos"
curso_diplomado.Inicializar conexion

if mdcu_ncorr="" then

sql_descuentos= "select''"
else
sql_descuentos= "select mdcu_ncorr,dcur_ncorr,dcur_ncorr as dcur_ncorr2,mdcu_estado from mantenedor_diplomados_cursos where mdcu_ncorr="&mdcu_ncorr&""
end if
'RESPONSE.WRITE("3. :"&sql_descuentos&"<BR>")
'RESPONSE.END()

curso_diplomado.Consultar sql_descuentos
curso_diplomado.siguiente

'RESPONSE.WRITE(curso_diplomado.ObtenerValor("dcur_ncorr"))
documento = curso_diplomado.ObtenerValor("mdcu_estado")
dcur_ncorr = curso_diplomado.ObtenerValor("dcur_ncorr")

if documento="1" then
doc_select_si="selected"
end if
if documento="2" then
doc_select_no="selected"
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

</script>
</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();">
<form name="edicion">
<input type="hidden" name="b[0][mdcu_ncorr]" value="<%=mdcu_ncorr%>" />
<input type="hidden" name="b[0][dcur_ncorr]" value="<%=dcur_ncorr%>" />
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
				<th width="68%">Curso</th>
				</tr>
					<tr>
					  <td><strong>Agregar Curso</strong></td>
                      <%if mdcu_ncorr="" then%>
					  	<td><%curso_diplomado.DibujaCampo("dcur_ncorr")%></td>
                      <%else%>
                      	<td><%curso_diplomado.DibujaCampo("dcur_ncorr2")%></td>
                      <%end if%>
					  </tr>
						<td><strong>Estado</strong></td>
						<td width="68%" valign="top">
                          <select name="datos[0][mdcu_estado]">
                            <option value="1" <%=doc_select_si%>>Activo</option>
                            <option value="2" <%=doc_select_no%>>Inactivo</option>
                        </select>	</td>
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