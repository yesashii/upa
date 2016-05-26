<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
for each k in request.QueryString
	response.Write(k&" = "&request.QueryString(k)&"<br>")
next
'response.End()
'---------------------------------------------

pers_nrut	= request.QueryString("pers_nrut")
pers_xdv	= request.QueryString("pers_xdv")
pers_temail	= request.QueryString("pers_temail")
PERS_NCORR	= request.QueryString("PERS_NCORR")


set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar


rut_usuario = negocio.ObtenerUsuario

existerolesusuario = conectar.ConsultaUno("select COUNT(*) from sis_roles_usuarios WHERE PERS_NCORR="&PERS_NCORR&" AND SROL_NCORR = 5")

sq_clave = "select" & vbCrLf &_
"replace(replace(replace(replace(replace(replace(replace(substring(pers_tnombre,1,1),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N'),' ','') + " & vbCrLf &_
"replace(replace(replace(replace(replace(replace(replace(substring(pers_tape_paterno,1,1),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N'),' ','') + " & vbCrLf &_
"replace(replace(replace(replace(replace(replace(replace(substring(pers_tape_materno,1,1),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N'),' ','') + " & vbCrLf &_
"case when pers_ncorr < 100 then substring(cast(pers_nrut as varchar) , len(pers_nrut)-3,4)"& vbCrLf &_ 
"else substring(cast(pers_ncorr as varchar) , " & vbCrLf &_
"len(pers_ncorr)-3,4) end as clave " & vbCrLf &_
" from personas  " & vbCrLf &_
" where pers_ncorr = " &PERS_NCORR
obtieneclave=conectar.ConsultaUno(sq_clave)

'response.Write sq_clave

existeusuario = conectar.ConsultaUno("select COUNT(*) from sis_usuarios WHERE PERS_NCORR="&PERS_NCORR)
consultaCorreo = conectar.ConsultaUno("select isnull(PERS_TEMAIL, '0') AS PERS_TEMAIL from personas WHERE PERS_NCORR="&PERS_NCORR)
response.Write consultaCorreo &" <> "& pers_temail & "<br>"


if consultaCorreo <> pers_temail  then 

	response.write pers_temail & "<-----<br>"
	cambiocorreo="UPDATE personas SET PERS_TEMAIL='"&pers_temail&"', AUDI_TUSUARIO='" & rut_usuario &"', AUDI_FMODIFICACION=GETDATE() WHERE PERS_NCORR="&PERS_NCORR
	''response.Write(cambiocorreo)

	conectar.EjecutaS(cambiocorreo)
	
	'response.End()
end if  

if existeusuario = "0" then

	'response.Redirect("http://www.upacifico.cl/super_test/motor_envia_aviso_apoderado.php?pers_nrut="&pers_nrut&"&pers_xdv="&pers_xdv&"&PERS_TEMAIL="&PERS_TEMAIL&"&obtieneclave="&obtieneclave&"")
	
	sql1 = "insert into sis_usuarios(PERS_NCORR,SUSU_TLOGIN,SUSU_TCLAVE,SUSU_FMODIFICACION,AUDI_TUSUARIO,AUDI_FMODIFICACION,"& vbCrLf &_ 
	"actualizado_por) values "& vbCrLf &_ 
	"('"&PERS_NCORR&"','"&pers_nrut&"-"&pers_xdv&"','"&obtieneclave&"',getdate(),'apoderado',getdate(),"& vbCrLf &_ 
	"'"&rut_usuario&"')"
	
	''  DESCOMENTAR AL PASAR SEGURIDAD
	''sql1 = "insert into sis_usuarios(PERS_NCORR,SUSU_TLOGIN,SUSU_TCLAVE,SUSU_FMODIFICACION,AUDI_TUSUARIO,AUDI_FMODIFICACION,"& vbCrLf &_ 
	''"actualizado_por,susu_tclave_Encriptada,pregunta,respuesta,termino_vigencia,vigencia,indefinido,inicio_vigencia) values "& vbCrLf &_ 
	''"('"&PERS_NCORR&"','"&pers_nrut&"-"&pers_xdv&"','"&obtieneclave&"',getdate(),'apoderado',getdate(),"& vbCrLf &_ 
	''"'"&rut_usuario&"',ENCRYPTBYPASSPHRASE('UpAsGa','"&obtieneclave&"'),'"&PERS_NCORR&"', "& vbCrLf &_ 
	''"ENCRYPTBYPASSPHRASE('UpAsGa','"&PERS_NCORR&"'),GETDATE(),1,1,getdate())"
	
	
	
	''response.write sql1
	conectar.EjecutaS(sql1)
	'response.write sql1
	'response.end()
	
end if
	'response.end()
if existerolesusuario =0 then

	sql2="insert into sis_roles_usuarios (PERS_NCORR, SROL_NCORR, SRUS_FMODIFICACION, AUDI_TUSUARIO, AUDI_FMODIFICACION) values ("&PERS_NCORR&",5,getdate(),'"&rut_usuario&"',getdate())"
	
	''  DESMARCAR AL PASAR SEGURIDAD
	''sql2="insert into sis_roles_usuarios (PERS_NCORR, SROL_NCORR, SRUS_FMODIFICACION, AUDI_TUSUARIO, AUDI_FMODIFICACION, indefinido) values ("&PERS_NCORR&",5,getdate(),'"&rut_usuario&"',getdate(),1)"
	
	conectar.EjecutaS(sql2)
	'session("mensaje_error") = "Se Realizo el Cambio con Exito"

end if

	session("mensaje_error") = "Se Realizo el Cambio con Exito"




	'response.redirect("http://admision.upacifico.cl/postulacion/www/proc_envio_clave_apoderado.php?obtieneclave="+obtieneclave+"&pers_nrut="+pers_nrut+"&pers_xdv="+pers_xdv+"&pers_temail="+PERS_TEMAIL)

	'response.write sql2
	'sql0 = "select isnull(PERS_TEMAIL, '0') AS PERS_TEMAIL from personas WHERE PERS_NCORR="&PERS_NCORR
	'response.write "<br>ULTIMO SELECT -->" & sql0 & " "& conectar.ConsultaUno(sql0)
	''response.End()

%>
<script language = "javascript" src = "../biblioteca/funciones.js" ></script>
<script language="javascript">
	var obtieneclave = "<% =obtieneclave %>";
	var pers_nrut = "<% =pers_nrut %>";
	var pers_xdv = "<% =pers_xdv %>";
	var pers_temail = "<% =pers_temail %>";
	url = "http://admision.upacifico.cl/postulacion/www/proc_envio_clave_apoderado.php?obtieneclave="+obtieneclave+"&pers_nrut="+pers_nrut+"&pers_xdv="+pers_xdv+"&pers_temail="+pers_temail;
	//alert(url)
	window.open(url);
	CerrarActualizar();
</script>

