object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Main'
  ClientHeight = 420
  ClientWidth = 581
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 15
  object StatusBar: TStatusBar
    Left = 0
    Top = 401
    Width = 581
    Height = 19
    Panels = <
      item
        Width = 300
      end
      item
        Width = 400
      end>
    ExplicitLeft = 256
    ExplicitTop = 384
    ExplicitWidth = 0
  end
  object pnlAtalhos: TPanel
    Left = 0
    Top = 0
    Width = 581
    Height = 153
    Align = alTop
    TabOrder = 1
    object btnClientes: TButton
      Left = 56
      Top = 32
      Width = 153
      Height = 89
      Caption = 'Clientes'
      TabOrder = 0
      OnClick = btnClientesClick
    end
    object btnOrdens: TButton
      Left = 328
      Top = 32
      Width = 177
      Height = 89
      Caption = 'Ordens de Servi'#231'o'
      TabOrder = 1
      OnClick = btnOrdensClick
    end
  end
  object MainMenu1: TMainMenu
    Left = 528
    Top = 344
    object mnuCadastros: TMenuItem
      Caption = 'Cadastros'
      object mnuClientes: TMenuItem
        Caption = 'Clientes'
        OnClick = mnuClientesClick
      end
    end
    object mnuOrdensServico: TMenuItem
      Caption = 'Ordens de Servi'#231'o'
      OnClick = mnuOrdensServicoClick
    end
    object mnuSair: TMenuItem
      Caption = 'Sair'
      OnClick = mnuSairClick
    end
  end
end
