unit IA_Program2;
interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, pngimage, ExtCtrls, StrUtils, Math, Buttons ;
type
  TForm1 = class(TForm)
    RTipo: TRadioGroup;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    GroupBox4: TGroupBox;
    Label4: TLabel;
    Label10: TLabel;
    LDrink: TLabel;
    LTotal: TLabel;
    LForte: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    LSuave: TLabel;
    LFraco: TLabel;
    Label18: TLabel;
    img: TImage;
    txt_rum: TEdit;
    txt_gelo: TEdit;
    txt_refri: TEdit;
    Label5: TLabel;
    LPaladar: TLabel;
    btn_help: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure RTipoClick(Sender: TObject);
    procedure txt_refriExit(Sender: TObject);
    procedure txt_rumExit(Sender: TObject);
    procedure txt_geloExit(Sender: TObject);
    procedure novoDrink();
    procedure Button1Click(Sender: TObject);
    procedure limpaVariaveis();
    procedure calculaPertinencias();
    procedure  calculaCocaCola();
    procedure  calculaPepsiCola();
    procedure  calculaRum();
    procedure  calculaGelo();
    function  calculaMinimo(a,b,c : double) : double;
    function calculaMaximo(a,b,c : double) : double;
    procedure calculaPaladar();
    procedure calculaTipoDrink();
    procedure atualizaPertinencias();
    procedure Button3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
  public
  end;
var
  Form1: TForm1;
  caminho : string;
  refri_fraco, refri_suave, refri_forte : double;
  rum_fraco, rum_suave, rum_forte : double;
  gelo_pertinencia : double;
  fraco, suave, forte : double;
implementation
uses Pertinencias;
{$R *.dfm}
procedure TForm1.FormCreate(Sender: TObject);
begin
 caminho:= ParamStr(0);
 caminho:=ExtractFilePath(caminho); //pegar caminho para exibir as imagens dinamicamente
end;
procedure TForm1.FormShow(Sender: TObject);
begin
  limpaVariaveis();
  novoDrink();
end;
procedure TForm1.RTipoClick(Sender: TObject);
begin
  if RTipo.ItemIndex = 0 then
    img.Picture.LoadFromFile(caminho + '\cocacola.png')
  else
    img.Picture.LoadFromFile(caminho + '\pepsiocola.png');
end;
procedure TForm1.txt_geloExit(Sender: TObject);
begin
  if txt_gelo.Text <> '' then
  begin
    if (pos('.', txt_gelo.text) > 0) or  (pos(',', txt_gelo.text) > 0) then
      txt_gelo.text := AnsiReplaceStr(txt_gelo.text, '.', ',')
    else if txt_gelo.text <> '' then
      txt_gelo.text := txt_gelo.text + ',00';
    try
      if (StrToFloat(txt_gelo.Text) >= 0) then
    except
      showmessage('Digite apenas numeros e acima de 0');
      txt_gelo.Text := '';
      txt_gelo.SetFocus;
    end;
  end;
end;
procedure TForm1.txt_refriExit(Sender: TObject);
begin
  if txt_refri.Text <> '' then
  begin
    if (pos('.', txt_refri.text) > 0) or  (pos(',', txt_refri.text) > 0) then
      txt_refri.text := AnsiReplaceStr(txt_refri.text, '.', ',')
    else if txt_refri.text <> '' then
      txt_refri.text := txt_refri.text + ',00';
    try
      if (StrToFloat(txt_refri.Text) >= 0) then
    except
      showmessage('Digite apenas numeros e acima de 0');
      txt_refri.Text := '';
      txt_refri.SetFocus;
    end;
  end;
end;
procedure TForm1.txt_rumExit(Sender: TObject);
begin
  if txt_rum.Text <> '' then
  begin
    if (pos('.', txt_rum.text) > 0) or  (pos(',', txt_rum.text) > 0) then
      txt_rum.text := AnsiReplaceStr(txt_rum.text, '.', ',')
    else if txt_rum.Text <> '' then
      txt_rum.text := txt_rum.text + ',00';
    try
      if (StrToFloat(txt_rum.Text) >= 0) then
    except
      showmessage('Digite apenas numeros e acima de 0');
      txt_rum.Text := '';
      txt_rum.SetFocus;
    end;
  end;
