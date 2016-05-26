<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pare_ccod = Request("pare_ccod")

v_post_ncorr = Session("post_ncorr")
act_antecedentes = Session("ses_act_ancedentes") 
'response.Write("pare_ccod= "&q_pare_ccod&" post_ncorr= "&v_post_ncorr)
if EsVacio(v_post_ncorr) then
	Response.Redirect("inicio.asp")
end if


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Postulación - Apoderado Sostenedor"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'---------------------------------------------------------------------------------------------------


Sql_parientes_minimos = " Select count(*) as total " & VBCRLF  	& _
				" from postulantes pos, grupo_familiar gf, personas_postulante pp, parentescos pa " & VBCRLF  	& _
				" Where pos.post_ncorr='"&v_post_ncorr&"' " & VBCRLF  	& _
				" And pos.post_ncorr=gf.post_ncorr " & VBCRLF  	& _
				" And gf.pers_ncorr=pp.pers_ncorr " & VBCRLF  	& _
				" And gf.pare_ccod=pa.pare_ccod " & VBCRLF  	& _
				" And gf.pare_ccod not in (0) "
v_parientes =conexion.ConsultaUno(Sql_parientes_minimos)
'v_parientes="1" ' descomentar para dejarlo pasar sin parientes
'response.Write("<pre>"&Sql_parientes_minimos&"</pre>")
'response.End()
if v_parientes <= "0" and sys_exige_familiar=true then
	Response.Redirect("postulacion_4.asp")
end if


Sql_parientes_conteo=" Select count(*) as cantidad " & VBCRLF  	& _
						" from postulantes pos, grupo_familiar gf, personas_postulante pp " & VBCRLF  	& _
						" Where pos.post_ncorr='"&v_post_ncorr&"' " & VBCRLF  	& _
						" And pos.post_ncorr=gf.post_ncorr " & VBCRLF  	& _
						" And gf.pers_ncorr=pp.pers_ncorr " 
						
v_cantidad_parientes=conexion.consultaUno(Sql_parientes_conteo)
'response.Write(v_cantidad_parientes)
' ****************** COMPLETA LA INFORMACION DE LOS PARIENTES YA INGRESADOS	 ***************************
if v_cantidad_parientes=0 then

	sql_actualiza= " Insert into grupo_familiar (POST_NCORR,PERS_NCORR,PARE_CCOD,AUDI_TUSUARIO,AUDI_FMODIFICACION,GRUP_NINDEPENDIENTE)" & VBCRLF  	& _
					" select '"&v_post_ncorr&"' as post_ncorr,pers_ncorr,pare_ccod,'completa info.' as audi_tusuario, " & VBCRLF  	& _
					" getdate() as audi_fmodificacion, null as grup_nindependiente " & VBCRLF  	& _
					" from ( " & VBCRLF  	& _
					" select distinct pers_ncorr,pare_ccod  " & VBCRLF  	& _
					" from grupo_familiar  " & VBCRLF  	& _
					" where post_ncorr in (select post_ncorr " & VBCRLF  	& _
					"                    from postulantes  " & VBCRLF  	& _
					"                        where pers_ncorr in (select pers_ncorr " & VBCRLF  	& _
					"                                            from postulantes " & VBCRLF  	& _
					"                                            where post_ncorr='"&v_post_ncorr&"') " & VBCRLF  	& _
					"                     ) " & VBCRLF  	& _
					" ) as tabla "                                           
	
	conexion.ejecutaS(sql_actualiza)
	'response.Write("<pre>"&sql_actualiza&"</pre>")
			
end if


v_pais_ccod=conexion.consultauno("select a.pais_ccod from personas_postulante a,postulantes b where a.pers_ncorr=b.pers_ncorr and cast(b.post_ncorr as varchar)='"&v_post_ncorr&"'")
'response.Write("paissss "&v_pais_ccod)
if v_pais_ccod<>"" and q_pare_ccod<>"" then
	if cint(v_pais_ccod) = 1 and cint(q_pare_ccod) = 0 then
		criterio_direccion=1
	elseif cint(v_pais_ccod) <> 1 and cint(q_pare_ccod) = 0 then
		criterio_direccion=2
	else
    	criterio_direccion=1		
	end if
else
criterio_direccion=1		
end if
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "postulacion_5.xml", "botonera"


