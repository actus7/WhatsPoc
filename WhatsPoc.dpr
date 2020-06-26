program WhatsPoc;

uses
  Vcl.Forms,
  Windows,
  uMain in 'uMain.pas' {frmMain},
  uPublicRooms in 'uPublicRooms.pas' {frmPublicRooms},
  uSettings in 'uSettings.pas' {frmSettings},
  uBaseChildForm in 'uBaseChildForm.pas' {frmBaseChildForm},
  uChat in 'uChat.pas' {frmChat};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmSettings, frmSettings);
  Application.Run;
end.
