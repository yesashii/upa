<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=Encuestas.doc"
Response.ContentType = "application/vnd.ms-word"
Server.ScriptTimeOut = 650000
'----------------------------------------------------------------------------------
carr_ccod = Request.QueryString("carr_ccod")
sede_ccod = Request.QueryString("sede_ccod")
jorn_ccod = Request.QueryString("jorn_ccod")


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Evaluación docente"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

nombre_carrera = conexion.consultaUno("Select carr_tdesc from carreras where cast(carr_ccod as varchar)='"&carr_ccod&"'")
nombre_sede = conexion.consultaUno("Select protic.initCap(sede_tdesc) from sedes where cast(sede_ccod as varchar)='"&sede_ccod&"'")
nombre_jornada = conexion.consultaUno("Select protic.initCap(jorn_tdesc) from jornadas where cast(jorn_ccod as varchar)='"&jorn_ccod&"'")

encu_ncorr = 1

set escala= new cformulario
escala.carga_parametros "tabla_vacia.xml","tabla"
escala.inicializar conexion
Query_escala = "select  resp_ncorr,resp_tabrev,protic.initcap(resp_tdesc) as resp_tdesc,resp_nnota from respuestas where cast(encu_ncorr as varchar)='"&encu_ncorr&"' order by resp_norden"
escala.consultar Query_escala
cantid = escala.nroFilas

set criterios= new cformulario
criterios.carga_parametros "tabla_vacia.xml","tabla"
criterios.inicializar conexion
Query_criterios = "select  crit_ncorr,crit_tdesc from criterios where cast(encu_ncorr as varchar)='"&encu_ncorr&"' order by crit_norden"
criterios.consultar Query_criterios
cantid_criterios = criterios.nroFilas

set secciones= new cformulario
secciones.carga_parametros "tabla_vacia.xml","tabla"
secciones.inicializar conexion
Query_secciones = " select distinct a.secc_ccod,c.pers_ncorr,e.asig_tdesc " & vbCrLf &_
				  " from secciones a, bloques_horarios b, bloques_profesores c, periodos_Academicos d,asignaturas e " & vbCrLf &_
				  " where a.secc_ccod=b.secc_ccod " & vbCrLf &_
				  " and b.bloq_ccod=c.bloq_ccod " & vbCrLf &_
			      " and a.peri_ccod=d.peri_ccod and c.tpro_ccod = 1 " & vbCrLf &_
				  " and a.asig_ccod=e.asig_ccod " & vbCrLf &_
				  " and cast(d.anos_ccod as varchar)='2005' " & vbCrLf &_
				  " and cast(a.sede_ccod as varchar)='"&sede_ccod&"' " & vbCrLf &_
				  " and cast(a.carr_ccod as varchar)='"&carr_ccod&"' " & vbCrLf &_
				  " and cast(a.jorn_ccod as varchar)='"&jorn_ccod&"' " & vbCrLf &_
				  " and exists (select 1 from resultados_encuestas aa where aa.secc_ccod=a.secc_ccod and aa.pers_ncorr_destino = c.pers_ncorr) " & vbCrLf &_
				  " order by e.asig_tdesc"


secciones.consultar Query_secciones
cantid_secciones = secciones.nroFilas



%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<script language="JavaScript">
</script>

