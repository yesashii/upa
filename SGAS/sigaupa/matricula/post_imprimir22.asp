<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
v_pers_ncorr = Session("pers_ncorr")
if EsVacio(v_pers_ncorr) then
	Response.Redirect("inicio.asp")
end if

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Constancia de Envío de Postulación"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "post_cerrada.xml", "botonera"


'---------------------------------------------------------------------------------------------------
v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")

'------------------------------------------------------
v_post_ncorr = conexion.ConsultaUno("select post_ncorr from postulantes where pers_ncorr='" & v_pers_ncorr & "' and peri_ccod = '" & v_peri_ccod & "'")

v_pais_ccod= conexion.consultaUno("Select pais_ccod from personas_postulante where pers_ncorr='"&v_pers_ncorr&"'")

v_codeudor=conexion.consultaUno("Select pers_ncorr from codeudor_postulacion where cast(post_ncorr as varchar)='"&v_post_ncorr&"'")

set postulante = new CPostulante
postulante.Inicializar conexion, v_post_ncorr
if v_pais_ccod<>"" and v_codeudor<>"" then
if cint(v_pais_ccod)=1 and cstr(v_pers_ncorr)=cstr(v_codeudor) then
	criterio_direccion=1
elseif cint(v_pais_ccod)<>1 and cstr(v_pers_ncorr)=cstr(v_codeudor) then
	criterio_direccion=2
else
    criterio_direccion=1
end if
else
criterio_direccion=1
end if

set postulante = new CPostulante
postulante.Inicializar conexion, v_post_ncorr

sql_postulante = " select cast(a.pers_nrut as varchar(10))  + ' - ' + a.pers_xdv as rut, " & vbcrlf & _
" a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre_completo, " & vbcrlf & _
" protic.obtener_nombre_carrera(c.ofer_ncorr, 'CE') as carrera, " & vbcrlf & _
" g.jorn_tdesc,h.sede_tdesc,i.eepo_tdesc " & vbcrlf & _
" from  " & vbcrlf & _
" personas_postulante a,postulantes b,detalle_postulantes c, " & vbcrlf & _
" ofertas_academicas d,especialidades e,carreras f,jornadas g, " & vbcrlf & _
" sedes h,estado_examen_postulantes i " & vbcrlf & _
" where a.pers_ncorr = b.pers_ncorr " & vbcrlf & _
" and b.post_ncorr = c.post_ncorr " & vbcrlf & _
" and c.ofer_ncorr = d.ofer_ncorr " & vbcrlf & _
" and d.espe_ccod = e.espe_ccod " & vbcrlf & _
" and e.carr_ccod = f.carr_ccod   " & vbcrlf & _
" and d.jorn_ccod = g.jorn_ccod " & vbcrlf & _
" and d.sede_ccod = h.sede_ccod " & vbcrlf & _
" and c.eepo_ccod = i.eepo_ccod " & vbcrlf & _
" and b.epos_ccod = 2 " & vbcrlf & _
" and b.tpos_ccod = 1 " & vbcrlf & _
" and b.post_ncorr = '"&v_post_ncorr&"'" 'postulante.ObtenerSql("INFORMACION_POSTULANTE")

sql_codeudor = " select b.pers_tnombre + ' ' + b.pers_tape_paterno + ' ' +b.pers_tape_materno as nombre_codeudor, " & vbcrlf & _
" c.DIRE_TCALLE + ' ' + c.DIRE_TNRO + '  (' + d.CIUD_TDESC + ')' AS direccion_codeudor, " & vbcrlf & _
" b.pers_tfono " & vbcrlf & _
" from codeudor_postulacion a, " & vbcrlf & _
" personas_postulante b,direcciones_publica c,ciudades d " & vbcrlf & _
" where a.pers_ncorr = b.pers_ncorr " & vbcrlf & _
" and b.pers_ncorr = c.pers_ncorr " & vbcrlf & _
" and c.ciud_ccod = d.ciud_ccod " & vbcrlf & _
" and cast(c.tdir_ccod as varchar)='"&criterio_direccion&"' " & vbcrlf & _
" and a.post_ncorr = '"&v_post_ncorr&"'"



