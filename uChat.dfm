inherited frmChat: TfrmChat
  Caption = 'Chat'
  ClientHeight = 485
  ClientWidth = 1003
  ExplicitWidth = 1019
  ExplicitHeight = 524
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 731
    Top = 0
    Width = 8
    Height = 438
    Align = alRight
    ExplicitLeft = 609
    ExplicitHeight = 425
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 466
    Width = 1003
    Height = 19
    Panels = <
      item
        Width = 750
      end
      item
        Text = '0 Users'
        Width = 80
      end
      item
        Text = '0 B'
        Width = 80
      end
      item
        Text = 'Checkbox'
        Width = 50
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 438
    Width = 1003
    Height = 28
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      1003
      28)
    object cbBuscaUsuario: TComboBox
      Left = 918
      Top = 3
      Width = 78
      Height = 21
      Style = csDropDownList
      Anchors = [akTop, akRight]
      ItemIndex = 0
      TabOrder = 0
      Text = 'Nick'
      Items.Strings = (
        'Nick')
    end
    object edtBuscaUsuario: TEdit
      Left = 794
      Top = 3
      Width = 118
      Height = 21
      Anchors = [akTop, akRight]
      TabOrder = 1
    end
    object edtMensagem: TEdit
      Left = 3
      Top = 3
      Width = 785
      Height = 21
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 2
      OnKeyPress = edtMensagemKeyPress
    end
  end
  object DBGrid1: TDBGrid
    Left = 739
    Top = 0
    Width = 264
    Height = 438
    Align = alRight
    DataSource = dsUsuarios
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object reChat: TRichEdit
    Left = 0
    Top = 0
    Width = 731
    Height = 438
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 3
    Zoom = 100
    ExplicitLeft = 184
    ExplicitTop = 128
    ExplicitWidth = 185
    ExplicitHeight = 89
  end
  object fdmUsuarios: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 736
    Top = 56
    object fdmUsuariosId: TStringField
      FieldName = 'Id'
      Visible = False
      Size = 50
    end
    object fdmUsuariosIsMe: TBooleanField
      FieldName = 'IsMe'
      Visible = False
    end
    object fdmUsuariosName: TStringField
      FieldName = 'Name'
      Size = 100
    end
    object fdmUsuariosIsMyContact: TBooleanField
      FieldName = 'IsMyContact'
      Visible = False
    end
    object fdmUsuariosIsUser: TBooleanField
      FieldName = 'IsUser'
      Visible = False
    end
    object fdmUsuariosStatusMute: TBooleanField
      FieldName = 'StatusMute'
      Visible = False
    end
  end
  object dsUsuarios: TDataSource
    DataSet = fdmUsuarios
    Left = 736
    Top = 120
  end
end
