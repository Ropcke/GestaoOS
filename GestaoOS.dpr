program GestaoOS;

uses
  Vcl.Forms,
  fMain in 'fMain.pas' {frmMain},
  dmConexao in 'dmConexao.pas' {dtmConexao: TDataModule},
  dmClientes in 'dmClientes.pas' {dtmClientes: TDataModule},
  uClienteServico in 'uClienteServico.pas',
  ufrmClientes in 'ufrmClientes.pas' {frmClientes},
  uOrdemServico in 'uOrdemServico.pas',
  dmOrdens in 'dmOrdens.pas' {dtmOrdens: TDataModule},
  ufrmOrdens in 'ufrmOrdens.pas' {frmOrdens};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdtmConexao, dtmConexao);
  Application.CreateForm(TdtmClientes, dtmClientes);
  Application.CreateForm(TfrmClientes, frmClientes);
  Application.CreateForm(TdtmOrdens, dtmOrdens);
  Application.CreateForm(TfrmOrdens, frmOrdens);
  Application.Run;
end.
