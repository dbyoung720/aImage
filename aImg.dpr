program aImg;
{$IF CompilerVersion >= 21.0}
{$WEAKLINKRTTI ON}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
{$IFEND}

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {frmAnimateImage};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmAnimateImage, frmAnimateImage);
  Application.Run;
end.
