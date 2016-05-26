<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/funciones_formateo.asp" -->

<%
'---------------------------------------------------------------------------------------------------------------------------------
q_envi_ncorr = Request.QueryString("envi_ncorr")
q_todos = Request.QueryString("todos")

Response.AddHeader "Content-Disposition", "attachment;filename=banco_bci_" & q_envi_ncorr & ".txt"
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


consulta = " select a.tins_ccod as instruccion, " & vbCrLf &_ 
  " protic.extrae_acentos(substring(d.pers_tape_paterno,0,15)) as paterno,protic.extrae_acentos(substring(d.pers_tape_materno,0,10)) as materno, " & vbCrLf &_ 
  "protic.extrae_acentos(substring(d.pers_tnombre,0,15)) as nombre_aceptante," & vbCrLf &_ 
  "protic.extrae_acentos(substring(isnull(protic.obtener_direccion_letra(c.pers_ncorr_codeudor, 1,'CNPB'),protic.obtener_direccion(c.pers_ncorr_codeudor, 1,'CNPB')),0,50)) as direccion_aceptante, "& vbCrLf &_
  "replace(replace(protic.obtener_rut(c.pers_ncorr_codeudor),'-',''),'k','K') as rut_aceptante," & vbCrLf &_ 
  "isnull((select codigo from codigos_comunas_bci where descripcion=isnull(f.ciud_tdesc,h.ciud_tdesc)),0) as comuna,"& vbCrLf &_ 
  "ISNULL((select top 1 codigo_plaza from codigos_plazas_bci where descripcion_plaza=isnull(f.ciud_tdesc,h.ciud_tdesc)),0) as plaza_cobro, "& vbCrLf &_
  " PROTIC.TRUNC(convert(DATETIME,c.ding_fdocto, 103)) as fecha_vencimiento, "& vbCrLf &_
  " replace(STUFF(cast(c.ding_mdocto as numeric), 1, 0,REPLICATE('0',cast(12-len(cast(c.ding_mdocto as numeric)) as numeric)) ),'.','') as monto_documento, "& vbCrLf &_
  " c.ding_ndocto as num_cedente,'Letra N°: '+cast(c.ding_ndocto as varchar) as auxiliar, '' as codigo_postal, isnull(substring(d.pers_temail,0,50),'') as email " & vbCrLf &_
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
	 " left outer join direcciones g    " & vbCrLf &_
     "      on d.pers_ncorr = g.pers_ncorr    " & vbCrLf &_
     "      and g.tdir_ccod  = 1  " & vbCrLf &_
     " left outer join ciudades h    " & vbCrLf &_
     "      on g.ciud_ccod = h.ciud_ccod   " & vbCrLf &_
     " where a.envi_ncorr = '" & q_envi_ncorr & "'  "  


if q_todos = "NO" then
	str_rut = ObtenerStrRut()
	if str_rut <> "" then
		consulta = consulta & "  and d.pers_nrut in (" & str_rut & ")   " & vbCrLf 
	end if
end if
		   
consulta = consulta & "order by paterno,materno,nombre_aceptante asc,convert(datetime,c.ding_fdocto,103)  asc"

'Response.Write("<pre>" &consulta&"</pre>")
f_consulta.Consultar consulta


while f_consulta.Siguiente
    response.Write(Ac(f_consulta.ObtenerValor("instruccion"),1,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("paterno"),15,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("materno"),10,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("nombre_aceptante"),15,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("rut_aceptante"),9,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("direccion_aceptante"),50,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("comuna"),3,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("plaza_cobro"),4,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("fecha_vencimiento"),10,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("monto_documento"),12,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("num_cedente"),7,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("codigo_postal"),7,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("auxiliar"),30,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("email"),30,"I"))

	Response.Write(vbCrLf)
wend

'Response.Write("</pre>")
%>
