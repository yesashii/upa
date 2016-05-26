 <!--#include file="../biblioteca/conexion.asp" -->
<%
  rut = Request.form("rut")
  dv  = ucase(Request.form("dv"))
  RUT = rut & "-"& dv
  if session("rut_consulta") <> "" then
    rut = session("rut_consulta")
  end if 
  
  texto = "select USUA_TPREGUNTA from usuarios where USUA_TUSUARIO ='"& rut &"'"
  
  set rs1 = conexion(texto)

  if rs1.BOF and rs1.EOF then
    session("error_clave") = "Error.\nEl postulante no está registrado."
    redir = "olvido_clave.asp"
	response.redirect(redir)
  else
    pregunta = rs1("USUA_TPREGUNTA")
	if IsNull(pregunta) then
	  session("error_clave") = "Error.\nEl postulante está registrado, pero no ingresó pregunta."
      redir = "olvido_clave.asp"
	  response.redirect(redir)
	end if
	session("rut_consulta") = rut
%> 
<html>
<head>
<title>Contrase&ntilde;as</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="estilos/estilos.css" type="text/css">
</head>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript">
function cerrar(){
 window.close();
}
function mensaje(form){
<%if session("error_respuesta") <> "" then %>
    alert('<%=session("error_respuesta")%>');
    <%session("error_respuesta") = "" 
  end if %>
  form.respuesta.focus();
}
function envia(formulario){
  if (formulario.respuesta.value == ''){
    alert('ERROR.\nDebe escribir una respuesta.');
  }
  else{
    if (comilla(formulario.respuesta.value)){
	  alert('ERROR.\nLa respuesta no debe tener comillas');
	}
	else{
	  formulario.submit();
	}
  }
}
function bloquearTeclas(codigo,campo) {
	if(codigo <= 32 || (codigo > 47 && codigo < 58) || (codigo > 64 && codigo < 91) || (codigo >= 96 && codigo < 122) ||(codigo == 219) || (codigo == 221)) {
		return codigo;
	}
	return false;
}
</script>
<body bgcolor="#F1F1E4" onLoad="mensaje(document.form1);"  text="#000000" leftmargin="10" topmargin="10" marginwidth="0" marginheight="0" link ="#FFFFFF" alink="#FFFFFF" vlink= "#FFFFFF">
<form name="form1" method="post" action="respuesta.asp">
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
              <table width="100%" border="1" cellspacing="0" cellpadding="1" bordercolor="#FFFFFF">
                <tr> 
                  <td height="30" bgcolor="#ebebeb"> 
                    <div align="center"><b>&iquest;OLVIDASTE TU NOMBRE DE USUARIO 
                      O LA CLAVE?</b></div>
                  </td>
                </tr>
                <tr> 
                  <td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td width="17%" height="20">RUT <b> </b></td>
                        <td width="83%"> :<b> <%=rut%></b></td>
                      </tr>
                      <tr> 
                        <td width="17%" height="20">Pregunta </td>
                        <td width="83%"> : <%=pregunta%></td>
                      </tr>
                      <tr> 
                        <td width="17%" height="15">Respuesta</td>
                        <td width="83%">: 
                          <input type="text" name="respuesta" size="40" maxlength="40" >
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td height="25"><font color="#FFFFFF"><b> </b></font></td>
                </tr>
                <tr> 
                  <td height="30"> 
                    <div align="center"><a href="javascript:envia(document.form1);"><img src="../images/aceptar_tr.gif" width="66" height="20" border="0"></a>&nbsp;&nbsp;&nbsp;<a href="javascript:cerrar();"><img src="../images/cancelar2.gif" width="66" height="20" border="0"></a>&nbsp;&nbsp;</div>
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
<%end if %>
