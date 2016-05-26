<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'---------------------------------------------------------------------------------------------------

'Response.AddHeader "Content-Disposition", "attachment;filename=reporte_grl.txt"
'Response.ContentType = "text/plain;charset=UTF-8"
Server.ScriptTimeOut = 1500000
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion


set formulario_grl = new CFormulario
formulario_grl.carga_parametros "tabla_vacia.xml", "tabla"
formulario_grl.Inicializar conexion
consulta_grl =  "select distinct f.pers_ncorr, f.pers_nrut, cast(f.pers_nrut as varchar)+'-'+f.pers_xdv as rut,  "& vbCrLf &_
				" isnull(f.pers_tnombre,' ') as nombre, isnull(f.pers_tape_paterno,' ') as ap_paterno, isnull(f.pers_tape_materno,' ') as ap_materno,  "& vbCrLf &_  
				" (select top 1 replace(replace(replace(replace(replace(replace(replace(lower(email_upa),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N'),' ','') from sd_cuentas_email_totales tt where tt.rut=f.pers_nrut) as email_antiguo,  "& vbCrLf &_   
				" replace(replace(replace(replace(replace(replace(replace(substring(f.pers_tnombre,1,1),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N'),' ','') +    "& vbCrLf &_
				" replace(replace(replace(replace(replace(replace(replace(substring(f.pers_tape_paterno,1,1),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N'),' ','') +  "& vbCrLf &_
				" replace(replace(replace(replace(replace(replace(replace(substring(f.pers_tape_materno,1,1),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N'),' ','') +     "& vbCrLf &_
				" case when f.pers_ncorr < 100 then substring(cast(f.pers_nrut as varchar) , len(f.pers_nrut)-3,4)   "& vbCrLf &_
				"  else substring(cast(f.pers_ncorr as varchar) , len(f.pers_ncorr)-3,4) end as clave     "& vbCrLf &_
				" from datos_generales_secciones_otec d,ofertas_otec e, personas f, postulacion_otec g  "& vbCrLf &_
				" where d.dgso_ncorr=e.dgso_ncorr  "& vbCrLf &_ 
				" and d.dgso_ncorr=g.dgso_ncorr  "& vbCrLf &_
			    " and g.pers_ncorr = f.pers_ncorr   "& vbCrLf &_
				" and anio_admision = 2012   "& vbCrLf &_ 
				" and g.epot_ccod = 4  "& vbCrLf &_ 
				" and not exists (select 1 from cuentas_email_upa tt  "& vbCrLf &_
				"                 where tt.pers_ncorr=f.pers_ncorr) "

