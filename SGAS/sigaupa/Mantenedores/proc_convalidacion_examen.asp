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

post_ncorr=request.Form("post_ncorr")
cantidad=request.Form("cantidad")
total_cargo=request.Form("total_cargo")
pers_nrut=request.Form("busqueda[0][pers_nrut]")
pers_xdv=request.Form("busqueda[0][pers_xdv]")
jorn_ccod=request.Form("jorn_ccod")
carr_ccod=request.Form("a[0][carrera]")
carcon_ncorr=conexion.consultaUno("execute obtenersecuencia 'cargos_convalidacion'")
pers_ncorr=conexion.consultaUno("Select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&pers_nrut&"'")
peri_ccod=negocio.obtenerPeriodoAcademico("Postulacion")
'response.Write("carcon_ncorr "&carcon_ncorr)

consulta3=" select d.ofer_ncorr " & vbcrlf & _
		  " from  " & vbcrlf & _
		  " personas_postulante a,postulantes b,detalle_postulantes c, " & vbcrlf & _
		  " ofertas_academicas d,especialidades e,carreras f,jornadas g, " & vbcrlf & _
		  " sedes h,estado_examen_postulantes i " & vbcrlf & _
		  " where a.pers_ncorr = b.pers_ncorr " & vbcrlf & _
		  " and b.post_ncorr = c.post_ncorr " & vbcrlf & _
		  " and c.ofer_ncorr = d.ofer_ncorr " & vbcrlf & _
		  " and d.espe_ccod = e.espe_ccod " & vbcrlf & _
	  	  " and cast(e.carr_ccod as varchar)='"&carr_ccod&"'" & vbcrlf & _
		  " and e.carr_ccod = f.carr_ccod   " & vbcrlf & _
		  " and d.jorn_ccod = g.jorn_ccod " & vbcrlf & _
		  " and d.sede_ccod = h.sede_ccod " & vbcrlf & _
		  " and c.eepo_ccod = i.eepo_ccod " & vbcrlf & _
		  " and b.epos_ccod = 2 " & vbcrlf & _
		  " and b.tpos_ccod = 1 " & vbcrlf & _
		  " and  cast(b.post_ncorr as varchar)='"&post_ncorr&"'"
ofer_ncorr=conexion.consultaUno(consulta3)
'response.Write("<pre>"&consulta3&"</pre>")
set f_convalidacion = new CFormulario
f_convalidacion.Carga_Parametros "convalidacion_examen.xml", "agrega_convalidacion"
f_convalidacion.Inicializar conexion
f_convalidacion.ProcesaForm


f_convalidacion.AgregaCampoPost "post_ncorr", post_ncorr
f_convalidacion.AgregaCampoPost "carcon_ncantidad_asig", cantidad
f_convalidacion.AgregaCampoPost "carcon_total", total_cargo
f_convalidacion.AgregaCampoPost "carcon_ncorr", carcon_ncorr
f_convalidacion.AgregaCampoPost "ofer_ncorr", ofer_ncorr

comp_ndocto_seq = conexion.consultauno("exec ObtenerSecuencia 'compromisos'")

if jorn_ccod="1" then
tipo=1259
else
tipo=1260
end if
v_monto_convalidacion=total_cargo

sentencia_compromisos = " Insert into " & vbcrlf & _
						" compromisos (TCOM_CCOD, INST_CCOD, COMP_NDOCTO, ECOM_CCOD, PERS_NCORR, " & vbcrlf & _
						" COMP_FDOCTO, COMP_NCUOTAS, COMP_MNETO, COMP_MDESCUENTO, " & vbcrlf & _
						" COMP_MINTERESES, COMP_MIVA, COMP_MEXENTO, COMP_MDOCUMENTO, AUDI_TUSUARIO, AUDI_FMODIFICACION, SEDE_CCOD)  " & vbcrlf & _
						" values(35,1,"&comp_ndocto_seq&",1,"&pers_ncorr&",getdate(),1,"&v_monto_convalidacion&",0,0,0,0,"&v_monto_convalidacion&",'"&negocio.ObtenerUsuario&"',getdate(),'"&negocio.ObtenerSede&"') " 

sentencia_detalle_compromisos = " insert into detalle_compromisos " & vbcrlf & _
								" (TCOM_CCOD, INST_CCOD, COMP_NDOCTO, " & vbcrlf & _
								"  DCOM_NCOMPROMISO, DCOM_FCOMPROMISO, DCOM_MNETO, " & vbcrlf & _
								"  DCOM_MINTERESES, DCOM_MCOMPROMISO, ECOM_CCOD, " & vbcrlf & _
								"  PERS_NCORR, PERI_CCOD, AUDI_TUSUARIO, AUDI_FMODIFICACION)" & vbcrlf & _ 						
								"values (35,1,"&comp_ndocto_seq&",1,getdate(),"&v_monto_convalidacion&",0,"&v_monto_convalidacion&",1,"&pers_ncorr&","&peri_ccod&",'"&negocio.ObtenerUsuario&"',getdate())"

sentencia_detalle = " insert into detalles " & vbcrlf & _
								" (TCOM_CCOD, INST_CCOD, COMP_NDOCTO,TDET_CCOD, " & vbcrlf & _
								"  DETA_NCANTIDAD,DETA_MVALOR_UNITARIO, " & vbcrlf & _
								"  DETA_MVALOR_DETALLE, DETA_MSUBTOTAL, " & vbcrlf & _
								"  AUDI_TUSUARIO, AUDI_FMODIFICACION)" & vbcrlf & _ 						
								"values (35,1,"&comp_ndocto_seq&","&tipo&",1,"&v_monto_convalidacion&","&v_monto_convalidacion&","&v_monto_convalidacion&",'"&negocio.ObtenerUsuario&"',getdate())"
								
' No se cobra en 2013-01 según pase interno 258 - 09-10-2012 MS
'conexion.ejecutaS(sentencia_compromisos)
'conexion.ejecutaS(sentencia_detalle_compromisos)
'conexion.ejecutaS(sentencia_detalle)

f_convalidacion.MantieneTablas false

tiene_examen=conexion.consultaUno("Select count(*) from abonos where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and tcom_ccod=15")
tiene_compromiso=conexion.consultaUno("Select count(*) from compromisos where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and tcom_ccod=15")
'response.Write("abono "&tiene_examen &" compromiso "&tiene_compromiso& " pers_ncorr "&pers_ncorr)
if tiene_examen="0" and tiene_compromiso<>"0" then
sql_anula_compromiso="Update compromisos Set ecom_ccod='3' "&_
						" Where tcom_ccod=15"&_
						" And ecom_ccod=1"&_
						" And cast(sede_ccod as varchar)='"&negocio.ObtenerSede&"'"&_
						" And cast(pers_ncorr as varchar)='"&pers_ncorr&"'"
	conexion.ejecutaS(sql_anula_compromiso)
    sql_estado_examen="Update detalle_postulantes Set eepo_ccod='6' "&_
						" Where eepo_ccod=1"&_
						" And cast(post_ncorr as varchar)='"&post_ncorr&"'"
						'" and cast(ofer_ncorr as varchar)='"&ofer_ncorr&"'"
'	response.Write("<br><pre>"&sql_estado_examen&"</pre>")
conexion.ejecutaS(sql_estado_examen)	
end if
'conexion.estadotransaccion false  'roolback 
'response.End()

'---------------------------------------------------------------------------------------------------------
ruta="convalidacion_examen.asp?busqueda[0][pers_nrut]="&pers_nrut&"&busqueda[0][pers_xdv]="&pers_xdv
Response.Redirect(ruta)
%>
