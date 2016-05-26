
<!-- #include file = "../biblioteca/_conexion_sbd01.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "obtiene_rut.asp" -->
<%
server.ScriptTimeout = 8500
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
arch=request.QueryString("arch")
Response.AddHeader "Content-Disposition", "attachment;filename=bd_matricula_final.csv"
Response.ContentType = "application/csv"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

rut=Extraer_rut(arch)
ano=Year(now())
'carr_tdesc = request.querystring("carr_tdesc")
'carrera = carr_tdesc
'------------------------------------------------------------------------------------
set tabla = new cformulario
tabla.carga_parametros	"tabla_vacia.xml",	"tabla"
tabla.inicializar		conexion
		
'consulta = 	"select distinct a.pers_nrut, a.pers_xdv, a.pers_tape_paterno,a.pers_tape_materno, a.pers_tnombre, case a.sexo_ccod when '2' then 'F' when '1' then 'M' end as Sexo, " & vbCrlf & _
'			" CONVERT(VARCHAR(10), a.pers_fnacimiento, 103) as fecha_nacimiento, REPLACE(protic.ufe_obtener_direccion(a.pers_ncorr,1),';','') as direccion , " & vbCrlf & _
'			" u.codigo_ciudad, u.codigo_comuna, u.codigo_region, '' as Codigo_area,a.pers_tfono, a.pers_tcelular, a.pers_temail, protic.obtener_tipo_ies('ing') as Tipo_ies , " & vbCrlf & _
'			" protic.obtener_codigo_institucion_ies('ing') as cod_IES, m.seie_ing_ccod as Sede,h.cod_carrera_ing as Carrera, " & vbCrlf & _
'			" r.jorn_ccod, isnull(protic.ANO_INGRESO_CARRERA_EGRESA2(a.pers_ncorr,i.CARR_CCOD), protic.ANO_INGRESO_UNIVERSIDAD(a.pers_ncorr))as ano_ingreso, " & vbCrlf & _ 
'			" case (select top 1 tr.nive_ccod from malla_curricular tr where tr.plan_ccod = o.plan_ccod " & vbCrlf & _  
'            " and isnull(tr.mall_npermiso,0) = 0   " & vbCrlf & _
'			" and isnull(protic.estado_ramo_alumno(o.pers_ncorr,tr.asig_ccod,s.carr_ccod,tr.plan_ccod,r.peri_ccod),'') = '' " & vbCrlf & _
'			" order by tr.nive_ccod asc) when 1  then '1'  when 2  then '1'  when 3  then '2'  when 4  then '2'  when 5  then '3'  when 6  then '3'  when 7  then '4'  when 8  then '4'  when 9 then '5'  else 'SNR' end as nivel_estudio, '' as arancel_solicitado, t.aran_mcolegiatura " & vbCrlf & _
'			" from personas a, ufe_alumnos_cae g, ufe_carreras_ingresa h, carreras i, sedes l, ufe_sedes_ies m, direcciones q, " & vbCrlf & _
'			" ufe_carreras_homologadas n, alumnos o, postulantes p, ofertas_academicas r, ufe_ciudades_homologadas rr, ufe_ciudades u, especialidades s, aranceles t where h.cod_carrera_ing= g.carrera  " & vbCrlf & _
'			" and n.carr_ccod COLLATE Modern_Spanish_CI_AS =i.carr_ccod " & vbCrlf & _
'			" and h.car_ing_ncorr= n.car_ing_ncorr  " & vbCrlf & _
'			" and g.sede=m.seie_ing_ccod " & vbCrlf & _
'			" and m.sede_ccod=l.SEDE_CCOD  " & vbCrlf & _
'			" and a.pers_nrut=g.rut  " & vbCrlf & _
'			" and a.pers_ncorr=o.PERS_NCORR  " & vbCrlf & _
'			" and o.post_ncorr=p.post_ncorr  " & vbCrlf & _
'			" and p.PERI_CCOD in(select peri_ccod from periodos_academicos where anos_ccod in (g.anos_ccod)) " & vbCrlf & _
'			" and o.OFER_NCORR=r.OFER_NCORR  " & vbCrlf & _
'			" and g.anos_ccod=" & ano & vbCrlf & _
'			" and r.ESPE_CCOD=s.ESPE_CCOD " & vbCrlf & _
'			" and a.pers_ncorr=q.PERS_NCORR " & vbCrlf & _
'			" and q.ciud_ccod=rr.ciud_ccod " & vbCrlf & _
'			" and rr.uhciu_ccod=u.uhciu_ccod " & vbCrlf & _
'			" and r.aran_ncorr=t.aran_ncorr " & vbCrlf & _
'			" and q.tdir_ccod=1 " & vbCrlf & _
'			" and t.aran_mcolegiatura > 1 " & vbCrlf & _
'			" and n.carr_ccod COLLATE Modern_Spanish_CI_AS =s.CARR_CCOD and r.aran_ncorr=t.aran_ncorr " & vbCrlf & _
'			" and exists(select 1 from contratos con, compromisos com "   & vbCrlf & _
'            "        where con.post_ncorr=o.post_ncorr " & vbCrlf & _
'            "       and con.cont_ncorr=com.comp_ndocto  " & vbCrlf & _
'            "        and com.tcom_ccod in (1,2)) " & vbCrlf & _
'			" and a.pers_nrut in ("&rut&")"	


