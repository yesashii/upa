<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<% 

'for each k in request.form
	'response.Write(k&" = "&request.Form(k)&"<br>")
	'ofer_ncorr = request.Form(k)
'next



set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()

set f_postulantes = new Cformulario
f_postulantes.Carga_Parametros "genera_contrato_1.xml", "postulacion"
f_postulantes.Inicializar conexion
f_postulantes.ProcesaForm

f_postulantes.agregacampopost "post_ncorr",request.Form("post_ncorr")

q_post_ncorr=request.Form("post_ncorr")
v_peri_ccod=negocio.obtenerPeriodoAcademico("Postulacion")


for fila = 0 to (f_postulantes.CuentaPost - 1)

	
	v_ofer_ncorr	= f_postulantes.ObtenerValorPost (fila, "ofer_ncorr")
	
	v_tiene_contrato	= f_postulantes.ObtenerValorPost (fila, "tiene_contrato")
   
	v_post_ncorr	= f_postulantes.ObtenerValorPost (fila, "post_ncorr")
	
			
	if v_post_ncorr <> "" and v_ofer_ncorr <> "" and v_tiene_contrato="N" then
		
		'*****************************
		'Actualiza tabla postulante
		sql_actualiza="update POSTULANTES set OFER_NCORR = "&v_ofer_ncorr&", AUDI_FMODIFICACION = getdate(), AUDI_TUSUARIO= '"&v_usuario&"' where POST_NCORR = "&v_post_ncorr&" "
		conexion.EjecutaS(sql_actualiza)
		
		'verifica cupo
		sql_sin_cupo="select ofer_bactiva from ofertas_academicas where ofer_ncorr="&v_ofer_ncorr
		v_tiene_cupo= conexion.consultaUno(sql_sin_cupo)
		
		
		if v_tiene_cupo="N" then
			session("mensajeError")="La Carrera Selecccionada no esta activa para matriculas, \nes probable que no disponga de cupos suficientes"
			response.Redirect(request.ServerVariables("HTTP_REFERER"))
		end if
		'*****************************
   
	'########################################################################################
	'  Inicio Matricula Anticipada
	'########################################################################################

	' se quito esta funcionalidad buscar en archivos de respaldo anteriores al 12-12-2007	

	'########################################################################################
	'  Fin Matricula Anticipada
	'########################################################################################
		v_post_nuevo=conexion.consultaUno("Select post_bnuevo from postulantes where post_ncorr="&v_post_ncorr&" ")
	end if
next



'f_postulantes.MantieneTablas true

'----------------------------------------------------------------------------------------------------------------------------------
'------------------------------------------AGREGAR DESCUENTOS POR PASE MATRICULA----------------------------------------------------
'response.Write("<br>v_post_nuevo = "&v_post_nuevo)

