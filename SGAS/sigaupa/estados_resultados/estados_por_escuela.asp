<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../estados_resultados/funciones_escuelas.asp" -->
<%
Server.ScriptTimeout = 2000 
set pagina = new CPagina
pagina.Titulo = "Estado de resultado - Escuelas"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
v_usuario = negocio.ObtenerUsuario()
'response.Write("Usuario: "&Usuario)

facultad	= request.querystring("busqueda[0][facultad]")


'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "estados_resultados.xml", "botonera"
'-----------------------------------------------------------------------

sql_permisos=	"select count(cod_facultad) from eru_permisos_facultad_upa where pers_nrut="&v_usuario
v_existe	=	conexion.consultaUno(sql_permisos)

 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "estados_resultados.xml", "busqueda"
 f_busqueda.Inicializar conexion
 
 	if v_existe>0 then
 		f_busqueda.AgregaCampoParam "facultad", "filtro",  "cod_facultad in ( select cod_facultad from  eru_permisos_facultad_upa where pers_nrut in ('"&v_usuario&"') )"
	end if
 
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 


'----------------------------------------------------------------------------
if Request.QueryString <> "" then

' si ha seleccionado todos, y no tiene permisos limitados
if (facultad="" or EsVacio(facultad)) and v_existe=0 then
	facultad=1
else
' si ha seleccionado todo, pero tiene permisos limitados solo se muestra la primera facultad encontrada
	 if (facultad="" or EsVacio(facultad)) and v_existe>0 then
		sql_permisos=	"select top 1 cod_facultad from eru_permisos_facultad_upa where pers_nrut="&v_usuario
		facultad	=	Cint(conexion.consultaUno(sql_permisos))
	 end if
end if

 f_busqueda.AgregaCampoCons "facultad", facultad	
 
select case facultad
	case 1  'FACULTAD DE COMUNICACIONES
		' N° Escuelas : 9
		str_select=" E4 as f1, E6 as f2, E14 as f3, E21 as f4, E25 as f5, E28 as f6, E29 as f7, E35 as f8, E33 as f9 "
	case 2 'FACULTAD DE DISEÑO
		' N° Escuelas : 3
		str_select="E7 as f1, E8 as f2, E9 as f3"
	case 3 'FACULTAD DE NEGOCIOS Y MARKETING
		' N° Escuelas : 7
		str_select="E5 as f1, E16 as f2, E17 as f3, E18 as f4, E19 as f5, E26 as f6, E34 as f7"
	case 4 'FACULTAD DE CIENCIAS HUMANAS Y EDUCACION
		' N° Escuelas : 8
		str_select="E10 as f1, E12 as f2, E15 as f3, E27 as f4, E30 as f5, E11 as f6, E24 as f7, E23 as f8"
	case 5 'AREA CIENCIAS AGROPECUARIAS 
		' N° Escuelas : 2
		str_select=" E3 as f1, E31 as f2"
	case 6 'AREA CIENCIAS Y SALUD
		' N° Escuelas : 2
		str_select="E13 as f1, E22 as f2"
	case  else ' Otras Areas
		' N° Escuelas : 5
		str_select="E1 as f1, E2 as f2, E20 as f3, E32 as f4, E36 as f5"
end select	

set f_ingreso = new CFormulario
f_ingreso.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
f_ingreso.Inicializar conexion


  		sql_ingreso=ObtenerConsultaIngreso(facultad,str_select,1)
		'response.Write("<pre>"&sql_ingreso&"</pre>")
		f_ingreso.consultar sql_ingreso
			

'************************************************************************
	set f_costo_operacional = new CFormulario
	f_costo_operacional.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
	f_costo_operacional.Inicializar conexion


			sql_costo_operacional=ObtenerConsultaIngreso(facultad,str_select,2)
			f_costo_operacional.consultar sql_costo_operacional



'************************************************************************
	set f_gasto_administracion = new CFormulario
	f_gasto_administracion.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
	f_gasto_administracion.Inicializar conexion

			sql_gasto_administracion	=  ObtenerConsultaIngreso(facultad,str_select,3)
			
			'response.Write("<pre>"&sql_sedes&"</pre>")
			f_gasto_administracion.consultar sql_gasto_administracion


'************************************************************************
	set f_gasto_indirecto = new CFormulario
	f_gasto_indirecto.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
	f_gasto_indirecto.Inicializar conexion


			sql_gasto_indirecto=ObtenerConsultaIngreso(facultad,str_select,4)
			'response.Write("<pre>"&sql_gasto_indirecto&"</pre>")
			f_gasto_indirecto.consultar sql_gasto_indirecto


'-----------------------------------------------------------------------------
'*************************** TOTALIZADORES DE  SEDES *************************

			set f_totales = new CFormulario
			f_totales.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			f_totales.Inicializar conexion
			
			sql_totales=ObtenerConsultaTotal(facultad,str_select)

'response.Write("<pre>"&sql_totales&"</pre>")
						
			f_totales.consultar sql_totales
			
			while f_totales.Siguiente
			
			select case facultad
					case 1  'FACULTAD DE COMUNICACIONES
								v_total_f1	=CDBL(f_totales.obtenerValor("f1"))*-1
								v_total_f2	=CDBL(f_totales.obtenerValor("f2"))*-1
								v_total_f3	=CDBL(f_totales.obtenerValor("f3"))*-1
								v_total_f4	=CDBL(f_totales.obtenerValor("f4"))*-1
								v_total_f5	=CDBL(f_totales.obtenerValor("f5"))*-1
								v_total_f6	=CDBL(f_totales.obtenerValor("f6"))*-1
								v_total_f7	=CDBL(f_totales.obtenerValor("f7"))*-1
								v_total_f8	=CDBL(f_totales.obtenerValor("f8"))*-1
								v_total_f9	=CDBL(f_totales.obtenerValor("f9"))*-1	
				
					case 2 'FACULTAD DE DISEÑO
								v_total_f1	=CDBL(f_totales.obtenerValor("f1"))*-1
								v_total_f2	=CDBL(f_totales.obtenerValor("f2"))*-1
								v_total_f3	=CDBL(f_totales.obtenerValor("f3"))*-1
				
				
					case 3 'FACULTAD DE NEGOCIOS Y MARKETING
								v_total_f1	=CDBL(f_totales.obtenerValor("f1"))*-1
								v_total_f2	=CDBL(f_totales.obtenerValor("f2"))*-1
								v_total_f3	=CDBL(f_totales.obtenerValor("f3"))*-1
								v_total_f4	=CDBL(f_totales.obtenerValor("f4"))*-1
								v_total_f5	=CDBL(f_totales.obtenerValor("f5"))*-1
								v_total_f6	=CDBL(f_totales.obtenerValor("f6"))*-1
								v_total_f7	=CDBL(f_totales.obtenerValor("f7"))*-1
				
					case 4 'FACULTAD DE CIENCIAS HUMANAS Y EDUCACION
								v_total_f1	=CDBL(f_totales.obtenerValor("f1"))*-1
								v_total_f2	=CDBL(f_totales.obtenerValor("f2"))*-1
								v_total_f3	=CDBL(f_totales.obtenerValor("f3"))*-1
								v_total_f4	=CDBL(f_totales.obtenerValor("f4"))*-1
								v_total_f5	=CDBL(f_totales.obtenerValor("f5"))*-1
								v_total_f6	=CDBL(f_totales.obtenerValor("f6"))*-1
								v_total_f7	=CDBL(f_totales.obtenerValor("f7"))*-1
								v_total_f8	=CDBL(f_totales.obtenerValor("f8"))*-1
				
					case 5 'AREA CIENCIAS AGROPECUARIAS 
								v_total_f1	=CDBL(f_totales.obtenerValor("f1"))*-1
								v_total_f2	=CDBL(f_totales.obtenerValor("f2"))*-1
				
					case 6 'AREA CIENCIAS Y SALUD
								v_total_f1	=CDBL(f_totales.obtenerValor("f1"))*-1
								v_total_f2	=CDBL(f_totales.obtenerValor("f2"))*-1
				
					case  else ' Otras Areas
								v_total_f1	=CDBL(f_totales.obtenerValor("f1"))*-1
								v_total_f2	=CDBL(f_totales.obtenerValor("f2"))*-1
								v_total_f3	=CDBL(f_totales.obtenerValor("f3"))*-1
								v_total_f4	=CDBL(f_totales.obtenerValor("f4"))*-1
								v_total_f5	=CDBL(f_totales.obtenerValor("f5"))*-1
					end select	

			wend

'-----------------------------------------------------------------------------

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
function imprimir()
{
  window.print();  
}

function Validar(){
	return true;
}

function CargarCodigo(formulario, espe_ccod)
{

	_Buscar(this, document.forms['busca_codigo'],'', 'Validar();', 'FALSE');
}

function ver_detalle(var1,var2,var3){
	formulario=document.forms['busca_codigo'];
	formulario.elements["busqueda[0][mes_venc]"].value=var3
	_Buscar(this, document.forms['busca_codigo'],'', 'Validar();', 'FALSE');

}

</script>
<style type="text/css">

@media print{ .noprint {visibility:hidden; }}
	
</style>
</head>


<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
        <td  class="noprint"><table border="0" cellpadding="0" cellspacing="0" width="100%">
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
                       </font></div></td>
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
						  <td width="190"><div align="left"><strong>Facultades</strong>  </div></td>
						  <td width="482"><% f_busqueda.DibujaCampo ("facultad") %></td>  
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
	<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
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
                    <td width="20" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="288" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Estado de Resultado - Escuelas </font></div>
                    </td>
                    <td width="743" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
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
				  <br/>
				  <div align="center"><font color="#0033CC" size="2">VALORES ACUMULADOS AL MES DE JUNIO 2013</font></div>
				  <br/>
				  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#EDEDEF">
                    <tr> 
                      <td width="9" height="8"><img src="../imagenes/marco_claro/1.gif" width="9" height="8"></td>
                      <td height="8" background="../imagenes/marco_claro/2.gif"></td>
                      <td width="7" height="8"><img src="../imagenes/marco_claro/3.gif" width="7" height="8"></td>
                    </tr>
                    <tr> 
                      <td width="9" background="../imagenes/marco_claro/9.gif">&nbsp;</td>
                      <td>
					  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td height="2" background=""></td>
                          </tr>
                          <tr> 
                            <td> 
								<br/>
					<%if Request.QueryString <> "" then%>
					<%
					select case facultad
							case 1  'FACULTAD DE COMUNICACIONES
