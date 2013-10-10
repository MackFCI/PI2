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
    Date dtNascimento;
    String endereco;
    String telefone;
    String email;

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
            this.nome = rs.getString("nome");
            this.dtNascimento = rs.getDate("dtNascimento");
            this.endereco = rs.getString("endereco");
            this.telefone = rs.getString("telefone");
            this.email = rs.getString("email");
        }
    }
    public Usuario(String cpf, String nome, Date dtNascimento, String endereco, String telefone, String email) throws Exception {
        this.cpf = cpf;
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
            ps = con.prepareStatement("INSERT INTO " + nomeTabela + " (cpf, nome, dtNascimento, endereco, telefone, email) VALUES (?, ?, ?, ?, ?, ?)");
            ps.setString(1, cpf);
            ps.setString(2, nome);
            ps.setDate(3, dtNascimento);
            ps.setString(4, endereco);
            ps.setString(5, telefone);
            ps.setString(6, email);
            ps.executeUpdate();
        }else{
            //ALUNO JÁ EXISTE
            throw new Exception("O usuário informado (CPF: "+cpf+" | Nome: "+rs.getString("nome")+") já existe!");
        }
    }
    
    //GETTERS
    public String getCpf(){
        return cpf;
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
        PreparedStatement ps = con.prepareStatement("UPDATE " + nomeTabela + " SET nome = ?, dtNascimento = ?, endereco = ?, telefone = ?, email = ? WHERE cpf = ?");
        ps.setString(1, nome);
        ps.setDate(2, dtNascimento);
        ps.setString(3, endereco);
        ps.setString(4, telefone);
        ps.setString(5, email);
        ps.setString(6, cpf);
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
