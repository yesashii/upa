<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION			        :
'FECHA CREACIÓN			      :
'CREADO POR				        :
'ENTRADA				          : NA
'SALIDA				            : NA
'MODULO QUE ES UTILIZADO	: MODULO DAE 
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION		: 03/04/2013
'ACTUALIZADO POR			  : Luis Herrera G.
'MOTIVO				          : Corregir código, eliminar sentencia *= , =*
'LINEA				          : 59, 122, 148
'********************************************************************
set pagina = new CPagina
pagina.Titulo = "Generar Cargo de Pase Escolar"
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
 f_busqueda.Carga_Parametros "cargo_pase_escolar.xml", "busqueda_usuarios_nuevo"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' "
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut
 f_busqueda.AgregaCampoCons "pers_xdv", digito
'--------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "cargo_pase_escolar.xml", "botonera"
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

'----------------------------------------------------------------------------------nueva consulta 2008
consulta_datos =  " select a.pers_ncorr,                                                "& vbCrLf & _
"       protic.format_rut(pers_nrut)                                  as rut,           "& vbCrLf & _
"       pers_temail,                                                                    "& vbCrLf & _
"       isnull(pers_tcelular, (select top 1 pers_tcelular                               "& vbCrLf & _
"                              from   direcciones                                       "& vbCrLf & _
"                              where  pers_ncorr = a.pers_ncorr                         "& vbCrLf & _
"                                     and pers_tcelular is not null)) as pers_tcelular, "& vbCrLf & _
"       isnull(pers_tfono, (select top 1 pers_tfono                                     "& vbCrLf & _
"                           from   direcciones                                          "& vbCrLf & _
"                           where  pers_ncorr = a.pers_ncorr                            "& vbCrLf & _
"                                  and pers_tfono is not null))       as pers_tfono,    "& vbCrLf & _
"       a.pers_tnombre + ' ' + a.pers_tape_paterno + ' '                                "& vbCrLf & _
"       + a.pers_tape_materno                                         as nombre,        "& vbCrLf & _
"       b.sexo_tdesc                                                  as sexo,          "& vbCrLf & _
"       c.pais_tdesc                                                  as pais           "& vbCrLf & _
"from   personas_postulante as a                                                        "& vbCrLf & _
"       left outer join sexos as b                                                      "& vbCrLf & _
"                    on a.sexo_ccod = b.sexo_ccod                                       "& vbCrLf & _
"       inner join paises as c                                                          "& vbCrLf & _
"               on a.pais_ccod = c.pais_ccod                                            "& vbCrLf & _
"where  cast(a.pers_nrut as VARCHAR) = '"&rut&"'                                        "
'----------------------------------------------------------------------------------fin nueva consulta 2008

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

set fc_postulante = new CFormulario
fc_postulante.Carga_Parametros "cargo_pase_escolar.xml", "info_postulacion_contrato"
fc_postulante.Inicializar conexion

