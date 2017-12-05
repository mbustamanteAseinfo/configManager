/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:52 AM */

begin transaction
if exists(select 1 from sal.fac_factores where fac_codigo = '2C414057-6BCF-4407-AEA8-C526E920E251')
	delete from [sal].[fac_factores] where [fac_codigo] = '2C414057-6BCF-4407-AEA8-C526E920E251';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codpai],[fac_size]) values ('2C414057-6BCF-4407-AEA8-C526E920E251','agrega_ingresos_historial','Agrega los ingresos generados a la tabla temporal con el histórico','Sub agrega_ingresos_historial(ByRef Agrupadores, _
							  ByRef inn_ingresos, _
                              ByVal codEMP, _
                              ByVal codPPL, _
                              ByVal codTIG, _
                              ByVal Valor, _
                              ByVal codMON, _
                              ByVal Tiempo, _
                              ByVal UnidadTiempo)
	inn_ingresos.AddNew
	inn_ingresos.Fields("inn_codppl").Value = codPPL
	inn_ingresos.Fields("inn_codemp").Value = codEMP
	inn_ingresos.Fields("inn_codtig").Value = codTIG
	inn_ingresos.Fields("inn_valor").Value = Valor
	inn_ingresos.Fields("inn_codmon").Value = codMON
	inn_ingresos.Fields("inn_tiempo").Value = Tiempo
	inn_ingresos.Fields("inn_unidad_tiempo").Value = UnidadTiempo
	
	Agrupadores.SumaRubro "I", codTIG, Valor
End Sub','pa',0);

commit transaction;
