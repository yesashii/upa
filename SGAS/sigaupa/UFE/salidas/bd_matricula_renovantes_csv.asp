
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

 
consulta= " select distinct cast(pers_nrut as varchar) as rut,pers_xdv as dv,47 as cod_ies,    " & vbCrlf & _
		"  j.seie_min_ccod as cod_sede,k.car_min_ncorr as cod_carrera,d.jorn_ccod as cod_jornada,    " & vbCrlf & _
		" protic.ANO_INGRESO_CARRERA_EGRESA2(c.pers_ncorr,f.CARR_CCOD)as ano_ingreso, 1 as  modalidad,    " & vbCrlf & _
		" case when f.carr_ccod like '3' then 2 when f.carr_ccod in('110','810','920','930') then 2 else 1 end as version,    " & vbCrlf & _
		" (select count(*) from alumnos tt, ofertas_academicas t2, especialidades t3, periodos_academicos t4, cargas_academicas t5  " & vbCrlf & _
		" where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod and t2.peri_ccod=t4.peri_ccod  " & vbCrlf & _
		" and tt.matr_ncorr=t5.matr_ncorr and tt.pers_ncorr=b.pers_ncorr and t3.carr_ccod=f.carr_ccod   " & vbCrlf & _
		" and tt.emat_ccod <> 9 and t4.anos_ccod="&ano-1&") as total_ramos_inscritos_periodo,   " & vbCrlf & _
		" (select count(*) from alumnos tt, ofertas_academicas t2, especialidades t3, periodos_academicos t4, cargas_academicas t5, situaciones_finales t6  " & vbCrlf & _
		" where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod and t2.peri_ccod=t4.peri_ccod  " & vbCrlf & _
		" and tt.matr_ncorr=t5.matr_ncorr and tt.pers_ncorr=b.pers_ncorr and t3.carr_ccod=f.carr_ccod   " & vbCrlf & _
		" and t5.sitf_ccod=t6.sitf_ccod and t6.sitf_baprueba='S' and tt.emat_ccod <> 9 and t4.anos_ccod="&ano-1&") as total_ramos_aprobados_periodo,  " & vbCrlf & _
		" (select count(*) from alumnos tt, ofertas_academicas t2, especialidades t3, periodos_academicos t4, cargas_academicas t5  " & vbCrlf & _
		" where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod and t2.peri_ccod=t4.peri_ccod  " & vbCrlf & _
		" and tt.matr_ncorr=t5.matr_ncorr and tt.pers_ncorr=b.pers_ncorr and t3.carr_ccod=f.carr_ccod   " & vbCrlf & _
		" and tt.emat_ccod <> 9 and t4.anos_ccod <= "&ano-1&") as total_ramos_historicos_carrera,  " & vbCrlf & _
		" isnull((select top 1 case " & vbCrlf & _
        "    when emat_ccod in (1,6,11,16) then '1' " & vbCrlf & _
        "    when emat_ccod in (2,3,7,13,14) then '3' " & vbCrlf & _
        "    when emat_ccod in (4,8) then '4' end " & vbCrlf & _
		"	from alumnos al, ofertas_academicas oa where al.pers_ncorr=b.PERS_NCORR and al.OFER_NCORR=oa.OFER_NCORR and peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod="&ano&" and plec_ccod in (1))),0) as tipo_matricula,  " & vbCrlf & _
		"  '000' as ramos_aprobados_historicos,'0' as en_causal,'0' as beca_externa,'0' as beca_ext,'0' as beca_interna,'0' as beca_int,'0' as semes_bachillerato,'0' as semes_conva,'0' as discapacidad        " & vbCrlf & _
		"  from alumno_credito a    " & vbCrlf & _
		"  join alumnos b    " & vbCrlf & _
		" 	 on a.post_ncorr=b.post_ncorr    " & vbCrlf & _
		" 	 and a.tdet_ccod in (910,1390,1446,1537,1538,1539,1912)    " & vbCrlf & _
		"  join tipos_detalle g    " & vbCrlf & _
		" 	 on a.tdet_ccod=g.tdet_ccod    " & vbCrlf & _
		"  join personas c    " & vbCrlf & _
		" 	 on b.pers_ncorr=c.pers_ncorr    " & vbCrlf & _
		"  join ofertas_academicas d    " & vbCrlf & _
		" 	 on b.ofer_ncorr=d.ofer_ncorr    " & vbCrlf & _
		" 	 and d.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod="&ano&" and plec_ccod in (1,2))    " & vbCrlf & _
		"  join especialidades e    " & vbCrlf & _
		" 	 on d.espe_ccod=e.espe_ccod    " & vbCrlf & _
		"  join carreras f    " & vbCrlf & _
		" 	 on e.carr_ccod=f.carr_ccod    " & vbCrlf & _
		"  left outer join ufe_sedes_ies j    " & vbCrlf & _
		" 	 on d.SEDE_CCOD=j.sede_ccod    " & vbCrlf & _
		"  join ufe_carreras_homologadas k    " & vbCrlf & _
		" 	 on f.CARR_CCOD collate Modern_Spanish_CI_AS like k.carr_ccod    " & vbCrlf & _
		"  group by b.pers_ncorr,f.carr_ccod,k.car_min_ncorr,j.seie_min_ccod,c.pers_ncorr,   " & vbCrlf & _
		"  pers_nrut,pers_xdv,d.sede_ccod,ano_adjudicacion,d.jorn_ccod    "

