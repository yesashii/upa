<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
on error resume next
set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()

matricula 		= request.Form("m[0][ofot_nmatricula]")
arancel 		= request.Form("m[0][ofot_narancel]")
admision 		= request.Form("m[0][anio_admision]")
dgso_ncorr 		= request.Form("m[0][dgso_ncorr]")
dcur_ncorr 		= request.Form("m[0][dcur_ncorr]")
sede_ccod 		= request.Form("m[0][sede_ccod]")
nro_resolucion 	= request.Form("m[0][nro_resolucion]")
fecha_resolu 	= request.Form("m[0][fecha_resolucion]")
udpo_ccod 		= request.Form("m[0][udpo_ccod]")
activa1			= request.Form("_m[0][ofer_bpublica]")
activa2			= request.Form("m[0][ofer_bpublica]")
cod_presupuestario= request.Form("m[0][cod_presupuestario]")

if activa1<>"" then
activa=activa1
else
activa=activa2
end if

usuario = negocio.obtenerUsuario

tiene_oferta = conectar.consultaUno("select case count(*) when 0 then 'N' else 'S' end from ofertas_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")

if tiene_oferta= "N" then
 consulta = "insert into ofertas_otec (dgso_ncorr,dcur_ncorr,sede_ccod,ofot_nmatricula,ofot_narancel,audi_tusuario,audi_fmodificacion,anio_admision,udpo_ccod,nro_resolucion,activa_web,fecha_resolucion,cod_presupuestario)"&_
            "values ("&dgso_ncorr&","&dcur_ncorr&","&sede_ccod&","&matricula&","&arancel&",'"&usuario&"',getDate(),"&admision&",'"&udpo_ccod&"','"&nro_resolucion&"','"&activa&"','"&fecha_resolu&"','"&cod_presupuestario&"')"
else
 consulta = "update ofertas_otec set ofot_nmatricula="&matricula&",ofot_narancel="&arancel&",audi_tusuario='"&usuario&"',audi_fmodificacion=getDate(),anio_admision="&admision&" ,UDPO_CCOD='"&UDPO_CCOD&"',nro_resolucion='"&nro_resolucion&"',fecha_resolucion='"&fecha_resolu&"', activa_web='"&activa&"', cod_presupuestario='"&cod_presupuestario&"' where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'"
end if	
'response.Write(consulta)
'response.End()
conectar.ejecutaS consulta

tiene_tipo_detalle = conectar.consultaUno("select isnull(tdet_ccod,0) from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")
dcur_tdesc = conectar.consultaUno("select dcur_tdesc from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")

if tiene_tipo_detalle = "0" then 
	tdet_ccod = conectar.consultaUno("exec obtenerSecuencia 'tipos_detalle'")
	c_tipo = "insert into tipos_detalle (tdet_ccod,tdet_tdesc,tdet_bdescuento,tdet_mvalor_unitario,tcom_ccod,tdet_bvigente,audi_tusuario,audi_fmodificacion, tdet_bboleta,tbol_ccod)"&_
	         "values("&tdet_ccod&",'"&dcur_tdesc&"','S',"&(clng(matricula) + clng(arancel))&",7,'S','"&usuario&"',getDate(),'S',2)"
			 
	c_diplomado = "update diplomados_cursos set tdet_ccod ="&tdet_ccod&" where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'"		 
%>
<script>
	url="http://admision.upacifico.cl/postulacion/www/proc_edita_otec.php?dcur_tdesc=<%=dcur_tdesc%>&ofot_narancel=<%=arancel%>&ofot_nmatricula=<%=matricula%>";
	window.open(url);
</script>
<%
else
  tdet_ccod = conectar.consultaUno("select tdet_ccod from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")		
  c_tipo = " update tipos_detalle set tdet_tdesc='"&dcur_tdesc&"',tdet_mvalor_unitario="&(clng(matricula) + clng(arancel))&",audi_tusuario='"&usuario&"',audi_fmodificacion=getDate()"&_
           " where cast(tdet_ccod as varchar)='"&tdet_ccod&"'" 
  c_diplomado = "update diplomados_cursos set tdet_ccod ="&tdet_ccod&" where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'"			    	 
end if

'response.write(request.ServerVariables("HTTP_REFERER"))
'response.Write(c_tipo)
'response.Write(c_diplomado)
'response.End()
conectar.ejecutaS c_tipo
conectar.ejecutaS c_diplomado
'response.End()
'response.Redirect(request.ServerVariables("HTTP_REFERER"))
'response.End()
'response.Redirect("editar_asignatura.asp?asig_ccod="&request.Form("m[0][asig_ccod]"))

%>
<script type="text/javascript">
function redireccionar(){
  location.href="aranceles_programa.asp";
} 
setTimeout ("redireccionar()", 500); //tiempo expresado en milisegundos
</script>
