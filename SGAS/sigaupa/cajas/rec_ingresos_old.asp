<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
set botonera = new CFormulario
botonera.carga_parametros "paulo.xml", "btn_rec_ingresos"

rut=request.querystring("rut")
dv=request.querystring("dv")
inst=request.QueryString("ins[0][insti]")
set conectar 	= new cconexion
set formulario 	= new cformulario
set formulario1 = new cformulario
set negocio		= new cNegocio
set persona 	= new cformulario
set formu 		= new cformulario
set insti		= new cFormulario
set tabla_na	= new cformulario

conectar.inicializar "desauas"

negocio.inicializa conectar
sede=negocio.obtenerSede
usuario = negocio.obtenerUsuario


cajero_cons = "select caje_ccod from personas a, cajeros b where a.pers_ncorr=b.pers_ncorr and  pers_nrut=" & usuario & " and  sede_ccod=" & sede
cajero = conectar.consultaUno(cajero_cons)


mcaj_ncorr_cons = "select mcaj_ncorr from movimientos_cajas where caje_ccod='" & trim(cajero) & "' " & _
				" and sede_ccod=" & sede & _
				" and eren_ccod=1 " & _
				" and to_char(mcaj_finicio,'dd/mm/yyyy') = to_char(sysdate,'dd/mm/yyyy') "
				
mcaj_ncorr = conectar.consultaUno(mcaj_ncorr_cons)

'MCAJ_NCORR=891430

IF FALSE THEN
'if isnull(mcaj_ncorr) or mcaj_ncorr="" then
	session("mensajeError") = "ERROR:\nNo puede recibir pagos si no tiene una caja abierta hoy"
	response.Redirect("../lanzadera/lanzadera.asp")
'	response.Redirect("../cajas/rec_ingresos.asp")
else

formulario.carga_parametros "paulo.xml", "ingresos"
formulario1.carga_parametros "paulo.xml", "ingresos1"
insti.carga_parametros "paulo.xml", "institucion"
persona.carga_parametros "paulo.xml","persona"
tabla_na.carga_parametros "paulo.xml", "tabla"

persona.inicializar conectar
formulario.inicializar conectar
formulario1.inicializar conectar
insti.inicializar conectar
tabla_na.inicializar conectar

sede_ccod = negocio.obtenersede
institucion="select '' as institucion from dual"

saldo	=	conectar.consultauno("SELECT nvl(SUM(SALDO),0) FROM   " & _
"( " & _
"SELECT a.tcom_ccod, a.inst_ccod, a.comp_ndocto,b.dcom_ncompromiso as ncompromiso, b.dcom_ncompromiso, a.ecom_ccod as ecom_ccod, " & _
"      (b.dcom_mcompromiso - NVL(SUM (decode(c.ting_brebaje, 'S',-c.abon_mabono,c.abon_mabono)),0)) AS dcom_mcompromiso_oculto, " & _
"       nvl(SUM (decode(c.ting_brebaje, 'S',-c.abon_mabono,c.abon_mabono)),0) AS abono, b.dcom_fcompromiso, " & _
"       b.dcom_mcompromiso, a.comp_ndocto AS nro, " & _
"       d.tcom_tdesc AS concepto, d.tcom_tdesc,a.inst_ccod as institucion,b.dcom_mcompromiso as compromiso, " & _
"       (b.dcom_mcompromiso - NVL(SUM (decode(c.ting_brebaje, 'S',-c.abon_mabono,c.abon_mabono)),0)) AS saldo " & _
"  FROM compromisos a, " & _
"       detalle_compromisos b, " & _
"       (select b.tcom_ccod,b.inst_ccod,b.comp_ndocto,b.dcom_ncompromiso,b.abon_mabono, a.ting_ccod, d.ting_brebaje " & _
"        from ingresos a, abonos b, personas p, tipos_ingresos d " & _       
"        where a.ingr_ncorr = b.ingr_ncorr AND a.ting_ccod = d.ting_ccod " & _
"          AND a.eing_ccod = 1 " & _
"          AND b.pers_ncorr = p.pers_ncorr " & _
"          AND p.pers_nrut = '"& rut &"' " & _
"          and b.inst_ccod = '"& inst & "') c, " & _ 
"       tipos_compromisos d, " & _
"      personas e " & _
" WHERE a.tcom_ccod = b.tcom_ccod " & _
"   AND a.inst_ccod = b.inst_ccod " & _
"   AND a.comp_ndocto = b.comp_ndocto " & _
"   AND b.tcom_ccod = c.tcom_ccod (+) " & _
"   AND b.inst_ccod = c.inst_ccod (+) " & _
"   AND b.comp_ndocto = c.comp_ndocto (+) " & _
"   AND b.dcom_ncompromiso = c.dcom_ncompromiso (+) " & _
"   AND b.tcom_ccod = d.tcom_ccod  " & _
"	and B.ecom_ccod not in (2,3) " & _ 
"	and a.ecom_ccod not in (2,3) " & _ 
"   AND a.pers_ncorr = e.pers_ncorr " & _
"   AND e.pers_nrut = '"& rut &"' " & _
"   AND b.dcom_fcompromiso <= to_date('31/12/2002','dd/mm/yyyy') " & _
"   AND a.inst_ccod = '"& inst &"' " & _
 " GROUP BY a.tcom_ccod, " & _
 "         a.inst_ccod, " & _
 "         a.comp_ndocto, " & _
 "         b.dcom_ncompromiso, " & _
 "         b.dcom_fcompromiso, " & _
 "         b.dcom_mcompromiso, " & _
 "         d.tcom_tdesc,a.ecom_ccod " & _
 " ORDER BY b.dcom_fcompromiso asc,nro" & _
"  )") 


