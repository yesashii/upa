<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

set conexion = new cConexion
set ftitulo = new cFormulario
set fsecc_asig = new cFormulario
set botonera = new cFormulario
botonera.carga_parametros "parametros.xml", "btn_subsecciones"


sede_ccod = request.QueryString("sede_ccod")
peri_ccod = request.QueryString("peri_ccod")
asig_ccod = request.QueryString("asig_ccod")
carr_ccod = request.QueryString("carr_ccod")
nive_ccod = request.QueryString("nive_ccod")
espe_ccod = request.QueryString("espe_ccod")
plan_ccod = request.QueryString("plan_ccod")

'response.Write("<br>sede "&sede_ccod& " peri "&peri_ccod&" asig "&asig_ccod& " carr "& carr_ccod)

pagina = "edicion_secc_asig.asp?sede_ccod=" & sede_ccod & "&asig_ccod=" & asig_ccod & "&carr_ccod=" & carr_ccod & "&periodo=" & peri_ccod & "&nive_ccod=" & nive_ccod & "&plan_ccod=" & plan_ccod & "&espe_ccod=" & espe_ccod

conexion.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

ftitulo.carga_parametros "parametros.xml", "4tt"
ftitulo.inicializar conexion
fsecc_asig.carga_parametros "parametros.xml", "5"
fsecc_asig.inicializar conexion
secc_ccod = request.QueryString("secc_ccod")
'-------------------------------------CONSULTA CORRELATIVOS--------------------------------------------
consulta=" select correlativo=count(*),s1.ssec_ncorr, s1.secc_ccod,s1.sede_ccod,s1.carr_ccod,s1.peri_ccod,s1.asig_ccod,s1.jorn_ccod,s1.moda_ccod"& vbCrLf &_
		 " ,s1.ssec_tdesc,s1.ssec_nquorum, s1.ssec_ncupo,s1.ssec_finicio_sec,s1.ssec_ftermino_sec,s1.audi_tusuario,s1.audi_fmodificacion,s1.tsse_ccod "& vbCrLf &_
		 " from ("& vbCrLf &_
		 "	 select  c.ssec_ncorr, c.secc_ccod,"& vbCrLf &_
		 "	 case c.sede_ccod when NULL then "&sede_ccod&" else c.sede_ccod end as sede_ccod,"& vbCrLf &_
		 "	 case c.carr_ccod when NULL then '"&carr_ccod&"' else c.carr_ccod end as carr_ccod,"& vbCrLf &_
		 "	 case c.peri_ccod when NULL then "&peri_ccod&" else c.peri_ccod end as peri_ccod,"& vbCrLf &_
		 "	 case c.asig_ccod when NULL then '"&asig_ccod&"' else c.asig_ccod end as asig_ccod,"& vbCrLf &_
		 "	 case c.jorn_ccod when NULL then b.jorn_ccod else c.jorn_ccod end as jorn_ccod,"& vbCrLf &_
		 "	 case c.moda_ccod when NULL then b.moda_ccod else c.moda_ccod end as moda_ccod,"& vbCrLf &_
		 "	 c.ssec_tdesc,c.ssec_nquorum, c.ssec_ncupo,c.ssec_finicio_sec,c.ssec_ftermino_sec,c.audi_tusuario,c.audi_fmodificacion,c.tsse_ccod "& vbCrLf &_
		 "	 from asignaturas a,secciones b, sub_secciones c "& vbCrLf &_
		 "	 where a.asig_ccod=b.asig_ccod "& vbCrLf &_
		 "	 and b.secc_ccod=c.secc_ccod"& vbCrLf &_
		 "	 and c.tsse_ccod=2"& vbCrLf &_
		 "	 and b.secc_ccod="&secc_ccod&")  s1,"& vbCrLf &_
		 "	 ("& vbCrLf &_
		 "	 select  c.ssec_ncorr, c.secc_ccod,"& vbCrLf &_
		 "	 case c.sede_ccod when NULL then "&sede_ccod&" else c.sede_ccod end as sede_ccod,"& vbCrLf &_
		 "	 case c.carr_ccod when NULL then "&carr_ccod&" else c.carr_ccod end as carr_ccod,"& vbCrLf &_
		 "	 case c.peri_ccod when NULL then "&peri_ccod&" else c.peri_ccod end as peri_ccod,"& vbCrLf &_
		 "	 case c.asig_ccod when NULL then '"&asig_ccod&"' else c.asig_ccod end as asig_ccod,"& vbCrLf &_
		 "	 case c.jorn_ccod when NULL then b.jorn_ccod else c.jorn_ccod end as jorn_ccod,"& vbCrLf &_
		 "	 case c.moda_ccod when NULL then b.moda_ccod else c.moda_ccod end as moda_ccod,"& vbCrLf &_
		 "	 c.ssec_tdesc,c.ssec_nquorum, c.ssec_ncupo,c.ssec_finicio_sec,c.ssec_ftermino_sec,c.audi_tusuario,c.audi_fmodificacion,c.tsse_ccod "& vbCrLf &_
		 "	 from asignaturas a,secciones b, sub_secciones c "& vbCrLf &_
		 "	 where a.asig_ccod=b.asig_ccod "& vbCrLf &_
		 "	 and b.secc_ccod=c.secc_ccod"& vbCrLf &_
		 "	 and c.tsse_ccod=2"& vbCrLf &_
		 "	 and b.secc_ccod="&secc_ccod&")  s2"& vbCrLf &_
		 " where s1.ssec_ncorr>=s2.ssec_ncorr"& vbCrLf &_
		 " group by s1.ssec_ncorr, s1.secc_ccod,s1.sede_ccod,s1.carr_ccod,s1.peri_ccod,s1.asig_ccod,s1.jorn_ccod,s1.moda_ccod"& vbCrLf &_
		 " ,s1.ssec_tdesc,s1.ssec_nquorum, s1.ssec_ncupo,s1.ssec_finicio_sec,s1.ssec_ftermino_sec,s1.audi_tusuario,s1.audi_fmodificacion,s1.tsse_ccod "& vbCrLf &_
		 " order by correlativo"

