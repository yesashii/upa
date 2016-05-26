<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
sede_ccod = Request.QueryString("busqueda[0][sede_ccod]")
jorn_ccod = Request.QueryString("busqueda[0][jorn_ccod]")
carr_ccod = Request.QueryString("busqueda[0][carr_ccod]")
estado_ccod = Request.QueryString("estado_ccod")
estado_alumno = Request.QueryString("estado_alumno")
inicio = request.querystring("inicio")
termino = request.querystring("termino")
 
'response.Write("estado "&estado_ccod)
'busqueda=request.QueryString("paso")
'response.Write("sede= "&sede_ccod & " carrera "&carr_ccod&" jornada "&jorn_ccod)


	
	
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Seguimiento de Matriculas"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion


sede_ccod_usuario=negocio.ObtenerSede()
'if sede_ccod="" then
'	sede_ccod=sede_ccod_usuario
'end if


set f_botonera = new CFormulario
f_botonera.Carga_Parametros "lista_matriculas.xml", "botonera"
v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")
usuario=negocio.ObtenerUsuario()

'if v_peri_ccod > "205" then'-----------------------------solo actualizará los estados cuando se busque inf. del 2007.
'	conexion.ejecutaS "execute calificar_test_ingreso"
'end if

pers_ncorr_encargado=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")
	
if v_peri_ccod = "200" or estado_ccod="4" then
    filtro_matriculas = " and  exists (select 1 from alumnos alu,contratos cont where b.post_ncorr=alu.post_ncorr and alu.emat_ccod in (1,4,8,10) and alu.matr_ncorr=cont.matr_ncorr and cont.econ_ccod=1) "
    fecha_matricula = " (select protic.trunc(cont.cont_fcontrato) from alumnos alu,contratos cont where b.post_ncorr=alu.post_ncorr and alu.emat_ccod in (1,4,8,10) and alu.matr_ncorr=cont.matr_ncorr and cont.econ_ccod=1) "	
	if inicio <> "" and termino <> "" then
			filtro_fecha = " AND (select convert(datetime,convert(varchar,cont.cont_fcontrato,103),103) from alumnos alu,contratos cont where b.post_ncorr=alu.post_ncorr and alu.emat_ccod in (1,4,8,10) and alu.matr_ncorr=cont.matr_ncorr and cont.econ_ccod=1) between convert(datetime,'" & inicio & "',103) and convert(datetime,'" & termino & "',103)"& vbCrLf
	 elseif inicio <> "" and termino = "" then	
		 	filtro_fecha = " AND (select convert(datetime,convert(varchar,cont.cont_fcontrato,103),103) from alumnos alu,contratos cont where b.post_ncorr=alu.post_ncorr and alu.emat_ccod in (1,4,8,10) and alu.matr_ncorr=cont.matr_ncorr and cont.econ_ccod=1) >= convert(datetime,'" & inicio & "',103) "& vbCrLf
	 elseif inicio = "" and termino <> "" then	
		 	filtro_fecha = " AND (select convert(datetime,convert(varchar,cont.cont_fcontrato,103),103) from alumnos alu,contratos cont where b.post_ncorr=alu.post_ncorr and alu.emat_ccod in (1,4,8,10) and alu.matr_ncorr=cont.matr_ncorr and cont.econ_ccod=1) <= convert(datetime,'" & termino & "',103) "& vbCrLf	
	 end if
	
elseif v_peri_ccod= "202" and estado_ccod<>"4" then
	filtro_matriculas = " And isnull((select sum(protic.total_recepcionar_cuota(37,comp.inst_ccod,comp.comp_ndocto,dcom.dcom_ncompromiso)) " & vbCrLf &_ 
         			   " from compromisos comp, detalle_compromisos dcom " & vbCrLf &_ 
                       " where comp.post_ncorr = c.post_ncorr and comp.ofer_ncorr = c.ofer_ncorr and  comp.comp_ndocto=dcom.comp_ndocto and  comp.tcom_ccod=dcom.tcom_ccod and  comp.inst_ccod=dcom.inst_ccod and comp.ecom_ccod <> 3 and comp.tcom_ccod=37),1) = 0 "
	fecha_matricula =  " (select protic.trunc(max(abo.abon_fabono)) " & vbCrLf &_ 
         			   " from compromisos comp, detalle_compromisos dcom, abonos abo " & vbCrLf &_ 
                       " where comp.post_ncorr = c.post_ncorr and comp.ofer_ncorr = c.ofer_ncorr and comp.tcom_ccod=37 and  comp.comp_ndocto=dcom.comp_ndocto  and comp.tcom_ccod = dcom.tcom_ccod and  abo.comp_ndocto=dcom.comp_ndocto  and abo.tcom_ccod = dcom.tcom_ccod) "
	if inicio <> "" and termino <> "" then
			filtro_fecha = " AND (select convert(datetime,max(abo.abon_fabono),103) " & vbCrLf &_ 
         			       " from compromisos comp, detalle_compromisos dcom, abonos abo " & vbCrLf &_ 
                           " where comp.post_ncorr = c.post_ncorr and comp.ofer_ncorr = c.ofer_ncorr and comp.tcom_ccod=37 and  comp.comp_ndocto=dcom.comp_ndocto  and comp.tcom_ccod = dcom.tcom_ccod and  abo.comp_ndocto=dcom.comp_ndocto  and abo.tcom_ccod = dcom.tcom_ccod) " & vbCrLf &_
                           " between convert(datetime,'" & inicio & "',103) and convert(datetime,'" & termino & "',103)"& vbCrLf
	 elseif inicio <> "" and termino = "" then	
		 	filtro_fecha = " AND (select convert(datetime,max(abo.abon_fabono),103) " & vbCrLf &_ 
         			       " from compromisos comp, detalle_compromisos dcom, abonos abo " & vbCrLf &_ 
                           " where comp.post_ncorr = c.post_ncorr and comp.ofer_ncorr = c.ofer_ncorr and comp.tcom_ccod=37 and  comp.comp_ndocto=dcom.comp_ndocto  and comp.tcom_ccod = dcom.tcom_ccod and  abo.comp_ndocto=dcom.comp_ndocto  and abo.tcom_ccod = dcom.tcom_ccod) " & vbCrLf &_
			               " >= convert(datetime,'" & inicio & "',103) "& vbCrLf
	 elseif inicio = "" and termino <> "" then	
		 	filtro_fecha = " AND (select convert(datetime,max(abo.abon_fabono),103) " & vbCrLf &_ 
         			       " from compromisos comp, detalle_compromisos dcom, abonos abo " & vbCrLf &_ 
                           " where comp.post_ncorr = c.post_ncorr and comp.ofer_ncorr = c.ofer_ncorr and comp.tcom_ccod=37 and  comp.comp_ndocto=dcom.comp_ndocto  and comp.tcom_ccod = dcom.tcom_ccod and  abo.comp_ndocto=dcom.comp_ndocto  and abo.tcom_ccod = dcom.tcom_ccod) " & vbCrLf &_
			               " <= convert(datetime,'" & termino & "',103) "& vbCrLf	
	 end if			   
end if

'------------------------------------------------------------------------------------------------------------------------------
'----------------------------------Ver si la carrera seleccionada paga examen--------------------------------------------------

consulta="select count(*) from especialidades a,ofertas_academicas b" & vbCrLf &_ 
		 " where cast(b.peri_ccod as varchar)='"&v_peri_ccod&"'" 
		 if carr_ccod<>"" and carr_ccod<>"-1" then
            consulta=consulta & " and cast(a.carr_ccod as varchar)='"&carr_ccod&"'" & vbCrLf &_
            " and a.espe_ccod=b.espe_ccod"
		 end if
         consulta=consulta & " and cast(b.sede_ccod as varchar)='"&sede_ccod&"'" & vbCrLf &_
         " and b.ofer_bpaga_examen='N' and b.post_bnuevo='S'"
'response.Write("<pre>"&consulta&"</pre>")
paga=conexion.consultaUno(consulta)

'-----------------------------------------------------------------------------------------------------------------------------
'response.Write("<pre>"&estado_ccod&"</pre>")
set lista = new CFormulario

