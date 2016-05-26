<%
function ExtraeAcentosCaracteres (cadena)
cadena=trim(cadena) 
cadena=Replace(cadena,"á", "&aacute;")
cadena=Replace(cadena,"Á", "&Aacute;")
cadena=Replace(cadena,"é", "&eacute;")
cadena=Replace(cadena,"É", "&Eacute;")
cadena=Replace(cadena,"í", "&iacute;")
cadena=Replace(cadena,"Í", "&Iacute;")
cadena=Replace(cadena,"ó", "&oacute")
cadena=Replace(cadena,"Ó", "&Oacute")
cadena=Replace(cadena,"ú", "&uacute;")
cadena=Replace(cadena,"Ú", "&Uacute;")
cadena=Replace(cadena,"ñ", "&ntilde;")
cadena=Replace(cadena,"Ñ", "&Ntilde;")
ExtraeAcentosCaracteres=cadena
end function

%>
