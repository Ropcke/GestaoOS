unit uClienteServico;

interface

uses
  System.SysUtils, System.RegularExpressions;

type
  TClienteServico = class
  public
    class procedure ValidarCliente(const ANome, ADocumento, AEmail: string);
    class function FormatarDocumento(const ADocumento: string): string;
  end;

implementation

class procedure TClienteServico.ValidarCliente(const ANome, ADocumento, AEmail: string);
begin
  if ANome.Trim.IsEmpty then
    raise Exception.Create('O nome do cliente é obrigatório. ');

  if Length(ANome.Trim) < 3 then
    raise Exception.Create('O nome do cliente deve ter no mínimo 3 caracteres. ');

  if not AEmail.Trim.IsEmpty then
  begin
    if not TRegEx.IsMatch(AEmail.Trim, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$') then
      raise Exception.Create('O e-mail informado não possui um formato válido.');
  end;
end;

class function TClienteServico.FormatarDocumento(const ADocumento: string): string;
begin
  Result := TRegEx.Replace(ADocumento, '[^\d]', '');
end;



end.
