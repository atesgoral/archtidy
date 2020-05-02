unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, ExtCtrls, ComCtrls, JPEG;

const
  VKC_NUMPLUS = 107;
  VKC_NUMMINUS = 109;
  VKC_NUMASTERISK = 106;

type
//  ECannotDisp = class(Exception);
  TFormMain = class(TForm)
    PanelMain: TPanel;
    PanelTop: TPanel;
    StatusBarMain: TStatusBar;
    ButtonRename: TButton;
    PanelLeft: TPanel;
    PanelDriveList: TPanel;
    DriveComboBoxMain: TDriveComboBox;
    DirectoryListBoxMain: TDirectoryListBox;
    PanelFileList: TPanel;
    FileListBoxMain: TFileListBox;
    PanelFileCnt: TPanel;
    LabelFileCnt: TLabel;
    BevelFileCnt: TBevel;
    PanelInfo: TPanel;
    ScrollBoxImage: TScrollBox;
    ImageMain: TImage;
    PanelInfoTop: TPanel;
    LabelSize: TLabel;
    BevelSize: TBevel;
    LabelDim: TLabel;
    BevelDim: TBevel;
    CheckBoxStretch: TCheckBox;
    PanelFilter: TPanel;
    FilterComboBoxMain: TFilterComboBox;
    procedure FileListBoxMainClick(Sender: TObject);
    procedure CheckBoxStretchClick(Sender: TObject);
    procedure ImageMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageMainMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageMainMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure ButtonRenameClick(Sender: TObject);
    procedure DirectoryListBoxMainChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure CheckFileAvail;
    procedure TryShowInfo(FileName: String);
    procedure FitImage;
    procedure ClearInfo;
  public
  protected
    procedure EvtMessage(var Msg: TMsg; var Handled: Boolean);
  end;

var
  FormMain: TFormMain;
  MDown: Boolean = False;
  DownX, DownY, DownHPos, DownVPos: Integer;

implementation

{$R *.DFM}

uses
  Utils, RenameForm;

function SizeToStr(Size: Longint): String;
var
  R: Real;

begin
  if (Size < 1000) then
    Result := IntToStr(Size)
  else
    begin
      R := Size / 1024;
      if (R < 1000) then
        Result := Format('%.3gKB', [R])
      else
        begin
          R := R / 1024;
          Result := Format('%.3gMB', [R])
        end;
    end;
end;

procedure TFormMain.FitImage;
var
  ImgWidth, ImgHeight, ClWidth, ClHeight: Integer;
  ImgRatio, ClRatio: Real;

begin
  ImgWidth := ImageMain.Picture.Width;
  ClWidth := ScrollBoxImage.ClientWidth;
  if (ImgWidth = 0) or (ClWidth = 0) then
    Exit;
  ImgHeight := ImageMain.Picture.Height;
  ClHeight := ScrollBoxImage.ClientHeight;
  ImgRatio := ImgHeight / ImgWidth;
  ClRatio := ClHeight / ClWidth;
  if (ImgRatio >= ClRatio) then
    begin
      ImageMain.Width := Trunc(ClHeight / ImgRatio);
      ImageMain.Height := ClHeight;
    end
  else
    begin
      ImageMain.Width := ClWidth;
      ImageMain.Height := Trunc(ClWidth * ImgRatio);
    end;
end;

procedure TFormMain.TryShowInfo(FileName: String);
var
  F: File of byte;

begin
  try
    AssignFile(F, FileName);
    Reset(F);
    LabelSize.Caption := SizeToStr(FileSize(F));
    CloseFile(F);
    ImageMain.Picture.LoadFromFile(FileName);
    LabelDim.Caption := Format('%d x %d', [ImageMain.Picture.Width, ImageMain.Picture.Height]);
    if CheckBoxStretch.Checked then
      FitImage;
    ImageMain.Visible := True;
  except
    ClearInfo;
  end;
end;

procedure TFormMain.ClearInfo;
begin
  LabelFileCnt.Caption := '';
  LabelSize.Caption := '';
  LabelDim.Caption := '';
  ImageMain.Visible := False;
end;

procedure TFormMain.FileListBoxMainClick(Sender: TObject);
begin
  if (FileListBoxMain.SelCount <> 0) then
    TryShowInfo(FileListBoxMain.FileName);
end;

procedure TFormMain.CheckBoxStretchClick(Sender: TObject);
var
  NotChecked: Boolean;

begin
  NotChecked := not CheckBoxStretch.Checked;
  ImageMain.Stretch := CheckBoxStretch.Checked;
  ImageMain.AutoSize := NotChecked;
  ScrollBoxImage.HorzScrollBar.Visible := NotChecked;
  ScrollBoxImage.VertScrollBar.Visible := NotChecked;
  if CheckBoxStretch.Checked then
    FitImage;
end;

procedure TFormMain.ImageMainMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
X, Y: Integer);
begin
  MDown := True;
  DownX := X;
  DownY := Y;
  DownHPos := ScrollBoxImage.HorzScrollBar.Position;
  DownVPos := ScrollBoxImage.VertScrollBar.Position;
end;

procedure TFormMain.ImageMainMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
X, Y: Integer);
begin
  MDown := False;
end;

procedure TFormMain.ImageMainMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if MDown then
    begin
      ScrollBoxImage.HorzScrollBar.Position := DownHPos + DownX - X;
      ScrollBoxImage.VertScrollBar.Position := DownVPos + DownY - Y;
    end;
end;

procedure TFormMain.FormResize(Sender: TObject);
begin
  if CheckBoxStretch.Checked then
    FitImage;
end;

procedure TFormMain.ButtonRenameClick(Sender: TObject);
begin
  if (FormRename = nil) then
    FormRename := TFormRename.Create(Self);
  FormRename.AssignList(FileListBoxMain);
  if (FormRename.ShowModal = mrOK) then
    begin
      FileListBoxMain.Update;
      CheckFileAvail;
    end;
end;

procedure TFormMain.CheckFileAvail;
var
  FileAvail: Boolean;

begin
  FileAvail := (FileListBoxMain.Items.Count > 0);
  if FileAvail then
    begin
      FileListBoxMain.ItemIndex := 0;
      TryShowInfo(FileListBoxMain.FileName);
    end
  else
    ClearInfo;
  ButtonRename.Enabled := FileAvail;
  LabelFileCnt.Caption := ItemCount(FileListBoxMain.Items.Count, 'file');
end;

procedure TFormMain.DirectoryListBoxMainChange(Sender: TObject);
begin
  CheckFileAvail;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  Application.OnMessage := EvtMessage;
  CheckFileAvail;
end;

procedure TFormMain.EvtMessage(var Msg: TMsg; var Handled: Boolean);
begin
  if (Msg.message = WM_KEYDOWN) then
    case Msg.wParam of
      VKC_NUMPLUS: Exit;
      VKC_NUMMINUS: Exit;
      VKC_NUMASTERISK: CheckBoxStretch.Checked := not CheckBoxStretch.Checked;
    end;
end;

end.
