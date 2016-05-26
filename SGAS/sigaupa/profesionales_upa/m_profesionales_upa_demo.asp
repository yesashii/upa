<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeOut = 300000
set pagina = new CPagina
pagina.Titulo = "Corporación de Profesionales"
'-------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------

set botonera = new CFormulario
botonera.Carga_Parametros "m_profesionales_upa.xml", "botonera"
'-------------------------------------------------------------------------------
'for each k in request.QueryString()
'	response.Write(k&" = "&request.QueryString(k)&"<br>")
'next
 carr_ccod  =   request.QueryString("busqueda[0][carr_ccod]")
 jorn_ccod	=	request.querystring("busqueda[0][jorn_ccod]")
 pers_nrut  =   request.QueryString("busqueda[0][pers_nrut]") 
 pers_xdv   =   request.QueryString("busqueda[0][pers_xdv]") 
 pers_tape_paterno  =   request.QueryString("busqueda[0][pers_tape_paterno]") 
 pers_tape_materno  =   request.QueryString("busqueda[0][pers_tape_materno]")
 pers_tnombre =   request.QueryString("busqueda[0][pers_tnombre]")
 mes_ccod =   request.QueryString("busqueda[0][mes_ccod]") 
 sexo_ccod =   request.QueryString("busqueda[0][sexo_ccod]") 
 pers_temail =   request.QueryString("busqueda[0][pers_temail]") 
 ano_egreso =   request.QueryString("busqueda[0][ano_egreso]")
 sin_carrera =  request.QueryString("busqueda[0][sin_carrera]")
 sin_jornada =  request.QueryString("busqueda[0][sin_jornada]")

 fecha_modificacion =  request.QueryString("busqueda[0][fecha_modificacion]")

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "m_profesionales_upa.xml", "busqueda"
 f_busqueda.Inicializar conexion
 peri = periodo
 
 consulta="Select '"&carr_ccod&"' as carr_ccod, '"&jorn_ccod&"' as jorn_ccod, '"&pers_nrut&"' as pers_nrut,'"&pers_xdv&"' as pers_xdv,"& vbCrLf & _
          " '"&pers_tape_paterno&"' as pers_tape_paterno,'"&pers_tape_materno&"' as pers_tape_materno,'"&pers_tnombre&"' as pers_tnombre,"& vbCrLf & _
		  " '"&mes_ccod&"' as mes_ccod,'"&sexo_ccod&"' as sexo_ccod,'"&pers_temail&"' as pers_temail,'"&ano_egreso&"' as ano_egreso,'"&sin_carrera&"' as sin_carrera,'"&sin_jornada&"' as sin_jornada,'"&fecha_modificacion&"' as fecha_modificacion"
 f_busqueda.consultar consulta

 consulta = " select carr_ccod, carr_tdesc,jorn_ccod,jorn_tdesc from (" & vbCrLf & _
			" select distinct c.carr_ccod,c.carr_tdesc,d.jorn_ccod,d.jorn_tdesc " & vbCrLf & _
			" from ofertas_academicas a, especialidades b, carreras c,jornadas d " & vbCrLf & _
			" where a.espe_ccod=b.espe_ccod and b.carr_ccod=c.carr_ccod " & vbCrLf & _
			" and a.jorn_ccod=d.jorn_ccod " & vbCrLf & _
			" and exists (select 1 from alumnos aa (nolock) where a.ofer_ncorr=aa.ofer_ncorr) " & vbCrLf & _
			" union  " & vbCrLf & _
			" select distinct b.carr_ccod, b.carr_tdesc,c.jorn_ccod,c.jorn_tdesc " & vbCrLf & _
			" from egresados_upa2 a, carreras b,jornadas c" & vbCrLf & _
			" where a.carr_ccod=b.carr_ccod " & vbCrLf & _
			" and a.jorn_ccod=c.jorn_ccod)a" & vbCrLf & _
			" order by carr_tdesc "

'response.Write("<pre>"&consulta&"</pre>")	
 f_busqueda.inicializaListaDependiente "lBusqueda", consulta

 f_busqueda.Siguiente
 