%>
						<table border="0" align="center"  >
                                <tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
                                  <th >TIPO</th>
                                  <th colspan="2">ESCUELA DE COMUNICACIÓN MULTIMEDIA</th>
                                  <th colspan="2">ESCUELA DE DIRECCION Y PRODUCCION DE EVENTOS</th>
                                  <th colspan="2">ESCUELA DE FOTOGRAFIA</th>
								  <th colspan="2">ESCUELA DE MUSICA Y TECNOLOGIA</th>
                                  <th colspan="2">ESCUELA DE PERIODISMO</th>
                                  <th colspan="2">ESCUELA DE PUBLICIDAD</th>
                                  <th colspan="2">ESCUELA DE RELACIONES PUBLICAS</th>
								  <th colspan="2">LICENCIATURAS</th>
                                  <th colspan="2">OTROS FACULTAD COMUNICACIONES</th>
                                </tr>
								<%
								v_grupo=1
								v_subtotal_f1	= 0
								v_subtotal_f2	= 0
								v_subtotal_f3	= 0
								v_subtotal_f4 	= 0
								v_subtotal_f5	= 0
								v_subtotal_f6	= 0
								v_subtotal_f7	= 0
								v_subtotal_f8 	= 0
								v_subtotal_f9	= 0

								while f_ingreso.Siguiente
									descripcion_grupo= f_ingreso.ObtenerValor("descripcion_grupo")

										v_porcentaje_f1	= (CDBL(f_ingreso.ObtenerValor("f1"))*-100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_ingreso.ObtenerValor("f2"))*-100)/CDBL(v_total_f2)
										v_porcentaje_f3	= (CDBL(f_ingreso.ObtenerValor("f3"))*-100)/CDBL(v_total_f3)
										v_porcentaje_f4	= (CDBL(f_ingreso.ObtenerValor("f4"))*-100)/CDBL(v_total_f4)
										v_porcentaje_f5	= (CDBL(f_ingreso.ObtenerValor("f5"))*-100)/CDBL(v_total_f5)
										v_porcentaje_f6	= (CDBL(f_ingreso.ObtenerValor("f6"))*-100)/CDBL(v_total_f6)
										v_porcentaje_f7	= (CDBL(f_ingreso.ObtenerValor("f7"))*-100)/CDBL(v_total_f7)
										v_porcentaje_f8	= (CDBL(f_ingreso.ObtenerValor("f8"))*-100)/CDBL(v_total_f8)
										v_porcentaje_f9	= (CDBL(f_ingreso.ObtenerValor("f9"))*-100)/CDBL(v_total_f9)

									
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_ingreso.ObtenerValor("f1"))*-1)
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_ingreso.ObtenerValor("f2"))*-1)
										v_subtotal_f3	= v_subtotal_f3 + (CDBL(f_ingreso.ObtenerValor("f3"))*-1)
										v_subtotal_f4	= v_subtotal_f4 + (CDBL(f_ingreso.ObtenerValor("f4"))*-1)
										v_subtotal_f5	= v_subtotal_f5 + (CDBL(f_ingreso.ObtenerValor("f5"))*-1)
										v_subtotal_f6	= v_subtotal_f6 + (CDBL(f_ingreso.ObtenerValor("f6"))*-1)
										v_subtotal_f7	= v_subtotal_f7 + (CDBL(f_ingreso.ObtenerValor("f7"))*-1)
										v_subtotal_f8	= v_subtotal_f8 + (CDBL(f_ingreso.ObtenerValor("f8"))*-1)
										v_subtotal_f9	= v_subtotal_f9 + (CDBL(f_ingreso.ObtenerValor("f9"))*-1)

								%>
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  <td align="left"><%f_ingreso.DibujaCampo("descripcion")%></td>
								  <td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f1"))*-1,0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f1,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f2"))*-1,0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f2,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f3"))*-1,0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f3,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f4"))*-1,0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f4,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f5"))*-1,0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f5,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f6"))*-1,0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f6,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f7"))*-1,0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f7,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f8"))*-1,0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f8,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f9"))*-1,0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f9,0)%><strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
								%>
								<!-- INICIO sub total de grupos -->
									<tr bordercolor='#999999' align="right">	
									  <th align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th nowrap><%=formatnumber(v_subtotal_f1,0)%></th>
										<th nowrap></th>
									  <th nowrap><%=formatnumber(v_subtotal_f2,0)%></th>
										<th nowrap></th>
									  <th nowrap><%=formatnumber(v_subtotal_f3,0)%></th>
										<th nowrap></th>
									  <th nowrap><%=formatnumber(v_subtotal_f4,0)%></th>
										<th nowrap></th>
									  <th nowrap><%=formatnumber(v_subtotal_f5,0)%></th>
										<th nowrap></th>
									  <th nowrap><%=formatnumber(v_subtotal_f6,0)%></th>
										<th nowrap></th>
									  <th nowrap><%=formatnumber(v_subtotal_f7,0)%></th>
										<th nowrap></th>
									  <th nowrap><%=formatnumber(v_subtotal_f8,0)%></th>
										<th nowrap></th>
									  <th nowrap><%=formatnumber(v_subtotal_f9,0)%></th>
										<th nowrap></th>
									</tr>
								<%

								v_subtotal_f1	= 0
								v_subtotal_f2	= 0
								v_subtotal_f3	= 0
								v_subtotal_f4 	= 0
								v_subtotal_f5	= 0
								v_subtotal_f6	= 0
								v_subtotal_f7	= 0
								v_subtotal_f8 	= 0
								v_subtotal_f9	= 0
															
								while f_costo_operacional.Siguiente
									descripcion_grupo= f_costo_operacional.ObtenerValor("descripcion_grupo")
								
										v_porcentaje_f1	= (CDBL(f_costo_operacional.ObtenerValor("f1"))*100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_costo_operacional.ObtenerValor("f2"))*100)/CDBL(v_total_f2)
										v_porcentaje_f3	= (CDBL(f_costo_operacional.ObtenerValor("f3"))*100)/CDBL(v_total_f3)
										v_porcentaje_f4	= (CDBL(f_costo_operacional.ObtenerValor("f4"))*100)/CDBL(v_total_f4)
										v_porcentaje_f5	= (CDBL(f_costo_operacional.ObtenerValor("f5"))*100)/CDBL(v_total_f5)
										v_porcentaje_f6	= (CDBL(f_costo_operacional.ObtenerValor("f6"))*100)/CDBL(v_total_f6)
										v_porcentaje_f7	= (CDBL(f_costo_operacional.ObtenerValor("f7"))*100)/CDBL(v_total_f7)
										v_porcentaje_f8	= (CDBL(f_costo_operacional.ObtenerValor("f8"))*100)/CDBL(v_total_f8)
										v_porcentaje_f9	= (CDBL(f_costo_operacional.ObtenerValor("f9"))*100)/CDBL(v_total_f9)

									
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_costo_operacional.ObtenerValor("f1")))
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_costo_operacional.ObtenerValor("f2")))
										v_subtotal_f3	= v_subtotal_f3 + (CDBL(f_costo_operacional.ObtenerValor("f3")))
										v_subtotal_f4	= v_subtotal_f4 + (CDBL(f_costo_operacional.ObtenerValor("f4")))
										v_subtotal_f5	= v_subtotal_f5 + (CDBL(f_costo_operacional.ObtenerValor("f5")))
										v_subtotal_f6	= v_subtotal_f6 + (CDBL(f_costo_operacional.ObtenerValor("f6")))
										v_subtotal_f7	= v_subtotal_f7 + (CDBL(f_costo_operacional.ObtenerValor("f7")))
										v_subtotal_f8	= v_subtotal_f8 + (CDBL(f_costo_operacional.ObtenerValor("f8")))
										v_subtotal_f9	= v_subtotal_f9 + (CDBL(f_costo_operacional.ObtenerValor("f9")))
								
								
								%>							
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_costo_operacional.DibujaCampo("descripcion")%></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f1")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f1,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f2")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f2,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f3")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f3,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f4")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f4,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f5")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f5,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f6")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f6,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f7")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f7,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f8")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f8,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f9")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f9,0)%><strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
								
									v_porc_grupo_f1	= (CDBL(v_subtotal_f1)*100)/CDBL(v_total_f1)
									v_porc_grupo_f2	= (CDBL(v_subtotal_f2)*100)/CDBL(v_total_f2)
									v_porc_grupo_f3	= (CDBL(v_subtotal_f3)*100)/CDBL(v_total_f3)
									v_porc_grupo_f4	= (CDBL(v_subtotal_f4)*100)/CDBL(v_total_f4)
									v_porc_grupo_f5	= (CDBL(v_subtotal_f5)*100)/CDBL(v_total_f5)
									v_porc_grupo_f6	= (CDBL(v_subtotal_f6)*100)/CDBL(v_total_f6)
									v_porc_grupo_f7	= (CDBL(v_subtotal_f7)*100)/CDBL(v_total_f7)
									v_porc_grupo_f8	= (CDBL(v_subtotal_f8)*100)/CDBL(v_total_f8)
									v_porc_grupo_f9	= (CDBL(v_subtotal_f9)*100)/CDBL(v_total_f9)

									
									'*** Subtotal Acumulado (A-B)=C ***
									v_operacional_f1 	= CDBL(v_total_f1)-CDBL(v_subtotal_f1)
									v_operacional_f2 	= CDBL(v_total_f2)-CDBL(v_subtotal_f2)	
									v_operacional_f3 	= CDBL(v_total_f3)-CDBL(v_subtotal_f3)	
									v_operacional_f4 	= CDBL(v_total_f4)-CDBL(v_subtotal_f4)
									v_operacional_f5 	= CDBL(v_total_f5)-CDBL(v_subtotal_f5)
									v_operacional_f6 	= CDBL(v_total_f6)-CDBL(v_subtotal_f6)	
									v_operacional_f7 	= CDBL(v_total_f7)-CDBL(v_subtotal_f7)	
									v_operacional_f8 	= CDBL(v_total_f8)-CDBL(v_subtotal_f8)
									v_operacional_f9 	= CDBL(v_total_f9)-CDBL(v_subtotal_f9)
									
									v_porc_operacional_f1	= (CDBL(v_operacional_f1)*100)/CDBL(v_total_f1)
									v_porc_operacional_f2	= (CDBL(v_operacional_f2)*100)/CDBL(v_total_f2)
									v_porc_operacional_f3	= (CDBL(v_operacional_f3)*100)/CDBL(v_total_f3)
									v_porc_operacional_f4	= (CDBL(v_operacional_f4)*100)/CDBL(v_total_f4)
									v_porc_operacional_f5	= (CDBL(v_operacional_f5)*100)/CDBL(v_total_f5)
									v_porc_operacional_f6	= (CDBL(v_operacional_f6)*100)/CDBL(v_total_f6)
									v_porc_operacional_f7	= (CDBL(v_operacional_f7)*100)/CDBL(v_total_f7)
									v_porc_operacional_f8	= (CDBL(v_operacional_f8)*100)/CDBL(v_total_f8)
									v_porc_operacional_f9	= (CDBL(v_operacional_f9)*100)/CDBL(v_total_f9)
								
								%>
								<!-- INICIO sub total de grupo -->
									<tr bordercolor='#999999' align="right">	
									  <th align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th nowrap><%=formatnumber(v_subtotal_f1,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f1,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f2,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f2,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f3,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f3,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f4,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f4,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f5,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f5,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f6,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f6,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f7,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f7,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f8,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f8,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f9,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f9,0)%><strong>%</strong></th>
									</tr>
								<!-- INICIO totalizado de RESULTADO OPERACIONAL-->
									<tr><th colspan="19" height="5"></th>
									</tr>
									<tr bordercolor='#999999' bgcolor="#FFFFCC" align="right">	
										<th align="left"><strong>RESULTADO OPERACIONAL</strong></th>
									  <th nowrap><%=formatnumber(v_operacional_f1,0)%></th>
									  <th nowrap><%=Round(v_porc_operacional_f1,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_operacional_f2,0)%></th>
									  <th nowrap><%=Round(v_porc_operacional_f2,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_operacional_f3,0)%></th>
									  <th nowrap><%=Round(v_porc_operacional_f3,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_operacional_f4,0)%></th>
									  <th nowrap><%=Round(v_porc_operacional_f4,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_operacional_f5,0)%></th>
									  <th nowrap><%=Round(v_porc_operacional_f5,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_operacional_f6,0)%></th>
									  <th nowrap><%=Round(v_porc_operacional_f6,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_operacional_f7,0)%></th>
									  <th nowrap><%=Round(v_porc_operacional_f7,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_operacional_f8,0)%></th>
									  <th nowrap><%=Round(v_porc_operacional_f8,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_operacional_f9,0)%></th>
									  <th nowrap><%=Round(v_porc_operacional_f9,0)%><strong>%</strong></th>
									</tr>
									<tr><th colspan="19" height="10"></th>									
								<%
								
								v_subtotal_f1	= 0
								v_subtotal_f2	= 0
								v_subtotal_f3	= 0
								v_subtotal_f4 	= 0
								v_subtotal_f5	= 0
								v_subtotal_f6	= 0
								v_subtotal_f7	= 0
								v_subtotal_f8 	= 0
								v_subtotal_f9	= 0

								while f_gasto_administracion.Siguiente
									descripcion_grupo= f_gasto_administracion.ObtenerValor("descripcion_grupo")
									
										v_porcentaje_f1	= (CDBL(f_gasto_administracion.ObtenerValor("f1"))*100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_gasto_administracion.ObtenerValor("f2"))*100)/CDBL(v_total_f2)
										v_porcentaje_f3	= (CDBL(f_gasto_administracion.ObtenerValor("f3"))*100)/CDBL(v_total_f3)
										v_porcentaje_f4	= (CDBL(f_gasto_administracion.ObtenerValor("f4"))*100)/CDBL(v_total_f4)
										v_porcentaje_f5	= (CDBL(f_gasto_administracion.ObtenerValor("f5"))*100)/CDBL(v_total_f5)
										v_porcentaje_f6	= (CDBL(f_gasto_administracion.ObtenerValor("f6"))*100)/CDBL(v_total_f6)
										v_porcentaje_f7	= (CDBL(f_gasto_administracion.ObtenerValor("f7"))*100)/CDBL(v_total_f7)
										v_porcentaje_f8	= (CDBL(f_gasto_administracion.ObtenerValor("f8"))*100)/CDBL(v_total_f8)
										v_porcentaje_f9	= (CDBL(f_gasto_administracion.ObtenerValor("f9"))*100)/CDBL(v_total_f9)

									
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_gasto_administracion.ObtenerValor("f1")))
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_gasto_administracion.ObtenerValor("f2")))
										v_subtotal_f3	= v_subtotal_f3 + (CDBL(f_gasto_administracion.ObtenerValor("f3")))
										v_subtotal_f4	= v_subtotal_f4 + (CDBL(f_gasto_administracion.ObtenerValor("f4")))
										v_subtotal_f5	= v_subtotal_f5 + (CDBL(f_gasto_administracion.ObtenerValor("f5")))
										v_subtotal_f6	= v_subtotal_f6 + (CDBL(f_gasto_administracion.ObtenerValor("f6")))
										v_subtotal_f7	= v_subtotal_f7 + (CDBL(f_gasto_administracion.ObtenerValor("f7")))
										v_subtotal_f8	= v_subtotal_f8 + (CDBL(f_gasto_administracion.ObtenerValor("f8")))
										v_subtotal_f9	= v_subtotal_f9 + (CDBL(f_gasto_administracion.ObtenerValor("f9")))
								
								%>							
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_gasto_administracion.DibujaCampo("descripcion")%></td>
								  <td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f1")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f1,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f2")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f2,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f3")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f3,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f4")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f4,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f5")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f5,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f6")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f6,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f7")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f7,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f8")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f8,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f9")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f9,0)%><strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
									v_porc_grupo_f1	= (CDBL(v_subtotal_f1)*100)/CDBL(v_total_f1)
									v_porc_grupo_f2	= (CDBL(v_subtotal_f2)*100)/CDBL(v_total_f2)
									v_porc_grupo_f3	= (CDBL(v_subtotal_f3)*100)/CDBL(v_total_f3)
									v_porc_grupo_f4	= (CDBL(v_subtotal_f4)*100)/CDBL(v_total_f4)
									v_porc_grupo_f5	= (CDBL(v_subtotal_f5)*100)/CDBL(v_total_f5)
									v_porc_grupo_f6	= (CDBL(v_subtotal_f6)*100)/CDBL(v_total_f6)
									v_porc_grupo_f7	= (CDBL(v_subtotal_f7)*100)/CDBL(v_total_f7)
									v_porc_grupo_f8	= (CDBL(v_subtotal_f8)*100)/CDBL(v_total_f8)
									v_porc_grupo_f9	= (CDBL(v_subtotal_f9)*100)/CDBL(v_total_f9)

									'*** Subtotal Acumulado (C-D)=E ***
									v_adm_f1 	= CDBL(v_operacional_f1)-CDBL(v_subtotal_f1)
									v_adm_f2 	= CDBL(v_operacional_f2)-CDBL(v_subtotal_f2)	
									v_adm_f3 	= CDBL(v_operacional_f3)-CDBL(v_subtotal_f3)	
									v_adm_f4 	= CDBL(v_operacional_f4)-CDBL(v_subtotal_f4)
									v_adm_f5 	= CDBL(v_operacional_f5)-CDBL(v_subtotal_f5)
									v_adm_f6 	= CDBL(v_operacional_f6)-CDBL(v_subtotal_f6)	
									v_adm_f7 	= CDBL(v_operacional_f7)-CDBL(v_subtotal_f7)	
									v_adm_f8 	= CDBL(v_operacional_f8)-CDBL(v_subtotal_f8)
									v_adm_f9 	= CDBL(v_operacional_f9)-CDBL(v_subtotal_f9)
									
									v_porc_adm_f1	= (CDBL(v_adm_f1)*100)/CDBL(v_total_f1)
									v_porc_adm_f2	= (CDBL(v_adm_f2)*100)/CDBL(v_total_f2)
									v_porc_adm_f3	= (CDBL(v_adm_f3)*100)/CDBL(v_total_f3)
									v_porc_adm_f4	= (CDBL(v_adm_f4)*100)/CDBL(v_total_f4)
									v_porc_adm_f5	= (CDBL(v_adm_f5)*100)/CDBL(v_total_f5)
									v_porc_adm_f6	= (CDBL(v_adm_f6)*100)/CDBL(v_total_f6)
									v_porc_adm_f7	= (CDBL(v_adm_f7)*100)/CDBL(v_total_f7)
									v_porc_adm_f8	= (CDBL(v_adm_f8)*100)/CDBL(v_total_f8)
									v_porc_adm_f9	= (CDBL(v_adm_f9)*100)/CDBL(v_total_f9)
								%>
								<!-- INICIO sub total de grupos -->
									<tr bordercolor='#999999' align="right">	
									  <th align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
									  <th nowrap><%=formatnumber(v_subtotal_f1,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f1,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f2,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f2,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f3,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f3,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f4,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f4,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f5,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f5,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f6,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f6,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f7,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f7,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f8,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f8,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f9,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f9,0)%><strong>%</strong></th>
									</tr>
								<!-- INICIO totalizado de RESULTADO OPERACIONAL-->
									<tr><th colspan="19" height="5"></th>
									<tr bordercolor='#999999' bgcolor="#FFFFCC" align="right">	
										<th align="left"><strong>RESULTADO</strong></th>
									  <th nowrap><%=formatnumber(v_adm_f1,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f1,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_adm_f2,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f2,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_adm_f3,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f3,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_adm_f4,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f4,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_adm_f5,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f5,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_adm_f6,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f6,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_adm_f7,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f7,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_adm_f8,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f8,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_adm_f9,0)%></th>
									  <th nowrap><%=Round(v_porc_adm_f9,0)%><strong>%</strong></th>
									</tr>
									<tr><th colspan="19" height="10"></th>
								 <%
								 
									v_subtotal_f1	= 0
									v_subtotal_f2	= 0
									v_subtotal_f3	= 0
									v_subtotal_f4 	= 0
									v_subtotal_f5	= 0
									v_subtotal_f6	= 0
									v_subtotal_f7	= 0
									v_subtotal_f8 	= 0
									v_subtotal_f9	= 0
										
								 while f_gasto_indirecto.Siguiente
								 
								  		descripcion_grupo= f_gasto_indirecto.ObtenerValor("descripcion_grupo")
								 
										v_porcentaje_f1	= (CDBL(f_gasto_indirecto.ObtenerValor("f1"))*100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_gasto_indirecto.ObtenerValor("f2"))*100)/CDBL(v_total_f2)
										v_porcentaje_f3	= (CDBL(f_gasto_indirecto.ObtenerValor("f3"))*100)/CDBL(v_total_f3)
										v_porcentaje_f4	= (CDBL(f_gasto_indirecto.ObtenerValor("f4"))*100)/CDBL(v_total_f4)
										v_porcentaje_f5	= (CDBL(f_gasto_indirecto.ObtenerValor("f5"))*100)/CDBL(v_total_f5)
										v_porcentaje_f6	= (CDBL(f_gasto_indirecto.ObtenerValor("f6"))*100)/CDBL(v_total_f6)
										v_porcentaje_f7	= (CDBL(f_gasto_indirecto.ObtenerValor("f7"))*100)/CDBL(v_total_f7)
										v_porcentaje_f8	= (CDBL(f_gasto_indirecto.ObtenerValor("f8"))*100)/CDBL(v_total_f8)
										v_porcentaje_f9	= (CDBL(f_gasto_indirecto.ObtenerValor("f9"))*100)/CDBL(v_total_f9)
									
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_gasto_indirecto.ObtenerValor("f1")))
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_gasto_indirecto.ObtenerValor("f2")))
										v_subtotal_f3	= v_subtotal_f3 + (CDBL(f_gasto_indirecto.ObtenerValor("f3")))
										v_subtotal_f4	= v_subtotal_f4 + (CDBL(f_gasto_indirecto.ObtenerValor("f4")))
										v_subtotal_f5	= v_subtotal_f5 + (CDBL(f_gasto_indirecto.ObtenerValor("f5")))
										v_subtotal_f6	= v_subtotal_f6 + (CDBL(f_gasto_indirecto.ObtenerValor("f6")))
										v_subtotal_f7	= v_subtotal_f7 + (CDBL(f_gasto_indirecto.ObtenerValor("f7")))
										v_subtotal_f8	= v_subtotal_f8 + (CDBL(f_gasto_indirecto.ObtenerValor("f8")))
										v_subtotal_f9	= v_subtotal_f9 + (CDBL(f_gasto_indirecto.ObtenerValor("f9")))
								%>
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_gasto_indirecto.DibujaCampo("descripcion")%></td>
								  <td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f1")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f1,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f2")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f2,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f3")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f3,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f4")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f4,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f5")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f5,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f6")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f6,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f7")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f7,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f8")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f8,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f9")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f9,0)%><strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
								
								
									v_porc_grupo_f1	= (CDBL(v_subtotal_f1)*100)/CDBL(v_total_f1)
									v_porc_grupo_f2	= (CDBL(v_subtotal_f2)*100)/CDBL(v_total_f2)
									v_porc_grupo_f3	= (CDBL(v_subtotal_f3)*100)/CDBL(v_total_f3)
									v_porc_grupo_f4	= (CDBL(v_subtotal_f4)*100)/CDBL(v_total_f4)
									v_porc_grupo_f5	= (CDBL(v_subtotal_f5)*100)/CDBL(v_total_f5)
									v_porc_grupo_f6	= (CDBL(v_subtotal_f6)*100)/CDBL(v_total_f6)
									v_porc_grupo_f7	= (CDBL(v_subtotal_f7)*100)/CDBL(v_total_f7)
									v_porc_grupo_f8	= (CDBL(v_subtotal_f8)*100)/CDBL(v_total_f8)
									v_porc_grupo_f9	= (CDBL(v_subtotal_f9)*100)/CDBL(v_total_f9)
								
								%>
								<!-- INICIO sub total de grupos -->
									<tr bordercolor='#999999' align="right">	
									  <th align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th nowrap><%=formatnumber(v_subtotal_f1,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f1,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f2,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f2,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f3,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f3,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f4,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f4,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f5,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f5,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f6,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f6,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f7,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f7,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f8,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f8,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f9,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f9,0)%><strong>%</strong></th>
									</tr>
									<%
									'*** Subtotal Acumulado (E-F)=G ***
									v_resul_total_f1 	= CDBL(v_adm_f1)-CDBL(v_subtotal_f1)
									v_resul_total_f2 	= CDBL(v_adm_f2)-CDBL(v_subtotal_f2)	
									v_resul_total_f3 	= CDBL(v_adm_f3)-CDBL(v_subtotal_f3)	
									v_resul_total_f4 	= CDBL(v_adm_f4)-CDBL(v_subtotal_f4)
									v_resul_total_f5 	= CDBL(v_adm_f5)-CDBL(v_subtotal_f5)
									v_resul_total_f6 	= CDBL(v_adm_f6)-CDBL(v_subtotal_f6)	
									v_resul_total_f7 	= CDBL(v_adm_f7)-CDBL(v_subtotal_f7)	
									v_resul_total_f8 	= CDBL(v_adm_f8)-CDBL(v_subtotal_f8)
									v_resul_total_f9 	= CDBL(v_adm_f9)-CDBL(v_subtotal_f9)
									
									v_porc_total_f1	= (CDBL(v_resul_total_f1)*100)/CDBL(v_total_f1)
									v_porc_total_f2	= (CDBL(v_resul_total_f2)*100)/CDBL(v_total_f2)
									v_porc_total_f3	= (CDBL(v_resul_total_f3)*100)/CDBL(v_total_f3)
									v_porc_total_f4	= (CDBL(v_resul_total_f4)*100)/CDBL(v_total_f4)
									v_porc_total_f5	= (CDBL(v_resul_total_f5)*100)/CDBL(v_total_f5)
									v_porc_total_f6	= (CDBL(v_resul_total_f6)*100)/CDBL(v_total_f6)
									v_porc_total_f7	= (CDBL(v_resul_total_f7)*100)/CDBL(v_total_f7)
									v_porc_total_f8	= (CDBL(v_resul_total_f8)*100)/CDBL(v_total_f8)
									v_porc_total_f9	= (CDBL(v_resul_total_f9)*100)/CDBL(v_total_f9)
									
									%>
								 <tr><th colspan="19" height="5"></th>
								 <tr bordercolor='#999999'  bgcolor="#FFFFCC" align="right">
								 	<td align="left"><b>RESULTADO TOTAL</b></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f1,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f1,0)%></b><strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f2,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f2,0)%></b><strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f3,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f3,0)%></b><strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f4,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f4,0)%></b><strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f5,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f5,0)%></b><strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f6,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f6,0)%></b><strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f7,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f7,0)%></b><strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f8,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f8,0)%></b><strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f9,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f9,0)%></b><strong>%</strong></td>
								 </tr>
                              </table>
