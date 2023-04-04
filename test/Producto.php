<?php

class Producto{

  private $tipo = "";
  private $marca = "";
  private $precio = 0.0;

  //Método para actualizar los atributos
  //SET = Asignar | escribir
  //GET = Obtener | leer
  public function setTipo($value){
    $this->tipo = $value;
  }

  public function getTipo(){
    return $this->tipo;
  }

  public function setMarca($value){
    $this->marca = $value;
  }

  public function getMarca(){
    return $this->marca;
  }

  public function setPrecio($value){
    $this->precio = $value;
  }

  public function getPrecio(){
    return $this->precio;
  }

}

//Instancia
$producto1 = new Producto();
$producto1->setTipo("Monitor");
$producto1->setMarca("Samsung");
$producto1->setPrecio(550);

echo $producto1->getTipo();
echo $producto1->getMarca();
echo $producto1->getPrecio();