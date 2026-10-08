unit uOrdemServico;

interface

uses

System.SysUtils, System.DateUtils;

type
  TOrdemServico = class
  public
    class function CalcularSubtotalItem(const AQuantidade, AValorUnitario: Double): Double;

    class function VerificarAtraso(const ADataPrevista: TDateTime; const AStatus: string): Boolean;
  end;

implementation

{ TOrdemServico }

class function TOrdemServico.CalcularSubtotalItem(const AQuantidade, AValorUnitario: Double): Double;
begin
  Result := AQuantidade * AValorUnitario;
end;

class function TOrdemServico.VerificarAtraso(const ADataPrevista: TDateTime; const AStatus: string): Boolean;
begin
  Result := (ADataPrevista < Date) and
            (not SameText(AStatus, 'Concluida')) and
            (not SameText(AStatus, 'Cancelada'));
end;


end.
