<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%


v_fren_ncorr= request.querystring("fren_ncorr")

set pagina = new CPagina
pagina.Titulo = "Rendicion de Fondo a Rendir N° "&v_fren_ncorr
'**********************************************************
set botonera = new CFormulario
botonera.carga_parametros "reembolso_gasto.xml", "botonera"

set conectar = new cconexion
conectar.inicializar "upacifico"

set conexion = new Cconexion2
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

v_usuario=negocio.ObtenerUsuario()
v_anos_ccod	= conectar.consultaUno("select year(getdate())")


'**********************************************************
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "pago_proveedor.xml", "datos_proveedor"
f_busqueda.Inicializar conectar
	if v_fren_ncorr<>"" then

		sql_datos_solicitud	= " select year(fren_fpago) as anio,protic.trunc(fren_fpago) as fren_fpago,protic.trunc(fren_factividad) as fren_factividad, a.*, "&_
								" c.pers_tnombre+' '+c.pers_tape_paterno as v_nombre, c.pers_tnombre, cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, d.pers_tnombre as pers_tnombre_aut, d.pers_xdv  as pers_xdv_aut   "&_
								" from ocag_fondos_a_rendir a, personas c, personas d "&_
								"	where a.pers_ncorr=c.pers_ncorr "&_ 
								" 	and a.pers_nrut_aut=d.pers_nrut "&_
								" 	and a.fren_ncorr="&v_fren_ncorr
							
	else
		sql_datos_solicitud="select ''"
	end if
	
f_busqueda.Consultar sql_datos_solicitud
f_busqueda.Siguiente

if area_ccod="" or EsVacio(area_ccod) then
	area_ccod= f_busqueda.ObtenerValor("area_ccod")
end if


set f_presupuesto = new CFormulario
 	f_presupuesto.Carga_Parametros "datos_presupuesto.xml", "detalle_presupuesto"
 	f_presupuesto.Inicializar conectar
	sql_presupuesto="select * from ocag_presupuesto_solicitud where cast(cod_solicitud as varchar)='"&v_fren_ncorr&"' and tsol_ccod=3 and isnull(psol_brendicion,'N') ='S'"
	f_presupuesto.consultar sql_presupuesto	
	filas_presu= f_presupuesto.nrofilas
	

'*****************************************************************************************
'***************	listas de seleccion para filas de tabla dinamica	******************	


set f_cod_pre = new CFormulario
f_cod_pre.carga_parametros "orden_compra.xml", "codigo_presupuesto"
f_cod_pre.inicializar conexion
f_cod_pre.consultar "select '' "


sql_codigo_pre="(select distinct cod_pre, 'Area('+cast(cast(cod_area as numeric) as varchar)+')-'+concepto as valor "&_
			    " from presupuesto_upa.protic.presupuesto_upa_2011 	"&_
			    "	where cod_anio=2011 "&_
				"	and cod_area in (   select distinct area_ccod "&_ 
				"		 from  presupuesto_upa.protic.area_presupuesto_usuario  "&_
				"		 where rut_usuario in ("&v_usuario&") and cast(area_ccod as varchar)= '"&area_ccod&"') "&_
				" ) as tabla "

'response.Write(sql_codigo_pre)
f_cod_pre.agregaCampoParam "cod_pre","destino", sql_codigo_pre
f_cod_pre.consultar sql_codigo_pre
f_cod_pre.Siguiente
'response.Write("<hr>"&area_ccod)

set f_centro_costo = new CFormulario
f_centro_costo.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_centro_costo.inicializar conectar

sql_centro_costo=" select a.ccos_ncorr,a.ccos_tcodigo as ccos_tcompuesto,ccos_tdesc "&_ 
					" from ocag_centro_costo a, ocag_permisos_centro_costo b "&_ 
					" where a.ccos_tcodigo=b.ccos_tcodigo "&_ 
					" and pers_nrut="&v_usuario

f_centro_costo.consultar sql_centro_costo

set f_datos_area = new CFormulario
f_datos_area.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_datos_area.inicializar conexion

sql_datos_area= " select * from presupuesto_upa.protic.area_presupuestal where area_ccod="&area_ccod

