<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

'Response.AddHeader "Content-Disposition", "attachment;filename=bd_renovantes_egresados.csv"
'Response.ContentType = "application/csv"

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
		
consulta = "select  a.pers_nrut, a.pers_xdv,a.pers_tnombre, a.pers_tape_paterno,a.pers_tape_materno, " & vbCrlf & _
       		"protic.obtener_tipo_ies('ing') as Tipo_ies ,protic.obtener_codigo_institucion_ies('ing') as cod_IES, " & vbCrlf & _
			"m.seie_ing_ccod as Sede,h.cod_carrera_ing as Carrera, r.jorn_ccod, " & vbCrlf & _
			"isnull(protic.ANO_INGRESO_CARRERA_EGRESA2(a.pers_ncorr,i.CARR_CCOD), " & vbCrlf & _
			"protic.ANO_INGRESO_UNIVERSIDAD(a.pers_ncorr))as ano_ingreso, " & vbCrlf & _
			"r.jorn_ccod, aran_mcolegiatura " & vbCrlf & _
			"from personas a, " & vbCrlf & _
				"ufe_alumnos_cae g, " & vbCrlf & _
				"ufe_carreras_ingresa h, " & vbCrlf & _
				"carreras i, " & vbCrlf & _
				"sedes l, " & vbCrlf & _
				"ufe_sedes_ies m, " & vbCrlf & _
				"ufe_carreras_homologadas n, " & vbCrlf & _
				"alumnos o, " & vbCrlf & _
				"postulantes p, " & vbCrlf & _
				"ofertas_academicas r, " & vbCrlf & _
				"especialidades s, " & vbCrlf & _
                "aranceles t " & vbCrlf & _
				"where h.cod_carrera_ing= g.carrera " & vbCrlf & _
				"and n.carr_ccod COLLATE Modern_Spanish_CI_AS =i.carr_ccod " & vbCrlf & _
				"and h.car_ing_ncorr= n.car_ing_ncorr " & vbCrlf & _
				"and g.sede=m.seie_ing_ccod " & vbCrlf & _
				"and m.sede_ccod=l.SEDE_CCOD " & vbCrlf & _
				"and a.pers_nrut=g.rut " & vbCrlf & _
				"and a.pers_ncorr=o.PERS_NCORR " & vbCrlf & _
				"and o.post_ncorr=p.post_ncorr " & vbCrlf & _
				"and p.PERI_CCOD in(select peri_ccod from periodos_academicos where anos_ccod in (g.anos_ccod)) " & vbCrlf & _
				"and o.OFER_NCORR=r.OFER_NCORR " & vbCrlf & _
				"and g.anos_ccod=2011 " & vbCrlf & _ 
				"and r.ESPE_CCOD=s.ESPE_CCOD " & vbCrlf & _
				"and n.carr_ccod COLLATE Modern_Spanish_CI_AS =s.CARR_CCOD " & vbCrlf & _
                "and r.aran_ncorr=t.aran_ncorr"			

response.Write(consulta)
response.End()
tabla.consultar consulta 


'fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
response.Write("RUT;DV;NOMBRES;APELLIDO_PATERNO;APELLIDO_MATERNO;COD_T_IES;COD_IES;COD_SEDE;COD_CARRERA;ANO_INGRESO;JORNADA;ARANCEL_REAL")
Response.Write(vbCrLf)
while tabla.Siguiente
response.Write(""&tabla.ObtenerValor("pers_nrut")&";"&tabla.ObtenerValor("pers_xdv")&";"&tabla.ObtenerValor("pers_tape_paterno")&";"&tabla.ObtenerValor("pers_tape_materno")&";"&tabla.ObtenerValor("pers_tnombre")&";"&tabla.ObtenerValor("Tipo_ies")&";"&tabla.ObtenerValor("cod_IES")&";"&tabla.ObtenerValor("Sede")&";"&tabla.ObtenerValor("Carrera")&";"&tabla.ObtenerValor("ano_ingreso")&";"&tabla.ObtenerValor("jorn_ccod")&";"&tabla.ObtenerValor("aran_mcolegiatura")&"")
Response.Write(vbCrLf)
wend
%>