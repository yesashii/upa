<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=indicadores_alumnos.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 99999999
'---------------------------------------------------------------------------------------------------

v_cod_opcion  	= request.querystring("busqueda[0][cod_opcion]")
if v_cod_opcion <> 16 and v_cod_opcion <> 17 then
	v_anos  		= request.querystring("busqueda[0][v_anos]")
else
	v_anos  		= request.querystring("busqueda[0][v_anos2]")
end if

vcantidad=request.querystring("busqueda[0][v_cantidad]")

set pagina = new CPagina
pagina.Titulo = "Listado de indicadores" 

set conexion = new cConexion
conexion.inicializar "upacifico"

set conectar= new cConexion
conectar.inicializar "upacifico"

fecha_01 = conexion.consultaUno("select protic.trunc(getDate())")

set formulario = new CFormulario
formulario.carga_parametros "tabla_vacia.xml", "tabla"
'response.Write("etapa 1")
'response.Flush()
Select Case v_cod_opcion
	Case 1
	    titulo = "1.- Relación Porcentual entre el número de alumnos matriculados en carreras LOCE; respectod el total de alumnos matriculados en la institución."
		
		consulta=matriculados_loce(v_anos)
		sql_consulta_count= "Select count(*) from ("&consulta&") as tabla" 
		v_cantidad=conexion.consultaUno(sql_consulta_count)
		
		c_total_alumnos= "select count(*) from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd, carreras ee "& vbCrLf &_
        				 " where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod and dd.carr_ccod=ee.carr_ccod "& vbCrLf &_
        				 " and cast(cc.anos_ccod as varchar)= '"&v_anos&"' and aa.emat_ccod <> 9 "& vbCrLf &_
        				 " and exists (select 1 from contratos cont1, compromisos comp1 "& vbCrLf &_
						 " where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr and ee.tcar_ccod=1"& vbCrLf &_
						 " and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2))"
		total_universidad_loce = clng(conexion.consultaUno(c_total_alumnos))				
		
		texto = "<strong>Total Alumnos Universidad : </strong>"&conexion.consultaUno(c_total_alumnos)
		estandar = "<strong>Estandar: </strong>Porcentaje de alumnos de similares carreras LOCE de Mercado."
		formula = "<table border='1' width='90'><tr><td aling='center'><img src='img/participacion.gif'></td></tr></table>"

        consulta_facultad = " select *, cast(((en_loce * 100.00)/total_facultad) as decimal(5,2)) as indicador "& vbCrLf &_
							" from "& vbCrLf &_
							" ( "& vbCrLf &_
							" select a.facu_ccod,a.facu_tdesc,sum(factor_carrera) as en_loce,isnull(total_facultad,1) as total_facultad "& vbCrLf &_
							" from facultades a, areas_academicas b, "& vbCrLf &_
							" ( "& vbCrLf &_
							" "&consulta&" "& vbCrLf &_
							" )c "& vbCrLf &_
							" where a.facu_ccod = b.facu_ccod "& vbCrLf &_
							" and b.area_ccod = c.area_ccod "& vbCrLf &_
							" group by a.facu_ccod,a.facu_tdesc,total_facultad "& vbCrLf &_
							" )tabla_general "& vbCrLf &_
							" order by facu_tdesc "
		'response.Write("<pre>"&consulta_facultad&"</pre>")
		'response.End()
	Case 2
   	    titulo = "2.- Relación porcentual entre el número de postulantes seleccionados y el total de postulantes a la carrera."
		consulta=postulantes(v_anos)
		sql_consulta_count= "Select count(*) from ("&consulta&") as tabla" 
		v_cantidad=conexion.consultaUno(sql_consulta_count)
		estandar = "<strong>Estandar: </strong>Por definir."
		formula = "<table border='1' width='90'><tr><td aling='center'><img src='img/seleccion.gif'></td></tr></table>"

        consulta_facultad = "select *, cast(((total_aprobados * 100.00)/total_postulantes) as decimal(5,2)) as indicador "& vbCrLf &_
							" from "& vbCrLf &_
							" ( "& vbCrLf &_
							" select a.facu_ccod,a.facu_tdesc,sum(total_aprobados) as total_aprobados,sum(total_postulantes) as total_postulantes  "& vbCrLf &_
							" from facultades a, areas_academicas b, "& vbCrLf &_
							" ("&consulta&" "& vbCrLf &_
							" )c "& vbCrLf &_
							" where a.facu_ccod=b.facu_ccod "& vbCrLf &_
							" and b.area_ccod=c.area_ccod "& vbCrLf &_
							" group by a.facu_ccod,a.facu_tdesc "& vbCrLf &_
							" )tabla_general "& vbCrLf &_
							" order by facu_tdesc "
	Case 3
   	    titulo = "3.- Demanda anual por carreras de la institución."
		consulta=vacantes(v_anos)
		sql_consulta_count= "Select count(*) from ("&consulta&") as tabla" 
		v_cantidad=conexion.consultaUno(sql_consulta_count)
		
		estandar = "<strong>Estandar: </strong>100% del cupo ofrecido."
		formula = "<table border='1' width='90'><tr><td aling='center'><img src='img/demanda.gif'></td></tr></table>"

        consulta_facultad = "select *, cast(((matriculados * 100.00)/vacantes) as decimal(5,2)) as indicador "& vbCrLf &_
							" from "& vbCrLf &_
							" ( "& vbCrLf &_
							" select a.facu_ccod,a.facu_tdesc,sum(matriculados) as matriculados,sum(vacantes) as vacantes  "& vbCrLf &_
							" from facultades a, areas_academicas b, "& vbCrLf &_
							" ("&consulta&" "& vbCrLf &_
							" )c "& vbCrLf &_
							" where a.facu_ccod=b.facu_ccod "& vbCrLf &_
							" and b.area_ccod=c.area_ccod "& vbCrLf &_
							" group by a.facu_ccod,a.facu_tdesc "& vbCrLf &_
							" )tabla_general "& vbCrLf &_
							" order by facu_tdesc " 
	Case 4
   	    titulo = "4.- Conformación porcentual de alumnos nuevos, según sexo y nacionalidad matriculados en primer año de carrera."
		consulta=alumnos_nuevos(v_anos)
		sql_consulta_count= "Select count(*) from ("&consulta&") as tabla" 
		v_cantidad=conexion.consultaUno(sql_consulta_count)
		
		estandar = "<strong>Estandar: </strong>No tiene."
		formula  = "<table border='1' width='90'><tr><td aling='center'><img src='img/alumnado.gif'></td></tr></table>"

        consulta_facultad = " select *, cast(((hombres * 100.00)/total_carreras) as decimal(5,2)) as indicador_hombres, "& vbCrLf &_
							" cast(((mujeres * 100.00)/total_carreras) as decimal(5,2)) as indicador_mujeres, "& vbCrLf &_
							" cast(((extranjeros * 100.00)/total_carreras) as decimal(5,2)) as indicador_extranjeros "& vbCrLf &_
							" from "& vbCrLf &_
							" ( "& vbCrLf &_
							" select a.facu_ccod,a.facu_tdesc,sum(total_carrera) as total_carreras,sum(total_hombres_carrera) as hombres, "& vbCrLf &_
							" sum(total_mujeres_carrera) as mujeres,sum(total_extranjeros_carrera) as extranjeros  "& vbCrLf &_
							" from facultades a, areas_academicas b, "& vbCrLf &_
							" ("&consulta&" "& vbCrLf &_
							" )c "& vbCrLf &_
							" where a.facu_ccod=b.facu_ccod "& vbCrLf &_
							" and b.area_ccod=c.area_ccod "& vbCrLf &_
							" group by a.facu_ccod,a.facu_tdesc "& vbCrLf &_
							" )tabla_general "& vbCrLf &_
							" order by facu_tdesc " 
	Case 5
  	    titulo = "5.- Porcentaje de implementación del Área de Formación Fundamental a los programas de estudio."
		consulta=formacion_fundamental(v_anos)
		sql_consulta_count= "Select count(*) from ("&consulta&") as tabla" 
		v_cantidad=conexion.consultaUno(sql_consulta_count)
		
		estandar = "<strong>Estandar: </strong>100% en carreras de jornada diurna."
		formula  = "<table border='1' width='90'><tr><td aling='center'><img src='img/ffundamental.gif'></td></tr></table>"

       
    Case 14
   	    titulo = "5.- Expresa la Tasa anual de deserción de alumnos de la Universidad."
		'response.Write(titulo)
		consulta=desercion(v_anos)
		'sql_consulta_count= "Select count(*) from ("&consulta&") as tabla" 
		'v_cantidad=conexion.consultaUno(sql_consulta_count)
		v_cantidad=vcantidad

'response.Write("etapa 2")
'response.Flush()
		
		estandar = "<strong>Estandar: </strong>Menor o igual al 10% de la tasa de deserción del período anterior."
		formula = "<table border='1' width='90'><tr><td aling='center'><img src='img/desercion.gif'></td></tr></table>>"

        consulta_facultad = " select *, cast(((abandonos * 100.00)/total_carreras) as decimal(5,2)) as indicador_abandonos, "& vbCrLf &_
							" cast(((retiros * 100.00)/total_carreras) as decimal(5,2)) as indicador_retiros, "& vbCrLf &_
							" cast(((eliminados * 100.00)/total_carreras) as decimal(5,2)) as indicador_eliminados, "& vbCrLf &_
							" cast(((cambios * 100.00)/total_carreras) as decimal(5,2)) as indicador_cambios, "& vbCrLf &_
							" cast(((abandonos * 100.00)/total_carreras) as decimal(5,2)) + cast(((retiros * 100.00)/total_carreras) as decimal(5,2)) + cast(((eliminados * 100.00)/total_carreras) as decimal(5,2)) + cast(((cambios * 100.00)/total_carreras) as decimal(5,2)) as indicador_totales "& vbCrLf &_
							" from "& vbCrLf &_
							" ( "& vbCrLf &_
							" select a.facu_ccod,a.facu_tdesc,sum(total_alumnos_carrera) as total_carreras,sum(abandonos_temp) as abandonos, "& vbCrLf &_
							" sum(retiros_temp) as retiros,sum(eliminados_temp) as eliminados, sum(cambios_temp) as cambios   "& vbCrLf &_
							" from facultades a, areas_academicas b, "& vbCrLf &_
							" ("&consulta&" "& vbCrLf &_
							" )c "& vbCrLf &_
							" where a.facu_ccod=b.facu_ccod "& vbCrLf &_
							" and b.area_ccod=c.area_ccod "& vbCrLf &_
							" group by a.facu_ccod,a.facu_tdesc "& vbCrLf &_
							" )tabla_general "& vbCrLf &_
							" order by facu_tdesc "
'response.Write("etapa 3")
'response.Flush()
		'response.Write("<pre>"&consulta_facultad&"</pre>")							
      Case 15
   	    titulo = "6.- Expresa la Tasa anual de deserción de alumnos nuevos de la Universidad."
		consulta=desercion_nuevos(v_anos)
		sql_consulta_count= "Select count(*) from ("&consulta&") as tabla" 
		v_cantidad=conexion.consultaUno(sql_consulta_count)
		
		estandar = "<strong>Estandar: </strong>Menor o igual al 10% de la tasa de deserción del período anterior."
		formula = "<table border='1' width='90'><tr><td aling='center'><img src='img/desercion.gif'></td></tr></table>>"

       consulta_facultad = " select *, case when total_carreras > 0 then cast(((abandonos * 100.00)/total_carreras) as decimal(5,2)) else 0 end as indicador_abandonos, "& vbCrLf &_
							" case when total_carreras > 0 then cast(((retiros * 100.00)/total_carreras) as decimal(5,2)) else 0 end as indicador_retiros, "& vbCrLf &_
							" case when total_carreras > 0 then cast(((eliminados * 100.00)/total_carreras) as decimal(5,2)) else 0 end as indicador_eliminados, "& vbCrLf &_
							" case when total_carreras > 0 then cast(((cambios * 100.00)/total_carreras) as decimal(5,2)) else 0 end as indicador_cambios, "& vbCrLf &_
							" case when total_carreras > 0 then cast(((abandonos * 100.00)/total_carreras) as decimal(5,2)) else 0 end + case when total_carreras > 0 then cast(((retiros * 100.00)/total_carreras) as decimal(5,2)) else 0 end + case when total_carreras > 0 then cast(((eliminados * 100.00)/total_carreras) as decimal(5,2)) else 0 end + case when total_carreras > 0 then cast(((cambios * 100.00)/total_carreras) as decimal(5,2)) else 0 end as indicador_totales "& vbCrLf &_
							" from "& vbCrLf &_
							" ( "& vbCrLf &_
							" select a.facu_ccod,a.facu_tdesc,sum(total_alumnos_carrera) as total_carreras,sum(abandonos_temp) as abandonos, "& vbCrLf &_
							" sum(retiros_temp) as retiros,sum(eliminados_temp) as eliminados ,sum(cambios_temp) as cambios "& vbCrLf &_
							" from facultades a, areas_academicas b, "& vbCrLf &_
							" ("&consulta&" "& vbCrLf &_
							" )c "& vbCrLf &_
							" where a.facu_ccod=b.facu_ccod "& vbCrLf &_
							" and b.area_ccod=c.area_ccod "& vbCrLf &_
							" group by a.facu_ccod,a.facu_tdesc "& vbCrLf &_
							" )tabla_general "& vbCrLf &_
							" order by facu_tdesc " 	
							'response.Write("<pre>"&consulta_facultad&"</pre>")	
	  Case 16
		titulo = "7.- Expresa El porcetaje de alumnos titulados oportunamente para cada carrera."
		consulta=titulacion_oportuna(v_anos)
		'response.Write("<pre>"&consulta&"</pre>")
		'response.End()
		sql_consulta_count= "Select count(*) from ("&consulta&") as tabla" 
		v_cantidad=conexion.consultaUno(sql_consulta_count)
		
		estandar = "<strong>Estandar: </strong>Por definir."
		formula = " "
        
		consulta_facultad = "select *, cast(((titulados * 100.00)/activos) as decimal(6,2)) as indicador "& vbCrLf &_
							" from "& vbCrLf &_
							" ( "& vbCrLf &_
							" select a.facu_ccod,a.facu_tdesc,sum(activos_consulta) as activos,sum(titulados_a_tiempo) as titulados  "& vbCrLf &_
							" from facultades a, areas_academicas b, "& vbCrLf &_
							" ("&consulta&" "& vbCrLf &_
							" )c "& vbCrLf &_
							" where a.facu_ccod=b.facu_ccod "& vbCrLf &_
							" and b.area_ccod=c.area_ccod "& vbCrLf &_
							" group by a.facu_ccod,a.facu_tdesc "& vbCrLf &_
							" )tabla_general "& vbCrLf &_
							" order by facu_tdesc "  
			
        'docentes total contratados
		'consulta_docentes=ObtenerTotalProfes()
		'v_cantidad_docentes=conexion.consultaUno(consulta_docentes)
	Case 17
		titulo = "8.- Expresa el promedio de tiempo(semestres) de titulación de alumnos para cada carrera."
		consulta=promedio_titulacion(v_anos)
		'response.Write("<pre>"&consulta&"</pre>")
		'response.End()
				
		estandar = "<strong>Estandar: </strong>Por definir."
		formula = " "
        'docentes total contratados
		'consulta_docentes=ObtenerTotalProfes()
		'v_cantidad_docentes=conexion.consultaUno(consulta_docentes)				
