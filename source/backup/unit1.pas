unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  Menus, SynHighlighterXML, SynEdit, IdHTTP, IdSSLOpenSSL;

type

  { TForm1 }

  TForm1 = class(TForm)
    ClearResponseButton: TButton;
    ClearRequestButton: TButton;
    CharsetBox: TComboBox;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    Label5: TLabel;
    SaveButton: TButton;
    Label4: TLabel;
    ResponseMemo: TMemo;
    SendButton: TButton;
    LoadButton: TButton;
    Label2: TLabel;
    Label3: TLabel;
    HeadersMemo: TMemo;
    RequestMemo: TMemo;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    StatusBar1: TStatusBar;
    URLEdit: TEdit;
    IdHTTP1: TIdHTTP;
    Label1: TLabel;
    procedure ClearRequestButtonClick(Sender: TObject);
    procedure ClearResponseButtonClick(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of string);
    procedure LoadButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure SendButtonClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }


procedure TForm1.FormCreate(Sender: TObject);
begin
end;

procedure TForm1.SaveButtonClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
  ResponseMemo.Lines.SaveToFile(SaveDialog1.FileName);
end;

procedure TForm1.SendButtonClick(Sender: TObject);
var
  query: TStringList;
  RS, PD: TStringStream;
  response: string;
  i: integer;
begin
  query:= TStringList.Create;
  RS := TStringStream.Create('', TEncoding.UTF8);
  StatusBar1.Panels.Items[0].Text := 'Sending...';
  if HeadersMemo.Lines.Count > 0 then
     for i:=1 to HeadersMemo.Lines.Count do
     begin
       IdHTTP1.Request.CustomHeaders.Add(HeadersMemo.Lines[i]);
     end;
  PD := TStringStream.Create(RequestMemo.Lines.Text, TEncoding.UTF8);
  try
  try
    IdHTTP1.Post(URLEdit.Text, PD, RS);
    response := RS.DataString;
    ResponseMemo.Lines.Text:=response;
    StatusBar1.Panels.Items[0].Text := 'Idle. Code' + #13#10 + IntToStr(IdHTTP1.ResponseCode);
  except
    on E: Exception do
      StatusBar1.Panels.Items[0].Text:='Exception: ' + E.ClassName + #13#10 + E.Message;

  end;
  finally
    query.Free;
    PD.Free;
    RS.Free;
    IdHTTP1.Request.CustomHeaders.Clear;
  end;

end;

procedure TForm1.LoadButtonClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
     RequestMemo.Lines.LoadFromFile(OpenDialog1.FileName);
end;

procedure TForm1.FormDropFiles(Sender: TObject; const FileNames: array of string
  );
begin
  RequestMemo.Lines.LoadFromFile(FileNames[0]);
end;


procedure TForm1.ClearRequestButtonClick(Sender: TObject);
begin
  RequestMemo.Lines.Clear;
end;

procedure TForm1.ClearResponseButtonClick(Sender: TObject);
begin
  ResponseMemo.Lines.Clear;
end;

end.

