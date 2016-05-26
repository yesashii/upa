<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=horas_tomadas.xls"
Response.ContentType = "application/vnd.ms-excel"

peri_ccod=request.QueryString("peri_ccod")
sede_ccod=request.QueryString("sede_ccod")
fecha_consulta=request.QueryString("fecha_consulta")
indice=request.QueryString("indice")
if indice="" then

indice=-99
end if
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion

  usu=negocio.obtenerUsuario
 
'response.Write(sql_descuentos)
 if not esVacio(fecha_consulta) then
 	 dia_semana = conexion.consultaUno("select datepart(weekday,convert(datetime,'"&fecha_consulta&"',103))") 
' 
	 'response.Write(dia_semana)
 end if
 fecha_trabajo = Array("","","","","","","","")
 if not esVacio(fecha_consulta) then
 	 if dia_semana = "1" then
		  fecha_trabajo(1) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)")
		  fecha_trabajo(2) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+1")
		  fecha_trabajo(3) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+2")
		  fecha_trabajo(4) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+3")
		  fecha_trabajo(5) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+4")
		  fecha_trabajo(6) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+5")
		  fecha_trabajo(7) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+6")
	 elseif dia_semana = "2" then
		  fecha_trabajo(1) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-1")
		  fecha_trabajo(2) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)")
		  fecha_trabajo(3) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+1")
		  fecha_trabajo(4) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+2")
		  fecha_trabajo(5) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+3")
		  fecha_trabajo(6) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+4")
		  fecha_trabajo(7) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+5")
	 elseif dia_semana = "3" then
		  fecha_trabajo(1) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-2")
		  fecha_trabajo(2) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-1")
		  fecha_trabajo(3) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)")
		  fecha_trabajo(4) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+1")
		  fecha_trabajo(5) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+2")
		  fecha_trabajo(6) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+3")
		  fecha_trabajo(7) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+4") 
     elseif dia_semana = "4" then
		  fecha_trabajo(1) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-3")
		  fecha_trabajo(2) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-2")
		  fecha_trabajo(3) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-1")
		  fecha_trabajo(4) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)")
		  fecha_trabajo(5) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+1")
		  fecha_trabajo(6) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+2")
		  fecha_trabajo(7) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+3") 
	 elseif dia_semana = "5" then
		  fecha_trabajo(1) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-4")
		  fecha_trabajo(2) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-3")
		  fecha_trabajo(3) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-2")
		  fecha_trabajo(4) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-1")
		  fecha_trabajo(5) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)")
		  fecha_trabajo(6) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+1")
		  fecha_trabajo(7) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+2") 
	 elseif dia_semana = "6" then
		  fecha_trabajo(1) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-5")
		  fecha_trabajo(2) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-4")
		  fecha_trabajo(3) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-3")
		  fecha_trabajo(4) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-2")
		  fecha_trabajo(5) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-1")
		  fecha_trabajo(6) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)")
		  fecha_trabajo(7) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+1") 
	 elseif dia_semana = "7" then
		  fecha_trabajo(1) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-6")
		  fecha_trabajo(2) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-5")
		  fecha_trabajo(3) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-4")
		  fecha_trabajo(4) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-3")
		  fecha_trabajo(5) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-2")
		  fecha_trabajo(6) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-1")
		  fecha_trabajo(7) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)") 	  
     end if
 end if
 
 
 if fecha_consulta<>"" then
s_es_lunes = "select case when protic.trunc('"&fecha_trabajo(1)&"')=protic.trunc(getdate())and datepart(weekday,convert(datetime,'"&fecha_trabajo(1)&"',103))=datepart(weekday,convert(datetime,getdate(),103))then 1  else 0 end"
s_es_martes = "select case when protic.trunc('"&fecha_trabajo(2)&"')=protic.trunc(getdate())and datepart(weekday,convert(datetime,'"&fecha_trabajo(2)&"',103))=datepart(weekday,convert(datetime,getdate(),103))then 1  else 0 end"
s_es_miercoles = "select case when protic.trunc('"&fecha_trabajo(3)&"')=protic.trunc(getdate())and datepart(weekday,convert(datetime,'"&fecha_trabajo(3)&"',103))=datepart(weekday,convert(datetime,getdate(),103))then 1  else 0 end"
s_es_jueves = "select case when protic.trunc('"&fecha_trabajo(4)&"')=protic.trunc(getdate())and datepart(weekday,convert(datetime,'"&fecha_trabajo(4)&"',103))=datepart(weekday,convert(datetime,getdate(),103))then 1  else 0 end"
s_es_viernes = "select case when protic.trunc('"&fecha_trabajo(5)&"')=protic.trunc(getdate())and datepart(weekday,convert(datetime,'"&fecha_trabajo(5)&"',103))=datepart(weekday,convert(datetime,getdate(),103))then 1  else 0 end"
 'response.Write("<br>s_es_hoy= "&s_es_hoy)
