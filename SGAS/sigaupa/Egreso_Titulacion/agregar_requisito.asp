<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
repl_ncorr=request.QueryString("repl_ncorr")
plan_ccod = request.QueryString("plan_ccod")
sede_ccod = request.QueryString("sede_ccod")
peri_ccod = request.QueryString("peri_ccod")

set pagina = new CPagina
pagina.Titulo = "Requisitos de Titulación"

set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores			= new cErrores

set botonera = new CFormulario
botonera.Carga_Parametros "mant_requisito.xml", "botonera"

'set freq = new cFormulario
'freg.carga_parametros "mant_requisito.xml",""
'freq.inicializar conexion

'freq.consultar "select * from where "


sqlsumpon= " SELECT sum(repl_nponderacion) " & _
		   " FROM REQUISITOS_PLAN A " & _
		   " WHERE a.sede_ccod= '"&sede_ccod&"' " & _
		   " and a.plan_ccod='"&plan_ccod&"'" & _
		   " and a.peri_ccod='"&peri_ccod&"'" 
sumapon=conexion.consultauno(sqlsumpon)

consulta = "select * from tipos_requisitos_titulo "

'response.Write(consulta)		   
set f_datos_requisitos = new cFormulario
f_datos_requisitos.Inicializar conexion
f_datos_requisitos.Carga_Parametros "mant_requisito.xml", "f_agregar_req"
f_datos_requisitos.Consultar consulta
f_datos_requisitos.siguiente

SqlTER = " select a.treq_ccod,a.teva_ccod,b.teva_tdesc " & _
		" from tipos_requisitos_titulo a, tipos_evaluacion_requisitos b " &_
		" where a.teva_ccod=b.teva_ccod " & _
		" order by treq_ccod "
		 
conexion.Ejecuta SqlTER
set rec_tipos_eval = conexion.ObtenerRS

%>
<html>
<head>
<title>Mantenedor de Funciones</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function Validar(){
	return true
}

rec_tipos_eval = new Array();

<%
if (rec_tipos_eval.BOF <> rec_tipos_eval.EOF) then

rec_tipos_eval.MoveFirst
i = 0
while not rec_tipos_eval.Eof
%>
rec_tipos_eval[<%=i%>] = new Array();
rec_tipos_eval[<%=i%>]["treq_ccod"] = '<%=rec_tipos_eval("treq_ccod")%>';
rec_tipos_eval[<%=i%>]["teva_ccod"] = '<%=rec_tipos_eval("teva_ccod")%>';
rec_tipos_eval[<%=i%>]["teva_tdesc"] = '<%=rec_tipos_eval("teva_tdesc")%>';
<%	
	rec_tipos_eval.MoveNext
	i = i + 1
wend
end if
%>
function sumaponderacion(formulario){
suma='<%=sumapon%>'
ponderacion=parseInt(suma)+parseInt(formulario.elements["m[0][repl_nponderacion]"].value)

if (parseInt(ponderacion)>100){
	return false;
}
else {return true}
}

function CargaTipoEval(formulario){
//alert(formulario.elements["m[0][treq_ccod]"].value)
	for (i = 0; i < rec_tipos_eval.length; i++) {
  			if(formulario.elements["m[0][treq_ccod]"].value==rec_tipos_eval[i]["treq_ccod"]){
				formulario.elements["m[0][TEVA_TDESC]"].value=rec_tipos_eval[i]["teva_tdesc"]
				formulario.teva_ccod.value=rec_tipos_eval[i]["teva_ccod"]
				if (formulario.teva_ccod.value==2 ){
					formulario.elements["m[0][repl_nponderacion]"].value=""
					formulario.elements["m[0][repl_nponderacion]"].setAttribute("disabled",true)
				}
				else {
						formulario.elements["m[0][repl_nponderacion]"].setAttribute("disabled",false)
						formulario.elements["m[0][repl_nponderacion]"].value=0
				}
			}
	}

}
function iniciopagina(formulario){
	t_req='<%=TREQ_CCOD%>'

	if (t_req==1){
		formulario.elements["m[0][treq_ccod]"].setAttribute("disabled",true)	
	}	

for (i = 0; i < rec_tipos_eval.length; i++) {
  			if(formulario.elements["m[0][treq_ccod]"].value==rec_tipos_eval[i]["treq_ccod"]){
				formulario.elements["m[0][TEVA_TDESC]"].value=rec_tipos_eval[i]["teva_tdesc"]
				formulario.teva_ccod.value=rec_tipos_eval[i]["teva_ccod"]
				if (formulario.teva_ccod.value==2 ){
					formulario.elements["m[0][repl_nponderacion]"].value=""
					formulario.elements["m[0][repl_nponderacion]"].setAttribute("disabled",true)
				}
				else {
						formulario.elements["m[0][repl_nponderacion]"].setAttribute("disabled",false)
						//formulario.elements["m[0][repl_nponderacion]"].value=0
				}
			}
	}
	
}

