unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.IniFiles, System.Types, System.IOUtils,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.jpeg, PicShow;

type
  TfrmAnimateImage = class(TForm)
    tmrShow: TTimer;
    img1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmrShowTimer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FImgAnimateShow: TPicShow;
    FintIndex      : Integer;
    FlstFiles      : TStringList;
    procedure AnimateImage; overload;
    procedure AnimateImage(const strPath: string); overload;
  end;

var
  frmAnimateImage: TfrmAnimateImage;

implementation

{$R *.dfm}

procedure TfrmAnimateImage.FormCreate(Sender: TObject);
begin
  BorderStyle              := bsNone;
  WindowState              := wsMaximized;
  FintIndex                := -1;
  FlstFiles                := TStringList.Create;
  FImgAnimateShow          := TPicShow.Create(frmAnimateImage);
  FImgAnimateShow.Parent   := frmAnimateImage;
  FImgAnimateShow.Align    := alClient;
  FImgAnimateShow.Stretch  := True;
  FImgAnimateShow.Threaded := True;
  FImgAnimateShow.Delay    := 30;
  FImgAnimateShow.BgMode   := bmCentered;
  FImgAnimateShow.BgPicture.Assign(img1.Picture);
  FImgAnimateShow.Visible := True;

  AnimateImage;
end;

procedure TfrmAnimateImage.FormDestroy(Sender: TObject);
begin
  tmrShow.Enabled := False;
  FlstFiles.Free;
  FImgAnimateShow.Free;
end;

procedure TfrmAnimateImage.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    with TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini')) do
    begin
      WriteInteger('Config', 'Index', FintIndex);
      Free;
    end;
    Close;
  end;
end;

procedure TfrmAnimateImage.AnimateImage;
var
  strIniFileName: String;
  strImagePath  : String;
begin
  strIniFileName := ChangeFileExt(ParamStr(0), '.ini');
  if FileExists(strIniFileName) then
  begin
    with TIniFile.Create(strIniFileName) do
    begin
      strImagePath := ReadString('Config', 'Directory', '');
      Free;
    end;
    if Trim(strImagePath) = '' then
    begin
      strImagePath := ExtractFilePath(ParamStr(0));
    end;
  end
  else
  begin
    strImagePath := ExtractFilePath(ParamStr(0));
  end;

  if (Trim(strImagePath) <> '') and DirectoryExists(strImagePath) then
  begin
    AnimateImage(strImagePath);
  end;
end;

procedure TfrmAnimateImage.AnimateImage(const strPath: string);
var
  strFiles: TStringDynArray;
  strFile : String;
begin
  strFiles := TDirectory.GetFiles(strPath, '*.jpg', TSearchOption.soAllDirectories);
  if Length(strFiles) <= 0 then
    Exit;

  for strFile in strFiles do
  begin
    FlstFiles.Add(strFile);
  end;

  with TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini')) do
  begin
    FintIndex := ReadInteger('Config', 'Index', 0);
    if FintIndex >= FlstFiles.Count then
      FintIndex := 0;
    Free;
  end;

  tmrShow.Enabled := True;
end;

procedure TfrmAnimateImage.tmrShowTimer(Sender: TObject);
begin
  Inc(FintIndex);
  if FintIndex >= FlstFiles.Count then
    FintIndex := 0;

  FImgAnimateShow.Style := Random(170);
  FImgAnimateShow.Picture.LoadFromFile(FlstFiles[FintIndex]);
  FImgAnimateShow.Execute;
end;

end.
