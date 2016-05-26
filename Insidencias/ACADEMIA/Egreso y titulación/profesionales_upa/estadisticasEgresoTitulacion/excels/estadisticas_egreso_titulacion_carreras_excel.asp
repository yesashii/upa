<!-- #include file = "../../../biblioteca/_conexion.asp" -->
<!-- #include file = "../../../biblioteca/_negocio.asp" -->
<!-- #include file = "../dlls/dll_1.asp" -->
<%
Response.AddHeader "Content-Disposition", "attachment;filename=estadisticas_egreso_titulacion.xls"
Response.ContentType = "application/vnd.ms-excel"
set pagina = new CPagina
'-------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------

'***************************'
'** CAPTURA VARIABLES GET **'
'***************************'--------------------------	
sede_ccod 	= request.QueryString("sede_ccod")
tipo      	= request.QueryString("tipo")
sexo_ccod 	= request.QueryString("sexo_ccod")
institucion	= request.QueryString("institucion")
facu_ccod	= request.QueryString("facu_ccod")
carr_ccod   = request.QueryString("carr_ccod")
sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede_ccod&"'")
carr_tdesc = conexion.consultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar)='"&carr_ccod&"'")
consultaFecha = "select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha"
fecha_a_mostrar=conexion.consultaUno(consultaFecha)

upa_pregrado  	=  request.QueryString("upa_pregrado")
upa_postgrado 	=  request.QueryString("upa_postgrado")
instituto     	=  request.QueryString("instituto")
egresados  	  	=  request.QueryString("egresados")
titulados     	=  request.QueryString("titulados")
graduados     	=  request.QueryString("graduados")
salidas_int   	=  request.QueryString("salidas_int")
femenino 	  	=  request.QueryString("femenino")
masculino 	  	=  request.QueryString("masculino")
'------------------------------------------------------------------>>>>>>>>>>>>>>>>Arreglo de sexo
if sexo_ccod = 1 then 
masculino 	= "1"
femenino 	= "0"
end if
if sexo_ccod = 2 then 
masculino 	= "0"
femenino 	= "1"
end if
if sexo_ccod = 3 then 
masculino 	= "1"
femenino 	= "1"
end if
'------------------------------------------------------------------<<<<<<<<<<<<<<<<Arreglo de sexo
SexTextMascu 	= "M"
SexTextFeme 	= "F"
SexTextFM		= "total"
'---------------------------------------------------o
selectAnioPromo = request.QueryString("selectAnioPromo")
selectAnioTitu  = request.QueryString("selectAnioTitu")
selectAnioEgre  = request.QueryString("selectAnioEgre")
'DEBUG---------------------------------->>	
	'response.write("sede_ccod = "&sede_ccod)        &response.write("<br>")
	'response.write("tipo = "&tipo)                  &response.write("<br>")
	'response.write("sexo_ccod = "&sexo_ccod)        &response.write("<br>")
	'response.write("institucion = "&institucion)    &response.write("<br>")
	'response.write("facu_ccod = "&facu_ccod)        &response.write("<br>")
	'response.write("sede_tdesc = "&sede_tdesc)      &response.write("<br>")
	'response.write("carr_ccod = "&carr_ccod)        &response.write("<br>")
	'response.write("carr_tdesc = "&carr_tdesc)      &response.write("<br>")
'DEBUG----------------------------------<<
'PARA EL ENVÍO---------------------------------------------------------------------->>
E_sede_ccod 	= sede_ccod	
E_tipo      	= tipo	
E_sexo_ccod 	= sexo_ccod
E_institucion	= institucion
E_facu_ccod		= facu_ccod
E_carr_ccod   	= carr_ccod
E_sede_tdesc 	= sede_tdesc
E_carr_tdesc 	= carr_tdesc
'PARA EL ENVÍO----------------------------------------------------------------------<<

'---------------------------------------------------------------------------------filtro facultades y carreras
	if carr_ccod<>"0" then
		filtro_carreras = "and cast(c.carr_ccod as varchar)='"&carr_ccod&"'"
	else
		filtro_carreras=""
	end if	
	
	if facu_ccod<>"0" then
		filtro_facultad = "and cast(d.facu_ccod as varchar)='"&facu_ccod&"'"
	else
		filtro_facultad=""
	end if	
'---------------------------------------------------------------------------------filtro facultades y carreras
'--------------------------------------------------------------------------------->>filtro carreras
if institucion <> "I" then
	if tipo ="POG" then
		filtro_carreras = filtro_carreras&" and cast(c.tcar_ccod as varchar) ='2'"
	else
		filtro_facultad= filtro_facultad&" and cast(c.tcar_ccod as varchar) ='1'"
	end if	
