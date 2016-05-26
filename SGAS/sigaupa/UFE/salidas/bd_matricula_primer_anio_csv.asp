<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "obtiene_rut.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=bd_matricula_primer_agno.csv"
Response.ContentType = "application/csv"

arch=request.QueryString("arch")
ano=Year(date())


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


consulta =	" select distinct cast(pers_nrut as varchar) as rut,pers_xdv as dv,pers_tape_paterno as paterno,pers_tape_materno as materno,pers_tnombre as nombres,  " & vbCrlf & _
			" protic.ANO_INGRESO_CARRERA_EGRESA2(c.pers_ncorr,f.CARR_CCOD)as ano_ingreso, 1 as semestre_ingreso,  " & vbCrlf & _
			" 1 as semestre_ingreso,j.seie_min_ccod as cod_sede,k.car_ing_ncorr as cod_carrera, 1 as  modalidad,  " & vbCrlf & _
			" case when f.carr_ccod in('110','117') then 2   " & vbCrlf & _
			" when f.carr_ccod in('116','810','920','930') then 3 " & vbCrlf & _
			" when f.carr_ccod in('115') then 4 " & vbCrlf & _
			" else 1 end as version,  " & vbCrlf & _
			" d.jorn_ccod as cod_jornada,protic.obtener_psu(b.pers_ncorr,'P') as promedio_psu, cast(isnull(c.pers_nnota_ens_media,0)*100 as integer) as nem  " & vbCrlf & _
			" from alumno_credito a  " & vbCrlf & _
			" join alumnos b  " & vbCrlf & _
			"     on a.post_ncorr=b.post_ncorr  " & vbCrlf & _
			"     and a.tdet_ccod in (910,1390,1446,1537,1538,1539,1912)  " & vbCrlf & _
			" join tipos_detalle g  " & vbCrlf & _
			"     on a.tdet_ccod=g.tdet_ccod  " & vbCrlf & _
			" join personas c  " & vbCrlf & _
			"     on b.pers_ncorr=c.pers_ncorr  " & vbCrlf & _
			" join ofertas_academicas d  " & vbCrlf & _
			"     on b.ofer_ncorr=d.ofer_ncorr  " & vbCrlf & _
			"     and d.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod="&ano&" and plec_ccod=1)  " & vbCrlf & _
			" join especialidades e  " & vbCrlf & _
			"     on d.espe_ccod=e.espe_ccod  " & vbCrlf & _
			" join carreras f  " & vbCrlf & _
			"     on e.carr_ccod=f.carr_ccod  " & vbCrlf & _
			" join areas_academicas h  " & vbCrlf & _
			"     on f.area_ccod=h.area_ccod  " & vbCrlf & _
			" join facultades i  " & vbCrlf & _
			"     on h.facu_ccod=i.facu_ccod  " & vbCrlf & _
			" left outer join ufe_sedes_ies j  " & vbCrlf & _
			"     on d.SEDE_CCOD=j.sede_ccod  " & vbCrlf & _
			" join ufe_carreras_homologadas k  " & vbCrlf & _
			"     on f.CARR_CCOD collate Modern_Spanish_CI_AS like k.carr_ccod  " & vbCrlf & _
			" where c.pers_nrut in ("&rut&")" & vbCrlf & _
			" group by c.pers_nnota_ens_media,b.pers_ncorr,f.carr_ccod,k.car_ing_ncorr,j.seie_min_ccod,c.pers_ncorr,pers_tape_paterno,  " & vbCrlf & _
			" pers_tape_materno,pers_tnombre,pers_nrut,pers_xdv,carr_tdesc,d.sede_ccod,ano_adjudicacion,monto_bene,tdet_tdesc,i.facu_tdesc,f.CARR_CCOD,d.jorn_ccod  "


'response.write("<pre>"&consulta&"</pre>")
'response.End()
 
fecha=now()
descripcion="bd_matricula_prime_año"
usu=negocio.obtenerUsuario
usal_ncorr=conexion.ConsultaUno("exec ObtenerSecuencia 'ufe_salidas_log'")
strInst="insert into ufe_salidas_log (usal_ncorr,usal_tdesc,audi_tusuario,audi_fmodificacion, usal_parametro) values (" & usal_ncorr & ", '" & descripcion & "' ," & usu & ",'" & fecha & "', '" & rut & "')"
conexion.ejecutaS (strInst)
tabla.consultar consulta 
'response.write(consulta)
'response.end()
'------------------------------------------------------------------------------------

encabezados="rut;dv;paterno;materno;nombres;ano_ingreso;semestre_ingreso;cod_sede;cod_carrera;cod_jornada;modalidad;version;promedio_psu;nem"
response.Write(encabezados)
Response.Write(vbCrLf)
while tabla.Siguiente

usdl_ncorr=conexion.ConsultaUno("exec ObtenerSecuencia 'ufe_salidas_detalle_log'")
	detalle=""&tabla.ObtenerValor("rut")&";"&tabla.ObtenerValor("dv")&";"&tabla.ObtenerValor("paterno")&";"&tabla.ObtenerValor("materno")&";"&tabla.ObtenerValor("nombres")&";" & _
	""&tabla.ObtenerValor("ano_ingreso")&";"&tabla.ObtenerValor("semestre_ingreso")&";"&tabla.ObtenerValor("cod_sede")&";"&tabla.ObtenerValor("cod_carrera")&";"&tabla.ObtenerValor("cod_jornada")&";" & _
	""&tabla.ObtenerValor("modalidad")&";"&tabla.ObtenerValor("version")&";"&tabla.ObtenerValor("promedio_psu")&";"&tabla.ObtenerValor("nem")&""
	response.Write(detalle)
	Response.Write(vbCrLf)
	strInst="insert into ufe_salidas_detalle_log (usdl_ncorr,usal_ncorr,usdl_detalle) values (" & usdl_ncorr & ", " &  usal_ncorr & ", '" & detalle & "')"
	conexion.ejecutaS (strInst)

wend
%>