</head>
<body>
<br>
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="800">
  <tr height="300">
    <td><div align="center"><font face="Times New Roman, Times, serif" size="+4"><strong>&nbsp;</strong></font></div></td>
  </tr>
  <tr height="100">
    <td><div align="center"><font face="Times New Roman, Times, serif" size="+4"><strong>Evaluación Docente</strong></font><br><font face="Times New Roman, Times, serif" size="+2"><strong><%=Nombre_carrera%></strong></font></div></td>
  </tr>
  <tr height="300">
    <td><div align="center"><font face="Times New Roman, Times, serif" size="+4"><strong>&nbsp;</strong></font></div></td>
  </tr>
  <tr height="50">
    <td><div align="right"><font face="Times New Roman, Times, serif" size="4"><strong><%=nombre_sede%></strong></font></div></td>
  </tr>
  <tr height="50">
    <td><div align="right"><font face="Times New Roman, Times, serif" size="4"><strong><%=nombre_jornada%></strong></font></div></td>
  </tr>
 </table>
 
 <%if cantid_secciones > "0" then
   while secciones.siguiente %>
  <table width="100%" border="1" cellpadding="0" cellspacing="0" height="830">
  <tr height="830">
 	<td  width="100%" align="center">
	<table width="100%"  border="0" align="center">
						<tr>
							<td colspan="3">
							<table width="100%" border="0">
								 <%
								 total1=0
								 total2=0
								 total3=0
								 total4=0
								 total5=0
								 secc_ccod = secciones.obtenerValor("secc_ccod")
								 pers_ncorr = secciones.obtenerValor("pers_ncorr")
								 pers_ncorr_profesor = pers_ncorr
								 
								 '------------------buscamos que datos vamos mostrar en el encabezado de la encuesta
								 carrera=conexion.consultaUno("select protic.initCap(carr_tdesc) from secciones a, carreras b where a.carr_ccod=b.carr_ccod and cast(a.secc_ccod as varchar)='"&secc_ccod&"'")
								 asignatura=conexion.consultaUno("select ltrim(rtrim(b.asig_ccod))+' ' + protic.initCap(b.asig_tdesc) from secciones a, asignaturas b where a.asig_ccod=b.asig_ccod and cast(a.secc_ccod as varchar)='"&secc_ccod&"'") 
								 seccion=conexion.consultaUno("select secc_tdesc from secciones a where cast(a.secc_ccod as varchar)='"&secc_ccod&"'")
								 carr_ccod=conexion.consultaUno("select carr_ccod from secciones a where cast(a.secc_ccod as varchar)='"&secc_ccod&"'")
								 profesor = conexion.consultaUno("select protic.initCap(pers_tnombre + ' ' + pers_tape_paterno + ' ' +pers_tape_materno) from personas where cast(pers_ncorr as varchar)='"&pers_ncorr_profesor&"'")
								
								 if secc_ccod <> "" then
									cantidad_encuestas = conexion.consultaUno("select count(distinct pers_ncorr_encuestado) from resultados_encuestas where cast(pers_ncorr_destino as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"'")
									contestada = conexion.consultaUno("Select Count(*) from resultados_encuestas where cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"'")
								 else
									cantidad_encuestas = conexion.consultaUno("select count(*) from (select distinct pers_ncorr_encuestado,secc_ccod from resultados_encuestas where cast(pers_ncorr_destino as varchar)='"&pers_ncorr&"')a")
									contestada = conexion.consultaUno("Select Count(*) from resultados_encuestas where cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"'")
								 end if 

								  if secc_ccod <> "" then%>
								  <tr> 
									<td width="18%" align="left"><strong><font size="-1">Escuela</font></strong> </td>
									<td width="1%"><strong><font size="-1">:</font></strong></td>
									<td width="38%" align="left"><font size="-1" color="#CC0000"><%=carrera%></font></td>
									<td width="14%" align="right"><strong><font size="-1">Secci&oacute;n</font></strong></td>
									<td width="2%"><strong><font size="-1">:</font></strong></td>
									<td colspan="3" align="left"><font  size="-1" color="#CC0000"><%=seccion%></font></td>
								  </tr>
  								  <tr> 
									<td width="18%" align="left"><strong><font size="-1">Asignatura</font></strong></td>
									<td width="1%"><strong><font size="-1">:</font></strong></td>
									<td colspan="6" align="left"><font size="-1" color="#CC0000"><%=asignatura%></font></td>
									
								  </tr>
								  <%end if%>
								   <tr> 
									<td width="18%" align="left"><strong><font size="-1">Profesor</font></strong> </td>
									<td width="1%"><strong><font size="-1">:</font></strong></td>
									<td width="38%" align="left"><strong><font size="-1" color="#CC0000"><%=profesor%></font></strong></td>
								    <td width="14%" align="right"><strong><font size="-1">Alumnos</font></strong></td>
									<td width="2%"><strong><font size="-1">:</font></strong></td>
									<td colspan="3" align="left"><font size="-1" color="#CC0000"><%=cantidad_encuestas%></font></td>
								  </tr>
						    </table>
							</td>
						</tr>

						<%escala.primero
						  escala.siguiente 
						  cantid = escala.nroFilas
						  if cantid > "0" then
						  		abrev = escala.obtenervalor("resp_tabrev")
								texto= escala.obtenervalor("resp_tdesc")
  					    %> 
						<tr> 
						   <td colspan="3" >
						       <table width="100%">
							       <tr>
								       <td width="3%"><div align="left"><strong><font size="-1"><%=abrev%></font></strong></div></td>
							           <td width="1%"><strong><center><font size="-1">:</font></center></strong></td>
							           <td width="46%"><div align="left"><font size="-1"><%=texto%></font></div></td>
									   <%escala.siguiente
								         abrev = escala.obtenervalor("resp_tabrev")
								         texto= escala.obtenervalor("resp_tdesc") %>
									   <td width="3%"><div align="left"><strong><font size="-1"><%=abrev%></font></strong></div></td>
							           <td width="1%"><strong><center><font size="-1">:</font></center></strong></td>
							           <td width="46%"><div align="left"><font size="-1"><%=texto%></font></div></td>
								   </tr>
								   <%escala.siguiente
								         abrev = escala.obtenervalor("resp_tabrev")
								         texto= escala.obtenervalor("resp_tdesc") %>
								   <tr>
								       <td width="3%"><div align="left"><strong><font size="-1"><%=abrev%></font></strong></div></td>
							           <td width="1%"><strong><center><font size="-1">:</font></center></strong></td>
							           <td width="46%"><div align="left"><font size="-1"><%=texto%></font></div></td>
									   <%escala.siguiente
								         abrev = escala.obtenervalor("resp_tabrev")
								         texto= escala.obtenervalor("resp_tdesc") %>
									   <td width="3%"><div align="left"><strong><font size="-1"><%=abrev%></font></strong></div></td>
							           <td width="1%"><strong><center><font size="-1">:</font></center></strong></td>
							           <td width="46%"><div align="left"><font size="-1"><%=texto%></font></div></td>
								   </tr>
								    <%escala.siguiente
								         abrev = escala.obtenervalor("resp_tabrev")
								         texto= escala.obtenervalor("resp_tdesc") %>
								   <tr>
								       <td width="3%"><div align="left"><strong><font size="-1"><%=abrev%></font></strong></div></td>
							           <td width="1%"><strong><center><font size="-1">:</font></center></strong></td>
							           <td width="46%" colspan="4"><div align="left"><font size="-1"><%=texto%></font></div></td>
								   </tr>
								    <%escala.primero%>
							   </table>
						  </td>
						</tr>
						<%
						'wend
						end if
						%>
						
                      </table>
                      <table width="100%"  border="0" align="center">
                       <%
					    criterios.primero 
						cantid_criterios = criterios.nroFilas
					    if cantid_criterios >"0" then
					        contador=1
							acumulado_total = 0
						  	while criterios.siguiente
									ncorr = criterios.obtenervalor("crit_ncorr")
									'response.Write("ncorr= "&ncorr&" ")
									titulo= criterios.obtenervalor("crit_tdesc")						
							%>  
							<tr> 
                          		<td colspan="3"><font  size="-1" color="#CC0000"><strong>&nbsp;</strong></font></td>

						  		<%if cantid >"0" then
						  			escala.Primero
						  			while escala.siguiente
										abrev = escala.obtenervalor("resp_tabrev")%>
										<td width="20"><strong><center><font size="-1" color="#CC0000">
						  				<%response.Write(abrev)		
										%></font></center></strong>
										</td>
										<td width="20"><strong><center><font size="-1" color="#CC0000">
						  				<%response.Write("%")		
										%></font></center></strong>
										</td>
									<%wend%>
							    <%end if%>
							<td width="2"><font size="-1">&nbsp;</font></td>	
							</tr>
							<%
							set preguntas= new cformulario
							preguntas.carga_parametros "tabla_vacia.xml","tabla"
							preguntas.inicializar conexion
							Query_preguntas = "select  preg_ncorr,preg_ccod,protic.initCap(preg_tdesc) as preg_tdesc,preg_norden from preguntas where cast(crit_ncorr as varchar)='"&ncorr&"' order by preg_norden"
							preguntas.consultar Query_preguntas
							cantid_preguntas = preguntas.nroFilas
							'response.Write("ncorr= "&ncorr&" cantidad_preguntas "&cantid_preguntas)
								if cantid_preguntas >"0" then
						  			while preguntas.siguiente
									    'response.Write("sql= "&Query_preguntas)
										orden = preguntas.obtenervalor("preg_norden")
										pregunta= preguntas.obtenervalor("preg_tdesc")						
										ccod=preguntas.obtenervalor("preg_ccod")						
										preg_ncorr=preguntas.obtenervalor("preg_ncorr")						
										%>  
										<tr> 
                          				<td width="18" align="right"><strong><font size="-1"><%=contador%></font></strong></td>
										<td width="17"><font size="-1"><%=".-"%></font></td>
										<td width="591"><font size="-1"><%=pregunta%></font></td>
						  
						  				<%if cantid >"0" then
						  					escala.Primero
											acumulado = 0
											
						  					while escala.siguiente%>
											 <td width="20"><font size="-1"><center>
											   <%if contestada <> 0 then
														if secc_ccod <> "" then 
															respuesta = conexion.consultaUno("Select count(distinct pers_ncorr_encuestado) from resultados_encuestas where cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"' and preg_ncorr='"&preg_ncorr&"' and cast(resp_ncorr as varchar)='"&escala.obtenervalor("resp_ncorr")&"'")  
														else
															respuesta = conexion.consultaUno("Select count(distinct pers_ncorr_encuestado) from resultados_encuestas where cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"' and preg_ncorr='"&preg_ncorr&"' and cast(resp_ncorr as varchar)='"&escala.obtenervalor("resp_ncorr")&"'")  
														end if%>
														
														<%if respuesta > "0" then 
														  	response.Write("<strong>"&respuesta&"</strong>")
															puntaje = escala.obtenervalor("resp_ncorr")
															acumulado = acumulado + (cint(puntaje) * cint(respuesta))
														  else
														  	response.Write(respuesta)
														  end if%>
														
												  <%end if
												   abrev = escala.obtenervalor("resp_tabrev")
												   if abrev = "1" then
												    total1 = total1 + cint(respuesta)
												   elseif abrev = "2" then
												    total2 = total2 + cint(respuesta)
												   elseif abrev = "3" then
												    total3 = total3 + cint(respuesta)
												   elseif abrev = "4" then
												    total4 = total4 + cint(respuesta)
												   elseif abrev = "5" then
												    total5 = total5 + cint(respuesta)
												   end if
												   %>
											   </center></font></td>
											   <td width="20"><strong><center><font size="-1" color="#CC0000">
													<% acumulado = cint((cint(respuesta) * 100) / cint(cantidad_encuestas))
													   if acumulado > 0 and acumulado < 100 then 
													   		response.Write(acumulado)
													   elseif acumulado = 0 then
													   		response.Write(0)
													   elseif acumulado = 100 then
													   		response.Write(100)	
													   end if		
													%></font></center></strong>
												</td>
											<%wend%>
									    <%end if%>
										<td width="2"><font size="-1">&nbsp;</font></td>	
										</tr>
									<%contador=contador+1 
									  acumulado_total = acumulado_total + acumulado
									wend
								end if
								Query_preguntas=""%>
								

							<%wend 
							end if
							%>
							<tr> 
							   <td colspan="3" align="right"><strong><font size="-2">Totales</font></strong></td>
							   <td align="center"><strong><font size="-1"><%=total1%></font></strong></td>
							   <td align="center"><strong><font size="-1">&nbsp;</font></strong></td>
							   <td align="center"><strong><font size="-1"><%=total2%></font></strong></td>
							   <td align="center"><strong><font size="-1">&nbsp;</font></strong></td>
							   <td align="center"><strong><font size="-1"><%=total3%></font></strong></td>
							   <td align="center"><strong><font size="-1">&nbsp;</font></strong></td>
							   <td align="center"><strong><font size="-1"><%=total4%></font></strong></td>
							   <td align="center"><strong><font size="-1">&nbsp;</font></strong></td>
							   <td align="center"><strong><font size="-1"><%=total5%></font></strong></td>
							   <td align="center"><strong><font size="-1">&nbsp;</font></strong></td>
							</tr>
	   </table>
	   
	</td>
 </tr>
 </table>
 <%wend
 end if%>
</body>
</html>
