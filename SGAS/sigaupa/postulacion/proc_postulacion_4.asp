<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
' codigo del postulante
v_post_ncorr 	= 	Session("post_ncorr")
v_pare_ccod		=	request.Form("padre[0][pare_ccod]")

if EsVacio(v_post_ncorr) then
	Response.Redirect("inicio.asp")
end if

'-------------------------------------------------------------------------------------------------
Function ObtenerPersNCorr(p_pers_nrut, conexion)
	dim consulta, v_pers_ncorr
	consulta = "select pers_ncorr from personas_postulante where pers_nrut = '" & p_pers_nrut & "'"	
	v_pers_ncorr = conexion.ConsultaUno(consulta)	
	
	if EsVacio(v_pers_ncorr) then
		consulta = "select pers_ncorr from personas where pers_nrut = '" & p_pers_nrut & "'"	
		v_pers_ncorr = conexion.ConsultaUno(consulta)
	end if
	
	if EsVacio(v_pers_ncorr) then
		consulta = "Exec obtenerSecuencia 'personas' "
		v_pers_ncorr = conexion.ConsultaUno(consulta)
	end if
	ObtenerPersNCorr = v_pers_ncorr	
End Function


set conexion = new CConexion
conexion.Inicializar "upacifico"

'conexion.EstadoTransaccion false

'-------------------------------------------------------------------------------------------------
set f_grupo_familiar = new CFormulario
f_grupo_familiar.Carga_Parametros "postulacion_4.xml", "grupo_familiar"
f_grupo_familiar.Inicializar conexion
f_grupo_familiar.ProcesaForm

set f_direcciones = new CFormulario
f_direcciones.Carga_Parametros "postulacion_4.xml", "direcciones"
f_direcciones.Inicializar conexion
f_direcciones.ProcesaForm


'-------------------------------------------------------------------------------------------------
' Obtencion dels exo de acuerdo al grado de parentesco
		v_variable = "padre"
		
		select case v_pare_ccod
		case 2
			' si es madre=> sexo=2 (femenino)
			v_sexo_ccod = "2"
		case 1
			v_sexo_ccod="1"
		case else
			v_sexo_ccod="1"
		end select	
'-----------------------------			

'response.Write("Parentesco:"&v_pare_ccod&" Post ncorr:"&v_post_ncorr&" Sexo:"&v_sexo_ccod)
'response.End()	
	if not EsVacio(f_grupo_familiar.ObtenerValorPost(0, "pers_nrut")) then
		v_pers_ncorr = ObtenerPersNCorr(f_grupo_familiar.ObtenerValorPost(0, "pers_nrut"), conexion)
		
		'----------------- INGRESO DEL PARENTESCO -----------------------------------------------------
		
		f_grupo_familiar.AgregaParam "variable", v_variable
		'f_grupo_familiar.AgregaCampoPost "pare_ccod", v_pare_ccod
		f_grupo_familiar.AgregaCampoPost "sexo_ccod", v_sexo_ccod
		f_grupo_familiar.AgregaCampoPost "pers_ncorr", v_pers_ncorr
		f_grupo_familiar.AgregaCampoPost "post_ncorr", v_post_ncorr
		f_grupo_familiar.AgregaCampoPost "tdir_ccod", "1"
		f_grupo_familiar.AgregaCampoPost "pers_tfono", f_grupo_familiar.ObtenerValorPost(0, "dire_tfono")
		
		f_grupo_familiar.MantieneTablas false
		'response.Write("<hr>INGRESO DE LA DIRECCIONES<HR>")
		
		'----------------- INGRESO DE LA DIRECCIONES -----------------------------------------------------
		f_direcciones.AgregaParam "variable", v_variable
		f_direcciones.AgregaCampoPost "pers_ncorr", v_pers_ncorr
		f_direcciones.AgregaCampoPost "tdir_ccod", "3"
		f_direcciones.AgregaCampoPost "dire_tcalle", f_direcciones.ObtenerValorPost (0, "dire_tcalle_empresa")
		f_direcciones.AgregaCampoPost "dire_tnro", f_direcciones.ObtenerValorPost (0, "dire_tnro_empresa")
		f_direcciones.AgregaCampoPost "dire_tpoblacion", f_direcciones.ObtenerValorPost (0, "dire_tpoblacion_empresa")
		f_direcciones.AgregaCampoPost "dire_tfono", f_direcciones.ObtenerValorPost (0, "dire_tfono_empresa")
		f_direcciones.AgregaCampoPost "ciud_ccod", f_direcciones.ObtenerValorPost (0, "ciud_ccod_empresa")
		
		f_direcciones.MantieneTablas false
	end if



'conexion.estadotransaccion false
'response.End()
'---------------------------------------------------------------------------------------------------------------
'Response.Redirect("postulacion_4.asp")
%>
<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript" >
CerrarActualizar();
</script>

