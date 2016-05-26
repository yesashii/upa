<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
bhot_ccod= request.QueryString("bhot_ccod")
set pagina = new CPagina
pagina.Titulo = "Relatores por horario"

set botonera =  new CFormulario
botonera.carga_parametros "asignar_relator_programa.xml", "btn_agregar_relator"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores 	= new cErrores

dcur_tdesc = conexion.consultauno("SELECT lower(dcur_tdesc) FROM datos_generales_secciones_otec a,diplomados_cursos b, secciones_otec c, bloques_horarios_otec d WHERE a.dcur_ncorr=b.dcur_ncorr and a.dgso_ncorr=c.dgso_ncorr and c.seot_ncorr=d.seot_ncorr and cast(d.bhot_ccod as varchar)= '" &bhot_ccod & "' ")
sede_tdesc = conexion.consultauno("SELECT sede_tdesc FROM datos_generales_secciones_otec a,sedes b, secciones_otec c, bloques_horarios_otec d WHERE a.sede_ccod=b.sede_ccod and a.dgso_ncorr=c.dgso_ncorr and c.seot_ncorr=d.seot_ncorr and cast(d.bhot_ccod as varchar)= '" &bhot_ccod & "' ")
dgso_ncorr = conexion.consultauno("SELECT a.dgso_ncorr FROM datos_generales_secciones_otec a, secciones_otec c, bloques_horarios_otec d WHERE a.dgso_ncorr=c.dgso_ncorr and c.seot_ncorr=d.seot_ncorr and cast(d.bhot_ccod as varchar)= '" &bhot_ccod & "' ")
anos_ccod  = conexion.consultauno("SELECT anio_admision FROM ofertas_otec WHERE cast(dgso_ncorr as varchar)= '" &dgso_ncorr & "' ")


lenguetas_masignaturas = Array(Array("Relatores por horario", "#"))

'-----------------------------------------planificación de la sección----------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "asignar_relator_programa.xml", "f_relatores_horario"
formulario.inicializar conexion

if bhot_ccod <> "" then
consulta =" select cast(d.pers_nrut as varchar)+ '-' + d.pers_xdv as rut, d.pers_tape_paterno + ' ' + d.pers_tape_materno + ', ' + d.pers_tnombre as nombre, d.pers_ncorr, a.bhot_ccod, c.trot_tdesc as tipo " & vbCrlf & _
		  " from bloques_horarios_otec a, bloques_relatores_otec b, tipos_relatores_otec c, personas d " & vbCrlf & _
		  " where cast(a.bhot_ccod as varchar)='"&bhot_ccod&"' " & vbCrlf & _
		  " and a.bhot_ccod=b.bhot_ccod and isnull(b.trot_ccod,1) = c.trot_ccod and b.pers_ncorr=d.pers_ncorr" & vbCrlf & _
		  " order by nombre asc " 
end if
'response.Write("<pre>"&consulta&"</pre>")
formulario.consultar consulta 


set formulario_relator = new cformulario
formulario_relator.carga_parametros "asignar_relator_programa.xml", "asignar_relator"
formulario_relator.inicializar conexion

consulta = " select "&bhot_ccod&" as bhot_ccod " 
formulario_relator.consultar consulta 
formulario_relator.siguiente
formulario_relator.agregaCampoParam "pers_ncorr", "destino","(select b.pers_ncorr, pers_tnombre + ' ' + pers_tape_paterno as nombre from relatores_programa a, personas b where a.pers_ncorr=b.pers_ncorr and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and anos_ccod="&anos_ccod&")aa"
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

function guardar(formulario){

if(preValidaFormulario(formulario))
    {	
    	formulario.action ='actualizar_modulos.asp';
		formulario.submit();
	}
	
}
function cerrar(){
	CerrarActualizar();
}

function enviar(formulario){
	formulario.action ='actualizar_bloque.asp';
	//if(preValidaFormulario(formulario)){
	  formulario.submit();
	  
	//}
	
}

