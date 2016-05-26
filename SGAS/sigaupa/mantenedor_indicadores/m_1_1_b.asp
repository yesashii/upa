<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'	next
	

anos_ccod=request.Form("bu[0][anos_ccod]")	
tipo_mantenedora=request.Form("bu[0][tipo_mantenedora]")
tipo_indi=request.Form("bu[0][tipo_indi]") 


'response.write("<br>anos_ccod= "&anos_ccod)
'response.write("<br>tipo_mantenedora= "&tipo_mantenedora)
'response.write("<br>tipo_indi= "&tipo_indi)	
'response.End()
'---------------------------------------------------------------------------------------------------
'set pagina = new CPagina
'pagina.Titulo = "Encuesta Así soy yo"
'---------------------------------------------------------------------------------------------------
'secc_ccod=request.Form("secc")
'anos_ccod=request.Form("anos_ccod")

set pagina = new cPagina
set conexion = new CConexion
conexion.Inicializar "upacifico"
'
set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "mantenedores_escuela.xml", "botonera"

set f_mantenedor = new CFormulario
'response.End()
if tipo_mantenedora="1" then
	f_mantenedor.Carga_Parametros "mantenedores_escuela.xml", "f_mantenedor_base_1_1_b"
	pre="base"
	anos="2009"
	ano_matricula = "2008"
elseif tipo_mantenedora="2"  then
	f_mantenedor.Carga_Parametros "mantenedores_escuela.xml", "f_mantenedor_real_1_1_b"
	pre="real"
	anos=anos_ccod
	ano_matricula = anos
	valor=valor&" and g.anos_ccod="&anos_ccod&""
elseif tipo_mantenedora="3"  then
	f_mantenedor.Carga_Parametros "mantenedor_anuales.xml", "f_mantenedor_1_1_b"
	pre="estimativo"
	anos="2009"
	valor=valor&" and g.anos_ccod="&anos_ccod&""
