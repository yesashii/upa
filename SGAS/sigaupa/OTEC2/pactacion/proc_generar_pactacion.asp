<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

'for each x in request.Form
'	response.Write(x&"->"&request.Form(x)&"<br>")
'next
'response.End()


q_pers_ncorr = request.Form("pers_ncorr")
q_dgso_ncorr = request.Form("dgso_ncorr")
q_fpot_ccod = request.Form("fpot_ccod")
q_num_oc = request.Form("num_oc")


set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set variables = new CVariables
variables.ProcesaForm

set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede

Usuario = negocio.ObtenerUsuario()
v_mcaj_ncorr = cajero.ObtenerCajaAbierta
v_comp_ndocto = variables.ObtenerValor("detalles_pactacion", 0, "comp_ndocto")
'response.Write("comp_ndocto "&v_comp_ndocto)
'response.End()

'conexion.EstadoTransaccion false

'-----------------------------------------------------------------------------------------------------------
set f_detalles_pactacion = new CFormulario
f_detalles_pactacion.Carga_Parametros "agregar_cargo_pactacion.xml", "detalles_pactacion"
f_detalles_pactacion.Inicializar conexion
f_detalles_pactacion.ProcesaForm
f_detalles_pactacion.MantieneTablas false

'response.End()


'conexion.estadotransaccion false

'-----------------------------------------------------------------------------------------------------------
sentencia = "execute genera_pactacion '" & v_comp_ndocto & "','" & negocio.ObtenerSede & "','" & negocio.ObtenerPeriodoAcademico("POSTULACION") & "','" & v_mcaj_ncorr & "'"
'response.Write(sentencia)

conexion.EstadoTransaccion conexion.EjecutaP(sentencia)
'response.Write("<br><b>Estado 0:</b>"&conexion.ObtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'response.End()


'###################################################################################
		sql_ingreso=" select c.ingr_nfolio_referencia " & vbCrLf &_   
					" 	from sim_pactaciones a " & vbCrLf &_
					"	join abonos b " & vbCrLf &_
					"		on a.comp_ndocto = b.comp_ndocto " & vbCrLf &_      
					"		and a.inst_ccod = b.inst_ccod  " & vbCrLf &_     
					"		and a.tcom_ccod = b.tcom_ccod " & vbCrLf &_
					"  join ingresos c " & vbCrLf &_
					"		on b.ingr_ncorr = c.ingr_ncorr " & vbCrLf &_ 
					"  left outer join detalle_ingresos d  " & vbCrLf &_
					"		on c.ingr_ncorr= d.ingr_ncorr " & vbCrLf &_ 
					"		--and d.ting_ccod not in (5) " & vbCrLf &_					   
					"  where cast(a.comp_ndocto as varchar) = '" & v_comp_ndocto & "' " & vbCrLf &_    
					"		and b.tcom_ccod in (7) " & vbCrLf &_      
					"		and c.ting_ccod=33 " & vbCrLf &_ 
					"		and not exists (select 1 from detalle_ingresos where ting_ccod=5 and ingr_ncorr=c.ingr_ncorr) " & vbCrLf &_ 
					" group by c.ingr_nfolio_referencia "
	 
	v_folio_referencia   =conexion.consultaUno(sql_ingreso)
'###################################################################################

