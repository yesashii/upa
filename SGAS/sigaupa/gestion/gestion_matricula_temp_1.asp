<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
sede = request.QueryString("sede_ccod")

set pagina = new CPagina
set botonera =  new CFormulario
botonera.carga_parametros "gestion_matricula.xml","botones_rep_matriculados"
pagina.Titulo = "Alumnos Matriculados por Carrera"

set conectar = new cConexion
conectar.inicializar "upacifico"

set negocio = new cnegocio
negocio.inicializa conectar

set f_matriculados = new cformulario
f_matriculados.carga_parametros "gestion_matricula.xml","matriculados_1"
f_matriculados.inicializar conectar

periodo=negocio.ObtenerPeriodoAcademico("CLASES18")
		
consulta2="select aa.sede_ccod,aa.sede_tdesc, aa.espe_ccod, f.carr_tdesc+'-'+e.espe_tdesc as carr_tdesc, " & vbCrLf &_
" cast(isnull(EN_PROCESO_n,0) as integer) as EN_PROCESO_n, " & vbCrLf &_
" cast(isnull(EN_PROCESO_a,0)as integer) as EN_PROCESO_a, " & vbCrLf &_
" cast(isnull(EN_PROCESO_n,0)+isnull(EN_PROCESO_a,0)as integer) as EN_PROCESO_t, " & vbCrLf &_
" cast(isnull(ENVIADOS_n,0)as integer) as ENVIADOS_n," & vbCrLf &_
" cast(isnull(ENVIADOS_a,0)as integer) as ENVIADOS_a," & vbCrLf &_
" cast(isnull(ENVIADOS_n,0)+isnull(ENVIADOS_a,0)as integer) as ENVIADOS_t, " & vbCrLf &_
" cast(isnull(MATRICULADOS_n,0)as integer) as MATRICULADOS_n, " & vbCrLf &_
" cast(isnull(MATRICULADOS_a,0)as integer) as MATRICULADOS_a, " & vbCrLf &_
" cast(isnull(MATRICULADOS_n,0)+isnull(MATRICULADOS_a,0)as integer) as MATRICULADOS_t, " & vbCrLf &_
"	 Case cast(isnull(EN_PROCESO_n,0) as char) When '0' then '-' else '<a href=""gestion_matricula_2.asp?sede_ccod='+cast(aa.sede_ccod as varchar)+'&espe_ccod='+cast(aa.espe_ccod as varchar)+'&epos_ccod=1&nuevo=S"">'+cast(isnull(EN_PROCESO_n,0) as varchar)+'</a>' end as v_EN_PROCESO_n , " & vbCrLf &_
"     Case cast(isnull(EN_PROCESO_a,0)as char) When '0' then '-' else '<a href=""gestion_matricula_2.asp?sede_ccod='+cast(aa.sede_ccod as varchar)+'&espe_ccod='+cast(aa.espe_ccod as varchar)+'&epos_ccod=1&nuevo=N"">'+cast(isnull(EN_PROCESO_a,0) as varchar)+ '</a>' end as v_EN_PROCESO_a," & vbCrLf &_
"	 Case cast(isnull(EN_PROCESO_n,0) + isnull(EN_PROCESO_a,0)as char) When '0' then '-' else '<a href=""gestion_matricula_2.asp?sede_ccod='+cast(aa.sede_ccod as varchar)+'&espe_ccod='+cast(aa.espe_ccod as varchar)+'&epos_ccod=1&nuevo=T"">' + cast(isnull(EN_PROCESO_n,0)+isnull(EN_PROCESO_a,0) as varchar) +'</a>' end as v_EN_PROCESO_t," & vbCrLf &_
"	 Case cast(isnull(ENVIADOS_n,0) as char) When '0' then '-' else '<a href=""gestion_matricula_2.asp?sede_ccod='+cast(aa.sede_ccod as varchar)+'&espe_ccod='+cast(aa.espe_ccod as varchar)+'&epos_ccod=2&nuevo=S"">'+cast(isnull(ENVIADOS_n,0) as varchar)+'</a>' end as v_ENVIADOS_n," & vbCrLf &_
"	 Case cast(isnull(ENVIADOS_a,0) as char) When '0' then '-' else '<a href=""gestion_matricula_2.asp?sede_ccod='+cast(aa.sede_ccod as varchar)+'&espe_ccod='+cast(aa.espe_ccod as varchar)+'&epos_ccod=2&nuevo=N"">'+cast(isnull(ENVIADOS_a,0) as varchar)+'</a>' end as v_ENVIADOS_a," & vbCrLf &_
"	 Case cast(isnull(ENVIADOS_n,0)  + isnull(ENVIADOS_a,0) as char) When '0' then '-' else '<a href=""gestion_matricula_2.asp?sede_ccod=' +cast(aa.sede_ccod as varchar)+'&espe_ccod=' +cast(aa.espe_ccod as varchar)+'&epos_ccod=2&nuevo=T"">'+ cast(isnull(ENVIADOS_n,0)+isnull(ENVIADOS_a,0) as varchar)+'</a>' end as v_ENVIADOS_t," & vbCrLf &_
"	 Case cast(isnull(MATRICULADOS_n,0)as char) When '0' then '-' else '<a href=""gestion_matricula_2.asp?sede_ccod='+cast(aa.sede_ccod as varchar)+'&espe_ccod='+cast(aa.espe_ccod as varchar)+'&emat_ccod=1&nuevo=S"">'+cast(isnull(MATRICULADOS_N,0) as varchar)+'</a>' end as v_MATRICULADOS_n," & vbCrLf &_
"	 Case cast(isnull(MATRICULADOS_a,0)as char) When '0' then '-' else '<a href=""gestion_matricula_2.asp?sede_ccod='+cast(aa.sede_ccod as varchar)+'&espe_ccod='+cast(aa.espe_ccod as varchar)+'&emat_ccod=1&nuevo=N"">'+cast(isnull(MATRICULADOS_a,0) as varchar)+'</a>' end as v_MATRICULADOS_a," & vbCrLf &_
"	 Case cast(isnull(MATRICULADOS_n,0) + isnull(MATRICULADOS_a,0)as char ) When '0' then '-' else '<a href=""gestion_matricula_2.asp?sede_ccod=' +cast(aa.sede_ccod as varchar)+'&espe_ccod='+cast(aa.espe_ccod as varchar)+ '&epos_ccod=2&nuevo=T"">'+cast(isnull(MATRICULADOS_n,0)+isnull(MATRICULADOS_a,0) as varchar)+'</a>' end as v_MATRICULADOS_t " & vbCrLf &_
" from ( select a.sede_ccod,a.sede_tdesc, a.espe_ccod, " & vbCrLf &_
"    SUM(case EPOS_CCOD When 1 then (case nuevo when 'S' then total_pos end )else 0 end) as EN_PROCESO_n, " & vbCrLf &_
"    SUM(case EPOS_CCOD When 1 then (case nuevo when 'N' then total_pos end )else 0 end) as EN_PROCESO_a, " & vbCrLf &_
"    SUM(case EPOS_CCOD When 2 then (case nuevo when 'S' then total_pos end )else 0 end) as ENVIADOS_n, " & vbCrLf &_
"    SUM(case EPOS_CCOD When 2 then (case nuevo when 'N' then total_pos end )else 0 end) as ENVIADOS_a " & vbCrLf &_
" from " & vbCrLf &_
" (select b.sede_ccod,sede_tdesc, d.epos_ccod, e.espe_ccod, protic.es_nuevo_carrera(c.pers_ncorr,e.carr_ccod,a.peri_ccod) as nuevo, count(*) as total_pos " & vbCrLf &_
" from ofertas_academicas a " & vbCrLf &_
" left outer join sedes b " & vbCrLf &_
"    on a.sede_ccod=b.sede_ccod " & vbCrLf &_
" left outer join especialidades e " & vbCrLf &_
"    on a.espe_ccod = e.espe_ccod " & vbCrLf &_
" left outer join postulantes c " & vbCrLf &_
"    on a.ofer_ncorr =c.ofer_ncorr " & vbCrLf &_
" left outer join estados_postulantes d  " & vbCrLf &_
"    on c.epos_ccod = d.epos_ccod " & vbCrLf &_      
" where a.peri_ccod='" & periodo  & "' " & vbCrLf &_
" and a.sede_ccod = '" & sede & "' " & vbCrLf &_
" and c.audi_tusuario not in ('AgregaNota2T','AgregaNota3','AgregaNota37','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46'," & vbCrLf  & _
"                     'AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp'," & vbCrLf  & _
"                     'AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80'," & vbCrLf  & _
"                     'AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99') " & vbCrLf  & _
" group by b.sede_ccod,sede_tdesc, d.epos_ccod, e.espe_ccod, protic.es_nuevo_carrera(c.pers_ncorr,e.carr_ccod,a.peri_ccod)) a " & vbCrLf &_
" GROUP BY a.sede_ccod,a.SEDE_TDESC,a.espe_ccod  " & vbCrLf &_
" )aa "& vbCrLf &_
" left outer join -- segunda tabla del from (B)" & vbCrLf &_
" ( select b.sede_ccod,sede_tdesc, a.espe_ccod, count(*) as MATRICULADOS_n " & vbCrLf &_
" from ofertas_academicas a left outer join sedes b " & vbCrLf &_
"    on a.sede_ccod = b.sede_ccod " & vbCrLf &_
" left outer join alumnos c " & vbCrLf &_
"    on a.ofer_ncorr  = c.ofer_ncorr " & vbCrLf &_
"    and c.emat_ccod=1  " & vbCrLf &_
" left outer join especialidades d " & vbCrLf &_
"    on a.espe_ccod   = d.espe_ccod " & vbCrLf &_
" where a.peri_ccod= '" & periodo  & "' " & vbCrLf &_
" and a.sede_ccod = '" & sede & "' " & vbCrLf &_
" And c.pers_ncorr > 0 " & vbCrLf &_
" and protic.es_nuevo_carrera(c.pers_ncorr,d.carr_ccod,a.peri_ccod) = 'S' " & vbCrLf &_
" and c.audi_tusuario not in ('AgregaNota2T','AgregaNota3','AgregaNota37','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46'," & vbCrLf  & _
"                     'AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp'," & vbCrLf  & _
"                     'AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80'," & vbCrLf  & _
"                     'AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99') " & vbCrLf  & _
" group by b.sede_ccod,sede_tdesc, a.espe_ccod " & vbCrLf &_
" ) B  on aa.espe_ccod=b.espe_ccod " & vbCrLf &_
"  left outer join --Join tabla virtual " & vbCrLf &_
" ( select b.sede_ccod,sede_tdesc,  a.espe_ccod, count(*) as MATRICULADOS_a " & vbCrLf &_
" from ofertas_academicas a left outer join sedes b " & vbCrLf &_
"    on a.sede_ccod=b.sede_ccod  " & vbCrLf &_
" left outer join alumnos c " & vbCrLf &_
"    on a.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
"     and c.emat_ccod=1  " & vbCrLf &_
" left outer join especialidades d " & vbCrLf &_
"    on a.espe_ccod  = d.espe_ccod " & vbCrLf &_
" where a.peri_ccod= '" & periodo  & "' " & vbCrLf &_
" and a.sede_ccod = '" & sede & "' " & vbCrLf &_
" And c.pers_ncorr > 0 " & vbCrLf &_
" and protic.es_nuevo_carrera(c.pers_ncorr,d.carr_ccod,a.peri_ccod) = 'N' " & vbCrLf &_
" and c.audi_tusuario not in ('AgregaNota2T','AgregaNota3','AgregaNota37','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46'," & vbCrLf  & _
"                     'AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp'," & vbCrLf  & _
"                     'AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80'," & vbCrLf  & _
"                     'AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99') " & vbCrLf  & _
" group by b.sede_ccod,sede_tdesc, a.espe_ccod " & vbCrLf &_
" ) BB " & vbCrLf &_
"    on aa.espe_ccod = bb.espe_ccod " & vbCrLf &_
" join especialidades e " & vbCrLf &_
" on aa.espe_ccod = e.espe_ccod  " & vbCrLf &_
" join carreras f on " & vbCrLf &_
" e.carr_ccod = f.carr_ccod"& vbCrLf &_
" order by carr_tdesc"

