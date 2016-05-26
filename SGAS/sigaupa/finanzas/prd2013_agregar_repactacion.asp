<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'---------------------------------------------------------------------------------------------------
q_repa_ncorr = Request.QueryString("repa_ncorr")
q_ingresos = Request.QueryString("ingresos")
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Nueva repactación"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "agregar_repactacion.xml", "botonera"

set errores = new CErrores

'---------------------------------------------------------------------------------------------------
set f_detalle_compromisos = new CFormulario
f_detalle_compromisos.Carga_Parametros "agregar_repactacion.xml", "documentos_repactacion"
f_detalle_compromisos.Inicializar conexion
cuenta = 0
if EsVacio(q_repa_ncorr) then
	f_detalle_compromisos.ProcesaForm

	str_filtro_ingresos = ""
	for i_ = 0 to f_detalle_compromisos.CuentaPost - 1
		if EsVacio(f_detalle_compromisos.ObtenerValorPost(i_, "ingr_ncorr")) then
				str_filtro_ingresos = str_filtro_ingresos
		else
		str_filtro_ingresos = str_filtro_ingresos &  f_detalle_compromisos.ObtenerValorPost(i_, "ingr_ncorr") 
		end if
	
		if CInt(i_) <>  CInt(f_detalle_compromisos.CuentaPost - 1) then
			if EsVacio(f_detalle_compromisos.ObtenerValorPost(i_, "ingr_ncorr")) then
					str_filtro_ingresos = str_filtro_ingresos
			else	
					str_filtro_ingresos = str_filtro_ingresos & ","

			end if
		end if
	next
	if EsVacio(f_detalle_compromisos.ObtenerValorPost(i_ - 1, "ingr_ncorr")) then
		ultimo = 1
	else ultimo = 0		
	end if	

	if ultimo <> 0 then
		largo = len(str_filtro_ingresos)
		str_filtro_ingresos = Mid (str_filtro_ingresos,1,largo-1)
	end if
else
	str_filtro_ingresos = q_ingresos
end if
			
		   
consulta = "select b.comp_ndocto, b.tcom_ccod, cast(b.dcom_ncompromiso as varchar) + '/' + cast(a.comp_ncuotas as varchar) as cuota," & vbCrLf &_
			"        a.comp_fdocto, b.dcom_fcompromiso, b.dcom_mcompromiso," & vbCrLf &_
			"        isnull(b.dcom_mcompromiso, 0) - protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as abonos," & vbCrLf &_
			"        protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo," & vbCrLf &_
			"        b.ecom_ccod, e.edin_ccod, e.ting_ccod, e.ding_ndocto, e.ingr_ncorr," & vbCrLf &_
			"        e.ting_ccod as c_ting_ccod, e.ding_ndocto as c_ding_ndocto," & vbCrLf &_
			"		 b.comp_ndocto as c_comp_ndocto, b.tcom_ccod as c_tcom_ccod" & vbCrLf &_
			"    from compromisos a,detalle_compromisos b,abonos c,ingresos d,detalle_ingresos e,personas f" & vbCrLf &_
			"    where a.tcom_ccod = b.tcom_ccod  " & vbCrLf &_
			"        and a.inst_ccod = b.inst_ccod  " & vbCrLf &_
			"        and a.comp_ndocto = b.comp_ndocto" & vbCrLf &_
			"        and b.tcom_ccod = c.tcom_ccod " & vbCrLf &_
			"        and b.inst_ccod = c.inst_ccod " & vbCrLf &_
			"        and b.comp_ndocto = c.comp_ndocto " & vbCrLf &_
			"        and b.dcom_ncompromiso = c.dcom_ncompromiso" & vbCrLf &_
			"        and c.ingr_ncorr = d.ingr_ncorr " & vbCrLf &_
			"        and d.ingr_ncorr = e.ingr_ncorr " & vbCrLf &_
			"        and a.pers_ncorr = f.pers_ncorr" & vbCrLf &_
			"        and d.eing_ccod <> 3 " & vbCrLf &_
			"        and a.ecom_ccod = '1'" & vbCrLf &_
			"        and e.ingr_ncorr in (" & str_filtro_ingresos & ")" & vbCrLf &_
			"        --order by b.tcom_ccod asc, b.dcom_ncompromiso asc"
	'response.Write("<pre>" & consulta & "</pre>")
	'response.End()			
