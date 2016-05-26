<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
  set conexion = new CConexion
  conexion.Inicializar "upacifico"
  
  set negocio = new CNegocio
  negocio.Inicializa conexion
  
  'response.End()

  q_pers_nrut = negocio.obtenerUsuario
  pers_ncorr = conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
  
  c_es_profesor = " Select count(*) from bloques_profesores a, bloques_horarios b, secciones c "&_
                  " where a.bloq_ccod=b.bloq_ccod and b.secc_ccod=c.secc_ccod and c.peri_ccod=226 "&_
				  " and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and c.carr_ccod='21' "
  es_profesor = conexion.consultaUno(c_es_profesor)

  c_es_alumno = " Select count(*) from alumnos a, ofertas_academicas b, especialidades c"&_
                " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod "&_
				" and a.emat_ccod <> 9 and b.peri_ccod=226 and c.carr_ccod='21' "&_
				" and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'"
  es_alumno = conexion.consultaUno(c_es_alumno)
  
  c_es_administrativo = " Select count(*) from personas where pers_nrut in (9498228,7013653,8099825,2633087,9975051,13687557) "&_
                        " and cast(pers_ncorr as varchar)='"&pers_ncorr&"'"
  es_administrativo = conexion.consultaUno(c_es_administrativo)  
  
  mensaje_bloqueo = ""
  if es_alumno = "0" and es_profesor="0" and es_administrativo="0" then
  	mensaje_bloqueo = "Lo sentimos pero en esta votación sólo pueden participar administrativos, alumnos y profesores de la escuela de diseño gráfico"
  end if
  
  grabado = conexion.consultaUno("select count(*) from votacion_concurso_dg where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and anos_ccod=2012")
  
  if grabado > "0" then
	mensaje_bloqueo = "Lo sentimos pero sólo puede guardar una preferencia de afiche"
  end if

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>UN RAYON EN LA PARED - AFICHES</title>
<style type="text/css">
<!--
body {
	background-color: #CCCCCC;
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.Estilo1 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 9;
}
.Estilo3 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
}
.Estilo4 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 9px;
}
-->
</style>
<script type="text/JavaScript">
<!--
function MM_openBrWindow(theURL,winName,features) 
{ //v2.0
  window.open(theURL,winName,features);
}

function enviar_votacion()
{
  var cantidad=document.edicion.length;
  var contestada = 0;
  var i=0;
  var cant_radios = 0;
  for(i=0;i<cantidad;i++)
  {
    elemento=document.edicion.elements[i];
  	if (elemento.type=="radio")
  		{
		  cant_radios++;
		  if(elemento.checked)
		     {contestada++;}
  		}
  }
  //alert(contestada);
  
  if (contestada > 0)
  {
  	document.edicion.submit();
  }
  else
  {
  	alert("Imposible enviar la votación, aún no selecciona afiche");
  }
}
//-->
</script>
</head>

<body>
<table width="90%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td valign="top"><img src="tit.gif" alt="UN RAYON EN LA PARED" width="555" height="112" /></td>
    <td valign="top"><div align="right"><img src="logo.gif" alt="LOGO UPA" width="185" height="56" /></div></td>
  </tr>
</table>
<Form name="edicion" action="proc_guardar_votacion_dg.asp" method="post">
<input type="hidden" name="pers_ncorr" value="<%=pers_ncorr%>">
<input type="hidden" name="es_profesor" value="<%=es_profesor%>">
<input type="hidden" name="es_alumno" value="<%=es_alumno%>">
<input type="hidden" name="es_administrativo" value="<%=es_administrativo%>">
<table width="90%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td valign="top">
         <blockquote class="Estilo1">
      <p>&nbsp;</p>
      <p><strong>Instrucciones:</strong><br />  
        <span class="Estilo3">Bienvenido a la muestra de afiches del concurso  <B> &quot;&iexcl;Igualdad de g&eacute;nero ahora!&quot;. </B>  </span></p>
    </blockquote>
      <ol>
        <li class="Estilo3">Pincha los afiches para visualizarlos a mayor tama&ntilde;o.</li>
		<li class="Estilo3"> Selecciona tu favorito y vota. S&oacute;lo puedes hacerlo una vez.</li>
		<li class="Estilo3"> Recuerda que la premiación es el jueves 12 de julio a las 12:00 en el hall del triángulo <B>¡TE ESPERAMOS! </b> </li>
      </ol>
      <blockquote>
        <p class="Estilo1"><strong>Afiches participantes:</strong></p>
      </blockquote>
    </td>
    <td width="100" valign="top"><div align="right"></div></td>
  </tr>
