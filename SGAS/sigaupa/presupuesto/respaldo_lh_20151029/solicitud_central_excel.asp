<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "presupuesto/funciones/funciones.asp" -->

<%
Server.ScriptTimeout = 3000 
Response.AddHeader "Content-Disposition", "attachment;filename=solicitud_centralizada.xls"
Response.ContentType = "application/vnd.ms-excel"

set pagina = new CPagina
pagina.Titulo = "Ejecucion Presupuestaria"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set conexion2 = new CConexion2
conexion2.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
v_usuario = negocio.ObtenerUsuario()
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "ejecucion_presupuestaria.xml", "botonera"
'-----------------------------------------------------------------------
 
v_prox_anio = request.querystring("anio")
nro_t		= request.querystring("nro")
area_ccod	= request.querystring("area") 

set f_solicitado = new CFormulario
f_solicitado.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
f_solicitado.Inicializar conexion2


set f_aprobados = new CFormulario
f_aprobados.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
f_aprobados.Inicializar conexion2
 
if nro_t="" then
	nro_t=1
end if

select case (nro_t)
	case 1: ' Audiovisual		
	
		sql_solicitud="select *,nombremes, case a.esol_ccod when 1 then 'Anular' when 3 then 'Dejar Pendiente' when 4 then 'Ver motivo' else 'Estado Final' end as accion "& vbCrLf &_
							" from presupuesto_upa.protic.centralizar_solicitud_audiovisual a, presupuesto_upa.protic.concepto_centralizado b,presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d "& vbCrLf &_
							"	where a.tpre_ccod in (1) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
							"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
							"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
							"	and isnull(mes_ccod,1)=d.indice "& vbCrLf &_
							" 	and a.esol_ccod not in (2,3) "& vbCrLf &_
							"	and area_ccod="&area_ccod&" and anio_ccod="&v_prox_anio
					
		sql_aprobadas="select * "& vbCrLf &_
							" from presupuesto_upa.protic.centralizar_solicitud_audiovisual a, presupuesto_upa.protic.concepto_centralizado b,presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d "& vbCrLf &_
							"	where a.tpre_ccod in (1) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
							"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
							"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
							"	and isnull(mes_ccod,1)=d.indice "& vbCrLf &_
							" 	and a.esol_ccod in (2) "& vbCrLf &_
							"	and area_ccod="&area_ccod&" and anio_ccod="&v_prox_anio
											
	case 2: ' Biblioteca
		sql_solicitud="select * "& vbCrLf &_
					" from presupuesto_upa.protic.centralizar_solicitud_biblioteca a, presupuesto_upa.protic.concepto_centralizado b,presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d "& vbCrLf &_
					"	where a.tpre_ccod in (2) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
					"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
					"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
					"	and isnull(mes_ccod,1)=d.indice "& vbCrLf &_
					" 	and a.esol_ccod not in (2) "& vbCrLf &_
					"	and area_ccod="&area_ccod&" and anio_ccod="&v_prox_anio
		
		sql_aprobadas="select * "& vbCrLf &_
					" from presupuesto_upa.protic.centralizar_solicitud_biblioteca a, presupuesto_upa.protic.concepto_centralizado b,presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d "& vbCrLf &_
					"	where a.tpre_ccod in (2) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
					"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
					"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
					"	and isnull(mes_ccod,1)=d.indice "& vbCrLf &_
					" 	and a.esol_ccod in (2) "& vbCrLf &_
					"	and area_ccod="&area_ccod&" and anio_ccod="&v_prox_anio		
						
	case 3: ' Computacion
		sql_solicitud="select * "& vbCrLf &_
					" from presupuesto_upa.protic.centralizar_solicitud_computacion a, presupuesto_upa.protic.concepto_centralizado b,presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d "& vbCrLf &_
					"	where a.tpre_ccod in (3) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
					"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
					"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
					"	and isnull(mes_ccod,1)=d.indice "& vbCrLf &_
					" 	and a.esol_ccod not in (2) "& vbCrLf &_
					"	and area_ccod="&area_ccod&" and anio_ccod="&v_prox_anio

		sql_aprobadas="select * "& vbCrLf &_
					" from presupuesto_upa.protic.centralizar_solicitud_computacion a, presupuesto_upa.protic.concepto_centralizado b,presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d "& vbCrLf &_
					"	where a.tpre_ccod in (3) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
					"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
					"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
					"	and isnull(mes_ccod,1)=d.indice "& vbCrLf &_
					" 	and a.esol_ccod in (2) "& vbCrLf &_
					"	and area_ccod="&area_ccod&" and anio_ccod="&v_prox_anio		

					
	case 4: ' Servicios Generales
		sql_solicitud="select * "& vbCrLf &_
					" from presupuesto_upa.protic.centralizar_solicitud_servicios_generales a, presupuesto_upa.protic.concepto_centralizado b,presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d "& vbCrLf &_ 
					"	where a.tpre_ccod in (4) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
					"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
					"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
					"	and isnull(mes_ccod,1)=d.indice "& vbCrLf &_
					" 	and a.esol_ccod not in (2) "& vbCrLf &_
					"	and area_ccod="&area_ccod&" and anio_ccod="&v_prox_anio

		sql_aprobadas="select * "& vbCrLf &_
					" from presupuesto_upa.protic.centralizar_solicitud_servicios_generales a, presupuesto_upa.protic.concepto_centralizado b,presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d "& vbCrLf &_
					"	where a.tpre_ccod in (4) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
					"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
					"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
					"	and isnull(mes_ccod,1)=d.indice "& vbCrLf &_
					" 	and a.esol_ccod in (2) "& vbCrLf &_
					"	and area_ccod="&area_ccod&" and anio_ccod="&v_prox_anio		
					
	case 5: 'REcursos Humanos
		sql_solicitud="select * "& vbCrLf &_
					" from presupuesto_upa.protic.centralizar_solicitud_personal a, presupuesto_upa.protic.concepto_centralizado b,presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d  "& vbCrLf &_
					"	where a.tpre_ccod in (5) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
					"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
					"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
					"	and isnull(mes_ccod,1)=d.indice "& vbCrLf &_
					"	and area_ccod="&area_ccod&" and anio_ccod="&v_prox_anio

		sql_aprobadas="select * "& vbCrLf &_
					" from presupuesto_upa.protic.centralizar_solicitud_personal a, presupuesto_upa.protic.concepto_centralizado b,presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d "& vbCrLf &_
					"	where a.tpre_ccod in (5) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
					"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
					"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
					"	and isnull(mes_ccod,1)=d.indice "& vbCrLf &_
					" 	and a.esol_ccod in (2) "& vbCrLf &_
					" 	and a.esol_ccod not in (2) "& vbCrLf &_
					"	and area_ccod="&area_ccod&" and anio_ccod="&v_prox_anio		
