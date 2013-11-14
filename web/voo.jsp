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
        <h1>Voo</h1>
        <%
            try{
                int nVoo = 0;
                Voo voo = null;
                if(request.getParameter("nVoo") != null){
                    nVoo = Integer.valueOf(request.getParameter("nVoo"));
                    //CARREGA OS DADOS DO Voo INFORMADO
                    voo = new Voo(nVoo);
                }
                
                //BREADCRUMB
                %><p><a href="index.jsp">Início</a> > <a href="voo.jsp">Voo</a></p><%
                
                if(voo == null){
                    //MOSTRA TODOS OS Voos
                    ResultSet rs;
                    String buscaOrigem = request.getParameter("sO");
                    String buscaDestino = request.getParameter("sD");
                    if(buscaOrigem != null && buscaDestino != null){
                        rs = Voo.retornaBusca(buscaOrigem, buscaDestino);
                    }else{
                        rs = Voo.retornaTodos();
                        buscaOrigem = "";
                        buscaDestino = "";
                    }
                    
                    if(!rs.isBeforeFirst()){
                        out.print("<p>Nenhum voo foi encontrado!</p>");
                    }else{
                        //MOSTRA OS REGISTROS
                        %>
                        <form action="" method="get">
                            <table>
                                <tr>
                                    <td>Origem:</td>
                                    <td><input type="text" name="sO" value="<%=buscaOrigem%>" /></td>
                                    <td rowspan="2"><input type="submit" value="Buscar" /></td>
                                </tr>
                                <tr>
                                    <td>Destino:</td>
                                    <td><input type="text" name="sD" value="<%=buscaDestino%>" /></td>
                                </tr>
                            </table>
                        </form>
                        <br />
                        <table border="1">
                            <tr>
                                <th>Data</th>
                                <th>Hora</th>
                                <th>Origem</th>
                                <th>Destino</th>
                                <th>&nbsp;</th>
                            </tr>
                        <%
                        while(rs.next()){
                            Aeroporto origem = new Aeroporto(rs.getString("origem"));
                            Aeroporto destino = new Aeroporto(rs.getString("destino"));

                            %><tr>
                                <td><%=rs.getDate("data")%></td>
                                <td><%=rs.getTime("hora")%></td>
                                <td align="center" title="<%=origem.getNome()%>"><a href="aeroporto.jsp?cod=<%=origem.getCod()%>">[<%=origem.getCod()%>] <%=origem.getCidade()%></a></td>
                                <td align="center" title="<%=destino.getNome()%>"><a href="aeroporto.jsp?cod=<%=destino.getCod()%>">[<%=destino.getCod()%>] <%=destino.getCidade()%></a></td>
                                <td><a href="?nVoo=<%=rs.getInt("nVoo")%>">detalhes</a></td>
                            </tr><%
                        }
                        %></table><%
                    }
                }else{
                    //MOSTRA OS DADOS DO Voo SELECIONADO
                    %>
                    <style>
                        table tr th{
                            text-align: right;
                        }
                    </style>
                    <table border="1">
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
                        <tr>
                            <td colspan="2" style="text-align:center;"><a href="passagem.jsp?nVoo=<%=voo.getNVoo()%>">Comprar passagem</a></td>
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
