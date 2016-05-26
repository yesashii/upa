<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION				:	
'FECHA CREACIÓN				:
'CREADO POR					:
'ENTRADA					: NA
'SALIDA						: NA
'MODULO QUE ES UTILIZADO	: EGRESO Y TITULACION
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION		: 20/02/2013
'ACTUALIZADO POR			: Luis Herrera G.
'MOTIVO						: Corregir código, eliminar sentencia *=
'LINEA						: 60
'********************************************************************

set pagina = new CPagina
pagina.Titulo = "Registro de antecedentes de Titulados y Egresados"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
rut = request.querystring("busqueda[0][pers_nrut]")
digito = request.querystring("busqueda[0][pers_xdv]")
grabar = request.querystring("grabar")
'--------------------------------------------------------------------------



 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "antecedentes_titulados_escuela.xml", "busqueda_usuarios_nuevo"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' "
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut
 f_busqueda.AgregaCampoCons "pers_xdv", digito
'--------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "antecedentes_titulados_escuela.xml", "botonera"
'--------------------------------------------------------------------------
set datos_personales = new CFormulario
datos_personales.Carga_Parametros "tabla_vacia.xml", "tabla"
datos_personales.Inicializar conexion
'consulta_datos =  " select a.pers_ncorr,protic.format_rut(pers_nrut) as rut, pers_temail, "& vbCrLf &_
'				  " isnull(pers_tcelular,(select top 1 pers_tcelular from direcciones where pers_ncorr=a.pers_ncorr and pers_tcelular is not null)) as pers_tcelular, "& vbCrLf &_
'				  " isnull(pers_tfono,(select top 1 pers_tfono from direcciones where pers_ncorr=a.pers_ncorr and pers_tfono is not null)) as pers_tfono,    "& vbCrLf &_
'				  " a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' +a.pers_tape_materno as nombre, "& vbCrLf &_
'				  " b.sexo_tdesc as sexo,c.pais_tdesc as pais "& vbCrLf &_
'				  " from personas_postulante a,sexos b,paises c "& vbCrLf &_
'				  " where cast(a.pers_nrut as varchar)='"&rut&"' "& vbCrLf &_
'				  " and a.sexo_ccod *=b.sexo_ccod "& vbCrLf &_
'				  " and a.pais_ccod=c.pais_ccod"
consulta_datos =  "select a.pers_ncorr, "& vbCrLf &_
		"	protic.format_rut(pers_nrut) as rut, "& vbCrLf &_ 
		"	pers_temail, "& vbCrLf &_
		"	isnull "& vbCrLf &_
		"	( "& vbCrLf &_
		"		pers_tcelular, "& vbCrLf &_
		"		( "& vbCrLf &_
		"			select top 1 pers_tcelular "& vbCrLf &_
		"			from direcciones "& vbCrLf &_
		"			where pers_ncorr=a.pers_ncorr "& vbCrLf &_ 
		"				and pers_tcelular is not null "& vbCrLf &_
		"		) "& vbCrLf &_
		"	) as pers_tcelular, "& vbCrLf &_ 
		"	isnull "& vbCrLf &_
		"	( "& vbCrLf &_
		"		pers_tfono, "& vbCrLf &_
		"		( "& vbCrLf &_
		"			select top 1 pers_tfono "& vbCrLf &_
		"			from direcciones "& vbCrLf &_
		"			where pers_ncorr=a.pers_ncorr "& vbCrLf &_ 
		"			and pers_tfono is not null "& vbCrLf &_
		"		) "& vbCrLf &_
		"	) as pers_tfono, "& vbCrLf &_
		"	a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' +a.pers_tape_materno as nombre, "& vbCrLf &_
		"	b.sexo_tdesc as sexo, "& vbCrLf &_
		"	c.pais_tdesc as pais "& vbCrLf &_
		"from personas_postulante a	"& vbCrLf &_
		"left outer join sexos b "& vbCrLf &_
		"	on a.sexo_ccod = b.sexo_ccod "& vbCrLf &_	 
		"join paises c "& vbCrLf &_	
		"	on a.pais_ccod=c.pais_ccod "& vbCrLf &_
		"where cast(a.pers_nrut as varchar)='"&rut&"' "
datos_personales.Consultar consulta_datos
datos_personales.siguiente

