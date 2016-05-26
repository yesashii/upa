<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_ncorr =Request.QueryString("pers_ncorr")
q_peri_ccod= request.QueryString("peri_ccod")

set pagina = new CPagina
pagina.Titulo = "Becas"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
set f_botonera = new CFormulario
f_botonera.carga_parametros "mis_datos.xml", "botonera"


set botonera = new CFormulario
botonera.carga_parametros "mis_datos.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "mis_datos.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

'---------------------------------------------------------------------------------------------------
set f_mis_datos = new CFormulario
f_mis_datos.Carga_Parametros "mis_datos.xml", "cheques"
f_mis_datos.Inicializar conexion

 
if q_peri_ccod = "" then
sql_descuentos= "select ''"

else 
sql_descuentos= "select a.pers_ncorr,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,"& vbCrLf &_
				"(select sede_tdesc from sedes r where r.sede_ccod=c.sede_ccod)as sede,"& vbCrLf &_
				"case when datos_corr='S' then 'SI' else 'NO'end as datos_correctos,"& vbCrLf &_
				"case when trabaja_estudia=1 then 'SOLO ESTUDIA' else 'ESTUDIA Y TRABAJA' end as estudia,"& vbCrLf &_
				"isnull((select tenfer_tdesc from tipos_enfermedad aa where aa.tenfer_ccod=g.tenfer_ccod ),'')as tenfer_tdesc,"& vbCrLf &_
				"tenfer_otro,"& vbCrLf &_
				"pre_basica,basica,media_1_3,media_4,superior,otra,"& vbCrLf &_
				"upper(pers_tape_paterno)+' '+upper(pers_tape_materno)+' '+upper(pers_tnombre)as nombre,"& vbCrLf &_
				"carr_tdesc as carrera, protic.obtener_direccion(a.pers_ncorr,1,'CNPB')as direccion, "& vbCrLf &_
				"case when vive_con_padres='S' then 'SI' else 'NO' end as vive_con_padres,"& vbCrLf &_
				"case when cual_padre_vive= 1 then 'CON LA MADRE' when cual_padre_vive=2 then 'CON EL PADRE' when cual_padre_vive=3 then 'CON AMBOS' end as cual_padre_vive"& vbCrLf &_
				"from personas a, "& vbCrLf &_
				"alumnos b,"& vbCrLf &_
				"ofertas_academicas c,"& vbCrLf &_
				"especialidades d,"& vbCrLf &_
				"carreras e, "& vbCrLf &_
				"direcciones f,"& vbCrLf &_
				"mis_datos g"& vbCrLf &_
				"where a.pers_ncorr="&q_pers_ncorr&""& vbCrLf &_
				"and a.pers_ncorr=b.pers_ncorr"& vbCrLf &_
				"and b.ofer_ncorr=c.ofer_ncorr"& vbCrLf &_
				"and c.espe_ccod=d.espe_ccod"& vbCrLf &_
				"and d.carr_ccod=e.carr_ccod"& vbCrLf &_
				"and a.pers_ncorr=f.pers_ncorr"& vbCrLf &_
				"and a.pers_ncorr=g.pers_ncorr"& vbCrLf &_
				"and peri_ccod="&q_peri_ccod&""& vbCrLf &_
				"--and post_bnuevo='S'"& vbCrLf &_
				"and tdir_ccod=1"& vbCrLf &_
				"and emat_ccod=1"
					
end if

f_mis_datos.Consultar sql_descuentos
f_mis_datos.Siguiente				
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&numero_total&"</pre>")
'response.Write("<pre>"&q_sfun_ccod&"</pre>")
'response.End()

s_parentesco_codeudor="select c.pare_ccod"& vbCrLf &_
"from alumnos a,"& vbCrLf &_
"postulantes b,"& vbCrLf &_
"codeudor_postulacion c"& vbCrLf &_
"where a.pers_ncorr="&q_pers_ncorr&""& vbCrLf &_
"and a.pers_ncorr=b.pers_ncorr"& vbCrLf &_
"and b.post_ncorr=c.post_ncorr"& vbCrLf &_
"and peri_ccod="&q_peri_ccod&""
parentesco_codeudor=conexion.consultaUno(s_parentesco_codeudor)

'response.Write("<pre>"&s_parentesco_codeudor&"</pre>")
'response.Write("<pre>"&parentesco_codeudor&"</pre>")

'response.Write("<pre>select case count(*) when 0 then 'N' else 'S' end from mis_datos_hermanos where pers_ncorr="&q_pers_ncorr&"</pre>")
existen_parientes=conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from mis_datos_hermanos where pers_ncorr="&q_pers_ncorr&"")

