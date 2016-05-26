<!-- #include file = "../biblioteca/_conexion.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=estadisticas_egreso_titulacion_personas.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 350000
set conexion = new CConexion
conexion.Inicializar "upacifico"

'-----------------------------------------------------------------------
fecha		= conexion.consultaUno("select getDate() ")
sede_ccod 	= request.QueryString("sede_ccod")
tipo      	= request.QueryString("tipo")
sexo_ccod 	= request.QueryString("sexo_ccod")
institucion	= request.QueryString("institucion")
facu_ccod	= request.QueryString("facu_ccod")
carr_ccod   = request.QueryString("carr_ccod")

sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede_ccod&"'")
carr_tdesc = conexion.consultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar)='"&carr_ccod&"'")
facu_tdesc = conexion.consultaUno("select facu_tdesc from facultades where cast(facu_ccod as varchar)='"&facu_ccod&"'")
sexo_tdesc = conexion.consultaUno("select sexo_tdesc from sexos where cast(sexo_ccod as varchar)='"&sexo_ccod&"'")
fecha1	   = conexion.consultaUno("select getDate()")
estado = ""
categoria = "PREGRADO"
institucion = "UNIVERSIDAD"
insti		= "U"
query = ""

set f_personas = new cformulario
f_personas.carga_parametros "tabla_vacia.xml","tabla"
f_personas.inicializar conexion

if tipo = "UEG" then
	estado = "Egresados de Universidad"
	query = "select distinct cast(f.pers_nrut as varchar)+'-'+f.pers_xdv as rut, f.pers_tape_paterno + ' ' + f.pers_tape_materno + ', ' + f.pers_tnombre as nombre,"& vbCrLf &_
	        " (select sexo_tdesc from sexos ttt where ttt.sexo_ccod=f.sexo_ccod) as sexo, protic.trunc(f.pers_fnacimiento) as nacimiento, '"&institucion&"' as institu, "& vbCrLf &_
			" '"&sede_tdesc&"' as sede, e.facu_tdesc as facultad, c.carr_tdesc as carrera, "& vbCrLf &_
			" (select top 1 t3.espe_tdesc  "& vbCrLf &_
            "         from alumnos tt (nolock), ofertas_academicas t2, especialidades t3  "& vbCrLf &_
            "         where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod  "& vbCrLf &_
            "         and tt.emat_ccod <> 9 and tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
            "         and t3.carr_ccod=c.carr_ccod order by t2.peri_ccod desc) as especialidad, "& vbCrLf &_
			" (select top 1 t4.jorn_tdesc  "& vbCrLf &_
            "         from alumnos tt (nolock), ofertas_academicas t2, especialidades t3, jornadas t4  "& vbCrLf &_
            "         where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod  "& vbCrLf &_
            "         and tt.emat_ccod <> 9 and tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
            "         and t3.carr_ccod=c.carr_ccod and t2.jorn_ccod=t4.jorn_ccod order by t2.peri_ccod desc) as jornada, "& vbCrLf &_
			" 'SI' as egresado, "& vbCrLf &_
			" (select top 1 protic.trunc(fecha_egreso)  "& vbCrLf &_
			"  from detalles_titulacion_carrera ttt (nolock) "& vbCrLf &_
			"  where ttt.pers_ncorr=a.pers_ncorr and ttt.carr_ccod=a.carr_ccod  "& vbCrLf &_
			"  and ttt.plan_ccod=a.plan_ccod and isnull(protic.trunc(ttt.fecha_egreso),'')<>'' )  as fecha_egreso, "& vbCrLf &_
			" (select case count(*) when 0 then 'NO' else 'SI' end  "& vbCrLf &_
			"  from alumnos_salidas_carrera ttt (nolock), salidas_carrera tt2 "& vbCrLf &_
			"  where ttt.pers_ncorr=a.pers_ncorr and ttt.saca_ncorr=tt2.saca_ncorr "& vbCrLf &_
			"  and tt2.carr_ccod=a.carr_ccod and tt2.plan_ccod=a.plan_ccod)  as titulado, "& vbCrLf &_
			" (select top 1 protic.trunc(ttt.ASCA_FSALIDA) "& vbCrLf &_
			"  from alumnos_salidas_carrera ttt (nolock), salidas_carrera tt2 "& vbCrLf &_
			"  where ttt.pers_ncorr=a.pers_ncorr and ttt.saca_ncorr=tt2.saca_ncorr "& vbCrLf &_
 			"  and tt2.carr_ccod=a.carr_ccod and tt2.plan_ccod=a.plan_ccod)  as fecha_titulo, "& vbCrLf &_
			" case c.tcar_ccod when 1 then 'SI' else '' end as pregrado, case c.tcar_ccod when 2 then 'SI' else '' end as postgrado, "& vbCrLf &_
			" protic.ano_ingreso_carrera_egresa2(f.pers_ncorr,c.carr_ccod) as ano_ingreso,  "& vbCrLf &_
			" (select lower(ttt.pers_temail) from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as email,  "& vbCrLf &_
			" (select pers_tfono from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as fono_p,  "& vbCrLf &_
			" (select pers_tcelular from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as celular,  "& vbCrLf &_
			" ' ' as facebook, ' ' as twitter, ' ' as lindkedin, (select pais_tdesc from paises ttt where ttt.pais_ccod=f.pais_ccod) as pais,   "& vbCrLf &_
			" (select tt3.regi_tdesc from alumni_direcciones ttt, ciudades tt2, regiones tt3 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod and tt2.regi_ccod=tt3.regi_ccod) as region,  "& vbCrLf &_
            " (select tt2.ciud_tcomuna from alumni_direcciones ttt, ciudades tt2 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod) as ciudad,  "& vbCrLf &_
			" (select tt2.ciud_tdesc from alumni_direcciones ttt, ciudades tt2 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod) as comuna,  "& vbCrLf &_
			" (select ttt.dire_tcalle from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as calle,  "& vbCrLf &_
			" (select ttt.dire_tnro from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as nro,  "& vbCrLf &_
			" (select ttt.dire_tblock from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as depto,  "& vbCrLf &_
			" (select ttt.dire_tpoblacion from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as condominio,  "& vbCrLf &_
			" (select ttt.dire_tdepto from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as villa,  "& vbCrLf &_
			" (select ttt.dire_tlocalidad from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as localidad,  "& vbCrLf &_
			" (select ttt.ciud_particular from alumni_personas ttt where ttt.pers_ncorr=f.pers_ncorr) as ciudad_ext,  "& vbCrLf &_
			" (select ttt.regi_particular from alumni_personas ttt where ttt.pers_ncorr=f.pers_ncorr) as region_ext,  "& vbCrLf &_
			" (select top 1 dlp.dlpr_nombre_empresa from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as empresa, "& vbCrLf &_
            " (select top 1 dlp.dlpr_rubro_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as rubro, "& vbCrLf &_
		    " (select top 1 dlp.dlpr_depto_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as depto, "& vbCrLf &_		   
		    " (select top 1 dlp.dlpr_cargo_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as cargo, "& vbCrLf &_
		    " (select top 1 dlp.dlpr_email_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as email_laboral, "& vbCrLf &_
		    " (select top 1 dlp.dlpr_web_empresa    from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as web, "& vbCrLf &_
			" protic.ultima_modificacion_cpp(f.pers_ncorr,2) as usuario, "& vbCrLf &_
		    " protic.ultima_modificacion_cpp(f.pers_ncorr,1) as fecha_modificacion, "& vbCrLf &_
			" (select case dae.tipo_contacto when 'P' then 'Particular' when 'C' then 'Comercial' else '' end from alumni_datos_adicionales_egresados dae where dae.pers_ncorr=f.pers_ncorr) as tipo_contacto, "& vbCrLf &_
			" (select recibir_info from alumni_datos_adicionales_egresados dae where dae.pers_ncorr=f.pers_ncorr) as recibir_info "& vbCrLf &_
			"    from detalles_titulacion_carrera a (nolock), carreras c,   "& vbCrLf &_
            "         areas_academicas d, facultades e,personas f (nolock)  "& vbCrLf &_
            "    where a.carr_ccod=c.carr_ccod  "& vbCrLf &_
            "    and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
            "    and a.pers_ncorr=f.pers_ncorr and isnull(protic.trunc(a.fecha_egreso),'')<>''  "& vbCrLf &_
            "    and e.facu_ccod = case when "&facu_ccod&" = 0 then e.facu_ccod else "&facu_ccod&" end  "& vbCrLf &_
            "    and c.carr_ccod = case when '"&carr_ccod&"' = '0' then c.carr_ccod else '"&carr_ccod&"' end  "& vbCrLf &_
            "    and (select top 1 t2.sede_ccod  "& vbCrLf &_
            "         from alumnos tt (nolock), ofertas_academicas t2, especialidades t3  "& vbCrLf &_
            "         where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod  "& vbCrLf &_
            "         and tt.emat_ccod <> 9 and tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
            "         and t3.carr_ccod=c.carr_ccod order by t2.peri_ccod desc) = "&sede_ccod&"  "& vbCrLf &_
            "    and cast(isnull(f.sexo_ccod,1) as varchar) = "&sexo_ccod&"  "& vbCrLf &_
            "    and not exists (select 1 from salidas_carrera tt where tt.carr_ccod=a.carr_ccod   "& vbCrLf &_
            "                    and tt.saca_ncorr=a.plan_ccod and tt.tsca_ccod = 4)  "& vbCrLf &_
            "    union  "& vbCrLf &_
            "    select distinct cast(f.pers_nrut as varchar)+'-'+f.pers_xdv as rut, f.pers_tape_paterno + ' ' + f.pers_tape_materno + ', ' + f.pers_tnombre as nombre,"& vbCrLf &_
	        "    (select sexo_tdesc from sexos ttt where ttt.sexo_ccod=f.sexo_ccod) as sexo, protic.trunc(f.pers_fnacimiento) as nacimiento,'"&institucion&"' as institu,   "& vbCrLf &_
			"    '"&sede_tdesc&"' as sede, e.facu_tdesc as facultad, c.carr_tdesc as carrera,' '  as especialidad,  "& vbCrLf &_
			"    (select jorn_tdesc from jornadas ttt where ttt.jorn_ccod=a.jorn_ccod) as jornada,    "& vbCrLf &_
			"    (select case count(*) when 0 then 'NO' else 'SI' end  "& vbCrLf &_
			"     from egresados_upa2 ttt where ttt.pers_ncorr=a.pers_ncorr and ttt.carr_ccod=a.carr_ccod  "& vbCrLf &_
			"     and a.entidad='U' and a.emat_ccod=4) as egresado, "& vbCrLf &_
			"    '' as fecha_egreso, "& vbCrLf &_
			"    (select case count(*) when 0 then 'NO' else 'SI' end "& vbCrLf &_
			"     from egresados_upa2 ttt where ttt.pers_ncorr=a.pers_ncorr and ttt.carr_ccod=a.carr_ccod "& vbCrLf &_
			"     and a.entidad='U' and a.emat_ccod=4) as titulado, "& vbCrLf &_
			"    '' as fecha_titulo, "& vbCrLf &_
			"    case c.tcar_ccod when 1 then 'SI' else '' end as pregrado, case c.tcar_ccod when 2 then 'SI' else '' end as postgrado, "& vbCrLf &_
			"    protic.ano_ingreso_carrera_egresa2(f.pers_ncorr,c.carr_ccod) as ano_ingreso,    "& vbCrLf &_
			"    (select lower(ttt.pers_temail) from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as email,  "& vbCrLf &_
			"    (select pers_tfono from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as fono_p,  "& vbCrLf &_
			"    (select pers_tcelular from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as celular,  "& vbCrLf &_
			"    ' ' as facebook, ' ' as twitter, ' ' as lindkedin, (select pais_tdesc from paises ttt where ttt.pais_ccod=f.pais_ccod) as pais,    "& vbCrLf &_
			"    (select tt3.regi_tdesc from alumni_direcciones ttt, ciudades tt2, regiones tt3 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod and tt2.regi_ccod=tt3.regi_ccod) as region,  "& vbCrLf &_
			"    (select tt2.ciud_tcomuna from alumni_direcciones ttt, ciudades tt2 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod) as ciudad,  "& vbCrLf &_
			"    (select tt2.ciud_tdesc from alumni_direcciones ttt, ciudades tt2 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod) as comuna,  "& vbCrLf &_
            " (select ttt.dire_tcalle from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as calle,  "& vbCrLf &_
			" (select ttt.dire_tnro from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as nro,  "& vbCrLf &_
			" (select ttt.dire_tblock from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as depto,  "& vbCrLf &_
			" (select ttt.dire_tpoblacion from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as condominio,  "& vbCrLf &_
			" (select ttt.dire_tdepto from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as villa,  "& vbCrLf &_
			" (select ttt.dire_tlocalidad from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as localidad,  "& vbCrLf &_
			" (select ttt.ciud_particular from alumni_personas ttt where ttt.pers_ncorr=f.pers_ncorr) as ciudad_ext,  "& vbCrLf &_
			" (select ttt.regi_particular from alumni_personas ttt where ttt.pers_ncorr=f.pers_ncorr) as region_ext,  "& vbCrLf &_
			" (select top 1 dlp.dlpr_nombre_empresa from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as empresa, "& vbCrLf &_
            " (select top 1 dlp.dlpr_rubro_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as rubro, "& vbCrLf &_
		    " (select top 1 dlp.dlpr_depto_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as depto, "& vbCrLf &_		   
		    " (select top 1 dlp.dlpr_cargo_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as cargo, "& vbCrLf &_
		    " (select top 1 dlp.dlpr_email_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as email_laboral, "& vbCrLf &_
		    " (select top 1 dlp.dlpr_web_empresa    from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as web, "& vbCrLf &_
			" protic.ultima_modificacion_cpp(f.pers_ncorr,2) as usuario, "& vbCrLf &_
		    " protic.ultima_modificacion_cpp(f.pers_ncorr,1) as fecha_modificacion , "& vbCrLf &_
			" (select case dae.tipo_contacto when 'P' then 'Particular' when 'C' then 'Comercial' else '' end from alumni_datos_adicionales_egresados dae where dae.pers_ncorr=f.pers_ncorr) as tipo_contacto, "& vbCrLf &_
			" (select recibir_info from alumni_datos_adicionales_egresados dae where dae.pers_ncorr=f.pers_ncorr) as recibir_info "& vbCrLf &_
			"    from egresados_upa2 a (nolock),carreras c (nolock),  "& vbCrLf &_
            "    areas_academicas d, facultades e,personas f (nolock)  "& vbCrLf &_
            "    where a.carr_ccod=c.carr_ccod  "& vbCrLf &_
            "    and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod and a.pers_ncorr=f.pers_ncorr  "& vbCrLf &_
            "    and a.ENTIDAD='U' and a.emat_ccod in (4,8)  "& vbCrLf &_
            "    and cast(a.sede_ccod as varchar) = "&sede_ccod&"  "& vbCrLf &_
            "    and e.facu_ccod = case when "&facu_ccod&" = 0 then e.facu_ccod else "&facu_ccod&" end  "& vbCrLf &_
            "    and c.carr_ccod = case when '"&carr_ccod&"' = '0' then c.carr_ccod else '"&carr_ccod&"' end  "& vbCrLf &_
            "    and cast(isnull(a.sexo_ccod,1) as varchar)= "&sexo_ccod&"  "& vbCrLf &_
            "    and not exists (select 1 from detalles_titulacion_carrera tt (nolock)  "& vbCrLf &_
            "                    where tt.pers_ncorr=a.pers_ncorr and tt.carr_ccod=c.carr_ccod  "& vbCrLf &_
            "                    and isnull(protic.trunc(tt.fecha_egreso),'') <> '') order by nombre asc"
