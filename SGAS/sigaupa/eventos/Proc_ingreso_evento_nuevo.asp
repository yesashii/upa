<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each x in request.Form
'	response.Write("<br>"&x&" -> "&request.Form(x))
'next

  set conexion = new CConexion
  conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()

v_colegio=request.Form("envio[0][cole_ccod]")
v_otro_colegio=request.Form("envio[0][otro_tdesc]")
v_ciud_ccod=request.Form("envio[0][ciud_ccod_colegio]")
v_perfil=request.Form("perfil")

if v_ciud_ccod="" then
	v_ciud_ccod=0
end if

if isnull(v_colegio) or v_colegio="" then

	if v_otro_colegio<>"" then
		
		v_usuario=v_usuario&" - CREA COLEGIO"

		' obtener una secuencia para insertar un nuevo colegio:
		  	v_cole_ccod= conexion.ConsultaUno("execute obtenersecuencia 'COLE_CCOD'")
			sql_inserta ="insert into colegios (cole_ccod, ciud_ccod,tcol_ccod,cole_tdesc, audi_tusuario, audi_fmodificacion)  "& vbCrLf &_
			" values("&v_cole_ccod&","&v_ciud_ccod&",0,'"&v_otro_colegio&"','"&v_usuario&"', getdate()) "
		'response.Write(sql_inserta)
		'response.End()
		conexion.EstadoTransaccion conexion.EjecutaS(sql_inserta) 	
		v_crear_colegio=true
	end if
end if


'----------------------------------------------------------------------
  v_even_ncorr = conexion.ConsultaUno("execute obtenersecuencia 'eventos'")  
'----------------------------------------------------------------------  
  set formulario = new CFormulario
  formulario.Carga_Parametros "eventos_upa.xml", "f_nuevo"
  formulario.Inicializar conexion
  formulario.ProcesaForm
  
  if v_crear_colegio=true then
    formulario.agregacampopost "cole_ccod" , v_cole_ccod
  end if
  formulario.agregacampopost "even_ncorr" , v_even_ncorr
  formulario.agregacampopost "pcol_ccod" , v_perfil
  formulario.MantieneTablas false
'response.End()

%>

<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
  opener.location.href = "ingreso_evento.asp?busqueda[0][even_ncorr]=<%=v_even_ncorr%>";
  close(); 
</script>
