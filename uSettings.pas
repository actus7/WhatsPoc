unit uSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.Buttons, Vcl.Imaging.pngimage;

type
  TfrmSettings = class(TForm)
    PageControl1: TPageControl;
    pnlBotoes: TPanel;
    btnCancelar: TButton;
    Button1: TButton;
    tsGeneral: TTabSheet;
    tsSharing: TTabSheet;
    tsDownload: TTabSheet;
    GroupBox1: TGroupBox;
    btnDesconectar: TSpeedButton;
    imgQrCode: TImage;
    lblStatus: TLabel;
    whatsOff: TImage;
    whatsOn: TImage;
    Label3: TLabel;
    procedure btnDesconectarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSettings: TfrmSettings;

implementation

{$R *.dfm}

uses
  uMain, uTInject.Constant;

procedure TfrmSettings.btnDesconectarClick(Sender: TObject);
begin
  if not frmMain.TInject1.auth then
    exit;

   frmMain.TInject1.Logtout;
   frmMain.TInject1.Disconnect;
end;

procedure TfrmSettings.FormShow(Sender: TObject);
begin
  if frmMain.TInject1.Status = Inject_Destroy then
    frmMain.FazConexaoServidor;
end;

end.
