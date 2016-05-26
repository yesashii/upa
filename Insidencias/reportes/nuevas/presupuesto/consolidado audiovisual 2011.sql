select area_tdesc as area,ccen_tdesc  as concepto,nombremes as mes,ccau_ncantidad  as cantidad,esol_tdesc as estado,ccau_tdesc as detalle
from presupuesto_upa.protic.centralizar_solicitud_audiovisual a, 
presupuesto_upa.protic.concepto_centralizado b,
presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d,
presupuesto_upa.protic.area_presupuestal e    
where a.tpre_ccod in (1) and a.tpre_ccod=b.tpre_ccod   
and a.ccen_ccod=b.ccen_ccod   
and a.esol_ccod=c.esol_ccod   
and isnull(mes_ccod,1)=d.indice   
and a.esol_ccod not in (2)   
--and area_ccod= 1
and a.area_ccod=e.area_ccod  
and anio_ccod= 2011