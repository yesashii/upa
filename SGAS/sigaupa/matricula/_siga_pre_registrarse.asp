<html>
<head>
<title>Ficha de creaci&oacute;n de claves</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="estilos/estilos.css" rel="stylesheet" type="text/css">
<SCRIPT LANGUAGE="JavaScript" SRC="../biblioteca/validadores.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../biblioteca/funciones.js"></SCRIPT>
<script language="JavaScript" type="text/JavaScript">
function habilita(form,valor,obj1){
	if (valor == '1'){
	  obj1.visibility = "visible" ;
	}
	else{
	  obj1.visibility = "hidden" ;
	}
}
function enviar(form){
 form.dv.value = form.dv.value.toUpperCase();
 var cont = 0;
 for (i=0; i<form.radio.length; i++){
    if(form.radio[i].checked == true){
      cont = cont +1 ;
	  check = i;
    }
 }
 if (cont == 0){
   alert('Debe elegir una opción antes de continuar.');
 }
 else{
    var val= form.radio[check].value;
	if (val==1){
	   if((form.rut.value == '') || (form.dv.value == '')){
	      alert('Si Ud. es una persona chilena, debe ingresar su número de RUT.')
		  form.rut.focus();
	   }
	   else{
	     if(!(valida_rut(form.rut.value + '-' + form.dv.value))){
		    alert('ERROR.\nEl RUT que Ud. ha ingresado no es válido.Por favor, ingréselo nuevamente.');
			form.rut.focus();
			form.rut.select();
		 }
		 else{
	        form.action = 'proc_pre_valida.asp';
		    form.submit();
	     }		
	   }
	}
	else{
	   form.action = 'proc_pre_valida.asp';
	   form.submit();
	}
 }	
}

function mensaje(){
<%if session("mens_error_registro") <> "" then %>
alert('<%=session("mens_error_registro")%>');
<%session("mens_error_registro") = ""
end if %>
}
</script>
</head>
<body onLoad="javascript:mensaje();" bgcolor="#21559C" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table border="0" cellpadding="0" cellspacing="0" width="754" align="center">
  <!-- fwtable fwsrc="interior.png" fwbase="int.gif" fwstyle="Dreamweaver" fwdocid = "342205829" fwnested="0" -->
  <tr> 
    <td><img src="../images/spacer.gif" width="9" height="1" border="0" alt=""></td>
    <td><img src="../images/spacer.gif" width="16" height="1" border="0" alt=""></td>
    <td><img src="../images/spacer.gif" width="117" height="1" border="0" alt=""></td>
    <td><img src="../images/spacer.gif" width="591" height="1" border="0" alt=""></td>
    <td><img src="../images/spacer.gif" width="21" height="1" border="0" alt=""></td>
    <td><img src="../images/spacer.gif" width="1" height="1" border="0" alt=""></td>
  </tr>
  <tr> 
    <td colspan="3"><div align="right"><img name="int_r1_c1" src="../images/int_r1_c1.gif" width="142" height="83" border="0" alt=""></div></td>
    <td colspan="2"><img name="int_r1_c4" src="../images/int_r1_c4.gif" width="612" height="83" border="0" alt=""></td>
    <td><img src="../../images/spacer.gif" width="1" height="83" border="0" alt=""></td>
  </tr>
  <tr> 
    <td colspan="2"><img name="int_r2_c1" src="../images/int_r2_c1.gif" width="25" height="13" border="0" alt=""></td>
    <td colspan="2" background="../images/int_r2_c3.gif"><img name="int_r2_c3" src="../images/int_r2_c3.gif" width="708" height="13" border="0" alt=""></td>
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
    <td rowspan="2" colspan="2" bgcolor="#2359A3" valign="top"> <table border="0" cellpadding="0" cellspacing="0" width="90%" align="center">
        <!-- fwtable fwsrc="marco ancho.png" fwbase="int_ancha.gif" fwstyle="Dreamweaver" fwdocid = "342205829" fwnested="0" -->
        <tr> 
          <td><img src="../images/spacer.gif" width="6" height="1" border="0" alt=""></td>
          <td><img src="../images/spacer.gif" width="463" height="1" border="0" alt=""></td>
          <td><img src="../images/spacer.gif" width="19" height="1" border="0" alt=""></td>
          <td><img src="../images/spacer.gif" width="198" height="1" border="0" alt=""></td>
          <td><img src="../images/spacer.gif" width="9" height="1" border="0" alt=""></td>
          <td><img src="../images/spacer.gif" width="1" height="1" border="0" alt=""></td>
        </tr>
        <tr> 
          <td colspan="5" bgcolor="#F1F1E4"> <table width="100%" border="1" cellspacing="0" cellpadding="1" bordercolor="#FFFFFF">
              <tr bordercolor="#FFFFFF"> 
                <td width="32%" bgcolor="#F1F1E4"> 
                  <div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif"> 
                    <img src="../images/flecha2.gif" width="7" height="7"> <b><font color="#CC3300">FICHA 
                    DE CREACI&Oacute;N DE CLAVES</font></b></font></div>
                  <div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif"></font></div></td>
                <td width="12%" bgcolor="#F1F1E4"></td>
                <td width="17%" bgcolor="#F1F1E4"></td>
                <td width="16%" bgcolor="#F1F1E4"></td>
                <td width="23%" bgcolor="#F1F1E4"></td>
              </tr>
            </table></td>
          <td><img src="../images/spacer.gif" width="1" height="21" border="0" alt=""></td>
        </tr>
        <tr> 
          <td background="../images/int_ancha_r2_c1.gif"><img name="int_ancha_r2_c1" src="../images/int_ancha_r2_c1.gif" width="6" height="147" border="0" alt=""></td>
          <td colspan="3" bgcolor="#F1F1E4"><form action="man_formulario.asp" method="post" name="formulario1">
              <table width="100%" border="0" cellpadding="0" cellspacing="0"> 
                <tr> 
                  <td height="20" valign="middle"> <div align="center"><font color="#000066" size="2"><strong></strong></font></div></td>
                </tr>
                <tr> 
                  <td>