Case 18

		consulta=vacantes_ofertas(v_anos)
		'response.Write("<hr><pre>"&consulta&"</pre>")
		'sql_consulta_count= "Select count(*) from ("&consulta&") as tabla" 
		'v_cantidad=conexion.consultaUno(sql_consulta_count)
		
		estandar = "<strong>Estandar: </strong>100% del cupo ofrecido."
		formula = "<table border='1' width='90'><tr><td aling='center'><img src='img/demanda.gif'></td></tr></table>"
		


		if v_anos >="2007" then

				
			v_peri_ccod=conexion.consultaUno("select top 1 peri_ccod from periodos_academicos where anos_ccod="&v_anos&" and plec_ccod in (1,2) order by peri_ccod desc")
					
			consulta_facultad= " select cc.facu_tdesc as facultad,isnull(vacantes_nuevos_facultad,0) as vacantes_nuevos, "& vbCrLf &_
								" isnull(vacantes_antiguos_facultad,0) as vacantes_antiguos,isnull(sum(nuevos),0) as nuevos, isnull(sum(antiguos),0) as antiguos,  "& vbCrLf &_ 
								"  case when isnull(vacantes_nuevos_facultad,0)=0 then 0 else cast(((sum(nuevos) * 100.00) / vacantes_nuevos_facultad ) as decimal (6,2)) end as indicador_nuevos,   "& vbCrLf &_
								"  case when isnull(vacantes_antiguos_facultad,0)=0 then 0 else cast(((sum(antiguos) * 100.00) / vacantes_antiguos_facultad ) as decimal (6,2)) end as indicador_antiguos "& vbCrLf &_
								"  from areas_academicas bb "& vbCrLf &_
								"      join facultades cc   "& vbCrLf &_
								"        on bb.facu_ccod=cc.facu_ccod "& vbCrLf &_
								"        and bb.facu_ccod not in (6,7) "& vbCrLf &_  
								"      join "& vbCrLf &_         
								"          (select distinct count(nuevo) as nuevos,count(antiguo) as antiguos,area_ccod,peri_ccod,sede_ccod,carr_ccod,jorn_ccod,vacantes_nuevos_facultad,vacantes_antiguos_facultad "& vbCrLf &_
								"                from ("& vbCrLf &_
								"                  select case when i.post_bnuevo='S' then 1 end as nuevo,case when i.post_bnuevo='N' then 1 end as antiguo, "& vbCrLf &_
								"                    matr_ncorr,alum_nmatricula, a.area_ccod,d.peri_ccod,e.sede_ccod,a.carr_ccod,f.jorn_ccod, "& vbCrLf &_    
								"                     isnull(vacantes_nuevos_facultad,0) as vacantes_nuevos_facultad, isnull(vacantes_antiguos_facultad,0) as vacantes_antiguos_facultad "& vbCrLf &_  
								"                     from carreras a "& vbCrLf &_   
								"                     join especialidades b "& vbCrLf &_  
								"                        on a.carr_ccod=b.carr_ccod "& vbCrLf &_
								"                        and a.carr_ccod not in (6) "& vbCrLf &_         
								"                     join ofertas_academicas c "& vbCrLf &_   
								"                        on b.espe_ccod=c.espe_ccod "& vbCrLf &_
								"                     join alumnos h "& vbCrLf &_
								"                        on c.ofer_ncorr=h.ofer_ncorr "& vbCrLf &_
								"                        and h.alum_nmatricula not in (7777) "& vbCrLf &_
								"                        and emat_ccod in (1,4,8,2,15,16)  "& vbCrLf &_
								"                     join postulantes i "& vbCrLf &_
								"                        on h.post_ncorr=i.post_ncorr "& vbCrLf &_
								"                        and h.ofer_ncorr=i.ofer_ncorr "& vbCrLf &_         
								"                     join periodos_academicos d "& vbCrLf &_   
								"                        on c.peri_ccod=d.peri_ccod "& vbCrLf &_    
								"                        and cast(d.anos_ccod as varchar)="&v_anos&" "& vbCrLf &_     
								"                     join sedes e "& vbCrLf &_   
								"                        on c.sede_ccod=e.sede_ccod "& vbCrLf &_
								"                     join jornadas f "& vbCrLf &_    
								"                        on c.jorn_ccod=f.jorn_ccod "& vbCrLf &_   
								"                     left outer join estructura_indicador_ofertas g "& vbCrLf &_   
								"                        on  c.jorn_ccod=g.jornada "& vbCrLf &_   
								"                        and c.sede_ccod=g.sede "& vbCrLf &_   
								"                        and b.carr_ccod=g.cod_carrera "& vbCrLf &_     
								"                        and cast(g.admision as varchar)="&v_anos&" "& vbCrLf &_
								"                     where a.tcar_ccod=1 "& vbCrLf &_
								"		  				 and d.peri_ccod=protic.retorna_max_periodo_matricula(h.pers_ncorr,'"&v_peri_ccod&"',b.carr_ccod)     "& vbCrLf &_								     
								"                ) as zz "& vbCrLf &_ 
								"                group by area_ccod,peri_ccod,sede_ccod,carr_ccod,jorn_ccod,vacantes_nuevos_facultad,vacantes_antiguos_facultad "& vbCrLf &_

								"         ) aa "& vbCrLf &_
								"   on aa.area_ccod=bb.area_ccod "& vbCrLf &_
								"  group by cc.facu_ccod,cc.facu_tdesc,vacantes_antiguos_facultad,vacantes_nuevos_facultad "    
					


			consulta_sede= "select bb.sede_tdesc as sede,isnull(vacantes_nuevos_sede,0) as vacantes_nuevos,  "& vbCrLf &_
							 "isnull(vacantes_antiguos_sede,0) as vacantes_antiguos,isnull(sum(nuevos),0) as nuevos, isnull(sum(antiguos),0) as antiguos,  "& vbCrLf &_  
							 " case when isnull(vacantes_nuevos_sede,0)=0 then 0 else cast(((sum(nuevos) * 100.00) / vacantes_nuevos_sede ) as decimal (6,2)) end as indicador_nuevos,  "& vbCrLf &_  
							 " case when isnull(vacantes_antiguos_sede,0)=0 then 0 else cast(((sum(antiguos) * 100.00) / vacantes_antiguos_sede ) as decimal (6,2)) end as indicador_antiguos  "& vbCrLf &_
							 " from sedes bb  "& vbCrLf &_
							 "     left outer join  "& vbCrLf &_         
							 "         (select distinct count(nuevo) as nuevos,count(antiguo) as antiguos,area_ccod,peri_ccod,sede_ccod,carr_ccod,jorn_ccod,vacantes_nuevos_sede,vacantes_antiguos_sede  "& vbCrLf &_
							 "               from ( "& vbCrLf &_
							 "                 select case when i.post_bnuevo='S' then 1 end as nuevo,case when i.post_bnuevo='N' then 1 end as antiguo, "& vbCrLf &_
							 "                   matr_ncorr,alum_nmatricula, a.area_ccod,d.peri_ccod,e.sede_ccod,a.carr_ccod,f.jorn_ccod, "& vbCrLf &_     
							 "                    isnull(vacantes_nuevos_sede,0) as vacantes_nuevos_sede, isnull(vacantes_antiguos_sede,0) as vacantes_antiguos_sede "& vbCrLf &_
							 "                    from carreras a     "& vbCrLf &_
							 "                    join especialidades b    "& vbCrLf &_
							 "                       on a.carr_ccod=b.carr_ccod "& vbCrLf &_
							 "                       and a.carr_ccod not in (6) "& vbCrLf &_     
							 "                    join ofertas_academicas c "& vbCrLf &_   
							 "                       on b.espe_ccod=c.espe_ccod "& vbCrLf &_
							 "                    join alumnos h "& vbCrLf &_
							 "                       on c.ofer_ncorr=h.ofer_ncorr "& vbCrLf &_
							 "                       and h.alum_nmatricula not in (7777) "& vbCrLf &_
							 "                       and emat_ccod in (1,4,8,2,15,16)  "& vbCrLf &_
							 "                    join postulantes i "& vbCrLf &_
							 "                       on h.post_ncorr=i.post_ncorr "& vbCrLf &_
							 "                       and h.ofer_ncorr=i.ofer_ncorr "& vbCrLf &_         
							 "                    join periodos_academicos d "& vbCrLf &_   
							 "                       on c.peri_ccod=d.peri_ccod "& vbCrLf &_    
							 "                       and cast(d.anos_ccod as varchar)="&v_anos&" "& vbCrLf &_     
							 "                    join sedes e "& vbCrLf &_   
							 "                       on c.sede_ccod=e.sede_ccod "& vbCrLf &_
							 "                    join jornadas f "& vbCrLf &_     
							 "                       on c.jorn_ccod=f.jorn_ccod  "& vbCrLf &_  
							 "                    left outer join estructura_indicador_ofertas g  "& vbCrLf &_  
							 "                       on  c.jorn_ccod=g.jornada  "& vbCrLf &_  
							 "                       and c.sede_ccod=g.sede "& vbCrLf &_   
							 "                       and b.carr_ccod=g.cod_carrera "& vbCrLf &_     
							 "                       and cast(g.admision as varchar)="&v_anos&" "& vbCrLf &_
							 "                    where a.tcar_ccod=1 "& vbCrLf &_     
							 "		  				 and d.peri_ccod=protic.retorna_max_periodo_matricula(h.pers_ncorr,'"&v_peri_ccod&"',b.carr_ccod)     "& vbCrLf &_								     
							 "               ) as zz  "& vbCrLf &_
							 "               group by area_ccod,peri_ccod,sede_ccod,carr_ccod,jorn_ccod,vacantes_nuevos_sede,vacantes_antiguos_sede "& vbCrLf &_
							 "        ) aa  "& vbCrLf &_
							 "  on aa.sede_ccod=bb.sede_ccod "& vbCrLf &_
							 " where bb.sede_ccod not in (3,5,6,7) "& vbCrLf &_
							 " group by bb.sede_ccod,bb.sede_tdesc,vacantes_antiguos_sede,vacantes_nuevos_sede  "


		else         

				consulta_facultad = " select admision, facultad, sum(nuevos) as nuevos, sum(antiguos) as antiguos, "& vbCrLf &_
								" sum(vacantes_nuevos) as vacantes_nuevos, sum(vacantes_antiguos) as vacantes_antiguos, "& vbCrLf &_
								" case when sum(vacantes_nuevos)=0 then 0 else cast(((sum(nuevos) * 100.00) / sum(vacantes_nuevos) ) as decimal (6,2)) end as indicador_nuevos, "& vbCrLf &_
								" case when sum(vacantes_antiguos)=0 then 0 else cast(((sum(antiguos) * 100.00) / sum(vacantes_antiguos) ) as decimal (6,2)) end as indicador_antiguos "& vbCrLf &_
								" from estructura_ofertas_antiguas a "& vbCrLf &_
								" left outer join carreras b "& vbCrLf &_
								"	on a.cod_carrera=b.carr_ccod "& vbCrLf &_
								" join  jornadas c "& vbCrLf &_
								"	on a.jornada=c.jorn_ccod "& vbCrLf &_
								" join sedes d "& vbCrLf &_
								"	on a.sede=d.sede_ccod "& vbCrLf &_
								" where admision='"&v_anos&"'  "& vbCrLf &_  
								" group by facultad,admision "  			
								
				consulta_sede = " select admision, sede_tdesc as sede, sum(nuevos) as nuevos, sum(antiguos) as antiguos, "& vbCrLf &_
								" sum(vacantes_nuevos) as vacantes_nuevos, sum(vacantes_antiguos) as vacantes_antiguos, "& vbCrLf &_
								" case when sum(vacantes_nuevos)=0 then 0 else cast(((sum(nuevos) * 100.00) / sum(vacantes_nuevos) ) as decimal (6,2)) end as indicador_nuevos, "& vbCrLf &_
								" case when sum(vacantes_antiguos)=0 then 0 else cast(((sum(antiguos) * 100.00) / sum(vacantes_antiguos) ) as decimal (6,2)) end as indicador_antiguos "& vbCrLf &_
								" from estructura_ofertas_antiguas a "& vbCrLf &_
								" left outer join carreras b "& vbCrLf &_
								"	on a.cod_carrera=b.carr_ccod "& vbCrLf &_
								" join  jornadas c "& vbCrLf &_
								"	on a.jornada=c.jorn_ccod "& vbCrLf &_
								" join sedes d "& vbCrLf &_
								"	on a.sede=d.sede_ccod "& vbCrLf &_
								" where admision='"&v_anos&"'  "& vbCrLf &_  
								" group by sede_tdesc,admision "  																
													
		end if		
		
	Case 19

		consulta_base=matriculados_no_loce(v_anos)

		sql_consulta_count= "Select sum(total_alumnos_carrera) from ("&consulta_base&") as tabla" 
		v_cantidad=conexion.consultaUno(sql_consulta_count)
        total_universidad=v_cantidad

		texto = "<strong>Total Alumnos Universidad : </strong>"&total_universidad
		estandar = "<strong>Estandar: </strong>Porcentaje de alumnos"
		formula = "<table border='1' width='90'><tr><td aling='center'><img src='img/participacion.gif'></td></tr></table>"
		'response.Write(texto)		
			 

		consulta = 	"   select area_ccod,sede_tdesc as sede,carr_tdesc as carrera,jorn_tdesc as jornada, "&total_universidad&" as total_universidad, "& vbCrLf &_  
					"  (total_alumnos_carrera) as factor_carrera,(Select sum(total_alumnos_carrera) from ("&consulta_base&") as tabla where facu_ccod=table_a.facu_ccod) as total_facultad, "& vbCrLf &_
					"  cast(((total_alumnos_carrera * 100.00) / (Select sum(total_alumnos_carrera) from ("&consulta_base&") as tabla where facu_ccod=table_a.facu_ccod)) as decimal(8,2)) as porcentaje_participacion_facultad, "& vbCrLf &_   
					"  cast(((total_alumnos_carrera * 100.00) / "&total_universidad&") as decimal(8,2)) as porcentaje_participacion_universidad "& vbCrLf &_  
					"   from ( "& vbCrLf &_ 
					" "&consulta_base&" "& vbCrLf &_
					" )table_a  "
							 	
		
		consulta_facu = 	"   select area_ccod,sede_tdesc as sede,carr_tdesc as carrera,jorn_tdesc as jornada, "& vbCrLf &_  
					"  (total_alumnos_carrera) as factor_carrera, "& vbCrLf &_
					"  cast(((total_alumnos_carrera * 100.00) / "&total_universidad&") as decimal(8,2)) as porcentaje_participacion_universidad, "& vbCrLf &_  
					"  cast(((total_alumnos_carrera * 100.00) / 5) as decimal(8,2)) as porcentaje_participacion_facultad "& vbCrLf &_   
					"   from ( "& vbCrLf &_ 
					" "&consulta_base&" "& vbCrLf &_
					" )table_a  "
					
		consulta_facultad = " select *, cast(((total_facultad * 100.00)/total_universidad) as decimal(8,2)) as indicador "& vbCrLf &_
							" from "& vbCrLf &_
							" ( "& vbCrLf &_
							" select a.facu_ccod,a.facu_tdesc,sum(factor_carrera) as total_facultad, "& vbCrLf &_
							" "&total_universidad&" as total_universidad "& vbCrLf &_
							" from facultades a, areas_academicas b, "& vbCrLf &_
							" ( "& vbCrLf &_
							" "&consulta_facu&" "& vbCrLf &_
							" )c "& vbCrLf &_
							" where a.facu_ccod = b.facu_ccod "& vbCrLf &_
							" and b.area_ccod = c.area_ccod "& vbCrLf &_
							" group by a.facu_ccod,a.facu_tdesc "& vbCrLf &_
							" )tabla_general "& vbCrLf &_
							" order by facu_tdesc "


End select
'response.End()
	'response.Write("<pre>"&consulta &" order by sede, carrera, jornada  </pre>")
   ' response.End()


formulario.inicializar conectar 
'formulario.Consultar consulta &" order by sede, carrera, jornada  "
if v_cod_opcion <> 16 and v_cod_opcion <> 17  then
		formulario.Consultar consulta &" order by sede, carrera, jornada  "
	elseif v_cod_opcion = 16 then 
		formulario.Consultar consulta &" order by carrera, jornada  "
	elseif v_cod_opcion = 17 then 
		formulario.Consultar consulta &" order by carrera"	
end if

v_filas=formulario.nroFilas

if v_cod_opcion = 1 then
	    total_loce = 0
		while formulario.siguiente
			total_loce = total_loce + clng(formulario.obtenerValor("factor_carrera"))
		wend
		porcentaje_universidad = formatnumber(cdbl((total_loce * 100) / total_universidad_loce),2,-1,0,0)
		formulario.primero
elseif v_cod_opcion = 2 then
	    total_aprobados = 0
		total_postulantes = 0
		while formulario.siguiente
			total_aprobados = total_aprobados + clng(formulario.obtenerValor("total_aprobados"))
			total_postulantes = total_postulantes + clng(formulario.obtenerValor("total_postulantes"))
			'response.Write("<br>valores total_aprobados="&total_aprobados&" total_postulantes="&total_postulantes)
		wend
		porcentaje_universidad = formatnumber(cdbl((total_aprobados * 100) / total_postulantes),2,-1,0,0)
		formulario.primero
elseif v_cod_opcion = 3 then
	    matriculados = 0
		tvacantes = 0
		while formulario.siguiente
			matriculados = matriculados + clng(formulario.obtenerValor("matriculados"))
			tvacantes = tvacantes + clng(formulario.obtenerValor("vacantes"))
			'response.Write("<br>valores total_aprobados="&total_aprobados&" total_postulantes="&total_postulantes)
		wend
		porcentaje_universidad = formatnumber(cdbl((matriculados * 100) / tvacantes),2,-1,0,0)
		formulario.primero
elseif v_cod_opcion = 4 then
	    ntotales = 0
		nhombres = 0
		nmujeres = 0
		nextranjeros = 0
		while formulario.siguiente
			ntotales = ntotales + clng(formulario.obtenerValor("total_carrera"))
			nhombres = nhombres + clng(formulario.obtenerValor("total_hombres_carrera"))
			nmujeres = nmujeres + clng(formulario.obtenerValor("total_mujeres_carrera"))
			nextranjeros = nextranjeros + clng(formulario.obtenerValor("total_extranjeros_carrera"))
			'response.Write("<br>valores total_aprobados="&total_aprobados&" total_postulantes="&total_postulantes)
		wend
		porcentaje_universidad = ntotales
		porcentaje_hombres = formatnumber(cdbl((nhombres * 100) / ntotales),2,-1,0,0)
		porcentaje_mujeres = formatnumber(cdbl((nmujeres * 100) / ntotales),2,-1,0,0)
		porcentaje_extranjeros = formatnumber(cdbl((nextranjeros * 100) / ntotales),2,-1,0,0)
		formulario.primero
