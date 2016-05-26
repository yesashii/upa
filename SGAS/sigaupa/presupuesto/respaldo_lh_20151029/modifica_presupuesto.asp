<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 2000 
set pagina = new CPagina
pagina.Titulo = "Modificación de Solicitud Presupuestaria"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set conexion2 = new CConexion2
conexion2.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
v_usuario = negocio.ObtenerUsuario()
'response.Write("Usuario: "&Usuario)



'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "modifica_ejecucion_presupuestaria.xml", "botonera"
'-----------------------------------------------------------------------
 
 codcaja	= request.querystring("busqueda[0][codcaja]")
 area_ccod	= request.querystring("busqueda[0][area_ccod]")


 
 if codcaja="" then
	 codcaja= request.querystring("codcaja")
 end if

 if area_ccod="" then
	 area_ccod= request.querystring("area_ccod")
 end if

 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "ejecucion_presupuestaria_2011_adm.xml", "busqueda_presupuesto"
 f_busqueda.Inicializar conexion2
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
 
 f_busqueda.AgregaCampoCons "codcaja", codcaja
 f_busqueda.AgregaCampoParam "area_ccod", "filtro",  "area_ccod in ( select area_ccod from  presupuesto_upa.protic.area_presupuesto_usuario  where rut_usuario in ('"&v_usuario&"') )"
 f_busqueda.AgregaCampoCons "area_ccod", area_ccod

 f_busqueda.AgregaCampoParam "codcaja", "destino",  " (select distinct cod_pre from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2011 where cod_area in ('"&area_ccod&"')) a "
 'f_busqueda.AgregaCampoParam "cod_pre", "filtro",  "cod_pre in ( select distinct cod_pre from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual where cod_area in ('"&area_ccod&"') )"
 f_busqueda.AgregaCampoCons "codcaja", codcaja

'----------------------------------------------------------------------------


 if Request.QueryString <> "" then
	  

			set f_presupuestado = new CFormulario
			f_presupuestado.Carga_Parametros "modifica_ejecucion_presupuestaria.xml", "f_modifica"
			f_presupuestado.Inicializar conexion2
			
			if codcaja <> "" then
			 
				sql_presupuestado	=" SELECT concepto, detalle,descripcion_area, cod_pre,isnull(total,0) as total, "& vbCrLf &_
									" isnull(enero,0) as enero, isnull(febrero,0) as febrero, isnull(marzo,0) as marzo, isnull(abril,0) as abril, "& vbCrLf &_
									" isnull(mayo,0) as mayo, isnull(junio,0) as junio, isnull(julio,0) as julio, isnull(agosto,0) as agosto, "& vbCrLf &_
									" isnull(septiembre,0) as septiembre,isnull(octubre,0) as octubre, isnull(noviembre,0) as noviembre,  "& vbCrLf &_
									" isnull(diciembre,0) as diciembre, isnull(enero_prox,0) as enero_prox,isnull(febrero_prox,0) as febrero_prox "& vbCrLf &_
									"	FROM presupuesto_upa.protic.presupuesto_upa_2011_adm "& vbCrLf &_
									"	where ltrim(rtrim(cod_pre)) like '"&codcaja&"'  "
			else
				sql_presupuestado	=" SELECT top 1 concepto, detalle, descripcion_area, cod_pre,isnull(total,0) as total, "& vbCrLf &_
									" isnull(enero,0) as enero, isnull(febrero,0) as febrero, isnull(marzo,0) as marzo, isnull(abril,0) as abril, "& vbCrLf &_
									" isnull(mayo,0) as mayo, isnull(junio,0) as junio, isnull(julio,0) as julio, isnull(agosto,0) as agosto, "& vbCrLf &_
									" isnull(septiembre,0) as septiembre,isnull(octubre,0) as octubre, isnull(noviembre,0) as noviembre,  "& vbCrLf &_
									" isnull(diciembre,0) as diciembre, isnull(enero_prox,0) as enero_prox,isnull(febrero_prox,0) as febrero_prox "& vbCrLf &_
									"	FROM presupuesto_upa.protic.presupuesto_upa_2011_adm "& vbCrLf &_
									"	where cod_pre in (select distinct cod_pre from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2011 where cod_area="&area_ccod&")  "
			end if
			
			'response.Write("<pre>"&codcaja& "codcaja" &"</pre>")
			'response.Write("<pre>"&sql_presupuestado&"</pre>")
			'response.End()
			f_presupuestado.consultar sql_presupuestado
			
			
	sql_area_presu	= " select top 1 area_tdesc from presupuesto_upa.protic.area_presupuesto_usuario a, presupuesto_upa.protic.area_presupuestal b " & vbCrLf &_
					" where a.area_ccod=b.area_ccod " & vbCrLf &_
					" and rut_usuario="&v_usuario&"  and a.area_ccod="&area_ccod&"  "
	
	area_presupuesto = 	conexion2.consultaUno(sql_area_presu)

	
