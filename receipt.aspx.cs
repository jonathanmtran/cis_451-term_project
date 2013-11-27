using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class receipt : System.Web.UI.Page
{
	private Cart ShoppingCart;
	private String connString = ConfigurationManager.ConnectionStrings["connString"].ToString();
	private SqlConnection conn;

    protected void Page_Load(object sender, EventArgs e)
    {
		if(Session.IsNewSession)
			Response.Redirect("default.aspx");

		if(Session["invoiceId"] == null)
			Response.Redirect("default.aspx");

		this.ShoppingCart = new Cart();
		this.conn = new SqlConnection(this.connString);
		int invoiceId = int.Parse(Session["invoiceId"].ToString().Trim());

		SqlDataSource1.SelectParameters["cart_id"].DefaultValue = this.ShoppingCart.Get_Cart().ToString();
		
		SqlCommand cmd = new SqlCommand("SELECT * FROM [orders] WHERE order_id = @order_id", this.conn);
		cmd.Parameters.AddWithValue("@order_id", invoiceId);

		this.conn.Open();

		SqlDataReader reader = cmd.ExecuteReader();

		if(!reader.HasRows)
			// Cart does not exist
			Response.Redirect("default.aspx");

		reader.Read();

		String state = reader["state"].ToString().Trim();

		lblName.Text = reader["last_name"].ToString().Trim() + ", " + reader["first_name"].ToString().Trim();
		lblAddress.Text = reader["address"].ToString().Trim();
		lblCityStateZip.Text = reader["city"].ToString().Trim() + ", " + state + " " + reader["zip"].ToString().Trim();
		lblEmailAddress.Text = reader["email"].ToString().Trim();

		lblInvoiceId.Text = invoiceId.ToString();

		double total = this.ShoppingCart.Calculate_Subtotal() + this.ShoppingCart.Calculate_Tax(state);

		ddSubtotal.InnerText = "$" + Convert.ToDecimal(this.ShoppingCart.Calculate_Subtotal()).ToString("#,##0.00");
		ddTax.InnerText = "$" + Convert.ToDecimal(this.ShoppingCart.Calculate_Tax(state)).ToString("#,##0.00");
		ddTotal.InnerText = "$" + Convert.ToDecimal(total).ToString("#,##0.00");

		Session.Abandon();
    }
}