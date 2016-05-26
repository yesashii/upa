<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
saca_ncorr = Request.QueryString("saca_ncorr")
pers_ncorr = Request.QueryString("pers_ncorr")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Documentos Entregados a Títulos y Grados"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_salida = new CFormulario
f_salida.Carga_Parametros "expediente_titulacion.xml", "salida"
f_salida.Inicializar conexion

SQL = " select b.pers_ncorr,a.saca_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_nrut, b.pers_xdv,  "& vbCrLf &_
      " b.pers_tnombre + ' ' + b.pers_tape_paterno + ' ' + b.pers_tape_materno as alumno, "& vbCrLf &_
	  " a.saca_tdesc as salida, c.tsca_ccod,case c.tsca_ccod when 1 then '<font color=#073299><strong>' "& vbCrLf &_ 
      "            when 2 then '<font color=#004000><strong>' "& vbCrLf &_ 
  	  " 		   when 3 then '<font color=#b76d05><strong>' "& vbCrLf &_ 
	  "			   when 4 then '<font color=#714e9c><strong>' "& vbCrLf &_ 
	  " 		   when 5 then '<font color=#ab2b05><strong>' "& vbCrLf &_ 
	  "  		   when 6 then '<font color=#0078c0><strong>' end + c.tsca_tdesc + '</strong></font>' as tipo_salida, d.carr_ccod, d.carr_tdesc, "& vbCrLf &_
      "    (select top 1 sede_ccod from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod order by t2.peri_ccod desc) as sede_ccod, "& vbCrLf &_
      "    (select top 1 sede_tdesc from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            INNER JOIN sedes t4 "& vbCrLf &_
      "            ON t2.sede_ccod = t4.sede_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod order by t2.peri_ccod desc) as sede_tdesc, "& vbCrLf &_
      "    (select top 1 jorn_tdesc from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            INNER JOIN jornadas t4 "& vbCrLf &_
      "            ON t2.jorn_ccod = t4.jorn_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod order by t2.peri_ccod desc) as jorn_tdesc, "& vbCrLf &_
      "    (select top 1 peri_ccod from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (4,8) "& vbCrLf &_
      "            order by t2.peri_ccod desc) as peri_ccod, "& vbCrLf &_
      "    (select top 1 peri_tdesc from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod=t3.espe_ccod "& vbCrLf &_
      "            INNER JOIN periodos_academicos t4 "& vbCrLf &_
      "            ON t2.peri_ccod = t4.peri_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (4,8) "& vbCrLf &_
      "            order by t2.peri_ccod desc) as peri_tdesc, "& vbCrLf &_
      "    (select case count(*) when 0 then 'N' else 'S' end  from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod=t3.espe_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (4)) as egresado, "& vbCrLf &_
      "    (select case count(*) when 0 then 'N' else 'S' end  from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (8)) as titulado, "& vbCrLf &_
      "    (select top 1 t1.plan_ccod  from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (4) order by peri_ccod desc ) as plan_ccod, "& vbCrLf &_
      " asca_ncorr, protic.trunc(asca_fsalida) as asca_fsalida, asca_nfolio, asca_nregistro, replace(cast(asca_nnota as decimal(2,1)),',','.') as asca_nnota, ' '  as asca_bingr_manual, "& vbCrLf &_
      "    (select max(peri_ccod) "& vbCrLf &_
      "			from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "			ON t1.pers_ncorr = b.pers_ncorr "& vbCrLf &_
      "			INNER JOIN especialidades t3 "& vbCrLf &_
      "			ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "			WHERE t2.espe_ccod = t3.espe_ccod and t3.carr_ccod = d.carr_ccod and isnull(t1.emat_ccod,0) <> 9) as ultimo_periodo "& vbCrLf &_
      " from salidas_carrera a INNER JOIN personas b "& vbCrLf &_
      " ON cast(b.pers_ncorr as varchar)='"&pers_ncorr&"' and cast(a.saca_ncorr as varchar)='"&saca_ncorr&"' "& vbCrLf &_
      " INNER JOIN tipos_salidas_carrera c "& vbCrLf &_
      " ON a.tsca_ccod=c.tsca_ccod "& vbCrLf &_
      " INNER JOIN  carreras d "& vbCrLf &_
      " ON a.carr_ccod=d.carr_ccod "& vbCrLf &_
      " LEFT OUTER JOIN alumnos_salidas_carrera e "& vbCrLf &_
      " ON a.saca_ncorr = e.saca_ncorr and b.pers_ncorr = e.pers_ncorr" 

