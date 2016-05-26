<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
sin_bloqueo=true '(con false bloquea las nuevas solicitudes)
'sin_bloqueo=true '(Habilita las nuevas solicitudes)

Server.ScriptTimeout = 2000 
set pagina = new CPagina
pagina.Titulo = "Solicitud Presupuestaria 2013"
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
 
 codcaja	= request.querystring("busqueda[0][codcaja]")
 area_ccod	= request.querystring("busqueda[0][area_ccod]")
 mes_venc	= request.querystring("busqueda[0][mes_venc]")  
 nro_t		= request.querystring("nro_t")
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
 'v_prox_anio	=	v_anio_actual ' se agrego por que el 2010 el presupuesto paso de año y deben seguir entrando al 2011
 
 'response.Write(" v_anio_actual: "&v_anio_actual&" v_prox_anio:"&v_prox_anio)
 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "solicitud_presupuestaria.xml", "busqueda_presupuesto"
 f_busqueda.Inicializar conexion2
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoParam "area_ccod", "filtro",  "area_ccod in ( select area_ccod from  presupuesto_upa.protic.area_presupuesto_usuario  where rut_usuario in ('"&v_usuario&"') )"
 f_busqueda.AgregaCampoCons "area_ccod", area_ccod

 f_busqueda.AgregaCampoParam "codcaja", "destino",  " (select distinct cod_pre, concepto_pre +' ('+cod_pre+')' as valor from presupuesto_upa.protic.codigos_presupuesto where cod_area in ('"&area_ccod&"')) a "
 f_busqueda.AgregaCampoCons "codcaja", codcaja
 f_busqueda.AgregaCampoCons "detalle", v_detalle