elseif v_cod_opcion = 14 then
	    ntotales = 0
		nabandonos = 0
		nretiros = 0
		neliminados = 0
		porc_total = 0
		while formulario.siguiente
			ntotales = ntotales + clng(formulario.obtenerValor("total_alumnos_carrera"))
			nabandonos = nabandonos + clng(formulario.obtenerValor("abandonos_temp"))
			nretiros = nretiros + clng(formulario.obtenerValor("retiros_temp"))
			neliminados = neliminados + clng(formulario.obtenerValor("eliminados_temp"))
			porc_total = ( clng(nabandonos) + clng(nretiros) + clng(neliminados) )
    		'response.Write("<br>valores total_aprobados="&total_aprobados&" total_postulantes="&total_postulantes)
		wend
		porcentaje_universidad = ntotales
		porcentaje_abandonos = formatnumber(cdbl((nabandonos * 100) / ntotales),2,-1,0,0)
		porcentaje_retiros = formatnumber(cdbl((nretiros * 100) / ntotales),2,-1,0,0)
		porcentaje_eliminados = formatnumber(cdbl((neliminados * 100) / ntotales),2,-1,0,0)
		porcentaje_total = formatnumber(cdbl((porc_total * 100) / ntotales),2,-1,0,0)
		formulario.primero
elseif v_cod_opcion = 15 then
	    ntotales = 0
		nabandonos = 0
		nretiros = 0
		neliminados = 0
		porc_total = 0
		while formulario.siguiente
			ntotales = ntotales + clng(formulario.obtenerValor("total_alumnos_carrera"))
			nabandonos = nabandonos + clng(formulario.obtenerValor("abandonos_temp"))
			nretiros = nretiros + clng(formulario.obtenerValor("retiros_temp"))
			neliminados = neliminados + clng(formulario.obtenerValor("eliminados_temp"))
			porc_total = ( clng(nabandonos) + clng(nretiros) + clng(neliminados) )
			'response.Write("<br>valores total_aprobados="&total_aprobados&" total_postulantes="&total_postulantes)
		wend
		porcentaje_universidad = ntotales
		porcentaje_abandonos = formatnumber(cdbl((nabandonos * 100) / ntotales),2,-1,0,0)
		porcentaje_retiros = formatnumber(cdbl((nretiros * 100) / ntotales),2,-1,0,0)
		porcentaje_eliminados = formatnumber(cdbl((neliminados * 100) / ntotales),2,-1,0,0)
		porcentaje_total = formatnumber(cdbl((porc_total * 100) / ntotales),2,-1,0,0)
		formulario.primero
elseif v_cod_opcion = 16 then
	    activos = 0
		titulados = 0
		while formulario.siguiente
			activos = activos + clng(formulario.obtenerValor("activos_consulta"))
			titulados = titulados + clng(formulario.obtenerValor("titulados_a_tiempo"))
			'response.Write("<br>valores total_aprobados="&total_aprobados&" total_postulantes="&total_postulantes)
		wend
		porcentaje_universidad = formatnumber(cdbl((titulados * 100) / activos),2,-1,0,0)
		formulario.primero
elseif v_cod_opcion = 17 then
	    cantidad = 0
		promedio = 0
		while formulario.siguiente
			cantidad = cantidad + 1
			promedio = promedio + clng(formulario.obtenerValor("indicador"))
			'response.Write("<br>valores total_aprobados="&total_aprobados&" total_postulantes="&total_postulantes)
		wend
		porcentaje_universidad = formatnumber(cdbl((promedio) / cantidad),2,-1,0,0)
		formulario.primero		
elseif v_cod_opcion = 18 then
	    matriculados = 0
		tvacantes = 0
		matriculados_antiguos = 0
		tvacantes_antiguos = 0
		while formulario.siguiente
			matriculados = matriculados + clng(formulario.obtenerValor("nuevos"))
			tvacantes = tvacantes + clng(formulario.obtenerValor("vacantes_nuevos"))
			matriculados_antiguos = matriculados_antiguos + clng(formulario.obtenerValor("antiguos"))
			tvacantes_antiguos = tvacantes_antiguos + clng(formulario.obtenerValor("vacantes_antiguos"))
			'response.Write("<br>valores total_aprobados="&total_aprobados&" total_postulantes="&total_postulantes)
		wend
		if tvacantes = 0 then
			porcentaje_universidad = formatnumber(0,2,-1,0,0)
		else
			porcentaje_universidad = formatnumber(cdbl((matriculados * 100) / tvacantes),2,-1,0,0)
		end if
		if tvacantes_antiguos = 0 then 
			porcentaje_universidad_antiguos = formatnumber(0,2,-1,0,0)
		else
			porcentaje_universidad_antiguos = formatnumber(cdbl((matriculados_antiguos * 100) / tvacantes_antiguos),2,-1,0,0)
		end if 
		formulario.primero
end if


'//////////////confeccionamos la lista con indices por facultad en algunos casos estudiados////////////////////
if consulta_facultad <> "" then

	set formulario2 = new CFormulario
	formulario2.carga_parametros "tabla_vacia.xml", "tabla"
	formulario2.inicializar conexion
	formulario2.Consultar consulta_facultad

end if

if consulta_sede <> "" then

	set formulario3 = new CFormulario
	formulario3.carga_parametros "tabla_vacia.xml", "tabla"
	formulario3.inicializar conexion
	formulario3.Consultar consulta_sede

end if

Function matriculados_loce(anio)
	sql_indicador=	" select area_ccod,sede_tdesc as sede,carr_tdesc as carrera,jorn_tdesc as jornada, "& vbCrLf &_
					" (total_alumnos_carrera) as factor_carrera, total_facultad, cast(((cast(total_alumnos_carrera as decimal(5,2)) * 100.00) / total_alumnos) as decimal(5,2)) as porcentaje_participacion_universidad, "& vbCrLf &_
					" cast(((cast(total_alumnos_carrera as decimal(5,2)) * 100.00) / total_facultad) as decimal(5,2)) as porcentaje_participacion_facultad  "& vbCrLf &_
					"  from  "& vbCrLf &_
					"     ( "& vbCrLf &_
					"		select ttr.area_ccod,ttr.sede_ccod,ttr.sede_tdesc,ttr.carr_ccod,ttr.carr_tdesc,ttr.jorn_ccod,ttr.jorn_tdesc,"& vbCrLf &_
					"       (select count(distinct pers_ncorr) from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd "& vbCrLf &_
					"        where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
					"        and cc.anos_ccod = ttr.anos_ccod and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod "& vbCrLf &_
					"        and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod <> 9 "& vbCrLf &_
					"        and exists (select 1 from contratos cont1, compromisos comp1 "& vbCrLf &_
					"                    where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr "& vbCrLf &_
					"                    and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2))) as total_alumnos_carrera, "& vbCrLf &_
					"        (select count(distinct pers_ncorr) from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd, carreras ee "& vbCrLf &_
					"         where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod "& vbCrLf &_
					"         and cc.anos_ccod = ttr.anos_ccod and aa.emat_ccod <> 9 and bb.espe_ccod=dd.espe_ccod and dd.carr_ccod=ee.carr_ccod and ee.tcar_ccod=1 "& vbCrLf &_
					"         and exists (select 1 from contratos cont1, compromisos comp1 "& vbCrLf &_
					"                     where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr "& vbCrLf &_
					"                     and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2))) as total_alumnos,"& vbCrLf &_
					"         (select count(*) from (select distinct pers_ncorr,dd.carr_ccod, bb.jorn_ccod,bb.sede_ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc,especialidades dd "& vbCrLf &_
					"         where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod "& vbCrLf &_
					"         and cc.anos_ccod = ttr.anos_ccod and aa.emat_ccod <> 9 "& vbCrLf &_
					"         and bb.espe_ccod = dd.espe_ccod"& vbCrLf &_
					"         and dd.carr_ccod in (select distinct carr_ccod from carreras cac,areas_academicas bbb "& vbCrLf &_
					"                              where cac.area_ccod=bbb.area_ccod and bbb.facu_ccod = ttr.facu_ccod and cac.tcar_ccod=1)"& vbCrLf &_
					"         and exists (select 1 from contratos cont1, compromisos comp1 "& vbCrLf &_
					"                     where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr "& vbCrLf &_
					"                     and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2))) as tabla_temp) as total_facultad                "& vbCrLf &_
					"		  from  "& vbCrLf &_
					" 		  (  "& vbCrLf &_
					"       	 select distinct g.facu_ccod, d.anos_ccod,a.area_ccod,e.sede_ccod,e.sede_tdesc,a.carr_ccod,a.carr_tdesc,  "& vbCrLf &_
					"		     f.jorn_ccod,f.jorn_tdesc  "& vbCrLf &_
					"         	from carreras a, especialidades b, ofertas_academicas c, periodos_academicos d, sedes e, jornadas f,areas_academicas g "& vbCrLf &_
					"         	where carr_bloce='S' and a.carr_ccod=b.carr_ccod and b.espe_ccod=c.espe_ccod "& vbCrLf &_
					"         	and c.peri_ccod=d.peri_ccod and cast(d.anos_ccod as varchar)='"&anio&"' "& vbCrLf &_
					"         	and c.sede_ccod=e.sede_ccod and c.jorn_ccod=f.jorn_ccod "& vbCrLf &_
					"         	and a.area_ccod=g.area_ccod and a.tcar_ccod=1"& vbCrLf &_
					"         	and exists(select 1 from alumnos aa  "& vbCrLf &_
					"                    where aa.ofer_ncorr=c.ofer_ncorr and aa.emat_ccod <> 9 "& vbCrLf &_
					"                    and exists (select 1 from contratos cont1, compromisos comp1 "& vbCrLf &_
					"          where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr "& vbCrLf &_
					"          and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2))) "& vbCrLf &_
					"        )ttr "& vbCrLf &_
					" )table_a    "
    matriculados_loce=sql_indicador				
end function

Function matriculados_no_loce(anio)

	v_peri_ccod=conexion.consultaUno("select top 1 peri_ccod from periodos_academicos where anos_ccod="&anio&" and plec_ccod in (1,2) order by peri_ccod desc")

	sql_indicador=	"	 select  h.facu_ccod,facu_tdesc,sede_tdesc, e.carr_tdesc,g.jorn_tdesc,count(*) as total_alumnos_carrera, "& vbCrLf &_
					"			a.jorn_ccod,f.area_ccod,b.sede_ccod  "& vbCrLf &_   
					"		  from ofertas_academicas a left outer join sedes b "& vbCrLf &_    
					"			 on a.sede_ccod = b.sede_ccod "& vbCrLf &_    
					"		  left outer join alumnos c "& vbCrLf &_    
					"			 on a.ofer_ncorr  = c.ofer_ncorr "& vbCrLf &_    
					"		  left outer join especialidades d "& vbCrLf &_     
					"			 on a.espe_ccod   = d.espe_ccod "& vbCrLf &_
					"		  join carreras e "& vbCrLf &_
					"			 on d.carr_ccod= e.carr_ccod "& vbCrLf &_
					"			 and e.tcar_ccod=1 "& vbCrLf &_
					"		  join areas_academicas f "& vbCrLf &_
					"			on e.area_ccod=f.area_ccod "& vbCrLf &_
					"		  join facultades  h "& vbCrLf &_
					"			on f.facu_ccod=h.facu_ccod "& vbCrLf &_                
					"		  join jornadas g "& vbCrLf &_
					"			on a.jorn_ccod=g.jorn_ccod "& vbCrLf &_
					"		  where c.emat_ccod in (1,4,8,2,15,16)  and c.audi_tusuario not like '%ajunte matricula%'    "& vbCrLf &_
					"		  And c.pers_ncorr > 0     "& vbCrLf &_
					"		  and protic.afecta_estadistica(c.matr_ncorr) > 0     "& vbCrLf &_
					"		  and a.peri_ccod=protic.retorna_max_periodo_matricula(c.pers_ncorr,'"&v_peri_ccod&"',d.carr_ccod)    "& vbCrLf &_
					"		  and isnull(c.alum_nmatricula,0) not in (7777)  "& vbCrLf &_
					"		  and c.audi_tusuario not in ('Agregabase_saenzBeta2','AgregaBaseSaenzBeta2','AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42',    "& vbCrLf &_
						"						'AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno',    "& vbCrLf &_ 
						"						'AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65',     "& vbCrLf &_
						"						'AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99','AgregaNotaN',     "& vbCrLf &_
						"						'AgregaNotaProtix','AgregaNotaprotix1','Agreganotas_saenzBeta2','AgregaNotas46$','AgregaNotas46$Beta','AgregaNotas46$Beta2','AgregaNotasSaenzBeta2', "& vbCrLf &_    
						"						'Agregaprotix_saenzBeta2','AgregaProtixSaenzBeta2')     "& vbCrLf &_
						"	  group by h.facu_ccod,facu_tdesc,g.jorn_tdesc,f.area_ccod,b.sede_ccod,sede_tdesc,e.carr_tdesc,a.jorn_ccod "
					
    matriculados_no_loce=sql_indicador				
end function

Function postulantes(anio)
	sql_indicador=	" select area_ccod,sede_tdesc as sede,carr_tdesc as carrera,jorn_tdesc as jornada,matriculados,total_aprobados,total as total_postulantes, "& vbCrLf &_
					" cast(((cast(total_aprobados as decimal(5,2)) * 100) / total) as decimal (5,2)) as porcentaje_seleccion "& vbCrLf &_
					" from  "& vbCrLf &_
					"    ( "& vbCrLf &_
					"      select ttr.area_ccod,ttr.sede_ccod,ttr.sede_tdesc,ttr.carr_ccod,ttr.carr_tdesc,ttr.jorn_ccod,ttr.jorn_tdesc, "& vbCrLf &_
					"     (select count(distinct aa.pers_ncorr) "& vbCrLf &_
					"	   from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd "& vbCrLf &_
					"	   where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
					"			 and cc.anos_ccod = ttr.anos_ccod and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod "& vbCrLf &_
					"			 and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod <> 9 and bb.post_bnuevo='S' "& vbCrLf &_
					"			 and exists (select 1 from contratos cont1, compromisos comp1  "& vbCrLf &_
					"						 where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr  "& vbCrLf &_
					"						 and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2))) as matriculados, "& vbCrLf &_
					"      (select count(distinct pers_ncorr) "& vbCrLf &_
					"		from postulantes aa, detalle_postulantes bb, ofertas_academicas cc,especialidades dd, periodos_academicos ee "& vbCrLf &_
					"       where aa.post_ncorr=bb.post_ncorr and bb.ofer_ncorr=cc.ofer_ncorr and cc.espe_ccod=dd.espe_ccod "& vbCrLf &_
					"             and cc.peri_ccod=ee.peri_ccod and ee.anos_ccod=ttr.anos_ccod "& vbCrLf &_
					"             and cc.sede_ccod=ttr.sede_ccod and cc.jorn_ccod=ttr.jorn_ccod and dd.carr_ccod=ttr.carr_ccod "& vbCrLf &_
					"             and eepo_ccod=2 and aa.post_bnuevo='S') as total_aprobados, "& vbCrLf &_
					"		(select count(distinct pers_ncorr) "& vbCrLf &_
					"		 from postulantes aa, detalle_postulantes bb, ofertas_academicas cc,especialidades dd, periodos_academicos ee"& vbCrLf &_
					"        where aa.post_ncorr=bb.post_ncorr and bb.ofer_ncorr=cc.ofer_ncorr and cc.espe_ccod=dd.espe_ccod "& vbCrLf &_
					"              and cc.peri_ccod=ee.peri_ccod and ee.anos_ccod=ttr.anos_ccod and aa.post_bnuevo='S' "& vbCrLf &_
					"              and cc.sede_ccod=ttr.sede_ccod and cc.jorn_ccod=ttr.jorn_ccod and dd.carr_ccod=ttr.carr_ccod) as total "& vbCrLf &_
					"		  from  "& vbCrLf &_
					" 		  (  "& vbCrLf &_
					"       	 select distinct d.anos_ccod,a.area_ccod,e.sede_ccod,e.sede_tdesc,a.carr_ccod,a.carr_tdesc,  "& vbCrLf &_
					"		     f.jorn_ccod,f.jorn_tdesc  "& vbCrLf &_
					" 			 from carreras a, especialidades b, ofertas_academicas c, periodos_academicos d, sedes e, jornadas f "& vbCrLf &_
					" 			 where a.carr_ccod=b.carr_ccod and b.espe_ccod=c.espe_ccod and a.tcar_ccod=1"& vbCrLf &_
					" 			 and c.peri_ccod=d.peri_ccod and cast(d.anos_ccod as varchar)='"&anio&"' "& vbCrLf &_
					" 			 and c.sede_ccod=e.sede_ccod and c.jorn_ccod=f.jorn_ccod "& vbCrLf &_
					" 			 and exists(select 1 from detalle_postulantes aa  "& vbCrLf &_
			        "            where aa.ofer_ncorr=c.ofer_ncorr and aa.eepo_ccod = 2) "& vbCrLf &_
					" 			 and a.tcar_ccod=1 and c.post_bnuevo='S'"& vbCrLf &_ 
					"         )ttr "& vbCrLf &_          
					" )table_a     "

      
    postulantes=sql_indicador				
end function

