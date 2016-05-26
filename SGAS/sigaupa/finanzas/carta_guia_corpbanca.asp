<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/funciones_formateo.asp" -->

<%
'---------------------------------------------------------------------------------------------------------------------------------
q_envi_ncorr = Request.QueryString("envi_ncorr")
q_todos = Request.QueryString("todos")

Response.AddHeader "Content-Disposition", "attachment;filename=banco_corpbanca_" & q_envi_ncorr & ".txt"
Response.ContentType = "text/plain"
'for each x in request.Form
'	response.Write("<br>"& x &"->"&request.Form(x))
'next
'---------------------------------------------------------------------------------------------------------------------------------
Function ObtenerStrRut
	Dim variables, var, str_rut
	
set f_variables = new CFormulario
f_variables.Carga_Parametros "Envios_Banco.xml", "f_detalle_agrupado"
f_variables.Inicializar conexion
f_variables.ProcesaForm

	
	str_rut = ""	

	for i_ = 0 to f_variables.CuentaPost - 1
	'response.Write("<br> a"&f_variables.ObtenerValorPost( i_, "carta")&" ->"&str_rut)		
		if f_variables.ObtenerValorPost(i_, "carta") = "1" then
			if str_rut="" then
				str_rut = f_variables.ObtenerValorPost(i_, "r_apoderado")
			else
				str_rut = str_rut & ", "& f_variables.ObtenerValorPost(i_, "r_apoderado") 
			end if
		end if
	next
	
	sql = "select '"&str_rut&"'"
	str_rut = conexion.ConsultaUno(sql)
		
	ObtenerStrRut = str_rut
	
End Function

'---------------------------------------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


'---------------------------------------------------------------------------------------------------------------------------------
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "consulta.xml", "consulta"
f_consulta.Inicializar conexion