v_mes_actual= conexion2.consultaUno("select month(getdate())")	

'v_mes_actual =5

i_ = 0
	while f_presupuestado.Siguiente
	
		if 1 < v_mes_actual then
			f_presupuestado.AgregaCampoFilaParam i_, "enero", "permiso", "LECTURA"
		end if
		
		if 2 < v_mes_actual then
			f_presupuestado.AgregaCampoFilaParam i_, "febrero", "permiso", "LECTURA"
		end if
		
		if 3 < v_mes_actual then
			f_presupuestado.AgregaCampoFilaParam i_, "marzo", "permiso", "LECTURA"
		end if
		
		if 4 < v_mes_actual then
			f_presupuestado.AgregaCampoFilaParam i_, "abril", "permiso", "LECTURA"
		end if
		
		if 5 < v_mes_actual then
			f_presupuestado.AgregaCampoFilaParam i_, "mayo", "permiso", "LECTURA"
		end if
		
		if 6 < v_mes_actual then
			f_presupuestado.AgregaCampoFilaParam i_, "junio", "permiso", "LECTURA"
		end if
		
		if 7 < v_mes_actual then
			f_presupuestado.AgregaCampoFilaParam i_, "julio", "permiso", "LECTURA"
		end if
		
		if 8 < v_mes_actual then
			f_presupuestado.AgregaCampoFilaParam i_, "agosto", "permiso", "LECTURA"
		end if
		
		if 9 < v_mes_actual then
			f_presupuestado.AgregaCampoFilaParam i_, "septiembre", "permiso", "LECTURA"
		end if
		
		if 10 < v_mes_actual then
			f_presupuestado.AgregaCampoFilaParam i_, "octubre", "permiso", "LECTURA"
		end if
		
		if 11 < v_mes_actual then
			f_presupuestado.AgregaCampoFilaParam i_, "noviembre", "permiso", "LECTURA"
		end if
			
		i_ = i_ + 1
	wend

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
function Validar(){
	return true;
}

function CargarCodigo(formulario, espe_ccod)
{
	if (espe_ccod != '') {
	_Buscar(this, document.forms['busca_codigo'],'', 'Validar();', 'FALSE');
	}
}


function isDigit(ch) {
   if (ch >= '0' && ch <= '9')
      return true;
   return false;
}

function EsNumerico(obj) {
   value = obj.value;
   if(!value){
   	obj.value=0;
   }
   cont=0;
   for (n = 0; n < value.length; n++){
	  if ( ! isDigit(value.charAt(n))) {
		 alert("Debe ingresar un valor numerico");
		 obj.value=0;
		 obj.focus();
		 return false;
	  }
	}
}

function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if%>
}

