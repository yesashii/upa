<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
 
encu_ncorr = "25"
pers_ncorr = request.querystring("pers_ncorr")


'--------------------------------------------------------------------------
set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

if pers_ncorr = "" then
	pers_nrut= negocio.obtenerUsuario()
	pers_ncorr= conectar.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'")
end if



'consulta_cantidad_encuestas= " select count(distinct b.encu_ncorr) " &_
'                            " from sis_roles_usuarios a, roles_encuestas b "&_
'							 " where cast(pers_ncorr as varchar)='"&pers_ncorr&"' "&_
'                             " and a.srol_ncorr=b.srol_ncorr"
'cantidad_encuestas=conectar.consultaUno(consulta_cantidad_encuestas)
cantidad_encuestas="1"

if cantidad_encuestas = "0" then
	encu_ncorr = ""
end if


set botonera = new CFormulario
botonera.Carga_Parametros "contestar_encuesta_emprendedores.xml", "botonera"
cantidad_encuestas=cInt(cantidad_encuestas)
if cantidad_encuestas = "0" then
	mensaje="Aún no existen encuestas disponibles para ser contestadas por Usted."
else
    if cantidad_encuestas = "1" then
	    'consulta_encuestas= " select distinct b.encu_ncorr " &_
        '                     " from sis_roles_usuarios a, roles_encuestas b "&_
		'					 " where cast(pers_ncorr as varchar)='"&pers_ncorr&"' "&_
        '                     " and a.srol_ncorr=b.srol_ncorr"
		'encu_ncorr=conectar.consultaUno(consulta_encuestas)
		 encu_ncorr="25"
	 end if
end if

nombre_encuesta = conectar.consultaUno("Select encu_tnombre from encuestas where cast(encu_ncorr as varchar)='"&encu_ncorr&"'")
instruccion = conectar.consultaUno("Select encu_tinstruccion from encuestas where cast(encu_ncorr as varchar)='"&encu_ncorr&"'")
pagina.Titulo = nombre_encuesta



set escala= new cformulario
escala.carga_parametros "tabla_vacia.xml","tabla"
escala.inicializar conectar
Query_escala = "select  resp_ncorr,resp_tabrev,protic.initcap(resp_tdesc) as resp_tdesc from respuestas where cast(encu_ncorr as varchar)='"&encu_ncorr&"' order by resp_norden"
escala.consultar Query_escala
cantid = escala.nroFilas

set criterios= new cformulario
criterios.carga_parametros "tabla_vacia.xml","tabla"
criterios.inicializar conectar
Query_criterios = "select  crit_ncorr,crit_tdesc from criterios where cast(encu_ncorr as varchar)='"&encu_ncorr&"' order by crit_norden"
criterios.consultar Query_criterios
cantid_criterios = criterios.nroFilas

'------------------buscamos que datos vamos mostrar en el encabezado de la encuesta

set datos = new cformulario
datos.carga_parametros "tabla_vacia.xml","tabla"
datos.inicializar conectar
Query_datos = " select top 1 g.carr_tdesc, g.carr_ccod, a.secc_tdesc, j.pers_tnombre + ' ' + j.pers_tape_paterno + ' ' + j.pers_tape_materno as profesor,"&_
			  " k.asig_tdesc as asignatura,protic.ano_ingreso_carrera(c.pers_ncorr,g.carr_ccod) as ano_ingreso "&_
		      " from secciones a, cargas_academicas b, alumnos c, sis_usuarios d, ofertas_academicas e, "&_
			  " especialidades f, carreras g, bloques_horarios h, bloques_profesores i,personas j, asignaturas k "&_
			  " where a.asig_ccod='FFFDD004' and a.peri_ccod='206' "&_
			  " and a.secc_Ccod=b.secc_ccod and b.matr_ncorr=c.matr_ncorr and c.pers_ncorr=d.pers_ncorr "&_
			  " and cast(c.pers_ncorr as varchar)='"&pers_ncorr&"' "&_
			  " and c.ofer_ncorr = e.ofer_ncorr and e.espe_ccod=f.espe_ccod and f.carr_ccod=g.carr_ccod "&_
			  " and a.secc_ccod=h.secc_ccod and h.bloq_ccod=i.bloq_ccod and i.tpro_ccod=1 "&_
			  " and i.pers_ncorr=j.pers_ncorr and a.asig_ccod=k.asig_ccod "