'f_busqueda.AgregaCampoCons "concepto", v_concepto
 
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
	 
	 f_busqueda.AgregaCampoParam "detalle", "destino",  " (select distinct cpre_ncorr,cod_pre,concepto_pre, detalle_pre from presupuesto_upa.protic.codigos_presupuesto) a "
	 f_busqueda.AgregaCampoParam "detalle", "filtro",  " cod_pre in ('"&codcaja&"') "
	 
	 txt_detalle= conexion2.ConsultaUno("select detalle_pre from presupuesto_upa.protic.codigos_presupuesto where cast(cpre_ncorr as varchar)='"&v_detalle&"'")
 else
    'f_busqueda.AgregaCampoParam "concepto", "destino",  " (select '' as cod_pre, '' as concepto_pre where 1=1 ) a "
	'f_busqueda.AgregaCampoParam "concepto", "deshabilitado", "true"
    f_busqueda.AgregaCampoParam "detalle", "destino",  " (select '' as cpre_ncorr,'' as cod_pre,'' as concepto_pre, '' as detalle_pre where 1=1 ) a "
	f_busqueda.AgregaCampoParam "detalle", "deshabilitado", "true"
 end if
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
						
				sql_meses= "	select  upper(nombremes) as mes,indice as mes_venc,sum(cast(isnull(solicitado,0) as numeric)) as solicitado,   "& vbCrLf &_ 
							" sum(cast(isnull(presupuestado,0) as numeric)) as presupuestado "& vbCrLf &_
							"	 from softland.sw_mesce as b   "& vbCrLf &_
							"	 left outer join (  "& vbCrLf &_
							"		select pa.mes as mes, sum(solicitado) as solicitado,sum(presupuestado) as presupuestado "& vbCrLf &_
							"			from     	"& vbCrLf &_
							"				( 		"& vbCrLf &_
							"				select sum(valor) as presupuestado,0 as solicitado,mes,cod_anio, cod_pre, cod_area, descripcion_area,concepto "& vbCrLf &_
							"				from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2012     "& vbCrLf &_
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
						" and cajcod in (select distinct cod_pre from presupuesto_upa.protic.vis_presupuesto_anual where cod_area="&area_ccod&") "
			
			
				sql_meses= "	select  upper(nombremes) as mes,indice as mes_venc,sum(cast(isnull(solicitado,0) as numeric)) as solicitado,   "& vbCrLf &_ 
							" sum(cast(isnull(presupuestado,0) as numeric)) as presupuestado "& vbCrLf &_
							"	 from softland.sw_mesce as b   "& vbCrLf &_
							"	 left outer join (  "& vbCrLf &_
							"		select pa.mes as mes, sum(solicitado) as solicitado,sum(presupuestado) as presupuestado "& vbCrLf &_
							"			from     "& vbCrLf &_
							"				(select sum(valor) as presupuestado,0 as solicitado,mes,cod_anio,cod_area, descripcion_area "& vbCrLf &_
							"				from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2012     "& vbCrLf &_
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
								" and cajcod in (select distinct cod_pre from presupuesto_upa.protic.vis_presupuesto_anual where cod_area="&area_ccod&") "
						
			
			end if
		
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
			set f_presupuestado = new CFormulario
			f_presupuestado.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			f_presupuestado.Inicializar conexion2
			
			if codcaja <> "" then
			 
				sql_presupuestado	=" SELECT concepto, detalle, cod_pre,isnull(total,0) as total, "& vbCrLf &_
									" isnull(enero,0) as enero, isnull(febrero,0) as febrero, isnull(marzo,0) as marzo, isnull(abril,0) as abril, "& vbCrLf &_
									" isnull(mayo,0) as mayo, isnull(junio,0) as junio, isnull(julio,0) as julio, isnull(agosto,0) as agosto, "& vbCrLf &_
									" isnull(septiembre,0) as septiembre,isnull(octubre,0) as octubre, isnull(noviembre,0) as noviembre,  "& vbCrLf &_
									" isnull(diciembre,0) as diciembre, isnull(enero_prox,0) as enero_prox,isnull(febrero_prox,0) as febrero_prox "& vbCrLf &_
									"  FROM presupuesto_upa.protic.solicitud_presupuesto_upa "& vbCrLf &_
									"  where cod_pre = '"&codcaja&"' "& vbCrLf &_
									"  and cod_anio=year(getdate())+1"
			else
				sql_presupuestado	=" SELECT concepto, detalle, cod_pre,isnull(total,0) as total, "& vbCrLf &_
									" isnull(enero,0) as enero, isnull(febrero,0) as febrero, isnull(marzo,0) as marzo, isnull(abril,0) as abril, "& vbCrLf &_
									" isnull(mayo,0) as mayo, isnull(junio,0) as junio, isnull(julio,0) as julio, isnull(agosto,0) as agosto, "& vbCrLf &_
									" isnull(septiembre,0) as septiembre,isnull(octubre,0) as octubre, isnull(noviembre,0) as noviembre,  "& vbCrLf &_
									" isnull(diciembre,0) as diciembre, isnull(enero_prox,0) as enero_prox,isnull(febrero_prox,0) as febrero_prox "& vbCrLf &_
									"  FROM presupuesto_upa.protic.solicitud_presupuesto_upa "& vbCrLf &_
									"  where cod_pre in (select distinct cod_pre from presupuesto_upa.protic.vis_solicitud_presupuesto_anual where cod_area="&area_ccod&")  "& vbCrLf &_
									"  and cod_anio=year(getdate())+1"
			end if
			
			f_presupuestado.consultar sql_presupuestado
			
		case 3:
			'Correspondiente a la pestaña de solicitudes centralizadas por otras areas
			set f_solicitado = new CFormulario
			f_solicitado.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			f_solicitado.Inicializar conexion2
		
			set f_aprobados = new CFormulario
			f_aprobados.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			f_aprobados.Inicializar conexion2

			select case (area_ccod)
			case 88:
				sql_solicitud="select *, case a.esol_ccod when 1 then 'Dar Alta' end as accion,nombremes "& vbCrLf &_
							" from presupuesto_upa.protic.centralizar_solicitud_audiovisual a, presupuesto_upa.protic.concepto_centralizado b, "& vbCrLf &_
							" presupuesto_upa.protic.estado_solicitud c, presupuesto_upa.protic.area_presupuestal d, softland.sw_mesce e "& vbCrLf &_
							"	where a.tpre_ccod in (1) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
							"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
							"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
							"	and a.area_ccod=d.area_ccod "& vbCrLf &_
							"	and isnull(mes_ccod,1)=e.indice "& vbCrLf &_
							"	and a.esol_ccod=1 and anio_ccod="&v_prox_anio

				sql_aprobadas="select *, case a.esol_ccod when 1 then 'Dar Alta' end as accion ,nombremes"& vbCrLf &_
							" from presupuesto_upa.protic.centralizar_solicitud_audiovisual a, presupuesto_upa.protic.concepto_centralizado b, "& vbCrLf &_
							" presupuesto_upa.protic.estado_solicitud c, presupuesto_upa.protic.area_presupuestal d, softland.sw_mesce e "& vbCrLf &_
							"	where a.tpre_ccod in (1) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
							"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
							"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
							"	and a.area_ccod=d.area_ccod "& vbCrLf &_
							"	and isnull(mes_ccod,1)=e.indice "& vbCrLf &_
							"	and a.esol_ccod not in (1,3) and anio_ccod="&v_prox_anio
				
			case 8:
				sql_solicitud="select *, case a.esol_ccod when 1 then 'Dar Alta' end as accion,nombremes "& vbCrLf &_
							" from presupuesto_upa.protic.centralizar_solicitud_biblioteca a, presupuesto_upa.protic.concepto_centralizado b, "& vbCrLf &_
							" presupuesto_upa.protic.estado_solicitud c, presupuesto_upa.protic.area_presupuestal d, softland.sw_mesce e "& vbCrLf &_
							"	where a.tpre_ccod in (2) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
							"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
							"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
							"	and a.area_ccod=d.area_ccod "& vbCrLf &_
							"	and isnull(mes_ccod,1)=e.indice "& vbCrLf &_
							"	and a.esol_ccod=1 and anio_ccod="&v_prox_anio
							
				sql_aprobadas="select *, case a.esol_ccod when 1 then 'Dar Alta' end as accion,nombremes "& vbCrLf &_
								" from presupuesto_upa.protic.centralizar_solicitud_biblioteca a, presupuesto_upa.protic.concepto_centralizado b, "& vbCrLf &_
								" presupuesto_upa.protic.estado_solicitud c, presupuesto_upa.protic.area_presupuestal d, softland.sw_mesce e "& vbCrLf &_
								"	where a.tpre_ccod in (2) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
								"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
								"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
								"	and a.area_ccod=d.area_ccod "& vbCrLf &_
								"	and isnull(mes_ccod,1)=e.indice "& vbCrLf &_
								"	and a.esol_ccod not in (1,3) and anio_ccod="&v_prox_anio							
			case 15:
				sql_solicitud="select *, case a.esol_ccod when 1 then 'Dar Alta' end as accion,nombremes "& vbCrLf &_
							" from presupuesto_upa.protic.centralizar_solicitud_computacion a, presupuesto_upa.protic.concepto_centralizado b, "& vbCrLf &_
							" presupuesto_upa.protic.estado_solicitud c, presupuesto_upa.protic.area_presupuestal d, softland.sw_mesce e "& vbCrLf &_
							"	where a.tpre_ccod in (3) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
							"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
							"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
							"	and a.area_ccod=d.area_ccod "& vbCrLf &_
							"	and isnull(mes_ccod,1)=e.indice "& vbCrLf &_
							"	and a.esol_ccod=1 and anio_ccod="&v_prox_anio
							
				sql_aprobadas="select *, case a.esol_ccod when 1 then 'Dar Alta' end as accion,nombremes "& vbCrLf &_
								" from presupuesto_upa.protic.centralizar_solicitud_computacion a, presupuesto_upa.protic.concepto_centralizado b, "& vbCrLf &_
								" presupuesto_upa.protic.estado_solicitud c, presupuesto_upa.protic.area_presupuestal d, softland.sw_mesce e "& vbCrLf &_
								"	where a.tpre_ccod in (3) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
								"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
								"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
								"	and a.area_ccod=d.area_ccod "& vbCrLf &_
								"	and isnull(mes_ccod,1)=e.indice "& vbCrLf &_
								"	and a.esol_ccod not in (1,3) and anio_ccod="&v_prox_anio							
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
				
				sql_solicitud="select *, case a.esol_ccod when 1 then 'Dar Alta' end as accion,nombremes "& vbCrLf &_
							" from presupuesto_upa.protic.centralizar_solicitud_servicios_generales a, presupuesto_upa.protic.concepto_centralizado b, "& vbCrLf &_ 
							" presupuesto_upa.protic.estado_solicitud c, presupuesto_upa.protic.area_presupuestal d, softland.sw_mesce e "& vbCrLf &_
							"	where a.tpre_ccod in (4) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
							"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
							"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
							"	and a.area_ccod=d.area_ccod "& vbCrLf &_
							"	and isnull(mes_ccod,1)=e.indice "& vbCrLf &_
							"   and isnull(a.sede_ccod,1)="&v_sede_ccod&" "& vbCrLf &_
							"	and a.esol_ccod=1 and anio_ccod="&v_prox_anio
							
				sql_aprobadas="select *, case a.esol_ccod when 1 then 'Dar Alta' end as accion,nombremes "& vbCrLf &_
								" from presupuesto_upa.protic.centralizar_solicitud_servicios_generales a, presupuesto_upa.protic.concepto_centralizado b, "& vbCrLf &_
								" presupuesto_upa.protic.estado_solicitud c, presupuesto_upa.protic.area_presupuestal d, softland.sw_mesce e "& vbCrLf &_
								"	where a.tpre_ccod in (4) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
								"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
								"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
								"	and a.area_ccod=d.area_ccod "& vbCrLf &_
								"	and isnull(mes_ccod,1)=e.indice "& vbCrLf &_
								"   and isnull(a.sede_ccod,1)="&v_sede_ccod&" "& vbCrLf &_
								"	and a.esol_ccod not in (1,3) and anio_ccod="&v_prox_anio							
			case 75:
				sql_solicitud="select *, case a.esol_ccod when 1 then 'Dar Alta' end as accion,nombremes "& vbCrLf &_
							" from presupuesto_upa.protic.centralizar_solicitud_personal a, presupuesto_upa.protic.concepto_centralizado b, "& vbCrLf &_
							" presupuesto_upa.protic.estado_solicitud c, presupuesto_upa.protic.area_presupuestal d, softland.sw_mesce e "& vbCrLf &_
							"	where a.tpre_ccod in (5) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
							"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
							"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
							"	and a.area_ccod=d.area_ccod "& vbCrLf &_
							"	and isnull(mes_ccod,1)=e.indice "& vbCrLf &_
							"	and a.esol_ccod=1 and anio_ccod="&v_prox_anio

				sql_aprobadas="select *, case a.esol_ccod when 1 then 'Dar Alta' end as accion,nombremes "& vbCrLf &_
								" from presupuesto_upa.protic.centralizar_solicitud_personal a, presupuesto_upa.protic.concepto_centralizado b, "& vbCrLf &_
								" presupuesto_upa.protic.estado_solicitud c, presupuesto_upa.protic.area_presupuestal d, softland.sw_mesce e "& vbCrLf &_
								"	where a.tpre_ccod in (5) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
								"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
								"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
								"	and a.area_ccod=d.area_ccod "& vbCrLf &_
								"	and isnull(mes_ccod,1)=e.indice "& vbCrLf &_
								"	and a.esol_ccod not in (1,3) and anio_ccod="&v_prox_anio							
			case else
				sql_solicitud="select '' "
				sql_aprobadas="select '' "
			end select

		'response.Write("<pre>"&sql_solicitud&"<pre>")
		'response.End()
		f_solicitado.consultar sql_solicitud
		f_aprobados.consultar sql_aprobadas

	
	end select	

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
%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

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

