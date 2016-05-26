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
sql_anio_admision= 	 "	select anos_ccod "&_
					 "	from postulantes a,periodos_academicos b "&_
					 "	where cast(a.post_ncorr as varchar)='"&q_post_ncorr&"'"&_
					 "	and a.peri_ccod=b.peri_ccod"

' "	and stde_ccod in (2354,905,924,1276,1271,1272,1273,1278,1505,1537,1725,1726,1727,1944,1945,2187,2205,2208,2210,2220,2316) "&_
sql_descuentos= 	 "	select top 1 sdes_nporc_colegiatura as porcentaje,tdet_tdesc as descuento, sdes_mcolegiatura as monto "&_
					 "  from sdescuentos a, tipos_detalle b  "&_
					 "	where post_ncorr in ("&q_post_ncorr&") "&_
					 "  and stde_ccod in (2359,2354,905,924,2617,1271,1272,1273,1505,1725,1726,1727,1944,1945,2187,2208,2210) "& vbcrlf & _
					 "	and a.stde_ccod=b.tdet_ccod "&_
					 "	and esde_ccod=1 " 

end if 

		anio_admision.Consultar sql_anio_admision
		anio_admision.Siguiente
		
ano_admision = anio_admision.obtenerValor("anos_ccod")		
		
		descuentos.Consultar sql_descuentos
		descuentos.Siguiente
		
porcentaje = descuentos.obtenerValor("porcentaje")	
descuento = descuentos.obtenerValor("descuento")	
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
				<DIV align="center"><font face="Verdana, Arial, Helvetica, sans-serif"><span style="color:#42424A; font-weight: bold; font-size: 17px">ANEXO DE CONTRATO PARA ALUMNOS BENEFICIADOS CON BECA INTERNA</span></font></DIV>
				<div align="left">
 				<br/>
                  <br/>
                  <br/>
                  	
                  <p align="justify" style="line-height:18pt;font-size: 16px">
					El  alumno (a), ....................................................... Rut ......................
					es beneficiado (a) con un descuento de arancel, para el período académico <b><%=ano_admision%></b>, correspondiente a:<b> <%=porcentaje%>%</b>  
					bajo el concepto de <b><%=descuento%></b>,   
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

          <p style="font-size: 12px ">Santiago,<b><%=v_dia%></b> de <b><%=v_mes%></b> del <b><%=v_anio%></b> </p>
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