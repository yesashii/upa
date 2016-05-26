<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=segui_matriculas_excel.xls"
Response.ContentType = "application/vnd.ms-excel"

sede_ccod = Request.QueryString("sede_ccod")
jorn_ccod = Request.QueryString("jorn_ccod")
carr_ccod = Request.QueryString("carr_ccod")
estado_ccod = Request.QueryString("estado_ccod")
estado_alumno = Request.QueryString("estado_alumno")
inicio = request.querystring("inicio")
termino = request.querystring("termino")


'------------------------------------------------------------------------------------
set pagina = new CPagina
'------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------------
v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")
if v_peri_ccod = "200" then
    filtro_matriculas = " and  exists (select 1 from alumnos alu,contratos cont where b.post_ncorr=alu.post_ncorr and alu.emat_ccod in (1,4,8,10) and alu.matr_ncorr=cont.matr_ncorr and cont.econ_ccod=1) "
    fecha_matricula = " (select protic.trunc(cont.cont_fcontrato) from alumnos alu,contratos cont where b.post_ncorr=alu.post_ncorr and alu.emat_ccod in (1,4,8,10) and alu.matr_ncorr=cont.matr_ncorr and cont.econ_ccod=1) "	
	if inicio <> "" and termino <> "" then
			filtro_fecha = " AND (select convert(datetime,convert(varchar,cont.cont_fcontrato,103),103) from alumnos alu,contratos cont where b.post_ncorr=alu.post_ncorr and alu.emat_ccod in (1,4,8,10) and alu.matr_ncorr=cont.matr_ncorr and cont.econ_ccod=1) between convert(datetime,'" & inicio & "',103) and convert(datetime,'" & termino & "',103)"& vbCrLf
	 elseif inicio <> "" and termino = "" then	
		 	filtro_fecha = " AND (select convert(datetime,convert(varchar,cont.cont_fcontrato,103),103) from alumnos alu,contratos cont where b.post_ncorr=alu.post_ncorr and alu.emat_ccod in (1,4,8,10) and alu.matr_ncorr=cont.matr_ncorr and cont.econ_ccod=1) >= convert(datetime,'" & inicio & "',103) "& vbCrLf
	 elseif inicio = "" and termino <> "" then	
		 	filtro_fecha = " AND (select convert(datetime,convert(varchar,cont.cont_fcontrato,103),103) from alumnos alu,contratos cont where b.post_ncorr=alu.post_ncorr and alu.emat_ccod in (1,4,8,10) and alu.matr_ncorr=cont.matr_ncorr and cont.econ_ccod=1) <= convert(datetime,'" & termino & "',103) "& vbCrLf	
	 end if
	