select case q_fpot_ccod
		case "1"
			' Forma pago : Personas Natural
			' cambiar estado a "Matriculado"
			sql_actualiza_estado= "update postulacion_otec set epot_ccod=4, comp_ndocto='" & v_comp_ndocto & "', audi_fmodificacion=getdate() " & vbCrLf &_ 
								" where pote_ncorr in ( " & vbCrLf &_ 
								" Select pote_ncorr " & vbCrLf &_
								"  from postulacion_otec a, datos_generales_secciones_otec b ,   " & vbCrLf &_  
								"  ofertas_otec c , diplomados_cursos d, personas e  " & vbCrLf &_
								"  where cast(e.pers_ncorr as varchar)= '"&q_pers_ncorr&"'  " & vbCrLf &_
								"  and a.dgso_ncorr="&q_dgso_ncorr&"  " & vbCrLf &_   
								"  and a.pers_ncorr=e.pers_ncorr  " & vbCrLf &_   
								"  and a.dgso_ncorr=b.dgso_ncorr  " & vbCrLf &_  
								"  and b.dgso_ncorr=c.dgso_ncorr  " & vbCrLf &_  
								"  and c.dcur_ncorr=d.dcur_ncorr  " & vbCrLf &_  
								"  and a.epot_ccod=2   " & vbCrLf &_
								" )  "
				
			sql_inserta_relacion=" Insert into postulantes_cargos_otec " & vbCrLf &_  
									" Select pote_ncorr,'"& v_comp_ndocto &"' as comp_ndocto, " & vbCrLf &_  
									" "&q_pers_ncorr&" as pers_ncorr_institucion,1 as tipo_institucion, " & vbCrLf &_
									" '"&Usuario&" crea cargo' as audi_tusuario, getdate() as audi_fmodificacion " & vbCrLf &_
									"  from postulacion_otec a, datos_generales_secciones_otec b ,   " & vbCrLf &_  
									"  ofertas_otec c , diplomados_cursos d, personas e  " & vbCrLf &_
									"  where cast(e.pers_ncorr as varchar)= '"&q_pers_ncorr&"'  " & vbCrLf &_
									"  and a.dgso_ncorr="&q_dgso_ncorr&"  " & vbCrLf &_   
									"  and a.pers_ncorr=e.pers_ncorr  " & vbCrLf &_   
									"  and a.dgso_ncorr=b.dgso_ncorr  " & vbCrLf &_  
									"  and b.dgso_ncorr=c.dgso_ncorr  " & vbCrLf &_  
									"  and c.dcur_ncorr=d.dcur_ncorr  " & vbCrLf &_  
									"  and a.epot_ccod=4 " 
				'response.Write("<b>Estado</b>"&conexion.ObtenerEstadoTransaccion)

			case "4"
				' Forma pago : Mixto (Otic-Empresa)
				' analizar que ambas partes hayan generado el cargo
				' colocar estado transitorio para generar factura 

					sql_empresa="Select count(*) " & vbCrLf &_
							  " from postulacion_otec a, datos_generales_secciones_otec b ,  " & vbCrLf &_  
							  " ofertas_otec c , diplomados_cursos d,ordenes_compras_otec f   " & vbCrLf &_
							  " where a.dgso_ncorr="&q_dgso_ncorr&" " & vbCrLf &_  
							  " and a.empr_ncorr_empresa='"&q_pers_ncorr&"' " & vbCrLf &_
							  " and a.fpot_ccod=4 " & vbCrLf &_
							  " and a.dgso_ncorr=b.dgso_ncorr  " & vbCrLf &_ 
							  " and b.dgso_ncorr=c.dgso_ncorr " & vbCrLf &_  
							  " and c.dcur_ncorr=d.dcur_ncorr " & vbCrLf &_
							  " and a.dgso_ncorr=f.dgso_ncorr " & vbCrLf &_ 
							  " and a.norc_otic=f.nord_compra" & vbCrLf &_ 
							  " and f.nord_compra="&q_num_oc&" " & vbCrLf &_    
							  " and a.epot_ccod=3 " 

					v_existe_empr=conexion.consultaUno(sql_empresa)

					sql_otic="Select count(*) " & vbCrLf &_
							  " from postulacion_otec a, datos_generales_secciones_otec b ,  " & vbCrLf &_  
							  " ofertas_otec c , diplomados_cursos d,ordenes_compras_otec f   " & vbCrLf &_
							  " where a.dgso_ncorr="&q_dgso_ncorr&" " & vbCrLf &_  
							  " and a.empr_ncorr_otic='"&q_pers_ncorr&"' " & vbCrLf &_
							  " and a.fpot_ccod=4 " & vbCrLf &_
							  " and a.dgso_ncorr=b.dgso_ncorr  " & vbCrLf &_ 
							  " and b.dgso_ncorr=c.dgso_ncorr " & vbCrLf &_  
							  " and c.dcur_ncorr=d.dcur_ncorr " & vbCrLf &_ 
							  " and a.dgso_ncorr=f.dgso_ncorr " & vbCrLf &_ 
							  " and a.norc_otic=f.nord_compra" & vbCrLf &_ 
							  " and f.nord_compra="&q_num_oc&" " & vbCrLf &_  
							  " and a.epot_ccod=3 " 

					v_existe_otic=conexion.consultaUno(sql_otic)

					' si anteriormente se calculo la empresa
					if v_existe_empr>0 then
						sql_extra=" and a.empr_ncorr_empresa=e.pers_ncorr "
						sql_extra2=" and a.epot_ccod=3 "
						cod_estado="4"
						v_tipo=2
					else 
					' si anteriormente se calculo la otic
						if v_existe_otic >0 then
							sql_extra=" and a.empr_ncorr_otic=e.pers_ncorr "
							sql_extra2=" and a.epot_ccod=3 "
							cod_estado="4"
							v_tipo=3
						else
							' sino, es porque es la primera vez que se calcula
							if v_existe_empr=0 and v_existe_otic=0 then
							' primera vez que se calcula, se debe determinar si es empresa  u otic
											sql_otic="Select count(*) " & vbCrLf &_
													  " from postulacion_otec a, datos_generales_secciones_otec b ,  " & vbCrLf &_  
													  " ofertas_otec c , diplomados_cursos d,ordenes_compras_otec f " & vbCrLf &_
													  " where a.dgso_ncorr="&q_dgso_ncorr&" " & vbCrLf &_  
													  " and a.empr_ncorr_otic='"&q_pers_ncorr&"' " & vbCrLf &_
													  " and a.fpot_ccod=4 " & vbCrLf &_
													  " and a.dgso_ncorr=b.dgso_ncorr  " & vbCrLf &_ 
													  " and b.dgso_ncorr=c.dgso_ncorr " & vbCrLf &_  
													  " and c.dcur_ncorr=d.dcur_ncorr " & vbCrLf &_
													  " and a.dgso_ncorr=f.dgso_ncorr " & vbCrLf &_ 
													  " and a.norc_otic=f.nord_compra" & vbCrLf &_ 
													  " and f.nord_compra="&q_num_oc&" " & vbCrLf &_    
													  " and a.epot_ccod=2 " 
													  
										v_existe_otic=conexion.consultaUno(sql_otic)
									' la empresa elegida es una otic
										if v_existe_otic >0 then
											v_tipo=3
											sql_extra	=	" and a.empr_ncorr_otic=e.pers_ncorr "
											sql_opuesto	=	" and a.empr_ncorr_empresa=e.pers_ncorr"
										else' sino , es una empresa normal
											v_tipo=2
											sql_extra	=	" and a.empr_ncorr_empresa=e.pers_ncorr "
											sql_opuesto	=	" and a.empr_ncorr_otic=e.pers_ncorr"
										end if
								cod_estado="3"
								sql_extra2=" and a.epot_ccod=2 "
							'*****************************************************************************************
							'***** VALIDAR PAGO CERO DE EMPRESA U OTIC Y DEJAR MATRICULA EN ESTADO 'Matriculado' *****	
							
							
							
							'*****************************************************************************************	
							end if
							v_tipo=2
						end if
					end if

					sql_actualiza_estado= "update postulacion_otec set epot_ccod="&cod_estado&", comp_ndocto='" & v_comp_ndocto & "', audi_fmodificacion=getdate() " & vbCrLf &_ 
								" where pote_ncorr in ( " & vbCrLf &_ 
								" Select pote_ncorr " & vbCrLf &_
								"  from postulacion_otec a, datos_generales_secciones_otec b ,   " & vbCrLf &_  
								"  ofertas_otec c , diplomados_cursos d, personas e,ordenes_compras_otec f  " & vbCrLf &_
								"  where cast(e.pers_ncorr as varchar)= '"&q_pers_ncorr&"'  " & vbCrLf &_
								"  and a.dgso_ncorr="&q_dgso_ncorr&"  " & vbCrLf &_   
								"  "&sql_extra&"  " & vbCrLf &_   
								"  and a.dgso_ncorr=b.dgso_ncorr  " & vbCrLf &_  
								"  and b.dgso_ncorr=c.dgso_ncorr  " & vbCrLf &_ 
							    "  and a.fpot_ccod=4 " & vbCrLf &_ 
								"  and c.dcur_ncorr=d.dcur_ncorr  " & vbCrLf &_
								"  and a.dgso_ncorr=f.dgso_ncorr " & vbCrLf &_ 
							  	"  and a.norc_otic=f.nord_compra" & vbCrLf &_ 
							  	"  and f.nord_compra="&q_num_oc&" " & vbCrLf &_     
								"  "&sql_extra2&"   " & vbCrLf &_
								" )  "

					sql_inserta_relacion= " insert into postulantes_cargos_otec " & vbCrLf &_  
									" Select distinct pote_ncorr,'"& v_comp_ndocto &"' as comp_ndocto " & vbCrLf &_  
									" ,"&q_pers_ncorr&" as pers_ncorr_institucion,"&v_tipo&" as tipo_institucion,  " & vbCrLf &_
									" '"&Usuario&" crea cargo' as audi_tusuario, getdate() as audi_fmodificacion " & vbCrLf &_
									"  from postulacion_otec a, datos_generales_secciones_otec b ,   " & vbCrLf &_  
									"  ofertas_otec c , diplomados_cursos d, personas e ,ordenes_compras_otec f " & vbCrLf &_
									"  where cast(e.pers_ncorr as varchar)= '"&q_pers_ncorr&"'  " & vbCrLf &_
									"  and a.dgso_ncorr="&q_dgso_ncorr&"  " & vbCrLf &_   
									"  "&sql_extra&"  " & vbCrLf &_
									"  and a.dgso_ncorr=b.dgso_ncorr  " & vbCrLf &_  
									"  and b.dgso_ncorr=c.dgso_ncorr  " & vbCrLf &_  
									"  and c.dcur_ncorr=d.dcur_ncorr  " & vbCrLf &_ 
									"  and a.dgso_ncorr=f.dgso_ncorr " & vbCrLf &_ 
									"  and a.norc_otic=f.nord_compra" & vbCrLf &_ 
									"  and f.nord_compra="&q_num_oc&" "   

			Case else
				' Forma pago : Empresa
					sql_actualiza_estado= "update postulacion_otec set epot_ccod=4, comp_ndocto='" & v_comp_ndocto & "' , audi_fmodificacion=getdate() " & vbCrLf &_ 
								" where pote_ncorr in ( " & vbCrLf &_ 
								" Select pote_ncorr " & vbCrLf &_
								"  from postulacion_otec a, datos_generales_secciones_otec b ,   " & vbCrLf &_  
								"  ofertas_otec c , diplomados_cursos d, personas e ,ordenes_compras_otec f " & vbCrLf &_
								"  where cast(e.pers_ncorr as varchar)= '"&q_pers_ncorr&"'  " & vbCrLf &_
								"  and a.dgso_ncorr="&q_dgso_ncorr&"  " & vbCrLf &_   
								"  and a.empr_ncorr_empresa=e.pers_ncorr  " & vbCrLf &_   
								"  and a.dgso_ncorr=b.dgso_ncorr  " & vbCrLf &_  
								"  and b.dgso_ncorr=c.dgso_ncorr  " & vbCrLf &_  
								"  and c.dcur_ncorr=d.dcur_ncorr  " & vbCrLf &_ 
								"  and a.dgso_ncorr=f.dgso_ncorr " & vbCrLf &_ 
							  	"  and a.norc_empresa=f.nord_compra" & vbCrLf &_ 
							  	"  and f.nord_compra="&q_num_oc&" " & vbCrLf &_     								 
								"  and a.epot_ccod=2   " & vbCrLf &_
								" )  "
								
						sql_inserta_relacion=" insert into postulantes_cargos_otec " & vbCrLf &_  
									" Select distinct pote_ncorr,'"& v_comp_ndocto &"' as comp_ndocto, " & vbCrLf &_  
									" "&q_pers_ncorr&" as pers_ncorr_institucion,2 as tipo_institucion," & vbCrLf &_ 
									" '"&Usuario&" crea cargo' as audi_tusuario, getdate() as audi_fmodificacion " & vbCrLf &_
									"  from postulacion_otec a, datos_generales_secciones_otec b ,   " & vbCrLf &_  
									"  ofertas_otec c , diplomados_cursos d, personas e ,ordenes_compras_otec f " & vbCrLf &_
									"  where cast(e.pers_ncorr as varchar)= '"&q_pers_ncorr&"'  " & vbCrLf &_
									"  and a.dgso_ncorr="&q_dgso_ncorr&"  " & vbCrLf &_   
									"  and a.empr_ncorr_empresa=e.pers_ncorr  " & vbCrLf &_   
									"  and a.dgso_ncorr=b.dgso_ncorr  " & vbCrLf &_  
									"  and b.dgso_ncorr=c.dgso_ncorr  " & vbCrLf &_  
									"  and c.dcur_ncorr=d.dcur_ncorr  " & vbCrLf &_ 
									"  and a.dgso_ncorr=f.dgso_ncorr " & vbCrLf &_ 
									"  and a.norc_empresa=f.nord_compra" & vbCrLf &_ 
									"  and a.empr_ncorr_empresa=f.empr_ncorr "& vbCrLf &_ 
									"  and f.nord_compra="&q_num_oc&" "   								 
					