<div align="right">
                    </div>
                    <table width="90%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#A0C0EB" bgcolor="#FBFBF7">
                      <tr> 
                        <td valign="middle"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td width="5%">&nbsp;</td>
                              <td width="89%" height="5">&nbsp;</td>
                              <td width="6%">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td width="5%">&nbsp;</td>
                              <td width="89%"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td><p><br>
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">&nbsp;&nbsp;Antes 
                                        de continuar, debes especificar si eres 
                                        chileno o extranjero.</font></p>
                                      <p><font size="2"><strong>ATENCI&Oacute;N:</strong><br>
                                        <strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Si 
                                        eres extranjero y ya tienes tu c&eacute;dula 
                                        de identidad chilena, ingresa como chileno.</strong></font><br>
                                        <br>
                                        <br>
                                      </p></td>
                                  </tr>
                                  <tr> 
                                    <td height="25"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="25%"> 
                                            <input type="radio" name="radio" value="1" onClick="javascript:habilita(this.form,1,capa_rut.style);">
                                            Soy chileno </td>
                                          <td width="2%">&nbsp;</td>
                                          <td><div id="capa_rut"  style= "visibility:hidden">Ingrese 
                                              su RUT : 
                                              <input name="rut" type="text" id="rut" size="10" maxlength="8">
                                              - 
                                              <input name="dv" type="text" id="dv" size="1" maxlength="1">
                                            </div></td>
                                        </tr>
                                        <tr> 
                                          <td width="25%"> <input type="radio" name="radio" value="2" onClick="javascript:habilita(this.form,2,capa_rut.style);">
                                            Soy extranjero</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="25%">&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                        </tr>
                                      </table></td>
                                  </tr>
                                  <tr> 
                                    <td height="30"> <div align="center">&nbsp;&nbsp;&nbsp; 
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; 
                                      </div></td>
                                  </tr>
                                </table></td>
                              <td width="6%">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td width="5%" height="5">&nbsp;</td>
                              <td width="89%">&nbsp;</td>
                              <td width="6%">&nbsp;</td>
                            </tr>
                          </table> </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </form></td>
          <td background="../images/int_ancha_r2_c5.gif"><img name="int_ancha_r2_c5" src="../images/int_ancha_r2_c5.gif" width="9" height="147" border="0" alt=""></td>
          <td><img src="../images/spacer.gif" width="1" height="147" border="0" alt=""></td>
        </tr>
      </table>
      <table border="0" cellpadding="0" cellspacing="0" width="548" align="center">
        <!-- fwtable fwsrc="marco.png" fwbase="botonera.gif" fwstyle="Dreamweaver" fwdocid = "342205829" fwnested="0" -->
        <tr> 
          <td bgcolor="#F1F1E4"><img src="../images/spacer.gif" width="4" height="1" border="0" alt=""></td>
          <td bgcolor="#F1F1E4"><img src="../images/spacer.gif" width="318" height="1" border="0" alt=""></td>
          <td bgcolor="#F1F1E4"><img src="../images/spacer.gif" width="19" height="1" border="0" alt=""></td>
          <td bgcolor="#F1F1E4"><img src="../images/spacer.gif" width="65" height="1" border="0" alt=""></td>
          <td bgcolor="#F1F1E4"><img src="../images/spacer.gif" width="67" height="1" border="0" alt=""></td>
          <td bgcolor="#F1F1E4"><img src="../images/spacer.gif" width="66" height="1" border="0" alt=""></td>
          <td bgcolor="#F1F1E4"><img src="../images/spacer.gif" width="9" height="1" border="0" alt=""></td>
          <td><img src="../images/spacer.gif" width="1" height="1" border="0" alt=""></td>
        </tr>
        <tr> 
          <td rowspan="4" bgcolor="#F1F1E4"><img name="botonera_r1_c1" src="../images/botonera_r1_c1.gif" width="4" height="31" border="0" alt=""></td>
          <td rowspan="2" bgcolor="#F1F1E4">&nbsp;</td>
          <td rowspan="4"><img name="botonera_r1_c3" src="../images/botonera_r1_c3.gif" width="19" height="31" border="0" alt=""></td>
          <td colspan="3" background="../images/botonera_r1_c4.gif"><img name="botonera_r1_c4" src="../images/botonera_r1_c4.gif" width="198" height="4" border="0" alt=""></td>
          <td rowspan="4"><img name="botonera_r1_c7" src="../images/botonera_r1_c7.gif" width="9" height="31" border="0" alt=""></td>
          <td><img src="../images/spacer.gif" width="1" height="4" border="0" alt=""></td>
        </tr>
        <tr> 
          <td rowspan="2" bgcolor="#B9B9B9">&nbsp;</td>
          <td rowspan="2" bgcolor="#B9B9B9"><a href="javascript:enviar(document.formulario1);"><img name="botonera_r2_c6" src="../images/enviar2.gif" width="66" height="20" border="0" alt=""></a></td>
          <td rowspan="2" bgcolor="#B9B9B9"><a href="inicio.asp"><img name="botonera_r2_c6" src="../images/botonera_r2_c6.gif" width="66" height="20" border="0" alt=""></a></td>
          <td><img src="../images/spacer.gif" width="1" height="15" border="0" alt=""></td>
        </tr>
        <tr> 
          <td rowspan="2" background="../images/botonera_r3_c2.gif"><img name="botonera_r3_c2" src="../images/botonera_r3_c2.gif" width="465" height="12" border="0" alt=""></td>
          <td><img src="../images/spacer.gif" width="1" height="5" border="0" alt=""></td>
        </tr>
        <tr> 
          <td colspan="3" background="../images/botonera_r4_c4.gif"><img name="botonera_r4_c4" src="../images/botonera_r4_c4.gif" width="198" height="7" border="0" alt=""></td>
          <td><img src="../images/spacer.gif" width="1" height="7" border="0" alt=""></td>
        </tr>
      </table></td>
    <td><img src="../images/spacer.gif" width="1" height="155" border="0" alt=""></td>
  </tr>
  <tr> 
    <td><img src="../images/spacer.gif" width="1" height="176" border="0" alt=""></td>
  </tr>
</table>
</body>
</html>