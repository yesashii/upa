<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "presupuesto/funciones/funciones.asp" -->

<%
Response.Buffer = False
Response.addHeader "pragma", "no-cache"
Response.CacheControl = "Private"
Response.Expires = 0

sin_bloqueo=true '(con false bloquea las nuevas solicitudes)
'sin_bloqueo=true '(Habilita las nuevas solicitudes)

Server.ScriptTimeout = 2000
set pagina = new CPagina
pagina.Titulo = "Ingreso de presupuesto 2016"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set conexion2 = new CConexion2
conexion2.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
v_usuario = negocio.ObtenerUsuario()
'response.Write("Usuario: "&Usuario)

'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "solicitud_presupuestaria.xml", "botonera"
'-----------------------------------------------------------------------

codcaja	   = request.querystring("busqueda[0][codcaja]")
area_ccod	 = request.querystring("busqueda[0][area_ccod]")
mes_venc	 = request.querystring("busqueda[0][mes_venc]")
nro_t		   = request.querystring("nro_t")
v_concepto = request.querystring("busqueda[0][concepto]")
v_detalle  = request.querystring("busqueda[0][detalle]")

 if codcaja="" then
	 codcaja= request.querystring("codcaja")
 end if

 if area_ccod="" then
	 area_ccod= request.querystring("area_ccod")
 end if

 v_anio_actual	= conexion2.ConsultaUno("select year(getdate())")
 v_prox_anio	=	v_anio_actual+1
 'v_prox_anio	=	v_anio_actual ' se agrego por que el 2010 el presupuesto paso de a?o y deben seguir entrando al 2011

 'response.Write(" v_anio_actual: "&v_anio_actual&" v_prox_anio:"&v_prox_anio)

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "solicitud_presupuestaria.xml", "busqueda_presupuesto"
 f_busqueda.Inicializar conexion2
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente

 f_busqueda.AgregaCampoParam "area_ccod", "filtro",  "area_ccod in ( select area_ccod from  presupuesto_upa.protic.area_presupuesto_usuario  where rut_usuario in ('"&v_usuario&"') )"
 f_busqueda.AgregaCampoCons "area_ccod", area_ccod

 f_busqueda.AgregaCampoParam "codcaja", "destino",  " (select distinct cpre_orden,cod_pre, concepto_pre +' ('+cod_pre+')' as valor from presupuesto_upa.protic.codigos_presupuesto where cpre_bestado in (1) and cod_area in ('"&area_ccod&"') ) a "
 f_busqueda.AgregaCampoCons "codcaja", codcaja
 f_busqueda.AgregaCampoCons "detalle", v_detalle
'f_busqueda.AgregaCampoCons "concepto", v_concepto

 'response.Write("select distinct cod_pre, concepto_pre +' ('+cod_pre+')' as valor from presupuesto_upa.protic.codigos_presupuesto where cpre_bestado in (1) and cod_area in ('"&area_ccod&"') ) a ")

' Bloquea la caja de texto para ingresar un nuevo detalle mientras esta algun detalle seleccionado
if v_detalle<>""  and codcaja <> "" then
	f_busqueda.AgregaCampoCons "nuevo_detalle", "-Bloqueado-"
	mostrar_agregar=false
end if


if v_detalle=""  and codcaja <> "" then
	f_busqueda.AgregaCampoParam "nuevo_detalle", "deshabilitado", "false"
	f_busqueda.AgregaCampoCons "nuevo_detalle", ""
	mostrar_agregar=true
else
	f_busqueda.AgregaCampoCons "nuevo_detalle", "-Bloqueado-"
	mostrar_agregar=false
end if

'Activa filtros si se ha seleccionado un codigo presupuestario
 if codcaja <>"" then
	 'f_busqueda.AgregaCampoParam "concepto", "destino",  " (select distinct cod_pre,concepto_pre from presupuesto_upa.protic.codigos_presupuesto) a "
	 'f_busqueda.AgregaCampoParam "concepto", "filtro",  " cod_pre in ('"&codcaja&"') "

	 f_busqueda.AgregaCampoParam "detalle", "destino",  " (select distinct cpre_ncorr,cod_pre,concepto_pre, detalle_pre from presupuesto_upa.protic.codigos_presupuesto where cpre_bestado in (1) ) a "
	 f_busqueda.AgregaCampoParam "detalle", "filtro",  " cod_pre in ('"&codcaja&"') "

	 txt_detalle= conexion2.ConsultaUno("select detalle_pre from presupuesto_upa.protic.codigos_presupuesto where cast(cpre_ncorr as varchar)='"&v_detalle&"'")
 else
    'f_busqueda.AgregaCampoParam "concepto", "destino",  " (select '' as cod_pre, '' as concepto_pre where 1=1 ) a "
	'f_busqueda.AgregaCampoParam "concepto", "deshabilitado", "true"
    f_busqueda.AgregaCampoParam "detalle", "destino",  " (select '' as cpre_ncorr,'' as cod_pre,'' as concepto_pre, '' as detalle_pre where 1=1 ) a "
	f_busqueda.AgregaCampoParam "detalle", "deshabilitado", "true"
 end if

	if codcaja<>""  and area_ccod <> "" and v_detalle <> "" then

				if txt_detalle <>"" then
					str_detalle="and detalle='"&txt_detalle&"'"
				end if

		sql_tpre_ccod= "select max(tpre_ccod) as  tpre_ccod "& vbCrLf &_
				"				from presupuesto_upa.protic.solicitud_presupuesto_upa  "& vbCrLf &_
				"				where cod_pre='"&codcaja&"' "& vbCrLf &_
				"				and cod_area="&area_ccod&" "& vbCrLf &_
				"				"&str_concepto&" "& vbCrLf &_
				"				"&str_detalle&" "& vbCrLf &_
				"				and cod_anio=year(getdate())+1 "

		'response.Write(sql_tpre_ccod)

		v_tpre_ccod= conexion2.consultaUno(sql_tpre_ccod)
	end if

'response.Write("tipo: "&v_tpre_ccod)
	f_busqueda.AgregaCampoCons "tpre_ccod", v_tpre_ccod
'----------------------------------------------------------------------------


 set f_presupuesto = new CFormulario
 f_presupuesto.Carga_Parametros "solicitud_presupuestaria.xml", "f_presupuesto"
 f_presupuesto.Inicializar conexion2

   if Request.QueryString <> "" then

	  if nro_t="" then
	  	nro_t=1
	  end if

	select case (nro_t)

		case 1:

			if mes_venc <> "" then
				sql_mes= "and month(movfv)="&mes_venc
				nombre_mes=conexion2.consultauno("select nombremes from softland.sw_mesce where indice="&mes_venc&"")

				if mes_venc=0 then
					nombre_mes= "TODOS LOS MESES"
					sql_mes=""
				end if

			end if


			if codcaja <> "" then
					'######################## por codigo	###################
				consulta_prespuesto="select  month(movfv) as mes_venc,* from softland.cwmovim " & vbCrLf &_
								" where year(movfv)=year(getdate()) " & vbCrLf &_
								" and movhaber <> 0 " & vbCrLf &_
								" and cpbnum>0 "& vbCrLf &_
								" and pctcod like '2-10-070-10-000003' "& vbCrLf &_
								" "&sql_mes&" "& vbCrLf &_
								" and cajcod='"&codcaja&"' "


'				if v_concepto <>"" then
'					str_concepto="and concepto='"&v_concepto&"'"
'				end if

				if txt_detalle <>"" then
					str_detalle="and detalle='"&txt_detalle&"'"
				end if

				sql_meses=  " select  upper(nombremes) as mes,indice as mes_venc,sum(cast(isnull(solicitado,0) as numeric)) as solicitado,   "& vbCrLf &_
							" sum(cast(isnull(presupuestado,0) as numeric)) as presupuestado "& vbCrLf &_
							"	 from softland.sw_mesce as b   "& vbCrLf &_
							"	 left outer join (  "& vbCrLf &_
							"		select pa.mes as mes, sum(solicitado) as solicitado,sum(presupuestado) as presupuestado "& vbCrLf &_
							"			from     	"& vbCrLf &_
							"				( 		"& vbCrLf &_
							"				select sum(valor) as presupuestado,0 as solicitado,mes,cod_anio, cod_pre, cod_area, descripcion_area,concepto "& vbCrLf &_
							"				from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2013     "& vbCrLf &_
							"				where cod_pre='"&codcaja&"' "& vbCrLf &_
							"				and cod_area="&area_ccod&" "& vbCrLf &_
							"				"&str_concepto&" "& vbCrLf &_
							"				"&str_detalle&" "& vbCrLf &_
							"				and cod_anio=year(getdate()) "& vbCrLf &_
							"				group by mes,cod_anio, cod_pre, cod_area, descripcion_area,concepto  "& vbCrLf &_
							"			Union "& vbCrLf &_
							"				select 0 as presupuestado,sum(valor) as solicitado,mes,cod_anio, cod_pre, cod_area, descripcion_area,concepto "& vbCrLf &_
							"				from presupuesto_upa.protic.vis_solicitud_presupuesto_anual  "& vbCrLf &_
							"				where cod_pre='"&codcaja&"' "& vbCrLf &_
							"				and cod_area="&area_ccod&" "& vbCrLf &_
							"				"&str_concepto&" "& vbCrLf &_
							"				"&str_detalle&" "& vbCrLf &_
							"				and cod_anio=year(getdate())+1 "& vbCrLf &_
							"				group by mes,cod_anio, cod_pre, cod_area, descripcion_area,concepto  "& vbCrLf &_
							"				) as pa "& vbCrLf &_
							"			group by pa.mes   "& vbCrLf &_
							"	)as a  "& vbCrLf &_
							"on indice=mes  "& vbCrLf &_
						"group by nombremes,indice "


					sql_total_gastado=	"select  isnull(sum(cast(movhaber as numeric)),0) as total from softland.cwmovim " & vbCrLf &_
								" where year(movfv)=year(getdate()) " & vbCrLf &_
								" and movhaber <> 0 " & vbCrLf &_
								" and cpbnum>0 "& vbCrLf &_
								" and pctcod like '2-10-070-10-000003' "& vbCrLf &_
								" "&sql_mes&" "& vbCrLf &_
								" and cajcod='"&codcaja&"' "


			else
				'######################## por area	###################
				consulta_prespuesto="select  month(movfv) as mes_venc,* from softland.cwmovim " & vbCrLf &_
						" where year(movfv)=year(getdate()) " & vbCrLf &_
						" and movhaber <> 0 " & vbCrLf &_
						" and cpbnum>0 "& vbCrLf &_
						" and pctcod like '2-10-070-10-000003' "& vbCrLf &_
						" "&sql_mes&" "& vbCrLf &_
						" and cajcod COLLATE SQL_Latin1_General_CP1_CI_AS in (select distinct cod_pre from presupuesto_upa.protic.vis_presupuesto_anual where cod_area="&area_ccod&") "


				sql_meses= "	select  upper(nombremes) as mes,indice as mes_venc,sum(cast(isnull(solicitado,0) as numeric)) as solicitado,   "& vbCrLf &_
							" sum(cast(isnull(presupuestado,0) as numeric)) as presupuestado "& vbCrLf &_
							"	 from softland.sw_mesce as b   "& vbCrLf &_
							"	 left outer join (  "& vbCrLf &_
							"		select pa.mes as mes, sum(solicitado) as solicitado,sum(presupuestado) as presupuestado "& vbCrLf &_
							"			from     "& vbCrLf &_
							"				(select sum(valor) as presupuestado,0 as solicitado,mes,cod_anio,cod_area, descripcion_area "& vbCrLf &_
							"				from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2013     "& vbCrLf &_
							"				where cod_pre in (select distinct cod_pre from presupuesto_upa.protic.vis_presupuesto_anual where cod_area= "&area_ccod&" ) "& vbCrLf &_
							"				and cod_anio=year(getdate()) "& vbCrLf &_
							"				group by mes,cod_anio, cod_area, descripcion_area  "& vbCrLf &_
							"			union "& vbCrLf &_
							"				select 0 as presupuestado,sum(valor) as solicitado,mes,cod_anio, cod_area, descripcion_area "& vbCrLf &_
							"				from presupuesto_upa.protic.vis_solicitud_presupuesto_anual  "& vbCrLf &_
							"				where cod_pre in (select distinct cod_pre from presupuesto_upa.protic.vis_presupuesto_anual where cod_area= "&area_ccod&" )  "& vbCrLf &_
							"				and cod_anio=year(getdate())+1 "& vbCrLf &_
							"				group by mes,cod_anio, cod_area, descripcion_area "& vbCrLf &_
							"				) as pa "& vbCrLf &_
							"			group by pa.mes   "& vbCrLf &_
							"	)as a  "& vbCrLf &_
							"on indice=mes  "& vbCrLf &_
						"group by nombremes,indice "


			sql_total_gastado=	"select  isnull(sum(cast(movhaber as numeric)),0) as total from softland.cwmovim " & vbCrLf &_
								" where year(movfv)=year(getdate()) " & vbCrLf &_
								" and movhaber <> 0 " & vbCrLf &_
								" and cpbnum>0 "& vbCrLf &_
								" and pctcod like '2-10-070-10-000003' "& vbCrLf &_
								" "&sql_mes&" "& vbCrLf &_
								" and cajcod COLLATE SQL_Latin1_General_CP1_CI_AS in (select distinct cod_pre from presupuesto_upa.protic.vis_presupuesto_anual where cod_area="&area_ccod&") "


			end if
		'response.Write("<pre>"&sql_meses&"</pre>")
			f_presupuesto.consultar consulta_prespuesto

			v_total_gastado	= conexion2.consultaUno(sql_total_gastado)

			if v_total_gastado="" then
				v_total_gastado=0
			end if
		   'response.Write("<pre>"&sql_total_gastado&"</pre>")

			set f_meses = new CFormulario
			f_meses.Carga_Parametros "solicitud_presupuestaria.xml", "solicitud"
			f_meses.Inicializar conexion2

			f_meses.consultar sql_meses

		case 2:
			anio = "2016"
			set f_presupuestado = new CFormulario
			f_presupuestado.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			f_presupuestado.Inicializar conexion
			if codcaja = "" then
				filtro_codcaja = "where area_ccod='"&area_ccod&"' and anio = "&anio&" "
			else
			    filtro_codcaja = "where cod_pre = '"&codcaja&"' and anio = "&anio&" "
			end if

			sql_presupuestado	="" & vbCrLf & _
			"select cod_pre,                      " & vbCrLf & _
			"       area_ccod,                    " & vbCrLf & _
			"       detalle,   	                  " & vbCrLf & _
			"       eje_ccod,                     " & vbCrLf & _
			"       foco_ccod,                    " & vbCrLf & _
			"       prog_ccod,                    " & vbCrLf & _
			"       proye_ccod,                   " & vbCrLf & _
			"       obje_ccod,                    " & vbCrLf & _
			"       tipo_gasto,                   " & vbCrLf & _
			"       anio,                         " & vbCrLf & _
			"       ene,                          " & vbCrLf & _
			"       feb,                          " & vbCrLf & _
			"       mar,                          " & vbCrLf & _
			"       abr,                          " & vbCrLf & _
			"       may,                          " & vbCrLf & _
			"       jun,                          " & vbCrLf & _
			"       jul,                          " & vbCrLf & _
			"       ago,                          " & vbCrLf & _
			"       sep,                          " & vbCrLf & _
			"       octu,                         " & vbCrLf & _
			"       nov,                          " & vbCrLf & _
			"       dic,                          " & vbCrLf & _
			"       total                         " & vbCrLf & _
			"from   presupuesto_directo_area_desa "&filtro_codcaja&"   "
			'response.write("<pre>"&sql_presupuestado&"</pre>")
			'response.end()
			f_presupuestado.consultar sql_presupuestado


