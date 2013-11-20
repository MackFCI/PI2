<%-- 
    Document   : index
    Created on : 10/10/2013, 00:35:32
    Author     : lucasesaito
--%>

<%@page import="Mackenzie.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Projeto Interdisciplinar II | Sistema de venda de passagens</title>
    </head>
    <body>
        <h1>Sistema de venda de passagens</h1>
        <%
        Usuario usuarioAutenticado = (Usuario) session.getAttribute("ctrl_usuario");
        if(usuarioAutenticado == null){
            %>
            <p><a href="cadastro.jsp?inserir">Cadastro</a> | <a href="login.jsp">Login</a></p>
            <p><a href="voo.jsp">Consultar voos disponíveis</a></p>
            <%
        }else{
            %>
            <p>Olá <%=usuarioAutenticado.getNome()%> | <a href="login.jsp?sair">Sair</a></p>
            <p><a href="voo.jsp">Consultar voos disponíveis</a></p>
            <p><a href="passagem.jsp">Consultar passagens compradas</a></p>
            <%
        }
        %>
    </body>
</html>
