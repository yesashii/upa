<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
seot_ncorr= request.QueryString("seot_ncorr")
dgso_ncorr = request.QueryString("dgso_ncorr")
bhot_ccod = request.QueryString("bhot_ccod")

'response.Write(bhot_ccod)
set pagina = new CPagina

if bhot_ccod = "" then
	pagina.Titulo = "Creación de Horarios"
else
	pagina.Titulo = "Editar Horarios"
end if
set botonera =  new CFormulario
botonera.carga_parametros "planificar_programa.xml", "btn_edicion_plan_acad"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores 	= new cErrores


sede_ccod = conexion.consultaUno("select sede_ccod from datos_generales_secciones_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")

'---------------------------------------------------------------------------------------------------
set formu_resul= new cformulario
formu_resul.carga_parametros "planificar_programa.xml", "edicion_bloque"

formu_resul.agregaCampoParam "pers_ncorr", "filtro", "cast(sede_ccod as varchar) = '" & sede_ccod &"'"
formu_resul.agregaCampoParam "hora_ccod", "filtro", "cast(sede_ccod as varchar) = '" & sede_ccod &"'"
formu_resul.agregaCampoParam "sala_ccod", "filtro", "cast(sede_ccod as varchar) = '" & sede_ccod &"'"

formu_resul.inicializar conexion
consulta = " select cast(c.mote_ccod as varchar) + ' - ' + a.seot_tdesc + ': ' + c.mote_tdesc as asignatura"&_
			   " from secciones_otec a, mallas_otec b,modulos_otec c "&_
			   " where a.maot_ncorr=b.maot_ncorr and b.mote_ccod=c.mote_ccod "&_
			   " and cast(a.seot_ncorr as varchar)='"&seot_ncorr&"'"
asignatura = conexion.consultaUno(consulta)
if bhot_ccod <> "" then
	consulta = "select a.*,  '" & asignatura & "' as secc_ccod_pres from bloques_horarios_otec a where cast(bhot_ccod as varchar)='"& bhot_ccod &"'"
else
    horas_seguidas = "Horas seguidas: <input type='text' name='horas' value='1' maxlength='1' size='2'>"
	consulta = "select isnull(maot_nhoras_programa,0) from secciones_otec a, mallas_otec b where cast(seot_ncorr as varchar) = '"& seot_ncorr &"' and a.maot_ncorr=b.maot_ncorr"
	horas = conexion.consultaUno(consulta)

	consulta = "select '" & b & "' as ssec_ncorr,  '" & asignatura & "' as secc_ccod_pres,  '" & _
				 c & "' as pers_ncorr,  " & sede_ccod & " as sede_ccod_pres, " &_ 
				 "'" & fInicio & "' as bhot_finicio,  '" & fTermino & "' as bhot_ftermino"  
end if


'response.Write(consulta)
formu_resul.consultar consulta 

if b<>"" then
	formu_resul.agregaCampoCons "secc_ccod", secc_ccod
end if

formu_resul.siguiente

seot_finicio = conexion.consultaUno("select protic.trunc(seot_finicio) from secciones_otec where cast(seot_ncorr as varchar)='"&seot_ncorr&"'")
seot_ftermino = conexion.consultaUno("select protic.trunc(seot_ftermino) from secciones_otec where cast(seot_ncorr as varchar)='"&seot_ncorr&"'")



lenguetas_masignaturas = Array(Array("Agregar horario", "planificar_horario.asp?seot_ncorr="&seot_ncorr&"&dgso_ncorr="&dgso_ncorr))
'response.Write("doras "&horas_Asignatura&" duracion "&duracion_asignatura)


'-----------------------------------------planificación de la sección----------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "planificar_programa.xml", "f_horario"
formulario.inicializar conexion

if seot_ncorr <> "" then
consulta =" select a.dias_ccod,a.bhot_ccod,a.seot_ncorr,f.dgso_ncorr,b.dias_tdesc as dia,c.hora_tdesc as bloque,d.sede_tdesc as sede,e.sala_tdesc as sala, " & vbCrlf & _
		  " protic.trunc(bhot_finicio) as finicio, protic.trunc(bhot_ftermino) as ftermino, isnull(bhot_nayudantia,0) as bhot_nayudantia " & vbCrlf & _
		  " from bloques_horarios_otec a, dias_semana b,horarios c,sedes d,salas e,secciones_otec f " & vbCrlf & _
		  " where cast(a.seot_ncorr as varchar)='"&seot_ncorr&"' " & vbCrlf & _
		  " and a.seot_ncorr=f.seot_ncorr and a.dias_ccod=b.dias_ccod " & vbCrlf & _
		  " and a.hora_ccod=c.hora_ccod " & vbCrlf & _
		  " and a.sede_ccod=d.sede_ccod " & vbCrlf & _
		  " and a.sala_ccod=e.sala_ccod order by a.dias_ccod, c.hora_tdesc asc" 
          

