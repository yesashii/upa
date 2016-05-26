<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_evalua.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'-----------------------------------------------------
	'for each k in request.form
	'response.Write(k&" = "&request.Form(k)&"<br>")
	'next
'response.End()

set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar

set f_encuesta_a = new CFormulario
f_encuesta_a.Carga_Parametros "tus_datos.xml", "encabezado"
f_encuesta_a.Inicializar conectar
f_encuesta_a.ProcesaForm
for filai = 0 to f_encuesta_a.CuentaPost - 1
pers_ncorr1 = f_encuesta_a.ObtenerValorPost (filai, "pers_ncorr")



set f_encuesta_ai = new CFormulario
f_encuesta_ai.Carga_Parametros "tus_datos.xml", "encabezado"
f_encuesta_ai.Inicializar conectar
f_encuesta_ai.ProcesaForm
for fila = 0 to f_encuesta_ai.CuentaPost - 1
pers_ncorr = f_encuesta_ai.ObtenerValorPost (fila, "pers_nrut")
tenfer_ccod = f_encuesta_ai.ObtenerValorPost (fila, "tenfer_ccod")
descrip_tenfer = f_encuesta_ai.ObtenerValorPost (fila, "otras")
trabaja = f_encuesta_ai.ObtenerValorPost (fila, "estudia_trabaja")
pers_ncorr = f_encuesta_ai.ObtenerValorPost (fila, "pers_ncorr") 
pers_bdire_correc=f_encuesta_ai.ObtenerValorPost (fila, "dire_corr")
	a_update="update personas set tenfer_ccod='"&tenfer_ccod&"',descrip_tenfer='"&descrip_tenfer&"',trabaja='"&trabaja&"' where pers_ncorr="&pers_ncorr&""
conectar.ejecutaS (a_update)
'response.Write(a_update)
'response.End()

direccion="insert into direccion_correcta (pers_ncorr,pers_bdire_correc) values("&pers_ncorr&",'"&pers_bdire_correc&"')"
conectar.ejecutaS (direccion)
'response.Write(direccion)
'response.End()
  
next


next

	   

if request.Form("fpapa[0][pers_tnombre]") <> "" or request.Form("encu[0][codeudor]")=request.Form("fpapa[0][pers_ncorr]")  then
set f_encuesta_p = new CFormulario
f_encuesta_p.Carga_Parametros "tus_datos.xml", "papa"
f_encuesta_p.Inicializar conectar
f_encuesta_p.ProcesaForm
for filai = 0 to f_encuesta_p.CuentaPost - 1

pers_nrut = f_encuesta_p.ObtenerValorPost (filai, "pers_nrut")
pers_xdv = f_encuesta_p.ObtenerValorPost (filai, "pers_xdv")
pers_ncorr = f_encuesta_p.ObtenerValorPost (filai, "pers_ncorr")
pers_tape_paterno = f_encuesta_p.ObtenerValorPost (filai, "pers_tape_paterno")
pers_tape_materno = f_encuesta_p.ObtenerValorPost (filai, "pers_tape_materno")
pers_tnombre = f_encuesta_p.ObtenerValorPost (filai, "pers_tnombre")
regi_ccod = f_encuesta_p.ObtenerValorPost (filai, "regi_ccod")
ciud_ccod = f_encuesta_p.ObtenerValorPost (filai, "ciud_ccod")
eciv_ccod = f_encuesta_p.ObtenerValorPost (filai, "eciv_ccod")
dire_tcalle = f_encuesta_p.ObtenerValorPost (filai, "dire_tcalle")
dire_tblock = f_encuesta_p.ObtenerValorPost (filai, "dire_tblock")
dire_tpoblacion = f_encuesta_p.ObtenerValorPost (filai, "dire_tpoblacion")
dire_tfono = f_encuesta_p.ObtenerValorPost (filai, "dire_tfono")
dire_tnro=f_encuesta_p.ObtenerValorPost (fila, "dire_tnro")
pers_tcelular = f_encuesta_p.ObtenerValorPost (filai, "pers_tfono")
pers_temail = f_encuesta_p.ObtenerValorPost (filai, "pers_temail")
nedu_ccod = f_encuesta_p.ObtenerValorPost (filai, "nedu_ccod")
sicupadre_ccod = f_encuesta_p.ObtenerValorPost (filai, "sicupadre_ccod")
sitocup_ccod = f_encuesta_p.ObtenerValorPost (filai, "sitocup_ccod")
pare_ccod = f_encuesta_p.ObtenerValorPost (filai, "pare_ccod")
pers_ncorr = f_encuesta_p.ObtenerValorPost (filai, "pers_ncorr")
post_ncorr=f_encuesta_p.ObtenerValorPost (filai, "post_ncorr")