</table>
<hr align="left" width="90%" size="1" noshade="noshade" />
<table width="90%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="20%">
		<span class="Estilo4">
	      <div align="center"><a href="#"><img src="chicos/img_1.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(1).jpg','','width=305,height=425')" /></a><br/>
            <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=1 and anos_ccod=2012")%>
            <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
          </div>
          </span>	
    </td>
	<td width="20%">
		<span class="Estilo4">
	      <div align="center"><a href="#"><img src="chicos/img_2.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(2).jpg','','width=305,height=425')" /></a><br />
            <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=2 and anos_ccod=2012")%>
            <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
          </div>
          </span>	
     </td>
	
	    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_3.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(3).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=3 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>	</td>
	
	    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_4.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(4).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=4 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>	</td>
	
	    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_5.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(5).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=5 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>	</td>
  </tr>
</table>
  
  
  <hr align="left" width="90%" size="1" noshade="noshade" />
  <table width="90%" border="0" cellspacing="0" cellpadding="0">
 
 
 <tr>
    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_6.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(6).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=6 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	  
    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_7.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(7).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=7 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	
	    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_8.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(8).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=8 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	
	    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_9.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(9).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=9 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	
	    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_10.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(10).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=10 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
  </tr>
 
 
</table>
    
  <hr align="left" width="90%" size="1" noshade="noshade" />
  <table width="90%" border="0" cellspacing="0" cellpadding="0">

 
 
 <tr>
    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_11.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(11).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=11 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	  
    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_12.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(12).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=12 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	
	    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_13.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(13).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=13 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	
	    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_14.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(14).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=14 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	
	    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_15.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(15).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=15 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
  </tr>
 
 
</table>
    
  <hr align="left" width="90%" size="1" noshade="noshade" />
  <table width="90%" border="0" cellspacing="0" cellpadding="0">
 

 
 
 <tr>
    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_16.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(16).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=16 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	  
    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_17.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(17).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=17 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	
	    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_18.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(18).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=18 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	
	    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_19.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(19).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=19 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	
	    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_20.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(20).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=20 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
  </tr>
 
 
</table>
    
  <hr align="left" width="90%" size="1" noshade="noshade" />
  <table width="90%" border="0" cellspacing="0" cellpadding="0">
 
 

 
 
 <tr>
    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_21.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(21).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=21 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	  
    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_22.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(22).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=22 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	
	    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_23.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(23).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=23 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	
	    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_24.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(24).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=24 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	
	    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_25.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(25).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=25 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
  </tr>
  
  
</table>
    
  <hr align="left" width="90%" size="1" noshade="noshade" />
  <table width="90%" border="0" cellspacing="0" cellpadding="0">

 
 
 <tr>
    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_26.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(26).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=26 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	  
    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_27.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(27).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=27 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	
	    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_28.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(28).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=28 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	
	    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_29.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(29).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=29 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	
	    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_30.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(30).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=30 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
  </tr>
  
  
</table>
    
  <hr align="left" width="90%" size="1" noshade="noshade" />
  <table width="90%" border="0" cellspacing="0" cellpadding="0">
 
 
 <tr>
    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_31.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(31).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=31 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	  
    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_32.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(32).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=32 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	
	    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_33.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(33).jpg','','width=305,height=425')" /></a><br />
         <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=33 and anos_ccod=2012")%>
         <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	
	    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_34.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(34).jpg','','width=305,height=425')" /></a><br />
            <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=34 and anos_ccod=2012")%>
            <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	
	    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_35.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(35).jpg','','width=305,height=425')" /></a><br />
            <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=35 and anos_ccod=2012")%>
            <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
  </tr>
 
 

