object frmOrdens: TfrmOrdens
  Left = 0
  Top = 0
  Caption = 'frmOrdens'
  ClientHeight = 553
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
  object pgControl: TPageControl
    Left = 0
    Top = 0
    Width = 624
    Height = 553
    ActivePage = tsConsulta
    Align = alClient
    TabOrder = 0
    object tsConsulta: TTabSheet
      Caption = 'Consulta'
      DoubleBuffered = False
      ParentDoubleBuffered = False
      object pnlBotoesConsulta: TPanel
        Left = 0
        Top = 464
        Width = 616
        Height = 59
        Align = alBottom
        TabOrder = 0
        object btnNovo: TButton
          Left = 46
          Top = 16
          Width = 75
          Height = 25
          Caption = 'Novo'
          TabOrder = 0
          OnClick = btnNovoClick
        end
        object btnEditar: TButton
          Left = 184
          Top = 16
          Width = 75
          Height = 25
          Caption = 'Editar'
          TabOrder = 1
          OnClick = btnEditarClick
        end
        object btnExcluir: TButton
          Left = 328
          Top = 16
          Width = 75
          Height = 25
          Caption = 'Excluir'
          TabOrder = 2
          OnClick = btnExcluirClick
        end
        object btnImprimir: TButton
          Left = 472
          Top = 16
          Width = 75
          Height = 25
          Caption = 'Imprimir'
          TabOrder = 3
          OnClick = btnImprimirClick
        end
      end
      object pnlTop: TPanel
        Left = 0
        Top = 0
        Width = 616
        Height = 161
        Align = alTop
        TabOrder = 1
        object GroupBox4: TGroupBox
          Left = 1
          Top = 1
          Width = 614
          Height = 159
          Align = alClient
          Caption = 'Filtros'
          TabOrder = 0
          object lblFiltroCliente: TLabel
            Left = 16
            Top = 21
            Width = 37
            Height = 15
            Caption = 'Cliente'
          end
          object lblFiltroStatus: TLabel
            Left = 152
            Top = 21
            Width = 32
            Height = 15
            Caption = 'Status'
          end
          object lblDataIni: TLabel
            Left = 360
            Top = 21
            Width = 56
            Height = 15
            Caption = 'Data In'#237'cio'
          end
          object lblDataFim: TLabel
            Left = 360
            Top = 93
            Width = 52
            Height = 15
            Caption = 'Data Final'
          end
          object lblTotalAbertas: TLabel
            Left = 13
            Top = 98
            Width = 40
            Height = 15
            Caption = 'Abertas'
          end
          object lblTotalEmAndamento: TLabel
            Left = 74
            Top = 98
            Width = 63
            Height = 15
            Caption = 'Andamento'
          end
          object lblTotalConcluidas: TLabel
            Left = 175
            Top = 98
            Width = 59
            Height = 15
            Caption = 'Concluidas'
          end
          object lblTotalAtrasadas: TLabel
            Left = 262
            Top = 98
            Width = 51
            Height = 15
            Caption = 'Atrasadas'
          end
          object btnPesquisar: TButton
            Left = 504
            Top = 88
            Width = 75
            Height = 25
            Caption = 'Pesquisar'
            TabOrder = 0
            OnClick = btnPesquisarClick
          end
          object cbFiltroStatus: TComboBox
            Left = 152
            Top = 42
            Width = 145
            Height = 23
            TabOrder = 1
            Items.Strings = (
              'Todos'
              'Aberta'
              'Em Andamento'
              'Concluida'
              'Cancelada')
          end
          object dtpDataFim: TDateTimePicker
            Left = 360
            Top = 114
            Width = 105
            Height = 23
            Date = 46297.000000000000000000
            Time = 0.632033564812445500
            TabOrder = 2
          end
          object dtpDataIni: TDateTimePicker
            Left = 360
            Top = 42
            Width = 105
            Height = 23
            Date = 46297.000000000000000000
            Time = 0.631758344905392700
            TabOrder = 3
          end
          object edtFiltroCliente: TEdit
            Left = 16
            Top = 42
            Width = 121
            Height = 23
            TabOrder = 4
          end
        end
      end
      object dbgOrdens: TDBGrid
        Left = 0
        Top = 161
        Width = 616
        Height = 303
        Align = alClient
        DataSource = dsOrdens
        TabOrder = 2
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
        OnDrawColumnCell = dbgOrdensDrawColumnCell
      end
    end
    object tsCadastro: TTabSheet
      Caption = 'Cadastro'
      ImageIndex = 1
      object pnlRodapeCadastro: TPanel
        Left = 0
        Top = 448
        Width = 616
        Height = 75
        Align = alBottom
        TabOrder = 0
        object GroupBox3: TGroupBox
          Left = 1
          Top = 1
          Width = 614
          Height = 73
          Align = alClient
          Caption = 'Valor Total'
          TabOrder = 0
          object lblValorTotalCaption: TLabel
            Left = 191
            Top = 17
            Width = 7
            Height = 37
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -27
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
          object lblValorTotal: TLabel
            Left = 9
            Top = 16
            Width = 176
            Height = 37
            Caption = 'Valor Total: R$ '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -27
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
          object btnSalvar: TButton
            Left = 422
            Top = 24
            Width = 75
            Height = 25
            Caption = 'Salvar'
            TabOrder = 0
            OnClick = btnSalvarClick
          end
          object btnCancelar: TButton
            Left = 518
            Top = 24
            Width = 75
            Height = 25
            Caption = 'Cancelar'
            TabOrder = 1
            OnClick = btnCancelarClick
          end
        end
      end
      object pnlCabecalhoOS: TPanel
        Left = 0
        Top = 0
        Width = 616
        Height = 185
        Align = alTop
        TabOrder = 1
        object GroupBox1: TGroupBox
          Left = 1
          Top = 1
          Width = 614
          Height = 183
          Align = alClient
          Caption = 'Ordem de Servi'#231'o'
          TabOrder = 0
          object lblCliente: TLabel
            Left = 159
            Top = 17
            Width = 37
            Height = 15
            Caption = 'Cliente'
          end
          object lblStatus: TLabel
            Left = 448
            Top = 17
            Width = 32
            Height = 15
            Caption = 'Status'
          end
          object lblDataPrevista: TLabel
            Left = 327
            Top = 17
            Width = 68
            Height = 15
            Caption = 'Data Prevista'
          end
          object lblID: TLabel
            Left = 7
            Top = 17
            Width = 11
            Height = 15
            Caption = 'ID'
          end
          object lblDescricao: TLabel
            Left = 8
            Top = 89
            Width = 122
            Height = 15
            Caption = 'Descri'#231#227'o do Problema'
          end
          object cbStatus: TComboBox
            Left = 448
            Top = 38
            Width = 145
            Height = 23
            TabOrder = 0
          end
          object dtpDataPrevista: TDateTimePicker
            Left = 327
            Top = 38
            Width = 98
            Height = 23
            Date = 46300.000000000000000000
            Time = 0.695593530093901800
            DoubleBuffered = False
            ParentDoubleBuffered = False
            TabOrder = 1
          end
          object edtID: TEdit
            Left = 8
            Top = 38
            Width = 121
            Height = 23
            Enabled = False
            ReadOnly = True
            TabOrder = 2
          end
          object mmoDescricao: TMemo
            Left = 7
            Top = 110
            Width = 586
            Height = 67
            Lines.Strings = (
              'mmoDescricao')
            TabOrder = 3
          end
          object cbCliente: TComboBox
            Left = 159
            Top = 38
            Width = 145
            Height = 23
            TabOrder = 4
            Text = 'cbCliente'
          end
        end
      end
      object Panel5: TPanel
        Left = 0
        Top = 185
        Width = 616
        Height = 80
        Align = alTop
        TabOrder = 2
        object grpItens: TGroupBox
          Left = 1
          Top = 1
          Width = 614
          Height = 78
          Align = alClient
          Caption = 'Itens da OS'
          TabOrder = 0
          object lblItemDescricao: TLabel
            Left = 9
            Top = 22
            Width = 95
            Height = 15
            Caption = 'Descri'#231#227'o do Item'
          end
          object lblItemQtd: TLabel
            Left = 138
            Top = 22
            Width = 62
            Height = 15
            Caption = 'Quantidade'
          end
          object lblItemValorUnit: TLabel
            Left = 227
            Top = 22
            Width = 70
            Height = 15
            Caption = 'Valor unit'#225'rio'
          end
          object btnAdicionarItem: TButton
            Left = 376
            Top = 41
            Width = 97
            Height = 25
            Caption = 'Adicionar Item'
            TabOrder = 0
            OnClick = btnAdicionarItemClick
          end
          object btnRemoverItem: TButton
            Left = 487
            Top = 41
            Width = 97
            Height = 25
            Caption = 'Remover Item'
            TabOrder = 1
            OnClick = btnRemoverItemClick
          end
          object edtItemDescricao: TEdit
            Left = 9
            Top = 43
            Width = 121
            Height = 23
            TabOrder = 2
          end
          object edtItemQtd: TEdit
            Left = 138
            Top = 43
            Width = 83
            Height = 23
            TabOrder = 3
          end
          object edtItemValorUnit: TEdit
            Left = 227
            Top = 43
            Width = 121
            Height = 23
            TabOrder = 4
          end
        end
      end
      object Panel6: TPanel
        Left = 0
        Top = 265
        Width = 616
        Height = 183
        Align = alClient
        TabOrder = 3
        object dbgItens: TDBGrid
          Left = 1
          Top = 1
          Width = 614
          Height = 181
          Align = alClient
          DataSource = dsItens
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
        end
      end
    end
  end
  object dsItens: TDataSource
    DataSet = dtmOrdens.mtItens
    Left = 476
    Top = 354
  end
  object dsOrdens: TDataSource
    DataSet = dtmOrdens.qryOrdens
    Left = 548
    Top = 418
  end
end