f_detalle_compromisos.Consultar consulta

consulta_suma = "select sum(a.saldo) as mrepactar from ( " & vbCrLf &_
                consulta & vbCrLf &_
				") a"				

v_mrepactar = conexion.ConsultaUno(consulta_suma)				

'response.Write(str_filtro_ingresos)


'----------------------------------------------------------------------------------------------------------------
set f_repactacion = new CFormulario
f_repactacion.Carga_Parametros "agregar_repactacion.xml", "repactacion"
f_repactacion.Inicializar conexion

		  
consulta = "select a.tcom_ccod, a.comp_ndocto, isnull(cast(b.repa_ncorr as varchar), '" & q_repa_ncorr & "') as repa_ncorr," & vbCrLf &_
			"        b.mrep_ccod, a.ncuotas as srep_ncuotas_repactar, cast(a.monto as int) as srep_mrepactar, " & vbCrLf &_
			"        case a.tcom_ccod " & vbCrLf &_
			"            when 1 then a.tcom_ccod" & vbCrLf &_
			"            when 2 then a.tcom_ccod" & vbCrLf &_
			"            else protic.compromiso_origen_repactacion(a.comp_ndocto, 'tcom_ccod')" & vbCrLf &_
			"            end as tcom_ccod_origen " & vbCrLf &_
			"from (select tcom_ccod, comp_ndocto, count(distinct ingr_ncorr) as ncuotas, sum(isnull(abon_mabono, 0)) as monto, 0 as n " & vbCrLf &_
			"      from abonos " & vbCrLf &_
			"	  where ingr_ncorr in (" & str_filtro_ingresos & ") " & vbCrLf &_
			"	  group by tcom_ccod, comp_ndocto " & vbCrLf &_
			"	  ) a,  " & vbCrLf &_
			"	  (select a.*, 0 as n from sim_repactaciones a where cast(repa_ncorr as varchar) = '" & q_repa_ncorr & "') b " & vbCrLf &_
			"where a.n *= b.n"
			
'response.Write("<pre>" & consulta & "</pre>")
		  
f_repactacion.Consultar consulta
'response.End()	
f_repactacion.Siguiente
f_repactacion.AgregaCampoCons "repa_ncorr", q_repa_ncorr

f_repactacion.AgregaCampoCons "srep_mrepactar", v_mrepactar

v_tcom_ccod = f_repactacion.ObtenerValor("tcom_ccod")
'v_srep_mrepactar = f_repactacion.ObtenerValor("srep_mrepactar")
v_srep_mrepactar = v_mrepactar
v_tcom_ccod_origen = f_repactacion.ObtenerValor("tcom_ccod_origen")

if f_repactacion.NroFilas >0 then
'if f_repactacion.NroFilas = 1 then	
	b_continuar = true
else
	b_continuar = false
end if



if b_continuar then

	set f_forma_repactacion = new CFormulario
	f_forma_repactacion.Carga_Parametros "agregar_repactacion.xml", "forma_repactacion"
	f_forma_repactacion.Inicializar conexion
	
	set f_consulta = new CFormulario
	f_consulta.Carga_Parametros "consulta.xml", "consulta"
	f_consulta.Inicializar conexion
	
	v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")


			   
