<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each x in request.Form
'	response.Write("<br>"&x&" -> "&request.Form(x))
'next

f_dcur_ncorr=Request.form("b[0]dcur_ncorr")
'f_dcur_ncorr=98
'response.Write("</br>f_dcur_ncorr "&f_dcur_ncorr)
'response.Write("</br>f_pers_ncorr_relator "&f_pers_ncorr_relator)
'response.Write("</br>seot_ncorr "&seot_ncorr)
'response.Write("</br>mote_ccod "&mote_ccod)
'response.End()
'--------------------------------------------------

set conectar	=	new cconexion
conectar.inicializar "upacifico"
set negocio		=	new cnegocio
negocio.inicializa conectar

set pagina = new CPagina
pagina.Titulo = "Administra Encuesta"


'--------------------------------------------------
set botonera = new CFormulario
botonera.carga_parametros "administra_encuesta.xml", "botonera"


set f_busqueda	=	new cformulario
f_busqueda.inicializar		conectar
f_busqueda.carga_parametros	"tabla_vacia.xml", "tabla" 

consulta="select 1 as npre,'Este curso ha aumentado mi interés por la materia.'as pregunta, cast(round(avg(enpo_I_1),2)as decimal(8,2))as promedio"& vbCrLf &_
"from encu_programa_otec vv"& vbCrLf &_
"where  vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select  2 as npre,'Este curso ha sido una herramienta de gran utilidad para mi desarrollo profesional 'as pregunta, cast(round(avg(enpo_I_2),2)as decimal(8,2))as promedio"& vbCrLf &_
"from encu_programa_otec vv"& vbCrLf &_
"where  vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 3 as npre,'Se cumplieron en gran medida mis expectativas respecto al programa y la universidad.'as pregunta, cast(round(avg(enpo_I_3),2)as decimal(8,2))as promedio"& vbCrLf &_
"from encu_programa_otec vv"& vbCrLf &_
"where  vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 4 as npre,'El curso ha sido muy valioso para mi desempeño laboral.'as pregunta, cast(round(avg(enpo_I_4),2)as decimal(8,2))as promedio"& vbCrLf &_
"from encu_programa_otec vv"& vbCrLf &_
"where  vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select  5 as npre,'Los objetivos definidos se cumplieron.'as pregunta, cast(round(avg(enpo_I_5),2)as decimal(8,2))as promedio"& vbCrLf &_
"from encu_programa_otec vv"& vbCrLf &_
"where  vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 6 as npre,'Los contenidos son actuales y adecuados al programa.'as pregunta, cast(round(avg(enpo_I_6),2)as decimal(8,2))as promedio"& vbCrLf &_
"from encu_programa_otec vv"& vbCrLf &_
"where  vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 7 as npre,'La Bibliografía utilizada es actualizada.'as pregunta, cast(round(avg(enpo_I_7),2)as decimal(8,2))as promedio"& vbCrLf &_
"from encu_programa_otec vv"& vbCrLf &_
"where  vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"order by npre"



'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_busqueda.consultar	consulta
'f_busqueda.Siguiente



set f_busqueda_II	=	new cformulario
f_busqueda_II.inicializar		conectar
f_busqueda_II.carga_parametros	"administra_encuesta.xml", "segunda_part" 

consul="select 1 as npre,'El curso contó con los medios audiovisuales requeridos.'as pregunta, (select count(enpo_II_1) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_1=1 )as s,"& vbCrLf &_
" (select count(enpo_II_1) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_1=2 )as av,"& vbCrLf &_
" (select count(enpo_II_1) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_1=3 )as n,"& vbCrLf &_
"  (select count(enpo_II_2) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_2=0 )as na"& vbCrLf &_
"from encu_programa_otec vv"& vbCrLf &_
"where vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select  2 as npre,'Existe una plataforma virtual de apoyo amigable.'as pregunta,  (select count(enpo_II_2) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_2=1 )as s,"& vbCrLf &_
" (select count(enpo_II_2) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_2=2 )as av,"& vbCrLf &_
" (select count(enpo_II_2) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_2=3 )as n,"& vbCrLf &_
"   (select count(enpo_II_2) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_2=0 )as na"& vbCrLf &_
"from encu_programa_otec vv"& vbCrLf &_
"where vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 3 as npre,'La Sala en que se impartió el curso era confortable.'as pregunta,  (select count(enpo_II_3) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_3=1 )as s,"& vbCrLf &_
 "(select count(enpo_II_3) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_3=2 )as av,"& vbCrLf &_
" (select count(enpo_II_3) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_3=3 )as n,"& vbCrLf &_
"   (select count(enpo_II_3) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_3=0 )as na"& vbCrLf &_
"from encu_programa_otec vv"& vbCrLf &_
"where vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 4 as npre,'El acceso a la Biblioteca fue adecuado.'as pregunta,  (select count(enpo_II_4) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_4=1 )as s,"& vbCrLf &_
 "(select count(enpo_II_4) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_4=2 )as av,"& vbCrLf &_
