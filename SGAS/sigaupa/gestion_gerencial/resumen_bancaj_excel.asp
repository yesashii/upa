<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 150000
Response.AddHeader "Content-Disposition", "attachment;filename=resumen_bancaj.xls"
Response.ContentType = "application/vnd.ms-excel"
'Randomize()
'response.Write(Rnd)

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Resumen de caja"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion

v_anos  = request.querystring("busqueda[0][v_anos]")
'v_sede_ccod  = request.querystring("busqueda[0][sede_ccod]")
'v_pers_ncorr = request.querystring("busqueda[0][pers_ncorr]")


fecha_01 = conexion.ConsultaUno("Select protic.trunc(getdate())")

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "numeros_boletas_cajeros.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente

 'f_busqueda.AgregaCampoCons "sede_ccod", v_sede_ccod
 'f_busqueda.AgregaCampoCons "pers_ncorr", v_pers_ncorr
 
 

'**********************************************************************************


v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")

set lista = new CFormulario
lista.carga_parametros "consulta.xml", "consulta"


Function ObtenerConsulta(p_sede)

sql_sede=	" select mes_ccod,mes_tdesc+'(Año '+cast(ano as varchar)+')' as mes_tdesc,sum(cheques) as cheques, sum(letras) as letras, sum(efectivo) as efectivo,  "& vbCrLf &_
			" sum(credito) as credito, sum(debito) as debito, sum(vale_vista) as vale_vista, sum(pagare) as pagare,sum(multidebito) as multidebito,sum(pagare_upa) as pagare_upa,  "& vbCrLf &_
			" (sum(cheques)+sum(letras)+sum(efectivo)+sum(credito)+sum(debito)+sum(vale_vista)+sum(pagare)+sum(multidebito)+sum(pagare_upa)) as total "& vbCrLf &_
			" from ( "& vbCrLf &_
			" select datepart(month,b.mcaj_finicio) as mes,datepart(year,b.mcaj_finicio) as ano,isnull(max(cheque),0) as cheques,isnull(max(letra),0) as letras,    "& vbCrLf &_  
				 " isnull(max(efectivo),0) as efectivo,isnull(max(credito),0) as credito,    "& vbCrLf &_ 
				 " isnull(max(vale_vista),0) as vale_vista,isnull(max(debito),0) as debito,     "& vbCrLf &_
				 " isnull(max(pagare),0) as pagare, isnull(max(multidebito),0) as multidebito,isnull(max(pagare_upa),0) as pagare_upa,   "& vbCrLf &_  
				 " (isnull(max(cheque),0) + isnull(max(letra),0) + isnull(max(efectivo),0) + isnull(max(credito),0) +    "& vbCrLf &_ 
				 " isnull(max(vale_vista),0) +isnull(max(debito),0) + isnull(max(pagare),0)+ isnull(max(multidebito),0)+ isnull(max(pagare_upa),0) ) as total    "& vbCrLf &_
				 " from (      "& vbCrLf &_
				 "     select mcaj_ncorr,case ting_ccod when 3 then cast(sum(monto_recaudado) as numeric) end as cheque,    "& vbCrLf &_  
				 "     case ting_ccod when 4 then cast(sum(monto_recaudado) as numeric) end as letra,     "& vbCrLf &_
				 "     case ting_ccod when 6 then cast(sum(monto_recaudado) as numeric) end as efectivo,   "& vbCrLf &_  
				 "     case ting_ccod when 13 then cast(sum(monto_recaudado) as numeric) end as credito,     "& vbCrLf &_
				 "     case ting_ccod when 14 then cast(sum(monto_recaudado) as numeric) end as vale_vista,     "& vbCrLf &_
				 "     case ting_ccod when 51 then cast(sum(monto_recaudado) as numeric) end as debito,     "& vbCrLf &_
				 "     case ting_ccod when 52 then cast(sum(monto_recaudado) as numeric) end as pagare,     "& vbCrLf &_
				 "     case ting_ccod when 59 then cast(sum(monto_recaudado) as numeric) end as multidebito,     "& vbCrLf &_
				 "     case ting_ccod when 66 then cast(sum(monto_recaudado) as numeric) end as pagare_upa     "& vbCrLf &_				 
				 "     from (     "& vbCrLf &_
							"  select a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo, "& vbCrLf &_   
							"  case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6 "& vbCrLf &_
							"       else b.ting_ccod end as ting_ccod,    "& vbCrLf &_
							"  case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo "& vbCrLf &_
							"       else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado    "& vbCrLf &_  
							"  from ingresos a      "& vbCrLf &_
							"  left outer join detalle_ingresos b    "& vbCrLf &_  
							"      on a.ingr_ncorr=b.ingr_ncorr   "& vbCrLf &_   
							"      and  b.ting_ccod in (3,4,6,13,14,51,52,59,66)    "& vbCrLf &_   
							"  left outer join tipos_ingresos c      "& vbCrLf &_ 
							"      on b.ting_ccod=c.ting_ccod     "& vbCrLf &_ 
							"  where a.mcaj_ncorr in (select  distinct d.mcaj_ncorr "& vbCrLf &_
													" from contratos a, compromisos b, abonos c, ingresos d, movimientos_cajas e	"& vbCrLf &_
													" where a.cont_ncorr=b.comp_ndocto	"& vbCrLf &_
													" and b.comp_ndocto=c.comp_ndocto	"& vbCrLf &_
													" and b.tcom_ccod=c.tcom_ccod	"& vbCrLf &_
													" and b.inst_ccod=c.inst_ccod	"& vbCrLf &_
													" and c.ingr_ncorr=d.ingr_ncorr	"& vbCrLf &_
													" and a.econ_ccod not in (2,3)	"& vbCrLf &_
													" and d.ting_ccod in (7)	"& vbCrLf &_
													" and d.eing_ccod not in (3,6)	"& vbCrLf &_
													" and d.mcaj_ncorr=e.mcaj_ncorr	"& vbCrLf &_
													" and e.sede_ccod in ('"&p_sede&"')	"& vbCrLf &_
													" and a.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod ='"&v_anos&"') "& vbCrLf &_
													" )        "& vbCrLf &_
							"  and a.ting_ccod  in (7)     "& vbCrLf &_ 
							"  and a.eing_ccod not in (3,6)     "& vbCrLf &_  
				 	" UNION	 "& vbCrLf &_					
						"  -- Titulaciones pagadas directamente  "& vbCrLf &_
							"   select a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo,  "& vbCrLf &_
							"   case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6  "& vbCrLf &_
							" 	   else b.ting_ccod end as ting_ccod, "& vbCrLf &_    
							"   case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo  "& vbCrLf &_
							" 	   else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado  "& vbCrLf &_    
							"   from ingresos a   "& vbCrLf &_    
							"   left outer join detalle_ingresos b  "& vbCrLf &_   
							" 	  on a.ingr_ncorr=b.ingr_ncorr   "& vbCrLf &_ 
							" 	  and  b.ting_ccod in (3,4,6,13,14,51,52,59,66)   "& vbCrLf &_  
							"   left outer join tipos_ingresos c   "& vbCrLf &_    
							" 	  on b.ting_ccod=c.ting_ccod  "& vbCrLf &_
							"   join abonos d  "& vbCrLf &_
							" 	on a.ingr_ncorr=d.ingr_ncorr  "& vbCrLf &_
							" 	and d.tcom_ccod=4  "& vbCrLf &_
							"   join detalles e  "& vbCrLf &_
							" 	on d.comp_ndocto=e.comp_ndocto  "& vbCrLf &_
							" 	and d.tcom_ccod=e.tcom_ccod  "& vbCrLf &_
							" 	and e.tdet_ccod in (1230)	  "& vbCrLf &_ 
							"   where a.mcaj_ncorr in ( "& vbCrLf &_ 
							" 						select  distinct e.mcaj_ncorr "& vbCrLf &_ 
												" 	 from compromisos b, abonos c, ingresos d, movimientos_cajas e, detalles f	 "& vbCrLf &_ 
												" 	 where b.comp_ndocto=c.comp_ndocto	 "& vbCrLf &_ 
												" 	 and b.tcom_ccod=c.tcom_ccod	 "& vbCrLf &_ 
												" 	 and b.inst_ccod=c.inst_ccod	 "& vbCrLf &_ 
												" 	 and c.ingr_ncorr=d.ingr_ncorr	 "& vbCrLf &_ 
												" 	 and d.ting_ccod in (34)	 "& vbCrLf &_ 
												" 	 and d.eing_ccod not in (3,6)	 "& vbCrLf &_ 
												" 	 and d.mcaj_ncorr=e.mcaj_ncorr "& vbCrLf &_ 
												" 	 and b.tcom_ccod=4	 "& vbCrLf &_ 
												" 	 and e.sede_ccod in ('"&p_sede&"') "& vbCrLf &_ 
												" 	 and b.tcom_ccod=f.tcom_ccod "& vbCrLf &_ 
												" 	 and b.comp_ndocto=f.comp_ndocto "& vbCrLf &_ 
												" 	 and f.tdet_ccod in (1230)	 "& vbCrLf &_ 
							"  ) "& vbCrLf &_ 
							"   and a.ting_ccod  in (34)     "& vbCrLf &_  
							"   and a.eing_ccod not in (3,6)  "& vbCrLf &_ 
							"   and datepart(year,a.ingr_fpago)='"&v_anos&"' "& vbCrLf &_ 
					" UNION  "& vbCrLf &_ 
							"   -- Titulaciones repactadas  "& vbCrLf &_ 
							"   Select a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo,  "& vbCrLf &_ 
							"   case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6  "& vbCrLf &_ 
							" 	   else b.ting_ccod end as ting_ccod,     "& vbCrLf &_ 
							"   case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo  "& vbCrLf &_ 
							" 	   else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado  "& vbCrLf &_    
							"  From ingresos a  "& vbCrLf &_ 
							"   left outer join detalle_ingresos b  "& vbCrLf &_    
							" 	  on a.ingr_ncorr=b.ingr_ncorr    "& vbCrLf &_ 
							" 	  and  b.ting_ccod in (3,4,6,13,14,51,52,59,66) "& vbCrLf &_ 
							"  left outer join tipos_ingresos c  "& vbCrLf &_      
							" 	  on b.ting_ccod=c.ting_ccod  "& vbCrLf &_ 
							"   join abonos d  "& vbCrLf &_ 
							" 		on a.ingr_ncorr=d.ingr_ncorr  "& vbCrLf &_ 
							" 		and d.tcom_ccod=3  "& vbCrLf &_ 
							"    join compromisos e  "& vbCrLf &_ 
							" 	on d.comp_ndocto=e.comp_ndocto  "& vbCrLf &_ 
							" 	and d.tcom_ccod=e.tcom_ccod  "& vbCrLf &_ 
							" 	and e.sede_ccod in ('"&p_sede&"')    "& vbCrLf &_              
							"  Where ingr_nfolio_referencia in ( "& vbCrLf &_ 
							" 		select a.ingr_nfolio_referencia  "& vbCrLf &_ 
									" from ingresos a, detalle_ingresos b, abonos c  "& vbCrLf &_ 
									" where a.ingr_ncorr=b.ingr_ncorr  "& vbCrLf &_ 
									" 	and a.ingr_ncorr=c.ingr_ncorr  "& vbCrLf &_ 
									" 	and c.tcom_ccod=4  "& vbCrLf &_ 
									" 	and a.ting_ccod=9  "& vbCrLf &_ 
									" 	and b.ting_ccod=9 "& vbCrLf &_ 
									" 	and a.eing_ccod=5 "& vbCrLf &_ 
							" ) "& vbCrLf &_ 
							" and a.eing_ccod not in (5,3,6) "& vbCrLf &_ 
							" and a.ting_ccod=15 "& vbCrLf &_ 
							" and datepart(year,a.ingr_fpago)='"&v_anos&"'   "& vbCrLf &_ 
				 "     ) as tabla      "& vbCrLf &_
				 "     group by mcaj_ncorr,ting_ccod      "& vbCrLf &_
				 " ) a      "& vbCrLf &_
				 " join movimientos_cajas b   "& vbCrLf &_   
				 "     on a.mcaj_ncorr=b.mcaj_ncorr    "& vbCrLf &_
				 " 	  and b.tcaj_ccod in (1000)   "& vbCrLf &_   
			"	 group by b.mcaj_finicio "& vbCrLf &_  
			"    ) as tabla "& vbCrLf &_  
			" join meses "& vbCrLf &_  
			"    on mes_ccod=mes   "& vbCrLf &_  
			" group by mes_tdesc,mes_ccod,ano "  & vbCrLf &_  
			" order by ano asc,mes_ccod asc "         
			  
