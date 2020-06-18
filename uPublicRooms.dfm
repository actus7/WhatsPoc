inherited frmPublicRooms: TfrmPublicRooms
  Caption = 'Public Rooms'
  ClientHeight = 455
  ClientWidth = 914
  ExplicitWidth = 930
  ExplicitHeight = 494
  PixelsPerInch = 96
  TextHeight = 13
  object stbPublicRooms: TStatusBar
    Left = 0
    Top = 436
    Width = 914
    Height = 19
    Panels = <>
  end
  object pnlBotoes: TPanel
    Left = 0
    Top = 378
    Width = 914
    Height = 58
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      914
      58)
    object btnRefresh: TButton
      Left = 822
      Top = 8
      Width = 87
      Height = 22
      Anchors = [akTop, akRight]
      Caption = 'Refresh'
      TabOrder = 0
    end
    object btnConnect: TButton
      Left = 822
      Top = 32
      Width = 87
      Height = 22
      Anchors = [akRight, akBottom]
      Caption = 'Connect'
      TabOrder = 1
    end
    object grpFilter: TGroupBox
      Left = 0
      Top = 5
      Width = 477
      Height = 44
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Filter'
      TabOrder = 2
      object edtFilter: TEdit
        Left = 10
        Top = 15
        Width = 456
        Height = 21
        Align = alCustom
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
      end
    end
    object grpConexaoManual: TGroupBox
      Left = 483
      Top = 5
      Width = 331
      Height = 44
      Anchors = [akTop, akRight]
      Caption = 'Manual connect address'
      TabOrder = 3
      object edtConexaoManual: TEdit
        Left = 11
        Top = 15
        Width = 310
        Height = 21
        Align = alCustom
        Anchors = [akTop, akRight]
        TabOrder = 0
      end
    end
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 0
    Width = 914
    Height = 378
    Align = alClient
    DataSource = dsSalas
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDblClick = DBGrid1DblClick
    Columns = <
      item
        Expanded = False
        FieldName = 'sala'
        Width = 400
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'endereco'
        Width = 400
        Visible = True
      end>
  end
  object fdmSalas: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 424
    Top = 112
    object fdmSalassala: TStringField
      DisplayLabel = 'Nome da Sala'
      FieldName = 'sala'
      Size = 100
    end
    object fdmSalasendereco: TStringField
      DisplayLabel = 'Endere'#231'o da Sala'
      FieldName = 'endereco'
      Size = 150
    end
  end
  object dsSalas: TDataSource
    DataSet = fdmSalas
    Left = 424
    Top = 160
  end
end
