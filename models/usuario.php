<?php

require_once 'Conexion.php';

class Usuario extends Conexion{

  private $accesoBD;  //Conexión

  public function __CONSTRUCT(){
    $this->accesoBD = parent::getConexion();
  }

  public function iniciarSesion($nombreUsuario = ""){
    try{
      $consulta = $this->accesoBD->prepare("CALL spu_usuarios_login(?)");
      $consulta->execute(array($nombreUsuario));
      return $consulta->fetch(PDO::FETCH_ASSOC);
    }
    catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function registrarUsuario(){
    try{
      //1. Preparamos la consulta
      $consulta = $this->accesoBD->prepare("CALL spu_usuarios_registrar(?,?,?,?)");
      //2. Ejecutamos la consulta
      $consulta->execute(
        array(
          $datos["nombreusuario"],
          $datos["claveacceso"],
          $datos["apellidos"],
          $datos["nombres"]
        )
      );
    }
    catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function eliminarUsuario(){
    try{
      $consulta = $this->accesoBD->prepare("CALL spu_usuarios_eliminar(?)");
      $consulta->execute(array($idusuario));
    }
    catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function listarUsuario(){
    try{
      //1. Preparamos la consulta
      $consulta = $this->accesoBD->prepare("CALL spu_usuarios_mostrar()");
      //2. Ejecutamos la consulta
      $consulta->execute();
      //3. Devolvemos el resultado (array asociativo)
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    }
    catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function getCurso($idusuario = 0){
    try{
      $consulta = $this->accesoBD->prepare("CALL spu_usuarios_actualizar(?)");
      $consulta->execute(array($idusuarioso));
      //Retornar el registro encontrado
      return $consulta->fetch(PDO::FETCH_ASSOC);
    }
    catch(Exception $e){
      die($e->getMessage());
    }
  }
  
}