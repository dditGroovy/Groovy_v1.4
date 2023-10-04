<%--
  Created by IntelliJ IDEA.
  User: seojukang
  Date: 2023/09/13
  Time: 9:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<p> The time on the server is ${serverTime}. </p>
<form action="/common/uploadFile" method="post" enctype="multipart/form-data">
    <input type="file" name="defaultFile">
    <button type="submit">저장</button>
</form>
</body>
</html>
