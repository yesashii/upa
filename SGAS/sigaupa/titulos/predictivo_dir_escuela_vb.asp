<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_ncorr = Request.QueryString("pers_ncorr")
q_carr_ccod = Request.QueryString("carr_ccod")
q_plan_ccod = Request.QueryString("plan_ccod")


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "SOLICITUD DE EGRESO"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "predictivo_dir_escuela.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "predictivo_dir_escuela.xml", "encabezado_vb"
f_encabezado.Inicializar conexion

SQL = " select cast(pers_nrut as varchar)+'-'+pers_xdv as rut, pers_tnombre as nombres, pers_tape_paterno + ' ' +  pers_tape_materno as apellidos," & vbCrLf &_
      " (select carr_tdesc from carreras where carr_ccod='"&q_carr_ccod&"') as carrera " & vbCrLf &_
	  " from personas where cast(pers_ncorr as varchar)='"&q_pers_ncorr&"'"

f_encabezado.Consultar SQL
f_encabezado.Siguiente

set f_salidas = new CFormulario
f_salidas.Carga_Parametros "predictivo_dir_escuela.xml", "salidas_vb"
f_salidas.Inicializar conexion

SQL = " select a.tsca_ccod, a.saca_ncorr,  "& vbCrLf & _
      " a.tsca_tdesc as tsca_tdesc, "& vbCrLf & _
	  " a.saca_tdesc, a.plan_ccod, "& vbCrLf & _
      " a.saca_npond_asignaturas, a.asignaturas, count(b.reca_ncorr) as adicionales, sum(b.repl_nponderacion) as pond_adicionales, "& vbCrLf & _
	  " (select case count(*) when 0 then '' else 'SÍ' end from CANDIDATOS_EGRESO CE,CANDIDATOS_EGRESO_DETALLE CED where CE.CEGR_NCORR=CED.CEGR_NCORR AND CED.saca_ncorr=a.saca_ncorr AND cast(CE.pers_ncorr as varchar)='"&q_pers_ncorr&"' and cast(CE.plan_ccod as varchar)='"&q_plan_ccod&"' and CE.carr_ccod='"&q_carr_ccod&"') as asignado "& vbCrLf & _
      " from (  "& vbCrLf & _
	  "         select a.tsca_ccod, a.saca_ncorr, b.tsca_tdesc, a.saca_tdesc, a.plan_ccod, "& vbCrLf & _
	  "                a.saca_npond_asignaturas, count(c.mall_ccod) as asignaturas "& vbCrLf & _
      " 		from salidas_carrera a INNER JOIN tipos_salidas_carrera b "& vbCrLf & _
      "			ON a.tsca_ccod = b.tsca_ccod "& vbCrLf & _
      "			LEFT OUTER JOIN asignaturas_salidas_carrera c "& vbCrLf & _
      "			ON a.saca_ncorr = c.saca_ncorr "& vbCrLf & _
      "			WHERE cast(a.carr_ccod as varchar) = '" & q_carr_ccod & "' and isnull(a.SACA_BMUESTRA_ESCUELA,'0') = '1' "& vbCrLf & _
      "			group by a.tsca_ccod, a.saca_ncorr, b.tsca_tdesc, a.saca_tdesc, a.plan_ccod, a.saca_npond_asignaturas "& vbCrLf & _
      " 	 ) a LEFT OUTER JOIN requisitos_carrera b "& vbCrLf & _
      " ON a.saca_ncorr = b.saca_ncorr "& vbCrLf & _
	  " WHERE PROTIC.PREDICTIVO_EGRESO_ESCUELA_VB("+q_pers_ncorr+",'"+q_carr_ccod+"',"+q_plan_ccod+",a.saca_ncorr,a.asignaturas) = 1 "& vbCrLf & _
      " group by a.tsca_ccod, a.saca_ncorr, a.tsca_tdesc, a.saca_tdesc, a.plan_ccod, "& vbCrLf & _
	  "          a.saca_npond_asignaturas, a.asignaturas "& vbCrLf & _
	  " order by a.tsca_ccod, a.saca_ncorr "

'response.Write("<pre>"&SQL&"</pre>")

f_salidas.Consultar SQL

grabado = conexion.consultaUno("select count(*) from CANDIDATOS_EGRESO where cast(pers_ncorr as varchar)='"&q_pers_ncorr&"' and cast(plan_ccod as varchar)='"&q_plan_ccod&"' and carr_ccod='"&q_carr_ccod&"'")

fecha_solicitud = conexion.consultaUno("select protic.trunc(CEGR_FSOLICITUD) from CANDIDATOS_EGRESO where cast(pers_ncorr as varchar)='"&q_pers_ncorr&"' and cast(plan_ccod as varchar)='"&q_plan_ccod&"' and carr_ccod='"&q_carr_ccod&"'")
estado_solicitud = conexion.consultaUno("select b.ECEG_TDESC from CANDIDATOS_EGRESO a, ESTADO_CANDIDATOS_EGRESO b where a.ECEG_CCOD=b.ECEG_CCOD AND cast(pers_ncorr as varchar)='"&q_pers_ncorr&"' and cast(plan_ccod as varchar)='"&q_plan_ccod&"' and carr_ccod='"&q_carr_ccod&"'")
eceg_ccod = conexion.consultaUno("select b.ECEG_CCOD from CANDIDATOS_EGRESO a, ESTADO_CANDIDATOS_EGRESO b where a.ECEG_CCOD=b.ECEG_CCOD AND cast(pers_ncorr as varchar)='"&q_pers_ncorr&"' and cast(plan_ccod as varchar)='"&q_plan_ccod&"' and carr_ccod='"&q_carr_ccod&"'")