datos.consultar Query_datos
datos.siguiente

'response.Write(Query_datos)
carrera= datos.obtenerValor("carr_tdesc")

asignatura=datos.obtenerValor("asignatura")
seccion=datos.obtenerValor("secc_tdesc")
'response.Write("select carr_ccod from secciones a where cast(a.secc_ccod as varchar)='"&secc_ccod&"'   .................")
carr_ccod=datos.obtenerValor("carr_ccod")

'response.Write("select protic.ano_ingreso_carrera("&pers_ncorr&",'"&carr_ccod&"')")
ano_ingreso = datos.obtenerValor("ano_ingreso")
'response.End()
profesor = datos.obtenerValor("profesor")

'generamos mensaje de encuesta contestada 
contestada_temp = conectar.consultaUno("Select Count(*) from encuestas_emprendedores where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and ano_aplicacion = '2007'")
if contestada_temp <> "0" then 
c_contestada =  "select top 1 " & vbCrLf &_
				" (cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_1) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_2) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_3) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_4) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_5) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_6) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_7) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_8) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_9) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_10) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_11) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_12) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_13) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_14) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_15) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_16) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_17) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_18) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_19) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_20)  as numeric)+ " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_21) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_22) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_23) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_24)  as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_25) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_26) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_27) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_28) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_29)  as numeric)+ " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_30) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_31) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_32) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_33) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_34) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_35) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_36) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_37) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_38) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_39) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_40) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_41) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_42) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_43) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_44) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_45) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_46) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_47) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_48) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_49) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_50) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_51) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_52) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_53) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_54) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_55) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_56) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_57) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_58) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_59) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_60) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_61) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_62) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_63) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_64) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_65) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_66) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_67) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_68) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_69) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_70) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_71) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_72) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_73) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_74) as numeric) + " & vbCrLf &_
				" cast((select resp_nnota from respuestas aa where aa.resp_ncorr=preg_75) as numeric) ) as total " & vbCrLf &_
				" from encuestas_emprendedores  " & vbCrLf &_
				" where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and ano_aplicacion = '2007' " 

     puntaje = conectar.consultaUno(c_contestada)
    'response.Write(puntaje)
	if cint(puntaje) > 0 and cint(puntaje) <= 260 then
		mensaje_puntos="Los resultados sólo muestran que no posee un especial interés por el área de los negocios, lo que no impide que de proponérselo pueda desarrollarse adecuadamente en el área."
    elseif cint(puntaje) >= 261 and cint(puntaje) <= 300 then
	    mensaje_puntos="Cuenta con un potencial emprendedor, el cual de presentarse las circunstancias podrán hacer que se desarrolle a plenitud."
    elseif cint(puntaje) >= 301 then
	    mensaje_puntos="Tiene una personalidad que va de acuerdo con el emprendedor, cualquiera  que sea  la profesión que ejerza imprimirá en su actividad profesional su sello emprendedor."
    end if
end if
'response.Write(mensaje_puntos)
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
function volver()
{
   CerrarActualizar();
}

function direccionar(valor)
{var cadena;
 var secc_ccod='<%=secc_ccod%>';
 var pers_ncorr_profesor='<%=pers_ncorr_profesor%>';
 location.href="contestar_encuesta2.asp?encu_ncorr="+valor+"&secc_ccod="+secc_ccod+"&pers_ncorr_docente="+pers_ncorr_profesor;
}


function validar()
{ var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor=<%=cantid%>;
  //alert("divisor= "+divisor);
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if (elemento.type=="radio")
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }
  if (divisor!=0)
  {
  if (contestada==(cant_radios/divisor))
  { 
	 if(confirm("Está seguro que desea grabar la Evaluación.\n\nUna vez guardada la encuesta, no podrá realizar cambio alguno en ella.")) 
     { document.edicion.method = "POST";
	   document.edicion.action = "encuesta_emprendedores_proc.asp";
       document.edicion.submit();
	 }  
  }
  else
   alert("Debe responder la encuesta antes de grabar,\n aún faltan preguntas por responder.");
  }
  else
     alert("Esta encuesta no ha sido creada completamente aún, No la puede contestar");

}

</script>


</head>

