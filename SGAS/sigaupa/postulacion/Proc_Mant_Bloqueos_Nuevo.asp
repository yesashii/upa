<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
  pers_ncorr = Request.QueryString("pers_ncorr")
  set conexion = new CConexion
  conexion.Inicializar "desauas"
  
  set negocio = new CNegocio
  negocio.Inicializa conexion
  
'-----------------------------------------------------------------------
  Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'-----------------------------------------------------------------------
  
  set f1 = new CFormulario
  f1.Carga_Parametros "Mant_Bloqueos.xml", "f_nuevo"
  f1.Inicializar conexion
  f1.Consultar "select bloq_ncorr_seq.nextval as bloq_ncorr from dual"
  f1.Siguiente
  bloq_ncorr = f1.obtenervalor("bloq_ncorr")
'----------------------------------------------------------------------  

  cadena = "select sede_ccod from postulantes a, ofertas_academicas b  "&_     
           "where pers_ncorr =" & pers_ncorr & " "&_   
           "  and a.ofer_ncorr = b.ofer_ncorr "&_ 
           "  and a.peri_ccod ='" & Periodo & "'"
  
  sede_ccod = conexion.consultauno(cadena)
  
  sql ="select codigo_alumno("& pers_ncorr & "," & Periodo & ") as n_matricula from dual"
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
 
%>

<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
CerrarActualizar();
</script>