set fc_postulante = new CFormulario
fc_postulante.Carga_Parametros "post_cerrada.xml", "info_postulacion"
fc_postulante.Inicializar conexion

fc_postulante.Consultar sql_postulante
fc_postulante.AgregaCampoParam "eepo_tdesc", "descripcion", "Examen Admisión"
fc_postulante.Siguiente

NombrePostulante =fc_postulante.obtenervalor("nombre_completo")
RutPostulante    =fc_postulante.obtenervalor("rut")

fc_postulante.primero



set fc_codeudor = new CFormulario
fc_codeudor.Carga_Parametros "post_cerrada.xml", "info_codeudor"
fc_codeudor.Inicializar conexion

fc_codeudor.Consultar sql_codeudor
fc_codeudor.siguiente
NombreCodeudor = fc_codeudor.obtenervalor("nombre_codeudor")
DireccionCodeudor = fc_codeudor.obtenervalor("direccion_codeudor")
FonoCodeudor = fc_codeudor.obtenervalor("pers_tfono")


'----------------------------------------------------------------------------------------------------------------
consulta = "select protic.protic.es_nuevo_institucion('" & v_pers_ncorr & "', '" & v_peri_ccod  &"') "
v_es_nuevo_institucion = conexion.ConsultaUno(consulta)

%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<style>
@media print{ .noprint {visibility:hidden; }}
</style>

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

function imprimir() {
  //alert("Enviando a imprimir....");
  window.print()
}
function salir() {
  //window.open(direccion ,"ventana1","width=370,height=205,scrollbars=no, left=313, top=200");
  window.close();
}
</script>

