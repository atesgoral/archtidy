program ArchTidy;

{%ToDo 'ArchTidy.todo'}

uses
  Forms,
  MainForm in 'MainForm.pas' {FormMain},
  RenameForm in 'RenameForm.pas' {FormRename},
  Utils in 'Utils.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
