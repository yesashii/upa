<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file="../biblioteca/_negocio.asp" -->
<%

set conectar = new cconexion


set formulario = new cformulario
set negocio = new cNegocio

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
conectar.inicializar "upacifico"
negocio.inicializa conectar

formulario.carga_parametros "paulo.xml", "edicion_bloque"
formulario.inicializar conectar
horas = request.form("horas")
'response.Write("<br>horas"&horas)
if not isNumeric(horas) or horas = "" then
	horas = 1
end if

bloq = request.form("pl[0][bloq_ccod]")
'response.Write("<br>bloque"&bloq)
if bloq = "" then
	bloq = "NULL"
end if


sede = request.form("pl[0][sede_ccod]")
'response.Write("<br>sede "&sede)
ssec = request.form("pl[0][SSEC_NCORR]")
'response.Write("<br>seccion "&ssec)
dia  = request.form("pl[0][dias_ccod]")
'response.Write("<br>dia "&dia)
hora = cint(request.form("pl[0][hora_ccod]"))
'response.Write("<br>hora "&hora)
finix = request.form("pl[0][bloq_finicio_modulo]")
'response.Write("<br>finix "&finix)
fterx = request.form("pl[0][bloq_ftermino_modulo]")
'response.Write("<br>fterx "&fterx)
fini = negocio.cambiaFecha(finix)
'response.Write("<br>fini "&fini)
fter = negocio.cambiaFecha(fterx)
'response.Write("<br>fter "&fter)
sala = request.form("pl[0][sala_ccod]")
'response.Write("<br>sala "&sala)
pers = request.form("pl[0][pers_ncorr]") 
'response.Write("persona "&pers)
'response.End()
consulta = "select DATEDIFF(day,ssec_finicio_sec," & fini & ") from sub_secciones where ssec_ncorr=" & ssec

finis = conectar.consultaUno(consulta)
'response.Write("<br>finis "&finis)
consulta = "select DATEDIFF(day,ssec_ftermino_sec," & fter & ") from sub_secciones where ssec_ncorr=" & ssec
fters = conectar.consultaUno(consulta)
'response.Write("<br>fters "&fters)

consulta = "select isnull(asig_nhoras,0) from asignaturas a, secciones b, sub_secciones c where a.asig_ccod=b.asig_ccod and b.secc_ccod=c.secc_ccod and c.ssec_ncorr = " & ssec
horas_asig = cint(conectar.consultaUno(consulta))
'response.Write("<br>horas_asig "&horas_asig)
consulta = "select isnull(sum(protic.dias_habiles(dias_ccod,bloq_finicio_modulo,bloq_ftermino_modulo)),0) as a from bloques_horarios where ssec_ncorr = " & ssec
'response.Write(consulta&"<br>")
horas_secc = cint(conectar.consultaUno(consulta))
'response.Write("<br>horas_secc "&horas_secc)
consulta = "select protic.dias_habiles( " & dia & ", " & fini & ", " & fter & " )"
'response.Write("<br>"&consulta)
dias_habiles = cint(conectar.consultaUno(consulta))
'response.Write("<br>dias_habiles "&dias_habiles)
sala_top2=0
if hora + horas <= 22 then
	for i = 0 to horas - 1
	
		if i=0 then 
			paso_hora = hora
		else
			paso_hora = hora+i
		end if	
		sala_cons = " select cast(protic.topones_sala(" & sala & ", " & fini & ", " & fter & ","&dia&","&paso_hora&")as numeric) as t" 
		secc_cons = " select cast(protic.topones_subseccion(" & bloq & ", " & ssec & ", " & dia & ", " & hora + i & ", " & fini & ", " & fter & ") as numeric) as t" 
		sala_top = cint(conectar.consultaUno(sala_cons))
		'response.Write("<br>topones sala "&sala_top)
		secc_top = cint(conectar.consultaUno(secc_cons))
		'response.Write("<br>topones_subseccines "&secc_top)
		sala_top2 = sala_top2 +sala_top
		if pers <> "" then
			prof_cons = " select protic.topones_docente(" & bloq & ", " & pers & ") as t" 
			prof_top = cInt(conectar.consultaUno(prof_cons))
			'response.Write("<br>topones_profe "&prof_top)
		else
			prof_top = 0
		end if
		
		if sala_top > 0 or secc_top > 0 or prof_top > 0 then
			exit for
		end if
	next

	mensajeError = ""
	if cint(sala_top) > 0 or cint(sala_top2)>0 then
		mensajeError = mensajeError & "No se puede asignar sala por coincidencia de horario\n" 
	end if
	if cint(prof_top) > 0 then
		mensajeError = mensajeError & "No se puede asignar profesor por coincidencia de horario\n" 
	end if
	if cint(secc_top) > 0 then
		mensajeError = mensajeError & "No se puede asignar horario porque la sección ya lo está usando\n" 
	end if
else
	mensajeError = "Sólo están disponibles 19 bloques horarios"