if ciud_ccod ="" then

	ciud_ccod=0
	
	end if
'response.Write(pers_nrut)
 if request.Form("fpapa[0][pers_ncorr]") = ""  then 
	  pers_ncorr=conectar.ConsultaUno("exec ObtenerSecuencia 'personas'")
 	  if request.Form("fmpapa[0][pers_nrut]") = ""  then 
    	pers_nrut = conectar.ConsultaUno("exec ObtenerSecuencia 'personas'")	   
		pers_xdv = conectar.ConsultaUno("select dbo.dv("&pers_nrut&") as dv ")		  
	  end if	  
	  p_insert="insert into personas(pers_ncorr,pers_nrut,pers_xdv,pers_tnombre,pers_tape_paterno,pers_tape_materno,pers_tcelular,pers_temail,nedu_ccod,sicupadre_ccod,sitocup_ccod,eciv_ccod) values("&pers_ncorr&","&pers_nrut&",'"&pers_xdv&"','"&pers_tnombre&"','"&pers_tape_paterno&"','"&pers_tape_materno&"','"&pers_tcelular&"','"&pers_temail&"','"&nedu_ccod&"','"&sicupadre_ccod&"','"&sitocup_ccod&"',"&eciv_ccod&")"		  
	  'response.Write("<pre>"&p_insert&"</pre>")
	  conectar.ejecutaS (p_insert)
	
	  gfp_insert="insert into grupo_familiar (post_ncorr,pers_ncorr,pare_ccod) values("&post_ncorr&","&pers_ncorr&",'"&pare_ccod&"')"
	  'response.Write ("<pre>"&gfp_insert&"</pre>")
	  conectar.ejecutaS (gfp_insert)
	
 	  dp_insert = "insert into direcciones (tdir_ccod,pers_ncorr,dire_tcalle, dire_tblock, dire_tpoblacion, dire_tnro,ciud_ccod) values(1,"&pers_ncorr&",'"&dire_tcalle&"','"&dire_tblock&"','"&dire_tpoblacion&"','"&dire_tnro&"',"&ciud_ccod&")" 
	  'response.Write ("<pre>"&dp_insert&"</pre>")
	  conectar.ejecutaS (dp_insert)
  else
	
	persona_grp=conectar.consultaUno("select case count (*) when 0 then 'NO' else 'SI' end  from grupo_familiar where cast(pers_ncorr as varchar) ='"&pers_ncorr&"' ")
	'response.Write ("<pre>"&persona_grp&"</pre>")
	
	p_update="update personas set nedu_ccod='"&nedu_ccod&"', sicupadre_ccod='"&sicupadre_ccod&"', sitocup_ccod='"&sitocup_ccod&"' where pers_ncorr="&pers_ncorr&""
	'response.Write ("<pre>"&p_update&"</pre>")
	conectar.ejecutaS (p_update)
  end if
	
  if persona_grp ="NO" then
	 gfp_insert="insert into grupo_familiar (post_ncorr,pers_ncorr,pare_ccod) values("&post_ncorr&","&pers_ncorr&",'"&pare_ccod&"')"
	 'response.Write("<pre>"&gfp_insert&"</pre>")
	 conectar.ejecutaS (gfp_insert)
  end if
