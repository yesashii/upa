<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
set f_busqueda = new CFormulario
set conexion = new CConexion
set botonera = new CFormulario
set negocio = new CNegocio

conexion.Inicializar "upacifico"
negocio.Inicializa conexion

botonera.Carga_Parametros "lista_docentes.xml", "btn_lista"

Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
anos_ccod = conexion.consultaUno("select anos_ccod from periodos_Academicos where cast(peri_ccod as varchar)='"&Periodo&"'")

'-----------------------------------------------------------------------
pagina.Titulo = "Listado Docentes por Asignaturas"

'-----------------------------------------------------------------------

set f_listado = new CFormulario
f_listado.Carga_Parametros "lista_docentes.xml", "f_listado"
f_listado.Inicializar conexion

'------"	   and m.peri_ccod = n.peri_ccod   "& vbCrLf &_ ---------
				
				
consulta = " select distinct b.sede_tdesc as sede, c.carr_tdesc  as carrera,d.asig_ccod as cod_asig,d.asig_tdesc as asignatura, "& vbCrLf &_
		   " a.secc_tdesc as seccion,cast(g.pers_nrut as varchar) + '-' + g.pers_xdv as rut,g.pers_tnombre +' '+ g.pers_tape_paterno +' ' + "& vbCrLf &_
		   " g.pers_tape_materno as nombre,h.tpro_tdesc as tipo, i.peri_tdesc as periodo,protic.trunc(secc_finicio_sec) as finicio, "& vbCrLf &_
		   " protic.trunc(secc_ftermino_sec) as ftermino, j.duas_tdesc as duracion  "& vbCrLf &_
		   " from secciones a,sedes b,carreras c,asignaturas d,bloques_horarios e,bloques_profesores f,personas g, tipos_profesores h, "& vbCrLf &_
		   " periodos_academicos i,duracion_asignatura j  "& vbCrLf &_
		   " where a.sede_ccod=b.sede_ccod "& vbCrLf &_
		   " and a.carr_ccod=c.carr_ccod "& vbCrLf &_
		   " and a.asig_ccod=d.asig_ccod "& vbCrLf &_
		   " and a.secc_ccod=e.secc_ccod "& vbCrLf &_
		   " and e.bloq_ccod=f.bloq_ccod "& vbCrLf &_
		   " and f.pers_ncorr=g.pers_ncorr "& vbCrLf &_
		   " and f.tpro_ccod=h.tpro_ccod "& vbCrLf &_
		   " and a.peri_ccod=i.peri_ccod "& vbCrLf &_
		   " and d.duas_ccod = j.duas_ccod "& vbCrLf &_
		   " and cast(i.anos_ccod as varchar)='"&anos_ccod&"' "& vbCrLf &_
		   " order by b.sede_tdesc,c.carr_tdesc,d.asig_tdesc"
  	   
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_listado.Consultar consulta
cantidad=f_listado.nroFilas
'---------------------------------------------------------------------------------------------------
'set botonera = new CFormulario
'botonera.Carga_Parametros "Envios_Notaria.xml", "botonera"
%>


<html>
<head>
<title>Listado Docentes</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
</script>

<script language='javaScript1.2'> 
  colores = Array(3);
  colores[0] = ''; 
  colores[1] = '#97AAC6'; 
  colores[2] = '#C0C0C0'; 
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
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
                <td width="9"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="100%" height="8" border="0" alt=""></td>
              <td width="7"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><%pagina.DibujarLenguetas Array("Listado de asignaturas por sede"), 1%></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="100%" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  
                <td align="center" bgcolor="#D8D8DE"> <br>
                  <%pagina.DibujarTituloPagina%>
                  <br>
                  <br>
                  <table width="665" border="0">
                    <tr> 
                      <td width="116">&nbsp;</td>
                      <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                          <%f_listado.AccesoPagina%>
                        </div></td>
                      <td width="24"> <div align="right"> </div></td>
                    </tr>
                  </table> 
                  <form name="edicion">
                    <% f_listado.DibujaTabla %>
                    <br>
                  </form>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif"><img src="../imagenes/der.gif" width="7" height="10"></td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="206" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><div align="center"> 
                          <% if cint(cantidad)=0 then
						        botonera.agregabotonparam "excel", "deshabilitado" ,"TRUE"
						     end if
							 botonera.agregabotonparam "excel", "url", "lista_docentes_excel.asp"
						     botonera.DibujaBoton ("excel") %>
                        </div></td>
                      <td><div align="center"> 
                          <%botonera.DibujaBoton "salir" %>
                        </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="150" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="310" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
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
