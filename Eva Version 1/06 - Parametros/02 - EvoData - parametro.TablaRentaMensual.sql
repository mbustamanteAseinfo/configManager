
if not exists (select 1 from gen.apa_alcances_parametros where apa_codpar = 'TablaRentaMensual' and apa_codpai = 'pa')
begin
insert into gen.apa_alcances_parametros(apa_fecha_inicio, apa_fecha_final, apa_codpar, apa_codpai, apa_codgrc, apa_codcia, apa_codcdt, apa_valor, apa_usuario_grabacion, apa_fecha_grabacion, apa_usuario_modificacion, apa_fecha_modificacion)
values (null,null,'TablaRentaMensual','pa',NULL,NULL,NULL,NULL,NULL, NULL, NULL, NULL)

insert into gen.rap_rangos_alcance_parametros(rap_codapa, rap_inicio, rap_fin, rap_porcentaje, rap_excedente, rap_valor) values (SCOPE_IDENTITY(),0.00,11000.00,0.00,0.00,0.00),
(SCOPE_IDENTITY(),11000.01,50000.00,15.00,11000.00,0.00),
(SCOPE_IDENTITY(),50000.01,1000000.00,25.00,50000.00,5850.00)
end