if existen_parientes="S" then

set f_mis_datos_parientes = new CFormulario
f_mis_datos_parientes.Carga_Parametros "mis_datos.xml", "parientes"
f_mis_datos_parientes.Inicializar conexion

s_parientes="select midh_nombre+' '+midh_ape_paterno+' '+midh_ape_materno as nombre,"& vbCrLf &_
				"(select pare_tdesc from parentescos aa where aa.pare_ccod=a.pare_ccod)as parentesco,"& vbCrLf &_
				"midh_edad as edad,"& vbCrLf &_
				"midh_cargo as cargo,"& vbCrLf &_
				"midh_empresa as empresa" & vbCrLf &_
				"from mis_datos_hermanos a"& vbCrLf &_
				"where pers_ncorr="&q_pers_ncorr&""
f_mis_datos_parientes.Consultar s_parientes
'response.Write("<br>"&s_parientes)
end if

if parentesco_codeudor<>"1" and parentesco_codeudor<>"2" then

set f_mis_datos_codeudor= new CFormulario
f_mis_datos_codeudor.Carga_Parametros "mis_datos.xml", "codeudor"
f_mis_datos_codeudor.Inicializar conexion

s_codeudor="select cast(pers_nrut as varchar)+'-'+pers_xdv as rut,"& vbCrLf &_
"pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre,"& vbCrLf &_
"(select pare_tdesc from parentescos aa where aa.pare_ccod=b.pare_ccod)as parentesco,"& vbCrLf &_
"isnull((select pais_tdesc from paises aa where aa.pais_ccod=a.pais_ccod),'CHILE') as pais,"& vbCrLf &_
"(select regi_tdesc from regiones aa,ciudades bb,direcciones cc where aa.regi_ccod=bb.regi_ccod and bb.ciud_ccod=cc.ciud_ccod and tdir_ccod=1 and cc.pers_ncorr=a.pers_ncorr)as region,"& vbCrLf &_
"(select ciud_tdesc from ciudades bb,direcciones cc where  bb.ciud_ccod=cc.ciud_ccod and tdir_ccod=1 and cc.pers_ncorr=a.pers_ncorr)as ciudad,"& vbCrLf &_
"(select eciv_tdesc from estados_civiles aa where aa.eciv_ccod=a.eciv_ccod)as estado_civil,"& vbCrLf &_
"protic.obtener_direccion(a.pers_ncorr,1,'CNPB')as direccion,"& vbCrLf &_
"pers_temail,"& vbCrLf &_
"mdoc_cargo as cargo,"& vbCrLf &_
"mdoc_empresa as empresa,"& vbCrLf &_
"(select nied_tdesc from nivel_educacional aa where aa.nied_ccod=b.nied_ccod)as nied_ccod,"& vbCrLf &_
"(select sicupadre_tdesc from situacion_ocupacional_padres aa where aa.sicupadre_ccod=b.sicupadre_ccod)as sicupadre_ccod,"& vbCrLf &_
"(select topa_tdesc from tipo_organizacion_padre aa where aa.topa_ccod=b.topa_ccod)as topa_ccod,"& vbCrLf &_
"(select sitocup_tdesc from tipos_situacion_padres aa where aa.sitocup_ccod=b.sitocup_ccod)as sitocup_ccod"& vbCrLf &_
"from personas a"& vbCrLf &_
"join mis_datos_otro_codeudor b"& vbCrLf &_
"on a.pers_ncorr=b.pers_ncorr_codeudor"& vbCrLf &_
"join codeudor_postulacion c"& vbCrLf &_
"on b.pers_ncorr_codeudor=c.pers_ncorr"& vbCrLf &_
"join alumnos d"& vbCrLf &_
"on b.pers_ncorr=d.pers_ncorr"& vbCrLf &_
"join postulantes e"& vbCrLf &_
"on d.post_ncorr=e.post_ncorr"& vbCrLf &_
"where b.pers_ncorr="&q_pers_ncorr&""& vbCrLf &_
"and e.peri_ccod="&q_peri_ccod&""

f_mis_datos_codeudor.Consultar s_codeudor
f_mis_datos_codeudor.Siguiente
'response.Write("<br>"&s_codeudor)
end if




existe_codeudor_papa=conexion.consultaUno("select case count(pers_ncorr_sostenedor) when 0 then 'N' else 'S' end from mis_datos_padres where pers_ncorr="&q_pers_ncorr&" and pare_ccod=1")
existe_codeudor_mama=conexion.consultaUno("select case count(pers_ncorr_sostenedor) when 0 then 'N' else 'S' end from mis_datos_padres where pers_ncorr="&q_pers_ncorr&" and pare_ccod=2")

