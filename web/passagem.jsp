<%-- 
    Document   : passagem
    Created on : 11/11/2013, 00:53:49
    Author     : lucasesaito
--%>

<%@page import="java.net.URLEncoder"%>
<%@page import="java.sql.*"%>
<%@page import="Mackenzie.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Projeto Interdisciplinar II | Passagem</title>
    </head>
    <body>
        <h1>Passagem</h1>
        <%
            try{
                int nVoo = 0;
                Voo voo = null;
                if(request.getParameter("nVoo") != null){
                    nVoo = Integer.valueOf(request.getParameter("nVoo"));
                    voo = new Voo(nVoo);
                }
                
                int nPoltrona = 0;
                Passagem passagem = null;
                if(nVoo != 0 && request.getParameter("nPoltrona") != null){
                    nPoltrona = Integer.valueOf(request.getParameter("nPoltrona"));
                    if(request.getParameter("comprar") == null){
                        //CARREGA OS DADOS DA Passagem INFORMADA
                        passagem = new Passagem(nVoo, nPoltrona);
                    }
                }
                
                if(voo != null){
                    %>
                    <p>
                        <strong>Número do Voo:</strong> <a href="voo.jsp?nVoo=<%=voo.getNVoo()%>"><%=voo.getNVoo()%></a><br />
                        <strong>Origem:</strong> <%=voo.getOrigem().getNome()%> [<a href="aeroporto.jsp?cod=<%=voo.getOrigem().getCod()%>"><%=voo.getOrigem().getCod()%></a>]<br />
                        <strong>Destino:</strong> <%=voo.getDestino().getNome()%> [<a href="aeroporto.jsp?cod=<%=voo.getDestino().getCod()%>"><%=voo.getDestino().getCod()%></a>]<br />
                        <strong>Data:</strong> <%=voo.getData()%> - <%=voo.getHora()%>
                    </p>
                    <%
                }
                
                if(passagem != null){
                    %><p><a href="passagem.jsp">Mostrar todas as passagens cadastradas</a><%
                    //MOSTRA OS DADOS DA Passagem SELECIONADA
                    %>
                    <style>
                        table tr th{
                            text-align: right;
                        }
                    </style>
                    <table border="1">
                        <tr>
                            <th>Poltrona</th>
                            <td><%=passagem.getNPoltrona()%></td>
                        </tr>
                        <tr>
                            <th>CPF</th>
                            <td><%=passagem.getCpf()%></td>
                        </tr>
                        <tr>
                            <th>Nome do passageiro</th>
                            <td><%=passagem.getNomePassageiro()%></td>
                        </tr>
                    </table>
                    <%
                }else if(voo != null && nPoltrona != 0){
                    //COMPRAR PASSAGEM
                    
                    //AQUI O USUÁRIO DEVE ESTAR LOGADO
                    Usuario usuarioAutenticado = (Usuario) session.getAttribute("ctrl_usuario");
                    if(usuarioAutenticado == null){
                       %><p>Você deve estar autenticado para acessar esta página.</p><%
                       response.sendRedirect("login.jsp?urlToGo="+URLEncoder.encode(request.getRequestURI()+"?"+request.getQueryString(), "UTF-8"));
                    }
                    
                    String cpf = usuarioAutenticado.getCpf();
                    if(request.getParameter("btnSubmit") != null){
                        String nomePassageiro = request.getParameter("txtNomePassageiro");
                        
                        Passagem novaPassagem = new Passagem(voo.getNVoo(), nPoltrona, cpf, nomePassageiro);
                        
                        response.sendRedirect("passagem.jsp?nVoo="+voo.getNVoo()+"&nPoltrona="+nPoltrona);
                    }
                    
                    //BREADCRUMB
                    %><p><a href="index.jsp">Início</a> > <a href="passagem.jsp">Passagem</a></p><%
                    
                    %>
                    <script>
                        function validaSubmit(){
                            if(document.getElementById("ckbContrato").checked === true){
                                return true;
                            }else{
                                alert("Você deve aceitar o contrato de serviço para continuar!");
                                return false;
                            }
                        }
                    </script>
                    <style>
                        table tr th{
                            text-align: right;
                        }
                    </style>
                    <form method="post" action="?nVoo=<%=voo.getNVoo()%>&nPoltrona=<%=nPoltrona%>&comprar" onsubmit="return validaSubmit();">
                        <table>
                            <tr>
                                <th>Nome do passageiro</th>
                                <td><input type="text" name="txtNomePassageiro" value="<%=usuarioAutenticado.getNome()%>" /></td>
                            </tr>
                            <tr>
                                <th><input type="checkbox" name="ckbContrato" id="ckbContrato" /></th>
                                <td>Aceito o <a href="contrato.html" target="_blanck">contrato de serviço</a></td>
                            </tr>
                            <tr>
                                <th>&nbsp;</th>
                                <td><input type="submit" name="btnSubmit" value="Comprar passagem" /></td>
                            </tr>
                        </table>
                    </form>
                    <%
                }else if(voo != null){
                    //MOSTRA TODOS AS Poltronas disponíveis
                    if(Passagem.qtdPoltronas(nVoo) >= voo.getQtdPoltronas()){
                        out.print("<p>Não existem mais poltronas para este Voo!</p>");
                    }else{
                        //MOSTRA TODAS AS Poltronas
                        ResultSet rs = Passagem.retornaTodos(nVoo);
                        
                        //BREADCRUMB
                        %><p><a href="index.jsp">Início</a> > <a href="passagem.jsp">Passagem</a></p><%
                        
                        %>
                        <table border="1">
                            <tr>
                                <th>Poltrona</th>
                                <% for(int i=1; i<=voo.getQtdPoltronas(); i++){ %>
                                    <th><%=i%></th>
                                <% } %>
                            </tr>
                            <tr>
                                <th>Status</th>
                                <% for(int i=1; i<=voo.getQtdPoltronas(); i++){ %>
                                    <%
                                        if(Passagem.poltronaDisponivel(nVoo, i)){
                                            out.print("<td><a href=\"?nVoo="+nVoo+"&nPoltrona="+i+"&comprar\">Disponível</a></td>");
                                        }else{
                                            out.print("<td>Ocupada</td>");
                                        }
                                    %>
                                <% } %>
                            </tr>
                        </table>
                        <%
                    }
                }else{
                    //AQUI O USUÁRIO DEVE ESTAR LOGADO
                    Usuario usuarioAutenticado = (Usuario) session.getAttribute("ctrl_usuario");
                    if(usuarioAutenticado == null){
                       %><p>Você deve estar autenticado para acessar esta página.</p><%
                       response.sendRedirect("login.jsp?urlToGo="+URLEncoder.encode(request.getRequestURI()+"?"+request.getQueryString(), "UTF-8"));
                    }
                    
                    //BREADCRUMB
                    %><p><a href="index.jsp">Início</a> > <a href="passagem.jsp">Passagem</a></p><%
                    
                    //MOSTRA TODOS AS Passagens
                    ResultSet rs = Passagem.retornaTodos(usuarioAutenticado.getCpf());
                    if(!rs.isBeforeFirst()){
                        out.print("<p>Nenhuma passagem foi encontrada!</p>");
                    }else{
                        //MOSTRA OS REGISTROS
                        %><table border="1">
                            <tr>
                                <th>Data/Hora</th>
                                <th>Origem</th>
                                <th>Destino</th>
                                <th>Poltrona</th>
                                <th>&nbsp;</th>
                            </tr>
                        <%
                        while(rs.next()){
                            Voo voo2 = new Voo(rs.getInt("nVoo"));
                            %><tr>
                                <td><%=voo2.getData()%> - <%=voo2.getHora()%></td>
                                <td align="center"><%=voo2.getOrigem().getCod()%></td>
                                <td align="center"><%=voo2.getDestino().getCod()%></td>
                                <td align="center"><%=rs.getInt("nPoltrona")%></td>
                                <td><a href="?nVoo=<%=rs.getInt("nVoo")%>&nPoltrona=<%=rs.getInt("nPoltrona")%>">detalhes</a></td>
                            </tr><%
                        }
                        %></table><%
                    }
                }
            }catch(Exception e){
                System.out.print(e);
                out.print("<p>"+e.getMessage()+"</p>");
            }
        %>
    </body>
</html>
