<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Antecedentes Profesionales"

'---------------------------------------------------------------------------------------------------
pers_ncorr=request.QueryString("pers_ncorr")
rut = request("rut")
dv = request("dv")

set negocio = new CNegocio
set conectar = new cconexion

conectar.inicializar "upacifico"
negocio.inicializa conectar
sede = negocio.obtenerSede

Sqlpersfeccionamiento = " Select '"&pers_ncorr&"' as pers_ncorr,cudo_ncorr,cudo_tinstitucion, " & _
						" case grac_ccod when 1 then ' TÉCNICO ' when 2 then ' PROFESIONAL ' else '' end + '""' + CUDO_TITULO + '""' as CUDO_TITULO,PAIS_TDESC,cudo_ano_egreso " & _
			   " from curriculum_docente a,paises b" & _
			   " where a.pais_ccod = b.pais_ccod" & _
			   " and cast(pers_ncorr as varchar)='"&pers_ncorr&"'" & _
			   " and tiex_ccod=3 " &_
			   "order by cudo_finicio asc"

set F_Perfeccionamiento = new cformulario			   
F_Perfeccionamiento.carga_parametros "lec_perfeccionamiento.xml", "perfeccionamiento"
F_Perfeccionamiento.inicializar conectar

F_Perfeccionamiento.consultar Sqlpersfeccionamiento

response.Flush()
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "lec_perfeccionamiento.xml", "botonera"

f_botonera.AgregaBotonParam "agregar", "url", "agregar_perfeccionamiento.asp?pers_ncorr=" & pers_ncorr

lenguetas_masignaturas = Array(Array("Informacion Docente", "editar_docente.asp?pers_ncorr="&pers_ncorr&"&rut="&rut&"&dv="&dv),Array("Antecedentes Profesionales", "perfeccionamiento.asp?pers_ncorr="&pers_ncorr&"&rut="&rut&"&dv="&dv),Array("Antecedentes Academicos", "grado_academico.asp?pers_ncorr="&pers_ncorr&"&rut="&rut&"&dv="&dv), Array("Experiencia Laboral", "experiencia_laboral.asp?pers_ncorr="&pers_ncorr&"&rut="&rut&"&dv="&dv),Array("Experiencia Docente", "experiencia_docente.asp?pers_ncorr="&pers_ncorr&"&rut="&rut&"&dv="&dv))
lenguetas_masignaturas01 = Array(Array("Otras Actividades Docente", "otras_actividades.asp?pers_ncorr="&pers_ncorr))

nombre=conectar.ConsultaUno("select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
rut=conectar.ConsultaUno("select cast(pers_nrut as varchar)+'-'+pers_xdv from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
%>


<html>
<head>
<title>Experiencia Docente</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">


function enviar(formulario,pagina){
			pers_ncorr=formulario.pers_ncorr.value	
			if (pagina==0){
				window.navigate('editar_docente.asp?pers_ncorr='+pers_ncorr+'&rut='+"<%=rut%>"+'&dv='+"<%=dv%>");
				//formulario.action ='editar_docente.asp?pers_ncorr='+pers_ncorr+'&rut='+<%=rut%>+'&dv='+<%=dv%>;	  
		  		//formulario.submit();
			}
			/*if (pagina==1){
				window.navigate('experiencia_laboral.asp?pers_ncorr='+pers_ncorr+'&rut='+<%=rut%>+'&dv='+<%=dv%>)
				//formulario.action ='experiencia_laboral.asp?pers_ncorr='+pers_ncorr+'&rut='+<%=rut%>+'&dv='+<%=dv%>;	  
			  	//formulario.submit();
			}
			if (pagina==2){
				window.navigate('experiencia_docente.asp?pers_ncorr='+pers_ncorr+'&rut='+<%=rut%>+'&dv='+<%=dv%>)
				//formulario.action ='experiencia_docente.asp?pers_ncorr='+pers_ncorr+'&rut='+<%=rut%>+'&dv='+<%=dv%>;	  
			  	//formulario.submit();
			}*/
}

function enviar2()
{ var pers_ncorr=document.editar.elements["pers_ncorr"].value;
  ruta="grado_academico.asp?pers_ncorr="+pers_ncorr;
  window.location=ruta;
}


</script>

<style type="text/css">
<!--
.style1 {
	color: #333333;
	font-size: 10px;
}
.style2 {color: #333333}
-->
</style>
</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<br>		
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td background="../imagenes/top_r1_c2.gif"><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><%pagina.DibujarLenguetas lenguetas_masignaturas, 2%></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="693" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
			  <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><%pagina.DibujarLenguetas lenguetas_masignaturas01, 0%></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="693" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">				   
				      <br>
			          <div align="center"> 
                        <%pagina.DibujarTituloPagina%>
                     </div>
					 <br>
					 <div>
					 	<table>
							<tr>
								<td>
									Nombre:&nbsp;<strong><%=nombre%></strong>
								</td>
							</tr>
							<tr>
								<td>
									Rut:&nbsp;<strong><%=rut%></strong>
								</td>
							</tr>
						</table>
					 </div>
				    <form name="editar">
					<input type="hidden" name="pers_ncorr" value=<%=pers_ncorr%>>
				    <div align="center">
			          <%F_Perfeccionamiento.dibujatabla()%>
					  <br>
					  <br>
                    		            
                      </div>
				    </form>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="181" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><div align="center">
                          <%
						 f_botonera.agregabotonparam "anterior", "url", "editar_docente.asp?pers_ncorr="&pers_ncorr 
						  f_botonera.DibujaBoton("anterior")%>
                      </div></td>
					  <td><div align="center">
                          <%f_botonera.agregabotonparam "siguiente", "url","grado_academico.asp?pers_ncorr="&pers_ncorr
						  f_botonera.DibujaBoton("siguiente")%>
                      </div></td>
                      <td><div align="center">
                          <%f_botonera.DibujaBoton "salir"%>
                      </div></td>
                    </tr>
                  </table></td>
                  <td width="181" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<p><br>
			<p><br>
			<p><br>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
