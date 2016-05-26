<%
Class Claalumno
  private conexion
  private thisRut

  Public Sub Inicializa(str_conexion, int_rut)
    set conexion  = str_conexion
    thisRut       = int_rut
  end sub

  Public function getCodCarrera()

    codcarrera  = 0

    set formulario = new CFormulario
    formulario.Carga_Parametros "tabla_vacia.xml", "tabla"
    formulario.Inicializar conexion

    str_consulta1 = ""& vbCrLf &_
    "-- Entrada	: rut sin digito verificador del alumno. 																		"& vbCrLf &_
    "-- Salida 	: Una sola fila con el plan y el código de la carrera												"& vbCrLf &_
    "select car.carr_ccod as carr_ccod                                                    	"& vbCrLf &_
    "from   personas as ta                                                                 	"& vbCrLf &_
    "       inner join alumnos as alu                                                      	"& vbCrLf &_
    "               on ta.pers_ncorr = alu.pers_ncorr                                      	"& vbCrLf &_
    "                  and alu.audi_fmodificacion = (select Max(audi_fmodificacion)        	"& vbCrLf &_
    "                                                from   alumnos xx 					   					"& vbCrLf &_
    "                                                where  xx.pers_ncorr = ta.pers_ncorr) 	"& vbCrLf &_
    "       inner join estados_matriculas as esm                                           	"& vbCrLf &_
    "               on alu.emat_ccod = esm.emat_ccod                                       	"& vbCrLf &_
    "                  and esm.emat_ccod <> 9                                              	"& vbCrLf &_
    "       inner join ofertas_academicas as ofa                                           	"& vbCrLf &_
    "               on alu.ofer_ncorr = ofa.ofer_ncorr                                     	"& vbCrLf &_
    "       inner join periodos_academicos as pea                                          	"& vbCrLf &_
    "               on ofa.peri_ccod = pea.peri_ccod                                       	"& vbCrLf &_
    "       inner join especialidades as esp                                               	"& vbCrLf &_
    "               on ofa.espe_ccod = esp.espe_ccod                                       	"& vbCrLf &_
    "       inner join carreras as car                                                     	"& vbCrLf &_
    "               on esp.carr_ccod = car.carr_ccod                                       	"& vbCrLf &_
    "       inner join salidas_carrera as sac                                              	"& vbCrLf &_
    "		 			on car.carr_ccod = sac.carr_ccod                                   						"& vbCrLf &_
    "		 			and sac.tsca_ccod = 1                                              						"& vbCrLf &_
    "					and sac.audi_fmodificacion = (select Max(audi_fmodificacion)       						"& vbCrLf &_
    "                                    	from   salidas_carrera xx                      		"& vbCrLf &_
    "                                       where  xx.carr_ccod = sac.carr_ccod)           	"& vbCrLf &_
    "where  Cast(ta.pers_nrut as varchar) = '"&thisRut&"'                               	  "

    prueba = "<pre>"&str_consulta1&"</pre>"

    formulario.Consultar str_consulta1
    while formulario.siguiente
      codcarrera = formulario.obtenerValor("carr_ccod")
    wend

    'getCodCarrera = prueba
    getCodCarrera = codcarrera

  end function

  Public function getPersNCorr()

    set formulario = new CFormulario
    formulario.Carga_Parametros "tabla_vacia.xml", "tabla"
    formulario.Inicializar conexion

    pers_ncorr = 0

    consulta      = "select pers_ncorr from personas where pers_nrut = "&thisRut
    formulario.Consultar consulta
    while formulario.siguiente
      pers_ncorr = formulario.obtenerValor("pers_ncorr")
    wend

    getPersNCorr  = pers_ncorr
    'response.write("<pre>"&consulta&"</pre>")
    'response.end()

  end function

  Public function getUltimoAnioCarrera(CodCarrera, PersNCorr)

    consulta              = "select protic.obtener_ultimo_anio_carrera("&CodCarrera&","&PersNCorr&")"
    anioSalida            = conexion.ConsultaUno (consulta)
    getUltimoAnioCarrera  = anioSalida
    'response.write("<pre>"&consulta&"</pre>")
    'response.end()

  end function

End class
%>
