using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page
{
	private String connString = ConfigurationManager.ConnectionStrings["connString"].ToString();
	private SqlConnection conn;

    protected void Page_Load(object sender, EventArgs e)
    {
		this.conn = new SqlConnection(this.connString);
		
		int product = 0;
		if(!String.IsNullOrEmpty(Request.QueryString["product"])) {
			product = Convert.ToInt32(Request.QueryString["product"].ToString());
			product_detail.Visible = true;
			SubCategories.Visible = true;
		}

		if(product == 0)
		{
			int category = 0;

			if(!String.IsNullOrEmpty(Request.QueryString["category"]))
				category = Convert.ToInt32(Request.QueryString["category"].ToString());

			if(category == 0) {
				index.Visible = true;
				SubCategories.Visible = false;
			}
			else {
				index.Visible = false;

				// If this category contains subcategories, let the user know that they need to pick a subcategory
				SqlCommand cmd = new SqlCommand("SELECT * FROM [categories] WHERE parent_id = " + category, this.conn);
				this.conn.Open();
				SqlDataReader reader = cmd.ExecuteReader();
			
				if(reader.HasRows)
					parent_category.Visible = true;
				else
					product_listing.Visible = true;

				reader.Close();
				this.conn.Close();
			}
		}
    }

	protected void Create_Breadcrumbs()
	{
		this.Create_Breadcrumbs(Convert.ToInt32(Request.QueryString["category"]), false);
	}

	protected void Create_Breadcrumbs_From_Product(String product)
	{
		int product_id = Convert.ToInt32(product);

		SqlCommand cmd = new SqlCommand("SELECT category_id, product_name FROM [products] WHERE product_id = " + product_id, this.conn);
		this.conn.Open();

		SqlDataReader reader = cmd.ExecuteReader();
		reader.Read();
		int category_id = Convert.ToInt32(reader["category_id"].ToString());
		String product_name = reader["product_name"].ToString();
		this.conn.Close();

		this.Create_Breadcrumbs(category_id, true);
		Response.Write(product_name);
	}

	protected void Create_Breadcrumbs(int category_id, bool hyperlink_last)
	{
		if(hyperlink_last == null)
			hyperlink_last = false;

		if(String.IsNullOrEmpty(category_id.ToString()))
			return;

		if (category_id == 0)
			return;

		List<KeyValuePair<int,string>> breadcrumbs = new List<KeyValuePair<int,string>>();
		
		SqlCommand cmd = new SqlCommand("SELECT * FROM [categories] WHERE category_id = @id", this.conn);
		cmd.Parameters.AddWithValue("@id", category_id);

		this.conn.Open();
		SqlDataReader reader = cmd.ExecuteReader();
		
		reader.Read();
		int parent_id = Convert.ToInt32(reader["parent_id"].ToString());
		breadcrumbs.Add(new KeyValuePair<int,string>(Convert.ToInt32(reader["category_id"].ToString()), reader["category_name"].ToString()));
		reader.Close();

		while(parent_id != 0)
		{
			SqlCommand catCmd = new SqlCommand("SELECT * FROM [categories] WHERE category_id = " + parent_id, this.conn);
			SqlDataReader catReader = catCmd.ExecuteReader();
			catReader.Read();

			int crumb_id = Convert.ToInt32(catReader["category_id"].ToString());
			String crumb_name = catReader["category_name"].ToString().Trim();

			breadcrumbs.Add(new KeyValuePair<int, string>(crumb_id, crumb_name));
			parent_id = Convert.ToInt32(catReader["parent_id"].ToString());

			catReader.Close();
		}

		breadcrumbs.Add(new KeyValuePair<int, string>(0, "Home"));

		for(int i = breadcrumbs.Count - 1; i > -1; i--)
		{
			if(i > 0)
			{
				String href = breadcrumbs[i].Key == 0 ? "Default.aspx" : "Default.aspx?category=" + breadcrumbs[i].Key;
				Response.Write("<a href=\"" + href + "\">" + breadcrumbs[i].Value + "</a>");
				Response.Write(" <span class=\"divider\">&raquo;</span> ");
			}
			else
			{
				if(!hyperlink_last)
					Response.Write(breadcrumbs[i].Value);				
				else
				{
					String href = breadcrumbs[i].Key == 0 ? "Default.aspx" : "Default.aspx?category=" + breadcrumbs[i].Key;
					Response.Write("<a href=\"" + href + "\">" + breadcrumbs[i].Value + "</a>");
					Response.Write(" <span class=\"divider\">&raquo;</span> ");
				}
			}
		}
	}

	protected void Create_Sidebar()
	{
		int category_id = 0;

		if(!String.IsNullOrEmpty(Request.QueryString["category"]))
			category_id = Convert.ToInt32(Request.QueryString["category"]);
		else if(!String.IsNullOrEmpty(Request.QueryString["product"]))
		{
			int product_id = Convert.ToInt32(Request.QueryString["product"]);

			SqlCommand cmd = new SqlCommand("SELECT category_id, product_name FROM [products] WHERE product_id = " + product_id, this.conn);
			this.conn.Open();

			SqlDataReader reader = cmd.ExecuteReader();
			reader.Read();
			category_id = Convert.ToInt32(reader["category_id"].ToString());
			this.conn.Close();
		}

		this.Create_Sidebar(category_id);
	}

	protected void Create_Sidebar(int category_id)
	{
		if (String.IsNullOrEmpty(category_id.ToString()))
			return;

		if (category_id == 0)
			return;

		SqlCommand cmd = new SqlCommand("SELECT * FROM [categories] WHERE category_id = " + category_id, this.conn);
		this.conn.Open();

		SqlDataReader reader = cmd.ExecuteReader();
		reader.Read();

		int parent_id = Convert.ToInt32(reader["parent_id"].ToString());
		reader.Close();
		
		if(parent_id != 0)
		{
			while(parent_id != 0)
			{
				cmd = new SqlCommand("SELECT * FROM [categories] WHERE category_id = " + parent_id, this.conn);
				reader = cmd.ExecuteReader();
				reader.Read();

				parent_id = Convert.ToInt32(reader["parent_id"].ToString());
				if(parent_id == 0)
				{
					parent_id = Convert.ToInt32(reader["category_id"].ToString());
					reader.Close();
					break;
				}

				reader.Close();
			}
		}
		else {
			cmd = new SqlCommand("SELECT * FROM [categories] WHERE parent_id = " + category_id, this.conn);
			reader = cmd.ExecuteReader();

			if(reader.HasRows)
				parent_id = category_id;
			else
				parent_id = 0;

			reader.Close();
		}

		cmd = new SqlCommand("SELECT * FROM [categories] WHERE parent_id = " + parent_id, this.conn);
		reader = cmd.ExecuteReader();
		while(reader.Read())
		{
			int cat_id = Convert.ToInt32(reader["category_id"].ToString());
			String cat_name = reader["category_name"].ToString().Trim();
			String li_class = category_id == cat_id ? " class=\"active\"" : null;

			Response.Write("<li" + li_class + "><a href=\"?category=" + cat_id + "\">" + cat_name + "</a></li>");
		}

		this.conn.Close();
	}
}