elseif v_peri_ccod= "202" then
	filtro_matriculas = " And isnull((select sum(protic.total_recepcionar_cuota(37,comp.inst_ccod,comp.comp_ndocto,dcom.dcom_ncompromiso)) " & vbCrLf &_ 
         			   " from compromisos comp, detalle_compromisos dcom " & vbCrLf &_ 
                       " where comp.post_ncorr = c.post_ncorr and comp.ofer_ncorr = c.ofer_ncorr and  comp.comp_ndocto=dcom.comp_ndocto and  comp.tcom_ccod=dcom.tcom_ccod and  comp.inst_ccod=dcom.inst_ccod and comp.ecom_ccod <> 3 and comp.tcom_ccod=37),1) = 0 "
	fecha_matricula =  " (select protic.trunc(max(abo.abon_fabono)) " & vbCrLf &_ 
         			   " from compromisos comp, detalle_compromisos dcom, abonos abo " & vbCrLf &_ 
                       " where comp.post_ncorr = c.post_ncorr and comp.ofer_ncorr = c.ofer_ncorr and comp.tcom_ccod=37 and  comp.comp_ndocto=dcom.comp_ndocto  and comp.tcom_ccod = dcom.tcom_ccod and  abo.comp_ndocto=dcom.comp_ndocto  and abo.tcom_ccod = dcom.tcom_ccod) "
	if inicio <> "" and termino <> "" then
			filtro_fecha = " AND (select convert(varchar,max(abo.abon_fabono),103) " & vbCrLf &_ 
         			       " from compromisos comp, detalle_compromisos dcom, abonos abo " & vbCrLf &_ 
                           " where comp.post_ncorr = c.post_ncorr and comp.ofer_ncorr = c.ofer_ncorr and comp.tcom_ccod=37 and  comp.comp_ndocto=dcom.comp_ndocto  and comp.tcom_ccod = dcom.tcom_ccod and  abo.comp_ndocto=dcom.comp_ndocto  and abo.tcom_ccod = dcom.tcom_ccod) " & vbCrLf &_
                           " between convert(datetime,'" & inicio & "',103) and convert(datetime,'" & termino & "',103)"& vbCrLf
	 elseif inicio <> "" and termino = "" then	
		 	filtro_fecha = " AND (select convert(varchar,max(abo.abon_fabono),103) " & vbCrLf &_ 
         			       " from compromisos comp, detalle_compromisos dcom, abonos abo " & vbCrLf &_ 
                           " where comp.post_ncorr = c.post_ncorr and comp.ofer_ncorr = c.ofer_ncorr and comp.tcom_ccod=37 and  comp.comp_ndocto=dcom.comp_ndocto  and comp.tcom_ccod = dcom.tcom_ccod and  abo.comp_ndocto=dcom.comp_ndocto  and abo.tcom_ccod = dcom.tcom_ccod) " & vbCrLf &_
			               " >= convert(datetime,'" & inicio & "',103) "& vbCrLf
	 elseif inicio = "" and termino <> "" then	
		 	filtro_fecha = " AND (select convert(varchar,max(abo.abon_fabono),103) " & vbCrLf &_ 
         			       " from compromisos comp, detalle_compromisos dcom, abonos abo " & vbCrLf &_ 
                           " where comp.post_ncorr = c.post_ncorr and comp.ofer_ncorr = c.ofer_ncorr and comp.tcom_ccod=37 and  comp.comp_ndocto=dcom.comp_ndocto  and comp.tcom_ccod = dcom.tcom_ccod and  abo.comp_ndocto=dcom.comp_ndocto  and abo.tcom_ccod = dcom.tcom_ccod) " & vbCrLf &_
			               " <= convert(datetime,'" & termino & "',103) "& vbCrLf	
	 end if		   
end if


Usuario = negocio.ObtenerUsuario()
pers_ncorr_encargado=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")
peri_tdesc=conexion.consultaUno("Select peri_tdesc from periodos_academicos where cast(peri_ccod as varchar)='"&v_peri_ccod&"'")
'------------------------------------------------------------------------------------

consulta="select count(*) from especialidades a,ofertas_academicas b" & vbCrLf &_ 
		 " where cast(b.peri_ccod as varchar)='"&v_peri_ccod&"'" 
		 if carr_ccod<>"" and carr_ccod<>"-1" then
            consulta=consulta & " and cast(a.carr_ccod as varchar)='"&carr_ccod&"'" & vbCrLf &_
            " and a.espe_ccod=b.espe_ccod"
		 end if
         consulta=consulta & " and cast(b.sede_ccod as varchar)='"&sede_ccod&"'" & vbCrLf &_
         " and b.ofer_bpaga_examen='N' and b.post_bnuevo='S'"
'response.Write("<pre>"&consulta&"</pre>")
paga = conexion.consultaUno(consulta)

if estado_ccod="4" then
    estado="MATRICULADOS"
elseif estado_ccod="6" then
	estado="APROBADO SIN COMPLETAR"
elseif estado_ccod="7" then
	estado="FICHA COMPLETA, SIN MATRICULAR"
elseif estado_ccod="9" then
	estado="POSTULADO SIN RENDIR"
end if