'-------------------------------------------FIN-------------------------------------------------------
'consulta = " select '1' as correlativo, c.ssec_ncorr, c.secc_ccod,"& vbCrLf &_
'    	   " case c.sede_ccod when NULL then "&sede_ccod&" else c.sede_ccod end as sede_ccod,"& vbCrLf &_ 
'		   " case c.carr_ccod when NULL then "&carr_ccod&" else c.carr_ccod end as carr_ccod,"& vbCrLf &_
'		   " case c.peri_ccod when NULL then "&peri_ccod&" else c.peri_ccod end as peri_ccod,"& vbCrLf &_   
'		   " case c.asig_ccod when NULL then '"&asig_ccod&"' else c.asig_ccod end as asig_ccod,"& vbCrLf &_ 
'		   " case c.jorn_ccod when NULL then b.jorn_ccod else c.jorn_ccod end as jorn_ccod,"& vbCrLf &_  
'		   " case c.moda_ccod when NULL then b.moda_ccod else c.moda_ccod end as moda_ccod,"& vbCrLf &_  
'          " c.ssec_tdesc,c.ssec_nquorum, c.ssec_ncupo,c.ssec_finicio_sec,c.ssec_ftermino_sec,c.audi_tusuario,c.audi_fmodificacion,c.tsse_ccod "& vbCrLf &_
'          " from asignaturas a,secciones b, sub_secciones c "& vbCrLf &_
'          " where a.asig_ccod=b.asig_ccod " & vbCrLf &_
'          " and b.secc_ccod=c.secc_ccod" & vbCrLf &_
'          " and c.tsse_ccod=2" & vbCrLf &_
'          " and b.secc_ccod=" & secc_ccod 
'response.Write("<pre>"&consulta&"</pre>")		      		   
fsecc_asig.consultar consulta

