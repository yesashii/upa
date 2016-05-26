<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'---------------------------------------------------------------------------------------------------------------------------------
q_envi_ncorr = Request.QueryString("envi_ncorr")
q_todos = Request.QueryString("todos")

Response.AddHeader "Content-Disposition", "attachment;filename=security_" & q_envi_ncorr & ".txt"
Response.ContentType = "text/plain"

'---------------------------------------------------------------------------------------------------------------------------------
Function ObtenerStrRut
	Dim variables, var, str_rut
	
	set variables = new CVariables
	variables.ProcesaForm
	var = "DETALLE_AGRUPADO"
	
	str_rut = "0, "	

	for i_ = 0 to variables.NroFilas(var) - 1		
		if variables.ObtenerValor(var, i_, "CARTA") = "1" then
			str_rut = str_rut & variables.ObtenerValor(var, i_, "R_APODERADO") & ", "
		end if
	next
	
	sql = "select rtrim('"&str_rut&"', ', ') from dual"
	str_rut = conexion.ConsultaUno(sql)
		
	ObtenerStrRut = str_rut
	
End Function

'---------------------------------------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------------------------------------
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "consulta.xml", "consulta"
f_consulta.Inicializar conexion

consulta = "select replace(substr(obtener_nombre_completo(c.pers_ncorr_codeudor), 0, 35), ';', '') as nombre_aceptante, " & vbCrLf &_
           "	   f.ciud_tdesc, f.ciud_tcomuna, d.pers_nrut, d.pers_xdv, to_char(c.ding_fdocto, 'dd/mm/yyyy') as fecha_vencimiento, " & vbCrLf &_
		   "	   '01' as tipo_moneda, c.ding_mdocto, " & vbCrLf &_
		   "	   case when upper(trim(f.ciud_tcomuna)) = 'SANTIAGO' then f.ciud_tcomuna else f.ciud_tdesc end as ciudad, " & vbCrLf &_
		   "	   case when upper(trim(f.ciud_tcomuna)) = 'SANTIAGO' then f.ciud_tdesc else f.ciud_tcomuna end as comuna, " & vbCrLf &_
		   "	   trim(replace(substr(obtener_direccion(c.pers_ncorr_codeudor, 1) || ' ' || case when upper(trim(f.ciud_tcomuna)) <> upper(trim(f.ciud_tdesc)) then case when upper(trim(f.ciud_tcomuna)) = 'SANTIAGO' then f.ciud_tcomuna else f.ciud_tdesc end else '' end, 0, 35), ';', '')) as direccion, " & vbCrLf &_
		   "       decode('" & negocio.ObtenerSede & "', '1', '840', '2', '', '3', '320') as plaza, " & vbCrLf &_
		   "       decode(a.tins_ccod, 1, 'C', 2, 'G') as tipo " & vbCrLf &_
		   "from envios a, detalle_envios b, detalle_ingresos c, " & vbCrLf &_
		   "     personas d, direcciones e, ciudades f  " & vbCrLf &_
		   "where a.envi_ncorr = b.envi_ncorr " & vbCrLf &_
		   "  and b.ting_ccod = c.ting_ccod " & vbCrLf &_
		   "  and b.ding_ndocto = c.ding_ndocto " & vbCrLf &_
		   "  and b.ingr_ncorr = c.ingr_ncorr " & vbCrLf &_
		   "  and c.pers_ncorr_codeudor = d.pers_ncorr (+) " & vbCrLf &_
		   "  and d.pers_ncorr = e.pers_ncorr (+) " & vbCrLf &_
		   "  and e.ciud_ccod = f.ciud_ccod (+) " & vbCrLf &_
		   "  and e.tdir_ccod (+) = 1 " & vbCrLf &_
		   "  and a.envi_ncorr = '" & q_envi_ncorr & "' " & vbCrLf 

if q_todos = "NO" then
	str_rut = ObtenerStrRut()
	consulta = consulta & "  and d.pers_nrut in (" & str_rut & ")   " & vbCrLf 
end if
		   
consulta = consulta & "order by nombre_aceptante asc, fecha_vencimiento asc"


f_consulta.Consultar consulta

'Response.Write("<pre>" & vbCrLf)
while f_consulta.Siguiente
	Response.Write(f_consulta.ObtenerValor("nombre_aceptante") & ";")
	Response.Write(f_consulta.ObtenerValor("direccion") & ";")
	Response.Write(f_consulta.ObtenerValor("comuna") & ";")
	Response.Write(f_consulta.ObtenerValor("comuna") & ";")
	Response.Write(f_consulta.ObtenerValor("pers_nrut") & ";")
	Response.Write(f_consulta.ObtenerValor("pers_xdv") & ";")
	Response.Write(f_consulta.ObtenerValor("tipo") & ";")
	Response.Write(f_consulta.ObtenerValor("fecha_vencimiento") & ";")
	Response.Write(f_consulta.ObtenerValor("plaza") & ";")
	Response.Write(f_consulta.ObtenerValor("tipo_moneda") & ";")
	Response.Write(f_consulta.ObtenerValor("ding_mdocto"))
	Response.Write(vbCrLf)
wend

'Response.Write("</pre>")
%>