set lista = new CFormulario
lista.carga_parametros "tabla_vacia.xml", "tabla"
if estado_ccod="4" then
consulta=" select distinct " & vbCrLf &_
		 "        isnull((select top 1 'Matriculado(a) en ' + sede_tdesc + ' - ' + carr_tdesc + ' ' + jorn_tdesc " & vbCrLf &_
		 "		  from alumnos aaa, ofertas_academicas bbb, sedes ccc, jornadas ddd, especialidades eee, carreras fff " & vbCrLf &_
		 "		  where aaa.pers_ncorr=a.pers_ncorr and aaa.emat_ccod in (1,4,8) " & vbCrLf &_
		 "        and aaa.ofer_ncorr=bbb.ofer_ncorr and bbb.peri_ccod = b.peri_ccod " & vbCrLf &_
		 "        and bbb.sede_ccod= ccc.sede_ccod  and bbb.jorn_ccod=ddd.jorn_ccod  " & vbCrLf &_
		 "        and bbb.espe_ccod=eee.espe_ccod and eee.carr_ccod=fff.carr_ccod  " & vbCrLf &_
		 "        ),'No') as matriculado,    " & vbCrLf &_
         " protic.FORMAT_RUT(cast(a.pers_nrut as varchar(10))) as rut,case j.emat_ccod when 1 then protic.trunc(i.alum_fmatricula) when 4 then protic.trunc(i.alum_fmatricula) when 8 then protic.trunc(i.alum_fmatricula) else protic.trunc(i.audi_fmodificacion) end as fecha," & vbCrLf &_ 
         " a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre, f.carr_tdesc as carrera, h.sede_tdesc as sede,e.espe_tdesc," & vbCrLf &_ 
         " a.pers_tfono as fono,a.pers_tcelular as celular, case a.pers_temail when null then '' else '<A href=""mailto:'+a.pers_temail+'"">'+a.pers_temail+'</a>' end  as email,g.jorn_tdesc as jornada," & vbCrLf &_ 
		 " '<font color=''' + case j.emat_ccod when 1 then '#0033FF' when 4 then '#0033FF' when 8 then '#0033FF' else '#CC0000' end +'''>' + j.emat_tdesc +'</font>' as estado, " & vbCrLf &_ 
		 " (select pers_tnombre +' ' + pers_tape_paterno from postulantes_por_agente aa, agentes_postulacion bb, personas cc " & vbCrLf &_ 
         "    where aa.post_ncorr=b.post_ncorr and aa.sede_ccod=d.sede_ccod and aa.sede_ccod=bb.sede_ccod and aa.id=bb.id " & vbCrLf &_ 
  		 "    and bb.pers_ncorr=cc.pers_ncorr) as agente " & vbCrLf &_ 
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
		 if carr_ccod <> "" and carr_ccod <> "-1" then 
	         consulta=consulta & " and cast(f.carr_ccod as varchar)= '"&carr_ccod&"'" 
		 end if
		 if inicio <> "" and termino <> "" then
			consulta = consulta &  " AND convert(datetime,convert(varchar,i.alum_fmatricula,103),103) between  convert(datetime,'" & inicio & "',103) and convert(datetime,'" & termino & "',103)"& vbCrLf
		 elseif inicio <> "" and termino = "" then	
		 	consulta = consulta &  " AND convert(datetime,convert(varchar,i.alum_fmatricula,103),103) >= convert(datetime,'" & inicio & "',103) "& vbCrLf
		 elseif inicio = "" and termino <> "" then	
		 	consulta = consulta &  " AND convert(datetime,convert(varchar,i.alum_fmatricula,103),103) <= convert(datetime,'" & termino & "',103) "& vbCrLf	
		 end if 
         consulta=consulta & " and e.carr_ccod = f.carr_ccod  "
		 if jorn_ccod <> "" and jorn_ccod <> "-1" then
		 	consulta=consulta&" and cast(d.jorn_ccod as varchar)='"&jorn_ccod&"'"
		 end if
         consulta=consulta & " and d.jorn_ccod = g.jorn_ccod "
     	 if sede_ccod<>"" and sede_ccod<>"-1" then
         	consulta= consulta & " and cast(h.sede_ccod as varchar)= '"&sede_ccod&"'"
		 end if
         consulta=consulta & " and d.sede_ccod = h.sede_ccod " & vbCrLf &_ 
	 	 " and b.epos_ccod = 2 " & vbCrLf &_ 
		 " and b.post_ncorr=i.post_ncorr and b.ofer_ncorr=i.ofer_ncorr and b.pers_ncorr=i.pers_ncorr and i.emat_ccod in (1,4,8) " & vbCrLf &_ 
 		 " and i.emat_ccod=j.emat_ccod" & vbCrLf &_ 
		 " and  exists (select 1 from alumnos alu where b.post_ncorr=alu.post_ncorr and alu.emat_ccod in (1,4,8) and isnull(alum_nmatricula,0) <> '7777' "& vbCrLf  & _
		 " ) " 
 
 
' eliminada la validacion de tipo de postulacion
   ' " --and b.tpos_ccod = 1 "
   
end if

if estado_ccod="6" then