end select
'response.Write("<b>query:</b> <pre>"&sql_inserta_relacion&"</pre>")
'response.Write("<b>query:</b> <pre>"&sql_actualiza_estado&"</pre>")
'response.Write("<br><b>Estado 0:</b>"&conexion.ObtenerEstadoTransaccion)
conexion.EstadoTransaccion conexion.EjecutaS(sql_actualiza_estado)
'response.Write("<br><b>Estado 0.5:</b>"&conexion.ObtenerEstadoTransaccion)
conexion.EstadoTransaccion conexion.EjecutaS(sql_inserta_relacion)


v_caot_ncorr = conexion.ConsultaUno("execute obtenersecuencia 'contrato_alumno_otec'")
sql_contrato= 	" Insert into contratos_alumnos_otec (caot_ncorr,caot_ncontrato,caot_fcontrato,audi_tusuario,audi_fmodificacion) " & vbCrLf &_ 
				" Values ("&v_caot_ncorr&","&v_caot_ncorr&",protic.trunc(getdate()),'"&Usuario&"',getdate())"
'response.Write("<pre>"&sql_contrato&"</pre>")
conexion.EstadoTransaccion conexion.EjecutaS(sql_contrato)		

'response.Write("<br><b>Estado 1:</b>"&conexion.ObtenerEstadoTransaccion)

