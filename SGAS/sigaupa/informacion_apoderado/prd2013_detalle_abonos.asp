<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno_2008.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_tcom_ccod = Request.QueryString("tcom_ccod")
q_inst_ccod = Request.QueryString("inst_ccod")
q_comp_ndocto = Request.QueryString("comp_ndocto")
q_dcom_ncompromiso = Request.QueryString("dcom_ncompromiso")

'---------------------------------------------------------------------------------------------------

set pagina = new CPagina
pagina.Titulo = "Detalle de abonos"

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "detalle_abonos.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

'set negocio = new CNegocio
'negocio.Inicializa conexion


'---------------------------------------------------------------------------------------------------
set f_cuota = new CFormulario
f_cuota.Carga_Parametros "detalle_abonos.xml", "cuota"
f_cuota.Inicializar conexion


select case q_tcom_ccod
	case "5"
		numero = conexion.consultaUno("select ding_ndocto from referencias_cargos where reca_ncorr='" & q_comp_ndocto & "'")
		
	case "6"
		numero = conexion.consultaUno("select ding_ndocto from referencias_cargos where reca_ncorr='" & q_comp_ndocto & "'")
		
	case "14"
		numero = conexion.consultaUno("select ding_ndocto from compromisos_cheques where cche_ncorr='" & q_comp_ndocto & "'")
	
	case else
		numero = conexion.ConsultaUno("select protic.documento_asociado_cuota('" & q_tcom_ccod & "', '" & q_inst_ccod & "', '" & q_comp_ndocto & "', '" & q_dcom_ncompromiso & "', 'ding_ndocto')")

end select

'--------------------------------------------------------------------------------

consulta = "select '" & numero & "' as Num_Docto, a.comp_ndocto, a.tcom_ccod, a.dcom_ncompromiso, a.dcom_mcompromiso, a.dcom_fcompromiso, protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_completo " & vbCrLf &_
           "from detalle_compromisos a " & vbCrLf &_
		   "where a.tcom_ccod = '" & q_tcom_ccod & "'  " & vbCrLf &_
		   "  and a.inst_ccod = '" & q_inst_ccod & "'  " & vbCrLf &_
		   "  and a.comp_ndocto = '" & q_comp_ndocto & "'  " & vbCrLf &_
		   "  and a.dcom_ncompromiso = '" & q_dcom_ncompromiso & "'"
f_cuota.Consultar consulta

'---------------------------------------------------------------------------------------------------		   
set f_abonos = new CFormulario
f_abonos.Carga_Parametros "detalle_abonos.xml", "abonos"
f_abonos.Inicializar conexion
		   
consulta = "select cast(case d.ting_brebaje when 'S' then -a.abon_mabono else a.abon_mabono end as numeric) as abon_mabono" & vbCrLf &_
			"        , a.abon_fabono, b.eing_ccod, b.ingr_fpago, b.ingr_mefectivo, b.ingr_mdocto, b.ting_ccod" & vbCrLf &_
			"        , b.ingr_nfolio_referencia, (select ting_ccod from detalle_ingresos where ingr_ncorr=b.ingr_ncorr) as ting_ccod_documento,"  & vbCrLf &_
			" c.ding_ndocto, c.ding_mdocto, c.ding_fdocto , c.banc_ccod " & vbCrLf &_
			"    from abonos a,ingresos b,detalle_ingresos c,tipos_ingresos d" & vbCrLf &_
			"    where a.ingr_ncorr = b.ingr_ncorr" & vbCrLf &_
			"        and b.ingr_ncorr *= c.ingr_ncorr" & vbCrLf &_
			"        and b.ting_ccod = d.ting_ccod" & vbCrLf &_
			"        and protic.estado_origen_ingreso(a.ingr_ncorr) in (1, 5)" & vbCrLf &_
			"        and isnull(c.ding_bpacta_cuota, 'N') = 'N' " & vbCrLf &_
			"        and a.tcom_ccod = '" & q_tcom_ccod & "' " & vbCrLf &_
			"        and a.inst_ccod = '" & q_inst_ccod & "' " & vbCrLf &_
			"        and a.comp_ndocto = '" & q_comp_ndocto & "' " & vbCrLf &_
			"        and a.dcom_ncompromiso = '" & q_dcom_ncompromiso & "'"
