<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Ingreso de cedentes banco"
'-----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'----------------------------------------------------------------------
set cajero = new CCajero
cajero.inicializar conexion, negocio.obtenerUsuario, negocio.obtenerSede

if not cajero.TieneCajaAbierta then
  session("mensajeerror")= "No puede ingresar cedentes sin tener una caja abierta"
  response.Redirect("../lanzadera/lanzadera.asp") 
 end if
 
'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Ingreso_Cedentes.xml", "botonera"
'-----------------------------------------------------------------------
 rut_alumno = request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito = request.querystring("busqueda[0][pers_xdv]")
 rut_apoderado = request.querystring("busqueda[0][code_nrut]")
 rut_apoderado_digito = request.querystring("busqueda[0][code_xdv]")
 num_doc = request.querystring("busqueda[0][ding_ndocto]")
  
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "Ingreso_Cedentes.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut_alumno
 f_busqueda.AgregaCampoCons "pers_xdv", rut_alumno_digito
 f_busqueda.AgregaCampoCons "code_nrut", rut_apoderado
 f_busqueda.AgregaCampoCons "code_xdv", rut_apoderado_digito
 f_busqueda.AgregaCampoCons "ding_ndocto", num_doc
' -----------------------------------------------------------------------
 set f_letras = new CFormulario
 f_letras.Carga_Parametros "Ingreso_Cedentes.xml", "f_letras"
 f_letras.Inicializar conexion
 
'		sql =   "select x.*, total_recepcionar_cuota(x.tcom_ccod, x.inst_ccod, x.comp_ndocto, x.dcom_ncompromiso) as saldo_cuota, "& vbCrLf  &_
'			    "      total_recepcionar_cuota(x.tcom_ccod, x.inst_ccod, x.comp_ndocto, x.dcom_ncompromiso) as c_saldo_cuota "& vbCrLf  &_
'			    "from ( "& vbCrLf  &_
'				"	   SELECT a.ding_ndocto, a.ding_ndocto as c_ding_ndocto, a.ding_nsecuencia, a.ting_ccod, a.ingr_ncorr, d.ting_tdesc,   "& vbCrLf  &_
'				"			   c.edin_ccod, c.edin_tdesc, trunc(b.ingr_fpago) as ingr_fpago, trunc(a.ding_fdocto) as ding_fdocto, "& vbCrLf  &_
'				"			   f.pers_nrut || '-' || f.pers_xdv as rut_alumno, "& vbCrLf  &_
'				"			   h.pers_nrut || '-' || h.pers_xdv as rut_apoderado, a.ding_mdetalle, "& vbCrLf  &_
'				"			   i.tcom_ccod, i.inst_ccod, i.comp_ndocto, i.dcom_ncompromiso  	       "& vbCrLf  &_
'				"	   FROM detalle_ingresos a, ingresos b, estados_detalle_ingresos c, tipos_ingresos d, "& vbCrLf  &_
'				"			personas f, personas h, abonos i   "& vbCrLf  &_
'				"	   WHERE a.ting_ccod = 4	   "& vbCrLf  &_
'				"		 and a.ding_ncorrelativo = 1  "& vbCrLf  &_
'				"		 and c.fedi_ccod IN (4,20)   "& vbCrLf  &_
'				"		 and a.ingr_ncorr = b.ingr_ncorr   "& vbCrLf  &_
'				"		 and b.ingr_ncorr = i.ingr_ncorr   "& vbCrLf  &_
'				"		 and a.edin_ccod = c.edin_ccod   "& vbCrLf  &_
'				"		 and a.ting_ccod = d.ting_ccod    "& vbCrLf  &_
'				"		 and b.pers_ncorr = f.pers_ncorr   "& vbCrLf  &_
'				"		 and a.pers_ncorr_codeudor = h.pers_ncorr (+) "& vbCrLf
				