end if
'response.Write("horas "&horas&" * dias_habiles "&dias_habiles&" + horas_secc "&horas_secc&" > horas_asig "&horas_asig)
'response.End()
if ucase(bloq) = "NULL" and horas*dias_habiles + horas_secc > horas_asig then
	mensajeError = "Se sobrepasa total de horas de la asignatura"
end if

if cint(finis) > 0 or cint(fters) < 0 then
	mensajeError = "Las fechas de inicio y término están fuera del rango de la sección"
end if

if mensajeError <> "" then
    'response.Write("entre acá")
	'response.End()
	session("mensajeError") = mensajeError
	response.Redirect request.ServerVariables("HTTP_REFERER")

else

	formulario.procesaForm	
  ' response.Write("revisando....horas.... "&horas)
	if horas > 1 then
		
		for i = 1 to horas-1
			formulario.clonaFilaPost(0)
			formulario.agregaCampoFilaPost i, "hora_ccod", hora + i
	
			bloq = formulario.ObtenerValorPost(i, "bloq_ccod")
			
			'response.Write("revisando "&bloq)
			'response.End()
			if UCase(bloq) = "NULL" or EsVacio(bloq) then
                 
				v_bloq_ccod = conectar.ConsultaUno("execute obtenersecuencia 'bloq_ccod_seq'")
				formulario.AgregaCampoFilaPost i, "bloq_ccod", v_bloq_ccod
 				'response.Write("<br>v_bloq_ccod "&v_bloq_ccod)

				if EsVacio(v_bloque) then
					v_bloque = v_bloq_ccod
				end if
			end if	
				 
	
		next
	else
		if UCase(bloq) = "NULL" then
		    
			v_bloq_ccod = conectar.ConsultaUno("execute obtenersecuencia 'bloq_ccod_seq'")
			'response.Write("revisando.... "&v_bloq_ccod)
			formulario.AgregaCampoPost "bloq_ccod", v_bloq_ccod
			v_bloque = v_bloq_ccod
		end if
			
	end if
	formulario.mantienetablas false	
	'response.End()
			v_secc_ccod = conectar.consultauno("select secc_ccod from bloques_horarios where cast(ssec_ncorr as varchar) ='"&ssec&"'")
			
			sql_pers_ncorr =" select b.pers_ncorr from bloques_horarios a, bloques_profesores b " & _
							" where a.bloq_ccod = b.bloq_ccod" & _
							" and  cast(secc_ccod as varchar)= '"&v_secc_ccod&"' " & _
							" and  b.tpro_ccod =1 "
							
			v_pers_ncorr = conectar.consultauno(sql_pers_ncorr)
			v_pers_ncorr=""	
    		if v_pers_ncorr<>"" then
			'response.Write("pers_ncorr= "&v_pers_ncorr)
						set f_tabla  = new CFormulario
						f_tabla.Carga_Parametros "paulo.xml","tabla"
						f_tabla.Inicializar conectar
						
					
						sql_bloq_sin_profesor = "select bloq_ccod from bloques_horarios " & _
												" where cast(secc_ccod as varchar)= '"&v_secc_ccod&"'" & _
												" and bloq_ccod not in (select a.bloq_ccod from " & _
																		" bloques_horarios a, bloques_profesores b " & _ 
																		" where a.bloq_ccod = b.bloq_ccod " & _ 
																		" and cast(a.secc_ccod as varchar)='"&v_secc_ccod &"')" 
																	
					f_tabla.consultar sql_bloq_sin_profesor													 											
				   'response.Write("<br>sql_bloq_sin_profesor "&sql_bloq_sin_profesor)
					filas = f_tabla.nrofilas
					'response.Write("filas " &filas)	
					for i=0 to filas-1
						f_tabla.siguiente
						i_bloq_ccod =f_tabla.obtenervalor("bloq_ccod")
						consulta_22="select count(*) " & vbCrLf &_
									"      from sub_secciones a, bloques_horarios b, bloques_profesores c " & vbCrLf &_
									"      where a.ssec_ncorr = b.ssec_ncorr " & vbCrLf &_
									"        and b.bloq_ccod = c.bloq_ccod " & vbCrLf &_
									"        and cast(a.ssec_ncorr as varchar)= '" & ssec & "' " 
				
 						cantidad_rownum=conectar.consultaUNO (consulta_22)
						sentencia =  "insert into bloques_profesores(bloq_ccod, pers_ncorr, sede_ccod, tpro_ccod, tpag_ccod, bpro_mvalor, audi_tusuario, audi_fmodificacion) " & vbCrLf &_
						             "select '" & i_bloq_ccod & "', a.pers_ncorr, a.sede_ccod, case "&cantidad_rownum&" when 1 then a.tpro_ccod else 2 end as tpro_ccod, a.tpag_ccod, a.bpro_mvalor, '" & negocio.ObtenerUsuario & "', getDate() " & vbCrLf &_
				     	             "from (select c.pers_ncorr, min(c.sede_ccod) as sede_ccod, min(c.tpro_ccod) as tpro_ccod, min(c.tpag_ccod) as tpag_ccod, max(c.bpro_mvalor) as bpro_mvalor " & vbCrLf &_
									 "      from sub_secciones a, bloques_horarios b, bloques_profesores c " & vbCrLf &_
									 "      where a.ssec_ncorr = b.ssec_ncorr " & vbCrLf &_
									 "        and b.bloq_ccod = c.bloq_ccod " & vbCrLf &_
									 "        and cast(a.ssec_ncorr as varchar) = '" & ssec & "' " & vbCrLf &_
				 					 "      group by c.pers_ncorr " & vbCrLf &_
					                 " ) a"
						
						'response.Write("<pre>"&sentencia&"</pre>")
						'"insert INTO bloques_profesores " & _
									'			"(BLOQ_CCOD, PERS_NCORR, SEDE_CCOD, TPRO_CCOD, TPAG_CCOD, BPRO_MVALOR, AUDI_TUSUARIO, AUDI_FMODIFICACION)" & _
									'			"values('"&i_bloq_ccod&"','"&v_pers_ncorr&"','"&sede&"','"&request.Form("profesor[0][tpro_ccod]")&"','"&request.Form("profesor[0][tpag_ccod]")&"'," & _
									'			" '"&request.Form("profesor[0][bpro_mvalor]")&"','"&negocio.obtenerusuario&"',sysdate)"
						'response.Write("<br><pre>"&sentencia&"</pre>")
						'response.End()				
						conectar.EstadoTransaccion conectar.EjecutaS(sentencia)		
					next					
	end if
	'response.End()		
	if UCase(bloq) = "NULL" then
		'sentencia = "insert into bloques_profesores(bloq_ccod, pers_ncorr, sede_ccod, tpro_ccod, tpag_ccod, audi_tusuario, audi_fmodificacion) " & vbCrLf &_
		'            "select '" & v_bloq_ccod & "', c.pers_ncorr, min(c.sede_ccod) as sede_ccod, max(c.tpro_ccod) as tpro_ccod, min(c.tpag_ccod) as tpag_ccod, '" & negocio.ObtenerUsuario & "', sysdate " & vbCrLf &_
		'			"from sub_secciones a, bloques_horarios b, bloques_profesores c " & vbCrLf &_
		'			"where a.ssec_ncorr = b.ssec_ncorr " & vbCrLf &_
		'			"  and b.bloq_ccod = c.bloq_ccod " & vbCrLf &_
		'			"  and a.ssec_ncorr = '" & ssec & "' " & vbCrLf &_
		'			"group by c.pers_ncorr"
		consulta_22="select count(*) " & vbCrLf &_
					"      from sub_secciones a, bloques_horarios b, bloques_profesores c " & vbCrLf &_
					"      where a.ssec_ncorr = b.ssec_ncorr " & vbCrLf &_
					"        and b.bloq_ccod = c.bloq_ccod " & vbCrLf &_
					"        and a.ssec_ncorr = '" & ssec & "' " 
				
		cantidad_rownum=conectar.consultaUNO (consulta_22)
		
		sentencia = "insert into bloques_profesores(bloq_ccod, pers_ncorr, sede_ccod, tpro_ccod, tpag_ccod, bpro_mvalor, audi_tusuario, audi_fmodificacion) " & vbCrLf &_
		            "select '" & v_bloq_ccod & "', a.pers_ncorr, a.sede_ccod, case "&cantidad_rownum&" when 1 then a.tpro_ccod else 2 end as tpro_ccod, a.tpag_ccod, a.bpro_mvalor, '" & negocio.ObtenerUsuario & "', getDate() " & vbCrLf &_
		            "from (select c.pers_ncorr, min(c.sede_ccod) as sede_ccod, min(c.tpro_ccod) as tpro_ccod, min(c.tpag_ccod) as tpag_ccod, max(c.bpro_mvalor) as bpro_mvalor " & vbCrLf &_
					"      from sub_secciones a, bloques_horarios b, bloques_profesores c " & vbCrLf &_
					"      where a.ssec_ncorr = b.ssec_ncorr " & vbCrLf &_
					"        and b.bloq_ccod = c.bloq_ccod " & vbCrLf &_
					"        and cast(a.ssec_ncorr as varchar)= '" & ssec & "' " & vbCrLf &_
					"      group by c.pers_ncorr " & vbCrLf &_
					"    ) a"
		'response.Write("<pre>"&sentencia&"</pre>")
    end if	
	
	'conectar.EstadoTransaccion false
	'response.End()
'response.Write("revision hasta antes de redireccionar")	
'response.End()	
	if Request.QueryString("accion") = "A" then
			Response.Redirect("edicion_plan_acad.asp?accion=A&bloq_ccod=" & v_bloque)
	else
		if Session("ses_accion") = "A" then

				url = "edicion_plan_acad.asp?ssec_ncorr=" & ssec & "&sede_ccod=" & sede & "&accion=A"
				response.Redirect url
		else
		    response.write "<script language='JavaScript1.2'>"
			response.write "self.opener.location.reload();"
			response.write "self.close();"
			response.write "</script>"
		end if
	end if
end if

%>
