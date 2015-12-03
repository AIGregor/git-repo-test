unit clTasks;
// КЛАСС - Задачи

interface

type
  task = class
    public
    id_user : integer;
    id_project : integer;
    id_tasks : integer;
    name : string;
    task_aim : string;
    creationDate : TDate;
    description : string;
    function getNameProjectByID_project(id_tasks : integer) : string;
  end;

var
  all_ProjectTasts : array of task;
  selected_task : integer;

implementation

function task.getNameProjectByID_project(id_tasks : integer) : string;
var
  i : integer;
begin
  for I := 0 to length(all_ProjectTasts)-1 do
    begin
      if all_ProjectTasts[i].id_tasks = id_tasks then
        begin
          Result := all_ProjectTasts[i].name;
        end;
    end;
end;

end.
