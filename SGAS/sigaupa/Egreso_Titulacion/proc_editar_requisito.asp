<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file="../biblioteca/_negocio.asp" -->
<%

set conexion = new cConexion
conexion.Inicializar "desauas"

set negocio = new cnegocio
negocio.Inicializa conexion

'for each k in request.form
'	response.Write(k&" = "&request.form(k)&"<br>")
'next

treq_ccod = request.Form("m[0][treq_ccod]")
teva_ccod = request.Form("m[0][teva_ccod]")
ChkObli=request.Form("ChkObli")
repl_nponderacion = request.Form("m[0][repl_nponderacion]")
repl_ncorr = request.Form("repl_ncorr")
TREQ_CCOD=request.Form("TREQ_CCOD")

'if ChkObli="" or isnull(ChkObli) then
'	ChkObli="N"
'else
'	ChkObli="S"
'end if
if TREQ_CCOD=1 then
	sentencia=" update requisitos_plan set repl_nponderacion='"&repl_nponderacion&"'" & _
			  " where repl_ncorr= '"&repl_ncorr&"'"	
else
	sentencia = " update  requisitos_plan set treq_ccod='"&treq_ccod&"' ,"  & _
			    " audi_fmodificacion=sysdate ," & _
				" audi_tusuario ='"&negocio.obtenerusuario&"'," & _
				" repl_bobligatorio = 'S'," & _
				" repl_nponderacion ='"&repl_nponderacion&"' " & _
				" where repl_ncorr= '"&repl_ncorr&"'"
end if				
			
conexion.EstadoTransaccion conexion.EjecutaS(sentencia)
'response.Redirect(request.ServerVariables("HTTP_REFERER"))
'response.Write(sentencia)		
%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>