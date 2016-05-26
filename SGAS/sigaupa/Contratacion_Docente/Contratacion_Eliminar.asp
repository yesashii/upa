<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_planes = new CFormulario
f_planes.Carga_Parametros "Contratacion_docentes.xml", "habilitacion"

f_planes.Inicializar conexion
f_planes.ProcesaForm
f_planes.ListarPost
  
'response.end


cont = 0
for fila = 0 to f_planes.CuentaPost - 1
   pers_ncorr = f_planes.ObtenerValorPost (fila, "pers_ncorr")
   carr_ncorr = f_planes.ObtenerValorPost (fila, "carr_ncorr")   
  pers_tcoduas = f_planes.ObtenerValorPost (fila, "pers_tcoduas")
   if cole_ccod <> "" then
'   response.write(cole_ccod)
      sql = "select count(pers_ncorr) "&_ 
            "from personas a "&_
            "where  a.cole_ccod =" & cole_ccod 
	  resultado = conexion.ConsultaUno(sql) 
'
'      sql = "select count(pers_ncorr) "&_ 
'            "from personas_postulante a "&_
'            "where  a.cole_ccod =" & cole_ccod 
'	  resultado2 = conexion.ConsultaUno(sql) 

	  if cint(resultado) > 0 then
          f_planes.EliminaFilaPost fila 		 
	      cad = cad & cole_tcoduas  & "  "
		  cont = cont  + 1 
		 ' response.Write("<BR>"&resultado&" No se puede:" & plan_ccod) 
	  end if
   else
     f_planes.EliminaFilaPost fila 
   end if 
next
if cont > 0 then
  mensage = "Los siguientes Docentes no se eliminaron, porque existen Habilitaciones relacionados..." & "\n" & cad 
  session("mensajeError")= mensage
end if
f_planes.MantieneTablas false
'conexion.estadotransaccion false  'roolback 

response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
