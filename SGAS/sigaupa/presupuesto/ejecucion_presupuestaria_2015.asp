<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 2000 
set pagina = new CPagina
pagina.Titulo = "Ejecucion Presupuestaria"
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
botonera.Carga_Parametros "ejecucion_presupuestaria_2015.xml", "botonera"
'-----------------------------------------------------------------------
 
 codcaja	= request.querystring("busqueda[0][codcaja]")
 area_ccod	= request.querystring("busqueda[0][area_ccod]")
 mes_venc	= request.querystring("busqueda[0][mes_venc]")  
 nro_t		= request.querystring("nro_t")
 
 if codcaja="" then
	 codcaja= request.querystring("codcaja")
 end if

 if area_ccod="" then
	 area_ccod= request.querystring("area_ccod")
 end if

 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "ejecucion_presupuestaria_2015.xml", "busqueda_presupuesto"
 f_busqueda.Inicializar conexion2
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
 'f_busqueda.AgregaCampoCons "codcaja", codcaja
 f_busqueda.AgregaCampoParam "area_ccod", "filtro",  "area_ccod in ( select distinct area_ccod from  presupuesto_upa.protic.area_presupuesto_usuario  where rut_usuario in ('"&v_usuario&"') )"
 f_busqueda.AgregaCampoCons "area_ccod", area_ccod

 f_busqueda.AgregaCampoParam "codcaja", "destino",  "(select distinct cod_pre, cod_pre as desc_cod_pre from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2015  where cod_area in ('"&area_ccod&"')) a "
 'f_busqueda.AgregaCampoParam "cod_pre", "filtro",  "cod_pre in ( select distinct cod_pre from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2015 where cod_area in ('"&area_ccod&"') )"
 f_busqueda.AgregaCampoCons "codcaja", codcaja
 
