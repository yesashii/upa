<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- '#include file="../biblioteca/_conexion_cpp.asp" -->
<!-- #include file="../biblioteca/_negocio.asp" -->

<%
nueva_secc_ccod=request.Form("d[0][secc_ccod]")
cantidad_transferible=request.Form("cantidad_transferible")
'for each k in request.Form()
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next


carr_ccod = request.form("a[0][carr_ccod]")
espe_ccod = request.form("a[0][espe_ccod]")
plan_ccod= request.form("a[0][plan_ccod]")
peri_ccod = request.form("a[0][peri_ccod]")
emat_ccod= request.form("a[0][emat_ccod]")
pers_nrut= request.form("pers_nrut")

set conectar = new cconexion
conectar.inicializar "upacifico"

set formulario = new cformulario

'set conectar_cpp = new cconexion2
'conectar_cpp.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

pers_ncorr = conectar.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'")
ano_ingreso=conectar.consultaUno("select protic.ano_ingreso_carrera_egresados("&pers_ncorr&",'"&carr_ccod&"')")

consulta_ultimo_periodo = " select max(peri_ccod) " & vbCrLf & _
						  " from alumnos a, ofertas_academicas b " & vbCrLf & _
						  " where a.ofer_ncorr=b.ofer_ncorr " & vbCrLf & _
						  " and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'" & vbCrLf & _
						  " and cast(b.espe_ccod as varchar)='"&espe_ccod&"'"
ultimo_periodo = conectar.consultaUno(consulta_ultimo_periodo)

consulta_sede = " select sede_ccod " & vbCrLf & _
						  " from alumnos a, ofertas_academicas b " & vbCrLf & _
						  " where a.ofer_ncorr=b.ofer_ncorr " & vbCrLf & _
						  " and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'" & vbCrLf & _
						  " and cast(b.espe_ccod as varchar)='"&espe_ccod&"'"& vbCrLf & _
						  " and cast(b.peri_ccod as varchar)='"&ultimo_periodo&"'"
sede_ccod = conectar.consultaUno(consulta_sede)

consulta_jornada = " select jorn_ccod " & vbCrLf & _
						  " from alumnos a, ofertas_academicas b " & vbCrLf & _
						  " where a.ofer_ncorr=b.ofer_ncorr " & vbCrLf & _
						  " and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'" & vbCrLf & _
						  " and cast(b.espe_ccod as varchar)='"&espe_ccod&"'"& vbCrLf & _
						  " and cast(b.peri_ccod as varchar)='"&ultimo_periodo&"'"
jorn_ccod = conectar.consultaUno(consulta_jornada)

consulta_postulacion = " select post_ncorr " & vbCrLf & _
						  " from alumnos a, ofertas_academicas b " & vbCrLf & _
						  " where a.ofer_ncorr=b.ofer_ncorr " & vbCrLf & _
						  " and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'" & vbCrLf & _
						  " and cast(b.espe_ccod as varchar)='"&espe_ccod&"'"& vbCrLf & _
						  " and cast(b.peri_ccod as varchar)='"&ultimo_periodo&"'"
ultimo_post = conectar.consultaUno(consulta_postulacion)

ofer_ncorr = conectar.consultauno("execute obtenersecuencia 'ofertas_academicas'")
aran_ncorr = conectar.consultauno("execute obtenersecuencia 'aranceles'")
post_ncorr = conectar.consultauno("execute obtenersecuencia 'postulantes'")
matr_ncorr = conectar.consultauno("execute obtenersecuencia 'alumnos'")

audi_tusuario = "ajuste matricula "&negocio.obtenerUsuario

c_oferta = "insert into ofertas_academicas (OFER_NCORR,SEDE_CCOD,PERI_CCOD,ESPE_CCOD,JORN_CCOD,POST_BNUEVO,ARAN_NCORR,OFER_NVACANTES,OFER_NQUORUM,OFER_BPAGA_EXAMEN,AUDI_TUSUARIO,AUDI_FMODIFICACION,OFER_BPUBLICA,OFER_BACTIVA)"&_
           "values ("&ofer_ncorr&","&sede_ccod&","&peri_ccod&",'"&espe_ccod&"',"&jorn_ccod&",'N',"&aran_ncorr&",100,1,'N','"&audi_tusuario&"',getDate(),'N','N')"   

c_aranceles = "insert into aranceles (ARAN_NCORR,MONE_CCOD,OFER_NCORR,ARAN_TDESC,ARAN_MMATRICULA,ARAN_MCOLEGIATURA,ARAN_NANO_INGRESO,AUDI_TUSUARIO,AUDI_FMODIFICACION,sede_ccod,espe_ccod,carr_ccod,peri_ccod,jorn_ccod,aran_cvigente_fup)"&_
              "values ("&aran_ncorr&",1,"&ofer_ncorr&",'ajuste matricula histórica',0,0,"&ano_ingreso&",'"&audi_tusuario&"',getDate(),"&sede_ccod&",'"&espe_ccod&"','"&carr_ccod&"',"&peri_ccod&","&jorn_ccod&",'N')"
			  
