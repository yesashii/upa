<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%


v_rgas_ncorr= request.querystring("rgas_ncorr")

set pagina = new CPagina
pagina.Titulo = "Reembolso de gastos y rendicion N° "&v_rgas_ncorr
'**********************************************************
set botonera = new CFormulario
botonera.carga_parametros "reembolso_gasto.xml", "botonera"

set conectar = new cconexion
conectar.inicializar "upacifico"

set conexion = new Cconexion2
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

v_usuario 	= negocio.ObtenerUsuario()
sede		= negocio.obtenerSede
v_anos_ccod	= conectar.consultaUno("select year(getdate())")
fecha_actual= conectar.consultaUno("select protic.trunc(getDate())")


'**********************************************************
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "pago_proveedor.xml", "datos_proveedor"
f_busqueda.Inicializar conectar
	if v_rgas_ncorr<>"" then

		sql_datos_solicitud="select protic.trunc(a.ocag_fingreso) as ocag_fingreso "&_
								" , a.rgas_ncorr, a.rgas_mgiro, a.pers_ncorr_proveedor, a.rgas_fpago, a.tmon_ccod, a.mes_ccod, a.anos_ccod, a.cod_pre, a.vibo_ccod, a.audi_tusuario "&_
								" , a.audi_fmodificacion, a.rgas_frecepcion, a.rgas_tobs_rechazo, a.tsol_ccod, a.area_ccod, a.ocag_generador, a.ocag_frecepcion_presupuesto, a.ocag_responsable "&_
								" , a.ocag_baprueba, a.sede_ccod, a.cod_solicitud_origen, a.ocag_baprueba_rector "&_
								" , c.PERS_NCORR, c.PERS_NRUT, c.PERS_XDV "&_
								" , LTRIM(RTRIM(c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO)) as v_nombre "&_
								" , LTRIM(RTRIM(c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO)) as PERS_TNOMBRE "&_	
							" from ocag_reembolso_gastos a, personas c "&_
						    " where a.pers_ncorr_proveedor=c.pers_ncorr and a.rgas_ncorr="&v_rgas_ncorr		
							
	else
		sql_datos_solicitud="select ''"
	end if
	
	'response.write("sql_datos_solicitud: "&sql_datos_solicitud&"<br>")
	
f_busqueda.Consultar sql_datos_solicitud
f_busqueda.Siguiente

	mmonto= f_busqueda.obtenervalor("rgas_mgiro")
	mnonto=FormatCurrency(mmonto,0)

if area_ccod="" then
	area_ccod= f_busqueda.ObtenerValor("area_ccod")
end if

'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
v_pers_tnombre = f_busqueda.obtenerValor("pers_tnombre")
v_rut=f_busqueda.obtenerValor("pers_nrut")

'response.write("v_pers_tnombre: "&v_pers_tnombre&"<br>")
	'8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
	'88 INICIO
	
	if v_pers_tnombre="" then
	
	set f_personas2 = new CFormulario
	f_personas2.carga_parametros "tabla_vacia.xml", "tabla_vacia"
	f_personas2.inicializar conexion

	sql_datos_persona= " select CODAUX AS pers_nrut, RIGHT(RUTAUX,1) AS pers_xdv, NOMAUX AS pers_tnombre, NOMAUX AS v_nombre "&_
											" from softland.cwtauxi where cast(CodAux as varchar)='"&v_rut&"'"
	
	f_personas2.consultar sql_datos_persona
	f_personas2.Siguiente
						
	v_pers_tnombre = f_personas2.obtenerValor("pers_tnombre")
						
	f_busqueda.AgregaCampoCons "pers_tnombre", f_personas2.obtenerValor("pers_tnombre")
	
	end if
	'88 FIN
	'8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
	
'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

 set f_presupuesto = new CFormulario
 	f_presupuesto.Carga_Parametros "datos_presupuesto.xml", "detalle_presupuesto"
 	f_presupuesto.Inicializar conectar
	sql_presupuesto="select * from ocag_presupuesto_solicitud where cast(cod_solicitud as varchar)='"&v_rgas_ncorr&"' and tsol_ccod=2"
	f_presupuesto.consultar sql_presupuesto	
	filas_presu= f_presupuesto.nrofilas
	
 set f_detalle = new CFormulario
 	f_detalle.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
 	f_detalle.Inicializar conectar

