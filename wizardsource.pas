unit wizardsource;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Tabs,
  Vcl.ComCtrls, Data.DB, Data.Win.ADODB, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage;

type
  TfrmWizardSource = class(TForm)
    pnlWizard: TPanel;
    pnlTopInfo: TPanel;
    pnlButtons: TPanel;
    lblWizardName: TLabel;
    lblWizardStatus: TLabel;
    btnCancel: TButton;
    btnNext: TButton;
    btnBack: TButton;
    pcWizardSteps: TPageControl;
    tsSelectType: TTabSheet;
    tsAddSource: TTabSheet;
    lblQuestion: TLabel;
    rbWeb: TRadioButton;
    rbFile: TRadioButton;
    Label1: TLabel;
    Memo1: TMemo;
    mmSourceLink: TMemo;
    Label2: TLabel;
    btnOpen: TButton;
    OpnDialogFile: TOpenDialog;
    mmComment: TMemo;
    lblComment: TLabel;
    mmSourceName: TMemo;
    SourceName: TLabel;
    Image1: TImage;
    procedure btnNextClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure pageSelectType();
    procedure pageAddSource();
    function getFileFormat(fileName : string) : string;
  public
    { Public declarations }
  end;

var
  frmWizardSource: TfrmWizardSource;
  pwcFileLink : PWideChar;
  pwcNewFileName  : PWideChar;
  stFileLink  : string;
implementation

{$R *.dfm}
uses glbVar, clTasks, clProjects, sourcelist;

procedure TfrmWizardSource.btnCancelClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmWizardSource.btnNextClick(Sender: TObject);
begin
// обработка мастера - кнопка ДАЛЕЕ
  if pcWizardSteps.ActivePage = tsSelectType then
    begin
      pageSelectType;
      Exit;
    end;
  if pcWizardSteps.ActivePage = tsAddSource then
    begin
      pageAddSource;
      frmSourceList.Enabled := true;
      self.Close;
      Exit;
    end;
end;

procedure TfrmWizardSource.btnOpenClick(Sender: TObject);
begin
  OpnDialogFile.Options := [ofFileMustExist];
  if OpnDialogFile.Execute then
    stfileLink := OpnDialogFile.FileName;
  mmSourceLink.Text := stfileLink;
end;

procedure TfrmWizardSource.FormCreate(Sender: TObject);
begin
  // Отображение формы записи как отдельного окна в строке Пуск
   SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;

procedure TfrmWizardSource.FormShow(Sender: TObject);
begin
  tsSelectType.TabVisible := false;
  tsAddSource.TabVisible := false;
  tsSelectType.Show;
  lblWizardName.Caption := 'Загрузка нового источника информации';
  lblWizardStatus.Caption := 'Тип источника'
end;

procedure TfrmWizardSource.pageAddSource();
var
 i : integer;
 sqlQuery  : TADOQuery;
 queryString : string;
 distDir : string;
 tempp : project;
 tempt : task;
 currentDir : string;
 newID : integer;
 stNewID : string;
 sourceLink : string;
begin

distDir := '';
stNewID := '';
sourceLink := '';
currentDir := '';

  sqlQuery := TADOQuery.Create(self);

  if not currentTypeConnection then
    sqlQuery.ConnectionString := sqlConnection_localhost
  else
    sqlQuery.ConnectionString := sqlConnection_remotehost;

  sqlQuery.SQL.Clear;

// выбран источник интернет
if rbWeb.Checked then
  begin
    if (mmSourceLink.Text <> '') and (mmComment.Text <> '') then
      begin
      // добавление новой строки в таблицу источников
//INSERT INTO `ci53070_unionpro`.`Source` (`creation_date`, `content`, `author`, `add_source_date`, `comments`) VALUES ('2051-05-06', 'teyty', 'ertye', '2015-06-03', 'etyety');
        sourceLink := mmSourceLink.Text;

    queryString := 'INSERT INTO ci53070_unionpro.Source' +
       ' (creation_date, content, comments, source_name) ' +
       ' VALUES ( ' + #39 + FormatDateTime('yyyy-mm-dd hh:mm:ss',now) + #39 +
       ', ' + #39 + sourceLink + #39 +
       ', ' + #39 + mmComment.Text + #39 +
       ', ' + #39 + mmSourceName.Text + #39 + ');';

        sqlQuery.SQL.Add(queryString);
        try
          sqlQuery.ExecSQL;
        except
          on e: EADOError do
          begin
            MessageDlg('Ошибка при создании нового источника. Выполнение прервано. ' + e.Message, mtError,[mbOK], 0);
            Exit;
          end;
        end;
        // обновить список используемых источников // процедура REfresh в модуле записи
        frmSourceList.RefreshListSource;
      end
    else
      begin
        MessageDlg('Адресс источника или комментарий пуст.', mtError,[mbOK], 0);
      end;
  end;
  // выбран источник файл
