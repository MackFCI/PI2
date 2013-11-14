<%-- 
    Document   : aeroporto
    Created on : 07/11/2013, 09:28:12
    Author     : lucasesaito
--%>

<%@page import="java.sql.*"%>
<%@page import="Mackenzie.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Projeto Interdisciplinar II | Aeroporto</title>
    </head>
    <body>
        <h1>Aeroporto</h1>
        <%
            try{
                String cod = "";
                Aeroporto aeroporto = null;
                if(request.getParameter("cod") != null){
                    cod = request.getParameter("cod");
                    //CARREGA OS DADOS DO Aeroporto INFORMADO
                    aeroporto = new Aeroporto(cod);
                }
                
                //BREADCRUMB
                %><p><a href="index.jsp">Início</a> > <a href="voo.jsp">Voo</a> > <a href="aeroporto.jsp">Aeroporto</a></p><%
                
                if(aeroporto == null){
                    //MOSTRA TODOS OS Aeroportos
                    ResultSet rs = Aeroporto.retornaTodos();
                    if(!rs.isBeforeFirst()){
                        out.print("<p>Nenhum aeroporto foi encontrado!</p>");
                    }else{
                        //MOSTRA OS REGISTROS
                        %><table border="1">
                            <tr>
                                <th>Código</th>
                                <th>Nome</th>
                                <th>Cidade</th>
                                <th>&nbsp;</th>
                            </tr>
                        <%
                        while(rs.next()){
                            %><tr>
                                <td><%=rs.getString("codAeroporto")%></td>
                                <td><%=rs.getString("nome")%></td>
                                <td><%=rs.getString("cidade")%></td>
                                <td><a href="?cod=<%=rs.getString("codAeroporto")%>">detalhes</a></td>
                            </tr><%
                        }
                        %></table><%
                    }
                }else{
                    //MOSTRA OS DADOS DO Aeroporto SELECIONADO
                    %>
                    <style>
                        table tr th{
                            text-align: right;
                        }
                    </style>
                    <table border="1">
                        <tr>
                            <th>Código do aeroporto</th>
                            <td><%=aeroporto.getCod()%></td>
                        </tr>
                        <tr>
                            <th>Nome</th>
                            <td><%=aeroporto.getNome()%></td>
                        </tr>
                        <tr>
                            <th>Cidade</th>
                            <td><%=aeroporto.getCidade()%></td>
                        </tr>
                    </table>
                    <%
                }
            }catch(Exception e){
                System.out.print(e);
                out.print("<p>"+e.getMessage()+"</p>");
            }
        %>
    </body>
</html>