'-----------------------------------------
'--		PESTA?A SOLICITUD CENTRALIZADA	--
'------------------------------------------------------------------------------------------------>>
case 3:
	set f_solicitado = new CFormulario
	f_solicitado.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
	f_solicitado.Inicializar conexion2

	set f_aprobados = new CFormulario
	f_aprobados.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
	f_aprobados.Inicializar conexion2

	select case (area_ccod)
		'---------------------------------
		'--		Direcci?n de docencia	--
		'------------------------------------------------------------------------------------------->>
		case 27:
		sql_solicitud=""& vbCrLf &_
					"select *,                                                           "& vbCrLf &_
					"       case a.esol_ccod                                             "& vbCrLf &_
					"              when 1 then 'Dar Alta'                                "& vbCrLf &_
					"       end as accion,                                               "& vbCrLf &_
					"       nombremes                                                    "& vbCrLf &_
					"from   presupuesto_upa.protic.centralizar_solicitud_dir_docencia a, "& vbCrLf &_
					"       presupuesto_upa.protic.concepto_centralizado b,              "& vbCrLf &_
					"       presupuesto_upa.protic.estado_solicitud c,                   "& vbCrLf &_
					"       softland.sw_mesce d,                                         "& vbCrLf &_
					"       presupuesto_upa.protic.area_presupuestal x                   "& vbCrLf &_
					"where  a.tpre_ccod in (6)                                           "& vbCrLf &_
					"and    a.tpre_ccod=b.tpre_ccod                                      "& vbCrLf &_
					"and    a.ccen_ccod=b.ccen_ccod                                      "& vbCrLf &_
					"and    a.esol_ccod=c.esol_ccod                                      "& vbCrLf &_
					"and    isnull(mes_ccod,1)=d.indice                                  "& vbCrLf &_
					"and    a.esol_ccod not in (2,3)                                     "& vbCrLf &_
					"and    a.area_ccod= x.area_ccod                                     "& vbCrLf &_
					"and    anio_ccod="&v_prox_anio&"                                    "

		sql_aprobadas=""& vbCrLf &_
					"select *                                                            "& vbCrLf &_
					"from   presupuesto_upa.protic.centralizar_solicitud_dir_docencia a, "& vbCrLf &_
					"       presupuesto_upa.protic.concepto_centralizado b,              "& vbCrLf &_
					"       presupuesto_upa.protic.estado_solicitud c,                   "& vbCrLf &_
					"       softland.sw_mesce d,                                         "& vbCrLf &_
					"       presupuesto_upa.protic.area_presupuestal x                   "& vbCrLf &_
					"where  a.tpre_ccod in (6)                                           "& vbCrLf &_
					"and    a.tpre_ccod=b.tpre_ccod                                      "& vbCrLf &_
					"and    a.ccen_ccod=b.ccen_ccod                                      "& vbCrLf &_
					"and    a.esol_ccod=c.esol_ccod                                      "& vbCrLf &_
					"and    isnull(mes_ccod,1)=d.indice                                  "& vbCrLf &_
					"and    a.esol_ccod in (2)                                           "& vbCrLf &_
					"and    a.area_ccod= x.area_ccod                                     "& vbCrLf &_
					"and    anio_ccod="&v_prox_anio&"                                    "
		'Debug --------------->>
		'solicitado
		'response.write("<pre>"&sql_solicitud&"</pre>")
		'response.end()

		'aprobado
		'response.write("<pre>"&sql_aprobadas&"</pre>")
		'response.end()
		'Debug ---------------<<
		'------------------------------------------------------------------------------------------>>
		'--		Direcci?n de docencia	--
		'---------------------------------

		'-------------------------------------
		'--		departamento Audiovisual	--
		'------------------------------------------------------------------------------------------->>
		case 60:
			sql_solicitud=""& vbCrLf &_
						"select *,                                                          "& vbCrLf &_
						"       case a.esol_ccod                                            "& vbCrLf &_
						"              when 1 then 'Dar Alta'                               "& vbCrLf &_
						"       end as accion,                                              "& vbCrLf &_
						"       nombremes                                                   "& vbCrLf &_
						"from   presupuesto_upa.protic.centralizar_solicitud_audiovisual a, "& vbCrLf &_
						"       presupuesto_upa.protic.concepto_centralizado b,             "& vbCrLf &_
						"       presupuesto_upa.protic.estado_solicitud c,                  "& vbCrLf &_
						"       presupuesto_upa.protic.area_presupuestal d,                 "& vbCrLf &_
						"       softland.sw_mesce e                                         "& vbCrLf &_
						"where  a.tpre_ccod in (1)                                          "& vbCrLf &_
						"and    a.tpre_ccod=b.tpre_ccod                                     "& vbCrLf &_
						"and    a.ccen_ccod=b.ccen_ccod                                     "& vbCrLf &_
						"and    a.esol_ccod=c.esol_ccod                                     "& vbCrLf &_
						"and    a.area_ccod=d.area_ccod                                     "& vbCrLf &_
						"and    isnull(mes_ccod,1)=e.indice                                 "& vbCrLf &_
						"and    a.esol_ccod=1                                               "& vbCrLf &_
						"and    anio_ccod="&v_prox_anio&"                                   "

			sql_aprobadas=""& vbCrLf &_
						"select *,                                                          "& vbCrLf &_
						"       case a.esol_ccod                                            "& vbCrLf &_
						"              when 1 then 'Dar Alta'                               "& vbCrLf &_
						"       end as accion ,                                             "& vbCrLf &_
						"       nombremes                                                   "& vbCrLf &_
						"from   presupuesto_upa.protic.centralizar_solicitud_audiovisual a, "& vbCrLf &_
						"       presupuesto_upa.protic.concepto_centralizado b,             "& vbCrLf &_
						"       presupuesto_upa.protic.estado_solicitud c,                  "& vbCrLf &_
						"       presupuesto_upa.protic.area_presupuestal d,                 "& vbCrLf &_
						"       softland.sw_mesce e                                         "& vbCrLf &_
						"where  a.tpre_ccod in (1)                                          "& vbCrLf &_
						"and    a.tpre_ccod=b.tpre_ccod                                     "& vbCrLf &_
						"and    a.ccen_ccod=b.ccen_ccod                                     "& vbCrLf &_
						"and    a.esol_ccod=c.esol_ccod                                     "& vbCrLf &_
						"and    a.area_ccod=d.area_ccod                                     "& vbCrLf &_
						"and    isnull(mes_ccod,1)=e.indice                                 "& vbCrLf &_
						"and    a.esol_ccod not in (1,3)                                    "& vbCrLf &_
						"and    anio_ccod="&v_prox_anio&"                                   "
		'	Debug --------------->>
		' solicitado
		'response.write("<pre>"&sql_solicitud&"</pre>")
		'response.end()

		' aprobado
		'response.write("<pre>"&sql_aprobadas&"</pre>")
		'response.end()
		'	Debug ---------------<<
		'------------------------------------------------------------------------------------------->>
		'--		departamento Audiovisual	--
		'-------------------------------------

		'---------------------------------
		'--		direcci?n de biblioteca	--
		'------------------------------------------------------------------------------------------->>
		case 99:
			sql_solicitud=""& vbCrLf &_
						"select *,                                                          "& vbCrLf &_
						"       case a.esol_ccod                                            "& vbCrLf &_
						"              when 1 then 'Dar Alta'                               "& vbCrLf &_
						"       end as accion,                                              "& vbCrLf &_
						"       nombremes                                                   "& vbCrLf &_
						"from   presupuesto_upa.protic.centralizar_solicitud_biblioteca a,  "& vbCrLf &_
						"       presupuesto_upa.protic.concepto_centralizado b,             "& vbCrLf &_
						"       presupuesto_upa.protic.estado_solicitud c,                  "& vbCrLf &_
						"       presupuesto_upa.protic.area_presupuestal d,                 "& vbCrLf &_
						"       softland.sw_mesce e                                         "& vbCrLf &_
						"where  a.tpre_ccod in (2)                                          "& vbCrLf &_
						"and    a.tpre_ccod=b.tpre_ccod                                     "& vbCrLf &_
						"and    a.ccen_ccod=b.ccen_ccod                                     "& vbCrLf &_
						"and    a.esol_ccod=c.esol_ccod                                     "& vbCrLf &_
						"and    a.area_ccod=d.area_ccod                                     "& vbCrLf &_
						"and    isnull(mes_ccod,1)=e.indice                                 "& vbCrLf &_
						"and    a.esol_ccod=1                                               "& vbCrLf &_
						"and    anio_ccod="&v_prox_anio&"                                   "


			sql_aprobadas=""& vbCrLf &_
						"select *,                                                         "& vbCrLf &_
						"       case a.esol_ccod                                           "& vbCrLf &_
						"              when 1 then 'Dar Alta'                              "& vbCrLf &_
						"       end as accion,                                             "& vbCrLf &_
						"       nombremes                                                  "& vbCrLf &_
						"from   presupuesto_upa.protic.centralizar_solicitud_biblioteca a, "& vbCrLf &_
						"       presupuesto_upa.protic.concepto_centralizado b,            "& vbCrLf &_
						"       presupuesto_upa.protic.estado_solicitud c,                 "& vbCrLf &_
						"       presupuesto_upa.protic.area_presupuestal d,                "& vbCrLf &_
						"       softland.sw_mesce e                                        "& vbCrLf &_
						"where  a.tpre_ccod in (2)                                         "& vbCrLf &_
						"and    a.tpre_ccod=b.tpre_ccod                                    "& vbCrLf &_
						"and    a.ccen_ccod=b.ccen_ccod                                    "& vbCrLf &_
						"and    a.esol_ccod=c.esol_ccod                                    "& vbCrLf &_
						"and    a.area_ccod=d.area_ccod                                    "& vbCrLf &_
						"and    isnull(mes_ccod,1)=e.indice                                "& vbCrLf &_
						"and    a.esol_ccod not in (1,3)                                   "& vbCrLf &_
						"and    anio_ccod="&v_prox_anio&"                                  "
		'	Debug --------------->>
		' solicitado
		'response.write("<pre>"&sql_solicitud&"</pre>")
		'response.end()

		' aprobado
		'response.write("<pre>"&sql_aprobadas&"</pre>")
		'response.end()
		'	Debug ---------------<<
		'------------------------------------------------------------------------------------------->>
		'--		direcci?n de biblioteca	--
		'---------------------------------
		'-------------------------------------------------
		'--		DIRECCION TECNOLOGIA DE LA INFORMACION	--
		'------------------------------------------------------------------------------------------->>
			case 15:
				sql_solicitud=""& vbCrLf &_
							"select *,                                                          "& vbCrLf &_
							"       case a.esol_ccod                                            "& vbCrLf &_
							"              when 1 then 'Dar Alta'                               "& vbCrLf &_
							"       end as accion,                                              "& vbCrLf &_
							"       nombremes                                                   "& vbCrLf &_
							"from   presupuesto_upa.protic.centralizar_solicitud_computacion a, "& vbCrLf &_
							"       presupuesto_upa.protic.concepto_centralizado b,             "& vbCrLf &_
							"       presupuesto_upa.protic.estado_solicitud c,                  "& vbCrLf &_
							"       presupuesto_upa.protic.area_presupuestal d,                 "& vbCrLf &_
							"       softland.sw_mesce e                                         "& vbCrLf &_
							"where  a.tpre_ccod in (3)                                          "& vbCrLf &_
							"and    a.tpre_ccod=b.tpre_ccod                                     "& vbCrLf &_
							"and    a.ccen_ccod=b.ccen_ccod                                     "& vbCrLf &_
							"and    a.esol_ccod=c.esol_ccod                                     "& vbCrLf &_
							"and    a.area_ccod=d.area_ccod                                     "& vbCrLf &_
							"and    isnull(mes_ccod,1)=e.indice                                 "& vbCrLf &_
							"and    a.esol_ccod=1                                               "& vbCrLf &_
							"and    anio_ccod="&v_prox_anio&"                                   "

				sql_aprobadas=""& vbCrLf &_
							"select *,                                                          "& vbCrLf &_
							"       case a.esol_ccod                                            "& vbCrLf &_
							"              when 1 then 'Dar Alta'                               "& vbCrLf &_
							"       end as accion,                                              "& vbCrLf &_
							"       nombremes                                                   "& vbCrLf &_
							"from   presupuesto_upa.protic.centralizar_solicitud_computacion a, "& vbCrLf &_
							"       presupuesto_upa.protic.concepto_centralizado b,             "& vbCrLf &_
							"       presupuesto_upa.protic.estado_solicitud c,                  "& vbCrLf &_
							"       presupuesto_upa.protic.area_presupuestal d,                 "& vbCrLf &_
							"       softland.sw_mesce e                                         "& vbCrLf &_
							"where  a.tpre_ccod in (3)                                          "& vbCrLf &_
							"and    a.tpre_ccod=b.tpre_ccod                                     "& vbCrLf &_
							"and    a.ccen_ccod=b.ccen_ccod                                     "& vbCrLf &_
							"and    a.esol_ccod=c.esol_ccod                                     "& vbCrLf &_
							"and    a.area_ccod=d.area_ccod                                     "& vbCrLf &_
							"and    isnull(mes_ccod,1)=e.indice                                 "& vbCrLf &_
							"and    a.esol_ccod not in (1,3)                                    "& vbCrLf &_
							"and    anio_ccod="&v_prox_anio&"                                   "
		'	Debug --------------->>
		' solicitado
		'response.write("<pre>"&sql_solicitud&"</pre>")
		'response.end()

		' aprobado
		'response.write("<pre>"&sql_aprobadas&"</pre>")
		'response.end()
		'	Debug ---------------<<
		'------------------------------------------------------------------------------------------->>
		'--		DIRECCION TECNOLOGIA DE LA INFORMACION	--
		'-------------------------------------------------
		'-------------------------------------
		'--		PPTO SERVICIOS GENERALES 	--
		'------------------------------------------------------------------------------------------->>
		case 77,78,79,80:
			select case area_ccod
				case 77:
					'response.Write("Baquedano")
					v_sede_ccod=8
				case 78:
					'response.Write("Las Condes")
					v_sede_ccod=1
				case 79:
					'response.Write("Lyon")
					v_sede_ccod=2
				case 80:
					'response.Write("Melipilla")
					v_sede_ccod=4
				case else
					v_sede_ccod=1
				end select

				sql_solicitud=""& vbCrLf &_
							"select *,                                                                  "& vbCrLf &_
							"       case a.esol_ccod                                                    "& vbCrLf &_
							"              when 1 then 'Dar Alta'                                       "& vbCrLf &_
							"       end as accion,                                                      "& vbCrLf &_
							"       nombremes                                                           "& vbCrLf &_
							"from   presupuesto_upa.protic.centralizar_solicitud_servicios_generales a, "& vbCrLf &_
							"       presupuesto_upa.protic.concepto_centralizado b,                     "& vbCrLf &_
							"       presupuesto_upa.protic.estado_solicitud c,                          "& vbCrLf &_
							"       presupuesto_upa.protic.area_presupuestal d,                         "& vbCrLf &_
							"       softland.sw_mesce e                                                 "& vbCrLf &_
							"where  a.tpre_ccod in (4)                                                  "& vbCrLf &_
							"and    a.tpre_ccod=b.tpre_ccod                                             "& vbCrLf &_
							"and    a.ccen_ccod=b.ccen_ccod                                             "& vbCrLf &_
							"and    a.esol_ccod=c.esol_ccod                                             "& vbCrLf &_
							"and    a.area_ccod=d.area_ccod                                             "& vbCrLf &_
							"and    isnull(mes_ccod,1)=e.indice                                         "& vbCrLf &_
							"and    isnull(a.sede_ccod,1)="&v_sede_ccod&"                               "& vbCrLf &_
							"and    a.esol_ccod=1                                                       "& vbCrLf &_
							"and    anio_ccod="&v_prox_anio&"                                           "

				sql_aprobadas=""& vbCrLf &_
							"select *,                                                                  "& vbCrLf &_
							"       case a.esol_ccod                                                    "& vbCrLf &_
							"              when 1 then 'Dar Alta'                                       "& vbCrLf &_
							"       end as accion,                                                      "& vbCrLf &_
							"       nombremes                                                           "& vbCrLf &_
							"from   presupuesto_upa.protic.centralizar_solicitud_servicios_generales a, "& vbCrLf &_
							"       presupuesto_upa.protic.concepto_centralizado b,                     "& vbCrLf &_
							"       presupuesto_upa.protic.estado_solicitud c,                          "& vbCrLf &_
							"       presupuesto_upa.protic.area_presupuestal d,                         "& vbCrLf &_
							"       softland.sw_mesce e                                                 "& vbCrLf &_
							"where  a.tpre_ccod in (4)                                                  "& vbCrLf &_
							"and    a.tpre_ccod=b.tpre_ccod                                             "& vbCrLf &_
							"and    a.ccen_ccod=b.ccen_ccod                                             "& vbCrLf &_
							"and    a.esol_ccod=c.esol_ccod                                             "& vbCrLf &_
							"and    a.area_ccod=d.area_ccod                                             "& vbCrLf &_
							"and    isnull(mes_ccod,1)=e.indice                                         "& vbCrLf &_
							"and    isnull(a.sede_ccod,1)="&v_sede_ccod&"                               "& vbCrLf &_
							"and    a.esol_ccod not in (1,3)                                            "& vbCrLf &_
							"and    anio_ccod="&v_prox_anio&"                                           "
		'	Debug --------------->>
		' solicitado
		'response.write("<pre>"&sql_solicitud&"</pre>")
		'response.end()

		' aprobado
		'response.write("<pre>"&sql_aprobadas&"</pre>")
		'response.end()
		'	Debug ---------------<<
		'------------------------------------------------------------------------------------------->>
		'--		PPTO SERVICIOS GENERALES 	--
		'-------------------------------------
		'-------------------------------------
		'--		DIRECCION RECURSOS HUMANOS 	--
		'------------------------------------------------------------------------------------------->>
		case 125:
			sql_solicitud=""& vbCrLf &_
						"select *,                                                       "& vbCrLf &_
						"       case a.esol_ccod                                         "& vbCrLf &_
						"              when 1 then 'Dar Alta'                            "& vbCrLf &_
						"       end as accion,                                           "& vbCrLf &_
						"       nombremes                                                "& vbCrLf &_
						"from   presupuesto_upa.protic.centralizar_solicitud_personal a, "& vbCrLf &_
						"       presupuesto_upa.protic.concepto_centralizado b,          "& vbCrLf &_
						"       presupuesto_upa.protic.estado_solicitud c,               "& vbCrLf &_
						"       presupuesto_upa.protic.area_presupuestal d,              "& vbCrLf &_
						"       softland.sw_mesce e                                      "& vbCrLf &_
						"where  a.tpre_ccod in (5)                                       "& vbCrLf &_
						"and    a.tpre_ccod=b.tpre_ccod                                  "& vbCrLf &_
						"and    a.ccen_ccod=b.ccen_ccod                                  "& vbCrLf &_
						"and    a.esol_ccod=c.esol_ccod                                  "& vbCrLf &_
						"and    a.area_ccod=d.area_ccod                                  "& vbCrLf &_
						"and    isnull(mes_ccod,1)=e.indice                              "& vbCrLf &_
						"and    a.esol_ccod=1                                            "& vbCrLf &_
						"and    anio_ccod="&v_prox_anio&"                                "

			sql_aprobadas=""& vbCrLf &_
						"select *,                                                       "& vbCrLf &_
						"       case a.esol_ccod                                         "& vbCrLf &_
						"              when 1 then 'Dar Alta'                            "& vbCrLf &_
						"       end as accion,                                           "& vbCrLf &_
						"       nombremes                                                "& vbCrLf &_
						"from   presupuesto_upa.protic.centralizar_solicitud_personal a, "& vbCrLf &_
						"       presupuesto_upa.protic.concepto_centralizado b,          "& vbCrLf &_
						"       presupuesto_upa.protic.estado_solicitud c,               "& vbCrLf &_
						"       presupuesto_upa.protic.area_presupuestal d,              "& vbCrLf &_
						"       softland.sw_mesce e                                      "& vbCrLf &_
						"where  a.tpre_ccod in (5)                                       "& vbCrLf &_
						"and    a.tpre_ccod=b.tpre_ccod                                  "& vbCrLf &_
						"and    a.ccen_ccod=b.ccen_ccod                                  "& vbCrLf &_
						"and    a.esol_ccod=c.esol_ccod                                  "& vbCrLf &_
						"and    a.area_ccod=d.area_ccod                                  "& vbCrLf &_
						"and    isnull(mes_ccod,1)=e.indice                              "& vbCrLf &_
						"and    a.esol_ccod not in (1,3)                                 "& vbCrLf &_
						"and    anio_ccod="&v_prox_anio&"                                "
		'	Debug --------------->>
		' solicitado
		'response.write("<pre>"&sql_solicitud&"</pre>")
		'response.end()

		' aprobado
		'response.write("<pre>"&sql_aprobadas&"</pre>")
		'response.end()
		'	Debug ---------------<<
		'------------------------------------------------------------------------------------------->>
		'--		DIRECCION RECURSOS HUMANOS 	--
		'-------------------------------------
		'-------------------------------------
		'--		Direcci?n de An?lisis y Aseg. de la Calidad	--
		'------------------------------------------------------------------------------------------->>
		case 69:
			sql_solicitud=""& vbCrLf &_
						"select *,                                                          	"& vbCrLf &_
						"       case a.esol_ccod                                            	"& vbCrLf &_
						"              when 1 then 'Dar Alta'                               	"& vbCrLf &_
						"       end as accion,                                              	"& vbCrLf &_
						"       nombremes                                                   	"& vbCrLf &_
						"from   presupuesto_upa.protic.centralizar_solicitud_aceguraCalidad a, 	"& vbCrLf &_
						"       presupuesto_upa.protic.concepto_centralizado b,             	"& vbCrLf &_
						"       presupuesto_upa.protic.estado_solicitud c,                  	"& vbCrLf &_
						"       presupuesto_upa.protic.area_presupuestal d,                 	"& vbCrLf &_
						"       softland.sw_mesce e                                         	"& vbCrLf &_
						"where  a.tpre_ccod in (9)                                          	"& vbCrLf &_
						"and    a.tpre_ccod=b.tpre_ccod                                     	"& vbCrLf &_
						"and    a.ccen_ccod=b.ccen_ccod                                     	"& vbCrLf &_
						"and    a.esol_ccod=c.esol_ccod                                     	"& vbCrLf &_
						"and    a.area_ccod=d.area_ccod                                     	"& vbCrLf &_
						"and    isnull(mes_ccod,1)=e.indice                                 	"& vbCrLf &_
						"and    a.esol_ccod=1                                               	"& vbCrLf &_
						"and    anio_ccod="&v_prox_anio&"                                   	"

			sql_aprobadas=""& vbCrLf &_
						"select *,                                                          	"& vbCrLf &_
						"       case a.esol_ccod                                            	"& vbCrLf &_
						"              when 1 then 'Dar Alta'                               	"& vbCrLf &_
						"       end as accion ,                                             	"& vbCrLf &_
						"       nombremes                                                   	"& vbCrLf &_
						"from   presupuesto_upa.protic.centralizar_solicitud_aceguraCalidad a, 	"& vbCrLf &_
						"       presupuesto_upa.protic.concepto_centralizado b,             	"& vbCrLf &_
						"       presupuesto_upa.protic.estado_solicitud c,                  	"& vbCrLf &_
						"       presupuesto_upa.protic.area_presupuestal d,                 	"& vbCrLf &_
						"       softland.sw_mesce e                                         	"& vbCrLf &_
						"where  a.tpre_ccod in (9)                                          	"& vbCrLf &_
						"and    a.tpre_ccod=b.tpre_ccod                                     	"& vbCrLf &_
						"and    a.ccen_ccod=b.ccen_ccod                                     	"& vbCrLf &_
						"and    a.esol_ccod=c.esol_ccod                                     	"& vbCrLf &_
						"and    a.area_ccod=d.area_ccod                                     	"& vbCrLf &_
						"and    isnull(mes_ccod,1)=e.indice                                 	"& vbCrLf &_
						"and    a.esol_ccod not in (1,3)                                    	"& vbCrLf &_
						"and    anio_ccod="&v_prox_anio&"                                   	"
		'	Debug --------------->>
		' solicitado
		' response.write("<pre>"&sql_solicitud&"</pre>")
		' response.end()

		' aprobado
		'response.write("<pre>"&sql_aprobadas&"</pre>")
		'response.end()
		'	Debug ---------------<<
		'------------------------------------------------------------------------------------------->>
		'--		Direcci?n de An?lisis y Aseg. de la Calidad	--
		'-------------------------------------
		'-------------------------------------
		'--		Departamento de asuntos estudiantiles	--
		'------------------------------------------------------------------------------------------->>
		case 87:
			sql_solicitud=""& vbCrLf &_
						"select *,                                                          	"& vbCrLf &_
						"       case a.esol_ccod                                            	"& vbCrLf &_
						"              when 1 then 'Dar Alta'                               	"& vbCrLf &_
						"       end as accion,                                              	"& vbCrLf &_
						"       nombremes                                                   	"& vbCrLf &_
						"from   presupuesto_upa.protic.centralizar_solicitud_dae a, 			"& vbCrLf &_
						"       presupuesto_upa.protic.concepto_centralizado b,             	"& vbCrLf &_
						"       presupuesto_upa.protic.estado_solicitud c,                  	"& vbCrLf &_
						"       presupuesto_upa.protic.area_presupuestal d,                 	"& vbCrLf &_
						"       softland.sw_mesce e                                         	"& vbCrLf &_
						"where  a.tpre_ccod in (8)                                          	"& vbCrLf &_
						"and    a.tpre_ccod=b.tpre_ccod                                     	"& vbCrLf &_
						"and    a.ccen_ccod=b.ccen_ccod                                     	"& vbCrLf &_
						"and    a.esol_ccod=c.esol_ccod                                     	"& vbCrLf &_
						"and    a.area_ccod=d.area_ccod                                     	"& vbCrLf &_
						"and    isnull(mes_ccod,1)=e.indice                                 	"& vbCrLf &_
						"and    a.esol_ccod=1                                               	"& vbCrLf &_
						"and    anio_ccod="&v_prox_anio&"                                   	"

			sql_aprobadas=""& vbCrLf &_
						"select *,                                                          	"& vbCrLf &_
						"       case a.esol_ccod                                            	"& vbCrLf &_
						"              when 1 then 'Dar Alta'                               	"& vbCrLf &_
						"       end as accion ,                                             	"& vbCrLf &_
						"       nombremes                                                   	"& vbCrLf &_
						"from   presupuesto_upa.protic.centralizar_solicitud_dae a, 			"& vbCrLf &_
						"       presupuesto_upa.protic.concepto_centralizado b,             	"& vbCrLf &_
						"       presupuesto_upa.protic.estado_solicitud c,                  	"& vbCrLf &_
						"       presupuesto_upa.protic.area_presupuestal d,                 	"& vbCrLf &_
						"       softland.sw_mesce e                                         	"& vbCrLf &_
						"where  a.tpre_ccod in (8)                                          	"& vbCrLf &_
						"and    a.tpre_ccod=b.tpre_ccod                                     	"& vbCrLf &_
						"and    a.ccen_ccod=b.ccen_ccod                                     	"& vbCrLf &_
						"and    a.esol_ccod=c.esol_ccod                                     	"& vbCrLf &_
						"and    a.area_ccod=d.area_ccod                                     	"& vbCrLf &_
						"and    isnull(mes_ccod,1)=e.indice                                 	"& vbCrLf &_
						"and    a.esol_ccod not in (1,3)                                    	"& vbCrLf &_
						"and    anio_ccod="&v_prox_anio&"                                   	"
		'	Debug --------------->>
		' solicitado
		' response.write("<pre>"&sql_solicitud&"</pre>")
		' response.end()

		' aprobado
		'response.write("<pre>"&sql_aprobadas&"</pre>")
		'response.end()
		'	Debug ---------------<<
		'------------------------------------------------------------------------------------------->>
		'--		Departamento de asuntos estudiantiles	--
		'-------------------------------------
		'-------------------------------------
		'--		Vicerector?a acad?mica 	--
		'------------------------------------------------------------------------------------------->>
		case 83:
			sql_solicitud=""& vbCrLf &_
						"select *,                                                          			"& vbCrLf &_
						"       case a.esol_ccod                                            			"& vbCrLf &_
						"              when 1 then 'Dar Alta'                               			"& vbCrLf &_
						"       end as accion,                                              			"& vbCrLf &_
						"       nombremes                                                   			"& vbCrLf &_
						"from   presupuesto_upa.protic.centralizar_solicitud_vicerectoriaAcademica a, 	"& vbCrLf &_
						"       presupuesto_upa.protic.concepto_centralizado b,             			"& vbCrLf &_
						"       presupuesto_upa.protic.estado_solicitud c,                  			"& vbCrLf &_
						"       presupuesto_upa.protic.area_presupuestal d,                 			"& vbCrLf &_
						"       softland.sw_mesce e                                         			"& vbCrLf &_
						"where  a.tpre_ccod in (7)                                          			"& vbCrLf &_
						"and    a.tpre_ccod=b.tpre_ccod                                     			"& vbCrLf &_
						"and    a.ccen_ccod=b.ccen_ccod                                     			"& vbCrLf &_
						"and    a.esol_ccod=c.esol_ccod                                     			"& vbCrLf &_
						"and    a.area_ccod=d.area_ccod                                     			"& vbCrLf &_
						"and    isnull(mes_ccod,1)=e.indice                                 			"& vbCrLf &_
						"and    a.esol_ccod=1                                               			"& vbCrLf &_
						"and    anio_ccod="&v_prox_anio&"                                   			"

			sql_aprobadas=""& vbCrLf &_
						"select *,                                                          			"& vbCrLf &_
						"       case a.esol_ccod                                            			"& vbCrLf &_
						"              when 1 then 'Dar Alta'                               			"& vbCrLf &_
						"       end as accion ,                                             			"& vbCrLf &_
						"       nombremes                                                   			"& vbCrLf &_
						"from   presupuesto_upa.protic.centralizar_solicitud_vicerectoriaAcademica a, 	"& vbCrLf &_
						"       presupuesto_upa.protic.concepto_centralizado b,             			"& vbCrLf &_
						"       presupuesto_upa.protic.estado_solicitud c,                  			"& vbCrLf &_
						"       presupuesto_upa.protic.area_presupuestal d,                 			"& vbCrLf &_
						"       softland.sw_mesce e                                         			"& vbCrLf &_
						"where  a.tpre_ccod in (7)                                          			"& vbCrLf &_
						"and    a.tpre_ccod=b.tpre_ccod                                     			"& vbCrLf &_
						"and    a.ccen_ccod=b.ccen_ccod                                     			"& vbCrLf &_
						"and    a.esol_ccod=c.esol_ccod                                     			"& vbCrLf &_
						"and    a.area_ccod=d.area_ccod                                     			"& vbCrLf &_
						"and    isnull(mes_ccod,1)=e.indice                                 			"& vbCrLf &_
						"and    a.esol_ccod not in (1,3)                                    			"& vbCrLf &_
						"and    anio_ccod="&v_prox_anio&"                                   			"
		'	Debug --------------->>
		' solicitado
		' response.write("<pre>"&sql_solicitud&"</pre>")
		' response.end()

		' aprobado
		'response.write("<pre>"&sql_aprobadas&"</pre>")
		'response.end()
		'	Debug ---------------<<
		'------------------------------------------------------------------------------------------->>
		'--		Vicerector?a acad?mica	--
		'-------------------------------------
			case else
				sql_solicitud="select '' "
				sql_aprobadas="select '' "
			end select
		'	Debug --------------->>
		' solicitado
		'response.write("<pre>"&sql_solicitud&"</pre>")
		'response.end()

		' aprobado
		'response.write("<pre>"&sql_aprobadas&"</pre>")
		'response.end()
		'	Debug ---------------<<
		f_solicitado.consultar sql_solicitud
		f_aprobados.consultar sql_aprobadas
	end select