desbloqueos=conectar.consultauno("select count(*) from desbloqueos_especiales where pers_nrut='"& rut &"'")

if saldo <= 0 then
	filtro=" and b.dcom_fcompromiso > to_date('31/12/2002','dd/mm/yyyy') "
end if

personas = "select " & _
        "pers_ncorr as c, pers_nrut || '-' || pers_xdv  as rut " & _
		" , pers_tape_paterno || ' ' ||   PERS_TAPE_MATERNO || ' ' || pers_tnombre as nombre  " & _
	   " from personas" & _
	   " where pers_nrut='" & rut & "' " & _
       " and pers_xdv='" & dv & "'  "

'******************************* NUEVO  ***************************** -->
campos="select count(*) from (" & _
"SELECT a.tcom_ccod, a.inst_ccod, a.comp_ndocto, b.dcom_ncompromiso, e.pers_ncorr, " & _
"      (b.dcom_mcompromiso - NVL(SUM (decode(c.ting_brebaje, 'S',-c.abon_mabono,c.abon_mabono)),0)) AS dcom_mcompromiso_oculto, " & _
"       nvl(SUM (decode(c.ting_brebaje, 'S',-c.abon_mabono,c.abon_mabono)),0) AS abono, b.dcom_fcompromiso, " & _
"       b.dcom_mcompromiso, a.comp_ndocto AS nro, " & _
"       d.tcom_tdesc AS concepto, d.tcom_tdesc,a.inst_ccod as institucion, " & _
"       (b.dcom_mcompromiso - NVL(SUM (decode(c.ting_brebaje, 'S',-c.abon_mabono,c.abon_mabono)),0)) AS saldo " & _
"  FROM compromisos a, " & _
"       detalle_compromisos b, " & _
"       (select b.tcom_ccod,b.inst_ccod,b.comp_ndocto,b.dcom_ncompromiso,b.abon_mabono,a.ting_ccod, d.ting_brebaje " & _
"        from ingresos a, abonos b, personas c, tipos_ingresos d " & _       
"        where a.ingr_ncorr = b.ingr_ncorr AND a.ting_ccod = d.ting_ccod " & _
"          AND c.pers_ncorr = b.pers_ncorr and c.pers_nrut = '"& rut & "' " & _ 
"          AND a.eing_ccod = 1 and b.inst_ccod = '"& inst & "') c, " & _ 
"       tipos_compromisos d, " & _
"      personas e " & _
" WHERE a.tcom_ccod = b.tcom_ccod " & _
"   AND a.inst_ccod = b.inst_ccod " & _
"   AND a.comp_ndocto = b.comp_ndocto " & _
"   AND b.tcom_ccod = c.tcom_ccod (+) " & _
"   AND b.inst_ccod = c.inst_ccod (+) " & _
"   AND b.comp_ndocto = c.comp_ndocto (+) " & _
"   AND b.dcom_ncompromiso = c.dcom_ncompromiso (+) " & _
"   AND b.tcom_ccod = d.tcom_ccod  " & _
"   AND a.ecom_ccod not in (2,3)  " & _
"	and B.ecom_ccod not in (2,3,5) " & _ 
"   AND a.pers_ncorr = e.pers_ncorr " & _
"   AND e.pers_nrut = '"& rut &"' " & _
"   AND a.inst_ccod = '"& inst &"' "&filtro&"" & _
" HAVING nvl((b.dcom_mcompromiso - nvl(SUM (decode(c.ting_brebaje, 'S',-c.abon_mabono,c.abon_mabono)),0)),0) > 0 " & _
 " GROUP BY a.tcom_ccod, " & _
 "         a.inst_ccod, " & _
 "         a.comp_ndocto, " & _
 "         b.dcom_ncompromiso, " & _
 "         b.dcom_fcompromiso, " & _
 "         b.dcom_mcompromiso, " & _
 "         e.pers_ncorr, " & _
 "         d.tcom_tdesc " & _
 " ORDER BY b.dcom_fcompromiso asc,a.tcom_ccod,nro) "

nro_campos=cint(conectar.consultaUno(campos))
'******************************* FIN NUEVO  ***************************** -->