</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="720" border="0" align="center" cellpadding="0" cellspacing="0">
    
  <tr>
    <td valign="top" bgcolor="#FFFFFF">
	<br>
	<%if cantidad_encuestas <> "1"  then%>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
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
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              
            </table>
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                      <td bgcolor="#D8D8DE"><div align="left"><%
						if cantidad_encuestas = "0" then
						response.Write("<center><h3>"&mensaje&"</h3></center>")
						botonera.dibujaBoton "Volver"
						end if
						%> 
                      </div>
					  </td>
                      <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                      <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                      <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
      </tr>
    </table>	
	<%end if 'fin del if que muestra el selesct de las encuestas%>
	<br>
	<%if encu_ncorr <> "" then%>
	<form name="edicion">
		<% 'response.Write("Select Count(*) from resultados_encuestas where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"'")
		  contestada = conectar.consultaUno("Select Count(*) from encuestas_emprendedores where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and ano_aplicacion = '2007'")
		  
		%>
	<input name="p[0][encu_ncorr]" type="hidden" value="<%=encu_ncorr%>">
	<input name="p[0][pers_ncorr_encuestado]" type="hidden" value="<%=pers_ncorr%>">
	<input name="p[0][carr_ccod]" type="hidden" value="<%=carr_ccod%>">
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
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
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0" aling="center">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				  
				     <div align="center">
                      <%pagina.DibujarTituloPagina%>
                      <BR>
                      <table width="100%"  border="0" align="center">
                        <tr> 
                          <td colspan="3">&nbsp;</td>
						</tr>
						<tr>
							<td colspan="3">
							<table width="100%" border="0">
								  <tr> 
									<td width="18%" align="left"><strong>Programa</strong> </td>
									<td width="1%"><strong>:</strong></td>
									<td width="38%" align="left"><font color="#CC0000"><%=carrera%></font></td>
									<td width="14%" align="right">&nbsp;</td>
									<td width="2%">&nbsp;</td>
									<td colspan="3" align="left">&nbsp;</td>
								  </tr>
  								  <tr> 
									<td width="18%" align="left"><strong>Módulo</strong></td>
									<td width="1%"><strong>:</strong></td>
									<td width="38%" align="left"><font color="#CC0000"><%=asignatura%></font></td>
									<td width="14%" align="right"><strong>Año</strong></td>
									<td width="2%"><strong>:</strong></td>
									<td width="27%" align="left"><font color="#CC0000"><%=ano_ingreso%></font></td>
    							  </tr>
								   <tr> 
									<td width="18%" align="left"><strong>Profesor</strong> </td>
									<td width="1%"><strong>:</strong></td>
									<td colspan="4" align="left"><strong><font color="#CC0000"><%=profesor%></font></strong></td>
								  </tr>
								  
								  <%if mensaje_puntos <> "" then %>
								  <tr>
								  	  <td colspan="6">&nbsp;</td>
								  </tr>
								  <tr> 
								      <td colspan="6" align="center">
									  		<table width="90%" border="1" bordercolor="#990000">
												<tr>
													<td colspan="2" align="center" bgcolor="#990000"><font color="#FFFFFF"><strong>Resultados de la Encuesta</strong></font></td>
												</tr>
												<tr>
													<td align="left"><strong>Puntaje Obtenido   :  </strong><%=puntaje%></td>
												</tr>
												<tr><td align="left"><strong><%=mensaje_puntos%></strong></td></tr>
											
											</table>
									  </td>
							      </tr>
								  <%end if%>
						    </table>
							</td>
						</tr>
						<tr>
							<td colspan="3">&nbsp;</td>
						</tr>
						<tr> 
                          <td colspan="3"><strong>INSTRUCCIONES : </strong>Estimado Alumno (a):</td>
						</tr>
						<tr>  
						  <td colspan="3"><%=instruccion%></td>
						</tr>
						<tr>  
						  <td colspan="3" height="20"></td>
						</tr> 
						<%if cantid > "0" then
						  while escala.siguiente
								abrev = escala.obtenervalor("resp_tabrev")
								texto= escala.obtenervalor("resp_tdesc")						
						%> 
						<tr>  
						   <td width="3%"><div align="left"><strong><%=abrev%></strong></div></td>
  						   <td width="3%"><strong><center>:</center></strong></td>
						   <td width="94%"><div align="left"><strong><%=texto%></strong></div></td>
						</tr>
						<%
						wend
						end if
						%>
						
                      </table>
                   <table width="100%" border="0">
						  <tr> 
							<td width="5%"> 
							</td>
							<td width="6%">&nbsp; </td>
							<td width="75%">&nbsp;</td>
							<td width="14%">&nbsp;</td>
						  </tr>
						</table>
                       <table width="100%"  border="0" align="center">
                       <%if cantid_criterios >"0" then
					        contador=1
						  	while criterios.siguiente
									ncorr = criterios.obtenervalor("crit_ncorr")
									'response.Write("ncorr= "&ncorr&" ")
									titulo= criterios.obtenervalor("crit_tdesc")						
							%>  
							<tr> 
                          		<td colspan="3"><strong><%=titulo%></strong></td>
						  		
						  		<%if cantid >"0" then
						  			escala.Primero
						  			while escala.siguiente
										abrev = escala.obtenervalor("resp_tabrev")%>
										<td width="20"><strong><center>
						  				<%response.Write(abrev)		
										%></center></strong>
										</td>
									<%wend
								end if%>
							<td width="2">&nbsp;</td>	
							</tr>
							<%
							set preguntas= new cformulario
							preguntas.carga_parametros "tabla_vacia.xml","tabla"
							preguntas.inicializar conectar
							Query_preguntas = "select  preg_ncorr,preg_ccod,protic.initCap(preg_tdesc) as preg_tdesc,preg_norden from preguntas where cast(crit_ncorr as varchar)='"&ncorr&"' order by preg_norden"
							preguntas.consultar Query_preguntas
							cantid_preguntas = preguntas.nroFilas
							'response.Write("ncorr= "&ncorr&" cantidad_preguntas "&cantid_preguntas)
								if cantid_preguntas >"0" then
						  			while preguntas.siguiente
									    'response.Write("sql= "&Query_preguntas)
										orden = preguntas.obtenervalor("preg_norden")
										pregunta= preguntas.obtenervalor("preg_tdesc")						
										ccod=preguntas.obtenervalor("preg_ccod")						
										preg_ncorr=preguntas.obtenervalor("preg_ncorr")						
										%>  
										<tr> 
                          				<td width="18" align="right"><strong><%=contador%></strong></td>
										<td width="17"><%=".-"%></td>
										<td width="591"><%=pregunta%></td>
						  
						  				<%if cantid >"0" then
						  					escala.Primero
						  					while escala.siguiente%>
											 <td width="20"><center>
											   <%if contestada <> 0 then
											     'response.Write("Select resp_ncorr from resultados_encuestas where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"' and preg_ncorr='"&preg_ncorr&"'")
												  respuesta = conectar.consultaUno("Select preg_"&contador&" from encuestas_emprendedores where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and ano_aplicacion='2007'")  
												   'response.Write("enca "&respuesta)
												   if respuesta <> "" and not esVacio(respuesta) then	
														if cInt(respuesta) = cInt(escala.obtenervalor("resp_ncorr")) then%>
												 			<input type="radio" name="<%="p[0][preg_"&contador&"]"%>" value="<%=escala.obtenervalor("resp_ncorr")%>" checked>
												 		<%else%>
															<input type="radio" name="<%="p[0][preg_"&contador&"]"%>" value="<%=escala.obtenervalor("resp_ncorr")%>" disabled>
												 		<%end if
												   end if%>
											   <%else%>
						  							<input type="radio" name="<%="p[0][preg_"&contador&"]"%>" value="<%=escala.obtenervalor("resp_ncorr")%>">
						  					  <%end if%>
											  </center></td>
											<%wend
									    end if%>
										<td width="2">&nbsp;</td>	
										</tr>
									<%contador=contador+1 
									wend
								end if
								Query_preguntas=""%>
								
							<tr>
							<td colspan="5">&nbsp;</td>
							</tr>
							<%wend 
							end if
							%>
							
                          </tr>
                         </table> 
                    <BR>
                  </div>
				</td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="101" nowrap bgcolor="#D8D8DE"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="50%"><% botonera.dibujaBoton "Volver" %></td>
                      <td width="50%"><% if contestada = 0 then
						botonera.dibujaBoton "guardar_encuesta"
						end if  %> </td>
                    </tr>
                  </table></td>
                  <td width="309" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="267" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<BR>
		  </td>
        </tr>
      </table>
	  </form>
	  <%end if%>	
   </td>
  </tr>  
</table>
</body>
</html>
