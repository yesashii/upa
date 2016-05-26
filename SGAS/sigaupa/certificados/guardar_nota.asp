<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file="../biblioteca/_negocio.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.form(k)&"<br>")
'next
'response.End()
registros	=	request.Form("registros")
seccion		=	session("secc_ccod_trabajo")
cali_ncorr	=	request.form("not[0][cali_ncorr]")	
'response.Write("registros "&registros&" seccion "&seccion&" cali_ncorr "&cali_ncorr)
set calificaciones	=	new cformulario
set calificaciones_cambio	=	new cformulario
set datos	  		=	new cformulario
set datos_ponderacion		=	new cformulario
set conectar		=	new cconexion
set negocio			=	new cnegocio				


conectar.inicializar		"upacifico"
calificaciones.inicializar	conectar
calificaciones_cambio.inicializar	conectar

datos.inicializar	conectar
datos.carga_parametros		"paulo.xml","tabla"
datos_ponderacion.inicializar	conectar
datos_ponderacion.carga_parametros		"paulo.xml","tabla"


negocio.inicializa conectar

registros	=	request.Form("registros")
seccion		=	session("secc_ccod_trabajo")
cali_ncorr	=	request.form("not[0][cali_ncorr]")	

'-------------------------hacemos un respaldo de las calificaciones antes de guardar los cambios-----------------------
'----------------------------------Agregado por Marcelo Sandoval-------------------------------------------------------
calificaciones_cambio.carga_parametros		"notas.xml","guardar_nota"
calificaciones_cambio.procesaForm
calificaciones_cambio.agregacampopost	"cali_ncorr",cali_ncorr
calificaciones_cambio.agregacampopost	"secc_ccod",seccion
for i=0 to calificaciones_cambio.cuentaPost - 1
    'response.write("Entre al for<br>")
	cala_nnota1 = calificaciones_cambio.obtenerValorPost(i,"cala_nnota")
	cala_nnota_respaldo1  = calificaciones_cambio.obtenerValorPost(i,"cala_nnota_respaldo")
	secc_ccod1 = calificaciones_cambio.obtenerValorPost(i,"secc_ccod")
	matr_ncorr1  = calificaciones_cambio.obtenerValorPost(i,"matr_ncorr")
	cali_ncorr1  = calificaciones_cambio.obtenerValorPost(i,"cali_ncorr")
	cala_nresolucion1  = calificaciones_cambio.obtenerValorPost(i,"cala_nresolucion")
	cala_tobservacion1  = calificaciones_cambio.obtenerValorPost(i,"cala_tobservacion")
	
	if ((cala_nnota1 <> cala_nnota_respaldo1) and (cala_nresolucion1 <> "")) then
	     if cala_nnota_respaldo1 = "" then 
		    cala_nnota_respaldo1 = cala_nnota1
		 end if	
		 
		 consulta_insert = " insert into calificaciones_alumnos_cambio(matr_ncorr,secc_ccod,cali_ncorr,cala_nnota,audi_tusuario,audi_fmodificacion,cali_njustificacion,cala_nresolucion,cala_tobservacion)"&_
		                   " values ("&matr_ncorr1&","&seccion&","&cali_ncorr1&","&cala_nnota_respaldo1&",'"&negocio.obtenerUsuario&"',getDate(),null,'"&cala_nresolucion1&"','"&cala_tobservacion1&"')"
	     'response.Write(consulta_insert)
		 conectar.ejecutaS  consulta_insert
	end if
	
next	


'----------------------------------------------------------------------------------------------------------------------

calificaciones.carga_parametros		"notas.xml","guardar_nota"
calificaciones.procesaForm
calificaciones.agregacampopost	"cali_ncorr",	cali_ncorr
calificaciones.agregacampopost	"secc_ccod",	seccion
calificaciones.mantienetablas false

'conectar.estadoTransaccion false
'response.End()

sql="select sitf_ccod from cargas_academicas a , alumnos b" & _
	" where a.matr_ncorr=b.matr_ncorr " & _
	" and 	cast(a.secc_ccod as varchar)='"&seccion&"'" & _
	" and 	b.emat_ccod=1 " 
'response.Write("<br>"&sql)
sif_ccod=conectar.consultauno(sql)

sql_EXREP = "select count(*) from cargas_academicas a , alumnos b" & _
			" where a.matr_ncorr=b.matr_ncorr " & _
			" and 	cast(a.secc_ccod as varchar)='"&seccion&"'" & _
			" and 	b.emat_ccod=1 " & _
			" and   a.eexa_ccod_rep is not null"
'response.Write("<br>"&sql_EXREP)
EXREP = conectar.consultauno(sql_EXREP)


sql2=" select isnull(b.tasg_ccod,a.tasg_ccod) from asignaturas a, secciones b " & _
	 " where a.asig_ccod=b.asig_ccod " & _
	 " and cast(b.secc_ccod as varchar)='"&seccion&"'"  
'response.Write("<br>"&sql2)
tipo_asignatura=conectar.consultauno(sql2)
'-------- DATOS DE PONDERACION Y EXIMICION --------------------
v_mall_ccod = conectar.consultauno("select mall_ccod from secciones where cast(secc_ccod as varchar)= '"&seccion&"'")
sql_datos = " select isnull(MALL_NOTA_PRESENTACION,0) as MALL_NOTA_PRESENTACION ,isnull(MALL_PORCENTAJE_PRESENTACION,0) as MALL_PORCENTAJE_PRESENTACION," & _
			" isnull(MALL_NEVALUACION_MINIMA,0) as MALL_NEVALUACION_MINIMA,isnull(MALL_PORCENTAJE_ASISTENCIA,0) as MALL_PORCENTAJE_ASISTENCIA,isnull(MALL_NOTA_EXIMICION,0) as MALL_NOTA_EXIMICION" & _
			" from malla_curricular " & _
			"where cast(mall_ccod as varchar)='"&v_mall_ccod&"'"
