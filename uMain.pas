Unit uMain;

Interface

Uses
  WinApi.Windows, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, ComCtrls, ImgList, System.ImageList, Vcl.Tabs,
  Data.DB, Vcl.Grids, Vcl.DBGrids, System.Math, FireDAC.Stan.Option,
  System.JSON, Generics.Collections,

  // ############ ATENCAO AQUI ####################
  // units adicionais obrigatorias
  uTInject.ConfigCEF, uTInject, uTInject.Constant, uTInject.JS,
  uInjectDecryptFile,
  uTInject.Console, uTInject.Diversos, uTInject.AdjustNumber, uTInject.Config,
  uTInject.Classes, Vcl.StdCtrls;

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
    TInject1: TInject;
    Settings2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure MnuTileClick(Sender: TObject);
    procedure MnuArrClick(Sender: TObject);
    procedure MnuCasClick(Sender: TObject);
    procedure MnuExitClick(Sender: TObject);

    procedure mdiChildrenTabsChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
    procedure PublicRooms1Click(Sender: TObject);
    procedure TInject1GetQrCode(const Sender: TObject; const QrCode: TResultQRCodeClass);
    procedure TInject1GetStatus(Sender: TObject);
    procedure Settings2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TInject1GetAllGroupList(const AllGroups: TRetornoAllGroups);
    procedure TInject1GetAllGroupContacts(const Contacts: TClassAllGroupContacts);
    procedure TInject1GetAllContactList(const AllContacts: TRetornoAllContacts);
    procedure TInject1GetUnReadMessages(const Chats: TChatList);
  private
    { Private declarations }
  public
    Contatos: TDictionary<String, TContato>;
    Salas: TDictionary<String, TSala>;
    Procedure MDIChildCreated(const childHandle: THandle);
    Procedure MDIChildDestroyed(const childHandle: THandle);
    procedure FazConexaoServidor;
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

procedure TfrmMain.FazConexaoServidor;
begin
  if not TInject1.Auth(false) then
  Begin
    TInject1.FormQrCodeType := TFormQrCodeType(2);
    TInject1.FormQrCodeStart;
  End;

  if not TInject1.FormQrCodeShowing then
    TInject1.FormQrCodeShowing := true;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  FazConexaoServidor;
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
  TInject1.ShutDown;

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
  if TInject1.Status = Inject_Initialized then
  begin
    if not Assigned(frmPublicRooms) then
    begin
      Application.CreateForm(TfrmPublicRooms, frmPublicRooms);
      try
        frmPublicRooms.Show;
      finally
        if frmMain.TInject1.Auth then
          frmMain.TInject1.getAllGroups;
        frmPublicRooms.WindowState := wsMaximized;
      end;
    end;
  end;
end;

procedure TfrmMain.AbrirSala(pEndereco, pNome: String);
var
  i, idxTab: Integer;
  Sala: TSala;
begin
  if TInject1.Status = Inject_Initialized then
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
        if TInject1.Auth then
          TInject1.listGroupContacts(pEndereco);
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
end;

procedure TfrmMain.TInject1GetUnReadMessages(const Chats: TChatList);
var
  AChat: TChatClass;
  AMessage: TMessagesClass;
  Contato, telefone: string;
  injectDecrypt: TInjectDecryptFile;

  Sala: TSala;
