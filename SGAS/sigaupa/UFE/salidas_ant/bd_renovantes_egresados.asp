
<!-- #include file = "../biblioteca/_conexion_sbd01.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "obtiene_rut.asp" -->
<%
server.ScriptTimeout = 8500
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()


set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
arch=request.QueryString("arch")
ano=Year(now())
rut=Extraer_rut(arch)
'rut=""
'carr_tdesc = request.querystring("carr_tdesc")
'carrera = carr_tdesc
'------------------------------------------------------------------------------------
set tabla = new cformulario
tabla.carga_parametros	"tabla_vacia.xml",	"tabla"
tabla.inicializar		conexion
		
consulta = 	" select a.pers_nrut, a.pers_xdv,a.pers_tnombre, a.pers_tape_paterno,a.pers_tape_materno,  " & vbCrlf & _
			" case a.sexo_ccod when '2' then 'F' when '1' then 'M' end as Sexo, CONVERT(VARCHAR(10), a.pers_fnacimiento, 103) as fecha_nacimiento, " & vbCrlf & _
			" REPLACE(protic.ufe_obtener_direccion(a.pers_ncorr,1),';','') as direccion , u.codigo_ciudad, u.codigo_comuna, u.codigo_region, " & vbCrlf & _
			" '' as Codigo_area,a.pers_tfono, a.pers_tcelular, a.pers_temail, protic.obtener_tipo_ies('ing') as Tipo_ies , " & vbCrlf & _
			" protic.obtener_codigo_institucion_ies('ing') as cod_IES, m.seie_ing_ccod as Sede,h.cod_carrera_ing as Carrera, " & vbCrlf & _
			" r.jorn_ccod, t.aran_mcolegiatura as arancel_real, '' as egresado, " & vbCrlf & _
			" ISNULL(protic.trunc((select fecha_egreso  from detalles_titulacion_carrera uu where  o.pers_ncorr=uu.pers_ncorr and o.plan_ccod=uu.plan_ccod  and n.carr_ccod COLLATE Modern_Spanish_CI_AS =uu.carr_ccod )), 'NO EXISTE') as fecha_egreso,'' as fecha_u_matricula, " & vbCrlf & _
			"  '' as c_estudios, case (select top 1 tr.nive_ccod from malla_curricular tr where tr.plan_ccod = o.plan_ccod " & vbCrlf & _  
            " and isnull(tr.mall_npermiso,0) = 0   " & vbCrlf & _
			" and isnull(protic.estado_ramo_alumno(o.pers_ncorr,tr.asig_ccod,s.carr_ccod,tr.plan_ccod,r.peri_ccod),'') = '' " & vbCrlf & _
			" order by tr.nive_ccod asc) when 1  then '1'  when 2  then '1'  when 3  then '2'  when 4  then '2'  when 5  then '3'  when 6  then '3'  when 7  then '4'  when 8  then '4'  when 9 then '5'  else 'SNR' end as nivel_estudio,  '' as C_E_A  " & vbCrlf & _
			"  from personas a, ufe_alumnos_cae g, ufe_carreras_ingresa h, carreras i, sedes l, ufe_sedes_ies m, direcciones q, " & vbCrlf & _
			"  ufe_carreras_homologadas n, alumnos o, postulantes p, ofertas_academicas r, ufe_ciudades_homologadas rr, ufe_ciudades u, especialidades s, aranceles t " & vbCrlf & _
			"  where h.cod_carrera_ing= g.carrera  " & vbCrlf & _
			"  and n.carr_ccod COLLATE Modern_Spanish_CI_AS =i.carr_ccod  " & vbCrlf & _
			"  and h.car_ing_ncorr= n.car_ing_ncorr  " & vbCrlf & _
			"  and g.sede=m.seie_ing_ccod  " & vbCrlf & _
			"  and m.sede_ccod=l.SEDE_CCOD  " & vbCrlf & _
			"  and a.pers_nrut=g.rut  " & vbCrlf & _
			"  and a.pers_ncorr=o.PERS_NCORR  " & vbCrlf & _
			"  and o.post_ncorr=p.post_ncorr  " & vbCrlf & _
			"  and p.PERI_CCOD in(select peri_ccod from periodos_academicos where anos_ccod in (g.anos_ccod)) " & vbCrlf & _
			"  and o.OFER_NCORR=r.OFER_NCORR  " & vbCrlf & _
			"  and g.anos_ccod=datepart(yyyy,getdate())-1" & vbCrlf & _
			"  and r.ESPE_CCOD=s.ESPE_CCOD " & vbCrlf & _
			"  and a.pers_ncorr=q.PERS_NCORR " & vbCrlf & _
			"  and q.ciud_ccod=rr.ciud_ccod " & vbCrlf & _
			"  and rr.uhciu_ccod=u.uhciu_ccod " & vbCrlf & _
			"  and r.aran_ncorr=t.aran_ncorr " & vbCrlf & _
			"  and q.tdir_ccod=1 " & vbCrlf & _
			"  and n.carr_ccod COLLATE Modern_Spanish_CI_AS =s.CARR_CCOD and r.aran_ncorr=t.aran_ncorr " & vbCrlf & _
			"  and o.emat_ccod=4 " & vbCrlf & _
			" and a.pers_nrut in ("&rut&") " & vbCrlf & _	
			
			" union " & vbCrlf & _
			
			" select a.pers_nrut, a.pers_xdv,a.pers_tnombre, a.pers_tape_paterno,a.pers_tape_materno,  " & vbCrlf & _
			" case a.sexo_ccod when '2' then 'F' when '1' then 'M' end as Sexo, CONVERT(VARCHAR(10), a.pers_fnacimiento, 103) as fecha_nacimiento, " & vbCrlf & _
			" REPLACE(protic.ufe_obtener_direccion(a.pers_ncorr,1),';','') as direccion , u.codigo_ciudad, u.codigo_comuna, u.codigo_region, " & vbCrlf & _
			" '' as Codigo_area,a.pers_tfono, a.pers_tcelular, a.pers_temail, protic.obtener_tipo_ies('ing') as Tipo_ies , " & vbCrlf & _
			" protic.obtener_codigo_institucion_ies('ing') as cod_IES, m.seie_ing_ccod as Sede,h.cod_carrera_ing as Carrera, " & vbCrlf & _
			" r.jorn_ccod, t.aran_mcolegiatura as arancel_real, '' as egresado, " & vbCrlf & _
			" ISNULL(protic.trunc((select fecha_egreso  from detalles_titulacion_carrera uu where  o.pers_ncorr=uu.pers_ncorr and o.plan_ccod=uu.plan_ccod  and n.carr_ccod COLLATE Modern_Spanish_CI_AS =uu.carr_ccod )), 'NO EXISTE') as fecha_egreso,'' as fecha_u_matricula, " & vbCrlf & _
			"  '' as c_estudios, case (select top 1 tr.nive_ccod from malla_curricular tr where tr.plan_ccod = o.plan_ccod " & vbCrlf & _  
            " and isnull(tr.mall_npermiso,0) = 0   " & vbCrlf & _
			" and isnull(protic.estado_ramo_alumno(o.pers_ncorr,tr.asig_ccod,s.carr_ccod,tr.plan_ccod,r.peri_ccod),'') = '' " & vbCrlf & _
			" order by tr.nive_ccod asc) when 1  then '1'  when 2  then '1'  when 3  then '2'  when 4  then '2'  when 5  then '3'  when 6  then '3'  when 7  then '4'  when 8  then '4'  when 9 then '5'  else 'SNR' end as nivel_estudio,  '' as C_E_A  " & vbCrlf & _
			"  from personas a, ufe_alumnos_cae g, ufe_carreras_ingresa h, carreras i, sedes l, ufe_sedes_ies m, direcciones q, " & vbCrlf & _
			"  ufe_carreras_homologadas n, alumnos o, postulantes p, ofertas_academicas r, ufe_ciudades_homologadas rr, ufe_ciudades u, especialidades s, aranceles t " & vbCrlf & _
			"  where h.cod_carrera_ing= g.carrera  " & vbCrlf & _
			"  and n.carr_ccod COLLATE Modern_Spanish_CI_AS =i.carr_ccod  " & vbCrlf & _
			"  and h.car_ing_ncorr= n.car_ing_ncorr  " & vbCrlf & _
			"  and g.sede=m.seie_ing_ccod  " & vbCrlf & _
			"  and m.sede_ccod=l.SEDE_CCOD  " & vbCrlf & _
			"  and a.pers_nrut=g.rut  " & vbCrlf & _
			"  and a.pers_ncorr=o.PERS_NCORR  " & vbCrlf & _
			"  and o.post_ncorr=p.post_ncorr  " & vbCrlf & _
			"  and p.PERI_CCOD in(select peri_ccod from periodos_academicos where anos_ccod in (datepart(yyyy,getdate()))) " & vbCrlf & _
			"  and o.OFER_NCORR=r.OFER_NCORR  " & vbCrlf & _
			"  and g.anos_ccod=datepart(yyyy,getdate())-1" & vbCrlf & _
			"  and r.ESPE_CCOD=s.ESPE_CCOD " & vbCrlf & _
			"  and a.pers_ncorr=q.PERS_NCORR " & vbCrlf & _
			"  and q.ciud_ccod=rr.ciud_ccod " & vbCrlf & _
			"  and rr.uhciu_ccod=u.uhciu_ccod " & vbCrlf & _
			"  and r.aran_ncorr=t.aran_ncorr " & vbCrlf & _
			"  and q.tdir_ccod=1 " & vbCrlf & _
			"  and n.carr_ccod COLLATE Modern_Spanish_CI_AS =s.CARR_CCOD and r.aran_ncorr=t.aran_ncorr " & vbCrlf & _
			"  and o.emat_ccod=4 " & vbCrlf & _
			" and a.pers_nrut in ("&rut&")"	