end if
if tipo = "UTI" then
	estado = "Titulados de Universidad"
	query= "select distinct cast(f.pers_nrut as varchar)+'-'+f.pers_xdv as rut, f.pers_tape_paterno + ' ' + f.pers_tape_materno + ', ' + f.pers_tnombre as nombre,"& vbCrLf &_
	       " (select sexo_tdesc from sexos ttt where ttt.sexo_ccod=f.sexo_ccod) as sexo, protic.trunc(f.pers_fnacimiento) as nacimiento,'"&institucion&"' as institu,   "& vbCrLf &_
		   " '"&sede_tdesc&"' as sede, e.facu_tdesc as facultad, c.carr_tdesc as carrera,  "& vbCrLf &_
		   " (select top 1 t3.espe_tdesc  "& vbCrLf &_
           "         from alumnos tt (nolock), ofertas_academicas t2, especialidades t3  "& vbCrLf &_
           "         where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod  "& vbCrLf &_
           "         and tt.emat_ccod <> 9 and tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
           "         and t3.carr_ccod=c.carr_ccod order by t2.peri_ccod desc) as especialidad, "& vbCrLf &_
		   " (select top 1 t4.jorn_tdesc  "& vbCrLf &_
           "         from alumnos tt (nolock), ofertas_academicas t2, especialidades t3, jornadas t4  "& vbCrLf &_
           "         where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod  "& vbCrLf &_
           "         and tt.emat_ccod <> 9 and tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
           "         and t3.carr_ccod=c.carr_ccod and t2.jorn_ccod=t4.jorn_ccod order by t2.peri_ccod desc) as jornada, "& vbCrLf &_
		   " (select case count(*) when 0 then 'NO' else 'SI' end  "& vbCrLf &_
		   "  from detalles_titulacion_carrera ttt (nolock) "& vbCrLf &_
		   "  where ttt.pers_ncorr=a.pers_ncorr and ttt.carr_ccod=b.carr_ccod  "& vbCrLf &_
		   "  and ttt.plan_ccod=b.plan_ccod and isnull(protic.trunc(ttt.fecha_egreso),'')<>'' ) as egresado, "& vbCrLf &_
		   " (select top 1 protic.trunc(fecha_egreso)  "& vbCrLf &_
		   "  from detalles_titulacion_carrera ttt (nolock) "& vbCrLf &_
		   "  where ttt.pers_ncorr=a.pers_ncorr and ttt.carr_ccod=b.carr_ccod  "& vbCrLf &_
		   "  and ttt.plan_ccod=b.plan_ccod and isnull(protic.trunc(ttt.fecha_egreso),'')<>'' )  as fecha_egreso, "& vbCrLf &_
		   " (select case count(*) when 0 then 'NO' else 'SI' end  "& vbCrLf &_
		   "  from alumnos_salidas_carrera ttt (nolock), salidas_carrera tt2 "& vbCrLf &_
		   "  where ttt.pers_ncorr=a.pers_ncorr and ttt.saca_ncorr=tt2.saca_ncorr "& vbCrLf &_
		   "  and tt2.carr_ccod=b.carr_ccod and tt2.plan_ccod=b.plan_ccod)  as titulado, "& vbCrLf &_
		   " (select top 1 protic.trunc(ttt.ASCA_FSALIDA) "& vbCrLf &_
		   "  from alumnos_salidas_carrera ttt (nolock), salidas_carrera tt2 "& vbCrLf &_
		   "  where ttt.pers_ncorr=a.pers_ncorr and ttt.saca_ncorr=tt2.saca_ncorr "& vbCrLf &_
		   "  and tt2.carr_ccod=b.carr_ccod and tt2.plan_ccod=b.plan_ccod)  as fecha_titulo, "& vbCrLf &_
		   " case c.tcar_ccod when 1 then 'SI' else '' end as pregrado, case c.tcar_ccod when 2 then 'SI' else '' end as postgrado, "& vbCrLf &_
		   " protic.ano_ingreso_carrera_egresa2(f.pers_ncorr,c.carr_ccod) as ano_ingreso,   "& vbCrLf &_
		   " (select lower(ttt.pers_temail) from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as email,  "& vbCrLf &_
		   " (select pers_tfono from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as fono_p,  "& vbCrLf &_
		   " (select pers_tcelular from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as celular,  "& vbCrLf &_
		   " ' ' as facebook, ' ' as twitter, ' ' as lindkedin, (select pais_tdesc from paises ttt where ttt.pais_ccod=f.pais_ccod) as pais,    "& vbCrLf &_
		   " (select tt3.regi_tdesc from alumni_direcciones ttt, ciudades tt2, regiones tt3 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod and tt2.regi_ccod=tt3.regi_ccod) as region,  "& vbCrLf &_
           " (select tt2.ciud_tcomuna from alumni_direcciones ttt, ciudades tt2 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod) as ciudad,  "& vbCrLf &_
		   " (select tt2.ciud_tdesc from alumni_direcciones ttt, ciudades tt2 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod) as comuna,  "& vbCrLf &_
		   " (select ttt.dire_tcalle from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as calle,  "& vbCrLf &_
		   " (select ttt.dire_tnro from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as nro,  "& vbCrLf &_
		   " (select ttt.dire_tblock from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as depto,  "& vbCrLf &_
		   " (select ttt.dire_tpoblacion from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as condominio,  "& vbCrLf &_
		   " (select ttt.dire_tdepto from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as villa,  "& vbCrLf &_
		   " (select ttt.dire_tlocalidad from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as localidad,  "& vbCrLf &_
		   " (select ttt.ciud_particular from alumni_personas ttt where ttt.pers_ncorr=f.pers_ncorr) as ciudad_ext,  "& vbCrLf &_
		   " (select ttt.regi_particular from alumni_personas ttt where ttt.pers_ncorr=f.pers_ncorr) as region_ext,  "& vbCrLf &_
		   " (select top 1 dlp.dlpr_nombre_empresa from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as empresa, "& vbCrLf &_
           " (select top 1 dlp.dlpr_rubro_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as rubro, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_depto_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as depto, "& vbCrLf &_		   
		   " (select top 1 dlp.dlpr_cargo_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as cargo, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_email_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as email_laboral, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_web_empresa    from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as web, "& vbCrLf &_
		   " protic.ultima_modificacion_cpp(f.pers_ncorr,2) as usuario, "& vbCrLf &_
		   " protic.ultima_modificacion_cpp(f.pers_ncorr,1) as fecha_modificacion, "& vbCrLf &_
		   " (select case dae.tipo_contacto when 'P' then 'Particular' when 'C' then 'Comercial' else '' end from alumni_datos_adicionales_egresados dae where dae.pers_ncorr=f.pers_ncorr) as tipo_contacto, "& vbCrLf &_
		   " (select recibir_info from alumni_datos_adicionales_egresados dae where dae.pers_ncorr=f.pers_ncorr) as recibir_info "& vbCrLf &_
		   " from alumnos_salidas_carrera a (nolock), salidas_carrera b (nolock), carreras c (nolock), "& vbCrLf &_ 
           "      areas_academicas d, facultades e,personas f (nolock) "& vbCrLf &_
           " where a.saca_ncorr = b.saca_ncorr and b.carr_ccod=c.carr_ccod "& vbCrLf &_
           " and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod  "& vbCrLf &_
           " and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (1,2,5) "& vbCrLf &_
           " and e.facu_ccod = case when "&facu_ccod&" = 0 then e.facu_ccod else "&facu_ccod&" end "& vbCrLf &_
           " and c.carr_ccod = case when '"&carr_ccod&"' = '0' then c.carr_ccod else '"&carr_ccod&"' end "& vbCrLf &_
           " and cast(a.sede_ccod as varchar)="&sede_ccod&" "& vbCrLf &_
           " and cast(isnull(f.sexo_ccod,1) as varchar)="&sexo_ccod&" "& vbCrLf &_
           " union "& vbCrLf &_
           " select distinct cast(f.pers_nrut as varchar)+'-'+f.pers_xdv as rut, f.pers_tape_paterno + ' ' + f.pers_tape_materno + ', ' + f.pers_tnombre as nombre,"& vbCrLf &_
	       " (select sexo_tdesc from sexos ttt where ttt.sexo_ccod=f.sexo_ccod) as sexo, protic.trunc(f.pers_fnacimiento) as nacimiento,'"&institucion&"' as institu,   "& vbCrLf &_
		   " '"&sede_tdesc&"' as sede, e.facu_tdesc as facultad, c.carr_tdesc as carrera,' '  as especialidad,   "& vbCrLf &_
		   " (select jorn_tdesc from jornadas ttt where ttt.jorn_ccod=a.jorn_ccod) as jornada,    "& vbCrLf &_
		   " (select case count(*) when 0 then 'NO' else 'SI' end "& vbCrLf &_
		   "  from egresados_upa2 ttt where ttt.pers_ncorr=a.pers_ncorr and ttt.carr_ccod=a.carr_ccod "& vbCrLf &_
		   "  and a.entidad='U' and a.emat_ccod=4) as egresado, "& vbCrLf &_
		   " '' as fecha_egreso, "& vbCrLf &_
		   " (select case count(*) when 0 then 'NO' else 'SI' end "& vbCrLf &_
		   "  from egresados_upa2 ttt where ttt.pers_ncorr=a.pers_ncorr and ttt.carr_ccod=a.carr_ccod "& vbCrLf &_
		   "  and a.entidad='U' and a.emat_ccod=4) as titulado, "& vbCrLf &_
		   " '' as fecha_titulo, "& vbCrLf &_
		   " case c.tcar_ccod when 1 then 'SI' else '' end as pregrado, case c.tcar_ccod when 2 then 'SI' else '' end as postgrado, "& vbCrLf &_
		   " protic.ano_ingreso_carrera_egresa2(f.pers_ncorr,c.carr_ccod) as ano_ingreso,   "& vbCrLf &_
		   " (select lower(ttt.pers_temail) from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as email,  "& vbCrLf &_
		   " (select pers_tfono from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as fono_p,  "& vbCrLf &_
		   " (select pers_tcelular from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as celular,  "& vbCrLf &_
		   " ' ' as facebook, ' ' as twitter, ' ' as lindkedin, (select pais_tdesc from paises ttt where ttt.pais_ccod=f.pais_ccod) as pais,    "& vbCrLf &_
		   " (select tt3.regi_tdesc from alumni_direcciones ttt, ciudades tt2, regiones tt3 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod and tt2.regi_ccod=tt3.regi_ccod) as region,  "& vbCrLf &_
           " (select tt2.ciud_tcomuna from alumni_direcciones ttt, ciudades tt2 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod) as ciudad,  "& vbCrLf &_
		   " (select tt2.ciud_tdesc from alumni_direcciones ttt, ciudades tt2 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod) as comuna,  "& vbCrLf &_
		   " (select ttt.dire_tcalle from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as calle,  "& vbCrLf &_
		   " (select ttt.dire_tnro from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as nro,  "& vbCrLf &_
		   " (select ttt.dire_tblock from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as depto,  "& vbCrLf &_
		   " (select ttt.dire_tpoblacion from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as condominio,  "& vbCrLf &_
		   " (select ttt.dire_tdepto from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as villa,  "& vbCrLf &_
		   " (select ttt.dire_tlocalidad from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as localidad,  "& vbCrLf &_
		   " (select ttt.ciud_particular from alumni_personas ttt where ttt.pers_ncorr=f.pers_ncorr) as ciudad_ext,  "& vbCrLf &_
		   " (select ttt.regi_particular from alumni_personas ttt where ttt.pers_ncorr=f.pers_ncorr) as region_ext,  "& vbCrLf &_
		   " (select top 1 dlp.dlpr_nombre_empresa from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as empresa, "& vbCrLf &_
           " (select top 1 dlp.dlpr_rubro_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as rubro, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_depto_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as depto, "& vbCrLf &_		   
		   " (select top 1 dlp.dlpr_cargo_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as cargo, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_email_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as email_laboral, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_web_empresa    from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as web, "& vbCrLf &_
		   " protic.ultima_modificacion_cpp(f.pers_ncorr,2) as usuario, "& vbCrLf &_
		   " protic.ultima_modificacion_cpp(f.pers_ncorr,1) as fecha_modificacion, "& vbCrLf &_
		   " (select case dae.tipo_contacto when 'P' then 'Particular' when 'C' then 'Comercial' else '' end from alumni_datos_adicionales_egresados dae where dae.pers_ncorr=f.pers_ncorr) as tipo_contacto, "& vbCrLf &_
		   " (select recibir_info from alumni_datos_adicionales_egresados dae where dae.pers_ncorr=f.pers_ncorr) as recibir_info "& vbCrLf &_
		   " from egresados_upa2 a (nolock),carreras c (nolock), "& vbCrLf &_
           " areas_academicas d, facultades e (nolock),personas f (nolock)  "& vbCrLf &_
           " where a.carr_ccod=c.carr_ccod "& vbCrLf &_
           " and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod and a.pers_ncorr=f.pers_ncorr "& vbCrLf &_
           " and a.ENTIDAD='U' and a.emat_ccod = 8 "& vbCrLf &_
           " and cast(a.sede_ccod as varchar)="&sede_ccod&" "& vbCrLf &_
           " and cast(isnull(a.sexo_ccod,1) as varchar)="&sexo_ccod&" "& vbCrLf &_ 
           " and e.facu_ccod = case when "&facu_ccod&" = 0 then e.facu_ccod else "&facu_ccod&" end "& vbCrLf &_
           " and c.carr_ccod = case when '"&carr_ccod&"' = '0' then c.carr_ccod else '"&carr_ccod&"' end "& vbCrLf &_
           " and not exists (select 1 from alumnos_salidas_carrera tt (nolock), salidas_carrera t2 (nolock) "& vbCrLf &_
           "                 where tt.saca_ncorr=t2.saca_ncorr "& vbCrLf &_
           "                 and tt.pers_ncorr=a.pers_ncorr and t2.carr_ccod=c.carr_ccod "& vbCrLf &_
           "                 and t2.tsca_ccod in (1,2,5)) order by nombre asc"
