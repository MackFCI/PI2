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
public class Aeroporto {
    static final String nomeTabela = "aeroporto";
    
    String codAeroporto;
    String nome;
    String cidade;
    
    //CONSTRUTORES
    public Aeroporto(String codAeroporto) throws Exception {
        this.codAeroporto = codAeroporto;
        
        Conexao banco = new Conexao();
        Connection con = banco.getCon();
        
        PreparedStatement ps = con.prepareStatement("SELECT * FROM " + nomeTabela + " WHERE codAeroporto = ?");
        ps.setString(1, codAeroporto);
        ResultSet rs = ps.executeQuery();
        if(!rs.next()){
            throw new Exception("Aeroporto não encontrado!");
        }else{
            this.codAeroporto = rs.getString("codAeroporto");
            this.nome = rs.getString("nome");
            this.cidade = rs.getString("cidade");
        }
    }
    
    //GETTERS
    public String getCod(){
        return codAeroporto;
    }
    public String getNome(){
        return nome;
    }
    public String getCidade(){
        return cidade;
    }
    
    static public ResultSet retornaTodos() throws Exception{
        Conexao banco = new Conexao();
        Connection con = banco.getCon();
        
        Statement s = con.createStatement();
        ResultSet rs = s.executeQuery("SELECT * FROM " + nomeTabela + "");
        
        return rs;
    }
}