' response.Write("<br>Hola estoy probando...<pre>"&consulta2&"</pre>")
'response.end()

f_matriculados.Consultar consulta2

f_matriculados.agregaparam "editar",false
'f_matriculados.agregacampocons "v_EN_PROCESO","<a href=""gestion_matricula_2.asp?sede_ccod="&sede&"&amp;espe_ccod=%espe_ccod%&amp;epos_ccod=1"">%EN_PROCESO%</a>"
'f_matriculados.agregacampocons "v_ENVIADOS","<a href=""gestion_matricula_2.asp?sede_ccod="&sede&"&amp;espe_ccod=%espe_ccod%&amp;epos_ccod=2"">%ENVIADOS%</a>"
'f_matriculados.agregacampocons "v_MATRICULADOS","<a href=""gestion_matricula_2.asp?sede_ccod="&sede&"&amp;espe_ccod=%espe_ccod%&amp;emat_ccod=1"">%MATRICULADOS%</a>"
'f_matriculados.Siguiente

'consulta_suma = "select sum(en_proceso) as en_proceso, sum(enviados) as enviados, sum(matriculados) as matriculados from ("&consulta&")"

'set fsuma = new cformulario
'fsuma.carga_parametros "gestion_matricula.xml","tabla"
'fsuma.inicializar conectar
'fsuma.Consultar consulta_suma
'fsuma.siguiente
'suma_enproceso=fsuma.obtenervalor("en_proceso")
'suma_enviados=fsuma.obtenervalor("enviados")
'suma_matriculados=fsuma.obtenervalor("matriculados")

