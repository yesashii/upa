
<!-- #include file = "../biblioteca/_conexion_sbd01.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "obtiene_rut.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
arch=request.QueryString("arch")
ano=Year(now())
'Response.AddHeader "Content-Disposition", "attachment;filename=bd_apelantes_b_ingreso_ies.csv"
'Response.ContentType = "application/csv"

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
		
consulta =  " select DISTINCT  a.pers_nrut, protic.obtener_tipo_ies('ing') as Tipo_ies ,  "  & vbCrlf & _
			" protic.obtener_codigo_institucion_ies('ing') as cod_IES, m.seie_ing_ccod as Sede,h.cod_carrera_ing as Carrera,  "  & vbCrlf & _
			" r.jorn_ccod, case (select top 1 tr.nive_ccod from malla_curricular tr where tr.plan_ccod = o.plan_ccod " & vbCrlf & _  
            " and isnull(tr.mall_npermiso,0) = 0   " & vbCrlf & _
			" and isnull(protic.estado_ramo_alumno(o.pers_ncorr,tr.asig_ccod,s.carr_ccod,tr.plan_ccod,r.peri_ccod),'') = '' " & vbCrlf & _
			" order by tr.nive_ccod asc) when 1  then '1'  when 2  then '1'  when 3  then '2'  when 4  then '2'  when 5  then '3'  when 6  then '3'  when 7  then '4'  when 8  then '4'  when 9 then '5'  else 'SNR' end as nivel_estudio "  & vbCrlf & _
			" from personas a, ufe_alumnos_cae g, ufe_carreras_ingresa h, carreras i, sedes l, ufe_sedes_ies m, direcciones q, "  & vbCrlf & _
			" ufe_carreras_homologadas n, alumnos o, postulantes p, ofertas_academicas r, ufe_ciudades_homologadas rr, ufe_ciudades u, especialidades s, aranceles t  "  & vbCrlf & _
			" where h.cod_carrera_ing= g.carrera  "  & vbCrlf & _
			" and n.carr_ccod COLLATE Modern_Spanish_CI_AS =i.carr_ccod  "  & vbCrlf & _
			" and h.car_ing_ncorr= n.car_ing_ncorr  "  & vbCrlf & _
			" and g.sede=m.seie_ing_ccod  "  & vbCrlf & _
			" and m.sede_ccod=l.SEDE_CCOD   "  & vbCrlf & _
			" and a.pers_nrut=g.rut   "  & vbCrlf & _
			" and a.pers_ncorr=o.PERS_NCORR  "  & vbCrlf & _ 
			" and o.post_ncorr=p.post_ncorr  "  & vbCrlf & _
			" and p.PERI_CCOD in(select peri_ccod from periodos_academicos where anos_ccod in (g.anos_ccod))  "  & vbCrlf & _
			" and o.OFER_NCORR=r.OFER_NCORR  "  & vbCrlf & _
			" and g.anos_ccod=" & ano & vbCrlf & _
			" and r.ESPE_CCOD=s.ESPE_CCOD  "  & vbCrlf & _
			" and a.pers_ncorr=q.PERS_NCORR  "  & vbCrlf & _
			" and q.ciud_ccod=rr.ciud_ccod  "  & vbCrlf & _
			" and rr.uhciu_ccod=u.uhciu_ccod  "  & vbCrlf & _
			" and r.aran_ncorr=t.aran_ncorr  "  & vbCrlf & _
			" and q.tdir_ccod=1 "  & vbCrlf & _
			" and n.carr_ccod COLLATE Modern_Spanish_CI_AS =s.CARR_CCOD "  & vbCrlf & _
			" and t.aran_mcolegiatura > 0 "  & vbCrlf & _
			" and a.pers_nrut in ("&rut&")"	
		 
	response.Write(consulta)
	response.End()	
fecha=now()
tabla.consultar consulta 
descripcion="bd_nivel_estudios_b_renovantes"
usu=negocio.obtenerUsuario
usal_ncorr=conexion.ConsultaUno("exec ObtenerSecuencia 'ufe_salidas_log'")
strInst="insert into ufe_salidas_log (usal_ncorr,usal_tdesc,audi_tusuario,audi_fmodificacion, usal_parametro) values (" & usal_ncorr & ", '" & descripcion & "' ," & usu & ",'" & fecha & "', '" & rut & "')"
conexion.ejecutaS (strInst)
'response.Write(consulta)
'response.End()
'------------------------------------------------------------------------------------
encabezados="RUT;TIPO_IES;CODIGO_IES;SEDE;CARRERA;JORNADA;NIVEL_ESTUDIOS"
response.Write(encabezados)
Response.Write(vbCrLf)

while tabla.Siguiente
	usdl_ncorr=conexion.ConsultaUno("exec ObtenerSecuencia 'ufe_salidas_detalle_log'")
	detalle=""&tabla.ObtenerValor("pers_nrut")&";"&tabla.ObtenerValor("Tipo_ies")&";"&tabla.ObtenerValor("cod_IES")&";"&tabla.ObtenerValor("Sede")&";"&tabla.ObtenerValor("Carrera")&";"&tabla.ObtenerValor("jorn_ccod")&";"&tabla.ObtenerValor("nivel_estudio")&""
	response.Write(detalle)
	Response.Write(vbCrLf)
	strInst="insert into ufe_salidas_detalle_log (usdl_ncorr,usal_ncorr,usdl_detalle) values (" & usdl_ncorr & ", " &  usal_ncorr & ", '" & detalle & "')"
	conexion.ejecutaS (strInst)
	
wend
%>