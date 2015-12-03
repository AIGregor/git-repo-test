unit login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB,  Data.Win.ADODB;

type
  TfrmLogin = class(TForm)
    edtLogin: TEdit;
    edtPassword: TEdit;
    lblAimTask: TLabel;
    Label1: TLabel;
    btnEntre: TButton;
    lblNewUser: TLabel;
    edPasswordCheck: TEdit;
    btnCreateNewUser: TButton;
    btnCancel: TButton;
    procedure btnEntreClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lblNewUserClick(Sender: TObject);
    procedure btnCreateNewUserClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;
  checkPassword: string;
  loginStatus : boolean;

implementation

{$R *.dfm}
uses Main, glbVar, clUsers;

procedure TfrmLogin.btnCancelClick(Sender: TObject);
begin
  //frmLogin.Width := 361;
  frmLogin.Height := 112;

  btnCancel.Visible := false;
  btnCreateNewUser.Visible := false;
  edPasswordCheck.Visible := false;

  edtLogin.Text := '';
  edtPassword.Text := '';
  edPasswordCheck.Text := '';

  lblNewUser.Visible := true;
  btnEntre.Visible := true;
end;

procedure TfrmLogin.btnCreateNewUserClick(Sender: TObject);
var
  sqlQuery  : TADOQuery;
  queryString : String;
begin
// Создание нового пользователя

  // Проверка заполнения имени и пароля
  if (edtLogin.Text = '') or
    (edtPassword.Text = '') or
    (edPasswordCheck.Text = '') then
    begin
      MessageDlg('Заполните все необходимые поля. ', mtError,[mbOK], 0);
      Exit;
    end;
  // проверка совпадения паролей
  if edtPassword.Text <> edPasswordCheck.Text then
    begin
      MessageDlg('Пароли не совпадают!', mtError,[mbOK], 0);
      Exit;
    end;
  // подключение к БД
    sqlQuery := TADOQuery.Create(self);

  if not currentTypeConnection then
    sqlQuery.ConnectionString := sqlConnection_localhost
  else
    sqlQuery.ConnectionString := sqlConnection_remotehost;

    sqlQuery.SQL.Clear;
  // INSERT INTO `ci53070_unionpro`.`Users` (`login`, `password`) VALUES ('Гость', '123');

    queryString := 'INSERT INTO ci53070_unionpro.Users' +
       ' (creation_date, login, password) ' +
       ' VALUES ( ' +
              #39 + FormatDateTime('yyyy-mm-dd hh:mm:ss', Now) + #39 +
       ', ' + #39 + edtLogin.Text + #39 +
       ', ' + #39 + edtPassword.Text + #39 + ');'; ;

    sqlQuery.SQL.Add(queryString);

    try
      sqlQuery.ExecSQL;
    except
      on e: EADOError do
      begin
        MessageDlg('Не удалось нового пользователя. Ошибка: ' + e.Message, mtError,[mbOK], 0);
        Exit;
      end;
    end;

  sqlQuery.Free;

  MessageDlg('Новый пользователь успешно создан. Запустите программу еще раз.', mtInformation ,[mbOK], 0);
  self.Close;
end;

procedure TfrmLogin.btnEntreClick(Sender: TObject);
var
  counrUser : integer;
  i : integer;
begin
  checkPassword := 'behdf';
  if checkPassword = 'behdf' then
    begin
      counrUser := Length(all_users);
      for i := 0 to counrUser - 1 do
        begin
          if (edtLogin.Text = all_users[i].login) then
            begin
              currentUSER_ID := all_users[i].id_user;
              MainForm.Visible := True;
              MainForm.Enabled := true;
              loginStatus := true;
              frmLogin.Close;
              Exit;
            end;
        end;
      MessageDlg('Среди нас таких нет!', mtError,[mbOK], 0);
      checkPassword := '';
//      CheckBox1.Checked := false;
//      CheckBox2.Checked := false;
//      CheckBox3.Checked := false;
//      CheckBox4.Checked := false;
//      CheckBox5.Checked := false;
//      CheckBox6.Checked := false;
//      CheckBox7.Checked := false;
//      CheckBox8.Checked := false;
//      CheckBox9.Checked := false;
      exit;
    end
  else
     begin
      ShowMessage('А казачек то засланный.');
      checkPassword := '';
//      CheckBox1.Checked := false;
//      CheckBox2.Checked := false;
//      CheckBox3.Checked := false;
//      CheckBox4.Checked := false;
//      CheckBox5.Checked := false;
//      CheckBox6.Checked := false;
//      CheckBox7.Checked := false;
//      CheckBox8.Checked := false;
//      CheckBox9.Checked := false;
     end;

 // if edtLogin.Text = '' then ShowMessage('Введите имя пользователя.');
 // if edtPassword.Text = '' then ShowMessage('Введите пароль.');

end;

procedure TfrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // При закрытии формы авторизации закрываем программу
  if not loginStatus then MainForm.Close;
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
var
  temp : users;
begin
// Загрузка всех пользователей
  temp.getAllUsers;
  loginStatus := false;
end;

procedure TfrmLogin.lblNewUserClick(Sender: TObject);
begin
  //frmLogin.Width := 378;
  frmLogin.Height := 121;

  btnCreateNewUser.Visible := true;
  edPasswordCheck.Visible := true;

  lblNewUser.Visible := false;
  btnEntre.Visible := false;

  btnCancel.Visible := true;

end;

end.