restante = conexion.consultaUno("select isnull(CEGR_NTOTAL_RECHAZOS,0) - isnull(CEGR_NTOTAL_REINTENTOS,0) from CANDIDATOS_EGRESO where cast(pers_ncorr as varchar)='"&q_pers_ncorr&"' and cast(plan_ccod as varchar)='"&q_plan_ccod&"' and carr_ccod='"&q_carr_ccod&"'")


sin_mencion = conexion.consultaUno("select isnull(CEGR_BSIN_MENCION,'0') from CANDIDATOS_EGRESO where cast(pers_ncorr as varchar)='"&q_pers_ncorr&"' and cast(plan_ccod as varchar)='"&q_plan_ccod&"' and carr_ccod='"&q_carr_ccod&"'")
'response.End()
chequeado = ""
if sin_mencion = "1" then
	chequeado = "checked"
end if



lenguetas = Array(Array("Solicitud de egreso", "predictivo_dir_escuela_vb.asp?pers_ncorr=" & q_pers_ncorr&"&carr_ccod="& q_carr_ccod & "&plan_ccod="&q_plan_ccod))
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

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
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
        <td>
		  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas lenguetas, 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
			<div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
              <br>
              <table width="98%"  border="1">
                <tr>
                  <td width="90%">
				      <table width="100%" cellpadding="0" cellspacing="0">
					    <tr>
						    <td colspan="3" height="25" align="left"><b>Direcci&oacute;n de Escuela:</b></td>
						</tr>
						<form name="edicion">
						<input type="hidden" name="plan_ccod" value="<%=q_plan_ccod%>"> 
						<input type="hidden" name="carr_ccod" value="<%=q_carr_ccod%>"> 
						<input type="hidden" name="pers_ncorr" value="<%=q_pers_ncorr%>"> 
						<tr>
						    <td width="20%" height="25" align="left"><b>Rut Alumno</b></td>
							<td width="5%" align="center"><b>:</b></td>
							<td width="75%" align="left"><%=f_encabezado.obtenerValor("rut")%></td>
						</tr>
						<tr>
						    <td width="20%" height="25" align="left"><b>Apellidos</b></td>
							<td width="5%" align="center"><b>:</b></td>
							<td width="75%" align="left"><%=f_encabezado.obtenerValor("apellidos")%></td>
						</tr>
						<tr>
						    <td width="20%" height="25" align="left"><b>Nombres</b></td>
							<td width="5%" align="center"><b>:</b></td>
							<td width="75%" align="left"><%=f_encabezado.obtenerValor("nombres")%></td>
						</tr>
						<tr>
						    <td width="20%" height="25" align="left"><b>Carrera</b></td>
							<td width="5%" align="center"><b>:</b></td>
							<td width="75%" align="left"><%=f_encabezado.obtenerValor("carrera")%></td>
						</tr>
						<%if grabado <> "0" then%>
						<tr>
						    <td width="20%" height="25" align="left"><font color="#CC3300"><b>Fecha solicitud</b></font></td>
							<td width="5%" align="center"><font color="#CC3300"><b>:</b></font></td>
							<td width="75%" align="left"><font color="#CC3300"><%=fecha_solicitud%></font></td>
						</tr>
						<tr>
						    <td width="20%" height="25" align="left"><font color="#CC3300"><b>Estado solicitud</b></font></td>
							<td width="5%" align="center"><font color="#CC3300"><b>:</b></font></td>
							<td width="75%" align="left"><font color="#CC3300"><%=Estado_solicitud%></font></td>
						</tr>
						<%end if%>
						<tr>
						    <td colspan="3" height="25" align="left"><b>Salidas y Menciones</b></td>
						</tr>
						<tr>
						    <td colspan="3"><div align="right">P&aacute;ginas : <%f_salidas.AccesoPagina%></div></td>
						</tr>
						<tr>
						    <td colspan="3" align="center"><%f_salidas.DibujaTabla%></td>
						</tr>
						<tr>
						    <td colspan="3"><div align="center"><%f_salidas.Pagina%></div></td>
						</tr>
						<tr>
						    <td colspan="3"><div align="center">&nbsp;</div></td>
						</tr>
						<tr>
						    <td width="20%" align="right"><input type="checkbox" name="sin_mencion" value="1" <%=chequeado%>></td>
							<td colspan="2" align="left">Como encargado de escuela, solicito no considerar Menci&oacute;n para &eacute;ste alummno.</td>
						</tr>
						 </form>
					  </table>	
					</td>
                </tr>
              </table>
              </div>
            </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="20%" height="20">
			   <table width="90%">
			   		<tr>
						<td width="25%"><div align="center"><%f_botonera.DibujaBoton "cerrar"%></div></td>
						<td width="25%"><div align="center"><%if grabado <> "0" or eceg_ccod <> "1" then
						                                         f_botonera.agregaBotonParam "guardar_vb","deshabilitado","true"
						                                      end if
						                                      f_botonera.DibujaBoton "guardar_vb"%></div></td>
						<td width="25%"><div align="center"><%if grabado = "0" or eceg_ccod <> "1" then
						                                         f_botonera.agregaBotonParam "cancelar_vb","deshabilitado","true"
															  end if
						                                      f_botonera.DibujaBoton "cancelar_vb"%></div></td>
						<td width="25%"><div align="center"><%if restante <> "0" and Estado_solicitud = "RECHAZADO" then
						                                         f_botonera.DibujaBoton "reenviar_vb"
															  end if
						                                      %></div></td>									   
					</tr>
			   </table>
			</td>
            <td width="80%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
