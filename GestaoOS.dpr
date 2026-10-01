program GestaoOS;

uses
  Vcl.Forms,
  fMain in 'fMain.pas' {frmClientes},
  dmConexao in 'dmConexao.pas' {dtmConexao: TDataModule},
  dmClientes in 'dmClientes.pas' {dtmClientes: TDataModule},
  uClienteServico in 'uClienteServico.pas',
  ufrmClientes in 'ufrmClientes.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmClientes, frmClientes);
  Application.CreateForm(TdtmConexao, dtmConexao);
  Application.CreateForm(TdtmClientes, dtmClientes);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
