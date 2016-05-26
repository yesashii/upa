<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- '#include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.Form()
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=listado_alumnos_matriculados.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 150000
'set pagina = new CPagina
'pagina.Titulo = "Listado de Alumnos"

set conexion = new CConexion
conexion.Inicializar "upacifico"
carrera =request.Form("busqueda[0][carr_ccod]")
periodo =request.Form("busqueda[0][peri_ccod]")
agrega_carga =request.Form("agrega_carga")
agrega_morosidad =request.Form("agrega_morosidad")
agrega_documentos =request.Form("agrega_documentos")
aran_nano_ingreso = request.Form("busqueda[0][aran_nano_ingreso]")
post_nano_paa = request.Form("busqueda[0][post_nano_paa]")
emat_tdesc = request.Form("busqueda[0][emat_tdesc]")
fecha_inicio = request.Form("inicio")
min_puntaje = request.Form("min_puntaje")
max_puntaje = request.Form("max_puntaje")
ingreso_especial = request.Form("ingreso_especial")
usuario = request.Form("usuario")
peri = request.Form("peri")
'response.Write("ingreso_especial "&ingreso_especial)

if not esVacio(carrera) then
    
	filtro= " and cast(f.carr_ccod as varchar)='"&carrera&"'"
else
	filtro=" "	
end if

'set negocio = new CNegocio
'negocio.Inicializa conexion

if not esvacio(periodo) then
	filtro_periodo=" and cast(c.peri_ccod as varchar)='"&periodo&"'"
	filtro_anio= " join periodos_Academicos pea on c.peri_ccod = pea.peri_ccod"
else
    'peri= negocio.obtenerPeriodoAcademico("POSTULACION")
	anos_ccod=conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&peri&"'")
	'anos_ccod="2006"
    filtro_anio= " join periodos_Academicos pea on c.peri_ccod = pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&anos_ccod&"'"	
end if
'peri_ccod = negocio.ObtenerPeriodoAcademico("Postulacion")

'usuario = negocio.obtenerUsuario
pers_ncorr_administrativo = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")
autoriza_puntaje = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end  from sis_roles_usuarios where cast(pers_ncorr as varchar)='"&pers_ncorr_administrativo&"' and srol_ncorr in (2,42)")
if usuario = "8402799" or usuario = "15964262" then
	autoriza_puntaje = "S"
end if
'-----------------------------------------------------------------------------------------------
set f_listado = new CFormulario
f_listado.Carga_Parametros "consulta.xml", "consulta" 'carga el xml
f_listado.Inicializar conexion 'inicializo conexion

consulta =  " select distinct cast(a.pers_nrut as varchar)+'-'+ a.pers_xdv as rut,isnull(a.pers_temail,'No ingresado') as email, "& vbCrLf &_
		    "   a.pers_tape_paterno  as AP_Paterno, a.pers_tape_materno  as AP_Materno, a.pers_tnombre as nombre,protic.trunc(a.pers_fnacimiento) as fecha_nacimiento, "& vbCrLf &_
			"   case a.sexo_ccod when 1 then 'Masculino' when 2  then 'Femenino' else 'Sin Seleccionar' end as sexo,datediff(year,a.pers_fnacimiento,getDate()) as edad, "& vbCrLf &_
			"   (select top 1 case ta1.tpad_ccod when 1 then 'P.A.A' when 2 then 'P.S.U' else '--' end "& vbCrLf &_
 			"   from postulantes ta1 (nolock) "& vbCrLf &_
		    "   where ta1.pers_ncorr=a.pers_ncorr and isnull(ta1.post_npaa_matematicas,0) > 0 "& vbCrLf &_
			"   and isnull(ta1.post_npaa_verbal,0) > 0 "& vbCrLf &_
			"   order by peri_ccod desc) as tipo_prueba, "& vbCrLf &_
			"   (select top 1 cast(ta1.post_npaa_verbal as varchar)  "& vbCrLf &_
			"    from postulantes ta1 (nolock)  "& vbCrLf &_
			"    where ta1.pers_ncorr=a.pers_ncorr and isnull(ta1.post_npaa_verbal,0) > 0   "& vbCrLf &_
			"    and isnull(ta1.post_npaa_matematicas,0) > 0  "& vbCrLf &_
			"    order by peri_ccod desc) as puntaje_verbal, "& vbCrLf &_
			"   (select top 1 cast(ta1.post_npaa_matematicas as varchar)  "& vbCrLf &_
			"    from postulantes ta1 (nolock)  "& vbCrLf &_
			"    where ta1.pers_ncorr=a.pers_ncorr and isnull(ta1.post_npaa_matematicas,0) > 0   "& vbCrLf &_
			"    and isnull(ta1.post_npaa_verbal,0) > 0   "& vbCrLf &_
			"    order by peri_ccod desc) as puntaje_matematicas, "& vbCrLf &_
			"   isnull((select top 1 cast((isnull(ta1.post_npaa_verbal,0) + isnull(ta1.post_npaa_matematicas,0)) / 2 as decimal(6,3)) "& vbCrLf &_
			"           from postulantes ta1 (nolock) "& vbCrLf &_
			"           where ta1.pers_ncorr=a.pers_ncorr and isnull(ta1.post_npaa_matematicas,0) > 0  "& vbCrLf &_
			"           and isnull(ta1.post_npaa_verbal,0) > 0 "& vbCrLf &_
			"           order by peri_ccod desc),0) as promedio_prueba, "& vbCrLf &_
			"   (select top 1 ta1.POST_NANO_PAA  "& vbCrLf &_
			"   from postulantes ta1 (nolock) "& vbCrLf &_
			"   where ta1.pers_ncorr=a.pers_ncorr and isnull(ta1.post_npaa_matematicas,0) > 0   "& vbCrLf &_
			"   and isnull(ta1.post_npaa_verbal,0) > 0  "& vbCrLf &_
			"   order by peri_ccod desc) as ano_paa, "& vbCrLf &_
			"   upper(protic.obtener_direccion_letra(a.pers_ncorr,1,'CNPB')) as dire_particular, protic.obtener_direccion_letra(a.pers_ncorr,1,'CAS') as casilla_particular, "
			