case 6:
			sql_solicitud="select *,nombremes, case a.esol_ccod when 1 then 'Anular' when 3 then 'Dejar Pendiente' when 4 then 'Ver motivo' else 'Estado Final' end as accion "& vbCrLf &_
							" from presupuesto_upa.protic.centralizar_solicitud_dir_docencia a, presupuesto_upa.protic.concepto_centralizado b,presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d "& vbCrLf &_
							"	where a.tpre_ccod in (6) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
							"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
							"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
							"	and isnull(mes_ccod,1)=d.indice "& vbCrLf &_
							"	and area_ccod="&area_ccod&" and anio_ccod="&v_prox_anio
						
			sql_aprobadas="select * "& vbCrLf &_
							" from presupuesto_upa.protic.centralizar_solicitud_dir_docencia a, presupuesto_upa.protic.concepto_centralizado b,presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d "& vbCrLf &_
							"	where a.tpre_ccod in (6) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
							"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
							"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
							"	and isnull(mes_ccod,1)=d.indice "& vbCrLf &_
							" 	and a.esol_ccod in (2) "& vbCrLf &_
							"	and area_ccod="&area_ccod&" and anio_ccod="&v_prox_anio				

end select	

'response.Write("<pre>"&sql_solicitud&"</pre>")

f_solicitado.consultar sql_solicitud
f_aprobados.consultar sql_aprobadas

