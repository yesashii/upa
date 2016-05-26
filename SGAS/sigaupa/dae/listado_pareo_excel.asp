<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=rerporte_pareo.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 4500000

'----------------------------------------------------------------------------------
anos_ccod = request.Form("busqueda[0][anos_ccod]")
'response.Write(anos_ccod)
'response.End()
'---------------------------------------------------------------------------------------------------

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

'-----------------------------------------------------------------------------------------------
set f_listado = new CFormulario
f_listado.Carga_Parametros "consulta.xml", "consulta" 'carga el xml
f_listado.Inicializar conexion 'inicializo conexion

consulta="  select distinct f.carr_ccod,a.pers_nrut as rut_del_postulante, a.pers_xdv as digito_verificador_del_rut, "& vbCrLf &_
		 " a.pers_tape_paterno  as Apellido_paterno_del_postulante, "& vbCrLf &_
		 " a.pers_tape_materno  as Apellido_materno_del_postulante, "& vbCrLf &_
		 " a.pers_tnombre as nombre_del_postulante, "& vbCrLf &_
		 " '1' as tipo_de_institucion,'007' as codigo_de_institucion, "& vbCrLf &_
		 " (select top 1 codigo_sede from carreras_dae tt where tt.carrera_sistema=f.carr_ccod and tt.sede_sistema=c.sede_ccod and tt.codigo_jornada=c.jorn_ccod) as codigo_sede, "& vbCrLf &_
		 " (select top 1 codigo_carrera from carreras_dae tt where tt.carrera_sistema=f.carr_ccod and tt.sede_sistema=c.sede_ccod and tt.codigo_jornada=c.jorn_ccod) as codigo_carrera, "& vbCrLf &_
		 " protic.ano_ingreso_carrera (a.pers_ncorr,e.carr_ccod) as ano_ingreso, "& vbCrLf &_ 
		 " (select top 1 duracion from carreras_dae tt where tt.carrera_sistema=f.carr_ccod and tt.sede_sistema=c.sede_ccod and tt.codigo_jornada=c.jorn_ccod) as duracion_carrera, "& vbCrLf &_
		 " g.jorn_ccod as jornada ,ARA.ARAN_MMATRICULA as monto_matricula,ARA.ARAN_MCOLEGIATURA as  monto_arancel, "& vbCrLf &_
		 " (select emat_tdesc from estados_matriculas emat  "& vbCrLf &_
		 "    where emat.emat_ccod in (select top 1 emat_ccod from alumnos a1 (nolock), ofertas_academicas o1,periodos_academicos z1 where a1.pers_ncorr=d.pers_ncorr and a1.ofer_ncorr=o1.ofer_ncorr and o1.espe_ccod = c.espe_ccod and a1.emat_ccod <> 9 and o1.peri_ccod=z1.peri_ccod and z1.anos_ccod=pea.anos_ccod order by o1.peri_ccod desc, convert(datetime,a1.audi_fmodificacion) desc)) "& vbCrLf &_
		 " as estado_academico, "& vbCrLf &_
		 " (select count(*) from alumnos aaa (nolock), ofertas_academicas bbb, periodos_academicos ccc,cargas_academicas ddd (nolock),especialidades fff "& vbCrLf &_
		 "  where aaa.ofer_ncorr=bbb.ofer_ncorr and bbb.peri_Ccod=ccc.peri_ccod "& vbCrLf &_
		 "  and ccc.anos_ccod=pea.anos_ccod and aaa.pers_ncorr=d.pers_ncorr  and ccc.plec_ccod=1 "& vbCrLf &_
		 "  and aaa.matr_ncorr=ddd.matr_ncorr and bbb.espe_ccod=fff.espe_ccod and fff.carr_ccod=e.carr_ccod ) as nro_asignaturas, "& vbCrLf &_
		 " (select count(*) from alumnos aaa (nolock), ofertas_academicas bbb, periodos_academicos ccc,cargas_academicas ddd (nolock),situaciones_finales eee,especialidades fff "& vbCrLf &_
		 "  where aaa.ofer_ncorr=bbb.ofer_ncorr and bbb.peri_Ccod=ccc.peri_ccod "& vbCrLf &_
		 "  and ccc.anos_ccod=pea.anos_ccod and aaa.pers_ncorr=d.pers_ncorr "& vbCrLf &_
		 "  and aaa.matr_ncorr=ddd.matr_ncorr and ddd.sitf_ccod=eee.sitf_ccod and ccc.plec_ccod=1 "& vbCrLf &_
		 "  and sitf_baprueba = 'S' and bbb.espe_ccod=fff.espe_ccod and fff.carr_ccod=e.carr_ccod ) as nro_asignaturas_aprobadas, "& vbCrLf &_
		 " (select count(*) from alumnos aaa (nolock), ofertas_academicas bbb, periodos_academicos ccc,cargas_academicas ddd (nolock),situaciones_finales eee,especialidades fff "& vbCrLf &_
		 "  where aaa.ofer_ncorr=bbb.ofer_ncorr and bbb.peri_ccod=ccc.peri_ccod "& vbCrLf &_
		 "  and ccc.anos_ccod=pea.anos_ccod and aaa.pers_ncorr=d.pers_ncorr "& vbCrLf &_
		 "  and aaa.matr_ncorr=ddd.matr_ncorr and ddd.sitf_ccod=eee.sitf_ccod and ccc.plec_ccod=1 "& vbCrLf &_
		 "  and sitf_baprueba = 'N' and bbb.espe_ccod=fff.espe_ccod and fff.carr_ccod=e.carr_ccod ) as nro_asignaturas_reprobadas, "& vbCrLf &_
		 "  (select cast(avg(ddd.carg_nnota_final) as decimal(3,2)) from alumnos aaa (nolock), ofertas_academicas bbb, periodos_academicos ccc,cargas_academicas ddd (nolock),situaciones_finales eee,especialidades fff "& vbCrLf &_
		 "  where aaa.ofer_ncorr=bbb.ofer_ncorr and bbb.peri_Ccod=ccc.peri_ccod "& vbCrLf &_
		 "  and ccc.anos_ccod=pea.anos_ccod and aaa.pers_ncorr=d.pers_ncorr "& vbCrLf &_
		 "  and aaa.matr_ncorr=ddd.matr_ncorr and ddd.sitf_ccod=eee.sitf_ccod and bbb.espe_ccod=fff.espe_ccod and fff.carr_ccod=e.carr_ccod "& vbCrLf &_
		 "  and isnull(ddd.sitf_ccod,'T')<>'T' and isnull(ddd.carg_nnota_final,0)<>0  and  plec_ccod=1) as promedio_notas, "& vbCrLf &_
		 "  protic.es_moroso(a.pers_ncorr,getDate()) as es_moroso "& vbCrLf &_
		 ",(select sum(protic.total_recepcionar_cuota(bb.tcom_ccod, bb.inst_ccod, bb.comp_ndocto, bb.dcom_ncompromiso)) as saldo"& vbCrLf &_
		"from "& vbCrLf &_
		"compromisos aa  (nolock)"& vbCrLf &_
		"join detalle_compromisos bb  (nolock)"& vbCrLf &_
		"on aa.tcom_ccod = bb.tcom_ccod  "& vbCrLf &_  
		"and aa.inst_ccod = bb.inst_ccod    "& vbCrLf &_
		"and aa.comp_ndocto = bb.comp_ndocto "& vbCrLf &_
		"left outer join detalle_ingresos cc  (nolock)"& vbCrLf &_
		"on protic.documento_asociado_cuota(bb.tcom_ccod, bb.inst_ccod, bb.comp_ndocto, bb.dcom_ncompromiso, 'ting_ccod') = cc.ting_ccod   "& vbCrLf &_
		"and protic.documento_asociado_cuota(bb.tcom_ccod, bb.inst_ccod, bb.comp_ndocto, bb.dcom_ncompromiso, 'ding_ndocto') = cc.ding_ndocto  "& vbCrLf &_
		"and protic.documento_asociado_cuota(bb.tcom_ccod, bb.inst_ccod, bb.comp_ndocto, bb.dcom_ncompromiso, 'ingr_ncorr') = cc.ingr_ncorr"& vbCrLf &_    
		"left join estados_detalle_ingresos dd   "& vbCrLf &_
		"on cc.edin_ccod = dd.edin_ccod "& vbCrLf &_
		"left outer join rango_factor_interes hh   "& vbCrLf &_
		"on datediff(day,bb.dcom_fcompromiso, getdate()) between rafi_ndias_minimo and rafi_ndias_maximo "& vbCrLf &_   
		"and floor(bb.dcom_mcompromiso/protic.valor_uf()) between rafi_mufes_min and rafi_mufes_max   "& vbCrLf &_
		"left outer join factor_interes ff   "& vbCrLf &_
		"on ff.rafi_ccod=hh.rafi_ccod   "& vbCrLf &_
		"and ff.anos_ccod=datepart(year, getdate())  "& vbCrLf &_ 
		"and ff.efin_ccod=1 "& vbCrLf &_
		"where protic.total_recepcionar_cuota(bb.tcom_ccod, bb.inst_ccod, bb.comp_ndocto, bb.dcom_ncompromiso) > 0 "& vbCrLf &_ 
		"and ( (cc.ting_ccod is null) or"& vbCrLf &_  
		"(cc.ting_ccod = 4 and dd.edin_ccod not in (6) ) or "& vbCrLf &_ 
		"(cc.ting_ccod = 5 and dd.edin_ccod not in (6) ) or  "& vbCrLf &_
		"(cc.ting_ccod in (2, 50)) or  "& vbCrLf &_
		"(cc.ting_ccod in (3,38) and dd.edin_ccod not in (6, 12, 51)) or  "& vbCrLf &_
		"(cc.ting_ccod = 52 and dd.edin_ccod not in (6) ) or "& vbCrLf &_
		"(cc.ting_ccod = 87 and dd.edin_ccod not in (6) ) or "& vbCrLf &_
		"(cc.ting_ccod = 88 and dd.edin_ccod not in (6) ) "& vbCrLf &_
		")  "& vbCrLf &_
		"and aa.ecom_ccod = '1'  "& vbCrLf &_
		"and bb.ecom_ccod = '1'  "& vbCrLf &_
		"and aa.pers_ncorr  = a.pers_ncorr"& vbCrLf &_
		"and datediff(day,bb.dcom_fcompromiso, getdate())>1 )as monto_morosidad,"& vbCrLf &_
		"(select case when sum(case when datediff(day,bb.dcom_fcompromiso, getdate())>5 then datediff(day,bb.dcom_fcompromiso, getdate()) else 0 end)>=90 then 'Si' else 'No' end as dias_mora"& vbCrLf &_
		"from "& vbCrLf &_
		"compromisos aa (nolock)"& vbCrLf &_ 
		"join detalle_compromisos bb  (nolock)"& vbCrLf &_
		"on aa.tcom_ccod = bb.tcom_ccod "& vbCrLf &_   
		"and aa.inst_ccod = bb.inst_ccod  "& vbCrLf &_  
		"and aa.comp_ndocto = bb.comp_ndocto "& vbCrLf &_
		"left outer join detalle_ingresos cc  (nolock)"& vbCrLf &_
		"on protic.documento_asociado_cuota(bb.tcom_ccod, bb.inst_ccod, bb.comp_ndocto, bb.dcom_ncompromiso, 'ting_ccod') = cc.ting_ccod "& vbCrLf &_  
		"and protic.documento_asociado_cuota(bb.tcom_ccod, bb.inst_ccod, bb.comp_ndocto, bb.dcom_ncompromiso, 'ding_ndocto') = cc.ding_ndocto "& vbCrLf &_ 
		"and protic.documento_asociado_cuota(bb.tcom_ccod, bb.inst_ccod, bb.comp_ndocto, bb.dcom_ncompromiso, 'ingr_ncorr') = cc.ingr_ncorr    "& vbCrLf &_
		"left join estados_detalle_ingresos dd "& vbCrLf &_  
		"on cc.edin_ccod = dd.edin_ccod "& vbCrLf &_
		"left outer join rango_factor_interes hh   "& vbCrLf &_
		"on datediff(day,bb.dcom_fcompromiso, getdate()) between rafi_ndias_minimo and rafi_ndias_maximo"& vbCrLf &_    
		"and floor(bb.dcom_mcompromiso/protic.valor_uf()) between rafi_mufes_min and rafi_mufes_max  "& vbCrLf &_ 
		"left outer join factor_interes ff  "& vbCrLf &_ 
		"on ff.rafi_ccod=hh.rafi_ccod   "& vbCrLf &_
		"and ff.anos_ccod=datepart(year, getdate())   "& vbCrLf &_
		"and ff.efin_ccod=1 "& vbCrLf &_
		"where protic.total_recepcionar_cuota(bb.tcom_ccod, bb.inst_ccod, bb.comp_ndocto, bb.dcom_ncompromiso) > 0  "& vbCrLf &_
		"and ( (cc.ting_ccod is null) or  "& vbCrLf &_
		"(cc.ting_ccod = 4 and dd.edin_ccod not in (6) ) or  "& vbCrLf &_
		"(cc.ting_ccod = 5 and dd.edin_ccod not in (6) ) or  "& vbCrLf &_
		"(cc.ting_ccod in (2, 50)) or  "& vbCrLf &_
		"(cc.ting_ccod in (3,38) and dd.edin_ccod not in (6, 12, 51)) or  "& vbCrLf &_
		"(cc.ting_ccod = 52 and dd.edin_ccod not in (6) ) or "& vbCrLf &_
		"(cc.ting_ccod = 87 and dd.edin_ccod not in (6) ) or "& vbCrLf &_
		"(cc.ting_ccod = 88 and dd.edin_ccod not in (6) ) "& vbCrLf &_
		")  "& vbCrLf &_
		"and aa.ecom_ccod = '1'  "& vbCrLf &_
		"and bb.ecom_ccod = '1'  "& vbCrLf &_
		"and aa.pers_ncorr  = a.pers_ncorr"& vbCrLf &_
		"and datediff(day,bb.dcom_fcompromiso, getdate())>1 )'moroso_90'"& vbCrLf &_
		 "   ,(select case count(*) when 0 then 'N' else 'S' end  from sdescuentos aa,stipos_descuentos bbb "& vbCrLf &_
         "  where post_ncorr in (select post_ncorr from postulantes bb  (nolock) where bb.pers_ncorr=a.pers_ncorr) "& vbCrLf &_
         "   and  esde_ccod=1 "& vbCrLf &_
         "   and aa.stde_ccod=bbb.stde_ccod"& vbCrLf &_
         "   and tben_ccod=3	)tiene_descuento,"& vbCrLf &_
         "   protic.tiene_credito(a.pers_ncorr,"&anos_ccod&")tiene_beca, "& vbCrLf &_
		 "   protic.trunc(d.alum_fmatricula) as alum_fmatricula,case when a.sexo_ccod=1 then 'M' else 'F' end as sexo_tdesc,protic.trunc(a.pers_fnacimiento) as pers_fnacimiento, "& vbCrLf &_
		 "   protic.obtener_direccion_letra(a.pers_ncorr,1,'CNPB') as direccion, "& vbCrLf &_
		 "   protic.obtener_direccion_letra(a.pers_ncorr,1,'C-C') as ciudad, "& vbCrLf &_
		 "   (select regi_tdesc from direcciones_publica tt1 (nolock),ciudades tt2, regiones tt3 "& vbCrLf &_
		 "   where tt1.pers_ncorr=a.pers_ncorr and tt1.tdir_ccod=1 and tt1.ciud_ccod=tt2.ciud_ccod "& vbCrLf &_
		 "   and tt2.regi_ccod=tt3.regi_ccod) as region,pers_tfono,pers_tcelular,pers_temail "& vbCrLf &_
		 "  from personas_postulante a  (nolock) join alumnos d  (nolock) "& vbCrLf &_
		 "        on a.pers_ncorr = d.pers_ncorr  "& vbCrLf &_
		 "    join ofertas_academicas c "& vbCrLf &_
		 "        on c.ofer_ncorr = d.ofer_ncorr   "& vbCrLf &_
		 "    join ARANCELES ARA "& vbCrLf &_
		 "        on ARA.ARAN_NCORR = C.ARAN_NCORR   "& vbCrLf &_
		 "     join periodos_Academicos pea on c.peri_ccod = pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&anos_ccod&"'"& vbCrLf &_
		 "    join postulantes pos  (nolock)"& vbCrLf &_
		 "        on pos.post_ncorr = d.post_ncorr "& vbCrLf &_
		 "   left outer join colegios k "& vbCrLf &_
		 "        on a.cole_ccod = k.cole_ccod   "& vbCrLf &_
		 "    join especialidades e "& vbCrLf &_
		 "        on c.espe_ccod  = e.espe_ccod "& vbCrLf &_
		 "    left outer join planes_estudio pl "& vbCrLf &_
		 "        on d.plan_ccod = pl.plan_ccod "& vbCrLf &_
		 "    join carreras f "& vbCrLf &_
		 "        on e.carr_ccod=f.carr_ccod  "& vbCrLf &_
		 "    join jornadas g "& vbCrLf &_
		 "        on c.jorn_ccod=g.jorn_ccod "& vbCrLf &_
		 "    join sedes h "& vbCrLf &_
		 "        on c.sede_ccod=h.sede_ccod "& vbCrLf &_
		 "    left outer join tipos_colegios m "& vbCrLf &_
		 "        on k.tcol_ccod = m.tcol_ccod "& vbCrLf &_
		 "    join contratos cont (nolock)"& vbCrLf &_
		 "        on d.matr_ncorr = cont.matr_ncorr and d.post_ncorr = cont.post_ncorr "& vbCrLf &_
		 " where cont.econ_ccod = 1 and f.tcar_ccod=1 "& vbCrLf &_
		 " and d.emat_ccod not in (9) "& vbCrLf &_
		 " and exists (select 1 from contratos cont1 (nolock), compromisos comp1 (nolock) where d.post_ncorr=cont1.post_ncorr and d.matr_ncorr=cont1.matr_ncorr and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2) )  "& vbCrLf &_
		 " group by a.pers_ncorr, e.carr_ccod, c.peri_ccod,a.pers_nrut,a.pers_xdv, a.pers_tnombre,a.pers_tape_paterno, f.carr_ccod,g.jorn_ccod, "& vbCrLf &_
		 "         a.pers_tape_materno,d.matr_ncorr, c.espe_ccod,c.sede_ccod,c.jorn_ccod,pers_tfono,pers_tcelular,pers_temail,  "& vbCrLf &_
		 "         pea.anos_ccod, d.pers_ncorr,a.sexo_ccod,ARA.ARAN_MMATRICULA,ARA.ARAN_MCOLEGIATURA,d.alum_fmatricula,a.pers_fnacimiento  "
		 