if agrega_carga <> "" then 			
			consulta = consulta & "	(select case count(*) when 0 then 'No' else 'Sí' end from cargas_academicas carg (nolock) where carg.matr_ncorr=d.matr_ncorr) as con_carga, "& vbCrLf &_
			"   (select count(*) from cargas_academicas carg (nolock) where carg.matr_ncorr=d.matr_ncorr) as cant_asignaturas,"
end if			
			
if agrega_morosidad <> "" then 			
           consulta = consulta  & "   case protic.es_moroso(a.pers_ncorr,getdate()) when 'N' then 'No' else 'Sí' end as es_moroso,protic.es_moroso_monto(a.pers_ncorr,getdate())as monto_morosidad,"
end if			
			
			
consulta = consulta & "   isnull(cast(pos.post_nano_paa as varchar),'--') as ano_rindio_prueba,isnull(pos.post_tinstitucion_anterior,'--') as institucion_anterior, "& vbCrLf &_
			"   pai.pais_tdesc as pais,e.carr_ccod as cod_carrera,f.carr_tdesc as Carrera,e.espe_tdesc as especialidad,pl.plan_tdesc as plan_est,case c.post_bnuevo when 'N' then 'ANTIGUO' else 'NUEVO' end as tipo,case talu_ccod when 1 then '' when 2 then 'ALUMNO UPA DE INTERCAMBIO' when 3 then 'ALUMNO EXTRANJERO DE INTERCAMBIO' end  as tipo_intercambio, "& vbCrLf &_
			"   g.jorn_tdesc as jornada ,h.sede_tdesc as sede,ARA.ARAN_MMATRICULA,ARA.ARAN_MCOLEGIATURA,protic.ano_ingreso_carrera (a.pers_ncorr,e.carr_ccod) as ano_ingreso,isnull(cast(protic.PROMEDIO_MEDIA(a.pers_ncorr) as varchar),'') as promedio_media, "& vbCrLf &_
			"   i.dire_tfono as telefono_particular,j.ciud_tdesc as comuna_particular,j.ciud_tcomuna as ciudad_particular,reg.regi_tdesc as region_particular, "& vbCrLf &_
			"   upper(protic.obtener_direccion_letra(a.pers_ncorr,2,'CNPB'))  as dire_academica, protic.obtener_direccion_letra(a.pers_ncorr,2,'CAS')  as casilla_academica, "& vbCrLf &_
			"   dire2.dire_tfono as telefono_academica,ciud2.ciud_tdesc as comuna_academica,ciud2.ciud_tcomuna as ciudad_academica, "& vbCrLf &_
			"   isnull(k.cole_tdesc,a.pers_tcole_egreso) as nombre_colegio, isnull(l.ciud_tdesc,'--') as comuna_colegio, isnull(l.ciud_tcomuna,'--') as ciudad_colegio, isnull(m.tcol_tdesc,'--') as tipo_colegio, a.pers_nano_egr_media as ano_egreso, "& vbCrLf &_
			"   isnull(case tip_ens.tens_ccod when 4 then a.pers_ttipo_ensenanza else tip_ens.tens_tdesc end,'--') as tipo_ensenanza, "& vbCrLf &_
			"   (select emat_tdesc from estados_matriculas emat "& vbCrLf &_
    		"    where emat.emat_ccod in (select top 1 emat_ccod from alumnos a1, ofertas_academicas o1 where a1.pers_ncorr=d.pers_ncorr and a1.ofer_ncorr=o1.ofer_ncorr and o1.espe_ccod = c.espe_ccod and a1.emat_ccod <> 9 order by o1.peri_ccod desc, convert(datetime,a1.audi_fmodificacion) desc)) "& vbCrLf &_
            "    as estado_academico,"& vbCrLf &_
			"    (select top 1 lower(email_nuevo) from cuentas_email_upa tt where tt.pers_ncorr=d.pers_ncorr and email_nuevo like '%alumnos.upacifico.cl') as email_upa,"& vbCrLf &_
			"    (select facu_tdesc from areas_academicas ttt, facultades rrr where ttt.area_ccod=f.area_ccod and ttt.facu_ccod=rrr.facu_ccod) as facultad ,"& vbCrLf &_
			"   protic.trunc(cont.cont_fcontrato) as fecha_matricula,protic.trunc(d.audi_fmodificacion) as fecha_modificacion,"& vbCrLf &_
			"   (select top 1 isnull(oema_tobservacion,'--') "& vbCrLf &_
		    "           from alumnos mm (nolock),observaciones_estado_matricula om,ofertas_academicas ccc,periodos_academicos ddd, especialidades eee "& vbCrLf &_ 
		    "           where mm.matr_ncorr = om.matr_ncorr and mm.ofer_ncorr=ccc.ofer_ncorr "& vbCrLf &_
			"           and ccc.peri_ccod=ddd.peri_ccod and mm.emat_ccod <> 1 and mm.pers_ncorr = d.pers_ncorr "& vbCrLf &_
            "           and ccc.espe_ccod=eee.espe_ccod and eee.carr_ccod=f.carr_ccod  "& vbCrLf &_
            "           and ddd.anos_ccod >= pea.anos_ccod and isnull(oema_tobservacion,'')<>'' "& vbCrLf &_
            "           order by ddd.peri_ccod desc) as observacion, "& vbCrLf &_
		    " --(select top 1 isnull(om2.eoma_tdesc,'--') "& vbCrLf &_
            "--		from alumnos mm,observaciones_estado_matricula om,ofertas_academicas ccc,periodos_academicos ddd,estado_observaciones_matriculas om2, especialidades eee "& vbCrLf &_
            "--		where mm.matr_ncorr = om.matr_ncorr and mm.ofer_ncorr=ccc.ofer_ncorr "& vbCrLf &_
            "--		and ccc.peri_ccod=ddd.peri_ccod and mm.emat_ccod <> 1 and mm.pers_ncorr = d.pers_ncorr "& vbCrLf &_
			"--       and ccc.espe_ccod=eee.espe_ccod and eee.carr_ccod=f.carr_ccod "& vbCrLf &_
			"--		and om.eoma_ccod = om2.eoma_ccod and ddd.anos_ccod >= pea.anos_ccod and isnull(oema_tobservacion,'')<>''"& vbCrLf &_
			"--		order by ddd.peri_ccod desc) as condicion,"& vbCrLf &_
			"  (select top 1 (select isnull(om2.eoma_tdesc,'--') from estado_observaciones_matriculas om2 where om2.eoma_ccod = isnull(om.eoma_ccod,0)) "& vbCrLf &_
		    "           from alumnos mm (nolock),observaciones_estado_matricula om,ofertas_academicas ccc,periodos_academicos ddd, especialidades eee "& vbCrLf &_ 
		    "           where mm.matr_ncorr = om.matr_ncorr and mm.ofer_ncorr=ccc.ofer_ncorr "& vbCrLf &_
			"           and ccc.peri_ccod=ddd.peri_ccod and mm.emat_ccod <> 1 and mm.pers_ncorr = d.pers_ncorr "& vbCrLf &_
            "           and ccc.espe_ccod=eee.espe_ccod and eee.carr_ccod=f.carr_ccod  "& vbCrLf &_
            "           and ddd.anos_ccod >= pea.anos_ccod and isnull(oema_tobservacion,'')<>'' "& vbCrLf &_
            "           order by ddd.peri_ccod desc) as condicion, "& vbCrLf &_
			"	cast(pers2.pers_nrut as varchar)+'-'+pers2.pers_xdv as rut_codeudor, pers2.pers_tnombre + ' ' +pers2.pers_tape_paterno + ' ' + pers2.pers_tape_materno  as codeudor, protic.trunc(pers2.pers_fnacimiento) as fecha_nacimiento_codeudor, "& vbCrLf &_
			" 	upper(protic.obtener_direccion_letra(pers2.pers_ncorr,1,'CNPB'))  as direccion_codeudor,protic.obtener_direccion_letra(pers2.pers_ncorr,1,'C-C')  as ciudad_codeudor, max(isnull(pers2.pers_temail,'')) as email_codeudor, a.pers_tcelular, "& vbCrLf &_
			"  (select top 1 bb.tfma_tdesc from ALUMNOS_FORMA_MATRICULA aa, TIPOS_FORMA_MATRICULA bb where aa.pers_ncorr=a.pers_ncorr and aa.tfma_ccod = bb.tfma_ccod order by aa.audi_fmodificacion desc) as tipo_mat "
						
			if agrega_documentos <> "" then
			consulta = consulta & "	,(select case count(*) when 0 then 'No' else 'Sí' end from documentos_postulantes aa where aa.pers_ncorr=a.pers_ncorr and aa.doma_ccod = 1 and isnull(entregado,'N')='S') as Ced_identidad, "& vbCrLf &_
			 "	(select case count(*) when 0 then 'No' else 'Sí' end from documentos_postulantes aa (nolock) where aa.pers_ncorr=a.pers_ncorr and aa.doma_ccod = 2 and isnull(entregado,'N')='S') as Lic_Enseñanza_Media,"& vbCrLf &_
			 "	(select case count(*) when 0 then 'No' else 'Sí' end from documentos_postulantes aa (nolock) where aa.pers_ncorr=a.pers_ncorr and aa.doma_ccod = 3 and isnull(entregado,'N')='S') as Conc_de_notas_Enseñanza_Media, "& vbCrLf &_
			 "	(select case count(*) when 0 then 'No' else 'Sí' end from documentos_postulantes aa (nolock) where aa.pers_ncorr=a.pers_ncorr and aa.doma_ccod = 4 and isnull(entregado,'N')='S') as Puntaje_PSU, "& vbCrLf &_
			 "	(select case count(*) when 0 then 'No' else 'Sí' end from documentos_postulantes aa (nolock) where aa.pers_ncorr=a.pers_ncorr and aa.doma_ccod = 6 and isnull(entregado,'N')='S') as Fotografias,	"& vbCrLf &_
			 "	(select case count(*) when 0 then 'No' else 'Sí' end from documentos_postulantes aa (nolock) where aa.pers_ncorr=a.pers_ncorr and aa.doma_ccod = 7 and isnull(entregado,'N')='S') as Certificado_Residencia,"& vbCrLf &_
			 "	(select case count(*) when 0 then 'No' else 'Sí' end from documentos_postulantes aa (nolock) where aa.pers_ncorr=a.pers_ncorr and aa.doma_ccod = 8 and isnull(entregado,'N')='S') as Seguro_Salud,"& vbCrLf &_
			 "	(select case count(*) when 0 then 'No' else 'Sí' end from documentos_postulantes aa (nolock) where aa.pers_ncorr=a.pers_ncorr and aa.doma_ccod = 9 and isnull(entregado,'N')='S') as doc_mat_9,"& vbCrLf &_
			 "	(select case count(*) when 0 then 'No' else 'Sí' end from documentos_postulantes aa (nolock) where aa.pers_ncorr=a.pers_ncorr and aa.doma_ccod = 10 and isnull(entregado,'N')='S') as doc_mat_10,"& vbCrLf &_
			 "	(select case count(*) when 0 then 'No' else 'Sí' end from documentos_postulantes aa (nolock) where aa.pers_ncorr=a.pers_ncorr and aa.doma_ccod = 11 and isnull(entregado,'N')='S') as doc_mat_11,"& vbCrLf &_
			 "	(select case count(*) when 0 then 'No' else 'Sí' end from documentos_postulantes aa (nolock) where aa.pers_ncorr=a.pers_ncorr and aa.doma_ccod = 12 and isnull(entregado,'N')='S') as doc_mat_12,"& vbCrLf &_
			 "	(select case count(*) when 0 then 'No' else 'Sí' end from documentos_postulantes aa (nolock) where aa.pers_ncorr=a.pers_ncorr and aa.doma_ccod = 13 and isnull(entregado,'N')='S') as doc_mat_13,"& vbCrLf &_
			 "	(select case count(*) when 0 then 'No' else 'Sí' end from documentos_postulantes aa (nolock) where aa.pers_ncorr=a.pers_ncorr and aa.doma_ccod = 14 and isnull(entregado,'N')='S') as doc_mat_14,"& vbCrLf &_
			 "	(select case count(*) when 0 then 'No' else 'Sí' end from documentos_postulantes aa (nolock) where aa.pers_ncorr=a.pers_ncorr and aa.doma_ccod = 15 and isnull(entregado,'N')='S') as doc_mat_15,"& vbCrLf &_
			 "	(select case count(*) when 0 then 'No' else 'Sí' end from documentos_postulantes aa (nolock) where aa.pers_ncorr=a.pers_ncorr and aa.doma_ccod = 16 and isnull(entregado,'N')='S') as doc_mat_16,"& vbCrLf &_
			 "	(select case count(*) when 0 then 'No' else 'Sí' end from documentos_postulantes aa (nolock) where aa.pers_ncorr=a.pers_ncorr and aa.doma_ccod = 17 and isnull(entregado,'N')='S') as doc_mat_17,"& vbCrLf &_
			 "	(select case count(*) when 0 then 'No' else 'Sí' end from documentos_postulantes aa (nolock) where aa.pers_ncorr=a.pers_ncorr and aa.doma_ccod = 18 and isnull(entregado,'N')='S') as doc_mat_18,"& vbCrLf &_
			 "	(select case count(*) when 0 then 'No' else 'Sí' end from documentos_postulantes aa (nolock) where aa.pers_ncorr=a.pers_ncorr and aa.doma_ccod = 19 and isnull(entregado,'N')='S') as doc_mat_19,"& vbCrLf &_
			 "	(select case count(*) when 0 then 'No' else 'Sí' end from documentos_postulantes aa (nolock) where aa.pers_ncorr=a.pers_ncorr and aa.doma_ccod = 20 and isnull(entregado,'N')='S') as doc_mat_20,"& vbCrLf &_
			 "	(select case count(*) when 0 then 'No' else 'Sí' end from documentos_postulantes aa (nolock) where aa.pers_ncorr=a.pers_ncorr and aa.doma_ccod = 21 and isnull(entregado,'N')='S') as doc_mat_21,"& vbCrLf &_
			 "	(select case count(*) when 0 then 'No' else 'Sí' end from documentos_postulantes aa (nolock) where aa.pers_ncorr=a.pers_ncorr and aa.doma_ccod = 22 and isnull(entregado,'N')='S') as doc_mat_22,"& vbCrLf &_
			 "	(select case count(*) when 0 then 'No' else 'Sí' end from documentos_postulantes aa (nolock) where aa.pers_ncorr=a.pers_ncorr and aa.doma_ccod = 23 and isnull(entregado,'N')='S') as doc_mat_23 "
			end if
			
			consulta = consulta & " from personas_postulante a  (nolock) join alumnos d  (nolock) "& vbCrLf &_
			"        on a.pers_ncorr = d.pers_ncorr  "& vbCrLf &_
			"    join ofertas_academicas c "& vbCrLf &_
			"        on c.ofer_ncorr = d.ofer_ncorr   "& vbCrLf &_
			"    join ARANCELES ARA "& vbCrLf &_
			"        on ARA.ARAN_NCORR = C.ARAN_NCORR   "& vbCrLf &_
			"    "&filtro_anio& vbCrLf &_
			"    left outer join tipos_ensenanza_media tip_ens "& vbCrLf &_
			"        on a.tens_ccod = tip_ens.tens_ccod    "& vbCrLf &_
			"    join postulantes pos  (nolock) "& vbCrLf &_
			"        on pos.post_ncorr = d.post_ncorr "& vbCrLf &_
			"    join paises pai "& vbCrLf &_
			"        on pai.pais_ccod = isnull(a.pais_ccod,0) "& vbCrLf &_
			"    left outer join colegios k "& vbCrLf &_
			"        on a.cole_ccod = k.cole_ccod   "& vbCrLf &_
			"    join especialidades e "& vbCrLf &_
			"        on c.espe_ccod  = e.espe_ccod "& vbCrLf &_
			"    left outer join planes_estudio pl "& vbCrLf &_
			"        on d.plan_ccod = pl.plan_ccod "& vbCrLf &_
			"    join carreras f "& vbCrLf &_
			"        on e.carr_ccod=f.carr_ccod "& filtro & vbCrLf &_
			"    join jornadas g "& vbCrLf &_
			"        on c.jorn_ccod=g.jorn_ccod "& vbCrLf &_
			"    join sedes h "& vbCrLf &_
			"        on c.sede_ccod=h.sede_ccod "& vbCrLf &_
			"    left outer join direcciones i "& vbCrLf &_
			"        on a.pers_ncorr = i.pers_ncorr  "& vbCrLf &_
			"    left outer join direcciones dire2 "& vbCrLf &_
			"        on a.pers_ncorr = dire2.pers_ncorr    and 2 = dire2.tdir_ccod "& vbCrLf &_
			"    left outer join ciudades j "& vbCrLf &_
			"        on i.ciud_ccod = j.ciud_ccod "& vbCrLf &_
			"    left outer join regiones reg "& vbCrLf &_
			"        on j.regi_ccod = reg.regi_ccod  "& vbCrLf &_
			"    left outer join ciudades ciud2 "& vbCrLf &_
			"        on dire2.ciud_ccod = ciud2.ciud_ccod    "& vbCrLf &_
			"    left outer join ciudades l "& vbCrLf &_
			"        on k.ciud_ccod = l.ciud_ccod "& vbCrLf &_
			"    left outer join tipos_colegios m "& vbCrLf &_
			"        on k.tcol_ccod = m.tcol_ccod "& vbCrLf &_
			"    join contratos cont (nolock) "& vbCrLf &_
			"        on d.matr_ncorr = cont.matr_ncorr and d.post_ncorr = cont.post_ncorr "& vbCrLf &_
			"    --join estados_matriculas emat "& vbCrLf &_
			"       --on emat.emat_ccod = (select top 1 emat_ccod from alumnos a1, ofertas_academicas o1 where a1.pers_ncorr=d.pers_ncorr and a1.ofer_ncorr=o1.ofer_ncorr and o1.espe_ccod = c.espe_ccod order by o1.peri_ccod desc, convert(datetime,a1.audi_fmodificacion) desc) "& vbCrLf &_
			" 		--on d.emat_ccod = emat.emat_ccod "& vbCrLf &_
			"	 left outer join codeudor_postulacion copo  (nolock) "& vbCrLf &_
			"        on pos.post_ncorr = copo.post_ncorr "& vbCrLf &_
			"    left outer join personas_postulante pers2  (nolock)"& vbCrLf &_
			"        on copo.pers_ncorr = pers2.pers_ncorr "& vbCrLf &_
			" where cont.econ_ccod = 1 "& vbCrLf &_
			" and d.emat_ccod not in (9) "& vbCrLf &_
			" and i.tdir_ccod = 1 "& vbCrLf &_
			" "& filtro_periodo & vbCrLf &_
			" and exists (select 1 from contratos cont1 (nolock), compromisos comp1  (nolock) where d.post_ncorr=cont1.post_ncorr and d.matr_ncorr=cont1.matr_ncorr and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2) ) "
			


