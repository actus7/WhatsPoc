Unit uMain;

Interface

Uses
  WinApi.Windows, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, ComCtrls, ImgList, System.ImageList, Vcl.Tabs,
  Data.DB, Vcl.Grids, Vcl.DBGrids, System.Math, FireDAC.Stan.Option,
  System.JSON, Generics.Collections, Vcl.StdCtrls;

Type
  TContato = class
    IsMe: Boolean;
    Name: String;
    PushName: String;
    VerifiedName: String;
    IsMyContact: Boolean;
    IsUser: Boolean;
    StatusMute: Boolean;
  end;

  TSala = class
    Endereco: String;
    Handle: Integer;
  end;

  TfrmMain = class(TForm)
    HashBackGround: TShape;
    MainMenu: TMainMenu;
    MnuFile: TMenuItem;
    MnuView: TMenuItem;
    MnuAbout: TMenuItem;
    MnuTile: TMenuItem;
    MnuCas: TMenuItem;
    MnuArr: TMenuItem;
    MnuExit: TMenuItem;
    N1: TMenuItem;
    stbPrincipal: TStatusBar;
    ImageList: TImageList;
    mdiChildrenTabs: TTabSet;
    Settings1: TMenuItem;
    Connect1: TMenuItem;
    ransfer1: TMenuItem;
    Search1: TMenuItem;
    PublicRooms1: TMenuItem;
    splMain: TSplitter;
    dbgDownload: TDBGrid;
    Settings2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure MnuTileClick(Sender: TObject);
    procedure MnuArrClick(Sender: TObject);
    procedure MnuCasClick(Sender: TObject);
    procedure MnuExitClick(Sender: TObject);

    procedure mdiChildrenTabsChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
    procedure PublicRooms1Click(Sender: TObject);
    procedure Settings2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    Contatos: TDictionary<String, TContato>;
    Salas: TDictionary<String, TSala>;
    Procedure MDIChildCreated(const childHandle: THandle);
    Procedure MDIChildDestroyed(const childHandle: THandle);
    procedure AbrirSala(pEndereco, pNome: String);
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

Implementation

{$R *.dfm}

uses
  uSettings, uPublicRooms, uChat;

procedure TfrmMain.mdiChildrenTabsChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
var
  cHandle: Integer;
  k: Integer;
begin
  cHandle := Integer(mdiChildrenTabs.Tabs.Objects[NewTab]);

  if mdiChildrenTabs.Tag = -1 then
    Exit;

  for k := 0 to MDIChildCount - 1 do
  begin
    if MDIChildren[k].Handle = cHandle then
    begin
      MDIChildren[k].Show;
      Break;
    end;
  end;

end;

procedure TfrmMain.MDIChildCreated(const childHandle: THandle);
begin
  mdiChildrenTabs.Tabs.AddObject(TForm(FindControl(childHandle)).Caption, TObject(childHandle));
  mdiChildrenTabs.TabIndex := -1 + mdiChildrenTabs.Tabs.Count;
end;

procedure TfrmMain.MDIChildDestroyed(const childHandle: THandle);
var
  idx: Integer;
begin
  idx := mdiChildrenTabs.Tabs.IndexOfObject(TObject(childHandle));
  mdiChildrenTabs.Tabs.Delete(idx);
end;

procedure TfrmMain.MnuArrClick(Sender: TObject);
begin
  ArrangeIcons;
end;

procedure TfrmMain.MnuCasClick(Sender: TObject);
begin
  Cascade;
end;

procedure TfrmMain.MnuTileClick(Sender: TObject);
begin
  if TileMode = tbHorizontal then
    TileMode := tbVertical
  else
    TileMode := tbHorizontal;
  Tile;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Key: String;
begin
  for Key in Contatos.Keys do
  begin
    Contatos.Items[Key].Destroy;
  end;
  Contatos.Free;

  for Key in Salas.Keys do
  begin
    Salas.Items[Key].Destroy;
  end;
  Salas.Free;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Contatos := TDictionary<String, TContato>.Create;
  Salas := TDictionary<String, TSala>.Create;
end;

procedure TfrmMain.PublicRooms1Click(Sender: TObject);
begin
  if not Assigned(frmPublicRooms) then
  begin
    Application.CreateForm(TfrmPublicRooms, frmPublicRooms);
    try
      frmPublicRooms.Show;
    finally
      frmPublicRooms.WindowState := wsMaximized;
    end;
  end;
end;

procedure TfrmMain.AbrirSala(pEndereco, pNome: String);
var
  i, idxTab: Integer;
  Sala: TSala;
begin
  idxTab := -1;
  for i := 0 to MDIChildCount - 1 do
  begin
    if MDIChildren[i].ClassName = 'TfrmChat' then
    begin
      if TfrmChat(MDIChildren[i]).Endereco = pEndereco then
      begin
        idxTab := mdiChildrenTabs.Tabs.IndexOfObject(TObject(MDIChildren[i].Handle));
        Break;
      end;
    end;
  end;

  if idxTab = -1 then
  begin
    Application.CreateForm(TfrmChat, frmChat);
    try
      frmChat.Endereco := pEndereco;
      frmChat.Caption := pNome;
      idxTab := mdiChildrenTabs.Tabs.IndexOfObject(TObject(frmChat.Handle));
      mdiChildrenTabs.Tabs[idxTab] := pNome;
      frmChat.Show;
    finally
      frmChat.WindowState := wsMaximized;

      Sala := TSala.Create;
      Sala.Handle := frmChat.Handle;
      Sala.Endereco := pEndereco;
      Salas.Add(pEndereco, Sala);
    end;
  end
  else
    mdiChildrenTabs.TabIndex := idxTab;

end;

procedure TfrmMain.Settings2Click(Sender: TObject);
begin
  frmSettings.ShowModal;
end;

procedure TfrmMain.MnuExitClick(Sender: TObject);
begin
  Halt(0);
  // Exit from our application;
end;

end.