end if
f_mantenedor.Inicializar conexion
'response.Write(ano_matricula)
'pers_ncorr=conexion.ConsultaUno("select protic.obtener_pers_ncorr("&q_pers_nrut&")")
if tipo_mantenedora="3" then
	'consulta ="select distinct a.sede_ccod,e.jorn_ccod,d.carr_tdesc,c.carr_ccod,d.tcar_ccod, b.sede_tdesc as sede,e.jorn_tdesc as jornada,d.carr_tdesc as carrera ,case d.tcar_ccod when 1 then 'Pregrado' else 'Postgrado' end as tipo_carrera,isnull(indi_1_1_b,14) as "&pre&"_indi_1_1_b "& vbCrLf &_
	'"from ofertas_academicas a "& vbCrLf &_
	'"join sedes b"& vbCrLf &_
	'"on a.sede_ccod=b.sede_ccod"& vbCrLf &_
	'"join especialidades c"& vbCrLf &_
	'"on  a.espe_ccod=c.espe_ccod"& vbCrLf &_
	'"join carreras d "& vbCrLf &_
	'"on c.carr_ccod=d.carr_ccod"& vbCrLf &_
	'"join jornadas e "& vbCrLf &_
	'"on a.jorn_ccod=e.jorn_ccod"& vbCrLf &_
	'"join periodos_academicos f"& vbCrLf &_
	'"on a.peri_ccod=f.peri_Ccod"& vbCrLf &_
	'"left outer join mantenedor_dato_"&pre&"_escuela g"& vbCrLf &_
	'"on a.sede_ccod=g.sede_ccod"& vbCrLf &_
	'"and e.jorn_ccod=g.jorn_ccod"& vbCrLf &_
	'"and c.carr_ccod=g.carr_ccod"& vbCrLf &_
	'"and d.tcar_ccod=g.tcar_ccod"& vbCrLf &_
	'""&valor&""& vbCrLf &_
	'"where f.anos_Ccod='"&anos&"' and d.tcar_ccod=1 "& vbCrLf &_
	'"and exists (select 1 from alumnos tt where tt.ofer_ncorr=a.ofer_ncorr and tt.emat_ccod=1)"& vbCrLf &_
	'"order by sede,carrera,jornada"
	total_base =conexion.ConsultaUno("select count(*) from mantenedor_dato_base_anual")
	total_real=conexion.ConsultaUno("select count(*) from mantenedor_dato_real_anual  where anos_ccod="&anos_ccod&"")
	total_estimativo=conexion.ConsultaUno("select count(indi_1_1_b) from mantenedor_dato_estimativo_anual")


	if total_base > 0 then
		consulta_base ="(select cast(avg(indi_1_1_b) as decimal(3,0)) from mantenedor_dato_base_escuela where isnull(indi_1_1_b,0) <> 0 ) as base_indi_1_1_b"
	else
		consulta_base ="(select 0)as base_indi_1_1_b"
	end if
	
	if total_real > 0 then
		consulta_real =",(select cast(avg(indi_1_1_b) as decimal(3,0)) from mantenedor_dato_real_escuela where cast(anos_ccod as varchar)='"&anos_ccod&"' and isnull(indi_1_1_b,0) <> 0)as real_indi_1_1_b"
	else
		consulta_real =",(select 0)as real_indi_1_1_b"
	end if
	
	if total_estimativo > 0 then
		consulta_estimativo =",(select isnull(indi_1_1_b,0) as estimativo_indi_1_1_b from mantenedor_dato_estimativo_anual where anos_ccod=2009) as estimativo_indi_1_1_b_2009,"&_
		                     " (select isnull(indi_1_1_b,0) as estimativo_indi_1_1_b from mantenedor_dato_estimativo_anual where anos_ccod=2010) as estimativo_indi_1_1_b_2010,"&_
		                     " (select isnull(indi_1_1_b,0) as estimativo_indi_1_1_b from mantenedor_dato_estimativo_anual where anos_ccod=2011) as estimativo_indi_1_1_b_2011,"&_
							 " (select isnull(indi_1_1_b,0) as estimativo_indi_1_1_b from mantenedor_dato_estimativo_anual where anos_ccod=2012) as estimativo_indi_1_1_b_2012,"&_
							 " (select isnull(indi_1_1_b,0) as estimativo_indi_1_1_b from mantenedor_dato_estimativo_anual where anos_ccod=2013) as estimativo_indi_1_1_b_2013"
	else
		consulta_estimativo=",(select 0 )as estimativo_indi_1_1_b_2009,"&_
		                    ",(select 0 )as estimativo_indi_1_1_b_2010,"&_
							" (select 0 )as estimativo_indi_1_1_b_2011,"&_
							" (select 0 )as estimativo_indi_1_1_b_2012,"&_
							" (select 0 )as estimativo_indi_1_1_b_2013"
	end if
	
	'response.End()
	
	consulta="select "&consulta_base&" "&consulta_real&" "&consulta_estimativo&"" 
	
