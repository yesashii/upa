<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'	next
'response.End()

server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=filtro_maestro.xls"
Response.ContentType = "application/vnd.ms-excel"
'-------------------------------------CAMPOS--------------------------------------------------------------
q_estado_matricula=request.form("_busqueda[0][estado_matricula]")
q_tdet_ccod =Request.form("busqueda[0][tdet_ccod]")
q_sede_ccod= request.form("busqueda[0][sede_ccod")
q_esmoroso=request.form("_busqueda[0][esmoroso]")
q_tipo_alumno=request.form("_busqueda[0][tipo_alumno]")
q_email_upa=request.form("_busqueda[0][emailupa]")
q_ano_ingreso_carrera=request.form("_busqueda[0][ano_ingreso]")
q_facultada=request.form("_busqueda[0][facultad]") 
q_psu_matematica=request.form("_busqueda[0][psu_matematica]")
q_psu_lenguaje=request.form("_busqueda[0][psu_lenguaje]")
q_psu_promedio=request.form("_busqueda[0][psu_promedio]")
q_nem=request.form("_busqueda[0][nem]")
q_direccion=request.form("_busqueda[0][direccion]")
q_celular=request.form("_busqueda[0][celular]")
q_telefono=request.form("_busqueda[0][telefono]")
q_region=request.form("_busqueda[0][region]")
q_ciudad=request.form("_busqueda[0][ciudad]")
q_codeudor=request.form("_busqueda[0][codeudor]")
q_banco=request.form("_busqueda[0][banco]")
q_rut_banco=request.form("_busqueda[0][rut_banco]")
q_tipo_alumno_cae=request.form("_busqueda[0][tipo_alumno_cae]")
q_monto_beca_mineduc=request.form("_busqueda[0][monto_beca_mineduc]")
q_ano_adjudicacion_beca=request.form("_busqueda[0][ano_adjudicacion_beca]")
q_codigo_carrera_mineduc=request.form("_busqueda[0][codigo_carrera_mineduc]")
q_codigo_carrera_ingresa=request.form("_busqueda[0][codigo_carrera_ingresa]")
q_codigo_sede_mineduc=request.form("_busqueda[0][codigo_sede_mineduc]")
q_codigo_sede_ingresa=request.form("_busqueda[0][codigo_sede_ingresa]")
q_codigo_jornada=request.form("_busqueda[0][codigo_jornada]")
q_codigo_estado_renovante=request.form("_busqueda[0][codigo_estado_renovante]")
q_ano_licitacion=request.form("_busqueda[0][ano_licitacion]")
'------------------------------------FILTROS---------------------------------------------------------------

q_emat_ccod=request.form("busqueda[0][emat_ccod]")
q_peri_ccod= request.form("busqueda[0][peri_ccod]")
q_peri_ccod_desde= request.form("busqueda[0][peri_ccod_desde]")
q_peri_ccod_hasta= request.form("busqueda[0][peri_ccod_hasta]")
q_carr_ccod=request.form("busqueda[0][carr_ccod]") 
q_aran_nano_ingreso=request.form("busqueda[0][aran_nano_ingreso]") 
q_noescae=request.form("_busqueda[0][noescae]")
q_escae=request.form("_busqueda[0][escae]")
q_taca_ccod=request.form("busqueda[0][taca_ccod]")
q_nobeca_mineduc=request.form("_busqueda[0][nobeca_mineduc]")
q_beca_mineduc=request.form("_busqueda[0][beca_mineduc]")
q_tdet_ccod=request.form("busqueda[0][tdet_ccod]")
q_escae=request.form("_busqueda[0][escae]") 
q_noescae=request.form("_busqueda[0][noescae]") 
q_taca_ccod=request.form("busqueda[0][taca_ccod]") 
q_nobeca_mineduc=request.form("_busqueda[0][nobeca_mineduc]")
q_beca_mineduc=request.form("_busqueda[0][beca_mineduc]")
q_tdet_ccod=request.form("busqueda[0][tdet_ccod]")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion

tablas=""
filtros_tablas=""
campos=""
q_estado_matricula="1"
'----------------------------------------campos-----------------------------------


if q_peri_ccod_desde <>"" or q_peri_ccod_hasta <>"" then
fitro_periodo="and c.PERI_CCOD between "&q_peri_ccod_desde&" and "&q_peri_ccod_hasta&""
else
fitro_periodo="and c.PERI_CCOD="&q_peri_ccod&""
end if 


if q_estado_matricula="1" or q_emat_ccod<>""then
	'if tablas<>"" then
	'else
		
		if q_emat_ccod<>""then 
			filtros_tablas=filtros_tablas&" and b.emat_ccod="&q_emat_ccod&""
		end if
		campos=campos&",e.emat_tdesc"
	
end if
if q_esmoroso="1" then
campos=campos&",(select case protic.es_moroso(a.pers_ncorr,getDate()) when 'S' then 'SI' else 'NO' end)as esmoroso" 
end if


if q_tipo_alumno="1" then

campos=campos&",case when d.post_bnuevo='S' then 'Nuevo' else 'Antiguo' end as tipo_alumno"
end if

if q_email_upa="1" then
campos=campos&",(select top 1 lower(email_nuevo)  from cuentas_email_upa where pers_ncorr=a.pers_ncorr)as email_upa"
end if

if q_ano_ingreso_carrera="1" then
		campos=campos&",(select protic.ano_ingreso_carrera_egresa2(a.pers_ncorr,g.carr_ccod))as ano_ingreso_carrera"
end if


if q_facultada="1" then

		tablas=tablas&" ,areas_academicas ara ,facultades facu "

		filtros_tablas=filtros_tablas&" and g.area_ccod=ara.area_ccod and ara.facu_ccod=facu.facu_ccod"
		
		campos=campos&",facu_tdesc"
		
end if

if q_psu_matematica="1" then

	campos=campos&",c.POST_NPAA_MATEMATICAS"
	
end if
if q_psu_lenguaje="1" then

campos=campos&",c.POST_NPAA_VERBAL"

end if
if q_psu_promedio="1" then

campos=campos&",(isnull(c.POST_NPAA_VERBAL,0)+isnull(c.POST_NPAA_MATEMATICAS,0))/2 as promedio "

end if
if q_nem="1" then

campos=campos&",a.PERS_NNOTA_ENS_MEDIA"

end if

if q_direccion="1" then

campos=campos&",protic.obtener_direccion (a.pers_ncorr,1,'CNPB')as direccion"

end if

	
if q_celular="1" then

campos=campos&",a.pers_tcelular"

end if

if q_telefono="1" then
campos=campos&",a.pers_tfono"
end if

if q_region="1" then
campos=campos&",protic.obtener_direccion (a.pers_ncorr,1,'R')as region"
end if

if q_ciudad="1" then
campos=campos&",protic.obtener_direccion (a.pers_ncorr,1,'COM')as ciudad"
end if

if q_codeudor="1" then
		
		tablas=tablas&" ,codeudor_postulacion j"

		filtros_tablas=filtros_tablas&" and c.post_ncorr=j.post_ncorr"
		
		campos=campos&",(select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno from personas aaa where aaa.pers_ncorr=j.pers_ncorr)as codeudor"

end if

