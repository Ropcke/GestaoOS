unit dmClientes;

interface

uses
  System.SysUtils, System.Classes, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uClienteServico;

type
  TdtmClientes = class(TDataModule)
    qryClientes: TFDQuery;
    qryManutencao: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ListarClientes(const AFiltroNome: string = '');
    procedure InserirCliente(const ANome, ADocumento, ATelefone, AEmail: string);
    procedure AlterarCliente(const AId: Integer; const ANome, ADocumento, ATelefone, AEmail: string);
    procedure ExcluirCliente(const AId: Integer);
  end;

var
  dtmClientes: TdtmClientes;

implementation

uses
  dmConexao;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdtmClientes.DataModuleCreate(Sender: TObject);
begin
  if qryClientes.Active then
    qryClientes.Close;
end;

procedure TdtmClientes.ListarClientes(const AFiltroNome: string);
begin
  qryClientes.Close;
  qryClientes.SQL.Clear;
  qryClientes.SQL.Add('SELECT ID, NOME, DOCUMENTO, TELEFONE, EMAIL, DATA_CADASTRO');
  qryClientes.SQL.Add('FROM CLIENTE');

  if not AFiltroNome.Trim.IsEmpty then
  begin
    qryClientes.SQL.Add('WHERE (UPPER(NOME) LIKE UPPER(:FILTRO)) OR (DOCUMENTO LIKE :FILTRO)');
    qryClientes.ParamByName('FILTRO').AsString := '%' + AFiltroNome.Trim + '%';
  end;

  qryClientes.SQL.Add('ORDER BY NOME');
  qryClientes.Open;
end;

procedure TdtmClientes.InserirCliente(const ANome, ADocumento, ATelefone, AEmail: string);
begin
  TClienteServico.ValidarCliente(ANome, ADocumento, AEmail);

  qryManutencao.Close;
  qryManutencao.SQL.Clear;
  qryManutencao.SQL.Add('INSERT INTO CLIENTE (NOME, DOCUMENTO, TELEFONE, EMAIL, DATA_CADASTRO)');
  qryManutencao.SQL.Add('VALUES (:NOME, :DOCUMENTO, :TELEFONE, :EMAIL, CURRENT_TIMESTAMP)');

  qryManutencao.ParamByName('NOME').AsString      := ANome.Trim;
  qryManutencao.ParamByName('DOCUMENTO').AsString  := TClienteServico.FormatarDocumento(ADocumento);
  qryManutencao.ParamByName('TELEFONE').AsString  := ATelefone.Trim;
  qryManutencao.ParamByName('EMAIL').AsString     := AEmail.Trim;

  qryManutencao.ExecSQL;
end;

procedure TdtmClientes.AlterarCliente(const AId: Integer; const ANome, ADocumento, ATelefone, AEmail: string);
begin
  TClienteServico.ValidarCliente(ANome, ADocumento, AEmail);

  qryManutencao.Close;
  qryManutencao.SQL.Clear;
  qryManutencao.SQL.Add('UPDATE CLIENTE SET');
  qryManutencao.SQL.Add('  NOME = :NOME,');
  qryManutencao.SQL.Add('  DOCUMENTO = :DOCUMENTO,');
  qryManutencao.SQL.Add('  TELEFONE = :TELEFONE,');
  qryManutencao.SQL.Add('  EMAIL = :EMAIL');
  qryManutencao.SQL.Add('WHERE ID = :ID');

  qryManutencao.ParamByName('ID').AsInteger       := AId;
  qryManutencao.ParamByName('NOME').AsString      := ANome.Trim;
  qryManutencao.ParamByName('DOCUMENTO').AsString  := TClienteServico.FormatarDocumento(ADocumento);
  qryManutencao.ParamByName('TELEFONE').AsString  := ATelefone.Trim;
  qryManutencao.ParamByName('EMAIL').AsString     := AEmail.Trim;

  qryManutencao.ExecSQL;
end;

procedure TdtmClientes.ExcluirCliente(const AId: Integer);
begin
  qryManutencao.Close;
  qryManutencao.SQL.Clear;
  qryManutencao.SQL.Add('DELETE FROM CLIENTE WHERE ID = :ID');
  qryManutencao.ParamByName('ID').AsInteger := AId;

  try
    qryManutencao.ExecSQL;
  except
    on E: Exception do
      raise Exception.Create('Não é possível excluir este cliente pois existem registros vinculados a ele: ' + E.Message);
  end;
end;

end.
