unit clProjects;

interface
// http://rsdn.ru/article/opengl/layeredopengl.xml
// http://www.opengl-tutorial.org/
type
  project = class
  public
    id_project : integer;
    id_user : integer;
    name : string;
    creationDate : TDate;
    description : string;
    function getIndexProjectByID_project(id_project : integer) : integer;
    function getNameProjectByID_project(id_project : integer) : string;
  end;

var
  all_project : array of project;
  selectedProject : integer;

implementation

function project.getIndexProjectByID_project(id_project : integer) : integer;
var
  i : integer;
begin
  for I := 0 to length(all_project)-1 do
    begin
      if all_project[i].id_project = id_project then
        begin
          Result := i;
        end;
    end;
end;

function project.getNameProjectByID_project(id_project : integer) : string;
var
  i : integer;
begin
  for I := 0 to length(all_project)-1 do
    begin
      if all_project[i].id_project = id_project then
        begin
          Result := all_project[i].name;
        end;
    end;
end;

end.