consulta = "select a.tcom_ccod, a.ting_ccod, a.ting_ccod AS c_ting_ccod, b.repa_ncorr," & vbCrLf &_
			"        b.sfrp_mmonto, b.sfrp_ncuotas, b.sfrp_ndocto_inicial, b.sfrp_nfrecuencia," & vbCrLf &_
			"        b.sfrp_finicio_pago, b.banc_ccod, b.plaz_ccod, b.sfrp_tctacte," & vbCrLf &_
			"        case isnull(b.ting_ccod,0) " & vbCrLf &_
			"                when 0 then 'N'" & vbCrLf &_
			"                else 'S'" & vbCrLf &_
			"                end AS butiliza," & vbCrLf &_
			"        ltrim(rtrim(isnull(b.sfrp_mtasa_interes,isnull(c.tint_mtasa, 0)))) AS sfrp_mtasa_interes," & vbCrLf &_
			"        isnull(b.pers_ncorr_codeudor, d.pers_ncorr_codeudor) AS pers_ncorr_codeudor                " & vbCrLf &_
			"from (SELECT DISTINCT tcom_ccod, ting_ccod   " & vbCrLf &_
			"      FROM STIPOS_PAGOS a   " & vbCrLf &_
			"	  WHERE ting_ccod <> 6   " & vbCrLf &_
			"	    AND tcom_ccod = '2' " & vbCrLf &_
			"      UNION " & vbCrLf &_
			"      SELECT 1, 2) a,SIM_FORMA_REPACTACIONES b, TASAS_INTERES c, " & vbCrLf &_
			"      (SELECT MAX(pers_ncorr_codeudor) AS pers_ncorr_codeudor " & vbCrLf &_
			"	  FROM DETALLE_INGRESOS " & vbCrLf &_
			"	  WHERE ingr_ncorr IN (" & str_filtro_ingresos & ")) d" & vbCrLf &_
			"where a.ting_ccod *= b.ting_ccod" & vbCrLf &_
			"    AND a.ting_ccod *= c.ting_ccod" & vbCrLf &_
			"    AND c.ttin_ccod = 2" & vbCrLf &_
			"    AND c.peri_ccod = '" & v_peri_ccod & "'" & vbCrLf &_
			"    AND cast(b.repa_ncorr as varchar) = '" & q_repa_ncorr & "'" & vbCrLf &_
			"ORDER BY a.ting_ccod DESC"
					
	'response.Write("<pre>" & consulta & "</pre>")		
			   
	f_forma_repactacion.Consultar consulta 
	f_consulta.Consultar consulta
	
	i_ = 0
	while f_consulta.Siguiente
	
		
		
		if f_consulta.ObtenerValor("ting_ccod") <> "3" and f_consulta.ObtenerValor("ting_ccod") <> "13" and f_consulta.ObtenerValor("ting_ccod") <> "51" and  f_consulta.ObtenerValor("ting_ccod") <> "52" and  f_consulta.ObtenerValor("ting_ccod") <> "59" and  f_consulta.ObtenerValor("ting_ccod") <> "66" then
			f_forma_repactacion.AgregaCampoFilaParam i_, "banc_ccod", "permiso", "LECTURA"
			f_forma_repactacion.AgregaCampoFilaParam i_, "plaz_ccod", "permiso", "LECTURA"
			f_forma_repactacion.AgregaCampoFilaParam i_, "sfrp_tctacte", "permiso", "LECTURA"
			
		end if
		
		if f_consulta.ObtenerValor("ting_ccod") = "52" THEN
			f_forma_repactacion.AgregaCampoFilaParam i_, "sfrp_ndocto_inicial", "permiso", "LECTURA"
		end if

		if f_consulta.ObtenerValor("ting_ccod") = "59" THEN
			f_forma_repactacion.AgregaCampoFilaParam i_, "sfrp_ndocto_inicial", "permiso", "LECTURA"
		end if

		if f_consulta.ObtenerValor("ting_ccod") = "66" THEN
			f_forma_repactacion.AgregaCampoFilaParam i_, "sfrp_ndocto_inicial", "permiso", "LECTURA"
		end if
				
		if f_consulta.ObtenerValor("ting_ccod") <> "3" and f_consulta.ObtenerValor("ting_ccod") <> "2" and f_consulta.ObtenerValor("ting_ccod") <> "13" and f_consulta.ObtenerValor("ting_ccod") <> "51" then
			f_forma_repactacion.AgregaCampoFilaParam i_, "sfrp_ndocto_inicial", "permiso", "LECTURA"
		end if
		
		if f_consulta.ObtenerValor("butiliza") = f_forma_repactacion.ObtenerDescriptor("butiliza", "valorFalso") then
			f_forma_repactacion.AgregaCampoFilaParam i_, "sfrp_ncuotas", "deshabilitado", "TRUE"
			f_forma_repactacion.AgregaCampoFilaParam i_, "sfrp_mmonto", "deshabilitado", "TRUE"
			f_forma_repactacion.AgregaCampoFilaParam i_, "sfrp_finicio_pago", "deshabilitado", "TRUE"
			f_forma_repactacion.AgregaCampoFilaParam i_, "sfrp_nfrecuencia", "deshabilitado", "TRUE"
			f_forma_repactacion.AgregaCampoFilaParam i_, "sfrp_mmonto", "deshabilitado", "TRUE"
			f_forma_repactacion.AgregaCampoFilaParam i_, "sfrp_ndocto_inicial", "deshabilitado", "TRUE"
			f_forma_repactacion.AgregaCampoFilaParam i_, "banc_ccod", "deshabilitado", "TRUE"
			f_forma_repactacion.AgregaCampoFilaParam i_, "plaz_ccod", "deshabilitado", "TRUE"
			f_forma_repactacion.AgregaCampoFilaParam i_, "sfrp_mtasa_interes", "deshabilitado", "TRUE"
			f_forma_repactacion.AgregaCampoFilaParam i_, "sfrp_tctacte", "deshabilitado", "TRUE"
		end if			
		
		
		if f_consulta.ObtenerValor("ting_ccod") ="13" or f_consulta.ObtenerValor("ting_ccod") ="51" or f_consulta.ObtenerValor("ting_ccod") = "52" or f_consulta.ObtenerValor("ting_ccod") = "59" or f_consulta.ObtenerValor("ting_ccod") = "66" then
				f_forma_repactacion.AgregaCampoFilaParam i_, "plaz_ccod", "permiso", "oculto"
				f_forma_repactacion.AgregaCampoFilaParam i_, "banc_ccod", "id", "TO-N"
				f_forma_repactacion.AgregaCampoFilaParam i_, "sdfp_tctacte", "id", "TO-N"
				f_forma_repactacion.AgregaCampoFilaParam i_, "sdfp_ndocto_inicial","id", "TO-N"		
		end if		
		'f_forma_repactacion.AgregaCampoFilaParam i_, "sfrp_ncuotas", "filtro", "tcom_ccod = '" & v_tcom_ccod_origen & "' and ting_ccod = '"&f_consulta.ObtenerValor("ting_ccod")&"' and stpa_ncuotas > 0"
		
		f_forma_repactacion.AgregaCampoFilaParam i_, "sfrp_ncuotas", "filtro", "tcom_ccod = '2' and ting_ccod = '"&f_consulta.ObtenerValor("ting_ccod")&"' and stpa_ncuotas > 0"
		
		i_ = i_ + 1
	wend
	
	'-----------------------------------------------------------------------------------------------------------------
	set f_suma = new CFormulario
	f_suma.Carga_Parametros "agregar_repactacion.xml", "suma"
	f_suma.Inicializar conexion
	
	'consulta = "select nvl(sum(sfrp_mmonto), 0) as total_actual, nvl('" & v_srep_mrepactar & "', 0) as total_repactar, nvl(sum(sfrp_mmonto), 0) - nvl('" & v_srep_mrepactar & "', 0) as diferencia, to_char(sysdate, 'dd/mm/yyyy') as fecha_actual " & vbCrLf &_
	'           "from sim_forma_repactaciones a " & vbCrLf &_
	'		   "where repa_ncorr = '" & q_repa_ncorr & "'"
	if EsVacio(v_srep_mrepactar) then 
	consulta = "select isnull(sum(sfrp_mmonto), 0) as total_actual, 0 as total_repactar," & vbCrLf &_
			"        isnull(sum(sfrp_mmonto), 0) as diferencia," & vbCrLf &_
			"        convert(varchar,getdate(),103) as fecha_actual " & vbCrLf &_
			"from sim_forma_repactaciones a " & vbCrLf &_
			"where cast(repa_ncorr as varchar) = '" & q_repa_ncorr & "'"
	else		   
	consulta = "select isnull(sum(sfrp_mmonto), 0) as total_actual, isnull(cast('" & v_srep_mrepactar & "' as varchar), 0) as total_repactar," & vbCrLf &_
			"        isnull(sum(sfrp_mmonto), 0) - cast(isnull(cast('" & v_srep_mrepactar & "' as varchar), 0) as varchar) as diferencia," & vbCrLf &_
			"        convert(varchar,getdate(),103) as fecha_actual " & vbCrLf &_
			"from sim_forma_repactaciones a " & vbCrLf &_
			"where cast(repa_ncorr as varchar) = '" & q_repa_ncorr & "'"
	end if			
	'response.Write("<pre>"&consulta&"</pre>")		
	'response.End()
	f_suma.Consultar consulta
	
	
