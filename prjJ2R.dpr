program prjJ2R;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {FormMain},
  XSuperJSON in 'comps\XSO\XSuperJSON.pas',
  XSuperObject in 'comps\XSO\XSuperObject.pas',
  FMX.JSON2Record in 'FMX.JSON2Record.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;

end.