end if	
'---------------------------------------------------------------------------------<<filtro carreras	
'------------------------------------------------------------------------------------------------------->>>>>>>PARA EL TOTAL
set f_lista_2 = new CFormulario
f_lista_2.Carga_Parametros "tabla_vacia.xml", "tabla"
f_lista_2.Inicializar conexion
consulta =  "select distinct sum(protic.estadistica_titulados_v2013("&sede_ccod&",1,'U','UEG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'))					as suma_egresados_U_hombres  "& vbCrLf &_
							",sum(protic.estadistica_titulados_v2013("&sede_ccod&",2,'U','UEG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'))				as suma_egresados_U_mujeres  "& vbCrLf &_
							",sum(protic.estadistica_titulados_v2013("&sede_ccod&",1,'U','UTI',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'))				as suma_titulados_U_hombres  "& vbCrLf &_
							",sum(protic.estadistica_titulados_v2013("&sede_ccod&",2,'U','UTI',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'))				as suma_titulados_U_mujeres   "& vbCrLf &_
							",sum(protic.estadistica_titulados_v2013("&sede_ccod&",1,'U','PRG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'))				as suma_graduados_PR_hombres  "& vbCrLf &_
							",sum(protic.estadistica_titulados_v2013("&sede_ccod&",2,'U','PRG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'))				as suma_graduados_PR_mujeres  "& vbCrLf &_
							",sum(protic.estadistica_titulados_v2013("&sede_ccod&",1,'U','SIE',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'))				as suma_SIE_hombres  "& vbCrLf &_
							",sum(protic.estadistica_titulados_v2013("&sede_ccod&",2,'U','SIE',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'))				as suma_SIE_mujeres  "& vbCrLf &_
							",sum(protic.estadistica_titulados_v2013("&sede_ccod&",1,'U','SIT',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'))				as suma_SIT_hombres  "& vbCrLf &_
							",sum(protic.estadistica_titulados_v2013("&sede_ccod&",2,'U','SIT',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'))				as suma_SIT_mujeres  "& vbCrLf &_
							",sum(isnull(protic.estadistica_titulados_v2013("&sede_ccod&",1,'I','IEG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'),0))		as suma_egresados_I_hombres  "& vbCrLf &_
							",sum(isnull(protic.estadistica_titulados_v2013("&sede_ccod&",2,'I','IEG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'),0))		as suma_egresados_I_mujeres  "& vbCrLf &_
							",sum(isnull(protic.estadistica_titulados_v2013("&sede_ccod&",1,'I','ITI',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'),0))		as suma_titulados_I_hombres  "& vbCrLf &_
							",sum(isnull(protic.estadistica_titulados_v2013("&sede_ccod&",2,'I','ITI',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'),0))		as suma_titulados_I_mujeres  "& vbCrLf &_
							",sum(protic.estadistica_titulados_v2013("&sede_ccod&",1,'U','POG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'))				as suma_graduados_PO_hombres "& vbCrLf &_
							",sum(protic.estadistica_titulados_v2013("&sede_ccod&",2,'U','POG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'))				as suma_graduados_PO_mujeres "& vbCrLf &_
            "FROM  "& vbCrLf &_
			"( "& vbCrLf &_
            "select distinct e.facu_ccod,c.carr_ccod,c.carr_tdesc  "& vbCrLf &_
			"            from alumnos_salidas_carrera a (nolock),   "& vbCrLf &_
			"            salidas_carrera b (nolock), carreras c (nolock),   "& vbCrLf &_
			"            areas_academicas d, facultades e,personas f (nolock)  "& vbCrLf &_
			"            where a.saca_ncorr = b.saca_ncorr and b.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"            and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"            and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (1,2,5)  "& vbCrLf &_
			"            and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "&filtro_carreras&filtro_facultad& vbCrLf &_
			"union  "& vbCrLf &_
			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc  "& vbCrLf &_
			"            from egresados_upa2 a (nolock),carreras c (nolock),  "& vbCrLf &_
			"            areas_academicas d, facultades e (nolock)   "& vbCrLf &_
			"            where a.carr_ccod=c.carr_ccod collate SQL_Latin1_General_CP1_CI_AS "& vbCrLf &_
			"            and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"            and a.ENTIDAD='U' and a.emat_ccod = 8  "& vbCrLf &_
			"            and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "& vbCrLf &_
			"            and not exists (select 1   "& vbCrLf &_
			"                            from alumnos_salidas_carrera tt (nolock),  "& vbCrLf &_
			"                            salidas_carrera t2 (nolock)  "& vbCrLf &_
			"                            where tt.saca_ncorr=t2.saca_ncorr  "& vbCrLf &_
			"                            and tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
			"                            and t2.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"                            and t2.tsca_ccod in (1,2,5))     "&filtro_carreras&filtro_facultad& vbCrLf &_
			"union  "& vbCrLf &_
			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc  "& vbCrLf &_
			"                from detalles_titulacion_carrera a (nolock), carreras c,   "& vbCrLf &_
			"                     areas_academicas d, facultades e,personas f (nolock)  "& vbCrLf &_
			"                where a.carr_ccod=c.carr_ccod collate SQL_Latin1_General_CP1_CI_AS "& vbCrLf &_
			"                and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"                and a.pers_ncorr=f.pers_ncorr   "& vbCrLf &_
			"                and isnull(protic.trunc(a.fecha_egreso),'') <> ''  "& vbCrLf &_
			"                and (select top 1 t2.sede_ccod  "& vbCrLf &_
			"                     from alumnos tt (nolock),   "& vbCrLf &_
			"                     ofertas_academicas t2, especialidades t3  "& vbCrLf &_
			"                     where tt.ofer_ncorr=t2.ofer_ncorr   "& vbCrLf &_
			"                     and t2.espe_ccod=t3.espe_ccod  "& vbCrLf &_
			"                     and tt.emat_ccod <> 9   "& vbCrLf &_
			"                     and tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
			"                     and t3.carr_ccod=c.carr_ccod   "& vbCrLf &_
			"                     order by t2.peri_ccod desc) = '"&sede_ccod&"'  "& vbCrLf &_
			"                and not exists (select 1 from salidas_carrera tt   "& vbCrLf &_
			"                                where tt.carr_ccod=a.carr_ccod   "& vbCrLf &_
			"                                and tt.saca_ncorr=a.plan_ccod   "& vbCrLf &_
			"                                and tt.tsca_ccod = 4)  "&filtro_carreras&filtro_facultad& vbCrLf &_
			"union  "& vbCrLf &_
			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc  "& vbCrLf &_
			"                from egresados_upa2 a (nolock),carreras c (nolock),  "& vbCrLf &_
			"                areas_academicas d, facultades e  "& vbCrLf &_
			"                where a.carr_ccod=c.carr_ccod collate SQL_Latin1_General_CP1_CI_AS "& vbCrLf &_
			"                and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"                and a.ENTIDAD='U' and a.emat_ccod in (4,8)  "& vbCrLf &_
			"                and cast(a.sede_ccod as varchar) = '"&sede_ccod&"'  "& vbCrLf &_
			"                and not exists (select 1   "& vbCrLf &_
			"                                from detalles_titulacion_carrera tt(nolock)  "& vbCrLf &_
			"                                where tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
			"                                and tt.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"                                and isnull(protic.trunc(tt.fecha_egreso),'') <> '')  "&filtro_carreras&filtro_facultad& vbCrLf &_
			"union  "& vbCrLf &_
			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc  "& vbCrLf &_
			"                from alumnos_salidas_carrera a (nolock),   "& vbCrLf &_
			"                salidas_carrera b (nolock), carreras c (nolock),   "& vbCrLf &_
			"                areas_academicas d, facultades e,personas f (nolock)  "& vbCrLf &_
			"                where a.saca_ncorr = b.saca_ncorr   "& vbCrLf &_
			"                and b.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"                and c.area_ccod=d.area_ccod   "& vbCrLf &_
			"                and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"                and a.pers_ncorr=f.pers_ncorr   "& vbCrLf &_
			"                and b.tsca_ccod in (3) and c.tcar_ccod=1  "& vbCrLf &_
			"                and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "&filtro_carreras&filtro_facultad& vbCrLf &_
			"union  "& vbCrLf &_
			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc  "& vbCrLf &_
			"                from alumnos_salidas_carrera a (nolock),   "& vbCrLf &_
			"                salidas_carrera b (nolock), carreras c (nolock),   "& vbCrLf &_
			"                areas_academicas d, facultades e,personas f (nolock),  "& vbCrLf &_
			"                alumnos_salidas_intermedias g (nolock)  "& vbCrLf &_
			"                where a.saca_ncorr = b.saca_ncorr   "& vbCrLf &_
			"                and b.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"                and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"                and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (4)  "& vbCrLf &_
			"                and a.saca_ncorr=g.saca_ncorr   "& vbCrLf &_
			"                and a.pers_ncorr=g.pers_ncorr and g.emat_ccod in (8)  "& vbCrLf &_
			"                and g.saca_ncorr in (756,764,774)  "& vbCrLf &_
			"                and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "&filtro_carreras&filtro_facultad& vbCrLf &_
			"union  "& vbCrLf &_
			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc   "& vbCrLf &_
			"            from alumnos_salidas_carrera a (nolock),   "& vbCrLf &_
			"            salidas_carrera b (nolock), carreras c (nolock),   "& vbCrLf &_
			"            areas_academicas d, facultades e,personas f (nolock),  "& vbCrLf &_
			"            alumnos_salidas_intermedias g (nolock)  "& vbCrLf &_
			"            where a.saca_ncorr = b.saca_ncorr and b.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"            and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"            and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (4)  "& vbCrLf &_
			"            and a.saca_ncorr=g.saca_ncorr and a.pers_ncorr=g.pers_ncorr  "& vbCrLf &_
			"            and g.emat_ccod in (4,8)  "& vbCrLf &_
			"            and g.saca_ncorr not in (756,764,774)  "& vbCrLf &_
			"            and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "&filtro_carreras&filtro_facultad& vbCrLf &_
			"union  "& vbCrLf &_
			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc   "& vbCrLf &_
			"            from alumnos_salidas_carrera a (nolock),   "& vbCrLf &_
			"            salidas_carrera b (nolock), carreras c (nolock),   "& vbCrLf &_
			"            areas_academicas d, facultades e,personas f (nolock),  "& vbCrLf &_
			"            alumnos_salidas_intermedias g (nolock)  "& vbCrLf &_
			"            where a.saca_ncorr = b.saca_ncorr and b.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"            and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"            and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (4)  "& vbCrLf &_
			"            and a.saca_ncorr=g.saca_ncorr   "& vbCrLf &_
			"            and a.pers_ncorr=g.pers_ncorr and g.emat_ccod in (8)  "& vbCrLf &_
			"            and g.saca_ncorr not in (756,764,774)  "& vbCrLf &_
			"            and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "&filtro_carreras&filtro_facultad& vbCrLf &_
			"union  "& vbCrLf &_
			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc   "& vbCrLf &_
			"            from egresados_upa2 a (nolock),carreras c (nolock),  "& vbCrLf &_
			"            areas_academicas d, facultades e  "& vbCrLf &_
			"            where a.carr_ccod=c.carr_ccod collate SQL_Latin1_General_CP1_CI_AS "& vbCrLf &_
			"                and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"                and a.ENTIDAD='I' and a.emat_ccod in (4,8)  "& vbCrLf &_
			"                and cast(a.sede_ccod as varchar) = '"&sede_ccod&"'  "& vbCrLf &_
			"                and not exists (select 1   "& vbCrLf &_
			"                                from detalles_titulacion_carrera tt (nolock)  "& vbCrLf &_
			"                                where tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
			"                                and tt.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"                                and isnull(protic.trunc(tt.fecha_egreso),'') <> '')  "&filtro_carreras&filtro_facultad& vbCrLf &_
			"union  "& vbCrLf &_
			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc   "& vbCrLf &_
			"            from egresados_upa2 a (nolock),carreras c (nolock),  "& vbCrLf &_
			"            areas_academicas d, facultades e (nolock)   "& vbCrLf &_
			"            where a.carr_ccod=c.carr_ccod collate SQL_Latin1_General_CP1_CI_AS "& vbCrLf &_
			"            and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"            and a.ENTIDAD='I' and a.emat_ccod = 8  "& vbCrLf &_
			"            and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "& vbCrLf &_
			"            and not exists (select 1   "& vbCrLf &_
			"                            from alumnos_salidas_carrera tt (nolock),  "& vbCrLf &_
			"                            salidas_carrera t2 (nolock)  "& vbCrLf &_
			"                            where tt.saca_ncorr=t2.saca_ncorr  "& vbCrLf &_
			"                            and tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
			"                            and t2.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"                            and t2.tsca_ccod in (1,2,5))  "&filtro_carreras&filtro_facultad& vbCrLf &_
			"union  "& vbCrLf &_
			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc   "& vbCrLf &_
			"                from alumnos_salidas_carrera a (nolock),   "& vbCrLf &_
			"                salidas_carrera b (nolock), carreras c (nolock),   "& vbCrLf &_
			"                areas_academicas d, facultades e,personas f (nolock)  "& vbCrLf &_
			"                where a.saca_ncorr = b.saca_ncorr   "& vbCrLf &_
			"                and b.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"                and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"                and a.pers_ncorr=f.pers_ncorr   "& vbCrLf &_
			"                and b.tsca_ccod in (3) and c.tcar_ccod=2  "& vbCrLf &_
			"                and cast(a.sede_ccod as varchar)='"&sede_ccod&"'"&filtro_carreras&filtro_facultad& vbCrLf &_
			" ) ttr "
