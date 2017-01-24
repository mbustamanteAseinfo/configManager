/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:52 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'C0E973DD-C81F-4274-BCE1-10975F3A485E';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codpai],[fac_size]) values ('C0E973DD-C81F-4274-BCE1-10975F3A485E','agrega_descuentos_historial','Agrega los descuentos generados a la tabla temporal con el histórico','Sub agrega_descuentos_historial(ByRef Agrupadores, _
                                ByRef dss_descuentos, _
                                ByVal codEMP, _
                                ByVal codPPL, _
                                ByVal codTDC, _
                                ByVal Valor, _
                                ByVal ValorPatronal, _
                                Byval IngresoAfecto, _
                                ByVal codMON, _
                                ByVal Tiempo, _
                                ByVal UnidadTiempo)
    dss_descuentos.AddNew
    dss_descuentos.Fields("dss_codppl").Value = codPPL
    dss_descuentos.Fields("dss_codemp").Value = codEMP
    dss_descuentos.Fields("dss_codtdc").Value = codTDC
    dss_descuentos.Fields("dss_valor").Value = Valor
    dss_descuentos.Fields("dss_valor_patronal").Value = ValorPatronal
    dss_descuentos.Fields("dss_ingreso_afecto").Value = IngresoAfecto
    dss_descuentos.Fields("dss_codmon").Value = codMON
    dss_descuentos.Fields("dss_tiempo").Value = Tiempo
    dss_descuentos.Fields("dss_unidad_tiempo").Value = UnidadTiempo

	Agrupadores.SumaRubro "D", codTDC, Valor
End Sub','pa',0);

commit transaction;