'------------------------------------------------------------------------------------------------>>
'--		PESTA?A SOLICITUD CENTRALIZADA	--
'-----------------------------------------
	sql_area_presu	= " select top 1 area_tdesc from presupuesto_upa.protic.area_presupuesto_usuario a, presupuesto_upa.protic.area_presupuestal b " & vbCrLf &_
					" where a.area_ccod=b.area_ccod " & vbCrLf &_
					" and rut_usuario="&v_usuario&"  and a.area_ccod="&area_ccod&"  "

	area_presupuesto = 	conexion2.consultaUno(sql_area_presu)


else
	 f_presupuesto.consultar "select '' where 1 = 2"
	 f_presupuesto.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
end if

if v_usuario= "13493596" or v_usuario="9251062" or v_usuario="11843248" then
	sin_bloqueo=true
end if

'response.Write("<pre>"&sql_meses&"</pre>")
'**************************'
'**		BUSQUEDA EJES	 **'
'**************************'------------------------
	set f_busqueda_c1 = new CFormulario
	f_busqueda_c1.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
	f_busqueda_c1.inicializar conexion
	consulta_foco = "SELECT eje_ccod, EJE_TDESC FROM EJE"
				f_busqueda_c1.consultar consulta_foco
'----------------------------------------------------DEBUG
'response.Write("<pre>"&consulta_foco&"</pre>")
'response.End()
'----------------------------------------------------DEBUG
'**************************'------------------------
'**		BUSQUEDA EJES	 **'
'**************************'
%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="presupuesto/js/jquery.js"></script>
<script type="text/javascript" src="presupuesto/js/jquery_ui.js" ></script>
<script type="text/javascript" src="presupuesto/js/funciones_1.js" ></script>
<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>