consulta_titulo = "Select (select carr_tdesc from carreras where cast(carr_ccod as varchar)='" & carr_ccod & "') as carr_tdesc," & _
                  "       (select asig_ccod  from asignaturas where cast(asig_ccod as varchar)='" & asig_ccod & "') as asig_ccod, " & _
				  "		  (select asig_tdesc from asignaturas where cast(asig_ccod as varchar)='" & asig_ccod & "') as asig_tdesc " 
				 
				   
ftitulo.consultar consulta_titulo

ftitulo.siguiente
'--------------------------debemos ver si el usuario es del departamento de docencia o nop------------------------
usuario_secion = negocio.obtenerUsuario
'response.Write("select count(*) from personas a, sis_roles_usuarios b where a.pers_ncorr=b.pers_ncorr and cast(a.pers_nrut as varchar)='"&usuario_secion&"' and srol_ncorr = 27")
de_docencia = conexion.consultaUno("select count(*) from personas a, sis_roles_usuarios b where a.pers_ncorr=b.pers_ncorr and cast(a.pers_nrut as varchar)='"&usuario_secion&"' and srol_ncorr = 27")

if de_docencia > "0" then
	sys_cierra_planificacion = false
end if

if usuario_secion <> "8516097" and usuario_secion <> "10070749" then
	sys_cierra_planificacion = true
end if
sys_cierra_planificacion = false

%>


<html>
<head>
<title>Detalle Secciones Asignatura</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript" type="text/JavaScript">

function subsecciones(seccion) {
	formulario = document.forms[0];
	
	formulario.action = "subsecciones.asp";
	formulario.submit();
}

function compara(formulario)
{
	var num_elementos=formulario.length;
	nro=null;
	filaAnterior=null;
	flag=true;
	for (i=0;i < num_elementos;i++){
		var numeroE= new RegExp("([0-9]+)","gi");
		var campoCupoE= new RegExp("secc_ncupo","gi");
		var campoQuorumE= new RegExp("(secc_nquorum)","gi");
		nombre = formulario.elements[i].name;
		if ((numeroA=numeroE.exec(nombre))!=null){
				nro = numeroA[1];
		}
		if (campoCupoE.test(nombre)){
				cupo = formulario.elements[i].value;
			}
		 if (campoQuorumE.test(nombre)){
			quorum = formulario.elements[i].value;
			if (quorum >= 0) {
				if(cupo<quorum){ 
					alert("Existe un cupo menor que la cantidad mínima de alumnos")
					return (false);				
				}
			}
			else{
				alert('Ingrese un número mayor o igual a 0');
				return (false);
			}
		}
			filaActual = nro;
			if ( filaActual != filaAnterior ){
				flag=false;
				filaAnterior = filaActual;
			}
		}
	return (true);	
}


function modificar(formulario){
	if(preValidaFormulario(document.buscador)){
		   if(compara(formulario)){
		   	return(valida(document.buscador));
			}
	}
	return (false);
}

function proc_btn_clickeado(formulario,boton){
	formulario.btn_clickeado.value = boton;
	if (boton != '3'){
	  if(modificar(formulario)){
	  formulario.submit();
	  }
	 }
	else{
	 formulario.submit();
	}
}


function valida(formulario) {
	nroElementos = formulario.elements.length;
	j=1;
	flag = true;
		for(i=0; i < nroElementos ; i++ ) {
			var expresion = new RegExp('(secc_finicio|secc_ftermino)','gi');
			if (expresion.test(formulario.elements[i].name) ) {
				switch(j%2) {
					case 1 :
						fechaInicio = formulario.elements[i].value;
						break;
					case 0 :
						fechaTermino = formulario.elements[i].value;
						if(!comparaFechas(fechaTermino,fechaInicio)) {
							flag=false;
						}
						break;
				}
				j++;
			}
		}
		if(!flag) {
			alert('Complete correctamente las fechas del formulario');
		}
	return(flag);
}

function anterior(formulario){
url = '<%= pagina %>';
 formulario.action = url;
 formulario.submit();
}	
</script>

