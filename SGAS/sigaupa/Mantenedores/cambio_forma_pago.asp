<!-- #include file = "cambio_forma_pago_proc.asp" -->

<%
'---------------------------------------------------------------------------------------------------

Set forma_pago_controlador = new controlador_forma_pago

set pagina = new CPagina
pagina.Titulo = "Cambio Forma Pago"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

folio_buscar 	= 	Request.Form("comprobante_buscar")
ingresar = Request.Form("es_efectivo")
folio_referencia 	= 	Request.Form("folio_referencia")
detalle_ingreso = Request.Form("detalle_ingreso")

'----- PARA CHEQUES  ----------
cheque = Request.Form("cheque_estado")
if cheque = "True" then
	cheque_cuenta = Request.Form("cheque_cuenta")
	cheque_banco = Request.Form("cheque_banco")
	cheque_fecha = Request.Form("cheque_fecha")
	cheque_monto = Request.Form("cheque_monto")
	cheque_plaza = Request.Form("cheque_plaza")
end if
'----- PARA EFECTIVO ----------
efectivo = Request.Form("efectivo_estado")
if efectivo = "True" then
	efectivo_monto = Request.Form("efectivo_monto")
end if
'----- PARA CREDITO  ----------
credito = Request.Form("credito_estado")
if credito = "True" then
	credito_cuenta = Request.Form("credito_cuenta")
	credito_banco = Request.Form("credito_banco")
	credito_fecha = Request.Form("credito_fecha")
	credito_monto = Request.Form("credito_monto")	
end if
'----- PARA DEBITO  -----------
debito = Request.Form("debito_estado")

if debito = "True" then
	debito_cuenta = Request.Form("debito_cuenta")
	debito_banco = Request.Form("debito_banco")
	debito_fecha = Request.Form("debito_fecha")
	debito_monto = Request.Form("debito_monto")	
end if

if ingresar = "True" then
	if cheque = "True" then
		forma_pago_controlador.ingresar_a_cheque cheque_cuenta, cheque_banco,cheque_fecha, cheque_monto, cheque_plaza, folio_referencia
	end if
	if debito = "True" then
		forma_pago_controlador.insertar_a_debito debito_cuenta,debito_banco,debito_fecha,debito_monto, folio_referencia
	end if
	if credito = "True" then
		forma_pago_controlador.insertar_a_credito credito_cuenta,credito_banco,credito_fecha,credito_monto, folio_referencia
	end if
else
	if cheque = "True" then
		forma_pago_controlador.actualizar_a_cheque cheque_cuenta, cheque_banco,cheque_fecha, cheque_monto, cheque_plaza, detalle_ingreso
	end if
	if efectivo = "True" then
		forma_pago_controlador.actualizar_efectivo efectivo_monto, detalle_ingreso
	end if
	if debito = "True" then
		forma_pago_controlador.actualizar_a_debito debito_cuenta,debito_banco,debito_fecha,debito_monto, detalle_ingreso
	end if
	if credito = "True" then
		forma_pago_controlador.actualizar_a_credito credito_cuenta,credito_banco,credito_fecha,credito_monto, detalle_ingreso
	end if
end if



es_efectivo = false

if folio_buscar <> "" then
	datos = forma_pago_controlador.obtener_datos(folio_buscar)

	if datos(0)(0) = "EFECTIVO" then
		es_efectivo = true
	else
		es_efectivo = false
	end if
end if

forma_pago = forma_pago_controlador.obtener_forma_pago()
bancos = forma_pago_controlador.obtener_banco()
plazas = forma_pago_controlador.obtener_plaza()

