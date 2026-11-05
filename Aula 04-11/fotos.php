<?php
$listagem = array();

if (is_dir("fotos")) {
    $todas = scandir("fotos");

    foreach ($todas as $nome) {
        $final = strtolower($nome);

        if ($final == "." || $final == "..") {
            continue;
        }

        if (
            str_ends_with($final, ".jpg") ||
            str_ends_with($final, ".jpeg") ||
            str_ends_with($final, ".png") ||
            str_ends_with($final, ".webp")
        ) {
            $listagem[] = array(
                "nome" => $nome,
                "dados" => base64_encode(file_get_contents("fotos/" . $nome)),
            );
        }
    }
}

echo json_encode($listagem);
?>