'#################################################################################	
'#######################	RESULTADO DE LA SIMULACION  ##########################
'#################################################################################	
	'-----------------------------------------------------------------------------------------------------------------
	set f_detalles_repactacion = new CFormulario
	f_detalles_repactacion.Carga_Parametros "agregar_repactacion.xml", "detalles_repactacion"
	f_detalles_repactacion.Inicializar conexion
	
			   
consulta = "select a.ting_ccod as c_ting_ccod, a.repa_ncorr, a.sdrp_ncuota," & vbCrLf &_
			"        a.sdrp_ncuota as c_sdrp_ncuota, a.ting_ccod, a.sdrp_ndocumento," & vbCrLf &_
			"        a.banc_ccod, a.plaz_ccod, a.sdrp_femision, a.sdrp_fvencimiento," & vbCrLf &_
			"        cast(a.sdrp_mmonto as numeric) as sdrp_mmonto, cast(a.sdrp_mmonto as numeric) sdrp_monto_oculto, a.sdrp_tctacte," & vbCrLf &_
			"        a.pers_ncorr_codeudor, protic.obtener_rut(a.pers_ncorr_codeudor) AS rut_codeudor " & vbCrLf &_
			"from sim_detalles_repactacion a " & vbCrLf &_
			"where cast(a.repa_ncorr as varchar) = '" & q_repa_ncorr & "' " & vbCrLf &_
			"order by a.sdrp_ncuota	"
	'response.Write("<pre>"&consulta&"</pre>")		
	'response.End()		
	f_detalles_repactacion.Consultar consulta
	
	f_consulta.Inicializar conexion
	f_consulta.Consultar consulta