'response.Write("rut ="&pers_nrut)	
'response.Write("rut ="&pers_xdv)
'response.Write("rut ="&pers_ncorr)



	
next


end if




if request.Form("fmama[0][pers_tnombre]")<> "" or request.Form("encu[0][codeudor]")=request.Form("fmama[0][pers_ncorr]") then
set f_encuesta_m = new CFormulario
f_encuesta_m.Carga_Parametros "tus_datos.xml", "mama"
f_encuesta_m.Inicializar conectar
f_encuesta_m.ProcesaForm

for fila = 0 to f_encuesta_m.CuentaPost - 1

pers_nrut = f_encuesta_m.ObtenerValorPost (fila, "pers_nrut")
pers_xdv = f_encuesta_m.ObtenerValorPost (fila, "pers_xdv")
pers_ncorr = f_encuesta_m.ObtenerValorPost (fila, "pers_ncorr")
pers_tape_paterno = f_encuesta_m.ObtenerValorPost (fila, "pers_tape_paterno")
pers_tape_materno = f_encuesta_m.ObtenerValorPost (fila, "pers_tape_materno")
pers_tnombre = f_encuesta_m.ObtenerValorPost (fila, "pers_tnombre")
regi_ccod = f_encuesta_m.ObtenerValorPost (fila, "regi_ccod")
ciud_ccod = f_encuesta_m.ObtenerValorPost (fila, "ciud_ccod")
eciv_ccod = f_encuesta_m.ObtenerValorPost (fila, "eciv_ccod")
dire_tcalle = f_encuesta_m.ObtenerValorPost (fila, "dire_tcalle")
dire_tblock = f_encuesta_m.ObtenerValorPost (fila, "dire_tblock")
dire_tpoblacion = f_encuesta_m.ObtenerValorPost (fila, "dire_tpoblacion")
dire_tfono = f_encuesta_m.ObtenerValorPost (fila, "dire_tfono")
dire_tnro=f_encuesta_m.ObtenerValorPost (fila, "dire_tnro")
pers_tcelular = f_encuesta_m.ObtenerValorPost (fila, "pers_tfono")
pers_temail = f_encuesta_m.ObtenerValorPost (fila, "pers_temail")
nedu_ccod = f_encuesta_m.ObtenerValorPost (fila, "nedu_ccod")
sicupadre_ccod = f_encuesta_m.ObtenerValorPost (fila, "sicupadre_ccod")
sitocup_ccod = f_encuesta_m.ObtenerValorPost (fila, "sitocup_ccod")
pare_ccod = f_encuesta_m.ObtenerValorPost (fila, "pare_ccod")
pers_ncorr = f_encuesta_m.ObtenerValorPost (fila, "pers_ncorr")
post_ncorr=f_encuesta_m.ObtenerValorPost (fila, "post_ncorr")