<script language="JavaScript">
function Validar(){
	return true;
}


function CargarCodigoCaja(formulario)
{
	_Buscar(this, document.forms['busca_codigo'],'', 'Validar();', 'FALSE');
}

function CargarCodigo(formulario, espe_ccod)
{
//alert(formulario);
	formulario.elements["busqueda[0][detalle]"].value="";
	_Buscar(this, document.forms['busca_codigo'],'', 'Validar();', 'FALSE');
}

function CargarPrioridad(tpre_ccod)
{

	formulario= document.forms['solicitud'];
	formulario.elements["tpre_ccod"].value=tpre_ccod;
}

function CargarConcepto(formulario)
{

	_Buscar(this, document.forms['busca_codigo'],'', 'Validar();', 'FALSE');
}


function CargarDetalles(formulario)
{
	_Buscar(this, document.forms['busca_codigo'],'', 'Validar();', 'FALSE');
}

function ver_detalle(var1,var2,var3){
	formulario=document.forms['busca_codigo'];
	formulario.elements["busqueda[0][mes_venc]"].value=var3
	_Buscar(this, document.forms['busca_codigo'],'', 'Validar();', 'FALSE');

}



function ValidaNumero(elemento){
	formulario=document.forms['busca_codigo'];
	cadena=elemento.name;
	valor_nuevo=cadena.substring(1,cadena.Length);
//alert(elemento.value);
	if(isNumber(formulario.elements[valor_nuevo].value)){
		CalcularTotalSolicitado();
		return true;
	}else{
		alert("Ingrese un numero v?lido");
		elemento.value="0";
		elemento.focus();
	}
}

function CalcularTotalSolicitado()
{
	formulario=document.forms['busca_codigo'];
	v_total_solicitud = 0;
	for (var i = 0; i < 12; i++)
	{
		//alert("fdg= "+i);
		v_total_solicitud = v_total_solicitud + parseInt(document.busca_codigo.elements['test['+i+'][solicitado]'].value);
	}
	formulario.total_solicitud.value=	FormatoMoneda(String(v_total_solicitud));
	formulario.total_solicitud_.value=	v_total_solicitud;


}


function FormatoMoneda(valor){
	salida = '';
	/*numDecimales=0;
		if((valor.length-numDecimales)%3>0){
				adicional = 1;
		}
			iteraciones = ((valor.length-numDecimales)-(valor.length-numDecimales)%3)/3 + adicional;
		    for(i=1;i<=iteraciones;i++) {
			    extra = valor.length-3*i-numDecimales < 0 ? valor.length-3*i-numDecimales : 0;
				if(i==1)
					salida = valor.substr(valor.length-3*i-numDecimales,3+extra) + salida;
				else
					salida = valor.substr(valor.length-3*i-numDecimales,3+extra) + '.' + salida;
			}
				if(salida==''){
					salida = 0;
				}
					salida = '$ ' + salida;

	return salida;	*/

		while( valor.length > 3 )
		{
		 salida = '.' + valor.substr(valor.length - 3) + salida;
		 valor = valor.substring(0, valor.length - 3);
		}
		salida = valor + salida;
		salida = '$ ' + salida;
	return salida;
}
function quitarMoneda(valor)
{
	var res = valor.replace("$ ", "");
	var res2 = res.replace(".", "");
	return res2;
}

function CargarAnterior()
{
	v_area='<%=area_presupuesto%>';
	v_codigo='<%=codcaja%>';
	//v_concepto='<%=v_concepto%>';
	v_detalle='<%=txt_detalle%>';

	if(v_codigo==''){
		v_codigo='TODOS';
	}
/*	if(v_concepto==''){
		v_concepto='TODOS';
	}*/
	if(v_detalle==''){
		v_detalle='TODOS';
	}

	//"Esta apunto de copiar el presupuesto del a?o anterior asociado a:\n\t Area:"+v_area+"\n\t C?digo:"+v_codigo+"\n\t Concepto: "+v_concepto+"\n\t Detalle: "+v_detalle+" \n?Esta seguro de realizar esta acci?n?. Los datos puedes ser modificados posteriormente."
	if(confirm("Esta apunto de copiar el presupuesto del a?o anterior asociado a:\n\t Area: "+v_area+"\n\t C?digo: "+v_codigo+"\n\t Detalle: "+v_detalle+" \n?Esta seguro de realizar esta acci?n?. Los datos puedes ser modificados posteriormente.")){
		formulario=document.forms['busca_codigo'];
		formulario.action = "proc_cargar_anterior.asp";
		formulario.method = "post";
		formulario.submit();
	}
	return false;
}


function CambiaEstado(num,v_estado,codigo){
area='<%=area_ccod%>';
	if(v_estado==2){
		alert("Esta solicitud ya fue activada, por lo tanto no es posible realizar modificaciones");
	}else{

		if(v_estado==1){
			txt_estado="Dar de alta";
		}else{
			txt_estado="dejar Pendiente";
		}

		if(confirm("Esta seguro que desea "+txt_estado+" la solicitud seleccionada")){
			location.href="proc_cambia_estado_solicitud_encargado.asp?nro="+num+"&etd="+v_estado+"&cod="+codigo+"&area="+area;
		}

	}

}

function Rechazar(num,codigo){
	if(confirm("Est? a punto de rechazar una solicitud, desea continuar?")){
		direccion = "motivo_rechazo.asp?cod="+codigo+"&nro="+num;
		window.open(direccion, "ventana1","width=300,height=180,scrollbars=no, left=380, top=350");
	}
}

function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if%>
}

