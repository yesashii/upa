<%
function ExtraeAcentosCaracteres (cadena)
cadena=trim(cadena) 
cadena=Replace(cadena,"�", "&aacute;")
cadena=Replace(cadena,"�", "&Aacute;")
cadena=Replace(cadena,"�", "&eacute;")
cadena=Replace(cadena,"�", "&Eacute;")
cadena=Replace(cadena,"�", "&iacute;")
cadena=Replace(cadena,"�", "&Iacute;")
cadena=Replace(cadena,"�", "&oacute")
cadena=Replace(cadena,"�", "&Oacute")
cadena=Replace(cadena,"�", "&uacute;")
cadena=Replace(cadena,"�", "&Uacute;")
cadena=Replace(cadena,"�", "&ntilde;")
cadena=Replace(cadena,"�", "&Ntilde;")
ExtraeAcentosCaracteres=cadena
end function

%>
