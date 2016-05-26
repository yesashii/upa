<!-- #include file = "../biblioteca/_conexion.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=estadisticas_egreso_titulacion.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 350000
set conexion = new CConexion
conexion.Inicializar "upacifico"

'-----------------------------------------------------------------------
upa_pregrado  =  request.QueryString("upa_pregrado")
upa_postgrado =  request.QueryString("upa_postgrado")
instituto     =  request.QueryString("instituto")

egresados  	  =  request.QueryString("egresados")
titulados     =  request.QueryString("titulados")
graduados     =  request.QueryString("graduados")
salidas_int   =  request.QueryString("salidas_int")

femenino      =  request.QueryString("femenino")
masculino     =  request.QueryString("masculino")

facu_ccod     =  request.QueryString("facu_ccod")
carr_ccod     =  request.QueryString("carr_ccod")


 fecha_modificacion =  request.QueryString("fecha_modificacion")

fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------


set f_lista = new CFormulario
f_lista.Carga_Parametros "tabla_vacia.xml", "tabla"
f_lista.Inicializar conexion

consulta =  "select a.sede_ccod,a.sede_tdesc as sede  "
            if upa_pregrado = "1" then
				if egresados = "1" then
					if masculino = "1" then
						consulta = consulta & ",protic.estadistica_titulados(a.sede_ccod,1,'U','UEG',"&facu_ccod&",'"&carr_ccod&"') as egresados_U_hombres  "
					end if
					if femenino = "1" then
						consulta = consulta & ",protic.estadistica_titulados(a.sede_ccod,2,'U','UEG',"&facu_ccod&",'"&carr_ccod&"') as egresados_U_mujeres  "
					end if
				end if
				if titulados = "1" then
					if masculino = "1" then
						consulta = consulta & ",protic.estadistica_titulados(a.sede_ccod,1,'U','UTI',"&facu_ccod&",'"&carr_ccod&"') as titulados_U_hombres  "
					end if
					if femenino = "1" then
						consulta = consulta & ",protic.estadistica_titulados(a.sede_ccod,2,'U','UTI',"&facu_ccod&",'"&carr_ccod&"') as titulados_U_mujeres   "
					end if
				end if
				if graduados = "1" then
					if masculino = "1" then
						consulta = consulta & ",protic.estadistica_titulados(a.sede_ccod,1,'U','PRG',"&facu_ccod&",'"&carr_ccod&"') as graduados_PR_hombres  "
					end if
					if femenino = "1" then
						consulta = consulta & ",protic.estadistica_titulados(a.sede_ccod,2,'U','PRG',"&facu_ccod&",'"&carr_ccod&"') as graduados_PR_mujeres  "
					end if
				end if
				if salidas_int = "1" then
					if masculino = "1" then
						consulta = consulta & ",protic.estadistica_titulados(a.sede_ccod,1,'U','SIE',"&facu_ccod&",'"&carr_ccod&"') as SIE_hombres  "
					end if
					if femenino = "1" then
						consulta = consulta & ",protic.estadistica_titulados(a.sede_ccod,2,'U','SIE',"&facu_ccod&",'"&carr_ccod&"') as SIE_mujeres  "
					end if
					if masculino = "1" then
						consulta = consulta & ",protic.estadistica_titulados(a.sede_ccod,1,'U','SIT',"&facu_ccod&",'"&carr_ccod&"') as SIT_hombres  "
					end if
					if femenino = "1" then
						consulta = consulta & ",protic.estadistica_titulados(a.sede_ccod,2,'U','SIT',"&facu_ccod&",'"&carr_ccod&"') as SIT_mujeres  "
					end if
				end if
            end if
			if instituto = "1" then
				if egresados = "1" then
					if masculino = "1" then
						consulta = consulta & ",isnull(protic.estadistica_titulados(a.sede_ccod,1,'I','IEG',"&facu_ccod&",'"&carr_ccod&"'),0) as egresados_I_hombres  "
					end if
					if femenino = "1" then
						consulta = consulta & ",isnull(protic.estadistica_titulados(a.sede_ccod,2,'I','IEG',"&facu_ccod&",'"&carr_ccod&"'),0) as egresados_I_mujeres  "
					end if
				end if
				if titulados = "1" then
					if masculino = "1" then
						consulta = consulta & ",isnull(protic.estadistica_titulados(a.sede_ccod,1,'I','ITI',"&facu_ccod&",'"&carr_ccod&"'),0) as titulados_I_hombres  "
					end if
					if femenino = "1" then
						consulta = consulta & ",isnull(protic.estadistica_titulados(a.sede_ccod,2,'I','ITI',"&facu_ccod&",'"&carr_ccod&"'),0) as titulados_I_mujeres  "
					end if
				end if
			end if
			if upa_postgrado = "1" then
				if graduados = "1" then
					if masculino = "1" then
						consulta = consulta & ",protic.estadistica_titulados(a.sede_ccod,1,'U','POG',"&facu_ccod&",'"&carr_ccod&"') as graduados_PO_hombres "
					end if
					if femenino = "1" then
						consulta = consulta & ",protic.estadistica_titulados(a.sede_ccod,2,'U','POG',"&facu_ccod&",'"&carr_ccod&"') as graduados_PO_mujeres "
					end if
				end if	
			end if
			
			consulta = consulta & " from sedes a  "& vbCrLf &_
								  " order by sede_tdesc asc "

