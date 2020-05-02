object FormMain: TFormMain
  Left = 211
  Top = 113
  Width = 640
  Height = 400
  Caption = 'ArchTidy'
  Color = clBtnFace
  Font.Charset = TURKISH_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object PanelMain: TPanel
    Left = 0
    Top = 49
    Width = 632
    Height = 305
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object PanelLeft: TPanel
      Left = 0
      Top = 0
      Width = 145
      Height = 305
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object PanelDriveList: TPanel
        Left = 0
        Top = 0
        Width = 145
        Height = 33
        Align = alTop
        TabOrder = 0
        object DriveComboBoxMain: TDriveComboBox
          Left = 8
          Top = 8
          Width = 129
          Height = 19
          Color = 16761024
          DirList = DirectoryListBoxMain
          TabOrder = 0
          TextCase = tcUpperCase
        end
      end
      object DirectoryListBoxMain: TDirectoryListBox
        Left = 0
        Top = 33
        Width = 145
        Height = 272
        Align = alClient
        Color = 16761024
        FileList = FileListBoxMain
        ItemHeight = 16
        TabOrder = 1
        OnChange = DirectoryListBoxMainChange
      end
    end
    object PanelFileList: TPanel
      Left = 145
      Top = 0
      Width = 144
      Height = 305
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      object FileListBoxMain: TFileListBox
        Left = 0
        Top = 33
        Width = 144
        Height = 251
        Align = alClient
        Color = 16761024
        ItemHeight = 13
        TabOrder = 0
        OnClick = FileListBoxMainClick
      end
      object PanelFileCnt: TPanel
        Left = 0
        Top = 0
        Width = 144
        Height = 33
        Align = alTop
        TabOrder = 1
        object BevelFileCnt: TBevel
          Left = 8
          Top = 8
          Width = 129
          Height = 17
        end
        object LabelFileCnt: TLabel
          Left = 16
          Top = 10
          Width = 4
          Height = 13
        end
      end
      object PanelFilter: TPanel
        Left = 0
        Top = 284
        Width = 144
        Height = 21
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        object FilterComboBoxMain: TFilterComboBox
          Left = 0
          Top = 0
          Width = 145
          Height = 21
          Color = 16761024
          FileList = FileListBoxMain
          Filter = 'All files (*.*)|*.*|Image files (JPEG, BMP)|*.jpg;*.jpeg;*.bmp'
          TabOrder = 0
        end
      end
    end
    object PanelInfo: TPanel
      Left = 289
      Top = 0
      Width = 343
      Height = 305
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      object ScrollBoxImage: TScrollBox
        Left = 0
        Top = 33
        Width = 343
        Height = 272
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alClient
        Color = clBlack
        ParentColor = False
        TabOrder = 0
        object ImageMain: TImage
          Left = 0
          Top = 0
          Width = 105
          Height = 105
          AutoSize = True
          IncrementalDisplay = True
          ParentShowHint = False
          ShowHint = False
          OnMouseDown = ImageMainMouseDown
          OnMouseMove = ImageMainMouseMove
          OnMouseUp = ImageMainMouseUp
        end
      end
      object PanelInfoTop: TPanel
        Left = 0
        Top = 0
        Width = 343
        Height = 33
        Align = alTop
        TabOrder = 1
        object LabelSize: TLabel
          Left = 16
          Top = 10
          Width = 4
          Height = 13
        end
        object BevelSize: TBevel
          Left = 8
          Top = 8
          Width = 57
          Height = 17
        end
        object LabelDim: TLabel
          Left = 80
          Top = 10
          Width = 4
          Height = 13
        end
        object BevelDim: TBevel
          Left = 72
          Top = 8
          Width = 89
          Height = 17
        end
        object CheckBoxStretch: TCheckBox
          Left = 174
          Top = 8
          Width = 97
          Height = 17
          Caption = 'Stretch to fit'
          TabOrder = 0
          OnClick = CheckBoxStretchClick
        end
      end
    end
  end
  object PanelTop: TPanel
    Left = 0
    Top = 0
    Width = 632
    Height = 49
    Align = alTop
    TabOrder = 1
    object ButtonRename: TButton
      Left = 16
      Top = 16
      Width = 75
      Height = 21
      Caption = '&Rename...'
      TabOrder = 0
      OnClick = ButtonRenameClick
    end
  end
  object StatusBarMain: TStatusBar
    Left = 0
    Top = 354
    Width = 632
    Height = 19
    Panels = <>
    ParentFont = True
    SimplePanel = True
    UseSystemFont = False
  end
end