function CargarConcepto(formulario)
{

	_Buscar(this, document.forms['busca_codigo'],'', 'Validar();', 'FALSE');
}


function CargarDetalles(formulario)
{
	_Buscar(this, document.forms['busca_codigo'],'', 'Validar();', 'FALSE');
}

function GuardarDetalle()
{
	formulario=document.forms['busca_codigo'];
	formulario.action = "proc_agrega_detalle.asp";
	formulario.method = "post";
	formulario.submit(); 

}

function ver_detalle(var1,var2,var3){
	formulario=document.forms['busca_codigo'];
	formulario.elements["busqueda[0][mes_venc]"].value=var3
	_Buscar(this, document.forms['busca_codigo'],'', 'Validar();', 'FALSE');

}



function ValidaNumero(elemento){
	formulario=document.forms['solicitud'];
	cadena=elemento.name;
	valor_nuevo=cadena.substring(1,cadena.Length); 
//alert(elemento.value);
	if(isNumber(formulario.elements[valor_nuevo].value)){
		CalcularTotalSolicitado();
		return true;
	}else{
		alert("Ingrese un numero válido");
		elemento.value="0";
		elemento.focus();
	}
}

function CalcularTotalSolicitado()
{
	var formulario = document.forms["solicitud"];
	
	v_total_solicitud = 0;
	
	for (var i = 0; i < 12; i++) {
		if (formulario.elements["test["+i+"][solicitado]"].value){
			v_total_solicitud = v_total_solicitud + parseInt(formulario.elements["test["+i+"][solicitado]"].value);
		}
	}
	
	formulario.total_solicitud.value=	FormatoMoneda(String(v_total_solicitud));

}


