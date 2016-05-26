<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
maot_ncorr= request.QueryString("maot_ncorr")
dgso_ncorr = request.QueryString("dgso_ncorr")

set pagina = new CPagina
pagina.Titulo = "Creación y edición de secciones Otec"

set botonera =  new CFormulario
botonera.carga_parametros "secciones_otec.xml", "botonera_secciones"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
periodo = negocio.obtenerPeriodoAcademico("Postulacion")
'---------------------------------------------------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "secciones_otec.xml", "edita_secciones"
formulario.inicializar conexion

if maot_ncorr <> "" and dgso_ncorr <> "" then 
consulta= " select dgso_ncorr,a.maot_ncorr,seot_tdesc,seot_ncorr as codigo,seot_ncorr,seot_ncupo,seot_nquorum,protic.trunc(seot_finicio)as  seot_finicio,protic.trunc(seot_ftermino) as seot_ftermino, " & vbCrlf & _
		  " maot_nhoras_programa,maot_npresupuesto_relator,seot_ncantidad_relator,isnull(jorn_ccod,1) as jorn_ccod  " & vbCrlf & _
		  " from secciones_otec a, mallas_otec b" & vbCrlf & _
		  " where a.maot_ncorr=b.maot_ncorr and cast(b.maot_ncorr as varchar)='"& maot_ncorr &"' and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'" & vbCrlf & _
		  " order by seot_tdesc "
else
consulta = "select * from sexos where 1=2"
end if

'response.write("<pre>"&consulta&"</pre>")
formulario.consultar consulta 
'if maot_ncorr <> "" and dgso_ncorr <> ""  then
'	formulario.agregacampocons "maot_ncorr", maot_ncorr
'	formulario.agregacampocons "dgso_ncorr", dgso_ncorr
'end if
'formulario.siguiente

lenguetas_masignaturas = Array(Array("Listado de Secciones Creadas", "agregar_seccion.asp?maot_ncorr="&maot_ncorr&"&dgso_ncorr="&dgso_ncorr))
'response.Write("doras "&horas_Asignatura&" duracion "&duracion_asignatura)

cantidad_sin_grabar = conexion.consultaUno("select count(*) from secciones_otec where cast(maot_ncorr as varchar)='"&maot_ncorr&"' and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and isnull(seot_nhoras_programa,0)=0")
'response.Write(cantidad_sin_grabar)
cantidad_registros = formulario.nroFilas()
dgso_finicio = conexion.consultaUno("select protic.trunc(dgso_finicio) from datos_generales_secciones_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")
dgso_ftermino = conexion.consultaUno("select protic.trunc(dgso_ftermino) from datos_generales_secciones_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")
dgso_ncupo = conexion.consultaUno("select dgso_ncupo from datos_generales_secciones_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")
dgso_nquorum = conexion.consultaUno("select dgso_nquorum from datos_generales_secciones_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")


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
function volver(){
	CerrarActualizar();
}

