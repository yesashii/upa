<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
 Session.Timeout = 20 
 'response.Redirect("maq_postulacion_1.asp")

 '<<<<<<<<<<<<Ir a buscar cuál es el período activo >>>>>>>>>>>>>>>>
 set conectar = new CConexion
 conectar.inicializar "desauas"
 
 
 set per = new CNegocio
 per.AsignaConexion conectar
 periodo_actual = per.obtenerPeriodoAcademico("POSTULACION")
 
 
' session("sesion_periodo_academico") = periodo_actual
 '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 		 
		 
 usuario = ucase(trim(request.Form("usuario")))
 clave   = trim(request.Form("clave"))
 
 texto = " select pers_ncorr from usuarios where usua_tusuario = '"& usuario &"' " _
       & " and usua_tclave = '"& clave &"' " 
 pers_ncorr_us = conectar.consultaUno(texto)	   
 
 if isNull(pers_ncorr_us) then ' No está registrado...
     session("mensajeError") = "El USUARIO y la CLAVE ingresada no coinciden."
     response.Redirect("inicio.asp")	 
 else
	 session("ses_correlativo") = corr_pers
	 
     texto = " select Upper(pers_tnombre || ' ' || pers_tape_paterno || ' ' || pers_tape_materno) as nombre " _
	       & " from personas_postulante where pers_ncorr=" & corr_pers
     nombre_usuario	= conectar.consultaUno(texto) 
	 
     'session("ses_nombre") = nombre_usuario
   	 
     'Veremos si tiene una postulacion para este periodo y su estado(en proceso, enviado)
	 set form_postulacion = new cformulario
     form_postulacion.carga_parametros "tabla_vacia.xml", "tabla"
     form_postulacion.inicializar conectar
	  
     texto = " select post_ncorr, ofer_ncorr,epos_ccod, tpos_ccod " _
	       & " from postulantes " _
	       & " where pers_ncorr= " & corr_pers _
		   & " and peri_ccod = " & periodo_actual
		   
     form_postulacion.Consultar texto
     form_postulacion.Siguiente
	 
	 
     if form_postulacion.NroFilas = 0 then
		  '-------------------------------------------------------------------------------------------------
		  ' Obtenemos el correlativo para post_ncorr desde la secuencia.
		  texto2 = "select post_ncorr_seq.nextval as corr from dual"
		  corr_post_ncorr  = conectar.consultaUno(texto2)
		  corr_postulacion = corr_post_ncorr
		  session("ses_post_ncorr") = corr_post_ncorr
		 
          '------¿Es alumno antiguo? -------------------------------------------------------------
		  texto_alumno= " select * from( " _
		              & " select ofer_ncorr from alumnos a " _
			 		  & " where pers_ncorr = "& corr_pers &" " _
			 		  & " and emat_ccod = 1 " _
			 		  & " order by alum_fmatricula desc " _
					  & " ) where rownum = 1 "
		  es_alumno = conectar.consultaUno(texto_alumno)
		 
		  if isNull(es_alumno) then ' No es alumno.
			   post_bnuevo     = "S"
			   oferta_actual   = "NULL"
		  else
			   post_bnuevo     = "N"
			   ' Buscaremos la sede y carrera de la oferta antigua.-------------------------------
			   set f_nueva_oferta = new cformulario
               f_nueva_oferta.carga_parametros "tabla_vacia.xml", "tabla"
               f_nueva_oferta.inicializar conectar
			   
			   texto = " select  a.sede_ccod, b.carr_ccod " _
			         & " from ofertas_academicas a, especialidades b" _
					 & " where  a.ofer_ncorr = " & es_alumno _
					 & " and a.espe_ccod = b.espe_ccod" 
			   f_nueva_oferta.consultar texto
               f_nueva_oferta.siguiente	 
			   
			   sede_anterior = f_nueva_oferta.obtenerValor("sede_ccod")
			   carr_anterior = f_nueva_oferta.obtenerValor("carr_ccod")
			   
			   ' Ahora hay que buscar la oferta de este periodo, que coincida con la oferta antigua.
			   consulta2 = " select a.ofer_ncorr " _
                         & " from ofertas_academicas a, aranceles b, especialidades c " _
                         & " where a.SEDE_CCOD	= "& sede_anterior &" " _
                         & " and a.PERI_CCOD = "& periodo_actual  _
                         & " and a.ofer_ncorr = b.ofer_ncorr " _
                         & " and b.aran_nano_ingreso is null " _
                         & " and a.espe_ccod = c.espe_ccod" _
                         & " and c.carr_ccod = '"& carr_anterior &"' " _
                         & " order by ofer_ncorr "
			   resp_ofer_actual = conectar.consultaUno(consulta2)
		   
		       if not isNull(resp_ofer_actual) then
		            oferta_actual = resp_ofer_actual
		       else	 ' No existe una oferta actual, con los datos de la oferta antigua
		            oferta_actual = "NULL"
			        post_bnuevo     = "S"
		       end if
		  end if
		 
		 '---- Ahora insertamos un registro en postulantes---------------------------------------------------------
		 
		  insertar = " insert into postulantes(pers_ncorr,post_ncorr,epos_ccod,peri_ccod, " _
		           & " ofer_Ncorr, post_bnuevo, tpos_ccod, audi_tusuario, audi_fmodificacion) " _
		           & " values("& corr_pers &","& corr_postulacion &",1, "& periodo_actual &", " _
			 	   &   oferta_actual &", '"& post_bnuevo &"', 1 , 'Internet', sysdate )"
		  conectar.EstadoTransaccion conectar.EjecutaS (insertar)
		  
     else	 	
	      tpos_ccod  = trim(form_postulacion.ObtenerValor("tpos_ccod"))
	      if tpos_ccod <> "1" then '-- Alumno Empresa ---
			   session("mensajeError") = "Su tipo de postulación no le permite entrar a este sistema."
               response.Redirect("inicio.asp")
		  else	 
		       post_ncorr  = trim(form_postulacion.ObtenerValor("post_ncorr"))
			   
			   			   
			   matr_ncorr_cons = " select matr_ncorr from alumnos " _
			                   & " where post_ncorr='" & post_ncorr & "' and emat_ccod=1"
			   matr_ncorr = conectar.consultaUno(matr_ncorr_cons)
			  
			   if isNull(matr_ncorr) then ' -- No está matriculado
				   session("ses_post_ncorr") = post_ncorr
				   
				   epos_ccod  = trim(form_postulacion.ObtenerValor("epos_ccod"))
				   
				   if epos_ccod = "2" then ' el postulante ya ha enviado su postulacion
					  redireccion = "post_cerrada.asp"
				   else
					  redireccion = "principal.asp"	
				   end if
			   else
				   session("ses_matr_ncorr") = matr_ncorr
				   session("ses_post_ncorr") = post_ncorr
				   redireccion = "principal_alumno.asp"
			   end if 
			   response.redirect(redireccion)
		  end if	   
     end if
  END IF  
  
  response.Redirect("principal.asp" )
%>