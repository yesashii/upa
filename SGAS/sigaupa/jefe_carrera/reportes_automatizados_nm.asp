<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=activos_sin_matricular.xls"
Response.ContentType = "application/vnd.ms-excel"

'----------------------------------------------------------------------------------
anos_ccod = Request.QueryString("busqueda[0][anos_ccod]")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "ALUMNOS ACTIVOS SIN MATRICULA EN "

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

anos_siguiente = conexion.consultaUno("select anos_ccod + 1 from anos where cast(anos_ccod as varchar)='"&anos_ccod&"'")
primer_semestre = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_siguiente&"' and plec_ccod=1")
fecha_01 = conexion.consultaUno("select getDate() ")

'-----------------------------------------------------------------------------------------------
set f_listado = new CFormulario
f_listado.Carga_Parametros "consulta.xml", "consulta" 'carga el xml
f_listado.Inicializar conexion 

consulta = 	"  select * "& vbCrLf &_
			" from  "& vbCrLf &_
			" (  "& vbCrLf &_
			" select distinct a.pers_ncorr,cast(a.pers_nrut as varchar)+'-'+ a.pers_xdv as rut,isnull(lower(a.pers_temail),'No ingresado') as email, a.pers_tfono as fono,a.pers_tcelular as celular,  "& vbCrLf &_
			"   a.pers_tape_paterno  as AP_Paterno, a.pers_tape_materno  as AP_Materno, a.pers_tnombre as nombre,protic.trunc(a.pers_fnacimiento) as fecha_nacimiento,  "& vbCrLf &_
			"   case a.sexo_ccod when 1 then 'Masculino' when 2  then 'Femenino' else 'Sin Seleccionar' end as sexo,   "& vbCrLf &_
			"   pai.pais_tdesc as pais,facu.facu_ccod,facu.facu_tdesc as facultad,h.sede_ccod,h.sede_tdesc as sede,e.carr_ccod ,f.carr_tdesc as Carrera,g.jorn_ccod, g.jorn_tdesc as jornada , "& vbCrLf &_
			"   case c.post_bnuevo when 'N' then 'ANTIGUO' else 'NUEVO' end as tipo,   "& vbCrLf &_
			"   protic.ano_ingreso_carrera (a.pers_ncorr,e.carr_ccod) as ano_ingreso, "& vbCrLf &_
			"   (select emat_tdesc from estados_matriculas emat   "& vbCrLf &_
			"   where emat.emat_ccod in (select top 1 emat_ccod from alumnos a1, ofertas_academicas o1 where a1.pers_ncorr=d.pers_ncorr and a1.ofer_ncorr=o1.ofer_ncorr and o1.espe_ccod = c.espe_ccod and a1.emat_ccod <> 9 order by o1.peri_ccod desc, convert(datetime,a1.audi_fmodificacion) desc))   "& vbCrLf &_
			"   as estado_academico,protic.trunc(cont.cont_fcontrato) as fecha_matricula,protic.trunc(d.audi_fmodificacion) as fecha_modificacion  "& vbCrLf &_
			"   from personas_postulante a join alumnos d  "& vbCrLf &_ 
			"        on a.pers_ncorr = d.pers_ncorr "& vbCrLf &_  
			"   join ofertas_academicas c "& vbCrLf &_  
			"        on c.ofer_ncorr = d.ofer_ncorr    "& vbCrLf &_ 
			"   join periodos_academicos pea   "& vbCrLf &_
			"        on c.peri_ccod = pea.peri_ccod and pea.anos_ccod= '"&anos_ccod&"' "& vbCrLf &_
			"   join postulantes pos  "& vbCrLf &_
			"        on pos.post_ncorr = d.post_ncorr  "& vbCrLf &_
			"    join paises pai  "& vbCrLf &_
			"        on pai.pais_ccod = isnull(a.pais_ccod,0)   "& vbCrLf &_
			"    join especialidades e   "& vbCrLf &_
			"        on c.espe_ccod  = e.espe_ccod  "& vbCrLf &_
			"    join carreras f  "& vbCrLf &_
			"        on e.carr_ccod=f.carr_ccod  "& vbCrLf &_
			"    join areas_academicas aca  "& vbCrLf &_
			"        on f.area_ccod = aca.area_ccod  "& vbCrLf &_
			"    join facultades facu  "& vbCrLf &_
			"        on aca.facu_ccod=facu.facu_ccod        "& vbCrLf &_
			"    join jornadas g   "& vbCrLf &_
			"        on c.jorn_ccod=g.jorn_ccod "& vbCrLf &_  
			"    join sedes h   "& vbCrLf &_
			"       on c.sede_ccod=h.sede_ccod  "& vbCrLf &_
			"    join contratos cont  "& vbCrLf &_
			"        on d.matr_ncorr = cont.matr_ncorr and d.post_ncorr = cont.post_ncorr   "& vbCrLf &_
			" where cont.econ_ccod = 1   "& vbCrLf &_
			" and d.emat_ccod not in (9)  "& vbCrLf &_
			" and exists (select 1 from contratos cont1, compromisos comp1 where d.post_ncorr=cont1.post_ncorr and d.matr_ncorr=cont1.matr_ncorr and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2) )    "& vbCrLf &_
			" group by a.pers_ncorr, e.carr_ccod, c.peri_ccod,a.pers_nrut,a.pers_xdv, a.pers_tnombre,a.pers_tape_paterno,  "& vbCrLf &_
			"         a.pers_tape_materno,a.pers_fnacimiento,d.matr_ncorr,f.carr_tdesc,c.post_bnuevo,d.alum_fmatricula,g.jorn_tdesc,h.sede_tdesc,  "& vbCrLf &_
			"         pai.pais_tdesc,e.espe_tdesc,a.sexo_ccod,cont.cont_fcontrato, d.audi_fmodificacion,c.espe_ccod,d.pers_ncorr,a.pers_fnacimiento,a.sexo_ccod, "& vbCrLf &_
			"		 a.pers_temail,facu.facu_ccod,facu_tdesc, h.sede_ccod, g.jorn_ccod, a.pers_tfono,a.pers_tcelular "& vbCrLf &_
			" )tabla_final  "& vbCrLf &_
			" where estado_academico = 'Activa' "& vbCrLf &_
            " and not exists (select 1 from alumnos aa, ofertas_academicas bb, especialidades cc "& vbCrLf &_
            "                 where aa.ofer_ncorr=bb.ofer_ncorr and aa.pers_ncorr=tabla_final.pers_ncorr "& vbCrLf &_
            "                 and bb.espe_ccod=cc.espe_ccod and cc.carr_ccod=tabla_final.carr_ccod "& vbCrLf &_
            "                 and cast(bb.peri_ccod as varchar)='"&primer_semestre&"' and aa.emat_ccod <> 9 ) "& vbCrLf &_
		 	" order by sede,carrera,AP_Paterno,AP_Materno,Nombre "
			
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_listado.Consultar consulta 'este hace la pega
'response.write(consulta)
%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<script language="JavaScript">
</script>