function validaCambios(){
	alert("..");
	return false;
}
function revision(formulario)
{ var cantidad = <%=cantidad_registros%>;
  var i=0;
  var dgso_finicio = '<%=dgso_finicio%>';
  var dgso_ftermino = '<%=dgso_ftermino%>';
  var dgso_ncupo = <%=dgso_ncupo%>;
  var dgso_nquorum = <%=dgso_nquorum%>;
  var mensaje_error = "";
  var cupo = 0;
  
  array_inicio_programa = dgso_finicio.split('/');     
  array_termino_programa = dgso_ftermino.split('/');

  dia_inicio = array_inicio_programa[0];
  mes_inicio  = array_inicio_programa[1];
  agno_inicio = array_inicio_programa[2];
  dia_termino = array_termino_programa[0];
  mes_termino  = array_termino_programa[1];
  agno_termino = array_termino_programa[2];
 // con formatos mm/dd/yyyy
 fecha_inicio_programa = mes_inicio+'/'+dia_inicio+'/'+agno_inicio;
 fecha_termino_programa = mes_termino+'/'+dia_termino+'/'+agno_termino;
// convertir a milisegundos
 m_fecha_inicio_p  = Date.parse(fecha_inicio_programa);
 m_fecha_termino_p = Date.parse(fecha_termino_programa);
  
  for (i=0; i<cantidad;i++)
	{  //alert("cantidad "+cantidad+" i "+i);
		cupo = formulario.elements["m["+i+"][seot_ncupo]"].value;
		quorum = formulario.elements["m["+i+"][seot_nquorum]"].value;
		inicio = formulario.elements["m["+i+"][seot_finicio]"].value;
		termino = formulario.elements["m["+i+"][seot_ftermino]"].value;
		if (cupo >= dgso_ncupo)
		{ //alert("quorum "+quorum+" dgso_nquorum "+dgso_nquorum);
		 	if (quorum >= dgso_nquorum)
			{
				
				array_inicio = inicio.split('/');     
                array_termino = termino.split('/');

				dia_inicio1 = array_inicio[0];
				mes_inicio1  = array_inicio[1];
				agno_inicio1 = array_inicio[2];
				dia_termino1 = array_termino[0];
				mes_termino1  = array_termino[1];
				agno_termino1 = array_termino[2];
				// con formatos mm/dd/yyyy
				fecha_inicio_seccion = mes_inicio1+'/'+dia_inicio1+'/'+agno_inicio1;
				fecha_termino_seccion = mes_termino1+'/'+dia_termino1+'/'+agno_termino1;
				m_fecha_inicio_s  = Date.parse(fecha_inicio_seccion);
				m_fecha_termino_s = Date.parse(fecha_termino_seccion);
				//alert("inicio "+m_fecha_inicio_s+" termino "+m_fecha_termino_s);
				
				diferencia_s=eval(m_fecha_inicio_s - m_fecha_termino_s);
				
				if (diferencia_s <= 0 )
				{
					diferencia_pii = eval(m_fecha_inicio_s - m_fecha_inicio_p);
					diferencia_ptt = eval(m_fecha_termino_s - m_fecha_termino_p);
					//alert("ii "+diferencia_pii+" tt "+diferencia_ptt);
					if ((diferencia_pii < 0)||(diferencia_ptt > 0))
					{
						//alert("Existen un error en las fechas de la sección estan fuera del rango de las del programa");
						mensaje_error = "Existen un error en las fechas de la sección estan fuera del rango de las del programa";
						
					}
					//else
					//{
						//return true;
					//	mensaje_error = "";
					//}
					
				}
				else
				{
				 //alert("La fecha de inicio de la sección no puede ser mayor a la de término");
				 mensaje_error = "La fecha de inicio de la sección no puede ser mayor a la de término";
				 //return false;
				}
				
			}
			else
			{
				//alert("La cantidad de alumnos mínimos de la sección no puede ser menor a la del programa ("+dgso_nquorum+").");
				mensaje_error = "La cantidad de alumnos mínimos de la sección no puede ser menor a la del programa ("+dgso_nquorum+")." ;
				//return false;
			}
		}
	     else
		{
		  //alert("El cupo de la sección no puede ser menor al del programa creado ("+dgso_ncupo+")");
		  mensaje_error = "El cupo de la sección no puede ser menor al del programa creado ("+dgso_ncupo+")";
		  //return false;
		}
	}
//return false;
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
              <form name="edicion" method="post">
			  <table width="100%"  border="0">
			  <tr>
				<td align="center">
				<input type="hidden" name="maot_ncorr" value="<%=maot_ncorr%>">
				<input type="hidden" name="dgso_ncorr" value="<%=dgso_ncorr%>">
						<table width="98%">
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
					   </table>
				</td>
			  </tr>
			</table>
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
                  <td><div align="center"><%if cantidad_sin_grabar = "0" then
				                               botonera.dibujaboton "agregar"
											 end if%></div></td>
				  <td><div align="center"><%botonera.dibujaboton "guardar"%></div></td>	
				  <td><div align="center"><%if cantidad_registros > 0 then
				                               botonera.dibujaboton "eliminar"
											 end if%></div></td>						 
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