set f_mis_datos_papa = new CFormulario
f_mis_datos_papa.Carga_Parametros "mis_datos.xml", "papa"
f_mis_datos_papa.Inicializar conexion

'response.Write("<br> existe papa"&existe_codeudor_papa)
'response.Write("<br> select case count(pers_ncorr_sostenedor) when 0 then 'N' else 'S' end from mis_datos_padres where pers_ncorr="&q_pers_ncorr&" and pare_ccod=1")
if existe_codeudor_papa="N" then
s_papa="select cast(midp_rut as varchar)+'-'+midp_dv as rut,"& vbCrLf &_
"midp_nombre+' '+midp_ape_paterno+' '+midp_ape_materno as nombre,"& vbCrLf &_
"isnull((select pais_tdesc from paises aa where cast(aa.pais_ccod as varchar)=a.pais_ccod),'CHILE') as pais,"& vbCrLf &_
"(select regi_tdesc from regiones aa where cast(aa.regi_ccod as varchar)=a.regi_ccod)as region,"& vbCrLf &_
"(select ciud_tdesc from ciudades bb where  cast(bb.ciud_ccod as varchar)=a.ciud_ccod )as ciudad,"& vbCrLf &_
"(select eciv_tdesc from estados_civiles aa where cast(aa.eciv_ccod as varchar)=a.eciv_ccod)as estado_civil,"& vbCrLf &_
"midp_calle+' Nro: '+midp_nro+' '+isnull(+'Depto: '+midp_depto,'')+' '+isnull(+'Condominio: '+midp_condominio,'')as direccion,"& vbCrLf &_
"(select nied_tdesc from nivel_educacional aa where cast(aa.nied_ccod as varchar)=a.nied_ccod)as nied_ccod,"& vbCrLf &_
"(select sicupadre_tdesc from situacion_ocupacional_padres aa where cast(aa.sicupadre_ccod as varchar)=a.sicupadre_ccod)as sicupadre_ccod,"& vbCrLf &_
"(select topa_tdesc from tipo_organizacion_padre aa where cast(aa.topa_ccod as varchar)=a.topa_ccod)as topa_ccod,"& vbCrLf &_
"(select sitocup_tdesc from tipos_situacion_padres aa where cast(aa.sitocup_ccod as varchar)=a.sitocup_ccod)as sitocup_ccod,"& vbCrLf &_
"case when datos_corr='S' then 'SI' else 'NO' end as datos_corr,"& vbCrLf &_
"midp_cago as cargo,"& vbCrLf &_
"midp_empresa as empresa,"& vbCrLf &_
"case when vivo='N' then 'NO' when vivo='S' then 'SI' end as vivo"& vbCrLf &_
"from  mis_datos_padres a"& vbCrLf &_
"where a.pers_ncorr="&q_pers_ncorr&""& vbCrLf &_
"and pare_ccod=1"


elseif existe_codeudor_papa="S" then
s_papa="select cast(pers_nrut as varchar)+'-'+pers_xdv as rut,"& vbCrLf &_
"pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre,"& vbCrLf &_
"isnull((select pais_tdesc from paises aa where aa.pais_ccod=a.pais_ccod),'CHILE') as pais,"& vbCrLf &_
"(select regi_tdesc from regiones aa,ciudades bb,direcciones cc where aa.regi_ccod=bb.regi_ccod and bb.ciud_ccod=cc.ciud_ccod and tdir_ccod=1 and cc.pers_ncorr=a.pers_ncorr)as region,"& vbCrLf &_
"(select ciud_tdesc from ciudades bb,direcciones cc where  bb.ciud_ccod=cc.ciud_ccod and tdir_ccod=1 and cc.pers_ncorr=a.pers_ncorr)as ciudad,"& vbCrLf &_
"(select eciv_tdesc from estados_civiles aa where aa.eciv_ccod=a.eciv_ccod)as estado_civil,"& vbCrLf &_
"protic.obtener_direccion(a.pers_ncorr,1,'CNPB')as direccion,"& vbCrLf &_
"pers_temail,"& vbCrLf &_
"midp_cago as cargo,"& vbCrLf &_
"midp_empresa as empresa,"& vbCrLf &_
"(select nied_tdesc from nivel_educacional aa where cast(aa.nied_ccod as varchar)=b.nied_ccod)as nied_ccod,"& vbCrLf &_
"(select sicupadre_tdesc from situacion_ocupacional_padres aa where aa.sicupadre_ccod=b.sicupadre_ccod)as sicupadre_ccod,"& vbCrLf &_
"(select topa_tdesc from tipo_organizacion_padre aa where aa.topa_ccod=b.topa_ccod)as topa_ccod,"& vbCrLf &_
"(select sitocup_tdesc from tipos_situacion_padres aa where aa.sitocup_ccod=b.sitocup_ccod)as sitocup_ccod,"& vbCrLf &_
"case when datos_corr='S' then 'SI' else 'NO' end as datos_corr,"& vbCrLf &_
"case when vivo='N' then 'NO' when vivo='S' then 'SI' end as vivo"& vbCrLf &_
"from personas a"& vbCrLf &_
"left outer join mis_datos_padres b"& vbCrLf &_
"on a.pers_ncorr=b.pers_ncorr_sostenedor"& vbCrLf &_
"where b.pers_ncorr="&q_pers_ncorr&""& vbCrLf &_
"and pare_ccod=1"
end if
'response.Write("<br>"&s_papa)
f_mis_datos_papa.Consultar s_papa
f_mis_datos_papa.Siguiente



