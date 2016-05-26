<%
Class CCajero
	Private v_pers_ncorr, v_caje_ccod, v_sede_ccod
	Private b_es_cajero
	Private conexion
	Private sql_caja
	Private archivo_xml
	Private v_tcaj_ccod

	Sub Inicializar(p_conexion, p_pers_nrut, p_sede_ccod)
		Dim registros

		set conexion = p_conexion
		v_sede_ccod = p_sede_ccod

		consulta = "select rtrim(ltrim(b.caje_ccod)) as caje_ccod, b.sede_ccod, b.pers_ncorr, b.caje_cestado " & vbCrLf &_
		           "from personas a, cajeros b " & vbCrLf &_
				   "where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
				   "  and b.caje_cestado = 1 " & vbCrLf &_
				   "  and b.sede_ccod = '" & v_sede_ccod & "'" & vbCrLf &_
				   "  and cast(a.pers_nrut as varchar)= '" & p_pers_nrut & "'"
		'response.Write("<pre>"&consulta&"</pre>")
		'response.end
		conexion.Ejecuta consulta
		set registros = conexion.ObtenerRegistros

		if registros.Item("filas").Count > 0 then
			b_es_cajero = true
			v_caje_ccod = registros.Item("filas").Item(0).Item("CAJE_CCOD")
			v_sede_ccod = registros.Item("filas").Item(0).Item("SEDE_CCOD")
			v_pers_ncorr = registros.Item("filas").Item(0).Item("PERS_NCORR")
		else
			b_es_cajero = false
		end if

		archivo_xml = "class_cajero.xml"

		v_tcaj_ccod = "1000"

		Me.FormaSql
	End Sub


	Sub AsignarTipoCaja(p_tcaj_ccod)
		v_tcaj_ccod = p_tcaj_ccod
		Me.FormaSql
	End Sub


	Function EsCajeroSede
		EsCajeroSede = b_es_cajero
	End Function


	Sub FormaSql
		sql_caja = "select a.mcaj_ncorr, convert(varchar,a.mcaj_finicio,103) as mcaj_finicio, a.tcaj_ccod " & vbCrLf &_
				   "from movimientos_cajas a, cajeros b " & vbCrLf &_
				   "where a.caje_ccod = b.caje_ccod " & vbCrLf &_
				   "  and a.sede_ccod = b.sede_ccod " & vbCrLf &_
				   "  and a.eren_ccod = 1 " & vbCrLf &_
				   "  and convert(varchar,a.mcaj_finicio,103) = convert(varchar,getdate(),103)" & vbCrLf &_
				   "  and cast(a.tcaj_ccod as varchar) = '" & v_tcaj_ccod & "'" & vbCrLf &_
				   "  and cast(b.caje_ccod as varchar) = '" & v_caje_ccod & "'" & vbCrLf &_
				   "  and cast(b.sede_ccod as varchar) = '" & v_sede_ccod & "'"
		'response.Write("<pre>"&sql_caja&"</pre>")
		'response.end
				   '"  and trunc(a.mcaj_finicio) = trunc(sysdate) " & vbCrLf &_
	End Sub


	Function AbrirCaja
		'Abrir Caja
		'Retornar Caja Abierta
		Dim f_movimiento_caja
		Dim v_mcaj_ncorr

		if not Me.TieneCajaAbierta and b_es_cajero then
			set f_movimiento_caja = new CFormulario
			f_movimiento_caja.Carga_Parametros archivo_xml, "movimientos_cajas"
			f_movimiento_caja.Inicializar conexion

			v_mcaj_ncorr = conexion.ConsultaUno("execute obtenersecuencia 'movimientos_cajas'")
			'v_mcaj_ncorr = conexion.ConsultaUno("select mcaj_ncorr_seq.nextval from dual")
			v_mcaj_finicio = conexion.ConsultaUno("select convert(varchar,getdate(),101)")
			'v_mcaj_finicio = conexion.ConsultaUno("select to_char(sysdate, 'dd/mm/yyyy') from dual")

			f_movimiento_caja.CreaFilaPost
			f_movimiento_caja.AgregaCampoPost "mcaj_ncorr", v_mcaj_ncorr
			f_movimiento_caja.AgregaCampoPost "caje_ccod", v_caje_ccod
			f_movimiento_caja.AgregaCampoPost "eren_ccod", "1"
			f_movimiento_caja.AgregaCampoPost "tcaj_ccod", v_tcaj_ccod
			f_movimiento_caja.AgregaCampoPost "sede_ccod", v_sede_ccod
			f_movimiento_caja.AgregaCampoPost "mcaj_finicio", v_mcaj_finicio
			f_movimiento_caja.MantieneTablas false

			'response.Write v_mcaj_finicio
			end if

		AbrirCaja = Me.ObtenerCajaAbierta
	End Function

	Sub CerrarCaja
	End Sub


	Function ObtenerCajaAbierta
		Dim registros

		conexion.Ejecuta sql_caja
		set registros = conexion.ObtenerRegistros
		if registros.Item("filas").Count > 0 then
			ObtenerCajaAbierta = registros.Item("filas").Item(0).Item("MCAJ_NCORR")
		else
			ObtenerCajaAbierta = ""
		end if
	End Function


	Function TieneAlgunaCajaAbierta
		Dim consulta
		Dim registros

		consulta = "select a.mcaj_ncorr, a.mcaj_finicio, a.tcaj_ccod " & vbCrLf &_
				   "from movimientos_cajas a, cajeros b " & vbCrLf &_
				   "where a.caje_ccod = b.caje_ccod " & vbCrLf &_
				   "  and a.sede_ccod = b.sede_ccod " & vbCrLf &_
				   "  and a.eren_ccod = 1 " & vbCrLf &_
				   "  and convert(varchar,a.mcaj_finicio,103) = convert(varchar,getdate(),103) " & vbCrLf &_
				   "  and b.caje_ccod = '" & v_caje_ccod & "'" & vbCrLf &_
				   "  and b.sede_ccod = '" & v_sede_ccod & "'"

				   '"  and trunc(a.mcaj_finicio) = trunc(sysdate) " & vbCrLf &_
				   'response.write("<pre>"&consulta&"</pre>")

		TieneAlgunaCajaAbierta = false

		if b_es_cajero then
			conexion.Ejecuta consulta
			set registros = conexion.ObtenerRegistros

			if registros.Item("filas").Count > 0 then
				TieneAlgunaCajaAbierta = true
			else
				TieneAlgunaCajaAbierta = false
			end if
		end if

	End Function


	Function ObtenerCajeCCod
		ObtenerCajeCCod = v_caje_ccod
	End Function


	Function TieneCajaAbierta
		'Retornar True o False
		Dim consulta
		Dim registros

		TieneCajaAbierta = false

		if b_es_cajero then
			conexion.Ejecuta sql_caja
			set registros = conexion.ObtenerRegistros

			if registros.Item("filas").Count > 0 then
				TieneCajaAbierta = true
			else
				TieneCajaAbierta = false
			end if
		end if
	End Function

End Class
%>
