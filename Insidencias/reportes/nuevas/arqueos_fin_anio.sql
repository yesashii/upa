--------------------------------------------------------------------
-- Arqueo de letras
select a.*,edin_tdesc as estado,protic.obtener_dato_docto(a.num,4,'C') as caja, protic.obtener_rut(protic.obtener_dato_docto(a.num,3,'P')) as codeudor,
isnull(protic.obtener_rut(case when len(protic.obtener_caja_rut(descripcion,'R'))<1 then null else protic.obtener_caja_rut(descripcion,'R') end),protic.obtener_rut(protic.obtener_dato_docto(a.num,5,'A')))as Rut_alumno
from fox..sd_arqueo_letra_saldo a, estados_detalle_ingresos b
where protic.obtener_dato_docto(a.num,4,'E')*=b.edin_ccod



--------------------------------------------------------------------
-- Arqueos cheques
select a.*,(select banc_tdesc from bancos where banc_ccod=protic.obtener_dato_docto(a.num,3,'B')) as banco,edin_tdesc as estado,
isnull(protic.obtener_rut(case when len(protic.obtener_caja_rut(descripcion,'R'))<1 then null else protic.obtener_caja_rut(descripcion,'R') end),protic.obtener_rut(protic.obtener_dato_docto(a.num,3,'A')))as Rut_alumno,
protic.obtener_rut(protic.obtener_dato_docto(a.num,3,'P')) as codeudor,protic.obtener_dato_docto(a.num,3,'C') as caja,protic.obtener_dato_docto(a.num,3,'B') as cod_banco
from fox..sd_arqueo_cheque_saldo a, estados_detalle_ingresos b
where protic.obtener_dato_docto(a.num,3,'E')*=b.edin_ccod



--------------------------------------------------------------------
--Arqueos Transbank
select a.*,edin_tdesc as estado,protic.obtener_rut(protic.obtener_dato_docto(case when len(a.num)>5 then left(cast(a.num as varchar),len(a.num)-len(protic.obtener_caja_rut(descripcion,'F'))) else a.num end,52,'P')) as codeudor,
isnull(protic.obtener_rut(case when len(protic.obtener_caja_rut(descripcion,'R'))<1 then null else protic.obtener_caja_rut(descripcion,'R') end),protic.obtener_rut(protic.obtener_dato_docto(a.num,52,'A')))as Rut_alumno,
protic.obtener_dato_docto(case when len(a.num)>5 then left(cast(a.num as varchar),len(a.num)-len(protic.obtener_caja_rut(descripcion,'F'))) else a.num end,52,'C') as caja
from fox..sd_arqueo_transbank_saldo a, estados_detalle_ingresos b
where protic.obtener_dato_docto(case when len(a.num)>5 then left(cast(a.num as varchar),len(a.num)-len(protic.obtener_caja_rut(descripcion,'F'))) else a.num end,52,'E')*=b.edin_ccod



--------------------------------------------------------------------
--Arqueo Pagares antiguos
select a.*,edin_tdesc as estado,protic.obtener_rut(protic.obtener_dato_docto(a.num,5,'P')) as codeudor,
isnull(protic.obtener_rut(case when len(protic.obtener_caja_rut(descripcion,'R'))<1 then null else protic.obtener_caja_rut(descripcion,'R') end),protic.obtener_rut(protic.obtener_dato_docto(a.num,5,'A'))) as Rut_alumno,
protic.obtener_dato_docto(a.num,5,'C') as caja
from fox..sd_arqueo_pagare_final a, estados_detalle_ingresos b
where protic.obtener_dato_docto(a.num,5,'E')*=b.edin_ccod



--------------------------------------------------------------------
-- Arqueos otros documentos
select a.*,(select banc_tdesc from bancos where banc_ccod=protic.obtener_dato_docto(a.num,3,'B')) as banco,edin_tdesc as estado,
isnull(protic.obtener_rut(case when len(protic.obtener_caja_rut(descripcion,'R'))<1 then null else protic.obtener_caja_rut(descripcion,'R') end),protic.obtener_rut(protic.obtener_dato_docto(a.num,3,'A')))as Rut_alumno,
protic.obtener_rut(protic.obtener_dato_docto(a.num,3,'P')) as codeudor,protic.obtener_dato_docto(a.num,3,'C') as caja,protic.obtener_dato_docto(a.num,3,'B') as cod_banco
from fox..sd_arqueo_otros_doc_final a, estados_detalle_ingresos b
where protic.obtener_dato_docto(a.num,3,'E')*=b.edin_ccod


select * from fox..sd_arqueo_letra_saldo