'---------------------------------------agregamos los filtros adicionales a la consulta---------------------------------------------------------
if aran_nano_ingreso <> "" then
	consulta = consulta & " and cast(protic.ano_ingreso_carrera (a.pers_ncorr,e.carr_ccod) as varchar)= '"&aran_nano_ingreso&"'"
end if



if fecha_inicio <> "" then	
		 	consulta = consulta & " AND convert(varchar,d.audi_fmodificacion,103) = convert(datetime,'" & fecha_inicio & "',103) "& vbCrLf	
end if

if post_nano_paa <> "" then	
		 	consulta = consulta &  "  AND  (select top 1 ta1.POST_NANO_PAA  "& vbCrLf &_
								   "   		from postulantes ta1  (nolock)  "& vbCrLf &_
								   "   		where ta1.pers_ncorr=a.pers_ncorr and isnull(ta1.post_npaa_matematicas,0) > 0   "& vbCrLf &_
								   "   		and isnull(ta1.post_npaa_verbal,0) > 0  "& vbCrLf &_
								   "   		order by peri_ccod desc) = '" & post_nano_paa & "' "
end if

if ingreso_especial = "" then
	if min_puntaje <> "" then
		consulta = consulta & " AND  isnull((select top 1 cast((isnull(ta1.post_npaa_verbal,0) + isnull(ta1.post_npaa_matematicas,0)) / 2 as decimal(6,3)) "& vbCrLf &_
							  "       		 from postulantes ta1  (nolock) "& vbCrLf &_
							  "       		 where ta1.pers_ncorr=a.pers_ncorr and isnull(ta1.post_npaa_matematicas,0) > 0  "& vbCrLf &_
							  "       		 and isnull(ta1.post_npaa_verbal,0) > 0 "& vbCrLf &_
							  "      		 order by peri_ccod desc),0) >= '"&min_puntaje&"' "

	end if
	
	if max_puntaje <> "" then
		consulta = consulta & " AND  isnull((select top 1 cast((isnull(ta1.post_npaa_verbal,0) + isnull(ta1.post_npaa_matematicas,0)) / 2 as decimal(6,3)) "& vbCrLf &_
							  "       		 from postulantes ta1  (nolock) "& vbCrLf &_
							  "      		 where ta1.pers_ncorr=a.pers_ncorr and isnull(ta1.post_npaa_matematicas,0) > 0  "& vbCrLf &_
							  "       		 and isnull(ta1.post_npaa_verbal,0) > 0 "& vbCrLf &_
							  "       		 order by peri_ccod desc),0) <= '"&max_puntaje&"' "
	end if
