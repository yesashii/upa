<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
codigo_solicitud	= request.querystring("cod")
nro_solicitud		= request.querystring("nro")


set botonera =  new CFormulario
botonera.carga_parametros "solicitud_presupuestaria.xml", "botonera"

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Motivo Rechazo</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript">
function enviar(formu){
if (formu.rechazo.value!='')
	{
		
		formu.action = "proc_agregar_rechazo.asp";
		formu.method = "post";
		formu.submit(); 
			
		/*	direccion="proc_agregar_rechazo.asp?cod=<%=codigo_solicitud%>&nro=<%=nro_solicitud%>";
	        resultado=window.open(direccion, "ventana2","width=700,height=400,scrollbars=yes, left=200, top=200");*/
		    // window.close();
	}		   
	else {
	alert("El motivo no puede ser vacío")
	}
}

</script>
</head>

<body leftmargin="0" topmargin="0" onLoad="MM_preloadImages('../images/enviar2_f2.gif')">
<form name="formu" method="post" >
<input type="hidden" name="nro" value="<%=nro_solicitud%>">
<input type="hidden" name="cod" value="<%=codigo_solicitud%>">
  <table align="center" width="250" border="1" cellpadding="0" cellspacing="0" bordercolor="#A0C0EB" bgcolor="#D8D8DE">
    <tr> 
      <td width="258" align="right">
<div align="center">

          <p><strong>Ingreso motivo rechazo solicitud<br>
            </strong></p>
          <table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#FFFFFF">
            <tr> 
              <td><div align="center">
                  <textarea name="rechazo" cols="40" rows="5"></textarea>
                  </div></td>
            </tr>
          </table>
          <p><strong><%botonera.dibujaboton "enviar"%></strong></p>
          <p>&nbsp;</p>
</div></td>
    </tr>
  </table>
</form>
</body>
</html>