'---------------------------------------------------------------------------------------------------
set f_codeudor = new CFormulario
f_codeudor.Carga_Parametros "postulacion_5.xml", "codeudor"
f_codeudor.Inicializar conexion

if EsVacio(q_pare_ccod) then
	v_pare_ccod = conexion.ConsultaUno("select pare_ccod from codeudor_postulacion where post_ncorr = '" & v_post_ncorr & "'")
else
	v_pare_ccod = q_pare_ccod
end if

if EsVacio(v_pare_ccod) then
	v_pare_ccod="null"
	filtro ="1=2"
else
	filtro = "1=1"
end if

v_pariente_grupofamiliar=conexion.ConsultaUno("select case count(*) when 0 then 'N' else 'S' end as está"& vbCrLf &_
												"from codeudor_postulacion a where a.post_ncorr='" & v_post_ncorr & "'"& vbCrLf &_
											"and exists(select 1 from grupo_familiar b where a.post_ncorr=b.post_ncorr and a.pers_ncorr=b.pers_ncorr)")
											
v_pare_ccod_codeudor = conexion.ConsultaUno("select isnull(pare_ccod,0) from codeudor_postulacion where post_ncorr = '" & v_post_ncorr & "'")
 
if EsVacio(q_pare_ccod) then
	q_pare_ccod = v_pare_ccod
end if

if EsVacio(v_pare_ccod_codeudor) then
	v_pare_ccod_codeudor="0"
end if

'response.Write(v_pariente_grupofamiliar)
'response.Write(" v_pare_ccod_codeudor ="&v_pare_ccod_codeudor&" ")
'response.Write(" q_pare_ccod="&q_pare_ccod)
'response.Write("y"&v_pare_ccod_codeudor)
'response.End()


if v_pariente_grupofamiliar = "S" then

	if EsVacio(q_pare_ccod) then
		q_pare_ccod="0"
	end if


	if q_pare_ccod = "0" then
	
	consulta = "select  pos.post_ncorr,'" & v_pare_ccod & "' as pare_ccod, per.pers_ncorr,eciv_ccod,pers_nrut, pers_xdv,pers_tnombre, pers_tape_paterno,pers_tape_materno , pers_fnacimiento,ifam_ccod, alab_ccod, nedu_ccod,pers_tprofesion, pers_tempresa,pers_temail,"& vbCrLf &_
				  "dp.dire_tcalle,dp.dire_tnro,dp.dire_tblock,dp.dire_tpoblacion,dp.dire_tfono,dp.ciud_ccod,(select e.regi_ccod from direcciones_publica d, ciudades e where d.ciud_ccod = e.ciud_ccod and d.pers_ncorr = per.pers_ncorr and cast(d.tdir_ccod as varchar)= '1' ) as regi_ccod,"& vbCrLf &_
				  "dp2.dire_tcalle as dire_tcalle_empresa, dp2.dire_tnro as dire_tnro_empresa,dp2.dire_tpoblacion  as dire_tpoblacion_empresa,dp2.dire_tfono as              dire_tfono_empresa,dp2.ciud_ccod as ciud_ccod_empresa  "  & vbCrLf &_ 
				 "from  postulantes pos"& vbCrLf &_
				 "join personas_postulante per"& vbCrLf &_
				  "on post_ncorr='"&v_post_ncorr&"' "& vbCrLf &_
				  "and pos.pers_ncorr=per.pers_ncorr"& vbCrLf &_
				 "join direcciones_publica dp"& vbCrLf &_
				  "on dp.pers_ncorr=per.pers_ncorr"& vbCrLf &_
				  "and tdir_ccod = 1"& vbCrLf &_
				  "join direcciones_publica dp2"& vbCrLf &_
				 "on dp2.pers_ncorr=per.pers_ncorr"& vbCrLf &_
				"and dp2.tdir_ccod = 3" 
		
	 
	  
	  
	 else
	 
	  consulta = "select  post_ncorr,'" & v_pare_ccod & "' as pare_ccod, gf.pers_ncorr,eciv_ccod,pers_nrut, pers_xdv,pers_tnombre, pers_tape_paterno,pers_tape_materno ,pers_fnacimiento,ifam_ccod, alab_ccod, nedu_ccod,pers_tprofesion, pers_tempresa,pers_temail," & vbCrLf &_
			   "dp.dire_tcalle,dp.dire_tnro,dp.dire_tblock,dp.dire_tpoblacion,dp.dire_tfono,dp.ciud_ccod ,(select e.regi_ccod from direcciones_publica d, ciudades e where d.ciud_ccod = e.ciud_ccod and d.pers_ncorr = per.pers_ncorr and cast(d.tdir_ccod as varchar)= '1' ) as regi_ccod," & vbCrLf &_
			  " dp2.dire_tcalle as dire_tcalle_empresa, dp2.dire_tnro as dire_tnro_empresa,dp2.dire_tpoblacion  as dire_tpoblacion_empresa,dp2.dire_tfono as            dire_tfono_empresa,dp2.ciud_ccod as ciud_ccod_empresa " & vbCrLf &_    
				"from grupo_familiar gf " & vbCrLf &_
				"left outer join personas_postulante per" & vbCrLf &_
				"on per.pers_ncorr=gf.pers_ncorr" & vbCrLf &_
			   " and cast(gf.pare_ccod as varchar)='"&v_pare_ccod&"' "& vbCrLf &_
				"and cast(post_ncorr as varchar)= '"&v_post_ncorr&"' "& vbCrLf &_
				"join direcciones_publica dp"  & vbCrLf &_
				"on dp.pers_ncorr=per.pers_ncorr" & vbCrLf &_
				"and tdir_ccod = 1" & vbCrLf &_
				"join direcciones_publica dp2" & vbCrLf &_
				"on dp2.pers_ncorr=per.pers_ncorr" & vbCrLf &_
			   "and dp2.tdir_ccod = 3"
	 end if 
 
 
