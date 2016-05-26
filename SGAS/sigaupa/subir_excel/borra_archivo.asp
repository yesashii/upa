<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
archivo= request.QueryString("arch")
filename=server.mappath(".") & "\archivos\"&archivo
Set FSO = Server.CreateObject("Scripting.FileSystemObject")
FSO.DeleteFile(filename)
Set FSO = nothing
session("mensajeerror")= "El nombre de la pestaña no es correcto"
response.Redirect("subir_excel.asp")

%>




