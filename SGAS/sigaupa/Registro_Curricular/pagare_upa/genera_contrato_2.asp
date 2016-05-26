<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'response.Write("<h3>Página temporalmente fuera de servicio...</h3>")
'response.End()
q_post_ncorr = Request.QueryString("post_ncorr")

set pagina = new CPagina
pagina.Titulo = "Generación de Contratos - Forma de Pago"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

sede = negocio.obtenerSede

set errores = new CErrores


set f_consulta = new CFormulario
f_consulta.Carga_Parametros "consulta.xml", "consulta"


sql_ofer_ncorr = 	"select ofer_ncorr from postulantes where post_ncorr =  '"&q_post_ncorr&"'"
v_ofer_ncorr	=	conexion.ConsultaUno(sql_ofer_ncorr)  

'end if

consulta = "select count(*) " & vbCrLf &_
           "from contratos " & vbCrLf &_
		   "where econ_ccod <> 3 " & vbCrLf &_
		   "  and post_ncorr = '" & q_post_ncorr & "'"
  
if CInt(conexion.ConsultaUno(consulta)) > 0 then
	b_contrato_generado = true
else
	b_contrato_generado = false
end if

'---------------------------------------------------------------------------------------------------
consulta_datos = "select a.pers_ncorr, b.post_ncorr, cast(a.pers_nrut as varchar)+ ' - ' + cast(a.pers_xdv as varchar) as rut," & vbCrLf &_
                  " cast(a.pers_tnombre as varchar)+ ' ' + cast(a.pers_tape_paterno as varchar) + ' ' + cast(a.pers_tape_materno as varchar) as nombre_completo," & vbCrLf &_
                  " a.pers_nrut, a.pers_xdv, " & vbCrLf &_
                  " cast(e.carr_tdesc as varchar)+ ' - ' + cast(d.espe_tdesc as varchar) as carrera, convert(varchar,getDate(),103) as fecha_actual," & vbCrLf &_
                  " g.sede_tdesc,f.aran_mmatricula, f.aran_mcolegiatura, i.stpa_ccod, " & vbCrLf &_
	              " isnull(f.aran_mmatricula, 0) + isnull(f.aran_mcolegiatura, 0) as subtotal, " & vbCrLf &_
	              " sum(isnull(h.sdes_mmatricula, 0) + isnull(h.sdes_mcolegiatura, 0)) as total_descuentos, " & vbCrLf &_
	              " isnull(f.aran_mmatricula, 0) + isnull(f.aran_mcolegiatura, 0) - sum(isnull(h.sdes_mmatricula, 0) + isnull(h.sdes_mcolegiatura, 0)) as total, " & vbCrLf &_
                  " sum(case h.esde_ccod when 1 then isnull(h.sdes_mmatricula, 0) + isnull(h.sdes_mcolegiatura, 0) else 0 end) as total_descuentos_confirmados, " & vbCrLf &_
	              " isnull(f.aran_mmatricula, 0) + isnull(f.aran_mcolegiatura, 0) - sum(case h.esde_ccod when 1 then isnull(h.sdes_mmatricula, 0) + isnull(h.sdes_mcolegiatura, 0) else 0 end ) as total_pagar, " & vbCrLf &_
                  " isnull(f.aran_mmatricula, 0) - sum(case h.esde_ccod when 1 then isnull(h.sdes_mmatricula, 0) else 0 end) as total_pagar_matricula, " & vbCrLf &_
             	  " isnull(f.aran_mcolegiatura, 0) - sum(case h.esde_ccod when 1 then isnull(h.sdes_mcolegiatura, 0) else 0 end) as total_pagar_colegiatura " & vbCrLf &_
                  " from personas_postulante a, postulantes b, ofertas_academicas c, especialidades d, carreras e, aranceles f, sedes g, " & vbCrLf &_
                  " sdescuentos h, spagos i " & vbCrLf &_
	              " where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
                  " and b.ofer_ncorr = c.ofer_ncorr   " & vbCrLf &_
                  " and c.espe_ccod = d.espe_ccod " & vbCrLf &_
                  " and d.carr_ccod = e.carr_ccod " & vbCrLf &_
                  " and c.aran_ncorr = f.aran_ncorr " & vbCrLf &_
                  " and c.sede_ccod = g.sede_ccod " & vbCrLf &_
                  " and b.post_ncorr *= h.post_ncorr  " & vbCrLf &_
                  " and b.ofer_ncorr *= h.ofer_ncorr  " & vbCrLf &_
                  " and b.post_ncorr *= i.post_ncorr  " & vbCrLf &_
                  " and b.ofer_ncorr *= i.ofer_ncorr " & vbCrLf &_
                  " and b.tpos_ccod in (1,2) " & vbCrLf &_
                  " and b.epos_ccod = 2 " & vbCrLf &_
                  " and cast(b.post_ncorr as varchar)= '" & q_post_ncorr & "' " & vbCrLf &_
                  " group by a.pers_ncorr, b.post_ncorr, a.pers_nrut, a.pers_xdv, a.pers_tnombre, a.pers_tape_paterno, a.pers_tape_materno, " & vbCrLf &_
                  " e.carr_tdesc, d.espe_tdesc, g.sede_tdesc, f.aran_mmatricula, f.aran_mcolegiatura, i.stpa_ccod "
				 
'response.Write("<pre>" & consulta_datos2 & "</pre>")				 
'---------------------------------------------------------------------------------------------------

set fc_datos = new CFormulario
fc_datos.Carga_Parametros "genera_contrato_2.xml", "datos_encabezado"
fc_datos.Inicializar conexion
fc_datos.Consultar consulta_datos
fc_datos.Siguiente

v_total_pagar_matricula = fc_datos.ObtenerValor("total_pagar_matricula")
v_total_pagar_colegiatura = fc_datos.ObtenerValor("total_pagar_colegiatura")
'response.Write("total "&v_total_pagar_matricula)
v_fecha_actual = fc_datos.ObtenerValor("fecha_actual")

'-----------------------------------------------------------------------------------------------------------
set f_tabla_valores = new CFormulario
f_tabla_valores.Carga_Parametros "genera_contrato_2.xml", "tabla_valores"
f_tabla_valores.Inicializar conexion

consulta = " select b.tipo, b.ttipo,   " & vbcrlf & _
"       case b.tipo  " & vbcrlf & _
"             when 1 then a.aran_mmatricula  " & vbcrlf & _
"             when 2 then -a.desc_matricula  " & vbcrlf & _
"        end as matricula  ,  " & vbcrlf & _
"        case b.tipo  " & vbcrlf & _
"             when 1 then a.aran_mcolegiatura  " & vbcrlf & _
"             when 2 then -a.desc_colegiatura  " & vbcrlf & _
"        end as arancel  ,  " & vbcrlf & _
"        case b.tipo  " & vbcrlf & _
"             when 1 then a.total_arancel  " & vbcrlf & _
"             when 2 then -a.total_descuentos  " & vbcrlf & _
"        end as total  ,  " & vbcrlf & _
"        case b.tipo  " & vbcrlf & _
"             when 1 then a.aran_mmatricula  " & vbcrlf & _
"             when 2 then -a.desc_matricula  " & vbcrlf & _
"        end as c_matricula  ,  " & vbcrlf & _
"        case b.tipo  " & vbcrlf & _
"             when 1 then a.aran_mcolegiatura  " & vbcrlf & _
"             when 2 then -a.desc_colegiatura  " & vbcrlf & _
"        end as c_arancel  ,  " & vbcrlf & _
"        case b.tipo  " & vbcrlf & _
"             when 1 then a.total_arancel  " & vbcrlf & _
"             when 2 then -a.total_descuentos  " & vbcrlf & _
"        end as c_arancel    " & vbcrlf & _
" from (  " & vbcrlf & _
"         select b.post_ncorr, c.ofer_ncorr,   " & vbcrlf & _
"                d.aran_mmatricula, d.aran_mcolegiatura, d.aran_mmatricula + d.aran_mcolegiatura as total_arancel,  " & vbcrlf & _
"                sum(isnull(f.sdes_mmatricula, 0)) as desc_matricula, sum(isnull(f.sdes_mcolegiatura, 0)) as desc_colegiatura,   " & vbcrlf & _
" 	           sum(isnull(f.sdes_mmatricula, 0)) + sum(isnull(f.sdes_mcolegiatura, 0)) as total_descuentos         " & vbcrlf & _
"         from personas_postulante a,postulantes b,  " & vbcrlf & _
"         ofertas_academicas c,aranceles d,spagos e,sdescuentos f  " & vbcrlf & _
"         where a.pers_ncorr = b.pers_ncorr  " & vbcrlf & _
"         and b.ofer_ncorr  = c.ofer_ncorr  " & vbcrlf & _
"         and c.aran_ncorr   = d.aran_ncorr  " & vbcrlf & _
"         and b.post_ncorr   *= e.post_ncorr  " & vbcrlf & _
"         and b.post_ncorr   *= f.post_ncorr  " & vbcrlf & _
"         and b.ofer_ncorr   *= f.ofer_ncorr  " & vbcrlf & _
"         and f.esde_ccod = 1  " & vbcrlf & _
"         and b.post_ncorr = '"&q_post_ncorr&"'  " & vbcrlf & _
"         group by b.post_ncorr, c.ofer_ncorr, d.aran_mmatricula, d.aran_mcolegiatura ) a,  " & vbcrlf & _
"         (select 1 as tipo, 'ARANCELES DE CARRERA' as ttipo  union   " & vbcrlf & _
" 	     select 2 as tipo, 'DESCUENTOS Y CRÉDITOS AUTORIZADOS' as ttipo ) b  " & vbcrlf & _
" order by b.tipo asc  "
'response.Write("<pre>"&consulta&"<pre>")


f_tabla_valores.Consultar consulta

'---------------------------------------------------------------------------------------------------------
set f_descuentos = new CFormulario
f_descuentos.Carga_Parametros "genera_contrato_2.xml", "descuentos"
f_descuentos.Inicializar conexion

consulta = "select a.stde_ccod, a.post_ncorr, a.ofer_ncorr, isnull(a.sdes_nporc_matricula,0)  as sdes_nporc_matricula, isnull(a.sdes_nporc_colegiatura,0) as sdes_nporc_colegiatura, a.esde_ccod, " & vbCrLf &_
           "       b.stde_tdesc, isnull(a.sdes_mmatricula,0)  as sdes_mmatricula, isnull(a.sdes_mcolegiatura,0)  as sdes_mcolegiatura, isnull(a.sdes_mmatricula, 0) + isnull(a.sdes_mcolegiatura, 0) as subtotal, a.sdes_tobservaciones " & vbCrLf &_
		   "from sdescuentos a, stipos_descuentos b, postulantes c " & vbCrLf &_
		   "where a.stde_ccod = b.stde_ccod " & vbCrLf &_
		   "  and a.post_ncorr = c.post_ncorr " & vbCrLf &_
		   "  and a.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
		   "  and c.post_ncorr = '" & q_post_ncorr & "'"
'response.Write("<pre>"&consulta&"</pre>")		   
f_descuentos.Consultar consulta


