<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new cnegocio
negocio.inicializa conexion
'response.End()
'conexion.estadotransaccion false
pers_ncorr = request.Form("profesor[0][pers_ncorr]")
sede_ccod = request.Form("profesor[0][sede_ccod]")
tpro_ccod = request.Form("profesor[0][tpro_ccod]")

if esVacio(sede_ccod) then
sede_ccod = request.Form("sede")
end if

'response.End()
bloque = request.Form("profesor[0][bloq_ccod]")

if esVacio(bloque) then
	bloque=request.Form("bloque")
end if
cupo_seccion = conexion.consultaUno("select cast(isnull(secc_ncupo,0) as varchar) from secciones a, bloques_horarios b where a.secc_ccod=b.secc_ccod and cast(bloq_ccod as varchar)='"&bloque&"'")
v_seccion=conexion.consultaUno("select top 1 a.secc_ccod from secciones a, bloques_horarios b where a.secc_ccod=b.secc_ccod and cast(bloq_ccod as varchar)='"&bloque&"'")
if cupo_seccion <> "0" and not esVacio(cupo_seccion) then
'No se puede agregar un docente pues la sección se encuentra sin cupos disponibles
if tpro_ccod = 1 then
                ' se cancelo el for que asignaba docente a todos los blosque s horarios de la asignatura para que se puedan asignar más de un docente.
				'set f_tabla  = new CFormulario
				'f_tabla.Carga_Parametros "paulo.xml","tabla"
				'f_tabla.Inicializar conexion
				
				'seccion = conexion.consultauno("select secc_ccod from bloques_horarios where cast(bloq_ccod as varchar) ='"&request.Form("profesor[0][bloq_ccod]")&"'")
				
				'sql ="select bloq_ccod from bloques_horarios where  cast(secc_ccod as varchar) ='"&seccion&"'"
				'f_tabla.consultar sql
				'filas = f_tabla.nrofilas
				'response.Write("<hr>"&sql&"<hr>")
				'for i=0 to filas-1
					'f_tabla.siguiente
					'bloque = request.Form("profesor[0][bloq_ccod]") 'f_tabla.obtenervalor("bloq_ccod")
					consulta = " select count(*) from bloques_profesores "&_
           					   " where tpro_ccod=1 and ebpr_ccod=2 and cast(bloq_ccod as varchar)='"&bloque&"'" &_
		   			           " and not exists(select 1 from bloques_profesores bl where cast(bloq_ccod as varchar)='"&bloque&"' and tpro_ccod=1 and isnull(bl.ebpr_ccod,1)=1)"
					'response.Write(consulta&"<br>")
					busca_prof_eliminado = conexion.consultaUno(consulta)
					seccion = conexion.consultaUno("select secc_ccod from bloques_horarios where cast(bloq_ccod as varchar)='"&bloque&"'")
					horas_asignatura = conexion.consultauno("Select case moda_ccod when 2 then isnull(secc_nhoras_pagar,asig_nhoras) else asig_nhoras end from secciones a, asignaturas b where a.asig_ccod=b.asig_ccod and cast(secc_ccod as varchar)='"&seccion&"'")
					if busca_prof_eliminado <> "0" then
					    'response.Write("entre a cantidad_eliminados <br>")
						c_cantidad_docentes = "select distinct b.pers_ncorr from bloques_horarios a, bloques_profesores b where a.bloq_ccod=b.bloq_ccod and cast(a.secc_ccod as varchar)='"&seccion&"' and b.tpro_ccod=1"
						cantidad_docentes = conexion.consultaUno("select count(*) from ("&c_cantidad_docentes&")a")		
						memo = conexion.consultaUno("select hopr_tresolucion from horas_profesores where cast(secc_ccod as varchar)='"&seccion&"' and cast(pers_ncorr as varchar)='"&profe_eliminado&"'")
