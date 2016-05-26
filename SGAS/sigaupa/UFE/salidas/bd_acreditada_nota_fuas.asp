
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "obtiene_rut.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()


set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'carr_tdesc = request.querystring("carr_tdesc")
'carrera = carr_tdesc
'
arch=request.QueryString("arch")
ano=Year(now())

Response.AddHeader "Content-Disposition", "attachment;filename=bd_acreditada_nota_fuas.csv"
Response.ContentType = "application/csv"


'----
rut=Extraer_rut(arch)
'------------------------------------------------------------------------------------
set tabla = new cformulario
tabla.carga_parametros	"tabla_vacia.xml",	"tabla"
tabla.inicializar		conexion
		
consulta = "select a.pers_nrut,a.pers_nnota_ens_media as NEM, " & vbCrlf & _
			"protic.obtener_tipo_ies('ing') as Tipo_ies ," & vbCrlf & _
			"protic.obtener_codigo_institucion_ies('ing') as cod_IES, '' as NEM2  " & vbCrlf & _
			"from personas a" & vbCrlf & _
			"where a.pers_nrut in ("& rut &")" & vbCrlf & _
			"and g.anos_ccod="& ano & vbCrlf & _
			"group by a.pers_nrut,a.pers_nnota_ens_media order by a.pers_nr"			



fecha=now()
descripcion="bd_acreditada_nota_fuas"
usu=negocio.obtenerUsuario
usal_ncorr=conexion.ConsultaUno("exec ObtenerSecuencia 'ufe_salidas_log'")
strInst="insert into ufe_salidas_log (usal_ncorr,usal_tdesc,audi_tusuario,audi_fmodificacion, usal_parametro) values (" & usal_ncorr & ", '" & descripcion & "' ," & usu & ",'" & fecha & "', '" & rut & "')"
conexion.ejecutaS (strInst)
tabla.consultar consulta 
'fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
encabezados="RUT;NEM;TIPO_IES;COD_IES;NEM2;"
response.Write(encabezados)
Response.Write(vbCrLf)

while tabla.Siguiente
    usdl_ncorr=conexion.ConsultaUno("exec ObtenerSecuencia 'ufe_salidas_detalle_log'")
	detalle=""&tabla.ObtenerValor("pers_nrut")&";"&tabla.ObtenerValor("nem")&";"&tabla.ObtenerValor("Tipo_ies")&";"&tabla.ObtenerValor("cod_IES")&";"&tabla.ObtenerValor("NEM2")&""
	response.Write(detalle)
	Response.Write(vbCrLf)
	strInst="insert into ufe_salidas_detalle_log (usdl_ncorr,usal_ncorr,usdl_detalle) values (" & usdl_ncorr & ", " &  usal_ncorr & ", '" & detalle & "')"
	conexion.ejecutaS (strInst)

wend
%>