</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" cellpadding="0" cellspacing="0">
  <tr>
  </tr>
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
<form action="subsecciones_proc.asp" method="post" name="buscador" >
	<table width="68%" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
            <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
            <tr>
              <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
            </tr>
            <tr>
              <td bgcolor="#D8D8DE"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td bgcolor="#D8D8DE"><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="560" height="8" border="0"></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
            </tr>
            <tr>
              <td bgcolor="#D8D8DE"><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td bgcolor="#D8D8DE"><table width="90%" border="0" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
                  <tr>
                    <td width="8" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="221" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif"> <b><font color="#FFFFFF">ADMINISTRAR
                        SUBSECCIONES</font></b></font></div></td>
                    <td width="265"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="9" bgcolor="#D8D8DE">&nbsp;</td>
                  </tr>
                </table>
              </td>
              <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
            </tr>
            <tr>
              <td height="2"><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="560" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
            </tr>
          </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"> &nbsp;
					<input type="hidden" name="secc_ccod" value="<%=secc_ccod%>">
					<input type="hidden" name="sede_ccod" value="<%=sede_ccod%>">
					<input type="hidden" name="carr_ccod" value="<%=carr_ccod%>">
					<input type="hidden" name="peri_ccod" value="<%=peri_ccod%>">
					<input type="hidden" name="asig_ccod" value="<%=asig_ccod%>">
                    <input type="hidden" name="btn_clickeado" value="">
                    <br>
									   	 <%if sys_cierra_planificacion=true then response.Write("<br/><font color='blue'>"&sys_info_cierre_planificacion&"</font><br/>") end if%>

        <table width="98%" align="center" cellpadding="0" cellspacing="0">
          <tr> 
            <td align="center"><table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td align="right" >
                  <% ftitulo.dibujaEtiqueta("carr_tdesc") %>
      : </td>
                <td > <strong>
                  <% ftitulo.dibujaCampo("carr_tdesc") %>
                </strong> </td>
              </tr>
              <tr>
                <td align="right">
                  <% ftitulo.dibujaEtiqueta("asig_ccod") %>
      : </td>
                <td> <strong>
                  <% ftitulo.dibujaCampo("asig_ccod") %>
      -
      <% ftitulo.dibujaCampo("asig_tdesc") %>
                </strong> </td>
                <td align="right"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b>
                  <%fsecc_asig.accesoPagina %>
                </b></font></strong></font></strong></font></strong></font></strong><b> </b></font></strong></font></strong></font></strong></font></strong></font></strong></font></strong></font></td>
              </tr>
            </table>
              <font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><br>
              </b></font></strong></font></strong><b> </b></font></strong></font></strong></font></strong></font></strong></font>
              <table width="98%" height="200" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td align="center" valign="top"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><b>Subsecciones
                                Pr&aacute;cticas </b></font></strong></font></strong></font>
                      <%fsecc_asig.dibujaTabla %>
                      <br>
                  </td>
                </tr>
              </table>              <font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><br>
              </b><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b> 
              </b><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b> 
              </b></font></strong></font></strong></font></strong></font></strong></font></strong></font></strong></font> 
              <font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b> 
              </b></font></strong></font></strong></font></strong></font></strong></font></strong></font></strong></font> 
              </tr>
        </table>
                    <br>
                </td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                <td width="307" bgcolor="#D8D8DE"><table width="94%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
					<%if sys_cierra_planificacion=false then%>
                      <td width="21%"><div align="center">
                          <%botonera.dibujaboton "eliminar"%>
                        </div>
                      </td>
                      <td width="25%"><div align="center">
                          <%botonera.dibujaboton "guardar"%>
                        </div>
                      </td>
                      <td width="31%"><div align="center">
                          <%botonera.dibujaboton "agregar"%>
                        </div>
                      </td>
					  <%end if%>
                      <td width="23%"><div align="center">
                          <%botonera.dibujaboton "anterior"%>
                        </div>
                      </td>
                    </tr>
                  </table>
                </td>
                <td width="55" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
</form>
</td>
  </tr>  
</table>
</body>
</html>
