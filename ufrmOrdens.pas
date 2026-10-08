unit ufrmOrdens;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Data.DB, dmOrdens, dmClientes, uOrdemServico,
  Vcl.DBCtrls;

type
  TfrmOrdens = class(TForm)
    pgControl: TPageControl;
    tsConsulta: TTabSheet;
    tsCadastro: TTabSheet;
    lblFiltroCliente: TLabel;
    lblFiltroStatus: TLabel;
    lblDataIni: TLabel;
    lblDataFim: TLabel;
    edtFiltroCliente: TEdit;
    cbFiltroStatus: TComboBox;
    dtpDataIni: TDateTimePicker;
    dtpDataFim: TDateTimePicker;
    btnPesquisar: TButton;
    dbgOrdens: TDBGrid;
    pnlBotoesConsulta: TPanel;
    btnNovo: TButton;
    btnEditar: TButton;
    btnExcluir: TButton;
    lblID: TLabel;
    lblCliente: TLabel;
    lblDataPrevista: TLabel;
    lblStatus: TLabel;
    lblDescricao: TLabel;
    edtID: TEdit;
    dtpDataPrevista: TDateTimePicker;
    cbStatus: TComboBox;
    mmoDescricao: TMemo;
    grpItens: TGroupBox;
    lblItemDescricao: TLabel;
    lblItemQtd: TLabel;
    lblItemValorUnit: TLabel;
    edtItemDescricao: TEdit;
    edtItemQtd: TEdit;
    edtItemValorUnit: TEdit;
    btnAdicionarItem: TButton;
    btnRemoverItem: TButton;
    dbgItens: TDBGrid;
    pnlRodapeCadastro: TPanel;
    lblValorTotalCaption: TLabel;
    btnSalvar: TButton;
    btnCancelar: TButton;
    lblValorTotal: TLabel;
    cbCliente: TComboBox;
    dsOrdens: TDataSource;
    dsItens: TDataSource;
    lblTotalAbertas: TLabel;
    lblTotalEmAndamento: TLabel;
    lblTotalConcluidas: TLabel;
    lblTotalAtrasadas: TLabel;
    btnImprimir: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnAdicionarItemClick(Sender: TObject);
    procedure btnRemoverItemClick(Sender: TObject);
    procedure dbgOrdensDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure btnImprimirClick(Sender: TObject);
  private
    procedure LimparCampos;
    procedure AtualizarTotalTela;
    procedure CarregarClientesCombo(AComboBox: TComboBox);
    procedure AlternarAba(const AAbaConsulta: Boolean);
    procedure AtualizarDashboard;
  public
    { Public declarations }
  end;

var
  frmOrdens: TfrmOrdens;

implementation

{$R *.dfm}

procedure TfrmOrdens.FormShow(Sender: TObject);
begin
  if not Assigned(dsOrdens) then
  begin
    dsOrdens := TDataSource.Create(Self);
    dsOrdens.DataSet := dtmOrdens.qryOrdens;
  end;

  if not Assigned(dsItens) then
  begin
    dsItens := TDataSource.Create(Self);
    dsItens.DataSet := dtmOrdens.mtItens;
  end;

  CarregarClientesCombo(cbCliente);
  btnPesquisarClick(Sender);
  AlternarAba(True);
end;

procedure TfrmOrdens.AlternarAba(const AAbaConsulta: Boolean);
begin
   tsConsulta.TabVisible := AAbaConsulta;
   tsCadastro.TabVisible := not AAbaConsulta;
   PgControl.ActivePageIndex := Ord(not AAbaConsulta);
end;

procedure TfrmOrdens.CarregarClientesCombo(AComboBox: TComboBox);
begin
  AComboBox.Items.Clear;
  dtmClientes.ListarClientes('');
  dtmClientes.qryClientes.First;

  while not dtmClientes.qryClientes.Eof do
  begin
    AComboBox.Items.AddObject(
      dtmClientes.qryClientes.FieldByName('NOME').AsString,
      TObject(IntPtr(dtmClientes.qryClientes.FieldByName('ID').AsInteger))
    );
    dtmClientes.qryClientes.Next;
  end;
