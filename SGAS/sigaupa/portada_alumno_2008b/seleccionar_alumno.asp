<%
Response.addHeader "pragma", "no-cache"
Response.CacheControl = "Private"
Response.Expires = 0
Response.ExpiresAbsolute = #4/12/2000 10:00:00# 
%>
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<% 
'------------------------------------------------------
 set conexion = new CConexion
 conexion.Inicializar "upacifico"
 set errores = new CErrores
'set negocio = new CNegocio
'negocio.Inicializa conexion
'------------------------------------------------------

'if session("id")="" then
'	session("mensajeerror")	= 	"ocurrio un error inesperado, porfavor vuela a intentarlo."
'	session("rut_apoderado")=	""
'	session("rut_usuario")	=	""
'	response.Redirect("portada_alumno.asp") 		
'end if 

rut_apo=session("rut_apoderado")
 
'response.Write("Rut apoderado:"&session("rut_usuario"))

'------------------------------------------------------  
 set botonera = new Cformulario
 botonera.carga_parametros "portada_alumno.xml", "btn_portada"
'------------------------------------------------------

 set f_datos_alu = new CFormulario
 f_datos_alu.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
 f_datos_alu.Inicializar conexion


			sql_rut_alu= " select distinct a.pers_nrut,a.pers_xdv, a.pers_tnombre, a.pers_tape_paterno, a.pers_tape_materno "&_
						 " from personas a, postulantes b "&_
						 " where a.pers_ncorr=b.pers_ncorr "&_
						 " and b.post_ncorr in (select post_ncorr from codeudor_postulacion cp, personas pr where cp.pers_ncorr=pr.pers_ncorr and pers_nrut="&rut_apo&")"
			
			
 f_datos_alu.Consultar sql_rut_alu
 'f_datos_alu.Siguiente			


'---------------------------------------------------------------------
 set f_datos = new CFormulario
 f_datos.Carga_Parametros "portada_alumno.xml", "f_datos"
 f_datos.Inicializar conexion
 f_datos.Consultar "select ''"
 f_datos.Siguiente


cont=0 
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Bienvenido a Universidad del Pac&iacute;fico Online</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript"> 
<!-- 
function EncuadraVentana(){
	if(parent.location != self.location)parent.location = self.location;
}
//--> 
function clave() {
  direccion = "olvido_clave.asp";
  window.open(direccion ,"ventana1","width=370,height=205,scrollbars=no, left=313, top=200");
}
</script>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#84a6d3" onLoad="EncuadraVentana();">
<table align="center" height="100%">
<tr><td valign="middle">
<table width="601" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
      <td width="601" colspan="2" align="center"><table width="585" cellpadding="0" cellspacing="0">
        <tr valign="top">
          <td width="552" height="136" bgcolor="#4b73a6" align="right"><img width="552" height="136" src="../informacion_alumno_2008/imagenes/frame_portada_1.jpg"></td>
          <td width="33" height="135" bgcolor="#84a6d3" align="left"><img width="33" height="135" src="../informacion_alumno_2008/imagenes/frame_portada_2.jpg"></td>
        </tr>
        <tr valign="top">
          <td width="552" bgcolor="#4b73a6" align="right"><table width="98%" align="center" border="0" bgcolor="#f7faff">
              <form name="valida" action="" method="post">
                <tr>
                  <td width="100%" align="center"><table width="100%">
                      <tr>
                        <td width="44%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Alumnos avalados </strong></font></td>
                        <td width="56%"><hr></td>
                      </tr>
                  </table></td>
                </tr>
                <tr>
                  <td width="100%" align="center"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                      <tr>
                        <td width="100%" height="20">&nbsp;</td>
                      </tr>
                      <tr>
                        <td height="20" align="center"><table width="100%" border="1" bordercolor="#496da6">
                            <tr>
                              <td align="center">
							  <table width="100%" border="0">
                                  <tr>
                                    <td align="center" width="37"><img width="37" height="38" src="../informacion_alumno_2008/imagenes/llaves.gif" border="0"></td>
                                    <td width="478" align="left">
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr><th colspan="4"><font size="2" face="Courier New"><b>Listado de alumnos</b></font></th></tr>
                                        <%while f_datos_alu.Siguiente 
										cont=cont+1
										%>
										<tr valign="bottom">
										  <td width="5%" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><b><%=cont%>.</b></font></td>
                                          <td width="18%" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6">
                                            <%f_datos_alu.dibujaCampo "pers_nrut"%>-<%f_datos_alu.dibujaCampo "pers_xdv"%></font></td>
										  <td width="62%" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6">
										    <%f_datos_alu.dibujaCampo "pers_tnombre"%>&nbsp;<%f_datos_alu.dibujaCampo "pers_tape_paterno"%>&nbsp;<%f_datos_alu.dibujaCampo "pers_tape_materno"%></font></td>
										  <td width="15%" align="left"> &nbsp;<a href="reenvia.asp?codigo=<%f_datos_alu.dibujaCampo "pers_nrut"%>"><font size="2">Acceder</font></a></td>
									    </tr>
										<%wend%>
                                    </table></td>
                                  </tr>
                                  <tr>
                                    <td colspan="2" align="center"></td>
                                  </tr>
                              </table></td>
                            </tr>
                        </table></td>
                      </tr>
                      <tr>
                        <td height="20">&nbsp;</td>
                      </tr>
                  </table></td>
                </tr>
              </form>
          </table></td>
        </tr>
        <tr>
          <td bgcolor="#4b73a6"></td>

        </tr>
      </table></td>
  </tr>
  <tr></tr>
  
  <tr> 
    <td colspan="2"><img src="pixel_negro.gif" width="100%" height="2"></td>
  </tr>
</table>
</td></tr></table>
</body>
</html>
