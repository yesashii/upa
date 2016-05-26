
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "obtiene_rut.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
arch=request.QueryString("arch")
Response.AddHeader "Content-Disposition", "attachment;filename=bd_matricula_1.csv"
Response.ContentType = "application/csv"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'carr_tdesc = request.querystring("carr_tdesc")
'carrera = carr_tdesc
'
rut=Extraer_rut(arch)
ano=Year(now())
'------------------------------------------------------------------------------------
set tabla = new cformulario
tabla.carga_parametros	"tabla_vacia.xml",	"tabla"
tabla.inicializar		conexion
		
'consulta = "select  distinct a.pers_nrut, a.pers_xdv, a.pers_tape_paterno,a.pers_tape_materno,a.pers_tnombre, " & vbCrlf & _
'       		"protic.obtener_tipo_ies('ing') as Tipo_ies ,protic.obtener_codigo_institucion_ies('ing') as cod_IES, " & vbCrlf & _
'			"m.seie_ing_ccod as Sede,h.cod_carrera_ing as Carrera, r.jorn_ccod, " & vbCrlf & _
'			"t.aran_mcolegiatura " & vbCrlf & _
'			"from personas a, " & vbCrlf & _
'				"ufe_alumnos_cae g, " & vbCrlf & _
'				"ufe_carreras_ingresa h, " & vbCrlf & _
'				"carreras i, " & vbCrlf & _
'				"sedes l, " & vbCrlf & _
'				"ufe_sedes_ies m, " & vbCrlf & _
'				"ufe_carreras_homologadas n, " & vbCrlf & _
'				"alumnos o, " & vbCrlf & _
'				"postulantes p, " & vbCrlf & _
'				"ofertas_academicas r, " & vbCrlf & _
'				"especialidades s, " & vbCrlf & _
'                "aranceles t " & vbCrlf & _
'				"where h.cod_carrera_ing= g.carrera " & vbCrlf & _
'				"and n.carr_ccod COLLATE Modern_Spanish_CI_AS =i.carr_ccod " & vbCrlf & _
'				"and h.car_ing_ncorr= n.car_ing_ncorr " & vbCrlf & _
'				"and g.sede=m.seie_ing_ccod " & vbCrlf & _
'				"and m.sede_ccod=l.SEDE_CCOD " & vbCrlf & _
'				"and a.pers_nrut=g.rut " & vbCrlf & _
'				"and a.pers_ncorr=o.PERS_NCORR " & vbCrlf & _
'				"and o.post_ncorr=p.post_ncorr " & vbCrlf & _
'				"and p.PERI_CCOD in(select peri_ccod from periodos_academicos where anos_ccod in (g.anos_ccod)) " & vbCrlf & _
'				"and o.OFER_NCORR=r.OFER_NCORR " & vbCrlf & _
'				"and g.anos_ccod="& ano & vbCrlf & _ 
'				"and r.ESPE_CCOD=s.ESPE_CCOD " & vbCrlf & _
'				"and n.carr_ccod COLLATE Modern_Spanish_CI_AS =s.CARR_CCOD " & vbCrlf & _
'                "and r.aran_ncorr=t.aran_ncorr"	& vbCrlf & _
'				"and t.aran_mcolegiatura > 1" & vbCrlf & _
'				"and a.pers_nrut in ("&rut&")"	
				
				
				
'consulta ="select  distinct a.pers_nrut, a.pers_xdv, a.pers_tape_paterno,a.pers_tape_materno,a.pers_tnombre, " & vbCrlf & _
'				"protic.obtener_tipo_ies('ing') as Tipo_ies ,protic.obtener_codigo_institucion_ies('ing') as cod_IES, " & vbCrlf & _
'				"m.seie_ing_ccod as Sede,h.cod_carrera_ing as Carrera, r.jorn_ccod, " & vbCrlf & _
'				"t.aran_mcolegiatura " & vbCrlf & _
'				"from personas a, " & vbCrlf & _
'				"ufe_carreras_ingresa h," & vbCrlf & _ 
'				"carreras i, " & vbCrlf & _
'				"sedes l, " & vbCrlf & _
'				"ufe_sedes_ies m, " & vbCrlf & _
'				"ufe_carreras_homologadas n, " & vbCrlf & _
'				"alumnos o, " & vbCrlf & _
'				"postulantes p, " & vbCrlf & _
'				"ofertas_academicas r, " & vbCrlf & _
'				"especialidades s, " & vbCrlf & _
'				"aranceles t " & vbCrlf & _
'				"where n.carr_ccod COLLATE Modern_Spanish_CI_AS =i.carr_ccod " & vbCrlf & _
'				"and h.car_ing_ncorr= n.car_ing_ncorr" & vbCrlf & _ 
'				"and r.sede_ccod=m.sede_ccod" & vbCrlf & _
'				"and m.sede_ccod=l.SEDE_CCOD " & vbCrlf & _
'				"and a.pers_ncorr=o.PERS_NCORR" & vbCrlf & _ 
'				"and o.post_ncorr=p.post_ncorr" & vbCrlf & _ 
'				"and p.PERI_CCOD in(select peri_ccod from periodos_academicos where anos_ccod in ("& ano &"))" & vbCrlf & _ 
'				"and o.OFER_NCORR=r.OFER_NCORR " & vbCrlf & _
'				"and r.ESPE_CCOD=s.ESPE_CCOD" & vbCrlf & _ 
'				"and n.carr_ccod COLLATE Modern_Spanish_CI_AS =s.CARR_CCOD " & vbCrlf & _
'				"and r.aran_ncorr=t.aran_ncorr" & vbCrlf & _
'				"and t.aran_mcolegiatura > 1" & vbCrlf & _
'				"and a.pers_nrut in ("&rut&")"
				