function total_presupuesto()
	{
	
		
			
			
	<% if area_ccod <> "" then	%> 		
	
	filas=<%=f_presupuestado.nrofilas%>
			total=0
			for(i=0;i<filas;i++)
			{
			
							if (document.presupuesto.elements['pre['+i+'][enero]'])
				{
					enero=document.presupuesto.elements['pre['+i+'][enero]'].value*1
				}
				else
				{
					enero=0									
				}
				
				if (document.presupuesto.elements['pre['+i+'][febrero]'])
				{
					febrero=document.presupuesto.elements['pre['+i+'][febrero]'].value*1
				}
				else
				{
					febrero=0			 				
				}
				
				if (document.presupuesto.elements['pre['+i+'][marzo]'])
				{
					marzo=document.presupuesto.elements['pre['+i+'][marzo]'].value*1
				}
				else
				{
					marzo=0									
				}
					if (document.presupuesto.elements['pre['+i+'][abril]'])
				{
					abril=document.presupuesto.elements['pre['+i+'][abril]'].value*1
				}
				else
				{
					abril=0								
				}
				
					if (document.presupuesto.elements['pre['+i+'][mayo]'])
				{
					mayo=document.presupuesto.elements['pre['+i+'][mayo]'].value*1
				}
				else
				{
					mayo=0									
				}
				
					if (document.presupuesto.elements['pre['+i+'][junio]'])
				{
					junio=document.presupuesto.elements['pre['+i+'][junio]'].value*1
				}
				else
				{
					junio=0									
				}
				
					if (document.presupuesto.elements['pre['+i+'][julio]'])
				{
					julio=document.presupuesto.elements['pre['+i+'][julio]'].value*1
				}
				else
				{
					julio=0					
				}
				
				
					if (document.presupuesto.elements['pre['+i+'][agosto]'])
				{
					agosto=document.presupuesto.elements['pre['+i+'][agosto]'].value*1
				}
				else
				{
					agosto=0									
				}
				
					if (document.presupuesto.elements['pre['+i+'][septiembre]'])
				{
					septiembre=document.presupuesto.elements['pre['+i+'][septiembre]'].value*1
				}
				else
				{
					septiembre=0									
				}
				
					if (document.presupuesto.elements['pre['+i+'][octubre]'])
				{
					octubre=document.presupuesto.elements['pre['+i+'][octubre]'].value*1
				}
				else
				{
					octubre=0									
				}
				
					if (document.presupuesto.elements['pre['+i+'][noviembre]'])
				{
					noviembre=document.presupuesto.elements['pre['+i+'][noviembre]'].value*1
				}
				else
				{
					noviembre=0									
				}
				
					if (document.presupuesto.elements['pre['+i+'][diciembre]'])
				{
					diciembre=document.presupuesto.elements['pre['+i+'][diciembre]'].value*1
				}
				else
				{
					diciembre=0									
				}
				
					total=total+enero+febrero+marzo+abril+mayo+junio+julio+agosto+septiembre+octubre+noviembre+diciembre	
			}
	
	
		
		document.presupuesto.elements['pre[0][total]'].value=total
	
	<%end if%>
	}






</script>