</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="720" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <%'pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#ffffff">
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#ffffff">
      <tr>
        <td width="9">&nbsp;</td>
        <td><table width="97%"  border="1" cellspacing="0" cellpadding="0">
          <tr>
            <td height="2"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%>
                  </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Datos del postulante"%>
                      <br><br>
                      <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td colspan="2"> <div align="left"><strong>R.U.T. 
                                  Postulante</strong></div></td>
                              <td width="1%"><strong>:</strong></td>
                              <td width="47%"><%=RutPostulante%></td>
                            </tr>
                            <tr> 
                              <td colspan="2">&nbsp;</td>
                              <td>&nbsp;</td>
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td colspan="2"><strong>Nombre Postulante</strong></td>
                              <td><strong>:</strong></td>
                              <td><%=NombrePostulante%></td>
                            </tr>
                            <tr> 
                              <td colspan="4"> <div align="center"> </div></td>
                            </tr>
                            <tr> 
                              <td colspan="4">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td colspan="4">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td colspan="2"><strong>Nombre Apoderado Sostenedor 
                                Econ&oacute;mico </strong></td>
                              <td><strong>:</strong></td>
                              <td><%=NombreCodeudor%></td>
                            </tr>
                            <tr> 
                              <td colspan="4">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td width="46%"><strong>Direcci&oacute;n Apoderado Sostenedor 
                                Econ&oacute;mico </strong></td>
                              <td width="6%" rowspan="3">&nbsp;</td>
                              <td><strong>:</strong></td>
                              <td> <%=DireccionCodeudor%> </td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
                              <td>&nbsp;</td>
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td><strong>Tel&eacute;fono Apoderado Sostenedor 
                                Econ&oacute;mico</strong></td>
                              <td><strong>:</strong></td>
                              <td> <%=FonoCodeudor%> </td>
                            </tr>
                            <tr> 
                              <td colspan="4"><div align="center"></div></td>
                            </tr>
                            <tr> 
                              <td colspan="4"><div align="center"><strong>POSTULACIONES</strong></div></td>
                            </tr>
                            <tr> 
                              <td colspan="4">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td colspan="4"> <div align="center"> 
                                  <%fc_postulante.dibujatabla()%>
                                </div></td>
                            </tr>
                            <tr> 
                              <td colspan="4">&nbsp;</td>
                            </tr>
                          </table>
                      <br>
                      <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><p align="justify">1.-El presente documento acredita 
                                  tu postulaci&oacute;n a Universidad Del Pac&iacute;fico. 
                                  En ning&uacute;n caso representa una reserva 
                                  de matr&iacute;cula.</p>
                                <p align="justify">2.-Para continuar con el proceso 
                                  de postulaci&oacute;n debes acercarte a cualquier 
                                  Sede de la Universidad del Pac&iacute;fico a 
                                  pagar arancel de $12.000.- correspondiente a 
                                  derecho de examen de admisi&oacute;n, rendirlo 
                                  y si eres aceptado, hacer efectiva tu matr&iacute;cula 
                                  dentro de los tres d&iacute;as siguientes. </p>
                                							
							<%if v_es_nuevo_institucion = "S" then%>
							
                            <table width="99%"  border="0" align="center" cellpadding="0" cellspacing="0">
                              <tr>
                                <td><p align="justify"><strong>DOCUMENTACI&Oacute;N QUE DEBES PRESENTAR AL MOMENTO DE MATRICULARTE:</strong></p>
                                      <ul>
                                        <li>C&eacute;dula De Identidad / C&eacute;dula 
                                          de identidad del pa&iacute;s de origen 
                                          / Pasaporte.</li>
                                        <li> Licencia de Ense&ntilde;anza Media 
                                          o Licencia de término de estudios secundarios 
                                          en pa&iacute;s de origen.</li>
                                        <li>Concentraci&oacute;n de notas de ense&ntilde;anza 
                                          media o de estudios secundarios.</li>
                                        <li>Puntaje P.A.A. / P.S.U.(s&oacute;lo 
                                          para estudiantes chilenos).</li>
                                        <li>2 fotos tama&ntilde;o carn&eacute;, 
                                          con nombre y n&uacute;mero de c&eacute;dula 
                                          de identidad.</li>
                                        <li>Certificado de Residencia o boleta 
                                          de alg&uacute;n servicio tales como Luz, 
                                          Agua, Gas o Tel&eacute;fono del apoderado</li>
									    <li>Acreditar seguro de salud(S&oacute;lo 
                                          para estudiantes extranjeros).</li>	  
                                      </ul>
                                  <p align="justify">S&oacute;lo ser&aacute;n recibidos los documentos originales o aqu&eacute;llos que se encuentren debidamente legalizados.</p>
								      <p align="justify">Si deseas realizar cambios 
                                        a tu postulaci&oacute;n, ya enviada a 
                                        Universidad del Pac&iacute;fico, puedes 
                                        hacerlo en secretar&iacute;a de Admisi&oacute;n.</p>
								      <p align="justify"><strong>NOTA.: Si no 
                                        tienes algunos de los documentos solicitados 
                                        (con excepci&oacute;n de la c&eacute;dula 
                                        de identidad), puedes entregarlos antes 
                                        del 30 de Diciembre del 2004 en Oficina 
                                        de Registro Curricular (Tercer Piso Casa 
                                        Central). </strong></p></td>
                              </tr>
				           </table>
							<%end if%>
							                          
                            </td>
                        </tr>
                      </table></td>
                  </tr>
                </table>
                       
            </form></td></tr>
        </table></td>
        <td width="7">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td  class="noprint"  width="18%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton ("salir2")%></div></td>
				  <td>&nbsp;</td>
				  <td><div align="center"><%f_botonera.DibujaBoton ("imprimir")%></div></td>
                </tr>
              </table>
            </div></td>
            <td width="82%" rowspan="2" ></td>
            </tr>
          <tr>
            <td height="8"></td>
          </tr>
        </table></td>
        <td width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
