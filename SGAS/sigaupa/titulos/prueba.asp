<%
	saca_ncorr = Request.QueryString("saca_ncorr")
	pers_ncorr = Request.QueryString("pers_ncorr")
	tsca_ccod  = Request.QueryString("tsca_ccod")
	valor = Request.QueryString("valor")
	if valor <> "" then
		Response.Redirect "certificado_titulo.asp?saca_ncorr="&saca_ncorr&"&pers_ncorr="&pers_ncorr&"&tsca_ccod="&tsca_ccod&"&valor="&valor
	end if

%>
<form name='envia' method='GET' action='prueba.asp'>
	<input type='hidden' id='saca_ncorr' name='saca_ncorr' value=<%=saca_ncorr%>>
	<input type='hidden' id='pers_ncorr' name='pers_ncorr' value=<%=pers_ncorr%>>
	<input type='hidden' id='tsca_ccod' name='tsca_ccod' value=<%=tsca_ccod%>>
	<input type='hidden' id='valor' name='valor'>
</form>
<script language='JavaScript'>
	var x;
    if (confirm("Desea Imprimir Mensión") == true) {
        x = "1";
    } else {
        x = "0";
    }
    document.getElementById("valor").value = x;
	document.envia.submit()
</script>