end if
if tipo = "PRG" then
	estado = "Graduados de Universidad"
	query= " select distinct cast(f.pers_nrut as varchar)+'-'+f.pers_xdv as rut, f.pers_tape_paterno + ' ' + f.pers_tape_materno + ', ' + f.pers_tnombre as nombre,"& vbCrLf &_
	       " (select sexo_tdesc from sexos ttt where ttt.sexo_ccod=f.sexo_ccod) as sexo, protic.trunc(f.pers_fnacimiento) as nacimiento,'"&institucion&"' as institu,   "& vbCrLf &_
		   " '"&sede_tdesc&"' as sede,  e.facu_tdesc as facultad, c.carr_tdesc as carrera, ' ' as especialidad, "& vbCrLf &_
		   " (select top 1 t4.jorn_tdesc  "& vbCrLf &_
           "         from alumnos tt (nolock), ofertas_academicas t2, especialidades t3, jornadas t4  "& vbCrLf &_
           "         where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod  "& vbCrLf &_
           "         and tt.emat_ccod <> 9 and tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
           "         and t3.carr_ccod=c.carr_ccod and t2.jorn_ccod=t4.jorn_ccod order by t2.peri_ccod desc) as jornada, "& vbCrLf &_
		   "  (select case count(*) when 0 then 'NO' else 'SI' end  "& vbCrLf &_
		   "  from detalles_titulacion_carrera ttt (nolock) "& vbCrLf &_
		   "  where ttt.pers_ncorr=a.pers_ncorr and ttt.carr_ccod=b.carr_ccod  "& vbCrLf &_
		   "  and ttt.plan_ccod=b.plan_ccod and isnull(protic.trunc(ttt.fecha_egreso),'')<>'' ) as egresado, "& vbCrLf &_
		   " (select top 1 protic.trunc(fecha_egreso)  "& vbCrLf &_
		   "  from detalles_titulacion_carrera ttt (nolock) "& vbCrLf &_
		   "  where ttt.pers_ncorr=a.pers_ncorr and ttt.carr_ccod=b.carr_ccod  "& vbCrLf &_
		   "  and ttt.plan_ccod=b.plan_ccod and isnull(protic.trunc(ttt.fecha_egreso),'')<>'' )  as fecha_egreso, "& vbCrLf &_
		   " (select case count(*) when 0 then 'NO' else 'SI' end  "& vbCrLf &_
		   "  from alumnos_salidas_carrera ttt (nolock), salidas_carrera tt2 "& vbCrLf &_
		   "  where ttt.pers_ncorr=a.pers_ncorr and ttt.saca_ncorr=tt2.saca_ncorr "& vbCrLf &_
		   "  and tt2.carr_ccod=b.carr_ccod and tt2.plan_ccod=b.plan_ccod)  as titulado, "& vbCrLf &_
		   " (select top 1 protic.trunc(ttt.ASCA_FSALIDA) "& vbCrLf &_
		   "  from alumnos_salidas_carrera ttt (nolock), salidas_carrera tt2 "& vbCrLf &_
	 	   "  where ttt.pers_ncorr=a.pers_ncorr and ttt.saca_ncorr=tt2.saca_ncorr "& vbCrLf &_
		   "  and tt2.carr_ccod=b.carr_ccod and tt2.plan_ccod=b.plan_ccod)  as fecha_titulo , "& vbCrLf &_
		   " case c.tcar_ccod when 1 then 'SI' else '' end as pregrado, case c.tcar_ccod when 2 then 'SI' else '' end as postgrado, "& vbCrLf &_
		   " protic.ano_ingreso_carrera_egresa2(f.pers_ncorr,c.carr_ccod) as ano_ingreso,   "& vbCrLf &_
		   " (select lower(ttt.pers_temail) from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as email,  "& vbCrLf &_
		   " (select pers_tfono from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as fono_p,  "& vbCrLf &_
		   " (select pers_tcelular from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as celular,  "& vbCrLf &_
		   " ' ' as facebook, ' ' as twitter, ' ' as lindkedin, (select pais_tdesc from paises ttt where ttt.pais_ccod=f.pais_ccod) as pais,    "& vbCrLf &_
		   " (select tt3.regi_tdesc from alumni_direcciones ttt, ciudades tt2, regiones tt3 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod and tt2.regi_ccod=tt3.regi_ccod) as region,  "& vbCrLf &_
           " (select tt2.ciud_tcomuna from alumni_direcciones ttt, ciudades tt2 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod) as ciudad,  "& vbCrLf &_
		   " (select tt2.ciud_tdesc from alumni_direcciones ttt, ciudades tt2 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod) as comuna,  "& vbCrLf &_
		   " (select ttt.dire_tcalle from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as calle,  "& vbCrLf &_
		   " (select ttt.dire_tnro from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as nro,  "& vbCrLf &_
		   " (select ttt.dire_tblock from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as depto,  "& vbCrLf &_
		   " (select ttt.dire_tpoblacion from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as condominio,  "& vbCrLf &_
		   " (select ttt.dire_tdepto from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as villa,  "& vbCrLf &_
		   " (select ttt.dire_tlocalidad from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as localidad,  "& vbCrLf &_
		   " (select ttt.ciud_particular from alumni_personas ttt where ttt.pers_ncorr=f.pers_ncorr) as ciudad_ext,  "& vbCrLf &_
		   " (select ttt.regi_particular from alumni_personas ttt where ttt.pers_ncorr=f.pers_ncorr) as region_ext,  "& vbCrLf &_
		   " (select top 1 dlp.dlpr_nombre_empresa from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as empresa, "& vbCrLf &_
           " (select top 1 dlp.dlpr_rubro_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as rubro, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_depto_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as depto, "& vbCrLf &_		   
		   " (select top 1 dlp.dlpr_cargo_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as cargo, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_email_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as email_laboral, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_web_empresa    from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as web, "& vbCrLf &_
		   " protic.ultima_modificacion_cpp(f.pers_ncorr,2) as usuario, "& vbCrLf &_
		   " protic.ultima_modificacion_cpp(f.pers_ncorr,1) as fecha_modificacion, "& vbCrLf &_
		   " (select case dae.tipo_contacto when 'P' then 'Particular' when 'C' then 'Comercial' else '' end from alumni_datos_adicionales_egresados dae where dae.pers_ncorr=f.pers_ncorr) as tipo_contacto, "& vbCrLf &_
		   " (select recibir_info from alumni_datos_adicionales_egresados dae where dae.pers_ncorr=f.pers_ncorr) as recibir_info "& vbCrLf &_
		   "     from alumnos_salidas_carrera a (nolock), salidas_carrera b (nolock), carreras c (nolock),  "& vbCrLf &_
           "          areas_academicas d, facultades e,personas f (nolock) "& vbCrLf &_
           "     where a.saca_ncorr = b.saca_ncorr and b.carr_ccod=c.carr_ccod "& vbCrLf &_
           "     and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod  "& vbCrLf &_
           "     and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (3) and c.tcar_ccod=1 "& vbCrLf &_
           "     and cast(a.sede_ccod as varchar)="&sede_ccod&" "& vbCrLf &_
           "     and e.facu_ccod = case when "&facu_ccod&" = 0 then e.facu_ccod else "&facu_ccod&" end "& vbCrLf &_
           "     and c.carr_ccod = case when '"&carr_ccod&"' = '0' then c.carr_ccod else '"&carr_ccod&"' end "& vbCrLf &_
           "     and cast(isnull(f.sexo_ccod,1) as varchar)="&sexo_ccod&" "& vbCrLf &_
           " union "& vbCrLf &_
           " select distinct cast(f.pers_nrut as varchar)+'-'+f.pers_xdv as rut, f.pers_tape_paterno + ' ' + f.pers_tape_materno + ', ' + f.pers_tnombre as nombre, "& vbCrLf &_
	       " (select sexo_tdesc from sexos ttt where ttt.sexo_ccod=f.sexo_ccod) as sexo, protic.trunc(f.pers_fnacimiento) as nacimiento,'"&institucion&"' as institu,   "& vbCrLf &_
		   " '"&sede_tdesc&"' as sede, e.facu_tdesc as facultad, c.carr_tdesc as carrera, ' ' as especialidad,  "& vbCrLf &_
		   " (select top 1 t4.jorn_tdesc  "& vbCrLf &_
           "         from alumnos tt (nolock), ofertas_academicas t2, especialidades t3, jornadas t4  "& vbCrLf &_
           "         where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod  "& vbCrLf &_
           "         and tt.emat_ccod <> 9 and tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
           "         and t3.carr_ccod=c.carr_ccod and t2.jorn_ccod=t4.jorn_ccod order by t2.peri_ccod desc) as jornada, "& vbCrLf &_
		   "   (select case count(*) when 0 then 'NO' else 'SI' end  "& vbCrLf &_
		   "  from detalles_titulacion_carrera ttt (nolock)  "& vbCrLf &_
		   "  where ttt.pers_ncorr=a.pers_ncorr and ttt.carr_ccod=b.carr_ccod  "& vbCrLf &_
		   "  and ttt.plan_ccod=b.plan_ccod and isnull(protic.trunc(ttt.fecha_egreso),'')<>'' ) as egresado, "& vbCrLf &_
		   " (select top 1 protic.trunc(fecha_egreso)  "& vbCrLf &_
		   "  from detalles_titulacion_carrera ttt (nolock) "& vbCrLf &_
		   "  where ttt.pers_ncorr=a.pers_ncorr and ttt.carr_ccod=b.carr_ccod  "& vbCrLf &_
		   "  and ttt.plan_ccod=b.plan_ccod and isnull(protic.trunc(ttt.fecha_egreso),'')<>'' )  as fecha_egreso, "& vbCrLf &_
		   " (select case count(*) when 0 then 'NO' else 'SI' end  "& vbCrLf &_
		   "  from alumnos_salidas_carrera ttt (nolock), salidas_carrera tt2 "& vbCrLf &_
		   "  where ttt.pers_ncorr=a.pers_ncorr and ttt.saca_ncorr=tt2.saca_ncorr "& vbCrLf &_
		   "  and tt2.carr_ccod=b.carr_ccod and tt2.plan_ccod=b.plan_ccod)  as titulado, "& vbCrLf &_
		   " (select top 1 protic.trunc(ttt.ASCA_FSALIDA) "& vbCrLf &_
		   "  from alumnos_salidas_carrera ttt (nolock), salidas_carrera tt2 "& vbCrLf &_
		   "  where ttt.pers_ncorr=a.pers_ncorr and ttt.saca_ncorr=tt2.saca_ncorr "& vbCrLf &_
		   "  and tt2.carr_ccod=b.carr_ccod and tt2.plan_ccod=b.plan_ccod)  as fecha_titulo, "& vbCrLf &_
		   "  case c.tcar_ccod when 1 then 'SI' else '' end as pregrado, case c.tcar_ccod when 2 then 'SI' else '' end as postgrado, "& vbCrLf &_
		   "  protic.ano_ingreso_carrera_egresa2(f.pers_ncorr,c.carr_ccod) as ano_ingreso,   "& vbCrLf &_
		   " (select lower(ttt.pers_temail) from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as email,  "& vbCrLf &_
		   " (select pers_tfono from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as fono_p,  "& vbCrLf &_
		   " (select pers_tcelular from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as celular,  "& vbCrLf &_
		   " ' ' as facebook, ' ' as twitter, ' ' as lindkedin, (select pais_tdesc from paises ttt where ttt.pais_ccod=f.pais_ccod) as pais,    "& vbCrLf &_
		   " (select tt3.regi_tdesc from alumni_direcciones ttt, ciudades tt2, regiones tt3 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod and tt2.regi_ccod=tt3.regi_ccod) as region,  "& vbCrLf &_
           " (select tt2.ciud_tcomuna from alumni_direcciones ttt, ciudades tt2 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod) as ciudad,  "& vbCrLf &_
		   " (select tt2.ciud_tdesc from alumni_direcciones ttt, ciudades tt2 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod) as comuna,  "& vbCrLf &_
		   " (select ttt.dire_tcalle from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as calle,  "& vbCrLf &_
		   " (select ttt.dire_tnro from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as nro,  "& vbCrLf &_
		   " (select ttt.dire_tblock from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as depto,  "& vbCrLf &_
		   " (select ttt.dire_tpoblacion from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as condominio,  "& vbCrLf &_
		   " (select ttt.dire_tdepto from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as villa,  "& vbCrLf &_
		   " (select ttt.dire_tlocalidad from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as localidad,  "& vbCrLf &_
		   " (select ttt.ciud_particular from alumni_personas ttt where ttt.pers_ncorr=f.pers_ncorr) as ciudad_ext,  "& vbCrLf &_
		   " (select ttt.regi_particular from alumni_personas ttt where ttt.pers_ncorr=f.pers_ncorr) as region_ext,  "& vbCrLf &_
		   " (select top 1 dlp.dlpr_nombre_empresa from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as empresa, "& vbCrLf &_
           " (select top 1 dlp.dlpr_rubro_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as rubro, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_depto_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as depto, "& vbCrLf &_		   
		   " (select top 1 dlp.dlpr_cargo_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as cargo, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_email_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as email_laboral, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_web_empresa    from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as web, "& vbCrLf &_
		   " protic.ultima_modificacion_cpp(f.pers_ncorr,2) as usuario, "& vbCrLf &_
		   " protic.ultima_modificacion_cpp(f.pers_ncorr,1) as fecha_modificacion, "& vbCrLf &_
		   " (select case dae.tipo_contacto when 'P' then 'Particular' when 'C' then 'Comercial' else '' end from alumni_datos_adicionales_egresados dae where dae.pers_ncorr=f.pers_ncorr) as tipo_contacto, "& vbCrLf &_
		   " (select recibir_info from alumni_datos_adicionales_egresados dae where dae.pers_ncorr=f.pers_ncorr) as recibir_info "& vbCrLf &_
		   "     from alumnos_salidas_carrera a (nolock), salidas_carrera b (nolock), carreras c (nolock),  "& vbCrLf &_
           "          areas_academicas d, facultades e,personas f (nolock), alumnos_salidas_intermedias g (nolock) "& vbCrLf &_
           "     where a.saca_ncorr = b.saca_ncorr and b.carr_ccod=c.carr_ccod "& vbCrLf &_
           "     and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod  "& vbCrLf &_
           "     and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (4) "& vbCrLf &_
           "     and a.saca_ncorr=g.saca_ncorr and a.pers_ncorr=g.pers_ncorr and g.emat_ccod in (8) "& vbCrLf &_
           "     and g.saca_ncorr in (756,764,774) "& vbCrLf &_
           "     and e.facu_ccod = case when "&facu_ccod&" = 0 then e.facu_ccod else "&facu_ccod&" end "& vbCrLf &_
           "     and c.carr_ccod = case when '"&carr_ccod&"' = '0' then c.carr_ccod else '"&carr_ccod&"' end "& vbCrLf &_
           "     and cast(a.sede_ccod as varchar)="&sede_ccod&" "& vbCrLf &_
           "     and cast(isnull(f.sexo_ccod,1) as varchar)="&sexo_ccod&" order by nombre asc"
