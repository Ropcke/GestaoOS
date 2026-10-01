object frmClientes: TfrmClientes
  Left = 0
  Top = 0
  Caption = 'Cadastro de Clientes'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 15
  object pgcPrincipal: TPageControl
    Left = 0
    Top = 0
    Width = 624
    Height = 441
    ActivePage = tsCadastro
    Align = alClient
    TabOrder = 0
    object tsConsulta: TTabSheet
      Caption = 'Consulta'
      object pnlPesquisa: TPanel
        Left = 0
        Top = 0
        Width = 616
        Height = 41
        Align = alTop
        TabOrder = 0
        object lbpesquisar: TLabel
          Left = 0
          Top = 8
          Width = 90
          Height = 15
          Caption = 'Pesquisar Cliente'
        end
        object edtPesquisa: TEdit
          Left = 112
          Top = 8
          Width = 121
          Height = 23
          TabOrder = 0
        end
        object btnPesquisar: TButton
          Left = 304
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Pesquisar'
          Default = True
          TabOrder = 1
          OnClick = btnPesquisarClick
        end
      end
      object gridClientes: TDBGrid
        Left = 0
        Top = 41
        Width = 616
        Height = 329
        Align = alClient
        DataSource = dsClientes
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
        OnDblClick = gridClientesDblClick
      end
      object pnlEditar: TPanel
        Left = 0
        Top = 370
        Width = 616
        Height = 41
        Align = alBottom
        TabOrder = 2
        object btnNovo: TButton
          Left = 112
          Top = 6
          Width = 89
          Height = 25
          Caption = 'Novo Cliente'
          TabOrder = 0
          OnClick = btnNovoClick
        end
        object btnEditar: TButton
          Left = 256
          Top = 6
          Width = 89
          Height = 25
          Caption = 'Editar'
          TabOrder = 1
          OnClick = btnEditarClick
        end
        object btnExcluir: TButton
          Left = 408
          Top = 6
          Width = 89
          Height = 25
          Caption = 'Excluir'
          TabOrder = 2
          OnClick = btnExcluirClick
        end
      end
    end
    object tsCadastro: TTabSheet
      Caption = 'Cadastro'
      ImageIndex = 1
      object Label1: TLabel
        Left = 11
        Top = 3
        Width = 11
        Height = 15
        Caption = 'ID'
      end
      object Label2: TLabel
        Left = 11
        Top = 67
        Width = 89
        Height = 15
        Caption = 'Nome Completo'
      end
      object Label3: TLabel
        Left = 11
        Top = 123
        Width = 63
        Height = 15
        Caption = 'Documento'
      end
      object Label4: TLabel
        Left = 11
        Top = 173
        Width = 111
        Height = 15
        Caption = 'Telefone / WhatsApp'
      end
      object Label5: TLabel
        Left = 11
        Top = 219
        Width = 34
        Height = 15
        Caption = 'E-mail'
      end
      object edtID: TEdit
        Left = 11
        Top = 24
        Width = 121
        Height = 23
        Enabled = False
        ReadOnly = True
        TabOrder = 0
      end
      object edtDocumento: TEdit
        Left = 11
        Top = 144
        Width = 232
        Height = 23
        TabOrder = 1
      end
      object edtNome: TEdit
        Left = 11
        Top = 88
        Width = 438
        Height = 23
        TabOrder = 2
      end
      object edtTelefone: TEdit
        Left = 11
        Top = 194
        Width = 222
        Height = 23
        TabOrder = 3
        TextHint = '(51)9000-00000'
      end
      object edtEmail: TEdit
        Left = 11
        Top = 240
        Width = 286
        Height = 23
        TabOrder = 4
      end
      object Panel1: TPanel
        Left = 0
        Top = 370
        Width = 616
        Height = 41
        Align = alBottom
        TabOrder = 5
        object btnSalvar: TButton
          Left = 168
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Salvar (F5)'
          TabOrder = 0
          OnClick = btnSalvarClick
        end
        object btnCancelar: TButton
          Left = 328
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Cancelar'
          TabOrder = 1
          OnClick = btnCancelarClick
        end
      end
    end
  end
  object dsClientes: TDataSource
    DataSet = dtmClientes.qryClientes
    Left = 548
    Top = 330
  end
end
