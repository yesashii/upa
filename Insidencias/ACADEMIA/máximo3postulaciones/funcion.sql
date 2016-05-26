create function numero_postulaciones( @v_post_ncorr varchar(45) ) 
returns numeric as 
begin 
  declare @retornar numeric 
set @retornar = ( select Count(*) 
         from   detalle_postulantes a, 
                ofertas_academicas b, 
                especialidades c, 
                carreras d, 
                sedes e, 
                jornadas f, 
                estado_examen_postulantes g 
         where  a.ofer_ncorr = b.ofer_ncorr 
         and    b.espe_ccod = c.espe_ccod 
         and    c.carr_ccod = d.carr_ccod 
         and    b.sede_ccod = e.sede_ccod 
         and    b.jorn_ccod = f.jorn_ccod 
         and    a.eepo_ccod = g.eepo_ccod 
         and    d.ecar_ccod = 1 
         and    d.inst_ccod = 1 
         and    Cast(a.post_ncorr as varchar) = @v_post_ncorr );
  return @retornar 
end