end;

procedure TfrmOrdens.LimparCampos;
begin
  edtID.Text := '0';
  cbCliente.ItemIndex := -1;
  dtpDataPrevista.Date := Date + 7;
  cbStatus.ItemIndex := 0;
  mmoDescricao.Clear;

  edtItemDescricao.Clear;
  edtItemQtd.Text := '1';
  edtItemValorUnit.Text := '0,00';

  dtmOrdens.mtItens.Close;
  dtmOrdens.mtItens.CreateDataSet;
  AtualizarTotalTela;
end;

procedure TfrmOrdens.AtualizarTotalTela;
begin
  lblValorTotal.Caption := FormatFloat('R$ #,##0.00', dtmOrdens.CalcularTotalOS);
end;

procedure TfrmOrdens.btnPesquisarClick(Sender: TObject);
var
  LClienteId: Integer;
  LStatus: string;
begin
  LClienteId := 0;
  LStatus := '';
  if cbFiltroStatus.ItemIndex > 0 then
    LStatus := cbFiltroStatus.Text;

  dtmOrdens.ListarOrdens(
    LClienteId,
    LStatus,
    DateToStr(dtpDataIni.Date),
    DateToStr(dtpDataFim.Date)
  );

  AtualizarDashboard;
end;

procedure TfrmOrdens.btnNovoClick(Sender: TObject);
begin
  dtmOrdens.NovaOrdemServico;
  LimparCampos;
  AlternarAba(False);
  cbCliente.SetFocus;
end;

procedure TfrmOrdens.btnExcluirClick(Sender: TObject);
var
  LOrdemId: Integer;