'--------------------------------------------------------------------------------------------------------
consulta =" select a.post_ncorr, a.ofer_ncorr, a.stpa_ccod, a.tcom_ccod, a.ting_ccod, a.ting_ccod as c_ting_ccod,  " & vbcrlf & _
"       isnull(a.sdfp_mmonto, 0) as sdfp_mmonto,  " & vbcrlf & _
"       isnull(a.sdfp_finicio_pago, null) as sdfp_finicio_pago, isnull(a.sdfp_nfrecuencia, 1) as sdfp_nfrecuencia,  " & vbcrlf & _
"  	    a.banc_ccod, a.plaz_ccod,a.sdfp_tplaza_sbif, a.sdfp_ndocto_inicial, a.sdfp_tctacte,  " & vbcrlf & _
"        case isnull(a.sdfp_mmonto, 0) " & vbcrlf & _
"             when 0 then 'N' " & vbcrlf & _
"             else 'S' " & vbcrlf & _
"        end butiliza, " & vbcrlf & _
"        (select isnull(bb.stpa_ncuotas, 0)  " & vbcrlf & _
"         from stipos_pagos bb " & vbcrlf & _
"         where a.stpa_ccod *= bb.stpa_ccod  " & vbcrlf & _
"         and a.tcom_ccod *= bb.tcom_ccod   " & vbcrlf & _
"         and a.ting_ccod *= bb.ting_ccod ) as stpa_ncuotas " & vbcrlf & _
" from " & vbcrlf & _
" (select a.post_ncorr, a.ofer_ncorr, a.stpa_ccod, a.tcom_ccod, a.ting_ccod,  " & vbcrlf & _
"         b.sdfp_mmonto, b.sdfp_finicio_pago, b.sdfp_nfrecuencia, b.banc_ccod, " & vbcrlf & _
"         b.plaz_ccod,b.sdfp_tplaza_sbif, b.sdfp_ndocto_inicial, b.sdfp_tctacte  " & vbcrlf & _
"  from (select a.post_ncorr, a.ofer_ncorr, b.stpa_ccod, " & vbcrlf & _
"        c.tcom_ccod, c.ting_ccod " & vbcrlf & _
"        from postulantes a,spagos b, sformas_pactacion_contrato c" & vbcrlf & _
"        where a.post_ncorr *= b.post_ncorr " & vbcrlf & _
"        and   a.ofer_ncorr *= b.ofer_ncorr " & vbcrlf & _
"        and   a.post_ncorr ='"&q_post_ncorr&"') a, " & vbcrlf & _
"        sdetalles_forma_pago b " & vbcrlf & _
"  where a.post_ncorr *= b.post_ncorr   " & vbcrlf & _
"  and   a.ofer_ncorr *= b.ofer_ncorr " & vbcrlf & _  
"  and   a.tcom_ccod  *= b.tcom_ccod  " & vbcrlf & _
"  and   a.ting_ccod  *= b.ting_ccod ) a " & vbcrlf

'"             (select distinct tcom_ccod, ting_ccod  " & vbcrlf & _
'"              from stipos_pagos ) c  " & vbcrlf & _
' este codigo fue reemplazado por una tabla que contiene los datos necesarios
'response.Write("<pre>"&consulta&"</pre>")

sql_fp_matricula = consulta & "  where a.tcom_ccod = 1 order by a.ting_ccod desc"
sql_fp_colegiatura = consulta & "  where a.tcom_ccod = 2 order by a.ting_ccod desc"

'response.Write("<pre>"&sql_fp_colegiatura&"</pre>")

set f_forma_pago_matricula = new CFormulario
f_forma_pago_matricula.Carga_Parametros "genera_contrato_2.xml", "forma_pago"
f_forma_pago_matricula.Inicializar conexion
f_forma_pago_matricula.AgregaParam "variable", "fp_matricula"
f_forma_pago_matricula.Consultar sql_fp_matricula

set f_forma_pago_colegiatura = new CFormulario
f_forma_pago_colegiatura.Carga_Parametros "genera_contrato_2.xml", "forma_pago"
f_forma_pago_colegiatura.Inicializar conexion
f_forma_pago_colegiatura.AgregaParam "variable", "fp_colegiatura"
f_forma_pago_colegiatura.Consultar sql_fp_colegiatura

'-------------------------------------------------------------------------
'-----------	SI EL CONTRATO AUN NO SE HA GENERADO----------------------
if not b_contrato_generado then
	f_consulta.Inicializar conexion
	f_consulta.Consultar sql_fp_matricula
	
'#################################################################################
'###############################	MATRICULA	##################################
	i_ = 0
	while f_consulta.Siguiente
		if f_consulta.ObtenerValor("ting_ccod") <> "3" and f_consulta.ObtenerValor("ting_ccod") <>"13" and f_consulta.ObtenerValor("ting_ccod") <>"51" and f_consulta.ObtenerValor("ting_ccod") <>"59" and f_consulta.ObtenerValor("ting_ccod") <>"66" then
			f_forma_pago_matricula.AgregaCampoFilaParam i_, "banc_ccod", "permiso", "LECTURA"
			f_forma_pago_matricula.AgregaCampoFilaParam i_, "plaz_ccod", "permiso", "LECTURA"		
			f_forma_pago_matricula.AgregaCampoFilaParam i_, "sdfp_ndocto_inicial", "permiso", "LECTURA"
			f_forma_pago_matricula.AgregaCampoFilaParam i_, "sdfp_tctacte", "permiso", "LECTURA"
		end if
		
		if f_consulta.ObtenerValor("ting_ccod") = "6" then
			f_forma_pago_matricula.AgregaCampoFilaParam i_, "sdfp_finicio_pago", "soloLectura", "TRUE"
			f_forma_pago_matricula.AgregaCampoFilaParam i_, "sdfp_nfrecuencia", "permiso", "LECTURA"
			f_forma_pago_matricula.AgregaCampoFilaCons i_, "sdfp_nfrecuencia", ""
		end if	
			
		if f_consulta.ObtenerValor("butiliza") = f_forma_pago_matricula.ObtenerDescriptor("butiliza", "valorFalso") then
			f_forma_pago_matricula.AgregaCampoFilaParam i_, "stpa_ncuotas", "deshabilitado", "TRUE"
			f_forma_pago_matricula.AgregaCampoFilaParam i_, "sdfp_mmonto", "deshabilitado", "TRUE"
			f_forma_pago_matricula.AgregaCampoFilaParam i_, "sdfp_finicio_pago", "deshabilitado", "TRUE"
			f_forma_pago_matricula.AgregaCampoFilaParam i_, "sdfp_nfrecuencia", "deshabilitado", "TRUE"
			f_forma_pago_matricula.AgregaCampoFilaParam i_, "sdfp_ndocto_inicial", "deshabilitado", "TRUE"
			f_forma_pago_matricula.AgregaCampoFilaParam i_, "banc_ccod", "deshabilitado", "TRUE"
			f_forma_pago_matricula.AgregaCampoFilaParam i_, "plaz_ccod", "deshabilitado", "TRUE"
			f_forma_pago_matricula.AgregaCampoFilaParam i_, "sdfp_tctacte", "deshabilitado", "TRUE"
		end if
		
		if f_consulta.ObtenerValor("ting_ccod") ="13" or f_consulta.ObtenerValor("ting_ccod") ="51" or f_consulta.ObtenerValor("ting_ccod") ="59" or f_consulta.ObtenerValor("ting_ccod") ="66" then
				f_forma_pago_matricula.AgregaCampoFilaParam i_, "sdfp_ndocto_inicial", "permiso", "oculto"
				f_forma_pago_matricula.AgregaCampoFilaParam i_, "plaz_ccod", "permiso", "oculto"
				f_forma_pago_matricula.AgregaCampoFilaParam i_, "banc_ccod", "id", "TO-N"
				f_forma_pago_matricula.AgregaCampoFilaParam i_, "sdfp_tctacte", "id", "TO-N"		
		end if
		
		if f_consulta.ObtenerValor("ting_ccod") ="13" or f_consulta.ObtenerValor("ting_ccod") ="51" then
			f_forma_pago_matricula.AgregaCampoFilaParam i_, "sdfp_tctacte", "maxCaracteres", "4"
			f_forma_pago_matricula.AgregaCampoFilaParam i_, "sdfp_tctacte", "script", "onblur='VerificaNumerosTarjeta(this)'"
			f_forma_pago_matricula.AgregaCampoFilaParam i_, "sdfp_tctacte", "id", "NU-N"
		end if
		
		f_forma_pago_matricula.AgregaCampoFilaParam i_, "stpa_ncuotas", "filtro", "a.tcom_ccod = '" & f_consulta.ObtenerValor("tcom_ccod") & "' and a.ting_ccod = '" & f_consulta.ObtenerValor("ting_ccod") & "' and a.stpa_ncuotas > 0 order by a.tcom_ccod, a.ting_ccod, a.stpa_ncuotas"
		
		i_ = i_ + 1
	wend
	
'#############################################################################################
'###############################	COLEGIATURA O ARANCEL 	##################################
	
	f_consulta.Inicializar conexion
	f_consulta.Consultar sql_fp_colegiatura
	i_ = 0
	while f_consulta.Siguiente
		if f_consulta.ObtenerValor("ting_ccod") <> "3"  and f_consulta.ObtenerValor("ting_ccod") <>"13" and f_consulta.ObtenerValor("ting_ccod") <>"51" and f_consulta.ObtenerValor("ting_ccod") <>"52" and f_consulta.ObtenerValor("ting_ccod") <>"59" and f_consulta.ObtenerValor("ting_ccod") <>"66" then		
			f_forma_pago_colegiatura.AgregaCampoFilaParam i_, "sdfp_ndocto_inicial", "permiso", "LECTURA"
			f_forma_pago_colegiatura.AgregaCampoFilaParam i_, "banc_ccod", "permiso", "LECTURA"
			f_forma_pago_colegiatura.AgregaCampoFilaParam i_, "plaz_ccod", "permiso", "LECTURA"		
			f_forma_pago_colegiatura.AgregaCampoFilaParam i_, "sdfp_tctacte", "permiso", "LECTURA"		
		end if

		if f_consulta.ObtenerValor("ting_ccod") = "6" then		
			f_forma_pago_colegiatura.AgregaCampoFilaParam i_, "sdfp_finicio_pago", "soloLectura", "TRUE"
			f_forma_pago_colegiatura.AgregaCampoFilaParam i_, "sdfp_nfrecuencia", "permiso", "LECTURA"
			f_forma_pago_colegiatura.AgregaCampoFilaCons i_, "sdfp_nfrecuencia", ""
		end if
		
		if f_consulta.ObtenerValor("butiliza") = f_forma_pago_colegiatura.ObtenerDescriptor("butiliza", "valorFalso") then
			f_forma_pago_colegiatura.AgregaCampoFilaParam i_, "stpa_ncuotas", "deshabilitado", "TRUE"
			f_forma_pago_colegiatura.AgregaCampoFilaParam i_, "sdfp_mmonto", "deshabilitado", "TRUE"
			f_forma_pago_colegiatura.AgregaCampoFilaParam i_, "sdfp_finicio_pago", "deshabilitado", "TRUE"
			f_forma_pago_colegiatura.AgregaCampoFilaParam i_, "sdfp_nfrecuencia", "deshabilitado", "TRUE"
			f_forma_pago_colegiatura.AgregaCampoFilaParam i_, "sdfp_ndocto_inicial", "deshabilitado", "TRUE"
			f_forma_pago_colegiatura.AgregaCampoFilaParam i_, "banc_ccod", "deshabilitado", "TRUE"
			f_forma_pago_colegiatura.AgregaCampoFilaParam i_, "plaz_ccod", "deshabilitado", "TRUE"
			f_forma_pago_colegiatura.AgregaCampoFilaParam i_, "sdfp_tctacte", "deshabilitado", "TRUE"
		end if
		'
		if f_consulta.ObtenerValor("ting_ccod") ="13" or f_consulta.ObtenerValor("ting_ccod") ="51" or f_consulta.ObtenerValor("ting_ccod") ="52" or f_consulta.ObtenerValor("ting_ccod") ="59" or f_consulta.ObtenerValor("ting_ccod") ="66" then
				f_forma_pago_colegiatura.AgregaCampoFilaParam i_, "sdfp_ndocto_inicial", "permiso", "oculto"
				f_forma_pago_colegiatura.AgregaCampoFilaParam i_, "plaz_ccod", "permiso", "oculto"
				f_forma_pago_colegiatura.AgregaCampoFilaParam i_, "banc_ccod", "id", "TO-N"
				f_forma_pago_colegiatura.AgregaCampoFilaParam i_, "sdfp_tctacte", "id", "TO-N"		
		end if
		
		if f_consulta.ObtenerValor("ting_ccod") ="13" or f_consulta.ObtenerValor("ting_ccod") ="51" then
			f_forma_pago_colegiatura.AgregaCampoFilaParam i_, "sdfp_tctacte", "maxCaracteres", "4"
			f_forma_pago_colegiatura.AgregaCampoFilaParam i_, "sdfp_tctacte", "script", "onblur='VerificaNumerosTarjeta(this)'"
			f_forma_pago_colegiatura.AgregaCampoFilaParam i_, "sdfp_tctacte", "id", "NU-N"
			
		end if
		
		f_forma_pago_colegiatura.AgregaCampoFilaParam i_, "stpa_ncuotas", "filtro", "tcom_ccod = '" & f_consulta.ObtenerValor("tcom_ccod") & "' and ting_ccod = '" & f_consulta.ObtenerValor("ting_ccod") & "' and stpa_ncuotas > 0 order by a.tcom_ccod, a.ting_ccod, a.stpa_ncuotas"
		
		i_ = i_ + 1
	wend