</table>
    
  <hr align="left" width="90%" size="1" noshade="noshade" />
  <table width="90%" border="0" cellspacing="0" cellpadding="0">

 
 
 <tr>
    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_36.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(36).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=36 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>	</td>
	  
    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_37.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(37).jpg','','width=305,height=425')" /></a><br />
            <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=37 and anos_ccod=2012")%>
            <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>	</td>
	
	    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_38.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(38).jpg','','width=305,height=425')" /></a><br />
            <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=38 and anos_ccod=2012")%>
            <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>	</td>
	
	    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_39.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(39).jpg','','width=305,height=425')" /></a><br />
            <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=39 and anos_ccod=2012")%>
            <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>	</td>
	
	    <td width="20%">
	<span class="Estilo4">

      <div align="center"><a href="#"><img src="chicos/img_40.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(40).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=40 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>	</td>
  </tr>
</table>
   
  <hr align="left" width="90%" size="1" noshade="noshade" />
  <table width="90%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="20%">
	<span class="Estilo4">
      <div align="center"><a href="#"><img src="chicos/img_41.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(41).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=41 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
    <td width="20%">
	<span class="Estilo4">
      <div align="center"><a href="#"><img src="chicos/img_42.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(42).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=42 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	<td width="20%">
	<span class="Estilo4">
      <div align="center"><a href="#"><img src="chicos/img_43.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(43).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=43 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	<td width="20%">
	<span class="Estilo4">
      <div align="center"><a href="#"><img src="chicos/img_44.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(44).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=44 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	<td width="20%">
	<span class="Estilo4">
      <div align="center"><a href="#"><img src="chicos/img_45.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(45).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=45 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
  </tr>
</table>

  <hr align="left" width="90%" size="1" noshade="noshade" />
  <table width="90%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="20%">
	<span class="Estilo4">
      <div align="center"><a href="#"><img src="chicos/img_46.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(46).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=46 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
    <td width="20%">
	<span class="Estilo4">
      <div align="center"><a href="#"><img src="chicos/img_47.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(47).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=47 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	<td width="20%">
	<span class="Estilo4">
      <div align="center"><a href="#"><img src="chicos/img_48.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(48).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=48 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	<td width="20%">
	<span class="Estilo4">
      <div align="center"><a href="#"><img src="chicos/img_49.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(49).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=49 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	<td width="20%">
	<span class="Estilo4">
      <div align="center"><a href="#"><img src="chicos/img_50.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(50).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=50 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
  </tr>
</table>

<hr align="left" width="90%" size="1" noshade="noshade" />
  <table width="90%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="20%">
	<span class="Estilo4">
      <div align="center"><a href="#"><img src="chicos/img_51.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(51).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=51 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
    <td width="20%">
	<span class="Estilo4">
      <div align="center"><a href="#"><img src="chicos/img_52.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(52).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=52 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	<td width="20%">
	<span class="Estilo4">
      <div align="center"><a href="#"><img src="chicos/img_53.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(53).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=53 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	<td width="20%">
	<span class="Estilo4">
      <div align="center"><a href="#"><img src="chicos/img_54.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(54).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=54 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
	<td width="20%">
	<span class="Estilo4">
      <div align="center"><a href="#"><img src="chicos/img_55.jpg" width="107" height="150" border="0" onClick="MM_openBrWindow('grandes/Img_gr(55).jpg','','width=305,height=425')" /></a><br />
        <%total = conexion.consultaUno("select count(*) from votacion_concurso_dg where opcion=55 and anos_ccod=2012")%>
        <font size="3" color="#0033FF"><strong><%=total%> VOTOS</strong></font>
      </div>
      </span>
	</td>
  </tr>
</table>

<hr align="left" width="90%" size="1" noshade="noshade" />
<hr align="left" width="90%" size="1" noshade="noshade">
  <table width="90%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td bgcolor="#990000" align="center">
          <font color="#FFFFFF"><strong>
          	&nbsp;
          </strong></font>
      </td>
    </tr>
  </table>
 </Form>
 <p>&nbsp;</p>
 <p align="center">&nbsp;</p>
 <p>&nbsp;</p>
 <p>&nbsp;</p>
</body>
</html>
