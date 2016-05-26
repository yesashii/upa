<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_planes = new CFormulario
f_planes.Carga_Parametros "Planes.xml", "f_planes"
f_planes.Inicializar conexion
f_planes.ProcesaForm
'f_planes.ListarPost
cont = 0
for fila = 0 to f_planes.CuentaPost - 1
   plan_ccod = f_planes.ObtenerValorPost (fila, "plan_ccod")
   plan_tcoduas = f_planes.ObtenerValorPost (fila, "c_plan_tcoduas")
   if plan_ccod <> "" then
      sql = "select count(matr_ncorr) "&_ 
            "from alumnos a "&_
            "where a.emat_ccod <> 9 "&_
            "  and a.plan_ccod =" & plan_ccod
	  resultado = conexion.ConsultaUno(sql) 
	  if cint(resultado) > 0 then
          f_planes.EliminaFilaPost fila 		 
	      cad = cad & plan_tcoduas  & "  "
		  cont = cont  + 1 
		 ' response.Write("<BR>"&resultado&" No se puede:" & plan_ccod) 
	  end if
   else
     f_planes.EliminaFilaPost fila 
   end if 
next
if cont > 0 then
  mensage = "Los siguientes Planes no se eliminaron, porque existen alumnos relacionados..." & "\n" & cad 
  session("mensajeError")= mensage
end if
f_planes.MantieneTablas false
'conexion.estadotransaccion false  'roolback 

response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
