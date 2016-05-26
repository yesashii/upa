<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 30000 
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Indicadores Docencia"
'---------------------------------------------------------------------------------------------------

set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion

v_cod_opcion  	= request.querystring("busqueda[0][cod_opcion]")
v_anos  		= request.querystring("busqueda[0][v_anos]")

sql_anos= "(select distinct anos_ccod as v_anos, 'Año '+cast(anos_ccod as varchar) as  anos_tdesc From periodos_academicos Where anos_ccod >=2005) as tabla "

		
sql_opciones= "(  "& vbCrLf &_
			" select 14 as cod_opcion,'Perfiles docentes consolidado' as opcion"& vbCrLf &_
			" union "& vbCrLf &_
			" select 1 as cod_opcion, 'Academicos con titulo Profesional' as opcion  "& vbCrLf &_
			" union "& vbCrLf &_
			" select 2 as cod_opcion,'Academicos con grado Magister' as opcion "& vbCrLf &_
			" union "& vbCrLf &_
			" select 3 as cod_opcion,'Academicos con grado Doctorado' as opcion "& vbCrLf &_
			" union "& vbCrLf &_
			" select 4 as cod_opcion,'Docentes Titulados v/s docentes carreras profesionales' as opcion "& vbCrLf &_
			" union "& vbCrLf &_
			" select 5 as cod_opcion,'Docentes segun edad' as opcion "& vbCrLf &_
			" union "& vbCrLf &_
			" select 6 as cod_opcion,'Docentes segun año ingreso' as opcion "& vbCrLf &_
			" union "& vbCrLf &_
			" select 7 as cod_opcion,'Docentes jornada Hora' as opcion "& vbCrLf &_
			" union "& vbCrLf &_
			" select 8 as cod_opcion,'Docentes jornada Media' as opcion "& vbCrLf &_
			" union "& vbCrLf &_
			" select 9 as cod_opcion,'Docentes jornada Completa' as opcion "& vbCrLf &_
			" union "& vbCrLf &_
			" select 10 as cod_opcion,'Docentes categoria Titular' as opcion "& vbCrLf &_
			" union "& vbCrLf &_
			" select 11 as cod_opcion,'Docentes categoria Asociado' as opcion "& vbCrLf &_
			" union "& vbCrLf &_
			" select 12 as cod_opcion,'Docentes categoria Asistente' as opcion "& vbCrLf &_
			" union "& vbCrLf &_
			" select 13 as cod_opcion,'Docentes categoria Instructor' as opcion "& vbCrLf &_
			" ) as tabla_opcion "

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "indicadores_docencia.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.siguiente
 
f_busqueda.AgregaCampoParam "cod_opcion", "destino", sql_opciones 
f_busqueda.AgregaCampoParam "v_anos", "destino", sql_anos 

f_busqueda.AgregaCampoCons "v_anos", v_anos
f_busqueda.AgregaCampoCons "cod_opcion", v_cod_opcion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "indicadores_docencia.xml", "botonera"

set formulario = new CFormulario
set formulario_facu = new CFormulario

Select Case v_cod_opcion
	Case 1
	img="img/porc_titulo_profesional.bmp"
		tipo_listado="Profesionales"
		formulario.carga_parametros "indicadores_docencia.xml", "grados_docente"
		formulario_facu.carga_parametros "indicadores_docencia.xml", "grados_docente_facu"
		grado = "'PROFESIONAL','LICENCIADO'"
		sql_consulta_count= "Select count(*) from ("&ObtenerProfesional()&") as tabla" 
		v_cantidad_profes=conexion.consultaUno(sql_consulta_count)
' docentes total contratados
		consulta_docentes=ObtenerTotalProfes()
		v_cantidad_docentes=conexion.consultaUno(consulta_docentes)
		consulta=ObtenerGrado_listado(grado,v_cantidad_docentes)
		consulta_facu=ObtenerGrado_listado_facu(grado,v_cantidad_docentes,tipo_listado)
'response.Write("<pre>"&consulta_facu&"</pre>")
'response.End()

	Case 2
	img="img/porc_titulo_magister.bmp"
		tipo_listado="Magister"
		formulario.carga_parametros "indicadores_docencia.xml", "grados_docente"
		formulario_facu.carga_parametros "indicadores_docencia.xml", "grados_docente_facu"
		grado = "'MAGISTER', 'MAESTRIA'"
		sql_consulta_count= "Select count(*) from ("&ObtenerMagister()&") as tabla" 
		v_cantidad_profes=conexion.consultaUno(sql_consulta_count)
' docentes total contratados
		consulta_docentes=ObtenerTotalProfes()
		v_cantidad_docentes=conexion.consultaUno(consulta_docentes)
		consulta=ObtenerGrado_listado(grado,v_cantidad_docentes)
		consulta_facu=ObtenerGrado_listado_facu(grado,v_cantidad_docentes,tipo_listado)
	Case 3
	img="img/porc_titulo_doctor.bmp"
		tipo_listado="Doctores"
		formulario.carga_parametros "indicadores_docencia.xml", "grados_docente"
		formulario_facu.carga_parametros "indicadores_docencia.xml", "grados_docente_facu"
		grado = "'DOCTORADO'"
		sql_consulta_count= "Select count(*) from ("&ObtenerDoctor()&") as tabla" 
		v_cantidad_profes=conexion.consultaUno(sql_consulta_count)
' docentes total contratados
		consulta_docentes=ObtenerTotalProfes()
		v_cantidad_docentes=conexion.consultaUno(consulta_docentes)
		consulta=ObtenerGrado_listado(grado,v_cantidad_docentes)
		consulta_facu=ObtenerGrado_listado_facu(grado,v_cantidad_docentes,tipo_listado)
	Case 4
	
	img="img/relacion_carreras_profesionales.bmp"
		formulario.carga_parametros "indicadores_docencia.xml", "grados_docente"
		formulario_facu.carga_parametros "indicadores_docencia.xml", "grados_docente_facu"
		
		sql_consulta_count= "Select count(*) from ("&ObtenerProfesional()&") as tabla" 
		v_cantidad_profes=conexion.consultaUno(sql_consulta_count)
