<%
class CAlumno
	private conexion, matr_ncorr, pers_ncorr, plan_ccod,xs, v_peri_ccod ,v_peri_selec
	Private sql_datos_alumno, sql_carrera_alumno
	Private archivo_xml
	
	sub Inicializa (con, nroMatricula)
		set conexion = con
		matr_ncorr = nroMatricula
		pers_ncorr = conexion.consultaUno ("select pers_ncorr from alumnos where cast(matr_ncorr as varchar) ='" & matr_ncorr & "'")
		plan_ccod = conexion.consultaUno ("select plan_ccod from  alumnos where cast(matr_ncorr as varchar) ='" & matr_ncorr & "'")

		'response.Write("<pre>"&peri_ccod&"</pre>") 
		'response.End()

		archivo_xml = "class_alumno.xml"		
		Me.FormaSql
	end sub
	
	
	Sub Inicializar(p_conexion, p_matr_ncorr)
		Me.Inicializa p_conexion, p_matr_ncorr
	End Sub
	
	Sub InicializarCarreras(p_conexion, p_matr_ncorr, p_peri_ccod, peri_selec)
		v_peri_ccod = p_peri_ccod
		v_peri_selec= peri_selec
		Me.Inicializa p_conexion, p_matr_ncorr
	End Sub
	
	Sub FormaSql
		sql_datos_alumno = "select top 1 protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_completo, " & vbCrLf &_
		                   "       protic.obtener_nombre_carrera(a.ofer_ncorr,'CE') as carrera, " & vbCrLf &_
						   "	   protic.obtener_rut(a.pers_ncorr) as rut, c.sede_tdesc, " & vbCrLf &_
						   " isnull(protic.ANO_INGRESO_CARRERA(a.pers_ncorr,(select protic.obtener_nombre_carrera((select top 1 ofer_ncorr "& vbCrLf &_
						   " From alumnos where matr_ncorr='" & matr_ncorr & "' order by matr_ncorr desc),'CC'))) ,  " & vbCrLf &_
						   " protic.ANO_INGRESO_UNIVERSIDAD(a.pers_ncorr) )as ano_ingreso, case d.econ_ccod when 1 then 'MATRICULADO' when 2 then 'PENDIENTE' else 'NO MATRICULADO' end as estado_matricula,  " & vbCrLf &_
						   " case isnull(e.emat_ccod,0) when 1 then 'ACTIVO' else e.emat_tdesc end  as estado_alumno " & vbCrLf &_
						   " From alumnos a, ofertas_academicas b, sedes c, contratos d, estados_matriculas e  " & vbCrLf &_
						   " Where a.ofer_ncorr = b.ofer_ncorr " & vbCrLf &_
						   "  and b.sede_ccod  = c.sede_ccod " & vbCrLf &_
						   "  and a.matr_ncorr *= d.matr_ncorr " & vbCrLf &_
						   "  and a.emat_ccod  = e.emat_ccod " & vbCrLf &_
						   "  and cast(a.matr_ncorr as varchar) = '" & matr_ncorr & "'" & vbCrLf &_
						   "  order by d.cont_ncorr desc " 
			'response.Write("<pre>"&sql_datos_alumno&"</pre>")			   
			'"  and d.econ_ccod <> 3 " & vbCrLf &_
		sql_carrera_alumno = "select protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_completo, " & vbCrLf &_ 
       					   " protic.obtener_nombre_carrera(a.ofer_ncorr,'CE') as carrera, " & vbCrLf &_ 
						   " protic.obtener_rut(a.pers_ncorr) as rut, c.sede_tdesc,  " & vbCrLf &_
						   " isnull(protic.ANO_INGRESO_CARRERA(a.pers_ncorr,(select protic.obtener_nombre_carrera((select top 1 ofer_ncorr  " & vbCrLf &_
						   " From alumnos where matr_ncorr=a.matr_ncorr order by matr_ncorr desc),'CC'))) ,   " & vbCrLf &_
 						   " protic.ANO_INGRESO_UNIVERSIDAD(a.pers_ncorr) )as ano_ingreso, case d.econ_ccod when 1 then 'MATRICULADO' when 2 then 'PENDIENTE' else 'NO MATRICULADO' end as estado_matricula,   " & vbCrLf &_
						   " case isnull(e.emat_ccod,0) when 1 then 'ACTIVO' else e.emat_tdesc end  as estado_alumno  " & vbCrLf &_
						   " From alumnos a, ofertas_academicas b, sedes c, contratos d, estados_matriculas e   " & vbCrLf &_
						   " Where a.ofer_ncorr = b.ofer_ncorr  " & vbCrLf &_
						   " and b.sede_ccod  = c.sede_ccod  " & vbCrLf &_
						   "  and a.matr_ncorr *= d.matr_ncorr  " & vbCrLf &_
						   " and d.econ_ccod<>3 " & vbCrLf &_
						   "  and a.emat_ccod  = e.emat_ccod  " & vbCrLf &_
							"  and cast(a.pers_ncorr as varchar)= '" & pers_ncorr & "' "& vbCrLf &_
							"  and cast(b.peri_ccod as varchar) = '" & v_peri_ccod & "' " & vbCrLf &_
							"  order by d.cont_ncorr desc "
							'response.Write("<pre>"&sql_carrera_alumno&"</pre>") 
							'response.Write("<pre>Periodo :"&peri_ccod&"</pre>") 
							'response.End()
							
		sql_carrera_alumno = "select * from (select protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_completo, " & vbCrLf &_
							 " protic.obtener_nombre_carrera(a.ofer_ncorr,'CE') as carrera, " & vbCrLf &_
							 " protic.obtener_rut(a.pers_ncorr) as rut, c.sede_tdesc,  " & vbCrLf &_
							 " isnull(protic.ANO_INGRESO_CARRERA(a.pers_ncorr,(select protic.obtener_nombre_carrera((select top 1 ofer_ncorr  " & vbCrLf &_
							 " From alumnos where matr_ncorr=a.matr_ncorr ),'CC'))) , protic.ANO_INGRESO_UNIVERSIDAD(a.pers_ncorr) )as ano_ingreso, " & vbCrLf &_
							 " case when protic.tiene_contrato_periodo("&v_peri_selec&",a.pers_ncorr)>=1 then 'MATRICULADO' else 'NO MATRICULADO' end as estado_matricula, " & vbCrLf &_
							 " --case d.econ_ccod when 1 then 'MATRICULADO' when 2 then 'PENDIENTE' else 'NO MATRICULADO' end as estado_matricula,   " & vbCrLf &_
							 " case isnull(e.emat_ccod,0) when 1 then 'ACTIVO' else e.emat_tdesc end  as estado_alumno,protic.ANO_INGRESO_UNIVERSIDAD(a.pers_ncorr) as ingreso_u , " & vbCrLf &_
							 " (select peri_tdesc from periodos_academicos where peri_ccod='"&v_peri_selec&"' ) as peri_tdesc "& vbCrLf &_
							 " From alumnos a, ofertas_academicas b, sedes c, contratos d, estados_matriculas e   " & vbCrLf &_
							 " Where a.ofer_ncorr = b.ofer_ncorr  " & vbCrLf &_
							 "  and b.sede_ccod  = c.sede_ccod  " & vbCrLf &_
							 "  and a.matr_ncorr *= d.matr_ncorr  " & vbCrLf &_
							 "  and d.econ_ccod<>3 " & vbCrLf &_
							 "  and a.emat_ccod  = e.emat_ccod " & vbCrLf &_ 
							 "  and cast(a.pers_ncorr as varchar)= '" & pers_ncorr & "' " & vbCrLf &_
							 "  and b.peri_ccod = '" & v_peri_ccod & "' " & vbCrLf &_
							 "  and a.emat_ccod<>9) as tabla" & vbCrLf &_
							 " union " & vbCrLf &_
							 " select * from (" & vbCrLf &_
							 " select protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_completo, " & vbCrLf &_
							 " protic.obtener_nombre_carrera(a.ofer_ncorr,'CE') as carrera, " & vbCrLf &_
							 " protic.obtener_rut(a.pers_ncorr) as rut, c.sede_tdesc,  " & vbCrLf &_
							 " isnull(protic.ANO_INGRESO_CARRERA(a.pers_ncorr,(select protic.obtener_nombre_carrera((select top 1 ofer_ncorr  " & vbCrLf &_
							 " From alumnos where matr_ncorr=a.matr_ncorr ),'CC'))) , protic.ANO_INGRESO_UNIVERSIDAD(a.pers_ncorr) )as ano_ingreso, " & vbCrLf &_
							 " case when protic.tiene_contrato_periodo("&v_peri_selec&",a.pers_ncorr)>=1 then 'MATRICULADO' else 'NO MATRICULADO' end as estado_matricula, " & vbCrLf &_
							 " --case d.econ_ccod when 1 then 'MATRICULADO' when 2 then 'PENDIENTE' else 'NO MATRICULADO' end as estado_matricula,   " & vbCrLf &_
							 " case isnull(e.emat_ccod,0) when 1 then 'ACTIVO' else e.emat_tdesc end  as estado_alumno,protic.ANO_INGRESO_UNIVERSIDAD(a.pers_ncorr) as ingreso_u,  " & vbCrLf &_
							 " (select peri_tdesc from periodos_academicos where peri_ccod='"&v_peri_selec&"' ) as peri_tdesc "& vbCrLf &_
							 " From alumnos a, ofertas_academicas b, sedes c, contratos d, estados_matriculas e   " & vbCrLf &_
							 " Where a.ofer_ncorr = b.ofer_ncorr  " & vbCrLf &_
							 "  and b.sede_ccod  = c.sede_ccod  " & vbCrLf &_
							 "  and a.matr_ncorr = d.matr_ncorr  " & vbCrLf &_
							 "  and d.econ_ccod<>3 " & vbCrLf &_
							 "  and a.emat_ccod  = e.emat_ccod  " & vbCrLf &_
							 "  and cast(a.pers_ncorr as varchar)= '" & pers_ncorr & "' " & vbCrLf &_
							 "  and b.peri_ccod = " & v_peri_ccod & " ) as tabla  " & vbCrLf &_
							 " union  " & vbCrLf &_
 							 " select * from (  " & vbCrLf &_
              				 " select top 1 protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_completo,  " & vbCrLf &_
							 " linea_1_certificado + ' ' + linea_2_certificado as carrera,  " & vbCrLf &_
							 " protic.obtener_rut(a.pers_ncorr) as rut, null as sede_tdesc,   " & vbCrLf &_
						     " isnull(protic.ANO_INGRESO_CARRERA(a.pers_ncorr,e.carr_ccod), protic.ANO_INGRESO_UNIVERSIDAD(a.pers_ncorr) )as ano_ingreso,  " & vbCrLf &_
							 " case when protic.tiene_contrato_periodo( " & v_peri_ccod & ",a.pers_ncorr)>=1 then 'MATRICULADO' else 'NO MATRICULADO' end as estado_matricula,  " & vbCrLf &_
							 " case isnull(a.emat_ccod,0) when 1 then 'ACTIVO' else c.emat_tdesc end  as estado_alumno, protic.ANO_INGRESO_UNIVERSIDAD(a.pers_ncorr) as ingreso_u,  " & vbCrLf &_
							 " d.peri_tdesc as peri_tdesc   " & vbCrLf &_
							 " from alumnos_salidas_intermedias a, salidas_carrera b,estados_matriculas c,periodos_academicos d, carreras e  " & vbCrLf &_
							 " where cast(a.pers_ncorr as varchar)='"& pers_ncorr &"' and a.saca_ncorr=b.saca_ncorr    " & vbCrLf &_
							 " and a.emat_ccod=c.emat_ccod  and a.peri_ccod = d.peri_ccod and b.carr_ccod=e.carr_ccod   " & vbCrLf &_
							 " order by a.emat_ccod desc  " & vbCrLf &_
							 " )as tabla "				
			'response.Write("<pre>"&sql_carrera_alumno&"</pre>") 
	End Sub
	
	
	Function ObtenerSql(p_tipo)
		Dim sql
		
		sql = ""
		
		select case UCase(p_tipo)
			case "INFORMACION_ALUMNO"
				sql = sql_datos_alumno
			case "CARRERAS_ALUMNO"
				sql = sql_carrera_alumno
		end select
		
		ObtenerSql = sql
	End Function
	
	Sub DibujaDatos
		Dim formulario
		
		set formulario = new CFormulario
		formulario.Carga_Parametros archivo_xml, "datos_alumno"
		formulario.Inicializar conexion
		'formulario.Consultar Me.ObtenerSql("INFORMACION_ALUMNO")
		
		if	not EsVacio(v_peri_ccod) then
			formulario.agregacampoParam "carrera", "permiso","OCULTO"
			formulario.agregacampoParam "sede_tdesc", "permiso","OCULTO"
			formulario.agregacampoParam "ano_ingreso", "permiso","OCULTO"
			formulario.agregacampoParam "estado_matricula", "permiso","OCULTO"
			formulario.agregacampoParam "estado_alumno", "permiso","OCULTO"
			formulario.agregacampoParam "ingreso_u", "permiso","OCULTO"
		end if
		formulario.Consultar Me.ObtenerSql("INFORMACION_ALUMNO")
		formulario.DibujaRegistro
		
		set formulario = Nothing
		
	End Sub
	
	Sub DibujaDatos2
		Dim formulario2
		
		set formulario2 = new CFormulario
		formulario2.Carga_Parametros archivo_xml, "carreras_alumno"
		formulario2.Inicializar conexion
		formulario2.Consultar Me.ObtenerSql("CARRERAS_ALUMNO")
		
		formulario2.DibujaTabla
		
		set formulario2 = Nothing
	End Sub
	
	function obtenerPersNcorr
		obtenerPersNcorr = pers_ncorr
	end function
	
	function obtenerPlanCcod
		obtenerPlanCcod = plan_ccod
	end function
	
	sub construyeSituacionAsignaturas

		situacion_asignaturas_sql = "" & _ 
			" SELECT nive_ccod, isnull(a.asig_ccod,'P ' + cast(b.asig_ccod as varchar)) as asignatura " & vbCrLf  & _
			"  FROM (SELECT DISTINCT asig_ccod " & vbCrLf  & _
			"          FROM secciones a, cargas_academicas b, alumnos c, situaciones_finales d " & vbCrLf  & _
			"         WHERE a.secc_ccod = b.secc_ccod " & vbCrLf  & _
			"           AND b.matr_ncorr = c.matr_ncorr " & vbCrLf  & _
			"           and b.sitf_ccod=d.sitf_ccod " & vbCrLf  & _
			"           and d.sitf_baprueba = 'S' " & vbCrLf  & _
			"           and cast(c.pers_ncorr as varchar) = '" & pers_ncorr & "' " & vbCrLf  & _
			"		  UNION  " & vbCrLf  & _
			"		select distinct asig_ccod " & vbCrLf  & _
			"          FROM convalidaciones a, alumnos b, situaciones_finales c " & vbCrLf  & _
			"         WHERE a.matr_ncorr = b.matr_ncorr " & vbCrLf  & _
			"           and a.sitf_ccod=c.sitf_ccod " & vbCrLf  & _
			"           and c.sitf_baprueba = 'S' " & vbCrLf  & _
			"           and cast(b.pers_ncorr as varchar) = '" & pers_ncorr & "' " & vbCrLf  & _
			"		) a, malla_curricular b " & vbCrLf  & _
			" WHERE a.asig_ccod  =* b.asig_ccod " & vbCrLf  & _
			"   AND cast(b.plan_ccod as varchar) = '" & plan_ccod & "' " & vbCrLf  & _
			"order by nive_ccod  " & vbCrLf  
		'response.Write("<pre>"&situacion_asignaturas_sql&"</pre>")
		'response.End()	
		conexion.ejecuta situacion_asignaturas_sql
		set situacion_asignaturas_res = conexion.obtenerRegistros
		set xs = createObject("Scripting.Dictionary")
		item_pivote = "NIVE_CCOD"
		
		for each sxi in situacion_asignaturas_res.Item("filas").Items
			if not xs.exists(sxi.Item(item_pivote)) then
				xs.Add sxi.Item(item_pivote), createObject("Scripting.Dictionary")
			end if
			for each xsii in sxi.keys
				if not xs.item(sxi.Item(item_pivote)).exists(xsii) then
					xs.item(sxi.Item(item_pivote)).Add xsii, createObject("Scripting.Dictionary")
				end if
								xs.item(sxi.Item(item_pivote)).item(xsii).Add xs.item(sxi.Item(item_pivote)).item(xsii).count, sxi.Item(xsii)
			next
		next
	end sub
	
	sub dibujaSituacionAsignaturas
		s = "" & _
			" <table border=1 width=""100%"" cellspacing=""0"" cellpadding=""0""  bordercolor='#9bb4e6' bgcolor='#F1F1E4'> " & vbCrLf  & _
			" 	<tr bgcolor='#A0C0EB'> " & vbCrLf  
		for each x in xs.keys
			s = s & _
				" 	<th> " & vbCrLf  & _
				x & _
				" </th> " & vbCrLf  			
		next
		s = s & _
			" 	</tr> " & vbCrLf & _	
			" 	<tr> " & vbCrLf 	
		for each xz in xs.Items
			s = s & _
				" 	  <td align=""right"" valign=""top""> " & vbCrLf  
			for each xzs in xz.item("ASIGNATURA").Items
				s = s & xzs & "<br>" & vbCrLf  
			next
			s = s & _
				" 	  </td> " & vbCrLf  
		next
		s = s & _
			" 	</tr> " & vbCrLf  & _
			" </table> " & vbCrLf  
	   response.write s			
	end sub	
		
End class
%>