set f_mis_datos_mama = new CFormulario
f_mis_datos_mama.Carga_Parametros "mis_datos.xml", "mama"
f_mis_datos_mama.Inicializar conexion


if existe_codeudor_mama="N" then

s_mama="select cast(midp_rut as varchar)+'-'+midp_dv as rut,"& vbCrLf &_
"midp_nombre+' '+midp_ape_paterno+' '+midp_ape_materno as nombre,"& vbCrLf &_
"isnull((select pais_tdesc from paises aa where cast(aa.pais_ccod as varchar)=a.pais_ccod),'CHILE') as pais,"& vbCrLf &_
"(select regi_tdesc from regiones aa where cast(aa.regi_ccod as varchar)=a.regi_ccod)as region,"& vbCrLf &_
"(select ciud_tdesc from ciudades bb where  cast(bb.ciud_ccod as varchar)=a.ciud_ccod )as ciudad,"& vbCrLf &_
"(select eciv_tdesc from estados_civiles aa where cast(aa.eciv_ccod as varchar)=a.eciv_ccod)as estado_civil,"& vbCrLf &_
"midp_calle+' Nro: '+midp_nro+' '+isnull(+'Depto: '+midp_depto,'')+' '+isnull(+'Condominio: '+midp_condominio,'')as direccion,"& vbCrLf &_
"(select nied_tdesc from nivel_educacional aa where cast(aa.nied_ccod as varchar)=a.nied_ccod)as nied_ccod,"& vbCrLf &_
"(select sicupadre_tdesc from situacion_ocupacional_padres aa where cast(aa.sicupadre_ccod as varchar)=a.sicupadre_ccod)as sicupadre_ccod,"& vbCrLf &_
"(select topa_tdesc from tipo_organizacion_padre aa where cast(aa.topa_ccod as varchar)=a.topa_ccod)as topa_ccod,"& vbCrLf &_
"(select sitocup_tdesc from tipos_situacion_padres aa where cast(aa.sitocup_ccod as varchar)=a.sitocup_ccod)as sitocup_ccod,"& vbCrLf &_
"midp_cago as cargo,"& vbCrLf &_
"midp_empresa as empresa,"& vbCrLf &_
"case when datos_corr='S' then 'SI' else 'NO' end as datos_corr,"& vbCrLf &_
"case when vivo='N' then 'NO' when vivo='S' then 'SI' end as vivo"& vbCrLf &_
"from  mis_datos_padres a"& vbCrLf &_
"where a.pers_ncorr="&q_pers_ncorr&""& vbCrLf &_
"and pare_ccod=2"

