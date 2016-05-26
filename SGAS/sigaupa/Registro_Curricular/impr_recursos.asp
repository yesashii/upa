<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_post_ncorr = Request.QueryString("post_ncorr")
'response.Write(q_pers_nrut)
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Recursos entregados al Alumno"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "entrega_recursos.xml", "botonera"

v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")


'-------------------------------------------------------------------------------------------------------------------------
set f_datos_alumno = new CFormulario
f_datos_alumno.Carga_Parametros "entrega_recursos.xml", "datos_alumno"
f_datos_alumno.Inicializar conexion

consulta = "select top 1 protic.obtener_rut(a.pers_ncorr) as rut," & vbCrLf &_
			"    protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_completo," & vbCrLf &_
			"    protic.obtener_nombre_carrera(c.ofer_ncorr,'CE') as carrera " & vbCrLf &_
			" from personas_postulante a, postulantes b, ofertas_academicas c " & vbCrLf &_
			" where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
			"  and b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
			"  and b.post_ncorr = '" & q_post_ncorr & "'"
			
'response.Write("<pre>"&consulta&"</pre>")
f_datos_alumno.Consultar consulta
f_datos_alumno.siguiente
'response.End()
'-------------------------------------------------------------------------------------------------------------------------
set f_recursos = new CFormulario
f_recursos.Carga_Parametros "entrega_recursos.xml", "recursos2"
f_recursos.Inicializar conexion



consulta= 	"	select recu_predefinido as bentregado,protic.trunc(getdate()) as fecha_entrega,* "& vbCrLf &_
			"	from recursos where erec_ccod=1 "
'response.Write("<pre>"&consulta&"</pre>")		
f_recursos.Consultar consulta


if f_recursos.NroFilas = 0 then
	f_botonera.AgregaBotonParam "imprimir", "deshabilitado", "TRUE"
end if
fecha_01=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate())as varchar)+'-'+cast(datePart(year,getDate())as varchar) as fecha")
%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_inicial.css" rel="stylesheet" type="text/css">
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
function salir(){
window.close();
}
</script>

</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="500" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
 <tr>
    <td valign="top" bgcolor="#ffffff">
	<br>
	<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#ffffff">
       <tr>
        <td width="9">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Recursos Entregados"), 1 %></td>
          </tr>
          <tr>
            <td height="2">&nbsp;</td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%>
              <br>
              <br>
              <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                 <tr>
                  	<td width="85"><div align="left"><strong>R.U.T. Alumno</strong></div></td>
				 	<td width="5"><div align="center"><strong>:</strong></div></td>
				  	<td width="350"><div align="left"><%=f_datos_alumno.obtenerValor("rut")%></div></td>
                </tr>
				  <tr>
                  	<td width="85"><div align="left"><strong>Nombre</strong></div></td>
				 	<td width="5"><div align="center"><strong>:</strong></div></td>
				  	<td width="350"><div align="left"><%=f_datos_alumno.obtenerValor("nombre_completo")%></div></td>
                  </tr>
				  <tr>
                  	<td width="85"><div align="left"><strong>Carrera</strong></div></td>
				 	<td width="5"><div align="center"><strong>:</strong></div></td>
				  	<td width="350"><div align="left"><%=f_datos_alumno.obtenerValor("carrera")%></div></td>
                  </tr>
				   <tr>
                  	<td width="85"><div align="left"><strong>Impreso</strong></div></td>
				 	<td width="5"><div align="center"><strong>:</strong></div></td>
				  	<td width="150"><div align="left"><%=fecha_01%></div></td>
                  </tr>
				<tr>
                  <td><%'f_datos_alumno.DibujaRegistro%></td>
                </tr>
              </table>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Recursos"%>
					<br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"><%f_recursos.DibujaTabla%></div></td>
                        </tr>
                      </table></td>
                  </tr>
				   <tr>
                    <td>
					<br>
					<br>
					<br>
					<br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"><strong>_______________</strong></div></td>
						  <td><div align="center"><strong>_______________</strong></div></td>
                        </tr>
						 <tr>
                          <td><div align="center">Alumno</div></td>
						  <td><div align="center">Apoderado</div></td>
                        </tr>
                      </table></td>
                  </tr>
                </table>
                          <br>
            </form></td></tr>
        </table></td>
        <td width="7">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28">&nbsp;</td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="29%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0" class="noprint">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("imprimir")%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("salir2")%>
                  </div></td>
                  </tr>
              </table>
            </div></td>
            <td width="71%" rowspan="2">&nbsp;</td>
            </tr>
          <tr>
            <td height="8"></td>
          </tr>
        </table></td>
        <td width="7" height="28">&nbsp;</td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
