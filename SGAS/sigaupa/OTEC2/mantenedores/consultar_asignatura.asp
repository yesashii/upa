<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
codigo  = request.QueryString("codigo")
set botonera =  new CFormulario
botonera.carga_parametros "m_modulos.xml", "btn_busca_asignaturas"

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
	if (formu.mote_ccod.value!='')
	{
		   //window.opener.document.forms[0].mote_ccod.value = formu.mote_ccod.value ;
		   //window.opener.document.forms[0].action = 'editar_modulos.asp';
		   //window.opener.document.forms[0].submit();
		   
		   direccion = "editar_modulos.asp?codigo="+ formu.mote_ccod.value;
	       resultado=window.open(direccion, "ventana2","width=400,height=200,scrollbars=no, left=380, top=350");
		   window.close();
	}		   
	else {alert("El Código No Puede Ser Vacio")}
}

</script>
</head>

<body leftmargin="0" topmargin="0" onLoad="MM_preloadImages('../images/enviar2_f2.gif')" onBlur="revisaVentana();" >
<form name="formu" method="get" >
  <table width="250" border="1" cellpadding="0" cellspacing="0" bordercolor="#A0C0EB" bgcolor="#D8D8DE">
    <tr> 
      <td width="258" align="right">
<div align="center">
<p align="right"><strong></strong></p>
          <p><strong>Verificaci&oacute;n de Existencia de Módulos<br>
            </strong></p>
          <table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#FFFFFF">
            <tr> 
              <td><div align="center"><strong>C&oacute;digo del Módulo
                    <input name="mote_ccod" onkeyup="this.value=this.value.toUpperCase();" type="text" size="10" maxlength="8" value="<%=codigo%>">
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

