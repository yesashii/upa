<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%


	'for each k in request.form
	'response.Write(k&" = "&request.Form(k)&"<br>")
	'next
'response.End()
'Session.Contents.RemoveAll()

set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar


set f_agrega = new CFormulario
f_agrega.Carga_Parametros "empresa.xml", "f_datos_empresas"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
for filai = 0 to f_agrega.CuentaPost - 1

rut= f_agrega.ObtenerValorPost (filai, "rut2")
dv= f_agrega.ObtenerValorPost (filai, "dv2")
empr_tnombre= f_agrega.ObtenerValorPost (filai, "empr_tnombre")
empr_trazon_social= f_agrega.ObtenerValorPost (filai, "empr_trazon_social")
dire_tcalle= f_agrega.ObtenerValorPost (filai, "dire_tcalle")
dire_tnro= f_agrega.ObtenerValorPost (filai, "dire_tnro")
dire_tdepto= f_agrega.ObtenerValorPost (filai, "dire_tdepto")
regi_ccod= f_agrega.ObtenerValorPost (filai, "regi_ccod")
ciud_ccod= f_agrega.ObtenerValorPost (filai, "ciud_ccod")
pais_ccod= f_agrega.ObtenerValorPost (filai, "pais_ccod")
sector= f_agrega.ObtenerValorPost (filai, "sector")
n_trabajador= f_agrega.ObtenerValorPost (filai, "n_trabajadores")
pers_contacto= f_agrega.ObtenerValorPost (filai, "pers_contacto")
cargo= f_agrega.ObtenerValorPost (filai, "cargo")
fono= f_agrega.ObtenerValorPost (filai, "fono")
fax= f_agrega.ObtenerValorPost (filai, "fax")
pers_temail= f_agrega.ObtenerValorPost (filai, "pers_temail")
daem_pers_tnombre_contacto= f_agrega.ObtenerValorPost (filai, "daem_pers_tnombre")
daem_pers_tape_paterno= f_agrega.ObtenerValorPost (filai, "daem_pers_tape_paterno")
daem_pers_tape_materno= f_agrega.ObtenerValorPost (filai, "daem_pers_tape_materno")
daem_pers_nrut_contacto= f_agrega.ObtenerValorPost (filai, "rut_contacto")
daem_pers_xdv_contacto= f_agrega.ObtenerValorPost (filai, "dv_contacto")


if fax= "" then
fax="NULL"
end if



existe=conectar.consultaUno("select case count(*) when 0 then 'N' else 'S' end from empresas where empr_nrut="&rut&"")
 
response.Write("existe "&existe&"<br>")

if existe="S" then


empre_ncorr=conectar.consultaUno("select empr_ncorr from empresas where empr_nrut="&rut&"")
daem_ncorr=conectar.ConsultaUno("exec ObtenerSecuencia 'datos_empresas'")

	insert_daem="insert into datos_empresa (daem_ncorr,empr_ncorr,daem_sector,daem_ntrabajadores,daem_pers_tnombre_contacto,daem_pers_tape_paterno,daem_pers_tape_materno,daem_pers_nrut_contacto,daem_pers_xdv_contacto,daem_cargo,daem_tpers_fono,daem_tpers_fax,daem_temail,audi_tusuario,audi_fmodificacion)"& vbCrLf &_
	"values ("&daem_ncorr&","&empre_ncorr&",'"&sector&"',"&n_trabajador&",'"&daem_pers_tnombre_contacto&"','"&daem_pers_tape_paterno&"','"&daem_pers_tape_materno&"',"&daem_pers_nrut_contacto&",'"&daem_pers_xdv_contacto&"','"&cargo&"',"&fono&","&fax&",'"&pers_temail&"','Registro Empresa CEE',getdate())"
	conectar.ejecutaS (insert_daem)
		'response.Write("<BR>"&empre_ncorr&"<BR>")
		'response.Write("<BR>"&insert_daem&"<BR>")
	empr_ncorr=conectar.consultaUno("select empr_ncorr from empresas where empr_nrut="&rut&"")	
		
	insert_user="insert into sis_usuarios (PERS_NCORR,SUSU_TLOGIN,SUSU_TCLAVE,SUSU_FMODIFICACION,AUDI_TUSUARIO,AUDI_FMODIFICACION) values("&empr_ncorr&",'"&rut&"','"&empr_ncorr&"',getdate(),'Registro Empresa CEE',getdate())"
conectar.ejecutaS (insert_user)
else
'response.Write("3")
empr_tdireccion=""&dire_tcalle&" "&dire_tnro&" "&dire_tdepto&""
empr_ncorr=conectar.ConsultaUno("exec ObtenerSecuencia 'personas'")


	insert_empre="insert into empresas (empr_ncorr,empr_tnombre,empr_trazon_social,empr_nrut,empr_xdv,empr_tdireccion,ciud_ccod,empr_tfono,empr_tfax,AUDI_TUSUARIO,AUDI_FMODIFICACION) "& vbCrLf &_
	"values ("&empr_ncorr&",'"&empr_tnombre&"','"&empr_trazon_social&"',"&rut&",'"&dv&"','"&empr_tdireccion&"',"&ciud_ccod&","&fono&","&fax&",'Registro Empresa CEE',getdate())"

