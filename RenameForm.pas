unit RenameForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, FileCtrl;

const
  DEFAULTBASE = 'File_';

type
  TFormRename = class(TForm)
    PanelTop: TPanel;
    ListViewMain: TListView;
    StatusBarMain: TStatusBar;
    EditBase: TEdit;
    LabelBase: TLabel;
    RadioGroupExt: TRadioGroup;
    PanelBottom: TPanel;
    ButtonGo: TButton;
    GroupBoxNum: TGroupBox;
    ComboBoxDigits: TComboBox;
    EditStart: TEdit;
    LabelStart: TLabel;
    LabelDigits: TLabel;
    TimerBuildWait: TTimer;
    CheckBoxClose: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonGoClick(Sender: TObject);
    procedure EditStartKeyPress(Sender: TObject; var Key: Char);
    procedure ComboBoxDigitsChange(Sender: TObject);
    procedure RadioGroupExtClick(Sender: TObject);
    procedure EditBaseKeyPress(Sender: TObject; var Key: Char);
    procedure TimerBuildWaitTimer(Sender: TObject);
  private
    Path: String;
    Start: Integer;
    FormatStr: String;
    ListChanged: Boolean;
    Renamed: Boolean;
    procedure Status(S: String);
    procedure SuggestBase;
    procedure GetFormat;
    function NewName(FileName: String; Cnt: Integer): String;
    procedure BuildList;
    procedure RenameAll;
    procedure ResetBuildWait;
  public
    procedure AssignList(FileListBox: TFileListBox);
  end;

var
  FormRename: TFormRename;

implementation

{$R *.DFM}

uses
  Utils;

function HTTPSafe(S: String): String;
var
  Len, Index: Integer;
  C: Char;

begin
  Len := Length(S);
  Index := 1;
  Result := '';
  while (Index <= Len) do
    begin
      C := S[Index];
      case C of
        '0'..'9', 'A'..'Z', 'a'..'z', '-', '_': Result := Result + C;
        ' ': Result := Result + '_';
      end;
      inc(Index);
    end;
end;

procedure TFormRename.SuggestBase;
var
  Len, Index: Integer;
  Base: String;

begin
  Len := Length(Path);
  Index := Len;
  while (Index > 1) and (Path[Index - 1] <> '\') do
    dec(Index);
  Base := HTTPSafe(Copy(Path, Index, Len - Index));
  if (Length(Base) > 0) then
    EditBase.Text := Base + '_'
  else
    EditBase.Text := DEFAULTBASE;
end;

function TFormRename.NewName(FileName: String; Cnt: Integer): String;
var
  Len, Index: Integer;
  Ext: String;

begin
  Len := Length(FileName);
  Index := Len;
  while (Index > 0) and (FileName[Index] <> '.') do
    dec(Index);
  if (Index > 0) then
    begin
      Ext := Copy(FileName, Index, Len - Index + 1);
      case RadioGroupExt.ItemIndex of
        0: Ext := Lowercase(Ext);
        1: Ext := Uppercase(Ext);
      end;
    end
  else
    Ext := '';
  Result := Format(FormatStr, [Start + Cnt, Ext]);
end;

procedure TFormRename.Status(S: String);
begin
  StatusBarMain.SimpleText := S;
end;

procedure TFormRename.GetFormat;
var
  Code: Integer;

begin
  Val(EditStart.Text, Start, Code);
  if (Code <> 0) then
    Start := 0;
  FormatStr := Format('%s%%.%sd%%s', [EditBase.Text, ComboBoxDigits.Text]);
end;

procedure TFormRename.AssignList(FileListBox: TFileListBox);
var
  Cnt: Integer;
  ListItem: TListItem;

begin
  ListViewMain.Items.Clear;
  ButtonGo.Enabled := True;
  Path := FileListBox.Directory;
  if (Path[Length(Path)] <> '\') then
    Path := Path + '\';
  SuggestBase;
  Caption := 'Rename - ' + Path;
  GetFormat;
  for Cnt := 0 to FileListBox.Items.Count - 1 do
    begin
      ListItem := ListViewMain.Items.Add;
      ListItem.Caption := FileListBox.Items.Strings[Cnt];
      ListItem.SubItems.Add(NewName(ListItem.Caption, Cnt));
    end;
  ListChanged := False;
  Renamed := False;
  Status(ItemCount(FileListBox.Items.Count, 'file'));
end;

procedure TFormRename.FormCreate(Sender: TObject);
begin
  ComboBoxDigits.ItemIndex := 2;
end;

procedure TFormRename.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Renamed then
    ModalResult := mrOK
  else
    Action := caHide;
end;

procedure TFormRename.BuildList;
var
  Cnt: Integer;
  ListItem: TListItem;

begin
  TimerBuildWait.Enabled := False;
  GetFormat;
  for Cnt := 0 to ListViewMain.Items.Count - 1 do
    begin
      ListItem := ListViewMain.Items.Item[Cnt];
      ListItem.SubItems.Strings[0] := NewName(ListItem.Caption, Cnt);
    end;
  ListChanged := False;
end;

procedure TFormRename.RenameAll;
var
  Cnt: Integer;
  ListItem: TListItem;
  Src, Dest: String;
  F: File;
  Confs: Integer;

begin
  ButtonGo.Enabled := False;
  Status('Renaming...');
  Confs := 0;
  for Cnt := 0 to ListViewMain.Items.Count - 1 do
    begin
      ListItem := ListViewMain.Items.Item[Cnt];
      Src := Path + ListItem.Caption;
      if FileExists(Src) then
        begin
          Dest := Path + ListItem.SubItems.Strings[0];
          if FileExists(Dest) then
            begin
              Dest := Dest + '.dup';
              inc(Confs);
            end;
          AssignFile(F, Src);
          Rename(F, Dest);
        end;
    end;
//  if (Confs > 0) then
//    RestoreConfs;
  Renamed := True;
  if CheckBoxClose.Checked then
    Close
  else
    begin
      Status('Rename operation complete with ' + ItemCount(Confs, 'conflict'));
      ButtonGo.Enabled := True;
    end;
end;

procedure TFormRename.ButtonGoClick(Sender: TObject);
begin
  if ListChanged then
    BuildList;
  if (MessageDlg('Rename these files?', mtConfirmation, mbOKCancel, 0) = mrOK) then
    RenameAll;
end;

procedure TFormRename.EditStartKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in [#8, '0'..'9']) then
    Key := #0;
  ResetBuildWait;
end;

procedure TFormRename.ComboBoxDigitsChange(Sender: TObject);
begin
  BuildList;
end;

procedure TFormRename.RadioGroupExtClick(Sender: TObject);
begin
  BuildList;
end;

procedure TFormRename.EditBaseKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key in ['\', '/', ':', '*', '?', '"', '<', '>', '|']) then
    Key := #0;
  ResetBuildWait;
end;

procedure TFormRename.ResetBuildWait;
begin
  TimerBuildWait.Enabled := False;
  TimerBuildWait.Enabled := True;
  ListChanged := True;
end;

procedure TFormRename.TimerBuildWaitTimer(Sender: TObject);
begin
  BuildList;
end;

end.