f_abonos.Consultar consulta

'---------------------------------------------------------------------------------------------------		   
set f_abonos_documentados = new CFormulario
f_abonos_documentados.Carga_Parametros "detalle_abonos.xml", "abonos"
f_abonos_documentados.Inicializar conexion

consulta = "select cast(case d.ting_brebaje when 'S' then -a.abon_mabono else  a.abon_mabono end as numeric) as abon_mabono" & vbCrLf &_
			"        , a.abon_fabono, b.eing_ccod, b.ingr_fpago, b.ingr_mefectivo, b.ingr_mdocto, b.ting_ccod" & vbCrLf &_
			"        , b.ingr_nfolio_referencia, (select ting_ccod from detalle_ingresos where ingr_ncorr=b.ingr_ncorr) as ting_ccod_documento, c.ding_ndocto, c.ding_mdocto" & vbCrLf &_
			"        , c.ding_fdocto, c.edin_ccod, c.ting_ccod ,c.banc_ccod " & vbCrLf &_
			"    from abonos a,ingresos b,detalle_ingresos c,tipos_ingresos d" & vbCrLf &_
			"    where a.ingr_ncorr = b.ingr_ncorr" & vbCrLf &_
			"        and b.ingr_ncorr *= c.ingr_ncorr" & vbCrLf &_
			"        and b.ting_ccod = d.ting_ccod" & vbCrLf &_
			"        and protic.estado_origen_ingreso(a.ingr_ncorr) = 4 " & vbCrLf &_
			"        and a.tcom_ccod = '" & q_tcom_ccod & "' " & vbCrLf &_
			"        and a.inst_ccod = '" & q_inst_ccod & "' " & vbCrLf &_
			"        and a.comp_ndocto = '" & q_comp_ndocto & "' " & vbCrLf &_
			"        and a.dcom_ncompromiso = '" & q_dcom_ncompromiso & "'"

f_abonos_documentados.Consultar consulta

'---------------------------------------------------------------------------------
set f_detalle = new CFormulario
f_detalle.Carga_Parametros "detalle_abonos.xml", "detalle_cargo"
f_detalle.Inicializar conexion

consulta = "select 1 as orden1, " & vbCrLf &_
			"       case grouping(d.tdet_tdesc)" & vbCrLf &_
			"                when 1 then 2" & vbCrLf &_
			"                else 1" & vbCrLf &_
			"                end as orden2, " & vbCrLf &_
			"       case max(d.tdet_bdescuento)" & vbCrLf &_
			"                when 'S' then 2" & vbCrLf &_
			"                else 1" & vbCrLf &_
			"                end as orden3," & vbCrLf &_
			"       case grouping(d.tdet_tdesc)" & vbCrLf &_
			"                when 1 then '<b><div align=right>TOTAL COMPROMISO</div></b>'" & vbCrLf &_
			"                else d.tdet_tdesc" & vbCrLf &_
			"                end as tdet_tdesc, " & vbCrLf &_
			"	   sum(c.deta_msubtotal) as valor" & vbCrLf &_
			"    from detalle_compromisos a,compromisos b,detalles c,tipos_detalle d" & vbCrLf &_
			"    where a.tcom_ccod = b.tcom_ccod" & vbCrLf &_
			"        and a.inst_ccod = b.inst_ccod" & vbCrLf &_
			"        and a.comp_ndocto = b.comp_ndocto" & vbCrLf &_
			"        and b.tcom_ccod = c.tcom_ccod" & vbCrLf &_
			"        and b.inst_ccod = c.inst_ccod" & vbCrLf &_
			"        and b.comp_ndocto = c.comp_ndocto " & vbCrLf &_
			"        and c.tdet_ccod = d.tdet_ccod      " & vbCrLf &_
			"        and a.tcom_ccod = '" & q_tcom_ccod & "' " & vbCrLf &_
			"        and a.inst_ccod = '" & q_inst_ccod & "'" & vbCrLf &_
			"        and a.comp_ndocto = '" & q_comp_ndocto & "' " & vbCrLf &_
			"        and a.dcom_ncompromiso = '" & q_dcom_ncompromiso & "'" & vbCrLf &_
			"group by d.tdet_tdesc WITH ROLLUP" & vbCrLf &_
			"union" & vbCrLf &_
			"select 2 as orden1, 1 as orden2, 1 as orden3, '<div align=right>Nº CUOTAS</div>', comp_ncuotas " & vbCrLf &_
			"from compromisos " & vbCrLf &_
			"where tcom_ccod = '" & q_tcom_ccod & "' " & vbCrLf &_
			"  and inst_ccod = '" & q_inst_ccod & "' " & vbCrLf &_
			"  and comp_ndocto = '" & q_comp_ndocto & "'  " & vbCrLf &_
			"order by orden1 asc, orden2 asc, orden3 asc "
			