%>
<html>
<head>
<title><% = pagina.Titulo %></title>
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
	
	function mostrar(a)
	{
		document.getElementById("cheque").style.display ="none";
		document.getElementById("cheque_estado").value ="False";
		document.getElementById("efectivo").style.display ="none";
		document.getElementById("efectivo_estado").value ="False";
		document.getElementById("credito").style.display ="none";
		document.getElementById("credito_estado").value ="False";
		document.getElementById("debito").style.display ="none";
		document.getElementById("debito_estado").value ="False";
		
		if(a.value == 3)
		{
			document.getElementById("cheque").style.display ="";
			document.getElementById("cheque_estado").value ="True";
		}
		else if(a.value == 6)
		{
			document.getElementById("efectivo").style.display ="";
			document.getElementById("efectivo_estado").value ="True";
		}
		else if(a.value == 13)
		{
			document.getElementById("credito").style.display ="";
			document.getElementById("credito_estado").value = "True";
		}
		else if(a.value == 51)
		{
			document.getElementById("debito").style.display ="";
			document.getElementById("debito_estado").value ="True";
		}
	}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onBlur="revisaVentana();">
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
                        <td><div align="right"><strong>N° Comprobante</strong></div></td>
                        <td width="7%"><div align="center"><strong>:</strong></div></td>
                        <td width="61%"><div align="left"><input type="text" name="comprobante_buscar" id ="comprobante_buscar" onKeyDown="esnumero(this)" onBlur="esnumero(this)" onKeyUp="esnumero(this)"></div></td>
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
			<% if es_efectivo then %>
				<table>
					<tr>
						<td><strong>Forma Pago</strong></td>
						<td>:</td>
						<td><% response.write datos(0)(0)%></td>
					</tr>
					<tr>
						<td><strong>Valor</strong></td>
						<td>:</td>
						<td><% response.write datos(0)(1)%></td>
					</tr>
				</table>
			<% else 
				if folio_buscar <> "" then%>
				<table width="100%">
					<tr>
						<td>Forma Pago</td>
						<td>Tipo Pago</td>
						<td>N° Documento</td>
						<td>Monto Documento</td>
						<td>Fecha Documento</td>
						<td>Folio Referencia</td>
					</tr>
					<tr>
						<% for each valor in datos %>
							<td><% response.write valor(0)%></td>
							<td><% response.write valor(1)%></td>
							<td><% response.write FormatNumber(valor(2),0)%></td>
							<td><% response.write FormatCurrency(valor(3),0) %></td>
							<td><% response.write valor(4)%></td>
							<td><% response.write FormatNumber(valor(5),0)%></td>
						<% next %>
					</tr>
				</table>
				<% end if 
			end if %>
				<form name="cambiar_forma" method="post">
					<table>
						<tr>
							<td>Seleccione Tipo</td>
							<td>:</td>
							<td>
								<select id="forma_pago" onChange="mostrar(this);">
									<option value=""> --SELECCIONE FORMA DE PAGO --</option>
									<% for each valor in forma_pago %>
										<option value="<% =valor(0) %>"> <% =valor(1) %></option>
									<% next %>
								</select>
							</td>
						</tr>
					<% if not es_efectivo then %>
						<tr>
							<td>Numero de Documento</td>
							<td>:</td>
							<td><input type="text" value="" name="detalle_ingreso"></td>
						</tr>
					<% end if %>
					</table>
					<div id="cheque" style="display:none;">
						<br><br><strong>CHEQUE</strong><br>
						<input type="hidden" value="False" name="cheque_estado">
						<table>
							<tr>
								<td>Valor a pagar</td>
								<td>:</td>
								<td><input type="text" value="" name="cheque_monto"></td>
							</tr>
							<tr>
								<td>Fecha a pagar (dd/mm/yyyy)</td>
								<td>:</td>
								<td><input type="text" value="" name="cheque_fecha"></td>
							</tr>
							<tr>
								<td>Numero de Cuenta</td>
								<td>:</td>
								<td><input type="text" value="" name="cheque_cuenta"></td>
							</tr>
							<tr>
								<td>Seleccione Banco</td>
								<td>:</td>
								<td>
									<select id="cheque_banco" name="cheque_banco">
										<option value=""> --SELECCIONE BANCO --</option>
										<% for each valor in bancos %>
											<option value="<% =valor(0) %>"> <% =valor(1) %></option>
										<% next %>
									</select>
								</td>
							</tr>
							<tr>
								<td>Seleccione Plaza</td>
								<td>:</td>
								<td>
									<select id="cheque_plaza" name="cheque_plaza">
										<option value=""> --SELECCIONE PLAZA --</option>
										<% for each valor in plazas %>
											<option value="<% =valor(0) %>"> <% =valor(1) %></option>
										<% next %>
									</select>
								</td>
							</tr>
						</table>
					</div>
					<div id="efectivo" style="display:none;">
						<br><br><strong>EFECTIVO</strong><br>
						<input type="hidden" value="False" name="efectivo_estado">
						<table>
							<tr>
								<td>Valor a pagar</td>
								<td>:</td>
								<td><input type="text" value="" name="efectivo_monto"></td>
							</tr>
						</table>
					</div>
					<div id="credito" style="display:none;">
						<br><br><strong>CREDITO</strong><br>
						<input type="hidden" value="False" name="credito_estado">
						<table>
							<tr>
								<td>Valor a pagar</td>
								<td>:</td>
								<td><input type="text" value="" name="credito_monto"></td>
							</tr>
							<tr>
								<td>Fecha a pagar (dd/mm/yyyy)</td>
								<td>:</td>
								<td><input type="text" value="" name="credito_fecha"></td>
							</tr>
							<tr>
								<td>Numero de Cuenta</td>
								<td>:</td>
								<td><input type="text" value="" name="credito_cuenta"></td>
							</tr>
							<tr>
								<td>Seleccione Banco</td>
								<td>:</td>
								<td>
									<select id="credito_banco" name="credito_banco">
										<option value=""> --SELECCIONE BANCO --</option>
										<% for each valor in bancos %>
											<option value="<% =valor(0) %>"> <% =valor(1) %></option>
										<% next %>
									</select>
								</td>
							</tr>
						</table>
					</div>
					<div id="debito" style="display:none;">
						<br><br><strong>DEBITO</strong><br>
						<input type="hidden" value="False" name="debito_estado">
						<table>
							<tr>
								<td>Valor a pagar</td>
								<td>:</td>
								<td><input type="text" value="" name="debito_monto"></td>
							</tr>
							<tr>
								<td>Fecha a pagar (dd/mm/yyyy)</td>
								<td>:</td>
								<td><input type="text" value="" name="debito_fecha"></td>
							</tr>
							<tr>
								<td>Numero de Cuenta</td>
								<td>:</td>
								<td><input type="text" value="" name="debito_cuenta"></td>
							</tr>
							<tr>
								<td>Seleccione Banco</td>
								<td>:</td>
								<td>
									<select id="debito_banco" name="debito_banco">
										<option value=""> --SELECCIONE BANCO --</option>
										<% for each valor in bancos %>
											<option value="<% =valor(0) %>"> <% =valor(1) %></option>
										<% next %>
									</select>
								</td>
							</tr>
						</table>
					</div>
					<input type="text" value="<% response.write folio_buscar %>" name="folio_referencia" readonly>
					<input type="text" value="<% response.write es_efectivo %>" name="es_efectivo" readonly>
					<input type="submit" value="Cambiar">
				</form>
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