if ciud_ccod ="" then

	ciud_ccod=0
	
	end if
	
 if request.Form("fmama[0][pers_ncorr]") = ""  then 
	pers_ncorr=conectar.ConsultaUno("exec ObtenerSecuencia 'personas'")
    if request.Form("fmama[0][pers_nrut]") = ""  then 
		pers_nrut = conectar.ConsultaUno("exec ObtenerSecuencia 'personas'")	   
	    pers_xdv = conectar.ConsultaUno("select dbo.dv("&pers_nrut&") as dv ")		  
	end if	  
	m_insert="insert into personas(pers_ncorr,pers_nrut,pers_xdv,pers_tnombre,pers_tape_paterno,pers_tape_materno,pers_tcelular,pers_temail,nedu_ccod,sicupadre_ccod,sitocup_ccod,eciv_ccod) values("&pers_ncorr&","&pers_nrut&",'"&pers_xdv&"','"&pers_tnombre&"','"&pers_tape_paterno&"','"&pers_tape_materno&"','"&pers_tcelular&"','"&pers_temail&"','"&nedu_ccod&"','"&sicupadre_ccod&"','"&sitocup_ccod&"',"&eciv_ccod&")"		  
	'response.Write("<pre>"&m_insert&"</pre>")
	conectar.ejecutaS (m_insert)
	
	gfm_insert="insert into grupo_familiar (post_ncorr,pers_ncorr,pare_ccod) values("&post_ncorr&","&pers_ncorr&",'"&pare_ccod&"')"
	'response.Write ("<pre>"&gfm_insert&"</pre>")
	conectar.ejecutaS (gfm_insert)
	
	
	
	dm_insert = "insert into direcciones (tdir_ccod,pers_ncorr,dire_tcalle, dire_tblock, dire_tpoblacion, dire_tnro,ciud_ccod) values('1',"&pers_ncorr&",'"&dire_tcalle&"','"&dire_tblock&"','"&dire_tpoblacion&"','"&dire_tnro&"',"&ciud_ccod&")"
	conectar.ejecutaS (dm_insert)
	'response.Write ("<pre>"&dm_insert&"</pre>")
else
	persona_grm=conectar.consultaUno("select case count (*) when 0 then 'NO' else 'SI' end  from grupo_familiar where cast(pers_ncorr as varchar) ='"&pers_ncorr&"' ")
	'response.Write ()("<pre>"&persona_gr&"</pre>")
	
	m_update="update personas set nedu_ccod='"&nedu_ccod&"', sicupadre_ccod='"&sicupadre_ccod&"', sitocup_ccod='"&sitocup_ccod&"' where pers_ncorr="&pers_ncorr&" "
	'response.Write ("<pre>"&m_update&"</pre>")
	conectar.ejecutaS (m_update)
	
end if
	
	if persona_grm ="NO" then
	 gfm_insert="insert into grupo_familiar (post_ncorr,pers_ncorr,pare_ccod) values("&post_ncorr&","&pers_ncorr&",'"&pare_ccod&"')"
	 'response.Write ("<pre>"&gfm_insert&"</pre>")
	 conectar.ejecutaS (gfm_insert)
	end if
'response.Write("rut ="&pers_nrut)	
'response.Write("rut ="&pers_xdv)
'response.Write("rut ="&pers_ncorr)



	
next

end if


 if request.Form("fhermano1[0][pers_tnombre]")<> "" then

set f_encuesta_hI = new CFormulario
f_encuesta_hI.Carga_Parametros "tus_datos.xml", "hermano1"
f_encuesta_hI.Inicializar conectar
f_encuesta_hI.ProcesaForm
for fila = 0 to f_encuesta_hI.CuentaPost - 1