' docentes total contratados
		consulta_docentes=ObtenerTotalProfesCarrerasProfesionales()
		v_cantidad_docentes=conexion.consultaUno(consulta_docentes)
		tipo_listado="Profesionales"
		consulta=ObtenerProfesCarrerasProfesionales_listado(v_cantidad_docentes)
		consulta_facu=ObtenerProfesCarrerasProfesionales_listado_facu(v_cantidad_docentes)
	Case 5
	img="img/edades.bmp"
		formulario.carga_parametros "indicadores_docencia.xml", "edad_profesores"
		formulario_facu.carga_parametros "indicadores_docencia.xml", "edad_profesores_facu"
		consulta=ObtenerEdadesProfes_listado()
		consulta_facu=ObtenerEdadesProfes_facu()

		sql_suma_cantidad= "select sum (cantidad) as suma_cantidad from ("&ObtenerEdadesProfes()&") as tabla2"
		sql_suma_producto= "select sum (producto) as suma_producto from ("&ObtenerEdadesProfes()&") as tabla2"  
		v_cantidad_suma=conexion.consultaUno(sql_suma_cantidad)
		v_producto_suma=conexion.consultaUno(sql_suma_producto)
		
	Case 6
	img="img/antiguedad.bmp"
		formulario.carga_parametros "indicadores_docencia.xml", "ingreso_profesores"
		formulario_facu.carga_parametros "indicadores_docencia.xml", "ingreso_profesores_facu"
		consulta=ObtenerAntiguedadProfes_listado()
		consulta_facu=ObtenerAntiguedadProfes_facu()
		sql_suma_cantidad= "select sum (cantidad) as suma_cantidad from ("&ObtenerAntiguedadProfes()&") as tabla2"
		sql_suma_producto= "select sum (producto) as suma_producto from ("&ObtenerAntiguedadProfes()&") as tabla2"  
		v_cantidad_suma=conexion.consultaUno(sql_suma_cantidad)
		v_producto_suma=conexion.consultaUno(sql_suma_producto)
	Case 7
	img="img/docentes_jornada_hora.bmp"
		jornada="Hora"		
		formulario.carga_parametros "indicadores_docencia.xml", "jornadas_profesores"
		formulario_facu.carga_parametros "indicadores_docencia.xml", "jornadas_profesores_facu"

		consulta_docentes=ObtenerTotalProfes()
		v_cantidad_docentes=conexion.consultaUno(consulta_docentes)
		consulta=ObtenerJornadaProfesor_listado(jornada,v_cantidad_docentes)
		consulta_facu=ObtenerJornadaProfesor_facu(jornada,v_cantidad_docentes)


		sql_consulta_count= "Select count(*) from ("&ObtenerJornadaProfesor(jornada)&") as tabla" 
		v_cantidad_profes_jornada=conexion.consultaUno(sql_consulta_count)
		' docentes total contratados

	Case 8
	
	img="img/docentes_jornada_media.bmp"
		jornada="Media"
		formulario.carga_parametros "indicadores_docencia.xml", "jornadas_profesores"
		formulario_facu.carga_parametros "indicadores_docencia.xml", "jornadas_profesores_facu"

		' docentes total contratados
		consulta_docentes=ObtenerTotalProfes()
		v_cantidad_docentes=conexion.consultaUno(consulta_docentes)
		consulta=ObtenerJornadaProfesor_listado(jornada,v_cantidad_docentes)
		consulta_facu=ObtenerJornadaProfesor_facu(jornada,v_cantidad_docentes)

		sql_consulta_count= "Select count(*) from ("&ObtenerJornadaProfesor(jornada)&") as tabla" 
		v_cantidad_profes_jornada=conexion.consultaUno(sql_consulta_count)
		
	Case 9
	
	img="img/docentes_jornada_completa.bmp"
		jornada="Completa"
		formulario.carga_parametros "indicadores_docencia.xml", "jornadas_profesores"
		formulario_facu.carga_parametros "indicadores_docencia.xml", "jornadas_profesores_facu"

		' docentes total contratados
		consulta_docentes=ObtenerTotalProfes()
		v_cantidad_docentes=conexion.consultaUno(consulta_docentes)
		consulta=ObtenerJornadaProfesor_listado(jornada,v_cantidad_docentes)
		consulta_facu=ObtenerJornadaProfesor_facu(jornada,v_cantidad_docentes)

		sql_consulta_count= "Select count(*) from ("&ObtenerJornadaProfesor(jornada)&") as tabla" 
		v_cantidad_profes_jornada=conexion.consultaUno(sql_consulta_count)

	Case 10
	
	img="img/docentes_categoria.bmp"
		tipo_categoria="Titular"
		categoria="1,2"
		formulario.carga_parametros "indicadores_docencia.xml", "categorias_docente"
		formulario_facu.carga_parametros "indicadores_docencia.xml", "categorias_docente_facu"
		
		' docentes total contratados
		consulta_docentes=ObtenerTotalProfes()
		v_cantidad_docentes=conexion.consultaUno(consulta_docentes)
		consulta=ObtenerCategoriaProfesor_listado(categoria,v_cantidad_docentes)
		consulta_facu=ObtenerCategoriaProfesor_facu(categoria,v_cantidad_docentes)

		sql_consulta_count= "Select count(*) from ("&ObtenerCategoriaProfesor(categoria)&") as tabla" 
		v_cantidad_profes_categoria=conexion.consultaUno(sql_consulta_count)
		
	Case 11
	
	img="img/docentes_categoria.bmp"
		tipo_categoria="Asociado"
		categoria="3,4"
		formulario.carga_parametros "indicadores_docencia.xml", "categorias_docente"
		formulario_facu.carga_parametros "indicadores_docencia.xml", "categorias_docente_facu"
		
		' docentes total contratados
		consulta_docentes=ObtenerTotalProfes()
		v_cantidad_docentes=conexion.consultaUno(consulta_docentes)
		consulta=ObtenerCategoriaProfesor_listado(categoria,v_cantidad_docentes)
		consulta_facu=ObtenerCategoriaProfesor_facu(categoria,v_cantidad_docentes)

		sql_consulta_count= "Select count(*) from ("&ObtenerCategoriaProfesor(categoria)&") as tabla" 
		v_cantidad_profes_categoria=conexion.consultaUno(sql_consulta_count)

	Case 12
	
	img="img/docentes_categoria.bmp"
		tipo_categoria="Asistente"
		categoria="5,6"
		formulario.carga_parametros "indicadores_docencia.xml", "categorias_docente"
		formulario_facu.carga_parametros "indicadores_docencia.xml", "categorias_docente_facu"
		
		' docentes total contratados
		consulta_docentes=ObtenerTotalProfes()
		v_cantidad_docentes=conexion.consultaUno(consulta_docentes)
		consulta=ObtenerCategoriaProfesor_listado(categoria,v_cantidad_docentes)
		consulta_facu=ObtenerCategoriaProfesor_facu(categoria,v_cantidad_docentes)

		sql_consulta_count= "Select count(*) from ("&ObtenerCategoriaProfesor(categoria)&") as tabla" 
		v_cantidad_profes_categoria=conexion.consultaUno(sql_consulta_count)

	Case 13
	
	img="img/docentes_categoria.bmp"
		tipo_categoria="Instructor"
		categoria="7,8"
		formulario.carga_parametros "indicadores_docencia.xml", "categorias_docente"
		formulario_facu.carga_parametros "indicadores_docencia.xml", "categorias_docente_facu"
		
		' docentes total contratados
		consulta_docentes=ObtenerTotalProfes()
		v_cantidad_docentes=conexion.consultaUno(consulta_docentes)
		consulta=ObtenerCategoriaProfesor_listado(categoria,v_cantidad_docentes)
		consulta_facu=ObtenerCategoriaProfesor_facu(categoria,v_cantidad_docentes)

		sql_consulta_count= "Select count(*) from ("&ObtenerCategoriaProfesor(categoria)&") as tabla" 
		v_cantidad_profes_categoria=conexion.consultaUno(sql_consulta_count)

	Case 14
	
	img="img/consolidado.bmp"
		formulario.carga_parametros "indicadores_docencia.xml", "grados_consolidados_escuela"
		formulario_facu.carga_parametros "indicadores_docencia.xml", "grados_consolidados_facu"

		consulta_docentes=ObtenerTotalProfes()
		v_cantidad_docentes=conexion.consultaUno(consulta_docentes)
		
		consulta_consolidado=GradosConsolidados(v_cantidad_docentes)
		consulta=GradosConsolidadosEscuelas(v_cantidad_docentes)
		consulta_facu=GradosConsolidadosFacultades(v_cantidad_docentes)
End select



if not Esvacio(Request.QueryString) then

	formulario.inicializar conexion 
	formulario.Consultar consulta


	if v_cod_opcion=14 then
		set formulario_consolidado = new CFormulario
		formulario_consolidado.carga_parametros "indicadores_docencia.xml", "grados_consolidados" 
		formulario_consolidado.inicializar conexion 
		formulario_consolidado.Consultar consulta_consolidado
	end if

		formulario_facu.inicializar conexion 
		formulario_facu.Consultar consulta_facu

else
v_cantidad_profes=0
v_cantidad_docentes=0
	set formulario = new CFormulario
	set formulario_facu = new CFormulario
	formulario.inicializar conexion
	formulario_facu.inicializar conexion

	formulario.carga_parametros "indicadores_docencia.xml", "formulario_vacio" 
	formulario.Consultar "select '' where 1=2 "

	formulario_facu.carga_parametros "indicadores_docencia.xml", "formulario_vacio" 
	formulario_facu.Consultar "select '' where 1=2 "
end if


Function ObtenerTotalProfes()
	sql_indicador=	" select count(*) as cantitad "& vbCrLf &_
					" from ( "& vbCrLf &_
					"     select  distinct a.pers_ncorr "& vbCrLf &_
					"     from contratos_docentes_upa a, anexos b, carreras e "& vbCrLf &_
					"     where ano_contrato="&v_anos&" "& vbCrLf &_
					"     and a.cdoc_ncorr=b.cdoc_ncorr "& vbCrLf &_
					"     and a.ecdo_ccod not in (3) "& vbCrLf &_
					" 	  and b.eane_ccod     <> 3  "& vbCrLf &_
					"     and b.carr_ccod=e.carr_ccod "& vbCrLf &_
					"     and e.tcar_ccod=1 "& vbCrLf &_
					"     and a.tpro_ccod=1 "& vbCrLf &_
					" ) as tabla" 
    ObtenerTotalProfes=sql_indicador				
end function


Function ObtenerProfesional()
	sql_indicador=	" select distinct protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_docente, "& vbCrLf &_
					" 'PROFESIONAL' as grado "& vbCrLf &_
					" from contratos_docentes_upa a, anexos b, carreras e "& vbCrLf &_
					" where ano_contrato="&v_anos&" "& vbCrLf &_
					" and a.cdoc_ncorr=b.cdoc_ncorr "& vbCrLf &_
					" and a.ecdo_ccod not in (3) "& vbCrLf &_
					" and b.eane_ccod     <> 3  "& vbCrLf &_
					" and a.tpro_ccod=1 "& vbCrLf &_
					" and b.carr_ccod=e.carr_ccod "& vbCrLf &_
					" and e.tcar_ccod=1 "& vbCrLf &_
					" and protic.obtener_grado_docente(a.pers_ncorr,'U') in ('PROFESIONAL','LICENCIADO') "         
    ObtenerProfesional=sql_indicador				
end function

Function ObtenerMagister()
	sql_indicador=	" select distinct protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_docente, "& vbCrLf &_
					" protic.obtener_grado_docente(a.pers_ncorr,'U') as grado "& vbCrLf &_
					" from contratos_docentes_upa a, anexos b, carreras e "& vbCrLf &_
					" where ano_contrato="&v_anos&" "& vbCrLf &_
					" and a.cdoc_ncorr=b.cdoc_ncorr "& vbCrLf &_
					" and a.ecdo_ccod not in (3) "& vbCrLf &_
					" and b.eane_ccod     <> 3  "& vbCrLf &_
					" and a.tpro_ccod=1 "& vbCrLf &_
					" and b.carr_ccod=e.carr_ccod "& vbCrLf &_
					" and e.tcar_ccod=1 "& vbCrLf &_					
					" and protic.obtener_grado_docente(a.pers_ncorr,'U') in ('MAGISTER', 'MAESTRIA') "         
      
    ObtenerMagister=sql_indicador				
end function

Function ObtenerDoctor()
	sql_indicador=	" select distinct protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_docente, "& vbCrLf &_
				" protic.obtener_grado_docente(a.pers_ncorr,'U') as grado "& vbCrLf &_
				" from contratos_docentes_upa a, anexos b, carreras e "& vbCrLf &_
				" where ano_contrato="&v_anos&" "& vbCrLf &_
				" and a.cdoc_ncorr=b.cdoc_ncorr "& vbCrLf &_
				" and a.ecdo_ccod not in (3) "& vbCrLf &_
				" and b.eane_ccod     <> 3  "& vbCrLf &_
				" and a.tpro_ccod=1 "& vbCrLf &_
				" and b.carr_ccod=e.carr_ccod "& vbCrLf &_
				" and e.tcar_ccod=1 "& vbCrLf &_
				" and protic.obtener_grado_docente(a.pers_ncorr,'U') in ('DOCTORADO') "         
    ObtenerDoctor=sql_indicador				
end function


