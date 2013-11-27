<%@ Page Title="" Language="C#" MasterPageFile="~/rwm_ecommerce.master" AutoEventWireup="true" CodeFile="cart.aspx.cs" Inherits="cart" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="default" Runat="Server">
	<div class="span12">
	<h2>Shopping Cart</h2>
		<div class="alert alert-error" runat="server" id="alert" visible="False"></div>

	<asp:SqlDataSource ID="SqlDataSource1" runat="server" 
		ConnectionString="<%$ ConnectionStrings:connString %>" 
		SelectCommand="SELECT [products].product_id, product_code, product_name, qty, price, qty * price AS total FROM [shopping_cart_items], [products] WHERE cart_id = @cart_id AND [products].product_id = [shopping_cart_items].product_id">
		<SelectParameters>
			<asp:Parameter Name="cart_id" Type="String" />
		</SelectParameters>
	</asp:SqlDataSource>
	
	<form runat="server" class="table table-striped table-hover">
	<asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
		DataSourceID="SqlDataSource1" EnableModelValidation="True" 
		CssClass="table table-striped table-hover" OnRowCommand="GridView1_RowCommand" DataKeyNames="product_id">
		<Columns>
			<asp:BoundField DataField="product_id" HeaderText="Product ID" 
				SortExpression="product_id" />

			<asp:BoundField DataField="product_code" HeaderText="Product Code" 
				SortExpression="product_code" />
			
			<asp:BoundField DataField="product_name" HeaderText="Product Name" 
				SortExpression="product_name" />

			<asp:TemplateField HeaderText="Qty">
                <ItemTemplate>
                    <asp:Textbox ID="tbNewQuantity" runat="server" Text='<%# Eval("qty") %>'></asp:Textbox>
                    <asp:Button ID="btnUpdate" runat="server" CommandName="rowUpdate" Text="Update" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>"></asp:Button>
                    <asp:Button ID="btnRemove" runat="server" CommandName="rowRemove" Text="Remove" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>"></asp:Button>                                  
                </ItemTemplate>
			</asp:TemplateField>
			
			<asp:BoundField DataField="price" HeaderText="Unit Price" SortExpression="price" FooterStyle-BorderStyle="NotSet" />

			<asp:BoundField DataField="total" HeaderText="Total" SortExpression="total" />
		</Columns>
		<EmptyDataTemplate>
			You don&#39;t have any items in your shopping cart
		</EmptyDataTemplate>
	</asp:GridView>

		<dl class="dl-horizontal pull-right">
			<dt>Sub-total:</dt>
			<dd id="sub_total" runat="server">$</dd>

			<dt>Total:</dt>
			<dd id="total" runat="server">$</dd>
		</dl>
		<div class="clearfix"></div>
		<a href="checkout.aspx" class="btn btn-success pull-right">Checkout</a>
		<a href="default.aspx" class="btn btn-primary">Continue Shopping</a>
		<a href="cart.aspx?action=empty" class="btn btn-danger">Empty Cart</a>
	</form>
	</div>
</asp:Content>
