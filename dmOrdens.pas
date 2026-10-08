unit dmOrdens;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, uOrdemServico, frxExportCSV,
  frxClass, frxExportBaseDialog, frxExportPDF, frxDBSet, frCoreClasses, Dialogs;

type
  TdtmOrdens = class(TDataModule)
    qryOrdens: TFDQuery;
    qryItens: TFDQuery;
    qryManutencao: TFDQuery;
    mtItens: TFDMemTable;
    frxReportOS: TfrxReport;
    frxDBOrdens: TfrxDBDataset;
    frxPDFExport1: TfrxPDFExport;
    frxCSVExport1: TfrxCSVExport;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    procedure ConfigurarMemTable;
  public
    { Public declarations }
    procedure ListarOrdens(const AClienteId: Integer; const AStatus, ADataIni, ADataFim: string);
    procedure CarregarItensOS(const AOrdemId: Integer);
    procedure AdicionarItemMemoria(const ADescricao: string; const AQtd, AValorUnit: Double);
    function CalcularTotalOS: Double;
    function SalvarOrdemServico(const AId, AClienteId: Integer;
      const ADataPrevista: TDateTime; const AStatus, ADescricaoProblema: string): Integer;
    procedure ExcluirOrdemServico(const AOrdemId: Integer);
    procedure NovaOrdemServico;
    procedure ObterResumoStatus(out QAbertas, QAndamento, QConcluidas, QAtrasadas: Integer);
    procedure ImprimirRelatorioOS;
  end;

var
  dtmOrdens: TdtmOrdens;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses dmConexao;

{$R *.dfm}


procedure TdtmOrdens.DataModuleCreate(Sender: TObject);
begin
  qryOrdens.Connection := dtmConexao.FDConnection;
  qryItens.Connection := dtmConexao.FDConnection;
  qryManutencao.Connection := dtmConexao.FDConnection;

  ConfigurarMemTable;
end;

procedure TdtmOrdens.ConfigurarMemTable;
begin
  mtItens.Close;
  mtItens.FieldDefs.Clear;
  mtItens.FieldDefs.Add('DESCRICAO', ftString, 200);
  mtItens.FieldDefs.Add('QUANTIDADE', ftFloat);
  mtItens.FieldDefs.Add('VALOR_UNITARIO', ftFloat);
  mtItens.FieldDefs.Add('SUBTOTAL', ftFloat);
  mtItens.CreateDataSet;
end;

procedure TdtmOrdens.ListarOrdens(const AClienteId: Integer; const AStatus, ADataIni, ADataFim: string);
begin
  qryOrdens.Close;
  qryOrdens.SQL.Clear;
  qryOrdens.SQL.Add('SELECT O.ID, O.CLIENTE_ID, C.NOME AS CLIENTE_NOME,');
  qryOrdens.SQL.Add('       O.DATA_ABERTURA, O.DATA_PREVISTA, O.DATA_FECHAMENTO,');
  qryOrdens.SQL.Add('       O.STATUS, O.DESCRICAO_PROBLEMA, O.VALOR_TOTAL');
  qryOrdens.SQL.Add('FROM ORDEM_SERVICO O');
  qryOrdens.SQL.Add('INNER JOIN CLIENTE C ON (C.ID = O.CLIENTE_ID)');
  qryOrdens.SQL.Add('WHERE 1=1');

  if AClienteId > 0 then
  begin
    qryOrdens.SQL.Add('  AND O.CLIENTE_ID = :CLIENTE_ID');
    qryOrdens.ParamByName('CLIENTE_ID').AsInteger := AClienteId;
  end;

  if not AStatus.Trim.IsEmpty then
  begin
    qryOrdens.SQL.Add('  AND O.STATUS = :STATUS');
    qryOrdens.ParamByName('STATUS').AsString := AStatus;
  end;

  if not ADataIni.Trim.IsEmpty then
  begin
    qryOrdens.SQL.Add('  AND O.DATA_ABERTURA >= :DATA_INI');
    qryOrdens.ParamByName('DATA_INI').AsDate := StrToDate(ADataIni);
  end;

  if not ADataFim.Trim.IsEmpty then
  begin
    qryOrdens.SQL.Add('  AND O.DATA_ABERTURA <= :DATA_FIM');
    qryOrdens.ParamByName('DATA_FIM').AsDate := StrToDate(ADataFim);
  end;

  qryOrdens.SQL.Add('ORDER BY O.ID DESC');
  qryOrdens.Open;
end;

procedure TdtmOrdens.AdicionarItemMemoria(const ADescricao: string; const AQtd, AValorUnit: Double);
begin
  mtItens.Append;
  mtItens.FieldByName('DESCRICAO').AsString      := ADescricao;
  mtItens.FieldByName('QUANTIDADE').AsFloat      := AQtd;
  mtItens.FieldByName('VALOR_UNITARIO').AsFloat := AValorUnit;
  mtItens.FieldByName('SUBTOTAL').AsFloat       := TOrdemServico.CalcularSubtotalItem(AQtd, AValorUnit);
  mtItens.Post;