sql_total_det_pag = " Select sum(a.sdrp_mmonto) as total " & vbCrLf &_
            		" From sim_detalles_repactacion a " & vbCrLf &_
		    		" Where cast(a.repa_ncorr as varchar) = '" & q_repa_ncorr & "' " 
					
total_det_pag = conexion.consultaUno (sql_total_det_pag)
if 	EsVacio(total_det_pag) then
	total_det_pag=0
end if


	i_ = 0

	while f_consulta.Siguiente
		if f_consulta.ObtenerValor("ting_ccod") <> "3" then
			f_detalles_repactacion.AgregaCampoFilaParam i_, "banc_ccod", "permiso", "LECTURA"
			f_detalles_repactacion.AgregaCampoFilaParam i_, "plaz_ccod", "permiso", "LECTURA"
			f_detalles_repactacion.AgregaCampoFilaParam i_, "sdrp_tctacte", "permiso", "LECTURA"
			f_detalles_repactacion.AgregaCampoFilaParam i_, "sdrp_fvencimiento", "permiso", "LECTURA"
			f_detalles_repactacion.AgregaCampoFilaParam i_, "sdrp_mmonto", "permiso", "LECTURA"			
		end if
		
		if f_consulta.ObtenerValor("ting_ccod") <> "3" and f_consulta.ObtenerValor("ting_ccod") <> "2" then
			f_detalles_repactacion.AgregaCampoFilaParam i_, "sdrp_ndocumento", "permiso", "LECTURA"
		end if
		
		if f_consulta.ObtenerValor("ting_ccod") = "4" or f_consulta.ObtenerValor("ting_ccod") = "3"  or f_consulta.ObtenerValor("ting_ccod") = "52" or f_consulta.ObtenerValor("ting_ccod") = "59"  or f_consulta.ObtenerValor("ting_ccod") = "66" then
			f_detalles_repactacion.AgregaCampoFilaParam i_, "sdrp_mmonto", "permiso","LECTURAESCRITURA"
			'f_detalles_repactacion.AgregaCampoFilaParam i_, "sdrp_monto_oculto", "permiso","LECTURAESCRITURA"
			f_detalles_repactacion.AgregaCampoFilaParam i_, "sdrp_fvencimiento", "permiso","LECTURAESCRITURA"
			f_detalles_repactacion.AgregaCampoFilaParam i_, "sdrp_fvencimiento", "id","FE-N"
		end if
		
		if f_consulta.ObtenerValor("ting_ccod") = "52" then
			f_detalles_repactacion.AgregaCampoFilaParam i_, "sdrp_fvencimiento", "permiso","LECTURAESCRITURA"
			f_detalles_repactacion.AgregaCampoFilaParam i_, "sdrp_fvencimiento", "id","FE-N"
		end if

		if f_consulta.ObtenerValor("ting_ccod") = "59" then
			f_detalles_repactacion.AgregaCampoFilaParam i_, "sdrp_fvencimiento", "permiso","LECTURAESCRITURA"
			f_detalles_repactacion.AgregaCampoFilaParam i_, "sdrp_fvencimiento", "id","FE-N"
		end if

		if f_consulta.ObtenerValor("ting_ccod") = "66" then
			f_detalles_repactacion.AgregaCampoFilaParam i_, "sdrp_fvencimiento", "permiso","LECTURAESCRITURA"
			f_detalles_repactacion.AgregaCampoFilaParam i_, "sdrp_fvencimiento", "id","FE-N"
		end if

		if f_consulta.ObtenerValor("ting_ccod") <> "4" and f_consulta.ObtenerValor("ting_ccod") <> "2" then
			f_detalles_repactacion.AgregaCampoFilaParam i_, "bcambia_codeudor", "permiso", "OCULTO"
			f_detalles_repactacion.AgregaCampoFilaParam i_, "rut_codeudor", "permiso", "OCULTO"
		end if
		
		i_ = i_ + 1
	wend

