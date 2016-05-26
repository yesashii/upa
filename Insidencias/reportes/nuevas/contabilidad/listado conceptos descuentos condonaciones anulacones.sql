select ting_ccod,ting_cuenta_softland, ting_tdesc as concepto, ereg_tdesc as uso_concepto
from tipos_ingresos a, estados_regularizados b 
where a.ting_bregularizacion='S' 
and a.ereg_ccod=b.ereg_ccod