Function ObtenerGrado_listado(grado, total)

	sql_indicador=	"select sede,carrera,jornada, grado, count(*) as cantidad, valor, valor_escuela, "& vbCrLf &_
					" cast(cast((count(*)*100.00)/valor as decimal(5,2)) as varchar)+' %' as indice,  "& vbCrLf &_
					" cast(cast((count(*)*100.00)/valor_escuela as decimal(5,2)) as varchar)+' %' as indice_escuela  "& vbCrLf &_
					"	from ( "& vbCrLf &_
					"	select distinct carr_tdesc as carrera, jorn_tdesc as jornada,sede_tdesc as sede, "& vbCrLf &_
					"	protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_docente, "& vbCrLf &_
					"	protic.obtener_grado_docente(a.pers_ncorr,'U') as grado, "& vbCrLf &_
					"	'"&total&"' as valor, protic.obtener_docentes_escuela("&v_anos&",b.sede_ccod,b.carr_ccod,b.jorn_ccod) as valor_escuela "& vbCrLf &_
					" from contratos_docentes_upa a, anexos b, carreras e, jornadas f, sedes g "& vbCrLf &_
					" where ano_contrato="&v_anos&" "& vbCrLf &_
					" and a.cdoc_ncorr=b.cdoc_ncorr "& vbCrLf &_
					" and a.ecdo_ccod not in (3) "& vbCrLf &_
					" and b.eane_ccod     <> 3  "& vbCrLf &_
					" and a.tpro_ccod=1 "& vbCrLf &_
					" and b.carr_ccod=e.carr_ccod "& vbCrLf &_
					" and b.jorn_ccod=f.jorn_ccod "& vbCrLf &_
					" and e.tcar_ccod=1 "& vbCrLf &_
					" and protic.obtener_grado_docente(a.pers_ncorr,'U') in ("&grado&") "& vbCrLf &_
					" ) as tabla "& vbCrLf &_
					" group by sede,carrera,jornada,grado,valor, valor_escuela "

'response.Write("<pre>"&sql_indicador&"</pre>")
'response.Flush()
    ObtenerGrado_listado=sql_indicador				
end function

Function ObtenerGrado_listado_facu(grado, total,grado_desc)
	sql_indicador=	"select facultad, count(*) as cantidad, valor,valor_facultad,  "& vbCrLf &_
					" cast(cast((count(*)*100.00)/valor as decimal(5,2)) as varchar)+' %' as indice,  "& vbCrLf &_
					" cast(cast((count(*)*100.00)/valor_facultad as decimal(5,2)) as varchar)+' %' as indice_facultad  "& vbCrLf &_
					"	from ( "& vbCrLf &_
					"	select distinct facu_tdesc as facultad,protic.obtener_docentes_facultad("&v_anos&",i.facu_ccod) as valor_facultad, "& vbCrLf &_
					"	"&total&" as valor,'"&grado_desc&"' as grado, a.pers_ncorr "& vbCrLf &_
					" from contratos_docentes_upa a, anexos b, carreras e, "& vbCrLf &_
					" jornadas f, sedes g, areas_academicas h, facultades i "& vbCrLf &_
					" where ano_contrato="&v_anos&" "& vbCrLf &_
					" and a.cdoc_ncorr=b.cdoc_ncorr "& vbCrLf &_
					" and a.ecdo_ccod not in (3) "& vbCrLf &_
					" and b.eane_ccod     <> 3  "& vbCrLf &_
					" and a.tpro_ccod=1 "& vbCrLf &_
					" and b.carr_ccod=e.carr_ccod "& vbCrLf &_
					" and b.jorn_ccod=f.jorn_ccod "& vbCrLf &_
					" and b.sede_ccod=g.sede_ccod "& vbCrLf &_
					" and e.area_ccod=h.area_ccod "& vbCrLf &_
					" and h.facu_ccod=i.facu_ccod "& vbCrLf &_
					" and e.tcar_ccod=1 "& vbCrLf &_
					" and protic.obtener_grado_docente(a.pers_ncorr,'U') in ("&grado&") "& vbCrLf &_
					" ) as tabla "& vbCrLf &_
					" group by facultad,grado,valor,valor_facultad "
'response.Write("<pre>"&sql_indicador&"</pre>")         
    ObtenerGrado_listado_facu=sql_indicador				
end function

Function ObtenerTotalProfesCarrerasProfesionales()
	sql_indicador=	" select count(*) from ( "& vbCrLf &_
					" select distinct a.pers_ncorr "& vbCrLf &_
					" from contratos_docentes_upa a, anexos b, carreras e "& vbCrLf &_
					" where ano_contrato="&v_anos&" "& vbCrLf &_
					" and a.cdoc_ncorr=b.cdoc_ncorr "& vbCrLf &_
					" and a.ecdo_ccod not in (3) "& vbCrLf &_
					" and b.eane_ccod     <> 3  "& vbCrLf &_
					" and a.tpro_ccod=1 "& vbCrLf &_
					" and b.carr_ccod=e.carr_ccod "& vbCrLf &_
					" and e.tcar_ccod=1 "& vbCrLf &_
					" and protic.obtener_grado_docente(a.pers_ncorr,'U') in ('PROFESIONAL','LICENCIADO','DOCTOR','MAGISTER') "& vbCrLf &_
					" and b.carr_ccod in (select carr_ccod "& vbCrLf &_
					" 					 from carreras "& vbCrLf &_
					" 					where tgra_ccod in (2,3,7))"& vbCrLf &_
					" ) as tabla "         
    ObtenerTotalProfesCarrerasProfesionales=sql_indicador				
end function

Function ObtenerProfesCarrerasProfesionales_listado(total)
	sql_indicador=	" select *, cast(cast((cantidad*100.00)/valor as decimal(8,2)) as varchar)+' %' as indice, "& vbCrLf &_
					" cast(cast((cantidad*100.00)/valor_escuela as decimal(8,2)) as varchar)+' %' as indice_escuela "& vbCrLf &_
					" from (select grado,sede,carrera,jornada,count(*) as cantidad, "& vbCrLf &_
					" "&total&" as valor,protic.obtener_docentes_escuela("&v_anos&",sede_ccod,carr_ccod,jorn_ccod) as valor_escuela "& vbCrLf &_
					" from ( "& vbCrLf &_
					" select  distinct a.pers_ncorr, protic.obtener_grado_docente(a.pers_ncorr,'U') as grado,"& vbCrLf &_
					"  carr_tdesc as carrera,  jorn_tdesc as jornada, sede_tdesc as sede,b.sede_ccod,b.carr_ccod,b.jorn_ccod "& vbCrLf &_ 
					" from contratos_docentes_upa a, anexos b,  "& vbCrLf &_
					" carreras e, jornadas f, sedes g "& vbCrLf &_
					" where ano_contrato="&v_anos&" "& vbCrLf &_
					" and a.cdoc_ncorr=b.cdoc_ncorr "& vbCrLf &_
					" and a.ecdo_ccod not in (3) "& vbCrLf &_
					" and b.eane_ccod     <> 3  "& vbCrLf &_
					" and a.tpro_ccod=1 "& vbCrLf &_
					" and b.carr_ccod=e.carr_ccod "& vbCrLf &_
					" and b.jorn_ccod=f.jorn_ccod "& vbCrLf &_
					" and b.sede_ccod=g.sede_ccod "& vbCrLf &_
					" and e.tcar_ccod=1 "& vbCrLf &_
					" and protic.obtener_grado_docente(a.pers_ncorr,'U') in ('PROFESIONAL','LICENCIADO') "& vbCrLf &_   
					" and b.carr_ccod in (select carr_ccod "& vbCrLf &_
					" 					 from carreras "& vbCrLf &_
					" 					where tgra_ccod in (2,3,7))"& vbCrLf &_
					" ) as tabla "& vbCrLf &_
					" group by grado,sede,carrera,jornada,sede_ccod,carr_ccod,jorn_ccod ) as tabla_final "  
'response.Write("<pre>"&sql_indicador&"</pre>")   
'response.Flush()    
    ObtenerProfesCarrerasProfesionales_listado=sql_indicador				
end function

Function ObtenerProfesCarrerasProfesionales_listado_facu(total)
	sql_indicador=	" select *, cast(cast((cantidad*100.00)/valor as decimal(8,2)) as varchar)+' %' as indice, "& vbCrLf &_
					" cast(cast((cantidad*100.00)/valor_facultad as decimal(6,2)) as varchar)+' %' as indice_facultad  "& vbCrLf &_
					" from (select grado,facultad,count(*) as cantidad, "& vbCrLf &_
					" "&total&" as valor,protic.obtener_docentes_facultad("&v_anos&",facu_ccod) as valor_facultad "& vbCrLf &_
					" from ( "& vbCrLf &_
					" select  distinct facu_tdesc as facultad,a.pers_ncorr, 'Profesionales' as grado, "& vbCrLf &_
					"  i.facu_ccod,carr_tdesc as carrera,  jorn_tdesc as jornada, sede_tdesc as sede "& vbCrLf &_ 
					" from contratos_docentes_upa a, anexos b,  "& vbCrLf &_
					" carreras e, jornadas f, sedes g, areas_academicas h, facultades i "& vbCrLf &_
					" where ano_contrato="&v_anos&" "& vbCrLf &_
					" and a.cdoc_ncorr=b.cdoc_ncorr "& vbCrLf &_
					" and a.ecdo_ccod not in (3) "& vbCrLf &_
					" and b.eane_ccod     <> 3  "& vbCrLf &_
					" and a.tpro_ccod=1 "& vbCrLf &_
					" and b.carr_ccod=e.carr_ccod "& vbCrLf &_
					" and b.jorn_ccod=f.jorn_ccod "& vbCrLf &_
					" and b.sede_ccod=g.sede_ccod "& vbCrLf &_
					" and e.area_ccod=h.area_ccod "& vbCrLf &_
					" and h.facu_ccod=i.facu_ccod "& vbCrLf &_
					" and e.tcar_ccod=1 "& vbCrLf &_
					" and protic.obtener_grado_docente(a.pers_ncorr,'U') in ('PROFESIONAL','LICENCIADO') "& vbCrLf &_   
					" and b.carr_ccod in (select carr_ccod "& vbCrLf &_
					" 					 from carreras "& vbCrLf &_
					" 					where tgra_ccod in (2,3,7))"& vbCrLf &_
					" ) as tabla "& vbCrLf &_
					" group by facultad,grado,facu_ccod ) as tabla_final "  
'response.Write("<pre>"&sql_indicador&"</pre>")   
'response.Flush()         
    ObtenerProfesCarrerasProfesionales_listado_facu=sql_indicador				
end function

