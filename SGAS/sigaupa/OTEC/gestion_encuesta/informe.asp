<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each x in request.Form
'	response.Write("<br>"&x&" -> "&request.Form(x))
'next
'response.End()
'f_dcur_ncorr=98
f_dcr=Request.querystring("dcur_ncorr")
f_dcur_ncorr=Request.Form("b[0]dcur_ncorr")
'f_dcur_ncorr=98

if f_dcur_ncorr="" then
f_dcur_ncorr=f_dcr
end if
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

consulta="select mote_tdesc,rtrim(c.mote_ccod)as mote_ccod,protic.trunc(seot_finicio)as seot_finicio,protic.trunc(seot_ftermino)as seot_ftermino"& vbCrLf &_
"from diplomados_cursos a"& vbCrLf &_
"join mallas_otec b"& vbCrLf &_
"on a.dcur_ncorr=b.dcur_ncorr"& vbCrLf &_
"join modulos_otec c"& vbCrLf &_
"on b.mote_ccod=c.mote_ccod"& vbCrLf &_
"join secciones_otec d"& vbCrLf &_
"on b.maot_ncorr=d.maot_ncorr"& vbCrLf &_
"join autoriza_encuesta_otec e"& vbCrLf &_
"on b.mote_ccod=e.mote_ccod"& vbCrLf &_
"and a.dcur_ncorr=e.dcur_ncorr"& vbCrLf &_
"where a.dcur_ncorr="&f_dcur_ncorr&""& vbCrLf &_
"group by mote_tdesc,c.mote_ccod,seot_finicio,seot_ftermino"
'
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_busqueda.consultar	consulta
'f_busqueda.Siguiente

dcur_tdesc=conectar.consultaUno("select dcur_tdesc from diplomados_cursos where dcur_ncorr="&f_dcur_ncorr&"")
'-------------------------------------------------------------------------


sel_prom_infraestructura="select cast(((round(avg(enpo_II_1),2)+round(avg(enpo_II_2),2)+round(avg(enpo_II_3),2)+round(avg(enpo_II_4),2)"& vbCrLf &_
													"+round(avg(enpo_II_5),2)+round(avg(enpo_II_6),2)+round(avg(enpo_II_7),2))/7) as decimal(18,2))"& vbCrLf &_
													"from encu_programa_otec vv" & vbCrLf &_
													"where vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
													"group by dcur_ncorr"
											
									prom_infraestructura=conectar.consultaUno(sel_prom_infraestructura)

sel_prom_programa="select cast(((round(avg(enpo_I_1),2)+round(avg(enpo_I_2),2)+round(avg(enpo_I_3),2)+round(avg(enpo_I_4),2)"& vbCrLf &_
													"+round(avg(enpo_I_5),2)+round(avg(enpo_I_6),2)+round(avg(enpo_I_7),2))/7) as decimal(18,2))"& vbCrLf &_
													"from encu_programa_otec vv" & vbCrLf &_
													"where vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
													"group by dcur_ncorr"
									prom_programa=conectar.consultaUno(sel_prom_programa)