'consulta = " select * from sexos"
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_lista.Consultar consulta 

%>
<html>
<head>
<title>ESTADÍSTICAS EGRESADOS, TITULADOS Y GRADUADOS</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
  <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">ESTADÍSTICAS EGRESADOS, TITULADOS Y GRADUADOS</font></div>
	<div align="right"><%=fecha%></div></td>
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
</table>

<p>&nbsp;</p>
<table width="100%" border="1">
   <tr>
   		<td width="100%" align="center">
			<table class='v1' width='100%' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD' id='tb_secciones'>
				<tr bgcolor='#C4D7FF' bordercolor='#999999'>
					<th><font color='#333333'>&nbsp;</font></th>
					<%if upa_pregrado = "1" then%>
						<th colspan="10"><font color='#333333'>Universidad Pregrado</font></th>
					<%end if%>
					<%if upa_postgrado = "1" then%>
						<th colspan="2"><font color='#333333'>Universidad Postgrado</font></th>
					<%end if%>
					<%if instituto = "1" then%>
						<th colspan="4"><font color='#333333'>Instituto</font></th>
					<%end if%>
				</tr>
				<tr bgcolor='#C4D7FF' bordercolor='#999999'>
					<th><font color='#333333'>Sede</font></th>
					<%if upa_pregrado = "1" then%>
						<th colspan="2"><font color='#333333'>Egresados</font></th>
						<th colspan="2"><font color='#333333'>Titulados</font></th>
						<th colspan="2"><font color='#333333'>Grados</font></th>
						<th colspan="2"><font color='#333333'>S.I.E</font></th>
						<th colspan="2"><font color='#333333'>S.I.T</font></th>
					<%end if%>
					<%if upa_postgrado = "1" then%>
						<th colspan="2"><font color='#333333'>Grados</font></th>
					<%end if%>
					<%if instituto = "1" then%>
						<th colspan="2"><font color='#333333'>Egresados</font></th>
						<th colspan="2"><font color='#333333'>Titulados</font></th>
					<%end if%>
				</tr>
				<tr bgcolor='#C4D7FF' bordercolor='#999999'>
					<th><font color='#333333'>&nbsp;</font></th>
					<%if upa_pregrado = "1" then%>
						<th><font color='#333333'>H</font></th>
						<th><font color='#333333'>M</font></th>
						<th><font color='#333333'>H</font></th>
						<th><font color='#333333'>M</font></th>
						<th><font color='#333333'>H</font></th>
						<th><font color='#333333'>M</font></th>
						<th><font color='#333333'>H</font></th>
						<th><font color='#333333'>M</font></th>
						<th><font color='#333333'>H</font></th>
						<th><font color='#333333'>M</font></th>
					<%end if%>
  					<%if upa_postgrado = "1" then%>
						<th><font color='#333333'>H</font></th>
						<th><font color='#333333'>M</font></th>
					<%end if%>
					<%if instituto = "1" then%>
						<th><font color='#333333'>H</font></th>
						<th><font color='#333333'>M</font></th>
						<th><font color='#333333'>H</font></th>
						<th><font color='#333333'>M</font></th>
					<%end if%>
				</tr>
				<%  TEUH = 0
					TEUM = 0
					TTUH = 0
					TTUM = 0
					TGPH = 0
					TGPM = 0
					TESH = 0
					TESM = 0
					TTSH = 0
					TTSM = 0
					TEIH = 0
					TEIM = 0
					TTIH = 0
					TTIM = 0
					TGGH = 0
					TGGM = 0
				  while f_lista.siguiente
				    sede_ccod = f_lista.obtenerValor("sede_ccod")
					sede      = f_lista.obtenerValor("sede")
					if upa_pregrado = "1" then
					    if egresados = "1" then
						    if masculino = "1" then
								EUH       = f_lista.obtenerValor("egresados_U_hombres")
								TEUH = TEUH + cint(EUH)
							end if
							if femenino = "1" then
								EUM       = f_lista.obtenerValor("egresados_U_mujeres")
								TEUM = TEUM + cint(EUM)
							end if
						end if
						if titulados = "1" then
						    if masculino = "1" then
								TUH       = f_lista.obtenerValor("titulados_U_hombres")
								TTUH = TTUH + cint(TUH)
							end if
							if femenino = "1" then
								TUM       = f_lista.obtenerValor("titulados_U_mujeres")
								TTUM = TTUM + cint(TUM) 
							end if
						end if
						if graduados = "1" then
						    if masculino = "1" then
								GPH       = f_lista.obtenerValor("graduados_PR_hombres")
								TGPH = TGPH + cint(GPH)
							end if
							if femenino = "1" then
								GPM       = f_lista.obtenerValor("graduados_PR_mujeres")
								TGPM = TGPM + cint(GPM)
							end if
						end if
						if salidas_int = "1" then
						    if masculino = "1" then	
								ESH       = f_lista.obtenerValor("SIE_hombres")
								TESH = TESH + cint(ESH)
							end if
							if femenino = "1" then
								ESM     = f_lista.obtenerValor("SIE_mujeres")
								TESM = TESM + cint(ESM)
							end if
							if masculino = "1" then
								TSH       = f_lista.obtenerValor("SIT_hombres")
								TTSH = TTSH + cint(TSH)
							end if
							if femenino = "1" then
								TSM       = f_lista.obtenerValor("SIT_mujeres")
								TTSM = TTSM + cint(TSM)
							end if
						end if
					end if
					if instituto = "1" then
					    if egresados = "1" then
						    if masculino = "1" then
								EIH       = f_lista.obtenerValor("egresados_I_hombres")
								TEIH = TEIH + cint(EIH)
							end if
							if femenino = "1" then
								EIM       = f_lista.obtenerValor("egresados_I_mujeres")
								TEIM = TEIM + cint(EIM)
							end if
						end if
						if titulados = "1" then
						    if masculino = "1" then
								TIH       = f_lista.obtenerValor("titulados_I_hombres")
								TTIH = TTIH + cint(TIH)
							end if
							if femenino = "1" then
								TIM       = f_lista.obtenerValor("titulados_I_mujeres")
								TTIM = TTIM + cint(TIM)
							end if
						end if
					end if
					if upa_postgrado = "1" then
					    if graduados = "1" then
						    if masculino = "1" then
								GGH       = f_lista.obtenerValor("graduados_PO_hombres")
								TGGH = TGGH + cint(GGH)
							end if
							if femenino = "1" then
								GGM       = f_lista.obtenerValor("graduados_PO_mujeres")
								TGGM = TGGM + cint(GGM)
							end if
						end if
					end if					