tabla="SELECT a.tcom_ccod, a.inst_ccod, a.comp_ndocto, b.dcom_ncompromiso, e.pers_ncorr, " & _
"      (b.dcom_mcompromiso - NVL(SUM (decode(c.ting_brebaje, 'S',-c.abon_mabono,c.abon_mabono)),0)) AS dcom_mcompromiso_oculto, " & _
"       nvl(SUM (decode(c.ting_brebaje, 'S',-c.abon_mabono,c.abon_mabono)),0) AS abono, b.dcom_fcompromiso, " & _
"       b.dcom_mcompromiso, a.comp_ndocto AS nro, " & _
"       d.tcom_tdesc AS concepto, d.tcom_tdesc,a.inst_ccod as institucion, " & _
"       (b.dcom_mcompromiso - NVL(SUM (decode(c.ting_brebaje, 'S',-c.abon_mabono,c.abon_mabono)),0)) AS saldo " & _
"  FROM compromisos a, " & _
"       detalle_compromisos b, " & _
"       (select b.tcom_ccod,b.inst_ccod,b.comp_ndocto,b.dcom_ncompromiso,b.abon_mabono,a.ting_ccod, d.ting_brebaje " & _
"        from ingresos a, abonos b, personas c, tipos_ingresos d " & _       
"        where a.ingr_ncorr = b.ingr_ncorr AND a.ting_ccod = d.ting_ccod " & _
"          AND c.pers_ncorr = b.pers_ncorr and c.pers_nrut = '"& rut & "' " & _ 
"          AND a.eing_ccod = 1 and b.inst_ccod = '"& inst & "') c, " & _ 
"       tipos_compromisos d, " & _
"      personas e " & _
" WHERE a.tcom_ccod = b.tcom_ccod " & _
"   AND a.inst_ccod = b.inst_ccod " & _
"   AND a.comp_ndocto = b.comp_ndocto " & _
"   AND b.tcom_ccod = c.tcom_ccod (+) " & _
"   AND b.inst_ccod = c.inst_ccod (+) " & _
"   AND b.comp_ndocto = c.comp_ndocto (+) " & _
"   AND b.dcom_ncompromiso = c.dcom_ncompromiso (+) " & _
"   AND b.tcom_ccod = d.tcom_ccod  " & _
"   AND a.ecom_ccod not in (2,3)  " & _
"	and B.ecom_ccod not in (2,3,5) " & _ 
"   AND a.pers_ncorr = e.pers_ncorr " & _
"   AND e.pers_nrut = '"& rut &"' " & _
"   AND a.inst_ccod = '"& inst &"' "&filtro&" " & _
" HAVING nvl((b.dcom_mcompromiso - nvl(SUM (decode(c.ting_brebaje, 'S',-c.abon_mabono,c.abon_mabono)),0)),0) > 0 " & _
 " GROUP BY a.tcom_ccod, " & _
 "         a.inst_ccod, " & _
 "         a.comp_ndocto, " & _
 "         b.dcom_ncompromiso, " & _
 "         b.dcom_fcompromiso, " & _
 "         b.dcom_mcompromiso, " & _
 "         e.pers_ncorr, " & _
 "         d.tcom_tdesc " & _
 " ORDER BY b.dcom_fcompromiso asc,a.tcom_ccod,nro"
'response.Write(tabla)

tabla1="SELECT a.tcom_ccod, a.inst_ccod, a.comp_ndocto, b.dcom_ncompromiso, e.pers_ncorr, " & _
"      (b.dcom_mcompromiso - NVL(SUM (decode(c.ting_brebaje, 'S',-c.abon_mabono,c.abon_mabono)),0)) AS dcom_mcompromiso_oculto, " & _
"       nvl(SUM (decode(c.ting_brebaje, 'S',-c.abon_mabono,c.abon_mabono)),0) AS abono, b.dcom_fcompromiso, " & _
"       b.dcom_mcompromiso, a.comp_ndocto AS nro, " & _
"       d.tcom_tdesc AS concepto, d.tcom_tdesc,a.inst_ccod as institucion, " & _
"       (b.dcom_mcompromiso - NVL(SUM (decode(c.ting_brebaje, 'S',-c.abon_mabono,c.abon_mabono)),0)) AS saldo " & _
"  FROM compromisos a, " & _
"       detalle_compromisos b, " & _
"       (select b.tcom_ccod,b.inst_ccod,b.comp_ndocto,b.dcom_ncompromiso,b.abon_mabono,a.ting_ccod, d.ting_brebaje " & _
"        from ingresos a, abonos b, personas c, tipos_ingresos d " & _       
"        where a.ingr_ncorr = b.ingr_ncorr AND a.ting_ccod = d.ting_ccod " & _
"          AND c.pers_ncorr = b.pers_ncorr and c.pers_nrut = '"& rut & "' " & _ 
"          AND a.eing_ccod = 1 and b.inst_ccod = '"& inst & "') c, " & _ 
"       tipos_compromisos d, " & _
"      personas e " & _
" WHERE a.tcom_ccod = b.tcom_ccod " & _
"   AND a.inst_ccod = b.inst_ccod " & _
"   AND a.comp_ndocto = b.comp_ndocto " & _
"   AND b.tcom_ccod = c.tcom_ccod (+) " & _
"   AND b.inst_ccod = c.inst_ccod (+) " & _
"   AND b.comp_ndocto = c.comp_ndocto (+) " & _
"   AND b.dcom_ncompromiso = c.dcom_ncompromiso (+) " & _
"   AND b.tcom_ccod = d.tcom_ccod  " & _
"   AND a.ecom_ccod not in (2,3)  " & _
"	and B.ecom_ccod = 5  " & _ 
"   AND a.pers_ncorr = e.pers_ncorr " & _
"   AND e.pers_nrut = '"& rut &"' " & _
"   AND a.inst_ccod = '"& inst &"' "&filtro&"" & _
" HAVING nvl((b.dcom_mcompromiso - nvl(SUM (decode(c.ting_brebaje, 'S',-c.abon_mabono,c.abon_mabono)),0)),0) > 0 " & _
 " GROUP BY a.tcom_ccod, " & _
 "         a.inst_ccod, " & _
 "         a.comp_ndocto, " & _
 "         b.dcom_ncompromiso, " & _
 "         b.dcom_fcompromiso, " & _
 "         b.dcom_mcompromiso, " & _
 "         e.pers_ncorr, " & _
 "         d.tcom_tdesc " & _
 " ORDER BY b.dcom_fcompromiso asc,nro,a.tcom_ccod"
 