es_lunes =conexion.consultaUno(s_es_lunes)
es_martes =conexion.consultaUno(s_es_martes)
es_miercoles =conexion.consultaUno(s_es_miercoles)
es_jueves =conexion.consultaUno(s_es_jueves)
es_viernes =conexion.consultaUno(s_es_viernes)
 'response.Write("<br>es hoy= "&es_hoy)
 end if
 

consulta_modulo="select case count(*) when 0 then 'No' else 'Si' end  from bloques_sicologos a,"& vbcrlf & _
"sicologos_sede b,"& vbcrlf & _
"sicologos c"& vbcrlf & _
"where a.side_ncorr=b.side_ncorr"& vbcrlf & _
"and b.sico_ncorr=c.sico_ncorr"& vbcrlf & _
"and c.pers_ncorr=protic.obtener_pers_ncorr("&usu&")"& vbcrlf & _
"and a.peri_ccod="&peri_ccod&""
tiene_bloque_creado=conexion.ConsultaUno(consulta_modulo)

side_ncorr=conexion.ConsultaUno("select side_ncorr from sicologos_sede a, sicologos b where a.sico_ncorr=b.sico_ncorr and b.pers_ncorr=protic.obtener_pers_ncorr("&usu&") and sede_ccod="&sede_ccod&"")
 
 set f_horas = new CFormulario
f_horas.Carga_Parametros "crea_modulos_sicologos.xml", "hora"
f_horas.Inicializar conexion
if sede_ccod<>"" and tiene_bloque_creado="Si" then  
sql_hora= "select hora_ini+'-'+hora_fin as hora,"& vbcrlf & _
"isnull((select case when count(*)>0 then '<a style="&CHR(034)&"cursor:pointer"&CHR(034)&"  title="&CHR(034) &"'+pers_tnombre+' '+pers_tape_paterno+'"&CHR(034) &">'+cast(pers_nrut as varchar)+'-'+pers_xdv+'</a>' else '--' end from horas_tomadas aa, personas bb where aa.pers_ncorr=bb.PERS_NCORR and aa.blsi_ncorr=a.blsi_ncorr and convert(datetime,hoto_fecha,103)=convert(datetime,'"&fecha_trabajo(1)&"',103) and esho_ccod in (1,2) group by hoto_ncorr,pers_tnombre,pers_tape_paterno,pers_nrut,pers_xdv),'<a>&nbsp;</a>')as lunes ,"& vbcrlf & _
"isnull((select case when count(*)>0 then '<a style="&CHR(034)&"cursor:pointer"&CHR(034)&"  title="&CHR(034) &"'+pers_tnombre+' '+pers_tape_paterno+'"&CHR(034) &">'+cast(pers_nrut as varchar)+'-'+pers_xdv+'</a>' else '--' end from horas_tomadas aa, personas bb where aa.pers_ncorr=bb.PERS_NCORR and aa.blsi_ncorr=a.blsi_ncorr and convert(datetime,hoto_fecha,103)=convert(datetime,'"&fecha_trabajo(2)&"',103) and esho_ccod in (1,2) group by hoto_ncorr,pers_tnombre,pers_tape_paterno,pers_nrut,pers_xdv),'<a>&nbsp;</a>')as martes ,"& vbcrlf & _
"isnull((select case when count(*)>0 then '<a style="&CHR(034)&"cursor:pointer"&CHR(034)&"  title="&CHR(034) &"'+pers_tnombre+' '+pers_tape_paterno+'"&CHR(034) &">'+cast(pers_nrut as varchar)+'-'+pers_xdv+'</a>' else '--' end from horas_tomadas aa, personas bb where aa.pers_ncorr=bb.PERS_NCORR and aa.blsi_ncorr=a.blsi_ncorr and convert(datetime,hoto_fecha,103)=convert(datetime,'"&fecha_trabajo(3)&"',103) and esho_ccod in (1,2) group by hoto_ncorr,pers_tnombre,pers_tape_paterno,pers_nrut,pers_xdv),'<a>&nbsp;</a>')as miercoles ,"& vbcrlf & _
"isnull((select case when count(*)>0 then '<a style="&CHR(034)&"cursor:pointer"&CHR(034)&"  title="&CHR(034) &"'+pers_tnombre+' '+pers_tape_paterno+'"&CHR(034) &">'+cast(pers_nrut as varchar)+'-'+pers_xdv+'</a>' else '--' end from horas_tomadas aa, personas bb where aa.pers_ncorr=bb.PERS_NCORR and aa.blsi_ncorr=a.blsi_ncorr and convert(datetime,hoto_fecha,103)=convert(datetime,'"&fecha_trabajo(4)&"',103) and esho_ccod in (1,2) group by hoto_ncorr,pers_tnombre,pers_tape_paterno,pers_nrut,pers_xdv),'<a>&nbsp;</a>')as jueves ,"& vbcrlf & _
"isnull((select case when count(*)>0 then '<a style="&CHR(034)&"cursor:pointer"&CHR(034)&"  title="&CHR(034) &"'+pers_tnombre+' '+pers_tape_paterno+'"&CHR(034) &">'+cast(pers_nrut as varchar)+'-'+pers_xdv+'</a>' else '--' end from horas_tomadas aa, personas bb where aa.pers_ncorr=bb.PERS_NCORR and aa.blsi_ncorr=a.blsi_ncorr and convert(datetime,hoto_fecha,103)=convert(datetime,'"&fecha_trabajo(5)&"',103) and esho_ccod in (1,2) group by hoto_ncorr,pers_tnombre,pers_tape_paterno,pers_nrut,pers_xdv),'<a>&nbsp;</a>')as viernes "& vbcrlf & _
"from bloques_sicologos a,"& vbcrlf & _
"sicologos_sede b,"& vbcrlf & _
"sicologos c"& vbcrlf & _
"where a.side_ncorr=b.side_ncorr"& vbcrlf & _
"and b.sico_ncorr=c.sico_ncorr"& vbcrlf & _
"and b.sede_ccod="&sede_ccod&""& vbcrlf & _
"and a.peri_ccod="&peri_ccod&""& vbcrlf & _
"and c.pers_ncorr=protic.obtener_pers_ncorr("&usu&")"
else
sql_hora="select ''"
end if