<%
case 2 'FACULTAD DE DISEÑO
%>
								<table width="98%" border="0" align="center"  >
                                <tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
                                  <th>TIPO</th>
                                  <th colspan="2">ESCUELA DE DISEÑO</th>
                                  <th colspan="2">ESCUELA DE DISEÑO DE VESTUARIO Y TEXTIL</th>
                                  <th colspan="2">ESCUELA DE DISEÑO GRAFICO</th>
                                </tr>
								<%
								v_grupo=1
								v_subtotal_f1	= 0
								v_subtotal_f2	= 0
								v_subtotal_f3	= 0
								
								while f_ingreso.Siguiente
									descripcion_grupo= f_ingreso.ObtenerValor("descripcion_grupo")

										v_porcentaje_f1	= (CDBL(f_ingreso.ObtenerValor("f1"))*-100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_ingreso.ObtenerValor("f2"))*-100)/CDBL(v_total_f2)
										v_porcentaje_f3	= (CDBL(f_ingreso.ObtenerValor("f3"))*-100)/CDBL(v_total_f3)
																				
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_ingreso.ObtenerValor("f1"))*-1)
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_ingreso.ObtenerValor("f2"))*-1)
										v_subtotal_f3	= v_subtotal_f3 + (CDBL(f_ingreso.ObtenerValor("f3"))*-1)
								%>
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_ingreso.DibujaCampo("descripcion")%></td>
								  <td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f1"))*-1,0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f1,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f2"))*-1,0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f2,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f3"))*-1,0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f3,0)%><strong>%</strong></td>
								  </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
								%>
								<!-- INICIO sub total de grupos -->
									<tr bordercolor='#999999' align="right">	
									  <th align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th nowrap><%=formatnumber(v_subtotal_f1,0)%></th>
									  <th nowrap></th>
									  <th nowrap><%=formatnumber(v_subtotal_f2,0)%></th>
										<th nowrap></th>
										<th nowrap><%=formatnumber(v_subtotal_f3,0)%></th>
										<th nowrap></th>
									</tr>
								<%

								v_subtotal_f1	= 0
								v_subtotal_f2	= 0
								v_subtotal_f3	= 0
															
								while f_costo_operacional.Siguiente
									descripcion_grupo= f_costo_operacional.ObtenerValor("descripcion_grupo")
								
										v_porcentaje_f1	= (CDBL(f_costo_operacional.ObtenerValor("f1"))*100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_costo_operacional.ObtenerValor("f2"))*100)/CDBL(v_total_f2)
										v_porcentaje_f3	= (CDBL(f_costo_operacional.ObtenerValor("f3"))*100)/CDBL(v_total_f3)
									
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_costo_operacional.ObtenerValor("f1")))
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_costo_operacional.ObtenerValor("f2")))
										v_subtotal_f3	= v_subtotal_f3 + (CDBL(f_costo_operacional.ObtenerValor("f3")))
								
								
								%>							
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_costo_operacional.DibujaCampo("descripcion")%></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f1")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f1,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f2")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f2,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f3")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f3,0)%><strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
								
									v_porc_grupo_f1	= (CDBL(v_subtotal_f1)*100)/CDBL(v_total_f1)
									v_porc_grupo_f2	= (CDBL(v_subtotal_f2)*100)/CDBL(v_total_f2)
									v_porc_grupo_f3	= (CDBL(v_subtotal_f3)*100)/CDBL(v_total_f3)
									
									'*** Subtotal Acumulado (A-B)=C ***
									v_operacional_f1 	= CDBL(v_total_f1)-CDBL(v_subtotal_f1)
									v_operacional_f2 	= CDBL(v_total_f2)-CDBL(v_subtotal_f2)	
									v_operacional_f3 	= CDBL(v_total_f3)-CDBL(v_subtotal_f3)	
									
									v_porc_operacional_f1	= (CDBL(v_operacional_f1)*100)/CDBL(v_total_f1)
									v_porc_operacional_f2	= (CDBL(v_operacional_f2)*100)/CDBL(v_total_f2)
									v_porc_operacional_f3	= (CDBL(v_operacional_f3)*100)/CDBL(v_total_f3)
								
								%>
								<!-- INICIO sub total de grupo -->
									<tr bordercolor='#999999' align="right">	
									  <th align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th nowrap><%=formatnumber(v_subtotal_f1,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f1,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f2,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f2,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f3,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f3,0)%><strong>%</strong></th>
									</tr>
								<!-- INICIO totalizado de RESULTADO OPERACIONAL-->
									<tr><th colspan="7" height="5"></th>
									<tr bordercolor='#999999' bgcolor="#FFFFCC" align="right">	
										<th align="left"><strong>RESULTADO OPERACIONAL</strong></th>
										<th nowrap><%=formatnumber(v_operacional_f1,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_f1,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_operacional_f2,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_f2,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_operacional_f3,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_f3,0)%><strong>%</strong></th>
									</tr>
								<%
								
								v_subtotal_f1	= 0
								v_subtotal_f2	= 0
								v_subtotal_f3	= 0
								v_subtotal_f4 	= 0

								while f_gasto_administracion.Siguiente
									descripcion_grupo= f_gasto_administracion.ObtenerValor("descripcion_grupo")
									
										v_porcentaje_f1	= (CDBL(f_gasto_administracion.ObtenerValor("f1"))*100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_gasto_administracion.ObtenerValor("f2"))*100)/CDBL(v_total_f2)
										v_porcentaje_f3	= (CDBL(f_gasto_administracion.ObtenerValor("f3"))*100)/CDBL(v_total_f3)
									
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_gasto_administracion.ObtenerValor("f1")))
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_gasto_administracion.ObtenerValor("f2")))
										v_subtotal_f3	= v_subtotal_f3 + (CDBL(f_gasto_administracion.ObtenerValor("f3")))
								
								%>							
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_gasto_administracion.DibujaCampo("descripcion")%></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f1")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f1,0)%><strong>%</strong></td>
   											<td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f2")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f2,0)%><strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f3")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f3,0)%><strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
									v_porc_grupo_f1	= (CDBL(v_subtotal_f1)*100)/CDBL(v_total_f1)
									v_porc_grupo_f2	= (CDBL(v_subtotal_f2)*100)/CDBL(v_total_f2)
									v_porc_grupo_f3	= (CDBL(v_subtotal_f3)*100)/CDBL(v_total_f3)

									'*** Subtotal Acumulado (C-D)=E ***
									v_adm_f1 	= CDBL(v_operacional_f1)-CDBL(v_subtotal_f1)
									v_adm_f2 	= CDBL(v_operacional_f2)-CDBL(v_subtotal_f2)	
									v_adm_f3 	= CDBL(v_operacional_f3)-CDBL(v_subtotal_f3)	
									
									v_porc_adm_f1	= (CDBL(v_adm_f1)*100)/CDBL(v_total_f1)
									v_porc_adm_f2	= (CDBL(v_adm_f2)*100)/CDBL(v_total_f2)
									v_porc_adm_f3	= (CDBL(v_adm_f3)*100)/CDBL(v_total_f3)
								%>
								<!-- INICIO sub total de grupos -->
									<tr bordercolor='#999999' align="right">	
										<th align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th nowrap><%=formatnumber(v_subtotal_f1,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f1,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f2,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f2,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f3,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f3,0)%><strong>%</strong></th>
									</tr>
								<!-- INICIO totalizado de RESULTADO OPERACIONAL-->
									<tr><th colspan="7" height="5"></th>
									<tr bordercolor='#999999' bgcolor="#FFFFCC" align="right">	
										<th align="left"><strong>RESULTADO</strong></th>
										<th nowrap><%=formatnumber(v_adm_f1,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f1,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_adm_f2,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f2,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_adm_f3,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f3,0)%><strong>%</strong></th>
									</tr>
									<tr><th colspan="7" height="10"></th>									
								 <%
								 
									v_subtotal_f1	= 0
									v_subtotal_f2	= 0
									v_subtotal_f3	= 0
										
								 while f_gasto_indirecto.Siguiente
								 		descripcion_grupo= f_gasto_indirecto.ObtenerValor("descripcion_grupo")
								 
										v_porcentaje_f1	= (CDBL(f_gasto_indirecto.ObtenerValor("f1"))*100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_gasto_indirecto.ObtenerValor("f2"))*100)/CDBL(v_total_f2)
										v_porcentaje_f3	= (CDBL(f_gasto_indirecto.ObtenerValor("f3"))*100)/CDBL(v_total_f3)
									
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_gasto_indirecto.ObtenerValor("f1")))
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_gasto_indirecto.ObtenerValor("f2")))
										v_subtotal_f3	= v_subtotal_f3 + (CDBL(f_gasto_indirecto.ObtenerValor("f3")))
								%>
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_gasto_indirecto.DibujaCampo("descripcion")%></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f1")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f1,0)%><strong>%</strong></td>
   											<td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f2")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f2,0)%><strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f3")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f3,0)%><strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
									v_porc_grupo_f1	= (CDBL(v_subtotal_f1)*100)/CDBL(v_total_f1)
									v_porc_grupo_f2	= (CDBL(v_subtotal_f2)*100)/CDBL(v_total_f2)
									v_porc_grupo_f3	= (CDBL(v_subtotal_f3)*100)/CDBL(v_total_f3)
								%>
								<!-- INICIO sub total de grupos -->
									<tr bordercolor='#999999' align="right">	
										<th align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th nowrap><%=formatnumber(v_subtotal_f1,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f1,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f2,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f2,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f3,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f3,0)%><strong>%</strong></th>
									</tr>
									<%
									'*** Subtotal Acumulado (E-F)=G ***
									v_resul_total_f1 	= CDBL(v_adm_f1)-CDBL(v_subtotal_f1)
									v_resul_total_f2 	= CDBL(v_adm_f2)-CDBL(v_subtotal_f2)	
									v_resul_total_f3 	= CDBL(v_adm_f3)-CDBL(v_subtotal_f3)	
									
									v_porc_total_f1	= (CDBL(v_resul_total_f1)*100)/CDBL(v_total_f1)
									v_porc_total_f2	= (CDBL(v_resul_total_f2)*100)/CDBL(v_total_f2)
									v_porc_total_f3	= (CDBL(v_resul_total_f3)*100)/CDBL(v_total_f3)
									
									%>
								 <tr><th colspan="7" height="5"></th>
								 <tr bordercolor='#999999'  bgcolor="#FFFFCC" align="right">
								 	<td align="left"><b>RESULTADO TOTAL</b></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f1,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f1,0)%></b><strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f2,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f2,0)%></b><strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f3,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f3,0)%></b><strong>%</strong></td>
								 </tr>
								 <tr><th colspan="7" height="10"></th>
                              </table>
<%
							case 3 'FACULTAD DE NEGOCIOS Y MARKETING
%>