if estado_ccod="1" then
lista.carga_parametros "lista_matriculas.xml", "list_alumnos"

consulta=" select distinct protic.FORMAT_RUT(cast(a.pers_nrut as varchar(10))) as rut,protic.trunc(c.audi_fmodificacion) as fecha," & vbCrLf &_ 
         " a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre," & vbCrLf &_ 
         " a.pers_tfono as fono, case a.pers_temail when null then '' else '<A href=""mailto:'+a.pers_temail+'"">'+a.pers_temail+'</a>' end  as email,g.jorn_tdesc as jornada" & vbCrLf &_ 
         " from  " & vbCrLf &_ 
         " personas_postulante a,postulantes b,detalle_postulantes c, " & vbCrLf &_ 
         " ofertas_academicas d,especialidades e,carreras f,jornadas g, " & vbCrLf &_ 
         " sedes h " & vbCrLf &_ 
         " where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_ 
         " and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"'" & vbCrLf &_ 
         " and b.post_ncorr = c.post_ncorr " & vbCrLf &_ 
         " and c.ofer_ncorr = d.ofer_ncorr " & vbCrLf &_ 
		 " and d.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where pers_ncorr='"&pers_ncorr_encargado&"')" & vbCrLf &_
         " and d.espe_ccod = e.espe_ccod "
		 if carr_ccod<>"" and carr_ccod<>"-1" then
         	consulta= consulta & " and cast(f.carr_ccod as varchar)= '"&carr_ccod&"'" 
		 end if
		 if inicio <> "" and termino <> "" then
			consulta = consulta &  " AND convert(datetime,convert(datetime,c.audi_fmodificacion,103),103) between convert(datetime,'" & inicio & "',103) and convert(datetime,'" & termino & "',103)"& vbCrLf
		 elseif inicio <> "" and termino = "" then	
		 	consulta = consulta &  " AND convert(datetime,convert(datetime,c.audi_fmodificacion,103),103) >= convert(datetime,'" & inicio & "',103) "& vbCrLf
		 elseif inicio = "" and termino <> "" then	
		 	consulta = consulta &  " AND convert(datetime,convert(datetime,c.audi_fmodificacion,103),103) <= convert(datetime,'" & termino & "',103) "& vbCrLf	
		 end if 
         consulta= consulta& " and e.carr_ccod = f.carr_ccod  "
		 if jorn_ccod<>"" and jorn_ccod<>"-1" then
		 consulta=consulta&" and cast(d.jorn_ccod as varchar)='"&jorn_ccod&"'"
		 end if
         consulta=consulta & " and d.jorn_ccod = g.jorn_ccod "
		 if sede_ccod<>"" and sede_ccod<>"-1" then
         	consulta=consulta & " and cast(h.sede_ccod as varchar)= '"&sede_ccod&"'"
		 end if
         consulta=consulta & " and d.sede_ccod = h.sede_ccod " 
		 if paga="0" then
		 consulta=consulta &" and protic.buscar_pagados_1(a.pers_ncorr,"&v_peri_ccod&")='N'"
		 end if
		 consulta=consulta & " and isnull(c.eepo_ccod,1) =1 "&vbCrlf &_
         " and b.epos_ccod = 2 " & vbCrLf &_ 
		 " and b.audi_tusuario not in ('AgregaNota2T','AgregaNota3','AgregaNota37','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46'," & vbCrLf  & _
         "            'AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp'," & vbCrLf  & _
         "            'AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80'," & vbCrLf  & _
         "            'AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99') " 

end if

if estado_ccod="2" then
lista.carga_parametros "lista_matriculas.xml", "list_alumnos"

consulta=" select distinct protic.FORMAT_RUT(cast(a.pers_nrut as varchar(10))) as rut,protic.trunc(c.audi_fmodificacion) as fecha," & vbCrLf &_ 
         " a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre," & vbCrLf &_ 
         " a.pers_tfono as fono, case a.pers_temail when null then '' else '<A href=""mailto:'+a.pers_temail+'"">'+a.pers_temail+'</a>' end  as email,g.jorn_tdesc as jornada" & vbCrLf &_ 
         " from  " & vbCrLf &_ 
         " personas a,postulantes b,detalle_postulantes c, " & vbCrLf &_ 
         " ofertas_academicas d,especialidades e,carreras f,jornadas g, " & vbCrLf &_ 
         " sedes h " & vbCrLf &_ 
         " where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_ 
         " and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"'" & vbCrLf &_ 
         " and b.post_ncorr = c.post_ncorr " & vbCrLf &_ 
         " and c.ofer_ncorr = d.ofer_ncorr " & vbCrLf &_ 
		 " and d.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where pers_ncorr='"&pers_ncorr_encargado&"')" & vbCrLf &_
         " and d.espe_ccod = e.espe_ccod "
		 if carr_ccod<>"" and carr_ccod<>"-1" then
         	consulta= consulta & " and cast(f.carr_ccod as varchar)= '"&carr_ccod&"'" 
		 end if
		 if inicio <> "" and termino <> "" then
			consulta = consulta &  " AND convert(datetime,convert(datetime,c.audi_fmodificacion,103),103) between convert(datetime,'" & inicio & "',103) and  convert(datetime,'" & termino & "',103)"& vbCrLf
		 elseif inicio <> "" and termino = "" then	
		 	consulta = consulta &  " AND convert(datetime,convert(datetime,c.audi_fmodificacion,103),103) >= convert(datetime,'" & inicio & "',103) "& vbCrLf
		 elseif inicio = "" and termino <> "" then	
		 	consulta = consulta &  " AND convert(datetime,convert(datetime,c.audi_fmodificacion,103),103) <= convert(datetime,'" & termino & "',103) "& vbCrLf	
		 end if 
         consulta= consulta& " and e.carr_ccod = f.carr_ccod  "
		 if jorn_ccod<>"" and jorn_ccod<>"-1" then
		 consulta=consulta&" and cast(d.jorn_ccod as varchar)='"&jorn_ccod&"'"
		 end if
         consulta=consulta & " and d.jorn_ccod = g.jorn_ccod "
		 if sede_ccod<>"" and sede_ccod<>"-1" then
         	consulta=consulta & " and cast(h.sede_ccod as varchar)= '"&sede_ccod&"'"
		 end if
         consulta=consulta & " and d.sede_ccod = h.sede_ccod " 
		 if paga="0" then
		 consulta=consulta &" and protic.buscar_pagados_1(a.pers_ncorr,"&v_peri_ccod&")='S'"
		 end if
		 consulta=consulta & " and isnull(c.eepo_ccod,1) =1 "&vbCrlf &_
         " and b.epos_ccod = 2 " & vbCrLf &_ 
		 " and b.audi_tusuario not in ('AgregaNota2T','AgregaNota3','AgregaNota37','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46'," & vbCrLf  & _
         "            'AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp'," & vbCrLf  & _
         "            'AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80'," & vbCrLf  & _
         "            'AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99') " 

'response.Write("<pre>"&consulta&"</pre>")	
'response.Write("<pre>1</pre>")	 
end if

if estado_ccod="3" then
lista.carga_parametros "lista_matriculas.xml", "list_alumnos"