'----------------------------------------------------------------------------


 set f_presupuesto = new CFormulario
 f_presupuesto.Carga_Parametros "ejecucion_presupuestaria_2015.xml", "f_presupuesto"
 f_presupuesto.Inicializar conexion2

   if Request.QueryString <> "" then
	  
	  if nro_t="" then
	  	nro_t=1
	  end if

	select case (nro_t)
		
		
		case 1:
			set f_presupuestado = new CFormulario
			f_presupuestado.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			f_presupuestado.Inicializar conexion2
			
			if codcaja <> "" then
			 
				sql_presupuestado	=" SELECT concepto, detalle, cod_pre,isnull(total,0) as total, "& vbCrLf &_
									" isnull(enero,0) as enero, isnull(febrero,0) as febrero, isnull(marzo,0) as marzo, isnull(abril,0) as abril, "& vbCrLf &_
									" isnull(mayo,0) as mayo, isnull(junio,0) as junio, isnull(julio,0) as julio, isnull(agosto,0) as agosto, "& vbCrLf &_
									" isnull(septiembre,0) as septiembre,isnull(octubre,0) as octubre, isnull(noviembre,0) as noviembre,  "& vbCrLf &_
									" isnull(diciembre,0) as diciembre, isnull(enero_prox,0) as enero_prox,isnull(febrero_prox,0) as febrero_prox "& vbCrLf &_
									"	FROM presupuesto_upa.protic.presupuesto_upa_2015 "& vbCrLf &_
									"	where cod_pre = '"&codcaja&"'  "
			else
				sql_presupuestado	=" SELECT concepto, detalle, cod_pre,isnull(total,0) as total, "& vbCrLf &_
									" isnull(enero,0) as enero, isnull(febrero,0) as febrero, isnull(marzo,0) as marzo, isnull(abril,0) as abril, "& vbCrLf &_
									" isnull(mayo,0) as mayo, isnull(junio,0) as junio, isnull(julio,0) as julio, isnull(agosto,0) as agosto, "& vbCrLf &_
									" isnull(septiembre,0) as septiembre,isnull(octubre,0) as octubre, isnull(noviembre,0) as noviembre,  "& vbCrLf &_
									" isnull(diciembre,0) as diciembre, isnull(enero_prox,0) as enero_prox,isnull(febrero_prox,0) as febrero_prox "& vbCrLf &_
									"	FROM presupuesto_upa.protic.presupuesto_upa_2015 "& vbCrLf &_
									"	where cod_pre in (select distinct cod_pre from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2015 where cod_area="&area_ccod&")  "
			end if
			
			f_presupuestado.consultar sql_presupuestado
			'response.Write("<pre>"&sql_presupuestado&"</pre>")
			
		case 2:
	
			if mes_venc <> "" then
				'sql_mes= "and month(movfv)="&mes_venc
				sql_mes="and cast(substring(b.efcodi,1,2) as numeric)="&mes_venc
				nombre_mes=conexion2.consultauno("select nombremes from softland.sw_mesce where indice="&mes_venc&"")
				
				if mes_venc=0 then
					nombre_mes= "TODOS LOS MESES"
					sql_mes=""
				end if
			
			end if


			if codcaja <> "" then
					'######################## por codigo	###################	

				consulta_prespuesto=" select  a.cpbnum,a.codaux as rut,c.nomaux as proveedor, convert(char(10),a.movfv,103) as fecha_pago," & vbCrLf &_
								 " MovTipDocRef as tipo_doc,MovNumDocRef as num_doc,a.movhaber as monto,a.movglosa as detalle, a.cajcod as cajcod" & vbCrLf &_
								 " from softland.cwmovim a, softland.cwmovef b, softland.cwtauxi c  " & vbCrLf &_
								 " where a.cpbnum=b.cpbnum" & vbCrLf &_
								 " and a.movhaber=b.efmontohaber "& vbCrLf &_ 
								 " and a.codaux=c.codaux" & vbCrLf &_
								 " and a.movnum=b.movnum" & vbCrLf &_
								 " and substring(b.efcodi,3,4)=2015   " & vbCrLf &_
								 " and a.movhaber <> 0    " & vbCrLf &_
								 " and a.cpbnum>0   " & vbCrLf &_
								 " "&sql_mes&" "& vbCrLf &_
								 " and a.cajcod='"&codcaja&"' "& vbCrLf &_
								 " and a.pctcod like '2-10-070-10-000004' "
				
					
				sql_meses= "select  upper(nombremes) as mes,indice as mes_venc,cast(isnull(presu_real,0) as numeric) as presu_real,   "& vbCrLf &_
							"    cast(isnull(presupuestado,0) as numeric) as presupuestado,  cast(isnull(desviacion,0) as numeric) as desviacion "& vbCrLf &_
							"		 from softland.sw_mesce as b  "& vbCrLf &_
							"         left outer join ( "& vbCrLf &_
							"			select pa.mes as mes, isnull(presu_real,0) as presu_real,presupuestado, presupuestado-isnull(presu_real,0) as desviacion "& vbCrLf &_
							"				from  "& vbCrLf &_
							"					(select sum(valor) as presupuestado,mes "& vbCrLf &_   
							"						from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2015    "& vbCrLf &_
							"						where cod_pre='"&codcaja&"' "& vbCrLf &_
							"						group by mes "& vbCrLf &_
							"					) as pa "& vbCrLf &_
							"					left outer join     "& vbCrLf &_
							"					(select isnull(sum(cast(movhaber as numeric)),0) as presu_real, cast(substring(b.efcodi,1,2) as numeric) as mes    "& vbCrLf &_
							"					from  softland.cwmovim a, softland.cwmovef b   "& vbCrLf &_   
							" 					where a.cpbnum=b.cpbnum " & vbCrLf &_
							"					and a.movnum=b.movnum " & vbCrLf &_
							" 					and a.movhaber=b.efmontohaber  " & vbCrLf &_
							"					and substring(b.efcodi,3,4)=2015  "& vbCrLf &_
							"					and a.cajcod='"&codcaja&"'  "& vbCrLf &_ 
							"					and a.movhaber <> 0      "& vbCrLf &_
							"					and a.pctcod like '2-10-070-10-000004'   "& vbCrLf &_  
							"					and a.cpbnum>0  group by cast(substring(b.efcodi,1,2) as numeric) "& vbCrLf &_
							"					) as pr   "& vbCrLf &_
							"				on pa.mes=pr.mes "& vbCrLf &_
							" 		)as a "& vbCrLf &_
							"	on indice=mes "
							
									
			else
				'######################## por area	###################	

				consulta_prespuesto=" select  a.cpbnum,a.codaux as rut,c.nomaux as proveedor, convert(char(10),a.movfv,103) as fecha_pago," & vbCrLf &_
								 " MovTipDocRef as tipo_doc,MovNumDocRef as num_doc,a.movhaber as monto,a.movglosa as detalle, a.cajcod as cajcod" & vbCrLf &_
								 " from softland.cwmovim a, softland.cwmovef b, softland.cwtauxi c  " & vbCrLf &_
								 " where a.cpbnum=b.cpbnum" & vbCrLf &_
								 " and a.movhaber=b.efmontohaber " & vbCrLf &_
								 " and a.codaux=c.codaux" & vbCrLf &_
								 " and a.movnum=b.movnum" & vbCrLf &_
								 " and a.pctcod like '2-10-070-10-000004' "& vbCrLf &_
								 " and substring(b.efcodi,3,4)=2015   " & vbCrLf &_
								 " and a.movhaber <> 0    " & vbCrLf &_
								 " and a.cpbnum>0   " & vbCrLf &_
								 " "&sql_mes&" "& vbCrLf &_
								 " and a.cajcod in (select distinct cod_pre from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2015 where cod_area="&area_ccod&") "
								 
			
				sql_meses= "select  upper(nombremes) as mes,indice as mes_venc,cast(isnull(presu_real,0) as numeric) as presu_real,   "& vbCrLf &_
							"    cast(isnull(presupuestado,0) as numeric) as presupuestado,  cast(isnull(desviacion,0) as numeric) as desviacion "& vbCrLf &_
							"		 from softland.sw_mesce as b  "& vbCrLf &_
							"         left outer join ( "& vbCrLf &_
							"			select pa.mes as mes, isnull(presu_real,0) as presu_real,presupuestado, presupuestado-isnull(presu_real,0) as desviacion "& vbCrLf &_
							"				from  "& vbCrLf &_
							"					(select sum(valor) as presupuestado,mes "& vbCrLf &_   
							"						from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2015    "& vbCrLf &_
							"						where cod_pre in (select distinct cod_pre from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2015 where cod_area= "&area_ccod&" ) "& vbCrLf &_
							"						group by mes "& vbCrLf &_
							"					) as pa "& vbCrLf &_
							"					left outer join     "& vbCrLf &_
							"					(select isnull(sum(cast(movhaber as numeric)),0) as presu_real, cast(substring(b.efcodi,1,2) as numeric) as mes    "& vbCrLf &_
							"					from  softland.cwmovim a, softland.cwmovef b  "& vbCrLf &_   
							"					where a.cpbnum=b.cpbnum "& vbCrLf &_
							"					and a.movnum=b.movnum " & vbCrLf &_ 
							" 					and a.movhaber=b.efmontohaber "& vbCrLf &_ 
							"					and	substring(b.efcodi,3,4)=2015    "& vbCrLf &_
							"					and a.cajcod in (select distinct cod_pre from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2015 where cod_area= "&area_ccod&" )  "& vbCrLf &_ 
							"					and a.movhaber <> 0      "& vbCrLf &_
							"					and a.pctcod like '2-10-070-10-000004'   "& vbCrLf &_  
							"					and a.cpbnum>0  group by cast(substring(b.efcodi,1,2) as numeric) "& vbCrLf &_
							"					) as pr   "& vbCrLf &_
							"				on pa.mes=pr.mes "& vbCrLf &_
							" 		)as a "& vbCrLf &_
							"	on indice=mes  order by mes_venc asc"
			end if

			'response.Write("<pre>"&consulta_prespuesto&"</pre>")

			f_presupuesto.consultar consulta_prespuesto				   
		
			set f_meses = new CFormulario
			f_meses.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			f_meses.Inicializar conexion2

			'response.Write("<pre>"&sql_meses&"</pre>")
			f_meses.consultar sql_meses
	
	end select	

	sql_area_presu	= " select top 1 area_tdesc from presupuesto_upa.protic.area_presupuesto_usuario a, presupuesto_upa.protic.area_presupuestal b " & vbCrLf &_
					" where a.area_ccod=b.area_ccod " & vbCrLf &_
					" and rut_usuario="&v_usuario&"  and a.area_ccod="&area_ccod&"  "
	
	area_presupuesto = 	conexion2.consultaUno(sql_area_presu)