tiene=conectar.consultaUno("select count(*) from informe_conclusione_encuesta_otec where dcur_ncorr="&f_dcur_ncorr&"")
set f_concluciones	=	new cformulario
f_concluciones.inicializar		conectar
f_concluciones.carga_parametros	"administra_encuesta.xml", "f_conculusiones" 
if 	tiene=0 then								
sel_concl_="select''"
else
sel_concl_="select iceo_preliminares as preliminares,iceo_acciones as acciones,iceo_finales as finales from informe_conclusione_encuesta_otec where dcur_ncorr="&f_dcur_ncorr&""	
end if
'response.Write(sel_concl_)
f_concluciones.consultar	sel_concl_
f_concluciones.Siguiente								
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
function pdf()
{
	window.open('informe_pdf.asp?dcur_ncorr='+<%=f_dcur_ncorr%>+'',0)
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Creaci&oacute;n informe final </font></div></td>
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
				  <input type="hidden"  name="b[0]dcur_ncorr" value="<%=f_dcur_ncorr%>">
				  	<table width="95%">
						<tr>
						  <td align="center"><strong><font size="2">Programa: <%=dcur_tdesc%></font></strong></td>
						</tr>
						<tr>
						  <td align="center">&nbsp;</td>
						</tr>
						<tr>
						  <td align="center"><strong><font size="2">Encuesta  Relatores</font></strong></td>
						</tr>			
						<tr>
						  <td width="62%" align="center">
						  		<table width="90%" border="1">
									<tr borderColor="#999999">
									<td width="44%" bgColor="#c4d7ff"><div align="center"><strong>Relator</strong></div></td> 
									  <td width="33%" bgColor="#c4d7ff"><div align="center"><strong>Módulos</strong></div></td>
									  <td width="23%" height="17" bgColor="#c4d7ff"><div align="center"><strong>Ptje Promedio</strong></div></td>
									</tr>
									<%while f_busqueda.Siguiente
									mote_ccod=f_busqueda.ObtenerValor("mote_ccod")
									seot_finicio=f_busqueda.ObtenerValor("seot_finicio")
									seot_ftermino=f_busqueda.ObtenerValor("seot_ftermino")
									
									set f_relatores = new CFormulario
									f_relatores.Carga_Parametros "tabla_vacia.xml", "tabla"
									f_relatores.Inicializar conectar
									  
							consulta_sec="select b.mote_ccod,c.seot_ncorr,f.pers_ncorr,mote_tdesc,a.dcur_ncorr,pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre"& vbCrLf &_
							"from modulos_otec b"& vbCrLf &_
							",mallas_otec a"& vbCrLf &_
							",secciones_otec c "& vbCrLf &_
							",bloques_horarios_otec d"& vbCrLf &_
							",bloques_relatores_otec e"& vbCrLf &_
							",personas f"& vbCrLf &_
							"where a.mote_ccod=b.mote_ccod"& vbCrLf &_
							"and a.maot_ncorr=c.maot_ncorr"& vbCrLf &_
							"and c.seot_ncorr=d.seot_ncorr"& vbCrLf &_
							"and d.bhot_ccod=e.bhot_ccod"& vbCrLf &_
							"and e.pers_ncorr=f.pers_ncorr"& vbCrLf &_
							"and a.mote_ccod='"&mote_ccod&"'"& vbCrLf &_
							"and protic.trunc(seot_finicio)='"&seot_finicio&"'"& vbCrLf &_
							"and protic.trunc(seot_ftermino)='"&seot_ftermino&"'"& vbCrLf &_
							"group by  e.pers_ncorr,b.mote_ccod,c.seot_ncorr,f.pers_ncorr,mote_tdesc,a.dcur_ncorr,pers_tape_paterno,pers_tape_materno,pers_tnombre"& vbCrLf &_
							"order by nombre"
							f_relatores.Consultar consulta_sec		
									
									 
								  'response.Write("<br>"&v_deuda)
								  
								
								while f_relatores.Siguiente	
							  
									pers_ncorr=f_relatores.Obtenervalor("pers_ncorr")
									seot_ncorr=f_relatores.Obtenervalor("seot_ncorr")
									mote_ccod=f_relatores.Obtenervalor("mote_ccod")
									
									sel_prom="select cast(((round(avg(enrp_1),2)+round(avg(enrp_2),2)+round(avg(enrp_3),2)+"& vbCrLf &_
											"round(avg(enrp_4),2)+round(avg(enrp_5),2)+round(avg(enrp_6),2)+round(avg(enrp_7),2)+"& vbCrLf &_
											"round(avg(enrp_8),2)+round(avg(enrp_9),2)+round(avg(enrp_10),2)+round(avg(enrp_11),2)+"& vbCrLf &_
											"round(avg(enrp_12),2)+round(avg(enrp_13),2))/13) as decimal(18,1))promedio_evaluacion"& vbCrLf &_
											"from ENCU_RELATOR_OTEC vv"& vbCrLf &_
											"where  vv.pers_ncorr_relator="&pers_ncorr&""& vbCrLf &_
											"and vv.seot_ncorr="&seot_ncorr&""& vbCrLf &_
											"and vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
											"group by pers_ncorr_relator"
											
									prom=conectar.consultaUno(sel_prom)
									'response.Write(sel_prom)
									%>
										  <tr borderColor="#999999"> 
											 <td bgcolor="#FFECC6"><div align="center"><%=f_relatores.Obtenervalor("nombre")%></div></td>
											 <td bgcolor="#FFECC6"><div align="center"><%=f_relatores.Obtenervalor("mote_tdesc")%></div></td>
											 <td bgcolor="#FFECC6"><div align="center"><%=prom%></div></td>
										  </tr>
							 	<%  wend %>	  
						<%  wend %>
								 </table>						  </td>
						</tr>
						<tr>
						  <td align="center">&nbsp;</td>
						</tr>
						<tr>
						  <td align="center"><strong><font size="2">Encuesta  Programa </font></strong></td>
						</tr>
						<tr>
						  <td width="62%" align="center">
						  		<table width="30%" border="1">
									<tr borderColor="#999999">
									  <td width="23%" height="17" bgColor="#c4d7ff"><div align="center"><strong>Ptje Promedio</strong></div></td>
									</tr>
									<tr borderColor="#999999"> 
											 <td bgcolor="#FFECC6"><div align="center"><%=prom_programa%></div></td>
										  </tr>
								 </table>						  </td>
						</tr>
						<tr>
						  <td align="center"><strong><font size="2">Encuesta Infraestreuctura </font></strong></td>
						</tr>
						<tr>
						  <td width="62%" align="center">
						  		<table width="30%" border="1">
									<tr borderColor="#999999">
											<td width="44%" bgColor="#c4d7ff"><div align="center"><strong>Ptje Promedio</strong></div></td> 
									</tr>
									<tr borderColor="#999999"> 
											 <td bgcolor="#FFECC6"><div align="center"><%=prom_infraestructura%></div></td>
										  </tr>
								 </table>						  </td>
						</tr>
						<tr>
						  <td align="center"><strong><font size="2">Conclusiones Preliminares</font></strong></td>
						</tr>
						<tr>
						  <td align="center"><%f_concluciones.dibujaCampo("preliminares")%></td>
						</tr>
						<tr>
						  <td align="center"><strong><font size="2">Conclusiones Finales</font></strong></td>
						</tr>
						<tr>
						  <td align="center"><%f_concluciones.dibujaCampo("finales")%></td>
						</tr>
						<tr>
						  <td align="center"><strong><font size="2">Acciones</font></strong></td>
						</tr>
						<tr>
						  <td align="center"><%f_concluciones.dibujaCampo("acciones")%></td>
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
					<td align="center"><%botonera.DibujaBoton"guarda_informe"%></td>
                      <td align="center"><%botonera.AgregaBotonParam "pdf", "url", "informe_pdf.asp?dcur_ncorr="&f_dcur_ncorr&""
					  botonera.DibujaBoton"pdf"%></td>
					  <td align="center"><%	botonera.AgregaBotonParam "volver", "url", "opcion_administracion.asp?dcur_ncorr="&f_dcur_ncorr
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