</script>
<style type="text/css">

	.meses:link, .meses:visited { 	text-decoration: underline;color:#0033FF; }
	.meses:hover {	text-decoration: none; }

</style>
</head>

<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();CalcularTotalSolicitado();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">

<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
              <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8" background="../imagenes/top_r1_c2.gif"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="100" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador</font></div></td>
                    <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                  </tr>
              </table></td>
              <td align="left"><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td background="../imagenes/top_r3_c2.gif"><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE">
			<BR>
				<form name="buscador">
                      <table width="100%" border="0" align="left">
                        <tr>
                          <td width="35"></td>
						  <td width="190"><div align="left"><strong>Area Presupuesto</strong>  </div></td>
						  <td width="482"><% f_busqueda.DibujaCampo ("area_ccod") %></td>
                          <td width="183"><div align="center"><%botonera.DibujaBoton "buscar" %></div></td>
                        </tr>
                      </table>
				</form>
                </td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE" background="../imagenes/base2.gif"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>
          </td>
      </tr>
    </table>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
              <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td ><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td background="../imagenes/top_r1_c2.gif"><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="15" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="114" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Presupuesto</font></div>
                    </td>
                    <td width="904" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                  </tr>
                </table>
              </td>
              <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td background="../imagenes/top_r3_c2.gif"><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
            </tr>

              <tr>
                <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"> <div align="center"><BR>
                    <%pagina.DibujarTituloPagina%>
                  </div>
			<% if area_ccod <> "" then	%>
				  <table width="632"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#EDEDEF">
                    <tr>
                      <td width="9" height="8"><img src="../imagenes/marco_claro/1.gif" width="9" height="8"></td>
                      <td height="8" background="../imagenes/marco_claro/2.gif"></td>
                      <td width="7" height="8"><img src="../imagenes/marco_claro/3.gif" width="7" height="8"></td>
                    </tr>
                    <tr>
                      <td width="9" background="../imagenes/marco_claro/9.gif">&nbsp;</td>
                      <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td>
                              <%
								' Pesta?as
								url_Pestania 			= "ingreso_presupuesto_directo_2015.asp"
								arrArea 				= Array()
								Redim arrArea(3)
								IngresoDePresupuesto 	= array("Ingreso De Presupuesto",url_Pestania&"?area_ccod="&area_ccod&"&codcaja="& codcaja &"&nro_t=1")
								Presupuesto				= array("Presupuesto",url_Pestania&"?area_ccod="&area_ccod&"&codcaja="& codcaja &"&nro_t=2")
								SolicitudCentralizada	= array("Solicitud Centralizada",url_Pestania&"?area_ccod="&area_ccod&"&codcaja="& codcaja &"&nro_t=3")
								pagina.DibujarLenguetasFClaro Array(IngresoDePresupuesto,Presupuesto, SolicitudCentralizada), nro_t
							 %>
                            </td>
                          </tr>
                          <tr>
                            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
                          </tr>
                          <tr>
                            <td>
								<table border="1" width="100%">
								<tr>
								<%
								select case (nro_t)
								case 1:
								%>

								<td valign="top" width="30%">
								<br/>
								<center><font color="#0000CC" size="2"><b><%=area_presupuesto%></b></font></center>
<form name="busca_codigo" action="presupuesto/proc/procesaPresu_1.asp" id="busca_codigo" method="post">
									<input type="hidden" name="nro_t" value="<%=nro_t%>" >
									<input type="hidden" name="busqueda[0][area_ccod]" value="<%=area_ccod%>"/>
									<input type="hidden" name="busqueda[0][mes_venc]" value=""/>
									<table width="100%" border="0">
										<tr>
											<td colspan="2" align="center"><%
											if sin_bloqueo then
											'botonera.DibujaBoton ("anterior")
											end if
											%><br></td>
										</tr>

<tr><td width="70%"><span id="tablaTotal"></span></td></tr></tr>
<tr>
	<td colspan="2">
		<span id="combo_1"><input type="hidden" name="selCombo" value="0"></span>
	</td>
</tr>

<tr>
	<td colspan="2">
		<span id="ComboFoco"><input type="hidden" name="selCombo2" value="0"></span>
	</td>
</tr>

<tr>
	<td colspan="2">
		<span id="ComboPrograma"><input type="hidden" name="selCombo3" value="0"></span>
	</td>
</tr>

<tr>
	<td colspan="2">
		<span id="ComboProyecto"><input type="hidden" name="selCombo4" value="0"></span>
	</td>
</tr>
<tr>
	<td colspan="2">
	<span id=detalleProyecto align="justify" ></span>
	</td>
</tr>
<tr>
	<td colspan="2">
		<span id="ComboObjetivo"><input type="hidden" name="selCombo5" value="0"></span>
	</td>
</tr>
<tr>
	<td colspan="2">
	<span id=detalleObjetivo  align="justify" ></span>
	</td>
</tr>
<tr>
	<td colspan="2">
	<br/><hr/>
	</td>
</tr>
<tr>
	<td colspan="2"><div align="left"><strong>Concepto Presupuestario</strong></div></td>
</tr>
<tr>
	<td colspan="2"><span id="conceptoP"><% f_busqueda.DibujaCampo("codcaja") %></span></td>
</tr>
<tr>
  <td ><strong>Detalle De Partida Presupuestaria</strong> </td>
  <td ><strong>Tipo de gasto</strong> </td>
</tr>

<tr>

	<td align="left"><span id="detPresupuesto">
	<SELECT NAME="selCombo6" disabled>
		<option value="0">-Bloqueado-</option>
	</select>
	</span></td>
    <td align="left"><%f_busqueda.DibujaCampo ("tpre_ccod")%></td>
</tr>
<tr>
<td><span id="agregarDetalle"></span></td>
</tr>
<tr>
	<td><span id="estado_1"></span></td>
</tr>
									</table>
									<br>
									<center>
									</center>
									<table align="center">
									<tr>
										<td colspan="2" align="center" bgcolor='#C4D7FF' bordercolor='#999999'>Zona De Descargas</td>
									</tr>
									<tr>
										<td align="center"><a href="./BASES_PRESUPUESTARIA_2016_DEF.pdf" target="_new"><img src="../imagenes/bases_presupuesto.png" border="0" alt="Descargar Bases" align="middle" /></a></td>
										<!--<td align="center"><a href="./docs/Manual Instrucciones Proyectos 2013.pdf" target="_new"><img src="../imagenes/manual_presupuesto.png" border="0" alt="Descargar Manual" align="middle" /></a></td> -->
									</tr>
									<tr>
										<th>Bases Presupuesto 2016</th>
										<!--<th>Manual Instrucciones Planificacion</th>-->
									</tr>
									</table>
									</td>


							<tr><td colspan="2">
								  <%if mes_venc<>"" then%>
								  <form name="edicion" >
								  <input type="hidden" name="codcaja" value="<%=codcaja%>">
								  <input type="hidden" name="area_ccod" value="<%=area_ccod%>">
								  <input type="hidden" name="mes_venc" value="<%=mes_venc%>"/>

								  <font color="#0000CC" size="2">Detalle real para el mes: <b><%=nombre_mes%></b></font> <font color="#CC3300" size="2"> (Presupuesto periodo anterior)</font>
									  <table width="100%" cellspacing="0" cellpadding="0" border="0">
									  	<tr>
											<td colspan="2"><div align="right">P&aacute;ginas: &nbsp; <% f_presupuesto.AccesoPagina %></div></td>
										</tr>
										<tr>
										  <td colspan="2" align="center"><% f_presupuesto.DibujaTabla() %></td>
										</tr>
									  	<tr>
									  		<td width="23%" align="left"><font color="#0000CC" size="2">Total Ejecutado:</font></td>
								  		  	<td width="77%" align="left"><strong><%=formatcurrency(v_total_gastado,0)%></strong></td>
										</tr>
									  </table>
								  </form>
							</td></tr>
</form>
							<%end if

							 case 2:%>
							 <tr><td colspan="2">

							 	<br/>
								<font color="#0000CC" size="2">Area Presupuesto: <b><%=area_presupuesto%></b></font>
									<br/>
									<form name="busca_codigo" method="get">
									<input type="hidden" name="nro_t" value="<%=nro_t%>" >
									<input type="hidden" name="busqueda[0][area_ccod]" value="<%=area_ccod%>"/>
									<input type="hidden" name="busqueda[0][mes_venc]" value=""/>
									<table>
										<tr>
											<td width="155"><div align="left"><strong>C?digo presupuestario</strong></div></td>
											<td width="8">:</td>
											<td width="53"><%
											f_busqueda.AgregaCampoParam "codcaja", "script", "onChange='CargarCodigoCaja(this.form)'"
											f_busqueda.DibujaCampo("codcaja") %></td>
										</tr>
									</table>
									</form>

								<form name="presupuesto" method="post">
									<input type="hidden" name="nro_t" value="<%=nro_t%>" >
									<input type="hidden" name="codcaja" value="<%=codcaja%>">
									<input type="hidden" name="area_ccod" value="<%=area_ccod%>">
								</form>
									<table width="100%" border="1" align="center" >
										<tr  bgcolor='#C4D7FF' bordercolor='#999999'>
										  <th width="25%">CONCEPTO</th>
										  <th width="25%">DETALLE</th>
										  <th width="25%">CODIGO</th>
                                          <th width="25%">TIPO</th>
										  <th width="25%">ENERO</th>
										  <th width="25%">FEBRERO</th>
										  <th width="25%">MARZO</th>
										  <th width="25%">ABRIL</th>
										  <th width="25%">MAYO</th>
										  <th width="25%">JUNIO</th>
										  <th width="25%">JULIO</th>
										  <th width="25%">AGOSTO</th>
										  <th width="25%">SEPTIEMBRE</th>
										  <th width="25%">OCTUBRE</th>
										  <th width="25%">NOVIEMBRE</th>
										  <th width="25%">DICIEMBRE</th>
										  <th width="25%">TOTAL</th>
										</tr>
									<%
									while f_presupuestado.Siguiente
										foco_ccod 	= f_presupuestado.ObtenerValor("foco_ccod")
										foco_tdesc	= conexion.consultaUno("select foco_tdesc from foco where foco_ccod = "&foco_ccod&"")
										prog_ccod 	= f_presupuestado.ObtenerValor("prog_ccod")
										prog_tdesc	= conexion.consultaUno("select prog_tdesc from programa where prog_ccod = "&prog_ccod&"")
										proye_ccod 	= f_presupuestado.ObtenerValor("proye_ccod")
										proye_tdesc	= conexion.consultaUno("select proye_tdesc from proyecto where proye_ccod = "&proye_ccod&"")
										obje_ccod 	= f_presupuestado.ObtenerValor("obje_ccod")
										obje_tdesc	= conexion.consultaUno("select obje_tdesc from objetivo where obje_ccod = "&obje_ccod&"")


										eje_ccod 	= f_presupuestado.ObtenerValor("eje_ccod")
										eje_tdesc	= conexion.consultaUno("select eje_tdesc from eje where eje_ccod = "&eje_ccod&"")
										cod_pre 	= f_presupuestado.ObtenerValor("cod_pre")
										detalle 	= f_presupuestado.ObtenerValor("detalle")
										tipo_gasto 	= f_presupuestado.ObtenerValor("tipo_gasto")
										ene 		= f_presupuestado.ObtenerValor("ene")
										feb  		= f_presupuestado.ObtenerValor("feb")
										mar  		= f_presupuestado.ObtenerValor("mar")
										abr  		= f_presupuestado.ObtenerValor("abr")
										may  		= f_presupuestado.ObtenerValor("may")
										jun  		= f_presupuestado.ObtenerValor("jun")
										jul  		= f_presupuestado.ObtenerValor("jul")
										ago  		= f_presupuestado.ObtenerValor("ago")
										sep  		= f_presupuestado.ObtenerValor("sep")
										octu 		= f_presupuestado.ObtenerValor("octu")
										nov  		= f_presupuestado.ObtenerValor("nov")
										dic  		= f_presupuestado.ObtenerValor("dic")
										total		= f_presupuestado.ObtenerValor("total")
										'-----------------------------------------------------------calculo totales
										tot_ene   =  tot_ene   + ene
										tot_feb   =  tot_feb   + feb
										tot_mar   =  tot_mar   + mar
										tot_abr   =  tot_abr   + abr
										tot_may   =  tot_may   + may
										tot_jun   =  tot_jun   + jun
										tot_jul   =  tot_jul   + jul
										tot_ago   =  tot_ago   + ago
										tot_sep   =  tot_sep   + sep
										tot_octu  =  tot_octu  + octu
										tot_nov   =  tot_nov   + nov
										tot_dic   =  tot_dic   + dic
										tot_total =  tot_total + total
										'-----------------------------------------------------------calculo totales

										set f_busqueda2 = new CFormulario
										f_busqueda2.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
										f_busqueda2.inicializar conexion2
										con_1 = "select concepto_pre from  presupuesto_upa.protic.codigos_presupuesto where cod_pre = '"&cod_pre&"'"
										'response.write(con_1)
										'response.end()
										f_busqueda2.consultar con_1
										f_busqueda2.siguiente
										nombre_1     = f_busqueda2.ObtenerValor("concepto_pre")

									%>
									<tr bordercolor='#999999'>
										<td><%=nombre_1%></td>
										<td><%=detalle%></td>
										<td><%=cod_pre%></td>
                                        <td><%=tipo_gasto%></td>
										<td><%=ene%></td>
										<td><%=feb%> </td>
										<td><%=mar%> </td>
										<td><%=abr%> </td>
										<td><%=may%> </td>
										<td><%=jun%> </td>
										<td><%=jul%> </td>
										<td><%=ago%> </td>
										<td><%=sep%> </td>
										<td><%=octu%> </td>
										<td><%=nov%> </td>
										<td><%=dic%> </td>
										<td><strong><%=total%></strong></td>
									</tr>
									 <%wend%>
									<tr bordercolor='#999999'>
								 	<td colspan="4"><b>Totales</b></td>
									<td align="right"><%=tot_ene%><b></b></td>
									<td align="right"><%=tot_feb%><b></b></td>
									<td align="right"><%=tot_mar%><b></b></td>
									<td align="right"><%=tot_abr%><b></b></td>
									<td align="right"><%=tot_may%><b></b></td>
									<td align="right"><%=tot_jun%><b></b></td>
									<td align="right"><%=tot_jul%><b></b></td>
									<td align="right"><%=tot_ago%><b></b></td>
									<td align="right"><%=tot_sep%><b></b></td>
									<td align="right"><%=tot_octu%><b></b></td>
									<td align="right"><%=tot_nov%><b></b></td>
									<td align="right"><%=tot_dic%><b></b></td>
									<td align="right"><b><%=tot_total%></b></td>
								 </tr>
								  </table>
<%
'-----------------------------------------
'--		PESTA?A SOLICITUD CENTRALIZADA	--
'------------------------------------------------------------------------------------------------>>
case 3:%>
<tr><td colspan="2">
	  <br/>
		<%
select case (area_ccod)
	'-------------------------------------
	'--		'DEPARTAMENTO AUDIOVISUAL	--(Vista)
	'------------------------------------------------------------------------------------------>>
	case 60:
	%>
	<font>Pendientes</font>
	<br/>
	<table width="95%" border="1" align="center"  >
	<%
	encaPendientes()
	while f_solicitado.Siguiente
	'----------------------------------------------
	v_neje 			= f_solicitado.ObtenerValor("eje_ccod")
	v_nfoco			= f_solicitado.ObtenerValor("foco_ccod")
	v_nprograma		= f_solicitado.ObtenerValor("prog_ccod")
	v_nproyecto 	= f_solicitado.ObtenerValor("proye_ccod")
	v_nobjetivo 	= f_solicitado.ObtenerValor("obje_ccod")
	v_nTPresu		= f_solicitado.ObtenerValor("t_presupuesto")
	areaPresupuesta	= f_solicitado.ObtenerValor("area_tdesc")
	v_TPresu		= ""
	if(v_nTPresu = "1") then v_TPresu = "Primario" end if
	if(v_nTPresu = "2") then v_TPresu = "Secundario" end if
	'------------------------------------------------------------->>
	if isNull(v_neje) then v_neje  = 0 end if
	if isNull(v_nfoco) then v_nfoco  = 0 end if
	if isNull(v_nprograma) then v_nprograma  = 0 end if
	if isNull(v_nproyecto) then v_nproyecto  = 0 end if
	if isNull(v_nobjetivo) then v_nobjetivo  = 0 end if
	if 	isnull(areaPresupuesta) then areaPresupuesta = 0 end if
	'-------------------------------------------------------------<<
	v_eje 		= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
	v_foco		= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&v_nfoco&"")
	v_programa	= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&v_nprograma&"")
	v_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
	v_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&v_nobjetivo&"")
	'cadenaTabla()
	'----------------------------------------------
    filasPendientes "ccen_tdesc", "ccau_tdesc", areaPresupuesta, v_eje, v_foco, v_programa, v_proyecto, v_objetivo, "nombremes", "ccau_ncantidad", "v_aprox", v_TPresu, "esol_tdesc", "esol_ccod", "ccau_ncorr", "accion"
	wend
	if f_solicitado.nrofilas <=0 then%>
		<tr bordercolor='#999999'>	<td colspan="14" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
	<% end if%>
	</table>
	<br/>
	<font>Aceptadas y Rechazadas</font>
	<br/>
	<table width="95%" border="1" align="center"  >
	<%
		encaDeAlta()
		while f_aprobados.Siguiente
	'----------------------------------------------
		va_nTPresu			= f_aprobados.ObtenerValor("t_presupuesto")
		va_neje 			= f_aprobados.ObtenerValor("eje_ccod")
		va_nfoco			= f_aprobados.ObtenerValor("foco_ccod")
		va_nprograma		= f_aprobados.ObtenerValor("prog_ccod")
		va_nproyecto 		= f_aprobados.ObtenerValor("proye_ccod")
		va_nobjetivo 		= f_aprobados.ObtenerValor("obje_ccod")
		vareaPresupuesta	= f_aprobados.ObtenerValor("area_tdesc")
		va_TPresu		= ""
		if(va_nTPresu = "1") then va_TPresu = "Primario" end if
		if(va_nTPresu = "2") then va_TPresu = "Secundario" end if
		'-------------------------------->>
		if 	isnull(va_nTPresu) then va_nTPresu = 0 end if
		if 	isnull(va_neje) then va_neje = 0 end if
		if 	isnull(va_nfoco) then va_nfoco = 0 end if
		if 	isnull(va_nprograma) then va_nprograma = 0 end if
		if 	isnull(va_nproyecto) then va_nproyecto = 0 end if
		if 	isnull(va_nobjetivo) then va_nobjetivo = 0 end if
		if 	isnull(vareaPresupuesta) then vareaPresupuesta = 0 end if
		'-------------------------------->>
		con_1 = "select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&va_neje
		'response.write(con_1)
		va_eje 			= conexion.consultaUno(con_1)
		va_foco			= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&va_nfoco&"")
		va_programa		= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&va_nprograma&"")
		va_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&va_nproyecto&"")
		va_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&va_nobjetivo&"")
	'----------------------------------------------
		filasDeAlta "ccen_tdesc", "ccau_tdesc", vareaPresupuesta, va_eje, va_foco, va_programa, va_proyecto, va_objetivo, "nombremes", "ccau_ncantidad", "v_aprox", va_TPresu, "esol_tdesc"

		wend
		if f_aprobados.nrofilas <=0 then%>
			<tr bordercolor='#999999'>	<td colspan="14" align="center">No se encontraron solicitudes aprobadas </td></tr>
		<% end if%>
	</table>