'--------------------------------------------------------------------o|>Debug			
'response.write("<pre>"&consulta&"</pre>")	
'response.end()
'--------------------------------------------------------------------o<|Debug
f_lista_2.Consultar consulta 
f_lista_2.Siguiente

suma_egresados_U_hombres	=  f_lista_2.ObtenerValor("suma_egresados_U_hombres")
suma_egresados_U_mujeres    =  f_lista_2.ObtenerValor("suma_egresados_U_mujeres")
suma_titulados_U_hombres    =  f_lista_2.ObtenerValor("suma_titulados_U_hombres")
suma_titulados_U_mujeres    =  f_lista_2.ObtenerValor("suma_titulados_U_mujeres")
suma_graduados_PR_hombres   =  f_lista_2.ObtenerValor("suma_graduados_PR_hombres")
suma_graduados_PR_mujeres   =  f_lista_2.ObtenerValor("suma_graduados_PR_mujeres")
suma_SIE_hombres            =  f_lista_2.ObtenerValor("suma_SIE_hombres")
suma_SIE_mujeres            =  f_lista_2.ObtenerValor("suma_SIE_mujeres")
suma_SIT_hombres            =  f_lista_2.ObtenerValor("suma_SIT_hombres")
suma_SIT_mujeres            =  f_lista_2.ObtenerValor("suma_SIT_mujeres")
suma_egresados_I_hombres    =  f_lista_2.ObtenerValor("suma_egresados_I_hombres")
suma_egresados_I_mujeres    =  f_lista_2.ObtenerValor("suma_egresados_I_mujeres")
suma_titulados_I_hombres    =  f_lista_2.ObtenerValor("suma_titulados_I_hombres")
suma_titulados_I_mujeres    =  f_lista_2.ObtenerValor("suma_titulados_I_mujeres")
suma_graduados_PO_hombres   =  f_lista_2.ObtenerValor("suma_graduados_PO_hombres")
suma_graduados_PO_mujeres   =  f_lista_2.ObtenerValor("suma_graduados_PO_mujeres")
suma_graduados_PO_mujeresYhombres    	=  cInt(suma_graduados_PO_hombres) + cInt(suma_graduados_PO_mujeres)
suma_egresados_U_mujeresYhombres    	=  cInt(suma_egresados_U_hombres) + cInt(suma_egresados_U_mujeres)
suma_titulados_U_mujeresYhombres    	=  cInt(suma_titulados_U_hombres) + cInt(suma_titulados_U_mujeres)
suma_graduados_PR_mujeresYhombres    	=  cInt(suma_graduados_PR_hombres) + cInt(suma_graduados_PR_mujeres)
suma_SIE_mujeresYhombres    			=  cInt(suma_SIE_hombres) + cInt(suma_SIE_mujeres)
suma_SIT_mujeresYhombres    			=  cInt(suma_SIT_hombres) + cInt(suma_SIT_mujeres)
suma_egresados_I_mujeresYhombres    	=  cInt(suma_egresados_I_hombres) + cInt(suma_egresados_I_mujeres)
suma_titulados_I_mujeresYhombres   	 	=  cInt(suma_titulados_I_hombres) + cInt(suma_titulados_I_mujeres)
'-------------------------------------------------------------------------------------------------------<<<<<<<PARA EL TOTAL



