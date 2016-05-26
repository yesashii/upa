<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file="../biblioteca/_negocio.asp" -->
<%

set conectar = new cconexion


set formulario = new cformulario
set negocio = new cNegocio

'for each k in request.form
	'response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
conectar.inicializar "upacifico"
negocio.inicializa conectar

formulario.carga_parametros "planificar_programa.xml", "edicion_bloque"
formulario.inicializar conectar
horas = request.form("horas")
'response.Write("<br>horas"&horas)
if not isNumeric(horas) or horas = "" then
	horas = 1
end if

bhot = request.form("pl[0][bhot_ccod]")
seot_ncorr = request.form("seot_ncorr")
dgso_ncorr = request.form("dgso_ncorr")
'response.Write("<br>bloque "&bloq)
if bhot = "" then
	bhot = "NULL"
end if


sede_ccod = request.form("sede_ccod")
'response.Write("<br>sede "&sede_ccod)

seot_ncorr = request.form("seot_ncorr")
'response.Write("<br>seccion "&seot_ncorr)

dia  = request.form("pl[0][dias_ccod]")
'response.Write("<br>dia "&dia)

hora_ccod = cint(request.form("pl[0][hora_ccod]"))
'response.Write("<br>hora "&hora_ccod)

finix = request.form("pl[0][bhot_finicio]")
'response.Write("<br>finix "&finix)
fterx = request.form("pl[0][bhot_ftermino]")
'response.Write("<br>fterx "&fterx)

fini = negocio.cambiaFecha(finix)
'response.Write("<br>fini "&fini)
fter = negocio.cambiaFecha(fterx)
'response.Write("<br>fter "&fter)
sala = request.form("pl[0][sala_ccod]")
'response.Write("<br>sala "&sala)

consulta = "select DATEDIFF(day,seot_finicio," & fini & ") from secciones_otec where cast(seot_ncorr as varchar)='" & seot_ncorr &"'"

finis = conectar.consultaUno(consulta)
'response.Write("<br>finis "&finis)

consulta = "select DATEDIFF(day,seot_ftermino," & fter & ") from secciones_otec where cast(seot_ncorr as varchar)='" & seot_ncorr &"'"
fters = conectar.consultaUno(consulta)
'response.Write("<br>fters "&fters)

consulta = "select isnull(maot_nhoras_programa,0) from secciones_otec a, mallas_otec b where cast(seot_ncorr as varchar) = '"& seot_ncorr &"' and a.maot_ncorr=b.maot_ncorr "
horas_asig = cint(conectar.consultaUno(consulta))
'response.Write("<br>horas_asig "&horas_asig)

consulta = "select isnull(sum(protic.dias_habiles(dias_ccod,bhot_finicio,bhot_ftermino)),0) as a from bloques_horarios_otec where cast(seot_ncorr as varchar) = '" & seot_ncorr &"'"
'response.Write(consulta&"<br>")
horas_secc = cint(conectar.consultaUno(consulta))
'response.Write("<br>horas_secc "&horas_secc)

consulta = "select protic.dias_habiles( " & dia & ", " & fini & ", " & fter & " )"
'response.Write("<br>"&consulta)
dias_habiles = cint(conectar.consultaUno(consulta))

'response.Write("<br>dias_habiles "&dias_habiles)

sala_top2=0
paso_hora = hora_ccod
sala_cons = " select cast(protic.topones_sala_2(" & sala & ", " & fini & ", " & fter & ","&dia&","&paso_hora&")as numeric) as t" 
sala_top = cint(conectar.consultaUno(sala_cons))
'response.Write("<br>topones sala "&sala_top)
'response.End()
		'response.Write("<br>topones_subseccines "&secc_top)
		sala_top2 = sala_top2 + sala_top
		if pers <> "" then
			'prof_cons = " select protic.topones_docente(" & bloq & ", " & pers & ") as t" 
			prof_top = 0'cInt(conectar.consultaUno(prof_cons))
			'response.Write("<br>topones_profe "&prof_top)
		else
			prof_top = 0
		end if


	mensajeError = ""
	if cint(sala_top) > 0 or cint(sala_top2) > 0 then
		mensajeError = mensajeError & "No se puede asignar sala por coincidencia de horario\n" 
	end if
	if cint(prof_top) > 0 then
		mensajeError = mensajeError & "No se puede asignar profesor por coincidencia de horario\n" 
	end if
'response.Write("dias_habiles "&dias_habiles&"  +  horas_secc "&horas_secc&" > horas_asig "&horas_asig)
'response.End() 

if bhot="NULL" and (dias_habiles + horas_secc > horas_asig) then
	mensajeError = "Se sobrepasa total de horas del módulo"
end if

'response.Write("<br>--"&mensajeError)


'if cint(finis) > 0 or cint(fters) < 0 then
'	mensajeError = "Las fechas de inicio y término están fuera del rango del módulo"
'end if

if mensajeError <> "" then
    'response.Write("entre acá")
	'response.End()
	session("mensajeError") = mensajeError
	response.Redirect request.ServerVariables("HTTP_REFERER")

else

	formulario.procesaForm	
  ' response.Write("revisando....horas.... "&horas)
	if UCase(bhot) = "NULL" then
		'response.Write("Entre")    
			v_bhot_ccod = conectar.ConsultaUno("execute obtenersecuencia 'bloques_horarios_otec'")
			'response.Write("revisando.... "&v_bloq_ccod)
			formulario.AgregaCampoPost "bhot_ccod", v_bhot_ccod
			v_bloque = v_bhot_ccod
	end if
	'response.Write("<br>bhot_ccod "&v_bloque)

	formulario.AgregaCampoPost "seot_ncorr", seot_ncorr
	formulario.AgregaCampoPost "sede_ccod", sede_ccod
	formulario.mantienetablas false	
end if
	
'response.End()	
Response.Redirect("planificar_horario.asp?seot_ncorr="&seot_ncorr&"&dgso_ncorr="& dgso_ncorr)


%>
