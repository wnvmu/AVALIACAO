program PedidoVenda;

uses
  Vcl.Forms,
  Pedido in 'Pedido.pas' {PedidoVendas};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TPedidoVendas, PedidoVendas);
  Application.Run;
end.
