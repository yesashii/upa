<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

v_post_ncorr = Session("post_ncorr")
'response.Write(v_post_ncorr)

if EsVacio(v_post_ncorr) then
	Response.Redirect("inicio.asp")
end if
'-------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set negocio2 = new CNegocio
negocio2.Inicializa conexion

pers_ncorr =conexion.consultauno("select pers_ncorr from postulantes where post_ncorr = '"&v_post_ncorr&"'")

Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")

' suprimido por un tiempo ya que no se cobra examen de admision
if variable = "nada" then 

	'---------------periodo ------------------------------------------------------------
	cc_peri_ccod = " select peri_ccod from postulantes where post_ncorr=" & v_post_ncorr
	peri_ccod = conexion.consultaUno(cc_peri_ccod)
	
	'-------------------------------------------------------------------------------------------------
	' --- inserta el compromiso Examen de Admision -----------------
	
	sql_existe_compromiso=	" Select count(*) from compromisos "&_
							" Where tcom_ccod=15"&_
							" And ecom_ccod=1"&_
							" And cast(sede_ccod as varchar)='"&negocio2.ObtenerSede&"'"&_
							" And pers_ncorr="&pers_ncorr
	v_existe_compromiso = conexion.consultaUno(sql_existe_compromiso)				 
	
					
	sql_carrera_pagan =" Select count(*) as total " & vbcrlf & _
					 " From detalle_postulantes a, ofertas_academicas b, especialidades c,carreras d,sedes e, " & vbcrlf & _
					 " ESTADO_EXAMEN_POSTULANTES G" & vbcrlf & _
					 " where a.ofer_ncorr = b.ofer_ncorr " & vbcrlf & _
					 " and b.espe_ccod = c.espe_ccod " & vbcrlf & _
					 " and c.carr_ccod = d.carr_ccod " & vbcrlf & _
					 " and b.sede_ccod =e.sede_ccod " & vbcrlf & _
					 " and A.EEPO_ccod = G.EEPO_ccod " & vbcrlf & _
					 " and cast(a.post_ncorr as varchar)='"&v_post_ncorr&"'"&_
					 " And b.OFER_BPAGA_EXAMEN='S' "
	v_carrera_pagan = conexion.consultaUno(sql_carrera_pagan)
	
	sql_paga_o_no="Select count(*) from postulantes where post_ncorr='"&v_post_ncorr&"' and post_bpaga='N'"
	v_paga=conexion.consultaUno(sql_paga_o_no)
					 
	' si no se ha generado pago y existe al menos una carrera que cobra examen dentro de las que ha postulado
	if(cint(v_existe_compromiso) = 0) and (cint(v_carrera_pagan) > 0) And (cint(v_paga)=0) then
	' genera compromisos por postulacion	
	comp_ndocto_seq 		= conexion.consultauno("exec ObtenerSecuencia 'compromisos'")
	'DCOM_NCOMPROMISO_seq 	= conexion.consultauno("exec ObtenerSecuencia 'detalle_compromisos'")
	sql_monto_examen="Select TDET_MVALOR_UNITARIO from tipos_detalle Where tdet_ccod=1243 and tcom_ccod=15"
	v_monto_examen=conexion.ConsultaUno(sql_monto_examen)
	'response.Write("<br> Actualiza: "&sentencia_postulacion&"<br>")
	
	
	sentencia_compromisos = " Insert into " & vbcrlf & _
							" compromisos (TCOM_CCOD, INST_CCOD, COMP_NDOCTO, ECOM_CCOD, PERS_NCORR, " & vbcrlf & _
							" COMP_FDOCTO, COMP_NCUOTAS, COMP_MNETO, COMP_MDESCUENTO, " & vbcrlf & _
							" COMP_MINTERESES, COMP_MIVA, COMP_MEXENTO, COMP_MDOCUMENTO, AUDI_TUSUARIO, AUDI_FMODIFICACION, SEDE_CCOD)  " & vbcrlf & _
							" values(15,1,"&comp_ndocto_seq&",1,"&pers_ncorr&",getdate(),1,"&v_monto_examen&",0,0,0,0,"&v_monto_examen&",'"&negocio2.ObtenerUsuario&"',getdate(),'"&negocio2.ObtenerSede&"') " 
	
	'response.Write("<br> compro: "&sentencia_compromisos&"<br>")
	
	sentencia_detalle_compromisos = " insert into detalle_compromisos " & vbcrlf & _
									" (TCOM_CCOD, INST_CCOD, COMP_NDOCTO, " & vbcrlf & _
									"  DCOM_NCOMPROMISO, DCOM_FCOMPROMISO, DCOM_MNETO, " & vbcrlf & _
									"  DCOM_MINTERESES, DCOM_MCOMPROMISO, ECOM_CCOD, " & vbcrlf & _
									"  PERS_NCORR, PERI_CCOD, AUDI_TUSUARIO, AUDI_FMODIFICACION)" & vbcrlf & _ 						
									"values (15,1,"&comp_ndocto_seq&",1,getdate(),"&v_monto_examen&",0,"&v_monto_examen&",1,"&pers_ncorr&","&peri_ccod&",'"&negocio2.ObtenerUsuario&"',getdate())"
	
	'"&DCOM_NCOMPROMISO_seq&" eliminado porque la el proceso de pago muere con un numero muy exesivo
	'response.Write("<br><br> detalle compro: "&sentencia_detalle_compromisos&"<br>")
	
	sentencia_detalle = " insert into detalles " & vbcrlf & _
									" (TCOM_CCOD, INST_CCOD, COMP_NDOCTO,TDET_CCOD, " & vbcrlf & _
									"  DETA_NCANTIDAD,DETA_MVALOR_UNITARIO, " & vbcrlf & _
									"  DETA_MVALOR_DETALLE, DETA_MSUBTOTAL, " & vbcrlf & _
									"  AUDI_TUSUARIO, AUDI_FMODIFICACION)" & vbcrlf & _ 						
									"values (15,1,"&comp_ndocto_seq&",1243,1,"&v_monto_examen&","&v_monto_examen&","&v_monto_examen&",'"&negocio2.ObtenerUsuario&"',getdate())"
	'response.Write("<br><br> detalle compro: "&sentencia_detalle&"<br>")	
	'conexion.estadotransaccion false
	'response.End()	
									
	conexion.ejecutaS(sentencia_compromisos)
	conexion.ejecutaS(sentencia_detalle_compromisos)
	conexion.ejecutaS(sentencia_detalle)
	
	elseif (cint(v_carrera_pagan) = 0) then
		' no tiene carreras que requieran pagos
		' entonces se eliminan sus compromisos
		sql_anula_compromiso="Update compromisos Set ecom_ccod='3' "&_
							" Where tcom_ccod=15"&_
							" And ecom_ccod=1"&_
							" And cast(sede_ccod as varchar)='"&negocio2.ObtenerSede&"'"&_
							" And pers_ncorr="&pers_ncorr
		conexion.ejecutaS(sql_anula_compromiso)					
	'response.Write("<br> anula:"&sql_anula_compromiso&"<br>")
	end if
	
