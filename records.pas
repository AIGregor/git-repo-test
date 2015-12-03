unit records;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls, Data.DB,  Data.Win.ADODB, Vcl.Grids, Vcl.DBGrids, Winapi.ShellAPI;

type
  TfrmRecords = class(TForm)
    pnlSource: TPanel;
    Main: TPanel;
    mmRecordContent: TMemo;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    mmCreate: TMenuItem;
    mmSave: TMenuItem;
    mmExit: TMenuItem;
    N2: TMenuItem;
    immPNL_Tasks: TMenuItem;
    immPNL_Source: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    lblTaskName: TLabel;
    mmEnd: TMemo;
    dsAll_records_task: TDataSource;
    tSave: TTimer;
    N3: TMenuItem;
    N4: TMenuItem;
    Splitter1: TSplitter;
    dsAll_resource_of_task: TDataSource;
    adoqAll_records_task: TADOQuery;
    dbgAll_Resource: TDBGrid;
    pnlAllRecords: TPanel;
    dbgAll_Records: TDBGrid;
    sbSQLStatus: TStatusBar;
    Splitter2: TSplitter;
    procedure FormShow(Sender: TObject);
    procedure immPNL_TasksClick(Sender: TObject);
    procedure immPNL_SourceClick(Sender: TObject);
    procedure mmCreateClick(Sender: TObject);
    procedure tSaveTimer(Sender: TObject);
    procedure CreateNewRecord;
    procedure SaveRecord;
    procedure RefreshResourceTable;
    procedure mmSaveClick(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure dbgAll_ResourceDblClick(Sender: TObject);
    procedure dbgAll_RecordsDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mmExitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRecords: TfrmRecords;
  currentIndexOfRecord : integer; // текущая запись для сохрания

implementation

{$R *.dfm}
uses glbVar, clTasks, clRecords, sourcelist;

procedure TfrmRecords.dbgAll_RecordsDblClick(Sender: TObject);
var
  strContent : string; // Основная запись
  strEnd : string;     // Заключение
  queryString : string;
  i, buttonSelected : integer;
begin
  // сохранить перед переходом на др. запись
//  SaveRecord;
//  // обновление данных в внутренном массиве
//  adoqAll_records_task.SQL.Clear;
//  queryString := 'SELECT * FROM ci53070_unionpro.Records where ' +
//      'Tasks_idTasks =' + selected_task.ToString + ';';
//
//  adoqAll_records_task.SQL.Add(queryString);
//    try
//      adoqAll_records_task.Active := true;
//    except
//      on e: EADOError do
//      begin
//        MessageDlg('Не удалось загрузить все записи для выбранного проекта. ' + e.Message, mtError,[mbOK], 0);
//        Exit;
//      end;
//    end;
//
//  for I := 0 to adoqAll_records_task.RecordCount-1 do
//    begin
//      all_records[i].id_records := adoqAll_records_task.FieldByName('idRecords').AsInteger;
//      all_records[i].id_tasks   := adoqAll_records_task.FieldByName('Tasks_idTasks').AsInteger;
//      all_records[i].id_project := adoqAll_records_task.FieldByName('Tasks_Projects_idProjects').AsInteger;
//      all_records[i].id_user    := adoqAll_records_task.FieldByName('Tasks_Users_idUsers').AsInteger;
//      all_records[i].Content    := adoqAll_records_task.FieldByName('content').AsString;
//      all_records[i].Conclusion := adoqAll_records_task.FieldByName('conclusion').AsString;
//      all_records[i].creationDate := adoqAll_records_task.FieldByName('creation_date').AsDateTime;
//      adoqAll_records_task.Next;
//    end;
//
//  //dsAll_records_task.DataSet := adoqAll_records_task;
buttonSelected := MessageDlg('Сохранил текущую запись ?', mtInformation, mbYesNo, 0);
      if buttonSelected = mrYes then
        begin
          // Показать содержимое прошлых записей
          mmRecordContent.Text := dsAll_records_task.DataSet.FieldByName('content').AsString;
          mmEnd.Text           := dsAll_records_task.DataSet.FieldByName('conclusion').AsString;
          currentIndexOfRecord := dbgAll_Records.DataSource.DataSet.RecNo - 1;
          exit;
        end;
      if buttonSelected = mrNo then
        begin
          ShowMessage('Сохрани, сам пока не умею.');
          Exit;
        end;

end;

procedure TfrmRecords.dbgAll_ResourceDblClick(Sender: TObject);
var
  FileLink : String;
  pwcFileLink : PWideChar;
begin
// Открытие файла из спискка источников
  FileLink := dsAll_resource_of_task.DataSet.FieldByName('content').AsString;
  pwcFileLink := Addr(FileLink[1]);
  ShellExecute(0, nil, pwcFileLink, nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmRecords.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  adoqAll_records_task.DataSource.DataSet.ClearFields;
//  adoqAll_records_task.Free;
//  if frmRecords.Visible = false then Application.Terminate;
end;

procedure TfrmRecords.FormCreate(Sender: TObject);
begin
// Отображение формы записи как отдельного окна в строке Пуск
   SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
end;

procedure TfrmRecords.FormShow(Sender: TObject);
var
  i : integer;
  queryString : string;
begin

// загрузить все записи связанные с данными проектом.
  if not currentTypeConnection then
    adoqAll_records_task.ConnectionString := sqlConnection_localhost
  else
    adoqAll_records_task.ConnectionString := sqlConnection_remotehost;

  adoqAll_records_task.SQL.Clear;

// Создать новую запись
  Self.CreateNewRecord;
  self.RefreshResourceTable;
end;

procedure TfrmRecords.immPNL_SourceClick(Sender: TObject);
begin
  if immPNL_Source.Checked then
    begin
      pnlSource.Visible := false;
      immPNL_Source.Checked := false;
    end
  else
    begin
      pnlSource.Visible := true;
      immPNL_Source.Checked := true;
    end;
end;

procedure TfrmRecords.immPNL_TasksClick(Sender: TObject);
begin
  if immPNL_Tasks.Checked then
    begin
      pnlAllRecords.Visible := false;
      immPNL_Tasks.Checked := false;
    end
  else
    begin
      pnlAllRecords.Visible := true;
      immPNL_Tasks.Checked := true;
    end;
end;

procedure TfrmRecords.mmCreateClick(Sender: TObject);
begin
  self.CreateNewRecord;
end;


procedure TfrmRecords.mmExitClick(Sender: TObject);
begin
  self.Close;
end;

procedure TfrmRecords.mmSaveClick(Sender: TObject);
begin
  SaveRecord;
end;

//добавление новых источников к записи
procedure TfrmRecords.N4Click(Sender: TObject);
var
  i : integer;
begin
  // показать форму список источников
  frmSourceList.Show;
  // блокировка формы до добавления новых источников
  frmRecords.Enabled := false;
end;

procedure TfrmRecords.CreateNewRecord;
var
//  sqlQuery  : TADOQuery;
 i : integer;
 queryString : string;
  newElement : integer;
begin
  i := 1;
// создание новой записи
    adoqAll_records_task.SQL.Clear;

// INSERT INTO `ci53070_unionpro`.`Records` (`creation_date`, `Tasks_idTasks`, `Tasks_Projects_idProjects`, `Tasks_Users_idUsers`) VALUES ('2015-05-30', '2', '1', '1');

    queryString := 'INSERT INTO ci53070_unionpro.Records (creation_date, Tasks_idTasks,' +
      ' Tasks_Projects_idProjects, Tasks_Users_idUsers) VALUES (' +
      #39 + FormatDateTime('yyyy-mm-dd hh:mm:ss',now) + #39 + ', ' +
      #39 + currentTASK_ID.ToString     + #39 + ', ' +
      #39 + currentPROJECT_ID.ToString  + #39 + ', ' +
      #39 + currentUser_id.ToString     + #39 + ');';

    adoqAll_records_task.SQL.Add(queryString);

    try
      adoqAll_records_task.ExecSQL;
      sbSQLStatus.Panels[0].Text := 'Создана новая запись в журнале - ' + FormatDateTime('c', now);
    except
      on e: EADOError do
      begin
        MessageDlg('Ошибка при создании новой записи в журнале. ' + e.Message, mtError,[mbOK], 0);
        Exit;
      end;
    end;
// обновление данных в внутренном массиве
  adoqAll_records_task.SQL.Clear;
  queryString := 'SELECT * FROM ci53070_unionpro.Records where ' +
      'Tasks_idTasks =' + selected_task.ToString + ';';

  adoqAll_records_task.SQL.Add(queryString);
    try
      adoqAll_records_task.Active := true;
    except
      on e: EADOError do
      begin
        MessageDlg('Не удалось загрузить все записи для выбранного проекта. ' + e.Message, mtError,[mbOK], 0);
        Exit;
      end;
    end;
// Очистка списка записей
  setlength(all_records,0);
  SetLength(all_records, adoqAll_records_task.RecordCount);

  i := Length(all_records) - 1;
  newElement := Length(all_records) - 1;

  for I := 0 to adoqAll_records_task.RecordCount-1 do
    begin
      all_records[i] := clRecords.Records.Create;
      all_records[i].id_records := adoqAll_records_task.FieldByName('idRecords').AsInteger;
      all_records[i].id_tasks   := adoqAll_records_task.FieldByName('Tasks_idTasks').AsInteger;
      all_records[i].id_project := adoqAll_records_task.FieldByName('Tasks_Projects_idProjects').AsInteger;
      all_records[i].id_user    := adoqAll_records_task.FieldByName('Tasks_Users_idUsers').AsInteger;
      all_records[i].Content    := adoqAll_records_task.FieldByName('content').AsString;
      all_records[i].Conclusion := adoqAll_records_task.FieldByName('conclusion').AsString;
      all_records[i].creationDate := adoqAll_records_task.FieldByName('creation_date').AsDateTime;
      adoqAll_records_task.Next;
    end;

  mmRecordContent.Text := '';
  mmEnd.Text := '';

  dsAll_records_task.DataSet := adoqAll_records_task;

//  for I := 0 to dbgAll_Records.Columns.Count-1 do
//    begin
//      dbgAll_Records.Columns.Items[i].Width := 50;
//    end;
// Запуск таймера сохранения
  tSave.Enabled := true;

  for I := 0 to Length(all_ProjectTasts)-1 do
    begin
      if all_ProjectTasts[i].id_tasks = selected_task then
        begin
          lblTaskName.Caption := all_ProjectTasts[i].name;
        end;
    end;

  currentRECORD_ID := all_records[newElement].id_records;
  currentIndexOfRecord := newElement;
  mmRecordContent.Text := '';
  mmEnd.Text := '';
//  adoqAll_records_task.Close;
end;


procedure TfrmRecords.SaveRecord;
var
  sqlQuery  : TADOQuery;
  i : integer;
  queryString : string;
begin
    // сохранение данных по таймеру
    i :=1;
// сохранение изменений в журнале
    sqlQuery := TADOQuery.Create(self);

  if not currentTypeConnection then
    sqlQuery.ConnectionString := sqlConnection_localhost
  else
    sqlQuery.ConnectionString := sqlConnection_remotehost;

    sqlQuery.SQL.Clear;

    i := currentIndexOfRecord; // сохранить текущую выбранную запись
    all_records[i].Content := mmRecordContent.Text;
    all_records[i].Conclusion := mmEnd.Text;

// UPDATE `ci53070_unionpro`.`Records` SET `content`='545', `conclusion`='cbvnc454tf' WHERE idRecords ='1';

    queryString := 'UPDATE ci53070_unionpro.Records SET ' +
      'content='    + #39 + all_records[i].Content + #39 + ', ' +
      'conclusion=' + #39 + all_records[i].Conclusion + #39 + ' where ' +
      'idRecords='  + #39 + all_records[i].id_records.ToString  + #39 + ';';

    sqlQuery.SQL.Add(queryString);

    try
      sqlQuery.ExecSQL;
      sbSQLStatus.Panels[0].Text := 'Запись сохранена - ' + FormatDateTime('c', now);
    except
      on e: EADOError do
      begin
        MessageDlg('Не удалось сохранить запись. Ошибка: ' + e.Message, mtError,[mbOK], 0);
        Exit;
      end;
    end;

  sqlQuery.Free;
end;

procedure TfrmRecords.tSaveTimer(Sender: TObject);
begin
  SaveRecord;
end;

// Обновление списка русурсов для текущего проекта
procedure TfrmRecords.RefreshResourceTable;
var
  sqlQuery  : TADOQuery;
  queryString : string;
begin
  sqlQuery := TADOQuery.Create(self);

  if not currentTypeConnection then
    sqlQuery.ConnectionString := sqlConnection_localhost
  else
    sqlQuery.ConnectionString := sqlConnection_remotehost;

  sqlQuery.SQL.Clear;

  queryString := 'SELECT source_name, content FROM ' +
	  'ci53070_unionpro.Source, ci53070_unionpro.Resources where ' +
    'ci53070_unionpro.Source.idSource = ci53070_unionpro.Resources.Source_idSource;';

  sqlQuery.SQL.Add(queryString);
    try
      sqlQuery.Active := True;
    except
      on e: EADOError do
      begin
        MessageDlg('Ошибка обновлении списка источников. ' + e.Message, mtError,[mbOK], 0);
        Exit;
      end;
    end;
  // загрузка на форму
  dsAll_resource_of_task.DataSet := sqlQuery;
  // Настройка таблицы Источников -
  dbgAll_Resource.Columns[0].Title.Caption := 'Название';
  dbgAll_Resource.Columns[1].Title.Caption := 'Путь';

  dbgAll_Resource.Columns[0].Width := 400;
  dbgAll_Resource.Columns[1].Width := 350;

  // Таблица - Записи
  dbgAll_Records.Columns[0].Title.Caption := 'ID';
  dbgAll_Records.Columns[1].Title.Caption := 'Дата создания';
  dbgAll_Records.Columns[3].Title.Caption := 'Заключение';
  dbgAll_Records.Columns[2].Visible := false;
  dbgAll_Records.Columns[4].Visible := false;
  dbgAll_Records.Columns[5].Visible := false;
  dbgAll_Records.Columns[6].Visible := false;

  dbgAll_Records.Columns[0].Width := 50;
  dbgAll_Records.Columns[1].Width := 150;
  dbgAll_Records.Columns[3].Width := 300;
end;

end.
