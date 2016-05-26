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
negocio.InicializaPortal conexion

set negocio2 = new CNegocio
negocio2.InicializaPortal conexion


Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")

'conexion.EstadoTransaccion false
'---------------periodo ------------------------------------------------------------
cc_peri_ccod = " select peri_ccod from postulantes where post_ncorr=" & v_post_ncorr
peri_ccod = conexion.consultaUno(cc_peri_ccod)

'-------------------------------------------------------------------------------------------------
'set f_postulacion = new CFormulario
'f_postulacion.Carga_Parametros "postulacion_6.xml", "postulacion"
'f_postulacion.Inicializar conexion
'f_postulacion.ProcesaForm

'f_postulacion.AgregaCampoPost "epos_ccod", "2"
'f_postulacion.AgregaCampoPost "post_fpostulacion", negocio.ObtenerFechaActual

'f_postulacion.MantieneTablas true
' --- inserta el compromiso examen de admision -----------------


pers_ncorr =conexion.consultauno("select pers_ncorr from postulantes where post_ncorr = '"&v_post_ncorr&"'")

sql_existe_compromiso=	" Select count(*) from compromisos "&_
						" Where tcom_ccod=15"&_
						" And ecom_ccod=1"&_
						" And pers_ncorr="&pers_ncorr
'response.Write("<br> sql_existe_compromiso "&sql_existe_compromiso)
v_existe_compromiso = conexion.consultaUno(sql_existe_compromiso)				 

				
sql_carrera_pagan =" Select count(*) as total " & vbcrlf & _
				 " From detalle_postulantes a, ofertas_academicas b, especialidades c,carreras d,sedes e, " & vbcrlf & _
				 " ESTADO_EXAMEN_POSTULANTES G" & vbcrlf & _
				 " where a.ofer_ncorr = b.ofer_ncorr " & vbcrlf & _
				 " and b.espe_ccod = c.espe_ccod " & vbcrlf & _
				 " and c.carr_ccod = d.carr_ccod " & vbcrlf & _
				 " and b.sede_ccod =e.sede_ccod " & vbcrlf & _
				 " and A.EEPO_ccod = G.EEPO_ccod " & vbcrlf & _
				 " and a.post_ncorr ='"&v_post_ncorr&"'"&_
				 " And b.OFER_BPAGA_EXAMEN='S' "
'response.Write("<br> sql_carrera_pagan "&sql_carrera_pagan)
v_carrera_pagan = conexion.consultaUno(sql_carrera_pagan)				 

'response.Write("<br> Actualiza: "&sql_existe_compromiso&"<br>")
'response.Write("<br> Tiene "&v_existe_compromiso&" compromisos y son "&v_carrera_pagan&" carreras ke cobran <br>")

' si no se ha generado pago y existe al emnos una carrera ke cobra de las que ha postulado
if(v_existe_compromiso = 0) and (v_carrera_pagan > 0) then
' genera compromisos por postulacion	

comp_ndocto_seq 		= conexion.consultauno("exec ObtenerSecuencia 'compromisos'")
'DCOM_NCOMPROMISO_seq 	= conexion.consultauno("exec ObtenerSecuencia 'detalle_compromisos'")

sql_monto_examen="Select TDET_MVALOR_UNITARIO from tipos_detalle Where tdet_ccod=1243 and tcom_ccod=15"

v_monto_examen=conexion.ConsultaUno(sql_monto_examen)

sentencia_postulacion	= "update postulantes set epos_ccod = 2, audi_fmodificacion =getdate() where post_ncorr ='"&v_post_ncorr&"' "
'response.Write("<br><br> Actualiza: "&sentencia_postulacion&"<br>")


sentencia_compromisos = " Insert into " & vbcrlf & _
						" compromisos (TCOM_CCOD, INST_CCOD, COMP_NDOCTO, ECOM_CCOD, PERS_NCORR, " & vbcrlf & _
						" COMP_FDOCTO, COMP_NCUOTAS, COMP_MNETO, COMP_MDESCUENTO, " & vbcrlf & _
						" COMP_MINTERESES, COMP_MIVA, COMP_MEXENTO, COMP_MDOCUMENTO, AUDI_TUSUARIO, AUDI_FMODIFICACION )  " & vbcrlf & _
						" values(15,1,"&comp_ndocto_seq&",1,"&pers_ncorr&",getdate(),1,"&v_monto_examen&",0,0,0,0,"&v_monto_examen&",'"&pers_ncorr&"',getdate()) " 

'response.Write("<br><br> compromisos: "&sentencia_compromisos&"<br>")

sentencia_detalle_compromisos = " insert into detalle_compromisos " & vbcrlf & _
								" (TCOM_CCOD, INST_CCOD, COMP_NDOCTO, " & vbcrlf & _
								"  DCOM_NCOMPROMISO, DCOM_FCOMPROMISO, DCOM_MNETO, " & vbcrlf & _
								"  DCOM_MINTERESES, DCOM_MCOMPROMISO, ECOM_CCOD, " & vbcrlf & _
								"  PERS_NCORR, PERI_CCOD, AUDI_TUSUARIO, AUDI_FMODIFICACION)" & vbcrlf & _ 						
								"values (15,1,"&comp_ndocto_seq&",1,getdate(),"&v_monto_examen&",0,"&v_monto_examen&",1,"&pers_ncorr&","&peri_ccod&",'"&pers_ncorr&"',getdate())"
'"&DCOM_NCOMPROMISO_seq&" eliminado porque la el proceso de pago muere con un numero muy exesivo
'response.Write("<br><br> detalle compromisos: "&sentencia_detalle_compromisos&"<br>")

sentencia_detalle = " insert into detalles " & vbcrlf & _
								" (TCOM_CCOD, INST_CCOD, COMP_NDOCTO,TDET_CCOD, " & vbcrlf & _
								"  DETA_NCANTIDAD,DETA_MVALOR_UNITARIO, " & vbcrlf & _
								"  DETA_MVALOR_DETALLE, DETA_MSUBTOTAL, " & vbcrlf & _
								"  AUDI_TUSUARIO, AUDI_FMODIFICACION)" & vbcrlf & _ 						
								"values (15,1,"&comp_ndocto_seq&",1243,1,"&v_monto_examen&","&v_monto_examen&","&v_monto_examen&",'"&negocio2.ObtenerUsuario&"',getdate())"
'response.Write("<br><br> detalle compromisos: "&sentencia_detalle&"<br>")	

conexion.ejecutaS(sentencia_postulacion)								
'response.Write("1"&conexion.obtenerEstadoTransaccion)
conexion.ejecutaS(sentencia_compromisos)
'response.Write("1"&conexion.obtenerEstadoTransaccion)
conexion.ejecutaS(sentencia_detalle_compromisos)
'response.Write("1"&conexion.obtenerEstadoTransaccion)
conexion.ejecutaS(sentencia_detalle)
'response.Write("1"&conexion.obtenerEstadoTransaccion)

elseif (v_carrera_pagan = 0) then
	' no tiene carreras que requieran pagos
	' entonces se eliminan sus compromisos
	sql_anula_compromiso="Update compromisos Set ecom_ccod='3' "&_
						" Where tcom_ccod=15"&_
						" And ecom_ccod=1"&_
						" And pers_ncorr="&pers_ncorr
	conexion.ejecutaS(sql_anula_compromiso)					
'response.Write("<br> anula:"&sql_anula_compromiso&"<br>")
end if

'conexion.EstadoTransaccion false
'response.End()
'--------------------------------------------------------------------------------------------------------------------------------  
Response.Redirect("post_cerrada.asp")
%>

