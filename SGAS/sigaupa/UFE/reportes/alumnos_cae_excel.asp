<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 20000
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
Response.AddHeader "Content-Disposition", "attachment;filename=alumnos_con_cae.xls"
Response.ContentType = "application/vnd.ms-excel"

q_pers_nrut=request.Form("b[0][pers_nrut]")
q_pers_xdv=request.Form("b[0][pers_xdv]")
q_anos_ccod=request.Form("b[0][anos_ccod]")
q_taca_ccod=request.QueryString("b[0][taca_ccod]")
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion


if q_pers_nrut<>"" then

  filtro1=filtro1&"and a.pers_nrut="&q_pers_nrut&""

end if

if q_taca_ccod<>"" then
filtro2=filtro2&"and b.taca_ccod="&q_taca_ccod&""
end if

sql_descuentos="select cast(pers_nrut as varchar)+'-'+pers_xdv as rut," & vbCrlf & _ 
"pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre_alumno," & vbCrlf & _ 
"(select top 1 emat_tdesc from alumnos aa,estados_matriculas bb,ofertas_academicas cc,especialidades dd,carreras ee,ufe_carreras_homologadas ff,ufe_carreras_ingresa gg, periodos_academicos hh where aa.PERS_NCORR=a.PERS_NCORR and aa.EMAT_CCOD=bb.EMAT_CCOD and aa.emat_ccod <>9 and aa.OFER_NCORR=cc.OFER_NCORR and cc.ESPE_CCOD=dd.ESPE_CCOD and dd.CARR_CCOD=ee.carr_ccod and ee.carr_ccod=ff.carr_ccod COLLATE Modern_Spanish_CI_AS and ff.car_ing_ncorr=gg.car_ing_ncorr and gg.cod_carrera_ing=b.carrera and cc.PERI_CCOD=hh.PERI_CCOD and hh.ANOS_CCOD=b.anos_ccod order by matr_ncorr desc)as estado_matricula," & vbCrlf & _ 
"c.taca_tdesc as tipo_cae," & vbCrlf & _ 
"(select top 1 isnull(protic.ANO_INGRESO_CARRERA_EGRESA2(aa.pers_ncorr,ff.CARR_CCOD),protic.ANO_INGRESO_UNIVERSIDAD(a.pers_ncorr))as promocion from alumnos aa,estados_matriculas bb,ofertas_academicas cc,especialidades dd,carreras ee,ufe_carreras_homologadas ff,ufe_carreras_ingresa gg, periodos_academicos hh where aa.PERS_NCORR=a.PERS_NCORR and aa.EMAT_CCOD=bb.EMAT_CCOD and aa.emat_ccod <>9 and aa.OFER_NCORR=cc.OFER_NCORR and cc.ESPE_CCOD=dd.ESPE_CCOD and dd.CARR_CCOD=ee.carr_ccod and ee.carr_ccod=ff.carr_ccod COLLATE Modern_Spanish_CI_AS and ff.car_ing_ncorr=gg.car_ing_ncorr and gg.cod_carrera_ing=b.carrera and cc.PERI_CCOD=hh.PERI_CCOD and hh.ANOS_CCOD=b.anos_ccod order by matr_ncorr desc)as promocion," & vbCrlf & _ 
"(select top 1 carr_tdesc from alumnos aa,estados_matriculas bb,ofertas_academicas cc,especialidades dd,carreras ee,ufe_carreras_homologadas ff,ufe_carreras_ingresa gg, periodos_academicos hh where aa.PERS_NCORR=a.PERS_NCORR and aa.EMAT_CCOD=bb.EMAT_CCOD and aa.emat_ccod <>9 and aa.OFER_NCORR=cc.OFER_NCORR and cc.ESPE_CCOD=dd.ESPE_CCOD and dd.CARR_CCOD=ee.carr_ccod and ee.carr_ccod=ff.carr_ccod COLLATE Modern_Spanish_CI_AS and ff.car_ing_ncorr=gg.car_ing_ncorr and gg.cod_carrera_ing=b.carrera and cc.PERI_CCOD=hh.PERI_CCOD and hh.ANOS_CCOD=b.anos_ccod  order by matr_ncorr desc)as carrera," & vbCrlf & _ 
"(select top 1 jorn_tdesc from alumnos aa,estados_matriculas bb,ofertas_academicas cc,especialidades dd,carreras ee,ufe_carreras_homologadas ff,ufe_carreras_ingresa gg,jornadas hh, periodos_academicos ii  where aa.PERS_NCORR=a.PERS_NCORR and aa.EMAT_CCOD=bb.EMAT_CCOD and aa.emat_ccod <>9 and aa.OFER_NCORR=cc.OFER_NCORR and cc.ESPE_CCOD=dd.ESPE_CCOD and dd.CARR_CCOD=ee.carr_ccod and ee.carr_ccod=ff.carr_ccod COLLATE Modern_Spanish_CI_AS and ff.car_ing_ncorr=gg.car_ing_ncorr and gg.cod_carrera_ing=b.carrera and cc.jorn_ccod=hh.jorn_ccod and cc.PERI_CCOD=ii.PERI_CCOD and ii.ANOS_CCOD=b.anos_ccod order by matr_ncorr desc)as jornada," & vbCrlf & _ 
"(select top 1 case post_bnuevo when 'S' then 'NUEVO' else 'ANTIGUO' end from alumnos aa,estados_matriculas bb,ofertas_academicas cc,especialidades dd,carreras ee,ufe_carreras_homologadas ff,ufe_carreras_ingresa gg, periodos_academicos hh where aa.PERS_NCORR=a.PERS_NCORR and aa.EMAT_CCOD=bb.EMAT_CCOD and aa.emat_ccod <>9 and aa.OFER_NCORR=cc.OFER_NCORR and cc.ESPE_CCOD=dd.ESPE_CCOD and dd.CARR_CCOD=ee.carr_ccod and ee.carr_ccod=ff.carr_ccod COLLATE Modern_Spanish_CI_AS and ff.car_ing_ncorr=gg.car_ing_ncorr and gg.cod_carrera_ing=b.carrera and cc.PERI_CCOD=hh.PERI_CCOD and hh.ANOS_CCOD=b.anos_ccod  order by matr_ncorr desc)as tipo_alumno," & vbCrlf & _   
"(select top 1 sede_tdesc from alumnos aa,estados_matriculas bb,ofertas_academicas cc,especialidades dd,carreras ee,ufe_carreras_homologadas ff,ufe_carreras_ingresa gg,sedes hh where aa.PERS_NCORR=a.PERS_NCORR and aa.EMAT_CCOD=bb.EMAT_CCOD and aa.emat_ccod <>9 and aa.OFER_NCORR=cc.OFER_NCORR and cc.ESPE_CCOD=dd.ESPE_CCOD and dd.CARR_CCOD=ee.carr_ccod and ee.carr_ccod=ff.carr_ccod COLLATE Modern_Spanish_CI_AS and ff.car_ing_ncorr=gg.car_ing_ncorr and gg.cod_carrera_ing=b.carrera and cc.sede_ccod=hh.sede_ccod order by matr_ncorr desc)as sede"& vbCrlf & _  
"from personas a," & vbCrlf & _ 
"ufe_alumnos_cae b," & vbCrlf & _ 
"ufe_tipo_alumnos_cae c" & vbCrlf & _ 
"where a.PERS_NRUT=b.RUT" & vbCrlf & _ 
"and b.anos_ccod="&q_anos_ccod&""& vbCrlf & _ 
"and b.esca_ccod=1"& vbCrlf & _ 
""&filtro1&""& vbCrlf & _ 
""&filtro2&""& vbCrlf & _
"and b.taca_ccod=c.taca_ccod"
				

				
fecha=conexion.ConsultaUno("select protic.trunc(getdate())")
hora =conexion.ConsultaUno("select cast(datepart(hour,getdate())as varchar)+':'+cast(datepart(minute,getdate())as varchar)+' hrs'")