Function ObtenerEdadesProfes()
	sql_indicador=	" select edad,count(*) as cantidad,  (edad*count(*)) as producto "& vbCrLf &_
					" from  ( "& vbCrLf &_
					" 	select distinct DATEDIFF(year,isnull(c.pers_fnacimiento,getdate()),DATEADD(year,"&v_anos&"-year(getdate()),getdate())) as edad,  "& vbCrLf &_
					"   protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_docente "& vbCrLf &_
					" 	from contratos_docentes_upa a, anexos b, personas c, carreras e "& vbCrLf &_
					" 	where ano_contrato="&v_anos&" "& vbCrLf &_
					" 	and a.cdoc_ncorr=b.cdoc_ncorr "& vbCrLf &_
					" 	and a.pers_ncorr=c.pers_ncorr "& vbCrLf &_
					" 	and a.ecdo_ccod not in (3) "& vbCrLf &_
					"   and b.eane_ccod     <> 3  "& vbCrLf &_
					" 	and a.tpro_ccod=1 "& vbCrLf &_
					"   and b.carr_ccod=e.carr_ccod "& vbCrLf &_
					"   and e.tcar_ccod=1 "& vbCrLf &_
					" ) as tabla "& vbCrLf &_
					" group by edad "         
    ObtenerEdadesProfes=sql_indicador				
end function

Function ObtenerEdadesProfes_listado()
	sql_indicador=	" select *, cast((suma*1.0/cantidad) as decimal(5,2)) as promedio from ( "& vbCrLf &_
					" select sede,carrera,jornada,sum(edad) as suma,count(*) as cantidad "& vbCrLf &_
					"  from  (   "& vbCrLf &_
					"	select distinct DATEDIFF(year,isnull(c.pers_fnacimiento,getdate()),DATEADD(year,"&v_anos&"-year(getdate()),getdate())) as edad,    "& vbCrLf &_
					"	protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_docente, "& vbCrLf &_
					"	carr_tdesc as carrera,  jorn_tdesc as jornada, sede_tdesc as sede "& vbCrLf &_ 
					"	from contratos_docentes_upa a, anexos b, personas c, carreras e, jornadas f, sedes g "& vbCrLf &_   
					"	where ano_contrato= "&v_anos&" "& vbCrLf &_
					"	and a.cdoc_ncorr=b.cdoc_ncorr  "& vbCrLf &_ 
					"	and a.pers_ncorr=c.pers_ncorr "& vbCrLf &_  
					"	and a.ecdo_ccod not in (3) "& vbCrLf &_
					"   and b.eane_ccod     <> 3  "& vbCrLf &_  
					"	and a.tpro_ccod=1 "& vbCrLf &_
					"	and b.carr_ccod=e.carr_ccod "& vbCrLf &_
					"	and b.jorn_ccod=f.jorn_ccod "& vbCrLf &_
					"	and b.sede_ccod=g.sede_ccod "& vbCrLf &_  
					"   and e.tcar_ccod=1 "& vbCrLf &_ 
					"  ) as tabla "& vbCrLf &_  
					"  group by sede,carrera,jornada "& vbCrLf &_
					" ) as tabla"     
    
    ObtenerEdadesProfes_listado=sql_indicador				
end function

Function ObtenerEdadesProfes_facu()
	sql_indicador=	" select *, cast((suma*1.0/cantidad) as decimal(5,2)) as promedio from ( "& vbCrLf &_
					" select facultad,sum(edad) as suma,count(*) as cantidad "& vbCrLf &_
					"  from  (   "& vbCrLf &_
					"	select distinct DATEDIFF(year,isnull(c.pers_fnacimiento,getdate()),DATEADD(year,"&v_anos&"-year(getdate()),getdate())) as edad,    "& vbCrLf &_
					"	protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_docente, "& vbCrLf &_
					"	i.facu_tdesc as facultad "& vbCrLf &_ 
					"	from contratos_docentes_upa a, anexos b, personas c, carreras e, "& vbCrLf &_
					" 	jornadas f, sedes g,areas_academicas j, facultades i "& vbCrLf &_   
					"	where ano_contrato= "&v_anos&" "& vbCrLf &_
					"	and a.cdoc_ncorr=b.cdoc_ncorr  "& vbCrLf &_ 
					"	and a.pers_ncorr=c.pers_ncorr "& vbCrLf &_  
					"	and a.ecdo_ccod not in (3) "& vbCrLf &_
					"   and b.eane_ccod     <> 3  "& vbCrLf &_  
					"	and a.tpro_ccod=1 "& vbCrLf &_
					"	and b.carr_ccod=e.carr_ccod "& vbCrLf &_
					"	and b.jorn_ccod=f.jorn_ccod "& vbCrLf &_
					"	and b.sede_ccod=g.sede_ccod "& vbCrLf &_ 
					"	and e.area_ccod=j.area_ccod "& vbCrLf &_
					"	and j.facu_ccod=i.facu_ccod "& vbCrLf &_
					"   and e.tcar_ccod=1 "& vbCrLf &_ 
					"  ) as tabla "& vbCrLf &_  
					"  group by facultad "& vbCrLf &_
					" ) as tabla"     
    
    ObtenerEdadesProfes_facu=sql_indicador				
end function

Function ObtenerAntiguedadProfes()
	sql_indicador=	" select antiguedad,ingreso,count(*) as cantidad,  (antiguedad*count(*)) as producto "& vbCrLf &_
					" from  ( "& vbCrLf &_
					" 	select distinct isnull(min(prof_ingreso_uas),year(getdate())) as ingreso, "&v_anos&"-isnull(min(prof_ingreso_uas),year(getdate())) as antiguedad,  "& vbCrLf &_
					"   protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_docente "& vbCrLf &_
					" 	from contratos_docentes_upa a, anexos b, personas c, profesores d, carreras e "& vbCrLf &_
					" 	where ano_contrato="&v_anos&" "& vbCrLf &_
					" 	and a.cdoc_ncorr=b.cdoc_ncorr "& vbCrLf &_
					" 	and a.pers_ncorr=c.pers_ncorr "& vbCrLf &_
					" 	and a.ecdo_ccod not in (3) "& vbCrLf &_
					"   and b.eane_ccod     <> 3  "& vbCrLf &_
					" 	and c.pers_ncorr=d.pers_ncorr "& vbCrLf &_
					" 	and d.tpro_ccod=1 "& vbCrLf &_
					" 	and a.tpro_ccod=1 "& vbCrLf &_
					"   and b.carr_ccod=e.carr_ccod "& vbCrLf &_
					"   and e.tcar_ccod=1 "& vbCrLf &_
					"   group by a.pers_ncorr "& vbCrLf &_
					" ) as tabla "& vbCrLf &_
					" group by ingreso,antiguedad "         
    ObtenerAntiguedadProfes=sql_indicador				
end function

Function ObtenerAntiguedadProfes_listado()
	sql_indicador=	" select *, cast((suma*1.0/cantidad) as decimal(5,2)) as promedio from ( "& vbCrLf &_
					" select sede, carrera,jornada,sum(antiguedad) as suma,count(*) as cantidad "& vbCrLf &_
					" from  ( "& vbCrLf &_
					" 	select distinct isnull(min(prof_ingreso_uas),year(getdate())) as ingreso, "&v_anos&"-isnull(min(prof_ingreso_uas),year(getdate())) as antiguedad,  "& vbCrLf &_
					"   protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_docente, "& vbCrLf &_
					"	carr_tdesc as carrera,  jorn_tdesc as jornada, sede_tdesc as sede "& vbCrLf &_ 
					" 	from contratos_docentes_upa a, anexos b, personas c, profesores d, carreras e, jornadas f, sedes g  "& vbCrLf &_
					" 	where ano_contrato="&v_anos&" "& vbCrLf &_
					" 	and a.cdoc_ncorr=b.cdoc_ncorr "& vbCrLf &_
					" 	and a.pers_ncorr=c.pers_ncorr "& vbCrLf &_
					" 	and a.ecdo_ccod not in (3) "& vbCrLf &_
					"   and b.eane_ccod   <> 3  "& vbCrLf &_
					" 	and c.pers_ncorr=d.pers_ncorr "& vbCrLf &_
					" 	and d.tpro_ccod=1 "& vbCrLf &_
					" 	and a.tpro_ccod=1 "& vbCrLf &_
					"	and b.carr_ccod=e.carr_ccod "& vbCrLf &_
					"	and b.jorn_ccod=f.jorn_ccod "& vbCrLf &_
					"	and b.sede_ccod=g.sede_ccod "& vbCrLf &_ 
					"   and e.tcar_ccod=1 "& vbCrLf &_
					"   group by a.pers_ncorr,carr_tdesc,jorn_tdesc,sede_tdesc "& vbCrLf &_  
					" ) as tabla "& vbCrLf &_
					" group by sede, carrera,jornada "& vbCrLf &_
					" ) as tabla"       
       
    ObtenerAntiguedadProfes_listado=sql_indicador				
end function

Function ObtenerAntiguedadProfes_facu()
	sql_indicador=	" select *, cast((suma*1.0/cantidad) as decimal(5,2)) as promedio from ( "& vbCrLf &_
					" select facultad,sum(antiguedad) as suma,count(*) as cantidad "& vbCrLf &_
					" from  ( "& vbCrLf &_
					" 	select distinct isnull(min(prof_ingreso_uas),year(getdate())) as ingreso, "&v_anos&"-isnull(min(prof_ingreso_uas),year(getdate())) as antiguedad,  "& vbCrLf &_
					"   protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_docente, "& vbCrLf &_
					"	i.facu_tdesc as facultad "& vbCrLf &_ 
					" 	from contratos_docentes_upa a, anexos b, personas c, profesores d, "& vbCrLf &_
					"   carreras e, jornadas f, sedes g, areas_academicas j, facultades i  "& vbCrLf &_
					" 	where ano_contrato="&v_anos&" "& vbCrLf &_
					" 	and a.cdoc_ncorr=b.cdoc_ncorr "& vbCrLf &_
					" 	and a.pers_ncorr=c.pers_ncorr "& vbCrLf &_
					" 	and a.ecdo_ccod not in (3) "& vbCrLf &_
					"   and b.eane_ccod <> 3  "& vbCrLf &_
					" 	and c.pers_ncorr=d.pers_ncorr "& vbCrLf &_
					" 	and d.tpro_ccod=1 "& vbCrLf &_
					" 	and a.tpro_ccod=1 "& vbCrLf &_
					"	and b.carr_ccod=e.carr_ccod "& vbCrLf &_
					"	and b.jorn_ccod=f.jorn_ccod "& vbCrLf &_
					"	and b.sede_ccod=g.sede_ccod "& vbCrLf &_
					"	and e.area_ccod=j.area_ccod "& vbCrLf &_
					"	and j.facu_ccod=i.facu_ccod "& vbCrLf &_
					"   and e.tcar_ccod=1 "& vbCrLf &_
					"   group by a.pers_ncorr,i.facu_tdesc "& vbCrLf &_        
					" ) as tabla "& vbCrLf &_
					" group by facultad "& vbCrLf &_
					" ) as tabla"       
       
    ObtenerAntiguedadProfes_facu=sql_indicador				