<table width="98%" border="0" align="center"  >
                                <tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
                                  <th width="14%">TIPO</th>
                                  <th colspan="2">ESCUELA DE CONTADOR AUDITOR</th>
                                  <th colspan="2">ESCUELA DE INGENIERIA COMERCIAL</th>
                                  <th colspan="2">ESCUELA DE INGENIERIA EN GESTION AERONAUTICA</th>
								  <th colspan="2">ESCUELA DE INGENIERIA EN GESTION DE EMPRESAS DE SERVICIOS</th>
                                  <th colspan="2">ESCUELA DE INGENIERIA EN GESTION TURISTICA</th>
                                  <th colspan="2">ESCUELA DE PREVENCION DE RIESGOS</th>
                                  <th colspan="2">OTROS DE FACULTAD DE NEGOCIOS Y MARKETING</th>
                                </tr>
								<%
								v_grupo=1
								v_subtotal_f1	= 0
								v_subtotal_f2	= 0
								v_subtotal_f3	= 0
								v_subtotal_f4 	= 0
								v_subtotal_f5	= 0
								v_subtotal_f6	= 0
								v_subtotal_f7	= 0
								
								while f_ingreso.Siguiente
									descripcion_grupo= f_ingreso.ObtenerValor("descripcion_grupo")

										v_porcentaje_f1	= (CDBL(f_ingreso.ObtenerValor("f1"))*-100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_ingreso.ObtenerValor("f2"))*-100)/CDBL(v_total_f2)
										v_porcentaje_f3	= (CDBL(f_ingreso.ObtenerValor("f3"))*-100)/CDBL(v_total_f3)
										v_porcentaje_f4	= (CDBL(f_ingreso.ObtenerValor("f4"))*-100)/CDBL(v_total_f4)
										v_porcentaje_f5	= (CDBL(f_ingreso.ObtenerValor("f5"))*-100)/CDBL(v_total_f5)
										v_porcentaje_f6	= (CDBL(f_ingreso.ObtenerValor("f6"))*-100)/CDBL(v_total_f6)
										v_porcentaje_f7	= (CDBL(f_ingreso.ObtenerValor("f7"))*-100)/CDBL(v_total_f7)
									
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_ingreso.ObtenerValor("f1"))*-1)
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_ingreso.ObtenerValor("f2"))*-1)
										v_subtotal_f3	= v_subtotal_f3 + (CDBL(f_ingreso.ObtenerValor("f3"))*-1)
										v_subtotal_f4	= v_subtotal_f4 + (CDBL(f_ingreso.ObtenerValor("f4"))*-1)
										v_subtotal_f5	= v_subtotal_f5 + (CDBL(f_ingreso.ObtenerValor("f5"))*-1)
										v_subtotal_f6	= v_subtotal_f6 + (CDBL(f_ingreso.ObtenerValor("f6"))*-1)
										v_subtotal_f7	= v_subtotal_f7 + (CDBL(f_ingreso.ObtenerValor("f7"))*-1)
								%>
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_ingreso.DibujaCampo("descripcion")%></td>
											<td width="4%" nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f1"))*-1,0)%></td>
											<td width="7%" nowrap><%=Round(v_porcentaje_f1,0)%><strong>%</strong></td>
   											<td width="4%" nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f2"))*-1,0)%></td>
											<td width="12%" nowrap><%=Round(v_porcentaje_f2,0)%><strong>%</strong></td>
											<td width="9%" nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f3"))*-1,0)%></td>
											<td width="10%" nowrap><%=Round(v_porcentaje_f3,0)%><strong>%</strong></td>
											<td width="13%" nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f4"))*-1,0)%></td>
											<td width="3%" nowrap><%=Round(v_porcentaje_f4,0)%><strong>%</strong></td>
											<td width="4%" nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f5"))*-1,0)%></td>
											<td width="7%" nowrap><%=Round(v_porcentaje_f5,0)%><strong>%</strong></td>
   											<td width="4%" nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f6"))*-1,0)%></td>
											<td width="12%" nowrap><%=Round(v_porcentaje_f6,0)%><strong>%</strong></td>
											<td width="9%" nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f7"))*-1,0)%></td>
											<td width="10%" nowrap><%=Round(v_porcentaje_f7,0)%><strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
								%>
								<!-- INICIO sub total de grupos -->
									<tr bordercolor='#999999' align="right">	
										<th width="25%" align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th width="10%" nowrap><%=formatnumber(v_subtotal_f1,0)%></th>
										<th nowrap></th>
										<th width="10%" nowrap><%=formatnumber(v_subtotal_f2,0)%></th>
										<th nowrap></th>
										<th width="10%" nowrap><%=formatnumber(v_subtotal_f3,0)%></th>
										<th nowrap></th>
										<th width="10%" nowrap><%=formatnumber(v_subtotal_f4,0)%></th>
										<th nowrap></th>
										<th width="10%" nowrap><%=formatnumber(v_subtotal_f5,0)%></th>
										<th nowrap></th>
										<th width="10%" nowrap><%=formatnumber(v_subtotal_f6,0)%></th>
										<th nowrap></th>
										<th width="10%" nowrap><%=formatnumber(v_subtotal_f7,0)%></th>
										<th nowrap></th>
									</tr>
								<%

								v_subtotal_f1	= 0
								v_subtotal_f2	= 0
								v_subtotal_f3	= 0
								v_subtotal_f4 	= 0
								v_subtotal_f5	= 0
								v_subtotal_f6	= 0
								v_subtotal_f7	= 0
															
								while f_costo_operacional.Siguiente
									descripcion_grupo= f_costo_operacional.ObtenerValor("descripcion_grupo")
								
										v_porcentaje_f1	= (CDBL(f_costo_operacional.ObtenerValor("f1"))*100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_costo_operacional.ObtenerValor("f2"))*100)/CDBL(v_total_f2)
										v_porcentaje_f3	= (CDBL(f_costo_operacional.ObtenerValor("f3"))*100)/CDBL(v_total_f3)
										v_porcentaje_f4	= (CDBL(f_costo_operacional.ObtenerValor("f4"))*100)/CDBL(v_total_f4)
										v_porcentaje_f5	= (CDBL(f_costo_operacional.ObtenerValor("f5"))*100)/CDBL(v_total_f5)
										v_porcentaje_f6	= (CDBL(f_costo_operacional.ObtenerValor("f6"))*100)/CDBL(v_total_f6)
										v_porcentaje_f7	= (CDBL(f_costo_operacional.ObtenerValor("f7"))*100)/CDBL(v_total_f7)
									
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_costo_operacional.ObtenerValor("f1")))
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_costo_operacional.ObtenerValor("f2")))
										v_subtotal_f3	= v_subtotal_f3 + (CDBL(f_costo_operacional.ObtenerValor("f3")))
										v_subtotal_f4	= v_subtotal_f4 + (CDBL(f_costo_operacional.ObtenerValor("f4")))
										v_subtotal_f5	= v_subtotal_f5 + (CDBL(f_costo_operacional.ObtenerValor("f5")))
										v_subtotal_f6	= v_subtotal_f6 + (CDBL(f_costo_operacional.ObtenerValor("f6")))
										v_subtotal_f7	= v_subtotal_f7 + (CDBL(f_costo_operacional.ObtenerValor("f7")))
								
								%>							
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_costo_operacional.DibujaCampo("descripcion")%></td>
											<td width="4%" nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f1")),0)%></td>
											<td width="7%" nowrap><%=Round(v_porcentaje_f1,0)%><strong>%</strong></td>
   											<td width="4%" nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f2")),0)%></td>
											<td width="12%" nowrap><%=Round(v_porcentaje_f2,0)%><strong>%</strong></td>
											<td width="9%" nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f3")),0)%></td>
											<td width="10%" nowrap><%=Round(v_porcentaje_f3,0)%><strong>%</strong></td>
											<td width="13%" nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f4")),0)%></td>
											<td width="3%" nowrap><%=Round(v_porcentaje_f4,0)%><strong>%</strong></td>
											<td width="4%" nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f5")),0)%></td>
											<td width="7%" nowrap><%=Round(v_porcentaje_f5,0)%><strong>%</strong></td>
   											<td width="4%" nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f6")),0)%></td>
											<td width="12%" nowrap><%=Round(v_porcentaje_f6,0)%><strong>%</strong></td>
											<td width="9%" nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f7")),0)%></td>
											<td width="10%" nowrap><%=Round(v_porcentaje_f7,0)%><strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
								
									v_porc_grupo_f1	= (CDBL(v_subtotal_f1)*100)/CDBL(v_total_f1)
									v_porc_grupo_f2	= (CDBL(v_subtotal_f2)*100)/CDBL(v_total_f2)
									v_porc_grupo_f3	= (CDBL(v_subtotal_f3)*100)/CDBL(v_total_f3)
									v_porc_grupo_f4	= (CDBL(v_subtotal_f4)*100)/CDBL(v_total_f4)
									v_porc_grupo_f5	= (CDBL(v_subtotal_f5)*100)/CDBL(v_total_f5)
									v_porc_grupo_f6	= (CDBL(v_subtotal_f6)*100)/CDBL(v_total_f6)
									v_porc_grupo_f7	= (CDBL(v_subtotal_f7)*100)/CDBL(v_total_f7)
									'*** Subtotal Acumulado (A-B)=C ***
									v_operacional_f1 	= CDBL(v_total_f1)-CDBL(v_subtotal_f1)
									v_operacional_f2 	= CDBL(v_total_f2)-CDBL(v_subtotal_f2)	
									v_operacional_f3 	= CDBL(v_total_f3)-CDBL(v_subtotal_f3)	
									v_operacional_f4 	= CDBL(v_total_f4)-CDBL(v_subtotal_f4)
									v_operacional_f5 	= CDBL(v_total_f5)-CDBL(v_subtotal_f5)
									v_operacional_f6 	= CDBL(v_total_f6)-CDBL(v_subtotal_f6)	
									v_operacional_f7 	= CDBL(v_total_f7)-CDBL(v_subtotal_f7)	
									
									v_porc_operacional_f1	= (CDBL(v_operacional_f1)*100)/CDBL(v_total_f1)
									v_porc_operacional_f2	= (CDBL(v_operacional_f2)*100)/CDBL(v_total_f2)
									v_porc_operacional_f3	= (CDBL(v_operacional_f3)*100)/CDBL(v_total_f3)
									v_porc_operacional_f4	= (CDBL(v_operacional_f4)*100)/CDBL(v_total_f4)
									v_porc_operacional_f5	= (CDBL(v_operacional_f5)*100)/CDBL(v_total_f5)
									v_porc_operacional_f6	= (CDBL(v_operacional_f6)*100)/CDBL(v_total_f6)
									v_porc_operacional_f7	= (CDBL(v_operacional_f7)*100)/CDBL(v_total_f7)
								
								%>
								<!-- INICIO sub total de grupo -->
									<tr bordercolor='#999999' align="right">	
										<th width="25%" align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th width="10%" nowrap><%=formatnumber(v_subtotal_f1,0)%></th>
										<th width="5%" nowrap><%=Round(v_porc_grupo_f1,0)%><strong>%</strong></th>
										<th width="10%" nowrap><%=formatnumber(v_subtotal_f2,0)%></th>
										<th width="5%" nowrap><%=Round(v_porc_grupo_f2,0)%><strong>%</strong></th>
										<th width="10%" nowrap><%=formatnumber(v_subtotal_f3,0)%></th>
										<th width="5%" nowrap><%=Round(v_porc_grupo_f3,0)%><strong>%</strong></th>
										<th width="10%" nowrap><%=formatnumber(v_subtotal_f4,0)%></th>
										<th width="5%" nowrap><%=Round(v_porc_grupo_f4,0)%><strong>%</strong></th>
										<th width="10%" nowrap><%=formatnumber(v_subtotal_f5,0)%></th>
										<th width="5%" nowrap><%=Round(v_porc_grupo_f5,0)%><strong>%</strong></th>
										<th width="10%" nowrap><%=formatnumber(v_subtotal_f6,0)%></th>
										<th width="5%" nowrap><%=Round(v_porc_grupo_f6,0)%><strong>%</strong></th>
										<th width="10%" nowrap><%=formatnumber(v_subtotal_f7,0)%></th>
										<th width="5%" nowrap><%=Round(v_porc_grupo_f7,0)%><strong>%</strong></th>
									</tr>
								<!-- INICIO totalizado de RESULTADO OPERACIONAL-->
									<tr><th colspan="15" height="5"></th>
									<tr bordercolor='#999999' bgcolor="#FFFFCC" align="right">	
										<th align="left"><strong>RESULTADO OPERACIONAL</strong></th>
										<th width="4%" nowrap><%=formatnumber(v_operacional_f1,0)%></th>
										<th width="7%" nowrap><%=Round(v_porc_operacional_f1,0)%><strong>%</strong></th>
										<th width="4%" nowrap><%=formatnumber(v_operacional_f2,0)%></th>
										<th width="12%" nowrap><%=Round(v_porc_operacional_f2,0)%><strong>%</strong></th>
										<th width="9%" nowrap><%=formatnumber(v_operacional_f3,0)%></th>
										<th width="10%" nowrap><%=Round(v_porc_operacional_f3,0)%><strong>%</strong></th>
										<th width="13%" nowrap><%=formatnumber(v_operacional_f4,0)%></th>
										<th width="3%" nowrap><%=Round(v_porc_operacional_f4,0)%><strong>%</strong></th>
										<th width="4%" nowrap><%=formatnumber(v_operacional_f5,0)%></th>
										<th width="7%" nowrap><%=Round(v_porc_operacional_f5,0)%><strong>%</strong></th>
										<th width="4%" nowrap><%=formatnumber(v_operacional_f6,0)%></th>
										<th width="12%" nowrap><%=Round(v_porc_operacional_f6,0)%><strong>%</strong></th>
										<th width="9%" nowrap><%=formatnumber(v_operacional_f7,0)%></th>
										<th width="10%" nowrap><%=Round(v_porc_operacional_f7,0)%><strong>%</strong></th>
									</tr>
									<tr><th colspan="15" height="10"></th>									
								<%
								
								v_subtotal_f1	= 0
								v_subtotal_f2	= 0
								v_subtotal_f3	= 0
								v_subtotal_f4 	= 0
								v_subtotal_f5	= 0
								v_subtotal_f6	= 0
								v_subtotal_f7	= 0

								while f_gasto_administracion.Siguiente
										descripcion_grupo= f_gasto_administracion.ObtenerValor("descripcion_grupo")
								
										v_porcentaje_f1	= (CDBL(f_gasto_administracion.ObtenerValor("f1"))*100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_gasto_administracion.ObtenerValor("f2"))*100)/CDBL(v_total_f2)
										v_porcentaje_f3	= (CDBL(f_gasto_administracion.ObtenerValor("f3"))*100)/CDBL(v_total_f3)
										v_porcentaje_f4	= (CDBL(f_gasto_administracion.ObtenerValor("f4"))*100)/CDBL(v_total_f4)
										v_porcentaje_f5	= (CDBL(f_gasto_administracion.ObtenerValor("f5"))*100)/CDBL(v_total_f5)
										v_porcentaje_f6	= (CDBL(f_gasto_administracion.ObtenerValor("f6"))*100)/CDBL(v_total_f6)
										v_porcentaje_f7	= (CDBL(f_gasto_administracion.ObtenerValor("f7"))*100)/CDBL(v_total_f7)
									
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_gasto_administracion.ObtenerValor("f1")))
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_gasto_administracion.ObtenerValor("f2")))
										v_subtotal_f3	= v_subtotal_f3 + (CDBL(f_gasto_administracion.ObtenerValor("f3")))
										v_subtotal_f4	= v_subtotal_f4 + (CDBL(f_gasto_administracion.ObtenerValor("f4")))
										v_subtotal_f5	= v_subtotal_f5 + (CDBL(f_gasto_administracion.ObtenerValor("f5")))
										v_subtotal_f6	= v_subtotal_f6 + (CDBL(f_gasto_administracion.ObtenerValor("f6")))
										v_subtotal_f7	= v_subtotal_f7 + (CDBL(f_gasto_administracion.ObtenerValor("f7")))
								
								%>							
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_gasto_administracion.DibujaCampo("descripcion")%></td>
											<td width="4%" nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f1")),0)%></td>
											<td width="7%" nowrap><%=Round(v_porcentaje_f1,0)%><strong>%</strong></td>
   											<td width="4%" nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f2")),0)%></td>
											<td width="12%" nowrap><%=Round(v_porcentaje_f2,0)%><strong>%</strong></td>
											<td width="9%" nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f3")),0)%></td>
											<td width="10%" nowrap><%=Round(v_porcentaje_f3,0)%><strong>%</strong></td>
											<td width="13%" nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f4")),0)%></td>
											<td width="3%" nowrap><%=Round(v_porcentaje_f4,0)%><strong>%</strong></td>
											<td width="4%" nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f5")),0)%></td>
											<td width="7%" nowrap><%=Round(v_porcentaje_f5,0)%><strong>%</strong></td>
   											<td width="4%" nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f6")),0)%></td>
											<td width="12%" nowrap><%=Round(v_porcentaje_f6,0)%><strong>%</strong></td>
											<td width="9%" nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f7")),0)%></td>
											<td width="10%" nowrap><%=Round(v_porcentaje_f7,0)%><strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
									v_porc_grupo_f1	= (CDBL(v_subtotal_f1)*100)/CDBL(v_total_f1)
									v_porc_grupo_f2	= (CDBL(v_subtotal_f2)*100)/CDBL(v_total_f2)
									v_porc_grupo_f3	= (CDBL(v_subtotal_f3)*100)/CDBL(v_total_f3)
									v_porc_grupo_f4	= (CDBL(v_subtotal_f4)*100)/CDBL(v_total_f4)
									v_porc_grupo_f5	= (CDBL(v_subtotal_f5)*100)/CDBL(v_total_f5)
									v_porc_grupo_f6	= (CDBL(v_subtotal_f6)*100)/CDBL(v_total_f6)
									v_porc_grupo_f7	= (CDBL(v_subtotal_f7)*100)/CDBL(v_total_f7)

									'*** Subtotal Acumulado (C-D)=E ***
									v_adm_f1 	= CDBL(v_operacional_f1)-CDBL(v_subtotal_f1)
									v_adm_f2 	= CDBL(v_operacional_f2)-CDBL(v_subtotal_f2)	
									v_adm_f3 	= CDBL(v_operacional_f3)-CDBL(v_subtotal_f3)	
									v_adm_f4 	= CDBL(v_operacional_f4)-CDBL(v_subtotal_f4)
									v_adm_f5 	= CDBL(v_operacional_f5)-CDBL(v_subtotal_f5)
									v_adm_f6 	= CDBL(v_operacional_f6)-CDBL(v_subtotal_f6)	
									v_adm_f7 	= CDBL(v_operacional_f7)-CDBL(v_subtotal_f7)	
									
									v_porc_adm_f1	= (CDBL(v_adm_f1)*100)/CDBL(v_total_f1)
									v_porc_adm_f2	= (CDBL(v_adm_f2)*100)/CDBL(v_total_f2)
									v_porc_adm_f3	= (CDBL(v_adm_f3)*100)/CDBL(v_total_f3)
									v_porc_adm_f4	= (CDBL(v_adm_f4)*100)/CDBL(v_total_f4)
									v_porc_adm_f5	= (CDBL(v_adm_f5)*100)/CDBL(v_total_f5)
									v_porc_adm_f6	= (CDBL(v_adm_f6)*100)/CDBL(v_total_f6)
									v_porc_adm_f7	= (CDBL(v_adm_f7)*100)/CDBL(v_total_f7)
								%>
								<!-- INICIO sub total de grupos -->
									<tr bordercolor='#999999' align="right">	
										<th width="25%" align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th width="10%" nowrap><%=formatnumber(v_subtotal_f1,0)%></th>
										<th width="5%" nowrap><%=Round(v_porc_grupo_f1,0)%><strong>%</strong></th>
										<th width="10%" nowrap><%=formatnumber(v_subtotal_f2,0)%></th>
										<th width="5%" nowrap><%=Round(v_porc_grupo_f2,0)%><strong>%</strong></th>
										<th width="10%" nowrap><%=formatnumber(v_subtotal_f3,0)%></th>
										<th width="5%" nowrap><%=Round(v_porc_grupo_f3,0)%><strong>%</strong></th>
										<th width="10%" nowrap><%=formatnumber(v_subtotal_f4,0)%></th>
										<th width="5%" nowrap><%=Round(v_porc_grupo_f4,0)%><strong>%</strong></th>
										<th width="10%" nowrap><%=formatnumber(v_subtotal_f5,0)%></th>
										<th width="5%" nowrap><%=Round(v_porc_grupo_f5,0)%><strong>%</strong></th>
										<th width="10%" nowrap><%=formatnumber(v_subtotal_f6,0)%></th>
										<th width="5%" nowrap><%=Round(v_porc_grupo_f6,0)%><strong>%</strong></th>
										<th width="10%" nowrap><%=formatnumber(v_subtotal_f7,0)%></th>
										<th width="5%" nowrap><%=Round(v_porc_grupo_f7,0)%><strong>%</strong></th>
									</tr>
								<!-- INICIO totalizado de RESULTADO OPERACIONAL-->
									<tr><th colspan="15" height="5"></th>
									<tr bordercolor='#999999' bgcolor="#FFFFCC" align="right">	
										<th align="left"><strong>RESULTADO</strong></th>
										<th width="4%" nowrap><%=formatnumber(v_adm_f1,0)%></th>
										<th width="7%" nowrap><%=Round(v_porc_adm_f1,0)%><strong>%</strong></th>
										<th width="4%" nowrap><%=formatnumber(v_adm_f2,0)%></th>
										<th width="12%" nowrap><%=Round(v_porc_adm_f2,0)%><strong>%</strong></th>
										<th width="9%" nowrap><%=formatnumber(v_adm_f3,0)%></th>
										<th width="10%" nowrap><%=Round(v_porc_adm_f3,0)%><strong>%</strong></th>
										<th width="13%" nowrap><%=formatnumber(v_adm_f4,0)%></th>
										<th width="3%" nowrap><%=Round(v_porc_adm_f4,0)%><strong>%</strong></th>
										<th width="4%" nowrap><%=formatnumber(v_adm_f5,0)%></th>
										<th width="7%" nowrap><%=Round(v_porc_adm_f5,0)%><strong>%</strong></th>
										<th width="4%" nowrap><%=formatnumber(v_adm_f6,0)%></th>
										<th width="12%" nowrap><%=Round(v_porc_adm_f6,0)%><strong>%</strong></th>
										<th width="9%" nowrap><%=formatnumber(v_adm_f7,0)%></th>
										<th width="10%" nowrap><%=Round(v_porc_adm_f7,0)%><strong>%</strong></th>
									</tr>
									<tr><th colspan="15" height="10"></th>
								 <%
								 
									v_subtotal_f1	= 0
									v_subtotal_f2	= 0
									v_subtotal_f3	= 0
									v_subtotal_f4 	= 0
									v_subtotal_f5	= 0
									v_subtotal_f6	= 0
									v_subtotal_f7	= 0
										
								 while f_gasto_indirecto.Siguiente
								 		descripcion_grupo= f_gasto_indirecto.ObtenerValor("descripcion_grupo")
								 
										v_porcentaje_f1	= (CDBL(f_gasto_indirecto.ObtenerValor("f1"))*100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_gasto_indirecto.ObtenerValor("f2"))*100)/CDBL(v_total_f2)
										v_porcentaje_f3	= (CDBL(f_gasto_indirecto.ObtenerValor("f3"))*100)/CDBL(v_total_f3)
										v_porcentaje_f4	= (CDBL(f_gasto_indirecto.ObtenerValor("f4"))*100)/CDBL(v_total_f4)
										v_porcentaje_f5	= (CDBL(f_gasto_indirecto.ObtenerValor("f5"))*100)/CDBL(v_total_f5)
										v_porcentaje_f6	= (CDBL(f_gasto_indirecto.ObtenerValor("f6"))*100)/CDBL(v_total_f6)
										v_porcentaje_f7	= (CDBL(f_gasto_indirecto.ObtenerValor("f7"))*100)/CDBL(v_total_f7)
																				
									
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_gasto_indirecto.ObtenerValor("f1")))
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_gasto_indirecto.ObtenerValor("f2")))
										v_subtotal_f3	= v_subtotal_f3 + (CDBL(f_gasto_indirecto.ObtenerValor("f3")))
										v_subtotal_f4	= v_subtotal_f4 + (CDBL(f_gasto_indirecto.ObtenerValor("f4")))
										v_subtotal_f5	= v_subtotal_f5 + (CDBL(f_gasto_indirecto.ObtenerValor("f5")))
										v_subtotal_f6	= v_subtotal_f6 + (CDBL(f_gasto_indirecto.ObtenerValor("f6")))
										v_subtotal_f7	= v_subtotal_f7 + (CDBL(f_gasto_indirecto.ObtenerValor("f7")))
								%>
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_gasto_indirecto.DibujaCampo("descripcion")%></td>
											<td width="4%"><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f1")),0)%></td>
											<td width="7%"><%=Round(v_porcentaje_f1,0)%><strong>%</strong></td>
   											<td width="4%"><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f2")),0)%></td>
											<td width="12%"><%=Round(v_porcentaje_f2,0)%><strong>%</strong></td>
											<td width="9%"><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f3")),0)%></td>
											<td width="10%"><%=Round(v_porcentaje_f3,0)%><strong>%</strong></td>
											<td width="13%"><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f4")),0)%></td>
											<td width="3%"><%=Round(v_porcentaje_f4,0)%><strong>%</strong></td>
											<td width="4%"><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f5")),0)%></td>
											<td width="7%"><%=Round(v_porcentaje_f5,0)%><strong>%</strong></td>
   											<td width="4%"><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f6")),0)%></td>
											<td width="12%"><%=Round(v_porcentaje_f6,0)%><strong>%</strong></td>
											<td width="9%"><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f7")),0)%></td>
											<td width="10%"><%=Round(v_porcentaje_f7,0)%><strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
								
								
									v_porc_grupo_f1	= (CDBL(v_subtotal_f1)*100)/CDBL(v_total_f1)
									v_porc_grupo_f2	= (CDBL(v_subtotal_f2)*100)/CDBL(v_total_f2)
									v_porc_grupo_f3	= (CDBL(v_subtotal_f3)*100)/CDBL(v_total_f3)
									v_porc_grupo_f4	= (CDBL(v_subtotal_f4)*100)/CDBL(v_total_f4)
									v_porc_grupo_f5	= (CDBL(v_subtotal_f5)*100)/CDBL(v_total_f5)
									v_porc_grupo_f6	= (CDBL(v_subtotal_f6)*100)/CDBL(v_total_f6)
									v_porc_grupo_f7	= (CDBL(v_subtotal_f7)*100)/CDBL(v_total_f7)
								
								%>
								<!-- INICIO sub total de grupos -->
									<tr bordercolor='#999999' align="right">	
										<th width="25%" align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th width="10%"><%=formatnumber(v_subtotal_f1,0)%></th>
										<th width="5%"><%=Round(v_porc_grupo_f1,0)%><strong>%</strong></th>
										<th width="10%"><%=formatnumber(v_subtotal_f2,0)%></th>
										<th width="5%"><%=Round(v_porc_grupo_f2,0)%><strong>%</strong></th>
										<th width="10%"><%=formatnumber(v_subtotal_f3,0)%></th>
										<th width="5%"><%=Round(v_porc_grupo_f3,0)%><strong>%</strong></th>
										<th width="10%"><%=formatnumber(v_subtotal_f4,0)%></th>
										<th width="5%"><%=Round(v_porc_grupo_f4,0)%><strong>%</strong></th>
										<th width="10%"><%=formatnumber(v_subtotal_f5,0)%></th>
										<th width="5%"><%=Round(v_porc_grupo_f5,0)%><strong>%</strong></th>
										<th width="10%"><%=formatnumber(v_subtotal_f6,0)%></th>
										<th width="5%"><%=Round(v_porc_grupo_f6,0)%><strong>%</strong></th>
										<th width="10%"><%=formatnumber(v_subtotal_f7,0)%></th>
										<th width="5%"><%=Round(v_porc_grupo_f7,0)%><strong>%</strong></th>
									</tr>
									<%
									'*** Subtotal Acumulado (E-F)=G ***
									v_resul_total_f1 	= CDBL(v_adm_f1)-CDBL(v_subtotal_f1)
									v_resul_total_f2 	= CDBL(v_adm_f2)-CDBL(v_subtotal_f2)	
									v_resul_total_f3 	= CDBL(v_adm_f3)-CDBL(v_subtotal_f3)	
									v_resul_total_f4 	= CDBL(v_adm_f4)-CDBL(v_subtotal_f4)
									v_resul_total_f5 	= CDBL(v_adm_f5)-CDBL(v_subtotal_f5)
									v_resul_total_f6 	= CDBL(v_adm_f6)-CDBL(v_subtotal_f6)	
									v_resul_total_f7 	= CDBL(v_adm_f7)-CDBL(v_subtotal_f7)	
									
									v_porc_total_f1	= (CDBL(v_resul_total_f1)*100)/CDBL(v_total_f1)
									v_porc_total_f2	= (CDBL(v_resul_total_f2)*100)/CDBL(v_total_f2)
									v_porc_total_f3	= (CDBL(v_resul_total_f3)*100)/CDBL(v_total_f3)
									v_porc_total_f4	= (CDBL(v_resul_total_f4)*100)/CDBL(v_total_f4)
									v_porc_total_f5	= (CDBL(v_resul_total_f5)*100)/CDBL(v_total_f5)
									v_porc_total_f6	= (CDBL(v_resul_total_f6)*100)/CDBL(v_total_f6)
									v_porc_total_f7	= (CDBL(v_resul_total_f7)*100)/CDBL(v_total_f7)
								
									%>
								 <tr><th colspan="15" height="5"></th>
								 <tr bordercolor='#999999'  bgcolor="#FFFFCC" align="right">
								 	<td align="left"><b>RESULTADO TOTAL</b></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f1,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f1,0)%></b><strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f2,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f2,0)%></b><strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f3,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f3,0)%></b><strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f4,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f4,0)%></b><strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f5,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f5,0)%></b><strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f6,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f6,0)%></b><strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f7,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f7,0)%></b><strong>%</strong></td>
								 </tr>
                              </table>
