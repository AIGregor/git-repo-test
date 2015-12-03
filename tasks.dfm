object frmTasks: TfrmTasks
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = #1047#1072#1076#1072#1095#1080
  ClientHeight = 315
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter2: TSplitter
    Left = 225
    Top = 0
    Height = 315
    ExplicitLeft = 330
    ExplicitHeight = 343
  end
  object plnTreeTasks: TPanel
    Left = 0
    Top = 0
    Width = 225
    Height = 315
    Align = alLeft
    Caption = 'plnTreeTasks'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    ExplicitLeft = 3
    ExplicitTop = -3
  end
  object Panel1: TPanel
    Left = 228
    Top = 0
    Width = 407
    Height = 315
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnResize = Panel1Resize
    object ProjectName: TLabel
      Left = 6
      Top = 9
      Width = 395
      Height = 18
      Align = alCustom
      Alignment = taCenter
      AutoSize = False
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Georgia'
      Font.Style = []
      ParentFont = False
    end
    object lblAimTask: TLabel
      Left = 6
      Top = 70
      Width = 395
      Height = 18
      Align = alCustom
      Alignment = taCenter
      AutoSize = False
      Caption = #1062#1077#1083#1100' '#1079#1072#1076#1072#1095#1080' :'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Georgia'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 6
      Top = 121
      Width = 395
      Height = 18
      Align = alCustom
      Alignment = taCenter
      AutoSize = False
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#1079#1072#1076#1072#1095#1080' :'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Georgia'
      Font.Style = []
      ParentFont = False
    end
    object mmDescriptionTask: TMemo
      Left = 6
      Top = 145
      Width = 395
      Height = 121
      Align = alCustom
      TabOrder = 0
    end
    object edtAimTask: TEdit
      Left = 2
      Top = 94
      Width = 395
      Height = 21
      AutoSize = False
      TabOrder = 1
    end
    object btnShowRecords: TButton
      Left = 128
      Top = 272
      Width = 273
      Height = 33
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1078#1091#1088#1085#1072#1083
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object BackToProject: TButton
      Left = 6
      Top = 272
      Width = 116
      Height = 33
      Caption = #1055#1088#1086#1077#1082#1090#1099
      TabOrder = 3
      OnClick = BackToProjectClick
    end
  end
  object PopupMenuTasks: TPopupMenu
    Left = 72
    Top = 32
    object ppmAddNewTask: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      OnClick = ppmAddNewTaskClick
    end
    object ppmEdtTask: TMenuItem
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
      OnClick = ppmEdtTaskClick
    end
  end
  object ADOConnection1: TADOConnection
    ConnectionString = 
      'Provider=MSDASQL.1;Password=#5#b8Q*ne6wM@kbd*x$v;Persist Securit' +
      'y Info=True;User ID=ci53070_unionpro;Extended Properties="Driver' +
      '=MySQL ODBC 5.2 Unicode Driver;SERVER=85.10.205.173;UID=ci53070_' +
      'unionpro;PWD={#5#b8Q*ne6wM@kbd*x$v};PORT=3306;COLUMN_SIZE_S32=1"' +
      ';Initial Catalog=ci53070_unionpro'
    Provider = 'MSDASQL.1'
    Left = 152
    Top = 80
  end
end
