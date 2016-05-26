<!-- #include file = "../../../biblioteca/_conexion.asp" -->
<!-- #include file = "../../../biblioteca/_negocio.asp" -->
<!-- #include file = "../dlls/dll_1.asp" -->
<%
'---------------------------------------------------oDebug>>
for each k in request.QueryString()
 response.Write(k&" = "&request.QueryString(k)&"<br>")
next
'response.end()
'---------------------------------------------------oDebug<<
set pagina = new CPagina
'-------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

'set negocio = new CNegocio
'negocio.Inicializa conexion
'------------------------------------------------------------------------------

'***************************'
'** CAPTURA VARIABLES GET **'
'***************************'--------------------------	
sede_ccod 		= request.QueryString("sede_ccod")
tipo      		= request.QueryString("tipo")
sexo_ccod 		= request.QueryString("sexo_ccod")
institucion		= request.QueryString("institucion")
facu_ccod		= request.QueryString("facu_ccod")
carr_ccod   	= request.QueryString("carr_ccod")
sede_tdesc 		= conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede_ccod&"'")
carr_tdesc 		= conexion.consultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar)='"&carr_ccod&"'")
'-------------------------------------------------------------------
upa_pregrado  	=  request.QueryString("upa_pregrado")
upa_postgrado 	=  request.QueryString("upa_postgrado")
instituto     	=  request.QueryString("instituto")
egresados  	  	=  request.QueryString("egresados")
titulados     	=  request.QueryString("titulados")
graduados     	=  request.QueryString("graduados")
salidas_int   	=  request.QueryString("salidas_int")
femenino 	  	=  request.QueryString("femenino")
masculino 	  	=  request.QueryString("masculino")
selectAnioPromo =  request.QueryString("selectAnioPromo")
selectAnioTitu  =  request.QueryString("selectAnioTitu")
selectAnioEgre  =  request.QueryString("selectAnioEgre")
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
'for each k in request.QueryString()
' response.Write(k&" = "&request.QueryString(k)&"<br>")
'next

'***************************'--------------------------	
'** CAPTURA VARIABLES GET **'
'***************************'
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
'*********************************************************'
'**						TOTALES							**'
'*********************************************************'-------------------------
'TOTALES>>>>>>
suma_egresados_u_hombres	=	0
suma_egresados_u_mujeres	=	0
suma_titulados_u_hombres	=	0
suma_titulados_u_mujeres	=	0
suma_sie_hombres			=	0
suma_sie_mujeres			=	0
suma_sit_hombres			=	0
suma_sit_mujeres			=	0
suma_graduados_po_hombres	=	0
suma_graduados_po_mujeres	=	0
suma_egresados_i_hombres	=	0
suma_egresados_i_mujeres	=	0
suma_titulados_i_hombres	=	0
suma_titulados_i_mujeres	=	0					
'TOTALES<<<<<<
TEUH = 0 'total/egresados/universidad pre-grado/hombre
TEUM = 0 'total/egresados/universidad pre-grado/mujer
TEIH = 0 'total/egresados/instituto/hombre
TEIM = 0 'total/egresados/instituto/mujer					
TTUH = 0 'total/titulados/universidad pre-grado/hombre
TTUM = 0 'total/titulados/universidad pre-grado/mujer
TTIH = 0 'total/titulados/instituto/hombre
TTIM = 0 'total/titulados/instituto/mujer					
TGPH = 0 'total/grados/universidad pre-grado/hombre
TGPM = 0 'total/grados/universidad pre-grado/mujer
TGGH = 0 'total/grados/universidad_post_grado/hombre
TGGM = 0 'total/grados/universidad_post_grado/mujer					
TESH = 0 'total/s.i.e/universidad_pre_grado/hombre
TESM = 0 'total/s.i.e/universidad_pre_grado/mujer
TTSH = 0 'total/s.i.t/universidad_pre_grado/hombre
TTSM = 0 'total/s.i.t/universidad_pre_grado/mujer
'-----------------------------------------------------------------------------/////////////
EUH	= 0
EUM	= 0
TUH	= 0
TUM	= 0
ESH	= 0
ESM	= 0
TSH	= 0
TSM	= 0
EIM = 0
TIH	= 0
TIM	= 0
GGH	= 0
GGM	= 0
set f_lista2 = new CFormulario
f_lista2.Carga_Parametros "tabla_vacia.xml", "tabla"
f_lista2.Inicializar conexion
consulta = "" & vbCrLf & _
"select sede_ccod, 					" & vbCrLf & _
			"sede_tdesc as sede 		" & vbCrLf & _ 
			"from sedes   				"& vbCrLf &_
			" order by sede_tdesc asc 	"