end;
procedure TForm1.atualizaPertinencias();
begin
  Form2.LFracoCoca.Caption :=  FloatToStr(refri_fraco);
  Form2.LSuaveCoca.Caption :=  FloatToStr(refri_suave);
  Form2.LForteCoca.Caption :=  FloatToStr(refri_forte);
  Form2.LFracoRum.Caption :=  FloatToStr(rum_fraco);
  Form2.LSuaveRum.Caption :=  FloatToStr(rum_suave);
  Form2.LForteRum.Caption :=  FloatToStr(rum_forte);
  Form2.LGelo.Caption :=  FloatToStr(gelo_pertinencia);
end;
procedure TForm1.Button2Click(Sender: TObject);
begin
  novoDrink();
end;
procedure TForm1.Button3Click(Sender: TObject);
begin
  Form2.Show;
end;
procedure  TForm1.novoDrink();
begin
  txt_refri.text := '';
  txt_rum.text := '';
  txt_gelo.text := '';
  Rtipo.itemindex := 0;
  img.Picture.LoadFromFile(caminho + '\cocacola.png');
  btn_help.Glyph.LoadFromFile(caminho + '\help.bmp');
  LFraco.caption := '';
  LSuave.caption := '';
  LForte.caption := '';
  LPaladar.Caption := '';
  LDrink.caption := '';
  LTotal.caption := '';
  limpaVariaveis();
end;

//====================================  INICIO PROCESSAMENTO ====================================

procedure TForm1.Button1Click(Sender: TObject);
begin
  if (txt_gelo.Text <> '') and (txt_refri.Text <> '') and (txt_rum.Text <> '') then
  begin
    limpaVariaveis();
    calculaPertinencias();
    calculaPaladar();
    calculaTipoDrink();
  end
  else
    ShowMessage('Preencha todas as quantidades!');
end;

procedure TForm1.limpaVariaveis();
begin
  refri_fraco := 0;
  refri_suave := 0;
  refri_forte := 0;
  rum_fraco := 0;
  rum_suave := 0;
  rum_forte := 0;
  gelo_pertinencia := 0;
  fraco := 0;
  suave := 0;
  forte := 0;
  atualizaPertinencias();
end;

//CALCULA PERTINENCIAS
procedure TForm1.calculaPertinencias();
begin

  if RTipo.ItemIndex = 0 then
    calculaCocaCola()
  else
    calculaPepsiCola();
   calculaRum();
   calculaGelo();
   atualizaPertinencias();
end;

procedure TForm1.calculaCocaCola();
var
  refri : double;
begin
  refri := StrToFloat(txt_refri.Text);

// Calcula fraco
  if refri < 56  then
    refri_fraco := 0
  else if (58 < refri) and (refri <= 60) then
    refri_fraco := 1
  else if (56 <= refri) and (refri <= 58) then
    refri_fraco := (refri - 56) / (58-56)
  else if refri > 60 then
    refri_fraco := 0;

//Calcula suave
  if (refri  < 52) then
    refri_suave := 0
  else if (52 <= refri) and (refri <= 54) then
    refri_suave := (refri - 52 ) / (54-52)
  else if (54 < refri) and (refri < 56) then
    refri_suave := 1
  else if (56 <= refri) and (refri <= 58) then
    refri_suave :=  (58-refri)/(58-56)
  else if refri > 58 then
    refri_suave := 0;

//Calcula Forte
  if refri < 50 then
    refri_forte := 0
  else if (50 <= refri) and (refri < 52) then
    refri_forte := 1
  else if (52 <= refri) and (refri <= 54) then
    refri_forte := (54-refri)/(54-52)
  else if refri > 54 then
    refri_forte := 0;
end;

procedure TForm1.calculaPepsiCola();
var
  refri : double;
begin
  refri := StrToFloat(txt_refri.Text);

// Calcula fraco
  if refri < 66  then
    refri_fraco := 0
  else if (68 < refri) and (refri <= 70) then
    refri_fraco := 1
  else if (66 <= refri) and (refri <= 68) then
    refri_fraco := (refri - 66) / (68-66)
  else if refri > 70 then
    refri_fraco := 0;

//Calcula suave
  if (refri  < 62) then
    refri_suave := 0
  else if (62 <= refri) and (refri <= 64) then
    refri_suave := (refri - 62 ) / (64-62)
  else if (64 < refri) and (refri < 66) then
    refri_suave := 1
  else if (66 <= refri) and (refri <= 68) then
    refri_suave :=  (68-refri)/(68-66)
  else if refri > 68 then
    refri_suave := 0;

