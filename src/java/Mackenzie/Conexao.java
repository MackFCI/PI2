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
    String tabela;
    Connection con;
    Statement s;
    
    public Conexao() throws Exception {
        String retorno = null;
        
        try{
            Class.forName("com.mysql.jdbc.Driver");

            con = DriverManager.getConnection("jdbc:mySQL://"+servidor+":3306/?useUnicode=true&characterEncoding=ISO-8859-1", usuario, senha);
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
    
    void preparaBanco() throws SQLException, Exception{
        PreparedStatement s;
        
        //CRIANDO O DATABASE
        try{
            s = con.prepareStatement("USE "+database);
            s.executeUpdate();
        }catch(SQLSyntaxErrorException e){
            if(e.getMessage().equals("Unknown database '"+database+"'")){
                s = con.prepareStatement("CREATE DATABASE "+database+" CHARACTER SET utf8 COLLATE utf8_general_ci");
                s.executeUpdate();
                s = con.prepareStatement("USE "+database);
                s.executeUpdate();
            }
        }
        
        //CRIANDO A TABELA usuario
        tabela = "usuario";
        try{
            s = con.prepareStatement("SELECT cpf, nome FROM "+tabela);
            ResultSet rs = s.executeQuery();
        }catch(SQLSyntaxErrorException e){
            if(e.getMessage().equals("Table '"+database+"."+tabela+"' doesn't exist")){
                s = con.prepareStatement("CREATE TABLE "+tabela+" (cpf varchar(11) NOT NULL, senha varchar(32), nome varchar(45) NOT NULL, dtNascimento date, endereco varchar(100), telefone varchar(15), email varchar(100), PRIMARY KEY (cpf))");
                s.executeUpdate();
            }
        }
        
        //CRIANDO A TABELA aeroporto
        tabela = "aeroporto";
        try{
            s = con.prepareStatement("SELECT codAeroporto FROM "+tabela);
            ResultSet rs = s.executeQuery();
        }catch(SQLSyntaxErrorException e){
            if(e.getMessage().equals("Table '"+database+"."+tabela+"' doesn't exist")){
                s = con.prepareStatement("CREATE TABLE "+tabela+" (codAeroporto varchar(3) NOT NULL, nome varchar(45) NOT NULL, cidade varchar(100), PRIMARY KEY (codAeroporto))");
                s.executeUpdate();
                
                //INSERINDO OS REGISTROS
                String[][] registros = new String[][] {
                    //{codAeroporto, nome, cidade}
                    {"GRU", "Cumbica", "Guarulhos - SP"},
                    {"CGO", "Congonhas", "São Paulo - SP"},
                    {"SDU", "Santos Dumont", "Rio de Janeiro - RJ"},
                    {"BSB", "Juscelino Kubitschek", "Brasília - DF"}
                };
                for(int i=0; i < registros.length; i++){
                    try{
                        s = con.prepareStatement("INSERT INTO "+tabela+" (codAeroporto, nome, cidade) VALUES ('"+registros[i][0]+"', '"+registros[i][1]+"', '"+registros[i][2]+"')");
                        s.executeUpdate();
                    }catch(SQLSyntaxErrorException e2){
                        throw new Exception(e2.getErrorCode() + " - " + e2.toString());
                    }catch(com.mysql.jdbc.exceptions.jdbc4.MySQLIntegrityConstraintViolationException e2){
                        throw new Exception("<p>Registro ["+registros[i][0]+"] já existe!</p>");
                    }
                }
            }
        }
        
        //CRIANDO A TABELA voo
        tabela = "voo";
        try{
            s = con.prepareStatement("SELECT nVoo FROM "+tabela);
            ResultSet rs = s.executeQuery();
        }catch(SQLSyntaxErrorException e){
            if(e.getMessage().equals("Table '"+database+"."+tabela+"' doesn't exist")){
                s = con.prepareStatement("CREATE TABLE "+tabela+" (nVoo int NOT NULL, data date NOT NULL, hora time NOT NULL, origem varchar(3) NOT NULL, destino varchar(3) NOT NULL, qtdPoltronas int NOT NULL, PRIMARY KEY (nVoo), FOREIGN KEY (origem) REFERENCES aeroporto(codAeroporto), FOREIGN KEY (destino) REFERENCES aeroporto(codAeroporto))");
                s.executeUpdate();
                
                //INSERINDO OS REGISTROS
                String[][] registros = new String[][] {
                    //{nVoo, data, hora, origem, destino, qtdPoltronas}
                    {"1", "2013-11-21", "08:00:00", "GRU", "SDU", "5"},
                    {"2", "2013-11-22", "09:00:00", "BSB", "CGO", "8"},
                    {"3", "2013-11-23", "10:00:00", "SDU", "GRU", "5"},
                };
                for(int i=0; i < registros.length; i++){
                    try{
                        s = con.prepareStatement("INSERT INTO "+tabela+" (nVoo, data, hora, origem, destino, qtdPoltronas) VALUES ("+registros[i][0]+", '"+registros[i][1]+"', '"+registros[i][2]+"', '"+registros[i][3]+"', '"+registros[i][4]+"', "+registros[i][5]+")");
                        s.executeUpdate();
                    }catch(SQLSyntaxErrorException e2){
                        throw new Exception(e2.getErrorCode() + " - " + e2.toString());
                    }catch(com.mysql.jdbc.exceptions.jdbc4.MySQLIntegrityConstraintViolationException e2){
                        throw new Exception("<p>Registro ["+registros[i][0]+"] já existe!</p>");
                    }
                }
            }
        }
        
        //CRIANDO A TABELA passagem
        tabela = "passagem";
        try{
            s = con.prepareStatement("SELECT nVoo, nPoltrona FROM "+tabela);
            ResultSet rs = s.executeQuery();
        }catch(SQLSyntaxErrorException e){
            if(e.getMessage().equals("Table '"+database+"."+tabela+"' doesn't exist")){
                s = con.prepareStatement("CREATE TABLE "+tabela+" (nVoo int NOT NULL, nPoltrona int NOT NULL, cpf varchar(11) NOT NULL, qtdParadas int, duracao int, nomePassageiro varchar(45), PRIMARY KEY (nVoo, nPoltrona), FOREIGN KEY (nVoo) REFERENCES voo(nVoo), FOREIGN KEY (cpf) REFERENCES usuario(cpf))");
                s.executeUpdate();
            }
        }
    }
}
