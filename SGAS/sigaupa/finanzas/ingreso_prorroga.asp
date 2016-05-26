<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'<!-- #include file = "../biblioteca/_conexion_prod.asp" -->
set pagina = new CPagina
pagina.Titulo = "Ingreso de prorrogas (UPA)"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'-----------------------------------------------------------------------
set botonera = new CFormulario

botonera.Carga_Parametros "Ingreso_Prorroga.xml", "botonera"


'-----------------------------------------------------------------------
 rut_alumno = request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito = request.querystring("busqueda[0][pers_xdv]")
 rut_apoderado = request.querystring("busqueda[0][code_nrut]")
 rut_apoderado_digito = request.querystring("busqueda[0][code_xdv]")
 num_doc = request.querystring("busqueda[0][ding_ndocto]")
 estado_doc = request.querystring("busqueda[0][edin_ccod]")
 vencimiento = request.querystring("busqueda[0][ding_fdocto]")
 tipo_doc = request.querystring("busqueda[0][ting_ccod]")
 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "Ingreso_Prorroga.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut_alumno
 f_busqueda.AgregaCampoCons "pers_xdv", rut_alumno_digito
 f_busqueda.AgregaCampoCons "code_nrut", rut_apoderado
 f_busqueda.AgregaCampoCons "code_xdv", rut_apoderado_digito
 f_busqueda.AgregaCampoCons "ding_ndocto", num_doc
 f_busqueda.AgregaCampoCons "edin_ccod", estado_doc
 f_busqueda.AgregaCampoCons "ding_fdocto", vencimiento
 f_busqueda.AgregaCampoCons "ting_ccod", tipo_doc
'-----------------------------------------------------------------------
 set f_datos = new CFormulario
 f_datos.Carga_Parametros "Ingreso_Prorroga.xml", "f_documentos"
 f_datos.Inicializar conexion

 set f_documentos = new CFormulario
 f_documentos.Carga_Parametros "Ingreso_Prorroga.xml", "f_documentos"
 f_documentos.Inicializar conexion
 
			  
