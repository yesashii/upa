<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

rut = request.Form("rut")
condicion = request.Form("condicion")
dv = conexion.consultauno("SELECT pers_xdv FROM personas WHERE cast(pers_nrut as varchar) = '" & rut & "'")
nombre = conexion.consultauno("SELECT pers_tape_paterno + ' ' + pers_tape_materno + ', ' + pers_tnombre FROM personas WHERE cast(pers_nrut as varchar) = '" & rut & "'")
usuario = negocio.obtenerUsuario
response.Write(rut)
response.Write(dv)
response.Write(nombre)
response.Write(condicion)
response.Write(usuario)
c_insert = " insert into causal_eliminacion (rut,dv,alumno,sexo,audi_tusuario,audi_fmodificacion)"&_
           " values ("&rut&",'"&dv&"','"&nombre&"','"&condicion&"','"&usuario&"',getDate())"

conexion.ejecutaS c_insert

%>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
 CerrarActualizar();
</script>