unit newtask;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB,  Data.Win.ADODB;

type
  TfrmNewTask = class(TForm)
    cbUserName: TComboBox;
    LbAuthorName: TLabel;
    mmTaskName: TMemo;
    lblTaskName: TLabel;
    Label1: TLabel;
    mmAimTask: TMemo;
    Label2: TLabel;
    mmDescriptionTask: TMemo;
    btnDo: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnDoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure UpDataLBTasks;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNewTask: TfrmNewTask;

implementation

{$R *.dfm}
uses glbVar, clProjects, clTasks, clUsers, tasks, projects;

procedure TfrmNewTask.btnDoClick(Sender: TObject);
var
  sqlQuery : TADOQuery;
  newIndex : integer;
  queryString : string;
begin
  sqlQuery := TADOQuery.Create(self);

  if not currentTypeConnection then
    sqlQuery.ConnectionString := sqlConnection_localhost
  else
    sqlQuery.ConnectionString := sqlConnection_remotehost;

  sqlQuery.SQL.Clear;

  if (mmTaskName.Text = '') then
    begin
      MessageDlg('Bведите название проекта.', mtError,[mbOK], 0);
      Exit;
    end;

  if (cbUserName.Items[cbUserName.ItemIndex] = '') then
    begin
        MessageDlg('Bведите пользователя.', mtError,[mbOK], 0);
        exit;
    end;
  // Cоздание
  if frmNewTask.Tag = 0 then
    begin
      SetLength(all_ProjectTasts, length(all_ProjectTasts)+1);
      newIndex := Length(all_ProjectTasts)-1;
      all_ProjectTasts[newIndex] := task.Create;
      try
        all_ProjectTasts[newIndex].id_user := all_users[cbUserName.ItemIndex].id_user;
        all_ProjectTasts[newIndex].id_project := currentPROJECT_ID;
        all_ProjectTasts[newIndex].name := mmTaskName.Text;
        all_ProjectTasts[newIndex].task_aim := mmAimTask.Text;
        all_ProjectTasts[newIndex].description := mmDescriptionTask.Text;
        all_ProjectTasts[newIndex].creationDate := Now;
      except
        MessageDlg('Ћдин из параметров введен не верно.', mtError,[mbOK], 0);
        Exit;
      end;
     // INSERT INTO `ci53070_unionpro`.`Tasks` (`creation_date`, `task_aim`, `description`, `task_name`, `Projects_idProjects`, `Users_idUsers`) VALUES ('2015-06-05', 'ntrg', 'sdfs', 'sdfs', '2', '1');
     queryString := 'INSERT INTO ci53070_unionpro.Tasks (creation_date, task_aim, description,' +
      'task_name, Projects_idProjects, Users_idUsers) VALUES (' +
      #39 + FormatDateTime('yyyy-mm-dd hh:mm:ss',all_project[Length(all_project)-1].creationDate) + #39 + ', ' +
      #39 + all_ProjectTasts[newIndex].task_aim     + #39 + ', ' +
      #39 + all_ProjectTasts[newIndex].description  + #39 + ', ' +
      #39 + all_ProjectTasts[newIndex].name         + #39 + ', ' +
      #39 + all_ProjectTasts[newIndex].id_project.ToString   + #39 + ', ' +
      #39 + all_ProjectTasts[newIndex].id_user.ToString      + #39 + ');';

      sqlQuery.SQL.Add(queryString);

      try
        sqlQuery.ExecSQL;
      except
        on e: EADOError do
        begin
          MessageDlg('Ћшибка при создании нового проекта. ' + e.Message, mtError,[mbOK], 0);
          Exit;
        end;
      end;
    end;
  // ђедактирование
  if frmNewTask.Tag = 1 then
    begin
      // UPDATE `ci53070_unionpro`.`Tasks` SET `task_aim`='Тестир' WHERE `idTasks`='2' and`Projects_idProjects`='1' and`Users_idUsers`='1';
      newIndex := selected_task;
      try
        // заполнить параметры выбранной задачи
        all_ProjectTasts[newIndex].id_user := all_users[cbUserName.ItemIndex].id_user;
        all_ProjectTasts[newIndex].id_project := selectedProject;
        all_ProjectTasts[newIndex].name := mmTaskName.Text;
        all_ProjectTasts[newIndex].task_aim := mmAimTask.Text;
        all_ProjectTasts[newIndex].description := mmDescriptionTask.Text;
        all_ProjectTasts[newIndex].creationDate := now;
      except on e: EADOError do
        begin
          MessageDlg('Ћдин из параметров введен не верно. ' + e.Message, mtError,[mbOK], 0);
          Exit;
        end;
      end;

      queryString := 'UPDATE `ci53070_unionpro`.`Tasks` SET ' +
      'creation_date='       + #39 + FormatDateTime('yyyy-mm-dd hh:mm:ss',all_project[Length(all_project)-1].creationDate) + #39 + ', ' +
      'task_aim='            + #39 + all_ProjectTasts[newIndex].task_aim     + #39 + ', ' +
      'description='         + #39 + all_ProjectTasts[newIndex].description  + #39 + ', ' +
      'task_name='           + #39 + all_ProjectTasts[newIndex].name         + #39 + ' where ' +
      'Projects_idProjects=' + #39 + all_ProjectTasts[newIndex].id_project.ToString   + #39 + ' and ' +
      'Users_idUsers='       + #39 + all_ProjectTasts[newIndex].id_user.ToString      + #39 + ';';

      sqlQuery.SQL.Add(queryString);

      try
        sqlQuery.ExecSQL;
      except
        on e: EADOError do
        begin
          MessageDlg('Ћшибка при сохранении изменений в выбранной задаче. ' + e.Message, mtError,[mbOK], 0);
          Exit;
        end;
      end;
    end;

  UpDataLBTasks;

  sqlQuery.Destroy;

  frmProjects.WindowState := wsNormal;
  frmProjects.Show;
  frmNewTask.Close;