%>
<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >

							<% 
							select case (nro_t)
							case 1:
							%>
								<font>Anexo N°5.1: Requerimientos Audiovisuales</font>
								<br/><br/>
								<font>Solicitudes Pendientes</font><br/>							
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripción</th>
									  <th width="51%">Eje</th>
									  <th width="51%">Proyecto</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="9%">Valor Apox.</th>
									  <th width="9%">Tipo presupuesto</th>
									  <th width="18%">Estado</th>
									</tr>
									<%
									while f_solicitado.Siguiente
									'----------------------------------------------
									v_neje 			= f_solicitado.ObtenerValor("eje_ccod")
									v_nproyecto 	= f_solicitado.ObtenerValor("proye_ccod")
									v_nTPresu		= f_solicitado.ObtenerValor("t_presupuesto")
									v_TPresu		= ""
									if(v_nTPresu = "1") then v_TPresu = "Primario" end if
									if(v_nTPresu = "2") then v_TPresu = "Secundario" end if
									v_eje			= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
									v_proyecto		= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
									'cadenaTabla()
									va_neje 		= f_aprobados.ObtenerValor("eje_ccod")
									va_nproyecto 	= f_aprobados.ObtenerValor("proye_ccod")
									va_nTPresu		= f_aprobados.ObtenerValor("t_presupuesto")
									va_TPresu		= ""
									if(va_nTPresu = "1") then va_TPresu = "Primario" end if
									if(va_nTPresu = "2") then va_TPresu = "Secundario" end if
									va_eje			= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
									va_proyecto		= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
									'----------------------------------------------									
									%>
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><%f_solicitado.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_solicitado.DibujaCampo("ccau_tdesc")%></td>
									  <td><%=cadenaTablaExcel(v_eje)%></td>
									  <td><%=cadenaTablaExcel(v_proyecto)%></td>
									  <td><%=f_solicitado.DibujaCampo("nombremes")%></td>
									  <td><%=f_solicitado.DibujaCampo("ccau_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("v_aprox")%></td>
									  <td><%=v_TPresu%></td>
									  <td><%=f_solicitado.DibujaCampo("esol_tdesc")%></td>
									</tr>
									 <%
									 wend%>
									 <%if f_solicitado.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="10" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
									 <% end if%>
								</table>
								<br/>
								<font>Solicitudes aceptadas</font>
								<br/><br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripción</th>
									  <th width="51%">Eje</th>
									  <th width="51%">Proyecto</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="9%">Valor Apox.</th>
									  <th width="9%">Tipo presupuesto</th>
									  <th width="18%">Estado</th>
									</tr>
									<%
									while f_aprobados.Siguiente
									%>
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><%f_aprobados.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_aprobados.DibujaCampo("ccau_tdesc")%></td>
									  <td><%=cadenaTablaExcel(va_eje)%></td>
									  <td><%=cadenaTablaExcel(va_proyecto)%></td>
									  <td><%=f_aprobados.DibujaCampo("nombremes")%></td>
									  <td><%=f_aprobados.DibujaCampo("ccau_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("v_aprox")%></td>
									  <td><%=v_TPresu%></td>
									  <td><%=f_aprobados.DibujaCampo("esol_tdesc")%></td>
									</tr>
									 <%wend%>
									 <%if f_aprobados.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="9" align="center">No se encontraron solicitudes aprobadas </td></tr>
									 <% end if%>
								</table>
							<%case 2%>
								<br/>
								<font>Anexo N°4: Material Bibliográfico</font><br/>
								<font>Solicitudes Pendientes</font><br/>	
<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripción</th>
									<th width="51%">Eje</th>	
									<th width="51%">Proyecto</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									<th width="9%">Valor Apox.</th>
									<th width="9%">Tipo presupuesto</th>
									  <th width="18%">Estado</th>
									</tr>
									<%
									while f_solicitado.Siguiente
									'----------------------------------------------
									v_neje 			= f_solicitado.ObtenerValor("eje_ccod")
									v_nproyecto 	= f_solicitado.ObtenerValor("proye_ccod")
									v_nTPresu		= f_solicitado.ObtenerValor("t_presupuesto")
									v_TPresu		= ""
									if(v_nTPresu = "1") then v_TPresu = "Primario" end if
									if(v_nTPresu = "2") then v_TPresu = "Secundario" end if
									v_eje			= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
									v_proyecto		= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
									'cadenaTabla()
									va_neje 		= f_aprobados.ObtenerValor("eje_ccod")
									va_nproyecto 	= f_aprobados.ObtenerValor("proye_ccod")
									va_nTPresu		= f_aprobados.ObtenerValor("t_presupuesto")
									va_TPresu		= ""
									if(va_nTPresu = "1") then va_TPresu = "Primario" end if
									if(va_nTPresu = "2") then va_TPresu = "Secundario" end if
									va_eje			= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
									va_proyecto		= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
									'----------------------------------------------		
									%>
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><%f_solicitado.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_solicitado.DibujaCampo("ccbi_tdesc")%></td>
									  <td><%=cadenaTablaExcel(v_eje)%></td>
									  <td><%=cadenaTablaExcel(v_proyecto)%></td>
									  <td><%=f_solicitado.DibujaCampo("nombremes")%></td>
									  <td><%=f_solicitado.DibujaCampo("ccbi_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("v_aprox")%></td>
									  <td><%=v_TPresu%></td>
									  <td><%=f_solicitado.DibujaCampo("esol_tdesc")%></td>
									  </tr>
									 <%wend%>
									 <%if f_solicitado.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="10" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
									 <% end if%>
								</table>
								<br/>
								<font>Solicitudes aceptadas</font>
								<br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripcion</th>
									  <th width="51%">Eje</th>
									  <th width="51%">Proyecto</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="9%">Valor Apox.</th>
									  <th width="9%">Tipo presupuesto</th>
									  <th width="18%">Estado</th>
									</tr>
									<%
									while f_aprobados.Siguiente
									%>
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><%f_aprobados.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_aprobados.DibujaCampo("ccbi_tdesc")%></td>
									  <td><%=cadenaTablaExcel(va_eje)%></td>
									  <td><%=cadenaTablaExcel(va_proyecto)%></td>
									  <td><%=f_aprobados.DibujaCampo("nombremes")%></td>
									  <td><%=f_aprobados.DibujaCampo("ccbi_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("v_aprox")%></td>
									  <td><%=v_TPresu%></td>
									  <td><%=f_aprobados.DibujaCampo("esol_tdesc")%></td>
									</tr>
									 <%wend%>
									 <%if f_aprobados.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="9" align="center">No se encontraron solicitudes aprobadas </td></tr>
									 <% end if%>
								</table>
																
							<%case 3:%>
								<br/>
								<font>Anexo N°5: Requerimientos Computacionales</font><br/>
								<font>Solicitudes Pendientes</font><br/>
							<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripción</th>
									<th width="51%">Eje</th>	
									<th width="51%">Proyecto</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									<th width="9%">Valor Apox.</th>
									<th width="9%">Tipo presupuesto</th>
									  <th width="18%">Estado</th>
									</tr>
									<%
									while f_solicitado.Siguiente
									'----------------------------------------------
									v_neje 			= f_solicitado.ObtenerValor("eje_ccod")
									v_nproyecto 	= f_solicitado.ObtenerValor("proye_ccod")
									v_nTPresu		= f_solicitado.ObtenerValor("t_presupuesto")
									v_TPresu		= ""
									if(v_nTPresu = "1") then v_TPresu = "Primario" end if
									if(v_nTPresu = "2") then v_TPresu = "Secundario" end if
									v_eje			= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
									v_proyecto		= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
									'cadenaTabla()
									va_neje 		= f_aprobados.ObtenerValor("eje_ccod")
									va_nproyecto 	= f_aprobados.ObtenerValor("proye_ccod")
									va_nTPresu		= f_aprobados.ObtenerValor("t_presupuesto")
									va_TPresu		= ""
									if(va_nTPresu = "1") then va_TPresu = "Primario" end if
									if(va_nTPresu = "2") then va_TPresu = "Secundario" end if
									va_eje			= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
									va_proyecto		= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
									'----------------------------------------------		
									%>
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><%f_solicitado.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_solicitado.DibujaCampo("ccco_tdesc")%></td>
									  <td><%=cadenaTablaExcel(v_eje)%></td>
									  <td><%=cadenaTablaExcel(v_proyecto)%></td>
									  <td><%=f_solicitado.DibujaCampo("nombremes")%></td>
									  <td><%=f_solicitado.DibujaCampo("ccco_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("v_aprox")%></td>
									  <td><%=v_TPresu%></td>
									  <td><%=f_solicitado.DibujaCampo("esol_tdesc")%></td>
									  </tr>
									 <%wend%>
									 <%if f_solicitado.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="10" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
									 <% end if%>
								</table>											
								<br/>
								<font>Solicitudes aceptadas</font>
								<br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripcion</th>
									  <th width="51%">Eje</th>
									  <th width="51%">Proyecto</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="9%">Valor Apox.</th>
									  <th width="9%">Tipo presupuesto</th>
									  <th width="18%">Estado</th>
									</tr>
									<%
									while f_aprobados.Siguiente
									%>
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><%f_aprobados.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_aprobados.DibujaCampo("ccco_tdesc")%></td>
									  <td><%=cadenaTablaExcel(va_eje)%></td>
									  <td><%=cadenaTablaExcel(va_proyecto)%></td>
									  <td><%=f_aprobados.DibujaCampo("nombremes")%></td>
									  <td><%=f_aprobados.DibujaCampo("ccco_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("v_aprox")%></td>
									  <td><%=v_TPresu%></td>
									  <td><%=f_aprobados.DibujaCampo("esol_tdesc")%></td>
									</tr>
									 <%wend%>
									 <%if f_aprobados.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="9" align="center">No se encontraron solicitudes aprobadas </td></tr>
									 <% end if%>
								</table>						
							<%case 4:%>
								<br/>
								<font>Anexo N°4: Requerimientos Reparaciones, Equipos Mobiliarios</font>
								<br/><br/>
								<font>Solicitudes Pendientes</font><br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripción</th>
									  <th width="51%">Eje</th>
									  <th width="51%">Proyecto</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Sede</th>
									  <th width="9%">Cantidad</th>
									  <th width="9%">Valor Apox.</th>
									  <th width="9%">Tipo presupuesto</th>
									  <th width="18%">Estado</th>
									</tr>
									<%
									while f_solicitado.Siguiente
									'----------------------------------------------
									v_neje 			= f_solicitado.ObtenerValor("eje_ccod")
									v_nproyecto 	= f_solicitado.ObtenerValor("proye_ccod")
									v_nTPresu		= f_solicitado.ObtenerValor("t_presupuesto")
									v_TPresu		= ""
									if(v_nTPresu = "1") then v_TPresu = "Primario" end if
									if(v_nTPresu = "2") then v_TPresu = "Secundario" end if
									v_eje			= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
									v_proyecto		= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
									'cadenaTabla()
									va_neje 		= f_aprobados.ObtenerValor("eje_ccod")
									va_nproyecto 	= f_aprobados.ObtenerValor("proye_ccod")
									va_nTPresu		= f_aprobados.ObtenerValor("t_presupuesto")
									va_TPresu		= ""
									if(va_nTPresu = "1") then va_TPresu = "Primario" end if
									if(va_nTPresu = "2") then va_TPresu = "Secundario" end if
									va_eje			= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
									va_proyecto		= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
									'----------------------------------------------		
									%>
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><%f_solicitado.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_solicitado.DibujaCampo("ccsg_tdesc")%></td>
									  <td><%=cadenaTablaExcel(v_eje)%></td>
									  <td><%=cadenaTablaExcel(v_proyecto)%></td>
									  <td><%=f_solicitado.DibujaCampo("nombremes")%></td>
									  <td><%=f_solicitado.DibujaCampo("sede")%></td>
									  <td><%=f_solicitado.DibujaCampo("ccsg_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("v_aprox")%></td>
									  <td><%=v_TPresu%></td>
									  <td><%=f_solicitado.DibujaCampo("esol_tdesc")%></td>
									  </tr>


									 <%wend%>
									 <%if f_solicitado.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="11" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
									 <% end if%>
								</table>
								<br/>
								<font>Solicitudes aceptadas</font>
								<br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripción</th>
									  <th width="51%">Eje</th>
									  <th width="51%">Proyecto</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Sede</th>
									  <th width="9%">Cantidad</th>
									  <th width="9%">Valor Apox.</th>
									  <th width="9%">Tipo presupuesto</th>
									  <th width="18%">Estado</th>
									</tr>
									<%
									while f_aprobados.Siguiente
									%>
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><%f_aprobados.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_aprobados.DibujaCampo("ccsg_tdesc")%></td>
									  <td><%=cadenaTablaExcel(va_eje)%></td>
									  <td><%=cadenaTablaExcel(va_proyecto)%></td>
									  <td><%=f_aprobados.DibujaCampo("nombremes")%></td>
									   <td><%=f_aprobados.DibujaCampo("sede")%></td>
									  <td><%=f_aprobados.DibujaCampo("ccsg_ncantidad")%></td>
									  <td><%=f_aprobados.DibujaCampo("v_aprox")%></td>
									  <td><%=v_TPresu%></td>
									  <td><%=f_aprobados.DibujaCampo("esol_tdesc")%></td>
									</tr>
									 <%wend%>
									 <%if f_aprobados.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="10" align="center">No se encontraron solicitudes aprobadas </td></tr>
									 <% end if%>
								</table>																			
							<%case 5:%>
							<br/>
							<font>Anexo N°:5 Requerimientos de Personal</font>
							<br/><br/>
								<font>Solicitudes Pendientes</font><br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripción</th>
									  <th width="51%">Eje</th>
									  <th width="51%">Proyecto</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="9%">Valor Apox.</th>
									  <th width="9%">Tipo presupuesto</th>
									  <th width="18%">Estado</th>									  
									</tr>
									<%
									while f_solicitado.Siguiente
									'----------------------------------------------
									v_neje 			= f_solicitado.ObtenerValor("eje_ccod")
									v_nproyecto 	= f_solicitado.ObtenerValor("proye_ccod")
									v_nTPresu		= f_solicitado.ObtenerValor("t_presupuesto")
									v_TPresu		= ""
									if(v_nTPresu = "1") then v_TPresu = "Primario" end if
									if(v_nTPresu = "2") then v_TPresu = "Secundario" end if
									v_eje			= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
									v_proyecto		= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
									'cadenaTabla()
									va_neje 		= f_aprobados.ObtenerValor("eje_ccod")
									va_nproyecto 	= f_aprobados.ObtenerValor("proye_ccod")
									va_nTPresu		= f_aprobados.ObtenerValor("t_presupuesto")
									va_TPresu		= ""
									if(va_nTPresu = "1") then va_TPresu = "Primario" end if
									if(va_nTPresu = "2") then va_TPresu = "Secundario" end if
									va_eje			= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
									va_proyecto		= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
									'----------------------------------------------	
									%>
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><%f_solicitado.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_solicitado.DibujaCampo("ccpe_tdesc")%></td>
									  <td><%=cadenaTablaExcel(v_eje)%></td>
									  <td><%=cadenaTablaExcel(v_proyecto)%></td>
									  <td><%=f_solicitado.DibujaCampo("nombremes")%></td>
									  <td><%=f_solicitado.DibujaCampo("ccpe_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("v_aprox")%></td>
									  <td><%=v_TPresu%></td>
									  <td><%=f_solicitado.DibujaCampo("esol_tdesc")%></td>
									  </tr>
									 <%wend%>
									 <%if f_solicitado.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="10" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
									 <% end if%>
								</table>
								<br/>
								<font>Solicitudes aceptadas</font>
								<br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripcion</th>
									  <th width="51%">Eje</th>
									  <th width="51%">Proyecto</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="9%">Valor Apox.</th>
									  <th width="9%">Tipo presupuesto</th>
									  <th width="18%">Estado</th>
									</tr>
									<%
									while f_aprobados.Siguiente
									%>
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><%f_aprobados.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_aprobados.DibujaCampo("ccpe_tdesc")%></td>
									  <td><%=cadenaTablaExcel(va_eje)%></td>
									  <td><%=cadenaTablaExcel(va_proyecto)%></td>
									  <td><%=f_aprobados.DibujaCampo("nombremes")%></td>
									  <td><%=f_aprobados.DibujaCampo("ccpe_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("v_aprox")%></td>
									  <td><%=v_TPresu%></td>
									  <td><%=f_aprobados.DibujaCampo("esol_tdesc")%></td>
									</tr>
									 <%wend%>
									 <%if f_aprobados.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="9" align="center">No se encontraron solicitudes aprobadas </td></tr>
									 <% end if%>
								</table>	
							<%case 6:%>
								<font>Anexo N°6: Requerimientos Docencia</font>
								<br/><br/>
								<font>Solicitudes Pendientes</font><br/>							
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripción</th>
									  <th width="51%">Eje</th>
									  <th width="51%">Proyecto</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="9%">Valor Apox.</th>
									  <th width="9%">Tipo presupuesto</th>
									  <th width="18%">Estado</th>								  
									</tr>
									<%
									while f_solicitado.Siguiente
									'----------------------------------------------
									v_neje 			= f_solicitado.ObtenerValor("eje_ccod")
									v_nproyecto 	= f_solicitado.ObtenerValor("proye_ccod")
									v_nTPresu		= f_solicitado.ObtenerValor("t_presupuesto")
									v_TPresu		= ""
									if(v_nTPresu = "1") then v_TPresu = "Primario" end if
									if(v_nTPresu = "2") then v_TPresu = "Secundario" end if
									v_eje			= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
									v_proyecto		= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
									'cadenaTabla()
									va_neje 		= f_aprobados.ObtenerValor("eje_ccod")
									va_nproyecto 	= f_aprobados.ObtenerValor("proye_ccod")
									va_nTPresu		= f_aprobados.ObtenerValor("t_presupuesto")
									va_TPresu		= ""
									if(va_nTPresu = "1") then va_TPresu = "Primario" end if
									if(va_nTPresu = "2") then va_TPresu = "Secundario" end if
									va_eje			= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
									va_proyecto		= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
									'----------------------------------------------	
									%>
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><%f_solicitado.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_solicitado.DibujaCampo("ccau_tdesc")%></td>
									  <td><%=cadenaTablaExcel(v_eje)%></td>
									  <td><%=cadenaTablaExcel(v_proyecto)%></td>
									  <td><%=f_solicitado.DibujaCampo("nombremes")%></td>
									  <td><%=f_solicitado.DibujaCampo("ccau_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("v_aprox")%></td>
									  <td><%=v_TPresu%></td>
									  <td><%=f_solicitado.DibujaCampo("esol_tdesc")%></td>
									 </tr>


									 <%wend%>
									 <%if f_solicitado.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="10" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
									 <% end if%>
								</table>
								<br/>
								<font>Solicitudes aceptadas</font>
								<br/><br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripcion</th>
									  <th width="51%">Eje</th>
									  <th width="51%">Proyecto</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="9%">Valor Apox.</th>
									  <th width="9%">Tipo presupuesto</th>
									  <th width="18%">Estado</th>
									</tr>
									<%
									while f_aprobados.Siguiente
									%>
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><%f_aprobados.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_aprobados.DibujaCampo("ccau_tdesc")%></td>
									  <td><%=cadenaTablaExcel(va_eje)%></td>
									  <td><%=cadenaTablaExcel(va_proyecto)%></td>
									  <td><%=f_aprobados.DibujaCampo("nombremes")%></td>
									  <td><%=f_aprobados.DibujaCampo("ccau_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("v_aprox")%></td>
									  <td><%=v_TPresu%></td>
									  <td><%=f_aprobados.DibujaCampo("esol_tdesc")%></td>
									</tr>
									 <%wend%>
									 <%if f_aprobados.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="9" align="center">No se encontraron solicitudes aprobadas </td></tr>
									 <% end if%>
								</table>											
							
							<% end select %>
							
</body>
</html>