'response.Write("<br>"&sql_hora)
f_horas.Consultar sql_hora


'------------------------------------------------------------------------
%>
 <html>
<head>
<title><%=pagina.Titulo%></title>  

</head>
<body bgcolor="#ffffff" leftmargin="43" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="98%" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" border="2" bordercolor="#0099CC">
								<tr> 
									<td colspan="5" align="center">&nbsp;</td>
								</tr>
								<tr>
									<td align="center"><font size="3" color="#0099CC">HORA</font></td>
									
										<td align="center"><font size="3" color="#0099CC">LUNES</font><br><font color="#990000"><%=fecha_trabajo(1)%></font></td>
								
										<td align="center"><font size="3" color="#0099CC">MARTES</font><br><font color="#990000"><%=fecha_trabajo(2)%></font></td>
								
										<td align="center"><font size="3" color="#0099CC">MIERCOLES</font><br><font color="#990000"><%=fecha_trabajo(3)%></font></td>
									
										<td align="center"><font size="3" color="#0099CC">JUEVES</font><br><font color="#990000"><%=fecha_trabajo(4)%></font></td>
									
										<td align="center"><font size="3" color="#0099CC">VIERNES</font><br><font color="#990000"><%=fecha_trabajo(5)%></font></td>
									
									
								</tr>
									<%while f_horas.siguiente%>
								    <tr>
									    <td align="center"><font color="#000000"><%=f_horas.ObtenerValor("hora")%></font></td>
									
										<td align="center"><font color="#000000"><%=f_horas.ObtenerValor("lunes")%></font></td>
										
										<td align="center"><font color="#000000"><%=f_horas.ObtenerValor("martes")%></font></td>
										
										<td align="center"><font color="#000000"><%=f_horas.ObtenerValor("miercoles")%></font></td>
										
										<td align="center"><font color="#000000"><%=f_horas.ObtenerValor("jueves")%></font></td>
										
										<td align="center"><font color="#000000"><%=f_horas.ObtenerValor("viernes")%></font></td>
							    	<%wend%>
									</tr>
								
						        </table>
</html>