end;

procedure TfrmNewTask.UpDataLBTasks;
var
  i : integer;
  sqlQuery  : TADOQuery;
  prId_user : TParameter;
  prProjectName : TParameter;
  prDescription : TParameter;
  prDate : TParameter;
  queryString : string;
begin
    sqlQuery := TADOQuery.Create(self);

    if not currentTypeConnection then
      sqlQuery.ConnectionString := sqlConnection_localhost
    else
      sqlQuery.ConnectionString := sqlConnection_remotehost;

    sqlQuery.SQL.Clear;
  // получаем все задачи для выбранного проекта
    queryString := 'SELECT * FROM ci53070_unionpro.Tasks where Projects_idProjects =' + currentPROJECT_ID.ToString() + ';';
    sqlQuery.SQL.Add(queryString);

    try
      sqlQuery.Active := True;;
    except
      on e: EADOError do
      begin
        MessageDlg('Ошибка зыгрузки списка задач для выбранного проекта. ' + e.Message, mtError,[mbOK], 0);
        Exit;
      end;
    end;

 if sqlQuery.RecordCount = 0 then
  begin
    ShowMessage('Список задач для выбранного проекта пуст.');
//    buttonSelected := MessageDlg('Список задач для выбранноо проекта пуст. Создать новую задачу ?', mtInformation, mbYesNo, 0);
//    if buttonSelected = mrYes then
//      begin
//        // показать форму для создания новой задачи
//        frmNewTask.Tag := 0;
//        frmNewTask.Show;
//        self.Close;
//        Exit;
//      end;
//    if buttonSelected = mrNo then
//      begin
//        Exit;
//      end;
  end
  else
    begin
      // Очистка списка задач для выбранного проекта
      SetLength(all_ProjectTasts, 0);
      SetLength(all_ProjectTasts, sqlQuery.RecordCount);
      // Очистка списка задач
      frmProjects.lbTasks.Items.Clear;
      // Заполнение списка проектов
      for i := 0 to sqlQuery.RecordCount-1 do
      begin
        all_ProjectTasts[i] := task.Create();

        all_ProjectTasts[i].id_tasks 	  := sqlQuery.FieldByName('idTasks').AsInteger;
        all_ProjectTasts[i].creationDate:= sqlQuery.FieldByName('creation_date').AsDateTime;
        all_ProjectTasts[i].task_aim    := sqlQuery.FieldByName('task_aim').Text;
        all_ProjectTasts[i].id_project 	:= sqlQuery.FieldByName('Projects_idProjects').AsInteger;
        all_ProjectTasts[i].name       	:= sqlQuery.FieldByName('task_name').AsString;
        all_ProjectTasts[i].id_user 	  := sqlQuery.FieldByName('Users_idUsers').AsInteger;
        all_ProjectTasts[i].description := sqlQuery.FieldByName('description').AsString;
      // Заполение списка задач
        frmProjects.lbTasks.Items.Add(all_ProjectTasts[i].name);
        sqlQuery.Next;
      end;
    end;

end;

procedure TfrmNewTask.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmTasks.Enabled := true;
end;

procedure TfrmNewTask.FormShow(Sender: TObject);
var
  I: Integer;
  temp :users;
begin
  temp.getAllUsers;
  // заполнЯем список пользователей
  for I := 0 to length(all_users)-1 do
    begin
        cbUserName.Items.Add(all_users[i].login);
    end;
// если создается новая задача
  if frmNewTask.Tag = 0 then
    begin
      mmAimTask.Text := '';
      mmTaskName.Text := '';
      mmDescriptionTask.Text := '';
    end;

  if frmNewTask.Tag <> 0 then
    begin
      mmAimTask.Text := all_ProjectTasts[selected_task].task_aim;
      mmTaskName.Text := all_ProjectTasts[selected_task].name;
      mmDescriptionTask.Text := all_ProjectTasts[selected_task].description;

      // выбираем активного пользователя
      for I := 0 to Length(all_users)-1 do
      begin
        if all_ProjectTasts[selected_task].id_user = all_users[i].id_user then
          begin
            cbUserName.ItemIndex := cbUserName.Items.IndexOf(all_users[i].login);
          end;
      end;
    end;
end;

end.