'*************************************** inicio nuevo***********************************
campos2="select count(*) from (SELECT a.tcom_ccod, a.inst_ccod, a.comp_ndocto, b.dcom_ncompromiso, e.pers_ncorr, " & _
"      (b.dcom_mcompromiso - NVL(SUM (decode(c.ting_brebaje, 'S',-c.abon_mabono,c.abon_mabono)),0)) AS dcom_mcompromiso_oculto, " & _
"       nvl(SUM (decode(c.ting_brebaje, 'S',-c.abon_mabono,c.abon_mabono)),0) AS abono, b.dcom_fcompromiso, " & _
"       b.dcom_mcompromiso, a.comp_ndocto AS nro, " & _
"       d.tcom_tdesc AS concepto, d.tcom_tdesc,a.inst_ccod as institucion, " & _
"       (b.dcom_mcompromiso - NVL(SUM (decode(c.ting_brebaje, 'S',-c.abon_mabono,c.abon_mabono)),0)) AS saldo " & _
"  FROM compromisos a, " & _
"       detalle_compromisos b, " & _
"       (select b.tcom_ccod,b.inst_ccod,b.comp_ndocto,b.dcom_ncompromiso,b.abon_mabono, a.ting_ccod, d.ting_brebaje " & _
"        from ingresos a, abonos b, personas c, tipos_ingresos d " & _       
"        where a.ingr_ncorr = b.ingr_ncorr AND a.ting_ccod = d.ting_ccod " & _
"          AND c.pers_ncorr = b.pers_ncorr and c.pers_nrut = '"& rut & "' " & _ 
"          AND a.eing_ccod = 1 and b.inst_ccod = '"& inst & "') c, " & _ 
"       tipos_compromisos d, " & _
"      personas e " & _
" WHERE a.tcom_ccod = b.tcom_ccod " & _
"   AND a.inst_ccod = b.inst_ccod " & _
"   AND a.comp_ndocto = b.comp_ndocto " & _
"   AND b.tcom_ccod = c.tcom_ccod (+) " & _
"   AND b.inst_ccod = c.inst_ccod (+) " & _
"   AND b.comp_ndocto = c.comp_ndocto (+) " & _
"   AND b.dcom_ncompromiso = c.dcom_ncompromiso (+) " & _
"   AND b.tcom_ccod = d.tcom_ccod  " & _
"   AND a.ecom_ccod not in (2,3)  " & _
"	and B.ecom_ccod = 5  " & _ 
"   AND a.pers_ncorr = e.pers_ncorr " & _
"   AND e.pers_nrut = '"& rut &"' " & _
"   AND a.inst_ccod = '"& inst &"' "&filtro&"" & _
" HAVING nvl((b.dcom_mcompromiso - nvl(SUM (decode(c.ting_brebaje, 'S',-c.abon_mabono,c.abon_mabono)),0)),0) > 0 " & _
 " GROUP BY a.tcom_ccod, " & _
 "         a.inst_ccod, " & _
 "         a.comp_ndocto, " & _
 "         b.dcom_ncompromiso, " & _
 "         b.dcom_fcompromiso, " & _
 "         b.dcom_mcompromiso, " & _
 "         e.pers_ncorr, " & _
 "         d.tcom_tdesc " & _
 " ORDER BY b.dcom_fcompromiso,a.tcom_ccod,nro)"
 

nro_campos2=cint(conectar.consultaUno(campos2))
'*************************************** termino nuevo***********************************
'response.write tabla1
totales="select * from ( " & _
"    sum(c.abon_mabono) as abono, " & _
"    sum(b.dcom_mcompromiso - c.abon_mabono) as saldo_total, " & _
"    sum(b.dcom_mcompromiso) as deuda " & _
"from " & _
"    compromisos a,detalle_compromisos b,abonos c, tipos_compromisos d,personas e " & _
"where " & _
"    a.tcom_ccod         =   b.tcom_ccod " & _
"    and a.inst_ccod     =   b.inst_ccod " & _
"    and a.comp_ndocto   =   b.comp_ndocto " & _
"    and b.tcom_ccod     =   c.tcom_ccod(+) " & _
"    and b.inst_ccod     =   c.inst_ccod(+) " & _
"    and b.comp_ndocto   =   c.comp_ndocto(+) " & _
"    and b.dcom_ncompromiso = c.dcom_ncompromiso (+) " & _
"    and c.tcom_ccod         = d.tcom_ccod " & _
"    and a.pers_ncorr        = e.pers_ncorr  " & _
"    and e.pers_nrut        = '"& rut &"'  " & _
"  	  ) a "

