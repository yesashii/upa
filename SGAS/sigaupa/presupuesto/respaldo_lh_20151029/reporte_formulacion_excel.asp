<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 3000 

Response.AddHeader "Content-Disposition", "attachment;filename=formulacion_presupuesto.xls"
Response.ContentType = "application/vnd.ms-excel"

'for each k in request.form
'	response.Write(k&" = "&request.querystring(k)&"<br>")
'next
'response.End()

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
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "ejecucion_presupuestaria.xml", "botonera"
'-----------------------------------------------------------------------

v_anio_actual	= conexion2.ConsultaUno("select year(getdate())")
'v_prox_anio		= v_anio_actual+1
v_prox_anio		= v_anio_actual

 
nro_t		= request.querystring("nro_t")
v_area		= request.querystring("cod_area")
concepto 	= request.querystring("busqueda[0][concepto]")
detalle_concepto 	= request.querystring("concepto")


if concepto<>"" then
	sql_concepto= "and concepto like '"&concepto&"' "
end if

if v_area<>"" then
	sql_area= " and cod_area = "&v_area&" "
end if

if nro_t="" then
	nro_t=1
end if

 set f_presupuestado = new CFormulario
 f_presupuestado.Carga_Parametros "formulacion_presupuesto.xml", "f_presupuesto"
 f_presupuestado.Inicializar conexion2

	select case (nro_t)
		
		case 1:
	
			sql_presupuestado	= " select area_tdesc as area,sum(isnull(total,0)) as total,   "& vbCrLf &_
								  "  sum(isnull(enero,0)) as enero, sum(isnull(febrero,0)) as febrero, sum(isnull(marzo,0)) as marzo, sum(isnull(abril,0)) as abril, "& vbCrLf &_  
								  "  sum(isnull(mayo,0)) as mayo, sum(isnull(junio,0)) as junio, sum(isnull(julio,0)) as julio, sum(isnull(agosto,0)) as agosto,   "& vbCrLf &_
								  "  sum(isnull(septiembre,0)) as septiembre,sum(isnull(octubre,0)) as octubre, sum(isnull(noviembre,0)) as noviembre,   "& vbCrLf &_ 
								  "  sum(isnull(diciembre,0)) as diciembre, sum(isnull(enero_prox,0)) as enero_prox,sum(isnull(febrero_prox,0)) as febrero_prox "& vbCrLf &_
								  "	FROM presupuesto_upa.protic.solicitud_presupuesto_upa  a, presupuesto_upa.protic.area_presupuestal b "& vbCrLf &_
								  "	where a.cod_area=b.area_ccod "& vbCrLf &_
								  " and cod_anio="&v_prox_anio&" "& vbCrLf &_
								  " "&sql_concepto&" "& vbCrLf &_
								  "	group by area_tdesc order by  area_tdesc desc"

		case 2:
	

			sql_presupuestado	= " SELECT concepto, sum(isnull(total,0)) as total,  "& vbCrLf &_ 
								  " sum(isnull(enero,0)) as enero, sum(isnull(febrero,0)) as febrero, sum(isnull(marzo,0)) as marzo, sum(isnull(abril,0)) as abril,"& vbCrLf &_   
								  " sum(isnull(mayo,0)) as mayo, sum(isnull(junio,0)) as junio, sum(isnull(julio,0)) as julio, sum(isnull(agosto,0)) as agosto, "& vbCrLf &_  
								  " sum(isnull(septiembre,0)) as septiembre,sum(isnull(octubre,0)) as octubre, sum(isnull(noviembre,0)) as noviembre, "& vbCrLf &_   
								  " sum(isnull(diciembre,0)) as diciembre, sum(isnull(enero_prox,0)) as enero_prox,sum(isnull(febrero_prox,0)) as febrero_prox  "& vbCrLf &_ 
								  " FROM presupuesto_upa.protic.solicitud_presupuesto_upa  "& vbCrLf &_
								  " and cod_anio="&v_prox_anio&" "& vbCrLf &_ 
								  " group by concepto  "
		case 3:
	

			sql_presupuestado	= " SELECT concepto, sum(isnull(total,0)) as total,  "& vbCrLf &_ 
								  " sum(isnull(enero,0)) as enero, sum(isnull(febrero,0)) as febrero, sum(isnull(marzo,0)) as marzo, sum(isnull(abril,0)) as abril,"& vbCrLf &_   
								  " sum(isnull(mayo,0)) as mayo, sum(isnull(junio,0)) as junio, sum(isnull(julio,0)) as julio, sum(isnull(agosto,0)) as agosto, "& vbCrLf &_  
								  " sum(isnull(septiembre,0)) as septiembre,sum(isnull(octubre,0)) as octubre, sum(isnull(noviembre,0)) as noviembre, "& vbCrLf &_   
								  " sum(isnull(diciembre,0)) as diciembre, sum(isnull(enero_prox,0)) as enero_prox,sum(isnull(febrero_prox,0)) as febrero_prox  "& vbCrLf &_ 
								  " FROM presupuesto_upa.protic.solicitud_presupuesto_upa  "& vbCrLf &_ 
								  " where 1=1 "& vbCrLf &_
								  " "&sql_area&" "& vbCrLf &_
								  " and cod_anio="&v_prox_anio&" "& vbCrLf &_
								  " group by concepto  "
		case 4:
	

			sql_presupuestado	= " SELECT concepto, sum(isnull(total,0)) as total,  "& vbCrLf &_ 
								  " sum(isnull(enero,0)) as enero, sum(isnull(febrero,0)) as febrero, sum(isnull(marzo,0)) as marzo, sum(isnull(abril,0)) as abril,"& vbCrLf &_   
								  " sum(isnull(mayo,0)) as mayo, sum(isnull(junio,0)) as junio, sum(isnull(julio,0)) as julio, sum(isnull(agosto,0)) as agosto, "& vbCrLf &_  
								  " sum(isnull(septiembre,0)) as septiembre,sum(isnull(octubre,0)) as octubre, sum(isnull(noviembre,0)) as noviembre, "& vbCrLf &_   
								  " sum(isnull(diciembre,0)) as diciembre, sum(isnull(enero_prox,0)) as enero_prox,sum(isnull(febrero_prox,0)) as febrero_prox  "& vbCrLf &_ 
								  " FROM presupuesto_upa.protic.solicitud_presupuesto_upa  "& vbCrLf &_ 
								  " where 1=1 "& vbCrLf &_
								  " "&sql_area&" "& vbCrLf &_
								  " and cod_anio="&v_prox_anio&" "& vbCrLf &_
								  " group by concepto  "
								  								  
			
	end select	
	'response.Write("<pre>"&sql_presupuestado&"</pre>")	
	f_presupuestado.consultar sql_presupuestado
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
								<br/>
								<font color="#0000CC" size="2">FORMULACION PRESUPUESTARIA POR AREA</font> 
								<br/>
								<br/>
										<table width="100%" border="1" align="center" >
												<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
												  <th width="40%">AREA</th>
												  <th width="25%">ENERO</th>
												  <th width="25%">FEBRERO</th>
												  <th width="25%">MARZO</th>
												  <th width="25%">ABRIL</th>
												  <th width="25%">MAYO</th>
												  <th width="25%">JUNIO</th>
												  <th width="25%">JULIO</th>
												  <th width="25%">AGOSTO</th>
												  <th width="25%">SEPTIEMBRE</th>
												  <th width="25%">OCTUBRE</th>
												  <th width="25%">NOVIEMBRE</th>
												  <th width="25%">DICIEMBRE</th>
												  <th width="25%">ENERO PROX</th>
												  <th width="25%">FEBRERO PROX</th>
												  <th width="25%">TOTAL</th>
												</tr>
											<%
											while f_presupuestado.Siguiente
												v_total		=	v_total		+	CDbl(f_presupuestado.ObtenerValor("total"))
												v_enero		=	v_enero		+	CDbl(f_presupuestado.ObtenerValor("enero"))
												v_febrero	=	v_febrero	+	CDbl(f_presupuestado.ObtenerValor("febrero"))
												v_marzo		=	v_marzo		+	CDbl(f_presupuestado.ObtenerValor("marzo"))
												v_abril		=	v_abril		+	CDbl(f_presupuestado.ObtenerValor("abril"))
												v_mayo		=	v_mayo		+	CDbl(f_presupuestado.ObtenerValor("mayo"))
												v_junio		=	v_junio		+	CDbl(f_presupuestado.ObtenerValor("junio"))
												v_julio		=	v_julio		+	CDbl(f_presupuestado.ObtenerValor("julio"))
												v_agosto	=	v_agosto	+	CDbl(f_presupuestado.ObtenerValor("agosto"))
												v_septiembre=	v_septiembre	+	CDbl(f_presupuestado.ObtenerValor("septiembre"))
												v_octubre	=	v_octubre		+	CDbl(f_presupuestado.ObtenerValor("octubre"))
												v_noviembre	=	v_noviembre		+	CDbl(f_presupuestado.ObtenerValor("noviembre"))
												v_diciembre	=	v_diciembre		+	CDbl(f_presupuestado.ObtenerValor("diciembre"))
												v_enero_prox	=v_enero_prox	+	CDbl(f_presupuestado.ObtenerValor("enero_prox"))
												v_febrero_prox	=v_febrero_prox	+	CDbl(f_presupuestado.ObtenerValor("febrero_prox"))
											%>
											<tr bordercolor='#999999'>	
												<td><%=f_presupuestado.ObtenerValor("area")%></td>
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
											<td ><b>Totales</b></td>
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
                              
								 
							<%case 2:%>
							
								<br/>
								<font color="#0000CC" size="2">FORMULACION PRESUPUESTARIA POR CONCEPTO </font>
								<br/>
								<br/>
								<table width="100%" border="1" align="center" >
												<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
												  <th colspan="3">CONCEPTO</th>
												  <th width="25%">ENERO</th>
												  <th width="25%">FEBRERO</th>
												  <th width="25%">MARZO</th>
												  <th width="25%">ABRIL</th>
												  <th width="25%">MAYO</th>
												  <th width="25%">JUNIO</th>
												  <th width="25%">JULIO</th>
												  <th width="25%">AGOSTO</th>
												  <th width="25%">SEPTIEMBRE</th>
												  <th width="25%">OCTUBRE</th>
												  <th width="25%">NOVIEMBRE</th>
												  <th width="25%">DICIEMBRE</th>
												  <th width="25%">ENERO PROX</th>
												  <th width="25%">FEBRERO PROX</th>
												  <th width="25%">TOTAL</th>
												</tr>
											<%
											while f_presupuestado.Siguiente
												v_total		=	v_total		+	CDbl(f_presupuestado.ObtenerValor("total"))
												v_enero		=	v_enero		+	CDbl(f_presupuestado.ObtenerValor("enero"))
												v_febrero	=	v_febrero	+	CDbl(f_presupuestado.ObtenerValor("febrero"))
												v_marzo		=	v_marzo		+	CDbl(f_presupuestado.ObtenerValor("marzo"))
												v_abril		=	v_abril		+	CDbl(f_presupuestado.ObtenerValor("abril"))
												v_mayo		=	v_mayo		+	CDbl(f_presupuestado.ObtenerValor("mayo"))
												v_junio		=	v_junio		+	CDbl(f_presupuestado.ObtenerValor("junio"))
												v_julio		=	v_julio		+	CDbl(f_presupuestado.ObtenerValor("julio"))
												v_agosto	=	v_agosto	+	CDbl(f_presupuestado.ObtenerValor("agosto"))
												v_septiembre=	v_septiembre	+	CDbl(f_presupuestado.ObtenerValor("septiembre"))
												v_octubre	=	v_octubre		+	CDbl(f_presupuestado.ObtenerValor("octubre"))
												v_noviembre	=	v_noviembre		+	CDbl(f_presupuestado.ObtenerValor("noviembre"))
												v_diciembre	=	v_diciembre		+	CDbl(f_presupuestado.ObtenerValor("diciembre"))
												v_enero_prox	=v_enero_prox	+	CDbl(f_presupuestado.ObtenerValor("enero_prox"))
												v_febrero_prox	=v_febrero_prox	+	CDbl(f_presupuestado.ObtenerValor("febrero_prox"))
											
											%>
											<tr bordercolor='#999999'>	
												<td colspan="3"><%=f_presupuestado.ObtenerValor("concepto")%></td>
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
											<td colspan="3"><b>Totales</b></td>
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

							<%case 3:%>
							
								<br/>
								<font color="#0000CC" size="2">PRESUPUESTO LEASING</font>
								<br/>
								<br/>
								<table width="100%" border="1" align="center" >
												<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
												  <th >AREA</th>
												  <th >CONCEPTO</th>
												  <th >DETALLE</th>
												  <th width="25%">ENERO</th>
												  <th width="25%">FEBRERO</th>
												  <th width="25%">MARZO</th>
												  <th width="25%">ABRIL</th>
												  <th width="25%">MAYO</th>
												  <th width="25%">JUNIO</th>
												  <th width="25%">JULIO</th>
												  <th width="25%">AGOSTO</th>
												  <th width="25%">SEPTIEMBRE</th>
												  <th width="25%">OCTUBRE</th>
												  <th width="25%">NOVIEMBRE</th>
												  <th width="25%">DICIEMBRE</th>
												  <th width="25%">ENERO PROX</th>
												  <th width="25%">FEBRERO PROX</th>
												  <th width="25%">TOTAL</th>
												</tr>
											<%
											while f_presupuestado.Siguiente
												v_total		=	v_total		+	CDbl(f_presupuestado.ObtenerValor("total"))
												v_enero		=	v_enero		+	CDbl(f_presupuestado.ObtenerValor("enero"))
												v_febrero	=	v_febrero	+	CDbl(f_presupuestado.ObtenerValor("febrero"))
												v_marzo		=	v_marzo		+	CDbl(f_presupuestado.ObtenerValor("marzo"))
												v_abril		=	v_abril		+	CDbl(f_presupuestado.ObtenerValor("abril"))
												v_mayo		=	v_mayo		+	CDbl(f_presupuestado.ObtenerValor("mayo"))
												v_junio		=	v_junio		+	CDbl(f_presupuestado.ObtenerValor("junio"))
												v_julio		=	v_julio		+	CDbl(f_presupuestado.ObtenerValor("julio"))
												v_agosto	=	v_agosto	+	CDbl(f_presupuestado.ObtenerValor("agosto"))
												v_septiembre=	v_septiembre	+	CDbl(f_presupuestado.ObtenerValor("septiembre"))
												v_octubre	=	v_octubre		+	CDbl(f_presupuestado.ObtenerValor("octubre"))
												v_noviembre	=	v_noviembre		+	CDbl(f_presupuestado.ObtenerValor("noviembre"))
												v_diciembre	=	v_diciembre		+	CDbl(f_presupuestado.ObtenerValor("diciembre"))
												v_enero_prox	=v_enero_prox	+	CDbl(f_presupuestado.ObtenerValor("enero_prox"))
												v_febrero_prox	=v_febrero_prox	+	CDbl(f_presupuestado.ObtenerValor("febrero_prox"))
											
											%>
											<tr bordercolor='#999999'>	
												<td ><%=f_presupuestado.ObtenerValor("area")%></td>
												<td ><%=f_presupuestado.ObtenerValor("concepto")%></td>
												<td ><%=f_presupuestado.ObtenerValor("detalle")%></td>
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
											<td colspan="3"><b>Totales</b></td>
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
										  
							 <% case 4:%>
									 <tr><td>
									 
										<br/>
										<font color="#0000CC" size="2">FORMULACION PRESUPUESTARIA PARA REVISION </font> 
										<br/>
										<br/>		
											<table width="100%" border="1" align="center" >
												<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
												  <th >CONCEPTO</th>
												  <th width="25%">ENERO</th>
												  <th width="25%">FEBRERO</th>
												  <th width="25%">MARZO</th>
												  <th width="25%">ABRIL</th>
												  <th width="25%">MAYO</th>
												  <th width="25%">JUNIO</th>
												  <th width="25%">JULIO</th>
												  <th width="25%">AGOSTO</th>
												  <th width="25%">SEPTIEMBRE</th>
												  <th width="25%">OCTUBRE</th>
												  <th width="25%">NOVIEMBRE</th>
												  <th width="25%">DICIEMBRE</th>
												  <th width="25%">ENERO PROX</th>
												  <th width="25%">FEBRERO PROX</th>
												  <th width="25%">TOTAL</th>
												</tr>
											<%
											while f_presupuestado.Siguiente
												v_total		=	v_total		+	CDbl(f_presupuestado.ObtenerValor("total"))
												v_enero		=	v_enero		+	CDbl(f_presupuestado.ObtenerValor("enero"))
												v_febrero	=	v_febrero	+	CDbl(f_presupuestado.ObtenerValor("febrero"))
												v_marzo		=	v_marzo		+	CDbl(f_presupuestado.ObtenerValor("marzo"))
												v_abril		=	v_abril		+	CDbl(f_presupuestado.ObtenerValor("abril"))
												v_mayo		=	v_mayo		+	CDbl(f_presupuestado.ObtenerValor("mayo"))
												v_junio		=	v_junio		+	CDbl(f_presupuestado.ObtenerValor("junio"))
												v_julio		=	v_julio		+	CDbl(f_presupuestado.ObtenerValor("julio"))
												v_agosto	=	v_agosto	+	CDbl(f_presupuestado.ObtenerValor("agosto"))
												v_septiembre=	v_septiembre	+	CDbl(f_presupuestado.ObtenerValor("septiembre"))
												v_octubre	=	v_octubre		+	CDbl(f_presupuestado.ObtenerValor("octubre"))
												v_noviembre	=	v_noviembre		+	CDbl(f_presupuestado.ObtenerValor("noviembre"))
												v_diciembre	=	v_diciembre		+	CDbl(f_presupuestado.ObtenerValor("diciembre"))
												v_enero_prox	=v_enero_prox	+	CDbl(f_presupuestado.ObtenerValor("enero_prox"))
												v_febrero_prox	=v_febrero_prox	+	CDbl(f_presupuestado.ObtenerValor("febrero_prox"))
											
											%>
											<tr bordercolor='#999999'>	
												<td><%=f_presupuestado.ObtenerValor("concepto")%></td>
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
											 <%
											 if f_presupuestado.ObtenerValor("concepto")<>"" then
											 	ind=0
												txt_concepto=f_presupuestado.ObtenerValor("concepto")
												
												set f_detalle = new CFormulario
												f_detalle.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
												f_detalle.Inicializar conexion2
											
												sql_detalle_concepto= "	 SELECT spru_ncorr,cod_pre,area_tdesc as area,concepto,detalle, isnull(total,0) as total,  "& vbCrLf &_
																	  " case isnull(leasing,0) when 1 then '<font color=Red>SI</font>' else 'NO' end as  usa_leasing, "& vbCrLf &_
																	  " isnull(enero,0) as enero,  isnull(febrero,0) as febrero,  isnull(marzo,0) as marzo,  isnull(abril,0) as abril,"& vbCrLf &_
																	  " isnull(mayo,0) as mayo,  isnull(junio,0) as junio,  isnull(julio,0) as julio,  isnull(agosto,0) as agosto,"& vbCrLf &_ 
																	  " isnull(septiembre,0) as septiembre, isnull(octubre,0) as octubre,  isnull(noviembre,0) as noviembre, "& vbCrLf &_
																	  " isnull(diciembre,0) as diciembre,  isnull(enero_prox,0) as enero_prox, isnull(febrero_prox,0) as febrero_prox  "& vbCrLf &_
																	  " FROM presupuesto_upa.protic.solicitud_presupuesto_upa a, presupuesto_upa.protic.area_presupuestal b  "& vbCrLf &_
																	  " where cod_area=area_ccod "& vbCrLf &_
																	  " and cod_anio="&v_prox_anio&" "& vbCrLf &_ 
																	  " "&sql_area&" "& vbCrLf &_
																	  " and concepto='"&txt_concepto&"' "
																										  
												'response.Write("<pre>"&sql_detalle_concepto&"</pre>")					  
												 f_detalle.Consultar sql_detalle_concepto
											 %>
											 <tr>
											 <td colspan="16">
											 <div id="tablachica">
											 	<table border="0" class="subtabla" width="98%"  cellpadding="0" cellspacing="0" align="right" bordercolorlight="#000033">
													<tr  bordercolor='#CCCCCC'>
														<th width="1%"></th>
														<th width="1%">LEASING</th>
														<th width="1%">codigo</th>
														<th width="15%">Area presupuesto </th>
														<th width="15%">Detalle</th>
														<th width="6%">Enero</th>
														<th width="6%">Febrero</th>
														<th width="6%">Marzo</th>
														<th width="6%">Abril</th>
														<th width="6%">Mayo</th>
														<th width="6%">Junio</th>
														<th width="6%">Julio</th>
														<th width="6%">Agosto</th>
														<th width="6%">Septiembre</th>
														<th width="6%">Octubre</th>
														<th width="6%">Noviembre</th>
														<th width="6%">Diciembre</th>
														<th width="6%">Enero prox.</th>
														<th width="6%">Febrero prox.</th>
														<th width="12%">Total</th>
														
													</tr>
													<% 
													while f_detalle.Siguiente 
													%>
													<tr class="color">
														<td>
														</td>
														<td><strong><%=f_detalle.ObtenerValor("usa_leasing")%></strong></td>
														<td><%=f_detalle.ObtenerValor("cod_pre")%></td>
														<td><font color="#003366"><%=f_detalle.ObtenerValor("area")%></font></td>
														<td><%=f_detalle.ObtenerValor("detalle")%></td>
														<td><%=f_detalle.ObtenerValor("enero")%></td>
														<td><%=f_detalle.ObtenerValor("febrero")%></td>
														<td><%=f_detalle.ObtenerValor("marzo")%></td>
														<td><%=f_detalle.ObtenerValor("abril")%></td>
														<td><%=f_detalle.ObtenerValor("mayo")%></td>
														<td><%=f_detalle.ObtenerValor("junio")%></td>
														<td><%=f_detalle.ObtenerValor("julio")%></td>
														<td><%=f_detalle.ObtenerValor("agosto")%></td>
														<td><%=f_detalle.ObtenerValor("septiembre")%></td>
														<td><%=f_detalle.ObtenerValor("octubre")%></td>
														<td><%=f_detalle.ObtenerValor("noviembre")%></td>
														<td><%=f_detalle.ObtenerValor("diciembre")%></td>
														<td><%=f_detalle.ObtenerValor("enero_prox")%></td>
														<td><%=f_detalle.ObtenerValor("febrero_prox")%></td>
														<td><%=f_detalle.ObtenerValor("total")%></td>
														
													</tr>
													<% 
													ind=ind+1
													wend
													%>
												</table>
												</div>
												</td>
											</tr>
											<% end if
											 
											 wend%>
											<tr bordercolor='#999999'>
											<td ><b>Totales</b></td>
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