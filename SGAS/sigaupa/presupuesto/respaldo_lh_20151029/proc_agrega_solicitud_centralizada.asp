<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

v_area_ccod			=	request.Form("area_ccod")
v_ccen_ccod			=	request.Form("busqueda[0][ccen_ccod]")
v_descripcion		=	request.Form("descripcion")
v_cantidad			=	request.Form("cantidad")
v_tipo				=	request.Form("tipo")
v_mes				=	request.Form("mes")
v_sede				= 	request.Form("sede_ccod")
'-------------------------------------------------Modifica 16/10/2014
v_eje_ccod			=	request.Form("selCombo")
v_foco_ccod			=	request.Form("selCombo2")
v_prog_ccod			=	request.Form("selCombo3")
v_proye_ccod		=	request.Form("selCombo4")
v_obje_ccod			=	request.Form("selCombo5")
v_vAprox			=	request.Form("vAprox")
v_t_presupuesto		=	request.Form("tpresupuesto")

v_vAprox			=	replace(v_vAprox, ".", "")

set conexion2 = new CConexion2
conexion2.Inicializar "upacifico"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()

v_anio_actual	= conexion2.ConsultaUno("select year(getdate())")
v_prox_anio	=	v_anio_actual+1
'v_cod_anio	=	v_anio_actual

if v_area_ccod <>"" and v_ccen_ccod <>"" and v_descripcion <> "" and v_cantidad <> "" then
	
	select case (v_tipo)
	case 1:
			v_ccau_ncorr = conexion2.ConsultaUno("exec presupuesto_upa.dbo.obtenersecuencia 'audiovisual'")						
			sql_ingreso_solicitud= ""& vbCrLf &_
									"insert into presupuesto_upa.protic.centralizar_solicitud_audiovisual "& vbCrLf &_
									"            (mes_ccod,                                               "& vbCrLf &_
									"             tpre_ccod,                                              "& vbCrLf &_
									"             ccau_ncorr,                                             "& vbCrLf &_
									"             ccau_tdesc,                                             "& vbCrLf &_
									"             ccau_ncantidad,                                         "& vbCrLf &_
									"             area_ccod,                                              "& vbCrLf &_
									"             anio_ccod,                                              "& vbCrLf &_
									"             esol_ccod,                                              "& vbCrLf &_
									"             ccen_ccod,                                              "& vbCrLf &_
									"             eje_ccod,                                               "& vbCrLf &_
									"             foco_ccod,                                              "& vbCrLf &_
									"             prog_ccod,                                              "& vbCrLf &_
									"             proye_ccod,                                             "& vbCrLf &_
									"             obje_ccod,                                              "& vbCrLf &_
									"             v_aprox,                                                "& vbCrLf &_
									"             t_presupuesto,                                          "& vbCrLf &_
									"             audi_tusuario,                                          "& vbCrLf &_
									"             audi_fmodificacion)                                     "& vbCrLf &_
									"values      ("&v_mes&",                                              "& vbCrLf &_
									"             "&v_tipo&",                                             "& vbCrLf &_
									"             "&v_ccau_ncorr&",                                       "& vbCrLf &_
									"             '"&v_descripcion&"',                                    "& vbCrLf &_
									"             "&v_cantidad&",                                         "& vbCrLf &_
									"             "&v_area_ccod&",                                        "& vbCrLf &_
									"             "&v_prox_anio&",                                        "& vbCrLf &_
									"             1,                                                      "& vbCrLf &_
									"             '"&v_ccen_ccod&"',                                      "& vbCrLf &_
									"             '"&v_eje_ccod&"',                                       "& vbCrLf &_
									"             '"&v_foco_ccod&"',                                      "& vbCrLf &_
									"             '"&v_prog_ccod&"',                                      "& vbCrLf &_
									"             '"&v_proye_ccod&"',                                     "& vbCrLf &_
									"             '"&v_obje_ccod&"',                                      "& vbCrLf &_
									"             '"&v_vAprox&"',                                         "& vbCrLf &_
									"             '"&v_t_presupuesto&"',                                  "& vbCrLf &_
									"             '"&v_usuario&"',                                        "& vbCrLf &_
									"             Getdate())                                              "