else
	 f_presupuesto.consultar "select '' where 1 = 2"
	 f_presupuesto.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
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

	_Buscar(this, document.forms['busca_codigo'],'', 'Validar();', 'FALSE');
}

function ver_detalle(var1,var2,var3){
	formulario=document.forms['busca_codigo'];
	formulario.elements["busqueda[0][mes_venc]"].value=var3
	_Buscar(this, document.forms['busca_codigo'],'', 'Validar();', 'FALSE');

}
</script>
<style type="text/css">

	.meses:link, .meses:visited { 	text-decoration: underline;color:#0033FF; }
	.meses:hover {	text-decoration: none; }
	
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
                    <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="172" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Documentos
                          Encontrados</font></div>
                    </td>
                    <td width="485" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
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
                              <%pagina.DibujarLenguetasFClaro Array(array("Presupuestado","ejecucion_presupuestaria_2015.asp?area_ccod="&area_ccod&"&codcaja="& codcaja &"&nro_t=1"),array("Ejecucion Presupuestaria","ejecucion_presupuestaria_2015.asp?area_ccod="&area_ccod&"&codcaja="& codcaja &"&nro_t=2")), nro_t %>
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
								<input type="hidden" name="nro_t" value="<%=nro_t%>" >
								<input type="hidden" name="busqueda[0][area_ccod]" value="<%=area_ccod%>"/>
								<input type="hidden" name="busqueda[0][mes_venc]" value=""/>
											
								<table>
									<tr>                          
										<td width="155"><div align="left"><strong>Código presupuestario</strong></div></td>
										<td width="8">:</td>
										<td width="53"><% f_busqueda.DibujaCampo("codcaja") %></td>
									</tr>
								</table>
								</form>
							<% 
							select case (nro_t)
							case 2:
							%>
								<form name="presupuesto" method="post" >
									<input type="hidden" name="nro_t" value="<%=nro_t%>" >
									<input type="hidden" name="codcaja" value="<%=codcaja%>">
									<input type="hidden" name="area_ccod" value="<%=area_ccod%>">
								</form>
			
                              <table width="90%" border="1" align="center"  >
                                <tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
                                  <th width="25%">MES</th>
                                  <th width="25%">REAL</th>
                                  <th width="25%">PRESUPUESTADO</th>
                                  <th width="25%">DESV. MENSUAL</th>
								  <th width="25%">DESV. ACUMULADA</th>
                                </tr>
								<%
								v_total_real	=0
								v_total_presu	=0
								v_total_desvi	=0
								while f_meses.Siguiente
									v_total_real	=	v_total_real	+	Clng(f_meses.ObtenerValor("presu_real"))
									v_total_presu	=	v_total_presu	+	Clng(f_meses.ObtenerValor("presupuestado"))
									v_total_desvi	=	v_total_desvi	+	Clng(f_meses.ObtenerValor("desviacion"))
									'response.Write("<hr>"&Clng(v_total_presu)&"-"&Clng(v_total_real))
									v_desvi_acumul	=	CDbl(v_total_presu)-CDbl(v_total_real)
									v_mes_venc		=	Cint(f_meses.ObtenerValor("mes_venc"))
									
									if CDbl(v_desvi_acumul)<0 then
										v_signo_a= "red"
									else
										v_signo_a= "black"
									end if
									
									if CDbl(f_meses.ObtenerValor("desviacion"))<0 then
										v_signo= "red"
									else
										v_signo= "black"
									end if
								%>
								<tr bordercolor='#999999'>	
                                  <td><font color="#0033FF"><a href="JAVASCRIPT:ver_detalle(<%=area_ccod%>,'<%=codcaja%>',<%=v_mes_venc%>);" class="meses"><%f_meses.DibujaCampo("mes")%></a></font></td>
                                  <td><%=formatcurrency(f_meses.ObtenerValor("presu_real"),0)%></td>
                                  <td><%=formatcurrency(f_meses.ObtenerValor("presupuestado"),0)%></td>
                                  <td><font color="<%=v_signo%>"><%=formatcurrency(f_meses.ObtenerValor("desviacion"),0)%></font></td>
								  <td><font color="<%=v_signo_a%>"><%=formatcurrency(v_desvi_acumul,0)%></font></td>
                                </tr>
								 <%wend
								 v_desvi_mensual=v_total_presu-v_total_real
								 if v_desvi_mensual<0 then
								 	color1="color='#FF0000'"
								 end if
								 if v_desvi_acumul<0 then
								 	color2="color='#FF0000'"
								 end if
								 %>
								 <tr bordercolor='#999999'>
								 	<td><a href="JAVASCRIPT:ver_detalle(<%=area_ccod%>,'<%=codcaja%>',0);"><b>TOTAL</b></a></td>
									<td><b><%=formatcurrency(v_total_real,0,0)%></b></td>
									<td><b><%=formatcurrency(v_total_presu,0,0)%></b></td>
									<td><font <%=color1%> size="1" ><b><%=formatcurrency(v_desvi_mensual,0,0)%></b></font></td>
									<td><font <%=color2%> size="1" ><b><%=formatcurrency(v_desvi_acumul,0,0)%></b></font></td>
								 </tr>
                              </table>
							  <%if mes_venc<>"" then%>
						      <form name="edicion" >
							  <input type="hidden" name="codcaja" value="<%=codcaja%>">
							  <input type="hidden" name="area_ccod" value="<%=area_ccod%>">
							  <input type="hidden" name="mes_venc" value="<%=mes_venc%>"/>
							  
							  <font color="#0000CC" size="2">Detalle presupuesto ejecutado para el mes: <b><%=nombre_mes%></b></font>
                                  <table width="600" cellspacing="0" cellpadding="0">
								  <tr><td><div align="right">P&aacute;ginas: &nbsp; <% f_presupuesto.AccesoPagina %></div></td></tr>
                                    <tr>
                                      <td align="center"><% f_presupuesto.DibujaTabla() %></td>
                                    </tr>
                                  </table>
                              </form>
							<%end if
							 case 1:%>
								<form name="presupuesto" method="post">
									<input type="hidden" name="nro_t" value="<%=nro_t%>" >
									<input type="hidden" name="codcaja" value="<%=codcaja%>">
									<input type="hidden" name="area_ccod" value="<%=area_ccod%>">
								</form>							
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
										  <th width="25%">ENERO PROX</th>
										  <th width="25%">FEBRERO PROX</th>
										  <th width="25%">TOTAL</th>
										</tr>
									<%
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
										<td><%=f_presupuestado.ObtenerValor("concepto")%></td>
										<td><%=f_presupuestado.ObtenerValor("detalle")%></td>
										<td><%=f_presupuestado.ObtenerValor("cod_pre")%></td>
										<td><%=formatcurrency(f_presupuestado.ObtenerValor("enero"),0)%></td>
										<td><%=formatcurrency(f_presupuestado.ObtenerValor("febrero"),0)%></td>
										<td><%=formatcurrency(f_presupuestado.ObtenerValor("marzo"),0)%></td>
										<td><%=formatcurrency(f_presupuestado.ObtenerValor("abril"),0)%></td>
										<td><%=formatcurrency(f_presupuestado.ObtenerValor("mayo"),0)%></td>
										<td><%=formatcurrency(f_presupuestado.ObtenerValor("junio"),0)%></td>
										<td><%=formatcurrency(f_presupuestado.ObtenerValor("julio"),0)%></td>
										<td><%=formatcurrency(f_presupuestado.ObtenerValor("agosto"),0)%></td>
										<td><%=formatcurrency(f_presupuestado.ObtenerValor("septiembre"),0)%></td>
										<td><%=formatcurrency(f_presupuestado.ObtenerValor("octubre"),0)%></td>
										<td><%=formatcurrency(f_presupuestado.ObtenerValor("noviembre"),0)%></td>
										<td><%=formatcurrency(f_presupuestado.ObtenerValor("diciembre"),0)%></td>
										<td><%=formatcurrency(f_presupuestado.ObtenerValor("enero_prox"),0)%></td>
										<td><%=formatcurrency(f_presupuestado.ObtenerValor("febrero_prox"),0)%></td>
										<td><strong><%=formatcurrency(f_presupuestado.ObtenerValor("total"),0)%></strong></td>
									</tr>
									 <%wend%>
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
									<td align="right"><b><%=formatcurrency(v_enero_prox,0)%></b></td>
									<td align="right"><b><%=formatcurrency(v_febrero_prox,0)%></b></td>
									<td align="right"><b><%=formatcurrency(v_total,0)%></b></td>
								 </tr>									 
								  </table>
							<%End Select%>
						<br/>
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
											<% 
											select case (nro_t)
											case 2:
											%>
												<td width="49%">
													<% 'botonera.DibujaBoton ("excel_presupuesto")%>
												</td>
												<td width="21%">
													<%if mes_venc<>"" then													
													 botonera.DibujaBoton ("excel_detalle") 
													end if%>													
												</td>
												<%case 1:%>
												<td width="100%">
													<%botonera.DibujaBoton ("excel_mensual")%>
												</td>
												<% end select %>
										  	</tr>
                                		</table>
                              </div></td>
								<td width="53%" rowspan="2" background="../imagenes/marco_claro/15.gif"><img src="../imagenes/marco_claro/14.gif" width="12" height="28"></td>
                          	</tr>
							   <tr> 
                            		<td height="8" background="../imagenes/marco_claro/13.gif"></td>
                          		</tr>
							</table>
							<!-- hasta aca 
							<img src="../imagenes/marco_claro/15.gif" width="100%" height="13">--></td>
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