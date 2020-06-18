unit uPublicRooms;

interface

uses
  Winapi.Windows, System.Classes, Vcl.Forms, uBaseChildForm, Vcl.StdCtrls,
  Vcl.Controls, Vcl.ExtCtrls, Vcl.ComCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfrmPublicRooms = class(TfrmBaseChildForm)
    stbPublicRooms: TStatusBar;
    pnlBotoes: TPanel;
    btnRefresh: TButton;
    btnConnect: TButton;
    grpFilter: TGroupBox;
    grpConexaoManual: TGroupBox;
    edtFilter: TEdit;
    edtConexaoManual: TEdit;
    DBGrid1: TDBGrid;
    fdmSalas: TFDMemTable;
    dsSalas: TDataSource;
    fdmSalassala: TStringField;
    fdmSalasendereco: TStringField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGrid1DblClick(Sender: TObject);
  private
    fListaSalas: TStringList;
    //function GetSalas: TStringList;
    procedure SetSalas(pListaSalas: TStringList);
    { Private declarations }
  public
    property Salas: TStringList write SetSalas;
    { Public declarations }
  end;

var
  frmPublicRooms: TfrmPublicRooms;

implementation

{$R *.dfm}

uses
  uMain;

procedure TfrmPublicRooms.DBGrid1DblClick(Sender: TObject);
begin
  if fdmSalas.Active then
    frmMain.AbrirSala(fdmSalasendereco.AsString, fdmSalassala.AsString);
end;

procedure TfrmPublicRooms.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  frmPublicRooms := nil;
end;

procedure TfrmPublicRooms.SetSalas(pListaSalas: TStringList);
var
  i: integer;
  lSala: String;
  lNomeSala: String;
  lEnderecoSala: String;
begin
  fdmSalas.Close;
  fdmSalas.Open;
  fdmSalas.LogChanges := false;
  fdmSalas.ResourceOptions.SilentMode := True;
  fdmSalas.UpdateOptions.LockMode := lmNone;
  fdmSalas.UpdateOptions.LockPoint := lpDeferred;
  fdmSalas.UpdateOptions.FetchGeneratorsPoint := gpImmediate;
  fdmSalas.DisableControls;
  fdmSalas.BeginBatch;
  try
    for i := 0 to (pListaSalas.Count) - 1 do
    begin
      lSala := pListaSalas[i];
      lNomeSala := Copy(lSala, Pos('@g.us ', lSala) + 6, Length(lSala));
      lEnderecoSala := Copy(lSala, 0, Pos('@g.us', lSala) + 4);

      fdmSalas.Append;
      fdmSalassala.AsString := lNomeSala;
      fdmSalasendereco.AsString := lEnderecoSala;
      fdmSalas.Post;
    end;
  finally
    fdmSalas.EndBatch;
    fdmSalas.EnableControls;
  end;
end;

end.
