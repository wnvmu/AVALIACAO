unit Pedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Data.SqlExpr, Data.DBXMySQL, Vcl.ExtCtrls, Data.FMTBcd,
  Vcl.ComCtrls, Datasnap.DBClient, Datasnap.Provider;

type
  TPedidoVendas = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    EdCodigo: TEdit;
    EdNome: TEdit;
    EdCidade: TEdit;
    CBUF: TComboBox;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    EdIten: TEdit;
    EdDescricao: TEdit;
    EdQuant: TEdit;
    Button1: TButton;
    Conn: TSQLConnection;
    Panel1: TPanel;
    BtPedido: TButton;
    BtCancelar: TButton;
    SalvarPedido: TButton;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    QueryTemp: TSQLQuery;
    DataSetProvider1: TDataSetProvider;
    ClientDataSet1: TClientDataSet;
    Edvunit: TEdit;
    EdTotal: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    GroupBox3: TGroupBox;
    LBSomatorio: TLabel;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    Panel2: TPanel;
    Label10: TLabel;
    Edit1: TEdit;
    Button2: TButton;
    Label11: TLabel;
    Edit2: TEdit;
    Button3: TButton;
    procedure BtPedidoClick(Sender: TObject);
    procedure BtCancelarClick(Sender: TObject);
    procedure SalvarPedidoClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure EdTotalKeyPress(Sender: TObject; var Key: Char);
    procedure EdvunitKeyPress(Sender: TObject; var Key: Char);
    procedure EdQuantKeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EdvunitExit(Sender: TObject);
    procedure EdTotalExit(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    Function  ImportarUF :TStrings;
    Procedure IniciarPedido;
    Procedure SalvarItens(Cod,Quant:Integer;Produto:String;ValorU,Total:Real);
    Procedure SalvarCliente(Nome,Cidade,UF:String);
    Procedure FinalizarPedido;
    Procedure Deletar_Temp;
    Procedure SomarTotal;
    Function GerarNumeroPedido:String;
    Function GerarCodProduto:Integer;
  public
    { Public declarations }
  end;

var
  PedidoVendas: TPedidoVendas;
  Somatorio : Real;
  Codigo_Cliente, ID_PRODUTO : Integer;
  VTOTAL, S2 : Real;
  Numero_Pedido, IDP : string;
  Loc_Pedido : Boolean;

implementation

{$R *.dfm}

{$REGION 'Função para buscar UF'}
function TPedidoVendas.ImportarUF: TStrings;
var ListUF : TSQLQuery;
begin
  Result := TStringList.Create;
  Result.Clear;
  Result.BeginUpdate;

  ListUF := TSQLQuery.Create(nil);
  ListUF.SQLConnection := Conn;
  ListUF.SQL.Clear;
  ListUF.SQL.Add('select * from estados');
  ListUF.Active := True;

  with ListUF do
    begin
      First;
      while not Eof do
        begin
          Result.Add(FieldByName('UF').AsString);
          Next;
        end;
    end;
  Result.EndUpdate;
end;
 {$ENDREGION}

{$REGION 'CANCELAR PEDIDO DE VENDA/EDIÇÃO'}
procedure TPedidoVendas.BtCancelarClick(Sender: TObject);
begin
FinalizarPedido;
BtPedido.Enabled      := True;
BtCancelar.Enabled    := False;
SalvarPedido.Enabled  := False;
Deletar_Temp;
ClientDataSet1.Refresh;

EdCodigo.Clear;
EdNome.Clear;
EdCidade.Clear;

ClientDataSet1.Close;
QueryTemp.SQL.Clear;
QueryTemp.SQL.Add('SELECT * FROM TEMP');

end;
{$ENDREGION}

{$REGION 'INICIAR PEDIDO DE VENDA'}
procedure TPedidoVendas.BtPedidoClick(Sender: TObject);
begin
IniciarPedido;
BtPedido.Enabled      := False;
BtCancelar.Enabled    := True;
SalvarPedido.Enabled  := True;
Deletar_Temp;
ClientDataSet1.Refresh;
LBSomatorio.Caption   := 'R$: 0,00';

 if EdNome.Text <> '' then
 begin
  EdNome.Enabled   := False;
  EdCidade.Enabled := False;
  EdDescricao.SetFocus;
 end
 Else
 Begin
  CBUF.Clear;
  EdNome.Enabled        := True;
  EdCidade.Enabled      := True;
  EdIten.Text           := IDP;
  EdCodigo.Text         := IntToStr(Codigo_Cliente);
  CBUF.Items            := ImportarUF;
  EdNome.SetFocus;
 End;
end;
{$ENDREGION}

{$REGION 'ADICIONAR/EDITAR ITENS AO DBGRID'}
procedure TPedidoVendas.Button1Click(Sender: TObject);
var Qry : TSQLQuery; Resultado : Real;
begin
 if Button1.Caption = 'Adicionar' then
   Begin
   SalvarItens(StrToInt(EdIten.Text),StrToInt(EdQuant.Text),EdDescricao.Text,StrToFloat(Edvunit.Text),StrToFloat(EdTotal.Text));
   EdIten.Clear;
   EdQuant.Clear;
   EdDescricao.Clear;
   EdTotal.Clear;
   Edvunit.Clear;
   SomarTotal;
   GerarCodProduto;
   EdIten.Text := IDP;
   End;

 if Button1.Caption = 'Editar' then
   Begin
    Qry := TSQLQuery.Create(nil);
     with Qry do
        begin
         SQLConnection := Conn;
         Close;
         SQL.Clear;
         SQL.Add('UPDATE temp SET qt = :qt, vu = :vu, vt = :vt where id = '+IntToStr(ID_PRODUTO));
         ParamByName('qt').AsInteger := StrToInt(EdQuant.Text);
         ParamByName('vu').AsFloat := StrToFloat(Edvunit.Text);
         ParamByName('vt').AsFloat := StrToFloat(EdTotal.Text);
         ExecSQL();
         Close;
         SQL.Clear;
         SQL.Add('SELECT CASE WHEN MAX( ID ) +1 IS NULL '+
                  'THEN 1 '+
                  'ELSE MAX( ID ) +1 '+
                  'END AS Cod '+
                  'FROM temp ');
         Open;
         EdIten.Text := FieldByName('Cod').Value;
         Close;

         ClientDataSet1.Refresh;
         Button1.Enabled := True;

         EdIten.Enabled       := False;
         EdDescricao.Enabled  := True;
         EdDescricao.Clear;
         EdQuant.Clear;
         Edvunit.Clear;
         EdTotal.Clear;
         SomarTotal;
         Application.ProcessMessages;
         Button1.Caption       := 'Adicionar';
        end;
   End;
   EdDescricao.SetFocus;
end;
 {$ENDREGION}

{$REGION 'BUSCAR PEDIDO DE VENDA'}
procedure TPedidoVendas.Button2Click(Sender: TObject);
var QryCliente : TSQLQuery;
begin
 try
   QryCliente := TSQLQuery.Create(nil);
   QueryTemp.Close;
   with QryCliente do
   Begin
    SQLConnection := Conn;
    Close;
    SQL.Clear;
    SQL.Add('select registrogeral.*, cliente.* from registrogeral, cliente where registrogeral.npedido = '+Edit1.Text);
    Open;
    EdCodigo.Text       := IntToStr(FieldByName('id').AsInteger);
    EdNome.Text         := FieldByName('nome').AsString;
    EdCidade.Text       := FieldByName('cidade').AsString;
    CBUF.Text           := FieldByName('estado').AsString;
    LBSomatorio.Caption := 'R$: '+ FormatFloat('0.##',FieldByName('total').AsFloat);
   End;

   with QueryTemp do
   Begin
    SQLConnection := Conn;
    ClientDataSet1.Active := False;
    Close;
    SQL.Clear;
    SQL.Add('select idc as id, descricao as nome, quantidade as qt, valorun as vu, valortotal as vt from produto where npedido = '+Edit1.Text);
    Active := True;
    ClientDataSet1.Active := True;
    if not IsEmpty then
      button3.Enabled := True
    Else
    Begin
      button3.Enabled := False;
      ShowMessage('Pedido não localizado!');
      Edit1.Clear;
    End;


   End;
   BtPedido.Enabled   := False;
   BtCancelar.Enabled := True;
 Except
   ShowMessage('Erro ao realizar busca, informar ao suporte tecnico!');
 end;
end;
{$ENDREGION}

{$REGION 'EXCLUIR VENDA REALIZADA'}
procedure TPedidoVendas.Button3Click(Sender: TObject);
var Qry : TSQLQuery;
begin
 IF Application.MessageBox('DESEJA Excluir esse pedido ?','ATENÇÃO',MB_YESNO + MB_ICONWARNING)=MRYES THEN
 Begin
  Try
   Qry := TSQLQuery.Create(nil);
   with Qry do
   Begin
     SQLConnection := Conn;
     Close;
     SQL.Clear;
     SQL.Add('DELETE FROM produto, registrogeral '+
             'USING registrogeral INNER JOIN produto '+
             'WHERE registrogeral.npedido = '+Edit1.Text);
     ExecSQL();
   End;
  Except
   ShowMessage('Impossivel excluir o pedido Nº '+Edit1.Text);
  End;

 End;
end;
{$ENDREGION}

procedure TPedidoVendas.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var Qry : TSQLQuery;
begin
  if key = VK_DELETE then
  begin
   IF Application.MessageBox('DESEJA Excluir esse registro ?','ATENÇÃO',MB_YESNO + MB_ICONWARNING)=MRYES THEN
    Begin
     Qry := TSQLQuery.Create(nil);
     ID_PRODUTO  := StrToInt(DBGrid1.Columns.Items[0].Field.Text);
     with Qry do
     Begin
       SQLConnection := Conn;
       Close;
       SQL.Clear;
       SQL.Text := 'delete from temp where id = '+IntToStr(ID_PRODUTO);
       ExecSQL();
       ClientDataSet1.Refresh;
       if QueryTemp.RecordCount = 0 then
         Begin
           LBSomatorio.Caption := 'R$: 0,00'
         End;
     End;
    end;
   end;

  if key = VK_RETURN then
  Begin
  IF Application.MessageBox('DESEJA alterar esse registro ?','ATENÇÃO',MB_YESNO + MB_ICONWARNING)=MRYES THEN
    Begin
     Button1.Caption := 'Editar';
     ID_PRODUTO           := StrToInt(DBGrid1.Columns.Items[0].Field.Text);
     EdIten.Text          := DBGrid1.Columns.Items[0].Field.Text;
     EdIten.Enabled       := False;
     EdDescricao.Text     := DBGrid1.Columns.Items[1].Field.Text;
     EdDescricao.Enabled  := False;
     EdQuant.Text         := DBGrid1.Columns.Items[2].Field.Text;
     Edvunit.Text         := DBGrid1.Columns.Items[3].Field.Text;
     EdTotal.Text         := DBGrid1.Columns.Items[4].Field.Text;
    End;
  End;
  SomarTotal;
end;

procedure TPedidoVendas.Deletar_Temp;
var Qry : TSQLQuery;
begin
 Qry := TSQLQuery.Create(nil);
 with Qry do
 Begin
   SQLConnection := Conn;
   Close;
   SQL.Clear;
   SQL.Text := 'delete from temp';
   ExecSQL();
 End;

end;

procedure TPedidoVendas.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
if not (key in ['0'..'9',#8]) then key :=#0;
end;

{$REGION 'REALIZAR BUSCA DE CLIENTE JÁ CADASTRADO'}
procedure TPedidoVendas.Edit2Change(Sender: TObject);
var Qry : TSQLQuery;
begin
 Qry := TSQLQuery.Create(nil);
 with Qry do
 Begin
   SQLConnection := Conn;
   Close;
   SQL.Clear;
   SQL.Add('SELECT * FROM cliente WHERE nome LIKE '+QuotedStr(Edit2.Text+'%'));
   Open;
   EdCodigo.Text := IntToStr(FieldByName('id').AsInteger);
   EdNome.Text   := FieldByName('nome').AsString;
   EdCidade.Text := FieldByName('cidade').AsString;
   CBUF.Text     := FieldByName('estado').AsString;
   Close;
 End;
end;
{$ENDREGION}

{$REGION 'SO PERMIT NUMERO'}
procedure TPedidoVendas.EdQuantKeyPress(Sender: TObject; var Key: Char);
begin
if not (key in ['0'..'9',#8]) then key :=#0;
end;
{$ENDREGION}

procedure TPedidoVendas.EdTotalExit(Sender: TObject);
begin
S2 := StrToFloat(EdTotal.Text);
end;

procedure TPedidoVendas.EdTotalKeyPress(Sender: TObject; var Key: Char);
begin
if not (key in ['0'..'9',',',#8]) then key :=#0;
end;

procedure TPedidoVendas.EdvunitExit(Sender: TObject);
var Soma : Real;
begin
  if EdQuant.Text = '' then
  begin

  end
  Else
  Soma := StrToFloat(Edvunit.Text)*StrToFloat(EdQuant.Text);
  EdTotal.Text := FloatToStr(Soma);

end;

procedure TPedidoVendas.EdvunitKeyPress(Sender: TObject; var Key: Char);
begin
if not (key in ['0'..'9',',',#8]) then key :=#0;
end;

procedure TPedidoVendas.FinalizarPedido;
var I : Integer;
begin
  CBUF.Enabled     := False;
  Button1.Enabled  := False;
end;

procedure TPedidoVendas.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
Deletar_Temp;
end;

{$REGION 'GERAR CÓDIGO DO PRODUTO'}
function TPedidoVendas.GerarCodProduto: Integer;
var Qry : TSQLQuery; somar : Integer;
begin
 Qry := TSQLQuery.Create(nil);
   with Qry do
   begin
   SQLConnection := Conn;
   Close;
   SQL.Clear;
   SQL.Add('SELECT PRODUTO FROM NUMERO');
   Open;
   somar := StrToInt(FieldByName('PRODUTO').AsString) + 1;
   IDP := IntToStr(somar);

    if (IDP = '0') or (FieldByName('PRODUTO').IsNull) Then
    begin
       Close;
       SQL.Clear;
       SQL.Add('INSERT INTO NUMERO (PRODUTO) VALUES (1)');
       ExecSQL;
    end
    Else
    Begin
       Close;
       SQL.Clear;
       SQL.Add('UPDATE NUMERO SET PRODUTO = '+IntToStr(somar));
       ExecSQL;
    End;

   close;
   end;
end;
{$ENDREGION}

{$REGION 'GERAR NUMERO DO PEDIDO'}
function TPedidoVendas.GerarNumeroPedido: String;
var qry : TSQLQuery; Resultado : string; somarnum : Integer;
begin
 qry := TSQLQuery.Create(nil);
 with qry do
 begin
   SQLConnection := Conn;
   Close;
   SQL.Clear;
   SQL.Add('SELECT * FROM npedido');
   Open;
   Resultado := FieldByName('n').AsString;

   if (FieldByName('n').AsString = '0') or (FieldByName('n').IsNull) then
   begin
     GerarNumeroPedido := '1';
     Close;
     SQL.Clear;
     SQL.Add('INSERT INTO npedido (n) VALUES (1)');
     ExecSQL();
   end
   else
   Begin
     somarnum := StrToInt(Resultado) + 1;
     GerarNumeroPedido := IntToStr(somarnum);
     Close;
     SQL.Clear;
     SQL.Add('UPDATE npedido SET n = '+IntToStr(somarnum)+'');
     ExecSQL();
   End;
   Close;
 end;
end;
{$ENDREGION}

{$REGION 'SALVAR PEDIDO DE VENDA'}
procedure TPedidoVendas.SalvarPedidoClick(Sender: TObject);
var I : Integer;
begin
SalvarCliente(EdNome.Text, EdCidade.Text, CBUF.Text);
IniciarPedido;
CBUF.Items            := ImportarUF;
BtPedido.Enabled      := True;
BtCancelar.Enabled    := False;
SalvarPedido.Enabled  := False;
Deletar_Temp;
ClientDataSet1.Refresh;
EdIten.Text           := IDP;
EdCodigo.Text         := IntToStr(Codigo_Cliente);
LBSomatorio.Caption   := 'R$: 0,00';
CBUF.Enabled          := False;
Button1.Enabled       := False;
end;
{$ENDREGION}

{$REGION 'SOMAR VALOR TOTAL DA VENDA'}
procedure TPedidoVendas.SomarTotal;
var SM : TSQLQuery;
begin
 SM := TSQLQuery.Create(nil);
 with SM do
 Begin
   SQLConnection        := Conn;
   Close;
   SQL.Clear;
   SQL.Text             := 'SELECT SUM(vt) AS TOTAL FROM temp';
   Open;
   LBSomatorio.Caption  := 'R$: '+ FormatFloat('0.##',FieldByName('TOTAL').AsFloat);
   VTOTAL               := FieldByName('TOTAL').AsFloat;
   Close;
 End;
 {$ENDREGION}



end;

procedure TPedidoVendas.Timer1Timer(Sender: TObject);
begin
StatusBar1.Panels[1].Text := FormatDateTime('dd/mm/YYYY', Date);
StatusBar1.Panels[3].Text := FormatDateTime('hh:mm:ss', Time);
end;

{$REGION 'INICIAR PEDIDO DE VENDA'}
procedure TPedidoVendas.IniciarPedido;
var I : Integer; CodCliente : TSQLQuery;
begin
  EdCodigo.Enabled    := False;
  EdNome.Enabled      := True;
  EdCidade.Enabled    := True;
  CBUF.Enabled        := True;
  Button1.Enabled     := True;
  EdDescricao.Enabled := True;
  EdQuant.Enabled     := True;
  Edvunit.Enabled     := True;
  EdTotal.Enabled     := True;
  ClientDataSet1.Open;

  Try
  Conn.Connected := True;

    CodCliente := TSQLQuery.Create(nil);
    with CodCliente do
    Begin
      SQLConnection := Conn;
      Close;
      SQL.Clear;
      SQL.Add('SELECT CASE WHEN MAX( ID ) +1 IS NULL '+
              'THEN 1 '+
              'ELSE MAX( ID ) +1 '+
              'END AS Cod '+
              'FROM cliente ');
      Open;
      Codigo_Cliente := FieldByName('Cod').Value;
    End;
    GerarCodProduto;
  Except
   ShowMessage('Não foi possivel conectar ao banco de dados!');
  End;
end;
{$ENDREGION}

{$REGION 'SALVAR CLIENTE NO BANCO DE DADOS'}
procedure TPedidoVendas.SalvarCliente(Nome, Cidade, UF: String);
var Query : TSQLQuery;
begin
 Try
  Numero_Pedido := GerarNumeroPedido;
  Query := TSQLQuery.Create(Self);
  Query.SQLConnection := Conn;
  With Query do
  Begin

    Close;
    SQL.Clear;
    SQL.Text := 'SELECT * FROM cliente WHERE id ='+EdCodigo.Text;
    Open;

    if not IsEmpty then
    Begin

    End
    Else
    begin
    Close;
    SQL.Clear;
    SQL.Text := 'INSERT INTO cliente (id, nome, cidade, estado) VALUES (NULL, '+QuotedStr(Nome)+', '+QuotedStr(Cidade)+', '+QuotedStr(UF)+')';
    ExecSQL();
    end;

    Close;
    SQL.Clear;
    SQL.Add('INSERT INTO registroGeral '+
    '(id, npedido, data, cliente, total'+
    ') VALUES (NULL, :npedido, :data, :cliente, :valor)');
    ParamByName('npedido').AsString   := Numero_Pedido;
    ParamByName('data').AsDate        := Date;
    ParamByName('cliente').AsInteger  := StrToInt(EdCodigo.Text);
    ParamByName('valor').AsFloat      := VTOTAL;
    ExecSQL();

    Close;
    SQL.Clear;
    SQL.Add('insert into produto (idp,idc,npedido,descricao,quantidade,valorun,valortotal)' +
            'select id,'+EdCodigo.Text+','+Numero_Pedido+',nome,qt,vu,vt from temp');
    ExecSQL();
    Deletar_Temp;
  End;

 Except
   on Exc:Exception do begin
    ShowMessage('Erro ao adicionar Cliente!');
   end;
 End;
   Conn.Connected := False;
end;
{$ENDREGION}

{$REGION 'SALVAR ITENS DO PEDIDO NA TABELA TEMPORARIA'}
procedure TPedidoVendas.SalvarItens(Cod,Quant:Integer;Produto:String;ValorU,Total:Real);
begin
 with QueryTemp do
 Begin
  Close;
  SQL.Clear;
  SQL.Add('INSERT INTO temp (');
  SQL.Add('id ,');
  SQL.Add('nome ,');
  SQL.Add('qt ,');
  SQL.Add('vu ,');
  SQL.Add('vt');
  SQL.Add(')VALUES (');
  SQL.Add(':id, :Produto, :Quant, :ValorU, :Total)');
  ParamByName('id').AsInteger  := Cod;
  ParamByName('Produto').AsString := Produto;
  ParamByName('Quant').AsInteger  := Quant;
  ParamByName('ValorU').AsFloat   := ValorU;
  ParamByName('Total').AsFloat    := Total;


  ExecSQL();
  Close;
  SQL.Clear;
  SQL.Add('select * from TEMP');
  Open;
  ClientDataSet1.Refresh;
 End;
end;
{$ENDREGION}



end.
