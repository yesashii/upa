<!-- #include file="../biblioteca/_conexion.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.form(k)&"<br>")
'next
'response.End()
secc_ccod		=	request.form("secc_ccod")	
adia_ncorr	=	request.form("adia_ncorr")	
actividades_desarrolladas = request.Form("actividades_desarrolladas")

set conexion = new CConexion
conexion.Inicializar "upacifico"

c_update = " update asistencia_diaria set actividades_desarrolladas='"&actividades_desarrolladas&"' where cast(adia_ncorr as varchar)='"&adia_ncorr&"'"
conexion.ejecutaS (c_update)

'Borramos todos los registros de asistencia ingresados antes del grabado por si hay modificaciones
c_delete = " delete from detalle_asistencia_diaria where cast(adia_ncorr as varchar)='"&adia_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"'"
conexion.ejecutaS (c_delete)


set formulario = new CFormulario
formulario.Carga_Parametros "tabla_vacia.xml", "tabla"
formulario.Inicializar conexion 

consulta = "  select distinct c.pers_ncorr " &vbcrlf &_
		   "  from cargas_academicas a, alumnos b, personas c " &vbcrlf &_
		   "  where a.matr_ncorr=b.matr_ncorr and b.pers_ncorr=c.pers_ncorr " &vbcrlf &_
		   "  and cast(secc_ccod as varchar)='"&secc_ccod&"' " 
		   
formulario.Consultar consulta

set formulario_bloques = new CFormulario
formulario_bloques.Carga_Parametros "tabla_vacia.xml", "tabla"
formulario_bloques.Inicializar conexion 

consulta2 = "  select hora_ccod , bloq_ccod " &vbcrlf &_
		   "  from bloques_horarios " &vbcrlf &_
		   "  where cast(secc_ccod as varchar)='"&secc_ccod&"' " &vbcrlf &_
   		   "  and dias_ccod  =  datePart(weekday,getDate())" &vbcrlf &_
		   "  order by hora_ccod asc "

formulario_bloques.Consultar consulta2

while formulario.siguiente
	pers_ncorr = formulario.obtenerValor("pers_ncorr")
	valor_general = request.Form("asistencia_"&pers_ncorr&"")
	while formulario_bloques.siguiente
	  bloque = formulario_bloques.obtenerValor("bloq_ccod")
	  if valor_general <> "1" then 
		  valor = request.Form("asiste_"&pers_ncorr&"_"&bloque&"")
		  if valor <> "1" then
			valor = "0"
		  end if
	  else
	  		valor = valor_general
	  end if
	  
	  c_insert_detalle = "insert into detalle_asistencia_diaria (adia_ncorr,secc_ccod,bloq_ccod,pers_ncorr,asiste)"&_
	                     " values ("&adia_ncorr&","&secc_ccod&","&bloque&","&pers_ncorr&","&valor&")"	
	  conexion.ejecutaS (c_insert_detalle)
	wend
	formulario_bloques.primero
wend
'response.End()
 session("mensajeError") = "Asistencia grabada exitosamente"
 response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>