consulta ="select  distinct a.pers_nrut, a.pers_xdv, a.pers_tape_paterno,a.pers_tape_materno,a.pers_tnombre, " & vbCrlf & _
				"protic.obtener_tipo_ies('ing') as Tipo_ies ,protic.obtener_codigo_institucion_ies('ing') as cod_IES, " & vbCrlf & _
				"m.seie_ing_ccod as Sede,cast(n.car_ing_ncorr as varchar) as Carrera, r.jorn_ccod, " & vbCrlf & _
				"t.aran_mcolegiatura " & vbCrlf & _
				"from personas a, " & vbCrlf & _
				"carreras i, " & vbCrlf & _
				"sedes l, " & vbCrlf & _
				"ufe_sedes_ies m, " & vbCrlf & _
				"ufe_carreras_homologadas n, " & vbCrlf & _
				"alumnos o, " & vbCrlf & _
				"postulantes p, " & vbCrlf & _
				"ofertas_academicas r, " & vbCrlf & _
				"especialidades s, " & vbCrlf & _
				"aranceles t " & vbCrlf & _
				"where n.carr_ccod COLLATE Modern_Spanish_CI_AS =i.carr_ccod " & vbCrlf & _
				"and r.sede_ccod=m.sede_ccod" & vbCrlf & _
				"and m.sede_ccod=l.SEDE_CCOD " & vbCrlf & _
				"and a.pers_ncorr=o.PERS_NCORR" & vbCrlf & _ 
				"and o.post_ncorr=p.post_ncorr" & vbCrlf & _ 
				"and p.PERI_CCOD in(select peri_ccod from periodos_academicos where anos_ccod in ("& ano &"))" & vbCrlf & _ 
				"and o.OFER_NCORR=r.OFER_NCORR " & vbCrlf & _
				"and r.ESPE_CCOD=s.ESPE_CCOD" & vbCrlf & _ 
				"and n.carr_ccod COLLATE Modern_Spanish_CI_AS =s.CARR_CCOD " & vbCrlf & _
				"and r.aran_ncorr=t.aran_ncorr" & vbCrlf & _
				"and t.aran_mcolegiatura > 1" & vbCrlf & _
				"and o.emat_ccod not in (9) " & vbCrlf & _
				"and a.pers_nrut in ("&rut&")"
				
						
'response.Write(consulta)
'response.End()
fecha=now()
descripcion="bd_matricula_1"
usu=negocio.obtenerUsuario
usal_ncorr=conexion.ConsultaUno("exec ObtenerSecuencia 'ufe_salidas_log'")
strInst="insert into ufe_salidas_log (usal_ncorr,usal_tdesc,audi_tusuario,audi_fmodificacion, usal_parametro) values (" & usal_ncorr & ", '" & descripcion & "' ," & usu & ",'" & fecha & "', '" & rut & "')"
conexion.ejecutaS (strInst)
tabla.consultar consulta 

'------------------------------------------------------------------------------------
encabezados="RUT;DV;APELLIDO_PATERNO;APELLIDO_MATERNO;NOMBRES;COD_T_IES;COD_IES;COD_SEDE;COD_CARRERA;JORNADA;ARANCEL_REAL"
response.Write(encabezados)
Response.Write(vbCrLf)

while tabla.Siguiente
    usdl_ncorr=conexion.ConsultaUno("exec ObtenerSecuencia 'ufe_salidas_detalle_log'")
	detalle=""&tabla.ObtenerValor("pers_nrut")&";"&tabla.ObtenerValor("pers_xdv")&";"&tabla.ObtenerValor("pers_tape_paterno")&";"&tabla.ObtenerValor("pers_tape_materno")&";"&tabla.ObtenerValor("pers_tnombre")&";"&tabla.ObtenerValor("Tipo_ies")&";"&tabla.ObtenerValor("cod_IES")&";'"&tabla.ObtenerValor("Sede")&";'"&tabla.ObtenerValor("Carrera")&";'"&tabla.ObtenerValor("jorn_ccod")&";"&tabla.ObtenerValor("aran_mcolegiatura")&""
	response.Write(detalle)
	Response.Write(vbCrLf)
	strInst="insert into ufe_salidas_detalle_log (usdl_ncorr,usal_ncorr,usdl_detalle) values (" & usdl_ncorr & ", " &  usal_ncorr & ", '" & detalle & "')"
	conexion.ejecutaS (strInst)

wend
%>