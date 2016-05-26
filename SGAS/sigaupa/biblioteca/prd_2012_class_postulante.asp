<%
Class CPostulante
	Private v_pers_ncorr, v_post_ncorr, v_ofer_ncorr
	Private conexion	
	Private sql_informacion_postulante, sql_tabla_valores
	Private archivo_xml
	
	Sub Inicializar(p_conexion, p_post_ncorr)
		set conexion = p_conexion
		v_post_ncorr = p_post_ncorr		
		v_pers_ncorr = conexion.ConsultaUno("select pers_ncorr from postulantes where cast(post_ncorr as varchar) = '" & p_post_ncorr & "'")
		v_ofer_ncorr = conexion.ConsultaUno("select ofer_ncorr from postulantes where cast(post_ncorr as varchar) = '" & p_post_ncorr & "'")
		
		archivo_xml = "class_postulante.xml"
		
		Me.FormaSql
	End Sub
	
	Sub FormaSql
		sql_informacion_postulante = " select  "  & vbCrLf &_
			"(protic.ano_ingreso_carrera(a.pers_ncorr,d.carr_ccod)) as ano_ingreso ," & vbCrLf &_
				"(select j.DIRE_TCALLE + ' ' + j.DIRE_TNRO + '  (' + k.CIUD_TDESC + ')' "  & vbCrLf &_
				" from direcciones_publica j,ciudades k "  & vbCrLf &_
				" where j.ciud_ccod = k.ciud_ccod "  & vbCrLf &_
				" and j.pers_ncorr = a.pers_ncorr "  & vbCrLf &_
				" and j.tdir_ccod = 1)  as direccion,  "  & vbCrLf &_
				" (select  k.CIUD_TDESC "  & vbCrLf &_
				" from direcciones_publica j,ciudades k "  & vbCrLf &_
				" where j.ciud_ccod = k.ciud_ccod "  & vbCrLf &_
				" and j.pers_ncorr = a.pers_ncorr "  & vbCrLf &_
				" and j.tdir_ccod = 1) AS CIUD_TDESC , "  & vbCrLf &_
				" (select n.DIRE_TCALLE + ' ' + n.DIRE_TNRO + '  (' + o.CIUD_TDESC + ')' "  & vbCrLf &_
				" from direcciones_publica n ,ciudades o "  & vbCrLf &_
				" where n.ciud_ccod = o.ciud_ccod "  & vbCrLf &_
				" and n.pers_ncorr = m.pers_ncorr "  & vbCrLf &_
				" and n.tdir_ccod = 1)  as direccion_codeudor , "  & vbCrLf &_
		" m.pers_tnombre + ' ' + m.pers_tape_paterno + ' ' + m.pers_tape_materno as nombre_codeudor, m.pers_tfono as pers_tfono_codeudor, "  & vbCrLf &_
		" a.pers_ncorr, b.post_ncorr, cast(a.pers_nrut as varchar(10))  + ' - ' + a.pers_xdv as rut, a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre_completo, a.pers_nrut, a.pers_xdv, "  & vbCrLf &_
		" protic.obtener_nombre_carrera(c.ofer_ncorr, 'CE') as carrera,convert(datetime,getdate(),103) as fecha_actual,  g.sede_tdesc,  "  & vbCrLf &_
		" f.aran_mmatricula, f.aran_mcolegiatura, i.stpa_ccod,p.jorn_tdesc, "  & vbCrLf &_
		" isnull(f.aran_mmatricula, 0) + isnull(f.aran_mcolegiatura, 0) as subtotal, "  & vbCrLf &_
		" sum(isnull(h.sdes_mmatricula, 0) + isnull(h.sdes_mcolegiatura, 0)) as total_descuentos, "  & vbCrLf &_
		" isnull(f.aran_mmatricula, 0) + isnull(f.aran_mcolegiatura, 0) - sum(isnull(h.sdes_mmatricula, 0) + isnull(h.sdes_mcolegiatura, 0)) as total, "  & vbCrLf &_
		" case h.esde_ccod  "  & vbCrLf &_
		" 	   when 1 then sum(isnull(h.sdes_mmatricula,0)+isnull(h.sdes_mcolegiatura, 0)) "  & vbCrLf &_
		"  	   else 0 "  & vbCrLf &_
		" end as total_descuentos_autorizados, "  & vbCrLf &_
		" case h.esde_ccod  "  & vbCrLf &_
		"  	  when 1 then isnull(f.aran_mmatricula, 0) + isnull(f.aran_mcolegiatura, 0) - sum(isnull(h.sdes_mmatricula,0)+isnull(h.sdes_mcolegiatura, 0)) "  & vbCrLf &_
		"	   else  isnull(f.aran_mmatricula, 0) + isnull(f.aran_mcolegiatura, 0)-0 "  & vbCrLf &_
		" end as total_pagar, "  & vbCrLf &_
		" case h.esde_ccod  "  & vbCrLf &_
		"	   when 1 then isnull(f.aran_mmatricula, 0) - isnull(h.sdes_mmatricula, 0) "  & vbCrLf &_
		"	   else  isnull(f.aran_mmatricula, 0) - 0 "  & vbCrLf &_
		" end as total_pagar_matricula, "  & vbCrLf &_
		" case h.esde_ccod  "  & vbCrLf &_
		"	   when 1 then isnull(f.aran_mcolegiatura, 0) - isnull(h.sdes_mcolegiatura, 0) "  & vbCrLf &_
		" 	   else  isnull(f.aran_mcolegiatura, 0) - 0 "  & vbCrLf &_
		" end as total_pagar_colegiatura "  & vbCrLf &_
		" from personas_postulante a,postulantes b, "  & vbCrLf &_
		" ofertas_academicas c,especialidades d,carreras e, aranceles f,sedes g, "  & vbCrLf &_
		" sdescuentos h, spagos i,codeudor_postulacion l,personas_postulante m,jornadas p "  & vbCrLf &_
		" where a.pers_ncorr = b.pers_ncorr "  & vbCrLf &_
		" and b.ofer_ncorr = c.ofer_ncorr "  & vbCrLf &_
		" and c.espe_ccod = d.espe_ccod "  & vbCrLf &_
		" and d.carr_ccod = e.carr_ccod "  & vbCrLf &_
		" and c.ofer_ncorr = f.ofer_ncorr "  & vbCrLf &_
		" and c.sede_ccod = g.sede_ccod "  & vbCrLf &_
		" and b.post_ncorr *= h.post_ncorr   "  & vbCrLf &_
		" and b.ofer_ncorr *= h.ofer_ncorr   "  & vbCrLf &_
		" and b.post_ncorr *= i.post_ncorr   "  & vbCrLf &_
		" and b.ofer_ncorr *= i.ofer_ncorr   "  & vbCrLf &_
		" and b.post_ncorr = l.post_ncorr  "  & vbCrLf &_
		" and l.pers_ncorr = m.pers_ncorr "  & vbCrLf &_
		" and c.jorn_ccod = p.jorn_ccod "  & vbCrLf &_
		" and b.tpos_ccod in (1,2)  "  & vbCrLf &_
		" and b.epos_ccod = 2  "  & vbCrLf &_
		" and cast(b.post_ncorr as varchar)= '"&v_post_ncorr&"'"  & vbCrLf &_
		" group by a.pers_ncorr, b.post_ncorr, a.pers_nrut, a.pers_xdv, a.pers_tnombre, a.pers_tape_paterno, a.pers_tape_materno, "  & vbCrLf &_
		" m.pers_tnombre, m.pers_tape_paterno, m.pers_tape_materno,m.pers_tfono,m.pers_ncorr,f.aran_mmatricula, "  & vbCrLf &_
		"f.aran_mcolegiatura, i.stpa_ccod, c.ofer_ncorr, p.jorn_tdesc, g.sede_tdesc,h.esde_ccod,sdes_mmatricula,h.sdes_mcolegiatura,d.carr_ccod "  
		
		'response.Write("<pre>"&sql_informacion_postulante&"</pre>")

							