'response.Write("<br>"&sql_datos)			
datos_ponderacion.consultar sql_datos
datos_ponderacion.siguiente
V_MALL_NOTA_PRESENTACION =conectar.consultauno("select replace('"&datos_ponderacion.obtenervalor("MALL_NOTA_PRESENTACION")&"',',','.')")
'response.Write("<br>v_malla_nota_presentacion "&v_malla_nota_presentacion)
V_MALL_PORCENTAJE_PRESENTACION =datos_ponderacion.obtenervalor("MALL_PORCENTAJE_PRESENTACION")
'response.Write("<br>v_malla_porcentaje_presentacion "&v_malla_porcentaje_presentacion)
V_MALL_PORCENTAJE_EXAMEN =( 100 - CINT(V_MALL_PORCENTAJE_PRESENTACION) )
'response.Write("<br>v_malla_porcentaje_examen "&v_mall_porcentaje_examen)
V_MALL_PORCENTAJE_ASISTENCIA =datos_ponderacion.obtenervalor("MALL_PORCENTAJE_ASISTENCIA")
'response.Write("<br>v_mall_porcentaje_asistencia "&v_mall_porcentaje_asistencia)
V_MALL_NOTA_EXIMICION =conectar.consultauno("select replace('"&datos_ponderacion.obtenervalor("MALL_NOTA_EXIMICION")&"',',','.')")
'response.Write("<br>v_mall_nota_eximision "&v_mall_nota_eximision)
'--------------------------------------------------------------
'--- SI SE CAMBIA UNA NOTA PARCIAL LUEGO DE INGRESAR EXAMNES Y/O EXAMENES DE REPETICION------' 
if (sif_ccod<>"" ) then 
	set exprRegular = new RegExp
	exprRegular.pattern = "matr_ncorr"
	exprRegular.IgnoreCase = True
	for each k in request.form
		if exprRegular.Test(K) then
			query_datos = "select SECC_CCOD, SITF_CCOD,isnull(CARG_NNOTA_PRESENTACION,0) as CARG_NNOTA_PRESENTACION,isnull(CARG_NNOTA_EXAMEN,0) as CARG_NNOTA_EXAMEN, " & _          
						  " isnull(CARG_NNOTA_REPETICION,0) as CARG_NNOTA_REPETICION,isnull(CARG_NNOTA_FINAL,0) as CARG_NNOTA_FINAL,isnull(CARG_NASISTENCIA,0) as CARG_NASISTENCIA, EEXA_CCOD , " & _                  
					      "	EEXA_CCOD_REP from cargas_academicas " & _
						  " WHERE cast(MATR_NCORR as varchar)='"&REQUEST.Form(K)&"'"&_         
						  " AND cast(SECC_CCOD as varchar)='"&SECCION&"'"
            'response.Write("<br>"&query_datos)
    		datos.consultar query_datos
			datos.siguiente
			v_sitf_ccod = datos.obtenervalor("sitf_ccod")
			'response.Write("<br>v_sift_ccod "&v_sift_ccod)
			V_CARG_NNOTA_PRESENTACION = conectar.consultauno("select replace('"&datos.obtenervalor("CARG_NNOTA_PRESENTACION")&"',',','.')")
			'response.Write("<br>V_CARG_NNOTA_PRESENTACION "&V_CARG_NNOTA_PRESENTACION)
			V_CARG_NNOTA_EXAMEN = conectar.consultauno("select replace('"&datos.obtenervalor("CARG_NNOTA_EXAMEN")&"',',','.')")
			'response.Write("<br>V_CARG_NNOTA_EXAMEN "&V_CARG_NNOTA_EXAMEN)
			V_CARG_NNOTA_REPETICION =conectar.consultauno("select replace('"& datos.obtenervalor("CARG_NNOTA_REPETICION")&"',',','.')")
			'response.Write("<br>V_CARG_NNOTA_REPETICION "&V_CARG_NNOTA_REPETICION)
			V_CARG_NASISTENCIA = datos.obtenervalor("CARG_NASISTENCIA")
			'response.Write("<br>V_CARG_NNOTA_REPETICION "&V_CARG_NNOTA_REPETICION)	
			V_EEXA_CCOD = datos.obtenervalor("EEXA_CCOD")
			'response.Write("<br>V_EEXA_CCOD "&V_EEXA_CCOD)	
			V_EEXA_CCOD_REP = datos.obtenervalor("EEXA_CCOD_REP")												
			'response.Write("<br>V_EEXA_CCOD_REP "&V_EEXA_CCOD_REP)
			sqlNP="select replace(protic.NOTA_PRESENTACION('"&request.form(k)&"','"&seccion&"'),',','.')"
			'response.Write("<br>"&sqlNP)
			NP=	conectar.consultauno(sqlNP)
			'response.Write("<br>NP "&NP)
			NPFuncion = conectar.consultauno("select replace('"&NP&"',',','.')")
			'response.Write("<br>NPFuncion "&NPFuncion)
			if V_EEXA_CCOD="EX" then
				 if NP >=V_MALL_NOTA_EXIMICION then
				 	NF = NP
					NFUpdate =NPFuncion
					V_EEXA_CCOD_update ="EX"
					V_EEXA_CCOD_rep_update =""
					'response.Write("<br>NF "&NF&" NFUpdate "&NFUpdate&" V_EEXA_CCOD_update "&V_EEXA_CCOD_update&" V_EEXA_CCOD_rep_update "&V_EEXA_CCOD_rep_update )
				 else
				 	if EXREP>0 then
						NF = "1.0"
						NFUpdate ="1.0"
						V_EEXA_CCOD_update ="NP"
						V_EEXA_CCOD_rep_update ="NP"
						'response.Write("<br>NF "&NF&" NFUpdate "&NFUpdate&" V_EEXA_CCOD_update "&V_EEXA_CCOD_update&" V_EEXA_CCOD_rep_update "&V_EEXA_CCOD_rep_update )
					else
						V_EEXA_CCOD_rep_update =""
						NF = "1.0"
						NFUpdate ="1.0"
						V_EEXA_CCOD_update ="NP"
						V_EEXA_CCOD_rep_update =""
						'response.Write("<br>NF "&NF&" NFUpdate "&NFUpdate&" V_EEXA_CCOD_update "&V_EEXA_CCOD_update&" V_EEXA_CCOD_rep_update "&V_EEXA_CCOD_rep_update )
					end if	
				 end if
				 
		         if (isnull(V_CARG_NNOTA_REPETICION) or isempty(V_CARG_NNOTA_REPETICION) or V_CARG_NNOTA_REPETICION="") then
					 	if ( V_CARG_NNOTA_EXAMEN<>"") then
							if (V_CARG_NNOTA_EXAMEN<V_MALL_NOTA_PRESENTACION AND V_EEXA_CCOD_rep<>"NP") Then
								NFUpdate = conectar.consultauno("select replace('"&V_CARG_NNOTA_EXAMEN&"',',','.')")
								'response.Write("<br>NFUpdate "&NFUpdate)
						 		nf       = V_CARG_NNOTA_EXAMEN
								'response.Write("<br>nf "&nf)
							end if
						end if
				 else
				 	if 	V_CARG_NNOTA_REPETICION<V_MALL_NOTA_PRESENTACION then
						 NFUpdate = conectar.consultauno("select replace('"&V_CARG_NNOTA_REPETICION&"',',','.')")
						 'response.Write("<br>NFUpdate "&NFUpdate)
						 nf       = V_CARG_NNOTA_REPETICION
						 'response.Write("<br>nf "&nf)
					end if
				 end if
				  '---- cambio de notas----'
	 			if EXREP>0 then
					if ( V_CARG_NNOTA_EXAMEN<>"" and V_CARG_NNOTA_EXAMEN>V_MALL_NOTA_PRESENTACION ) then
						sqlNF="select replace(protic.CAMBIO_NOTAFINAL('"&request.form(k)&"','"&seccion&"','"&NPFuncion&"','"&V_MALL_PORCENTAJE_PRESENTACION&"','"&V_MALL_PORCENTAJE_EXAMEN&"'),',','.')"
						'response.Write("<br>sqlNF "&sqlNF)
						NF=	conectar.consultauno(sqlNF)
						'response.Write("<br>NF "&NF)	
						if NF>"3.95" then
							NFUpdate =	conectar.consultauno("select replace('"&NF&"',',','.')")
							'response.Write("<br>NFUpdate "&NFUpdate)
							V_EEXA_CCOD_update ="RE"
							V_EEXA_CCOD_REP_update =""
							nota_repeticion=""
						end if	
					end if
				end if	
			 '-------------------------------------
				 if nf<"3.95" THEN
				 	sitf_ccod ="R"
				 else
				 	if CINT(V_CARG_NASISTENCIA)<CINT(V_MALL_PORCENTAJE_ASISTENCIA) then
						 	sitf_ccod ="R"					
					else
						    sitf_ccod ="A"
					end if
				 end if	
				
				 
				 sentencia = " UPDATE cargas_academicas set SITF_CCOD ='"&sitf_ccod&"'," & vbCrlf & _
				 			   " CARG_NNOTA_PRESENTACION ="&NPFuncion&", " & vbCrlf & _
				 			   " CARG_NNOTA_EXAMEN=NULL, " & vbCrlf & _
							   " CARG_NNOTA_REPETICION = NULL," & vbCrlf & _
							   " CARG_NNOTA_FINAL = "&NFUpdate&"," & vbCrlf & _
							   " AUDI_TUSUARIO = '"&negocio.obtenerusuario&"'," & vbCrlf & _
							   " AUDI_FMODIFICACION = Getdate(), " & vbCrlf & _
							   " EEXA_CCOD = '"&V_EEXA_CCOD_update&"'," & vbCrlf & _
							   " EEXA_CCOD_REP = '"&V_EEXA_CCOD_rep_update&"'" & vbCrlf & _
							   " WHERE cast(matr_ncorr as varchar)= '"&request.form(k)&"'" & vbCrlf & _
							   " and cast(secc_ccod as varchar)='"&seccion&"'" 
				'response.Write("<br><pre>1:"&sentencia&"</pre>")			   
							   
			end if
			
			if V_EEXA_CCOD="SD" then
			   if NP >=V_MALL_NOTA_EXIMICION then
			   	  NF = NP	
				  NFUpdate =NPFuncion
				  V_CARG_NNOTA_EXAMEN=""
				  V_CARG_NNOTA_REPETICION =""
				  V_EEXA_CCOD_update ="EX"
				  V_EEXA_CCOD_rep_update =""
				  'response.Write("<br>NF "&NF&" NFUpdate "&NFUpdate&" V_EEXA_CCOD_update "&V_EEXA_CCOD_update&" V_EEXA_CCOD_rep_update "&V_EEXA_CCOD_rep_update&" V_CARG_NNOTA_EXAMEN "& V_CARG_NNOTA_EXAMEN&" V_CARG_NNOTA_REPETICION "&V_CARG_NNOTA_REPETICION )
			   else 
			   		if NP <V_MALL_NOTA_PRESENTACION then
 						if (isnull(V_EEXA_CCOD_REP) or isempty(V_EEXA_CCOD_REP) or V_EEXA_CCOD_REP="") then
							NFUpdate =NPFuncion
							V_EEXA_CCOD_update ="SD"
							V_EEXA_CCOD_rep_update =""
							'response.Write("<br>NFUpdate "&NFUpdate&" V_EEXA_CCOD_update "&V_EEXA_CCOD_update&" V_EEXA_CCOD_rep_update "&V_EEXA_CCOD_rep_update)
						else	
							if V_EEXA_CCOD_REP = "NP"then
								NF = "1.0"
								NFUpdate ="1.0"
								V_EEXA_CCOD_update ="SD"
								V_EEXA_CCOD_rep_update ="NP"
								'response.Write("<br>NF "&NF&" NFUpdate "&NFUpdate&" V_EEXA_CCOD_update "&V_EEXA_CCOD_update&" V_EEXA_CCOD_rep_update "&V_EEXA_CCOD_rep_update)
							else
								sqlNF="select replace(protic.NOTAFINAL('"&request.form(k)&"','"&seccion&"','"&NPFuncion&"','"&V_MALL_PORCENTAJE_PRESENTACION&"','"&V_MALL_PORCENTAJE_EXAMEN&"'),',','.')"
								'response.Write("<br>"&sqlNF)
								NF=	conectar.consultauno(sqlNF)
								NFUpdate =	conectar.consultauno("select replace('"&NF&"',',','.')")
								V_EEXA_CCOD_rep_update ="RE"
								V_EEXA_CCOD_update ="SD"
								'response.Write("<br>NF "&NF&" NFUpdate "&NFUpdate&" V_EEXA_CCOD_update "&V_EEXA_CCOD_update&" V_EEXA_CCOD_rep_update "&V_EEXA_CCOD_rep_update)
							end if
						end if
					 else
				 		if (isnull(V_EEXA_CCOD_REP) or isempty(V_EEXA_CCOD_REP) or V_EEXA_CCOD_REP="" or V_EEXA_CCOD_REP="NP") then
							NF = "1.0"
							NFUpdate ="1.0"
							V_EEXA_CCOD_update ="NP"
							V_EEXA_CCOD_rep_update =""
							'response.Write("<br>NF "&NF&" NFUpdate "&NFUpdate&" V_EEXA_CCOD_update "&V_EEXA_CCOD_update&" V_EEXA_CCOD_rep_update "&V_EEXA_CCOD_rep_update)
						else
							sqlNF="select replace(protic.NOTAFINAL('"&request.form(k)&"','"&seccion&"','"&NPFuncion&"','"&V_MALL_PORCENTAJE_PRESENTACION&"','"&V_MALL_PORCENTAJE_EXAMEN&"'),',','.')"
							NF=	conectar.consultauno(sqlNF)	
							NFUpdate =	conectar.consultauno("select replace('"&NF&"',',','.')")
							V_EEXA_CCOD_update ="NP"
							V_EEXA_CCOD_rep_update ="RE"
							'response.Write("<br>NF "&NF&" NFUpdate "&NFUpdate&" V_EEXA_CCOD_update "&V_EEXA_CCOD_update&" V_EEXA_CCOD_rep_update "&V_EEXA_CCOD_rep_update)
						end if
					 end if  
					  
			   end if 	   
								
		         if (isnull(V_CARG_NNOTA_REPETICION) or isempty(V_CARG_NNOTA_REPETICION) or V_CARG_NNOTA_REPETICION="") then
					 	if ( V_CARG_NNOTA_EXAMEN<>"") then
							if (V_CARG_NNOTA_EXAMEN<V_MALL_NOTA_PRESENTACION AND V_EEXA_CCOD_rep<>"NP") Then
								NFUpdate = conectar.consultauno("select replace('"&V_CARG_NNOTA_EXAMEN&"',',','.')")
								'response.Write("<br>NFUpdate "&NFUpdate)
						 		nf       = V_CARG_NNOTA_EXAMEN
								'response.Write("<br>nf "&nf)
							end if
						end if
				 else
				 	if 	V_CARG_NNOTA_REPETICION<V_MALL_NOTA_PRESENTACION then
						 NFUpdate = conectar.consultauno("select replace('"&V_CARG_NNOTA_REPETICION&"',',','.')")
						 'response.Write("<br>NFUpdate "&NFUpdate)
						 nf       = V_CARG_NNOTA_REPETICION
						 'response.Write("<br>nf "&nf)
					end if
				 end if 
				 '---- cambio de notas----'
	 			if EXREP>0 then
					if ( V_CARG_NNOTA_EXAMEN<>"" and V_CARG_NNOTA_EXAMEN>V_MALL_NOTA_PRESENTACION ) then
						sqlNF="select replace(protic.CAMBIO_NOTAFINAL('"&request.form(k)&"','"&seccion&"','"&NPFuncion&"','"&V_MALL_PORCENTAJE_PRESENTACION&"','"&V_MALL_PORCENTAJE_EXAMEN&"'),',','.')"
						'response.Write("<br>sqlNF "&sqlNF)
						NF=	conectar.consultauno(sqlNF)
						'response.Write("<br>NF "&NF)	
						if NF>"3.95" then
							NFUpdate =	conectar.consultauno("select replace('"&NF&"',',','.')")
							V_EEXA_CCOD_update ="RE"
							V_EEXA_CCOD_REP_update =""
							nota_repeticion=""
							'response.Write("<br> NFUpdate "&NFUpdate&" V_EEXA_CCOD_update "&V_EEXA_CCOD_update&" V_EEXA_CCOD_rep_update "&V_EEXA_CCOD_rep_update&" nota_repeticion "&nota_repeticion)
						end if	
					end if
				end if	
			 '-------------------------------------
						

				 if nf<"3.95" THEN
				 	sitf_ccod ="R"
					'response.Write("<br>RR")
				 else
				 	if CINT(V_CARG_NASISTENCIA)<CINT(V_MALL_PORCENTAJE_ASISTENCIA) then
						 	sitf_ccod ="R"					
					else
						    sitf_ccod ="A"
					end if
					'response.Write("<br>"&sitf_ccod)
				 end if	
				 nota_examen = conectar.consultauno("select replace('"&V_CARG_NNOTA_EXAMEN&"',',','.')")
				 nota_repeticion = conectar.consultauno("select replace('"&V_CARG_NNOTA_REPETICION&"',',','.')")
				 
				 
				 'response.Write("<br>nota_examen "&nota_examen&" nota_repeticion "&nota_repeticion)
				 sentencia = " UPDATE cargas_academicas set SITF_CCOD ='"&sitf_ccod&"'," & vbCrlf & _
				 			   " CARG_NNOTA_PRESENTACION ="&NPFuncion&"," 
							   if nota_examen<>"" then
				 			   		sentencia=sentencia & " CARG_NNOTA_EXAMEN="&nota_examen&", " 
							   else
							   		sentencia=sentencia & " CARG_NNOTA_EXAMEN=NULL, " 
							   end if
							   if nota_repeticion<>"" then
							   		sentencia=sentencia & " CARG_NNOTA_REPETICION = "&nota_repeticion&","
							   else
							   		sentencia=sentencia & " CARG_NNOTA_REPETICION = Null,"
							   end if
							   
							   if NFUpdate <> "" then
							   		sentencia=sentencia & " CARG_NNOTA_FINAL = "&NFUpdate&","
							   else
							   		sentencia=sentencia & " CARG_NNOTA_FINAL = Null,"
							   end if	
							   
				sentencia=sentencia & " AUDI_TUSUARIO = '"&negocio.obtenerusuario&"'," & vbCrlf & _
							   " AUDI_FMODIFICACION = getDate()," & vbCrlf & _
							   " EEXA_CCOD = '"&V_EEXA_CCOD_update&"'," & vbCrlf & _
							   " EEXA_CCOD_REP = '"&V_EEXA_CCOD_REP_update&"'" & vbCrlf & _							   
							   " WHERE cast(matr_ncorr as varchar)= '"&request.form(k)&"'" & vbCrlf & _
							   " and cast(secc_ccod as varchar)='"&seccion&"'" 

			'response.Write("<pre>2: "&sentencia&"</pre>")		
 			end if

 			if V_EEXA_CCOD="RE"  then
			
			    if NP >=V_MALL_NOTA_EXIMICION and V_CARG_NNOTA_PRESENTACION<V_MALL_NOTA_EXIMICION then
				 	NF = NP
					NFUpdate =NPFuncion
					V_CARG_NNOTA_EXAMEN=""
				  	V_CARG_NNOTA_REPETICION =""
				  	V_EEXA_CCOD_update ="EX"
					V_EEXA_REP_update =""
					'response.Write("<br>NF "&NF&" NFUpdate "&NFUpdate&" V_EEXA_CCOD_update "&V_EEXA_CCOD_update&" V_EEXA_CCOD_rep_update "&V_EEXA_CCOD_rep_update&" V_CARG_NNOTA_EXAMEN "&V_CARG_NNOTA_EXAMEN&" V_CARG_NNOTA_REPETICION "&V_CARG_NNOTA_REPETICION)
				else
				 if NP <V_MALL_NOTA_PRESENTACION then
			   		V_EEXA_CCOD_update ="SD"
					V_CARG_NNOTA_EXAMEN=""
					'response.Write("<br>V_EEXA_CCOD_update "&V_EEXA_CCOD_update&" V_CARG_NNOTA_EXAMEN "&V_CARG_NNOTA_EXAMEN)
					if (isnull(V_EEXA_CCOD_REP) or isempty(V_EEXA_CCOD_REP) or V_EEXA_CCOD_REP="") then
						NF = NP
						NFUpdate =	NPFuncion
						V_EEXA_CCOD_update ="SD"
						V_EEXA_CCOD_rep_update =""
						'response.Write("<br>NF "&NF&" NFUpdate "&NFUpdate&" V_EEXA_CCOD_update "&V_EEXA_CCOD_update&" V_EEXA_CCOD_rep_update "&V_EEXA_CCOD_rep_update)
					else
							if V_EEXA_CCOD_REP = "NP"then
								NF = "1.0"
								NFUpdate ="1,0"
								V_EEXA_CCOD_update ="SD"
								V_EEXA_CCOD_rep_update ="NP"
								'response.Write("<br>NF "&NF&" NFUpdate "&NFUpdate&" V_EEXA_CCOD_update "&V_EEXA_CCOD_update&" V_EEXA_CCOD_rep_update "&V_EEXA_CCOD_rep_update)
							else
								sqlNF="select replace(protic.NOTAFINAL('"&request.form(k)&"','"&seccion&"','"&NPFuncion&"','"&V_MALL_PORCENTAJE_PRESENTACION&"','"&V_MALL_PORCENTAJE_EXAMEN&"'),',','.')"
								'response.Write("<br>"&sqlNF)
								NF=	conectar.consultauno(sqlNF)	
								NFUpdate =	conectar.consultauno("select replace('"&NF&"',',','.') ")
								V_EEXA_CCOD_update ="SD"
								V_EEXA_CCOD_rep_update ="RE"
								'response.Write("<br>NF "&NF&" NFUpdate "&NFUpdate&" V_EEXA_CCOD_update "&V_EEXA_CCOD_update&" V_EEXA_CCOD_rep_update "&V_EEXA_CCOD_rep_update)
							end if
				   end if			
				 else
						if EXREP>0 then
							if (isnull(V_EEXA_CCOD_REP) or isempty(V_EEXA_CCOD_REP) or V_EEXA_CCOD_REP="") then
								if (isnull(V_CARG_NNOTA_REPETICION) or isempty(V_CARG_NNOTA_REPETICION) or V_CARG_NNOTA_REPETICION="") then
									V_EEXA_CCOD_rep_update =""		
									sqlNF="select replace(protic.NOTAFINAL('"&request.form(k)&"','"&seccion&"','"&NPFuncion&"','"&V_MALL_PORCENTAJE_PRESENTACION&"','"&V_MALL_PORCENTAJE_EXAMEN&"'),',','.')"
									'response.Write("<br>sqlNF "&sqlNF)
									NF=	conectar.consultauno(sqlNF)	
									NFUpdate =	conectar.consultauno("select replace('"&NF&"',',','.')")
									V_EEXA_CCOD_update ="RE"
									'response.Write("<br>NF "&NF&" NFUpdate "&NFUpdate&" V_EEXA_CCOD_update "&V_EEXA_CCOD_update&" V_EEXA_CCOD_rep_update "&V_EEXA_CCOD_rep_update)
								end if
							else
								if V_EEXA_CCOD_REP="NP" then
									NF = "1.0"
									NFUpdate ="1,0"
									V_EEXA_CCOD_update ="RE"
									V_EEXA_CCOD_rep_update ="NP"
									'response.Write("<br>NF "&NF&" NFUpdate "&NFUpdate&" V_EEXA_CCOD_update "&V_EEXA_CCOD_update&" V_EEXA_CCOD_rep_update "&V_EEXA_CCOD_rep_update)
								else
									sqlNF="select replace(protic.NOTAFINAL('"&request.form(k)&"','"&seccion&"','"&NPFuncion&"','"&V_MALL_PORCENTAJE_PRESENTACION&"','"&V_MALL_PORCENTAJE_EXAMEN&"'),',','.')"
									'response.Write("<br>"&sqlNF)
									NF=	conectar.consultauno(sqlNF)	
									NFUpdate =	conectar.consultauno("select replace('"&NF&"',',','.')")
									V_EEXA_CCOD_update ="RE"
									V_EEXA_CCOD_rep_update ="RE"
									'response.Write("<br>NF "&NF&" NFUpdate "&NFUpdate&" V_EEXA_CCOD_update "&V_EEXA_CCOD_update&" V_EEXA_CCOD_rep_update "&V_EEXA_CCOD_rep_update)
								end if
							end if
						else
							V_EEXA_CCOD_rep_update =""
							sqlNF="select replace(protic.NOTAFINAL('"&request.form(k)&"','"&seccion&"','"&NPFuncion&"','"&V_MALL_PORCENTAJE_PRESENTACION&"','"&V_MALL_PORCENTAJE_EXAMEN&"'),',','.')"
							'response.Write("<br>"&sqlNF)
							NF=	conectar.consultauno(sqlNF)	
							NFUpdate =	conectar.consultauno("select replace('"&NF&"',',','.')")
							V_EEXA_CCOD_update ="RE"
							'response.Write("<br>NF "&NF&" NFUpdate "&NFUpdate&" V_EEXA_CCOD_update "&V_EEXA_CCOD_update)
						end if	
						
 							   
				 end if
		         if (isnull(V_CARG_NNOTA_REPETICION) or isempty(V_CARG_NNOTA_REPETICION) or V_CARG_NNOTA_REPETICION="") then
					 	if ( V_CARG_NNOTA_EXAMEN<>"") then
							if (V_CARG_NNOTA_EXAMEN<V_MALL_NOTA_PRESENTACION AND EsVacio(V_EEXA_CCOD_rep)) Then
								NFUpdate = conectar.consultauno("select replace('"&V_CARG_NNOTA_EXAMEN&"',',','.')")
						 		nf       = V_CARG_NNOTA_EXAMEN
     							'response.Write("<br>NFUpdate "&NFUpdate&" nf "&nf)	
							end if
						end if
				 else
				 	if 	V_CARG_NNOTA_REPETICION<V_MALL_NOTA_PRESENTACION then
						 NFUpdate = conectar.consultauno("select replace('"&V_CARG_NNOTA_REPETICION&"',',','.')")
						 nf       = V_CARG_NNOTA_REPETICION
						 'response.Write("<br>NFUpdate "&NFUpdate&" nf "&nf)	
					end if
				 end if
			end if
			 nota_examen = conectar.consultauno("select replace('"&V_CARG_NNOTA_EXAMEN&"',',','.')")
			 nota_repeticion = conectar.consultauno("select replace('"&V_CARG_NNOTA_REPETICION&"',',','.')") 
			 '---- cambio de notas----'
	 			if EXREP>0 then
					if ( V_CARG_NNOTA_EXAMEN<>"" and V_CARG_NNOTA_EXAMEN>V_MALL_NOTA_PRESENTACION ) then
						sqlNF="select replace(protic.CAMBIO_NOTAFINAL('"&request.form(k)&"','"&seccion&"','"&NPFuncion&"','"&V_MALL_PORCENTAJE_PRESENTACION&"','"&V_MALL_PORCENTAJE_EXAMEN&"'),',','.')"
						'response.Write("<br>"&sqlNF)	
						NF=	conectar.consultauno(sqlNF)	
						if NF>"3.95" then
							NFUpdate =	conectar.consultauno("select replace('"&NF&"',',','.')")
							V_EEXA_CCOD_update ="RE"
							V_EEXA_CCOD_REP_update =""
							nota_repeticion=""
							'response.Write("<br>NF "&NF&" NFUpdate "&NFUpdate&" V_EEXA_CCOD_update "&V_EEXA_CCOD_update&" V_EEXA_CCOD_rep_update "&V_EEXA_CCOD_rep_update&" nota_repeticion "&nota_repeticion)
						end if	
					end if
				end if	
			 '-------------------------------------

				 if nf<"3.95" THEN
				 	sitf_ccod ="R"
				 else
				 	if CINT(V_CARG_NASISTENCIA)<CINT(V_MALL_PORCENTAJE_ASISTENCIA) then
						 	sitf_ccod ="R"					
					else
						    sitf_ccod ="A"
					end if
				 end if	
				'response.Write("<br>sift_ccod "&sitf_ccod)
				
			 
				 sentencia = " UPDATE cargas_academicas set SITF_CCOD ='"&sitf_ccod&"'," & vbCrlf & _
				 			   " CARG_NNOTA_PRESENTACION ="&NPFuncion&", " 
							   if nota_examen<>"" then
				 			   		sentencia=sentencia & " CARG_NNOTA_EXAMEN="&nota_examen&", " 
							   else
							   		sentencia=sentencia & " CARG_NNOTA_EXAMEN=NULL, " 
							   end if
							   if nota_repeticion<>"" then
							   		sentencia=sentencia & " CARG_NNOTA_REPETICION = "&nota_repeticion&","
							   else
							   		sentencia=sentencia & " CARG_NNOTA_REPETICION = Null,"
							   end if
							   if NFUpdate <> "" then
							   		sentencia=sentencia & " CARG_NNOTA_FINAL = "&NFUpdate&","
							   else
							   		sentencia=sentencia & " CARG_NNOTA_FINAL = Null,"
							   end if	
				sentencia=sentencia & " AUDI_TUSUARIO = '"&negocio.obtenerusuario&"'," & vbCrlf & _
									  " AUDI_FMODIFICACION = getDate()," & vbCrlf & _
									  " EEXA_CCOD = '"&V_EEXA_CCOD_update&"'," & vbCrlf & _
									  " EEXA_CCOD_REP = '"&V_EEXA_CCOD_REP_update&"'" & vbCrlf & _
									  " WHERE cast(matr_ncorr as varchar)= '"&request.form(k)&"'" & vbCrlf & _
									  " and cast(secc_ccod as varchar)='"&seccion&"'" 
                 'response.Write("<br><pre>3: "&sentencia&"</pre>")  
					

			end if
 			if V_EEXA_CCOD="NP" then
			    if NP >=V_MALL_NOTA_EXIMICION then
				 	NF = NP
					NFUpdate =NPFuncion
					V_CARG_NNOTA_EXAMEN=""
				  	V_CARG_NNOTA_REPETICION =""
				  	V_EEXA_CCOD_update ="EX"
					V_EEXA_REP =""
				'	response.Write("<br>NF "&NF&" NFUpdate "&NFUpdate&" V_EEXA_CCOD_update "&V_EEXA_CCOD_update&" V_EEXA_CCOD_rep_update "&V_EEXA_CCOD_rep_update&" V_CARG_NNOTA_EXAMEN "&V_CARG_NNOTA_EXAMEN&" V_CARG_NNOTA_EXAMEN "&V_CARG_NNOTA_EXAMEN &" V_EEXA_REP "&V_EEXA_REP)
				else
					if NP <V_MALL_NOTA_PRESENTACION then
						V_EEXA_CCOD_update ="SD"
						if (isnull(V_EEXA_CCOD_REP) or isempty(V_EEXA_CCOD_REP) or V_EEXA_CCOD_REP="") then
							if EXREP>0 then
								V_EEXA_CCOD_rep_update ="NP"
								V_EEXA_CCOD_update ="SD"
								NF = "1.0"
								NFUpdate ="1,0"
				'				response.Write("<br>NF "&NF&" NFUpdate "&NFUpdate&" V_EEXA_CCOD_update "&V_EEXA_CCOD_update&" V_EEXA_CCOD_rep_update "&V_EEXA_CCOD_rep_update)
							else
								V_EEXA_CCOD_rep_update =""
								V_EEXA_CCOD_update ="SD"
								NF = "1.0"
								NFUpdate ="1,0"
				'				response.Write("<br>NF "&NF&" NFUpdate "&NFUpdate&" V_EEXA_CCOD_update "&V_EEXA_CCOD_update&" V_EEXA_CCOD_rep_update "&V_EEXA_CCOD_rep_update)
							end if	
						else
							if V_EEXA_CCOD_REP = "NP"then
								NF = "1.0"
								NFUpdate ="1,0"
								V_EEXA_CCOD_rep_update ="NP"
								V_EEXA_CCOD_update ="SD"
				'				response.Write("<br>NF "&NF&" NFUpdate "&NFUpdate&" V_EEXA_CCOD_update "&V_EEXA_CCOD_update&" V_EEXA_CCOD_rep_update "&V_EEXA_CCOD_rep_update)
							else
								sqlNF="select replace(protic.NOTAFINAL('"&request.form(k)&"','"&seccion&"','"&NPFuncion&"','"&V_MALL_PORCENTAJE_PRESENTACION&"','"&V_MALL_PORCENTAJE_EXAMEN&"'),',','.')"
				'				response.Write("<br>sqlNF "&sqlNF)
								NF=	conectar.consultauno(sqlNF)	
								NFUpdate =	conectar.consultauno("select replace('"&NF&"',',','.')")
								V_EEXA_CCOD_rep_update ="RE"
								V_EEXA_CCOD_update ="SD"
				'				response.Write("<br>NF "&NF&" NFUpdate "&NFUpdate&" V_EEXA_CCOD_update "&V_EEXA_CCOD_update&" V_EEXA_CCOD_rep_update "&V_EEXA_CCOD_rep_update)
							end if
						end if
					 else
						 if (isnull(V_EEXA_CCOD_REP) or isempty(V_EEXA_CCOD_REP) or V_EEXA_CCOD_REP="" or V_EEXA_CCOD_REP="NP" ) then	
						 
						 	if EXREP>0 then
						 		NF = "1.0"
								NFUpdate ="1,0"
								V_EEXA_CCOD_rep_update ="NP"
								V_EEXA_CCOD_update ="NP"
				'				response.Write("<br>NF "&NF&" NFUpdate "&NFUpdate&" V_EEXA_CCOD_update "&V_EEXA_CCOD_update&" V_EEXA_CCOD_rep_update "&V_EEXA_CCOD_rep_update)
							else
	 		 				   V_EEXA_CCOD_rep_update =""
								V_EEXA_CCOD_update ="NP"
								NF = "1.0"
								NFUpdate ="1,0"
				'				response.Write("<br>NF "&NF&" NFUpdate "&NFUpdate&" V_EEXA_CCOD_update "&V_EEXA_CCOD_update&" V_EEXA_CCOD_rep_update "&V_EEXA_CCOD_rep_update)
							end if		
						 else
	 		 				    sqlNF="select replace(protic.NOTAFINAL('"&request.form(k)&"','"&seccion&"','"&NPFuncion&"','"&V_MALL_PORCENTAJE_PRESENTACION&"','"&V_MALL_PORCENTAJE_EXAMEN&"'),',','.')"
			'					response.Write("<pre>sqlNF "&sqlNF)
								NF=	conectar.consultauno(sqlNF)	
								NFUpdate =	conectar.consultauno("select replace('"&NF&"',',','.')")	
								V_EEXA_CCOD_update ="NP"		
								V_EEXA_CCOD_REP_update ="RE"
			'					response.Write("<br>NF "&NF&" NFUpdate "&NFUpdate&" V_EEXA_CCOD_update "&V_EEXA_CCOD_update&" V_EEXA_CCOD_rep_update "&V_EEXA_CCOD_rep_update)
						 end if
					 end if
				end if
		         if (isnull(V_CARG_NNOTA_REPETICION) or isempty(V_CARG_NNOTA_REPETICION) or V_CARG_NNOTA_REPETICION="") then
					 	if ( V_CARG_NNOTA_EXAMEN<>"") then
							if (V_CARG_NNOTA_EXAMEN<V_MALL_NOTA_PRESENTACION AND V_EEXA_CCOD_rep<>"NP") Then
								NFUpdate = conectar.consultauno("select replace('"&V_CARG_NNOTA_EXAMEN&"',',','.')")
						 		nf       = V_CARG_NNOTA_EXAMEN
			'					response.Write("<br>NF "&NF&" NFUpdate "&NFUpdate)
							end if
						end if
				 else
				 	if 	V_CARG_NNOTA_REPETICION<V_MALL_NOTA_PRESENTACION then
						 NFUpdate = conectar.consultauno("select replace('"&V_CARG_NNOTA_REPETICION&"',',','.')")
						 nf       = V_CARG_NNOTA_REPETICION
			'			 response.Write("<br>NF "&NF&" NFUpdate "&NFUpdate)
					end if
				 end if
				 '---- cambio de notas----'
	 			if EXREP>0 then
					if ( V_CARG_NNOTA_EXAMEN<>"" and V_CARG_NNOTA_EXAMEN>V_MALL_NOTA_PRESENTACION ) then
						sqlNF="select replace(protic.CAMBIO_NOTAFINAL('"&request.form(k)&"','"&seccion&"','"&NPFuncion&"','"&V_MALL_PORCENTAJE_PRESENTACION&"','"&V_MALL_PORCENTAJE_EXAMEN&"'),',','.')"
						NF=	conectar.consultauno(sqlNF)	
						if NF>"3.95" then
							NFUpdate =	conectar.consultauno("select replace('"&NF&"',',','.')")
							V_EEXA_CCOD_update ="RE"
							V_EEXA_CCOD_REP_update =""
							nota_repeticion=""
			'				response.Write("<br>NF "&NF&" NFUpdate "&NFUpdate&" V_EEXA_CCOD_update "&V_EEXA_CCOD_update&" V_EEXA_CCOD_rep_update "&V_EEXA_CCOD_rep_update&" nota_repeticion "&nota_repeticion)
						end if	
					end if
				end if	
			 '-------------------------------------
				
				 if nf<"3.95" THEN
				 	sitf_ccod ="R"
				 else
				 	if CINT(V_CARG_NASISTENCIA)<CINT(V_MALL_PORCENTAJE_ASISTENCIA) then
						 	sitf_ccod ="R"					
					else
						    sitf_ccod ="A"
					end if
				 end if	
			'	 response.Write("<br>sitf_ccod "&sitf_ccod)
				 
				 nota_examen = conectar.consultauno("select replace('"&V_CARG_NNOTA_EXAMEN&"',',','.')")
				 nota_repeticion = conectar.consultauno("select replace('"&V_CARG_NNOTA_REPETICION&"',',','.')")
			'	 response.Write("<br>nota_examen "&nota_examen&" nota_repeticion "&nota_repeticion)
				 
				 if nota_examen="" then
				    nota_examen=null
			     end if
				 if nota_repeticion ="" then
				 	nota_repeticion=null
				 end if
				 
				 sentencia = " UPDATE cargas_academicas set SITF_CCOD ='"&sitf_ccod&"'," & vbCrlf & _
				 			   " CARG_NNOTA_PRESENTACION ="&NPFuncion&", " 
							   if nota_examen<>"" then
				 			   		sentencia=sentencia & " CARG_NNOTA_EXAMEN="&nota_examen&", " 
							   else
							   		sentencia=sentencia & " CARG_NNOTA_EXAMEN=NULL, " 
							   end if
							   if nota_repeticion<>"" then
							   		sentencia=sentencia & " CARG_NNOTA_REPETICION = "&nota_repeticion&","
							   else
							   		sentencia=sentencia & " CARG_NNOTA_REPETICION = Null,"
							   end if	
							   if NFUpdate <> "" then
							   		sentencia=sentencia & " CARG_NNOTA_FINAL = "&NFUpdate&","
							   else
							   		sentencia=sentencia & " CARG_NNOTA_FINAL = Null,"
							   end if	
				sentencia=sentencia & " AUDI_TUSUARIO = '"&negocio.obtenerusuario&"'," & vbCrlf & _
							   " AUDI_FMODIFICACION = getDate(), " & vbCrlf & _
							   " EEXA_CCOD = '"&V_EEXA_CCOD_update&"'," & vbCrlf & _
							   " EEXA_CCOD_REP = '"&V_EEXA_CCOD_REP_update&"'" & vbCrlf & _
							   " WHERE cast(matr_ncorr as varchar)= '"&request.form(k)&"'" & vbCrlf & _
							   " and cast(secc_ccod as varchar)='"&seccion&"'" 
                'response.Write("<pre>4: "&sentencia&"</pre>")
			end if
			
				'RESPONSE.Write("<br>sentenciaEX :<pre>"&sentencia&"</pre><BR><BR><BR>")
				conectar.EstadoTransaccion conectar.EjecutaS(sentencia)
		end if	
		
	next
								
	
end if
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>