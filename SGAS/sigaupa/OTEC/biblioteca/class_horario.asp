<%
'*******************************************************************
'DESCRIPCION			        :
'FECHA CREACIÓN			      :
'CREADO POR				        :
'ENTRADA				          : NA
'SALIDA				            : NA
'MODULO QUE ES UTILIZADO	: SIN ACCESO DESDE EL SISTEMA
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION		: 15/03/2013
'ACTUALIZADO POR			  : Luis Herrera G.
'MOTIVO				          : Corregir código, eliminar sentencia *=
'LINEA				          : 168
'********************************************************************
class cHorario
	private conexion, sHorario, negocio, sede
	sub inicializa ( con ) 
		set conexion = con
		set sHorario = me.creaHorario
		set negocio = new CNegocio	
	end sub
	
	sub dibuja
		response.write "<table width='100%' border='1' bordercolor='#A0C0EB' bgcolor='#FBFBF7' cellspacing='0' cellpadding='0'>" & vbCrLf
		for each i in sHorario.Keys
			response.write "<tr>" & vbCrLf
			for each j in sHorario.Item(i).Keys
			'response.Write("USOS "&sHorario.Item(i).Item(j).Item("usos"))
				if cint(sHorario.Item(i).Item(j).Item("usos")) > 0 then
					color = " bgcolor='#DCDCB8' "
				else
					color = ""
				end if
				response.write "<td " & color & " align='center' bgcolor='#f4f4ea' class='horario'>" & vbCrLf
				response.write(sHorario.Item(i).Item(j).Item("valor")) & vbCrLf
				response.write "</td>" & vbCrLf
				response.Flush()
			next
			response.write "<tr>" & vbCrLf
		next
	end sub
	
	'---------------------------horario salas para el periodo--------------------------------
	
	sub cargaHorarioSalaPeriodo(codigo,fecha_inicio,fecha_termino)
		fini = negocio.cambiaFecha(fecha_inicio)
		fter = negocio.cambiaFecha(fecha_termino)
        peri = negocio.obtenerPeriodoAcademico("Planificacion")
		periodo_1 = conexion.consultaUno("select peri_ccod from periodos_academicos where plec_ccod = 1 and anos_ccod=(select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&peri&"')")
		'response.Write("PERIODO :"&peri&"</pre>")
		'response.Write("CODIGO SALA :"&codigo&"</pre>")
		'response.Write("FECHA INICIO :"&fini&"</pre>")
		'response.Write("FECHA TERMINO :"&fter&"</pre>")
		
'-----------------------------------------
		consulta = "select " & vbCrLf & _
			"		b.sala_ccod,sala_ciso,tsal_tdesc,dias_ccod,hora_ccod, " & _
			"   	protic.detalle_sala_periodo( " & _
			"      	b.sala_ccod,a.dias_ccod,a.hora_ccod,"&peri&") as detalle," & _
			"      	 count(distinct a.bloq_ccod) as usos " & vbCrLf & _
			"	  	from " & vbCrLf & _
			"			bloques_horarios a, salas b, tipos_sala c,secciones d, asignaturas e " & vbCrLf & _
			"	  	where " & vbCrLf & _
			"			a.sala_ccod =b.sala_ccod " & vbCrLf & _
			"			and b.tsal_ccod=c.tsal_ccod " & vbCrLf & _
			"			and cast(b.sala_ccod as varchar)='" & codigo & "'" & vbCrLf & _
			"			and hora_ccod is not null  " & vbCrLf & _
			"			and a.secc_ccod=d.secc_ccod and d.asig_ccod=e.asig_ccod and d.peri_ccod = case e.duas_ccod when 3 then '"&periodo_1&"' else '"&peri&"' end   " & vbCrLf & _
			"			and a.bloq_ftermino_modulo  " & vbCrLf & _
			"		between  " & vbCrLf & _
			"			" & fini & vbCrLf & _
			"		  and  " & vbCrLf & _
			"		    " & fter & vbCrLf & _
			"	  	group by  " & vbCrLf & _
			"			b.sala_ccod,sala_ciso,tsal_tdesc,dias_ccod,hora_ccod " & vbCrLf 

		'response.Write("<pre>"&consulta&"</pre>")
		'response.End()
		conexion.ejecuta consulta
		set r = conexion.obtenerRegistros
		
		for each x in r.Item("filas").Items
			dia = cint(x.Item("DIAS_CCOD"))
			hora = cint(x.Item("HORA_CCOD"))
			'response.Write("<br>dia "&dia&" hora "&hora)
			'response.Write("sHorario.Exists(hora) "&sHorario.Exists(hora-1) )
			if sHorario.Exists(hora) then
				if sHorario.Item(hora).Exists(dia) then
					sHorario.Item(hora).Item(dia).Item("usos") = cint(x.Item("USOS"))
					sHorario.Item(hora).Item(dia).Item("valor") = x.Item("DETALLE")
					'response.Write("<br>usos "&x.Item("USOS")&" detalle "&x.Item("DETALLE"))
				end if
			end if
		next
	end sub
	
	'-------------------------------fin periodo-----------------------------------------------
	
	sub cargaHorarioSala(codigo,fecha_inicio,fecha_termino)
		fini = negocio.cambiaFecha(fecha_inicio)
		fter = negocio.cambiaFecha(fecha_termino)
		peri = negocio.obtenerPeriodoAcademico("Planificacion")
		periodo_1 = conexion.consultaUno("select peri_ccod from periodos_academicos where plec_ccod = 1 and anos_ccod=(select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&peri&"')")
		'response.Write("PERI :"&periodo_1&"</pre>")
		'response.Write("FECHA INICIO :"&fin&"</pre>")
		'response.Write("FECHA TERMINO :"&fter&"</pre>")
		
		consulta = "select " & vbCrLf & _
		"		b.sala_ccod,sala_ciso,tsal_tdesc,dias_ccod,hora_ccod, " & _
		"   	protic.detalle_sala( " & _
		"      	b.sala_ccod,a.dias_ccod,a.hora_ccod, " & _
		"      	" & fini & "," & fter & ") as detalle, count(distinct a.bloq_ccod) as usos " & vbCrLf & _
		"	  	from " & vbCrLf & _
		"			bloques_horarios a, salas b, tipos_sala c,secciones d, asignaturas e " & vbCrLf & _
		"	  	where " & vbCrLf & _
		"			a.sala_ccod =b.sala_ccod " & vbCrLf & _
		"			and b.tsal_ccod=c.tsal_ccod " & vbCrLf & _
		"			and cast(b.sala_ccod as varchar)='" & codigo & "'" & vbCrLf & _
		"			and hora_ccod is not null  " & vbCrLf & _
		"			and a.secc_ccod=d.secc_ccod and d.asig_ccod=e.asig_ccod and d.peri_ccod = case e.duas_ccod when 3 then '"&periodo_1&"' else '"&peri&"' end " & vbCrLf & _
		"			and a.bloq_finicio_modulo  " & vbCrLf & _
		"		between  " & vbCrLf & _
		"			" & fini & vbCrLf & _
		"		  and  " & vbCrLf & _
		"		    " & fter & vbCrLf & _
		"	  	group by  " & vbCrLf & _
		"			b.sala_ccod,sala_ciso,tsal_tdesc,dias_ccod,hora_ccod " & vbCrLf 
		
		'INNER JOIN bloque_horarios
		'ON a.secc_ccod = c.ccod
		'response.Write("<pre>"&consulta&"</pre>")
		
		conexion.ejecuta consulta
		set r = conexion.obtenerRegistros
		for each x in r.Item("filas").Items
			dia = cint(x.Item("DIAS_CCOD"))
			hora = cint(x.Item("HORA_CCOD"))
			'response.Write("<br>dia "&dia&" hora "&hora)
			'response.Write("sHorario.Exists(hora) "&sHorario.Exists(hora-1) )
			if sHorario.Exists(hora) then
				if sHorario.Item(hora).Exists(dia) then
					sHorario.Item(hora).Item(dia).Item("usos") = cint(x.Item("USOS"))
					sHorario.Item(hora).Item(dia).Item("valor") = x.Item("DETALLE")
					'response.Write("<br>usos "&x.Item("USOS")&" detalle "&x.Item("DETALLE"))
				end if
			end if
		next
	end sub
	
	'-----------------------------------------------------------------------------------------
	sub cargaHorarioSeccion(codigo,fecha_inicio,fecha_termino)
	'response.Write("cargaHorarioSeccion")
		fini = negocio.cambiaFecha(fecha_inicio)
		fter = negocio.cambiaFecha(fecha_termino)
		
		'response.Write("<pre>"&peri&"</pre>")
		'response.Write("<pre>"&fini&"</pre>")
		'response.Write("<pre>"&fter&"</pre>")
		
'		consulta = "select " & vbCrLf & _
'		"		b.sala_ccod,sala_ciso,tsal_tdesc,dias_ccod,hora_ccod, " & _
'		"       protic.detalle_seccion(a.secc_ccod,b.sala_ccod,a.dias_ccod,a.hora_ccod) as detalle, count(distinct a.bloq_ccod) as usos " & vbCrLf & _
'		"	  from " & vbCrLf & _
'		"		bloques_horarios a, salas b, tipos_sala c " & vbCrLf & _
'		"	  where " & vbCrLf & _
'		"		a.sala_ccod *=b.sala_ccod " & vbCrLf & _
'		"		and b.tsal_ccod=c.tsal_ccod " & vbCrLf & _
'		"		and cast(a.secc_ccod as varchar)= '" & codigo & "'" & vbCrLf & _
'		"		and a.bloq_finicio_modulo  " & vbCrLf & _
'		"		between  " & vbCrLf & _
'		"			" & fini & vbCrLf & _
'		"		  and  " & vbCrLf & _
'		"		    " & fter & vbCrLf & _
'		"	  group by  " & vbCrLf & _
'		"		b.sala_ccod,sala_ciso,tsal_tdesc,dias_ccod,hora_ccod,a.secc_ccod " & vbCrLf 

'--------------------------------------------------------------------------------------------------------------------------ACTUALIZACIÓN SQLServer 2008	
consulta = " select b.sala_ccod,                                      " & vbCrLf &_
"       sala_ciso,                                                    " & vbCrLf &_
"       tsal_tdesc,                                                   " & vbCrLf &_
"       dias_ccod,                                                    " & vbCrLf &_
"       hora_ccod,                                                    " & vbCrLf &_
"       protic.detalle_seccion(a.secc_ccod, b.sala_ccod, a.dias_ccod, " & vbCrLf &_
"       a.hora_ccod) as                                               " & vbCrLf &_
"       detalle,                                                      " & vbCrLf &_
"       count(distinct a.bloq_ccod)                                   " & vbCrLf &_
"       as usos                                                       " & vbCrLf &_
"from   bloques_horarios as a                                         " & vbCrLf &_
"       left outer join salas as b                                    " & vbCrLf &_
"                    on a.sala_ccod = b.sala_ccod                     " & vbCrLf &_
"       inner join tipos_sala as c                                    " & vbCrLf &_
"               on b.tsal_ccod = c.tsal_ccod                          " & vbCrLf &_
"where  cast(a.secc_ccod as varchar) = '" & codigo & "'               " & vbCrLf &_
"       and a.bloq_finicio_modulo between "& fini &" and "& fter &        vbCrLf &_
"group  by b.sala_ccod,                                               " & vbCrLf &_
"          sala_ciso,                                                 " & vbCrLf &_
"          tsal_tdesc,                                                " & vbCrLf &_
"          dias_ccod,                                                 " & vbCrLf &_
"          hora_ccod,                                                 " & vbCrLf &_
"          a.secc_ccod                                                "
'--------------------------------------------------------------------------------------------------------------------------ACTUALIZACIÓN SQLServer 2008	

		conexion.ejecuta consulta

		set r = conexion.obtenerRegistros
		for each x in r.Item("filas").Items
			dia = cint(x.Item("DIAS_CCOD"))
			hora = cint(x.Item("HORA_CCOD"))
			if sHorario.Exists(hora) then
				if sHorario.Item(hora).Exists(dia) then
					sHorario.Item(hora).Item(dia).Item("usos") = cint(x.Item("USOS"))
					sHorario.Item(hora).Item(dia).Item("valor") = x.Item("DETALLE")
				end if
			end if
		next
	end sub
	
	sub cargaHorarioCarrera(codigo)
	'-----------------o---------------------
	'LO QUE ESTABA
	'	consulta = "select " & vbCrLf & _
	'	"		b.sala_ccod,tsal_tdesc,dias_ccod,hora_ccod, " & _
	'	"       protic.detalle_seccion( " & _
	'	"       a.secc_ccod,b.sala_ccod,a.dias_ccod,a.hora_ccod) " & _
	'	"       as detalle, count(distinct a.bloq_ccod) as usos " & vbCrLf & _
	'	"	  from " & vbCrLf & _
	'	"		bloques_horarios a, salas b, tipos_sala c " & vbCrLf & _
	'	"	  where " & vbCrLf & _
	'	"		a.sala_ccod =b.sala_ccod " & vbCrLf & _
	'	"		and b.tsal_ccod=c.tsal_ccod " & vbCrLf & _
	'	"		and cast(a.secc_ccod as varchar) in " & codigo & "" & vbCrLf & _
	'	"	  group by  " & vbCrLf & _
	'	"		b.sala_ccod,sala_ciso,tsal_tdesc,dias_ccod,hora_ccod,a.secc_ccod " & vbCrLf 
	'-----------------O-----------------------
	
	consulta = " select b.sala_ccod,tsal_tdesc,dias_ccod,hora_ccod,count(distinct a.bloq_ccod) as usos,"  & vbCrLf & _
		     " 		cast(f.asig_ccod as varchar)+ '-<font color=#0000FF>' +cast(f.asig_tdesc as varchar)+ ' ('+cast(f.asig_nhoras as varchar)+' hrs)'+'</font> sala '+' '+ cast(b.sala_tdesc as varchar) +'<br>'+ protic.obtener_profesor(a.bloq_ccod) as detalle " & vbCrLf & _
			 " from " & vbCrLf & _
			 " 		bloques_horarios a, salas b, tipos_sala c,secciones d,asignaturas f " & vbCrLf & _
			 " where  "& vbCrLf & _
			 " 		a.sala_ccod =b.sala_ccod " & vbCrLf & _
       		 " 		and a.secc_ccod=d.secc_ccod " & vbCrLf & _
       		 " 		and d.asig_ccod=f.asig_ccod "& vbCrLf & _
       		 " 		and b.tsal_ccod=c.tsal_ccod " & vbCrLf & _
			 " 		and cast(a.secc_ccod as varchar) in "& codigo &" " & vbCrLf & _
			 " group by b.sala_ccod,sala_ciso,tsal_tdesc,dias_ccod,hora_ccod,a.secc_ccod, " & vbCrLf & _
             " 		f.asig_ccod,f.asig_tdesc,f.asig_nhoras,b.sala_tdesc,a.bloq_ccod"
		
        'response.Write("<pre>"&consulta&"</pre>")
		conexion.ejecuta consulta

		set r = conexion.obtenerRegistros
		for each x in r.Item("filas").Items
			dia = cint(x.Item("DIAS_CCOD"))
			hora = cint(x.Item("HORA_CCOD"))
			if sHorario.Exists(hora) then
				if sHorario.Item(hora).Exists(dia) then
					sHorario.Item(hora).Item(dia).Item("usos") = cint(x.Item("USOS"))
					sHorario.Item(hora).Item(dia).Item("valor") = x.Item("DETALLE")
				end if
			end if
		next
	end sub
	'------------------------------------------------------------------------------
	sub cargaHorarioAlumno(codigo,fecha_inicio,fecha_termino)
	fini = negocio.cambiaFecha(fecha_inicio)
	fter = negocio.cambiaFecha(fecha_termino)
			
	nueva_sede =session("nueva_sede")
	
	if nueva_sede= "" or esVacio(nueva_sede) or isnull(nueva_sede) then
	      filtro_sede=""
	else
		  filtro_sede= " and cast(f.sede_ccod as varchar)='"&nueva_sede&"'"	  
	end if		
	'response.End()
	'response.Write("cargahorarioAlumno")
	
	'------PERIODO ACTUAL A PARTIR DE MATR_CORR-------------
	'peri_actual = conexion.consultaUno("select b.peri_ccod as periodo" & vbCrLf & _
	'	"	from alumnos a, postulantes b" & vbCrLf & _
	'	"	where 	a.matr_ncorr='" & codigo & "' " & vbCrLf & _
	'	"			and a.post_ncorr=b.post_ncorr" & vbCrLf & _
	'	"			and a.pers_ncorr=b.pers_ncorr")

	'response.Write("periodo lectivo :" & peri_actual)		
	'response.End()
	'-----------------------------------------------------------
	'-------------PERS_NCORR A PARTIR DEL MATR_NCORR--------------
	pers_ncorr = conexion.consultaUno("select pers_ncorr from alumnos 	where matr_ncorr='" & codigo & "' ")
    plec_ccod = conexion.consultaUno("select plec_ccod from alumnos a, ofertas_academicas b, periodos_academicos c where a.ofer_ncorr=b.ofer_ncorr and b.peri_ccod=c.peri_ccod and cast(a.matr_ncorr as varchar)='"&codigo&"'")
	periodo_actual = conexion.consultaUno("select b.peri_ccod from alumnos a, ofertas_academicas b, periodos_academicos c where a.ofer_ncorr=b.ofer_ncorr and b.peri_ccod=c.peri_ccod and cast(a.matr_ncorr as varchar)='"&codigo&"'")
	
	if plec_ccod = "2" then
		anos_ccod = conexion.consultaUno("select anos_ccod from alumnos a, ofertas_academicas b, periodos_academicos c where a.ofer_ncorr=b.ofer_ncorr and b.peri_ccod=c.peri_ccod and cast(a.matr_ncorr as varchar)='"&codigo&"'")
		primer_periodo = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod&"' and plec_ccod=1")
		carr_ccod = conexion.consultaUno("select carr_ccod from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(a.matr_ncorr as varchar)='"&codigo&"'")
		mat_anterior = conexion.consultaUno("select matr_ncorr from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and cast(c.carr_ccod as varchar)='"&carr_ccod&"' and cast(peri_ccod as varchar)='"&primer_periodo&"' and emat_ccod in (1,2,4,6,11,8,10,13)")
	end if
	'response.Write("mat_anterior :" & mat_anterior)
	'RESPONSE.End()
	'------------------------------------------------------------------------	
	'-----------------MATR_ncorr DEL PERODO ANTERIOR A PARTIR DE PERS_NCORR-------------
 	 if mat_anterior <> "" then
	 	filtro_matriculas = " and cast(d.matr_ncorr as varchar) in ('" & codigo & "', '" & mat_anterior & "')"
		filtro_periodo= " and cast(f.peri_ccod as varchar)= case g.duas_ccod when '3' then '"&primer_periodo&"' else '"&periodo_actual&"' end "
	 else
	 	filtro_matriculas = " and cast(d.matr_ncorr as varchar) in ('" & codigo & "')"
		filtro_periodo = " and cast(f.peri_ccod as varchar)=  '"&periodo_actual&"'"
	 end if
		
	consulta = " select b.sala_ccod,tsal_tdesc,dias_ccod,hora_ccod,cast(f.asig_ccod as varchar)+ '-' +  " & vbCrLf & _
		       " cast(f.secc_tdesc as varchar) + ' ' + cast(g.asig_tdesc as varchar)+ ' ' + cast(b.sala_tdesc as varchar)+ ' ' + '' +  " & vbCrLf & _
			   " protic.profesores_bloque(a.bloq_ccod) +  " & vbCrLf & _
    		   " case (select count(*) from horario_asignado_real aaa where aaa.bloq_ccod=a.bloq_ccod)  " & vbCrLf & _
               " when 0 then ''  " & vbCrLf & _
               " else '<br><font color=#000099>' +  " & vbCrLf & _
               " 	(select '<strong>Horario Clase: <br>('+ cast( datepart(hour,hora_hinicio)as varchar)+ ':' + cast( datepart(minute,hora_hinicio)as varchar)+  " & vbCrLf & _
      		   "  	' -- ' + cast( datepart(hour,hora_htermino)as varchar)+ ':' + cast( datepart(minute,hora_htermino)as varchar)+ ')'  " & vbCrLf & _
 			   " 	from horario_asignado_real aaa,horarios_optativos bbb  " & vbCrLf & _
			   " 	where aaa.bloq_ccod=a.bloq_ccod and aaa.hora_ccod_optativos=bbb.hora_ccod_optativos) + '</strong></font>'  " & vbCrLf & _
			   " end  " & vbCrLf & _
		       " as detalle,  " & vbCrLf & _
		       " count(distinct a.bloq_ccod) as usos  " & vbCrLf & _
				"	  	from " & vbCrLf & _
				"			bloques_horarios a, salas b, tipos_sala c, cargas_academicas d, personas e, secciones f, asignaturas g " & vbCrLf & _
				"	  	where " & vbCrLf & _
				"			a.sala_ccod =b.sala_ccod " & vbCrLf & _
				"			and a.pers_ncorr =e.pers_ncorr " & vbCrLf & _
				"			and a.secc_ccod=f.secc_ccod " & vbCrLf & _
				"			and f.asig_ccod=g.asig_ccod "&filtro_sede & vbCrLf & _
				"			and b.tsal_ccod=c.tsal_ccod " & vbCrLf & _
				"			and a.secc_ccod=d.secc_ccod " & vbCrLf & _
				"			and not exists (select 1 from convalidaciones conv where d.matr_ncorr=conv.matr_ncorr and f.asig_ccod=conv.asig_ccod) " & vbCrLf & _
				"			"& filtro_matriculas & vbCrLf & _
				"			"& filtro_periodo & vbCrLf & _
				"	  group by  " & vbCrLf & _
				"			f.asig_ccod,f.secc_tdesc, g.asig_tdesc, b.sala_ccod,tsal_tdesc,dias_ccod,hora_ccod,a.secc_ccod,e.pers_tape_paterno, e.pers_tnombre,a.bloq_ccod,b.sala_tdesc"
				
		'response.Write("fecha inicio periodo:<pre>"&fini&"</pre>")
		'response.Write("fecha termino periodo:<pre>"&fter&"</pre>")
		'response.Write("N Matricula Actual:<pre>"&codigo&"</pre>")
		'response.Write("N Matricula Anterior:<pre>"&matr_ant&"</pre>")
		'response.Write("<pre>"&consulta&"</pre>")		
		'response.End()
		conexion.ejecuta consulta
		set r = conexion.obtenerRegistros
		for each x in r.Item("filas").Items
			dia = cint(x.Item("DIAS_CCOD"))
			hora = cint(x.Item("HORA_CCOD"))
			if sHorario.Exists(hora) then
				if sHorario.Item(hora).Exists(dia) then
					sHorario.Item(hora).Item(dia).Item("usos") = cint(x.Item("USOS"))
					sHorario.Item(hora).Item(dia).Item("valor") = x.Item("DETALLE")
				end if
			end if
		next
	end sub
	
	sub cargaHorarioProfesor(codigo,fecha_inicio,fecha_termino)
	'response.Write("cargaHorarioProfesor")
		fini = negocio.cambiaFecha(fecha_inicio)
		fter = negocio.cambiaFecha(fecha_termino)
		
		consulta = " SELECT" & vbCrLf & _
        "       a.dias_ccod,a.hora_ccod, d.asig_tdesc + '  '+ cast(b.asig_ccod as varchar) + '-' + b.secc_tdesc + '<br>' + cast(c.sala_ciso as varchar) as detalle," & vbCrLf & _
		"	  d.asig_tdesc" & vbCrLf & _
        "     , ' Aula ' + cast(c.sala_ciso as varchar) as sala_ciso, e.sede_tdesc, count(distinct a.bloq_ccod) as usos" & vbCrLf & _
        "      from" & vbCrLf & _
        "        bloques_horarios a, secciones b, salas c,asignaturas d, sedes e," & vbCrLf & _
		"	     bloques_profesores f" & vbCrLf & _
        "      where" & vbCrLf & _
        "        a.secc_ccod=b.secc_ccod" & vbCrLf & _
        "        and a.sala_ccod=c.sala_ccod" & vbCrLf & _
		"		 and a.bloq_ccod = f.bloq_ccod " & vbCrLf & _
		"	     and cast(f.pers_ncorr as varchar) ='"&codigo&"'" & vbCrLf & _
		"	     and d.asig_ccod=b.asig_ccod" & vbCrLf & _
		"	     and b.sede_ccod=e.sede_ccod " & vbCrLf & _
		"	     and (" & vbCrLf & _
		"	 	    a.bloq_finicio_modulo between "&fini&" and "&fter&"" & vbCrLf & _
		"		    or a.bloq_ftermino_modulo between "&fini&" and "&fter&"" & vbCrLf & _
		"		    or a.bloq_finicio_modulo < "&fini&" and a.bloq_ftermino_modulo > "&fter&"" & vbCrLf & _
		"		) group by  a.dias_ccod,a.hora_ccod,d.asig_tdesc,sala_ciso, e.sede_tdesc,b.asig_ccod,b.secc_tdesc"
		
		'consulta = "select " & vbCrLf & _
		'"		b.sala_ccod,sala_ciso,tsal_tdesc,dias_ccod,hora_ccod, " & vbCrLf & _
		'"       protic.detalle_profesor( " & vbCrLf & _
		'"       a.pers_ncorr,a.dias_ccod,a.hora_ccod, " & vbCrLf & _
		'"       " & fini & "," & fter & ") as detalle, count(distinct a.bloq_ccod) as usos " & vbCrLf & _
		'"	  from " & vbCrLf & _
		'"		bloques_horarios a, salas b, tipos_sala c " & vbCrLf & _
		'"	  where " & vbCrLf & _
		'"		a.sala_ccod *=b.sala_ccod " & vbCrLf & _
		'"		and b.tsal_ccod=c.tsal_ccod " & vbCrLf & _
		'"		and a.pers_ncorr=" & codigo & vbCrLf & _
		'"		and a.bloq_finicio_modulo  " & vbCrLf & _
		'"		between  " & vbCrLf & _
		'"			" & fini &"" & vbCrLf & _
		'"		  and  " & vbCrLf & _
		'"		    " & fter &"" & vbCrLf & _
		'"	  group by  " & vbCrLf & _
		'"		b.sala_ccod,sala_ciso,tsal_tdesc,dias_ccod,hora_ccod, a.pers_ncorr" & vbCrLf 
		'response.write(consulta)
		
		conexion.ejecuta consulta
		set r = conexion.obtenerRegistros
		for each x in r.Item("filas").Items
			dia = cint(x.Item("DIAS_CCOD"))
			hora = cint(x.Item("HORA_CCOD"))
			if sHorario.Exists(hora) then
				if sHorario.Item(hora).Exists(dia) then
					sHorario.Item(hora).Item(dia).Item("usos") = cint(x.Item("USOS"))
					sHorario.Item(hora).Item(dia).Item("valor") = x.Item("DETALLE")
				end if
			end if
		next
	end sub
	
	function creaHorario
	    if session("nueva_sede")<>"" then
			consulta = "select a.hora_ccod, cast(datePart(hour,hora_hinicio) as varchar)+':'+cast(datePart(minute,hora_hinicio) as varchar)  + '<br>' + cast(datePart(hour,hora_htermino) as varchar)+':'+cast(datePart(minute,hora_htermino) as varchar) as h from horarios a, horarios_sedes b where a.hora_ccod=b.hora_ccod and  cast(sede_ccod as varchar) = '" & session("nueva_sede") & "' and isnull(horario_antiguo,0) = 0" 
		else
			consulta = "select a.hora_ccod, cast(datePart(hour,hora_hinicio) as varchar)+':'+cast(datePart(minute,hora_hinicio) as varchar)  + '<br>' + cast(datePart(hour,hora_htermino) as varchar)+':'+cast(datePart(minute,hora_htermino) as varchar) as h from horarios a, horarios_sedes b where a.hora_ccod=b.hora_ccod and  cast(sede_ccod as varchar) = '" & session("sede") & "' and isnull(horario_antiguo,0) = 0" 
		end if	
		conexion.ejecuta consulta
		set xHoras = conexion.obtenerRegistros
		consulta = "select dias_ccod, dias_tdesc from dias_semana where dias_ccod < 7"
		conexion.ejecuta consulta
		set xDias = conexion.obtenerRegistros
		set xHorario = CreateObject("scripting.Dictionary")
		xHorario.Add 0, CreateObject("scripting.Dictionary")
		xHorario.Item(0).Add 0, CreateObject("scripting.Dictionary")
		xHorario.Item(0).Item(0).Add "valor", "&nbsp;"
		xHorario.Item(0).Item(0).Add "usos", "0"
		for i=1 to xDias.Item("filas").count
			xHorario.Item(0).Add i, CreateObject("scripting.Dictionary")
			xHorario.Item(0).Item(i).Add "valor", xDias.Item("filas").Item(i-1).Item("DIAS_TDESC")
			xHorario.Item(0).Item(i).Add "usos", "0"
		next
		for i=1 to xHoras.Item("filas").count
			xHorario.add i, CreateObject("scripting.Dictionary")
			xHorario.Item(i).Add 0, CreateObject("scripting.Dictionary")
			xHorario.Item(i).Item(0).Add "valor", xHoras.Item("filas").Item(i-1).Item("H")
			xHorario.Item(i).Item(0).Add "usoa", "0"
			for j=1 to xDias.Item("filas").count
				xHorario.Item(i).Add j, CreateObject("scripting.Dictionary")
				xHorario.Item(i).Item(j).Add "valor", "&nbsp;"
				xHorario.Item(i).Item(j).Add "uso", "0"
			next
		next
		set creaHorario = xHorario
	end function

	sub generaHorario(codigo,fecha_inicio,fecha_termino,tipo)
		select case ucase(tipo)
			case "SALA"
				me.cargaHorarioSala codigo,fecha_inicio,fecha_termino
			case "SALA_PERIODO"
				me.cargaHorarioSalaPeriodo codigo,fecha_inicio,fecha_termino	
			case "DOCENTE"
				me.cargaHorarioProfesor codigo,fecha_inicio,fecha_termino
			case "SECCION"
				me.cargaHorarioSeccion codigo,fecha_inicio,fecha_termino
			case "ALUMNO"
				me.cargaHorarioAlumno codigo,fecha_inicio,fecha_termino
			case "CARRERA"
				me.cargaHorarioCarrera codigo
		end select
	end sub
	
end class
%>