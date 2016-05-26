<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

q_leng	=request.QueryString("q_leng")

if session("nombre_archivo") ="" then
	session("mensaje_error")="Aun no se ha cargado un archivo valido para realizar el pago de Letras"
	response.Redirect("cargar_archivo_pago_electronico.asp")
end if

if EsVacio(q_leng) or q_leng="" then
	q_leng=1
end if

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Revisar archivo cargado"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
set errores = new CErrores
'---------------------------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.carga_parametros "archivo_pago_electronico.xml", "botonera"
'---------------------------------------------------------------------------------------------------


Const ForReading = 1
Const Create = False
Dim FSysObj
Dim TS
Dim strLine
Dim strFileName

'nombre del fichero a mostrar
'response.Write(server.mappath("..") & session("nombre_archivo"))
nombre_archivo=session("nombre_archivo")
strFileName = Server.MapPath("..\archivos_pago_electronico\"&nombre_archivo)

'Creación del objeto FileSystemObject
Set FSysObj = Server.CreateObject("Scripting.FileSystemObject")

' Abrimos el fichero
Set TS = FSysObj.OpenTextFile(strFileName, ForReading, Create)



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
<script language="javascript">

function ChequearTodos(datos) {
	for (i=0;i<document.datos.elements.length;i++) {
		if(document.datos.elements[i].type == "checkbox") {
			if((document.datos.elements[i].checked == 1)&&(document.datos.elements[i].name!="todo"))
				document.datos.elements[i].checked=0
			else if((document.datos.elements[i].checked == 0)&&(document.datos.elements[i].name!="todo"))
				document.datos.elements[i].checked=1
			}
	}
} 

function Mostrar(){
	div = document.getElementById('errores');
	if (div.style.display=='none'){
		div.style.display = '';
		div.style.visibility = 'visible';
	}else{
		div.style.display = 'none';
		div.style.visibility = 'hidden';
	}
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="" onBlur="revisaVentana();">
<table width="400" height="250" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado%>  
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
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0" >
          <tr>
            <td>
             <%pagina.DibujarLenguetasFClaro Array(array("Carga Archivo","cargar_archivo_pago_electronico.asp?q_leng=1"), array("Revision Archivo","revisar_archivo_pago_electronico.asp"), array("Pago Letras","pagar_archivo_pago_electronico.asp"), array("Impresion de comprobantes","comprobante_archivo_pago_electronico.asp")), q_leng %>
			</td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form method="post" action="guardar_archivo_pago_proc.asp" name="datos" >
              <br/>
			  <%if nombre_archivo <>"" then%>
			  <font color="#0033FF" size="+1">Archivo Cargado: <b><%=nombre_archivo%></b></font>
			  <%end if%>
			  <br/>
			  <br/>
			  <%pagina.DibujarSubtitulo "Listado de letras cargadas"%>
			  	
              <table align="center" class=v1 width='100%' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD'>
                <tr bgcolor='#C4D7FF' bordercolor='#999999'>
					<th width="7%"><input type="checkbox" name="todo" onClick="ChequearTodos(datos)" /></th>
					<th width="7%">Rut</th>
					<th width="10%">Letra</th>
					<th width="14%">NombreCliente</th>
					<th width="7%">Moneda</th>
					<th width="11%">Valor Cuota</th>
					<th width="9%">Valor Mora</th>
					<th width="13%">Monto Recaudado</th>
					<th width="8%">Fecha Vcto</th>
					<th width="14%">Fecha Recaudacion</th>
					
				</tr>
				
				<% If not TS.AtEndOfStream Then 
				error_filas=0
				contador=0
				dim filas(10000) 
				ind=0
					Do While not TS.AtendOfStream
					 ' para dejar la primera fila afuera, porque contiene los encabezados
					 ' Leemos el fichero linea a linea y lo mostramos 
					strLine = Replace(TS.ReadLine,chr(34),"") 
					if instr(strLine,",") and len(strLine)>0 then
						arreglo= split(strLine, ",")
						if isArray(arreglo) and UBound(arreglo)=8 and contador>0 then
						%>
						<tr bgcolor="#FFFFFF">
							<th width="7%"><input type="checkbox" name="letras[<%=ind%>][opcion]" value="<%=ind%>" />
							<input type="hidden" name="letras[<%=ind%>][pers_nrut]" value="<%=arreglo(0)%>">
							<input type="hidden" name="letras[<%=ind%>][pele_nidentificacion]" value="<%=arreglo(1)%>">
							<input type="hidden" name="letras[<%=ind%>][pele_tmoneda]" value="<%=arreglo(3)%>">
							</th>
							<td><%=arreglo(0)%></td>
							<td><%=arreglo(1)%></td> 
							<td><%=arreglo(2)%></td>
							<td><%=arreglo(3)%></td>
							<td><input type="text" name="letras[<%=ind%>][pele_mvalor_cuota]" value="<%=arreglo(4)%>" size="8"></td>
							<td><input type="text" name="letras[<%=ind%>][pele_mvalor_mora]" value="<%=arreglo(5)%>" size="6"></td>
							<td><input type="text" name="letras[<%=ind%>][pele_mmonto_recaudado]" value="<%=arreglo(6)%>" size="8"></td>
							<td><input type="text" name="letras[<%=ind%>][pele_fvencimiento]" value="<%=arreglo(7)%>" size="12"></td>
							<td><input type="text" name="letras[<%=ind%>][pele_frecaudacion]" value="<%=arreglo(8)%>" size="12"></td>
					   </tr>
					  <% 
						  ind=ind+1
						else ' Si no cumple con la cantidad de registros por filas, si no trae comas, o si es la primera fila
							if contador >0 then ' Si no es la primera Fila
								error_filas=error_filas+1
								filas(error_filas)=strLine
							end if
						end if
					else ' Si la linea no viene con separacion de comas
						if len(strLine)>0 then
							error_filas=error_filas+1
							filas(error_filas)=strLine
						end if
					end if
					contador=contador+1
			  loop
				End If %>
			</table>
            </form>
			<br/>
			<% if  error_filas >0 then%>
				<font color="#996633" size="2">Se encontraron <b><%=error_filas%></b> filas, que NO estaban correctamente formateadas...<a href="javascript:Mostrar();">ver detalle</a></font>
			<div id="errores" style="visibility:hidden; display:none;">
			<%
				response.Write("<hr>")
				for i=0 to UBound(filas)
					if len(filas(i))>0 then
					   response.Write(filas(i))&"<br>"
				   end if
				next
				response.Write("<hr>")
			end if
			%>
			</div>
			<br/>
			</td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
   <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="13%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                    
					<%
					if ind=0 then
						botonera.AgregaBotonParam "guardar", "deshabilitado", "true"
					end if
					botonera.DibujaBoton "guardar" %></div></td>
					<td><div align="center">
                    
					<%botonera.DibujaBoton"salir" %></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="87%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28">
            </td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
    <br>
    </td>
  </tr>  
</table>
</body>
</html>
<%
' cerramos y destruimos los objetos
TS.Close
Set TS = Nothing
Set FSysObj = Nothing
%>