'response.Write("<pre>"&sql_sede&"</pre>")	
'response.Flush()			
	ObtenerConsulta=sql_sede				
end function


set casa_central = new CFormulario
casa_central.carga_parametros "resumen_caja_diario.xml", "resumen_caja"
casa_central.inicializar conexion 

set providencia = new CFormulario
providencia.carga_parametros "resumen_caja_diario.xml", "resumen_caja"
providencia.inicializar conexion 

set melipilla = new CFormulario
melipilla.carga_parametros "resumen_caja_diario.xml", "resumen_caja"
melipilla.inicializar conexion 

sql_casa_central=ObtenerConsulta(1)
sql_providencia=ObtenerConsulta(2)
sql_melipilla=ObtenerConsulta(4)
'response.Write("<pre>"&sql_casa_cetral&"</pre>")		

if not Esvacio(Request.QueryString) then
	casa_central.Consultar sql_casa_central
	providencia.Consultar sql_providencia
	melipilla.Consultar sql_melipilla

else
	casa_central.Consultar sql_casa_central
	providencia.Consultar sql_providencia
	melipilla.Consultar sql_melipilla
	
	vacia = "select '' where 1=2 "
	 
	melipilla.Consultar vacia
	melipilla.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
	
	providencia.Consultar vacia
	providencia.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
	
	casa_central.Consultar vacia
	casa_central.AgregaParam "mensajeError", "Ingrese criterio de busqueda"