'#################################################################################	
'###################	FIN RESULTADO DE LA SIMULACION  ##########################
'#################################################################################	
	
	'-----------------------------------------------------------------------------------------------------------------
	set f_detalle_ingresos = new CFormulario
	f_detalle_ingresos.Carga_Parametros "agregar_repactacion.xml", "detalle_ingresos"
	f_detalle_ingresos.Inicializar conexion
	
	consulta = "select * from detalle_ingresos where ingr_ncorr in (" & str_filtro_ingresos & ")"
	f_detalle_ingresos.Consultar consulta
	f_detalle_ingresos.AgregaCampoCons "repa_ncorr", q_repa_ncorr
	
	
	
	'------------------------------------------------------------------------------------------------------------------
	set f_repactaciones = new CFormulario
	f_repactaciones.Carga_Parametros "agregar_repactacion.xml", "repactaciones"
	f_repactaciones.Inicializar conexion
	f_repactaciones.Consultar "select ''"
	f_repactaciones.AgregaCampoCons "repa_ncorr", q_repa_ncorr
	
	
	'------------------------------------------------------------------------------------------------------------------
	if f_detalles_repactacion.NroFilas = 0 then
		f_botonera.AgregaBotonParam "aceptar", "deshabilitado", "TRUE"
		f_botonera.AgregaBotonParam "cambiar_codeudor", "deshabilitado", "TRUE"
	end if
	
	
	'-------------------------------------------------------------------------------------------------------------------
	'f_forma_repactacion.AgregaCampoParam "sfrp_ncuotas", "tipo", "INPUT"
	'f_forma_repactacion.AgregaCampoParam "sfrp_ncuotas", "caracteres", "3"
	'f_forma_repactacion.AgregaCampoParam "sfrp_ncuotas", "id", "EP-N"

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
var t_forma_repactacion;
var t_alt_forma_repactacion;
var t_suma;
var t_alt_suma;
var t_detalles_repactacion;


function ValidarRepactacion()
{
	var suma_actual = t_forma_repactacion.SumarColumna("sfrp_mmonto");
	
	if (suma_actual != t_suma.ObtenerValor(0, "total_repactar")) {
		alert('El monto a repactar debe ser igual a ' + t_alt_suma.ObtenerValor(0, "total_repactar"));
		t_alt_suma.filas[0].campos["total_actual"].objeto.focus();
		return false;
	}
	
	
	for (var i = 0; i < t_forma_repactacion.filas.length; i++) {
		if ( (t_forma_repactacion.ObtenerValor(i, "butiliza") == 'S') && (t_forma_repactacion.ObtenerValor(i, "sfrp_mmonto") <= 0) ) {
			alert('Si va a utilizar esta forma de pago, monto debe ser mayor que $0.')
			t_alt_forma_repactacion.filas[i].campos["sfrp_mmonto"].objeto.focus();
			return false;
		}
	}
	
	
	for (var i = 0; i < t_forma_repactacion.filas.length; i++) {
		if ( (t_forma_repactacion.ObtenerValor(i, "butiliza") == 'S') && (t_forma_repactacion.ObtenerValor(i, "sfrp_mtasa_interes") < 0) ) {
			alert('Porcentaje de interés no puede ser negativo.');
			t_forma_repactacion.filas[i].campos["sfrp_mtasa_interes"].objeto.select();
			return false;
		}
	}
	
	
	return true;
}


