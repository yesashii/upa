<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'----------------------------------------------------------
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv 	= Request.QueryString("busqueda[0][pers_xdv]")
v_evento 	= Request.QueryString("evento")
q_regi_ccod_colegio = Request.QueryString("da[0][regi_ccod_colegio]")
q_ciud_ccod_colegio = Request.QueryString("da[0][ciud_ccod_colegio]")

if v_evento="" then
	v_evento=719
end if

if v_evento <> "" and EsVacio(q_pers_nrut) then
	q_pers_nrut = Request.QueryString("rut_alumno")
	q_pers_xdv 	= Request.QueryString("digito_v")
	if q_pers_xdv="10" then
		q_pers_xdv="k"
	end if
	if q_pers_xdv="11" then
		q_pers_xdv="n"
	end if
end if

'----------------------------------------------------
 set conexion = new CConexion
 conexion.Inicializar "upacifico"

 set negocio = new CNegocio
 negocio.Inicializa conexion
'----------------------------------------------------

 set pagina = new CPagina
 pagina.Titulo = "Ficha de postulación a eventos"
 
'----------Botones de la pagina -----------
 set f_botonera = new CFormulario
 f_botonera.Carga_Parametros "ficha_casa_abierta_alumno.xml", "botonera"
 f_botonera.Inicializar conexion

'------------busqueda del alumno si es que esta en la BD-------------------
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "ficha_casa_abierta_alumno.xml", "busqueda"
 f_busqueda.Inicializar conexion

 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
 f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
'------------------------------------------------------------------------- 


'------------CREACIÓN DATOS DEL AlUMNO--------------------------------------
set f_datos_alumno = new CFormulario
f_datos_alumno.Carga_Parametros "ficha_casa_abierta_alumno.xml", "f_datos_alumno"
f_datos_alumno.Inicializar conexion

consulta_pers_ncorr= conexion.consultaUno("select count(*) from personas_eventos_upa where cast(pers_nrut as varchar)='" & q_pers_nrut & "' ")
'response.Write("<pre>"&consulta_pers_ncorr&"<pre>")
if consulta_pers_ncorr > 0 then
	v_existe=1

	consulta_datos_alumno=	" select a.pers_ncorr_alumno,isnull(d.regi_ccod,0) as regi_ccod_colegio,isnull(c.ciud_ccod,0) as ciud_ccod_colegio, b.caev_ccod, c.cole_ccod, " & vbCrLf &_
							" pers_totro_colegio, b.carrera_1,b.carrera_2,b.carrera_3,b.pest_ccod,c.cole_ccod as colegio, " & vbCrLf &_
							" b.PERS_NBECAS_CREDITOS,b.PERS_NCONVENIOS_INTER,b.PERS_NDEPORTE_RECREACION,b.PERS_NSEGURO_ESCOLAR, " & vbCrLf &_
							" b.PERS_NTALLER_TEATRO,b.PERS_NOTRO_BENEFICIO,b.PERS_TOTRO_BENEFICIO_DESC,b.PERS_TOTRO_COLEGIO, " & vbCrLf &_
							" a.pers_tnombre, a.pers_tape_paterno, a.pers_tape_materno, a.pers_tdireccion, a.ciud_ccod , " & vbCrLf &_
							" a.pers_temail,a.pers_tfono, a.pers_tcelular,protic.trunc(pers_fnacimiento) as pers_fnacimiento " & vbCrLf &_
							" From personas_eventos_upa a " & vbCrLf &_
							" left outer join eventos_alumnos b " & vbCrLf &_
							"    on a.pers_ncorr_alumno=b.pers_ncorr_alumno  " & vbCrLf &_
							"    and b.even_ncorr='"&v_evento&"' " & vbCrLf &_
							" left outer join colegios c " & vbCrLf &_
							"     on a.cole_ccod=c.cole_ccod " & vbCrLf &_
							" left outer join ciudades d " & vbCrLf &_
							"    on c.ciud_ccod=d.ciud_ccod " & vbCrLf &_
							" Where cast(a.pers_nrut as varchar)='" & q_pers_nrut & "' "

else
	v_existe=0
	consulta_datos_alumno="select '' "

end if

'response.Write("<pre>"&consulta_datos_alumno&"</pre>")

f_datos_alumno.consultar consulta_datos_alumno


sql_colegio_evento=	"Select b.cole_ccod,c.ciud_ccod, c.regi_ccod "& vbCrLf &_
					" From eventos_upa a,  colegios b , ciudades c" & vbCrLf &_
					" Where a.cole_ccod=b.cole_ccod"& vbCrLf &_
					" and b.ciud_ccod=c.ciud_ccod"& vbCrLf &_
					" and a.even_ncorr="&v_evento


