Unit uBaseChildForm;

Interface

Uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms;

Type
  TfrmBaseChildForm = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure WMMDIACTIVATE(var msg: TWMMDIACTIVATE); message WM_MDIACTIVATE;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBaseChildForm: TfrmBaseChildForm;

Implementation

{$R *.dfm}

uses
  uMain;

procedure TfrmBaseChildForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := CaFree;
end;

procedure TfrmBaseChildForm.FormCreate(Sender: TObject);
begin
  frmMain.MDIChildCreated(self.Handle)
end;

procedure TfrmBaseChildForm.FormDestroy(Sender: TObject);
begin
  frmMain.MDIChildDestroyed(self.Handle);
end;

procedure TfrmBaseChildForm.WMMDIACTIVATE(var msg: TWMMDIACTIVATE);
var
  active: TWinControl;
  idx: Integer;
begin
  active := FindControl(msg.ActiveWnd);

  if Assigned(active) then
  begin
    idx := frmMain.mdiChildrenTabs.Tabs.IndexOfObject(TObject(msg.ActiveWnd));
    frmMain.mdiChildrenTabs.Tag := -1;
    frmMain.mdiChildrenTabs.TabIndex := idx;
    frmMain.mdiChildrenTabs.Tag := 0;
  end;
end;

end.