end function

Function ObtenerJornadaProfesor(jornada)
	sql_indicador=	" select * from ( "& vbCrLf &_
					" select aa.pers_ncorr,aa.rut, "& vbCrLf &_
					" bb.pers_tnombre as nombre_docente, bb.pers_tape_paterno+' '+bb.pers_tape_materno as apellido_docente, "& vbCrLf &_
					" aa.grado,aa.descripcion_grado, sum(hora_semana) as horas_semanales, "& vbCrLf &_
					" case when sum(hora_semana)>=40 then 'Completa' when sum(hora_semana)<19 then 'Hora' else 'Media' end as jornada "& vbCrLf &_
					" from  ( "& vbCrLf &_
					" 		select pers_ncorr,rut, "& vbCrLf &_
					" 		protic.obtener_grado_docente(pers_ncorr,'U') as grado, "& vbCrLf &_
					" 		protic.obtener_grado_docente(pers_ncorr,'D') as descripcion_grado, "& vbCrLf &_
					" 		((sum(horas)*75)/60)/case regimen when 'ANUAL'then 36 "& vbCrLf &_
					" 										  when 'SEMESTRAL'then 18 "& vbCrLf &_
					" 										  when 'TRIMESTRAL'then 12 "& vbCrLf &_
					" 										  when 'PERIODO'then 12 end  as hora_semana "& vbCrLf &_
					" 		from ( "& vbCrLf &_
					" 			select protic.obtener_rut(pers_ncorr) as rut,pers_ncorr, "& vbCrLf &_
					" 			cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen    "& vbCrLf &_
					" 			from (   "& vbCrLf &_
					" 				select  a.pers_ncorr,(c.dane_nsesiones/2) as sesiones,c.duas_ccod,  "& vbCrLf &_
					" 				b.anex_ncorr,c.dane_msesion as monto_cuota    "& vbCrLf &_
					" 				  From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,     "& vbCrLf &_
					" 							 asignaturas j, secciones n,tipos_profesores o,profesores p       "& vbCrLf &_
					" 						  Where a.cdoc_ncorr     =   b.cdoc_ncorr      "& vbCrLf &_
					" 							 and b.anex_ncorr    =   c.anex_ncorr      "& vbCrLf &_
					" 							 and a.pers_ncorr    =   d.pers_ncorr      "& vbCrLf &_
					" 							 and b.sede_ccod     =   e.sede_ccod       "& vbCrLf &_
					" 							 and c.asig_ccod     =   j.asig_ccod       "& vbCrLf &_
					" 							 and n.secc_ccod     =   c.secc_ccod       "& vbCrLf &_
					" 							 and o.TPRO_CCOD     =   p.TPRO_CCOD       "& vbCrLf &_
					" 							 and p.pers_ncorr    =   d.pers_ncorr      "& vbCrLf &_
					" 							 --AND b.SEDE_CCOD     =   p.sede_ccod       "& vbCrLf &_
					" 							 and a.ecdo_ccod     <> 3     "& vbCrLf &_
					" 							 and b.eane_ccod     <> 3 "& vbCrLf &_
					" 							 and a.tpro_ccod=1     "& vbCrLf &_
					" 							 and a.ano_contrato="&v_anos&" "& vbCrLf &_
					" 							 and n.carr_ccod in (select carr_ccod from carreras where tcar_ccod=1) "& vbCrLf &_
					" 							 and a.pers_ncorr not in (27208)     "& vbCrLf &_
					" 				group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,c.duas_ccod "& vbCrLf &_
					" 			 ) as aa,     "& vbCrLf &_
					" 			anexos b, duracion_asignatura c    "& vbCrLf &_
					" 			where aa.anex_ncorr=b.anex_ncorr "& vbCrLf &_
					" 			and  aa.duas_ccod=c.duas_ccod "& vbCrLf &_
					" 			group by b.anex_ncorr,pers_ncorr,b.anex_nhoras_coordina,monto_cuota,b.anex_ncuotas,duas_tdesc "& vbCrLf &_
					" 		) as t "& vbCrLf &_
					" 		group by rut,regimen,pers_ncorr "& vbCrLf &_
					" ) as aa , personas bb "& vbCrLf &_
					" where aa.pers_ncorr=bb.pers_ncorr "& vbCrLf &_
					" --and aa.pers_ncorr not in ( select distinct pers_ncorr from administrativos_docentes where admd_jornada in (1,2) and pers_ncorr not in (12258)) "& vbCrLf &_
					" group by  aa.pers_ncorr,aa.rut,aa.grado,aa.descripcion_grado, "& vbCrLf &_
					" bb.pers_tnombre, bb.pers_tape_paterno, bb.pers_tape_materno   "& vbCrLf &_
					" ) as tabla "& vbCrLf &_
					" where jornada like '"&jornada&"' "         
'response.Write("<pre>"&sql_indicador&"</pre>")
'response.End()
    ObtenerJornadaProfesor=sql_indicador				
end function

Function ObtenerJornadaProfesor_listado(jornada, total)
	sql_indicador=	" Select k.sede_tdesc as sede,c.carr_tdesc as carrera,j.jorn_tdesc as jornada, count(*) as cantidad , "& vbCrLf &_
					" protic.obtener_docentes_escuela("&v_anos&",an.sede_ccod,an.carr_ccod,an.jorn_ccod) as valor_escuela,  "& vbCrLf &_
					" total as total_docentes, cast(cast((count(*)*100.00)/total as decimal(8,2)) as varchar)+' %' as indice, "& vbCrLf &_
					" cast(cast((count(*)*100.00)/protic.obtener_docentes_escuela("&v_anos&",an.sede_ccod,an.carr_ccod,an.jorn_ccod) as decimal(8,2)) as varchar)+' %' as indice_escuela "& vbCrLf &_
					" from (  "& vbCrLf &_
					" select aa.pers_ncorr,aa.rut,"&total&" as total, "& vbCrLf &_
					" bb.pers_tnombre as nombre_docente, bb.pers_tape_paterno+' '+bb.pers_tape_materno as apellido_docente,  "& vbCrLf &_
					" aa.grado,aa.descripcion_grado, sum(hora_semana) as horas_semanales,  "& vbCrLf &_
					" case when sum(hora_semana)>=40 then 'Completa' when sum(hora_semana)<19 then 'Hora' else 'Media' end as horas_jornada  "& vbCrLf &_
					" from  (  "& vbCrLf &_
					"		select pers_ncorr,rut, "& vbCrLf &_
					"		protic.obtener_grado_docente(pers_ncorr,'U') as grado,  "& vbCrLf &_
					"		protic.obtener_grado_docente(pers_ncorr,'D') as descripcion_grado,  "& vbCrLf &_
					"		((sum(horas)*75)/60)/case regimen when 'ANUAL'then 36  "& vbCrLf &_
					"										  when 'SEMESTRAL'then 18  "& vbCrLf &_
					"										  when 'TRIMESTRAL'then 12  "& vbCrLf &_
					"										  when 'PERIODO'then 12 end  as hora_semana  "& vbCrLf &_
					"		from (  "& vbCrLf &_
					"			select protic.obtener_rut(pers_ncorr) as rut,pers_ncorr,  "& vbCrLf &_
					"			cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen  "& vbCrLf &_
					"			from (    "& vbCrLf &_
					"				select  a.pers_ncorr,(c.dane_nsesiones/2) as sesiones,c.duas_ccod,   "& vbCrLf &_
					"				b.anex_ncorr,c.dane_msesion as monto_cuota "& vbCrLf &_
					"				  From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "& vbCrLf &_    
					"							 asignaturas j, secciones n,tipos_profesores o,profesores p  "& vbCrLf &_    
					"						  Where a.cdoc_ncorr     =   b.cdoc_ncorr "& vbCrLf &_      
					"							 and b.anex_ncorr    =   c.anex_ncorr  "& vbCrLf &_     
					"							 and a.pers_ncorr    =   d.pers_ncorr  "& vbCrLf &_      
					"							 and b.sede_ccod     =   e.sede_ccod   "& vbCrLf &_     
					"							 and c.asig_ccod     =   j.asig_ccod  "& vbCrLf &_      
					"							 and n.secc_ccod     =   c.secc_ccod  "& vbCrLf &_      
					"							 and o.TPRO_CCOD     =   p.TPRO_CCOD  "& vbCrLf &_      
					"							 and p.pers_ncorr    =   d.pers_ncorr  "& vbCrLf &_     
					"							 --AND b.SEDE_CCOD     =   p.sede_ccod   "& vbCrLf &_     
					"							 and a.ecdo_ccod     <> 3  "& vbCrLf &_
					"							 and b.eane_ccod     <> 3  "& vbCrLf &_
					"							 and a.tpro_ccod=1     "& vbCrLf &_ 
					"							 and a.ano_contrato="&v_anos&"   "& vbCrLf &_
					"							 and n.carr_ccod in (select carr_ccod from carreras where tcar_ccod=1)  "& vbCrLf &_
					"							 and a.pers_ncorr not in (27208)      "& vbCrLf &_
					"				group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,c.duas_ccod "& vbCrLf &_
					"			 ) as aa,  "& vbCrLf &_    
					"			anexos b, duracion_asignatura c     "& vbCrLf &_
					"			where aa.anex_ncorr=b.anex_ncorr  "& vbCrLf &_
					"			and  aa.duas_ccod=c.duas_ccod  "& vbCrLf &_
					"			group by b.anex_ncorr,pers_ncorr,b.anex_nhoras_coordina,monto_cuota,b.anex_ncuotas,duas_tdesc  "& vbCrLf &_
					"		) as t  "& vbCrLf &_
					"		group by rut,regimen,pers_ncorr "& vbCrLf &_
					" ) as aa , personas bb  "& vbCrLf &_
					" where aa.pers_ncorr=bb.pers_ncorr  "& vbCrLf &_
					" --and aa.pers_ncorr not in ( select distinct pers_ncorr from administrativos_docentes where admd_jornada in (1,2) and pers_ncorr not in (12258))  "& vbCrLf &_
					" group by  aa.pers_ncorr,aa.rut,aa.grado,aa.descripcion_grado,  "& vbCrLf &_
					" bb.pers_tnombre, bb.pers_tape_paterno, bb.pers_tape_materno  "& vbCrLf &_
					" ) as ab , contratos_docentes_upa cd, anexos an, carreras c, jornadas j, sedes k "& vbCrLf &_
					" where ab.horas_jornada like '"&jornada&"'  "& vbCrLf &_
					"	and ab.pers_ncorr  = cd.pers_ncorr "& vbCrLf &_
					"	and cd.cdoc_ncorr  = an.cdoc_ncorr       "& vbCrLf &_
					"	and cd.ano_contrato= "&v_anos&" "& vbCrLf &_
					"	and cd.ecdo_ccod     <> 3  "& vbCrLf &_    
					"	and an.eane_ccod     <> 3 "& vbCrLf &_
					"	and an.carr_ccod    =   c.carr_ccod "& vbCrLf &_
					"	and an.jorn_ccod    =   j.jorn_ccod "& vbCrLf &_
					"	and an.sede_ccod    =   k.sede_ccod "& vbCrLf &_
					"	and c.tcar_ccod=1 "& vbCrLf &_
					" group by total,c.carr_tdesc,j.jorn_tdesc,k.sede_tdesc, an.carr_ccod,an.jorn_ccod,an.sede_ccod "         