consulta=" select distinct protic.FORMAT_RUT(cast(a.pers_nrut as varchar(10))) as rut,protic.trunc(c.audi_fmodificacion) as fecha," & vbCrLf &_ 
         " a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre," & vbCrLf &_ 
         " a.pers_tfono as fono, case a.pers_temail when null then '' else '<A href=""mailto:'+a.pers_temail+'"">'+a.pers_temail+'</a>' end  as email,g.jorn_tdesc as jornada" & vbCrLf &_ 
         " from  "
		 if paga="0" then 
         	consulta=consulta & " personas a,"
		 else
		 	consulta=consulta & " personas_postulante a,"
		 end if
         consulta=consulta & "postulantes b,detalle_postulantes c, " & vbCrLf &_ 
         " ofertas_academicas d,especialidades e,carreras f,jornadas g, " & vbCrLf &_ 
         " sedes h" & vbCrLf &_ 
         " where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_ 
         " and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"'" & vbCrLf &_ 
         " and b.post_ncorr = c.post_ncorr " & vbCrLf &_ 
         " and c.ofer_ncorr = d.ofer_ncorr " & vbCrLf &_ 
    	 " and d.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where cast(pers_ncorr as varchar)='"&pers_ncorr_encargado&"')" & vbCrLf &_
         " and d.espe_ccod = e.espe_ccod "
		 if carr_ccod<>"" and carr_ccod<>"-1" then
               consulta=consulta & " and cast(f.carr_ccod as varchar)= '"&carr_ccod&"'"
		 end if	   
		 if inicio <> "" and termino <> "" then
			consulta = consulta &  " AND convert(datetime,convert(varchar,c.audi_fmodificacion,103),103) between convert(datetime,'" & inicio & "',103) and convert(datetime,'" & termino & "',103)"& vbCrLf
		 elseif inicio <> "" and termino = "" then	
		 	consulta = consulta &  " AND convert(datetime,convert(varchar,c.audi_fmodificacion,103),103) >= convert(datetime,'" & inicio & "',103) "& vbCrLf
		 elseif inicio = "" and termino <> "" then	
		 	consulta = consulta &  " AND convert(datetime,convert(varchar,c.audi_fmodificacion,103),103) <= convert(datetime,'" & termino & "',103) "& vbCrLf	
		 end if 
         consulta=consulta & " and e.carr_ccod = f.carr_ccod  " 
		 if jorn_ccod<>"" and jorn_ccod<>"-1" then
		 		consulta=consulta&" and cast(d.jorn_ccod as varchar)='"&jorn_ccod&"'"
		 end if
         consulta=consulta & " and d.jorn_ccod = g.jorn_ccod " 
         if sede_ccod<>"" and sede_ccod<>"-1" then
         consulta=consulta &" and cast(h.sede_ccod as varchar)= '"&sede_ccod&"'"
		 end if
         consulta=consulta &" and d.sede_ccod = h.sede_ccod " & vbCrLf &_ 
	 	 " and c.eepo_ccod<>1 "&vbCrlf &_
         " and b.epos_ccod = 2 " & vbCrLf &_ 
		 " and not exists (select 1 from alumnos alu where b.post_ncorr=alu.post_ncorr and alu.emat_ccod=1 "& vbCrLf  & _
		 " and alu.audi_tusuario not in ('AgregaNota2T','AgregaNota3','AgregaNota37','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46'," & vbCrLf  & _
         "            'AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp'," & vbCrLf  & _
         "            'AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80'," & vbCrLf  & _
         "            'AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99')) "
		 
		 'response.Write("<pre>"&consulta&"</pre>")
end if

if estado_ccod="4" then
lista.carga_parametros "lista_matriculas.xml", "list_alumnos_matriculados"

consulta=" select distinct protic.FORMAT_RUT(cast(a.pers_nrut as varchar(10))) as rut,case j.emat_ccod when 1 then protic.trunc(i.alum_fmatricula) when 4 then protic.trunc(i.alum_fmatricula) when 8 then protic.trunc(i.alum_fmatricula) else protic.trunc(i.audi_fmodificacion) end as fecha," & vbCrLf &_ 
         " a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre," & vbCrLf &_ 
         " a.pers_tfono as fono, case a.pers_temail when null then '' else '<A href=""mailto:'+a.pers_temail+'"">'+a.pers_temail+'</a>' end  as email," & vbCrLf &_ 
		 " '<font color=''' + case j.emat_ccod when 1 then '#0033FF' when 4 then '#0033FF' when 8 then '#0033FF' else '#CC0000' end +'''>' + j.emat_tdesc +'</font>' as estado" & vbCrLf &_ 
         " from  " 
		 if paga="0" then 
         	consulta=consulta & " personas a,"
		 else
		 	consulta=consulta & " personas_postulante a,"
		 end if 
         consulta=consulta & " postulantes b, " & vbCrLf &_ 
         " ofertas_academicas d,especialidades e,carreras f,jornadas g, " & vbCrLf &_ 
         " sedes h, alumnos i, estados_matriculas j" & vbCrLf &_ 
         " where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_ 
         " and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"'" & vbCrLf &_ 
         " and b.ofer_ncorr = d.ofer_ncorr " & vbCrLf &_ 
   	 	 " and d.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where cast(pers_ncorr as varchar)='"&pers_ncorr_encargado&"')" & vbCrLf &_
         " and d.espe_ccod = e.espe_ccod "
		 if carr_ccod<>"" and carr_ccod<>"-1" then 
	         consulta=consulta & " and cast(f.carr_ccod as varchar)= '"&carr_ccod&"'" 
		 end if
		 if inicio <> "" and termino <> "" then
			consulta = consulta &  " AND convert(datetime,convert(varchar,i.alum_fmatricula,103),103) between convert(datetime,'" & inicio & "',103) and convert(datetime,'" & termino & "',103)"& vbCrLf
		 elseif inicio <> "" and termino = "" then	
		 	consulta = consulta &  " AND convert(datetime,convert(varchar,i.alum_fmatricula,103),103) >= convert(datetime,'" & inicio & "',103) "& vbCrLf
		 elseif inicio = "" and termino <> "" then	
		 	consulta = consulta &  " AND convert(datetime,convert(varchar,i.alum_fmatricula,103),103) <= convert(datetime,'" & termino & "',103) "& vbCrLf	
		 end if 
         consulta=consulta & " and e.carr_ccod = f.carr_ccod  "
		 if jorn_ccod<>"" and jorn_ccod<>"-1" then
		 	consulta=consulta&" and cast(d.jorn_ccod as varchar)='"&jorn_ccod&"'"
		 end if
         consulta=consulta & " and d.jorn_ccod = g.jorn_ccod "
     	 if sede_ccod<>"" and sede_ccod<>"-1" then
         	consulta= consulta & " and cast(h.sede_ccod as varchar)= '"&sede_ccod&"'"
		 end if
         consulta=consulta & " and d.sede_ccod = h.sede_ccod " & vbCrLf &_ 
	 	 " and b.epos_ccod = 2 " & vbCrLf &_ 
		 " and b.post_ncorr=i.post_ncorr and b.ofer_ncorr=i.ofer_ncorr and b.pers_ncorr=i.pers_ncorr and i.emat_ccod in (1,4,8)" & vbCrLf &_ 
 		 " and i.emat_ccod=j.emat_ccod" & vbCrLf &_ 
		 " and  exists (select 1 from alumnos alu where b.post_ncorr=alu.post_ncorr and alu.emat_ccod in (1,4,8) and isnull(alum_nmatricula,0) <> '7777' "& vbCrLf  & _
		 " and alu.audi_tusuario not in ('AgregaNota2T','AgregaNota3','AgregaNota37','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46'," & vbCrLf  & _
         "            'AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp'," & vbCrLf  & _
         "            'AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80'," & vbCrLf  & _
         "            'AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99')) " 
 
 
' eliminada la validacion de tipo de postulacion
   ' " --and b.tpos_ccod = 1 "
   
end if

if estado_ccod="5" then
lista.carga_parametros "lista_matriculas.xml", "list_alumnos_matriculados"

