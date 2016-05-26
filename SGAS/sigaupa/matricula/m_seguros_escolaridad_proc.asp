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
post_ncorr = request.Form("post_ncorr")
pers_ncorr_contratante= request.Form("pers_ncorr_contratante")
no_deseo= request.Form("no_deseo")
ofer_ncorr = conexion.consultaUno("select ofer_ncorr from alumnos where cast(post_ncorr as varchar)='"&request.Form("post_ncorr")&"'")
pers_ncorr = conexion.consultaUno("select pers_ncorr from alumnos where cast(post_ncorr as varchar)='"&request.Form("post_ncorr")&"'")
peri_ccod = conexion.consultaUno("select peri_ccod from postulantes where cast(post_ncorr as varchar)='"&request.Form("post_ncorr")&"'")
sede_ccod = conexion.consultaUno("select sede_ccod from ofertas_academicas where cast(ofer_ncorr as varchar)='"&ofer_ncorr&"'")

v_sses_ncorr = conexion.ConsultaUno("exec ObtenerSecuencia 'solicitud_seguro_escolaridad'")


v_monto_compromiso=35000

c_solicitud = "insert into solicitud_seguro_escolaridad (SSES_NCORR,POST_NCORR,OFER_NCORR,PERS_NCORR_CONTRATANTE,SSES_FPOSTULACION,AUDI_TUSUARIO,AUDI_FMODIFICACION,NO_DESEO)" &_
              "values ("&v_sses_ncorr&","&post_ncorr&","&ofer_ncorr&","&pers_ncorr_contratante&",getDate(),'"&usuario&"',getDate(),'"&no_deseo&"')"

'response.Write("<br>"&c_solicitud)
conexion.ejecutaS(c_solicitud)


if no_deseo = "N" then

    comp_ndocto_seq = conexion.consultauno("exec ObtenerSecuencia 'compromisos'")
    sentencia_compromisos = " Insert into " & vbcrlf & _
							" compromisos (TCOM_CCOD, INST_CCOD, COMP_NDOCTO, ECOM_CCOD, PERS_NCORR, " & vbcrlf & _
							" COMP_FDOCTO, COMP_NCUOTAS, COMP_MNETO, COMP_MDESCUENTO, " & vbcrlf & _
							" COMP_MINTERESES, COMP_MIVA, COMP_MEXENTO, COMP_MDOCUMENTO, AUDI_TUSUARIO, AUDI_FMODIFICACION, SEDE_CCOD,POST_NCORR,OFER_NCORR,PERI_CCOD)  " & vbcrlf & _
							" values(26,1,"&comp_ndocto_seq&",1,"&pers_ncorr&",getdate(),1,"&v_monto_compromiso&",0,0,0,0,"&v_monto_compromiso&",'"&negocio.ObtenerUsuario&"',getdate(),'"&negocio.ObtenerSede&"',"&post_ncorr&","&ofer_ncorr&","&peri_ccod&") " 
	
	sentencia_detalle_compromisos = " insert into detalle_compromisos " & vbcrlf & _
									" (TCOM_CCOD, INST_CCOD, COMP_NDOCTO, " & vbcrlf & _
									"  DCOM_NCOMPROMISO, DCOM_FCOMPROMISO, DCOM_MNETO, " & vbcrlf & _
									"  DCOM_MINTERESES, DCOM_MCOMPROMISO, ECOM_CCOD, " & vbcrlf & _
									"  PERS_NCORR, PERI_CCOD, AUDI_TUSUARIO, AUDI_FMODIFICACION)" & vbcrlf & _ 						
									"values (26,1,"&comp_ndocto_seq&",1,getdate(),"&v_monto_compromiso&",0,"&v_monto_compromiso&",1,"&pers_ncorr&","&peri_ccod&",'"&negocio.ObtenerUsuario&"',getdate())"
	
	sentencia_detalle = " insert into detalles " & vbcrlf & _
									" (TCOM_CCOD, INST_CCOD, COMP_NDOCTO,TDET_CCOD, " & vbcrlf & _
									"  DETA_NCANTIDAD,DETA_MVALOR_UNITARIO, " & vbcrlf & _
									"  DETA_MVALOR_DETALLE, DETA_MSUBTOTAL, " & vbcrlf & _
									"  AUDI_TUSUARIO, AUDI_FMODIFICACION)" & vbcrlf & _ 						
									"values (26,1,"&comp_ndocto_seq&",1237,1,"&v_monto_compromiso&","&v_monto_compromiso&","&v_monto_compromiso&",'"&negocio.ObtenerUsuario&"',getdate())"
									
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