<%
							
							case 4 'FACULTAD DE CIENCIAS HUMANAS Y EDUCACION
%>

<table width="98%" border="0" align="center"  >
                                <tr  bgcolor='#C4D7FF' bordercolor='#999999' > 
                                  <th align="left">TIPO</th>
                                  <th colspan="2" align="center">ESCUELA DE EDUCACION BASICA</th>
                                  <th colspan="2" align="center">ESCUELA DE EDUCACION PARVULARIA</th>
                                  <th colspan="2" align="center">ESCUELA DE GESTION SOCIAL E INTEGRACION DEL ADULTO MAYOR</th>
								  <th colspan="2" align="center">ESCUELA DE PSICOLOGIA</th>
                                  <th colspan="2" align="center">ESCUELA DE TRABAJO SOCIAL</th>
                                  <th colspan="2" align="center">ESCUELA DE EDUCACION FISICA</th>
                                  <th colspan="2" align="center">ESCUELA DE PEDAGOGIA EN LENGUAJE</th>
								  <th colspan="2" align="center">ESCUELA DE PEDAGOGIA EN HISTORIA</th>
                                </tr>
								<%
								v_grupo=1
								v_subtotal_f1	= 0
								v_subtotal_f2	= 0
								v_subtotal_f3	= 0
								v_subtotal_f4 	= 0
								v_subtotal_f5	= 0
								v_subtotal_f6	= 0
								v_subtotal_f7	= 0
								v_subtotal_f8 	= 0
								
								while f_ingreso.Siguiente
										descripcion_grupo= f_ingreso.ObtenerValor("descripcion_grupo")

										v_porcentaje_f1	= (CDBL(f_ingreso.ObtenerValor("f1"))*-100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_ingreso.ObtenerValor("f2"))*-100)/CDBL(v_total_f2)
										v_porcentaje_f3	= (CDBL(f_ingreso.ObtenerValor("f3"))*-100)/CDBL(v_total_f3)
										v_porcentaje_f4	= (CDBL(f_ingreso.ObtenerValor("f4"))*-100)/CDBL(v_total_f4)
										v_porcentaje_f5	= (CDBL(f_ingreso.ObtenerValor("f5"))*-100)/CDBL(v_total_f5)
										v_porcentaje_f6	= (CDBL(f_ingreso.ObtenerValor("f6"))*-100)/CDBL(v_total_f6)
										v_porcentaje_f7	= (CDBL(f_ingreso.ObtenerValor("f7"))*-100)/CDBL(v_total_f7)
										v_porcentaje_f8	= (CDBL(f_ingreso.ObtenerValor("f8"))*-100)/CDBL(v_total_f8)
									
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_ingreso.ObtenerValor("f1"))*-1)
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_ingreso.ObtenerValor("f2"))*-1)
										v_subtotal_f3	= v_subtotal_f3 + (CDBL(f_ingreso.ObtenerValor("f3"))*-1)
										v_subtotal_f4	= v_subtotal_f4 + (CDBL(f_ingreso.ObtenerValor("f4"))*-1)
										v_subtotal_f5	= v_subtotal_f5 + (CDBL(f_ingreso.ObtenerValor("f5"))*-1)
										v_subtotal_f6	= v_subtotal_f6 + (CDBL(f_ingreso.ObtenerValor("f6"))*-1)
										v_subtotal_f7	= v_subtotal_f7 + (CDBL(f_ingreso.ObtenerValor("f7"))*-1)
										v_subtotal_f8	= v_subtotal_f8 + (CDBL(f_ingreso.ObtenerValor("f8"))*-1)
								%>
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_ingreso.DibujaCampo("descripcion")%></td>
											<td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f1"))*-1,0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f1,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f2"))*-1,0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f2,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f3"))*-1,0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f3,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f4"))*-1,0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f4,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f5"))*-1,0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f5,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f6"))*-1,0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f6,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f7"))*-1,0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f7,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f8"))*-1,0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f8,0)%><strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
								%>
								<!-- INICIO sub total de grupos -->
									<tr bordercolor='#999999' align="right">	
									  <th align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th nowrap><%=formatnumber(v_subtotal_f1,0)%></th>
										<th nowrap></th>
									  <th nowrap><%=formatnumber(v_subtotal_f2,0)%></th>
										<th nowrap></th>
									  <th nowrap><%=formatnumber(v_subtotal_f3,0)%></th>
										<th nowrap></th>
									  <th nowrap><%=formatnumber(v_subtotal_f4,0)%></th>
										<th nowrap></th>
									  <th nowrap><%=formatnumber(v_subtotal_f5,0)%></th>
										<th nowrap></th>
									  <th nowrap><%=formatnumber(v_subtotal_f6,0)%></th>
										<th nowrap></th>
									  <th nowrap><%=formatnumber(v_subtotal_f7,0)%></th>
										<th nowrap></th>
									  <th nowrap><%=formatnumber(v_subtotal_f8,0)%></th>
										<th nowrap></th>
									</tr>
								<%

								v_subtotal_f1	= 0
								v_subtotal_f2	= 0
								v_subtotal_f3	= 0
								v_subtotal_f4 	= 0
								v_subtotal_f5	= 0
								v_subtotal_f6	= 0
								v_subtotal_f7	= 0
								v_subtotal_f8 	= 0
															
								while f_costo_operacional.Siguiente
										descripcion_grupo= f_costo_operacional.ObtenerValor("descripcion_grupo")
								
										v_porcentaje_f1	= (CDBL(f_costo_operacional.ObtenerValor("f1"))*100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_costo_operacional.ObtenerValor("f2"))*100)/CDBL(v_total_f2)
										v_porcentaje_f3	= (CDBL(f_costo_operacional.ObtenerValor("f3"))*100)/CDBL(v_total_f3)
										v_porcentaje_f4	= (CDBL(f_costo_operacional.ObtenerValor("f4"))*100)/CDBL(v_total_f4)
										v_porcentaje_f5	= (CDBL(f_costo_operacional.ObtenerValor("f5"))*100)/CDBL(v_total_f5)
										v_porcentaje_f6	= (CDBL(f_costo_operacional.ObtenerValor("f6"))*100)/CDBL(v_total_f6)
										v_porcentaje_f7	= (CDBL(f_costo_operacional.ObtenerValor("f7"))*100)/CDBL(v_total_f7)
										v_porcentaje_f8	= (CDBL(f_costo_operacional.ObtenerValor("f8"))*100)/CDBL(v_total_f8)
									
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_costo_operacional.ObtenerValor("f1")))
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_costo_operacional.ObtenerValor("f2")))
										v_subtotal_f3	= v_subtotal_f3 + (CDBL(f_costo_operacional.ObtenerValor("f3")))
										v_subtotal_f4	= v_subtotal_f4 + (CDBL(f_costo_operacional.ObtenerValor("f4")))
										v_subtotal_f5	= v_subtotal_f5 + (CDBL(f_costo_operacional.ObtenerValor("f5")))
										v_subtotal_f6	= v_subtotal_f6 + (CDBL(f_costo_operacional.ObtenerValor("f6")))
										v_subtotal_f7	= v_subtotal_f7 + (CDBL(f_costo_operacional.ObtenerValor("f7")))
										v_subtotal_f8	= v_subtotal_f8 + (CDBL(f_costo_operacional.ObtenerValor("f8")))
								
								%>							
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_costo_operacional.DibujaCampo("descripcion")%></td>
											<td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f1")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f1,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f2")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f2,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f3")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f3,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f4")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f4,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f5")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f5,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f6")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f6,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f7")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f7,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f8")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f8,0)%><strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
								
									v_porc_grupo_f1	= (CDBL(v_subtotal_f1)*100)/CDBL(v_total_f1)
									v_porc_grupo_f2	= (CDBL(v_subtotal_f2)*100)/CDBL(v_total_f2)
									v_porc_grupo_f3	= (CDBL(v_subtotal_f3)*100)/CDBL(v_total_f3)
									v_porc_grupo_f4	= (CDBL(v_subtotal_f4)*100)/CDBL(v_total_f4)
									v_porc_grupo_f5	= (CDBL(v_subtotal_f5)*100)/CDBL(v_total_f5)
									v_porc_grupo_f6	= (CDBL(v_subtotal_f6)*100)/CDBL(v_total_f6)
									v_porc_grupo_f7	= (CDBL(v_subtotal_f7)*100)/CDBL(v_total_f7)
									v_porc_grupo_f8	= (CDBL(v_subtotal_f8)*100)/CDBL(v_total_f8)
									
									'*** Subtotal Acumulado (A-B)=C ***
									v_operacional_f1 	= CDBL(v_total_f1)-CDBL(v_subtotal_f1)
									v_operacional_f2 	= CDBL(v_total_f2)-CDBL(v_subtotal_f2)	
									v_operacional_f3 	= CDBL(v_total_f3)-CDBL(v_subtotal_f3)	
									v_operacional_f4 	= CDBL(v_total_f4)-CDBL(v_subtotal_f4)
									v_operacional_f5 	= CDBL(v_total_f5)-CDBL(v_subtotal_f5)
									v_operacional_f6 	= CDBL(v_total_f6)-CDBL(v_subtotal_f6)	
									v_operacional_f7 	= CDBL(v_total_f7)-CDBL(v_subtotal_f7)	
									v_operacional_f8 	= CDBL(v_total_f8)-CDBL(v_subtotal_f8)
									
									v_porc_operacional_f1	= (CDBL(v_operacional_f1)*100)/CDBL(v_total_f1)
									v_porc_operacional_f2	= (CDBL(v_operacional_f2)*100)/CDBL(v_total_f2)
									v_porc_operacional_f3	= (CDBL(v_operacional_f3)*100)/CDBL(v_total_f3)
									v_porc_operacional_f4	= (CDBL(v_operacional_f4)*100)/CDBL(v_total_f4)
									v_porc_operacional_f5	= (CDBL(v_operacional_f5)*100)/CDBL(v_total_f5)
									v_porc_operacional_f6	= (CDBL(v_operacional_f6)*100)/CDBL(v_total_f6)
									v_porc_operacional_f7	= (CDBL(v_operacional_f7)*100)/CDBL(v_total_f7)
									v_porc_operacional_f8	= (CDBL(v_operacional_f8)*100)/CDBL(v_total_f8)
								%>
								<!-- INICIO sub total de grupo -->
									<tr bordercolor='#999999' align="right">	
									  <th align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th nowrap><%=formatnumber(v_subtotal_f1,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f1,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f2,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f2,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f3,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f3,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f4,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f4,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f5,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f5,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f6,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f6,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f7,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f7,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f8,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f8,0)%><strong>%</strong></th>
									</tr>
								<!-- INICIO totalizado de RESULTADO OPERACIONAL-->
									<tr><th colspan="17" height="5"></th>
									<tr bordercolor='#999999' bgcolor="#FFFFCC" align="right">	
										<th align="left"><strong>RESULTADO OPERACIONAL</strong></th>
										<th nowrap><%=formatnumber(v_operacional_f1,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_f1,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_operacional_f2,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_f2,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_operacional_f3,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_f3,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_operacional_f4,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_f4,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_operacional_f5,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_f5,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_operacional_f6,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_f6,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_operacional_f7,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_f7,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_operacional_f8,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_f8,0)%><strong>%</strong></th>
									</tr>
									<tr><th colspan="17" height="10"></th>
								<%
								
								v_subtotal_f1	= 0
								v_subtotal_f2	= 0
								v_subtotal_f3	= 0
								v_subtotal_f4 	= 0
								v_subtotal_f5	= 0
								v_subtotal_f6	= 0
								v_subtotal_f7	= 0
								v_subtotal_f8 	= 0

								while f_gasto_administracion.Siguiente
										descripcion_grupo= f_gasto_administracion.ObtenerValor("descripcion_grupo")
								
										v_porcentaje_f1	= (CDBL(f_gasto_administracion.ObtenerValor("f1"))*100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_gasto_administracion.ObtenerValor("f2"))*100)/CDBL(v_total_f2)
										v_porcentaje_f3	= (CDBL(f_gasto_administracion.ObtenerValor("f3"))*100)/CDBL(v_total_f3)
										v_porcentaje_f4	= (CDBL(f_gasto_administracion.ObtenerValor("f4"))*100)/CDBL(v_total_f4)
										v_porcentaje_f5	= (CDBL(f_gasto_administracion.ObtenerValor("f5"))*100)/CDBL(v_total_f5)
										v_porcentaje_f6	= (CDBL(f_gasto_administracion.ObtenerValor("f6"))*100)/CDBL(v_total_f6)
										v_porcentaje_f7	= (CDBL(f_gasto_administracion.ObtenerValor("f7"))*100)/CDBL(v_total_f7)
										v_porcentaje_f8	= (CDBL(f_gasto_administracion.ObtenerValor("f8"))*100)/CDBL(v_total_f8)
																				
									
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_gasto_administracion.ObtenerValor("f1")))
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_gasto_administracion.ObtenerValor("f2")))
										v_subtotal_f3	= v_subtotal_f3 + (CDBL(f_gasto_administracion.ObtenerValor("f3")))
										v_subtotal_f4	= v_subtotal_f4 + (CDBL(f_gasto_administracion.ObtenerValor("f4")))
										v_subtotal_f5	= v_subtotal_f5 + (CDBL(f_gasto_administracion.ObtenerValor("f5")))
										v_subtotal_f6	= v_subtotal_f6 + (CDBL(f_gasto_administracion.ObtenerValor("f6")))
										v_subtotal_f7	= v_subtotal_f7 + (CDBL(f_gasto_administracion.ObtenerValor("f7")))
										v_subtotal_f8	= v_subtotal_f8 + (CDBL(f_gasto_administracion.ObtenerValor("f8")))
								
								%>							
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_gasto_administracion.DibujaCampo("descripcion")%></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f1")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f1,0)%><strong>%</strong></td>
   											<td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f2")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f2,0)%><strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f3")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f3,0)%><strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f4")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f4,0)%><strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f5")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f5,0)%><strong>%</strong></td>
   											<td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f6")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f6,0)%><strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f7")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f7,0)%><strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f8")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f8,0)%><strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
									v_porc_grupo_f1	= (CDBL(v_subtotal_f1)*100)/CDBL(v_total_f1)
									v_porc_grupo_f2	= (CDBL(v_subtotal_f2)*100)/CDBL(v_total_f2)
									v_porc_grupo_f3	= (CDBL(v_subtotal_f3)*100)/CDBL(v_total_f3)
									v_porc_grupo_f4	= (CDBL(v_subtotal_f4)*100)/CDBL(v_total_f4)
									v_porc_grupo_f5	= (CDBL(v_subtotal_f5)*100)/CDBL(v_total_f5)
									v_porc_grupo_f6	= (CDBL(v_subtotal_f6)*100)/CDBL(v_total_f6)
									v_porc_grupo_f7	= (CDBL(v_subtotal_f7)*100)/CDBL(v_total_f7)
									v_porc_grupo_f8	= (CDBL(v_subtotal_f8)*100)/CDBL(v_total_f8)

									'*** Subtotal Acumulado (C-D)=E ***
									v_adm_f1 	= CDBL(v_operacional_f1)-CDBL(v_subtotal_f1)
									v_adm_f2 	= CDBL(v_operacional_f2)-CDBL(v_subtotal_f2)	
									v_adm_f3 	= CDBL(v_operacional_f3)-CDBL(v_subtotal_f3)	
									v_adm_f4 	= CDBL(v_operacional_f4)-CDBL(v_subtotal_f4)
									v_adm_f5 	= CDBL(v_operacional_f5)-CDBL(v_subtotal_f5)
									v_adm_f6 	= CDBL(v_operacional_f6)-CDBL(v_subtotal_f6)	
									v_adm_f7 	= CDBL(v_operacional_f7)-CDBL(v_subtotal_f7)	
									v_adm_f8 	= CDBL(v_operacional_f8)-CDBL(v_subtotal_f8)
									
									v_porc_adm_f1	= (CDBL(v_adm_f1)*100)/CDBL(v_total_f1)
									v_porc_adm_f2	= (CDBL(v_adm_f2)*100)/CDBL(v_total_f2)
									v_porc_adm_f3	= (CDBL(v_adm_f3)*100)/CDBL(v_total_f3)
									v_porc_adm_f4	= (CDBL(v_adm_f4)*100)/CDBL(v_total_f4)
									v_porc_adm_f5	= (CDBL(v_adm_f5)*100)/CDBL(v_total_f5)
									v_porc_adm_f6	= (CDBL(v_adm_f6)*100)/CDBL(v_total_f6)
									v_porc_adm_f7	= (CDBL(v_adm_f7)*100)/CDBL(v_total_f7)
									v_porc_adm_f8	= (CDBL(v_adm_f8)*100)/CDBL(v_total_f8)
								%>
								<!-- INICIO sub total de grupos -->
									<tr bordercolor='#999999' align="right">	
										<th align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th nowrap><%=formatnumber(v_subtotal_f1,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f1,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f2,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f2,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f3,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f3,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f4,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f4,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f5,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f5,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f6,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f6,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f7,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f7,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f8,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f8,0)%><strong>%</strong></th>
									</tr>
								<!-- INICIO totalizado de RESULTADO OPERACIONAL-->
									<tr><th colspan="17" height="5"></th>
									<tr bordercolor='#999999' bgcolor="#FFFFCC" align="right">	
										<th align="left"><strong>RESULTADO</strong></th>
										<th nowrap><%=formatnumber(v_adm_f1,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f1,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_adm_f2,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f2,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_adm_f3,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f3,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_adm_f4,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f4,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_adm_f5,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f5,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_adm_f6,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f6,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_adm_f7,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f7,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_adm_f8,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f8,0)%><strong>%</strong></th>
									</tr>
									<tr><th colspan="17" height="10"></th>
								 <%
								 
									v_subtotal_f1	= 0
									v_subtotal_f2	= 0
									v_subtotal_f3	= 0
									v_subtotal_f4 	= 0
									v_subtotal_f5	= 0
									v_subtotal_f6	= 0
									v_subtotal_f7	= 0
									v_subtotal_f8 	= 0
										
								 while f_gasto_indirecto.Siguiente
								 		descripcion_grupo= f_gasto_indirecto.ObtenerValor("descripcion_grupo")
								 
										v_porcentaje_f1	= (CDBL(f_gasto_indirecto.ObtenerValor("f1"))*100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_gasto_indirecto.ObtenerValor("f2"))*100)/CDBL(v_total_f2)
										v_porcentaje_f3	= (CDBL(f_gasto_indirecto.ObtenerValor("f3"))*100)/CDBL(v_total_f3)
										v_porcentaje_f4	= (CDBL(f_gasto_indirecto.ObtenerValor("f4"))*100)/CDBL(v_total_f4)
										v_porcentaje_f5	= (CDBL(f_gasto_indirecto.ObtenerValor("f5"))*100)/CDBL(v_total_f5)
										v_porcentaje_f6	= (CDBL(f_gasto_indirecto.ObtenerValor("f6"))*100)/CDBL(v_total_f6)
										v_porcentaje_f7	= (CDBL(f_gasto_indirecto.ObtenerValor("f7"))*100)/CDBL(v_total_f7)
										v_porcentaje_f8	= (CDBL(f_gasto_indirecto.ObtenerValor("f8"))*100)/CDBL(v_total_f8)
									
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_gasto_indirecto.ObtenerValor("f1")))
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_gasto_indirecto.ObtenerValor("f2")))
										v_subtotal_f3	= v_subtotal_f3 + (CDBL(f_gasto_indirecto.ObtenerValor("f3")))
										v_subtotal_f4	= v_subtotal_f4 + (CDBL(f_gasto_indirecto.ObtenerValor("f4")))
										v_subtotal_f5	= v_subtotal_f5 + (CDBL(f_gasto_indirecto.ObtenerValor("f5")))
										v_subtotal_f6	= v_subtotal_f6 + (CDBL(f_gasto_indirecto.ObtenerValor("f6")))
										v_subtotal_f7	= v_subtotal_f7 + (CDBL(f_gasto_indirecto.ObtenerValor("f7")))
										v_subtotal_f8	= v_subtotal_f8 + (CDBL(f_gasto_indirecto.ObtenerValor("f8")))
								%>
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_gasto_indirecto.DibujaCampo("descripcion")%></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f1")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f1,0)%><strong>%</strong></td>
   											<td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f2")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f2,0)%><strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f3")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f3,0)%><strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f4")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f4,0)%><strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f5")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f5,0)%><strong>%</strong></td>
   											<td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f6")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f6,0)%><strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f7")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f7,0)%><strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f8")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f8,0)%><strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
								
								
									v_porc_grupo_f1	= (CDBL(v_subtotal_f1)*100)/CDBL(v_total_f1)
									v_porc_grupo_f2	= (CDBL(v_subtotal_f2)*100)/CDBL(v_total_f2)
									v_porc_grupo_f3	= (CDBL(v_subtotal_f3)*100)/CDBL(v_total_f3)
									v_porc_grupo_f4	= (CDBL(v_subtotal_f4)*100)/CDBL(v_total_f4)
									v_porc_grupo_f5	= (CDBL(v_subtotal_f5)*100)/CDBL(v_total_f5)
									v_porc_grupo_f6	= (CDBL(v_subtotal_f6)*100)/CDBL(v_total_f6)
									v_porc_grupo_f7	= (CDBL(v_subtotal_f7)*100)/CDBL(v_total_f7)
									v_porc_grupo_f8	= (CDBL(v_subtotal_f8)*100)/CDBL(v_total_f8)
								
								%>
								<!-- INICIO sub total de grupos -->
									<tr bordercolor='#999999' align="right">	
										<th align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th nowrap><%=formatnumber(v_subtotal_f1,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f1,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f2,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f2,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f3,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f3,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f4,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f4,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f5,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f5,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f6,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f6,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f7,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f7,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f8,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f8,0)%><strong>%</strong></th>
									</tr>
									<%
									'*** Subtotal Acumulado (E-F)=G ***
									v_resul_total_f1 	= CDBL(v_adm_f1)-CDBL(v_subtotal_f1)
									v_resul_total_f2 	= CDBL(v_adm_f2)-CDBL(v_subtotal_f2)	
									v_resul_total_f3 	= CDBL(v_adm_f3)-CDBL(v_subtotal_f3)	
									v_resul_total_f4 	= CDBL(v_adm_f4)-CDBL(v_subtotal_f4)
									v_resul_total_f5 	= CDBL(v_adm_f5)-CDBL(v_subtotal_f5)
									v_resul_total_f6 	= CDBL(v_adm_f6)-CDBL(v_subtotal_f6)	
									v_resul_total_f7 	= CDBL(v_adm_f7)-CDBL(v_subtotal_f7)	
									v_resul_total_f8 	= CDBL(v_adm_f8)-CDBL(v_subtotal_f8)
									
									v_porc_total_f1	= (CDBL(v_resul_total_f1)*100)/CDBL(v_total_f1)
									v_porc_total_f2	= (CDBL(v_resul_total_f2)*100)/CDBL(v_total_f2)
									v_porc_total_f3	= (CDBL(v_resul_total_f3)*100)/CDBL(v_total_f3)
									v_porc_total_f4	= (CDBL(v_resul_total_f4)*100)/CDBL(v_total_f4)
									v_porc_total_f5	= (CDBL(v_resul_total_f5)*100)/CDBL(v_total_f5)
									v_porc_total_f6	= (CDBL(v_resul_total_f6)*100)/CDBL(v_total_f6)
									v_porc_total_f7	= (CDBL(v_resul_total_f7)*100)/CDBL(v_total_f7)
									v_porc_total_f8	= (CDBL(v_resul_total_f8)*100)/CDBL(v_total_f8)
									
									%>
								 <tr><th colspan="17" height="5"></th>
								 <tr bordercolor='#999999'  bgcolor="#FFFFCC" align="right">
								 	<td align="left"><b>RESULTADO TOTAL</b></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f1,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f1,0)%></b><strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f2,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f2,0)%></b><strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f3,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f3,0)%></b><strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f4,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f4,0)%></b><strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f5,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f5,0)%></b><strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f6,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f6,0)%></b><strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f7,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f7,0)%></b><strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f8,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f8,0)%></b><strong>%</strong></td>
								 </tr>
                              </table>

