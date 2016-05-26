<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_sede_ccod = Request.QueryString("d[0][sede_ccod]")
q_carr_ccod = Request.QueryString("d[0][carr_ccod]")
q_pers_nrut = Request.QueryString("d[0][pers_nrut]")
q_jorn_ccod = Request.QueryString("d[0][jorn_ccod]")


if not IsNumeric(q_pers_nrut) then
	q_pers_nrut = ""
end if

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Director de carrera"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "adm_email_directores.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_director = new CFormulario
f_director.Carga_Parametros "adm_email_directores.xml", "edicion_director"
f_director.Inicializar conexion

'consulta = "select a.pers_ncorr, a.pers_nrut, a.pers_xdv, a.pers_tape_paterno, a.pers_tape_materno, a.pers_tnombre, obtener_nombre_completo(a.pers_ncorr) as nombre_director " & vbCrLf &_
'          "from personas a " & vbCrLf &_
'		   "where a.pers_nrut = '" & q_pers_nrut & "'"

consulta = " select a.pers_ncorr, cast(a.pers_nrut as varchar) + '-' + a.pers_xdv as Rut, a.pers_tape_paterno, a.pers_tape_materno, a.pers_tnombre, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_director, " & vbCrLf &_
           " (select pers_temail from EMAIL_DIRECTORES_CARRERA EDC  where EDC.pers_ncorr=a.pers_ncorr and ISNULL(EDC.pers_temail,'') <> '') as pers_temail " & vbCrLf &_
           " from personas a " & vbCrLf &_
		   " where cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "'"		   

f_director.Consultar consulta


if f_director.NroFilas = 0 and not EsVacio(q_pers_nrut) then
	conexion.MensajeError "No existe la persona con el rut " & q_pers_nrut & "."
	Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
end if

f_director.AgregaCampoCons "sede_ccod", q_sede_ccod
f_director.AgregaCampoCons "carr_ccod", q_carr_ccod
f_director.AgregaCampoCons "jorn_ccod", q_jorn_ccod
f_director.Siguiente
set errores = new CErrores

carrera=conexion.consultaUno("Select carr_tdesc from carreras where cast(carr_ccod as varchar)='"&q_carr_ccod&"'")
sede=conexion.consultaUno("Select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&q_sede_ccod&"'")
jornada=conexion.consultaUno("Select jorn_tdesc from jornadas where cast(jorn_ccod as varchar)='"&q_jorn_ccod&"'")
%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function pers_nrut_blur(p_objeto)
{
	BuscarRut();	
}


function BuscarRut()
{
	var formulario = document.forms["edicion"];
	
	formulario.method = "get";
	formulario.submit();	
}


function InicioPagina()
{
	o_pers_nrut = document.forms["edicion"].elements["d[0][pers_nrut]"];	
	flag = 0;
}


var flag;
function dBlur()
{
	flag = 1;
}

function dFocus()
{
	if (flag == 1) {
		BuscarRut();
	}
}

</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana(); dBlur();" onFocus="dFocus();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">	  <br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Edición"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><br>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Director de carrera " & carrera%>
                      <br>
                      <table width="98%"  border="0" align="center">
					   <tr>
                          <td width="10%"><div align="left"><strong>Sede</strong></div></td>
						  <td width="2%"><div align="center"><strong>:</strong></div></td>
						  <td width="88%"><div align="left"><%=sede%></td>
					   </tr>
						<tr>
                          <td width="10%"><div align="left"><strong>Jornada</strong></div></td>
						  <td width="2%"><div align="center"><strong>:</strong></div></td>
						  <td width="88%"><div align="left"><%=jornada%></td>
						</tr>
						<tr>
                          <td width="10%" colspan="3"><hr></td>
                        </tr>
						<tr>
                          <td width="10%"><div align="left"><strong>RUT</strong></div></td>
						  <td width="2%"><div align="center"><strong>:</strong></div></td>
						  <td width="88%"><div align="left"><%f_director.dibujaCampo("Rut")%></div></td>
                        </tr>
						<tr>
                          <td width="10%"><div align="left"><strong>Nombre</strong></div></td>
						  <td width="2%"><div align="center"><strong>:</strong></div></td>
						  <td width="88%"><div align="left"><%f_director.dibujaCampo("nombre_director")%></div></td>
                        </tr>
						<tr>
                          <td width="10%"><div align="left"><strong>Email</strong></div></td>
						  <td width="2%"><div align="center"><strong>:</strong></div></td>
						  <td width="88%"><div align="left"><%f_director.dibujaCampo("pers_temail")%></div></td>
                        </tr><%f_director.dibujaCampo("carr_ccod")%><%f_director.dibujaCampo("sede_ccod")%><%f_director.dibujaCampo("tcar_ccod")%>
							 <%f_director.dibujaCampo("jorn_ccod")%><%f_director.dibujaCampo("pers_ncorr")%>
                      </table></td>
                  </tr>
                </table>
                          <br>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="29%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><% if EsVacio(q_pers_nrut) then
				                             f_botonera.AgregaBotonParam "aceptar", "deshabilitado","TRUE"
											 end if
											 f_botonera.DibujaBoton "aceptar"
											    %></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton "cancelar"%>
                  </div></td>
                  </tr>
              </table>
            </div></td>
            <td width="71%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