consulta= " select distinct  a.pers_nrut, a.pers_xdv, a.pers_tape_paterno,a.pers_tape_materno, a.pers_tnombre, " & vbCrlf & _
			" case a.sexo_ccod when '2' then 'F' when '1' then 'M' end as Sexo, " & vbCrlf & _
			" CONVERT(VARCHAR(10), a.pers_fnacimiento, 103) as fecha_nacimiento, " & vbCrlf & _
			" REPLACE(protic.ufe_obtener_direccion(a.pers_ncorr,1),';','') as direccion ,u.codigo_ciudad, u.codigo_comuna, u.codigo_region, '' as Codigo_area,a.pers_tfono, a.pers_tcelular, a.pers_temail, protic.obtener_tipo_ies('ing') as Tipo_ies , " & vbCrlf & _
			" protic.obtener_codigo_institucion_ies('ing') as cod_IES, m.seie_ing_ccod as Sede, " & vbCrlf & _
			" h.cod_carrera_ing as Carrera, r.jorn_ccod, isnull(protic.ANO_INGRESO_CARRERA_EGRESA2(a.pers_ncorr,i.CARR_CCOD), protic.ANO_INGRESO_UNIVERSIDAD(a.pers_ncorr))as ano_ingreso, " & vbCrlf & _
			" case (select top 1 tr.nive_ccod from malla_curricular tr where tr.plan_ccod = o.plan_ccod   " & vbCrlf & _
			" and isnull(tr.mall_npermiso,0) = 0   " & vbCrlf & _
			" and isnull(protic.estado_ramo_alumno(o.pers_ncorr,tr.asig_ccod,s.carr_ccod,tr.plan_ccod,r.peri_ccod),'') = ''  " & vbCrlf & _
			" order by tr.nive_ccod asc) when 1  then '1'  when 2  then '1'  when 3  then '2'  when 4  then '2'  when 5  then '3'when 6  then '3'  when 7  then '4'  when 8  then '4'  when 9 then '5'  else 'SNR' end as nivel_estudio, '' as arancel_solicitado, t.aran_mcolegiatura  " & vbCrlf & _
			" from personas a, " & vbCrlf & _
			" ufe_carreras_ingresa h, " & vbCrlf & _
			" carreras i,  " & vbCrlf & _
			" sedes l,  " & vbCrlf & _
			" ufe_sedes_ies m,  " & vbCrlf & _
			" ufe_carreras_homologadas n, " & vbCrlf & _
			" alumnos o, " & vbCrlf & _
			" postulantes p, " & vbCrlf & _
			" direcciones q, " & vbCrlf & _
			" ofertas_academicas r, " & vbCrlf & _
			" ufe_ciudades_homologadas rr, " & vbCrlf & _
			" ufe_ciudades u, " & vbCrlf & _
			" especialidades s, " & vbCrlf & _
			" aranceles t " & vbCrlf & _
			" where n.carr_ccod COLLATE Modern_Spanish_CI_AS =i.carr_ccod  " & vbCrlf & _
			" and h.car_ing_ncorr= n.car_ing_ncorr " & vbCrlf & _
			" and r.sede_ccod=m.sede_ccod " & vbCrlf & _
			" and m.sede_ccod=l.SEDE_CCOD  " & vbCrlf & _
			" and a.pers_ncorr=o.PERS_NCORR " & vbCrlf & _
			" and o.post_ncorr=p.post_ncorr " & vbCrlf & _
			" and p.PERI_CCOD in(select peri_ccod from periodos_academicos where anos_ccod in (datepart(yyyy,getdate()))) " & vbCrlf & _
			" and o.OFER_NCORR=r.OFER_NCORR " & vbCrlf & _
			" and a.pers_ncorr=q.PERS_NCORR " & vbCrlf & _
			" and q.ciud_ccod=rr.ciud_ccod " & vbCrlf & _
			" and q.tdir_ccod=1 " & vbCrlf & _
			" and rr.uhciu_ccod=u.uhciu_ccod  " & vbCrlf & _
			" and r.ESPE_CCOD=s.ESPE_CCOD " & vbCrlf & _
			" and n.carr_ccod COLLATE Modern_Spanish_CI_AS =s.CARR_CCOD  " & vbCrlf & _
			" and r.aran_ncorr=t.aran_ncorr " & vbCrlf & _
			" and exists(select 1 from contratos con, compromisos com  " & vbCrlf & _
			"             where con.post_ncorr=o.post_ncorr " & vbCrlf & _
			"             and con.cont_ncorr=com.comp_ndocto  " & vbCrlf & _
			"             and com.tcom_ccod in (1,2)) " & vbCrlf & _
			" and t.aran_mcolegiatura > 1 " & vbCrlf & _
			" and a.pers_nrut in ("&rut&")"	



