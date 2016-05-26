<!--construido 02/06/2015 V1.0 -->
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next

post_ncorr 	= request.Form("post_ncorr")
POST_BNUEVO 	= request.Form("POST_BNUEVO")


'---------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set formulario = new CFormulario
formulario.Carga_Parametros "cambio_oferta_academica2.xml", "f_tabla"
formulario.ProcesaForm

for fila=0 to formulario.CuentaPost -1
ofer_ncorr=formulario.ObtenerValorPost(fila,"ofer_ncorr")

if ofer_ncorr <> "" then 

consulta_oferta=conectar.ConsultaUno("SELECT POST_BNUEVO FROM OFERTAS_ACADEMICAS WHERE OFER_NCORR = "&ofer_ncorr)

sql_postulante="update postulantes set POST_BNUEVO = '"&consulta_oferta&"',ofer_ncorr = "&ofer_ncorr&" where  post_ncorr = "&post_ncorr&""

consulta_oferta=conectar.ConsultaUno("SELECT POST_BNUEVO FROM OFERTAS_ACADEMICAS WHERE OFER_NCORR = "&ofer_ncorr)

sql_detalle_postulante="update detalle_postulantes set ofer_ncorr = "&ofer_ncorr&" where  post_ncorr = "&post_ncorr&""

conectar.EstadoTransaccion conectar.EjecutaS(sql_postulante)
conectar.EstadoTransaccion conectar.EjecutaS(sql_detalle_postulante)

end if

next

%>

<script language = "javascript" src = "../biblioteca/funciones.js" ></script>
<script languaje= "javascript">
CerrarActualizar();
</script>


