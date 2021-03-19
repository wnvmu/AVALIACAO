object PedidoVendas: TPedidoVendas
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Pedidos de Venda - Candidado -  Wellington'
  ClientHeight = 567
  ClientWidth = 689
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 41
    Width = 689
    Height = 81
    Align = alTop
    Caption = 'Cliente '
    TabOrder = 0
    ExplicitTop = 0
    ExplicitWidth = 679
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 37
      Height = 13
      Caption = 'C'#243'digo:'
    end
    object Label2: TLabel
      Left = 88
      Top = 24
      Width = 31
      Height = 13
      Caption = 'Nome:'
    end
    object Label3: TLabel
      Left = 360
      Top = 24
      Width = 37
      Height = 13
      Caption = 'Cidade:'
    end
    object Label4: TLabel
      Left = 560
      Top = 24
      Width = 37
      Height = 13
      Caption = 'Estado:'
    end
    object EdCodigo: TEdit
      Left = 16
      Top = 43
      Width = 66
      Height = 21
      CharCase = ecUpperCase
      Enabled = False
      TabOrder = 0
    end
    object EdNome: TEdit
      Left = 88
      Top = 43
      Width = 266
      Height = 21
      CharCase = ecUpperCase
      Enabled = False
      TabOrder = 1
    end
    object EdCidade: TEdit
      Left = 360
      Top = 43
      Width = 194
      Height = 21
      CharCase = ecUpperCase
      Enabled = False
      TabOrder = 2
    end
    object CBUF: TComboBox
      Left = 560
      Top = 43
      Width = 81
      Height = 21
      CharCase = ecUpperCase
      Enabled = False
      TabOrder = 3
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 122
    Width = 689
    Height = 352
    Align = alTop
    Caption = 'Produto'
    TabOrder = 1
    ExplicitLeft = -1
    ExplicitTop = 117
    object Label5: TLabel
      Left = 16
      Top = 32
      Width = 37
      Height = 13
      Caption = 'C'#243'digo:'
    end
    object Label6: TLabel
      Left = 220
      Top = 32
      Width = 50
      Height = 13
      Caption = 'Descri'#231#227'o:'
    end
    object Label7: TLabel
      Left = 421
      Top = 32
      Width = 60
      Height = 13
      Caption = 'Quantidade:'
    end
    object Label8: TLabel
      Left = 500
      Top = 32
      Width = 36
      Height = 13
      Caption = 'V. Unit:'
    end
    object Label9: TLabel
      Left = 562
      Top = 32
      Width = 28
      Height = 13
      Caption = 'Total:'
    end
    object EdIten: TEdit
      Left = 3
      Top = 51
      Width = 66
      Height = 21
      CharCase = ecUpperCase
      Enabled = False
      TabOrder = 0
    end
    object EdDescricao: TEdit
      Left = 69
      Top = 51
      Width = 348
      Height = 21
      CharCase = ecUpperCase
      Enabled = False
      TabOrder = 1
    end
    object EdQuant: TEdit
      Left = 417
      Top = 51
      Width = 67
      Height = 21
      CharCase = ecUpperCase
      Enabled = False
      TabOrder = 2
      OnKeyPress = EdQuantKeyPress
    end
    object Button1: TButton
      Left = 620
      Top = 51
      Width = 54
      Height = 21
      Caption = 'Adicionar'
      Enabled = False
      TabOrder = 5
      OnClick = Button1Click
    end
    object DBGrid1: TDBGrid
      Left = 2
      Top = 78
      Width = 685
      Height = 272
      Align = alBottom
      DataSource = DataSource1
      Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 6
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnKeyDown = DBGrid1KeyDown
      Columns = <
        item
          Expanded = False
          FieldName = 'id'
          Title.Caption = 'C'#211'DIGO'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'nome'
          Title.Caption = 'DESCRI'#199#195'O'
          Width = 350
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'qt'
          Title.Caption = 'QUANT.'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'vu'
          Title.Caption = 'V. UNIT.'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'vt'
          Title.Caption = 'V. TOTAL'
          Visible = True
        end>
    end
    object Edvunit: TEdit
      Left = 484
      Top = 51
      Width = 65
      Height = 21
      CharCase = ecUpperCase
      Enabled = False
      TabOrder = 3
      OnExit = EdvunitExit
      OnKeyPress = EdvunitKeyPress
    end
    object EdTotal: TEdit
      Left = 549
      Top = 51
      Width = 65
      Height = 21
      CharCase = ecUpperCase
      Enabled = False
      TabOrder = 4
      OnExit = EdTotalExit
      OnKeyPress = EdTotalKeyPress
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 474
    Width = 689
    Height = 74
    Align = alClient
    TabOrder = 2
    ExplicitTop = 433
    ExplicitWidth = 679
    ExplicitHeight = 72
    object BtPedido: TButton
      Left = 1
      Top = 1
      Width = 118
      Height = 72
      Align = alLeft
      Caption = 'Iniciar Pedido'
      TabOrder = 0
      OnClick = BtPedidoClick
      ExplicitHeight = 70
    end
    object BtCancelar: TButton
      Left = 119
      Top = 1
      Width = 118
      Height = 72
      Align = alLeft
      Caption = 'Cancelar Pedido'
      Enabled = False
      TabOrder = 1
      OnClick = BtCancelarClick
      ExplicitHeight = 70
    end
    object SalvarPedido: TButton
      Left = 237
      Top = 1
      Width = 118
      Height = 72
      Align = alLeft
      Caption = 'Salvar Pedido'
      Enabled = False
      TabOrder = 2
      OnClick = SalvarPedidoClick
      ExplicitHeight = 70
    end
    object GroupBox3: TGroupBox
      Left = 503
      Top = 1
      Width = 185
      Height = 72
      Align = alRight
      Caption = 'TOTAL DA VENDA'
      TabOrder = 3
      ExplicitLeft = 506
      ExplicitTop = 4
      ExplicitHeight = 105
      object LBSomatorio: TLabel
        Left = 3
        Top = 24
        Width = 101
        Height = 29
        Caption = 'R$: 0,00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -24
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object Button3: TButton
      Left = 355
      Top = 1
      Width = 118
      Height = 72
      Align = alLeft
      Caption = 'Excluir Pedido'
      Enabled = False
      TabOrder = 4
      OnClick = Button3Click
      ExplicitHeight = 70
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 548
    Width = 689
    Height = 19
    Panels = <
      item
        Text = 'Data'
        Width = 30
      end
      item
        Width = 70
      end
      item
        Text = 'Hora'
        Width = 40
      end
      item
        Width = 80
      end>
    ExplicitLeft = 560
    ExplicitTop = 528
    ExplicitWidth = 0
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 689
    Height = 41
    Align = alTop
    TabOrder = 4
    ExplicitLeft = -8
    ExplicitTop = -15
    ExplicitWidth = 679
    object Label10: TLabel
      Left = 16
      Top = 14
      Width = 71
      Height = 13
      Caption = 'Buscar Pedido:'
    end
    object Label11: TLabel
      Left = 318
      Top = 14
      Width = 72
      Height = 13
      Caption = 'Buscar Cliente:'
    end
    object Edit1: TEdit
      Left = 93
      Top = 11
      Width = 121
      Height = 21
      TabOrder = 0
      OnKeyPress = Edit1KeyPress
    end
    object Button2: TButton
      Left = 220
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Buscar'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Edit2: TEdit
      Left = 396
      Top = 11
      Width = 269
      Height = 21
      TabOrder = 2
      OnChange = Edit2Change
    end
  end
  object Conn: TSQLConnection
    ConnectionName = 'MySQLConnection'
    DriverName = 'MySQL'
    LoginPrompt = False
    Params.Strings = (
      'DriverUnit=Data.DBXMySQL'
      
        'DriverPackageLoader=TDBXDynalinkDriverLoader,DbxCommonDriver250.' +
        'bpl'
      
        'DriverAssemblyLoader=Borland.Data.TDBXDynalinkDriverLoader,Borla' +
        'nd.Data.DbxCommonDriver,Version=24.0.0.0,Culture=neutral,PublicK' +
        'eyToken=91d62ebb5b0d1b1b'
      
        'MetaDataPackageLoader=TDBXMySqlMetaDataCommandFactory,DbxMySQLDr' +
        'iver250.bpl'
      
        'MetaDataAssemblyLoader=Borland.Data.TDBXMySqlMetaDataCommandFact' +
        'ory,Borland.Data.DbxMySQLDriver,Version=24.0.0.0,Culture=neutral' +
        ',PublicKeyToken=91d62ebb5b0d1b1b'
      'GetDriverFunc=getSQLDriverMYSQL'
      'LibraryName=dbxmys.dll'
      'LibraryNameOsx=libsqlmys.dylib'
      'VendorLib=D:\HTTP\MySQL\libmysql.dll'
      'VendorLibWin64=D:\HTTP\MySQL\libmysql.dll'
      'VendorLibOsx=libmysqlclient.dylib'
      'MaxBlobSize=-1'
      'DriverName=MySQL'
      'HostName=localhost'
      'Database=pedidos'
      'User_Name=root'
      'Password=203540'
      'ServerCharSet='
      'BlobSize=-1'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'Compressed=False'
      'Encrypted=False'
      'ConnectTimeout=60'
      
        'ConnectionString=DriverUnit=Data.DBXMySQL,DriverPackageLoader=TD' +
        'BXDynalinkDriverLoader,DbxCommonDriver250.bpl,DriverAssemblyLoad' +
        'er=Borland.Data.TDBXDynalinkDriverLoader,Borland.Data.DbxCommonD' +
        'river,Version=24.0.0.0,Culture=neutral,PublicKeyToken=91d62ebb5b' +
        '0d1b1b,MetaDataPackageLoader=TDBXMySqlMetaDataCommandFactory,Dbx' +
        'MySQLDriver250.bpl,MetaDataAssemblyLoader=Borland.Data.TDBXMySql' +
        'MetaDataCommandFactory,Borland.Data.DbxMySQLDriver,Version=24.0.' +
        '0.0,Culture=neutral,PublicKeyToken=91d62ebb5b0d1b1b,GetDriverFun' +
        'c=getSQLDriverMYSQL,LibraryName=dbxmys.dll,LibraryNameOsx=libsql' +
        'mys.dylib,VendorLib=C:\Users\Wellington\Desktop\Avaliza'#231#227'o\Win32' +
        '\Debug\libmysql.dll,VendorLibWin64=libmysql.dll,VendorLibOsx=lib' +
        'mysqlclient.dylib,MaxBlobSize=-1,DriverName=MySQL,HostName=local' +
        'host,Database=pedidos,User_Name=root,Password=203540,ServerCharS' +
        'et=,BlobSize=-1,ErrorResourceFile=,LocaleCode=0000,Compressed=Fa' +
        'lse,Encrypted=False,ConnectTimeout=60,ConnectionString=DriverUni' +
        't=Data.DBXMySQL,DriverPackageLoader=TDBXDynalinkDriverLoader,Dbx' +
        'CommonDriver250.bpl,DriverAssemblyLoader=Borland.Data.TDBXDynali' +
        'nkDriverLoader,Borland.Data.DbxCommonDriver,Version=24.0.0.0,Cul' +
        'ture=neutral,PublicKeyToken=91d62ebb5b0d1b1b,MetaDataPackageLoad' +
        'er=TDBXMySqlMetaDataCommandFactory,DbxMySQLDriver250.bpl,MetaDat' +
        'aAssemblyLoader=Borland.Data.TDBXMySqlMetaDataCommandFactory,Bor' +
        'land.Data.DbxMySQLDriver,Version=24.0.0.0,Culture=neutral,Public' +
        'KeyToken=91d62ebb5b0d1b1b,GetDriverFunc=getSQLDriverMYSQL,Librar' +
        'yName=dbxmys.dll,LibraryNameOsx=libsqlmys.dylib,VendorLib=LIBMYS' +
        'QL.dll,VendorLibWin64=libmysql.dll,VendorLibOsx=libmysqlclient.d' +
        'ylib,MaxBlobSize=-1,DriverName=MySQL,HostName=ServerName,Databas' +
        'e=DBNAME,User_Name=user,Password=password,ServerCharSet=,BlobSiz' +
        'e=-1,ErrorResourceFile=,LocaleCode=0000,Compressed=False,Encrypt' +
        'ed=False,ConnectTimeout=60')
    Connected = True
    Left = 64
    Top = 360
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 224
    Top = 353
  end
  object QueryTemp: TSQLQuery
    DataSource = DataSource1
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'select * from temp')
    SQLConnection = Conn
    Left = 160
    Top = 360
  end
  object DataSetProvider1: TDataSetProvider
    DataSet = QueryTemp
    Left = 536
    Top = 288
  end
  object ClientDataSet1: TClientDataSet
    Active = True
    Aggregates = <>
    Params = <>
    ProviderName = 'DataSetProvider1'
    Left = 304
    Top = 360
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 624
    Top = 17
  end
end
