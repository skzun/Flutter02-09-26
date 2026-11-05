<?php
include "conexao.php";

$texto = $_POST["texto"] ?? "";

if (trim($texto) == "") {
    echo "Nenhum texto foi enviado.";
    exit;
}

$sql  = "INSERT INTO textos (texto) VALUES (?)";
$stmt = $conexao->prepare($sql);
$stmt->bind_param("s", $texto);

if ($stmt->execute()) {
    echo "Texto salvo com sucesso! (id = " . $stmt->insert_id . ")";
} else {
    echo "Erro ao salvar: " . $stmt->error;
}

$stmt->close();
$conexao->close();
?>
