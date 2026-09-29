object dtmConexao: TdtmConexao
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 480
  Width = 640
  object FDConnection: TFDConnection
    Left = 40
    Top = 24
  end
  object FDPhysFBDriverLink: TFDPhysFBDriverLink
    Left = 136
    Top = 24
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 272
    Top = 24
  end
end