f_datos_area.consultar sql_datos_area
f_datos_area.siguiente
'response.end()

sql_devolucion= " select a.pers_nrut from ocag_devolucion_rendicion_fondos a, personas b "&_
				" where fren_ncorr="&v_fren_ncorr&" "&_
				" and a.pers_nrut=b.pers_nrut "

v_pers_nrut=conectar.ConsultaUno(sql_devolucion)

v_generador=conectar.consultaUno("select protic.obtener_nombre_completo(pers_ncorr,'n') as generador from personas where cast(pers_nrut as varchar)='"&v_pers_nrut&"'")
'*****************************************************************************************
'***************	FIN listas de seleccion para filas de tabla dinamica	**************

set f_detalle = new CFormulario
f_detalle.Carga_Parametros "rendicion_fondo_fijo.xml", "detalle_rendicion"
f_detalle.Inicializar conectar

if v_fren_ncorr<>"" then
	sql_detalle_pago= 	" Select protic.trunc(rfre_fdocto) as rfre_fdocto, cast(a.pers_nrut as varchar)+'-'+pers_xdv as rut, * "&_
						" from ocag_rendicion_fondos_a_rendir a, personas b where fren_ncorr ="&v_fren_ncorr&" and a.pers_nrut=b.pers_nrut"
else
	sql_detalle_pago= "select '' "