consulta=" select distinct protic.FORMAT_RUT(cast(a.pers_nrut as varchar(10))) as rut,case j.emat_ccod when 1 then protic.trunc(i.alum_fmatricula) when 4 then protic.trunc(i.alum_fmatricula) when 8 then protic.trunc(i.alum_fmatricula) else protic.trunc(i.audi_fmodificacion) end as fecha," & vbCrLf &_ 
         " a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre," & vbCrLf &_ 
         " a.pers_tfono as fono, case a.pers_temail when null then '' else '<A href=""mailto:'+a.pers_temail+'"">'+a.pers_temail+'</a>' end  as email," & vbCrLf &_ 
		 " '<font color=''' + case j.emat_ccod when 1 then '#0033FF' when 4 then '#0033FF' when 8 then '#0033FF' else '#CC0000' end +'''>' + j.emat_tdesc +'</font>' as estado" & vbCrLf &_ 
         " from  " 
		 if paga="0" then 
         	consulta=consulta & " personas a,"
		 else
		 	consulta=consulta & " personas_postulante a,"
		 end if 
         consulta=consulta & " postulantes b, " & vbCrLf &_ 
         " ofertas_academicas d,especialidades e,carreras f,jornadas g, " & vbCrLf &_ 
         " sedes h, alumnos i, estados_matriculas j" & vbCrLf &_ 
         " where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_ 
         " and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"'" & vbCrLf &_ 
         " and b.ofer_ncorr = d.ofer_ncorr " & vbCrLf &_ 
   	 	 " and d.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where cast(pers_ncorr as varchar)='"&pers_ncorr_encargado&"')" & vbCrLf &_
         " and d.espe_ccod = e.espe_ccod "
		 if carr_ccod<>"" and carr_ccod<>"-1" then 
	         consulta=consulta & " and cast(f.carr_ccod as varchar)= '"&carr_ccod&"'" 
		 end if
		 if inicio <> "" and termino <> "" then
			consulta = consulta &  " AND convert(datetime,convert(varchar,i.alum_fmatricula,103),103) between convert(datetime,'" & inicio & "',103) and convert(datetime,'" & termino & "',103)"& vbCrLf
		 elseif inicio <> "" and termino = "" then	
		 	consulta = consulta &  " AND convert(datetime,convert(varchar,i.alum_fmatricula,103),103) >= convert(datetime,'" & inicio & "',103) "& vbCrLf
		 elseif inicio = "" and termino <> "" then	
		 	consulta = consulta &  " AND convert(datetime,convert(varchar,i.alum_fmatricula,103),103) <= convert(datetime,'" & termino & "',103) "& vbCrLf	
		 end if 
         consulta=consulta & " and e.carr_ccod = f.carr_ccod  "
		 if jorn_ccod<>"" and jorn_ccod<>"-1" then
		 	consulta=consulta&" and cast(d.jorn_ccod as varchar)='"&jorn_ccod&"'"
		 end if
         consulta=consulta & " and d.jorn_ccod = g.jorn_ccod "
     	 if sede_ccod<>"" and sede_ccod<>"-1" then
         	consulta= consulta & " and cast(h.sede_ccod as varchar)= '"&sede_ccod&"'"
		 end if
         consulta=consulta & " and d.sede_ccod = h.sede_ccod " & vbCrLf &_ 
	 	 " and b.epos_ccod = 2 " & vbCrLf &_ 
		 " and b.post_ncorr=i.post_ncorr and b.ofer_ncorr=i.ofer_ncorr and b.pers_ncorr=i.pers_ncorr and i.emat_ccod not in (1,4,8)" & vbCrLf &_ 
 		 " and i.emat_ccod=j.emat_ccod" & vbCrLf &_ 
		 " and  exists (select 1 from alumnos alu where b.post_ncorr=alu.post_ncorr "& vbCrLf  & _
		 " and alu.audi_tusuario not in ('AgregaNota2T','AgregaNota3','AgregaNota37','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46'," & vbCrLf  & _
         "            'AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp'," & vbCrLf  & _
         "            'AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80'," & vbCrLf  & _
         "            'AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99')) " 
 
 
' eliminada la validacion de tipo de postulacion
   ' " --and b.tpos_ccod = 1 "
   
end if

if estado_ccod="6" then
lista.carga_parametros "lista_matriculas.xml", "list_alumnos"

consulta=" select distinct protic.FORMAT_RUT(cast(a.pers_nrut as varchar(10))) as rut,protic.trunc(c.audi_fmodificacion) as fecha," & vbCrLf &_ 
         " a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre," & vbCrLf &_ 
         " a.pers_tfono as fono, case a.pers_temail when null then '' else '<A href=""mailto:'+a.pers_temail+'"">'+a.pers_temail+'</a>' end  as email,g.jorn_tdesc as jornada" & vbCrLf &_ 
         " from  " & vbCrLf &_ 
         " personas_postulante a,postulantes b,detalle_postulantes c, " & vbCrLf &_ 
         " ofertas_academicas d,especialidades e,carreras f,jornadas g, " & vbCrLf &_ 
         " sedes h " & vbCrLf &_ 
         " where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_ 
         " and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"'" & vbCrLf &_ 
         " and b.post_ncorr = c.post_ncorr " & vbCrLf &_ 
         " and c.ofer_ncorr = d.ofer_ncorr " & vbCrLf &_ 
		 " and d.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where pers_ncorr='"&pers_ncorr_encargado&"')" & vbCrLf &_
         " and d.espe_ccod = e.espe_ccod "
		 if carr_ccod<>"" and carr_ccod<>"-1" then
         	consulta= consulta & " and cast(f.carr_ccod as varchar)= '"&carr_ccod&"'" 
		 end if
		 if inicio <> "" and termino <> "" then
			consulta = consulta &  " AND convert(datetime,convert(varchar,c.audi_fmodificacion,103),103) between convert(datetime,'" & inicio & "',103) and convert(datetime,'" & termino & "',103)"& vbCrLf
		 elseif inicio <> "" and termino = "" then	
		 	consulta = consulta &  " AND convert(datetime,convert(varchar,c.audi_fmodificacion,103),103) >= convert(datetime,'" & inicio & "',103) "& vbCrLf
		 elseif inicio = "" and termino <> "" then	
		 	consulta = consulta &  " AND convert(datetime,convert(varchar,c.audi_fmodificacion,103),103) <= convert(datetime,'" & termino & "',103) "& vbCrLf	
		 end if 
         consulta= consulta& " and e.carr_ccod = f.carr_ccod  "
		 if jorn_ccod<>"" and jorn_ccod<>"-1" then
		 consulta=consulta&" and cast(d.jorn_ccod as varchar)='"&jorn_ccod&"'"
		 end if
         consulta=consulta & " and d.jorn_ccod = g.jorn_ccod "
		 if sede_ccod<>"" and sede_ccod<>"-1" then
         	consulta=consulta & " and cast(h.sede_ccod as varchar)= '"&sede_ccod&"'"
		 end if
         consulta=consulta & " and d.sede_ccod = h.sede_ccod " 
		 consulta=consulta & " and isnull(c.eepo_ccod,1) =1 --and isnull(dpos_ncalificacion,0) = 0"&vbCrlf &_
         " and b.epos_ccod = 2 " & vbCrLf &_ 
		 " and b.audi_tusuario not in ('AgregaNota2T','AgregaNota3','AgregaNota37','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46'," & vbCrLf  & _
         "            'AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp'," & vbCrLf  & _
         "            'AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80'," & vbCrLf  & _
         "            'AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99') " 

end if
if estado_ccod="7" then
lista.carga_parametros "lista_matriculas.xml", "list_alumnos"

