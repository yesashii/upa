<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
v_post_ncorr_carrera = Request.QueryString("post_ncorr")
v_oferta 	= Request.QueryString("ofer_ncorr")
q_pers_nrut = Request.QueryString("pers_nrut")

'response.Write(q_pers_nrut)
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "CREDITO CON AVAL DEL ESTADO LEY N° 20.027"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "entrega_recursos.xml", "botonera"

v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")
'revisar este código estaba en 234
if v_peri_ccod<>"238" then
	v_peri_ccod="238"
end if

v_anio= conexion.consultaUno("select anos_ccod from periodos_academicos where peri_ccod="&v_peri_ccod)


fecha_actual= conexion.consultaUno("select protic.trunc(getDate())")

v_pers_ncorr = conexion.consultauno("select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)  = '"&q_pers_nrut&"'")	

v_pers_nrut = conexion.consultauno("select protic.obtener_rut(pers_ncorr) as rut from personas_postulante where cast(pers_nrut as varchar)  = '"&q_pers_nrut&"'")	


v_existe=conexion.consultaUno("select count(*) from solicitud_credito_cae where post_ncorr="&v_post_ncorr_carrera&" and ofer_ncorr="&v_oferta&" ")


set fc_datos = new CFormulario
fc_datos.Carga_Parametros "consulta.xml", "consulta"
fc_datos.Inicializar conexion

		   
consulta = "select cast(a.pers_nrut as varchar) + ' - ' + a.pers_xdv as rut," & vbCrLf &_
			"         a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre_completo " & vbCrLf &_
			"from personas_postulante a " & vbCrLf &_
			"where cast(a.pers_nrut as varchar) = '" & q_pers_nrut & "'"
'response.Write("<pre>"&consulta&"</pre>")
		   
fc_datos.Consultar consulta
fc_datos.Siguiente


if not esVacio(v_oferta) and v_oferta <> "" then
	cod_carrera = conexion.consultaUno("select carr_ccod from ofertas_academicas b,especialidades c where cast(peri_ccod as varchar)='"&v_peri_ccod&"' and b.espe_ccod = c.espe_ccod and b.ofer_ncorr="&v_oferta&" ")
	carrera 	= conexion.consultaUno("select upper(carr_tdesc) from carreras where carr_ccod ='"&cod_carrera&"'")	
	ano_ingreso = conexion.consultaUno("select isnull(protic.ANO_INGRESO_CARRERA("&v_pers_ncorr&",'"&cod_carrera&"'),year(getdate()))")
	sede_ccod 	= conexion.consultaUno("select sede_ccod from ofertas_academicas where ofer_ncorr="&v_oferta&" ")
	sede 		= conexion.consultaUno("select upper(sede_tdesc) from sedes where sede_ccod ='"&sede_ccod&"'")	
	jornada 	= conexion.consultaUno("select upper(jorn_tdesc) from ofertas_academicas a, jornadas b where a.ofer_ncorr="&v_oferta&" and a.jorn_ccod=b.jorn_ccod ")
end if

set f_solicitud = new CFormulario
f_solicitud.Carga_Parametros "solicitud_credito_cae.xml", "solicitud_credito_cae"
f_solicitud.Inicializar conexion

if v_existe>=1 then
	sql_datos_solicitud=" select isnull(socc_bcurso_superior,0) as socc_bcurso_superior,* from solicitud_credito_cae "&_
						" where post_ncorr="&v_post_ncorr_carrera&" "&_ 
						" and ofer_ncorr="&v_oferta&" "
else
	sql_datos_solicitud="select "&v_oferta&" as ofer_ncorr,"&v_post_ncorr_carrera&" as post_ncorr,"&v_pers_ncorr&" as pers_ncorr "						
end if

'response.Write(sql_datos_solicitud)						
f_solicitud.Consultar sql_datos_solicitud
f_solicitud.Siguiente	

f_solicitud.AgregaCampoParam "socc_bsolicita", "permiso", "lectura"
f_solicitud.AgregaCampoParam "socc_brenovante", "permiso", "lectura"
f_solicitud.AgregaCampoParam "socc_bmonto_solicitado", "permiso", "lectura"
f_solicitud.AgregaCampoParam "socc_mmonto_solicitado", "permiso", "lectura"
f_solicitud.AgregaCampoParam "socc_bcurso_superior", "permiso", "lectura"


