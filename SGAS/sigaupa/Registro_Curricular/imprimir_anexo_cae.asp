<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_post_ncorr = Request.QueryString("post_ncorr")
'response.Write(q_pers_nrut)
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "ANEXO AL CONTRATO DE SERVICIOS EDUCACIONALES CON CRÉDITO CON AVAL DEL ESTADO"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "entrega_recursos.xml", "botonera"

v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")
v_anos_ccod= conexion.consultaUno("select isnull(anos_ccod, year(getdate())) as anio_ccod from periodos_academicos where peri_ccod="&v_peri_ccod)

'-------------------------------------------------------------------------------------------------------------------------
set f_datos_alumno = new CFormulario
f_datos_alumno.Carga_Parametros "entrega_recursos.xml", "datos_alumno"
f_datos_alumno.Inicializar conexion

consulta = "select top 1 aran_nano_ingreso,d.contrato as cont_ncorr,protic.obtener_rut(a.pers_ncorr) as rut," & vbCrLf &_
			"    protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_completo," & vbCrLf &_
			"    protic.obtener_nombre_carrera(c.ofer_ncorr,'CE') as carrera, " & vbCrLf &_
			"    protic.obtener_nombre_completo(e.pers_ncorr,'n') as nombre_apoderado, " & vbCrLf &_  
		 	" 	 protic.obtener_rut(e.pers_ncorr) as rut_apoderado " & vbCrLf &_       
			" from personas_postulante a, postulantes b, ofertas_academicas c, contratos d, codeudor_postulacion e, aranceles f " & vbCrLf &_
			" where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
			"  and b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
			"  and b.post_ncorr=d.post_ncorr " & vbCrLf &_
			"    and c.ofer_ncorr=f.ofer_ncorr " & vbCrLf &_
       		"	and c.aran_ncorr=f.aran_ncorr " & vbCrLf &_
            "  and d.econ_ccod not in (3) " & vbCrLf &_
			"  and b.post_ncorr = '" & q_post_ncorr & "'"
			
'response.Write("<pre>"&consulta&"</pre>")
f_datos_alumno.Consultar consulta
f_datos_alumno.siguiente
'response.End()
'-------------------------------------------------------------------------------------------------------------------------
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
	window.print()
}
function salir(){
	window.close();
}
</script>

</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="700" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
 <tr>
    <td valign="top" bgcolor="#ffffff">
	<br>
	<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#ffffff">
       <tr>
        <td width="9">&nbsp;</td>
        <td>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%>
              <br>
              <br>
			  <p>&nbsp;</p>
               </div>
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td>
								<p style="text-align:justify; font-size:12px;">En este acto el alumno(a) <b><%=f_datos_alumno.obtenerValor("nombre_completo")%></b>, Rut N° <b><%=f_datos_alumno.obtenerValor("rut")%></b>  y/o apoderado(a) <b><%=f_datos_alumno.obtenerValor("nombre_completo")%></b>, Rut <b><%=f_datos_alumno.obtenerValor("rut")%></b>, declaran que el Monto del Arancel de Referencia, se encuentra incorporado en valor del cuadro de pagos suscrito en el Contrato de Servicios Educacionales N°<b><%=f_datos_alumno.obtenerValor("cont_ncorr")%></b>, emitido en virtud de los servicios educacionales contratados con la Universidad del Pacífico para el año académico <b><%=v_anos_ccod%></b>, y éste será pagado, total o parcialmente según corresponda, con cargo al Crédito Con Aval del Estado,  otorgado según lo establecido en la Ley N° 20.027, cuyo Reglamento y Normativa declaran conocer y aceptar.</p>
								<p style="text-align:justify; font-size:12px;">El financiamiento será imputado total o parcialmente a la obligación de pago que se encuentre vigente, con la Universidad.</p>
								<p style="text-align:justify; font-size:12px;">La Universidad se obliga a recibir el pago, en la fecha efectiva que la entidad bancaria realicé el respectivo abono a la cuenta corriente de la Universidad del Pacifico; no obstante, el pago anticipado, no tendrá descuentos de carácter financiero, de ninguna índole.</p>
								<p style="text-align:justify; font-size:12px;">En la eventualidad y por los motivos que sea,  los fondos por concepto de Crédito con Aval del Estado,  no sean ingresados, como pagos a la Universidad del Pacífico, el contratante y suscriptor, de los servicios educacionales contratados, no quedará liberado del pago, debiendo someterse  a las condiciones de pago que estipule o fije la Universidad del Pacífico.</p>
								<p style="text-align:justify; font-size:12px;">Asimismo se deja constancia que sólo como una forma de otorgamiento de plazo, la Universidad del Pacifico ha emitido una letra de cambio bancaria de vencimiento noviembre, siendo aceptada por el apoderado (a)/alumno (a), la cual será pagada ya sea en su totalidad o parcialmente por medio de abono correspondiente a financiamiento de Crédito con Aval del Estado, al respecto es importante mencionar, que en la eventualidad que:</p>
								<ul style="text-align:justify; font-size:12px;">
									<li>El valor abonado por concepto de arancel referencial sea mayor a la letra de cambio bancaria  firmada, la diferencia será abonada a los aranceles pendientes del año académico respectivo y vigente.</li>
									<li>El valor abonado por concepto de arancel referencial sea menor a la letra de cambio bancaria firmada, la diferencia pendiente siempre será de cargo del apoderado (a)/alumno(a) según corresponda.</li>
								</ul>
						  </td>
                        </tr>
                      </table></td>
                  </tr>
				   <tr>
                    <td>
					<br/>
					<br/>
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
            </td></tr>
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