consulta=" select distinct protic.FORMAT_RUT(cast(a.pers_nrut as varchar(10))) as rut,isnull(protic.trunc(c.audi_fmodificacion),protic.trunc(getDate())) as fecha," & vbCrLf &_ 
         " a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre," & vbCrLf &_ 
         " a.pers_tfono as fono, case a.pers_temail when null then '' else '<A href=""mailto:'+a.pers_temail+'"">'+a.pers_temail+'</a>' end  as email,g.jorn_tdesc as jornada" & vbCrLf &_ 
         " from  " & vbCrLf &_ 
         " personas_postulante a,postulantes b,detalle_postulantes c, " & vbCrLf &_ 
         " ofertas_academicas d,especialidades e,carreras f,jornadas g, " & vbCrLf &_ 
         " sedes h " & vbCrLf &_ 
         " where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_ 
         " and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"'" & vbCrLf &_ 
         " and b.post_ncorr = c.post_ncorr " & vbCrLf &_ 
		 " and exists (select 1 from aranceles tt where tt.aran_ncorr=d.aran_ncorr and isnull(tt.aran_mmatricula,0) <> 0) " & vbCrLf &_
         " and c.ofer_ncorr = d.ofer_ncorr " & vbCrLf &_ 
		 " and d.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where pers_ncorr='"&pers_ncorr_encargado&"')" & vbCrLf &_
         " and d.espe_ccod = e.espe_ccod "
		 if carr_ccod<>"" and carr_ccod<>"-1" then
         	consulta= consulta & " and cast(f.carr_ccod as varchar)= '"&carr_ccod&"'" 
		 end if
		 if inicio <> "" and termino <> "" then
			consulta = consulta &  " AND convert(datetime,convert(varchar,c.audi_fmodificacion,103),103) between convert(datetime,'" & inicio & "',103) and convert(datetime,'" & termino & "',103)"& vbCrLf
		 elseif inicio <> "" and termino = "" then	
		 	consulta = consulta &  " AND convert(datetime,convert(varchar,c.audi_fmodificacion,103),103) >= convert(datetime,'" & inicio & "',103) "& vbCrLf
		 elseif inicio = "" and termino <> "" then	
		 	consulta = consulta &  " AND convert(datetime,convert(varchar,c.audi_fmodificacion,103),103) <= convert(datetime,'" & termino & "',103) "& vbCrLf	
		 end if 
         consulta= consulta& " and e.carr_ccod = f.carr_ccod  "
		 if jorn_ccod<>"" and jorn_ccod<>"-1" then
		 consulta=consulta&" and cast(d.jorn_ccod as varchar)='"&jorn_ccod&"'"
		 end if
         consulta=consulta & " and d.jorn_ccod = g.jorn_ccod "
		 if sede_ccod<>"" and sede_ccod<>"-1" then
         	consulta=consulta & " and cast(h.sede_ccod as varchar)= '"&sede_ccod&"'"
		 end if
         consulta=consulta & " and d.sede_ccod = h.sede_ccod " 
		 consulta=consulta & " and c.eepo_ccod not in (1) --and isnull(dpos_ncalificacion,0) <> 0 "&vbCrlf &_
         " --and isnull((select sum(protic.total_recepcionar_cuota(37,comp.inst_ccod,comp.comp_ndocto,dcom.dcom_ncompromiso)) " & vbCrLf &_ 
         " --from compromisos comp, detalle_compromisos dcom " & vbCrLf &_ 
         " --where comp.post_ncorr = c.post_ncorr and comp.ofer_ncorr = c.ofer_ncorr and  comp.comp_ndocto=dcom.comp_ndocto and comp.tcom_ccod=37),1) > 0 " & vbCrLf &_ 
		 " and b.epos_ccod = 2 "
		 if usuario <> "9251062" and usuario <> "12889224" then
		  consulta = consulta & " And isnull((select sum(protic.total_recepcionar_cuota(37,comp.inst_ccod,comp.comp_ndocto,dcom.dcom_ncompromiso)) " & vbCrLf &_ 
         			   			" from compromisos comp, detalle_compromisos dcom " & vbCrLf &_ 
                       			" where comp.post_ncorr = c.post_ncorr and comp.ofer_ncorr = c.ofer_ncorr and  comp.comp_ndocto=dcom.comp_ndocto and  comp.tcom_ccod=dcom.tcom_ccod and  comp.inst_ccod=dcom.inst_ccod and comp.ecom_ccod <> 3 and comp.tcom_ccod=37),1) <> 0 " & vbCrLf &_
		 						" And not exists(select 1 from alumnos alu where alu.post_ncorr=c.post_ncorr and alu.ofer_ncorr=c.ofer_ncorr and alu.emat_ccod in (1,4,8))"
		 end if 
		 consulta = consulta & " and b.audi_tusuario not in ('AgregaNota2T','AgregaNota3','AgregaNota37','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46'," & vbCrLf  & _
							   "            'AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp'," & vbCrLf  & _
							   "            'AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80'," & vbCrLf  & _
							   "            'AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99') " 

end if

if estado_ccod="8" then
lista.carga_parametros "lista_matriculas.xml", "list_alumnos"

consulta=" select distinct protic.FORMAT_RUT(cast(a.pers_nrut as varchar(10))) as rut, '"&fecha_matricula&"' as fecha," & vbCrLf &_ 
         " a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre," & vbCrLf &_ 
         " a.pers_tfono as fono, case a.pers_temail when null then '' else '<A href=""mailto:'+a.pers_temail+'"">'+a.pers_temail+'</a>' end  as email,g.jorn_tdesc as jornada" & vbCrLf &_ 
         " from  " & vbCrLf &_ 
         " personas_postulante a,postulantes b,detalle_postulantes c, " & vbCrLf &_ 
         " ofertas_academicas d,especialidades e,carreras f,jornadas g, " & vbCrLf &_ 
         " sedes h " & vbCrLf &_ 
         " where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_ 
         " and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"'" & vbCrLf &_ 
         " and b.post_ncorr = c.post_ncorr " & vbCrLf &_ 
         " and c.ofer_ncorr = d.ofer_ncorr " & vbCrLf &_ 
		 " and d.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where pers_ncorr='"&pers_ncorr_encargado&"')" & vbCrLf &_
         " and d.espe_ccod = e.espe_ccod "
		 if carr_ccod<>"" and carr_ccod<>"-1" then
         	consulta= consulta & " and cast(f.carr_ccod as varchar)= '"&carr_ccod&"'" 
		 end if
		 consulta= consulta& " and e.carr_ccod = f.carr_ccod  "
		 if jorn_ccod<>"" and jorn_ccod<>"-1" then
		 consulta=consulta&" and cast(d.jorn_ccod as varchar)='"&jorn_ccod&"'"
		 end if
         consulta=consulta & " and d.jorn_ccod = g.jorn_ccod "
		 if sede_ccod<>"" and sede_ccod<>"-1" then
         	consulta=consulta & " and cast(h.sede_ccod as varchar)= '"&sede_ccod&"'"
		 end if
         consulta=consulta & " and d.sede_ccod = h.sede_ccod " 
		 consulta=consulta & " and c.eepo_ccod=2 --and isnull(dpos_ncalificacion,0) <> 0 "&vbCrlf &_
         "  " & filtro_matriculas & vbCrLf &_ 
		 " and b.epos_ccod = 2 " & vbCrLf &_ 
		 " " & filtro_fecha 
		 if usuario <> "9251062" and usuario <> "12889224" then
		  consulta = consulta & " And not exists(select 1 from alumnos alu where alu.post_ncorr=c.post_ncorr and alu.ofer_ncorr=c.ofer_ncorr and alu.emat_ccod in (1,4,8))"
		 end if 
		 consulta= consulta & " and b.audi_tusuario not in ('AgregaNota2T','AgregaNota3','AgregaNota37','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46'," & vbCrLf  & _
							  "            'AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp'," & vbCrLf  & _
							  "            'AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80'," & vbCrLf  & _
							  "            'AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99') " 

end if
if estado_ccod="9" then
lista.carga_parametros "lista_matriculas.xml", "list_alumnos"

