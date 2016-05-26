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
v_post_ncorr= session("post_ncorr_alumno") 'conexion.consultaUno("select post_ncorr from postulantes where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(peri_ccod as varchar)='"&periodo&"' and epos_ccod=2")

nombre_pariente = conexion.consultaUno("Select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas_postulante where cast(pers_ncorr as varchar)='"&pers_ncorr_pariente&"'")
rut_pariente = conexion.consultaUno("Select cast(pers_nrut as varchar) + '-' + pers_xdv from personas_postulante where cast(pers_ncorr as varchar)='"&pers_ncorr_pariente&"'")
parentesco = conexion.consultaUno("select pare_tdesc from grupo_familiar a, parentescos b where a.pare_ccod=b.pare_ccod and cast(pers_ncorr as varchar)='"&pers_ncorr_pariente&"' and cast(post_ncorr as varchar)='"&v_post_ncorr&"'")

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "ingresos_grupo_familiar.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_familiar = new CFormulario
f_familiar.Carga_Parametros "ingresos_grupo_familiar.xml", "ingreso_familiar"
f_familiar.Inicializar conexion

consulta = " select ing_liquido, ret_judicial, aportes, act_varias,arr_bienes,arr_vehiculos,intereses, dividendos " &_
           "  from antecedentes_personas where cast(pers_ncorr as varchar)='"&pers_ncorr_pariente&"'"
  
f_familiar.Consultar consulta
f_familiar.Siguiente

lenguetas_postulacion = Array("Ingresos Familiares")

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
</script>

<style type="text/css">
<!--
.style1 {color: #FF0000}
.Estilo2 {color: #FF0000; font-weight: bold; }
-->
</style>
</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); " onBlur="revisaVentana();">
<table width="500"  border="0" align="center" cellpadding="0" cellspacing="0">
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
              <%pagina.DibujarTitulo "Agregar Ingreso Familiar" %>
              <br>
             </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>                     
                      <br>
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
                          <td colspan="2"><strong><hr></strong></td>
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
                          <td width="50%"><strong>Ingr. L&iacute;quido regular mensual,remuneraciones, pensiones y honorarios</strong></td>
                          <td><strong>: $</strong> <%=f_familiar.dibujaCampo("ing_liquido")%><br></td>
                        </tr>
						<tr>
                          <td colspan="2"><strong><hr></strong></td>
                        </tr>
						<tr>
                          <td width="50%"><strong>Ret. Judicial y/o pensi&oacute;n orfandad</strong></td>
                          <td><strong>: $</strong> <%=f_familiar.dibujaCampo("ret_judicial")%></td>
                        </tr>
						<tr>
                          <td width="50%"><strong>Aportes de parientes u otros</strong></td>
                          <td><strong>: $</strong>  <%=f_familiar.dibujaCampo("aportes")%></td>
                        </tr>
						<tr>
                          <td width="50%"><strong>Actividades varias</strong></td>
                          <td><strong>: $</strong> <%=f_familiar.dibujaCampo("act_varias")%></td>
                        </tr>
						<tr>
                          <td width="50%"><strong>Arriendo bienes ra&iacute;ces</strong></td>
                          <td><strong>: $</strong> <%=f_familiar.dibujaCampo("arr_bienes")%></td>
                        </tr>
						<tr>
                          <td width="50%"><strong>Arriendo veh&iacute;culos</strong></td>
                          <td><strong>: $</strong> <%=f_familiar.dibujaCampo("arr_vehiculos")%></td>
                        </tr>
						<tr>
                          <td width="50%"><strong>&Iacute;ntereses por dep&oacute;sitos</strong></td>
                          <td><strong>: $</strong> <%=f_familiar.dibujaCampo("intereses")%></td>
                        </tr>
						<tr>
                          <td width="50%"><strong>Dividendos por acciones</strong></td>
                          <td><strong>: $</strong> <%=f_familiar.dibujaCampo("dividendos")%><input type="hidden" value="<%=pers_ncorr_pariente%>" name="padre[0][pers_ncorr]"></td>
                        </tr>
						<tr>
                          <td colspan="2"><strong>&nbsp;</strong></td>
                        </tr>
                      </table>
                     </td>
                  </tr>
                </table>
           </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("agregar")%>
                  </div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("cerrar")%>
                  </div></td>
                </tr>
              </table>
            </div></td>
            <td width="62%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
