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
'response.End()

treq_ccod=request.Form("m[0][treq_ccod]")
sede_ccod=request.Form("sede_ccod")
teva_ccod=request.Form("teva_ccod")
ponderacion=request.Form("m[0][repl_nponderacion]")
plan_ccod=request.Form("plan_ccod")
peri_ccod=request.Form("peri_ccod")

sql = " select count(*) from requisitos_plan " & _ 
	  " where sede_ccod= '"&sede_ccod&"' and plan_ccod='"&plan_ccod&"' " & _
	  " and peri_ccod='"&peri_ccod&"' and treq_ccod='"&treq_ccod&"' "
	  
'response.Write(sql&"<br>")
reg=conexion.consultauno(sql)

if (cint(reg)=0) then
	sentencia= " insert into requisitos_plan" & _
			   " (REPL_NCORR,PLAN_CCOD,TREQ_CCOD,AUDI_FMODIFICACION,AUDI_TUSUARIO,PERI_CCOD,SEDE_CCOD,REPL_BOBLIGATORIO,REPL_NPONDERACION) " & _
			   " values (repl_ncorr_seq.nextval,'"&plan_ccod&"','"&treq_ccod&"',sysdate,'"&negocio.obtenerusuario&"','"&peri_ccod&"','"&sede_ccod&"','S','"&ponderacion&"')" 
		   
	'response.Write(sentencia)
	ver = conexion.EjecutaS(sentencia)
	
	conexion.EstadoTransaccion  ver
	if not ver then
		session("mensajeError")="Ha ocurrido un error al guardar el requisito.\nPor favor vuelva a intentar mas tarde."
		response.Redirect(request.ServerVariables("HTTP_REFERER"))
	end if
else
 	session("mensajeError")=" Ya existe un requisito del tipo seleccionado."
	response.Redirect(request.ServerVariables("HTTP_REFERER"))
end if

%>
<script language="JavaScript">
	self.opener.location.reload()
	window.close()
</script>