pers_nrut = f_encuesta_hI.ObtenerValorPost (fila, "pers_nrut")
pers_xdv = f_encuesta_hI.ObtenerValorPost (fila, "pers_xdv")
pers_ncorr = f_encuesta_hI.ObtenerValorPost (fila, "pers_ncorr")
pers_tape_paterno = f_encuesta_hI.ObtenerValorPost (fila, "pers_tape_paterno")
pers_tape_materno = f_encuesta_hI.ObtenerValorPost (fila, "pers_tape_materno")
pers_tnombre = f_encuesta_hI.ObtenerValorPost (fila, "pers_tnombre")
regi_ccod = f_encuesta_hI.ObtenerValorPost (fila, "regi_ccod")
ciud_ccod = f_encuesta_hI.ObtenerValorPost (fila, "ciud_ccod")
eciv_ccod = f_encuesta_hI.ObtenerValorPost (fila, "eciv_ccod")
dire_tcalle = f_encuesta_hI.ObtenerValorPost (fila, "dire_tcalle")
dire_tblock = f_encuesta_hI.ObtenerValorPost (fila, "dire_tblock")
dire_tpoblacion = f_encuesta_hI.ObtenerValorPost (fila, "dire_tpoblacion")
dire_tfono = f_encuesta_hI.ObtenerValorPost (fila, "dire_tfono")
dire_tnro=f_encuesta_hI.ObtenerValorPost (fila, "dire_tnro")
pers_tcelular = f_encuesta_hI.ObtenerValorPost (fila, "pers_tfono")
pers_temail = f_encuesta_hI.ObtenerValorPost (fila, "pers_temail")
nedu_ccod = f_encuesta_hI.ObtenerValorPost (fila, "nedu_ccod")
sicupadre_ccod = f_encuesta_hI.ObtenerValorPost (fila, "sicupadre_ccod")
sitocup_ccod = f_encuesta_hI.ObtenerValorPost (fila, "sitocup_ccod")
pare_ccod = f_encuesta_hI.ObtenerValorPost (fila, "pare_ccod")
pers_ncorr = f_encuesta_hI.ObtenerValorPost (fila, "pers_ncorr")
post_ncorr=f_encuesta_hI.ObtenerValorPost (fila, "post_ncorr")
pers_fnacimiento=f_encuesta_hI.ObtenerValorPost (fila, "pers_fnacimiento")
 if request.Form("fhermano1[0][pers_ncorr]") = ""  then 
		  
		  pers_ncorr=conectar.ConsultaUno("exec ObtenerSecuencia 'personas'")
 if request.Form("fhermano1[0][pers_nrut]") = ""  then 
		pers_nrut = conectar.ConsultaUno("exec ObtenerSecuencia 'personas'")	   
		  pers_xdv = conectar.ConsultaUno("select dbo.dv("&pers_nrut&") as dv ")		  
	end if	  
	
	
hi_insert="insert into personas(pers_ncorr,pers_nrut,pers_xdv,pers_tnombre,pers_tape_paterno,pers_tape_materno,sicupadre_ccod,pers_fnacimiento) values("&pers_ncorr&","&pers_nrut&",'"&pers_xdv&"','"&pers_tnombre&"','"&pers_tape_paterno&"','"&pers_tape_materno&"','"&sicupadre_ccod&"','"&pers_fnacimiento&"')"		  
'response.Write("perssonas  "&hi_insert)
conectar.ejecutaS (hi_insert)
	
	gfhi_insert="insert into grupo_familiar (post_ncorr,pers_ncorr,pare_ccod) values("&post_ncorr&","&pers_ncorr&",'"&pare_ccod&"')"
'	response.Write ("familia"&gfhi_insert)
conectar.ejecutaS (gfhi_insert)
	

		end if
		
'response.Write("rut ="&pers_nrut)	
'response.Write("rut ="&pers_xdv)
'response.Write("rut ="&pers_ncorr)



	
next
end if


 if request.Form("fhermano2[0][pers_tnombre]")<> "" then

set f_encuesta_hII = new CFormulario
f_encuesta_hII.Carga_Parametros "tus_datos.xml", "hermano2"
f_encuesta_hII.Inicializar conectar
f_encuesta_hII.ProcesaForm
for fila = 0 to f_encuesta_hII.CuentaPost - 1

