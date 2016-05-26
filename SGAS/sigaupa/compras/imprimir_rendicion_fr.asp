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


if v_rfre_ncorr="" or EsVacio(v_rfre_ncorr) then
	v_rfre_ncorr=conectar.consultaUno("select top 1 rfre_ncorr from ocag_rendicion_fondos_a_rendir where fren_ncorr="&v_fren_ncorr)
end if

'**********************************************************
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "pago_proveedor.xml", "datos_proveedor"
f_busqueda.Inicializar conectar
	if v_fren_ncorr<>"" then

		sql_datos_solicitud	= " select ocag_generador,year(ocag_fingreso) as anio,protic.trunc(ocag_fingreso) as ocag_fingreso,protic.trunc(fren_factividad) as fren_factividad, a.* "&_
								" , LTRIM(RTRIM(c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO)) as v_nombre "&_
								" , LTRIM(RTRIM(c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO)) as PERS_TNOMBRE "&_	
								" , cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, d.pers_tnombre as pers_tnombre_aut, d.pers_xdv  as pers_xdv_aut   "&_
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

'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
v_pers_tnombre = f_busqueda.obtenerValor("pers_tnombre")
v_rut=f_busqueda.obtenerValor("pers_nrut")
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

'set f_presupuesto = new CFormulario
' 	f_presupuesto.Carga_Parametros "datos_presupuesto.xml", "detalle_presupuesto"
' 	f_presupuesto.Inicializar conectar
'	sql_presupuesto="select * from ocag_presupuesto_solicitud where cast(cod_solicitud as varchar)='"&v_fren_ncorr&"' and tsol_ccod=3 and isnull(psol_brendicion,'N') ='S'"
'	f_presupuesto.consultar sql_presupuesto	
'	filas_presu= f_presupuesto.nrofilas
	

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

v_pers_nrut=f_busqueda.ObtenerValor("ocag_generador")

v_generador=conectar.consultaUno("select protic.obtener_nombre_completo(pers_ncorr,'n') as generador from personas where cast(pers_nrut as varchar)='"&v_pers_nrut&"'")
'*****************************************************************************************
'***************	FIN listas de seleccion para filas de tabla dinamica	**************

set f_detalle = new CFormulario
f_detalle.Carga_Parametros "rendicion_fondo_fijo.xml", "detalle_rendicion"
f_detalle.Inicializar conectar

if v_rfre_ncorr<>"" then
'response.Write("<hr>"&ajajaja&"<hr>")
	sql_detalle_pago= "select isnull(drfr_mretencion,0) as drfr_mretencion,protic.trunc(drfr_fdocto) as drfr_fdocto,* from ocag_detalle_rendicion_fondo_rendir where rfre_ncorr ="&v_rfre_ncorr
else
	sql_detalle_pago= "select 0 as drfr_mdocto, 0 as drfr_mretencion "
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
							<p><strong>Anexo detalle por Rendicion</strong></p>
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
										<td style="border: 1px solid black" align="center">&nbsp;<%=f_detalle.ObtenerValor("tgas_ccod")%></td>
										<td style="border: 1px solid black" align="center">&nbsp;<%=f_detalle.ObtenerValor("drfr_fdocto")%></td>
										<td style="border: 1px solid black" align="center">&nbsp;<%
										f_detalle.AgregaCampoParam "tdoc_ccod", "permiso", "ESCRITURA"
										f_detalle.DibujaCampo("tdoc_ccod")%> </td>
										<td style="border: 1px solid black" align="center">&nbsp;<%=f_detalle.ObtenerValor("drfr_ndocto")%> </td>
										<td style="border: 1px solid black" align="center">&nbsp;<%=f_detalle.ObtenerValor("drfr_trut")%> </td>
										<td style="border: 1px solid black" align="center">&nbsp;<%=f_detalle.ObtenerValor("drfr_mretencion")%> </td>
										<td style="border: 1px solid black" align="center">&nbsp;<%=f_detalle.ObtenerValor("drfr_mdocto")%> </td>
									</tr>	
									<%
									v_total_rendido=clng(v_total_rendido)+clng(f_detalle.ObtenerValor("drfr_mdocto"))
									
									ind=ind+1
									wend
								end if
								%>	
							<tr>
								<th colspan="5"></th>
								<td align="right">Total Rendido</td>
								<td style="border: 1px solid black" align="right">&nbsp;<%=formatnumber(v_total_rendido,0)%></td>
							</tr>
							<tr>
								<th colspan="5"></th>
								<td align="right">Monto Asignado</td>
								<td style="border: 1px solid black" align="right">&nbsp;<%=formatnumber(f_busqueda.ObtenerValor("fren_mmonto"),0)%></td>
							</tr>	
							<tr>
								<th colspan="5"></th>
								<td align="right">Monto a Girar</td>
								<td style="border: 1px solid black" align="right">&nbsp;<%=formatnumber(Clng(v_total_rendido-Clng(f_busqueda.ObtenerValor("fren_mmonto"))),0)%></td>
							</tr>																																			
						</table>
						
					<p><strong>Identificacion del fondo</strong></p>
                      <table width="100%" border="0">
                        <tr> 
                          <td align="center">
								<table width="100%" border="0">
									<tr> 
										<td>N°Fondo</td>
										<td>Fecha Solicitud</td>
										<td>Fecha Actividad</td>
										<td>Rut solicitud</td>
										<td>Nombre solicitante</td>
									</tr>
									<tr> 
										<td style="border: 1px solid black">&nbsp;<%=f_busqueda.ObtenerValor("fren_ncorr")%></td>
										<td style="border: 1px solid black">&nbsp;<%=f_busqueda.ObtenerValor("ocag_fingreso")%></td>
										<td style="border: 1px solid black">&nbsp;<%=f_busqueda.ObtenerValor("fren_factividad")%></td>
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
										<td width="30%" rowspan="2" align="center" valign="bottom"><img src="../imagenes/autorizado.png" width="185" height="105" ><br>_______________________<br>
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