fecha=now()

'response.Write(consulta)
'response.End()

tabla.consultar consulta 
descripcion="bd_renovantes_egresados"
usu=negocio.obtenerUsuario
usal_ncorr=conexion.ConsultaUno("exec ObtenerSecuencia 'ufe_salidas_log'")
strInst="insert into ufe_salidas_log (usal_ncorr,usal_tdesc,audi_tusuario,audi_fmodificacion, usal_parametro) values (" & usal_ncorr & ", '" & descripcion & "' ," & usu & ",'" & fecha & "', '" & rut & "')"
conexion.ejecutaS (strInst)
'response.Write(consulta)
'response.End()
'------------------------------------------------------------------------------------
encabezados="RUT;DV;NOMBRES;PATERNO;MATERNO;SEXO;FECHA_NACIMIENTO;DIRECCION;CIUDAD;COMUNA;REGION;CODIGO_AREA;FONO_FIJO;CELULAR;EMAIL_ALUMNO;CODIGO_TIPO_IES;CODIGO_DE_IES;CODIGO_DE_SEDE;CODIGO_DE_CARRERA;JORNADA;ARANCEL_REAL;EGRESADO;FECHA_EGRESO;FECHA_ULTIMA_MATRICULA;CONTINUIDAD_DE_ESTUDIOS;NIVEL_ESTUDIOS;CUMPLIMIENTO_EXIGENCIAS_ACADEMICAS"
response.Write(encabezados)
Response.Write(vbCrLf)

