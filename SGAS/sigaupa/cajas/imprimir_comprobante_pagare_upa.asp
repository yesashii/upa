<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%


v_pepu_ccod= request.querystring("pepu_ccod")

set pagina = new CPagina
pagina.Titulo = "Comprobante ingresos pago electronico de Pagare UPA N° "&v_pepu_ccod
'**********************************************************
set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

v_usuario=negocio.ObtenerUsuario()
fecha_actual= conectar.consultaUno("select protic.trunc(getDate())")


'**********************************************************
set f_letras = new CFormulario
f_letras.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
f_letras.Inicializar conectar
	if v_pepu_ccod<>"" then

		sql_pago_letras =" select tcom_ccod,comp_ndocto, dcom_ncompromiso,protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre,protic.trunc(pepu_fvencimiento) as  fvencimiento, "&_
							" pepu_ccod,edin_ccod, b.pers_ncorr, pepu_nidentificacion as num_letra,pepu_mmonto_recaudado as monto_letra, protic.obtener_rut(b.pers_ncorr) as rut_alumno, "&_
							" protic.trunc(pepu_frecaudacion) as  frecaudacion, pepu_nidentificacion,pepu_mvalor_cuota,pepu_mmonto_recaudado,  "&_
							" a.ingr_nfolio_referencia " & vbCrlf & _
							" from pago_electronico_pagare_upa a join personas b  "&_
							"  on a.pers_nrut=b.pers_nrut "&_
							" join detalle_ingresos c  "&_
							"     on LEFT(pepu_nidentificacion,LEN(pepu_nidentificacion)-2)=c.ding_ndocto "&_
							"     and c.ting_ccod=66 "&_
							" join ingresos d "&_
							"     on c.ingr_ncorr=d.ingr_ncorr "&_
							" join  abonos e "&_
							"     on d.ingr_ncorr=e.ingr_ncorr "&_ 
							" where pepu_ccod="&v_pepu_ccod&" "&_
							" and d.eing_ccod=4 "&_
							" and a.ingr_nfolio_referencia is not null"&_
							" and a.pepu_nidentificacion= protic.obtener_numero_pagare_upa_softland(d.ingr_ncorr)" 
	else
		sql_pago_letras="select ''"
	end if

'response.Write(sql_pago_letras)
	
f_letras.Consultar sql_pago_letras




'*****************************************************************************************
'***************	listas de seleccion para filas de tabla dinamica	******************	


set f_busqueda = new CFormulario
f_busqueda.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_busqueda.inicializar conectar
f_busqueda.consultar "select '' "


sql_datos_caja=" select top 1 protic.obtener_rut(d.pers_ncorr) as rut_cajero, protic.obtener_nombre_completo(d.pers_ncorr,'n') as nombre_completo, "&_
				"	protic.trunc(mcaj_finicio) as fecha_caja, b.mcaj_ncorr, "&_
				"	(select count(*) from pago_electronico_pagare_upa where pepu_ccod="&v_pepu_ccod&") as cantidad_doc, "&_
				"	(select sum(pepu_mvalor_cuota) from pago_electronico_pagare_upa where pepu_ccod="&v_pepu_ccod&") as monto_total "&_
				"	from pago_electronico_pagare_upa a "&_
				"	join ingresos b  "&_
				"		on a.ingr_nfolio_referencia=b.ingr_nfolio_referencia "&_
				"	join movimientos_cajas c  "&_
				"		on b.mcaj_ncorr=c.mcaj_ncorr "&_
				"	join cajeros d "&_
				"		on c.caje_ccod=d.caje_ccod "&_
				"		and c.sede_ccod=d.sede_ccod "&_
				"	where a.pepu_ccod="&v_pepu_ccod&" "&_
				"	and b.ting_ccod=16 "

'response.Write("<pre>"&sql_datos_caja&"</pre>")

f_busqueda.consultar sql_datos_caja
f_busqueda.Siguiente
'response.Write("<hr>"&area_ccod)


'*****************************************************************************************
'***************	FIN listas de seleccion para filas de tabla dinamica	**************

%>
<style>
table{
	font-family:Verdana, Arial, Helvetica, sans-serif;
    font-size: 0.9em;
}
p.encabezado{
    font-size: 0.725em;
}
table.membrete{
    font-size: 0.725em;
}
</style>

