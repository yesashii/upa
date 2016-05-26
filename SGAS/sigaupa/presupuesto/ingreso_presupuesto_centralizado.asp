<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "presupuesto/funciones/funciones.asp" -->

<%
Server.ScriptTimeout = 2000
set pagina = new CPagina
pagina.Titulo = "Solicitud Centralizada 2015"
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
'response.Write("Usuario: "&v_usuario)



'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "solicitud_presupuestaria_centralizada.xml", "botonera"
'-----------------------------------------------------------------------

'------------------------------------------------------------------funciones---->>>
'dibuja el valor estimado
function htmlValorEstimado()
%>
 <td><strong>Valor Aprox.:</strong></td><td>:</td><td><input value="0" type="text" name="vAprox" size="12" maxlength="10" onkeyup="format(this)" onchange="format(this)" onClick="this.select();"> Total</td>
<%
 end function
'dibuja el tipo de presupuesto
function htmlTipoPresupuesto()
%>
<td><strong>Tipo gasto</strong></td><td>:</td><td>
<SELECT NAME="tpresupuesto" >
<option value="1">Primario</option>
<option value="2">Secundario</option>
</select>

<%
end function
'------------------------------------------------------------------funciones----<<<


 codcaja	= request.querystring("busqueda[0][codcaja]")
 area_ccod	= request.querystring("busqueda[0][area_ccod]")
 mes_venc	= request.querystring("busqueda[0][mes_venc]")
 nro_t		= request.querystring("nro_t")

 if codcaja="" then
	 codcaja= request.querystring("codcaja")
 end if

 if area_ccod="" then
	 area_ccod= request.querystring("area_ccod")
 end if

 v_anio_actual	= conexion2.ConsultaUno("select year(getdate())")

 v_mes_actual	= conexion2.ConsultaUno("select month(getdate())")

'if v_mes_actual <=10 then
'	v_prox_anio	=	v_anio_actual
'else
'	v_prox_anio	=	v_anio_actual+1
'end if

v_prox_anio	=	v_anio_actual+1
' v_prox_anio	=	v_anio_actual ' se agrego por que el 2010 el presupuesto paso de año

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "solicitud_presupuestaria_centralizada.xml", "busqueda_presupuesto"
 f_busqueda.Inicializar conexion2
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente

 f_busqueda.AgregaCampoParam "area_ccod", "filtro",  "area_ccod in ( select area_ccod from  presupuesto_upa.protic.area_presupuesto_usuario  where rut_usuario in ('"&v_usuario&"') )"
 f_busqueda.AgregaCampoCons "area_ccod", area_ccod

'----------------------------------------------------------------------------
set f_solicitado = new CFormulario
f_solicitado.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
f_solicitado.Inicializar conexion2


set f_aprobados = new CFormulario
f_aprobados.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
f_aprobados.Inicializar conexion2



