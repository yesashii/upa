<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
on error resume next
set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

for each k in request.form
	response.write(k&"="&request.Form(k)&"<br>")
next
usuario = negocio.obtenerUsuario

maot_ncorr = request.Form("m[0][maot_ncorr]")
horas = request.Form("m[0][maot_nhoras_programa]")
presupuesto=request.Form("m[0][maot_npresupuesto_relator]")
orden = request.Form("m[0][maot_norden]")

if maot_ncorr <> "" and horas <> "" and presupuesto <> "" and orden <> "" then
	c_update = "update mallas_otec set maot_nhoras_programa="&horas&",maot_npresupuesto_relator="&presupuesto&",maot_norden="&orden&", audi_tusuario='"&usuario&"',audi_fmodificacion=getDate() where cast(maot_ncorr as varchar)='"&maot_ncorr&"'"
	
	conectar.ejecutaS c_update
end if


'response.End()

response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
	CerrarActualizar();
</script>