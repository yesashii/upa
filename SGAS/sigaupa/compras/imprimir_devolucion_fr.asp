<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%


v_fren_ncorr= request.querystring("fren_ncorr")

set pagina = new CPagina
pagina.Titulo = "Autorizacion de giro por Rendicion de Fondo a Rendir N° "&v_fren_ncorr
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
fecha_actual= conectar.consultaUno("select protic.trunc(getDate())")


'**********************************************************
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "pago_proveedor.xml", "datos_proveedor"
f_busqueda.Inicializar conectar
	if v_fren_ncorr<>"" then

		sql_datos_solicitud	= " select protic.trunc(ocag_fingreso) as ocag_fingreso,protic.trunc(fren_factividad) as fren_factividad, a.*, "&_
								" c.pers_tnombre as v_nombre, c.pers_tnombre, c.pers_nrut, c.pers_xdv, d.pers_tnombre as pers_tnombre_aut, d.pers_xdv  as pers_xdv_aut   "&_
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
	sql_presupuesto="select * from ocag_presupuesto_solicitud where cast(cod_solicitud as varchar)='"&v_fren_ncorr&"' and tsol_ccod=3 and isnull(psol_brendicion,'S') ='S'"
	f_presupuesto.consultar sql_presupuesto	
	filas_presu= f_presupuesto.nrofilas
	

set f_responsable = new CFormulario
	f_responsable.carga_parametros "tabla_vacia.xml", "tabla_vacia"
	f_responsable.inicializar conectar
	sql_responsable= "Select pers_nrut_responsable as pers_nrut,protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre "&_
					  "	from ocag_responsable_area a, personas b "&_
					  "	where a.pers_nrut_responsable=b.pers_nrut "&_
					  "	and cast(a.pers_nrut as varchar)='"&v_usuario&"'"
	f_responsable.consultar sql_responsable

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
'f_cod_pre.Siguiente
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
v_generador=conectar.consultaUno("select protic.obtener_nombre_completo(pers_ncorr,'n') as generador from personas where pers_nrut="&f_busqueda.ObtenerValor("audi_tusuario"))



set f_detalle = new CFormulario
f_detalle.Carga_Parametros "ver_solicitud_giro.xml", "detalle_rendicion_rendir"
f_detalle.Inicializar conectar
sql_detalle_pago= "select drfr_trut as pers_nrut,isnull(drfr_mretencion,0) as drfr_mretencion,protic.trunc(drfr_fdocto) as drfr_fdocto,* from ocag_detalle_rendicion_fondo_rendir where fren_ncorr ="&v_fren_ncorr

f_detalle.Consultar sql_detalle_pago

set f_devolucion = new CFormulario
f_devolucion.Carga_Parametros "ver_solicitud_giro.xml", "devolucion_rendicion"
f_devolucion.Inicializar conectar

	sql_devolucion="select protic.trunc(dren_fcomprobante) as dren_fcomprobante, * from ocag_devolucion_rendicion_fondos where fren_ncorr="&v_fren_ncorr

f_devolucion.Consultar sql_devolucion
f_devolucion.siguiente

set f_presupuesto_devol = new CFormulario
f_presupuesto_devol.Carga_Parametros "ver_solicitud_giro.xml", "detalle_presupuesto"
f_presupuesto_devol.Inicializar conectar

	sql_presupuesto="select * from ocag_presupuesto_solicitud where cast(cod_solicitud_origen as varchar)='"&v_fren_ncorr&"' and tsol_ccod=2 and isnull(psol_brendicion,'S') ='S'"