'sql_postulante = " select  distinct case when f.carr_ccod in (870,940,950,880) and "&v_peri_ccod&" >220 and b.post_bnuevo='S' then 'N' else 'S' end as tiene_cupo,C.POST_NCORR AS FICHA,cast(a.pers_nrut as varchar(10))  + ' - ' + a.pers_xdv as rut, " & vbcrlf & _
'			" a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre_completo, " & vbcrlf & _
'			" protic.obtener_nombre_carrera(c.ofer_ncorr, 'CE')+ case when f.carr_ccod in (870,940,950,880) and "&v_peri_ccod&" >220  and b.post_bnuevo='S' then '<br><b><font color=#FF0000>-Carreras educacion bloqueadas-</font></b>' else '' end as carrera, " & vbcrlf & _
'			" g.jorn_tdesc,h.sede_tdesc,i.eepo_tdesc,c.ofer_ncorr,i.eepo_ccod, " & vbcrlf & _
'			" '' as ventana,"  & vbcrlf & _
'			" b.post_ncorr,isnull((Select 'S' as tiene_contr from contratos where post_ncorr=b.post_ncorr and econ_ccod<>3),'N') as tiene_contrato ," & vbcrlf & _
'			" isnull((Select top 1 'SI' as tiene_contr from contratos where post_ncorr=b.post_ncorr and econ_ccod<>3),'NO') as c_contrato " & vbcrlf & _
'			" from  " & vbcrlf & _
'			" personas_postulante a,postulantes b,detalle_postulantes c, " & vbcrlf & _
'			" ofertas_academicas d,especialidades e,carreras f,jornadas g, " & vbcrlf & _
'			" sedes h,estado_examen_postulantes i " & vbcrlf & _
'			" where a.pers_ncorr = b.pers_ncorr " & vbcrlf & _
'			" and b.post_ncorr = c.post_ncorr " & vbcrlf & _
'			" and c.ofer_ncorr = d.ofer_ncorr " & vbcrlf & _
'			" and d.espe_ccod = e.espe_ccod " & vbcrlf & _
'			" and e.carr_ccod = f.carr_ccod   " & vbcrlf & _
'			" and d.jorn_ccod = g.jorn_ccod " & vbcrlf & _
'			" and d.sede_ccod = h.sede_ccod " & vbcrlf & _
'			" and c.eepo_ccod *= i.eepo_ccod " & vbcrlf & _
'			" and b.epos_ccod = 2 " & vbcrlf & _
'			" and d.ofer_bactiva <> 'N' " & vbcrlf & _
'			" and b.tpos_ccod in (1,2) " & vbcrlf & _
'			" and b.audi_tusuario not like '%ajus%' "& vbcrlf & _
'			" and cast(b.pers_ncorr as varchar)= '" & codigo & "' " & vbcrlf & _
'			" and b.peri_ccod = " & v_peri_ccod & " "& vbcrlf & _
'"UNION "& vbcrlf & _
'			" select distinct 'S' as tiene_cupo,C.POST_NCORR AS FICHA,cast(a.pers_nrut as varchar(10))  + ' - ' + a.pers_xdv as rut, " & vbcrlf & _
'			" a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre_completo, " & vbcrlf & _
'			" protic.obtener_nombre_carrera(c.ofer_ncorr, 'CE')+'<b><font color=#FF0000>CUPOS AGOTADOS</font></b>' as carrera, " & vbcrlf & _
'			" g.jorn_tdesc,h.sede_tdesc,i.eepo_tdesc,c.ofer_ncorr,1 as eepo_ccod, " & vbcrlf & _
'			" '' as ventana,"  & vbcrlf & _
'			" b.post_ncorr,isnull((Select top 1 'S' as tiene_contr from contratos where post_ncorr=b.post_ncorr and econ_ccod<>3),'N') as tiene_contrato ," & vbcrlf & _
'			" isnull((Select top 1 'SI' as tiene_contr from contratos where post_ncorr=b.post_ncorr and econ_ccod<>3),'NO') as c_contrato " & vbcrlf & _
'			" from  " & vbcrlf & _
'			" personas_postulante a,postulantes b,detalle_postulantes c, " & vbcrlf & _
'			" ofertas_academicas d,especialidades e,carreras f,jornadas g, " & vbcrlf & _
'			" sedes h,estado_examen_postulantes i " & vbcrlf & _
'			" where a.pers_ncorr = b.pers_ncorr " & vbcrlf & _
'			" and b.post_ncorr = c.post_ncorr " & vbcrlf & _
'			" and c.ofer_ncorr = d.ofer_ncorr " & vbcrlf & _
'			" and d.espe_ccod = e.espe_ccod " & vbcrlf & _
'			" and e.carr_ccod = f.carr_ccod   " & vbcrlf & _
'			" and d.jorn_ccod = g.jorn_ccod " & vbcrlf & _
'			" and d.sede_ccod = h.sede_ccod " & vbcrlf & _
'			" and c.eepo_ccod *= i.eepo_ccod " & vbcrlf & _
'			" and b.epos_ccod = 2 " & vbcrlf & _
'			" and d.ofer_bactiva = 'N' " & vbcrlf & _
'			" and b.tpos_ccod in (1,2) " & vbcrlf & _
'			" and b.audi_tusuario not like '%ajus%' "& vbcrlf & _
'			" and cast(b.pers_ncorr as varchar)= '" & codigo & "' " & vbcrlf & _
'			" and b.peri_ccod = " & v_peri_ccod & " "