'response.Write("<pre>"&sql_indicador&"</pre>")
'response.End()
    ObtenerJornadaProfesor_listado=sql_indicador				
end function

Function ObtenerJornadaProfesor_facu(jornada, total)
	sql_indicador=	" select facultad,count(*) as cantidad ,valor_facultad, "& vbCrLf &_   
		  			" total as total_docentes,cast(cast((count(*)*100.00)/total as decimal(8,2)) as varchar)+' %' as indice, "& vbCrLf &_
					" cast(cast((count(*)*100.00)/valor_facultad as decimal(8,2)) as varchar)+' %' as indice_facultad "& vbCrLf &_
					" from ( "& vbCrLf &_
  					" select distinct  i.facu_tdesc as facultad, ab.pers_ncorr,total,   "& vbCrLf &_
					" protic.obtener_docentes_facultad("&v_anos&",i.facu_ccod) as valor_facultad "& vbCrLf &_
					" from (  "& vbCrLf &_
					" select aa.pers_ncorr,aa.rut,"&total&" as total, "& vbCrLf &_
					" bb.pers_tnombre as nombre_docente, bb.pers_tape_paterno+' '+bb.pers_tape_materno as apellido_docente,  "& vbCrLf &_
					" aa.grado,aa.descripcion_grado, sum(hora_semana) as horas_semanales,  "& vbCrLf &_
					" case when sum(hora_semana)>=40 then 'Completa' when sum(hora_semana)<19 then 'Hora' else 'Media' end as horas_jornada  "& vbCrLf &_
					" from  (  "& vbCrLf &_
					"		select pers_ncorr,rut, "& vbCrLf &_
					"		protic.obtener_grado_docente(pers_ncorr,'U') as grado,  "& vbCrLf &_
					"		protic.obtener_grado_docente(pers_ncorr,'D') as descripcion_grado,  "& vbCrLf &_
					"		((sum(horas)*75)/60)/case regimen when 'ANUAL'then 36  "& vbCrLf &_
					"										  when 'SEMESTRAL'then 18  "& vbCrLf &_
					"										  when 'TRIMESTRAL'then 12  "& vbCrLf &_
					"										  when 'PERIODO'then 12 end  as hora_semana  "& vbCrLf &_
					"		from (  "& vbCrLf &_
					"			select protic.obtener_rut(pers_ncorr) as rut,pers_ncorr,  "& vbCrLf &_
					"			cast(sum(sesiones)as numeric)+b.anex_nhoras_coordina as horas,duas_tdesc as regimen  "& vbCrLf &_
					"			from (    "& vbCrLf &_
					"				select  a.pers_ncorr,(c.dane_nsesiones/2) as sesiones,c.duas_ccod,   "& vbCrLf &_
					"				b.anex_ncorr,c.dane_msesion as monto_cuota "& vbCrLf &_
					"				  From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "& vbCrLf &_    
					"							 asignaturas j, secciones n,tipos_profesores o,profesores p  "& vbCrLf &_    
					"						  Where a.cdoc_ncorr     =   b.cdoc_ncorr "& vbCrLf &_      
					"							 and b.anex_ncorr    =   c.anex_ncorr  "& vbCrLf &_     
					"							 and a.pers_ncorr    =   d.pers_ncorr  "& vbCrLf &_      
					"							 and b.sede_ccod     =   e.sede_ccod   "& vbCrLf &_     
					"							 and c.asig_ccod     =   j.asig_ccod  "& vbCrLf &_      
					"							 and n.secc_ccod     =   c.secc_ccod  "& vbCrLf &_      
					"							 and o.TPRO_CCOD     =   p.TPRO_CCOD  "& vbCrLf &_      
					"							 and p.pers_ncorr    =   d.pers_ncorr  "& vbCrLf &_     
					"							-- AND b.SEDE_CCOD     =   p.sede_ccod   "& vbCrLf &_     
					"							 and a.ecdo_ccod     <> 3  "& vbCrLf &_
					"							 and b.eane_ccod     <> 3  "& vbCrLf &_
					"							 and a.tpro_ccod=1     "& vbCrLf &_ 
					"							 and a.ano_contrato="&v_anos&"   "& vbCrLf &_
					"							 and n.carr_ccod in (select carr_ccod from carreras where tcar_ccod=1)  "& vbCrLf &_
					"							 and a.pers_ncorr not in (27208)      "& vbCrLf &_
					"				group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,c.duas_ccod "& vbCrLf &_
					"			 ) as aa,  "& vbCrLf &_    
					"			anexos b, duracion_asignatura c     "& vbCrLf &_
					"			where aa.anex_ncorr=b.anex_ncorr  "& vbCrLf &_
					"			and  aa.duas_ccod=c.duas_ccod  "& vbCrLf &_
					"			group by b.anex_ncorr,pers_ncorr,b.anex_nhoras_coordina,monto_cuota,b.anex_ncuotas,duas_tdesc  "& vbCrLf &_
					"		) as t  "& vbCrLf &_
					"		group by rut,regimen,pers_ncorr "& vbCrLf &_
					" ) as aa , personas bb  "& vbCrLf &_
					" where aa.pers_ncorr=bb.pers_ncorr  "& vbCrLf &_
					" --and aa.pers_ncorr not in ( select distinct pers_ncorr from administrativos_docentes where admd_jornada in (1,2) and pers_ncorr not in (12258))  "& vbCrLf &_
					" group by  aa.pers_ncorr,aa.rut,aa.grado,aa.descripcion_grado,  "& vbCrLf &_
					" bb.pers_tnombre, bb.pers_tape_paterno, bb.pers_tape_materno  "& vbCrLf &_
					" ) as ab , contratos_docentes_upa cd, anexos an, carreras c, jornadas j, sedes k, areas_academicas h, facultades i "& vbCrLf &_
					" where ab.horas_jornada like '"&jornada&"'  "& vbCrLf &_
					"	and ab.pers_ncorr  = cd.pers_ncorr "& vbCrLf &_
					"	and cd.cdoc_ncorr  = an.cdoc_ncorr       "& vbCrLf &_
					"	and cd.ano_contrato= "&v_anos&" "& vbCrLf &_
					"	and cd.ecdo_ccod    <> 3  "& vbCrLf &_    
					"	and an.eane_ccod    <> 3 "& vbCrLf &_
					"	and an.carr_ccod    =   c.carr_ccod "& vbCrLf &_
					"	and an.jorn_ccod    =   j.jorn_ccod "& vbCrLf &_
					"	and an.sede_ccod    =   k.sede_ccod "& vbCrLf &_
					"	and c.area_ccod		=	h.area_ccod "& vbCrLf &_
					"	and h.facu_ccod		=	i.facu_ccod "& vbCrLf &_
					"	and c.tcar_ccod		=	1 "& vbCrLf &_
					" ) as tablita "& vbCrLf &_
		  			" group by total,facultad,valor_facultad "         
'response.Write("<pre>"&sql_indicador&"</pre>")
'response.End()
    ObtenerJornadaProfesor_facu=sql_indicador				
end function


Function ObtenerCategoriaProfesor(categoria)
		sql_indicador=	" select distinct d.jdoc_ccod,e.jdoc_tdesc as jerarquia,a.pers_ncorr "& vbCrLf &_
						" from contratos_docentes_upa a, anexos b, personas c, profesores d, jerarquias_docentes e, carreras h "& vbCrLf &_
						" where ano_contrato="&v_anos&" "& vbCrLf &_
						" and a.cdoc_ncorr=b.cdoc_ncorr "& vbCrLf &_
						" and a.pers_ncorr=c.pers_ncorr "& vbCrLf &_
						" and a.ecdo_ccod not in (3) "& vbCrLf &_
						" and b.eane_ccod    <> 3 "& vbCrLf &_
						" and c.pers_ncorr=d.pers_ncorr "& vbCrLf &_
						" and a.tpro_ccod=1 "& vbCrLf &_
						" and b.carr_ccod=h.carr_ccod "& vbCrLf &_ 
						" and h.tcar_ccod=1 "& vbCrLf &_ 
						" and d.jdoc_ccod=e.jdoc_ccod "& vbCrLf &_
						" and d.jdoc_ccod in ("&categoria&") "

    ObtenerCategoriaProfesor=sql_indicador				
