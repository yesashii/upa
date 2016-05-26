<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=indicador_morosidad.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 150000

set pagina = new CPagina
pagina.Titulo = "Indicador de Morosidad"

'-----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "indicador_morosidad.xml", "botonera"
'-----------------------------------------------------------------------
sede 		= request.querystring("busqueda[0][sede_ccod]")
facultad 	= request.querystring("busqueda[0][facu_ccod]")
carrera 	= request.querystring("busqueda[0][carr_ccod]")
fecha_corte	= request.querystring("busqueda[0][fecha_corte]")
fecha_inicio= request.querystring("busqueda[0][fecha_inicio]")

if fecha_corte <> "" and fecha_inicio <>"" then
	sql_fecha=" and convert(datetime,dcom_fcompromiso,103) between convert(datetime,'"&fecha_inicio&"',103) and convert(datetime,'"&fecha_corte&"',103)"
	msg= "Esta visualizando el indicador de morosidad entre los días <b>"&fecha_inicio&"</b> y <b>"&fecha_corte&"</b>"
end if

if fecha_corte <> "" and fecha_inicio="" then
	sql_fecha=" and convert(datetime,dcom_fcompromiso,103) <= convert(datetime,'"&fecha_corte&"',103)"
	msg= "Esta visualizando el indicador de morosidad historico hasta el dia: <b>"&fecha_corte&"</b>"
end if

if fecha_corte = "" and fecha_inicio <>"" then
	sql_fecha=" and convert(datetime,dcom_fcompromiso,103) >= convert(datetime,'"&fecha_inicio&"',103) "
	msg= "Esta visualizando el indicador de morosidad desde el día <b>"&fecha_inicio&"</b> a la fecha"
end if




set f_morosidad_total = new CFormulario
f_morosidad_total.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
f_morosidad_total.Inicializar conexion

sql_morosidad_total=" select item, pactado, saldo, saldo_doctos, cast(((saldo * 100.00)/pactado) as decimal(8,2)) as ind_total,"& vbCrLf &_
					"	cast(((saldo_doctos * 100.00)/pactado) as decimal(8,2)) as ind_doctos "& vbCrLf &_
					"	from (    "& vbCrLf &_
					"		 select item, sum(pactado) as pactado,sum (saldo) as saldo,sum(saldo_doctos) as saldo_doctos "& vbCrLf &_
					"			from ( "& vbCrLf &_
					"				select 'INDICADOR MOROSIDAD GENERAL' as item, sum(imup_monto_deuda) as pactado,sum(imup_monto_saldo) as saldo, "& vbCrLf &_
					"				case when ting_ccod in (3,38,4,87,52) then isnull(sum(imup_monto_saldo),0) end as saldo_doctos "& vbCrLf &_
					"					from indicador_morosidad_upa   "& vbCrLf &_
					"					where 1=1 "& vbCrLf &_
					"					"&sql_fecha&" "& vbCrLf &_   
					"					group by ting_ccod "& vbCrLf &_
					"			) as sumatoria "& vbCrLf &_
					"		group by item "& vbCrLf &_
					"	) as tabla_final "& vbCrLf &_
					"	order by item "

f_morosidad_total.consultar sql_morosidad_total		

set f_morosidad_general = new CFormulario
f_morosidad_general.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
f_morosidad_general.Inicializar conexion

sql_morosidad=	" select item,  "& vbCrLf &_
				" letras,dletras,case when dletras=0 then 0 else cast(((letras * 100.00)/dletras) as decimal(8,2)) end as ind_letras, "& vbCrLf &_
				" cheques,dcheques,case when dcheques=0 then 0 else cast(((cheques * 100.00)/dcheques) as decimal(8,2)) end as ind_cheques, "& vbCrLf &_
				" pagares,dpagares,case when dpagares=0 then 0 else cast(((pagares * 100.00)/dpagares) as decimal(8,2)) end as ind_pagares, "& vbCrLf &_
				" otros,dotros,case when dotros=0 then 0 else cast(((otros * 100.00)/dotros) as decimal(8,2)) end as ind_otros "& vbCrLf &_
				" from ( "& vbCrLf &_
					"select 'INDICADOR MOROSIDAD GENERAL' as item, "& vbCrLf &_
					"	isnull(sum(letra),0) as letras, isnull(sum(cheque),0) as cheques,isnull(sum(pagare),0) as pagares, isnull(sum(otros),0) as otros, "& vbCrLf &_
					"	isnull(sum(dletra),0) as dletras, isnull(sum(dcheque),0) as dcheques,isnull(sum(dpagare),0) as dpagares,isnull(sum(dotros),0) as dotros "& vbCrLf &_
					" from ( "& vbCrLf &_   
					"		select "& vbCrLf &_   
					"		case when ting_ccod in (4,87) then isnull(sum(imup_monto_saldo),0) end as letra, "& vbCrLf &_
					"		case when ting_ccod in (3,38) then isnull(sum(imup_monto_saldo),0) end as cheque, "& vbCrLf &_
					"		case when ting_ccod=52 then isnull(sum(imup_monto_saldo),0) end as pagare, "& vbCrLf &_
					"		case when isnull(ting_ccod,0) not in (3,4,38,52,87) then isnull(sum(imup_monto_saldo),0) end as otros, "& vbCrLf &_
					"		case when ting_ccod in (4,87) then isnull(sum(imup_monto_deuda),0) end as dletra, "& vbCrLf &_
					"		case when ting_ccod in (3,38) then isnull(sum(imup_monto_deuda),0) end as dcheque, "& vbCrLf &_
					"		case when ting_ccod=52 then isnull(sum(imup_monto_deuda),0) end as dpagare, "& vbCrLf &_
					"		case when isnull(ting_ccod,0) not in (3,4,38,52,87) then isnull(sum(imup_monto_deuda),0) end as dotros "& vbCrLf &_
					"		from indicador_morosidad_upa  "& vbCrLf &_   
					"		where 1=1 "& vbCrLf &_   
					"		"&sql_fecha&" "& vbCrLf &_   
					"		group by ting_ccod "& vbCrLf &_   
					"	) as tabla "& vbCrLf &_
				"	) as tabla"& vbCrLf &_
				"	order by item "