else
   	consulta =" select sede_ccod,jorn_ccod,carr_tdesc,carr_ccod,tcar_ccod,sede,jornada,carrera, "& vbCrLf &_
			  "	tipo_carrera,total_matriculados,total_matriculados_fp,  "& vbCrLf &_
			  "	case isnull(base_indi_1_1_b,200) when 200 then case total_matriculados when 0 then 0 else cast(((total_matriculados_fp * 100) / total_matriculados) as decimal(3,0)) end "& vbCrLf &_
			  "									   else base_indi_1_1_b end as "&pre&"_indi_1_1_b"& vbCrLf &_
			  "	from "& vbCrLf &_ 
			  "	(  "& vbCrLf &_                                  
			  "	select distinct a.sede_ccod,e.jorn_ccod,d.carr_tdesc,c.carr_ccod,d.tcar_ccod,  "& vbCrLf &_
			  "	b.sede_tdesc as sede,e.jorn_tdesc as jornada,d.carr_tdesc as carrera , "& vbCrLf &_
			  "	case d.tcar_ccod when 1 then 'Pregrado' else 'Postgrado' end as tipo_carrera, "& vbCrLf &_
			  "	indi_1_1_b as base_indi_1_1_b, "& vbCrLf &_
			  "	(select count(distinct T2.pers_ncorr)  "& vbCrLf &_
			  "	   from alumnos T2,ofertas_academicas TT, "& vbCrLf &_
			  "			especialidades T3    "& vbCrLf &_
			  "	 where T2.ofer_ncorr= TT.ofer_ncorr    "& vbCrLf &_
			  "	   and TT.espe_ccod = T3.espe_ccod and TT.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod='"&ano_matricula&"') "& vbCrLf &_
			  "	   and TT.jorn_ccod= e.jorn_ccod    "& vbCrLf &_
			  "	   and T3.carr_ccod= d.carr_ccod   "& vbCrLf &_
			  "	   and TT.sede_ccod= b.sede_ccod   "& vbCrLf &_
			  "	   and T2.emat_ccod in (1,4,8,2,15,16)  and T2.audi_tusuario not like '%ajunte matricula%'   "& vbCrLf &_
			  "	   and protic.afecta_estadistica(T2.matr_ncorr) > 0    "& vbCrLf &_
			  "	   and isnull(T2.alum_nmatricula,0) not in (7777)  "& vbCrLf &_
			  "	   and exists (select 1 from cargas_academicas ttt where ttt.matr_ncorr=t2.matr_ncorr) "& vbCrLf &_
			  "	   and T2.audi_tusuario not in ('Agregabase_saenzBeta2','AgregaBaseSaenzBeta2','AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42',   "& vbCrLf &_
			  "									'AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno',    "& vbCrLf &_
			  "									'AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65',    "& vbCrLf &_
			  "									'AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99','AgregaNotaN',    "& vbCrLf &_
			  "									'AgregaNotaProtix','AgregaNotaprotix1','Agreganotas_saenzBeta2','AgregaNotas46$','AgregaNotas46$Beta','AgregaNotas46$Beta2','AgregaNotasSaenzBeta2',  "& vbCrLf &_ 
			  "									'Agregaprotix_saenzBeta2','AgregaProtixSaenzBeta2') "& vbCrLf &_
			  "	   ) as total_matriculados, "& vbCrLf &_
			  "	(select count(distinct T2.pers_ncorr)  "& vbCrLf &_
			  "	   from alumnos T2,ofertas_academicas TT, "& vbCrLf &_
			  "			especialidades T3   "& vbCrLf &_
			  "	 where T2.ofer_ncorr= TT.ofer_ncorr   "& vbCrLf &_
			  "	   and TT.espe_ccod = T3.espe_ccod and TT.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod='"&ano_matricula&"') "& vbCrLf &_
			  "	   and TT.jorn_ccod= e.jorn_ccod   "& vbCrLf &_
			  "	   and T3.carr_ccod= d.carr_ccod   "& vbCrLf &_
			  "	   and TT.sede_ccod= b.sede_ccod   "& vbCrLf &_
			  "	   and T2.emat_ccod in (1,4,8,2,15,16)  and T2.audi_tusuario not like '%ajunte matricula%'   "& vbCrLf &_
			  "	   and protic.afecta_estadistica(T2.matr_ncorr) > 0   "& vbCrLf &_
			  "	   and isnull(T2.alum_nmatricula,0) not in (7777) "& vbCrLf &_
			  "	   and exists (select 1 from cargas_academicas ttt, secciones tt2, malla_curricular tt3 "& vbCrLf &_
			  "				   where ttt.matr_ncorr=t2.matr_ncorr and ttt.secc_ccod=tt2.secc_ccod and tt2.mall_ccod=tt3.mall_ccod "& vbCrLf &_
			  "				   and tt3.plan_ccod in (370,378,479,527) ) "& vbCrLf &_
			  "	   and T2.audi_tusuario not in ('Agregabase_saenzBeta2','AgregaBaseSaenzBeta2','AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42',   "& vbCrLf &_
			  "									'AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno',    "& vbCrLf &_
			  "									'AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65',   "& vbCrLf &_
			  "									'AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99','AgregaNotaN',   "& vbCrLf &_
			  "									'AgregaNotaProtix','AgregaNotaprotix1','Agreganotas_saenzBeta2','AgregaNotas46$','AgregaNotas46$Beta','AgregaNotas46$Beta2','AgregaNotasSaenzBeta2', "& vbCrLf &_  
			  "									'Agregaprotix_saenzBeta2','AgregaProtixSaenzBeta2') "& vbCrLf &_
			  "	   ) as total_matriculados_fp"& vbCrLf &_
			  " from ofertas_academicas a "& vbCrLf &_
			  " join sedes b"& vbCrLf &_
			  " 	on a.sede_ccod=b.sede_ccod"& vbCrLf &_
			  " join especialidades c"& vbCrLf &_
			  "		on  a.espe_ccod=c.espe_ccod"& vbCrLf &_
			  " join carreras d "& vbCrLf &_
			  "		on c.carr_ccod=d.carr_ccod"& vbCrLf &_
			  "	join jornadas e "& vbCrLf &_
			  "		on a.jorn_ccod=e.jorn_ccod"& vbCrLf &_
			  "	join periodos_academicos f"& vbCrLf &_
			  "		on a.peri_ccod=f.peri_Ccod"& vbCrLf &_
			  "	left outer join mantenedor_dato_"&pre&"_escuela g"& vbCrLf &_
			  "		on a.sede_ccod=g.sede_ccod"& vbCrLf &_
			  "		and e.jorn_ccod=g.jorn_ccod"& vbCrLf &_
			  "		and c.carr_ccod=g.carr_ccod"& vbCrLf &_
			  "		and d.tcar_ccod=g.tcar_ccod"& vbCrLf &_
			  " "&valor&""& vbCrLf &_
			  "  where f.anos_Ccod='"&anos&"' and d.tcar_ccod=1 "& vbCrLf &_
			  "  and exists (select 1 from alumnos tt where tt.ofer_ncorr=a.ofer_ncorr and tt.emat_ccod=1)"& vbCrLf &_
			  "  )table1 "& vbCrLf &_
			  "  order by sede,carrera,jornada"

