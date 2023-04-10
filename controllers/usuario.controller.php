<?php
session_start();

require_once '../models/usuario.php';

if (isset($_POST['operacion'])){

  $usuario = new Usuario();

  //Identificando la operación...
  if ($_POST['operacion'] == 'login'){
    $registro = $usuario->iniciarSesion($_POST['nombreusuario']);
    
    $_SESSION["login"] = false;
    //objeto para contener el resultado
    $resultado = [
      "status"    =>  false,
      "mensaje"   =>  ""
    ];

    if ($registro){
      //El usuario si existe
      $claveEncriptada = $registro["claveacceso"];
      
      //Validar la contraseña
      if (password_verify($_POST['claveIngresada'], $claveEncriptada)){
        $resultado["status"] = true;
        $resultado["mensaje"] = "Bienvenidos al Sistema";
        $_SESSION["login"]  =  true;
      }else{
        $resultado["mensaje"] = "No encontramos al usuario";
      }
    }else{
      //El usuario no existe
      $resultado["mensaje"] = "No encontramos al usuario";
    }

    //Enviamos el objeto resultado a la vista 
    echo json_encode($resultado);
  }
}

if (isset($_GET['operacion'])){
  if ($_GET['operacion'] == 'finalizar'){
    session_destroy();
    session_unset();
    header('location:../index.php');
  }
}