'response.write("<pre>"&consulta&"</pre>")
'response.End()
f_listado.Consultar consulta 'este hace la pega
'response.write(consulta)

%>


<html>
<head>
<title>Reporte matriculados para pareo</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<script language="JavaScript">
</script>

</head>
<body>
<p>
</p>
<table width="100%" border="1" cellpadding="0" cellspacing="0">
  <tr>
    <td><div align="center"><strong>NUM</strong></div></td>
	<td><div align="center"><strong>RUT DEL POSTULANTE</strong></div></td>
    <td><div align="center"><strong>DIGITO VERIFICADOR</strong></div></td>
	<td><div align="center"><strong>APELLIDO PATERNO</strong></div></td>
	<td><div align="center"><strong>APELLIDO MATERNO</strong></div></td>
	<td><div align="center"><strong>NOMBRE DEL POSTULANTE</strong></div></td>
	<td><div align="center"><strong>TIPO DE INSTITUCIÓN</strong></div></td>
	<td><div align="center"><strong>CÓDIGO DE INSTITUCIÓN</strong></div></td>
	<td><div align="center"><strong>CÓDIGO DE SEDE</strong></div></td>
	<td><div align="center"><strong>CÓDIGO DE CARRERA</strong></div></td>
	<td><div align="center"><strong>AÑO DE INGRESO</strong></div></td>
	<td><div align="center"><strong>DURACIÓN DE CARRERA</strong></div></td>
	<td><div align="center"><strong>JORNADA</strong></div></td>
	<td><div align="center"><strong>MONTO MATRICULA</strong></div></td>
	<td><div align="center"><strong>MONTO ARANCEL</strong></div></td>
	<td><div align="center"><strong>ESTADO ACADÉMICO</strong></div></td>
	<td><div align="center"><strong>N° DE ASIGNATURAS</strong></div></td>
	<td><div align="center"><strong>ASIGNATURAS APROBADAS</strong></div></td>
	<td><div align="center"><strong>ASIGNATURAS REPROBADAS</strong></div></td>
	<td><div align="center"><strong>PROMEDIO NOTAS</strong></div></td>
	<td><div align="center"><strong>ES MOROSO</strong></div></td>
	<td><div align="center"><strong>MAS 90 DIAS MOROSO</strong></div></td>
	<td><div align="center"><strong>MONTO MOROSIDAD</strong></div></td>
	<td><div align="center"><strong>TIENE DESCUENTO</strong></div></td>
	<td><div align="center"><strong>TIENE BECA</strong></div></td>
	<td><div align="center"><strong>FECHA MATRICULA</strong></div></td>
	<td><div align="center"><strong>SEXO</strong></div></td>
	<td><div align="center"><strong>FECHA NACIMIENTO</strong></div></td>
	<td><div align="center"><strong>DIRECCION</strong></div></td>
	<td><div align="center"><strong>CIUDAD</strong></div></td>
	<td><div align="center"><strong>REGION</strong></div></td>
	<td><div align="center"><strong>FONO</strong></div></td>
	<td><div align="center"><strong>CELULAR</strong></div></td>
	<td><div align="center"><strong>EMAIL</strong></div></td>
  </tr>
  <%NUMERO=1%>
  <%while f_listado.Siguiente%> <!-- mientras hay registro hace-->
  <tr>
    <td><%=NUMERO%> </td>
	<td><%=f_listado.ObtenerValor("rut_del_postulante")%></td>
    <td><%=f_listado.ObtenerValor("digito_verificador_del_rut")%></td>
	<td><%=f_listado.ObtenerValor("Apellido_paterno_del_postulante")%></td>
	<td><%=f_listado.ObtenerValor("Apellido_materno_del_postulante")%></td>
	<td><%=f_listado.ObtenerValor("Nombre_del_postulante")%></td>
	<td><%=f_listado.ObtenerValor("tipo_de_institucion")%></td>
	<td>&nbsp;<%=f_listado.ObtenerValor("codigo_de_institucion")%></td>
	<td>&nbsp;<%=f_listado.ObtenerValor("codigo_sede")%></td>
	<td>&nbsp;<%=f_listado.ObtenerValor("codigo_carrera")%></td>
	<td><%=f_listado.ObtenerValor("ano_ingreso")%></td>
	<td><%=f_listado.ObtenerValor("duracion_carrera")%></td>
	<td><%=f_listado.ObtenerValor("jornada")%></td>
	<td><%=f_listado.ObtenerValor("monto_matricula")%></td>
	<td><%=f_listado.ObtenerValor("monto_arancel")%></td>
	<td><%=f_listado.ObtenerValor("estado_academico")%></td>
	<td><%=f_listado.ObtenerValor("nro_asignaturas")%></td>
	<td><%=f_listado.ObtenerValor("nro_asignaturas_aprobadas")%></td>
	<td><%=f_listado.ObtenerValor("nro_asignaturas_reprobadas")%></td>
	<td><%=f_listado.ObtenerValor("promedio_notas")%></td>
	<td><%=f_listado.ObtenerValor("es_moroso")%></td>
	<td><%=f_listado.ObtenerValor("moroso_90")%></td>
	<td><%=f_listado.ObtenerValor("monto_morosidad")%></td>
	<td><%=f_listado.ObtenerValor("tiene_descuento")%></td>
	<td><%=f_listado.ObtenerValor("tiene_beca")%></td>
	<td><%=f_listado.ObtenerValor("alum_fmatricula")%></td>
	<td><%=f_listado.ObtenerValor("sexo_tdesc")%></td>
	<td><%=f_listado.ObtenerValor("pers_fnacimiento")%></td>
	<td><%=f_listado.ObtenerValor("direccion")%></td>
	<td><%=f_listado.ObtenerValor("ciudad")%></td>
	<td><%=f_listado.ObtenerValor("region")%></td>
	<td><%=f_listado.ObtenerValor("pers_tfono")%></td>
	<td><%=f_listado.ObtenerValor("pers_tcelular")%></td>
	<td><%=f_listado.ObtenerValor("pers_temail")%></td>
  </tr>
   <%NUMERO=NUMERO+1%>
  <%wend%>
</table>
</body>
</html>
