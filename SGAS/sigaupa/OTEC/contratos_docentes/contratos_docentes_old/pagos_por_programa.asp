<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
z_dcur_ncorr= request.QueryString("b[0][dcur_ncorr]")
q_dcur_ncorr= request.QueryString("b[0][dcur_ncorr]")
'response.write("<br>z_dcur_ncorr="&z_dcur_ncorr)
if z_dcur_ncorr ="" then
z_dcur_ncorr="0"
end if
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Contratacion de Docentes"

'----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "pagos_por_programa.xml", "botonera"

'-----------------------------------------------------------------------
  set f_select  = new cformulario
f_select.carga_parametros "tabla_vacia.xml", "tabla" 
f_select.inicializar conexion	
sql="select distinct e.dcur_ncorr,dcur_tdesc"& vbCrLf &_
		"from contratos_docentes_otec a,"& vbCrLf &_
		"anexos_otec b,detalle_anexo_otec c,personas d,mallas_otec e,centros_costos_asignados f,"& vbCrLf &_
		"centros_costo g,diplomados_cursos h,tipos_contratos_docentes i,datos_generales_secciones_otec j"& vbCrLf &_
		"where a.cdot_ncorr=b.cdot_ncorr"& vbCrLf &_
		"and b.anot_ncorr=c.anot_ncorr"& vbCrLf &_
		"and a.pers_ncorr=d.pers_ncorr"& vbCrLf &_
		"and ecdo_ccod=1"& vbCrLf &_
		"and eane_ccod=1"& vbCrLf &_
		"and c.mote_ccod=e.mote_ccod"& vbCrLf &_
		"and f.ccos_ccod=g.ccos_ccod"& vbCrLf &_
		"and f.tdet_ccod=h.tdet_ccod"& vbCrLf &_
		"and h.dcur_ncorr=e.dcur_ncorr"& vbCrLf &_
		"and a.tcdo_ccod=i.tcdo_ccod"& vbCrLf &_
		"and e.dcur_ncorr=j.dcur_ncorr"& vbCrLf &_
		"and datepart(yyyy,cdot_finicio)in( datepart(yyyy,getdate()),datepart(yyyy,getdate())-1)"& vbCrLf &_
		"--and convert(datetime,protic.trunc(getdate()),103)between convert(datetime,protic.trunc(anot_finicio),103) and convert(datetime,protic.trunc(anot_ffin),103)"& vbCrLf &_						
		"order by dcur_tdesc"
f_select.consultar sql



  set f_busqueda_  = new cformulario
f_busqueda_.carga_parametros "pagos_por_programa.xml", "busqueda_programa" 
f_busqueda_.inicializar conexion
if q_dcur_ncorr<>"" then


if q_dcur_ncorr <>"0" then
	filtro=filtro&"and e.dcur_ncorr="&z_dcur_ncorr&""
end if

sql_b="select cast(pers_nrut as varchar)+'-'+pers_xdv as rut,pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre ,dcur_tdesc,ccos_tcompuesto,protic.trunc(dgso_finicio)+' al '+protic.trunc(dgso_ftermino)as duracion,"& vbCrLf &_
		"(daot_nhora*daot_mhora)total_pagar,"& vbCrLf &_
		"cast(round(((daot_nhora*daot_mhora)/anot_ncuotas),0)as numeric (18,0))valor_cuota,"& vbCrLf &_
		"anot_ncuotas,"& vbCrLf &_
		"'desde '+protic.trunc(anot_finicio)+' al '+protic.trunc(anot_ffin)as fechas_cuotas"& vbCrLf &_
		"from contratos_docentes_otec a,"& vbCrLf &_
		"anexos_otec b,"& vbCrLf &_
		"detalle_anexo_otec c,"& vbCrLf &_
		"personas d,"& vbCrLf &_
		"mallas_otec e,"& vbCrLf &_
		"centros_costos_asignados f,"& vbCrLf &_
		"centros_costo g,"& vbCrLf &_
		"diplomados_cursos h,"& vbCrLf &_
		"tipos_contratos_docentes i,"& vbCrLf &_
		"datos_generales_secciones_otec j"& vbCrLf &_
		"where a.cdot_ncorr=b.cdot_ncorr"& vbCrLf &_
		"and b.anot_ncorr=c.anot_ncorr"& vbCrLf &_
		"and a.pers_ncorr=d.pers_ncorr"& vbCrLf &_
		"and ecdo_ccod=1"& vbCrLf &_
		"and eane_ccod=1"& vbCrLf &_
		"and c.mote_ccod=e.mote_ccod"& vbCrLf &_
		"and f.ccos_ccod=g.ccos_ccod"& vbCrLf &_
		"and f.tdet_ccod=h.tdet_ccod"& vbCrLf &_
		"and h.dcur_ncorr=e.dcur_ncorr"& vbCrLf &_
		"and a.tcdo_ccod=i.tcdo_ccod"& vbCrLf &_
		"and e.dcur_ncorr=j.dcur_ncorr"& vbCrLf &_
		""&filtro&""& vbCrLf &_
		"and datepart(yyyy,cdot_finicio)in( datepart(yyyy,getdate()),datepart(yyyy,getdate())-1)"& vbCrLf &_
		"--and convert(datetime,protic.trunc(getdate()),103)between convert(datetime,protic.trunc(anot_finicio),103) and convert(datetime,protic.trunc(anot_ffin),103)"& vbCrLf &_
		"order by pers_tape_paterno,pers_tape_materno"
else
sql_b="select ''"
end if	
f_busqueda_.consultar sql_b
'response.Write(sql_b)
'f_busqueda_.Siguiente
'response.Write("<br>"&sql_b)
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

function reseta_selet()
{
valor=<%=z_dcur_ncorr%>
document.buscador.elements["b[0][dcur_ncorr]"].value=valor;
}
</script>

<style type="text/css">
<!--
body {
	background-color: #D8D8DE;
}
-->
</style></head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'),reseta_selet();">


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
                            <td width="88%" height=35 align=middle valign=top colspan="3">
                              <div align="center"><strong><font size="2">Seleccione el programa</font></strong><br>
                                </td>
                            </tr>
                          <tr>
                            <td valign=top align="center">&nbsp;</td>
                             <%
							 comilla=""""
							 response.Write("<td><select name="&comilla&"b[0][dcur_ncorr]"&comilla&">")
							 response.Write("<option value=0>Todos</option>")
							 
							 while f_select.Siguiente
							   response.Write("<option value="&comilla&""&f_select.ObtenerValor("dcur_ncorr")&""&comilla&">"&f_select.ObtenerValor("dcur_tdesc")&"</option>")
							 wend
							   response.Write("</select></td>")
							%>
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
							<%botonera.DibujaBoton "busca"%>
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
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          
        </table></td>
        <td width="10" background="../imagenes/der.gif"></td>
      </tr>
	  
	  <tr align="center">
	  <td width="9" background="../imagenes/izq.gif"></td>
	  <td align="center"><%f_busqueda_.DibujaTabla()%></td>
	  <td width="10" background="../imagenes/der.gif"></td>
	  </tr>
	  <%if q_dcur_ncorr <>"" then %>
	  <tr align="center">
	  <td width="9" background="../imagenes/izq.gif"></td>
	   <td align="left"><%botonera.AgregaBotonParam "excel", "url", "pagos_por_programa_excel.asp?dcur_ncorr="&q_dcur_ncorr&""
	   					botonera.DibujaBoton "excel"%></td>
	  <td width="10" background="../imagenes/der.gif"></td>
	  </tr>
	   <%end if%>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="10" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	
	</table>
</body>
</html>
