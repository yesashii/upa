<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"


set negocio = new CNegocio
negocio.Inicializa conexion

post_ncorr = session("post_ncorr")

if 	not EsVacio(post_ncorr) then
	pers_ncorr = conexion.ConsultaUno("Select pers_ncorr from postulantes where post_ncorr=" & post_ncorr)
	' se buscan las postulacion a segundas carreras que se encuentren en proceso
	sql_post_ncorr = "select max(post_ncorr) from postulantes " & vbcrlf & _
    			 " where cast(pers_ncorr as varchar)='" & pers_ncorr & "' " & vbcrlf & _
    			 " and tpos_ccod=2 " & vbcrlf & _
    			 " and epos_ccod=1 "
	post_ncorr_aux = conexion.ConsultaUno(sql_post_ncorr)
	if 	not EsVacio(post_ncorr_aux) then
		session("post_ncorr")=post_ncorr_aux
		response.Redirect("postulacion_diplo_1.asp")
	end if
end if	


%>
<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript" >
var preguntamsgs=confirm('Su(s) postulacion(es) ha(n) sido enviada.\n ¿Desea crear una nueva postulación?');
if (preguntamsgs==true)// para crear nuevas postulaciones
{window.location.href='proc_index_matricula_diplo_otra.asp';}
if (preguntamsgs==false)// se muestra la ultima postulacion enviada
{window.location.href='post_cerrada.asp';}

//CerrarActualizar();
</script>