'----------------------------------------------------------------------------------
set f_alumnos = new CFormulario
f_alumnos.Carga_Parametros "m_profesionales_upa.xml", "f_alumnos"
f_alumnos.Inicializar conexion

 if jorn_ccod = "" and carr_ccod= "" then
    f_alumnos.consultar "select '' "
	f_alumnos.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
 end if

 consulta = " select cast(a.pers_nrut as varchar) +'-'+ b.pers_xdv as rut,"& vbCrLf &_
			" b.pers_tape_paterno + ' ' + b.pers_tape_materno + ' ' + b.pers_tnombre as alumno, 'EGRESADO' as estado,  año  as realizado, protic.initCap(isnull(case pers_temail when '' then 'No Registra' else pers_temail end,'No registra')) as email, isnull(protic.trunc(pers_fnacimiento),'No Registra') as fecha_nacimiento,  "& vbCrLf &_
			" b.pers_ncorr,a.carr_ccod, entidad as letra,a.jorn_ccod,protic.ultima_modificacion_cpp(b.pers_ncorr,1) as modificado "& vbCrLf &_
			" from egresados_upa2 a,alumni_personas b (nolock) "& vbCrLf &_ 
			" where a.pers_nrut = b.pers_nrut and a.pers_xdv = b.pers_xdv"& vbCrLf &_
			" --and not exists (select 1 from alumni_personas aa (nolock), alumnos ba (nolock), ofertas_academicas ca, especialidades da "& vbCrLf &_
			" --               where a.pers_nrut = aa.pers_nrut and aa.pers_ncorr=ba.pers_ncorr  "& vbCrLf &_
			" --               and ba.ofer_ncorr = ca.ofer_ncorr and ca.espe_ccod = da.espe_ccod "& vbCrLf &_
			" --               and da.carr_ccod = a.carr_ccod and ba.emat_ccod in (4,8)) "& vbCrLf &_
			"  and not exists (select 1 from alumni_personas aa (nolock), alumnos ba (nolock), ofertas_academicas ca, especialidades da "& vbCrLf &_
            "  where a.pers_nrut = aa.pers_nrut and aa.pers_ncorr=ba.pers_ncorr  "& vbCrLf &_
            "  and ba.emat_ccod in (4,8))  "
			if sin_carrera = "" or sin_carrera = "0" then 
			  if sin_jornada = "" or sin_jornada = "0" then 
				consulta = consulta & "  and  carr_ccod='"&carr_ccod&"' and cast(jorn_ccod as varchar)='"&jorn_ccod&"'"
			  else
			  	consulta = consulta & "  and  carr_ccod='"&carr_ccod&"'"
			  end if	
			end if
            if pers_nrut <> "" and pers_xdv <> ""	then
			    consulta = consulta & " and cast(b.pers_nrut as varchar)='"&pers_nrut&"'"
			end if 
			if pers_tape_paterno <> "" then
			    consulta = consulta & " and pers_tape_paterno like '%"&pers_tape_paterno&"%'"
			end if 		
			if pers_tape_materno <> "" then
			    consulta = consulta & " and pers_tape_materno like '%"&pers_tape_materno&"%'"
			end if 
			if pers_tnombre <> "" then
			    consulta = consulta & " and pers_tnombre like '%"&pers_tnombre&"%'"
			end if 
			if mes_ccod <> "" then
			    consulta = consulta & " and cast(datepart(month,pers_fnacimiento) as varchar)='"&mes_ccod&"'"
			end if
			if sexo_ccod <> "" then
			    consulta = consulta & " and cast(sexo_ccod as varchar)='"&sexo_ccod&"'"
			end if 
			if pers_temail <> "" then
			    consulta = consulta & " and pers_temail like'%"&pers_temail&"%'"
			end if 		
			if ano_egreso <> "" then
			    consulta = consulta & " and año ='"&ano_egreso&"'"
			end if 		
			if fecha_modificacion <> "" then
			    consulta = consulta & " and exists (select 1 from alumni_datos_adicionales_egresados dae where dae.pers_ncorr= b.pers_ncorr and convert(varchar,dae.audi_fmodificacion,103) <= convert(datetime,'"&fecha_modificacion&"',103))"
			end if 		 
			
 consulta = consulta &	" union                 "& vbCrLf &_
						" select cast(d.pers_nrut as varchar)+'-'+d.pers_xdv as rut,d.pers_tape_paterno + ' ' + d.pers_tape_materno + ' ' + d.pers_tnombre as alumno, "& vbCrLf &_
						" f.emat_tdesc as estado,e.anos_ccod as realizado,protic.initCap(isnull(case pers_temail when '' then 'No Registra' else pers_temail end,'No registra')) as email, isnull(protic.trunc(pers_fnacimiento),'No Registra') as fecha_nacimiento,"& vbCrLf &_
						" a.pers_ncorr,c.carr_ccod, 'U' as letra,b.jorn_ccod,protic.ultima_modificacion_cpp(d.pers_ncorr,1) as modificado"& vbCrLf &_
						" from alumnos a (nolock), ofertas_academicas b, especialidades c, alumni_personas d (nolock),periodos_Academicos e,estados_matriculas f "& vbCrLf &_
						" where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod "& vbCrLf &_
						" and a.pers_ncorr = d.pers_ncorr "& vbCrLf &_
						" and b.peri_ccod = e.peri_ccod "& vbCrLf &_
						" and a.emat_ccod= f.emat_ccod "& vbCrLf &_
						" and a.emat_ccod in (4,8) "
						'Cambio solicitado emat_ccod = (select top 1 emat_ccod from alumnos a1, ofertas_academicas o1 where a1.pers_ncorr=d.pers_ncorr and a1.ofer_ncorr=o1.ofer_ncorr and o1.espe_ccod = c.espe_ccod and emat_ccod in (4,8) order by o1.peri_ccod desc, convert(datetime,a1.audi_fmodificacion) desc)
						if sin_carrera = "" or sin_carrera = "0" then 
							  if sin_jornada = "" or sin_jornada = "0" then 
								consulta = consulta & "  and  carr_ccod='"&carr_ccod&"' and cast(jorn_ccod as varchar)='"&jorn_ccod&"'"
							  else
								consulta = consulta & "  and  carr_ccod='"&carr_ccod&"'"
							  end if
						end if
                        if pers_nrut <> "" and pers_xdv <> ""	then
						    consulta = consulta & " and cast(d.pers_nrut as varchar)='"&pers_nrut&"'"
						end if 		
						if pers_tape_paterno <> "" then
			    			consulta = consulta & " and pers_tape_paterno like '%"&pers_tape_paterno&"%'"
						end if 		
						if pers_tape_materno <> "" then
			    			consulta = consulta & " and pers_tape_materno like '%"&pers_tape_materno&"%'"
						end if 		
						if pers_tnombre <> "" then
			    			consulta = consulta & " and pers_tnombre like '%"&pers_tnombre&"%'"
						end if 	
						if mes_ccod <> "" then
			    			consulta = consulta & " and cast(datepart(month,pers_fnacimiento) as varchar)='"&mes_ccod&"'"
						end if 
						if sexo_ccod <> "" then
							consulta = consulta & " and cast(sexo_ccod as varchar)='"&sexo_ccod&"'"
						end if 	
						if pers_temail <> "" then
							consulta = consulta & " and pers_temail like '%"&pers_temail&"%'"
						end if 	 
						if ano_egreso <> "" then
							consulta = consulta & " and e.anos_ccod ='"&ano_egreso&"'"
						end if 		
						if fecha_modificacion <> "" then
						    consulta = consulta & " and exists (select 1 from alumni_datos_adicionales_egresados dae where dae.pers_ncorr= d.pers_ncorr and convert(varchar,dae.audi_fmodificacion,103) <= convert(datetime,'"&fecha_modificacion&"',103))"
						end if 				
                       'agregamos las salidas intermedias tanto con egresados como titulados
 consulta = consulta &	" union                 "& vbCrLf &_
						" select cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut,b.pers_tape_paterno + ' ' + b.pers_tape_materno + ' ' + b.pers_tnombre as alumno, "& vbCrLf &_
						" d.emat_tdesc as estado,c.anos_ccod as realizado,protic.initCap(isnull(case pers_temail when '' then 'No Registra' else pers_temail end,'No registra')) as email, isnull(protic.trunc(pers_fnacimiento),'No Registra') as fecha_nacimiento, "& vbCrLf &_
						" a.pers_ncorr,e.carr_ccod, 'U' as letra, "& vbCrLf &_
						" (select top 1 t2.jorn_ccod from alumnos tt, ofertas_academicas t2, especialidades t3 where tt.pers_ncorr=a.pers_ncorr "& vbCrLf &_
						"  and tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod and t3.carr_ccod=e.carr_ccod order by t2.peri_ccod desc) as jorn_ccod, "& vbCrLf &_
						" protic.ultima_modificacion_cpp(a.pers_ncorr,1) as modificado "& vbCrLf &_
						" from alumnos_salidas_intermedias a,alumni_personas b (nolock),periodos_academicos c, estados_matriculas d, salidas_carrera e "& vbCrLf &_
						" where a.pers_ncorr=b.pers_ncorr and a.emat_ccod in (4,8) "& vbCrLf &_
						" and a.peri_ccod=c.peri_ccod and a.emat_ccod=d.emat_ccod "& vbCrLf &_
						" and a.saca_ncorr=e.saca_ncorr "
						if sin_carrera = "" or sin_carrera = "0" then 
							  if sin_jornada = "" or sin_jornada = "0" then 
								consulta = consulta & "  and  e.carr_ccod='"&carr_ccod&"' and  cast((select top 1 t2.jorn_ccod from alumnos tt (nolock), ofertas_academicas t2, especialidades t3 where tt.pers_ncorr=a.pers_ncorr "&_
						                              "  and tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod and t3.carr_ccod=e.carr_ccod order by t2.peri_ccod desc) as varchar) ='"&jorn_ccod&"'"
							  else
								consulta = consulta & "  and  e.carr_ccod='"&carr_ccod&"'"
							  end if
						end if
                        if pers_nrut <> "" and pers_xdv <> ""	then
						    consulta = consulta & " and cast(b.pers_nrut as varchar)='"&pers_nrut&"'"
						end if 		
						if pers_tape_paterno <> "" then
			    			consulta = consulta & " and b.pers_tape_paterno like '%"&pers_tape_paterno&"%'"
						end if 		
						if pers_tape_materno <> "" then
			    			consulta = consulta & " and b.pers_tape_materno like '%"&pers_tape_materno&"%'"
						end if 		
						if pers_tnombre <> "" then
			    			consulta = consulta & " and b.pers_tnombre like '%"&pers_tnombre&"%'"
						end if 	
						if mes_ccod <> "" then
			    			consulta = consulta & " and cast(datepart(month,b.pers_fnacimiento) as varchar)='"&mes_ccod&"'"
						end if 
						if sexo_ccod <> "" then
							consulta = consulta & " and cast(b.sexo_ccod as varchar)='"&sexo_ccod&"'"
						end if 	
						if pers_temail <> "" then
							consulta = consulta & " and b.pers_temail like '%"&pers_temail&"%'"
						end if 	 
						if ano_egreso <> "" then
							consulta = consulta & " and c.anos_ccod ='"&ano_egreso&"'"
						end if 		
						if fecha_modificacion <> "" then
						    consulta = consulta & " and exists (select 1 from alumni_datos_adicionales_egresados dae where dae.pers_ncorr= a.pers_ncorr and convert(varchar,dae.audi_fmodificacion,103) <= convert(datetime,'"&fecha_modificacion&"',103))"
						end if 
									