end if
'-------------------------------------------------------------------------

'------------------------------------------------------------------------
set f_suma_fp_matricula = new CFormulario
f_suma_fp_matricula.Carga_Parametros "genera_contrato_2.xml", "suma_fpago"
f_suma_fp_matricula.Inicializar conexion
f_suma_fp_matricula.AgregaParam "variable", "suma_fp_matricula"

if v_total_pagar_matricula="" then
	v_total_pagar_matricula=0
end if
if v_total_pagar_colegiatura="" then
	v_total_pagar_colegiatura=0
end if
consulta = "select isnull(sum(b.sdfp_mmonto), 0) as total_actual, '" & v_total_pagar_matricula & "' as total_pagar, isnull(sum(b.sdfp_mmonto), 0) - isnull('" & v_total_pagar_matricula & "', 0) as diferencia" & vbCrLf &_
           "from postulantes a, sdetalles_forma_pago b " & vbCrLf &_
		   "where a.post_ncorr = b.post_ncorr " & vbCrLf &_
		   "  and a.ofer_ncorr = b.ofer_ncorr " & vbCrLf &_
		   "  and b.tcom_ccod = '1'  " & vbCrLf &_
		   "  and a.post_ncorr = '" & q_post_ncorr & "'"
' response.Write("<pre>"&consulta&"</pre>")  
f_suma_fp_matricula.Consultar consulta


'------------------------------------------------------------------------
set f_suma_fp_colegiatura = new CFormulario
f_suma_fp_colegiatura.Carga_Parametros "genera_contrato_2.xml", "suma_fpago"
f_suma_fp_colegiatura.Inicializar conexion
f_suma_fp_colegiatura.AgregaParam "variable", "suma_fp_colegiatura"

consulta = "select isnull(sum(b.sdfp_mmonto), 0) as total_actual, '" & v_total_pagar_colegiatura & "' as total_pagar, isnull(sum(b.sdfp_mmonto), 0) - isnull('" & v_total_pagar_colegiatura & "', 0) as diferencia" & vbCrLf &_
           "from postulantes a, sdetalles_forma_pago b " & vbCrLf &_
		   "where a.post_ncorr = b.post_ncorr " & vbCrLf &_
		   "  and a.ofer_ncorr = b.ofer_ncorr " & vbCrLf &_
		   "  and b.tcom_ccod = '2'  " & vbCrLf &_
		   "  and a.post_ncorr = '" & q_post_ncorr & "'"
' response.Write("<pre>"&consulta&"</pre>") 
f_suma_fp_colegiatura.Consultar consulta

'---------------------------------------------------------------------------------------------------------
set f_spagos = new CFormulario
f_spagos.Carga_Parametros "genera_contrato_2.xml", "spagos"
f_spagos.Inicializar conexion

consulta = "select a.post_ncorr, a.ofer_ncorr, b.stpa_ccod " & vbCrLf &_
		   "from postulantes a, spagos b  " & vbCrLf &_
		   "where a.post_ncorr *= b.post_ncorr   " & vbCrLf &_
		   "  and a.ofer_ncorr *= b.ofer_ncorr   " & vbCrLf &_
		   "  and a.post_ncorr = '" & q_post_ncorr & "'"

f_spagos.Consultar consulta


'---------------------------------------------------------------------------------------------------------
set f_detalle_pagos = new CFormulario
f_detalle_pagos.Carga_Parametros "genera_contrato_2.xml", "detalle_pagos"
f_detalle_pagos.Inicializar conexion

consulta =  "select b.post_ncorr, b.ofer_ncorr, b.sdpa_ncuota, b.sdpa_ccod, " & vbcrlf & _
			" b.sdpa_ncuota as c_sdpa_ncuota, b.sdpa_ccod as c_sdpa_ccod, " & vbcrlf & _
			" b.ting_ccod, b.ting_ccod as c_ting_ccod, b.tcom_ccod, b.sdpa_ndocumento,  " & vbcrlf & _ 
			" b.sdpa_femision, b.sdpa_fvencimiento, b.sdpa_mmonto as sdpa_mmonto,b.sdpa_mmonto as c_sdpa_mmonto, " & vbCrLf &_
            "       b.sdpa_tctacte, b.banc_ccod, b.plaz_ccod " & vbCrLf &_
            "from postulantes a, sdetalles_pagos b " & vbCrLf &_
		    "where a.post_ncorr = b.post_ncorr " & vbCrLf &_
		    "  and a.ofer_ncorr = b.ofer_ncorr " & vbCrLf &_
		    "  and a.post_ncorr = '" & q_post_ncorr & "' " & vbCrLf &_
		   "order by b.tcom_ccod asc, b.sdpa_fvencimiento asc, b.ting_ccod desc"

f_detalle_pagos.Consultar consulta

sql_total_det_pag = " select sum(b.sdpa_mmonto) as sdpa_mmonto " & vbCrLf &_
            		" from postulantes a, sdetalles_pagos b " & vbCrLf &_
		    		" where a.post_ncorr = b.post_ncorr " & vbCrLf &_
		      		" and a.ofer_ncorr = b.ofer_ncorr " & vbCrLf &_
		      		" and a.post_ncorr = '" & q_post_ncorr & "' " & vbCrLf &_
           			" group by a.post_ncorr " & vbCrLf 
					
total_det_pag = conexion.consultaUno (sql_total_det_pag)

if	EsVacio(total_det_pag) then
	total_det_pag = "0"
end if

'#####################################################################################
'###################	DIBUJA RESULTADO DE LA SIMULACION	##########################
if not b_contrato_generado then
	f_consulta.Inicializar conexion
	f_consulta.Consultar consulta
	
	i_ = 0
	while f_consulta.Siguiente
		if f_consulta.ObtenerValor("ting_ccod") <> "3" and f_consulta.ObtenerValor("ting_ccod") <> "52" then
			f_detalle_pagos.AgregaCampoFilaParam i_, "banc_ccod", "permiso", "LECTURA"
			f_detalle_pagos.AgregaCampoFilaParam i_, "plaz_ccod", "permiso", "LECTURA"		
			f_detalle_pagos.AgregaCampoFilaParam i_, "sdpa_tctacte", "permiso", "LECTURA"		
			f_detalle_pagos.AgregaCampoFilaParam i_, "sdpa_ndocumento", "permiso", "LECTURA"		
		end if
		
		
		'#################################################################
		'###### 	Hace Editable los montos de la simulacion		######
		'#################################################################		
		if f_consulta.ObtenerValor("ting_ccod") ="3" then
			f_detalle_pagos.AgregaCampoFilaParam i_, "sdpa_fvencimiento","permiso", "LECTURAESCRITURA"
			f_detalle_pagos.AgregaCampoFilaParam i_, "sdpa_mmonto","permiso","LECTURAESCRITURA"
			f_detalle_pagos.AgregaCampoFilaParam i_, "sdpa_fvencimiento","id","FE-N"
		end if
		
		if f_consulta.ObtenerValor("ting_ccod") ="4" then
			f_detalle_pagos.AgregaCampoFilaParam i_, "sdpa_fvencimiento","permiso", "LECTURAESCRITURA"
			f_detalle_pagos.AgregaCampoFilaParam i_, "sdpa_mmonto","permiso","LECTURAESCRITURA"
			f_detalle_pagos.AgregaCampoFilaParam i_, "sdpa_fvencimiento","id","FE-N"
		end if
		
		if f_consulta.ObtenerValor("ting_ccod") ="13" then 
			f_detalle_pagos.AgregaCampoFilaParam i_, "sdpa_fvencimiento","permiso", "LECTURAESCRITURA"
			f_detalle_pagos.AgregaCampoFilaParam i_, "sdpa_mmonto","permiso","LECTURAESCRITURA"
			f_detalle_pagos.AgregaCampoFilaParam i_, "sdpa_fvencimiento","id","FE-N"
		end if
		
		if f_consulta.ObtenerValor("ting_ccod") ="51" then
			f_detalle_pagos.AgregaCampoFilaParam i_, "sdpa_mmonto","permiso","LECTURAESCRITURA"
		end if

		'PAGARE TRANSBANK
		if f_consulta.ObtenerValor("ting_ccod") ="52" then
			f_detalle_pagos.AgregaCampoFilaParam i_, "plaz_ccod", "permiso", "oculto"
			f_detalle_pagos.AgregaCampoFilaParam i_, "banc_ccod", "permiso", "lectura"		
			f_detalle_pagos.AgregaCampoFilaParam i_, "sdpa_tctacte", "permiso", "lectura"
			f_detalle_pagos.AgregaCampoFilaParam i_, "sdpa_ndocumento", "permiso", "oculto"
			f_detalle_pagos.AgregaCampoFilaParam i_, "sdpa_fvencimiento","permiso", "LECTURAESCRITURA"
			f_detalle_pagos.AgregaCampoFilaParam i_, "sdpa_mmonto","permiso","LECTURAESCRITURA"
			f_detalle_pagos.AgregaCampoFilaParam i_, "sdpa_fvencimiento","id","FE-N"
		end if

		'PAGARE MULTIDEBITO
		if f_consulta.ObtenerValor("ting_ccod") ="59" then
			f_detalle_pagos.AgregaCampoFilaParam i_, "plaz_ccod", "permiso", "oculto"
			f_detalle_pagos.AgregaCampoFilaParam i_, "banc_ccod", "permiso", "lectura"		
			f_detalle_pagos.AgregaCampoFilaParam i_, "sdpa_tctacte", "permiso", "lectura"
			f_detalle_pagos.AgregaCampoFilaParam i_, "sdpa_ndocumento", "permiso", "oculto"
			f_detalle_pagos.AgregaCampoFilaParam i_, "sdpa_fvencimiento","permiso", "LECTURAESCRITURA"
			f_detalle_pagos.AgregaCampoFilaParam i_, "sdpa_mmonto","permiso","LECTURAESCRITURA"
			f_detalle_pagos.AgregaCampoFilaParam i_, "sdpa_fvencimiento","id","FE-N"
		end if

		'PAGARE UPA
		if f_consulta.ObtenerValor("ting_ccod") ="66" then
			f_detalle_pagos.AgregaCampoFilaParam i_, "plaz_ccod", "permiso", "oculto"
			f_detalle_pagos.AgregaCampoFilaParam i_, "banc_ccod", "permiso", "lectura"		
			f_detalle_pagos.AgregaCampoFilaParam i_, "sdpa_tctacte", "permiso", "lectura"
			f_detalle_pagos.AgregaCampoFilaParam i_, "sdpa_ndocumento", "permiso", "oculto"
			f_detalle_pagos.AgregaCampoFilaParam i_, "sdpa_fvencimiento","permiso", "LECTURAESCRITURA"
			f_detalle_pagos.AgregaCampoFilaParam i_, "sdpa_mmonto","permiso","LECTURAESCRITURA"
			f_detalle_pagos.AgregaCampoFilaParam i_, "sdpa_fvencimiento","id","FE-N"
		end if
				
		'#################################################################
		'###### 	Fin Editable los montos de la simulacion		######
		'#################################################################		

		
		i_ = i_ + 1
	wend