v_arancel_real=conexion.consultaUno("select max(aran_mcolegiatura) from aranceles where ofer_ncorr="&v_oferta&" ")
v_arancel_real=conexion.consultaUno("select  top 1 aran_mcolegiatura from aranceles where ofer_ncorr="&v_oferta&" order by audi_fmodificacion desc")
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
	<table class="membrete" align="center" width="760" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="142" align="left"><img src="../imagenes/logo_upa_2011.jpg" height="100"  alt="Logo"></td>
			<td width="455" valign="top">
			  <p>Vicerrectoria de Administración y Finanzas </p>
			  <p>Departamento de Financiamiento Estudiantil</p></td>
		  <td width="163"><br/></td>
		</tr>
	</table>	
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
						<table width="98%"  border="0" align="center" cellpadding="2" cellspacing="0">
							<tr>
							  <td width="11%"><strong>NOMBRE</strong></td>
							  <td width="1%"><strong>:</strong></td>
							  <td width="43%" ><%=fc_datos.ObtenerValor("nombre_completo")%></td>
							  <td width="9%">&nbsp;</td>
							  <td width="4%">&nbsp;</td>
							  <td width="32%">&nbsp;</td>
							</tr>
							<tr>
							  <td width="11%"><strong>CARRERA</strong></td>
							  <td width="1%"><strong>:</strong></td>
							  <td colspan="3" ><%=carrera%></td>
							  <td></td>
							</tr>
							<tr>
							  <td width="11%"><strong>SEDE</strong></td>
							  <td width="1%"><strong>:</strong></td>
							  <td width="43%"><%=sede%></td>
							  <td><strong>JORNADA</strong></td>
							  <td><strong>:</strong></td>
							  <td><%=jornada%></td>
							</tr>
							<tr>
							  <td width="11%"><strong>AÑO INGRESO</strong></td>
							  <td width="1%"><strong>:</strong></td>
							  <td width="43%"><%=ano_ingreso%></td>
							  <td></td>
							  <td></td>
							  <td></td>				  
							</tr>
							<tr>
								<td colspan="5"><li>Solicita monto crédito con aval del estado, para el período académico <%=v_anio%></li></td>
								<td><b><%f_solicitud.dibujaBoleano("socc_bsolicita")%></b></td>					
							</tr>
							<tr>
							  <td colspan="3"><li>Condici&oacute;n del Alumno en relaci&oacute;n al CAE</li></td>
							  <td colspan="3"><b><%f_solicitud.dibujaBoleano("socc_brenovante")%></b></td>
							</tr>
                            <% if f_solicitud.ObtenerValor("socc_bcurso_superior")<>"0" AND f_solicitud.ObtenerValor("socc_brenovante") = 1 then%>
                            <tr>
							  <td colspan="3"><li>Curso </li></td>
							  <td colspan="3"><b><%f_solicitud.dibujaBoleano("socc_bcurso_superior")%></b></td>
							</tr>
                            <% end if %>
							<tr>
							  <td colspan="3"><li>Monto solicitado</li></td>
							  <td colspan="3"><b><%f_solicitud.dibujaBoleano("socc_bmonto_solicitado")%></b></td>
							  </tr>
							<tr>
							  <td colspan="3"><li>Valor Solicitado (en pesos) </li></td>
							  <td colspan="3">$ <%f_solicitud.dibujaCampo("socc_mmonto_solicitado")%>
                              &nbsp;&nbsp;&nbsp;&nbsp; <b>Arancel Real Anual:</b>&nbsp;&nbsp; $<%=v_arancel_real%></td>
							  </tr>
						  </table>
						  <p>&nbsp;</p>
					</td>
				  </tr>
                  <tr>
                    <td>
						  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
							<tr>
							  <td>
									<p style="text-align:justify; font-size:12px;">Si eres alumno (a) Renovante de Cr&eacute;dito, es de tu  responsabilidad confirmar en forma oficial y especificar si vas a necesitar o  no vas a necesitar alg&uacute;n monto para el per&iacute;odo acad&eacute;mico que corresponda,  escogiendo una de las tres opciones de montos para financiar tu carrera, seg&uacute;n lo  dispuesto en el Formulario de&nbsp; Solicitud  de Monto, en <a href="http://www.ingresa.cl">www.ingresa.cl</a>,&nbsp; en los plazos establecidos por la Comisi&oacute;n.</p>
									<p style="text-align:justify; font-size:12px;">Si vas a solicitar financiamiento CAE para el a&ntilde;o  acad&eacute;mico correspondiente,&nbsp; recuerda que  el valor m&iacute;nimo que puedes pedir es $200.000.-</p>
									<p style="text-align:justify; font-size:12px;">Si no vas a necesitar financiamiento CAE para el a&ntilde;o  acad&eacute;mico correspondiente, recuerda que debes digitar Monto 0 (cero).</p>
									<p style="text-align:justify; font-size:12px;">No podr&aacute;s  solicitar un monto que exceda el monto fijado como Arancel Referencial para tu  Carrera, previamente definido por el Ministerio de Educaci&oacute;n.</p>
									<p style="text-align:justify; font-size:12px;">Recuerda que el  Cr&eacute;dito Con Aval del Estado, no cubre el valor de la Matr&iacute;cula ni Valor de  Titulaci&oacute;n</p>
									<p style="text-align:justify; font-size:12px;">Declaro que todos los datos proporcionados en este  documento son fidedignos, por lo que libero a la Universidad del Pac&iacute;fico, de  cualquier responsabilidad  posterior que pudiera presentarse derivada de los mismos.</p>
								</td>
							</tr>
						  </table>
					  </td>
                  </tr>
				   <tr>
                    <td>
					<br/>
					<br/>
                      <table width="98%"  border="0" align="center" cellpadding="3" cellspacing="0">
						<tr>
                          <td width="15%" align="left">FIRMA ALUMNO</td>
						  <td width="85%" align="left"><strong>___________________</strong></td>
                        </tr>
                        <tr>
                           <td align="left">RUT ALUMNO</td>
						   <td align="left"><strong><%=v_pers_nrut%></strong></td>
                        </tr>
                        <tr>
                          <td align="left">&nbsp;</td>
                          <td align="right">&nbsp;Fecha:&nbsp;<%=fecha_actual%></td>
                        </tr>
                      </table>
					  </td>
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
