<%-- 
    Document   : login
    Created on : 13/11/2013, 08:56:23
    Author     : lucasesaito
--%>

<%@page import="Mackenzie.*"%>
<%
    String txtUsuario = request.getParameter("txtUsuario");
    String txtSenha = request.getParameter("txtSenha");
    String msg = "";
    Usuario usuarioAutenticado = null;
    
    try{
        if(txtUsuario != null && txtSenha != null){
            usuarioAutenticado = new Usuario(txtUsuario, txtSenha);
            session.setAttribute("ctrl_usuario", usuarioAutenticado);
        }else{
            txtUsuario = "";
            txtSenha = "";
        }
    }catch(Exception e){
        msg = e.getMessage();
    }
    
    //URLTOGO
    String urlToGo = "";
    if(request.getParameter("urlToGo") != null){
        urlToGo = request.getParameter("urlToGo");
    }
    
    //LOGOUT
    if(request.getParameter("sair") != null){
        session.setAttribute("ctrl_usuario", null);
        response.sendRedirect("index.jsp");
    }
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Projeto Interdisciplinar II | Login</title>
    </head>
    <body>
        <h1>Login</h1>
        <p><a href="index.jsp">Início</a> > <a href="login.jsp">Login</a></p>
        <%
        usuarioAutenticado = (Usuario) session.getAttribute("ctrl_usuario");
        if(usuarioAutenticado == null){
            %>
            <style>
                .alinharDireita{
                    text-align: right;
                }
            </style>
            <form action="" method="post">
                <input type="hidden" name="urlToGo" value="<%=urlToGo%>" />
                <table>
                    <tr>
                        <td class="alinharDireita">CPF:</td>
                        <td><input type="text" name="txtUsuario" id="txtUsuario" value="<%=txtUsuario%>" /></td>
                    </tr>
                    <tr>
                        <td class="alinharDireita">Senha:</td>
                        <td><input type="password" name="txtSenha" /></td>
                    </tr>
                    <% if(!msg.isEmpty()){ %>
                        <tr>
                            <td colspan="2"><span style="font-weight: bold; color: red;"><%=msg%></span></td>
                        </tr>
                    <% } %>
                    <tr>
                        <td>&nbsp;</td>
                        <td><input type="submit" value="Login" /></td>
                    </tr>
                </table>
            </form>
            <script>document.getElementById('txtUsuario').focus();</script>
            <%
        }else{ //USUÁRIO AUTENTICADO
            if(!urlToGo.isEmpty()){
                response.sendRedirect(urlToGo);
            }else{
                response.sendRedirect("index.jsp");
            }
        }
        %>
    </body>
</html>
