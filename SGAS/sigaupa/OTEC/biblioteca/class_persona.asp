<%
Class CPersona
	Private conexion, v_pers_nrut
	Private archivo_xml
	Private v_pers_ncorr
	Private formulario
	
	Sub Inicializar(p_conexion, p_pers_nrut)
		set conexion = p_conexion
		v_pers_nrut = p_pers_nrut
		
		v_pers_ncorr = conexion.ConsultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='" & v_pers_nrut & "'")
		archivo_xml = "class_persona.xml"
	End Sub
	
	Function ObtenerPostNcorr(p_peri_ccod)
		'Buscar el post_ncorr dado el periodo
		Dim consulta
		
		consulta = "select b.post_ncorr " & vbCrLf &_
		           "from personas_postulante a, postulantes b " & vbCrLf &_
				   "where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
				   "  and b.peri_ccod = '" & p_peri_ccod & "' " & vbCrLf &_
				   "  and cast(a.pers_nrut as varchar)= '" & v_pers_nrut & "'"
				   
		ObtenerPostNcorr = conexion.ConsultaUno(consulta)				   
				   
	End Function
	
	Function ObtenerMatrNcorr(p_peri_ccod)
		'Buscar la matrícula activa dado el periodo
		Dim consulta
		
		consulta = "select b.matr_ncorr " & vbCrLf &_
		           "from personas a, alumnos b, ofertas_academicas c " & vbCrLf &_
				   "where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
				   "  and b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
				   "  and b.emat_ccod = 1 " & vbCrLf &_
				   "  and cast(c.peri_ccod as varchar) = '" & p_peri_ccod & "'" & vbCrLf &_
				   "  and cast(a.pers_nrut as varchar) = '" & v_pers_nrut & "'"
				   
		'response.Write("<pre>"&consulta&"</pre>")		   
		'response.End
		ObtenerMatrNcorr = conexion.ConsultaUno(consulta)				   
	End Function
	
	Function ObtenerMatriculaPeriodo(p_peri_ccod)
		'Buscar la matrícula activa dado el periodo
		Dim consulta
		
		consulta = "select b.matr_ncorr " & vbCrLf &_
		           "from personas a, alumnos b, ofertas_academicas c " & vbCrLf &_
				   "where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
				   "  and b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
				   "  and cast(c.peri_ccod as varchar) = '" & p_peri_ccod & "'" & vbCrLf &_
				   "  and cast(a.pers_nrut as varchar) = '" & v_pers_nrut & "'" & vbCrLf &_
				   " and emat_ccod <> 9 "& vbCrLf &_
				   " order by b.matr_ncorr desc "
				   
		'response.Write("<pre>"&consulta&"</pre>")		   
		'response.End
		ObtenerMatriculaPeriodo = conexion.ConsultaUno(consulta)				   
	End Function
	
	Function ObtenerPersNCorr
		ObtenerPersNCorr = v_pers_ncorr
	End Function
	
	
	Function ObtenerUltimoPeriodoMatriculado
	End Function	
	
	
	Sub DibujaDatos
		set formulario = new CFormulario
		formulario.Carga_Parametros archivo_xml, "datos_persona"
		formulario.Inicializar conexion
		'if EsVacio(v_pers_ncorr) then
		'		rut=""
		'		nombre_completo=""
		'		formulario.Consultar "select ''"
		'		formulario.agregacampopost "rut", rut
		'		formulario.agregacampopost "nombre_completo", nombre_completo
		'		formulario.DibujaRegistro
		'else
		'consulta = "select cast(protic.obtener_rut('" & v_pers_ncorr & "') as varchar) as rut, cast(protic.obtener_nombre_completo('" & v_pers_ncorr & "','n') as varchar) as nombre_completo from personas where cast(pers_ncorr as varchar)= '" & v_pers_ncorr & "'"
		'consulta = "select cast(protic.obtener_rut('1') as varchar) as rut, cast(protic.obtener_nombre_completo('1','n') as varchar) as nombre_completo from personas where pers_ncorr = '1'"		
		consulta2 =  " Select cast(pers_tnombre +' '+ pers_tape_paterno +' '+ pers_tape_materno as varchar) as nombre_completo," & vbCrLf &_
					" cast(pers_nrut as varchar)+'-'+cast(pers_xdv as varchar) as rut, " & vbCrLf &_
					" protic.ANO_INGRESO_UNIVERSIDAD(pers_ncorr) as ano_ingreso, 'No Matriculado' as estado_matricula, " & vbCrLf &_
					"        (select case b.emat_ccod when 1 then 'ACTIVO' else b.emat_tdesc end  from alumnos a , estados_matriculas b  " & vbCrLf &_
					" where a.matr_ncorr in (select max(matr_ncorr) from alumnos where cast(pers_ncorr as varchar)='" & v_pers_ncorr & "') " & vbCrLf &_
					"	and a.emat_ccod=b.emat_ccod " & vbCrLf &_
					" ) AS estado_alumno " & vbCrLf &_
					" From personas Where cast(pers_ncorr as varchar)= '" & v_pers_ncorr & "'"
					'response.Write("<pre>"&consulta&"</pre>")
					'response.End()
		
		consulta=    " Select top 1 a.pers_ncorr, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_completo,  " & vbCrLf &_
					  " protic.obtener_rut(a.pers_ncorr) as rut,ISNULL(max(c.sede_tdesc),(select sede_tdesc from sedes where sede_ccod in (select sede_ccod from ofertas_academicas where ofer_ncorr in (protic.ultima_oferta_matriculado(a.pers_ncorr))))) as sede_tdesc,  " & vbCrLf &_
					  " protic.obtener_nombre_carrera(protic.ultima_oferta_matriculado(a.pers_ncorr),'CE') as carrera, " & vbCrLf &_
                      " isnull(protic.ANO_INGRESO_CARRERA(a.pers_ncorr,protic.obtener_nombre_carrera(protic.ultima_oferta_matriculado(a.pers_ncorr),'CC')),protic.ANO_INGRESO_UNIVERSIDAD(a.pers_ncorr)) as ano_ingreso,  " & vbCrLf &_
                      " isnull((select upper(ec.econ_tdesc) from contratos co, estados_contrato ec where post_ncorr in (d.post_ncorr)and co.econ_ccod=ec.econ_ccod and co.cont_ncorr in (select max(cont_ncorr) from contratos where post_ncorr in (d.post_ncorr))),'NO MATRICULADO') as estado_matricula," & vbCrLf &_
                      " (select case b.emat_ccod when 1 then 'ACTIVO' else b.emat_tdesc end  from alumnos a , estados_matriculas b  " & vbCrLf &_
					  " Where a.matr_ncorr in (select max(matr_ncorr) from alumnos where cast(pers_ncorr as varchar)='" & v_pers_ncorr & "')  " & vbCrLf &_
					  "   and a.emat_ccod=b.emat_ccod  " & vbCrLf &_
					  " ) as estado_alumno  " & vbCrLf &_
					  " From  personas a  " & vbCrLf &_
                      "       left outer join  alumnos d " & vbCrLf &_
                      "           on a.pers_ncorr=d.pers_ncorr  " & vbCrLf &_
					  " 				and d.emat_ccod <>9  " & vbCrLf &_
                      "        left outer join  ofertas_academicas b  " & vbCrLf &_
                      "           on protic.ultima_oferta_matriculado(a.pers_ncorr) = b.ofer_ncorr  " & vbCrLf &_
                      "           and d.ofer_ncorr=b.ofer_ncorr  " & vbCrLf &_
                      "       left outer join sedes c   " & vbCrLf &_
                      "          on b.sede_ccod=c.sede_ccod  " & vbCrLf &_
					  " where  cast(a.pers_ncorr as varchar) = '" & v_pers_ncorr & "'  " & vbCrLf &_
					  " Group by a.pers_ncorr ,d.post_ncorr ,b.peri_ccod order by b.peri_ccod desc" 
		'response.Write("<pre>"&consulta&"</pre>")
		formulario.Consultar consulta
		formulario.DibujaRegistro
		'end if
		
		
		set formulario = Nothing
	End Sub
	
End Class
%>