'response.Write("<br>Memo: "&memo)
						if cantidad_docentes = "1" then
						    'response.Write("ahora para ver si solo es un docente<br>")
							profe_eliminado= conexion.consultaUno(c_cantidad_docentes)
							horas_Asignadas = conexion.consultaUno("select count(*) from horas_profesores where cast(secc_ccod as varchar)='"&seccion&"' and cast(pers_ncorr as varchar)='"&profe_eliminado&"'")
						    if horas_asignadas > "0" then
							    'response.Write("ahora para ver si esta en la tabla horas_profesores <br>")
								horas_Asignadas = conexion.consultaUno("select hopr_nhoras from horas_profesores where cast(secc_ccod as varchar)='"&seccion&"' and cast(pers_ncorr as varchar)='"&profe_eliminado&"'")
    						    horas_para_el_docente = cint(horas_asignatura) - cint(horas_asignadas)
							end if
						else
						    'response.Write("si son mas de un profesor <br>")
						    horas_Asignadas = conexion.consultaUno("select sum(hopr_nhoras) from horas_profesores where cast(secc_ccod as varchar)='"&seccion&"'")	
							horas_para_el_docente = cint(horas_asignatura) - cint(horas_asignadas) 
						end if
						'--------------------debemos agregar un registro a la tabla horas_profesores para este nuevo profesor con la cantidad de horas que le corresponde
						'response.Write("horas_asignatura "&horas_asignatura&" horas_profesor "&horas_asignadas)
						'debemos declarar una variable que sirva para indicar que un docente es el reemplazante de otro
						
						no_existe_hora_compartida=conexion.consultaUno("select count(*) from horas_profesores where secc_ccod="&seccion&" and pers_ncorr="&pers_ncorr&" ")
						v_tipo_bloque=conexion.consultaUno("select top 1 isnull(bloq_ayudantia,0) from bloques_horarios where cast(bloq_ccod as varchar) = '"&bloque&"'")
						if no_existe_hora_compartida =0 then
						' para las secciones que tienen mas de un bloque se duplica el registro en horas compartidas
						' por lo tanto se debe validar que se agregue solo una vez el registro.
							consulta_insercion_docente =" insert into horas_profesores (secc_ccod,pers_ncorr,hopr_nhoras,audi_tusuario,audi_fmodificacion,hopr_tresolucion,bloq_ayudantia)"&_
														" values ("&seccion&","&pers_ncorr&","&horas_para_el_docente&",'Asignado al cargar docente',getDate(),'"&memo&"',"&v_tipo_bloque&") "      
						end if
					end if
					
				
					if esVacio(bloque) then
						bloque=request.Form("bloque")
					end if
					
					sql_bloq_prof=" select count(*) from " & _
								  " bloques_profesores where cast(pers_ncorr as varchar) = '"&pers_ncorr&"' " & _
								  " and cast(bloq_ccod as varchar) = '"&bloque&"' "
								  
					ver_bloque = cInt(conexion.consultauno(sql_bloq_prof))			  
					
					if ver_bloque =0 then
						
						sentencia = "insert into bloques_profesores " & _
									"(BLOQ_CCOD, PERS_NCORR, SEDE_CCOD, TPRO_CCOD, TPAG_CCOD, BPRO_MVALOR, AUDI_TUSUARIO, AUDI_FMODIFICACION)" & _
									"values('"&bloque&"','"&pers_ncorr&"','"&sede_ccod&"','"&tpro_ccod&"',null," & _
									" null,'"&negocio.obtenerusuario&"',getdate())"

'response.Write("<br>consulta update 1 : "& sentencia&"<br>")
'response.Write("<br>Transacc-->: "&conexion.obtenerEstadoTransaccion)
if bloque<> "17002" and bloque <> "17003" and bloque <> "17004" and bloque <> "17005"then
								
						sql_topones ="select protic.TOPONES_DOCENTE('"&bloque&"','"&pers_ncorr&"')"			
						topones = cInt(conexion.consultauno(sql_topones))
						'response.Write("Topones : "& sql_topones&"<br>")
						'response.End()
end if	
						if topones > 0 then
							conexion.estadoTransaccion false
							detalle_topon=conexion.consultaUno("select protic.DETALLE_TOPONES_DOCENTE('"&bloque&"','"&pers_ncorr&"')")
							session("mensajeError") = "Error\nNo se puede asignar profesor por coincidencia de horario con \n "&detalle_topon
						else
							conexion.ejecutaS sentencia		
							'response.Write(sentencia)
							if consulta_insercion_docente <> "" then
								conexion.ejecutaS consulta_insercion_docente
								'response.Write(consulta_insercion_docente)
