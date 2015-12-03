unit sourcelist;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Data.DB,  Data.Win.ADODB, Winapi.ShellAPI;

type
  TfrmSourceList = class(TForm)
    pnlSourceTable: TPanel;
    pnlButtons: TPanel;
    dbgSourceList: TDBGrid;
    btnInclude: TButton;
    btnCancel: TButton;
    dsAll_Source: TDataSource;
    btnAddNewSource: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnAddNewSourceClick(Sender: TObject);
    procedure RefreshListSource();
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dbgSourceListDblClick(Sender: TObject);
    procedure btnIncludeClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
 // http://www.slideshare.net/neoLogics/palo-jedox
var
  frmSourceList: TfrmSourceList;
  clearListSource : Boolean;

implementation

{$R *.dfm}
uses glbVar, wizardsource, records;

procedure TfrmSourceList.btnAddNewSourceClick(Sender: TObject);
begin
// Показать форму-мастера выбора типа источника = web-ссылка или файл
  frmWizardSource.Show;
  frmWizardSource.rbWeb.Checked := false;
  frmWizardSource.rbFile.Checked := false;
  frmWizardSource.mmSourceLink.Text := '';
  frmWizardSource.mmComment.Text := '';
  frmWizardSource.mmSourceName.Text := '';
end;

procedure TfrmSourceList.btnCancelClick(Sender: TObject);
begin
  self.Close;
end;
// Подключение ресурса к задаче
procedure TfrmSourceList.btnIncludeClick(Sender: TObject);
var
  FileLink : string;
  idRecord : integer;
  idSource : integer;
  sqlQuery  : TADOQuery;
  i : integer;
  queryString : string;
begin
// всегда активен первый источник в списке
  FileLink := dsAll_Source.DataSet.FieldByName('content').AsString;
  idRecord := currentRECORD_ID;
  idSource := dsAll_Source.DataSet.FieldByName('idSource').AsInteger;

  ShowMessage(FileLink);

// Создать новую запись в таблице Resousce
  sqlQuery := TADOQuery.Create(self);

    if not currentTypeConnection then
    sqlQuery.ConnectionString := sqlConnection_localhost
  else
    sqlQuery.ConnectionString := sqlConnection_remotehost;

  sqlQuery.SQL.Clear;
// INSERT INTO `ci53070_unionpro`.`Resources` (`creation_date`, `comments`, `Records_idRecords`, `Source_idSource`) VALUES ('2015-05-05', 'sdfsdfa', '6', '10');

  queryString := 'INSERT INTO ci53070_unionpro.Resources (creation_date,' +
    ' Records_idRecords, Source_idSource) VALUES (' +
    #39 + FormatDateTime('yyyy-mm-dd hh:mm:ss',now) + #39 + ', ' +
    #39 + idRecord.ToString  + #39 + ', ' +
    #39 + idSource.ToString     + #39 + ');';

  sqlQuery.SQL.Add(queryString);

  try
    sqlQuery.ExecSQL;
  except
    on e: EADOError do
    begin
      MessageDlg('Ошибка при добавлении ресурса к задаче. ' + e.Message, mtError,[mbOK], 0);
      Exit;
    end;
  end;

  frmRecords.RefreshResourceTable;

end;

procedure TfrmSourceList.dbgSourceListDblClick(Sender: TObject);
var
  i : integer;
  FileLink : string;
  pwcFileLink : PWideChar;
begin
// Открытие файла для просмотра из списка источников
  FileLink := dsAll_Source.DataSet.FieldByName('content').AsString;
  pwcFileLink := Addr(FileLink[1]);
  ShellExecute(0, nil, pwcFileLink, nil, nil, SW_SHOWNORMAL);

//  ShowMessage(contentString);

//  selectedIndex := dsAll_Source.DataSet.RecNo;
//  while i < selectedIndex do
//    begin
//      dsAll_Source.DataSet.Next;
//      i := i + 1;
//    end;
//
//  contentString := dsAll_Source.DataSet.FieldByName('content').AsString;
//  ShowMessage(selectedIndex.ToString() + ' ' + contentString);
end;

procedure TfrmSourceList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmRecords.Enabled := true;
  frmSourceList.btnInclude.Enabled := true;
end;

procedure TfrmSourceList.FormShow(Sender: TObject);
var
  sqlQuery  : TADOQuery;
  i : integer;
  queryString : string;
  buttonSelected : integer;
begin
// загрузить все существующие источники.
    sqlQuery := TADOQuery.Create(nil);

  if not currentTypeConnection then
    sqlQuery.ConnectionString := sqlConnection_localhost
  else
    sqlQuery.ConnectionString := sqlConnection_remotehost;

    sqlQuery.SQL.Clear;

    queryString := 'SELECT * FROM ci53070_unionpro.Source;';

    sqlQuery.SQL.Add(queryString);

    try
      sqlQuery.Active := true;
    except
      on e: EADOError do
      begin
        MessageDlg('Ошибка при загрузке источников для выбранной задачи. ' + e.Message, mtError,[mbOK], 0);
        Exit;
      end;
    end;

  dsAll_Source.DataSet := sqlQuery;

  if sqlQuery.RecordCount = 0 then
    begin
      buttonSelected := MessageDlg('Список источников пуст. Добавить новый источник ?', mtInformation, mbYesNo, 0);
      // добавить новый источник в БД
      if buttonSelected = mrYes then
        begin
        // Показать форму-мастера выбора типа источника = web-ссылка или файл
          frmWizardSource.Show;
          frmSourceList.Enabled := false;
        end;
      // не добавлять новый источник
      if buttonSelected = mrNo then
        begin
          clearListSource := true;
          exit;
        end;

    end;
	
// Редактирование заголовков таблицы
  dbgSourceList.Columns[0].Title.Caption := 'ID';
  dbgSourceList.Columns[1].Title.Caption := 'Дата создания';
  dbgSourceList.Columns[5].Title.Caption := 'Путь';
  dbgSourceList.Columns[6].Title.Caption := 'Имя';

  dbgSourceList.Columns[0].Width := 50;
  dbgSourceList.Columns[1].Width := 130;
  dbgSourceList.Columns[5].Width := 300;
  dbgSourceList.Columns[6].Width := 130;

  dbgSourceList.Columns[2].Visible := false;
  dbgSourceList.Columns[3].Visible := false;
  dbgSourceList.Columns[4].Visible := false;
end;
// Обновление списка иточников
procedure TfrmSourceList.RefreshListSource();
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

  queryString := 'SELECT * FROM ci53070_unionpro.Source;';

  sqlQuery.SQL.Add(queryString);
    try
      sqlQuery.Active := True;
    except
      on e: EADOError do
      begin
        MessageDlg('Ошибка при обновлении списка источников. ' + e.Message, mtError,[mbOK], 0);
        Exit;
      end;
    end;
  // загрузка на форму
  dsAll_Source.DataSet := sqlQuery;

  // Редактирование заголовков таблицы
  dbgSourceList.Columns[0].Title.Caption := 'ID';
  dbgSourceList.Columns[1].Title.Caption := 'Дата создания';
  dbgSourceList.Columns[5].Title.Caption := 'Путь';
  dbgSourceList.Columns[6].Title.Caption := 'Имя';

  dbgSourceList.Columns[0].Width := 50;
  dbgSourceList.Columns[1].Width := 130;
  dbgSourceList.Columns[5].Width := 300;
  dbgSourceList.Columns[6].Width := 130;

  dbgSourceList.Columns[2].Visible := false;
  dbgSourceList.Columns[3].Visible := false;
  dbgSourceList.Columns[4].Visible := false;
end;

end.