sql_tabla_valores = "select b.tipo, b.ttipo, " & vbCrLf &_
					"       case b.tipo when 1 then a.aran_mmatricula when 2 then -a.desc_matricula end as matricula," & vbCrLf &_
					"       case b.tipo when 1 then a.aran_mcolegiatura when 2 then -a.desc_colegiatura end as arancel," & vbCrLf &_
					"       case b.tipo when 1 then a.total_arancel when 2 then -a.total_descuentos end as total, " & vbCrLf &_
					"       case b.tipo when 1 then a.aran_mmatricula when 2 then -a.desc_matricula end as c_matricula, " & vbCrLf &_
					"	   case b.tipo when 1 then a.aran_mcolegiatura when 2 then -a.desc_colegiatura end as c_arancel, " & vbCrLf &_
					"	   case b.tipo when 1 then a.total_arancel when 2 then -a.total_descuentos end as c_total " & vbCrLf &_
					"from      " & vbCrLf &_
					"(select b.post_ncorr, b.ofer_ncorr,d.aran_mmatricula, d.aran_mcolegiatura," & vbCrLf &_
					"     d.aran_mmatricula + d.aran_mcolegiatura as total_arancel," & vbCrLf &_
					"     sum(isnull(f.sdes_mmatricula, 0)) as desc_matricula, sum(isnull(f.sdes_mcolegiatura, 0)) as desc_colegiatura," & vbCrLf &_
					"     sum(isnull(f.sdes_mmatricula, 0)) + sum(isnull(f.sdes_mcolegiatura, 0)) as total_descuentos" & vbCrLf &_
					"    from personas_postulante a,postulantes b,ofertas_academicas c,aranceles d," & vbCrLf &_
					"        spagos e,sdescuentos f" & vbCrLf &_
					"    where a.pers_ncorr = b.pers_ncorr      " & vbCrLf &_
					"        and b.ofer_ncorr = c.ofer_ncorr" & vbCrLf &_
					"        and c.aran_ncorr = d.aran_ncorr" & vbCrLf &_
					"        and b.post_ncorr *= e.post_ncorr" & vbCrLf &_
					"        and b.ofer_ncorr *= e.ofer_ncorr" & vbCrLf &_
					"        and b.post_ncorr *= f.post_ncorr" & vbCrLf &_
					"        and b.ofer_ncorr *= f.ofer_ncorr" & vbCrLf &_
					"        and f.esde_ccod  = 1" & vbCrLf &_
					"        and cast(b.post_ncorr as varchar)= '" & v_post_ncorr & "' " & vbCrLf &_
					"    group by b.post_ncorr, b.ofer_ncorr, d.aran_mmatricula, d.aran_mcolegiatura ) a," & vbCrLf &_
					" (select 1 as tipo, 'ARANCELES DE CARRERA' as ttipo union " & vbCrLf &_
					"	      select 2 as tipo, 'DESCUENTOS Y CRÉDITOS AUTORIZADOS' as ttipo) b " & vbCrLf &_
					"order by b.tipo asc"
			'response.Write("<pre>"&sql_tabla_valores&"</pre>")						
	End Sub
	
	
	Function ObtenerSql(p_tipo)
		Dim sql
		
		sql = ""		
		select case UCase(p_tipo)
			case "INFORMACION_POSTULANTE"
				sql = sql_informacion_postulante
			case "TABLA_VALORES"
				sql = sql_tabla_valores 
		end select
		
		ObtenerSql = sql
	End Function	

	
	Sub DibujaDatos
		Dim formulario
		Dim salida
		Dim botonera
		
		set formulario = new CFormulario
		formulario.Carga_Parametros archivo_xml, "datos_postulante"
		formulario.Inicializar conexion		
		formulario.Consultar Me.ObtenerSql("INFORMACION_POSTULANTE")
		formulario.DibujaRegistro		
		set formulario = Nothing
		

		if Me.EnvioPostulacion then						
			set botonera = new CFormulario
			botonera.Carga_Parametros archivo_xml, "botonera"
					
			salida = "<table width=""100%""  border=""0"" align=""center"" cellpadding=""0"" cellspacing=""0"">" & vbCrLf &_
					 "  <tr><td><div align='right'>" & vbCrLf 
					 
			Response.Write(salida)
			salida = ""
			
			botonera.AgregaBotonUrlParam "cambiar_info_codeudor", "post_ncorr", v_post_ncorr
			if Me.EstaMatriculado then
				botonera.AgregaBotonParam "cambiar_info_codeudor", "deshabilitado", "TRUE"
			end if		
			botonera.DibujaBoton "cambiar_info_codeudor"
			
			salida = "  </div></td></tr>" & vbCrLf &_
					 "</table>"				 
			response.Write(salida)
			set botonera = Nothing
		end if

	End Sub
	
	
	Sub DibujaTablaValores
		Dim formulario
		
		set formulario = new CFormulario
		formulario.Carga_Parametros archivo_xml, "tabla_valores"
		formulario.Inicializar conexion
		formulario.Consultar Me.ObtenerSql("TABLA_VALORES")
		formulario.DibujaTabla
		
		set formulario = Nothing
	End Sub
	
	
	Function ObtenerPersNCorr
		ObtenerPersNCorr = v_pers_ncorr
	End Function
	
	
	Function EnvioPostulacion
		Dim npostulaciones_enviadas
		
		npostulaciones_enviadas = CInt(conexion.ConsultaUno("select count(*) from postulantes where cast(post_ncorr  as varchar)= '" & v_post_ncorr & "' and epos_ccod = 2"))
		
		if npostulaciones_enviadas > 0 then
			EnvioPostulacion = True
		else
			EnvioPostulacion = False
		end if
		
	End Function
	
	
	Function TieneContratoGenerado
		Dim consulta, ncontratos
		
		ncontratos = CInt(conexion.ConsultaUno("select count(*) from contratos where cast(post_ncorr as varchar) = '" & v_post_ncorr & "' and econ_ccod <> 3"))
		
		if ncontratos > 0 then
			TieneContratoGenerado = True
		else
			TieneContratoGenerado = False
		end if				
	End Function
		
	
	Function EstaMatriculado
		Dim consulta, nmatriculas		
		
		nmatriculas = CInt(conexion.ConsultaUno("select count(*) from alumnos where post_ncorr = '" & v_post_ncorr & "' and emat_ccod = 1"))
		
		if nmatriculas > 0 then
			EstaMatriculado = True
		else
			EstaMatriculado = False
		end if
	End Function
	
		
End Class
%>