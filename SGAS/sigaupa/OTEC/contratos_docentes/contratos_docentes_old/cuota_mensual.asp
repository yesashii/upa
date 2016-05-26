<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Contratacion de Docentes"
'----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_peri_ccod = negocio.ObtenerPeriodoAcademico("Planificacion")

'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "couta_mes.xml", "botonera"

'-----------------------------------------------------------------------
v_dcur_ncorr 	= 	Request.QueryString("busqueda[0][dcur_ncorr]")
v_sede_ccod 	= 	Request.QueryString("busqueda[0][sede_ccod]")

'-----------------------------------------------------------------------
'v_dcur_ncorr =21
set formulario = new cformulario
formulario.carga_parametros "contratos_docentes_otec.xml", "filtro_docentes2"
formulario.inicializar conexion 

 
if v_sede_ccod <> "" then
filtro="and sede_ccod="&v_sede_ccod&""
end if

if v_dcur_ncorr = "" then
v_dcur_ncorr=0
end if

consulta="Select rp.pers_ncorr, pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre,cast(pers_nrut as varchar)+'-'+pers_xdv as rut, sede_ccod,dc.dcur_ncorr,dcur_tdesc,"& vbcrlf & _

"cast((select count(distinct bbb.seot_ncorr) from bloques_relatores_otec aaa,bloques_horarios_otec bbb,secciones_otec ccc,datos_generales_secciones_otec ddd,diplomados_cursos eee where aaa.bhot_ccod=bbb.bhot_ccod "& vbcrlf & _
"and bbb.seot_ncorr=ccc.seot_ncorr"& vbcrlf & _
"and ccc.dgso_ncorr=ddd.dgso_ncorr"& vbcrlf & _
"and ddd.dcur_ncorr=eee.dcur_ncorr"& vbcrlf & _
"and eee.dcur_ncorr=dc.dcur_ncorr"& vbcrlf & _
"and aaa.pers_ncorr=p.pers_ncorr"& vbcrlf & _
"and aaa.anot_ncorr is null)as numeric)as  pendientes,"& vbcrlf & _
"(select count(distinct bbb.seot_ncorr) from bloques_relatores_otec aaa,bloques_horarios_otec bbb,secciones_otec ccc,datos_generales_secciones_otec ddd,diplomados_cursos eee"& vbcrlf & _
"where aaa.bhot_ccod=bbb.bhot_ccod"& vbcrlf & _
"and bbb.seot_ncorr=ccc.seot_ncorr"& vbcrlf & _
"and ccc.dgso_ncorr=ddd.dgso_ncorr"& vbcrlf & _
"and ddd.dcur_ncorr=eee.dcur_ncorr"& vbcrlf & _
"and eee.dcur_ncorr=dc.dcur_ncorr"& vbcrlf & _
"and aaa.pers_ncorr=p.pers_ncorr"& vbcrlf & _
"and aaa.anot_ncorr is not null)as anexos_creados,"& vbcrlf & _
"(select count(distinct bbb.seot_ncorr) from bloques_relatores_otec aaa,bloques_horarios_otec bbb,secciones_otec ccc,datos_generales_secciones_otec ddd,diplomados_cursos eee"& vbcrlf & _
"where aaa.bhot_ccod=bbb.bhot_ccod"& vbcrlf & _
"and bbb.seot_ncorr=ccc.seot_ncorr"& vbcrlf & _
"and ccc.dgso_ncorr=ddd.dgso_ncorr"& vbcrlf & _
"and ddd.dcur_ncorr=eee.dcur_ncorr"& vbcrlf & _
"and eee.dcur_ncorr=dc.dcur_ncorr"& vbcrlf & _
"and aaa.pers_ncorr=p.pers_ncorr"& vbcrlf & _
"and aaa.anot_ncorr is not null)as anexos_creadosz"& vbcrlf & _
",+'$ '+cast(tcat_valor as varchar)as valor_categoria,(select cdot_ncorr from contratos_docentes_otec cdo where cdo.pers_ncorr=rp.pers_ncorr and ecdo_ccod=1)as cdot_ncorr ,(select tcdo_ccod from contratos_docentes_otec cdo where cdo.pers_ncorr=rp.pers_ncorr and ecdo_ccod=1)as tcdo_ccod,  "& vbcrlf & _
"(select tcdo_ccod from contratos_docentes_otec cdo where cdo.pers_ncorr=rp.pers_ncorr and ecdo_ccod=1)as z_tcdo_ccod  "& vbcrlf & _
"from relatores_programa rp,diplomados_cursos dc,datos_generales_secciones_otec dgot,personas p,tipos_categoria tc"& vbcrlf & _
"where rp.dgso_ncorr =dgot.dgso_ncorr"& vbcrlf & _
"and dgot.dcur_ncorr=dc.dcur_ncorr"& vbcrlf & _
"and rp.tcat_ccod=tc.tcat_ccod"& vbcrlf & _
" "&filtro& vbCrLf &_
"and dc.dcur_ncorr="&v_dcur_ncorr&""& vbCrLf &_
"and rp.pers_ncorr=p.pers_ncorr"& vbCrLf &_
"order by nombre"  