'response.Write("<pre>"&consulta&"</pre>")						
cantidad_alumnos = conexion.consultaUno("select count(distinct rut) from (" &consulta & ")a")			
consulta = "select * from (" &consulta & ")a order by alumno"
'response.Write("<pre>"&consulta&"</pre>")	   
'response.End()
  if Request.QueryString <> "" then
      f_alumnos.consultar consulta
  else
	f_alumnos.consultar "select '' "
	f_alumnos.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
  end if


'response.Write(cantidad_alumnos)
'-----------------------Realizar búsqueda de datos totales para la consulta---------------------------------------



set f_resumen = new CFormulario
f_resumen.Carga_Parametros "tabla_vacia.xml", "tabla"
f_resumen.Inicializar conexion

 if jorn_ccod = "" and carr_ccod= "" then
    f_resumen.consultar "select '' "
 end if

 consulta = " select distinct b.pers_ncorr,a.carr_ccod, entidad, "& vbCrLf &_
            " (select case count(*) when 0 then 0 else 1 end from egresados_upa2 tt "& vbCrLf &_
			"        where tt.pers_nrut=a.pers_nrut and tt.carr_ccod=a.carr_ccod and tt.emat_ccod=4) as egresado, "& vbCrLf &_
            " (select case count(*) when 0 then 0 else 1 end from egresados_upa2 tt  "& vbCrLf &_
			"        where tt.pers_nrut=a.pers_nrut and tt.carr_ccod=a.carr_ccod and tt.emat_ccod=8) as titulado "& vbCrLf &_
			" from egresados_upa2 a,alumni_personas b (nolock) "& vbCrLf &_ 
			" where a.pers_nrut = b.pers_nrut and a.pers_xdv = b.pers_xdv"& vbCrLf &_
			"  and not exists (select 1 from alumni_personas aa (nolock) , alumnos ba (nolock), ofertas_academicas ca, especialidades da "& vbCrLf &_
            "  where a.pers_nrut = aa.pers_nrut and aa.pers_ncorr=ba.pers_ncorr  "& vbCrLf &_
            "  and ba.emat_ccod in (4,8))  "
			if sin_carrera = "" or sin_carrera = "0" then 
			  if sin_jornada = "" or sin_jornada = "0" then 
				consulta = consulta & "  and  carr_ccod='"&carr_ccod&"' and cast(jorn_ccod as varchar)='"&jorn_ccod&"'"
			  else
			  	consulta = consulta & "  and  carr_ccod='"&carr_ccod&"'"
			  end if	
			end if
            if pers_nrut <> "" and pers_xdv <> ""	then
			    consulta = consulta & " and cast(b.pers_nrut as varchar)='"&pers_nrut&"'"
			end if 
			if pers_tape_paterno <> "" then
			    consulta = consulta & " and pers_tape_paterno like '%"&pers_tape_paterno&"%'"
			end if 		
			if pers_tape_materno <> "" then
			    consulta = consulta & " and pers_tape_materno like '%"&pers_tape_materno&"%'"
			end if 
			if pers_tnombre <> "" then
			    consulta = consulta & " and pers_tnombre like '%"&pers_tnombre&"%'"
			end if 
			if mes_ccod <> "" then
			    consulta = consulta & " and cast(datepart(month,pers_fnacimiento) as varchar)='"&mes_ccod&"'"
			end if
			if sexo_ccod <> "" then
			    consulta = consulta & " and cast(sexo_ccod as varchar)='"&sexo_ccod&"'"
			end if 
			if pers_temail <> "" then
			    consulta = consulta & " and pers_temail like'%"&pers_temail&"%'"
			end if 		
			if ano_egreso <> "" then
			    consulta = consulta & " and año ='"&ano_egreso&"'"
			end if 		
			if fecha_modificacion <> "" then
			    consulta = consulta & " and exists (select 1 from alumni_datos_adicionales_egresados dae where dae.pers_ncorr= b.pers_ncorr and convert(varchar,dae.audi_fmodificacion,103) <= convert(datetime,'"&fecha_modificacion&"',103))"
			end if 		 
			
 consulta = consulta &	" union                 "& vbCrLf &_
						" select distinct a.pers_ncorr,c.carr_ccod, 'U' as entidad, "& vbCrLf &_ 
						"        (select case count(*) when 0 then 0 else 1 end from alumnos tt (nolock), ofertas_academicas tt2, "& vbCrLf &_
						"         especialidades tt3 where tt.pers_ncorr=a.pers_ncorr and tt.ofer_ncorr=tt2.ofer_ncorr "& vbCrLf &_
						"		  and tt2.espe_ccod=tt3.espe_ccod and tt3.carr_ccod=c.carr_ccod and tt.emat_ccod=4) as egresado, "& vbCrLf &_
						"        (select case count(*) when 0 then 0 else 1 end from alumnos tt (nolock), ofertas_academicas tt2, "& vbCrLf &_
						"          especialidades tt3 where tt.pers_ncorr=a.pers_ncorr and tt.ofer_ncorr=tt2.ofer_ncorr  "& vbCrLf &_
						" 		   and tt2.espe_ccod=tt3.espe_ccod and tt3.carr_ccod=c.carr_ccod and tt.emat_ccod=8) as titulado "& vbCrLf &_
						" from alumnos a (nolock), ofertas_academicas b, especialidades c, alumni_personas d (nolock),periodos_Academicos e,estados_matriculas f "& vbCrLf &_
						" where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod "& vbCrLf &_
						" and a.pers_ncorr = d.pers_ncorr "& vbCrLf &_
						" and b.peri_ccod = e.peri_ccod "& vbCrLf &_
						" and a.emat_ccod= f.emat_ccod "& vbCrLf &_
						" and a.emat_ccod in (4,8) "
						if sin_carrera = "" or sin_carrera = "0" then 
							  if sin_jornada = "" or sin_jornada = "0" then 
								consulta = consulta & "  and  carr_ccod='"&carr_ccod&"' and cast(jorn_ccod as varchar)='"&jorn_ccod&"'"
							  else
								consulta = consulta & "  and  carr_ccod='"&carr_ccod&"'"
							  end if
						end if
                        if pers_nrut <> "" and pers_xdv <> ""	then
						    consulta = consulta & " and cast(d.pers_nrut as varchar)='"&pers_nrut&"'"
						end if 		
						if pers_tape_paterno <> "" then
			    			consulta = consulta & " and pers_tape_paterno like '%"&pers_tape_paterno&"%'"
						end if 		
						if pers_tape_materno <> "" then
			    			consulta = consulta & " and pers_tape_materno like '%"&pers_tape_materno&"%'"
						end if 		
						if pers_tnombre <> "" then
			    			consulta = consulta & " and pers_tnombre like '%"&pers_tnombre&"%'"
						end if 	
						if mes_ccod <> "" then
			    			consulta = consulta & " and cast(datepart(month,pers_fnacimiento) as varchar)='"&mes_ccod&"'"
						end if 
						if sexo_ccod <> "" then
							consulta = consulta & " and cast(sexo_ccod as varchar)='"&sexo_ccod&"'"
						end if 	
						if pers_temail <> "" then
							consulta = consulta & " and pers_temail like '%"&pers_temail&"%'"
						end if 	 
						if ano_egreso <> "" then
							consulta = consulta & " and e.anos_ccod ='"&ano_egreso&"'"
						end if 		
						if fecha_modificacion <> "" then
						    consulta = consulta & " and exists (select 1 from alumni_datos_adicionales_egresados dae where dae.pers_ncorr= d.pers_ncorr and convert(varchar,dae.audi_fmodificacion,103) <= convert(datetime,'"&fecha_modificacion&"',103))"
						end if 	
 consulta = consulta &	" union                 "& vbCrLf &_
						"  select distinct a.pers_ncorr,e.carr_ccod, 'U' as entidad, "& vbCrLf &_
						"  (select case count(*) when 0 then 0 else 1 end "& vbCrLf &_
						"          from alumnos_salidas_intermedias tt, salidas_carrera tt2 "& vbCrLf &_
						"          where tt.pers_ncorr=a.pers_ncorr and tt.saca_ncorr=tt2.saca_ncorr  "& vbCrLf &_
						"                and tt2.carr_ccod=e.carr_ccod and tt.emat_ccod=4) as egresado,  "& vbCrLf &_
						" (select case count(*) when 0 then 0 else 1 end  "& vbCrLf &_
						"          from alumnos_salidas_intermedias tt, salidas_carrera tt2 "& vbCrLf &_
						"          where tt.pers_ncorr=a.pers_ncorr and tt.saca_ncorr=tt2.saca_ncorr  "& vbCrLf &_
						"                and tt2.carr_ccod=e.carr_ccod and tt.emat_ccod=8) as titulado "& vbCrLf &_
						" from alumnos_salidas_intermedias a,alumni_personas b (nolock),periodos_academicos c, estados_matriculas d, salidas_carrera e "& vbCrLf &_
						" where a.pers_ncorr=b.pers_ncorr and a.emat_ccod in (4,8) "& vbCrLf &_
						" and a.peri_ccod=c.peri_ccod and a.emat_ccod=d.emat_ccod "& vbCrLf &_
						" and a.saca_ncorr=e.saca_ncorr "
						if sin_carrera = "" or sin_carrera = "0" then 
							  if sin_jornada = "" or sin_jornada = "0" then 
									consulta = consulta & "  and  e.carr_ccod='"&carr_ccod&"' and  cast((select top 1 t2.jorn_ccod from alumnos tt (nolock), ofertas_academicas t2, especialidades t3 where tt.pers_ncorr=a.pers_ncorr "&_
						                                  "  and tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod and t3.carr_ccod=e.carr_ccod order by t2.peri_ccod desc) as varchar) ='"&jorn_ccod&"'"
							  else
								     consulta = consulta & " and e.carr_ccod='"&carr_ccod&"'"
							  end if
						end if
                        if pers_nrut <> "" and pers_xdv <> ""	then
						    consulta = consulta & " and cast(b.pers_nrut as varchar)='"&pers_nrut&"'"
						end if 		
						if pers_tape_paterno <> "" then
			    			consulta = consulta & " and b.pers_tape_paterno like '%"&pers_tape_paterno&"%'"
						end if 		
						if pers_tape_materno <> "" then
			    			consulta = consulta & " and b.pers_tape_materno like '%"&pers_tape_materno&"%'"
						end if 		
						if pers_tnombre <> "" then
			    			consulta = consulta & " and b.pers_tnombre like '%"&pers_tnombre&"%'"
						end if 	
						if mes_ccod <> "" then
			    			consulta = consulta & " and cast(datepart(month,b.pers_fnacimiento) as varchar)='"&mes_ccod&"'"
						end if 
						if sexo_ccod <> "" then
							consulta = consulta & " and cast(b.sexo_ccod as varchar)='"&sexo_ccod&"'"
						end if 	
						if pers_temail <> "" then
							consulta = consulta & " and b.pers_temail like '%"&pers_temail&"%'"
						end if 	 
						if ano_egreso <> "" then
							consulta = consulta & " and c.anos_ccod ='"&ano_egreso&"'"
						end if 		
						if fecha_modificacion <> "" then
						    consulta = consulta & " and exists (select 1 from alumni_datos_adicionales_egresados dae where dae.pers_ncorr= a.pers_ncorr and convert(varchar,dae.audi_fmodificacion,103) <= convert(datetime,'"&fecha_modificacion&"',103))"
						end if 

