package Mackenzie;

import java.sql.*;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author 31117317
 */
public class Usuario {
    static final String nomeTabela = "usuario";
    
    String cpf;
    String nome;
    String senha;
    Date dtNascimento;
    String endereco;
    String telefone;
    String email;
    private static final String salt = "@k#ppcjrDHM<T.S6,~N=`5ko=fDNF8~2R/5yg!|i5t;M``jT_$=rE?[T,29Wb=X2";

    //CONSTRUTORES
    public Usuario(String cpf) throws Exception {
        this.cpf = cpf;
        
        Conexao banco = new Conexao();
        Connection con = banco.getCon();
        
        PreparedStatement ps = con.prepareStatement("SELECT * FROM " + nomeTabela + " WHERE cpf = ?");
        ps.setString(1, cpf);
        ResultSet rs = ps.executeQuery();
        if(!rs.next()){
            throw new Exception("Usuário não encontrado!");
        }else{
            this.cpf = rs.getString("cpf");
            this.senha = rs.getString("senha");
            this.nome = rs.getString("nome");
            this.dtNascimento = rs.getDate("dtNascimento");
            this.endereco = rs.getString("endereco");
            this.telefone = rs.getString("telefone");
            this.email = rs.getString("email");
        }
    }
    public Usuario(String cpf, String senha, String nome, Date dtNascimento, String endereco, String telefone, String email) throws Exception {
        this.cpf = cpf;
        this.senha = senha;
        this.nome = nome;
        this.dtNascimento = dtNascimento;
        this.endereco = endereco;
        this.telefone = telefone;
        this.email = email;
        
        Conexao banco = new Conexao();
        Connection con = banco.getCon();
        
        PreparedStatement ps;
        ps = con.prepareStatement("SELECT * FROM " + nomeTabela + " WHERE cpf = ?");
        ps.setString(1, cpf);
        ResultSet rs = ps.executeQuery();
        if(!rs.next()){
            //INSERIR
            ps = con.prepareStatement("INSERT INTO " + nomeTabela + " (cpf, senha, nome, dtNascimento, endereco, telefone, email) VALUES (?, MD5(CONCAT(?, ?, ?)), ?, ?, ?, ?, ?)");
            ps.setString(1, cpf);
            ps.setString(2, String.valueOf(cpf));
            ps.setString(3, salt);
            ps.setString(4, senha);
            ps.setString(5, nome);
            ps.setDate(6, dtNascimento);
            ps.setString(7, endereco);
            ps.setString(8, telefone);
            ps.setString(9, email);
            ps.executeUpdate();
        }else{
            //ALUNO JÁ EXISTE
            throw new Exception("O usuário informado (CPF: "+cpf+" | Nome: "+rs.getString("nome")+") já existe!");
        }
    }
    public Usuario(String cpf, String senha) throws Exception {
        Conexao banco = new Conexao();
        Connection con = banco.getCon();
        
        PreparedStatement ps = con.prepareStatement("SELECT * FROM usuario WHERE cpf = ? AND senha = MD5(CONCAT(cpf, ?, ?))");
        ps.setString(1, cpf);
        ps.setString(2, salt);
        ps.setString(3, senha);
        ResultSet rs = ps.executeQuery();
        if(!rs.next()){
            throw new Exception("Usuário e/ou Senha inválidos!");
        }else{
            this.cpf = rs.getString("cpf");
            this.senha = rs.getString("senha");
            this.nome = rs.getString("nome");
            this.dtNascimento = rs.getDate("dtNascimento");
            this.endereco = rs.getString("endereco");
            this.telefone = rs.getString("telefone");
            this.email = rs.getString("email");
        }
    }
    
    //GETTERS
    public String getCpf(){
        return cpf;
    }
    public String getSenha(){
        return senha;
    }
    public String getNome(){
        return nome;
    }
    public Date getDtNascimento(){
        return dtNascimento;
    }
    public String getEndereco(){
        return endereco;
    }
    public String getTelefone(){
        return telefone;
    }
    public String getEmail(){
        return email;
    }
    //SETTERS
    public void setSenha(String senha){
        this.senha = senha;
    }
    public void setNome(String nome){
        this.nome = nome;
    }
    public void setDtNascimento(Date dtNascimento){
        this.dtNascimento = dtNascimento;
    }
    public void setEndereco(String endereco){
        this.endereco = endereco;
    }
    public void setTelefone(String telefone){
        this.telefone = telefone;
    }
    public void setEmail(String email){
        this.email = email;
    }
    
    public void atualizar() throws Exception{
        Conexao banco = new Conexao();
        Connection con = banco.getCon();
        
        //INSERIR
        PreparedStatement ps = con.prepareStatement("UPDATE " + nomeTabela + " SET nome = ?, dtNascimento = ?, endereco = ?, telefone = ?, email = ?, senha = MD5(CONCAT(cpf, ?, ?)) WHERE cpf = ?");
        ps.setString(1, nome);
        ps.setDate(2, dtNascimento);
        ps.setString(3, endereco);
        ps.setString(4, telefone);
        ps.setString(5, email);
        ps.setString(6, salt);
        ps.setString(7, senha);
        ps.setString(8, cpf);
        ps.executeUpdate();
    }
    public void excluir() throws Exception{
        Conexao banco = new Conexao();
        Connection con = banco.getCon();
        
        //EXCLUIR
        PreparedStatement ps = con.prepareStatement("DELETE FROM " + nomeTabela + " WHERE cpf = ?");
        ps.setString(1, cpf);
        ps.executeUpdate();
    }
    
    static public ResultSet retornaTodos() throws Exception{
        Conexao banco = new Conexao();
        Connection con = banco.getCon();
        
        Statement s = con.createStatement();
        ResultSet rs = s.executeQuery("SELECT * FROM " + nomeTabela + "");
        
        return rs;
    }
}
