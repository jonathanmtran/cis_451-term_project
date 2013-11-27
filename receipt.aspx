<%@ Page Title="" Language="C#" MasterPageFile="~/rwm_ecommerce.master" AutoEventWireup="true" CodeFile="receipt.aspx.cs" Inherits="receipt" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="default" Runat="Server">
<div class="span12">
	<h2>Receipt</h2>

	<p>Thank you for your order. Here is a receipt for your records</p>

	<h3>[Company Name Goes Here]</h3>

	<h4>Bill To:</h4>
	<p>
		<asp:Label ID="lblName" runat="server"></asp:Label><br />
		<asp:Label ID="lblAddress" runat="server"></asp:Label><br />
		<asp:Label ID="lblCityStateZip" runat="server"></asp:Label><br />
		<asp:Label ID="lblEmailAddress" runat="server"></asp:Label>
	</p>

	<p><strong>Invoice #: </strong> <asp:Label ID="lblInvoiceId" runat="server"></asp:Label></p>

	<asp:SqlDataSource ID="SqlDataSource1" runat="server" 
			ConnectionString="<%$ ConnectionStrings:connString %>" 
			SelectCommand="SELECT [products].product_id, product_code, product_name, qty, price, qty * price AS total FROM [shopping_cart_items], [products] WHERE cart_id = @cart_id AND [products].product_id = [shopping_cart_items].product_id">
			<SelectParameters>
				<asp:Parameter Name="cart_id" Type="String" />
			</SelectParameters>
		</asp:SqlDataSource>
	
	<form runat="server">
		<asp:GridView ID="GridView1" runat="server" DataSourceID="SqlDataSource1" 
			EnableModelValidation="True" AutoGenerateColumns="False" 
			CssClass="table table-striped table-hover">
			<Columns>
				<asp:BoundField DataField="product_name" HeaderText="Product Name" 
					SortExpression="product_name" />
				<asp:BoundField DataField="qty" HeaderText="Qty" SortExpression="qty" />
				<asp:BoundField DataField="price" HeaderText="Unit Price" 
					SortExpression="price" />
				<asp:BoundField DataField="total" HeaderText="Total" ReadOnly="True" 
					SortExpression="total" />
			</Columns>
		</asp:GridView>
	</form>

	<dl class="dl-horizontal pull-right">
		<dt>Sub-total:</dt>
		<dd id="ddSubtotal" runat="server"></dd>

		<dt>Tax:</dt>
		<dd id="ddTax" runat="server">$0.00</dd>

		<dt>Total:</dt>
		<dd id="ddTotal" runat="server"></dd>
	</dl>
</div>
</asp:Content>
