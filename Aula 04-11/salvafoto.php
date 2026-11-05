<?php
if (!isset($_FILES["foto"])) {
    echo "Erro: nenhuma foto recebida!";
    exit;
}

$arquivo = $_FILES["foto"];

if ($arquivo["error"] != 0) {
    echo "Erro no envio!";
    exit;
}

if (!is_dir("fotos")) {
    mkdir("fotos");
}

$nome = time() . "_" . $arquivo["name"];

if (move_uploaded_file($arquivo["tmp_name"], "fotos/" . $nome)) {
    echo "Foto salva! (" . $nome . ")";
} else {
    echo "Erro ao salvar!";
}
?>