Function vacantes(anio)
	sql_indicador=	" select area_ccod, sede_tdesc as sede,carr_tdesc as carrera, jorn_tdesc as jornada, matriculados, vacantes, "& vbCrLf &_
					" cast(((matriculados * 100.00) / vacantes ) as decimal (6,2)) as Demanda "& vbCrLf &_
					" from "& vbCrLf &_
					"    ( "& vbCrLf &_
					"    select area_ccod,sede_ccod, sede_tdesc,carr_ccod,carr_tdesc, jorn_ccod,jorn_tdesc,  sum(vacantes) as vacantes, sum(num_matriculados) as matriculados "& vbCrLf &_
					"    from "& vbCrLf &_
					"       (  "& vbCrLf &_
				    "        select distinct a.area_ccod, e.sede_ccod,e.sede_tdesc,a.carr_ccod,a.carr_tdesc,f.jorn_ccod,f.jorn_tdesc, "& vbCrLf &_
				    "        c.ofer_nvacantes as vacantes, (select count(distinct pers_ncorr) from alumnos aa where aa.ofer_ncorr=c.ofer_ncorr and aa.emat_ccod = 1) as num_matriculados  "& vbCrLf &_         
				    "        from carreras a, especialidades b, ofertas_academicas c, periodos_academicos d, sedes e, jornadas f "& vbCrLf &_
				    "        where a.carr_ccod=b.carr_ccod and b.espe_ccod=c.espe_ccod "& vbCrLf &_
				    "        and c.peri_ccod=d.peri_ccod and cast(d.anos_ccod as varchar)='"&anio&"' "& vbCrLf &_
				    "        and c.sede_ccod=e.sede_ccod and c.jorn_ccod=f.jorn_ccod "& vbCrLf &_
				    "        and a.tcar_ccod=1 and c.post_bnuevo='S'  "& vbCrLf &_
				    "        and exists(select 1 from alumnos aa  "& vbCrLf &_
					"                   where aa.ofer_ncorr=c.ofer_ncorr and aa.emat_ccod = 1 "& vbCrLf &_
				    "                   and exists (select 1 from contratos cont1, compromisos comp1 "& vbCrLf &_
				    "    where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr "& vbCrLf &_
					"    and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2))) "& vbCrLf &_
				    " )aaa  "& vbCrLf &_            
					" group by area_ccod,sede_ccod,sede_tdesc,carr_ccod,carr_tdesc,jorn_ccod,jorn_tdesc "& vbCrLf &_
					" )tabla_a "
    vacantes=sql_indicador				
end function

Function vacantes_ofertas(anio)

	if anio>="2007" then

	sql_indicador=   " select area_ccod, sede_tdesc as sede,carr_tdesc as carrera, jorn_tdesc as jornada,  "& vbCrLf &_
					  " antiguos, nuevos, vacantes_nuevos, vacantes_antiguos,   "& vbCrLf &_
					  " case when vacantes_nuevos=0 then 0 else cast(((nuevos * 100.00) / vacantes_nuevos ) as decimal (8,2)) end as indicador_nuevos, "& vbCrLf &_
					  " case when vacantes_antiguos=0 then 0 else cast(((antiguos * 100.00) / vacantes_antiguos ) as decimal (8,2)) end as indicador_antiguos "& vbCrLf &_
					  " from    "& vbCrLf &_
					  "	 ( select *,protic.obtener_alumnos_escuela(zz.sede_ccod,zz.carr_ccod,zz.jorn_ccod,zz.peri_ccod,'S') as nuevos ,   "& vbCrLf &_           
						"	protic.obtener_alumnos_escuela(zz.sede_ccod,zz.carr_ccod,zz.jorn_ccod,zz.peri_ccod,'N') as antiguos    "& vbCrLf &_
						" 	from (  "& vbCrLf &_
						" 	  	select  distinct a.area_ccod , max(d.peri_ccod) as peri_ccod,e.sede_ccod,e.sede_tdesc,a.carr_ccod,a.carr_tdesc,f.jorn_ccod, f.jorn_tdesc,  "& vbCrLf &_   
	 					" 		isnull(vacantes_nuevos,0) as vacantes_nuevos, isnull(vacantes_antiguos,0) as vacantes_antiguos "& vbCrLf &_
						"		 from carreras a  "& vbCrLf &_
						"		 join especialidades b "& vbCrLf &_
						"			on a.carr_ccod=b.carr_ccod   "& vbCrLf &_
						"		 join ofertas_academicas c "& vbCrLf &_
						"			on b.espe_ccod=c.espe_ccod "& vbCrLf &_
						"		 join periodos_academicos d "& vbCrLf &_
						"			on c.peri_ccod=d.peri_ccod  "& vbCrLf &_
						"			and cast(d.anos_ccod as varchar)='"&anio&"'    "& vbCrLf &_
						"		 join sedes e "& vbCrLf &_
						"			on c.sede_ccod=e.sede_ccod "& vbCrLf &_
						"		 join jornadas f   "& vbCrLf &_
						"			on c.jorn_ccod=f.jorn_ccod "& vbCrLf &_
						"		 left outer join estructura_indicador_ofertas g "& vbCrLf &_
						"			on  c.jorn_ccod=g.jornada "& vbCrLf &_
						"			and c.sede_ccod=g.sede "& vbCrLf &_
						"			and b.carr_ccod=g.cod_carrera   "& vbCrLf &_
						"			and cast(g.admision as varchar)='"&v_anos&"' "& vbCrLf &_
						"		 where a.tcar_ccod=1   "& vbCrLf &_
					    "           group by a.area_ccod,e.sede_ccod,e.sede_tdesc,a.carr_ccod,a.carr_tdesc,f.jorn_ccod,f.jorn_tdesc,vacantes_nuevos,vacantes_antiguos "& vbCrLf &_
            			"	 ) zz "& vbCrLf &_
					  " )tabla_a   "					  
	
	else
		sql_indicador=	" select admision,sede_tdesc as sede, facultad,carrera,jorn_tdesc as jornada, "& vbCrLf &_
						"	nuevos, antiguos, vacantes_nuevos, vacantes_antiguos, "& vbCrLf &_
						" case when vacantes_nuevos=0 then 0 else cast(((nuevos * 100.00) / vacantes_nuevos ) as decimal (8,2)) end as indicador_nuevos, "& vbCrLf &_
					  	" case when vacantes_antiguos=0 then 0 else cast(((antiguos * 100.00) / vacantes_antiguos ) as decimal (8,2)) end as indicador_antiguos "& vbCrLf &_
						"	from estructura_ofertas_antiguas a "& vbCrLf &_
						"	left outer join carreras b "& vbCrLf &_
						"		on a.cod_carrera=b.carr_ccod "& vbCrLf &_
						"	join  jornadas c "& vbCrLf &_
						"		on a.jornada=c.jorn_ccod "& vbCrLf &_
						"	join sedes d "& vbCrLf &_
						"		on a.sede=d.sede_ccod "& vbCrLf &_
						"		where cast(admision as varchar)='"&anio&"' "
	end if	
    vacantes_ofertas=sql_indicador				
end function 


Function alumnos_nuevos(anio)
	sql_indicador=	" select area_ccod,sede_tdesc as sede,carr_tdesc as carrera, jorn_tdesc as jornada, "& vbCrLf &_
					" total_carrera,total_hombres_carrera, "& vbCrLf &_
					" cast(((cast(total_hombres_carrera as decimal(5,2)) * 100) / total_carrera) as decimal(5,2)) as porc_hombres, "& vbCrLf &_
					" total_mujeres_carrera, "& vbCrLf &_
					" cast(((cast(total_mujeres_carrera as decimal(5,2)) * 100) / total_carrera) as decimal(5,2)) as porc_mujeres, "& vbCrLf &_
					" total_extranjeros_carrera, "& vbCrLf &_
					" cast(((cast(total_extranjeros_carrera as decimal(5,2)) * 100) / total_carrera) as decimal(5,2)) as porc_extranjeros "& vbCrLf &_
					" from "& vbCrLf &_
					"     ( "& vbCrLf &_
					"     select ttr.area_ccod, ttr.sede_ccod,ttr.sede_tdesc,ttr.carr_ccod,ttr.carr_tdesc,ttr.jorn_ccod,ttr.jorn_tdesc, "& vbCrLf &_
				    "     (select count(distinct aa.pers_ncorr) from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd "& vbCrLf &_
				    "      where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
				    "     and cc.anos_ccod = ttr.anos_ccod and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod "& vbCrLf &_
				    "     and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod <> 9 and bb.post_bnuevo='S'"& vbCrLf &_
					"     and exists (select 1 from contratos cont1, compromisos comp1 "& vbCrLf &_
				    "                 where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr "& vbCrLf &_
					"                 and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2))) as total_carrera, "& vbCrLf &_
					"     (select count(distinct aa.pers_ncorr) from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd,personas ee "& vbCrLf &_
					"     where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
				    "     and cc.anos_ccod = ttr.anos_ccod and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod "& vbCrLf &_
				    "     and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod <> 9 and aa.pers_ncorr=ee.pers_ncorr and ee.sexo_ccod=1 and bb.post_bnuevo='S'"& vbCrLf &_
				    "     and exists (select 1 from contratos cont1, compromisos comp1  "& vbCrLf &_
					"                 where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr "& vbCrLf &_
					"                 and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2))) as total_hombres_carrera,"& vbCrLf &_
				    "    (select count(distinct aa.pers_ncorr) from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd,personas ee "& vbCrLf &_
				    "     where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
					"     and cc.anos_ccod = ttr.anos_ccod and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod "& vbCrLf &_
				    "     and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod <> 9 and aa.pers_ncorr=ee.pers_ncorr and ee.sexo_ccod=2 and bb.post_bnuevo='S'"& vbCrLf &_
					"     and exists (select 1 from contratos cont1, compromisos comp1  "& vbCrLf &_
				    "                 where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr "& vbCrLf &_
					"                 and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2))) as total_mujeres_carrera, "& vbCrLf &_
				    "    (select count(distinct aa.pers_ncorr) from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd,personas ee "& vbCrLf &_
				    "     where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
				    "     and cc.anos_ccod = ttr.anos_ccod and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod "& vbCrLf &_
				    "     and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod <> 9 and aa.pers_ncorr=ee.pers_ncorr and isnull(ee.pais_ccod,1) <> 1 and bb.post_bnuevo='S'"& vbCrLf &_
     				"     ) as total_extranjeros_carrera                                                  "& vbCrLf &_
				    "		  from  "& vbCrLf &_
					" 		  (  "& vbCrLf &_
					"       	 select distinct d.anos_ccod,a.area_ccod,e.sede_ccod,e.sede_tdesc,a.carr_ccod,a.carr_tdesc,  "& vbCrLf &_
					"		     f.jorn_ccod,f.jorn_tdesc  "& vbCrLf &_
					"    		 from carreras a, especialidades b, ofertas_academicas c, periodos_academicos d, sedes e, jornadas f "& vbCrLf &_
				    "   		 where a.carr_ccod=b.carr_ccod and b.espe_ccod=c.espe_ccod "& vbCrLf &_
				    "    		 and c.peri_ccod=d.peri_ccod and cast(d.anos_ccod as varchar)='"&anio&"' "& vbCrLf &_
				    "    		 and c.sede_ccod=e.sede_ccod and c.jorn_ccod=f.jorn_ccod "& vbCrLf &_
				    "    		 and a.tcar_ccod=1 and c.post_bnuevo='S'  "& vbCrLf &_
				    "    		 and exists(select 1 from alumnos aa  "& vbCrLf &_
					"                       where aa.ofer_ncorr=c.ofer_ncorr and aa.emat_ccod <> 9 "& vbCrLf &_
					"                       and exists (select 1 from contratos cont1, compromisos comp1  "& vbCrLf &_
				    "                                   where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr  "& vbCrLf &_
				    "                       and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2))) "& vbCrLf &_
					"         )ttr "& vbCrLf &_
					" )tabla_a "
					
    alumnos_nuevos =sql_indicador				
end function

Function formacion_fundamental(anio)
	sql_indicador=	" select sede_tdesc as sede,carr_tdesc as carrera, jorn_tdesc as jornada, "& vbCrLf &_
					" total_asignaturas, total_FF "& vbCrLf &_
					" from "& vbCrLf &_
					" ( "& vbCrLf &_
				    "    select distinct e.sede_ccod,e.sede_tdesc,a.carr_ccod,a.carr_tdesc,f.jorn_ccod,f.jorn_tdesc, "& vbCrLf &_
				    "    (select count(distinct cc.asig_ccod) from secciones aa,periodos_academicos bb, asignaturas cc  "& vbCrLf &_
				    "     where aa.peri_ccod=bb.peri_ccod and bb.anos_ccod=d.anos_ccod and aa.asig_ccod=cc.asig_ccod "& vbCrLf &_
			 	    "     and aa.sede_ccod=e.sede_ccod and aa.jorn_ccod=f.jorn_ccod and aa.carr_ccod=a.carr_ccod "& vbCrLf &_
 					"     and exists(select 1 from cargas_academicas dd where aa.secc_ccod=dd.secc_ccod)) as total_asignaturas, "& vbCrLf &_
				    "    (select count(distinct cc.asig_ccod) "& vbCrLf &_
				    "     from secciones aa,periodos_academicos bb, asignaturas cc  "& vbCrLf &_
				    "     where aa.peri_ccod=bb.peri_ccod and bb.anos_ccod=d.anos_ccod and aa.asig_ccod=cc.asig_ccod "& vbCrLf &_
				    "     and aa.sede_ccod=e.sede_ccod and aa.jorn_ccod=f.jorn_ccod and aa.carr_ccod=a.carr_ccod and cc.area_ccod=1 "& vbCrLf &_
				    "     and exists(select 1 from cargas_academicas dd where aa.secc_ccod=dd.secc_ccod)) as total_FF "& vbCrLf &_                                           
				    "     from carreras a, especialidades b, ofertas_academicas c, periodos_academicos d, sedes e, jornadas f "& vbCrLf &_
				    "     where a.carr_ccod=b.carr_ccod and b.espe_ccod=c.espe_ccod "& vbCrLf &_
				    "     and c.peri_ccod=d.peri_ccod and cast(d.anos_ccod as varchar)='"&anio&"' "& vbCrLf &_
				    "     and c.sede_ccod=e.sede_ccod and c.jorn_ccod=f.jorn_ccod "& vbCrLf &_
					"     and a.tcar_ccod=1 and c.post_bnuevo='S'  "& vbCrLf &_
				    "     and exists(select 1 from secciones aa,periodos_academicos bb, cargas_academicas cc  "& vbCrLf &_
					"                where aa.peri_ccod=bb.peri_ccod and bb.anos_ccod=d.anos_ccod and aa.secc_Ccod=cc.secc_ccod "& vbCrLf &_
					"                and aa.sede_ccod=e.sede_ccod and aa.jorn_ccod=f.jorn_ccod and aa.carr_ccod=a.carr_ccod) "& vbCrLf &_
					" )tabla_a "
    formacion_fundamental=sql_indicador				
end function