sql = "select convert(varchar,getdate(),103) as fecha_hoy, a.ding_ndocto, a.ding_ndocto as c_ding_ndocto,"& vbCrLf &_
		"        a.ting_ccod, a.edin_ccod, a.edin_ccod as c_edin_ccod, a.ingr_ncorr, g.abon_mabono,"& vbCrLf &_
		"        a.ding_ncorrelativo, a.plaz_ccod, a.banc_ccod, a.ding_fdocto as c_ding_fdocto,"& vbCrLf &_
		"        a.ding_mdetalle, a.ding_mdetalle as c_ding_mdocto, a.ding_mdocto, a.ding_nsecuencia,"& vbCrLf &_
		"        a.ding_tcuenta_corriente, a.envi_ncorr, a.repa_ncorr, c.pers_ncorr,"& vbCrLf &_
		"        protic.obtener_rut(c.pers_ncorr) as rut_alumno, protic.obtener_rut(a.PERS_NCORR_CODEUDOR) as rut_apoderado,"& vbCrLf &_
		"        convert(varchar,b.ingr_fpago,103) as ingr_fpago, convert(varchar,a.ding_fdocto,103) as ding_fdocto,"& vbCrLf &_
		"        i.ting_tdesc, j.edin_tdesc,'' as multa,h.tcom_ccod, h.inst_ccod, h.comp_ndocto,"& vbCrLf &_
		"        h.tcom_ccod as c_tcom_ccod, h.dcom_ncompromiso, "& vbCrLf &_
		"        w.total as reca_mmonto"& vbCrLf &_
		"        from detalle_ingresos a join ingresos b"& vbCrLf &_
        "        	on a.ingr_ncorr = b.ingr_ncorr "& vbCrLf &_
        "		 join personas c"& vbCrLf &_
        "	  	 	on b.pers_ncorr = c.pers_ncorr"& vbCrLf &_
        "        join tipos_ingresos i"& vbCrLf &_
        "           on a.ting_ccod = i.ting_ccod"& vbCrLf &_
        "        join estados_detalle_ingresos j"& vbCrLf &_
        "			on a.edin_ccod = j.edin_ccod"& vbCrLf &_
        "        left outer join personas f"& vbCrLf &_
        "           on a.PERS_NCORR_CODEUDOR = f.pers_ncorr"& vbCrLf &_
        "        join abonos g"& vbCrLf &_
        "           on b.ingr_ncorr = g.ingr_ncorr"& vbCrLf &_
        "        join detalle_compromisos h"& vbCrLf &_
        "           on g.tcom_ccod = h.tcom_ccod  and g.inst_ccod = h.inst_ccod  and g.comp_ndocto = h.comp_ndocto and g.dcom_ncompromiso = h.dcom_ncompromiso"& vbCrLf &_
        "        join compromisos k"& vbCrLf &_
        "           on h.tcom_ccod = k.tcom_ccod and h.inst_ccod = k.inst_ccod  and h.comp_ndocto = k.comp_ndocto"& vbCrLf &_
        "        left outer join (select x.ting_ccod, x.ding_ndocto, x.ingr_ncorr, sum (x.reca_mmonto) as total"& vbCrLf &_
        "                         from referencias_cargos x "& vbCrLf &_
        "                         group by  x.ting_ccod, x.ding_ndocto, x.ingr_ncorr "& vbCrLf &_
        "                         )w"& vbCrLf &_
        "           on  a.ting_ccod = w.ting_ccod  and a.ding_ndocto = w.ding_ndocto and a.ingr_ncorr = w.ingr_ncorr"& vbCrLf &_
        " where a.ding_ncorrelativo > 0  "& vbCrLf &_
        " and a.edin_ccod not in (5,6,11,12,16,17,18,21,22,23,24,25,26,27,28,29,30,36,37,39,41,42,43,44,45,46,99,51) "& vbCrLf &_
		" and a.ting_ccod in (3,4,38,52,88,59,66)"& vbCrLf &_
        " and k.ecom_ccod = 1 "
		
  'response.Write("<pre>"&sql&"</pre>")

  if tipo_doc <> "" then
    sql = sql &  " and a.ting_ccod = isnull('" & tipo_doc & "', a.ting_ccod) "
  end if
  
  if estado_doc <> "" then
    sql = sql &  " and a.edin_ccod = isnull('" & estado_doc & "', a.edin_ccod) "
  end if
  
  if rut_apoderado <> "" then
   sql = sql &  " and cast(f.pers_nrut as varchar) = '" & rut_apoderado & "'"
  end if
  
  if rut_alumno <> "" then
     sql = sql &  " and cast(c.pers_nrut as varchar) ='" & rut_alumno & "'"
  end if
  
  if vencimiento <> "" then
     sql = sql & " and convert(datetime,a.ding_fdocto,103) = isnull(convert(datetime,'" & vencimiento & "',103),convert(datetime,a.ding_fdocto,103)) "
  end if
  
 if num_doc <> "" then
   sql = sql & " and cast(a.ding_ndocto as varchar)= isnull('" & num_doc & "',cast(a.ding_ndocto as varchar)) "
  end if

  sql = sql & "ORDER BY a.ding_fdocto "
  'response.Write("<pre>" & sql & "</pre>")
   'response.End()
  fila = 0
  if Request.QueryString <> "" then
    f_documentos.Consultar sql
	f_datos.Consultar sql
	
	while f_datos.Siguiente
      estado = f_datos.ObtenerValor("edin_ccod")
	  
	  if estado = "18" or estado = "17" or estado = "6" then
	    f_documentos.AgregaCampoFilaParam fila, "multa" , "permiso", "LECTURA"
		 f_documentos.AgregaCampoFilaParam fila, "nueva_fecha" , "permiso", "LECTURA"
		f_documentos.AgregaCampoFilaParam fila, "multa" , "formato", "MONEDA"
	  end if
	fila = fila + 1
	wend
 
  else
	f_documentos.consultar "select '' where 1 = 2"
	f_documentos.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
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
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>

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
	
	rut_apoderado = formulario.elements["busqueda[0][code_nrut]"].value + "-" + formulario.elements["busqueda[0][code_xdv]"].value;	
    if (formulario.elements["busqueda[0][code_nrut]"].value  != '')
	  if (!valida_rut(rut_apoderado)) 
  	   {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][code_xdv]"].focus();
		formulario.elements["busqueda[0][code_xdv]"].select();
		return false;
	   }
	return true;
	}