f_salida.Consultar SQL
f_salida.Siguiente
plan = f_salida.obtenerValor("plan_ccod")
carrera = f_salida.obtenerValor("carr_ccod")
ultimo_periodo = f_salida.obtenerValor("ultimo_periodo")

q_plan_ccod  = plan
plan_ccod = plan
q_peri_ccod  = ultimo_periodo
q_pers_nrut = conexion.consultaUno("Select pers_nrut from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
q_pers_xdv  = conexion.consultaUno("Select pers_xdv from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
rut = q_pers_nrut

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "expediente_titulacion.xml", "botonera"
'---------------------------------------------------------------------------------------------------

'---------------------------------------------------------------------------------------------------
set f_titulado = new CFormulario
f_titulado.Carga_Parametros "expediente_titulacion.xml", "encabezado_de"
f_titulado.Inicializar conexion

v_sede_ccod = conexion.consultaUno("select top 1 sede_ccod from personas a, alumnos b, ofertas_academicas c where cast(a.pers_nrut as varchar)='"&q_pers_nrut&"' and a.pers_ncorr=b.pers_ncorr and cast(b.plan_Ccod as varchar)='"&q_plan_ccod&"' and b.ofer_ncorr=c.ofer_ncorr order by peri_ccod desc")

SQL = " select f.sede_ccod, a.pers_ncorr, b.plan_ccod, c.espe_ccod, e.peri_ccod, d.carr_tdesc, c.espe_tdesc, e.peri_tdesc, f.sede_tdesc, plan_tdesc as plan_ncorrelativo, protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre " & vbCrLf & _
	  " from personas a, planes_estudio b, especialidades c, carreras d, periodos_academicos e, sedes f " & vbCrLf & _
	  " where b.espe_ccod = c.espe_ccod " & vbCrLf & _
	  "   and c.carr_ccod = d.carr_ccod " & vbCrLf & _
	  "   and cast(f.sede_ccod as varchar)= '" & v_sede_ccod & "' " & vbCrLf & _
	  "   and cast(e.peri_ccod as varchar)= '" & q_peri_ccod & "' " & vbCrLf & _
	  "   and cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "' " & vbCrLf & _
	  "   and cast(b.plan_ccod as varchar)= '" & q_plan_ccod & "'"

f_titulado.Consultar SQL
f_titulado.SiguienteF
v_sede_ccod = f_titulado.obtenerValor("sede_ccod")


'---------------------------------------------------------------------------------------------------
f_botonera.AgregaBotonUrlParam "siguiente", "pers_nrut", q_pers_nrut
f_botonera.AgregaBotonUrlParam "siguiente", "pers_xdv", q_pers_xdv
'---------------------------------------------------------------------------------------------------

'---------------------------------------------------------------------------------------------------
url_leng_0 = "exp_tit_mensajes.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_1 = "exp_tit_datos_personales.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_2 = "exp_tit_doctos_entregados.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_3 = "exp_tit_historico_notas.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_4 = "exp_tit_practica.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_5 = "exp_tit_egreso.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_6 = "exp_tit_salida.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_7 = "exp_tit_titulo.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_8 = "exp_tit_concentracion.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr

'---------------------------------------------------------------------------------------------------
set historico		=		new cformulario
historico.inicializar 		conexion
historico.carga_parametros	"tabla_vacia.xml","tabla"

cons_historico="select a.nive_ccod,ltrim(rtrim(a.asig_ccod)) as asig_ccod,asig.asig_tdesc,a.mall_ccod, " & vbCrLf  & _
                   "	  case cast(cast(b.carg_nnota_final as decimal(2,1))as varchar) when ' .0' then '0.0' else cast(cast(b.carg_nnota_final as decimal(2,1))as varchar) end as carg_nnota_final,  " & vbCrLf  & _
				   "	 b.sitf_ccod,b.peri_ccod, " & vbCrLf  & _
				   "	 isnull( case ('('+ cast(pa.anos_ccod as varchar) + '-' + cast(b.sitf_ccod as varchar)+')') " & vbCrLf  & _
				   "     when ('('+ cast(pa.anos_ccod as varchar) + '-' + ')') then ' ' " & vbCrLf  & _
				   "     when '(-)' then ' '" & vbCrLf  & _
				   "     else ('('+ cast(pa.anos_ccod as varchar) + '-' + case cast(b.sitf_ccod as varchar) when 'A' then 'Apr' when 'R' then 'Repr' when 'C' then 'Conv' when 'SP' then 'S.P' when 'H' then 'Homologado' when 'S' then 'Suf' when 'RS' then 'RS' when 'RI' then 'RI' when 'CR' then 'ECR' end +')') end ,'' ) as anos_ccod  " & vbCrLf  & _
				   "	 from (  " & vbCrLf  & _
				   "	 select ma.nive_ccod, asig_ccod,esp.carr_ccod,ma.mall_ccod  " & vbCrLf  & _
			  	   "	 from especialidades esp, planes_estudio pl, malla_curricular ma  " & vbCrLf  & _
				   "	 where esp.espe_ccod=pl.espe_ccod  " & vbCrLf  & _
				   "	  and pl.plan_ccod=ma.plan_ccod  " & vbCrLf  & _
				   "	  and cast(pl.plan_ccod as varchar)='"&plan&"') a left outer join" & vbCrLf  & _
				   "	  (	  " & vbCrLf  & _
				   "	  select h.asig_ccod,a.sitf_ccod,a.carg_nnota_final,g.peri_ccod " & vbCrLf  & _
				   "		from  " & vbCrLf  & _
				   "			 cargas_academicas a, " & vbCrLf  & _
				   "			 alumnos b, " & vbCrLf  & _
				   "			 personas c, " & vbCrLf  & _
				   "			 ofertas_academicas d " & vbCrLf  & _
				   "			 ,planes_estudio e " & vbCrLf  & _
				   "			 ,especialidades f " & vbCrLf  & _
				   "			 ,secciones g " & vbCrLf  & _
				   "			 ,asignaturas h " & vbCrLf  & _
				   "		where  " & vbCrLf  & _
				   "			  a.matr_ncorr=b.matr_ncorr " & vbCrLf  & _
				   "			  and b.pers_ncorr=c.pers_ncorr " & vbCrLf  & _
				   "			  and b.ofer_ncorr=d.ofer_ncorr " & vbCrLf  & _
				   "			  and b.plan_ccod=e.plan_ccod " & vbCrLf  & _
				   "              and isnull(a.carg_noculto,0) <>1" & vbcrlf &_
				   "			  and e.espe_ccod=f.espe_ccod " & vbCrLf  & _
				   "			  and not exists(select 1 from equivalencias equi where equi.asig_ccod=h.asig_ccod and a.matr_ncorr=equi.matr_ncorr and a.secc_ccod = equi.secc_ccod) " & vbCrLf  & _
				   "			  and a.secc_ccod=g.secc_ccod " & vbCrLf  & _
				   "			  and g.asig_ccod=h.asig_ccod " & vbCrLf  & _
				   "			  and cast(pers_nrut as varchar)='"&rut&"' " & vbCrLf  & _
				   "			  and cast(a.sitf_ccod as varchar) not in ('EE','EQ','NN') " & vbCrLf  & _
				   "		union   " & vbCrLf  & _
				   "		select  " & vbCrLf  & _
				   "			 a.asig_ccod,sitf_ccod,case a.sitf_ccod when 'C' then isnull(a.conv_nnota,null) when 'AC' then a.conv_nnota else isnull(a.conv_nnota,null) end as nota,e.peri_ccod " & vbCrLf  & _
				   "		from  " & vbCrLf  & _
				   "			 convalidaciones a " & vbCrLf  & _
				   "			 , alumnos b " & vbCrLf  & _
				   "			 ,personas c " & vbCrLf  & _
				   "			 , actas_convalidacion d " & vbCrLf  & _
				   "			 , ofertas_academicas e " & vbCrLf  & _
				   "			 , planes_estudio f " & vbCrLf  & _
				   "			 ,especialidades g " & vbCrLf  & _
				   "		where " & vbCrLf  & _
				   "			 a.matr_ncorr=b.matr_ncorr " & vbCrLf  & _
				   "			 and b.pers_ncorr=c.pers_ncorr " & vbCrLf  & _
				   "			 and a.acon_ncorr=d.acon_ncorr " & vbCrLf  & _
				   "			 and b.ofer_ncorr=e.ofer_ncorr " & vbCrLf  & _
				   "			 and b.plan_ccod=f.plan_ccod " & vbCrLf  & _
				   "			 and f.espe_ccod=g.espe_ccod " & vbCrLf  & _
				   "			 and cast(g.carr_ccod as varchar)='"&carrera&"' " & vbCrLf  & _
				   "			 and cast(c.pers_nrut as varchar)='"&rut&"' " & vbCrLf  & _
				   "		union " & vbCrLf  & _
				   "		select " & vbCrLf  & _
				   "			  a.asig_ccod,b.sitf_ccod,b.carg_nnota_final,d.peri_ccod " & vbCrLf  & _
				   "		from " & vbCrLf  & _
				   "			equivalencias a " & vbCrLf  & _
				   "			, cargas_academicas b " & vbCrLf  & _
				   "			, secciones c " & vbCrLf  & _
				   "			, ofertas_academicas d " & vbCrLf  & _
				   "			, planes_estudio e " & vbCrLf  & _
				   "			, especialidades f " & vbCrLf  & _
				   "			, alumnos g " & vbCrLf  & _
				   "			, personas h " & vbCrLf  & _
				   "		where " & vbCrLf  & _
				   "			 a.matr_ncorr=b.matr_ncorr " & vbCrLf  & _
				   "			 and a.secc_ccod=b.secc_ccod " & vbCrLf  & _
				   "			 and b.secc_ccod=c.secc_ccod " & vbCrLf  & _
				   "			 and b.matr_ncorr=g.matr_ncorr " & vbCrLf  & _
				   "			 and d.ofer_ncorr=g.ofer_ncorr " & vbCrLf  & _
				   "			 and e.plan_ccod=g.plan_ccod " & vbCrLf  & _
				   "             and isnull(b.carg_noculto,0) <>1" & vbcrlf &_
				   "			 and e.espe_ccod=f.espe_ccod " & vbCrLf  & _
				   "			 and g.pers_ncorr=h.pers_ncorr " & vbCrLf  & _
				   "			 --and cast(f.carr_ccod as varchar)='"&carrera&"' " & vbCrLf  & _
				   "			 and cast(h.pers_nrut as varchar)='"&rut&"' " & vbCrLf  & _
				   "		union " & vbCrLf  & _
				   "    		 select distinct hd.asig_ccod,carg.sitf_ccod,carg.carg_nnota_final,i.peri_ccod " & vbCrLf  & _
				   "                from personas pers,alumnos al,cargas_academicas carg,situaciones_finales sf,secciones secc,asignaturas asig, homologacion_destino hd, " & vbCrLf  & _
				   "                     homologacion_fuente hf,homologacion h,ofertas_academicas i" & vbCrLf  & _
				   "                where cast(pers.pers_nrut as varchar)='"&rut&"' " & vbCrLf  & _
				   "                and pers.pers_ncorr=al.pers_ncorr" & vbCrLf  & _
				   "                and al.matr_ncorr=carg.matr_ncorr" & vbCrLf  & _
				   "                and carg.sitf_ccod=sf.sitf_ccod" & vbCrLf  & _
				   "                --and cast(sf.sitf_baprueba as varchar)='S'" & vbCrLf  & _
				   "                and cast(carg.sitf_ccod as varchar) <>'EQ'" & vbCrLf  & _
				   "                and secc.secc_ccod=carg.secc_ccod" & vbCrLf  & _
				   "                and asig.asig_ccod=secc.asig_ccod" & vbCrLf  & _
				   "                and isnull(carg.carg_noculto,0) <>1" & vbcrlf &_
				   "                and asig.asig_ccod=hf.asig_ccod" & vbCrLf  & _
				   "                and hd.homo_ccod=h.homo_ccod" & vbCrLf  & _
				   "                and al.ofer_ncorr=i.ofer_ncorr" & vbCrLf  & _
				   "                and hf.homo_ccod=h.homo_ccod" & vbCrLf  & _
				   "			    and cast(secc.carr_ccod as varchar)='"&carrera&"' " & vbCrLf  & _
				   "                and hd.asig_ccod <> hf.asig_ccod" & vbCrLf  & _
				   "                and h.THOM_CCOD = 1 " & vbCrLf  & _
				   "		) b  on  a.asig_ccod = b.asig_ccod " & vbCrLf  & _
				   "		join   asignaturas asig on a.asig_ccod=asig.asig_ccod  " & vbCrLf  & _
				   "	    left outer join periodos_academicos pa on b.peri_ccod=pa.peri_ccod" & vbCrLf  & _
				   "        join carreras ca on ca.carr_ccod=a.carr_ccod " & vbCrLf  & _
				   "        order by a.nive_ccod,a.asig_ccod,b.peri_ccod "

'Evaluamos si ya fueron grabadas las notas
grabado = conexion.consultaUno("select count(*) from HIST_ASIG_EGRESO where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(plan_ccod as varchar)='"&plan_ccod&"' and carr_ccod='"&carrera&"'")
if grabado <> "0" then
 cons_historico = " select NIVE_CCOD,ASIG_CCOD,ASIG_TDESC,MALL_CCOD,CARG_NNOTA_FINAL,SITF_CCOD,PERI_CCOD,ANOS_CCOD "&_
                  " from HIST_ASIG_EGRESO "&_
				  " where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(plan_ccod as varchar)='"&plan_ccod&"' and carr_ccod='"&carrera&"'"&_
				  " order by NIVE_CCOD, ASIG_TDESC "
end if
oportunidades	=	3

historico.consultar	cons_historico
nro_columnas =historico.nroFilas
'response.write("<pre>" & cons_historico & "</pre>")

carr_param = conexion.consultaUno("select carr_ccod from salidas_carrera where cast(saca_ncorr as varchar)='"&saca_ncorr&"'")
permiso_escuela = conexion.consultaUno("select isnull((select isnull(peca_dat_personal,'0') from permisos_evt_carrera where carr_ccod='"&carr_param&"'),'0')")

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

<script language="JavaScript">


var t_datos;
var o_pers_nrut;
var flag;





function dBlur()
{
	flag = 1;
}


function InicioPagina()
{
	t_datos = new CTabla("dp");
	
	flag = 0;
}

</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td align="right" valign="top" bgcolor="#EAEAEA">	  <br>
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
            <td><%pagina.DibujarLenguetasFClaro Array(Array("Mensajes", url_leng_0), Array("Datos Pers.", url_leng_1), Array("Docs Alumno", url_leng_2),Array("Hist. Notas", url_leng_3), Array("Práctica prof.", url_leng_4), Array("Datos Egreso", url_leng_5),Array("Reg. Salida", url_leng_6), Array("Tesis y comisión", url_leng_7), Array("Conc. Notas", url_leng_8)), 4%></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
			   <form name="edicion">
			    <input type="hidden" name="rut" value="<%=rut%>">
				<input type="hidden" name="carrera" value="<%=carrera%>">
				<input type="hidden" name="plan" value="<%=plan%>">
				<input type="hidden" name="saca_ncorr" value="<%=saca_ncorr%>">
				<input type="hidden" name="pers_ncorr" value="<%=pers_ncorr%>">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
                      <td>
                        <table width="98%"  border="0" align="center">
                          <tr> 
                            <td>
							  <div align="center">
                                <%f_titulado.DibujaRegistro%>
                              </div>
							</td>
                          </tr>
                        </table></td>
                  </tr>
				  <tr>
                    <td>
					  <%pagina.DibujarSubtitulo "Histórico de notas del alumno"%>
                      <table width="98%"  border="1" align="center">
                        <tr valign="top">
                           <td width='100%' align="center">
						  	<%
						if plan_ccod <> "" then
							response.Write("<table class='v1' width='98%' border='1' bordercolor='#999999' bgcolor='#adadad' cellspacing='0' cellpadding='0'>")
							response.Write("<tr borderColor=#999999 bgColor=#c4d7ff>")
							response.Write("<TH><FONT color=#333333>Nivel</FONT></TH><TH><FONT color=#333333>Cód. Asignatura</FONT></TH><TH><FONT color=#333333>Asignatura</FONT></TH>")
							for o_ = 1 to oportunidades
								response.Write("<TH><FONT color=#333333>"&o_&"&nbsp;Oport.</FONT></TH>")
							next
							'response.Write("</b>")
							response.Write("</tr>")
							historico.siguiente
							nivel		= historico.obtenervalor("nive_ccod")
							aux			= historico.obtenervalor("asig_ccod")
							asignatura	= historico.obtenervalor("asig_tdesc")
							nota		= historico.obtenervalor("carg_nnota_final")
							sit_final	= historico.obtenervalor("sitf_ccod")
							ano			= historico.obtenervalor("anos_ccod")
							malla		= historico.obtenervalor("mall_ccod")
							cadena		= nota&"&nbsp;"&historico.obtenervalor("anos_ccod")
							'response.Write("1:cadena--> "&cadena)
							contador	=	1
							col			=	1	
							nro			=	3
										for k=0 to historico.nroFilas-1 
											if historico.obtenervalor("asig_ccod") <> "" then
												historico.siguiente
												
												if aux = historico.obtenervalor("asig_ccod") then
													col	=	col + 1
													cadena = cadena & "<td nowrap align='center' class=noclick  onmouseover=resaltar(this); onmouseout=desResaltar(this);>"&historico.obtenervalor("carg_nnota_final")&"&nbsp;"&historico.obtenervalor("anos_ccod")&"</td>"
												   'response.Write("<br> "&cadena)
												else
													response.write("<tr bgColor=#ffffff><td class=noclick  onmouseover=resaltar(this); onmouseout=desResaltar(this);>"&nivel&"</td><td  class=noclick onmouseover=resaltar(this); onmouseout=desResaltar(this);>"&aux&"</td><td  class=noclick onmouseover=resaltar(this); onmouseout=desResaltar(this);>"&asignatura&"</td><td class=noclick onmouseover=resaltar(this) onmouseout=desResaltar(this)>"&cadena&"</td>")
													for i_=1 to oportunidades-col
														response.Write("<td class=noclick onmouseover=resaltar(this); onmouseout=desResaltar(this);>&nbsp;</td>")
													next
													col	=	1
													contador = 2
													'tabla.siguiente
													nivel		= historico.obtenervalor("nive_ccod")
													aux			= historico.obtenervalor("asig_ccod")
													asignatura	= historico.obtenervalor("asig_tdesc")
													nota		= historico.obtenervalor("carg_nnota_final")
													sit_final	= historico.obtenervalor("sitf_ccod")
													ano			= historico.obtenervalor("anos_ccod")
													malla   	= historico.obtenervalor("mall_ccod")
													horas		= historico.obtenervalor("asig_nhoras")
													cadena		= historico.obtenervalor("carg_nnota_final")&"&nbsp;"&historico.obtenervalor("anos_ccod")
													nf			= historico.obtenervalor("nf")
													sf			= historico.obtenervalor("sitf_ccod")
													'response.Write("3:cadena--> "&cadena&" ano "&historico.obtenervalor("anos_ccod"))
												end if
											end if
											if k=historico.nrofilas-1 then
													'historico.anterior
													historico.anterior
													nivel		= historico.obtenervalor("nive_ccod")
													aux			= historico.obtenervalor("asig_ccod")
													asignatura	= historico.obtenervalor("asig_tdesc")
													nota		= historico.obtenervalor("carg_nnota_final")
													sit_final	= historico.obtenervalor("sitf_ccod")
													ano			= historico.obtenervalor("anos_ccod")
													horas		= historico.obtenervalor("asig_nhoras")
													malla  	    = historico.obtenervalor("mall_ccod")
													cadena		= historico.obtenervalor("carg_nnota_final")
													nf			= historico.obtenervalor("nf")
													sf			= historico.obtenervalor("sitf_ccod")
													historico.siguiente
													'response.Write("4:cadena--> "&cadena)
													if aux = historico.obtenervalor("asig_ccod") then
														response.write("<tr bgColor=#FFFFFF><td class=noclick onmouseover=resaltar(this); onmouseout=desResaltar(this);>"&nivel&"</td><td  class=noclick onmouseover=resaltar(this); onmouseout=desResaltar(this);>"&aux&"</td><td  class=noclick onmouseover=resaltar(this); onmouseout=desResaltar(this);>"&asignatura&"</td><td  class=noclick onmouseover=resaltar(this) onmouseout=desResaltar(this)>"&cadena&"&nbsp;"&ano&"</td><td  class=noclick onmouseover=resaltar(this); onmouseout=desResaltar(this);>"&historico.obtenervalor("carg_nnota_final")&"&nbsp;"&historico.obtenervalor("anos_ccod")&"</td>")
														for h_=3 to oportunidades
														historico.siguiente
														response.write("<td  class=noclick onmouseover=resaltar(this); onmouseout=desResaltar(this);>"&historico.obtenervalor("carg_nnota_final")&"&nbsp;"&historico.obtenervalor("anos_ccod")&"</td>")
															'response.Write("<td>&nbsp;</td>")
														next
														response.Write("</tr>")
					
													else
														historico.siguiente
														response.write("<tr bgColor=#FFFFFF><td  class=noclick onmouseover=resaltar(this); onmouseout=desResaltar(this);>"&historico.obtenervalor("nive_ccod")&"</td><td  class=noclick onmouseover=resaltar(this); onmouseout=desResaltar(this);>"&historico.obtenervalor("asig_ccod")&"</td><td  class=noclick onmouseover=resaltar(this) onmouseout=desResaltar(this) >"&historico.obtenervalor("asig_tdesc")&"</td><td  class=noclick onmouseover=resaltar(this); onmouseout=desResaltar(this);>"&historico.obtenervalor("carg_nnota_final")&"&nbsp;"&historico.obtenervalor("anos_ccod")&"</td>")
														for h_=2 to oportunidades
															response.Write("<td  class=noclick onmouseover=resaltar(this); onmouseout=desResaltar(this);>&nbsp;</td>")
														next
														response.Write("</tr>")
													end if
											end if
										response.Write("</tr>")
										
    								next
							response.Write("</table>")
						else %>
                              <table class="v1" border="1" borderColor="#999999" bgColor="#adadad" cellspacing="0" cellspading="0" width="98%">
                              <tr align="center" bgColor="#c4d7ff">
                                <TH><FONT color=#333333>Nivel</FONT></TH>
                                <TH><FONT color=#333333>C&oacute;digo Asignatura</FONT></TH>
                                <TH><FONT color=#333333>Asignatura</FONT></TH>
                                <TH><FONT color=#333333>1 oportunidad</FONT></TH>
                                <TH><FONT color=#333333>2 oportunidad</FONT></TH>
                                <TH><FONT color=#333333>3 oportunidad</FONT></TH>
                              </tr>
                              <tr bgcolor="#FFFFFF">
                                <td colspan="6" align="center" class=noclick onmouseover=resaltar(this) onmouseout=desResaltar(this)>No hay datos asociados a los parametros de b&uacute;squeda.</td>
                              </tr>
                            </table>
                            <%
						end if
						%>
							
							
						  </td>
                        </tr>
                      </table></td>
                  </tr>
				  
				  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <% if permiso_escuela = "0" then%>
				  <tr>
                    <td align="center"><font color="#8A0808">LA  ESCUELA NO POSEE PERMISOS DE INGRESO O EDICIÓN DE DATOS</font></td>
                  </tr>
				  <%end if%>
				  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <%If grabado = "0" then%>
				  <tr>
                    <td>Al asociar histórico de notas, se realiará una copia actual de las notas para ser consideradas en el EVT.</td>
                  </tr>
				  <%End if%>
	           </table>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="23%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%if grabado = "0" then
				                                if permiso_escuela = "0" then
				                                   f_botonera.AgregaBotonParam "guardar_notas" , "deshabilitado" , "true"
											    end if
				                                f_botonera.DibujaBoton "guardar_notas"
											end if%></div></td>
                  <td><div align="center"><%f_botonera.DibujaBoton "cerrar"%></div></td>
                </tr>
              </table>
            </div></td>
            <td width="77%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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