set f_concepto = new CFormulario
f_concepto.Carga_Parametros "solicitud_presupuestaria_centralizada.xml", "concepto"
f_concepto.Inicializar conexion2
f_concepto.Consultar "select ''"
f_concepto.Siguiente



   if Request.QueryString <> "" then

	  if nro_t="" then
	  	nro_t=1
	  end if



	select case (nro_t)
		case 1:'AUDIOVISUAL
			sql_solicitud=""& vbCrLf &_
				"select *,                                                          "& vbCrLf &_
				"       nombremes,                                                  "& vbCrLf &_
				"       case a.esol_ccod                                            "& vbCrLf &_
				"              when 1 then 'Anular'                                 "& vbCrLf &_
				"              when 3 then 'Dejar Pendiente'                        "& vbCrLf &_
				"              when 4 then 'Ver motivo'                             "& vbCrLf &_
				"              else 'Estado Final'                                  "& vbCrLf &_
				"       end as accion                                               "& vbCrLf &_
				"from   presupuesto_upa.protic.centralizar_solicitud_audiovisual a, "& vbCrLf &_
				"       presupuesto_upa.protic.concepto_centralizado b,             "& vbCrLf &_
				"       presupuesto_upa.protic.estado_solicitud c,                  "& vbCrLf &_
				"       softland.sw_mesce d                                         "& vbCrLf &_
				"where  a.tpre_ccod in (1)                                          "& vbCrLf &_
				"and    a.tpre_ccod=b.tpre_ccod                                     "& vbCrLf &_
				"and    a.ccen_ccod=b.ccen_ccod                                     "& vbCrLf &_
				"and    a.esol_ccod=c.esol_ccod                                     "& vbCrLf &_
				"and    isnull(mes_ccod,1)=d.indice                                 "& vbCrLf &_
				"and    a.esol_ccod not in (2,3)                                    "& vbCrLf &_
				"and    area_ccod="&area_ccod&"                                     "& vbCrLf &_
				"and    anio_ccod="&v_prox_anio&"                                   "

			sql_aprobadas=""& vbCrLf &_
				"select *                                                           "& vbCrLf &_
				"from   presupuesto_upa.protic.centralizar_solicitud_audiovisual a, "& vbCrLf &_
				"       presupuesto_upa.protic.concepto_centralizado b,             "& vbCrLf &_
				"       presupuesto_upa.protic.estado_solicitud c,                  "& vbCrLf &_
				"       softland.sw_mesce d                                         "& vbCrLf &_
				"where  a.tpre_ccod in (1)                                          "& vbCrLf &_
				"and    a.tpre_ccod=b.tpre_ccod                                     "& vbCrLf &_
				"and    a.ccen_ccod=b.ccen_ccod                                     "& vbCrLf &_
				"and    a.esol_ccod=c.esol_ccod                                     "& vbCrLf &_
				"and    isnull(mes_ccod,1)=d.indice                                 "& vbCrLf &_
				"and    a.esol_ccod in (2)                                          "& vbCrLf &_
				"and    area_ccod="&area_ccod&"                                     "& vbCrLf &_
				"and    anio_ccod="&v_prox_anio&"                                   "

			f_concepto.AgregaCampoParam "ccen_ccod", "filtro", "tpre_ccod in (1)"

		case 2:'BIBLIOTECA
			sql_solicitud=""& vbCrLf &_
				"select *,                                                         "& vbCrLf &_
				"       nombremes,                                                 "& vbCrLf &_
				"       case a.esol_ccod                                           "& vbCrLf &_
				"              when 1 then 'Anular'                                "& vbCrLf &_
				"              when 3 then 'Dejar Pendiente'                       "& vbCrLf &_
				"              when 4 then 'Ver motivo'                            "& vbCrLf &_
				"              else 'Estado Final'                                 "& vbCrLf &_
				"       end as accion                                              "& vbCrLf &_
				"from   presupuesto_upa.protic.centralizar_solicitud_biblioteca a, "& vbCrLf &_
				"       presupuesto_upa.protic.concepto_centralizado b,            "& vbCrLf &_
				"       presupuesto_upa.protic.estado_solicitud c,                 "& vbCrLf &_
				"       softland.sw_mesce d                                        "& vbCrLf &_
				"where  a.tpre_ccod in (2)                                         "& vbCrLf &_
				"and    a.tpre_ccod=b.tpre_ccod                                    "& vbCrLf &_
				"and    a.ccen_ccod=b.ccen_ccod                                    "& vbCrLf &_
				"and    a.esol_ccod=c.esol_ccod                                    "& vbCrLf &_
				"and    isnull(mes_ccod,1)=d.indice                                "& vbCrLf &_
				"and    a.esol_ccod not in (2,3)                                   "& vbCrLf &_
				"and    area_ccod="&area_ccod&"                                    "& vbCrLf &_
				"and    anio_ccod="&v_prox_anio&"                                  "

			sql_aprobadas=""& vbCrLf &_
				"select * 														   "& vbCrLf &_
				"from   presupuesto_upa.protic.centralizar_solicitud_biblioteca a, "& vbCrLf &_
				"       presupuesto_upa.protic.concepto_centralizado b,            "& vbCrLf &_
				"       presupuesto_upa.protic.estado_solicitud c,                 "& vbCrLf &_
				"       softland.sw_mesce d                                        "& vbCrLf &_
				"where  a.tpre_ccod in (2)                                         "& vbCrLf &_
				"and    a.tpre_ccod=b.tpre_ccod                                    "& vbCrLf &_
				"and    a.ccen_ccod=b.ccen_ccod                                    "& vbCrLf &_
				"and    a.esol_ccod=c.esol_ccod                                    "& vbCrLf &_
				"and    isnull(mes_ccod,1)=d.indice                                "& vbCrLf &_
				"and    a.esol_ccod in (2)                                         "& vbCrLf &_
				"and    area_ccod="&area_ccod&"                                    "& vbCrLf &_
				"and    anio_ccod="&v_prox_anio&"                                  "

			f_concepto.AgregaCampoParam "ccen_ccod", "filtro", "tpre_ccod in (2)"

		case 3:
			sql_solicitud="select *,nombremes, case a.esol_ccod when 1 then 'Anular' when 3 then 'Dejar Pendiente' when 4 then 'Ver motivo' else 'Estado Final' end as accion "& vbCrLf &_
						" from presupuesto_upa.protic.centralizar_solicitud_computacion a, presupuesto_upa.protic.concepto_centralizado b,presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d "& vbCrLf &_
						"	where a.tpre_ccod in (3) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
						"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
						"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
						"	and isnull(mes_ccod,1)=d.indice "& vbCrLf &_
						" 	and a.esol_ccod not in (2,3) "& vbCrLf &_
						"	and area_ccod="&area_ccod&" and anio_ccod="&v_prox_anio

			sql_aprobadas="select * "& vbCrLf &_
						" from presupuesto_upa.protic.centralizar_solicitud_computacion a, presupuesto_upa.protic.concepto_centralizado b,presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d "& vbCrLf &_
						"	where a.tpre_ccod in (3) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
						"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
						"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
						"	and isnull(mes_ccod,1)=d.indice "& vbCrLf &_
						" 	and a.esol_ccod in (2) "& vbCrLf &_
						"	and area_ccod="&area_ccod&" and anio_ccod="&v_prox_anio


			f_concepto.AgregaCampoParam "ccen_ccod", "filtro", "tpre_ccod in (3)"

		case 4:
			sql_solicitud="select *,sede_tdesc as sede, nombremes, case a.esol_ccod when 1 then 'Anular' when 3 then 'Dejar Pendiente' when 4 then 'Ver motivo' else 'Estado Final' end as accion "& vbCrLf &_
						" from presupuesto_upa.protic.centralizar_solicitud_servicios_generales a, presupuesto_upa.protic.concepto_centralizado b,presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d, presupuesto_upa.protic.sedes e "& vbCrLf &_
						"	where a.tpre_ccod in (4) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
						"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
						"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
						"	and isnull(mes_ccod,1)=d.indice "& vbCrLf &_
						"   and isnull(a.sede_ccod,1)=e.sede_ccod "& vbCrLf &_
						" 	and a.esol_ccod not in (2,3) "& vbCrLf &_
						"	and area_ccod="&area_ccod&" and anio_ccod="&v_prox_anio

			sql_aprobadas="select *,sede_tdesc as sede "& vbCrLf &_
						" from presupuesto_upa.protic.centralizar_solicitud_servicios_generales a, presupuesto_upa.protic.concepto_centralizado b,presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d, presupuesto_upa.protic.sedes e "& vbCrLf &_
						"	where a.tpre_ccod in (4) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
						"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
						"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
						"	and isnull(mes_ccod,1)=d.indice "& vbCrLf &_
						"   and isnull(a.sede_ccod,1)=e.sede_ccod "& vbCrLf &_
						" 	and a.esol_ccod in (2) "& vbCrLf &_
						"	and area_ccod="&area_ccod&" and anio_ccod="&v_prox_anio

			f_concepto.AgregaCampoParam "ccen_ccod", "filtro", "tpre_ccod in (4)"

		case 5:
			sql_solicitud="select *,nombremes, case a.esol_ccod when 1 then 'Anular' when 3 then 'Dejar Pendiente' when 4 then 'Ver motivo' else 'Estado Final' end as accion "& vbCrLf &_
						" from presupuesto_upa.protic.centralizar_solicitud_personal a, presupuesto_upa.protic.concepto_centralizado b,presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d  "& vbCrLf &_
						"	where a.tpre_ccod in (5) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
						"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
						"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
						"	and isnull(mes_ccod,1)=d.indice "& vbCrLf &_
						" 	and a.esol_ccod not in (2,3) "& vbCrLf &_
						"	and area_ccod="&area_ccod&" and anio_ccod="&v_prox_anio

			sql_aprobadas="select * "& vbCrLf &_
						" from presupuesto_upa.protic.centralizar_solicitud_personal a, presupuesto_upa.protic.concepto_centralizado b,presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d "& vbCrLf &_
						"	where a.tpre_ccod in (5) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
						"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
						"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
						"	and isnull(mes_ccod,1)=d.indice "& vbCrLf &_
						" 	and a.esol_ccod in (2) "& vbCrLf &_
						" 	and a.esol_ccod not in (2) "& vbCrLf &_
						"	and area_ccod="&area_ccod&" and anio_ccod="&v_prox_anio


			f_concepto.AgregaCampoParam "ccen_ccod", "filtro", "tpre_ccod in (5)"

			case 6:
			sql_solicitud="select *,nombremes, case a.esol_ccod when 1 then 'Anular' when 3 then 'Dejar Pendiente' when 4 then 'Ver motivo' else 'Estado Final' end as accion "& vbCrLf &_
							" from presupuesto_upa.protic.centralizar_solicitud_dir_docencia a, presupuesto_upa.protic.concepto_centralizado b,presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d "& vbCrLf &_
							"	where a.tpre_ccod in (6) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
							"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
							"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
							"	and isnull(mes_ccod,1)=d.indice "& vbCrLf &_
							" 	and a.esol_ccod not in (2,3) "& vbCrLf &_
							"	and area_ccod="&area_ccod&" and anio_ccod="&v_prox_anio

			sql_aprobadas="select * "& vbCrLf &_
							" from presupuesto_upa.protic.centralizar_solicitud_dir_docencia a, presupuesto_upa.protic.concepto_centralizado b,presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d "& vbCrLf &_
							"	where a.tpre_ccod in (6) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
							"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
							"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
							"	and isnull(mes_ccod,1)=d.indice "& vbCrLf &_
							" 	and a.esol_ccod in (2) "& vbCrLf &_
							"	and area_ccod="&area_ccod&" and anio_ccod="&v_prox_anio

			f_concepto.AgregaCampoParam "ccen_ccod", "filtro", "tpre_ccod in (6)"

			case 7:
			sql_solicitud=""& vbCrLf &_
				"select *,                                                          			"& vbCrLf &_
				"       nombremes,                                                  			"& vbCrLf &_
				"       case a.esol_ccod                                            			"& vbCrLf &_
				"              when 1 then 'Anular'                                 			"& vbCrLf &_
				"              when 3 then 'Dejar Pendiente'                        			"& vbCrLf &_
				"              when 4 then 'Ver motivo'                             			"& vbCrLf &_
				"              else 'Estado Final'                                  			"& vbCrLf &_
				"       end as accion                                               			"& vbCrLf &_
				"from   presupuesto_upa.protic.centralizar_solicitud_vicerectoriaAcademica a, 	"& vbCrLf &_
				"       presupuesto_upa.protic.concepto_centralizado b,             			"& vbCrLf &_
				"       presupuesto_upa.protic.estado_solicitud c,                  			"& vbCrLf &_
				"       softland.sw_mesce d                                         			"& vbCrLf &_
				"where  a.tpre_ccod in (7)                                          			"& vbCrLf &_
				"and    a.tpre_ccod=b.tpre_ccod                                     			"& vbCrLf &_
				"and    a.ccen_ccod=b.ccen_ccod                                     			"& vbCrLf &_
				"and    a.esol_ccod=c.esol_ccod                                     			"& vbCrLf &_
				"and    isnull(mes_ccod,1)=d.indice                                 			"& vbCrLf &_
				"and    a.esol_ccod not in (2,3)                                    			"& vbCrLf &_
				"and    area_ccod="&area_ccod&"                                     			"& vbCrLf &_
				"and    anio_ccod="&v_prox_anio&"                                   			"

			sql_aprobadas=""& vbCrLf &_
				"select *                                                           			"& vbCrLf &_
				"from   presupuesto_upa.protic.centralizar_solicitud_vicerectoriaAcademica a, 	"& vbCrLf &_
				"       presupuesto_upa.protic.concepto_centralizado b,             			"& vbCrLf &_
				"       presupuesto_upa.protic.estado_solicitud c,                  			"& vbCrLf &_
				"       softland.sw_mesce d                                         			"& vbCrLf &_
				"where  a.tpre_ccod in (7)                                          			"& vbCrLf &_
				"and    a.tpre_ccod=b.tpre_ccod                                     			"& vbCrLf &_
				"and    a.ccen_ccod=b.ccen_ccod                                     			"& vbCrLf &_
				"and    a.esol_ccod=c.esol_ccod                                     			"& vbCrLf &_
				"and    isnull(mes_ccod,1)=d.indice                                 			"& vbCrLf &_
				"and    a.esol_ccod in (2)                                          			"& vbCrLf &_
				"and    area_ccod="&area_ccod&"                                     			"& vbCrLf &_
				"and    anio_ccod="&v_prox_anio&"                                   			"

			f_concepto.AgregaCampoParam "ccen_ccod", "filtro", "tpre_ccod in (7)"

			case 8:
			sql_solicitud=""& vbCrLf &_
				"select *,                                                          			"& vbCrLf &_
				"       nombremes,                                                  			"& vbCrLf &_
				"       case a.esol_ccod                                            			"& vbCrLf &_
				"              when 1 then 'Anular'                                 			"& vbCrLf &_
				"              when 3 then 'Dejar Pendiente'                        			"& vbCrLf &_
				"              when 4 then 'Ver motivo'                             			"& vbCrLf &_
				"              else 'Estado Final'                                  			"& vbCrLf &_
				"       end as accion                                               			"& vbCrLf &_
				"from   presupuesto_upa.protic.centralizar_solicitud_dae a, 	"& vbCrLf &_
				"       presupuesto_upa.protic.concepto_centralizado b,             			"& vbCrLf &_
				"       presupuesto_upa.protic.estado_solicitud c,                  			"& vbCrLf &_
				"       softland.sw_mesce d                                         			"& vbCrLf &_
				"where  a.tpre_ccod in (8)                                          			"& vbCrLf &_
				"and    a.tpre_ccod=b.tpre_ccod                                     			"& vbCrLf &_
				"and    a.ccen_ccod=b.ccen_ccod                                     			"& vbCrLf &_
				"and    a.esol_ccod=c.esol_ccod                                     			"& vbCrLf &_
				"and    isnull(mes_ccod,1)=d.indice                                 			"& vbCrLf &_
				"and    a.esol_ccod not in (2,3)                                    			"& vbCrLf &_
				"and    area_ccod="&area_ccod&"                                     			"& vbCrLf &_
				"and    anio_ccod="&v_prox_anio&"                                   			"

			sql_aprobadas=""& vbCrLf &_
				"select *                                                           			"& vbCrLf &_
				"from   presupuesto_upa.protic.centralizar_solicitud_dae a, 	"& vbCrLf &_
				"       presupuesto_upa.protic.concepto_centralizado b,             			"& vbCrLf &_
				"       presupuesto_upa.protic.estado_solicitud c,                  			"& vbCrLf &_
				"       softland.sw_mesce d                                         			"& vbCrLf &_
				"where  a.tpre_ccod in (8)                                          			"& vbCrLf &_
				"and    a.tpre_ccod=b.tpre_ccod                                     			"& vbCrLf &_
				"and    a.ccen_ccod=b.ccen_ccod                                     			"& vbCrLf &_
				"and    a.esol_ccod=c.esol_ccod                                     			"& vbCrLf &_
				"and    isnull(mes_ccod,1)=d.indice                                 			"& vbCrLf &_
				"and    a.esol_ccod in (2)                                          			"& vbCrLf &_
				"and    area_ccod="&area_ccod&"                                     			"& vbCrLf &_
				"and    anio_ccod="&v_prox_anio&"                                   			"

			f_concepto.AgregaCampoParam "ccen_ccod", "filtro", "tpre_ccod in (8)"

			case 9:
			sql_solicitud=""& vbCrLf &_
				"select *,                                                          			"& vbCrLf &_
				"       nombremes,                                                  			"& vbCrLf &_
				"       case a.esol_ccod                                            			"& vbCrLf &_
				"              when 1 then 'Anular'                                 			"& vbCrLf &_
				"              when 3 then 'Dejar Pendiente'                        			"& vbCrLf &_
				"              when 4 then 'Ver motivo'                             			"& vbCrLf &_
				"              else 'Estado Final'                                  			"& vbCrLf &_
				"       end as accion                                               			"& vbCrLf &_
				"from   presupuesto_upa.protic.centralizar_solicitud_aceguraCalidad a, 	"& vbCrLf &_
				"       presupuesto_upa.protic.concepto_centralizado b,             			"& vbCrLf &_
				"       presupuesto_upa.protic.estado_solicitud c,                  			"& vbCrLf &_
				"       softland.sw_mesce d                                         			"& vbCrLf &_
				"where  a.tpre_ccod in (9)                                          			"& vbCrLf &_
				"and    a.tpre_ccod=b.tpre_ccod                                     			"& vbCrLf &_
				"and    a.ccen_ccod=b.ccen_ccod                                     			"& vbCrLf &_
				"and    a.esol_ccod=c.esol_ccod                                     			"& vbCrLf &_
				"and    isnull(mes_ccod,1)=d.indice                                 			"& vbCrLf &_
				"and    a.esol_ccod not in (2,3)                                    			"& vbCrLf &_
				"and    area_ccod="&area_ccod&"                                     			"& vbCrLf &_
				"and    anio_ccod="&v_prox_anio&"                                   			"

			sql_aprobadas=""& vbCrLf &_
				"select *                                                           			"& vbCrLf &_
				"from   presupuesto_upa.protic.centralizar_solicitud_aceguraCalidad a, 	"& vbCrLf &_
				"       presupuesto_upa.protic.concepto_centralizado b,             			"& vbCrLf &_
				"       presupuesto_upa.protic.estado_solicitud c,                  			"& vbCrLf &_
				"       softland.sw_mesce d                                         			"& vbCrLf &_
				"where  a.tpre_ccod in (7)                                          			"& vbCrLf &_
				"and    a.tpre_ccod=b.tpre_ccod                                     			"& vbCrLf &_
				"and    a.ccen_ccod=b.ccen_ccod                                     			"& vbCrLf &_
				"and    a.esol_ccod=c.esol_ccod                                     			"& vbCrLf &_
				"and    isnull(mes_ccod,1)=d.indice                                 			"& vbCrLf &_
				"and    a.esol_ccod in (2)                                          			"& vbCrLf &_
				"and    area_ccod="&area_ccod&"                                     			"& vbCrLf &_
				"and    anio_ccod="&v_prox_anio&"                                   			"

			f_concepto.AgregaCampoParam "ccen_ccod", "filtro", "tpre_ccod in (9)"




	end select
