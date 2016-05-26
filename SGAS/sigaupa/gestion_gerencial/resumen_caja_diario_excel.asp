<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 150000
Response.AddHeader "Content-Disposition", "attachment;filename=resumen_caja.xls"
Response.ContentType = "application/vnd.ms-excel"
 
 '---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Resumen de caja"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion

inicio = request.querystring("inicio")
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



v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")

set lista = new CFormulario
lista.carga_parametros "consulta.xml", "consulta"


if v_sede_ccod <> "" then
	filtro =" and  f.sede_ccod="&v_sede_ccod
end if


if v_pers_ncorr <> "" then
	filtro =filtro&" and  k.pers_ncorr="&v_pers_ncorr
end if

if inicio <> "" then
	filtro =filtro&" and  protic.trunc(convert(datetime,j.mcaj_finicio,103))=convert(datetime,'"&inicio&"',103) "
end if

Function ObtenerConsulta(p_sede)
sql_sede="select protic.obtener_nombre(c.pers_ncorr,'c') as cajero,a.mcaj_ncorr,isnull(max(cheque),0) as cheques,isnull(max(letra),0) as letras, "& vbCrLf &_  
				" isnull(max(efectivo),0) as efectivo,isnull(max(credito),0) as credito,"& vbCrLf &_  
				" isnull(max(vale_vista),0) as vale_vista,isnull(max(debito),0) as debito,"& vbCrLf &_  
				" isnull(max(pagare),0) as pagare,isnull(max(multidebito),0) as multidebito, isnull(max(pagare_upa),0) as pagare_upa,  "& vbCrLf &_  
				" (isnull(max(cheque),0) + isnull(max(letra),0) + isnull(max(efectivo),0) + isnull(max(credito),0) +" & vbCrLf &_ 
				" isnull(max(vale_vista),0) +isnull(max(debito),0) + isnull(max(pagare),0)+ isnull(max(multidebito),0)+ isnull(max(pagare_upa),0) ) as total"& vbCrLf &_ 
				" from ( "& vbCrLf &_  
				"     select mcaj_ncorr,case ting_ccod when 3 then cast(sum(monto_recaudado) as numeric) end as cheque, "& vbCrLf &_  
				"     case ting_ccod when 4 then cast(sum(monto_recaudado) as numeric) end as letra,"& vbCrLf &_  
				"     case ting_ccod when 6 then cast(sum(monto_recaudado) as numeric) end as efectivo,"& vbCrLf &_  
				"     case ting_ccod when 13 then cast(sum(monto_recaudado) as numeric) end as credito,"& vbCrLf &_  
				"     case ting_ccod when 14 then cast(sum(monto_recaudado) as numeric) end as vale_vista,"& vbCrLf &_  
				"     case ting_ccod when 51 then cast(sum(monto_recaudado) as numeric) end as debito,"& vbCrLf &_  
				"     case ting_ccod when 52 then cast(sum(monto_recaudado) as numeric) end as pagare,"& vbCrLf &_
				"     case ting_ccod when 59 then cast(sum(monto_recaudado) as numeric) end as multidebito,"& vbCrLf &_  
				"     case ting_ccod when 66 then cast(sum(monto_recaudado) as numeric) end as pagare_upa"& vbCrLf &_  
  				"     from ("& vbCrLf &_  
				"         select a.mcaj_ncorr,c.ting_tdesc,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo,"& vbCrLf &_  
				"         case when b.ting_ccod is null and a.ingr_mefectivo is not null then 6 else b.ting_ccod end as ting_ccod,"& vbCrLf &_  
				"         case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo else b.ding_mdetalle end as monto_recaudado "& vbCrLf &_  
				"         from ingresos a "& vbCrLf &_  
				"         left outer join detalle_ingresos b "& vbCrLf &_  
				"             on a.ingr_ncorr=b.ingr_ncorr "& vbCrLf &_  
				"             and b.ting_ccod in (3,4,6,13,14,51,52,59,66) "& vbCrLf &_  
				"         left outer join tipos_ingresos c  "& vbCrLf &_  
				"             on b.ting_ccod=c.ting_ccod "& vbCrLf &_  
				"         where a.mcaj_ncorr in (select mcaj_ncorr from movimientos_cajas where sede_ccod in ("&p_sede&") and convert(datetime,protic.trunc(mcaj_finicio),103)=convert(datetime,'"&inicio&"',103)) "& vbCrLf &_  
				"         and a.ting_ccod  in (7,15,16,33,34) "& vbCrLf &_  
				"     ) as tabla "& vbCrLf &_  
				"     group by mcaj_ncorr,ting_ccod "& vbCrLf &_  
				" ) a "& vbCrLf &_  
				" join movimientos_cajas b "& vbCrLf &_  
				"     on a.mcaj_ncorr=b.mcaj_ncorr "& vbCrLf &_
				" 	  and b.tcaj_ccod in (1000) "& vbCrLf &_  
				" join cajeros c "& vbCrLf &_  
				"     on b.caje_ccod=c.caje_ccod "& vbCrLf &_  
				" group by a.mcaj_ncorr, c.pers_ncorr " 
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