set botonera = new CFormulario
botonera.Carga_Parametros "estadisticas_egreso_titulacion.xml", "botonera"
set f_lista = new CFormulario
f_lista.Carga_Parametros "tabla_vacia.xml", "tabla"
f_lista.Inicializar conexion
consulta =  "select distinct facu_ccod,carr_ccod, carr_tdesc  "& vbCrLf &_
			",protic.estadistica_titulados_v2013("&sede_ccod&",1,'U','UEG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"') 			as egresados_U_hombres  "& vbCrLf &_
			",protic.estadistica_titulados_v2013("&sede_ccod&",2,'U','UEG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"') 			as egresados_U_mujeres  "& vbCrLf &_
			",protic.estadistica_titulados_v2013("&sede_ccod&",1,'U','UTI',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"') 			as titulados_U_hombres  "& vbCrLf &_
			",protic.estadistica_titulados_v2013("&sede_ccod&",2,'U','UTI',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"') 			as titulados_U_mujeres   "& vbCrLf &_
			",protic.estadistica_titulados_v2013("&sede_ccod&",1,'U','PRG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"') 			as graduados_PR_hombres  "& vbCrLf &_
			",protic.estadistica_titulados_v2013("&sede_ccod&",2,'U','PRG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"') 			as graduados_PR_mujeres  "& vbCrLf &_
			",protic.estadistica_titulados_v2013("&sede_ccod&",1,'U','SIE',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"') 			as SIE_hombres  "& vbCrLf &_
			",protic.estadistica_titulados_v2013("&sede_ccod&",2,'U','SIE',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"') 			as SIE_mujeres  "& vbCrLf &_
			",protic.estadistica_titulados_v2013("&sede_ccod&",1,'U','SIT',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"') 			as SIT_hombres  "& vbCrLf &_
			",protic.estadistica_titulados_v2013("&sede_ccod&",2,'U','SIT',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"') 			as SIT_mujeres  "& vbCrLf &_
			",isnull(protic.estadistica_titulados_v2013("&sede_ccod&",1,'I','IEG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'),0) 	as egresados_I_hombres  "& vbCrLf &_
			",isnull(protic.estadistica_titulados_v2013("&sede_ccod&",2,'I','IEG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'),0) 	as egresados_I_mujeres  "& vbCrLf &_
			",isnull(protic.estadistica_titulados_v2013("&sede_ccod&",1,'I','ITI',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'),0) 	as titulados_I_hombres  "& vbCrLf &_
			",isnull(protic.estadistica_titulados_v2013("&sede_ccod&",2,'I','ITI',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"'),0) 	as titulados_I_mujeres  "& vbCrLf &_
			",protic.estadistica_titulados_v2013("&sede_ccod&",1,'U','POG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"') 			as graduados_PO_hombres "& vbCrLf &_
			",protic.estadistica_titulados_v2013("&sede_ccod&",2,'U','POG',facu_ccod,carr_ccod,'"&selectAnioPromo&"','"&selectAnioEgre&"','"&selectAnioTitu&"') 			as graduados_PO_mujeres "& vbCrLf &_
            "FROM  "& vbCrLf &_
			"( "& vbCrLf &_
            "select distinct e.facu_ccod,c.carr_ccod,c.carr_tdesc  "& vbCrLf &_
			"            from alumnos_salidas_carrera a (nolock),   "& vbCrLf &_
			"            salidas_carrera b (nolock), carreras c (nolock),   "& vbCrLf &_
			"            areas_academicas d, facultades e,personas f (nolock)  "& vbCrLf &_
			"            where a.saca_ncorr = b.saca_ncorr and b.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"            and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"            and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (1,2,5)  "& vbCrLf &_
			"            and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "&filtro_carreras&filtro_facultad& vbCrLf &_
			"union  "& vbCrLf &_
			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc  "& vbCrLf &_
			"            from egresados_upa2 a (nolock),carreras c (nolock),  "& vbCrLf &_
			"            areas_academicas d, facultades e (nolock)   "& vbCrLf &_
			"            where a.carr_ccod=c.carr_ccod collate SQL_Latin1_General_CP1_CI_AS "& vbCrLf &_
			"            and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"            and a.ENTIDAD='U' and a.emat_ccod = 8  "& vbCrLf &_
			"            and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "& vbCrLf &_
			"            and not exists (select 1   "& vbCrLf &_
			"                            from alumnos_salidas_carrera tt (nolock),  "& vbCrLf &_
			"                            salidas_carrera t2 (nolock)  "& vbCrLf &_
			"                            where tt.saca_ncorr=t2.saca_ncorr  "& vbCrLf &_
			"                            and tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
			"                            and t2.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"                            and t2.tsca_ccod in (1,2,5))     "&filtro_carreras&filtro_facultad& vbCrLf &_
			"union  "& vbCrLf &_
			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc  "& vbCrLf &_
			"                from detalles_titulacion_carrera a (nolock), carreras c,   "& vbCrLf &_
			"                     areas_academicas d, facultades e,personas f (nolock)  "& vbCrLf &_
			"                where a.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"                and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"                and a.pers_ncorr=f.pers_ncorr   "& vbCrLf &_
			"                and isnull(protic.trunc(a.fecha_egreso),'') <> ''  "& vbCrLf &_
			"                and (select top 1 t2.sede_ccod  "& vbCrLf &_
			"                     from alumnos tt (nolock),   "& vbCrLf &_
			"                     ofertas_academicas t2, especialidades t3  "& vbCrLf &_
			"                     where tt.ofer_ncorr=t2.ofer_ncorr   "& vbCrLf &_
			"                     and t2.espe_ccod=t3.espe_ccod  "& vbCrLf &_
			"                     and tt.emat_ccod <> 9   "& vbCrLf &_
			"                     and tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
			"                     and t3.carr_ccod=c.carr_ccod   "& vbCrLf &_
			"                     order by t2.peri_ccod desc) = '"&sede_ccod&"'  "& vbCrLf &_
			"                and not exists (select 1 from salidas_carrera tt   "& vbCrLf &_
			"                                where tt.carr_ccod=a.carr_ccod   "& vbCrLf &_
			"                                and tt.saca_ncorr=a.plan_ccod   "& vbCrLf &_
			"                                and tt.tsca_ccod = 4)  "&filtro_carreras&filtro_facultad& vbCrLf &_
			"union  "& vbCrLf &_
			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc  "& vbCrLf &_
			"                from egresados_upa2 a (nolock),carreras c (nolock),  "& vbCrLf &_
			"                areas_academicas d, facultades e  "& vbCrLf &_
			"                where a.carr_ccod=c.carr_ccod collate SQL_Latin1_General_CP1_CI_AS  "& vbCrLf &_
			"                and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"                and a.ENTIDAD='U' and a.emat_ccod in (4,8)  "& vbCrLf &_
			"                and cast(a.sede_ccod as varchar) = '"&sede_ccod&"'  "& vbCrLf &_
			"                and not exists (select 1   "& vbCrLf &_
			"                                from detalles_titulacion_carrera tt(nolock)  "& vbCrLf &_
			"                                where tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
			"                                and tt.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"                                and isnull(protic.trunc(tt.fecha_egreso),'') <> '')  "&filtro_carreras&filtro_facultad& vbCrLf &_
			"union  "& vbCrLf &_
			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc  "& vbCrLf &_
			"                from alumnos_salidas_carrera a (nolock),   "& vbCrLf &_
			"                salidas_carrera b (nolock), carreras c (nolock),   "& vbCrLf &_
			"                areas_academicas d, facultades e,personas f (nolock)  "& vbCrLf &_
			"                where a.saca_ncorr = b.saca_ncorr   "& vbCrLf &_
			"                and b.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"                and c.area_ccod=d.area_ccod   "& vbCrLf &_
			"                and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"                and a.pers_ncorr=f.pers_ncorr   "& vbCrLf &_
			"                and b.tsca_ccod in (3) and c.tcar_ccod=1  "& vbCrLf &_
			"                and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "&filtro_carreras&filtro_facultad& vbCrLf &_
			"union  "& vbCrLf &_
			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc  "& vbCrLf &_
			"                from alumnos_salidas_carrera a (nolock),   "& vbCrLf &_
			"                salidas_carrera b (nolock), carreras c (nolock),   "& vbCrLf &_
			"                areas_academicas d, facultades e,personas f (nolock),  "& vbCrLf &_
			"                alumnos_salidas_intermedias g (nolock)  "& vbCrLf &_
			"                where a.saca_ncorr = b.saca_ncorr   "& vbCrLf &_
			"                and b.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"                and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"                and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (4)  "& vbCrLf &_
			"                and a.saca_ncorr=g.saca_ncorr   "& vbCrLf &_
			"                and a.pers_ncorr=g.pers_ncorr and g.emat_ccod in (8)  "& vbCrLf &_
			"                and g.saca_ncorr in (756,764,774)  "& vbCrLf &_
			"                and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "&filtro_carreras&filtro_facultad& vbCrLf &_
			"union  "& vbCrLf &_
			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc   "& vbCrLf &_
			"            from alumnos_salidas_carrera a (nolock),   "& vbCrLf &_
			"            salidas_carrera b (nolock), carreras c (nolock),   "& vbCrLf &_
			"            areas_academicas d, facultades e,personas f (nolock),  "& vbCrLf &_
			"            alumnos_salidas_intermedias g (nolock)  "& vbCrLf &_
			"            where a.saca_ncorr = b.saca_ncorr and b.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"            and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"            and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (4)  "& vbCrLf &_
			"            and a.saca_ncorr=g.saca_ncorr and a.pers_ncorr=g.pers_ncorr  "& vbCrLf &_
			"            and g.emat_ccod in (4,8)  "& vbCrLf &_
			"            and g.saca_ncorr not in (756,764,774)  "& vbCrLf &_
			"            and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "&filtro_carreras&filtro_facultad& vbCrLf &_
			"union  "& vbCrLf &_
			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc   "& vbCrLf &_
			"            from alumnos_salidas_carrera a (nolock),   "& vbCrLf &_
			"            salidas_carrera b (nolock), carreras c (nolock),   "& vbCrLf &_
			"            areas_academicas d, facultades e,personas f (nolock),  "& vbCrLf &_
			"            alumnos_salidas_intermedias g (nolock)  "& vbCrLf &_
			"            where a.saca_ncorr = b.saca_ncorr and b.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"            and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"            and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (4)  "& vbCrLf &_
			"            and a.saca_ncorr=g.saca_ncorr   "& vbCrLf &_
			"            and a.pers_ncorr=g.pers_ncorr and g.emat_ccod in (8)  "& vbCrLf &_
			"            and g.saca_ncorr not in (756,764,774)  "& vbCrLf &_
			"            and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "&filtro_carreras&filtro_facultad& vbCrLf &_
			"union  "& vbCrLf &_
			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc   "& vbCrLf &_
			"            from egresados_upa2 a (nolock),carreras c (nolock),  "& vbCrLf &_
			"            areas_academicas d, facultades e  "& vbCrLf &_
			"            where a.carr_ccod=c.carr_ccod collate SQL_Latin1_General_CP1_CI_AS "& vbCrLf &_
			"                and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"                and a.ENTIDAD='I' and a.emat_ccod in (4,8)  "& vbCrLf &_
			"                and cast(a.sede_ccod as varchar) = '"&sede_ccod&"'  "& vbCrLf &_
			"                and not exists (select 1   "& vbCrLf &_
			"                                from detalles_titulacion_carrera tt (nolock)  "& vbCrLf &_
			"                                where tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
			"                                and tt.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"                                and isnull(protic.trunc(tt.fecha_egreso),'') <> '')  "&filtro_carreras&filtro_facultad& vbCrLf &_
			"union  "& vbCrLf &_
			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc   "& vbCrLf &_
			"            from egresados_upa2 a (nolock),carreras c (nolock),  "& vbCrLf &_
			"            areas_academicas d, facultades e (nolock)   "& vbCrLf &_
			"            where a.carr_ccod=c.carr_ccod  collate SQL_Latin1_General_CP1_CI_AS"& vbCrLf &_
			"            and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"            and a.ENTIDAD='I' and a.emat_ccod = 8  "& vbCrLf &_
			"            and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "& vbCrLf &_
			"            and not exists (select 1   "& vbCrLf &_
			"                            from alumnos_salidas_carrera tt (nolock),  "& vbCrLf &_
			"                            salidas_carrera t2 (nolock)  "& vbCrLf &_
			"                            where tt.saca_ncorr=t2.saca_ncorr  "& vbCrLf &_
			"                            and tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
			"                            and t2.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"                            and t2.tsca_ccod in (1,2,5))  "&filtro_carreras&filtro_facultad& vbCrLf &_
			"union  "& vbCrLf &_
			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc   "& vbCrLf &_
			"                from alumnos_salidas_carrera a (nolock),   "& vbCrLf &_
			"                salidas_carrera b (nolock), carreras c (nolock),   "& vbCrLf &_
			"                areas_academicas d, facultades e,personas f (nolock)  "& vbCrLf &_
			"                where a.saca_ncorr = b.saca_ncorr   "& vbCrLf &_
			"                and b.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"                and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"                and a.pers_ncorr=f.pers_ncorr   "& vbCrLf &_
			"                and b.tsca_ccod in (3) and c.tcar_ccod=2  "& vbCrLf &_
			"                and cast(a.sede_ccod as varchar)='"&sede_ccod&"'"&filtro_carreras&filtro_facultad& vbCrLf &_
			" ) ttr "& vbCrLf &_
			" ORDER BY carr_tdesc ASC "
'response.write("<pre>"&consulta&"</pre>")	
'response.end()	
f_lista.Consultar consulta 
	

%>
<html>
<head>
<title>detalle carreras excel</title>
<meta http-equiv="Content-Type" content="text/html;">
<style type="text/css">
	
div#tResutados1{
	width:100%;
	alignment-adjust:auto;
}
div#contieneCarga{
	width:100%;
	height:40px;
	text-align:center;
}
div#contieneCarga#cargando{
	width:300px;
	height:40px;
	text-align:center;
	background:url(../img/ajax-loader.gif) no-repeat;	
	background-position: center;
}
div#titulo{
	color:#666;
}
td.nombre
{
	padding-left:30px;
}
td.total_1
{
	color:#000;
	text-align:center;
	font-weight:bold;
}
th.total_1
{
	color:#000;
	text-align:center;
	font-weight:bold;
}
td.porcent_1
{
	color:#000;
	text-align:center;
	font-weight:bold; 
}
th.porcent_1
{
	color:#000;
	text-align:center;
	font-weight:bold;
}

td.porcent_2
{
	color:#000;
	text-align:center;
	font-weight:bold; 
	background-color:#BCC0E0;
}
</style>
</head>
<body >
<table width="100%" border="0">
  <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">ESTADÍSTICAS EGRESADOS, TITULADOS Y GRADUADOS</font></div>
<%	fecha1	= conexion.consultaUno("select getDate()")	%>
<div id="fecha">
	<table>
		<tr>
			<td style="border-bottom:solid; border-bottom-color:#666;" width="77%" align="left"><strong><%response.Write("Fecha y hora: "&fecha1)%></strong></td>
		</tr>
	</table>