c_postulacion = " insert into postulantes (POST_NCORR,PERS_NCORR,EPOS_CCOD,TPOS_CCOD,PERI_CCOD,POST_BNUEVO,OCUP_CCOD,OFER_NCORR,POST_FPOSTULACION,TPAD_CCOD,POST_NPAA_VERBAL,POST_NPAA_MATEMATICAS,POST_NANO_PAA,IESU_CCOD,POST_TINSTITUCION_ANTERIOR,TIES_CCOD,POST_TTIPO_INSTITUCION_ANT,POST_TCARRERA_ANTERIOR,POST_NSEM_CURSADOS,POST_NSEM_APROBADOS,POST_NANO_INICIO_EST_ANT,POST_NANO_TERMINO_EST_ANT,POST_BTITULADO,POST_TTITULO_OBTENIDO,POST_BREQUIERE_EXAMEN,POST_NNOTA_EXAMEN,POST_BPASE_ESCOLAR,POST_TOTRO_COLEGIO,POST_NCORR_CODEUDOR,TBEN_CCOD1,TBEN_CCOD2,POST_BTRABAJA,POST_NINICIO,POST_BRECONOCIMIENTO_ESTUDIOS,POST_TOTRAS_ACTIVIDADES,AUDI_TUSUARIO,AUDI_FMODIFICACION,POST_BPAGA,POST_NCORRELATIVO)"&_
                " select "&post_ncorr&" as post_ncorr,pers_ncorr,2 as epos_ccod,tpos_ccod,"&peri_ccod&" as peri_ccod,'N' as post_bnuevo,ocup_ccod,"&ofer_ncorr&" as ofer_ncorr,post_fpostulacion,tpad_ccod,post_npaa_verbal,post_npaa_matematicas,post_nano_paa,iesu_ccod,"&_
                " post_tinstitucion_anterior,ties_ccod,post_ttipo_institucion_ant,post_tcarrera_anterior,post_nsem_cursados,post_nsem_aprobados,post_nano_inicio_est_ant,post_nano_termino_est_ant, "&_
                " post_btitulado,post_ttitulo_obtenido,post_brequiere_examen,post_nnota_examen,post_bpase_escolar,post_totro_colegio,post_ncorr_codeudor,tben_ccod1,tben_ccod2,post_btrabaja,post_ninicio,"&_
                " post_breconocimiento_estudios,post_totras_Actividades,'"&audi_tusuario&"' as audi_tusuario,getDate() as audi_fmodificacion,post_bpaga,post_ncorrelativo "&_
                " from postulantes where cast(post_ncorr as varchar)= '"&ultimo_post&"'"

c_detalle_postulacion = "insert into detalle_postulantes (post_ncorr,ofer_ncorr,audi_tusuario,audi_fmodificacion,dpos_tobservacion,eepo_ccod,dpos_ncalificacion,dpos_fexamen)"&_
 			          	" values("&post_ncorr&","&ofer_ncorr&",'"&audi_tusuario&"',getDate(),'ajuste matrícula histórica',5,NULL,NULL)"


c_grupo_familiar = " insert into grupo_familiar (post_ncorr,pers_ncorr,pare_ccod,audi_tusuario,audi_fmodificacion,grup_nindependiente) "&_
            	   " select "&post_ncorr&" as post_ncorr,pers_ncorr,pare_ccod,'"&audi_tusuario&"' as audi_tusuario,getDate() as audi_fmodificacion,null "&_
            	   " from grupo_familiar where cast(post_ncorr as varchar)= '"&ultimo_post&"'"
			
c_codeudor_postulacion = "insert into codeudor_postulacion (post_ncorr,pers_ncorr,pare_ccod,audi_tusuario,audi_fmodificacion)"&_
                         " select "&post_ncorr&" as post_ncorr,pers_ncorr,pare_ccod,'"&audi_tusuario&"' as audi_tusuario,getDate() as audi_fmodificacion"&_
                         " from codeudor_postulacion where cast(post_ncorr as varchar) = '"&ultimo_post&"'"			
			

c_alumnos = "insert into alumnos (MATR_NCORR,EMAT_CCOD,POST_NCORR,OFER_NCORR,PERS_NCORR,PLAN_CCOD,ALUM_NMATRICULA,ALUM_FMATRICULA,AUDI_TUSUARIO,AUDI_FMODIFICACION,ETCA_CCOD,TALU_CCOD,EMAT_CCOD_PEEC,ALUM_TRABAJADOR,ESTADO_CIERRE_CCOD)"&_			
            "values ("&matr_ncorr&","&emat_ccod&","&post_ncorr&","&ofer_ncorr&","&pers_ncorr&","&plan_ccod&",7777,getDate(),'"&audi_tusuario&"',getDate(),2,1,Null,Null,Null)"



conectar.ejecutaS c_oferta 
conectar.ejecutaS c_aranceles
conectar.ejecutaS c_postulacion 
conectar.ejecutaS c_detalle_postulacion
conectar.ejecutaS c_grupo_familiar 
conectar.ejecutaS c_codeudor_postulacion 
conectar.ejecutaS c_alumnos 

'conectar_cpp.ejecutaS c_oferta 
'conectar_cpp.ejecutaS c_aranceles
'conectar_cpp.ejecutaS c_postulacion 
'conectar_cpp.ejecutaS c_detalle_postulacion
'conectar_cpp.ejecutaS c_grupo_familiar 
'conectar_cpp.ejecutaS c_codeudor_postulacion 
'conectar_cpp.ejecutaS c_alumnos 

'response.Write("<br>"&c_oferta)
'response.Write("<br>"&c_aranceles)
'response.Write("<br>"&c_postulacion) 
'response.Write("<br>"&c_detalle_postulacion)
'response.Write("<br>"&c_grupo_familiar) 
'response.Write("<br>"&c_codeudor_postulacion) 
'response.Write("<br>"&c_alumnos) 			  
'response.End()
'response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
 CerrarActualizar();
</script>