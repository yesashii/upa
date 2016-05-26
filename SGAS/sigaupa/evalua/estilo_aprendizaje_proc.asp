<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
'-----------------------------------------------------
'for each k in request.form
	'response.Write(k&" = "&request.Form(k)&"<br>")
'next

'response.End()

set conectar = new cconexion
conectar.inicializar "upacifico"

preg_1=request.Form("p[0][preg_1]")
preg_2=request.Form("p[0][preg_2]")
preg_3=request.Form("p[0][preg_3]")
preg_4=request.Form("p[0][preg_4]")
preg_5=request.Form("p[0][preg_5]")
preg_6=request.Form("p[0][preg_6]")
preg_7=request.Form("p[0][preg_7]")
preg_8=request.Form("p[0][preg_8]")
preg_9=request.Form("p[0][preg_9]")
preg_10=request.Form("p[0][preg_10]")
preg_11=request.Form("p[0][preg_11]")
preg_12=request.Form("p[0][preg_12]")
preg_13=request.Form("p[0][preg_13]")
preg_14=request.Form("p[0][preg_14]")
preg_15=request.Form("p[0][preg_15]")
preg_16=request.Form("p[0][preg_16]")
preg_17=request.Form("p[0][preg_17]")
preg_18=request.Form("p[0][preg_18]")
preg_19=request.Form("p[0][preg_19]")
preg_20=request.Form("p[0][preg_20]")
preg_21=request.Form("p[0][preg_21]")
preg_22=request.Form("p[0][preg_22]")
preg_23=request.Form("p[0][preg_23]")
preg_24=request.Form("p[0][preg_24]")
preg_25=request.Form("p[0][preg_25]")
preg_26=request.Form("p[0][preg_26]")
preg_27=request.Form("p[0][preg_27]")
preg_28=request.Form("p[0][preg_28]")
preg_29=request.Form("p[0][preg_29]")
preg_30=request.Form("p[0][preg_30]")
preg_31=request.Form("p[0][preg_31]")
preg_32=request.Form("p[0][preg_32]")
preg_33=request.Form("p[0][preg_33]")
preg_34=request.Form("p[0][preg_34]")
preg_35=request.Form("p[0][preg_35]")
preg_36=request.Form("p[0][preg_36]")
preg_37=request.Form("p[0][preg_37]")
preg_38=request.Form("p[0][preg_38]")
preg_39=request.Form("p[0][preg_39]")
preg_40=request.Form("p[0][preg_40]")
preg_41=request.Form("p[0][preg_41]")
preg_42=request.Form("p[0][preg_42]")
preg_43=request.Form("p[0][preg_43]")
preg_44=request.Form("p[0][preg_44]")
preg_45=request.Form("p[0][preg_45]")
preg_46=request.Form("p[0][preg_46]")
preg_47=request.Form("p[0][preg_47]")
preg_48=request.Form("p[0][preg_48]")
preg_49=request.Form("p[0][preg_49]")
preg_50=request.Form("p[0][preg_50]")
preg_51=request.Form("p[0][preg_51]")
preg_52=request.Form("p[0][preg_52]")
preg_53=request.Form("p[0][preg_53]")
preg_54=request.Form("p[0][preg_54]")
preg_55=request.Form("p[0][preg_55]")
preg_56=request.Form("p[0][preg_56]")
preg_57=request.Form("p[0][preg_57]")
preg_58=request.Form("p[0][preg_58]")
preg_59=request.Form("p[0][preg_59]")
preg_60=request.Form("p[0][preg_60]")
preg_61=request.Form("p[0][preg_61]")
preg_62=request.Form("p[0][preg_62]")
preg_63=request.Form("p[0][preg_63]")
preg_64=request.Form("p[0][preg_64]")
preg_65=request.Form("p[0][preg_65]")
preg_66=request.Form("p[0][preg_66]")
preg_67=request.Form("p[0][preg_67]")
preg_68=request.Form("p[0][preg_68]")
preg_69=request.Form("p[0][preg_69]")
preg_70=request.Form("p[0][preg_70]")
preg_71=request.Form("p[0][preg_71]")
preg_72=request.Form("p[0][preg_72]")
preg_73=request.Form("p[0][preg_73]")
preg_74=request.Form("p[0][preg_74]")
preg_75=request.Form("p[0][preg_75]")
preg_76=request.Form("p[0][preg_76]")
preg_77=request.Form("p[0][preg_77]")
preg_78=request.Form("p[0][preg_78]")
preg_79=request.Form("p[0][preg_79]")
preg_80=request.Form("p[0][preg_80]")
observaciones=request.Form("p[0][observaciones]")
carr_ccod=request.Form("encu[0][carr_ccod]")
pers_ncorr=request.Form("encu[0][pers_ncorr]") 


