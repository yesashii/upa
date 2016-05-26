<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
tipo = request.querystring("tipo")
anos_ccod = request.querystring("anos_ccod")
sede_ccod = request.querystring("sede_ccod")
carr_ccod = request.querystring("carr_ccod")
jorn_ccod = request.querystring("jorn_ccod")
nuevo = request.querystring("nuevo")

set pagina = new CPagina

if tipo = "14" then
   pagina.Titulo = "Listado de alumnos con Causal de Abandono" 
elseif tipo = "3" then
   pagina.Titulo = "Listado de alumnos con Causal de Retiro" 
elseif tipo = "5" then
   pagina.Titulo = "Listado de alumnos con Causal de Eliminación" 
elseif tipo = "6" then
   pagina.Titulo = "Listado de alumnos con Causal de Cambio de Carrera"    
elseif tipo = "PT" then
   pagina.Titulo = "Listado de alumnos titulados de la Carrera"     
elseif tipo = "TO" then
   pagina.Titulo = "Listado de alumnos titulados oportunamente"        
end if
'---------------------------------------------------------------------------------------------------
'----------------------------------------------------------	
set conectar = new cconexion
conectar.inicializar "upacifico"

sede_tdesc = conectar.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede_ccod&"'")
carr_tdesc = conectar.consultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar)='"&carr_ccod&"'")
jorn_tdesc = conectar.consultaUno("select jorn_tdesc from jornadas where cast(jorn_ccod as varchar)='"&jorn_ccod&"'")
if tipo <> "PT" and tipo <> "TO" then
	if nuevo ="S" then
		consulta =      " select cast(pers_nrut as varchar)+'-'+pers_xdv as rut, "& vbCrLf &_
						" pers_tnombre as nombres, pers_tape_paterno + ' ' + pers_tape_materno as apellidos, "& vbCrLf &_
						" protic.ano_ingreso_carrera(a.pers_ncorr,'"&carr_ccod&"') as ano_ingreso "& vbCrLf &_
						" from personas a,"& vbCrLf &_
						" ("& vbCrLf &_
						"        select distinct aa.pers_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd  "& vbCrLf &_
						"		 where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod  "& vbCrLf &_
						"		 and cast(cc.anos_ccod as varchar) = '"&anos_ccod&"' and cast(bb.sede_ccod as varchar)='"&sede_ccod&"' and cast(bb.jorn_ccod as varchar)= '"&jorn_ccod&"'"& vbCrLf &_
						"		 and dd.carr_ccod='"&carr_ccod&"' and cast(aa.emat_ccod as varchar)= '"&tipo&"'  "& vbCrLf &_
						"		 and exists (select 1 from alumnos aaa, ofertas_academicas bbb, periodos_academicos ccc, especialidades ddd  "& vbCrLf &_
						"					 where aaa.pers_ncorr=aa.pers_ncorr and aaa.ofer_ncorr=bbb.ofer_ncorr and bbb.peri_ccod=ccc.peri_ccod  "& vbCrLf &_
						"					 and bbb.espe_ccod=ddd.espe_ccod and ccc.anos_ccod = cc.anos_ccod and bbb.sede_ccod=bb.sede_ccod  "& vbCrLf &_
						"					 and bbb.jorn_ccod=bb.jorn_ccod and ddd.carr_ccod=dd.carr_ccod and bbb.post_bnuevo='S' and isnull(aaa.talu_ccod,1) <> 3 )  "& vbCrLf &_
						"		 and exists (select 1 from contratos cont1, compromisos comp1   "& vbCrLf &_
						"									 where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr  "& vbCrLf &_
						"									 and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2)) "& vbCrLf &_
						" union    "& vbCrLf &_
						"		 select distinct aa.pers_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd  "& vbCrLf &_
						"		 where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod  "& vbCrLf &_
						"		 and cast(cc.anos_ccod as varchar)= '"&anos_ccod&"' and cast(bb.sede_ccod as varchar)='"&sede_ccod&"' and cast(bb.jorn_ccod as varchar)='"&jorn_ccod&"'  "& vbCrLf &_
						"		 and dd.carr_ccod='"&carr_ccod&"' and cast(aa.emat_ccod as varchar)= '"&tipo&"' and cc.plec_ccod <> 1  "& vbCrLf &_
						"		 and exists (select 1 from alumnos aaa, ofertas_academicas bbb, periodos_academicos ccc, especialidades ddd   "& vbCrLf &_
						"					 where aaa.pers_ncorr=aa.pers_ncorr and aaa.ofer_ncorr=bbb.ofer_ncorr and bbb.peri_ccod=ccc.peri_ccod  "& vbCrLf &_
						"					 and bbb.espe_ccod=ddd.espe_ccod and ccc.anos_ccod = cc.anos_ccod and bbb.sede_ccod=bb.sede_ccod  "& vbCrLf &_
						"					 and bbb.jorn_ccod=bb.jorn_ccod and ddd.carr_ccod=dd.carr_ccod and bbb.post_bnuevo='S' and isnull(aaa.talu_ccod,1) <> 3 )  "& vbCrLf &_
						"		 and not exists (select 1 from contratos cont1, compromisos comp1   "& vbCrLf &_
						"									 where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr  "& vbCrLf &_
						"									 and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2)) "& vbCrLf &_
						" union "& vbCrLf &_
						" select aa.pers_ncorr,bb.peri_Ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd "& vbCrLf &_
						" where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
						" and cc.anos_ccod = (cast('"&anos_ccod&"' as numeric) + 1) and cast(bb.sede_ccod as varchar)='"&sede_ccod&"' and cast(bb.jorn_ccod as varchar)='"&jorn_ccod&"' "& vbCrLf &_
						" and dd.carr_ccod='"&carr_ccod&"' and cast(aa.emat_ccod as varchar)= '"&tipo&"' and cc.plec_ccod=1 and aa.alum_nmatricula = '7777' "& vbCrLf &_
						" and exists (select 1 from alumnos aaa, ofertas_academicas bbb, periodos_academicos ccc, especialidades ddd "& vbCrLf &_
						"             where aaa.pers_ncorr=aa.pers_ncorr and aaa.ofer_ncorr=bbb.ofer_ncorr and bbb.peri_ccod=ccc.peri_ccod "& vbCrLf &_
						"             and bbb.espe_ccod=ddd.espe_ccod and ccc.anos_ccod = (cc.anos_ccod - 1) and bbb.sede_ccod=bb.sede_ccod "& vbCrLf &_
						"             and bbb.jorn_ccod=bb.jorn_ccod and ddd.carr_ccod=dd.carr_ccod and bbb.post_bnuevo='S' and isnull(aaa.talu_ccod,1) <> 3 ) " & vbCrLf &_
						" ) tablilla " & vbCrLf &_
						" where a.pers_ncorr = tablilla.pers_ncorr "& vbCrLf &_
						" and not exists ( select 1 from alumnos aa, ofertas_academicas bb,especialidades dd "& vbCrLf &_
						"                           where aa.pers_ncorr=tablilla.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr "& vbCrLf &_
						"						    and bb.peri_ccod > tablilla.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
						"						    and cast(bb.sede_ccod as varchar)='"&sede_ccod&"' and cast(bb.jorn_ccod as varchar)='"&jorn_ccod&"' and dd.carr_ccod='"&carr_ccod&"' "& vbCrLf &_
						"                           and aa.emat_ccod = 1) "
	
	else
		consulta =      "  select cast(pers_nrut as varchar)+'-'+pers_xdv as rut, "& vbCrLf &_
						" pers_tnombre as nombres, pers_tape_paterno + ' ' + pers_tape_materno as apellidos, "& vbCrLf &_
						" protic.ano_ingreso_carrera(a.pers_ncorr,'"&carr_ccod&"') as ano_ingreso "& vbCrLf &_
						" from personas a,"& vbCrLf &_
						" ( "& vbCrLf &_
						" select distinct aa.pers_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd "& vbCrLf &_
						" where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
						" and cast(cc.anos_ccod as varchar)= '"&anos_ccod&"' and cast(bb.sede_ccod as varchar) ='"&sede_ccod&"' and cast(bb.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
						" and dd.carr_ccod='"&carr_ccod&"' and cast(aa.emat_ccod as varchar)= '"&tipo&"'  and isnull(aa.talu_ccod,1) <> 3 "& vbCrLf &_
						" and exists (select 1 from contratos cont1, compromisos comp1  "& vbCrLf &_
						"             where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr "& vbCrLf &_
						"             and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2)) "& vbCrLf &_
						" union "& vbCrLf &_
						" select distinct aa.pers_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd "& vbCrLf &_
						" where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
						" and cast(cc.anos_ccod as varchar) = '"&anos_ccod&"' and cast(bb.sede_ccod as varchar)='"&sede_ccod&"' and cast(bb.jorn_ccod as varchar) = '"&jorn_ccod&"'"& vbCrLf &_
						" and dd.carr_ccod='"&carr_ccod&"' and cast(aa.emat_ccod as varchar)= '"&tipo&"' and cc.plec_ccod <> 1  and isnull(aa.talu_ccod,1) <> 3"& vbCrLf &_
						" and not exists (select 1 from contratos cont1, compromisos comp1  "& vbCrLf &_
						"                 where aa.post_ncorr=cont1.post_ncorr and aa.matr_ncorr=cont1.matr_ncorr "& vbCrLf &_
						"                 and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2)) "& vbCrLf &_
						" union "& vbCrLf &_
						" select distinct aa.pers_ncorr,bb.peri_ccod from alumnos aa, ofertas_academicas bb, periodos_academicos cc, especialidades dd "& vbCrLf &_
						" where aa.ofer_ncorr=bb.ofer_ncorr and bb.peri_ccod=cc.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
						" and cc.anos_ccod = (cast('"&anos_ccod&"' as numeric) + 1) and cast(bb.sede_ccod as varchar)='"&sede_ccod&"' and cast(bb.jorn_ccod as varchar)='"&jorn_ccod&"' "& vbCrLf &_
						" and dd.carr_ccod='"&carr_ccod&"' and cast(aa.emat_ccod as varchar)= '"&tipo&"' and cc.plec_ccod=1 and aa.alum_nmatricula = '7777'   and isnull(aa.talu_ccod,1) <> 3"& vbCrLf &_
						" ) tablilla " & vbCrLf &_
						" where a.pers_ncorr = tablilla.pers_ncorr "& vbCrLf &_
						" and not exists ( select 1 from alumnos aa, ofertas_academicas bb,especialidades dd "& vbCrLf &_
						"                           where aa.pers_ncorr=tablilla.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr "& vbCrLf &_
						"						    and bb.peri_ccod > tablilla.peri_ccod and bb.espe_ccod=dd.espe_ccod "& vbCrLf &_
						"						    and cast(bb.sede_ccod as varchar)='"&sede_ccod&"' and cast(bb.jorn_ccod as varchar)='"&jorn_ccod&"' and dd.carr_ccod='"&carr_ccod&"' "& vbCrLf &_
						"                           and aa.emat_ccod = 1) "
						
	
	end if