'----------------------------------------------------DEBUG
'response.Write("<pre>"&sql_solicitud&"</pre>")
'response.End()
'----------------------------------------------------DEBUG
	f_solicitado.consultar sql_solicitud
	f_aprobados.consultar sql_aprobadas

else
	 f_solicitado.consultar "select '' where 1 = 2"
	 f_solicitado.AgregaParam "mensajeError", "Ingrese criterio de busqueda"

	 f_aprobados.consultar "select '' where 1 = 2"
	 f_aprobados.AgregaParam "mensajeError", "Ingrese criterio de busqueda"


end if
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
function agregaEjes()
%>
											<tr>
											<td><strong><%=traeNombre("eje")%></strong> </td>
											</tr>
											<tr>
												<td colspan="2">
												<span id="combo_1">
													<SELECT NAME="selCombo" SIZE=1 onChange="traeComboFoco(this.value);">
														<OPTION VALUE=0>Seleccione un eje Presupuestario </OPTION>
														<% while f_busqueda_c1.siguiente %>
														<option value="<%=f_busqueda_c1.ObtenerValor("eje_ccod")%>"><%=f_busqueda_c1.ObtenerValor("eje_tdesc")%></option>
														<% wend %>
														<option value="100">Otro</option>
													</SELECT>
												</span>
												</td>
											</tr>
											<tr>
												<td><strong><%=traeNombre("foco")%></strong> </td>
											</tr>
											<tr>
												<td colspan="2">
													<span id="ComboFoco">
														<SELECT NAME="selCombo2" disabled>
															<option value="0">-Bloqueado-</option>
														</select>
													</span>
												</td>
											</tr>
											<tr>
												<td><strong><%=traeNombre("programa")%></strong> </td>
											</tr>
											<tr>
												<td colspan="2">
													<span id="ComboPrograma">
													<SELECT NAME="selCombo3" disabled>
														<option value="0">-Bloqueado-</option>
													</select>
													</span>
												</td>
											</tr>
											<tr>
												<td><strong><%=traeNombre("proyecto")%></strong> </td>
											</tr>
											<tr>
												<td colspan="2">
													<span id="ComboProyecto">
													<SELECT NAME="selCombo4" disabled>
														<option value="0">-Bloqueado-</option>
													</select>
													</span>
												</td>
											</tr>
											<tr>
												<td colspan="2">
												<span id=detalleProyecto align="justify" ></span>
												</td>
											</tr>
											<tr>
												<td><strong><%=traeNombre("objetivo")%></strong> </td>
											</tr>
											<tr>
												<td colspan="2">
													<span id="ComboObjetivo">
													<SELECT NAME="selCombo5" disabled>
														<option value="0">-Bloqueado-</option>
													</select>
													</span>
												</td>
											</tr>
											<tr>
												<td colspan="2">
												<span id=detalleObjetivo  align="justify" ></span>
												</td>
											</tr>
<%
end function


%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script type="text/javascript" src="presupuesto/js/jquery.js"></script>
<script type="text/javascript" src="presupuesto/js/jquery_ui.js" ></script>
<script type="text/javascript" src="presupuesto/js/funciones_2.js" ></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>

<script language="JavaScript">
//
//Funciones para guardar el presupuesto----------------------
function Validar(){
	return true;
}
function format(input)
{
var num = input.value.replace(/\./g,'');
if(!isNaN(num)){
num = num.toString().split('').reverse().join('').replace(/(?=\d*\.?)(\d{3})/g,'$1.');
num = num.split('').reverse().join('').replace(/^[\.]/,'');
input.value = num;
}

else{ alert('Solo se permiten numeros');
input.value = input.value.replace(/[^\d\.]*/g,'');
}
}
function GrabarSolicitud()
{

	formulario=document.forms['solicitud'];
	v_concepto			=	document.solicitud.elements['busqueda[0][ccen_ccod]'].value; // Combo concepto.
	v_descripcion		=	formulario.descripcion.value; // caja de texto descripción.
	v_cantidad			=	formulario.cantidad.value; // caja de texto cantidad.
	v_valorAprox		=	formulario.vAprox.value; // caja de texto valor aproximado.
	//v_ComboEje			=	formulario.selCombo.value; // valor del comboEje.
	//v_ComboFoco			=	formulario.selCombo2.value; // valor del comboEje.
	//v_ComboPrograma		=	formulario.selCombo3.value; // valor del comboEje.
	//v_ComboProyecto		=	formulario.selCombo4.value; // valor del comboProyecto.
//	if(v_ComboEje == '0')
//	{
//		alert("No se ha seleccionado un Eje");
//		formulario.selCombo.focus();
//		return false;
//	}
//	if(v_ComboEje!=100){
//
//		if(v_ComboFoco == '0'  )
//		{
//			alert("No se ha seleccionado un foco");
//			formulario.selCombo2.focus();
//			return false;
//		}
//		if(v_ComboPrograma == '0' )
//		{
//			alert("No se ha seleccionado un Programa");
//			formulario.selCombo3.focus();
//			return false;
//		}
//		if(v_ComboProyecto == '0' )
//		{
//			alert("No se ha seleccionado un Proyecto");
//			formulario.selCombo4.focus();
//			return false;
//		}
//	}
	if(v_valorAprox==""){
		alert("No ha seleccionado un Valor Apoximado.");
		return false;
	}
	if(v_concepto==""){
		alert("No ha seleccionado un concepto presupuestario válido");
		return false;
	}

	if((v_descripcion!="")&&(v_cantidad!="")){

		formulario.action = "proc_agrega_solicitud_centralizada.asp";
		formulario.method = "post";
		formulario.submit();
	}else{
		alert("Debe ingresar una descripcion y una cantidad valida para su solicitud");
		return false;
	}
}
//Función encargada de eliminar el estado
//num		: es el número de opción (pestaña)
//v_estado	: estado de la solicitud([1	Pendiente], [2	Activa], [3	Anulada], [4 Rechazada])
function CambiaEstado(num,v_estado,codigo){
  // pruebas --->
  //alert("num -> "+num+"-v_estado -> "+v_estado+"-codigo -> "+codigo);
  //return;
  // pruebas ---<

	area='<%=area_ccod%>';
	if(v_estado==2)
	{
		alert("Esta solicitud ya fue activada, por lo tanto no es posible anularla");
	}else{

		if(v_estado==4)
		{
			window.open("ver_motivo_rechazo.asp?nro="+num+"&cod="+codigo,"ventana1","width=300,height=180,scrollbars=no, left=380, top=350")
		}else{
			// solo estados pendientes y anulada
			if(v_estado==1){
				txt_estado="Anular";
			}else{
				txt_estado="desea dejar Pendiente";
			}

			if(confirm("Esta seguro que "+txt_estado+" la solicitud seleccionada")){
				location.href="proc_cambia_estado_solicitud.asp?nro="+num+"&etd="+v_estado+"&cod="+codigo+"&area="+area;
			}
		}
	}

}

function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if%>
}
//Funciones para guardar el presupuesto----------------------
//


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
                      <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador
                      </font></div></td>
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
                <td bgcolor="#D8D8DE"><div align="center">
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
                </div></td>
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
                    <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="170" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Ingreso Solicitud Centralizada</font></div>
                    </td>
                    <td width="485" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
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
							  // pestanias
								arrArea = Array()
								Redim arrArea(10)
								arrArea(1) = array("Audiovisual","ingreso_presupuesto_centralizado.asp?area_ccod="&area_ccod&"&nro_t=1")
								arrArea(2) = array("Biblioteca","ingreso_presupuesto_centralizado.asp?area_ccod="&area_ccod&"&nro_t=2")
								arrArea(3) = array("TIC","ingreso_presupuesto_centralizado.asp?area_ccod="&area_ccod&"&nro_t=3")
								arrArea(4) = array("Operaciones","ingreso_presupuesto_centralizado.asp?area_ccod="&area_ccod&"&nro_t=4")
								arrArea(5) = array("Recursos Humanos","ingreso_presupuesto_centralizado.asp?area_ccod="&area_ccod&"&nro_t=5")
								arrArea(6) = array("Recursos de apoyo a la docencia","ingreso_presupuesto_centralizado.asp?area_ccod="&area_ccod&"&nro_t=6")
								arrArea(7) = array("Vicerrectoría Académica","ingreso_presupuesto_centralizado.asp?area_ccod="&area_ccod&"&nro_t=7")
								arrArea(8) = array("DAE","ingreso_presupuesto_centralizado.asp?area_ccod="&area_ccod&"&nro_t=8")
								arrArea(9) = array("Dirección de Análisis y Aseg. de la Calidad","ingreso_presupuesto_centralizado.asp?area_ccod="&area_ccod&"&nro_t=9")
								pagina.DibujarLenguetasFClaro Array(arrArea(1), arrArea(2), arrArea(3),arrArea(4),arrArea(5),arrArea(6), arrArea(7), arrArea(8), arrArea(9) ), nro_t
							  %>
                            </td>
                          </tr>
                          <tr>
                            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
                          </tr>
                          <tr>
                            <td><br/>

							<% select case (nro_t)	%>
							<% case 1:	%>
