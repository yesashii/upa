<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
enfp_ncorr=request.QueryString("enfp_ncorr")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Agregar antecedentes de enfermos"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion



pers_ncorr =session("pers_ncorr_alumno")
periodo = negocio.ObtenerPeriodoAcademico("Postulacion")
v_post_ncorr=session("post_ncorr_alumno")'conexion.consultaUno("select post_ncorr from postulantes where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(peri_ccod as varchar)='"&periodo&"' and epos_ccod=2")
pers_ncorr_pariente = conexion.consultauno("select pers_ncorr from enfermedades_persona where cast(enfp_ncorr as varchar)='"&enfp_ncorr&"'")
nombre_pariente = conexion.consultaUno("Select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas_postulante where cast(pers_ncorr as varchar)='"&pers_ncorr_pariente&"'")
rut_pariente = conexion.consultaUno("Select cast(pers_nrut as varchar) + '-' + pers_xdv from personas_postulante where cast(pers_ncorr as varchar)='"&pers_ncorr_pariente&"'")
parentesco = conexion.consultaUno("select pare_tdesc from grupo_familiar a, parentescos b where a.pare_ccod=b.pare_ccod and cast(pers_ncorr as varchar)='"&pers_ncorr_pariente&"' and cast(post_ncorr as varchar)='"&v_post_ncorr&"'")

consulta_parientes = "select c.pers_ncorr, b.pare_tdesc + ': '+ c.pers_tnombre + ' ' + c.pers_tape_paterno + ' ' + c.pers_tape_materno as familiar  "&vbcrlf &_
                     "from grupo_familiar a, parentescos b, personas_postulante c "&vbcrlf &_
					 " where a.pare_ccod=b.pare_ccod and cast(post_ncorr as varchar)='"&v_post_ncorr&"'"&vbcrlf &_
					 " and a.pers_ncorr = c.pers_ncorr" &vbcrlf &_
					 " and a.pare_ccod <> 0 "&vbcrlf &_
					 " and isnull(grup_nindependiente,0)= 0 "&vbcrlf &_
				     " union All "&vbcrlf &_
					 " select a.pers_ncorr, 'Alumno(a) : '+ a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as familiar "&vbcrlf &_
					 " from personas_postulante a "&vbcrlf &_
					 " where cast(pers_ncorr as varchar)='"&pers_ncorr&"'"
					 
'response.Write("<pre>"&consulta_parientes&"</pre>")					 
					 if pers_ncorr_pariente<>"" then
					   consulta_parientes= consulta_parientes & " and cast(a.pers_ncorr as varchar)='"&pers_ncorr_pariente&"'"
					 end if
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "ant_salud_familiar.xml", "botonera"


'--------------Se debe buscar las propiedades que tenga la persona y mostrarlas en una lista----------------
if enfp_ncorr <> "" then
	consulta_enfermos = "Select enfp_ncorr,pp.pers_ncorr,enfp_ncosto,enfp_tdiagnostico" &_
                       " from personas_postulante pp, enfermedades_persona pr where pp.pers_ncorr=pr.pers_ncorr and cast(enfp_ncorr as varchar)='"&enfp_ncorr&"'"     

else
	consulta_enfermos = "select ''"
end if
set f_enfermos = new CFormulario
f_enfermos.Carga_Parametros "ant_salud_familiar.xml", "datos_enfermos"
f_enfermos.Inicializar conexion
f_enfermos.Consultar consulta_enfermos
f_enfermos.agregacampoparam "pers_ncorr","destino","("&consulta_parientes &")a"
f_enfermos.siguiente

lenguetas_postulacion = Array("Ingreso de enfermos Familiares")

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
function validar(formulario)
{ var valor_retorno=false;
 if ((formulario.elements["rol_propiedad"].value != "") && (formulario.elements["avaluo_propiedad"].value != ""))
  	valor_retorno= true;
 else if (formulario.elements["rol_propiedad"].value == "")
    { alert("no puede dejar el Rol de la propiedad sin ingresar");
	  formulario.elements["rol_propiedad"].focus();
	}
 else if (formulario.elements["avaluo_propiedad"].value == "")
    { alert("no puede dejar el Avalúo de la propiedad sin ingresar");
	  formulario.elements["avaluo_propiedad"].focus();
	}	

return valor_retorno;
}
</script>

<style type="text/css">
<!--
.style1 {color: #FF0000}
.Estilo2 {color: #FF0000; font-weight: bold; }
-->
</style>
</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); " onBlur="revisaVentana();">
<table width="550"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
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
            <td><%				
				pagina.DibujarLenguetas lenguetas_postulacion, 1
				%></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTitulo "Antecedentes de Salud" %>
             </div>
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>                     
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <%if pers_ncorr_pariente <> "" then%>
						<tr>
                          <td width="10%"><strong>Rut</strong></td>
                          <td><strong>: </strong><%=rut_pariente%></td>
                        </tr>
						<tr>
                          <td width="10%"><strong>Nombre</strong></td>
                          <td><strong>: </strong><%=nombre_pariente%></td>
                        </tr>
						<tr>
                          <td width="10%"><strong>Parentesco</strong></td>
                          <td><strong>: </strong><%=parentesco%></td>
                        </tr>
						<%end if%>
						<tr>
                          <td colspan="2" align="center"><hr></td>
						</tr>
						<tr>
                          <td colspan="2"><strong><br><br></strong></td>
                       </tr>
                      </table>
                     </td>
                  </tr>
				  <br><br>
				  <tr>
                    <td>                     
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <form name="edicion2">
						<tr>
                          <td width="23%"><strong>Nombre Enfermo</strong></td>
                          <td width="77%"><%f_enfermos.dibujacampo("pers_ncorr")%><input type="hidden" name="enfermo[0][enfp_ncorr]" value="<%=enfp_ncorr%>"></td>
                        </tr>
						<tr>
                          <td width="23%"><strong>Costo</strong></td>
                          <td width="77%"><%f_enfermos.dibujacampo("enfp_ncosto")%> <strong>($)</strong></td>
                        </tr>
						<tr>
                          <td width="23%"><strong>Diagn&oacute;stico</strong></td>
                          <td width="77%"><%f_enfermos.dibujacampo("enfp_tdiagnostico")%></td>
                        </tr>
						</form>
						<tr>
                          <td colspan="2"><strong>&nbsp;</strong></td>
                        </tr>
                      </table>
                     </td>
                  </tr>
                </table>
           </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="27%" height="20"><div align="center">
              <table width="66%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("agregar")%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("cerrar")%>
                  </div></td>
                </tr>
              </table>
            </div></td>
            <td width="73%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