elseif tipo = "PT" then 
	consulta =          " select distinct cast(pers_nrut as varchar)+'-'+pers_xdv as rut, "& vbCrLf &_
						" pers_tnombre as nombres, pers_tape_paterno + ' ' + pers_tape_materno as apellidos, "& vbCrLf &_
						" protic.ano_ingreso_carrera_egresa2(aa.pers_ncorr,ca.carr_ccod) as ano_ingreso "& vbCrLf &_
	                    " from alumnos aa, ofertas_academicas ba, especialidades ca,personas da "& vbCrLf &_
					    " where aa.ofer_ncorr=ba.ofer_ncorr and ba.espe_ccod=ca.espe_ccod and aa.pers_ncorr= da.pers_ncorr and ca.carr_ccod='"&carr_ccod&"' "& vbCrLf &_
					    " and aa.emat_ccod='8' and protic.ano_ingreso_carrera_egresa2(aa.pers_ncorr,ca.carr_ccod) = '"&anos_ccod&"' "

elseif tipo = "TO" then 
	consulta =          " select distinct cast(pers_nrut as varchar)+'-'+pers_xdv as rut, "& vbCrLf &_
						" pers_tnombre as nombres, pers_tape_paterno + ' ' + pers_tape_materno as apellidos, "& vbCrLf &_
						" protic.ano_ingreso_carrera_egresa2(aa.pers_ncorr,ea.carr_ccod) as ano_ingreso "& vbCrLf &_
	                    " from alumnos aa, ofertas_academicas oa, periodos_academicos pa,especialidades ea, personas pe "& vbCrLf &_
					    " where aa.ofer_ncorr=oa.ofer_ncorr and oa.peri_ccod=pa.peri_ccod  and aa.pers_ncorr=pe.pers_ncorr "& vbCrLf &_
					    " and pa.anos_ccod <= (cast ((espe_nduracion / 2) as numeric) + cast('"&anos_ccod&"' as numeric)) "& vbCrLf &_
					    " and oa.espe_ccod=ea.espe_ccod and ea.carr_ccod='"&carr_ccod&"' and cast(oa.jorn_ccod as varchar)='"&jorn_ccod&"' "& vbCrLf &_
					    " and aa.emat_ccod=8 and protic.ano_ingreso_carrera_egresa2(aa.pers_ncorr,ea.carr_ccod)='"&anos_ccod&"' "