<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
          <td>
		  	<table class="membrete" align="center" width="760" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="142" align="left"><img src="../imagenes/logo_upa_2011.jpg" height="100"  alt="Logo"></td>
					<td width="455" valign="top"><p>Vicerrectoria de Administración y Finanzas </p>
					  <p>Dirección de Finanzas</p></td>
				  <td width="163"><br/></td>
				</tr>
			</table>
		  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td>
					  <br/>
                      <center><%pagina.DibujarTituloPagina()%></center>
					  <br/>
                <table width="760" align="center">
				<tr>
					<td>
					<p class="encabezado">&nbsp;</p>
					</td>
					<td valign="bottom" align="right"><table>
					<tr><td align="left">Fecha de impresión:</td><td style="border: 1px solid black">&nbsp;<%=fecha_actual%></td></tr>
					</table>
					
					</td>
				</tr>
				</table>
                  <table width="760" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
                    <td>
						<table width="100%" border="0">
						  <tr >
						    <td width="15%"> Cajero </td>
						    <td style="border: 1px solid black" width="35%"><%=f_busqueda.ObtenerValor("nombre_completo")%> </td> 
							<td width="15%">Total Doctos </td>
							<td  style="border: 1px solid black">&nbsp;<%f_busqueda.DibujaCampo("cantidad_doc")%></td>
						  </tr>						
						  <tr> 
							<td width="11%">Rut Cajero </td>
							<td style="border: 1px solid black" width="27%"> <%=f_busqueda.ObtenerValor("rut_cajero")%></td>
							<td>N&deg; Caja </td>
							<td style="border: 1px solid black">&nbsp;<%f_busqueda.DibujaCampo("mcaj_ncorr")%>
							</td>
						  </tr>
						  <tr>
						    <td>Monto Total </td>
						    <td style="border: 1px solid black"><%=f_busqueda.ObtenerValor("monto_total")%></td> 
							<td > Fecha Caja </td>
							<td  style="border: 1px solid black">&nbsp;<%f_busqueda.DibujaCampo("fecha_caja")%></td>
						  </tr>
						</table>
						<p><strong>Detalle pago Pagare UPA </strong></p>
								<table width="100%" border='0' cellpadding='1' cellspacing='1' >
									<tr>
										<th width="50%">Rut alumno </th>
										<th width="12%">N&deg; Cuota </th>
										<th width="12%">Comprobante</th>
										<th width="12%">Fecha</th>
										<th width="16%">Valor</th>
									</tr>
									<%
										if f_letras.nrofilas >=1 then
											ind=0
											v_totalizado=0
											while f_letras.Siguiente 
											%>
											<tr>
												<td style="border: 1px solid black"><%=f_letras.ObtenerValor("rut_alumno")%></td>
												<td style="border: 1px solid black"><%=f_letras.ObtenerValor("num_letra")%></td>
												<td style="border: 1px solid black"><%=f_letras.ObtenerValor("ingr_nfolio_referencia")%> </td>
												<td style="border: 1px solid black"><%=f_letras.ObtenerValor("frecaudacion")%> </td>
												<td style="border: 1px solid black"><%=f_letras.ObtenerValor("monto_letra")%> </td>
											</tr>	
											<%
											v_totalizado=v_totalizado+clng(f_letras.ObtenerValor("monto_letra"))
											ind=ind+1
											wend
										end if 
									%>
									<tr>
										<th colspan="4" align="right">Total cargado</th>
										<td width="10%" style="border: 1px solid black"><%=v_totalizado%></td>
									</tr>
								</table>								
						<p><br/>
					</p>
                      <table align="center" width="98%" border="0"  cellspacing="10">
						<tr>
							<td style="border: 1px solid black" valign="bottom" width="30%" align="center"><br><br><br>V°B° Cajas </td>
							<td style="border: 1px solid white" valign="bottom" width="35%"></td>
							
							<td style="border: 1px solid black" valign="bottom" width="35%"  align="center"><br><br><br>V°B° Tesoreria </td>
						</tr>
					</table>
				    </td>
                  </tr>
                </table>
					</td>
                </tr>
            </table>
		  </td>
        </tr>
      </table>	
</body>
</html>