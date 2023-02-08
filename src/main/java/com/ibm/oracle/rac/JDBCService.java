package com.ibm.oracle.rac;

import jakarta.ws.rs.core.MediaType;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.Statement;
import java.sql.ResultSet;

import java.security.Security;
import java.security.Provider;

import jakarta.annotation.Resource;
import jakarta.enterprise.context.RequestScoped;
import javax.sql.DataSource;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;

@Path("/jdbc")
@RequestScoped
public class JDBCService {

    public static final String nl = System.lineSeparator();
    public static final String WARNING = " -- Connection will remain in pool for 15 seconds";
    public static final String SUCCESS = "SUCCESS" + WARNING + nl;
    public static final String FAILURE = "FAILURE" + WARNING + nl;

    @Resource(lookup = "jdbc/oracle-rac")
    DataSource oracleRAC;

    private String getOutput(DataSource ds, String sql) {

        StringWriter output = new StringWriter();
        PrintWriter writer = new PrintWriter(output);

        try (Connection con = ds.getConnection(); Statement stmt = con.createStatement()) {
            ResultSet result = stmt.executeQuery(sql);
            while (result.next()) {
                if(result.getInt(1) == 1) {
                    writer.print(SUCCESS + nl);
                    break;
                } else {
                    writer.print(FAILURE + nl); 
                    writer.print("Result set did not contain 1" + nl);
                }
            }
        } catch (Throwable e) {
            writer.print(FAILURE);
            e.printStackTrace(writer);
        }
        return output.toString();
    }

    @GET
    @Path("/oracle")
    @Produces(MediaType.TEXT_PLAIN)
    public String testOracleRAC() throws Exception {
        return getOutput(oracleRAC, "SELECT 1 FROM DUAL");
    }
}
