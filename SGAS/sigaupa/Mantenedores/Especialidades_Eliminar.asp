<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_especialidades = new CFormulario
f_especialidades.Carga_Parametros "Especialidades.xml", "f_especialidades"
f_especialidades.Inicializar conexion
f_especialidades.ProcesaForm
'f_especialidades.ListarPost
cont = 0
for fila = 0 to f_especialidades.CuentaPost - 1
   espe_ccod = f_especialidades.ObtenerValorPost (fila, "espe_ccod")   
   if espe_ccod <> "" then
     sql = "select count(ofer_ncorr) "&_ 
            "from ofertas_academicas a "&_
            "where a.espe_ccod =" & espe_ccod
    resultado = conexion.ConsultaUno(sql)  
    if cint(resultado) > 0 then
          f_especialidades.EliminaFilaPost fila 		 
	      cont = cont  + 1 		 
	end if
   else
     f_especialidades.EliminaFilaPost fila 
   end if 
next
if cont > 0 then
  mensage = "No se pueden eliminar algunas especialidades, \nporque existen ofertas académicas relacionadas..."  
  session("mensajeError")= mensage
end if
f_especialidades.MantieneTablas false
'conexion.estadotransaccion false  'roolback 

response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