end if
if tipo = "SIE" then
	estado = "Egresados de Salidas Intermedias"
	query= " select distinct cast(f.pers_nrut as varchar)+'-'+f.pers_xdv as rut, f.pers_tape_paterno + ' ' + f.pers_tape_materno + ', ' + f.pers_tnombre as nombre,"& vbCrLf &_
	       " (select sexo_tdesc from sexos ttt where ttt.sexo_ccod=f.sexo_ccod) as sexo, protic.trunc(f.pers_fnacimiento) as nacimiento,'"&institucion&"' as institu,   "& vbCrLf &_
		   " '"&sede_tdesc&"' as sede,  e.facu_tdesc as facultad, c.carr_tdesc as carrera, ' '  as especialidad,  "& vbCrLf &_
		   " (select top 1 t4.jorn_tdesc  "& vbCrLf &_
           "         from alumnos tt (nolock), ofertas_academicas t2, especialidades t3, jornadas t4  "& vbCrLf &_
           "         where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod  "& vbCrLf &_
           "         and tt.emat_ccod <> 9 and tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
           "         and t3.carr_ccod=c.carr_ccod and t2.jorn_ccod=t4.jorn_ccod order by t2.peri_ccod desc) as jornada, "& vbCrLf &_
		   " (select case count(*) when 0 then 'NO' else 'SI' end   "& vbCrLf &_
		   "  from alumnos_salidas_intermedias ttt (nolock)  "& vbCrLf &_
		   "  where ttt.pers_ncorr=a.pers_ncorr and ttt.saca_ncorr=b.saca_ncorr   "& vbCrLf &_
		   "  and ttt.emat_ccod = 4) as egresado,  "& vbCrLf &_
		   " (select top 1 protic.trunc(fecha_egreso)   "& vbCrLf &_
		   "  from detalles_titulacion_carrera ttt (nolock)  "& vbCrLf &_
		   "  where ttt.pers_ncorr = a.pers_ncorr and ttt.carr_ccod=b.carr_ccod   "& vbCrLf &_
		   "  and ttt.plan_ccod = a.saca_ncorr and isnull(protic.trunc(ttt.fecha_egreso),'')<>'' )  as fecha_egreso,  "& vbCrLf &_
		   " (select case count(*) when 0 then 'NO' else 'SI' end   "& vbCrLf &_
		   "  from alumnos_salidas_intermedias ttt (nolock)  "& vbCrLf &_
		   "  where ttt.pers_ncorr=a.pers_ncorr and ttt.saca_ncorr=b.saca_ncorr   "& vbCrLf &_
		   "  and ttt.emat_ccod = 8) as titulado,  "& vbCrLf &_
		   " (select top 1 protic.trunc(ttt.ASCA_FSALIDA)  "& vbCrLf &_
		   "  from alumnos_salidas_carrera ttt (nolock)  "& vbCrLf &_
		   "  where ttt.pers_ncorr=a.pers_ncorr and ttt.saca_ncorr=a.saca_ncorr  "& vbCrLf &_
		   " ) as fecha_titulado, "& vbCrLf &_
		   " case c.tcar_ccod when 1 then 'SI' else '' end as pregrado, case c.tcar_ccod when 2 then 'SI' else '' end as postgrado, "& vbCrLf &_
		   " protic.ano_ingreso_carrera_egresa2(f.pers_ncorr,c.carr_ccod) as ano_ingreso,    "& vbCrLf &_
		   " (select lower(ttt.pers_temail) from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as email,  "& vbCrLf &_
		   " (select pers_tfono from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as fono_p,  "& vbCrLf &_
		   " (select pers_tcelular from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as celular,  "& vbCrLf &_
		   " ' ' as facebook, ' ' as twitter, ' ' as lindkedin, (select pais_tdesc from paises ttt where ttt.pais_ccod=f.pais_ccod) as pais,    "& vbCrLf &_
		   " (select tt3.regi_tdesc from alumni_direcciones ttt, ciudades tt2, regiones tt3 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod and tt2.regi_ccod=tt3.regi_ccod) as region,  "& vbCrLf &_
           " (select tt2.ciud_tcomuna from alumni_direcciones ttt, ciudades tt2 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod) as ciudad,  "& vbCrLf &_
   		   " (select tt2.ciud_tdesc from alumni_direcciones ttt, ciudades tt2 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod) as comuna,  "& vbCrLf &_
		   " (select ttt.dire_tcalle from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as calle,  "& vbCrLf &_
		   " (select ttt.dire_tnro from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as nro,  "& vbCrLf &_
		   " (select ttt.dire_tblock from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as depto,  "& vbCrLf &_
		   " (select ttt.dire_tpoblacion from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as condominio,  "& vbCrLf &_
		   " (select ttt.dire_tdepto from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as villa,  "& vbCrLf &_
		   " (select ttt.dire_tlocalidad from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as localidad,  "& vbCrLf &_
		   " (select ttt.ciud_particular from alumni_personas ttt where ttt.pers_ncorr=f.pers_ncorr) as ciudad_ext,  "& vbCrLf &_
		   " (select ttt.regi_particular from alumni_personas ttt where ttt.pers_ncorr=f.pers_ncorr) as region_ext,  "& vbCrLf &_
		   " (select top 1 dlp.dlpr_nombre_empresa from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as empresa, "& vbCrLf &_
           " (select top 1 dlp.dlpr_rubro_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as rubro, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_depto_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as depto, "& vbCrLf &_		   
		   " (select top 1 dlp.dlpr_cargo_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as cargo, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_email_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as email_laboral, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_web_empresa    from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as web, "& vbCrLf &_
		   " protic.ultima_modificacion_cpp(f.pers_ncorr,2) as usuario, "& vbCrLf &_
		   " protic.ultima_modificacion_cpp(f.pers_ncorr,1) as fecha_modificacion, "& vbCrLf &_
		   " (select case dae.tipo_contacto when 'P' then 'Particular' when 'C' then 'Comercial' else '' end from alumni_datos_adicionales_egresados dae where dae.pers_ncorr=f.pers_ncorr) as tipo_contacto, "& vbCrLf &_
		   " (select recibir_info from alumni_datos_adicionales_egresados dae where dae.pers_ncorr=f.pers_ncorr) as recibir_info "& vbCrLf &_
		   " from alumnos_salidas_carrera a (nolock), salidas_carrera b (nolock), carreras c (nolock),  "& vbCrLf &_
           "      areas_academicas d, facultades e,personas f (nolock), alumnos_salidas_intermedias g (nolock) "& vbCrLf &_
           " where a.saca_ncorr = b.saca_ncorr and b.carr_ccod=c.carr_ccod "& vbCrLf &_
           " and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod  "& vbCrLf &_
           " and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (4) "& vbCrLf &_
           " and a.saca_ncorr=g.saca_ncorr and a.pers_ncorr=g.pers_ncorr and g.emat_ccod in (4,8) "& vbCrLf &_
           " and g.saca_ncorr not in (756,764,774) "& vbCrLf &_
           " and e.facu_ccod = case when "&facu_ccod&" = 0 then e.facu_ccod else "&facu_ccod&" end "& vbCrLf &_
           " and c.carr_ccod = case when '"&carr_ccod&"' = '0' then c.carr_ccod else '"&carr_ccod&"' end "& vbCrLf &_
           " and cast(a.sede_ccod as varchar)="&sede_ccod&" "& vbCrLf &_
           " and cast(isnull(f.sexo_ccod,1) as varchar)="&sexo_ccod&" order by nombre asc"
