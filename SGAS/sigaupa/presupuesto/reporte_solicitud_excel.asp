<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 3000 

Response.AddHeader "Content-Disposition", "attachment;filename=solicitud_presupuestaria.xls"
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
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
v_usuario = negocio.ObtenerUsuario()
'response.Write("Usuario: "&Usuario)

v_anio_actual	= 	conexion2.ConsultaUno("select year(getdate())")
v_cod_anio	=	v_anio_actual+1
'v_cod_anio	=	v_anio_actual
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "solicitud_presupuestaria.xml", "botonera"
'-----------------------------------------------------------------------
 
 codcaja	= request.querystring("busqueda[0][codcaja]")
 nro_t		= request.querystring("nro_t")
 area_ccod	= request.querystring("busqueda[0][area_ccod]") 
 
if codcaja="" then
	codcaja= request.querystring("codcaja")
end if

if area_ccod="" then
	area_ccod= request.querystring("area_ccod")
end if 

txt_concepto=conexion2.ConsultaUno("select top 1 concepto_pre from presupuesto_upa.protic.codigos_presupuesto where cod_pre='"&codcaja&"' and cod_area="&area_ccod&" ")

if txt_concepto<>"" then
	txt_concepto=txt_concepto&" ("&codcaja&")"
else
	txt_concepto= "Todos"
end if

sql_area_presu	= " select top 1 area_tdesc from presupuesto_upa.protic.area_presupuesto_usuario a, presupuesto_upa.protic.area_presupuestal b " & vbCrLf &_
				" where a.area_ccod=b.area_ccod " & vbCrLf &_
				" and rut_usuario="&v_usuario&"  and a.area_ccod="&area_ccod&"  "

area_presupuesto = 	conexion2.consultaUno(sql_area_presu)


 
'----------------------------------------------------------------------------


 set f_presupuesto = new CFormulario
 f_presupuesto.Carga_Parametros "solicitud_presupuestaria.xml", "f_presupuesto"
 f_presupuesto.Inicializar conexion2

   if Request.QueryString <> "" then
	  
	 if nro_t="" then
	  	nro_t=1
	 end if

	select case (nro_t)

		case 1:

			if codcaja <> "" then
				'######################## por codigo	###################	