<%
							case 5 'AREA CIENCIAS AGROPECUARIAS 
%>
					<table width="98%" border="0" align="center"  >
                                <tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
                                  <th>TIPO</th>
                                  <th colspan="2">ESCUELA DE AGRONOMIA</th>
                                  <th colspan="2">ESCUELA DE VETERINARIA</th>
                                </tr>
								<%
								v_grupo=1
								v_subtotal_f1	= 0
								v_subtotal_f2	= 0
								
								while f_ingreso.Siguiente
										descripcion_grupo= f_ingreso.ObtenerValor("descripcion_grupo")

										v_porcentaje_f1	= (CDBL(f_ingreso.ObtenerValor("f1"))*-100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_ingreso.ObtenerValor("f2"))*-100)/CDBL(v_total_f2)
																				
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_ingreso.ObtenerValor("f1"))*-1)
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_ingreso.ObtenerValor("f2"))*-1)
								%>
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_ingreso.DibujaCampo("descripcion")%></td>
								  <td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f1"))*-1,0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f1,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f2"))*-1,0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f2,0)%><strong>%</strong></td>
								</tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
								%>
								<!-- INICIO sub total de grupos -->
									<tr bordercolor='#999999' align="right">	
									  <th align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th nowrap><%=formatnumber(v_subtotal_f1,0)%></th>
									  <th nowrap></th>
										<th nowrap><%=formatnumber(v_subtotal_f2,0)%></th>
										<th nowrap></th>
									</tr>
								<%

								v_subtotal_f1	= 0
								v_subtotal_f2	= 0
															
								while f_costo_operacional.Siguiente
										descripcion_grupo= f_costo_operacional.ObtenerValor("descripcion_grupo")
								
										v_porcentaje_f1	= (CDBL(f_costo_operacional.ObtenerValor("f1"))*100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_costo_operacional.ObtenerValor("f2"))*100)/CDBL(v_total_f2)
									
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_costo_operacional.ObtenerValor("f1")))
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_costo_operacional.ObtenerValor("f2")))
								%>							
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_costo_operacional.DibujaCampo("descripcion")%></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f1")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f1,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f2")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f2,0)%><strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
								
									v_porc_grupo_f1	= (CDBL(v_subtotal_f1)*100)/CDBL(v_total_f1)
									v_porc_grupo_f2	= (CDBL(v_subtotal_f2)*100)/CDBL(v_total_f2)
									
									'*** Subtotal Acumulado (A-B)=C ***
									v_operacional_f1 	= CDBL(v_total_f1)-CDBL(v_subtotal_f1)
									v_operacional_f2 	= CDBL(v_total_f2)-CDBL(v_subtotal_f2)	
									
									v_porc_operacional_f1	= (CDBL(v_operacional_f1)*100)/CDBL(v_total_f1)
									v_porc_operacional_f2	= (CDBL(v_operacional_f2)*100)/CDBL(v_total_f2)
								
								%>
								<!-- INICIO sub total de grupo -->
									<tr bordercolor='#999999' align="right">	
									  <th align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th nowrap><%=formatnumber(v_subtotal_f1,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f1,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f2,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f2,0)%><strong>%</strong></th>
									</tr>
								<!-- INICIO totalizado de RESULTADO OPERACIONAL-->
									<tr><th colspan="5" height="5"></th>
									<tr bordercolor='#999999' bgcolor="#FFFFCC" align="right">	
										<th align="left"><strong>RESULTADO OPERACIONAL</strong></th>
										<th nowrap><%=formatnumber(v_operacional_f1,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_f1,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_operacional_f2,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_f2,0)%><strong>%</strong></th>
									</tr>
									<tr><th colspan="5" height="10"></th>
								<%
								
								v_subtotal_f1	= 0
								v_subtotal_f2	= 0

								while f_gasto_administracion.Siguiente
										descripcion_grupo= f_gasto_administracion.ObtenerValor("descripcion_grupo")
								
										v_porcentaje_f1	= (CDBL(f_gasto_administracion.ObtenerValor("f1"))*100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_gasto_administracion.ObtenerValor("f2"))*100)/CDBL(v_total_f2)
									
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_gasto_administracion.ObtenerValor("f1")))
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_gasto_administracion.ObtenerValor("f2")))
								
								%>							
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_gasto_administracion.DibujaCampo("descripcion")%></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f1")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f1,0)%><strong>%</strong></td>
   											<td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f2")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f2,0)%><strong>%</strong></td>
							</tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
									v_porc_grupo_f1	= (CDBL(v_subtotal_f1)*100)/CDBL(v_total_f1)
									v_porc_grupo_f2	= (CDBL(v_subtotal_f2)*100)/CDBL(v_total_f2)

									'*** Subtotal Acumulado (C-D)=E ***
									v_adm_f1 	= CDBL(v_operacional_f1)-CDBL(v_subtotal_f1)
									v_adm_f2 	= CDBL(v_operacional_f2)-CDBL(v_subtotal_f2)	
									
									v_porc_adm_f1	= (CDBL(v_adm_f1)*100)/CDBL(v_total_f1)
									v_porc_adm_f2	= (CDBL(v_adm_f2)*100)/CDBL(v_total_f2)
								%>
								<!-- INICIO sub total de grupos -->
									<tr bordercolor='#999999' align="right">	
										<th align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th nowrap><%=formatnumber(v_subtotal_f1,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f1,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f2,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f2,0)%><strong>%</strong></th>
									</tr>
								<!-- INICIO totalizado de RESULTADO OPERACIONAL-->
									<tr><th colspan="5" height="5"></th>
									<tr bordercolor='#999999' bgcolor="#FFFFCC" align="right">	
										<th align="left"><strong>RESULTADO</strong></th>
										<th nowrap><%=formatnumber(v_adm_f1,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f1,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_adm_f2,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f2,0)%><strong>%</strong></th>
									</tr>
									<tr><th colspan="5" height="10"></th>
								 <%
								 
									v_subtotal_f1	= 0
									v_subtotal_f2	= 0
										
								 while f_gasto_indirecto.Siguiente
								 		descripcion_grupo= f_gasto_indirecto.ObtenerValor("descripcion_grupo")
								 
										v_porcentaje_f1	= (CDBL(f_gasto_indirecto.ObtenerValor("f1"))*100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_gasto_indirecto.ObtenerValor("f2"))*100)/CDBL(v_total_f2)
									
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_gasto_indirecto.ObtenerValor("f1")))
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_gasto_indirecto.ObtenerValor("f2")))
								%>
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_gasto_indirecto.DibujaCampo("descripcion")%></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f1")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f1,0)%><strong>%</strong></td>
   											<td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f2")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f2,0)%><strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
									v_porc_grupo_f1	= (CDBL(v_subtotal_f1)*100)/CDBL(v_total_f1)
									v_porc_grupo_f2	= (CDBL(v_subtotal_f2)*100)/CDBL(v_total_f2)
								%>
								<!-- INICIO sub total de grupos -->
									<tr bordercolor='#999999' align="right">	
										<th align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th nowrap><%=formatnumber(v_subtotal_f1,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f1,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f2,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f2,0)%><strong>%</strong></th>
									</tr>
									<%
									'*** Subtotal Acumulado (E-F)=G ***
									v_resul_total_f1 	= CDBL(v_adm_f1)-CDBL(v_subtotal_f1)
									v_resul_total_f2 	= CDBL(v_adm_f2)-CDBL(v_subtotal_f2)	
									
									v_porc_total_f1	= (CDBL(v_resul_total_f1)*100)/CDBL(v_total_f1)
									v_porc_total_f2	= (CDBL(v_resul_total_f2)*100)/CDBL(v_total_f2)
									%>
								 <tr><th colspan="5" height="5"></th>
								 <tr bordercolor='#999999'  bgcolor="#FFFFCC" align="right">
								 	<td align="left"><b>RESULTADO TOTAL</b></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f1,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f1,0)%></b><strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f2,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f2,0)%></b><strong>%</strong></td>
								 </tr>
                              </table>