consulta=" select distinct protic.FORMAT_RUT(cast(a.pers_nrut as varchar(10))) as rut,protic.trunc(c.audi_fmodificacion) as fecha," & vbCrLf &_ 
         " a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre," & vbCrLf &_ 
         " a.pers_tfono as fono, case a.pers_temail when null then '' else '<A href=""mailto:'+a.pers_temail+'"">'+a.pers_temail+'</a>' end  as email,g.jorn_tdesc as jornada" & vbCrLf &_ 
         " from  " & vbCrLf &_ 
         " personas_postulante a,postulantes b,detalle_postulantes c, " & vbCrLf &_ 
         " ofertas_academicas d,especialidades e,carreras f,jornadas g, " & vbCrLf &_ 
         " sedes h " & vbCrLf &_ 
         " where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_ 
         " and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"'" & vbCrLf &_ 
         " and b.post_ncorr = c.post_ncorr " & vbCrLf &_ 
         " and c.ofer_ncorr = d.ofer_ncorr " & vbCrLf &_ 
		 " and d.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where pers_ncorr='"&pers_ncorr_encargado&"')" & vbCrLf &_
         " and d.espe_ccod = e.espe_ccod "
		 if carr_ccod<>"" and carr_ccod<>"-1" then
         	consulta= consulta & " and cast(f.carr_ccod as varchar)= '"&carr_ccod&"'" 
		 end if
		 if inicio <> "" and termino <> "" then
			consulta = consulta &  " AND convert(datetime,convert(varchar,c.audi_fmodificacion,103),103) between convert(datetime,'" & inicio & "',103) and convert(datetime,'" & termino & "',103)"& vbCrLf
		 elseif inicio <> "" and termino = "" then	
		 	consulta = consulta &  " AND convert(datetime,convert(varchar,c.audi_fmodificacion,103),103) >= convert(datetime,'" & inicio & "',103) "& vbCrLf
		 elseif inicio = "" and termino <> "" then	
		 	consulta = consulta &  " AND convert(datetime,convert(varchar,c.audi_fmodificacion,103),103) <= convert(datetime,'" & termino & "',103) "& vbCrLf	
		 end if 
         consulta= consulta& " and e.carr_ccod = f.carr_ccod  "
		 if jorn_ccod<>"" and jorn_ccod<>"-1" then
		 consulta=consulta&" and cast(d.jorn_ccod as varchar)='"&jorn_ccod&"'"
		 end if
         consulta=consulta & " and d.jorn_ccod = g.jorn_ccod "
		 if sede_ccod<>"" and sede_ccod<>"-1" then
         	consulta=consulta & " and cast(h.sede_ccod as varchar)= '"&sede_ccod&"'"
		 end if
         consulta=consulta & " and d.sede_ccod = h.sede_ccod " 
		 consulta=consulta & " and isnull(c.eepo_ccod,1) =1 "&vbCrlf &_
         " and b.epos_ccod = 1 " & vbCrLf &_ 
		 " and b.audi_tusuario not in ('AgregaNota2T','AgregaNota3','AgregaNota37','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46'," & vbCrLf  & _
         "            'AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp'," & vbCrLf  & _
         "            'AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80'," & vbCrLf  & _
         "            'AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99') " 

end if
'response.Write("<pre>"&consulta&"</pre>")
if estado_ccod="" then
lista.carga_parametros "lista_matriculas.xml", "list_alumnos"
consulta = "select  pers_ncorr, cast(a.pers_nrut as varchar) as rut,  " &_
            "a.PERS_TAPE_PATERNO+' '+a.PERS_TAPE_MATERNO+' '+a.PERS_TNOMBRE as nombre  " &_ 
            "from personas a  where 1=2"
end if 

if estado_alumno="1" then
   consulta=consulta&" and b.post_bnuevo='N'"
elseif estado_alumno="2" then
   consulta=consulta&" and b.post_bnuevo='S'"   
end if
'response.Write("<pre>"&consulta&"</pre>")


lista.inicializar conexion 
'response.End()
lista.consultar consulta
'response.Write(consulta)
'response.End() 
if lista.nroFilas > 0 then

	cantidad_encontrados=conexion.consultaUno("Select Count(*) from ("&consulta&")a")

else
	cantidad_encontrados=0
end if
'response.End()
'----------------------------------------------------------------------- 
 set f_sedes2 = new CFormulario
 f_sedes2.Carga_Parametros "tabla_vacia.xml", "tabla"
 f_sedes2.Inicializar conexion
 consulta_sedes = "select distinct b.sede_ccod as ccod from ofertas_academicas a, sis_sedes_usuarios b where cast(a.peri_ccod as varchar)='"&v_peri_ccod&"' and a.sede_ccod=b.sede_ccod and cast(b.pers_ncorr as varchar)='"&pers_ncorr_encargado&"'" &_
                  "and a.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where cast(pers_ncorr as varchar)='"&pers_ncorr_encargado&"')"
 'response.Write(consulta_sedes)
 f_sedes2.Consultar consulta_sedes
 while f_sedes2.siguiente
 	if cad_sedes="" then
	   cad_sedes=cad_sedes&f_sedes2.obtenerValor("ccod")
	else
	   cad_sedes=cad_sedes&","&f_sedes2.obtenerValor("ccod")   
	end if
 wend

 '------------------------------------------consultamos las carreras--------------------------------------------------------
 'response.Write(sede_ccod)
 if sede_ccod="" then
	sede_ccod=conexion.consultaUno(consulta_sedes)
end if

 if sede_ccod<>"" and sede_ccod<>"-1" then
		 set f_carreras = new CFormulario
		 f_carreras.Carga_Parametros "tabla_vacia.xml", "tabla"
		 f_carreras.Inicializar conexion
		 consulta_carreras = "Select distinct c.carr_ccod,c.carr_tdesc" & vbCrLf &_ 
         			         " from ofertas_academicas a, especialidades b,carreras c" & vbCrLf &_ 
					  		 " where cast(a.sede_ccod as varchar)='"&sede_ccod&"'" & vbCrLf &_ 
                    		 " --and a.post_bnuevo='S'" & vbCrLf &_ 
                    		 " and cast(a.peri_ccod as varchar)='"&v_peri_ccod&"'" & vbCrLf &_ 
                    		 " and a.espe_ccod=b.espe_ccod" & vbCrLf &_
							 " and a.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where pers_ncorr='"&pers_ncorr_encargado&"')" & vbCrLf &_
                   		     " and b.carr_ccod=c.carr_ccod" & vbCrLf &_
                             " order by carr_tdesc"
        'response.Write("<pre>"&consulta_carreras&"</pre>")
		f_carreras.Consultar consulta_carreras
	
		while f_carreras.siguiente
			if cad_carreras="" then
			    cad_carreras=cad_carreras&"'"&f_carreras.obtenerValor("carr_ccod")&"'"
			else
		        cad_carreras=cad_carreras&",'"&f_carreras.obtenerValor("carr_ccod")&"'"
		    end if
        wend
 end if
 'response.End()

 '-----------------------------------------buscamos las jornadas que pertenecen a la carrera
 if carr_ccod<>"" and carr_ccod<>"-1" then
	  	set f_jornadas = new CFormulario
		f_jornadas.Carga_Parametros "tabla_vacia.xml", "tabla"
		f_jornadas.Inicializar conexion
		consulta_jornadas = "select distinct d.jorn_tdesc,d.jorn_ccod" & vbCrLf &_  
							" from ofertas_academicas a, carreras b,especialidades c, jornadas d " & vbCrLf &_ 
                		    " where cast(b.carr_ccod as varchar)='"&carr_ccod&"'" & vbCrLf &_ 
                    		" and b.carr_ccod=c.carr_ccod" & vbCrLf &_ 
                    		" and c.espe_ccod=a.espe_ccod" & vbCrLf &_ 
                    		" and a.jorn_ccod=d.jorn_ccod" & vbCrLf &_ 
                    		" and cast(a.sede_ccod as varchar)='"&sede_ccod&"'" & vbCrLf &_ 
                    		" and cast(a.peri_ccod as varchar)='"&v_peri_ccod&"'"
		f_jornadas.Consultar consulta_jornadas
		
		while f_jornadas.siguiente
			if cad_jornadas="" then
			    cad_jornadas=cad_jornadas&f_jornadas.obtenerValor("jorn_ccod")
			else
		        cad_jornadas=cad_jornadas&","&f_jornadas.obtenerValor("jorn_ccod")
		    end if
        wend
 end if
 
 'response.Write("sedes "&cad_sedes)
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "lista_matriculas.xml", "f_busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 
 if cad_sedes<>"" then
 	   f_busqueda.Agregacampoparam "sede_ccod", "filtro" , "sede_ccod in ("&cad_sedes&")"
 end if
 f_busqueda.AgregaCampoCons "sede_ccod", sede_ccod 
  
 	if  EsVacio(sede_ccod) or sede_ccod="-1" then
  		f_busqueda.Agregacampoparam "carr_ccod", "filtro" , "1=2"
	else
		f_busqueda.Agregacampoparam "carr_ccod", "filtro" , "carr_ccod in ("&cad_carreras&")"
	    f_busqueda.AgregaCampoCons "carr_ccod", carr_ccod 
	end if
	
		
	if EsVacio(carr_ccod) or carr_ccod="-1" then
		f_busqueda.Agregacampoparam "jorn_ccod", "filtro" , "1=2"
	else
		f_busqueda.Agregacampoparam "jorn_ccod", "filtro" , "jorn_ccod in ("&cad_jornadas&")"
	    f_busqueda.AgregaCampoCons "jorn_ccod", jorn_ccod 
	end if
	
	
 f_busqueda.Siguiente
