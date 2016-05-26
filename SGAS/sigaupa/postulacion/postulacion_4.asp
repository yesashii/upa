<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
v_post_ncorr = Session("post_ncorr")

if EsVacio(v_post_ncorr) then
	Response.Redirect("inicio.asp")
end if

Sql_parientes = " Select pp.pers_ncorr, pp.pers_tnombre+' '+ pp.pers_tape_paterno+' '+pp.pers_tape_materno as nombre_familiar," & VBCRLF  	& _
				" cast(pp.pers_nrut as varchar)+'-'+cast(pp.pers_xdv as varchar) as rut_familiar, pp.pers_fnacimiento,  " & VBCRLF  	& _
				" (select pare_tdesc from parentescos Where pare_ccod=gf.PARE_CCOD) as parentesco, gf.pare_ccod, pos.post_ncorr " & VBCRLF  	& _
				" from postulantes pos, grupo_familiar gf, personas_postulante pp " & VBCRLF  	& _
				" Where pos.post_ncorr='"&v_post_ncorr&"' " & VBCRLF  	& _
				" And pos.post_ncorr=gf.post_ncorr " & VBCRLF  	& _
				" And gf.pers_ncorr=pp.pers_ncorr " 

'set f_grilla = new CFormulario
'f_grilla.Carga_Parametros "postulacion_4.xml", "grilla_familiares"
'f_grilla.Inicializar conexion

'f_grilla.Consultar Sql_parientes
'f_grilla.Siguientef

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Postulación - Antecedentes Familiares"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.InicializaPortal conexion

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "postulacion_4.xml", "botonera"


'---------------------------------------------------------------------------------------------------
set f_grilla = new CFormulario
f_grilla.Carga_Parametros "postulacion_4.xml", "grilla_familiares"
f_grilla.Inicializar conexion

  
f_grilla.Consultar Sql_parientes

'###############	VERIFICA QUE EXISTA ALMENOS UN PARIENTE ANTES DE ENVIAR LA POSTULACION	###################
Sql_parientes_minimos = " Select count(*) as total " & VBCRLF  	& _
				" from postulantes pos, grupo_familiar gf, personas_postulante pp, parentescos pa " & VBCRLF  	& _
				" Where pos.post_ncorr='"&v_post_ncorr&"' " & VBCRLF  	& _
				" And pos.post_ncorr=gf.post_ncorr " & VBCRLF  	& _
				" And gf.pers_ncorr=pp.pers_ncorr " & VBCRLF  	& _
				" And gf.pare_ccod=pa.pare_ccod " & VBCRLF  	& _
				" And gf.pare_ccod not in (0) "
'response.Write("<pre>"&Sql_parientes_minimos&"<pre>")				
v_parientes =conexion.ConsultaUno(Sql_parientes_minimos)
if sys_exige_familiar=false then
	v_parientes="1"
end if
'v_parientes="1"' descomentar para dejarlo pasar sin parientes
'-------------------------------------------------------------------------------------



'-------------------------------------------------------------------------------------
v_epos_ccod = conexion.ConsultaUno("select epos_ccod from postulantes where post_ncorr = '" & v_post_ncorr & "'")

if v_epos_ccod = "2" then
	lenguetas_postulacion = Array(Array("Información general", "postulacion_1.asp"), Array("Datos Personales", "postulacion_2.asp"), Array("Ant. Académicos", "postulacion_3.asp"), Array("Ant. Familiares", "postulacion_4.asp"), Array("Apoderado Sostenedor", "postulacion_5.asp"))
	msjRecordatorio = "Se ha detectado que esta postulación ya ha sido enviada.  Si va a realizar cambios en la información de esta página, presione el botón ""Siguiente"" para guardarlos."
else
	lenguetas_postulacion = Array("Información general", "Datos Personales", "Ant. Académicos", "Ant. Familiares", "Apoderado Sostenedor", "Envío de Postulación")
	msjRecordatorio = ""
end if

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
<script language="JavaScript" src="../biblioteca/dicc_ciudades.js"></script>
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>

<script language="JavaScript">
function agregar_familiar(){
	//alert("levantar ventana familiares...");
	window.open("postulacion_4_familiares.asp","familiares"," resize=yes, width=770,height=400, scrollbars=yes, top=10,left=10");
}
function eliminar_familiar(form){
	form.submit
}

function Validar_Familiares(){
var v_parientes;
v_parientes=<%=v_parientes%>;
	if (v_parientes > 0){
		_Navegar(document.edicion, 'postulacion_5.asp', 'FALSE');
	}else{
		alert("Debe ingresar al menos un familiar para continuar el proceso de postulacion.")
	}
}

</script>

<style type="text/css">
<!--
.style1 {color: #FF0000}
.Estilo2 {color: #FF0000; font-weight: bold; }
-->
</style>
</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); " >
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">  
  <tr>
    <td valign="top" bgcolor="#e1eae0">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td colspan="3" valign="top" bgcolor="#FFFFFF" width="750" align="center">
    <img src="../imagenes/vineta2_r1_c1_2016.jpg" width="750" height="100"/>
    </td>
  </tr>
  <tr>
    <td valign="top" bgcolor="#FFFFFF">
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
            <td><%				
				pagina.DibujarLenguetas lenguetas_postulacion, 4
				%></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTitulo "FICHA DE POSTULACION ANTECEDENTES FAMILIARES" %>
              <br>
              <br>
              <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td><div align="justify"><%=msjRecordatorio%></div></td>
                </tr>
              </table>
</div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Familiares"%>                      
						  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
							<tr>
							  <td align="center">
							  <%f_grilla.DibujaTabla() %>
								</td>
							</tr>
						  </table>
						  <br>
         	 		</td>
                  </tr>
				  <tr>
				  	<td>
					<table width="100%" >
					<tr>
						<td width="80%"></td>
						<td><div align="right"> <%f_botonera.DibujaBoton("agregar_familiar")%></div></td>
						<td><div align="right"> <%f_botonera.DibujaBoton("eliminar_familiar")%></div></td>
					</tr>
					</table>
					</td>
				  </tr>
                </table>
            </form>
			
			
			</td></tr>
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
                  <td><div align="center"><%f_botonera.DibujaBoton("anterior")%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("siguiente")%>
                  </div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("salir")%>
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
</td>
</tr>
</table>
</body>
</html>
