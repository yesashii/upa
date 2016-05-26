<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "busca_docentes.xml", "botonera"

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Consulta</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<SCRIPT LANGUAGE="JavaScript" SRC="../biblioteca/validadores.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../biblioteca/funciones.js"></SCRIPT>
<script language="JavaScript" type="text/javascript">
<!--

function enviar(formu){
	if(!(valida_rut(formu.rut.value + '-' + formu.dv.value))){
		    alert('ERROR.\nEl RUT que Ud. ha ingresado no es válido.Por favor, ingréselo nuevamente.');
			formu.rut.focus();
			formu.rut.select();
		 }
		 else{
		   window.opener.document.forms[2].elements["rut"].value = formu.rut.value ;
		   window.opener.document.forms[2].elements["dv"].value = formu.dv.value ;
           window.opener.document.forms[2].action = 'editar_docente.asp';
		   window.opener.document.forms[2].submit();
		   window.close();		   
 		}
}

	//self.opener.location.reload();
	//self.close();
//}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" onLoad="MM_preloadImages('../images/enviar2_f2.gif')">
<form name="formu" method="get" target="_blank">
  <table width="250" border="1" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
    <tr> 
      <td width="258" align="right">
<div align="center">
<p align="right"><strong></strong></p>
          <p><strong>Verificaci&oacute;n de Existencia Docente<br>
            </strong></p>
          <table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#A2A2AC">
            <tr> 
              <td><div align="center"><strong>Rut Docente 
                  <input name="rut" type="text" size="10" maxlength="8">
                  - 
                  <input name="dv" type="text" size="2" maxlength="1">
                  </strong></div></td>
            </tr>
          </table>
		  <br>
          <%
		  'pagina.DibujarBoton "Enviar", "", "enviar(document.formu);"
		  f_botonera.DibujaBoton("enviar")
		  %>
		  <br>          
      </div></td>
    </tr>
  </table>
</form>
</body>
</html>

