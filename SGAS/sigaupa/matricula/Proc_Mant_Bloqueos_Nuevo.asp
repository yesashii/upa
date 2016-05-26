<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
  pers_ncorr = Request.QueryString("pers_ncorr")
  set conexion = new CConexion
  conexion.Inicializar "upacifico"
  
  set negocio = new CNegocio
  negocio.Inicializa conexion
  
'-----------------------------------------------------------------------
  Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
  sede_usuario=negocio.ObtenerSede()
'-----------------------------------------------------------------------
  
  'set f1 = new CFormulario
  'f1.Carga_Parametros "Mant_Bloqueos.xml", "f_nuevo"
  'f1.Inicializar conexion
  'f1.Consultar "select bloq_ncorr_seq.nextval as bloq_ncorr from dual"
  'f1.Siguiente
  'bloq_ncorr = f1.obtenervalor("bloq_ncorr")

bloq_ncorr= conexion.ConsultaUno("execute obtenersecuencia 'bloqueos'")
'----------------------------------------------------------------------  

  cadena = "select sede_ccod from postulantes a, ofertas_academicas b  "&_     
           "where pers_ncorr =" & pers_ncorr & " "&_   
           "  and a.ofer_ncorr = b.ofer_ncorr "&_ 
           "  and a.peri_ccod ='" & Periodo & "'"
' response.Write("<hr>"&cadena&"<hr>"  )   
  sede_ccod = conexion.consultauno(cadena)

if sede_ccod="" or EsVacio(sede_ccod) then
	sede_ccod=sede_usuario
end if

  sql ="select protic.codigo_alumno("& pers_ncorr & "," & Periodo & ") as n_matricula "
  n_matricula = conexion.consultauno(sql)

  set formulario = new CFormulario
  formulario.Carga_Parametros "Mant_Bloqueos.xml", "f_nuevo"
  formulario.Inicializar conexion
  formulario.ProcesaForm

  formulario.agregacampopost "bloq_ncorr" , bloq_ncorr
  formulario.agregacampopost "pers_ncorr" , pers_ncorr
  formulario.agregacampopost "sede_ccod" , sede_ccod
  formulario.agregacampopost "eblo_ccod" , 1
  formulario.agregacampopost "bloq_fbloqueo" , date
  formulario.agregacampopost "alum_nmatricula" , n_matricula
  formulario.agregacampopost "peri_ccod" , Periodo

  formulario.MantieneTablas false
  	'conexion.estadotransaccion false  'roolback 
	'response.End()
 
%>

<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
CerrarActualizar();
</script>
