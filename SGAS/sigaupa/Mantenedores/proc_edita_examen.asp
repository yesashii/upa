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

set f_mantiene_carreras = new CFormulario
f_mantiene_carreras.Carga_Parametros "busca_examen_postulante.xml", "mantiene_examenes"
f_mantiene_carreras.Inicializar conexion
f_mantiene_carreras.ProcesaForm

v_eepo_ccod		=	f_mantiene_carreras.ObtenerValorPost(0,"eepo_ccod")
v_ofer_ncorr	=	f_mantiene_carreras.ObtenerValorPost(0,"ofer_ncorr")
v_post_ncorr	=	f_mantiene_carreras.ObtenerValorPost(0,"post_ncorr")
v_pers_ncorr	= 	conexion.ConsultaUno("Select pers_ncorr  from postulantes where post_ncorr="&v_post_ncorr)

'response.Write("<br>Ofer_ncorr:"&v_ofer_ncorr)
'response.Write("<br>Post_ncorr:"&v_post_ncorr)
'response.Write("<br>Pers_ncorr:"&v_pers_ncorr)


v_salida_mantiene = f_mantiene_carreras.MantieneTablas(false)

'debemos sacar los datos necesarios para crear el regsitro del alumno en la tabla usuarios
rut = conexion.consultaUno("select cast(pers_nrut as varchar)+'-'+pers_xdv from personas_postulante where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"'")
existe = conexion.consultaUno("select count(*) from usuarios where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"'")
if existe ="0" then
	c_insert = " insert into usuarios (PERS_NCORR,USUA_TPREGUNTA,USUA_TRESPUESTA,USUA_TUSUARIO,USUA_TCLAVE,AUDI_TUSUARIO,AUDI_FMODIFICACION)"&_
			   " values ('"&v_pers_ncorr&"',null,null,'"&rut&"','"&v_post_ncorr&"','"&negocio.obtenerUsuario&"',getDate()) "
	
	v_usuario = conexion.EjecutaS(c_insert)
end if

'se coloca en 0 para no generar el concepto de matricula anticipada
genera_matricula_anticipada = 0

if genera_matricula_anticipada <> 0 then 

	sql_matricula_anticipada = " Select d.valor " & vbcrlf & _
								" From ofertas_academicas a,especialidades b,carreras c, matriculas_anticipadas d " & vbcrlf & _
								" Where a.ofer_ncorr ='"&v_ofer_ncorr&"' " & vbcrlf & _
								" and a.espe_ccod=b.espe_ccod  " & vbcrlf & _
								" and b.carr_ccod=c.carr_ccod " & vbcrlf & _
								" and a.sede_ccod=d.sede_ccod " & vbcrlf & _
								" and a.jorn_ccod=d.jorn_ccod " & vbcrlf & _
								" and c.carr_ccod=d.carr_ccod " & vbcrlf & _
								" and a.peri_ccod=d.peri_ccod " & vbcrlf & _
								" and d.mant_bactiva='S' "
	
	v_monto_matricula=conexion.ConsultaUno(sql_matricula_anticipada)

	' si existe un valor para una matricula anticipada en este periodo
	if v_monto_matricula <> "" and v_eepo_ccod="2" then 
	'-------------------------------------------------------------------------------------------------
	' --- CREACION DE COMPROMISO POR CONCEPTO DE MATRICULA ANTICIPADA -----------------
	
	sql_existe_compromiso=	" Select count(*) from compromisos "&_
							" Where tcom_ccod=37 "&_
							" And ecom_ccod=1 "&_
							" And pers_ncorr="&v_pers_ncorr&_
							" And ofer_ncorr="&v_ofer_ncorr&_
							" And post_ncorr="&v_post_ncorr
							
	v_existe_compromiso = conexion.consultaUno(sql_existe_compromiso)
	' si no se ha generado Matricula para esta oferta academica
	if(cint(v_existe_compromiso) = 0)  then
		' genera compromisos por postulacion	
		comp_ndocto_seq 		= conexion.consultauno("exec ObtenerSecuencia 'compromisos'")
	
		v_peri_ccod=conexion.ConsultaUno("select peri_ccod from ofertas_academicas where ofer_ncorr="&v_ofer_ncorr)
		'Response.Write("<hr>Periodo: "&v_peri_ccod&"<hr>")
		
		sentencia_compromisos = " Insert into " & vbcrlf & _
								" compromisos (TCOM_CCOD, INST_CCOD, COMP_NDOCTO, ECOM_CCOD, PERS_NCORR, "& vbcrlf & _ 
								" COMP_FDOCTO, COMP_NCUOTAS, COMP_MNETO, COMP_MDESCUENTO, " & vbcrlf & _
								" COMP_MINTERESES, COMP_MIVA, COMP_MEXENTO, COMP_MDOCUMENTO, AUDI_TUSUARIO, " & vbcrlf & _
								" AUDI_FMODIFICACION, SEDE_CCOD,post_ncorr, ofer_ncorr, peri_ccod)  "& vbcrlf & _
								" values(37,1,"&comp_ndocto_seq&",1,"&v_pers_ncorr&",getdate(),1,"&v_monto_matricula&",0,0,0,"& vbcrlf & _
								" 0,"&v_monto_matricula&",'"&negocio.ObtenerUsuario&"',getdate(),'"&negocio.ObtenerSede&"',"& vbcrlf & _
								" "&v_post_ncorr&","&v_ofer_ncorr&","&v_peri_ccod&") " 
		
		'response.Write("<br> compro: "&sentencia_compromisos&"<br>")
		
		sentencia_detalle_compromisos = " insert into detalle_compromisos " & vbcrlf & _
										" (TCOM_CCOD, INST_CCOD, COMP_NDOCTO, " & vbcrlf & _
										"  DCOM_NCOMPROMISO, DCOM_FCOMPROMISO, DCOM_MNETO, " & vbcrlf & _
										"  DCOM_MINTERESES, DCOM_MCOMPROMISO, ECOM_CCOD, " & vbcrlf & _
										"  PERS_NCORR, PERI_CCOD, AUDI_TUSUARIO, AUDI_FMODIFICACION)" & vbcrlf & _ 						
										" values (37,1,"&comp_ndocto_seq&",1,getdate(),"&v_monto_matricula&",0,"&v_monto_matricula&","& vbcrlf & _ 
										" 1,"&v_pers_ncorr&","&v_peri_ccod&",'"&negocio.ObtenerUsuario&"',getdate())"

		'response.Write("<br><br> detalle compro: "&sentencia_detalle_compromisos&"<br>")
		
		sentencia_detalle = " insert into detalles " & vbcrlf & _
							" (TCOM_CCOD, INST_CCOD, COMP_NDOCTO,TDET_CCOD, " & vbcrlf & _
							"  DETA_NCANTIDAD,DETA_MVALOR_UNITARIO, " & vbcrlf & _
							"  DETA_MVALOR_DETALLE, DETA_MSUBTOTAL, " & vbcrlf & _
							"  AUDI_TUSUARIO, AUDI_FMODIFICACION)" & vbcrlf & _ 						
							" values (37,1,"&comp_ndocto_seq&",1369,1,"&v_monto_matricula&","&v_monto_matricula&", "& vbcrlf & _ 
							" "&v_monto_matricula&",'"&negocio.ObtenerUsuario&"',getdate())"
		'response.Write("<br><br> detalle compro: "&sentencia_detalle&"<br>")	
		
										
		v_salida_mantiene=conexion.ejecutaS(sentencia_compromisos)
		v_salida_mantiene=conexion.ejecutaS(sentencia_detalle_compromisos)
		v_salida_mantiene=conexion.ejecutaS(sentencia_detalle)
	end if
end if

end if
sql_pone_fecha ="Update detalle_postulantes set dpos_fexamen=getdate() where post_ncorr="&v_post_ncorr&" and ofer_ncorr="&v_ofer_ncorr
'RESPONSE.Write("<BR> sql_pone_fecha: "&sql_pone_fecha)
v_salida_mantiene =conexion.EjecutaS(sql_pone_fecha)
'response.Write("Transaccion: "&v_salida_mantiene)
'conexion.estadotransaccion false
'response.End()

if v_salida_mantiene then
session("mensaje_error")="Los datos han sido guardados correctamente"
else
session("mensaje_error")="No se pudo realizar la accion solicitada"
end if
response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>