instit="select inst_trazon_social from instituciones where inst_ccod='"&inst&"'"
rinsti=conectar.consultauno(instit)


persona.consultar personas	   
formulario.consultar tabla
formulario1.consultar tabla1
insti.consultar institucion

if nro_campos > 0 then 
	formulario.agregacampocons "boton", "<a href=""javascript:acobranza('%tcom_ccod%','%inst_ccod%','%comp_ndocto%','%dcom_ncompromiso%', document.estado);"" >Enviar</a>"
	formulario.agregacampoparam "boton","alineamiento","center"
end if

if nro_campos2 > 0 then 
	formulario1.agregacampocons "boton", "<a href=""javascript:apendiente('%tcom_ccod%','%inst_ccod%','%comp_ndocto%','%dcom_ncompromiso%', document.estado1);"" >Enviar</a>"
	formulario1.agregacampoparam "boton","alineamiento","center"
end if


persona.siguiente
insti.agregacampocons "insti",inst

insti.siguiente



consulta = "select a.pers_ncorr, a.total_abonos, nvl(b.total_abonado, 0) as total_abonado, a.total_abonos - nvl(b.total_abonado, 0) as saldo_abonos " & _
			" from (select a.pers_ncorr, count(*), nvl(sum(a.ingr_mtotal), 0) as total_abonos " & _
			"     from ingresos a, notascreditos_documentos b " & _
			"	  where a.ingr_ncorr = b.ingr_ncorr_notacredito and " & _
			"	              a.eing_ccod = 1 and " & _
			"				  a.ting_ccod = 51 " & _
			"	  group by a.pers_ncorr) a, " & _
			"	  (select a.pers_ncorr, nvl(sum(b.ding_mdetalle), 0) as total_abonado " & _
			"	   from ingresos a, detalle_ingresos b " & _
			"	   where a.ingr_ncorr = b.ingr_ncorr and " & _
			"	         a.eing_ccod = 1 and " & _
			"			 b.ting_ccod = 52 " & _
			"	   group by a.pers_ncorr) b, personas c " & _
			" where a.pers_ncorr = b.pers_ncorr (+) and " & _
			"      a.pers_ncorr = c.pers_ncorr and " & _
			"	  c.pers_nrut = '" &rut& "'"


consulta = "select a.pers_ncorr, a.total_abonos, nvl(b.total_abonado, 0) as total_abonado, " &_
           "       a.total_abonos - nvl(b.total_abonado, 0) as saldo_abonos " &_
		   "from (select a.pers_ncorr, nvl(sum(a.ingr_mtotal), 0) as total_abonos " &_
		   "      from ingresos a, notascreditos_documentos b, personas c, tipos_ingresos d " &_
		   "	  where a.ingr_ncorr = b.ingr_ncorr_notacredito and " &_
		   "	        a.pers_ncorr = c.pers_ncorr and " &_
		   "            a.ting_ccod = d.ting_ccod and " &_
		   "	        a.eing_ccod = 1 and " &_
		   "	        d.ting_brebaje = 'S' and " &_
		   "			a.ting_ccod not in (4, 15) and " &_
		   "			c.pers_nrut = '" & rut & "' " &_
		   "	  group by a.pers_ncorr) a, " &_
		   "	 (select a.pers_ncorr, nvl(sum(b.ding_mdetalle), 0) as total_abonado " &_
		   "	 from ingresos a, detalle_ingresos b, personas c " &_
		   "	 where a.ingr_ncorr = b.ingr_ncorr and " &_
		   "	       a.pers_ncorr = c.pers_ncorr and " &_
		   "	       a.eing_ccod = 1 and " &_
		   "		   b.ting_ccod = 52 and " &_
		   "		   c.pers_nrut = '" & rut & "' " &_
		   "	 group by a.pers_ncorr) b, personas c " &_
		   "where a.pers_ncorr = b.pers_ncorr (+) and " &_
		   "      a.pers_ncorr = c.pers_ncorr and " &_
		   "	  c.pers_nrut = '" & rut & "' "
		   
tabla_na.consultar consulta
tabla_na.siguiente

'response.Write(consulta)

if tabla_na.nrofilas <> 0 then
	suma	=	tabla_na.obtenervalor("saldo_abonos")
else
	suma	=	0
end if


'----------------------------------------------------------------------------------------------------------------------
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "andres.xml", "consulta"

consulta = "select nvl(sum(nvl(malu_mtotal, 0) - nvl(malu_mutilizado, 0)), 0) as malumno " & vbCrLf &_
           "from montos_alumnos a, personas b " & vbCrLf &_
		   "where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
		   "  and a.tmal_ccod in (1) " & vbCrLf &_
		   "  and b.pers_nrut = '" & rut & "'"

f_consulta.Inicializar conectar		
f_consulta.Consultar consulta
f_consulta.Siguiente		   
v_monto_alumno = CLng(f_consulta.ObtenerValor("malumno"))



%>


<html>
<head>
<title>Recepci&oacute;n de Ingresos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
<!--
function VerDetalle()
{
	str_url = "det_nabono.asp?pers_nrut=<%=rut%>&pers_xdv=<%=dv%>";
	
	resultado = open(str_url, "", "width=750, height=400, scrollbars=yes");
}