end if

v_genera_psico="N" ' ya no se crean test de sicologia
if v_genera_psico="S" then
	'################################################################################################
	'#######################  GENERACION DE COMPROMISO POR TEST PSICOLOGIA	#########################
	'################################################################################################
	
	sql_carrera_pagan =" Select count(*) as total " & vbcrlf & _
							 " From detalle_postulantes a, ofertas_academicas b, especialidades c,carreras d,sedes e, " & vbcrlf & _
							 " ESTADO_EXAMEN_POSTULANTES G" & vbcrlf & _
							 " where a.ofer_ncorr = b.ofer_ncorr " & vbcrlf & _
							 " and b.espe_ccod = c.espe_ccod " & vbcrlf & _
							 " and c.carr_ccod = d.carr_ccod " & vbcrlf & _
							 " and b.sede_ccod =e.sede_ccod " & vbcrlf & _
							 " and A.EEPO_ccod = G.EEPO_ccod " & vbcrlf & _
							 " and cast(a.post_ncorr as varchar)='"&v_post_ncorr&"'"&_
							 " And b.OFER_BPAGA_EXAMEN='S' "& vbcrlf & _
							 " And d.carr_ccod=43 "
					 
	v_carrera_psico = conexion.consultaUno(sql_carrera_pagan)
	'response.Write("<br> Actualiza: <pre>"&sql_carrera_pagan&"</pre><br>")
	'response.Flush()

	if v_carrera_psico > 0 then
		
			'---------------periodo ------------------------------------------------------------
		cc_peri_ccod = " select peri_ccod from postulantes where post_ncorr=" & v_post_ncorr
		peri_ccod = conexion.consultaUno(cc_peri_ccod)
		
		'-------------------------------------------------------------------------------------------------
		' --- busca el compromiso Test  -----------------
		
		sql_existe_compromiso=	" Select count(*) as valor  from compromisos  a, detalle_compromisos b , detalles c "& vbcrlf & _
								" Where a.tcom_ccod=15 "& vbcrlf & _
								" And a.ecom_ccod=1 "& vbcrlf & _
								" And cast(a.sede_ccod as varchar)='"&negocio2.ObtenerSede&"'"& vbcrlf & _
								" And a.pers_ncorr="&pers_ncorr&" "& vbcrlf & _
								" and a.comp_ndocto=b.comp_ndocto"& vbcrlf & _
								" and a.inst_ccod=b.inst_ccod "& vbcrlf & _
								" and a.tcom_ccod=b.tcom_ccod "& vbcrlf & _
								" and b.comp_ndocto=c.comp_ndocto "& vbcrlf & _
								" and b.inst_ccod=c.inst_ccod "& vbcrlf & _
								" and b.tcom_ccod=c.tcom_ccod "& vbcrlf & _
								" and c.tdet_ccod=1377 "
	
								
		v_existe_compromiso = conexion.consultaUno(sql_existe_compromiso)				 
		'response.Write("<br> Actualiza: <pre>"&sql_existe_compromiso&"</pre><br>")
		'response.Flush()
	

		' si no se ha generado pago y existe al menos una carrera que cobra examen dentro de las que ha postulado
		if cint(v_existe_compromiso) = 0  then
		
		' genera compromiso de test psicologia por postulacion	
		comp_ndocto_seq 		= conexion.consultauno("exec ObtenerSecuencia 'compromisos'")
		sql_monto_examen="Select TDET_MVALOR_UNITARIO from tipos_detalle Where tdet_ccod=1377 and tcom_ccod=15"
		v_monto_examen=conexion.ConsultaUno(sql_monto_examen)
		'response.Write("<br> Actualiza: <pre>"&sql_monto_examen&"</pre><br>")
		'response.Flush()
		
		
		sentencia_compromisos = " Insert into " & vbcrlf & _
								" compromisos (TCOM_CCOD, INST_CCOD, COMP_NDOCTO, ECOM_CCOD, PERS_NCORR, COMP_FDOCTO, COMP_NCUOTAS, COMP_MNETO, COMP_MDESCUENTO, " & vbcrlf & _
								" COMP_MINTERESES, COMP_MIVA, COMP_MEXENTO, COMP_MDOCUMENTO, AUDI_TUSUARIO, AUDI_FMODIFICACION, SEDE_CCOD)  " & vbcrlf & _
								" values(15,1,"&comp_ndocto_seq&",1,"&pers_ncorr&",getdate(),1,"&v_monto_examen&",0,0,0,0,"&v_monto_examen&",'"&negocio2.ObtenerUsuario&"',getdate(),'"&negocio2.ObtenerSede&"') " 
		'response.Write("<br> compro: <pre>"&sentencia_compromisos&"</pre><br>")
		'response.Flush()
		
		sentencia_detalle_compromisos = " insert into detalle_compromisos " & vbcrlf & _
										" (TCOM_CCOD, INST_CCOD, COMP_NDOCTO, DCOM_NCOMPROMISO, DCOM_FCOMPROMISO, DCOM_MNETO, " & vbcrlf & _
										"  DCOM_MINTERESES, DCOM_MCOMPROMISO, ECOM_CCOD, PERS_NCORR, PERI_CCOD, AUDI_TUSUARIO, AUDI_FMODIFICACION)" & vbcrlf & _ 						
										"values (15,1,"&comp_ndocto_seq&",1,getdate(),"&v_monto_examen&",0,"&v_monto_examen&",1,"&pers_ncorr&","&peri_ccod&",'"&negocio2.ObtenerUsuario&"',getdate())"
		'response.Write("<br><br> detalle compro:<pre> "&sentencia_detalle_compromisos&"</pre><br>")
		'response.Flush()
		
		sentencia_detalle = " insert into detalles " & vbcrlf & _
										" (TCOM_CCOD, INST_CCOD, COMP_NDOCTO,TDET_CCOD, DETA_NCANTIDAD,DETA_MVALOR_UNITARIO, " & vbcrlf & _
										"  DETA_MVALOR_DETALLE, DETA_MSUBTOTAL, AUDI_TUSUARIO, AUDI_FMODIFICACION)" & vbcrlf & _ 						
										"values (15,1,"&comp_ndocto_seq&",1377,1,"&v_monto_examen&","&v_monto_examen&","&v_monto_examen&",'"&negocio2.ObtenerUsuario&"',getdate())"
		'response.Write("<br><br> detalle compro: <pre>"&sentencia_detalle&"</pre><br>")	
		'response.Flush()
		
			conexion.ejecutaS(sentencia_compromisos)
			conexion.ejecutaS(sentencia_detalle_compromisos)
			conexion.ejecutaS(sentencia_detalle)
			sql_obliga_pagar	= "update postulantes set post_bpaga = 'S' where post_ncorr ='"&v_post_ncorr&"' "
			conexion.ejecutaS(sql_obliga_pagar)
	
		end if
	end if
end if
'########	CAMBIA EL ESTADO DE LA POSTULACION A ENVIADO	##############
sentencia_postulacion	= "update postulantes set epos_ccod = 2, post_bpaga = 'N',audi_fmodificacion =getdate() where post_ncorr ='"&v_post_ncorr&"' "
conexion.ejecutaS(sentencia_postulacion)

'conexion.EstadoTransaccion false
'response.End()
'--------------------------------------------------------------------------------------------------------------------------------  
Response.Redirect("post_cerrada.asp")
%>

