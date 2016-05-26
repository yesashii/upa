<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
seot_ncorr= request.QueryString("seot_ncorr")
dgso_ncorr = request.QueryString("dgso_ncorr")
anos_ccod = request.QueryString("anos_ccod")
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

dcur_tdesc = conexion.consultauno("SELECT dcur_tdesc FROM datos_generales_secciones_otec a,diplomados_cursos b WHERE cast(dgso_ncorr as varchar)= '" & dgso_ncorr & "' and a.dcur_ncorr=b.dcur_ncorr")
sede_tdesc = conexion.consultauno("SELECT sede_tdesc FROM datos_generales_secciones_otec a,sedes b WHERE cast(dgso_ncorr as varchar)= '" & dgso_ncorr & "' and a.sede_ccod=b.sede_ccod")

dcur_ncorr = conexion.consultauno("SELECT dcur_ncorr FROM datos_generales_secciones_otec  WHERE cast(dgso_ncorr as varchar)= '" & dgso_ncorr & "'")
sede_ccod = conexion.consultauno("SELECT sede_ccod FROM datos_generales_secciones_otec WHERE cast(dgso_ncorr as varchar)= '" & dgso_ncorr & "' ")

'----------------------Generaremos un horario los domingos en bloques secuenciales para una sala de OTEC virtual a fin de ajustar la contratación docente-------------
'---------------------------Agregado por MArcelo Sandoval en el plan de mejoras OTEC 2013-----------------------------------------------------------------------------
'---------------------------16-08-2013--------------------------------------------------------------------------------------------------------------------------------
c_hora = " select isnull(max(c.hora_ccod),0) + 1 as hora " & vbCrlf & _
		 " from datos_generales_secciones_otec a join secciones_otec b " & vbCrlf & _
		 "    on a.dgso_ncorr=b.dgso_ncorr " & vbCrlf & _
		 " left outer join bloques_horarios_otec c " & vbCrlf & _
		 "    on b.seot_ncorr=c.seot_ncorr " & vbCrlf & _
		 " where cast(a.dgso_ncorr as varchar)='"&dgso_ncorr&"'"
		 
hora = conexion.consultaUno(c_hora)

tiene_horario = conexion.consultaUno("select count(*) from bloques_horarios_otec where cast(seot_ncorr as varchar)='"&seot_ncorr&"'")
if tiene_horario = "0" then
	v_bhot_ccod = conexion.ConsultaUno("execute obtenersecuencia 'bloques_horarios_otec'")
	c_inserta = " insert into bloques_horarios_otec  " & vbCrlf & _
				" select "&v_bhot_ccod&" as bhot_ccod, a.seot_ncorr, "&hora&" as hora, 7 as dias_ccod,  " & vbCrlf & _
				" 325 as sala_ccod, b.sede_ccod as sede_ccod, a.seot_finicio as bhot_finicio, a.seot_ftermino as bhot_ftermino,  " & vbCrlf & _
				" '"&negocio.obtenerUsuario&"' audi_tusuario, getDate() as audi_fmodificacion, null as anot_ncorr,null as bhot_nayudantia " & vbCrlf & _
				" from secciones_otec a,datos_generales_secciones_otec b " & vbCrlf & _
				" where a.dgso_ncorr=b.dgso_ncorr  " & vbCrlf & _
				" and cast(a.seot_ncorr as varchar)='"&seot_ncorr&"'"
	
	conexion.ejecutaS c_inserta
end if
'--------------------------CIERRE DE La CREACION DE HORARIO------------------------------------------------------------------

lenguetas_masignaturas = Array(Array("Relatores por horario", "#"))

'-----------------------------------------planificación de la sección----------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "asignar_relator_programa.xml", "f_horario"
formulario.inicializar conexion

if seot_ncorr <> "" then
consulta =" select a.dias_ccod,a.bhot_ccod, a.bhot_ccod as clave,a.seot_ncorr,f.dgso_ncorr,b.dias_tdesc as dia,c.hora_tdesc as bloque,d.sede_tdesc as sede,e.sala_tdesc as sala, " & vbCrlf & _
		  " '( '+protic.trunc(bhot_finicio) +' -- ' + protic.trunc(bhot_ftermino) + ' )' as periodo, protic.RELATORES_BLOQUE_OTEC(a.bhot_ccod) as relator" & vbCrlf & _
		  " from bloques_horarios_otec a, dias_semana b,horarios c,sedes d,salas e,secciones_otec f " & vbCrlf & _
		  " where cast(a.seot_ncorr as varchar)='"&seot_ncorr&"' " & vbCrlf & _
		  " and a.seot_ncorr=f.seot_ncorr and a.dias_ccod=b.dias_ccod " & vbCrlf & _
		  " and a.hora_ccod=c.hora_ccod " & vbCrlf & _
		  " and a.sede_ccod=d.sede_ccod " & vbCrlf & _
		  " and a.sala_ccod=e.sala_ccod order by a.dias_ccod, c.hora_tdesc asc " 
else
consulta = "select '' as bhot_ccod"
end if

formulario.consultar consulta 
formulario.agregaCampoParam "pers_ncorr", "destino","(select b.pers_ncorr, pers_tnombre + ' ' + pers_tape_paterno as relator from relatores_programa a, personas b where a.pers_ncorr=b.pers_ncorr and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and anos_ccod="&anos_ccod&")aa"
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
<table width="720" border="0" align="left" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA"><br><br>
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
						
					    <form name="edicion2">
						<tr>
							<td><%response.Write("<strong>PROGRAMA: "&dcur_tdesc&"</strong>")%></td>
						  </tr>
						  <tr>
							<td><%response.Write("<strong>SEDE: "&sede_tdesc&"</strong>")%></td>
						  </tr>
						  <tr>
							<td>&nbsp;</td>
						  </tr>
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
						<tr>
						   <td>&nbsp;</td>
					    </tr>
						</tr>
						   <td>&nbsp;</td>
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
            <td width="18%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
				  <td><div align="center"><%botonera.agregaBotonParam "volver","url","asignar_relator_programa.asp?b[0][dcur_ncorr]="&dcur_ncorr&"&b[0][sede_ccod]="&sede_ccod&"&detalle=2&b[0][anio_admision]="&anos_ccod
				                            botonera.dibujaboton "volver"%></div></td>
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
