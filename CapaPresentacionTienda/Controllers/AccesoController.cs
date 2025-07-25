﻿using CapaEntidad;
using CapaNegocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace CapaPresentacionTienda.Controllers
{
    public class AccesoController : Controller
    {
        // GET: Acceso
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult Registrar()
        {
            return View();
        }
        public ActionResult Reestablecer()
        {
            return View();
        }
        public ActionResult CambiarClave()
        {
            return View();
        }


        [HttpPost]
        public ActionResult Registrar(Cliente objeto)
        {
            int resultado;
            string mensaje = string.Empty;

            ViewData["Nombres"] = string.IsNullOrEmpty(objeto.Nombres) ? "" :objeto.Nombres;
            ViewData["Apellidos"] = string.IsNullOrEmpty(objeto.Apellidos) ? "" :objeto.Apellidos;
            ViewData["Correo"] = string.IsNullOrEmpty(objeto.Correo) ? "" :objeto.Correo;

            if(objeto.Clave != objeto.ConfirmarClave)
            {
                ViewBag.Error = "Las contraseñas no coinciden";
                return View();
            }
            resultado = new CN_Cliente().Registrar(objeto, out mensaje);

            if (resultado > 0)
            {
                ViewBag.Error = null;
                return RedirectToAction("Index", "Acceso");
            }
            else
            {
                ViewBag.Error = mensaje;
                return View();
            }
        }

        [HttpPost]
        public ActionResult Index(string correo,string clave)
        {
            Cliente ocliente = null;
            ocliente = new CN_Cliente().Listar().Where(item => item.Correo == correo && item.Clave == CN_Recursos.ConvertirSha256(clave)).FirstOrDefault();

            if(ocliente == null)
            {
                ViewBag.Error = "Correo o clave no son correctas";
                return View();
            }
            else
            {
                if (ocliente.Reestablecer) 
                {
                    TempData["IdCliente"] = ocliente.IdCliente;
                    return RedirectToAction("CambiarClave", "Acceso");
                }
                else
                {
                    FormsAuthentication.SetAuthCookie(ocliente.Correo, false);                  

                    Session["Cliente"] = ocliente;

                    ViewBag.Error = null;

                    return RedirectToAction("Index", "Tienda");

                }
            }
        }
        [HttpPost]
        public ActionResult Reestablecer(string correo)
        {
            Cliente ocliente= new Cliente();

            ocliente= new CN_Cliente().Listar().Where(item => item.Correo == correo).FirstOrDefault();

            if (ocliente == null)
            {
                ViewBag.Error("No se encontro un cliente relacionado a ese correo");
                return View();
            }
            else
            {
                string mensaje = string.Empty;
                bool respuesta = new CN_Cliente().ReestablecerClave(ocliente.IdCliente, correo, out mensaje);

                if (respuesta)
                {
                    ViewBag.Error = null;
                    return RedirectToAction("Index", "Acceso");
                }
                else
                {
                    ViewBag.Error = mensaje;
                    return View();
                }
            }
        }
        [HttpPost]
        public ActionResult CambiarClave(string idcliente,string claveactual,string nuevaclave,string confirmarclave)
        {
            Cliente oCliente = new Cliente();

            oCliente = new CN_Cliente().Listar().Where(u => u.IdCliente == int.Parse(idcliente)).FirstOrDefault();

            if (oCliente.Clave != CN_Recursos.ConvertirSha256(claveactual))
            {
                TempData["IdCliente"] = idcliente;
                ViewData["vclave"] = "";
                ViewBag.Error = "La contraseña actual no es correcta";
                return View();
            }
            else if (nuevaclave != confirmarclave)
            {
                TempData["IdCliente"] = idcliente;
                ViewData["vclave"] = claveactual;
                ViewBag.Error = "Las contraseñas no coinciden";
                return View();
            }
            ViewData["vclave"] = "";
            nuevaclave = CN_Recursos.ConvertirSha256(nuevaclave);
            string mensaje = string.Empty;
            bool respuesta = new CN_Cliente().CambiarClave(int.Parse(idcliente), nuevaclave, out mensaje);

            if (respuesta)
            {
                return RedirectToAction("Index");
            }
            else
            {
                TempData["IdCliente"] = idcliente;
                ViewBag.Erorr = mensaje;
                return View();
            }
        }
        public ActionResult CerrarSesion()
        {
            Session["Cliente"] = null;
            FormsAuthentication.SignOut();
            return RedirectToAction("Index", "Acceso");
        }

    }
}