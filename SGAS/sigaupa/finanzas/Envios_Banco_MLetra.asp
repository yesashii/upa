<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO:GESTIÓN DE DOCUMENTOS
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:12/03/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			:111
'********************************************************************
set pagina = new CPagina
pagina.Titulo = "Detalle de las Letras"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'---------------------------------------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
folio_envio = Request.QueryString("folio_envio")
rut_apoderado = Request.QueryString("rut_apoderado")
rut_alumno = Request.QueryString("rut_alumno")
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Envios_banco.xml", "botonera"
'-----------------------------------------------------------------------
set f_datos = new CFormulario
f_datos.Carga_Parametros "Envios_Banco.xml", "f_detalle_agrupado"
f_datos.Inicializar conexion
consulta =  "select protic.obtener_nombre_completo(a.pers_ncorr,'N') as nombre_apoderado , protic.obtener_rut(a.pers_ncorr) as c_rut_apoderado "&_ 
				"from personas a "&_ 
				"where cast(a.pers_nrut as varchar) = '" & rut_apoderado  &"'"
  
f_datos.Consultar consulta
f_datos.Siguiente

'----------------------------------------------------------------------
set f_letras = new CFormulario

f_letras.Carga_Parametros "Envios_Banco.xml", "f_detalle_letras"
f_letras.Inicializar conexion
consulta = "SELECT a.envi_ncorr, b.ding_ndocto,b.denv_fretorno, b.ting_ccod, d.ting_tdesc, e.ingr_ncorr, "&_
       "f.pers_ncorr, i.post_ncorr, h.pers_nrut, h.pers_xdv, cast(h.pers_nrut as varchar) + '-' + h.pers_xdv as rut_alumno, "&_
	   "g.pers_nrut as code_nrut, g.pers_xdv as code_xdv, cast(g.pers_nrut as varchar) + '-' + g.pers_xdv as rut_apoderado, "&_
	   "i.peri_ccod, g.pers_tnombre + ' ' + g.pers_tape_paterno as nombre_apoderado, "&_
       "e.ding_ndocto, c.edin_tdesc, e.ding_fdocto, e.ding_mdocto, f.ingr_fpago "&_
  "FROM envios a, "&_
       "detalle_envios b, "&_
       "estados_detalle_ingresos c, "&_
       "tipos_ingresos d, "&_
       "detalle_ingresos e, "&_
       "ingresos f, "&_
       "personas h, "&_
       "postulantes i, "&_
       "codeudor_postulacion j, "&_
	   "personas g "&_
 "WHERE (e.DING_NCORRELATIVO = 1 "&_ 
        "AND a.envi_ncorr = b.envi_ncorr "&_
        "AND b.ting_ccod = d.ting_ccod "&_
        "AND e.ting_ccod = b.ting_ccod "&_
        "AND e.ding_ndocto = b.ding_ndocto "&_ 
        "AND f.ingr_ncorr = e.ingr_ncorr "&_
        "AND i.pers_ncorr = f.pers_ncorr "&_
        "AND h.pers_ncorr = i.pers_ncorr "&_
        "AND j.post_ncorr = i.post_ncorr "&_
        "AND e.edin_ccod = c.edin_ccod "&_
		"AND j.pers_ncorr = g.pers_ncorr "&_
        "AND a.envi_ncorr =" & folio_envio & " "&_
        "AND cast(g.pers_nrut as varchar) = '" & rut_apoderado & "' "&_ 
        "AND i.peri_ccod ="  & Periodo & ")"

