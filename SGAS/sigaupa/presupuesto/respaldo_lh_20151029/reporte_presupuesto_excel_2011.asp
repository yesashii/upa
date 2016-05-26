<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 3000 

Response.AddHeader "Content-Disposition", "attachment;filename=ejecucion_presupuestaria.xls"
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
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "ejecucion_presupuestaria.xml", "botonera"
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

	sql_area_presu	= " select top 1 area_tdesc from presupuesto_upa.protic.area_presupuesto_usuario a, presupuesto_upa.protic.area_presupuestal b " & vbCrLf &_
					" where a.area_ccod=b.area_ccod " & vbCrLf &_
					" and rut_usuario="&v_usuario&"  and a.area_ccod="&area_ccod&"  "
	
	area_presupuesto = 	conexion2.consultaUno(sql_area_presu)

 

'----------------------------------------------------------------------------


 set f_presupuesto = new CFormulario
 f_presupuesto.Carga_Parametros "ejecucion_presupuestaria.xml", "f_presupuesto"
 f_presupuesto.Inicializar conexion2

   if Request.QueryString <> "" then
	  
	  if nro_t="" then
	  	nro_t=1
	  end if

	select case (nro_t)

		case 1:
			set f_presupuestado = new CFormulario
			f_presupuestado.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			f_presupuestado.Inicializar conexion2
			
			if codcaja <> "" then
			 
				sql_presupuestado	=" SELECT concepto, detalle, cod_pre,isnull(total,0) as total, "& vbCrLf &_
									" isnull(enero,0) as enero, isnull(febrero,0) as febrero, isnull(marzo,0) as marzo, isnull(abril,0) as abril, "& vbCrLf &_
									" isnull(mayo,0) as mayo, isnull(junio,0) as junio, isnull(julio,0) as julio, isnull(agosto,0) as agosto, "& vbCrLf &_
									" isnull(septiembre,0) as septiembre,isnull(octubre,0) as octubre, isnull(noviembre,0) as noviembre,  "& vbCrLf &_
									" isnull(diciembre,0) as diciembre, isnull(enero_prox,0) as enero_prox,isnull(febrero_prox,0) as febrero_prox "& vbCrLf &_
									"	FROM presupuesto_upa.protic.presupuesto_upa_2011 "& vbCrLf &_
									"	where cod_pre = '"&codcaja&"'  "
			else
				sql_presupuestado	=" SELECT concepto, detalle, cod_pre,isnull(total,0) as total, "& vbCrLf &_
									" isnull(enero,0) as enero, isnull(febrero,0) as febrero, isnull(marzo,0) as marzo, isnull(abril,0) as abril, "& vbCrLf &_
									" isnull(mayo,0) as mayo, isnull(junio,0) as junio, isnull(julio,0) as julio, isnull(agosto,0) as agosto, "& vbCrLf &_
									" isnull(septiembre,0) as septiembre,isnull(octubre,0) as octubre, isnull(noviembre,0) as noviembre,  "& vbCrLf &_
									" isnull(diciembre,0) as diciembre, isnull(enero_prox,0) as enero_prox,isnull(febrero_prox,0) as febrero_prox "& vbCrLf &_
									"	FROM presupuesto_upa.protic.presupuesto_upa_2011 "& vbCrLf &_
									"	where cod_pre in (select distinct cod_pre from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2011 where cod_area="&area_ccod&")  "
				codcaja="TODOS"
			end if
									
			f_presupuestado.consultar sql_presupuestado			
	
		case 2:
	
			set f_meses = new CFormulario
			f_meses.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			f_meses.Inicializar conexion2
			
			if codcaja <> "" then
								
					sql_meses= "select  upper(nombremes) as mes,indice as mes_venc,cast(isnull(presu_real,0) as numeric) as presu_real,   "& vbCrLf &_
							"    cast(isnull(presupuestado,0) as numeric) as presupuestado,  cast(isnull(desviacion,0) as numeric) as desviacion "& vbCrLf &_
							"		 from softland.sw_mesce as b  "& vbCrLf &_
							"         left outer join ( "& vbCrLf &_
							"			select pa.mes as mes, isnull(presu_real,0) as presu_real,presupuestado, presupuestado-isnull(presu_real,0) as desviacion "& vbCrLf &_
							"				from  "& vbCrLf &_
							"					(select sum(valor) as presupuestado,mes "& vbCrLf &_   
							"						from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2011    "& vbCrLf &_
							"						where cod_pre='"&codcaja&"' "& vbCrLf &_
							"						group by mes "& vbCrLf &_
							"					) as pa "& vbCrLf &_
							"					left outer join     "& vbCrLf &_
							"					(select isnull(sum(cast(movhaber as numeric)),0) as presu_real, cast(substring(b.efcodi,1,2) as numeric) as mes    "& vbCrLf &_
							"					from  softland.cwmovim a, softland.cwmovef b   "& vbCrLf &_   
							" 					where a.cpbnum=b.cpbnum " & vbCrLf &_
							"					and a.movnum=b.movnum " & vbCrLf &_
							" 					and a.movhaber=b.efmontohaber  " & vbCrLf &_
							"					and substring(b.efcodi,3,4)=2011  "& vbCrLf &_
							"					and a.cajcod='"&codcaja&"'  "& vbCrLf &_ 
							"					and a.movhaber <> 0      "& vbCrLf &_
							"					and a.pctcod like '2-10-070-10-000004'   "& vbCrLf &_  
							"					and a.cpbnum>0  group by cast(substring(b.efcodi,1,2) as numeric) "& vbCrLf &_
							"					) as pr   "& vbCrLf &_
							"				on pa.mes=pr.mes "& vbCrLf &_
							" 		)as a "& vbCrLf &_
							"	on indice=mes "								
			else
					sql_meses= "select  upper(nombremes) as mes,indice as mes_venc,cast(isnull(presu_real,0) as numeric) as presu_real,   "& vbCrLf &_
							"    cast(isnull(presupuestado,0) as numeric) as presupuestado,  cast(isnull(desviacion,0) as numeric) as desviacion "& vbCrLf &_
							"		 from softland.sw_mesce as b  "& vbCrLf &_
							"         left outer join ( "& vbCrLf &_
							"			select pa.mes as mes, isnull(presu_real,0) as presu_real,presupuestado, presupuestado-isnull(presu_real,0) as desviacion "& vbCrLf &_
							"				from  "& vbCrLf &_
							"					(select sum(valor) as presupuestado,mes "& vbCrLf &_   
							"						from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2011    "& vbCrLf &_
							"						where cod_pre in (select distinct cod_pre from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2011 where cod_area= "&area_ccod&" ) "& vbCrLf &_
							"						group by mes "& vbCrLf &_
							"					) as pa "& vbCrLf &_
							"					left outer join     "& vbCrLf &_
							"					(select isnull(sum(cast(movhaber as numeric)),0) as presu_real, cast(substring(b.efcodi,1,2) as numeric) as mes    "& vbCrLf &_
							"					from  softland.cwmovim a, softland.cwmovef b  "& vbCrLf &_   
							"					where a.cpbnum=b.cpbnum "& vbCrLf &_
							"					and a.movnum=b.movnum " & vbCrLf &_ 
							" 					and a.movhaber=b.efmontohaber "& vbCrLf &_ 
							"					and	substring(b.efcodi,3,4)=2011    "& vbCrLf &_
							"					and a.cajcod in (select distinct cod_pre from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2011 where cod_area= "&area_ccod&" )  "& vbCrLf &_ 
							"					and a.movhaber <> 0      "& vbCrLf &_
							"					and a.pctcod like '2-10-070-10-000004'   "& vbCrLf &_  
							"					and a.cpbnum>0  group by cast(substring(b.efcodi,1,2) as numeric) "& vbCrLf &_
							"					) as pr   "& vbCrLf &_
							"				on pa.mes=pr.mes "& vbCrLf &_
							" 		)as a "& vbCrLf &_
							"	on indice=mes  order by mes_venc asc"
							
				codcaja="TODOS"
			end if
	'response.Write(sql_meses)
			f_meses.consultar sql_meses	
	
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
							case 2:
							%>
								<p><b>Presupuestado vs Real </b></p>
								<br/>
								<p><b>Area Presupuestal:&nbsp;<font color="#0000CC" size="2"><%=area_presupuesto%></font>&nbsp;&nbsp;Código Presupuestario:&nbsp;<font color="#0000CC" size="2"><%=codcaja%></font></b></p>
								
                              <table border="1" align="left" width="100%" >
                                <tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
                                  <th>MES</th>
                                  <th>REAL</th>
                                  <th>PRESUPUESTADO</th>
                                  <th>DESV. MENSUAL</th>
								  <th>DESV. ACUMULADA</th>
                                </tr>
								<%
								v_total_real	=0
								v_total_presu	=0
								v_total_desvi	=0
								while f_meses.Siguiente
									v_total_real	=	v_total_real	+	Clng(f_meses.ObtenerValor("presu_real"))
									v_total_presu	=	v_total_presu	+	Clng(f_meses.ObtenerValor("presupuestado"))
									v_total_desvi	=	v_total_desvi	+	Clng(f_meses.ObtenerValor("desviacion"))
									v_desvi_acumul	=	Clng(v_total_presu)-Clng(v_total_real)
									
									if Clng(v_desvi_acumul)<0 then
										v_signo_a= "red"
									else
										v_signo_a= "black"
									end if
									
									if Clng(f_meses.ObtenerValor("desviacion"))<0 then
										v_signo= "red"
									else
										v_signo= "black"
									end if
								%>
								<tr bordercolor='#999999'>	
									
                                  <td><%f_meses.DibujaCampo("mes")%></td>
                                  <td align="right"><%=f_meses.ObtenerValor("presu_real")%></td>
                                  <td align="right"><%=f_meses.ObtenerValor("presupuestado")%></td>
                                  <td align="right"><font color="<%=v_signo%>"><%=f_meses.ObtenerValor("desviacion")%></font></td>
								  <td align="right"><font color="<%=v_signo_a%>"><%=v_desvi_acumul%></font></td>
                                </tr>
								 <%wend%>
								 <tr bordercolor='#999999'>
								 	<td><b>Totales</b></td>
									<td align="right"><b><%=v_total_real%></b></td>
									<td align="right"><b><%=v_total_presu%></b></td>
									<td align="right"><b><%=v_total_presu-v_total_real%></b></td>
									<td align="right"><b><%=v_desvi_acumul%></b></td>
								 </tr>
                              </table>
								 
							<%case 1:%>
								<p><b>Detalle del presupuestado</b></p>
								<br/>
								<p><b>Area Presupuestal:&nbsp;<font color="#0000CC" size="2"><%=area_presupuesto%></font>&nbsp;&nbsp;Código Presupuestario:&nbsp;<font color="#0000CC" size="2"><%=codcaja%></font></b></p>
									<table border="1" align="left" width="100%" >
										<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
										  <th>CONCEPTO</th>
										  <th>DETALLE</th>
										  <th>CODIGO</th>
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
										v_total		=	v_total		+	Clng(f_presupuestado.ObtenerValor("total"))
										v_enero		=	v_enero		+	Clng(f_presupuestado.ObtenerValor("enero"))
										v_febrero	=	v_febrero	+	Clng(f_presupuestado.ObtenerValor("febrero"))
										v_marzo		=	v_marzo		+	Clng(f_presupuestado.ObtenerValor("marzo"))
										v_abril		=	v_abril		+	Clng(f_presupuestado.ObtenerValor("abril"))
										v_mayo		=	v_mayo		+	Clng(f_presupuestado.ObtenerValor("mayo"))
										v_junio		=	v_junio		+	Clng(f_presupuestado.ObtenerValor("junio"))
										v_julio		=	v_julio		+	Clng(f_presupuestado.ObtenerValor("julio"))
										v_agosto	=	v_agosto	+	Clng(f_presupuestado.ObtenerValor("agosto"))
										v_septiembre=	v_septiembre	+	Clng(f_presupuestado.ObtenerValor("septiembre"))
										v_octubre	=	v_octubre		+	Clng(f_presupuestado.ObtenerValor("octubre"))
										v_noviembre	=	v_noviembre		+	Clng(f_presupuestado.ObtenerValor("noviembre"))
										v_diciembre	=	v_diciembre		+	Clng(f_presupuestado.ObtenerValor("diciembre"))
										v_enero_prox	=v_enero_prox	+	Clng(f_presupuestado.ObtenerValor("enero_prox"))
										v_febrero_prox	=v_febrero_prox	+	Clng(f_presupuestado.ObtenerValor("febrero_prox"))
									%>
									<tr bordercolor='#999999'>	
										<td><%=f_presupuestado.ObtenerValor("concepto")%></td>
										<td><%=f_presupuestado.ObtenerValor("detalle")%></td>
										<td><%=f_presupuestado.ObtenerValor("cod_pre")%></td>
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
							
							<%End Select%>
</body>
</html>