consulta=" select distinct " & vbCrLf &_
		 "        isnull((select top 1 'Matriculado(a) en ' + sede_tdesc + ' - ' + carr_tdesc + ' ' + jorn_tdesc " & vbCrLf &_
		 "		  from alumnos aaa, ofertas_academicas bbb, sedes ccc, jornadas ddd, especialidades eee, carreras fff " & vbCrLf &_
		 "		  where aaa.pers_ncorr=a.pers_ncorr and aaa.emat_ccod in (1,4,8) " & vbCrLf &_
		 "        and aaa.ofer_ncorr=bbb.ofer_ncorr and bbb.peri_ccod = b.peri_ccod " & vbCrLf &_
		 "        and bbb.sede_ccod= ccc.sede_ccod  and bbb.jorn_ccod=ddd.jorn_ccod  " & vbCrLf &_
		 "        and bbb.espe_ccod=eee.espe_ccod and eee.carr_ccod=fff.carr_ccod  " & vbCrLf &_
		 "        ),'No') as matriculado,    " & vbCrLf &_
         " protic.FORMAT_RUT(cast(a.pers_nrut as varchar(10))) as rut,protic.trunc(c.audi_fmodificacion) as fecha," & vbCrLf &_ 
         " a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre, f.carr_tdesc as carrera, h.sede_tdesc as sede,e.espe_tdesc," & vbCrLf &_ 
         " a.pers_tfono as fono,a.pers_tcelular as celular, case a.pers_temail when null then '' else '<A href=""mailto:'+a.pers_temail+'"">'+a.pers_temail+'</a>' end  as email,g.jorn_tdesc as jornada," & vbCrLf &_ 
		 " isnull(i.obpo_tobservacion,'--') as observacion,j.eopo_tdesc as obs_postulacion,  " & vbCrLf &_ 	
		 " (select pers_tnombre +' ' + pers_tape_paterno from postulantes_por_agente aa, agentes_postulacion bb, personas cc " & vbCrLf &_ 
         "    where aa.post_ncorr=b.post_ncorr and aa.sede_ccod=d.sede_ccod and aa.sede_ccod=bb.sede_ccod and aa.id=bb.id " & vbCrLf &_ 
  		 "    and bb.pers_ncorr=cc.pers_ncorr) as agente " & vbCrLf &_ 
         " from  " & vbCrLf &_ 
         " personas_postulante a join postulantes b " & vbCrLf &_ 
		 "		on	a.pers_ncorr = b.pers_ncorr" & vbCrLf &_  
		 " join detalle_postulantes c " & vbCrLf &_ 
		 " 		on b.post_ncorr = c.post_ncorr" & vbCrLf &_ 
         " join ofertas_academicas d" & vbCrLf &_ 
		 "		on c.ofer_ncorr = d.ofer_ncorr" & vbCrLf &_ 
		 " join especialidades e" & vbCrLf &_ 
		 "		on d.espe_ccod = e.espe_ccod" & vbCrLf &_ 
		 " join carreras f " & vbCrLf &_ 
		 "		on e.carr_ccod = f.carr_ccod" & vbCrLf &_ 
		 " join jornadas g " & vbCrLf &_ 
         "		on d.jorn_ccod = g.jorn_ccod" & vbCrLf &_ 
		 " join sedes h " & vbCrLf &_ 
		 "		on d.sede_ccod = h.sede_ccod" & vbCrLf &_ 
  	     " left outer join observaciones_postulacion i " & vbCrLf &_ 
		 " on c.post_ncorr = i.post_ncorr and c.ofer_ncorr=i.ofer_ncorr "& vbCrLf &_ 
         " left outer join estado_observaciones_postulacion j " & vbCrLf &_ 
		 " on isnull(i.eopo_ccod,1) = j.eopo_ccod "& vbCrLf &_ 
         " where  cast(b.peri_ccod as varchar)='"&v_peri_ccod&"'" & vbCrLf &_ 
         " and d.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where pers_ncorr='"&pers_ncorr_encargado&"')" 
		 if carr_ccod <> "" and carr_ccod <> "-1" then
         	consulta= consulta & " and cast(f.carr_ccod as varchar)= '"&carr_ccod&"'" 
		 end if
		 if inicio <> "" and termino <> "" then
			consulta = consulta &  " AND convert(datetime,convert(varchar,c.audi_fmodificacion,103),103) between convert(datetime,'" & inicio & "',103) and convert(datetime,'" & termino & "',103)"& vbCrLf
		 elseif inicio <> "" and termino = "" then	
		 	consulta = consulta &  " AND convert(datetime,convert(varchar,c.audi_fmodificacion,103),103) >= convert(datetime,'" & inicio & "',103) "& vbCrLf
		 elseif inicio = "" and termino <> "" then	
		 	consulta = consulta &  " AND convert(datetime,convert(varchar,c.audi_fmodificacion,103),103) <= convert(datetime,'" & termino & "',103) "& vbCrLf	
		 end if 
         consulta= consulta& " "
		 if jorn_ccod <> "" and jorn_ccod <> "-1" then
		 consulta=consulta&" and cast(d.jorn_ccod as varchar)='"&jorn_ccod&"'"
		 end if
         consulta=consulta & "  "
		 if sede_ccod <> "" and sede_ccod <> "-1" then
         	consulta=consulta & " and cast(h.sede_ccod as varchar)= '"&sede_ccod&"'"
		 end if
         consulta=consulta & "  " 
		 consulta=consulta & " and c.eepo_ccod = 2"&vbCrlf &_
         " and b.epos_ccod = 1 " 