end if
'#####################################################################################

'-------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "genera_contrato_2.xml", "botonera"

f_botonera.AgregaBotonParam "anterior", "url", "genera_contrato_1.asp?busqueda[0][pers_nrut]=" & fc_datos.ObtenerValor("pers_nrut") & "&busqueda[0][pers_xdv]=" & fc_datos.ObtenerValor("pers_xdv")
f_botonera.AgregaBotonParam "calcular", "url", "proc_calcular_contrato.asp?post_ncorr=" & q_post_ncorr
f_botonera.AgregaBotonParam "siguiente", "url", "proc_genera_contrato_2.asp?post_ncorr=" & q_post_ncorr
f_botonera.AgregaBotonParam "agregar_descuento", "url", "agregar_descuento.asp?post_ncorr=" & q_post_ncorr

'---------------------------------------------------------------------------------------------------------
'---------------	EL CONTRATO YA FUE GENERADO ----------------------------------------------------------
if b_contrato_generado then
	f_botonera.AgregaBotonParam "agregar_descuento", "deshabilitado", "TRUE"
	f_botonera.AgregaBotonParam "eliminar_descuento", "deshabilitado", "TRUE"
	f_botonera.AgregaBotonParam "calcular", "deshabilitado", "TRUE"
	
	f_descuentos.AgregaParam "editar", "FALSE"
	f_descuentos.AgregaParam "eliminar", "FALSE"
	
	
	f_forma_pago_matricula.AgregaCampoParam "butiliza", "deshabilitado", "TRUE"	
	f_forma_pago_matricula.AgregaCampoParam "stpa_ncuotas", "permiso", "LECTURA"
	f_forma_pago_matricula.AgregaCampoParam "sdfp_mmonto", "permiso", "LECTURA"
	f_forma_pago_matricula.AgregaCampoParam "sdfp_finicio_pago", "permiso", "LECTURA"
	f_forma_pago_matricula.AgregaCampoParam "sdfp_nfrecuencia", "permiso", "LECTURA"
	f_forma_pago_matricula.AgregaCampoParam "sdfp_ndocto_inicial", "permiso", "LECTURA"
	f_forma_pago_matricula.AgregaCampoParam "banc_ccod", "permiso", "LECTURA"
	f_forma_pago_matricula.AgregaCampoParam "plaz_ccod", "permiso", "LECTURA"
	f_forma_pago_matricula.AgregaCampoParam "sdfp_tctacte", "permiso", "LECTURA"
	
	f_forma_pago_colegiatura.AgregaCampoParam "butiliza", "deshabilitado", "TRUE"	
	f_forma_pago_colegiatura.AgregaCampoParam "stpa_ncuotas", "permiso", "LECTURA"
	f_forma_pago_colegiatura.AgregaCampoParam "sdfp_mmonto", "permiso", "LECTURA"
	f_forma_pago_colegiatura.AgregaCampoParam "sdfp_finicio_pago", "permiso", "LECTURA"
	f_forma_pago_colegiatura.AgregaCampoParam "sdfp_nfrecuencia", "permiso", "LECTURA"
	f_forma_pago_colegiatura.AgregaCampoParam "sdfp_ndocto_inicial", "permiso", "LECTURA"
	f_forma_pago_colegiatura.AgregaCampoParam "banc_ccod", "permiso", "LECTURA"
	f_forma_pago_colegiatura.AgregaCampoParam "plaz_ccod", "permiso", "LECTURA"
	f_forma_pago_colegiatura.AgregaCampoParam "sdfp_tctacte", "permiso", "LECTURA"
	
	f_detalle_pagos.AgregaCampoParam "sdpa_ndocumento", "permiso", "LECTURA"
	f_detalle_pagos.AgregaCampoParam "banc_ccod", "permiso", "LECTURA"
	f_detalle_pagos.AgregaCampoParam "plaz_ccod", "permiso", "LECTURA"
	f_detalle_pagos.AgregaCampoParam "sdpa_tctacte", "permiso", "LECTURA"
end if

if f_spagos.NroFilas = 0 then
	f_botonera.AgregaBotonParam "calcular", "deshabilitado", "TRUE"
end if


if f_detalle_pagos.NroFilas = 0 then
	f_botonera.AgregaBotonParam "siguiente", "deshabilitado", "TRUE"
end if




'--------------------------------------------------------------------------------------------------
set f_max_cuotas = new CFormulario
f_max_cuotas.Carga_Parametros "genera_contrato_2.xml", "max_cuotas"
f_max_cuotas.Inicializar conexion

' ********** tabla SCUOTAS_PACTACION se usa para agregar mas cuotas a la simulacion ****************

' valores fijos para los numeros de maximos de cuotas permitidos
consulta = "select '5' as max_cuotas_doc_matricula, " & vbCrLf &_
           "       '1' as max_cuotas_efec_matricula, " & vbCrLf &_
		   "	   '40' as max_cuotas_doc_colegiatura, " & vbCrLf &_
		   "	   '1' as max_cuotas_efec_colegiatura, " & vbCrLf &_
		   "       '5' as max_cuotas_matricula, " & vbCrLf &_
		   "	   '42' as max_cuotas_colegiatura " 

' consulta antes de modificar simulacion
consulta_2 = "select max(ncuotas_doc_matricula) as max_cuotas_doc_matricula, " & vbCrLf &_
           "       max(ncuotas_efec_matricula) as max_cuotas_efec_matricula, " & vbCrLf &_
		   "	   max(ncuotas_doc_colegiatura) as max_cuotas_doc_colegiatura, " & vbCrLf &_
		   "	   max(ncuotas_efec_colegiatura) as max_cuotas_efec_colegiatura, " & vbCrLf &_
		   "       max(ncuotas_matricula) as max_cuotas_matricula, " & vbCrLf &_
		   "	   max(ncuotas_colegiatura) as max_cuotas_colegiatura " & vbCrLf &_
		   "from vis_numero_cuotas"


		   
f_max_cuotas.Consultar consulta
'f_max_cuotas.Siguiente



'------------------------------------------------------------------------------------------
set postulante = new CPostulante
postulante.Inicializar conexion, q_post_ncorr

'------------------------------------------------------------------------------------------

set f_fecha_inicio = new CFormulario
f_fecha_inicio.Carga_Parametros "genera_contrato_2.xml", "fecha_inicio_pago"
f_fecha_inicio.Inicializar conexion

consulta = "select '' "
f_fecha_inicio.Consultar consulta
f_fecha_inicio.Siguiente

sql ="(select cast(a.fini_ndia as varchar(2))+'/' + cast(a.fini_nmes as varchar)+ '/' +cast(fini_anio as varchar) as fecha " & vbcrlf & _
"         from                     " & vbcrlf & _
"         (   select  a.fini_ndia, a.fini_nmes, " & vbcrlf & _
"             case  " & vbcrlf & _
"                 when  getdate() > '30/10/'+cast(year(getdate()) as varchar)  " & vbcrlf & _
"                 then year(getdate())+1 " & vbcrlf & _
"                 else  year(getdate()) " & vbcrlf & _
"             end as fini_anio " & vbcrlf & _
"             from  " & vbcrlf & _
"             (select fini_ndia, fini_nmes,  " & vbcrlf & _
"              convert (datetime,cast(fini_ndia as varchar)+'-'+cast(fini_nmes as varchar)+'-'+cast(year(getdate()) as varchar),103 ) as fecha " & vbcrlf & _
"              from             " & vbcrlf & _
"              fechas_inicio_pagos) a ) a) a " & vbcrlf 

'response.Write("<pre>"&sql&"</pre>")
f_fecha_inicio.AgregaCampoParam "fecha_inicio_pago","destino", sql

if b_contrato_generado then
	f_fecha_inicio.AgregaCampoParam "fecha_inicio_pago", "permiso", "OCULTO"
	f_detalle_pagos.AgregaCampoParam "sdpa_mmonto","permiso","LECTURA"
end if

'##//  VALIDACIONES DE CAE
consulta_fuas = "select count(*) " & vbCrLf &_
           "from sdescuentos " & vbCrLf &_
		   "where stde_ccod=1402 " & vbCrLf &_
		   "  and post_ncorr = '" & q_post_ncorr & "'"
		   
if CInt(conexion.ConsultaUno(consulta_fuas)) > 0 then
	b_existe_fuas = true
else
	b_existe_fuas = false
end if

sql_tubo_cae_upa="select case count(*) when 0 then 'N' else 'S' end as tiene from ufe_alumnos_cae a"& vbcrlf & _
"where anos_ccod = (select max(anos_ccod)as anos_ccod from ufe_alumnos_cae aa where aa.rut=a.rut)"& vbcrlf & _
"and rut=(select bb.pers_nrut from postulantes aa,personas bb where aa.PERS_NCORR=bb.PERS_NCORR and post_ncorr="&q_post_ncorr&")" & vbcrlf & _
"and 0=(select isnull((select case when socc_mmonto_solicitado=0 " & vbcrlf & _
						"then socc_mmonto_solicitado " & vbcrlf & _
						"else socc_mmonto_solicitado end as monto_cae " & vbcrlf & _
					"from solicitud_credito_cae where post_ncorr="&q_post_ncorr&" and ofer_ncorr="&v_ofer_ncorr&") , 0))"

tubo_cae_upa	=	conexion.consultaUno(sql_tubo_cae_upa) 


sql_monto_cae=  " select isnull((select case when socc_mmonto_solicitado=0 " & vbcrlf & _
				"		then socc_mmonto_solicitado " & vbcrlf & _
				"		else socc_mmonto_solicitado end as monto_cae " & vbcrlf & _
				"	from solicitud_credito_cae where post_ncorr="&q_post_ncorr&" and ofer_ncorr="&v_ofer_ncorr&") , 0) "

v_valor_cae	=	conexion.consultaUno(sql_monto_cae)  


if b_existe_fuas or Clng(v_valor_cae)>0 then
	msg_fuas="El alumno es beneficiario CAE, debe documentar una letra por el valor referencial de "&formatcurrency(v_valor_cae,0)&" que cubra el credito solicitado, el resto en 10 documentos o segun corresponda."
	espacios=msg_fuas&"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
	msg_fuas=espacios&msg_fuas
end if

if tubo_cae_upa="S"   then
	msg_fuas="El alumno es Renovante del Credito CAE, debe pasar por el modulo de admision y llenar la solicitud de credito CAE para matricularse."
	espacios=msg_fuas&"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
	msg_fuas=espacios&msg_fuas
end if

'pers_ncorr=conexion.consultaUno("select top 1 pers_ncorr from postulantes where post_ncorr="&q_post_ncorr)
'if pers_ncorr="98648" then
'	otro_msg="Debe dirigirse a cobranzas para regularizar situacion financiera (devolucion de cheques)."
'	espacios=otro_msg&"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
'	otro_msg=espacios&otro_msg
'end if

%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<style type="text/css">
input.suma {
background-color:#D8D8DE;
border:0;
text-align:left;
}
</style>

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

