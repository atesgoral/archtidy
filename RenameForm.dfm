object FormRename: TFormRename
  Left = 282
  Top = 168
  Width = 550
  Height = 400
  Color = clBtnFace
  Font.Charset = TURKISH_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PanelTop: TPanel
    Left = 0
    Top = 0
    Width = 153
    Height = 354
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object LabelBase: TLabel
      Left = 16
      Top = 8
      Width = 65
      Height = 13
      Caption = 'Base Name'
    end
    object EditBase: TEdit
      Left = 16
      Top = 24
      Width = 121
      Height = 21
      Color = 16761024
      TabOrder = 0
      OnKeyPress = EditBaseKeyPress
    end
    object RadioGroupExt: TRadioGroup
      Left = 16
      Top = 144
      Width = 121
      Height = 73
      Caption = 'Extension'
      ItemIndex = 0
      Items.Strings = (
        'To lowercase'
        'To uppercase'
        'Don'#39't change')
      TabOrder = 1
      OnClick = RadioGroupExtClick
    end
    object PanelBottom: TPanel
      Left = 0
      Top = 304
      Width = 153
      Height = 50
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      object ButtonGo: TButton
        Left = 40
        Top = 16
        Width = 75
        Height = 21
        Caption = '&Go'
        Default = True
        TabOrder = 0
        OnClick = ButtonGoClick
      end
    end
    object GroupBoxNum: TGroupBox
      Left = 16
      Top = 56
      Width = 121
      Height = 73
      Caption = 'Numbering'
      TabOrder = 3
      object LabelStart: TLabel
        Left = 64
        Top = 24
        Width = 28
        Height = 13
        Caption = 'Start'
      end
      object LabelDigits: TLabel
        Left = 16
        Top = 24
        Width = 32
        Height = 13
        Caption = 'Digits'
      end
      object ComboBoxDigits: TComboBox
        Left = 16
        Top = 40
        Width = 41
        Height = 21
        Style = csDropDownList
        Color = 16761024
        ItemHeight = 13
        TabOrder = 0
        OnChange = ComboBoxDigitsChange
        Items.Strings = (
          '1'
          '2'
          '3'
          '4'
          '5'
          '6')
      end
      object EditStart: TEdit
        Left = 64
        Top = 40
        Width = 41
        Height = 21
        Color = 16761024
        TabOrder = 1
        Text = '1'
        OnKeyPress = EditStartKeyPress
      end
    end
    object CheckBoxClose: TCheckBox
      Left = 16
      Top = 232
      Width = 121
      Height = 17
      Caption = 'Auto-close'
      TabOrder = 4
    end
  end
  object ListViewMain: TListView
    Left = 153
    Top = 0
    Width = 389
    Height = 354
    Align = alClient
    Color = 16761024
    Columns = <
      item
        Caption = 'Original Name'
        Width = 160
      end
      item
        Caption = 'New Name'
        Width = 160
      end>
    ColumnClick = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
  end
  object StatusBarMain: TStatusBar
    Left = 0
    Top = 354
    Width = 542
    Height = 19
    Panels = <>
    ParentFont = True
    SimplePanel = True
    UseSystemFont = False
  end
  object TimerBuildWait: TTimer
    Enabled = False
    OnTimer = TimerBuildWaitTimer
    Left = 160
    Top = 24
  end
end