end function

Function ObtenerCategoriaProfesor_listado(categoria, total)
		sql_indicador=	" select sede ,carrera ,jornada,total as total_docentes,valor_escuela, count(*) as cantidad, "& vbCrLf &_
						" cast(cast((count(*)*100.00)/total as decimal(8,2)) as varchar)+' %' as indice, "& vbCrLf &_
						" cast(cast((count(*)*100.00)/valor_escuela as decimal(8,2)) as varchar)+' %' as indice_escuela "& vbCrLf &_
						" from ( "& vbCrLf &_
						" select distinct a.pers_ncorr,"&total&" as total,protic.obtener_docentes_escuela("&v_anos&",b.sede_ccod,b.carr_ccod,b.jorn_ccod) as valor_escuela, "& vbCrLf &_
						" sede_tdesc as sede,carr_tdesc as carrera ,jorn_tdesc as jornada,d.jdoc_ccod,e.jdoc_tdesc as jerarquia "& vbCrLf &_
						" from contratos_docentes_upa a, anexos b, personas c, profesores d, jerarquias_docentes e, "& vbCrLf &_
						" carreras h, jornadas f, sedes g "& vbCrLf &_
						" where ano_contrato="&v_anos&" "& vbCrLf &_
						" and a.cdoc_ncorr=b.cdoc_ncorr "& vbCrLf &_
						" and a.pers_ncorr=c.pers_ncorr "& vbCrLf &_
						" and a.ecdo_ccod not in (3) "& vbCrLf &_
						" and b.eane_ccod    <> 3 "& vbCrLf &_
						" and c.pers_ncorr=d.pers_ncorr "& vbCrLf &_
						" and a.tpro_ccod=1 "& vbCrLf &_
						" and d.jdoc_ccod=e.jdoc_ccod "& vbCrLf &_
						" and b.carr_ccod=h.carr_ccod "& vbCrLf &_
						" and b.jorn_ccod=f.jorn_ccod "& vbCrLf &_
						" and b.sede_ccod=g.sede_ccod "& vbCrLf &_
						" and h.tcar_ccod=1 "& vbCrLf &_ 
						" and d.jdoc_ccod in ("&categoria&") "& vbCrLf &_
						" ) as tabla "& vbCrLf &_
						" group by total,sede,carrera,jornada,valor_escuela "

    ObtenerCategoriaProfesor_listado=sql_indicador				
end function


Function ObtenerCategoriaProfesor_facu(categoria, total)
		sql_indicador=	" select facultad,total as total_docentes,valor_facultad, count(*) as cantidad, "& vbCrLf &_
						" cast(cast((count(*)*100.00)/total as decimal(8,2)) as varchar)+' %' as indice, "& vbCrLf &_
						" cast(cast((count(*)*100.00)/valor_facultad as decimal(8,2)) as varchar)+' %' as indice_facultad "& vbCrLf &_
						" from ( "& vbCrLf &_
						" select distinct a.pers_ncorr,"&total&" as total,protic.obtener_docentes_facultad("&v_anos&",i.facu_ccod) as valor_facultad,  "& vbCrLf &_
						" i.facu_tdesc as facultad,d.jdoc_ccod,e.jdoc_tdesc as jerarquia "& vbCrLf &_
						" from contratos_docentes_upa a, anexos b, personas c, profesores d, jerarquias_docentes e, "& vbCrLf &_
						" carreras h, jornadas f, sedes g, areas_academicas j, facultades i "& vbCrLf &_
						" where ano_contrato="&v_anos&" "& vbCrLf &_
						" and a.cdoc_ncorr=b.cdoc_ncorr "& vbCrLf &_
						" and a.pers_ncorr=c.pers_ncorr "& vbCrLf &_
						" and a.ecdo_ccod not in (3) "& vbCrLf &_
						" and b.eane_ccod    <> 3 "& vbCrLf &_
						" and c.pers_ncorr=d.pers_ncorr "& vbCrLf &_
						" and a.tpro_ccod=1 "& vbCrLf &_
						" and d.jdoc_ccod=e.jdoc_ccod "& vbCrLf &_
						" and b.carr_ccod=h.carr_ccod "& vbCrLf &_
						" and b.jorn_ccod=f.jorn_ccod "& vbCrLf &_
						" and b.sede_ccod=g.sede_ccod "& vbCrLf &_
						" and h.area_ccod=j.area_ccod "& vbCrLf &_
						" and j.facu_ccod=i.facu_ccod "& vbCrLf &_
						" and h.tcar_ccod=1 "& vbCrLf &_ 
						" and d.jdoc_ccod in ("&categoria&") "& vbCrLf &_
						" ) as tabla "& vbCrLf &_
						" group by total,facultad,valor_facultad "

    ObtenerCategoriaProfesor_facu=sql_indicador				
end function


function GradosConsolidados(total)
sql_grados= " select 'UNIVERSIDAD DEL PACIFICO' as universidad, count(doctores) as doctores, count(magister) as magister, count(profesionales) as profesionales, count(tecnicos) as tecnicos,  "& vbCrLf &_
			" cast(cast((count(doctores)*100.00)/total as decimal(8,2)) as varchar)+' %' as indice_doc, cast(cast((count(magister)*100.00)/total as decimal(8,2)) as varchar)+' %' as indice_mag, "& vbCrLf &_
			" cast(cast((count(profesionales)*100.00)/total as decimal(8,2)) as varchar)+' %' as indice_prof, "& vbCrLf &_
			" cast(cast((count(tecnicos)*100.00)/total as decimal(8,2)) as varchar)+' %' as indice_tec, total "& vbCrLf &_
			" from (  "& vbCrLf &_
			"	select "&total&" as total,case when grado in ('DOCTORADO') then 'DOCTOR' end as doctores,  "& vbCrLf &_
			"	case when grado in ('MAGISTER','MAESTRIA') then 'MAGISTER' end as magister, "& vbCrLf &_
			"	case when grado in ('LICENCIADO','PROFESIONAL') then 'PROFESIONAL' end as profesionales, "& vbCrLf &_
			"	case when grado in ('TECNICO') then 'TECNICO' end as tecnicos, "& vbCrLf &_
			"	* from "& vbCrLf &_
			"	 ( "& vbCrLf &_
			"	  select distinct a.pers_ncorr  "& vbCrLf &_
			"	  ,protic.obtener_grado_docente(a.pers_ncorr,'U') as grado    "& vbCrLf &_
			"	  from contratos_docentes_upa a, anexos b, carreras e    "& vbCrLf &_
			"	  where ano_contrato= "&v_anos&"     "& vbCrLf &_
			"	  and a.cdoc_ncorr=b.cdoc_ncorr    "& vbCrLf &_
			"	  and a.ecdo_ccod not in (3)    "& vbCrLf &_
			" 	  and b.eane_ccod    <> 3 "& vbCrLf &_
			"	  and a.tpro_ccod=1    "& vbCrLf &_
			"	  and b.carr_ccod=e.carr_ccod "& vbCrLf &_
			"	  and e.tcar_ccod=1 "& vbCrLf &_
			"	) as tabla "& vbCrLf &_
			" ) as tabla_final group by  total "
			
'response.Write("<pre>"&sql_grados&"</pre>")

GradosConsolidados=sql_grados		

end function

function GradosConsolidadosEscuelas(total)

	sql_grados= " select sede, carrera, jornada,count(doctores) as doctores, count(magister) as magister, "& vbCrLf &_
				" count(profesionales) as profesionales, count(tecnicos) as tecnicos,  "& vbCrLf &_
				" cast(cast((count(doctores)*100.00)/total as decimal(8,2)) as varchar)+' %' as indice_doc,cast(cast((count(magister)*100.00)/total as decimal(8,2)) as varchar)+' %' as indice_mag, "& vbCrLf &_
   			    " cast(cast((count(profesionales)*100.00)/total as decimal(8,2)) as varchar)+' %' as indice_prof, "& vbCrLf &_
				" cast(cast((count(tecnicos)*100.00)/total as decimal(8,2)) as varchar)+' %' as indice_tec "& vbCrLf &_
				" from ( "& vbCrLf &_
				"	select "&total&" as total,case when grado in ('DOCTORADO') then 'DOCTOR' end as doctores, "& vbCrLf &_
				"	case when grado in ('MAGISTER','MAESTRIA') then 'MAGISTER' end as magister, "& vbCrLf &_
				"	case when grado in ('LICENCIADO','PROFESIONAL') then 'PROFESIONAL' end as profesionales, "& vbCrLf &_
				"	case when grado in ('TECNICO') then 'TECNICO' end as tecnicos, "& vbCrLf &_
				"	* from "& vbCrLf &_
				"	 ( "& vbCrLf &_
				"	  select distinct sede_tdesc as sede,carr_tdesc as carrera ,jorn_tdesc as jornada, "& vbCrLf &_
				"	  a.pers_ncorr,protic.obtener_grado_docente(a.pers_ncorr,'U') as grado    "& vbCrLf &_
				"	  from contratos_docentes_upa a, anexos b, "& vbCrLf &_
				"	   carreras h, jornadas f, sedes g    "& vbCrLf &_
				"	  where ano_contrato= "&v_anos&"     "& vbCrLf &_
				"	  and a.cdoc_ncorr=b.cdoc_ncorr    "& vbCrLf &_
				"	  and a.ecdo_ccod not in (3)    "& vbCrLf &_
				" 	  and b.eane_ccod    <> 3 "& vbCrLf &_
				"	  and b.carr_ccod=h.carr_ccod   "& vbCrLf &_
				"	  and b.jorn_ccod=f.jorn_ccod "& vbCrLf &_
				"	  and b.sede_ccod=g.sede_ccod    "& vbCrLf &_
				"	  and a.tpro_ccod=1    "& vbCrLf &_
				"	  and h.tcar_ccod=1 "& vbCrLf &_				
				"	) as tabla "& vbCrLf &_
				" ) as tabla_final "& vbCrLf &_
				" group by sede, carrera, jornada, total "

	GradosConsolidadosEscuelas=sql_grados	