if q_banco="1" or  q_tipo_alumno_cae="1" or q_escae="1" or q_taca_ccod<>"" or q_rut_banco="1" then
	
		tablas=tablas&" ,ufe_alumnos_cae k"
		
		filtros_tablas=filtros_tablas&" and a.pers_nrut=k.rut and k.esca_ccod=1 and k.anos_ccod=(select anos_ccod from periodos_academicos where peri_ccod=d.peri_ccod)"
		
		if q_banco="1" then
			campos=campos&",(select baca_tdesc from ufe_bancos_cae l where k.rut_banco=l.baca_nrut)as baca_tdesc"
		end if
		
		if q_tipo_alumno_cae="1" then
			campos=campos&",o.taca_tdesc"
			tablas=tablas&" ,ufe_tipo_alumnos_cae o"
			filtros_tablas=filtros_tablas&" and k.taca_ccod=o.taca_ccod"
		end if
		
		if q_taca_ccod<>"" then
			filtros_tablas=filtros_tablas&" and k.taca_ccod="&q_taca_ccod&""
		end if
		
		if q_rut_banco="1" then
			campos=campos&",k.rut_banco"
		end if
		
		if q_codigo_estado_renovante="1" then
			campos=campos&",k.RENON_ESTADO_ACTUAL"
		end if
		
		if q_ano_licitacion="1" then
			campos=campos&",(select anos_ccod from ufe_alumnos_cae aaa where taca_ccod=1 and aaa.rut=a.pers_nrut)as ano_licitacion"
		end if

end if
	
if q_noescae="1" then

filtros_tablas=filtros_tablas&" and a.pers_nrut not in (select rut from ufe_alumnos_cae aaa where aaa.anos_ccod=(select anos_ccod from periodos_academicos where peri_ccod=d.peri_ccod))"

end if

if q_monto_beca_mineduc="1" or q_ano_adjudicacion_beca="1"  or q_beca_mineduc="1" or q_tdet_ccod<>"" then

		tablas=tablas&" ,alumno_credito p,tipos_detalle dd"
		campos=campos&",dd.tdet_tdesc"
		
		filtros_tablas=filtros_tablas&" and c.post_ncorr=p.post_ncorr and p.tdet_ccod in (910,1390,1446,1537,1538,1539,1912) and p.tdet_ccod=dd.tdet_ccod"
		
		if q_monto_beca_mineduc="1" then
		
		campos=campos&",p.monto_bene"
		end if
		
		if q_ano_adjudicacion_beca="1" then
		
		campos=campos&",p.ano_adjudicacion"
		end if
		
		if q_tdet_ccod<>"" then
		
		filtros_tablas=filtros_tablas&" and  p.tdet_ccod ="&q_tdet_ccod&""
		end if

end if

if q_nobeca_mineduc="1" then
filtros_tablas=filtros_tablas&" and c.post_ncorr not in (select aa.post_ncorr from alumno_credito aa, postulantes bb where aa.post_ncorr=bb.post_ncorr and bb.peri_ccod=d.peri_ccod)"
end if

if q_carr_ccod<>"" then

filtros_tablas=filtros_tablas&" and g.carr_ccod="&q_carr_ccod&""

end if


if q_aran_nano_ingreso <>"" then

filtros_tablas=filtros_tablas&" and (select protic.ano_ingreso_carrera_egresa2(a.pers_ncorr,g.carr_ccod))="&q_aran_nano_ingreso&""
end if

if q_codigo_carrera_mineduc="1" or  q_codigo_carrera_ingresa="1" then

tablas=tablas&",ufe_carreras_homologadas r"

filtros_tablas=filtros_tablas&" and f.carr_ccod=r.carr_ccod COLLATE Modern_Spanish_CI_AS"


	if q_codigo_carrera_mineduc="1" then
	campos=campos&",car_min_ncorr "
	end if
	
	if q_codigo_carrera_ingresa="1" then
	campos=campos&",car_ing_ncorr "
	end if

end if

if q_codigo_sede_mineduc="1" or  q_codigo_sede_ingresa="1" then

tablas=tablas&",ufe_sedes_ies a1"

filtros_tablas=filtros_tablas&" and h.sede_ccod= a1.sede_ccod"

	
	if q_codigo_carrera_mineduc="1" then
	campos=campos&",seie_min_ccod  "
	end if
	
	if q_codigo_carrera_ingresa="1" then
	campos=campos&",seie_ing_ccod  "
	end if

end if

if q_codigo_jornada="1" then 
campos=campos&",i.jorn_ccod"
end if

