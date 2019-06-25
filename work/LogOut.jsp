<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.util.*"%>
<%  request.setCharacterEncoding("utf-8"); %>
<%
	String username = request.getParameter("username");
	System.out.println("Log out: " + username);
	session.setAttribute(username, null);
	response.sendRedirect("SignIn.jsp");
%>