%>
				<tr bgcolor="#FFFFFF">
					<td align='LEFT'><%=sede%></td>
					<%if upa_pregrado = "1" then%>
						<td align='CENTER'><%=EUH%></td>
						<td align='CENTER'><%=EUM%></td>
						<td align='CENTER'><%=TUH%></td>
						<td align='CENTER'><%=TUM%></td>
						<td align='CENTER'><%=GPH%></td>
						<td align='CENTER'><%=GPM%></td>
						<td align='CENTER'><%=ESH%></td>
						<td align='CENTER'><%=ESM%></td>
						<td align='CENTER'><%=TSH%></td>
						<td align='CENTER'><%=TSM%></td>
					<%end if%>
					<%if upa_postgrado = "1" then%>
						<td align='CENTER'><%=GGH%></td>
						<td align='CENTER'><%=GGM%></td>
					<%end if%>
					<%if instituto = "1" then%>
						<td align='CENTER'><%=EIH%></td>
						<td align='CENTER'><%=EIM%></td>
						<td align='CENTER'><%=TIH%></td>
						<td align='CENTER'><%=TIM%></td>
					<%end if%>
				</tr>
				<%wend%>
				<tr bgcolor="#FFFFFF">
					<td align='right'>TOTALES</td>
					<%if upa_pregrado = "1" then%>
						<td align='CENTER'><strong><%=TEUH%></strong></td>
						<td align='CENTER'><strong><%=TEUM%></strong></td>
						<td align='CENTER'><strong><%=TTUH%></strong></td>
						<td align='CENTER'><strong><%=TTUM%></strong></td>
						<td align='CENTER'><strong><%=TGPH%></strong></td>
						<td align='CENTER'><strong><%=TGPM%></strong></td>
						<td align='CENTER'><strong><%=TESH%></strong></td>
						<td align='CENTER'><strong><%=TESM%></strong></td>
						<td align='CENTER'><strong><%=TTSH%></strong></td>
						<td align='CENTER'><strong><%=TTSM%></strong></td>
					<%end if%>
					<%if upa_postgrado = "1" then%>
						<td align='CENTER'><strong><%=TGGH%></strong></td>
						<td align='CENTER'><strong><%=TGGM%></strong></td>
					<%end if%>
					<%if instituto = "1" then%>
						<td align='CENTER'><strong><%=TEIH%></strong></td>
						<td align='CENTER'><strong><%=TEIM%></strong></td>
						<td align='CENTER'><strong><%=TTIH%></strong></td>
						<td align='CENTER'><strong><%=TTIM%></strong></td>
					<%end if%>
				</tr>
			   </table>
		</td>
   </tr>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>