function DetalleMontosAlumno()
{
	str_url = "det_montos_alumno.asp?pers_nrut=<%=rut%>&pers_xdv=<%=dv%>";	
	resultado = open(str_url, "", "width=750, height=400, scrollbars=yes");
}


function abrir() {
var pasa='<%=desbloqueos%>';
	if(verifica_check(document.edicion)==0){
		if(check_consecutivos(document.edicion)==1 || pasa >= 1){
			aventana();
		}
		else{
			if(es_certificado(document.edicion)==1){
				aventana();
			}
			else {
				if(check_consecutivos(document.edicion)==0){
					alert('Compromiso(s) \"MATRICULA\" o \"COLEGIATURA\", debe(n) ser cancelado(s) desde el más antiguo');
				}
			}
		}
	}
	else {
		if (verifica_check(document.edicion)==1){
			alert('Ha seleccionado más de 7 compromisos');
		}
		else{
			if (verifica_check(document.edicion)==2){
				alert('No ha seleccionado ningún compromiso');
			}
		}
	}
}

function acobranza(a,b,c,d, form){  
	var aa =  MM_findObj('ce[0][tcom_ccod]', form);
	var bb =  MM_findObj('ce[0][inst_ccod]', form);
	var cc =  MM_findObj('ce[0][comp_ndocto]', form);
	var dd =  MM_findObj('ce[0][dcom_ncompromiso]', form);
	aa.value = a ;
	bb.value = b ;
	cc.value = c ;
	dd.value = d ;
	if (confirm('¿ Está seguro que desea enviar éste compromiso a cobranza ?')){
		form.action='actualizar_estado.asp';
		form.submit();
	}
}

function apendiente(a,b,c,d, form){  
	var aa =  MM_findObj('ce2[0][tcom_ccod]', form);
	var bb =  MM_findObj('ce2[0][inst_ccod]', form);
	var cc =  MM_findObj('ce2[0][comp_ndocto]', form);
	var dd =  MM_findObj('ce2[0][dcom_ncompromiso]', form);
	aa.value = a ;
	bb.value = b ;
	cc.value = c ;
	dd.value = d ;
	if (confirm('¿ Está seguro que desea dejar éste compromiso pendiente ?')){
		form.action='actualizar_estado.asp';
		form.submit();
	}
}


function abrir2() {
	if(verifica_check(document.cobranza)==0){
			aventana2();
	}
	else {
		if (verifica_check(document.edicion)==1){
			alert('Ha seleccionado más de 7 compromisos');
		}
		else{
			if (verifica_check(document.edicion)==2){
				alert('No ha seleccionado ningún compromiso');
			}
		}
	}
}


function aventana2(){
	direccion = "about:blank";
	resultado=window.open(direccion, "ventana1","width=800,height=400,scrollbars=YES, resizable=yes, left=0, top=0");
	document.cobranza.target = 'ventana1';
	document.cobranza.action = 'edicion_pago.asp';
	document.cobranza.submit();
}

function aventana(){
	direccion = "about:blank";
	resultado=window.open(direccion, "ventana1","width=800,height=400,scrollbars=YES, resizable=yes, left=0, top=0");
	document.edicion.target = 'ventana1';
	document.edicion.action = 'edicion_pago.asp';
	document.edicion.submit();
}

function verifica_check(formulario) {
	num=formulario.elements.length;
	c=0;
	for (i=0;i<num;i++){
		nombre = formulario.elements[i].name;
		var elem = new RegExp ("dcom_ncompromiso","gi");
		if (elem.test(nombre)){
			if((formulario.elements[i].checked==true)){
				c=c+1;
			}
		}
	}
	if ((c>0) && (c<8)) {
		check=0;//return (true);
	}
	else {
		if (c<=0){
			check=2;
		}
		else {
				check=1;//return (false);
		}
	}
	return(check);
}

function check_consecutivos(formulario) {
	num=formulario.elements.length;
	k=0;
	j=0
	for (i=0;i<num;i++){
		nombre = formulario.elements[i].name;
		var elem = new RegExp ("dcom_ncompromiso","gi");
		if (elem.test(nombre)){
			if(formulario.elements[i].checked==true) {				
				if(formulario.elements[i].name=='m['+j+'][dcom_ncompromiso]'){	
					j=j+1;
					k=2;
				}
				else {
					k=1;
				}
			}
		}
	}
	if (k==2){
		error=1;
	}
	else{
		error=0;
	}
	return(error);
}


function check_consecutivos2(formulario) {
	num=formulario.elements.length;
	k=0;
	j=0
	for (i=0;i<num;i++){
		nombre = formulario.elements[i].name;
		var elem = new RegExp ("dcom_ncompromiso","gi");
		if (elem.test(nombre)){
			if(formulario.elements[i].checked==true) {				
				if(formulario.elements[i].name=='mm['+j+'][dcom_ncompromiso]'){	
					j=j+1;
					k=2;
				}
				else {
					k=1;
				}
			}
		}
	}
	if (k==2){
		error=1;
	}
	else{
		error=0;
	}
	return(error);
}

