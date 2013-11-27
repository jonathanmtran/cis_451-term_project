using System;
using System.Configuration;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Net;
using System.Net.Mail;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Web.Configuration;

public partial class checkout : System.Web.UI.Page
{
	Cart ShoppingCart;

    protected void Page_Load(object sender, EventArgs e)
    {
		this.ShoppingCart = new Cart();
		double tax = 0.0;

		SqlDataSource1.SelectParameters["cart_id"].DefaultValue = this.ShoppingCart.Get_Cart().ToString();
		sub_total.InnerText = "$" + this.ShoppingCart.Calculate_Subtotal();
		
		if(IsPostBack)
		{
			if(ddl_state.SelectedValue.Equals("CA")) 
			{
				tax = this.ShoppingCart.Calculate_Tax(ddl_state.SelectedValue.Trim());
				dd_tax.InnerText = "$" + tax.ToString("#.##");
			}
			else
				dd_tax.InnerText = "$0.00";
		}
		total.InnerText = "$" + (this.ShoppingCart.Calculate_Subtotal() + tax).ToString("#.##");
    }

	protected void confirm_Click(object sender, EventArgs e)
	{
		String emailAddress = tbEmailAddress.Text.Trim();

		SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connString"].ToString());
		SqlCommand cmd = new SqlCommand("INSERT INTO [orders] (last_name, first_name, address, address_2, city, state, zip, phone_number, email, shopping_cart_id) VALUES (@last_name, @first_name, @address, @address_2, @city, @state, @zip, @phone_number, @email, @shopping_cart_id); SELECT Scope_Identity();", conn);

		cmd.Parameters.AddWithValue("@last_name", tbLastname.Text);
		cmd.Parameters.AddWithValue("@first_name", tbFirstname.Text);
		cmd.Parameters.AddWithValue("@address", tbAddress1.Text);
		cmd.Parameters.AddWithValue("@address_2", tbAddress2.Text);
		cmd.Parameters.AddWithValue("@city", tbCity.Text);
		cmd.Parameters.AddWithValue("@state", ddl_state.SelectedValue);
		cmd.Parameters.AddWithValue("@zip", tbZipCode.Text);
		cmd.Parameters.AddWithValue("@phone_number", tbPhoneNumber.Text);
		cmd.Parameters.AddWithValue("@email", emailAddress);
		cmd.Parameters.AddWithValue("@shopping_cart_id", this.ShoppingCart.Get_Cart().ToString());
		
		conn.Open();
		int invoiceId = int.Parse(cmd.ExecuteScalar().ToString());
		conn.Close();

		if(!Auth_Capture(invoiceId, tbCreditCardNumber.Text, tbCreditCardExp.Text))
		{
			// Throw some kind of error message here
			int foo = -1;
		}
		else
		{
			this.Send_Email(invoiceId, emailAddress, ddl_state.SelectedValue);

			Session["invoiceId"] = invoiceId;
			Response.Redirect("receipt.aspx");
		}
	}