</div>  
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
</table>
<%
'Inicio cuerpo tabla
%>
<table class='v1' width='100%' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD' id='tb_secciones'>
<%
'*************************************************'
'**				INSTITUCIONES					**'
'*************************************************'---------------------------------------
%>				
<tr bgcolor='#C4D7FF' bordercolor='#999999'>
	<th><font color='#333333'>&nbsp;</font></th>
<%
'************************'
'* Universidad Pregrado	*'
'************************'--------------- 
%>		
	<%if (institucion = "U") and (tipo = "UEG" or tipo = "UTI" or tipo = "PRG" or tipo = "SIE" or tipo = "SIT") then%>
		<th colspan="2"><font color='#333333'>Universidad Pregrado</font></th>
	<%end if%>
<%
'************************'--------------- 
'* Universidad Pregrado	*'
'************************'
%>	
<%
'****************************'
'* Universidad Postgrado	*'
'****************************'---------------
%>	
	<%if (institucion = "U") and ( tipo = "POG" ) then%>
		<th colspan="2"><font color='#333333'>Universidad Postgrado</font></th>
	<%end if%>	
<%
'****************************'---------------
'* Universidad Postgrado	*'
'****************************'
%>	
<%
'****************'
'* 	Instituto	*'
'****************'---------------
%>
	<%if (institucion = "I") and ( tipo = "IEG" or tipo = "ITI" ) then%>
		<th colspan="2"><font color='#333333'>Instituto</font></th>
	<%end if%>
<%
'****************'---------------
'* 	Instituto	*'
'****************'
%>	
</tr>
<%
'*************************************************'---------------------------------------
'**				INSTITUCIONES					**'
'*************************************************'
%>	

<%
'*********************************************************'
'**				ESTADOS DE TITULADOS					**'
'*********************************************************'---------------------------------------
%>				
<tr bgcolor='#C4D7FF' bordercolor='#999999'>
<th><font color='#333333'><%=sede_tdesc%></font></th>
<%
'************************'
'* Universidad Pregrado	*'
'************************'--------------- 
%>	
<%if institucion = "U" then%>
	<%if tipo = "UEG" then%>
		<th colspan="2"><font color='#333333'>Egresados</font></th>
	<%end if%>	
	<%if tipo = "UTI" then%>
		<th colspan="2"><font color='#333333'>Titulados</font></th>	
	<%end if%>	
	<%if tipo = "PRG" then%>	
		<th colspan="2"><font color='#333333'>Grados</font></th>
	<%end if%>	
	<%if tipo = "SIE" then%>		
		<th colspan="2"><font color='#333333'>S.I.E</font></th>
	<%end if%>	
	<%if tipo = "SIT" then%>
		<th colspan="2"><font color='#333333'>S.I.T</font></th>
	<%end if%>
<%end if%>	
<%
'************************'--------------- 
'* Universidad Pregrado	*'
'************************'
%>	
<%
'****************************'
'* Universidad Postgrado	*'
'****************************'---------------
%>
<%if institucion = "U" then%>
	<%if tipo = "POG" then%>
		<th colspan="2"><font color='#333333'>Grados</font></th>
	<%end if%>
<%end if%>	
<%
'****************************'---------------
'* Universidad Postgrado	*'
'****************************'
%>
<%
'****************'
'* 	Instituto	*'
'****************'---------------
%>
<%if institucion = "I" then%>
	<%if tipo = "IEG" then%>
		<th colspan="2"><font color='#333333'>Egresados</font></th>
	<%end if%>
	<%if tipo = "ITI" then%>
		<th colspan="2"><font color='#333333'>Titulados</font></th>
	<%end if%>
<%end if%>
<%
'****************'---------------
'* 	Instituto	*'
'****************'
%>
</tr>
<%
'*********************************************************'---------------------------------------
'**				ESTADOS DE TITULADOS					**'
'*********************************************************'
%>					
<%
'*****************************************'
'**				SEXOS					**'
'*****************************************'---------------------------------------
%>	
<tr bgcolor='#C4D7FF' bordercolor='#999999'>
<th><font color='#333333'>&nbsp;</font></th>
<%
'************************'
'* Universidad Pregrado	*'
'************************'--------------- 
%>	
<%if institucion = "U" then%>
	<%if tipo = "UEG" then%>
		<%if sexo_ccod = "1" then%>
			<th><%Response.write(SexTextMascu)%></th>
            <th class="porcent_1">%</th>
		<%end if%>	
		<%if sexo_ccod = "2" then%>
			<th><%Response.write(SexTextFeme)%></th>
            <th class="porcent_1">%</th>
		<%end if%>	
		<%if sexo_ccod = "3" then%>
			<th><%Response.write(SexTextFM)%></th>
            <th class="porcent_1">%</th>
		<%end if%>	
	<%end if%>	
	<%if tipo = "UTI" then%>
		<%if sexo_ccod = "1" then%>
			<th><%Response.write(SexTextMascu)%></th>
            <th class="porcent_1">%</th>
		<%end if%>	
		<%if sexo_ccod = "2" then%>
			<th><%Response.write(SexTextFeme)%></th>
            <th class="porcent_1">%</th>
		<%end if%>
		<%if sexo_ccod = "3" then%>
			<th><%Response.write(SexTextFM)%></th>
            <th class="porcent_1">%</th>
		<%end if%>			
	<%end if%>	
	<%if tipo = "PRG" then%>	
		<%if sexo_ccod = "1" then%>
			<th><%Response.write(SexTextMascu)%></th>
            <th class="porcent_1">%</th>
		<%end if%>	
		<%if sexo_ccod = "2" then%>
			<th><%Response.write(SexTextFeme)%></th>
            <th class="porcent_1">%</th>
		<%end if%>	
		<%if sexo_ccod = "3" then%>
			<th><%Response.write(SexTextFM)%></th>
            <th class="porcent_1">%</th>
		<%end if%>			
	<%end if%>	
	<%if tipo = "SIE" then%>		
		<%if sexo_ccod = "1" then%>
			<th><%Response.write(SexTextMascu)%></th>
            <th class="porcent_1">%</th>
		<%end if%>
		<%if sexo_ccod = "2" then%>
			<th><%Response.write(SexTextFeme)%></th>
            <th class="porcent_1">%</th>
		<%end if%>		
		<%if sexo_ccod = "3" then%>
			<th><%Response.write(SexTextFM)%></th>
            <th class="porcent_1">%</th>					
		<%end if%>
	<%end if%>	
	<%if tipo = "SIT" then%>
		<%if sexo_ccod = "1" then%>
			<th><%Response.write(SexTextMascu)%></th>
            <th class="porcent_1">%</th>
		<%end if%>
		<%if sexo_ccod = "2" then%>

			<th><%Response.write(SexTextFeme)%></th>
            <th class="porcent_1">%</th>
		<%end if%>
		<%if sexo_ccod = "3" then%>
			<th><%Response.write(SexTextFM)%></th>
            <th class="porcent_1">%</th>
		<%end if%>			
	<%end if%>
<%end if%>	
<%
'************************'--------------- 
'* Universidad Pregrado	*'
'************************'
%>	
<%
'****************************'
'* Universidad Postgrado	*'
'****************************'---------------
%>
<%if institucion = "U" then%>
	<%if tipo = "POG" then%>
		<%if sexo_ccod = "1" then%>
			<th><%Response.write(SexTextMascu)%></th>
            <th class="porcent_1">%</th>
		<%end if%>
		<%if sexo_ccod = "2" then%>

			<th><%Response.write(SexTextFeme)%></th>
            <th class="porcent_1">%</th>
		<%end if%>
		<%if sexo_ccod = "3" then%>
			<th><%Response.write(SexTextFM)%></th>
            <th class="porcent_1">%</th>
		<%end if%>			
	<%end if%>
<%end if%>	
<%
'****************************'---------------
'* Universidad Postgrado	*'
'****************************'
%>
<%
'****************'
'* 	Instituto	*'
'****************'---------------
%>
<%if institucion = "I" then%>
	<%if tipo = "IEG" then%>
		<%if sexo_ccod = "1" then%>
			<th><%Response.write(SexTextMascu)%></th>
            <th class="porcent_1">%</th>
		<%end if%>
		<%if sexo_ccod = "2" then%>

			<th><%Response.write(SexTextFeme)%></th>
            <th class="porcent_1">%</th>
		<%end if%>
		<%if sexo_ccod = "3" then%>
			<th><%Response.write(SexTextFM)%></th>
            <th class="porcent_1">%</th>
		<%end if%>			
	<%end if%>
	<%if tipo = "ITI" then%>
		<%if sexo_ccod = "1" then%>
			<th><%Response.write(SexTextMascu)%></th>
            <th class="porcent_1">%</th>
		<%end if%>
		<%if sexo_ccod = "2" then%>
			<th><%Response.write(SexTextFeme)%></th>
            <th class="porcent_1">%</th>
		<%end if%>
		<%if sexo_ccod = "3" then %>
			<th><%Response.write(SexTextFM)%></th>
            <th class="porcent_1">%</th>
		<%end if%>			
	<%end if%>
