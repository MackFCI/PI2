/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Mackenzie;

/**
 *
 * @author 31117317
 */
import java.sql.*;

public class Conexao {
    private String servidor = "localhost";
    private String usuario = "root";
    //private String senha = "administrador";
    private String senha = "";
    String database = "mackenzie_pi2";
    String tabela = "usuario";
    Connection con;
    Statement s;
    
    public Conexao() throws Exception {
        String retorno = null;
        
        try{
            Class.forName("com.mysql.jdbc.Driver");

            con = DriverManager.getConnection("jdbc:mySQL://"+servidor+":3306/?useUnicode=true",usuario,senha);
        }catch(ClassNotFoundException e){
            retorno = "Classe MySQL não encontrada!";
        }catch(com.mysql.jdbc.exceptions.jdbc4.CommunicationsException e){
            retorno = "Banco de dados não encontrado!";
        }catch(SQLSyntaxErrorException e){
            switch(e.getErrorCode()){
                case 1049:
                    retorno = "Base de dados não encontrada!";
                    break;
                case 1146:
                    retorno = "Tabela não encontrada!";
                    break;
                default:
                    retorno = e.getErrorCode() + " - " + e.toString();
            }
        }catch(SQLException e){
            switch(e.getErrorCode()){
                case 1045:
                    retorno = "Usuário e/ou senha incorretos!";
                    break;
                default:
                    retorno = e.getErrorCode() + " - " + e.toString();
            }
        }
        
        if(retorno != null){
            throw new Exception(retorno);
        }else{
            this.preparaBanco();
        }
    }
    
    Connection getCon(){
        return con;
    }
    
    void preparaBanco() throws SQLException{
        PreparedStatement s;
        
        //CRIANDO O DATABASE
        try{
            s = con.prepareStatement("USE "+database);
            s.executeUpdate();
        }catch(SQLSyntaxErrorException e){
            if(e.getMessage().equals("Unknown database '"+database+"'")){
                s = con.prepareStatement("CREATE DATABASE "+database);
                s.executeUpdate();
                s = con.prepareStatement("USE "+database);
                s.executeUpdate();
            }
        }
        
        //CRIANDO A TABELA usuario
        try{
            s = con.prepareStatement("SELECT cpf, nome FROM "+tabela);
            ResultSet rs = s.executeQuery();
        }catch(SQLSyntaxErrorException e){
            if(e.getMessage().equals("Table '"+database+"."+tabela+"' doesn't exist")){
                s = con.prepareStatement("CREATE TABLE "+tabela+" (cpf varchar(11) NOT NULL, nome varchar(45) NOT NULL, endereco varchar(100), telefone varchar(15), email varchar(100), PRIMARY KEY (cpf))");
                s.executeUpdate();
            }
        }
    }
}