var total_matricula;
var total_arancel;
var centinela_num_tar=0;
// Controla que los montos digitados en la simulacion cuandren con el total a pagar.
function ValidarCuotasPago()
{
<% if not b_contrato_generado then %>
var formulario = document.forms["detalle_pagos"];
suma_cuotas = 0;
total_cuotas = <%=total_det_pag%>;
//alert(total_cuotas);
for (var i = 0; i < <%=f_detalle_pagos.NroFilas%>; i++) {
		if ((formulario.elements["detalle_pagos[" +i + "][c_ting_ccod]"].value==3) || (formulario.elements["detalle_pagos[" +i + "][c_ting_ccod]"].value==4) || (formulario.elements["detalle_pagos[" +i + "][c_ting_ccod]"].value==52)|| (formulario.elements["detalle_pagos[" +i + "][c_ting_ccod]"].value==13)|| (formulario.elements["detalle_pagos[" +i + "][c_ting_ccod]"].value==51)|| (formulario.elements["detalle_pagos[" +i + "][c_ting_ccod]"].value==59) || (formulario.elements["detalle_pagos[" +i + "][c_ting_ccod]"].value==66) ) 
			{
			suma_cuotas += parseInt(formulario.elements["detalle_pagos[" +i + "][sdpa_mmonto]"].value);
			//valor_aux_01 = parseInt(formulario.elements["detalle_pagos[" +i + "][sdpa_mmonto]"].value);
			//alert("valor edit "+i+" - "+valor_aux_01)	
			}
		else
			{
			suma_cuotas += parseInt(formulario.elements["detalle_pagos[" +i + "][c_sdpa_mmonto]"].value);
			//valor_aux = parseInt(formulario.elements["detalle_pagos[" +i + "][c_sdpa_mmonto]"].value);
			//alert("valor NO edit "+i+" - "+valor_aux)	
			}
		//alert("arancel "+total_arancel);
		v_objeto_fecha=formulario.elements["detalle_pagos[" +i+ "][sdpa_fvencimiento]"];
		if(v_objeto_fecha){
			v_fecha_pago_simulacion=v_objeto_fecha.value;
			if (FechaMayorHoy(v_fecha_pago_simulacion)==false){
				v_objeto_fecha.focus();
				return false;
			}				
		}
	}
//alert("suma "+suma_cuotas)	
//return false;
if	(total_cuotas == suma_cuotas)	
	{
	return true;
	}
if	(total_cuotas > suma_cuotas)	
	{
	alert ("El monto de las cuotas de los documentos es inferior a lo que se debe documentar.");
	}
else
	{
	alert ("El monto de las cuotas de los documentos excede a lo que se debe documentar.");
	}	
return false;
<%else%>	
return true;
<%end if%>
}
function VerificaNumerosTarjeta(objeto){
	if (objeto.value.length == 4) 
		return true;
	if 	(centinela_num_tar<1){
		centinela_num_tar++;
		if (objeto.value.length < 4) {
			alert("Debe ingresar al menos los ultimos 4 digitos de la tarjeta seleccionada");
			objeto.focus();
			return false;
		}
		else
			return true;
	}
	else
		centinela_num_tar=0;

}

function CalcularTotalMatriculaArancel()
{
	var formulario = document.forms["valores"];
	
	total_matricula = 0;
	total_arancel = 0;
	
	for (var i = 0; i < <%=f_tabla_valores.NroFilas%>; i++) {
		total_matricula += parseInt(formulario.elements["valores["  +i + "][c_matricula]"].value);
		total_arancel += parseInt(formulario.elements["valores["  +i + "][c_arancel]"].value);
	}
	
}


function ValidarFormaPago()
{		
	var formulario = document.forms["forma_pago"];
	var v_mmatricula = 0;
	var v_mcolegiatura = 0;		

	
	/********************************************************************************************************/	
	if (total_matricula < 0) {
		alert('Monto a pagar en matrícula no puede ser negativo.\nVerificar los descuentos autorizados.');
		return false;
	}
	
	if (total_arancel < 0) {
		alert('Monto a pagar en arancel no puede ser negativo.\nVerificar los descuentos autorizados.');
		return false;
	}
	
	
	/********************************************************************************************************/	
	var ncuotas_doc_matricula = 0;
	var ncuotas_efec_matricula = 0;
	var ncuotas_matricula = 0;
	var ncuotas_doc_colegiatura = 0;
	var ncuotas_efec_colegiatura = 0;
	var ncuotas_colegiatura = 0;
	
	for (var i = 0; i < tabla_fp_matricula.filas.length; i++) {
		if (tabla_fp_matricula.filas[i].campos["butiliza"].objeto.value == 'S') {
			//ting_ccod=51 debito o pago redcompra, o similar (efectivo)
			if ((tabla_fp_matricula.filas[i].campos["ting_ccod"].objeto.value == '51')||(tabla_fp_matricula.filas[i].campos["ting_ccod"].objeto.value == '13')) {		
				if	(!VerificaNumerosTarjeta(formulario.elements["fp_matricula[" + i + "][sdfp_tctacte]"]))
					return false;
				
			}
			if ((tabla_fp_matricula.filas[i].campos["ting_ccod"].objeto.value != '6')&&(tabla_fp_matricula.filas[i].campos["ting_ccod"].objeto.value != '51')) {		
				// si es pago con credito se considera una cuota
				//ting_ccod=13 -> tarjeta de credito , una sola cuota independiente de la pactacion
				if(tabla_fp_matricula.filas[i].campos["ting_ccod"].objeto.value=='13'){
					ncuotas_doc_matricula = ncuotas_doc_matricula +1; 
				}else{
					ncuotas_doc_matricula += parseInt(tabla_fp_matricula.filas[i].campos["stpa_ncuotas"].objeto.value);
				}
				
			}
			else {
					ncuotas_efec_matricula += parseInt(tabla_fp_matricula.filas[i].campos["stpa_ncuotas"].objeto.value);
			}
		}
	}
	//alert("Documentado :"+ncuotas_doc_matricula);
	ncuotas_matricula = parseInt(ncuotas_doc_matricula);
	if (ncuotas_doc_matricula > t_max_cuotas.filas[0].campos["max_cuotas_doc_matricula"].objeto.value) {
		alert('Cantidad de cuotas con documento para matrícula no puede ser superior a ' + t_max_cuotas.filas[0].campos["max_cuotas_doc_matricula"].objeto.value + '.');
		return false;
	}
	
	if (ncuotas_efec_matricula > t_max_cuotas.filas[0].campos["max_cuotas_doc_matricula"].objeto.value) {
		alert('Cantidad de cuotas en efectivo para matrícula no puede ser superior a ' + t_max_cuotas.filas[0].campos["max_cuotas_doc_matricula"].objeto.value + '.');
		return false;
	}	

	if (ncuotas_matricula > t_max_cuotas.filas[0].campos["max_cuotas_matricula"].objeto.value) {
		alert('Cantidad de cuotas para matrícula no puede ser superior a ' + t_max_cuotas.filas[0].campos["max_cuotas_doc_matricula"].objeto.value + '.');
		return false;
	}
	
	
	for (var i = 0; i < tabla_fp_colegiatura.filas.length; i++) {
		if (tabla_fp_colegiatura.filas[i].campos["butiliza"].objeto.value == 'S') {
			if ((tabla_fp_colegiatura.filas[i].campos["ting_ccod"].objeto.value == '51')||(tabla_fp_colegiatura.filas[i].campos["ting_ccod"].objeto.value == '13')) {		
				if	(!VerificaNumerosTarjeta(formulario.elements["fp_colegiatura[" + i + "][sdfp_tctacte]"]))
					return false;
			}
			//alert(tabla_fp_colegiatura.filas[i].campos["ting_ccod"].objeto.value);
			if ((tabla_fp_colegiatura.filas[i].campos["ting_ccod"].objeto.value != '6')&&(tabla_fp_colegiatura.filas[i].campos["ting_ccod"].objeto.value != '51')) {		
				// si es pago con credito se considera una cuota
				//ting_ccod=13 -> tarjeta de credito , una sola cuota independiente de la pactacion
				if(tabla_fp_colegiatura.filas[i].campos["ting_ccod"].objeto.value == '13'){
					ncuotas_doc_colegiatura = ncuotas_doc_colegiatura + 1;
				}else{	
					ncuotas_doc_colegiatura += parseInt(tabla_fp_colegiatura.filas[i].campos["stpa_ncuotas"].objeto.value);
				}	
			}
			else {
				
				ncuotas_efec_colegiatura += parseInt(tabla_fp_colegiatura.filas[i].campos["stpa_ncuotas"].objeto.value);
			}
		}
	}
	//alert("Monto cuotas arancel :"+ncuotas_doc_colegiatura);
	ncuotas_colegiatura = parseInt(ncuotas_doc_colegiatura);
	// + parseInt(ncuotas_efec_colegiatura);
		
	if (ncuotas_doc_colegiatura > t_max_cuotas.filas[0].campos["max_cuotas_doc_colegiatura"].objeto.value) {
		alert('Cantidad de cuotas con documento para arancel no puede ser superior a ' + t_max_cuotas.filas[0].campos["max_cuotas_doc_colegiatura"].objeto.value + '.');
		return false;
	}
	
	if (ncuotas_efec_colegiatura > t_max_cuotas.filas[0].campos["max_cuotas_doc_colegiatura"].objeto.value) {
		alert('Cantidad de cuotas en efectivo para arancel no puede ser superior a ' + t_max_cuotas.filas[0].campos["max_cuotas_doc_colegiatura"].objeto.value + '.');
		return false;
	}	
	
	if (ncuotas_colegiatura > t_max_cuotas.filas[0].campos["max_cuotas_colegiatura"].objeto.value) {
		alert('Cantidad de cuotas para arancel no puede ser superior a ' + t_max_cuotas.filas[0].campos["max_cuotas_doc_colegiatura"].objeto.value + '.');
		return false;
	}	
	
	
	
	/********************************************************************************************************/	
	for (var i = 0; i < <%=f_forma_pago_matricula.NroFilas%>; i++) {
		v_sdfp_ncuotas = parseInt(formulario.elements["fp_matricula[" + i + "][stpa_ncuotas]"].value);
		v_sdfp_mmonto = parseInt(formulario.elements["fp_matricula[" + i + "][sdfp_mmonto]"].value);
		
		if (v_sdfp_mmonto < 0) {			
			alert('Monto no puede ser negativo.');
			formulario.elements["_fp_matricula[" + i + "][sdfp_mmonto]"].focus();
			return false;
		}		
		v_mmatricula += parseInt(formulario.elements["fp_matricula[" + i + "][sdfp_mmonto]"].value);
				
		if ( (v_sdfp_ncuotas == 0) && (v_sdfp_mmonto != 0) ) {			
			alert('Si el número de cuotas es 0, el monto también debe ser $0.');
			formulario.elements["fp_matricula[" + i + "][stpa_ncuotas]"].select();
			return false;
		}
		
		if ((tabla_fp_matricula.filas[i].campos["butiliza"].objeto.value == 'S') && (v_sdfp_mmonto == 0)) {
			alert('Si va a utilizar esta forma de pago, monto a pagar debe ser mayor que $0.');
			tabla_alt_fp_matricula.filas[i].campos["sdfp_mmonto"].objeto.select();			
			return false;
		}
		
		v_fecha_pago=tabla_fp_matricula.filas[i].campos["sdfp_finicio_pago"].objeto.value;
		if (FechaMayorHoy(v_fecha_pago)==false){
			tabla_fp_matricula.filas[i].campos["sdfp_finicio_pago"].objeto.focus();
			return false;
		}

	}
	
	if (total_matricula != v_mmatricula) {
		alert ('El total de la matrícula debe ser igual a $ ' + total_matricula + ' ($ ' + v_mmatricula + ').');
		formulario.elements["_suma_fp_matricula[0][total_actual]"].focus();
		return false;
	}	
	
	/*****************************************************************************************************************/		
	for (var i = 0; i < <%=f_forma_pago_colegiatura.NroFilas%>; i++) {
		v_sdfp_ncuotas = parseInt(formulario.elements["fp_colegiatura[" + i + "][stpa_ncuotas]"].value);
		v_sdfp_mmonto = parseInt(formulario.elements["fp_colegiatura[" + i + "][sdfp_mmonto]"].value);
		
		if (v_sdfp_mmonto < 0) {
			alert('Monto no puede ser negativo.');
			formulario.elements["_fp_colegiatura[" + i + "][sdfp_mmonto]"].focus();
			return false;
		}
		
		v_mcolegiatura += parseInt(formulario.elements["fp_colegiatura[" + i + "][sdfp_mmonto]"].value);		
				
		if ( (v_sdfp_ncuotas == 0) && (v_sdfp_mmonto != 0) ) {
			alert('Si el número de cuotas es 0, el monto también debe ser $0.');
			formulario.elements["fp_colegiatura[" + i + "][stpa_ncuotas]"].select();
			return false;
		}
		
		if ((tabla_fp_colegiatura.filas[i].campos["butiliza"].objeto.value == 'S') && (v_sdfp_mmonto == 0)) {
			alert('Si va a utilizar esta forma de pago, monto a pagar debe ser mayor que $0. ');
			formulario.elements["_fp_colegiatura[" + i + "][sdfp_mmonto]"].select();
			return false;
		}
		
		v_fecha_pago=tabla_fp_colegiatura.filas[i].campos["sdfp_finicio_pago"].objeto.value;
		if (FechaMayorHoy(v_fecha_pago)==false){
			tabla_fp_colegiatura.filas[i].campos["sdfp_finicio_pago"].objeto.focus();
			return false;
		}
	}
	
	if (total_arancel != v_mcolegiatura) {
		alert ('El total del arancel debe ser igual a $ ' + total_arancel + ' ($ ' + v_mcolegiatura + ').');
		formulario.elements["_suma_fp_colegiatura[0][total_actual]"].focus();
		return false;
	}
	
	/***********************************************************************************************************/

	return true;
}




