unit clRecords;

interface
  type
    Records = class
      id_records : integer;
      id_tasks : integer;
      id_project : integer;
      id_user : integer;
      Content : string;
      Conclusion : string;
      creationDate : TDate;
    end;

var
  all_records : array of records;
  selected_record : integer;

implementation

end.
