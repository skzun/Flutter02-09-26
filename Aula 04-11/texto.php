<?php
include "conexao.php";

$id = isset($_REQUEST["id"]) ? intval($_REQUEST["id"]) : 0;

$sql       = "SELECT id, texto FROM textos WHERE id > $id ORDER BY id ASC LIMIT 1";
$resultado = $conexao->query($sql);

if ($resultado) {
    $linha = $resultado->fetch_assoc();

    if ($linha) {
        $linha["id"] = intval($linha["id"]); 
        echo json_encode($linha, JSON_UNESCAPED_UNICODE);
    } else {
        echo json_encode(array("id" => 0, "texto" => "Nenhum texto encontrado"));
    }
} else {
    echo json_encode(array("id" => 0, "texto" => "Erro na consulta: " . $conexao->error));
}

$conexao->close();
?>