end if

if estado_ccod="7" then

consulta=" select distinct " & vbCrLf &_
		 "        isnull((select top 1 'Matriculado(a) en ' + sede_tdesc + ' - ' + carr_tdesc + ' ' + jorn_tdesc " & vbCrLf &_
		 "		  from alumnos aaa, ofertas_academicas bbb, sedes ccc, jornadas ddd, especialidades eee, carreras fff " & vbCrLf &_
		 "		  where aaa.pers_ncorr=a.pers_ncorr and aaa.emat_ccod in (1,4,8) " & vbCrLf &_
		 "        and aaa.ofer_ncorr=bbb.ofer_ncorr and bbb.peri_ccod = b.peri_ccod " & vbCrLf &_
		 "        and bbb.sede_ccod= ccc.sede_ccod  and bbb.jorn_ccod=ddd.jorn_ccod  " & vbCrLf &_
		 "        and bbb.espe_ccod=eee.espe_ccod and eee.carr_ccod=fff.carr_ccod  " & vbCrLf &_
		 "        ),'No') as matriculado,    " & vbCrLf &_
         " protic.FORMAT_RUT(cast(a.pers_nrut as varchar(10))) as rut,isnull(protic.trunc(c.audi_fmodificacion),protic.trunc(getDate())) as fecha," & vbCrLf &_ 
         " a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre, f.carr_tdesc as carrera, h.sede_tdesc as sede,e.espe_tdesc," & vbCrLf &_ 
         " a.pers_tfono as fono,a.pers_tcelular as celular, case a.pers_temail when null then '' else '<A href=""mailto:'+a.pers_temail+'"">'+a.pers_temail+'</a>' end  as email,g.jorn_tdesc as jornada," & vbCrLf &_
		 " i.eepo_tdesc as estado_examen," & vbCrLf &_ 
         " isnull(j.obpo_tobservacion,'--') as observacion,k.eopo_tdesc as obs_postulacion,  " & vbCrLf &_ 	
		 " (select pers_tnombre +' ' + pers_tape_paterno from postulantes_por_agente aa, agentes_postulacion bb, personas cc " & vbCrLf &_ 
         "    where aa.post_ncorr=b.post_ncorr and aa.sede_ccod=d.sede_ccod and aa.sede_ccod=bb.sede_ccod and aa.id=bb.id " & vbCrLf &_ 
  		 "    and bb.pers_ncorr=cc.pers_ncorr) as agente " & vbCrLf &_ 
		 " from  personas_postulante a join postulantes b " & vbCrLf &_
		 "		on a.pers_ncorr = b.pers_ncorr" & vbCrLf &_ 
		 " join detalle_postulantes c " & vbCrLf &_ 
		 "		on b.post_ncorr = c.post_ncorr" & vbCrLf &_
         " join ofertas_academicas d " & vbCrLf &_
		 " 		on c.ofer_ncorr = d.ofer_ncorr" & vbCrLf &_
		 " join especialidades e " & vbCrLf &_
		 "		on d.espe_ccod = e.espe_ccod" & vbCrLf &_
		 " join carreras f " & vbCrLf &_
		 "		on e.carr_ccod = f.carr_ccod" & vbCrLf &_
		 " join jornadas g " & vbCrLf &_ 
		 "		on d.jorn_ccod = g.jorn_ccod" & vbCrLf &_
         " join sedes h " & vbCrLf &_
		 "		on d.sede_ccod = h.sede_ccod" & vbCrLf &_
		 " join estado_examen_postulantes i  " & vbCrLf &_ 
		 "		on c.eepo_ccod = i.eepo_ccod " & vbCrLf &_
	     " left outer join observaciones_postulacion j " & vbCrLf &_ 
		 " on c.post_ncorr = j.post_ncorr and c.ofer_ncorr=j.ofer_ncorr "& vbCrLf &_ 
         " left outer join estado_observaciones_postulacion k " & vbCrLf &_ 
		 " on isnull(j.eopo_ccod,1) = k.eopo_ccod "& vbCrLf &_ 
         " where  cast(b.peri_ccod as varchar)='"&v_peri_ccod&"'" & vbCrLf &_ 
		 " and exists (select 1 from aranceles tt where tt.aran_ncorr=d.aran_ncorr and isnull(tt.aran_mmatricula,0) <> 0) " & vbCrLf &_
         " and d.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where pers_ncorr='"&pers_ncorr_encargado&"')"
         if carr_ccod <> "" and carr_ccod <> "-1" then
         	consulta= consulta & " and cast(f.carr_ccod as varchar)= '"&carr_ccod&"'" 
		 end if
		 if inicio <> "" and termino <> "" then
			consulta = consulta &  " AND convert(datetime,convert(varchar,c.audi_fmodificacion,103),103) between convert(datetime,'" & inicio & "',103) and convert(datetime,'" & termino & "',103)"& vbCrLf
		 elseif inicio <> "" and termino = "" then	
		 	consulta = consulta &  " AND convert(datetime,convert(varchar,c.audi_fmodificacion,103),103) >= convert(datetime,'" & inicio & "',103) "& vbCrLf
		 elseif inicio = "" and termino <> "" then	
		 	consulta = consulta &  " AND convert(datetime,convert(varchar,c.audi_fmodificacion,103),103) <= convert(datetime,'" & termino & "',103) "& vbCrLf	
		 end if 
         consulta= consulta& " "
		 if jorn_ccod <> "" and jorn_ccod <> "-1" then
		 consulta=consulta&" and cast(d.jorn_ccod as varchar)='"&jorn_ccod&"'"
		 end if
         consulta=consulta & "  "
		 if sede_ccod <> "" and sede_ccod <> "-1" then
         	consulta=consulta & " and cast(h.sede_ccod as varchar)= '"&sede_ccod&"'"
		 end if
         consulta=consulta & "  " 
		 consulta=consulta & " and c.eepo_ccod not in (1) "&vbCrlf &_
		 " and b.epos_ccod = 2 " 
		 if usuario <> "9251062" and usuario <> "12889224" then
		  consulta = consulta & " And not exists(select 1 from alumnos alu where alu.post_ncorr=c.post_ncorr and alu.ofer_ncorr=c.ofer_ncorr and alu.emat_ccod in (1,4,8))"
		 end if 