end if
if tipo = "SIT" then
	estado = "Titulados de Salidas Intermedias"
	query= "select distinct cast(f.pers_nrut as varchar)+'-'+f.pers_xdv as rut, f.pers_tape_paterno + ' ' + f.pers_tape_materno + ', ' + f.pers_tnombre as nombre,"& vbCrLf &_
	       " (select sexo_tdesc from sexos ttt where ttt.sexo_ccod=f.sexo_ccod) as sexo, protic.trunc(f.pers_fnacimiento) as nacimiento,'"&institucion&"' as institu,   "& vbCrLf &_
		   " '"&sede_tdesc&"' as sede, e.facu_tdesc as facultad, c.carr_tdesc as carrera, ' '  as especialidad,   "& vbCrLf &_
		   " (select top 1 t4.jorn_tdesc  "& vbCrLf &_
           "         from alumnos tt (nolock), ofertas_academicas t2, especialidades t3, jornadas t4  "& vbCrLf &_
           "         where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod  "& vbCrLf &_
           "         and tt.emat_ccod <> 9 and tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
           "         and t3.carr_ccod=c.carr_ccod and t2.jorn_ccod=t4.jorn_ccod order by t2.peri_ccod desc) as jornada, "& vbCrLf &_
		   " (select case count(*) when 0 then 'NO' else 'SI' end   "& vbCrLf &_
		   "  from alumnos_salidas_intermedias ttt (nolock)  "& vbCrLf &_
		   "  where ttt.pers_ncorr=a.pers_ncorr and ttt.saca_ncorr=b.saca_ncorr   "& vbCrLf &_
		   "  and ttt.emat_ccod = 4) as egresado,  "& vbCrLf &_
		   " (select top 1 protic.trunc(fecha_egreso)   "& vbCrLf &_
		   "  from detalles_titulacion_carrera ttt (nolock)  "& vbCrLf &_
		   "  where ttt.pers_ncorr = a.pers_ncorr and ttt.carr_ccod=b.carr_ccod   "& vbCrLf &_
		   "  and ttt.plan_ccod = a.saca_ncorr and isnull(protic.trunc(ttt.fecha_egreso),'')<>'' )  as fecha_egreso,  "& vbCrLf &_
		   " (select case count(*) when 0 then 'NO' else 'SI' end   "& vbCrLf &_
		   "  from alumnos_salidas_intermedias ttt (nolock)  "& vbCrLf &_
		   "  where ttt.pers_ncorr=a.pers_ncorr and ttt.saca_ncorr=b.saca_ncorr   "& vbCrLf &_
		   "  and ttt.emat_ccod = 8) as titulado,  "& vbCrLf &_
		   " (select top 1 protic.trunc(ttt.ASCA_FSALIDA)  "& vbCrLf &_
		   "  from alumnos_salidas_carrera ttt (nolock)  "& vbCrLf &_
		   "  where ttt.pers_ncorr=a.pers_ncorr and ttt.saca_ncorr=a.saca_ncorr  "& vbCrLf &_
		   " ) as fecha_titulado, "& vbCrLf &_
		   " case c.tcar_ccod when 1 then 'SI' else '' end as pregrado, case c.tcar_ccod when 2 then 'SI' else '' end as postgrado, "& vbCrLf &_
		   " protic.ano_ingreso_carrera_egresa2(f.pers_ncorr,c.carr_ccod) as ano_ingreso,   "& vbCrLf &_ 
		   " (select lower(ttt.pers_temail) from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as email,  "& vbCrLf &_
		   " (select pers_tfono from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as fono_p,  "& vbCrLf &_
		   " (select pers_tcelular from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as celular,  "& vbCrLf &_
		   " ' ' as facebook, ' ' as twitter, ' ' as lindkedin, (select pais_tdesc from paises ttt where ttt.pais_ccod=f.pais_ccod) as pais,    "& vbCrLf &_
		   " (select tt3.regi_tdesc from alumni_direcciones ttt, ciudades tt2, regiones tt3 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod and tt2.regi_ccod=tt3.regi_ccod) as region,  "& vbCrLf &_
           " (select tt2.ciud_tcomuna from alumni_direcciones ttt, ciudades tt2 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod) as ciudad,  "& vbCrLf &_
		   " (select tt2.ciud_tdesc from alumni_direcciones ttt, ciudades tt2 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod) as comuna,  "& vbCrLf &_
		   " (select ttt.dire_tcalle from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as calle,  "& vbCrLf &_
		   " (select ttt.dire_tnro from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as nro,  "& vbCrLf &_
		   " (select ttt.dire_tblock from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as depto,  "& vbCrLf &_
		   " (select ttt.dire_tpoblacion from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as condominio,  "& vbCrLf &_
		   " (select ttt.dire_tdepto from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as villa,  "& vbCrLf &_
		   " (select ttt.dire_tlocalidad from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as localidad,  "& vbCrLf &_
		   " (select ttt.ciud_particular from alumni_personas ttt where ttt.pers_ncorr=f.pers_ncorr) as ciudad_ext,  "& vbCrLf &_
		   " (select ttt.regi_particular from alumni_personas ttt where ttt.pers_ncorr=f.pers_ncorr) as region_ext,  "& vbCrLf &_
		   " (select top 1 dlp.dlpr_nombre_empresa from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as empresa, "& vbCrLf &_
           " (select top 1 dlp.dlpr_rubro_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as rubro, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_depto_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as depto, "& vbCrLf &_		   
		   " (select top 1 dlp.dlpr_cargo_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as cargo, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_email_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as email_laboral, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_web_empresa    from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as web, "& vbCrLf &_
		   " protic.ultima_modificacion_cpp(f.pers_ncorr,2) as usuario, "& vbCrLf &_
		   " protic.ultima_modificacion_cpp(f.pers_ncorr,1) as fecha_modificacion, "& vbCrLf &_
		   " (select case dae.tipo_contacto when 'P' then 'Particular' when 'C' then 'Comercial' else '' end from alumni_datos_adicionales_egresados dae where dae.pers_ncorr=f.pers_ncorr) as tipo_contacto, "& vbCrLf &_
		   " (select recibir_info from alumni_datos_adicionales_egresados dae where dae.pers_ncorr=f.pers_ncorr) as recibir_info "& vbCrLf &_
		   " from alumnos_salidas_carrera a (nolock), salidas_carrera b (nolock), carreras c (nolock),  "& vbCrLf &_
           "      areas_academicas d, facultades e,personas f (nolock), alumnos_salidas_intermedias g (nolock) "& vbCrLf &_
           " where a.saca_ncorr = b.saca_ncorr and b.carr_ccod=c.carr_ccod "& vbCrLf &_
           " and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod  "& vbCrLf &_
           " and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (4) "& vbCrLf &_
           " and a.saca_ncorr=g.saca_ncorr and a.pers_ncorr=g.pers_ncorr and g.emat_ccod in (8) "& vbCrLf &_
           " and g.saca_ncorr not in (756,764,774) "& vbCrLf &_
           " and e.facu_ccod = case when "&facu_ccod&" = 0 then e.facu_ccod else "&facu_ccod&" end "& vbCrLf &_
           " and c.carr_ccod = case when '"&carr_ccod&"' = '0' then c.carr_ccod else '"&carr_ccod&"' end "& vbCrLf &_
           " and cast(a.sede_ccod as varchar)="&sede_ccod&" "& vbCrLf &_
           " and cast(isnull(f.sexo_ccod,1) as varchar)="&sexo_ccod&" order by nombre asc"