consulta = "select 9 as codigo,'0001' as oficina,'00000000' as relleno, " & vbCrLf &_
		"	STUFF(d.pers_nrut, 1, 0,REPLICATE('0',cast(8-len(d.pers_nrut) as numeric))) as rut_aceptante,d.pers_xdv as dv, " & vbCrLf &_
		"	--STUFF(d.pers_nrut, 1, 0,REPLICATE('0',cast(9-len(d.pers_nrut) as numeric))) as rut_cedente,d.pers_xdv as dv_cedente, " & vbCrLf &_
		"	71704700 as rut_cedente,1 as dv_cedente, " & vbCrLf &_
		"	STUFF(ccte_tdesc,1, 0,REPLICATE('0',cast(10-len(ccte_tdesc) as numeric))) as cta_corriente, replace(convert(char(12),getdate(), 105),'-','') as fecha_recepcion,'999999' as folio_cartaguia, " & vbCrLf &_
		"	a.tcob_ccod as tipo_cobranza,'000' as tipo_moneda,'1' as tipo_doc, " & vbCrLf &_
		"	STUFF(ccte_tdesc,1, 0,REPLICATE('0',cast(10-len(ccte_tdesc) as numeric))) as  cta_corriente_abono,case a.tcob_ccod when 1 then 17 else 37 end as cod_abono, " & vbCrLf &_
		"	STUFF(ccte_tdesc,1, 0,REPLICATE('0',cast(10-len(ccte_tdesc) as numeric))) as  cta_corriente_cargo,'17' as cod_cargo,'N' as uso_banco, " & vbCrLf &_
		"	c.ding_ndocto as numero_cedente,--STUFF(c.ding_ndocto, 1, 0,REPLICATE('0',cast(15-len(c.ding_ndocto) as numeric))) as numero_cedente, " & vbCrLf &_
		"	 replace(substring(protic.obtener_nombre_completo(c.pers_ncorr_codeudor,'a'), 0, 31),'Ñ','N')  as nombre_aceptante, " & vbCrLf &_
		"	 case  when c.ding_ndocto between 231678 and 231679 then 'PEDRO DE VALDIVIA 1296' else " & vbCrLf &_
		" 		replace(substring(protic.obtener_direccion_letra(c.pers_ncorr_codeudor, 1,'CNPB'),0,31),'Ñ','N') end  as direccion_aceptante,  " & vbCrLf &_
		"	 replace(substring(f.ciud_tdesc,0,15),'Ñ','N')  as comuna, " & vbCrLf &_
		"	 replace(convert(char(12),c.ding_fdocto, 105),'-','') as fecha_vencimiento, " & vbCrLf &_
		"	 replace(STUFF(c.ding_mdocto, 1, 0,REPLICATE('0',cast(10-len(cast(c.ding_mdocto as numeric)) as numeric)) ),'.','') as monto_documento, " & vbCrLf &_
		"	 case a.tins_ccod when 1 then 2 else 1 end as instruccion, " & vbCrLf &_
		"	ISNULL((select top 1 STUFF(codigo_plaza,1, 0,REPLICATE('0',cast(4-len(codigo_plaza) as numeric))) from codigos_plazas_corpbanca where descripcion_plaza=f.ciud_tdesc),'0001') as plaza_cobro, " & vbCrLf &_
		"	' ' as codigo_tipo_carta,'000000000000000000' as relleno2" & vbCrLf &_
		" from envios a  " & vbCrLf &_
		" join detalle_envios b " & vbCrLf &_
		"	on a.envi_ncorr = b.envi_ncorr " & vbCrLf &_
		" join detalle_ingresos c " & vbCrLf &_
		"	 on b.ting_ccod = c.ting_ccod    " & vbCrLf &_
		"	 and b.ding_ndocto = c.ding_ndocto    " & vbCrLf &_
		"	 and b.ingr_ncorr = c.ingr_ncorr " & vbCrLf &_
		" join ingresos g " & vbCrLf &_
		"	on c.ingr_ncorr=g.ingr_ncorr " & vbCrLf &_      
		" left outer join personas d " & vbCrLf &_
		"	 on c.pers_ncorr_codeudor = d.pers_ncorr " & vbCrLf &_
		" left outer join direcciones_publica e " & vbCrLf &_
		"	 on d.pers_ncorr = e.pers_ncorr " & vbCrLf &_
		"	 and e.tdir_ccod  = 1 " & vbCrLf &_
		" left outer join ciudades f " & vbCrLf &_
		"	 on e.ciud_ccod = f.ciud_ccod " & vbCrLf &_
		" left outer join cuentas_corrientes h " & vbCrLf &_
		"	 on a.ccte_ccod = h.ccte_ccod " & vbCrLf &_		
     	" where a.envi_ncorr = '" & q_envi_ncorr & "'  "  

consulta = consulta & "order by nombre_aceptante,convert(datetime,c.ding_fdocto,103)  asc"

'Response.Write("<pre>" &consulta&"</pre>")
'response.End()

f_consulta.Consultar consulta
'f_consulta.Consultar "Select ''"

'Response.Write(vbCrLf)
while f_consulta.Siguiente
	Response.Write(Ac(f_consulta.ObtenerValor("codigo"),1,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("oficina"),4,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("relleno"),8,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("rut_aceptante"),8,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("dv"),1,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("rut_cedente"),9,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("dv_cedente"),1,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("cta_corriente"),10,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("fecha_recepcion"),8,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("folio_cartaguia"),6,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("tipo_cobranza"),1,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("tipo_moneda"),3,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("tipo_doc"),1,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("cta_corriente_abono"),10,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("cod_abono"),2,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("cta_corriente_cargo"),10,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("cod_cargo"),2,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("uso_banco"),1,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("numero_cedente"),15,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("nombre_aceptante"),30,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("direccion_aceptante"),30,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("comuna"),15,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("fecha_vencimiento"),8,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("monto_documento"),12,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("instruccion"),1,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("plaza_cobro"),4,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("codigo_tipo_carta"),1,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("relleno2"),18,"I"))
	

	
	
	

	
	

	Response.Write(vbCrLf)
wend

'Response.Write("</pre>")
%>
