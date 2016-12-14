unit FMX.JSON2Record;

{
  author: ZuBy
  email : rzaripov1990@gmail.com

  http://blog.rzaripov.kz
  https://github.com/rzaripov1990
}

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections,
  XSuperObject, XSuperJSON;

type
  TmyTypeJSONObj = TDictionary<string, ISuperObject>;
  TmyTypeRecordString = TDictionary<string, string>;

  TmyJSON2Record = record
  private
    class var FFoundObjs: TStringList;
    class var FArrays: TStringList;
    class var FObjects: TmyTypeJSONObj;
    class var FOutText: TmyTypeRecordString;
    class var FErrorText: string;
    class procedure EnumObj(const aValue: ISuperObject); static;
    class procedure EnumFields(const aKey: string; const aValue: ISuperObject); static;
  public
    class function GetFoundObjectsList: string; static;
    class function GetLastError: string; static;
    class function Generate(const aJSON: string): string; static;
    class function JSONView(const aJSON: string): string; static;
  end;

implementation

const
  TypeToField: array [TDataType] of string = ('nil', 'null', 'TObject', 'TArray', 'string', 'integer', 'float',
    'boolean', 'string', 'string', 'string');

  cSign = 'Record';
  cIndent = '  ';
  cRecordBegin = 'TmyTypeRecord = record';
  cRecordSub = 'TmyType%s = record';
  cRecordEnd = 'end;';
  cRecordField = cIndent + '%s: %s;';
  cFindObj = cIndent + '%s: TObject;';
  cFindArr = cIndent + '%s: TArray;';
  cReplaceObj = cIndent + '%s: TmyType%s;';
  cReplaceArr = cIndent + '%s: TArray<TmyType%s>;';

  { TmyJSON2Record }

class procedure TmyJSON2Record.EnumFields(const aKey: string; const aValue: ISuperObject);
var
  LEnum: TSuperEnumerator<IJSONPair>;
  LKey, LKeyUp: string;
begin
  if (aValue.DataType = TDataType.dtNull) or (aValue.DataType = TDataType.dtNil) or (aValue = nil) then
    exit;

  LKey := aKey;

  LKeyUp := LKey;
  LKeyUp[Low(string)] := AnsiUppercase(LKey)[low(string)];
  TmyJSON2Record.FOutText.AddOrSetValue(LKey, Format(cRecordSub, [LKeyUp]));
  LEnum := aValue.GetEnumerator;
  while LEnum.MoveNext do
  begin
    if (LEnum.GetCurrent.DataType = TDataType.dtNull) or (LEnum.GetCurrent.DataType = TDataType.dtNil) then
      Continue;
    TmyJSON2Record.FOutText.AddOrSetValue(LKey, TmyJSON2Record.FOutText.Items[LKey] + sLineBreak + Format(cRecordField,
      [LEnum.GetCurrent.Name, TypeToField[LEnum.GetCurrent.DataType]]));
  end;
  TmyJSON2Record.FOutText.AddOrSetValue(LKey, TmyJSON2Record.FOutText.Items[LKey] + sLineBreak + Format(cRecordEnd,
    [LKey]) + sLineBreak + sLineBreak);
end;

class procedure TmyJSON2Record.EnumObj(const aValue: ISuperObject);
var
  LEnum: TSuperEnumerator<IJSONPair>;
  J: integer;
begin
  LEnum := aValue.GetEnumerator;
  while LEnum.MoveNext do
  begin
    if LEnum.GetCurrent.DataType = TDataType.dtObject then
    begin
      TmyJSON2Record.FObjects.AddOrSetValue(LEnum.GetCurrent.Name, LEnum.GetCurrent.AsObject);
      TmyJSON2Record.EnumObj(LEnum.GetCurrent.AsObject);
    end
    else if LEnum.GetCurrent.DataType = TDataType.dtArray then
    begin
      TmyJSON2Record.FArrays.Add(LEnum.GetCurrent.Name);
      with LEnum.GetCurrent.AsArray do
      begin
        for J := 0 to Length - 1 do
        begin
          if O[J].DataType = TDataType.dtObject then
          begin
            TmyJSON2Record.EnumFields(LEnum.GetCurrent.Name, O[J]);
            TmyJSON2Record.EnumObj(O[J]);
          end
          else
            TmyJSON2Record.EnumFields(LEnum.GetCurrent.Name, O[J]);
        end;
      end;
    end;
  end;