Function desercion(anio)
	sql_indicador=	" select area_ccod,sede_tdesc as sede,carr_tdesc as carrera,jorn_tdesc as jornada, "& vbCrLf &_
					" total_alumnos_carrera, "& vbCrLf &_
					" total_abandonos_carrera as total_abandonos_carrera, "& vbCrLf &_
					" total_retiros_carrera as total_retiros_carrera, "& vbCrLf &_
					" total_eliminados_carrera as total_eliminados_carrera, "& vbCrLf &_
					" total_cambios_carrera as total_cambios_carrera, "& vbCrLf &_
					" total_abandonos_carrera as abandonos_temp, total_retiros_carrera as retiros_temp, total_eliminados_carrera as eliminados_temp, total_cambios_carrera as cambios_temp,"& vbCrLf &_
					" '<center><strong>' + cast((cast((((total_abandonos_carrera + total_retiros_carrera + total_eliminados_carrera + total_cambios_carrera) * 100.00 ) / total_alumnos_carrera) as decimal (5,2)))as varchar) + '</strong></center>' as porcentaje "& vbCrLf &_
					" from  "& vbCrLf &_
					"    ( "& vbCrLf &_
					"     select ttr.area_ccod,ttr.anos_ccod,ttr.sede_ccod,ttr.sede_tdesc,ttr.carr_ccod,ttr.carr_tdesc,ttr.jorn_ccod,ttr.jorn_tdesc, "& vbCrLf &_
					"     (select count(distinct aa.pers_ncorr) from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd "& vbCrLf &_
					"      where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
					"      and cc.anos_ccod = ttr.anos_ccod and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod "& vbCrLf &_
					"      and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod <> 9 and isnull(aa.talu_ccod,1) <> 3  and isnull(aa.talu_ccod,1) <> 3 "& vbCrLf &_
					"      and exists (select 1 from contratos cont1, compromisos comp1  "& vbCrLf &_
					"                  where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr "& vbCrLf &_
					"      and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2))) as total_alumnos_carrera, "& vbCrLf &_
					"      (select count(distinct pers_ncorr) "& vbCrLf &_
					"      from "& vbCrLf &_
					"      ( "& vbCrLf &_
					"        select distinct aa.pers_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd "& vbCrLf &_
					"		 where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
					"		 and cc.anos_ccod = ttr.anos_ccod and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod "& vbCrLf &_
					"		 and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod = 14  and isnull(aa.talu_ccod,1) <> 3 "& vbCrLf &_
					"		 and exists (select 1 from contratos cont1, compromisos comp1  "& vbCrLf &_
					"					 where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr "& vbCrLf &_
					"					 and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2)) "& vbCrLf &_
					"		 union "& vbCrLf &_
					"		 select distinct aa.pers_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd "& vbCrLf &_
					"		 where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
					"		 and cc.anos_ccod = ttr.anos_ccod and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod "& vbCrLf &_
					"		 and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod = 14 and cc.plec_ccod <> 1  and isnull(aa.talu_ccod,1) <> 3 "& vbCrLf &_
					"		 and not exists (select 1 from contratos cont1, compromisos comp1  "& vbCrLf &_

					"					 where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr "& vbCrLf &_
					"					 and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2)) "& vbCrLf &_
				    "         union "& vbCrLf &_
					"         select distinct aa.pers_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd "& vbCrLf &_
				    "         where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
					"         and cc.anos_ccod = (ttr.anos_ccod + 1) and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod "& vbCrLf &_
					"         and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod = 14 and cc.plec_ccod=1 and aa.alum_nmatricula = '7777'  and isnull(aa.talu_ccod,1) <> 3 "& vbCrLf &_
					"      ) as tablilla "& vbCrLf &_
					"		 where not exists ( select 1 from alumnos aa, ofertas_academicas bb,especialidades dd "& vbCrLf &_
		            "                           where aa.pers_ncorr=tablilla.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr "& vbCrLf &_
                    "						    and bb.peri_ccod > tablilla.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
                    "						    and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod and dd.carr_ccod=ttr.carr_ccod "& vbCrLf &_
					"                           and aa.emat_ccod = 1) "& vbCrLf &_
					"         ) as total_abandonos_carrera, "& vbCrLf &_
					" (select count(distinct pers_ncorr) "& vbCrLf &_
					"  from  "& vbCrLf &_
				    "     ( "& vbCrLf &_
					"        select distinct aa.pers_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd "& vbCrLf &_
					"		 where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
					"		 and cc.anos_ccod = ttr.anos_ccod and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod "& vbCrLf &_
					"		 and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod = 3  and isnull(aa.talu_ccod,1) <> 3 "& vbCrLf &_
					"		 and exists (select 1 from contratos cont1, compromisos comp1  "& vbCrLf &_
					"					 where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr "& vbCrLf &_
					"					 and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2)) "& vbCrLf &_
					"		 union "& vbCrLf &_
					"		 select distinct aa.pers_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd "& vbCrLf &_
					"		 where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
					"		 and cc.anos_ccod = ttr.anos_ccod and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod "& vbCrLf &_
					"		 and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod = 3 and cc.plec_ccod <> 1  and isnull(aa.talu_ccod,1) <> 3"& vbCrLf &_
					"		 and not exists (select 1 from contratos cont1, compromisos comp1  "& vbCrLf &_
					"					 where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr "& vbCrLf &_
					"					 and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2)) "& vbCrLf &_
				    "         union "& vbCrLf &_
					"         select distinct aa.pers_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd "& vbCrLf &_
					"         where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
			 	    "         and cc.anos_ccod = (ttr.anos_ccod + 1) and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod "& vbCrLf &_
				    "         and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod = 3 and cc.plec_ccod=1 and aa.alum_nmatricula = '7777'  and isnull(aa.talu_ccod,1) <> 3 "& vbCrLf &_
				    "      ) as tablilla "& vbCrLf &_
					"		 where not exists ( select 1 from alumnos aa, ofertas_academicas bb,especialidades dd "& vbCrLf &_
		            "                           where aa.pers_ncorr=tablilla.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr "& vbCrLf &_
                    "						    and bb.peri_ccod > tablilla.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
                    "						    and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod and dd.carr_ccod=ttr.carr_ccod "& vbCrLf &_
					"                           and aa.emat_ccod = 1) "& vbCrLf &_
					" ) as total_retiros_carrera, "& vbCrLf &_
					" (select count(distinct pers_ncorr) "& vbCrLf &_
					" from "& vbCrLf &_
				    "     ( "& vbCrLf &_
					"        select distinct aa.pers_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd "& vbCrLf &_
					"		 where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
					"		 and cc.anos_ccod = ttr.anos_ccod and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod "& vbCrLf &_
					"		 and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod = 5  and isnull(aa.talu_ccod,1) <> 3 "& vbCrLf &_
					"		 and exists (select 1 from contratos cont1, compromisos comp1  "& vbCrLf &_
					"					 where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr "& vbCrLf &_
					"					 and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2)) "& vbCrLf &_
					"		 union "& vbCrLf &_
					"		 select distinct aa.pers_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd "& vbCrLf &_
					"		 where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
					"		 and cc.anos_ccod = ttr.anos_ccod and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod "& vbCrLf &_
					"		 and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod = 5 and cc.plec_ccod <> 1  and isnull(aa.talu_ccod,1) <> 3 "& vbCrLf &_
					"		 and not exists (select 1 from contratos cont1, compromisos comp1  "& vbCrLf &_
					"					     where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr "& vbCrLf &_
					"					     and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2)) "& vbCrLf &_
					"         union "& vbCrLf &_
					"         select distinct aa.pers_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd "& vbCrLf &_
				    "         where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
				    "         and cc.anos_ccod = (ttr.anos_ccod + 1) and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod "& vbCrLf &_
				    "         and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod = 5 and cc.plec_ccod=1 and aa.alum_nmatricula = '7777' and isnull(aa.talu_ccod,1) <> 3 "& vbCrLf &_
				    "      ) as tablilla "& vbCrLf &_
					"		 where not exists ( select 1 from alumnos aa, ofertas_academicas bb,especialidades dd "& vbCrLf &_
		            "                           where aa.pers_ncorr=tablilla.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr "& vbCrLf &_
                    "						    and bb.peri_ccod > tablilla.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
                    "						    and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod and dd.carr_ccod=ttr.carr_ccod "& vbCrLf &_
					"                           and aa.emat_ccod = 1) "& vbCrLf &_
					" ) as total_eliminados_carrera, "& vbCrLf &_
					" (select count(distinct pers_ncorr) "& vbCrLf &_
					" from "& vbCrLf &_
				    "     ( "& vbCrLf &_
					"        select distinct aa.pers_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd "& vbCrLf &_
					"		 where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
					"		 and cc.anos_ccod = ttr.anos_ccod and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod "& vbCrLf &_
					"		 and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod = 6 and isnull(aa.talu_ccod,1) <> 3 "& vbCrLf &_
					"		 and exists (select 1 from contratos cont1, compromisos comp1  "& vbCrLf &_
					"					 where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr "& vbCrLf &_
					"					 and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2)) "& vbCrLf &_
					"		 union "& vbCrLf &_
					"		 select distinct aa.pers_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd "& vbCrLf &_
					"		 where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
					"		 and cc.anos_ccod = ttr.anos_ccod and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod "& vbCrLf &_
					"		 and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod = 6 and cc.plec_ccod <> 1 and isnull(aa.talu_ccod,1) <> 3 "& vbCrLf &_
					"		 and not exists (select 1 from contratos cont1, compromisos comp1  "& vbCrLf &_
					"					     where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr "& vbCrLf &_
					"					     and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2)) "& vbCrLf &_
					"         union "& vbCrLf &_
					"         select distinct aa.pers_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd "& vbCrLf &_
				    "         where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
				    "         and cc.anos_ccod = (ttr.anos_ccod + 1) and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod "& vbCrLf &_
				    "         and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod = 6 and cc.plec_ccod=1 and aa.alum_nmatricula = '7777' and isnull(aa.talu_ccod,1) <> 3 "& vbCrLf &_
				    "      ) as tablilla "& vbCrLf &_
					"		 where not exists ( select 1 from alumnos aa, ofertas_academicas bb,especialidades dd "& vbCrLf &_
		            "                           where aa.pers_ncorr=tablilla.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr "& vbCrLf &_
                    "						    and bb.peri_ccod > tablilla.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
                    "						    and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod and dd.carr_ccod=ttr.carr_ccod "& vbCrLf &_
					"                           and aa.emat_ccod = 1) "& vbCrLf &_
					" ) as total_cambios_carrera "& vbCrLf &_
					" from  "& vbCrLf &_
					" (  "& vbCrLf &_
					"	 select distinct d.anos_ccod,a.area_ccod,e.sede_ccod,e.sede_tdesc,a.carr_ccod,a.carr_tdesc,  "& vbCrLf &_
					"					 f.jorn_ccod,f.jorn_tdesc  "& vbCrLf &_
					" 		from carreras a, especialidades b, ofertas_academicas c, periodos_academicos d, sedes e, jornadas f "& vbCrLf &_
					" 		where a.carr_ccod=b.carr_ccod and b.espe_ccod=c.espe_ccod "& vbCrLf &_
					" 		and c.peri_ccod=d.peri_ccod and cast(d.anos_ccod as varchar)='"&anio&"' "& vbCrLf &_
					" 		and c.sede_ccod=e.sede_ccod and c.jorn_ccod=f.jorn_ccod and a.tcar_ccod=1"& vbCrLf &_
					" 		and exists(select 1 from alumnos aa  "& vbCrLf &_
					"           where aa.ofer_ncorr=c.ofer_ncorr and aa.emat_ccod <> 9 "& vbCrLf &_
					"           and exists (select 1 from contratos cont1, compromisos comp1  "& vbCrLf &_
					"           where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr  "& vbCrLf &_
					"           and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2))) "& vbCrLf &_
					" )ttr "& vbCrLf &_
					" )table_a      "
    desercion=sql_indicador				
end function

