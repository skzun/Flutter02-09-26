<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="utf-8">
    <title>Aula 13 - API de textos</title>
</head>
<body>
    <h2>Salvar um texto</h2>
    <form action="salvar.php" method="post">
        <textarea name="texto" rows="3" cols="40" placeholder="Digite o texto"></textarea>
        <br><br>
        <button type="submit">Salvar</button>
    </form>

    <h2>Buscar texto maior que um id (JSON)</h2>
    <form action="texto.php" method="get">
        id: <input type="number" name="id" value="0">
        <button type="submit">Buscar</button>
    </form>
</body>
</html>