if q_pers_nrut <> "" then
	'f_datos_alumno.agregacampocons "cole_ccod", v_colegio
	f_datos_alumno.agregacampocons "pers_nrut", q_pers_nrut
	f_datos_alumno.agregacampocons "q_pers_nrut", q_pers_nrut
	f_datos_alumno.agregacampocons "pers_xdv", q_pers_xdv
	f_datos_alumno.agregacampocons "q_pers_xdv", q_pers_xdv
end if

f_datos_alumno.siguiente


'###################################################################
'##################	PROPONE COLEGIO DE EVENTO	####################
set f_colegio_evento = new CFormulario
f_colegio_evento.Carga_Parametros "tabla_vacia.xml", "tabla"
f_colegio_evento.Inicializar conexion					
f_colegio_evento.consultar sql_colegio_evento
f_colegio_evento.siguiente

if v_existe=0 and EsVacio(q_regi_ccod_colegio) then

	q_regi_ccod_colegio	=	f_colegio_evento.ObtenerValor("regi_ccod")
	q_ciud_ccod_colegio	=	f_colegio_evento.ObtenerValor("ciud_ccod")
	f_datos_alumno.AgregaCampoCons "cole_ccod", f_colegio_evento.ObtenerValor("cole_ccod")
end if

'###################################################################

if not EsVacio(q_regi_ccod_colegio)  then
	f_datos_alumno.AgregaCampoCons "regi_ccod_colegio", q_regi_ccod_colegio
	f_datos_alumno.AgregaCampoCons "ciud_ccod_colegio", q_ciud_ccod_colegio
	f_datos_alumno.AgregaCampoParam "cole_ccod", "filtro", "ciud_ccod = '" & q_ciud_ccod_colegio & "'"
else

	f_datos_alumno.AgregaCampoParam "cole_ccod", "filtro", "ciud_ccod = '"&f_datos_alumno.ObtenerValor("ciud_ccod_colegio")&"'"
	
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


function LimpiarComboColegios()
{
	o_cole_ccod = document.edicion.elements["da[0][cole_ccod]"];
	
	o_cole_ccod.length = 0;
	o_cole_ccod.add (new Option("Seleccionar colegio", ""));
}

function RecargarColegios()
{	
	
	navigate("ficha_alumno_casa_abierta.asp?evento=<%=v_evento%>&busqueda[0][pers_nrut]=<%=q_pers_nrut%>&busqueda[0][pers_xdv]=<%=q_pers_xdv%>&da[0][regi_ccod_colegio]=" +document.edicion.elements["da[0][regi_ccod_colegio]"].value + "&da[0][ciud_ccod_colegio]=" + document.edicion.elements["da[0][ciud_ccod_colegio]"].value);
	
}

function InicioPagina()
{
<% if q_pers_nrut <>"" then%>
	_FiltrarCombobox(document.edicion.elements["da[0][ciud_ccod_colegio]"], 
	                 document.edicion.elements["da[0][regi_ccod_colegio]"].value,
					 d_ciudades,
					 'regi_ccod',
					 'ciud_ccod',
					 'ciud_tdesc',
					 '<%=f_datos_alumno.ObtenerValor("ciud_ccod_colegio")%>',
					 'Seleccionar ciudad');					
<% end if %>
}

function habilita_otro_colegio(objeto){
	//alert(objeto.checked);
	if(objeto.checked){
		document.edicion.elements["da[0][pers_totro_colegio]"].disabled=false;
		document.edicion.elements["da[0][cole_ccod]"].disabled=true;

	}else{
		document.edicion.elements["da[0][pers_totro_colegio]"].disabled=true;
		document.edicion.elements["da[0][cole_ccod]"].disabled=false;

	}
}	




function ValidaFormBusqueda()
   {
   var formulario = document.buscador;
   var	rut_busqueda = formulario.elements["busqueda[0][pers_nrut]"].value + '-' + formulario.elements["busqueda[0][pers_xdv]"].value;
	
mensaje.style.visibility="visible";
	
   if (!valida_rut(rut_busqueda)) 
      {
      alert('Ingrese un RUT válido.');
	  formulario.elements["busqueda[0][pers_xdv]"].select();
	  return false;
	  }
   return true;
   }
   