'----------------------------------------------------------------------------------------------------------------

consulta_carreras = "Select distinct c.carr_ccod,c.carr_tdesc,a.sede_ccod" & vbCrLf &_ 
                    " from ofertas_academicas a, especialidades b,carreras c" & vbCrLf &_ 
					" where a.post_bnuevo='S'" & vbCrLf &_ 
					" and cast(a.peri_ccod as varchar)='"&v_peri_ccod&"'" & vbCrLf &_ 
                    " and a.espe_ccod=b.espe_ccod" & vbCrLf &_
					" and a.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where pers_ncorr='"&pers_ncorr_encargado&"')" & vbCrLf &_
                    " and b.carr_ccod=c.carr_ccod" 

'response.End()
conexion.Ejecuta consulta_carreras
set rec_carreras = conexion.ObtenerRS

consulta_jornadas = "select distinct d.jorn_tdesc,d.jorn_ccod,b.carr_ccod" & vbCrLf &_  
					" from ofertas_academicas a, carreras b,especialidades c, jornadas d " & vbCrLf &_ 
                    " where b.carr_ccod=c.carr_ccod" & vbCrLf &_ 
                    " and c.espe_ccod=a.espe_ccod" & vbCrLf &_ 
                    " and a.jorn_ccod=d.jorn_ccod" & vbCrLf &_ 
                    " and cast(a.peri_ccod as varchar)='"&v_peri_ccod&"'"

conexion.Ejecuta consulta_jornadas
set rec_jornadas=conexion.ObtenerRS

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
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>

<script language="JavaScript">
function filtrarFacultades(formulario)
{
formulario.paso.value="";
formulario.method="get";
formulario.action="segui_matriculas.asp";
formulario.submit();
}
function filtrarCarreras(formulario)
{
formulario.paso.value="";
formulario.method="get";
formulario.action="segui_matriculas.asp";
formulario.submit();
}
function enviar(formulario)
{
if(document.buscador.elements["estado_ccod"].value!=""){
document.buscador.paso.value="1";
document.buscador.method="get";
document.buscador.action="segui_matriculas.asp";
document.buscador.submit();
}
else
alert("Debe seleccionar un estado para listar los alumnos");


}
function salir(){
location.href="../lanzadera/lanzadera_up.asp?resolucion=1152";
}
function MM_nbGroup(event, grpName) { //v6.0
  var i,img,nbArr,args=MM_nbGroup.arguments;
  if (event == "init" && args.length > 2) {
    if ((img = MM_findObj(args[2])) != null && !img.MM_init) {
      img.MM_init = true; img.MM_up = args[3]; img.MM_dn = img.src;
      if ((nbArr = document[grpName]) == null) nbArr = document[grpName] = new Array();
      nbArr[nbArr.length] = img;
      for (i=4; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
        if (!img.MM_up) img.MM_up = img.src;
        img.src = img.MM_dn = args[i+1];
        nbArr[nbArr.length] = img;
    } }
  } else if (event == "over") {
    document.MM_nbOver = nbArr = new Array();
    for (i=1; i < args.length-1; i+=3) if ((img = MM_findObj(args[i])) != null) {
      if (!img.MM_up) img.MM_up = img.src;
      img.src = (img.MM_dn && args[i+2]) ? args[i+2] : ((args[i+1])? args[i+1] : img.MM_up);
      nbArr[nbArr.length] = img;
    }
  } else if (event == "out" ) {
    for (i=0; i < document.MM_nbOver.length; i++) {
      img = document.MM_nbOver[i]; img.src = (img.MM_dn) ? img.MM_dn : img.MM_up; }
  } else if (event == "down") {
    nbArr = document[grpName];
    if (nbArr)
      for (i=0; i < nbArr.length; i++) { img=nbArr[i]; img.src = img.MM_up; img.MM_dn = 0; }
    document[grpName] = nbArr = new Array();
    for (i=2; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
      if (!img.MM_up) img.MM_up = img.src;
      img.src = img.MM_dn = (args[i+1])? args[i+1] : img.MM_up;
      nbArr[nbArr.length] = img;
  } }
}

arr_carreras = new Array();
arr_jornadas =new Array();

<%
rec_carreras.MoveFirst
i = 0
while not rec_carreras.Eof
%>
arr_carreras[<%=i%>] = new Array();
arr_carreras[<%=i%>]["carr_ccod"] = '<%=rec_carreras("carr_ccod")%>';
arr_carreras[<%=i%>]["carr_tdesc"] = '<%=rec_carreras("carr_tdesc")%>';
arr_carreras[<%=i%>]["sede_ccod"] = '<%=rec_carreras("sede_ccod")%>';
<%	
	rec_carreras.MoveNext
	i = i + 1
wend
%>

<%
rec_jornadas.MoveFirst
j = 0
while not rec_jornadas.Eof
%>
arr_jornadas[<%=j%>] = new Array();
arr_jornadas[<%=j%>]["jorn_ccod"] = '<%=rec_jornadas("jorn_ccod")%>';
arr_jornadas[<%=j%>]["jorn_tdesc"] = '<%=rec_jornadas("jorn_tdesc")%>';
arr_jornadas[<%=j%>]["carr_ccod"] = '<%=rec_jornadas("carr_ccod")%>';
<%	
	rec_jornadas.MoveNext
	j = j + 1
wend
%>

function CargarCarreras(formulario, sede_ccod)
{
	formulario.elements["busqueda[0][carr_ccod]"].length = 0;
	op = document.createElement("OPTION");
	op.value = "-1";
	op.text = "Seleccione Carreras";
	formulario.elements["busqueda[0][carr_ccod]"].add(op)
	for (i = 0; i < arr_carreras.length; i++)
	  { 
		if (arr_carreras[i]["sede_ccod"] == sede_ccod)
		 {
			op = document.createElement("OPTION");
			op.value = arr_carreras[i]["carr_ccod"];
			op.text = arr_carreras[i]["carr_tdesc"];
			formulario.elements["busqueda[0][carr_ccod]"].add(op)			
		 }
	}	
}

function CargarJornadas(formulario, carr_ccod)
{
	formulario.elements["busqueda[0][jorn_ccod]"].length = 0;
	op = document.createElement("OPTION");
	op.value = "-1";
	op.text = "Seleccione Jornada";
	formulario.elements["busqueda[0][jorn_ccod]"].add(op)
	for (j = 0; j < arr_jornadas.length; j++)
	  { 
		if (arr_jornadas[j]["carr_ccod"] == carr_ccod)
		 {
			op = document.createElement("OPTION");
			op.value = arr_jornadas[j]["jorn_ccod"];
			op.text = arr_jornadas[j]["jorn_tdesc"];
			formulario.elements["busqueda[0][jorn_ccod]"].add(op)			
		 }
	}	
}

function inicio()
{
  <%if sede_ccod <> "" then%>
    CargarCarreras(buscador, <%=sede_ccod%>);
	buscador.elements["busqueda[0][carr_ccod]"].value ='<%=carr_ccod%>'; 
  <%end if%>
  <%if carr_ccod <> "" then%>
    CargarJornadas(buscador, <%=carr_ccod%>);
	buscador.elements["busqueda[0][jorn_ccod]"].value ='<%=jorn_ccod%>'; 
  <%end if%>
}

</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "inicio","1","buscador","fecha_oculta_inicio"
	calendario.MuestraFecha "termino","2","buscador","fecha_oculta_termino"
	calendario.FinFuncion
