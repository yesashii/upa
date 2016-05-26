
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=bd_oferta_academica_nueva.csv"
Response.ContentType = "application/csv"

ano=Year(now())
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

 
consulta =	"select protic.obtener_tipo_ies('ing') as Tipo_ies ,protic.obtener_codigo_institucion_ies('ing') as cod_IES,c.seie_ing_ccod as Sede, b.cod_carrera_ing as Carrera, " & vbCrlf & _
			"f.jorn_ccod as Jornada, a.ofai_nduracion, a.ttie_ccod " & vbCrlf & _
			"from ufe_oferta_academica_ing a, ufe_carreras_ingresa b, ufe_sedes_ies c, " & vbCrlf & _
			"anos d, ufe_tipo_titulo_ies e, jornadas f," & vbCrlf & _
			"ufe_carreras_homologadas g " & vbCrlf & _
			"where a.carr_ccod=g.carr_ccod " & vbCrlf & _
			"and g.car_ing_ncorr=b.car_ing_ncorr  " & vbCrlf & _
			"and a.sede_ccod= c.sede_ccod " & vbCrlf & _
			"and a.jorn_ccod= f.jorn_ccod " & vbCrlf & _
			"and a.ttie_ccod= e.ttie_ccod " & vbCrlf & _
			"and a.anos_ccod= d.anos_ccod " & vbCrlf & _
			"and a.anos_ccod="&ano&""
			

tabla.consultar consulta 

'response.Write(consulta)
'response.End()
'fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
response.Write("codigo_tipo_ies;codigo_de_ies;codigo_de_sede;codigo_de_carrera;jornada;ano_duracion_carrera;tipo_titulo_de_carrera")
Response.Write(vbCrLf)
while tabla.Siguiente
response.Write(""&tabla.ObtenerValor("tipo_ies")&";"&tabla.ObtenerValor("cod_IES")&";"&tabla.ObtenerValor("Sede")&";"&tabla.ObtenerValor("Carrera")&";"&tabla.ObtenerValor("Jornada")&";"&tabla.ObtenerValor("duracion")&";"&tabla.ObtenerValor("ttie_ccod")&"")
Response.Write(vbCrLf)
wend
%>