//----------------------------------------------------------
function guardar(formulario)
	{
	alumno_existe="<%=v_existe%>";
 	if(preValidaFormulario(formulario))
		{	
			if (alumno_existe=="0") {
				formulario.action ='proc_agregar_alumno_casa_abierta.asp?folio_envio=<%=v_evento%>';
			}else{
				formulario.action ='proc_agregar_alumno_existe_casa.asp?folio_envio=<%=v_evento%>';
			}
			formulario.submit();
		}
	}


	function verifica_orden(objeto){
	//alert(objeto);alert(valor);
	//v_valor=objeto.value;
	
	valor_1=document.edicion.elements["da[0][PERS_NBECAS_CREDITOS]"];
	valor_2=document.edicion.elements["da[0][PERS_NCONVENIOS_INTER]"];
	valor_3=document.edicion.elements["da[0][PERS_NDEPORTE_RECREACION]"];
	valor_4=document.edicion.elements["da[0][PERS_NSEGURO_ESCOLAR]"];
	valor_5=document.edicion.elements["da[0][PERS_NTALLER_TEATRO]"];
	valor_6=document.edicion.elements["da[0][PERS_NOTRO_BENEFICIO]"];
	
	
	
		if ((objeto.value==valor_1.value)&&(objeto.name!=valor_1.name)){
			alert("el valor ingresado ya existe en casilla becas y creditos");
			valor_1.value='';
		}
		if ((objeto.value==valor_2.value)&&(objeto.name!=valor_2.name)){
			alert("el valor ingresado ya existe en la casilla convenios internacionales");
			valor_2.value='';
		}
		if ((objeto.value==valor_3.value)&&(objeto.name!=valor_3.name)){
			alert("el valor ingresado ya existe en la casilla deporte y recreacion");
			valor_3.value='';
		}
		if ((objeto.value==valor_4.value)&&(objeto.name!=valor_4.name)){
			alert("el valor ingresado ya existe en la casilla seguro escolar");
			valor_4.value='';
		}
		if ((objeto.value==valor_5.value)&&(objeto.name!=valor_5.name)){
			alert("el valor ingresado ya existe en la casilla talleres de teatro");
			valor_5.value='';
		}
		if ((objeto.value==valor_6.value)&&(objeto.name!=valor_6.name)){
			alert("el valor ingresado ya existe en la casilla otros beneficios");
			valor_6.value='';
		}
	
	}



</script>
</head>
<body  leftmargin="0" topmargin="0" onLoad="InicioPagina();">
<div align="center">
  <table width="73%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
    <tr>
      <td bgcolor="#EAEAEA"> <p>
        </p>
        <table width="650"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
          <tr> 
            <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
            <td height="8" background="../imagenes/top_r1_c2.gif"></td>
            <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
          </tr>
          <tr> 
            <td width="9" background="../imagenes/izq.gif"></td>
            <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td> 
                    <%pagina.DibujarLenguetas Array("Buscador"), 1 %>                    </td>
                </tr>
                <tr> 
                  <td height="2" background="../imagenes/top_r3_c2.gif"></td>
                </tr>
                <tr> 
                  <td><form name="buscador">
				  <input type="hidden" name="evento" value="<%=v_evento%>" >
                      <br><center>
                        <div id="mensaje" style="visibility:hidden"><font color="#0000FF" size="2" >Estamos procesando su informacion, por favor espere....</font></div>
                      </center>
                      <table width="98%"  border="0" align="center">
                        <tr> 
                          	<td width="81%">
							  	<div align="center"> 
									  <table width="90%"  border="0" cellspacing="0" cellpadding="0">
											<tr> 
												  <td><div align="right">R.U.T. Alumno </div></td>
												  <td width="7%"><div align="center">:</div></td>
												  <td> 
													<%f_busqueda.DibujaCampo("pers_nrut")%>-<%f_busqueda.DibujaCampo("pers_xdv")%>
													<%pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]"%>
												  </td>
											</tr>
									  </table>
								</div>
							</td>
                          <td width="19%"><div align="center"><%f_botonera.DibujaBoton("buscar")%> </div></td>
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

          <% if q_pers_nrut <>"" and f_datos_alumno.nrofilas > 0 then %>

        <table width="650"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
          <tr> 
            <td width="10" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
            <td width="100%" height="8" background="../imagenes/top_r1_c2.gif"></td>
            <td width="10" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
          </tr>
          <tr> 
            <td width="10" background="../imagenes/izq.gif">&nbsp;</td>
            <td align="left"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td height="2" ></td>
                </tr>
                <tr> 
                  <td><div align="center"> 
                      <p> <%pagina.DibujarTituloPagina%> </p>
                      </div>
                    <form name="edicion" method="post">
					<input type="hidden" name="da[0][even_ncorr]" value="<%=v_evento%>">
                      <table width="92%" border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr> 
                          <td width="100%"> <div align="center"> 
                              
							   <p align="left">
                                <%pagina.DibujarSubtitulo "Datos Académicos del Alumno"%>
                              </p>
                              <table width="95%" border="0">
								<tr> 
                                  <td width="162" align="left" valign="middle"><strong><font color="#FF0000">*</font>Colegio</strong></td>
                                  <td width="10" align="left" valign="top"><strong>:</strong></td>
                                  <td width="374">
								  	<%f_datos_alumno.DibujaCampo("regi_ccod_colegio")%><br>
									<%f_datos_alumno.DibujaCampo("ciud_ccod_colegio")%><br>
									<%f_datos_alumno.DibujaCampo("cole_ccod")%>
							      </td>
                                </tr>
                                <tr> 
                                  <td align="left" valign="top"><strong> Otro 
                                    colegio </strong></td>
                                  <td align="left" valign="top"><strong>:</strong></td>
                                  <td><input type="checkbox" name="habilita_cole" onClick="habilita_otro_colegio(this);">
								  <strong>
                                    <%f_datos_alumno.dibujaCampo("pers_totro_colegio")%>
                                    </strong></td>
                                </tr>
								<tr> 
                                  <td width="162" align="left" valign="top"><strong><font color="#FF0000">*</font>Curso</strong></td>
                                  <td width="10" align="left" valign="top"><strong>:</strong></td>
                                  <td width="374"> <%f_datos_alumno.dibujaCampo("caev_ccod")%> </td>
                                </tr>
