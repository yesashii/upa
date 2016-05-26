<!-- #include file = "cambio_rut_proc.asp" -->

<%
'---------------------------------------------------------------------------------------------------

Set rut_controlador = new controlador_rut

set pagina = new CPagina
pagina.Titulo = "Cambio de R.U.T."

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

rut_antiguo = Request.Form("rut_antiguo")
digito_antiguo = Request.Form("digito_antiguo")

if rut_antiguo <> "" AND digito_antiguo <> "" then
	encontrado = rut_controlador.obtener_persona(rut_antiguo, digito_antiguo)
	encontrados = false
	
	if encontrado(0) <> "" then
		encontrados = true
	end if
end if

dim arreglo(3)
arreglo(0) = Request.Form("nuevo_rut")
arreglo(1) = Request.Form("nuevo_digito")
arreglo(2) = Request.Form("tabla")
arreglo(3) = Request.Form("pers_ncorr")

if arreglo(0)<>"" AND arreglo(1)<>"" AND arreglo(2)<>"" AND arreglo(3)<>"" then
	rut_controlador.cambiar_rut(arreglo)
end if


%>
<html>
<head>
<title>Cambio De Rut</title>
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
	function calcular_digito(a,b)
	{
		document.getElementById(b).value = digito(a.value);
	}
	function digito(a)
	{
		var secuencia = 2
		var sum = 0;
		var rut=a;
	
		if (!rut || !rut.length || typeof rut !== 'string') {
			return "";
		}
	
		for (var i=rut.length - 1; i >=0; i--) {
			var d = rut.charAt(i)
			sum += new Number(d)* secuencia;
			secuencia +=1;
			if(secuencia == 8){
				secuencia=2;
			}
		};
	
		var rest = 11 - (sum % 11);
	
		if(rest==11)
		{
			rest = 0;
		}
		else if(rest == 10)
		{
			rest= "K";
		}
		return rest;
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
                        <td><div align="right"><strong>Buscar Persona</strong></div></td>
                        <td width="7%"><div align="center"><strong>:</strong></div></td>
                        <td width="61%"><div align="left">
							<input type="text" name="rut_antiguo" id ="rut_antiguo" onKeyDown="esnumero(this)" onBlur="esnumero(this)" onKeyUp="esnumero(this)" size="10">
							-<input type="text" name="digito_antiguo" id ="digito_antiguo" size="1">
							<a href="javascript:buscar_persona('rut_antiguo', 'digito_antiguo');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></div></td>
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
						<td><strong>Nombre</strong></td>
						<td>:</td>
						<td><% response.write encontrado(3)&" "&encontrado(4)&" "&encontrado(5)%></td>
					</tr>
					<tr>
						<td><strong>Rut Antiguo</strong></td>
						<td>:</td>
						<td><% response.write encontrado(1)&"-"&encontrado(2)%></td>
					</tr>
					
				</table>
				<br>
				<form name="cambiar" method="post">
					Ingrese Nuevo Rut: 
					<input type="text" name="nuevo_rut" id="nuevo_rut" size="10" onKeyDown="esnumero(this)" onBlur="esnumero(this); calcular_digito(this, 'nuevo_digito')" onKeyUp="esnumero(this)">-
					<input type="text" name="nuevo_digito" id="nuevo_digito" size="1" readonly>
					<input type="hidden" name="tabla" id="tabla" value="<% response.write encontrado(6)%>" readonly>
					<input type="hidden" name="pers_ncorr" id="pers_ncorr" value="<% response.write encontrado(0)%>" readonly>
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