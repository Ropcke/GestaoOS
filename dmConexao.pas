unit dmConexao;

interface

uses
  System.SysUtils, System.Classes, System.IniFiles, Vcl.Dialogs, Vcl.Forms,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Comp.UI,
  FireDAC.Phys.IBBase, FireDAC.Phys.FB, Data.DB, FireDAC.Comp.Client;

type
  TdtmConexao = class(TDataModule)
    FDConnection: TFDConnection;
    FDPhysFBDriverLink: TFDPhysFBDriverLink;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    procedure CarregarConfiguracaoINI;
    { Private declarations }
  public
    procedure Conectar;
    procedure Desconectar;
    { Public declarations }
  end;

var
  dtmConexao: TdtmConexao;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdtmConexao.DataModuleCreate(Sender: TObject);
begin
  CarregarConfiguracaoINI;
  Conectar;
end;

procedure TdtmConexao.DataModuleDestroy(Sender: TObject);
begin
  Desconectar;
end;

procedure TdtmConexao.CarregarConfiguracaoINI;
var
LIniFile: TIniFile;
LCaminhoIni: string;
LCaminhoBanco: string;
LVendorLib: string;
LCharSet: string;
begin
  LCaminhoIni := ExtractFilePath(ParamStr(0)) + 'conexao.ini';

  if not FileExists(LCaminhoIni) then
    LCaminhoIni := ExpandFileName(ExtractFilePath(ParamStr(0)) + '..\..\conexao.ini');

  if not FileExists(LCaminhoIni) then
    raise Exception.Create('Arquivo "conexao.ini" não encontrado: ' + LCaminhoIni);

    LIniFile := TIniFile.Create(LCaminhoIni);
    try
      LCaminhoBanco := LIniFile.ReadString('CONEXAO', 'Database', 'GESTAO_OS.FDB');

      if ExtractFileDrive(LCaminhoBanco) = '' then
      LCaminhoBanco := ExtractFilePath(ParamStr(0)) + LCaminhoBanco;

      LCharSet := LIniFile.ReadString('CONEXAO', 'CharacterSet', 'UTF8');

      FDConnection.Params.Clear;
      FDConnection.Params.DriverID := LIniFile.ReadString('CONEXAO', 'DriverID', 'FB');
      FDConnection.Params.Database := LCaminhoBanco;
      FDConnection.Params.UserName := LIniFile.ReadString('CONEXAO', 'User', 'SYSDBA');
      FDConnection.Params.Password := LIniFile.ReadString('CONEXAO', 'Password', 'masterkey');
      FDConnection.Params.Add('Server=' + LIniFile.ReadString('CONEXAO', 'Server', 'localhost'));
      FDConnection.Params.Add('Port=' + LIniFile.ReadString('CONEXAO', 'Port', '3050'));
      FDConnection.Params.Add('CharacterSet=' + LCharSet);

      if LIniFile.ValueExists('CONEXAO', 'VendorLib') then
      begin
        LVendorLib := LIniFile.ReadString('CONEXAO', 'VendorLib', 'fbclient.dll');
        if ExtractFileDrive(LVendorLib) = '' then
          LVendorLib := ExtractFilePath(ParamStr(0)) + LVendorLib;

        FDPhysFBDriverLink.VendorLib := LVendorLib;
      end;

      FDConnection.LoginPrompt := False;
   finally
    LIniFile.Free;
   end;
end;

procedure TdtmConexao.Conectar;
begin
  if not FDConnection.Connected then
  begin
    try
      FDConnection.Connected := True;
    except
      on E: Exception do
        ShowMessage('Erro ao conectar com o banco de dados Firebird:' + sLineBreak + E.Message);
    end;
  end;
end;

procedure TdtmConexao.Desconectar;
begin
  if FDConnection.Connected then
    FDConnection.Connected := False;
end;



end.