end if 
set formulario = new CFormulario
formulario.carga_parametros "indicadores_alumnos.xml", "listado_alumnos"


'response.Write("<pre>"&consulta&"</pre>")

formulario.inicializar conectar
formulario.Consultar consulta & " order by apellidos, nombres"

cantidad = conectar.consultaUno("select count(*) from ("&consulta&")aaaa")
set negocio = new CNegocio
negocio.Inicializa conectar
'-------------------------------------------------------------------------------
'------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "indicadores_alumnos.xml", "botonera"
'-------------------------------------------------------------------------------
%>
<html>
<head>
<title><%=Pagina.titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function salir()
{ 
  window.close();
}

</script>

</head>
<body bgcolor="#EBEBEB" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="600" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  
  <tr> 
    <td valign="top" bgcolor="#EAEAEA"> <br> <br> <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
                <td align="center"><br>
              <%pagina.DibujarTituloPagina%>
              <br></td>
              </tr>
            </table>
			<form name="litado">
                <table width="100%" border="0">
				  <tr> 
                    <td width="25%"><strong>Año</strong></td>
					<td width="5%"><strong>:</strong></td>
					<td><%=anos_ccod%></td>
                  </tr>
				  <%if tipo <> "PT" then%>
				  <%if tipo <> "TO" then %>
				  <tr> 
                    <td width="25%"><strong>Sede</strong></td>
					<td width="5%"><strong>:</strong></td>
					<td><%=sede_tdesc%></td>
                  </tr>
				  <%end if%>
				  <tr> 
                    <td width="25%"><strong>Carrera</strong></td>
					<td width="5%"><strong>:</strong></td>
					<td><%=carr_tdesc%></td>
                  </tr>
				  <tr> 
                    <td width="25%"><strong>Jornada</strong></td>
					<td width="5%"><strong>:</strong></td>
					<td><%=jorn_tdesc%></td>
                  </tr>
				  <%end if%>
				  <tr> 
                    <td width="25%"><strong>Encontrados</strong></td>
					<td width="5%"><strong>:</strong></td>
					<td><%=cantidad%> Alumno(s)</td>
                  </tr>
				  <tr>
                    <td colspan="3" align="right"><%formulario.AccesoPagina()%></td>
                  </tr>
                  <tr>
                    <td colspan="3" align="center">
						<%pagina.DibujarSubtitulo "Listado de alumnos.-"%><br>
                        <%formulario.dibujaTabla()%>
					<br>
                    </td>
                  </tr>
                </table>
                </form>
			</td>
          <td width="7" background="../imagenes/der.gif">&nbsp;</td>
        </tr>
        <tr> 
          <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
          <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="19%" height="20"><div align="center"> 
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                          <td width="53%"><div align="center">
                            <%botonera.DibujaBoton "salir"%>
                          </div></td>
                      </tr>
                    </table>
                  </div></td>
                <td width="81%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
              </tr>
              <tr> 
                <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
              </tr>
            </table></td>
          <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
        </tr>
      </table>
      <br> </td>
  </tr>
</table>
</body>
</html>
