update detalle_ingresos set ding_tcuenta_corriente= b.num_tarjeta
from detalle_ingresos a join sd_nro_pagare b
on  a.ding_ndocto=b.num_pagare
and a.ting_ccod=52

-- select para comprobar los cambios
select a.ding_ndocto,b.num_pagare,a.DING_TCUENTA_CORRIENTE, b.num_tarjeta
from detalle_ingresos a join sd_nro_pagare b
on  a.ding_ndocto=b.num_pagare
and ting_ccod=52 
