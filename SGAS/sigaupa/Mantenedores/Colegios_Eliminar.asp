<!-- #include file = "../biblioteca/_conexion.asp" -->

<%

'for each k in request.form
	'response.Write(k&" = "&request.Form(k)&"<br>")
'next
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_planes = new CFormulario
f_planes.Carga_Parametros "mantenedor_colegios.xml", "f_colegios"
f_planes.Inicializar conexion
f_planes.ProcesaForm
'f_planes.ListarPost
'response.end
cont = 0
for i = 0 to f_planes.CuentaPost - 1
   cole_ccod = f_planes.ObtenerValorPost (i, "cole_ccod2")
   'f_planes.AgregaCampoFilaPost fila, "cole_ccod",cole_ccod
   'response.Write("<br>fila "&i&" colegio "&cole_ccod)
   if cole_ccod <> "" then
	  cole_tcoduas = conexion.consultaUno("select protic.initcap(cole_tdesc) from colegios where cast(cole_ccod as varchar)='"&cole_ccod&"'")
      sql = "select count(pers_ncorr) "&_ 
            "from personas a "&_
            "where  a.cole_ccod =" & cole_ccod 
	  resultado = conexion.ConsultaUno(sql) 

      sql = "select count(pers_ncorr) "&_ 
            "from personas_postulante a "&_
            "where  a.cole_ccod =" & cole_ccod 
	  resultado2 = conexion.ConsultaUno(sql) 
	  
	  sql = "select count(pers_ncorr_alumno) "&_ 
            "from personas_eventos_upa a "&_
            "where  a.cole_ccod =" & cole_ccod 
	  resultado3 = conexion.ConsultaUno(sql) 

	  if cint(resultado) > 0 or cint(resultado2) > 0 or cint(resultado3) > 0 then
          'f_planes.EliminaFilaPost fila 		 
	      cad = cad &" -"& cole_tcoduas  & "\n  "
		  cont = cont  + 1 
		 'response.Write("<BR>"&cad&" No se puede:" & plan_ccod) 
	 else
	     consulta_eliminacion = "delete from colegios where cast(cole_ccod as varchar)='"&cole_ccod&"'"
		' response.Write(consulta_eliminacion)
		 conexion.ejecutaS (consulta_eliminacion)
	  end if
   'else
     'f_planes.EliminaFilaPost fila 
   end if 
next
if cont > 0 then
  mensage = "Los siguientes Colegios no se eliminaron, porque existen alumnos relacionados..." & "\n" & cad 
  session("mensajeError")= mensage
end if
'f_planes.MantieneTablas true
'conexion.estadotransaccion false  'roolback 
'response.End()
response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