<%end if%>
<%
'****************'---------------
'* 	Instituto	*'
'****************'
%>
</tr>
<%
'*****************************************'---------------------------------------
'**				SEXOS					**'
'*****************************************'
%>					
				<%  TEUH = 0
					TEUM = 0
					TTUH = 0
					TTUM = 0
					TGPH = 0
					TGPM = 0
					TESH = 0
					TESM = 0
					TTSH = 0
					TTSM = 0
					TEIH = 0
					TEIM = 0
					TTIH = 0
					TTIM = 0
					TGGH = 0
					TGGM = 0
					auxTotalEUHM 	= 0
					TauxTotalEUHM 	= 0
					auxTotalTUHM 	= 0
					TauxTotalTUHM 	= 0
					auxTotalGPHM	= 0
					TauxTotalGPHM	= 0		
					auxTotalESHM	= 0
					TauxTotalESHM	= 0	
					auxTotalTSHM	= 0
					TauxTotalTSHM	= 0	
					num=1
				  while f_lista.siguiente
				    carr_ccod = f_lista.obtenerValor("carr_ccod")'c??o carrera
					facu_ccod = f_lista.obtenerValor("facu_ccod")'c??o facultad
					carrera   = f_lista.obtenerValor("carr_tdesc")'nombre carrera 
					'************************'
					'* Universidad Pregrado	*'
					'************************'---------------
						'EGRESADOS----------->>
							EUH  = f_lista.obtenerValor("egresados_U_hombres")		' valor del total de hombres egresados universidad
							TEUH = TEUH + cint(EUH)									' valor de los totales de hombres egresados universidad
							EUM       = f_lista.obtenerValor("egresados_U_mujeres")	' valor del total de mujeres egresados universidad
							TEUM = TEUM + cint(EUM)									' valor de los totales de mujeres egresados universidad
							auxTotalEUHM 	= cint(EUH) + cint(EUM)					' valor del total de mujeres y hombres egresados universidad
							TauxTotalEUHM 	= TauxTotalEUHM + auxTotalEUHM			' valor de los totales de mujeres y hombres egresados universidad
						'EGRESADOS-----------<<	
						'TITULADOS----------->>
							TUH       = f_lista.obtenerValor("titulados_U_hombres")
							TTUH = TTUH + cint(TUH)
							TUM       = f_lista.obtenerValor("titulados_U_mujeres")
							TTUM = TTUM + cint(TUM) 
							auxTotalTUHM 	= cint(TUH) + cint(TUM)
							TauxTotalTUHM 	= TauxTotalTUHM + auxTotalTUHM							
						'TITULADOS-----------<<
						'GRADUADOS----------->>
							GPH       = f_lista.obtenerValor("graduados_PR_hombres")
							TGPH = TGPH + cint(GPH)								
							GPM       = f_lista.obtenerValor("graduados_PR_mujeres")
							TGPM = TGPM + cint(GPM)
							auxTotalGPHM	= cint(GPH) + cint(GPM)
							TauxTotalGPHM	= TauxTotalGPHM + auxTotalGPHM
						'GRADUADOS-----------<<
						'S.I.E----------->>
							ESH       = f_lista.obtenerValor("SIE_hombres")
							TESH = TESH + cint(ESH)
							ESM       = f_lista.obtenerValor("SIE_mujeres")
							TESM = TESM + cint(ESM)
							auxTotalESHM	= cint(ESH) + cint(ESM)
							TauxTotalESHM	= TauxTotalESHM + auxTotalESHM							
						'S.I.E-----------<<
						'S.I.T----------->>
							TSH       = f_lista.obtenerValor("SIT_hombres")
							TTSH = TTSH + cint(TSH)
							TSM       = f_lista.obtenerValor("SIT_mujeres")
							TTSM = TTSM + cint(TSM)
							auxTotalTSHM	= cint(TSH) + cint(TSM)
							TauxTotalTSHM	= TauxTotalTSHM + auxTotalTSHM								
						'S.I.T-----------<<
					'************************'---------------		
					'* Universidad Pregrado	*'
					'************************'	
					'****************************'	
					'* Universidad Postgrado	*'
					'****************************'---------------	
						'Grados----------->>
							GGH       = f_lista.obtenerValor("graduados_PO_hombres")
							TGGH = TGGH + cint(GGH)
							GGM       = f_lista.obtenerValor("graduados_PO_mujeres")
							TGGM = TGGM + cint(GGM)
							auxTotalGGHM	= cint(GGH) + cint(GGM)
							TauxTotalGGHM	= TauxTotalGGHM + auxTotalGGHM	
						'Grados-----------<<
					'****************************'---------------		
					'* Universidad Postgrado	*'
					'****************************'
					'****************************'	
					'* 			Instituto		*'
					'****************************'---------------		
						'EGRESADOS----------->>
							EIH       = f_lista.obtenerValor("egresados_I_hombres")
							TEIH = TEIH + cint(EIH)
							EIM       = f_lista.obtenerValor("egresados_I_mujeres")
							TEIM = TEIM + cint(EIM)
							auxTotalEIHM	= cint(EIH) + cint(EIM)
							TauxTotalEIHM	= TauxTotalEIHM + auxTotalEIHM								
						'EGRESADOS-----------<<	
						'TITULADOS----------->>
							TIH       = f_lista.obtenerValor("titulados_I_hombres")
							TTIH = TTIH + cint(TIH)
							TIM       = f_lista.obtenerValor("titulados_I_mujeres")
							TTIM = TTIM + cint(TIM)
							auxTotalTIHM	= cint(TIH) + cint(TIM)
							TauxTotalTIHM	= TauxTotalTIHM + auxTotalTIHM								
						'TITULADOS-----------<<						

					'****************************'---------------			
					'* 			Instituto		*'
					'****************************'		