'###################################################################################
'###########################			BOLETAS 		############################


	if v_folio_referencia <> "" then
		sql_crea_boletas="Exec genera_boletas 1,"&v_folio_referencia&", 33, "&negocio.ObtenerSede&","&v_mcaj_ncorr&", '"&Usuario&"' "
		v_salida = conexion.ConsultaUno(sql_crea_boletas)
		
		'***********************************************************************************
		sql_boletas="select pers_ncorr,isnull(pers_ncorr_aval,pers_ncorr)as pers_ncorr_aval,bole_ncorr from boletas where ingr_nfolio_referencia="&v_folio_referencia
	else
		sql_boletas="select '' "
	end if

	 set f_boletas = new CFormulario	
	 f_boletas.Carga_Parametros "tabla_vacia.xml","tabla"
	 f_boletas.Inicializar conexion
	 f_boletas.Consultar sql_boletas
	'***********************************************************************************

'###################################################################################

'conexion.EstadoTransaccion false
'response.End()
		
'---------------------------------------------------------------------------------------------------------------------
if conexion.ObtenerEstadoTransaccion then
	str_url = "imprimir_pactacion.asp?comp_ndocto="&v_comp_ndocto
else
	str_url = Request.ServerVariables("HTTP_REFERER")
end if
'Response.Write(str_url)
%>
<script language="javascript" type="text/javascript">
	 <%
		cantidad=f_boletas.nroFilas
		 if cantidad >0 then
			fila=0
			while f_boletas.siguiente
				  v_pers_ncorr=f_boletas.ObtenerValor("pers_ncorr")
				  v_pers_ncorr_aval=f_boletas.ObtenerValor("pers_ncorr_aval")
				  v_bole_ncorr=f_boletas.ObtenerValor("bole_ncorr")
				  if v_bole_ncorr <> "" then
					url="../../cajas/ver_detalle_boletas.asp?bole_ncorr="&v_bole_ncorr&"&pers_ncorr="&v_pers_ncorr&"&pers_ncorr_aval="&v_pers_ncorr_aval
					%>
						window.open("<%=url%>","<%=v_bole_ncorr%>");
					<%
				  end if
				  fila=fila+1
			wend	
		 end if
	%>
   location.reload("<%=str_url%>") 
</script>



