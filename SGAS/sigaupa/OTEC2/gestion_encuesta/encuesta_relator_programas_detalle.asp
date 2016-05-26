<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each x in request.Form
'	response.Write("<br>"&x&" -> "&request.Form(x))
'next

f_dcur_ncorr=Request.querystring("dcur_ncorr")
f_pers_ncorr_relator=Request.querystring("pers_ncorr_relator")
seot_ncorr=Request.querystring("seot_ncorr")
mote_ccod=Request.querystring("mote_ccod")
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

consulta="select 1 as npre,'El profesor dio a conocer los objetivos del programa'as pregunta, cast(round(avg(enrp_1),2)as decimal(8,2))as promedio"& vbCrLf &_
"from ENCU_RELATOR_OTEC vv"& vbCrLf &_
"where  vv.pers_ncorr_relator="&f_pers_ncorr_relator&""& vbCrLf &_
"and vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"and vv.seot_ncorr="&seot_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select  2 as npre,'El profesor prepara, organiza y estructura bien las clases'as pregunta, cast(round(avg(enrp_2),2)as decimal(8,2))as promedio"& vbCrLf &_
"from ENCU_RELATOR_OTEC vv"& vbCrLf &_
"where  vv.pers_ncorr_relator="&f_pers_ncorr_relator&""& vbCrLf &_
"and vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"and vv.seot_ncorr="&seot_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 3 as npre,'Los contenidos fueron expresados de modo comprensible'as pregunta, cast(round(avg(enrp_3),2)as decimal(8,2))as promedio"& vbCrLf &_
"from ENCU_RELATOR_OTEC vv"& vbCrLf &_
"where  vv.pers_ncorr_relator="&f_pers_ncorr_relator&""& vbCrLf &_
"and vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"and vv.seot_ncorr="&seot_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 4 as npre,'Los textos y material bibliográfico fueron adecuados para los aprendizajes'as pregunta, cast(round(avg(enrp_4),2)as decimal(8,2))as promedio"& vbCrLf &_
"from ENCU_RELATOR_OTEC vv"& vbCrLf &_
"where  vv.pers_ncorr_relator="&f_pers_ncorr_relator&""& vbCrLf &_
"and vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"and vv.seot_ncorr="&seot_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select  5 as npre,'Planifica y solicita los materiales necesarios para las clases'as pregunta, cast(round(avg(enrp_5),2)as decimal(8,2))as promedio"& vbCrLf &_
"from ENCU_RELATOR_OTEC vv"& vbCrLf &_
"where  vv.pers_ncorr_relator="&f_pers_ncorr_relator&""& vbCrLf &_
"and vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"and vv.seot_ncorr="&seot_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 6 as npre,'El profesor aplica diversas estrategias de enseñanza para facilitar el aprendizaje'as pregunta, cast(round(avg(enrp_6),2)as decimal(8,2))as promedio"& vbCrLf &_
"from ENCU_RELATOR_OTEC vv"& vbCrLf &_
"where  vv.pers_ncorr_relator="&f_pers_ncorr_relator&""& vbCrLf &_
"and vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"and vv.seot_ncorr="&seot_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 7 as npre,'El profesor se muestra accesible y está dispuesto a atender las consultas y sugerencias de los alumnos'as pregunta, cast(round(avg(enrp_7),2)as decimal(8,2))as promedio"& vbCrLf &_
"from ENCU_RELATOR_OTEC vv"& vbCrLf &_
"where  vv.pers_ncorr_relator="&f_pers_ncorr_relator&""& vbCrLf &_
"and vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"and vv.seot_ncorr="&seot_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 8 as npre,'El profesor cumple efectivamente con el Plan de Evaluación señalado'as pregunta, cast(round(avg(enrp_8),2)as decimal(8,2))as promedio"& vbCrLf &_
"from ENCU_RELATOR_OTEC vv"& vbCrLf &_
"where  vv.pers_ncorr_relator="&f_pers_ncorr_relator&""& vbCrLf &_
"and vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"and vv.seot_ncorr="&seot_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 9 as npre,'El profesor cumple adecuadamente con el Programa'as pregunta, cast(round(avg(enrp_9),2)as decimal(8,2))as promedio"& vbCrLf &_
"from ENCU_RELATOR_OTEC vv"& vbCrLf &_
"where  vv.pers_ncorr_relator="&f_pers_ncorr_relator&""& vbCrLf &_
"and vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"and vv.seot_ncorr="&seot_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 10 as npre,'El profesor entrega oportunamente (dentro de 15 días) los resultados de la evaluación'as pregunta, cast(round(avg(enrp_10),2)as decimal(8,2))as promedio"& vbCrLf &_
"from ENCU_RELATOR_OTEC vv"& vbCrLf &_
"where  vv.pers_ncorr_relator="&f_pers_ncorr_relator&""& vbCrLf &_
"and vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"and vv.seot_ncorr="&seot_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 11 as npre,'El profesor realiza retroalimentación de los aprendizajes'as pregunta, cast(round(avg(enrp_11),2)as decimal(8,2))as promedio"& vbCrLf &_
"from ENCU_RELATOR_OTEC vv"& vbCrLf &_
"where  vv.pers_ncorr_relator="&f_pers_ncorr_relator&""& vbCrLf &_
"and vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"and vv.seot_ncorr="&seot_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 12 as npre,'El profesor  promueve un ambiente de aprendizaje acorde a las necesidades de los estudiantes'as pregunta, cast(round(avg(enrp_12),2)as decimal(8,2))as promedio"& vbCrLf &_
"from ENCU_RELATOR_OTEC vv"& vbCrLf &_
"where  vv.pers_ncorr_relator="&f_pers_ncorr_relator&""& vbCrLf &_
"and vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"and vv.seot_ncorr="&seot_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 13 as npre,'El profesor cumple con el horario y aspectos formales 'as pregunta, cast(round(avg(enrp_13),2)as decimal(8,2))as promedio"& vbCrLf &_
"from ENCU_RELATOR_OTEC vv"& vbCrLf &_
"where  vv.pers_ncorr_relator="&f_pers_ncorr_relator&""& vbCrLf &_
"and vv.seot_ncorr="&seot_ncorr&""& vbCrLf &_
"and vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"order by npre"
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_busqueda.consultar	consulta
'f_busqueda.Siguiente

dcur_tdesc=conectar.consultaUno("select dcur_tdesc from diplomados_cursos where dcur_ncorr="&f_dcur_ncorr&"")
nombre_relator=conectar.consultaUno("select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno from personas  where pers_ncorr="&f_pers_ncorr_relator&"")
modulos=conectar.consultaUno("select mote_tdesc from modulos_otec where mote_ccod='"&mote_ccod&"'")
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
						  <td align="center"><strong><font size="2">Relator: <%=nombre_relator%></font></strong></td>
						</tr>
						<tr>
						  <td align="center"><strong><font size="2">Modulo: <%=modulos%></font></strong></td>
						</tr>
						<tr>
						  <td align="center">&nbsp;</td>
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
                      <td align="center"><%botonera.AgregaBotonParam "excel_estado", "url", "encuesta_relator_programas_detalle_excel.asp?dcur_ncorr="&f_dcur_ncorr&"&pers_ncorr_relator="&f_pers_ncorr_relator&"&seot_ncorr="&seot_ncorr
					  botonera.DibujaBoton"excel_estado"%></td>
					  <td align="center"><%	botonera.AgregaBotonParam "volver", "url", "encuesta_relator_programas.asp?dcur_ncorr="&f_dcur_ncorr&"&pers_ncorr_relator="&f_pers_ncorr_relator&""
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
