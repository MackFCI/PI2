<%-- 
    Document   : cadastro
    Created on : 10/10/2013, 00:44:15
    Author     : lucasesaito
--%>

<%@page import="java.sql.*"%>
<%@page import="Mackenzie.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Projeto Interdisciplinar II | Cadastro</title>
    </head>
    <body>
        <h1>Cadastro de usuário</h1>
        <%
        try{
            String cpf = "";
            Usuario usuario = null;
            if(request.getParameter("inserir") == null && request.getParameter("cpf") != null){
                cpf = request.getParameter("cpf");
                //CARREGA OS DADOS DO USUÁRIO INFORMADO
                usuario = new Usuario(cpf);
            }
            
            if(request.getParameter("inserir") != null || (request.getParameter("alterar") != null && usuario != null)){
                String msg = "";
                String botaoSubmit = "";
                
                //INICIALIZANDO AS VARIÁVEIS/CAMPOS
                String[][] campos = new String[][] {
                    //{label, tipo do campo, nome do campo, valor padrão, parâmetros html/input}
                    {"CPF", "text", "cpf", "", ""},
                    {"Nome", "text", "nome", "", ""},
                    {"Data de nascimento", "date", "dtNascimento", "", ""},
                    {"Endereço", "text", "endereco", "", ""},
                    {"Telefone", "tel", "telefone", "", ""},
                    {"E-mail", "email", "email", "", ""}
                };
                
                //VERIFICANDO AÇÃO
                if(request.getParameter("inserir") != null){ //INSERIR
                    botaoSubmit = "Inserir";
                }else if(request.getParameter("alterar") != null){ //ALTERAR
                    botaoSubmit = "Alterar";
                }
                
                //VERIFICANDO OS VALORES RECEBIDOS (POST do FORM)
                int qtdParam = 0;
                int qtdParamVazio = 0;
                for(int i=0; i<campos.length; i++){
                    if(request.getParameter(campos[i][2]) != null){
                        campos[i][3] = request.getParameter(campos[i][2]);
                        qtdParam++;
                        if(campos[i][3].equals("")){
                            qtdParamVazio++;
                        }
                    }
                }
                //System.out.print("QTD: "+qtdParam);
                if(qtdParam != campos.length){
                    if(usuario != null){
                        //INICIALIZANDO VALORES PARA O ALTERAR
                        campos[0][3] = String.valueOf(usuario.getCpf());
                        campos[0][4] = "readonly=\"readonly\"";
                        campos[1][3] = String.valueOf(usuario.getNome());
                        campos[2][3] = String.valueOf(usuario.getDtNascimento());
                        campos[3][3] = String.valueOf(usuario.getEndereco());
                        campos[4][3] = String.valueOf(usuario.getTelefone());
                        campos[5][3] = String.valueOf(usuario.getEmail());
                    }
                }else if(qtdParamVazio != 0){
                    msg = "Preencha todos os campos!";
                }else{
                    //RECUPERANDO AS INFORMAÇÕES
                    cpf = request.getParameter("cpf");
                    String nome = campos[1][3];
                    Date dtNascimento = Date.valueOf(campos[2][3]);
                    String endereco = request.getParameter("endereco");
                    String telefone = request.getParameter("telefone");
                    String email = request.getParameter("email");
                    //SALVA INFORMAÇÕES NO BANCO DE DADOS
                    if(request.getParameter("inserir") != null){ //INSERE NOVO
                        Usuario novo = new Usuario(cpf, nome, dtNascimento, endereco, telefone, email);
                    }else if(request.getParameter("alterar") != null){ //ATUALIZA AS INFO
                        usuario.setNome(nome);
                        usuario.setDtNascimento(dtNascimento);
                        usuario.setEndereco(endereco);
                        usuario.setEndereco(telefone);
                        usuario.setEndereco(email);
                        usuario.atualizar();
                    }
                    //REDIRECIONA USUÁRIO PARA PÁGINA DO USUÁRIO (DETALHES)
                    response.sendRedirect("usuario.jsp?cpf="+cpf);
                }
                %>
                <style>
                    .alinharDireita{
                        text-align: right;
                    }
                </style>
                <form method="post" action="">
                    <table>
                        <% for(int i=0; i<campos.length; i++){ %>
                            <tr>
                                <td class="alinharDireita"><%=campos[i][0]%>:</td>
                                <td><input type="<%=campos[i][1]%>" name="<%=campos[i][2]%>" value="<%=campos[i][3]%>" <%=campos[i][4]%> />
                            </tr>
                        <% } %>
                        <% if(!msg.isEmpty()){ %>
                            <tr>
                                <td colspan="2"><span style="font-weight: bold; color: red;"><%=msg%></span></td>
                            </tr>
                        <% } %>
                        <tr>
                            <td>&nbsp;</td>
                            <td><input type="submit" value="<%=botaoSubmit%>" /></td>
                        </tr>
                    </table>
                </form>
                <%
            }else if(request.getParameter("excluir") != null && usuario != null){//EXCLUIR
                usuario.excluir();
                //REDIRECIONA USUÁRIO PARA PÁGINA DE TODOS OS USUÁRIOS
                response.sendRedirect("usuario.jsp");
            }else{//NENHUMA AÇÃO
                if(usuario == null){
                    %><p><a href="?inserir">Inserir novo usuário</a><%
                    //MOSTRA TODOS OS USUÁRIOS
                    ResultSet rs = Usuario.retornaTodos();
                    if(!rs.isBeforeFirst()){
                        out.print("<p>Nenhum usuário foi encontrado!</p>");
                    }else{
                        //MOSTRA OS REGISTROS
                        %><table border="1">
                            <tr>
                                <th>CPF</th>
                                <th>Nome</th>
                                <th>Data de nascimento</th>
                                <th>Endereço</th>
                                <th>Telefone</th>
                                <th>E-mail</th>
                                <th>&nbsp;</th>
                            </tr>
                        <%
                        while(rs.next()){
                            %><tr>
                                <td><%=rs.getString("cpf")%></td>
                                <td><%=rs.getString("nome")%></td>
                                <td><%=rs.getDate("dtNascimento")%></td>
                                <td><%=rs.getString("endereco")%></td>
                                <td><%=rs.getString("telefone")%></td>
                                <td><%=rs.getString("email")%></td>
                                <td><a href="?cpf=<%=rs.getString("cpf")%>">detalhes</a></td>
                            </tr><%
                        }
                        %></table><%
                    }
                }else{
                    %><p><a href="usuario.jsp">Mostrar todos os usuários cadastrados</a><%
                    //MOSTRA OS DADOS DO USUÁRIO SELECIONADO
                    %><table border="1">
                        <tr>
                            <th>CPF</th>
                            <td><%=usuario.getCpf()%></td>
                        </tr>
                        <tr>
                            <th>Nome</th>
                            <td><%=usuario.getNome()%></td>
                        </tr>
                        <tr>
                            <th>Data de nascimento</th>
                            <td><%=usuario.getDtNascimento()%></td>
                        </tr>
                        <tr>
                            <th>Endereço</th>
                            <td><%=usuario.getEndereco()%></td>
                        </tr>
                        <tr>
                            <th>Telefone</th>
                            <td><%=usuario.getTelefone()%></td>
                        </tr>
                        <tr>
                            <th>E-mail</th>
                            <td><%=usuario.getEmail()%></td>
                        </tr>
                        <tr>
                            <th colspan="2"><a href="?alterar&cpf=<%=usuario.getCpf()%>">editar</a> | <a href="?excluir&cpf=<%=usuario.getCpf()%>">excluir</a></th>
                        </tr>
                    </table><%
                }
            }
        }catch(Exception e){
            System.out.print(e);
            out.print("<p>"+e.getMessage()+"</p>");
        }
        %>
    </body>
</html>