'response.write("<pre>"&sql_ingreso_solicitud&"</pre>")	
'response.End()								
	case 2:
			v_ccbi_ncorr = conexion2.ConsultaUno("exec presupuesto_upa.dbo.obtenersecuencia 'biblioteca'")						
			sql_ingreso_solicitud= ""& vbCrLf &_
									"insert into presupuesto_upa.protic.centralizar_solicitud_biblioteca "& vbCrLf &_
									"            (mes_ccod,                                              "& vbCrLf &_
									"             tpre_ccod,                                             "& vbCrLf &_
									"             ccbi_ncorr,                                            "& vbCrLf &_
									"             ccbi_tdesc,                                            "& vbCrLf &_
									"             ccbi_ncantidad,                                        "& vbCrLf &_
									"             area_ccod,                                             "& vbCrLf &_
									"             anio_ccod,                                             "& vbCrLf &_
									"             esol_ccod,                                             "& vbCrLf &_
									"             ccen_ccod,                                             "& vbCrLf &_
									"             eje_ccod,                                               "& vbCrLf &_
									"             foco_ccod,                                               "& vbCrLf &_
									"             prog_ccod,                                               "& vbCrLf &_
									"             proye_ccod,                                               "& vbCrLf &_
									"             obje_ccod,                                             "& vbCrLf &_
									"             v_aprox,                                               "& vbCrLf &_
									"             t_presupuesto,                                         "& vbCrLf &_									
									"             audi_tusuario,                                         "& vbCrLf &_
									"             audi_fmodificacion)                                    "& vbCrLf &_
									"values      ("&v_mes&",                                             "& vbCrLf &_
									"             "&v_tipo&",                                            "& vbCrLf &_
									"             "&v_ccbi_ncorr&",                                      "& vbCrLf &_
									"             '"&v_descripcion&"',                                   "& vbCrLf &_
									"             "&v_cantidad&",                                        "& vbCrLf &_
									"             "&v_area_ccod&",                                       "& vbCrLf &_
									"             "&v_prox_anio&",                                       "& vbCrLf &_
									"             1,                                                     "& vbCrLf &_
									"             '"&v_ccen_ccod&"',                                     "& vbCrLf &_
									"             '"&v_eje_ccod&"',                                       "& vbCrLf &_
									"             '"&v_foco_ccod&"',                                       "& vbCrLf &_
									"             '"&v_prog_ccod&"',                                       "& vbCrLf &_
									"             '"&v_proye_ccod&"',                                       "& vbCrLf &_
									"             '"&v_obje_ccod&"',                                     "& vbCrLf &_
									"             '"&v_vAprox&"',                                        "& vbCrLf &_
									"             '"&v_t_presupuesto&"',                                 "& vbCrLf &_									
									"             '"&v_usuario&"',                                       "& vbCrLf &_
									"             Getdate()) 				                             "
	case 3:
			v_ccco_ncorr = conexion2.ConsultaUno("exec presupuesto_upa.dbo.obtenersecuencia 'computacion'")						
			sql_ingreso_solicitud=""& vbCrLf &_
									"insert into presupuesto_upa.protic.centralizar_solicitud_computacion "& vbCrLf &_
									"            (mes_ccod,                                               "& vbCrLf &_
									"             tpre_ccod,                                              "& vbCrLf &_
									"             ccco_ncorr,                                             "& vbCrLf &_
									"             ccco_tdesc,                                             "& vbCrLf &_
									"             ccco_ncantidad,                                         "& vbCrLf &_
									"             area_ccod,                                              "& vbCrLf &_
									"             anio_ccod,                                              "& vbCrLf &_
									"             esol_ccod,                                              "& vbCrLf &_
									"             ccen_ccod,                                              "& vbCrLf &_
									"             eje_ccod,                                               "& vbCrLf &_
									"             foco_ccod,                                               "& vbCrLf &_
									"             prog_ccod,                                               "& vbCrLf &_
									"             proye_ccod,                                               "& vbCrLf &_
									"             obje_ccod,                                             "& vbCrLf &_
									"             v_aprox,                                                "& vbCrLf &_
									"             t_presupuesto,                                          "& vbCrLf &_									
									"             audi_tusuario,                                          "& vbCrLf &_
									"             audi_fmodificacion)                                     "& vbCrLf &_
									"values      ("&v_mes&",                                              "& vbCrLf &_
									"             "&v_tipo&",                                             "& vbCrLf &_
									"             "&v_ccco_ncorr&",                                       "& vbCrLf &_
									"             '"&v_descripcion&"',                                    "& vbCrLf &_
									"             "&v_cantidad&",                                         "& vbCrLf &_
									"             "&v_area_ccod&",                                        "& vbCrLf &_
									"             "&v_prox_anio&",                                        "& vbCrLf &_
									"             1,                                                      "& vbCrLf &_
									"             '"&v_ccen_ccod&"',                                      "& vbCrLf &_
									"             '"&v_eje_ccod&"',                                       "& vbCrLf &_
									"             '"&v_foco_ccod&"',                                       "& vbCrLf &_
									"             '"&v_prog_ccod&"',                                       "& vbCrLf &_
									"             '"&v_proye_ccod&"',                                       "& vbCrLf &_
									"             '"&v_obje_ccod&"',                                     "& vbCrLf &_
									"             '"&v_vAprox&"',                                         "& vbCrLf &_
									"             '"&v_t_presupuesto&"',                                  "& vbCrLf &_									
									"             '"&v_usuario&"',                                        "& vbCrLf &_
									"             Getdate())                                              "
			
	case 4:
			v_ccsg_ncorr = conexion2.ConsultaUno("exec presupuesto_upa.dbo.obtenersecuencia 'servicios_generales'")						
			sql_ingreso_solicitud=""& vbCrLf &_ 
									"insert into presupuesto_upa.protic.centralizar_solicitud_servicios_generales "& vbCrLf &_
									"            (sede_ccod,                                                      "& vbCrLf &_
									"             mes_ccod,                                                       "& vbCrLf &_
									"             tpre_ccod,                                                      "& vbCrLf &_
									"             ccsg_ncorr,                                                     "& vbCrLf &_
									"             ccsg_tdesc,                                                     "& vbCrLf &_
									"             ccsg_ncantidad,                                                 "& vbCrLf &_
									"             area_ccod,                                                      "& vbCrLf &_
									"             anio_ccod,                                                      "& vbCrLf &_
									"             esol_ccod,                                                      "& vbCrLf &_
									"             ccen_ccod,                                                      "& vbCrLf &_
									"             eje_ccod,                                               "& vbCrLf &_
									"             foco_ccod,                                               "& vbCrLf &_
									"             prog_ccod,                                               "& vbCrLf &_
									"             proye_ccod,                                               "& vbCrLf &_
									"             obje_ccod,                                             "& vbCrLf &_
									"             v_aprox,                                                		  "& vbCrLf &_
									"             t_presupuesto,                                          		  "& vbCrLf &_									
									"             audi_tusuario,                                                  "& vbCrLf &_
									"             audi_fmodificacion)                                             "& vbCrLf &_
									"values      ("&v_sede&",                                                     "& vbCrLf &_
									"             "&v_mes&",                                                      "& vbCrLf &_
									"             "&v_tipo&",                                                     "& vbCrLf &_
									"             "&v_ccsg_ncorr&",                                               "& vbCrLf &_
									"             '"&v_descripcion&"',                                            "& vbCrLf &_
									"             "&v_cantidad&",                                                 "& vbCrLf &_
									"             "&v_area_ccod&",                                                "& vbCrLf &_
									"             "&v_prox_anio&",                                                "& vbCrLf &_
									"             1,                                                              "& vbCrLf &_
									"             '"&v_ccen_ccod&"',                                              "& vbCrLf &_
									"             '"&v_eje_ccod&"',                                       "& vbCrLf &_
									"             '"&v_foco_ccod&"',                                       "& vbCrLf &_
									"             '"&v_prog_ccod&"',                                       "& vbCrLf &_
									"             '"&v_proye_ccod&"',                                       "& vbCrLf &_
									"             '"&v_obje_ccod&"',                                     "& vbCrLf &_
									"             '"&v_vAprox&"',                                         		  "& vbCrLf &_
									"             '"&v_t_presupuesto&"',                                  		  "& vbCrLf &_										
									"             '"&v_usuario&"',                                                "& vbCrLf &_
									"             Getdate())                                                      "

	case 5:
			v_ccpe_ncorr = conexion2.ConsultaUno("exec presupuesto_upa.dbo.obtenersecuencia 'personal'")						
			sql_ingreso_solicitud=""& vbCrLf &_  
									"insert into presupuesto_upa.protic.centralizar_solicitud_personal "& vbCrLf &_
									"            (mes_ccod,                                            "& vbCrLf &_
									"             tpre_ccod,                                           "& vbCrLf &_
									"             ccpe_ncorr,                                          "& vbCrLf &_
									"             ccpe_tdesc,                                          "& vbCrLf &_
									"             ccpe_ncantidad,                                      "& vbCrLf &_
									"             area_ccod,                                           "& vbCrLf &_
									"             anio_ccod,                                           "& vbCrLf &_
									"             esol_ccod,                                           "& vbCrLf &_
									"             ccen_ccod,                                           "& vbCrLf &_
									"             eje_ccod,                                            "& vbCrLf &_
									"             foco_ccod,                                           "& vbCrLf &_
									"             prog_ccod,                                               "& vbCrLf &_
									"             proye_ccod,                                               "& vbCrLf &_
									"             obje_ccod,                                             "& vbCrLf &_
									"             v_aprox,                                             "& vbCrLf &_
									"             t_presupuesto,                                       "& vbCrLf &_
									"             audi_tusuario,                                       "& vbCrLf &_
									"             audi_fmodificacion)                                  "& vbCrLf &_
									"values      ("&v_mes&",                                           "& vbCrLf &_
									"             "&v_tipo&",                                          "& vbCrLf &_
									"             "&v_ccpe_ncorr&",                                    "& vbCrLf &_
									"             '"&v_descripcion&"',                                 "& vbCrLf &_
									"             "&v_cantidad&",                                      "& vbCrLf &_
									"             "&v_area_ccod&",                                     "& vbCrLf &_
									"             "&v_prox_anio&",                                     "& vbCrLf &_
									"             1,                                                   "& vbCrLf &_
									"             '"&v_ccen_ccod&"',                                   "& vbCrLf &_
									"             '"&v_eje_ccod&"',                                       "& vbCrLf &_
									"             '"&v_foco_ccod&"',                                       "& vbCrLf &_
									"             '"&v_prog_ccod&"',                                       "& vbCrLf &_
									"             '"&v_proye_ccod&"',                                       "& vbCrLf &_
									"             '"&v_obje_ccod&"',                                     "& vbCrLf &_
									"             '"&v_vAprox&"',                                      "& vbCrLf &_
									"             '"&v_t_presupuesto&"',                               "& vbCrLf &_	
									"             '"&v_usuario&"',                                     "& vbCrLf &_
									"             Getdate()) 			                               "
