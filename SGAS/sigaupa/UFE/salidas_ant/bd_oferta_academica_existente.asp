
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=bd_oferta_academica_existente.csv"
Response.ContentType = "application/csv"

ano=Year(date())
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'carr_tdesc = request.querystring("carr_tdesc")
'carrera = carr_tdesc
'

'------------------------------------------------------------------------------------
set tabla = new cformulario
tabla.carga_parametros	"tabla_vacia.xml",	"tabla"
tabla.inicializar		conexion

 
consulta =	"select c.seie_ing_tdesc, b.nom_carrera_ing,  " & vbCrlf & _
        	"f.jorn_ccod , a.ofai_nduracion, a.ttie_ccod  " & vbCrlf & _
			"from ufe_oferta_academica_ing a, ufe_carreras_ingresa b, " & vbCrlf & _
			"ufe_sedes_ies c, anos d, ufe_tipo_titulo_ies e, jornadas f, " & vbCrlf & _
			"ufe_carreras_homologadas g  " & vbCrlf & _   
			"where a.carr_ccod=g.carr_ccod " & vbCrlf & _
			"and g.car_ing_ncorr=b.car_ing_ncorr " & vbCrlf & _
			"and a.sede_ccod= c.sede_ccod  " & vbCrlf & _
			"and a.jorn_ccod= f.jorn_ccod " & vbCrlf & _ 
			"and a.ttie_ccod= e.ttie_ccod " & vbCrlf & _
			"and a.anos_ccod= d.anos_ccod  " & vbCrlf & _
			"and a.anos_ccod="&ano&""
			

fecha=now()
descripcion="bd_matricula_final"
usu=negocio.obtenerUsuario
usal_ncorr=conexion.ConsultaUno("exec ObtenerSecuencia 'ufe_salidas_log'")
strInst="insert into ufe_salidas_log (usal_ncorr,usal_tdesc,audi_tusuario,audi_fmodificacion, usal_parametro) values (" & usal_ncorr & ", '" & descripcion & "' ," & usu & ",'" & fecha & "', '" & rut & "')"
conexion.ejecutaS (strInst)
tabla.consultar consulta 
'response.write(consulta)
'response.end()
'------------------------------------------------------------------------------------

encabezados="SEDE;CARRERA;JORNADA;DURACION;TIPO_TITULO_CARRERA"
response.Write(encabezados)
Response.Write(vbCrLf)
while tabla.Siguiente

usdl_ncorr=conexion.ConsultaUno("exec ObtenerSecuencia 'ufe_salidas_detalle_log'")
	detalle=""&tabla.ObtenerValor("seie_ing_tdesc")&";"&tabla.ObtenerValor("nom_carrera_ing")&";"&tabla.ObtenerValor("jorn_ccod")&";"&tabla.ObtenerValor("ofai_nduracion")&";"&tabla.ObtenerValor("ttie_ccod")&""
	response.Write(detalle)
	Response.Write(vbCrLf)
	strInst="insert into ufe_salidas_detalle_log (usdl_ncorr,usal_ncorr,usdl_detalle) values (" & usdl_ncorr & ", " &  usal_ncorr & ", '" & detalle & "')"
	conexion.ejecutaS (strInst)

wend
%>