else
	    consulta = consulta & " AND  isnull((select top 1 cast((isnull(ta1.post_npaa_verbal,0) + isnull(ta1.post_npaa_matematicas,0)) / 2 as decimal(6,3)) "& vbCrLf &_
							  "       		 from postulantes ta1  (nolock) "& vbCrLf &_
							  "       		 where ta1.pers_ncorr=a.pers_ncorr and isnull(ta1.post_npaa_matematicas,0) > 0  "& vbCrLf &_
							  "       		 and isnull(ta1.post_npaa_verbal,0) > 0 "& vbCrLf &_
							  "       		 order by peri_ccod desc),0) <= '475' "
end if
	 
consulta = consulta & " group by a.pers_ncorr, e.carr_ccod, c.peri_ccod,a.pers_nrut,a.pers_xdv, a.pers_tnombre,a.pers_tape_paterno, "& vbCrLf &_
			"         a.pers_tape_materno,a.pers_fnacimiento,d.matr_ncorr,f.carr_tdesc,c.post_bnuevo,d.alum_fmatricula,g.jorn_tdesc,h.sede_tdesc, "& vbCrLf &_
			"         i.dire_tcalle,pai.pais_tdesc,i.dire_tnro,i.dire_tpoblacion,i.dire_tblock,i.dire_tfono,j.ciud_tdesc,j.ciud_tcomuna,f.carr_ccod, "& vbCrLf &_
			"         dire2.dire_tcalle,dire2.dire_tnro,dire2.dire_tpoblacion,dire2.dire_tblock,dire2.dire_tfono,e.espe_tdesc,pl.plan_tdesc, "& vbCrLf &_
			"         ciud2.ciud_tdesc,ciud2.ciud_tcomuna,k.cole_tdesc,l.ciud_tdesc,l.ciud_tcomuna,a.pers_nnota_ens_media, reg.regi_tdesc,"& vbCrLf &_
			"         m.tcol_tdesc,a.pers_nano_egr_media,a.sexo_ccod,pos.tpad_ccod,pos.post_npaa_verbal,pos.POST_NANO_PAA,f.area_ccod, pea.anos_ccod, "& vbCrLf &_
			"         pos.post_npaa_matematicas,pos.post_nano_paa,pos.post_tinstitucion_anterior,a.pers_tcole_egreso,a.pers_ttipo_ensenanza,tip_ens.tens_ccod,tens_tdesc,"& vbCrLf &_
			"         cont.cont_fcontrato, d.audi_fmodificacion,c.espe_ccod,d.pers_ncorr,a.pers_fnacimiento,a.sexo_ccod,ARA.ARAN_MMATRICULA,ARA.ARAN_MCOLEGIATURA,"& vbCrLf &_
			"		  pers2.pers_ncorr,pers2.pers_nrut,pers2.pers_xdv,a.pers_temail,pers2.pers_tnombre,pers2.pers_tape_paterno,pers2.pers_tape_materno,pers2.pers_fnacimiento,talu_ccod,a.pers_tcelular "