f_presupuesto_devol.consultar sql_presupuesto
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
					<tr><td align="left">Fecha solicitud:</td><td style="border: 1px solid black">&nbsp;<%=f_busqueda.ObtenerValor("ocag_fingreso")%></td></tr>
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
						    <td width="15%"> Girar a nombre de </td>
						    <td style="border: 1px solid black" width="35%"><%=f_busqueda.ObtenerValor("pers_tnombre")%></td> 
							<td width="15%">&nbsp;</td>
							<td></td>
						  </tr>						
						  <tr> 
							<td width="11%">Rut </td>
							<td style="border: 1px solid black" width="27%"> <%=f_busqueda.ObtenerValor("pers_nrut")%>
						    -<%=f_busqueda.ObtenerValor("pers_xdv")%></td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						  </tr>
						  <tr>
						    <td>Monto asignado </td>
						    <td style="border: 1px solid black"><div align="right"><%=formatnumber(f_busqueda.ObtenerValor("fren_mmonto"),0)%></div></td> 
							<td > Descripcion Moneda </td>
							<td  style="border: 1px solid black">&nbsp;<%
							f_busqueda.AgregaCampoParam "tmon_ccod", "permiso", "ESCRITURA"
							f_busqueda.DibujaCampo("tmon_ccod")%></td>
						  </tr>
						</table>
						<p><strong>Datos Presupuesto</strong> <font color="#0033FF"><%=msg_oc%></font></p>
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
						<p><strong>Datos solicitante</strong></p>
                      <table width="100%" border="0">
                        <tr> 
                          <td align="center">
								<table width="100%" border="0">
									<tr> 
										<td width="16%" height="37">Solicitado por </td>
									  <td width="33%" style="border: 1px solid black">&nbsp;<%=f_datos_area.ObtenerValor("nombre_responsable")%></td>
									  <td width="16%">&nbsp;</td>
										<td width="35%" rowspan="3" align="center" valign="bottom"><img src="../imagenes/autorizado.png"  width="185" height="105"  ><br>_______________________<br>
									  Firma y Timbre solicitante</td>
									</tr>
									<tr> 
										<td width="16%" height="37">Generada por </td>
									  <td width="33%" colspan="1" style="border: 1px solid black"><%=Ucase(v_generador)%></td>
									</tr>
                                    <tr> 
										<td width="16%" height="37">Unidad Solicitante </td>
										<td colspan="2" style="border: 1px solid black"><%=f_datos_area.ObtenerValor("area_tdesc")%></td>
									</tr>
								</table>						  
						  </td>
                        </tr>
						
						<tr>
							<td>
						  </td>
						</tr>
                      </table>
					  <br/>
                      <table width="100%" border='1' cellpadding='0' cellspacing='0'>
                                        <tr>
                                          <th>Fecha Docto </th>
                                          <th>Tipo Docto </th>
                                          <th>N&deg;Docto</th>
                                          <th>Rut</th>
                                          <th>Tipo Gasto</th>
                                          <th>Descripcion Gasto</th>
                                          <th>Monto Bruto</th>
                                          <th>Retencion</th>
                                          <th>Monto Liquido</th>
                                        </tr>
                                        <%
								if f_detalle.nrofilas >=1 then
									ind=0
									v_total_rendido=0
									while f_detalle.Siguiente
									%>
                                        <tr>
                                          <td align="center"><%f_detalle.DibujaCampo("drfr_fdocto")%></td>
                                          <td align="center"><%f_detalle.DibujaCampo("tdoc_ccod")%>
                                            <%f_detalle.DibujaCampo("tipo_doc")%></td>
                                          <td align="center"><%f_detalle.DibujaCampo("drfr_ndocto")%></td>
                                          <td align="center"><%f_detalle.DibujaCampo("pers_nrut")%></td>
                                          <td align="center"><%f_detalle.DibujaCampo("tgas_ccod")%></td>
                                          <td align="center"><%f_detalle.DibujaCampo("drfr_tdesc")%></td>
                                          <td align="center"><%f_detalle.DibujaCampo("drfr_mdocto")%></td>
                                          <td align="center"><%f_detalle.DibujaCampo("drfr_mretencion")%></td>
                                          <%v_total_rendido=Clng(f_detalle.ObtenerValor("drfr_mdocto"))-Clng(f_detalle.ObtenerValor("drfr_mretencion"))
										rendicion= rendicion+v_total_rendido
										%>
                                          <td align="center"><%response.Write(v_total_rendido)%></td>
                                        </tr>
                                        <%'v_total_rendido=v_total_rendido+Clng(f_detalle.ObtenerValor("drfr_mdocto"))+Clng(f_detalle.ObtenerValor("drfr_mretencion"))
									ind=ind+1
									wend
								end if
								%>
                                        <tr>
                                          <th colspan="8" width="92%" align="right">Total Rendido</th>
                                          <td width="8%" align="right"><%=rendicion%></td>
                                        </tr>
                                        <tr>
                                          <th colspan="8" align="right">Monto solicitado</th>
                                          <td align="right"><%f_busqueda.dibujaCampo("fren_mmonto")%></td>
                                        </tr>
                                        <tr>
                                          <th colspan="8" align="right">Saldo</th>
                                          <%v_diferencia=Clng(f_busqueda.ObtenerValor("fren_mmonto"))-Clng(rendicion)%>
                                          <td align="right"><%=v_diferencia%></td>
                                        </tr><br><br><br>
                                        <tr>
                                          <td colspan="7"><strong>Detalle devolucion de dinero sobrante</strong><br/>
                                            <table align="center" width="100%" border='1' cellpadding='0' cellspacing='0'>
                                              <tr>
                                                <th >N° Comprobante</th>
                                                <th>Rut</th>
                                                <th>Fecha docto </th>
                                                <th>Descripcion devolucion</th>
                                                <th>Monto</th>
                                              </tr>
                                              <tr>
                                                <td ><%f_devolucion.DibujaCampo("dren_ncomprobante")%></td>
                                                <td><%f_devolucion.DibujaCampo("pers_nrut")%></td>
                                                <td><%f_devolucion.DibujaCampo("dren_fcomprobante")%></td>
                                                <td><%f_devolucion.DibujaCampo("dren_tglosa")%></td>
                                                <td><%f_devolucion.DibujaCampo("dren_mmonto")%></td>
                                              </tr>
                                            </table></td>
                                        </tr>
                                      </table>
					      	  </tr>			
                              
                              <tr>
									  <td colspan="4">
									  <hr>
											<h5>Detalle presupuesto para diferencia solicitada </h5>
			
											<table width="100%" class="v1" border='1' cellpadding='0' cellspacing='0'>
												<tr>
													<th width="50%">Cod. Presupuesto</th>
													<th width="12%">Mes</th>
													<th width="12%">Año</th>
													<th width="16%">Valor</th>
												</tr>
											<% ind=0
											f_presupuesto_devol.primero
											while f_presupuesto_devol.Siguiente 
											v_cod_pre=f_presupuesto_devol.ObtenerValor("cod_pre")
											%>
                                  <tr align="left" bgcolor="#FFFFFF">
                                    <td>
                                        <%
										f_cod_pre.primero
										while f_cod_pre.Siguiente 
											if Cstr(f_cod_pre.ObtenerValor("cod_pre"))=Cstr(v_cod_pre) then
												response.Write(f_cod_pre.ObtenerValor("valor"))
											end if
										wend
										%>                                    </td>
                                    <td><%f_presupuesto_devol.DibujaCampo("mes_ccod")%></td>
                                    <td><%f_presupuesto_devol.DibujaCampo("anos_ccod")%></td>
                                    <td><%f_presupuesto_devol.DibujaCampo("psol_mpresupuesto")%></td>
                                  </tr>
                                  <%
										ind=ind+1
										wend 
								  %>
										</table>
									</td>
							  </tr>					  
					</table>
                    <br>
                    <br>
					<table align="center" width="98%" border="0"  cellspacing="10">
						<tr>
							<td style="border: 1px solid black" valign="bottom" width="25%"><br><br><br>V°B° Presupuesto</td>
							<td style="border: 1px solid black" valign="bottom" width="25%"><br><br><br>V°B° Direccion de Finanzas</td>
							<td style="border: 1px solid black" valign="bottom" width="25%"><br><br><br>V°B° Vicerrector Adm. y Finanzas</td>
                            <td style="border: 1px solid black" valign="bottom" width="25%"><br><br><br>V°B° Rector</td>
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