<!-- #include file = "cambio_jornada_proc.asp" -->

<%
'---------------------------------------------------------------------------------------------------

Set jornada_controlador = new controlador_jornada

set pagina = new CPagina
pagina.Titulo = "Cambio Jornada"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

folio_buscar 	= 	Request.Form("folio_buscar")
jornada = Request.Form("jornada")
seccion = Request.Form("seccion")
encontrados = false
if jornada <> "" AND seccion <> "" then
	folio_buscar = seccion
	jornada_controlador.cambiar_jornada seccion, jornada
	encontrados = true
		encontrado = jornada_controlador.obtener_asignatura(seccion)
		tabla = jornada_controlador.obtener_tabla(seccion)
else
	if folio_buscar <> "" then
		encontrados = true
		encontrado = jornada_controlador.obtener_asignatura(folio_buscar)
		tabla = jornada_controlador.obtener_tabla(folio_buscar)
	end if
end if




%>
<html>
<head>
<title>Cambio De Jornada</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
	function Solo_Numerico(variable){
		Numer=parseInt(variable);
		if (isNaN(Numer)){
			return "";
		}
		return Numer;
	}
			
	function esnumero(Control){
		Control.value=Solo_Numerico(Control.value);
	}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();"onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr>
    <td height="65"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
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
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador" method="post">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td><div align="right"><strong>Codigo de Seccion </strong></div></td>
                        <td width="7%"><div align="center"><strong>:</strong></div></td>
                        <td width="61%"><div align="left"><input type="text" name="folio_buscar" id ="folio_buscar" onKeyDown="esnumero(this)" onBlur="esnumero(this)" onKeyUp="esnumero(this)"></div></td>
                      </tr>
                    </table>
                  </div></td>
                  <td><div align="center"><input type="submit" value="Buscar"></div></td>
                </tr>
              </table>
            </form></td>
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
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>          
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br><br>
			  </div>   
			<% if encontrados then %>
				<table>
					<tr>
						<td><strong>Asignatura</strong></td>
						<td>:</td>
						<td><% response.write encontrado(0)%></td>
					</tr>
					<tr>
						<td><strong>codigo asignatura:</strong></td>
						<td>:</td>
						<td><% response.write encontrado(1)%></td>
					</tr>
					<tr>
						<td><strong>jornada:</strong></td>
						<td>:</td>
						<td><% response.write encontrado(2)%></td>
					</tr>
					<tr>
						<td><strong>Sede:</strong></td>
						<td>:</td>
						<td><% response.write encontrado(3)%></td>
					</tr>
				</table>
				<br>
				<div align="center" style="width:100%;">
					<table width="80%" border="0" align="center">
						<tr>
							<td>
								<table class=v1 width="100%" align="center" border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD' id='tb_a'>
									<tr bgcolor='#C4D7FF' bordercolor='#999999'>
										<th><font color='#333333'>Especialidad</font></th>
										<th><font color='#333333'>Codigo Seccion</font></th>
										<th><font color='#333333'>Seccion</font></th>
										<th><font color='#333333'>Asignatura</font></th>
										<% '<th><font color='#333333'>Horario</font></th> 
										%>
									</tr>
									<%
										
										For Each item in tabla
											response.write "<tr bgcolor='#FFFFFF'>"
											response.write "<td nowrap>"&item(0)&"</td>"
											response.write "<td nowrap>"&item(1)&"</td>"
											response.write "<td nowrap>"&item(2)&"</td>"
											response.write "<td nowrap>"&item(3)&"</td>"
											'response.write "<td nowrap>"&item(4)&"</td>"
											response.write "</tr>"
										next
									%>
								</table>
							</td>
						</tr>
					</table>
				</div>
				<form name="cambiar" method="post">
					Eliga Jornada: 
					<select name="jornada">
						<%
							if encontrado(2)="DIURNO" then
								response.write "<option value='1' selected>DIURNO</option>"
								response.write "<option value='2'>VESPERTINO</option>"
							else
								response.write "<option value='1'>DIURNO</option>"
								response.write "<option value='2' selected>VESPERTINO</option>"
							end if
						%>
					</select>
					<input type="text" value="<% response.write folio_buscar %>" name="seccion" readonly>
					<input type="submit" value="Cambiar">
				</form>
			  <% end if %>
            </td></tr>            
      </table>		
        </td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="18%" height="20"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0" align="center">
                      <tr>
                        <td width="55%"><div align="center">
                            <input type="button" value="salir">
                          </div></td>
                      </tr>
                    </table>
            </div></td>
            <td width="82%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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