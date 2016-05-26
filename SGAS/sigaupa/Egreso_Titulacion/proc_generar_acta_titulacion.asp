<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%
set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new Cnegocio
negocio.Inicializa conexion

v_usuario = negocio.ObtenerUsuario

set f_acta = new CFormulario
f_acta.Carga_Parametros "lista_titulados.xml", "nueva_acta"
f_acta.Inicializar conexion
f_acta.ProcesaForm
'f_acta.ListarPost

v_acti_ncorr = conexion.ConsultaUno("SELECT acti_ncorr_seq.nextval FROM dual")
v_fecha = negocio.ObtenerFechaActual

f_acta.AgregaCampoPost "acti_ncorr", v_acti_ncorr
f_acta.AgregaCampoPost "acti_femision", v_fecha

f_acta.MantieneTablas false


sentencia = "insert into detalle_actas_titulacion (acti_ncorr, reti_ncorr, audi_tusuario, audi_fmodificacion) " & vbCrLf &_
            "select " & v_acti_ncorr & ", b.reti_ncorr, '" & v_usuario & "', sysdate " & vbCrLf &_
			"from (select egre_ncorr, min(cumplido) as cumplido, decode(min(cumplido),1,max(reti_ftermino)) as fecha_entrega " & vbCrLf &_
			"      from (select a.egre_ncorr, a.repl_ncorr, " & vbCrLf &_
			"                   decode(a.repl_bobligatorio,'S','S','N',decode(b.reti_ncorr, null, 'N', 'S')) as obligatorio, " & vbCrLf &_
			"            	    decode(b.ereq_ccod,1,1,0) as cumplido, " & vbCrLf &_
			"            	     b.reti_ftermino " & vbCrLf &_
			"            from (select a.egre_ncorr, b.repl_ncorr, b.repl_bobligatorio " & vbCrLf &_
			"                  from egresados a, requisitos_plan b " & vbCrLf &_
			"                  where a.plan_ccod = b.plan_ccod " & vbCrLf &_
			"                    and a.sede_ccod = b.sede_ccod " & vbCrLf &_
			"                    and a.peri_ccod = b.peri_ccod " & vbCrLf &_
			"                    and a.plan_ccod = '" & f_acta.ObtenerValorPost(0, "plan_ccod") & "' " & vbCrLf &_
			"					 and a.espe_ccod = '" & f_acta.ObtenerValorPost(0, "espe_ccod") & "' " & vbCrLf &_
			"                    and a.peri_ccod = '" & f_acta.ObtenerValorPost(0, "peri_ccod") & "' " & vbCrLf &_
			"                    and a.sede_ccod = '" & f_acta.ObtenerValorPost(0, "sede_ccod") & "' " & vbCrLf &_
			"                  order by a.egre_ncorr, b.treq_ccod) a, requisitos_titulacion b " & vbCrLf &_
			"            where a.egre_ncorr = b.egre_ncorr (+) " & vbCrLf &_
			"              and a.repl_ncorr = b.repl_ncorr (+) ) " & vbCrLf &_
			"      where obligatorio = 'S' " & vbCrLf &_
			"      group by egre_ncorr " & vbCrLf &_
			"      having min(cumplido) = 1 " & vbCrLf &_
			"      ) a, requisitos_titulacion b " & vbCrLf &_
			"where a.egre_ncorr = b.egre_ncorr " & vbCrLf &_
			"  and not exists (select 1 from detalle_actas_titulacion where reti_ncorr = b.reti_ncorr)"

'response.Write("<pre>"&sentencia&"</pre><hr>")
conexion.EstadoTransaccion conexion.EjecutaS (sentencia)


'-----------------------------------------------------------------------------------------------------------------------
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "consulta.xml", "consulta"
f_consulta.Inicializar conexion

consulta = "select c.egre_ncorr, to_char(a.acti_femision, 'dd/mm/yyyy') as acti_femision, to_char(max(c.reti_ftermino), 'dd/mm/yyyy') as ftermino " & vbCrLf &_
           "from actas_titulacion a, detalle_actas_titulacion b, requisitos_titulacion c " & vbCrLf &_
		   "where a.acti_ncorr = b.acti_ncorr " & vbCrLf &_
		   "  and b.reti_ncorr = c.reti_ncorr " & vbCrLf &_
		   "  and a.acti_ncorr = '" & v_acti_ncorr & "' " & vbCrLf &_
		   "group by c.egre_ncorr, a.acti_femision"
		   
f_consulta.Consultar consulta
while f_consulta.Siguiente
	sentencia = "UPDATE egresados " & vbCrLf &_
	            "	SET egre_fentrega_req = to_date('" & f_consulta.ObtenerValor("ftermino") & "', 'dd/mm/yyyy'), " & vbCrLf &_
				"       egre_ftitulacion = to_date('" & f_consulta.ObtenerValor("acti_femision") & "', 'dd/mm/yyyy') " & vbCrLf &_
				"WHERE egre_ncorr = '" & f_consulta.ObtenerValor("egre_ncorr") & "'"

	'response.Write("<pre>"&sentencia&"</pre><hr>")			
	conexion.EstadoTransaccion conexion.EjecutaS (sentencia)
wend




'-----------------------------------------------------------------------------------------------------------------------
'conexion.EstadoTransaccion conexion.EjecutaP ("registra_numeros_titulo(" & v_acti_ncorr & ")")
'---------------------------------------------------------------------------------------------

Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>