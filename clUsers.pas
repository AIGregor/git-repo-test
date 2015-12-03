unit clUsers;

interface

uses Data.DB,  Data.Win.ADODB, Vcl.Dialogs;

type
  users = class
  public
    id_user : integer;
    registration_date : TDate;
    login : string;
    procedure getAllUsers;
  end;


var
  all_users : array of users;

implementation

uses glbVar, clProjects, clTasks, tasks;

procedure users.getAllUsers();
var
  sqlQuery : TADOQuery;
  i : integer;
begin
// загрузить список пользователей / сформировать объект класса пользователь и проект
  sqlQuery := TADOQuery.Create(nil);

  if not currentTypeConnection then
    sqlQuery.ConnectionString := sqlConnection_localhost
  else
    sqlQuery.ConnectionString := sqlConnection_remotehost;

  sqlQuery.SQL.Clear;
  sqlQuery.SQL.Add('SELECT * FROM ci53070_unionpro.Users;');
  try
    sqlQuery.Active := True;
  except
    on e: EADOError do
    begin
      MessageDlg('Ошибка при загрузке списка пользователей.', mtError,[mbOK], 0);
      Exit;
    end;
  end;
  
  // структура данных users
  // 0 - id_users
  // 2 - login (имя пользователя)
  if length(all_users) <= 0 then
    begin
      SetLength(all_users, sqlQuery.RecordCount);

      for i := 0 to sqlQuery.RecordCount-1 do
        begin
          all_users[i] := users.Create;
          all_users[i].id_user := sqlQuery.Fields[0].AsInteger;
          all_users[i].login := sqlQuery.Fields[2].AsString;
          sqlQuery.Next;
        end;
      sqlQuery.Destroy;
    end;

end;

end.
