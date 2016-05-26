<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%
'for each k in request.querystring
'	response.Write(k&" = "&request.querystring(k)&"<br>")
'next
'response.End()
pers_nrut = request.QueryString("pers_nrut")
carr_ccod = request.QueryString("carr_ccod")
tdes_ccod = request.QueryString("tdes_ccod")
tipo = request.QueryString("tipo")
'response.Write(tdes_ccod)
set conexion = new cConexion
set negocio = new cnegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion

if esVacio(tdes_ccod) or tdes_ccod = "3" then
	resto_mensaje= ", para los fines que estime conveniente."
	tdes_ccod = "3"
elseif not esVacio(tdes_ccod) and (tdes_ccod = "5" or tdes_ccod = "1" or tdes_ccod = "4" or tdes_ccod = "9" or tdes_ccod = "10" or tdes_ccod = "11" or tdes_ccod = "12" or tdes_ccod = "13") then
	motivo = conexion.consultaUno("select protic.initcap(tdes_tdesc) from tipos_descripciones where cast(tdes_ccod as varchar)='"&tdes_ccod&"'")
	resto_mensaje= " a petici&oacute;n del (la) interesado(a) para solicitar "&motivo&"."
elseif not esVacio(tdes_ccod) and (tdes_ccod = "6" or tdes_ccod = "7" or tdes_ccod = "8" or tdes_ccod = "14" or tdes_ccod = "16" or tdes_ccod = "18") then
	motivo = conexion.consultaUno("select protic.initcap(tdes_tdesc) from tipos_descripciones where cast(tdes_ccod as varchar)='"&tdes_ccod&"'")
	resto_mensaje= " a petici&oacute;n del (la) interesado(a) para ser presentado en "&motivo&"."
elseif not esVacio(tdes_ccod) and tdes_ccod = "2" then
	resto_mensaje= " a petici&oacute;n del (la) interesado(a) para ser presentado en Cant&oacute;n de Reclutamiento."
elseif not esVacio(tdes_ccod) and (tdes_ccod = "15" or tdes_ccod = "17")then
	motivo = conexion.consultaUno("select protic.initcap(tdes_tdesc) from tipos_descripciones where cast(tdes_ccod as varchar)='"&tdes_ccod&"'")
	resto_mensaje= " a petici&oacute;n del (la) interesado(a) para "&motivo&"."	
end if


if esVacio(carr_ccod) then
consulta_carrera= " select top 1 d.carr_ccod from personas a, alumnos b, ofertas_academicas c, especialidades d " & vbCrLf &_
		  " where cast(a.pers_nrut as varchar)='"&pers_nrut&"' " & vbCrLf &_
		  " and a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
		  " and b.ofer_ncorr=c.ofer_ncorr " & vbCrLf &_
		  " and c.espe_ccod=d.espe_ccod " & vbCrLf &_
		  " order by peri_ccod desc"
carr_ccod = conexion.consultaUno(consulta_carrera)
end if

consulta= " select top 1 e.jorn_ccod from personas a, alumnos b, ofertas_academicas c, especialidades d,jornadas e " & vbCrLf &_
		  " where cast(a.pers_nrut as varchar)='"&pers_nrut&"' " & vbCrLf &_
		  " and a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
		  " and b.ofer_ncorr=c.ofer_ncorr " & vbCrLf &_
		  " and c.espe_ccod=d.espe_ccod " & vbCrLf &_
		  " and c.jorn_ccod=e.jorn_ccod " & vbCrLf &_
		  " and cast(d.carr_ccod as varchar)='"&carr_ccod&"' " & vbCrLf &_
		  " order by peri_ccod desc"


consulta_sede= " select top 1 e.sede_ccod from personas a, alumnos b, ofertas_academicas c, especialidades d,sedes e " & vbCrLf &_
		  " where cast(a.pers_nrut as varchar)='"&pers_nrut&"' " & vbCrLf &_
		  " and a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
		  " and b.ofer_ncorr=c.ofer_ncorr " & vbCrLf &_
		  " and c.espe_ccod=d.espe_ccod " & vbCrLf &_
		  " and c.sede_ccod=e.sede_ccod " & vbCrLf &_
		  " and cast(d.carr_ccod as varchar)='"&carr_ccod&"' " & vbCrLf &_
		  " order by peri_ccod desc"

jornada = conexion.consultaUno(consulta)
nombre_sede = conexion.consultaUno(consulta_sede)
pers_ncorr= conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'")

if tipo = "3" then 
	tipo_certificado = "Certificado de título"
elseif tipo = "4" then 
	tipo_certificado = "Certificado de grado académico"
elseif tipo = "5" then 
	tipo_certificado = "Certificado de título técnico"		
elseif tipo = "6" then 
	tipo_certificado = "Certificado de salida_intermedia"
elseif tipo = "7" then 
	tipo_certificado = "Certificado por mención"
elseif tipo = "8" then 
	tipo_certificado = "Certificado por minors"
elseif tipo = "1" then 
	tipo_certificado = "Certificado Con. Notas titulado"				
end if

correlativo = conexion.consultaUno("execute obtenerSecuencia 'certificados_emitidos'")
if tipo <> "4" then 
consulta_insert = "insert into certificados_emitidos (cert_ncorr,pers_ncorr,carr_ccod,jorn_ccod,sede_ccod,cert_tipo,cert_motivo_ccod,cert_motivo,cert_fecha,audi_tusuario,audi_fmodificacion)"&_
				  " values ("&correlativo&","&pers_ncorr&",'"&carr_ccod&"',"&jornada&","&nombre_sede&",'"&tipo_certificado&"',"&tdes_ccod&", '"&resto_mensaje&"',getDate(),'"&negocio.obtenerUsuario&"',getDate())"
else
c_grado = " select grado_academico from salidas_alumnos a, personas b, licenciaturas_carrera c " & vbCrLf &_
		  " where tiene_licenciatura ='S' " & vbCrLf &_
		  " and a.pers_ncorr=b.pers_ncorr and a.cod_registro =c.cod_registro  " & vbCrLf &_
		  " and cast(b.pers_nrut as varchar)='"&pers_nrut&"'"
grado = conexion.consultaUno(c_grado)
consulta_insert = "insert into certificados_emitidos (cert_ncorr,pers_ncorr,carr_ccod,jorn_ccod,sede_ccod,cert_tipo,cert_motivo_ccod,cert_motivo,cert_fecha,audi_tusuario,audi_fmodificacion,grado)"&_
				  " values ("&correlativo&","&pers_ncorr&",'"&carr_ccod&"',"&jornada&","&nombre_sede&",'"&tipo_certificado&"',null, null,getDate(),'"&negocio.obtenerUsuario&"',getDate(),'"&grado&"')"
end if
'response.Write(consulta_insert)
'response.End()
conexion.ejecutaS(consulta_insert)
if conexion.ObtenerEstadoTransaccion then
	conexion.MensajeError "Se ha guardado correctamente la solicitud de certificado."
else
	conexion.MensajeError "Ha ocurrido un error al tratar de guardar el certificado."	
end if
'if tipo <> "1" then
'	response.Redirect(request.ServerVariables("HTTP_REFERER"))
'end if
%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>