'response.Write(esapre_ncorr)
'response.End()

existe= conectar.consultaUno("select count(*) from encuesta_estilo_aprendizaje where pers_ncorr="&pers_ncorr&"")


if existe="0" then
fecha= conectar.consultaUno("select protic.trunc(getDate())")
esapre_ncorr = conectar.ConsultaUno("exec ObtenerSecuencia 'encuesta_estilo_aprendizaje'")
insert= "insert into encuesta_estilo_aprendizaje (esapre_ncorr,pers_ncorr,carr_ccod,preg_1,preg_2,preg_3,preg_4,preg_5,preg_6,preg_7,preg_8,preg_9,preg_10,preg_11,preg_12,preg_13,preg_14,preg_15,preg_16,preg_17,preg_18,preg_19,preg_20,preg_21,preg_22,preg_23,preg_24,preg_25,preg_26,preg_27,preg_28,preg_29,preg_30,preg_31,preg_32,preg_33,preg_34,preg_35,preg_36,preg_37,preg_38,preg_39,preg_40,preg_41,preg_42,preg_43,preg_44,preg_45,preg_46,preg_47,preg_48,preg_49,preg_50,preg_51,preg_52,preg_53,preg_54,preg_55,preg_56,preg_57,preg_58,preg_59,preg_60,preg_61,preg_62,preg_63,preg_64,preg_65,preg_66,preg_67,preg_68,preg_69,preg_70,preg_71,preg_72,preg_73,preg_74,preg_75,preg_76,preg_77,preg_78,preg_79,preg_80,observaciones,fecha) values("&esapre_ncorr&","&pers_ncorr&",'"&carr_ccod&"',"&preg_1&","&preg_2&","&preg_3&","&preg_4&","&preg_5&","&preg_6&","&preg_7&","&preg_8&","&preg_9&","&preg_10&","&preg_11&","&preg_12&","&preg_13&","&preg_14&","&preg_15&","&preg_16&","&preg_17&","&preg_18&","&preg_19&","&preg_20&","&preg_21&","&preg_22&","&preg_23&","&preg_24&","&preg_25&","&preg_26&","&preg_27&","&preg_28&","&preg_29&","&preg_30&","&preg_31&","&preg_32&","&preg_33&","&preg_34&","&preg_35&","&preg_36&","&preg_37&","&preg_38&","&preg_39&","&preg_40&","&preg_41&","&preg_42&","&preg_43&","&preg_44&","&preg_45&","&preg_46&","&preg_47&","&preg_48&","&preg_49&","&preg_50&","&preg_51&","&preg_52&","&preg_53&","&preg_54&","&preg_55&","&preg_56&","&preg_57&","&preg_58&","&preg_59&","&preg_60&","&preg_61&","&preg_62&","&preg_63&","&preg_64&","&preg_65&","&preg_66&","&preg_67&","&preg_68&","&preg_69&","&preg_70&","&preg_71&","&preg_72&","&preg_73&","&preg_74&","&preg_75&","&preg_76&","&preg_77&","&preg_78&","&preg_79&","&preg_80&",'"&observaciones&"','"&fecha&"') "

conectar.ejecutaS (insert)
'response.Write("respuesta "&insert)
Respuesta = conectar.ObtenerEstadoTransaccion()
'----------------------------------------------------
'response.Write("Insert "&insert)

end if

'response.End()
'----------------------------------------------------

response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>