function enviar(formulario){
	 if (formulario.teva_ccod.value==1){
		 if(preValidaFormulario(formulario)){
				if(sumaponderacion(formulario)){
					if (formulario.elements["m[0][repl_nponderacion]"].value>0 && formulario.elements["m[0][repl_nponderacion]"].value<=100){
				  		formulario.action = 'proc_agregar_requisito.asp'
				  		formulario.submit();
						self.opener.location.reload();
						self.close();
					}
					else { alert("La ponderacion Debe Ser Mayor a 0 y menor o igual a 100")
					}	
				}
				else{
					alert("La Suma De Las Ponderaciones Supera El 100%")
				}		
		}
	}
	else{
		formulario.action = 'proc_agregar_requisito.asp'
		formulario.submit();
		self.opener.location.reload();
		self.close();
	}
		
}
</script>

</head>
<body  onBlur="revisaVentana()" bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="iniciopagina(document.buscador);MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="552" height="268" border="0" align="center" cellpadding="0" cellspacing="0">
  <%'pagina.DibujarEncabezado()%>  
  <tr>
    <td height="268" valign="top" bgcolor="#EAEAEA">
	<BR>
	<BR>			
	
	<table width="400" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="400" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="400" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="9" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="205" valign="middle" background="../imagenes/fondo1.gif">
					  <font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">
					  Mantenedor de Requisitos
	  </font>
	  <div align="left"></div></td>
                      <td width="186" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="400" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				    &nbsp;
				    <form name="buscador">			    
					<table width="100%" border="0">
					  <tr>
					    <td nowrap>Tipo de Requisito</td>
					    <td nowrap>:</td>
					    <td nowrap><%f_datos_requisitos.dibujacampo("treq_ccod")%>
					    </td>
				      </tr>
					  <tr>
					    <td nowrap>Tipo de Evaluaci&oacute;n</td>
					    <td nowrap>:</td>
					    <td nowrap><%f_datos_requisitos.dibujacampo("TEVA_TDESC")%>
					    </td>
				      </tr>
					  <tr>
					    <td width="28%" nowrap>Ponderaci&oacute;n</td>
					    <td width="2%" nowrap>:</td>
					    <td width="70%" nowrap><%f_datos_requisitos.dibujacampo("repl_nponderacion")%> 
					      (%)</td>
				      </tr>
					  </table>					
				    <div align="right">Suma Total de ponderaciones:
                      <%response.Write(sumapon)%>                  
                      <br>				  
                    </div>
					<input name="TREQ_CCOD" type="hidden" value="<%=treq_ccod%>">
					<input name="teva_ccod" type="hidden" >
					<input name="sede_ccod" type="hidden" value="<%=sede_ccod%>">
					<input name="plan_ccod" type="hidden" value="<%=plan_ccod%>">
					<input name="peri_ccod" type="hidden" value="<%=peri_ccod%>">
					</form>
			</td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="225" bgcolor="#D8D8DE"> <div align="left"></div> 
		            <div align="left">                       <table width="100%" border="0" cellpadding="0" cellspacing="0">
                         <tr>
                           <td><% 'pagina.DibujarBoton "Aceptar", "GUARDAR-edicion", "Proc_Mant_Funciones_Edicion.asp"
						   botonera.dibujaboton "guardar"%>
</td>
                           <td><% 'pagina.DibujarBoton "Cancelar", "CERRAR", ""
						   botonera.dibujaboton "cancelar"%>
                           </td>
                         </tr>
                       </table>
</div></td>
                  <td width="37" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="145" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>