'response.Write("<pre>"&sql_morosidad&"</pre>")

f_morosidad_general.consultar sql_morosidad		
'----------------------------------------------------------------------------

set f_morosidad_sede = new CFormulario
f_morosidad_sede.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
f_morosidad_sede.Inicializar conexion

if sede = "" then
	sql_sede="a.sede_ccod in (1,2,4,5,6,7,8)"
else
	sql_sede="a.sede_ccod="&sede
end if

sql_morosidad_sede= " select item,  "& vbCrLf &_
						" letras,dletras,case when dletras=0 then 0 else cast(((letras * 100.00)/dletras) as decimal(8,2)) end as ind_letras, "& vbCrLf &_
						" cheques,dcheques,case when dcheques=0 then 0 else cast(((cheques * 100.00)/dcheques) as decimal(8,2)) end as ind_cheques, "& vbCrLf &_
						" pagares,dpagares,case when dpagares=0 then 0 else cast(((pagares * 100.00)/dpagares) as decimal(8,2)) end as ind_pagares, "& vbCrLf &_
						" otros,dotros,case when dotros=0 then 0 else cast(((otros * 100.00)/dotros) as decimal(8,2)) end as ind_otros "& vbCrLf &_
						" from ( "& vbCrLf &_
							"select sede as item, "& vbCrLf &_
							"	isnull(sum(letra),0) as letras, isnull(sum(cheque),0) as cheques,isnull(sum(pagare),0) as pagares, isnull(sum(otros),0) as otros, "& vbCrLf &_
							"	isnull(sum(dletra),0) as dletras, isnull(sum(dcheque),0) as dcheques,isnull(sum(dpagare),0) as dpagares,isnull(sum(dotros),0) as dotros "& vbCrLf &_
							"from ("& vbCrLf &_
							"    select a.sede_tdesc as sede,"& vbCrLf &_
								"		case when ting_ccod in (4,87) then isnull(sum(imup_monto_saldo),0) end as letra, "& vbCrLf &_
								"		case when ting_ccod in (3,38) then isnull(sum(imup_monto_saldo),0) end as cheque, "& vbCrLf &_
								"		case when ting_ccod=52 then isnull(sum(imup_monto_saldo),0) end as pagare, "& vbCrLf &_
								"		case when isnull(ting_ccod,0) not in (3,4,38,52,87) then isnull(sum(imup_monto_saldo),0) end as otros, "& vbCrLf &_
								"		case when ting_ccod in (4,87) then isnull(sum(imup_monto_deuda),0) end as dletra, "& vbCrLf &_
								"		case when ting_ccod in (3,38) then isnull(sum(imup_monto_deuda),0) end as dcheque, "& vbCrLf &_
								"		case when ting_ccod=52 then isnull(sum(imup_monto_deuda),0) end as dpagare, "& vbCrLf &_
								"		case when isnull(ting_ccod,0) not in (3,4,38,52,87) then isnull(sum(imup_monto_deuda),0) end as dotros "& vbCrLf &_
							"    from sedes a left outer join indicador_morosidad_upa b "& vbCrLf &_ 
							"        on a.sede_ccod=b.sede_ccod_actual"& vbCrLf &_
							"		"&sql_fecha&" "& vbCrLf &_   
							"        where "&sql_sede&" "& vbCrLf &_
							"        group by a.sede_ccod,ting_ccod, a.sede_tdesc"& vbCrLf &_
							") as tabla"& vbCrLf &_
							"group by sede "& vbCrLf &_
						"	) as tabla"& vbCrLf &_
						"	order by item "

f_morosidad_sede.consultar sql_morosidad_sede		


set f_morosidad_facultad = new CFormulario
f_morosidad_facultad.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
f_morosidad_facultad.Inicializar conexion

if facultad <> "" then
	sql_facultad=" and e.facu_ccod="&facultad
end if

