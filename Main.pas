unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, IniFiles;

type
  TMainForm = class(TForm)
    bbtProjects: TBitBtn;
    bbtSource: TBitBtn;
    bbtExit: TBitBtn;
    procedure bbtExitClick(Sender: TObject);
    procedure bbtProjectsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bbtSourceClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}
uses projects, login, sourcelist, glbVar;

procedure TMainForm.bbtExitClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TMainForm.bbtProjectsClick(Sender: TObject);
begin
  frmProjects.Show;
end;

procedure TMainForm.bbtSourceClick(Sender: TObject);
begin
  frmSourceList.Show;
  frmSourceList.btnInclude.Enabled := false;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  ini: TIniFile;
  pathIni : string;
begin
// Загрузать все настройки при создании

  pathIni := GetCurrentDir + '\Settigns.ini';
  ini := TIniFile.Create(pathIni);

  rootDir := ini.ReadString('Common', 'rootDir', 'E:');
  blDeleteFileAfterCopy := ini.ReadBool('Common', 'delAfterCopy', False);
  currentTypeConnection := ini.ReadBool('Connection', 'typeConnection', false);  // по умолчанию локальный хост

end;

procedure TMainForm.FormShow(Sender: TObject);
begin
// Определение положения формы на экране
  MainForm.Top := 0;
  MainForm.left := Screen.Width - MainForm.Width;
  frmLogin.Show;
end;

end.