' 	sql_detalle="select ccos_ncorr,tgas_tdesc,convert(date,drga_fdocto,103)as drga_fdocto,drga_ndocto, drga_mretencion, drga_mdocto, tdoc_tdesc,drga_tdescripcion " &_
'"from ocag_detalle_reembolso_gasto org,ocag_tipo_gasto ot ,ocag_tipo_documento od " &_
'"where org.tgas_ccod = ot.tgas_ccod " &_
'"and org.tdoc_ccod = od.tdoc_ccod " &_
'"and cast(rgas_ncorr as varchar)='"&v_rgas_ncorr&"'"

 	sql_detalle="select ccos_ncorr, tgas_tdesc,convert(date,drga_fdocto,103)as drga_fdocto, drga_ndocto " &_
						" , ISNULL(drga_mafecto,0)  AS drga_mafecto, ISNULL(drga_miva,0) AS drga_miva, ISNULL(drga_mexento, 0) AS drga_mexento " &_
						" , ISNULL(drga_mhonorarios,0) AS drga_mhonorarios, ISNULL(drga_mretencion,0) AS drga_mretencion, ISNULL(drga_mdocto,0) AS drga_mdocto " &_
						" , ISNULL(drga_bboleta_honorario,0) AS drga_bboleta_honorario " &_
						" , tdoc_tdesc, drga_tdescripcion  " &_
						" from ocag_detalle_reembolso_gasto org,ocag_tipo_gasto ot ,ocag_tipo_documento od  " &_
						" where org.tgas_ccod = ot.tgas_ccod  " &_
						" and org.tdoc_ccod = od.tdoc_ccod  " &_
						" and cast(rgas_ncorr as varchar)='"&v_rgas_ncorr&"'"
	
	f_detalle.agregaCampoParam "ccos_ncorr","filtro", "pers_nrut="&v_usuario
	f_detalle.consultar sql_detalle
	filas_detalle= f_detalle.nrofilas
	

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

f_cod_pre.agregaCampoParam "cod_pre","destino", sql_codigo_pre
f_cod_pre.consultar sql_codigo_pre
f_cod_pre.Siguiente


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

v_generador=conectar.consultaUno("select protic.obtener_nombre_completo(pers_ncorr,'n') as generador from personas where pers_nrut="&f_busqueda.ObtenerValor("audi_tusuario"))
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
					<tr><td align="left">Fecha de impresión:</td><td style="border: 1px solid black">&nbsp;<%=fecha_actual%></td>
					</tr>
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
						    <td style="border: 1px solid black" width="35%"><%=f_busqueda.ObtenerValor("pers_tnombre")%> </td> 
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
						    <td>Monto a Girar </td>
						    <td align="right" style="border: 1px solid black"><%=mnonto%></td> 
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
							<br/>
							<p><strong>Identificacion de gastos</strong></p>
								
                                <table width="100%" border='0' cellpadding='1' cellspacing='1' >
									<tr>
										<th width="10%">Tipo Documento</th>
										<th width="10%">Fecha Docto</th>
										<th width="10%">N° Docto</th>
										<th width="10%">Tipo Gasto</th>
										<th width="10%">Descripcion Gasto</th>
										<th width="10%">Neto</th>
										<th width="10%">Iva</th>
										<th width="10%">Exento</th>
										<th width="10%">Honorarios</th>
										<th width="10%">Retencion</th>
										<th width="10%">Líquido</th>

									</tr>
									<%if f_detalle.nrofilas >=1 then
											ind=0
											v_totalizado=0
											while f_detalle.Siguiente%>
											<tr>

												<td style="border: 1px solid black"><%f_detalle.DibujaCampo("tdoc_tdesc") %></td>
												<td style="border: 1px solid black"><%f_detalle.DibujaCampo("drga_fdocto") %></td>
												<td style="border: 1px solid black"><%f_detalle.DibujaCampo("drga_ndocto")%> </td>
												<td style="border: 1px solid black"><%f_detalle.DibujaCampo("tgas_tdesc")%> </td>
												<td style="border: 1px solid black"><%f_detalle.DibujaCampo("drga_tdescripcion")%> </td>
                                                <td style="border: 1px solid black"><%f_detalle.DibujaCampo("drga_mafecto") %></td>
                                                <td style="border: 1px solid black"><%f_detalle.DibujaCampo("drga_miva") %></td>
                                                <td style="border: 1px solid black"><%f_detalle.DibujaCampo("drga_mexento") %></td>
                                                <td style="border: 1px solid black"><%f_detalle.DibujaCampo("drga_mhonorarios") %></td>
                                                <td style="border: 1px solid black"><%f_detalle.DibujaCampo("drga_mretencion") %></td>
                                                <td style="border: 1px solid black"><%f_detalle.DibujaCampo("drga_mdocto") %></td>
											</tr>	
											<%
											V_BOLETA=f_detalle.ObtenerValor("drga_bboleta_honorario")
											'RESPONSE.WRITE(V_BOLETA)
											if cstr(V_BOLETA)=cstr(1) then
												v_drga_mhonorarios=v_drga_mhonorarios+clng(f_detalle.ObtenerValor("drga_mhonorarios"))
											end if

											if cstr(V_BOLETA)=cstr(2) then
												v_drga_mdocto=v_drga_mdocto+clng(f_detalle.ObtenerValor("drga_mdocto"))
											end if

											ind=ind+1
											wend
											v_totalizado=v_drga_mhonorarios+v_drga_mdocto
										end if%>
									<tr>
										<th colspan="10" align="right">Total Gastos</th>
										<td width="13%" style="border: 1px solid black"><%=v_totalizado%></td>
									</tr>
								</table>
					  <br/>
					<table align="center" width="100%" border="0"  cellspacing="10">
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