	protected Boolean Auth_Capture(int invoiceId, String cardNum, String expDate)
	{
		String lastName, firstName, address, state, zipCode;
		int shoppingCartId;

		SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connString"].ToString());
		
		SqlCommand cmd = new SqlCommand("SELECT * FROM [orders] WHERE order_id = @order_id", conn);
		cmd.Parameters.AddWithValue("@order_id", invoiceId);

		conn.Open();

		SqlDataReader reader = cmd.ExecuteReader();

		if(!reader.HasRows)
			return false;

		reader.Read();

		lastName = (String)reader["last_name"];
		firstName = (String)reader["first_name"];
		address = (String)reader["address"];
		state = (String)reader["state"];
		zipCode = reader["zip"].ToString();
		shoppingCartId = (int)reader["shopping_cart_id"];

		reader.Close();
		conn.Close();

		double subtotal = this.ShoppingCart.Calculate_Subtotal();
		double tax = this.ShoppingCart.Calculate_Tax(state);
		double total = subtotal + tax;

		// By default, this sample code is designed to post to our test server for
		// developer accounts: https://test.authorize.net/gateway/transact.dll
		// for real accounts (even in test mode), please make sure that you are
		// posting to: https://secure.authorize.net/gateway/transact.dll
		String post_url = "https://test.authorize.net/gateway/transact.dll";

		Dictionary<string, string> post_values = new Dictionary<string, string>();
		//the API Login ID and Transaction Key must be replaced with valid values
		post_values.Add("x_login", WebConfigurationManager.AppSettings["ApiLogin"]);
		post_values.Add("x_tran_key", WebConfigurationManager.AppSettings["TransactionKey"]);
		post_values.Add("x_delim_data", "TRUE");
		post_values.Add("x_delim_char", "|");
		post_values.Add("x_relay_response", "FALSE");

		post_values.Add("x_type", "AUTH_CAPTURE");
		post_values.Add("x_method", "CC");
		post_values.Add("x_card_num", cardNum);
		post_values.Add("x_exp_date", expDate);

		post_values.Add("x_amount", total.ToString());
		post_values.Add("x_invoice_num", invoiceId.ToString());

		post_values.Add("x_first_name", firstName);
		post_values.Add("x_last_name", lastName);
		post_values.Add("x_address", address);
		post_values.Add("x_state", state);
		post_values.Add("x_zip", zipCode);
		// Additional fields can be added here as outlined in the AIM integration
		// guide at: http://developer.authorize.net

		// This section takes the input fields and converts them to the proper format
		// for an http post.  For example: "x_login=username&x_tran_key=a1B2c3D4"
		String post_string = "";

		foreach (KeyValuePair<string, string> post_value in post_values)
		{
			post_string += post_value.Key + "=" + HttpUtility.UrlEncode(post_value.Value) + "&";
		}
		post_string = post_string.TrimEnd('&');

		// The following section provides an example of how to add line item details to
		// the post string.  Because line items may consist of multiple values with the
		// same key/name, they cannot be simply added into the above array.
		//
		// This section is commented out by default.
		/*
		string[] line_items = {
			"item1<|>golf balls<|><|>2<|>18.95<|>Y",
			"item2<|>golf bag<|>Wilson golf carry bag, red<|>1<|>39.99<|>Y",
			"item3<|>book<|>Golf for Dummies<|>1<|>21.99<|>Y"};
	
		foreach( string value in line_items )
		{
			post_string += "&x_line_item=" + HttpUtility.UrlEncode(value);
		}
		*/

		// create an HttpWebRequest object to communicate with Authorize.net
		HttpWebRequest objRequest = (HttpWebRequest)WebRequest.Create(post_url);
		objRequest.Method = "POST";
		objRequest.ContentLength = post_string.Length;
		objRequest.ContentType = "application/x-www-form-urlencoded";

		// post data is sent as a stream
		StreamWriter myWriter = null;
		myWriter = new StreamWriter(objRequest.GetRequestStream());
		myWriter.Write(post_string);
		myWriter.Close();

		// returned values are returned as a stream, then read into a string
		String post_response;
		HttpWebResponse objResponse = (HttpWebResponse)objRequest.GetResponse();
		using (StreamReader responseStream = new StreamReader(objResponse.GetResponseStream()))
		{
			post_response = responseStream.ReadToEnd();
			responseStream.Close();
		}

		// the response string is broken into an array
		// The split character specified here must match the delimiting character specified above
		Array response_array = post_response.Split('|');

		if (Int32.Parse(response_array.GetValue(0).ToString()) == 1)
		{
			Boolean result = false;

			// Update database with value 6, Transaction ID
			cmd = new SqlCommand("UPDATE [orders] SET auth_code = @auth_code WHERE order_id = @order_id", conn);
			cmd.Parameters.AddWithValue("@auth_code", response_array.GetValue(6));
			cmd.Parameters.AddWithValue("@order_id", invoiceId);

			conn.Open();

			if(cmd.ExecuteNonQuery() == 1)
				result = true;

			conn.Close();

			return result;
		}

		return false;
	}

	protected void Send_Email(int invoiceId, string emailAddress, string state)
	{
		SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connString"].ToString());
		
		SqlCommand cmd = new SqlCommand("SELECT product_name, qty, price, price * qty as total FROM [shopping_cart_items], [products] WHERE [shopping_cart_items].product_id = products.product_id AND cart_id = @cart_id", conn);
		cmd.Parameters.AddWithValue("@cart_id", this.ShoppingCart.Get_Cart().ToString());

		// Converted the code from this URL to C#
		// http://hwang.cisdept.csupomona.edu/cis451/download/emailing.txt

		SmtpClient smtpClient = new SmtpClient();
		MailMessage myMail = new MailMessage();

		myMail.From = new MailAddress(WebConfigurationManager.AppSettings["EmailFrom"]);
		myMail.To.Add(new MailAddress(emailAddress));
		myMail.Subject = "Your order receipt: Invoice #" + invoiceId;
		
		String emailBody = "<p>Here are the items in your order:</p><br />";
		
		conn.Open();
		SqlDataReader reader = cmd.ExecuteReader();

		emailBody += "<table><thead><tr><th>Product Name</th><th>Qty</th><th>Total</th></tr></thead>";
		emailBody += "<tbody>";

		while(reader.Read())
		{
			emailBody += "<tr><td>" + reader["product_name"].ToString().Trim() + "</td><td>" + reader["qty"] + "</td><td>$" + reader["total"] + "</td></tr>";
		}

		reader.Close();
		conn.Close();

		emailBody += "</tbody></table><br /><br />";

		emailBody += "<strong>Subtotal</strong>: $" + Convert.ToDecimal(this.ShoppingCart.Calculate_Subtotal()).ToString("#,##0.00") + "<br />";
		
		double tax = this.ShoppingCart.Calculate_Tax(state);

		emailBody += "<strong>Tax</strong>: $" + Convert.ToDecimal(tax).ToString("#,##0.00") + "<br />";
		emailBody += "<strong>Total</strong>: $" + Convert.ToDecimal(this.ShoppingCart.Calculate_Subtotal() + tax).ToString("#,##0.00") + "<br /><br />";

		emailBody += "Thank you for your business!";

		myMail.Body = emailBody;
		myMail.IsBodyHtml = true;

		smtpClient.Host = WebConfigurationManager.AppSettings["SMTPHost"];
		smtpClient.Port = int.Parse(WebConfigurationManager.AppSettings["SMTPPort"]);
		smtpClient.EnableSsl = true;
		smtpClient.Credentials = new NetworkCredential(WebConfigurationManager.AppSettings["SMTPUser"], WebConfigurationManager.AppSettings["SMTPPassword"]);
		smtpClient.Send(myMail);
	}
}