end if
if tipo = "IEG" then
	estado = "Egresados de Instituto"
	institucion = "INSTITUTO"
	insti		= "I"
	query ="select distinct cast(f.pers_nrut as varchar)+'-'+f.pers_xdv as rut, f.pers_tape_paterno + ' ' + f.pers_tape_materno + ', ' + f.pers_tnombre as nombre,"& vbCrLf &_
	       " (select sexo_tdesc from sexos ttt where ttt.sexo_ccod=f.sexo_ccod) as sexo, protic.trunc(f.pers_fnacimiento) as nacimiento,'"&institucion&"' as institu,   "& vbCrLf &_
		   " '"&sede_tdesc&"' as sede,  e.facu_tdesc as facultad, c.carr_tdesc as carrera, ' '  as especialidad, "& vbCrLf &_
		   " (select jorn_tdesc from jornadas ttt where ttt.jorn_ccod=a.jorn_ccod) as jornada,    "& vbCrLf &_
		   "    (select case count(*) when 0 then 'NO' else 'SI' end  "& vbCrLf &_
		   "     from egresados_upa2 ttt where ttt.pers_ncorr=a.pers_ncorr and ttt.carr_ccod=a.carr_ccod  "& vbCrLf &_
		   "     and a.entidad='I' and a.emat_ccod=4) as egresado, "& vbCrLf &_
		   "    '' as fecha_egreso, "& vbCrLf &_
		   "    (select case count(*) when 0 then 'NO' else 'SI' end "& vbCrLf &_
		   "     from egresados_upa2 ttt where ttt.pers_ncorr=a.pers_ncorr and ttt.carr_ccod=a.carr_ccod "& vbCrLf &_
		   "     and a.entidad='I' and a.emat_ccod=4) as titulado, "& vbCrLf &_
		   "    '' as fecha_titulo, "& vbCrLf &_
		   " case c.tcar_ccod when 1 then 'SI' else '' end as pregrado, case c.tcar_ccod when 2 then 'SI' else '' end as postgrado, "& vbCrLf &_
		   " protic.ano_ingreso_carrera_egresa2(f.pers_ncorr,c.carr_ccod) as ano_ingreso,   "& vbCrLf &_
		   " (select lower(ttt.pers_temail) from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as email,  "& vbCrLf &_
		   " (select pers_tfono from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as fono_p,  "& vbCrLf &_
		   " (select pers_tcelular from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as celular,  "& vbCrLf &_
		   " ' ' as facebook, ' ' as twitter, ' ' as lindkedin, (select pais_tdesc from paises ttt where ttt.pais_ccod=f.pais_ccod) as pais,    "& vbCrLf &_
		   " (select tt3.regi_tdesc from alumni_direcciones ttt, ciudades tt2, regiones tt3 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod and tt2.regi_ccod=tt3.regi_ccod) as region,  "& vbCrLf &_
           " (select tt2.ciud_tcomuna from alumni_direcciones ttt, ciudades tt2 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod) as ciudad,  "& vbCrLf &_
		   " (select tt2.ciud_tdesc from alumni_direcciones ttt, ciudades tt2 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod) as comuna,  "& vbCrLf &_
		   " (select ttt.dire_tcalle from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as calle,  "& vbCrLf &_
		   " (select ttt.dire_tnro from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as nro,  "& vbCrLf &_
		   " (select ttt.dire_tblock from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as depto,  "& vbCrLf &_
		   " (select ttt.dire_tpoblacion from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as condominio,  "& vbCrLf &_
		   " (select ttt.dire_tdepto from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as villa,  "& vbCrLf &_
		   " (select ttt.dire_tlocalidad from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as localidad,  "& vbCrLf &_
		   " (select ttt.ciud_particular from alumni_personas ttt where ttt.pers_ncorr=f.pers_ncorr) as ciudad_ext,  "& vbCrLf &_
		   " (select ttt.regi_particular from alumni_personas ttt where ttt.pers_ncorr=f.pers_ncorr) as region_ext,  "& vbCrLf &_
		   " (select top 1 dlp.dlpr_nombre_empresa from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as empresa, "& vbCrLf &_
           " (select top 1 dlp.dlpr_rubro_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as rubro, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_depto_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as depto, "& vbCrLf &_		   
		   " (select top 1 dlp.dlpr_cargo_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as cargo, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_email_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as email_laboral, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_web_empresa    from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as web, "& vbCrLf &_
		   " protic.ultima_modificacion_cpp(f.pers_ncorr,2) as usuario, "& vbCrLf &_
		   " protic.ultima_modificacion_cpp(f.pers_ncorr,1) as fecha_modificacion, "& vbCrLf &_
		   " (select case dae.tipo_contacto when 'P' then 'Particular' when 'C' then 'Comercial' else '' end from alumni_datos_adicionales_egresados dae where dae.pers_ncorr=f.pers_ncorr) as tipo_contacto, "& vbCrLf &_
		   " (select recibir_info from alumni_datos_adicionales_egresados dae where dae.pers_ncorr=f.pers_ncorr) as recibir_info "& vbCrLf &_
		   " from egresados_upa2 a (nolock),carreras c (nolock), "& vbCrLf &_
           "     areas_academicas d, facultades e,personas f (nolock) "& vbCrLf &_
           " where a.carr_ccod=c.carr_ccod "& vbCrLf &_
           "     and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod  and a.pers_ncorr=f.pers_ncorr "& vbCrLf &_
           "     and a.ENTIDAD='I' and a.emat_ccod in (4) "& vbCrLf &_
           "     and cast(a.sede_ccod as varchar) = "&sede_ccod&" "& vbCrLf &_
           "     and cast(isnull(a.sexo_ccod,1) as varchar)= "&sexo_ccod&" "& vbCrLf &_
           "     and e.facu_ccod = case when "&facu_ccod&" = 0 then e.facu_ccod else "&facu_ccod&" end "& vbCrLf &_
           "     and c.carr_ccod = case when '"&carr_ccod&"' = '0' then c.carr_ccod else '"&carr_ccod&"' end "& vbCrLf &_
           "     and not exists (select 1 from detalles_titulacion_carrera tt (nolock) "& vbCrLf &_
           "                     where tt.pers_ncorr=a.pers_ncorr and tt.carr_ccod=c.carr_ccod "& vbCrLf &_
           "                     and isnull(protic.trunc(tt.fecha_egreso),'') <> '') order by nombre asc"