function es_certificado(formulario){
	certificado=0;
	num=formulario.elements.length;
	for (i=0;i<num;i++){
		nombre = formulario.elements[i].name;
		var elem = new RegExp ("dcom_ncompromiso","gi");
		var cert = new RegExp ("tcom_ccod","gi");
		if (elem.test(nombre)){
			if(formulario.elements[i].checked==true) {
				nombre2=formulario.elements[i+1].name;				
				if(cert.test(nombre2)){
					if(formulario.elements[i+1].value==6 || formulario.elements[i+1].value==7){
							error=0;
							return(error);
					}
				}
			}
		}
	}
		error=1;
		return(error);
}

function enviar(formulario){
		if(!(valida_rut(formulario.rut.value + '-' + formulario.dv.value))){
		    alert('El RUT que Ud. ha ingresado no es válido.Por favor, ingréselo nuevamente.');
			formulario.rut.focus();
			formulario.rut.select();
		 }
		else{
			formulario.action = 'rec_ingresos.asp';
			formulario.submit();
		}
}


function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
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
//-->
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../jefe_carrera/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
            <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
            <tr>
              <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="5"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="207" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="center"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador
                          de Alumnos</font></div></td>
                    <td width="10" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="448" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                  </tr>
              </table></td>
              <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>              
            </tr>
            <tr>
              <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
          </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"><div align="center">
                      <form action="" method="get" name="buscador">
                  <table width="98%"  border="0">
                    <tr>
                      <td width="81%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr> 
                                  <td align="center" nowrap> 
                                    <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Rut&nbsp; 
                                      <input type="text" name="rut" size="10" maxlength="8" id="NU-N" value="<%=rut%>">
                                      - 
                                      <input type="text" name="dv" size="2" maxlength="1" id="LE-N" 			onKeyUp="this.value=this.value.toUpperCase();" value="<%=dv%>">
                                      </font></div>
                                    <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                      </font></div></td>
                                  <td align="center" nowrap><%=insti.dibujaCampo("insti")%></td>
                                </tr>
                              </table></td>
                      <td width="19%"><div align="center">
                        <%botonera.dibujaboton "buscar"%>
                      </div></td>
                    </tr>
                  </table>
				</form>
                </div></td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>			
          </td>
      </tr>
    </table>	
	<br>		
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                        <div align="left"><font size="1" face="Verdana, Arial, Helvetica, sans-serif"><font color="#FFFFFF">Recepci&oacute;n
                      de Ingresos</font></font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE"><table width="95%" align="center" cellpadding="0" cellspacing="0">
                        <tr> 
                          <form name="edicion" method="post">
						 <td align="left"> <%if rut <>"" and dv <> "" then %> <table width="50%" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td>Resultado de la B&uacute;squeda</td>
                              </tr>
                              <tr> 
                                <td nowrap><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Rut: 
                                  <strong><%=persona.dibujaCampo("rut")%></strong> Nombre:<strong> <%=persona.dibujaCampo("nombre")%></strong></font></td>
                              </tr>
							  <tr><td>
							  Institución: <strong><%=rinsti%> </strong>
							  </td><tr>
                            </table>
                            <%else
					  response.Write(texto)
					  end if%> <br> <table width="10%" align="right" cellpadding="0" cellspacing="0">
                              <tr> 
                                <td align="right" nowrap>&nbsp;</td>
                                <td width="42%" align="center" nowrap> <select name="nro_docto" id="NU-N">
                                    <option value="0" selected>0</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="6">6</option>
                                  </select> </td>
                                <td width="0%" align="right" nowrap>&nbsp;</td>
                                <td width="19%" align="right" nowrap>Nro de Documentos</td>
                                <td align="right">&nbsp; </td>
                              </tr>
                              <tr> 
                                <td width="36%" align="right" nowrap>&nbsp;</td>
                                <td colspan="3" align="center" nowrap>&nbsp;</td>
                                <td width="3%" align="right">&nbsp; </td>
                              </tr>
                              <tr> 
                                <td align="right" nowrap>&nbsp;</td>
                                <td colspan="3" align="center" nowrap><%botonera.dibujaboton "pagar"%>
                                </td>
                                <td align="right">&nbsp;</td>
                              </tr>
                            </table>
                            <input type="hidden" name="nombre" value="<%=persona.dibujaCampo("nombre")%>"> 
                            <input type="hidden" name="rut" value="<%=persona.dibujaCampo("rut")%>"> 
                            <!--******************************* INICIO NUEVO  *********************** -->
                            <input type="hidden" name="nro_campos" value="<%=nro_campos%>"> 
                            <!--******************************* TERMINO NUEVO************************** -->
                            <br> <br> <br> <br> <br> <br> <table width="97%" align="center" cellpadding="0" cellspacing="0">
                              <tr> 
                                <td></td>
                              </tr>
                              <tr> 
                                <td height="13" align="center"><strong>COMPROMISOS 
                                  PENDIENTES </strong></td>
                              </tr>
                              <tr> 
                                <td align="center">&nbsp;</td>
                              </tr>
                              <tr> 
                                <td align="center"> <% if rut <>"" and dv <> "" then
										formulario.dibujaTabla()
									%> </td>
                              </tr>
                              <tr> 
                                <td align="center"> <%else%> 
                                  <table width="100%" border="1" align="center" cellpadding=0 cellspacing=0 bordercolor="#FFFFFF" bgcolor="#6581AB">
                                    <tr align="center"> 
                                      <td><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;</font></td>
                                      <td><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif"><strong>Nro. Cuota</strong></font></td>
                                      <td><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif"><strong>Concepto</strong></font></td>
                                      <td><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif"><strong> Vencimiento</strong></font></td>
                                      <td><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif"><strong>Monto</strong></font></td>
                                      <td><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif"><strong>Pago</strong></font></td>
                                      <td><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif"><strong>Saldo</strong></font></td>
                                    </tr>
                                    <tr align="center" bordercolor="#FFFFFF" bgcolor="#AEC7E3"> 
                                      <td colspan="7">Debe 
                                        ingresar el rut de la persona que desea 
                                        consultar</td>
                                    </tr>
                                  </table>
                                <%end if%> </td>
                              </tr>
                              <tr> 
                                <td align="center">&nbsp; </td>
                              </tr>
                              <tr> 
                                <td align="center">&nbsp;</td>
                              </tr>
                              <tr> 
                                <td align="center"> <% 'formulario1.dibujaTabla() %> </td>
                              </tr>
                            </table>
                            <p>
							<%if tabla_na.nrofilas > 0 and suma > 0   then%>
							<strong>* El alumno presenta Nota(s) de Crédito por un total de <%=FormatCurrency(suma, 0)%>.&nbsp;&nbsp;</strong><a href="javascript:VerDetalle()">Ver 
                              Detalle...</a> 
                              <input type="hidden" name="mnabono" value="<%=suma%>"></p>
							<%end if%>
							<p> 
                              <% if v_monto_alumno > 0 then %>
                              <strong>* El alumno tiene pagos reconocidos por 
                              un total de <%=FormatCurrency(v_monto_alumno, 0)%>.&nbsp;&nbsp;<a href="javascript:DetalleMontosAlumno();">Ver 
                              Detalle...</a></strong> 
                              <% end if %>
                            <p> - Debe seleccionar el (los) compromiso(s) que 
                              desea pagar y presionar el botón pagar.<br>
                              - Si desea enviar un compromiso a cobranza debe 
                              presionar <em>'Enviar'</em> y ver&aacute; el resultado 
                              en la tabla siguiente, y viceversa. 
                              <input type="hidden" name="mcaj_ncorr" 
                            value="<%=mcaj_ncorr%>">
                            </td>
                        </form>
                        </tr>
                        <tr>
                          <td align="left">
