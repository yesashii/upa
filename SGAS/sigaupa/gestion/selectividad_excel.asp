<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=Indice_de_Selectividad.xls"
Response.ContentType = "application/vnd.ms-excel"

anos_ccod = Request.QueryString("anos_ccod")
tasa = Request.QueryString("tasa")
tasa_informar = Request.QueryString("tasa_informar")

'------------------------------------------------------------------------------------
set pagina = new CPagina
'------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_carreras = new CFormulario
f_carreras.Carga_Parametros "tabla_vacia.xml", "tabla"
f_carreras.Inicializar conexion
	
			 consulta = " select distinct c.carr_ccod,carr_tdesc as carrera, "& vbCrLf &_
						" ( select count(distinct ax.pers_ncorr) "& vbCrLf &_
						"  from alumnos ax, ofertas_academicas bx, personas cx, periodos_academicos dx,especialidades ex  "& vbCrLf &_
						"  where ax.ofer_ncorr=bx.ofer_ncorr and ax.pers_ncorr=cx.pers_ncorr  "& vbCrLf &_
						"  and bx.peri_ccod = dx.peri_ccod and bx.espe_ccod = ex.espe_ccod and ax.emat_ccod <> 9 "& vbCrLf &_
						"  and exists(select 1 from cargas_Academicas carg where carg.matr_ncorr=ax.matr_ncorr)  "& vbCrLf &_
						"  and dx.anos_ccod = '"&anos_ccod&"' and ex.carr_ccod=b.carr_ccod "& vbCrLf &_
						"  and not exists (select 1 from alumnos alu, ofertas_academicas ofe, periodos_academicos pea,especialidades esp  "& vbCrLf &_
						"  where alu.pers_ncorr=ax.pers_ncorr and alu.ofer_ncorr=ofe.ofer_ncorr and ofe.peri_ccod=pea.peri_ccod  "& vbCrLf &_
						"  and pea.anos_ccod < dx.anos_ccod  and ofe.espe_ccod=esp.espe_ccod and esp.carr_ccod=ex.carr_ccod) "& vbCrLf &_
						" ) as total_alumnos "& vbCrLf &_
						" from ofertas_academicas a, especialidades b, carreras c, periodos_academicos d "& vbCrLf &_
						" where a.espe_ccod=b.espe_ccod and b.carr_ccod=c.carr_ccod and a.peri_ccod=d.peri_ccod "& vbCrLf &_
						" and cast(d.anos_ccod as varchar)='"&anos_ccod&"' "& vbCrLf &_
						" and exists (select 1 from alumnos aa, cargas_academicas bb "& vbCrLf &_
						"            where aa.ofer_ncorr=a.ofer_ncorr and aa.matr_ncorr=bb.matr_ncorr "& vbCrLf &_
						"            and aa.emat_ccod =1) "& vbCrLf &_
						" order by carrera asc   "
 f_carreras.consultar consulta
	  
	  
total = 0
while f_carreras.siguiente
	total = total + cint(f_carreras.obtenerValor("total_alumnos"))
wend
f_carreras.primero