pers_nrut = f_encuesta_hII.ObtenerValorPost (fila, "pers_nrut")
pers_xdv = f_encuesta_hII.ObtenerValorPost (fila, "pers_xdv")
pers_ncorr = f_encuesta_hII.ObtenerValorPost (fila, "pers_ncorr")
pers_tape_paterno = f_encuesta_hII.ObtenerValorPost (fila, "pers_tape_paterno")
pers_tape_materno = f_encuesta_hII.ObtenerValorPost (fila, "pers_tape_materno")
pers_tnombre = f_encuesta_hII.ObtenerValorPost (fila, "pers_tnombre")
regi_ccod = f_encuesta_hII.ObtenerValorPost (fila, "regi_ccod")
ciud_ccod = f_encuesta_hII.ObtenerValorPost (fila, "ciud_ccod")
eciv_ccod = f_encuesta_hII.ObtenerValorPost (fila, "eciv_ccod")
dire_tcalle = f_encuesta_hII.ObtenerValorPost (fila, "dire_tcalle")
dire_tblock = f_encuesta_hII.ObtenerValorPost (fila, "dire_tblock")
dire_tpoblacion = f_encuesta_hII.ObtenerValorPost (fila, "dire_tpoblacion")
dire_tfono = f_encuesta_hII.ObtenerValorPost (fila, "dire_tfono")
dire_tnro=f_encuesta_hI.ObtenerValorPost (fila, "dire_tnro")
pers_tcelular = f_encuesta_hII.ObtenerValorPost (fila, "pers_tfono")
pers_temail = f_encuesta_hII.ObtenerValorPost (fila, "pers_temail")
nedu_ccod = f_encuesta_hII.ObtenerValorPost (fila, "nedu_ccod")
sicupadre_ccod = f_encuesta_hII.ObtenerValorPost (fila, "sicupadre_ccod")
sitocup_ccod = f_encuesta_hII.ObtenerValorPost (fila, "sitocup_ccod")
pare_ccod = f_encuesta_hII.ObtenerValorPost (fila, "pare_ccod")
pers_ncorr = f_encuesta_hII.ObtenerValorPost (fila, "pers_ncorr")
post_ncorr=f_encuesta_hII.ObtenerValorPost (fila, "post_ncorr")
pers_fnacimiento=f_encuesta_hII.ObtenerValorPost (fila, "pers_fnacimiento")
if request.Form("fhermano2[0][pers_ncorr]") = ""  then 
		  
		  pers_ncorr=conectar.ConsultaUno("exec ObtenerSecuencia 'personas'")
 if request.Form("fhermano2[0][pers_nrut]") = ""  then 
	pers_nrut = conectar.ConsultaUno("exec ObtenerSecuencia 'personas'")	   
		  pers_xdv = conectar.ConsultaUno("select dbo.dv("&pers_nrut&") as dv ")		  
	end if	  
	
	
hii_insert="insert into personas(pers_ncorr,pers_nrut,pers_xdv,pers_tnombre,pers_tape_paterno,pers_tape_materno,sicupadre_ccod,pers_fnacimiento) values("&pers_ncorr&","&pers_nrut&",'"&pers_xdv&"','"&pers_tnombre&"','"&pers_tape_paterno&"','"&pers_tape_materno&"','"&sicupadre_ccod&"','"&pers_fnacimiento&"')"		  
'response.Write("perssonas  "&hi_insert)
conectar.ejecutaS (hii_insert)
	
	gfhii_insert="insert into grupo_familiar (post_ncorr,pers_ncorr,pare_ccod) values("&post_ncorr&","&pers_ncorr&",'"&pare_ccod&"')"
'	response.Write ("familia"&gfhi_insert)
conectar.ejecutaS (gfhii_insert)


		end if
		
'response.Write("rut ="&pers_nrut)	
'response.Write("rut ="&pers_xdv)
'response.Write("rut ="&pers_ncorr)



	
next
end if


 if request.Form("fhermano3[0][pers_tnombre]")<> "" then

set f_encuesta_hIII = new CFormulario
f_encuesta_hIII.Carga_Parametros "tus_datos.xml", "hermano3"
f_encuesta_hIII.Inicializar conectar
f_encuesta_hIII.ProcesaForm
for fila = 0 to f_encuesta_hIII.CuentaPost - 1