end if
if tipo = "ITI" then
	estado = "Titulados de Instituto"
	institucion = "INSTITUTO"
	insti		= "I"
	query= " select distinct cast(f.pers_nrut as varchar)+'-'+f.pers_xdv as rut, f.pers_tape_paterno + ' ' + f.pers_tape_materno + ', ' + f.pers_tnombre as nombre,"& vbCrLf &_
	       " (select sexo_tdesc from sexos ttt where ttt.sexo_ccod=f.sexo_ccod) as sexo, protic.trunc(f.pers_fnacimiento) as nacimiento,'"&institucion&"' as institu,   "& vbCrLf &_
		   " '"&sede_tdesc&"' as sede,  e.facu_tdesc as facultad, c.carr_tdesc as carrera, ' '  as especialidad, "& vbCrLf &_
		   " (select jorn_tdesc from jornadas ttt where ttt.jorn_ccod=a.jorn_ccod) as jornada,    "& vbCrLf &_
		   "    (select case count(*) when 0 then 'NO' else 'SI' end  "& vbCrLf &_
		   "     from egresados_upa2 ttt where ttt.pers_ncorr=a.pers_ncorr and ttt.carr_ccod=a.carr_ccod  "& vbCrLf &_
		   "     and a.entidad='I' and a.emat_ccod=4) as egresado, "& vbCrLf &_
		   "    '' as fecha_egreso, "& vbCrLf &_
		   "    (select case count(*) when 0 then 'NO' else 'SI' end "& vbCrLf &_
		   "     from egresados_upa2 ttt where ttt.pers_ncorr=a.pers_ncorr and ttt.carr_ccod=a.carr_ccod "& vbCrLf &_
		   "     and a.entidad='I' and a.emat_ccod=4) as titulado, "& vbCrLf &_
		   "    '' as fecha_titulo, "& vbCrLf &_
		   " case c.tcar_ccod when 1 then 'SI' else '' end as pregrado, case c.tcar_ccod when 2 then 'SI' else '' end as postgrado, "& vbCrLf &_
		   " protic.ano_ingreso_carrera_egresa2(f.pers_ncorr,c.carr_ccod) as ano_ingreso,    "& vbCrLf &_
		   " (select lower(ttt.pers_temail) from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as email,  "& vbCrLf &_
		   " (select pers_tfono from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as fono_p,  "& vbCrLf &_
		   " (select pers_tcelular from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as celular,  "& vbCrLf &_
		   " ' ' as facebook, ' ' as twitter, ' ' as lindkedin, (select pais_tdesc from paises ttt where ttt.pais_ccod=f.pais_ccod) as pais,    "& vbCrLf &_
		   " (select tt3.regi_tdesc from alumni_direcciones ttt, ciudades tt2, regiones tt3 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod and tt2.regi_ccod=tt3.regi_ccod) as region,  "& vbCrLf &_
           " (select tt2.ciud_tcomuna from alumni_direcciones ttt, ciudades tt2 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod) as ciudad,  "& vbCrLf &_
		   " (select tt2.ciud_tdesc from alumni_direcciones ttt, ciudades tt2 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod) as comuna,  "& vbCrLf &_
		   " (select ttt.dire_tcalle from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as calle,  "& vbCrLf &_
		   " (select ttt.dire_tnro from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as nro,  "& vbCrLf &_
		   " (select ttt.dire_tblock from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as depto,  "& vbCrLf &_
		   " (select ttt.dire_tpoblacion from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as condominio,  "& vbCrLf &_
		   " (select ttt.dire_tdepto from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as villa,  "& vbCrLf &_
		   " (select ttt.dire_tlocalidad from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as localidad,  "& vbCrLf &_
		   " (select ttt.ciud_particular from alumni_personas ttt where ttt.pers_ncorr=f.pers_ncorr) as ciudad_ext,  "& vbCrLf &_
		   " (select ttt.regi_particular from alumni_personas ttt where ttt.pers_ncorr=f.pers_ncorr) as region_ext,  "& vbCrLf &_
		   " (select top 1 dlp.dlpr_nombre_empresa from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as empresa, "& vbCrLf &_
           " (select top 1 dlp.dlpr_rubro_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as rubro, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_depto_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as depto, "& vbCrLf &_		   
		   " (select top 1 dlp.dlpr_cargo_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as cargo, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_email_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as email_laboral, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_web_empresa    from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as web, "& vbCrLf &_
		   " protic.ultima_modificacion_cpp(f.pers_ncorr,2) as usuario, "& vbCrLf &_
		   " protic.ultima_modificacion_cpp(f.pers_ncorr,1) as fecha_modificacion, "& vbCrLf &_
		   " (select case dae.tipo_contacto when 'P' then 'Particular' when 'C' then 'Comercial' else '' end from alumni_datos_adicionales_egresados dae where dae.pers_ncorr=f.pers_ncorr) as tipo_contacto, "& vbCrLf &_
		   " (select recibir_info from alumni_datos_adicionales_egresados dae where dae.pers_ncorr=f.pers_ncorr) as recibir_info "& vbCrLf &_
		   " from egresados_upa2 a (nolock),carreras c (nolock), "& vbCrLf &_
           " areas_academicas d, facultades e (nolock),personas f (nolock)  "& vbCrLf &_
           " where a.carr_ccod=c.carr_ccod "& vbCrLf &_
           " and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod and a.pers_ncorr=f.pers_ncorr "& vbCrLf &_
           " and a.ENTIDAD='I' and a.emat_ccod = 8 "& vbCrLf &_
           " and cast(a.sede_ccod as varchar)="&sede_ccod&" "& vbCrLf &_
           " and cast(isnull(a.sexo_ccod,1) as varchar)="&sexo_ccod&"  "& vbCrLf &_
           " and e.facu_ccod = case when "&facu_ccod&" = 0 then e.facu_ccod else "&facu_ccod&" end "& vbCrLf &_
           " and c.carr_ccod = case when '"&carr_ccod&"' = '0' then c.carr_ccod else '"&carr_ccod&"' end "& vbCrLf &_
           " and not exists (select 1 from alumnos_salidas_carrera tt (nolock), salidas_carrera t2 (nolock) "& vbCrLf &_
           "                 where tt.saca_ncorr=t2.saca_ncorr "& vbCrLf &_
           "                 and tt.pers_ncorr=a.pers_ncorr and t2.carr_ccod=c.carr_ccod "& vbCrLf &_
           "                 and t2.tsca_ccod in (1,2,5)) order by nombre asc"
end if
if tipo = "POG" then
	estado = "Graduados de Universidad"
	categoria = "POSTGRADO"
	query= " select distinct cast(f.pers_nrut as varchar)+'-'+f.pers_xdv as rut, f.pers_tape_paterno + ' ' + f.pers_tape_materno + ', ' + f.pers_tnombre as nombre,"& vbCrLf &_
	       " (select sexo_tdesc from sexos ttt where ttt.sexo_ccod=f.sexo_ccod) as sexo, protic.trunc(f.pers_fnacimiento) as nacimiento,'"&institucion&"' as institu,   "& vbCrLf &_
		   " '"&sede_tdesc&"' as sede, e.facu_tdesc as facultad, c.carr_tdesc as carrera, ' '  as especialidad,  "& vbCrLf &_
		   " (select top 1 t4.jorn_tdesc  "& vbCrLf &_
           "         from alumnos tt (nolock), ofertas_academicas t2, especialidades t3, jornadas t4  "& vbCrLf &_
           "         where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod  "& vbCrLf &_
           "         and tt.emat_ccod <> 9 and tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
           "         and t3.carr_ccod=c.carr_ccod and t2.jorn_ccod=t4.jorn_ccod order by t2.peri_ccod desc) as jornada, "& vbCrLf &_
		   " (select case count(*) when 0 then 'NO' else 'SI' end   "& vbCrLf &_
 		   " from detalles_titulacion_carrera ttt (nolock)  "& vbCrLf &_
		   " where ttt.pers_ncorr=a.pers_ncorr and ttt.carr_ccod=b.carr_ccod   "& vbCrLf &_
		   " and ttt.plan_ccod=b.plan_ccod and isnull(protic.trunc(ttt.fecha_egreso),'')<>'' )  as egresado, "& vbCrLf &_
		   " (select top 1 protic.trunc(fecha_egreso)  "& vbCrLf &_
		   "  from detalles_titulacion_carrera ttt (nolock) "& vbCrLf &_
		   "  where ttt.pers_ncorr=a.pers_ncorr and ttt.carr_ccod=b.carr_ccod  "& vbCrLf &_
		   "  and ttt.plan_ccod=b.plan_ccod and isnull(protic.trunc(ttt.fecha_egreso),'')<>'' )  as fecha_egreso, "& vbCrLf &_
		   " (select case count(*) when 0 then 'NO' else 'SI' end  "& vbCrLf &_
		   "  from alumnos_salidas_carrera ttt (nolock), salidas_carrera tt2 "& vbCrLf &_
		   "  where ttt.pers_ncorr=a.pers_ncorr and ttt.saca_ncorr=tt2.saca_ncorr "& vbCrLf &_
		   "  and tt2.carr_ccod=b.carr_ccod and tt2.plan_ccod=b.plan_ccod)  as titulado, "& vbCrLf &_
		   " (select top 1 protic.trunc(ttt.ASCA_FSALIDA) "& vbCrLf &_
		   "  from alumnos_salidas_carrera ttt (nolock), salidas_carrera tt2 "& vbCrLf &_
	 	   "  where ttt.pers_ncorr=a.pers_ncorr and ttt.saca_ncorr=tt2.saca_ncorr "& vbCrLf &_
		   "  and tt2.carr_ccod=b.carr_ccod and tt2.plan_ccod=b.plan_ccod)  as fecha_titulo , "& vbCrLf &_
		   " case c.tcar_ccod when 1 then 'SI' else '' end as pregrado, case c.tcar_ccod when 2 then 'SI' else '' end as postgrado, "& vbCrLf &_
		   " protic.ano_ingreso_carrera_egresa2(f.pers_ncorr,c.carr_ccod) as ano_ingreso,   "& vbCrLf &_
		   " (select lower(ttt.pers_temail) from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as email,  "& vbCrLf &_
		   " (select pers_tfono from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as fono_p,  "& vbCrLf &_
		   " (select pers_tcelular from alumni_personas ttt (nolock) where ttt.pers_ncorr=f.pers_ncorr) as celular,  "& vbCrLf &_
		   " ' ' as facebook, ' ' as twitter, ' ' as lindkedin, (select pais_tdesc from paises ttt where ttt.pais_ccod=f.pais_ccod) as pais,    "& vbCrLf &_
		   " (select tt3.regi_tdesc from alumni_direcciones ttt, ciudades tt2, regiones tt3 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod and tt2.regi_ccod=tt3.regi_ccod) as region,  "& vbCrLf &_
           " (select tt2.ciud_tcomuna from alumni_direcciones ttt, ciudades tt2 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod) as ciudad,  "& vbCrLf &_
		   " (select tt2.ciud_tdesc from alumni_direcciones ttt, ciudades tt2 where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr and ttt.ciud_ccod=tt2.ciud_ccod) as comuna,  "& vbCrLf &_
		   " (select ttt.dire_tcalle from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as calle,  "& vbCrLf &_
		   " (select ttt.dire_tnro from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as nro,  "& vbCrLf &_
		   " (select ttt.dire_tblock from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as depto,  "& vbCrLf &_
		   " (select ttt.dire_tpoblacion from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as condominio,  "& vbCrLf &_
		   " (select ttt.dire_tdepto from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as villa,  "& vbCrLf &_
		   " (select ttt.dire_tlocalidad from alumni_direcciones ttt where ttt.tdir_ccod=2 and ttt.pers_ncorr=f.pers_ncorr) as localidad,  "& vbCrLf &_
		   " (select ttt.ciud_particular from alumni_personas ttt where ttt.pers_ncorr=f.pers_ncorr) as ciudad_ext,  "& vbCrLf &_
		   " (select ttt.regi_particular from alumni_personas ttt where ttt.pers_ncorr=f.pers_ncorr) as region_ext,  "& vbCrLf &_
		   " (select top 1 dlp.dlpr_nombre_empresa from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as empresa, "& vbCrLf &_
           " (select top 1 dlp.dlpr_rubro_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as rubro, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_depto_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as depto, "& vbCrLf &_		   
		   " (select top 1 dlp.dlpr_cargo_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as cargo, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_email_empresa  from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as email_laboral, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_web_empresa    from alumni_direccion_laboral_profesionales dlp (nolock) where dlp.pers_ncorr = f.pers_ncorr order by dlp.audi_fmodificacion desc) as web, "& vbCrLf &_
		   " protic.ultima_modificacion_cpp(f.pers_ncorr,2) as usuario, "& vbCrLf &_
		   " protic.ultima_modificacion_cpp(f.pers_ncorr,1) as fecha_modificacion, "& vbCrLf &_
		   " (select case dae.tipo_contacto when 'P' then 'Particular' when 'C' then 'Comercial' else '' end from alumni_datos_adicionales_egresados dae where dae.pers_ncorr=f.pers_ncorr) as tipo_contacto, "& vbCrLf &_
		   " (select recibir_info from alumni_datos_adicionales_egresados dae where dae.pers_ncorr=f.pers_ncorr) as recibir_info "& vbCrLf &_
		   "     from alumnos_salidas_carrera a (nolock), salidas_carrera b (nolock), carreras c (nolock),  "& vbCrLf &_
           "          areas_academicas d, facultades e,personas f (nolock) "& vbCrLf &_
           "     where a.saca_ncorr = b.saca_ncorr and b.carr_ccod=c.carr_ccod "& vbCrLf &_
           "     and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod  "& vbCrLf &_
           "     and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (3) and c.tcar_ccod=2 "& vbCrLf &_
           "     and e.facu_ccod = case when "&facu_ccod&" = 0 then e.facu_ccod else "&facu_ccod&" end "& vbCrLf &_
           "     and c.carr_ccod = case when '"&carr_ccod&"' = '0' then c.carr_ccod else '"&carr_ccod&"' end "& vbCrLf &_
           "     and cast(a.sede_ccod as varchar)="&sede_ccod&" "& vbCrLf &_
           "     and cast(isnull(f.sexo_ccod,1) as varchar)="&sexo_ccod&" order by nombre asc"