elseif existe_codeudor_mama="S" then
s_mama="select cast(pers_nrut as varchar)+'-'+pers_xdv as rut,"& vbCrLf &_
"pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre,"& vbCrLf &_
"isnull((select pais_tdesc from paises aa where aa.pais_ccod=a.pais_ccod),'CHILE') as pais,"& vbCrLf &_
"(select regi_tdesc from regiones aa,ciudades bb,direcciones cc where aa.regi_ccod=bb.regi_ccod and bb.ciud_ccod=cc.ciud_ccod and tdir_ccod=1 and cc.pers_ncorr=a.pers_ncorr)as region,"& vbCrLf &_
"(select ciud_tdesc from ciudades bb,direcciones cc where  bb.ciud_ccod=cc.ciud_ccod and tdir_ccod=1 and cc.pers_ncorr=a.pers_ncorr)as ciudad,"& vbCrLf &_
"(select eciv_tdesc from estados_civiles aa where aa.eciv_ccod=a.eciv_ccod)as estado_civil,"& vbCrLf &_
"protic.obtener_direccion(a.pers_ncorr,1,'CNPB')as direccion,"& vbCrLf &_
"pers_temail,"& vbCrLf &_
"midp_cago as cargo,"& vbCrLf &_
"midp_empresa as empresa,"& vbCrLf &_
"(select nied_tdesc from nivel_educacional aa where cast(aa.nied_ccod as varchar)=b.nied_ccod)as nied_ccod,"& vbCrLf &_
"(select sicupadre_tdesc from situacion_ocupacional_padres aa where aa.sicupadre_ccod=b.sicupadre_ccod)as sicupadre_ccod,"& vbCrLf &_
"(select topa_tdesc from tipo_organizacion_padre aa where aa.topa_ccod=b.topa_ccod)as topa_ccod,"& vbCrLf &_
"(select sitocup_tdesc from tipos_situacion_padres aa where aa.sitocup_ccod=b.sitocup_ccod)as sitocup_ccod,"& vbCrLf &_
"case when datos_corr='S' then 'SI' else 'NO' end as datos_corr,"& vbCrLf &_
"case when vivo='N' then 'NO' when vivo='S' then 'SI' end as vivo"& vbCrLf &_
"from personas a"& vbCrLf &_
"left outer join mis_datos_padres b"& vbCrLf &_
"on a.pers_ncorr=b.pers_ncorr_sostenedor"& vbCrLf &_
"where b.pers_ncorr="&q_pers_ncorr&""& vbCrLf &_
"and pare_ccod=2"
end if