function sdfp_mmonto_blur(objeto)
{
	var formulario = document.forms["forma_pago"];
	var nfilas_fmatricula = parseInt('<%=f_forma_pago_matricula.NroFilas%>');
	var nfilas_fcolegiatura = parseInt('<%=f_forma_pago_colegiatura.NroFilas%>');
	
	var nfilas;
	var str_variable;
	var str_variable_suma;
	var suma = 0;
	
	if (objeto.name.search(/fp_matricula/) >= 0) {
		str_variable = "fp_matricula";
		nfilas = nfilas_fmatricula;		
		str_variable_suma = "suma_fp_matricula"
	}
	else {
		str_variable = "fp_colegiatura";
		nfilas = nfilas_fcolegiatura;
		str_variable_suma = "suma_fp_colegiatura"
	}
	
	
	for (var i = 0; i < nfilas; i++) {
		suma += parseInt(formulario.elements[str_variable + "[" + i + "][sdfp_mmonto]"].value);
	}
	
	formulario.elements[str_variable_suma + "[0][total_actual]"].value = suma;
	formulario.elements[str_variable_suma + "[0][diferencia]"].value = suma - formulario.elements[str_variable_suma + "[0][total_pagar]"].value;	
	
	formulario.elements["_" + str_variable_suma + "[0][total_actual]"].focus();
	formulario.elements["_" + str_variable_suma + "[0][total_actual]"].blur();
	formulario.elements["_" + str_variable_suma + "[0][diferencia]"].focus();
	formulario.elements["_" + str_variable_suma + "[0][diferencia]"].blur();
}



function ObtenerValorCampoHabilitadoFilaAnterior(p_fila, p_tabla, p_campo)
{
	for (var i = p_fila; i >= 0; i--)
	 {
		//alert("fila : " + i + " , campo : " + p_campo + " ---> " + p_tabla.filas[i].campos[p_campo].objeto.getAttribute("disabled"));
		
		if (p_tabla.filas[i].ExisteCampo(p_campo))
		  if ((!p_tabla.filas[i].campos[p_campo].objeto.getAttribute("disabled")))
		   {
			 return p_tabla.ObtenerValor(i, p_campo);
		   }	
	}
	
	return "0";
}


function ObtenerFechaFilaAnterior(p_fila, p_tabla)
{
	return (ObtenerValorCampoHabilitadoFilaAnterior(p_fila, p_tabla, "sdfp_finicio_pago"));
}

function ObtenerFrecuenciaFilaAnterior(p_fila, p_tabla)
{
	return (ObtenerValorCampoHabilitadoFilaAnterior(p_fila, p_tabla, "sdfp_nfrecuencia"));
}


