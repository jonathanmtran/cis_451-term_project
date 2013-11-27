using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class cart : System.Web.UI.Page
{
	private Cart ShoppingCart;
	private String connString = ConfigurationManager.ConnectionStrings["connString"].ToString();
	private SqlConnection conn;

    protected void Page_Load(object sender, EventArgs e)
    {
		this.ShoppingCart = new Cart();
		this.conn = new SqlConnection(this.connString);

		string action = "";
		
		if(!String.IsNullOrEmpty(Request.QueryString["action"]))
			action = Request.QueryString["action"].Trim();

		if(action == "add")
		{
			int product_id;
			int qty;
			
			if(!int.TryParse(Request.Form["product_id"], out product_id))
			{
				alert.InnerText = "Invalid product ID";
				alert.Visible = true;
				return;
			}

			if(!int.TryParse(Request.Form["quantity"], out qty))
			{
				alert.InnerText = "Invalid quantity";
				alert.Visible = true;
				return;
			}
			
			if(qty > 0)
			{
				if(this.Add(product_id, qty))
					Response.Redirect("cart.aspx");
			}
			else {
				alert.InnerText = "Invalid quantity";
				alert.Visible = true;
			}
		}
		else if(action == "empty")
		{
			this.Empty_Cart();
			Response.Redirect("cart.aspx");
		}
		
		SqlDataSource1.SelectParameters["cart_id"].DefaultValue = ShoppingCart.Get_Cart().ToString();
		sub_total.InnerText = "$" + Convert.ToDecimal(this.ShoppingCart.Calculate_Subtotal().ToString()).ToString("#,##0.00");
		total.InnerText = "$" + Convert.ToDecimal(this.ShoppingCart.Calculate_Subtotal().ToString()).ToString("#,##0.00");
    }

	protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
	{
		// References for C# implementation,
		// - http://forums.asp.net/t/1919572.aspx
		// - http://www.codeproject.com/Tips/80964/How-to-get-Hidden-Column-Value-in-GridView
		int index = Convert.ToInt32(e.CommandArgument);
		int product_id = int.Parse(GridView1.DataKeys[index].Value.ToString());
		
		if(e.CommandName == "rowUpdate")
		{
			TextBox tbNewQuantity = (TextBox)GridView1.Rows[index].Cells[2].FindControl("tbNewQuantity");
			int qty = int.Parse(tbNewQuantity.Text);

			if(!this.Update(product_id, qty))
				Response.Write("Unable to update product quantity");
			else
				Response.Redirect("cart.aspx");
		}
		else if(e.CommandName == "rowRemove")
		{
			if(!this.Delete(product_id))
				Response.Write("Unable to remove product from cart");
			else
				Response.Redirect("cart.aspx");
		}
	}

	protected Boolean Add(int product_id, int qty) 
	{
		int cart_id = this.ShoppingCart.Get_Cart();

		SqlCommand cmd = new SqlCommand("SELECT * FROM [shopping_cart_items] WHERE cart_id = " + cart_id + " AND product_id = " + product_id, this.conn);
		this.conn.Open();

		SqlDataReader reader = cmd.ExecuteReader();
		if(reader.HasRows)
		{
			// This item already exists in the cart
			reader.Read();
			
			int new_qty = (Int32)reader["qty"] + qty;

			reader.Close();
			this.conn.Close();

			return this.Update(product_id, new_qty);
		}
		else {
			// This item doesn't exist in the cart
			this.conn.Close();

			cmd = new SqlCommand("INSERT INTO [shopping_cart_items] (cart_id, product_id, qty) VALUES (@cart_id, @product_id, @qty)", this.conn);
			cmd.Parameters.AddWithValue("@cart_id", cart_id);
			cmd.Parameters.AddWithValue("@product_id", product_id);
			cmd.Parameters.AddWithValue("@qty", qty);
			
			this.conn.Open();
			int result = cmd.ExecuteNonQuery();
			
			return result == 1;
		}
	}

	protected Boolean Update(int product_id, int qty)
	{
		int cart_id = this.ShoppingCart.Get_Cart();
		int result = 0;

		if(qty < 1)
			return this.Delete(product_id);

		SqlCommand cmd = new SqlCommand("SELECT * FROM [shopping_cart_items] WHERE cart_id = " + cart_id + " AND product_id = " + product_id, this.conn);
		this.conn.Open();

		SqlDataReader reader = cmd.ExecuteReader();
		if (reader.HasRows)
		{
			reader.Read();

			cmd = new SqlCommand("UPDATE [shopping_cart_items] SET qty = @qty WHERE cart_id = @cart_id AND product_id = @product_id", this.conn);
			cmd.Parameters.AddWithValue("@cart_id", cart_id);
			cmd.Parameters.AddWithValue("@product_id", product_id);
			cmd.Parameters.AddWithValue("@qty", qty);

			reader.Close();

			result = (Int32)cmd.ExecuteNonQuery();
		}

		return result > 0;
	}

	protected Boolean Delete(int product_id)
	{
		SqlCommand cmd = new SqlCommand("DELETE FROM [shopping_cart_items] WHERE cart_id = @cart_id AND product_id = @product_id", this.conn);
		cmd.Parameters.AddWithValue("@cart_id", this.ShoppingCart.Get_Cart());
		cmd.Parameters.AddWithValue("@product_id", product_id);

		this.conn.Open();
		
		int result = cmd.ExecuteNonQuery();

		this.conn.Close();

		return result > -1;
	}

	protected void Empty_Cart()
	{
		SqlCommand cmd = new SqlCommand("DELETE FROM [shopping_cart_items] WHERE cart_id = @cart_id", this.conn);
		cmd.Parameters.AddWithValue("@cart_id", this.ShoppingCart.Get_Cart());

		this.conn.Open();

		cmd.ExecuteNonQuery();

		this.conn.Close();
	}
}