end if

%>
<html>
<head>
<title>Resumen cajas por día</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Resumen Bancaj</font></div>
	  <div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="15%" height="22" colspan="2"><strong>Documentos del año: <%=v_anos%> </strong></td>
    <td width="85%" colspan="2"> </td>
  </tr>
  <tr>
    <td colspan="2"><strong>Fecha actual: <%=fecha_01%></strong></td>
    <td colspan="2"> </td>
 </tr>
 
</table>

<p></p>
<font color="#0000FF" size="+1" ><strong>Casa Central</strong></font>
<table width="100%" border="1">
  <tr> 
    <td width="10%" bgcolor="#FFFFCC" ><div align="center"><strong>Mes</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Cheques</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Letras</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Efectivo</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Vale Vista</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>T. Credito</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>T. Debito</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Pagare TB</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>MultiDebito</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Pagare UPA</strong></div></td>        
	<td width="10%" bgcolor="#CCFFFF"><div align="center"><strong>Total Caja</strong></div></td>

  </tr>
  <% fila = 1 
     while casa_central.Siguiente %>
  <tr> 
	<td><div align="center"><%=casa_central.ObtenerValor("mes_tdesc")%></div></td>
	<td><div align="center"><%=FormatCurrency(casa_central.ObtenerValor("cheques"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(casa_central.ObtenerValor("letras"),0)%></div></td>
    <td><div align="center"><%=FormatCurrency(casa_central.ObtenerValor("efectivo"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(casa_central.ObtenerValor("vale_vista"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(casa_central.ObtenerValor("credito"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(casa_central.ObtenerValor("debito"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(casa_central.ObtenerValor("pagare"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(casa_central.ObtenerValor("multidebito"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(casa_central.ObtenerValor("pagare_upa"),0)%></div></td>    
	<td><div align="center"><%=FormatCurrency(casa_central.ObtenerValor("total"),0)%></div></td>

  </tr>
  <% 
  '***	TOTALIZA MONTOS	**********************
  cheque_central	=	Ccur(casa_central.ObtenerValor("cheques"))		+	Ccur(cheque_central)
  letras_central	=	Ccur(casa_central.ObtenerValor("letras"))		+	Ccur(letras_central)
  efectivo_central	=	Ccur(casa_central.ObtenerValor("efectivo"))		+	Ccur(efectivo_central)
  vale_vista_central=	Ccur(casa_central.ObtenerValor("vale_vista"))	+	Ccur(vale_vista_central)
  credito_central	=	Ccur(casa_central.ObtenerValor("credito"))		+	Ccur(credito_central)
  debito_central	=	Ccur(casa_central.ObtenerValor("debito"))		+	Ccur(debito_central)  
  Pagare_central	=	Ccur(casa_central.ObtenerValor("Pagare"))		+	Ccur(Pagare_central)
  multidebito_central	=	Ccur(casa_central.ObtenerValor("multidebito"))	+	Ccur(multidebito_central)  
  pagare_upa_central	=	Ccur(casa_central.ObtenerValor("pagare_upa"))	+	Ccur(pagare_upa_central)
  total_central		=	Ccur(casa_central.ObtenerValor("total"))		+	Ccur(total_central)
  wend %>
    <TR>
	  <TH >Totales x Documentos:</TH>
	  <TH><%=FormatCurrency(cheque_central,0)%></TD>
	  <TH><%=FormatCurrency(letras_central,0)%></TH>
	  <TH><%=FormatCurrency(efectivo_central,0)%></TH>
	  <TH><%=FormatCurrency(vale_vista_central,0)%></TH>
	  <TH><%=FormatCurrency(credito_central,0)%></TH>
	  <TH><%=FormatCurrency(debito_central,0)%></TH>
	  <TH><%=FormatCurrency(Pagare_central,0)%></TH>
	  <TH><%=FormatCurrency(multidebito_central,0)%></TH>
	  <TH><%=FormatCurrency(pagare_upa_central,0)%></TH>          
	  <TH><%=FormatCurrency(total_central,0)%></TH>  
	  
  </TR>
</table>
<p>&nbsp;</p>
<p></p>
<p></p> 
<font color="#0000FF" size="+1" ><strong>Sede Providencia</strong></font>
<table width="100%" border="1">
  <tr> 
    <td width="10%" bgcolor="#FFFFCC" ><div align="center"><strong>Mes</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Cheques</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Letras</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Efectivo</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Vale Vista</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>T. Credito</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>T. Debito</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Pagare TB</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>MultiDebito</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Pagare UPA</strong></div></td>        
	<td width="10%" bgcolor="#CCFFFF"><div align="center"><strong>Total Caja</strong></div></td>

  </tr>
  <%  while providencia.Siguiente %>
  <tr> 
	<td><div align="center"><%=providencia.ObtenerValor("mes_tdesc")%></div></td>
	<td><div align="center"><%=FormatCurrency(providencia.ObtenerValor("cheques"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(providencia.ObtenerValor("letras"),0)%></div></td>
    <td><div align="center"><%=FormatCurrency(providencia.ObtenerValor("efectivo"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(providencia.ObtenerValor("vale_vista"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(providencia.ObtenerValor("credito"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(providencia.ObtenerValor("debito"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(providencia.ObtenerValor("pagare"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(providencia.ObtenerValor("multidebito"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(providencia.ObtenerValor("pagare_upa"),0)%></div></td>        
	<td><div align="center"><%=FormatCurrency(providencia.ObtenerValor("total"),0)%></div></td>	
  </tr>
  <% 
   '***	TOTALIZA MONTOS	**********************
  cheque_providencia	=	Ccur(providencia.ObtenerValor("cheques"))		+	Ccur(cheque_providencia)
  letras_providencia	=	Ccur(providencia.ObtenerValor("letras"))		+	Ccur(letras_providencia)
  efectivo_providencia	=	Ccur(providencia.ObtenerValor("efectivo"))		+	Ccur(efectivo_providencia)
  vale_vista_providencia=	Ccur(providencia.ObtenerValor("vale_vista"))	+	Ccur(vale_vista_providencia)
  credito_providencia	=	Ccur(providencia.ObtenerValor("credito"))		+	Ccur(credito_providencia)
  debito_providencia	=	Ccur(providencia.ObtenerValor("debito"))		+	Ccur(debito_providencia)
  Pagare_providencia	=	Ccur(providencia.ObtenerValor("Pagare"))		+	Ccur(Pagare_providencia)
  multidebito_providencia	=	Ccur(providencia.ObtenerValor("multidebito"))		+	Ccur(multidebito_providencia)
  pagare_upa_providencia	=	Ccur(providencia.ObtenerValor("pagare_upa"))		+	Ccur(pagare_upa_providencia)  
  total_providencia		=	Ccur(providencia.ObtenerValor("total"))			+	Ccur(total_providencia)

  wend %>
  
    <TR>
	  <TH>Totales x Documentos:</TH>
	  <TH><%=FormatCurrency(cheque_providencia,0)%></TH>
	  <TH><%=FormatCurrency(letras_providencia,0)%></TH>
	  <TH><%=FormatCurrency(efectivo_providencia,0)%></TH>
	  <TH><%=FormatCurrency(vale_vista_providencia,0)%></TH>
	  <TH><%=FormatCurrency(credito_providencia,0)%></TH>
	  <TH><%=FormatCurrency(debito_providencia,0)%></TH>
	  <TH><%=FormatCurrency(Pagare_providencia,0)%></TH>
	  <TH><%=FormatCurrency(multidebito_providencia,0)%></TH>
	  <TH><%=FormatCurrency(pagare_upa_providencia,0)%></TH>        
	  <TH><%=FormatCurrency(total_providencia,0)%></TH>  
	   
  </TR>

</table>
<p>&nbsp;</p>
<p></p>
<p></p> 
<font color="#0000FF" size="+1"><strong>Sede Melipilla</strong></font>
<table width="100%" border="1">
  <tr> 
    <td width="10%" bgcolor="#FFFFCC" ><div align="center"><strong>Mes</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Cheques</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Letras</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Efectivo</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Vale Vista</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>T. Credito</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>T. Debito</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Pagare TB</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>MultiDebito</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Pagare UPA</strong></div></td>    
	<td width="10%" bgcolor="#CCFFFF"><div align="center"><strong>Total Caja</strong></div></td>
	
  </tr>
  <%  
     while melipilla.Siguiente %>
  <tr> 
	<td><div align="center"><%=melipilla.ObtenerValor("mes_tdesc")%></div></td>
	<td><div align="center"><%=FormatCurrency(melipilla.ObtenerValor("cheques"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(melipilla.ObtenerValor("letras"),0)%></div></td>
    <td><div align="center"><%=FormatCurrency(melipilla.ObtenerValor("efectivo"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(melipilla.ObtenerValor("vale_vista"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(melipilla.ObtenerValor("credito"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(melipilla.ObtenerValor("debito"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(melipilla.ObtenerValor("Pagare"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(melipilla.ObtenerValor("multidebito"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(melipilla.ObtenerValor("pagare_upa"),0)%></div></td>        
	<td><div align="center"><%=FormatCurrency(melipilla.ObtenerValor("total"),0)%></div></td>

  </tr>
  <% 
  '***	TOTALIZA MONTOS	**********************
  cheque_melipilla		=	Ccur(melipilla.ObtenerValor("cheques"))		+	Ccur(cheque_melipilla)
  letras_melipilla		=	Ccur(melipilla.ObtenerValor("letras"))		+	Ccur(letras_melipilla)
  efectivo_melipilla	=	Ccur(melipilla.ObtenerValor("efectivo"))	+	Ccur(efectivo_melipilla)
  vale_vista_melipilla	=	Ccur(melipilla.ObtenerValor("vale_vista"))	+	Ccur(vale_vista_melipilla)
  credito_melipilla		=	Ccur(melipilla.ObtenerValor("credito"))		+	Ccur(credito_melipilla)
  debito_melipilla		=	Ccur(melipilla.ObtenerValor("debito"))		+	Ccur(debito_melipilla)
  Pagare_melipilla		=	Ccur(melipilla.ObtenerValor("Pagare"))		+	Ccur(Pagare_melipilla)
  multidebito_melipilla	=	Ccur(melipilla.ObtenerValor("multidebito"))	+	Ccur(multidebito_melipilla)
  pagare_upa_melipilla	=	Ccur(melipilla.ObtenerValor("pagare_upa"))	+	Ccur(pagare_upa_melipilla)  
  total_melipilla		=	Ccur(melipilla.ObtenerValor("total"))		+	Ccur(total_melipilla)

  wend %>
    <TR>
	  <TH >Totales x Documentos:</TH>
	  <TH><%=FormatCurrency(cheque_melipilla,0)%></TH>
	  <TH><%=FormatCurrency(letras_melipilla,0)%></TH>
	  <TH><%=FormatCurrency(efectivo_melipilla,0)%></TH>
	  <TH><%=FormatCurrency(vale_vista_melipilla,0)%></TH>
	  <TH><%=FormatCurrency(credito_melipilla,0)%></TH>
	  <TH><%=FormatCurrency(debito_melipilla,0)%></TH>
	  <TH><%=FormatCurrency(Pagare_melipilla,0)%></TH>
	  <TH><%=FormatCurrency(multidebito_melipilla,0)%></TH>
	  <TH><%=FormatCurrency(pagare_upa_melipilla,0)%></TH>          
	  <TH><%=FormatCurrency(total_melipilla,0)%></TH>  

  </TR>

</table>
<%
' calculo de totales globales por documentos y cajas
v_total_cheques		=	cheque_central		+	cheque_providencia		+	cheque_melipilla
v_total_letras		=	letras_central		+	letras_providencia		+	letras_melipilla
v_total_efectivo	=	efectivo_central	+	efectivo_providencia	+	efectivo_melipilla
v_total_vale_vista	=	vale_vista_central	+	vale_vista_providencia	+	vale_vista_melipilla
v_total_credito		=	credito_central		+	credito_providencia		+	credito_melipilla
v_total_debito		=	debito_central		+	debito_providencia		+	debito_melipilla
v_total_Pagare		=	Pagare_central		+	Pagare_providencia		+	Pagare_melipilla
v_total_multidebito	=	multidebito_central	+	multidebito_providencia	+	multidebito_melipilla
v_total_pagare_upa	=	pagare_upa_central	+	pagare_upa_providencia	+	pagare_upa_melipilla
v_total_cajas		=	total_central		+	total_providencia		+	total_melipilla

%>
<p>&nbsp;</p>

<font color="#000000" size="+1" ><strong>Totalizacion de los ingresos del Año <%response.Write(v_anos)%></strong></font>
<table width="100%" border="1">
<tr>
    <td width="30%" ></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Cheques</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Letras</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Efectivo</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Vale Vista</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>T. Credito</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>T. Debito</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Pagare</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>MultiDebito</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Pagare UPA</strong></div></td>       
	<td width="10%" bgcolor="#CCFFFF" ><div align="center"><strong>Total Global</strong></div></td>
</tr>
    <TR>
	  <TH bgcolor="#CCFFFF">Totales Globales x Documentos:</TH>
	  <TH><%=FormatCurrency(v_total_cheques,0)%></TH>
	  <TH><%=FormatCurrency(v_total_letras,0)%></TH>
	  <TH><%=FormatCurrency(v_total_efectivo,0)%></TH>
	  <TH><%=FormatCurrency(v_total_vale_vista,0)%></TH>
	  <TH><%=FormatCurrency(v_total_credito,0)%></TH>
	  <TH><%=FormatCurrency(v_total_debito,0)%></TH>
	  <TH><%=FormatCurrency(v_total_Pagare,0)%></TH> 
	  <TH><%=FormatCurrency(v_total_multidebito,0)%></TH>
	  <TH><%=FormatCurrency(v_total_pagare_upa,0)%></TH>         
	  <TH><%=FormatCurrency(v_total_cajas,0)%></TH>  

  </TR>

</table>
<p></p>
<p></p>
</body>
</html>