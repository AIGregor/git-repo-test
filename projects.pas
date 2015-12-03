unit projects;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Data.DB,
  Data.Win.ADODB, Vcl.Menus, Vcl.Buttons, Vcl.ExtCtrls, Vcl.ToolWin;

type
  TfrmProjects = class(TForm)
    pnlTasks: TPanel;
    btnOpenRecords: TButton;
    Panel2: TPanel;
    ProjectsList: TListBox;
    ProjectName: TLabel;
    pnlProjectProperties: TPanel;
    LProjectTimeCreation: TLabel;
    LDescription: TLabel;
    ProjectDateCreation: TDateTimePicker;
    Description: TMemo;
    Panel4: TPanel;
    BitBtn2: TBitBtn;
    Panel5: TPanel;
    BitBtn3: TBitBtn;
    btnCloseProjectProperties: TBitBtn;
    btnCloseTasks: TBitBtn;
    Panel6: TPanel;
    btnMinProject: TBitBtn;
    btmCloseProject: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    TaskName: TLabel;
    lbTasks: TListBox;
    lblAimTask: TLabel;
    edtAimTask: TEdit;
    Label4: TLabel;
    mmDescriptionTask: TMemo;
    Label5: TLabel;
    creationDateTask: TDateTimePicker;
    btnShowTasks: TBitBtn;
    btnShowProperties: TBitBtn;
    btnSettings: TBitBtn;
    PopupMenuProjectList: TPopupMenu;
    ppmCreateProject: TMenuItem;
    EditCurrentProject: TMenuItem;
    PopupMenuTasks: TPopupMenu;
    ppmAddNewTask: TMenuItem;
    ppmEdtTask: TMenuItem;
    procedure btnOpenRecordsClick(Sender: TObject);
    procedure btnCreateProjectClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ProjectsListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ppmCreateProjectClick(Sender: TObject);
    procedure ProjectsListClick(Sender: TObject);
    procedure EditCurrentProjectClick(Sender: TObject);
    procedure Panel6DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Panel6MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnCloseProjectPropertiesClick(Sender: TObject);
    procedure btnShowPropertiesClick(Sender: TObject);
    procedure btnCloseTasksClick(Sender: TObject);
    procedure btnShowTasksClick(Sender: TObject);

    procedure loadingTasks(id_project : integer);
    procedure lbTasksClick(Sender: TObject);
    procedure ppmAddNewTaskClick(Sender: TObject);
    procedure ppmEdtTaskClick(Sender: TObject);
    procedure btmCloseProjectClick(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
    procedure btnMinProjectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmProjects: TfrmProjects;
  visibleTasks : boolean;
  visibleProperties : Boolean;
implementation

{$R *.dfm}
uses tasks,newproject,glbVar, clProjects, newtask, clTasks, records, settings;

procedure TfrmProjects.btnShowTasksClick(Sender: TObject);
begin
  if visibleTasks then
    begin
      pnlTasks.Visible := false;
      visibleTasks := false;
    end
  else
    begin
      pnlTasks.Visible := true;
      visibleTasks := true;
    end;
end;

procedure TfrmProjects.btnSettingsClick(Sender: TObject);
begin
  frmSettings.Show;
end;

procedure TfrmProjects.btnShowPropertiesClick(Sender: TObject);
begin
  if visibleProperties then
    begin
      pnlProjectProperties.Visible := false;
      visibleProperties := false;
    end
  else
    begin
      pnlProjectProperties.Visible := true;
      visibleProperties := true;
    end;
end;

procedure TfrmProjects.btmCloseProjectClick(Sender: TObject);
begin
  frmProjects.Close;
end;

procedure TfrmProjects.btnCloseProjectPropertiesClick(Sender: TObject);
begin
  pnlProjectProperties.Visible := false;
end;

procedure TfrmProjects.btnCloseTasksClick(Sender: TObject);
begin
  pnlTasks.Visible := false;
end;

procedure TfrmProjects.btnCreateProjectClick(Sender: TObject);
begin
  frmNewProject.Show;
  //frmProjects.Enabled := false;
end;

procedure TfrmProjects.btnMinProjectClick(Sender: TObject);
begin
  frmProjects.WindowState := wsMinimized;
end;

procedure TfrmProjects.Button1Click(Sender: TObject);
begin
  frmNewProject.Caption := 'Новый проект';
// говорим что надо создать
  frmNewProject.Tag := 0;
  frmNewProject.Show;
//frmProjects.Enabled := false;
end;

procedure TfrmProjects.FormCreate(Sender: TObject);
begin
// Отображение формы записи как отдельного окна в строке Пуск
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
  visibleTasks := true;
  visibleProperties := true;
end;

procedure TfrmProjects.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  frmProjects.perform(WM_SysCommand,$F012,0);
end;

procedure TfrmProjects.FormShow(Sender: TObject);
var
  firstQuery : TADOQuery;
  i : Integer;
  buttonSelected : integer;
begin
  pnlProjectProperties.Visible := false;
  pnlTasks.Visible := false;

  // очистка списка
  ProjectsList.Items.Clear;

  // загрузка из БД параметры проетов для отображения на форме.
  firstQuery := TADOQuery.Create(Self);

  if not currentTypeConnection then
    firstQuery.ConnectionString := sqlConnection_localhost
  else
    firstQuery.ConnectionString := sqlConnection_remotehost;

  firstQuery.SQL.Clear;
  firstQuery.SQL.Add('SELECT * FROM ci53070_unionpro.Projects where user_id =' + IntToStr(currentUSER_ID) + ';');

  try
    firstQuery.Active := True;
  except
    on e: EADOError do
    begin
      MessageDlg('Ошибка во время выполнения запроса.', mtError,[mbOK], 0);
      Exit;
    end;
  end;

  //Проверка существования проектов
  if firstQuery.RecordCount <= 0 then
    begin
      buttonSelected := MessageDlg('Список проектов пуст. Создать новый проект ?', mtInformation, mbYesNo, 0);
      if buttonSelected = mrYes then
        begin
          frmNewProject.Show;
          exit;
        end;
      if buttonSelected = mrNo then
        begin
          Exit;
        end;
    end
    else
      begin
        // Структура данных
        // 0 - idProject
        // 1 - projectName
        // 2 - crationDate
        // 3 - user_id
        // 4 - comment
          SetLength(all_project, firstQuery.RecordCount);

        // Заполнение списка проектов
        for i := 0 to firstQuery.RecordCount-1 do
        begin
          all_project[i] := project.Create();
          all_project[i].id_project := firstQuery.Fields[0].AsInteger;
          all_project[i].name := firstQuery.Fields[1].AsString;
          all_project[i].creationDate := firstQuery.Fields[2].AsDateTime;
          all_project[i].id_user := firstQuery.Fields[3].AsInteger;
          all_project[i].description := firstQuery.Fields[4].AsString;

          ProjectsList.Items.Add(all_project[i].name);

          if i=0 then
            begin
              Description.Text := all_project[i].description;
              ProjectName.Caption := all_project[i].name;
              ProjectDateCreation.Date := all_project[i].creationDate;
            end;
          firstQuery.Next;
        end;
        firstQuery.Free;
        ProjectsList.ItemIndex := 0;

        loadingTasks(all_project[0].id_project);

        if Length(all_ProjectTasts) > 0 then
          begin
            TaskName.Caption := all_ProjectTasts[0].name;
            edtAimTask.Text := all_ProjectTasts[0].task_aim;
            mmDescriptionTask.Text := all_ProjectTasts[0].description;
          end
          else
            begin
              TaskName.Caption := 'Задача';
              edtAimTask.Text := '';
              mmDescriptionTask.Text := '';
            end;
      end;
end;

procedure TfrmProjects.Panel6DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  MyMouse: TMouse;
begin
//  frmProjects.left := MyMouse.CursorPos.X;
//  frmProjects.top := MyMouse.CursorPos.Y;
end;

procedure TfrmProjects.Panel6MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // перемещение формы спомощью мыши
  ReleaseCapture;
  frmProjects.perform(WM_SysCommand,$F012,0);
end;

procedure TfrmProjects.EditCurrentProjectClick(Sender: TObject);
begin
  if ProjectsList.ItemIndex = -1 then MessageDlg('Выберите элемент.', mtError,[mbOK], 0);

  frmNewProject.Caption := 'Редактировать проект №' + all_project[ProjectsList.ItemIndex].id_project.ToString;
// говорим что нужно редактировать
  frmNewProject.Tag := 1;
  selectedProject := ProjectsList.ItemIndex;
  frmNewProject.Show;
//  frmProjects.Enabled := false;
end;

procedure TfrmProjects.ppmAddNewTaskClick(Sender: TObject);
begin
  //frmProjects.Enabled := false;
  frmProjects.WindowState := wsMinimized;
  frmNewTask.Tag := 0;
  frmNewTask.Caption := 'Новая задача';
  currentPROJECT_ID := all_project[ProjectsList.ItemIndex].id_project;
  frmNewTask.Show;
end;

procedure TfrmProjects.ppmCreateProjectClick(Sender: TObject);
begin
  // Создание нового проекта
  frmProjects.WindowState := wsMinimized;
  frmNewProject.Show;
end;

procedure TfrmProjects.ppmEdtTaskClick(Sender: TObject);
begin
  //frmProjects.Enabled := false;
  frmNewTask.Tag := 1;
  frmNewTask.Caption := 'Редактировать задачу';
  currentPROJECT_ID := all_ProjectTasts[lbTasks.ItemIndex].id_project;
  frmNewTask.Show;
end;

procedure TfrmProjects.btnOpenRecordsClick(Sender: TObject);
begin
  selected_task  := all_ProjectTasts[lbTasks.ItemIndex].id_tasks;
  currentPROJECT_ID := all_ProjectTasts[lbTasks.ItemIndex].id_project;
  frmTasks.Close;
  frmRecords.Show;
end;

procedure TfrmProjects.lbTasksClick(Sender: TObject);
var
  showIndex : integer;
begin
  showIndex := lbTasks.ItemIndex;
  creationDateTask.Date := all_ProjectTasts[showIndex].creationDate;
  TaskName.Caption := all_ProjectTasts[showIndex].name;
  edtAimTask.Text := all_ProjectTasts[showIndex].task_aim;
  mmDescriptionTask.Text := all_ProjectTasts[showIndex].description;
  currentTASK_ID := all_ProjectTasts[showIndex].id_tasks;
end;

procedure TfrmProjects.loadingTasks(id_project : integer);
var
  selectedProject : integer;
  i : integer;
  sqlQuery  : TADOQuery;
  queryString : string;
  buttonSelected : integer;
begin
   selectedProject := all_project[ProjectsList.ItemIndex].id_project;

  // загрузка  всех задач для выбранного проекта
  //на 28-07-2015 строим простой список
  // построение дерева задач рассмотрим потом по мере необходимости главное запустить
    sqlQuery := TADOQuery.Create(self);

  if not currentTypeConnection then
    sqlQuery.ConnectionString := sqlConnection_localhost
  else
    sqlQuery.ConnectionString := sqlConnection_remotehost;

    sqlQuery.SQL.Clear;
  // получаем все задачи для выбранного проекта
    queryString := 'SELECT * FROM ci53070_unionpro.Tasks where Projects_idProjects =' +
      selectedProject.ToString() + ';';
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
    lbTasks.Items.Clear;
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
      lbTasks.Items.Clear;
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
        lbTasks.Items.Add(all_ProjectTasts[i].name);
        sqlQuery.Next;
      end;
    end;

  sqlQuery.Free;
end;


procedure TfrmProjects.ProjectsListClick(Sender: TObject);
var
  selectedProject : integer;
  i : integer;
  sqlQuery  : TADOQuery;
  queryString : string;
  buttonSelected : integer;
begin
  selectedProject := ProjectsList.ItemIndex;
  currentPROJECT_ID := all_project[ProjectsList.ItemIndex].id_project;
  loadingTasks(all_project[ProjectsList.ItemIndex].id_project);

  // Заполнение свойств проекта
  Description.Text := all_project[selectedProject].description;
  ProjectName.Caption := all_project[selectedProject].name;
  ProjectDateCreation.Date := all_project[selectedProject].creationDate;
  // Зополнение свойств задачи
  TaskName.Caption := all_ProjectTasts[0].name;
  edtAimTask.Text := all_ProjectTasts[0].task_aim;
  mmDescriptionTask.Text := all_ProjectTasts[0].description;

  lbTasks.ItemIndex := 0;

  selectedProject := all_project[ProjectsList.ItemIndex].id_project;
  currentPROJECT_ID := selectedProject;
end;

procedure TfrmProjects.ProjectsListMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then PopupMenuProjectList.Popup(x,y);
end;

end.
