create procedure sd_inserta_codigos_tesis
as

begin

declare @r_cod_tes numeric
declare @r_cod_aut numeric
declare @r_cod_mat numeric

    
DECLARE c_codigos_autores CURSOR LOCAL FOR

select codtes, max(codaut) from fox..codigo_tesis_autores group by codtes
  
OPEN c_codigos_autores
FETCH NEXT FROM c_codigos_autores
INTO  @r_cod_tes,@r_cod_aut

 While @@FETCH_STATUS = 0
    Begin
       
        update fox..tesis_finales set cod_aut=@r_cod_aut where codigo=@r_cod_tes      

        FETCH NEXT FROM c_codigos_autores
        INTO  @r_cod_tes,@r_cod_aut

    End 
    
CLOSE c_codigos_autores 
DEALLOCATE c_codigos_autores	  


DECLARE c_codigos_materias CURSOR LOCAL FOR
select codtes, max(codmat) from fox..codigo_tesis_materias group by codtes
  
OPEN c_codigos_materias
FETCH NEXT FROM c_codigos_materias
INTO  @r_cod_tes,@r_cod_mat

 While @@FETCH_STATUS = 0
    Begin
       
        update fox..tesis_finales set cod_mat=@r_cod_mat where codigo=@r_cod_tes      

        FETCH NEXT FROM c_codigos_materias
        INTO  @r_cod_tes,@r_cod_mat

    End 
    
CLOSE c_codigos_materias 
DEALLOCATE c_codigos_materias

end