<style type="text/css">
	.nobord { border-style: solid; border-width: 0; padding: 0; background-color:#EDEDEF }
	.meses:link, .meses:visited { 	text-decoration: underline;color:#0033FF; }
	.meses:hover {	text-decoration: none; }
	
</style>
</head>


<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje(); total_presupuesto();" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
              <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8" background="../imagenes/top_r1_c2.gif"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="192" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador
                      de Documentos</font></div></td>
                    <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                  </tr>
              </table></td>
              <td align="left"><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>              
            </tr>
            <tr>
              <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td background="../imagenes/top_r3_c2.gif"><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"><div align="center">
			<BR>
				<form name="buscador">                
                      <table width="100%" border="0" align="left">
                        <tr>
                          <td width="35"></td>
						  <td width="190"><div align="left"><strong>Area Presupuesto</strong>  </div></td>
						  <td width="482"><% f_busqueda.DibujaCampo ("area_ccod") %></td>  
                          <td width="183"><div align="center"><%botonera.DibujaBoton "buscar" %></div></td>
                        </tr>
                      </table>
				</form>
                </div></td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE" background="../imagenes/base2.gif"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>			
          </td>
      </tr>
    </table>	
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
              <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td ><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td background="../imagenes/top_r1_c2.gif"><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                  
                    <td width="17"><%lenguetas=Array(Array("Reprogramacion Presupuesto","modifica_presupuesto.asp"),Array("Reasignar Presupuesto","reasigna_presupuesto.asp"))
						pagina.DibujarLenguetas lenguetas, 1 %></td>
                    
                    <td width="1018" bgcolor="#D8D8DE">&nbsp;</td>
                  </tr>
                </table>
              </td>
              <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td background="../imagenes/top_r3_c2.gif"><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
            </tr>

              <tr>
                <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"> <div align="center"><BR>
                    <%pagina.DibujarTituloPagina%>
                  </div>
			<% if area_ccod <> "" then	%>  
				  <table width="632"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#EDEDEF">
                    <tr> 
                      <td width="9" height="8"><img src="../imagenes/marco_claro/1.gif" width="9" height="8"></td>
                      <td height="8" background="../imagenes/marco_claro/2.gif"></td>
                      <td width="7" height="8"><img src="../imagenes/marco_claro/3.gif" width="7" height="8"></td>
                    </tr>
                    <tr> 
                      <td width="9" background="../imagenes/marco_claro/9.gif">&nbsp;</td>
                      <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td> 
                            </td>
                          </tr>
                          <tr> 
                            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
                          </tr>
                          <tr> 
                            <td> 
								<br/>
							<font color="#0000CC" size="2">Area Presupuesto: <b><%=area_presupuesto%></b></font>
								<br/>
								<form name="busca_codigo" method="get">
								<input type="hidden" name="busqueda[0][area_ccod]" value="<%=area_ccod%>"/>
								<table>
									<tr>                          
										<td width="155"><div align="left"><strong>Código presupuestario</strong></div></td>
										<td width="8">:</td>
										<td width="53"><% f_busqueda.DibujaCampo("codcaja") %></td>
									</tr>
								</table>
								</form>

								<form name="presupuesto" method="post">
									<input type="hidden" name="codcaja" value="<%=codcaja%>">
									<input type="hidden" name="area_ccod" value="<%=area_ccod%>">
                                   <table>
								  <tr>
                                  <td><div align="left"><strong>Total presupuesto disponible</strong></div><td>
                                  <td width="8">:</td>
                                  <td width="53"><input type="text" name="pre[0][total]" readonly="true" class="nobord" /> </td>
                                 
                                  
                                  
                                  </tr>
                                  </table>				
									<table width="100%" border="1" align="center" >
										<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
										  <th width="25%">CONCEPTO</th>
										  <th width="25%">DETALLE</th>
										  <th width="25%">CODIGO</th>
										  <th width="25%">ENERO</th>
										  <th width="25%">FEBRERO</th>
										  <th width="25%">MARZO</th>
										  <th width="25%">ABRIL</th>
										  <th width="25%">MAYO</th>
										  <th width="25%">JUNIO</th>
										  <th width="25%">JULIO</th>
										  <th width="25%">AGOSTO</th>
										  <th width="25%">SEPTIEMBRE</th>
										  <th width="25%">OCTUBRE</th>
										  <th width="25%">NOVIEMBRE</th>
										  <th width="25%">DICIEMBRE</th>
										</tr>
                                        
									<%
									'response.Write(f_presupuestado.NroFilas)
									ind=0
									'response.Write(f_presupuestado.nrofilas)
									f_presupuestado.Primero
									while f_presupuestado.Siguiente
										v_total		=	v_total		+	Clng(f_presupuestado.ObtenerValor("total"))
										v_enero		=	v_enero		+	Clng(f_presupuestado.ObtenerValor("enero"))
										v_febrero	=	v_febrero	+	Clng(f_presupuestado.ObtenerValor("febrero"))
										v_marzo		=	v_marzo		+	Clng(f_presupuestado.ObtenerValor("marzo"))
										v_abril		=	v_abril		+	Clng(f_presupuestado.ObtenerValor("abril"))
										v_mayo		=	v_mayo		+	Clng(f_presupuestado.ObtenerValor("mayo"))
										v_junio		=	v_junio		+	Clng(f_presupuestado.ObtenerValor("junio"))
										v_julio		=	v_julio		+	Clng(f_presupuestado.ObtenerValor("julio"))
										v_agosto	=	v_agosto	+	Clng(f_presupuestado.ObtenerValor("agosto"))
										v_septiembre=	v_septiembre	+	Clng(f_presupuestado.ObtenerValor("septiembre"))
										v_octubre	=	v_octubre		+	Clng(f_presupuestado.ObtenerValor("octubre"))
										v_noviembre	=	v_noviembre		+	Clng(f_presupuestado.ObtenerValor("noviembre"))
										v_diciembre	=	v_diciembre		+	Clng(f_presupuestado.ObtenerValor("diciembre"))
										v_enero_prox	=v_enero_prox	+	Clng(f_presupuestado.ObtenerValor("enero_prox"))
										v_febrero_prox	=v_febrero_prox	+	Clng(f_presupuestado.ObtenerValor("febrero_prox"))
									
									%>
									<tr bordercolor='#999999'>
									<input type="hidden" value="<%=f_presupuestado.ObtenerValor("concepto")%>" name="pre[<%=ind%>][concepto]">
									<input type="hidden" value="<%=f_presupuestado.ObtenerValor("detalle")%>" name="pre[<%=ind%>][detalle]">
									<input type="hidden" value="<%=f_presupuestado.ObtenerValor("cod_pre")%>" name="pre[<%=ind%>][cod_pre]">
									<input type="hidden" value="<%=f_presupuestado.ObtenerValor("descripcion_area")%>" name="pre[<%=ind%>][descripcion_area]">
										<td><%=f_presupuestado.ObtenerValor("concepto")%></td>
										<td><%=f_presupuestado.ObtenerValor("detalle")%></td>
										<td><%=f_presupuestado.ObtenerValor("cod_pre")%></td>
										<td><%=f_presupuestado.DibujaCampo("enero")%></td>
										<td><%=f_presupuestado.DibujaCampo("febrero")%></td>
										<td><%=f_presupuestado.DibujaCampo("marzo")%></td>
										<td><%=f_presupuestado.DibujaCampo("abril")%></td>
										<td><%=f_presupuestado.DibujaCampo("mayo")%></td>
										<td><%=f_presupuestado.DibujaCampo("junio")%></td>
										<td><%=f_presupuestado.DibujaCampo("julio")%></td>
										<td><%=f_presupuestado.DibujaCampo("agosto")%></td>
										<td><%=f_presupuestado.DibujaCampo("septiembre")%></td>
										<td><%=f_presupuestado.DibujaCampo("octubre")%></td>
										<td><%=f_presupuestado.DibujaCampo("noviembre")%></td>
										<td><%=f_presupuestado.DibujaCampo("diciembre")%></td>
										
									</tr>
                                   								 <%
									 ind=ind+1
									 wend%>
									<tr bordercolor='#999999'>
								 	<td colspan="3"><b>Totales</b></td>
									<td align="right"><b><%=formatcurrency(v_enero,0)%></b></td>
									<td align="right"><b><%=formatcurrency(v_febrero,0)%></b></td>
									<td align="right"><b><%=formatcurrency(v_marzo,0)%></b></td>
									<td align="right"><b><%=formatcurrency(v_abril,0)%></b></td>
									<td align="right"><b><%=formatcurrency(v_mayo,0)%></b></td>
									<td align="right"><b><%=formatcurrency(v_junio,0)%></b></td>
									<td align="right"><b><%=formatcurrency(v_julio,0)%></b></td>
									<td align="right"><b><%=formatcurrency(v_agosto,0)%></b></td>
									<td align="right"><b><%=formatcurrency(v_septiembre,0)%></b></td>
									<td align="right"><b><%=formatcurrency(v_octubre,0)%></b></td>
									<td align="right"><b><%=formatcurrency(v_noviembre,0)%></b></td>
									<td align="right"><b><%=formatcurrency(v_diciembre,0)%></b></td>
									
								 </tr>	
                                    <tr>
                                    <td></td>
                                    </tr>								 
								  </table>
							<br/>	  
								  </form>	
						
						</td>
                          </tr>
                        </table></td>
                      		<td width="7" background="../imagenes/marco_claro/10.gif">&nbsp;</td>
                    	</tr>
					  	<tr>
							<td align="left" valign="top"><img src="../imagenes/marco_claro/17.gif" width="9" height="28"></td>
							<td valign="top">
							<!-- desde aca -->
							<table  width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
                          		<tr > 
                            		<td width="47%" height="20"><div align="center"> 
                                		<table width="94%"  border="0" cellspacing="0" cellpadding="0">
										  	<tr> 
												<td width="100%">
													<%botonera.DibujaBoton ("guardar_adm")%>
												</td>
										  	</tr>
                                		</table>
                              </div></td>
								<td width="53%" rowspan="2" background="../imagenes/marco_claro/15.gif"><img src="../imagenes/marco_claro/14.gif" width="12" height="28"></td>
                          	</tr>
							   <tr> 
                            		<td height="8" background="../imagenes/marco_claro/13.gif"></td>
                          		</tr>
							</table>
							</td>
							<td align="right" valign="top" height="13"><img src="../imagenes/marco_claro/16.gif" width="7"height="28"></td>
					  	</tr>
                  </table>
				  <% end if %>
                    <br/>
					<br/>
                </td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
            </table>
			
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                <td width="20%" bgcolor="#D8D8DE"><table width="100%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td ><% botonera.DibujaBoton ("lanzadera") %> </td>
                    </tr>
                  </table>
                </td>
                <td width="80%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                <td width="7" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
              </tr>
              <tr>
                <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
              </tr>
            </table>
			
        </td>
      </tr>
    </table>
	<p>&nbsp;</p></td>
  </tr>  
</table>
</body>
</html>