'************************'
'* Universidad Pregrado	*'
'************************'--------------- 
%>	
<%if institucion = "U"  then%>	
	<%if tipo = "UEG" then%>
		<%if sexo_ccod = "1" and (cInt(EUH) > 0) then%>	
			<tr bgcolor="#FFFFFF">
				<input type="hidden" name="campo_<%=num%>_carrera" value="<%=carrera%>">
				<input type="hidden" name="campo_<%=num%>_c1" value="<%=EUH%>">
				<td align='LEFT' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font size="1"><%=carrera%></font></td>
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UEG&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=EUH%></td>
				<td class="porcent_1" ><%=persent(EUH,suma_egresados_u_hombres)%></td>
			</tr>
		<%end if%>	
		<%if sexo_ccod = "2" and (cInt(EUM) > 0) then%>
			<tr bgcolor="#FFFFFF">
				<input type="hidden" name="campo_<%=num%>_carrera" value="<%=carrera%>">
				<input type="hidden" name="campo_<%=num%>_c2" value="<%=EUM%>">
				<td align='LEFT' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font size="1"><%=carrera%></font></td>
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UEG&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=EUM%></td>
				<td class="porcent_1" ><%=persent(EUM,suma_egresados_u_mujeres)%></td>
			</tr>
		<%end if%>	
		<%if sexo_ccod = "3" and (cInt(auxTotalEUHM) > 0) then%>	
			<tr bgcolor="#FFFFFF">
				<input type="hidden" name="campo_<%=num%>_carrera" value="<%=carrera%>">
				<td align='LEFT' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font size="1"><%=carrera%></font></td>
				<td ><%=auxTotalEUHM%></td>
				<td class="porcent_1" ><%=persent(auxTotalEUHM,suma_egresados_U_mujeresYhombres)%></td>
			</tr>	
		<%end if%>
	<%end if%>	
	<%if tipo = "UTI" then%>
		<%if sexo_ccod = "1" and (cInt(TUH) > 0) then%>
			<tr bgcolor="#FFFFFF">
				<input type="hidden" name="campo_<%=num%>_carrera" value="<%=carrera%>">
				<input type="hidden" name="campo_<%=num%>_c3" value="<%=TUH%>">
				<td align='LEFT' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font size="1"><%=carrera%></font></td>
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UTI&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TUH%></td>
				<td class="porcent_1" ><%=persent(TUH,suma_titulados_u_hombres)%></td>		
			</tr>	
		<%end if%>	
		<%if sexo_ccod = "2" and (cInt(TUM) > 0) then%>
			<tr bgcolor="#FFFFFF">
				<input type="hidden" name="campo_<%=num%>_carrera" value="<%=carrera%>">
				<input type="hidden" name="campo_<%=num%>_c4" value="<%=TUM%>">
				<td align='LEFT' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font size="1"><%=carrera%></font></td>
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UTI&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TUM%></td>
				<td class="porcent_1" ><%=persent(TUM,suma_titulados_u_mujeres)%></td>
			</tr>	
		<%end if%>	
		<%if sexo_ccod = "3" and (cInt(auxTotalTUHM) > 0) then%>
			<tr bgcolor="#FFFFFF">
				<input type="hidden" name="campo_<%=num%>_carrera" value="<%=carrera%>">
				<input type="hidden" name="campo_<%=num%>_c5" value="<%=auxTotalTUHM%>">
				<td align='LEFT' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font size="1"><%=carrera%></font></td>
				<td ><%=auxTotalTUHM%></td>
				<td class="porcent_1" ><%=persent(auxTotalTUHM,suma_titulados_U_mujeresYhombres)%></td>
			</tr>	
		<%end if%>		
	<%end if%>	
	<%if tipo = "PRG" then%>	
		<%if sexo_ccod = "1" and (cInt(GPH) > 0) then%>
			<tr bgcolor="#FFFFFF">
				<input type="hidden" name="campo_<%=num%>_carrera" value="<%=carrera%>">
				<input type="hidden" name="campo_<%=num%>_c6" value="<%=GPM%>">
				<td align='LEFT' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font size="1"><%=carrera%></font></td>
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=PRG&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=GPH%></td>
				<td class="porcent_1" ><%=persent(GPH,suma_graduados_pr_hombres)%></td>
			</tr>	
		<%end if%>	
		<%if sexo_ccod = "2" and (cInt(GPM) > 0) then%>
			<tr bgcolor="#FFFFFF">
				<input type="hidden" name="campo_<%=num%>_carrera" value="<%=carrera%>">			
				<td align='LEFT' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font size="1"><%=carrera%></font></td>
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=PRG&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=GPM%></td>
				<td class="porcent_1" ><%=persent(GPM,suma_graduados_pr_mujeres)%></td>
			</tr>	
		<%end if%>
		<%if sexo_ccod = "3" and (cInt(auxTotalGPHM) > 0) then%>
			<tr bgcolor="#FFFFFF">
				<input type="hidden" name="campo_<%=num%>_carrera" value="<%=carrera%>">				
				<td align='LEFT' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font size="1"><%=carrera%></font></td>
				<td ><%=auxTotalGPHM%></td>
				<td class="porcent_1" ><%=persent(auxTotalGPHM,suma_graduados_PR_mujeresYhombres)%></td>
			</tr>	
		<%end if%>
	<%end if%>	
	<%if tipo = "SIE" then%>		
		<%if sexo_ccod = "1" and (cInt(ESH) > 0) then%>
			<tr bgcolor="#FFFFFF">
				<input type="hidden" name="campo_<%=num%>_carrera" value="<%=carrera%>">			
				<input type="hidden" name="campo_<%=num%>_c7" value="<%=ESH%>">
				<td align='LEFT' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font size="1"><%=carrera%></font></td>
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=SIE&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=ESH%></td>
				<td class="porcent_1" ><%=persent(ESH,suma_sie_hombres)%></td>
			</tr>	
		<%end if%>
		<%if sexo_ccod = "2" and (cInt(ESM) > 0) then%>
			<tr bgcolor="#FFFFFF">
				<input type="hidden" name="campo_<%=num%>_carrera" value="<%=carrera%>">		
				<input type="hidden" name="campo_<%=num%>_c8" value="<%=ESM%>">
				<td align='LEFT' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font size="1"><%=carrera%></font></td>
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=SIE&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=ESM%></td>
				<td class="porcent_1" ><%=persent(ESM,suma_sie_mujeres)%></td>
			</tr>
		<%end if%>
		<%if sexo_ccod = "3" and (cInt(auxTotalESHM) > 0) then%>
			<tr bgcolor="#FFFFFF">
				<input type="hidden" name="campo_<%=num%>_carrera" value="<%=carrera%>">		
				<td align='LEFT' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font size="1"><%=carrera%></font></td>
				<td ><%=auxTotalESHM%></td>
				<td class="porcent_1" ><%=persent(auxTotalESHM,suma_SIE_mujeresYhombres)%></td>
			</tr>
		<%end if%>		
	<%end if%>	
	<%if tipo = "SIT" then%>
		<%if sexo_ccod = "1" and (cInt(TSH) > 0) then%>
			<tr bgcolor="#FFFFFF">
				<input type="hidden" name="campo_<%=num%>_carrera" value="<%=carrera%>">			
				<input type="hidden" name="campo_<%=num%>_c9" value="<%=TSH%>">
				<td align='LEFT' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font size="1"><%=carrera%></font></td>
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=SIT&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TSH%></td>
				<td class="porcent_1" ><%=persent(TSH,suma_sit_hombres)%></td>
			</tr>
		<%end if%>
		<%if sexo_ccod = "2" and (cInt(TSM) > 0) then%>
			<tr bgcolor="#FFFFFF">
				<input type="hidden" name="campo_<%=num%>_carrera" value="<%=carrera%>">		
				<input type="hidden" name="campo_<%=num%>_c10" value="<%=TSM%>">
				<td align='LEFT' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font size="1"><%=carrera%></font></td>
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=SIT&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TSM%></td>
				<td class="porcent_1" ><%=persent(TSM,suma_sit_mujeres)%></td>
			</tr>		
		<%end if%>
		<%if sexo_ccod = "3" and (cInt(auxTotalTSHM) > 0) then%>
			<tr bgcolor="#FFFFFF">
				<input type="hidden" name="campo_<%=num%>_carrera" value="<%=carrera%>">			
				<td align='LEFT' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font size="1"><%=carrera%></font></td>
				<td ><%=auxTotalTSHM%></td>
				<td class="porcent_1" ><%=persent(auxTotalTSHM,suma_SIT_mujeresYhombres)%></td>
			</tr>	
		<%end if%>			
	<%end if%>
<%end if%>	
<%
'************************'---------------
'* Universidad Pregrado	*'
'************************'
%>

<%
'****************************'
'* Universidad Postgrado	*'
'****************************'---------------
%>	
<%if institucion = "U" then%>
	<%if tipo = "POG" then%>
		<%if (sexo_ccod = "1") and (cInt(GGH) > 0) then%>
			<tr bgcolor="#FFFFFF">
				<input type="hidden" name="campo_<%=num%>_carrera" value="<%=carrera%>">
				<input type="hidden" name="campo_<%=num%>_c11" value="<%=GGH%>">
				<td align='LEFT' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font size="1"><%=carrera%></font></td>
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=POG&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=GGH%></td>
				<td class="porcent_1" ><%=persent(GGH,suma_graduados_po_hombres)%></td>
			</tr>
		<%end if%>
		<%if sexo_ccod = "2" and (cInt(GGM) > 0) then%>
			<tr bgcolor="#FFFFFF">
				<input type="hidden" name="campo_<%=num%>_carrera" value="<%=carrera%>">
				<input type="hidden" name="campo_<%=num%>_c12" value="<%=GGM%>">
				<td align='LEFT' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font size="1"><%=carrera%></font></td>
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=POG&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=GGM%></td>
				<td class="porcent_1" ><%=persent(GGM,suma_graduados_po_mujeres)%></td>
			</tr>	
		<%end if%>
		<%if sexo_ccod = "3" and (cInt(auxTotalGGHM) > 0) then%>
			<tr bgcolor="#FFFFFF">
				<input type="hidden" name="campo_<%=num%>_carrera" value="<%=carrera%>">		
				<td align='LEFT' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font size="1"><%=carrera%></font></td>
				<td ><%=auxTotalGGHM%></td>
				<td class="porcent_1" ><%=persent(auxTotalGGHM,suma_graduados_PO_mujeresYhombres)%></td>
			</tr>	
		<%end if%>			
	<%end if%>
<%end if%>	
<%
'****************************'---------------
'* Universidad Postgrado	*'
'****************************'
%>	
<%
'****************'
'* 	Instituto	*'
'****************'---------------
%>	
<%if institucion = "I" then%>
	<%if tipo = "IEG" then%>
		<%if sexo_ccod = "1" and (cInt(EIH) > 0) then%>
			<tr bgcolor="#FFFFFF">
				<input type="hidden" name="campo_<%=num%>_carrera" value="<%=carrera%>">			
				<input type="hidden" name="campo_<%=num%>_c13" value="<%=EIH%>">
				<td align='LEFT' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font size="1"><%=carrera%></font></td>
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=IEG&sexo_ccod=1&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=EIH%></td>
				<td class="porcent_1" ><%=persent(EIH,suma_egresados_i_hombres)%></td>
			</tr>	
		<%end if%>
		<%if sexo_ccod = "2" and (cInt(EIM) > 0) then%>
			<tr bgcolor="#FFFFFF">
				<input type="hidden" name="campo_<%=num%>_carrera" value="<%=carrera%>">		
				<input type="hidden" name="campo_<%=num%>_c14" value="<%=EIM%>">
				<td align='LEFT' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font size="1"><%=carrera%></font></td>
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=IEG&sexo_ccod=2&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=EIM%></td>
				<td class="porcent_1" ><%=persent(EIM,suma_egresados_i_mujeres)%></td>
			</tr>	
		<%end if%>
		<%if sexo_ccod = "3" and (cInt(auxTotalEIHM) > 0) then%>
			<tr bgcolor="#FFFFFF">
				<input type="hidden" name="campo_<%=num%>_carrera" value="<%=carrera%>">			
				<td align='LEFT' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font size="1"><%=carrera%></font></td>
				<td ><%=auxTotalEIHM%></td>
				<td class="porcent_1" ><%=persent(auxTotalEIHM,suma_egresados_I_mujeresYhombres)%></td>
			</tr>	
		<%end if%>			
	<%end if%>
	<%if tipo = "ITI" then%>
		<%if sexo_ccod = "1" and (cInt(TIH) > 0)  then%>
			<tr bgcolor="#FFFFFF">
				<input type="hidden" name="campo_<%=num%>_carrera" value="<%=carrera%>">		
				<input type="hidden" name="campo_<%=num%>_c15" value="<%=TIH%>">
				<td align='LEFT' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font size="1"><%=carrera%></font></td>
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=ITI&sexo_ccod=1&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TIH%></td>
				<td class="porcent_1" ><%=persent(TIH,suma_titulados_i_hombres)%></td>
			</tr>	
		<%end if%>
		<%if sexo_ccod = "2" and (cInt(TIM) > 0)  then%>
			<tr bgcolor="#FFFFFF">
				<input type="hidden" name="campo_<%=num%>_carrera" value="<%=carrera%>">		
				<input type="hidden" name="campo_<%=num%>_c16" value="<%=TIM%>">
				<td align='LEFT' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font size="1"><%=carrera%></font></td>
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=ITI&sexo_ccod=2&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TIM%></td>
				<td class="porcent_1" ><%=persent(TIM,suma_titulados_i_mujeres)%></td>
			</tr>	
		<%end if%>
		<%if sexo_ccod = "3" and (cInt(auxTotalTIHM) > 0)  then%>
			<tr bgcolor="#FFFFFF">
				<input type="hidden" name="campo_<%=num%>_carrera" value="<%=carrera%>">		
				<td align='LEFT' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font size="1"><%=carrera%></font></td>
				<td ><%=auxTotalTIHM%></td>
				<td class="porcent_1" ><%=persent(auxTotalTIHM,suma_titulados_I_mujeresYhombres)%></td>
			</tr>	
		<%end if%>		
	<%end if%>
