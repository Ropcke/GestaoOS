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
    procedure InserirCliente(const ANome, ACpfCnpj, ATelefone, AEmail, AEndereco: string);
    procedure AlterarCliente(const AId: Integer; const ANome, ACpfCnpj, ATelefone, AEmail, AEndereco: string);
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
  qryClientes.SQL.Add('SELECT ID_CLIENTE, NOME, CPF_CNPJ, TELEFONE, EMAIL, ENDERECO, DATA_CADASTRO');
  qryClientes.SQL.Add('FROM CLIENTES');

  if not AFiltroNome.Trim.IsEmpty then
  begin
    qryClientes.SQL.Add('WHERE (UPPER(NOME) LIKE UPPER(:FILTRO)) OR (CPF_CNPJ LIKE :FILTRO)');
    qryClientes.ParamByName('FILTRO').AsString := '%' + AFiltroNome.Trim + '%';
  end;

  qryClientes.SQL.Add('ORDER BY NOME');
  qryClientes.Open;
end;

procedure TdtmClientes.InserirCliente(const ANome, ACpfCnpj, ATelefone, AEmail, AEndereco: string);
begin
  TClienteServico.ValidarCliente(ANome, ACpfCnpj, AEmail);

  qryManutencao.Close;
  qryManutencao.SQL.Clear;
  qryManutencao.SQL.Add('INSERT INTO CLIENTES (NOME, CPF_CNPJ, TELEFONE, EMAIL, ENDERECO, DATA_CADASTRO)');
  qryManutencao.SQL.Add('VALUES (:NOME, :CPF_CNPJ, :TELEFONE, :EMAIL, :ENDERECO, CURRENT_TIMESTAMP)');

  qryManutencao.ParamByName('NOME').AsString      := ANome.Trim;
  qryManutencao.ParamByName('CPF_CNPJ').AsString  := TClienteServico.FormatarDocumento(ACpfCnpj);
  qryManutencao.ParamByName('TELEFONE').AsString  := ATelefone.Trim;
  qryManutencao.ParamByName('EMAIL').AsString     := AEmail.Trim;
  qryManutencao.ParamByName('ENDERECO').AsString  := AEndereco.Trim;

  qryManutencao.ExecSQL;
end;

procedure TdtmClientes.AlterarCliente(const AId: Integer; const ANome, ACpfCnpj, ATelefone, AEmail, AEndereco: string);
begin
  TClienteServico.ValidarCliente(ANome, ACpfCnpj, AEmail);

  qryManutencao.Close;
  qryManutencao.SQL.Clear;
  qryManutencao.SQL.Add('UPDATE CLIENTES SET');
  qryManutencao.SQL.Add('  NOME = :NOME,');
  qryManutencao.SQL.Add('  CPF_CNPJ = :CPF_CNPJ,');
  qryManutencao.SQL.Add('  TELEFONE = :TELEFONE,');
  qryManutencao.SQL.Add('  EMAIL = :EMAIL,');
  qryManutencao.SQL.Add('  ENDERECO = :ENDERECO');
  qryManutencao.SQL.Add('WHERE ID_CLIENTE = :ID');

  qryManutencao.ParamByName('ID').AsInteger       := AId;
  qryManutencao.ParamByName('NOME').AsString      := ANome.Trim;
  qryManutencao.ParamByName('CPF_CNPJ').AsString  := TClienteServico.FormatarDocumento(ACpfCnpj);
  qryManutencao.ParamByName('TELEFONE').AsString  := ATelefone.Trim;
  qryManutencao.ParamByName('EMAIL').AsString     := AEmail.Trim;
  qryManutencao.ParamByName('ENDERECO').AsString  := AEndereco.Trim;

  qryManutencao.ExecSQL;
end;

procedure TdtmClientes.ExcluirCliente(const AId: Integer);
begin
  qryManutencao.Close;
  qryManutencao.SQL.Clear;
  qryManutencao.SQL.Add('DELETE FROM CLIENTES WHERE ID_CLIENTE = :ID');
  qryManutencao.ParamByName('ID').AsInteger := AId;

  try
    qryManutencao.ExecSQL;
  except
    on E: Exception do
      raise Exception.Create('Não é possível excluir este cliente pois existem registros vinculados a ele: ' + E.Message);
  end;
end;

end.