%>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../jefe_carrera/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();" >
<%calendario.ImprimeVariables%>
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="72" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador" method="get" action="">
              <br><input type="hidden" name="paso" value="">
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="91%"><div align="center">
                    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="13%"><div align="left"><strong>Sede </strong></div></td>
                        <td width="2%"><div align="center">:</div></td>
                                <td colspan="5"><%f_busqueda.DibujaCampo("sede_ccod")%></td>				
					  </tr>
					  <tr>
                        <td><div align="left"><strong>Carrera </strong></div></td>
                        <td width="2%"><div align="center">:</div></td>
                        <td colspan="5"><%f_busqueda.DibujaCampo("carr_ccod")%></td>	
                      </tr>
					  <tr>
                        <td><div align="left"><strong>Jornada </strong></div></td>
                        <td width="2%"><div align="center">:</div></td>
                        <td colspan="5"><%f_busqueda.DibujaCampo("jorn_ccod")%></td>	
                      </tr>
					  <tr>
                        <td width="13%"><div align="left"><strong>Estado </strong></div></td>
                        <td width="2%"><div align="center">:</div></td>
                        <td colspan="2"><select name='estado_ccod'>
						    <%if estado_ccod="" then%>
                            <option value='' selected>Estados</option>
							<%else%>
							<option value=''>Estados</option>
							<%end if%>
							<%if v_peri_ccod="164" then%>
									<%if estado_ccod="1" then%>
									<option value='1' selected>TEST NO PAGADO</option>
									<%else%>
									<option value='1' >TEST NO PAGADO</option>
									<%end if%>
									<%if estado_ccod="2" then%>
									<option value='2' selected>TEST PAGADO SIN RENDIR</option>
									<%else%>
									<option value='2' >TEST PAGADO SIN RENDIR</option>
									<%end if%>
									<%if estado_ccod="3" then%>
									<option value='3' selected>TEST RENDIDO SIN MATRICULAR</option>
									<%else%>
									<option value='3' >TEST RENDIDO SIN MATRICULAR</option>
									<%end if%>
									<%if estado_ccod="4" then%>
									<option value='4' selected>MATRICULA ACTIVA</option>
									<%else%>
									<option value='4' >MATRICULA ACTIVA</option>
									<%end if%>
									<%if estado_ccod="5" then%>
									<option value='5' selected>MATRICULA ANULADA</option>
									<%else%>
									<option value='5' >MATRICULA ANULADA</option>
									<%end if%>
							<%else%>
									<%if estado_ccod="9" then%>
									<option value='9' selected>POSTULACIÓN SIN ENVIAR</option>
									<%else%>
									<option value='9' >POSTULACIÓN SIN ENVIAR</option>
									<%end if%>
									<%if estado_ccod="6" then%>
									<option value='6' selected>POSTULACIÓN ENVIADA SIN RENDIR</option>
									<%else%>
									<option value='6' >POSTULACIÓN ENVIADA SIN RENDIR</option>
									<%end if%>
									<%if estado_ccod="7" then%>
									<option value='7' selected>TEST RENDIDO </option>
									<%else%>
									<option value='7' >TEST RENDIDO </option>
									<%end if%>
									<%if estado_ccod="8" then%>
									<option value='8' selected>MATRICULA ANTICIPADA ACTIVA</option>
									<%else%>
									<option value='8' >MATRICULA ANTICIPADA ACTIVA</option>
									<%end if%>
									<%if estado_ccod="4" then%>
									<option value='4' selected>MATRICULADOS</option>
									<%else%>
									<option value='4' >MATRICULADOS</option>
									<%end if%>
							<%end if%>
                           </select> 
						 </td>  
						 <td width="8%"><div align="left"><strong>Alumno </strong></div></td>
                         <td width="1%"><div align="center">:</div></td>
                         <td width="42%"><select name='estado_alumno'>
						    <%if estado_alumno="" then%>
                            <option value='' selected>Seleccione tipo</option>
							<%else%>
							<option value=''>Seleccione tipo</option>
							<%end if%>
							<%if estado_alumno="1" then%>
							<option value='1' selected>ANTIGUO</option>
							<%else%>
							<option value='1' >ANTIGUO</option>
							<%end if%>
							<%if estado_alumno="2" then%>
                            <option value='2' selected>NUEVO</option>
							<%else%>
							<option value='2' >NUEVO</option>
							<%end if%>
						  </select> 
						 </td>
					  </tr>
					  <tr> 
                          <td><strong>Inicio</strong></td>
                          <td>:</td>
                          <td><div align="left"></div>
                            <input type="text" name="inicio" maxlength="10" size="12" value="<%=inicio%>"><%calendario.DibujaImagen "fecha_oculta_inicio","1","buscador" %>
                            (dd/mm/aaaa) </td>
                          <td>&nbsp;</td>
                          <td><strong>T&eacute;rmino</strong></td>
                          <td>:</td>
                          <td><div align="left"> 
                             <input type="text" name="termino" maxlength="10" size="12" value="<%=termino%>">
                              <%calendario.DibujaImagen "fecha_oculta_termino","2","buscador" %>
                              (dd/mm/aaaa) </div></td>
                        </tr>
                    </table>
                  </div></td>
                  <td width="9%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td>
                </tr>
              </table>
            </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	<br>
	<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"> 
                    <%pagina.DibujarTituloPagina%>
                </div>
              <form name="edicion" method="post" action="">
			  <input type="hidden" name="sede" value="<%=sede_ccod%>">
              <input type="hidden" name="jornada" value="<%=jorn_ccod%>">
			  <input type="hidden" name="carrera" value="<%=carr_ccod%>">
			  <input type="hidden" name="estado_ccod" value="<%=estado_ccod%>">
			  <input type="hidden" name="paso" value="<%=busqueda%>">
			     			  
                  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><strong>Cantidad Encontrados :&nbsp;&nbsp;</strong><%=cantidad_encontrados%>&nbsp; Alumnos
                      <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                             <td align="right">P&aacute;gina:
                                 <%lista.accesopagina%>
                             </td>
                             </tr>
                               <tr>
                                 <td align="center">
                                    <%lista.dibujaTabla()%>
                                  </td>
                             </tr>
							 <tr>
							    <td>&nbsp;
								</td>
							</tr>
							<%if estado_ccod="5" then%>
							<tr>
							    <td> * los alumnos con matricula anulada presentan la fecha en que se hizo el cambio de estado acad&eacute;mico 
								</td>
							</tr>
							<%end if%>
							<%if usuario = "13435333" then%>
							<tr>
							    <td>&nbsp;</td>
							</tr>
							<tr>
							    <td align="center">
									<table width="77%" border="1" bordercolor="#FFFFFF">
										<tr>
											<td colspan="3" bgcolor="#c4d7ff" align="left">
											  <font face="Courier New, Courier, mono" size="2" color="#000000"><strong>Reportes diarios de admisión Marketing</strong></font>
											</td>
										</tr>
										<tr>
											<td width="33%" align="center" bgcolor="#FFFFFF">
											   <%f_botonera.agregabotonparam "excel_temporal", "url", "alumnos_email.asp?tipo=1"
											     f_botonera.agregabotonparam "excel_temporal", "texto", "Postulantes"
												 f_botonera.dibujaboton "excel_temporal"%>
											</td>
											<td width="34%" align="center" bgcolor="#FFFFFF">
											   <%f_botonera.agregabotonparam "excel_temporal", "url", "alumnos_email.asp?tipo=2"
											     f_botonera.agregabotonparam "excel_temporal", "texto", "Test Aprobado" 
												 f_botonera.dibujaboton "excel_temporal"%>
											</td>
											<td width="33%" align="center" bgcolor="#FFFFFF">
											   <%f_botonera.agregabotonparam "excel_temporal", "url", "alumnos_email.asp?tipo=3"
											     f_botonera.agregabotonparam "excel_temporal", "texto", "Matriculados"
												 f_botonera.dibujaboton "excel_temporal"%>
											</td>
										</tr>										
									</table>
								</td>
							</tr>
							<%end if%>
                          </table>
                     </td>
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
            <td width="16%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="51%"><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
				  <td width="29%"> <div align="center">  <% if cantidad_encontrados = 0 then
				                                                f_botonera.agregabotonparam "excel","deshabilitado","TRUE"    
															end if																             
					                       f_botonera.agregabotonparam "excel", "url", "segui_matriculas_excel.asp?sede_ccod="&sede_ccod&"&jorn_ccod="&jorn_ccod&"&carr_ccod="&carr_ccod&"&estado_ccod="&estado_ccod&"&estado_alumno="&estado_alumno&"&inicio="&inicio&"&termino="&termino
										   f_botonera.dibujaboton "excel"
										%>
					 </div>
                  </td>
				  <td width="20%">&nbsp;</td>
                  </tr>
              </table>
            </div></td>
            <td width="84%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
