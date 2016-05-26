<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

set botonera =  new CFormulario
botonera.carga_parametros "buscar_cuenta.xml", "btn_busca_cuentas"

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Consulta</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript">
function enviar(formu){
if (formu.cuenta.value!='')
	{
			direccion="agregar_cuenta.asp?cuenta="+formu.cuenta.value+"&viene=1"
	        resultado=window.open(direccion, "ventana2","width=700,height=400,scrollbars=yes, left=200, top=200");
		    // window.close();
	}		   
	else {alert("El Código No Puede Ser Vacio")}
}

</script>
</head>

<body leftmargin="0" topmargin="0" onLoad="MM_preloadImages('../images/enviar2_f2.gif')">
<form name="formu" method="get" >
  <table width="250" border="1" cellpadding="0" cellspacing="0" bordercolor="#A0C0EB" bgcolor="#D8D8DE">
    <tr> 
      <td width="258" align="right">
<div align="center">

          <p><strong>Verificaci&oacute;n de Existencia de Cuenta <br>
            </strong></p>
          <table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#FFFFFF">
            <tr> 
              <td><div align="center"><strong>C&oacute;digo Cuenta 
                  <input name="cuenta" onkeyup="this.value=this.value.toUpperCase();" type="text" size="25" maxlength="18" >
                  </strong></div></td>
            </tr>
          </table>
          <p><strong><%botonera.dibujaboton "enviar"%> </strong></p>
          <p>&nbsp;</p>
</div></td>
    </tr>
  </table>
</form>
</body>
</html>

