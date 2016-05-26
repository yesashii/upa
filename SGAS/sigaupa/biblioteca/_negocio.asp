<!-- #include file = "class_cuenta_corriente.asp" -->
<!-- #include file = "class_pagina.asp" -->
<!-- #include file = "class_postulante.asp" -->
<!-- #include file = "class_persona.asp" -->
<!-- #include file = "class_alumno.asp" -->
<!-- #include file = "class_cajero.asp" -->
<!-- #include file = "class_horario.asp" -->
<!-- #include file = "class_historico_notas.asp" -->
<!-- #include file = "class_fcalendario.asp" -->
<%
'**************************************************************************************************************
'************************************* C L A S E     N E G O C I O  *******************************************
Class CNegocio
	private conexion, usuario, sede, carreras, nombreUsuario, nombreSede
		
	sub Inicializa ( con ) 
		set conexion = con

		
		'---------------------------- PARA QUE OPERE EN DESARROLLO-------------------------------------
		'if (isnull(session("rut_usuario")) or session("rut_usuario")="" or isempty(session("rut_usuario"))) then 
		'	session("rut_usuario") = ""
			'session("rut_usuario") = "13516972"
		'end if 
		sql_periodo	=	" select max(a.peri_ccod) from periodos_academicos a,actividades_periodos b " & vbCrLf &_
                        " where a.peri_ccod=b.peri_ccod " & vbCrLf &_
                        " and b.acpe_bvigente='S' " & vbCrLf &_
                        " and tape_ccod=1 " 
		v_periodo	=	conexion.consultaUno(sql_periodo)	
		'v_periodo="164"
		'session("_periodo_CLASES18") = "164"
		'session("_periodo_CLASES20") = "164"
		'session("_periodo_PLANIFICACIONINTERSEM") = "164"
		'session("_periodo_POSTULACION") = "164"
		'session("_periodo_PLANIFICACION") = "164"
		session("_periodo_CLASES18") 		= v_periodo
		session("_periodo_CLASES20") 		= v_periodo
		actividad = session("_actividad")
		if actividad = "5" then
			session("_periodo_POSTULACION") 	= session("_periodo")
		else
			session("_periodo_POSTULACION") 	= v_periodo
		end if	
		'session("_periodo_PLANIFICACION") 	= v_periodo
		if actividad = "6" then
			session("_periodo_PLANIFICACION") 	= session("_periodo")
		else
			session("_periodo_PLANIFICACION") 	= v_periodo
		end if
		session("_periodo_PLANIFICACIONINTERSEM") = v_periodo
		'for each k in session.Contents
		'response.Write("<br>" & k)
		'next
		'-------------------------------------------------------------------------------------
		
		
		usuario = session("rut_usuario")		
	    'response.Write("usuario "&usuario)
		if usuario="" then
			paginaTerminoSesion = "../portada/portada.asp"
			response.Redirect paginaTerminoSesion
			response.flush
		end if
		
		'consulta = "select sede_ccod from funcionarios a, personas b where a.pers_ncorr=b.pers_ncorr and pers_nrut = " & usuario		
		consulta = " select c.sede_ccod " & vbCrLf &_
		           " from personas a, sis_usuarios b, sis_sedes_usuarios c " & vbCrLf &_
				   " where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
				   "  and b.pers_ncorr = c.pers_ncorr " & vbCrLf &_
				   "  and cast(a.pers_nrut as varchar) = '" & usuario & "'"		
		'response.Write(consulta)
		'response.Flush()
		sede_aux = conexion.consultaUno(consulta)
		'response.Write("<hr>"&session("sede")&"<hr>")
		'response.Write("Sede: "&sede_aux)
        if session("sede")=""  then
		   sede=sede_aux
		   session("sede")=sede_aux
		else
		  sede = session("sede")
		  session("sede")= session("sede")
		end if 
		
		'''''''''''''''''''''''''''''''''''''modificación 20-09-2004''''''''''''''''''''''''''''''''''''''''''''''''''''''
		consulta = "select rtrim(ltrim(protic.obtener_carreras(" & usuario & "))) "
		'response.Write("<br>usuario "&consulta)
		carreras = conexion.consultaUno(consulta)
        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		nombreSede = conexion.consultauno("select sede_tdesc from sedes where cast(sede_ccod as varchar)= '"&sede&"'")		
		nombreUsuario = conexion.consultaUno("select pers_tnombre  +' ' + pers_tape_paterno from personas where cast(pers_nrut as varchar)= '" & usuario&"'")		
		Session("_nombreSede") = nombreSede
		Session("_nombreUsuario") = nombreUsuario
	end sub
	
	
	Sub AsignaConexion(con)
		set conexion = con
	End Sub
	
	sub InicializaPortal(con)
		sql_periodo	=	" select max(a.peri_ccod) from periodos_academicos a,actividades_periodos b " & vbCrLf &_
                        " where a.peri_ccod=b.peri_ccod " & vbCrLf &_
                        " and b.acpe_bvigente='S' " & vbCrLf &_
                        " and tape_ccod=1 "      
		v_periodo	=	con.consultaUno(sql_periodo)
        'v_periodo   =   "164"
		set conexion = con
		actividad = session("_actividad")
		if actividad = "5" then
			session("_periodo_POSTULACION") 	= session("_periodo")
		else
			session("_periodo_POSTULACION") 	= v_periodo
		end if	
	end sub
	
	function ObtenerFechaActual
	    consulta = "SELECT CONVERT(DATETIME,getdate(),103)"
		fechaActual = conexion.consultaUno(consulta)
		obtenerFechaActual = fechaActual
	end function
	
	function CambiaFecha( fecha )
		cambiaFecha = "convert(datetime,'" & fecha & "',103)"
	end function
	
	function ObtenerSede
		obtenerSede = sede 
	end function
	
	function ObtenerUsuario
		obtenerUsuario = usuario 
	end function
	
	function ObtenerNombreUsuario
		obtenerNombreUsuario = nombreUsuario 
	end function
	
	function ObtenerNombreSede
		consulta = "select sede_tdesc from sedes where sede_ccod = " & sede
		nombreSede = conexion.consultaUno(consulta)
		obtenerNombreSede = nombreSede 
	end function
	
	function ObtenerSesion(id_sesion)	    
		TextoSql = "select valida_sesion('" & id_sesion & "') a from dual"
		SesionUsuario=conexion.consultaUno(TextoSql)
				
		if (isnull(SesionUsuario)) or (SesionUsuario="") or (isempty(SesionUsuario))  then
			paginaTerminoSesion = "http://www.upacifico.cl"
			response.Redirect paginaTerminoSesion
			
			response.flush
			
		else
				v_pers_ncorr = conexion.consultaUno(TextoSql)				
				conectar.ejecutaP("actualiza_sesion('"&id_sesion&"')")
				sql="select pers_nrut from personas where pers_ncorr='"&v_pers_ncorr&"'"
				session("rut_usuario")=conexion.consultaUno(sql)
				sqlsede="select sede_ccod from profesores a, personas b where a.pers_ncorr=b.pers_ncorr  and pers_nrut='"&session("rut_usuario")&"'"
				session("sede")=conexion.consultaUno(sqlsede)
				if isnull(session("sede") ) then
				sqlsede="select sede_ccod from alumnos a, ofertas_academicas b " & _
						" where a.ofer_ncorr=b.ofer_ncorr " & _
						" and pers_ncorr='"&v_pers_ncorr&"'"
						
				session("sede")=conexion.consultaUno(sqlsede)
				end if
				obtenerSesion = v_pers_ncorr
		end if

	end function

	function ObtenerUsuarioPortal
		ObtenerUsuarioPortal=session("rut_usuario")
	end function	
	
	
	function ObtenerFechaInicio (ByVal proceso, ByVal forma )
		dim peri_ccod
		dim consulta		
		
		proceso = UCase(proceso)
		forma = UCase(forma)
		
		if proceso = "CLASES" then
			proceso = "CLASES18"
		end if	
		
		peri_ccod = ObtenerPeriodoAcademico(proceso)
		
		
		'consulta = "select case '" & forma & "' " & vbCrLf &_
		'		   "	       when 'I' then to_char(case a.tape_ccod when c.plec_ccod then c.peri_finicio_periodo else a.acpe_finicio end, 'mm/dd/yyyy') " & vbCrLf &_
		'		   "		   else to_char(case a.tape_ccod when c.plec_ccod then c.peri_finicio_periodo else a.acpe_finicio end, 'dd/mm/yyyy') " & vbCrLf &_
		'		   "	   end as acpe_finicio " & vbCrLf &_				   
				   
		'consulta = "select decode ('" & forma & "', 'I', to_char(decode(a.tape_ccod, c.plec_ccod, c.peri_finicio_periodo, a.acpe_finicio), 'mm/dd/yyyy'), to_char(decode(a.tape_ccod, c.plec_ccod, c.peri_finicio_periodo, a.acpe_finicio), 'dd/mm/yyyy')) as acpe_finicio " & vbCrLf &_
		'		   "from actividades_periodos a, tipos_actividades_periodos b, periodos_academicos c " & vbCrLf &_
		'		   "where a.tape_ccod = b.tape_ccod " & vbCrLf &_
		'		   "  and a.peri_ccod = c.peri_ccod " & vbCrLf &_
		'		   "  and upper(b.tape_tactividad) = upper('" & proceso & "') " & vbCrLf &_
		'		   "  and a.peri_ccod = '" & peri_ccod & "'"
		
		'consulta ="select  case '" & forma & "' when 'I' then convert(varchar,case a.tape_ccod when c.plec_ccod then c.peri_finicio_periodo else  a.acpe_finicio end, 101)" & vbCrLf &_
         '         " else convert(varchar,case a.tape_ccod when c.plec_ccod then c.peri_finicio_periodo else a.acpe_finicio end, 103) end as acpe_finicio " & vbCrLf &_
          '        " from actividades_periodos a, tipos_actividades_periodos b, periodos_academicos c " & vbCrLf &_
			'	  " where a.tape_ccod = b.tape_ccod and a.peri_ccod = c.peri_ccod " & vbCrLf &_
             '     " and upper(b.tape_tactividad) = upper('" & proceso & "') and cast(a.peri_ccod as varchar) = '" & peri_ccod & "'" 
				  
		consulta ="select  case '" & forma & "' when 'I' then convert(datetime,a.acpe_finicio, 101)" & vbCrLf &_
                  " else convert(datetime,a.acpe_finicio, 103) end as acpe_finicio " & vbCrLf &_
                  " from actividades_periodos a, tipos_actividades_periodos b, periodos_academicos c " & vbCrLf &_
				  " where a.tape_ccod = b.tape_ccod and a.peri_ccod = c.peri_ccod " & vbCrLf &_
                  " and upper(b.tape_tactividad) = upper('" & proceso & "') and cast(a.peri_ccod as varchar) = '" & peri_ccod & "'" 
				  
		'response.Write("<preg>"&consulta&"</preg>")		   
		'response.End()
		ObtenerFechaInicio = conexion.ConsultaUno(consulta)
	end function
	
	
	function ObtenerFechaTermino (ByVal proceso, ByVal forma )
		dim peri_ccod
		dim consulta		
		
		proceso = UCase(proceso)
		forma = UCase(forma)
		peri_ccod = ObtenerPeriodoAcademico(proceso)		
		
		'consulta = "select case '" & forma & "' " & vbCrLf &_
		'		   "	       when 'I' then to_char(acpe_ftermino, 'mm/dd/yyyy') " & vbCrLf &_
		'		   "		   else to_char(acpe_ftermino, 'dd/mm/yyyy') " & vbCrLf &_
		'		   "	   end as acpe_ftermino " & vbCrLf &_
				   
		'consulta = "select decode('" & forma & "', 'I', to_char(acpe_ftermino, 'mm/dd/yyyy'), to_char(acpe_ftermino, 'dd/mm/yyyy')) as acpe_ftermino " & vbCrLf &_
		'		   "from actividades_periodos a, tipos_actividades_periodos b, periodos_academicos c " & vbCrLf &_
		'		   "where a.tape_ccod = b.tape_ccod " & vbCrLf &_
		'		   "  and a.peri_ccod = c.peri_ccod " & vbCrLf &_
		'		   "  and upper(b.tape_tactividad) = upper('" & proceso & "') " & vbCrLf &_
		'		   "  and a.peri_ccod = '" & peri_ccod & "'"
				   
		consulta = "select case '" & forma & "' when  'I' then convert(datetime,acpe_ftermino, 101)" & vbCrLf &_
                   " else convert(datetime,acpe_ftermino,103)end  as acpe_ftermino " & vbCrLf &_
                   " from actividades_periodos a, tipos_actividades_periodos b, periodos_academicos c " & vbCrLf &_
                   " where a.tape_ccod = b.tape_ccod and a.peri_ccod = c.peri_ccod " & vbCrLf &_
                   " and upper(b.tape_tactividad) = upper('" & proceso & "') and cast(a.peri_ccod as varchar) = '" & peri_ccod & "'" 
		
		'response.Write("<preg>"&consulta&"</preg>")		   
		'response.End()		   
		ObtenerFechaTermino = conexion.ConsultaUno(consulta)
	end function
	
	
	'function obtenerFechaInicio___ ( proceso, forma )
	'	select case proceso
	'		case "CLASES"
	'			select case forma
	'				case "I"
	'					obtenerFechaInicio = "03/10/2003"
	'				case "E"
	'					obtenerFechaInicio = "10/03/2003"
	'			end select
	'	end select
	'end function
	
	'function obtenerFechaTermino___ ( proceso, forma )
	'	select case proceso
	'		case "CLASES18"
	'			select case forma
	'				case "I"
	'					obtenerFechaTermino = "07/19/2003"
	'				case "E"
	'					obtenerFechaTermino = "19/07/2003"
	'			end select
	'		case "CLASES19"
	'			select case forma
	'				case "I"
	'					obtenerFechaTermino = "07/26/2003"
	'				case "E"
	'					obtenerFechaTermino = "26/07/2003"
	'			end select 
	'		case "CLASES20"
	'			select case forma
	'				case "I"
	'					obtenerFechaTermino = "08/02/2003"
	'				case "E"
	'					obtenerFechaTermino = "02/08/2003"
	'			end select
	'	end select
	'end function
	
	Function ObtenerPeriodoAcademico(ByVal p_proceso)
		ObtenerPeriodoAcademico = Session("_periodo_" & p_proceso)
	End Function
	
	
	function ObtenerPeriodoAcademico_Inacap(ByVal proceso)
	
		ObtenerPeriodoAcademico = v_periodo
		exit function
	
		dim nombre_variable
		dim consulta
		dim registros
		dim ruta_biblioteca				
		
		'---------------------------------------------------------------------------------------------------------
		if UCase(proceso) = "CLASES" then
			proceso = "CLASES18"
		end if
		
		'---------------------------------------------------------------------------------------------------------
		nombre_variable = "_periodo_" & LCase(proceso)
		
		'---------------------------------------------------------------------------------------------------------
		if IsEmpty(Session(nombre_variable)) or IsNull(Session(nombre_variable)) or Session(nombre_variable) = "" then
			consulta = "select a.peri_ccod, a.tape_ccod, c.peri_tdesc, c.anos_ccod " & vbCrLf &_
			           "from actividades_periodos a, tipos_actividades_periodos b, periodos_academicos c " & vbCrLf &_
					   "where a.tape_ccod = b.tape_ccod " & vbCrLf &_
					   "  and a.peri_ccod = c.peri_ccod " & vbCrLf &_
					   "  and a.acpe_bvigente = 'S' " & vbCrLf &_
					   "  and upper(b.tape_tactividad) = '" & UCase(proceso) & "'" & vbCrLf &_
					   "order by a.peri_ccod asc"
					   
		   
			conexion.Ejecuta consulta
			set registros = conexion.ObtenerRegistros
			if registros.Item("filas").Count = 1 then
				Session(nombre_variable) = registros.Item("filas").Item(0).Item("PERI_CCOD")
				ObtenerPeriodoAcademico = Session(nombre_variable)
			else
				set fso = Server.CreateObject("Scripting.FileSystemObject")
				ruta_biblioteca = "../biblioteca"
				
				while not fso.FolderExists(Server.MapPath(ruta_biblioteca))
					ruta_biblioteca = "../" & ruta_biblioteca				
				wend
				
				set fso = Nothing
				%>
				<script language="JavaScript">
				function _revisar_ventana()
				{
					if (ventana_periodo != undefined) {
						if (!ventana_periodo.closed) {
							ventana_periodo.focus();
						}
					}
				}
			
				attachEvent('onfocus', _revisar_ventana);			
				ventana_periodo = open("<%=ruta_biblioteca%>/selecciona_periodo.asp?tape_tactividad=<%=LCase(proceso)%>", "", "height=200, width=500, top=50, left=100");			
			
				</script>
				<%
				ObtenerPeriodoAcademico = 0
				Response.End()
			end if
		else
			ObtenerPeriodoAcademico = Session(nombre_variable)
		end if
	end function
	
	
	'function obtenerPeriodoAcademico__ ( proceso )
	'	select case ucase(proceso)
	'		case "PLANIFICACION"
	'			consulta = "select peri_ccod from periodos_academicos where peri_fmatricula_nuevos > sysdate"
	'			' periodo = conexion.consultaUno ( consulta )
	'			periodo = "158"
	'			obtenerPeriodoAcademico = periodo
	'		case "POSTULACION"
	'			consulta = "select peri_ccod from periodos_academicos where peri_fmatricula_nuevos > sysdate"
	'			' periodo = conexion.consultaUno ( consulta )
	'			periodo = "158"
	'			obtenerPeriodoAcademico = periodo
	'		case "CLASES"
	'			consulta = "select peri_ccod from periodos_academicos where peri_fmatricula_nuevos > sysdate"
	'			' periodo = conexion.consultaUno ( consulta )
	'			periodo = "158"
	'			obtenerPeriodoAcademico = periodo
	'		case "OTONO"
	'			consulta = "select peri_ccod from periodos_academicos where peri_fmatricula_nuevos > sysdate"
	'			' periodo = conexion.consultaUno ( consulta )
	'			periodo = "158"
	'			obtenerPeriodoAcademico = periodo				
	'		case "PRIMAVERA"
	'			consulta = "select peri_ccod from periodos_academicos where peri_fmatricula_nuevos > sysdate"
	'			' periodo = conexion.consultaUno ( consulta )
	'			periodo = "160"
	'			obtenerPeriodoAcademico = periodo
	'		case "CERTIFICADO"
	'			consulta = "select peri_ccod from periodos_academicos where peri_fmatricula_nuevos > sysdate"
	'			' periodo = conexion.consultaUno ( consulta )
	'			periodo = "156"
	'			obtenerPeriodoAcademico = periodo								
	'	end select
	'end function
	
	function obtenerCarreras
		obtenerCarreras = carreras
	end function
	
	function obtenerRol
		obtenerRol = "JC"
	end function
	
	Function ObtenerInfoUsuario
		ObtenerInfoUsuario = me.obtenerNombreUsuario & " - " & me.obtenerNombreSede & " - " & me.obtenerFechaActual
	End Function
	
	
	Sub DibujarComboSedes(p_nombre_combo, p_valor, p_obligatorio)
		dim consulta, registros, fila
		dim salida, v_id, v_selected
		
		consulta = "select c.sede_ccod, c.sede_tdesc " & vbCrLf &_
		           "from personas a, sis_sedes_usuarios b, sedes c " & vbCrLf &_
				   "where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
				   "  and b.sede_ccod = c.sede_ccod " & vbCrLf &_
				   "  and a.pers_nrut = '" & Me.ObtenerUsuario & "' " & vbCrLf &_
				   "order by c.sede_tdesc"
				   
		conexion.Ejecuta consulta
		set registros = conexion.ObtenerRegistros
		
		if p_obligatorio then
			v_id = "TO-N"
		else
			v_id = "TO-S"
		end if
		
		salida = "<select name=""" & p_nombre_combo & """ id=""" & v_id & """>" &_
		         "<option value="""">Seleccione sede</option>"
		
		
		for each fila in registros.Item("filas").Items
			if CStr(fila.Item("SEDE_CCOD")) = CStr(p_valor) then
				v_selected = " selected"
			else
				v_selected = ""
			end if
			
			salida = salida & "<option value=""" & fila.Item("SEDE_CCOD") & """" & v_selected & ">" & fila.Item("SEDE_TDESC") & "</option>"
		next
		
		salida = salida & "</select>" & vbCrLf
		
		response.Write(salida)				   
	End Sub
	
	
		
	Function ObtenerParametroSistema(p_tipo_parametro)	
		select case UCase(p_tipo_parametro)
			case "NOTA_MINIMA"
				ObtenerParametroSistema = "1.0"
				
			case "NOTA_MAXIMA"
				ObtenerParametroSistema = "7.0"
				
			case "NOTA_APROBACION"
				ObtenerParametroSistema = "4.0"
				
			case else
				ObtenerParametroSistema = ""
				
		end select
		
	End Function
	
	
	Function ObtenerErrorOracle(p_strError)
		Dim str_error
		dim expRegular
		Dim matches
		Dim arr
		Dim i_
		Dim str
		
		arr = Split(p_strError, "ORA-")
		if Ubound(arr) > 0 then
			str_error = Left(arr(1), Len(arr(1)) - 1)
			arr = Split(str_error, ":")
			str_error = ""			

			i_ = 0
			for each str in arr				
				if i_ > 0 then
					str_error = str_error & str
				end if
				i_ = i_ + 1
			next
			
			if CLng(arr(0)) < 20000 then
				str_error = ""
			end if
			
		else
			str_error = ""
		end if
		
		ObtenerErrorOracle = Trim(str_error)
	End Function
	
	
	
	Function ObtenerContratosHermanos(p_cont_ncorr)
		Dim arr_contratos
		Dim f_consulta
		Dim d_contratos
		
		set f_consulta = new CFormulario
		f_consulta.Carga_Parametros "consulta.xml", "consulta"		
		
		set d_contratos = Server.CreateObject("Scripting.Dictionary")		
		d_contratos.Add p_cont_ncorr, ""
		
		listo = false
		while not listo 
			for each v_cont_ncorr in d_contratos.Keys
               if v_cont_ncorr="" or isempty(v_cont_ncorr) or isnull(v_cont_ncorr) then v_cont_ncorr=-1
				consulta = "select distinct l.cont_ncorr " & vbCrLf &_
				           "from contratos a, compromisos b, detalle_compromisos c, abonos d, ingresos e, detalle_ingresos f, " & vbCrLf &_
						   "     detalle_ingresos g, ingresos h, abonos i, detalle_compromisos j, compromisos k, contratos l " & vbCrLf &_
						   "where a.cont_ncorr = b.comp_ndocto " & vbCrLf &_
						   "  and b.tcom_ccod = c.tcom_ccod " & vbCrLf &_
						   "  and b.inst_ccod = c.inst_ccod " & vbCrLf &_
						   "  and b.comp_ndocto = c.comp_ndocto " & vbCrLf &_
						   "  and c.tcom_ccod = d.tcom_ccod " & vbCrLf &_
						   "  and c.inst_ccod = d.inst_ccod " & vbCrLf &_
						   "  and c.comp_ndocto = d.comp_ndocto " & vbCrLf &_
						   "  and c.dcom_ncompromiso = d.dcom_ncompromiso " & vbCrLf &_
						   "  and d.ingr_ncorr = e.ingr_ncorr " & vbCrLf &_
						   "  and e.ingr_ncorr = f.ingr_ncorr " & vbCrLf &_
						   "  and f.banc_ccod = g.banc_ccod " & vbCrLf &_
						   "  and f.ding_ndocto = g.ding_ndocto " & vbCrLf &_
						   "  and isnull(f.ding_tcuenta_corriente, ' ') = isnull(g.ding_tcuenta_corriente, ' ') " & vbCrLf &_
						   "  and g.ding_ncorrelativo > 0 " & vbCrLf &_
						   "  and f.ding_nsecuencia <> g.ding_nsecuencia " & vbCrLf &_
						   "  and g.ingr_ncorr = h.ingr_ncorr " & vbCrLf &_
						   "  and h.ingr_ncorr = i.ingr_ncorr " & vbCrLf &_
						   "  and i.tcom_ccod = j.tcom_ccod " & vbCrLf &_
						   "  and i.inst_ccod = j.inst_ccod " & vbCrLf &_
						   "  and i.comp_ndocto = j.comp_ndocto " & vbCrLf &_
						   "  and i.dcom_ncompromiso = j.dcom_ncompromiso " & vbCrLf &_
						   "  and j.tcom_ccod = k.tcom_ccod " & vbCrLf &_
						   "  and j.inst_ccod = k.inst_ccod " & vbCrLf &_
						   "  and j.comp_ndocto = k.comp_ndocto " & vbCrLf &_
						   "  and k.comp_ndocto = l.cont_ncorr " & vbCrLf &_
						   "  and e.eing_ccod <> 3 " & vbCrLf &_
						   "  and f.ting_ccod = 3 " & vbCrLf &_
						   "  and g.ting_ccod = 3 " & vbCrLf &_
						   "  and e.eing_ccod in (2, 4) " & vbCrLf &_
						   "  and b.tcom_ccod in (1, 2) " & vbCrLf &_
						   "  and k.tcom_ccod in (1, 2) " & vbCrLf &_
						   "  and a.cont_ncorr = " & v_cont_ncorr & ""
						   
				f_consulta.Inicializar conexion
				f_consulta.Consultar consulta
				
				agregados = false
				while f_consulta.Siguiente
					v_cont_ncorr_hermano = f_consulta.ObtenerValor("cont_ncorr")
					if not d_contratos.Exists(v_cont_ncorr_hermano) then
						d_contratos.Add v_cont_ncorr_hermano, ""
						agregados = true
					end if
				wend
				
				if not agregados then
					listo = true
				end if				
			next
		wend				
		

		Redim arr_contratos(d_contratos.Count - 1)
		i_ = 0
		for each v_contrato in d_contratos.Keys
			arr_contratos(i_) = v_contrato
			i_ = i_ + 1
		next		

		ObtenerContratosHermanos = arr_contratos
	End Function
Function ObtenerMensajeBloqueo(p_pers_nrut, p_peri_ccod)
		Dim v_plec_ccod
		Dim sentencia
		Dim msj_bloqueo
		Dim estado	
			
		msj_bloqueo = ""	
		
		if not EsVacio(p_pers_nrut) then
			sentencia = "exec genera_bloqueos '" & p_pers_nrut  &"', '" & p_peri_ccod & "'"
			estado = conexion.EjecutaS(sentencia)
			
			if not estado then
				msj_bloqueo = msj_bloqueo & "Ha ocurrido un error generando el bloqueo.\n\n"
			end if
			
			msj_bloqueo = msj_bloqueo & conexion.ConsultaUno("select protic.bloqueos_matricula(" & p_pers_nrut & ", " & p_peri_ccod & ", getdate())")				
			'response.Write("select protic.bloqueos_matricula(" & p_pers_nrut & ", " & p_peri_ccod & ", getdate())")
		end if		
		
		ObtenerMensajeBloqueo = msj_bloqueo
	
	End Function	
end class



'---------------------------------------------------------------------------------------------------------------------------
Function EsVacio(p_texto)
	EsVacio = false
	
	if (IsNull(p_texto)) or (IsEmpty(p_texto)) or (p_texto = "") then
		EsVacio = true
	end if
	
End Function

if session("rut_usuario")="10536373" then
%>
<script language="javascript1.1">
//alert("Isabel, debes salir del sistema.... M.Riffo");
</script>
<%
end if
%>
