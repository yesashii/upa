<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

'for each k in request.Form()
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

'------------------------------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario = negocio.obtenerUsuario
post_ncorr = request.Form("m[0][post_ncorr]")
ofer_ncorr = request.Form("m[0][ofer_ncorr]")
post_bnuevo = request.QueryString("post_bnuevo")

pers_ncorr = request.Form("pers_ncorr_contratante")
no_deseo = request.Form("no_deseo")
peri_ccod = conexion.consultaUno("select peri_ccod from postulantes where cast(post_ncorr as varchar)='"&post_ncorr&"'")
sede_ccod = conexion.consultaUno("select sede_ccod from ofertas_academicas where cast(ofer_ncorr as varchar)='"&ofer_ncorr&"'")

monto = 0
if post_bnuevo = "S" then
	monto = "2700"
elseif post_bnuevo = "N" then
    monto = "1100"
end if


set fc_postulante = new CFormulario
fc_postulante.Carga_Parametros "cargo_pase_escolar.xml", "info_postulacion_contrato"
fc_postulante.Inicializar conexion
fc_postulante.ProcesaForm

msj_error = ""

encontro = 0
for i_ = 0 to fc_postulante.CuentaPost - 1
    if encontro = 0 then
		post_ncorr = fc_postulante.ObtenerValorPost(i_, "post_ncorr")
		ofer_ncorr = fc_postulante.ObtenerValorPost(i_, "ofer_ncorr")
		if post_ncorr <> "" and ofer_ncorr <> "" then
		   encontro = 1
		end if
    end if
next


if ofer_ncorr <> "" and post_ncorr <> "" then

    comp_ndocto_seq = conexion.consultauno("exec ObtenerSecuencia 'compromisos'")
    sentencia_compromisos = " Insert into compromisos " & vbcrlf & _
							" (TCOM_CCOD, INST_CCOD, COMP_NDOCTO, ECOM_CCOD, PERS_NCORR, " & vbcrlf & _
							" COMP_FDOCTO, COMP_NCUOTAS, COMP_MNETO, COMP_MDESCUENTO, " & vbcrlf & _
							" COMP_MINTERESES, COMP_MIVA, COMP_MEXENTO, COMP_MDOCUMENTO, AUDI_TUSUARIO, AUDI_FMODIFICACION, SEDE_CCOD,POST_NCORR,OFER_NCORR,PERI_CCOD)  " & vbcrlf & _
							" values(27,1,"&comp_ndocto_seq&",1,"&pers_ncorr&",getdate(),1,"&monto&",0,0,0,0,"&monto&",'"&negocio.ObtenerUsuario&"',getdate(),'"&negocio.ObtenerSede&"',"&post_ncorr&","&ofer_ncorr&","&peri_ccod&") " 
	
	sentencia_detalle_compromisos = " insert into detalle_compromisos " & vbcrlf & _
									" (TCOM_CCOD, INST_CCOD, COMP_NDOCTO, " & vbcrlf & _
									"  DCOM_NCOMPROMISO, DCOM_FCOMPROMISO, DCOM_MNETO, " & vbcrlf & _
									"  DCOM_MINTERESES, DCOM_MCOMPROMISO, ECOM_CCOD, " & vbcrlf & _
									"  PERS_NCORR, PERI_CCOD, AUDI_TUSUARIO, AUDI_FMODIFICACION)" & vbcrlf & _ 						
									"values (27,1,"&comp_ndocto_seq&",1,getdate(),"&monto&",0,"&monto&",1,"&pers_ncorr&","&peri_ccod&",'"&negocio.ObtenerUsuario&"',getdate())"
	
	sentencia_detalle = " insert into detalles " & vbcrlf & _
									" (TCOM_CCOD, INST_CCOD, COMP_NDOCTO,TDET_CCOD, " & vbcrlf & _
									"  DETA_NCANTIDAD,DETA_MVALOR_UNITARIO, " & vbcrlf & _
									"  DETA_MVALOR_DETALLE, DETA_MSUBTOTAL, " & vbcrlf & _
									"  AUDI_TUSUARIO, AUDI_FMODIFICACION)" & vbcrlf & _ 						
									"values (27,1,"&comp_ndocto_seq&",1224,1,"&monto&","&monto&","&monto&",'"&negocio.ObtenerUsuario&"',getdate())"
									
	'response.Write("<br>"&sentencia_compromisos)
	'response.Write("<br>"&sentencia_detalle_compromisos)
	'response.Write("<br>"&sentencia_detalle)
	
	conexion.ejecutaS(sentencia_compromisos)
	conexion.ejecutaS(sentencia_detalle_compromisos)
	conexion.ejecutaS(sentencia_detalle)
end if
'response.Write(ofer_ncorr)
'response.End()
'response.End()

'response.End()

response.Redirect(request.ServerVariables("HTTP_REFERER"))
'------------------------------------------------------------------------------------------------------------------------
%>