sql = "select x.*, x.ding_mdetalle as c_monto_total, protic.total_recepcionar_cuota(x.tcom_ccod, x.inst_ccod, x.comp_ndocto, x.dcom_ncompromiso) as saldo_cuota, "& vbCrLf  &_
	"      protic.total_recepcionar_cuota(x.tcom_ccod, x.inst_ccod, x.comp_ndocto, x.dcom_ncompromiso) as c_saldo_cuota "& vbCrLf  &_
	"from ( "& vbCrLf  &_
	"	   SELECT a.ding_ndocto, a.ding_ndocto as c_ding_ndocto, a.ding_nsecuencia, a.ting_ccod, a.ingr_ncorr, d.ting_tdesc,   "& vbCrLf  &_
	"			   c.edin_ccod, c.edin_tdesc, convert(varchar,b.ingr_fpago,103) as ingr_fpago, convert(varchar,a.ding_fdocto,103) as ding_fdocto, "& vbCrLf  &_
	"			   cast(f.pers_nrut as varchar) + '-' + f.pers_xdv as rut_alumno,convert(varchar,a.ding_fdocto,103) as c_ding_fdocto, "& vbCrLf  &_
	"			   cast(h.pers_nrut as varchar) + '-' + h.pers_xdv as rut_apoderado, a.ding_mdetalle, "& vbCrLf  &_
	"			   i.tcom_ccod, i.inst_ccod, i.comp_ndocto, i.dcom_ncompromiso  	       "& vbCrLf  &_
	" FROM "& vbCrLf  &_
	" detalle_ingresos a join ingresos b"& vbCrLf  &_
	"    on a.ingr_ncorr = b.ingr_ncorr   "& vbCrLf  &_
	" join estados_detalle_ingresos c"& vbCrLf  &_
	"    on a.edin_ccod = c.edin_ccod   "& vbCrLf  &_
	" join tipos_ingresos d"& vbCrLf  &_
	"    on a.ting_ccod = d.ting_ccod    "& vbCrLf  &_
	" join personas f"& vbCrLf  &_
	"    on b.pers_ncorr = f.pers_ncorr   "& vbCrLf  &_
	" left outer join personas h"& vbCrLf  &_
	"    on a.pers_ncorr_codeudor = h.pers_ncorr  "& vbCrLf  &_
	" join abonos i"& vbCrLf  &_
	"    on b.ingr_ncorr = i.ingr_ncorr"& vbCrLf  &_      
	" WHERE a.ting_ccod = 4	   "& vbCrLf  &_
	" and a.ding_ncorrelativo = 1  "& vbCrLf  &_
	" and c.fedi_ccod IN (4,20)"& vbCrLf  
						 if num_doc <> "" then
						   sql = sql + " and a.ding_ndocto = isnull('" & num_doc & "', a.ding_ndocto) "& vbCrLf
						 end if 
					     
						 if rut_alumno <> "" then
						   sql = sql + " and f.pers_nrut = isnull('" & rut_alumno & "', f.pers_nrut) "& vbCrLf
					     end if					  
					     
						 if rut_apoderado <> "" then
					       sql = sql +  " and h.pers_nrut = isnull('" & rut_apoderado & "', h.pers_nrut) "& vbCrLf
					     end if				
				
				sql = sql & "	) x   "& vbCrLf  &_
				"  ORDER BY x.ding_ndocto   "& vbCrLf			

	
  if Request.QueryString <> "" then
	'response.Write("<PRE>" & sql & "</PRE>")
	'response.End()
	f_letras.consultar sql
  else
	f_letras.consultar "select '' where 1 = 2"
	f_letras.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
  end if
'response.Write("<pre>"&sql&"</pre>")
'response.End()	  
cantidad=f_letras.nroFilas
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