<%
'----------------------->>
' 	inicio audiovisual
'----------------------->>
%>
								<font>Requerimientos Audiovisuales</font>
								<br/>

								<form name="solicitud">
								<input type="hidden" name="area_ccod" value="<%=area_ccod%>">
								<input type="hidden" name="tipo" value="1">
								<table border="1" width="%" bordercolorlight="#CCCCCC" bordercolordark="#CCCCCC">
								<tr>
									<td valign="top">
										<table>
											<%
											//agregaEjes() //agrega los combos de audiovisual.
											%>
										</table>
									</td>
									<td>
											<table border="1" width="%" bordercolorlight="#CCCCCC" bordercolordark="#CCCCCC">
											<tr>
												<td colspan="3" align="center"><strong>Solicitar</strong></td>
											</tr>
											<tr>
												<td><strong>Concepto</strong></td><td>:</td><td><%=f_concepto.DibujaCampo("ccen_ccod")%></td>
											</tr>
											<tr>
												<td><strong>Descripción</strong></td><td>:</td><td>
												<textarea name="descripcion" cols="40" rows="5"></textarea>
												<!--<input type="text" name="descripcion" size="50">-->
												</td>
											</tr>
											<tr>
												<td><strong>Cantidad</strong></td><td>:</td><td><input type="text" value="1" name="cantidad" size="4" maxlength="4" onClick="this.select();" > Unidades</td>
											</tr>
											<tr><%htmlValorEstimado()%></tr>
											<tr><%htmlTipoPresupuesto()%></tr>
											<tr>
												<td><strong>Mes</strong></td><td>:</td><td>
												<select name="mes">
													<option value="1">ENERO</option>
													<option value="2">FEBRERO</option>
													<option value="3">MARZO</option>
													<option value="4">ABRIL</option>
													<option value="5">MAYO</option>
													<option value="6">JUNIO</option>
													<option value="7">JULIO</option>
													<option value="8">AGOSTO</option>
													<option value="9">SEPTIEMBRE</option>
													<option value="10">OCTUBRE</option>
													<option value="11">NOVIEMBRE</option>
													<option value="12">DICIEMBRE</option>
												</select></td>
											</tr>
											<tr>
												<td colspan="3" align="center"><% botonera.DibujaBoton("agrega_concepto") %></td>
											</tr>
										</table>
									</td>
								</tr>
								</table>
								</form>
								<br/>
								<font>Pendientes</font>
								<br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'>
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripción</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="9%">Valor Aprox.</th>
									  <th width="9%">Tipo gasto</th>
									  <th width="18%">Estado</th>
									  <th width="18%">Accion</th>
									</tr>
									<%
									while f_solicitado.Siguiente
									'----------------------------------------------
									v_neje 			= f_solicitado.ObtenerValor("eje_ccod")
									v_nfoco			= f_solicitado.ObtenerValor("foco_ccod")
									v_nprograma		= f_solicitado.ObtenerValor("prog_ccod")
									v_nproyecto 	= f_solicitado.ObtenerValor("proye_ccod")
									v_nobjetivo 	= f_solicitado.ObtenerValor("obje_ccod")
									v_nTPresu		= f_solicitado.ObtenerValor("t_presupuesto")
									v_TPresu		= ""
									if(v_nTPresu = "1") then v_TPresu = "Primario" end if
									if(v_nTPresu = "2") then v_TPresu = "Secundario" end if

									v_eje 		= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
									v_foco		= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&v_nfoco&"")
									v_programa	= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&v_nprograma&"")
									v_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
									v_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&v_nobjetivo&"")
									'cadenaTabla()
									va_nTPresu		= f_aprobados.ObtenerValor("t_presupuesto")
									va_neje 		= f_aprobados.ObtenerValor("eje_ccod")
									va_nfoco		= f_aprobados.ObtenerValor("foco_ccod")
									va_nprograma	= f_aprobados.ObtenerValor("prog_ccod")
									va_nproyecto 	= f_aprobados.ObtenerValor("proye_ccod")
									va_nobjetivo 	= f_aprobados.ObtenerValor("obje_ccod")

									va_TPresu		= ""
									if(va_nTPresu = "1") then va_TPresu = "Primario" end if
									if(va_nTPresu = "2") then va_TPresu = "Secundario" end if
									va_eje 			= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
									va_foco			= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&v_nfoco&"")
									va_programa		= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&v_nprograma&"")
									va_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
									va_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&v_nobjetivo&"")
									'----------------------------------------------
									%>
									<tr bordercolor='#999999'>
									  <td><font color="#0033FF"><%f_solicitado.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_solicitado.DibujaCampo("ccau_tdesc")%></td>
									  <td><%=f_solicitado.DibujaCampo("nombremes")%></td>
									  <td><%=f_solicitado.DibujaCampo("ccau_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("v_aprox")%></td>
									  <td><%=v_TPresu%></td>
									  <td><%=f_solicitado.DibujaCampo("esol_tdesc")%></td>
									  <td><a href="javascript:CambiaEstado(1,<%f_solicitado.DibujaCampo("esol_ccod")%>,<%f_solicitado.DibujaCampo("ccau_ncorr")%>);"><%f_solicitado.DibujaCampo("accion")%></a></td>
									</tr>
									 <%
									 wend%>
									 <%if f_solicitado.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="13" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
									 <% end if%>
								</table>
								<br/>
								<font>Aceptadas</font>
								<br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'>
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripción</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="9%">Valor Aprox.</th>
									  <th width="9%">Tipo gasto</th>
									  <th width="18%">Estado</th>
									</tr>
									<%
									while f_aprobados.Siguiente
									%>
									<tr bordercolor='#999999'>
									  <td><font color="#0033FF"><%f_aprobados.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_aprobados.DibujaCampo("ccau_tdesc")%></td>
									  <td><%=cadenaTabla(va_eje)%></td>
									  <td><%=cadenaTabla(va_foco)%></td>
									  <td><%=cadenaTabla(va_programa)%></td>
									  <td><%=cadenaTabla(va_proyecto)%></td>
									  <td><%=cadenaTabla(va_objetivo)%></td>
									  <td><%=f_aprobados.DibujaCampo("nombremes")%></td>
									  <td><%=f_aprobados.DibujaCampo("ccau_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("v_aprox")%></td>
									  <td><%=v_TPresu%></td>
									  <td><%=f_aprobados.DibujaCampo("esol_tdesc")%></td>
									</tr>
									 <%wend%>
									 <%if f_aprobados.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="12" align="center">No se encontraron solicitudes aprobadas </td></tr>
									 <% end if%>
								</table>

							<%case 2:%>
<%
'----------------------------------->>
' 	inicio Material Bibliográfico
'----------------------------------->>
%>
								<font>Material Bibliográfico</font>
								<br/>

								<form name="solicitud">
								<input type="hidden" name="area_ccod" value="<%=area_ccod%>">
								<input type="hidden" name="tipo" value="2">
								<table border="1" width="%" bordercolorlight="#CCCCCC" bordercolordark="#CCCCCC">
								<tr>
									<td valign="top">
										<table>
											<%
											//agregaEjes()
											%>
										</table>
									</td>
									<td>
								<table border="1" width="%" bordercolorlight="#CCCCCC" bordercolordark="#CCCCCC">
									<tr>
										<td colspan="3" align="center"><strong>Solicitar</strong></td>
									</tr>
									<tr>
										<td><strong>Concepto</strong></td><td>:</td><td><%=f_concepto.DibujaCampo("ccen_ccod")%></td>
									</tr>
									<tr>
										<td><strong>Descripción</strong></td><td>:</td><td>
										<textarea name="descripcion" cols="40" rows="5"></textarea>
										<!--<input type="text" name="descripcion" size="50">-->
										</td>
									</tr>
									<tr>
										<td><strong>Cantidad</strong></td><td>:</td><td><input type="text" value="1" name="cantidad" size="4" maxlength="4" onClick="this.select();"> Unidades</td>
									</tr>
									<tr><%htmlValorEstimado()%></tr>
									<tr><%htmlTipoPresupuesto()%></tr>
									<tr>
										<td><strong>Mes</strong></td><td>:</td><td>
										<select name="mes">
											<option value="1">ENERO</option>
											<option value="2">FEBRERO</option>
											<option value="3">MARZO</option>
											<option value="4">ABRIL</option>
											<option value="5">MAYO</option>
											<option value="6">JUNIO</option>
											<option value="7">JULIO</option>
											<option value="8">AGOSTO</option>
											<option value="9">SEPTIEMBRE</option>
											<option value="10">OCTUBRE</option>
											<option value="11">NOVIEMBRE</option>
											<option value="12">DICIEMBRE</option>
										</select></td>
									</tr>
									<tr>
										<td colspan="3" align="center"><% botonera.DibujaBoton("agrega_concepto") %></td>
									</tr>
								</table>
									</td>
								</tr>
								</table>
								</form>
								<br/>
								<font>Pendientes</font>
								<br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'>
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripción</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="9%">Valor Aprox.</th>
									  <th width="9%">Tipo gasto</th>
									  <th width="18%">Estado</th>
									  <th width="18%">Accion</th>
									</tr>
									<%
									while f_solicitado.Siguiente
									'----------------------------------------------
									v_neje 			= f_solicitado.ObtenerValor("eje_ccod")
									v_nfoco			= f_solicitado.ObtenerValor("foco_ccod")
									v_nprograma		= f_solicitado.ObtenerValor("prog_ccod")
									v_nproyecto 	= f_solicitado.ObtenerValor("proye_ccod")
									v_nobjetivo 	= f_solicitado.ObtenerValor("obje_ccod")
									v_nTPresu		= f_solicitado.ObtenerValor("t_presupuesto")
									v_TPresu		= ""
									if(v_nTPresu = "1") then v_TPresu = "Primario" end if
									if(v_nTPresu = "2") then v_TPresu = "Secundario" end if

									v_eje 		= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
									v_foco		= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&v_nfoco&"")
									v_programa	= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&v_nprograma&"")
									v_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
									v_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&v_nobjetivo&"")
									'cadenaTabla()
									va_nTPresu		= f_aprobados.ObtenerValor("t_presupuesto")
									va_neje 		= f_aprobados.ObtenerValor("eje_ccod")
									va_nfoco		= f_aprobados.ObtenerValor("foco_ccod")
									va_nprograma	= f_aprobados.ObtenerValor("prog_ccod")
									va_nproyecto 	= f_aprobados.ObtenerValor("proye_ccod")
									va_nobjetivo 	= f_aprobados.ObtenerValor("obje_ccod")

									va_TPresu		= ""
									if(va_nTPresu = "1") then va_TPresu = "Primario" end if
									if(va_nTPresu = "2") then va_TPresu = "Secundario" end if
									va_eje 			= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
									va_foco			= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&v_nfoco&"")
									va_programa		= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&v_nprograma&"")
									va_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
									va_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&v_nobjetivo&"")
									'----------------------------------------------
																		%>

									<tr bordercolor='#999999'>
									  <td><font color="#0033FF"><%f_solicitado.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_solicitado.DibujaCampo("ccbi_tdesc")%></td>
									  <td><%=f_solicitado.DibujaCampo("nombremes")%></td>
									  <td><%=f_solicitado.DibujaCampo("ccbi_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("v_aprox")%></td>
									  <td><%=v_TPresu%></td>
									  <td><%=f_solicitado.DibujaCampo("esol_tdesc")%></td>
									  <td><a href="javascript:CambiaEstado(2,<%f_solicitado.DibujaCampo("esol_ccod")%>,<%f_solicitado.DibujaCampo("ccbi_ncorr")%>);"><%f_solicitado.DibujaCampo("accion")%></a></td>
									</tr>
									 <%wend%>
									 <%if f_solicitado.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="13" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
									 <% end if%>
								</table>
								<br/>
								<font>Aceptadas</font>
								<br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'>
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripción</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="9%">Valor Aprox.</th>
									  <th width="9%">Tipo gasto</th>
									  <th width="18%">Estado</th>
									</tr>
									<%
									while f_aprobados.Siguiente
									%>
									<tr bordercolor='#999999'>
									  <td><font color="#0033FF"><%f_aprobados.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_aprobados.DibujaCampo("ccbi_tdesc")%></td>
									  <td><%=cadenaTabla(va_eje)%></td>
									  <td><%=cadenaTabla(va_foco)%></td>
									  <td><%=cadenaTabla(va_programa)%></td>
									  <td><%=cadenaTabla(va_proyecto)%></td>
									  <td><%=cadenaTabla(va_objetivo)%></td>
									  <td><%=f_aprobados.DibujaCampo("nombremes")%></td>
									  <td><%=f_aprobados.DibujaCampo("ccbi_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("v_aprox")%></td>
									  <td><%=v_TPresu%></td>
									  <td><%=f_aprobados.DibujaCampo("esol_tdesc")%></td>
									</tr>
									 <%wend%>
									 <%if f_aprobados.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="12" align="center">No se encontraron solicitudes aprobadas </td></tr>
									 <% end if%>
								</table>

<%case 3:%>

								<font>Requerimientos Computacionales</font>
								<br/>

								<form name="solicitud">
								<input type="hidden" name="area_ccod" value="<%=area_ccod%>">
								<input type="hidden" name="tipo" value="3">
	<table border="1" width="%" bordercolorlight="#CCCCCC" bordercolordark="#CCCCCC">
								<tr>
									<td valign="top">
										<table>
											<%
											//agregaEjes()
											%>
										</table>
									</td>
									<td>
								<table border="1" width="%" bordercolorlight="#CCCCCC" bordercolordark="#CCCCCC">
									<tr>
										<td colspan="4" align="center"><strong>Solicitar</strong></td>
									</tr>
									<tr>
										<td><strong>Concepto</strong></td><td>:</td><td><%=f_concepto.DibujaCampo("ccen_ccod")%></td>
									</tr>
									<tr>
										<td><strong>Descripción</strong></td><td>:</td><td>
										<textarea name="descripcion" cols="40" rows="5"></textarea>
										<!--<input type="text" name="descripcion" size="50">-->
										</td>
									</tr>
									<tr>
										<td><strong>Cantidad</strong></td><td>:</td><td><input type="text" value="1" name="cantidad" size="4" maxlength="4" onClick="this.select();"> Unidades</td>
									</tr>
									<tr><%htmlValorEstimado()%></tr>
									<tr><%htmlTipoPresupuesto()%></tr>
									<tr>
										<td><strong>Mes</strong></td><td>:</td><td>
										<select name="mes">
											<option value="1">ENERO</option>
											<option value="2">FEBRERO</option>
											<option value="3">MARZO</option>
											<option value="4">ABRIL</option>
											<option value="5">MAYO</option>
											<option value="6">JUNIO</option>
											<option value="7">JULIO</option>
											<option value="8">AGOSTO</option>
											<option value="9">SEPTIEMBRE</option>
											<option value="10">OCTUBRE</option>
											<option value="11">NOVIEMBRE</option>
											<option value="12">DICIEMBRE</option>
										</select></td>
									</tr>
									<tr>
										<td colspan="3" align="center"><% botonera.DibujaBoton("agrega_concepto") %></td>
									</tr>
								</table>
									</td>
								</tr>
								</table>
								</form>
								<br/>
								<font>Pendientes</font>
								<br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'>
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripción</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="9%">Valor Aprox.</th>
									  <th width="9%">Tipo gasto</th>
									  <th width="18%">Estado</th>
									  <th width="18%">Accion</th>
									</tr>
									<%
									while f_solicitado.Siguiente
									'----------------------------------------------
									v_neje 			= f_solicitado.ObtenerValor("eje_ccod")
									v_nfoco			= f_solicitado.ObtenerValor("foco_ccod")
									v_nprograma		= f_solicitado.ObtenerValor("prog_ccod")
									v_nproyecto 	= f_solicitado.ObtenerValor("proye_ccod")
									v_nobjetivo 	= f_solicitado.ObtenerValor("obje_ccod")
									v_nTPresu		= f_solicitado.ObtenerValor("t_presupuesto")
									v_TPresu		= ""
									if(v_nTPresu = "1") then v_TPresu = "Primario" end if
									if(v_nTPresu = "2") then v_TPresu = "Secundario" end if

									v_eje 		= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
									v_foco		= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&v_nfoco&"")
									v_programa	= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&v_nprograma&"")
									v_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
									v_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&v_nobjetivo&"")
									'cadenaTabla()
									va_nTPresu		= f_aprobados.ObtenerValor("t_presupuesto")
									va_neje 		= f_aprobados.ObtenerValor("eje_ccod")
									va_nfoco		= f_aprobados.ObtenerValor("foco_ccod")
									va_nprograma	= f_aprobados.ObtenerValor("prog_ccod")
									va_nproyecto 	= f_aprobados.ObtenerValor("proye_ccod")
									va_nobjetivo 	= f_aprobados.ObtenerValor("obje_ccod")

									va_TPresu		= ""
									if(va_nTPresu = "1") then va_TPresu = "Primario" end if
									if(va_nTPresu = "2") then va_TPresu = "Secundario" end if
									va_eje 			= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
									va_foco			= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&v_nfoco&"")
									va_programa		= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&v_nprograma&"")
									va_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
									va_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&v_nobjetivo&"")
									'----------------------------------------------
									%>
									<tr bordercolor='#999999'>
									  <td><font color="#0033FF"><%f_solicitado.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_solicitado.DibujaCampo("ccco_tdesc")%></td>
									  <td><%=f_solicitado.DibujaCampo("nombremes")%></td>
									  <td><%=f_solicitado.DibujaCampo("ccco_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("v_aprox")%></td>
									  <td><%=v_TPresu%></td>
									  <td><%=f_solicitado.DibujaCampo("esol_tdesc")%></td>
									  <td><a href="javascript:CambiaEstado(3,<%f_solicitado.DibujaCampo("esol_ccod")%>,<%f_solicitado.DibujaCampo("ccco_ncorr")%>);"><%f_solicitado.DibujaCampo("accion")%></a></td>
									</tr>
									 <%wend%>
									 <%if f_solicitado.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="13" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
									 <% end if%>
								</table>
								<br/>
								<font>Aceptadas</font>
								<br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'>
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripción</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="9%">Valor Aprox.</th>
									  <th width="9%">Tipo gasto</th>
									  <th width="18%">Estado</th>
									</tr>
									<%
									while f_aprobados.Siguiente
									%>
									<tr bordercolor='#999999'>
									  <td><font color="#0033FF"><%f_aprobados.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_aprobados.DibujaCampo("ccco_tdesc")%></td>
									  <td><%=cadenaTabla(va_eje)%></td>
									  <td><%=cadenaTabla(va_foco)%></td>
									  <td><%=cadenaTabla(va_programa)%></td>
									  <td><%=cadenaTabla(va_proyecto)%></td>
									  <td><%=cadenaTabla(va_objetivo)%></td>
									  <td><%=f_aprobados.DibujaCampo("nombremes")%></td>
									  <td><%=f_aprobados.DibujaCampo("ccco_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("v_aprox")%></td>
									  <td><%=v_TPresu%></td>
									  <td><%=f_aprobados.DibujaCampo("esol_tdesc")%></td>
									</tr>
									 <%wend%>
									 <%if f_aprobados.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="12" align="center">No se encontraron solicitudes aprobadas </td></tr>
									 <% end if%>
								</table>

							<%case 4:%>

								<font>Requerimientos Reparaciones, Equipos Mobiliarios</font>
								<br/>

								<form name="solicitud">
								<input type="hidden" name="area_ccod" value="<%=area_ccod%>">
								<input type="hidden" name="tipo" value="4">
								<table border="1" width="%" bordercolorlight="#CCCCCC" bordercolordark="#CCCCCC">
								<tr>
									<td valign="top">
										<table>
											<%
											//agregaEjes()
											%>
										</table>
									</td>

									<td valign="top">
									<table border="1" width="%" bordercolorlight="#CCCCCC" bordercolordark="#CCCCCC">
									<tr>
										<td colspan="3" align="center"><strong>Solicitar</strong></td>
									</tr>
									<tr>
										<td><strong>Concepto</strong></td><td>:</td><td><%=f_concepto.DibujaCampo("ccen_ccod")%></td>
									</tr>
									<tr>
										<td><strong>Descripción</strong></td><td>:</td><td>
										<textarea name="descripcion" cols="40" rows="5"></textarea>
										<!--<input type="text" name="descripcion" size="50">-->
										</td>
									</tr>
									<tr>
										<td><strong>Cantidad</strong></td><td>:</td><td><input type="text" name="cantidad" size="4" maxlength="4" value="1" onClick="this.select();"> Unidades</td>
									</tr>
									<tr><%htmlValorEstimado()%></tr>
									<tr><%htmlTipoPresupuesto()%></tr>
									<tr>
										<td><strong>Mes</strong></td><td>:</td><td>
										<select name="mes">
											<option value="1">ENERO</option>
											<option value="2">FEBRERO</option>
											<option value="3">MARZO</option>
											<option value="4">ABRIL</option>
											<option value="5">MAYO</option>
											<option value="6">JUNIO</option>
											<option value="7">JULIO</option>
											<option value="8">AGOSTO</option>
											<option value="9">SEPTIEMBRE</option>
											<option value="10">OCTUBRE</option>
											<option value="11">NOVIEMBRE</option>
											<option value="12">DICIEMBRE</option>
										</select></td>
									</tr>
									<tr>
										<td><strong>Sede Asociada</strong></td><td>:</td><td>
										<select name="sede_ccod">
											<option value="1">LAS CONDES</option>
											<option value="4">MELIPILLA</option>
										</select></td>
									</tr>
									<tr>
										<td colspan="3" align="center"><% botonera.DibujaBoton("agrega_concepto") %></td>
									</tr>
									</table>
									</td>
								</tr>
								</table>
								</form>
								<br/>
								<font>Pendientes</font>
								<br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'>
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripción</th>
									  <th width="9%">Para mes</th>
									   <th width="9%">Sede</th>
									  <th width="9%">Cantidad</th>
									  <th width="9%">Valor Aprox.</th>
									  <th width="9%">Tipo gasto</th>
									  <th width="18%">Estado</th>
									  <th width="18%">Accion</th>
									</tr>
									<%
									while f_solicitado.Siguiente
									'----------------------------------------------
									v_neje 			= f_solicitado.ObtenerValor("eje_ccod")
									v_nfoco			= f_solicitado.ObtenerValor("foco_ccod")
									v_nprograma		= f_solicitado.ObtenerValor("prog_ccod")
									v_nproyecto 	= f_solicitado.ObtenerValor("proye_ccod")
									v_nobjetivo 	= f_solicitado.ObtenerValor("obje_ccod")
									v_nTPresu		= f_solicitado.ObtenerValor("t_presupuesto")
									v_TPresu		= ""
									if(v_nTPresu = "1") then v_TPresu = "Primario" end if
									if(v_nTPresu = "2") then v_TPresu = "Secundario" end if

									v_eje 		= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
									v_foco		= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&v_nfoco&"")
									v_programa	= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&v_nprograma&"")
									v_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
									v_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&v_nobjetivo&"")
									'cadenaTabla()
									va_nTPresu		= f_aprobados.ObtenerValor("t_presupuesto")
									va_neje 		= f_aprobados.ObtenerValor("eje_ccod")
									va_nfoco		= f_aprobados.ObtenerValor("foco_ccod")
									va_nprograma	= f_aprobados.ObtenerValor("prog_ccod")
									va_nproyecto 	= f_aprobados.ObtenerValor("proye_ccod")
									va_nobjetivo 	= f_aprobados.ObtenerValor("obje_ccod")

									va_TPresu		= ""
									if(va_nTPresu = "1") then va_TPresu = "Primario" end if
									if(va_nTPresu = "2") then va_TPresu = "Secundario" end if
									va_eje 			= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
									va_foco			= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&v_nfoco&"")
									va_programa		= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&v_nprograma&"")
									va_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
									va_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&v_nobjetivo&"")
									'----------------------------------------------
									%>
									<tr bordercolor='#999999'>
									  <td><font color="#0033FF"><%f_solicitado.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_solicitado.DibujaCampo("ccsg_tdesc")%></td>
									  <td><%=f_solicitado.DibujaCampo("nombremes")%></td>
									  <td><%=f_solicitado.DibujaCampo("sede")%></td>
									  <td><%=f_solicitado.DibujaCampo("ccsg_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("v_aprox")%></td>
									  <td><%=v_TPresu%></td>
									  <td><%=f_solicitado.DibujaCampo("esol_tdesc")%></td>
									  <td><a href="javascript:CambiaEstado(4,<%f_solicitado.DibujaCampo("esol_ccod")%>,<%f_solicitado.DibujaCampo("ccsg_ncorr")%>);"><%f_solicitado.DibujaCampo("accion")%></a></td>
									</tr>

									 <%wend%>
									 <%if f_solicitado.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="14" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
									 <% end if%>
								</table>
								<br/>
								<font>Aceptadas</font>
								<br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'>
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripción</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Sede</th>
									  <th width="9%">Cantidad</th>
									  <th width="9%">Valor Aprox.</th>
									  <th width="9%">Tipo gasto</th>
									  <th width="18%">Estado</th>
									</tr>
									<%
									while f_aprobados.Siguiente
									%>
									<tr bordercolor='#999999'>
									  <td><font color="#0033FF"><%f_aprobados.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_aprobados.DibujaCampo("ccsg_tdesc")%></td>
									  <td><%=cadenaTabla(va_eje)%></td>
									  <td><%=cadenaTabla(va_foco)%></td>
									  <td><%=cadenaTabla(va_programa)%></td>
									  <td><%=cadenaTabla(va_proyecto)%></td>
									  <td><%=cadenaTabla(va_objetivo)%></td>
									  <td><%=f_aprobados.DibujaCampo("nombremes")%></td>
									  <td><%=f_aprobados.DibujaCampo("sede")%></td>
									  <td><%=f_aprobados.DibujaCampo("ccsg_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("v_aprox")%></td>
									  <td><%=v_TPresu%></td>
									  <td><%=f_aprobados.DibujaCampo("esol_tdesc")%></td>
									</tr>
									 <%wend%>
									 <%if f_aprobados.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="13" align="center">No se encontraron solicitudes aprobadas </td></tr>
									 <% end if%>
								</table>

<%
'-----------------------------------
'	INICIO RECURSOS HUMANOS
'-----------------------------------
%>
								<%case 5:%>

								<font>Requerimientos de Personal</font>
								<br/>

								<form name="solicitud">
								<input type="hidden" name="area_ccod" value="<%=area_ccod%>">
								<input type="hidden" name="tipo" value="5">
								<table border="1" width="%" bordercolorlight="#CCCCCC" bordercolordark="#CCCCCC">
								<tr>
									<td valign="top">
										<table>
											<%
											//agregaEjes()
											%>
										</table>
									</td>
									<td>
								<table border="1" width="%" bordercolorlight="#CCCCCC" bordercolordark="#CCCCCC">
									<tr>
										<td colspan="3" align="center"><strong>Solicitar</strong></td>
									</tr>
									<tr>
										<td><strong>Concepto</strong></td><td>:</td><td><%=f_concepto.DibujaCampo("ccen_ccod")%></td>
									</tr>
									<tr>
										<td><strong>Descripción</strong></td><td>:</td><td>
										<textarea name="descripcion" cols="40" rows="5"></textarea>
										<!--<input type="text" name="descripcion" size="50">-->
										</td>
									</tr>
									<tr>
										<td><strong>Cantidad</strong></td><td>:</td><td><input type="text" name="cantidad" size="4" maxlength="4" value="1" onClick="this.select();"> Unidades</td>
									</tr>
									<tr><%htmlValorEstimado()%></tr>
									<tr><%htmlTipoPresupuesto()%></tr>
									<tr>
										<td><strong>Mes</strong></td><td>:</td><td>
										<select name="mes">
											<option value="1">ENERO</option>
											<option value="2">FEBRERO</option>
											<option value="3">MARZO</option>
											<option value="4">ABRIL</option>
											<option value="5">MAYO</option>
											<option value="6">JUNIO</option>
											<option value="7">JULIO</option>
											<option value="8">AGOSTO</option>
											<option value="9">SEPTIEMBRE</option>
											<option value="10">OCTUBRE</option>
											<option value="11">NOVIEMBRE</option>
											<option value="12">DICIEMBRE</option>
										</select></td>
									</tr>
									<tr>
										<td colspan="3" align="center"><% botonera.DibujaBoton("agrega_concepto") %></td>
									</tr>
								</table>
									</td>
								</tr>
								</table>
								</form>
								<br/>
								<font>Pendientes</font>
								<br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'>
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripción</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="9%">Valor Aprox.</th>
									  <th width="9%">Tipo gasto</th>
									  <th width="18%">Estado</th>
									  <th width="18%">Accion</th>
									</tr>
									<%
									while f_solicitado.Siguiente
									'----------------------------------------------
									v_neje 			= f_solicitado.ObtenerValor("eje_ccod")
									v_nfoco			= f_solicitado.ObtenerValor("foco_ccod")
									v_nprograma		= f_solicitado.ObtenerValor("prog_ccod")
									v_nproyecto 	= f_solicitado.ObtenerValor("proye_ccod")
									v_nobjetivo 	= f_solicitado.ObtenerValor("obje_ccod")
									v_nTPresu		= f_solicitado.ObtenerValor("t_presupuesto")
									v_TPresu		= ""
									if(v_nTPresu = "1") then v_TPresu = "Primario" end if
									if(v_nTPresu = "2") then v_TPresu = "Secundario" end if

									v_eje 		= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
									v_foco		= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&v_nfoco&"")
									v_programa	= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&v_nprograma&"")
									v_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
									v_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&v_nobjetivo&"")
									'cadenaTabla()
									va_nTPresu		= f_aprobados.ObtenerValor("t_presupuesto")
									va_neje 		= f_aprobados.ObtenerValor("eje_ccod")
									va_nfoco		= f_aprobados.ObtenerValor("foco_ccod")
									va_nprograma	= f_aprobados.ObtenerValor("prog_ccod")
									va_nproyecto 	= f_aprobados.ObtenerValor("proye_ccod")
									va_nobjetivo 	= f_aprobados.ObtenerValor("obje_ccod")

									va_TPresu		= ""
									if(va_nTPresu = "1") then va_TPresu = "Primario" end if
									if(va_nTPresu = "2") then va_TPresu = "Secundario" end if
									va_eje 			= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
									va_foco			= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&v_nfoco&"")
									va_programa		= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&v_nprograma&"")
									va_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
									va_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&v_nobjetivo&"")
									'----------------------------------------------
									%>
									<tr bordercolor='#999999'>
									  <td><font color="#0033FF"><%f_solicitado.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_solicitado.DibujaCampo("ccpe_tdesc")%></td>
									  <td><%=f_solicitado.DibujaCampo("nombremes")%></td>
									  <td><%=f_solicitado.DibujaCampo("ccpe_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("v_aprox")%></td>
									  <td><%=v_TPresu%></td>
									  <td><%=f_solicitado.DibujaCampo("esol_tdesc")%></td>
									  <td><a href="javascript:CambiaEstado(5,<%f_solicitado.DibujaCampo("esol_ccod")%>,<%f_solicitado.DibujaCampo("ccpe_ncorr")%>);"><%f_solicitado.DibujaCampo("accion")%></a></td>
									</tr>
									 <%wend%>
									 <%if f_solicitado.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="13" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
									 <% end if%>
								</table>
								<br/>
								<font>Aceptadas</font>
								<br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'>
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripción</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="9%">Valor Aprox.</th>
									  <th width="9%">Tipo gasto</th>
									  <th width="18%">Estado</th>
									</tr>
									<%
									while f_aprobados.Siguiente
									%>
									<tr bordercolor='#999999'>
									  <td><font color="#0033FF"><%f_aprobados.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_aprobados.DibujaCampo("ccpe_tdesc")%></td>
									  <td><%=cadenaTabla(va_eje)%></td>
									  <td><%=cadenaTabla(va_foco)%></td>
									  <td><%=cadenaTabla(va_programa)%></td>
									  <td><%=cadenaTabla(va_proyecto)%></td>
									  <td><%=cadenaTabla(va_objetivo)%></td>
									  <td><%=f_aprobados.DibujaCampo("nombremes")%></td>
									  <td><%=f_aprobados.DibujaCampo("ccpe_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("v_aprox")%></td>
									  <td><%=v_TPresu%></td>
									  <td><%=f_aprobados.DibujaCampo("esol_tdesc")%></td>
									</tr>
									 <%wend%>
									 <%if f_aprobados.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="12" align="center">No se encontraron solicitudes aprobadas </td></tr>
									 <% end if%>
								</table>


<%
'-----------------------------------
'	INICIO Recursos de apoyo a la docencia
'-----------------------------------
%>

							<%case 6:%>
								<font>Solicitudes del ámbito docente</font>
								<br/>

								<form name="solicitud">
								<input type="hidden" name="area_ccod" value="<%=area_ccod%>">
								<input type="hidden" name="tipo" value="6">
								<table border="1" width="%" bordercolorlight="#CCCCCC" bordercolordark="#CCCCCC">
								<tr>
									<td valign="top">
										<table>
											<%
											//agregaEjes()
											%>
										</table>
									</td>
									<td>
								<table border="1" width="%" bordercolorlight="#CCCCCC" bordercolordark="#CCCCCC">
									<tr>
										<td colspan="3" align="center"><strong>Solicitar</strong></td>
									</tr>
									<tr>
										<td><strong>Concepto</strong></td><td>:</td><td><%=f_concepto.DibujaCampo("ccen_ccod")%></td>
									</tr>
									<tr>
										<td><strong>Descripción</strong></td><td>:</td><td>
										<textarea name="descripcion" cols="40" rows="5"></textarea>
										<!--<input type="text" name="descripcion" size="50">-->
										</td>
									</tr>
									<tr>
										<td><strong>Cantidad</strong></td><td>:</td><td><input type="text" value="1" name="cantidad" size="4" maxlength="4" onClick="this.select();"> Unidades</td>
									</tr>
									<tr><%htmlValorEstimado()%></tr>
									<tr><%htmlTipoPresupuesto()%></tr>
									<tr>
										<td><strong>Mes</strong></td><td>:</td><td>
										<select name="mes">
											<option value="1">ENERO</option>
											<option value="2">FEBRERO</option>
											<option value="3">MARZO</option>
											<option value="4">ABRIL</option>
											<option value="5">MAYO</option>
											<option value="6">JUNIO</option>
											<option value="7">JULIO</option>
											<option value="8">AGOSTO</option>
											<option value="9">SEPTIEMBRE</option>
											<option value="10">OCTUBRE</option>
											<option value="11">NOVIEMBRE</option>
											<option value="12">DICIEMBRE</option>
										</select></td>
									</tr>
									<tr>
										<td colspan="3" align="center"><% botonera.DibujaBoton("agrega_concepto") %></td>
									</tr>
								</table>
									</td>
								</tr>
								</table>
								</form>
								<br/>
								<font>Pendientes</font>
								<br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'>
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripción</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="9%">Valor Aprox.</th>
									  <th width="9%">Tipo gasto</th>
									  <th width="18%">Estado</th>
									  <th width="18%">Accion</th>
									</tr>
									<%
									while f_solicitado.Siguiente
									'----------------------------------------------
									v_neje 			= f_solicitado.ObtenerValor("eje_ccod")
									v_nfoco			= f_solicitado.ObtenerValor("foco_ccod")
									v_nprograma		= f_solicitado.ObtenerValor("prog_ccod")
									v_nproyecto 	= f_solicitado.ObtenerValor("proye_ccod")
									v_nobjetivo 	= f_solicitado.ObtenerValor("obje_ccod")
									v_nTPresu		= f_solicitado.ObtenerValor("t_presupuesto")
									v_TPresu		= ""
									if(v_nTPresu = "1") then v_TPresu = "Primario" end if
									if(v_nTPresu = "2") then v_TPresu = "Secundario" end if

									v_eje 		= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
									v_foco		= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&v_nfoco&"")
									v_programa	= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&v_nprograma&"")
									v_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
									v_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&v_nobjetivo&"")
									'cadenaTabla()
									va_nTPresu		= f_aprobados.ObtenerValor("t_presupuesto")
									va_neje 		= f_aprobados.ObtenerValor("eje_ccod")
									va_nfoco		= f_aprobados.ObtenerValor("foco_ccod")
									va_nprograma	= f_aprobados.ObtenerValor("prog_ccod")
									va_nproyecto 	= f_aprobados.ObtenerValor("proye_ccod")
									va_nobjetivo 	= f_aprobados.ObtenerValor("obje_ccod")

									va_TPresu		= ""
									if(va_nTPresu = "1") then va_TPresu = "Primario" end if
									if(va_nTPresu = "2") then va_TPresu = "Secundario" end if
									va_eje 			= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
									va_foco			= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&v_nfoco&"")
									va_programa		= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&v_nprograma&"")
									va_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
									va_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&v_nobjetivo&"")
									'----------------------------------------------
									%>

									<tr bordercolor='#999999'>
									  <td><font color="#0033FF"><%f_solicitado.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_solicitado.DibujaCampo("ccau_tdesc")%></td>
									  <td><%=f_solicitado.DibujaCampo("nombremes")%></td>
									  <td><%=f_solicitado.DibujaCampo("ccau_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("v_aprox")%></td>
									  <td><%=v_TPresu%></td>
									  <td><%=f_solicitado.DibujaCampo("esol_tdesc")%></td>
									  <td><a href="javascript:CambiaEstado(6,<%f_solicitado.DibujaCampo("esol_ccod")%>,<%f_solicitado.DibujaCampo("ccau_ncorr")%>);"><%f_solicitado.DibujaCampo("accion")%></a></td>
									</tr>


									 <%wend%>
									 <%if f_solicitado.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="13" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
									 <% end if%>
								</table>
								<br/>
								<font>Aceptadas</font>
								<br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'>
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripción</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="9%">Valor Aprox.</th>
									  <th width="9%">Tipo gasto</th>
									  <th width="18%">Estado</th>
									</tr>
									<%
									while f_aprobados.Siguiente
									%>
									<tr bordercolor='#999999'>
									  <td><font color="#0033FF"><%f_aprobados.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_aprobados.DibujaCampo("ccau_tdesc")%></td>
									  <td><%=cadenaTabla(va_eje)%></td>
									  <td><%=cadenaTabla(va_foco)%></td>
									  <td><%=cadenaTabla(va_programa)%></td>
									  <td><%=cadenaTabla(va_proyecto)%></td>
									  <td><%=cadenaTabla(va_objetivo)%></td>
									  <td><%=f_aprobados.DibujaCampo("nombremes")%></td>
									  <td><%=f_aprobados.DibujaCampo("ccau_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("v_aprox")%></td>
									  <td><%=v_TPresu%></td>
									  <td><%=f_aprobados.DibujaCampo("esol_tdesc")%></td>
									</tr>
									 <%wend%>
									 <%if f_aprobados.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="12" align="center">No se encontraron solicitudes aprobadas </td></tr>
									 <% end if%>
								</table>
							<% case 7:	%>
<%
'---------------------------------->>
' 	inicio Vicerectoría académica
'---------------------------------->>
%>
								<font>Vicerectoría académica</font>
								<br/>

								<form name="solicitud">
								<input type="hidden" name="area_ccod" value="<%=area_ccod%>">
								<input type="hidden" name="tipo" value="7">
								<table border="1" width="%" bordercolorlight="#CCCCCC" bordercolordark="#CCCCCC">
								<tr>
									<td valign="top">
										<table>
											<%
											//agregaEjes() //agrega los combos
											%>
										</table>
									</td>
									<td>
											<table border="1" width="%" bordercolorlight="#CCCCCC" bordercolordark="#CCCCCC">
											<tr>
												<td colspan="3" align="center"><strong>Solicitar</strong></td>
											</tr>
											<tr>
												<td><strong>Concepto</strong></td><td>:</td><td><%=f_concepto.DibujaCampo("ccen_ccod")%></td>
											</tr>
											<tr>
												<td><strong>Descripción</strong></td><td>:</td><td>
												<textarea name="descripcion" cols="40" rows="5"></textarea>
												<!--<input type="text" name="descripcion" size="50">-->
												</td>
											</tr>
											<tr>
												<td><strong>Cantidad</strong></td><td>:</td><td><input type="text" value="1" name="cantidad" size="4" maxlength="4" onClick="this.select();" > Unidades</td>
											</tr>
											<tr><%htmlValorEstimado()%></tr>
											<tr><%htmlTipoPresupuesto()%></tr>
											<tr>
												<td><strong>Mes</strong></td><td>:</td><td>
												<select name="mes">
													<option value="1">ENERO</option>
													<option value="2">FEBRERO</option>
													<option value="3">MARZO</option>
													<option value="4">ABRIL</option>
													<option value="5">MAYO</option>
													<option value="6">JUNIO</option>
													<option value="7">JULIO</option>
													<option value="8">AGOSTO</option>
													<option value="9">SEPTIEMBRE</option>
													<option value="10">OCTUBRE</option>
													<option value="11">NOVIEMBRE</option>
													<option value="12">DICIEMBRE</option>
												</select></td>
											</tr>
											<tr>
												<td colspan="3" align="center"><% botonera.DibujaBoton("agrega_concepto") %></td>
											</tr>
										</table>
									</td>
								</tr>
								</table>
								</form>
								<br/>
								<font>Pendientes</font>
								<br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'>
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripción</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="9%">Valor Aprox.</th>
									  <th width="9%">Tipo gasto</th>
									  <th width="18%">Estado</th>
									  <th width="18%">Accion</th>
									</tr>
									<%
									while f_solicitado.Siguiente
									'----------------------------------------------
									v_neje 			= f_solicitado.ObtenerValor("eje_ccod")
									v_nfoco			= f_solicitado.ObtenerValor("foco_ccod")
									v_nprograma		= f_solicitado.ObtenerValor("prog_ccod")
									v_nproyecto 	= f_solicitado.ObtenerValor("proye_ccod")
									v_nobjetivo 	= f_solicitado.ObtenerValor("obje_ccod")
									v_nTPresu		= f_solicitado.ObtenerValor("t_presupuesto")
									v_TPresu		= ""
									if(v_nTPresu = "1") then v_TPresu = "Primario" end if
									if(v_nTPresu = "2") then v_TPresu = "Secundario" end if

									v_eje 		= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
									v_foco		= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&v_nfoco&"")
									v_programa	= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&v_nprograma&"")
									v_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
									v_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&v_nobjetivo&"")
									'cadenaTabla()
									va_nTPresu		= f_aprobados.ObtenerValor("t_presupuesto")
									va_neje 		= f_aprobados.ObtenerValor("eje_ccod")
									va_nfoco		= f_aprobados.ObtenerValor("foco_ccod")
									va_nprograma	= f_aprobados.ObtenerValor("prog_ccod")
									va_nproyecto 	= f_aprobados.ObtenerValor("proye_ccod")
									va_nobjetivo 	= f_aprobados.ObtenerValor("obje_ccod")

									va_TPresu		= ""
									if(va_nTPresu = "1") then va_TPresu = "Primario" end if
									if(va_nTPresu = "2") then va_TPresu = "Secundario" end if
									va_eje 			= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
									va_foco			= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&v_nfoco&"")
									va_programa		= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&v_nprograma&"")
									va_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
									va_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&v_nobjetivo&"")
									'----------------------------------------------
									%>
									<tr bordercolor='#999999'>
									  <td><font color="#0033FF"><%f_solicitado.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_solicitado.DibujaCampo("ccau_tdesc")%></td>
									  <td><%=f_solicitado.DibujaCampo("nombremes")%></td>
									  <td><%=f_solicitado.DibujaCampo("ccau_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("v_aprox")%></td>
									  <td><%=v_TPresu%></td>
									  <td><%=f_solicitado.DibujaCampo("esol_tdesc")%></td>
									  <td><a href="javascript:CambiaEstado(7,<%f_solicitado.DibujaCampo("esol_ccod")%>,<%f_solicitado.DibujaCampo("ccau_ncorr")%>);"><%f_solicitado.DibujaCampo("accion")%></a></td>
									</tr>
									 <%
									 wend%>
									 <%if f_solicitado.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="13" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
									 <% end if%>
								</table>
								<br/>
								<font>Aceptadas</font>
								<br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'>
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripción</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="9%">Valor Aprox.</th>
									  <th width="9%">Tipo gasto</th>
									  <th width="18%">Estado</th>
									</tr>
									<%
									while f_aprobados.Siguiente
									%>
									<tr bordercolor='#999999'>
									  <td><font color="#0033FF"><%f_aprobados.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_aprobados.DibujaCampo("ccau_tdesc")%></td>
									  <td><%=f_aprobados.DibujaCampo("nombremes")%></td>
									  <td><%=f_aprobados.DibujaCampo("ccau_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("v_aprox")%></td>
									  <td><%=v_TPresu%></td>
									  <td><%=f_aprobados.DibujaCampo("esol_tdesc")%></td>
									</tr>
									 <%wend%>
									 <%if f_aprobados.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="12" align="center">No se encontraron solicitudes aprobadas </td></tr>
									 <% end if%>
								</table>

							<% case 8:	%>
<%
'------------------------------>>
' 	inicio DAE
'------------------------------>>
%>
								<font>Departamento de asuntos estudiantiles</font>
								<br/>

								<form name="solicitud">
								<input type="hidden" name="area_ccod" value="<%=area_ccod%>">
								<input type="hidden" name="tipo" value="8">
								<table border="1" width="%" bordercolorlight="#CCCCCC" bordercolordark="#CCCCCC">
								<tr>
									<td valign="top">
										<table>
											<%
											//agregaEjes() //agrega los combos
											%>
										</table>
									</td>
									<td>
											<table border="1" width="%" bordercolorlight="#CCCCCC" bordercolordark="#CCCCCC">
											<tr>
												<td colspan="3" align="center"><strong>Solicitar</strong></td>
											</tr>
											<tr>
												<td><strong>Concepto</strong></td><td>:</td><td><%=f_concepto.DibujaCampo("ccen_ccod")%></td>
											</tr>
											<tr>
												<td><strong>Descripción</strong></td><td>:</td><td>
												<textarea name="descripcion" cols="40" rows="5"></textarea>
												<!--<input type="text" name="descripcion" size="50">-->
												</td>
											</tr>
											<tr>
												<td><strong>Cantidad</strong></td><td>:</td><td><input type="text" value="1" name="cantidad" size="4" maxlength="4" onClick="this.select();" > Unidades</td>
											</tr>
											<tr><%htmlValorEstimado()%></tr>
											<tr><%htmlTipoPresupuesto()%></tr>
											<tr>
												<td><strong>Mes</strong></td><td>:</td><td>
												<select name="mes">
													<option value="1">ENERO</option>
													<option value="2">FEBRERO</option>
													<option value="3">MARZO</option>
													<option value="4">ABRIL</option>
													<option value="5">MAYO</option>
													<option value="6">JUNIO</option>
													<option value="7">JULIO</option>
													<option value="8">AGOSTO</option>
													<option value="9">SEPTIEMBRE</option>
													<option value="10">OCTUBRE</option>
													<option value="11">NOVIEMBRE</option>
													<option value="12">DICIEMBRE</option>
												</select></td>
											</tr>
											<tr>
												<td colspan="3" align="center"><% botonera.DibujaBoton("agrega_concepto") %></td>
											</tr>
										</table>
									</td>
								</tr>
								</table>
								</form>
								<br/>
								<font>Pendientes</font>
								<br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'>
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripción</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="9%">Valor Aprox.</th>
									  <th width="9%">Tipo gasto</th>
									  <th width="18%">Estado</th>
									  <th width="18%">Accion</th>
									</tr>
									<%
									while f_solicitado.Siguiente
									'----------------------------------------------
									v_neje 			= f_solicitado.ObtenerValor("eje_ccod")
									v_nfoco			= f_solicitado.ObtenerValor("foco_ccod")
									v_nprograma		= f_solicitado.ObtenerValor("prog_ccod")
									v_nproyecto 	= f_solicitado.ObtenerValor("proye_ccod")
									v_nobjetivo 	= f_solicitado.ObtenerValor("obje_ccod")
									v_nTPresu		= f_solicitado.ObtenerValor("t_presupuesto")
									v_TPresu		= ""
									if(v_nTPresu = "1") then v_TPresu = "Primario" end if
									if(v_nTPresu = "2") then v_TPresu = "Secundario" end if

									v_eje 		= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
									v_foco		= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&v_nfoco&"")
									v_programa	= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&v_nprograma&"")
									v_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
									v_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&v_nobjetivo&"")
									'cadenaTabla()
									va_nTPresu		= f_aprobados.ObtenerValor("t_presupuesto")
									va_neje 		= f_aprobados.ObtenerValor("eje_ccod")
									va_nfoco		= f_aprobados.ObtenerValor("foco_ccod")
									va_nprograma	= f_aprobados.ObtenerValor("prog_ccod")
									va_nproyecto 	= f_aprobados.ObtenerValor("proye_ccod")
									va_nobjetivo 	= f_aprobados.ObtenerValor("obje_ccod")

									va_TPresu		= ""
									if(va_nTPresu = "1") then va_TPresu = "Primario" end if
									if(va_nTPresu = "2") then va_TPresu = "Secundario" end if
									va_eje 			= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
									va_foco			= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&v_nfoco&"")
									va_programa		= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&v_nprograma&"")
									va_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
									va_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&v_nobjetivo&"")
									'----------------------------------------------
									%>
									<tr bordercolor='#999999'>
									  <td><font color="#0033FF"><%f_solicitado.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_solicitado.DibujaCampo("ccau_tdesc")%></td>
									  <td><%=f_solicitado.DibujaCampo("nombremes")%></td>
									  <td><%=f_solicitado.DibujaCampo("ccau_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("v_aprox")%></td>
									  <td><%=v_TPresu%></td>
									  <td><%=f_solicitado.DibujaCampo("esol_tdesc")%></td>
									  <td><a href="javascript:CambiaEstado(8,<%f_solicitado.DibujaCampo("esol_ccod")%>,<%f_solicitado.DibujaCampo("ccau_ncorr")%>);"><%f_solicitado.DibujaCampo("accion")%></a></td>
									</tr>
									 <%
									 wend%>
									 <%if f_solicitado.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="13" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
									 <% end if%>
								</table>
								<br/>
								<font>Aceptadas</font>
								<br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'>
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripción</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="9%">Valor Aprox.</th>
									  <th width="9%">Tipo gasto</th>
									  <th width="18%">Estado</th>
									</tr>
									<%
									while f_aprobados.Siguiente
									%>
									<tr bordercolor='#999999'>
									  <td><font color="#0033FF"><%f_aprobados.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_aprobados.DibujaCampo("ccau_tdesc")%></td>
									  <td><%=f_aprobados.DibujaCampo("nombremes")%></td>
									  <td><%=f_aprobados.DibujaCampo("ccau_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("v_aprox")%></td>
									  <td><%=v_TPresu%></td>
									  <td><%=f_aprobados.DibujaCampo("esol_tdesc")%></td>
									</tr>
									 <%wend%>
									 <%if f_aprobados.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="12" align="center">No se encontraron solicitudes aprobadas </td></tr>
									 <% end if%>
								</table>

							<% case 9:	%>
<%
'------------------------------------->>
' 	inicio aseguramiento de la calidad
'------------------------------------->>
%>
								<font>Dirección de analisis y aseguramiento de la calidad</font>
								<br/>

								<form name="solicitud">
								<input type="hidden" name="area_ccod" value="<%=area_ccod%>">
								<input type="hidden" name="tipo" value="9">
								<table border="1" width="%" bordercolorlight="#CCCCCC" bordercolordark="#CCCCCC">
								<tr>
									<td valign="top">
										<table>
											<%
											//agregaEjes() //agrega los combos
											%>
										</table>
									</td>
									<td>
											<table border="1" width="%" bordercolorlight="#CCCCCC" bordercolordark="#CCCCCC">
											<tr>
												<td colspan="3" align="center"><strong>Solicitar</strong></td>
											</tr>
											<tr>
												<td><strong>Concepto</strong></td><td>:</td><td><%=f_concepto.DibujaCampo("ccen_ccod")%></td>
											</tr>
											<tr>
												<td><strong>Descripción</strong></td><td>:</td><td>
												<textarea name="descripcion" cols="40" rows="5"></textarea>
												<!--<input type="text" name="descripcion" size="50">-->
												</td>
											</tr>
											<tr>
												<td><strong>Cantidad</strong></td><td>:</td><td><input type="text" value="1" name="cantidad" size="4" maxlength="4" onClick="this.select();" > Unidades</td>
											</tr>
											<tr><%htmlValorEstimado()%></tr>
											<tr><%htmlTipoPresupuesto()%></tr>
											<tr>
												<td><strong>Mes</strong></td><td>:</td><td>
												<select name="mes">
													<option value="1">ENERO</option>
													<option value="2">FEBRERO</option>
													<option value="3">MARZO</option>
													<option value="4">ABRIL</option>
													<option value="5">MAYO</option>
													<option value="6">JUNIO</option>
													<option value="7">JULIO</option>
													<option value="8">AGOSTO</option>
													<option value="9">SEPTIEMBRE</option>
													<option value="10">OCTUBRE</option>
													<option value="11">NOVIEMBRE</option>
													<option value="12">DICIEMBRE</option>
												</select></td>
											</tr>
											<tr>
												<td colspan="3" align="center"><% botonera.DibujaBoton("agrega_concepto") %></td>
											</tr>
										</table>
									</td>
								</tr>
								</table>
								</form>
								<br/>
								<font>Pendientes</font>
								<br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'>
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripción</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="9%">Valor Aprox.</th>
									  <th width="9%">Tipo gasto</th>
									  <th width="18%">Estado</th>
									  <th width="18%">Accion</th>
									</tr>
									<%
									while f_solicitado.Siguiente
									'----------------------------------------------
									v_neje 			= f_solicitado.ObtenerValor("eje_ccod")
									v_nfoco			= f_solicitado.ObtenerValor("foco_ccod")
									v_nprograma		= f_solicitado.ObtenerValor("prog_ccod")
									v_nproyecto 	= f_solicitado.ObtenerValor("proye_ccod")
									v_nobjetivo 	= f_solicitado.ObtenerValor("obje_ccod")
									v_nTPresu		= f_solicitado.ObtenerValor("t_presupuesto")
									v_TPresu		= ""
									if(v_nTPresu = "1") then v_TPresu = "Primario" end if
									if(v_nTPresu = "2") then v_TPresu = "Secundario" end if

									v_eje 		= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
									v_foco		= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&v_nfoco&"")
									v_programa	= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&v_nprograma&"")
									v_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
									v_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&v_nobjetivo&"")
									'cadenaTabla()
									va_nTPresu		= f_aprobados.ObtenerValor("t_presupuesto")
									va_neje 		= f_aprobados.ObtenerValor("eje_ccod")
									va_nfoco		= f_aprobados.ObtenerValor("foco_ccod")
									va_nprograma	= f_aprobados.ObtenerValor("prog_ccod")
									va_nproyecto 	= f_aprobados.ObtenerValor("proye_ccod")
									va_nobjetivo 	= f_aprobados.ObtenerValor("obje_ccod")

									va_TPresu		= ""
									if(va_nTPresu = "1") then va_TPresu = "Primario" end if
									if(va_nTPresu = "2") then va_TPresu = "Secundario" end if
									va_eje 			= conexion.consultaUno("select isnull(eje_tdesc, 'Sin eje') from eje where eje_ccod = "&v_neje)
									va_foco			= conexion.consultaUno("select isnull(foco_tdesc, 'Sin foco') from foco where foco_ccod = "&v_nfoco&"")
									va_programa		= conexion.consultaUno("select isnull(prog_tdesc, 'Sin programa') from programa where prog_ccod = "&v_nprograma&"")
									va_proyecto 	= conexion.consultaUno("select isnull(proye_tdesc, 'Sin proyecto') from proyecto where proye_ccod = "&v_nproyecto&"")
									va_objetivo 	= conexion.consultaUno("select isnull(obje_tdesc, 'Sin objetivo') from objetivo where obje_ccod = "&v_nobjetivo&"")
									'----------------------------------------------
									%>
									<tr bordercolor='#999999'>
									  <td><font color="#0033FF"><%f_solicitado.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_solicitado.DibujaCampo("ccau_tdesc")%></td>
									  <td><%=f_solicitado.DibujaCampo("nombremes")%></td>
									  <td><%=f_solicitado.DibujaCampo("ccau_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("v_aprox")%></td>
									  <td><%=v_TPresu%></td>
									  <td><%=f_solicitado.DibujaCampo("esol_tdesc")%></td>
									  <td><a href="javascript:CambiaEstado(9,<%f_solicitado.DibujaCampo("esol_ccod")%>,<%f_solicitado.DibujaCampo("ccau_ncorr")%>);"><%f_solicitado.DibujaCampo("accion")%></a></td>
									</tr>
									 <%
									 wend%>
									 <%if f_solicitado.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="13" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
									 <% end if%>
								</table>
								<br/>
								<font>Aceptadas</font>
								<br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'>
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripción</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="9%">Valor Aprox.</th>
									  <th width="9%">Tipo gasto</th>
									  <th width="18%">Estado</th>
									</tr>
									<%
									while f_aprobados.Siguiente
									%>
									<tr bordercolor='#999999'>
									  <td><font color="#0033FF"><%f_aprobados.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_aprobados.DibujaCampo("ccau_tdesc")%></td>
									  <td><%=f_aprobados.DibujaCampo("nombremes")%></td>
									  <td><%=f_aprobados.DibujaCampo("ccau_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("v_aprox")%></td>
									  <td><%=v_TPresu%></td>
									  <td><%=f_aprobados.DibujaCampo("esol_tdesc")%></td>
									</tr>
									 <%wend%>
									 <%if f_aprobados.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="12" align="center">No se encontraron solicitudes aprobadas </td></tr>
									 <% end if%>
								</table>

							<% end select %>
							<br/>
							<br/>
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

												<td width="100%">
													<%
													botonera.agregabotonparam "excel_solicitud_central", "url", "solicitud_central_excel.asp?nro="&nro_t&"&area="&area_ccod&"&anio="&v_prox_anio
													botonera.DibujaBoton ("excel_solicitud_central")
													%>
												</td>

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
                <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                <td width="100" bgcolor="#D8D8DE"><table width="100%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr>
                      <td ><% botonera.DibujaBoton ("lanzadera") %> </td>
                    </tr>
                  </table>
                </td>
                <td width="262" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
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