if q_ofam_nversion_car="1" then
campos=campos&",(select top 1 ofam_nversion_carr from ufe_oferta_academica_min a2 where g.carr_ccod= a2.carr_ccod)as ofam_nversion_car"
end if
if q_ofam_nmodalidad_car="1" then
campos=campos&",(select top 1 ofam_nmodalida_carr  from ufe_oferta_academica_min a2 where g.carr_ccod= a2.carr_ccod)as ofam_nmodalidad_car"
end if
	
if q_durancion_carrera_min="1" then

campos=campos&",(select distinct ofam_nduracion from ufe_oferta_academica_min a3 where f.carr_ccod=a3.carr_ccod and   h.sede_ccod= a3.sede_ccod and i.jorn_ccod=a3.jorn_ccod and anos_ccod=(select anos_ccod from periodos_academicos xx where xx.peri_ccod=d.peri_ccod))as duracion_carrera_min"


end if
if q_durancion_carrera_ing="1" then


campos=campos&",(select distinct ofai_nduracion from ufe_oferta_academica_ing a4 where f.carr_ccod=a4.carr_ccod and   h.sede_ccod= a4.sede_ccod and i.jorn_ccod=a4.jorn_ccod and anos_ccod=(select anos_ccod from periodos_academicos xx where xx.peri_ccod=d.peri_ccod))as duracion_carrera_ing"


end if

if q_nivel_estudio="1" then

   campos=campos&",case (select top 1 tr.nive_ccod from malla_curricular tr where tr.plan_ccod = b.plan_ccod " & vbCrlf & _  
            " and isnull(tr.mall_npermiso,0) = 0   " & vbCrlf & _
			" and isnull(protic.estado_ramo_alumno(b.pers_ncorr,tr.asig_ccod,f.carr_ccod,tr.plan_ccod,d.peri_ccod),'') = '' " & vbCrlf & _
			" order by tr.nive_ccod asc) when 1  then '1'  when 2  then '1'  when 3  then '2'  when 4  then '2'  when 5  then '3'  when 6  then '3'  when 7  then '4'  when 8  then '4'  when 9 then '5'  else 'SNR' end as nivel_estudio_anos"
			
			campos=campos&" ,(select top 1 tr.nive_ccod from malla_curricular tr where tr.plan_ccod = b.plan_ccod " & vbCrlf & _  
            " and isnull(tr.mall_npermiso,0) = 0   " & vbCrlf & _
			" and isnull(protic.estado_ramo_alumno(b.pers_ncorr,tr.asig_ccod,f.carr_ccod,tr.plan_ccod,d.peri_ccod),'') = '' " & vbCrlf & _
			" order by tr.nive_ccod asc) as nivel_estudio_semestres"
end if

q_tipo_titulo_ing="1"
if q_tipo_titulo_ing="1" then
campos=campos&",(select distinct ax.ttie_tdesc from UFE_OFERTA_ACADEMICA_ING az ,ufe_tipo_titulo_ies ax where az.ttie_ccod=ax.ttie_ccod and f.carr_ccod=az.carr_ccod and   h.sede_ccod= az.sede_ccod and i.jorn_ccod=az.jorn_ccod and anos_ccod=(select anos_ccod from periodos_academicos xx where xx.peri_ccod=d.peri_ccod))ttie_tdesc"
end if
'---------------------------------------------------------------------------------------------------------------------------