<%
							case 6 'AREA CIENCIAS Y SALUD
%>
<table width="98%" border="0" align="center"  >
                                <tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
                                  <th>TIPO</th>
                                  <th colspan="2">ESCUELA DE ENFERMERIA</th>
                                  <th colspan="2">ESCUELA DE NUTRICION Y DIETETICA</th>
                                </tr>
								<%
								v_grupo=1
								v_subtotal_f1	= 0
								v_subtotal_f2	= 0
								
								while f_ingreso.Siguiente
										descripcion_grupo= f_ingreso.ObtenerValor("descripcion_grupo")

										v_porcentaje_f1	= (CDBL(f_ingreso.ObtenerValor("f1"))*-100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_ingreso.ObtenerValor("f2"))*-100)/CDBL(v_total_f2)
																				
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_ingreso.ObtenerValor("f1"))*-1)
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_ingreso.ObtenerValor("f2"))*-1)
								%>
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_ingreso.DibujaCampo("descripcion")%></td>
								  <td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f1"))*-1,0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f1,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f2"))*-1,0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f2,0)%><strong>%</strong></td>
								</tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
								%>
								<!-- INICIO sub total de grupos -->
									<tr bordercolor='#999999' align="right">	
									  <th align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th nowrap><%=formatnumber(v_subtotal_f1,0)%></th>
									  <th nowrap></th>
										<th nowrap><%=formatnumber(v_subtotal_f2,0)%></th>
										<th nowrap></th>
									</tr>
								<%

								v_subtotal_f1	= 0
								v_subtotal_f2	= 0
															
								while f_costo_operacional.Siguiente
										descripcion_grupo= f_costo_operacional.ObtenerValor("descripcion_grupo")
								
										v_porcentaje_f1	= (CDBL(f_costo_operacional.ObtenerValor("f1"))*100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_costo_operacional.ObtenerValor("f2"))*100)/CDBL(v_total_f2)
									
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_costo_operacional.ObtenerValor("f1")))
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_costo_operacional.ObtenerValor("f2")))
								%>							
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_costo_operacional.DibujaCampo("descripcion")%></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f1")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f1,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f2")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f2,0)%><strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
								
									v_porc_grupo_f1	= (CDBL(v_subtotal_f1)*100)/CDBL(v_total_f1)
									v_porc_grupo_f2	= (CDBL(v_subtotal_f2)*100)/CDBL(v_total_f2)
									
									'*** Subtotal Acumulado (A-B)=C ***
									v_operacional_f1 	= CDBL(v_total_f1)-CDBL(v_subtotal_f1)
									v_operacional_f2 	= CDBL(v_total_f2)-CDBL(v_subtotal_f2)	
									
									v_porc_operacional_f1	= (CDBL(v_operacional_f1)*100)/CDBL(v_total_f1)
									v_porc_operacional_f2	= (CDBL(v_operacional_f2)*100)/CDBL(v_total_f2)
								
								%>
								<!-- INICIO sub total de grupo -->
									<tr bordercolor='#999999' align="right">	
									  <th align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th nowrap><%=formatnumber(v_subtotal_f1,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f1,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f2,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f2,0)%><strong>%</strong></th>
									</tr>
								<!-- INICIO totalizado de RESULTADO OPERACIONAL-->
									<tr><th colspan="5" height="5"></th>
									<tr bordercolor='#999999' bgcolor="#FFFFCC" align="right">	
										<th align="left"><strong>RESULTADO OPERACIONAL</strong></th>
										<th nowrap><%=formatnumber(v_operacional_f1,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_f1,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_operacional_f2,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_f2,0)%><strong>%</strong></th>
									</tr>
									<tr><th colspan="5" height="10"></th>
								<%
								
								v_subtotal_f1	= 0
								v_subtotal_f2	= 0

								while f_gasto_administracion.Siguiente
								
								 		descripcion_grupo= f_gasto_administracion.ObtenerValor("descripcion_grupo")
								
										v_porcentaje_f1	= (CDBL(f_gasto_administracion.ObtenerValor("f1"))*100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_gasto_administracion.ObtenerValor("f2"))*100)/CDBL(v_total_f2)
									
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_gasto_administracion.ObtenerValor("f1")))
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_gasto_administracion.ObtenerValor("f2")))
								
								%>							
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_gasto_administracion.DibujaCampo("descripcion")%></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f1")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f1,0)%><strong>%</strong></td>
   											<td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f2")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f2,0)%><strong>%</strong></td>
							</tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
									v_porc_grupo_f1	= (CDBL(v_subtotal_f1)*100)/CDBL(v_total_f1)
									v_porc_grupo_f2	= (CDBL(v_subtotal_f2)*100)/CDBL(v_total_f2)

									'*** Subtotal Acumulado (C-D)=E ***
									v_adm_f1 	= CDBL(v_operacional_f1)-CDBL(v_subtotal_f1)
									v_adm_f2 	= CDBL(v_operacional_f2)-CDBL(v_subtotal_f2)	
									
									v_porc_adm_f1	= (CDBL(v_adm_f1)*100)/CDBL(v_total_f1)
									v_porc_adm_f2	= (CDBL(v_adm_f2)*100)/CDBL(v_total_f2)
								%>
								<!-- INICIO sub total de grupos -->
									<tr bordercolor='#999999' align="right">	
										<th align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th nowrap><%=formatnumber(v_subtotal_f1,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f1,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f2,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f2,0)%><strong>%</strong></th>
									</tr>
								<!-- INICIO totalizado de RESULTADO OPERACIONAL-->
									<tr><th colspan="5" height="5"></th>
									<tr bordercolor='#999999' bgcolor="#FFFFCC" align="right">	
										<th align="left"><strong>RESULTADO</strong></th>
										<th nowrap><%=formatnumber(v_adm_f1,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f1,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_adm_f2,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f2,0)%><strong>%</strong></th>
									</tr>
									<tr><th colspan="5" height="10"></th>
								 <%
								 
									v_subtotal_f1	= 0
									v_subtotal_f2	= 0
										
								 while f_gasto_indirecto.Siguiente
								 		descripcion_grupo= f_gasto_indirecto.ObtenerValor("descripcion_grupo")
								 
										v_porcentaje_f1	= (CDBL(f_gasto_indirecto.ObtenerValor("f1"))*100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_gasto_indirecto.ObtenerValor("f2"))*100)/CDBL(v_total_f2)
									
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_gasto_indirecto.ObtenerValor("f1")))
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_gasto_indirecto.ObtenerValor("f2")))
								%>
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_gasto_indirecto.DibujaCampo("descripcion")%></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f1")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f1,0)%><strong>%</strong></td>
   											<td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f2")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f2,0)%><strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
									v_porc_grupo_f1	= (CDBL(v_subtotal_f1)*100)/CDBL(v_total_f1)
									v_porc_grupo_f2	= (CDBL(v_subtotal_f2)*100)/CDBL(v_total_f2)
								%>
								<!-- INICIO sub total de grupos -->
									<tr bordercolor='#999999' align="right">	
										<th align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th nowrap><%=formatnumber(v_subtotal_f1,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f1,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f2,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f2,0)%><strong>%</strong></th>
									</tr>
									<%
									'*** Subtotal Acumulado (E-F)=G ***
									v_resul_total_f1 	= CDBL(v_adm_f1)-CDBL(v_subtotal_f1)
									v_resul_total_f2 	= CDBL(v_adm_f2)-CDBL(v_subtotal_f2)	
									
									v_porc_total_f1	= (CDBL(v_resul_total_f1)*100)/CDBL(v_total_f1)
									v_porc_total_f2	= (CDBL(v_resul_total_f2)*100)/CDBL(v_total_f2)
									%>
								 <tr><th colspan="5" height="5"></th>
								 <tr bordercolor='#999999'  bgcolor="#FFFFCC" align="right">
								 	<td align="left"><b>RESULTADO TOTAL</b></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f1,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f1,0)%></b><strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f2,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f2,0)%></b><strong>%</strong></td>
								 </tr>
                              </table>
<%
							case  else ' Otras Areas
