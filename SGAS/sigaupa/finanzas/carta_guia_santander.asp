<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/funciones_formateo.asp" -->

<%
'---------------------------------------------------------------------------------------------------------------------------------
q_envi_ncorr = Request.QueryString("envi_ncorr")
q_todos = Request.QueryString("todos")

Response.AddHeader "Content-Disposition", "attachment;filename=banco_santander_" & q_envi_ncorr & ".txt"
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

set f_consulta_encabezado = new CFormulario
f_consulta_encabezado.Carga_Parametros "consulta.xml", "consulta"
f_consulta_encabezado.Inicializar conexion

sql_registro_control= " select STUFF(replace(g.ccte_tdesc,'-',''), 1, 0,REPLICATE('0',cast(12-len(replace(g.ccte_tdesc,'-','')) as numeric))) as contrato, " & vbCrLf &_ 
						" '01' as clase,'0' as moneda,'000' as moneda_cobro,'000' as convenio, '000' as periodo_cuotas,'00' as maximo_protesto, " & vbCrLf &_ 
						" STUFF(protic.cantidad_documentos_envio(a.envi_ncorr),1,0,REPLICATE('0',cast(5-len(cast(protic.cantidad_documentos_envio(a.envi_ncorr) as numeric)) as numeric))) as cantidad_letras, " & vbCrLf &_ 
						"cast(STUFF(cast(protic.total_valor_envio(a.envi_ncorr) as numeric),1,0,REPLICATE('0',cast(14-len(cast(protic.total_valor_envio(a.envi_ncorr) as numeric)) as numeric)))as varchar)+'00' as monto_total " & vbCrLf &_ 
						" from envios a  " & vbCrLf &_ 
						" join detalle_envios b " & vbCrLf &_ 
						"    on a.envi_ncorr = b.envi_ncorr " & vbCrLf &_ 
						"join cuentas_corrientes g " & vbCrLf &_ 
						"    on a.ccte_ccod=g.ccte_ccod " & vbCrLf &_     
						" join detalle_ingresos c " & vbCrLf &_ 
						"     on b.ting_ccod = c.ting_ccod " & vbCrLf &_    
						"     and b.ding_ndocto = c.ding_ndocto " & vbCrLf &_    
						"     and b.ingr_ncorr = c.ingr_ncorr " & vbCrLf &_  
						" where a.envi_ncorr = '" & q_envi_ncorr & "' " & vbCrLf &_  
						" group by  g.ccte_tdesc,a.envi_ncorr "  


f_consulta_encabezado.Consultar sql_registro_control

while f_consulta_encabezado.Siguiente
	response.Write(Ac(f_consulta_encabezado.ObtenerValor("contrato"),12,"I"))
	Response.Write(Ac(f_consulta_encabezado.ObtenerValor("clase"),2,"I"))
	Response.Write(Ac(f_consulta_encabezado.ObtenerValor("moneda"),1,"I"))
	Response.Write(Ac(f_consulta_encabezado.ObtenerValor("moneda_cobro"),3,"I"))
	Response.Write(Ac(f_consulta_encabezado.ObtenerValor("convenio"),3,"I"))
	Response.Write(Ac(f_consulta_encabezado.ObtenerValor("cantidad_letras"),5,"I"))
	Response.Write(Ac(f_consulta_encabezado.ObtenerValor("monto_total"),16,"I"))
	Response.Write(Ac(f_consulta_encabezado.ObtenerValor("periodo_cuotas"),3,"I"))
	Response.Write(Ac(f_consulta_encabezado.ObtenerValor("maximo_protesto"),2,"I"))
wend


'---------------------------------------------------------------------------------------------------------------------------------
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "consulta.xml", "consulta"
f_consulta.Inicializar conexion


consulta = "select STUFF(d.pers_nrut, 1, 0,REPLICATE('0',cast(9-len(d.pers_nrut) as numeric))) as rut_aceptante," & vbCrLf &_
		" d.pers_xdv as dv," & vbCrLf &_
		" substring(protic.obtener_nombre_completo(c.pers_ncorr_codeudor,'a'), 0, 31) as nombre_aceptante," & vbCrLf &_
		" substring(protic.obtener_direccion_letra(c.pers_ncorr_codeudor, 1,'CNPB'),0,31) as direccion_aceptante, " & vbCrLf &_
		" substring(f.ciud_tdesc,0,26) as comuna," & vbCrLf &_
		" substring(f.ciud_tcomuna,0,26) as ciudad," & vbCrLf &_
		" c.ding_ndocto as numero_cedente," & vbCrLf &_
		" a.tins_ccod as instruccion," & vbCrLf &_
		" replace(convert(char(12),c.ding_fdocto, 105),'-','') as fecha_vencimiento," & vbCrLf &_
		" replace(convert(char(12),protic.trunc(g.ingr_fpago), 105),'/','') as fecha_giro," & vbCrLf &_
		" '0000000000000000' as monto_primera_cuota, '0000000000000000' as total_pagare, '000' as num_cuotas" & vbCrLf &_
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
     	" where a.envi_ncorr = '" & q_envi_ncorr & "'  "  

consulta = consulta & "order by nombre_aceptante,convert(datetime,c.ding_fdocto,103)  asc"

'Response.Write("<pre>" &consulta&"</pre>")

f_consulta.Consultar consulta
'f_consulta.Consultar "Select ''"

Response.Write(vbCrLf)
while f_consulta.Siguiente
	Response.Write(Ac(f_consulta.ObtenerValor("rut_aceptante"),9,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("dv"),1,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("nombre_aceptante"),30,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("direccion_aceptante"),30,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("comuna"),25,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("ciudad"),25,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("numero_cedente"),12,"I"))
	response.Write(Ac(f_consulta.ObtenerValor("instruccion"),1,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("fecha_vencimiento"),8,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("fecha_giro"),8,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("monto_primera_cuota"),16,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("total_pagare"),16,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("num_cuotas"),3,"I"))
	

	Response.Write(vbCrLf)
wend

'Response.Write("</pre>")
%>
