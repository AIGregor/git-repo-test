unit settings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Inifiles, Vcl.ExtCtrls;

type
  TfrmSettings = class(TForm)
    Label4: TLabel;
    edRoot: TEdit;
    btnOpen: TButton;
    chbDeleteAfterCopy: TCheckBox;
    btnCancel: TButton;
    btnSave: TButton;
    OpnDialogFile: TOpenDialog;
    Type_connection: TRadioGroup;
    procedure btnOpenClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSettings: TfrmSettings;


implementation
{$R *.dfm}
uses glbVar;

procedure TfrmSettings.btnCancelClick(Sender: TObject);
begin
  frmSettings.Close;
end;

procedure TfrmSettings.btnOpenClick(Sender: TObject);
begin
  OpnDialogFile.Options := [ofFileMustExist];
  if OpnDialogFile.Execute then
    edRoot.Text := OpnDialogFile.FileName;
end;

procedure TfrmSettings.btnSaveClick(Sender: TObject);
var
  ini : TIniFile;
  pathIni : String;
  typeConnection : Boolean;
begin
   // Create INI Object and open or create file test.ini
  pathIni := GetCurrentDir + '\Settigns.ini';
  ini := TIniFile.Create(GetCurrentDir + '\Settigns.ini');

  try
   // Write a string value to the INI file.
  ini.WriteString('Common', 'rootDir', edRoot.Text);
   // Write a boolean value to the INI file.
  ini.WriteBool('Common', 'delAfterCopy', chbDeleteAfterCopy.Checked);

  if Type_connection.ItemIndex = 0 then
    typeConnection := false // локальная сервер
  else
    typeConnection := true;// удаленный сервер

  ini.WriteBool('Connection', 'typeConnection', typeConnection);
  finally
   ini.Free;
  end;

  self.Close;

end;

procedure TfrmSettings.FormShow(Sender: TObject);
begin
  edRoot.Text := rootDir;
  chbDeleteAfterCopy.Checked := blDeleteFileAfterCopy;
end;

end.
