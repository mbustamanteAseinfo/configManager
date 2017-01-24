/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:52 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'D4C9E398-0A79-40F8-8123-4D9A2697E6D8';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codpai],[fac_size]) values ('D4C9E398-0A79-40F8-8123-4D9A2697E6D8','agrega_reservas_historial','Agrega las reservas generadas a la tabla temporal con el histórico','Sub agrega_reservas_historial(ByRef Agrupadores, _
							  ByRef res_reservas, _
                              ByVal codEMP, _
                              ByVal codPPL, _
                              ByVal codTRS, _
                              ByVal Valor, _
                              ByVal codMON, _
                              ByVal Tiempo, _
                              ByVal UnidadTiempo)
	res_reservas.AddNew
	res_reservas.Fields("res_codppl").Value = codPPL
	res_reservas.Fields("res_codemp").Value = codEMP
	res_reservas.Fields("res_codtrs").Value = codTRS
	res_reservas.Fields("res_valor").Value = Valor
	res_reservas.Fields("res_codmon").Value = codMON
	res_reservas.Fields("res_tiempo").Value = Tiempo
	res_reservas.Fields("res_unidad_tiempo").Value = UnidadTiempo
End Sub','pa',0);

commit transaction;
