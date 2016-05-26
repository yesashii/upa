<html>
<head>
<title>Inicio</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="estilos/estilos.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript" type="text/JavaScript">
function enviar(form){
  if(preValidaFormulario(form)){
    return true; 
  }
  else{
    return false;
  }
}

function clave(){
  direccion = "olvido_clave.asp";
  window.open(direccion ,"ventana1","width=387,height=205,scrollbars=no, left=313, top=200");
}
function registrarse(){
  window.location = 'pre_registrarse.asp';
}

function anterior(){
window.location = 'principal.htm';
}
function siguiente(){
window.location = 'postulacion2.htm';
}
function mensaje(form){
<%if session("ses_error_index") <> "" then %>
alert('<%=session("ses_error_index")%>');
<%session("ses_error_index") = ""
end if %>
form.usuario.focus();
}
</script>
<STYLE type="text/css">
 <!-- 
 A {color: #000000;  text-decoration: none; font-weight: bold;}
 A:hover {COLOR: #63ABCC; }

 // -->
 </STYLE>
</head>
<body onLoad="javascript:mensaje(document.formulario);" bgcolor="#21559C" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table border="0" cellpadding="0" cellspacing="0" width="754" align="center">
  <tr> 
    <td><img src="../images/spacer.gif" width="9" height="1" border="0" alt=""></td>
    <td><img src="../images/spacer.gif" width="16" height="1" border="0" alt=""></td>
    <td><img src="../images/spacer.gif" width="117" height="1" border="0" alt=""></td>
    <td><img src="../images/spacer.gif" width="591" height="1" border="0" alt=""></td>
    <td><img src="../images/spacer.gif" width="21" height="1" border="0" alt=""></td>
    <td><img src="../images/spacer.gif" width="1" height="1" border="0" alt=""></td>
  </tr>
  <tr> 
    <td colspan="3"><img name="int_r1_c1" src="../images/int_r1_c1.gif" width="142" height="83" border="0" alt=""></td>
    <td colspan="2"><img name="int_r1_c4" src="../images/int_r1_c4.gif" width="612" height="83" border="0" alt=""></td>
    <td><img src="../images/spacer.gif" width="1" height="83" border="0" alt=""></td>
  </tr>
  <tr> 
    <td colspan="2"><img name="int_r2_c1" src="../images/int_r2_c1.gif" width="25" height="13" border="0" alt=""></td>
    <td colspan="2"><img name="int_r2_c3" src="../images/int_r2_c3.gif" width="708" height="13" border="0" alt=""></td>
    <td><img name="int_r2_c5" src="../images/int_r2_c5.gif" width="21" height="13" border="0" alt=""></td>
    <td><img src="../images/spacer.gif" width="1" height="13" border="0" alt=""></td>
  </tr>
  <tr> 
    <td colspan="2" rowspan="3" background="../images/int_r3_c1.gif"><img name="int_r3_c1" src="../images/int_r3_c1.gif" width="25" height="100%" border="0" alt=""></td>
    <td colspan="2" align="right" bgcolor="#2359A3"><font color="#FFFFFF">&nbsp;</font></td>
    <td rowspan="3" background="../images/int_r3_c5.gif"><img name="int_r3_c5" src="../images/int_r3_c5.gif" width="21" height="100%" border="0" alt=""></td>
    <td><img src="../images/spacer.gif" width="1" height="21" border="0" alt=""></td>
  </tr>
  <tr> 
    <td rowspan="2" colspan="2" bgcolor="#2359A3" valign="top"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="34%" valign="top"><font color="#FFFFFF">&nbsp;&nbsp;&nbsp;Bienvenido 
            al Proceso de Postulaci&oacute;n 2003.<br>
            <br>
            Te invitamos a ingresar tus datos en la Ficha &Uacute;nica de Postulaci&oacute;n. 
            Los datos aqu&iacute; ingresados, ser&aacute;n requeridos cuando te 
            matricules en nuestra Instituci&oacute;n.<br>
            <br>
            &nbsp;&nbsp;&nbsp;Es muy importante la veracidad de los datos que 
            ingreses, ya que &eacute;stos te permitir&aacute;n postular a Becas 
            y Pase Escolar.<br>
            <br>
            &nbsp;&nbsp;&nbsp;Para hacer efectiva tu matr&iacute;cula, debes dirigirte 
            a la Oficina de Admisi&oacute;n y Matr&iacute;cula<br>
            de la sede de INACAP m&aacute;s cercana.<br>
            <br>
            &nbsp;&nbsp;&nbsp;En ning&uacute;n caso el llenado de esta ficha constituye 
            matr&iacute;cula o reserva de cupo en los Programas de Estudio (Carreras) 
            de INACAP.</font></td>
          <td><table border="0" cellpadding="0" cellspacing="0" width="462" align="center">
              <tr> 
                <td><img src="../images/spacer.gif" width="7" height="1" border="0" alt=""></td>
                <td><img src="../images/spacer.gif" width="17" height="1" border="0" alt=""></td>
                <td><img src="../images/spacer.gif" width="106" height="1" border="0" alt=""></td>
                <td><img src="../images/spacer.gif" width="21" height="1" border="0" alt=""></td>
                <td><img src="../images/spacer.gif" width="300" height="1" border="0" alt=""></td>
                <td><img src="../images/spacer.gif" width="11" height="1" border="0" alt=""></td>
                <td><img src="../images/spacer.gif" width="1" height="1" border="0" alt=""></td>
              </tr>
              <tr> 
                <td rowspan="4" colspan="2"><img name="inform_r1_c1" src="../images/inform_r1_c1.gif" width="24" height="26" border="0" alt=""></td>
                <td><img name="inform_r1_c3" src="../images/inform_r1_c3.gif" width="106" height="5" border="0" alt=""></td>
                <td rowspan="4"><img name="inform_r1_c4" src="../images/inform_r1_c4.gif" width="21" height="26" border="0" alt=""></td>
                <td rowspan="2"><img name="inform_r1_c5" src="../images/inform_r1_c5.gif" width="300" height="12" border="0" alt=""></td>
                <td rowspan="2"><img name="inform_r1_c6" src="../images/inform_r1_c6.gif" width="11" height="12" border="0" alt=""></td>
                <td><img src="../images/spacer.gif" width="1" height="5" border="0" alt=""></td>
              </tr>
              <tr> 
                <td width="106" height="16" rowspan="2" bgcolor="#B7B7B7"><div align="center"><strong><font color="#666666">INGRESO</font></strong></div></td>
                <td><img src="../images/spacer.gif" width="1" height="7" border="0" alt=""></td>
              </tr>
              <tr> 
                <td rowspan="2"><img name="inform_r3_c5" src="../images/inform_r3_c5.gif" width="300" height="14" border="0" alt=""></td>
                <td rowspan="3" background="../images/inform_r3_c6.gif"><img name="inform_r3_c6" src="../images/inform_r3_c6.gif" width="11" height="166" border="0" alt=""></td>
                <td><img src="../images/spacer.gif" width="1" height="9" border="0" alt=""></td>
              </tr>
              <tr> 
                <td><img name="inform_r4_c3" src="../images/inform_r4_c3.gif" width="106" height="5" border="0" alt=""></td>
                <td><img src="../images/spacer.gif" width="1" height="5" border="0" alt=""></td>
              </tr>
              <tr> 
                <td background="../images/inform_r5_c1.gif"><img name="inform_r5_c1" src="../images/inform_r5_c1.gif" width="7" height="152" border="0" alt=""></td>
                <td colspan="4" bgcolor="#F1F1E4"> <form  method="post" name="formulario" action="proc_index_matricula.asp" onSubmit="return enviar(document.formulario);" >
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td width="20%" height="22">&nbsp;</td>
                        <td width="20%">&nbsp;</td>
                        <td width="2%">&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="20%">&nbsp;</td>
                        <td width="20%" height="25"><strong>USUARIO (RUT)</strong></td>
                        <td width="2%">:</td>
                        <td><input name="usuario" type="text" id="TO-N" size="25" maxlength="25"></td>
                      </tr>
                      <tr> 
                        <td width="20%">&nbsp;</td>
                        <td width="20%" height="25"><strong>CLAVE</strong></td>
                        <td width="2%">:</td>
                        <td> <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td><input name="clave" type="password" id="TO-N" size="25" maxlength="25"></td>
                              <td><input name="imageField" type="image" src="../images/aceptar_tr.gif" width="66" height="20" border="0"></td>
                            </tr>
                          </table></td>
                      </tr>
                      <tr> 
                        <td width="20%">&nbsp;</td>
                        <td width="20%">&nbsp;</td>
                        <td width="2%">&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height="25" colspan="4"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td width="19%">&nbsp;</td>
                              <td width="31%" height="25">&#8226;&nbsp; <strong><a href="javascript:clave();">&iquest;OLVID&Oacute; 
                                CLAVE?</a></strong></td>
                              <td width="50%">&#8226; <a href="javascript:registrarse();"><strong>&nbsp;REGISTRARSE</strong></a></td>
                            </tr>
                          </table></td>
                      </tr>
                      <tr> 
                        <td height="25">&nbsp;</td>
                        <td colspan="3">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height="25">&nbsp;</td>
                        <td colspan="3">&nbsp;</td>
                      </tr>
                    </table>
                  </form></td>
                <td><img src="../images/spacer.gif" width="1" height="152" border="0" alt=""></td>
              </tr>
              <tr> 
                <td><img name="inform_r6_c1" src="../images/inform_r6_c1.gif" width="7" height="9" border="0" alt=""></td>
                <td colspan="4"><img name="inform_r6_c2" src="../images/inform_r6_c2.gif" width="444" height="9" border="0" alt=""></td>
                <td><img name="inform_r6_c6" src="../images/inform_r6_c6.gif" width="11" height="9" border="0" alt=""></td>
                <td><img src="../images/spacer.gif" width="1" height="9" border="0" alt=""></td>
              </tr>
            </table></td>
        </tr>
      </table></td>
    <td><img src="../images/spacer.gif" width="1" height="155" border="0" alt=""></td>
  </tr>
  <tr> 
    <td><img src="../images/spacer.gif" width="1" height="176" border="0" alt=""></td>
  </tr>
</table>
<table width="754" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><div align="center"><font color="#FFFFFF">Para consultas del Proceso de 
        Postulaci&oacute;n, puedes llamar al n&uacute;mero 800 20 25 20.<br>
        Sitio Optimizado para resoluci&oacute;n 800x600, use Internet Explorer 
        5.5 o superior.</font></div></td>
  </tr>
</table>
</body>
</html>
