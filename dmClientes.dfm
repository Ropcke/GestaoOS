object dtmClientes: TdtmClientes
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object qryClientes: TFDQuery
    Connection = dtmConexao.FDConnection
    Left = 192
    Top = 184
  end
  object qryManutencao: TFDQuery
    Connection = dtmConexao.FDConnection
    Left = 320
    Top = 184
  end
end