if rbFile.Checked then
  begin
  // запуск мастера сохранение пути к файлу.
  // изменение текущего каталога
  ChDir(sourceDisk);
  distDir := sourceDisk + '\' + tempp.getNameProjectByID_project(currentPROJECT_ID);
  // Проверка папки проекта
  if not DirectoryExists(distDir) then MkDir(distDir);
  distDir := distDir + '\' + tempt.getNameProjectByID_project(currentTASK_ID);
  // проверка папки задачи
  if not DirectoryExists(distDir) then MkDir(distDir);
  ChDir(distDir);
  // проверка существования файла
  // ---- дописать
  // Копирование файла в директорию текущего проекта и текущей задачи
  if stfileLink <> '' then
    begin
      // создать новую запись в таблице
    queryString := 'INSERT INTO ci53070_unionpro.Source' +
       ' (creation_date, content, comments, source_name) ' +
       ' VALUES ( ' + #39 + FormatDateTime('yyyy-mm-dd hh:mm:ss',now) + #39 +
       ', ' + #39 + sourceLink + #39 +
       ', ' + #39 + mmComment.Text + #39 +
       ', ' + #39 + mmSourceName.Text + #39 + ');';

      sqlQuery.SQL.Add(queryString);
      try
        sqlQuery.ExecSQL;
      except
        on e: EADOError do
        begin
          MessageDlg('Ошибка во время выполнения запроса добавления записи. Выполнение прервано. ' + E.ToString, mtError,[mbOK], 0);
          Exit;
        end;
      end;
      // получить запись где id источника максимален - последняя запись
      queryString := 'select * from Source where idSource = (select max(idSource) from Source);';
      sqlQuery.SQL.Clear;

      sqlQuery.SQL.Add(queryString);
      try
        sqlQuery.Active := true;
      except
        on e: EADOError do
        begin
          MessageDlg('Ошибка при добавления источника-файла. Выполнение прервано. ' + e.Message, mtError,[mbOK], 0);
          Exit;
        end;
      end;
      // получение номура id
      newID :=  sqlQuery.FieldByName('idSource').AsInteger;
      stNewID := newID.ToString() + getFileFormat(stFileLink);
      // переименовать файл и копировать в соответствующую директорию
      pwcFileLink := Addr(stFileLink[1]);
      pwcNewFileName := Addr(stNewID[1]);
      if CopyFile(pwcFileLink, pwcNewFileName, true) then
        MessageDlg('Файл успешно скопирован.', mtInformation,[mbOK], 0)
      else
        begin
          MessageDlg('Ошибка при копировании файла. Выполнение прервано.', mtError,[mbOK], 0);
          exit;
        end;
    end
  else
    begin
      MessageDlg('Адресс источника пуст.', mtError,[mbOK], 0);
	    Exit;
    end;

    distDir := distDir + '\' + stNewID;
  // записать путь к файлу в бд
      distDir := StringReplace(distDir,'\', '\\',[rfReplaceAll, rfIgnoreCase]);
      queryString := 'UPDATE ci53070_unionpro.Source SET ' +
      'content='  + #39 + distDir + #39 +
      ', source_name='  + #39 + mmSourceName.Text + #39 + ' where ' +
      'idSource=' + #39 + newID.ToString + #39 + ';';

      sqlQuery.SQL.Clear;

      sqlQuery.SQL.Add(queryString);
      try
        sqlQuery.ExecSQL;
      except
        on e: EADOError do
        begin
          MessageDlg('Ошибка во время выполнения запроса добавления записи. Выполнение прервано. ' + E.ToString, mtError,[mbOK], 0);
          Exit;
        end;
      end;
  // обновить список используемых источников // процедура REfresh в модуле записи
     frmSourceList.RefreshListSource;
  end;
end;

function TfrmWizardSource.getFileFormat(fileName : string) : string;
var
  findPoint : string;
  pointPosition : integer;
  lengthName : integer;
begin
  findPoint := '.';
  lengthName := Length(fileName);

  pointPosition := Pos(findPoint, fileName);

  result := Copy(fileName,pointPosition, lengthName - pointPosition + 1);
end;

procedure TfrmWizardSource.pageSelectType();
begin
    // выбран источник интернет
  if rbWeb.Checked then
    begin
      tsAddSource.Show;
      btnOpen.Visible := false;
      // выход после выполнения
      Exit;
    end;
  // выбран источник файл
  if rbFile.Checked then
    begin
      tsAddSource.Show;
      btnOpen.Visible := true;
      // выход после выполнения
      Exit;
    end;
  // Ничего не выбрано
  MessageDlg('Не указан тип источника !!!', mtError,[mbOK], 0);
end;

end.