end if

if estado_ccod="9" then

consulta=" select distinct " & vbCrLf &_
		 "        isnull((select top 1 'Matriculado(a) en ' + sede_tdesc + ' - ' + carr_tdesc + ' ' + jorn_tdesc " & vbCrLf &_
		 "		  from alumnos aaa, ofertas_academicas bbb, sedes ccc, jornadas ddd, especialidades eee, carreras fff " & vbCrLf &_
		 "		  where aaa.pers_ncorr=a.pers_ncorr and aaa.emat_ccod in (1,4,8) " & vbCrLf &_
		 "        and aaa.ofer_ncorr=bbb.ofer_ncorr and bbb.peri_ccod = b.peri_ccod " & vbCrLf &_
		 "        and bbb.sede_ccod= ccc.sede_ccod  and bbb.jorn_ccod=ddd.jorn_ccod  " & vbCrLf &_
		 "        and bbb.espe_ccod=eee.espe_ccod and eee.carr_ccod=fff.carr_ccod  " & vbCrLf &_
		 "        ),'No') as matriculado,    " & vbCrLf &_
         " protic.FORMAT_RUT(cast(a.pers_nrut as varchar(10))) as rut,protic.trunc(c.audi_fmodificacion) as fecha," & vbCrLf &_ 
         " a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre, f.carr_tdesc as carrera, h.sede_tdesc as sede,e.espe_tdesc," & vbCrLf &_ 
         " a.pers_tfono as fono,a.pers_tcelular as celular, case a.pers_temail when null then '' else '<A href=""mailto:'+a.pers_temail+'"">'+a.pers_temail+'</a>' end  as email,g.jorn_tdesc as jornada," & vbCrLf &_ 
         " isnull(i.obpo_tobservacion,'--') as observacion,j.eopo_tdesc as obs_postulacion,  " & vbCrLf &_ 
		 " (select pers_tnombre +' ' + pers_tape_paterno from postulantes_por_agente aa, agentes_postulacion bb, personas cc " & vbCrLf &_ 
         "    where aa.post_ncorr=b.post_ncorr and aa.sede_ccod=d.sede_ccod and aa.sede_ccod=bb.sede_ccod and aa.id=bb.id " & vbCrLf &_ 
  		 "    and bb.pers_ncorr=cc.pers_ncorr) as agente " & vbCrLf &_ 
		 " from  " & vbCrLf &_ 
         " personas_postulante a join postulantes b " & vbCrLf &_ 
		 "	on a.pers_ncorr = b.pers_ncorr" & vbCrLf &_ 
		 " join detalle_postulantes c " & vbCrLf &_ 
		 "	on b.post_ncorr = c.post_ncorr " & vbCrLf &_ 
         " join ofertas_academicas d "& vbCrLf &_ 
		 "  on c.ofer_ncorr = d.ofer_ncorr "& vbCrLf &_ 
		 " join especialidades e" & vbCrLf &_ 
		 "	on d.espe_ccod = e.espe_ccod "& vbCrLf &_ 
		 " join carreras f"& vbCrLf &_ 
		 "	on e.carr_ccod = f.carr_ccod "& vbCrLf &_ 
		 " join jornadas g " & vbCrLf &_ 
		 " 	on d.jorn_ccod = g.jorn_ccod "& vbCrLf &_ 
         " join sedes h " & vbCrLf &_ 
		 " on d.sede_ccod = h.sede_ccod "& vbCrLf &_ 
		 " left outer join observaciones_postulacion i " & vbCrLf &_ 
		 " on c.post_ncorr = i.post_ncorr and c.ofer_ncorr=i.ofer_ncorr "& vbCrLf &_ 
          " left outer join estado_observaciones_postulacion j " & vbCrLf &_ 
		 " on isnull(i.eopo_ccod,1) = j.eopo_ccod "& vbCrLf &_ 
		 " where  cast(b.peri_ccod as varchar)='"&v_peri_ccod&"'" & vbCrLf &_ 
		 " and d.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where pers_ncorr='"&pers_ncorr_encargado&"')" 
		 if carr_ccod <> "" and carr_ccod <> "-1" then
         	consulta= consulta & " and cast(f.carr_ccod as varchar)= '"&carr_ccod&"'" 
		 end if
		 if inicio <> "" and termino <> "" then
			consulta = consulta &  " AND convert(datetime,convert(varchar,c.audi_fmodificacion,103),103) between convert(datetime,'" & inicio & "',103) and convert(datetime,'" & termino & "',103)"& vbCrLf
		 elseif inicio <> "" and termino = "" then	
		 	consulta = consulta &  " AND convert(datetime,convert(varchar,c.audi_fmodificacion,103),103) >= convert(datetime,'" & inicio & "',103) "& vbCrLf
		 elseif inicio = "" and termino <> "" then	
		 	consulta = consulta &  " AND convert(datetime,convert(varchar,c.audi_fmodificacion,103),103) <= convert(datetime,'" & termino & "',103) "& vbCrLf	
		 end if 
         consulta= consulta& "  "
		 if jorn_ccod <> "" and jorn_ccod <> "-1" then
		 consulta=consulta&" and cast(d.jorn_ccod as varchar)='"&jorn_ccod&"'"
		 end if
         consulta=consulta & " "
		 if sede_ccod <> "" and sede_ccod <> "-1" then
         	consulta=consulta & " and cast(h.sede_ccod as varchar)= '"&sede_ccod&"'"
		 end if
         consulta=consulta & " " 
		 consulta=consulta & " and isnull(c.eepo_ccod,1) in (1,7) "&vbCrlf &_
         " and b.epos_ccod in (1,2) " 