set bustamante = new CFormulario
bustamante.carga_parametros "resumen_caja_diario.xml", "resumen_caja"
bustamante.inicializar conexion 

set concepcion = new CFormulario
concepcion.carga_parametros "resumen_caja_diario.xml", "resumen_caja"
concepcion.inicializar conexion 

set totales = new CFormulario
totales.carga_parametros "resumen_caja_diario.xml", "resumen_caja_final"
totales.inicializar conexion 

sql_casa_central=ObtenerConsulta(1)
sql_providencia=ObtenerConsulta(2)
sql_melipilla=ObtenerConsulta(4)
sql_concepcion=ObtenerConsulta(7)
sql_bustamante=ObtenerConsulta(8)

'response.Write("<pre>"&sql_resumen&"</pre>")		

if not Esvacio(Request.QueryString) then
	casa_central.Consultar sql_casa_central
	providencia.Consultar sql_providencia
	melipilla.Consultar sql_melipilla
	bustamante.Consultar sql_bustamante
	concepcion.Consultar sql_concepcion

else

	vacia = "select '' where 1=2 "

	concepcion.Consultar vacia
	concepcion.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
	 
	bustamante.Consultar vacia
	bustamante.AgregaParam "mensajeError", "Ingrese criterio de busqueda"

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
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Resumen de ingresos diarios por Caja</font></div>
	  <div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="15%" height="22" colspan="2"><strong>Cajas del d&iacute;a: <%=inicio %> </strong></td>
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
    <td width="10%" bgcolor="#FFFFCC" ><div align="center"><strong>N° Caja</strong></div></td>
    <td width="20%" bgcolor="#FFFFCC"><div align="center"><strong>Cajero</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Cheques</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Letras</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Efectivo</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Vale Vista</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>T. Credito</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>T. Debito</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Pagare TB</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>MultiDebito</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Pagare Upa</strong></div></td>    
	<td width="10%" bgcolor="#CCFFFF"><div align="center"><strong>Total Caja</strong></div></td>

  </tr>
  <% fila = 1 
     while casa_central.Siguiente %>
  <tr> 
	<td><div align="center"><%=casa_central.ObtenerValor("mcaj_ncorr")%></div></td>
	<td><div align="center"><%=casa_central.ObtenerValor("cajero")%></div></td>
	<td><div align="center"><%=FormatCurrency(casa_central.ObtenerValor("cheques"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(casa_central.ObtenerValor("letras"),0)%></div></td>
    <td><div align="center"><%=FormatCurrency(casa_central.ObtenerValor("efectivo"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(casa_central.ObtenerValor("vale_vista"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(casa_central.ObtenerValor("credito"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(casa_central.ObtenerValor("debito"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(casa_central.ObtenerValor("Pagare"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(casa_central.ObtenerValor("multidebito"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(casa_central.ObtenerValor("pagare_upa"),0)%></div></td>    
	<td><div align="center"><%=FormatCurrency(casa_central.ObtenerValor("total"),0)%></div></td>

  </tr>
  <% 
  '***	TOTALIZA MONTOS	**********************
  cheque_central	=	clng(casa_central.ObtenerValor("cheques"))		+	clng(cheque_central)
  letras_central	=	clng(casa_central.ObtenerValor("letras"))		+	clng(letras_central)
  efectivo_central	=	clng(casa_central.ObtenerValor("efectivo"))		+	clng(efectivo_central)
  vale_vista_central=	clng(casa_central.ObtenerValor("vale_vista"))	+	clng(vale_vista_central)
  credito_central	=	clng(casa_central.ObtenerValor("credito"))		+	clng(credito_central)
  debito_central	=	clng(casa_central.ObtenerValor("debito"))		+	clng(debito_central)  
  Pagare_central	=	clng(casa_central.ObtenerValor("Pagare"))		+	clng(Pagare_central)
  multidebito_central	=	clng(casa_central.ObtenerValor("multidebito"))	+	clng(multidebito_central)  
  pagare_upa_central	=	clng(casa_central.ObtenerValor("pagare_upa"))	+	clng(pagare_upa_central)  
  total_central		=	clng(casa_central.ObtenerValor("total"))		+	clng(total_central)
  wend %>
    <TR>
	  <TH colspan="2">Totales x Documentos:</TH>
	  <TH><%=FormatCurrency(cheque_central,0)%></TH>
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
    <td width="10%" bgcolor="#FFFFCC" ><div align="center"><strong>N° Caja</strong></div></td>
    <td width="20%" bgcolor="#FFFFCC"><div align="center"><strong>Cajero</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Cheques</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Letras</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Efectivo</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Vale Vista</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>T. Credito</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>T. Debito</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Pagare TB</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>MultiDebito</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Pagare Upa</strong></div></td>       
	<td width="10%" bgcolor="#CCFFFF"><div align="center"><strong>Total Caja</strong></div></td>

  </tr>
  <%  while providencia.Siguiente %>
  <tr> 
	<td><div align="center"><%=providencia.ObtenerValor("mcaj_ncorr")%></div></td>
	<td><div align="center"><%=providencia.ObtenerValor("cajero")%></div></td>
	<td><div align="center"><%=FormatCurrency(providencia.ObtenerValor("cheques"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(providencia.ObtenerValor("letras"),0)%></div></td>
    <td><div align="center"><%=FormatCurrency(providencia.ObtenerValor("efectivo"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(providencia.ObtenerValor("vale_vista"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(providencia.ObtenerValor("credito"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(providencia.ObtenerValor("debito"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(providencia.ObtenerValor("Pagare"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(providencia.ObtenerValor("multidebito"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(providencia.ObtenerValor("pagare_upa"),0)%></div></td>    
	<td><div align="center"><%=FormatCurrency(providencia.ObtenerValor("total"),0)%></div></td>	
  </tr>
  <% 
   '***	TOTALIZA MONTOS	**********************
  cheque_providencia	=	clng(providencia.ObtenerValor("cheques"))		+	clng(cheque_providencia)
  letras_providencia	=	clng(providencia.ObtenerValor("letras"))		+	clng(letras_providencia)
  efectivo_providencia	=	clng(providencia.ObtenerValor("efectivo"))		+	clng(efectivo_providencia)
  vale_vista_providencia=	clng(providencia.ObtenerValor("vale_vista"))	+	clng(vale_vista_providencia)
  credito_providencia	=	clng(providencia.ObtenerValor("credito"))		+	clng(credito_providencia)
  debito_providencia	=	clng(providencia.ObtenerValor("debito"))		+	clng(debito_providencia)
  Pagare_providencia	=	clng(providencia.ObtenerValor("Pagare"))		+	clng(Pagare_providencia)
  multidebito_providencia	=	clng(providencia.ObtenerValor("multidebito"))		+	clng(multidebito_providencia)
  pagare_upa_providencia	=	clng(providencia.ObtenerValor("pagare_upa"))		+	clng(pagare_upa_providencia)  
  total_providencia		=	clng(providencia.ObtenerValor("total"))			+	clng(total_providencia)

  wend %>
  
    <TR>
	  <TH colspan="2">Totales x Documentos:</TH>
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
    <td width="10%" bgcolor="#FFFFCC" ><div align="center"><strong>N° Caja</strong></div></td>
    <td width="20%" bgcolor="#FFFFCC"><div align="center"><strong>Cajero</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Cheques</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Letras</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Efectivo</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Vale Vista</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>T. Credito</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>T. Debito</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Pagare TB</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>MultiDebito</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Pagare Upa</strong></div></td>    
	<td width="10%" bgcolor="#CCFFFF"><div align="center"><strong>Total Caja</strong></div></td>
	
  </tr>
  <%  
     while melipilla.Siguiente %>
  <tr> 
	<td><div align="center"><%=melipilla.ObtenerValor("mcaj_ncorr")%></div></td>
	<td><div align="center"><%=melipilla.ObtenerValor("cajero")%></div></td>
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
  cheque_melipilla		=	clng(melipilla.ObtenerValor("cheques"))		+	clng(cheque_melipilla)
  letras_melipilla		=	clng(melipilla.ObtenerValor("letras"))		+	clng(letras_melipilla)
  efectivo_melipilla	=	clng(melipilla.ObtenerValor("efectivo"))	+	clng(efectivo_melipilla)
  vale_vista_melipilla	=	clng(melipilla.ObtenerValor("vale_vista"))	+	clng(vale_vista_melipilla)
  credito_melipilla		=	clng(melipilla.ObtenerValor("credito"))		+	clng(credito_melipilla)
  debito_melipilla		=	clng(melipilla.ObtenerValor("debito"))		+	clng(debito_melipilla)
  Pagare_melipilla		=	clng(melipilla.ObtenerValor("Pagare"))		+	clng(Pagare_melipilla)
  muldebito_melipilla	=	clng(melipilla.ObtenerValor("multidebito"))		+	clng(muldebito_melipilla)
  pagare_upa_melipilla	=	clng(melipilla.ObtenerValor("pagare_upa"))		+	clng(pagare_upa_melipilla)  
  total_melipilla		=	clng(melipilla.ObtenerValor("total"))		+	clng(total_melipilla)

  wend %>
    <TR>
	  <TH colspan="2">Totales x Documentos:</TH>
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

<p>&nbsp;</p>
<p></p>
<p></p> 
<font color="#0000FF" size="+1"><strong>Sede Bustamante</strong></font>
<table width="100%" border="1">
  <tr> 
    <td width="10%" bgcolor="#FFFFCC" ><div align="center"><strong>N° Caja</strong></div></td>
    <td width="20%" bgcolor="#FFFFCC"><div align="center"><strong>Cajero</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Cheques</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Letras</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Efectivo</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Vale Vista</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>T. Credito</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>T. Debito</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Pagare TB</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>MultiDebito</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Pagare Upa</strong></div></td>    
	<td width="10%" bgcolor="#CCFFFF"><div align="center"><strong>Total Caja</strong></div></td>
	
  </tr>
  <%  
     while bustamante.Siguiente %>
  <tr> 
	<td><div align="center"><%=bustamante.ObtenerValor("mcaj_ncorr")%></div></td>
	<td><div align="center"><%=bustamante.ObtenerValor("cajero")%></div></td>
	<td><div align="center"><%=FormatCurrency(bustamante.ObtenerValor("cheques"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(bustamante.ObtenerValor("letras"),0)%></div></td>
    <td><div align="center"><%=FormatCurrency(bustamante.ObtenerValor("efectivo"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(bustamante.ObtenerValor("vale_vista"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(bustamante.ObtenerValor("credito"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(bustamante.ObtenerValor("debito"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(bustamante.ObtenerValor("Pagare"),0)%></div></td>
    <td><div align="center"><%=FormatCurrency(bustamante.ObtenerValor("multidebito"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(bustamante.ObtenerValor("pagare_upa"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(bustamante.ObtenerValor("total"),0)%></div></td>

  </tr>
  <% 
  '***	TOTALIZA MONTOS	**********************
  cheque_bustamante		=	clng(bustamante.ObtenerValor("cheques"))	+	clng(cheque_bustamante)
  letras_bustamante		=	clng(bustamante.ObtenerValor("letras"))		+	clng(letras_bustamante)
  efectivo_bustamante	=	clng(bustamante.ObtenerValor("efectivo"))	+	clng(efectivo_bustamante)
  vale_vista_bustamante	=	clng(bustamante.ObtenerValor("vale_vista"))	+	clng(vale_vista_bustamante)
  credito_bustamante	=	clng(bustamante.ObtenerValor("credito"))	+	clng(credito_bustamante)
  debito_bustamante		=	clng(bustamante.ObtenerValor("debito"))		+	clng(debito_bustamante)
  Pagare_bustamante		=	clng(bustamante.ObtenerValor("Pagare"))		+	clng(Pagare_bustamante)
  multidebito_bustamante=	clng(bustamante.ObtenerValor("multidebito"))	+	clng(multidebito_bustamante)
  pagare_upa_bustamante	=	clng(bustamante.ObtenerValor("pagare_upa"))		+	clng(pagare_upa_bustamante)  
  total_bustamante		=	clng(bustamante.ObtenerValor("total"))		+	clng(total_bustamante)

  wend %>
    <TR>
	  <TH colspan="2">Totales x Documentos:</TH>
	  <TH><%=FormatCurrency(cheque_bustamante,0)%></TH>
	  <TH><%=FormatCurrency(letras_bustamante,0)%></TH>
	  <TH><%=FormatCurrency(efectivo_bustamante,0)%></TH>
	  <TH><%=FormatCurrency(vale_vista_bustamante,0)%></TH>
	  <TH><%=FormatCurrency(credito_bustamante,0)%></TH>
	  <TH><%=FormatCurrency(debito_bustamante,0)%></TH>
	  <TH><%=FormatCurrency(Pagare_bustamante,0)%></TH>
	  <TH><%=FormatCurrency(multidebito_bustamante,0)%></TH>
	  <TH><%=FormatCurrency(pagare_upa_bustamante,0)%></TH>          
	  <TH><%=FormatCurrency(total_bustamante,0)%></TH>  

  </TR>

</table>

<p>&nbsp;</p>
<p></p>
<p></p> 
<font color="#0000FF" size="+1"><strong>Sede Concepcion</strong></font>
<table width="100%" border="1">
  <tr> 
    <td width="10%" bgcolor="#FFFFCC" ><div align="center"><strong>N° Caja</strong></div></td>
    <td width="20%" bgcolor="#FFFFCC"><div align="center"><strong>Cajero</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Cheques</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Letras</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Efectivo</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Vale Vista</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>T. Credito</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>T. Debito</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Pagare</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>MultiDebito</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Pagare Upa</strong></div></td>       
	<td width="10%" bgcolor="#CCFFFF"><div align="center"><strong>Total Caja</strong></div></td>
	
  </tr>
  <%  
     while concepcion.Siguiente %>
  <tr> 
	<td><div align="center"><%=concepcion.ObtenerValor("mcaj_ncorr")%></div></td>
	<td><div align="center"><%=concepcion.ObtenerValor("cajero")%></div></td>
	<td><div align="center"><%=FormatCurrency(concepcion.ObtenerValor("cheques"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(concepcion.ObtenerValor("letras"),0)%></div></td>
    <td><div align="center"><%=FormatCurrency(concepcion.ObtenerValor("efectivo"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(concepcion.ObtenerValor("vale_vista"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(concepcion.ObtenerValor("credito"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(concepcion.ObtenerValor("debito"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(concepcion.ObtenerValor("Pagare"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(concepcion.ObtenerValor("total"),0)%></div></td>

  </tr>
  <% 
  '***	TOTALIZA MONTOS	**********************
  cheque_concepcion		=	clng(concepcion.ObtenerValor("cheques"))	+	clng(cheque_concepcion)
  letras_concepcion		=	clng(concepcion.ObtenerValor("letras"))		+	clng(letras_concepcion)
  efectivo_concepcion	=	clng(concepcion.ObtenerValor("efectivo"))	+	clng(efectivo_concepcion)
  vale_vista_concepcion	=	clng(concepcion.ObtenerValor("vale_vista"))	+	clng(vale_vista_concepcion)
  credito_concepcion	=	clng(concepcion.ObtenerValor("credito"))	+	clng(credito_concepcion)
  debito_concepcion		=	clng(concepcion.ObtenerValor("debito"))		+	clng(debito_concepcion)
  Pagare_concepcion		=	clng(concepcion.ObtenerValor("Pagare"))		+	clng(Pagare_concepcion)
  total_concepcion		=	clng(concepcion.ObtenerValor("total"))		+	clng(total_concepcion)

  wend %>
    <TR>
	  <TH colspan="2">Totales x Documentos:</TH>
	  <TH><%=FormatCurrency(cheque_concepcion,0)%></TH>
	  <TH><%=FormatCurrency(letras_concepcion,0)%></TH>
	  <TH><%=FormatCurrency(efectivo_concepcion,0)%></TH>
	  <TH><%=FormatCurrency(vale_vista_concepcion,0)%></TH>
	  <TH><%=FormatCurrency(credito_concepcion,0)%></TH>
	  <TH><%=FormatCurrency(debito_concepcion,0)%></TH>
	  <TH><%=FormatCurrency(Pagare_concepcion,0)%></TH>
	  <TH><%=FormatCurrency(multidebito_concepcion,0)%></TH>
	  <TH><%=FormatCurrency(pagare_upa_concepcion,0)%></TH>          
	  <TH><%=FormatCurrency(total_concepcion,0)%></TH>  

  </TR>

</table>

<%
' calculo de totales globales por documentos y cajas
v_total_cheques		=	cheque_central		+	cheque_providencia		+	cheque_melipilla	+	cheque_bustamante		+	cheque_concepcion
v_total_letras		=	letras_central		+	letras_providencia		+	letras_melipilla	+	letras_bustamante		+	letras_concepcion
v_total_efectivo	=	efectivo_central	+	efectivo_providencia	+	efectivo_melipilla	+	efectivo_bustamante		+	efectivo_concepcion
v_total_vale_vista	=	vale_vista_central	+	vale_vista_providencia	+	vale_vista_melipilla+	vale_vista_bustamante	+	vale_vista_concepcion
v_total_credito		=	credito_central		+	credito_providencia		+	credito_melipilla	+	credito_bustamante		+	credito_concepcion
v_total_debito		=	debito_central		+	debito_providencia		+	debito_melipilla	+	debito_bustamante		+	debito_concepcion
v_total_Pagare		=	Pagare_central		+	Pagare_providencia		+	Pagare_melipilla	+	Pagare_bustamante		+	Pagare_concepcion
v_total_multidebito	=	multidebito_central		+	multidebito_providencia		+	multidebito_melipilla	+	multidebito_bustamante		+	multidebito_concepcion
v_total_pagare_upa	=	pagare_upa_central		+	pagare_upa_providencia		+	pagare_upa_melipilla	+	pagare_upa_bustamante		+	pagare_upa_concepcion
v_total_cajas		=	total_central		+	total_providencia		+	total_melipilla		+	total_bustamante		+	total_concepcion


%>
<p>&nbsp;</p>

<font color="#000000" size="+1" ><strong>Totalizacion de los ingresos del d&iacute;a </strong></font>
<table width="100%" border="1">
<tr>
    <td width="30%" colspan="2"></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Cheques</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Letras</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Efectivo</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Vale Vista</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>T. Credito</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>T. Debito</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Pagare TB</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>MultiDebito</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Pagare Upa</strong></div></td>       
	<td width="10%" bgcolor="#CCFFFF" ><div align="center"><strong>Total Global</strong></div></td>
</tr>
    <TR>
	  <TH colspan="2" bgcolor="#CCFFFF">Totales Globales x Documentos:</TH>
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