</head>
<body>
<br>
<p>
	<center><font size="+3"><%=pagina.Titulo%>(<%=anos_siguiente%>)</font><br><%=fecha_01%></center>
</p>
<table width="100%" border="1" cellpadding="0" cellspacing="0">
  <tr>
    <td bgcolor="#FF9900"><div align="center"><strong>NUM</strong></div></td>
    <td bgcolor="#FF9900"><div align="center"><strong>Sede</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Carrera</strong></div></td>
    <td bgcolor="#FF9900"><div align="center"><strong>Jornada</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Facultad</strong></div></td>
    <td bgcolor="#FF9900"><div align="center"><strong>Rut</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Nombre</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Fecha Nacimiento</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Sexo</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Tipo</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Año de ingreso</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Estado</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Fecha de matrícula</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Fecha de modificación</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Email</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Teléfono</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Celular</strong></div></td>
  </tr>
  <%NUMERO=1%>
  <%while f_listado.Siguiente%> <!-- mientras hay registro hace-->
  <tr>
    <td align="left"><%=NUMERO%> </td>
    <td align="left"><%=f_listado.ObtenerValor("sede")%></td>
	<td align="left"><%=f_listado.ObtenerValor("carrera")%></td>
	<td align="left"><%=f_listado.ObtenerValor("jornada")%></td>
	<td align="left"><%=f_listado.ObtenerValor("facultad")%></td>
    <td align="left"><%=f_listado.ObtenerValor("rut")%></td>
	<td align="left"><%=f_listado.ObtenerValor("nombre")&" "&f_listado.ObtenerValor("ap_paterno")&" "&f_listado.ObtenerValor("ap_materno") %></td>
	<td align="left"><%=f_listado.ObtenerValor("fecha_nacimiento")%></td>
	<td align="left"><%=f_listado.ObtenerValor("sexo")%></td>
	<td align="left"><%=f_listado.ObtenerValor("tipo")%></td>
	<td align="left"><%=f_listado.ObtenerValor("ano_ingreso")%></td>
	<td align="left"><%=f_listado.ObtenerValor("estado_academico")%></td>
	<td align="left"><%=f_listado.ObtenerValor("fecha_matricula")%></td>
	<td align="left"><%=f_listado.ObtenerValor("fecha_modificacion")%></td>
	<td align="left"><%=f_listado.ObtenerValor("email")%></td>
	<td align="left"><%=f_listado.ObtenerValor("fono")%></td>
	<td align="left"><%=f_listado.ObtenerValor("celular")%></td>
   </tr>
   <%NUMERO=NUMERO+1%>
  <%wend%>
</table>
</body>
</html>
