<%-- 
    Document   : voo
    Created on : 07/11/2013, 08:54:38
    Author     : lucasesaito
--%>

<%@page import="java.sql.*"%>
<%@page import="Mackenzie.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Projeto Interdisciplinar II | Voo</title>
    </head>
    <body>
        <h1>Voos</h1>
        <%
            try{
                int nVoo = 0;
                Voo voo = null;
                if(request.getParameter("nVoo") != null){
                    nVoo = Integer.valueOf(request.getParameter("nVoo"));
                    //CARREGA OS DADOS DO Voo INFORMADO
                    voo = new Voo(nVoo);
                }
                if(voo == null){
                    //MOSTRA TODOS OS Voos
                    ResultSet rs = Voo.retornaTodos();
                    if(!rs.isBeforeFirst()){
                        out.print("<p>Nenhum voo foi encontrado!</p>");
                    }else{
                        //MOSTRA OS REGISTROS
                        %><table border="1">
                            <tr>
                                <th>Nº do Voo</th>
                                <th>Data</th>
                                <th>Hora</th>
                                <th>Origem</th>
                                <th>Destino</th>
                                <th>Poltronas</th>
                                <th>&nbsp;</th>
                                <th>&nbsp;</th>
                            </tr>
                        <%
                        while(rs.next()){
                            Aeroporto origem = new Aeroporto(rs.getString("origem"));
                            Aeroporto destino = new Aeroporto(rs.getString("destino"));

                            %><tr>
                                <td><%=rs.getInt("nVoo")%></td>
                                <td><%=rs.getDate("data")%></td>
                                <td><%=rs.getTime("hora")%></td>
                                <td align="center" title="<%=origem.getNome()%>"><a href="aeroporto.jsp?cod=<%=origem.getCod()%>">[<%=origem.getCod()%>] <%=origem.getCidade()%></a></td>
                                <td align="center" title="<%=destino.getNome()%>"><a href="aeroporto.jsp?cod=<%=destino.getCod()%>">[<%=destino.getCod()%>] <%=destino.getCidade()%></a></td>
                                <td><%=rs.getInt("qtdPoltronas")%></td>
                                <td><a href="?nVoo=<%=rs.getInt("nVoo")%>">detalhes</a></td>
                                <td><a href="passagem.jsp?nVoo=<%=rs.getInt("nVoo")%>">Comprar passagem</a></td>
                            </tr><%
                        }
                        %></table><%
                    }
                }else{
                    %><p><a href="voo.jsp">Mostrar todos os voos cadastrados</a><%
                    //MOSTRA OS DADOS DO Voo SELECIONADO
                    %><table border="1">
                        <tr>
                            <th>Número do Voo</th>
                            <td><%=voo.getNVoo()%></td>
                        </tr>
                        <tr>
                            <th>Data</th>
                            <td><%=voo.getData()%></td>
                        </tr>
                        <tr>
                            <th>Hora</th>
                            <td><%=voo.getHora()%></td>
                        </tr>
                        <tr>
                            <th>Origem</th>
                            <td title="<%=voo.getOrigem().getNome()%>"><a href="aeroporto.jsp?cod=<%=voo.getOrigem().getCod()%>">[<%=voo.getOrigem().getCod()%>] <%=voo.getOrigem().getCidade()%></a></td>
                        </tr>
                        <tr>
                            <th>Destino</th>
                            <td title="<%=voo.getDestino().getNome()%>"><a href="aeroporto.jsp?cod=<%=voo.getDestino().getCod()%>">[<%=voo.getDestino().getCod()%>] <%=voo.getDestino().getCidade()%></td>
                        </tr>
                        <tr>
                            <th>Quantidade de poltronas</th>
                            <td><%=voo.getQtdPoltronas()%></td>
                        </tr>
                        <tr>
                            <th>Quantidade de paradas</th>
                            <td><%=voo.getQtdParadas()%></td>
                        </tr>
                        <tr>
                            <th>Duração</th>
                            <td><%=voo.getDuracao()%></td>
                        </tr>
                    </table><%
                }
            }catch(Exception e){
                System.out.print(e);
                out.print("<p>"+e.getMessage()+"</p>");
            }
        %>
    </body>
</html>