if v_post_nuevo <> "S" then
	sql_cantidad_pases="Select count(*) from postulantes a, pase_matricula b "& vbCrLf &_ 
		" where cast(a.post_ncorr as varchar)='"&q_post_ncorr&"' "& vbCrLf &_
		" and cast(a.peri_ccod as varchar)='"&v_peri_ccod&"'" & vbCrLf &_ 
		" and a.pers_ncorr=b.pers_ncorr "& vbCrLf &_ 
		" and a.post_ncorr=b.post_ncorr "
							
	cantidad_pases=conexion.consultaUno(sql_cantidad_pases)

	carrera=conexion.consultaUno("Select c.carr_ccod from postulantes a, ofertas_academicas b,especialidades c,detalle_postulantes d where cast(a.post_ncorr as varchar)='"&q_post_ncorr&"' and a.post_ncorr=d.post_ncorr and d.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod")
	tipo_carrera= conexion.consultaUno("Select tcar_ccod from carreras where cast(carr_ccod as varchar)='"&carrera&"'")

	'---------------------busca si existe un pase_matricula para esa carrera y ese usuario en el periodo dado
	consulta=" Select 1 from postulantes a, pase_matricula b,ofertas_academicas c,especialidades d "& vbCrLf &_ 
		" where cast(a.post_ncorr as varchar)='"&q_post_ncorr&"'"& vbCrLf &_ 
		" and a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
		" and a.post_ncorr=b.post_ncorr "& vbCrLf &_ 
		" and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"'"& vbCrLf &_
		" and b.ofer_ncorr=c.ofer_ncorr "& vbCrLf &_ 
		" and c.espe_ccod=d.espe_ccod "& vbCrLf &_    
		" and cast(d.carr_ccod as varchar)='"&carrera&"'"
	'response.Write("<pre>"&consulta&"</pre>")	
	'response.End()		  
	encontrado=conexion.consultaUno(consulta) 
	ofer_ncorr=conexion.consultaUno("Select ofer_ncorr from postulantes  where cast(post_ncorr as varchar)='"&q_post_ncorr&"'")
	
	if cantidad_pases > "0"  and encontrado="1" then
		'response.Write("<br>encontrado"&encontrado)
	     
		porc_matricula_01=" Select pama_nporc_matricula from postulantes a, pase_matricula b,ofertas_academicas c,especialidades d "& vbCrLf &_ 
			" where cast(a.post_ncorr as varchar)='"&q_post_ncorr&"'"& vbCrLf &_ 
	        " and a.pers_ncorr=b.pers_ncorr and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"'"& vbCrLf &_
			" and b.ofer_ncorr=c.ofer_ncorr and c.espe_ccod=d.espe_ccod "& vbCrLf &_    
			" and cast(d.carr_ccod as varchar)='"&carrera&"'"
								 
		porc_colegiatura_01=" Select pama_nporc_colegiatura from postulantes a, pase_matricula b,ofertas_academicas c,especialidades d "& vbCrLf &_ 
			" where cast(a.post_ncorr as varchar)='"&q_post_ncorr&"'"& vbCrLf &_ 
			" and a.pers_ncorr=b.pers_ncorr and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"'"& vbCrLf &_
			" and b.ofer_ncorr=c.ofer_ncorr and c.espe_ccod=d.espe_ccod "& vbCrLf &_    
			" and cast(d.carr_ccod as varchar)='"&carrera&"'"
		  
		p_matricula=clng(conexion.consultaUno(porc_matricula_01))/100
		p_colegiatura=clng(conexion.consultaUno(porc_colegiatura_01))/100
		  
		valor_real_matricula=conexion.consultaUno("select isnull(aran_mmatricula,0) from ofertas_academicas a, aranceles b where cast(a.ofer_ncorr as varchar)='"&ofer_ncorr&"' and a.aran_ncorr=b.aran_ncorr")
		valor_real_colegiatura=conexion.consultaUno("select aran_mcolegiatura from ofertas_academicas a, aranceles b where cast(a.ofer_ncorr as varchar)='"&ofer_ncorr&"' and a.aran_ncorr=b.aran_ncorr")
		sql_matr="select isnull(aran_mmatricula,0) from ofertas_academicas a, aranceles b where cast(a.ofer_ncorr as varchar)='"&ofer_ncorr&"' and a.aran_ncorr=b.aran_ncorr"
		  
		descuento_matricula=clng(valor_real_matricula)* p_matricula
		descuento_colegiatura=clng(valor_real_colegiatura)* p_colegiatura
		  
		buscar_descuento_pase=conexion.consultaUno("select count(*) from sdescuentos where cast(post_ncorr as varchar)='"&q_post_ncorr&"' and cast(stde_ccod as varchar)='1262'")    	 
	      
		if buscar_descuento_pase = "0" then
		  
			'se debe ingresar un nuevo registro en la tabla sdescuentos con el contenido de ese pase matricula		  
			'response.Write("<br>buscar_descuento_pase "&buscar_descuento_pase)
			tipo_descuento=1262
			consulta_insercion="INSERT INTO sdescuentos(stde_ccod,post_ncorr,ofer_ncorr,esde_ccod,sdes_mmatricula,sdes_mcolegiatura,sdes_nporc_matricula,sdes_nporc_colegiatura,sdes_tobservaciones, audi_tusuario, audi_fmodificacion) "& vbCrLf  &_  
				" Select "&tipo_descuento&","&q_post_ncorr&","&ofer_ncorr&",1,"&descuento_matricula&","&descuento_colegiatura&",pama_nporc_matricula,pama_nporc_colegiatura,pama_tobservaciones,'traspaso-pactacion',getDate() "& vbCrLf  &_  
				" from postulantes a, pase_matricula b,ofertas_academicas c,especialidades d where cast(a.post_ncorr as varchar)='"&q_post_ncorr&"'"& vbCrLf &_ 
				" and a.pers_ncorr=b.pers_ncorr and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"'"& vbCrLf &_
				" and b.ofer_ncorr=c.ofer_ncorr and c.espe_ccod=d.espe_ccod and a.post_ncorr=b.post_ncorr "& vbCrLf &_    
				" and cast(d.carr_ccod as varchar)='"&carrera&"'"
			'response.Write("<br><pre>"&consulta_insercion&"</pre>")	
			'response.End()				 
			conexion.EstadoTransaccion conexion.EjecutaS(consulta_insercion)	
		else
			'se debe modificar el registro de sdescuentos con la nueva información del pase matricula
 
			descripcion_01=" Select pama_tobservaciones from postulantes a, pase_matricula b,ofertas_academicas c,especialidades d where cast(a.post_ncorr as varchar)='"&q_post_ncorr&"'"& vbCrLf &_ 
				" and a.pers_ncorr=b.pers_ncorr and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"'"& vbCrLf &_
				" and b.ofer_ncorr=c.ofer_ncorr and c.espe_ccod=d.espe_ccod "& vbCrLf &_    
				" and cast(d.carr_ccod as varchar)='"&carrera&"'"					 
								 
			consulta_actualizacion=" UPDATE sdescuentos "& vbCrLf  &_ 
				" SET sdes_mmatricula = "&descuento_matricula&", "& vbCrLf  &_ 
				"	  sdes_nporc_matricula = "&conexion.consultaUno(porc_matricula_01)&", "& vbCrLf  &_
				"	  sdes_mcolegiatura = "&descuento_colegiatura&", "& vbCrLf  &_ 					
				"	  sdes_nporc_colegiatura = "&conexion.consultaUno(porc_colegiatura_01)&", "& vbCrLf  &_
				"	  sdes_tobservaciones = '"&conexion.consultaUno(descripcion_01)&"', "& vbCrLf  &_
				"     audi_tusuario = 'traspaso-pactacion', "& vbCrLf  &_ 
				"     audi_fmodificacion = getdate() "& vbCrLf  &_ 
				" WHERE cast(post_ncorr as varchar)='"&q_post_ncorr&"'"& vbCrLf  &_ 
				"  and stde_ccod = '1262'"
			'response.Write("<br><pre>"&consulta_actualizacion&"</pre>")					 						
			conexion.EstadoTransaccion conexion.EjecutaS(consulta_actualizacion)							
		end if
		'---------------Agregamos la condición para el caso en que el alumno aun no tiene un pase------------- 
		'----------------------de matricula y debe sacarlo pa poder matricularse (26-11-2004)-----------------
	else
		'response.Write("este estudiante no tiene pase de matricula")
		
		v_pers_ncorr=conexion.consultaUno("Select pers_ncorr from postulantes where cast(post_ncorr as varchar)='"&q_post_ncorr&"'")
		v_pers_nrut=conexion.consultaUno("Select pers_nrut from personas where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"'")
		v_pers_xdv=conexion.consultaUno("Select pers_xdv from personas where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"'")
		'las carreras profesionales cuya matricula sea anterior a 3 años el periodo actual y aquellas carreras técnicas con 1 año de diferencia deben tener pase matricula
		' vale decir si el periodo de matricula es para el año 2005 auqellas carreras profesionales cuyos alumno se halla matriculado por 1° vez en el 2002
		' debe tener un pase dematricula y en el caso de la técnicas auqellas cuyo matricula sea anterior al 2004 tambien deben generar.
		diferencia_carrera=conexion.consultaUno(" Select isnull(anos_pase_matricula,0) from carreras where cast(carr_ccod as varchar)='"&carrera&"'")
		'response.Write(" Select anos_pase_matricula from carreras where cast(carr_ccod as varchar)='"&carrera&"'")
		consulta_primer_periodo=" select top 1 isnull(min(b.peri_ccod),"&v_peri_ccod&") as periodo "& vbCrLf  &_  
			" from postulantes a,ofertas_academicas b, periodos_academicos c, especialidades d,detalle_postulantes e"& vbCrLf  &_ 
			" where cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"' "& vbCrLf  &_ 
			" and a.post_ncorr=e.post_ncorr"& vbCrLf  &_ 
			" and e.ofer_ncorr=b.ofer_ncorr"& vbCrLf  &_ 
			" and b.peri_ccod=c.peri_ccod "& vbCrLf  &_ 
			" and b.espe_ccod=d.espe_ccod"& vbCrLf  &_ 
			" and cast(d.carr_ccod as varchar)='"&carrera&"'"& vbCrLf  &_
			" and exists (select 1 from alumnos alu where alu.post_ncorr=a.post_ncorr and alu.emat_ccod <> 9)"& vbCrLf  &_ 
			" order by periodo desc "
		'response.Write("<pre>"&consulta_primer_periodo&"</pre>") 
		primer_periodo = conexion.consultaUno(consulta_primer_periodo)
			
		primer_ano=conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&primer_periodo&"'")
		anio_admision=conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&v_peri_ccod&"'")			
		diferencia_anos=conexion.consultaUno("Select cast(isnull("&anio_admision&",datepart(year,getdate())) as numeric)-cast("&primer_ano&" as numeric)")
		'response.Write("<br>primer_ano ="&primer_ano&" diferencia_anos= "&diferencia_anos&" diferencia_carrera "&diferencia_carrera)
		if cstr(diferencia_anos)>=cstr(diferencia_carrera) and cint(diferencia_carrera)>0 then
			v_necesita_pase=true
			'response.Write("<br>El estudiante debe tener un pase de matricula")
			'response.End()
			ruta_devuelta="genera_contrato_1.asp?busqueda[0][pers_nrut]="&v_pers_nrut&"&busqueda[0][pers_xdv]="&v_pers_xdv&"&devuelto=1"
			'conexion.MensajeError "El alumno no registra información de pases de matricula\n y en su condición es necesario antes de generar el contrato."
	        Response.Redirect(ruta_devuelta)
		else
			v_necesita_pase=false	
			'response.Write("<br>El estudiante no cumple los requisitos para generarle un pase de matricula")	
		end if
	end if
	'-----------------------------------------FIN DEL AGREGA DESCUENTOS PASE MATRICULA-------------------------------------------------
	'----------------------------------------------------------------------------------------------------------------------------------
end if ' Fin condicion que evalua si es alumno nuevo
'response.Write("genera_contrato_2.asp?post_ncorr=" & request.Form("post_ncorr"))
'response.end

response.Redirect("genera_contrato_2.asp?post_ncorr=" & request.Form("post_ncorr") )
%>