'else 
sql_descuentos="select top 100  pers_nrut,pers_xdv,pers_tnombre,pers_tape_paterno,pers_tape_materno,carr_tdesc,sede_tdesc,jorn_tdesc"&campos&""& vbCrLf &_
				"from personas a,"& vbCrLf &_
				"alumnos b,"& vbCrLf &_
				"postulantes c,"& vbCrLf &_
				"ofertas_academicas d,"& vbCrLf &_
				"especialidades f,"& vbCrLf &_
				"carreras g,"& vbCrLf &_
				"sedes h,"& vbCrLf &_
				"jornadas i"& vbCrLf &_
				",estados_matriculas e"& vbCrLf &_
				""&tablas&""& vbCrLf &_
				"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_
				"and b.POST_NCORR=c.POST_NCORR"& vbCrLf &_
				"and c.OFER_NCORR=d.OFER_NCORR"& vbCrLf &_
				"and d.espe_ccod=f.espe_ccod"& vbCrLf &_
				"and f.carr_ccod=g.carr_ccod" & vbCrLf &_
				"and d.sede_ccod=h.sede_ccod"& vbCrLf &_
				"and d.jorn_ccod=i.jorn_ccod"& vbCrLf &_
				""&fitro_periodo&""& vbCrLf &_
				"and b.emat_ccod <>9"& vbCrLf &_ 
				"and b.emat_ccod=e.emat_ccod"& vbCrLf &_
				""&filtros_tablas&""& vbCrLf &_
				"order by pers_tape_paterno,pers_tape_materno,pers_tnombre"
fecha=now()




	
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&q_tdet_ccod&"</pre>")
'response.Write("<pre>"&q_sede_ccod&"</pre>")
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.End()
set f_valor_documentos  = new cformulario
f_valor_documentos.carga_parametros "tabla_vacia.xml", "tabla" 
f_valor_documentos.inicializar conexion							
f_valor_documentos.consultar sql_descuentos

'-------------------------------------------------------------------------------



%>
 <html>
<head>
<title><%=pagina.Titulo%></title>  

</head>
<body bgcolor="#ffffff" leftmargin="43" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="100%">
	<tr align="center">
	 <td width="100%"><div align="center"><strong>Reporte hecho el <%=fecha%></strong></div></td>
  </tr>