%>
<table width="98%" border="0" align="center"  >
                                <tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
                                  <th>TIPO</th>
                                  <th colspan="2">AREA TECNICA MELIPILLA</th>
                                  <th colspan="2">CENTRO DE COMPETITIVIDAD</th>
                                  <th colspan="2">ESCUELA DE INGENIERIA EN INFORMATICA</th>
								  <th colspan="2">EXTENSION</th>
                                  <th colspan="2">PROYECTOS</th>
                                </tr>
								<%
								v_grupo=1
								v_subtotal_f1	= 0
								v_subtotal_f2	= 0
								v_subtotal_f3	= 0
								v_subtotal_f4 	= 0
								v_subtotal_f5	= 0
								
								while f_ingreso.Siguiente
										descripcion_grupo= f_ingreso.ObtenerValor("descripcion_grupo")

										v_porcentaje_f1	= (CDBL(f_ingreso.ObtenerValor("f1"))*-100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_ingreso.ObtenerValor("f2"))*-100)/CDBL(v_total_f2)
										v_porcentaje_f3	= (CDBL(f_ingreso.ObtenerValor("f3"))*-100)/CDBL(v_total_f3)
										v_porcentaje_f4	= (CDBL(f_ingreso.ObtenerValor("f4"))*-100)/CDBL(v_total_f4)
										v_porcentaje_f5	= (CDBL(f_ingreso.ObtenerValor("f5"))*-100)/CDBL(v_total_f5)
									
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_ingreso.ObtenerValor("f1"))*-1)
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_ingreso.ObtenerValor("f2"))*-1)
										v_subtotal_f3	= v_subtotal_f3 + (CDBL(f_ingreso.ObtenerValor("f3"))*-1)
										v_subtotal_f4	= v_subtotal_f4 + (CDBL(f_ingreso.ObtenerValor("f4"))*-1)
										v_subtotal_f5	= v_subtotal_f5 + (CDBL(f_ingreso.ObtenerValor("f5"))*-1)
								%>
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_ingreso.DibujaCampo("descripcion")%></td>
								  <td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f1"))*-1,0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f1,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f2"))*-1,0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f2,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f3"))*-1,0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f3,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f4"))*-1,0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f4,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f5"))*-1,0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f5,0)%><strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
								%>
								<!-- INICIO sub total de grupos -->
									<tr bordercolor='#999999' align="right">	
									  <th align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th nowrap><%=formatnumber(v_subtotal_f1,0)%></th>
									  <th nowrap></th>
									  <th nowrap><%=formatnumber(v_subtotal_f2,0)%></th>
									  <th nowrap></th>
									  <th nowrap><%=formatnumber(v_subtotal_f3,0)%></th>
										<th nowrap></th>
										<th nowrap><%=formatnumber(v_subtotal_f4,0)%></th>
										<th nowrap></th>
										<th nowrap><%=formatnumber(v_subtotal_f5,0)%></th>
										<th nowrap></th>
									</tr>
								<%

								v_subtotal_f1	= 0
								v_subtotal_f2	= 0
								v_subtotal_f3	= 0
								v_subtotal_f4 	= 0
								v_subtotal_f5	= 0
															
								while f_costo_operacional.Siguiente
									descripcion_grupo= f_costo_operacional.ObtenerValor("descripcion_grupo")
								
										v_porcentaje_f1	= (CDBL(f_costo_operacional.ObtenerValor("f1"))*100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_costo_operacional.ObtenerValor("f2"))*100)/CDBL(v_total_f2)
										v_porcentaje_f3	= (CDBL(f_costo_operacional.ObtenerValor("f3"))*100)/CDBL(v_total_f3)
										v_porcentaje_f4	= (CDBL(f_costo_operacional.ObtenerValor("f4"))*100)/CDBL(v_total_f4)
										v_porcentaje_f5	= (CDBL(f_costo_operacional.ObtenerValor("f5"))*100)/CDBL(v_total_f5)
									
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_costo_operacional.ObtenerValor("f1")))
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_costo_operacional.ObtenerValor("f2")))
										v_subtotal_f3	= v_subtotal_f3 + (CDBL(f_costo_operacional.ObtenerValor("f3")))
										v_subtotal_f4	= v_subtotal_f4 + (CDBL(f_costo_operacional.ObtenerValor("f4")))
										v_subtotal_f5	= v_subtotal_f5 + (CDBL(f_costo_operacional.ObtenerValor("f5")))
								%>							
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_costo_operacional.DibujaCampo("descripcion")%></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f1")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f1,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f2")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f2,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f3")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f3,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f4")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f4,0)%><strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f5")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f5,0)%><strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
								
									v_porc_grupo_f1	= (CDBL(v_subtotal_f1)*100)/CDBL(v_total_f1)
									v_porc_grupo_f2	= (CDBL(v_subtotal_f2)*100)/CDBL(v_total_f2)
									v_porc_grupo_f3	= (CDBL(v_subtotal_f3)*100)/CDBL(v_total_f3)
									v_porc_grupo_f4	= (CDBL(v_subtotal_f4)*100)/CDBL(v_total_f4)
									v_porc_grupo_f5	= (CDBL(v_subtotal_f5)*100)/CDBL(v_total_f5)

									'*** Subtotal Acumulado (A-B)=C ***
									v_operacional_f1 	= CDBL(v_total_f1)-CDBL(v_subtotal_f1)
									v_operacional_f2 	= CDBL(v_total_f2)-CDBL(v_subtotal_f2)	
									v_operacional_f3 	= CDBL(v_total_f3)-CDBL(v_subtotal_f3)	
									v_operacional_f4 	= CDBL(v_total_f4)-CDBL(v_subtotal_f4)
									v_operacional_f5 	= CDBL(v_total_f5)-CDBL(v_subtotal_f5)
									
									v_porc_operacional_f1	= (CDBL(v_operacional_f1)*100)/CDBL(v_total_f1)
									v_porc_operacional_f2	= (CDBL(v_operacional_f2)*100)/CDBL(v_total_f2)
									v_porc_operacional_f3	= (CDBL(v_operacional_f3)*100)/CDBL(v_total_f3)
									v_porc_operacional_f4	= (CDBL(v_operacional_f4)*100)/CDBL(v_total_f4)
									v_porc_operacional_f5	= (CDBL(v_operacional_f5)*100)/CDBL(v_total_f5)
								%>
								<!-- INICIO sub total de grupo -->
									<tr bordercolor='#999999' align="right">	
									  <th align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th nowrap><%=formatnumber(v_subtotal_f1,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f1,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f2,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f2,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f3,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f3,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f4,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f4,0)%><strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f5,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f5,0)%><strong>%</strong></th>
									</tr>
								<!-- INICIO totalizado de RESULTADO OPERACIONAL-->
									<tr><th colspan="11" height="5"></th>
									<tr bordercolor='#999999' bgcolor="#FFFFCC" align="right">	
										<th align="left"><strong>RESULTADO OPERACIONAL</strong></th>
										<th nowrap><%=formatnumber(v_operacional_f1,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_f1,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_operacional_f2,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_f2,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_operacional_f3,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_f3,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_operacional_f4,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_f4,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_operacional_f5,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_f5,0)%><strong>%</strong></th>
									</tr>
									<tr><th colspan="11" height="10"></th>
								<%
								
								v_subtotal_f1	= 0
								v_subtotal_f2	= 0
								v_subtotal_f3	= 0
								v_subtotal_f4 	= 0
								v_subtotal_f5	= 0

								while f_gasto_administracion.Siguiente
								
								descripcion_grupo= f_gasto_administracion.ObtenerValor("descripcion_grupo")
								
										v_porcentaje_f1	= (CDBL(f_gasto_administracion.ObtenerValor("f1"))*100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_gasto_administracion.ObtenerValor("f2"))*100)/CDBL(v_total_f2)
										v_porcentaje_f3	= (CDBL(f_gasto_administracion.ObtenerValor("f3"))*100)/CDBL(v_total_f3)
										v_porcentaje_f4	= (CDBL(f_gasto_administracion.ObtenerValor("f4"))*100)/CDBL(v_total_f4)
										v_porcentaje_f5	= (CDBL(f_gasto_administracion.ObtenerValor("f5"))*100)/CDBL(v_total_f5)
									
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_gasto_administracion.ObtenerValor("f1")))
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_gasto_administracion.ObtenerValor("f2")))
										v_subtotal_f3	= v_subtotal_f3 + (CDBL(f_gasto_administracion.ObtenerValor("f3")))
										v_subtotal_f4	= v_subtotal_f4 + (CDBL(f_gasto_administracion.ObtenerValor("f4")))
										v_subtotal_f5	= v_subtotal_f5 + (CDBL(f_gasto_administracion.ObtenerValor("f5")))
								%>							
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_gasto_administracion.DibujaCampo("descripcion")%></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f1")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f1,0)%><strong>%</strong></td>
   											<td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f2")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f2,0)%><strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f3")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f3,0)%><strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f4")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f4,0)%><strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f5")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f5,0)%><strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
									v_porc_grupo_f1	= (CDBL(v_subtotal_f1)*100)/CDBL(v_total_f1)
									v_porc_grupo_f2	= (CDBL(v_subtotal_f2)*100)/CDBL(v_total_f2)
									v_porc_grupo_f3	= (CDBL(v_subtotal_f3)*100)/CDBL(v_total_f3)
									v_porc_grupo_f4	= (CDBL(v_subtotal_f4)*100)/CDBL(v_total_f4)
									v_porc_grupo_f5	= (CDBL(v_subtotal_f5)*100)/CDBL(v_total_f5)

									'*** Subtotal Acumulado (C-D)=E ***
									v_adm_f1 	= CDBL(v_operacional_f1)-CDBL(v_subtotal_f1)
									v_adm_f2 	= CDBL(v_operacional_f2)-CDBL(v_subtotal_f2)	
									v_adm_f3 	= CDBL(v_operacional_f3)-CDBL(v_subtotal_f3)	
									v_adm_f4 	= CDBL(v_operacional_f4)-CDBL(v_subtotal_f4)
									v_adm_f5 	= CDBL(v_operacional_f5)-CDBL(v_subtotal_f5)
									
									v_porc_adm_f1	= (CDBL(v_adm_f1)*100)/CDBL(v_total_f1)
									v_porc_adm_f2	= (CDBL(v_adm_f2)*100)/CDBL(v_total_f2)
									v_porc_adm_f3	= (CDBL(v_adm_f3)*100)/CDBL(v_total_f3)
									v_porc_adm_f4	= (CDBL(v_adm_f4)*100)/CDBL(v_total_f4)
									v_porc_adm_f5	= (CDBL(v_adm_f5)*100)/CDBL(v_total_f5)
								%>
								<!-- INICIO sub total de grupos -->
									<tr bordercolor='#999999' align="right">	
										<th align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th nowrap><%=formatnumber(v_subtotal_f1,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f1,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f2,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f2,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f3,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f3,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f4,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f4,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f5,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f5,0)%><strong>%</strong></th>
									</tr>
								<!-- INICIO totalizado de RESULTADO OPERACIONAL-->
									<tr><th colspan="11" height="5"></th>
									<tr bordercolor='#999999' bgcolor="#FFFFCC" align="right">	
										<th align="left"><strong>RESULTADO</strong></th>
										<th nowrap><%=formatnumber(v_adm_f1,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f1,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_adm_f2,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f2,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_adm_f3,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f3,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_adm_f4,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f4,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_adm_f5,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f5,0)%><strong>%</strong></th>
									</tr>
									<tr><th colspan="11" height="10"></th>
								 <%
								 
									v_subtotal_f1	= 0
									v_subtotal_f2	= 0
									v_subtotal_f3	= 0
									v_subtotal_f4 	= 0
									v_subtotal_f5	= 0
										
								 while f_gasto_indirecto.Siguiente
								 descripcion_grupo= f_gasto_indirecto.ObtenerValor("descripcion_grupo")
								 
										v_porcentaje_f1	= (CDBL(f_gasto_indirecto.ObtenerValor("f1"))*100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_gasto_indirecto.ObtenerValor("f2"))*100)/CDBL(v_total_f2)
										v_porcentaje_f3	= (CDBL(f_gasto_indirecto.ObtenerValor("f3"))*100)/CDBL(v_total_f3)
										v_porcentaje_f4	= (CDBL(f_gasto_indirecto.ObtenerValor("f4"))*100)/CDBL(v_total_f4)
										v_porcentaje_f5	= (CDBL(f_gasto_indirecto.ObtenerValor("f5"))*100)/CDBL(v_total_f5)
																				
									
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_gasto_indirecto.ObtenerValor("f1")))
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_gasto_indirecto.ObtenerValor("f2")))
										v_subtotal_f3	= v_subtotal_f3 + (CDBL(f_gasto_indirecto.ObtenerValor("f3")))
										v_subtotal_f4	= v_subtotal_f4 + (CDBL(f_gasto_indirecto.ObtenerValor("f4")))
										v_subtotal_f5	= v_subtotal_f5 + (CDBL(f_gasto_indirecto.ObtenerValor("f5")))
								%>
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_gasto_indirecto.DibujaCampo("descripcion")%></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f1")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f1,0)%><strong>%</strong></td>
   											<td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f2")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f2,0)%><strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f3")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f3,0)%><strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f4")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f4,0)%><strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f5")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f5,0)%><strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
								
								
									v_porc_grupo_f1	= (CDBL(v_subtotal_f1)*100)/CDBL(v_total_f1)
									v_porc_grupo_f2	= (CDBL(v_subtotal_f2)*100)/CDBL(v_total_f2)
									v_porc_grupo_f3	= (CDBL(v_subtotal_f3)*100)/CDBL(v_total_f3)
									v_porc_grupo_f4	= (CDBL(v_subtotal_f4)*100)/CDBL(v_total_f4)
									v_porc_grupo_f5	= (CDBL(v_subtotal_f5)*100)/CDBL(v_total_f5)
								%>
								<!-- INICIO sub total de grupos -->
									<tr bordercolor='#999999' align="right">	
										<th align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th nowrap><%=formatnumber(v_subtotal_f1,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f1,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f2,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f2,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f3,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f3,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f4,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f4,0)%><strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f5,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f5,0)%><strong>%</strong></th>
									</tr>
									<%
									'*** Subtotal Acumulado (E-F)=G ***
									v_resul_total_f1 	= CDBL(v_adm_f1)-CDBL(v_subtotal_f1)
									v_resul_total_f2 	= CDBL(v_adm_f2)-CDBL(v_subtotal_f2)	
									v_resul_total_f3 	= CDBL(v_adm_f3)-CDBL(v_subtotal_f3)	
									v_resul_total_f4 	= CDBL(v_adm_f4)-CDBL(v_subtotal_f4)
									v_resul_total_f5 	= CDBL(v_adm_f5)-CDBL(v_subtotal_f5)
									
									v_porc_total_f1	= (CDBL(v_resul_total_f1)*100)/CDBL(v_total_f1)
									v_porc_total_f2	= (CDBL(v_resul_total_f2)*100)/CDBL(v_total_f2)
									v_porc_total_f3	= (CDBL(v_resul_total_f3)*100)/CDBL(v_total_f3)
									v_porc_total_f4	= (CDBL(v_resul_total_f4)*100)/CDBL(v_total_f4)
									v_porc_total_f5	= (CDBL(v_resul_total_f5)*100)/CDBL(v_total_f5)
								
									%>
								 <tr><th colspan="11" height="5"></th>
								 <tr bordercolor='#999999'  bgcolor="#FFFFCC" align="right">
								 	<td align="left"><b>RESULTADO TOTAL</b></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f1,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f1,0)%></b><strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f2,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f2,0)%></b><strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f3,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f3,0)%></b><strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f4,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f4,0)%></b><strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f5,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f5,0)%></b><strong>%</strong></td>
								 </tr>
                              </table>
<%
						end select	
end if
%>
						<br/>
						</td>
                          </tr>
                        </table></td>
                      		<td width="7" background="../imagenes/marco_claro/10.gif">&nbsp;</td>
                    	</tr>
					  	<tr>
							<td class="noprint" align="left" valign="top"><img src="../imagenes/marco_claro/17.gif" width="9" height="28"></td>
							<td valign="top">
							<!-- desde aca -->
							<table  width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
                          		<tr > 
                            		<td class="noprint" width="47%" height="20" ><%botonera.DibujaBoton("imprimir")%></td>
								<td class="noprint" width="53%" rowspan="2" background="../imagenes/marco_claro/15.gif"><img src="../imagenes/marco_claro/14.gif" width="12" height="28"></td>
                          	</tr>
							   <tr> 
                            		<td height="8" background="../imagenes/marco_claro/13.gif"></td>
                          		</tr>
							</table>
							<!-- hasta aca 
							<img src="../imagenes/marco_claro/15.gif" width="100%" height="13">--></td>
							<td class="noprint" align="right" valign="top" height="13"><img src="../imagenes/marco_claro/16.gif" width="7"height="28"></td>
					  	</tr>
                  </table>
					<br/>
                </td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
            </table>
			
            <table class="noprint" width="100%" border="0" cellspacing="0" cellpadding="0">
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