end;

class function TmyJSON2Record.Generate(const aJSON: string): string;
var
  LObj: ISuperObject;
  LKey, LKeyUp: string;
  LValue: string;
  I: integer;
begin
  Result := '';
  TmyJSON2Record.FArrays.Clear;
  TmyJSON2Record.FOutText.Clear;
  TmyJSON2Record.FObjects.Clear;
  TmyJSON2Record.FFoundObjs.Clear;
  TmyJSON2Record.FErrorText := 'OK';

  if aJSON.IsEmpty then
  begin
    TmyJSON2Record.FErrorText := '(empty)';
    exit;
  end;

  try
    LObj := SO(aJSON);
  except
    TmyJSON2Record.FErrorText := 'INVALID JSON';
    exit;
  end;

  try
    TmyJSON2Record.EnumObj(LObj);
    TmyJSON2Record.EnumFields(cSign, LObj);

    for LKey in TmyJSON2Record.FObjects.Keys do
    begin
      if LKey.IsEmpty then
        Continue;
      TmyJSON2Record.FFoundObjs.Add(LKey);
      EnumFields(LKey, TmyJSON2Record.FObjects.Items[LKey]);
      TmyJSON2Record.FObjects.Remove(LKey);
    end;

    LValue := '';
    for LKey in TmyJSON2Record.FOutText.Keys do
    begin
      if LKey <> cSign then
        LValue := LValue + TmyJSON2Record.FOutText.Items[LKey];
    end;
    LValue := LValue + TmyJSON2Record.FOutText.Items[cSign];

    for LKey in TmyJSON2Record.FOutText.Keys do
    begin
      LKeyUp := LKey;
      LKeyUp[Low(string)] := AnsiUppercase(LKey)[low(string)];
      LValue := StringReplace(LValue, Format(cFindObj, [LKey]), Format(cReplaceObj, [LKey, LKeyUp]), []);
    end;

    for I := 0 to TmyJSON2Record.FArrays.Count - 1 do
    begin
      LKey := TmyJSON2Record.FArrays.Strings[I];
      LKeyUp := LKey;
      LKeyUp[Low(string)] := AnsiUppercase(LKey)[low(string)];
      LValue := StringReplace(LValue, Format(cFindArr, [LKey]), Format(cReplaceArr, [LKey, LKeyUp]), []);
    end;
    TmyJSON2Record.FArrays.Clear;
    TmyJSON2Record.FOutText.Clear;
    TmyJSON2Record.FObjects.Clear;

    Result := Trim(LValue);
  except
    TmyJSON2Record.FErrorText := 'JSON contains unsupported data';
  end;
end;

class function TmyJSON2Record.GetFoundObjectsList: string;
begin
  Result := TmyJSON2Record.FFoundObjs.Text;
end;

class function TmyJSON2Record.GetLastError: string;
begin
  Result := TmyJSON2Record.FErrorText;
end;

class function TmyJSON2Record.JSONView(const aJSON: string): string;
begin
  try
    Result := SO(aJSON).AsJSON(True);
  except
    Result := '';
  end;
end;

initialization

TmyJSON2Record.FErrorText := 'OK';
TmyJSON2Record.FArrays := TStringList.Create;
TmyJSON2Record.FOutText := TmyTypeRecordString.Create;
TmyJSON2Record.FObjects := TmyTypeJSONObj.Create;
TmyJSON2Record.FFoundObjs := TStringList.Create;

finalization

TmyJSON2Record.FArrays.Free;
TmyJSON2Record.FOutText.Free;
TmyJSON2Record.FObjects.Free;
TmyJSON2Record.FFoundObjs.Free;

end.
