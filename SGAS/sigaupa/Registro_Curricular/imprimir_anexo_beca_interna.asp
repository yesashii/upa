<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'*******************************************************************
'DESCRIPCION		: 
'FECHA CREACIÓN		: 28/11/2013
'CREADO POR 		: Michael Shaw Rojas
'ENTRADA		:NA
'SALIDA			:NA

'********************************************************************
set pagina = new CPagina

q_post_ncorr	= request.querystring("post_ncorr")
q_cont_ncorr	= request.querystring("cont_ncorr")

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'*****************ANIO DE ADMISION*****************
 set anio_admision = new CFormulario
 anio_admision.Carga_Parametros "tabla_vacia.xml", "tabla"
 anio_admision.Inicializar conexion
 sql_datos_solicitud= "select ''"
 
'****************DESCUENTOS*******************
 set descuentos = new CFormulario
 descuentos.Carga_Parametros "tabla_vacia.xml", "tabla"
 descuentos.Inicializar conexion
 sql_descuentos= "select ''"

'****************FECHA ACTUAL******************
v_anio=Year(date())
if Day(date())<9 then
	v_dia="0"&Day(date())
else
	v_dia=Day(date())
end if

if Month(date())<9 then
	v_mes="0"&Month(date())
else
	v_mes=Month(date())
end if
'********************************************

if q_post_ncorr <> "" then
	set datos = new CFormulario
	datos.Carga_Parametros "tabla_vacia.xml", "tabla"
	datos.Inicializar conexion
 
	sql_datos= "select distinct "&q_cont_ncorr&" AS nro_contrato , pa.anos_ccod, d.SDES_MCOLEGIATURA, td.STDE_TDESC, PERS_TNOMBRE+' '+PERS_TAPE_PATERNO+' '+PERS_TAPE_MATERNO AS nombre, protic.obtener_rut(p.pers_ncorr) AS rut"& vbcrlf & _
		"from personas p"& vbcrlf & _
		"	INNER JOIN alumnos a"& vbcrlf & _
		"		ON a.PERS_NCORR=p.PERS_NCORR"& vbcrlf & _
		"	INNER JOIN postulantes po"& vbcrlf & _
		"		ON po.PERS_NCORR=p.PERS_NCORR"& vbcrlf & _
		"	inner join SDESCUENTOS d"& vbcrlf & _
		"		on d.OFER_NCORR=a.OFER_NCORR"& vbcrlf & _
		"			and po.POST_NCORR=d.POST_NCORR"& vbcrlf & _
		"	INNER JOIN STIPOS_DESCUENTOS td"& vbcrlf & _
		"		ON d.STDE_CCOD=td.STDE_CCOD"& vbcrlf & _
		"	INNER JOIN CONTRATOS c"& vbcrlf & _
		"		ON c.MATR_NCORR=a.MATR_NCORR"& vbcrlf & _
		"	INNER JOIN periodos_academicos pa"& vbcrlf & _
		"		ON po.peri_ccod=pa.peri_ccod"& vbcrlf & _
		"where po.post_ncorr = "&q_post_ncorr & vbcrlf & _
		"	AND td.TBEN_CCOD=2"& vbcrlf & _
		"	AND td.STDE_CCOD IN (2316,2650,2861,2860,2205,2210,2773,1272,2187,2617,924,1271,2859,1505,2208,2359,905,1273,1944,1945,2354)" 
	
	'response.write sql_datos
	datos.Consultar sql_datos
	monto = 0
	descuento = ""
	i=1
	
	while datos.siguiente
		nombre = datos.obtenerValor("nombre")
		rut = datos.obtenerValor("rut")
		monto = monto + CDbl(datos.obtenerValor("SDES_MCOLEGIATURA"))
		nro_contrato = datos.obtenerValor("nro_contrato")
		anos_ccod = datos.obtenerValor("anos_ccod")
		if i <> datos.nroFilas then
			descuento = descuento +datos.obtenerValor("STDE_TDESC")+", "
		else
			descuento = descuento +datos.obtenerValor("STDE_TDESC")
		end if
		i=i+1
	wend
end if 
'------------------------------------------------------------------------------------------------

%>
<html>
<head>
<title>Anexo beca interna</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/tabla.css" rel="stylesheet" type="text/css">

<script>
function imprimir()
{
  window.print();  
}
</script>
</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<style>
@media print{ 
.noprint {
	visibility:hidden; 
}
}
</style>
<table width="600" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" >
	<br/>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" >
      <tr>
        <td>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr>
              	<td valign="top">
					<table width="100%">
						<tr>
							<td width="15%"><img src="../imagenes/logo_upa_rojo_2011.png" /></td>
							<td width="75%"> <div align="center"></div></td>
							<td width="10%"></td>
						</tr>
					</table>  
				</td>
            </tr>
            <tr>
              <td>
				<BR/>
				<BR/>
				<BR/>
				<BR/>
				<DIV align="center"><font face="Verdana, Arial, Helvetica, sans-serif"><span style="color:#42424A; font-weight: bold; font-size: 17px">ANEXO DE CONTRATO PARA ALUMNOS BENEFICIADOS <br>CON BECA INTERNA <%=anos_ccod%></span></font></DIV>
				<div align="left">
 				<br/>
                  <br/>
                  <br/>
                  	
                  <p align="justify" style="line-height:18pt;font-size: 16px">
					El  alumno (a), <b><%= nombre %></b> Rut <b><%= rut %></b> es beneficiado (a) con un descuento de arancel/copago arancel, para el período académico <b><%= anos_ccod %></b>, correspondiente a:<b> $<%= monto %>.- </b>  
					bajo el concepto de <b><%= descuento %></b>,   
					declara conocer el Reglamento Interno, que rige este descuento y sus requisitos para renovarlo. </p>
                </div>
                  <br>
              </td>
            </tr>
        </table></td>
      </tr>
      <tr>
        <td>
		<table>
		<tr>
			<td>
				<br/><br/><br/><br/><center>
				  _____________________________<br/> 
				<p style="font-size: 14px ">Alumno </p>
				</center><br/>
			</td>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td align="right">
				<br/><br/><br/><br/><center>
				  _____________________________<br/> 
				<p style="font-size: 14px ">Apoderado</p>
				</center><br/>
			</td>
		</tr>
		</table>
		  <p style="font-size: 14px ">N° Contrato : <b><%= nro_contrato %></b> </p>
          <p style="font-size: 14px ">Santiago,<b><%=v_dia%></b> de <b><%=v_mes%></b> del <b><%=v_anio%></b> </p>
		  </td>
      </tr>
      <tr>
        <td align="center" class="noprint" ><br/><a href="#" onClick="imprimir();">Imprimir</a></td>
      </tr>
    </table>
	</td>
  </tr>  
</table>
</body>
</html>
<!-- END: main -->