<form name="cobranza" method="post">
                            <table width="98%" align="center" cellpadding="0" cellspacing="0">
                              <tr> 
                                <td> <input type="hidden" name="mcaj_ncorr" value="<%=mcaj_ncorr%>"> 
                                  <input type="hidden" name="nombre" value="<%=persona.dibujaCampo("nombre")%>"> 
                                  <input type="hidden" name="rut" value="<%=persona.dibujaCampo("rut")%>"> 
                                  <!--******************************* INICIO NUEVO  ***************************** -->
                                  <input type="hidden" name="nro_campos2" value="<%=nro_campos2%>">
                                  <!--******************************* TERMINO NUEVO  ***************************** -->
                                  <br>
                                  <table width="10%" align="right" cellpadding="0" cellspacing="0">
                                    <tr> 
                                      <td width="36%" align="right" nowrap>&nbsp;</td>
                                      <td width="42%" align="center" nowrap> <input type="hidden" name="nro_docto2" value="1" id="NU-N"> 
                                      </td>
                                      <td width="0%" align="right" nowrap>&nbsp;</td>
                                      <td width="19%" align="right" nowrap>&nbsp;</td>
                                      <td width="3%" align="right">&nbsp; </td>
                                    </tr>
                                    <tr> 
                                      <td align="right" nowrap>&nbsp;</td>
                                      <td colspan="3" align="center" nowrap><%botonera.dibujaboton "pagar2"%>
                                      </td>
                                      <td align="right">&nbsp;</td>
                                    </tr>
                                  </table></td>
                              </tr>
                              <tr> 
                                <td align="center"><strong>COMPROMISOS EN COBRANZA</strong></td>
                              </tr>
                              <tr>
                                <td align="center">&nbsp;</td>
                              </tr>
                              <tr> 
                                <td align="center"> 
								<% 
								 formulario1.dibujaTabla() 
								 %> </td>
                              </tr>
                            </table>
							</form>
						  </td>
                        </tr>
                    </table></td>
                  <td align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				    &nbsp;
				    <form name="estado" method="post" >
					  <input type="hidden" name="ce[0][tcom_ccod]" value="">
					  <input type="hidden" name="ce[0][inst_ccod]" value="">
					  <input type="hidden" name="ce[0][comp_ndocto]" value="">
					  <input type="hidden" name="ce[0][dcom_ncompromiso]" value="">
				  </form>
				  <form name="estado1" method="post" >
					  <input type="hidden" name="ce2[0][tcom_ccod]" value="">
					  <input type="hidden" name="ce2[0][inst_ccod]" value="">
					  <input type="hidden" name="ce2[0][comp_ndocto]" value="">
					  <input type="hidden" name="ce2[0][dcom_ncompromiso]" value="">
                   </form>

				    <p><br>				  
	                </p></td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="111" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><div align="center">
                        <%botonera.dibujaboton "salir"%>
                      </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="251" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<p><br>
			<p><br>
			<p><br>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
<%
end if
%>