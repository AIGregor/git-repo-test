unit tasks;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Menus,
  Vcl.StdCtrls, Data.DB,  Data.Win.ADODB;

type
  TfrmTasks = class(TForm)
    plnTreeTasks: TPanel;
    Panel1: TPanel;
    ProjectName: TLabel;
    lblAimTask: TLabel;
    edtAimTask: TEdit;
    Label1: TLabel;
    btnShowRecords: TButton;
    Splitter2: TSplitter;
    PopupMenuTasks: TPopupMenu;
    ppmAddNewTask: TMenuItem;
    ppmEdtTask: TMenuItem;
    mmDescriptionTask: TMemo;
    BackToProject: TButton;
    ADOConnection1: TADOConnection;
    procedure FormShow(Sender: TObject);
    procedure Panel1Resize(Sender: TObject);
    procedure ppmAddNewTaskClick(Sender: TObject);
    procedure ppmEdtTaskClick(Sender: TObject);
    procedure lbTasksClick(Sender: TObject);
    procedure BackToProjectClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTasks: TfrmTasks;

implementation

{$R *.dfm}
uses glbVar, clProjects, clTasks, newtask, clUsers, records, projects;

procedure TfrmTasks.BackToProjectClick(Sender: TObject);
begin
  frmProjects.Show;
  self.Close;
end;

procedure TfrmTasks.FormShow(Sender: TObject);
var
 temp : project;
begin

//  TaskName.Caption := all_ProjectTasts[0].name;
  edtAimTask.Text := all_ProjectTasts[0].task_aim;
  mmDescriptionTask.Text := all_ProjectTasts[0].description;
  ProjectName.Caption := temp.getNameProjectByID_project(currentPROJECT_ID);

//  lbTasks.ItemIndex := 0;

end;

procedure TfrmTasks.ppmAddNewTaskClick(Sender: TObject);
begin
  frmTasks.Enabled := false;
  frmNewTask.Tag := 0;
  frmNewTask.Caption := 'Новая задача';
//  selected_task := lbTasks.ItemIndex;
  frmNewTask.Show;
end;

procedure TfrmTasks.ppmEdtTaskClick(Sender: TObject);
begin
  frmTasks.Enabled := false;
  frmNewTask.Tag := 1;
  frmNewTask.Caption := 'Редактировать задачу';
//  selected_task := lbTasks.ItemIndex;
  frmNewTask.Show;
end;

procedure TfrmTasks.lbTasksClick(Sender: TObject);
var
  showIndex : integer;
begin
//  showIndex := lbTasks.ItemIndex;

//  TaskName.Caption := all_ProjectTasts[showIndex].name;
  edtAimTask.Text := all_ProjectTasts[showIndex].task_aim;
  mmDescriptionTask.Text := all_ProjectTasts[showIndex].description;

end;

procedure TfrmTasks.Panel1Resize(Sender: TObject);
var
  commonWidth : integer;
begin
  commonWidth := Panel1.Width - 16;
  ProjectName.Width := commonWidth;
//  TaskName.Width := commonWidth;
  edtAimTask.Width := commonWidth;
  mmDescriptionTask.Width := commonWidth;
  btnShowRecords.Width := commonWidth-125;
end;

end.
