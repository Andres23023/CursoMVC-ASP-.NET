﻿using CapaEntidad;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaDatos
{
    public class CD_Cliente
    {
        public int Registrar(Cliente obj, out string Mensaje)
        {
            int idautogenerado = 0;
            Mensaje = string.Empty;
            try
            {
                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {
                    SqlCommand cmd = new SqlCommand("sp_RegistrarCliente", oconexion);
                    cmd.Parameters.AddWithValue("Nombres", obj.Nombres);
                    cmd.Parameters.AddWithValue("Apellidos", obj.Apellidos);
                    cmd.Parameters.AddWithValue("Correo", obj.Correo);
                    cmd.Parameters.AddWithValue("Clave", obj.Clave);
                    cmd.Parameters.Add("Resultado", SqlDbType.Int).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;
                    cmd.CommandType = CommandType.StoredProcedure;

                    oconexion.Open();

                    cmd.ExecuteNonQuery();

                    idautogenerado = Convert.ToInt32(cmd.Parameters["Resultado"].Value);
                    Mensaje = cmd.Parameters["Mensaje"].Value.ToString();
                }
            }
            catch (Exception ex)
            {
                idautogenerado = 0;
                Mensaje = ex.Message;
            }
            return idautogenerado;
        }

        public List<Cliente> Listar()
        {
            List<Cliente> lista = new List<Cliente>();

            try
            {
                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {
                    string query = "select IdCliente, Nombres, Apellidos, Correo, Clave, Reestablecer from Cliente";
                    SqlCommand cmd = new SqlCommand(query, oconexion);
                    cmd.CommandType = CommandType.Text;

                    oconexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lista.Add(
                                new Cliente()
                                {
                                    IdCliente = Convert.ToInt32(dr["IdCliente"]),
                                    Nombres = dr["Nombres"].ToString(),
                                    Apellidos = dr["Apellidos"].ToString(),
                                    Correo = dr["Correo"].ToString(),
                                    Clave = dr["Clave"].ToString(),
                                    Reestablecer = Convert.ToBoolean(dr["Reestablecer"])

                                }
                                );
                        }
                    }
                }
            }
            catch
            {
                lista = new List<Cliente>();
            }




            return lista;
        }

        public bool CambiarClave(int idcliente, string nuevaclave, out string Mensaje)
        {
            bool resultado = false;
            Mensaje = string.Empty;

            try
            {
                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {
                    SqlCommand cmd = new SqlCommand("update CLIENTE set Clave = @nuevaclave, Reestablecer = 0 " +
                        "where IdCliente = @id", oconexion);
                    cmd.Parameters.AddWithValue("@nuevaclave", nuevaclave);
                    cmd.Parameters.AddWithValue("@id", idcliente);
                    cmd.CommandType = CommandType.Text;
                    oconexion.Open();
                    resultado = cmd.ExecuteNonQuery() > 0 ? true : false;

                }
            }
            catch (Exception ex)
            {
                resultado = false;
                Mensaje = ex.Message;
            }
            return resultado;

        }

        public bool ReestablecerClave(int idcliente, string clave, out string Mensaje)
        {
            bool resultado = false;
            Mensaje = string.Empty;

            try
            {
                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {
                    SqlCommand cmd = new SqlCommand("update CLIENTE set Clave = @nuevaclave, Reestablecer = 1 " +
                         "where IdCliente = @id", oconexion);
                    cmd.Parameters.AddWithValue("@nuevaclave", clave);
                    cmd.Parameters.AddWithValue("@id", idcliente);
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandType = CommandType.Text;
                    oconexion.Open();
                    resultado = cmd.ExecuteNonQuery() > 0 ? true : false;

                }
            }
            catch (Exception ex)
            {
                resultado = false;
                Mensaje = ex.Message;
            }
            return resultado;

        }

    }
}