Function desercion_nuevos(anio)
	sql_indicador=	" select area_ccod,sede_tdesc as sede,carr_tdesc as carrera,jorn_tdesc as jornada, "& vbCrLf &_
					" total_alumnos_carrera, "& vbCrLf &_
					" total_abandonos_carrera as total_abandonos_carrera, "& vbCrLf &_
					" total_retiros_carrera as total_retiros_carrera, "& vbCrLf &_
					" total_eliminados_carrera as total_eliminados_carrera, "& vbCrLf &_
					" total_cambios_carrera as total_cambios_carrera, "& vbCrLf &_
					" total_abandonos_carrera as abandonos_temp, total_retiros_carrera as retiros_temp, total_eliminados_carrera as eliminados_temp,  total_cambios_carrera as cambios_temp,"& vbCrLf &_
					" '<center><strong>'+cast((cast((((total_abandonos_carrera + total_retiros_carrera + total_eliminados_carrera + total_cambios_carrera) * 100.00 ) / case total_alumnos_carrera when 0 then 1 else total_alumnos_carrera end ) as decimal (5,2))) as varchar)+ '</strong></center>' as porcentaje "& vbCrLf &_
					" from  "& vbCrLf &_
					"    ( "& vbCrLf &_
					"     select ttr.area_ccod,ttr.anos_ccod,ttr.sede_ccod,ttr.sede_tdesc,ttr.carr_ccod,ttr.carr_tdesc,ttr.jorn_ccod,ttr.jorn_tdesc, "& vbCrLf &_
					"     (select count(distinct aa.pers_ncorr) from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd "& vbCrLf &_
					"      where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
					"      and cc.anos_ccod = ttr.anos_ccod and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod "& vbCrLf &_
					"      and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod <> 9  and bb.post_bnuevo='S' and isnull(aa.talu_ccod,1) <> 3 "& vbCrLf &_
					"      and exists (select 1 from contratos cont1, compromisos comp1  "& vbCrLf &_
					"                  where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr "& vbCrLf &_
					"      and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2))) as total_alumnos_carrera, "& vbCrLf &_
					"      (select count(distinct pers_ncorr) "& vbCrLf &_
					"      from "& vbCrLf &_
					"      ( "& vbCrLf &_
					"        select distinct aa.pers_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd  "& vbCrLf &_
					"		 where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod  "& vbCrLf &_
					"		 and cc.anos_ccod = ttr.anos_ccod and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod  "& vbCrLf &_
					"		 and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod = 14  "& vbCrLf &_
					"		 and exists (select 1 from alumnos aaa, ofertas_academicas bbb, periodos_academicos ccc, especialidades ddd  "& vbCrLf &_
					"					 where aaa.pers_ncorr=aa.pers_ncorr and aaa.ofer_ncorr=bbb.ofer_ncorr and bbb.peri_ccod=ccc.peri_ccod  "& vbCrLf &_
					"					 and bbb.espe_ccod=ddd.espe_ccod and ccc.anos_ccod = ttr.anos_ccod and bbb.sede_ccod=ttr.sede_ccod  "& vbCrLf &_
					"					 and bbb.jorn_ccod=ttr.jorn_ccod and ddd.carr_ccod=ttr.carr_ccod and bbb.post_bnuevo='S'  and isnull(aaa.talu_ccod,1) <> 3 )  "& vbCrLf &_
					"		 and exists (select 1 from contratos cont1, compromisos comp1   "& vbCrLf &_
					"									 where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr  "& vbCrLf &_
					"									 and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2)) "& vbCrLf &_
					"		 union  "& vbCrLf &_
					"		 select distinct aa.pers_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd  "& vbCrLf &_
					"		 where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod  "& vbCrLf &_
					"		 and cc.anos_ccod = ttr.anos_ccod and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod  "& vbCrLf &_
					"		 and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod = 14 and cc.plec_ccod <> 1  "& vbCrLf &_
					"		 and exists (select 1 from alumnos aaa, ofertas_academicas bbb, periodos_academicos ccc, especialidades ddd   "& vbCrLf &_
					"					 where aaa.pers_ncorr=aa.pers_ncorr and aaa.ofer_ncorr=bbb.ofer_ncorr and bbb.peri_ccod=ccc.peri_ccod  "& vbCrLf &_
					"					 and bbb.espe_ccod=ddd.espe_ccod and ccc.anos_ccod = ttr.anos_ccod and bbb.sede_ccod=ttr.sede_ccod  "& vbCrLf &_
					"					 and bbb.jorn_ccod=ttr.jorn_ccod and ddd.carr_ccod=ttr.carr_ccod and bbb.post_bnuevo='S' and isnull(aaa.talu_ccod,1) <> 3 )  "& vbCrLf &_
					"		 and not exists (select 1 from contratos cont1, compromisos comp1   "& vbCrLf &_
					"									 where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr  "& vbCrLf &_
					"									 and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2)) "& vbCrLf &_
					"		 union  "& vbCrLf &_
					"        select distinct aa.pers_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd "& vbCrLf &_
				    "        where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
					"        and cc.anos_ccod = (ttr.anos_ccod + 1) and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod "& vbCrLf &_
					"        and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod = 14 and cc.plec_ccod=1 and aa.alum_nmatricula = '7777' "& vbCrLf &_
					"        and exists (select 1 from alumnos aaa, ofertas_academicas bbb, periodos_academicos ccc, especialidades ddd "& vbCrLf &_
                    "                     where aaa.pers_ncorr=aa.pers_ncorr and aaa.ofer_ncorr=bbb.ofer_ncorr and bbb.peri_ccod=ccc.peri_ccod "& vbCrLf &_
                    "                     and bbb.espe_ccod=ddd.espe_ccod and ccc.anos_ccod = ttr.anos_ccod and bbb.sede_ccod=ttr.sede_ccod "& vbCrLf &_
                    "                     and bbb.jorn_ccod=ttr.jorn_ccod and ddd.carr_ccod=ttr.carr_ccod and bbb.post_bnuevo='S' and isnull(aaa.talu_ccod,1) <> 3 ) "& vbCrLf &_
					"      ) as tablilla "& vbCrLf &_
					"		 where not exists ( select 1 from alumnos aa, ofertas_academicas bb,especialidades dd "& vbCrLf &_
		            "                           where aa.pers_ncorr=tablilla.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr "& vbCrLf &_
                    "						    and bb.peri_ccod > tablilla.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
                    "						    and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod and dd.carr_ccod=ttr.carr_ccod "& vbCrLf &_
					"                           and aa.emat_ccod = 1) "& vbCrLf &_
					"         ) as total_abandonos_carrera, "& vbCrLf &_
					" (select count(distinct pers_ncorr) "& vbCrLf &_
					"  from  "& vbCrLf &_
				    "     ( "& vbCrLf &_
					"        select distinct aa.pers_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd  "& vbCrLf &_
					"		 where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod  "& vbCrLf &_
					"		 and cc.anos_ccod = ttr.anos_ccod and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod  "& vbCrLf &_
					"		 and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod = 3 "& vbCrLf &_
					"		 and exists (select 1 from alumnos aaa, ofertas_academicas bbb, periodos_academicos ccc, especialidades ddd  "& vbCrLf &_
					"					 where aaa.pers_ncorr=aa.pers_ncorr and aaa.ofer_ncorr=bbb.ofer_ncorr and bbb.peri_ccod=ccc.peri_ccod  "& vbCrLf &_
					"					 and bbb.espe_ccod=ddd.espe_ccod and ccc.anos_ccod = ttr.anos_ccod and bbb.sede_ccod=ttr.sede_ccod  "& vbCrLf &_
					"					 and bbb.jorn_ccod=ttr.jorn_ccod and ddd.carr_ccod=ttr.carr_ccod and bbb.post_bnuevo='S' and isnull(aaa.talu_ccod,1) <> 3 )  "& vbCrLf &_
					"		 and exists (select 1 from contratos cont1, compromisos comp1   "& vbCrLf &_
					"									 where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr  "& vbCrLf &_
					"									 and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2)) "& vbCrLf &_
					"		 union  "& vbCrLf &_
					"		 select distinct aa.pers_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd  "& vbCrLf &_
					"		 where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod  "& vbCrLf &_
					"		 and cc.anos_ccod = ttr.anos_ccod and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod  "& vbCrLf &_
					"		 and dd.carr_ccod = ttr.carr_ccod and aa.emat_ccod = 3 and cc.plec_ccod <> 1  "& vbCrLf &_
					"		 and exists (select 1 from alumnos aaa, ofertas_academicas bbb, periodos_academicos ccc, especialidades ddd   "& vbCrLf &_
					"					 where aaa.pers_ncorr=aa.pers_ncorr and aaa.ofer_ncorr=bbb.ofer_ncorr and bbb.peri_ccod=ccc.peri_ccod  "& vbCrLf &_
					"					 and bbb.espe_ccod=ddd.espe_ccod and ccc.anos_ccod = ttr.anos_ccod and bbb.sede_ccod=ttr.sede_ccod  "& vbCrLf &_
					"					 and bbb.jorn_ccod=ttr.jorn_ccod and ddd.carr_ccod=ttr.carr_ccod and bbb.post_bnuevo='S' and isnull(aaa.talu_ccod,1) <> 3 )  "& vbCrLf &_
					"		 and not exists (select 1 from contratos cont1, compromisos comp1   "& vbCrLf &_
					"									 where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr  "& vbCrLf &_
					"									 and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2)) "& vbCrLf &_
				    "         union "& vbCrLf &_
					"         select distinct aa.pers_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd "& vbCrLf &_
					"         where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
			 	    "         and cc.anos_ccod = (ttr.anos_ccod + 1) and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod "& vbCrLf &_
				    "         and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod = 3 and cc.plec_ccod=1 and aa.alum_nmatricula = '7777' "& vbCrLf &_
					"         and exists (select 1 from alumnos aaa, ofertas_academicas bbb, periodos_academicos ccc, especialidades ddd "& vbCrLf &_
                    "                     where aaa.pers_ncorr=aa.pers_ncorr and aaa.ofer_ncorr=bbb.ofer_ncorr and bbb.peri_ccod=ccc.peri_ccod "& vbCrLf &_
                    "                     and bbb.espe_ccod=ddd.espe_ccod and ccc.anos_ccod = ttr.anos_ccod and bbb.sede_ccod=ttr.sede_ccod "& vbCrLf &_
                    "                     and bbb.jorn_ccod=ttr.jorn_ccod and ddd.carr_ccod=ttr.carr_ccod and bbb.post_bnuevo='S' and isnull(aaa.talu_ccod,1) <> 3 ) "& vbCrLf &_
				    "      ) as tablilla "& vbCrLf &_
					"		 where not exists ( select 1 from alumnos aa, ofertas_academicas bb,especialidades dd "& vbCrLf &_
		            "                           where aa.pers_ncorr=tablilla.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr "& vbCrLf &_
                    "						    and bb.peri_ccod > tablilla.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
                    "						    and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod and dd.carr_ccod=ttr.carr_ccod "& vbCrLf &_
					"                           and aa.emat_ccod = 1) "& vbCrLf &_
					" ) as total_retiros_carrera, "& vbCrLf &_
					" (select count(distinct pers_ncorr) "& vbCrLf &_
					" from "& vbCrLf &_
				    "     ( "& vbCrLf &_
		            "        select distinct aa.pers_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd  "& vbCrLf &_
					"		 where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod  "& vbCrLf &_
					"		 and cc.anos_ccod = ttr.anos_ccod and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod  "& vbCrLf &_
					"		 and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod = 5  "& vbCrLf &_
					"		 and exists (select 1 from alumnos aaa, ofertas_academicas bbb, periodos_academicos ccc, especialidades ddd  "& vbCrLf &_
					"					 where aaa.pers_ncorr=aa.pers_ncorr and aaa.ofer_ncorr=bbb.ofer_ncorr and bbb.peri_ccod=ccc.peri_ccod  "& vbCrLf &_
					"					 and bbb.espe_ccod=ddd.espe_ccod and ccc.anos_ccod = ttr.anos_ccod and bbb.sede_ccod=ttr.sede_ccod  "& vbCrLf &_
					"					 and bbb.jorn_ccod=ttr.jorn_ccod and ddd.carr_ccod=ttr.carr_ccod and bbb.post_bnuevo='S' and isnull(aaa.talu_ccod,1) <> 3 )  "& vbCrLf &_
					"		 and exists (select 1 from contratos cont1, compromisos comp1   "& vbCrLf &_
					"									 where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr  "& vbCrLf &_
					"									 and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2)) "& vbCrLf &_
					"		 union  "& vbCrLf &_
					"		 select distinct aa.pers_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd  "& vbCrLf &_
					"		 where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod  "& vbCrLf &_
					"		 and cc.anos_ccod = ttr.anos_ccod and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod  "& vbCrLf &_
					"		 and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod = 5 and cc.plec_ccod <> 1  "& vbCrLf &_
					"		 and exists (select 1 from alumnos aaa, ofertas_academicas bbb, periodos_academicos ccc, especialidades ddd   "& vbCrLf &_
					"					 where aaa.pers_ncorr=aa.pers_ncorr and aaa.ofer_ncorr=bbb.ofer_ncorr and bbb.peri_ccod=ccc.peri_ccod  "& vbCrLf &_
					"					 and bbb.espe_ccod=ddd.espe_ccod and ccc.anos_ccod = ttr.anos_ccod and bbb.sede_ccod=ttr.sede_ccod  "& vbCrLf &_
					"					 and bbb.jorn_ccod=ttr.jorn_ccod and ddd.carr_ccod=ttr.carr_ccod and bbb.post_bnuevo='S' and isnull(aaa.talu_ccod,1) <> 3 )  "& vbCrLf &_
					"		 and not exists (select 1 from contratos cont1, compromisos comp1   "& vbCrLf &_
					"									 where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr  "& vbCrLf &_
					"									 and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2)) "& vbCrLf &_
					"         union "& vbCrLf &_
					"         select distinct aa.pers_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd "& vbCrLf &_
				    "         where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
				    "         and cc.anos_ccod = (ttr.anos_ccod + 1) and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod "& vbCrLf &_
				    "         and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod = 5 and cc.plec_ccod=1 and aa.alum_nmatricula = '7777' "& vbCrLf &_
					"         and exists (select 1 from alumnos aaa, ofertas_academicas bbb, periodos_academicos ccc, especialidades ddd "& vbCrLf &_
                    "                     where aaa.pers_ncorr=aa.pers_ncorr and aaa.ofer_ncorr=bbb.ofer_ncorr and bbb.peri_ccod=ccc.peri_ccod "& vbCrLf &_
                    "                     and bbb.espe_ccod=ddd.espe_ccod and ccc.anos_ccod = ttr.anos_ccod and bbb.sede_ccod=ttr.sede_ccod "& vbCrLf &_
                    "                     and bbb.jorn_ccod=ttr.jorn_ccod and ddd.carr_ccod=ttr.carr_ccod and bbb.post_bnuevo='S' and isnull(aaa.talu_ccod,1) <> 3 ) "& vbCrLf &_
				    "      ) as tablilla "& vbCrLf &_
					"		 where not exists ( select 1 from alumnos aa, ofertas_academicas bb,especialidades dd "& vbCrLf &_
		            "                           where aa.pers_ncorr=tablilla.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr "& vbCrLf &_
                    "						    and bb.peri_ccod > tablilla.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
                    "						    and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod and dd.carr_ccod=ttr.carr_ccod "& vbCrLf &_
					"                           and aa.emat_ccod = 1) "& vbCrLf &_
					" ) as total_eliminados_carrera, "& vbCrLf &_
					" (select count(distinct pers_ncorr) "& vbCrLf &_
					" from "& vbCrLf &_
				    "     ( "& vbCrLf &_
		            "        select distinct aa.pers_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd  "& vbCrLf &_
					"		 where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod  "& vbCrLf &_
					"		 and cc.anos_ccod = ttr.anos_ccod and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod  "& vbCrLf &_
					"		 and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod = 6  "& vbCrLf &_
					"		 and exists (select 1 from alumnos aaa, ofertas_academicas bbb, periodos_academicos ccc, especialidades ddd  "& vbCrLf &_
					"					 where aaa.pers_ncorr=aa.pers_ncorr and aaa.ofer_ncorr=bbb.ofer_ncorr and bbb.peri_ccod=ccc.peri_ccod  "& vbCrLf &_
					"					 and bbb.espe_ccod=ddd.espe_ccod and ccc.anos_ccod = ttr.anos_ccod and bbb.sede_ccod=ttr.sede_ccod  "& vbCrLf &_
					"					 and bbb.jorn_ccod=ttr.jorn_ccod and ddd.carr_ccod=ttr.carr_ccod and bbb.post_bnuevo='S' and isnull(aaa.talu_ccod,1) <> 3 )  "& vbCrLf &_
					"		 and exists (select 1 from contratos cont1, compromisos comp1   "& vbCrLf &_
					"									 where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr  "& vbCrLf &_
					"									 and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2)) "& vbCrLf &_
					"		 union  "& vbCrLf &_
					"		 select distinct aa.pers_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd  "& vbCrLf &_
					"		 where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod  "& vbCrLf &_
					"		 and cc.anos_ccod = ttr.anos_ccod and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod  "& vbCrLf &_
					"		 and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod = 6 and cc.plec_ccod <> 1  "& vbCrLf &_
					"		 and exists (select 1 from alumnos aaa, ofertas_academicas bbb, periodos_academicos ccc, especialidades ddd   "& vbCrLf &_
					"					 where aaa.pers_ncorr=aa.pers_ncorr and aaa.ofer_ncorr=bbb.ofer_ncorr and bbb.peri_ccod=ccc.peri_ccod  "& vbCrLf &_
					"					 and bbb.espe_ccod=ddd.espe_ccod and ccc.anos_ccod = ttr.anos_ccod and bbb.sede_ccod=ttr.sede_ccod  "& vbCrLf &_
					"					 and bbb.jorn_ccod=ttr.jorn_ccod and ddd.carr_ccod=ttr.carr_ccod and bbb.post_bnuevo='S' and isnull(aaa.talu_ccod,1) <> 3 )  "& vbCrLf &_
					"		 and not exists (select 1 from contratos cont1, compromisos comp1   "& vbCrLf &_
					"									 where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr  "& vbCrLf &_
					"									 and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2)) "& vbCrLf &_
					"         union "& vbCrLf &_
					"         select distinct aa.pers_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd "& vbCrLf &_
				    "         where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
				    "         and cc.anos_ccod = (ttr.anos_ccod + 1) and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod "& vbCrLf &_
				    "         and dd.carr_ccod=ttr.carr_ccod and aa.emat_ccod = 6 and cc.plec_ccod=1 and aa.alum_nmatricula = '7777' "& vbCrLf &_
					"         and exists (select 1 from alumnos aaa, ofertas_academicas bbb, periodos_academicos ccc, especialidades ddd "& vbCrLf &_
                    "                     where aaa.pers_ncorr=aa.pers_ncorr and aaa.ofer_ncorr=bbb.ofer_ncorr and bbb.peri_ccod=ccc.peri_ccod "& vbCrLf &_
                    "                     and bbb.espe_ccod=ddd.espe_ccod and ccc.anos_ccod = ttr.anos_ccod and bbb.sede_ccod=ttr.sede_ccod "& vbCrLf &_
                    "                     and bbb.jorn_ccod=ttr.jorn_ccod and ddd.carr_ccod=ttr.carr_ccod and bbb.post_bnuevo='S' and isnull(aaa.talu_ccod,1) <> 3 ) "& vbCrLf &_
				    "      ) as tablilla "& vbCrLf &_
					"		 where not exists ( select 1 from alumnos aa, ofertas_academicas bb,especialidades dd "& vbCrLf &_
		            "                           where aa.pers_ncorr=tablilla.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr "& vbCrLf &_
                    "						    and bb.peri_ccod > tablilla.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
                    "						    and bb.sede_ccod=ttr.sede_ccod and bb.jorn_ccod=ttr.jorn_ccod and dd.carr_ccod=ttr.carr_ccod "& vbCrLf &_
					"                           and aa.emat_ccod = 1) "& vbCrLf &_
					" ) as total_cambios_carrera "& vbCrLf &_
					" from  "& vbCrLf &_
					" (  "& vbCrLf &_
					"	 select distinct d.anos_ccod,a.area_ccod,e.sede_ccod,e.sede_tdesc,a.carr_ccod,a.carr_tdesc,  "& vbCrLf &_
					"					 f.jorn_ccod,f.jorn_tdesc  "& vbCrLf &_
					"    from carreras a, especialidades b, ofertas_academicas c, periodos_academicos d, sedes e, jornadas f "& vbCrLf &_
					" 		where a.carr_ccod=b.carr_ccod and b.espe_ccod=c.espe_ccod "& vbCrLf &_
					" 		and c.peri_ccod=d.peri_ccod and cast(d.anos_ccod as varchar)='"&anio&"' "& vbCrLf &_
					" 		and c.sede_ccod=e.sede_ccod and c.jorn_ccod=f.jorn_ccod and a.tcar_ccod=1"& vbCrLf &_
					" 		and exists(select 1 from alumnos aa  "& vbCrLf &_
					"           where aa.ofer_ncorr=c.ofer_ncorr and aa.emat_ccod <> 9 "& vbCrLf &_
					"           and exists (select 1 from contratos cont1, compromisos comp1  "& vbCrLf &_
					"           where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr  "& vbCrLf &_
					"           and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2))) "& vbCrLf &_
					" )ttr "& vbCrLf &_
					" )table_a      "
    desercion_nuevos=sql_indicador
	'response.Write("<pre>"&sql_indicador&"</pre>")				
end function

