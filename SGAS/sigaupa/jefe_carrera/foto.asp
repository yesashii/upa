 <!-- #include file="../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"
rut = request.querystring("rut_alumno")
'response.End()

MaxSize = 700000
Response.Expires = 0
Response.Buffer = TRUE
Response.Clear
Response.ContentType = "image/pjpeg"

rut = request.querystring("rut_alumno")

conn = conexion.ObtenerCon
set rs2 = createobject("ADODB.Recordset")
rs2.open("select foto from fotosalumnos where rut = '" & rut & "'"), conn		 
Response.BinaryWrite rs2("foto").getChunk(MaxSize)

%>