if emat_tdesc <> "" then
	consulta = "select * from ("& consulta & ") table_1 where table_1.estado_academico ='"&emat_tdesc&"' "
end if

consulta = consulta & " order by sede,carrera,AP_Paterno,AP_Materno,Nombre"

'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_listado.Consultar consulta 'este hace la pega
'response.write(consulta)
%>


<html>
<head>
<title>Listado de Alumnos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<script language="JavaScript">
</script>

</head>
<body>

<br>
<%if autoriza_puntaje="S" then 
	cantidad_columnas = 14
 else
    cantidad_columnas = 11
 end if		
%>

<table width="100%" border="1" cellpadding="0" cellspacing="0">
  <tr>
  	<td colspan="21" bgcolor="#FFFFCC"><div align="center"><strong>INFORMACIÓN ALUMNO</strong></div></td>
  	<td colspan="16" bgcolor="#FFFFCC"><div align="center"><strong>INFORMACIÓN DE LA MATRICULA</strong></div></td>
  	<td colspan="<%=cantidad_columnas%>" bgcolor="#FFFFCC"><div align="center"><strong>INFORMACIÓN DE POSTULACIÓN</strong></div></td>
  	<td colspan="7" bgcolor="#FFFFCC"><div align="center"><strong>INFORMACIÓN CODEUDOR</strong></div></td>
	<%if agrega_carga <> "" then%>
		<td colspan="2" bgcolor="#FFFFCC"><div align="center"><strong>DATOS CARGA ACADÉMICA</strong></div></td>
	<%end if%>
	<%if agrega_morosidad <> "" then%>
		<td colspan="1" bgcolor="#FFFFCC"><div align="center"><strong>DATOS MOROSIDAD</strong></div></td>
	<%end if%>
	<%if agrega_documentos <> "" then%>
		<td colspan="22" bgcolor="#FFFFCC"><div align="center"><strong>DOCUMENTOS ENTREGADOS POR MATRICULA</strong></div></td>
	<%end if%>
  </tr>
  <tr>
    <td bgcolor="#FFFFCC"><div align="center"><strong>NUM</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>RUT</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="left"><strong>APELLIDO PATERNO</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="left"><strong>APELLIDO MATERNO</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="left"><strong>NOMBRES</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>FECHA NACIMIENTO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>EDAD</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>SEXO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>PAÍS</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>EMAIL UPA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>EMAIL PARTICULAR</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="left"><strong>DIRECCIÓN PARTICULAR</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>CASILLA PARTICULAR</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>TELÉFONO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>CELULAR</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>CIUDAD PARTICULAR</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>REGIÓN PARTICULAR</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="left"><strong>DIRECCIÓN ACADEMICA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>CASILLA ACADEMICA</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>TELÉFONO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>CIUDAD ACADEMICA</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>TIPO ALUMNO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>ES ALUMNO INTERCAMBIO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>ESTADO_ACADEMICO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>CONDICIÓN</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>OBSERVACIÓN</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>FECHA MATRICULA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>FECHA MODIFICACION</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>FACULTAD</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>COD. CARRERA</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="left"><strong>CARRERA</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="left"><strong>SEDE</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>JORNADA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>ESPECIALIDAD</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>MONTO MATRICULA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>MONTO ARANCEL</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>AÑO INGRESO CARRERA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>PLAN DE ESTUDIO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>COLEGIO EGRESO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>AÑO EGRESO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>TIPO PRUEBA</strong></div></td>
	<%if autoriza_puntaje="S" then%>
	<td bgcolor="#FFFFCC"><div align="center"><strong>VERBAL IE</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>MATEMÁTICAS IE</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>PROMEDIO PRUEBA IE</strong></div></td>
	<%end if%>
	<td bgcolor="#FFFFCC"><div align="center"><strong>VERBAL</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>MATEMÁTICAS</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>PROMEDIO PRUEBA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>AÑO PRUEBA</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>PROMEDIO ENS. MEDIA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>PROCEDENCIA EDUCACIÓN</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>TIPO ENSEÑANZA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>RUT CODEUDOR</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>NOMBRE CODEUDOR</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>FECHA NACIMIENTO CODEUDOR</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>DIRECCIÓN CODEUDOR</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>CIUDAD CODEUDOR</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>EMAIL CODEUDOR</strong></div></td>
    <td bgcolor="#FFCC00"><div align="center"><strong>TIPO INGRESO</strong></div></td>
	<%if agrega_carga <> "" then%>
	<td bgcolor="#FFFFCC"><div align="left"><strong>CON CARGA TOMADA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>CANTIDAD DE ASIGNATURAS</strong></div></td>
	<%end if%>
	<%if agrega_morosidad <> "" then%>
	<td bgcolor="#FFFFCC"><div align="left"><strong>MOROSO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>MONTO MOROSIDAD</strong></div></td>
	<%end if%>
	<%if agrega_documentos <> "" then%>
	<td bgcolor="#FFFFCC"><div align="center"><strong>CED. IDENTIDAD/CED. PAÍS DE ORIGEN/PASAPORTE</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>LICENCIA ENSEÑANZA MEDIA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>CONCENTRACIÓN DE NOTAS ENS. MEDIA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>PUNTAJE P.A.A. / P.S.U.</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>02 FOTOGRAFÍAS TAM. CARNET, NOMBRE/RUT</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>CERTIFICADO DE RESIDENCIA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>SEGURO DE SALUD (EXTRANJEROS)</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>INGRESO ESPECIAL(CONVALIDACIÓN/EXTRANJEROS)</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>Título Profesional de (8 semestres) en el área de Administración y Comercio, (original o copia legalizada)</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>Título Profesional de (8 semestres), (original o copia legalizada)</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>Título Técnico de Nivel Superior en el área de Administración y Comercio</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>Título Técnico de Nivel Superior en Prevención de Riesgos</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>Documento que acredite beneficio otorgado para Universidad</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>Diploma de Bachillerato Internacional</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>Documento del Departamento de Deportes de la DAE de la Universidad que acredite el beneficio. Visado por Vicerrectoría Académica</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>Documento de la Universidad que acredite beneficio de Beca Talento Creativo y Emprendedor. Visado por Vicerrectoría Académica</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>Título Profesional de (8 semestres) en el área de Administración y Comercio, (original o copia legalizada)</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>Certificado de notas con ramos aprobados y reprobados</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>Certificado de notas con ramos aprobados y reprobados de la Institución de Educación Superior de origen</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>Certificado original o fotocopia legalizada de los semestres cursados en la Institución de origen</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>Planes y Programas de asignaturas aprobadas de la Institución de procedencia</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>Certificado de Título de la carrera cursada, (original o fotocopia legalizada)</strong></div></td>
	<%end if%>
  </tr>
  <%NUMERO=1%>
  <%while f_listado.Siguiente%> <!-- mientras hay registro hace-->
  <tr>
    <td><%=NUMERO%></td>
	<td><%=f_listado.ObtenerValor("rut")%></td>
    <td><%=f_listado.ObtenerValor("AP_PATERNO")%></td>
    <td><%=f_listado.ObtenerValor("AP_MATERNO")%></td>
    <td><%=f_listado.ObtenerValor("nombre")%></td>
	<td><%=f_listado.ObtenerValor("fecha_nacimiento")%></td>
	<td><%=f_listado.ObtenerValor("edad")%></td>
	<td><%=f_listado.ObtenerValor("sexo")%></td>
	<td><%=f_listado.ObtenerValor("pais")%></td>
	<td><%=f_listado.ObtenerValor("email_upa")%></td>
	<td><%=f_listado.ObtenerValor("email")%></td>
	<td><%=f_listado.ObtenerValor("dire_particular")%></td>
	<td><%=f_listado.ObtenerValor("casilla_particular")%></td>
	<td><%=f_listado.ObtenerValor("telefono_particular")%></td>
	<td><%=f_listado.ObtenerValor("pers_tcelular")%></td>
	<td><%=f_listado.ObtenerValor("comuna_particular")%> , <%=f_listado.ObtenerValor("ciudad_particular")%></td>
	<td><%=f_listado.ObtenerValor("region_particular")%></td>
	<td><%=f_listado.ObtenerValor("dire_academica")%></td>
	<td><%=f_listado.ObtenerValor("casilla_academica")%></td>
	<td><%=f_listado.ObtenerValor("telefono_academica")%></td>
	<td><%=f_listado.ObtenerValor("comuna_academica")%> , <%=f_listado.ObtenerValor("ciudad_academica")%></td>
	<td><%=f_listado.ObtenerValor("tipo")%></td>
	<td><%=f_listado.ObtenerValor("tipo_intercambio")%></td>
	<td><%=f_listado.ObtenerValor("estado_academico")%></td>
	<td><%=f_listado.ObtenerValor("condicion")%></td>
	<td><%=f_listado.ObtenerValor("observacion")%></td>
	<td><%=f_listado.ObtenerValor("fecha_matricula")%></td>
	<td><%=f_listado.ObtenerValor("fecha_modificacion")%></td>
	<td><%=f_listado.ObtenerValor("facultad")%></td>
	<td><%=f_listado.ObtenerValor("cod_carrera")%></td>
	<td><%=f_listado.ObtenerValor("carrera")%></td>
	<td><%=f_listado.ObtenerValor("sede")%></td>
	<td><%=f_listado.ObtenerValor("jornada")%></td>
	<td><%=f_listado.ObtenerValor("especialidad")%></td>
	<td><%=f_listado.ObtenerValor("ARAN_MMATRICULA")%></td>
	<td><%=f_listado.ObtenerValor("ARAN_MCOLEGIATURA")%></td>
	<td><%=f_listado.ObtenerValor("ano_ingreso")%></td>
	<td><%=f_listado.ObtenerValor("plan_est")%></td>
	<td><%=f_listado.ObtenerValor("nombre_colegio")%>&nbsp;&nbsp;<%=f_listado.ObtenerValor("comuna_colegio")%>,&nbsp;<%=f_listado.ObtenerValor("ciudad_colegio")%></td>
	<td><%=f_listado.ObtenerValor("ano_egreso")%></td>
	<td><%=f_listado.ObtenerValor("tipo_prueba")%></td>
	<td><%=f_listado.ObtenerValor("puntaje_verbal")%></td>
	<td><%=f_listado.ObtenerValor("puntaje_matematicas")%></td>
	<td><%=f_listado.ObtenerValor("promedio_prueba")%></td>
	<%if autoriza_puntaje="S" then
		 if f_listado.ObtenerValor("promedio_prueba")  > "475" then %>
			<td><%=f_listado.ObtenerValor("puntaje_verbal")%></td>
			<td><%=f_listado.ObtenerValor("puntaje_matematicas")%></td>
			<td><%=f_listado.ObtenerValor("promedio_prueba")%></td>
		<%else%>
			<td>Ingreso Especial</td>
			<td>Ingreso Especial</td>
			<td>Ingreso Especial</td>
		 <%end if
	end if%>
	<td><%=f_listado.ObtenerValor("ano_paa")%></td>
	<td><%=f_listado.ObtenerValor("promedio_media")%></td>
	<td><%=f_listado.ObtenerValor("tipo_colegio")%></td>
	<td><%=f_listado.ObtenerValor("tipo_ensenanza")%></td>
	<td><%=f_listado.ObtenerValor("rut_codeudor")%></td>
	<td><%=f_listado.ObtenerValor("codeudor")%></td>
	<td><%=f_listado.ObtenerValor("fecha_nacimiento_codeudor")%></td>
	<td><%=f_listado.ObtenerValor("direccion_codeudor")%></td>
	<td><%=f_listado.ObtenerValor("ciudad_codeudor")%></td>
	<td><%=f_listado.ObtenerValor("email_codeudor")%></td>
    <td bgcolor="#FFCC00"><%=f_listado.ObtenerValor("tipo_mat")%></td>
	<%if agrega_carga <> "" then%>
	<td><%=f_listado.ObtenerValor("con_carga")%></td>
	<td><%=f_listado.ObtenerValor("cant_asignaturas")%></td>
	<%end if%>
	<%if agrega_morosidad <> "" then%>
	<td><%=f_listado.ObtenerValor("es_moroso")%></td>
	<td><%=f_listado.ObtenerValor("monto_morosidad")%></td>
	<%end if%>
	<%if agrega_documentos <> "" then%>
	<td align="center"><%=f_listado.ObtenerValor("Ced_identidad")%></td>
	<td align="center"><%=f_listado.ObtenerValor("Lic_Enseñanza_Media")%></td>
	<td align="center"><%=f_listado.ObtenerValor("Conc_de_notas_Enseñanza_Media")%></td>
	<td align="center"><%=f_listado.ObtenerValor("Puntaje_PSU")%></td>
	<td align="center"><%=f_listado.ObtenerValor("Fotografias")%></td>
	<td align="center"><%=f_listado.ObtenerValor("Certificado_Residencia")%></td>
	<td align="center"><%=f_listado.ObtenerValor("Seguro_Salud")%></td>
    <td align="center"><%=f_listado.ObtenerValor("Doc_Mat_9")%></td>
    <td align="center"><%=f_listado.ObtenerValor("Doc_Mat_10")%></td>
    <td align="center"><%=f_listado.ObtenerValor("Doc_Mat_11")%></td>
    <td align="center"><%=f_listado.ObtenerValor("Doc_Mat_12")%></td>
    <td align="center"><%=f_listado.ObtenerValor("Doc_Mat_13")%></td>
    <td align="center"><%=f_listado.ObtenerValor("Doc_Mat_14")%></td>
    <td align="center"><%=f_listado.ObtenerValor("Doc_Mat_15")%></td>
    <td align="center"><%=f_listado.ObtenerValor("Doc_Mat_16")%></td>
    <td align="center"><%=f_listado.ObtenerValor("Doc_Mat_17")%></td>
    <td align="center"><%=f_listado.ObtenerValor("Doc_Mat_18")%></td>
    <td align="center"><%=f_listado.ObtenerValor("Doc_Mat_19")%></td>
    <td align="center"><%=f_listado.ObtenerValor("Doc_Mat_20")%></td>
    <td align="center"><%=f_listado.ObtenerValor("Doc_Mat_21")%></td>
    <td align="center"><%=f_listado.ObtenerValor("Doc_Mat_22")%></td>
    <td align="center"><%=f_listado.ObtenerValor("Doc_Mat_23")%></td>
	<%end if%>
  </tr>
   <%NUMERO=NUMERO+1%>
  <%wend%>
</table>
</body>
</html>
