program UnionPro;

{$R *.dres}

uses
  Vcl.Forms,
  Main in 'Main.pas' {MainForm},
  projects in 'projects.pas' {frmProjects},
  records in 'records.pas' {frmRecords},
  source in 'source.pas' {frmSource},
  clUsers in 'clUsers.pas',
  clProjects in 'clProjects.pas',
  clRecords in 'clRecords.pas',
  clResource in 'clResource.pas',
  tasks in 'tasks.pas' {frmTasks},
  login in 'login.pas' {frmLogin},
  newproject in 'newproject.pas' {frmNewProject},
  glbVar in 'glbVar.pas',
  clTasks in 'clTasks.pas',
  newtask in 'newtask.pas' {frmNewTask},
  sourcelist in 'sourcelist.pas' {frmSourceList},
  wizardsource in 'wizardsource.pas' {frmWizardSource},
  settings in 'settings.pas' {frmSettings};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmProjects, frmProjects);
  Application.CreateForm(TfrmRecords, frmRecords);
  Application.CreateForm(TfrmSource, frmSource);
  Application.CreateForm(TfrmTasks, frmTasks);
  Application.CreateForm(TfrmNewProject, frmNewProject);
  Application.CreateForm(TfrmNewTask, frmNewTask);
  Application.CreateForm(TfrmSourceList, frmSourceList);
  Application.CreateForm(TfrmWizardSource, frmWizardSource);
  Application.CreateForm(TfrmSettings, frmSettings);
  Application.Run;
end.
