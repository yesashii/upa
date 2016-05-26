<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
set pagina = new CPagina

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_consulta = new CFormulario
f_consulta.Carga_Parametros "consulta.xml", "consulta"
f_consulta.Inicializar conexion


rut = Request("rut")
dv  = ucase(Request("dv"))

RUT = rut & "-" & dv
  
texto = "select USUA_TPREGUNTA from usuarios where USUA_TUSUARIO ='" & rut & "'" 
f_consulta.Consultar texto
f_consulta.Siguiente

if f_consulta.NroFilas = 0 then
	session("mensajeError") = "Error.\nEl postulante no está registrado."    
	Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
else 
	pregunta = f_consulta.ObtenerValor("USUA_TPREGUNTA")
	if IsNull(pregunta) then
	  session("mensajeError") = "Error.\nEl postulante está registrado, pero no ingresó pregunta."
	  Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
	end if
	
	
	'---------------------------------------------------------------------------------------------------
	set f_botonera = new CFormulario
	f_botonera.Carga_Parametros "matricula-inicio.xml", "botonera_pregunta_clave"


	set errores = new CErrores
	'---------------------------------------------------------------------------------------------------
%>


<html>
<head>
<title>Contrase&ntilde;as</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
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

</head>
<body bgcolor="#555564" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); " onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">	 
	    <form name="form1" method="get" action="respuesta.asp">
		<input type="hidden" name="rut" value="<%=rut%>">
      <table width="367" border="1" cellspacing="0" cellpadding="0" bordercolor="#FFFFFF">
        <tr>
          <td>            <table width="100%" border="0" cellspacing="0" cellpadding="0">
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
                      <div align="center"><b>&iquest;OLVIDASTE TU NOMBRE DE USUARIO O LA CLAVE?</b></div></td>
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
                    </table></td>
                  </tr>
                  <tr>
                    <td height="25"><font color="#FFFFFF"><b> </b></font></td>
                  </tr>
                  <tr>
                    <td height="30">
                      <div align="center">
                        <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td><div align="center"><%f_botonera.DibujaBoton("aceptar")%></div></td>
                            <td><div align="center">
                              <%f_botonera.DibujaBoton("cancelar")%>
                            </div></td>
                          </tr>
                        </table>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div></td>
                  </tr>
              </table></td>
              <td width="6%">&nbsp;</td>
            </tr>
            <tr>
              <td width="5%" height="5">&nbsp;</td>
              <td width="89%">&nbsp;</td>
              <td width="6%">&nbsp;</td>
            </tr>
          </table></td>
        </tr>
      </table>
          </form>
</td>
  </tr>  
</table>
</body>
</html>
<%end if%>