consulta = "select * from (" &consulta & ")a order by pers_ncorr"
'response.Write("<pre>" &consulta & "</pre>")
  if Request.QueryString <> "" then
      f_resumen.consultar consulta
  else
	f_resumen.consultar "select '' "
  end if

total_instituto = 0
total_egresados_institutos = 0
total_titulados_institutos = 0
total_terminados_intitutos = 0
total_universidad = 0
total_egresados_universidad = 0
total_titulados_universidad = 0
total_terminados_universidad = 0
total_completo = 0
while f_resumen.siguiente
	unidad = f_resumen.obtenerValor("entidad")
	estado_egreso = f_resumen.obtenerValor("egresado")
	estado_titulado = f_resumen.obtenerValor("titulado")
	pp = f_resumen.obtenerValor("pers_ncorr")
    if unidad = "I" then
		total_instituto = total_instituto + 1
		if estado_egreso = "1" and estado_titulado="0" then
			total_egresados_institutos = total_egresados_institutos + 1
		end if
		if estado_titulado = "1" and estado_egreso = "0" then
			total_titulados_institutos = total_titulados_institutos + 1
		end if
		if estado_egreso = "1" and estado_titulado = "1" then
			total_terminados_intitutos = total_terminados_intitutos + 1
		end if
	elseif unidad = "U" then
		total_universidad = total_universidad + 1
		if estado_egreso = "1" and estado_titulado = "0" then
			total_egresados_universidad = total_egresados_universidad + 1
		end if
		if estado_titulado = "1" and estado_egreso = "0" then
			total_titulados_universidad = total_titulados_universidad + 1
			'response.Write(pp&",")
		end if
		if estado_egreso = "1" and estado_titulado = "1" then
			total_terminados_universidad = total_terminados_universidad + 1
		end if	
	end if