begin
  if dtmOrdens.qryOrdens.IsEmpty then
    Exit;

  LOrdemId := dtmOrdens.qryOrdens.FieldByName('ID').AsInteger;

  if MessageDlg(Format('Deseja realmente excluir a Ordem de Serviço nº %d e seus itens?', [LOrdemId]),
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      dtmOrdens.ExcluirOrdemServico(LOrdemId);
      ShowMessage('Ordem de Serviço excluída com sucesso!');
      btnPesquisarClick(Sender);
    except
      on E: Exception do
        ShowMessage('Erro ao excluir: ' + E.Message);
    end;
  end;
end;

procedure TfrmOrdens.btnImprimirClick(Sender: TObject);
begin
  dtmOrdens.ImprimirRelatorioOS;
end;

procedure TfrmOrdens.btnCancelarClick(Sender: TObject);
begin
  AlternarAba(True);
end;

procedure TfrmOrdens.btnAdicionarItemClick(Sender: TObject);
var
  LQtd, LValor: Double;
begin
  if Trim(edtItemDescricao.Text) = '' then
  begin
    ShowMessage('Informe a descrição do item.');
    Exit;
  end;

  LQtd := StrToFloatDef(edtItemQtd.Text, 1);
  LValor := StrToFloatDef(edtItemValorUnit.Text, 0);

  dtmOrdens.AdicionarItemMemoria(edtItemDescricao.Text, LQtd, LValor);

  edtItemDescricao.Clear;
  edtItemQtd.Text := '1';
  edtItemValorUnit.Text := '0,00';
  edtItemDescricao.SetFocus;

  AtualizarTotalTela;
end;

procedure TfrmOrdens.btnRemoverItemClick(Sender: TObject);
begin
  if not dtmOrdens.mtItens.IsEmpty then
  begin
    dtmOrdens.mtItens.Delete;
    AtualizarTotalTela;
  end;
end;

procedure TfrmOrdens.btnSalvarClick(Sender: TObject);
var
  LId, LClienteId: Integer;
begin
  LId := StrToIntDef(edtID.Text, 0);

  if cbCliente.ItemIndex = -1 then
  begin
    ShowMessage('Selecione um cliente para a Ordem de Serviço.');
    cbCliente.SetFocus;
    Exit;
  end;

  if Trim(mmoDescricao.Text) = '' then
  begin
    ShowMessage('Informe a descrição do problema relatado pelo cliente.');
    mmoDescricao.SetFocus;
    Exit;
  end;

  if dtmOrdens.mtItens.IsEmpty then
  begin
    ShowMessage('Adicione pelo menos um item ou serviço à Ordem de Serviço antes de salvar.');
    edtItemDescricao.SetFocus;
    Exit;
  end;

  LClienteId := Integer(IntPtr(cbCliente.Items.Objects[cbCliente.ItemIndex]));

  try
    dtmOrdens.SalvarOrdemServico(
      LId,
      LClienteId,
      dtpDataPrevista.Date,
      cbStatus.Text,
      mmoDescricao.Text
    );

    ShowMessage('Ordem de Serviço salva com sucesso!');
    btnPesquisarClick(Sender);
    AlternarAba(True);
  except
    on E: Exception do
      ShowMessage('Atenção: ' + E.Message);
  end;

  AtualizarDashboard;

end;

procedure TfrmOrdens.btnEditarClick(Sender: TObject);
var
  LOrdemId, I: Integer;
  LClienteId: Integer;
begin
  if dtmOrdens.qryOrdens.IsEmpty then
    Exit;

  LOrdemId := dtmOrdens.qryOrdens.FieldByName('ID').AsInteger;
  LClienteId := dtmOrdens.qryOrdens.FieldByName('CLIENTE_ID').AsInteger;

  edtID.Text := LOrdemId.ToString;
  dtpDataPrevista.Date := dtmOrdens.qryOrdens.FieldByName('DATA_PREVISTA').AsDateTime;
  cbStatus.ItemIndex := cbStatus.Items.IndexOf(dtmOrdens.qryOrdens.FieldByName('STATUS').AsString);
  mmoDescricao.Text := dtmOrdens.qryOrdens.FieldByName('DESCRICAO_PROBLEMA').AsString;

  for I := 0 to cbCliente.Items.Count - 1 do
  begin
    if Integer(IntPtr(cbCliente.Items.Objects[I])) = LClienteId then
    begin
      cbCliente.ItemIndex := I;
      Break;
    end;
  end;

  dtmOrdens.CarregarItensOS(LOrdemId);
  AtualizarTotalTela;
  AlternarAba(False);
end;

procedure TfrmOrdens.dbgOrdensDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  LDataPrevista: TDateTime;
  LStatus: string;
  LAtrasado: Boolean;
begin
  if not dtmOrdens.qryOrdens.IsEmpty then
  begin
    LDataPrevista := dtmOrdens.qryOrdens.FieldByName('DATA_PREVISTA').AsDateTime;
    LStatus := dtmOrdens.qryOrdens.FieldByName('STATUS').AsString;

    LAtrasado := TOrdemServico.VerificarAtraso(LDataPrevista, LStatus);

    if LAtrasado and (not (gdSelected in State)) then
    begin
      dbgOrdens.Canvas.Brush.Color := $00C0C0FF;
      dbgOrdens.Canvas.Font.Color := clBlack;
      dbgOrdens.DefaultDrawColumnCell(Rect, DataCol, Column, State);
    end;
  end;
end;

procedure TfrmOrdens.AtualizarDashboard;
var
  LAbertas, LAndamento, LConcluidas, LAtrasadas: Integer;
begin
  dtmOrdens.ObterResumoStatus(LAbertas, LAndamento, LConcluidas, LAtrasadas);

  lblTotalAbertas.Caption     := 'Abertas: ' + IntToStr(LAbertas);
  lblTotalEmAndamento.Caption := 'Em Andamento: ' + IntToStr(LAndamento);
  lblTotalConcluidas.Caption  := 'Concluídas: ' + IntToStr(LConcluidas);
  lblTotalAtrasadas.Caption   := 'Em Atraso: ' + IntToStr(LAtrasadas);
end;


end.
