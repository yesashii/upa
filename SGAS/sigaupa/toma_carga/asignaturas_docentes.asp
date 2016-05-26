<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
set botonera = new CFormulario
set errores 	= new cErrores
botonera.carga_parametros "asignaturas_docentes.xml", "BotoneraSeccionesEQ"

'for each k in request.QueryString()
'	response.Write(k&" = "&request.QueryString(k)&"<br>")
'next
carr_ccod   =   request.QueryString("a[0][carr_ccod]")
sede_ccod	=	request.querystring("a[0][sede_ccod]")

set conectar		=	new cconexion
set negocio			=	new cnegocio

conectar.inicializar "upacifico"
negocio.inicializa conectar

'espe_ccod=conectar.consultaUno("Select espe_ccod from planes_estudio where cast(plan_ccod as varchar)='"&plan_ccod&"'")
'cadena_planes=conectar.consultaUno("select ltrim(rtrim(protic.obtener_planes('"&espe_ccod&"')))")
'response.Write("cadena planes "&cadena_planes)
'-------------------------------------------Seleccionar asignatura para equivalencia de una lista sin escribir su código-----
'-----------------------------------------------------------msandoval 19-02-2005---------------------------------------------
set fbusqueda = new cFormulario
fbusqueda.carga_parametros "asignaturas_docentes.xml", "buscador"
fbusqueda.inicializar conectar
peri = negocio.obtenerPeriodoAcademico ( "planificacion" ) 
'sede = negocio.obtenerSede

consulta="Select '"&sede_ccod&"' as sede_ccod, '"&carr_ccod&"' as carr_ccod"

fbusqueda.consultar consulta

consulta = " select distinct a.sede_ccod, a.sede_tdesc,b.carr_ccod,b.carr_tdesc "& vbCrLf &_
		   " from sedes a, carreras b, ofertas_Academicas c, especialidades d "& vbCrLf &_
		   " where a.sede_ccod=c.sede_ccod "& vbCrLf &_
		   " and c.espe_ccod=d.espe_ccod "& vbCrLf &_
		   " and d.carr_ccod=b.carr_ccod "& vbCrLf &_
		   " and cast(c.peri_ccod as varchar)='"&peri&"'"& vbCrLf &_
		   " order by sede_tdesc, carr_tdesc" 
	
fbusqueda.inicializaListaDependiente "lBusqueda", consulta
fbusqueda.siguiente

set f_asignaturas = new CFormulario
f_asignaturas.Carga_Parametros "asignaturas_docentes.xml", "f_asignaturas"
f_asignaturas.inicializar conectar

set f_profesores = new CFormulario
f_profesores.Carga_Parametros "asignaturas_docentes.xml", "f_profesores"
f_profesores.inicializar conectar

if not esVacio(sede_ccod) and not esVacio(carr_ccod) then
sql=" select distinct b.asig_ccod, b.asig_tdesc, e.dias_tdesc as dia,f.sala_tdesc,c.hora_ccod as bloque "& vbCrLf &_
	" from secciones a, asignaturas b, bloques_horarios c,dias_semana e,salas f "& vbCrLf &_
	" where a.asig_ccod=b.asig_ccod "& vbCrLf &_
	" and a.secc_ccod=c.secc_ccod "& vbCrLf &_
	" and not exists (select 1 from bloques_profesores d where c.bloq_ccod=d.bloq_ccod) "& vbCrLf &_
	" and c.dias_ccod=e.dias_ccod "& vbCrLf &_
	" and c.sala_ccod=f.sala_ccod "& vbCrLf &_
	" and cast(a.peri_ccod as varchar)='"&peri&"' "& vbCrLf &_
	" and cast(a.sede_ccod as varchar)='"&sede_ccod&"'" & vbCrLf &_
	" and cast(a.carr_ccod as varchar)='"&carr_ccod&"'"
	
'sql2=" select distinct cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut,b.pers_tape_paterno + ' ' +b.pers_tape_materno + ',' + b.pers_tnombre as profesor, " & vbCrLf &_
'	" c.tpro_tdesc as tipo_profesor " & vbCrLf &_
'	" from profesores a,personas b, tipos_profesores c " & vbCrLf &_
'	" where a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
'	" and a.tpro_ccod=c.tpro_ccod " & vbCrLf &_
'	" and not exists (select 1 from bloques_profesores d where a.pers_ncorr=d.pers_ncorr) " & vbCrLf &_
'	" and a.sede_ccod='"&sede_ccod&"'"
	