sql_morosidad_facultad= " select item,  "& vbCrLf &_
						" letras,dletras,case when dletras=0 then 0 else cast(((letras * 100.00)/dletras) as decimal(8,2)) end as ind_letras, "& vbCrLf &_
						" cheques,dcheques,case when dcheques=0 then 0 else cast(((cheques * 100.00)/dcheques) as decimal(8,2)) end as ind_cheques, "& vbCrLf &_
						" pagares,dpagares,case when dpagares=0 then 0 else cast(((pagares * 100.00)/dpagares) as decimal(8,2)) end as ind_pagares, "& vbCrLf &_
						" otros,dotros,case when dotros=0 then 0 else cast(((otros * 100.00)/dotros) as decimal(8,2)) end as ind_otros "& vbCrLf &_
						" from ( "& vbCrLf &_
							"select facu_tdesc as item, "& vbCrLf &_
							"	isnull(sum(letra),0) as letras, isnull(sum(cheque),0) as cheques,isnull(sum(pagare),0) as pagares, isnull(sum(otros),0) as otros, "& vbCrLf &_
							"	isnull(sum(dletra),0) as dletras, isnull(sum(dcheque),0) as dcheques,isnull(sum(dpagare),0) as dpagares,isnull(sum(dotros),0) as dotros "& vbCrLf &_
							"from  "& vbCrLf &_
							"facultades fac left outer join ( "& vbCrLf &_
							"	select e.facu_ccod, "& vbCrLf &_
							"		case when ting_ccod in (4,87) then isnull(sum(imup_monto_saldo),0) end as letra, "& vbCrLf &_
							"		case when ting_ccod in (3,38) then isnull(sum(imup_monto_saldo),0) end as cheque, "& vbCrLf &_
							"		case when ting_ccod=52 then isnull(sum(imup_monto_saldo),0) end as pagare, "& vbCrLf &_
							"		case when isnull(ting_ccod,0) not in (3,4,38,52,87) then isnull(sum(imup_monto_saldo),0) end as otros, "& vbCrLf &_
							"		case when ting_ccod in (4,87) then isnull(sum(imup_monto_deuda),0) end as dletra, "& vbCrLf &_
							"		case when ting_ccod in (3,38) then isnull(sum(imup_monto_deuda),0) end as dcheque, "& vbCrLf &_
							"		case when ting_ccod=52 then isnull(sum(imup_monto_deuda),0) end as dpagare, "& vbCrLf &_
							"		case when isnull(ting_ccod,0) not in (3,4,38,52,87) then isnull(sum(imup_monto_deuda),0) end as dotros "& vbCrLf &_
							"	from ofertas_academicas a join especialidades b"& vbCrLf &_
							"		on a.espe_ccod=b.espe_ccod "& vbCrLf &_
							"	join carreras c "& vbCrLf &_
							"		on b.carr_ccod=c.carr_ccod "& vbCrLf &_
							"	join areas_academicas d "& vbCrLf &_
							"		on c.area_ccod=d.area_ccod "& vbCrLf &_
							"	join facultades e "& vbCrLf &_
							"		on d.facu_ccod=e.facu_ccod "& vbCrLf &_
							" "&sql_facultad&" "& vbCrLf &_
							"	join indicador_morosidad_upa f "& vbCrLf &_
							"		on a.ofer_ncorr=f.ofer_ncorr_actual "& vbCrLf &_
							"		"&sql_fecha&" "& vbCrLf &_   
							"	group by e.facu_ccod,ting_ccod "& vbCrLf &_
							" ) as mfac "& vbCrLf &_
							" on fac.facu_ccod=mfac.facu_ccod "& vbCrLf &_
							" group by fac.facu_ccod,facu_tdesc "& vbCrLf &_
						"	) as tabla"& vbCrLf &_
						"	order by item "

f_morosidad_facultad.consultar sql_morosidad_facultad

set f_morosidad_escuela = new CFormulario
f_morosidad_escuela.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
f_morosidad_escuela.Inicializar conexion

if carrera <> "" then
	sql_carrera=" and c.carr_ccod="&carrera
end if

sql_morosidad_escuela=  " select item,jornada,  "& vbCrLf &_
						" letras,dletras,case when dletras=0 then 0 else cast(((letras * 100.00)/dletras) as decimal(8,2)) end as ind_letras, "& vbCrLf &_
						" cheques,dcheques,case when dcheques=0 then 0 else cast(((cheques * 100.00)/dcheques) as decimal(8,2)) end as ind_cheques, "& vbCrLf &_
						" pagares,dpagares,case when dpagares=0 then 0 else cast(((pagares * 100.00)/dpagares) as decimal(8,2)) end as ind_pagares, "& vbCrLf &_
						" otros,dotros,case when dotros=0 then 0 else cast(((otros * 100.00)/dotros) as decimal(8,2)) end as ind_otros "& vbCrLf &_
						" from ( "& vbCrLf &_
						" select carr_tdesc as item,jorn_tdesc as jornada, "& vbCrLf &_
						"	isnull(sum(letra),0) as letras, isnull(sum(cheque),0) as cheques,isnull(sum(pagare),0) as pagares,isnull(sum(otros),0) as otros,  "& vbCrLf &_ 
						"	isnull(sum(dletra),0) as dletras, isnull(sum(dcheque),0) as dcheques,isnull(sum(dpagare),0) as dpagares,isnull(sum(dotros),0) as dotros "& vbCrLf &_
						" from  "& vbCrLf &_
						" ( "& vbCrLf &_
						"	select c.carr_ccod,d.jorn_ccod,jorn_tdesc,carr_tdesc, "& vbCrLf &_
						"		case when ting_ccod in (4,87) then isnull(sum(imup_monto_saldo),0) end as letra, "& vbCrLf &_
						"		case when ting_ccod in (3,38) then isnull(sum(imup_monto_saldo),0) end as cheque, "& vbCrLf &_
						"		case when ting_ccod=52 then isnull(sum(imup_monto_saldo),0) end as pagare, "& vbCrLf &_
						"		case when isnull(ting_ccod,0) not in (3,4,38,52,87) then isnull(sum(imup_monto_saldo),0) end as otros, "& vbCrLf &_
						"		case when ting_ccod in (4,87) then isnull(sum(imup_monto_deuda),0) end as dletra, "& vbCrLf &_
						"		case when ting_ccod in (3,38) then isnull(sum(imup_monto_deuda),0) end as dcheque, "& vbCrLf &_
						"		case when ting_ccod=52 then isnull(sum(imup_monto_deuda),0) end as dpagare, "& vbCrLf &_
						"		case when isnull(ting_ccod,0) not in (3,4,38,52,87) then isnull(sum(imup_monto_deuda),0) end as dotros "& vbCrLf &_
						"	from ofertas_academicas a join especialidades b "& vbCrLf &_
						"		on a.espe_ccod=b.espe_ccod "& vbCrLf &_
						"	join carreras c "& vbCrLf &_
						"		on b.carr_ccod=c.carr_ccod "& vbCrLf &_
						"		--and tcar_ccod=1 "& vbCrLf &_
						" "&sql_carrera&" "& vbCrLf &_
						"	join jornadas d "& vbCrLf &_
						"		on a.jorn_ccod=d.jorn_ccod  "& vbCrLf &_        
						"	join indicador_morosidad_upa f "& vbCrLf &_
						"		on a.ofer_ncorr=f.ofer_ncorr_actual "& vbCrLf &_
						"		"&sql_fecha&" "& vbCrLf &_   
						"	group by c.carr_ccod,d.jorn_ccod,ting_ccod,jorn_tdesc,carr_tdesc "& vbCrLf &_
						") as mcar "& vbCrLf &_
						"group by carr_tdesc,jorn_tdesc "& vbCrLf &_
						"	) as tabla"& vbCrLf &_
						"	order by item,jornada "
						
