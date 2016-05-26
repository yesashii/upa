<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
pers_ncorr_pariente=request.QueryString("pers_ncorr")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Agregar ingresos de familiares "

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion



pers_ncorr =session("pers_ncorr_alumno")
periodo = negocio.ObtenerPeriodoAcademico("Postulacion")
v_post_ncorr=session("post_ncorr_alumno")'conexion.consultaUno("select post_ncorr from postulantes where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(peri_ccod as varchar)='"&periodo&"' and epos_ccod=2")

nombre_pariente = conexion.consultaUno("Select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas_postulante where cast(pers_ncorr as varchar)='"&pers_ncorr_pariente&"'")
rut_pariente = conexion.consultaUno("Select cast(pers_nrut as varchar) + '-' + pers_xdv from personas_postulante where cast(pers_ncorr as varchar)='"&pers_ncorr_pariente&"'")
parentesco = conexion.consultaUno("select pare_tdesc from grupo_familiar a, parentescos b where a.pare_ccod=b.pare_ccod and cast(pers_ncorr as varchar)='"&pers_ncorr_pariente&"' and cast(post_ncorr as varchar)='"&v_post_ncorr&"'")

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "propiedades_grupo_familiar.xml", "botonera"


'--------------Se debe buscar las propiedades que tenga la persona y mostrarlas en una lista----------------
consulta_propiedades = "Select pr.prpe_ncorr,pp.pers_ncorr as pers_ncorr2,pp.pers_ncorr, protic.format_rut(pp.pers_nrut) as rut, prpe_nrol,prpe_nrol as rol, prpe_navaluo" &_
                       " from personas_postulante pp, propiedades_personas pr where pp.pers_ncorr=pr.pers_ncorr and cast(pp.pers_ncorr as varchar)='"&pers_ncorr_pariente&"'"     

set f_propiedades = new CFormulario
f_propiedades.Carga_Parametros "propiedades_grupo_familiar.xml", "grilla_propiedades"
f_propiedades.Inicializar conexion
f_propiedades.Consultar consulta_propiedades

lenguetas_postulacion = Array("Propiedades Familiares")

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
<table width="450"  border="0" align="center" cellpadding="0" cellspacing="0">
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
              <%pagina.DibujarTitulo "Propiedades del Familiar" %>
             </div>
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>                     
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
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
						<tr>
                          <td colspan="2" align="center"><hr></td>
						</tr>
						<tr>
                          <td colspan="2" align="left"><%pagina.dibujarSubtitulo "Modificar Propiedad "%></td>
						</tr>
						<form name="edicion">
						<tr>
                          <td colspan="2" align="center"><%f_propiedades.DibujaTabla()%></td>
						</tr>
						<tr>
                          <td colspan="2" align="center">&nbsp;</td>
						</tr>
						<tr>
                          <td>&nbsp;</td>
						  <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
								  <td width="33%"><div align="center"></div></td>
								  <td width="52%"><div align="right"><%f_botonera.DibujaBoton("modificar")%></div></td>
								  <td width="15%"><div align="right"><%f_botonera.DibujaBoton("eliminar_propiedad")%></div></td>
								</tr>
							  </table>
						   </td>
						</tr>
						</form>
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
                        <tr>
                          <td colspan="2"><%pagina.dibujarSubtitulo "Crear nueva propiedad"%></td>
                        </tr>
						<tr>
                          <td colspan="2">&nbsp;</td>
                        </tr>
						<form name="edicion2">
						<tr>
                          <td width="22%"><strong>ROL</strong></td>
                          <td width="78%"><strong>: </strong><input type="text" name="rol_propiedad" size="10" maxlength="10" id="TO-S"></td>
                        </tr>
						<tr>
                          <td width="22%"><strong>Aval&uacute;o fiscal</strong></td>
                          <td><strong>: </strong>                            <input type="text" name="avaluo_propiedad" size="10" maxlength="10" id="NU-S">
                            ($) &nbsp;
                              <%f_botonera.DibujaBoton("agregar")%>
                              <input type="hidden" name="pers_ncorr_pariente" value="<%=pers_ncorr_pariente%>"></td></tr>
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
                  <td><div align="center"></div></td>
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