'response.Write("<br>consulta insercion 1 : "& consulta_insercion_docente&"<br>")
'response.Write("<br>Transacc-->: "&conexion.obtenerEstadoTransaccion)								
							end if
							
						end if 
					end if
					
				'next
  else			
 '       response.Write("entre al else")	
		set f_profesor = new CFormulario
		f_profesor.Carga_Parametros "edicion_plan_acad.xml", "agregar_profesor"
		f_profesor.Inicializar conexion
		f_profesor.ProcesaForm
		for i=0 to f_profesor.cuentaPost - 1
	         pers_ncorr = f_profesor.obtenerValorPost(i,"pers_ncorr")
		     tpro_ccod = f_profesor.obtenerValorPost(i,"tpro_ccod")
	         horas_ayudante = f_profesor.obtenerValorPost(i,"blpr_nhoras_ayudante")
			 nivel_ayudante = f_profesor.obtenerValorPost(i,"niay_ccod")
			 if esVacio(horas_ayudante) then
			 	horas_ayudante=0
			 end if
			 sede = request.Form("sede")
	         if not EsVacio(bloque) and not EsVacio(tpro_ccod) and not EsVacio(pers_ncorr) then
		         consulta_update = "insert into bloques_profesores " & _
									"(BLOQ_CCOD, PERS_NCORR, SEDE_CCOD, TPRO_CCOD, TPAG_CCOD, BPRO_MVALOR, AUDI_TUSUARIO, AUDI_FMODIFICACION,BLPR_NHORAS_AYUDANTE,NIAY_CCOD)" & _
									"values('"&bloque&"','"&pers_ncorr&"','"&sede&"','"&tpro_ccod&"',null," & _
									" null,'"&negocio.obtenerusuario&"',getdate(),"&horas_ayudante&","&nivel_ayudante&")"

'response.Write("<br>consulta update 2 : "& consulta_update&"<br>")
'response.Write("<br>Transacc-->: "&conexion.obtenerEstadoTransaccion)
				        sql_topones ="select protic.TOPONES_DOCENTE('"&bloque&"','"&pers_ncorr&"')"			
						topones = cInt(conexion.consultauno(sql_topones))
						'response.Write("Topones : "& sql_topones&"<br>")
						if topones > 0 and horas_ayudante > 0 then
							conexion.estadoTransaccion false
							detalle_topon=conexion.consultaUno("select protic.DETALLE_TOPONES_DOCENTE('"&bloque&"','"&pers_ncorr&"')")
							session("mensajeError") = "Error\nNo se puede asignar ayudante por coincidencia de horario con \n "&detalle_topon
						elseif topones = 0  and horas_ayudante = 0 then
							conexion.estadoTransaccion false
							session("mensajeError") = "Error\nNo se puede asignar ayudante por no traer valor de horas "
						else
							conexion.ejecutaS consulta_update		
							response.Write("Sentencia : <pre>"&consulta_update&"</pre><br>")	
'response.Write("<br>Transacc-->: "&conexion.obtenerEstadoTransaccion)
						end if 						  
	         end if 
       next 
 end if '''''''''''''''''''' fin del if de tipo_profesor
'response.End()  
else
session("mensajeError") = "Error\nNo se puede asignar profesor por falta de cupos en la sección"
end if'---------------fin de cupo = 0, para la sección 
'response.Write("<br>Transacc-->: "&conexion.obtenerEstadoTransaccion)
'conexion.estadoTransaccion false
'response.End()
sql_bloques_vacios="SELECT (SELECT COUNT (*) FROM BLOQUES_HORARIOS AA WHERE AA.SECC_CCOD=A.SECC_CCOD)- "& _
						" (SELECT COUNT (*) FROM BLOQUES_HORARIOS AA, BLOQUES_PROFESORES BB "& _
						"  WHERE AA.SECC_CCOD=A.SECC_CCOD AND AA.BLOQ_CCOD=BB.BLOQ_CCOD and niay_ccod is null) AS VACIOS "& _
						" FROM SECCIONES A "& _
						" WHERE SECC_CCOD="&v_seccion&" "
						
'response.Write("<pre>"&sql_bloques_vacios&"</pre>")		
				
v_bloques_vacios=conexion.ConsultaUno(sql_bloques_vacios)
if v_bloques_vacios="0" then
	sql_update_seccion="Update secciones set seccion_completa='S' where secc_ccod="&v_seccion&" "
else
	sql_update_seccion="Update secciones set seccion_completa='N' where secc_ccod="&v_seccion&" "
end if

conexion.ejecutaS(sql_update_seccion)	
'response.Write("<br><pre>"&sql_update_seccion&"</pre>")		
'response.End()
%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>