<%end if%>
<%
'****************'---------------
'* 	Instituto	*'
'****************'


num = num + 1

wend
%><tr bgcolor="#FFFFFF"><%
'*****************************************************************************************************************'
'**													TOTALES														**'
'*****************************************************************************************************************'---------
%>	
				
<input type="hidden" name="campo_<%=num%>_carrera" value="TOTALES">
<input type="hidden" name="campo_<%=num%>_c1" value="<%=TEUH%>">
<input type="hidden" name="campo_<%=num%>_c2" value="<%=TEUM%>">
<input type="hidden" name="campo_<%=num%>_c3" value="<%=TTUH%>">
<input type="hidden" name="campo_<%=num%>_c4" value="<%=TTUM%>">
<input type="hidden" name="campo_<%=num%>_c5" value="<%=TGPH%>">
<input type="hidden" name="campo_<%=num%>_c6" value="<%=TGPM%>">
<input type="hidden" name="campo_<%=num%>_c7" value="<%=TESH%>">
<input type="hidden" name="campo_<%=num%>_c8" value="<%=TESM%>">
<input type="hidden" name="campo_<%=num%>_c9" value="<%=TTSH%>">
<input type="hidden" name="campo_<%=num%>_c10" value="<%=TTSM%>">
<input type="hidden" name="campo_<%=num%>_c11" value="<%=TGGH%>">
<input type="hidden" name="campo_<%=num%>_c12" value="<%=TGGM%>">
<input type="hidden" name="campo_<%=num%>_c13" value="<%=TEIH%>">
<input type="hidden" name="campo_<%=num%>_c14" value="<%=TEIM%>">
<input type="hidden" name="campo_<%=num%>_c15" value="<%=TTIH%>">
<input type="hidden" name="campo_<%=num%>_c16" value="<%=TTIM%>">
			
<td align='right'>TOTALES</td>
<%
'************************'
'* Universidad Pregrado	*'
'************************'--------------- 
%>	
<%if institucion = "U" then%>
	<%if tipo = "UEG" then%>
		<%if sexo_ccod = "1" then%>
			<td align='CENTER'><strong><%=TEUH%></strong></td>
			<td class="porcent_1" >100</td>
		<%end if%>	
		<%if sexo_ccod = "2" then%>
			<td align='CENTER'><strong><%=TEUM%></strong></td>
			<td class="porcent_1" >100</td>
		<%end if%>	
		<%if sexo_ccod = "3" then%>
			<td align='CENTER'><strong><%=TauxTotalEUHM%></strong></td>
			<td class="porcent_1" >100</td>
		<%end if%>			
	<%end if%>	
	<%if tipo = "UTI" then%>
		<%if sexo_ccod = "1" then%>
			<td align='CENTER'><strong><%=TTUH%></strong></td>
			<td class="porcent_1" >100</td>
		<%end if%>	
		<%if sexo_ccod = "2" then%>
			<td align='CENTER'><strong><%=TTUM%></strong></td>
			<td class="porcent_1" >100</td>
		<%end if%>		
		<%if sexo_ccod = "3" then%>
			<td align='CENTER'><strong><%=TauxTotalTUHM%></strong></td>
			<td class="porcent_1" >100</td>
		<%end if%>				
	<%end if%>	
	<%if tipo = "PRG" then%>	
		<%if sexo_ccod = "1" then%>
			<td align='CENTER'><strong><%=TGPH%></strong></td>
			<td class="porcent_1" >100</td>
		<%end if%>	
		<%if sexo_ccod = "2" then%>
			<td align='CENTER'><strong><%=TGPM%></strong></td>
			<td class="porcent_1" >100</td>
		<%end if%>	
		<%if sexo_ccod = "3" then%>
			<td align='CENTER'><strong><%=TauxTotalGPHM%></strong></td>
			<td class="porcent_1" >100</td>
		<%end if%>			
	<%end if%>	
	<%if tipo = "SIE" then%>		
		<%if sexo_ccod = "1" then%>
			<td align='CENTER'><strong><%=TESH%></strong></td>
			<td class="porcent_1" >100</td>
		<%end if%>
		<%if sexo_ccod = "2" then%>
			<td align='CENTER'><strong><%=TESM%></strong></td>
			<td class="porcent_1" >100</td>
		<%end if%>
		<%if sexo_ccod = "3" then%>
			<td align='CENTER'><strong><%=TauxTotalESHM%></strong></td>
			<td class="porcent_1" >100</td>
		<%end if%>		
	<%end if%>	
	<%if tipo = "SIT" then%>
		<%if sexo_ccod = "1" then%>
			<td align='CENTER'><strong><%=TTSH%></strong></td>
			<td class="porcent_1" >100</td>
		<%end if%>
		<%if sexo_ccod = "2" then%>
			<td align='CENTER'><strong><%=TTSM%></strong></td>
			<td class="porcent_1" >100</td>
		<%end if%>
		<%if sexo_ccod = "3" then%>
			<td align='CENTER'><strong><%=TauxTotalTSHM%></strong></td>
			<td class="porcent_1" >100</td>
		<%end if%>		
	<%end if%>
<%end if%>	
<%
'************************'--------------- 
'* Universidad Pregrado	*'
'************************'
%>	
<%
'****************************'
'* Universidad Postgrado	*'
'****************************'---------------
%>
<%if institucion = "U" then%>
	<%if tipo = "POG" then%>
		<%if sexo_ccod = "1" then%>
			<td align='CENTER'><strong><%=TGGH%></strong></td>
			<td class="porcent_1" >100</td>
		<%end if%>
		<%if sexo_ccod = "2" then%>
			<td align='CENTER'><strong><%=TGGM%></strong></td>
			<td class="porcent_1" >100</td>
		<%end if%>
		<%if sexo_ccod = "3" then%>
			<td align='CENTER'><strong><%=TauxTotalGGHM%></strong></td>
			<td class="porcent_1" >100</td>
		<%end if%>		
	<%end if%>
<%end if%>	
<%
'****************************'---------------
'* Universidad Postgrado	*'
'****************************'
%>
<%
'****************'
'* 	Instituto	*'
'****************'---------------
%>
<%if institucion = "I" then%>
	<%if tipo = "IEG" then%>
		<%if sexo_ccod = "1" then%>
			<td align='CENTER'><strong><%=TEIH%></strong></td>
			<td class="porcent_1" >100</td>
		<%end if%>
		<%if sexo_ccod = "2" then%>
			<td align='CENTER'><strong><%=TEIM%></strong></td>
			<td class="porcent_1" >100</td>
		<%end if%>
		<%if sexo_ccod = "3" then%>
			<td align='CENTER'><strong><%=TauxTotalEIHM%></strong></td>
			<td class="porcent_1" >100</td>
		<%end if%>		
	<%end if%>
	<%if tipo = "ITI" then%>
		<%if sexo_ccod = "1" then%>
			<td align='CENTER'><strong><%=TTIH%></strong></td>
			<td class="porcent_1" >100</td>
		<%end if%>
		<%if sexo_ccod = "2" then%>
			<td align='CENTER'><strong><%=TTIM%></strong></td>
			<td class="porcent_1" >100</td>
		<%end if%>
		<%if sexo_ccod = "3" then%>
			<td align='CENTER'><strong><%=TauxTotalTIHM%></strong></td>
			<td class="porcent_1" >100</td>
		<%end if%>
	<%end if%>
<%end if%>
<%
'****************'---------------
'* 	Instituto	*'
'****************'
%>
<%
'*****************************************************************************************************************'---------
'**													TOTALES														**'
'*****************************************************************************************************************'
%>							
				</tr>
</table>
<%
'fin cuerpo tabla
%>
</body>
</html>