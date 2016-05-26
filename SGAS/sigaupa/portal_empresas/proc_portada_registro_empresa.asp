<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%


 Session.Contents.RemoveAll()
'-----------------------------------------------------------
 rut ="15964262" 'request("datos[0][pers_nrut]")
 dv ="3" 'request("datos[0][pers_xdv]")
 response.Write(rut)
 response.Write("<br/>"&dv)

 set conexion = new CConexion
 conexion.Inicializar "upacifico"

			session("rut_usuario") = RUT	
			 response.Write("<br/>"&"1")
	   		response.Redirect("registro_empresa.asp")

 
 %>