codigo 			= datos_personales.obtenerValor("pers_ncorr")
rut_completo 	= datos_personales.obtenerValor("rut")
nombre 	= datos_personales.obtenerValor("nombre")
sexo 	= datos_personales.obtenerValor("sexo")
pais 	= datos_personales.obtenerValor("pais")
pers_tcelular 	= datos_personales.obtenerValor("pers_tcelular")
pers_tfono 		= datos_personales.obtenerValor("pers_tfono")
pers_temail 	= datos_personales.obtenerValor("pers_temail")
v_peri_ccod  = negocio.ObtenerPeriodoAcademico("POSTULACION")
'pais = datos_personales.obtenerValor("pais")

set fc_matriculas = new CFormulario
fc_matriculas.Carga_Parametros "antecedentes_titulados_escuela.xml", "info_carreras"
fc_matriculas.Inicializar conexion

sql_matriculas = " select distinct e.carr_ccod, f.carr_tdesc as carrera, h.jorn_tdesc as jornada, " & vbcrlf & _
				 " (select top 1 t4.plan_ccod  " & vbcrlf & _
				 " from alumnos tt, ofertas_academicas t2, especialidades t3,planes_estudio t4, " & vbcrlf & _
				 "      estados_matriculas t5 " & vbcrlf & _
				 " where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod " & vbcrlf & _
				 " and tt.pers_ncorr=a.pers_ncorr and t3.carr_ccod=f.carr_ccod  " & vbcrlf & _
				 " and tt.plan_ccod=t4.plan_ccod and tt.emat_ccod=t5.emat_ccod " & vbcrlf & _
				 " order by t2.peri_ccod desc, tt.alum_fmatricula desc) as plan_ccod, " & vbcrlf & _
				 "(select top 1 plan_tdesc " & vbcrlf & _
				 " from alumnos tt, ofertas_academicas t2, especialidades t3,planes_estudio t4, " & vbcrlf & _
				 "      estados_matriculas t5 " & vbcrlf & _
				 " where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod " & vbcrlf & _
				 " and tt.pers_ncorr=a.pers_ncorr and t3.carr_ccod=f.carr_ccod  " & vbcrlf & _
				 " and tt.plan_ccod=t4.plan_ccod and tt.emat_ccod=t5.emat_ccod " & vbcrlf & _
				 " order by t2.peri_ccod desc, tt.alum_fmatricula desc) as plan_tdesc, " & vbcrlf & _
				 "(select top 1 emat_tdesc  " & vbcrlf & _
				 " from alumnos tt, ofertas_academicas t2, especialidades t3,planes_estudio t4, " & vbcrlf & _
				 "      estados_matriculas t5 " & vbcrlf & _
				 " where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod " & vbcrlf & _
				 " and tt.pers_ncorr=a.pers_ncorr and t3.carr_ccod=f.carr_ccod  " & vbcrlf & _
				 " and tt.plan_ccod=t4.plan_ccod and tt.emat_ccod=t5.emat_ccod " & vbcrlf & _
				 " order by t2.peri_ccod desc, tt.alum_fmatricula desc) as emat_tdesc " & vbcrlf & _
				 " from personas a, alumnos b, ofertas_academicas c, especialidades e, carreras f,jornadas h " & vbcrlf & _
			 	 " where a.pers_ncorr=b.pers_ncorr and b.ofer_ncorr=c.ofer_ncorr and c.espe_ccod=e.espe_ccod " & vbcrlf & _
				 " and e.carr_ccod=f.carr_ccod and c.jorn_ccod=h.jorn_ccod  " & vbcrlf & _
				 " and cast(a.pers_ncorr as varchar) = '"&codigo&"' " 

'response.write sql_matriculas
fc_matriculas.Consultar sql_matriculas

num = fc_matriculas.nrofilas

%>


<html>
<head>
<title>Antecedentes de Titulados y Egresados</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