'				if v_concepto <>"" then
'					str_concepto="and concepto='"&v_concepto&"'"
'				end if
				
				if txt_detalle <>"" then
					str_detalle="and detalle='"&txt_detalle&"'"
				end if 
						
				sql_meses= "	select  upper(nombremes) as mes,indice as mes_venc,sum(cast(isnull(solicitado,0) as numeric)) as solicitado,   "& vbCrLf &_ 
							" sum(cast(isnull(presupuestado,0) as numeric)) as presupuestado "& vbCrLf &_
							"	 from softland.sw_mesce as b   "& vbCrLf &_
							"	 left outer join (  "& vbCrLf &_
							"		select pa.mes as mes, sum(solicitado) as solicitado,sum(presupuestado) as presupuestado "& vbCrLf &_
							"			from     	"& vbCrLf &_
							"				( 		"& vbCrLf &_
							"				select sum(valor) as presupuestado,0 as solicitado,mes,cod_anio, cod_pre, cod_area, descripcion_area,concepto "& vbCrLf &_
							"				from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2013     "& vbCrLf &_
							"				where cod_pre='"&codcaja&"' "& vbCrLf &_
							"				and cod_area="&area_ccod&" "& vbCrLf &_
							"				"&str_concepto&" "& vbCrLf &_
							"				"&str_detalle&" "& vbCrLf &_
							"				and cod_anio=year(getdate()) "& vbCrLf &_
							"				group by mes,cod_anio, cod_pre, cod_area, descripcion_area,concepto  "& vbCrLf &_
							"			Union "& vbCrLf &_
							"				select 0 as presupuestado,sum(valor) as solicitado,mes,cod_anio, cod_pre, cod_area, descripcion_area,concepto "& vbCrLf &_
							"				from presupuesto_upa.protic.vis_solicitud_presupuesto_anual  "& vbCrLf &_   
							"				where cod_pre='"&codcaja&"' "& vbCrLf &_
							"				and cod_area="&area_ccod&" "& vbCrLf &_
							"				"&str_concepto&" "& vbCrLf &_
							"				"&str_detalle&" "& vbCrLf &_
							"				and cod_anio=year(getdate())+1 "& vbCrLf &_
							"				group by mes,cod_anio, cod_pre, cod_area, descripcion_area,concepto  "& vbCrLf &_
							"				) as pa "& vbCrLf &_
							"			group by pa.mes   "& vbCrLf &_                    
							"	)as a  "& vbCrLf &_
							"on indice=mes  "& vbCrLf &_
						"group by nombremes,indice "
							
							
			else
				'######################## por area	###################	
				sql_meses= "	select  upper(nombremes) as mes,indice as mes_venc,sum(cast(isnull(solicitado,0) as numeric)) as solicitado,   "& vbCrLf &_ 
							" sum(cast(isnull(presupuestado,0) as numeric)) as presupuestado "& vbCrLf &_
							"	 from softland.sw_mesce as b   "& vbCrLf &_
							"	 left outer join (  "& vbCrLf &_
							"		select pa.mes as mes, sum(solicitado) as solicitado,sum(presupuestado) as presupuestado "& vbCrLf &_
							"			from     "& vbCrLf &_
							"				(select sum(valor) as presupuestado,0 as solicitado,mes,cod_anio,cod_area, descripcion_area "& vbCrLf &_
							"				from presupuesto_upa.protic.vis_solicitud_presupuesto_anual     "& vbCrLf &_
							"				where cod_pre in (select distinct cod_pre from presupuesto_upa.protic.vis_presupuesto_anual where cod_area= "&area_ccod&" ) "& vbCrLf &_
							"				and cod_anio=year(getdate()) "& vbCrLf &_
							"				group by mes,cod_anio, cod_area, descripcion_area  "& vbCrLf &_
							"			union "& vbCrLf &_
							"				select 0 as presupuestado,sum(valor) as solicitado,mes,cod_anio, cod_area, descripcion_area "& vbCrLf &_
							"				from presupuesto_upa.protic.vis_solicitud_presupuesto_anual  "& vbCrLf &_   
							"				where cod_pre in (select distinct cod_pre from presupuesto_upa.protic.vis_presupuesto_anual where cod_area= "&area_ccod&" )  "& vbCrLf &_
							"				and cod_anio=year(getdate()) "& vbCrLf &_
							"				group by mes,cod_anio, cod_area, descripcion_area "& vbCrLf &_
							"				) as pa "& vbCrLf &_
							"			group by pa.mes   "& vbCrLf &_                    
							"	)as a  "& vbCrLf &_
							"on indice=mes  "& vbCrLf &_
						"group by nombremes,indice "
'and cod_anio=year(getdate())+1	
			
			end if
		
	
			set f_meses = new CFormulario
			f_meses.Carga_Parametros "solicitud_presupuestaria.xml", "solicitud"
			f_meses.Inicializar conexion2
			f_meses.consultar sql_meses

		case 2:
	
			anio = "2016"
			set f_presupuestado = new CFormulario
			f_presupuestado.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			f_presupuestado.Inicializar conexion
			if codcaja = "" then
				filtro_codcaja = "where area_ccod='"&area_ccod&"' and anio = "&anio&" "
			else
			    filtro_codcaja = "where cod_pre = '"&codcaja&"' and anio = "&anio&" "
			end if
			
			sql_presupuestado	="" & vbCrLf & _
			"select cod_pre,                      " & vbCrLf & _
			"       area_ccod,                    " & vbCrLf & _
			"       detalle,   	                  " & vbCrLf & _
			"       eje_ccod,                     " & vbCrLf & _
			"       foco_ccod,                    " & vbCrLf & _
			"       prog_ccod,                    " & vbCrLf & _
			"       proye_ccod,                   " & vbCrLf & _
			"       obje_ccod,                    " & vbCrLf & _
			"       tipo_gasto,                   " & vbCrLf & _
			"       anio,                         " & vbCrLf & _
			"       ene,                          " & vbCrLf & _
			"       feb,                          " & vbCrLf & _
			"       mar,                          " & vbCrLf & _
			"       abr,                          " & vbCrLf & _
			"       may,                          " & vbCrLf & _
			"       jun,                          " & vbCrLf & _
			"       jul,                          " & vbCrLf & _
			"       ago,                          " & vbCrLf & _
			"       sep,                          " & vbCrLf & _
			"       octu,                         " & vbCrLf & _
			"       nov,                          " & vbCrLf & _
			"       dic,                          " & vbCrLf & _
			"       total                         " & vbCrLf & _
			"from   presupuesto_directo_area_desa "&filtro_codcaja&"   " 
			'response.write("<pre>"&sql_presupuestado&"</pre>")
			'response.end()
			f_presupuestado.consultar sql_presupuestado

	end select	