function sfrp_mmonto_blur(objeto)
{
	t_suma.AsignarValor(0, "total_actual", t_forma_repactacion.SumarColumna("sfrp_mmonto"));
	t_suma.AsignarValor(0, "diferencia", t_forma_repactacion.SumarColumna("sfrp_mmonto") - t_suma.ObtenerValor(0, "total_repactar"));
	
	t_alt_suma.filas[0].campos["total_actual"].objeto.focus(); t_alt_suma.filas[0].campos["total_actual"].objeto.blur();
	t_alt_suma.filas[0].campos["diferencia"].objeto.focus(); t_alt_suma.filas[0].campos["diferencia"].objeto.blur();
}


function HabilitarFila(p_fila, p_habilitado)
{
	t_forma_repactacion.filas[p_fila].Habilitar(p_habilitado);
	t_alt_forma_repactacion.filas[p_fila].campos["sfrp_mmonto"].objeto.setAttribute("disabled", !p_habilitado);	
	
	if (p_habilitado) {
		t_forma_repactacion.filas[p_fila].campos["sfrp_mmonto"].objeto.value = t_suma.ObtenerValor(0, "diferencia") * -1;
		t_forma_repactacion.filas[p_fila].campos["sfrp_finicio_pago"].objeto.value = t_suma.ObtenerValor(0, "fecha_actual");
		t_forma_repactacion.AsignarValor(p_fila, "sfrp_nfrecuencia", '1');
	}
	else {
		t_forma_repactacion.filas[p_fila].campos["sfrp_mmonto"].objeto.value = '0';
		t_forma_repactacion.filas[p_fila].campos["sfrp_finicio_pago"].objeto.value = '';		
		t_forma_repactacion.AsignarValor(p_fila, "sfrp_nfrecuencia", '');
	}
	
	enMascara(t_alt_forma_repactacion.filas[p_fila].campos["sfrp_mmonto"].objeto, "MONEDA", 0);		
	sfrp_mmonto_blur(t_alt_forma_repactacion.filas[p_fila].campos["sfrp_mmonto"].objeto);	
}

function butiliza_click(objeto)
{
	HabilitarFila(_FilaCampo(objeto), objeto.checked);
}


function ValidarGeneracionRepactacion()
{
	for (var i = 0; i < t_detalles_repactacion.filas.length; i++) {
		if ( ((t_detalles_repactacion.ObtenerValor(i, "c_ting_ccod") == "4") || (t_detalles_repactacion.ObtenerValor(i, "c_ting_ccod") == "2")) &&
		     (isEmpty(t_detalles_repactacion.ObtenerValor(i, "pers_ncorr_codeudor")))
		   ) {
			alert('Una o más letras o facturas aparecen sin apoderado.  \n\nSelecciónelas en la casilla de verificación y presione \'Cambiar codeudor\'.');
			return false;
		}
	}
	if (ValidarCuotasPago()){
		return true;
	}
	return false;	
}


function ActualizarVentana()
{	
	if (ValidarGeneracionRepactacion())	{
		opener.location.reload();
		return true;
	}
	else {
		return false;
	}
}


function CambiarCodeudor()
{
	if (t_detalles_repactacion.CuentaSeleccionados("bcambia_codeudor") > 0) {
		resultado = open("", "wCodeudor", " resized, top=150, left=150, width=600, height=400, scrollbars=yes");
		return true;
	}
	else {
		alert('Debe seleccionar uno o más documentos para cambiar el apoderado.');
		return false;
	}
}


function InicioPagina()
{
	t_forma_repactacion = new CTabla("forma_repactacion");
	t_alt_forma_repactacion = new CTabla("_forma_repactacion");
	t_suma = new CTabla("suma");
	t_alt_suma = new CTabla("_suma");
	t_detalles_repactacion = new CTabla("detalles_repactacion");
	
	t_alt_suma.filas[0].campos["total_actual"].objeto.className = 'suma';
	t_alt_suma.filas[0].campos["total_repactar"].objeto.className = 'suma';
	t_alt_suma.filas[0].campos["diferencia"].objeto.className = 'suma';
}



