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
public class Voo {
    static final String nomeTabela = "voo";
    
    int nVoo;
    Date data;
    Time hora;
    Aeroporto origem;
    Aeroporto destino;
    int qtdPoltronas;
    int qtdParadas;
    int duracao;
    
    //CONSTRUTORES
    public Voo(int nVoo) throws Exception {
        this.nVoo = nVoo;
        
        Conexao banco = new Conexao();
        Connection con = banco.getCon();
        
        PreparedStatement ps = con.prepareStatement("SELECT * FROM " + nomeTabela + " WHERE nVoo = ?");
        ps.setInt(1, nVoo);
        ResultSet rs = ps.executeQuery();
        if(!rs.next()){
            throw new Exception("Voo não encontrado!");
        }else{
            this.nVoo = rs.getInt("nVoo");
            this.data = rs.getDate("data");
            this.hora = rs.getTime("hora");
            this.origem = new Aeroporto(rs.getString("origem"));
            this.destino = new Aeroporto(rs.getString("destino"));
            this.qtdPoltronas = rs.getInt("qtdPoltronas");
            this.qtdParadas = rs.getInt("qtdParadas");
            this.duracao = rs.getInt("duracao");
        }
    }
    
    //GETTERS
    public int getNVoo(){
        return nVoo;
    }
    public Date getData(){
        return data;
    }
    public Time getHora(){
        return hora;
    }
    public Aeroporto getOrigem(){
        return origem;
    }
    public Aeroporto getDestino(){
        return destino;
    }
    public int getQtdPoltronas(){
        return qtdPoltronas;
    }
    public int getQtdParadas(){
        return qtdParadas;
    }
    public int getDuracao(){
        return duracao;
    }
    
    static public ResultSet retornaTodos() throws Exception{
        Conexao banco = new Conexao();
        Connection con = banco.getCon();
        
        Statement s = con.createStatement();
        ResultSet rs = s.executeQuery("SELECT * FROM " + nomeTabela + "");
        
        return rs;
    }
}