<script language='JavaScript'> 
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


  function procesar_click()
  {
    var valor;	
	for (i = 0; i < tabla.filas.length; i++) 
     {  	    
	  	valor = document.edicion.elements["_letras[" + i + "][check]"].checked;	     
		if (valor == true) 
		  {		    
		  
		  
		    monto=document.edicion.elements["letras[" + i + "][c_saldo_cuota]"].value;
			monto_letra=document.edicion.elements["letras[" + i + "][c_monto_total]"].value;
			
			v_saldo_letra= eval(parseInt(monto_letra)-parseInt(monto));
			//alert(v_saldo_letra);
			if(v_saldo_letra>0){
				alert("No puede ingresar este cedente porque ya registra pagos");
				document.edicion.elements["letras[" + i + "][edin_ccod]"].setAttribute("disabled", true);
				document.edicion.elements["_letras[" + i + "][check]"].checked=false;
				document.edicion.elements["_letras[" + i + "][check]"].disabled=true;
			}else{
				document.edicion.elements["letras[" + i + "][edin_ccod]"].setAttribute("disabled", false);
		 		document.edicion.elements["letras[" + i + "][oculto]"].value =document.edicion.elements["letras[" + i + "][ding_ndocto]"].value
			}			
		  }
		 else
		 {
   		    document.edicion.elements["letras[" + i + "][oculto]"].value ="";
		    document.edicion.elements["letras[" + i + "][edin_ccod]"].setAttribute("disabled", true);
  		    document.edicion.elements["_letras[" + i + "][multa]"].setAttribute("disabled", true);
		    document.edicion.elements["letras[" + i + "][nueva_fecha]"].setAttribute("disabled", true)
		 }
	  }	  
  }
  
 function procesar_tabla()
  {
    //var tabla = new CTabla("letras");
    var valor;	
	for (i = 0; i < tabla.filas.length; i++) 
     {  	    
	   valor = document.edicion.elements["_letras[" + i + "][check]"].checked;
	   
	   if (valor == true)	 
	     {
		 
	          estado = tabla.ObtenerValor(i, "edin_ccod");
			  if ((estado == 6) || (estado == 7))
			    {	
					
				  document.edicion.elements["_letras[" + i + "][multa]"].setAttribute("disabled", true);
				  document.edicion.elements["letras[" + i + "][nueva_fecha]"].setAttribute("disabled", true);			      			      			    
				} 
			  if (estado == 18)
                {
					
				  document.edicion.elements["_letras[" + i + "][multa]"].setAttribute("disabled", false);
				  document.edicion.elements["letras[" + i + "][nueva_fecha]"].setAttribute("disabled", true);			      			      			    
				}
	 		  
			  if (estado == 19)
 			   {
			   
                  document.edicion.elements["_letras[" + i + "][multa]"].setAttribute("disabled", false);
				  document.edicion.elements["letras[" + i + "][nueva_fecha]"].setAttribute("disabled", true);			      			      			    
			   }
			   
			   if (estado == 20)
 			   {
			   
                  document.edicion.elements["_letras[" + i + "][multa]"].setAttribute("disabled", false);
				  document.edicion.elements["letras[" + i + "][nueva_fecha]"].setAttribute("disabled", false);			      			      			    
			   }			
	     }
	}  
  }

var tabla;

function inicio()
{
   tabla = new CTabla("letras");
}


