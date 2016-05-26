<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
secc_ccod=request.form("not[0][secc_ccod]")
'for each k in request.form
'	response.Write(k&" = "&request.form(k)&"<br>")
'next
set conectar		=	new cconexion
conectar.inicializar	"upacifico"

set negocio			=	new cnegocio
negocio.inicializa	conectar

set var = new cvariables

var.procesaform

num=var.nrofilas("NOT")

if num>0 then
			for i=0 to num
				if var.obtenervalor("not",i,"v_matr_ncorr")<>"" then
					response.Write(var.obtenervalor("not",i,"v_matr_ncorr"))	
					  SQL_Ver_Stf_alum=" select sitf_ccod from cargas_academicas " & _
									   " WHERE cast(MATR_NCORR as varchar)='"&var.obtenervalor("not",i,"v_matr_ncorr")&"' AND " & _
									   " cast(SECC_CCOD as varchar)='"&SECC_CCOD&"' "
					  sitf_ccod= conectar.consultauno(SQL_Ver_Stf_alum)
					 if isnull(sitf_ccod)	then
					 	sitf_ccod				= request.Form("not["&i&"][sitf_ccod]") 
						carg_nnota_presentacion = request.Form("not["&i&"][carg_nnota_presentacion]")
						carg_nnota_examen		= request.Form("not["&i&"][carg_nnota_examen]")
						carg_nnota_repeticion	= request.Form("not["&i&"][carg_nnota_repeticion]")
						carg_nasistencia		= request.Form("not["&i&"][carg_nasistencia]")
						carg_nnota_final		= request.Form("not["&i&"][carg_nnota_final]")

					 
							 'response.Write("sitf_ccod"&sitf_ccod&"<br>")	
							 'response.Write("carg_nnota_presentacion"&carg_nnota_presentacion&"<br>")
							 'response.Write("carg_nnota_examen"&carg_nnota_examen&"<br>")
							 'response.Write("carg_nnota_repeticion"&carg_nnota_repeticion&"<br>")
							 'response.Write("carg_nasistencia"&carg_nasistencia&"<br>")
  						     'response.Write("carg_nnota_final"&carg_nnota_final&"<br>")
					if (isnull(carg_nnota_examen) or (carg_nnota_examen=""))then
					carg_nnota_examen="null"
					end if
					if (isnull(carg_nnota_repeticion) or (carg_nnota_repeticion=""))then
					carg_nnota_repeticion="null"

					end if
					
					SenSQL = " update cargas_academicas " & _
							 " set SITF_CCOD = '"&sitf_ccod&"'," & _                    
							 " 	   CARG_NNOTA_PRESENTACION ="&carg_nnota_presentacion&" ," & _
							 "     CARG_NNOTA_EXAMEN  = "&carg_nnota_examen&"," & _     
							 "	   CARG_NNOTA_REPETICION  = "&carg_nnota_repeticion&"," & _ 
							 "	   CARG_NNOTA_FINAL      = "&carg_nnota_final&"," & _  
							 "	   CARG_NASISTENCIA       ="&carg_nasistencia&", " & _ 
							 "	   AUDI_TUSUARIO           = '"&negocio.obtenerusuario&"'," & _
							 "	   AUDI_FMODIFICACION     =getDate() " & _ 
							 " where cast(secc_ccod as varchar)= '"&secc_ccod&"'" & _
							 " and cast(matr_ncorr as varchar)='"&var.obtenervalor("not",i,"v_matr_ncorr")&"'"
 						conectar.EstadoTransaccion conectar.EjecutaS(SenSQL)							 
						'response.Write(SenSQL)
					 end if					 
					 
					  	
				  if not isnull(sitf_ccod) then 
				  		'sql	= 	" UPDATE CARGAS_ACADEMICAS  " & _
										  					
						SQL_Cerrar_alum = " UPDATE CARGAS_ACADEMICAS SET ESTADO_CIERRE_CCOD=2 " & _
										  " WHERE cast(MATR_NCORR as varchar)='"&var.obtenervalor("not",i,"v_matr_ncorr")&"' AND " & _
										  " cast(SECC_CCOD as varchar)='"&SECC_CCOD&"' "
										  
						conectar.EstadoTransaccion conectar.EjecutaS(SQL_Cerrar_alum)
				 
				 
				 		sql_cargas=" select count (isnull(estado_cierre_ccod,1)) from cargas_academicas " & _
								   " where cast(matr_ncorr as varchar)='"&var.obtenervalor("not",i,"v_matr_ncorr")&"' 	"
								   
						sql_cargas_cerradas = " select count (isnull(estado_cierre_ccod,1)) from cargas_academicas " & _
  								      " where cast(matr_ncorr as varchar)='"&var.obtenervalor("not",i,"v_matr_ncorr")&"' and" & _
									  " estado_cierre_ccod=2"
						num_cargas=conectar.consultauno(sql_cargas)
						num_cargas_cerradas=conectar.consultauno(sql_cargas_cerradas)
									  
						'response.Write(conectar.consultauno(sql_cargas)&" ---")
						'response.Write(conectar.consultauno(sql_cargas_cerradas)&"<br>")
						if 	num_cargas=num_cargas_cerradas then
							sql_cerrar_alum="update alumnos set estado_cierre_ccod=2 where cast(matr_ncorr as varchar)='"&var.obtenervalor("not",i,"matr_ncorr")&"'"
						'	response.Write(sql_cerrar_alum)
							conectar.EstadoTransaccion conectar.EjecutaS(sql_cerrar_alum)
						end if									
					
				 end if 						  
				end if
			next
end if


response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>