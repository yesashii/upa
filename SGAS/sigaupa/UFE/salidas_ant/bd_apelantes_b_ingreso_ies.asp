
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "obtiene_rut.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
arch=request.QueryString("arch")
Response.AddHeader "Content-Disposition", "attachment;filename=bd_apelantes_b_ingreso_ies.csv"
Response.ContentType = "application/csv"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'carr_tdesc = request.querystring("carr_tdesc")
'carrera = carr_tdesc
'
rut=Extraer_rut(arch)
'------------------------------------------------------------------------------------
set tabla = new cformulario
tabla.carga_parametros	"tabla_vacia.xml",	"tabla"
tabla.inicializar		conexion
		
consulta = "select  pers_nrut, pers_xdv,pers_tnombre, pers_tape_paterno, pers_tape_materno, '' as ingreso_percapita_a  "  & vbCrlf & _
           "from personas"	& vbCrlf & _
		   " where pers_nrut in ("&rut&")"			


fecha=now()
descripcion="bd_apelantes_b_ingreso_ies"
usu=negocio.obtenerUsuario
usal_ncorr=conexion.ConsultaUno("exec ObtenerSecuencia 'ufe_salidas_log'")
strInst="insert into ufe_salidas_log (usal_ncorr,usal_tdesc,audi_tusuario,audi_fmodificacion, usal_parametro) values (" & usal_ncorr & ", '" & descripcion & "' ," & usu & ",'" & fecha & "', '" & rut & "')"
conexion.ejecutaS (strInst)
tabla.consultar consulta 
'response.Write(consulta)
'response.End()
'------------------------------------------------------------------------------------
encabezados="RUT;DV;NOMBRES;APELLIDO_PATERNO;APELLIDO_MATERNO;INGRESO_PERCAPITA_ANUAL"
response.Write(encabezados)
Response.Write(vbCrLf)
while tabla.Siguiente
    usdl_ncorr=conexion.ConsultaUno("exec ObtenerSecuencia 'ufe_salidas_detalle_log'")
	detalle=""&tabla.ObtenerValor("pers_nrut")&";"&tabla.ObtenerValor("pers_xdv")&";"&tabla.ObtenerValor("pers_tnombre")&";"&tabla.ObtenerValor("pers_tape_paterno")&";"&tabla.ObtenerValor("pers_tape_materno")&";"&tabla.ObtenerValor("ingreso_percapita_a")&""
	response.Write(detalle)
	Response.Write(vbCrLf)
	strInst="insert into ufe_salidas_detalle_log (usdl_ncorr,usal_ncorr,usdl_detalle) values (" & usdl_ncorr & ", " &  usal_ncorr & ", '" & detalle & "')"
	conexion.ejecutaS (strInst)

wend
%>