<%
	'------------------------------------------------------------------------------------------>>
	'--		'DEPARTAMENTO AUDIOVISUAL	--(Vista)
	'-------------------------------------
	'---------------------------------
	'--		direcci?n de biblioteca	--(Vista)
	'------------------------------------------------------------------------------------------->>
case 99:%>
											<font>Pendientes</font>
											<br/>
	<table width="95%" border="1" align="center"  >
<%
encaPendientes()
while f_solicitado.Siguiente
'----------------------------------------------
	v_neje 			= f_solicitado.ObtenerValor("eje_ccod")
	v_nfoco			= f_solicitado.ObtenerValor("foco_ccod")
	v_nprograma		= f_solicitado.ObtenerValor("prog_ccod")
	v_nproyecto 	= f_solicitado.ObtenerValor("proye_ccod")
	v_nobjetivo 	= f_solicitado.ObtenerValor("obje_ccod")
	v_nTPresu		= f_solicitado.ObtenerValor("t_presupuesto")
	areaPresupuesta	= f_solicitado.ObtenerValor("area_tdesc")
	v_TPresu		= ""
	if(v_nTPresu = "1") then v_TPresu = "Primario" end if
	if(v_nTPresu = "2") then v_TPresu = "Secundario" end if
	'------------------------------------------------------------->>
	if isNull(v_neje) then v_neje  = 0 end if
	if isNull(v_nfoco) then v_nfoco  = 0 end if
	if isNull(v_nprograma) then v_nprograma  = 0 end if
	if isNull(v_nproyecto) then v_nproyecto  = 0 end if
	if isNull(v_nobjetivo) then v_nobjetivo  = 0 end if
	if 	isnull(areaPresupuesta) then areaPresupuesta = 0 end if
	'-------------------------------------------------------------<<
	v_eje 		= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
	v_foco		= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&v_nfoco&"")
	v_programa	= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&v_nprograma&"")
	v_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
	v_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&v_nobjetivo&"")
	'cadenaTabla()
	'----------------------------------------------
    filasPendientes "ccen_tdesc", "ccbi_tdesc", areaPresupuesta, v_eje, v_foco, v_programa, v_proyecto, v_objetivo, "nombremes", "ccbi_ncantidad", "v_aprox", v_TPresu, "esol_tdesc", "esol_ccod", "ccbi_ncorr", "accion"
	wend
	if f_solicitado.nrofilas <=0 then%>
		<tr bordercolor='#999999'>	<td colspan="14" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
	<% end if%>
	</table>
		<br/>
		<font>Aceptadas y Rechazadas</font>
		<br/>
		<table width="95%" border="1" align="center"  >
		<%
			encaDeAlta()
			while f_aprobados.Siguiente
	'----------------------------------------------
	va_nTPresu			= f_aprobados.ObtenerValor("t_presupuesto")
	va_neje 			= f_aprobados.ObtenerValor("eje_ccod")
	va_nfoco			= f_aprobados.ObtenerValor("foco_ccod")
	va_nprograma		= f_aprobados.ObtenerValor("prog_ccod")
	va_nproyecto 		= f_aprobados.ObtenerValor("proye_ccod")
	va_nobjetivo 		= f_aprobados.ObtenerValor("obje_ccod")
	vareaPresupuesta	= f_aprobados.ObtenerValor("area_tdesc")
	va_TPresu		= ""
	if(va_nTPresu = "1") then va_TPresu = "Primario" end if
	if(va_nTPresu = "2") then va_TPresu = "Secundario" end if
	'-------------------------------->>
	if 	isnull(va_nTPresu) then va_nTPresu = 0 end if
	if 	isnull(va_neje) then va_neje = 0 end if
	if 	isnull(va_nfoco) then va_nfoco = 0 end if
	if 	isnull(va_nprograma) then va_nprograma = 0 end if
	if 	isnull(va_nproyecto) then va_nproyecto = 0 end if
	if 	isnull(va_nobjetivo) then va_nobjetivo = 0 end if
	if 	isnull(vareaPresupuesta) then vareaPresupuesta = 0 end if
	'-------------------------------->>
	con_1 = "select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&va_neje
	'response.write(con_1)
	va_eje 			= conexion.consultaUno(con_1)
	va_foco			= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&va_nfoco&"")
	va_programa		= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&va_nprograma&"")
	va_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&va_nproyecto&"")
	va_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&va_nobjetivo&"")
	'----------------------------------------------
			filasDeAlta "ccen_tdesc", "ccbi_tdesc", areaPresupuesta, va_eje, va_foco, va_programa, va_proyecto, va_objetivo, "nombremes", "ccbi_ncantidad", "v_aprox", v_TPresu, "esol_tdesc"
			wend
			if f_aprobados.nrofilas <=0 then%>
				<tr bordercolor='#999999'>	<td colspan="14" align="center">No se encontraron solicitudes aprobadas </td></tr>
			<% end if%>
	</table>
<%
	'------------------------------------------------------------------------------------------->>
	'--		direcci?n de biblioteca	--(Vista)
	'---------------------------------
	'-------------------------------------------------
	'--		DIRECCION TECNOLOGIA DE LA INFORMACION	--(Vista)
	'------------------------------------------------------------------------------------------->>
	case 15:%>
											<font>Pendientes</font>
											<br/>
<table width="95%" border="1" align="center"  >
<%
encaPendientes()
while f_solicitado.Siguiente
'----------------------------------------------
	v_neje 			= f_solicitado.ObtenerValor("eje_ccod")
	v_nfoco			= f_solicitado.ObtenerValor("foco_ccod")
	v_nprograma		= f_solicitado.ObtenerValor("prog_ccod")
	v_nproyecto 	= f_solicitado.ObtenerValor("proye_ccod")
	v_nobjetivo 	= f_solicitado.ObtenerValor("obje_ccod")
	v_nTPresu		= f_solicitado.ObtenerValor("t_presupuesto")
	areaPresupuesta	= f_solicitado.ObtenerValor("area_tdesc")
	v_TPresu		= ""
	if(v_nTPresu = "1") then v_TPresu = "Primario" end if
	if(v_nTPresu = "2") then v_TPresu = "Secundario" end if
	'------------------------------------------------------------->>
	if isNull(v_neje) then v_neje  = 0 end if
	if isNull(v_nfoco) then v_nfoco  = 0 end if
	if isNull(v_nprograma) then v_nprograma  = 0 end if
	if isNull(v_nproyecto) then v_nproyecto  = 0 end if
	if isNull(v_nobjetivo) then v_nobjetivo  = 0 end if
	if 	isnull(areaPresupuesta) then areaPresupuesta = 0 end if
	'-------------------------------------------------------------<<
	v_eje 		= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
	v_foco		= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&v_nfoco&"")
	v_programa	= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&v_nprograma&"")
	v_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
	v_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&v_nobjetivo&"")
	'cadenaTabla()
	'----------------------------------------------
filasPendientes "ccen_tdesc", "ccco_tdesc", areaPresupuesta, v_eje, v_foco, v_programa, v_proyecto, v_objetivo, "nombremes", "ccco_ncantidad", "v_aprox", v_TPresu, "esol_tdesc", "esol_ccod", "ccco_ncorr", "accion"

wend
if f_solicitado.nrofilas <=0 then%>
	<tr bordercolor='#999999'>	<td colspan="14" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
<% end if%>
</table>
<br/>
		<font>Aceptadas y Rechazadas</font>
		<br/>
		<table width="95%" border="1" align="center"  >
<%
encaDeAlta()
			while f_aprobados.Siguiente
	'----------------------------------------------
	va_nTPresu			= f_aprobados.ObtenerValor("t_presupuesto")
	va_neje 			= f_aprobados.ObtenerValor("eje_ccod")
	va_nfoco			= f_aprobados.ObtenerValor("foco_ccod")
	va_nprograma		= f_aprobados.ObtenerValor("prog_ccod")
	va_nproyecto 		= f_aprobados.ObtenerValor("proye_ccod")
	va_nobjetivo 		= f_aprobados.ObtenerValor("obje_ccod")
	vareaPresupuesta	= f_aprobados.ObtenerValor("area_tdesc")
	va_TPresu		= ""
	if(va_nTPresu = "1") then va_TPresu = "Primario" end if
	if(va_nTPresu = "2") then va_TPresu = "Secundario" end if
	'-------------------------------->>
	if 	isnull(va_nTPresu) then va_nTPresu = 0 end if
	if 	isnull(va_neje) then va_neje = 0 end if
	if 	isnull(va_nfoco) then va_nfoco = 0 end if
	if 	isnull(va_nprograma) then va_nprograma = 0 end if
	if 	isnull(va_nproyecto) then va_nproyecto = 0 end if
	if 	isnull(va_nobjetivo) then va_nobjetivo = 0 end if
	if 	isnull(vareaPresupuesta) then vareaPresupuesta = 0 end if
	'-------------------------------->>
	con_1 = "select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&va_neje
	'response.write(con_1)
	va_eje 			= conexion.consultaUno(con_1)
	va_foco			= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&va_nfoco&"")
	va_programa		= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&va_nprograma&"")
	va_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&va_nproyecto&"")
	va_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&va_nobjetivo&"")
	'----------------------------------------------
			filasDeAlta "ccen_tdesc", "ccco_tdesc", areaPresupuesta, va_eje, va_foco, va_programa, va_proyecto, va_objetivo, "nombremes", "ccco_ncantidad", "v_aprox", v_TPresu, "esol_tdesc"
wend%>
			 <%if f_aprobados.nrofilas <=0 then%>
				<tr bordercolor='#999999'>	<td colspan="14" align="center">No se encontraron solicitudes aprobadas </td></tr>
			 <% end if%>
</table>
<%
	'------------------------------------------------------------------------------------------->>
	'--		DIRECCION TECNOLOGIA DE LA INFORMACION	--(Vista)
	'-------------------------------------------------

	'---------------------------------
	'--		DIRECCION DE DOCENCIA	--(Vista)
	'------------------------------------------------------------------------------------------->>
case 27:%>
<font>Pendientes</font>
<br/>
	<table width="95%" border="1" align="center"  >
	<%
	encaPendientes()
	while f_solicitado.Siguiente
	'----------------------------------------------
	v_neje 			= f_solicitado.ObtenerValor("eje_ccod")
	v_nfoco			= f_solicitado.ObtenerValor("foco_ccod")
	v_nprograma		= f_solicitado.ObtenerValor("prog_ccod")
	v_nproyecto 	= f_solicitado.ObtenerValor("proye_ccod")
	v_nobjetivo 	= f_solicitado.ObtenerValor("obje_ccod")
	v_nTPresu		= f_solicitado.ObtenerValor("t_presupuesto")
	v_TPresu		= ""
	areaPresupuesta	= f_solicitado.ObtenerValor("area_tdesc")
	if(v_nTPresu = "1") then v_TPresu = "Primario" end if
	if(v_nTPresu = "2") then v_TPresu = "Secundario" end if

	v_eje 		= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
	v_foco		= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&v_nfoco&"")
	v_programa	= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&v_nprograma&"")
	v_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
	v_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&v_nobjetivo&"")
	'cadenaTabla()
	filasPendientes "ccen_tdesc", "ccau_tdesc", areaPresupuesta, v_eje, v_foco, v_programa, v_proyecto, v_objetivo, "nombremes", "ccau_ncantidad", "v_aprox", v_TPresu, "esol_tdesc", "esol_ccod", "ccau_ncorr", "accion"

wend

if f_solicitado.nrofilas <=0 then%>
<tr bordercolor='#999999'>	<td colspan="14" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
<% end if%>
 </table>

