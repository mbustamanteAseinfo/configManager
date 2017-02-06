/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:53 AM */

begin transaction
if exists(select 1 from sal.fac_factores where fac_codigo = '84FE52E6-A703-4944-8103-FEED8244E3B6')
	delete from [sal].[fac_factores] where [fac_codigo] = '84FE52E6-A703-4944-8103-FEED8244E3B6';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codpai],[fac_size]) values ('84FE52E6-A703-4944-8103-FEED8244E3B6','writeLog','Escribe mensajes enviados desde la formulación en un archivo físico','Sub writeLog(ByVal msg)
    Dim fs, f
    Set fs = CreateObject("Scripting.FileSystemObject")
    Set f = fs.OpenTextFile("C:\inetpub\wwwroot\Evolution\PAgenPlanillaLog.txt", 8, True)
    
    f.Write msg
    f.Write Chr(13)
    f.Write Chr(10)
    
    f.Close
End Sub','pa',0);

commit transaction;