'response.Write("<br>"&s_mama)
f_mis_datos_mama.Consultar s_mama
f_mis_datos_mama.Siguiente
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
</script></head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
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
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
		  <tr>
		  <td><div align="center">
                    <br>
                    <table width="100%" border="0">
                    </table>					</tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Resultado Mis datos"%>
					
                      <table width="98%"  border="0" align="center">
					   <tr>
                             <td align="right"></td>
                        </tr>
                        <tr>						
                                <td align="center">  
									<table width="100%" border="0">
										<tr>
										  <td width="6%" ><div align="top"><strong>Rut</strong> : </div></td>
											<td width="18%" align="left"><%=f_mis_datos.Obtenervalor("rut")%></td>
										  <td width="8%" ><div align="top"><strong>Nombre:</strong></div></td>
										  <td width="68%" align="left"><%=f_mis_datos.Obtenervalor("nombre")%></td>
										</tr>
										<tr>
											<td ><div align="top"><strong>Sede:</strong></div></td>
											<td align="left"><%=f_mis_datos.Obtenervalor("sede")%></td>
											<td ><div align="top"><strong>Carrera</strong>:</div></td>
											<td align="left"><%=f_mis_datos.Obtenervalor("carrera")%></td>
										</tr>
									</table>
									
									<br>
									<table width="100%">
										<tr>
											<td width="24%"><strong>Parentesco del Codeudor</strong></td>
											<td width="76%"><%=parentesco_codeudor%></td>
										</tr>
									</table>
									<br>
									<table width="100%" border="0">
										<tr>
										  <td width="10%" ><div align="top"><strong>Dirección</strong>:</div></td>
										  <td width="90%" align="left"><%=f_mis_datos.Obtenervalor("direccion")%></td>
										</tr>
										<tr>
											<td>&nbsp;</td>
										</tr>
									</table>
									<table width="100%" border="0">
                                      <tr>
                                        <td width="36%" ><div align="top"><strong>La direcci&oacute;n en el sistema es correcta </strong>:</div></td>
                                        <td width="8%" align="left"><%=f_mis_datos.Obtenervalor("datos_correctos")%></td>
                                        <td width="22%" ><strong>Situacion Ocupacional</strong>:</td>
                                        <td width="34%" align="left" valign="bottom"><%=f_mis_datos.Obtenervalor("estudia")%></td>
                                      </tr>
									  <tr>
											<td>&nbsp;</td>
										</tr>
                                    </table>
									<table width="100%" border="0">
										<tr>
										    <td width="20%" ><div align="top"><strong>Vive con sus Padres</strong>:</div></td>
										  <td width="10%" align="left"><%=f_mis_datos.Obtenervalor("vive_con_padres")%></td>
									      <td width="10%" ><strong>Con Cual</strong>:</td>
										  <td width="60%" align="left"><%=f_mis_datos.Obtenervalor("cual_padre_vive")%></td>
										</tr>
									</table>
									<br>
									<table width="100%">
										<tr>
                                        <td width="13%"><div align="top"><strong>Enfermedad:</strong></div></td>
                                        <td width="17%" align="left"><%=f_mis_datos.Obtenervalor("tenfer_tdesc")%></td>
                                        <td width="25%" ><div align="top"><strong>Otro Tipo de Enfermedad: </strong></div></td>
                                        <td width="45%" align="left"><%=f_mis_datos.Obtenervalor("tenfer_otro")%></td>
                                      </tr>
									</table>
									<br>
									<%if parentesco_codeudor<>"1" and parentesco_codeudor<>"2" then%>
									<p /><strong>DATOS CODEUDOR </strong>
									<table width="100%">
										<tr>
											<td width="100%">
												<table width="100%">
													 <tr>
														<td width="15%"><strong>Rut</strong></td>
														<td width="85%"><strong>Parentesco</strong></td>
													 </tr>
													 <tr>
														<td><%=f_mis_datos_codeudor.Obtenervalor("rut")%></td>
														<td><%=f_mis_datos_codeudor.Obtenervalor("parentesco")%></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td width="100%">
												<table width="100%">
													<tr>
														<td><strong>Nombre</strong></td>
													</tr>
													<tr>
														<td><%=f_mis_datos_codeudor.Obtenervalor("nombre")%></td>
													</tr>
												 </table>
											</td>
										</tr>
										<tr>
											<td>
												<table width="100%">
													<tr>
														<td width="22%"><strong>País</strong></td>
														<td width="30%" ><strong>Región</strong></td>
														<td width="48%" ><strong>Ciudad</strong></td>
													</tr>
													<tr>
														<td><%=f_mis_datos_codeudor.Obtenervalor("pais")%></td>
														<td><%=f_mis_datos_codeudor.Obtenervalor("region")%></td>
														<td><%=f_mis_datos_codeudor.Obtenervalor("ciudad")%></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td>
												<table width="100%">
													<tr>
														<td width="22%"><strong>Dirección</strong></td>
													</tr>
													<tr>
														<td><%=f_mis_datos_codeudor.Obtenervalor("direccion")%></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td>
												<table width="100%">
													<tr>
														<td width="22%"><strong>Email</strong></td>
													</tr>
													<tr>
														<td><%=f_mis_datos_codeudor.Obtenervalor("email")%></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td>
												<table width="100%">
													<tr>
														<td width="22%"><strong>Estado Civil</strong></td>
													</tr>
													<tr>
														<td><%=f_mis_datos_codeudor.Obtenervalor("estado_civil")%></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td>
												<table width="100%">
													<tr>
														<td width="22%" ><strong>Cargo u Ocupación</strong></td>
														<td width="56%" ><strong>Empresa o Institución</strong></td>
													</tr>
													<tr>
														<td><%=f_mis_datos_codeudor.Obtenervalor("cargo")%></td>
														<td><%=f_mis_datos_codeudor.Obtenervalor("empresa")%></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td>
												<table width="100%">
													<tr>
														<td width="22%" ><strong>Nivel Educacional</strong></td>
													</tr>
													<tr>
														<td><%=f_mis_datos_codeudor.Obtenervalor("nied_ccod")%></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td>
												<table width="100%">
													<tr>
														<td width="22%" ><strong>Situación Ocupacional</strong></td>
													</tr>
													<tr>
														<td><%=f_mis_datos_codeudor.Obtenervalor("sicupadre_ccod")%></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td>
												<table width="100%">
													<tr>
														<td width="22%" ><strong>Tipo de Organismo o Empresa que Trabaja o Trabajó</strong></td>
													</tr>
													<tr>
														<td><%=f_mis_datos_codeudor.Obtenervalor("topa_ccod")%></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td>
												<table width="100%">
													<tr>
														<td width="22%" ><strong>Ocupación Principal</strong></td>
													</tr>
													<tr>
														<td><%=f_mis_datos_codeudor.Obtenervalor("sitocup_ccod")%></td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
									<%end if%>
									<br>
									<p /><strong>N° DE PERSONAS QUE ESTUDIAN EN LA CASA</strong>
									<table width="100%" border="1">
										<tr>
										  <td width="16%" ><div align="center"><strong>pre-basica</strong></div></td>
										  <td width="16%" ><div align="center"><strong>basica</strong></div></td>	
											<td width="16%" ><div align="center"><strong>Media 1 a 3</strong></div></td>
											<td width="16%" ><div align="center"><strong>Media 4 </strong></div></td>
											<td width="16%" ><div align="center"><strong>Superior</strong></div></td>
											<td width="16%" ><div align="center"><strong>Otra</strong></div></td>
										</tr>
										<tr>
											<td align="center"><%=f_mis_datos.Obtenervalor("pre_basica")%></td>
											<td align="center"><%=f_mis_datos.Obtenervalor("basica")%></td>
											<td align="center"><%=f_mis_datos.Obtenervalor("media_1_3")%></td>
											<td align="center"><%=f_mis_datos.Obtenervalor("media_4")%></td>
											<td align="center"><%=f_mis_datos.Obtenervalor("superior")%></td>
											<td align="center"><%=f_mis_datos.Obtenervalor("otra")%></td>
										</tr>
									</table>
									<%if existen_parientes="S" then%>
									<br>
									<p /><strong>GRUPO FAMILIAR</strong>
									<table width="100%" border="1">
										<tr>
										 	<td align="center"><strong>Parentesco</strong></td>
											<td align="center"><strong>Nombre</strong></td>
											<td align="center"><strong>Edad</strong></td>
											<td align="center"><strong>Cargo u Ocupación</strong></td>
											<td align="center"><strong>Empresa o Institución</strong></td>
										</tr>
										 <%  while f_mis_datos_parientes.Siguiente %>
										<tr>
											<td align="center"><%=f_mis_datos_parientes.Obtenervalor("parentesco")%></td>
											<td align="center"><%=f_mis_datos_parientes.Obtenervalor("nombre")%></td>
											<td align="center"><%=f_mis_datos_parientes.Obtenervalor("edad")%></td>
											<td align="center"><%=f_mis_datos_parientes.Obtenervalor("cargo")%></td>
											<td align="center"><%=f_mis_datos_parientes.Obtenervalor("empresa")%></td>
										</tr>
										<%wend%>
									</table>
									<%end if%>
									<br>
									<p /><strong>DATOS PAP&Aacute;</strong>
									<table width="100%">
										<tr>
											<td width="100%">
												<table width="100%">
													 <tr>
														<td width="15%"><strong>Rut</strong></td>
														<td width="85%"><strong>¿Esta Vivo?</strong></td>
													 </tr>
													 <tr>
														<td><%=f_mis_datos_papa.Obtenervalor("rut")%></td>
														<td>&nbsp;&nbsp;&nbsp;<%=f_mis_datos_papa.Obtenervalor("vivo")%></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td width="100%">
												<table width="100%">
													<tr>
														<td><strong>Nombre</strong></td>
													</tr>
													<tr>
														<td><%=f_mis_datos_papa.Obtenervalor("nombre")%></td>
													</tr>
												 </table>
											</td>
										</tr>
										<tr>
											<td>
												<table width="100%">
													<tr>
														<td width="22%"><strong>País</strong></td>
														<td width="30%" ><strong>Región</strong></td>
														<td width="48%" ><strong>Ciudad</strong></td>
													</tr>
													<tr>
														<td><%=f_mis_datos_papa.Obtenervalor("pais")%></td>
														<td><%=f_mis_datos_papa.Obtenervalor("region")%></td>
														<td><%=f_mis_datos_papa.Obtenervalor("ciudad")%></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td>
												<table width="100%">
													<tr>
														<td width="22%"><strong>Dirección</strong></td>
													</tr>
													<tr>
														<td><%=f_mis_datos_papa.Obtenervalor("direccion")%></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td>
												<table width="100%">
													<tr>
														<td width="22%"><strong>Email</strong></td>
													</tr>
													<tr>
														<td><%=f_mis_datos_papa.Obtenervalor("email")%></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td>
												<table width="100%">
													<tr>
														<td width="22%"><strong>Estado Civil</strong></td>
													</tr>
													<tr>
														<td><%=f_mis_datos_papa.Obtenervalor("estado_civil")%></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td>
												<table width="100%">
													<tr>
														<td width="22%" ><strong>Cargo u Ocupación</strong></td>
														<td width="56%" ><strong>Empresa o Institución</strong></td>
													</tr>
													<tr>
														<td><%=f_mis_datos_papa.Obtenervalor("cargo")%></td>
														<td><%=f_mis_datos_papa.Obtenervalor("empresa")%></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td>
												<table width="100%">
													<tr>
														<td width="22%" ><strong>Nivel Educacional</strong></td>
													</tr>
													<tr>
														<td><%=f_mis_datos_papa.Obtenervalor("nied_ccod")%></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td>
												<table width="100%">
													<tr>
														<td width="22%" ><strong>Situación Ocupacional</strong></td>
													</tr>
													<tr>
														<td><%=f_mis_datos_papa.Obtenervalor("sicupadre_ccod")%></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td>
												<table width="100%">
													<tr>
														<td width="22%" ><strong>Tipo de Organismo o Empresa que Trabaja o Trabajó</strong></td>
													</tr>
													<tr>
														<td><%=f_mis_datos_papa.Obtenervalor("topa_ccod")%></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td>
												<table width="100%">
													<tr>
														<td width="22%" ><strong>Ocupación Principal</strong></td>
													</tr>
													<tr>
														<td><%=f_mis_datos_papa.Obtenervalor("sitocup_ccod")%></td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
									<br>
									<p /><strong>DATOS MAM&Aacute;</strong>
									<table width="100%">
										<tr>
											<td width="100%">
												<table width="100%">
													 <tr>
														<td width="15%"><strong>Rut</strong></td>
														<td width="85%"><strong>¿Esta Vivo?</strong></td>
													 </tr>
													 <tr>
														<td><%=f_mis_datos_mama.Obtenervalor("rut")%></td>
														<td>&nbsp;&nbsp;&nbsp;<%=f_mis_datos_papa.Obtenervalor("vivo")%></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td width="100%">
												<table width="100%">
													<tr>
														<td><strong>Nombre</strong></td>
													</tr>
													<tr>
														<td><%=f_mis_datos_mama.Obtenervalor("nombre")%></td>
													</tr>
												 </table>
											</td>
										</tr>
										<tr>
											<td>
												<table width="100%">
													<tr>
														<td width="22%"><strong>País</strong></td>
														<td width="28%" ><strong>Región</strong></td>
														<td width="50%" ><strong>Ciudad</strong></td>
													</tr>
													<tr>
														<td><%=f_mis_datos_mama.Obtenervalor("pais")%></td>
														<td><%=f_mis_datos_mama.Obtenervalor("region")%></td>
														<td><%=f_mis_datos_mama.Obtenervalor("ciudad")%></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td>
												<table width="100%">
													<tr>
														<td width="22%"><strong>Dirección</strong></td>
													</tr>
													<tr>
														<td><%=f_mis_datos_mama.Obtenervalor("direccion")%></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td>
												<table width="100%">
													<tr>
														<td width="22%"><strong>Email</strong></td>
													</tr>
													<tr>
														<td><%=f_mis_datos_mama.Obtenervalor("email")%></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td>
												<table width="100%">
													<tr>
														<td width="22%"><strong>Estado Civil</strong></td>
													</tr>
													<tr>
														<td><%=f_mis_datos_mama.Obtenervalor("estado_civil")%></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td>
												<table width="100%">
													<tr>
														<td width="22%" ><strong>Cargo u Ocupación</strong></td>
														<td width="56%" ><strong>Empresa o Institución</strong></td>
													</tr>
													<tr>
														<td><%=f_mis_datos_mama.Obtenervalor("cargo")%></td>
														<td><%=f_mis_datos_mama.Obtenervalor("empresa")%></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td>
												<table width="100%">
													<tr>
														<td width="22%" ><strong>Nivel Educacional</strong></td>
													</tr>
													<tr>
														<td><%=f_mis_datos_mama.Obtenervalor("nied_ccod")%></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td>
												<table width="100%">
													<tr>
														<td width="22%" ><strong>Situación Ocupacional</strong></td>
													</tr>
													<tr>
														<td><%=f_mis_datos_mama.Obtenervalor("sicupadre_ccod")%></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td>
												<table width="100%">
													<tr>
														<td width="22%" ><strong>Tipo de Organismo o Empresa que Trabaja o Trabajó</strong></td>
													</tr>
													<tr>
														<td><%=f_mis_datos_mama.Obtenervalor("topa_ccod")%></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td>
												<table width="100%">
													<tr>
														<td width="22%" ><strong>Ocupación Principal</strong></td>
													</tr>
													<tr>
														<td><%=f_mis_datos_mama.Obtenervalor("sitocup_ccod")%></td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
							  </td>
                        </tr>
                      </table>
					  
                      <br>
                     </td>
                  </tr>
                </table>
                          <br>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="5%">
			<table width="100%" height="28" align="center"  border="0" cellpadding="0" cellspacing="0">
				    <tr>
						  <td width="31%" height="20" align="center">
							<table width="25%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
								   
											 
								    <td><div align="center"><%f_botonera.AgregaBotonParam "salir", "url", "mis_datos.asp?b[0][peri_ccod]="&q_peri_ccod
															f_botonera.DibujaBoton("salir")%></div></td>
								</tr>
							</table>
						 </td>
						<td width="100%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
					</tr>
					  <tr>
						<td height="100%" background="../imagenes/abajo_r2_c2.gif"></td>
					  </tr>
			</table>
		</td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>	</td>
  </tr>  
</table>
</body>
</html>