'----------------------------------------------------------------------------------nueva consulta 2008
sql_postulante = " select distinct case                                                                                  " & vbcrlf & _
"                  when f.carr_ccod in ( 870, 940, 950, 880 )                                                            " & vbcrlf & _
"                       and "&v_peri_ccod&" > 220                                                                        " & vbcrlf & _
"                       and b.post_bnuevo = 'S' then 'N'                                                                 " & vbcrlf & _
"                  else 'S'                                                                                              " & vbcrlf & _
"                end                                                                                 as tiene_cupo,      " & vbcrlf & _
"                c.post_ncorr                                                                        as ficha,           " & vbcrlf & _
"                cast(a.pers_nrut as VARCHAR(10)) + ' - '                                                                " & vbcrlf & _
"                + a.pers_xdv                                                                        as rut,             " & vbcrlf & _
"                a.pers_tnombre + ' ' + a.pers_tape_paterno + ' '                                                        " & vbcrlf & _
"                + a.pers_tape_materno                                                               as nombre_completo, " & vbcrlf & _
"                protic.obtener_nombre_carrera(c.ofer_ncorr, 'CE')                                                       " & vbcrlf & _
"                + case when f.carr_ccod in (870, 940, 950, 880) and "&v_peri_ccod&" >220 and b.post_bnuevo='S' then     " & vbcrlf & _
"                '<br><b><font color=#FF0000>-Carreras educacion bloqueadas-</font></b>' else '' end as carrera,         " & vbcrlf & _
"                g.jorn_tdesc,                                                                                           " & vbcrlf & _
"                h.sede_tdesc,                                                                                           " & vbcrlf & _
"                i.eepo_tdesc,                                                                                           " & vbcrlf & _
"                c.ofer_ncorr,                                                                                           " & vbcrlf & _
"                i.eepo_ccod,                                                                                            " & vbcrlf & _
"                ''                                                                                  as ventana,         " & vbcrlf & _
"                b.post_ncorr,                                                                                           " & vbcrlf & _
"                isnull((select 'S' as tiene_contr                                                                       " & vbcrlf & _
"                        from   contratos                                                                                " & vbcrlf & _
"                        where  post_ncorr = b.post_ncorr                                                                " & vbcrlf & _
"                               and econ_ccod <> 3), 'N')                                            as tiene_contrato,  " & vbcrlf & _
"                isnull((select top 1 'SI' as tiene_contr                                                                " & vbcrlf & _
"                        from   contratos                                                                                " & vbcrlf & _
"                        where  post_ncorr = b.post_ncorr                                                                " & vbcrlf & _
"                               and econ_ccod <> 3), 'NO')                                           as c_contrato       " & vbcrlf & _
"from   personas_postulante as a                                                                                         " & vbcrlf & _
"       inner join postulantes as b                                                                                      " & vbcrlf & _
"               on a.pers_ncorr = b.pers_ncorr                                                                           " & vbcrlf & _
"                  and b.epos_ccod = 2                                                                                   " & vbcrlf & _
"                  and b.tpos_ccod in ( 1, 2 )                                                                           " & vbcrlf & _
"                  and b.audi_tusuario not like '%ajus%'                                                                 " & vbcrlf & _
"                  and cast(b.pers_ncorr as VARCHAR) = '" & codigo & "'                                                  " & vbcrlf & _
"                  and b.peri_ccod = " & v_peri_ccod & "                                                                 " & vbcrlf & _
"       inner join detalle_postulantes as c                                                                              " & vbcrlf & _
"               on b.post_ncorr = c.post_ncorr                                                                           " & vbcrlf & _
"       inner join ofertas_academicas as d                                                                               " & vbcrlf & _
"               on c.ofer_ncorr = d.ofer_ncorr                                                                           " & vbcrlf & _
"                  and d.ofer_bactiva <> 'N'                                                                             " & vbcrlf & _
"       inner join especialidades as e                                                                                   " & vbcrlf & _
"               on d.espe_ccod = e.espe_ccod                                                                             " & vbcrlf & _
"       inner join carreras as f                                                                                         " & vbcrlf & _
"               on e.carr_ccod = f.carr_ccod                                                                             " & vbcrlf & _
"       inner join jornadas as g                                                                                         " & vbcrlf & _
"               on d.jorn_ccod = g.jorn_ccod                                                                             " & vbcrlf & _
"       inner join sedes as h                                                                                            " & vbcrlf & _
"               on d.sede_ccod = h.sede_ccod                                                                             " & vbcrlf & _
"       left outer join estado_examen_postulantes as i                                                                   " & vbcrlf & _
"                    on c.eepo_ccod = i.eepo_ccod                                                                        " & vbcrlf & _
"union                                                                                                                   " & vbcrlf & _
"select distinct 'S'                                                  as tiene_cupo,                                     " & vbcrlf & _
"                c.post_ncorr                                         as ficha,                                          " & vbcrlf & _
"                cast(a.pers_nrut as VARCHAR(10)) + ' - '                                                                " & vbcrlf & _
"                + a.pers_xdv                                         as rut,                                            " & vbcrlf & _
"                a.pers_tnombre + ' ' + a.pers_tape_paterno + ' '                                                        " & vbcrlf & _
"                + a.pers_tape_materno                                as nombre_completo,                                " & vbcrlf & _
"                protic.obtener_nombre_carrera(c.ofer_ncorr, 'CE')                                                       " & vbcrlf & _
"                + '<b><font color=#FF0000>CUPOS AGOTADOS</font></b>' as carrera,                                        " & vbcrlf & _
"                g.jorn_tdesc,                                                                                           " & vbcrlf & _
"                h.sede_tdesc,                                                                                           " & vbcrlf & _
"                i.eepo_tdesc,                                                                                           " & vbcrlf & _
"                c.ofer_ncorr,                                                                                           " & vbcrlf & _
"                1                                                    as eepo_ccod,                                      " & vbcrlf & _
"                ''                                                   as ventana,                                        " & vbcrlf & _
"                b.post_ncorr,                                                                                           " & vbcrlf & _
"                isnull((select top 1 'S' as tiene_contr                                                                 " & vbcrlf & _
"                        from   contratos                                                                                " & vbcrlf & _
"                        where  post_ncorr = b.post_ncorr                                                                " & vbcrlf & _
"                               and econ_ccod <> 3), 'N')             as tiene_contrato,                                 " & vbcrlf & _
"                isnull((select top 1 'SI' as tiene_contr                                                                " & vbcrlf & _
"                        from   contratos                                                                                " & vbcrlf & _
"                        where  post_ncorr = b.post_ncorr                                                                " & vbcrlf & _
"                               and econ_ccod <> 3), 'NO')            as c_contrato                                      " & vbcrlf & _
"from   personas_postulante as a                                                                                         " & vbcrlf & _
"       inner join postulantes as b                                                                                      " & vbcrlf & _
"               on a.pers_ncorr = b.pers_ncorr                                                                           " & vbcrlf & _
"                  and b.epos_ccod = 2                                                                                   " & vbcrlf & _
"                  and b.tpos_ccod in ( 1, 2 )                                                                           " & vbcrlf & _
"                  and b.audi_tusuario not like '%ajus%'                                                                 " & vbcrlf & _
"                  and cast(b.pers_ncorr as VARCHAR) = '" & codigo & "'                                                  " & vbcrlf & _
"                  and b.peri_ccod = " & v_peri_ccod & "                                                                 " & vbcrlf & _
"       inner join detalle_postulantes as c                                                                              " & vbcrlf & _
"               on b.post_ncorr = c.post_ncorr                                                                           " & vbcrlf & _
"       inner join ofertas_academicas as d                                                                               " & vbcrlf & _
"               on c.ofer_ncorr = d.ofer_ncorr                                                                           " & vbcrlf & _
"                  and d.ofer_bactiva = 'N'                                                                              " & vbcrlf & _
"       inner join especialidades as e                                                                                   " & vbcrlf & _
"               on d.espe_ccod = e.espe_ccod                                                                             " & vbcrlf & _
"       inner join carreras as f                                                                                         " & vbcrlf & _
"               on e.carr_ccod = f.carr_ccod                                                                             " & vbcrlf & _
"       inner join jornadas as g                                                                                         " & vbcrlf & _
"               on d.jorn_ccod = g.jorn_ccod                                                                             " & vbcrlf & _
"       inner join sedes as h                                                                                            " & vbcrlf & _
"               on d.sede_ccod = h.sede_ccod                                                                             " & vbcrlf & _
"       left outer join estado_examen_postulantes as i                                                                   " & vbcrlf & _
"                    on c.eepo_ccod = i.eepo_ccod                                                                        "
'----------------------------------------------------------------------------------fin nueva consulta 2008