</table>
<table width="100%" border="1">
  <tr>
  <td width="11%"><div align="center"><strong>Rut</strong></div></td>
	<td width="11%"><div align="center"><strong>DV</strong></div></td>
    <td width="22%"><div align="up"><strong>Nombre</strong></div></td>
	 <td width="22%"><div align="up"><strong>Apellido Paterno</strong></div></td>
	  <td width="22%"><div align="up"><strong>Apellido Materno</strong></div></td>
    
	<%if q_estado_matricula="1" or q_emat_ccod<>""then%><td width="11%"><div align="center"><strong>Estado Matricula</strong></div></td><%end if%>
	<%if q_esmoroso="1" then%><td width="11%"><div align="center"><strong>Es Moroso</strong></div></td><%end if%>
	<%if q_tipo_alumno="1" then%><td width="11%"><div align="center"><strong>Tipo Alumno</strong></div></td><%end if%>
	<%if q_email_upa="1" then%><td width="11%"><div align="center"><strong>Email UPA</strong></div></td><%end if%>
	<td width="38%"><div align="center"><strong>Carrera</strong></div></td>
	<%if q_codigo_carrera_mineduc="1" then%><td width="11%"><div align="center"><strong>Codigo Carrera Mineduc</strong></div></td><%end if%>
	<%if q_codigo_carrera_ingresa="1" then%><td width="11%"><div align="center"><strong>Codigo Carrera Ingresa</strong></div></td><%end if%>
	<%if q_ofam_nversion_car="1" then%><td width="11%"><div align="center"><strong>Version Carrera Mineduc</strong></div></td><%end if%>
	<%if q_ofam_nmodalidad_car="1" then%><td width="11%"><div align="center"><strong>Modalidad Carrera Mineduc</strong></div></td><%end if%>
	
    <td width="29%"><div align="center"><strong>Sede</strong></div></td>
	<%if q_codigo_sede_mineduc="1" then%><td width="11%"><div align="center"><strong>Codigo Sede Mineduc</strong></div></td><%end if%>
	<%if q_codigo_sede_ingresa="1" then%><td width="11%"><div align="center"><strong>Codigo Sede Ingresa</strong></div></td><%end if%>
	<td width="29%"><div align="center"><strong>Jornada</strong></div></td>
	<%if q_codigo_jornada="1" then%><td width="29%"><div align="center"><strong>Codigo Jornada</strong></div></td><%end if%>
	<%if q_durancion_carrera_min="1" then%><td width="29%"><div align="center"><strong>Duracion Carreras  Semestres</strong></div></td><%end if%>
	<%if q_durancion_carrera_ing="1" then%><td width="29%"><div align="center"><strong>Duracion Carreras Años</strong></div></td><%end if%>
	<%if q_facultada="1" then%><td width="29%"><div align="center"><strong>Facultad</strong></div></td><%end if%>
	<%if q_tipo_titulo_ing="1" then%><td width="29%"><div align="center"><strong>Tipo Titulo (Ingresa)</strong></div></td><%end if%>
	<%if q_nivel_estudio="1" then%><td width="29%"><div align="center"><strong>Nivel Estudios A&ntilde;o</strong></div></td><%end if%>
	<%if q_nivel_estudio="1" then%><td width="29%"><div align="center"><strong>Nivel Estudios Semestres</strong></div></td><%end if%>
	<%if q_ano_ingreso_carrera="1" then %><td width="29%"><div align="center"><strong>Año Ingreso Carrera</strong></div></td><%end if%>
	<%if q_psu_matematica="1" then%><td width="29%"><div align="center"><strong>PSU Matematica</strong></div></td><%end if%>
	<%if q_psu_lenguaje="1" then%><td width="29%"><div align="center"><strong>PSU Lenguaje</strong></div></td><%end if%>
	<%if q_psu_promedio="1" then%><td width="29%"><div align="center"><strong>PSU Promedio</strong></div></td><%end if%>
	<%if q_nem="1" then%><td width="11%"><div align="center"><strong>NEM</strong></div></td><%end if%>
	<%if q_direccion="1" then%><td width="11%"><div align="center"><strong>Direccion</strong></div></td><%end if%>
	<%if q_celular="1" then%><td width="11%"><div align="center"><strong>Celular</strong></div></td><%end if%>
	<%if q_telefono="1" then%><td width="11%"><div align="center"><strong>Telefono</strong></div></td><%end if%>
	<%if q_region="1" then%><td width="11%"><div align="center"><strong>Region</strong></div></td><%end if%>
	<%if q_ciudad="1" then%><td width="11%"><div align="center"><strong>Ciudad</strong></div></td><%end if%>
	<%if q_codeudor="1" then%><td width="11%"><div align="center"><strong>Codedudor</strong></div></td><%end if%>
	<%if q_codigo_estado_renovante="1" then%><td width="11%"><div align="center"><strong>Codigo Estado Renovante</strong></div></td><%end if%>
	<%if q_ano_licitacion="1" then%><td width="11%"><div align="center"><strong>A&ntilde;o
	      Licitacion CAE </strong></div></td><%end if%>
	<%if q_banco="1" then%><td width="11%"><div align="center"><strong>Banco</strong></div></td><%end if%>
	<%if q_rut_banco="1" then%><td width="11%"><div align="center"><strong>Rut Banco</strong></div></td><%end if%>
	<%if q_tipo_alumno_cae="1" then%><td width="11%"><div align="center"><strong>Tipo Alumno Cae</strong></div></td><%end if%>
	<%if q_monto_beca_mineduc="1" or q_ano_adjudicacion_beca="1" or q_beca_mineduc="1" or q_tdet_ccod<>"" then%><td width="11%"><div align="center"><strong>Beca</strong></div></td><%end if%>
	<%if q_monto_beca_mineduc="1" then%><td width="11%"><div align="center"><strong>Monto Beca</strong></div></td><%end if%>
	<%if q_ano_adjudicacion_beca="1" then%><td width="11%"><div align="center"><strong>Año
	      Adjudicación Beca Mineduc </strong></div></td><%end if%>
	
  </tr>
  <%  while f_valor_documentos.Siguiente %>
  <tr>
   <td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_nrut")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_xdv")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_tnombre")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_tape_paterno")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_tape_materno")%></div></td>
   
	<%if q_estado_matricula="1" or q_emat_ccod<>""then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("emat_tdesc")%></div></td><%end if%>
	<%if q_esmoroso="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("esmoroso")%></div></td><%end if%>
	<%if q_tipo_alumno="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("tipo_alumno")%></div></td><%end if%>
	<%if q_email_upa="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("email_upa")%></div></td><%end if%>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("carr_tdesc")%></div></td>
	<%if q_codigo_carrera_mineduc="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("car_min_ncorr")%></div></td><%end if%>
	<%if q_codigo_carrera_ingresa="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("car_ing_ncorr")%></div></td><%end if%>
	<%if q_ofam_nversion_car="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("ofam_nversion_car")%></div></td><%end if%>
	<%if q_ofam_nmodalidad_car="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("ofam_nmodalidad_car")%></div></td><%end if%>
	
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("sede_tdesc")%></div></td>
	<%if q_codigo_sede_mineduc="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("seie_min_ccod")%></div></td><%end if%>
	<%if q_codigo_sede_ingresa="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("seie_ing_ccod")%></div></td><%end if%>
	 <td><div align="left"><%=f_valor_documentos.ObtenerValor("jorn_tdesc")%></div></td>
	 <%if q_codigo_jornada="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("jorn_ccod")%></div></td><%end if%>
	  <%if q_durancion_carrera_min="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("duracion_carrera_min")%></div></td><%end if%>
	   <%if q_durancion_carrera_ing="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("duracion_carrera_ing")%></div></td><%end if%>
	 <%if q_facultada="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("facu_tdesc")%></div></td><%end if%>
	 <%if q_tipo_titulo_ing="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("ttie_tdesc")%></div></td><%end if%>
	 <%if q_nivel_estudio="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("nivel_estudio_anos")%></div></td><%end if%>
	 <%if q_nivel_estudio="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("nivel_estudio_semestres")%></div></td><%end if%>
	<%if q_ano_ingreso_carrera="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("ano_ingreso_carrera")%></div></td><%end if%>
	<%if q_psu_matematica="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("POST_NPAA_MATEMATICAS")%></div></td><%end if%>
	<%if q_psu_lenguaje="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("POST_NPAA_VERBAL")%></div></td><%end if%>
	<%if q_psu_promedio="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("promedio")%></div></td><%end if%>
	<%if q_nem then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("PERS_NNOTA_ENS_MEDIA")%></div></td><%end if%>
	<%if q_direccion="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("direccion")%></div></td><%end if%>
	<%if q_celular="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_tcelular")%></div></td><%end if%>
	<%if q_telefono="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_tfono")%></div></td><%end if%>
	<%if q_region="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("region")%></div></td><%end if%>
	<%if q_ciudad="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("ciudad")%></div></td><%end if%>
	<%if q_codeudor="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("codeudor")%></div></td><%end if%>
	<%if q_codigo_estado_renovante="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("RENON_ESTADO_ACTUAL")%></div></td><%end if%>
	<%if q_ano_licitacion="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("ano_licitacion")%></div></td><%end if%>
	<%if q_banco="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("baca_tdesc")%></div></td><%end if%>
	<%if q_rut_banco="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("rut_banco")%></div></td><%end if%>
	<%if q_tipo_alumno_cae="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("taca_tdesc")%></div></td><%end if%>
	<%if q_monto_beca_mineduc="1" or q_ano_adjudicacion_beca="1" or q_beca_mineduc="1" or q_tdet_ccod<>"" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("tdet_tdesc")%></div></td><%end if%>
	<%if q_monto_beca_mineduc="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("monto_bene")%></div></td><%end if%>
	<%if q_ano_adjudicacion_beca="1" then%><td><div align="left"><%=f_valor_documentos.ObtenerValor("ano_adjudicacion")%></div></td><%end if%>
  </tr>
  <%  wend %>
</table>
</html>