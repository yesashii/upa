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
	
			set f_presupuestado = new CFormulario
			f_presupuestado.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			f_presupuestado.Inicializar conexion2
			
			if codcaja <> "" then
			 
				sql_presupuestado	=" SELECT concepto, detalle, cod_pre,isnull(total,0) as total, "& vbCrLf &_
									" (select tp.tpre_tdesc from presupuesto_upa.protic.tipo_presupuesto tp where tp.tpre_ccod= isnull(a.tpre_ccod,2)) as tipo_presupuesto, "& vbCrLf &_
									" isnull(enero,0) as enero, isnull(febrero,0) as febrero, isnull(marzo,0) as marzo, isnull(abril,0) as abril, "& vbCrLf &_
									" isnull(mayo,0) as mayo, isnull(junio,0) as junio, isnull(julio,0) as julio, isnull(agosto,0) as agosto, "& vbCrLf &_
									" isnull(septiembre,0) as septiembre,isnull(octubre,0) as octubre, isnull(noviembre,0) as noviembre,  "& vbCrLf &_
									" isnull(diciembre,0) as diciembre, isnull(enero_prox,0) as enero_prox,isnull(febrero_prox,0) as febrero_prox "& vbCrLf &_
									"	FROM presupuesto_upa.protic.solicitud_presupuesto_upa a "& vbCrLf &_
									"	where cod_pre = '"&codcaja&"'  "& vbCrLf &_
									"  and cod_anio="&v_cod_anio&""
'and cod_anio=year(getdate())+1									
			else
				sql_presupuestado	=" SELECT concepto, detalle, cod_pre,isnull(total,0) as total, "& vbCrLf &_
									" (select tp.tpre_tdesc from presupuesto_upa.protic.tipo_presupuesto tp where tp.tpre_ccod= isnull(a.tpre_ccod,2)) as tipo_presupuesto, "& vbCrLf &_
									" isnull(enero,0) as enero, isnull(febrero,0) as febrero, isnull(marzo,0) as marzo, isnull(abril,0) as abril, "& vbCrLf &_
									" isnull(mayo,0) as mayo, isnull(junio,0) as junio, isnull(julio,0) as julio, isnull(agosto,0) as agosto, "& vbCrLf &_
									" isnull(septiembre,0) as septiembre,isnull(octubre,0) as octubre, isnull(noviembre,0) as noviembre,  "& vbCrLf &_
									" isnull(diciembre,0) as diciembre, isnull(enero_prox,0) as enero_prox,isnull(febrero_prox,0) as febrero_prox "& vbCrLf &_
									"	FROM presupuesto_upa.protic.solicitud_presupuesto_upa a "& vbCrLf &_
									" --where cod_pre in (select distinct cod_pre from presupuesto_upa.protic.vis_solicitud_presupuesto_anual where cod_area="&area_ccod&")  "& vbCrLf &_
									"  where cod_area="&area_ccod&"  "& vbCrLf &_
									"  and cod_anio="&v_cod_anio&" "
'and cod_anio=year(getdate())+1				
			end if
									
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
										  <th>ENERO PROX</th>
										  <th>FEBRERO PROX</th>
										  <th>TOTAL</th>
										</tr>
									<%
									while f_presupuestado.Siguiente
										v_total		=	v_total		+	Cdbl(f_presupuestado.ObtenerValor("total"))
										v_enero		=	v_enero		+	Cdbl(f_presupuestado.ObtenerValor("enero"))
										v_febrero	=	v_febrero	+	Cdbl(f_presupuestado.ObtenerValor("febrero"))
										v_marzo		=	v_marzo		+	Cdbl(f_presupuestado.ObtenerValor("marzo"))
										v_abril		=	v_abril		+	Cdbl(f_presupuestado.ObtenerValor("abril"))
										v_mayo		=	v_mayo		+	Cdbl(f_presupuestado.ObtenerValor("mayo"))
										v_junio		=	v_junio		+	Cdbl(f_presupuestado.ObtenerValor("junio"))
										v_julio		=	v_julio		+	Cdbl(f_presupuestado.ObtenerValor("julio"))
										v_agosto	=	v_agosto	+	Cdbl(f_presupuestado.ObtenerValor("agosto"))
										v_septiembre=	v_septiembre	+	Cdbl(f_presupuestado.ObtenerValor("septiembre"))
										v_octubre	=	v_octubre		+	Cdbl(f_presupuestado.ObtenerValor("octubre"))
										v_noviembre	=	v_noviembre		+	Cdbl(f_presupuestado.ObtenerValor("noviembre"))
										v_diciembre	=	v_diciembre		+	Cdbl(f_presupuestado.ObtenerValor("diciembre"))
										v_enero_prox	=v_enero_prox	+	Cdbl(f_presupuestado.ObtenerValor("enero_prox"))
										v_febrero_prox	=v_febrero_prox	+	Cdbl(f_presupuestado.ObtenerValor("febrero_prox"))
									%>
									<tr bordercolor='#999999'>	
										<td><%=f_presupuestado.ObtenerValor("concepto")%></td>
										<td><%=f_presupuestado.ObtenerValor("detalle")%></td>
										<td><%=f_presupuestado.ObtenerValor("cod_pre")%></td>
                                        <td><%=f_presupuestado.ObtenerValor("tipo_presupuesto")%></td>
										<td><%=f_presupuestado.ObtenerValor("enero")%></td>
										<td><%=f_presupuestado.ObtenerValor("febrero")%></td>
										<td><%=f_presupuestado.ObtenerValor("marzo")%></td>
										<td><%=f_presupuestado.ObtenerValor("abril")%></td>
										<td><%=f_presupuestado.ObtenerValor("mayo")%></td>
										<td><%=f_presupuestado.ObtenerValor("junio")%></td>
										<td><%=f_presupuestado.ObtenerValor("julio")%></td>
										<td><%=f_presupuestado.ObtenerValor("agosto")%></td>
										<td><%=f_presupuestado.ObtenerValor("septiembre")%></td>
										<td><%=f_presupuestado.ObtenerValor("octubre")%></td>
										<td><%=f_presupuestado.ObtenerValor("noviembre")%></td>
										<td><%=f_presupuestado.ObtenerValor("diciembre")%></td>
										<td><%=f_presupuestado.ObtenerValor("enero_prox")%></td>
										<td><%=f_presupuestado.ObtenerValor("febrero_prox")%></td>
										<td><strong><%=f_presupuestado.ObtenerValor("total")%></strong></td>
									</tr>
									 <%wend%>
									<tr bordercolor='#999999'>
								 	<td colspan="4"><b>Totales</b></td>
									<td align="right"><b><%=v_enero%></b></td>
									<td align="right"><b><%=v_febrero%></b></td>
									<td align="right"><b><%=v_marzo%></b></td>
									<td align="right"><b><%=v_abril%></b></td>
									<td align="right"><b><%=v_mayo%></b></td>
									<td align="right"><b><%=v_junio%></b></td>
									<td align="right"><b><%=v_julio%></b></td>
									<td align="right"><b><%=v_agosto%></b></td>
									<td align="right"><b><%=v_septiembre%></b></td>
									<td align="right"><b><%=v_octubre%></b></td>
									<td align="right"><b><%=v_noviembre%></b></td>
									<td align="right"><b><%=v_diciembre%></b></td>
									<td align="right"><b><%=v_enero_prox%></b></td>
									<td align="right"><b><%=v_febrero_prox%></b></td>
									<td align="right"><b><%=v_total%></b></td>
								 </tr>
								  </table>
							<%End Select%>
</body>
</html>