function FormatoMoneda(valor){
	salida = '';
	numDecimales=0;

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
	return salida;			
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
	
	//"Esta apunto de copiar el presupuesto del año anterior asociado a:\n\t Area:"+v_area+"\n\t Código:"+v_codigo+"\n\t Concepto: "+v_concepto+"\n\t Detalle: "+v_detalle+" \n¿Esta seguro de realizar esta acción?. Los datos puedes ser modificados posteriormente."
	if(confirm("Esta apunto de copiar el presupuesto del año anterior asociado a:\n\t Area: "+v_area+"\n\t Código: "+v_codigo+"\n\t Detalle: "+v_detalle+" \n¿Esta seguro de realizar esta acción?. Los datos puedes ser modificados posteriormente.")){
		formulario=document.forms['busca_codigo'];
		formulario.action = "proc_cargar_anterior.asp";
		formulario.method = "post";
		formulario.submit(); 
	}
	return false;
}

function GrabarRegistro()
{
	formulario=document.forms['solicitud'];
	formulario.action = "proc_grabar_solicitud.asp";
	formulario.method = "post";
	formulario.submit(); 

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
	if(confirm("Está a punto de rechazar una solicitud, desea continuar?")){
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


<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
                              <%pagina.DibujarLenguetasFClaro Array(array("Carga","ingreso_presupuesto_directo_2013.asp?area_ccod="&area_ccod&"&codcaja="& codcaja &"&nro_t=1"),array("Solicitud Presupuestado","ingreso_presupuesto_directo_2013.asp?area_ccod="&area_ccod&"&codcaja="& codcaja &"&nro_t=2"),array("Solicitud Centralizada","ingreso_presupuesto_directo_2013.asp?area_ccod="&area_ccod&"&codcaja="& codcaja &"&nro_t=3")), nro_t %>
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
									<form name="busca_codigo" method="get">
									<input type="hidden" name="nro_t" value="<%=nro_t%>" >
									<input type="hidden" name="busqueda[0][area_ccod]" value="<%=area_ccod%>"/>
									<input type="hidden" name="busqueda[0][mes_venc]" value=""/>
									<table width="100%" border="0">
										<tr>
											<td colspan="2" align="center"><%
											if sin_bloqueo then
											botonera.DibujaBoton ("anterior")
											end if
											%><br></td>
										</tr>									
										<tr>                          
											<td colspan="2"><div align="left"><strong>Concepto  presupuestario</strong></div></td>
										</tr>
										<tr>
											<td colspan="2"><% f_busqueda.DibujaCampo("codcaja") %></td>
										</tr>
<!--										
										<tr>
										  <td><strong>Concepto presupuesto</strong> </td>
										</tr>
										<tr>
											<td colspan="3" align="left"><%'f_busqueda.DibujaCampo ("concepto")%></td>
										</tr>
-->
										<tr>
										  <td colspan="2"><strong>Detalle presupuesto</strong> </td>
										</tr>
										<tr>
											<td colspan="2" align="left"><%f_busqueda.DibujaCampo ("detalle")%></td>
										</tr>
										<tr>
										  <td><strong>Agrega nuevo detalle</strong> </td>
										</tr>										
										<tr>
											<td align="left"><%f_busqueda.DibujaCampo ("nuevo_detalle")%></td>
											<td align="left"><%	
													if sin_bloqueo then
														if mostrar_agregar then
															botonera.DibujaBoton ("guardar")
														end if
													end if
													%>
											</td>
										</tr>											
									</table>
									<br>
									<center>
									</center>
									</form>
									<div align="center"><b>Descargar las bases presupuestarias 2012</b><br/>
								  <a href="BASES FOR PRESUPUESTARIA 2012.pdf" target="_new"><img src="../imagenes/descargar.png" width="75" height="75" border="0" alt="Descargar Bases" align="middle" /></a></div></td>
								<td width="70%">
								
									<form name="presupuesto" method="post" >
										<input type="hidden" name="nro_t" value="<%=nro_t%>" >
										<input type="hidden" name="codcaja" value="<%=codcaja%>">
										<input type="hidden" name="area_ccod" value="<%=area_ccod%>">
									</form>
									
 								<form name="solicitud">
							
									  <input type="hidden" name="codcaja" value="<%=codcaja%>">
									  <input type="hidden" name="area_ccod" value="<%=area_ccod%>">
									  <!--<input type="hidden" name="concepto" value="<%=v_concepto%>">-->
									  <input type="hidden" name="detalle" value="<%=v_detalle%>">

									<center><font color="#0000CC" size="2"><%=txt_detalle%></font></center>
								  <table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
									  <th width="33%">MES</th>
									  <th width="19%"><%=v_prox_anio%></th>
									  <th width="48%"><%=v_anio_actual%></th>
									</tr>
									<%
									v_total_soli	=0
									v_total_presu	=0
									'v_total_desvi	=0
									while f_meses.Siguiente
										v_total_soli	=	v_total_soli	+	Cdbl(f_meses.ObtenerValor("solicitado"))
										v_total_presu	=	v_total_presu	+	Cdbl(f_meses.ObtenerValor("presupuestado"))
										v_mes_venc		=	Cint(f_meses.ObtenerValor("mes_venc"))
									%>
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><a href="JAVASCRIPT:ver_detalle(<%=area_ccod%>,'<%=codcaja%>',<%=v_mes_venc%>);" class="meses"><%f_meses.DibujaCampo("mes")%></a></font></td>
									  <td><%=f_meses.DibujaCampo("solicitado")%></td><td><%=formatcurrency(f_meses.ObtenerValor("presupuestado"),0)%><%=f_meses.DibujaCampo("presupuestado")%></td>
									</tr>
									 <%wend%>
									 <tr bordercolor='#999999'>
										<td><a href="JAVASCRIPT:ver_detalle(<%=area_ccod%>,'<%=codcaja%>',0);"><b>TOTAL</b></a></td>
										<td align="right"><input type='text' name='total_solicitud' value='' readonly style="background-color:#EDEDEF;border: 1px #EDEDEF solid;">
										</td>
										<td><b><%=formatcurrency(v_total_presu,0,0)%></b></td>
									 </tr>
								  </table>
								  </form>
							</td></tr>
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
											<td width="155"><div align="left"><strong>Código presupuestario</strong></div></td>
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
										  <th width="25%">ENERO PROX</th>
										  <th width="25%">FEBRERO PROX</th>
										  <th width="25%">TOTAL</th>
										</tr>
									<%
									while f_presupuestado.Siguiente
										v_total		=	v_total		+	Cdbl(f_presupuestado.ObtenerValor("total"))
										v_enero		=	v_enero		+	Cdbl(f_presupuestado.ObtenerValor("enero"))
										v_febrero	=	v_febrero	+	Cdbl(f_presupuestado.ObtenerValor("febrero"))
										v_marzo		=	v_marzo		+	Cdbl(f_presupuestado.ObtenerValor("marzo"))
										v_abril		=	v_abril		+	Cdbl(f_presupuestado.ObtenerValor("abril"))
										v_mayo		=	v_mayo		+	Cdbl(f_presupuestado.ObtenerValor("mayo"))
										v_junio		=	v_junio		+	Cdbl(f_presupuestado.ObtenerValor("junio"))
										v_julio		=	v_julio		+	Cdbl(f_presupuestado.ObtenerValor("julio"))
										v_agosto	=	v_agosto	+	Cdbl(f_presupuestado.ObtenerValor("agosto"))
										v_septiembre=	v_septiembre	+	Cdbl(f_presupuestado.ObtenerValor("septiembre"))
										v_octubre	=	v_octubre		+	Cdbl(f_presupuestado.ObtenerValor("octubre"))
										v_noviembre	=	v_noviembre		+	Cdbl(f_presupuestado.ObtenerValor("noviembre"))
										v_diciembre	=	v_diciembre		+	Cdbl(f_presupuestado.ObtenerValor("diciembre"))
										v_enero_prox	=v_enero_prox	+	Cdbl(f_presupuestado.ObtenerValor("enero_prox"))
										v_febrero_prox	=v_febrero_prox	+	Cdbl(f_presupuestado.ObtenerValor("febrero_prox"))
									
									%>
									<tr bordercolor='#999999'>	
										<td><%=f_presupuestado.ObtenerValor("concepto")%></td>
										<td><%=f_presupuestado.ObtenerValor("detalle")%></td>
										<td><%=f_presupuestado.ObtenerValor("cod_pre")%></td>
										<td><%=formatcurrency(f_presupuestado.ObtenerValor("enero"),0)%></td>
										<td><%=formatcurrency(f_presupuestado.ObtenerValor("febrero"),0)%></td>
										<td><%=formatcurrency(f_presupuestado.ObtenerValor("marzo"),0)%></td>
										<td><%=formatcurrency(f_presupuestado.ObtenerValor("abril"),0)%></td>
										<td><%=formatcurrency(f_presupuestado.ObtenerValor("mayo"),0)%></td>
										<td><%=formatcurrency(f_presupuestado.ObtenerValor("junio"),0)%></td>
										<td><%=formatcurrency(f_presupuestado.ObtenerValor("julio"),0)%></td>
										<td><%=formatcurrency(f_presupuestado.ObtenerValor("agosto"),0)%></td>
										<td><%=formatcurrency(f_presupuestado.ObtenerValor("septiembre"),0)%></td>
										<td><%=formatcurrency(f_presupuestado.ObtenerValor("octubre"),0)%></td>
										<td><%=formatcurrency(f_presupuestado.ObtenerValor("noviembre"),0)%></td>
										<td><%=formatcurrency(f_presupuestado.ObtenerValor("diciembre"),0)%></td>
										<td><%=formatcurrency(f_presupuestado.ObtenerValor("enero_prox"),0)%></td>
										<td><%=formatcurrency(f_presupuestado.ObtenerValor("febrero_prox"),0)%></td>
										<td><strong><%=formatcurrency(f_presupuestado.ObtenerValor("total"),0)%></strong></td>
									</tr>
									 <%wend%>
									<tr bordercolor='#999999'>
								 	<td colspan="3"><b>Totales</b></td>
									<td align="right"><b><%=formatcurrency(v_enero,0)%></b></td>
									<td align="right"><b><%=formatcurrency(v_febrero,0)%></b></td>
									<td align="right"><b><%=formatcurrency(v_marzo,0)%></b></td>
									<td align="right"><b><%=formatcurrency(v_abril,0)%></b></td>
									<td align="right"><b><%=formatcurrency(v_mayo,0)%></b></td>
									<td align="right"><b><%=formatcurrency(v_junio,0)%></b></td>
									<td align="right"><b><%=formatcurrency(v_julio,0)%></b></td>
									<td align="right"><b><%=formatcurrency(v_agosto,0)%></b></td>
									<td align="right"><b><%=formatcurrency(v_septiembre,0)%></b></td>
									<td align="right"><b><%=formatcurrency(v_octubre,0)%></b></td>
									<td align="right"><b><%=formatcurrency(v_noviembre,0)%></b></td>
									<td align="right"><b><%=formatcurrency(v_diciembre,0)%></b></td>
									<td align="right"><b><%=formatcurrency(v_enero_prox,0)%></b></td>
									<td align="right"><b><%=formatcurrency(v_febrero_prox,0)%></b></td>
									<td align="right"><b><%=formatcurrency(v_total,0)%></b></td>
								 </tr>									 
								  </table>
								  <%case 3:%>
							<tr><td colspan="2">	  
								  <br/>
									<%
									select case (area_ccod)
										case 88:%>
											<font>Pendientes</font>
											<br/>
											<table width="95%" border="1" align="center"  >
											<tr  bgcolor='#C4D7FF' bordercolor='#999999'>
												<th width="22%">Solicitante</th> 
												<th width="22%">Concepto</th>
												<th width="51%">Descripcion</th>
												<th width="9%">Cantidad</th>
												<th width="9%">Para mes</th>
												<th width="18%">Estado</th>
												<th width="18%">Accion</th>									  
											</tr>
											<%while f_solicitado.Siguiente%>
											<tr bordercolor='#999999'>
												<td><%=f_solicitado.DibujaCampo("area_tdesc")%></td>	
											  	<td><font color="#0033FF"><%f_solicitado.DibujaCampo("ccen_tdesc")%></a></font></td>
											  	<td><%=f_solicitado.DibujaCampo("ccau_tdesc")%></td>
											  	<td><%=f_solicitado.DibujaCampo("ccau_ncantidad")%></td>
												<td><%=f_solicitado.DibujaCampo("nombremes")%></td>
											  	<td><%=f_solicitado.DibujaCampo("esol_tdesc")%></td>
											  	<td><a href="javascript:CambiaEstado(1,<%f_solicitado.DibujaCampo("esol_ccod")%>,<%f_solicitado.DibujaCampo("ccau_ncorr")%>);"><%f_solicitado.DibujaCampo("accion")%>
											  	</a> |<a href="javascript:Rechazar(1,<%f_solicitado.DibujaCampo("ccau_ncorr")%>);">Rechazar</a></td>
											</tr>
											 <%wend
											 if f_solicitado.nrofilas <=0 then%>
												<tr bordercolor='#999999'>	<td colspan="7" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
											 <% end if%>
											</table>
											
											<br/> 
											<font>Aceptadas y Rechazadas</font>
											<br/>
											<table width="95%" border="1" align="center"  >
												<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
 												  <th width="22%">Solicitante</th> 
												  <th width="22%">Concepto</th>
												  <th width="51%">Descripcion</th>
												  <th width="9%">Para mes</th>
												  <th width="9%">Cantidad</th>
												  <th width="18%">Estado</th>
												</tr>
												<%
												while f_aprobados.Siguiente
												%>
												<tr bordercolor='#999999'>	
												  <td><%=f_aprobados.DibujaCampo("area_tdesc")%></td>
												  <td><font color="#0033FF"><%f_aprobados.DibujaCampo("ccen_tdesc")%></a></font></td>
												  <td><%=f_aprobados.DibujaCampo("ccau_tdesc")%></td>
												  <td><%=f_aprobados.DibujaCampo("nombremes")%></td>
												  <td><%=f_aprobados.DibujaCampo("ccau_ncantidad")%></td>
												  <td><%=f_aprobados.DibujaCampo("esol_tdesc")%></td>
												</tr>
												 <%wend%>
												 <%if f_aprobados.nrofilas <=0 then%>
													<tr bordercolor='#999999'>	<td colspan="6" align="center">No se encontraron solicitudes aprobadas </td></tr>
												 <% end if%>
											</table>	 

										<%case 8:%>
											<font>Pendientes</font>
											<br/>										
										<table width="95%" border="1" align="center"  >
											<tr  bgcolor='#C4D7FF' bordercolor='#999999'>
												<th width="22%">Solicitante</th> 
												<th width="22%">Concepto</th>
												<th width="51%">Descripcion</th>
												<th width="9%">Cantidad</th>
												<th width="9%">Para mes</th>
												<th width="18%">Estado</th>
												<th width="18%">Accion</th>									  
											</tr>
											<%while f_solicitado.Siguiente%>
											<tr bordercolor='#999999'>
												<td><%=f_solicitado.DibujaCampo("area_tdesc")%></td>	
											  	<td><font color="#0033FF"><%f_solicitado.DibujaCampo("ccen_tdesc")%></a></font></td>
											  	<td><%=f_solicitado.DibujaCampo("ccbi_tdesc")%></td>
											  	<td><%=f_solicitado.DibujaCampo("ccbi_ncantidad")%></td>
												<td><%=f_solicitado.DibujaCampo("nombremes")%></td>
											  	<td><%=f_solicitado.DibujaCampo("esol_tdesc")%></td>
											  	<td><a href="javascript:CambiaEstado(2,<%f_solicitado.DibujaCampo("esol_ccod")%>,<%f_solicitado.DibujaCampo("ccbi_ncorr")%>);"><%f_solicitado.DibujaCampo("accion")%></a>|
												<a href="javascript:Rechazar(2,<%f_solicitado.DibujaCampo("ccbi_ncorr")%>);">Rechazar</a></td>
											</tr>
											 <%wend
											 if f_solicitado.nrofilas <=0 then%>
												<tr bordercolor='#999999'>	<td colspan="7" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
											 <% end if%>
								    </table>
									
										<br/> 
											<font>Aceptadas y Rechazadas</font>
											<br/>
											<table width="95%" border="1" align="center"  >
												<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
 												  <th width="22%">Solicitante</th>
												  <th width="22%">Concepto</th>
												  <th width="51%">Descripcion</th>
												  <th width="9%">Para mes</th>
												  <th width="9%">Cantidad</th>
												  <th width="18%">Estado</th>
												</tr>
												<%
												while f_aprobados.Siguiente
												%>
												<tr bordercolor='#999999'>	
												  <td><%=f_aprobados.DibujaCampo("area_tdesc")%></td>
												  <td><font color="#0033FF"><%f_aprobados.DibujaCampo("ccen_tdesc")%></a></font></td>
												  <td><%=f_aprobados.DibujaCampo("ccbi_tdesc")%></td>
												  <td><%=f_aprobados.DibujaCampo("nombremes")%></td>
												  <td><%=f_aprobados.DibujaCampo("ccbi_ncantidad")%></td>
												  <td><%=f_aprobados.DibujaCampo("esol_tdesc")%></td>
												</tr>
												 <%wend%>
												 <%if f_aprobados.nrofilas <=0 then%>
													<tr bordercolor='#999999'>	<td colspan="6" align="center">No se encontraron solicitudes aprobadas </td></tr>
												 <% end if%>
											</table>	 
										<%case 15:%>
											<font>Pendientes</font>
											<br/>										
											<table width="95%" border="1" align="center"  >
											<tr  bgcolor='#C4D7FF' bordercolor='#999999'>
												<th width="22%">Solicitante</th> 
												<th width="22%">Concepto</th>
												<th width="51%">Descripcion</th>
												<th width="9%">Cantidad</th>
												<th width="9%">Para mes</th>
												<th width="18%">Estado</th>
												<th width="18%">Accion</th>									  
											</tr>
											<%while f_solicitado.Siguiente%>
											<tr bordercolor='#999999'>
												<td><%=f_solicitado.DibujaCampo("area_tdesc")%></td>	
											  	<td><font color="#0033FF"><%f_solicitado.DibujaCampo("ccen_tdesc")%></a></font></td>
											  	<td><%=f_solicitado.DibujaCampo("ccco_tdesc")%></td>
											  	<td><%=f_solicitado.DibujaCampo("ccco_ncantidad")%></td>
												<td><%=f_solicitado.DibujaCampo("nombremes")%></td>
											  	<td><%=f_solicitado.DibujaCampo("esol_tdesc")%></td>
											  	<td><a href="javascript:CambiaEstado(3,<%f_solicitado.DibujaCampo("esol_ccod")%>,<%f_solicitado.DibujaCampo("ccco_ncorr")%>);"><%f_solicitado.DibujaCampo("accion")%>
											  	</a> |<a href="javascript:Rechazar(3,<%f_solicitado.DibujaCampo("ccco_ncorr")%>);">Rechazar</a></td>
											</tr>
											 <%wend
											 if f_solicitado.nrofilas <=0 then%>
												<tr bordercolor='#999999'>	<td colspan="7" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
											 <% end if%>
								    </table>
									<br/> 
											<font>Aceptadas y Rechazadas</font>
											<br/>
											<table width="95%" border="1" align="center"  >
												<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
 												  <th width="22%">Solicitante</th>
												  <th width="22%">Concepto</th>
												  <th width="51%">Descripcion</th>
												  <th width="9%">Para mes</th>
												  <th width="9%">Cantidad</th>
												  <th width="18%">Estado</th>
												</tr>
												<%
												while f_aprobados.Siguiente
												%>
												<tr bordercolor='#999999'>	
												  <td><%=f_aprobados.DibujaCampo("area_tdesc")%></td>
												  <td><font color="#0033FF"><%f_aprobados.DibujaCampo("ccen_tdesc")%></a></font></td>
												  <td><%=f_aprobados.DibujaCampo("ccco_tdesc")%></td>
												  <td><%=f_aprobados.DibujaCampo("nombremes")%></td>
												  <td><%=f_aprobados.DibujaCampo("ccco_ncantidad")%></td>
												  <td><%=f_aprobados.DibujaCampo("esol_tdesc")%></td>
												</tr>
												 <%wend%>
												 <%if f_aprobados.nrofilas <=0 then%>
													<tr bordercolor='#999999'>	<td colspan="6" align="center">No se encontraron solicitudes aprobadas </td></tr>
												 <% end if%>
											</table>	 
									
										<%case 77,78,79,80:%>
											<font>Pendientes</font>
											<br/>										
												<table width="95%" border="1" align="center"  >
													<tr  bgcolor='#C4D7FF' bordercolor='#999999'>
														<th width="22%">Solicitante</th> 
														<th width="22%">Concepto</th>
														<th width="51%">Descripcion</th>
														<th width="9%">Cantidad</th>
														<th width="9%">Para mes</th>
														<th width="18%">Estado</th>
														<th width="18%">Accion</th>									  
													</tr>
													<%while f_solicitado.Siguiente%>
													<tr bordercolor='#999999'>
														<td><%=f_solicitado.DibujaCampo("area_tdesc")%></td>	
														<td><font color="#0033FF"><%f_solicitado.DibujaCampo("ccen_tdesc")%></a></font></td>
														<td><%=f_solicitado.DibujaCampo("ccsg_tdesc")%></td>
														<td><%=f_solicitado.DibujaCampo("ccsg_ncantidad")%></td>
														<td><%=f_solicitado.DibujaCampo("nombremes")%></td>
														<td><%=f_solicitado.DibujaCampo("esol_tdesc")%></td>
														<td><a href="javascript:CambiaEstado(4,<%f_solicitado.DibujaCampo("esol_ccod")%>,<%f_solicitado.DibujaCampo("ccsg_ncorr")%>);"><%f_solicitado.DibujaCampo("accion")%>
														</a> |<a href="javascript:Rechazar(4,<%f_solicitado.DibujaCampo("ccsg_ncorr")%>);">Rechazar</a></td>
													</tr>
													 <%wend
													 if f_solicitado.nrofilas <=0 then%>
														<tr bordercolor='#999999'>	<td colspan="7" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
													 <% end if%>
												</table>
										<br/> 
											<font>Aceptadas y Rechazadas</font>
											<br/>
											<table width="95%" border="1" align="center"  >
												<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
 												  <th width="22%">Solicitante</th>
												  <th width="22%">Concepto</th>
												  <th width="51%">Descripcion</th>
												  <th width="9%">Para mes</th>
												  <th width="9%">Cantidad</th>
												  <th width="18%">Estado</th>
												</tr>
												<%
												while f_aprobados.Siguiente
												%>
												<tr bordercolor='#999999'>	
												  <td><%=f_aprobados.DibujaCampo("area_tdesc")%></td>
												  <td><font color="#0033FF"><%f_aprobados.DibujaCampo("ccen_tdesc")%></a></font></td>
												  <td><%=f_aprobados.DibujaCampo("ccsg_tdesc")%></td>
												  <td><%=f_aprobados.DibujaCampo("nombremes")%></td>
												  <td><%=f_aprobados.DibujaCampo("ccsg_ncantidad")%></td>
												  <td><%=f_aprobados.DibujaCampo("esol_tdesc")%></td>
												</tr>
												 <%wend%>
												 <%if f_aprobados.nrofilas <=0 then%>
													<tr bordercolor='#999999'>	<td colspan="6" align="center">No se encontraron solicitudes aprobadas </td></tr>
												 <% end if%>
											</table>	 
											
										<%case 75:%>
											<font>Pendientes</font>
											<br/>										
											<table width="95%" border="1" align="center"  >
												<tr  bgcolor='#C4D7FF' bordercolor='#999999'>
													<th width="22%">Solicitante</th> 
													<th width="22%">Concepto</th>
													<th width="51%">Descripcion</th>
													<th width="9%">Cantidad</th>
													<th width="9%">Para mes</th>
													<th width="18%">Estado</th>
													<th width="18%">Accion</th>									  
												</tr>
												<%while f_solicitado.Siguiente%>
												<tr bordercolor='#999999'>
													<td><%=f_solicitado.DibujaCampo("area_tdesc")%></td>	
													 <td><font color="#0033FF"><%f_solicitado.DibujaCampo("ccen_tdesc")%></a></font></td>
													<td><%=f_solicitado.DibujaCampo("ccpe_tdesc")%></td>
													<td><%=f_solicitado.DibujaCampo("ccpe_ncantidad")%></td>
													<td><%=f_solicitado.DibujaCampo("nombremes")%></td>
													<td><%=f_solicitado.DibujaCampo("esol_tdesc")%></td>
													<td><a href="javascript:CambiaEstado(5,<%f_solicitado.DibujaCampo("esol_ccod")%>,<%f_solicitado.DibujaCampo("ccpe_ncorr")%>);"><%f_solicitado.DibujaCampo("accion")%>
													</a> |<a href="javascript:Rechazar(5,<%f_solicitado.DibujaCampo("ccpe_ncorr")%>);">Rechazar</a></td>
												</tr>
												 <%wend
												 if f_solicitado.nrofilas <=0 then%>
													<tr bordercolor='#999999'>	<td colspan="7" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
												 <% end if %>
											</table>
										
										<font>Aceptadas y Rechazadas</font>
											<br/>
											<table width="95%" border="1" align="center"  >
												<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
 												  <th width="22%">Solicitante</th>
												  <th width="22%">Concepto</th>
												  <th width="51%">Descripcion</th>
												  <th width="9%">Para mes</th>
												  <th width="9%">Cantidad</th>
												  <th width="18%">Estado</th>
												</tr>
												<%
												while f_aprobados.Siguiente
												%>
												<tr bordercolor='#999999'>	
												  <td><%=f_aprobados.DibujaCampo("area_tdesc")%></td>
												  <td><font color="#0033FF"><%f_aprobados.DibujaCampo("ccen_tdesc")%></a></font></td>
												  <td><%=f_aprobados.DibujaCampo("ccpe_tdesc")%></td>
												  <td><%=f_aprobados.DibujaCampo("nombremes")%></td>
												  <td><%=f_aprobados.DibujaCampo("ccpe_ncantidad")%></td>
												  <td><%=f_aprobados.DibujaCampo("esol_tdesc")%></td>
												</tr>
												 <%wend%>
												 <%if f_aprobados.nrofilas <=0 then%>
													<tr bordercolor='#999999'>	<td colspan="6" align="center">No se encontraron solicitudes aprobadas </td></tr>
												 <% end if%>
											</table>	
												 
										<%case else:%>	 
										
											<center><font size="2" color="#FF0000">Su area presupuestal, no centraliza solicitudes de presupuesto</font></center>
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
													if sin_bloqueo then
													if v_detalle<>""  and codcaja <> "" then
														botonera.DibujaBoton ("grabar")
													end if
													end if
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
</html>