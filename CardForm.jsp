<%@ page import="java.sql.*"%>
<%@ page import="java.string.*"%>
<head>

    <title>Flick It Up!</title>
    <link rel="icon" type="image/png" href="https://pics.freeicons.io/uploads/icons/png/19348469091553508380-512.png">

<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
body {
  margin: 0;
  font-family: Arial, Helvetica, sans-serif;
}

.topnav {
  overflow: hidden;
  background-color: transparent;
}

.topnav a {
  float: left;
  color: #f2f2f2;
  text-align: center;
  padding: 14px 16px;
  text-decoration: none;
  font-size: 17px;
}

.topnav a:hover {
  background-color: #ddd;
  color: black;
}

.topnav a.active {
  background-color: #04AA6D;
  color: white;
}
<%@include file="css/home.css"%>
</style>



</head>
<body style="background-color:#b14e59;">

<div class="topnav">
  <a  href="home.jsp">Home</a>
  <a href="favorite.jsp">Favorites</a>
  <a class="active" href="accountPage.jsp">Account</a>
</div>
<br>
    <%

      if (session.getAttribute("accountID")==null){
        %>
          <h1>ERROR, You do not seem to be login</h1>
        <%
      }else{
        int accountID = (Integer)session.getAttribute("accountID");
    %>
    <div>
      <form>
        <table>
          <thead>
            <th>Card Number</th>
            <th>Name</th>
            <th>CVV</th>
            <th>Expiration Date</th>
            <th>Zip Code</th>
          </thead>
          <tbody>
            <tr>
              <td><input type = "text" name = "cardNum"></td>
              <td><input type = "text" name = "name"></td>
              <td><input type = "text" name = "code"></td>
              <td><input type = "text" name = "date"></td>
              <td><input type = "text" name = "zip"></td>
            </tr>
          </tbody>
        </table>
        <input type="submit" value="Add Card" name="add">
      </form>
    </div>
    <%
    String user = "appdb";
    String password = "password";
    java.sql.Connection con;
    PreparedStatement pstatement = null;

    String sign = request.getParameter("add");
    if(sign!=null){
      int codeI=0;
      int zipI=0;
      int updateQuery = 0;
      String cardNumber = request.getParameter("cardNum");
      String name = request.getParameter("name");
      String cvv = request.getParameter("code");
      String date = request.getParameter("date");
      String zip = request.getParameter("zip");

      if (cvv != null && zip != null){
        codeI = Integer.parseInt(cvv);
        zipI = Integer.parseInt(zip);
      }

      try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/CS157A_Proj?autoReconnect=true&useSSL=false",user, password);
        String queryString = "INSERT INTO payment VALUES (?,?,?,?,?,?)";
        String deleteQuery = "DELETE FROM payment WHERE account_id = "+accountID;
        Statement stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
        stmt.executeUpdate(deleteQuery);
        pstatement = con.prepareStatement(queryString);
        pstatement.setInt(1,accountID);
        pstatement.setString(2, name);
        pstatement.setString(3, cardNumber);
        pstatement.setInt(4,codeI);
        pstatement.setString(5,date);
        pstatement.setInt(6,zipI);
        updateQuery = pstatement.executeUpdate();
        if (updateQuery != 0){
          response.sendRedirect("addUser.jsp");
        } else {
          out.println("error processing the form");
        }

      } catch(SQLException e) {
          out.println("SQLException caught: " + e.getMessage());
      }
  }
}

    %>
