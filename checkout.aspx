<%@ Page Title="" Language="C#" MasterPageFile="~/rwm_ecommerce.master" AutoEventWireup="true" CodeFile="checkout.aspx.cs" Inherits="checkout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="default" Runat="Server">
	<div class="span12">
	<h2>Checkout Process</h2>
	<form runat="server">
	<div class="accordion" id="accordion2">
		<div class="accordion-group">
			<div class="accordion-heading">
				<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseTwo">
					STEP 1: ACCOUNT & BILLING DETAILS
				</a>
			</div>
			<div id="collapseTwo" class="accordion-body collapse in">
				<div class="accordion-inner">
						<label> Last Name:</label>
						<asp:TextBox ID="tbLastname" runat="server"></asp:TextBox>

						<label> First Name:</label>
						<asp:TextBox ID="tbFirstname" runat="server"></asp:TextBox>
					
						<label> Address 1:</label>
						<asp:TextBox ID="tbAddress1" runat="server"></asp:TextBox>
						
						<label>Address 2:</label>
						<asp:TextBox ID="tbAddress2" runat="server"></asp:TextBox>

						<label> City:</label>
						<asp:TextBox ID="tbCity" runat="server"></asp:TextBox>
					
						<label> State:</label>
						<asp:DropDownList ID="ddl_state" runat="server" CssClass="large-field" 
							AutoPostBack="True">
							<asp:ListItem Value="">--- Please Select ---</asp:ListItem>
							<asp:ListItem value="AL">Alabama</asp:ListItem>
							<asp:ListItem value="AK">Alaska</asp:ListItem>
							<asp:ListItem value="AZ">Arizona</asp:ListItem>
							<asp:ListItem value="AR">Arkansas</asp:ListItem>
							<asp:ListItem value="CA">California</asp:ListItem>
							<asp:ListItem value="CO">Colorado</asp:ListItem>
							<asp:ListItem value="CT">Connecticut</asp:ListItem>
							<asp:ListItem value="DE">Delaware</asp:ListItem>
							<asp:ListItem value="DC">District Of Columbia</asp:ListItem>
							<asp:ListItem value="FL">Florida</asp:ListItem>
							<asp:ListItem value="GA">Georgia</asp:ListItem>
							<asp:ListItem value="HI">Hawaii</asp:ListItem>
							<asp:ListItem value="ID">Idaho</asp:ListItem>
							<asp:ListItem value="IL">Illinois</asp:ListItem>
							<asp:ListItem value="IN">Indiana</asp:ListItem>
							<asp:ListItem value="IA">Iowa</asp:ListItem>
							<asp:ListItem value="KS">Kansas</asp:ListItem>
							<asp:ListItem value="KY">Kentucky</asp:ListItem>
							<asp:ListItem value="LA">Louisiana</asp:ListItem>
							<asp:ListItem value="ME">Maine</asp:ListItem>
							<asp:ListItem value="MD">Maryland</asp:ListItem>
							<asp:ListItem value="MA">Massachusetts</asp:ListItem>
							<asp:ListItem value="MI">Michigan</asp:ListItem>
							<asp:ListItem value="MN">Minnesota</asp:ListItem>
							<asp:ListItem value="MS">Mississippi</asp:ListItem>
							<asp:ListItem value="MO">Missouri</asp:ListItem>
							<asp:ListItem value="MT">Montana</asp:ListItem>
							<asp:ListItem value="NE">Nebraska</asp:ListItem>
							<asp:ListItem value="NV">Nevada</asp:ListItem>
							<asp:ListItem value="NH">New Hampshire</asp:ListItem>
							<asp:ListItem value="NJ">New Jersey</asp:ListItem>
							<asp:ListItem value="NM">New Mexico</asp:ListItem>
							<asp:ListItem value="NY">New York</asp:ListItem>
							<asp:ListItem value="NC">North Carolina</asp:ListItem>
							<asp:ListItem value="ND">North Dakota</asp:ListItem>
							<asp:ListItem value="OH">Ohio</asp:ListItem>
							<asp:ListItem value="OK">Oklahoma</asp:ListItem>
							<asp:ListItem value="OR">Oregon</asp:ListItem>
							<asp:ListItem value="PA">Pennsylvania</asp:ListItem>
							<asp:ListItem value="RI">Rhode Island</asp:ListItem>
							<asp:ListItem value="SC">South Carolina</asp:ListItem>
							<asp:ListItem value="SD">South Dakota</asp:ListItem>
							<asp:ListItem value="TN">Tennessee</asp:ListItem>
							<asp:ListItem value="TX">Texas</asp:ListItem>
							<asp:ListItem value="UT">Utah</asp:ListItem>
							<asp:ListItem value="VT">Vermont</asp:ListItem>
							<asp:ListItem value="VA">Virginia</asp:ListItem>
							<asp:ListItem value="WA">Washington</asp:ListItem>
							<asp:ListItem value="WV">West Virginia</asp:ListItem>
							<asp:ListItem value="WI">Wisconsin</asp:ListItem>
							<asp:ListItem value="WY">Wyoming</asp:ListItem>
						</asp:DropDownList>

						&nbsp;<label>Zip Code:</label>
						<asp:TextBox ID="tbZipCode" runat="server"></asp:TextBox>

						&nbsp;<label>Phone Number:</label>
						<asp:TextBox ID="tbPhoneNumber" runat="server"></asp:TextBox>

						&nbsp;<label>E-Mail Address:</label>
						<asp:TextBox ID="tbEmailAddress" runat="server"></asp:TextBox>

						<br />
						<button class="btn btn-primary" onclick="$(this).parent().parent().collapse('hide'); $('#collapseFive').collapse('show'); return false;">Continue</button>
				</div>
			</div>
		</div>

		<div class="accordion-group">
			<div class="accordion-heading">
				<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseFive">
					STEP 2: PAYMENT
				</a>
			</div>
			<div id="collapseFive" class="accordion-body collapse">
				<div class="accordion-inner">
						<label class="radio">
							<input type="radio" name="optionsRadios" id="optionsRadios1" value="credit_card" onclick="$('.credit-card').show()" checked>
							Credit Card
						</label>
						<label class="radio">
							<input type="radio" name="optionsRadios" id="optionsRadios2" value="cod" onclick="$('.credit-card').hide()">
							Cash on Delivery (COD)
						</label>
						<br />
						<div class="credit-card">
							<label>Credit Card Number</label>
							<asp:TextBox ID="tbCreditCardNumber" runat="server"></asp:TextBox>

							<label>Credit Card Type</label>
							<asp:DropDownList ID="ddlCreditCardType" runat="server">
								<asp:ListItem>--- Select one ---</asp:ListItem>
								<asp:ListItem Value="AmEx">American Express</asp:ListItem>
								<asp:ListItem Value="DC">Diners Club</asp:ListItem>
								<asp:ListItem Value="Disc">Discover</asp:ListItem>
								<asp:ListItem>JCB</asp:ListItem>
								<asp:ListItem>Visa</asp:ListItem>
							</asp:DropDownList>

							<label>&nbsp;Expiration Date (mmyy)</label>
							<asp:TextBox ID="tbCreditCardExp" runat="server" MaxLength="4" size="4" Width="100px"></asp:TextBox>
						</div>

						<button class="btn btn-primary" onclick="$(this).parent().parent().collapse('hide'); $('#collapseSix').collapse('show'); return false;">Continue</button>
				</div>

			</div>
		</div>

		<div class="accordion-group">
			<div class="accordion-heading">
				<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseSix">
					STEP 3: CONFIRM ORDER
				</a>
			</div>
			<div id="collapseSix" class="accordion-body collapse">
				<div class="accordion-inner">
					<asp:SqlDataSource ID="SqlDataSource1" runat="server" 
						ConnectionString="<%$ ConnectionStrings:connString %>" 
						SelectCommand="SELECT product_name, qty, price, price * qty as total FROM [shopping_cart_items], [products] WHERE [shopping_cart_items].product_id = products.product_id AND cart_id = @cart_id">
						<SelectParameters>
							<asp:Parameter Name="cart_id" />
						</SelectParameters>
					</asp:SqlDataSource>
					
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
					
					<dl class="dl-horizontal pull-right">
						<dt>Sub-total:</dt>
						<dd id="sub_total" runat="server"></dd>

						<dt>Tax:</dt>
						<dd id="dd_tax" runat="server">$0.00</dd>

						<dt>Total:</dt>
						<dd id="total" runat="server"></dd>
					</dl>
					<div class="clearfix"></div>

					<asp:Button ID="confirm" runat="server" Text="Confirm Order" 
						CssClass="btn btn-success pull-right" onclick="confirm_Click" />
					<br />&nbsp;
				</div>
			</div>
		</div>
	</form>
	</div>
</asp:Content>