/*************************************************************************************************************************/
function HabilitarFila(p_variable, p_fila, p_habilitado)
{
	var tabla, tabla_alt, tabla_suma, estado,v_usa_lector;
	var v_tipo_ingreso="";
	
		 
	switch (p_variable) {
		case "fp_matricula" :
			tabla = tabla_fp_matricula;
			tabla_alt = tabla_alt_fp_matricula;
			tabla_suma = t_suma_fp_matricula;
			estado = "matricula";
			break;
			
		case "fp_colegiatura" :
			tabla = tabla_fp_colegiatura;		
			tabla_alt = tabla_alt_fp_colegiatura;
			tabla_suma = t_suma_fp_colegiatura;
			estado = "colegiatura";
			break;
	}
	
	
	if (p_habilitado) {
		//tabla.filas[p_fila].campos["stpa_ncuotas"].objeto.value = '';
		tabla.filas[p_fila].campos["sdfp_mmonto"].objeto.value = '0';	
		tabla.filas[p_fila].campos["sdfp_finicio_pago"].objeto.value = '';	
		
		if (tabla.filas[p_fila].ExisteCampo("sdfp_nfrecuencia")) {
			tabla.filas[p_fila].campos["sdfp_nfrecuencia"].objeto.value = tabla.filas[p_fila].campos["sdfp_nfrecuencia"].valorInicial;			
		}
		
		if (tabla.filas[p_fila].ExisteCampo("sdfp_ndocto_inicial")) {
			tabla.filas[p_fila].campos["sdfp_ndocto_inicial"].objeto.value = tabla.filas[p_fila].campos["sdfp_ndocto_inicial"].valorInicial;
		}
		
		if (tabla.filas[p_fila].ExisteCampo("banc_ccod")) {
			v_usa_lector=true;
			tabla.filas[p_fila].campos["banc_ccod"].objeto.value = tabla.filas[p_fila].campos["banc_ccod"].valorInicial;
		}
				
		if (tabla.filas[p_fila].ExisteCampo("plaz_ccod")) {		
			tabla.filas[p_fila].campos["plaz_ccod"].objeto.value = tabla.filas[p_fila].campos["plaz_ccod"].valorInicial;
		}
				
	}
	else
	 {
		var frecuencia_anterior = "";
		var cant_cuotas = 1;
		
		v_tipo_ingreso = tabla.filas[p_fila].campos["ting_ccod"].objeto;
		
		
		var fecha_efectivo =  tabla.filas[0].campos["sdfp_finicio_pago"].objeto.value;
		var cuotas_efectivo =  tabla.filas[0].campos["stpa_ncuotas"].objeto.value;
		
		if (fecha_efectivo != "")
		  {
		    if (estado == "matricula") 
			{
			  var arr_fecha_efectivo = fecha_efectivo.split(/\//);
			  var dia1  =  arr_fecha_efectivo[0];
		      var mes1  =  arr_fecha_efectivo[1];
			  var anio1 =  arr_fecha_efectivo[2];
			
				nueva_fecha1 = new Date(anio1, mes1, dia1);
				
				dia1  = nueva_fecha1.getDate();
				mes1  =  nueva_fecha1.getMonth() + parseInt(cuotas_efectivo);
				anio1 =  nueva_fecha1.getFullYear();
						
				if (dia1 < 10)
					dia1 = "0" + dia1; 
				if (mes1 < 10)
					mes1 = "0" + mes1;
					
				var fecha_anterior = dia1 + "/" + mes1 + "/" + anio1;
            }						
			frecuencia_anterior = "0";  //para que no coloque la fecha actual como fecha de inicico en la letra o cheque
		  }
		
		//obtiene frecuencia, cuotas y fecha anterior    		
		for (var i = p_fila; i >= 0; i--)
	    {
		  if (tabla.filas[i].ExisteCampo("sdfp_nfrecuencia") == true)
		    if (tabla.filas[i].campos["sdfp_nfrecuencia"].objeto.getAttribute("disabled") == false )
			    {
				  frecuencia_anterior = tabla.filas[i].campos["sdfp_nfrecuencia"].objeto.value;			   
				  cant_cuotas =  tabla.filas[i].campos["stpa_ncuotas"].objeto.value;
				  fecha_anterior =  tabla.filas[i].campos["sdfp_finicio_pago"].objeto.value;
				}
		 }
		//alert(estado);
		
	  
	   
	   if (frecuencia_anterior == 0 )
		  {
		  	//alert("frecuencia 0 ");
		    if (p_fila != 0) 
			{
			  if (estado == "matricula")
 			    {
				  
				  if ((fecha_efectivo == "")||(v_tipo_ingreso.value==6)||(v_tipo_ingreso.value==13)||(v_tipo_ingreso.value==51))
				    tabla.filas[p_fila].campos["sdfp_finicio_pago"].objeto.value = '<%=fc_datos.ObtenerValor("fecha_actual")%>';  
					
			      else
				    tabla.filas[p_fila].campos["sdfp_finicio_pago"].objeto.value = fecha_anterior = dia1 + "/" + mes1 + "/" + anio1;
					
				}
			  else
			   {
			     var f_inicio = document.forma_pago.elements["fecha_inicio[0][fecha_inicio_pago]"].value //+ "/" + arr_f_actual[2];
                 tabla.filas[p_fila].campos["sdfp_finicio_pago"].objeto.value = f_inicio;
				 if ((v_tipo_ingreso.value==6)||(v_tipo_ingreso.value==13)||(v_tipo_ingreso.value==51)) // fecha actual para efectivo y tarjeta debito
				 	tabla.filas[p_fila].campos["sdfp_finicio_pago"].objeto.value = '<%=fc_datos.ObtenerValor("fecha_actual")%>';
			   }
			}
			else{
			  if (v_tipo_ingreso.value==52){
					diap=25;
					mesp='02';
					var f_inicio = document.forma_pago.elements["fecha_inicio[1][fecha_inicio_pago]"].value;
					var arr_fecha_pag = f_inicio.split(/\//); 
					var aniop =  arr_fecha_pag[2];
					tabla.filas[p_fila].campos["sdfp_finicio_pago"].objeto.value = diap + "/" + mesp + "/" + aniop;
				}else{
				 	tabla.filas[p_fila].campos["sdfp_finicio_pago"].objeto.value = '<%=fc_datos.ObtenerValor("fecha_actual")%>';	      
			  	}
			}  
		  }
	   else
		  {
		  //alert("otra frecuencia");
		   		cant_meses = parseInt(cant_cuotas) * parseInt(frecuencia_anterior);
				var arr_fecha = fecha_anterior.split(/\//);
				var dia  =  arr_fecha[0];
				var mes  =  arr_fecha[1];
				var anio =  arr_fecha[2];
				mes = mes - 1;
				mes = mes + cant_meses;		
				nueva_fecha = new Date(anio, mes, dia);
				
				dia = nueva_fecha.getDate();
				mes  =  nueva_fecha.getMonth() + 1;
				anio =  nueva_fecha.getFullYear();
			
				if (dia < 10)
					dia = "0" + dia; 
				if (mes < 10)
					mes = "0" + mes; 
				
				if ((v_tipo_ingreso.value==6)||(v_tipo_ingreso.value==13)||(v_tipo_ingreso.value==51)){
				    tabla.filas[p_fila].campos["sdfp_finicio_pago"].objeto.value = '<%=fc_datos.ObtenerValor("fecha_actual")%>';  
					
				}else{					

					tabla.filas[p_fila].campos["sdfp_finicio_pago"].objeto.value = dia + "/" + mes + "/" + anio;		  			 

				}
			}
			
		    
		tabla.filas[p_fila].campos["sdfp_mmonto"].objeto.value = -1 * (tabla_suma.filas[0].campos["diferencia"].objeto.value);
	}
	
	enMascara(tabla_alt.filas[p_fila].campos["sdfp_mmonto"].objeto, "MONEDA", 0);		
	sdfp_mmonto_blur(tabla_alt.filas[p_fila].campos["sdfp_mmonto"].objeto);
	
	
	tabla.filas[p_fila].Habilitar(!p_habilitado);	
	
	for (var i = 0; i < tabla_alt.filas[p_fila].campos.length; i++) {
		if (tabla_alt.filas[p_fila].campos[i].nombreCampo != "butiliza") {
			tabla_alt.filas[p_fila].campos[i].objeto.setAttribute("disabled", p_habilitado)
		}
	}
	
	
		
	
}


function butiliza_click(objeto)
{	

	nombre=objeto.name;
	variable=_ObtenerVariableCampo(objeto);
	v_indice_docto=extrae_indice(nombre);
	var v_indice='';
	if ((nombre=="_fp_colegiatura[0][butiliza]")||(nombre=="_fp_colegiatura[1][butiliza]")){ 
		
		//---------------------------------------------------------------------------------------------
		// DESHABILITA LAS OTRAS FORMAS DE PAGO QUE NO SEAN TRANSBANK  O MULTIDEBITO
				if (v_indice_docto==1){
						elemento0=document.forma_pago.elements["_fp_colegiatura[0][butiliza]"];
						elemento0.checked=false;
						cambiaOculto(elemento0, 'S', 'N')
						HabilitarFila(_ObtenerVariableCampo(elemento0), _FilaCampo(elemento0), !elemento0.checked);
				}else{
						elemento1=document.forma_pago.elements["_fp_colegiatura[1][butiliza]"];
						elemento1.checked=false;
						cambiaOculto(elemento1, 'S', 'N')
						HabilitarFila(_ObtenerVariableCampo(elemento1), _FilaCampo(elemento1), !elemento1.checked);
				}		
				elemento2=document.forma_pago.elements["_fp_colegiatura[2][butiliza]"];
				elemento2.checked=false;
				cambiaOculto(elemento2, 'S', 'N')
				HabilitarFila(_ObtenerVariableCampo(elemento2), _FilaCampo(elemento2), !elemento2.checked);
				
				elemento3=document.forma_pago.elements["_fp_colegiatura[3][butiliza]"];
				elemento3.checked=false;
				cambiaOculto(elemento3, 'S', 'N')
				HabilitarFila(_ObtenerVariableCampo(elemento3), _FilaCampo(elemento3), !elemento3.checked);
				
				elemento4=document.forma_pago.elements["_fp_colegiatura[4][butiliza]"];
				elemento4.checked=false;
				cambiaOculto(elemento4, 'S', 'N')
				HabilitarFila(_ObtenerVariableCampo(elemento4), _FilaCampo(elemento4), !elemento4.checked);
				
				elemento5=document.forma_pago.elements["_fp_colegiatura[5][butiliza]"];
				elemento5.checked=false;
				cambiaOculto(elemento5, 'S', 'N')
				HabilitarFila(_ObtenerVariableCampo(elemento5), _FilaCampo(elemento5), !elemento5.checked);
				
				elemento6=document.forma_pago.elements["_fp_colegiatura[6][butiliza]"];
				elemento6.checked=false;
				cambiaOculto(elemento6, 'S', 'N')
				HabilitarFila(_ObtenerVariableCampo(elemento6), _FilaCampo(elemento6), !elemento6.checked);				

		//---------------------------------------------------------------------------------------------
		
			HabilitarFila(_ObtenerVariableCampo(objeto), _FilaCampo(objeto), !objeto.checked);
	}else {

		if(variable=="fp_colegiatura"){
			//---------------------------------------------------------------------------------------------
			// DESHABILITA  EL PAGO CON TRANSBANK Y CON MULTIDEBITO
				
				elemento0=document.forma_pago.elements["_fp_colegiatura[0][butiliza]"];
				elemento0.checked=false;
				cambiaOculto(elemento0, 'S', 'N')
				HabilitarFila(_ObtenerVariableCampo(elemento0), _FilaCampo(elemento0), !elemento0.checked);

				elemento1=document.forma_pago.elements["_fp_colegiatura[1][butiliza]"];
				elemento1.checked=false;
				cambiaOculto(elemento1, 'S', 'N')
				HabilitarFila(_ObtenerVariableCampo(elemento1), _FilaCampo(elemento1), !elemento1.checked);				
			
			//---------------------------------------------------------------------------------------------	
		}	
		HabilitarFila(_ObtenerVariableCampo(objeto), _FilaCampo(objeto), !objeto.checked);
		
	}

	if(objeto.checked){
		v_indice=_FilaCampo(objeto);
		v_variable=_ObtenerVariableCampo(objeto);
		tipo_ingreso=document.forma_pago.elements[v_variable+"["+v_indice+"][ting_ccod]"];
		
		if (tipo_ingreso.value==3){
			activa_pago(tipo_ingreso,v_variable)
		}
	}
}

var tabla_fp_matricula;
var tabla_alt_fp_matricula;
var tabla_fp_colegiatura;
var tabla_alt_fp_colegiatura;
var t_suma_fp_matricula;
var t_suma_fp_colegiatura;
var t_suma_alt_fp_matricula;
var t_suma_alt_fp_colegiatura;

var t_max_cuotas;


var str_fecha = '<%=fc_datos.ObtenerValor("fecha_actual")%>';


function InicioPagina()
{	
	CalcularTotalMatriculaArancel();
	
	tabla_fp_matricula = new CTabla("fp_matricula");
	tabla_alt_fp_matricula = new CTabla("_fp_matricula");
	tabla_fp_colegiatura = new CTabla("fp_colegiatura");
	tabla_alt_fp_colegiatura = new CTabla("_fp_colegiatura");
	t_suma_fp_matricula = new CTabla("suma_fp_matricula");
	t_suma_fp_colegiatura = new CTabla("suma_fp_colegiatura");
	t_suma_alt_fp_matricula = new CTabla("_suma_fp_matricula");
	t_suma_alt_fp_colegiatura = new CTabla("_suma_fp_colegiatura");	
	t_max_cuotas = new CTabla("max_cuotas")	

	t_suma_alt_fp_matricula.filas[0].campos["total_actual"].objeto.className = 'suma';
	t_suma_alt_fp_matricula.filas[0].campos["total_pagar"].objeto.className = 'suma';
	t_suma_alt_fp_matricula.filas[0].campos["diferencia"].objeto.className = 'suma';	
	t_suma_alt_fp_colegiatura.filas[0].campos["total_actual"].objeto.className = 'suma';	
	t_suma_alt_fp_colegiatura.filas[0].campos["total_pagar"].objeto.className = 'suma';	
	t_suma_alt_fp_colegiatura.filas[0].campos["diferencia"].objeto.className = 'suma';	
		
}


//--------------------------------------------------------------------------------//
//------------------	LECTURA DE CHEQUES CON LECTOR MAGNETICO 	--------------//
var conteo=0;
function activa_pago(elemento,variable){
//document.detalle.receptaculo.value="";
valor=elemento.value;
v_indice=extrae_indice(elemento.name);
v_variable=variable;
//v_indice=0;
	if (valor==3) {
		if(confirm("Puede ingresar los datos del documento utilizando el lector de magnetico,\nPresione Aceptar e intruduzca el documento.\nPresione Cancelar para ingresarlos manualmente.")){
			document.forma_pago.elements[v_variable+"["+v_indice+"][receptaculo]"].value="";
			document.forma_pago.elements[v_variable+"["+v_indice+"][sdfp_ndocto_inicial]"].value="";
			document.forma_pago.elements[v_variable+"["+v_indice+"][sdfp_tctacte]"].value="";
			document.forma_pago.elements[v_variable+"["+v_indice+"][plaz_ccod]"].value="";
			document.forma_pago.elements[v_variable+"["+v_indice+"][banc_ccod]"].value="";
			document.forma_pago.elements[v_variable+"["+v_indice+"][sdfp_tplaza_sbif]"].value="";
			document.forma_pago.elements[v_variable+"["+v_indice+"][receptaculo]"].focus();
		}else{
			document.forma_pago.elements[v_variable+"["+v_indice+"][sdfp_ndocto_inicial]"].focus();
		}
	}
}

function  extrae_indice(cadena){
	var posicion1 = cadena.indexOf("[",0)+1;
	var posicion2 = cadena.indexOf("]",0);
	var indice=cadena.substring(posicion1, posicion2);
	return indice;
}

//realiza los calculos cuando se quita el foco
function verifica_lectura(objeto){
valor=objeto.value;
conteo=0;
v_indice=extrae_indice(objeto.name);
	if (valor==""){
		v_opcion_elegida=confirm("El documento intruducido no ha sido leido correctamente.\nPresione Aceptar para volver a intentarlo,\nCancelar para ingresarlo en forma manual");
		if(v_opcion_elegida){
			objeto.focus();
		}else{
			//document.detalle.receptaculo.focus();
			document.forma_pago.elements[v_variable+"["+v_indice+"][sdfp_ndocto_inicial]"].focus();
		}
	}else{
		//alert("calculando..."+valor);
		convierte_codigo(valor,v_indice);
	}
}

function  captura_saltos(objeto){
	if(window.event.keyCode==13){
		conteo=conteo+1;
		if(conteo==4){
			v_indice=extrae_indice(objeto.name);
			document.forma_pago.elements[v_variable+"["+v_indice+"][sdfp_finicio_pago]"].focus();
		}
	}
}

function convierte_codigo(cadena,indice){
	var serie_cheque=cadena;
	var array_cheque=serie_cheque.split("\n");
	var banco='';
	var plaza=2; //otras plazas, por defecto
	var v_sede='<%=sede%>';
	// codigos de las plazas
	
	var melipilla 	=376;
	var talagante 	=368;
	var san_bernardo=344;
	var santiago	=320;

	n_cheque=   parseFloat(Trim(array_cheque[0]));
	v_banco	=	parseFloat(Trim(array_cheque[1]));
	v_plaza	=	parseFloat(Trim(array_cheque[2]));
	cta_cte	=	parseFloat(Trim(array_cheque[3]));
	
if (v_banco>0){
	banco=v_banco;
}else{
	banco='';
}

switch(v_sede){
// traduccionde codigo sbif para las plazas de los bancos
//plaza (1= misma, 2= otras)
		 case   '1': if(v_plaza==santiago)	{plaza=1;}else{plaza=2;} break;
		 case   '2': if(v_plaza==santiago)	{plaza=1;}else{plaza=2;} break;
		 case   '3': if(v_plaza==santiago)	{plaza=1;}else{plaza=2;} break;
		 case   '8': if(v_plaza==santiago)	{plaza=1;}else{plaza=2;} break;
		 case   '4': if(v_plaza==melipilla)	{plaza=1;}else{plaza=2;} break;
		 case   '5': if(v_plaza==talagante)	{plaza=1;}else{plaza=2;} break;
		 case   '6': if(v_plaza==san_bernardo){plaza=1;}else{plaza=2;} break;
}

	document.forma_pago.elements[v_variable+"["+indice+"][sdfp_ndocto_inicial]"].value=n_cheque;
	document.forma_pago.elements[v_variable+"["+indice+"][sdfp_tctacte]"].value=cta_cte;
	document.forma_pago.elements[v_variable+"["+indice+"][banc_ccod]"].value=banco;
	document.forma_pago.elements[v_variable+"["+indice+"][plaz_ccod]"].value=plaza;
	document.forma_pago.elements[v_variable+"["+indice+"][sdfp_tplaza_sbif]"].value=v_plaza;
	//alert(document.forma_pago.elements[v_variable+"["+v_indice+"][ding_tplaza_sbif]"].value);
	this.value="";
	alert("OK!!");
}
//--------------------------------------------------------------------------------//
//--------------------------	FIN LECTURA DE CHEQUES	--------------------------//
	


function FechaMayorHoy(fecha_comparable){

var v_fecha = new Date();
	dia=v_fecha.getDate();
	mes=v_fecha.getMonth()+1;
	agno=v_fecha.getFullYear();
	if (dia<10){dia='0'+dia;}

array_pag=fecha_comparable.split('/');

dia_pag  = array_pag[0];
mes_pag  = array_pag[1];
agno_pag = array_pag[2];

// con formatos mm/dd/yyyy
fecha_pag=mes_pag+'/'+dia_pag+'/'+agno_pag;
sysdate=mes+'/'+dia+'/'+agno;

// convertir a milisegundos
m_sysdate = Date.parse(sysdate);
m_fecha_ingresada= Date.parse(fecha_pag);


diferencia=eval(m_fecha_ingresada-m_sysdate);

	if (diferencia<0){
		dias = eval(Math.round(diferencia/86400000))*-1;
		if (dias >=1){
			v_respuesta='La fecha ingresada es demasiado antigua.\nExisten '+dias+' dias de desfase para la fecha actual. \n\n!!Debe ingresar como minimo la fecha atual¡¡';
			alert(v_respuesta);
			return false;
		}
	}


}


</script>

</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Forma de pago", "Generar contrato", "Imprimir"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br><br><br>
                </div>              
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Datos del postulante"%>
						<%postulante.DibujaDatos %>
						   
                        <br>
					      <form name="valores">
                          <div align="center">						
                            <%f_tabla_valores.DibujaTabla %>
						    <%'postulante.DibujaTablaValores%></div>
						  </form>
						    <form name="edicion">
						    <%pagina.DibujarSubtitulo "Descuentos"%>                        
						    <div align="center">  
						    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                              <tr>
                                <td><div align="center">
                                      <%f_descuentos.DibujaTabla%>
                                </div></td>
                              </tr>
                              <tr>
                                <td><br>
                                  <table width="180"  border="0" align="right" cellpadding="0" cellspacing="0">
                                  <tr>
                                    <td><div align="center">
                                        <%f_botonera.DibujaBoton("agregar_descuento")%>
                                    </div></td>
                                    <td><div align="center">
                                        <%f_botonera.DibujaBoton("eliminar_descuento")%>
                                    </div></td>
                                  </tr>
                                </table>
							    </td>
                              </tr>
                            </table>
						     </div>
						    </form>
						     <marquee><font color="#FF0000" size="3" style="font-style:italic; font-weight:bold; text-decoration:blink"><%=msg_fuas%><%=otro_msg%></font></marquee>
					  				    
						 <form name="forma_pago"> 
						   <a name="a_forma_pago"></a>
						   <hr>						 
					            <%pagina.DibujarSubtitulo("Forma de pago Matr&iacute;cula")%>
					            <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0" >
                                  <tr>
                                    <td width="100%" valign="top">
								    <table class=v1 width='100%' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD'>
									  <tr bgcolor='#C4D7FF' bordercolor='#999999'>
									  <th><font color='#333333'>chek</font></th>
									  <th><font color='#333333'>docto</font></th>
									  <th><font color='#333333'>Nº Cuotas</font></th>
									  <th><font color='#333333'>Monto ($)</font></th>
									  <th><font color='#333333'>F. Inicio Pago</font></th>
									  <th><font color='#333333'>Frec.</font></th>
									  <th><font color='#333333'>Nº Docto. Inicial</font></th>
									  <th><font color='#333333'>Cuenta Corriente / Nº Tarjeta</font></th>
									  <th><font color='#333333'>Banco</font></th>
									  <th><font color='#333333'>Plaza</font></th>
									  </tr>
										  <%while f_forma_pago_matricula.Siguiente%>
										  <tr>	<%f_forma_pago_matricula.DibujaCampo("ting_ccod")%>
												  <%f_forma_pago_matricula.DibujaCampo("post_ncorr")%>
												  <%f_forma_pago_matricula.DibujaCampo("tcom_ccod")%>
												  <%f_forma_pago_matricula.DibujaCampo("ofer_ncorr")%>
												  <%f_forma_pago_matricula.dibujaTextarea("receptaculo")%>
												  <%f_forma_pago_matricula.DibujaCampo("sdfp_tplaza_sbif")%>
											  <td><%f_forma_pago_matricula.DibujaCampo("butiliza")%></td>
											  <td><%f_forma_pago_matricula.DibujaCampo("c_ting_ccod")%></td>
											  <td><%f_forma_pago_matricula.DibujaCampo("stpa_ncuotas")%></td>
											  <td><%f_forma_pago_matricula.DibujaCampo("sdfp_mmonto")%></td>
											  <td><%f_forma_pago_matricula.DibujaCampo("sdfp_finicio_pago")%></td>
											  <td><%f_forma_pago_matricula.DibujaCampo("sdfp_nfrecuencia")%></td>
											  <td><%f_forma_pago_matricula.DibujaCampo("sdfp_ndocto_inicial")%></td>
											  <td><%f_forma_pago_matricula.DibujaCampo("sdfp_tctacte")%></td>
											  <td><%f_forma_pago_matricula.DibujaCampo("banc_ccod")%></td>
											  <td><%f_forma_pago_matricula.DibujaCampo("plaz_ccod")%></td>
											  
										</tr>
										  <%wend%>
									  </table>
								    </td></tr>
                                  <tr>
                                    <td><br>
                                      <%f_suma_fp_matricula.DibujaRegistro%></td></tr>
                                </table>
					            <br>
					            <br>
                                <%pagina.DibujarSubtitulo("Forma de pago Arancel")%>
                            Fecha vencimiento primer documento 
                            : 
                            <% f_fecha_inicio.DibujaCampo ("fecha_inicio_pago")%>
                                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                                  <tr>
                                    <td width="100%">
                                      <table class=v1 width='100%' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD'>
									  <tr bgcolor='#C4D7FF' bordercolor='#999999'>
									  <th><font color='#333333'>chek</font></th>
									  <th><font color='#333333'>docto</font></th>
									  <th><font color='#333333'>Nº Cuotas</font></th>
									  <th><font color='#333333'>Monto ($)</font></th>
									  <th><font color='#333333'>F. Inicio Pago</font></th>
									  <th><font color='#333333'>Frec.</font></th>
									  <th><font color='#333333'>Nº Docto. Inicial</font></th>
									  <th><font color='#333333'>Cuenta Corriente / Nº Tarjeta</font></th>
									  <th><font color='#333333'>Banco</font></th>
									  <th><font color='#333333'>Plaza</font></th>
									  </tr>
										  <%while f_forma_pago_colegiatura.Siguiente%>
										  <tr>
												  <td><%f_forma_pago_colegiatura.DibujaCampo("ting_ccod")%>
												  <%f_forma_pago_colegiatura.DibujaCampo("post_ncorr")%>
												  <%f_forma_pago_colegiatura.DibujaCampo("tcom_ccod")%>
												  <%f_forma_pago_colegiatura.DibujaCampo("ofer_ncorr")%>
												  <%f_forma_pago_colegiatura.dibujaTextarea("receptaculo")%>
												  <%f_forma_pago_colegiatura.DibujaCampo("sdfp_tplaza_sbif")%>
											  <%f_forma_pago_colegiatura.DibujaCampo("butiliza")%></td>
											  <td><%f_forma_pago_colegiatura.DibujaCampo("c_ting_ccod")%></td>
											  <td><%f_forma_pago_colegiatura.DibujaCampo("stpa_ncuotas")%></td>
											  <td><%f_forma_pago_colegiatura.DibujaCampo("sdfp_mmonto")%></td>
											  <td><%f_forma_pago_colegiatura.DibujaCampo("sdfp_finicio_pago")%></td>
											  <td><%f_forma_pago_colegiatura.DibujaCampo("sdfp_nfrecuencia")%></td>
											  <td><%f_forma_pago_colegiatura.DibujaCampo("sdfp_ndocto_inicial")%></td>
											  <td><%f_forma_pago_colegiatura.DibujaCampo("sdfp_tctacte")%></td>
											  <td><%f_forma_pago_colegiatura.DibujaCampo("banc_ccod")%></td>
											  <td><%f_forma_pago_colegiatura.DibujaCampo("plaz_ccod")%></td>
										  </tr>
										  <%wend%>
									  </table>
								    </td>
                                  </tr>
                                  <tr>
                                    <td>
                                    <%f_suma_fp_colegiatura.DibujaRegistro%></td>
                                  </tr>
                                </table>
					            <br>
					            <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                                  <tr>
                                    <td width="80%"><div align="right">
                                      <%f_botonera.DibujaBoton("calcular")%>
                                    </div></td>
                                  </tr>
                                </table>
					            <%f_spagos.DibujaRegistro%>
					            <%f_max_cuotas.DibujaRegistro%>
					    </form>
                                <form name="detalle_pagos">
                                  <%pagina.DibujarSubtitulo "Detalle de pagos"%>
                                  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                                    <tr>
                                      <td>
									  <table class=v1 width='98%' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD'>
										  <tr bgcolor='#C4D7FF' bordercolor='#999999'>
										  <th><font color='#333333'>Nº Cuota</font></th>
										  <th><font color='#333333'>Tipo</font></th>
										  <th><font color='#333333'>Tipo<br>Docto.</font></th>
										  <th><font color='#333333'>Nº<br>Docto.</font></th>
										  <th><font color='#333333'>Cuenta Corriente</font></th>
										  <th><font color='#333333'>Banco</font></th>
										  <th><font color='#333333'>Plaza</font></th>
										  <th><font color='#333333'>Fecha<br>Emisión</font></th>
										  <th><font color='#333333'>Fecha<br>Venc.</font></th>
										  <th><font color='#333333'>Monto Docto.</font></th>
									  </tr>
										  <%while f_detalle_pagos.Siguiente%>
										  <tr>
												  <td><%f_detalle_pagos.DibujaCampo("c_ting_ccod")%>
												  <%f_detalle_pagos.DibujaCampo("post_ncorr")%>
												  <%f_detalle_pagos.DibujaCampo("sdpa_ccod")%>
												  <%f_detalle_pagos.DibujaCampo("ofer_ncorr")%>
												  <%f_detalle_pagos.DibujaCampo("sdpa_ncuota")%>
												  <%f_detalle_pagos.DibujaCampo("c_sdpa_mmonto")%>
											  <%f_detalle_pagos.DibujaCampo("c_sdpa_ncuota")%></td>
											  <td><%f_detalle_pagos.DibujaCampo("c_sdpa_ccod")%></td>
											  <td><%f_detalle_pagos.DibujaCampo("ting_ccod")%></td>
											  <td><%f_detalle_pagos.DibujaCampo("sdpa_ndocumento")%></td>
											  <td><%f_detalle_pagos.DibujaCampo("sdpa_tctacte")%></td>
											  <td><%f_detalle_pagos.DibujaCampo("banc_ccod")%></td>
											  <td><%f_detalle_pagos.DibujaCampo("plaz_ccod")%></td>
											  <td><%f_detalle_pagos.DibujaCampo("sdpa_femision")%></td>
											  
											<td><%f_detalle_pagos.DibujaCampo("sdpa_fvencimiento")%></td>
											  <td><%f_detalle_pagos.DibujaCampo("sdpa_mmonto")%></td>
										  </tr>
										  <%wend%>
										  <tr bgcolor="#FFFFFF"><th colspan='9'>Total</th><th align='RIGHT'><%=formatcurrency(total_det_pag,0)%></th></tr>
									    </table>
									  </td>
                                    </tr>
                                  </table>
                                </form>                              <br>
   					      <div align="left">                        </div>					  </td></tr>
                </table>
                          <br>
</td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("anterior")%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("siguiente")%>
                  </div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("salir")%>
                  </div></td>
                </tr>
              </table>
            </div></td>
            <td width="62%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
