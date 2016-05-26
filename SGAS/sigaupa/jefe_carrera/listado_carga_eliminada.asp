 <!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
 Response.Buffer = True
 Response.ExpiresAbsolute = Now() - 1
 Response.Expires = 0
 Response.CacheControl = "no-cache" 
 
set pagina = new CPagina
pagina.Titulo = "Carga Académica eliminada del Alumno"

'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "elimina_carga_academica.xml", "BotoneraTomaCarga"

'------------------------------------------------------------------------------------------------------
'-------------------------para anularle el derecho de ingreso a los directores de carrera--------------
usuario_temporal = negocio.obtenerUsuario
pers_ncorr_usuario = conectar.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario_temporal&"'")
autorizado_carga = conectar.consultaUno("Select isnull(count(*),0) from sis_roles_usuarios where srol_ncorr=2 and cast(pers_ncorr as varchar)='"&pers_ncorr_usuario&"'")
'response.Write("Select isnull(count(*),0) from sis_roles_usuarios where srol_ncorr=2 and cast(pers_ncorr as varchar)='"&pers_ncorr_usuario&"'")
if autorizado_carga > "0" then
	sys_cierra_toma_carga = false
end if	
'response.Write("sys_cierra_toma_carga "&sys_cierra_toma_carga&" autorizado "&autorizado_carga)
'-----------------------------------------------FIN---------------------------------------------------- 
'---------------------------------------------------------------------------------------------------
pers_nrut = request.QueryString("rut")
pers_xdv = request.QueryString("dv")
peri_ccod = negocio.obtenerPeriodoAcademico("TOMACARGA")
v_plec_ccod = conectar.ConsultaUno("select plec_ccod from periodos_academicos where cast(peri_ccod as varchar) = '" & peri_ccod & "'")
sede_ccod = negocio.obtenerSede

 texto_1 = " SELECT matr_ncorr " & vbCrLf &_
         " FROM personas a, alumnos b, ofertas_academicas c " & vbCrLf &_
         " WHERE a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
         " AND b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
         " AND cast(pers_nrut as varchar) = '"& pers_nrut &"' " & vbCrLf &_
         " AND peri_ccod = '"& peri_ccod &"' " & vbCrLf &_
         " AND sede_ccod = '"& sede_ccod &"' " & vbCrLf &_
         " and emat_ccod = 1 " 		
  
 matr_ncorr =  conectar.consultaUno(texto_1) 
 'response.Write("<pre>"&texto_1&"</pre>")
 pers_ncorr = conectar.consultaUno ("select pers_ncorr from personas where cast(pers_nrut as varchar)='" & pers_nrut & "' ")
 nombre = conectar.consultaUno ("select pers_tape_paterno + ' ' + pers_tape_materno + ', ' + pers_tnombre from personas where cast(pers_ncorr as varchar) ='" & pers_ncorr & "'")
 carrera = conectar.consultaUno ("select carr_tdesc from carreras a, especialidades b, planes_estudio c, alumnos d where a.carr_ccod=b.carr_ccod and b.espe_ccod=c.espe_ccod and c.plan_ccod=d.plan_ccod and cast(matr_ncorr as varchar) ='" & matr_ncorr & "' and d.emat_ccod=1")

set formulario 	= new cformulario
formulario.carga_parametros "elimina_carga_academica.xml", "carga_eliminada"
formulario.inicializar conectar

sql_carga_eliminada = " select c.asig_ccod, c.asig_tdesc,b.secc_tdesc, a.cael_nresolucion as resolucion,a.cael_tobservacion as comentario, " & vbCrLf & _
					  " cast(d.pers_nrut as varchar)+'-'+d.pers_xdv as rut_encargado, d.pers_tnombre + ' ' + d.pers_tape_paterno + ' ' +d.pers_tape_materno as encargado, " & vbCrLf & _
					  " protic.trunc(a.audi_fmodificacion) as fecha_eliminacion  " & vbCrLf & _
					  " from cargas_eliminadas a,secciones b,asignaturas c,personas d   " & vbCrLf & _
					  " where a.secc_ccod = b.secc_ccod   " & vbCrLf & _
					  " and b.asig_ccod = c.asig_ccod   " & vbCrLf & _
					  " and cast(a.matr_ncorr as varchar) = '"&matr_ncorr&"' " & vbCrLf & _
					  " and a.audi_tusuario = cast(d.pers_nrut as varchar)" & vbCrLf & _
					  " order by c.asig_tdesc " 
'response.Write(sql_carga_eliminada)					  
formulario.consultar sql_carga_eliminada

'response.End()
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
    formulario.dv.value =formulario.dv.value.toUpperCase();
  	if(preValidaFormulario(formulario)){
	   if(!(valida_rut(formulario.rut.value + '-' + formulario.dv.value))){
	      alert('El RUT que Ud. ha ingresado no es válido.Por favor, ingréselo nuevamente.');
	      formulario.rut.focus();
	      formulario.rut.select();
	   }
       else{	
	      formulario.submit();
	   }
	}   
 }

</script>
<STYLE type="text/css">
 <!-- 
 A {color: #000000;  text-decoration: none; font-weight: bold;}
 A:hover {COLOR: #63ABCC; }

 // -->
 </STYLE>
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
.anchofijo {
	font-family: "Courier New", Courier, mono;
	font-size: 10px;
	width: 350px;
}
-->
</style>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td nowrap> <div align="center"></div></td>
                        <td> <div align="center">I<font size="1" face="Verdana, Arial, Helvetica, sans-serif">ngrese 
                            el RUT del alumno : 
                            <input name="rut" type="text" ID="NU-N" value="<%=pers_nrut%>" size="10" maxlength="8">
                            - 
                            <input name="dv" type="text" ID="LN-N" value="<%=pers_xdv%>" size="2" maxlength="1" >
                            <%pagina.DibujarBuscaPersonas "rut", "dv"%><br>
                            </font></div></td></tr>
      </table></div></td>
                  <td width="19%"><div align="center"><%f_botonera.DibujaBoton "buscar"%></div></td>
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
                </div><%
if nombre <> "" then
%>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr><br>
                <td width="80">RUT</td>
                <td>: <%= pers_nrut %>-<%= pers_xdv %></td>
              </tr>
              <tr>
                <td>Nombre</td>
                <td>: <%= nombre %></td>
              </tr>
              <tr>
                <td>Carrera</td>
                <td>: <%= carrera %></td>
              </tr>
			  </table>
<%
end if
%>		
              <form name="edicion">
			  <input type="hidden" name="matr_ncorr" value="<%=matr_ncorr%>">
			  <%if nombre <> "" then%>
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Carga Académica Eliminada"%>
                      <br> <%formulario.dibujatabla()%>                     </td>
                  </tr>
                </table>
                <br>
                <%end if%>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="16%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                   <td><div align="center">
                    <%f_botonera.DibujaBoton "SALIR"%>
                  </div></td>
                </tr>
              </table>
            </div></td>
            <td width="84%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
</body>
</html>