'response.write(consulta)
'response.Flush()			

fecha=now()
descripcion="bd_becas_alumnos_renovantes"
usu=negocio.obtenerUsuario
usal_ncorr=conexion.ConsultaUno("exec ObtenerSecuencia 'ufe_salidas_log'")
strInst="insert into ufe_salidas_log (usal_ncorr,usal_tdesc,audi_tusuario,audi_fmodificacion, usal_parametro) values (" & usal_ncorr & ", '" & descripcion & "' ," & usu & ",'" & fecha & "', '" & rut & "')"
conexion.ejecutaS (strInst)
tabla.consultar consulta 
'response.write(consulta)
'response.end()
'------------------------------------------------------------------------------------

encabezados="rut;dv;cod_ies;cod_sede;cod_carrera;cod_jornada;version;modalidad;ano_ingreso;tipo_matricula;total_ramos_inscritos_periodo;total_ramos_aprobados_periodo;total_ramos_historicos_carrera;ramos_aprobados_historicos;en_causal;beca_externa;beca_ext;beca_interna;beca_int;semes_bachillerato;semes_conva;discapacidad"
response.Write(encabezados)
Response.Write(vbCrLf)
while tabla.Siguiente

usdl_ncorr=conexion.ConsultaUno("exec ObtenerSecuencia 'ufe_salidas_detalle_log'")
	detalle=""&tabla.ObtenerValor("rut")&";"&tabla.ObtenerValor("dv")&";"&tabla.ObtenerValor("cod_ies")&";"&tabla.ObtenerValor("cod_sede")&";"&tabla.ObtenerValor("cod_carrera")&";"&tabla.ObtenerValor("cod_jornada")&";"&tabla.ObtenerValor("version")&";"&tabla.ObtenerValor("modalidad")&";"&tabla.ObtenerValor("ano_ingreso")&";"&tabla.ObtenerValor("tipo_matricula")&";" & _
	""&tabla.ObtenerValor("total_ramos_inscritos_periodo")&";"&tabla.ObtenerValor("total_ramos_aprobados_periodo")&";"&tabla.ObtenerValor("total_ramos_historicos_carrera")&";"&tabla.ObtenerValor("ramos_aprobados_historicos")&";"&tabla.ObtenerValor("en_causal")&";"&tabla.ObtenerValor("beca_externa")&";"&tabla.ObtenerValor("beca_ext")&";"&tabla.ObtenerValor("beca_interna")&";"&tabla.ObtenerValor("beca_int")&";"&tabla.ObtenerValor("semes_bachillerato")&";"&tabla.ObtenerValor("semes_conva")&";"&tabla.ObtenerValor("discapacidad")&""
	response.Write(detalle)
	Response.Write(vbCrLf)
	strInst="insert into ufe_salidas_detalle_log (usdl_ncorr,usal_ncorr,usdl_detalle) values (" & usdl_ncorr & ", " &  usal_ncorr & ", '" & detalle & "')"
	conexion.ejecutaS (strInst)

wend

%>