end if	
'response.Write(sql_detalle_pago)
f_detalle.Consultar sql_detalle_pago



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
		  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td>
					  <br/>
                      <center><%pagina.DibujarTituloPagina()%></center>
					  <br/>
                  <table width="760" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
                    <td>
							<p><strong>Anexo detalle por rendicion</strong></p>
							<table align="center" width="100%" border="0"  cellpadding="0" cellspacing="5">
								<tr>
									<th>Tipo Gasto </th>
									<th>Fecha Docto</th>
									<th>Tipo Docto </th>
									<th>N&deg;Docto</th>
									<th>Rut</th>
									<th>Retencion</th>
									<th>Monto</th>
								</tr>
									<%
								if f_detalle.nrofilas >=1 then
									ind=0
									v_total_rendido=0
									while f_detalle.Siguiente %>
									<tr>
										<td style="border: 1px solid black" align="center"><%=f_detalle.ObtenerValor("tgas_ccod")%></td>
										<td style="border: 1px solid black" align="center"><%=f_detalle.ObtenerValor("rfre_fdocto")%></td>
										<td style="border: 1px solid black" align="center"><%=f_detalle.ObtenerValor("tdoc_ccod")%> </td>
										<td style="border: 1px solid black" align="center"><%=f_detalle.ObtenerValor("rfre_ndocto")%> </td>
										<td style="border: 1px solid black" align="center"><%=f_detalle.ObtenerValor("rut")%> </td>
										<td style="border: 1px solid black" align="center"><%=f_detalle.ObtenerValor("rfre_mretencion")%> </td>
										<td style="border: 1px solid black" align="center"><%=f_detalle.ObtenerValor("rfre_mmonto")%> </td>
									</tr>	
									<%
									v_total_rendido=clng(v_total_rendido)+clng(f_detalle.ObtenerValor("rfre_mmonto"))
									ind=ind+1
									wend
								end if
								%>	
							<tr>
								<th colspan="5"></th>
								<td align="right">Total Rendido</td>
								<td style="border: 1px solid black">&nbsp;<%=v_total_rendido%></td>
							</tr>
							<tr>
								<th colspan="5"></th>
								<td align="right">Monto Asignado</td>
								<td style="border: 1px solid black">&nbsp;<%=f_busqueda.ObtenerValor("fren_mmonto")%></td>
							</tr>	
							<tr>
								<th colspan="5"></th>
								<td align="right">Monto a Girar</td>
								<td style="border: 1px solid black">&nbsp;<%=Clng(v_total_rendido-Clng(f_busqueda.ObtenerValor("fren_mmonto")))%></td>
							</tr>																																			
						</table>

						<p><strong>Datos Presupuesto</strong></p>
								<table width="100%" border='0' cellpadding='1' cellspacing='1' >
									<tr>
										<th width="50%">Descripcion</th>
										<th width="12%">Codigo</th>
										<th width="12%">Mes</th>
										<th width="12%">Año</th>
										<th width="16%">Valor</th>
									</tr>
									<%
										if f_presupuesto.nrofilas >=1 then
											ind=0
											v_totalizado=0
											while f_presupuesto.Siguiente 
											v_cod_pre=f_presupuesto.ObtenerValor("cod_pre")
											%>
											<tr>
												<td style="border: 1px solid black">
														<%
														f_cod_pre.primero
														while f_cod_pre.Siguiente 
															if Cstr(f_cod_pre.ObtenerValor("cod_pre"))=Cstr(v_cod_pre) then
																response.Write(f_cod_pre.ObtenerValor("valor"))
															end if
														wend%>
											  </td>
												<td style="border: 1px solid black"><%=v_cod_pre%></td>
												<td style="border: 1px solid black"><%
												f_presupuesto.AgregaCampoParam "mes_ccod", "permiso", "ESCRITURA"
												f_presupuesto.DibujaCampo("mes_ccod")%> </td>
												<td style="border: 1px solid black"><%
												f_presupuesto.AgregaCampoParam "anos_ccod", "permiso", "ESCRITURA"
												f_presupuesto.DibujaCampo("anos_ccod")%> </td>
												<td style="border: 1px solid black"><%=f_presupuesto.ObtenerValor("psol_mpresupuesto")%> </td>
											</tr>	
											<%
											v_totalizado=v_totalizado+clng(f_presupuesto.ObtenerValor("psol_mpresupuesto"))
											ind=ind+1
											wend
										end if 
									%>
									<tr>
										<th colspan="4" align="right">Total presupuesto</th>
										<td width="10%" style="border: 1px solid black"><%=v_totalizado%></td>
									</tr>
								</table>
					<p><strong>Identificacion del fondo</strong></p>
                      <table width="100%" border="0">
                        <tr> 
                          <td align="center">
								<table width="100%" border="0">
									<tr> 
										<td>N°Fondo</td>
										<td>Año</td>
										<td>Fecha Solicitud</td>
										<td>Fecha Actividad</td>
										<td>Rut solicitud</td>
										<td>Nombre solicitante</td>
									</tr>
									<tr> 
										<td style="border: 1px solid black">&nbsp;<%=f_busqueda.ObtenerValor("fren_ncorr")%></td>
										<td style="border: 1px solid black">&nbsp;<%=f_busqueda.ObtenerValor("anio")%></td>
										<td style="border: 1px solid black">&nbsp;<%=f_busqueda.ObtenerValor("fren_factividad")%></td>
										<td style="border: 1px solid black">&nbsp;<%=f_busqueda.ObtenerValor("fren_fpago")%></td>
										<td style="border: 1px solid black">&nbsp;<%=f_busqueda.ObtenerValor("rut")%></td>
										<td style="border: 1px solid black">&nbsp;<%=f_busqueda.ObtenerValor("v_nombre")%></td>
									</tr>
								</table>						  
						  </td>
                        </tr>
                      </table>																
						<p><strong>Datos solicitante</strong></p>
                      <table width="100%" border="0">
                        <tr> 
                          <td align="center">
								<table width="100%" border="0">
									<tr> 
										<td width="10%">Solicitado por </td>
									  <td width="20%" style="border: 1px solid black">&nbsp;<%=f_datos_area.ObtenerValor("nombre_responsable")%></td>
										<td width="10%">Generada por </td>
									  <td width="20%" style="border: 1px solid black">&nbsp; <%=Ucase(v_generador)%></td>
										<td width="30%" rowspan="2" align="center" valign="bottom">_______________________<br>
									  Firma y Timbre solicitante</td>
									</tr>
									<tr> 
										<td>Unidad Solicitante </td>
										<td colspan="3" style="border: 1px solid black"><%=f_datos_area.ObtenerValor("area_tdesc")%></td>
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
		  </td>
        </tr>
      </table>	
</body>
</html>