end;

function TdtmOrdens.CalcularTotalOS: Double;
var
  LTotal: Double;
begin
  LTotal := 0;
  mtItens.First;
  while not mtItens.Eof do
  begin
    LTotal := LTotal + mtItens.FieldByName('SUBTOTAL').AsFloat;
    mtItens.Next;
  end;
  Result := LTotal;
end;

function TdtmOrdens.SalvarOrdemServico(const AId, AClienteId: Integer;
  const ADataPrevista: TDateTime; const AStatus, ADescricaoProblema: string): Integer;
var
  LOrdemId: Integer;
  LTotalOS: Double;
  LConn: TFDConnection;
begin
  LConn := dtmConexao.FDConnection;
  LTotalOS := CalcularTotalOS;

  LConn.StartTransaction;
  try
    if AId = 0 then
    begin
      qryManutencao.Close;
      qryManutencao.SQL.Clear;
      qryManutencao.SQL.Add('INSERT INTO ORDEM_SERVICO (CLIENTE_ID, DATA_ABERTURA, DATA_PREVISTA, STATUS, DESCRICAO_PROBLEMA, VALOR_TOTAL)');
      qryManutencao.SQL.Add('VALUES (:CLIENTE_ID, :DATA_ABERTURA, :DATA_PREVISTA, :STATUS, :DESCRICAO_PROBLEMA, :VALOR_TOTAL)');
      qryManutencao.SQL.Add('RETURNING ID');

      qryManutencao.ParamByName('CLIENTE_ID').AsInteger       := AClienteId;
      qryManutencao.ParamByName('DATA_ABERTURA').AsDate       := Date;
      qryManutencao.ParamByName('DATA_PREVISTA').AsDate       := ADataPrevista;
      qryManutencao.ParamByName('STATUS').AsString            := AStatus;
      qryManutencao.ParamByName('DESCRICAO_PROBLEMA').AsString := ADescricaoProblema;
      qryManutencao.ParamByName('VALOR_TOTAL').AsFloat        := LTotalOS;
      qryManutencao.Open;

      LOrdemId := qryManutencao.FieldByName('ID').AsInteger;
    end
    else
    begin
      LOrdemId := AId;

      qryManutencao.Close;
      qryManutencao.SQL.Clear;
      qryManutencao.SQL.Add('UPDATE ORDEM_SERVICO SET');
      qryManutencao.SQL.Add('  CLIENTE_ID = :CLIENTE_ID, DATA_PREVISTA = :DATA_PREVISTA,');
      qryManutencao.SQL.Add('  STATUS = :STATUS, DESCRICAO_PROBLEMA = :DESCRICAO_PROBLEMA,');
      qryManutencao.SQL.Add('  VALOR_TOTAL = :VALOR_TOTAL');
      if SameText(AStatus, 'Concluida') or SameText(AStatus, 'Cancelada') then
        qryManutencao.SQL.Add(', DATA_FECHAMENTO = CURRENT_DATE');
      qryManutencao.SQL.Add('WHERE ID = :ID');

      qryManutencao.ParamByName('ID').AsInteger               := LOrdemId;
      qryManutencao.ParamByName('CLIENTE_ID').AsInteger       := AClienteId;
      qryManutencao.ParamByName('DATA_PREVISTA').AsDate       := ADataPrevista;
      qryManutencao.ParamByName('STATUS').AsString            := AStatus;
      qryManutencao.ParamByName('DESCRICAO_PROBLEMA').AsString := ADescricaoProblema;
      qryManutencao.ParamByName('VALOR_TOTAL').AsFloat        := LTotalOS;
      qryManutencao.ExecSQL;

      qryManutencao.Close;
      qryManutencao.SQL.Text := 'DELETE FROM ITEM_ORDEM WHERE ORDEM_ID = :ORDEM_ID';
      qryManutencao.ParamByName('ORDEM_ID').AsInteger := LOrdemId;
      qryManutencao.ExecSQL;
    end;

    mtItens.First;
    while not mtItens.Eof do
    begin
      qryManutencao.Close;
      qryManutencao.SQL.Clear;
      qryManutencao.SQL.Add('INSERT INTO ITEM_ORDEM (ORDEM_ID, DESCRICAO, QUANTIDADE, VALOR_UNITARIO)');
      qryManutencao.SQL.Add('VALUES (:ORDEM_ID, :DESCRICAO, :QUANTIDADE, :VALOR_UNITARIO)');

      qryManutencao.ParamByName('ORDEM_ID').AsInteger      := LOrdemId;
      qryManutencao.ParamByName('DESCRICAO').AsString     := mtItens.FieldByName('DESCRICAO').AsString;
      qryManutencao.ParamByName('QUANTIDADE').AsFloat     := mtItens.FieldByName('QUANTIDADE').AsFloat;
      qryManutencao.ParamByName('VALOR_UNITARIO').AsFloat := mtItens.FieldByName('VALOR_UNITARIO').AsFloat;
      qryManutencao.ExecSQL;

      mtItens.Next;
    end;
    LConn.Commit;
    Result := LOrdemId;
  except
    on E: Exception do
    begin
      LConn.Rollback;
      raise Exception.Create('Erro ao salvar a Ordem de Serviço: ' + E.Message);
    end;
  end;
