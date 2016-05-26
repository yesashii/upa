<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
ofam_ncorr = request.QueryString("ofam_ncorr")
nom_carrera=  request.QueryString("nom_carrera")

q_facu_ccod= request.QueryString("test[0][facu_ccod]")
q_sede_ccod= request.QueryString("test[0][sede_ccod]")
q_anos_ccod= request.QueryString("test[0][anos_ccod]")
q_carr_ccod= request.QueryString("test[0][carr_ccod]")
'response.write "<pre>"&nom_carrera_ing&"</pre>"

set pagina = new CPagina
pagina.Titulo = "Mantenedor Oferta Academica "

set botonera =  new CFormulario
botonera.carga_parametros "adm_ofer_academica_min.xml", "btn_adm_carreras"
'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set errores = new CErrores


set f_busqueda =  new CFormulario
f_busqueda.carga_parametros	"adm_ofer_academica_min.xml",	"busqueda"
f_busqueda.inicializar		conectar
f_busqueda.consultar 		"select ''"
f_busqueda.siguiente
consulta_carrera=	"(select distinct d.carr_ccod,d.carr_tdesc " & vbCrlf & _ 
				  	"from alumnos a, ofertas_academicas b, especialidades c, carreras d, periodos_academicos e " & vbCrlf & _ 
				  	"where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod " & vbCrlf & _ 
				  	"and b.peri_ccod=e.peri_ccod and a.emat_ccod = 1 and a.alum_nmatricula <> 7777 " & vbCrlf & _ 
				  	"and e.anos_ccod >= 2008 and d.tcar_ccod = 1 ) a" 
					
f_busqueda.agregacampoparam "carr_ccod", "destino", consulta_carrera
f_busqueda.AgregaCampoCons "sede_ccod", q_sede_ccod
f_busqueda.AgregaCampoCons "anos_ccod", q_anos_ccod
f_busqueda.AgregaCampoCons "carr_ccod", q_carr_ccod
'---------------------------------------------------------------------------------------------------


if q_carr_ccod<>"" then
filtro1=filtro1&"and c.cod_carrera_min="&q_carr_ccod&""
end if

if q_sede_ccod<>"" then
filtro2=filtro2&"and e.sede_ccod="&q_sede_ccod&""
end if

if nom_carrera<>"" then
filtro3=filtro3&"and c.nom_carrera_ing like '%" & nom_carrera& "%'"
end if

	

if q_anos_ccod<>"" then
consulta= 	" select  a.ofam_ncorr, a.ofam_ncorr as eliminar , c.nom_carrera_min, e.sede_tdesc, b.jorn_tdesc,  f.anos_ccod , a.ofam_nduracion " & vbCrlf & _
			" from ufe_oferta_academica_min a, jornadas b, ufe_carreras_mineduc c , sedes e , anos f, ufe_carreras_homologadas g  " & vbCrlf & _
			" where a.jorn_ccod=b.jorn_ccod " & vbCrlf & _
			" and a.carr_ccod = g.carr_ccod " & vbCrlf & _
			" and a.anos_ccod=f.anos_ccod " & vbCrlf & _
			" and c.car_min_ncorr=g.car_min_ncorr " & vbCrlf & _
			" and a.sede_ccod=e.sede_ccod " & vbCrlf & _
			""&filtro1&""& vbCrlf & _
			""&filtro2&""& vbCrlf & _
			""&filtro3&""& vbCrlf & _
			"and a.anos_ccod="&q_anos_ccod&""& vbCrlf & _
			" order by nom_carrera_min" 
									
else

consulta="select ''"
end if
'response.write "<pre>"&consulta&"</pre>"
'response.End()			


set formulario 		= 		new cFormulario
formulario.carga_parametros	"adm_ofer_academica_min.xml",	"tabla"
formulario.inicializar		conectar
formulario.consultar 		consulta
'formulario.siguiente
'registros = formulario.nrofilas
'RESPONSE.end()
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

function enviar(formulario){
formulario.submit();
}
function agrega_carrera_antiguo(formulario){

	direccion="agregar_ofer_academica_min.asp?ofam_ncorr ="
	resultado=window.open(direccion, "ventana1","width=800,height=400,scrollbars=yes, left=0, top=0");
}
function agrega_carrera(formulario) {
	direccion = "agregar_ofer_academica_min.asp";
	resultado=window.open(direccion, "ventana1","width=800,height=400,scrollbars=no, left=380, top=350");
	
 // window.close();
}


</script>

</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <table width="100%" border="0">
                <tr>
                  <td width="29%">&nbsp;</td>
                  <td width="39%">
                        <div align="center">
                          <input type="text" name="nom_carrera" size="30" maxlength="50" onKeyDown="return bloquearTeclas(event.keyCode,this)" onKeyUp="this.value=this.value.toUpperCase()" ID="TO-S" >
                          <br>
  Nombre Carrera                        </div></td>
                  <td width="28%"><%botonera.dibujaboton "buscar"%></td>
                  <td width="4%" nowrap>&nbsp;</td>
                </tr>
              </table>
			   <table width="74%"  border="0" align="center">
					<tr>
					
				  	<td width="15%"><strong>Carreras:</strong></td>
				  	<td width="85%"><div align="left"><%f_busqueda.DibujaCampo("carr_ccod")%></div>
					
                </tr>
              </table>
              <table width="74%"  border="0" align="center">
					<tr>
					
				  	<td width="15%"><strong>Sedes:</strong></td>
				  	<td width="85%"><div align="left"><%f_busqueda.DibujaCampo("sede_ccod")%></div>
					
                </tr>
              </table>
               <table width="74%"  border="0" align="center">
					<tr>
					
				  	<td width="15%"><strong>Año Académico:</strong></td>
				  	<td width="85%"><div align="left"><%f_busqueda.DibujaCampo("anos_ccod")%></div>
					
                </tr>
              </table>
              </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
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
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                    <table width="650" border="0">
                      <tr> 
                        <td width="116">&nbsp;</td>
                        <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                            <%formulario.AccesoPagina%>
                          </div></td>
                        <td width="24"> <div align="right"> </div></td>
                      </tr>
                    </table>
                  </div>
              <form name="edicion">
			  <input name="registros" type="hidden" value="<%=registros%>">
                <div align="center"><%formulario.dibujatabla()%><br>
                </div>
              </form></td></tr>
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
                  <td><div align="center">
                    <%botonera.dibujaboton "AGREGAR"%>
                  </div></td>
                  <td><div align="center">
                    <%botonera.dibujaboton "eliminar"%>
                  </div></td>
				   
				  <td width="14%"> <div align="center">  <%
				                           botonera.agregabotonparam "excel_general", "url", "ofer_academica_excel.asp"
										   botonera.dibujaboton "excel_general"
										%>
					 </div>
                  </td>
                  <td><div align="center">
                    <%botonera.dibujaboton "SALIR"%>
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
<p>&nbsp;</p>
</body>
</html>