'"Select rp.pers_ncorr, pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre,cast(pers_nrut as varchar)+'-'+pers_xdv as rut, sede_ccod,dc.dcur_ncorr,dcur_tdesc,"& vbcrlf & _
'"cast((select count(pers_ncorr) from bloques_relatores_otec a where a.pers_ncorr=rp.pers_ncorr and anot_ncorr is null) as numeric)as  pendientes,"& vbcrlf & _
'"(select count(pers_ncorr) from bloques_relatores_otec a where a.pers_ncorr=rp.pers_ncorr and anot_ncorr is not null)as anexos_creados,+'$ '+cast( (select top 1 ceiling((MAOT_NPRESUPUESTO_RELATOR/seot_ncantidad_relator)/maot_nhoras_programa)  from mallas_otec a,secciones_otec b,bloques_relatores_otec bro,bloques_horarios_otec bht where a.maot_ncorr=b.maot_ncorr and b.dgso_ncorr=dgot.dgso_ncorr and a.dcur_ncorr=dc.dcur_ncorr and pers_ncorr=p.pers_ncorr and bro.bhot_ccod=bht.bhot_ccod and bht.seot_ncorr=b.seot_ncorr)as varchar)as valor_categoria,(select cdot_ncorr from contratos_docentes_otec cdo where cdo.pers_ncorr=rp.pers_ncorr and ecdo_ccod=1)as cdot_ncorr ,(select tcdo_ccod from contratos_docentes_otec cdo where cdo.pers_ncorr=rp.pers_ncorr)as tcdo_ccod,  "& vbcrlf & _
'"(select tcdo_ccod from contratos_docentes_otec cdo where cdo.pers_ncorr=rp.pers_ncorr)as z_tcdo_ccod  "& vbcrlf & _
'"from relatores_programa rp,diplomados_cursos dc,datos_generales_secciones_otec dgot,personas p,tipos_categoria tc"& vbcrlf & _
'"where rp.dgso_ncorr =dgot.dgso_ncorr"& vbcrlf & _
'"and dgot.dcur_ncorr=dc.dcur_ncorr"& vbcrlf & _
'"and rp.tcat_ccod=tc.tcat_ccod"& vbcrlf & _
'" "&filtro& vbCrLf &_
'"and dc.dcur_ncorr="&v_dcur_ncorr&""& vbCrLf &_
'"and rp.pers_ncorr=p.pers_ncorr"& vbCrLf &_
'"order by nombre"


'response.Write("<pre>"&consulta&"</pre>")
'response.End()
formulario.consultar consulta


 

set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "couta_mes.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar " select ''"


mes=conexion.ConsultaUno("select datepart(mm,getdate())")
f_busqueda.Siguiente
'response.End()
 f_busqueda.AgregaCampoCons "dcur_ncorr", v_dcur_ncorr
  f_busqueda.AgregaCampoCons "mes_ccod", mes
  
'---------------------------modificaciones nuevos filtros-------------------------------------------------

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
</script>

<style type="text/css">
<!--
body {
	background-color: #D8D8DE;
}
-->
</style></head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">


<table width="650" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
    <td valign="top" bgcolor="#EAEAEA">
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td width="581" height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="10" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td> <table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td align="left"><form name="buscador">
                
<table width="98%"  border="0">
                    <tr>
                      <td width="81%"><table cellspacing=0 cellpadding=0 width="100%" border=0>
                        <tbody>
                          <tr>
                            <td width="88%" height=40 align=middle valign=top colspan="2">
                              <div align="center"><strong><font size="3">Listado
                                    de profesores (valor cuota mensual)</font></strong><br>
                                  Presione bot&oacute;n para generar archivo</div></td>
                            </tr>
                          <tr>
                            <td valign=top align="right"><strong>Selecione Mes :</strong></td>
                             <td><%f_busqueda.DibujaCampo("mes_ccod")%></td>
                          </tr>
                        </tbody>
                      </table>
					  </td>
                      <td width="19%">
					  <table>
						  <tr>
							<td>
							 <div align="center">
							  <!--
							
--><br></div>
							</td>
						  </tr>
						  <tr>
							<td><div align="center">
							<%botonera.AgregaBotonParam "excel", "url", "cuota_mensual_excel.asp"
							  botonera.DibujaBoton "excel"%>
							</div></td>
						  </tr>
					  </table>
					 
					  </td>
                    </tr>
                  </table>
            </form></td>
          </tr>
        </table></td>
        <td width="10" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="10" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	
	
	</table>
</body>
</html>