daem_ncorr=conectar.ConsultaUno("exec ObtenerSecuencia 'datos_empresas'")
response.Write(daem_ncorr&"<BR>")	
	insert_daem="insert into datos_empresa (daem_ncorr,empr_ncorr,daem_sector,daem_ntrabajadores,daem_pers_tnombre_contacto,daem_pers_tape_paterno,daem_pers_tape_materno,daem_pers_nrut_contacto,daem_pers_xdv_contacto,daem_cargo,daem_tpers_fono,daem_tpers_fax,daem_temail,audi_tusuario,audi_fmodificacion)"& vbCrLf &_
	"values ("&daem_ncorr&","&empr_ncorr&",'"&sector&"',"&n_trabajador&",'"&daem_pers_tnombre_contacto&"','"&daem_pers_tape_paterno&"','"&daem_pers_tape_materno&"',"&daem_pers_nrut_contacto&",'"&daem_pers_xdv_contacto&"','"&cargo&"',"&fono&","&fax&",'"&pers_temail&"','Registro Empresa CEE',getdate())"
	

	
	
	if dire_tdepto="" then
	dire_tdepto="NULL"
	end if
	
		insert_pers="insert into personas (pers_ncorr,eciv_ccod,pais_ccod,pers_nrut,pers_xdv,pers_tnombre,pers_tape_paterno,pers_tape_materno,AUDI_TUSUARIO,AUDI_FMODIFICACION)"& vbCrLf &_
	"values ("&empr_ncorr&",1,"&pais_ccod&","&rut&",'"&dv&"','"&empr_tnombre&"','','','Registro Empresa CEE',getdate())"
	
	
			insert_pers_post="insert into personas_postulante (pers_ncorr,eciv_ccod,pais_ccod,pers_nrut,pers_xdv,pers_tnombre,pers_tape_paterno,pers_tape_materno,AUDI_TUSUARIO,AUDI_FMODIFICACION)"& vbCrLf &_
	"values ("&empr_ncorr&",1,"&pais_ccod&","&rut&",'"&dv&"','"&empr_tnombre&"','','','Registro Empresa CEE',getdate())"

	
	insert_dire="insert into direcciones (PERS_NCORR,TDIR_CCOD,CIUD_CCOD,DIRE_TCALLE,DIRE_TNRO,DIRE_TDEPTO,DIRE_TFONO,AUDI_TUSUARIO,AUDI_FMODIFICACION)"& vbCrLf &_
	"values ("&empr_ncorr&",1,"&ciud_ccod&",'"&dire_tcalle&"','"&dire_tnro&"','"&dire_tdepto&"','"&fono&"','Registro Empresa CEE',getdate())"
	
	insert_user="insert into sis_usuarios (PERS_NCORR,SUSU_TLOGIN,SUSU_TCLAVE,SUSU_FMODIFICACION,AUDI_TUSUARIO,AUDI_FMODIFICACION) values("&empr_ncorr&",'"&rut&"','"&empr_ncorr&"',getdate(),'Registro Empresa CEE',getdate())"

' 	response.Write("<BR>"&insert_empre&"<BR>")
'		response.Write("<BR>"&insert_pers&"<BR>")
'		response.Write("<BR>"&insert_pers_post&"<BR>")
'		response.Write("<BR>"&insert_daem&"<BR>")
'	response.Write("<BR>"&insert_dire&"<BR>")
'	response.Write("<BR>"&insert_user&"<BR>")
'
'response.End()	
		conectar.ejecutaS (insert_empre)
		if  conectar.ObtenerEstadoTransaccion() then
			conectar.ejecutaS (insert_daem)
		   if  conectar.ObtenerEstadoTransaccion() then 
					conectar.ejecutaS (insert_pers)
			   if  conectar.ObtenerEstadoTransaccion() then 
					 conectar.ejecutaS (insert_pers_post)
					  if  conectar.ObtenerEstadoTransaccion() then 
							conectar.ejecutaS (insert_dire)
						  if  conectar.ObtenerEstadoTransaccion() then 
								conectar.ejecutaS (insert_user)
						  else
							session("mensajeerror")= "Error5 al Guardar "	
							response.Redirect("registro_empresa.asp")
							'response.Write(insert_user)
	
						  end if
					  else
						session("mensajeerror")= "Error4 al Guardar "	
						response.Redirect(" registro_empresa.asp")
						'response.Write(insert_dire)

					  end if
				else
					session("mensajeerror")= "Error3 al Guardar "	
					response.Redirect("registro_empresa.asp")
					'response.Write(insert_pers_post)

			   end if
				  
			else
				session("mensajeerror")= "Error2 al Guardar "	
				response.Redirect("registro_empresa.asp")
				'response.Write(insert_pers)
			end if
		else
		session("mensajeerror")= "Error1 al Guardar"
		response.Redirect("registro_empresa.asp")
'			response.Write(conectar.ObtenerEstadoTransaccion()&"<br>")
'		response.Write(insert_daem)	
		end if
			




	
	
end if

next
response.Redirect("salida_registro_empresa.asp")
 %>