end;

procedure TdtmOrdens.CarregarItensOS(const AOrdemId: Integer);
begin
  ConfigurarMemTable;

  qryItens.Close;
  qryItens.SQL.Text := 'SELECT DESCRICAO, QUANTIDADE, VALOR_UNITARIO FROM ITEM_ORDEM WHERE ORDEM_ID = :ORDEM_ID';
  qryItens.ParamByName('ORDEM_ID').AsInteger := AOrdemId;
  qryItens.Open;

  while not qryItens.Eof do
  begin
    AdicionarItemMemoria(
      qryItens.FieldByName('DESCRICAO').AsString,
      qryItens.FieldByName('QUANTIDADE').AsFloat,
      qryItens.FieldByName('VALOR_UNITARIO').AsFloat
    );
    qryItens.Next;
  end;
end;

procedure TdtmOrdens.ExcluirOrdemServico(const AOrdemId: Integer);
var
  LConn: TFDConnection;
begin
  LConn := dtmConexao.FDConnection;
  LConn.StartTransaction;
  try
    qryManutencao.Close;
    qryManutencao.SQL.Text := 'DELETE FROM ITEM_ORDEM WHERE ORDEM_ID = :ID';
    qryManutencao.ParamByName('ID').AsInteger := AOrdemId;
    qryManutencao.ExecSQL;

    qryManutencao.Close;
    qryManutencao.SQL.Text := 'DELETE FROM ORDEM_SERVICO WHERE ID = :ID';
    qryManutencao.ParamByName('ID').AsInteger := AOrdemId;
    qryManutencao.ExecSQL;

    LConn.Commit;
  except
    on E: Exception do
    begin
      LConn.Rollback;
      raise Exception.Create('Erro ao excluir a Ordem de Serviço: ' + E.Message);
    end;
  end;
end;

procedure TdtmOrdens.NovaOrdemServico;
begin
  ConfigurarMemTable;
end;

procedure TdtmOrdens.ObterResumoStatus(out QAbertas, QAndamento, QConcluidas, QAtrasadas: Integer);
var
  LQry: TFDQuery;
begin
  QAbertas    := 0;
  QAndamento  := 0;
  QConcluidas := 0;
  QAtrasadas  := 0;

  LQry := TFDQuery.Create(nil);
  try
    LQry.Connection := dtmConexao.FDConnection;
    LQry.SQL.Text :=
      'SELECT ' +
      '  SUM(CASE WHEN STATUS = ''Aberta'' THEN 1 ELSE 0 END) AS ABERTAS, ' +
      '  SUM(CASE WHEN STATUS = ''Em Andamento'' THEN 1 ELSE 0 END) AS ANDAMENTO, ' +
      '  SUM(CASE WHEN STATUS = ''Concluida'' THEN 1 ELSE 0 END) AS CONCLUIDAS, ' +
      '  SUM(CASE WHEN STATUS NOT IN (''Concluida'', ''Cancelada'') AND DATA_PREVISTA < CURRENT_DATE THEN 1 ELSE 0 END) AS ATRASADAS ' +
      'FROM ORDEM_SERVICO';

    LQry.Open;

    if not LQry.IsEmpty then
    begin
      QAbertas    := LQry.FieldByName('ABERTAS').AsInteger;
      QAndamento  := LQry.FieldByName('ANDAMENTO').AsInteger;
      QConcluidas := LQry.FieldByName('CONCLUIDAS').AsInteger;
      QAtrasadas  := LQry.FieldByName('ATRASADAS').AsInteger;
    end;
  finally
    LQry.Free;
  end;
end;

procedure TdtmOrdens.ImprimirRelatorioOS;
var
  LPathRelatorio: string;
begin
  if qryOrdens.IsEmpty then
  begin
    ShowMessage('Não existem dados filtrados para gerar o relatório.');
    Exit;
  end;

  LPathRelatorio := ExtractFilePath(ParamStr(0)) + 'RelatorioOS.fr3';

  if FileExists(LPathRelatorio) then
    frxReportOS.LoadFromFile(LPathRelatorio)
  else
  begin
    frxReportOS.DesignReport;
    Exit;
  end;

  frxReportOS.ShowReport;
end;

end.