function ValidarCuotasPago()
{
var formulario = document.forms["detalle_repactacion"];
suma_cuotas = 0;
total_cuotas = <%=total_det_pag%>;
//alert("objeto:"+formulario.elements["detalles_repactacion[0][c_ting_ccod]"]);
for (var i = 0; i < <%=f_detalles_repactacion.NroFilas%>; i++) {
//alert("entro a validar:"+i);
		if ((formulario.elements["detalles_repactacion[" +i + "][c_ting_ccod]"].value==3) || (formulario.elements["detalles_repactacion[" +i + "][c_ting_ccod]"].value==4) || (formulario.elements["detalles_repactacion[" +i + "][c_ting_ccod]"].value==52)|| (formulario.elements["detalles_repactacion[" +i + "][c_ting_ccod]"].value==59)|| (formulario.elements["detalles_repactacion[" +i + "][c_ting_ccod]"].value==66)) 
			{
				suma_cuotas += parseInt(formulario.elements["detalles_repactacion[" +i + "][sdrp_mmonto]"].value);
			}
		else
			{
				suma_cuotas += parseInt(formulario.elements["detalles_repactacion[" +i + "][sdrp_monto_oculto]"].value);
			}
	}
	
	if	(total_cuotas == suma_cuotas){
		return true;
	}
	if	(total_cuotas > suma_cuotas){
		alert ("El monto de las cuotas de los documentos es inferior a lo que se debe documentar.");
	}else{
		alert ("El monto de las cuotas de los documentos excede a lo que se debe documentar.");
	}	
	return false;
}


function ValidarFecha(elemento,tipo){

var v_fecha = new Date();
	dia=v_fecha.getDate();
	mes=v_fecha.getMonth()+1;
	agno=v_fecha.getFullYear();
	if (dia<10){dia='0'+dia;}

v_indice 	= 	extrae_indice(elemento.name);
fecha_pag 	= 	elemento.value;
array_pag	=	fecha_pag.split('/');

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
				if (tipo==1){
					document.repactacion.elements["forma_repactacion["+v_indice+"][sfrp_finicio_pago]"].value="";
					document.repactacion.elements["forma_repactacion["+v_indice+"][sfrp_finicio_pago]"].focus();
				}else{
					document.detalle_repactacion.elements["detalles_repactacion["+v_indice+"][sdrp_fvencimiento]"].value="";
					document.detalle_repactacion.elements["detalles_repactacion["+v_indice+"][sdrp_fvencimiento]"].focus();
				}
			
		}
	}
}


</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
<table width="103%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">	  <br>
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
            <td><%pagina.DibujarLenguetas Array("Repactar"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
			<br>             
              <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>
					<form name="repactacion">
					<%pagina.DibujarSubtitulo "Documentos para repactar"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"><%f_detalle_compromisos.DibujaTabla%></div></td>
                        </tr>
                      </table>
                      <br><br>					  
                      <%pagina.DibujarSubtitulo "Detalle de la repactación"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"><%f_forma_repactacion.DibujaTabla%>
                          </div></td>
                        </tr>
                        <tr>
                          <td><br>
                            <%f_suma.DibujaRegistro%></td>
                        </tr>
                        <tr>
                          <td><br>                            <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td><%f_repactacion.DibujaRegistro%></td>
                              <td>
                                    <div align="center">
                                      <br>
                                      <%f_botonera.DibujaBoton("calcular")%>
                                    </div></td>
                            </tr>
                          </table>                            </td></tr>
                        <tr>
                          <td><div align="right">
                          </div></td>
                        </tr>
                      </table>
					  </form>
                      <br>
					  <form name="detalle_repactacion">
                      <%pagina.DibujarSubtitulo "Nuevos documentos"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"><%f_detalles_repactacion.DibujaTabla%></div></td>
                        </tr>
                        <tr>
                          <td><br>
                            <div align="right"><%f_botonera.DibujaBoton("cambiar_codeudor")%></div></td>
                        </tr>
                      </table>
					  <%f_detalle_ingresos.DibujaLista%>
                      <%f_repactaciones.DibujaRegistro%>
                      </form>
					  
					  </td>
                  </tr>
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
            <td width="29%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("aceptar")%></div></td>
                  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="71%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>	</td>
  </tr>  
</table>
</body>
</html>
<%
end if
%>