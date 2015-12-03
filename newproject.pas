unit newproject;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB,  Data.Win.ADODB;

type
  TfrmNewProject = class(TForm)
    LbAuthorName: TLabel;
    cbUserName: TComboBox;
    Label1: TLabel;
    mmProjectName: TMemo;
    mmDescription: TMemo;
    LDescription: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNewProject: TfrmNewProject;

implementation

{$R *.dfm}
uses projects, glbVar, clUsers, clProjects, clTasks;

procedure TfrmNewProject.Button1Click(Sender: TObject);
var
  sqlQuery  : TADOQuery;
  prId_user : TParameter;
  prProjectName : TParameter;
  prDescription : TParameter;
  prDate : TParameter;
  queryString : string;
  i : integer;
begin

  sqlQuery := TADOQuery.Create(self);

  if not currentTypeConnection then
    sqlQuery.ConnectionString := sqlConnection_localhost
  else
    sqlQuery.ConnectionString := sqlConnection_remotehost;

    sqlQuery.SQL.Clear;
// Создание нового проекта
if frmNewProject.Tag = 0 then
  begin
    if (mmProjectName.Text = '') then
      MessageDlg('Введите название проекта.', mtError,[mbOK], 0);

    if (cbUserName.Items[cbUserName.ItemIndex] = '') then
      MessageDlg('Введите пользователя.', mtError,[mbOK], 0);

    SetLength(all_project, length(all_project)+1);
    all_project[Length(all_project)-1] := project.Create;

    all_project[Length(all_project)-1].id_user := all_users[cbUserName.ItemIndex].id_user;
    all_project[Length(all_project)-1].creationDate := now;
    all_project[Length(all_project)-1].description := mmDescription.Text;
    all_project[Length(all_project)-1].name := mmProjectName.Text;

    queryString := 'INSERT INTO ci53070_unionpro.Projects' +
       ' (project_name, creation_date, user_id, comments) ' +
       ' VALUES ( ' + #39 + all_project[Length(all_project)-1].name + #39 +
       ', ' + #39 + FormatDateTime('yyyy-mm-dd hh:mm:ss', Now) + #39 +
       ', ' + #39 + all_project[Length(all_project)-1].id_user.ToString + #39 +
       ', ' + #39 + mmDescription.Text + #39 + ');';

    sqlQuery.SQL.Add(queryString);

    try
      sqlQuery.ExecSQL;
    except
      on e: EADOError do
      begin
        MessageDlg('Ошибка при создании новоо проекта. ' + e.Message, mtError,[mbOK], 0);
		frmProjects.Enabled := true;
		frmNewProject.Close;
        Exit;
      end;
    end;
  end;
// Редактирование выбранного проекта
if frmNewProject.Tag = 1 then
  begin
    // собираем измененные данные
    all_project[selectedProject].id_user := all_users[cbUserName.ItemIndex].id_user;
    all_project[selectedProject].creationDate := now;
    all_project[selectedProject].description := mmDescription.Text;
    all_project[selectedProject].name := mmProjectName.Text;
    // добавление в список
    frmProjects.ProjectsList.Items.Add(mmProjectName.Text);
    // составление запроса
    queryString := 'UPDATE ci53070_unionpro.Projects SET project_name=' + #39 +
       all_project[selectedProject].name + #39 + ', user_id= ' + #39 +
       all_project[selectedProject].id_user.ToString + #39 + ', comments=' + #39 +
       all_project[selectedProject].description + #39 + 'WHERE idProjects=' + #39 +
       all_project[selectedProject].id_project.ToString + #39 + ';';

    sqlQuery.SQL.Add(queryString);
    try
      sqlQuery.ExecSQL;
    except
      on e: EADOError do
      begin
        MessageDlg('Ошибка при сохранении изменений в проекте. ' + e.Message, mtError,[mbOK], 0);
		frmProjects.Enabled := true;
		frmNewProject.Close;
        Exit;
      end;
    end;
  end;

  frmProjects.ProjectsList.Clear;

  // Заполнение списка проектов
  for i := 0 to Length(all_project)-1 do
  begin
    frmProjects.ProjectsList.Items.Add(all_project[i].name);

    if i=0 then
      begin
        frmProjects.Description.Text := all_project[i].description;
        frmProjects.ProjectName.Caption := all_project[i].name;
        frmProjects.ProjectDateCreation.Date := all_project[i].creationDate;
      end;

  end;

      sqlQuery.SQL.Clear;
  // получаем все задачи для выбранного проекта
    queryString := 'SELECT * FROM ci53070_unionpro.Tasks where Projects_idProjects =' + selectedProject.ToString() + ';';
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

  // UPDATE `ci53070_unionpro`.`Projects` SET `project_name`='Тестироваие',
  //`user_id`='1', `comments`='Описание тестого проета для обображения в программе' WHERE `idProjects`='1';
  sqlQuery.Free;

// закрыть окно создание проектов и перейти на выбор проекта
  frmProjects.Enabled := true;
  frmProjects.WindowState := wsNormal;
  frmNewProject.Close;

end;

procedure TfrmNewProject.FormShow(Sender: TObject);
var
  i : integer;
  temp : users;
begin

temp.getAllUsers;

for i := 0 to length(all_users)-1 do
  begin
    cbUserName.Items.Add(all_users[i].login);
  end;

if Tag = 1 then
  begin
    for I := 0 to Length(all_users)-1 do
      begin
        if all_project[selectedProject].id_user = all_users[i].id_user then
          begin
            cbUserName.ItemIndex := cbUserName.Items.IndexOf(all_users[i].login);
          end;
      end;
    mmDescription.Text := all_project[selectedProject].description;
    mmProjectName.Text := all_project[selectedProject].name;
  end;

end;

end.