end if

if estado_alumno="1" then
   consulta=consulta&" and b.post_bnuevo='N'"
elseif estado_alumno="2" then
   consulta=consulta&" and b.post_bnuevo='S'"   
end if
'response.Write("<pre>"&consulta&"</pre>")
lista.inicializar conexion 
lista.consultar consulta

%>
<html>
<head>
<title> Listado Personas </title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="75%" border="1">
<tr>
	<td align="center" width="100%" colspan="16"><font size="+2">Listado de Personas que estan en el estado <%=estado%></font>
	</td>
</tr>
<tr>
	<td align="center" width="100%" colspan="16"><font size="+2">&nbsp;</font>
	</td>
</tr>
<tr>
	<td align="left" width="100%" colspan="16"><font size="+1"><strong>Periodo   : </strong> <%=peri_tdesc%></font>
	</td>
</tr>
<tr>
	<td align="center" width="100%" colspan="16"><font size="+2">&nbsp;</font>
	</td>
</tr>
<tr> 
    <td width="2%" bgcolor="#FFFFCC"><div align="center"><strong>N°</strong></div></td>
	<td width="10%"  bgcolor="#FFFFCC"><div align="center"><strong>Matriculado</strong></div></td>
	<td width="5%"  bgcolor="#FFFFCC"><div align="center"><strong>Sede</strong></div></td>
    <td width="15%"  bgcolor="#FFFFCC"><div align="center"><strong>Carrera</strong></div></td>
	<td width="15%"  bgcolor="#FFFFCC"><div align="center"><strong>Especialidad</strong></div></td>
    <td width="5%"  bgcolor="#FFFFCC"><div align="center"><strong>Jornada</strong></div></td>
    <td width="5%"  bgcolor="#FFFFCC"><div align="center"><strong>Rut</strong></div></td>
    <td width="25%"  bgcolor="#FFFFCC"><div align="center"><strong>Nombre</strong></div></td>
    <td width="5%"  bgcolor="#FFFFCC"><div align="center"><strong>Fono</strong></div></td>
	<td width="5%"  bgcolor="#FFFFCC"><div align="center"><strong>Celular</strong></div></td>
	<td width="10%"  bgcolor="#FFFFCC"><div align="center"><strong>Email</strong></div></td>
	<td width="5%"  bgcolor="#FFFFCC"><div align="center"><strong>Fecha</strong></div></td>
	<%if estado_ccod="4" then%>
	<td width="5%"  bgcolor="#FFFFCC"><div align="center"><strong>Estado</strong></div></td>
	<%end if%>
	<%if estado_ccod="7" then%>
	<td width="8%"  bgcolor="#FFFFCC"><div align="center"><strong>Estado Examen</strong></div></td>
	<%end if%>
	<%if estado_ccod="9" or estado_ccod="6" or estado_ccod="7" then%>
	<td width="10%"  bgcolor="#FFFFCC"><div align="center"><strong>Estado Postulación</strong></div></td>
	<td width="10%"  bgcolor="#FFFFCC"><div align="center"><strong>Observación</strong></div></td>
	<%end if%>
	<td width="10%"  bgcolor="#FFFFCC"><div align="center"><strong>AGENTE</strong></div></td>
  </tr>
  <% fila = 1  
     suma_rechasos = 0
    while lista.Siguiente %>
  <tr> 
   <td><div align="left"><%=fila%></div></td>
   <td><div align="center"><%=lista.ObtenerValor("matriculado")%></div></td>
   <td><div align="left"><%=lista.ObtenerValor("sede")%></div></td>
    <td><div align="left"><%=lista.ObtenerValor("carrera")%></div></td>
	<td><div align="left"><%=lista.ObtenerValor("espe_tdesc")%></div></td>
    <td><div align="left"><%=lista.ObtenerValor("jornada")%></div></td>
    <td><div align="left"><%=lista.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=lista.ObtenerValor("nombre")%></div></td>
    <td><div align="left"><%=lista.ObtenerValor("fono")%></div></td>
	<td><div align="left"><%=lista.ObtenerValor("celular")%></div></td>
	<td><div align="left"><%=lista.ObtenerValor("email")%></div></td>
	<td><div align="left"><%=lista.ObtenerValor("fecha")%></div></td>
	<%if estado_ccod="4" then%>
	<td><div align="left"><%=lista.ObtenerValor("estado")%></div></td>
	<%end if%>
	<%if estado_ccod="7" then%>
	<td><div align="left"><%=lista.ObtenerValor("estado_examen")%></div></td>
	<%end if%>
	<%if estado_ccod="9" or estado_ccod="6" or estado_ccod="7" then
			if lista.ObtenerValor("obs_postulacion") <> "En Espera" then
				suma_rechasos = suma_rechasos + 1
			end if	 
	%>
	<td><div align="left"><%=lista.ObtenerValor("obs_postulacion")%></div></td>
	<td><div align="left"><%=lista.ObtenerValor("observacion")%></div></td>
	<%end if%>
	<td><div align="left"><%=lista.ObtenerValor("agente")%></div></td>
  </tr>
  <% fila= fila + 1 
    wend %>
</table>
</body>
</html>