f_detalle.Consultar consulta

i_ = 0
while f_detalle.Siguiente
	if f_detalle.ObtenerValor("orden1") = "2" then
		f_detalle.AgregaCampoFilaParam i_, "valor", "formato", "DECIMAL"
	end if
	
	i_ = i_ + 1
wend
f_detalle.Primero

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Detalle de abonos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_alumno.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
</script>

<style type="text/css">
#menu div.barraMenu,
#menu div.barraMenu a.botonMenu {
font-family: sans-serif, Verdana, Arial;
font-size: 8pt;
color: white;
}

#menu div.barraMenu {
text-align: left;
}

#menu div.barraMenu a.botonMenu {
background-color: #4b73a6;
border-bottom-style:double;
border-color:#FFFFFF;
color: white;
cursor: pointer;
padding: 4px 6px 2px 5px;
text-decoration: none;
}

#menu div.barraMenu a.botonMenu:hover {
background-color: #FFFFFF;
color:#4b73a6;
}

#menu div.barraMenu a.botonMenu:active {
background-color: #637D4D;
color: black;
}
</style>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#CC6600" background="imagenes/fondo.jpg">
<center>
<table align="center" width="700">
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<tr>
		<td width="100%" align="center"><font size="5" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>Detalle de Abonos</strong></font></td>
	</tr>
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<!--Antecedentes educacionales-->
	<tr>
		<td width="100%" align="center">
			<table width="680" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="98%" border="0" bgcolor="#f7faff">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="25%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Detalle de abonos</strong></font></td>
										   <td><hr></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
									  <tr><td height="20" colspan="4"><div align="center"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%f_cuota.DibujaRegistro%></font></div></td></tr>
									  <tr><td height="20" colspan="4">&nbsp;</td></tr>
									  <tr>
									      <td colspan="4">
										  	<form name="edicion">
											<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
											  <tr>
												<td>
												  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
													<tr>
													  <td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Abonos</strong></font></td>
													</tr>
													<tr>
													  <td><div align="center"><%f_abonos.DibujaTabla%></div></td>
													</tr>
												  </table>
												  <br>
												  <br>
												  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
													<tr>
													  <td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Abonos documentados</strong></font></td>
													</tr>
													<tr>
													  <td><div align="center">
														  <%f_abonos_documentados.DibujaTabla%>
													  </div></td>
													</tr>
												  </table>
												  <br>
												  <br>
												  <br>
												  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
													<tr>
													  <td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Detalle Formación del cargo</strong></font></td>
													</tr>
													<tr>
													  <td><div align="center">
														  <%f_detalle.DibujaTabla%>
													  </div></td>
													</tr>
												  </table></td>
											  </tr>
											</table>
										  <br>
										</form>
										  
									      </td>
									  </tr>
									  <tr> 
										<td colspan="4" align="center"><%f_botonera.DibujaBoton("cerrar")%></td>
									  </tr>
								  </table>
                  
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
			</table>
		</td>
	</tr>
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
</table>
</center>
</body>
</html>