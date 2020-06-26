unit uChat;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.AnsiStrings, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBaseChildForm, Data.DB, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, System.JSON;

type
  TfrmChat = class(TfrmBaseChildForm)
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    Splitter1: TSplitter;
    fdmUsuarios: TFDMemTable;
    dsUsuarios: TDataSource;
    fdmUsuariosIsMe: TBooleanField;
    fdmUsuariosId: TStringField;
    fdmUsuariosName: TStringField;
    fdmUsuariosIsMyContact: TBooleanField;
    fdmUsuariosIsUser: TBooleanField;
    fdmUsuariosStatusMute: TBooleanField;
    cbBuscaUsuario: TComboBox;
    edtBuscaUsuario: TEdit;
    edtMensagem: TEdit;
    reChat: TRichEdit;
    procedure edtMensagemKeyPress(Sender: TObject; var Key: Char);
  private
    fEndereco: String;
    //procedure SetContatos(const pContatos: TJSONArray);
    //procedure SetMensagem(const pMensagem: TMessagesClass);
    { Private declarations }
  public
    property Endereco: String read fEndereco write fEndereco;
    //property EnviaContatos: TJSONArray write SetContatos;
    //property Mensagem: TMessagesClass write SetMensagem;
    { Public declarations }
  end;

var
  frmChat: TfrmChat;

implementation

{$R *.dfm}

uses
  uMain;

procedure TfrmChat.edtMensagemKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    edtMensagem.Clear;
  end;
end;

{procedure TfrmChat.SetContatos(const pContatos: TJSONArray);
var
  i: Integer;
  Contato: TContato;
begin
  fdmUsuarios.Close;
  fdmUsuarios.Open;
  fdmUsuarios.LogChanges := false;
  fdmUsuarios.ResourceOptions.SilentMode := True;
  fdmUsuarios.UpdateOptions.LockMode := lmNone;
  fdmUsuarios.UpdateOptions.LockPoint := lpDeferred;
  fdmUsuarios.UpdateOptions.FetchGeneratorsPoint := gpImmediate;
  fdmUsuarios.DisableControls;
  fdmUsuarios.BeginBatch;
  try
    for i := 0 to pContatos.Size - 1 do
    begin
      fdmUsuarios.Append;

      fdmUsuariosId.AsString := pContatos.Items[i].value;
      if (frmMain.Contatos.TryGetValue(pContatos.Items[i].value, Contato) = True) then
      begin
        if not Trim(Contato.VerifiedName).IsEmpty then
          fdmUsuariosName.AsString := Contato.VerifiedName
        else if not Trim(Contato.Name).IsEmpty then
          fdmUsuariosName.AsString := Contato.Name
        else if not Trim(Contato.PushName).IsEmpty then
          fdmUsuariosName.AsString := Contato.PushName
        else
          fdmUsuariosName.AsString := pContatos.Items[i].value;
      end
      else
        fdmUsuariosName.AsString := pContatos.Items[i].value;

      fdmUsuarios.Post;
    end;
  finally
    fdmUsuarios.EndBatch;
    fdmUsuarios.EnableControls;
  end;
end; }

{procedure TfrmChat.SetMensagem(const pMensagem: TMessagesClass);
var
  Mensagem: String;
  Contato: TContato;
begin
  case AnsiIndexStr(UpperCase(pMensagem.&type), ['CHAT', 'PTT', 'IMAGE', 'VIDEO', 'AUDIO', 'DOCUMENT']) of
    0:
      begin
        if pMensagem.Sender.isMe then
        begin
          with reChat do
          begin
            selstart := length(Text);
            sellength := 0;
            SelAttributes.Style := [];
            seltext := '[' + TimeToStr(now) + ']';

            selstart := length(Text);
            sellength := 0;
            SelAttributes.Style := [fsBold];
            seltext := ' <Você> ';

            selstart := length(Text);
            sellength := 0;
            SelAttributes.Style := [];
            seltext := StringReplace(pMensagem.body, #$A, #13#10, [rfReplaceAll, rfIgnoreCase]);
            lines.add(''); // new line
          end;
        end
        else
        begin
          Mensagem := '[' + TimeToStr(now) + '] ';
          Mensagem := Mensagem + '<' + pMensagem.Sender.PushName + '> ';
          Mensagem := Mensagem + StringReplace(pMensagem.body, #$A, #13#10, [rfReplaceAll, rfIgnoreCase]);
          reChat.lines.add(Mensagem);
        end;
      end;
    1..5:
      begin
        Mensagem := '[' + TimeToStr(now) + '] ';
        Mensagem := Mensagem + '<' + pMensagem.Sender.PushName + '> ';
        Mensagem := Mensagem + 'Enviou arquivo tipo -> '+pMensagem.&type;
        reChat.lines.add(Mensagem);
      end;
  end;
end; }

end.