" (select count(enpo_II_4) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_4=3 )as n,"& vbCrLf &_
"   (select count(enpo_II_4) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_4=0 )as na"& vbCrLf &_
"from encu_programa_otec vv"& vbCrLf &_
"where vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select  5 as npre,'El número de ejemplares de libros y documentos es óptimo.'as pregunta,  (select count(enpo_II_5) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_5=1 )as s,"& vbCrLf &_
" (select count(enpo_II_5) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_5=2 )as av,"& vbCrLf &_
" (select count(enpo_II_5) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_5=3 )as n,"& vbCrLf &_
"   (select count(enpo_II_5) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_5=0 )as na"& vbCrLf &_
"from encu_programa_otec vv"& vbCrLf &_
"where vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 6 as npre,'El apoyo de la coordinación del Programa fue adecuado.'as pregunta,  (select count(enpo_II_6) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_6=1 )as s,"& vbCrLf &_
" (select count(enpo_II_6) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_6=2 )as av,"& vbCrLf &_
" (select count(enpo_II_6) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_6=3 )as n,"& vbCrLf &_
"   (select count(enpo_II_6) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_6=0 )as na"& vbCrLf &_
"from encu_programa_otec vv"& vbCrLf &_
"where vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 7 as npre,'El servicio de cafetería es de buena calidad.'as pregunta,  (select count(enpo_II_7) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_7=1 )as s,"& vbCrLf &_
" (select count(enpo_II_7) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_7=2 )as av,"& vbCrLf &_
" (select count(enpo_II_7) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_7=3 )as n,"& vbCrLf &_
"   (select count(enpo_II_7) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_7=0 )as na"& vbCrLf &_
"from encu_programa_otec vv"& vbCrLf &_
"where vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"order by npre"

f_busqueda_II.consultar	consul
'response.Write("<pre>"&consul&"</pre>")




dcur_tdesc=conectar.consultaUno("select dcur_tdesc from diplomados_cursos where dcur_ncorr="&f_dcur_ncorr&"")
'-------------------------------------------------------------------------




%>


<html>
<head>
<title>Administrador de Encuesta</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript" type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function salir()
{
	window.close();
}
//-->
</script></head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>		
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="600" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Detalle Encuesta Relatores</font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="600" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
 				  <br>  <br/>
				  
				  <form name="buscador">
				  <input type="hidden"  name="d[0]dcur_ncorr" value="<%=f_dcur_ncorr%>">
				  	<table width="90%" align="center">
						
						<tr >
						  <td align="center"><strong><font size="2">Puntaje Promedio Preguntas </font></strong></td>
						</tr>
						<tr>
						  <td align="center"><strong><font size="2">Programa: <%=dcur_tdesc%></font></strong></td>
						</tr>
						<tr>
						  <td align="center">&nbsp;</td>
						</tr>
						<tr>
							<td align="center">
								
									<strong><font size="1">I.Cómo calificaría usted los siguientes elementos en relación a los CONTENIDOS del Programa</font></strong>
							</td>
						</tr>			
						<tr>
						  <td width="62%" align="center">
						  		<table width="80%" border="1">
									<tr borderColor="#999999"> 
									  <td width="76%" bgColor="#c4d7ff"><div align="center"><strong>Preguntas</strong></div></td>
									  <td width="24%" height="17" bgColor="#c4d7ff"><div align="center"><strong>Ptje Promedio </strong></div></td>
									</tr>
									<%while f_busqueda.Siguiente%>
								  <tr borderColor="#999999"> 
									 <td bgcolor="#FFECC6" ><div align="center"><%=f_busqueda.Obtenervalor("pregunta")%></div></td>
									 <td bgcolor="#FFECC6"><div align="center"><%=f_busqueda.Obtenervalor("promedio")%></div></td>
									 
								  </tr>
							 <%  wend %>	  
								 </table>
								 
						  </td>
						</tr>
						<tr>
							<td align="center">
								
									<strong><font size="1">II. En  relaci&oacute;n a aspectos de INFRAESTRUCTURA</font></strong>
							</td>
						</tr>			
						<tr>
						  <td width="62%" align="center">
						  		<table width="80%" border="1">
									<tr borderColor="#999999"> 
									  <td width="76%" bgColor="#c4d7ff"><div align="center"><strong>Preguntas</strong></div></td>
									  <td width="24%" height="17" bgColor="#c4d7ff"><div align="center"><strong>N° de Si </strong></div></td>
									  <td width="24%" height="17" bgColor="#c4d7ff"><div align="center"><strong>N° de A veces</strong></div></td>
									  <td width="24%" height="17" bgColor="#c4d7ff"><div align="center"><strong>No</strong></div></td>
									  <td width="24%" height="17" bgColor="#c4d7ff"><div align="center"><strong>No Aplica</strong></div></td>
									</tr>
									<%while f_busqueda_II.Siguiente%>
								  <tr borderColor="#999999"> 
									 <td bgcolor="#FFECC6" ><div align="center"><%=f_busqueda_II.Obtenervalor("pregunta")%></div></td>
									 <td bgcolor="#FFECC6"><div align="center"><%=f_busqueda_II.Obtenervalor("s")%></div></td>
									 <td bgcolor="#FFECC6"><div align="center"><%=f_busqueda_II.Obtenervalor("av")%></div></td>
									 <td bgcolor="#FFECC6"><div align="center"><%=f_busqueda_II.Obtenervalor("n")%></div></td>
									 <td bgcolor="#FFECC6"><div align="center"><%=f_busqueda_II.Obtenervalor("na")%></div></td>
								  </tr>
							 		<%wend%>	  
								 </table>
								 
						  </td>
						</tr>
					</table>
				  </form>
				 <br>  
				  <br/>
				 </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="125" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td align="center"><%botonera.AgregaBotonParam "excel_estado", "url", "encuesta_infra_programa_excel.asp?dcur_ncorr="&f_dcur_ncorr&""
					  botonera.DibujaBoton"excel_estado"%></td>
					  <td align="center"><%	botonera.AgregaBotonParam "volver", "url", "opcion_administracion.asp?dcur_ncorr="&f_dcur_ncorr&""
					  						botonera.DibujaBoton"volver"%></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="237" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
		  </td>
        </tr>
      </table>   
	  </td>
  </tr>  
</table>
</body>
</html>