else ' Si no esta en Grupo  Familiar
 

 
	if Cstr(q_pare_ccod) <> Cstr(v_pare_ccod_codeudor) then
	 
	
		 if q_pare_ccod = "0" then
		 
			 consulta = "select  pos.post_ncorr,'" & v_pare_ccod & "' as pare_ccod, per.pers_ncorr,eciv_ccod,pers_nrut, pers_xdv,pers_tnombre, pers_tape_paterno,pers_tape_materno , pers_fnacimiento,ifam_ccod, alab_ccod, nedu_ccod,pers_tprofesion, pers_tempresa,pers_temail,"& vbCrLf &_
						  "dp.dire_tcalle,dp.dire_tnro,dp.dire_tblock,dp.dire_tpoblacion,dp.dire_tfono,dp.ciud_ccod,(select e.regi_ccod from direcciones_publica d, ciudades e where d.ciud_ccod = e.ciud_ccod and d.pers_ncorr = per.pers_ncorr and cast(d.tdir_ccod as varchar)= '1' ) as regi_ccod,"& vbCrLf &_
						  "dp2.dire_tcalle as dire_tcalle_empresa, dp2.dire_tnro as dire_tnro_empresa,dp2.dire_tpoblacion  as dire_tpoblacion_empresa,dp2.dire_tfono as             dire_tfono_empresa,dp2.ciud_ccod as ciud_ccod_empresa  "  & vbCrLf &_ 
						 "from  postulantes pos"& vbCrLf &_
						 "join personas_postulante per"& vbCrLf &_
						  "on post_ncorr='"&v_post_ncorr&"' "& vbCrLf &_
						  "and pos.pers_ncorr=per.pers_ncorr"& vbCrLf &_
						"join direcciones_publica dp"& vbCrLf &_
						 "on dp.pers_ncorr=per.pers_ncorr"& vbCrLf &_
						 "and tdir_ccod = 1"& vbCrLf &_
						  "join direcciones_publica dp2"& vbCrLf &_
						 "on dp2.pers_ncorr=per.pers_ncorr"& vbCrLf &_
						"and dp2.tdir_ccod = 3" 
		else
			  consulta = "select  post_ncorr,'" & v_pare_ccod & "' as pare_ccod, gf.pers_ncorr,eciv_ccod,pers_nrut, pers_xdv,pers_tnombre, pers_tape_paterno,pers_tape_materno ,pers_fnacimiento,ifam_ccod, alab_ccod, nedu_ccod,pers_tprofesion, pers_tempresa,pers_temail," & vbCrLf &_
					   "dp.dire_tcalle,dp.dire_tnro,dp.dire_tblock,dp.dire_tpoblacion,dp.dire_tfono,dp.ciud_ccod ,(select e.regi_ccod from direcciones_publica d, ciudades e where d.ciud_ccod = e.ciud_ccod and d.pers_ncorr = per.pers_ncorr and cast(d.tdir_ccod as varchar)= '1' ) as regi_ccod," & vbCrLf &_
					  " dp2.dire_tcalle as dire_tcalle_empresa, dp2.dire_tnro as dire_tnro_empresa,dp2.dire_tpoblacion  as dire_tpoblacion_empresa,dp2.dire_tfono as            dire_tfono_empresa,dp2.ciud_ccod as ciud_ccod_empresa " & vbCrLf &_    
						"from grupo_familiar gf " & vbCrLf &_
						"left outer join personas_postulante per" & vbCrLf &_
						"on per.pers_ncorr=gf.pers_ncorr" & vbCrLf &_
					   " and cast(gf.pare_ccod as varchar)='"&v_pare_ccod&"' "& vbCrLf &_
						"and cast(post_ncorr as varchar)= '"&v_post_ncorr&"' "& vbCrLf &_
						"join direcciones_publica dp"  & vbCrLf &_
						"on dp.pers_ncorr=per.pers_ncorr" & vbCrLf &_
						"and tdir_ccod = 1" & vbCrLf &_
						"join direcciones_publica dp2" & vbCrLf &_
						"on dp2.pers_ncorr=per.pers_ncorr" & vbCrLf &_
					  "and dp2.tdir_ccod = 3"
		 end if 		
	 
	else
	 
	  consulta = "select distinct cp.post_ncorr, cp.pare_ccod, gf.pers_ncorr,eciv_ccod,pers_nrut, pers_xdv,pers_tnombre, pers_tape_paterno,pers_tape_materno ,pers_fnacimiento,ifam_ccod, alab_ccod, nedu_ccod,pers_tprofesion, pers_tempresa,pers_temail,"& vbCrLf &_
				"dp.dire_tcalle,dp.dire_tnro,dp.dire_tblock,dp.dire_tpoblacion,dp.dire_tfono,dp.ciud_ccod,(select e.regi_ccod from direcciones_publica d, ciudades e where d.ciud_ccod = e.ciud_ccod and d.pers_ncorr = per.pers_ncorr and cast(d.tdir_ccod as varchar)= '1' ) as regi_ccod,"& vbCrLf &_
				 "dp2.dire_tcalle as dire_tcalle_empresa, dp2.dire_tnro as dire_tnro_empresa,dp2.dire_tpoblacion  as dire_tpoblacion_empresa,dp2.dire_tfono as "& vbCrLf &_     
				 "dire_tfono_empresa,dp2.ciud_ccod as ciud_ccod_empresa "& vbCrLf &_
				"from codeudor_postulacion cp"& vbCrLf &_
				"left outer join grupo_familiar gf"& vbCrLf &_
				"on cp.pers_ncorr=gf.pers_ncorr"& vbCrLf &_
				"join personas_postulante per"& vbCrLf &_
				"on per.pers_ncorr=cp.pers_ncorr"& vbCrLf &_
				"and cast(cp.post_ncorr as varchar)= '"&v_post_ncorr&"' "& vbCrLf &_
				"join direcciones_publica dp"& vbCrLf &_
				"on dp.pers_ncorr=per.pers_ncorr"& vbCrLf &_
				"and tdir_ccod = 1"& vbCrLf &_
				"join direcciones_publica dp2"& vbCrLf &_
				"on dp2.pers_ncorr=per.pers_ncorr"& vbCrLf &_
				"and dp2.tdir_ccod = 3"
	  
	end if
   
