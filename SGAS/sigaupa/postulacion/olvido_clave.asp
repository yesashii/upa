<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.InicializaPortal conexion


set f_botonera = new CFormulario
f_botonera.Carga_Parametros "matricula-inicio.xml", "botonera_olvido_clave"

set errores = new CErrores
'---------------------------------------------------------------------------------------------------

%>


<html>
<head>
<title>Consultar Clave Registrada</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
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



function mensaje(){
<%if session("error_clave") <> "" then %>
    alert('<%=session("error_clave")%>');
    <%session("error_clave") = "" 
  end if %>
}
</script>

</head>
<body bgcolor="#555564" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');" onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">  
  <tr>
    <td valign="top" bgcolor="#FFFFFF">

	    <form name="formulario" method="get" action="pregunta_clave.asp">
      <table width="367" border="1" cellspacing="0" cellpadding="0" bordercolor="#003366">
        <tr>
          <td bgcolor="#CCCCCC"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="5%">&nbsp;</td>
                <td width="89%" height="5">&nbsp;</td>
                <td width="6%">&nbsp;</td>
              </tr>
              <tr> 
                <td width="5%">&nbsp;</td>
                <td width="89%"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="#003366">
                    <tr> 
                      <td bgcolor="#CCCCCC"> 
                        <div align="center"><font size="2" color="#FFFFFF" face="Times New Roman, Times, serif"><strong>&iquest;OLVIDASTE TU NOMBRE DE USUARIO 
                          O LA CLAVE?</strong></font></div>
                      </td>
                    </tr>
					<tr> 
                      <td bgcolor="#CCCCCC"><hr></td>
                    </tr>
                    <tr> 
                      <td bgcolor="#CCCCCC"><div align="justify"><br><font size="2" color="#FFFFFF" face="Times New Roman, Times, serif">
    Para recuperar tu nombre de <strong>usuario</strong> o la <strong>clave</strong>, primero debes ingresar tu RUT y responder a la pregunta que ingresaste cuando llenaste los datos en el formulario de <strong>FICHA DE CREACI&Oacute;N DE CLAVES</strong>.<br>
                          <br></font>
                      </div></td>
                    </tr>
                    <tr> 
                      <td height="25" bgcolor="#003366"><font size="2" color="#FFFFFF" face="Times New Roman, Times, serif">
					   <div align="center">RUT Profesional<b> :</b><font color="#FFFFFF"><b> 
                          <input type="text" name="rut" size="10" maxlength="8">
                          </b></font><b> - </b><b> 
                          <input type="text" name="dv" size="2" maxlength="1">
                        </b></div></font></td>
                    </tr>
                    <tr> 
                      <td height="30" bgcolor="#CCCCCC"> 
                        <div align="center"><br>
                          <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td><div align="center">
                                    <%f_botonera.DibujaBoton("aceptar")%>
                              </div></td>
                              <td><div align="center">
                                    <%f_botonera.DibujaBoton("cancelar")%>
                              </div></td>
                            </tr>
                          </table>
                           
                        </div>
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
</td>
  </tr>  
</table>
</body>
</html>
