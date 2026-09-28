program GestaoOS;

uses
  Vcl.Forms,
  fMain in 'fMain.pas' {Form1},
  dmConexao in 'dmConexao.pas' {dtmConexao: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TdtmConexao, dtmConexao);
  Application.Run;
end.
