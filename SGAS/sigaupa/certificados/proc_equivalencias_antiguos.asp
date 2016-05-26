<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

matr_ncorr=request.Form("matr_ncorr")
secc_ccod=request.Form("secc_ccod")
plan_ccod=request.Form("plan_ccod")
asig_ccod=request.Form("asigna[0][asig_ccod2]")
mall_ccod=conexion.consultaUno("select mall_ccod from malla_curricular where cast(plan_ccod as varchar)='"&plan_ccod&"' and cast(asig_ccod as varchar)='"&asig_ccod&"'")
usuario=negocio.obtenerUsuario

sentencia_equivalencias = " Insert into " & vbcrlf & _
						" equivalencias (MATR_NCORR, SECC_CCOD, MALL_CCOD, ASIG_CCOD,AUDI_TUSUARIO, AUDI_FMODIFICACION)  " & vbcrlf & _
						" values("&matr_ncorr&","&secc_ccod&","&mall_ccod&",'"&asig_ccod&"','"&usuario&"',getdate())" 
'response.Write("<pre>"&sentencia_equivalencias&"</pre>")
'response.End()
conexion.ejecutaS(sentencia_equivalencias)
%>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
CerrarActualizar();
</script>