%>
<html>
<head>
<title>Indice de Selectividad</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="75%" border="1">
  <tr>
    <td align="center" colspan="8"><font size="+2">Indice de Selectividad</font> </td>
  </tr>
  <tr>
    <td align="center" colspan="8"><font size="+2">&nbsp;</font> </td>
  </tr>
  <tr>
    <td align="left" colspan="2"><font size="+1"><strong>Año</strong></font></td>
    <td align="left" colspan="6"><font size="+1"><strong>: </strong><%=anos_ccod%></font></td>
  </tr>
  <tr>
    <td align="left" colspan="2"><font size="+1"><strong>Tasa de corte</strong></font></td>
    <td align="left" colspan="6"><font size="+1"><strong>: </strong><%=tasa%></font></td>
  </tr>
    <tr>
    <td align="left" colspan="2"><font size="+1"><strong>Tasa a informar</strong></font></td>
    <td align="left" colspan="6"><font size="+1"><strong>: </strong><%=tasa_informar%></font></td>
  </tr>
  <tr>
    <td align="center" colspan="8"><font size="+2">&nbsp;</font> </td>
  </tr>
  <tr>
    <td width="2%"  bgcolor="#FFFFCC"><div align="center"><strong>N°</strong></div></td>
    <td width="32%"  bgcolor="#FFFFCC"><div align="center"><strong>CARRERA</strong></div></td>
    <td width="9%"  bgcolor="#FFFFCC"><div align="center"><strong>TOTAL ALUMNOS</strong></div></td>
    <td width="7%"  bgcolor="#FFFFCC"><div align="center"><strong>TASA DE CORTE</strong></div></td>
    <td width="2%"  bgcolor="#FFFFCC"><div align="center"><strong> >= <%=tasa%> </strong></div></td>
	<td width="15%"  bgcolor="#FFFFCC"><div align="center"><strong>INDICE DE SELECTIVIDAD REAL</strong></div></td>
	<td width="11%"  bgcolor="#FFFFCC"><div align="center"><strong>TOTAL ALUMNOS A INFORMAR</strong></div></td>
	<td width="22%"  bgcolor="#FFFFCC"><div align="center"><strong>INDICE DE SELECTIVIDAD A INFORMAR</strong></div></td>
  </tr>
  <% fila = 1 
     total_tasas = 0 
	 total_informar = 0
  while f_carreras.Siguiente %>
  <tr>
    <td><div align="left"><%=fila%></div></td>
    <td><div align="left"><%=f_carreras.ObtenerValor("carrera")%></div></td>
    <td><div align="center"><%=f_carreras.ObtenerValor("total_alumnos")%></div></td>
    <td><div align="left"><%=tasa%></div></td>
	<%
		total_cumplen = conexion.consultaUno("select protic.obtener_indice_selectividad_carrera('"&f_carreras.ObtenerValor("carr_ccod")&"',"&anos_ccod&","&tasa&")")
	    total_tasas = total_tasas + cint(total_cumplen)
		total_beta = f_carreras.ObtenerValor("total_alumnos")
		total_beta_informar = conexion.consultaUno("select protic.obtener_indice_selectividad_carrera('"&f_carreras.ObtenerValor("carr_ccod")&"',"&anos_ccod&","&tasa_informar&")")

		if total_beta > 0 then
			calculo = (cdbl(total_cumplen) / cdbl(total_beta)) * 100.00
		else
			calculo = 0
		end if
		
		total_calculado = formatnumber(calculo,2,-1,0,0)
		total_informar = total_informar + cint(total_beta_informar)
		if cint(total_beta_informar) > 0 then
			calculo2 = (cdbl(total_cumplen) / cdbl(total_beta_informar)) * 100.00
		else
			calculo2 = 0
		end if
		total_calculado2 = formatnumber(calculo2,2,-1,0,0)
	%>
    <td><div align="left"><%=total_cumplen%></div></td>
    <td bgcolor="#FFFFCC"><div align="left"><%=total_calculado%> % </div></td>
	<td><div align="center"><%=total_beta_informar%></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><%=total_calculado2%> % </div></td>
  </tr>
  <% fila= fila + 1 
    wend %>
	<tr>
		<td colspan="2" align="right"><strong>TOTALES</strong></td>
		<td><div align="center"><strong><%=total%></strong></div></td>
		<td><div align="left"><strong>&nbsp;</strong></div></td>
		<td><div align="left"><strong><%=total_tasas%></strong></div></td>
		<%
			if total > 0 then
				calculo = (cdbl(total_tasas) / cdbl(total)) * 100.00
			else
				calculo = 0
			end if
			indice_universidad = formatnumber(calculo,2,-1,0,0)
			
			if total_informar > 0 then
				calculo2 = (cdbl(total_tasas) / cdbl(total_informar)) * 100.00
			else
				calculo2 = 0
			end if
			indice_universidad_informar = formatnumber(calculo2,2,-1,0,0)
		%>
		<td bgcolor="#FFFFCC"><div align="left"><strong><%=indice_universidad%> %</strong></div></td>
		<td><div align="center"><strong><%=total_informar%></strong></div></td>
		<td bgcolor="#FFFFCC"><div align="left"><strong><%=indice_universidad_informar%> %</strong></div></td>
	</tr>
</table>
</body>
</html>