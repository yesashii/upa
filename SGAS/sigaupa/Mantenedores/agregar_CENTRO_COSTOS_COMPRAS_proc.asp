<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

'for each k in request.form
'response.Write(k&" = "&request.Form(k)&"<br>")
'next'


set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

ccos_tcodigo=request.form("b[0][ccos_tcodigo]")
ccos_ncorr=request.form("b[0][ccos_ncorr]")

if ccos_ncorr= ""then
existe_cc=conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from ocag_centro_costo where cast(ccos_tcodigo as varchar)='"&ccos_tcodigo&"' ")
else
existe_cc="N"
end if
if existe_cc="N" then
				
				
				if ccos_ncorr=""then
				ccos_ncorr= conexion.ConsultaUno("execute obtenersecuencia 'ocag_centro_costo'")
				 'response.write(maqu_ncorr&"<hr>")'
				 end if
				set f_maquina = new CFormulario
				f_maquina.Carga_Parametros "centro_costo_compra.xml", "centro_costos_i"
				f_maquina.Inicializar conexion
				f_maquina.ProcesaForm
				f_maquina.agregacampopost "ccos_ncorr" , ccos_ncorr
		
				f_maquina.MantieneTablas false

'response.End()'
else

session("mensajeerror")= "el Codigo de centro de costo ingresado ya existe"

end if

'response.End()
'Response.Redirect("agregar_centro_costos_compras.asp")'


%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>