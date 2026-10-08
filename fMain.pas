unit fMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ufrmOrdens, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Menus;

type
  TfrmMain = class(TForm)
    btnClientes: TButton;
    btnOrdens: TButton;
    MainMenu1: TMainMenu;
    mnuClientes: TMenuItem;
    mnuCadastros: TMenuItem;
    mnuOrdensServico: TMenuItem;
    mnuSair: TMenuItem;
    StatusBar: TStatusBar;
    pnlAtalhos: TPanel;
    procedure btnClientesClick(Sender: TObject);
    procedure btnOrdensClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mnuClientesClick(Sender: TObject);
    procedure mnuOrdensServicoClick(Sender: TObject);
    procedure mnuSairClick(Sender: TObject);
  private
    { Private declarations }
    procedure AbrirClientes;
    procedure AbrirOrdensServico;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses dmClientes, uClienteServico, ufrmClientes;

procedure TfrmMain.btnClientesClick(Sender: TObject);
begin
  AbrirOrdensServico;
end;

procedure TfrmMain.btnOrdensClick(Sender: TObject);
begin
  AbrirClientes;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  if StatusBar.Panels.Count >= 2 then
  begin
    StatusBar.Panels[0].Text := ' Sistema de Gestão de Ordens de Serviço';
    StatusBar.Panels[1].Text := ' Banco de Dados: Conectado (Firebird)';
  end;
end;

procedure TfrmMain.mnuClientesClick(Sender: TObject);
begin
  AbrirClientes;
end;

procedure TfrmMain.mnuOrdensServicoClick(Sender: TObject);
begin
  AbrirOrdensServico;
end;

procedure TfrmMain.mnuSairClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmMain.AbrirClientes;
var
  LForm: TfrmClientes;
begin
  LForm := TfrmClientes.Create(Self);
  try
    LForm.ShowModal;
  finally
    LForm.Free;
  end;
end;

procedure TfrmMain.AbrirOrdensServico;
var
  LForm: TfrmOrdens;
begin
  LForm := TfrmOrdens.Create(Self);
  try
    LForm.ShowModal;
  finally
    LForm.Free;
  end;
end;

end.
