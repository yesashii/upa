<!-- #include file = "../biblioteca/de_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
 Session.Contents.RemoveAll()
'-----------------------------------------------------------
 rut = request("datos[0][pers_nrut]")
 dv = request("datos[0][pers_xdv]")

 set conexion = new CConexion
 conexion.Inicializar "upacifico"

c_nuevo= " select case count(*) when 0 then 'N' else 'S' end from personas a, alumnos b, ofertas_academicas c"&_
		 " where cast(a.pers_nrut as varchar)='"&rut&"' "&_
		 " and a.pers_ncorr=b.pers_ncorr and b.emat_ccod = 1 "&_
		 " and b.ofer_ncorr=c.ofer_ncorr and c.peri_ccod=214 and c.post_bnuevo='S'"
		 'response.Write(es_nuevo)
'response.End()
es_nuevo = conexion.consultaUno(c_nuevo)		 

if es_nuevo <> "N" and rut <> "" then
		'############################################################################################
			sql_pers_ncorr = "SELECT pers_ncorr FROM personas WHERE cast(pers_nrut as varchar)='" & RUT & "'"
			v_pers_ncorr =  conexion.ConsultaUno(sql_pers_ncorr)
			
	   		session("rut_usuario") = RUT	
	   		response.Redirect("menu_evalua.asp")
else
	   		session("mensajeerror")= "el rut ingresado no presenta matrícula de alumno nuevo en el sistema"
		    response.Redirect("portada_evalua.asp") 
end if
 
 %>