end if
'"select distinct a.sede_ccod,e.jorn_ccod,d.carr_tdesc,c.carr_ccod,d.tcar_ccod, b.sede_tdesc as sede,e.jorn_tdesc as jornada,d.carr_tdesc as carrera ,case d.tcar_ccod when 1 then 'Pregrado' else 'Postgrado' end as tipo_carrera,isnull(indi_1_1_a,0) as "&pre&"_indi_1_1_a "& vbCrLf &_
'"from ofertas_academicas a, sedes b, especialidades c, carreras d, jornadas e, periodos_academicos f,mantenedor_dato_"&pre&"_escuela g"& vbCrLf &_
'"where a.sede_ccod=b.sede_ccod" & vbCrLf &_
'"and a.espe_ccod=c.espe_ccod"& vbCrLf &_
'"and c.carr_ccod=d.carr_ccod"& vbCrLf &_
'"and a.jorn_ccod=e.jorn_ccod"& vbCrLf &_
'"and a.peri_ccod=f.peri_Ccod "& vbCrLf &_
'"and f.anos_Ccod='"&anos&"'"& vbCrLf &_
'""&valor&""& vbCrLf &_
'"and exists (select 1 from alumnos tt where tt.ofer_ncorr=a.ofer_ncorr and tt.emat_ccod=1)"& vbCrLf &_
'"and a.sede_ccod=g.sede_ccod"& vbCrLf &_
'"and e.jorn_ccod=g.jorn_ccod"& vbCrLf &_
'"and c.carr_ccod=g.carr_ccod"& vbCrLf &_
'"and d.tcar_ccod=g.tcar_ccod"& vbCrLf &_
'"order by sede,carrera,jornada" 



