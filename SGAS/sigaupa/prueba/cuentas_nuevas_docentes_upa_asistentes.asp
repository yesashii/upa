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
consulta_grl = "select distinct d.pers_ncorr, d.pers_nrut, cast(d.pers_nrut as varchar)+'-'+d.pers_xdv as rut,"& vbCrLf &_ 
				"isnull(d.pers_tnombre,' ') as nombre, isnull(d.pers_tape_paterno,' ') as ap_paterno, isnull(d.pers_tape_materno,' ') as ap_materno,  "& vbCrLf &_
				"(select top 1 replace(replace(replace(replace(replace(replace(replace(lower(email_upa),'�','A'),'�','E'),'�','I'),'�','O'),'�','U'),'�','N'),' ','') from sd_cuentas_email_totales tt where tt.rut=d.pers_nrut) as email_antiguo"& vbCrLf &_  
				" from  personas d "& vbCrLf &_  
				" where pers_nrut in (12879116) "
				
				'response.Write(consulta_grl)
				'response.End()				

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
		ap_paterno     = formulario_grl.obtenerValor("ap_paterno")
		ap_materno      = formulario_grl.obtenerValor("ap_materno")
        
        c_email_nuevo =  "  select replace(replace(replace(replace(replace(replace(SUBSTRING(ltrim(rtrim(pers_tnombre)), 1,1),'�','A'),'�','E'),'�','I'),'�','O'),'�','U'),'�','N') +  "& vbCrLf &_
						 "	replace(replace(replace(replace(replace(replace(replace(replace(substring(ltrim(rtrim(pers_tape_paterno)),1,15),'�','A'),'�','E'),'�','I'),'�','O'),'�','U'),'�','N'),' ',''),'-','') + "& vbCrLf &_
						 "	ltrim(rtrim(replace(replace(replace(replace(replace(replace(SUBSTRING(ltrim(rtrim(pers_tape_materno)),1,1),'�','A'),'�','E'),'�','I'),'�','O'),'�','U'),'�','N'))) +  "& vbCrLf &_
						 "	+'@DOCENTES.UPACIFICO.CL' as email_upa "& vbCrLf &_
						 "  from personas a where cast(pers_nrut as varchar)='"&pers_nrut&"'"& vbCrLf &_
						 "  and not exists (select 1 from cuentas_email_upa tt where tt.pers_ncorr = a.pers_ncorr) "
		email_nuevo = conexion.consultaUno(c_email_nuevo)
		ya_registrado = conexion.consultaUno("select case count(*) when 0 then 'NO' else 'SI' end from cuentas_email_upa where email_nuevo='"&email_nuevo&"' and rut <> '"&rut&"'")
		if ya_registrado = "SI" then
			c_email_nuevo =  "  select replace(replace(replace(replace(replace(replace(SUBSTRING(ltrim(rtrim(pers_tnombre)), 1,1),'�','A'),'�','E'),'�','I'),'�','O'),'�','U'),'�','N') +  "& vbCrLf &_
							 "	replace(replace(replace(replace(replace(replace(replace(replace(substring(ltrim(rtrim(pers_tape_paterno)),1,15),'�','A'),'�','E'),'�','I'),'�','O'),'�','U'),'�','N'),' ',''),'-','') + "& vbCrLf &_
							 "	ltrim(rtrim(replace(replace(replace(replace(replace(replace(SUBSTRING(ltrim(rtrim(pers_tape_materno)),1,2),'�','A'),'�','E'),'�','I'),'�','O'),'�','U'),'�','N'))) +  "& vbCrLf &_
							 "	+'@DOCENTES.UPACIFICO.CL' as email_upa "& vbCrLf &_
							 "  from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'"
			email_nuevo = conexion.consultaUno(c_email_nuevo)'busca el email con 2 caracteres en apellido materno
			ya_registrado2 = conexion.consultaUno("select case count(*) when 0 then 'NO' else 'SI' end from cuentas_email_upa where email_nuevo='"&email_nuevo&"' and rut <> '"&rut&"'")
			if ya_registrado2 = "SI" then
				c_email_nuevo =  "  select replace(replace(replace(replace(replace(replace(SUBSTRING(ltrim(rtrim(pers_tnombre)), 1,1),'�','A'),'�','E'),'�','I'),'�','O'),'�','U'),'�','N') +  "& vbCrLf &_
								 "	replace(replace(replace(replace(replace(replace(replace(replace(substring(ltrim(rtrim(pers_tape_paterno)),1,15),'�','A'),'�','E'),'�','I'),'�','O'),'�','U'),'�','N'),' ',''),'-','') + "& vbCrLf &_
								 "	ltrim(rtrim(replace(replace(replace(replace(replace(replace(SUBSTRING(ltrim(rtrim(pers_tape_materno)),1,3),'�','A'),'�','E'),'�','I'),'�','O'),'�','U'),'�','N'))) +  "& vbCrLf &_
								 "	+'@DOCENTES.UPACIFICO.CL' as email_upa "& vbCrLf &_
								 "  from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'"
				email_nuevo = conexion.consultaUno(c_email_nuevo)'busca el email con 3 caracteres en apellido materno
				ya_registrado3 = conexion.consultaUno("select case count(*) when 0 then 'NO' else 'SI' end from cuentas_email_upa where email_nuevo='"&email_nuevo&"' and rut <> '"&rut&"'")
				if ya_registrado3 = "SI" then
					c_email_nuevo =  "  select replace(replace(replace(replace(replace(replace(SUBSTRING(ltrim(rtrim(pers_tnombre)), 1,1),'�','A'),'�','E'),'�','I'),'�','O'),'�','U'),'�','N') +  "& vbCrLf &_
									 "	replace(replace(replace(replace(replace(replace(replace(replace(substring(ltrim(rtrim(pers_tape_paterno)),1,15),'�','A'),'�','E'),'�','I'),'�','O'),'�','U'),'�','N'),' ',''),'-','') + "& vbCrLf &_
									 "	ltrim(rtrim(replace(replace(replace(replace(replace(replace(SUBSTRING(ltrim(rtrim(pers_tape_materno)),1,3),'�','A'),'�','E'),'�','I'),'�','O'),'�','U'),'�','N'))) +  "& vbCrLf &_
									 "	+'W@DOCENTES.UPACIFICO.CL' as email_upa "& vbCrLf &_
									 "  from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'"
					email_nuevo = conexion.consultaUno(c_email_nuevo)'busca el email con 3 caracteres en apellido materno seguido de una "W"
					ya_registradoW = conexion.consultaUno("select case count(*) when 0 then 'NO' else 'SI' end from cuentas_email_upa where email_nuevo='"&email_nuevo&"' and rut <> '"&rut&"'")
					if ya_registradoW = "SI" then
						c_email_nuevo =  "  select replace(replace(replace(replace(replace(replace(SUBSTRING(ltrim(rtrim(pers_tnombre)), 1,1),'�','A'),'�','E'),'�','I'),'�','O'),'�','U'),'�','N') +  "& vbCrLf &_
										 "	replace(replace(replace(replace(replace(replace(replace(replace(substring(ltrim(rtrim(pers_tape_paterno)),1,15),'�','A'),'�','E'),'�','I'),'�','O'),'�','U'),'�','N'),' ',''),'-','') + "& vbCrLf &_
										 "	ltrim(rtrim(replace(replace(replace(replace(replace(replace(SUBSTRING(ltrim(rtrim(pers_tape_materno)),1,3),'�','A'),'�','E'),'�','I'),'�','O'),'�','U'),'�','N'))) +  "& vbCrLf &_
										 "	+'X@DOCENTES.UPACIFICO.CL' as email_upa "& vbCrLf &_
										 "  from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'"
						email_nuevo = conexion.consultaUno(c_email_nuevo) 'busca el email con 3 caracteres en apellido materno seguido de una "X"
						ya_registradoX = conexion.consultaUno("select case count(*) when 0 then 'NO' else 'SI' end from cuentas_email_upa where email_nuevo='"&email_nuevo&"' and rut <> '"&rut&"'")
						if ya_registradoX = "SI" then
							c_email_nuevo =  "  select replace(replace(replace(replace(replace(replace(SUBSTRING(ltrim(rtrim(pers_tnombre)), 1,1),'�','A'),'�','E'),'�','I'),'�','O'),'�','U'),'�','N') +  "& vbCrLf &_
											 "	replace(replace(replace(replace(replace(replace(replace(replace(substring(ltrim(rtrim(pers_tape_paterno)),1,15),'�','A'),'�','E'),'�','I'),'�','O'),'�','U'),'�','N'),' ',''),'-','') + "& vbCrLf &_
											 "	ltrim(rtrim(replace(replace(replace(replace(replace(replace(SUBSTRING(ltrim(rtrim(pers_tape_materno)),1,3),'�','A'),'�','E'),'�','I'),'�','O'),'�','U'),'�','N'))) +  "& vbCrLf &_
											 "	+'Y@DOCENTES.UPACIFICO.CL' as email_upa "& vbCrLf &_
											 "  from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'"
							email_nuevo = conexion.consultaUno(c_email_nuevo) 'busca el email con 3 caracteres en apellido materno seguido de una "Y"
							ya_registradoY = conexion.consultaUno("select case count(*) when 0 then 'NO' else 'SI' end from cuentas_email_upa where email_nuevo='"&email_nuevo&"' and rut <> '"&rut&"'")
							if ya_registradoY = "SI" then
								c_email_nuevo =  "  select replace(replace(replace(replace(replace(replace(SUBSTRING(ltrim(rtrim(pers_tnombre)), 1,1),'�','A'),'�','E'),'�','I'),'�','O'),'�','U'),'�','N') +  "& vbCrLf &_
												 "	replace(replace(replace(replace(replace(replace(replace(replace(substring(ltrim(rtrim(pers_tape_paterno)),1,15),'�','A'),'�','E'),'�','I'),'�','O'),'�','U'),'�','N'),' ',''),'-','') + "& vbCrLf &_
												 "	ltrim(rtrim(replace(replace(replace(replace(replace(replace(SUBSTRING(ltrim(rtrim(pers_tape_materno)),1,3),'�','A'),'�','E'),'�','I'),'�','O'),'�','U'),'�','N'))) +  "& vbCrLf &_
												 "	+'Z@DOCENTES.UPACIFICO.CL' as email_upa "& vbCrLf &_
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
				c_insert = " insert into cuentas_email_upa (PERS_NCORR,RUT,PERS_TNOMBRE,PERS_TAPE_PATERNO,PERS_TAPE_MATERNO,EMAIL_ANTIGUO,EMAIL_NUEVO,ESTADO_CUENTA,FECHA_CREACION,FECHA_GENERACION)"&_
			    	       " values ("&pers_ncorr&",'"&rut&"','"&nombre&"','"&ap_paterno&"','"&ap_materno&"','"&email_antiguo&"','"&email_nuevo&"',1,getDate(),null ) "
			else
				c_insert = " insert into cuentas_email_upa (PERS_NCORR,RUT,PERS_TNOMBRE,PERS_TAPE_PATERNO,PERS_TAPE_MATERNO,EMAIL_ANTIGUO,EMAIL_NUEVO,ESTADO_CUENTA,FECHA_CREACION,FECHA_GENERACION)"&_
			    	       " values ("&pers_ncorr&",'"&rut&"','"&nombre&"','"&ap_paterno&"','"&ap_materno&"',NULL,'"&email_nuevo&"',1,getDate(),null ) "
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