<!--
                                <tr> 
                                  <td align="left" valign="top"><strong><font color="#FF0000">*</font>Preferencia  
                                    de Estudio</strong></td>
                                  <td align="left" valign="top"><strong>:</strong></td>
                                  <td valign="top"> <strong><%f_datos_alumno.dibujaCampo("pest_ccod")%></strong>  </td>
                                </tr>
-->
                                <tr> 
                                  <td align="left" valign="top"><strong><font color="#FF0000">*</font>Carrera 
                                    de Interes 1</strong></td>
                                  <td align="left" valign="top"><strong>:</strong></td>
                                  <td> <%f_datos_alumno.dibujaCampo("carrera_1")%> </td>
                                </tr>
                                <tr> 
                                  <td align="left" valign="top"><strong>Carrera 
                                    de Interes 2 </strong></td>
                                  <td align="left" valign="top"><strong>:</strong></td>
                                  <td> <%f_datos_alumno.dibujaCampo("carrera_2")%> </td>
                                </tr>
                                <tr> 
                                  <td align="left" valign="top"><strong>Carrera 
                                    de Interes 3</strong></td>
                                  <td align="left" valign="top"><strong>:</strong></td>
                                  <td><strong>
                                    <%f_datos_alumno.dibujaCampo("carrera_3")%>
                                    </strong> </td>
                                </tr>
							  </table>
							  <p align="left"> 
                                <%pagina.DibujarSubtitulo "Identificaci&oacute;n del Alumno"%>
                              </p>
                              <table width="93%" border="0">
                                <tr> 
                                  <td height="27" colspan="2"> <%f_datos_alumno.dibujaCampo("pers_ncorr_alumno")%>
                                  </td>
                                </tr>
								<tr> 
                                  <td><strong><font color="#FF0000">*</font>Rut</strong></td>
                                  <td><strong>:<%=f_datos_alumno.dibujaCampo("pers_nrut")%><%=f_datos_alumno.obtenerValor("pers_nrut")%> - <%=f_datos_alumno.dibujaCampo("pers_xdv")%><%=f_datos_alumno.obtenerValor("pers_xdv")%></strong></td>
                                </tr>
                                <tr> 
                                  <td width="27%"><strong><font color="#FF0000">*</font>Nombres</strong></td>
                                  <td><strong>: 
                                    <%f_datos_alumno.dibujaCampo("pers_tnombre")%>
                                    </strong></td>
                                </tr>
                                <tr> 
                                  <td><strong><font color="#FF0000">*</font>Apellido 
                                    Paterno</strong></td>
                                  <td><strong>: 
                                    <%f_datos_alumno.dibujaCampo("pers_tape_paterno")%>
                                    </strong></td>
                                </tr>
                                <tr> 
                                  <td><strong>Apellido 
                                    Materno</strong></td>
                                  <td><strong>: 
                                    <%f_datos_alumno.dibujaCampo("pers_tape_materno")%>
                                    </strong></td>
                                </tr>
                                <tr> 
                                  <td><strong><font color="#FF0000">*</font>Direcci&oacute;n/Calle</strong></td>
                                  <td><strong>: 
                                    <%f_datos_alumno.dibujaCampo("pers_tdireccion")%>
                                    </strong></td>
                                </tr>
                                <tr> 
                                  <td><strong>Fecha Nacimiento 
                                    </strong></td>
                                  <td><strong>: 
                                    <%f_datos_alumno.dibujaCampo("pers_fnacimiento")%>(dd/mm/aaaa) </strong></td>
                                </tr>
                                <tr> 
                                  <td><strong><font color="#FF0000">*</font>Comuna</strong></td>
                                  <td><strong>: 
                                    <%f_datos_alumno.dibujaCampo("ciud_ccod")%>
                                    </strong></td>
                                </tr>
                                <tr> 
                                  <td><strong>E-mail</strong></td>
                                  <td><strong>: 
                                    <%f_datos_alumno.dibujaCampo("pers_temail")%>
                                    </strong></td>
                                </tr>
                                <tr> 
                                  <td><strong>Tel&eacute;fono Casa</strong></td>
                                  <td><strong>: 
                                    <%f_datos_alumno.dibujaCampo("pers_tfono")%>
                                    </strong></td>
                                </tr>
                                <tr> 
                                  <td><strong>Tel&eacute;fono Celular</strong></td>
                                  <td><strong>: 
                                    <%f_datos_alumno.dibujaCampo("pers_tcelular")%>
                                    </strong></td>
                                </tr>
                              </table>