pers_nrut = f_encuesta_hIII.ObtenerValorPost (fila, "pers_nrut")
pers_xdv = f_encuesta_hIII.ObtenerValorPost (fila, "pers_xdv")
pers_ncorr = f_encuesta_hIII.ObtenerValorPost (fila, "pers_ncorr")
pers_tape_paterno = f_encuesta_hIII.ObtenerValorPost (fila, "pers_tape_paterno")
pers_tape_materno = f_encuesta_hIII.ObtenerValorPost (fila, "pers_tape_materno")
pers_tnombre = f_encuesta_hIII.ObtenerValorPost (fila, "pers_tnombre")
regi_ccod = f_encuesta_hIII.ObtenerValorPost (fila, "regi_ccod")
ciud_ccod = f_encuesta_hIII.ObtenerValorPost (fila, "ciud_ccod")
eciv_ccod = f_encuesta_hIII.ObtenerValorPost (fila, "eciv_ccod")
dire_tcalle = f_encuesta_hIII.ObtenerValorPost (fila, "dire_tcalle")
dire_tblock = f_encuesta_hIII.ObtenerValorPost (fila, "dire_tblock")
dire_tpoblacion = f_encuesta_hIII.ObtenerValorPost (fila, "dire_tpoblacion")
dire_tfono = f_encuesta_hIII.ObtenerValorPost (fila, "dire_tfono")
dire_tnro=f_encuesta_hIII.ObtenerValorPost (fila, "dire_tnro")
pers_tcelular = f_encuesta_hIII.ObtenerValorPost (fila, "pers_tfono")
pers_temail = f_encuesta_hIII.ObtenerValorPost (fila, "pers_temail")
nedu_ccod = f_encuesta_hIII.ObtenerValorPost (fila, "nedu_ccod")
sicupadre_ccod = f_encuesta_hIII.ObtenerValorPost (fila, "sicupadre_ccod")
sitocup_ccod = f_encuesta_hIII.ObtenerValorPost (fila, "sitocup_ccod")
pare_ccod = f_encuesta_hIII.ObtenerValorPost (fila, "pare_ccod")
pers_ncorr = f_encuesta_hIII.ObtenerValorPost (fila, "pers_ncorr")
post_ncorr=f_encuesta_hIII.ObtenerValorPost (fila, "post_ncorr")
pers_fnacimiento=f_encuesta_hIII.ObtenerValorPost (fila, "pers_fnacimiento")
if request.Form("fhermano3[0][pers_ncorr]") = ""  then 
		  
		 pers_ncorr=conectar.ConsultaUno("exec ObtenerSecuencia 'personas'")
 if request.Form("fhermano3[0][pers_nrut]") = ""  then 
		pers_nrut = conectar.ConsultaUno("exec ObtenerSecuencia 'personas'")	   
		  pers_xdv = conectar.ConsultaUno("select dbo.dv("&pers_nrut&") as dv ")		  
	end if	  
	
	
hiii_insert="insert into personas(pers_ncorr,pers_nrut,pers_xdv,pers_tnombre,pers_tape_paterno,pers_tape_materno,sicupadre_ccod,pers_fnacimiento) values("&pers_ncorr&","&pers_nrut&",'"&pers_xdv&"','"&pers_tnombre&"','"&pers_tape_paterno&"','"&pers_tape_materno&"','"&sicupadre_ccod&"','"&pers_fnacimiento&"')"		  
'response.Write("perssonas  "&hi_insert)
conectar.ejecutaS (hiii_insert)
	
	gfhiii_insert="insert into grupo_familiar (post_ncorr,pers_ncorr,pare_ccod) values("&post_ncorr&","&pers_ncorr&",'"&pare_ccod&"')"
	'response.Write ("familia"&gfhi_insert)
 conectar.ejecutaS (gfhiii_insert)
	

		end if
		
'response.Write("rut ="&pers_nrut)	
'response.Write("rut ="&pers_xdv)
'response.Write("rut ="&pers_ncorr)



	
next
end if



Respuesta = conectar.ObtenerEstadoTransaccion()
'----------------------------------------------------
'response.Write("respuesta "&Respuesta)
'if Respuesta = true then
'session("mensajeerror")= "Resultados ingresados con Éxito"
'else
  'session("mensajeerror")= "Error al guadar los resultados"
'end if
'response.End()

'response.Redirect(request.ServerVariables("HTTP_REFERER"))
response.Redirect("menu_salida.asp")
%>