<br/>
<font>Aceptadas y Rechazadas</font>
<br/>
<table width="95%" border="1" align="center"  >
	<%
	encaDeAlta()
	while f_aprobados.Siguiente
	'----------------------------------------------
	va_nTPresu			= f_aprobados.ObtenerValor("t_presupuesto")
	va_neje 			= f_aprobados.ObtenerValor("eje_ccod")
	va_nfoco			= f_aprobados.ObtenerValor("foco_ccod")
	va_nprograma		= f_aprobados.ObtenerValor("prog_ccod")
	va_nproyecto 		= f_aprobados.ObtenerValor("proye_ccod")
	va_nobjetivo 		= f_aprobados.ObtenerValor("obje_ccod")
	vareaPresupuesta	= f_aprobados.ObtenerValor("area_tdesc")
	va_TPresu		= ""
	if(va_nTPresu = "1") then va_TPresu = "Primario" end if
	if(va_nTPresu = "2") then va_TPresu = "Secundario" end if
	'-------------------------------->>
	if 	isnull(va_nTPresu) then va_nTPresu = 0 end if
	if 	isnull(va_neje) then va_neje = 0 end if
	if 	isnull(va_nfoco) then va_nfoco = 0 end if
	if 	isnull(va_nprograma) then va_nprograma = 0 end if
	if 	isnull(va_nproyecto) then va_nproyecto = 0 end if
	if 	isnull(va_nobjetivo) then va_nobjetivo = 0 end if
	if 	isnull(vareaPresupuesta) then vareaPresupuesta = 0 end if
	'-------------------------------->>
	con_1 = "select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&va_neje
	'response.write(con_1)
	va_eje 			= conexion.consultaUno(con_1)
	va_foco			= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&va_nfoco&"")
	va_programa		= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&va_nprograma&"")
	va_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&va_nproyecto&"")
	va_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&va_nobjetivo&"")
	'----------------------------------------------
	filasDeAlta "ccen_tdesc", "ccau_tdesc", vareaPresupuesta, va_eje, va_foco, va_programa, va_proyecto, va_objetivo, "nombremes", "ccbi_ncantidad", "v_aprox", va_TPresu, "esol_tdesc"
wend
if f_aprobados.nrofilas <=0 then%>
		<tr bordercolor='#999999'>	<td colspan="14" align="center">No se encontraron solicitudes aprobadas </td></tr>
	 <% end if%>
</table>

<%
	'------------------------------------------------------------------------------------------->>
	'--		DIRECCION DE DOCENCIA	--(Vista)
	'---------------------------------

	'-------------------------------------
	'--		PPTO SERVICIOS GENERALES 	--
	'------------------------------------------------------------------------------------------->>
case 77,78,79,80:%>
<font>Pendientes</font>
<br/>
	<table width="95%" border="1" align="center"  >
<%
		encaPendientes()
		while f_solicitado.Siguiente
		'----------------------------------------------

			v_neje 			= f_solicitado.ObtenerValor("eje_ccod")
			v_nfoco			= f_solicitado.ObtenerValor("foco_ccod")
			v_nprograma		= f_solicitado.ObtenerValor("prog_ccod")
			v_nproyecto 	= f_solicitado.ObtenerValor("proye_ccod")
			v_nobjetivo 	= f_solicitado.ObtenerValor("obje_ccod")
			v_nTPresu		= f_solicitado.ObtenerValor("t_presupuesto")
			areaPresupuesta	= f_solicitado.ObtenerValor("area_tdesc")
			v_TPresu		= ""
			'---------------------------------------------------------------
			if isNull(v_neje) then v_neje  = 0 end if
			if isNull(v_nfoco) then v_nfoco  = 0 end if
			if isNull(v_nprograma) then v_nprograma  = 0 end if
			if isNull(v_nproyecto) then v_nproyecto  = 0 end if
			if isNull(v_nobjetivo) then v_nobjetivo  = 0 end if
			'---------------------------------------------------------------
			if(v_nTPresu = "1") then v_TPresu = "Primario" end if
			if(v_nTPresu = "2") then v_TPresu = "Secundario" end if
			v_eje 		= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
			v_foco		= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&v_nfoco&"")
			v_programa	= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&v_nprograma&"")
			v_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
			v_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&v_nobjetivo&"")
			'cadenaTabla()
		'----------------------------------------------
			filasPendientesSG "ccen_tdesc", "ccsg_tdesc", areaPresupuesta, v_eje, v_foco, v_programa, v_proyecto, v_objetivo, "nombremes", "ccsg_ncantidad", "v_aprox", v_TPresu, "esol_tdesc", "esol_ccod", "ccsg_ncorr", "accion", "ccsg_ncorr"
		wend

	if f_solicitado.nrofilas <=0 then%>
		<tr bordercolor='#999999'>	<td colspan="14" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
	<% end if%>

	</table>
<br/>
	<font>Aceptadas y Rechazadas</font>
	<br/>
	<table width="95%" border="1" align="center"  >

		<%
		encaDeAlta()
		while f_aprobados.Siguiente
	'----------------------------------------------
	va_nTPresu			= f_aprobados.ObtenerValor("t_presupuesto")
	va_neje 			= f_aprobados.ObtenerValor("eje_ccod")
	va_nfoco			= f_aprobados.ObtenerValor("foco_ccod")
	va_nprograma		= f_aprobados.ObtenerValor("prog_ccod")
	va_nproyecto 		= f_aprobados.ObtenerValor("proye_ccod")
	va_nobjetivo 		= f_aprobados.ObtenerValor("obje_ccod")
	vareaPresupuesta	= f_aprobados.ObtenerValor("area_tdesc")
	va_TPresu		= ""
	if(va_nTPresu = "1") then va_TPresu = "Primario" end if
	if(va_nTPresu = "2") then va_TPresu = "Secundario" end if
	'-------------------------------->>
	if 	isnull(va_nTPresu) then va_nTPresu = 0 end if
	if 	isnull(va_neje) then va_neje = 0 end if
	if 	isnull(va_nfoco) then va_nfoco = 0 end if
	if 	isnull(va_nprograma) then va_nprograma = 0 end if
	if 	isnull(va_nproyecto) then va_nproyecto = 0 end if
	if 	isnull(va_nobjetivo) then va_nobjetivo = 0 end if
	if 	isnull(vareaPresupuesta) then vareaPresupuesta = 0 end if
	'-------------------------------->>
	con_1 = "select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&va_neje
	'response.write(con_1)
	va_eje 			= conexion.consultaUno(con_1)
	va_foco			= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&va_nfoco&"")
	va_programa		= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&va_nprograma&"")
	va_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&va_nproyecto&"")
	va_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&va_nobjetivo&"")
	'----------------------------------------------
	filasDeAlta "ccen_tdesc", "ccsg_tdesc", vareaPresupuesta, va_eje, va_foco, va_programa, va_proyecto, va_objetivo, "nombremes", "ccsg_ncantidad", "v_aprox", va_TPresu, "esol_tdesc"
	wend
	if f_aprobados.nrofilas <=0 then%>
			<tr bordercolor='#999999'>	<td colspan="14" align="center">No se encontraron solicitudes aprobadas </td></tr>
		 <% end if%>
	</table>

<%
	'------------------------------------------------------------------------------------------->>
	'--		PPTO SERVICIOS GENERALES 	--
	'-------------------------------------

'-------------------------------------
'--		DIRECCION RECURSOS HUMANOS 	--
'------------------------------------------------------------------------------------------->>

case 125:%>
<font>Pendientes</font>
<br/>
<table width="95%" border="1" align="center"  >
<%
encaPendientes()
while f_solicitado.Siguiente
'----------------------------------------------
	v_neje 			= f_solicitado.ObtenerValor("eje_ccod")
	v_nfoco			= f_solicitado.ObtenerValor("foco_ccod")
	v_nprograma		= f_solicitado.ObtenerValor("prog_ccod")
	v_nproyecto 	= f_solicitado.ObtenerValor("proye_ccod")
	v_nobjetivo 	= f_solicitado.ObtenerValor("obje_ccod")
	v_nTPresu		= f_solicitado.ObtenerValor("t_presupuesto")
	areaPresupuesta	= f_solicitado.ObtenerValor("area_tdesc")
	v_TPresu		= ""
	if(v_nTPresu = "1") then v_TPresu = "Primario" end if
	if(v_nTPresu = "2") then v_TPresu = "Secundario" end if
	'------------------------------------------------------------->>
	if isNull(v_neje) then v_neje  = 0 end if
	if isNull(v_nfoco) then v_nfoco  = 0 end if
	if isNull(v_nprograma) then v_nprograma  = 0 end if
	if isNull(v_nproyecto) then v_nproyecto  = 0 end if
	if isNull(v_nobjetivo) then v_nobjetivo  = 0 end if
	if 	isnull(areaPresupuesta) then areaPresupuesta = 0 end if
	'-------------------------------------------------------------<<
	v_eje 		= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
	v_foco		= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&v_nfoco&"")
	v_programa	= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&v_nprograma&"")
	v_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
	v_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&v_nobjetivo&"")
	'cadenaTabla()
	'----------------------------------------------
	filasPendientes "ccen_tdesc", "ccpe_tdesc", areaPresupuesta, v_eje, v_foco, v_programa, v_proyecto, v_objetivo, "nombremes", "ccpe_ncantidad", "v_aprox", v_TPresu, "esol_tdesc", "esol_ccod", "ccpe_ncorr", "accion"

wend
 if f_solicitado.nrofilas <=0 then%>
	<tr bordercolor='#999999'>	<td colspan="14" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
<% end if %>
							</table>

<font>Aceptadas y Rechazadas</font>
	<br/>
	<table width="95%" border="1" align="center"  >
		<%
		encaDeAlta()
		while f_aprobados.Siguiente
	'----------------------------------------------
	va_nTPresu			= f_aprobados.ObtenerValor("t_presupuesto")
	va_neje 			= f_aprobados.ObtenerValor("eje_ccod")
	va_nfoco			= f_aprobados.ObtenerValor("foco_ccod")
	va_nprograma		= f_aprobados.ObtenerValor("prog_ccod")
	va_nproyecto 		= f_aprobados.ObtenerValor("proye_ccod")
	va_nobjetivo 		= f_aprobados.ObtenerValor("obje_ccod")
	vareaPresupuesta	= f_aprobados.ObtenerValor("area_tdesc")
	va_TPresu		= ""
	if(va_nTPresu = "1") then va_TPresu = "Primario" end if
	if(va_nTPresu = "2") then va_TPresu = "Secundario" end if
	'-------------------------------->>
	if 	isnull(va_nTPresu) then va_nTPresu = 0 end if
	if 	isnull(va_neje) then va_neje = 0 end if
	if 	isnull(va_nfoco) then va_nfoco = 0 end if
	if 	isnull(va_nprograma) then va_nprograma = 0 end if
	if 	isnull(va_nproyecto) then va_nproyecto = 0 end if
	if 	isnull(va_nobjetivo) then va_nobjetivo = 0 end if
	if 	isnull(vareaPresupuesta) then vareaPresupuesta = 0 end if
	'-------------------------------->>
	con_1 = "select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&va_neje
	'response.write(con_1)
	va_eje 			= conexion.consultaUno(con_1)
	va_foco			= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&va_nfoco&"")
	va_programa		= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&va_nprograma&"")
	va_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&va_nproyecto&"")
	va_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&va_nobjetivo&"")
	'----------------------------------------------
	filasDeAlta "ccen_tdesc", "ccpe_tdesc", vareaPresupuesta, va_eje, va_foco, va_programa, va_proyecto, va_objetivo, "nombremes", "ccpe_ncantidad", "v_aprox", va_TPresu, "esol_tdesc"

wend%>
		 <%if f_aprobados.nrofilas <=0 then%>
			<tr bordercolor='#999999'>	<td colspan="14" align="center">No se encontraron solicitudes aprobadas </td></tr>
		 <% end if%>
	</table>

<%
'------------------------------------------------------------------------------------------->>
'--		DIRECCION RECURSOS HUMANOS 	--
'-------------------------------------

'-------------------------------------------------
'--		DIRECCION aseguramiento de la calidad 	--
'------------------------------------------------------------------------------------------->>

case 69:%>
	<font>Pendientes</font>
	<br/>
	<table width="95%" border="1" align="center"  >
	<%
	encaPendientes()
	while f_solicitado.Siguiente
	'----------------------------------------------
	v_neje 			= f_solicitado.ObtenerValor("eje_ccod")
	v_nfoco			= f_solicitado.ObtenerValor("foco_ccod")
	v_nprograma		= f_solicitado.ObtenerValor("prog_ccod")
	v_nproyecto 	= f_solicitado.ObtenerValor("proye_ccod")
	v_nobjetivo 	= f_solicitado.ObtenerValor("obje_ccod")
	v_nTPresu		= f_solicitado.ObtenerValor("t_presupuesto")
	areaPresupuesta	= f_solicitado.ObtenerValor("area_tdesc")
	v_TPresu		= ""
	if(v_nTPresu = "1") then v_TPresu = "Primario" end if
	if(v_nTPresu = "2") then v_TPresu = "Secundario" end if
	'------------------------------------------------------------->>
	if isNull(v_neje) then v_neje  = 0 end if
	if isNull(v_nfoco) then v_nfoco  = 0 end if
	if isNull(v_nprograma) then v_nprograma  = 0 end if
	if isNull(v_nproyecto) then v_nproyecto  = 0 end if
	if isNull(v_nobjetivo) then v_nobjetivo  = 0 end if
	if 	isnull(areaPresupuesta) then areaPresupuesta = 0 end if
	'-------------------------------------------------------------<<
	v_eje 		= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
	v_foco		= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&v_nfoco&"")
	v_programa	= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&v_nprograma&"")
	v_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
	v_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&v_nobjetivo&"")
	'cadenaTabla()
	'----------------------------------------------
    filasPendientes "ccen_tdesc", "ccau_tdesc", areaPresupuesta, v_eje, v_foco, v_programa, v_proyecto, v_objetivo, "nombremes", "ccau_ncantidad", "v_aprox", v_TPresu, "esol_tdesc", "esol_ccod", "ccau_ncorr", "accion"
	wend
	if f_solicitado.nrofilas <=0 then%>
		<tr bordercolor='#999999'>	<td colspan="14" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
	<% end if%>
	</table>
	<br/>
	<font>Aceptadas y Rechazadas</font>
	<br/>
	<table width="95%" border="1" align="center"  >
	<%
		encaDeAlta()
		while f_aprobados.Siguiente
	'----------------------------------------------
		va_nTPresu			= f_aprobados.ObtenerValor("t_presupuesto")
		va_neje 			= f_aprobados.ObtenerValor("eje_ccod")
		va_nfoco			= f_aprobados.ObtenerValor("foco_ccod")
		va_nprograma		= f_aprobados.ObtenerValor("prog_ccod")
		va_nproyecto 		= f_aprobados.ObtenerValor("proye_ccod")
		va_nobjetivo 		= f_aprobados.ObtenerValor("obje_ccod")
		vareaPresupuesta	= f_aprobados.ObtenerValor("area_tdesc")
		va_TPresu		= ""
		if(va_nTPresu = "1") then va_TPresu = "Primario" end if
		if(va_nTPresu = "2") then va_TPresu = "Secundario" end if
		'-------------------------------->>
		if 	isnull(va_nTPresu) then va_nTPresu = 0 end if
		if 	isnull(va_neje) then va_neje = 0 end if
		if 	isnull(va_nfoco) then va_nfoco = 0 end if
		if 	isnull(va_nprograma) then va_nprograma = 0 end if
		if 	isnull(va_nproyecto) then va_nproyecto = 0 end if
		if 	isnull(va_nobjetivo) then va_nobjetivo = 0 end if
		if 	isnull(vareaPresupuesta) then vareaPresupuesta = 0 end if
		'-------------------------------->>
		con_1 = "select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&va_neje
		'response.write(con_1)
		va_eje 			= conexion.consultaUno(con_1)
		va_foco			= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&va_nfoco&"")
		va_programa		= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&va_nprograma&"")
		va_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&va_nproyecto&"")
		va_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&va_nobjetivo&"")
	'----------------------------------------------
		filasDeAlta "ccen_tdesc", "ccau_tdesc", vareaPresupuesta, va_eje, va_foco, va_programa, va_proyecto, va_objetivo, "nombremes", "ccau_ncantidad", "v_aprox", va_TPresu, "esol_tdesc"

		wend
		if f_aprobados.nrofilas <=0 then%>
			<tr bordercolor='#999999'>	<td colspan="14" align="center">No se encontraron solicitudes aprobadas </td></tr>
		<% end if%>
	</table>

