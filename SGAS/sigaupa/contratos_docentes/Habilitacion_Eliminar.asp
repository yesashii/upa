<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%

'for each x in request.Form
'	response.write("<br>"&x&"->"&request.Form(x))
'next
'response.end()


v_sede_ccod = request.querystring("sede_ccod")
v_jorn_ccod = request.querystring("jorn_ccod")
v_carr_ccod = request.querystring("carr_ccod")

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

peri_ccod = negocio.obtenerPeriodoAcademico("PLANIFICACION")

set f_planes = new CFormulario
f_planes.Carga_Parametros "habilitacion_docentes.xml", "f_habilitacion"

f_planes.Inicializar conexion
f_planes.ProcesaForm

for fila = 0 to f_planes.CuentaPost - 1
   	v_pers_ncorr = f_planes.ObtenerValorPost (fila, "pers_ncorr")
   	carr_ncorr = f_planes.ObtenerValorPost (fila, "carr_ncorr")   

   	if v_pers_ncorr <> "" then
		sql_bloques= "select count(*) as cantidad "&_
					" from bloques_profesores a, bloques_horarios b, secciones c, periodos_academicos d, periodos_academicos e "&_
					" where a.bloq_ccod=b.bloq_ccod "&_
					" and b.secc_ccod=c.secc_ccod "&_
					" and a.pers_ncorr="&v_pers_ncorr&" "&_
					" and c.peri_ccod=d.peri_ccod "&_
					" and d.anos_ccod=e.anos_ccod "&_
					" and e.peri_ccod="&peri_ccod&" "&_
					" and c.carr_ccod="&v_carr_ccod&" "&_
					" and c.jorn_ccod="&v_jorn_ccod&" "
	
		v_existe_bloque=conexion.ConsultaUno(sql_bloques)

		set f_periodos = new CFormulario
		f_periodos.Carga_Parametros "tabla_vacia.xml", "tabla"
		f_periodos.Inicializar conexion
		
		sql_periodos= "select b.peri_ccod "&_
						"from periodos_academicos a, periodos_academicos b "&_
						"where a.anos_ccod=b.anos_ccod "&_
						"and a.peri_ccod="& peri_ccod &" order by b.peri_ccod desc "
		
		f_periodos.Consultar sql_periodos
		
		cantidad=f_periodos.nroFilas
		if cantidad >0  then
			while f_periodos.siguiente
					
				v_periodo=f_periodos.ObtenerValor("peri_ccod")
				'response.Write("<li>aa")
				if cint(v_periodo) <> "" and v_existe_bloque=0 then
					'elimina un registro por cada periodo académico que ha sido creado, excluyendo al periodo actual
					sql_delete=	" delete from CARRERAS_DOCENTE  where peri_ccod="&v_periodo&" and sede_ccod="&v_sede_ccod&" and pers_ncorr="&v_pers_ncorr&" and carr_ccod='"&v_carr_ccod& "' and jorn_ccod="&v_jorn_ccod& " "
					'response.Write("<br>"&sql_delete)
					conexion.ejecutas (sql_delete)		
				else
					mensaje= "No fue posible eliminar la habilitacion, ya que el docente presenta bloques asociados"
					session("mensajeError")= mensaje
					conexion.estadotransaccion false
				end if
			wend	
		end if
		
		'conexion.estadotransaccion false
		'response.End()
		response.Redirect(Request.ServerVariables("HTTP_REFERER"))
	end if
next

'response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