formulario_grl.Consultar consulta_grl 
total_1 = formulario_grl.nroFilas
if total_1 > 0 then
    total_creados = 0
	while formulario_grl.siguiente
		pers_ncorr		= formulario_grl.obtenerValor("pers_ncorr")
		pers_nrut  		= formulario_grl.obtenerValor("pers_nrut")
		rut		  		= formulario_grl.obtenerValor("rut")
		email_antiguo   = formulario_grl.obtenerValor("email_antiguo")
		nombre          = formulario_grl.obtenerValor("nombre")
		ap_paterno      = formulario_grl.obtenerValor("ap_paterno")
		ap_materno      = formulario_grl.obtenerValor("ap_materno")
		clave           = formulario_grl.obtenerValor("clave")
        
        c_email_nuevo =  "  select replace(replace(replace(replace(replace(replace(SUBSTRING(ltrim(rtrim(pers_tnombre)), 1,1),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N') +  "& vbCrLf &_
						 "	replace(replace(replace(replace(replace(replace(replace(replace(substring(ltrim(rtrim(pers_tape_paterno)),1,15),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N'),' ',''),'-','') + "& vbCrLf &_
						 "	ltrim(rtrim(replace(replace(replace(replace(replace(replace(SUBSTRING(ltrim(rtrim(pers_tape_materno)),1,1),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N'))) +  "& vbCrLf &_
						 "	+'@ALUMNOS.UPACIFICO.CL' as email_upa "& vbCrLf &_
						 "  from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'"
		email_nuevo = conexion.consultaUno(c_email_nuevo)
		ya_registrado = conexion.consultaUno("select case count(*) when 0 then 'NO' else 'SI' end from cuentas_email_upa where email_nuevo='"&email_nuevo&"' and rut <> '"&rut&"'")
		if ya_registrado = "SI" then
			c_email_nuevo =  "  select replace(replace(replace(replace(replace(replace(SUBSTRING(ltrim(rtrim(pers_tnombre)), 1,1),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N') +  "& vbCrLf &_
							 "	replace(replace(replace(replace(replace(replace(replace(replace(substring(ltrim(rtrim(pers_tape_paterno)),1,15),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N'),' ',''),'-','') + "& vbCrLf &_
							 "	ltrim(rtrim(replace(replace(replace(replace(replace(replace(SUBSTRING(ltrim(rtrim(pers_tape_materno)),1,2),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N'))) +  "& vbCrLf &_
							 "	+'@ALUMNOS.UPACIFICO.CL' as email_upa "& vbCrLf &_
							 "  from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'"
			email_nuevo = conexion.consultaUno(c_email_nuevo)'busca el email con 2 caracteres en apellido materno
			ya_registrado2 = conexion.consultaUno("select case count(*) when 0 then 'NO' else 'SI' end from cuentas_email_upa where email_nuevo='"&email_nuevo&"' and rut <> '"&rut&"'")
			if ya_registrado2 = "SI" then
				c_email_nuevo =  "  select replace(replace(replace(replace(replace(replace(SUBSTRING(ltrim(rtrim(pers_tnombre)), 1,1),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N') +  "& vbCrLf &_
								 "	replace(replace(replace(replace(replace(replace(replace(replace(substring(ltrim(rtrim(pers_tape_paterno)),1,15),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N'),' ',''),'-','') + "& vbCrLf &_
								 "	ltrim(rtrim(replace(replace(replace(replace(replace(replace(SUBSTRING(ltrim(rtrim(pers_tape_materno)),1,3),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N'))) +  "& vbCrLf &_
								 "	+'@ALUMNOS.UPACIFICO.CL' as email_upa "& vbCrLf &_
								 "  from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'"
				email_nuevo = conexion.consultaUno(c_email_nuevo)'busca el email con 3 caracteres en apellido materno
				ya_registrado3 = conexion.consultaUno("select case count(*) when 0 then 'NO' else 'SI' end from cuentas_email_upa where email_nuevo='"&email_nuevo&"' and rut <> '"&rut&"'")
				if ya_registrado3 = "SI" then
					c_email_nuevo =  "  select replace(replace(replace(replace(replace(replace(SUBSTRING(ltrim(rtrim(pers_tnombre)), 1,1),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N') +  "& vbCrLf &_
									 "	replace(replace(replace(replace(replace(replace(replace(replace(substring(ltrim(rtrim(pers_tape_paterno)),1,15),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N'),' ',''),'-','') + "& vbCrLf &_
									 "	ltrim(rtrim(replace(replace(replace(replace(replace(replace(SUBSTRING(ltrim(rtrim(pers_tape_materno)),1,3),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N'))) +  "& vbCrLf &_
									 "	+'W@ALUMNOS.UPACIFICO.CL' as email_upa "& vbCrLf &_
									 "  from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'"
					email_nuevo = conexion.consultaUno(c_email_nuevo)'busca el email con 3 caracteres en apellido materno seguido de una "W"
					ya_registradoW = conexion.consultaUno("select case count(*) when 0 then 'NO' else 'SI' end from cuentas_email_upa where email_nuevo='"&email_nuevo&"' and rut <> '"&rut&"'")
					if ya_registradoW = "SI" then
						c_email_nuevo =  "  select replace(replace(replace(replace(replace(replace(SUBSTRING(ltrim(rtrim(pers_tnombre)), 1,1),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N') +  "& vbCrLf &_
										 "	replace(replace(replace(replace(replace(replace(replace(replace(substring(ltrim(rtrim(pers_tape_paterno)),1,15),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N'),' ',''),'-','') + "& vbCrLf &_
										 "	ltrim(rtrim(replace(replace(replace(replace(replace(replace(SUBSTRING(ltrim(rtrim(pers_tape_materno)),1,3),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N'))) +  "& vbCrLf &_
										 "	+'X@ALUMNOS.UPACIFICO.CL' as email_upa "& vbCrLf &_
										 "  from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'"
						email_nuevo = conexion.consultaUno(c_email_nuevo) 'busca el email con 3 caracteres en apellido materno seguido de una "X"
						ya_registradoX = conexion.consultaUno("select case count(*) when 0 then 'NO' else 'SI' end from cuentas_email_upa where email_nuevo='"&email_nuevo&"' and rut <> '"&rut&"'")
						if ya_registradoX = "SI" then
							c_email_nuevo =  "  select replace(replace(replace(replace(replace(replace(SUBSTRING(ltrim(rtrim(pers_tnombre)), 1,1),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N') +  "& vbCrLf &_
											 "	replace(replace(replace(replace(replace(replace(replace(replace(substring(ltrim(rtrim(pers_tape_paterno)),1,15),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N'),' ',''),'-','') + "& vbCrLf &_
											 "	ltrim(rtrim(replace(replace(replace(replace(replace(replace(SUBSTRING(ltrim(rtrim(pers_tape_materno)),1,3),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N'))) +  "& vbCrLf &_
											 "	+'Y@ALUMNOS.UPACIFICO.CL' as email_upa "& vbCrLf &_
											 "  from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'"
							email_nuevo = conexion.consultaUno(c_email_nuevo) 'busca el email con 3 caracteres en apellido materno seguido de una "Y"
							ya_registradoY = conexion.consultaUno("select case count(*) when 0 then 'NO' else 'SI' end from cuentas_email_upa where email_nuevo='"&email_nuevo&"' and rut <> '"&rut&"'")
							if ya_registradoY = "SI" then
								c_email_nuevo =  "  select replace(replace(replace(replace(replace(replace(SUBSTRING(ltrim(rtrim(pers_tnombre)), 1,1),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N') +  "& vbCrLf &_
												 "	replace(replace(replace(replace(replace(replace(replace(replace(substring(ltrim(rtrim(pers_tape_paterno)),1,15),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N'),' ',''),'-','') + "& vbCrLf &_
												 "	ltrim(rtrim(replace(replace(replace(replace(replace(replace(SUBSTRING(ltrim(rtrim(pers_tape_materno)),1,3),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N'))) +  "& vbCrLf &_
												 "	+'Z@ALUMNOS.UPACIFICO.CL' as email_upa "& vbCrLf &_
												 "  from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'"
								email_nuevo = conexion.consultaUno(c_email_nuevo) 'busca el email con 3 caracteres en apellido materno seguido de una "Z"
								ya_registradoZ = conexion.consultaUno("select case count(*) when 0 then 'NO' else 'SI' end from cuentas_email_upa where email_nuevo='"&email_nuevo&"' and rut <> '"&rut&"'")
								if ya_registradoZ = "SI" then
									email_nuevo = ""
								end if
							end if
						end if
					end if
				end if
			end if		
		end if
		
		if email_nuevo <> "" then
		    if email_antiguo <> "" then		   
				c_insert = " insert into cuentas_email_upa (PERS_NCORR,RUT,PERS_TNOMBRE,PERS_TAPE_PATERNO,PERS_TAPE_MATERNO,EMAIL_ANTIGUO,EMAIL_NUEVO,ESTADO_CUENTA,FECHA_CREACION,FECHA_GENERACION,CLAVE_EMAIL,usa_clave_email)"&_
			    	       " values ("&pers_ncorr&",'"&rut&"','"&nombre&"','"&ap_paterno&"','"&ap_materno&"','"&email_antiguo&"','"&email_nuevo&"',1,getDate(),null,'"&clave&"','SI') "
			else
				c_insert = " insert into cuentas_email_upa (PERS_NCORR,RUT,PERS_TNOMBRE,PERS_TAPE_PATERNO,PERS_TAPE_MATERNO,EMAIL_ANTIGUO,EMAIL_NUEVO,ESTADO_CUENTA,FECHA_CREACION,FECHA_GENERACION,CLAVE_EMAIL,usa_clave_email)"&_
			    	       " values ("&pers_ncorr&",'"&rut&"','"&nombre&"','"&ap_paterno&"','"&ap_materno&"',NULL,'"&email_nuevo&"',1,getDate(),null,'"&clave&"','SI') "
			end if
			conexion.ejecutaS c_insert
			
			if conexion.ObtenerEstadoTransaccion then
				total_creados = total_creados + 1
				'response.Write(email_nuevo&"<br>")
			end if
					   
		end if
		
	wend
	
	response.Write("<table bgColor=green><tr><td width='100%'><strong>Total de cuentas incorporadas: "&total_creados&" cuentas</strong></td></tr></table>")
	
end if
%>