begin
  for AChat in Chats.result do
  begin
    if Salas.TryGetValue(AChat.id, Sala) then
    begin
      for AMessage in AChat.messages do
      begin
        TfrmChat(FindControl(Sala.Handle)).Mensagem := AMessage;
      end;
    end;

    // for AMessage in AChat.messages do
    // begin

    // Memo1.Lines.Add(PChar('Nome Contato: ' + Trim(AMessage.Sender.PushName)));
    // Memo1.Lines.Add(PChar('Chat Id     : ' + AChat.id));
    // memo_unReadMessage.Lines.Add(PChar(AMessage.mediaData.&type) + 'Lat: '+AMessage.lat.ToString + ' Long: '+ AMessage.lng.ToString);
    // memo_unReadMessage.Lines.Add(PChar(AMessage.mediaKey));
    // Memo1.Lines.Add(PChar('Tipo mensagem: ' + AMessage.&type));
    // Memo1.Lines.Add(StringReplace(AMessage.body, #$A, #13#10,
    // [rfReplaceAll, rfIgnoreCase]));

    { if not AChat.isGroup then //Não exibe mensages de grupos
      begin
      if not AMessage.sender.isMe then  //Não exibe mensages enviadas por mim
      begin
      memo_unReadMessage.Clear;

      //Tratando o tipo do arquivo recebido e faz o download para pasta \BIN\temp
      case AnsiIndexStr(UpperCase(AMessage.&type), ['PTT', 'IMAGE', 'VIDEO', 'AUDIO', 'DOCUMENT']) of
      0: begin injectDecrypt.download(AMessage.clientUrl, AMessage.mediaKey, 'mp3'); end;
      1: begin injectDecrypt.download(AMessage.clientUrl, AMessage.mediaKey, 'jpg'); end;
      2: begin injectDecrypt.download(AMessage.clientUrl, AMessage.mediaKey, 'mp4'); end;
      3: begin injectDecrypt.download(AMessage.clientUrl, AMessage.mediaKey, 'mp3'); end;
      4: begin injectDecrypt.download(AMessage.clientUrl, AMessage.mediaKey, 'pdf'); end;
      end;

      memo_unReadMessage.Lines.Add(PChar( 'Nome Contato: ' + Trim(AMessage.Sender.pushName)));
      memo_unReadMessage.Lines.Add(PChar( 'Chat Id     : ' + AChat.id));
      //memo_unReadMessage.Lines.Add(PChar(AMessage.mediaData.&type) + 'Lat: '+AMessage.lat.ToString + ' Long: '+ AMessage.lng.ToString);
      //memo_unReadMessage.Lines.Add(PChar(AMessage.mediaKey));
      memo_unReadMessage.Lines.Add(PChar('Tipo mensagem: '      + AMessage.&type));
      memo_unReadMessage.Lines.Add( StringReplace(AMessage.body, #$A, #13#10, [rfReplaceAll, rfIgnoreCase]));

      telefone  :=  Copy(AChat.id, 3, Pos('@', AChat.id) - 3);
      contato   :=  AMessage.Sender.pushName;
      ed_profilePicThumbURL.text := AChat.contact.profilePicThumbObj.img;
      TInject1.ReadMessages(AChat.id);

      //            if (AMessage.&type = 'image') then
      //            begin
      //              decrypt.processaimagem(AMessage.clientUrl, AMessage.mediaKey, 'jpg');
      //            end;

      if chk_AutoResposta.Checked then
      VerificaPalavraChave(AMessage.body, '', telefone, contato);
      end;
      end; }
    // end;
  end;
end;

procedure TfrmMain.Settings2Click(Sender: TObject);
begin
  frmSettings.ShowModal;
end;

procedure TfrmMain.TInject1GetAllContactList(const AllContacts: TRetornoAllContacts);
var
  AContact: TContactClass;
  Contato: TContato;
begin
  Contatos.Clear;

  for AContact in AllContacts.result do
  begin
    if not Contatos.ContainsKey(AContact.id) then
    begin
      Contato := TContato.Create;
      Contato.Name := AContact.Name;
      Contato.PushName := AContact.PushName;
      Contato.VerifiedName := AContact.VerifiedName;
      Contato.IsUser := AContact.IsUser;
      Contato.StatusMute := AContact.StatusMute;
      Contato.IsMe := AContact.IsMe;
      Contato.IsMyContact := AContact.IsMyContact;
      Contatos.Add(AContact.id, Contato);
    end;
  end;
  AContact := nil;
end;

procedure TfrmMain.TInject1GetAllGroupContacts(const Contacts: TClassAllGroupContacts);
var
  JSonValue: TJSonValue;
  ArrayRows: TJSONArray;
begin
  JSonValue := TJSonObject.ParseJSONValue(Contacts.result);
  try
    ArrayRows := JSonValue as TJSONArray;
    frmChat.EnviaContatos := ArrayRows;
  finally
    JSonValue.Free;
  end;
end;

procedure TfrmMain.TInject1GetAllGroupList(const AllGroups: TRetornoAllGroups);
begin
  frmPublicRooms.Salas := AllGroups.Numbers;
end;

procedure TfrmMain.TInject1GetQrCode(const Sender: TObject; const QrCode: TResultQRCodeClass);
begin
  if TInject1.FormQrCodeType = TFormQrCodeType(Ft_none) then
  begin
    frmSettings.imgQrCode.Picture := QrCode.AQrCodeImage;
    stbPrincipal.Panels[0].Text := 'Faça o Login';
    stbPrincipal.Panels[1].Text := 'Aguardando Autenticação do Usuário...';
  end
  else
    frmSettings.imgQrCode.Picture := nil;
end;

procedure TfrmMain.TInject1GetStatus(Sender: TObject);
var
  page: Integer;
begin
  if not Assigned(Sender) Then
    Exit;

  if TInject(Sender).Status = Server_Disconnected then
  begin

  end;

  if (TInject(Sender).Status = Inject_Initialized) then
  begin
    frmSettings.btnDesconectar.Enabled := true;
    frmSettings.lblStatus.Caption := 'Online';
    frmSettings.lblStatus.Font.Color := $0000AE11;
  end
  else
  begin
    frmSettings.btnDesconectar.Enabled := false;
    frmSettings.lblStatus.Caption := 'Offline';
    frmSettings.lblStatus.Font.Color := $002894FF;
  end;

  frmSettings.whatsOn.Visible := frmSettings.btnDesconectar.Enabled;
  // lblNumeroConectado.Visible := whatsOn.Visible;
  frmSettings.whatsOff.Visible := Not frmSettings.whatsOn.Visible;

  frmSettings.Label3.Visible := false;

  If frmSettings.Label3.Caption <> '' Then
    frmSettings.Label3.Visible := true;

  If TInject(Sender).Status in [Server_ConnectingNoPhone, Server_TimeOut] Then
  Begin
    if TInject(Sender).FormQrCodeType = Ft_Desktop then
    Begin
      if TInject(Sender).Status = Server_ConnectingNoPhone then
        TInject1.FormQrCodeStop;
    end
    else
    Begin
      // stbPrincipal.Panels[0].Text := 'Conectando...';
      if TInject(Sender).Status = Server_ConnectingNoPhone then
      Begin
        if not TInject(Sender).FormQrCodeShowing then
          TInject(Sender).FormQrCodeShowing := true;
      end
      else
      begin
        TInject(Sender).FormQrCodeReloader;
      end;
    end;
  end;

  case TInject(Sender).Status of
    Server_ConnectedDown:
      begin
        stbPrincipal.Panels[0].Text := 'Conexão Falhou';
        frmSettings.Label3.Caption := TInject(Sender).StatusToStr;
      end;
    Server_Disconnected:
      begin
        stbPrincipal.Panels[0].Text := 'Desconectado';
        frmSettings.Label3.Caption := TInject(Sender).StatusToStr;
      end;
    Server_Disconnecting:
      begin
        stbPrincipal.Panels[0].Text := 'Desconectando...';
        frmSettings.Label3.Caption := TInject(Sender).StatusToStr;
      end;
    Server_Connected:
      begin
        stbPrincipal.Panels[0].Text := 'Conectado';
        frmSettings.Label3.Caption := '';
      end;
    Server_Connecting:
      begin
        stbPrincipal.Panels[0].Text := 'Conectando...';
        frmSettings.Label3.Caption := TInject(Sender).StatusToStr;
      end;
    Inject_Initializing:
      begin
        stbPrincipal.Panels[0].Text := 'Inicializando...';
        frmSettings.Label3.Caption := TInject(Sender).StatusToStr;
      end;
    Inject_Initialized:
      begin
        stbPrincipal.Panels[0].Text := 'Conectado';
        frmSettings.Label3.Caption := TInject(Sender).StatusToStr;
        TInject1.getAllContacts;
      end;
    Server_ConnectingNoPhone:
      begin
        stbPrincipal.Panels[0].Text := 'NoPhone';
        frmSettings.Label3.Caption := TInject(Sender).StatusToStr;
      end;
    Server_ConnectingReaderCode:
      begin
        stbPrincipal.Panels[0].Text := 'Lendo Código...';
        frmSettings.Label3.Caption := TInject(Sender).StatusToStr;
      end;
    Server_TimeOut:
      begin
        stbPrincipal.Panels[0].Text := 'TimeOut';
        frmSettings.Label3.Caption := TInject(Sender).StatusToStr;
      end;
    Inject_Destroying:
      begin
        stbPrincipal.Panels[0].Text := 'Desconectado';
        frmSettings.Label3.Caption := TInject(Sender).StatusToStr;
      end;
    Inject_Destroy:
      begin
        stbPrincipal.Panels[0].Text := 'Desconectado';
        frmSettings.Label3.Caption := TInject(Sender).StatusToStr;
      end;
  end;
  stbPrincipal.Panels[1].Text := frmSettings.Label3.Caption;
end;

procedure TfrmMain.MnuExitClick(Sender: TObject);
begin
  Halt(0);
  // Exit from our application;
end;

end.
