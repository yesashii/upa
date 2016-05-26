 <%
 SESSION.ABANDON
 Response.addHeader "pragma", "no-cache"
 Response.CacheControl = "Private"
 Response.Expires = 0
%>
<html>
<head>
<title>Contrase&ntilde;as</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="estilos/estilos.css" type="text/css">
</head>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript">
function enviar(formulario){
 if (formulario.rut.value ==''){
   alert('Debe ingresar RUT.');
   formulario.rut.focus();
 }
 else{
   if(formulario.dv.value == ''){
     alert('Debe ingresar DV.');
	 formulario.dv.focus();
   }
   else{
     if(comilla(formulario.rut.value)){
	   alert('RUT no debe llevar comilla simple.');
	 }
	 else{
	   if(comilla(formulario.dv.value)){
	      alert('DV no debe llevar comilla simple.');
	   }
	   else{
	     formulario.action = 'pregunta_clave.asp';
	     formulario.submit();
	   }
	 }
   }
 }
}
function salir(){
 window.close();
}
function mensaje(){
<%if session("error_clave") <> "" then %>
    alert('<%=session("error_clave")%>');
    <%session("error_clave") = "" 
  end if %>
}
</script>
<body bgcolor="#F1F1E4" onLoad="mensaje();" text="#000000" leftmargin="10" topmargin="10" marginwidth="2" marginheight="2" link ="#FFFFFF" alink="#FFFFFF" vlink= "#FFFFFF">
<form name="formulario" method="post" action="pregunta_clave.asp">
  <table width="367" border="1" cellspacing="0" cellpadding="0" bordercolor="#FFFFFF">
    <tr>
      <td> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="5%">&nbsp;</td>
            <td width="89%" height="5">&nbsp;</td>
            <td width="6%">&nbsp;</td>
          </tr>
          <tr> 
            <td width="5%">&nbsp;</td>
            <td width="89%"> 
              <table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#FFFFFF">
                <tr> 
                  <td height="30" bgcolor="#ebebeb"> 
                    <div align="center"><b>&iquest;OLVIDASTE TU NOMBRE DE USUARIO 
                      O LA CLAVE?</b></div>
                  </td>
                </tr>
                <tr> 
                  <td><br>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Para 
                    recuperar tu nombre de <b>usuario</b> o la <b>clave</b>,<br>
                    &nbsp;&nbsp;primero debes ingresar tu <b>RUT </b>y responder 
                    a la pregunta <br>
                    &nbsp;&nbsp;que ingresaste cuando llenaste los datos en el 
                    formulario de <br>
                    <b>&nbsp;&nbsp;FICHA DE CREACI&Oacute;N DE CLAVES</b>. <br>
                    <br>
                  </td>
                </tr>
                <tr> 
                  <td height="25">RUT Profesional<b> :</b><font color="#FFFFFF"><b> 
                    <input type="text" name="rut" size="10" maxlength="8">
                    </b></font><b> - </b><font color="#FFFFFF"><b> 
                    <input type="text" name="dv" size="2" maxlength="1">
                    </b></font></td>
                </tr>
                <tr> 
                  <td height="30"> 
                    <div align="center"><a href="javascript:enviar(document.formulario);"><img src="../images/aceptar_tr.gif" width="66" height="20" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp; 
                      &nbsp;&nbsp;&nbsp;&nbsp; <a href="javascript:salir();"><img src="../images/cancelar2.gif" width="66" height="20" border="0"></a></div>
                  </td>
                </tr>
              </table>
            </td>
            <td width="6%">&nbsp;</td>
          </tr>
          <tr> 
            <td width="5%" height="5">&nbsp;</td>
            <td width="89%">&nbsp;</td>
            <td width="6%">&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</form>
</body>
</html>