function Validar()
{
	formulario = document.buscador;
	
	rut_alumno = formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value;	
	if (formulario.elements["busqueda[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].focus();
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	  }
	
	
	return true;
}

function genera_digito (rut){
 var IgStringVerificador, IgN, IgSuma, IgDigito, IgDigitoVerificador, rut;
 var texto_rut = new String(rut);
 var posicion_guion = 0;
 
 posicion_guion = texto_rut.indexOf("-");
 if (posicion_guion != -1)
 {
    texto_rut = texto_rut.substring(0,posicion_guion);
    document.buscador.elements["busqueda[0][pers_nrut]"].value= texto_rut;
	rut = texto_rut;
 }
// texto_rut.
 //alert(texto_rut);
   if (rut.length==7) rut = '0' + rut; 

   
   IgStringVerificador = '32765432';
   IgSuma = 0;
   for( IgN = 0; IgN < 8 && IgN < rut.length; IgN++)
      IgSuma = eval(IgSuma + '+' + rut.substr(IgN, 1) + '*' + IgStringVerificador.substr(IgN, 1) + ';');
   IgDigito = 11 - IgSuma % 11;
   IgDigitoVerificador = IgDigito==10?'K':IgDigito==11?'0':IgDigito;
   //alert(IgDigitoVerificador);
buscador.elements["busqueda[0][pers_xdv]"].value=IgDigitoVerificador;
//alert(rut+IgDigitoVerificador);
_Buscar(this, document.forms['buscador'],'', 'Validar();', 'FALSE');
}


function practica(formulario)
{
	//tiene_contrato =<%'=tiene_contrato%>
	valor = uno_seleccionado(formulario);
	indice = -1;
	if	(valor == 1)// se selecciono uno
		{
		for	( i = 0; i < nro; i++ ) 
			{
			comp = formulario.elements[i];
			str  = formulario.elements[i].name;
			if	((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo'))
				{
                   indice=extrae_indice(str);
				}
			}
			if (indice > -1)
			{
			        //alert(formulario.elements["m["+indice+"][plan_ccod]"].value);
					v_plan_ccod = formulario.elements["m["+indice+"][plan_ccod]"].value;
				    irA('antecedentes_titulados_escuela_practica.asp?plan_ccod='+v_plan_ccod+'&pers_ncorr=<%=codigo%>', '1', 750, 400);
			}
		//alert("Opción de impresión sólo para contratos activos.");	
		//return false;	
		}
	else	
		{
		alert("Debe seleccionar una carrera ")
		}
}

function comision_tesis(formulario)
{
	//tiene_contrato =<%'=tiene_contrato%>
	valor = uno_seleccionado(formulario);
	indice = -1;
	if	(valor == 1)// se selecciono uno
		{
		for	( i = 0; i < nro; i++ ) 
			{
			comp = formulario.elements[i];
			str  = formulario.elements[i].name;
			if	((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo'))
				{
                   indice=extrae_indice(str);
				}
			}
			if (indice > -1)
			{
			        //alert(formulario.elements["m["+indice+"][plan_ccod]"].value);
					v_plan_ccod = formulario.elements["m["+indice+"][plan_ccod]"].value;
				    irA('antecedentes_titulados_escuela_comision.asp?plan_ccod='+v_plan_ccod+'&pers_ncorr=<%=codigo%>', '1', 750, 400);
			}
		//alert("Opción de impresión sólo para contratos activos.");	
		//return false;	
		}
	else	
		{
		alert("Debe seleccionar una carrera ")
		}
}

function datos_tesis(formulario)
{
	//tiene_contrato =<%'=tiene_contrato%>
	valor = uno_seleccionado(formulario);
	indice = -1;
	if	(valor == 1)// se selecciono uno
		{
		for	( i = 0; i < nro; i++ ) 
			{
			comp = formulario.elements[i];
			str  = formulario.elements[i].name;
			if	((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo'))
				{
                   indice=extrae_indice(str);
				}
			}
			if (indice > -1)
			{
			        //alert(formulario.elements["m["+indice+"][plan_ccod]"].value);
					v_plan_ccod = formulario.elements["m["+indice+"][plan_ccod]"].value;
				    irA('antecedentes_titulados_escuela_tesis.asp?plan_ccod='+v_plan_ccod+'&pers_ncorr=<%=codigo%>', '1', 750, 400);
			}
		//alert("Opción de impresión sólo para contratos activos.");	
		//return false;	
		}
	else	
		{
		alert("Debe seleccionar una carrera ")
		}
}

function uno_seleccionado(form)
{
	  	nro = form.elements.length;
   		num =0;
	   for( i = 0; i < nro; i++ ) {
		  comp = form.elements[i];
		  str  = form.elements[i].name;
		  
		  if((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo')){
	 		num += 1;
		  }
	   }
	   return num;
}
 

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
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
                      <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
                      <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                      <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td width="15" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                            <td width="210" valign="bottom" background="../imagenes/fondo1.gif"> 
                              <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador 
                                </font></div></td>
                            <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                            <td width="423" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                          </tr>
                        </table></td>
                      <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                      <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                      <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
                    </tr>
                  </table>
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                      <td bgcolor="#D8D8DE"><div align="center"> 
                          <form name="buscador">
                            <table width="98%"  border="0">
                              <tr> 
                                <td width="81%"><table width="524" border="0">
                                    <tr> 
                                      <td width="98">Rut Usuario</td>
                                      <td width="23">:</td>
                                      <td width="389"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                        <%f_busqueda.DibujaCampo("pers_nrut") %>
                                        - 
                                        <%f_busqueda.DibujaCampo("pers_xdv")%>
                                        </font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
                                    </tr>
                                  </table></td>
                                <td width="19%"><div align="center"> 
                                    <%botonera.DibujaBoton "buscar" %>
                                  </div></td>
                              </tr>
                            </table>
                          </form>
                        </div></td>
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
	<br>		
	<%if rut <> "" then%>
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
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Datos 
                          Encontrados</font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0" aling="center">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  
                <td bgcolor="#D8D8DE"> <div align="center">&nbsp; 
                    <BR>
					<%pagina.DibujarTituloPagina%>
                  </div>
                  <%if rut<>"" then%>
				  <table width="100%" border="0">
                    <tr> 
                      <td colspan="3">&nbsp;</td>
					</tr>
					<tr> 
                      <td align="left" width="15%"><strong>C&oacute;digo</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td width="83%" align="left"><%=codigo%></td>
					</tr>
					<tr> 
                      <td align="left" width="15%"><strong>R.U.T.</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left"><%=rut_completo%></td>
					</tr>
					<tr> 
                      <td align="left" width="15%"><strong>Nombre</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left"><%=nombre%></td>
					</tr>
					<tr> 
                      <td align="left" width="15%"><strong>Email</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left"><%=pers_temail%></td>
					</tr>
					<tr> 
                      <td align="left" width="15%"><strong>Celular</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left"><%=pers_tcelular%></td>
					</tr>
					<tr> 
                      <td align="left" width="15%"><strong>Fono Fijo</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left"><%=pers_tfono%></td>
					</tr>
					<tr> 
                      <td align="left" width="15%"><strong>Sexo</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left"><%=sexo%></td>
					</tr>
					<tr> 
                      <td align="left" width="15%"><strong>Pa&iacute;s</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left"><%=pais%></td>
					</tr>
					<tr> 
                      <td colspan="3">&nbsp;</td>
					</tr>
					<form name="edicion" method="post" target="_self">
					    <input type="hidden" name="pers_ncorr" value="<%=codigo%>">
						<tr> 
						  <td  colspan="3"><%pagina.DibujarSubtitulo "Paso 1: Seleccione Carrera"%></td>
						</tr>
						<tr> 
						  <td colspan="3">&nbsp;</td>
						</tr>
						<tr> 
						  <td  colspan="3" align="center"><%fc_matriculas.dibujatabla()%></td>
						</tr>
						<tr> 
						  <td colspan="3">&nbsp;</td>
						</tr>
						<tr> 
						  <td  colspan="3"><%pagina.DibujarSubtitulo "Paso 2: Presione sobre el botón de la acción a realizar"%></td>
						</tr>
						<tr> 
						  <td colspan="3">&nbsp;</td>
						</tr>
						<tr> 
						  <td colspan="3" align="center">
						  		<table width="75%" cellpadding="0" cellspacing="0">
									<tr>
										<td width="33%" align="center"><%  botonera.dibujaboton "practica"%></td>
										<td width="34%" align="center"><%  botonera.dibujaboton "comision"%></td>
										<td width="33%" align="right"><%  botonera.dibujaboton "tesis"%></td>
									</tr>
								</table>
						  </td>
						</tr>
						<tr> 
						  <td colspan="3">&nbsp;</td>
						</tr>
						<tr> 
						  <td colspan="3">&nbsp;</td>
						</tr>
					</form>
                  </table>
				  <%end if%>
				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="101" nowrap bgcolor="#D8D8DE"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                       <td width="54%">
                        <%  botonera.dibujaboton "salir"%>
                      </td>
					  <td width="40%">&nbsp;
					   
					  </td>
                    </tr>
                  </table></td>
                  <td width="309" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="267" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<%end if%>
			<BR>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