<%
'------------------------------------------------------------------------------------------->>
'--		DIRECCION aseguramiento de la calidad 	--
'-------------------------------------------------


'-------------------------------------------------
'--		Departamento de asuntos estudiantiles  	--
'------------------------------------------------------------------------------------------->>

case 87:%>
	<font>Pendientes</font>
	<br/>
	<table width="95%" border="1" align="center"  >
	<%
	encaPendientes()
	while f_solicitado.Siguiente
	'----------------------------------------------
	v_neje 			= f_solicitado.ObtenerValor("eje_ccod")
	v_nfoco			= f_solicitado.ObtenerValor("foco_ccod")
	v_nprograma		= f_solicitado.ObtenerValor("prog_ccod")
	v_nproyecto 	= f_solicitado.ObtenerValor("proye_ccod")
	v_nobjetivo 	= f_solicitado.ObtenerValor("obje_ccod")
	v_nTPresu		= f_solicitado.ObtenerValor("t_presupuesto")
	areaPresupuesta	= f_solicitado.ObtenerValor("area_tdesc")
	v_TPresu		= ""
	if(v_nTPresu = "1") then v_TPresu = "Primario" end if
	if(v_nTPresu = "2") then v_TPresu = "Secundario" end if
	'------------------------------------------------------------->>
	if isNull(v_neje) then v_neje  = 0 end if
	if isNull(v_nfoco) then v_nfoco  = 0 end if
	if isNull(v_nprograma) then v_nprograma  = 0 end if
	if isNull(v_nproyecto) then v_nproyecto  = 0 end if
	if isNull(v_nobjetivo) then v_nobjetivo  = 0 end if
	if 	isnull(areaPresupuesta) then areaPresupuesta = 0 end if
	'-------------------------------------------------------------<<
	v_eje 		= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
	v_foco		= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&v_nfoco&"")
	v_programa	= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&v_nprograma&"")
	v_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
	v_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&v_nobjetivo&"")
	'cadenaTabla()
	'----------------------------------------------
    filasPendientes "ccen_tdesc", "ccau_tdesc", areaPresupuesta, v_eje, v_foco, v_programa, v_proyecto, v_objetivo, "nombremes", "ccau_ncantidad", "v_aprox", v_TPresu, "esol_tdesc", "esol_ccod", "ccau_ncorr", "accion"
	wend
	if f_solicitado.nrofilas <=0 then%>
		<tr bordercolor='#999999'>	<td colspan="14" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
	<% end if%>
	</table>
	<br/>
	<font>Aceptadas y Rechazadas</font>
	<br/>
	<table width="95%" border="1" align="center"  >
	<%
		encaDeAlta()
		while f_aprobados.Siguiente
	'----------------------------------------------
		va_nTPresu			= f_aprobados.ObtenerValor("t_presupuesto")
		va_neje 			= f_aprobados.ObtenerValor("eje_ccod")
		va_nfoco			= f_aprobados.ObtenerValor("foco_ccod")
		va_nprograma		= f_aprobados.ObtenerValor("prog_ccod")
		va_nproyecto 		= f_aprobados.ObtenerValor("proye_ccod")
		va_nobjetivo 		= f_aprobados.ObtenerValor("obje_ccod")
		vareaPresupuesta	= f_aprobados.ObtenerValor("area_tdesc")
		va_TPresu		= ""
		if(va_nTPresu = "1") then va_TPresu = "Primario" end if
		if(va_nTPresu = "2") then va_TPresu = "Secundario" end if
		'-------------------------------->>
		if 	isnull(va_nTPresu) then va_nTPresu = 0 end if
		if 	isnull(va_neje) then va_neje = 0 end if
		if 	isnull(va_nfoco) then va_nfoco = 0 end if
		if 	isnull(va_nprograma) then va_nprograma = 0 end if
		if 	isnull(va_nproyecto) then va_nproyecto = 0 end if
		if 	isnull(va_nobjetivo) then va_nobjetivo = 0 end if
		if 	isnull(vareaPresupuesta) then vareaPresupuesta = 0 end if
		'-------------------------------->>
		con_1 = "select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&va_neje
		'response.write(con_1)
		va_eje 			= conexion.consultaUno(con_1)
		va_foco			= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&va_nfoco&"")
		va_programa		= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&va_nprograma&"")
		va_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&va_nproyecto&"")
		va_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&va_nobjetivo&"")
	'----------------------------------------------
		filasDeAlta "ccen_tdesc", "ccau_tdesc", vareaPresupuesta, va_eje, va_foco, va_programa, va_proyecto, va_objetivo, "nombremes", "ccau_ncantidad", "v_aprox", va_TPresu, "esol_tdesc"

		wend
		if f_aprobados.nrofilas <=0 then%>
			<tr bordercolor='#999999'>	<td colspan="14" align="center">No se encontraron solicitudes aprobadas </td></tr>
		<% end if%>
	</table>

<%
'------------------------------------------------------------------------------------------->>
'--		Departamento de asuntos estudiantiles  	--
'-------------------------------------------------


'-------------------------------------------------
'--		Vicerector?a acad?mica  	--
'------------------------------------------------------------------------------------------->>

case 83:%>
	<font>Pendientes</font>
	<br/>
	<table width="95%" border="1" align="center"  >
	<%
	encaPendientes()
	while f_solicitado.Siguiente
	'----------------------------------------------
	v_neje 			= f_solicitado.ObtenerValor("eje_ccod")
	v_nfoco			= f_solicitado.ObtenerValor("foco_ccod")
	v_nprograma		= f_solicitado.ObtenerValor("prog_ccod")
	v_nproyecto 	= f_solicitado.ObtenerValor("proye_ccod")
	v_nobjetivo 	= f_solicitado.ObtenerValor("obje_ccod")
	v_nTPresu		= f_solicitado.ObtenerValor("t_presupuesto")
	areaPresupuesta	= f_solicitado.ObtenerValor("area_tdesc")
	v_TPresu		= ""
	if(v_nTPresu = "1") then v_TPresu = "Primario" end if
	if(v_nTPresu = "2") then v_TPresu = "Secundario" end if
	'------------------------------------------------------------->>
	if isNull(v_neje) then v_neje  = 0 end if
	if isNull(v_nfoco) then v_nfoco  = 0 end if
	if isNull(v_nprograma) then v_nprograma  = 0 end if
	if isNull(v_nproyecto) then v_nproyecto  = 0 end if
	if isNull(v_nobjetivo) then v_nobjetivo  = 0 end if
	if 	isnull(areaPresupuesta) then areaPresupuesta = 0 end if
	'-------------------------------------------------------------<<
	v_eje 		= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
	v_foco		= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&v_nfoco&"")
	v_programa	= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&v_nprograma&"")
	v_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
	v_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&v_nobjetivo&"")
	'cadenaTabla()
	'----------------------------------------------
    filasPendientes "ccen_tdesc", "ccau_tdesc", areaPresupuesta, v_eje, v_foco, v_programa, v_proyecto, v_objetivo, "nombremes", "ccau_ncantidad", "v_aprox", v_TPresu, "esol_tdesc", "esol_ccod", "ccau_ncorr", "accion"
	wend
	if f_solicitado.nrofilas <=0 then%>
		<tr bordercolor='#999999'>	<td colspan="14" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
	<% end if%>
	</table>
	<br/>
	<font>Aceptadas y Rechazadas</font>
	<br/>
	<table width="95%" border="1" align="center"  >
	<%
		encaDeAlta()
		while f_aprobados.Siguiente
	'----------------------------------------------
		va_nTPresu			= f_aprobados.ObtenerValor("t_presupuesto")
		va_neje 			= f_aprobados.ObtenerValor("eje_ccod")
		va_nfoco			= f_aprobados.ObtenerValor("foco_ccod")
		va_nprograma		= f_aprobados.ObtenerValor("prog_ccod")
		va_nproyecto 		= f_aprobados.ObtenerValor("proye_ccod")
		va_nobjetivo 		= f_aprobados.ObtenerValor("obje_ccod")
		vareaPresupuesta	= f_aprobados.ObtenerValor("area_tdesc")
		va_TPresu		= ""
		if(va_nTPresu = "1") then va_TPresu = "Primario" end if
		if(va_nTPresu = "2") then va_TPresu = "Secundario" end if
		'-------------------------------->>
		if 	isnull(va_nTPresu) then va_nTPresu = 0 end if
		if 	isnull(va_neje) then va_neje = 0 end if
		if 	isnull(va_nfoco) then va_nfoco = 0 end if
		if 	isnull(va_nprograma) then va_nprograma = 0 end if
		if 	isnull(va_nproyecto) then va_nproyecto = 0 end if
		if 	isnull(va_nobjetivo) then va_nobjetivo = 0 end if
		if 	isnull(vareaPresupuesta) then vareaPresupuesta = 0 end if
		'-------------------------------->>
		con_1 = "select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&va_neje
		'response.write(con_1)
		va_eje 			= conexion.consultaUno(con_1)
		va_foco			= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&va_nfoco&"")
		va_programa		= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&va_nprograma&"")
		va_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&va_nproyecto&"")
		va_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&va_nobjetivo&"")
	'----------------------------------------------
		filasDeAlta "ccen_tdesc", "ccau_tdesc", vareaPresupuesta, va_eje, va_foco, va_programa, va_proyecto, va_objetivo, "nombremes", "ccau_ncantidad", "v_aprox", va_TPresu, "esol_tdesc"

		wend
		if f_aprobados.nrofilas <=0 then%>
			<tr bordercolor='#999999'>	<td colspan="14" align="center">No se encontraron solicitudes aprobadas </td></tr>
		<% end if%>
	</table>

<%
'------------------------------------------------------------------------------------------->>
'--		Vicerector?a acad?mica  	--
'-------------------------------------------------
	case else:%>

		<center><font size="2" color="#FF0000">Su ?rea presupuestaria, no centraliza solicitudes de presupuesto</font></center>
	<%End Select%>
<%End Select%>
						<br/>
						</td></tr></table>
						</td>
                          </tr>
                        </table></td>
                      		<td width="7" background="../imagenes/marco_claro/10.gif">&nbsp;</td>
                    	</tr>
					  	<tr>
							<td align="left" valign="top"><img src="../imagenes/marco_claro/17.gif" width="9" height="28"></td>
							<td valign="top">
							<!-- desde aca -->
							<table  width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
                          		<tr >
                            		<td width="47%" height="20"><div align="center">
                                		<table width="94%"  border="0" cellspacing="0" cellpadding="0">
										  	<tr>
											<%
											select case (nro_t)
												case 1:
												%>
												<td width="49%">
													<% botonera.DibujaBoton ("excel_solicitud")%>
												</td>
												<td width="100%">
													<%
													'if sin_bloqueo then
													'if v_detalle<>""  and codcaja <> "" then
														botonera.DibujaBoton ("grabar")
													'end if
													'end if
													%>
												</td>
												<td width="21%">
													<%if mes_venc<>"" then
													 botonera.DibujaBoton ("excel_detalle")
													end if%>
												</td>

												<%case 2:%>
												<td width="100%">
													<%botonera.DibujaBoton ("excel_solicitud_mensual")%>
												</td>
												<% end select %>
										  	</tr>
                                		</table>
                              </div></td>
								<td width="53%" rowspan="2" background="../imagenes/marco_claro/15.gif"><img src="../imagenes/marco_claro/14.gif" width="12" height="28"></td>
                          	</tr>
							   <tr>
                            		<td height="8" background="../imagenes/marco_claro/13.gif"></td>
                          		</tr>
							</table>
							<!-- hasta aca
							<img src="../imagenes/marco_claro/15.gif" width="100%" height="13">--></td>
							<td align="right" valign="top" height="13"><img src="../imagenes/marco_claro/16.gif" width="7"height="28"></td>
					  	</tr>
                  </table>
				  <% end if %>
                    <br/>
					<br/>
                </td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="10" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                <td width="152" bgcolor="#D8D8DE"><table width="100%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><% botonera.DibujaBoton ("lanzadera") %></td>
                    </tr>
                  </table>
                </td>
                <td width="100%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                <td width="7" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
              </tr>
              <tr>
                <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
              </tr>
            </table>
        </td>
      </tr>
    </table>
	<p>&nbsp;</p></td>
  </tr>
</table>
</body>
</html>						<input type='HIDDEN' name='total_solicitud_' value='0'>
										</td>
									 </tr>
								  </table>