'response.write "<pre>"&sql_descuentos&"</pre>"
'response.End()
set f_valor_documentos  = new cformulario
f_valor_documentos.carga_parametros "tabla_vacia.xml", "tabla" 
f_valor_documentos.inicializar conexion							
f_valor_documentos.consultar sql_descuentos

'-------------------------------------------------------------------------------

								

'response.End()		

'------------------------------------------------------------------------------
%>
 <html>
<head>
<title><%=pagina.Titulo%></title>  

</head>
<body bgcolor="#ffffff" leftmargin="43" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="100%" border="1">
  <tr align="center">
    <td></td>
    
    <td><div align="center"><strong>Año <%=q_anos_ccod%></strong></div></td>
	 <td><div align="center"><strong>Reporte hecho el <%=fecha%></strong></div></td>
      <td><div align="left"><strong>a las <%=hora%></strong></div></td>
  </tr>
 
  <tr>
    <td width="14%"><div align="up"><strong>Nombre Alumno</strong></div></td>
    <td width="7%"><div align="center"><strong>Rut</strong></div></td>
	<td width="24%"><div align="center"><strong>Estado Matricula</strong></div></td>
    <td width="18%"><div align="center"><strong>Promocion</strong></div></td>
	 <td width="7%"><div align="center"><strong>Sede</strong></div></td>
	 <td width="7%"><div align="center"><strong>Carrera</strong></div></td>
	 <td width="7%"><div align="center"><strong>Jornada</strong></div></td>
	 <td width="8%"><div align="center"><strong>Tipo Alumno</strong></div></td>
	 <td width="8%"><div align="center"><strong>Tipo Cae</strong></div></td>
  </tr>
  <%  while f_valor_documentos.Siguiente %>
  <tr>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("nombre_alumno")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("rut")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("estado_matricula")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("promocion")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("sede")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("carrera")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("jornada")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("tipo_alumno")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("tipo_cae")%></div></td>
  </tr>
  <%  wend %>
</table>
</html>