unit ufrmClientes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TfrmClientes = class(TForm)
    pgcPrincipal: TPageControl;
    tsConsulta: TTabSheet;
    tsCadastro: TTabSheet;
    pnlPesquisa: TPanel;
    lbpesquisar: TLabel;
    edtPesquisa: TEdit;
    btnPesquisar: TButton;
    gridClientes: TDBGrid;
    dsClientes: TDataSource;
    pnlEditar: TPanel;
    btnNovo: TButton;
    btnEditar: TButton;
    btnExcluir: TButton;
    edtID: TEdit;
    edtDocumento: TEdit;
    edtNome: TEdit;
    edtTelefone: TEdit;
    edtEmail: TEdit;
    Panel1: TPanel;
    btnSalvar: TButton;
    btnCancelar: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure gridClientesDblClick(Sender: TObject);
  private
    { Private declarations }
    procedure LimparCampos;
    procedure CarregarDadosParaEdicao;
    procedure AlternarAba(const AAbaConsulta: Boolean);
  public
    { Public declarations }
  end;

var
  frmClientes: TfrmClientes;

implementation

{$R *.dfm}

uses dmClientes, uClienteServico;

procedure TfrmClientes.FormShow(Sender: TObject);
begin
  AlternarAba(True);
  dtmClientes.ListarClientes('');
end;

procedure TfrmClientes.AlternarAba(const AAbaConsulta: Boolean);
begin
  if AAbaConsulta then
  begin
    tsConsulta.TabVisible := True;
    tsCadastro.TabVisible := False;
    pgcPrincipal.ActivePage := tsConsulta;
  end
  else
  begin
    tsConsulta.TabVisible := False;
    tsCadastro.TabVisible := True;
    pgcPrincipal.ActivePage := tsCadastro;
  end;
end;

procedure TfrmClientes.LimparCampos;
begin
  edtID.Text := '0';
  edtNome.Clear;
  edtDocumento.Clear;
  edtTelefone.Clear;
  edtEmail.Clear;
end;

procedure TfrmClientes.btnPesquisarClick(Sender: TObject);
begin
  dtmClientes.ListarClientes(edtPesquisa.Text);
end;

procedure TfrmClientes.btnNovoClick(Sender: TObject);
begin
  LimparCampos;
  AlternarAba(False);
  edtNome.SetFocus;
end;

procedure TfrmClientes.CarregarDadosParaEdicao;
begin
  if dtmClientes.qryClientes.IsEmpty then
    Exit;

  edtID.Text       := dtmClientes.qryClientes.FieldByName('ID').AsString;
  edtNome.Text     := dtmClientes.qryClientes.FieldByName('NOME').AsString;
  edtDocumento.Text := dtmClientes.qryClientes.FieldByName('DOCUMENTO').AsString;
  edtTelefone.Text := dtmClientes.qryClientes.FieldByName('TELEFONE').AsString;
  edtEmail.Text    := dtmClientes.qryClientes.FieldByName('EMAIL').AsString;

  AlternarAba(False);
  edtNome.SetFocus;
end;

procedure TfrmClientes.btnEditarClick(Sender: TObject);
begin
  if dtmClientes.qryClientes.IsEmpty then
  begin
    ShowMessage('Selecione um cliente na lista para editar.');
    Exit;
  end;
  CarregarDadosParaEdicao;
end;

procedure TfrmClientes.gridClientesDblClick(Sender: TObject);
begin
  if not dtmClientes.qryClientes.IsEmpty then
    CarregarDadosParaEdicao;
end;

procedure TfrmClientes.btnSalvarClick(Sender: TObject);
var
  LId: Integer;
begin
  LId := StrToIntDef(edtID.Text, 0);

  try
    if LId = 0 then
    begin
      dtmClientes.InserirCliente(
        edtNome.Text,
        edtDocumento.Text,
        edtTelefone.Text,
        edtEmail.Text
      );
      ShowMessage('Cliente cadastrado com sucesso!');
    end
    else
    begin
      dtmClientes.AlterarCliente(
        LId,
        edtNome.Text,
        edtDocumento.Text,
        edtTelefone.Text,
        edtEmail.Text
      );
      ShowMessage('Dados do cliente atualizados com sucesso!');
    end;
    dtmClientes.ListarClientes(edtPesquisa.Text);
    AlternarAba(True);

  except
    on E: Exception do
    begin
      ShowMessage('Atenção: ' + E.Message);
    end;
  end;
end;

procedure TfrmClientes.btnCancelarClick(Sender: TObject);
begin
  LimparCampos;
  AlternarAba(True);
end;

procedure TfrmClientes.btnExcluirClick(Sender: TObject);
var
  LId: Integer;
  LNome: string;
begin
  if dtmClientes.qryClientes.IsEmpty then
  begin
    ShowMessage('Selecione um cliente para excluir.');
    Exit;
  end;

  LId := dtmClientes.qryClientes.FieldByName('ID').AsInteger;
  LNome := dtmClientes.qryClientes.FieldByName('NOME').AsString;

  if MessageDlg('Tem certeza que deseja excluir o cliente "' + LNome + '"?',
     mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      dtmClientes.ExcluirCliente(LId);
      ShowMessage('Cliente excluído com sucesso!');
      dtmClientes.ListarClientes(edtPesquisa.Text);
    except
      on E: Exception do
        ShowMessage(E.Message);
    end;
  end;
end;

end.