'response.Write(consulta)
'response.End()

fecha=now()
descripcion="bd_matricula_final"
usu=negocio.obtenerUsuario
usal_ncorr=conexion.ConsultaUno("exec ObtenerSecuencia 'ufe_salidas_log'")
strInst="insert into ufe_salidas_log (usal_ncorr,usal_tdesc,audi_tusuario,audi_fmodificacion, usal_parametro) values (" & usal_ncorr & ", '" & descripcion & "' ," & usu & ",'" & fecha & "', '" & rut & "')"
conexion.ejecutaS (strInst)
tabla.consultar consulta 
'response.Write(consulta)
'response.End()
'------------------------------------------------------------------------------------
encabezados="RUT;DV;APELLIDO_PATERNO;APELLIDO_MATERNO;NOMBRES;SEXO;FECHA_NACIMIENTO;DIRECCION;CIUDAD;COMUNA;REGION;COD_AREA;FONO_FIJO;CELULAR;EMAIL;COD_T_IES;COD_IES;COD_SEDE;COD_CARRERA;JORNADA;ANO_ING_CARRERA;NIVEL_ESTUDIOS;ARANCEL_SOLICITADO;ARANCEL_REAL"
response.Write(encabezados)
Response.Write(vbCrLf)

while tabla.Siguiente
    usdl_ncorr=conexion.ConsultaUno("exec ObtenerSecuencia 'ufe_salidas_detalle_log'")
	detalle=""&tabla.ObtenerValor("pers_nrut")&";"&tabla.ObtenerValor("pers_xdv")&";"&tabla.ObtenerValor("pers_tape_paterno")&";"&tabla.ObtenerValor("pers_tape_materno")&";"&tabla.ObtenerValor("pers_tnombre")&";"&tabla.ObtenerValor("sexo")&";"&tabla.ObtenerValor("fecha_nacimiento")&";"&tabla.ObtenerValor("direccion")&";"&tabla.ObtenerValor("codigo_ciudad")&";"&tabla.ObtenerValor("codigo_comuna")&";"&tabla.ObtenerValor("codigo_region")&";"&tabla.ObtenerValor("Codigo_area")&";"&tabla.ObtenerValor("pers_tfono")&";"&tabla.ObtenerValor("pers_tcelular")&";"&tabla.ObtenerValor("pers_temail")&";"&tabla.ObtenerValor("Tipo_ies")&";"&tabla.ObtenerValor("cod_IES")&";"&tabla.ObtenerValor("Sede")&";"&tabla.ObtenerValor("Carrera")&";"&tabla.ObtenerValor("jorn_ccod")&";"&tabla.ObtenerValor("ano_ingreso")&";"&tabla.ObtenerValor("nivel_estudio")&";"&tabla.ObtenerValor("arancel_solicitado")&";"&tabla.ObtenerValor("aran_mcolegiatura")&""
	response.Write(detalle)
	Response.Write(vbCrLf)
	strInst="insert into ufe_salidas_detalle_log (usdl_ncorr,usal_ncorr,usdl_detalle) values (" & usdl_ncorr & ", " &  usal_ncorr & ", '" & detalle & "')"
	conexion.ejecutaS (strInst)

wend
%>