end function

function GradosConsolidadosFacultades(total)

	sql_grados= " select facultad,count(doctores) as doctores, count(magister) as magister, count(profesionales) as profesionales, count(tecnicos) as tecnicos, "& vbCrLf &_
				" cast(cast((count(doctores)*100.00)/total as decimal(8,2)) as varchar)+' %' as indice_doc,cast(cast((count(magister)*100.00)/total as decimal(8,2)) as varchar)+' %' as indice_mag, "& vbCrLf &_
				" cast(cast((count(profesionales)*100.00)/total as decimal(8,2)) as varchar)+' %' as indice_prof, "& vbCrLf &_
				" cast(cast((count(tecnicos)*100.00)/total as decimal(8,2)) as varchar)+' %' as indice_tec "& vbCrLf &_
				" from ( "& vbCrLf &_
				"	select "&total&" as total, case when grado in ('DOCTORADO') then 'DOCTOR' end as doctores, "& vbCrLf &_
				"	case when grado in ('MAGISTER','MAESTRIA') then 'MAGISTER' end as magister, "& vbCrLf &_
				"	case when grado in ('LICENCIADO','PROFESIONAL') then 'PROFESIONAL' end as profesionales, "& vbCrLf &_
				"	case when grado in ('TECNICO') then 'TECNICO' end as tecnicos, "& vbCrLf &_
				"	* from "& vbCrLf &_
				"	 ( "& vbCrLf &_
				"	  select distinct facu_tdesc as facultad, "& vbCrLf &_
				"	  a.pers_ncorr,protic.obtener_grado_docente(a.pers_ncorr,'U') as grado    "& vbCrLf &_
				"	  from contratos_docentes_upa a, anexos b, "& vbCrLf &_
				"	   carreras h, jornadas f, sedes g, areas_academicas j, facultades i    "& vbCrLf &_
				"	  where ano_contrato= "&v_anos&"     "& vbCrLf &_
				"	  and a.cdoc_ncorr=b.cdoc_ncorr "& vbCrLf &_
				"	  and a.ecdo_ccod not in (3)    "& vbCrLf &_
				"     and b.eane_ccod    <> 3 "& vbCrLf &_
				"	  and b.carr_ccod=h.carr_ccod   "& vbCrLf &_
				"	  and b.jorn_ccod=f.jorn_ccod "& vbCrLf &_
				"	  and b.sede_ccod=g.sede_ccod "& vbCrLf &_
				"	  and h.area_ccod=j.area_ccod "& vbCrLf &_
				"	  and j.facu_ccod=i.facu_ccod "& vbCrLf &_   
				"	  and a.tpro_ccod=1 "& vbCrLf &_   
				"	  and h.tcar_ccod=1 "& vbCrLf &_								
				"	) as tabla "& vbCrLf &_
				" ) as tabla_final "& vbCrLf &_
				" group by facultad, total "
	
	GradosConsolidadosFacultades=sql_grados
end function
'response.Write("<pre>"&sql_resumen&"</pre>")		
'response.End()
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
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>

<script language="JavaScript">

function salir(){
location.href="../lanzadera/lanzadera_up.asp?resolucion=1152";
}
function Excel(){
	alert("Funcion no disponible. ");
}
</script>


</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../jefe_carrera/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();" >

<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="72" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
                <td height="60">
<form name="buscador" method="get" action="">
              <br>
			   <table width="98%"  border="0" align="center">
                <tr>
                  <td width="82%"><div align="center">
                    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                          <td width="27%"><strong>Indicadores docencia </strong></td>
                          <td width="2%">:</td>
                          <td width="71%"><div align="left"></div>
                            <%f_busqueda.DibujaCampo("cod_opcion")%></td>
                        </tr>
                       <tr> 
                          <td width="27%"><strong>Años disponibles </strong></td>
                          <td width="2%">:</td>
                          <td width="71%"><div align="left"></div>
                            <%f_busqueda.DibujaCampo("v_anos")%></td>
                        </tr>
                    </table>
                  </div></td>
                  <td width="18%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td>
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
	<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
            <td><br><div align="center"> 
                    <%pagina.DibujarTituloPagina%>
                </div>
              <form name="edicion" method="post" action="">
			     <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>
<%if not Esvacio(Request.QueryString) then%>
<table align="center" width="90%" border="1"><tr><td><img src="<%=img%>"></td></tr></table>	
<%end if%>
<br>				
					
<%
if not Esvacio(Request.QueryString) then
	 if v_cod_opcion>=1 and v_cod_opcion<=4 then 
	 v_indicador=round(((v_cantidad_profes*100)/v_cantidad_docentes),2)
	%>
		<table align="left" class=v1 width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#999999" bgcolor="#ADADAD">
			<tr bgcolor='#C4D7FF' bordercolor='#999999'>
				<th><font color='#333333'>Universidad</font></th>
				<th><font color='#333333'>N&deg; <%=tipo_listado%></font></th>
				<th><font color='#333333'>Total Docentes</font></th>
				<th><font color='#333333'>Indice</font></th>
			</tr>
			<tr bgcolor="#FFFFFF">
				<td class='noclick'align='LEFT' width='' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>UNIVERSIDAD DEL PACIFICO</td>
				<td class='noclick'align='LEFT' width='' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><b><%=v_cantidad_profes%></b></td>
				<td class='noclick'align='LEFT' width='' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><b><%=v_cantidad_docentes%></b></td>
				<td class='noclick'align='LEFT' width='' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><b><%=v_indicador%> %</b></td>
			</tr>
		</table>
<br/>
	<%	end if

	if v_cod_opcion=5 or v_cod_opcion=6 then
		v_indicador=round(cint(v_producto_suma)/cint(v_cantidad_suma),2) 
%>
	<table align="left" class=v1 width="100%"  border="1" cellpadding="0" cellspacing="0" bordercolor="#999999" bgcolor="#ADADAD">
			<tr bgcolor='#C4D7FF' bordercolor='#999999'>
				<th><font color='#333333'>Universidad</font></th>
				<th><font color='#333333'>Total Docentes</font></th>
				<th><font color='#333333'>Promedio</font></th>
			</tr>
		<tr bgcolor="#FFFFFF">
			<td class='noclick'align='LEFT' width='' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>UNIVERSIDAD DEL PACIFICO</td>
			<td class='noclick'align='LEFT' width='' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><b><%=v_cantidad_suma%></b></td>
			<td class='noclick'align='LEFT' width='' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><b><%=v_indicador%></b></td>
		</tr>
	</table>
<br/>
	<%end if
    if v_cod_opcion>=7 and v_cod_opcion<=9 then 
    v_indicador=round(((v_cantidad_profes_jornada*100)/v_cantidad_docentes),2)
	%>
		<table align="left" class=v1 width="100%"  border="1" cellpadding="0" cellspacing="0" bordercolor="#999999" bgcolor="#ADADAD">
			<tr bgcolor='#C4D7FF' bordercolor='#999999'>
				<th><font color='#333333'>Universidad</font></th>
				<th><font color='#333333'>Docentes Jornada <%=jornada%></font></th>
				<th><font color='#333333'>Total Docentes</font></th>
				<th><font color='#333333'>Indice</font></th>
			</tr>
			<tr bgcolor="#FFFFFF">
				<td class='noclick'align='LEFT' width='' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>UNIVERSIDAD DEL PACIFICO</td>
				<td class='noclick'align='LEFT' width='' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><b><%=v_cantidad_profes_jornada%></b></td>
				<td class='noclick'align='LEFT' width='' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><b><%=v_cantidad_docentes%></b></td>
				<td class='noclick'align='LEFT' width='' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><b><%=v_indicador%> %</b></td>
			</tr>
		</table>
<br/>
	<%end if 
	if v_cod_opcion>=10 and v_cod_opcion<=13 then 
 		v_indicador=round((v_cantidad_profes_categoria/v_cantidad_docentes),2)
	%>
	<table align="left" class=v1 width="100%"  border="1" cellpadding="0" cellspacing="0" bordercolor="#999999" bgcolor="#ADADAD">
			<tr bgcolor='#C4D7FF' bordercolor='#999999'>
				<th><font color='#333333'>Universidad</font></th>
				<th><font color='#333333'>N° Docentes  <%=tipo_categoria%></font></th>
				<th><font color='#333333'>Total Docentes</font></th>
				<th><font color='#333333'>Indice</font></th>
			</tr>
			<tr bgcolor="#FFFFFF">
				<td class='noclick'align='LEFT' width='' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>UNIVERSIDAD DEL PACIFICO</td>
				<td class='noclick'align='LEFT' width='' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><b><%=v_cantidad_profes_categoria%></b></td>
				<td class='noclick'align='LEFT' width='' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><b><%=v_cantidad_docentes%></b></td>
				<td class='noclick'align='LEFT' width='' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><b><%=v_indicador%> %</b></td>
			</tr>
		</table>
<br/>
	<%end if 
end if 
if v_cod_opcion=14 then%>

		<%pagina.DibujarSubtitulo "Datos Indicadores Universidad"%><br>
		<% formulario_consolidado.dibujaTabla()%>
		<br>

<% end if %>

						<table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
							<tr>
                                 <td align="center">
								 	<%pagina.DibujarSubtitulo "Datos Indicadores Facultad"%><br>
                                    <%formulario_facu.dibujaTabla()%>
									<br>
                                 </td>
                             </tr>
                              <tr>
                                 <td align="center">
									<br>
								 	<%pagina.DibujarSubtitulo "Datos Indicadores Escuelas"%><br>
                                    <%formulario.dibujaTabla()%>
									<br>
                                 </td>
                             </tr>
						  </table>
                     </td>
                  </tr>
                </table>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="16%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="51%"><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
				  <td width="49%"> <div align="center">  <%f_botonera.dibujaboton "excel"%>
					 </div>
                  </td>
                  </tr>
              </table>
            </div></td>
            <td width="84%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
