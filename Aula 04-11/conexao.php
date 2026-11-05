<?php
$servidor = "localhost";
$usuario  = "root";
$senha    = "";
$banco    = "aula13";

$conexao = new mysqli($servidor, $usuario, $senha, $banco);

if ($conexao->connect_error) {
    die("Erro ao conectar no banco: " . $conexao->connect_error);
}

$conexao->set_charset("utf8mb4");
?>