while tabla.Siguiente
    usdl_ncorr=conexion.ConsultaUno("exec ObtenerSecuencia 'ufe_salidas_detalle_log'")
	detalle=""&tabla.ObtenerValor("pers_nrut")&";"&tabla.ObtenerValor("pers_xdv")&";"&tabla.ObtenerValor("pers_tnombre")&";"&tabla.ObtenerValor("pers_tape_paterno")&";"&tabla.ObtenerValor("pers_tape_materno")&";"&tabla.ObtenerValor("sexo")&";"&tabla.ObtenerValor("fecha_nacimiento")&";"&tabla.ObtenerValor("direccion")&";"&tabla.ObtenerValor("codigo_ciudad")&";"&tabla.ObtenerValor("codigo_comuna")&";"&tabla.ObtenerValor("codigo_region")&";"&tabla.ObtenerValor("codigo_area")&";"&tabla.ObtenerValor("pers_tfono")&";"&tabla.ObtenerValor("pers_tcelular")&";"&tabla.ObtenerValor("pers_temail")&";"&tabla.ObtenerValor("tipo_ies")&";"&tabla.ObtenerValor("cod_ies")&";"&tabla.ObtenerValor("sede")&";"&tabla.ObtenerValor("carrera")&";"&tabla.ObtenerValor("jorn_ccod")&";"&tabla.ObtenerValor("arancel_real")&";"&tabla.ObtenerValor("egresado")&";"&tabla.ObtenerValor("fecha_egreso")&";"&tabla.ObtenerValor("fecha_u_matricula")&";"&tabla.ObtenerValor("c_estudioa")&";"&tabla.ObtenerValor("nivel_estudio")&";"&tabla.ObtenerValor("c_e_a")&""
	response.Write(detalle)
	Response.Write(vbCrLf)
	strInst="insert into ufe_salidas_detalle_log (usdl_ncorr,usal_ncorr,usdl_detalle) values (" & usdl_ncorr & ", " &  usal_ncorr & ", '" & detalle & "')"
	conexion.ejecutaS (strInst)

wend
Response.AddHeader "Content-Disposition", "attachment;filename=bd_renovantes_egresados.csv"
Response.ContentType = "application/csv"

%>