var tabla;

function inicio()
{
   tabla = new CTabla("documentos");
   //alert('OK');
}

function prorrogar()
{
  var formulario = document.forms["edicion"];
 
  if (validar_datos() == true)
  {  	
    formulario.method = "post";
    formulario.action = "Proc_ingreso_Prorroga.asp";
	formulario.submit();
  }
 
 	
		
/*	if (ValidarFormRepactacion()) {		
		resultado = open("", "wrepactacion", "top=100, left=100, width=860, height=500, scrollbars=yes");	
		formulario.action = "agregar_repactacion.asp"
		formulario.target = "wrepactacion";
		formulario.method = "post";
		formulario.submit();
	}
 */
 
}

function validar_datos()
{
   var valor;
   var salir = "";
   var cont = 0;
   
   if (confirm("¿Esta seguro que desea prorrogar los documentos seleccionados?") == true)
    {
	  if (tabla.filas.length <= 0 )
	     return false;
	  else
	  for (i = 0; i < tabla.filas.length; i++) 
      {  	    
	  	valor = document.edicion.elements["documentos[" + i + "][ding_ndocto]"].checked;	     
        if (valor == true)
		 {
		    fecha_antigua = document.edicion.elements["documentos[" + i + "][c_ding_fdocto]"].value;
			fecha_nueva = document.edicion.elements["documentos[" + i + "][nueva_fecha]"].value;
			if (fecha_nueva != "")
			 {
			   cont++;
			    if (isFecha(fecha_nueva) == true)
				 {
		          if (comparar_fechas() == false)				  
				      return false;
				 }				  
				else { salir = "2";	break;	}
			 }
			else  { salir = "1";  break;   }
		 }
	  }
	  
	  if (salir == "1")
	    {
		  alert("Debe ingresar la nueva fecha de vencimiento");
		  document.edicion.elements["documentos[" + i + "][nueva_fecha]"].focus();
		   return false;
		}
	  if (salir == "2")
	    {
		  alert("La fecha ingresada no es válida");
		  document.edicion.elements["documentos[" + i + "][nueva_fecha]"].select();
		  document.edicion.elements["documentos[" + i + "][nueva_fecha]"].focus();
		   return false;
		}
	}
  else
     return false;
 
 if (cont == 0)  	   
    return false;
 
 return true;
}

