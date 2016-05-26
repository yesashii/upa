<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%

'for each k in request.Form()
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

on error resume next
set conexion = new cConexion
conexion.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'recolectamos los datos enviados por post desde la pantalla anterior
pers_ncorr=request.Form("p[0][pers_ncorr]")
asig_ccod=request.Form("p[0][asig_ccod]")
mall_ccod=request.Form("p[0][mall_ccod]")
peri_ccod=request.Form("m[0][peri_ccod]")
nota=request.Form("m[0][carg_nnota_final]")
sitf_ccod=request.Form("m[0][sitf_ccod]")

'if nota = "" or esVacio(nota) then 
'	response.Write("nula")
'else
	'response.Write("no nula")
'end if

'response.End()	
'response.Write("select matr_ncorr from alumnos a, ofertas_academicas b where cast(a.pers_ncorr)='"&pers_ncorr&"' and cast(peri_ccod as varchar)='"&peri_ccod&"' and emat_ccod in (1,2,4,8,10,13) ")

carr_ccod = conexion.consultaUno("select carr_ccod from malla_curricular a, planes_estudio b, especialidades c where cast(a.mall_ccod as varchar)='"&mall_ccod&"' and a.plan_ccod=b.plan_ccod and b.espe_ccod = c.espe_ccod")
matr_ncorr = conexion.consultaUno("select matr_ncorr from alumnos a, ofertas_academicas b where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and cast(peri_ccod as varchar)='"&peri_ccod&"' and emat_ccod in (1,2,4,8,10,13) ")
jorn_ccod = conexion.consultaUno("select jorn_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr")
sede_ccod = conexion.consultaUno("select sede_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr")

tiene_seccion = conexion.consultaUno("Select count(*) from secciones where carr_ccod='"&carr_ccod&"' and asig_ccod='"&asig_ccod&"' and cast(mall_ccod as varchar)='"&mall_ccod&"' and cast(peri_ccod as varchar)='"&peri_ccod&"'")

if tiene_seccion = "0" then
	secc_ccod = conexion.ConsultaUno("exec ObtenerSecuencia 'secciones'")
    crear_seccion = "insert into secciones (secc_ccod, sede_ccod, carr_ccod, jorn_ccod, asig_ccod, mall_ccod, peri_ccod, audi_tusuario, audi_fmodificacion)"&_
	                "values ("&secc_ccod&","&sede_ccod&",'"&carr_ccod&"',"&jorn_ccod&",'"&asig_ccod&"',"&mall_ccod&","&peri_ccod&",'Agregado por MTMErino(Notas New)',getDate())"

    conexion.ejecutaS crear_seccion
   'response.Write(crear_seccion)
end if

secc_ccod = conexion.consultaUno("Select secc_ccod from secciones where carr_ccod='"&carr_ccod&"' and asig_ccod='"&asig_ccod&"' and cast(mall_ccod as varchar)='"&mall_ccod&"' and cast(peri_ccod as varchar)='"&peri_ccod&"' ")

'--------------------------------------------------------------------
usuario_temp =  "("&negocio.obtenerusuario&") x subida Notas"

'inserta_nota = " insert into cargas_academicas (matr_ncorr, secc_ccod,sitf_ccod,carg_nnota_final,audi_tusuario, audi_fmodificacion) " & vbCrLf &_
'                     " select " & matr_ncorr & "," & secc_ccod & ",'"&sitf_ccod&"',"&nota&",'" & usuario_temp & "', getDate()  " & vbCrLf &_
'				     " where not exists (select 1 from cargas_academicas a2 where cast(a2.matr_ncorr as varchar)= '" & matr_ncorr & "' and cast(secc_ccod as varchar) = '" & secc_ccod & "')"

if nota = "" or esVacio(nota) then 
	inserta_nota = " insert into cargas_academicas (matr_ncorr, secc_ccod,sitf_ccod,carg_nnota_final,audi_tusuario, audi_fmodificacion) " & vbCrLf &_
                     " select " & matr_ncorr & "," & secc_ccod & ",'"&sitf_ccod&"',null,'" & usuario_temp & "', getDate()  " & vbCrLf &_
				     " where not exists (select 1 from cargas_academicas a2 where cast(a2.matr_ncorr as varchar)= '" & matr_ncorr & "' and cast(secc_ccod as varchar) = '" & secc_ccod & "')"
else
	inserta_nota = " insert into cargas_academicas (matr_ncorr, secc_ccod,sitf_ccod,carg_nnota_final,audi_tusuario, audi_fmodificacion) " & vbCrLf &_
                     " select " & matr_ncorr & "," & secc_ccod & ",'"&sitf_ccod&"',"&nota&",'" & usuario_temp & "', getDate()  " & vbCrLf &_
				     " where not exists (select 1 from cargas_academicas a2 where cast(a2.matr_ncorr as varchar)= '" & matr_ncorr & "' and cast(secc_ccod as varchar) = '" & secc_ccod & "')"
end if

conexion.ejecutaS inserta_nota
'response.Write(inserta_nota)
'------------------------------------------------------------------------------------------------------------------------
if conexion.obtenerEstadoTransaccion then	
	conexion.MensajeError "Se ha guardado correctamente la calificación del alumno."
else
	conexion.MensajeError "Se han producido errores en el ingreso de la calificación"
end if
'------------------------------------------------------------------------------------------------------------------------
'conexion.estadoTransaccion false
'response.End()

%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>