Function titulacion_oportuna (anio)
	'sql_indicador=	" select area_ccod,anos_ccod as ano_consulta,carr_tdesc as carrera,jorn_tdesc as jornada, "& vbCrLf &_
	'				" semestres as cant_semestres, duracion as titulados_hasta,total_activos as activos_consulta,titulados_a_tiempo, "& vbCrLf &_
	'				" case titulados_a_tiempo when 0 then 0 else cast((titulados_a_tiempo  * 100.00) / case total_activos when 0 then 1 else total_activos end as decimal (6,2)) end as indicador "& vbCrLf &_
	'				" from   "& vbCrLf &_
	'				"    (  "& vbCrLf &_
	'				"     select distinct ttr.area_ccod,ttr.anos_ccod,ttr.carr_ccod,ttr.carr_tdesc,ttr.jorn_ccod,ttr.jorn_tdesc,(select max(espe_nduracion) from especialidades esp where esp.carr_ccod=ttr.carr_ccod) as semestres, "& vbCrLf &_
	'				"     cast (((select max(espe_nduracion) from especialidades esp where esp.carr_ccod=ttr.carr_ccod) / 2) as numeric) + cast('"&anio&"' as numeric)  as duracion, "& vbCrLf &_
	'				"     (select count(distinct pers_ncorr) "& vbCrLf &_
	'				"      from alumnos aa, ofertas_academicas oa, periodos_academicos pa,especialidades ea "& vbCrLf &_
	'				"      where aa.ofer_ncorr=oa.ofer_ncorr and oa.peri_ccod=pa.peri_ccod and cast(pa.anos_ccod as varchar)='"&anio&"' "& vbCrLf &_
	'				"      and oa.espe_ccod=ea.espe_ccod and ea.carr_ccod=ttr.carr_ccod and oa.jorn_ccod=ttr.jorn_ccod "& vbCrLf &_
	'				"      and aa.emat_ccod=1  and isnull(aa.talu_ccod,1) <> 3 and protic.ano_ingreso_carrera_egresa2(aa.pers_ncorr,ttr.carr_ccod)='"&anio&"') as total_activos, "& vbCrLf &_
	'				"     (select count(distinct pers_ncorr) "& vbCrLf &_
	'				"      from alumnos aa, ofertas_academicas oa, periodos_academicos pa,especialidades ea "& vbCrLf &_
	'				"      where aa.ofer_ncorr=oa.ofer_ncorr and oa.peri_ccod=pa.peri_ccod  "& vbCrLf &_
	'				"      and pa.anos_ccod <= (cast ((espe_nduracion / 2) as numeric) + cast('"&anio&"' as numeric) ) "& vbCrLf &_
	'				"      and oa.espe_ccod=ea.espe_ccod and ea.carr_ccod=ttr.carr_ccod and oa.jorn_ccod=ttr.jorn_ccod "& vbCrLf &_
	'				"      and aa.emat_ccod=8 and protic.ano_ingreso_carrera_egresa2(aa.pers_ncorr,ttr.carr_ccod)='"&anio&"') as titulados_a_tiempo "& vbCrLf &_
	'				" from  "& vbCrLf &_
	'				" (  "& vbCrLf &_
	'				"	 select distinct d.anos_ccod,a.area_ccod,a.carr_ccod,a.carr_tdesc,  "& vbCrLf &_
	'				"					 f.jorn_ccod,f.jorn_tdesc  "& vbCrLf &_
	'				"     from carreras a, especialidades b, ofertas_academicas c, periodos_academicos d, jornadas f  "& vbCrLf &_
	'				"     where a.carr_ccod=b.carr_ccod and b.espe_ccod=c.espe_ccod  "& vbCrLf &_
	'				"     and c.peri_ccod=d.peri_ccod and cast(d.anos_ccod as varchar)='"&anio&"'  "& vbCrLf &_
	'				"     and c.jorn_ccod=f.jorn_ccod and a.tcar_ccod=1 "& vbCrLf &_
	'				"     and exists(select 1 from alumnos aa  "& vbCrLf &_
	'				"           where aa.ofer_ncorr=c.ofer_ncorr and aa.emat_ccod <> 9 "& vbCrLf &_
	'				"           and protic.ano_ingreso_carrera_egresa2(aa.pers_ncorr,a.carr_ccod)='"&anio&"') "& vbCrLf &_
	'				" )ttr "& vbCrLf &_
	'				" )table_a   "
	sql_indicador=	" select area_ccod,anos_ccod as ano_consulta,carr_tdesc as carrera,jorn_tdesc as jornada, "& vbCrLf &_
					" semestres as cant_semestres, duracion as titulados_hasta,total_activos as activos_consulta, "& vbCrLf &_
					" case titulados_a_tiempo when 0 then cast(titulados_a_tiempo as varchar) "& vbCrLf &_
					" else '<a href=""javascript:mostrar_titula2(8,'+ cast(anos_ccod as varchar) + ','+ carr_ccod +','+ cast(jorn_ccod as varchar) +')"">'+ cast(titulados_a_tiempo as varchar) + '</a>' "& vbCrLf &_
					" end as titulados_a_tiempo_temp,titulados_a_tiempo, "& vbCrLf &_
					" case titulados_a_tiempo when 0 then 0 else cast((titulados_a_tiempo  * 100.00) / case total_activos when 0 then 1 else total_activos end as decimal (6,2)) end as indicador "& vbCrLf &_
					" from   "& vbCrLf &_
					"    (  "& vbCrLf &_
					"     select ttr.area_ccod,ttr.anos_ccod,ttr.carr_ccod,ttr.carr_tdesc,ttr.jorn_ccod,ttr.jorn_tdesc,(select max(espe_nduracion) from especialidades esp where esp.carr_ccod=ttr.carr_ccod) as semestres, "& vbCrLf &_
					"     cast (((select max(espe_nduracion) from especialidades esp where esp.carr_ccod=ttr.carr_ccod) / 2) as numeric) + cast('"&anio&"' as numeric)  as duracion, "& vbCrLf &_
					"     (select count(distinct pers_ncorr) "& vbCrLf &_
					"      from alumnos aa (nolock), ofertas_academicas oa, periodos_academicos pa,especialidades ea "& vbCrLf &_
					"      where aa.ofer_ncorr=oa.ofer_ncorr and oa.peri_ccod=pa.peri_ccod and cast(pa.anos_ccod as varchar)='"&anio&"' "& vbCrLf &_
					"      and oa.espe_ccod=ea.espe_ccod and ea.carr_ccod=ttr.carr_ccod and oa.jorn_ccod=ttr.jorn_ccod "& vbCrLf &_
					"      and aa.emat_ccod=1 and isnull(aa.talu_ccod,1) <> 3 and protic.ano_ingreso_carrera_egresa2(aa.pers_ncorr,ttr.carr_ccod)='"&anio&"') as total_activos, "& vbCrLf &_
					"     (select count(distinct pers_ncorr) "& vbCrLf &_
					"      from alumnos aa (nolock), ofertas_academicas oa, periodos_academicos pa,especialidades ea "& vbCrLf &_
					"      where aa.ofer_ncorr=oa.ofer_ncorr and oa.peri_ccod=pa.peri_ccod  "& vbCrLf &_
					"      and pa.anos_ccod <= (cast ((espe_nduracion / 2) as numeric) + cast('"&anio&"' as numeric) ) "& vbCrLf &_
					"      and oa.espe_ccod=ea.espe_ccod and ea.carr_ccod=ttr.carr_ccod and oa.jorn_ccod=ttr.jorn_ccod "& vbCrLf &_
					"      and aa.emat_ccod=8 and protic.ano_ingreso_carrera_egresa2(aa.pers_ncorr,ttr.carr_ccod)='"&anio&"') as titulados_a_tiempo "& vbCrLf &_
					" from  "& vbCrLf &_
					"    (  "& vbCrLf &_
					"	 select distinct d.anos_ccod,a.area_ccod,a.carr_ccod,a.carr_tdesc,  "& vbCrLf &_
					"					 f.jorn_ccod,f.jorn_tdesc  "& vbCrLf &_
					"     from carreras a, especialidades b, ofertas_academicas c, periodos_academicos d, jornadas f  "& vbCrLf &_
					"     where a.carr_ccod=b.carr_ccod and b.espe_ccod=c.espe_ccod  "& vbCrLf &_
					"     and c.peri_ccod=d.peri_ccod and cast(d.anos_ccod as varchar)='"&anio&"'  "& vbCrLf &_
					"     and c.jorn_ccod=f.jorn_ccod and a.tcar_ccod=1 "& vbCrLf &_
					"     and exists(select 1 from alumnos aa  "& vbCrLf &_
					"           where aa.ofer_ncorr=c.ofer_ncorr and aa.emat_ccod <> 9 "& vbCrLf &_
					"           and protic.ano_ingreso_carrera_egresa2(aa.pers_ncorr,a.carr_ccod)='"&anio&"') "& vbCrLf &_
					" )ttr "& vbCrLf &_
					" )table_a   "
    titulacion_oportuna =sql_indicador				
end function
Function promedio_titulacion (anio)
	sql_indicador=	" select facu_ccod,anos_ccod as ano_consulta,carr_tdesc as carrera,duracion, "& vbCrLf &_
				    " total_activos as activos_consulta,titulados_a_la_fecha, promedio as indicador "& vbCrLf &_
					" from    "& vbCrLf &_
				    "    (   "& vbCrLf &_
					"     select distinct ttr.facu_ccod,ttr.anos_ccod,ttr.carr_ccod,ttr.carr_tdesc, "& vbCrLf &_
				    "     (select max(esp.espe_nduracion) from especialidades esp where esp.carr_ccod=ttr.carr_ccod ) as duracion,"& vbCrLf &_
					"     (select count(distinct pers_ncorr)  "& vbCrLf &_
					"      from alumnos aa, ofertas_academicas oa, periodos_academicos pa,especialidades ea  "& vbCrLf &_
					"      where aa.ofer_ncorr=oa.ofer_ncorr and oa.peri_ccod=pa.peri_ccod and cast(pa.anos_ccod as varchar)='"&anio&"'  "& vbCrLf &_
					"      and oa.espe_ccod=ea.espe_ccod and ea.carr_ccod=ttr.carr_ccod "& vbCrLf &_
					"      and aa.emat_ccod=1 and protic.ano_ingreso_carrera_egresa2(aa.pers_ncorr,ttr.carr_ccod)='"&anio&"') as total_activos,"& vbCrLf &_
					"      (select count(distinct aa.pers_ncorr) from alumnos aa, ofertas_academicas ba, especialidades ca "& vbCrLf &_
					"       where aa.ofer_ncorr=ba.ofer_ncorr and ba.espe_ccod=ca.espe_ccod and ca.carr_ccod=ttr.carr_ccod "& vbCrLf &_
					"       and aa.emat_ccod='8' and protic.ano_ingreso_carrera_egresa2(aa.pers_ncorr,ca.carr_ccod) = '"&anio&"' "& vbCrLf &_
					"       ) as titulados_a_la_fecha, "& vbCrLf &_
					"       protic.promedio_titulacion(ttr.carr_ccod,"&anio&") as promedio  "& vbCrLf &_
					" from  "& vbCrLf &_
					"    (  "& vbCrLf &_
					"	   select distinct e.facu_ccod,d.anos_ccod,a.carr_ccod,a.carr_tdesc  "& vbCrLf &_
					"      from carreras a, especialidades b, ofertas_academicas c, periodos_academicos d,areas_academicas e "& vbCrLf &_
					"      where a.carr_ccod=b.carr_ccod and b.espe_ccod=c.espe_ccod   "& vbCrLf &_
					"      and a.area_ccod = e.area_ccod "& vbCrLf &_
					"      and c.peri_ccod=d.peri_ccod and cast(d.anos_ccod as varchar)='"&anio&"'    "& vbCrLf &_
					"      and a.tcar_ccod=1  "& vbCrLf &_
					"      and exists(select 1 from alumnos aa   "& vbCrLf &_
					"                 where aa.ofer_ncorr=c.ofer_ncorr and aa.emat_ccod = 1   "& vbCrLf &_
					"                 and protic.ano_ingreso_carrera_egresa2(aa.pers_ncorr,a.carr_ccod)='"&anio&"')   "& vbCrLf &_
					"    )ttr "& vbCrLf &_
					" )table_a "

    promedio_titulacion =sql_indicador				
end function

Function ObtenerConsulta5()
	sql_indicador=	" select '' "         
    ObtenerConsulta5=sql_indicador				
end function


'response.Write("<hr>")
response.Flush()
'response.End()
%>
<html>
<head>
<title><%=titulo%></title>  
</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td colspan="2" align="center"><font size="3"><strong><%=titulo%></strong></font></td>
</tr>
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
<tr>
	<td colspan="2" align="left"><strong>Fecha Actual : </strong><%=fecha_01%></td>
</tr>
<%if texto <> "" then%>
<tr>
	<td colspan="2" align="left"><%=texto%></td>
</tr>
<%end if%>
<%if estandar <> "" then %>
<tr>
	<td colspan="2" align="left"><%=estandar%></td>
</tr>
<%end if%>
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
<%if porcentaje_universidad <> "" and v_cod_opcion <> 18 and v_cod_opcion <> 4 and v_cod_opcion <> 14 and v_cod_opcion <> 15 and v_cod_opcion <> 17 then%>
<tr>
    <td colspan="2" align="left"><font size="3" color="#666666"><strong>Indicador General Universidad : </strong><%=porcentaje_universidad%> (%)</font></td>
</tr>
<%elseif v_cod_opcion=17 then%>
							<tr>
							    <td colspan="2" align="center">&nbsp;</td>
							</tr>
							<tr>
							    <td colspan="2" align="left"><font size="3" color="#666666"><strong>Indicador General Universidad : ( Por definir )</strong><%'=porcentaje_universidad%></font></td>
							</tr>
							<tr>
							    <td colspan="2" align="left"><font size="3" color="#666666"><strong>Indicador por Facultad : ( Por definir )</strong><%'=porcentaje_universidad%></font></td>
							</tr>

<%elseif v_cod_opcion=18 then%>
<tr>
							    <td align="center">&nbsp;</td>
							</tr>
							<tr>
							    <td align="left">
								<table width="661" border="1" class=v1 bordercolor='#999999'  id='tb_a'>
								<tr bgcolor='#C4D7FF' bordercolor='#999999'>
									<td colspan="3"><strong>Indicadores Globales Universidad</strong></td>
								</tr>
									<tr>
										<td width="181"><strong>Matriculas Nuevos: </strong><%=matriculados%></td>	
										<td width="170"><strong>Vacantes Nuevos: </strong><%=tvacantes%></td>								
									  <td width="294"><strong>Indicador  Nuevos : </strong><%=porcentaje_universidad%> (%) </td>
									</tr>
									<tr>
										<td><strong>Matriculas Antiguos: </strong><%=matriculados_antiguos%></td>
										<td><strong>Vacantes Antiguos: </strong><%=tvacantes_antiguos%></td>		
									    <td align="left"><strong>Indicador  Antiguos : </strong><%=porcentaje_universidad_antiguos%> (%) </td>
									</tr>
								</table>
</td>
							</tr>								
<%elseif v_cod_opcion=4 then%>
<tr>
    <td colspan="2" align="left"><font size="3" color="#666666"><strong>Indicadores Generales Universidad</strong></font></td>
</tr>
<tr>
	<td colspan="2" align="center">
	<script language='javaScript1.2'> colores = Array(3);   colores[0] = ''; colores[1] = '#FFECC6'; colores[2] = '#FFECC6'; </script>
    <table class=v1 width='100%' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD' id='tb_a'>
	     <tr bgcolor='#C4D7FF' bordercolor='#999999'>
			<th align="center" colspan="2"><font color='#333333'>Indicadores Generales Universidad</font></th>
		 </tr> 
	     <tr bgcolor="#FFFFFF">
		    <td class='noclick' align='LEFT' width="40%" >AÑO CONSULTADO </td>
			<td class='noclick' align='LEFT' width="60%" ><%=v_anos%></td>
		 </tr> 
		 <tr bgcolor="#FFFFFF">
		    <td class='noclick' align='LEFT' width="40%" >TOTAL ALUMNOS NUEVOS </td>
			<td class='noclick' align='LEFT' width="60%" ><%=porcentaje_universidad%></td>
		 </tr> 
		 <tr bgcolor="#FFFFFF">
			<td class='noclick' align='LEFT' width="40%" >INDICADOR TOTAL HOMBRES</td>
			<td class='noclick' align='LEFT' width="60%" ><%=porcentaje_hombres%> (%)</td>
		 </tr>
		 <tr bgcolor="#FFFFFF">
		    <td class='noclick' align='LEFT' width="40%" >INDICADOR TOTAL MUJERES</td>
			<td class='noclick' align='LEFT' width="60%" ><%=porcentaje_mujeres%> (%)</td>
		 </tr> 
		 <tr bgcolor="#FFFFFF">
		    <td class='noclick' align='LEFT' width="40%" >INDICADOR TOTAL EXTRANJEROS</td>
			<td class='noclick' align='LEFT' width="60%" ><%=porcentaje_extranjeros%> (%)</td>
		 </tr> 
    </table>
	</td>
</tr>
<%elseif v_cod_opcion=14 then%>
<tr>
    <td colspan="2" align="left"><font size="3" color="#666666"><strong>Indicadores Generales Universidad</strong></font></td>
</tr>
<tr>
	<td colspan="2" align="center">
        <table class=v1 width='100%' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD' id='tb_a'>
		     <tr bgcolor='#C4D7FF' bordercolor='#999999'>
				<th align="center" colspan="2"><font color='#333333'>Indicadores Generales Universidad</font></th>
			 </tr> 
		     <tr bgcolor="#FFFFFF">
			    <td class='noclick' align='LEFT' width="40%" >AÑO CONSULTADO </td>
				<td class='noclick' align='LEFT' width="60%" ><%=v_anos%></td>
			 </tr> 
   	    	 <tr bgcolor="#FFFFFF">
			    <td class='noclick' align='LEFT' width="40%" >TOTAL ALUMNOS</td>
				<td class='noclick' align='LEFT' width="60%" ><%=porcentaje_universidad%></td>
			 </tr> 
			 <tr bgcolor="#FFFFFF">
			    <td class='noclick' align='LEFT' width="40%" >PORCENTAJE TOTAL ABANDONOS</td>
				<td class='noclick' align='LEFT' width="60%" ><%=porcentaje_abandonos%> (%)</td>
			 </tr>
			 <tr bgcolor="#FFFFFF">
			    <td class='noclick' align='LEFT' width="40%" >PORCENTAJE TOTAL RETIROS</td>
				<td class='noclick' align='LEFT' width="60%" ><%=porcentaje_retiros%> (%)</td>
			 </tr> 
			 <tr bgcolor="#FFFFFF">
			    <td class='noclick' align='LEFT' width="40%" >PORCENTAJE TOTAL ELIMINADOS</td>
				<td class='noclick' align='LEFT' width="60%" ><%=porcentaje_eliminados%> (%)</td>
			 </tr> 
			 <tr bgcolor="#FFFFFF">
				<td class='noclick' align='LEFT' width="40%" ><strong>INDICADOR UNIVERSIDAD</strong></td>
				<td class='noclick' align='LEFT' width="60%" ><strong><%=porcentaje_total%> (%)</strong></td>
			</tr> 
	    </table>
	</td>
</tr>
<%elseif v_cod_opcion=15 then%>
<tr>
    <td colspan="2" align="left"><font size="3" color="#666666"><strong>Indicadores Generales Universidad</strong></font></td>
</tr>
<tr>
	<td colspan="2" align="center">
        <table class=v1 width='100%' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD' id='tb_a'>
			<tr bgcolor='#C4D7FF' bordercolor='#999999'>
				<th align="center" colspan="2"><font color='#333333'>Indicadores Generales Universidad</font></th>
			</tr> 
			<tr bgcolor="#FFFFFF">
				<td class='noclick' align='LEFT' width="40%" >AÑO CONSULTADO </td>
	            <td class='noclick' align='LEFT' width="60%" ><%=v_anos%></td>
			</tr> 
			<tr bgcolor="#FFFFFF">
		        <td class='noclick' align='LEFT' width="40%" >TOTAL ALUMNOS</td>
				<td class='noclick' align='LEFT' width="60%" ><%=porcentaje_universidad%></td>
			</tr> 
			<tr bgcolor="#FFFFFF">
				<td class='noclick' align='LEFT' width="40%" >PORCENTAJE TOTAL ABANDONOS</td>
				<td class='noclick' align='LEFT' width="60%" ><%=porcentaje_abandonos%> (%)</td>
			</tr>
			<tr bgcolor="#FFFFFF">
                <td class='noclick' align='LEFT' width="40%" >PORCENTAJE TOTAL RETIROS</td>
				<td class='noclick' align='LEFT' width="60%" ><%=porcentaje_retiros%> (%)</td>
			</tr> 
			<tr bgcolor="#FFFFFF">
				<td class='noclick' align='LEFT' width="40%" >PORCENTAJE TOTAL ELIMINADOS</td>
				<td class='noclick' align='LEFT' width="60%" ><%=porcentaje_eliminados%> (%)</td>
			</tr> 
			<tr bgcolor="#FFFFFF">
				<td class='noclick' align='LEFT' width="40%" ><strong>INDICADOR UNIVERSIDAD</strong></td>
				<td class='noclick' align='LEFT' width="60%" ><strong><%=porcentaje_total%> (%)</strong></td>
			</tr> 
		</table>
	</td>
</tr>
<%end if
response.Flush()

%>
<tr>
    <td colspan="2" align="left">&nbsp;</td>
</tr>
<%if consulta_sede <> "" then%>
<tr>
    <td colspan="2" align="left"><font size="3" color="#666666"><strong>Indicador General por Sede</strong></font></td>