sql2= "  select distinct cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut,b.pers_tape_paterno + ' ' +b.pers_tape_materno + ',' + b.pers_tnombre as profesor, " & vbCrLf &_
	  " c.tpro_tdesc as tipo_profesor " & vbCrLf &_
	  " from profesores a,personas b, tipos_profesores c,carreras_docente d " & vbCrLf &_
	  " where a.pers_ncorr=d.pers_ncorr " & vbCrLf &_
	  " and a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
	  " and a.tpro_ccod=c.tpro_ccod " & vbCrLf &_
	  " and d.sede_ccod='"&sede_ccod&"' " & vbCrLf &_
	  " and d.peri_ccod='"&peri&"' " & vbCrLf &_
	  " and d.carr_ccod='"&carr_ccod&"' " & vbCrLf &_
	  " and not exists (select 1 from bloques_profesores f where a.pers_ncorr=f.pers_ncorr) "	  	
'response.Write("<pre>"&sql2&"</pre>")	
	carrera=conectar.consultaUno("Select carr_tdesc from carreras where cast(carr_ccod as varchar)='"&carr_ccod&"'")	
	sede=conectar.consultaUno("Select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede_ccod&"'")
else
	sql="select * from sexos where 1=2"
	sql2="select * from sexos where 1=2"
end if
'response.Write("<pre>"&sql2&"</pre>")
f_asignaturas.consultar sql
f_profesores.consultar sql2
%>

<html>
<head>
<title>B&uacute;squeda de Secciones</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<!--   -->
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
<!--


function enviar(formulario){
            formulario.action ="asignaturas_docentes.asp";//?matr_ncorr="+matricula+"&pers_ncorr="+pers+"&sede_ccod="+sede+"&plan_ccod="+plan+"&peri_ccod="+periodo+"&asig_ccod="+asignatura;
			formulario.submit();
}
function abrir(){
	self.opener.location.reload();
	window.close();
}
function salir(){
	self.opener.location.reload();
	window.close();
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_nbGroup(event, grpName) { //v6.0
  var i,img,nbArr,args=MM_nbGroup.arguments;
  if (event == "init" && args.length > 2) {
    if ((img = MM_findObj(args[2])) != null && !img.MM_init) {
      img.MM_init = true; img.MM_up = args[3]; img.MM_dn = img.src;
      if ((nbArr = document[grpName]) == null) nbArr = document[grpName] = new Array();
      nbArr[nbArr.length] = img;
      for (i=4; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
        if (!img.MM_up) img.MM_up = img.src;
        img.src = img.MM_dn = args[i+1];
        nbArr[nbArr.length] = img;
    } }
  } else if (event == "over") {
    document.MM_nbOver = nbArr = new Array();
    for (i=1; i < args.length-1; i+=3) if ((img = MM_findObj(args[i])) != null) {
      if (!img.MM_up) img.MM_up = img.src;
      img.src = (img.MM_dn && args[i+2]) ? args[i+2] : ((args[i+1])? args[i+1] : img.MM_up);
      nbArr[nbArr.length] = img;
    }
  } else if (event == "out" ) {
    for (i=0; i < document.MM_nbOver.length; i++) {
      img = document.MM_nbOver[i]; img.src = (img.MM_dn) ? img.MM_dn : img.MM_up; }
  } else if (event == "down") {
    nbArr = document[grpName];
    if (nbArr)
      for (i=0; i < nbArr.length; i++) { img=nbArr[i]; img.src = img.MM_up; img.MM_dn = 0; }
    document[grpName] = nbArr = new Array();
    for (i=2; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
      if (!img.MM_up) img.MM_up = img.src;
      img.src = img.MM_dn = (args[i+1])? args[i+1] : img.MM_up;
      nbArr[nbArr.length] = img;
  } }
}
//-->
</script>
<% fbusqueda.generaJS %>
</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="701" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td height="397" valign="top" bgcolor="#EAEAEA">
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
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td>
                  <%pagina.DibujarLenguetas Array("Seleccione datos de búsqueda"), 1 %>
                </td>
              <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>              
            </tr>
            <tr>
              <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
          </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td width="670" bgcolor="#D8D8DE">
				  <div align="left">
				    <table width="100%" cellpadding="0" cellspacing="0">
				      <tr>
				        <td>&nbsp;</td>
			          </tr>
			        </table>
			      </div>				  
<form action="" method="get" name="buscador">
                    <table width="98%"  border="0">
                      <tr>
                        <td width="81%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="5%"> <div align="left">Sede</div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td><% fbusqueda.dibujaCampoLista "lBusqueda", "sede_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="5%"> <div align="left">Carrera</div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td><% fbusqueda.dibujaCampoLista "lBusqueda", "carr_ccod"%></td>
                              </tr>
						   </table></td>
                        <td width="19%"><div align="center"><%botonera.dibujaboton "buscar"%></div></td>
                      </tr>
                    </table>
				  </form></td><td width="10" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>			
          </td>
      </tr>
    </table>	
	<br>		
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td>
		     <form name="edicion">
			 <input type="hidden" name="a[0][carr_ccod]" value="<%=carr_ccod%>">
			 <input type="hidden" name="a[0][sede_ccod]" value="<%=sede_ccod%>">
			 <table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="599" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
			  <tr>
              	<td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td>
                  <%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %>
                </td>
              	<td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>              
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
			 
              	<table width="100%" border="0" cellspacing="0" cellpadding="0">
                   <tr>
                  		<td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  		<td bgcolor="#D8D8DE" colspan="3">
				      	  		<table width="50%" cellspacing="0" cellpadding="0">
                      			<tr align="left">
                       				 <td colspan="2" nowrap>&nbsp;</td>
                      			</tr>
                      			<tr>
                        			 
                        <td width="29%" align="right" nowrap>Sede :</td>
                        			 <td width="71%" nowrap> <strong><%=sede%></strong> </td>
                        		</tr>
                      			<tr>
                        			 <td align="right" nowrap>Carrera :</td>
                        			 <td nowrap> <strong><%=carrera%></strong> </td>
                                </tr>
					         </table>
				 		</td>
						<td width="8" align="right" background="../imagenes/der.gif" colspan="1">&nbsp;</td>
                	</tr>
					<tr>
                  		<td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  		<td bgcolor="#D8D8DE" align="right" colspan="3">&nbsp;</td>
						<td width="8" align="right" background="../imagenes/der.gif" colspan="1">&nbsp;</td>
                	</tr>
					<tr>
                  		<td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  		<td bgcolor="#D8D8DE" align="center" colspan="3"><%pagina.dibujarSubtitulo "Asignaturas sin docente asignado"%></td>
						<td width="8" align="right" background="../imagenes/der.gif" colspan="1">&nbsp;</td>
                	</tr>	
					<tr>
                  		<td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  		<td bgcolor="#D8D8DE" align="right" colspan="3">P&aacute;gina:
                                 <%f_asignaturas.accesopagina%>
                             </td>
						<td width="8" align="right" background="../imagenes/der.gif" colspan="1">&nbsp;</td>
                	</tr>
					<tr>
                  		<td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  		<td bgcolor="#D8D8DE" colspan="3">
				      	  		<center><br><%f_asignaturas.dibujaTabla()%></center>
				 		</td>
						<td width="8" align="right" background="../imagenes/der.gif" colspan="1">&nbsp;</td>
                	</tr>
					<tr>
                  		<td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  		<td bgcolor="#D8D8DE" colspan="3" align="right">
						                   <% botonera.agregabotonparam "excel_asignaturas", "url", "listado_asignaturas_docente.asp"
										      botonera.dibujaboton "excel_asignaturas"%></td>
						<td width="8" align="right" background="../imagenes/der.gif" colspan="1">&nbsp;</td>
                	</tr>
					<tr>
                  		<td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  		<td bgcolor="#D8D8DE" colspan="3"><center><br>&nbsp;</center></td>
						<td width="8" align="right" background="../imagenes/der.gif" colspan="1">&nbsp;</td>
                	</tr>
					
					<tr>
                  		<td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  		<td bgcolor="#D8D8DE" colspan="3" align="center"><%pagina.dibujarSubtitulo "Docentes sin asignaturas"%></td>
						<td width="8" align="right" background="../imagenes/der.gif" colspan="1">&nbsp;</td>
                	</tr>
					<tr>
                  		<td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  		<td bgcolor="#D8D8DE" align="right" colspan="3">P&aacute;gina:
                                 <%f_profesores.accesopagina%>
                             </td>
						<td width="8" align="right" background="../imagenes/der.gif" colspan="1">&nbsp;</td>
                	</tr>
					<tr>
                  		<td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  		<td bgcolor="#D8D8DE" colspan="3">
				      	  		<center><br><%f_profesores.dibujaTabla()%></center>
				 		</td>
						<td width="8" align="right" background="../imagenes/der.gif" colspan="1">&nbsp;</td>
                	</tr>
					<tr>
                  		<td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  		<td bgcolor="#D8D8DE" colspan="3" align="right">
						                   <% botonera.agregabotonparam "excel_docentes", "url", "listado_docentes.asp"
										      botonera.dibujaboton "excel_docentes"%></td>
						<td width="8" align="right" background="../imagenes/der.gif" colspan="1">&nbsp;</td>
                	</tr>
					<tr>
                  		<td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  		<td width="132" bgcolor="#D8D8DE">
				  		<table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    		<tr>
                       			<td><div align="center"><%botonera.dibujaboton "salir"%></div></td>
                    		</tr>
                  		</table>                    
                  		</td>
                  		<td width="235" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                 		<td rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif" colspan="2" ><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                	</tr>
                	<tr>
                  		<td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                	</tr>
                </table>
				</form>
		         </td>
                </tr>
			   </table>
			   
           </td>
  </tr>  
</table>
</body>
</html>
