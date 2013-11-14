/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Mackenzie;

import java.sql.*;

/**
 *
 * @author lucasesaito
 */
public class Passagem {
    static final String nomeTabela = "passagem";
    
    int nVoo;
    int nPoltrona;
    String cpf;
    int qtdParadas;
    int duracao;
    String nomePassageiro;
    
    //CONSTRUTORES
    public Passagem(int nVoo, int nPoltrona) throws Exception {
        this.nVoo = nVoo;
        this.nPoltrona = nPoltrona;
        
        Conexao banco = new Conexao();
        Connection con = banco.getCon();
        
        PreparedStatement ps = con.prepareStatement("SELECT * FROM " + nomeTabela + " WHERE nVoo = ? AND nPoltrona = ?");
        ps.setInt(1, nVoo);
        ps.setInt(2, nPoltrona);
        ResultSet rs = ps.executeQuery();
        if(!rs.next()){
            throw new Exception("Passagem não encontrada!");
        }else{
            this.nVoo = rs.getInt("nVoo");
            this.nPoltrona = rs.getInt("nPoltrona");
            this.cpf = rs.getString("cpf");
            this.qtdParadas = rs.getInt("qtdParadas");
            this.duracao = rs.getInt("duracao");
            this.nomePassageiro = rs.getString("nomePassageiro");
        }
    }
    public Passagem(int nVoo, int nPoltrona, String cpf, int qtdParadas, int duracao, String nomePassageiro) throws Exception {
        this.nVoo = nVoo;
        this.nPoltrona = nPoltrona;
        this.cpf = cpf;
        this.qtdParadas = qtdParadas;
        this.duracao = duracao;
        this.nomePassageiro = nomePassageiro;
        
        Conexao banco = new Conexao();
        Connection con = banco.getCon();
        
        PreparedStatement ps;
        ps = con.prepareStatement("SELECT * FROM " + nomeTabela + " WHERE nVoo = ? AND nPoltrona = ?");
        ps.setInt(1, nVoo);
        ps.setInt(2, nPoltrona);
        ResultSet rs = ps.executeQuery();
        if(!rs.next()){
            //Verificar se existe assentos
            Voo voo = new Voo(nVoo);
            if(qtdPoltronas(voo.getNVoo()) >= voo.getQtdPoltronas()){
                //Voo cheio (não há poltornas livres)
                throw new Exception("Não existem mais poltronas disponíveis para o voo: "+voo.getNVoo()+"!");
            }else if(nPoltrona > voo.getQtdPoltronas()){
                //Poltrona escolhida fora da faixa disponível
                throw new Exception("Poltrona selecionada fora do intervalo disponível (máx "+voo.getQtdPoltronas()+")!");
            }
            
            //INSERIR
            ps = con.prepareStatement("INSERT INTO " + nomeTabela + " (nVoo, nPoltrona, cpf, qtdParadas, duracao, nomePassageiro) VALUES (?, ?, ?, ?, ?, ?)");
            ps.setInt(1, nVoo);
            ps.setInt(2, nPoltrona);
            ps.setString(3, cpf);
            ps.setInt(4, qtdParadas);
            ps.setInt(5, duracao);
            ps.setString(6, nomePassageiro);
            ps.executeUpdate();
        }else{
            //Passagem JÁ EXISTE
            throw new Exception("A passagem informada (Nº do Voo: "+nVoo+" | Poltrona: "+nPoltrona+") já existe!");
        }
    }
    
    //GETTERS
    public int getNVoo(){
        return nVoo;
    }
    public int getNPoltrona(){
        return nPoltrona;
    }
    public String getCpf(){
        return cpf;
    }
    public int getQtdParadas(){
        return qtdParadas;
    }
    public int getDuracao(){
        return duracao;
    }
    public String getNomePassageiro(){
        return nomePassageiro;
    }
    
    static public ResultSet retornaTodos() throws Exception{
        Conexao banco = new Conexao();
        Connection con = banco.getCon();
        
        Statement s = con.createStatement();
        ResultSet rs = s.executeQuery("SELECT * FROM " + nomeTabela + "");
        
        return rs;
    }
    static public ResultSet retornaTodos(int nVoo) throws Exception{
        Conexao banco = new Conexao();
        Connection con = banco.getCon();
        
        PreparedStatement ps;
        ps = con.prepareStatement("SELECT * FROM " + nomeTabela + " WHERE nVoo = ?");
        ps.setInt(1, nVoo);
        ResultSet rs = ps.executeQuery();
        
        return rs;
    }
    static public ResultSet retornaTodos(String cpf) throws Exception{
        Conexao banco = new Conexao();
        Connection con = banco.getCon();
        
        PreparedStatement ps;
        ps = con.prepareStatement("SELECT * FROM " + nomeTabela + " WHERE cpf = ?");
        ps.setString(1, cpf);
        ResultSet rs = ps.executeQuery();
        
        return rs;
    }
    static public int qtdPoltronas(int nVoo) throws Exception{
        Conexao banco = new Conexao();
        Connection con = banco.getCon();
        
        PreparedStatement ps;
        ps = con.prepareStatement("SELECT COUNT(*) AS qtdPoltronas FROM " + nomeTabela + " WHERE nVoo = ?");
        ps.setInt(1, nVoo);
        ResultSet rs = ps.executeQuery();
        rs.next();
        return rs.getInt("qtdPoltronas");
    }
    static public boolean poltronaDisponivel(int nVoo, int nPoltrona) throws Exception{
        Conexao banco = new Conexao();
        Connection con = banco.getCon();
        
        PreparedStatement ps;
        ps = con.prepareStatement("SELECT COUNT(*) AS qtdPassagem FROM " + nomeTabela + " WHERE nVoo = ? AND nPoltrona = ?");
        ps.setInt(1, nVoo);
        ps.setInt(2, nPoltrona);
        ResultSet rs = ps.executeQuery();
        rs.next();
        if(rs.getInt("qtdPassagem") == 0){
           return true;
        }else{
            return false;
        }
    }
}
