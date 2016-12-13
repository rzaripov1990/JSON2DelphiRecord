unit uMain;

{
  author: ZuBy
  email : rzaripov1990@gmail.com

  http://blog.rzaripov.kz
  https://github.com/rzaripov1990
}
interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Layouts;

type
  TFormMain = class(TForm)
    mJSON: TMemo;
    Rectangle1: TRectangle;
    mRecord: TMemo;
    Splitter1: TSplitter;
    lbTitle: TLabel;
    Layout1: TLayout;
    Layout2: TLayout;
    Splitter2: TSplitter;
    mJSONView: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    sbSourceClear: TSpeedButton;
    sbRunView: TSpeedButton;
    mLog: TMemo;
    Splitter3: TSplitter;
    sbCopy: TSpeedButton;
    procedure sbSourceClearClick(Sender: TObject);
    procedure sbRunViewClick(Sender: TObject);
    procedure sbCopyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.fmx}

uses
  FMX.JSON2Record;

procedure TFormMain.sbCopyClick(Sender: TObject);
begin
  mRecord.SelectAll;
  mRecord.CopyToClipboard;
end;

procedure TFormMain.sbRunViewClick(Sender: TObject);
begin;
  mJSONView.Text := TmyJSON2Record.JSONView(mJSON.Text);
  mRecord.Text := TmyJSON2Record.Generate(mJSON.Text);
  mLog.Text := TmyJSON2Record.GetLastError + sLineBreak + 'objects:' + TmyJSON2Record.GetFoundObjectsList;
end;

procedure TFormMain.sbSourceClearClick(Sender: TObject);
begin
  mJSON.Lines.Clear;
  mJSONView.Lines.Clear;
end;

initialization

FormatSettings.DecimalSeparator := '.';

end.
