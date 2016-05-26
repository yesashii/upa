<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file="../biblioteca/_negocio.asp" -->

<%
'for each k in request.Form()
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

for each k in request.form
	if mid(k,InStrRev(k,"[")) = "[reso_ncorr]" and request.Form(k) <> "" then
		reso_ncorr=request.Form(k)
	end if

next

pers_ncorr	=	request.Form("act[0][pers_ncorr]")

set activar		=	new cFormulario
set	conectar	=	new cConexion
set negocio		=	new cnegocio

conectar.inicializar		"desauas"

negocio.inicializa			conectar
activar.inicializar			conectar
activar.carga_parametros	"activar_documentos.xml", "activar_documentos"
activar.procesaform

peri_ccod	=	negocio.obtenerperiodoacademico("solicitudes")
comp_ndocto	=	conectar.consultauno("select comp_ndocto_seq.nextval from dual")

tdet	=	conectar.consultauno("select tdet_ccod from resoluciones where reso_ncorr='"&reso_ncorr&"'")	
inst_ccod	=	conectar.consultauno("select inst_ccod from resoluciones where reso_ncorr='"&reso_ncorr&"'")	
monto		=	conectar.consultauno("select tdet_mvalor_unitario from tipos_detalle where tdet_ccod='"&tdet&"'")
		
fdocto		=	conectar.consultauno("select convert(varchar,getdate(),103) as fecha")

sede_ccod	=	conectar.consultauno("select sede_ccod from ofertas_academicas a, alumnos b where a.ofer_ncorr=b.ofer_ncorr and b.matr_ncorr=(select max(matr_ncorr) from alumnos where pers_ncorr='"&pers_ncorr&"')")

tcom_ccod	=	conectar.consultauno("select tcom_ccod from tipos_detalle where tdet_ccod='"&tdet&"'")	


if clng(monto) = 0 then
	activar.agregacampopost		"esol_ccod",		5
else
	activar.agregacampopost		"esol_ccod",		3
end if

activar.agregacampopost		"comp_ndocto",		comp_ndocto	
activar.agregacampopost		"tcom_ccod",		tcom_ccod
activar.agregacampopost		"tdet_ccod",		tdet
activar.agregacampopost		"inst_ccod",		inst_ccod
activar.agregacampopost		"comp_mneto",		monto
activar.agregacampopost		"comp_fdocto",		fdocto
activar.agregacampopost		"comp_ncuotas",		1
activar.agregacampopost		"sede_ccod",		sede_ccod

activar.agregacampopost		"dcom_ncompromiso",	1
activar.agregacampopost		"dcom_fcompromiso",	fdocto
activar.agregacampopost		"dcom_mcompromiso",	monto
activar.agregacampopost		"ecom_ccod",		1
activar.agregacampopost		"peri_ccod",		peri_ccod

activar.agregacampopost		"deta_ncantidad",		1
activar.agregacampopost		"deta_mvalor_unitario", monto
activar.agregacampopost		"deta_mvalor_detalle",	monto
activar.agregacampopost		"deta_msubtotal",		monto
	

activar.mantienetablas 	false

conectar.estadotransaccion	false
'response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>
