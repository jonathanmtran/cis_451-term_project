<%@ Page Title="" Language="C#" MasterPageFile="~/rwm_ecommerce.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server"></asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="default" Runat="Server">
	<div class="container">
		<div class="row">
			<div id="SubCategories" class="span3" runat="server">
				<div class="well">
					<ul class="nav nav-list">
						<li class="nav-header">Sidebar</li>
						<% Create_Sidebar(); %>
					</ul>
				</div>
			</div>

			<div class="span<% Response.Write(SubCategories.Visible == false ? 12 : 9); %>">

			<asp:Panel ID="index" Visible="false" runat="server">
				<div class="hero-unit">
					<h1 class="">Special Offer</h1>
					<p class="">here is the best offer of the month! Do not loose it!</p>
					<p><a href="#" class="btn btn-primary btn-large">Learn more »</a></p>
				</div>

				<ul class="thumbnails">
					<li class="span3">
						<div class="thumbnail">
							<img src="holder.js/300x200" alt="">
							<div class="caption">
								<h4>Thumbnail label</h4>
								<p><strike>Euro 150,00</strike>&nbsp;Euro 100,00</p>
								<a class="btn btn-primary" href="#">View</a>
								<a class="btn btn-success" href="#">Add to Cart</a>
							</div>
						</div>
					</li>
				</ul>

				<!--<div class="pagination">
					<ul>
						<li class"disabled"><span>Prev</span></li>
						<li class"disabled"><span>1</span></li>
						<li><a href="#">2</a></li>
						<li><a href="#">3</a></li>
						<li><a href="#">4</a></li>
						<li><a href="#">5</a></li>
						<li><a href="#">Next</a></li>
					</ul>
				</div>-->
			</asp:Panel>

			<asp:Panel id="parent_category" runat="server" Visible="false">
				<div class="breadcrumbs">
					<% this.Create_Breadcrumbs(); %>
				</div>
				
				<br />

				<p>Select a sub category to see some products</p>
			</asp:Panel>

			<asp:Panel id="product_listing" runat="server" Visible="false">
				<div class="breadcrumbs">
					<% this.Create_Breadcrumbs(); %>
				</div>
				
				<br />

				<ul class="thumbnails">
					<asp:SqlDataSource ID="ProductsDS" runat="server" 
						ConnectionString="<%$ ConnectionStrings:connString %>" 
						SelectCommand="SELECT * FROM [products] WHERE ([category_id] = @category_id)">
						<SelectParameters>
							<asp:QueryStringParameter Name="category_id" QueryStringField="category" 
								Type="Int32" />
						</SelectParameters>
					</asp:SqlDataSource>
					<asp:Repeater ID="ProductsRepeater" runat="server" DataSourceID="ProductsDS">
						<ItemTemplate>
						<li class="span3">
							<div class="thumbnail">
								<img src="img/products/<%# Eval("product_code").ToString().Trim() %>.jpg" alt="">
								<div class="caption">
									<h4><%# Eval("product_name") %></h4>
									<p><%# Eval("price") %></p>
									<a class="btn btn-primary" href="./?product=<%# Eval("product_id") %>">View</a>
									<a class="btn btn-success" href="./cart.aspx?action=add&product=<%# Eval("product_id") %>">Add to Cart</a>
								</div>
							</div>
						</li>						
						</ItemTemplate>
					</asp:Repeater>
				</ul>				
			</asp:Panel>

			<asp:Panel id="product_detail" runat="server" Visible="false">
				<div class="breadcrumbs">
					<% this.Create_Breadcrumbs_From_Product(Request.QueryString["product"]); %>
				</div>
				
				<br />

				<asp:SqlDataSource ID="ProductDetailDS" runat="server" 
					ConnectionString="<%$ ConnectionStrings:connString %>" 
					SelectCommand="SELECT * FROM [products] WHERE ([product_id] = @product_id)">
					<SelectParameters>
						<asp:QueryStringParameter Name="product_id" QueryStringField="product" 
							Type="Int32" />
					</SelectParameters>
				</asp:SqlDataSource>
				<asp:Repeater ID="ProductDetailRepeater" DataSourceID="ProductDetailDS" runat="server">
				<ItemTemplate>
				<div class="row">
					<div class="span5">
						<img class="media-object" src="img/products/<%# Eval("product_code").ToString().Trim() %>.jpg" alt="" />
					</div>

					<div class="span4">
						<h4><%# Eval("product_name").ToString().Trim() %></h4>
						<h5><%# Eval("product_code").ToString().Trim() %></h5>
						<p>Sustainable squid try-hard, tousled pug freegan dolore pariatur nihil raw denim readymade whatever yr pop-up enim. Velit veniam McSweeney's whatever, next level street art brunch. Nesciunt delectus pork belly synth veniam. Velit brunch Terry Richardson anim. Occaecat butcher tousled 90's stumptown. Vinyl four loko semiotics readymade duis. Etsy Portland kitsch nihil ethical.</p>
						<h4>$<%# Eval("price").ToString().Trim() %></h4>

						<form>
							<label>
								<input type="text" id="quantity" name="quantity" value="1" class="span1" />&nbsp;Qty
							</label>
							<button class="btn btn-primary">Add to Chart</button>
						</form>
					</div>
				</div>
				</ItemTemplate>
				</asp:Repeater>
			</asp:Panel>
			</div>
		</div>
	</div>
</asp:Content>
