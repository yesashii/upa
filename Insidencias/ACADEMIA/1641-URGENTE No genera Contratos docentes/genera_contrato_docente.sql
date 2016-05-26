use [sigaupa] 

go 

/****** Object:  StoredProcedure [dbo].[GENERA_CONTRATO_DOCENTE]    Script Date: 02/29/2016 13:02:14 ******/ 
set ansi_nulls on 

go 

set quoted_identifier off 

go 

alter procedure [dbo].[genera_contrato_docente] (@p_pers_ncorr    numeric, 
                                                 @p_sede_ccod     numeric, 
                                                 @p_carr_ccod     char(3), 
                                                 @p_jorn_ccod     numeric, 
                                                 @p_tcdo_ccod     numeric, 
                                                 @p_audi_tusuario varchar(250)) 
as 
  begin 
      ------  Variables Generales -------- 
      declare @v_contrato numeric -----\ 
      declare @v_anex_ncorr numeric ----> Llaves 
      declare @v_dane_ncorr numeric -- / 
      declare @v_num_anexo numeric -- codigo del anexo 
      declare @v_fecha_inicio datetime 
      declare @v_fecha_fin datetime 
      declare @v_ano_actual numeric 
      declare @v_inicio_reg varchar(10) 
      declare @v_fin_reg varchar(10) 
      declare @v_mes_actual numeric 
      declare @v_mes_i_reg numeric 
      declare @v_mes_f_reg numeric 
      declare @v_num_cuotas numeric 
      declare @v_tipo_profe numeric 
      declare @v_horas_maximas numeric 
      declare @v_horas_asignadas numeric 
      declare @v_horas integer 
      declare @v_inicio_contrato datetime 
      declare @v_crear_fecha_fin numeric 
      declare @conteo_anexos numeric 
      declare @v_salida numeric 
      declare @v_coodinacion_antigua numeric 
      declare @v_cant_anexo numeric 
      declare @v_sin_fecha_fin numeric 
      declare @v_fin_mes varchar(2) 
      declare @v_fin_mesf varchar(2) 
      declare @v_num_reg numeric 
      declare @v_cont_reg numeric 
      declare @v_ultima_asig varchar(25) 
      declare @v_modo_on numeric 
      ------------------------------------ 
      ------  Variables del cursor c_anexos_escuela  --------- 
      declare @rae_duas_ccod numeric 
      declare @rae_sede_ccod numeric 
      declare @rae_carr_ccod numeric 
      declare @rae_jorn_ccod numeric 
      declare @rae_tcat_ccod numeric 
      declare @rae_seccion numeric 
      declare @rae_tipo_bloque numeric 
      -------------------------------------------------------- 
      ------  Variables del cursor c_detalle_anexos  --------- 
      declare @rda_asig_ccod varchar(25) 
      declare @rda_secc_ccod numeric 
      declare @rda_valor_sesion numeric 
      declare @rda_horas_asig numeric 
      declare @rda_bloque numeric 

      -------------------------------------------------------- 
      --##########    INICIALIZACION DE VARIABLES ###################### 
      select @v_ano_actual = Datepart(year, Getdate()) 

      --select @v_ano_actual=2013 -- año fijo porque se siguen haciendo contratos en enero del año anterior 
      select @v_mes_actual = Datepart(month, Getdate()) 

      set @conteo_anexos=0 
      set @v_salida=1 -- sin error 
      set transaction isolation level serializable 

      begin transaction 

      select @v_tipo_profe = tpro_ccod 
      from   profesores 
      where  pers_ncorr = @p_pers_ncorr 
             and sede_ccod = @p_sede_ccod 

      ------------------------------------------------------------------------------------------ 
      --     Obtiene el ultimo contrato activo que posee el docente 
      select @v_contrato = cdoc_ncorr, 
             @v_fecha_inicio = cdoc_finicio, 
             @v_fecha_fin = cdoc_ffin 
      from   contratos_docentes_upa 
      where  pers_ncorr = @p_pers_ncorr 
             and ecdo_ccod = 1 

      ------------------------------------------------------------------------------------------ 
      if @v_contrato is null -- Crear un nuevo contrato 
        begin 
            set @v_crear_fecha_fin=1 

            --obtiene el ultimo anexo que se habia generado en la contratacion antigua 
            --select @v_num_anexo=max(bloq_anexo) from  bloques_profesores where pers_ncorr=@p_pers_ncorr and proc_ccod is not null
            if @v_num_anexo is null 
              begin 
                  set @v_num_anexo=0 
              end 

            if @v_mes_actual = 3 -- si es Marzo (1er Semestre- Inicio año academico) 
              begin 
                  set @v_inicio_contrato='09-03-' + Cast(@v_ano_actual as varchar) 
                  set @v_mes_actual=null 
              end 
            else 
              begin 
                  if @v_mes_actual = 8 -- si es Agosto (2do Semestre) 
                    begin 
                        set @v_inicio_contrato='05-' + Cast(@v_mes_actual as varchar) + '-' 
                                               + Cast(@v_ano_actual as varchar) 
                    end 
                  else 
                    begin 
                        set @v_inicio_contrato='09-' + Cast(@v_mes_actual as varchar) + '-' 
                                               + Cast(@v_ano_actual as varchar) 
                    end 
              end 

            exec protic.retornarsecuencia 
              'contrato_docente', 
              @v_contrato output 

            insert into contratos_docentes_upa 
                        (cdoc_ncorr, 
                         pers_ncorr, 
                         tpro_ccod, 
                         cdoc_fcontrato, 
                         cdoc_finicio, 
                         ecdo_ccod, 
                         ano_contrato, 
                         tcdo_ccod, 
                         audi_tusuario, 
                         audi_fmodificacion) 
            values      (@v_contrato, 
                         @p_pers_ncorr, 
                         @v_tipo_profe, 
                         Getdate(), 
                         @v_inicio_contrato, 
                         1, 
                         @v_ano_actual, 
                         @p_tcdo_ccod, 
                         @p_audi_tusuario, 
                         Getdate()) 
        end 
      else 
        begin 
            select @v_num_anexo = Max(anex_ncodigo) 
            from   anexos 
            where  cdoc_ncorr = @v_contrato 
                   and eane_ccod not in ( 3 ) 

            --validacion extra (por cualquier anomalia) 
            if @v_num_anexo is null 
              begin 
                  set @v_num_anexo=0 
              end 
        end 

      -- obtiene los anexos a generar en esta escuela para el docente seleccionado 
      declare c_anexos_escuela cursor local static for 
        select f.duas_ccod, 
               a.sede_ccod, 
               d.carr_ccod, 
               d.jorn_ccod, 
               protic.obtiene_categoria_carrera(@p_pers_ncorr, @p_sede_ccod, @p_carr_ccod, @p_jorn_ccod, Max(d.peri_ccod), isnull(b.bloq_ayudantia, 0)) as CATEGORIA,
               Max(d.secc_ccod)                                                                                                                         as secc_ccod,
               isnull(b.bloq_ayudantia, 0)                                                                                                              as tipo_bloque
        from   bloques_profesores a, 
               bloques_horarios b, 
               secciones d, 
               carreras_docente e, 
               asignaturas f 
        where  a.bloq_anexo is null 
               and a.cdoc_ncorr is null 
               and e.tcat_ccod is not null 
               and b.bloq_ccod = a.bloq_ccod 
               and d.secc_ccod = b.secc_ccod 
               and d.carr_ccod = e.carr_ccod 
               and d.sede_ccod = e.sede_ccod 
               and d.jorn_ccod = e.jorn_ccod 
               and e.pers_ncorr = a.pers_ncorr 
               and f.asig_ccod = d.asig_ccod 
               and e.sede_ccod = a.sede_ccod 
               and a.pers_ncorr = @p_pers_ncorr 
               and e.sede_ccod = @p_sede_ccod 
               and e.carr_ccod = @p_carr_ccod 
               and e.jorn_ccod = @p_jorn_ccod 
               --and isnull(D.seccion_completa,'N')='S'  
               and f.duas_ccod not in ( 5 ) 
        group  by a.sede_ccod, 
                  d.carr_ccod, 
                  d.jorn_ccod, 
                  f.duas_ccod, 
                  b.bloq_ayudantia 
        --  order by F.DUAS_CCOD,A.SEDE_CCOD,D.CARR_CCOD,D.JORN_CCOD 
        union 
        select f.duas_ccod, 
               a.sede_ccod, 
               d.carr_ccod, 
               d.jorn_ccod, 
               protic.obtiene_categoria_carrera(@p_pers_ncorr, @p_sede_ccod, @p_carr_ccod, @p_jorn_ccod, d.peri_ccod, isnull(b.bloq_ayudantia, 0)) as CATEGORIA,
               d.secc_ccod, 
               isnull(b.bloq_ayudantia, 0)                                                                                                         as tipo_bloque
        from   bloques_profesores a, 
               bloques_horarios b, 
               secciones d, 
               carreras_docente e, 
               asignaturas f 
        where  a.bloq_anexo is null 
               and a.cdoc_ncorr is null 
               and e.tcat_ccod is not null 
               and b.bloq_ccod = a.bloq_ccod 
               and d.secc_ccod = b.secc_ccod 
               and d.carr_ccod = e.carr_ccod 
               and d.sede_ccod = e.sede_ccod 
               and d.jorn_ccod = e.jorn_ccod 
               and e.pers_ncorr = a.pers_ncorr 
               and f.asig_ccod = d.asig_ccod 
               and e.sede_ccod = a.sede_ccod 
               and a.pers_ncorr = @p_pers_ncorr 
               and e.sede_ccod = @p_sede_ccod 
               and e.carr_ccod = @p_carr_ccod 
               and e.jorn_ccod = @p_jorn_ccod 
               --and isnull(D.seccion_completa,'N')='S' 
               and f.duas_ccod in ( 5 ) 
        group  by a.sede_ccod, 
                  d.carr_ccod, 
                  d.jorn_ccod, 
                  f.duas_ccod, 
                  d.secc_ccod, 
                  d.peri_ccod, 
                  b.bloq_ayudantia 
        order  by f.duas_ccod, 
                  a.sede_ccod, 
                  d.carr_ccod, 
                  d.jorn_ccod 

      ----------------------------------------------------------------------------------- 
      open c_anexos_escuela 

      fetch next from c_anexos_escuela into @rae_duas_ccod, @rae_sede_ccod, @rae_carr_ccod, @rae_jorn_ccod, @rae_tcat_ccod, @rae_seccion, @rae_tipo_bloque

      while @@fetch_status = 0 
        begin 
            if @rae_tcat_ccod is not null 
              begin 
                  -- INSERTA UN NUEVO ANEXO PARA EL CONTRATO ACTIVO DEL DOCENTE 
                  set @v_num_anexo=@v_num_anexo + 1 
                  set @conteo_anexos=@conteo_anexos + 1 

                  --######################################################################## 
                  -----   CALCULO PARA CREAR LAS FECHAS TENTATIVAS DE LOS ANEXOS  ----- 
                  if @rae_duas_ccod = 5 -- regimen periodo de la asignatura 
                    begin 
                        select @v_inicio_reg = Replace(Substring(protic.trunc(secc_finicio_sec), 1, 5), '/', '-'), 
                               @v_fin_reg = Replace(Substring(protic.trunc(secc_ftermino_sec), 1, 5), '/', '-'), 
                               @v_mes_i_reg = Cast(Substring(protic.trunc(secc_finicio_sec), 4, 2)as integer),
                               @v_mes_f_reg = Cast(Substring(protic.trunc(secc_ftermino_sec), 4, 2)as integer)
                        from   secciones 
                        where  secc_ccod = @rae_seccion 
                    end 
                  else 
                    begin 
                        select @v_inicio_reg = preg_inicio, 
                               @v_fin_reg = preg_fin, 
                               @v_mes_i_reg = Cast(Substring(preg_inicio, 4, 2)as integer), 
                               @v_mes_f_reg = Cast(Substring(preg_fin, 4, 2)as integer) 
                        from   planificacion_regimen 
                        where  duas_ccod = @rae_duas_ccod 
                               and tpro_ccod = @v_tipo_profe 
                               and Datepart(month, Getdate()) + 1 between Cast(Substring(preg_inicio, 4, 2)as integer) and Cast(Substring(preg_fin, 4, 2)as integer)
                    end 

                  if @v_mes_actual >= @v_mes_i_reg 
                    begin 
                        if @v_mes_actual > @v_mes_f_reg 
                          begin -- en caso que calcule pasado el periodo asignado (limites fechas  regimen) 
                              set @v_inicio_reg = '01-' + Cast(@v_mes_f_reg as varchar) + '-'
                                                  + Cast(@v_ano_actual as varchar) 
                              set @v_fin_reg = @v_fin_reg + '-' 
                                               + Cast(@v_ano_actual as varchar) 
                          end 
                        else 
                          begin 
                              if @v_mes_actual = @v_mes_i_reg 
                                 and @rae_duas_ccod = 5 --(si es periodo y quedo dentro del mismo mes) 
                                begin 
                                    select @v_fin_mes = fdem_ndia 
                                    from   fin_de_mes 
                                    where  fdem_nmes = @v_mes_i_reg 

                                    select @v_fin_mesf = fdem_ndia 
                                    from   fin_de_mes 
                                    where  fdem_nmes = @v_mes_f_reg 

                                    set @v_inicio_reg = '01-' + Cast(@v_mes_actual as varchar) + '-' 
                                                        + Cast(@v_ano_actual as varchar) 
                                    set @v_fin_reg = Cast(@v_fin_mesf as varchar) + '-' 
                                                     + Cast(@v_mes_f_reg as varchar) + '-' 
                                                     + Cast(@v_ano_actual as varchar) 
                                end 
                              else -- si no es periodo 
                                begin 
                                    if @v_mes_actual = 8 -- si es Agosto (2do Semestre) 
                                      begin 
                                          set @v_inicio_reg='05-' + Cast(@v_mes_actual as varchar) + '-' 
                                                            + Cast(@v_ano_actual as varchar) 
                                          set @v_fin_reg = @v_fin_reg + '-' 
                                                           + Cast(@v_ano_actual as varchar) 
                                      end 
                                    else 
                                      begin 
                                          set @v_inicio_reg = '01-' + Cast(@v_mes_actual as varchar) + '-' 
                                                              + Cast(@v_ano_actual as varchar)
                                          set @v_fin_reg = @v_fin_reg + '-' 
                                                           + Cast(@v_ano_actual as varchar) 
                                      end 
                                end 
                          end 
                    end 
                  else --calculo realizado un mes antes de iniciar la seccion 
                    begin 
                        set @v_inicio_reg = @v_inicio_reg + '-' 
                                            + Cast(@v_ano_actual as varchar) 
                        set @v_fin_reg = @v_fin_reg + '-' 
                                         + Cast(@v_ano_actual as varchar) 
                    end 

                  --print 'inicio: '+cast(@v_inicio_reg as varchar)  
                  --print 'fin: '+cast(@v_fin_reg as varchar)     
                  select @v_num_cuotas = Datediff(month, convert(datetime, @v_inicio_reg, 103), convert(datetime, @v_fin_reg, 103))
                                         + 1 

                  --print 'cuotas '+cast(@v_num_cuotas as varchar)   
                  --############################################################################## 
                  --############################################################################## 
                  --##########    OBTENCION DE LAS HORAS DE COORDINACION PARA EL DOCENTE    ############ 
                  if @v_tipo_profe = 1 
                     and @rae_tipo_bloque = 0 
                    begin 
                        select @v_horas_maximas = duas_nhoras_coordina 
                        from   duracion_asignatura 
                        where  duas_ccod = @rae_duas_ccod 

                        -- CALCULO DE LAS HORAS YA ASIGNADAS (Contratos Nuevos) 
                        select @v_horas_asignadas = Sum(b.anex_nhoras_coordina) 
                        from   contratos_docentes_upa a, 
                               anexos b 
                        where  a.cdoc_ncorr = b.cdoc_ncorr 
                               and a.pers_ncorr = @p_pers_ncorr 
                               and b.sede_ccod = @p_sede_ccod 
                               and b.carr_ccod = @p_carr_ccod 
                               and b.jorn_ccod = @p_jorn_ccod 
                               and a.ecdo_ccod = 1 
                               and b.eane_ccod <> 3 

                        --########################################################### 
                        --################# HORAS CONTRATOS ANTIGUOS ################ 
                        select @v_coodinacion_antigua = Sum(a.hcor_valor1) 
                        from   bloques_profesores a, 
                               bloques_horarios b, 
                               secciones d, 
                               carreras_docente e, 
                               asignaturas f 
                        where  a.bloq_anexo is not null 
                               and a.cdoc_ncorr is not null 
                               and b.bloq_ccod = a.bloq_ccod 
                               and d.secc_ccod = b.secc_ccod 
                               and d.carr_ccod = e.carr_ccod 
                               and d.sede_ccod = e.sede_ccod 
                               and d.jorn_ccod = e.jorn_ccod 
                               and e.pers_ncorr = a.pers_ncorr 
                               and f.asig_ccod = d.asig_ccod 
                               and e.sede_ccod = a.sede_ccod 
                               and a.pers_ncorr = @p_pers_ncorr 
                               and e.sede_ccod = @p_sede_ccod 
                               and e.carr_ccod = @p_carr_ccod 
                               and e.jorn_ccod = @p_jorn_ccod 
                        group  by a.sede_ccod, 
                                  d.carr_ccod, 
                                  d.jorn_ccod 

                        --set @v_coodinacion_antigua=0 
                        --########################################################### 
                        if @v_coodinacion_antigua is null 
                          begin 
                              set @v_coodinacion_antigua=0 
                          end 

                        if @v_horas_asignadas is null 
                          begin 
                              set @v_horas_asignadas=0 
                          end 

                        -- si tenia antes horas de coordinacion por el primer semestre 
                        -- entonces corresponde darle 2 mas para la escuela. 
                        if @v_coodinacion_antigua = 2 
                           and @rae_duas_ccod = 2 
                          begin 
                              set @v_horas_maximas=@v_horas_maximas + 2 
                          end 

                        set @v_horas=@v_horas_maximas - ( @v_horas_asignadas + @v_coodinacion_antigua )

                        if @v_horas <= 0 
                            or @v_tipo_profe <> 1 
                          begin 
                              set @v_horas=0 
                          end 
                    end 
                  else -- si es ayudante 
                    begin 
                        set @v_horas=0 
                    end 

                  --##########################################################################                    
                  exec protic.retornarsecuencia 
                    'anexos', 
                    @v_anex_ncorr output 

                  insert into anexos 
                              (anex_ncorr, 
                               cdoc_ncorr, 
                               anex_ncodigo, 
                               eane_ccod, 
                               tpro_ccod, 
                               anex_finicio, 
                               anex_ffin, 
                               sede_ccod, 
                               carr_ccod, 
                               jorn_ccod, 
                               anex_ncuotas, 
                               anex_nhoras_coordina, 
                               audi_tusuario, 
                               audi_fmodificacion) 
                  values     (@v_anex_ncorr, 
                              @v_contrato, 
                              @v_num_anexo, 
                              1, 
                              @v_tipo_profe, 
                              convert(datetime, @v_inicio_reg, 103), 
                              convert(datetime, @v_fin_reg, 103), 
                              @rae_sede_ccod, 
                              @rae_carr_ccod, 
                              @rae_jorn_ccod, 
                              @v_num_cuotas, 
                              @v_horas, 
                              @p_audi_tusuario, 
                              Getdate()) 

                  --**********************************************************************************************
                  ----------          cursor para detalle de anexo        ------------ 
                  if @rae_duas_ccod = 5 
                    begin 
                        declare c_detalle_anexos cursor local static for 
                          select distinct d.asig_ccod, 
                                          d.secc_ccod, 
                                          protic.obtiene_monto_categoria(@rae_tcat_ccod) as monto,
                                          isnull(case 
                                                   when d.moda_ccod in( 1 ) then isnull(y.hopr_nhoras, case isnull(b.bloq_ayudantia, 0)
                                                                                                         when 0 then protic.retorna_horas_seccion1(d.secc_ccod, @v_tipo_profe, e.pers_ncorr)
                                                                                                         else protic.retorna_horas_tipo_bloque(d.secc_ccod, b.bloq_ayudantia)
                                                                                                       end)
                                                   else isnull(y.hopr_nhoras, d.secc_nhoras_pagar)
                                                 end, 0)                                 as ASIG_NHORAS,
                                          b.bloq_ccod 
                          from   bloques_profesores a 
                                 inner join bloques_horarios b 
                                         on b.bloq_ccod = a.bloq_ccod 
                                            and a.bloq_anexo is null 
                                            and a.pers_ncorr = @p_pers_ncorr 
                                            and isnull(b.bloq_ayudantia, 0) = @rae_tipo_bloque
                                 inner join secciones d 
                                         on d.secc_ccod = b.secc_ccod 
                                            and d.secc_ccod = @rae_seccion 
                                 inner join carreras_docente e 
                                         on d.carr_ccod = e.carr_ccod 
                                            and d.sede_ccod = e.sede_ccod 
                                            and d.jorn_ccod = e.jorn_ccod 
                                            and e.pers_ncorr = a.pers_ncorr 
                                            and e.sede_ccod = a.sede_ccod 
                                            and e.tcat_ccod is not null 
                                            and e.carr_ccod = @p_carr_ccod 
                                            and e.sede_ccod = @p_sede_ccod 
                                            and e.jorn_ccod = @p_jorn_ccod 
                                 inner join asignaturas f 
                                         on f.asig_ccod = d.asig_ccod 
                                            and f.duas_ccod = @rae_duas_ccod 
                                 left outer join horas_profesores y 
                                              on e.pers_ncorr = y.pers_ncorr 
                                                 and d.secc_ccod = y.secc_ccod 
                                                 and isnull(b.bloq_ayudantia, 0) = y.bloq_ayudantia
                                                 and y.hopr_nhoras > 0 
                          order  by d.asig_ccod, 
                                    d.secc_ccod 
                    end 
                  else 
                    begin 
                        declare c_detalle_anexos cursor local static for 
                          select distinct d.asig_ccod, 
                                          d.secc_ccod, 
                                          protic.obtiene_monto_categoria(@rae_tcat_ccod) as monto,
                                          isnull(case 
                                                   when d.moda_ccod in( 1 ) then isnull(y.hopr_nhoras, case isnull(b.bloq_ayudantia, 0)
                                                                                                         when 0 then protic.retorna_horas_seccion1(d.secc_ccod, @v_tipo_profe, e.pers_ncorr)
                                                                                                         else
                                                                                                           case
                                                                                                             when b.bloq_ayudantia in ( 2, 3, 4 )
                                                                                                                  and tpro_ccod = 2 then
                                                                                                             protic.retorna_horas_seccion1(d.secc_ccod, 2, e.pers_ncorr)
                                                                                                             else protic.retorna_horas_tipo_bloque(d.secc_ccod, b.bloq_ayudantia)
                                                                                                           end
                                                                                                       end)
                                                   else isnull(y.hopr_nhoras, d.secc_nhoras_pagar)
                                                 end, 0)                                 as ASIG_NHORAS,
                                          b.bloq_ccod 
                          from   bloques_profesores a 
                                 inner join bloques_horarios b 
                                         on b.bloq_ccod = a.bloq_ccod 
                                            and a.pers_ncorr = @p_pers_ncorr 
                                            and a.bloq_anexo is null 
                                            and isnull(b.bloq_ayudantia, 0) = @rae_tipo_bloque
                                 inner join secciones d 
                                         on d.secc_ccod = b.secc_ccod 
                                 inner join carreras_docente e 
                                         on d.carr_ccod = e.carr_ccod 
                                            and d.sede_ccod = e.sede_ccod 
                                            and d.jorn_ccod = e.jorn_ccod 
                                            and e.pers_ncorr = a.pers_ncorr 
                                            and e.sede_ccod = a.sede_ccod 
                                            and e.tcat_ccod is not null 
                                            and e.carr_ccod = @p_carr_ccod 
                                            and e.sede_ccod = @p_sede_ccod 
                                            and e.jorn_ccod = @p_jorn_ccod 
                                 inner join asignaturas f 
                                         on f.asig_ccod = d.asig_ccod 
                                            and f.duas_ccod = @rae_duas_ccod 
                                 left outer join horas_profesores y 
                                              on e.pers_ncorr = y.pers_ncorr 
                                                 and d.secc_ccod = y.secc_ccod 
                                                 and isnull(b.bloq_ayudantia, 0) = y.bloq_ayudantia
                                                 and y.hopr_nhoras > 0 
                          order  by d.asig_ccod, 
                                    d.secc_ccod 
                    end 

                  open c_detalle_anexos 

                  ----------------------------------- 
                  -- Variables para controlar anexos con mas de 10 secciones 
                  --select @v_num_reg=@@CURSOR_ROWS 
                  --set @v_modo_on=1  
                  --set @v_cont_reg=0 
                  ----------------------------------- 
                  fetch next from c_detalle_anexos into @rda_asig_ccod, @rda_secc_ccod, @rda_valor_sesion, @rda_horas_asig, @rda_bloque

                  while @@fetch_status = 0 
                    begin 
                        /*if @v_num_reg >10 
                            begin 
                         
                                if @v_cont_reg>=10 and @rda_asig_ccod<>@v_ultima_asig and @v_modo_on=1
                                    begin 
                                        set @v_modo_on=0  
                        end 
                         
                                set @v_cont_reg=@v_cont_reg+1 
                                set @v_ultima_asig=@rda_asig_ccod 
                         
                            end 
                         
                         
                        if @v_modo_on=1 
                        begin */ 
                        exec protic.retornarsecuencia 
                          'detalle_anexo', 
                          @v_dane_ncorr output 

                        insert into detalle_anexos 
                                    (dane_ncorr, 
                                     cdoc_ncorr, 
                                     anex_ncorr, 
                                     secc_ccod, 
                                     bloq_ccod, 
                                     asig_ccod, 
                                     dane_nsesiones, 
                                     duas_ccod, 
                                     dane_msesion, 
                                     audi_tusuario, 
                                     audi_fmodificacion) 
                        values     (@v_dane_ncorr, 
                                    @v_contrato, 
                                    @v_anex_ncorr, 
                                    @rda_secc_ccod, 
                                    @rda_bloque, 
                                    @rda_asig_ccod, 
                                    @rda_horas_asig, 
                                    @rae_duas_ccod, 
                                    @rda_valor_sesion, 
                                    @p_audi_tusuario, 
                                    Getdate()) 

                        -- marco la tabla bloques profesores con el bloque correspondiente 
                        update bloques_profesores 
                        set    bloq_anexo = @v_anex_ncorr, 
                               cdoc_ncorr = @v_contrato 
                        where  bloq_ccod = @rda_bloque 
                               and pers_ncorr = @p_pers_ncorr 

                        -- end 
                        fetch next from c_detalle_anexos into @rda_asig_ccod, @rda_secc_ccod, @rda_valor_sesion, @rda_horas_asig, @rda_bloque
                    end 

                  close c_detalle_anexos 

                  deallocate c_detalle_anexos 
              end --fin si no tiene categoria 
            fetch next from c_anexos_escuela into @rae_duas_ccod, @rae_sede_ccod, @rae_carr_ccod, @rae_jorn_ccod, @rae_tcat_ccod, @rae_seccion, @rae_tipo_bloque
        end 

      close c_anexos_escuela 

      deallocate c_anexos_escuela 

      select @v_sin_fecha_fin = Count(*) 
      from   contratos_docentes_upa 
      where  cdoc_ncorr = @v_contrato 
             and cdoc_ffin is null 

      if @v_crear_fecha_fin = 1 
          or @v_sin_fecha_fin > 0 
        begin 
            update contratos_docentes_upa 
            set    cdoc_ffin = convert(datetime, @v_fin_reg, 103) 
            where  cdoc_ncorr = @v_contrato 
        end 

      if @conteo_anexos = 0 
        begin 
            set @v_salida=2 --no se crearon anexos 

            rollback transaction 
        end 
      else 
        begin 
            set @v_salida=1 -- sin errores 

            commit transaction 
        end 

      select @v_salida 
  end 

-- Fin procedimiento 
go 