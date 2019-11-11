<%@page import="nl.bitwalker.useragentutils.OperatingSystem"%>
<%@page import="nl.bitwalker.useragentutils.Browser"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="nl.bitwalker.useragentutils.UserAgent"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>test</title>
<script src="https://common.cnblogs.com/scripts/jquery-2.2.0.min.js"></script>
<script type="text/javascript">
	function change(){
		document.getElementById("main").innerHTML="已经领取过优惠券，此页面不可用";
	}
	function pushHistory() {
		var state = {
			title: "title",
			url: "#"
		};
		window.history.pushState(state, "title", "#");
	}
	function iframeOnload(){
		pushHistory();
		changeFrameHeight();
	}
	function changeFrameHeight(){
	    var ifm= document.getElementById("ifd"); 
	    ifm.height=document.documentElement.clientHeight;
	}
	window.addEventListener("popstate", function(e) {
    	pushHistory();   	
    	history.go(1);
	}, false);
	window.onresize=function(){  
	     changeFrameHeight();  
	}
</script>
	</head>
	<body>
		<div id="main">
			<%
				session.setAttribute("time", "1");
				String name=request.getParameter("name");
				//获取浏览器信息
				String ua = request.getHeader("User-Agent");
				boolean isQQ=ua.matches(".*MQQBrowser.*");
				//boolean isQQ=true;
				Class.forName("com.mysql.cj.jdbc.Driver");
				Connection connection=DriverManager.getConnection("jdbc:mysql:///abslink?serverTimezone=Asia/Shanghai","root","627475");
				PreparedStatement statementDel=connection.prepareStatement("delete from name where name=?");
				PreparedStatement statement=connection.prepareStatement("select count(1) from name where name=?");
				statement.setString(1, name);
				ResultSet rs=statement.executeQuery();
				rs.next();
				if(!isQQ){
					out.println("请使用QQ浏览器登录。");
				}
				else if(rs.getInt(1)>0&&name!=null&&isQQ){
					statementDel.setString(1, name);
					statementDel.execute();
					out.println("<iframe id='ifd' src='https://m.tb.cn/h.eH8ll19?sm=0875c2' width='100%' onload='iframeOnload()' scrolling='no' frameborder='0'></iframe>");
					//https://m.tb.cn/h.eokRB0C?sm=b6b0b6
					/* String site = new String("https://m.tb.cn/h.eokRB0C?sm=b6b0b6");
				    response.setStatus(response.SC_MOVED_TEMPORARILY);
				    response.setHeader("Location", site); */
				}
				else{
					out.println("已经获取过优惠券，该链接不可用");
				}
			%>
		</div>
	</body>
</html>