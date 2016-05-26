<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/funciones_formateo.asp" -->

<%
'---------------------------------------------------------------------------------------------------------------------------------
q_envi_ncorr = Request.QueryString("envi_ncorr")
q_todos = Request.QueryString("todos")

Response.AddHeader "Content-Disposition", "attachment;filename=bancochile_" & q_envi_ncorr & ".txt"
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


consulta = " Select STUFF(replace(protic.obtener_rut(c.pers_ncorr_codeudor),'-',''),1,0,REPLICATE('0',cast(11-len(protic.obtener_rut(c.pers_ncorr_codeudor)) as numeric))) as rut_aceptante, " & vbCrLf &_
		   " substring(protic.extrae_acentos(protic.obtener_nombre_completo(c.pers_ncorr_codeudor,'a')), 0, 35) as nombre_aceptante,  " & vbCrLf &_  
		   " substring(protic.extrae_acentos(protic.obtener_direccion_letra(c.pers_ncorr_codeudor, 1,'CNPB')),0,35) as direccion_aceptante, " & vbCrLf &_   
		   " substring(f.ciud_tdesc,0,12) as comuna, " & vbCrLf &_
		   " substring(f.ciud_tcomuna,0,12) as ciudad, " & vbCrLf &_
		   " '' as plaza_pago, " & vbCrLf &_
		   " convert(char(8),c.ding_fdocto, 112) as fecha_vencimiento, " & vbCrLf &_
		   " case a.tins_ccod when 1 then 2 when 2 then 1 else a.tins_ccod end  as instruccion, " & vbCrLf &_
		   " replace(STUFF(c.ding_mdocto, 1, 0,REPLICATE('0',cast(11-len(cast(c.ding_mdocto as numeric)) as numeric)) ),'.','') as monto_documento, " & vbCrLf &_
		   " STUFF(c.ding_ndocto, 1, 0,REPLICATE('0',cast(9-len(c.ding_ndocto) as numeric)))as num_cedente, " & vbCrLf &_
		   " '999' as tipo_moneda,  " & vbCrLf &_
		   " a.tcob_ccod as tipo_cobranza " & vbCrLf &_
 		" from envios a  " & vbCrLf &_
     " join detalle_envios b " & vbCrLf &_
     "    on a.envi_ncorr = b.envi_ncorr " & vbCrLf &_
     " join detalle_ingresos c " & vbCrLf &_
     "     on b.ting_ccod = c.ting_ccod    " & vbCrLf &_
     "     and b.ding_ndocto = c.ding_ndocto    " & vbCrLf &_
     "     and b.ingr_ncorr = c.ingr_ncorr  " & vbCrLf &_ 
     " left outer join personas d " & vbCrLf &_
     "     on c.pers_ncorr_codeudor = d.pers_ncorr " & vbCrLf &_
     " left outer join direcciones_publica e " & vbCrLf &_
     "     on d.pers_ncorr = e.pers_ncorr " & vbCrLf &_
     "     and e.tdir_ccod  = 1 " & vbCrLf &_
     " left outer join ciudades f " & vbCrLf &_
     "     on e.ciud_ccod = f.ciud_ccod " & vbCrLf &_
     " where a.envi_ncorr = '" & q_envi_ncorr & "'  "  

if q_todos = "NO" then
	str_rut = ObtenerStrRut()
	if str_rut <> "" then
		consulta = consulta & "  and d.pers_nrut in (" & str_rut & ")   " & vbCrLf 
	end if
end if
		   
consulta = consulta & "order by nombre_aceptante,convert(datetime,c.ding_fdocto,103)  asc"

'Response.Write("<pre>" &consulta&"</pre>")
f_consulta.Consultar consulta

response.Write(Ac("H7170047001S",12,"I"))
Response.Write(vbCrLf)
while f_consulta.Siguiente
    response.Write(Ac(f_consulta.ObtenerValor("rut_aceptante"),10,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("nombre_aceptante"),35,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("direccion_aceptante"),35,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("comuna"),12,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("ciudad"),12,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("plaza_pago"),3,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("fecha_vencimiento"),8,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("instruccion"),1,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("monto_documento"),13,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("num_cedente"),9,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("tipo_moneda"),3,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("tipo_cobranza"),1,"I"))
	Response.Write(vbCrLf)
wend

'Response.Write("</pre>")
%>