fc_postulante.Consultar sql_postulante

num = fc_postulante.nrofilas

detalle_grabado = ""
ya_grabado = conexion.ConsultaUno("select case count(*) when 0 then 'NO' else 'SI' end from compromisos where tcom_ccod=27 and cast(pers_ncorr as varchar)='"&codigo&"' and ecom_ccod <> 3  and cast(peri_ccod as varchar)='"&v_peri_ccod&"'")

if ya_grabado = "SI" then
    detalle_grabado = conexion.ConsultaUno("select top 1 'Cargo de Pase Escolar generado por '+b.pers_tnombre+' '+ b.pers_tape_paterno + ' el día ' + protic.trunc(a.audi_fmodificacion)+' por un monto de '+cast(comp_mneto as varchar)  from compromisos a, personas b where a.audi_tusuario = cast(b.pers_nrut as varchar) and tcom_ccod=27 and cast(a.pers_ncorr as varchar)='"&codigo&"' and ecom_ccod <> 3  and cast(peri_ccod as varchar)='"&v_peri_ccod&"' order by a.audi_fmodificacion desc")
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

function pase_escolar(tipo)
{
	if(tipo == 'S')
	 {
	   if (confirm("¿Esta seguro que desea generar el cargo en cuenta corriente de pase nuevo por $ 2.700.-?"))
	   {
	      document.postulaciones.action = "cargo_pase_escolar_proc.asp?post_bnuevo="+tipo;
		  document.postulaciones.submit();
	   }
	 }
	else if (tipo == 'N')
	{
	   if (confirm("¿Esta seguro que desea generar el cargo en cuenta corriente de pase renovante por $ 1.100.-?"))
	   {
	      document.postulaciones.action = "cargo_pase_escolar_proc.asp?post_bnuevo="+tipo;
		  document.postulaciones.submit();
	   }
	 }
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
					<form name="postulaciones" method="post" target="_self">
					<input type="hidden" name="pers_ncorr_contratante" value="<%=codigo%>">
					<tr> 
                      <td  colspan="3"><%pagina.DibujarSubtitulo "Seleccione Carrera"%></td>
					</tr>
					<tr> 
                      <td  colspan="3" align="center"><%fc_postulante.dibujatabla()%></td>
					</tr>
					<tr> 
                      <td colspan="3">&nbsp;</td>
					</tr>
					<tr> 
                      <td colspan="3">
					  	<table width="50%" cellpadding="0" cellspacing="0" align="center">
							<tr>
								<td width="50%" align="center"><%  if num = 0 or detalle_grabado <> "" then
								                                     botonera.AgregaBotonParam "nuevos","deshabilitado","true"
								                                   end if
								                                   botonera.dibujaboton "nuevos"%></td>
								<td width="50%" align="center"><%  if num = 0 or detalle_grabado <> "" then
								                                     botonera.AgregaBotonParam "antiguos","deshabilitado","true"
								                                   end if
								                                   botonera.dibujaboton "antiguos"%></td>
							</tr>
						</table>
					  </td>
					</tr>
					<tr> 
                      <td colspan="3" align="center"><font size="3" color="#990000">
					      <%if detalle_grabado <> "" then
						      response.Write(detalle_grabado)
						    end if
						   %></font>
					  </td>
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
					  <td width="40%">
					   <% if ultimo_post_ncorr <> "" then
					      botonera.agregabotonparam "imprimir_alumno", "url", "../REPORTESNET/ficha_alumno.aspx?post_ncorr=" &  ultimo_post_ncorr  
    					  botonera.dibujaboton "imprimir_alumno" 
						  end if%>
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