else
consulta = "select '' as bhot_ccod"
end if

formulario.consultar consulta 


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
<table width="520" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA"><br>
	<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas lenguetas_masignaturas, 1%> </td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
              
			  <table width="100%"  border="0">
			  <tr>
				<td align="center">
				
						<table width="98%">
						<form name="edicion" method="post">
						<tr>
							<td><input type="hidden" name="sede_ccod" value="<%=sede_ccod%>">
								<input type="hidden" name="seot_ncorr" value="<%=seot_ncorr%>">
								<input type="hidden" name="dgso_ncorr" value="<%=dgso_ncorr%>">
								<input type="hidden" name="pl[0][bhot_ccod]" value="<%=bhot_ccod%>">
								<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
									   <tr> 
										 <br>
										  <center><%pagina.DibujarTituloPagina%></center>
										 <br>
										<td align="right">&nbsp;</td>
										<td width="31%" height="15" align="right"><font size="1"><strong>Asignatura 
										  - Secci&oacute;n</strong></font></td>
										<td width="3%"><div align="center">:</div></td>
										<td colspan="2"><%=formu_resul.dibujaCampo("ssec_ncorr")%><%=formu_resul.dibujaCampo("secc_ccod")%><%=formu_resul.dibujaCampo("secc_ccod_pres")%></td>
										<td><strong> </strong></td>
										<td>&nbsp;</td>
									  </tr>
									  <tr> 
										<td align="right">&nbsp;</td>
										<td height="25" align="right"><font size="1"><strong>D&iacute;a</strong></font></td>
										<td nowrap><div align="center">:</div></td>
										<td colspan="2" nowrap><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%=formu_resul.dibujaCampo("dias_ccod")%></font></td>
										<td nowrap>&nbsp; </td>
										<td nowrap>&nbsp;</td>
									  </tr>
									  <tr> 
										<td align="right">&nbsp;</td>
										<td align="right"><strong>Bloque Horario Inicio</strong></td>
										<td><div align="center">:</div></td>
										<td colspan="2"><%=formu_resul.dibujacampo("hora_ccod")%> <%'=horas_seguidas%></td>
										<td nowrap>&nbsp;</td>
										<td></td>
									  </tr>
									  <tr> 
										<td align="right">&nbsp;</td>
										<td height="25" align="right"><strong>Fecha Inicio</strong></td>
										<td><div align="center">:</div></td>
										<td colspan="2"><%=formu_resul.dibujacampo("bhot_finicio")%> (dd/mm/aaaa)</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
									  </tr>
									  <tr> 
										<td align="right">&nbsp;</td>
										<td height="25" align="right"><strong>Fecha T&eacute;rmino</strong></td>
										<td nowrap><div align="center">:</div></td>
										<td colspan="2" nowrap><%=formu_resul.dibujacampo("bhot_ftermino")%> (dd/mm/aaaa)</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
									  </tr>
									  <tr> 
										<td align="right">&nbsp;</td>
										<td height="25" align="right"><font size="1"><strong>Aula/Laboratorio/Taller</strong></font></td>
										<td><div align="center">:</div></td>
										<td width="34%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%=formu_resul.dibujaCampo("sala_ccod")%></font> </td>
										<td width="27%"><font color="#FF0000"> 
										  <div id="desc_cupos">&nbsp;</div>
										  </font></td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
									  </tr>
									   <tr> 
										<td align="right">&nbsp;</td>
										<td height="25" align="right"><strong>Bloque Ayudantía</strong></td>
										<td nowrap><div align="center">:</div></td>
										<td colspan="2" nowrap><%=formu_resul.dibujacampo("bhot_nayudantia")%></td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
									  </tr>
									  
									 </table>
                    </td>
					</tr>
					</form>
					<form name="edicion2">
						<tr>
							<td><div align="right"><strong>P&aacute;ginas :</strong>                          
							  <%formulario.accesopagina%>
							</div></td>
					    </tr>
					    <tr>
						   <td>&nbsp;</td>
					    </tr>
					    <tr>
						   <td><div align="center">
							  <%formulario.dibujatabla()%>
						      </div></td>
					       </tr>
					</form>
					</table>
				</td>
			  </tr>
			</table>
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
				  <td><div align="center"><%botonera.dibujaboton "guardar"%></div></td>	
				  <td><div align="center"><%botonera.dibujaboton "eliminar"%></div></td>
				  <td><div align="center"><%botonera.dibujaboton "salir"%></div></td>
                  <td><div align="center"></div></td>
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
