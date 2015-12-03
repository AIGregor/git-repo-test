unit glbVar;
// глобальные переменные
interface

const
  sqlConnection_remotehost : AnsiString  =
  'Provider=MSDASQL.1;Password=#5#b8Q*ne6wM@kbd*x$v;Persist Security Info=True;User ID=ci53070_unionpro;Extended ' +
  'Properties="Driver=MySQL ODBC 5.2 Unicode Driver;SERVER=92.53.123.104;UID=ci53070_unionpro;PWD={#5#b8Q*ne6wM@kbd*x$v};' +
  'DATABASE=ci53070_unionpro;PORT=3306;COLUMN_SIZE_S32=1"';

  sqlConnection_localhost : AnsiString  =
  'Provider=MSDASQL.1;Password=#5#b8Q*ne6wM@kbd*x$v;Persist Security Info=True;'+
  'User ID=ci53070_unionpro;Extended Properties="Driver=MySQL ODBC 5.2 Unicode Driver;'+
  'SERVER=85.10.205.173;UID=ci53070_unionpro;PWD={#5#b8Q*ne6wM@kbd*x$v};PORT=3306;'+
  'COLUMN_SIZE_S32=1";Initial Catalog=ci53070_unionpro';

var
  currentUSER_ID    : integer;
  currentPROJECT_ID : INTEGER;
  currentTASK_ID    : INTEGER;
  currentRECORD_ID  : INTEGER;

  currentTypeConnection : boolean; // 0 - localhost / 1 - remotehost

  rootDir           : string;
  blDeleteFileAfterCopy : Boolean;
  sourceDisk        : string;

implementation



end.
