<!-- #include file = "../biblioteca/conexion.asp" -->
<!-- #include file = "../biblioteca/_inacap.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
 correlativo  = session("ses_correlativo") ' Corrlelativo Persona
 corr_postulante = session("ses_post_ncorr") ' Correlativo Postulante 
 if correlativo = "" then
   response.Redirect("denegado.asp")
 end if
 
 '<<<<<<<<<<<<Ir a buscar cuál es el período activo >>>>>>>>>>>>>>>>
 set conectar = new cconexion
 conectar.inicializar "siga"
 
 set per = new cInacap 
 per.AsignaConexion conectar
 periodo_actual = per.obtenerPeriodoAcademico("POSTULACION")
 '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
 
 'Postulante es alumno antiguo??
  texto_alumno = " select * from( " _
               & " select a.ofer_ncorr,  c.carr_ccod " _
               & " from alumnos a , ofertas_academicas b, especialidades c " _
               & " where a.pers_ncorr = " & correlativo _
               & " and a.emat_ccod = 1 " _
               & " and a.ofer_ncorr = b.ofer_ncorr " _
               & " and b.espe_ccod = c.espe_ccod " _
               & " order by alum_fmatricula desc " _
               & " ) where rownum = 1 "
'  response.Write(texto_alumno)			   
  set rs_alu_antiguo = conexion(texto_alumno)
  
  if  rs_alu_antiguo.EOF then ' Es postulante nuevo
       ' Le mostraremos todas las ofertas de postulantes nuevos
       redireccion = "postulacion1.asp"
  else
       carrera_antigua = trim(rs_alu_antiguo("carr_ccod"))
	   oferta_antigua  = trim(rs_alu_antiguo("ofer_ncorr"))
       'Veremos si la oferta es de alumno nuevo o antiguo.
	   consulta_nuevo = " select c.carr_ccod , a.POST_BNUEVO" _
                      & " from postulantes a, ofertas_academicas b, especialidades c " _
                      & " where a.post_ncorr = " & corr_postulante _
                      & " and  a.ofer_ncorr = b.ofer_ncorr " _
                      & " and  b.espe_ccod = c.espe_ccod "
	   set rs_cons_nuevo = conexion(consulta_nuevo)
	 
	   if rs_cons_nuevo.EOF then ' Tiene oferta Nula
'-----------------------Si oferta esta nula, calcula oferta actual; si no la encuentra, la ingresa nula  --------
            post_bnuevo     = "N"
		   
		    ' Buscaremos la sede y carrera de la oferta antigua.
			texto = " select  a.sede_ccod, b.carr_ccod " _
			         & " from ofertas_academicas a, especialidades b" _
					 & " where  a.ofer_ncorr = " & oferta_antigua _
					 & " and a.espe_ccod = b.espe_ccod"
					 	  
		    set rs_nueva_oferta = conexion(texto)
		    sede_anterior = rs_nueva_oferta("sede_ccod")
		    carr_anterior = rs_nueva_oferta("carr_ccod")
		    rs_nueva_oferta.close : set rs_nueva_oferta = nothing
		   
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
						 
		    set resp_ofer_actual = conexion(consulta2)
	   
	        if not resp_ofer_actual.eof then
		         oferta_actual = resp_ofer_actual("ofer_ncorr")
	        else	 ' No existe una oferta actual, con los datos de la oferta antigua
		         oferta_actual = "NULL"
		         post_bnuevo     = "S"
	        end if
	        resp_ofer_actual.close  :  set resp_ofer_actual = nothing	   
	 
	        ' Ahora actualizamos un registro en postulantes
	        modif = " update postulantes set ofer_Ncorr= "& oferta_actual &", post_bnuevo= '" & post_bnuevo & "'" _
                  & " where post_ncorr=" & corr_postulante
	        set rs_modif = conexion(modif) : set rs_modif = nothing
'-----------------------------------------------------------------------------------------------------------      
	        if post_bnuevo = "N" then
	            redireccion = "postulacion11.asp"
		    else
		        redireccion = "postulacion1.asp"
		    end if	  
	   else
	       carrera_nueva = trim(rs_cons_nuevo("carr_ccod"))
		
		   if carrera_antigua =  carrera_nueva then 'Es alumno antiguo
		       redireccion = "postulacion11.asp"	
		   else ' Postulante nuevo...
		       redireccion = "postulacion1.asp"
		   end if
	   end if
	   rs_cons_nuevo.close : set rs_cons_nuevo = nothing
  end if
  rs_alu_antiguo.close  :  set rs_alu_antiguo = nothing
  response.Redirect(redireccion)
%>