f_morosidad_escuela.consultar sql_morosidad_escuela	

%>


<html>
<head>
<title><%=pagina.Titulo%></title>
</head>
<body>
<div align="center"><%pagina.DibujarTituloPagina%></div><br>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td>
				<center><font size="2" color="#0033FF"><%=msg%></font></center>
			     <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>
						<table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
								
								<tr>
							  		<td align="left"><br/><strong>Indicadores Totales Universidad</strong></td>
								</tr>
								<tr>
									<td>
									<table class=v1 border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD' id='tb_a'>
								     <tr bgcolor='#C4D7FF' bordercolor='#999999'>
										<th align="center"><font color='#333333'>Item</font></th>
											<th align="center"><font color='#333333'>Pactado </font></th>
											<th align="center"><font color='#333333'>Saldo Total </font></th>
											<th align="center"><font color='#333333'>Saldo Doctos </font></th>
											<th align="center"><font color='#333333'>Indicador vs Total </font></th>
											<th align="center"><font color='#333333'>Indicador vs Doctos </font></th>
									  </tr>
									<%  
									 while f_morosidad_total.Siguiente
									 	v_pactado	=	v_pactado	+	CDbl(f_morosidad_total.ObtenerValor("pactado"))
										v_saldo		=	v_saldo		+	CDbl(f_morosidad_total.ObtenerValor("saldo"))
										v_saldo_doctos		=	v_saldo_doctos		+	CDbl(f_morosidad_total.ObtenerValor("saldo_doctos"))
										ind_total	=	ind_total	+	CDbl(f_morosidad_total.ObtenerValor("ind_total"))
										ind_doctos	=	ind_doctos	+	CDbl(f_morosidad_total.ObtenerValor("ind_doctos"))
									 wend											
										 %>
										<tr align='right'>
											<th ><strong>Indicador Total:</strong></th>
											<th><%=formatcurrency(v_pactado,0)%></th>
											<th><%=formatcurrency(v_saldo,0)%></th>
											<th><%=formatcurrency(v_saldo_doctos,0)%></th>
											<th><%=ind_total%>%</th>
											<th><%=ind_doctos%>%</th>
										 </tr>
										</table>	
								</td>
							</tr>
							<tr>
							  <td align="left"><br/><strong>Indicadores Generales Universidad</strong></td>
							</tr>
							<tr>
								<td align="center">
                                    <table class=v1 width='100%' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD' id='tb_a'>
								     <tr bgcolor='#C4D7FF' bordercolor='#999999'>
											<th align="center"><font color='#333333'>Item</font></th>
											<th align="center"><font color='#333333'>Pactado Letra</font></th>
											<th align="center"><font color='#333333'>Saldo Letra</font></th>
											<th align="center"><font color='#333333'>Indicador</font></th>
											<th align="center"><font color='#333333'>Pactado Cheque</font></th>
											<th align="center"><font color='#333333'>Saldo Cheque</font></th>
											<th align="center"><font color='#333333'>Indicador</font></th>
											<th align="center"><font color='#333333'>Pactado Pagare</font></th>
											<th align="center"><font color='#333333'>Saldo Pagare</font></th>
											<th align="center"><font color='#333333'>Indicador</font></th>
											<th align="center"><font color='#333333'>Pactado Doctos</font></th>
											<th align="center"><font color='#333333'>Saldo Doctos</font></th>
											<th align="center"><font color='#333333'>Indicador</font></th>											
									  </tr>
									<%  
									 while f_morosidad_general.Siguiente
									 	v_letra	=	v_letra		+	CDbl(f_morosidad_general.ObtenerValor("letras"))
										v_cheque=	v_cheque	+	CDbl(f_morosidad_general.ObtenerValor("cheques"))
										v_pagare=	v_pagare	+	CDbl(f_morosidad_general.ObtenerValor("pagares"))
										v_otros	=	v_otros		+	CDbl(f_morosidad_general.ObtenerValor("otros"))
										v_dletra	=	v_dletra		+	CDbl(f_morosidad_general.ObtenerValor("dletras"))
										v_dcheque	=	v_dcheque		+	CDbl(f_morosidad_general.ObtenerValor("dcheques"))
										v_dpagare	=	v_dpagare		+	CDbl(f_morosidad_general.ObtenerValor("dpagares"))
										v_dotros 	=	v_dotros		+	CDbl(f_morosidad_general.ObtenerValor("dotros"))	
										
										v_suma_doctos	= CDbl(f_morosidad_general.ObtenerValor("letras"))+CDbl(f_morosidad_general.ObtenerValor("cheques"))+CDbl(f_morosidad_general.ObtenerValor("pagares"))
										v_suma_ddoctos	= CDbl(f_morosidad_general.ObtenerValor("dletras"))+CDbl(f_morosidad_general.ObtenerValor("dcheques"))+CDbl(f_morosidad_general.ObtenerValor("dpagares"))
										
										if v_suma_ddoctos=0 then
											v_ind_doctos="0%"
										else
											v_ind_doctos	= FormatPercent(v_suma_doctos/v_suma_ddoctos)
										end if
										
										v_doctos	= v_doctos 	+ v_suma_doctos	
										v_ddoctos	= v_ddoctos + v_suma_ddoctos
																			
									%>
								     <tr bgcolor="#FFFFFF" align='right'>
									    	<td align='LEFT'><%=f_morosidad_general.ObtenerValor("item")%></td>
											<td><%=formatcurrency(CDbl(f_morosidad_general.ObtenerValor("dletras")),0)%></td>
											<td><%=formatcurrency(CDbl(f_morosidad_general.ObtenerValor("letras")),0)%></td>
											<td><strong><%=f_morosidad_general.ObtenerValor("ind_letras")%>%</strong></td>
											<td><%=formatcurrency(CDbl(f_morosidad_general.ObtenerValor("dcheques")),0)%></td>
											<td><%=formatcurrency(CDbl(f_morosidad_general.ObtenerValor("cheques")),0)%></td>
											<td><strong><%=f_morosidad_general.ObtenerValor("ind_cheques")%>%</strong></td>
											<td><%=formatcurrency(CDbl(f_morosidad_general.ObtenerValor("dpagares")),0)%></td>
											<td><%=formatcurrency(CDbl(f_morosidad_general.ObtenerValor("pagares")),0)%></td>
											<td><strong><%=f_morosidad_general.ObtenerValor("ind_pagares")%>%</strong></td>
											<td><%=formatcurrency(v_suma_ddoctos,0)%></td>
											<td><%=formatcurrency(v_suma_doctos,0)%></td>
											<td><strong><%=v_ind_doctos%>%</strong></td>											
									  </tr> 
									<%wend											
											if v_dletra=0 then
												ind_letra="0%"
											else
												ind_letra=FormatPercent(v_letra/v_dletra)
											end if
											 
											if v_dcheque=0 then
												ind_cheque="0%"
											else
												ind_cheque=FormatPercent(v_cheque/v_dcheque)
											end if
											 
											if v_dpagare=0 then
												ind_pagare="0%"
											else
												ind_pagare=FormatPercent(v_pagare/v_dpagare)
											end if
											 
											if v_dotros=0 then
												ind_otros="0%"
											else
												ind_otros=FormatPercent(v_otros/v_dotros)
											end if
										 
										 	if v_ddoctos=0 then
												ind_doctos="0%"
											else
												ind_doctos=FormatPercent(v_doctos/v_ddoctos)
											end if
										 %>
										<tr align='right'>
											<th ><strong>Total:</strong></th>
											<th><%=formatcurrency(v_dletra,0)%></th>
											<th><%=formatcurrency(v_letra,0)%></th>
											<th><%=ind_letra%></th>
											<th><%=formatcurrency(v_dcheque,0)%></th>
											<th><%=formatcurrency(v_cheque,0)%></th>
											<th><%=ind_cheque%></th>
											<th><%=formatcurrency(v_dpagare,0)%></th>
											<th><%=formatcurrency(v_pagare,0)%></th>
											<th><%=ind_pagare%></th>
											<th><%=formatcurrency(v_ddoctos,0)%></th>
											<th><%=formatcurrency(v_doctos,0)%></th>
											<th><%=ind_doctos%></th>	
										 </tr>
										</table>	
								</td>
							</tr>
							<tr>
                             <td align="left"><br/></td>
                            </tr>
							<tr>
                             <td align="left"><br/><strong>Indicadores por Sede&nbsp;</strong></td>
                            </tr>
                            <tr>
                                 <td align="center">
								 	
                                    <table class=v1 width='100%' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD' id='tb_a'>
								     <tr bgcolor='#C4D7FF' bordercolor='#999999'>
											<th align="center"><font color='#333333'>Item</font></th>
											<th align="center"><font color='#333333'>Pactado Letra</font></th>
											<th align="center"><font color='#333333'>Saldo Letra</font></th>
											<th align="center"><font color='#333333'>Indicador</font></th>
											<th align="center"><font color='#333333'>Pactado Cheque</font></th>
											<th align="center"><font color='#333333'>Saldo Cheque</font></th>
											<th align="center"><font color='#333333'>Indicador</font></th>
											<th align="center"><font color='#333333'>Pactado Pagare</font></th>
											<th align="center"><font color='#333333'>Saldo Pagare</font></th>
											<th align="center"><font color='#333333'>Indicador</font></th>
											<th align="center"><font color='#333333'>Pactado Doctos</font></th>
											<th align="center"><font color='#333333'>Saldo Doctos</font></th>
											<th align="center"><font color='#333333'>Indicador</font></th>											
									  </tr> 
									 <%  
									 	v_letra	=	0
										v_cheque=	0
										v_pagare=	0
										v_otros	=	0
										v_dletra=	0
										v_dcheque=	0
										v_dpagare=	0
										v_dotros=	0	
										v_doctos=0
										v_ddoctos=0										
									 while f_morosidad_sede.Siguiente
										v_letra	=	v_letra		+	CDbl(f_morosidad_sede.ObtenerValor("letras"))
										v_cheque=	v_cheque	+	CDbl(f_morosidad_sede.ObtenerValor("cheques"))
										v_pagare=	v_pagare	+	CDbl(f_morosidad_sede.ObtenerValor("pagares"))
										v_otros	=	v_otros		+	CDbl(f_morosidad_sede.ObtenerValor("otros"))
										v_dletra	=	v_dletra		+	CDbl(f_morosidad_sede.ObtenerValor("dletras"))
										v_dcheque	=	v_dcheque		+	CDbl(f_morosidad_sede.ObtenerValor("dcheques"))
										v_dpagare	=	v_dpagare		+	CDbl(f_morosidad_sede.ObtenerValor("dpagares"))
										v_dotros 	=	v_dotros		+	CDbl(f_morosidad_sede.ObtenerValor("dotros"))	

										v_suma_doctos	= CDbl(f_morosidad_sede.ObtenerValor("letras"))+CDbl(f_morosidad_sede.ObtenerValor("cheques"))+CDbl(f_morosidad_sede.ObtenerValor("pagares"))
										v_suma_ddoctos	= CDbl(f_morosidad_sede.ObtenerValor("dletras"))+CDbl(f_morosidad_sede.ObtenerValor("dcheques"))+CDbl(f_morosidad_sede.ObtenerValor("dpagares"))
										if v_suma_ddoctos=0 then
											v_ind_doctos="0%"
										else
											v_ind_doctos	= FormatPercent(v_suma_doctos/v_suma_ddoctos)
										end if
										
										v_doctos	= v_doctos 	+ v_suma_doctos	
										v_ddoctos	= v_ddoctos + v_suma_ddoctos																			
									%>
								     <tr bgcolor="#FFFFFF" align='right'>
									    <td class='noclick' align='LEFT' width="40%"  ><%=f_morosidad_sede.ObtenerValor("item")%></td>
											<td><%=formatcurrency(CDbl(f_morosidad_sede.ObtenerValor("dletras")),0)%></td>
											<td><%=formatcurrency(CDbl(f_morosidad_sede.ObtenerValor("letras")),0)%></td>
											<td><strong><%=f_morosidad_sede.ObtenerValor("ind_letras")%>%</strong></td>
											<td><%=formatcurrency(CDbl(f_morosidad_sede.ObtenerValor("dcheques")),0)%></td>
											<td><%=formatcurrency(CDbl(f_morosidad_sede.ObtenerValor("cheques")),0)%></td>
											<td><strong><%=f_morosidad_sede.ObtenerValor("ind_cheques")%>%</strong></td>
											<td><%=formatcurrency(CDbl(f_morosidad_sede.ObtenerValor("dpagares")),0)%></td>
											<td><%=formatcurrency(CDbl(f_morosidad_sede.ObtenerValor("pagares")),0)%></td>
											<td><strong><%=f_morosidad_sede.ObtenerValor("ind_pagares")%>%</strong></td>
											<td><%=formatcurrency(v_suma_ddoctos,0)%></td>
											<td><%=formatcurrency(v_suma_doctos,0)%></td>
											<td><strong><%=v_ind_doctos%>%</strong></td>											
									  </tr> 
									 <%wend
									 		if v_dletra=0 then
												ind_letra="0%"
											else
												ind_letra=FormatPercent(v_letra/v_dletra)
											end if
											 
											if v_dcheque=0 then
												ind_cheque="0%"
											else
												ind_cheque=FormatPercent(v_cheque/v_dcheque)
											end if
											 
											if v_dpagare=0 then
												ind_pagare="0%"
											else
												ind_pagare=FormatPercent(v_pagare/v_dpagare)
											end if
											 
											if v_dotros=0 then
												ind_otros="0%"
											else
												ind_otros=FormatPercent(v_otros/v_dotros)
											end if

											if v_ddoctos=0 then
												ind_doctos="0%"
											else
												ind_doctos=FormatPercent(v_doctos/v_ddoctos)
											end if
									 %>
									 <tr align='right'>
									 	<th><strong>Total:</strong></th>
											<th><%=formatcurrency(v_dletra,0)%></th>
											<th><%=formatcurrency(v_letra,0)%></th>
											<th><%=ind_letra%></th>
											<th><%=formatcurrency(v_dcheque,0)%></th>
											<th><%=formatcurrency(v_cheque,0)%></th>
											<th><%=ind_cheque%></th>
											<th><%=formatcurrency(v_dpagare,0)%></th>
											<th><%=formatcurrency(v_pagare,0)%></th>
											<th><%=ind_pagare%></th>
											<th><%=formatcurrency(v_ddoctos,0)%></th>
											<th><%=formatcurrency(v_doctos,0)%></th>
											<th><%=ind_doctos%></th>	
									  </tr>
								    </table>	
							  </td>
                            </tr>
							<tr>
                             <td align="left"><br/></td>
                            </tr>
							<tr>
                             <td align="left"><br/><strong>Indicadores por Facultad</strong></td>
                            </tr>
                            <tr>
                                 <td align="center">
                                    <table class=v1 width='100%' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD' id='tb_a'>
								     <tr bgcolor='#C4D7FF' bordercolor='#999999'>
											<th align="center"><font color='#333333'>Item</font></th>
											<th align="center"><font color='#333333'>Pactado Letra</font></th>
											<th align="center"><font color='#333333'>Saldo Letra</font></th>
											<th align="center"><font color='#333333'>Indicador</font></th>
											<th align="center"><font color='#333333'>Pactado Cheque</font></th>
											<th align="center"><font color='#333333'>Saldo Cheque</font></th>
											<th align="center"><font color='#333333'>Indicador</font></th>
											<th align="center"><font color='#333333'>Pactado Pagare</font></th>
											<th align="center"><font color='#333333'>Saldo Pagare</font></th>
											<th align="center"><font color='#333333'>Indicador</font></th>
											<th align="center"><font color='#333333'>Pactado Doctos</font></th>
											<th align="center"><font color='#333333'>Saldo Doctos</font></th>
											<th align="center"><font color='#333333'>Indicador</font></th>											
									  </tr> 
								     <%  
									 	v_letra	=	0
										v_cheque=	0
										v_pagare=	0
										v_otros	=	0
										v_dletra=	0
										v_dcheque=	0
										v_dpagare=	0
										v_dotros=	0
										v_doctos=0
										v_ddoctos=0											
									 while f_morosidad_facultad.Siguiente
										v_letra	=	v_letra		+	CDbl(f_morosidad_facultad.ObtenerValor("letras"))
										v_cheque=	v_cheque	+	CDbl(f_morosidad_facultad.ObtenerValor("cheques"))
										v_pagare=	v_pagare	+	CDbl(f_morosidad_facultad.ObtenerValor("pagares"))
										v_otros	=	v_otros		+	CDbl(f_morosidad_facultad.ObtenerValor("otros"))
										v_dletra	=	v_dletra		+	CDbl(f_morosidad_facultad.ObtenerValor("dletras"))
										v_dcheque	=	v_dcheque		+	CDbl(f_morosidad_facultad.ObtenerValor("dcheques"))
										v_dpagare	=	v_dpagare		+	CDbl(f_morosidad_facultad.ObtenerValor("dpagares"))
										v_dotros 	=	v_dotros		+	CDbl(f_morosidad_facultad.ObtenerValor("dotros"))	
											
										v_suma_doctos	= CDbl(f_morosidad_facultad.ObtenerValor("letras"))+CDbl(f_morosidad_facultad.ObtenerValor("cheques"))+CDbl(f_morosidad_facultad.ObtenerValor("pagares"))
										v_suma_ddoctos	= CDbl(f_morosidad_facultad.ObtenerValor("dletras"))+CDbl(f_morosidad_facultad.ObtenerValor("dcheques"))+CDbl(f_morosidad_facultad.ObtenerValor("dpagares"))
										if v_suma_ddoctos=0 then
											v_ind_doctos="0%"
										else
											v_ind_doctos	= FormatPercent(v_suma_doctos/v_suma_ddoctos)
										end if
										
										v_doctos	= v_doctos 	+ v_suma_doctos	
										v_ddoctos	= v_ddoctos + v_suma_ddoctos																		
									%>
								     <tr bgcolor="#FFFFFF" align='right'>
									    <td class='noclick' align='LEFT' width="40%"  ><%=f_morosidad_facultad.ObtenerValor("item")%></td>
											<td><%=formatcurrency(CDbl(f_morosidad_facultad.ObtenerValor("dletras")),0)%></td>
											<td><%=formatcurrency(CDbl(f_morosidad_facultad.ObtenerValor("letras")),0)%></td>
											<td><strong><%=f_morosidad_facultad.ObtenerValor("ind_letras")%>%</strong></td>
											<td><%=formatcurrency(CDbl(f_morosidad_facultad.ObtenerValor("dcheques")),0)%></td>
											<td><%=formatcurrency(CDbl(f_morosidad_facultad.ObtenerValor("cheques")),0)%></td>
											<td><strong><%=f_morosidad_facultad.ObtenerValor("ind_cheques")%>%</strong></td>
											<td><%=formatcurrency(CDbl(f_morosidad_facultad.ObtenerValor("dpagares")),0)%></td>
											<td><%=formatcurrency(CDbl(f_morosidad_facultad.ObtenerValor("pagares")),0)%></td>
											<td><strong><%=f_morosidad_facultad.ObtenerValor("ind_pagares")%>%</strong></td>
											<td><%=formatcurrency(v_suma_ddoctos,0)%></td>
											<td><%=formatcurrency(v_suma_doctos,0)%></td>
											<td><strong><%=v_ind_doctos%>%</strong></td>											
									  </tr> 
									 <%wend
									 
									 		if v_dletra=0 then
												ind_letra="0%"
											else
												ind_letra=FormatPercent(v_letra/v_dletra)
											end if
											 
											if v_dcheque=0 then
												ind_cheque="0%"
											else
												ind_cheque=FormatPercent(v_cheque/v_dcheque)
											end if
											 
											if v_dpagare=0 then
												ind_pagare="0%"
											else
												ind_pagare=FormatPercent(v_pagare/v_dpagare)
											end if
											 
											if v_dotros=0 then
												ind_otros="0%"
											else
												ind_otros=FormatPercent(v_otros/v_dotros)
											end if

											if v_ddoctos=0 then
												ind_doctos="0%"
											else
												ind_doctos=FormatPercent(v_doctos/v_ddoctos)
											end if
									 %>
									 <tr align='right'>
									 	<th><strong>Total:</strong></th>
											<th><%=formatcurrency(v_dletra,0)%></th>
											<th><%=formatcurrency(v_letra,0)%></th>
											<th><%=ind_letra%></th>
											<th><%=formatcurrency(v_dcheque,0)%></th>
											<th><%=formatcurrency(v_cheque,0)%></th>
											<th><%=ind_cheque%></th>
											<th><%=formatcurrency(v_dpagare,0)%></th>
											<th><%=formatcurrency(v_pagare,0)%></th>
											<th><%=ind_pagare%></th>
											<th><%=formatcurrency(v_ddoctos,0)%></th>
											<th><%=formatcurrency(v_doctos,0)%></th>
											<th><%=ind_doctos%></th>	
									  </tr>
								    </table>	
																	
								</td>
                            </tr>
							<tr>
                             <td align="left"><br/></td>
                            </tr>
							<tr>
                             <td align="left"><br/><strong>Indicadores por Carrera</strong></td>
                            </tr>
							<tr>
								 <td align="center">
									    <table class=v1 width='100%' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD' id='tb_a'>
										 <tr bgcolor='#C4D7FF' bordercolor='#999999'>
											<th align="center"><font color='#333333'>Item</font></th>
											<th align="center"><font color='#333333'>Jornada</font></th>
											<th align="center"><font color='#333333'>Pactado Letra</font></th>
											<th align="center"><font color='#333333'>Saldo Letra</font></th>
											<th align="center"><font color='#333333'>Indicador</font></th>
											<th align="center"><font color='#333333'>Pactado Cheque</font></th>
											<th align="center"><font color='#333333'>Saldo Cheque</font></th>
											<th align="center"><font color='#333333'>Indicador</font></th>
											<th align="center"><font color='#333333'>Pactado Pagare</font></th>
											<th align="center"><font color='#333333'>Saldo Pagare</font></th>
											<th align="center"><font color='#333333'>Indicador</font></th>
											<th align="center"><font color='#333333'>Pactado Doctos</font></th>
											<th align="center"><font color='#333333'>Saldo Doctos</font></th>
											<th align="center"><font color='#333333'>Indicador</font></th>											
										  </tr> 
										<%  
									 	v_letra	=	0
										v_cheque=	0
										v_pagare=	0
										v_otros	=	0
										v_dletra=	0
										v_dcheque=	0
										v_dpagare=	0
										v_dotros=	0		
										v_doctos=0
										v_ddoctos=0																		
										 while f_morosidad_escuela.Siguiente
											v_letra	=	v_letra		+	CDbl(f_morosidad_escuela.ObtenerValor("letras"))
											v_cheque=	v_cheque	+	CDbl(f_morosidad_escuela.ObtenerValor("cheques"))
											v_pagare=	v_pagare	+	CDbl(f_morosidad_escuela.ObtenerValor("pagares"))
											v_otros =	v_otros		+	CDbl(f_morosidad_escuela.ObtenerValor("otros"))
											v_dletra	=	v_dletra		+	CDbl(f_morosidad_escuela.ObtenerValor("dletras"))
											v_dcheque	=	v_dcheque		+	CDbl(f_morosidad_escuela.ObtenerValor("dcheques"))
											v_dpagare	=	v_dpagare		+	CDbl(f_morosidad_escuela.ObtenerValor("dpagares"))
											v_dotros 	=	v_dotros		+	CDbl(f_morosidad_escuela.ObtenerValor("dotros"))

											v_suma_doctos	= CDbl(f_morosidad_escuela.ObtenerValor("letras"))+CDbl(f_morosidad_escuela.ObtenerValor("cheques"))+CDbl(f_morosidad_escuela.ObtenerValor("pagares"))
											v_suma_ddoctos	= CDbl(f_morosidad_escuela.ObtenerValor("dletras"))+CDbl(f_morosidad_escuela.ObtenerValor("dcheques"))+CDbl(f_morosidad_escuela.ObtenerValor("dpagares"))
											if v_suma_ddoctos=0 then
												v_ind_doctos="0%"
											else
												v_ind_doctos	= FormatPercent(v_suma_doctos/v_suma_ddoctos)
											end if
											
											v_doctos	= v_doctos 	+ v_suma_doctos	
											v_ddoctos	= v_ddoctos + v_suma_ddoctos	
										
										%>
										 <tr bgcolor="#FFFFFF" align='right'>
											<td align='LEFT'><%=f_morosidad_escuela.ObtenerValor("item")%></td>
											<td align='LEFT'><%=f_morosidad_escuela.ObtenerValor("jornada")%></td>
											<td><%=formatcurrency(CDbl(f_morosidad_escuela.ObtenerValor("dletras")),0)%></td>
											<td><%=formatcurrency(CDbl(f_morosidad_escuela.ObtenerValor("letras")),0)%></td>
											<td><strong><%=f_morosidad_escuela.ObtenerValor("ind_letras")%>%</strong></td>
											<td><%=formatcurrency(CDbl(f_morosidad_escuela.ObtenerValor("dcheques")),0)%></td>
											<td><%=formatcurrency(CDbl(f_morosidad_escuela.ObtenerValor("cheques")),0)%></td>
											<td><strong><%=f_morosidad_escuela.ObtenerValor("ind_cheques")%>%</strong></td>
											<td><%=formatcurrency(CDbl(f_morosidad_escuela.ObtenerValor("dpagares")),0)%></td>
											<td><%=formatcurrency(CDbl(f_morosidad_escuela.ObtenerValor("pagares")),0)%></td>
											<td><strong><%=f_morosidad_escuela.ObtenerValor("ind_pagares")%>%</strong></td>
											<td><%=formatcurrency(v_suma_ddoctos,0)%></td>
											<td><%=formatcurrency(v_suma_doctos,0)%></td>
											<td><strong><%=v_ind_doctos%>%</strong></td>											
										  </tr> 
										 <%wend
										 
											if v_dletra=0 then
												ind_letra="0%"
											else
												ind_letra=FormatPercent(v_letra/v_dletra)
											end if
											 
											if v_dcheque=0 then
												ind_cheque="0%"
											else
												ind_cheque=FormatPercent(v_cheque/v_dcheque)
											end if
											 
											if v_dpagare=0 then
												ind_pagare="0%"
											else
												ind_pagare=FormatPercent(v_pagare/v_dpagare)
											end if
											 
											if v_dotros=0 then
												ind_otros="0%"
											else
												ind_otros=FormatPercent(v_otros/v_dotros)
											end if

											if v_ddoctos=0 then
												ind_doctos="0%"
											else
												ind_doctos=FormatPercent(v_doctos/v_ddoctos)
											end if
										 %>
										<tr align='right'>
											<th colspan="2"><strong>Total:</strong></th>
											<th><%=formatcurrency(v_dletra,0)%></th>
											<th><%=formatcurrency(v_letra,0)%></th>
											<th><%=ind_letra%></th>
											<th><%=formatcurrency(v_dcheque,0)%></th>
											<th><%=formatcurrency(v_cheque,0)%></th>
											<th><%=ind_cheque%></th>
											<th><%=formatcurrency(v_dpagare,0)%></th>
											<th><%=formatcurrency(v_pagare,0)%></th>
											<th><%=ind_pagare%></th>
											<th><%=formatcurrency(v_ddoctos,0)%></th>
											<th><%=formatcurrency(v_doctos,0)%></th>
											<th><%=ind_doctos%></th>	
										  </tr>
										</table>				 
						      </td>
                            </tr>
							<br>
                               
						  </table>                     
					</td>
                  </tr>
                </table>
</td></tr>
        </table>
</body>
</html>
