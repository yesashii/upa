 <!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
estado_transaccion=true
set conectar = new cconexion
conectar.inicializar "desauas"

set negocio = new CNegocio
negocio.Inicializa conectar

v_audi_tusuario= request.Form("v_usuario")

set formulario = new cformulario
formulario.carga_parametros "agregar_requisito.xml", "agregar"
formulario.inicializar conectar
formulario.procesaForm

v_plan_ccod = Request.Form("plan_ccod")
v_mall_ccod = Request.Form("mall_ccod")




for iFila = 0 to formulario.CuentaPost - 1
	if formulario.ObtenerValorPost(iFila, "asig_ccod") <> "" then		
		v_asig_ccod = formulario.ObtenerValorPost(iFila, "asig_ccod")
		v_nive_ccod = formulario.ObtenerValorPost(iFila, "nive_ccod_2")
		v_treq_ccod = formulario.ObtenerValorPost(iFila, "treq_ccod")
		
		consulta = "select mall_ccod from malla_curricular where asig_ccod = '"&v_asig_ccod&"' and plan_ccod = "&v_plan_ccod&" and nive_ccod = " & v_nive_ccod
		v_mall_crequisito = conectar.ConsultaUno (consulta)
		
		consulta2=cint(conectar.consultauno("select count(*) from requisitos where "&_
		" mall_crequisito='"&v_mall_crequisito&"' and mall_ccod='"&v_mall_ccod&"'" ))
		if consulta2 = 0 then
			sentencia = " INSERT INTO requisitos(mall_crequisito, mall_ccod, treq_ccod, audi_tusuario, audi_fmodificacion) " & _
						" VALUES ("&v_mall_crequisito&","& v_mall_ccod &","& v_treq_ccod &", '"& v_audi_tusuario &"', sysdate)"
		else
			sentencia = " UPDATE  requisitos SET  treq_ccod="& v_treq_ccod &",audi_tusuario='"& v_audi_tusuario &"'," & _
						" audi_fmodificacion=sysdate " & _
						" WHERE mall_crequisito='"&v_mall_crequisito&"' and mall_ccod='"&v_mall_ccod&"'"
						
		end if 
		response.Write(sentencia)					
		estado=conectar.EjecutaS (sentencia)
		if estado=false then
			estado_transaccion=false
		end if	
		

	end if
next
conectar.estadotransaccion estado_transaccion
'response.redirect(request.ServerVariables("HTTP_REFERER"))
%>
<script language="JavaScript">
window.opener.location.reload()
window.close();

</script>
	