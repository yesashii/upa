<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new cnegocio
negocio.inicializa conexion
'response.End()
'conexion.estadotransaccion false
pers_ncorr = request.Form("profesor[0][pers_ncorr]")
sede_ccod = request.Form("profesor[0][sede_ccod]")
tpro_ccod = request.Form("profesor[0][tpro_ccod]")

'for each k in request.Form()
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
bloque = request.Form("profesor[0][bloq_ccod]")
cupo_seccion = conexion.consultaUno("select secc_ncupo from secciones a, bloques_horarios b where a.secc_ccod=b.secc_ccod and cast(bloq_ccod as varchar)='"&bloque&"'")
if cupo_seccion <> "0" then
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
					bloque = request.Form("profesor[0][bloq_ccod]") 'f_tabla.obtenervalor("bloq_ccod")
					
					sql_bloq_prof=" select count(*) from " & _
								  " bloques_profesores where cast(pers_ncorr as varchar) = '"&pers_ncorr&"' " & _
								  " and cast(bloq_ccod as varchar) = '"&bloque&"' "
								  
					ver_bloque = cInt(conexion.consultauno(sql_bloq_prof))			  
					
					if ver_bloque =0 then
						sentencia = "insert into bloques_profesores " & _
									"(BLOQ_CCOD, PERS_NCORR, SEDE_CCOD, TPRO_CCOD, TPAG_CCOD, BPRO_MVALOR, AUDI_TUSUARIO, AUDI_FMODIFICACION)" & _
									"values('"&bloque&"','"&pers_ncorr&"','"&sede_ccod&"','"&tpro_ccod&"',null," & _
									" null,'"&negocio.obtenerusuario&"',getdate())"
									
						sql_topones ="select protic.TOPONES_DOCENTE('"&bloque&"','"&pers_ncorr&"')"			
						topones = cInt(conexion.consultauno(sql_topones))
						'response.Write("Topones : "& sql_topones&"<br>")
						if topones>0 then
							conexion.estadoTransaccion false
							detalle_topon=conexion.consultaUno("select protic.DETALLE_TOPONES_DOCENTE('"&bloque&"','"&pers_ncorr&"')")
							session("mensajeError") = "Error\nNo se puede asignar profesor por coincidencia de horario con \n "&detalle_topon
						else
							conexion.ejecutaS sentencia		
							'response.Write("Sentencia : "&sentencia&"<br>")	
						end if 
					end if
					
				'next
  else			
 '       response.Write("entre al else")	
		set f_profesor = new CFormulario
		f_profesor.Carga_Parametros "edicion_plan_acad.xml", "agregar_profesor"
		f_profesor.Inicializar conexion
		f_profesor.ProcesaForm
		f_profesor.MantieneTablas false
  end if
  
else
session("mensajeError") = "Error\nNo se puede asignar profesor por falta de  cupos en la sección"
end if


'response.End()
'-----------------------------------------------------------------------
'url = "edicion_plan_acad.asp?bloq_ccod=" & f_profesor.ObtenerValorPost(0, "bloq_ccod")
'response.Write(url)
%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>
