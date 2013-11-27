using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

/// <summary>
/// Summary description for Cart
/// </summary>
public class Cart : Page
{
	private String connString;
	private SqlConnection conn;

	public Cart()
	{
		//
		// TODO: Add constructor logic here
		//
		this.connString  = ConfigurationManager.ConnectionStrings["connString"].ToString();
		this.conn = new SqlConnection(this.connString);
	}

	public int Get_Cart()
	{
		if (Session.IsNewSession)
			Session["cart_id"] = Session.SessionID;

		String session_id = (String)Session["cart_id"];
		int cart_id = 0;

		SqlCommand cmd = new SqlCommand("SELECT * FROM [shopping_carts] WHERE session_id = @session_id", this.conn);
		cmd.Parameters.AddWithValue("@session_id", session_id);
		this.conn.Open();

		SqlDataReader reader = cmd.ExecuteReader();
		if (reader.HasRows)
		{
			reader.Read();
			cart_id = (Int32)reader["cart_id"];
		}
		else
		{
			this.conn.Close();
			cmd.Parameters.Clear();

			cmd = new SqlCommand("INSERT INTO [shopping_carts] (session_id) VALUES(@session_id); SELECT Scope_Identity();", this.conn);
			cmd.Parameters.AddWithValue("@session_id", session_id);
			this.conn.Open();

			cart_id = int.Parse(cmd.ExecuteScalar().ToString());
		}

		this.conn.Close();

		return cart_id;
	}

	public double Calculate_Subtotal()
	{
		double subtotal = 0.0;

		SqlCommand cmd = new SqlCommand("SELECT COUNT(product_id) FROM [shopping_cart_items] WHERE cart_id = @cart_id", this.conn);
		cmd.Parameters.AddWithValue("@cart_id", this.Get_Cart());
		this.conn.Open();

		if (int.Parse(cmd.ExecuteScalar().ToString()) > 0)
		{
			this.conn.Close();

			cmd = new SqlCommand("SELECT SUM(price * qty) FROM [shopping_cart_items], [products] WHERE cart_id = @cart_id", this.conn);
			cmd.Parameters.AddWithValue("@cart_id", this.Get_Cart());

			this.conn.Open();

			subtotal = double.Parse(cmd.ExecuteScalar().ToString());
		}

		this.conn.Close();

		return subtotal;
	}

	public double Calculate_Tax(String state)
	{
		double tax = 0.0;
		double rate = 1;

		if(state == "CA")
			rate = 8.75;
			
		tax = this.Calculate_Subtotal() * (rate / 100);

		return tax;
	}
}