</tr>
<tr>
	<td colspan="2" align="center">
	   <table width="100%" border="1" bordercolor='#999999'>
 		  <%Select Case v_cod_opcion

				   Case 18%>
				   <tr> 
						<td bgcolor="#C4D7FF"><div align="center"><strong>Sede</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Matriculados Nuevos</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Vacantes Nuevos</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Indicador Nuevos(%)</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Matriculados Antiguos</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Vacantes Antiguos</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Indicador Antiguos(%)</strong></div></td>
						
					</tr>
				   <%
				   while formulario3.Siguiente %>
				   <tr> 
						<td><div align="left"><%=formulario3.ObtenerValor("sede")%></div></td>
						<td><div align="left"><%=formulario3.ObtenerValor("nuevos")%></div></td>
						<td><div align="left"><%=formulario3.ObtenerValor("vacantes_nuevos")%></div></td>
						<td><div align="left"><%=formulario3.ObtenerValor("indicador_nuevos")%></div></td>
						<td><div align="left"><%=formulario3.ObtenerValor("antiguos")%></div></td>
						<td><div align="left"><%=formulario3.ObtenerValor("vacantes_antiguos")%></div></td>
						<td><div align="left"><%=formulario3.ObtenerValor("indicador_antiguos")%></div></td>
					</tr>
				   <%wend
 			End Select%>   
	  </table>
	</td>
</tr>
<%end if%>



<%if consulta_facultad <> "" then%>
<tr>
    <td colspan="2" align="left"><font size="3" color="#666666"><strong>Indicador General por Facultad</strong></font></td>
</tr>
<tr>
	<td colspan="2" align="center">
	   <table width="100%" border="1" bordercolor='#999999'>
 		  <%Select Case v_cod_opcion
	           Case 1%>
				   <tr> 
						<td bgcolor="#C4D7FF"><div align="center"><strong>Facultad</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Matriculados LOCE</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Matriculados Facultad</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Indicador(%)</strong></div></td>
					</tr>
				   <%
				   while formulario2.Siguiente %>
				   <tr> 
						<td><div align="left"><%=formulario2.ObtenerValor("facu_tdesc")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("en_loce")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("total_facultad")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("indicador")%></div></td>
					</tr>
				   <%wend%>
				   <%Case 2%>
				   <tr> 
						<td bgcolor="#C4D7FF"><div align="center"><strong>Facultad</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Seleccionados</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Total Postulantes</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Indicador(%)</strong></div></td>
					</tr>
				   <%
				   while formulario2.Siguiente %>
				   <tr> 
						<td><div align="left"><%=formulario2.ObtenerValor("facu_tdesc")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("total_aprobados")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("total_postulantes")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("indicador")%></div></td>
					</tr>
				   <%wend%>
				   <%Case 3%>
				   <tr> 
						<td bgcolor="#C4D7FF"><div align="center"><strong>Facultad</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Matriculados</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Vacantes</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Indicador(%)</strong></div></td>
					</tr>
				   <%
				   while formulario2.Siguiente %>
				   <tr> 
						<td><div align="left"><%=formulario2.ObtenerValor("facu_tdesc")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("matriculados")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("vacantes")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("indicador")%></div></td>
					</tr>
				   <%wend%>
				   <%Case 4%>
				   <tr> 
						<td bgcolor="#C4D7FF"><div align="center"><strong>Facultad</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Total Carreras</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Total Hombres</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Indicador Hombres(%)</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Total Mujeres</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Indicador Mujeres(%)</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Total Extranjeros</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Indicador Extranjeros(%)</strong></div></td>
					</tr>
				   <%
				   while formulario2.Siguiente %>
				   <tr> 
						<td><div align="left"><%=formulario2.ObtenerValor("facu_tdesc")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("total_carreras")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("hombres")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("indicador_hombres")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("mujeres")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("indicador_mujeres")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("extranjeros")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("indicador_extranjeros")%></div></td>
					</tr>
				   <%wend%>
				   <%Case 14%>
				   <tr> 
						<td bgcolor="#C4D7FF"><div align="center"><strong>Facultad</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Total Carreras</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Abandonos</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Porcentaje Abandonos(%)</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Total Retiros</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Porcentaje Retiros(%)</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Total Eliminados</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Porcentaje Eliminados(%)</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Total Cambios</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Porcentaje Cambios(%)</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Indicador Facultad(%)</strong></div></td>
					</tr>
				   <%
				   while formulario2.Siguiente %>
				   <tr> 
						<td><div align="left"><%=formulario2.ObtenerValor("facu_tdesc")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("total_carreras")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("abandonos")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("indicador_abandonos")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("retiros")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("indicador_retiros")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("eliminados")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("indicador_eliminados")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("cambios")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("indicador_cambios")%></div></td>
						<td><div align="center"><strong><%=formulario2.ObtenerValor("indicador_totales")%></strong></div></td>
					</tr>
				   <%wend%>
				   <%Case 15%>
				   <tr> 
						<td bgcolor="#C4D7FF"><div align="center"><strong>Facultad</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Total Carreras</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Abandonos</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Porcentaje Abandonos(%)</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Total Retiros</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Porcentaje Retiros(%)</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Total Eliminados</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Porcentaje Eliminados(%)</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Total Cambios</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Porcentaje Cambios(%)</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Indicador Facultad(%)</strong></div></td>
					</tr>
				   <%
				   while formulario2.Siguiente %>
				   <tr> 
						<td><div align="left"><%=formulario2.ObtenerValor("facu_tdesc")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("total_carreras")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("abandonos")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("indicador_abandonos")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("retiros")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("indicador_retiros")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("eliminados")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("indicador_eliminados")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("cambios")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("indicador_cambios")%></div></td>
						<td><div align="center"><strong><%=formulario2.ObtenerValor("indicador_totales")%></strong></div></td>
					</tr>
				   <%wend%>
				   <%Case 16%>
				   <tr> 
						<td bgcolor="#C4D7FF"><div align="center"><strong>Facultad</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Matriculados</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Titulados</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Indicador(%)</strong></div></td>
					</tr>
				   <%
				   while formulario2.Siguiente %>
				   <tr> 
						<td><div align="left"><%=formulario2.ObtenerValor("facu_tdesc")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("activos")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("titulados")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("indicador")%></div></td>
					</tr>
				   <%wend
				   Case 18%>
				   <tr> 
						<td bgcolor="#C4D7FF"><div align="center"><strong>Facultad</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Matriculados Nuevos</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Vacantes Nuevos</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Indicador Nuevos(%)</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Matriculados Antiguos</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Vacantes Antiguos</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Indicador Antiguos(%)</strong></div></td>
						
					</tr>
				   <%
				   while formulario2.Siguiente %>
				   <tr> 
						<td><div align="left"><%=formulario2.ObtenerValor("facultad")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("nuevos")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("vacantes_nuevos")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("indicador_nuevos")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("antiguos")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("vacantes_antiguos")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("indicador_antiguos")%></div></td>
					</tr>
				   <%wend
				   Case 19%>
				   <tr> 
						<td bgcolor="#C4D7FF"><div align="center"><strong>Facultad</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Matriculados Facultad</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Matriculados Universidad</strong></div></td>
						<td bgcolor="#C4D7FF"><div align="center"><strong>Indicador(%)</strong></div></td>
					</tr>
				   <%
				   while formulario2.Siguiente %>
				   <tr> 
						<td><div align="left"><%=formulario2.ObtenerValor("facu_tdesc")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("total_facultad")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("total_universidad")%></div></td>
						<td><div align="left"><%=formulario2.ObtenerValor("indicador")%></div></td>
					</tr>
				   <%wend%>
			 <%End Select%>   
	  </table>
	</td>
</tr>
<%end if%>
<tr>
    <td colspan="2" align="left">&nbsp;</td>
</tr>
<tr>
    <td colspan="2" align="left"><font size="3" color="#666666"><strong>Indicadores General por Carrera</strong></font></td>
</tr>
<tr>
	<td colspan="2" align="center"><table width="100%" border="1" bordercolor='#999999'>
									  <%Select Case v_cod_opcion
	                                  Case 1%>
									  <tr> 
										<td bgcolor="#C4D7FF"><div align="center"><strong>N°</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Sede</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Carrera</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Jornada</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Alumnos Carrera</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Total Facultad</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Indicador Facultad(%)</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Indicador Universidad(%)</strong></div></td>
									  </tr>
									  <% fila = 1 
										 while formulario.Siguiente %>
									  <tr> 
										<td><div align="center"><%=fila%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("sede")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("carrera")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("jornada")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("factor_carrera")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("Total_facultad")%></div></td>
										<td bgcolor="#C4D7FF"><div align="left"><%=formulario.ObtenerValor("porcentaje_participacion_facultad")%></div></td>
										<td bgcolor="#C4D7FF"><div align="left"><%=formulario.ObtenerValor("porcentaje_participacion_universidad")%></div></td>	
										</tr>
									        <%fila= fila + 1  
										wend %>
									  <%Case 2%>
									  <tr> 
										<td bgcolor="#C4D7FF"><div align="center"><strong>N°</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Sede</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Carrera</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Jornada</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Nivel de concentración de Matrícula</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Seleccionados</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Total Postulantes</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Indicador (%)</strong></div></td>
									  </tr>
									  <% fila = 1 
										 while formulario.Siguiente %>
									  <tr> 
										<td><div align="center"><%=fila%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("sede")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("carrera")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("jornada")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("matriculados")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("total_aprobados")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("total_postulantes")%></div></td>
										<td bgcolor="#C4D7FF"><div align="left"><%=formulario.ObtenerValor("porcentaje_seleccion")%></div></td>	
									  </tr>
									     <%fila= fila + 1  
										 wend %>
									  <%Case 3%>
									  <tr> 
										<td bgcolor="#C4D7FF"><div align="center"><strong>N°</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Sede</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Carrera</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Jornada</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Matriculados</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Vacantes</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Indicador(%)</strong></div></td>
									  </tr>
									  <% fila = 1 
										 while formulario.Siguiente %>
									  <tr> 
										<td><div align="center"><%=fila%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("sede")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("carrera")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("jornada")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("matriculados")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("vacantes")%></div></td>
										<td bgcolor="#C4D7FF"><div align="left"><%=formulario.ObtenerValor("Demanda")%></div></td>	
									  </tr>
									  <%fila= fila + 1  
									  wend%>
									  <%Case 4%>
									  <tr> 
										<td bgcolor="#C4D7FF"><div align="center"><strong>N°</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Sede</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Carrera</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Jornada</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Total Carrera</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Total Hombres</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Indicador Hombres(%)</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Total Mujeres</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Indicador Mujeres(%)</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Total Extranjeros</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Indicador Extranjeros(%)</strong></div></td>
									  </tr>
									  <% fila = 1 
										 while formulario.Siguiente %>
									  <tr> 
										<td><div align="center"><%=fila%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("sede")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("carrera")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("jornada")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("total_carrera")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("total_hombres_carrera")%></div></td>
										<td bgcolor="#C4D7FF"><div align="left"><%=formulario.ObtenerValor("porc_hombres")%></div></td>	
										<td><div align="left"><%=formulario.ObtenerValor("total_mujeres_carrera")%></div></td>
										<td bgcolor="#C4D7FF"><div align="left"><%=formulario.ObtenerValor("porc_mujeres")%></div></td>	
										<td><div align="left"><%=formulario.ObtenerValor("total_extranjeros_carrera")%></div></td>
										<td bgcolor="#C4D7FF"><div align="left"><%=formulario.ObtenerValor("porc_extranjeros")%></div></td>	
									  </tr>
									  <%fila= fila + 1  
									  wend%>
									  <%Case 5%>
									  <tr> 
										<td bgcolor="#C4D7FF"><div align="center"><strong>N°</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Sede</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Carrera</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Jornada</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Total Asignaturas</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Total Formación Fundamental</strong></div></td>
									  </tr>
									  <% fila = 1 
										 while formulario.Siguiente %>
									  <tr> 
										<td><div align="center"><%=fila%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("sede")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("carrera")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("jornada")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("total_asignaturas")%></div></td>
										<td bgcolor="#C4D7FF"><div align="left"><%=formulario.ObtenerValor("total_FF")%></div></td>
									  </tr>
									  <%fila= fila + 1  
									  wend%>
									  <%Case 14%>
									  <tr> 
										<td bgcolor="#C4D7FF"><div align="center"><strong>N°</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Sede</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Carrera</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Jornada</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Total Matriculados</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Abondonos</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Retiros</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Eliminados</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Cambios</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Indicador(%)</strong></div></td>
									  </tr>
									  <% fila = 1 
										 while formulario.Siguiente %>
									  <tr> 
										<td><div align="center"><%=fila%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("sede")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("carrera")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("jornada")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("total_alumnos_carrera")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("total_abandonos_carrera")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("total_retiros_carrera")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("total_eliminados_carrera")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("total_cambios_carrera")%></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong><%=formulario.ObtenerValor("porcentaje")%></strong></div></td>
									  </tr>
									  <%fila= fila + 1  
									  wend%>
									  <%Case 15%>
									  <tr> 
										<td bgcolor="#C4D7FF"><div align="center"><strong>N°</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Sede</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Carrera</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Jornada</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Total Matriculados</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Abondonos</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Retiros</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Eliminados</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Cambios</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Indicador(%)</strong></div></td>
									  </tr>
									  <% fila = 1 
										 while formulario.Siguiente %>
									  <tr> 
										<td><div align="center"><%=fila%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("sede")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("carrera")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("jornada")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("total_alumnos_carrera")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("total_abandonos_carrera")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("total_retiros_carrera")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("total_eliminados_carrera")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("total_cambios_carrera")%></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong><%=formulario.ObtenerValor("porcentaje")%></strong></div></td>
									  </tr>
									  <%fila= fila + 1  
									  wend%>
									  <%Case 16%>
									  <tr> 
										<td bgcolor="#C4D7FF"><div align="center"><strong>N°</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Año</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Carrera</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Jornada</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Titulados Hasta</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Total Matriculados</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Titulados a Tiempo</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Indicador(%)</strong></div></td>
									  </tr>
									  <% fila = 1 
										 while formulario.Siguiente %>
									  <tr> 
										<td><div align="center"><%=fila%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("ano_consulta")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("carrera")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("jornada")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("titulados_hasta")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("activos_consulta")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("titulados_a_tiempo")%></div></td>
										<td bgcolor="#C4D7FF"><div align="left"><%=formulario.ObtenerValor("indicador")%></div></td>
									  </tr>
									  <%fila= fila + 1  
									  wend%>
									  <%Case 17%>
									  <tr> 
										<td bgcolor="#C4D7FF"><div align="center"><strong>N°</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Año</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Carrera</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Duración(Semestre)</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Total Matriculados</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Titulados a la Fecha</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Indicador(Semestres)</strong></div></td>
									  </tr>
									  <% fila = 1 
										 while formulario.Siguiente %>
									  <tr> 
										<td><div align="center"><%=fila%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("ano_consulta")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("carrera")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("duracion")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("activos_consulta")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("titulados_a_la_fecha")%></div></td>
										<td bgcolor="#C4D7FF"><div align="left"><%=formulario.ObtenerValor("indicador")%></div></td>
									  </tr>
									  <%fila= fila + 1  
									  wend%>
									  <%Case 18%>
									  <tr> 
										<td bgcolor="#C4D7FF"><div align="center"><strong>Sede</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Carrera</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Jornada</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Nuevos Matriculados</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Vacantes Nuevos</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Indicador Nuevos(%)</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Antiguos Matriculados</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Vacantes Antiguos</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Indicador Antiguos(%)</strong></div></td>
									  </tr>
									  <% fila = 1 
										 while formulario.Siguiente %>
									  <tr> 
										<td><div align="left"><%=formulario.ObtenerValor("sede")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("carrera")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("jornada")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("nuevos")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("vacantes_nuevos")%></div></td>
										<td bgcolor="#C4D7FF"><div align="left"><%=formulario.ObtenerValor("indicador_nuevos")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("antiguos")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("vacantes_antiguos")%></div></td>
										<td bgcolor="#C4D7FF"><div align="left"><%=formulario.ObtenerValor("indicador_antiguos")%></div></td>		
									  </tr>
									  <%fila= fila + 1  
									  wend
									  Case 19%>
									  <tr> 
										<td bgcolor="#C4D7FF"><div align="center"><strong>Sede</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Carrera</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Jornada</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Alumnos Carrera</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Total Facultad</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Indicador Facultad(%)</strong></div></td>
										<td bgcolor="#C4D7FF"><div align="center"><strong>Total Universidad</strong></div></td>										
										<td bgcolor="#C4D7FF"><div align="center"><strong>Indicador Universidad(%)</strong></div></td>
									  </tr>
									  <% fila = 1 
										 while formulario.Siguiente %>
									  <tr> 
										<td><div align="left"><%=formulario.ObtenerValor("sede")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("carrera")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("jornada")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("factor_carrera")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("Total_facultad")%></div></td>
										<td bgcolor="#C4D7FF"><div align="left"><%=formulario.ObtenerValor("porcentaje_participacion_facultad")%></div></td>
										<td><div align="left"><%=formulario.ObtenerValor("total_universidad")%></div></td>
										<td bgcolor="#C4D7FF"><div align="left"><%=formulario.ObtenerValor("porcentaje_participacion_universidad")%></div></td>	
										</tr>
									        <%fila= fila + 1  
										wend %>
									  <%End Select%>
									</table>
	</td>
</tr>
</table>

</body>
</html>