case 6:
			v_ccau_ncorr = conexion2.ConsultaUno("exec presupuesto_upa.dbo.obtenersecuencia 'audiovisual'")						
			sql_ingreso_solicitud= ""& vbCrLf &_
									"insert into presupuesto_upa.protic.centralizar_solicitud_dir_docencia "& vbCrLf &_
									"            (mes_ccod,                                               "& vbCrLf &_
									"             tpre_ccod,                                              "& vbCrLf &_
									"             ccau_ncorr,                                             "& vbCrLf &_
									"             ccau_tdesc,                                             "& vbCrLf &_
									"             ccau_ncantidad,                                         "& vbCrLf &_
									"             area_ccod,                                              "& vbCrLf &_
									"             anio_ccod,                                              "& vbCrLf &_
									"             esol_ccod,                                              "& vbCrLf &_
									"             ccen_ccod,                                              "& vbCrLf &_
									"             eje_ccod,                                               "& vbCrLf &_
									"             foco_ccod,                                               "& vbCrLf &_
									"             prog_ccod,                                               "& vbCrLf &_
									"             proye_ccod,                                               "& vbCrLf &_
									"             obje_ccod,                                             "& vbCrLf &_
									"             v_aprox,                                                "& vbCrLf &_
									"             t_presupuesto,                                          "& vbCrLf &_
									"             audi_tusuario,                                          "& vbCrLf &_
									"             audi_fmodificacion)                                     "& vbCrLf &_
									"values      ("&v_mes&",                                              "& vbCrLf &_
									"             "&v_tipo&",                                             "& vbCrLf &_
									"             "&v_ccau_ncorr&",                                       "& vbCrLf &_
									"             '"&v_descripcion&"',                                    "& vbCrLf &_
									"             "&v_cantidad&",                                         "& vbCrLf &_
									"             "&v_area_ccod&",                                        "& vbCrLf &_
									"             "&v_prox_anio&",                                        "& vbCrLf &_
									"             1,                                                      "& vbCrLf &_
									"             '"&v_ccen_ccod&"',                                      "& vbCrLf &_
									"             '"&v_eje_ccod&"',                                       "& vbCrLf &_
									"             '"&v_foco_ccod&"',                                       "& vbCrLf &_
									"             '"&v_prog_ccod&"',                                       "& vbCrLf &_
									"             '"&v_proye_ccod&"',                                       "& vbCrLf &_
									"             '"&v_obje_ccod&"',                                     "& vbCrLf &_
									"             '"&v_vAprox&"',                                         "& vbCrLf &_
									"             '"&v_t_presupuesto&"',                                  "& vbCrLf &_
									"             '"&v_usuario&"',                                        "& vbCrLf &_
									"             Getdate())                                              "									
end select
	v_estado_transaccion=conexion2.ejecutaS(sql_ingreso_solicitud)	
end if

'response.Write("<pre>"&sql_ingreso_solicitud&"</pre>")
'response.End()


if v_estado_transaccion=false  then
	'response.Write("<br>Todo MAL")
	session("mensaje_error")="La solicitud no pudo ser ingresada correctamente.\nAsegurece de ingresar la informacion correcta y vuelva a intentarlo."
else	
	'response.Write("<br>Todo bien")
	session("mensaje_error")="La solicitud fue ingresada correctamente."
end if
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>