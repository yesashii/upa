<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_post_ncorr = Request.QueryString("post_ncorr")

set pagina = new CPagina
pagina.Titulo = "Generación de Contratos"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores = new CErrores

'---------------------------------------------------------------------------------------------------
consulta = "select  a.pers_ncorr, b.post_ncorr, cast(a.pers_nrut as varchar) + ' - ' + a.pers_xdv as rut, " & vbCrLf &_
       " a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre_completo, a.pers_nrut, a.pers_xdv,  " & vbCrLf &_
       " e.carr_tdesc + ' - ' + d.espe_tdesc as carrera, convert(datetime,getdate(),103) as fecha_actual, g.sede_tdesc  " & vbCrLf &_
		   "from personas_postulante a, postulantes b, ofertas_academicas c, especialidades d, carreras e, sedes g  " & vbCrLf &_
		   "where a.pers_ncorr = b.pers_ncorr  " & vbCrLf &_
		   "  and b.ofer_ncorr = c.ofer_ncorr    " & vbCrLf &_
		   "  and c.espe_ccod = d.espe_ccod  " & vbCrLf &_
		   "  and d.carr_ccod = e.carr_ccod  " & vbCrLf &_
		   "  and c.sede_ccod = g.sede_ccod  " & vbCrLf &_
		   "  and b.tpos_ccod in (1,2)  " & vbCrLf &_
		   "  and b.epos_ccod = 2  " & vbCrLf &_
		   "  and b.post_ncorr = '" & q_post_ncorr & "'"
	
response.write(consulta)

set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "genera_contrato_3.xml", "encabezado"
f_encabezado.Inicializar conexion
f_encabezado.Consultar consulta
f_encabezado.Siguiente


'--------------------------------------------------------------------------------------------------------------
set f_tabla_datos = new CFormulario
f_tabla_datos.Carga_Parametros "genera_contrato_3.xml", "tabla_valores"
f_tabla_datos.Inicializar conexion

consulta = "select a.post_ncorr, a.ofer_ncorr, b.spag_mmatricula, b.spag_mcolegiatura, b.spag_mmatricula + b.spag_mcolegiatura as total " & vbCrLf &_
           "from postulantes a, spagos b " & vbCrLf &_
		   "where a.post_ncorr = b.post_ncorr " & vbCrLf &_
		   "  and a.ofer_ncorr = b.ofer_ncorr " & vbCrLf &_
		   "  and a.post_ncorr = '" & q_post_ncorr & "'"

f_tabla_datos.Consultar consulta

'--------------------------------------------------------------------------------------------------------------
set f_contratos = new CFormulario
f_contratos.Carga_Parametros "genera_contrato_3.xml", "contratos"
f_contratos.Inicializar conexion

consulta = "select a.cont_ncorr, a.econ_ccod, a.cont_fcontrato " & vbCrLf &_
           "from contratos a " & vbCrLf &_
		   "where a.econ_ccod <> 3 " & vbCrLf &_
		   "  and a.post_ncorr =  '" & q_post_ncorr & "'"

f_contratos.Consultar consulta
f_contratos.Siguiente
if f_contratos.NroFilas > 0 then
	b_contrato_generado = true
else
	b_contrato_generado = false
end if
'---------------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "genera_contrato_3.xml", "botonera"

f_botonera.AgregaBotonParam "anterior", "url", "genera_contrato_2.asp?post_ncorr=" & f_encabezado.ObtenerValor("post_ncorr")
f_botonera.AgregaBotonParam "siguiente", "url", "genera_contrato_4.asp?post_ncorr=" & f_encabezado.ObtenerValor("post_ncorr")
'response.Write("post_ncorr " & f_encabezado.ObtenerValor("post_ncorr"))
'---------------------------------------------------------------------------------------------------------

if b_contrato_generado then	
	str_boton_siguiente = "siguiente"
else
	str_boton_siguiente = "generar"
end if


'-------------------------------------------------------------------------------------------------
set postulante = new CPostulante
postulante.Inicializar conexion, q_post_ncorr
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
function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if%>
}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
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
            <td><%pagina.DibujarLenguetas Array("Forma de pago", "Generar contrato", "Imprimir"), 2 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Datos del postulante"%>
                        <%'f_encabezado.DibujaRegistro%>
						<%postulante.DibujaDatos%>
                        <br>
						<div align="center"><%f_tabla_datos.DibujaTabla%></div>
                        <br>                        <br>                        
				          <div align="right"><div align="left">
					          <%pagina.DibujarSubtitulo "Contratos"%>                        
                              <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                                <tr>
                                  <td><div align="center"><%f_contratos.DibujaTabla%></div></td>
                                </tr>
                              </table>
                              <br>
                            </div>
						  </div>
						
						</td></tr>
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
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("anterior")%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton(str_boton_siguiente)%>
                  </div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("salir")%>
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