f_lista2.Consultar consulta 
while f_lista2.siguiente
	sede_ccodThis = sede_ccod
	if upa_pregrado = "1" then
	    if egresados = "1" then
		    if masculino = "1" then
				letra 						= estadistica_titulados_vASP(sede_ccodThis,1,"U","UEG", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
				EUH       					= conexion.consultaUno(letra)
				TEUH 						= TEUH + cint(EUH)
				suma_egresados_u_hombres	= TEUH
			end if
			if femenino = "1" then
				letra 						= estadistica_titulados_vASP(sede_ccodThis,2,"U","UEG", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
				EUM       					= conexion.consultaUno(letra)
				TEUM 						= TEUM + cint(EUM)
				suma_egresados_u_mujeres	= TEUM
				response.write(suma_egresados_u_mujeres&"-")
			end if
		end if
		if titulados = "1" then
		    if masculino = "1" then
				letra 						= estadistica_titulados_vASP(sede_ccodThis,1,"U","UTI", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)	
				TUH     					= conexion.consultaUno(letra)							
				TTUH 						= TTUH + cint(TUH)
				suma_titulados_u_hombres	= TTUH
			end if
			if femenino = "1" then
				letra 						= estadistica_titulados_vASP(sede_ccodThis,2,"U","UTI", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
				TUM     					= conexion.consultaUno(letra)
				TTUM 						= TTUM + cint(TUM) 
				suma_titulados_u_mujeres	= TTUM
			end if
		end if
		if salidas_int = "1" then
			'EGRESADOS>>
		    if masculino = "1" then	
				letra 				= estadistica_titulados_vASP(sede_ccodThis,1,"U","SIE", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
				ESH     			= conexion.consultaUno(letra)
				TESH 				= TESH + cint(ESH)
				suma_sie_hombres	= TESH
			end if
			if femenino = "1" then
				letra 				= estadistica_titulados_vASP(sede_ccodThis,2,"U","SIE", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
				ESM     			= conexion.consultaUno(letra)
				TESM 				= TESM + cint(ESM)
				suma_sie_mujeres	= TESM
			end if
			'EGRESADOS<<
			'TITULADOS>>
			if masculino = "1" then
				letra 				= estadistica_titulados_vASP(sede_ccodThis,1,"U","SIT", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
				TSH     			= conexion.consultaUno(letra)
				TTSH 				= TTSH + cint(TSH)
				suma_sit_hombres	= TTSH
			end if
			if femenino = "1" then
				letra 				= estadistica_titulados_vASP(sede_ccodThis,2,"U","SIT", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
				TSM     			= conexion.consultaUno(letra)
				TTSM 				= TTSM + cint(TSM)
				suma_sit_mujeres	= TTSM
			'TITULADOS<<
			end if
		end if
	end if
	if instituto = "1" then
	    if egresados = "1" then
		    if masculino = "1" then
				letra 						= estadistica_titulados_vASP(sede_ccodThis,1,"I","IEG", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
				EIH     					= conexion.consultaUno(letra)
				TEIH 						= TEIH + cint(EIH)
				suma_egresados_i_hombres	= TEIH
			end if
			if femenino = "1" then
				letra 						= estadistica_titulados_vASP(sede_ccodThis,2,"I","IEG", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
				EIM     					= conexion.consultaUno(letra)
				TEIM 						= TEIM + cint(EIM)
				suma_egresados_i_mujeres	= TEIM
			end if
		end if
		if titulados = "1" then
		    if masculino = "1" then
				letra 						= estadistica_titulados_vASP(sede_ccodThis,1,"I","ITI", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
				TIH     					= conexion.consultaUno(letra)
				TTIH 						= TTIH + cint(TIH)
				suma_titulados_i_hombres	= TTIH
			end if
			if femenino = "1" then
				letra 						= estadistica_titulados_vASP(sede_ccodThis,2,"I","ITI", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
				TIM     					= conexion.consultaUno(letra)
				TTIM 						= TTIM + cint(TIM)
				suma_titulados_i_mujeres	= TTIM
			end if
		end if
	end if
	if upa_postgrado = "1" then				
	    if graduados = "1" then
		    if masculino = "1" then
				letra 						= estadistica_titulados_vASP(sede_ccodThis,1,"U","POG", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
				GGH     					= conexion.consultaUno(letra)
				TGGH 						= TGGH + cint(GGH)
				suma_graduados_po_hombres	= TGGH
			end if
			if femenino = "1" then
				letra 						= estadistica_titulados_vASP(sede_ccodThis,2,"U","POG", facu_ccod, carr_ccod, selectAnioPromo, selectAnioEgre, selectAnioTitu)
				GGM     					= conexion.consultaUno(letra)
				TGGM 						= TGGM + cint(GGM)
				suma_graduados_po_mujeres	= TGGM
			end if
		end if
	end if	
wend	
'*********************************************************'-------------------------
'**						TOTALES							**'
'*********************************************************'
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
            "select distinct e.facu_ccod,c.carr_ccod,c.carr_tdesc  																"& vbCrLf &_
			"            from alumnos_salidas_carrera a (nolock),   															"& vbCrLf &_
			"            salidas_carrera b (nolock), carreras c (nolock),   													"& vbCrLf &_
			"            areas_academicas d, facultades e,personas f (nolock)  													"& vbCrLf &_
			"            where a.saca_ncorr = b.saca_ncorr and b.carr_ccod=c.carr_ccod  										"& vbCrLf &_
			"            and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   												"& vbCrLf &_
			"            and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (1,2,5)  												"& vbCrLf &_
			"            and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "&filtro_carreras&filtro_facultad"					"& vbCrLf &_
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
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0"> 
   <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
      <br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array( EncodeUTF8("Distribución por carreras") ), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <% EncodeUTF8(pagina.DibujarTituloPagina) %>
			  </div>
<%	fecha1	= conexion.consultaUno("select getDate()")	%>
<div id="fecha">
	<table>
		<tr>
			<td style="border-bottom:solid; border-bottom-color:#666;" width="77%" align="left"><strong><%response.Write("Fecha y hora: "&fecha1)%></strong></td>
		</tr>
	</table>
</div>                
            </td>
		  </tr>         
		  <tr>
            <td align="right" height="30">&nbsp;</td>
		  </tr>
		  <form name="edicion" method="post">
		  <tr>
		  	<td align="center">
				<script language='javaScript1.2'> colores = Array(3);   colores[0] = ''; colores[1] = '#FFECC6'; colores[2] = '#FFECC6'; </script>
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
					carrera   = EncodeUTF8(f_lista.obtenerValor("carr_tdesc"))'nombre carrera 
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
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UEG&sexo_ccod=3&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=auxTotalEUHM%></td>
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
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UEG&sexo_ccod=3&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=auxTotalTUHM%></td>
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
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UEG&sexo_ccod=3&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=auxTotalGPHM%></td>
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
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=SIE&sexo_ccod=3&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=auxTotalESHM%></td>
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
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=SIT&sexo_ccod=3&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=auxTotalTSHM%></td>
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
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UEG&sexo_ccod=3&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=auxTotalGGHM%></td>
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
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UEG&sexo_ccod=3&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=auxTotalEIHM%></td>
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
				<td align='CENTER' class='click' onClick='irA2("estadisticasEgresoTitulacion/vistas/resultado_3.asp?femenino=<%=femenino%>&salidas_int=<%=salidas_int%>&graduados=<%=graduados%>&titulados=<%=titulados%>&egresados=<%=egresados%>&masculino=<%=masculino%>&instituto=<%=instituto%>&upa_postgrado=<%=upa_postgrado%>&upa_pregrado=<%=upa_pregrado%>&selectAnioPromo=<%=selectAnioPromo%>&selectAnioEgre=<%=selectAnioEgre%>&selectAnioTitu=<%=selectAnioTitu%>&sede_ccod=<%=sede_ccod%>&tipo=UEG&sexo_ccod=3&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=auxTotalTIHM%></td>
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
			</td>
		  </tr>
		    <input type="hidden" name="sede" value="<%=sede_tdesc%>">
		    <input type="hidden" name="registros" value="<%=num%>">
		  </form>
		  <tr>
            <td align="right">* Presione sobre el n&uacute;mero de inter&eacute;s para visualizar el dato a un detalle mayor.</td>
		  </tr>
		  <tr>
            <td align="right" height="50">&nbsp;</td>
		  </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="18%" height="20"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td><div align="center"><%botonera.dibujaBoton "volver"%></div></td>
						<td><div id="botonDoc" align="center">
						    <% 
							   url_2 = "estadisticasEgresoTitulacion/excels/estadisticas_egreso_titulacion_carreras_excel.asp?sede_ccod="&E_sede_ccod &"&tipo="&E_tipo&"&sexo_ccod="&E_sexo_ccod&"&institucion="&E_institucion&"&facu_ccod="&E_facu_ccod&"&carr_ccod="&E_carr_ccod&"&selectAnioPromo="&selectAnioPromo&"&selectAnioEgre="&selectAnioEgre&"&selectAnioTitu="&selectAnioTitu
 							   botonera.agregaBotonParam "excel_2","funcion","abreEcxel('"&url_2&"')"
							   botonera.dibujaBoton "excel_2"
							%>
							</div>
						</td>	
                        <td><div id="botonReportePrincipal" align="center">
						     <% 
							  url_2 = "estadisticasEgresoTitulacion/excels/gran_detalle_2.asp?sede_ccod="&E_sede_ccod&"&upa_pregrado="&upa_pregrado&"&upa_postgrado="&upa_postgrado&"&instituto="&instituto&"&egresados="&egresados&"&titulados="&titulados&"&graduados="&graduados&"&salidas_int="&salidas_int&"&femenino="&femenino&"&masculino="&masculino&"&facu_ccod="&E_facu_ccod&"&carr_ccod="&E_carr_ccod&"&selectAnioPromo="&selectAnioPromo&"&selectAnioEgre="&selectAnioEgre&"&selectAnioTitu="&selectAnioTitu
 							'   'response.Write(url_2)
							   botonera.agregaBotonParam "excel_general","funcion","abreEcxel('"&url_2&"')"
							   botonera.dibujaBoton "excel_general"
							%>
							</div>
						</td>				
                      </tr>
                    </table>
            </div></td>
            <td width="82%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