wend
total_completo = total_instituto + total_universidad
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
function enviar(formulario){
           	formulario.action ="m_profesionales_upa_demo.asp";//?matr_ncorr="+matricula+"&pers_ncorr="+pers+"&sede_ccod="+sede+"&plan_ccod="+plan+"&peri_ccod="+periodo+"&asig_ccod="+asignatura;
			formulario.submit();
}
</script>
<% f_busqueda.generaJS %>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0">
                      <tr>
                        <td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="5%"> <div align="left">Carrera</div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td><% f_busqueda.dibujaCampoLista "lBusqueda", "carr_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="5%"> <div align="left">Jornada</div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td><% f_busqueda.dibujaCampoLista "lBusqueda", "jorn_ccod"%>&nbsp;&nbsp;&nbsp;<strong>NO Considerar Jornada &nbsp;&nbsp;</strong><%f_busqueda.DibujaCampo("sin_jornada")%>&nbsp;&nbsp;&nbsp;<strong>NO Considerar Carrera &nbsp;&nbsp;</strong><%f_busqueda.DibujaCampo("sin_carrera")%></td>
                              </tr>
							  <tr><td colspan="3" align="right"><hr></td></tr>
							  <tr><td colspan="3" align="right">
									<table width="100%">
										<tr>
											<td><div align="center">                            
											  <p>
												  <%f_busqueda.DibujaCampo("pers_nrut")%> 
												- 
													<%f_busqueda.DibujaCampo("pers_xdv")%>
													<br>
													<strong>R.U.T.</strong> </p>
											  </div></td>
											<td><div align="center">
											  <%f_busqueda.DibujaCampo("pers_tape_paterno")%>
											  <br>
											  <strong>AP. PATERNO</strong></div></td>
											<td><div align="center">
											  <%f_busqueda.DibujaCampo("pers_tape_materno")%>
											  <br>
											  <strong>AP. MATERNO</strong></div></td>
											<td><div align="center">
											  <%f_busqueda.DibujaCampo("pers_tnombre")%>
											  <br>
											  <strong>NOMBRES</strong></div></td>
										  </tr>
									</table>  
							  </td></tr>
							   <tr><td colspan="3" align="right"><hr></td></tr>
							   <tr><td colspan="3" align="right">
									<table width="100%">
										<tr>
											<td><div align="center">                            
											  <p><%f_busqueda.DibujaCampo("mes_ccod")%><br>
													<strong>Mes Nacimiento</strong> </p>
											  </div></td>
											<td><div align="center">
											  <%f_busqueda.DibujaCampo("sexo_ccod")%>
											  <br>
											  <strong>Sexo</strong></div></td>
											<td><div align="center">
											  <%f_busqueda.DibujaCampo("pers_temail")%>
											  <br>
											  <strong>Email Alumno</strong></div></td>
											<td><div align="center">
											  <%f_busqueda.DibujaCampo("ano_egreso")%>
											  <br>
											  <strong>Año Egreso</strong></div></td>
										  </tr>
									</table>  
							  </td></tr>
							  <tr><td colspan="3" align="right"><hr></td></tr>
							  <tr><td colspan="3" align="right">Datos ingresados o Modificados hasta la fecha :  <%f_busqueda.DibujaCampo("fecha_modificacion")%> (dd/mm/aaaa)</td></tr>
    						  <tr><td colspan="3" align="right"><hr></td></tr>
							  <tr><td colspan="3" align="right"><%botonera.dibujaboton "buscar"%></td></tr>
                           </table>
						 </td>
                     </tr>
                    </table>
            </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
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
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
			  <br>
			  </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
                    <td align="center">
                		<table width="90%" cellpadding="0" cellspacing="0" border="1">
                        	<tr>
                            	<td colspan="6" align="center" width="100%"><strong>Resumen de Resultados</strong> (<%=total_completo%> Alumnos)</td>
                            </tr>
                            <tr>
                            	<td colspan="3" align="center" width="50%"><strong>Instituto</strong> (<%=total_instituto%> Alumnos)</td>
                                <td colspan="3" align="center" width="50%"><strong>Universidad</strong> (<%=total_universidad%> Alumnos)</td>
                            </tr>
                            <tr>
                            	<td align="center"><strong>Sólo egresados</strong></td>
                                <td align="center"><strong>Sólo titulados</strong></td>
                                <td align="center"><strong>Ambos estados</strong></td>
                                <td align="center"><strong>Sólo egresados</strong></td>
                                <td align="center"><strong>Sólo titulados</strong></td>
                                <td align="center"><strong>Ambos estados</strong></td>
                            </tr>
                            <tr>
                            	<td align="center"><%=total_egresados_institutos%></td>
                                <td align="center"><%=total_titulados_institutos%></td>
                                <td align="center"><%=total_terminados_intitutos%></td>
                                <td align="center"><%=total_egresados_universidad%></td>
                                <td align="center"><%=total_titulados_universidad%></td>
                                <td align="center"><%=total_terminados_universidad%></td>
                            </tr>
                        </table>
                    </td>
				</tr>
				<%if sin_carrera = "1" then %>
				<tr><td align="left"><div align="left"><strong>Los Datos entregados corresponden a todas las carreras de la Universidad e Instituto.</strong>
                          </div></td>
				</tr>
				<%end if%>
				<tr><td align="left">&nbsp;</td></tr>
				<tr><td align="right"><div align="right">P&aacute;ginas: &nbsp; 
                            <%f_alumnos.AccesoPagina%>
                          </div></td>
				</tr>
                <tr>
                    <td>
                       <%f_alumnos.dibujaTabla()%>
					  </td>
                  </tr>
				  <tr><td>&nbsp;</td></tr>
               </table>
                          <br>
            </form></td></tr>
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
                        <td><div align="center"><%botonera.dibujaBoton "lanzadera"%></div></td>
						<td><div align="center"><% 
							 url_2 = "m_profesionales_upa_excel.asp?carr_ccod="&carr_ccod&"&jorn_ccod="&jorn_ccod&"&pers_nrut="&pers_nrut&"&pers_xdv="&pers_xdv&"&pers_tape_paterno="&pers_tape_paterno&"&pers_tape_materno="&pers_tape_materno&"&pers_tnombre="&pers_tnombre&"&mes_ccod="&mes_ccod&"&sexo_ccod="&sexo_ccod&"&pers_temail="&pers_temail&"&ano_egreso="&ano_egreso&"&sin_carrera="&sin_carrera&"&sin_jornada="&sin_jornada&"&fecha_modificacion="&fecha_modificacion
 							 botonera.agregaBotonParam "excel","url",url_2
							                         if cantidad_alumnos = 0 then 
													  	botonera.agregaBotonParam "excel","deshabilitado","true"
													 end if
												   	 botonera.dibujaBoton "excel"
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
</body>
</html>