else
	 f_presupuesto.consultar "select '' where 1 = 2"
	 f_presupuesto.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
end if

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
								<p><b>Solicitado vs Anterior </b></p>
								<br/>
								<p><b>Area Presupuestal:&nbsp;<font color="#0000CC" size="2"><%=area_presupuesto%></font>&nbsp;&nbsp;Código Presupuestario:&nbsp;<font color="#0000CC" size="2"><%=txt_concepto%></font></b></p>
								
                              <table border="1" align="left" width="100%" >
                                <tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
                                  <th>MES</th>
                                  <th>SOLICITADO</th>
                                  <th>PRESUPUESTADO</th>
                                </tr>
								<%
								v_total_real	=0
								v_total_presu	=0
								v_total_desvi	=0
								while f_meses.Siguiente
									v_total_real	=	v_total_real	+	Cdbl(f_meses.ObtenerValor("solicitado"))
									v_total_presu	=	v_total_presu	+	Cdbl(f_meses.ObtenerValor("presupuestado"))
								
								%>
								<tr bordercolor='#999999'>	
									
                                  <td><%f_meses.DibujaCampo("mes")%></td>
                                  <td align="right"><%=f_meses.ObtenerValor("solicitado")%></td>
                                  <td align="right"><%=f_meses.ObtenerValor("presupuestado")%></td>
                                </tr>
								 <%wend%>
								 <tr bordercolor='#999999'>
								 	<td><b>Totales</b></td>
									<td align="right"><b><%=v_total_real%></b></td>
									<td align="right"><b><%=v_total_presu%></b></td>
								 </tr>
                              </table>
								 
							<%case 2:%>
								<p><b>Detalle del presupuesto solicitado</b></p>
								<br/>
								<p><b>Area Presupuestal:&nbsp;<font color="#0000CC" size="2"><%=area_presupuesto%></font>&nbsp;&nbsp;Código Presupuestario:&nbsp;<font color="#0000CC" size="2"><%=txt_concepto%></font></b></p>
									<table border="1" align="left" width="100%" >
										<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
										  <th>CONCEPTO</th>
										  <th>DETALLE</th>
										  <th>CODIGO</th>
                                          <th>TIPO</th>
										  <th>ENERO</th>
										  <th>FEBRERO</th>
										  <th>MARZO</th>
										  <th>ABRIL</th>
										  <th>MAYO</th>
										  <th>JUNIO</th>
										  <th>JULIO</th>
										  <th>AGOSTO</th>
										  <th>SEPTIEMBRE</th>
										  <th>OCTUBRE</th>
										  <th>NOVIEMBRE</th>
										  <th>DICIEMBRE</th>
										  <th>TOTAL</th>
										</tr>
									<%
									while f_presupuestado.Siguiente
										foco_ccod 	= f_presupuestado.ObtenerValor("foco_ccod")   
										foco_tdesc	= conexion.consultaUno("select foco_tdesc from foco where foco_ccod = "&foco_ccod&"")
										prog_ccod 	= f_presupuestado.ObtenerValor("prog_ccod") 
										prog_tdesc	= conexion.consultaUno("select prog_tdesc from programa where prog_ccod = "&prog_ccod&"")	
										proye_ccod 	= f_presupuestado.ObtenerValor("proye_ccod")  
										proye_tdesc	= conexion.consultaUno("select proye_tdesc from proyecto where proye_ccod = "&proye_ccod&"")			
										obje_ccod 	= f_presupuestado.ObtenerValor("obje_ccod")   
										obje_tdesc	= conexion.consultaUno("select obje_tdesc from objetivo where obje_ccod = "&obje_ccod&"")		
									
									
										eje_ccod 	= f_presupuestado.ObtenerValor("eje_ccod")
										eje_tdesc	= conexion.consultaUno("select eje_tdesc from eje where eje_ccod = "&eje_ccod&"")
										cod_pre 	= f_presupuestado.ObtenerValor("cod_pre")
										detalle 	= f_presupuestado.ObtenerValor("detalle")
										tipo_gasto 	= f_presupuestado.ObtenerValor("tipo_gasto")
										ene 		= f_presupuestado.ObtenerValor("ene")
										feb  		= f_presupuestado.ObtenerValor("feb")
										mar  		= f_presupuestado.ObtenerValor("mar")
										abr  		= f_presupuestado.ObtenerValor("abr")
										may  		= f_presupuestado.ObtenerValor("may")
										jun  		= f_presupuestado.ObtenerValor("jun")
										jul  		= f_presupuestado.ObtenerValor("jul")
										ago  		= f_presupuestado.ObtenerValor("ago")
										sep  		= f_presupuestado.ObtenerValor("sep")
										octu 		= f_presupuestado.ObtenerValor("octu")
										nov  		= f_presupuestado.ObtenerValor("nov")
										dic  		= f_presupuestado.ObtenerValor("dic")
										total		= f_presupuestado.ObtenerValor("total")
										'-----------------------------------------------------------calculo totales
										tot_ene   =  tot_ene   + ene  
										tot_feb   =  tot_feb   + feb  
										tot_mar   =  tot_mar   + mar  
										tot_abr   =  tot_abr   + abr  
										tot_may   =  tot_may   + may  
										tot_jun   =  tot_jun   + jun  
										tot_jul   =  tot_jul   + jul  
										tot_ago   =  tot_ago   + ago  
										tot_sep   =  tot_sep   + sep  
										tot_octu  =  tot_octu  + octu 
										tot_nov   =  tot_nov   + nov  
										tot_dic   =  tot_dic   + dic  
										tot_total =  tot_total + total										
										'-----------------------------------------------------------calculo totales
										
										set f_busqueda2 = new CFormulario
										f_busqueda2.Carga_Parametros "tabla_vacia.xml", "tabla_vacia" 
										f_busqueda2.inicializar conexion2	
										con_1 = "select concepto_pre from  presupuesto_upa.protic.codigos_presupuesto where cod_pre = '"&cod_pre&"'"
										'response.write(con_1)
										'response.end()
										f_busqueda2.consultar con_1	
										f_busqueda2.siguiente
										nombre_1     = f_busqueda2.ObtenerValor("concepto_pre")
									
									%>
									<tr bordercolor='#999999'>	
										<td><%=nombre_1%></td>
										<td><%=detalle%></td>
										<td><%=cod_pre%></td> 
                                        <td><%=tipo_gasto%></td>
										<td><%=ene%></td>
										<td><%=feb%> </td>
										<td><%=mar%> </td>
										<td><%=abr%> </td>
										<td><%=may%> </td>
										<td><%=jun%> </td>
										<td><%=jul%> </td>
										<td><%=ago%> </td>
										<td><%=sep%> </td>
										<td><%=octu%> </td>
										<td><%=nov%> </td>
					 					<td><%=dic%> </td>
										<td><strong><%=total%></strong></td>
									</tr>
									 <%wend%>
									<tr bordercolor='#999999'>
								 	<td colspan="4"><b>Totales</b></td>
									<td align="right"><%=tot_ene%><b></b></td>
									<td align="right"><%=tot_feb%><b></b></td>
									<td align="right"><%=tot_mar%><b></b></td>
									<td align="right"><%=tot_abr%><b></b></td>
									<td align="right"><%=tot_may%><b></b></td>
									<td align="right"><%=tot_jun%><b></b></td>
									<td align="right"><%=tot_jul%><b></b></td>
									<td align="right"><%=tot_ago%><b></b></td>
									<td align="right"><%=tot_sep%><b></b></td>
									<td align="right"><%=tot_octu%><b></b></td>
									<td align="right"><%=tot_nov%><b></b></td>
									<td align="right"><%=tot_dic%><b></b></td>
									<td align="right"><b><%=tot_total%></b></td>
								 </tr>									 
								  </table>
							<%End Select%>
</body>
</html>