end if

'response.Write("<pre>"&query&"</pre>")
f_personas.Consultar query

%>
<html>
<head>
<title>ESTADÍSTICAS EGRESADOS, TITULADOS Y GRADUADOS</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
  <tr> 
    <td colspan="3"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">ESTADÍSTICAS EGRESADOS, TITULADOS Y GRADUADOS</font></div></td>
  </tr>
  <tr> 
    <td colspan="3">&nbsp;</td>
  </tr>
</table>
<p>&nbsp;</p>
<table width="100%" border="0">
   					<tr>
						<td width="3%"><strong>Categoría</strong></td>
						<td width="20%" align="left"><strong>:</strong><%=categoria%></td>
						<td width="77%" colspan="44" align="left">&nbsp;</td>
					</tr>
					<tr>
						<td width="3%"><strong>Institución</strong></td>
						<td width="20%" align="left"><strong>:</strong><%=institucion%></td>
						<td colspan="44" align="left">&nbsp;</td>
					</tr>
					<tr>
						<td width="3%"><strong>Sede</strong></td>
						<td width="20%" align="left"><strong>:</strong><%=sede_tdesc%></td>
						<td colspan="44" align="left">&nbsp;</td>
					</tr>
					<tr>
						<td width="3%"><strong>Carrera</strong></td>
						<td width="20%" align="left"><strong>:</strong><%=carr_tdesc%></td>
						<td colspan="44" align="left">&nbsp;</td>
					</tr>
					<tr>
						<td width="3%"><strong>Facultad</strong></td>
						<td width="20%" align="left"><strong>:</strong><%=facu_tdesc%></td>
						<td colspan="44" align="left">&nbsp;</td>
					</tr>
					<tr>
						<td width="3%"><strong>Estado</strong></td>
						<td width="20%" align="left"><strong>:</strong><%=estado%></td>
						<td colspan="44" align="left">&nbsp;</td>
					</tr>
					<tr>
						<td width="3%"><strong>Género</strong></td>
						<td width="20%" align="left"><strong>:</strong><%=sexo_tdesc%></td>
						<td colspan="44" align="left">&nbsp;</td>
					</tr>
					<tr>
						<td width="3%"><strong>Fecha</strong></td>
						<td width="20%" align="left"><strong>:</strong><%=fecha%></td>
						<td colspan="44" align="left">&nbsp;</td>
					</tr>
					<tr><td colspan="46">&nbsp;</td></tr>
					<tr><td colspan="46">&nbsp;</td></tr>
					<tr>
						<td colspan="46" align="center">
							<table width="90%" cellpadding="0" cellspacing="1" border="1" bordercolor="#333333">
								<tr>
									<td align="center" bgcolor="#FF9900"><strong>FILA</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>RUT</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>NOMBRE</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>SEXO</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>FECHA NAC.</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>INSTITUCION</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>SEDE</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>FACULTAD</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>CARRERA</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>ESPECIALIDAD</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>JORNADA</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>EGRESADO</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>FECHA EGRESO</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>TITULADO</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>FECHA TITULO</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>PREGRADO</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>POSTGRADO</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>AÑO INGRESO</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>EMAIL</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>TELÉFONO PERSONAL</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>CELULAR</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>FACEBOOK</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>TWITTER</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>LINDKEDIN</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>PAIS</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>REGION</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>CIUDAD</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>COMUNA</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>CALLE</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>NÚMERO</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>DEPTO</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>CONDOMINIO</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>VILLA</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>LOCALIDAD</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>CIUDAD EXTRANJERO</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>REGIÓN EXTRANJERO</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>EMPRESA</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>RUBRO</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>DEPARTAMENTO</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>CARGO</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>EMAIL LABORAL</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>WEB_EMPRESA</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>QUIEN MODIFICA</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>FECHA MOD.</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>TIPO DE CONTACTO</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>RECIBIR INFO.</strong></td>
								</tr>
								<%fila = 1
								  while f_personas.siguiente%>
								<tr>
									<td align="left"><%=fila%></td>
									<td align="left"><%=f_personas.obtenerValor("rut")%></td>
									<td align="left"><%=f_personas.obtenerValor("nombre")%></td>
									<td align="left"><%=f_personas.obtenerValor("sexo")%></td>
									<td align="left"><%=f_personas.obtenerValor("nacimiento")%></td>
									<td align="left"><%=f_personas.obtenerValor("institu")%></td>
									<td align="left"><%=f_personas.obtenerValor("sede")%></td>
									<td align="left"><%=f_personas.obtenerValor("facultad")%></td>
									<td align="left"><%=f_personas.obtenerValor("carrera")%></td>
									<td align="left"><%=f_personas.obtenerValor("especialidad")%></td>
									<td align="left"><%=f_personas.obtenerValor("jornada")%></td>
									<td align="left"><%=f_personas.obtenerValor("egresado")%></td>
									<td align="left"><%=f_personas.obtenerValor("fecha_egreso")%></td>
									<td align="left"><%=f_personas.obtenerValor("titulado")%></td>
									<td align="left"><%=f_personas.obtenerValor("fecha_titulo")%></td>
									<td align="left"><%=f_personas.obtenerValor("pregrado")%></td>
									<td align="left"><%=f_personas.obtenerValor("postgrado")%></td>
									<td align="center"><%=f_personas.obtenerValor("ano_ingreso")%></td>
									<td align="left"><%=f_personas.obtenerValor("email")%></td>
									<td align="left"><%=f_personas.obtenerValor("fono_p")%></td>
									<td align="left"><%=f_personas.obtenerValor("celular")%></td>
									<td align="left"><%=f_personas.obtenerValor("facebook")%></td>
									<td align="left"><%=f_personas.obtenerValor("twitter")%></td>
									<td align="left"><%=f_personas.obtenerValor("lindkedin")%></td>
									<td align="left"><%=f_personas.obtenerValor("pais")%></td>
									<td align="left"><%=f_personas.obtenerValor("region")%></td>
									<td align="left"><%=f_personas.obtenerValor("ciudad")%></td>
									<td align="left"><%=f_personas.obtenerValor("comuna")%></td>
									<td align="left"><%=f_personas.obtenerValor("calle")%></td>
									<td align="left"><%=f_personas.obtenerValor("nro")%></td>
									<td align="left"><%=f_personas.obtenerValor("depto")%></td>
									<td align="left"><%=f_personas.obtenerValor("condominio")%></td>
									<td align="left"><%=f_personas.obtenerValor("villa")%></td>
									<td align="left"><%=f_personas.obtenerValor("localidad")%></td>
									<td align="left"><%=f_personas.obtenerValor("ciudad_ext")%></td>
									<td align="left"><%=f_personas.obtenerValor("region_ext")%></td>
									<td align="left"><%=f_personas.obtenerValor("empresa")%></td>
									<td align="left"><%=f_personas.obtenerValor("rubro")%></td>
									<td align="left"><%=f_personas.obtenerValor("depto")%></td>
									<td align="left"><%=f_personas.obtenerValor("cargo")%></td>
									<td align="left"><%=f_personas.obtenerValor("email_laboral")%></td>
									<td align="left"><%=f_personas.obtenerValor("web")%></td>
									<td align="left"><%=f_personas.obtenerValor("usuario")%></td>
									<td align="left"><%=f_personas.obtenerValor("fecha_modificacion")%></td>
									<td align="left"><%=f_personas.obtenerValor("tipo_contacto")%></td>
									<td align="left"><%=f_personas.obtenerValor("recibir_info")%></td>
								</tr>
								<%fila = fila + 1
								   wend%>
							</table>
						</td>
					</tr>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>