'response.write("<pre>"&consulta&"</pre>")
'response.End()
f_mantenedor.Consultar consulta
'f_mantenedor.Siguiente


'Ano =conexion.ConsultaUno("select anos_ccod from ")

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<title>- Universidad del Pac&iacute;fico</title>
<style type="text/css">
.Estilo35 {
	font-weight: bold;
	font-size: 26px;
	font-style: Arial, Helvetica, sans-serif;
	color: #000000;
}
.Estilo36 {
	font-weight: bold;
	font-size: 18px;
	font-style: Arial, Helvetica, sans-serif;
	color: #000000;
}
</style>
<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function bloquea_tabla()
{
	var mant=<%=tipo_mantenedora%>;
	 if (mant==3)
	 {
		 document.edicion.elements["ma[0][base_indi_1_1_b]"].disabled=true;
		 document.edicion.elements["ma[0][real_indi_1_1_b]"].disabled=true;
	 }
}

function verifica_porcentaje(numero,nombre)
{
	if ((numero>=0)&&(numero<=100))
	{
	}
	else
	{
	document.edicion.elements[nombre].value=0;
	document.edicion.elements[nombre].focus()
	document.edicion.elements[nombre].select();
	alert('El porcentaje no es valido');
	}

}
</script>
</head>

<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');bloquea_tabla()" >
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA"><br>
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
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
				<table width="700" border="0">
					<tr valign="top" align="center">
						<td width="100%" align="center">
						<form name="edicion">
						<input type="hidden" name="ma[0][anos_ccod]" value="<%=anos_ccod%>">
						<input type="hidden" name="ma[0][tipo_mantenedora]" value="<%=tipo_mantenedora%>">
						<input type="hidden" name="ma[0][tipo_indi]" value="<%=tipo_indi%>">
  						<table>
						  <tr>
							<td align="center">
							<%if tipo_mantenedora="1" then%>
							<p class="Estilo35"><strong>Informaci&oacute;n  Base para</strong></p>
							<%elseif tipo_mantenedora="2" then%>
							<p class="Estilo35"><strong>Informaci&oacute;n Real para el Año <%=anos_ccod%> de </strong></p>
							<%elseif tipo_mantenedora="3" then%>
							<p class="Estilo35"><strong>Informaci&oacute;n Estimativa para el Año <%=anos_ccod%> de </strong></p>
							<%end if%>
							</td>
						  </tr>
						  <tr>
							<td>
							<p class="Estilo36" align="center"><strong>Porcentaje de alumnos participantes en programa de formación general optativa</strong></p>
							</td>
						  </tr>
						  <tr valign="top">
						   <td>
							  <table>
								<tr>
									<td>
									<%f_mantenedor.DibujaTabla()%>
									</td>
								 </tr>
							  </table>
						   </td>	
						</tr>
                      </table>
                    </form>
                </td>
             </tr>
         </table>
        </td>
        </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="31%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
				  <td>
				      <div align="center">
                  		<% if tipo_mantenedora <> "3" then
						   	f_botonera.AgregaBotonParam "guardar", "url", "m_1_1_b_proc.asp"
						   else
						   	f_botonera.AgregaBotonParam "guardar", "url", "m_1_1_b_anual_proc.asp"
						   end if	
					    f_botonera.DibujaBoton"guardar"%>
					  </div>
				  </td>
				  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
                </tr>
              </table>
            </td>
            <td width="69%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