function comparar_fechas()
{
	for (i = 0; i < tabla.filas.length; i++) {
		 valor = document.edicion.elements["_letras[" + i + "][check]"].checked;
	   
	   if (valor == true)	 
	     {
	          estado = tabla.ObtenerValor(i, "edin_ccod");
			  if (estado == 20){
			  	//alert(estado+"No ha fallado el campo : "+i);	
				fecha_antigua 	= document.edicion.elements["letras[" + i + "][c_ding_fdocto]"].value;
				fecha_nueva 	= document.edicion.elements["letras[" + i + "][nueva_fecha]"].value;
				
					
					//alert("fecha_antigua: "+fecha_antigua);
					//alert("fecha_nueva: "+fecha_nueva);
					
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
					
			// haciendo convercion inplicita a numeros
					ano_i=ano_i*1;
					mes_i=mes_i*1;
					dia_i=dia_i*1;
					
					ano_t=ano_t*1;
					mes_t=mes_t*1;
					dia_t=dia_t*1;
					
				
					if( parseInt(ano_i) > parseInt(ano_t)) {
						alert("La nueva fecha debe ser mayor que la anterior");
						document.edicion.elements["letras[" + i + "][nueva_fecha]"].select();
						document.edicion.elements["letras[" + i + "][nueva_fecha]"].focus();
						return false;
					  }
					 
					if( (parseInt(ano_i) == parseInt(ano_t) )&&(parseInt(mes_i) > parseInt(mes_t) ) ) {
						alert("La nueva fecha debe ser mayor que la anterior");
						document.edicion.elements["letras[" + i + "][nueva_fecha]"].select();
						document.edicion.elements["letras[" + i + "][nueva_fecha]"].focus();   
						return false;
					  }
					if( (parseInt(ano_i) == parseInt(ano_t))&&(parseInt(mes_i) == parseInt(mes_t))&& (parseInt(dia_i) >= parseInt(dia_t)) ) {
						alert("La nueva fecha debe ser mayor que la anterior");
						document.edicion.elements["letras[" + i + "][nueva_fecha]"].select();
						document.edicion.elements["letras[" + i + "][nueva_fecha]"].focus();   
						return false;
					  }
				
					if (v_fecha_nueva <= v_fecha_antigua) {
						alert("La nueva fecha debe ser mayor que la anterior.");
						document.edicion.elements["letras[" + i + "][nueva_fecha]"].select();
						document.edicion.elements["letras[" + i + "][nueva_fecha]"].focus();
						return false;
					}
				
					if (v_fecha_nueva <= v_fecha_actual) {
						alert("La nueva fecha debe ser mayor que la fecha actual.");
						document.edicion.elements["letras[" + i + "][nueva_fecha]"].select();
						document.edicion.elements["letras[" + i + "][nueva_fecha]"].focus();
						return false;
					}
				
			}	
		}
	}

return true;
}




</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="inicio();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
                      <td width="84%"><div align="center">
                        <table width="524" border="0">
                          <tr>
                            <td>N&ordm; Letra</td>
                            <td>:</td>
                                  <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                                    <% f_busqueda.DibujaCampo ("ding_ndocto") %>
                                    </font></td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                          </tr>
                          <tr>
                            <td>Rut Alumno</td>
                            <td>:</td>
                                  <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                    <% f_busqueda.DibujaCampo ("pers_nrut") %>
                                    - 
                                    <% f_busqueda.DibujaCampo ("pers_xdv") %>
                                    </font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a><font face="Verdana, Arial, Helvetica, sans-serif" size="1">&nbsp; 
                                    </font></td>
                            <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Rut
                                Apoderado</font></td>
                            <td>:</td>
                            <td><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                      <% f_busqueda.DibujaCampo ("code_nrut") %>
                                      - 
                                      <% f_busqueda.DibujaCampo ("code_xdv") %>
                                      </font><a href="javascript:buscar_persona('busqueda[0][code_nrut]', 'busqueda[0][code_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></div>
                            </td>
                          </tr>
                        </table>
                      </div></td>
                      <td width="16%"><div align="center"><% botonera.DibujaBoton ("buscar")%></div></td>
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
                        <td> <div align="right">P&aacute;ginas: &nbsp; 
                            <% f_letras.AccesoPagina %>
                          </div></td>
                        <td width="3%"> <div align="right"> </div></td>
                      </tr>
                    </table>
                    <br>
                  </div>
                  <form name="edicion">
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td> <div align="center">
                            <% f_letras.DibujaTabla()%>
                            <br>
                          </div></td>
                      </tr>
                    </table>
                   
                  </form></td>
              </tr>
            </table></td>
          <td width="7" background="../imagenes/der.gif">&nbsp;</td>
        </tr>
        <tr> 
          <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
          <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="20%" height="20"><div align="center"> 
                    <table width="65%"  border="0" align="left" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td width="32%"><div align="center">
                            <%if cint(cantidad)=0 then
						        botonera.agregabotonparam "ingresar", "deshabilitado" ,"TRUE"
						      end if 
							  botonera.DibujaBoton ("ingresar") %>
                          </div></td>
                        <td width="56%"><div align="center">
                            <% botonera.DibujaBoton ("lanzadera")%>
                          </div></td>
                        <td width="12%"><div align="center"></div></td>
                      </tr>
                    </table>
                  </div></td>
                <td width="80%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
              </tr>
              <tr> 
                <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
              </tr>
            </table></td>
          <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
        </tr>
      </table>
     <BR></td>
  </tr>  
</table>
</body>
</html>