'	consulta =  "SELECT b.ding_ndocto,c1.edin_tdesc, d.ingr_fpago as ingr_fpago, c.ding_fdocto as ding_fdocto,  cast(c.ding_mdocto as integer) as ding_mdocto  "&_ 
'				"FROM envios a, detalle_envios b, detalle_ingresos c, estados_detalle_ingresos c1,  "&_ 
'					 "ingresos d, personas e, personas f   "&_ 
'				"WHERE c.DING_NCORRELATIVO = 1  "&_ 
'				  "and a.envi_ncorr = b.envi_ncorr "&_  
'				  "and b.ting_ccod = c.ting_ccod  "&_ 
'				  "and b.ding_ndocto = c.ding_ndocto "&_  
'				  "and b.ingr_ncorr = c.ingr_ncorr  "&_ 
'				  "and c.ingr_ncorr = d.ingr_ncorr  "&_ 
'				  "and b.edin_ccod = c1.edin_ccod  "&_ 
'				  "and d.pers_ncorr = e.pers_ncorr "&_ 
'				  "and c.PERS_NCORR_CODEUDOR *= f.pers_ncorr "&_ 
'				  "and cast(e.pers_nrut as varchar) ='" & rut_alumno & "' "&_
'				  "and cast(f.pers_nrut as varchar) ='" & rut_apoderado & "' "&_  
'				  "and cast(a.envi_ncorr as varchar)='" & folio_envio & "'"

	consulta =  "SELECT b.ding_ndocto,c1.edin_tdesc, d.ingr_fpago as ingr_fpago, c.ding_fdocto as ding_fdocto,  cast(c.ding_mdocto as integer) as ding_mdocto  "&_ 
				"FROM envios a "&_
				"INNER JOIN detalle_envios b "&_
				"ON a.envi_ncorr = b.envi_ncorr "&_
				"INNER JOIN detalle_ingresos c "&_
				"ON b.ting_ccod = c.ting_ccod and b.ding_ndocto = c.ding_ndocto and b.ingr_ncorr = c.ingr_ncorr AND c.DING_NCORRELATIVO = 1 "&_
				"INNER JOIN ingresos d "&_
				"ON c.ingr_ncorr = d.ingr_ncorr "&_
				"INNER JOIN estados_detalle_ingresos c1 "&_
				"ON b.edin_ccod = c1.edin_ccod "&_
				"INNER JOIN personas e "&_
				"ON d.pers_ncorr = e.pers_ncorr  "&_
				"LEFT OUTER JOIN  personas f "&_
				"ON c.PERS_NCORR_CODEUDOR = f.pers_ncorr "&_
				"WHERE cast(e.pers_nrut as varchar) = '" & rut_alumno & "' "&_
				  "and cast(f.pers_nrut as varchar) ='" & rut_apoderado & "' "&_  
				  "and cast(a.envi_ncorr as varchar)='" & folio_envio & "'"

f_letras.Consultar consulta
'response.Write(consulta)
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

</script>
<script language='javaScript1.2'> 
  colores = Array(3);
  colores[0] = ''; 
  colores[1] = '#97AAC6'; 
  colores[2] = '#C0C0C0'; 
</script>

</head>
<body  bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr> <td>
  <table width="90" border="0" align="center" cellpadding="0" cellspacing="0">
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
             <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="100%" height="8" border="0"></td>
             <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
           </tr>
           <tr>
             <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
             <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                 <tr>
                   <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                   <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                     <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Detalles
                        de las Letras</font></div>
                   </td>
                   <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                 </tr>
               </table>
             </td>
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
               <td width="9" align="left" background="../imagenes/izq.gif"></td>
               <td bgcolor="#D8D8DE"> 
                   <form name="edicion">
                    <div align="center"><BR>
                      <%pagina.DibujarTituloPagina%>
                      <BR><BR>
                    </div>
                    <table width="513" border="0">
                      <tr> 
                        <td width="20">&nbsp;</td>
                        <td width="135">Rut Apoderado</td>
                        <td width="31">:</td>
                        <td width="309"><% f_datos.DibujaCampo ("c_rut_apoderado")  %> </td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>Nombre Apoderado</td>
                        <td>:</td>
                        <td><% f_datos.DibujaCampo ("nombre_apoderado")  %> </td>
                      </tr>
                    </table>
                   <div align="center"><BR>
                      <% f_letras.dibujatabla() %>
                     </div>
                   </form>
                   <br>
               </td>
               <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
             </tr>
           </table>
           <table width="100%" border="0" cellspacing="0" cellpadding="0">
             <tr>
               <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
               <td width="116" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                   <tr>
                     <td><div align="center">
                         <%botonera.DibujaBoton "cancelar" %>
                       </div>
                     </td>
                    </tr>
                 </table>
               </td>
               <td width="246" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
               <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
             </tr>
             <tr>
               <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
             </tr>
           </table>
        </td>
     </tr>
   </table></td>
</tr>
</table>
</body>
</html>