%>


<html>
<head>
<title>Alumnos Matriculados</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
	colores = Array(3);
	colores[0] = '';
	colores[1] = '#97AAC6';
	colores[2] = '#C0C0C0';
</script>

<style type="text/css">
<!--
.Estilo2 {color: #000000}
.Estilo4 {color: #000000; font-weight: bold; }
-->
</style>
</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../__base/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
                <td>
                  <%pagina.DibujarLenguetas Array("Alumnos"), 1 %>
                </td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center">
                    <p align="left">&nbsp; </p>
                    <table width="100%" border="0">
                      <%if RegistrosN>0 then%>
                      <tr> 
                        <td align="center">&nbsp; </td>
                      </tr>
                      <%end if%>
                      <tr> 
                        <td align="center"><strong>
                          <%pagina.DibujarSubtitulo "Gestión Matricula por Carrera"%>
                          </strong></td>
                      </tr>
                    </table>
                    <form name="edicion">
                      <div align="left">
                        <input name="url" type="hidden" value="<%=request.ServerVariables("HTTP_REFERER")%>">
                      </div>
                      <table width="98%" align="center">
                        <tr>
                          <td align="center"> <!--<div align="right">P&aacute;ginas: 
                              <%f_matriculados.AccesoPagina%>
                            </div>--></td>
                        </tr>
                        <tr> 
                          <td align="center">						  <table width="683" border="1" cellpadding="0" cellspacing="0" bordercolor="#FFFFFF" bgcolor="#6581AB">
                            <!--DWLayoutTable-->
                            <tr>
                              <td width="70" rowspan="2" valign="bottom"><span class="tituloTabla"><strong>Sede</strong></span></td>
                              <td width="163" rowspan="2" valign="bottom"><div align="left"><span class="tituloTabla"><strong>Carrera</strong></span></div></td>
                              <td colspan="3" valign="top"><div align="center"><strong><span class="tituloTabla">EN PROCESO </span></strong></div></td>
                              <td colspan="3" valign="top"><div align="center"><strong><span class="tituloTabla">ENVIADOS</span></strong></div></td>
                              <td colspan="3" valign="top"><div align="center"><strong><span class="tituloTabla">MATRICULADOS</span></strong></div></td>
                            </tr>
                            <tr>
                              <td width="47" height="14"><div align="center"><span class="tituloTabla">Nuevos</span></div></td>
                              <td width="48"><div align="center"><span class="tituloTabla">Antiguos</span></div></td>
                              <td width="47"><div align="center"><span class="tituloTabla"><strong>Total</strong></span></div></td>
                              <td width="47"><div align="center"><span class="tituloTabla">Nuevos</span></div></td>
                              <td width="48"><div align="center"><span class="tituloTabla">Antiguos</span></div></td>
                              <td width="47"><div align="center"><span class="tituloTabla"><strong>Total</strong></span></div></td>
                              <td width="47"><div align="center"><span class="tituloTabla">Nuevos</span></div></td>
                              <td width="48"><div align="center"><span class="tituloTabla">Antiguos</span></div></td>
                              <td width="47"><div align="center"><span class="tituloTabla"><strong>Total</strong></span></div></td>
                            </tr>
                            <%'f_matriculados.dibujatabla()
							en_proceso_n_t=0
							en_proceso_a_t=0
							en_proceso_t_t=0
							enviados_n_t=0
							enviados_a_t=0
							enviados_t_t=0
							matriculados_n_t=0
							matriculados_a_t=0
							matriculados_t_t=0
							for nmat = 1 to f_matriculados.nrofilas
								f_matriculados.siguiente
								en_proceso_n_t=en_proceso_n_t+f_matriculados.obtenervalor("en_proceso_n")
								en_proceso_a_t=en_proceso_a_t+f_matriculados.obtenervalor("en_proceso_a")
								en_proceso_t_t=en_proceso_t_t+f_matriculados.obtenervalor("en_proceso_t")
								enviados_n_t=enviados_n_t+f_matriculados.obtenervalor("enviados_n")
								enviados_a_t=enviados_a_t+f_matriculados.obtenervalor("enviados_a")
								enviados_t_t=enviados_t_t+f_matriculados.obtenervalor("enviados_t")
								matriculados_n_t=matriculados_n_t+f_matriculados.obtenervalor("matriculados_n")
								matriculados_a_t=matriculados_a_t+f_matriculados.obtenervalor("matriculados_a")
								matriculados_t_t=matriculados_t_t+f_matriculados.obtenervalor("matriculados_t")
							%>
                            <tr bgcolor="#AEC7E3">
                              <td width="70" onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="left" class="Estilo2"><%=f_matriculados.obtenervalor("sede_tdesc")%></div></td>
                              <td width="163" onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="left" class="Estilo2"><%=f_matriculados.obtenervalor("carr_tdesc")%></div></td>
                              <td width="47" onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="right" class="Estilo2"><%=f_matriculados.obtenervalor("v_en_proceso_n")%></div></td>
                              <td width="48" onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="right" class="Estilo2"><%=f_matriculados.obtenervalor("v_en_proceso_a")%></div></td>
                              <td width="47" bgcolor="#97AAC6" onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="right" class="Estilo2"><%=f_matriculados.obtenervalor("v_en_proceso_t")%></div></td>
                              <td width="47" onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="right" class="Estilo2"><%=f_matriculados.obtenervalor("v_enviados_n")%></div></td>
                              <td width="48" onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="right" class="Estilo2"><%=f_matriculados.obtenervalor("v_enviados_a")%></div></td>
                              <td width="47" bgcolor="#97AAC6" onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="right" class="Estilo2"><%=f_matriculados.obtenervalor("v_enviados_t")%></div></td>
                              <td width="47" onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="right" class="Estilo2"><%=f_matriculados.obtenervalor("v_matriculados_n")%></div></td>
                              <td width="48" onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="right" class="Estilo2"><%=f_matriculados.obtenervalor("v_matriculados_a")%></div></td>
                              <td width="47" bgcolor="#97AAC6" onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="right" class="Estilo2"><%=f_matriculados.obtenervalor("v_matriculados_t")%></div></td>
                            </tr>
                            <%
							next							
							%>
                            <tr bgcolor="#AEC7E3">
                              <td colspan="2"><div align="right"><span class="Estilo2"><strong>Total</strong></span></div></td>                              
                              <td width="47" height="14"><div align="center" class="Estilo4">
                                  <div align="right"><%=en_proceso_n_t%></div>
                              </div></td>
                              <td width="48"><div align="center" class="Estilo4">
                                  <div align="right"><%=en_proceso_a_t%></div>
                              </div></td>
                              <td bgcolor="#97AAC6" width="47"><div align="center" class="Estilo4">
                                  <div align="right"><%=en_proceso_t_t%></div>
                              </div></td>
                              <td width="47"><div align="center" class="Estilo4">
                                  <div align="right"><%=enviados_n_t%></div>
                              </div></td>
                              <td width="48"><div align="center" class="Estilo4">
                                  <div align="right"><%=enviados_a_t%></div>
                              </div></td>
                              <td bgcolor="#97AAC6" width="47"><div align="center" class="Estilo4">
                                  <div align="right"><%=enviados_t_t%></div>
                              </div></td>
                              <td width="47"><div align="center" class="Estilo4">
                                  <div align="right"><%=matriculados_n_t%></div>
                              </div></td>
                              <td width="48"><div align="center" class="Estilo4">
                                  <div align="right"><%=matriculados_a_t%></div>
                              </div></td>
                              <td bgcolor="#97AAC6" width="47"><div align="center" class="Estilo4">
                                  <div align="right"><%=matriculados_t_t%></div>
                              </div></td>
                            </tr>
                          </table></td>
                        </tr>
                      </table>
                    </form>
                    <br>
                    <br>
                  </div>
                </td>
              </tr>
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
                  <td width="33%"><div align="center">
                            <% 
							botonera.agregabotonparam "anterior","url","gestion_matricula.asp"
							botonera.dibujaboton("anterior") %>
                          </div></td>
                  <td width="33%"></td>
                  <td width="34%"><div align="center">
                            <% botonera.dibujaboton("cancelar") %>
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
