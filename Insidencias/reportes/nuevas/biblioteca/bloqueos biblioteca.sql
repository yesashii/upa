select protic.obtener_rut(pers_ncorr) as rut, protic.obtener_nombre_completo(pers_ncorr,'n') as nombre_alumno, 
bloq_ncorr as num_bloqueo,tblo_tdesc as tipo_bloqueo, sede_tdesc as sede, eblo_tdesc as estado_bloqueo,
bloq_tobservacion as motivo_bloqueo, protic.trunc(bloq_fbloqueo) as fecha_bloqueo
from bloqueos a, tipos_bloqueos b, sedes c, estados_bloqueos d
where a.tblo_ccod=b.tblo_ccod
and a.sede_ccod=c.sede_ccod
and a.eblo_ccod=d.eblo_ccod
and b.tblo_ccod=8
and a.eblo_ccod=1
and convert(datetime,bloq_fbloqueo,103) >= convert(datetime,'01/12/2011',103)

