<!-- #include file = "../biblioteca/_conexion.asp" -->
<%

 Session.Contents.RemoveAll() 
  
 set conexion = new CConexion
 conexion.Inicializar "upacifico"
 
 session("rut_tyg") = ""	
 response.Redirect("index.asp") 

 %>