function revision()
{ var i=0;
  var formulario = document.edicion;
  var seot_finicio = '<%=seot_finicio%>';
  var seot_ftermino = '<%=seot_ftermino%>';
  var mensaje_error = "";
  
  array_inicio_seccion = seot_finicio.split('/');     
  array_termino_seccion = seot_ftermino.split('/');

  dia_inicio = array_inicio_seccion[0];
  mes_inicio  = array_inicio_seccion[1];
  agno_inicio = array_inicio_seccion[2];
  dia_termino = array_termino_seccion[0];
  mes_termino  = array_termino_seccion[1];
  agno_termino = array_termino_seccion[2];
 // con formatos mm/dd/yyyy
 fecha_inicio_seccion = mes_inicio+'/'+dia_inicio+'/'+agno_inicio;
 fecha_termino_seccion = mes_termino+'/'+dia_termino+'/'+agno_termino;
// convertir a milisegundos
 m_fecha_inicio_s  = Date.parse(fecha_inicio_seccion);
 m_fecha_termino_s = Date.parse(fecha_termino_seccion);

    	inicio = formulario.elements["pl[0][bhot_finicio]"].value;
		termino = formulario.elements["pl[0][bhot_ftermino]"].value;
		array_inicio = inicio.split('/');     
        array_termino = termino.split('/');

		dia_inicio1 = array_inicio[0];
		mes_inicio1  = array_inicio[1];
		agno_inicio1 = array_inicio[2];
		dia_termino1 = array_termino[0];
		mes_termino1  = array_termino[1];
		agno_termino1 = array_termino[2];
				// con formatos mm/dd/yyyy
		fecha_inicio_bloque = mes_inicio1+'/'+dia_inicio1+'/'+agno_inicio1;
		fecha_termino_bloque = mes_termino1+'/'+dia_termino1+'/'+agno_termino1;
		m_fecha_inicio_b  = Date.parse(fecha_inicio_bloque);
		m_fecha_termino_b = Date.parse(fecha_termino_bloque);
				//alert("inicio "+m_fecha_inicio_s+" termino "+m_fecha_termino_s);
				
		diferencia_b=eval(m_fecha_inicio_b - m_fecha_termino_b);
				
				if (diferencia_b <= 0 )
				{
					diferencia_pii = eval(m_fecha_inicio_b - m_fecha_inicio_s);
					diferencia_ptt = eval(m_fecha_termino_b - m_fecha_termino_s);
					//alert("ii "+diferencia_pii+" tt "+diferencia_ptt);
					if ((diferencia_pii < 0)||(diferencia_ptt > 0))
					{
						//alert("Existen un error en las fechas de la sección estan fuera del rango de las del programa");
						mensaje_error = "Existen un error en las fechas de los bloques a crear, estan fuera del rango de la sección";
						
					}

				}
				else
				{
				 //alert("La fecha de inicio de la sección no puede ser mayor a la de término");
				 mensaje_error = "La fecha de inicio del bloque no puede ser mayor a la de término";
				 //return false;
				}

if (mensaje_error == "")
	{
		return true;	
	}
else
	{
		alert(mensaje_error);
		return false;
	}	

}

</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="500" border="0" align="center" cellpadding="0" cellspacing="0" >
  <tr valign="middle">
    <td valign="top" bgcolor="#EAEAEA">
		<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
		  <tr>
			<td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
			<td height="8" background="../imagenes/top_r1_c2.gif"></td>
			<td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
		  </tr>
		  <tr>
			<td width="9" background="../imagenes/izq.gif">&nbsp;</td>
			<td>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td height="2" background="../imagenes/top_r3_c2.gif"></td>
					  </tr>
					  <tr>
						<td>
				<table width="100%"  border="0">
					  <tr>
						<td>&nbsp;</td>
					  </tr>
				 </table>
	
				 <table width="100%">
				 		<tr>
							<td><%response.Write("<strong>PROGRAMA: "&dcur_tdesc&"</strong>")%></td>
						  </tr>
						  <tr>
							<td><%response.Write("<strong>SEDE: "&sede_tdesc&"</strong>")%></td>
						  </tr>
						  <tr>
							<td>&nbsp;</td>
						  </tr>
						<form name="edicion2">
					    <tr>
						   <td><div align="center">
							  <%formulario.dibujatabla()%>
						      </div></td>
					    </tr>
						<tr>
						   <td align="right"><%botonera.dibujaboton "eliminar"%></td>
					    </tr>
						</form>
					<tr>
						<td colspan="2" align="right">&nbsp;</td>
					</tr>
					<form name="edicion3">
					<tr>
						<td colspan="2" align="center">
						  <table width="98%" cellpadding="0" cellspacing="0">
						    <tr>
								<td colspan="3" align="left"><font face="Verdana, Arial, Helvetica, sans-serif" color="#333333">Agregar Relator/Ayudante</font></td>
							</tr>
						    <tr>
								<td width="15%" align="left"><font face="Verdana, Arial, Helvetica, sans-serif"><strong>Relator</strong></font></td>
								<td width="1%" align="left"><font face="Verdana, Arial, Helvetica, sans-serif"><strong>:</strong></font></td>
								<td width="84%" align="left"><%formulario_relator.dibujaCampo("bhot_ccod")%><%formulario_relator.dibujaCampo("pers_ncorr")%></td>
							</tr>
							<tr>
								<td width="15%" align="left"><font face="Verdana, Arial, Helvetica, sans-serif"><strong>Tipo</strong></font></td>
								<td width="1%" align="left"><font face="Verdana, Arial, Helvetica, sans-serif"><strong>:</strong></font></td>
								<td width="84%" align="left"><%formulario_relator.dibujaCampo("trot_ccod")%></td>
							</tr>
							<tr>
								<td colspan="3" align="right"><%botonera.dibujaboton "guardar"%></td>
							</tr>
						  </table>						  
						</td>
					</tr>
					</form>
				 </table>
				</td>
			</tr>
			</table></td>
			<td width="7" background="../imagenes/der.gif">&nbsp;</td>
		  </tr>
		  <tr>
			<td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
			<td height="28"><table width="100%" height="28"  border="0" cellpadding?????="0" cellspacing="0">
			  <tr>
				<td width="38%" height="20"><div align="center">
				  <table width="90%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
					  <td><div align="center"><%botonera.dibujaboton "salir"%></div></td>
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
	</td>
  </tr>  
</table>
</body>
</html>