//Calcula Forte
  if refri < 60 then
    refri_forte := 0
  else if (60 <= refri) and (refri < 62) then
    refri_forte := 1
  else if (62 <= refri) and (refri <= 64) then
    refri_forte := (64 - refri) / (64-62)
  else if refri > 64 then
    refri_forte := 0;
end;

procedure TForm1.calculaRum();
var
  rum : double;
begin
  rum := StrToFloat(txt_rum.Text);

//Calcula fraco
  if rum < 10 then
    rum_fraco := 0
  else if (10 <= rum) and (rum < 15) then
    rum_fraco :=  1
  else if (15 <= rum) and (rum <= 20) then
    rum_fraco := (20 - rum) / (20-15)
  else if rum > 20 then
    rum_fraco := 0;

//Calcula Suave
  if rum  < 15 then
    rum_suave := 0
  else if (15 <= rum) and (rum <= 20) then
    rum_suave := (rum - 15) / (20-15)
  else if (20 < rum) and (rum < 25) then
    rum_suave := 1
  else if (25 <= rum) and (rum <= 27) then
    rum_suave := (27 - rum) / (27-25)
  else if rum > 27 then
    rum_suave := 0;

//Calcula forte
  if (rum  < 23) then
    rum_forte := 0
  else if (28 < rum) and (rum <= 30) then
    rum_forte := 1
  else if (23 <= rum) and (rum <= 28) then
    rum_forte := (rum - 23) / (28-23)
  else if rum > 30 then
    rum_forte := 0;
end;

procedure TForm1.calculaGelo();
var
  gelo : double;
begin
  gelo := StrToFloat(txt_gelo.Text);

  if gelo = 20 then
    gelo_pertinencia := 1
  else
    gelo_pertinencia := 0;
end;


//FUNÇÕES AUXILIARES
function TForm1.calculaMinimo(a,b,c : double) : double;
var
min : double;
begin
  min := a;
  if min > b then
    min := b;
  if min > c then
    min := c;

  result := min;
end;

function TForm1.calculaMaximo(a,b,c : double) : double;
var
max : double;
begin
  max := a;
  if max < b then
    max := b;
  if max < c then
    max := c;

  result := max;
end;

procedure TForm1.calculaPaladar();
begin

  fraco := calculaMaximo( calculaMinimo(refri_fraco, rum_fraco, gelo_pertinencia),
                          calculaMinimo(refri_fraco, rum_suave, gelo_pertinencia),
                          calculaMinimo(refri_suave, rum_fraco, gelo_pertinencia));

  suave := calculaMaximo( calculaMinimo(refri_forte, rum_fraco, gelo_pertinencia),
                          calculaMinimo(refri_suave, rum_suave, gelo_pertinencia),
                          calculaMinimo(refri_fraco, rum_forte, gelo_pertinencia));

  forte := calculaMaximo( calculaMinimo(refri_forte, rum_suave, gelo_pertinencia),
                          calculaMinimo(refri_forte, rum_forte, gelo_pertinencia),
                          calculaMinimo(refri_suave, rum_forte, gelo_pertinencia));

  LFraco.Caption := FloatToStr(fraco);
  LSuave.Caption := FloatToStr(suave);
  LForte.Caption := FloatToStr(forte);
end;

procedure TForm1.calculaTipoDrink();
var
aux : double;
begin
  aux := calculaMaximo(fraco, forte, suave);
  LPaladar.Caption := FloatToStr(aux);
  if (aux =  0) then
  begin
    LDrink.caption := 'Não é Cuba Livre';
    LTotal.caption := '';
    img.Picture.LoadFromFile(caminho + '\cubalivrefail.png');
  end
  else if (forte = aux) then
  begin
    LDrink.caption := 'Cuba Livre Forte';
    LTotal.caption := '25 R$';
    img.Picture.LoadFromFile(caminho + '\cubalivre.png');
  end
  else if (aux = suave) then
  begin
    LDrink.caption := 'Cuba Livre Suave';
    LTotal.caption := '20 R$';
    img.Picture.LoadFromFile(caminho + '\cubalivre.png');
  end
  else if (fraco = aux) then
  begin
    LDrink.caption := 'Cuba Livre Fraco';
    LTotal.caption := '15 R$';
    img.Picture.LoadFromFile(caminho + '\cubalivre.png');
  end;
end;
end.