function comparar_fechas()
{

fecha_antigua = document.edicion.elements["documentos[" + i + "][c_ding_fdocto]"].value;
fecha_nueva = document.edicion.elements["documentos[" + i + "][nueva_fecha]"].value;


var aa_fecha_termino = fecha_nueva.split(/\//);
var aa_fecha_inicio = fecha_antigua.split(/\//);

var ano_t= aa_fecha_termino[2];
var ano_i=aa_fecha_inicio[2];

var mes_t=aa_fecha_termino[1];
var mes_i=aa_fecha_inicio[1];

var dia_t=aa_fecha_termino[0];
var dia_i=aa_fecha_inicio[0];

var v_fecha_antigua = new Date(ano_i, mes_i -1, dia_i);
var v_fecha_nueva = new Date(ano_t, mes_t - 1, dia_t);
var v_fecha_actual = new Date();

if (v_fecha_nueva <= v_fecha_antigua) {
	alert("La nueva fecha debe ser mayor que la anterior.");
	document.edicion.elements["documentos[" + i + "][nueva_fecha]"].select();
    document.edicion.elements["documentos[" + i + "][nueva_fecha]"].focus();
	return false;
}

if (v_fecha_nueva <= v_fecha_actual) {
	alert("La nueva fecha debe ser mayor que la fecha actual.");
	document.edicion.elements["documentos[" + i + "][nueva_fecha]"].select();
    document.edicion.elements["documentos[" + i + "][nueva_fecha]"].focus();
	return false;
}

return true;




if( parseInt(ano_i) > parseInt(ano_t)) {
    alert("La nueva fecha debe ser mayor que la anterior");
	document.edicion.elements["documentos[" + i + "][nueva_fecha]"].select();
    document.edicion.elements["documentos[" + i + "][nueva_fecha]"].focus();
    return false;
  }
if( (parseInt(ano_i) == parseInt(ano_t))&&(parseInt(mes_i) > parseInt(mes_t)) ) {
    alert("La nueva fecha debe ser mayor que la anterior");
	document.edicion.elements["documentos[" + i + "][nueva_fecha]"].select();
    document.edicion.elements["documentos[" + i + "][nueva_fecha]"].focus();   
    return false;
  }
if( (parseInt(ano_i) == parseInt(ano_t))&&(parseInt(mes_i) == parseInt(mes_t))&& (parseInt(dia_i) >= parseInt(dia_t)) ) {
    alert("La nueva fecha debe ser mayor que la anterior");
	document.edicion.elements["documentos[" + i + "][nueva_fecha]"].select();
    document.edicion.elements["documentos[" + i + "][nueva_fecha]"].focus();   
    return false;
  }

/***********************************************/
/***   ahora compara con la fecha actutal    ***/
/***********************************************/  

fecha_antigua = document.edicion.elements["documentos[" + i + "][fecha_hoy]"].value;
fecha_nueva = document.edicion.elements["documentos[" + i + "][nueva_fecha]"].value;

var aa_fecha_termino = fecha_nueva.split(/\//);
var aa_fecha_inicio = fecha_antigua.split(/\//);

var ano_t= aa_fecha_termino[2];
var ano_i=aa_fecha_inicio[2];

var mes_t=aa_fecha_termino[1];
var mes_i=aa_fecha_inicio[1];

var dia_t=aa_fecha_termino[0];
var dia_i=aa_fecha_inicio[0];

if( parseInt(ano_i) > parseInt(ano_t)) {
    alert("La nueva fecha debe ser mayor que la fecha actual");
	document.edicion.elements["documentos[" + i + "][nueva_fecha]"].select();
    document.edicion.elements["documentos[" + i + "][nueva_fecha]"].focus();
    return false;
  }
if( (parseInt(ano_i) == parseInt(ano_t))&&(parseInt(mes_i) > parseInt(mes_t)) ) {
    alert("La nueva fecha debe ser mayor que la fecha actual");
	document.edicion.elements["documentos[" + i + "][nueva_fecha]"].select();
    document.edicion.elements["documentos[" + i + "][nueva_fecha]"].focus();   
    return false;
  }
if( (parseInt(ano_i) == parseInt(ano_t))&&(parseInt(mes_i) == parseInt(mes_t))&& (parseInt(dia_i) >= parseInt(dia_t)) ) {
    alert("La nueva fecha debe ser mayor que la fecha actual");
	document.edicion.elements["documentos[" + i + "][nueva_fecha]"].select();
    document.edicion.elements["documentos[" + i + "][nueva_fecha]"].focus();   
    return false;
  }  
return true;
}




</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "busqueda[0][ding_fdocto]","1","buscador","fecha_oculta_ding_fdocto"
	calendario.FinFuncion
%>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="inicio();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="100%" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
            <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
            <tr>
              <td width="9"><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="100%" height="1" border="0" alt=""></td>
              <td width="7"><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
            <tr>
              <td width="9"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="100%" height="8" border="0" alt=""></td>
              <td width="7"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
            <tr>
              <td width="9"><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><%pagina.DibujarLenguetas Array("Búsqueda de documentos"), 1%></td>
              <td width="7"><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>              
            </tr>
            <tr>
              <td width="9"><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="100%" height="2" border="0" alt=""></td>
              <td width="7"><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
          </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"><div align="center">
				<form name="buscador">
                      <table width="98%"  border="0">
                        <tr> 
                          <td width="100%"><table width="660" border="0" align="left">
                              <tr> 
                                <td width="92"><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">N&ordm; 
                                    Documento</font></div></td>
                                <td width="9">:</td>
                                <td width="145"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                  <% f_busqueda.DibujaCampo ("ding_ndocto") %>
                                  </font></td>
                                <td width="16"><div align="center"></div></td>
                                <td width="85">tipo</td>
                                <td width="10">:</td>
                                <td width="165"><% f_busqueda.DibujaCampo ("ting_ccod")%></td>
                                <td width="109" rowspan="6"><div align="center"></div>
                                  <div align="center"> 
                                    <%botonera.DibujaBoton "buscar" %>
                                  </div></td>
                              </tr>
                              <tr> 
                                <td><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Rut 
                                    Alumno </font></div></td>
                                <td>:</td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                  <% f_busqueda.DibujaCampo ("pers_nrut") %>
                                  - 
                                  <% f_busqueda.DibujaCampo ("pers_xdv") %>
                                  </font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a><font face="Verdana, Arial, Helvetica, sans-serif" size="1">&nbsp; 
                                  </font></td>
                                <td>&nbsp;</td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Rut 
                                  Apoderado</font></td>
                                <td>:</td>
                                <td><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                    <% f_busqueda.DibujaCampo ("code_nrut") %>
                                    - 
                                    <% f_busqueda.DibujaCampo ("code_xdv") %>
                                    </font><a href="javascript:buscar_persona('busqueda[0][code_nrut]', 'busqueda[0][code_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></div></td>
                              </tr>
                              <tr> 
                                <td>F. Vencimiento</td>
                                <td>:</td>
                                <td><% f_busqueda.DibujaCampo ("ding_fdocto")%>
								     <%calendario.DibujaImagen "fecha_oculta_ding_fdocto","1","buscador" %>(dd/mm/aaaa)</td>
                                <td>&nbsp;</td>
                              </tr>
							  <tr>
							                                  <td>Estado</td>
                                <td>:</td>
                                <td> <% f_busqueda.DibujaCampo ("edin_ccod") %> </td>
							  </tr>
                          
                            </table></td>
                        </tr>
                      </table>
				</form>
                </div></td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="100%" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>			
          </td>
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
                <td> 
                  <%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1%>
                </td>
              </tr>
              <tr> 
                <td height="2" background="../imagenes/top_r3_c2.gif"></td>
              </tr>
              <tr> 
                <td><div align="center"><br>
                    <%pagina.DibujarTituloPagina%>
                    <table width="100%" border="0">
                      <tr> 
                        <td width="116">&nbsp;</td>
                        <td width="97%">
<div align="right">P&aacute;ginas: &nbsp; 
                            <% f_documentos.AccesoPagina %>
                          </div></td>
                        <td width="3%"> 
                          <div align="right"> </div></td>
                      </tr>
                    </table>
                    <br>
                  </div>
                  <form name="edicion">
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td> <div align="center">
                            <% f_documentos.DibujaTabla()%>
                            <br>
                          </div></td>
                      </tr>
                    </table>
                    <br>
                  </form></td>
              </tr>
            </table></td>
          <td width="7" background="../imagenes/der.gif">&nbsp;</td>
        </tr>
        <tr> 
          <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
          <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="25%" height="20"><div align="center"> 
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td> <div align="left">
                            <% botonera.DibujaBoton ("prorrogar") %>
                          </div></td>
                        <td> <div align="left">
                            <% botonera.DibujaBoton ("lanzadera")%>
                          </div></td>
                        <td><div align="center"></div></td>
                      </tr>
                    </table>
                  </div></td>
                <td width="75%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
              </tr>
              <tr> 
                <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
              </tr>
            </table></td>
          <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
        </tr>
      </table>
      <p>&nbsp;</p>
      <p>&nbsp;</p></td>
  </tr>  
</table>
</body>
</html>