end if
  
 'response.Write("<pre>"&consulta&"</pre>") 
 
v_pers_nrut = Request.Form("codeudor[0][pers_nrut]")
v_pers_xdv = Request.Form("codeudor[0][pers_xdv]")
if v_pers_nrut <> "" then
	pers_ncorr_codeudor = conexion.consultaUno("Select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&v_pers_nrut&"'")
	consulta =  " select b.eciv_ccod,'" & v_post_ncorr & "' as post_ncorr, '" & v_pare_ccod & "' as pare_ccod, b.pers_ncorr, " & vbCrLf &_
				"  b.pers_nrut,b.pers_xdv, b.pers_tnombre, b.pers_tape_paterno,b.pers_tape_materno,b.pers_fnacimiento,b.ifam_ccod,b.alab_ccod," & vbCrLf &_
				" b.nedu_ccod,b.pers_tprofesion,b.pers_tempresa,b.pers_tcargo, " & vbCrLf &_
				" (select d.dire_tcalle from direcciones_publica d where d.pers_ncorr = b.pers_ncorr and cast(d.tdir_ccod as varchar)= '"&criterio_direccion&"') as dire_tcalle, " & vbCrLf &_
				" (select d.dire_tnro from direcciones_publica d where d.pers_ncorr = b.pers_ncorr and cast(d.tdir_ccod as varchar)= '"&criterio_direccion&"') as dire_tnro, " & vbCrLf &_
				" (select d.dire_tblock from direcciones_publica d where d.pers_ncorr = b.pers_ncorr and cast(d.tdir_ccod as varchar)= '"&criterio_direccion&"') as dire_tblock, " & vbCrLf &_
				" (select d.dire_tpoblacion from direcciones_publica d where d.pers_ncorr = b.pers_ncorr and cast(d.tdir_ccod as varchar)= '"&criterio_direccion&"') as dire_tpoblacion, " & vbCrLf &_
				" (select d.dire_tfono from direcciones_publica d where d.pers_ncorr = b.pers_ncorr and cast(d.tdir_ccod as varchar)= '"&criterio_direccion&"') as dire_tfono, " & vbCrLf &_
				" (select d.ciud_ccod from direcciones_publica d where d.pers_ncorr = b.pers_ncorr and cast(d.tdir_ccod as varchar)= '"&criterio_direccion&"') as ciud_ccod, " & vbCrLf &_
				" (select e.regi_ccod from direcciones_publica d, ciudades e where d.ciud_ccod = e.ciud_ccod and d.pers_ncorr = b.pers_ncorr and cast(d.tdir_ccod as varchar)= '"&criterio_direccion&"' ) as regi_ccod, " & vbCrLf &_
				" (select f.dire_tcalle from direcciones_publica f where f.pers_ncorr = b.pers_ncorr and f.tdir_ccod = 3) as dire_tcalle_empresa, " & vbCrLf &_
				" (select f.dire_tnro from direcciones_publica f where f.pers_ncorr = b.pers_ncorr and f.tdir_ccod = 3) as dire_tnro_empresa, " & vbCrLf &_
				" (select f.dire_tpoblacion from direcciones_publica f where f.pers_ncorr = b.pers_ncorr and f.tdir_ccod = 3) as dire_tpoblacion_empresa, " & vbCrLf &_
				" (select f.dire_tfono from direcciones_publica f where f.pers_ncorr = b.pers_ncorr and f.tdir_ccod = 3) as dire_tfono_empresa, " & vbCrLf &_
				" (select f.ciud_ccod from direcciones_publica f where f.pers_ncorr = b.pers_ncorr and f.tdir_ccod = 3) as ciud_ccod_empresa, " & vbCrLf &_
				" (select g.regi_ccod from direcciones_publica f, ciudades g where f.ciud_ccod = g.ciud_ccod and f.pers_ncorr = b.pers_ncorr and f.tdir_ccod = 3 ) as regi_ccod_empresa " & vbCrLf &_
				" from personas_postulante b" & vbCrLf &_
				" where cast(b.pers_ncorr as varchar)='"&pers_ncorr_codeudor&"'"
				
end if
'response.Write("<pre>"&consulta&"</pre>") 
f_codeudor.Consultar consulta

 if f_codeudor.nroFilas = 0 and v_pers_nrut <> "" then
 	f_codeudor.AgregaCampoCons "pers_nrut",v_pers_nrut
	f_codeudor.AgregaCampoCons "pers_xdv",v_pers_xdv
 end if 
 
f_codeudor.Siguientef


'---------------------------------------------------------------------------------------------------
consulta_ciudades = "select regi_ccod, ciud_ccod, ciud_tdesc, ciud_tcomuna from ciudades order by ciud_tdesc asc"

'-------------------------------------------------------------------------------------
v_epos_ccod = conexion.ConsultaUno("select epos_ccod from postulantes where post_ncorr = '" & v_post_ncorr & "'")

if v_epos_ccod = "2" then
	lenguetas_postulacion = Array(Array("Información general", "postulacion_1.asp"), Array("Datos Personales", "postulacion_2.asp"), Array("Ant. Académicos", "postulacion_3.asp"), Array("Ant. Familiares", "postulacion_4.asp"), Array("Apoderado Sostenedor", "postulacion_5.asp"))
	msjRecordatorio = "Se ha detectado que esta postulación ya ha sido enviada.  Si va a realizar cambios en la información de esta página, presione el botón ""Siguiente"" para guardarlos."
else
	lenguetas_postulacion = Array("Información general", "Datos Personales", "Ant. Académicos", "Ant. Familiares", "Apoderado Sostenedor", "Envío de Postulación")
	msjRecordatorio = ""
end if

if	not EsVacio(act_antecedentes) and act_antecedentes = "S" then
	lenguetas_postulacion = Array(Array("Información general", "postulacion_antiguo.asp"), Array("Datos Personales", "postulacion_2.asp"), Array("Ant. Académicos", "postulacion_3.asp"), Array("Ant. Familiares", "postulacion_4.asp"), Array("Apoderado Sostenedor", "postulacion_5.asp"))
	msjRecordatorio = "Si va a realizar cambios en la información de esta página, presione el botón ""Siguiente"" para guardarlos."
end if
		

'---------- CONSULTA PARA SUGERIR DIRECCION DEL ALUMNO POSTULANTE-------------------------------
set f_alumno_direccion = new CFormulario
f_alumno_direccion.Carga_Parametros "postulacion_4.xml", "direccion_postulante"
f_alumno_direccion.Inicializar conexion
consulta_direccion= " select g.regi_ccod, g.ciud_ccod, f.dire_tcalle,f.dire_tnro, f.dire_tblock,f.dire_tpoblacion,f.dire_tfono"& VBCRLF  	& _ 
					" from direcciones_publica f , postulantes pos, ciudades g "& VBCRLF  	& _
    				" where f.pers_ncorr = pos.pers_ncorr"& VBCRLF  	& _
					" and f.ciud_ccod = g.ciud_ccod"& VBCRLF  	& _
    				" And pos.post_ncorr="&v_post_ncorr&_
    				" and f.tdir_ccod  = 1 "
'response.Write(consulta_direccion)
f_alumno_direccion.Consultar consulta_direccion
f_alumno_direccion.SiguienteF

%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript" src="../biblioteca/dicc_ciudades.js"></script>
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>


<script language="JavaScript">
var t_padre;
function Validar()
{
	formulario = document.edicion;
	
	rut_codeudor = formulario.elements["codeudor[0][pers_nrut]"].value + "-" + formulario.elements["codeudor[0][pers_xdv]"].value;	
	if (!valida_rut(rut_codeudor)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["codeudor[0][pers_xdv]"].focus();
		formulario.elements["codeudor[0][pers_xdv]"].select();
		return false;
	}
	

	return true;
}



function CopiarDireccionParticular()
{
	/*
v_ciudad	=	document.edicion.elements['test[0][ciud_ccod]'].value;
v_region	=   document.edicion.elements["test[0][regi_ccod]"].value;
if ((!v_ciudad)||(!v_region)){
	alert("El postulante no presenta su direccion completa");
	return false;
}else{
	t_padre.AsignarValor(0, "regi_ccod", v_region);

	_FiltrarCombobox(document.edicion.elements["codeudor[0][ciud_ccod]"], 
	                 document.edicion.elements["codeudor[0][regi_ccod]"].value,
					 d_ciudades,
					 'regi_ccod',
					 'ciud_ccod',
					 'ciud_tdesc',
					 '+v_ciudad+');

		t_padre.AsignarValor(0, "ciud_ccod", document.edicion.elements['test[0][ciud_ccod]'].value);
		t_padre.AsignarValor(0, "dire_tcalle", document.edicion.elements['test[0][dire_tcalle]'].value);
		t_padre.AsignarValor(0, "dire_tnro", document.edicion.elements['test[0][dire_tnro]'].value);
		t_padre.AsignarValor(0, "dire_tblock", document.edicion.elements['test[0][dire_tblock]'].value);
		t_padre.AsignarValor(0, "dire_tpoblacion", document.edicion.elements['test[0][dire_tpoblacion]'].value);
		t_padre.AsignarValor(0, "dire_tfono", document.edicion.elements['test[0][dire_tfono]'].value);*/
		
		v_ciudad	=	document.edicion.elements['test[0][ciud_ccod]'].value;
		v_region	=   document.edicion.elements["test[0][regi_ccod]"].value;
		if ((!v_ciudad)||(!v_region)){
			alert("El postulante no presenta su direccion completa");
			return false;
		}else{
	//t_padre.AsignarValor(0, "regi_ccod", v_region);

	_FiltrarCombobox(document.edicion.elements["codeudor[0][ciud_ccod]"], 
	                 document.edicion.elements["codeudor[0][regi_ccod]"].value,
					 d_ciudades,
					 'regi_ccod',
					 'ciud_ccod',
					 'ciud_tdesc',
					 '+v_ciudad+');
					 
					 
		b=document.edicion.elements["test[0][dire_tcalle]"].value;
		c=document.edicion.elements["test[0][dire_tnro]"].value;
		d=document.edicion.elements["test[0][dire_tblock]"].value;
		f=document.edicion.elements["test[0][dire_tpoblacion]"].value;
		g=document.edicion.elements["test[0][dire_tfono]"].value;
		
		document.edicion.elements["codeudor[0][ciud_ccod]"].value = v_ciudad;
		document.edicion.elements["codeudor[0][regi_ccod]"].value = v_region;
		
		document.edicion.elements['codeudor[0][dire_tcalle]'].value = b;
		document.edicion.elements["codeudor[0][dire_tnro]"].value = c;
		document.edicion.elements["codeudor[0][dire_tblock]"].value = d;
		document.edicion.elements["codeudor[0][dire_tpoblacion]"].value=f;
		document.edicion.elements["codeudor[0][dire_tfono]"].value =g;
	}	
}



function InicioPagina()
{
	//t_padre = new CTabla("codeudor");
	
	_FiltrarCombobox(document.edicion.elements["codeudor[0][ciud_ccod]"], 
	                 document.edicion.elements["codeudor[0][regi_ccod]"].value,
					 d_ciudades,
					 'regi_ccod',
					 'ciud_ccod',
					 'ciud_tdesc',
					 '<%=f_codeudor.ObtenerValor("ciud_ccod")%>');
}
function pers_nrut_change(p_objeto)
{
  document.edicion.elements["codeudor[0][pers_xdv]"].focus();
}

function revisar_digito(p_objeto)
{  	p_objeto.value=p_objeto.value.toUpperCase();
	document.edicion.submit();
}
</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "codeudor[0][pers_fnacimiento]","1","edicion","fecha_oculta_codeudor"
	calendario.FinFuncion
%>

<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>
</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%				
				pagina.DibujarLenguetas lenguetas_postulacion, 5
				%></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTitulo "FICHA DE POSTULACION APODERADO SOSTENEDOR ECONOMICO"%>
              <br>
              <br>
              <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td><div align="justify"><%=msjRecordatorio%></div></td>
                </tr>
              </table>
                </div>
              <form name="edicion" method="post">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Apoderado Sostenedor"%>                    
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr>
                        <td><%f_codeudor.DibujaCampo("pare_ccod")%></td>
                      </tr>
                    </table>
                    <br>
                    <br>                     
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="33%"><span class="style1">(*)</span> R.U.T.<br>
						  <%f_codeudor.DibujaCampo("pers_nrut")%>
      -
      <%f_codeudor.DibujaCampo("pers_xdv")%></td>
                          <td width="67%"><span class="style1">(*)</span>FECHA DE NACIMIENTO <br>
                              <%f_codeudor.DibujaCampo("pers_fnacimiento")%>  <%calendario.DibujaImagen "fecha_oculta_codeudor","1","edicion" %></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><span class="style1">(*)</span> APELLIDO PATERNO <br>
                              <%f_codeudor.DibujaCampo("pers_tape_paterno")%></td>
                          <td><span class="style1">(*)</span> APELLIDO MATERNO <br>
                              <%f_codeudor.DibujaCampo("pers_tape_materno")%></td>
                          <td><span class="style1">(*)</span> NOMBRES<br>
                              <%f_codeudor.DibujaCampo("pers_tnombre")%></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="40%"><span class="style1">(*)</span> REGI&Oacute;N<br>
                              <%f_codeudor.DibujaCampo("regi_ccod")%>                          </td>
                          <td width="40%"><span class="style1">(*)</span> CIUDAD DE PROCEDENCIA<br>
                              <%f_codeudor.DibujaCampo("ciud_ccod")%></td>
							  <td width="20%"><span class="style1">(*)</span>EST. CIVIL<br>
                              <%f_codeudor.DibujaCampo("eciv_ccod")%></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><span class="style1">(*)</span> CALLE<br><%f_codeudor.DibujaCampo("dire_tcalle")%></td>
                          <td><span class="style1">(*)</span> N&Uacute;MERO<br><%f_codeudor.DibujaCampo("dire_tnro")%></td>
                          <td> DEPTO<br>  <%f_codeudor.DibujaCampo("dire_tblock")%> </td>
                          <td>CONJUNTO/CONDOMINIO<br><%f_codeudor.DibujaCampo("dire_tpoblacion")%></td>
                          <td></td>
                        </tr>
                      </table>
						<br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td>TEL&Eacute;FONO:<br><%f_codeudor.DibujaCampo("dire_tfono")%></td>
                          <td></td>
                          <td> EMAIL:<br>
                            <%f_codeudor.DibujaCampo("pers_temail")%></td>
                          <td></td>
                          <td></td>
                        </tr>
						<tr>
								<td colspan="4" align="right"> <%f_botonera.DibujaBoton("copiar_direccion")%></td>
					        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td>ESCOLARIDAD (&Uacute;LTIMO A&Ntilde;O CURSADO) <br>
                            <%f_codeudor.DibujaCampo("nedu_ccod")%></td>
                        </tr>
                      </table>
                      <br>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td>PROFESI&Oacute;N U OFICIO <br>
                              <%f_codeudor.DibujaCampo("pers_tprofesion")%></td>
                          <td>EMPRESA<br>
                              <%f_codeudor.DibujaCampo("pers_tempresa")%></td>
                          <td>CARGO O ACTIVIDAD <br>
                              <%f_codeudor.DibujaCampo("pers_tcargo")%></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="50%">REGI&Oacute;N<br>
                              <%f_codeudor.DibujaCampo("regi_ccod_empresa")%>                          </td>
                          <td width="50%">CIUDAD O LOCALIDAD<br>
                              <%f_codeudor.DibujaCampo("ciud_ccod_empresa")%></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td>CALLE<br>
                              <%f_codeudor.DibujaCampo("dire_tcalle_empresa")%></td>
                          <td>N&Uacute;MERO<br>
                              <%f_codeudor.DibujaCampo("dire_tnro_empresa")%></td>
                          <td>CONJUNTO/CONDOMINIO<br>
                              <%f_codeudor.DibujaCampo("dire_tpoblacion_empresa")%></td>
                          <td>TEL&Eacute;FONO<br>
						  
                              <%f_codeudor.DibujaCampo("dire_tfono_empresa")%></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td>ANTIGUEDAD LABORAL<br>
                            <%f_codeudor.DibujaCampo("alab_ccod")%> </td>
                          <td>RENTA PERCIBIDA<br>
                            <%f_codeudor.DibujaCampo("ifam_ccod")%>
							 </td>
						
							 
                        </tr>
                      </table>
                      <br>
                      <%f_codeudor.DibujaCampo("post_ncorr")%> 
					                     
					<%f_alumno_direccion.DibujaCampo("ciud_ccod")%>
			 
				  <%f_alumno_direccion.DibujaCampo("regi_ccod")%>
				 
				 <%f_alumno_direccion.DibujaCampo("dire_tcalle")%>
			 
				 <%f_alumno_direccion.DibujaCampo("dire_tnro")%>
				  
				 <%f_alumno_direccion.DibujaCampo("dire_tblock")%>
				  
				  <%f_alumno_direccion.DibujaCampo("dire_tpoblacion")%>
			  
				  <%f_alumno_direccion.DibujaCampo("dire_tfono")%> <br>                      
                      <br>                      </td>
                  </tr>
                </table>
				
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("anterior")%></div></td>				 
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("siguiente")%>
                  </div></td>				  
                  <td><div align="center">
				  	<%if Session("ses_act_ancedentes")<>"" then f_botonera.AgregaBotonParam "salir", "url", "actualizacion_antecedentes.asp" end if%>
                    <%if Session("ses_estado_alumno")=1 then f_botonera.AgregaBotonParam "salir", "url", "actualizacion_antecedentes_matriculados.asp" end if%>
					<% if Session("alumno_asistente")="1" then f_botonera.AgregaBotonParam "salir", "url", "apoyo_postulacion.asp" end if%>
					<%f_botonera.DibujaBoton("salir")%>
                  </div></td>
                </tr>
              </table>
            </div></td>
            <td width="62%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