<p align="left"><strong><font color="#000000">(</font><font color="#FF0000">*<font color="#000000">)</font></font></strong> Campos obligatorios </p>
                             <!--
								 <p align="left"><%pagina.DibujarSubtitulo "Niveles de importancia de beneficios del 1 al 6"%></p>
								<table width="95%" border="0">
								<tr>
                                  <td width="5%" align="left" valign="top"><%f_datos_alumno.dibujaCampo("PERS_NBECAS_CREDITOS")%></td>
                                  <td width="95%">                                  <strong>Becas y Creditos </strong></td>
                                </tr>
                                <tr>
                                  <td align="left" valign="top"><%f_datos_alumno.dibujaCampo("PERS_NCONVENIOS_INTER")%></td>
                                  <td>                                  <strong>Convenios internacionales</strong></td>
                                </tr>
                                <tr>
                                  <td align="left" valign="top"><%f_datos_alumno.dibujaCampo("PERS_NDEPORTE_RECREACION")%></td>
                                  <td>                                  <strong>Deporte y recreacion </strong></td>
                                </tr>
								  <tr>
                                  <td align="left" valign="top"><%f_datos_alumno.dibujaCampo("PERS_NSEGURO_ESCOLAR")%></td>
                                  <td>                                    <strong>Seguro escolar </strong></td>
                                </tr>
                                <tr>
                                  <td align="left" valign="top"><%f_datos_alumno.dibujaCampo("PERS_NTALLER_TEATRO")%></td>
                                  <td>                                  <strong>Talleres de Teatro </strong></td>
                                </tr>
                              
                                <tr>
                                  <td align="left" valign="top"><%f_datos_alumno.dibujaCampo("PERS_NOTRO_BENEFICIO")%></td>
                                  <td>                                  <%f_datos_alumno.dibujaCampo("PERS_TOTRO_BENEFICIO_DESC")%>
                                  <strong>(Otros beneficios ) </strong></td>
                                </tr>
                                
                                
                              </table>
                    -->
                            </div></td>
                        </tr>
                      </table>
                      
                    </form></td>
                </tr>
              </table></td>
            <td width="10" background="../imagenes/der.gif">&nbsp;</td>
          </tr>
          <tr> 
            <td width="10" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
            <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
                <tr> 
                  <td width="38%" height="20"><div align="center"> 
                      <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td><div align="center"> 
						  
                              <%f_botonera.DibujaBoton ("guardar")%>
                            </div></td>
                            <td><div align="center"> 
                            </div></td>
                        </tr>
                      </table>
                    </div></td>
                  <td width="72%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                </tr>
                <tr> 
                  <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
                </tr>
              </table></td>
            <td width="10" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
          </tr>
        </table>
        <p>
          <% end if%>
        </p></td>
    </tr>
  </table>
</div>
</body>
</html>
